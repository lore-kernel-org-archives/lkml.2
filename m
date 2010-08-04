Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204Ab0HDVO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 17:14:27 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:53989 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759043Ab0HDVN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 17:13:56 -0400
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        john stultz <johnstul@us.ibm.com>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>
Subject: [PATCHv3 00/16] pps: several fixes and improvements
Date: Thu,  5 Aug 2010 01:06:37 +0400
Message-Id: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.1
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains several changes that improve an overall
design/performance of PPS subsystem. I'd like these patches to be
merged mainline if no one objects.

Patches 1-3 are bugfixes.
Patches 4-11 are other improvements to PPS subsystem.
Patches 12-14 add kernel consumer support.
Patch 15 adds parallel port PPS client.
Patch 16 adds parallel port PPS generator.

You can find description for my previous patchset (it describes patches
12-16 in more detailed) here: http://lkml.org/lkml/2010/2/24/189

This patchset is tested against the vanilla 2.6.35 kernel. But we are
actually using it on 2.6.33.7-rt29 rt-preempt kernel most of the time.
Those who are interested in other versions of the patchset can find
them in my git repository:
git://github.com/ago/linux-2.6.git

There is one problem however: kernel consumer works bad (if enabled)
when CONFIG_NO_HZ is enabled. The reason for this is commit
a092ff0f90cae22b2ac8028ecd2c6f6c1a9e4601. Without it hardpps() is able
to sync to 1us precision in about 10 seconds. With CONFIG_NO_HZ it is
not syncing at all. This only affects patches 12-14, others are ok.

2John Stultz: the problem is not with logarithmic accumulation because
it works good if NTP_INTERVAL_FREQ is set to 2.

Changelog
v2 -> v3:
 * add patches 1-11
 * add clear_wait parameter to pps_parport
 * add delay parameter to pps_gen_parport
 * fix seqlock unlocking
 * fix issues pointed out by Rodolfo Giometti:
   * move CONFIG_NTP_PPS to drivers/pps/Kconfig
   * swap parport client and generator patches
   * style and typo fixes
 * move patch that adds unified timestamp gathering to be the beginning

v1 -> v2:
 * fix issues pointed out by John Stultz:
   * style fixes
   * add a about the authorship of the original code
   * replace timespec with pps_normtime struct where timespec is used
     in a wrong way
   * fix seqlock usage in hardpps()
 * unbind kernel consumer on device removal
 * send raw timestamp instead of the last difference to hardpps() which
   simplifies the code and is less error-prone
 * update comments in the kernel consumer code to match the reality
 * split the patch that adds MONOTONIC_RAW timestmaps into two
 * other small fixes

Alexander Gordeev (16):
  pps: trivial fixes
  pps: declare variables where they are used in switch
  pps: fix race in PPS_FETCH handler
  pps: unify timestamp gathering
  pps: access pps device by direct pointer
  pps: convert printk/pr_* to dev_*
  pps: move idr stuff to pps.c
  pps: add async PPS event handler
  pps: don't disable interrupts when using spin locks
  pps: use BUG_ON for kernel API safety checks
  pps: simplify conditions a bit
  ntp: add hardpps implementation
  pps: capture MONOTONIC_RAW timestamps as well
  pps: add kernel consumer support
  pps: add parallel port PPS client
  pps: add parallel port PPS signal generator

 Documentation/ioctl/ioctl-number.txt     |    2 +-
 drivers/pps/Kconfig                      |   10 +
 drivers/pps/Makefile                     |    2 +-
 drivers/pps/clients/Kconfig              |    7 +
 drivers/pps/clients/Makefile             |    1 +
 drivers/pps/clients/pps-ktimer.c         |   43 ++--
 drivers/pps/clients/pps-ldisc.c          |   49 ++--
 drivers/pps/clients/pps_parport.c        |  244 +++++++++++++++++
 drivers/pps/generators/Kconfig           |   17 ++
 drivers/pps/generators/Makefile          |    9 +
 drivers/pps/generators/pps_gen_parport.c |  274 +++++++++++++++++++
 drivers/pps/kapi.c                       |  330 +++++++++++-------------
 drivers/pps/pps.c                        |  201 +++++++++++---
 include/linux/pps.h                      |    7 +
 include/linux/pps_kernel.h               |   64 ++++-
 include/linux/serial_core.h              |    5 +-
 include/linux/time.h                     |    2 +
 include/linux/timex.h                    |    1 +
 include/linux/tty_ldisc.h                |    5 +-
 kernel/time/ntp.c                        |  421 ++++++++++++++++++++++++++++-
 kernel/time/timekeeping.c                |   34 +++
 21 files changed, 1419 insertions(+), 309 deletions(-)
 create mode 100644 drivers/pps/clients/pps_parport.c
 create mode 100644 drivers/pps/generators/Kconfig
 create mode 100644 drivers/pps/generators/Makefile
 create mode 100644 drivers/pps/generators/pps_gen_parport.c

