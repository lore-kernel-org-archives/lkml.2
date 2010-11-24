Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab0KXQZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 11:25:13 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:55559 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332Ab0KXQZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 11:25:11 -0500
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>
Subject: [PATCHv5 00/17] pps: several fixes and improvements
Date: Wed, 24 Nov 2010 19:15:38 +0300
Message-Id: <cover.1290599843.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.2.3
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains several changes that improve an overall
design/performance of PPS subsystem. I'd like these patches to be
merged mainline if no one objects.

Patches 1-4 are bugfixes.
Patches 5-12 are other improvements to PPS subsystem.
Patches 13-15 add kernel consumer support.
Patch 16 adds parallel port PPS client.
Patch 17 adds parallel port PPS generator.

You can find description for my previous patchset (it describes patches
13-17 in more detailed) here: http://lkml.org/lkml/2010/2/24/189

This patchset is tested against the vanilla 2.6.36 kernel. But we are
actually using it on 2.6.33.7-rt29 rt-preempt kernel most of the time.
Those who are interested in other versions of the patchset can find
them in my git repository:
git://github.com/ago/linux-2.6.git

There is one problem however: kernel consumer works bad (if enabled)
when CONFIG_NO_HZ is enabled. The reason for this is commit
a092ff0f90cae22b2ac8028ecd2c6f6c1a9e4601. Without it hardpps() is able
to sync to 1us precision in about 10 seconds. With CONFIG_NO_HZ it is
not syncing at all. This only affects patches 13-15, others are ok.

Changelog
v4 -> v5:
 * drop patch that adds PPS workqueue, it needs some more thinking
 * replace patch that stops disabling interrupts with a lighter version
 * add patch 5 which ensures that dcd_change() will never be called
   before tty_ldisc_open() or after tty_ldisc_close()
 * fix patch 7: convert all remaining prints
 * use BUG_ON only in pps_event
 * use "canonical" error-handling style in pps_tty_open

Alexander Gordeev (17):
  pps: trivial fixes
  pps: declare variables where they are used in switch
  pps: fix race in PPS_FETCH handler
  pps: unify timestamp gathering
  tty: don't allow ldisc dcd_change() after ldisc halt
  pps: access pps device by direct pointer
  pps: convert printk/pr_* to dev_*
  pps: move idr stuff to pps.c
  pps: do not disable interrupts for idr operations
  pps: use BUG_ON for kernel API safety checks
  pps: simplify conditions a bit
  pps: timestamp is always passed to dcd_change()
  ntp: add hardpps implementation
  pps: capture MONOTONIC_RAW timestamps as well
  pps: add kernel consumer support
  pps: add parallel port PPS client
  pps: add parallel port PPS signal generator

 Documentation/ioctl/ioctl-number.txt     |    2 +-
 Documentation/pps/pps.txt                |   46 ++++
 Documentation/serial/tty.txt             |    2 +-
 drivers/char/tty_io.c                    |    1 +
 drivers/char/tty_ldisc.c                 |    7 +
 drivers/pps/Kconfig                      |   10 +
 drivers/pps/Makefile                     |    2 +-
 drivers/pps/clients/Kconfig              |    7 +
 drivers/pps/clients/Makefile             |    1 +
 drivers/pps/clients/pps-ktimer.c         |   44 ++--
 drivers/pps/clients/pps-ldisc.c          |   54 ++---
 drivers/pps/clients/pps_parport.c        |  247 +++++++++++++++++
 drivers/pps/generators/Kconfig           |   17 ++
 drivers/pps/generators/Makefile          |    9 +
 drivers/pps/generators/pps_gen_parport.c |  275 +++++++++++++++++++
 drivers/pps/kapi.c                       |  221 +++++-----------
 drivers/pps/pps.c                        |  177 ++++++++++---
 include/linux/pps.h                      |    7 +
 include/linux/pps_kernel.h               |   54 +++-
 include/linux/serial_core.h              |   23 +-
 include/linux/time.h                     |    2 +
 include/linux/timex.h                    |    1 +
 include/linux/tty.h                      |    1 +
 include/linux/tty_ldisc.h                |    7 +-
 kernel/time/ntp.c                        |  425 ++++++++++++++++++++++++++++-
 kernel/time/timekeeping.c                |   38 +++
 26 files changed, 1387 insertions(+), 293 deletions(-)
 create mode 100644 drivers/pps/clients/pps_parport.c
 create mode 100644 drivers/pps/generators/Kconfig
 create mode 100644 drivers/pps/generators/Makefile
 create mode 100644 drivers/pps/generators/pps_gen_parport.c

-- 
1.7.2.3

