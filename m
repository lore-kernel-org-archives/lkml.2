Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542Ab0J1Tmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 15:42:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41648 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab0J1Tm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 15:42:28 -0400
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=C9oEWiQ14eQA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=b8VgSBC0AAAA:8 a=AkYz7fTvCCNagHbzy_wA:9 a=q59gMgxretIv8u6nLwIA:7 a=ksjK1klSw0uLHSrWxOB-7PKacSkA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [ANNOUNCE] ktest.pl: Easy and flexible testing script for Linux
 Kernel Developers
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jon Masters <jcm@redhat.com>, corbet <corbet@lwn.net>,
        Jake Edge <jake@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>, lmr@redhat.com,
        Greg Kroah-Hartman <gregkh@suse.de>, autotest@test.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Clark Williams <williams@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 28 Oct 2010 15:42:24 -0400
Message-ID: <1288294944.18238.346.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You may have heard of the project at autotest.kernel.org. This project
is an advanced testing suite to automate tests across several number of
machines. But it may be a bit too complex for the kernel developer that
has a hacked up setup in his basement, and only has a few tests that
need automation.

Thus, if you are like me, and just want something that can automate the
following:

   1) run ranconfig several times and make sure it builds and boots

   2) Have a bunch of patches you are about to push, and you want to
      make sure they build (and don't cause new warnings), boot and
      perhaps run a test script on the test box, for each patch you
      are about to push.

   3) Bisect a reproducing bug, that either fails the build of the
      kernel, booting of the kernel, or can be detected by a script that
      is run on the test machine.

Then I have the script for you!

****  ktest.pl ****

  http://rostedt.homelinux.com/ktest/

(for the script and a sample config file that is highly documented)


I know lots of other developers that have written their own scripts, but
I worked on this to be as simple, generic and flexible as possible, with
as little learning curve as possible.

I've just completed ktest.pl. This is a perl script that can do
bisects, patch set verification, or just simply test rand configs on
various kernels.

The way it works, is that it reads a generic config file that you set
up. You do not need to know perl or how the script itself works. But
here's the current requirements to use the test script:

1) You need two machines, where one is the build system and the other is
the test system. It also works with a virtual machine system where the
Guest is the test system and the host is the build system.

2) You need a way to force a reboot of the test system. For bare-metal,
I use a digital loggers power switch box. But virsh works well for
virtual guests too.

3) The user running the test must be able to ssh into the test system
from the build system without a login (ie. using ssh keys). The script
uses scp to copy data onto the system.

4) The test system needs a minimum of two kernels. One to boot to a
reliable kernel (this may be the distro kernel) and this kernel needs to
be loaded by default.  The second kernel is the test kernel, which may
or may not even boot.

5) You need a way to reboot into the test kernel for one instance. If
you use grub v1, this is already supplied. Just specify in the config
file the full title name of the test kernel in /boot/grub/menu.lst.

6) You need a way to read the console output of the test box with
something that produces standard output.

That's about it!


Note: The script does NOT modify the /boot/grub/menu.lst. You need to
manually add the test image yourself. Mine looks like this:

title Test Kernel
        root (hd0,8)
        kernel /boot/vmlinuz-test ro root=/dev/sda9 console=ttyS0,115200 ignore_loglevel selinux=0 nmi_watchdog=2
title Test Kernel 2
        root (hd0,8)
        kernel /boot/vmlinuz-test-2 ro root=/dev/sda9 console=ttyS0,115200 ignore_loglevel selinux=0 nmi_watchdog=2
        initrd /boot/initramfs-test-2.img

The first option boots a kernel that does not rely on an initrd. The
second option boots a kernel that does. For the second option I have
this line in my config file:

POST_INSTALL = ssh root@mitest /sbin/mkinitrd --allow-missing -f /boot/initramfs-test-2.img $KERNEL_VERSION

Here's some basic options for booting and testing a kernel on bare-metal
with the digital loggers power switch: (see the sample.conf for comments
on each option that is available)

MACHINE = mitest

TEST_START ITERATE 3
TEST_TYPE = boot
BUILD_TYPE = randconfig
MIN_CONFIG = /home/rostedt/work/autotest/configs/mitest/config-mitest-min

TEST_START
BUILD_TYPE = allyesconfig

TEST_START
BUILD_TYPE = allnoconfig

TEST_START SKIP
TEST_TYPE = bisect
CHECKOUT = mybranch
BISECT_TYPE = build
BISECT_GOOD = v2.6.36
BISECT_BAD = HEAD

DEFAULTS
SSH_USER = root
BUILD_DIR = /home/rostedt/work/autotest/nobackup/linux-test.git
OUTPUT_DIR = /home/rostedt/work/autotest/nobackup/mitest
BUILD_TARGET = arch/x86/boot/bzImage
TARGET_IMAGE = /boot/vmlinuz-test
POWER_CYCLE = wget --no-proxy -O /dev/null -q  --auth-no-challenge 'http://admin:admin@power/outlet?5=CCL'
CONSOLE = nc -d localhost 3001
LOCALVERSION = -test
GRUB_MENU = Test Kernel
MAKE_CMD = LD=ld-32 CC=gcc-32 AS=as-32 make ARCH=i386
POWER_OFF = wget --no-proxy -O /dev/null -q  --auth-no-challenge 'http://admin:admin@power/outlet?5=OFF'
BUILD_OPTIONS = -j20
LOG_FILE = /home/rostedt/work/autotest/nobackup/mitest/mitest.log
CLEAR_LOG = 1
ADD_CONFIG = /home/rostedt/work/autotest/configs/config-broken

Some comments about the above. Test options is started with TEST_START,
all options below that tag are for the given test, until another
TEST_START label or DEFAULTS label is encountered.

The options under DEFAULTS are the options to use for a test that is not
specified for that given test under TEST_START.

The TEST_START ITERATE 3, will repeat that test 3 times before going to
the next test.

The TEST_START SKIP will ignore that test and those options. This allows
me to keep tests in the config file that I may use later, but do not
want to use now.


The MIN_CONFIG is a config file with only the options I need to boot my
mitest box. This is fed to the randconfig (and allnoconfig) and
randconfig will keep these settings as is, and randomize the rest.

>From the sample.conf in my URL:

# The min config that is needed to build for the machine
# A nice way to create this is with the following:
#
#   $ ssh target
#   $ lsmod > mymods
#   $ scp mymods host:/tmp
#   $ exit
#   $ cd linux.git
#   $ rm .config
#   $ make LSMOD=mymods localyesconfig
#   $ grep '^CONFIG' .config > /home/test/config-min
#
# If you want even less configs:
#
#   log in directly to target (do not ssh)
#
#   $ su
#   # lsmod | cut -d' ' -f1 | xargs rmmod
#
#   repeat the above several times
#
#   # lsmod > mymods
#   # reboot
#
# May need to reboot to get your network back to copy the mymods
# to the host, and then remove the previous .config and run the
# localyesconfig again. The CONFIG_MIN generated like this will
# not guarantee network activity to the box so the TEST_TYPE of
# test may fail.


In addition to MIN_CONFIG, I have ADD_CONFIG which contains options that
I know breaks the build or boot. Here's what's in that file:

# CONFIG_SCSI_DEBUG is not set
# CONFIG_STAGING is not set
# CONFIG_KGDB_TESTS is not set
# CONFIG_KGDB_SERIAL_CONSOLE is not set
# CONFIG_PROVE_RCU is not set
# CONFIG_PROVE_RCU_REPEATEDLY is not set
# CONFIG_PARIDE is not set
# CONFIG_HOTPLUG_PCI_IBM is not set

Note, the options in MIN_CONFIG will override these.

I reboot the box by using wget to my power switch (hostname == power)
and can power cycle the box or just power it off. Note, the bios needs
to be set to "power on after power failure".

The CONSOLE is just a netcat to localhost port 3001, where I have
ttywatch running with a connection to the serial of the test box.


I have a similar config I use for a virtual machine:

MACHINE = ixg
SSH_USER = root
BUILD_DIR = /work/git/linux-test.git
OUTPUT_DIR = /work/autotest/build/ixg
BUILD_TARGET = arch/x86/boot/bzImage
TARGET_IMAGE = /boot/vmlinuz-test
POWER_CYCLE = virsh destroy GuestF12; sleep 5; virsh start GuestF12
CONSOLE =  virsh console GuestF12
LOCALVERSION = -test
GRUB_MENU = Test Kernel
MAKE_CMD = make
TMP_DIR = /work/autotest/tmp/
REBOOT_ON_ERROR = 1
REBOOT_ON_SUCCESS = 1
DIE_ON_FAILURE = 0
STORE_FAILURES = /work/autotest/failures
BUILD_OPTIONS = -j20
LOG_FILE = /work/autotest/build/ixg/ixg.log
CLEAR_LOG = 1
MIN_CONFIG= /work/autotest/configs/config-ixg-test-min
ADD_CONFIG = /work/autotest/configs/config-broken

Notice that the CONSOLE uses virsh console and the POWER_CYCLE uses
virsh destroy and virsh start.

Also note that TEST_START is not given. This will only run the test
once, using just the default options.

I have a few added options, where it reboots if it hits an ERROR or
after it has completed all tests. It will also store the dmesg, buildlog
and .config in a directory with a unique timestamp in the name
in /work/autotest/failures/ if a failure occurs. And the test will not
stop on a detected failure (DIE_ON_FAILURE = 0).


Bisecting...

To automate a bisect, set the following:

TEST_START
TEST_TYPE = bisect
BISECT_TYPE = boot
BISECT_GOOD = v2.6.35
BISECT_BAD = HEAD
CHECKOUT = master

This will start by checking out the master branch, and then performing:

git bisect start
git bisect good v2.6.35
git bisect bad HEAD

Note, the BISECT_GOOD and BISECT_BAD may be anything that git
allows as a parameter to the git bisect commands (SHA1 for example). The
bisect options are only valid under TEST_START, even if that's the only
test you run.

The type of bisects you can do (defined by BISECT_TYPE) are, build,
boot and test. The build option tests at each bisect stage if the build
succeeds. For boot, it makes sure the build and boot succeeds, and for
test, if a TEST option is supplied (defines a command to run after
booting), then it will make sure build, boot and running of TEST
succeeds. If TEST is not supplied, then the test type falls back to
boot.

Note, boot will end the test (and the bisect) if build fails, and the
test type will end the test if either build or boot fails. If this
occurs, the BUILD_DIR is left in the state that it was in, so you can
examine the git bisect log, and even do some checkouts to find a good
commit to continue with. Then you can add these options:

BISECT_REPLAY = file
BISECT_START = option

The BISECT_REPLAY contains a file that stores the 'git bisect log'
and will run the replay first. Thus after a bisect fails, you can go
into the build directory and run 'git bisect log > /tests/bisect.log'
and then add 'BISECT_REPLAY = /tests/bisect.log' to the test.

The BISECT_START contains a git entry that it should checkout after it
does the initial git bisect start, git bisect good, git bisect bad, and
git bisect replay (if BISECT_REPLAY is set), and before it continues the
bisect. This is best for those times that you come across a commit that
just breaks everything and you need to skip it.

With the above set, this is how it works:

git bisect start
git bisect good BISECT_GOOD
git bisect bad BISECT_BAD

if BISECT_REPLAY is defined:
  git bisect replay BISECT_REPLAY

if BISECT_START is defined
  git checkout BISECT_START

then the rest of the bisect will continue.

For those strange instances where you find that something was always
broken and suddenly started to work, you can set:

BISECT_REVERSE = 1

This does everything the same, except when it detects a failure, it
performs a 'git bisect good' and when it detects success, it performs
'git bisect bad'.



Testing patches...

I wrote this because, I like to make sure patches that are sent to me
build without warnings and boot fine. Thus, after I've manually reviewed
the patches, I'll pull them into git with git am, and then run something
like this test.

TEST_START
TEST_TYPE = patchcheck
CHECKOUT = testbranch
PATCHCHECK_START = bf4a88810378019b7a2b043c2e3a1d18ae98b663
PATCHCHECK_END = HEAD
PATCHCHECK_TYPE = test

This will checkout my testbranch, then do a git log on PATCHCHECK_END
till it found PATCHCHECK_START, then it will apply each commit it
found, one by one and do a build, boot and test against the commit. If I
set PATCHCHECK_TYPE = build, only a build will be performed.

The special feature that patchcheck does, is that when it does a build,
it examines what files have warnings. If a file touched by the patch
produces a warning in the build, then the patchcheck will fail. This
flags patches that produce new warnings.



Lots of other cool features may be coming soon (but the goal is to be
simple not powerful, for that, use autotest.kernel.org).

(Note, currently patchcheck and bisect only work with git repos, but it
would not be too hard to make this work with a quilt series. If someone
is interested, I'm sure I could do it.)

Again, for more info on this, see the sample.conf supplied in the URL
posted above. It has lots of documentation to describe it.

Maybe this should go into the tools directory?

What do you think?

-- Steve

