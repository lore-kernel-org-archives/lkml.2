Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab0JVI4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 04:56:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:41990 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466Ab0JVI4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 04:56:16 -0400
Message-ID: <4CC1518F.6080500@kernel.org>
Date: Fri, 22 Oct 2010 10:55:43 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] workqueue for v2.6.37-rc1
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Oct 2010 08:55:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following branch to receive workqueue changes for
v2.6.37-rc1.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-linus

The branch contains the following notable changes.

* Fix for a subtle bug in HIGHPRI work handling where a HIGHPRI work
  can be delayed by already executing non-HIGHPRI works.

* Addition of flush[_delayed]_work_sync(), which are equivalent to
  cancel[_delayed]_work_sync() and make sure that the flushed work has
  finished execution on all CPUs on return.  This will be primarily
  used to remove flush_scheduled_work() and other workqueue flushes
  with work-specific flushes.

* Several patches removing the use of flush_scheduled_work().  There
  are also multiple patches being routed through other subsystem
  trees.  Once the syncing variants of flush_work are available in
  mainline, more will follow.  The goal is to mark
  flush_scheduled_work() deprecated in the next merge window and
  remove it and trigger WARN_ON_ONCE() on all system workqueue flushes
  in the one after that.

Pulling into the current mainline (d4429f60) generates the following
conflict in fs/gfs2/main.c.  The resolution is WQ_MEM_RECLAIM |
WQ_FREEZEABLE.

@@@ -139,9 -143,9 +143,9 @@@ static int __init init_gfs2_fs(void
  		goto fail_unregister;

  	error = -ENOMEM;
  	gfs_recovery_wq = alloc_workqueue("gfs_recovery",
- 					  WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
 -					  WQ_RESCUER | WQ_FREEZEABLE, 0);
++					  WQ_MEM_RECLAIM | WQ_FREEZEABLE, 0);
  	if (!gfs_recovery_wq)
  		goto fail_wq;

  	gfs2_register_debugfs();

Just in case, the merged branch is available in the following branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git merged

Thanks.

Tejun Heo (14):
      workqueue: implement alloc_ordered_workqueue()
      workqueue: cleanup flush/cancel functions
      workqueue: factor out start_flush_work()
      workqueue: implement flush[_delayed]_work_sync()
      workqueue: prepare for more tracepoints
      workqueue: add queue_work and activate_work trace points
      workqueue: fix HIGHPRI handling in keep_working()
      workqueue: add and use WQ_MEM_RECLAIM flag
      isdn/eicon: don't call flush_scheduled_work() from diva_os_remove_soft_isr()
      pciehp: update workqueue usage
      shpchp: update workqueue usage
      memory_hotplug: drop spurious calls to flush_scheduled_work()
      workqueue: Clarify that schedule_on_each_cpu is synchronous
      workqueue: remove in_workqueue_context()

 Documentation/workqueue.txt             |   29 ++--
 drivers/ata/libata-sff.c                |    2 +-
 drivers/isdn/hardware/eicon/divasmain.c |    2 -
 drivers/pci/hotplug/pciehp.h            |    2 +
 drivers/pci/hotplug/pciehp_core.c       |   18 ++-
 drivers/pci/hotplug/pciehp_ctrl.c       |    9 +-
 drivers/pci/hotplug/pciehp_hpc.c        |   20 +--
 drivers/pci/hotplug/shpchp.h            |    2 +
 drivers/pci/hotplug/shpchp_core.c       |   20 ++-
 drivers/pci/hotplug/shpchp_ctrl.c       |    7 +-
 drivers/pci/hotplug/shpchp_hpc.c        |   26 +---
 fs/gfs2/main.c                          |    2 +-
 fs/xfs/linux-2.6/xfs_buf.c              |    2 +-
 include/linux/workqueue.h               |   51 ++++--
 include/trace/events/workqueue.h        |   77 +++++++-
 kernel/workqueue.c                      |  310 +++++++++++++++++++------------
 mm/memory_hotplug.c                     |    2 -
 17 files changed, 363 insertions(+), 218 deletions(-)

--
tejun
