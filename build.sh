#/bin/bash

# only proceed script when started not by pull request (PR)
if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  echo "this is PR, exiting"
  exit 0
fi

# enable error reporting to the console
set -e

# build site with middleman, by default to `build' folder
bundle exec middleman build

# cleanup
#rm -rf ../ovirt-stg.gh-pages

#clone `master' branch of the repository using encrypted GH_TOKEN for authentification
git clone https://${GH_TOKEN}@github.com/jasonbrooks/ovirt-stg.git ../ovirt-stg.gh-pages

# copy generated HTML site to `master' branch
cp -R build/* ../ovirt-stg.gh-pages

# commit and push generated content to `master' branch
# since repository was cloned in write mode with token auth - we can push there
cd ../ovirt-stg.gh-pages
git config user.email "jason@sealrock.net"
git config user.name "Jason Brooks"
git add -A .
git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
git push --quiet origin master > /dev/null 2>&1
