Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab2EVMIC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 08:08:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8535 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab2EVMGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 08:06:32 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=z4UiPMpQhlYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=20KFwNOVAAAA:8 a=vBuRF21Ry8gwXxID0loA:9 a=Vh2fHcqstepcrP00UCAA:7 a=QEXdDO2ut3YA:10 a=Gq9PjJF5URkA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=s3Je_W7DtKXg-KDrcBAA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120522120630.852325676@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 22 May 2012 08:05:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4/8] ktest: Add useful example configs
References: <20120522120531.460108326@goodmis.org>
Content-Disposition: inline; filename=0004-ktest-Add-useful-example-configs.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

I've been asked several times to provide more useful example configs for
ktest.pl, as the sample.conf is too complex (because it explains all
configs). This adds configs broken up by use case, and these configs are
based on actual configs that I use on a daily basis.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/examples/include/bisect.conf   |   90 +++++++++++
 tools/testing/ktest/examples/include/defaults.conf |  157 ++++++++++++++++=
++++
 .../testing/ktest/examples/include/min-config.conf |   60 ++++++++
 .../testing/ktest/examples/include/patchcheck.conf |   74 +++++++++
 tools/testing/ktest/examples/include/tests.conf    |   74 +++++++++
 tools/testing/ktest/examples/test.conf             |   62 ++++++++
 6 files changed, 517 insertions(+)
 create mode 100644 tools/testing/ktest/examples/include/bisect.conf
 create mode 100644 tools/testing/ktest/examples/include/defaults.conf
 create mode 100644 tools/testing/ktest/examples/include/min-config.conf
 create mode 100644 tools/testing/ktest/examples/include/patchcheck.conf
 create mode 100644 tools/testing/ktest/examples/include/tests.conf
 create mode 100644 tools/testing/ktest/examples/test.conf

diff --git a/tools/testing/ktest/examples/include/bisect.conf b/tools/testi=
ng/ktest/examples/include/bisect.conf
new file mode 100644
index 0000000..009bea6
--- /dev/null
+++ b/tools/testing/ktest/examples/include/bisect.conf
@@ -0,0 +1,90 @@
+#
+# This example shows the bisect tests (git bisect and config bisect)
+#
+
+
+# The config that includes this file may define a RUN_TEST
+# variable that will tell this config what test to run.
+# (what to set the TEST option to).
+#
+DEFAULTS IF NOT DEFINED RUN_TEST
+# Requires that hackbench is in the PATH
+RUN_TEST :=3D ${SSH} hackbench 50
+
+
+# Set TEST to 'bisect' to do a normal git bisect. You need
+# to modify the options below to make it bisect the exact
+# commits you are interested in.
+#
+TEST_START IF ${TEST} =3D=3D bisect
+TEST_TYPE =3D bisect
+# You must set the commit that was considered good (git bisect good)
+BISECT_GOOD =3D v3.3
+# You must set the commit that was considered bad (git bisect bad)
+BISECT_BAD =3D HEAD
+# It's best to specify the branch to checkout before starting the bisect.
+CHECKOUT =3D origin/master
+# This can be build, boot, or test. Here we are doing a bisect
+# that requires to run a test to know if the bisect was good or bad.
+# The test should exit with 0 on good, non-zero for bad. But see
+# the BISECT_RET_* options in samples.conf to override this.
+BISECT_TYPE =3D test
+TEST =3D ${RUN_TEST}
+# It is usually a good idea to confirm that the GOOD and the BAD
+# commits are truly good and bad respectively. Having BISECT_CHECK
+# set to 1 will check both that the good commit works and the bad
+# commit fails. If you only want to check one or the other,
+# set BISECT_CHECK to 'good' or to 'bad'.
+BISECT_CHECK =3D 1
+#BISECT_CHECK =3D good
+#BISECT_CHECK =3D bad
+
+# Usually it's a good idea to specify the exact config you
+# want to use throughout the entire bisect. Here we placed
+# it in the directory we called ktest.pl from and named it
+# 'config-bisect'.
+MIN_CONFIG =3D ${THIS_DIR}/config-bisect
+# By default, if we are doing a BISECT_TYPE =3D test run but the
+# build or boot fails, ktest.pl will do a 'git bisect skip'.
+# Uncomment the below option to make ktest stop testing on such
+# an error.
+#BISECT_SKIP =3D 0
+# Now if you had BISECT_SKIP =3D 0 and the test fails, you can
+# examine what happened and then do 'git bisect log > /tmp/replay'
+# Set BISECT_REPLAY to /tmp/replay and ktest.pl will run the
+# 'git bisect replay /tmp/replay' before continuing the bisect test.
+#BISECT_REPLAY =3D /tmp/replay
+# If you used BISECT_REPLAY after the bisect test failed, you may
+# not want to continue the bisect on that commit that failed.
+# By setting BISECT_START to a new commit. ktest.pl will checkout
+# that commit after it has performed the 'git bisect replay' but
+# before it continues running the bisect test.
+#BISECT_START =3D 2545eb6198e7e1ec50daa0cfc64a4cdfecf24ec9
+
+# Now if you don't trust ktest.pl to make the decisions for you, then
+# set BISECT_MANUAL to 1. This will cause ktest.pl not to decide
+# if the commit was good or bad. Instead, it will ask you to tell
+# it if the current commit was good. In the mean time, you could
+# take the result, load it on any machine you want. Run several tests,
+# or whatever you feel like. Then, when you are happy, you can tell
+# ktest if you think it was good or not and ktest.pl will continue
+# the git bisect. You can even change what commit it is currently at.
+#BISECT_MANUAL =3D 1
+
+
+# One of the unique tests that ktest does is the config bisect.
+# Currently (which hopefully will be fixed soon), the bad config
+# must be a superset of the good config. This is because it only
+# searches for a config that causes the target to fail. If the
+# good config is not a subset of the bad config, or if the target
+# fails because of a lack of a config, then it will not find
+# the config for you.
+TEST_START IF ${TEST} =3D=3D config-bisect
+TEST_TYPE =3D config_bisect
+# set to build, boot, test
+CONFIG_BISECT_TYPE =3D boot
+# Set the config that is considered bad.
+CONFIG_BISECT =3D ${THIS_DIR}/config-bad
+# This config is optional. By default it uses the
+# MIN_CONFIG as the good config.
+CONFIG_BISECT_GOOD =3D ${THIS_DIR}/config-good
diff --git a/tools/testing/ktest/examples/include/defaults.conf b/tools/tes=
ting/ktest/examples/include/defaults.conf
new file mode 100644
index 0000000..323a552
--- /dev/null
+++ b/tools/testing/ktest/examples/include/defaults.conf
@@ -0,0 +1,157 @@
+# This file holds defaults for most the tests. It defines the options that
+# are most common to tests that are likely to be shared.
+#
+# Note, after including this file, a config file may override any option
+# with a DEFAULTS OVERRIDE section.
+#
+
+# For those cases that use the same machine to boot a 64 bit
+# and a 32 bit version. The MACHINE is the DNS name to get to the
+# box (usually different if it was 64 bit or 32 bit) but the
+# BOX here is defined as a variable that will be the name of the box
+# itself. It is useful for calling scripts that will power cycle
+# the box, as only one script needs to be created to power cycle
+# even though the box itself has multiple operating systems on it.
+# By default, BOX and MACHINE are the same.
+
+DEFAULTS IF NOT DEFINED BOX
+BOX :=3D ${MACHINE}
+
+
+# Consider each box as 64 bit box, unless the config including this file
+# has defined BITS =3D 32
+
+DEFAULTS IF NOT DEFINED BITS
+BITS :=3D 64
+
+
+DEFAULTS
+
+# THIS_DIR is used through out the configs and defaults to ${PWD} which
+# is the directory that ktest.pl was called from.
+
+THIS_DIR :=3D ${PWD}
+
+
+# to orginize your configs, having each machine save their configs
+# into a separate directly is useful.
+CONFIG_DIR :=3D ${THIS_DIR}/configs/${MACHINE}
+
+# Reset the log before running each test.
+CLEAR_LOG =3D 1
+
+# As installing kernels usually requires root privilege, default the
+# user on the target as root. It is also required that the target
+# allows ssh to root from the host without asking for a password.
+
+SSH_USER =3D root
+
+# For accesing the machine, we will ssh to root@machine.
+SSH :=3D ssh ${SSH_USER}@${MACHINE}
+
+# Update this. The default here is ktest will ssh to the target box
+# and run a script called 'run-test' located on that box.
+TEST =3D ${SSH} run-test
+
+# Point build dir to the git repo you use
+BUILD_DIR =3D ${THIS_DIR}/linux.git
+
+# Each machine will have its own output build directory.
+OUTPUT_DIR =3D ${THIS_DIR}/build/${MACHINE}
+
+# Yes this config is focused on x86 (but ktest works for other archs too)
+BUILD_TARGET =3D arch/x86/boot/bzImage
+TARGET_IMAGE =3D /boot/vmlinuz-test
+
+# have directory for the scripts to reboot and power cycle the boxes
+SCRIPTS_DIR :=3D ${THIS_DIR}/scripts
+
+# You can have each box/machine have a script to power cycle it.
+# Name your script <box>-cycle.
+POWER_CYCLE =3D ${SCRIPTS_DIR}/${BOX}-cycle
+
+# This script is used to power off the box.
+POWER_OFF =3D ${SCRIPTS_DIR}/${BOX}-poweroff
+
+# Keep your test kernels separate from your other kernels.
+LOCALVERSION =3D -test
+
+# The /boot/grub/menu.lst is searched for the line:
+#  title Test Kernel
+# and ktest will use that kernel to reboot into.
+# For grub2 or other boot loaders, you need to set BOOT_TYPE
+# to 'script' and define other ways to load the kernel.
+# See snowball.conf example.
+#
+GRUB_MENU =3D Test Kernel
+
+# The kernel build will use this option.
+BUILD_OPTIONS =3D -j8
+
+# Keeping the log file with the output dir is convenient.
+LOG_FILE =3D ${OUTPUT_DIR}/${MACHINE}.log
+
+# Each box should have their own minum configuration
+# See min-config.conf
+MIN_CONFIG =3D ${CONFIG_DIR}/config-min
+
+# For things like randconfigs, there may be configs you find that
+# are already broken, or there may be some configs that you always
+# want set. Uncomment ADD_CONFIG and point it to the make config files
+# that set the configs you want to keep on (or off) in your build.
+# ADD_CONFIG is usually something to add configs to all machines,
+# where as, MIN_CONFIG is specific per machine.
+#ADD_CONFIG =3D ${THIS_DIR}/config-broken ${THIS_DIR}/config-general
+
+# To speed up reboots for bisects and patchcheck, instead of
+# waiting 60 seconds for the console to be idle, if this line is
+# seen in the console output, ktest will know the good kernel has
+# finished rebooting and it will be able to continue the tests.
+REBOOT_SUCCESS_LINE =3D ${MACHINE} login:
+
+# The following is different ways to end the test.
+# by setting the variable REBOOT to: none, error, fail or
+# something else, ktest will power cycle or reboot the target box
+# at the end of the tests.
+#
+# REBOOT :=3D none
+#   Don't do anything at the end of the test.
+#
+# REBOOT :=3D error
+#   Reboot the box if ktest detects an error
+#
+# REBOOT :=3D fail
+#   Do not stop on failure, and after all tests are complete
+#   power off the box (for both success and error)
+#   This is good to run over a weekend and you don't want to waste
+#   electricity.
+#
+
+DEFAULTS IF ${REBOOT} =3D=3D none
+REBOOT_ON_SUCCESS =3D 0
+REBOOT_ON_ERROR =3D 0
+POWEROFF_ON_ERROR =3D 0
+POWEROFF_ON_SUCCESS =3D 0
+
+DEFAULTS ELSE IF ${REBOOT} =3D=3D error
+REBOOT_ON_SUCCESS =3D 0
+REBOOT_ON_ERROR =3D 1
+POWEROFF_ON_ERROR =3D 0
+POWEROFF_ON_SUCCESS =3D 0
+
+DEFAULTS ELSE IF ${REBOOT} =3D=3D fail
+REBOOT_ON_SUCCESS =3D 0
+POWEROFF_ON_ERROR =3D 1
+POWEROFF_ON_SUCCESS =3D 1
+POWEROFF_AFTER_HALT =3D 120
+DIE_ON_FAILURE =3D 0
+
+# Store the failure information into this directory
+# such as the .config, dmesg, and build log.
+STORE_FAILURES =3D ${THIS_DIR}/failures
+
+DEFAULTS ELSE
+REBOOT_ON_SUCCESS =3D 1
+REBOOT_ON_ERROR =3D 1
+POWEROFF_ON_ERROR =3D 0
+POWEROFF_ON_SUCCESS =3D 0
diff --git a/tools/testing/ktest/examples/include/min-config.conf b/tools/t=
esting/ktest/examples/include/min-config.conf
new file mode 100644
index 0000000..c703cc4
--- /dev/null
+++ b/tools/testing/ktest/examples/include/min-config.conf
@@ -0,0 +1,60 @@
+#
+# This file has some examples for creating a MIN_CONFIG.
+# (A .config file that is the minimum for a machine to boot, or
+#  to boot and make a network connection.)
+#
+# A MIN_CONFIG is very useful as it is the minimum configuration
+# needed to boot a given machine. You can debug someone else's
+# .config by only setting the configs in your MIN_CONFIG. The closer
+# your MIN_CONFIG is to the true minimum set of configs needed to
+# boot your machine, the closer the config you test with will be
+# to the users config that had the failure.
+#
+# The make_min_config test allows you to create a MIN_CONFIG that
+# is truly the minimum set of configs needed to boot a box.
+#
+# In this example, the final config will reside in
+# ${CONFIG_DIR}/config-new-min and ${CONFIG_DIR}/config-new-min-net.
+# Just move one to the location you have set for MIN_CONFIG.
+#
+# The first test creates a MIN_CONFIG that will be the minimum
+# configuration to boot ${MACHINE} and be able to ssh to it.
+#
+# The second test creates a MIN_CONFIG that will only boot
+# the target and most likely will not let you ssh to it. (Notice
+# how the second test uses the first test's result to continue with.
+# This is because the second test config is a subset of the first).
+#
+# The ${CONFIG_DIR}/config-skip (and -net) will hold the configs
+# that ktest.pl found would not boot the target without them set.
+# The config-new-min holds configs that ktest.pl could not test
+# directly because another config that was needed to boot the box
+# selected them. Sometimes it is possible that this file will hold
+# the true minimum configuration. You can test to see if this is
+# the case by running the boot test with BOOT_TYPE =3D allnoconfig and
+# setting setting the MIN_CONFIG to ${CONFIG_DIR}/config-skip. If the
+# machine still boots, then you can use the config-skip as your MIN_CONFIG.
+#
+# These tests can run for several hours (and perhaps days).
+# It's OK to kill the test with a Ctrl^C. By restarting without
+# modifying this config, ktest.pl will notice that the config-new-min(-net)
+# exists, and will use that instead as the starting point.
+# The USE_OUTPUT_MIN_CONFIG is set to 1 to keep ktest.pl from asking
+# you if you want to use the OUTPUT_MIN_CONFIG as the starting point.
+# By using the OUTPUT_MIN_CONFIG as the starting point will allow ktest.pl=
 to
+# start almost where it left off.
+#
+TEST_START IF ${TEST} =3D=3D min-config
+TEST_TYPE =3D make_min_config
+OUTPUT_MIN_CONFIG =3D ${CONFIG_DIR}/config-new-min-net
+IGNORE_CONFIG =3D ${CONFIG_DIR}/config-skip-net
+MIN_CONFIG_TYPE =3D test
+TEST =3D ${SSH} echo hi
+USE_OUTPUT_MIN_CONFIG =3D 1
+
+TEST_START IF ${TEST} =3D=3D min-config && ${MULTI}
+TEST_TYPE =3D make_min_config
+OUTPUT_MIN_CONFIG =3D ${CONFIG_DIR}/config-new-min
+IGNORE_CONFIG =3D ${CONFIG_DIR}/config-skip
+MIN_CONFIG =3D ${CONFIG_DIR}/config-new-min-net
+USE_OUTPUT_MIN_CONFIG =3D 1
diff --git a/tools/testing/ktest/examples/include/patchcheck.conf b/tools/t=
esting/ktest/examples/include/patchcheck.conf
new file mode 100644
index 0000000..339d3e1
--- /dev/null
+++ b/tools/testing/ktest/examples/include/patchcheck.conf
@@ -0,0 +1,74 @@
+# patchcheck.conf
+#
+# This contains a test that takes two git commits and will test each
+# commit between the two. The build test will look at what files the
+# commit has touched, and if any of those files produce a warning, then
+# the build will fail.
+
+
+# PATCH_START is the commit to begin with and PATCH_END is the commit
+# to end with (inclusive). This is similar to doing a git rebase -i PATCH_=
START~1
+# and then testing each commit and doing a git rebase --continue.
+# You can use a SHA1, a git tag, or anything that git will accept for a ch=
eckout
+
+PATCH_START :=3D HEAD~3
+PATCH_END :=3D HEAD
+
+# Change PATCH_CHECKOUT to be the branch you want to test. The test will
+# do a git checkout of this branch before starting. Obviously both
+# PATCH_START and PATCH_END must be in this branch (and PATCH_START must
+# be contained by PATCH_END).
+
+PATCH_CHECKOUT :=3D test/branch
+
+# Usually it's a good idea to have a set config to use for testing individ=
ual
+# patches.
+PATCH_CONFIG :=3D ${CONFIG_DIR}/config-patchcheck
+
+# Change PATCH_TEST to run some test for each patch. Each commit that is
+# tested, after it is built and installed on the test machine, this command
+# will be executed. Usually what is done is to ssh to the target box and
+# run some test scripts. If you just want to boot test your patches
+# comment PATCH_TEST out.
+PATCH_TEST :=3D ${SSH} "/usr/local/bin/ktest-test-script"
+
+DEFAULTS IF DEFINED PATCH_TEST
+PATCH_TEST_TYPE :=3D test
+
+DEFAULTS ELSE
+PATCH_TEST_TYPE :=3D boot
+
+# If for some reason a file has a warning that one of your patches touch
+# but you do not care about it, set IGNORE_WARNINGS to that commit(s)
+# (space delimited)
+#IGNORE_WARNINGS =3D 39eaf7ef884dcc44f7ff1bac803ca2a1dcf43544 6edb2a8a385f=
0cdef51dae37ff23e74d76d8a6ce
+
+# If you are running a multi test, and the test failed on the first
+# test but on, say the 5th patch. If you want to restart on the
+# fifth patch, set PATCH_START1. This will make the first test start
+# from this commit instead of the PATCH_START commit.
+# Note, do not change this option. Just define PATCH_START1 in the
+# top config (the one you pass to ktest.pl), and this will use it,
+# otherwise it will just use PATCH_START if PATCH_START1 is not defined.
+DEFAULTS IF NOT DEFINED PATCH_START1
+PATCH_START1 :=3D ${PATCH_START}
+
+TEST_START IF ${TEST} =3D=3D patchcheck
+TEST_TYPE =3D patchcheck
+MIN_CONFIG =3D ${PATCH_CONFIG}
+TEST =3D ${PATCH_TEST}
+PATCHCHECK_TYPE =3D ${PATCH_TEST_TYPE}
+PATCHCHECK_START =3D ${PATCH_START1}
+PATCHCHECK_END =3D ${PATCH_END}
+CHECKOUT =3D ${PATCH_CHECKOUT}
+
+TEST_START IF ${TEST} =3D=3D patchcheck && ${MULTI}
+TEST_TYPE =3D patchcheck
+MIN_CONFIG =3D ${PATCH_CONFIG}
+TEST =3D ${PATCH_TEST}
+PATCHCHECK_TYPE =3D ${PATCH_TEST_TYPE}
+PATCHCHECK_START =3D ${PATCH_START}
+PATCHCHECK_END =3D ${PATCH_END}
+CHECKOUT =3D ${PATCH_CHECKOUT}
+# Use multi to test different compilers?
+MAKE_CMD =3D CC=3Dgcc-4.5.1 make
diff --git a/tools/testing/ktest/examples/include/tests.conf b/tools/testin=
g/ktest/examples/include/tests.conf
new file mode 100644
index 0000000..4fdb811
--- /dev/null
+++ b/tools/testing/ktest/examples/include/tests.conf
@@ -0,0 +1,74 @@
+#
+# This is an example of various tests that you can run
+#
+# The variable TEST can be of boot, build, randconfig, or test.
+#
+# Note that TEST is a variable created with ':=3D' and only exists
+# throughout the config processing (not during the tests itself).
+#
+# The TEST option (defined with '=3D') is used to tell ktest.pl
+# what test to run after a successful boot. The TEST option is
+# persistent into the test runs.
+#
+
+# The config that includes this file may define a BOOT_TYPE
+# variable that tells this config what type of boot test to run.
+# If it's not defined, the below DEFAULTS will set the default
+# to 'oldconfig'.
+#
+DEFAULTS IF NOT DEFINED BOOT_TYPE
+BOOT_TYPE :=3D oldconfig
+
+# The config that includes this file may define a RUN_TEST
+# variable that will tell this config what test to run.
+# (what to set the TEST option to).
+#
+DEFAULTS IF NOT DEFINED RUN_TEST
+# Requires that hackbench is in the PATH
+RUN_TEST :=3D ${SSH} hackbench 50
+
+
+# If TEST is set to 'boot' then just build a kernel and boot
+# the target.
+TEST_START IF ${TEST} =3D=3D boot
+TEST_TYPE =3D boot
+# Notice how we set the BUILD_TYPE option to the BOOT_TYPE variable.
+BUILD_TYPE =3D ${BOOT_TYPE}
+# Do not do a make mrproper.
+BUILD_NOCLEAN =3D 1
+
+# If you only want to build the kernel, and perhaps install
+# and test it yourself, then just set TEST to build.
+TEST_START IF ${TEST} =3D=3D build
+TEST_TYPE =3D build
+BUILD_TYPE =3D ${BOOT_TYPE}
+BUILD_NOCLEAN =3D 1
+
+# Build, install, boot and test with a randconfg 10 times.
+# It is important that you have set MIN_CONFIG in the config
+# that includes this file otherwise it is likely that the
+# randconfig will not have the neccessary configs needed to
+# boot your box. This version of the test requires a min
+# config that has enough to make sure the target has network
+# working.
+TEST_START ITERATE 10 IF ${TEST} =3D=3D randconfig
+MIN_CONFIG =3D ${CONFIG_DIR}/config-min-net
+TEST_TYPE =3D test
+BUILD_TYPE =3D randconfig
+TEST =3D ${RUN_TEST}
+
+# This is the same as above, but only tests to a boot prompt.
+# The MIN_CONFIG used here does not need to have networking
+# working.
+TEST_START ITERATE 10 IF ${TEST} =3D=3D randconfig && ${MULTI}
+TEST_TYPE =3D boot
+BUILD_TYPE =3D randconfig
+MIN_CONFIG =3D ${CONFIG_DIR}/config-min
+MAKE_CMD =3D make
+
+# This builds, installs, boots and tests the target.
+TEST_START IF ${TEST} =3D=3D test
+TEST_TYPE =3D test
+BUILD_TYPE =3D ${BOOT_TYPE}
+TEST =3D ${RUN_TEST}
+BUILD_NOCLEAN =3D 1
diff --git a/tools/testing/ktest/examples/test.conf b/tools/testing/ktest/e=
xamples/test.conf
new file mode 100644
index 0000000..b725210
--- /dev/null
+++ b/tools/testing/ktest/examples/test.conf
@@ -0,0 +1,62 @@
+#
+# Generic config for a machine
+#
+
+# Name your machine (the DNS name, what you ssh to)
+MACHINE =3D foo
+
+# BOX can be different than foo, if the machine BOX has
+# multiple partitions with different systems installed. For example,
+# you may have a i386 and x86_64 installation on a test box.
+# If this is the case, MACHINE defines the way to connect to the
+# machine, which may be different between which system the machine
+# is booting into. BOX is used for the scripts to reboot and power cycle
+# the machine, where it does not matter which system the machine boots int=
o.
+#
+#BOX :=3D bar
+
+# Define a way to read the console
+CONSOLE =3D stty -F /dev/ttyS0 115200 parodd; cat /dev/ttyS0
+
+# The include files will set up the type of test to run. Just set TEST to
+# which test you want to run.
+#
+# TESTS =3D patchcheck, randconfig, boot, test, config-bisect, bisect, min=
-config
+#
+# See the include/*.conf files that define these tests
+#
+TEST :=3D patchcheck
+
+# Some tests may have more than one test to run. Define MULTI :=3D 1 to run
+# the extra tests.
+MULTI :=3D 0
+
+# In case you want to differentiate which type of system you are testing
+BITS :=3D 64
+
+# REBOOT =3D none, error, fail, empty
+#  See include/defaults.conf
+REBOOT :=3D empty
+
+# The defaults file will set up various settings that can be used by all
+# machine configs.
+INCLUDE include/defaults.conf
+
+# In case you need to add a patch for a bisect or something
+#PRE_BUILD =3D patch -p1 < ${THIS_DIR}/fix.patch
+
+# Reset the repo after the build and remove all 'test' modules from the ta=
rget
+# Notice that DO_POST_BUILD is a variable (defined by ':=3D') and POST_BUI=
LD
+# is the option (defined by '=3D')
+
+DO_POST_BUILD :=3D git reset --hard
+POST_BUILD =3D ${SSH} 'rm -rf /lib/modules/*-test*'; ${DO_POST_BUILD}
+
+# The following files each handle a different test case.
+# Having them included allows you to set up more than one machine and share
+# the same tests.
+INCLUDE include/patchcheck.conf
+INCLUDE include/tests.conf
+INCLUDE include/bisect.conf
+INCLUDE include/min-config.conf
+
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPu4FGAAoJEIy3vGnGbaoALwAP+gJnjwEBecnR2YaULZqiYe5D
KHnvGT5NHcZnqajYKYTHJdHmtoa0nror6qJn1oQfyaR41ucpU3oWjgcN3pUR62dc
cetY3u/8XN/LZvwOhtSDSSilo9ppmUQVNenx0RoB+ohgx+AZrnW162Zkti4/Ql8F
mClcqJIC6TKBdZYA+cE7+bFjir+b1y5wFlFJYIy/GsKcieckoTVN74ihSyFI+VuD
ztJ5jG2tWjuEO22X8KcbdDoeikdXjQyzaTSgC/5fYsgIR5wEZDaxFntpMno/29Vw
RI74HyqQTGeldKRNHzN0fCBr1LZ46AZPrayoBpZ1aUoL1JrLN7mzDysaPjNNSK7H
29/P/CRxHx9ZgWDRZLdGWM8kEnc0U6f4SfcvpgCnckZKJNrbPE/gXytDYe2zkYVr
GNsIEsoKyHoTIlAHjrZSyZ0kG/NxryhJwaa4L/1mt0MF9ZokMs8ZBnkANnP1+CxM
xFGXdzBNSIX+rtRPqALwlTSPkHOdXh+GYs7duxq/PKrODUix4aZyHVNP1gHxV9gd
u1JWqT43Xf1imVjC4F1B8u9bXr2oynXDK01dEJ/eqpV6Qv+ZhbXcFsZtwQLDzqY2
inIE8gffiB2paW54zrZ9/X+3w+8ZIdUvYNaOfETgj23J2LTRmCIghSO9Jh8IJs0K
wlcD7cWINerHActYf0Ci
=NZFs
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
