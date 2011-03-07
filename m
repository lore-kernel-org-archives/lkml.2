Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab1CGR7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 12:59:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53242 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab1CGR7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 12:59:33 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=KGpMX1y64oQA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=8axyKG4oFpg07dgs734A:9 a=LbvEQd41gBSG5ur5EFMA:7 a=Vp16vuAqcF2af279Ztkr8HeZmRAA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Mon, 7 Mar 2011 12:59:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Theodore Tso <tytso@MIT.EDU>
Cc: CAI Qian <caiqian@redhat.com>, subrata@linux.vnet.ibm.com,
        ltp-list@lists.sf.net, vapier@gentoo.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Subject: Re: [LTP] [ANNOUNCE] The Linux Test Project has been released for
 FEBRUARY 2011.
Message-ID: <20110307175929.GA1240@home.goodmis.org>
References: <1469445745.266603.1299117157337.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
 <6AFCFCC5-DBC2-403E-9EED-D2A85FFCB21C@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6AFCFCC5-DBC2-403E-9EED-D2A85FFCB21C@mit.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 01:58:45PM -0500, Theodore Tso wrote:
> 
> On Mar 2, 2011, at 8:52 PM, CAI Qian wrote:
> 
> > Those days, there just too many tests and testing projects for kernel like
> > LTP, autotest, xfstests and so on. Why not have somewhere to collabrate and
> > then to extract the best?
> 
> Part of the problem is that every single testing project has different goals and
> priorities.   For example xfstests is maintained by the XFS folks, as well as people
> from some of the other file system development efforts (the ext4 one in particular,
> thanks to people like Eric Sandeen), to test file systems.

Perhaps we need to get developer's tests into the kernel. We now have a
tools/testing directory lets use it.

> 
> At least at one point, I had heard a complaint that LTP was more focused on 
> increasing test coverage as measured by a code coverage tool in the kernel
> than it was about about covering edge conditions, or races.  There's nothing 
> wrong with that, per se, and I don't know if it was true then or now, but it's a very
> different focus from one which is focused increasing the data reliability of file
> systems, quickly and efficiently.
> 
> And then there's the LSB test suites, which is really code at testing correctness
> from a standards perspective, which is a different focus yet again from the LTP
> and xfstests approach.
> 
> Bottom line, I'm a big fan of having different test suites, with different philosophies.
> Each philosophy has its strengths and blind spots, and so a problem that might
> be missed by one test suite might get caught by another.
> 
> The only real problem is an operational one.   There are some programs which
> are used by both LTP and xfstests, and changes that is made in one, don't 
> necessarily get propagated to the other unless someone manually does it.
> But I think we can solve that without trying to merge all of these tests into a
> single Grand Unified Test Suite.
> 

How about having the developers write tests and place them in the
tools/testing directory and then the folks at LTP and xfstests et al.
can update their code with the code from the kernel.

Currently only ktest.pl exists in this directory. I use it constantly
and post bugs that it finds. It focuses on just the building and booting
of a kernel. It can run several randconfigs, do bisects and such, but it
just has a single command to do any tests. This command is just a shell
command the user can put in. I leave what tests to run to the user. Thus
LTP could be the test that gets kicked off.

For example: I have this script I run on my x86 box:

TEST_START ITERATE 10
TEST_TYPE = test
BUILD_TYPE = randconfig
MIN_CONFIG = /home/rostedt/work/autotest/configs/mitest/config-mitest-net
CHECKOUT = origin/master
TEST = ssh root@mitest /work/c/hackbench_32 50

TEST_START ITERATE 10
TEST_TYPE = boot
BUILD_TYPE = randconfig
MIN_CONFIG = /home/rostedt/work/autotest/configs/mitest/config-mitest-min
MAKE_CMD = make ARCH=i386

DEFAULTS
REBOOT_ON_ERROR = 0
POWEROFF_ON_ERROR = 1
POWEROFF_ON_SUCCESS = 1
REBOOT_ON_SUCCESS = 0
DIE_ON_FAILURE = 0
STORE_FAILURES = /home/rostedt/work/autotest/nobackup/failures
POWEROFF_AFTER_HALT = 60
CLEAR_LOG = 1
MIN_CONFIG = /home/rostedt/work/autotest/configs/mitest/config-mitest-min
SSH_USER = root
BUILD_DIR = /home/rostedt/work/autotest/nobackup/linux-test.git
OUTPUT_DIR = /home/rostedt/work/autotest/nobackup/mitest
BUILD_TARGET = arch/x86/boot/bzImage
TARGET_IMAGE = /boot/vmlinuz-test
POWER_CYCLE = /home/rostedt/work/autotest/cycle-mxtest
CONSOLE = nc -d fedora 3001
LOCALVERSION = -test
GRUB_MENU = Test Kernel
MAKE_CMD = distmake-32 ARCH=i386
POWER_OFF = /home/rostedt/work/autotest/poweroff-mxtest
BUILD_OPTIONS = -j20
LOG_FILE = /home/rostedt/work/autotest/nobackup/mitest/mitest.log
TEST = ssh root@mitest cat /debug/tracing/trace
ADD_CONFIG = /home/rostedt/work/autotest/configs/config-broken /home/rostedt/work/autotest/config-general


Each command is documented in the samples.conf that is also in that
directory.

The above test runs two sets of tests. The first runs randconfig 10
times with a minimum config that will allow my box to have a network
connection, and after it boots, it runs hackbench.

The second test runs ten randconfig builds 10 times and just makes sure
the box can boot.

I'm working on getting to run commands via the console so I do not need
the network active to run tests.

Once could change the TEST = ... to run LTP tests, or anything else.
Having tests to run that I can add to my automated testing would be
helpful. I could build randconfigs and run these tests making sure that
they work with different configurations.

Maybe it would also be helpful to have the CONFIGs that are needed by
the tests. It would not make sense to test iptables if iptables is not
configured ;)

-- Steve

