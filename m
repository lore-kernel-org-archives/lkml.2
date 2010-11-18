Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab0KRQHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:07:38 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:37454 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab0KRQHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:07:33 -0500
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCHv4 00/17] pps: several fixes and improvements
Date: Thu, 18 Nov 2010 19:00:53 +0300
Message-Id: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.2.3
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains several changes that improve an overall
design/performance of PPS subsystem. I'd like these patches to be
merged mainline if no one objects.

Patches 1-3 are bugfixes.
Patches 4-12 are other improvements to PPS subsystem.
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
v3 -> v4:
 * add patch 12
 * fix memory leak when unregistering pps source
 * don't allow to pass NULL timestamp to dcd_change() to simplify the
   code because this possibility is never used
 * decrease SEND_DELAY_MAX from 300ms to 100us because spending 300ms
   with disabled interrupts is inacceptable while 100us can be
   tolerated in some setups
 * integrate Andrew Morton's patch that replaces create_rt_workqueue()
   with create_workqueue()
 * fix issues pointed out by Vitezslav Samel, Rodolfo Giometti,
   Joe Perches, John Stultz and Andrew Morton:
   * fix possible PPS device freeze due to event counter overflow
   * add a workaround for a possible race in tty code to the pps-ldisc
     module; it replaces a previously used workaround in pps subsystem
     code which was worse because it affected all PPS clients. The
     problem with the current tty code is that it uses mutexes for
     locking, but ldisc reference is taken and used in atomic context
     in uart_handle_dcd_change() so it can't lock mutex and therefore
     is race-prone. This issue should be discussed I think, but this
     patch should be ok for now.
   * override pr_fmt(fmt) to automagically print module names
   * add comments describing struct pps_normtime
   * add arch_gettimeoffset() to raw nanoseconds in
     getnstime_raw_and_real()
   * use WARN_ON_ONCE instead of WARN_ON in getnstime_raw_and_real()
   * convert SIGNAL_IS_SET macro in pps_parport to inline function
   * add documentation for pps_gen_parport

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

Alexander Gordeev (17):
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
  pps: timestamp is always passed to dcd_change()
  ntp: add hardpps implementation
  pps: capture MONOTONIC_RAW timestamps as well
  pps: add kernel consumer support
  pps: add parallel port PPS client
  pps: add parallel port PPS signal generator

 Documentation/ioctl/ioctl-number.txt     |    2 +-
 Documentation/pps/pps.txt                |   46 ++++
 Documentation/serial/tty.txt             |    2 +-
 drivers/pps/Kconfig                      |   10 +
 drivers/pps/Makefile                     |    2 +-
 drivers/pps/clients/Kconfig              |    7 +
 drivers/pps/clients/Makefile             |    1 +
 drivers/pps/clients/pps-ktimer.c         |   44 ++--
 drivers/pps/clients/pps-ldisc.c          |   70 +++---
 drivers/pps/clients/pps_parport.c        |  247 +++++++++++++++++
 drivers/pps/generators/Kconfig           |   17 ++
 drivers/pps/generators/Makefile          |    9 +
 drivers/pps/generators/pps_gen_parport.c |  275 +++++++++++++++++++
 drivers/pps/kapi.c                       |  334 +++++++++++------------
 drivers/pps/pps.c                        |  203 +++++++++++---
 include/linux/pps.h                      |    7 +
 include/linux/pps_kernel.h               |   64 ++++-
 include/linux/serial_core.h              |    5 +-
 include/linux/time.h                     |    2 +
 include/linux/timex.h                    |    1 +
 include/linux/tty_ldisc.h                |    7 +-
 kernel/time/ntp.c                        |  425 ++++++++++++++++++++++++++++-
 kernel/time/timekeeping.c                |   38 +++
 23 files changed, 1502 insertions(+), 316 deletions(-)
 create mode 100644 drivers/pps/clients/pps_parport.c
 create mode 100644 drivers/pps/generators/Kconfig
 create mode 100644 drivers/pps/generators/Makefile
 create mode 100644 drivers/pps/generators/pps_gen_parport.c

-- 
1.7.2.3

