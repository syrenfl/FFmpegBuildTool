#! /usr/bin/env bash

RED='\033[0;31m'
Green='\033[0;33m'
NC='\033[0m' # No Color

TARGET=$1

UPSTREAM=https://github.com/FFmpeg/FFmpeg.git
VERSION=4.1
BRANCH=origin/release/$VERSION
LOCAL_REPO=repository/ffmpeg-$VERSION

# http://www.runoob.com/linux/linux-comm-set.html
# set指令能设置所使用shell的执行方式，可依照不同的需求来做设置
# -e 　若指令传回值不等于0，则立即退出shell。

set -e

git --version

function pull_repository()
{
    echo "--------------------"
    echo -e "${RED}[*] pull ffmpeg ($UPSTREAM) base branch $BRANCH ${NC}"
    echo "--------------------"
    
    # if [ -d repository/ffmpeg-${VERSION} ]; then
    #     rm -rf ./repository/ffmpeg-$VERSION
    # fi
    
    sh tools/pull-repo-base.sh $UPSTREAM $LOCAL_REPO
}

function pull_fork()
{
    echo ""
    echo "--------------------"
    echo -e "${RED}[*] pull ffmpeg fork ffmpeg-$1 ${NC}"
    echo "--------------------"
    
    if [[ -d android/ffmpeg-$1 ]]; then
        rm -rf android/ffmpeg-$1
    fi
    
    sh tools/pull-repo-ref.sh $UPSTREAM android/ffmpeg-$1 ${LOCAL_REPO}
    cd android/ffmpeg-$1
    git checkout -b build_tools ${BRANCH}
    cd -
}

echo_usage() {
    echo "Usage:"
    echo "  init-android-ffmpeg.sh all|armv7a|armv8a|x86|x86_64"
    echo "  init-android-ffmpeg.sh clean"
    exit 1
}

case "$TARGET" in
    all)
        pull_repository
        pull_fork "armv7a"
        pull_fork "armv8a"
        pull_fork "x86"
        pull_fork "x86_64"
        echo "init complete"
    ;;
    armv7a)
        pull_repository
        pull_fork "armv7a"
        echo "init complete"
    ;;
    armv8a)
        pull_repository
        pull_fork "armv8a"
        echo "init complete"
    ;;
    x86)
        pull_repository
        pull_fork "x86"
        echo "init complete"
    ;;
    x86_64)
        pull_repository
        pull_fork "x86_64"
        echo "init complete"
    ;;
    clean)
        ACT_ARCHS_ALL="armv7a armv8a x86 x86_64"
        for ARCH in $ACT_ARCHS_ALL
        do
            if [[ -d android/ffmpeg-$ARCH ]]; then
                echo "rm android/ffmpeg-$ARCH"
                rm -rf android/ffmpeg-$ARCH
            fi
        done
        echo "clean complete"
    ;;
    *)
        echo_usage
        exit 1
    ;;
esac

echo "--------------------"
echo -e "${RED}[*] Finish pull ffmpeg ${NC}"
echo "--------------------"