Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab2IYTk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 15:40:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46821 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab2IYTkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 15:40:23 -0400
Date: Tue, 25 Sep 2012 12:40:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org
Subject: Re: ktest.pl always returns 0?
Message-ID: <20120925194019.GA25626@kroah.com>
References: <20120925180028.GA22896@kroah.com>
 <1348596917.6786.12.camel@fedora>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <1348596917.6786.12.camel@fedora>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 25, 2012 at 02:15:17PM -0400, Steven Rostedt wrote:
> On Tue, 2012-09-25 at 11:00 -0700, Greg KH wrote:
> > Hi Steven,
> 
> Note, emailing my RH account is hit or miss. If I'm traveling I don't
> read it, and I wont return messages until I'm back. It's best to email
> my rostedt@goodmis.org account, as I have better access to that account.
> I author my patches by the email of the people that pay me to write
> them. This isn't for your "who wrote the kernel" scripts. This is for
> anyone that happens to do a git log.

Hey, it's not my fault your employer has a crummy email system that
can't handle remote access well, I just went off of the Author: line in
your ktest.pl kernel commits :)

> > I'm trying to use ktest to do build tests of the stable patch series to
> > verify I didn't mess anything up, but I'm finding that ktest always
> > returns 0 when finished, no matter if the build test was successful or
> > failed.
> 
> Hmm, I should fix that. Yeah, I agree, if it fails a test it should
> return something other than zero. But I think that only happens if you
> have DIE_ON_FAILURE = 0. As IIRC, the perl "die" command should exit the
> application with an error code.
> 
> But yeah, I agree, if one of the tests fail, the error code should not
> be zero. I'll write up a patch to fix that. Or at least add an option to
> make that happen.

That would be great.

> > Is this right?  Is there some other way to determine if ktest fails
> > other than greping the output log?
> 
> If you have DIE_ON_FAILURE = 1 (default) it should exit with non zero.

It doesn't do that, test it and see (this is with what is in Linus's
3.6-rc7 tree, I didn't test linux-next if that is newer, my apologies.)

> > Oh, and any hints on kicking off a ktest process on a remote machine in
> > a "simple" way?  I'm just using ssh to copy over a script that runs
> > there, wrapping ktest.pl up with other stuff, I didn't miss the fact
> > that ktest itself can run remotely already, did I?
> 
> I'm a little confused by this question. Do you want a server ktest? That
> is, have a ktest daemon that listens for clients that sends it config
> files and then runs them? That would actually be a fun project ;-)
> 
> You're not running ktest on the target machine are you? The way I use it
> is the following:
> 
> I have a server that I ssh to and run ktest from. It does all the builds
> there on the server and this server has a means to monitor some target.
> I use ttywatch that connects to the serial of the target, in which ktest
> uses to read from.
> 
> Sometimes this "server" is the machine I'm logged in to.  And I just run
> ktest directly.
> 
> Can you explain more of what you are looking for?

I want to be able to say:
	- take this set of stable patches and go run a 'make
	  allmodconfig' build on a remote machine and email me back the
	  answer because I might not be able to keep an internet
	  connection open for the next 5-15 minutes it might take to
	  complete that task.

I don't do boot tests with these kernel build tests, although sometime
in the future it would be nice to do that.  Right now I do that testing
manually, as it's pretty infrequent (once per release usually.)

So yes, a 'ktest' server would be nice.  I've attached the (horrible)
script below that I'm using for this so far.  It seems to work well, and
I can do builds on a "cloud" server as well as my local build server
just fine, only thing needed to do is change the user and machine name
in the script.

I know ktest doesn't handle quilt patches yet, which is why I apply them
"by hand" now to a given git tree branch, if you ever do add that
option, I'll gladly test it out and change my script to use whatever
format it needs.

thanks,

greg k-h

--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=ts

#!/bin/bash
#
# Testing script to take a stable kernel patch set, build it on a remote
# machine using ktest, and email back the results.
#
# Copyright 2012 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
#
# Released under the GPLv2 only.
#
#
# Some variables you might want to mess with are:
#
# EMAIL: who to send the email to
# REMOTE_STABLE_GIT: on the remote machine, where the linux-stable git tree is located
# REMOTE_WORK: on the remote machine, what temporary location we can use to create a subdirectory and do our work in
# REMOTE_SERVER: the remote machine name
# REMOTE_USER: the username to run the script on the remote machine
# LOCAL_WORK: temporay location on the local machine to create some files before we copy them to the remote machine
# LOCAL_KTEST: local location of a version of ktest.pl that you want to run remotely (usually better than the version in the stable tree under testing due to age issues.)
# QUEUE_DIR: local location of the stable-queue git tree we are wanting to test


EMAIL="greg@kroah.com"

REMOTE_STABLE_GIT="/home/gregkh/linux/stable/linux-stable/"
REMOTE_WORK="/home/gregkh/tmp/"
REMOTE_SERVER="build"
REMOTE_USER="gregkh"

LOCAL_WORK="/tmp/"
LOCAL_KTEST="/home/gregkh/linux/gregkh/tools/testing/ktest/ktest.pl"
QUEUE_DIR="/home/gregkh/linux/stable/stable-queue/"

#######################################################
# I doubt you need to touch anything below this line,
# unless you want to fix my bugs, or rewrite the scripts
# to be saner (hint, feel free to do so...)
#######################################################


# grab the kernel version from the command line
KERNEL_VERSION="$1"

if [ "${KERNEL_VERSION}" == "" ] ; then
	echo "$0 KERNEL_VERSION"
	exit;
fi

# create the local temporary directory to do the work in.
SCRIPT_HOME=`mktemp -d ${LOCAL_WORK}/stable_test_XXXXX`
echo "Using ${SCRIPT_HOME} for our local files"

# create the remote directory
REMOTE_DIR=`ssh ${REMOTE_USER}@${REMOTE_SERVER} mktemp -d ${REMOTE_WORK}/stable_test_XXXXX`
echo "Using ${REMOTE_DIR} for the remote directory"


# tar up stable patch queue for just this kernel version
cd ${QUEUE_DIR}/queue-${KERNEL_VERSION}/
tar -c . | gzip > ${SCRIPT_HOME}/stable_queue.tar.gz

# create the script to run remotely

cat << __EOF__ > ${SCRIPT_HOME}/run_test.sh
#!/bin/bash
# Test script for the ${KERNEL_VERSION}-stable kernel
# autogenerated, do not edit by hand
#
STABLE_GIT="${REMOTE_STABLE_GIT}"
KERNEL_VERSION="${KERNEL_VERSION}"
PATCHES="stable_queue.tar.gz"

cd ${REMOTE_DIR}

# create the linux clone
git clone -s ${REMOTE_STABLE_GIT} linux
cd linux

# checkout the branch we need
git checkout -t -b linux-${KERNEL_VERSION}.y origin/linux-${KERNEL_VERSION}.y

# remove the .git directory as we don't need that space hanging around anymore
#rm -rf .git/

# create a patches/ directory for the stable patches to apply
mkdir patches
cd patches
tar -zxvf ${REMOTE_DIR}/\${PATCHES}
cd ..

# Apply the patch queue
QUILT_PATCHES=patches QUILT_SERIES=patches/series quilt push -aq --quiltrc

# build stuff
perl ../ktest.pl ../ktest.conf

KTEST_RUN=$?
echo "KTEST_RUN = \${KTEST_RUN}"

cd ..

if [ "\${KTEST_RUN}" = "0" ]; then
	# test succeeded
	SUBJECT="Build of ${KERNEL_VERSION} was good"
else
	SUBJECT="Build of ${KERNEL_VERSION} FAILED!"
fi

mutt -s "\${SUBJECT}" -a linux/log -- ${EMAIL} < output_log

# now that we are done, clean up after ourselves
rm -rf ${REMOTE_DIR}


__EOF__
chmod 755 ${SCRIPT_HOME}/run_test.sh

# create the ktest.conf file
cat <<__EOF__ > ${SCRIPT_HOME}/ktest.conf
TEST_START
TEST_TYPE = build

DEFAULTS
BUILD_TYPE = allmodconfig
OUTPUT_DIR = \${PWD}/output
LOG_FILE = \${PWD}/log
LOCALVERSION = -test
BUILD_OPTIONS = -j16
MACHINE = aws
BUILD_DIR = \${PWD}
__EOF__


# copy a version of ktest that we want to run
cp ${LOCAL_KTEST} ${SCRIPT_HOME}

# copy the files we created to the remote machine
scp -q ${SCRIPT_HOME}/* ${REMOTE_USER}@${REMOTE_SERVER}:${REMOTE_DIR}

# remove the local files as we don't need them anymore
rm -rf ${SCRIPT_HOME}

# execute the script on the remote machine

#ssh ${REMOTE_USER}@${REMOTE_SERVER} "cd ${REMOTE_DIR} && nohup \"cd ${REMOTE_DIR} && ./run_test.sh & > ${REMOTE_DIR} output_log \" "
#ssh ${REMOTE_USER}@${REMOTE_SERVER} "cd ${REMOTE_DIR} && nohup \"${REMOTE_DIR}/run_test.sh & > ${REMOTE_DIR}/output_log\""
#ssh ${REMOTE_USER}@${REMOTE_SERVER} "nohup ${REMOTE_DIR}/run_test.sh > ${REMOTE_DIR}/output_log &"
#ssh ${REMOTE_USER}@${REMOTE_SERVER} "${REMOTE_DIR}/run_test.sh > ${REMOTE_DIR}/output_log"
ssh -n -f ${REMOTE_USER}@${REMOTE_SERVER} "sh -c \"cd ${REMOTE_DIR}; nohup ./run_test.sh > ${REMOTE_DIR}/output_log 2>&1 &\" "


exit



--X1bOJ3K7DJ5YkBrT--
