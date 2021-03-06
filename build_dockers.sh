#!/usr/bin/env bash

set -x

PREFERED_BUILD=alpine

echo "Make sure your Docker environment has been set"

SOURCE_DIR=`dirname ${BASH_SOURCE[0]}`

pushd src

VERSION=`python -c 'import canari; print canari.__version__'`

if [ -n "$CIRCLE_TAG" ]; then
    VERSION="${CIRCLE_TAG#*v}"
fi;

popd

echo $SOURCE_DIR

pushd $SOURCE_DIR

for i in Docker*; do
    docker build --rm=false -t "redcanari/canari:$VERSION-${i#*-}" -f $i .
done


docker tag redcanari/canari:$VERSION-$PREFERED_BUILD redcanari/canari

if [ "$1" = "push" ]; then
    docker push redcanari/canari
fi;

popd
