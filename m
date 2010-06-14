Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab0FNVl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:41:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:46946 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756719Ab0FNVjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:39:23 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: [PATCHSET] workqueue: concurrency managed workqueue, take#5
Date: Mon, 14 Jun 2010 23:37:17 +0200
Message-Id: <1276551467-21246-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Jun 2010 21:37:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

This is the fifth take of cmwq (concurrency managed workqueue)
patchset.  It's on top of v2.6.35-rc3 + sched/core patches.  Git tree
is available at

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-cmwq

Changes from the last take[L] are...

* fscache patches are omitted for now.

* The patchset is rebased on cpu_stop + sched/core, which now includes
  all the necessary scheduler patches.  cpu_stop already reimplements
  stop_machine so that it doesn't use RT workqueue, so this patchset
  simply drops RT wq support.

* __set_cpus_allowed() was determined to be unnecessary with recent
  scheduler changes.  On cpu re-onlining, cmwq now kills all idle
  workers and tells busy ones to rebind after finishing the current
  work by scheduling a dedicated work.  This allows managing proper
  cpu binding without adding overhead to hotpath.

* Oleg's clear work->data patch moved at the head of the queue and now
  lives in the for-next branch which will be pushed to mainline on the
  next merge window.

* Applied Oleg's review.

  * Comments updated as suggested.

  * work_flags_to_color() replaced w/ get_work_color()

  * nr_cwqs_to_flush bug which could cause premature flush completion
    fixed.

  * Replace rewind + list_for_each_entry_safe_continue() w/
    list_for_each_entry_safe_from().

  * Don't directly write to *work_data_bits() but use __set_bit()
    instead.

  * Fixed cpu hotplug exclusion bug.

* Other misc tweaks.

Now that all scheduler bits are in place, I'll keep the tree stable
and publish it to linux-next soonish, so this hopefully is the last of
exhausting massive postings of this patchset.

Jeff, Arjan, I think it'll be best to route the libata and async
patches through wq tree.  Would that be okay?

This patchset contains the following patches.

 0001-sched-consult-online-mask-instead-of-active-in-selec.patch
 0002-sched-rename-preempt_notifiers-to-sched_notifiers-an.patch
 0003-sched-refactor-try_to_wake_up.patch
 0004-sched-implement-__set_cpus_allowed.patch
 0005-sched-make-sched_notifiers-unconditional.patch
 0006-sched-add-wakeup-sleep-sched_notifiers-and-allow-NUL.patch
 0007-sched-implement-try_to_wake_up_local.patch
 0008-workqueue-change-cancel_work_sync-to-clear-work-data.patch
 0009-acpi-use-queue_work_on-instead-of-binding-workqueue-.patch
 0010-stop_machine-reimplement-without-using-workqueue.patch
 0011-workqueue-misc-cosmetic-updates.patch
 0012-workqueue-merge-feature-parameters-into-flags.patch
 0013-workqueue-define-masks-for-work-flags-and-conditiona.patch
 0014-workqueue-separate-out-process_one_work.patch
 0015-workqueue-temporarily-disable-workqueue-tracing.patch
 0016-workqueue-kill-cpu_populated_map.patch
 0017-workqueue-update-cwq-alignement.patch
 0018-workqueue-reimplement-workqueue-flushing-using-color.patch
 0019-workqueue-introduce-worker.patch
 0020-workqueue-reimplement-work-flushing-using-linked-wor.patch
 0021-workqueue-implement-per-cwq-active-work-limit.patch
 0022-workqueue-reimplement-workqueue-freeze-using-max_act.patch
 0023-workqueue-introduce-global-cwq-and-unify-cwq-locks.patch
 0024-workqueue-implement-worker-states.patch
 0025-workqueue-reimplement-CPU-hotplugging-support-using-.patch
 0026-workqueue-make-single-thread-workqueue-shared-worker.patch
 0027-workqueue-add-find_worker_executing_work-and-track-c.patch
 0028-workqueue-carry-cpu-number-in-work-data-once-executi.patch
 0029-workqueue-implement-WQ_NON_REENTRANT.patch
 0030-workqueue-use-shared-worklist-and-pool-all-workers-p.patch
 0031-workqueue-implement-concurrency-managed-dynamic-work.patch
 0032-workqueue-increase-max_active-of-keventd-and-kill-cu.patch
 0033-workqueue-add-system_wq-system_long_wq-and-system_nr.patch
 0034-workqueue-implement-DEBUGFS-workqueue.patch
 0035-workqueue-implement-several-utility-APIs.patch
 0036-libata-take-advantage-of-cmwq-and-remove-concurrency.patch
 0037-async-use-workqueue-for-worker-pool.patch
 0038-fscache-convert-object-to-use-workqueue-instead-of-s.patch
 0039-fscache-convert-operation-to-use-workqueue-instead-o.patch
 0040-fscache-drop-references-to-slow-work.patch
 0041-cifs-use-workqueue-instead-of-slow-work.patch
 0042-gfs2-use-workqueue-instead-of-slow-work.patch
 0043-slow-work-kill-it.patch

diffstat.

 arch/ia64/kernel/smpboot.c |    2 
 arch/x86/kernel/smpboot.c  |    2 
 drivers/acpi/osl.c         |   40 
 drivers/ata/libata-core.c  |   20 
 drivers/ata/libata-eh.c    |    4 
 drivers/ata/libata-scsi.c  |   10 
 drivers/ata/libata-sff.c   |    9 
 drivers/ata/libata.h       |    1 
 include/linux/cpu.h        |    2 
 include/linux/kthread.h    |    1 
 include/linux/libata.h     |    1 
 include/linux/workqueue.h  |  146 +
 kernel/async.c             |  140 -
 kernel/kthread.c           |   15 
 kernel/power/process.c     |   21 
 kernel/trace/Kconfig       |    4 
 kernel/workqueue.c         | 3313 +++++++++++++++++++++++++++++++++++++++------
 kernel/workqueue_sched.h   |   13 
 lib/Kconfig.debug          |    7 
 19 files changed, 3128 insertions(+), 623 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/954759
