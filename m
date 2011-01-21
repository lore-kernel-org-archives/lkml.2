Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1AUVOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 16:14:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33133 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab1AUVOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 16:14:06 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=ZNWVe3i0kLwA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=47681EPdxkKAl8cyRE8A:9 a=_hINfl-VBxzuN86LwfQA:7 a=m_IVftNGMj904hvKuiACF-qJpl0A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: 2.6.38-rc1 problems with khugepaged
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: werner <w.landgraf@ru.ru>, akpm@linux-foundation.org, hannes@cmpxchg.org,
        idryomov@gmail.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>
In-Reply-To: <20110121191757.GO9506@random.random>
References: <web-444048714@zbackend1.aha.ru>
	 <20110121191757.GO9506@random.random>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 21 Jan 2011 16:14:02 -0500
Message-ID: <1295644442.12215.4482.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ annoying plug ]

On Fri, 2011-01-21 at 20:17 +0100, Andrea Arcangeli wrote:
> On Fri, Jan 21, 2011 at 06:43:44AM -0400, werner wrote:
> > 2.6.38-rc1-git1 runs normally with khugepaged switched 
> > OFF.  Thus, khugepaged  is the problem; as said if 
> > switched it on, during boot the computer becomes very slow 
> > and sticks almost.    wl
> 
> Sorry, looks like x86 32bit THP wasn't tested in all possible .config
> (32bit support is upstream-only feature and because of lower userbase
> it also got a lot less testing than 64bit support).
> 
> Does it make any difference if you both disable CONFIG_PARAVIRT and
> enable HIGHMEM64?
> 
> For now keep THP off on 32bit, it should be trivial to reproduce so
> fix will come soon.
> 
> Minchan info shows it's an 32bit arch bug so don't be too worried
> about it because it can't affect 64bit builds and it's not common code
> bug and we'll fix it ASAP.

Just want to mention that ktest.pl was included in this release, just
for this purpose :)

It does randconfigs (and other nice features) and will test various
kernels. All you need is to have a test machine that can be remotely
booted and have its console read via stdio from another machine.

This happened to be how I triggered the bug.

I would be happy to help anyone set it up. The config I used to test my
box to do 10 runs of randconfig with a minimal config to make it boot,
and then 10 runs of randconfig with the minimal config to make it boot
and enable networking:

-----
MACHINE = mitest

# The TEST_START can override most defaults

# do ten boot tests (minimum forced config settings as possible)
TEST_START ITERATE 10
TEST_TYPE = boot
BUILD_TYPE = randconfig
MIN_CONFIG = /home/rostedt/work/autotest/configs/mitest/config-mitest-min
CHECKOUT = origin/master

# do ten boot and ssh hackbench tests (need network configs set)
TEST_START ITERATE 10
TEST_TYPE = TEST
BUILD_TYPE = randconfig
MIN_CONFIG = /home/rostedt/work/autotest/configs/mitest/config-mitest-net
CHECKOUT = origin/master
TEST = ssh root@mitest /work/c/hackbench_32 50


# defaults to use when watching test (SKIP will make ktest ignore it)
DEFAULTS SKIP
REBOOT_ON_ERROR = 1
POWEROFF_ON_ERROR = 0
POWEROFF_ON_SUCCESS = 0
REBOOT_ON_SUCCESS = 1
DIE_ON_FAILURE = 1

#defaults to kick off at night, and shut down at the end
DEFAULTS
REBOOT_ON_ERROR = 0
POWEROFF_ON_ERROR = 1
POWEROFF_ON_SUCCESS = 1
REBOOT_ON_SUCCESS = 0
DIE_ON_FAILURE = 0
STORE_FAILURES = /home/rostedt/work/autotest/nobackup/failures

# defaults for all tests
DEFAULTS
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
-----


-- Steve


