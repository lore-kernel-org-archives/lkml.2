Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab2HCRoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 13:44:09 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:34680 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab2HCRoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 13:44:06 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        padovan@profusion.mobi, marcel@holtmann.org, peterz@infradead.org,
        mingo@redhat.com, davem@davemloft.net, dougthompson@xmission.com,
        ibm-acpi@hmh.eng.br, cbou@mail.ru, rui.zhang@intel.com,
        tomi.valkeinen@ti.com
Subject: 
Date: Fri,  3 Aug 2012 10:43:45 -0700
Message-Id: <1344015839-21800-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

delayed_work has been annoyingly missing the mechanism to modify timer
of a pending delayed_work - ie. mod_timer() counterpart.  delayed_work
users have been working around this using several methods - using an
explicit timer + work item, messing directly with delayed_work->timer,
and canceling before re-queueing, all of which are error-prone and/or
ugly.

Gustavo Padovan posted a RFC implementation[1] of mod_delayed_work() a
while back but it wasn't complete.  To properly implement
mod_delayed_work[_on](), it should be able to steal pending work items
which may be on timer or worklist or anywhere inbetween.  This is
similar to what __cancel_work_timer() does but it turns out that there
are a lot of holes around this area and try_to_grab_pending() needs
considerable amount of work to be used for other purposes too.

This patchset improves canceling and try_to_grab_pending(), use it to
implement mod_delayed_work[_on](), convert easy ones, and drop
__cancel_delayed_work_sync() which doesn't have relevant users
afterwards.

Changes from the first take[L] are,

* All updated patches rolled into the series and Acked-by's added.a

* Tomi Valkeinen pointed out that mod_delayed_work() can't be called
  from IRQ handlers and thus can't replace __cancel_delayed_work()
  users.  __cancel_delayed_work() users dropped from conversion.  This
  will be handled by a future patchset.

* Ensuring preemtion is disabled across PENDING manipulation doesn't
  make try_to_grab_pending() safe to use from bh context and making it
  impossible to replace even cancel_delayed_work() users.  Whole patch
  series updated so that IRQ is disabled across PENDING manipulation
  instead.  As most operations had to grab gcwq->lock anyway, this
  doesn't add extra IRQ toggling.

* try_to_grab_pending() and __cancel_work_timer() updated to take bool
  @is_dwork instead of @timer and disable IRQ on successful return.

This patchset contains the following fourteen patches.

 0001-workqueue-reorder-queueing-functions-so-that-_on-var.patch
 0002-workqueue-make-queueing-functions-return-bool.patch
 0003-workqueue-add-missing-smp_wmb-in-process_one_work.patch
 0004-workqueue-disable-irq-while-manipulating-PENDING.patch
 0005-workqueue-set-delayed_work-timer-function-on-initial.patch
 0006-workqueue-unify-local-CPU-queueing-handling.patch
 0007-workqueue-fix-zero-delay-handling-of-queue_delayed_w.patch
 0008-workqueue-move-try_to_grab_pending-upwards.patch
 0009-workqueue-introduce-WORK_OFFQ_FLAG_.patch
 0010-workqueue-factor-out-__queue_delayed_work-from-queue.patch
 0011-workqueue-reorganize-try_to_grab_pending-and-__cance.patch
 0012-workqueue-mark-a-work-item-being-canceled-as-such.patch
 0013-workqueue-implement-mod_delayed_work-_on.patch
 0014-workqueue-use-mod_delayed_work-instead-of-cancel-que.patch

0001-0003 are preparatory.

0004 removes the possibility of cancel_sync spinning for extended
period of time while another task holding PENDING is preempted or
interrupted.

0005-0007 clean up local queueing handling.

0008-0011 prepare for try_to_grab_pending() improvements.

0012 makes try_to_grab_pending() distinguish transient failure which
can be safely busy-retried and failure because the work item is being
canceled, which may take arbitrary amount of time.

0013 uses the improved try_to_grab_pending() to implement
mod_delayed_work[_on]().

0014 converts cancel + queue sequences to mod_delayed_work().

This patchset is also available at the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-wq-mod_delayed

If nobody objects, I'd like to route this series through wq/for-3.7.
Changes to other subsystems are fairly localized and conflicts, if
they occur, shouldn't be too painful to handle.

Although this ends up adding ~130 LOC, it contains a lot more
documentation, converted only the apparent ones, and IMHO is
worthwhile to have regardless as it removes an annoyance which is
pretty easy to encounter while using delayed_work.

Thanks.

 block/genhd.c                          |    6 
 drivers/edac/edac_mc.c                 |   17 
 drivers/infiniband/core/addr.c         |    4 
 drivers/infiniband/hw/nes/nes_hw.c     |    6 
 drivers/infiniband/hw/nes/nes_nic.c    |    5 
 drivers/net/wireless/ipw2x00/ipw2100.c |    8 
 drivers/net/wireless/zd1211rw/zd_usb.c |    3 
 drivers/platform/x86/thinkpad_acpi.c   |   20 
 drivers/power/charger-manager.c        |    9 
 drivers/power/ds2760_battery.c         |    9 
 drivers/power/jz4740-battery.c         |    6 
 drivers/thermal/thermal_sys.c          |   15 
 fs/afs/callback.c                      |    4 
 fs/afs/server.c                        |   10 
 fs/afs/vlocation.c                     |   14 
 fs/nfs/nfs4renewd.c                    |    3 
 include/linux/workqueue.h              |   47 +-
 kernel/workqueue.c                     |  732 ++++++++++++++++++++-------------
 net/core/dst.c                         |    4 
 net/rfkill/input.c                     |    3 
 20 files changed, 526 insertions(+), 399 deletions(-)

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1159922
[L] http://thread.gmane.org/gmane.linux.kernel/1334546
