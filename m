Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab1G1FQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 01:16:46 -0400
Received: from mail.windriver.com ([147.11.1.11]:51289 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab1G1FQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 01:16:30 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: mingo@elte.hu, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-arch@vger.kernel.org
Subject: [RFC/PULL 00/11] introduce export.h; reduce module.h usage
Date: Thu, 28 Jul 2011 01:16:07 -0400
Message-Id: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think there really is any rocket science or contentious stuff here.
It is a sensible cleanup that adds organization and speeds up compiles.
The RFC I'm hoping for is more about how/when we want to get this in tree.

The problem:
------------
	 The module.h header file contains a path to nearly every other
header, and it itself is implicitly used everywhere.  Such that if you
touch module.h and rebuild, it takes the same time as a completely clean
build.  We are feeding massive amounts of needless stuff to cpp on every
kernel build.  The "implicitly everywhere" problem is caused by common
header files (device.h, sock.h, etc) directly including module.h.

The solution:
-------------
	This also comes in two parts.  We can drastically reduce the
users of module.h by introducing an export.h -- so that every file
who isn't a module, but needs EXPORT_SYMBOL/THIS_MODULE, can instead
just use this lightweight header which in turn doesn't include any
others.  The "implicitly everywhere" can be solved by removing
module.h from all possible <linux/somefile.h> and replacing it with
a simple reference for "struct module". 

Solving the implicitly everywhere problem reveals lots of files who
were unknowingly capitalizing on having module.h present for its
contents, and contents of the files it in turn included.

Shown here in this RFC are the just the include/* patches which form
these two solutions.  What is *not* shown is the boring 150 or so
patches, all of the one-line variety, which deal with the fact that
people were implicitly taking advantage of module.h (and all its children
includes).  These all fall into one of these five mundane categories.

 1) adding module.h to files that were modular but were simply not
    including module.h because of its implicit presence everywhere.

 2) adding export.h to non-modular files that were not including module.h
    but were trying to use EXPORT_SYMBOL/THIS_MODULE macros.

 3) replacing module.h with export.h in non-modular files that are only
    trying to use EXPORT_SYMBOL/THIS_MODULE macros.

 4) adding in various other headers, like <linux/stat.h> that were simply
    implicitly present via happenstance of the module.h's sub-includes.

 5) deleting the <linux/module.h> from files who were including it but
    not doing anything at all related to modules.

Note that #3 and #5 don't show up as warnings/errors, I had to actively
hunt out those optimizations manually.  In total, all the one line
"fallout" changes add to this cleanup to give it this footprint:

 1148 files changed, 1263 insertions(+), 428 deletions(-)

[If I knew it was going to be that involved, I'd probably would have
 never undertaken to start this in the 1st place...]

I've kept these changes all grouped into arch and subsystem categories
in case people want to see this go in chunks via maintainer trees (as it
is much easier to combine things than try to "un-combine" things.)

For all 160 commits, the branch "module.h-split", available here:

	git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git

has the complete content.  I've put the header changes after all the
patches from the top 5 categories, so that people bisecting non related
issues at a later date don't get hit with a commit zone with build failures.

The original idea for this cleanup came from Ingo[1], and in that same
thread, I'd posted[2] preliminary data on my work-in-progress.  Also in the
thread, Ingo had some positive feedback (many thanks!) and benchmark
numbers[3], indicating that we really probably want to to go with this.

Since that discussion, I've spawned out to cover allyesconfig builds in
powerpc, sparc, arm, mips, x86, x86-64 in order to hunt down and squash
build failures caused by people assuming module.h content is present.

I am sure that some of the less common arch (DEC Alpha, etc.) may still
have some of these assumptions lingering in their arch specific drivers,
but I don't see fixing these outliers as they arise as an issue.

Anyway, unless there is considerable objection to what is here, I'd like
to have Linus simply pull this directly.  That is what Ingo recommended,
and also my personal preference.  But I'm OK with feeding it in chunkwise
via individual maintainer trees if people want that instead.

Thanks,
Paul.

[1] https://lkml.org/lkml/2011/5/23/76
[2] https://lkml.org/lkml/2011/5/27/459
[3] https://lkml.org/lkml/2011/5/28/60


----

 *** Reminder ***
  Summary below excludes all the boring one line patches.  In the repo:

http://git.kernel.org/?p=linux/kernel/git/paulg/linux.git;a=shortlog;h=refs/heads/module.h-split

  they are after patch #1 and before the #2...#11 listed below.

Paul Gortmaker (11):
  module.h: split out the EXPORT_SYMBOL for faster compiles
  sysdev.h: dont include <linux/module.h> for no reason
  net: inet_timewait_sock doesnt need <linux/module.h>
  device_cgroup.h: delete needless include <linux/module.h>
  crypto.h: remove unused crypto_tfm_alg_modname() inline
  linux/stop_machine.h: fix implicit use of smp.h for smp_processor_id
  pm_runtime.h: explicitly requires notifier.h
  uwb.h: fix implicit use of asm/page.h for PAGE_SIZE
  net: sch_generic remove redundant use of <linux/module.h>
  include: convert various register fcns to macros to avoid include chaining
  include: replace linux/module.h with "struct module" wherever possible

 include/drm/drmP.h               |    3 +-
 include/linux/bcma/bcma.h        |    7 +--
 include/linux/blkdev.h           |    2 +-
 include/linux/cpuidle.h          |    3 +-
 include/linux/crypto.h           |    6 ---
 include/linux/device.h           |   15 ++++--
 include/linux/device_cgroup.h    |    1 -
 include/linux/export.h           |   89 ++++++++++++++++++++++++++++++++++++++
 include/linux/firmware.h         |    2 +-
 include/linux/ftrace.h           |    2 +-
 include/linux/gameport.h         |   17 +++----
 include/linux/hid.h              |    9 ++--
 include/linux/i2c.h              |   10 ++--
 include/linux/ipmi.h             |    3 +-
 include/linux/ipmi_smi.h         |    1 -
 include/linux/mdio-bitbang.h     |    3 +-
 include/linux/module.h           |   68 +----------------------------
 include/linux/mtd/mtd.h          |    3 +-
 include/linux/pci_hotplug.h      |   10 +---
 include/linux/pm_runtime.h       |    1 +
 include/linux/serio.h            |   20 +++++----
 include/linux/ssb/ssb.h          |    7 +--
 include/linux/stop_machine.h     |    1 +
 include/linux/sunrpc/svc_xprt.h  |    3 +-
 include/linux/sysdev.h           |    1 -
 include/linux/textsearch.h       |    3 +-
 include/linux/uio_driver.h       |   12 +++---
 include/linux/usb.h              |    9 ++--
 include/linux/uwb.h              |    1 +
 include/linux/uwb/umc.h          |    7 +--
 include/linux/vlynq.h            |    3 +-
 include/media/saa7146.h          |    3 +-
 include/media/v4l2-int-device.h  |    3 +-
 include/net/inet_timewait_sock.h |    1 -
 include/net/lib80211.h           |    3 +-
 include/net/sch_generic.h        |    1 -
 include/net/sock.h               |    2 +-
 include/sound/core.h             |    2 +-
 include/trace/define_trace.h     |    2 +-
 include/trace/events/module.h    |    2 +-
 40 files changed, 184 insertions(+), 157 deletions(-)
 create mode 100644 include/linux/export.h

-- 
1.7.6

