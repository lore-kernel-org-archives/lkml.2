Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416Ab2BNSSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 13:18:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63783 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758884Ab2BNSSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 13:18:05 -0500
Date: Tue, 14 Feb 2012 10:17:52 -0800
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shaohua.li@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH block/for-linus 3/3] block: exit_io_context() should call
 elevator_exit_icq_fn()
Message-ID: <20120214181752.GU12117@google.com>
References: <20120214181245.GS12117@google.com>
 <20120214181623.GT12117@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120214181623.GT12117@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While updating locking, b2efa05265 "block, cfq: unlink
cfq_io_context's immediately" moved elevator_exit_icq_fn() invocation
from exit_io_context() to the final ioc put.  While this doesn't cause
catastrophic failure, it effectively removes task exit notification to
elevator and cause noticeable IO performance degradation with CFQ.

On task exit, CFQ used to immediately expire the slice if it was being
used by the exiting task as no more IO would be issued by the task;
however, after b2efa05265, the notification is lost and disk could sit
idle needlessly, leading to noticeable IO performance degradation for
certain workloads.

This patch renames ioc_exit_icq() to ioc_destroy_icq(), separates
elevator_exit_icq_fn() invocation into ioc_exit_icq() and invokes it
from exit_io_context().  ICQ_EXITED flag is added to avoid invoking
the callback more than once for the same icq.

Walking icq_list from ioc side and invoking elevator callback requires
reverse double locking.  This may be better implemented using RCU;
unfortunately, using RCU isn't trivial.  e.g. RCU protection would
need to cover request_queue and queue_lock switch on cleanup makes
grabbing queue_lock from RCU unsafe.  Reverse double locking should
do, at least for now.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-and-bisected-by: Shaohua Li <shli@kernel.org>
LKML-Reference: <CANejiEVzs=pUhQSTvUppkDcc2TNZyfohBRLygW5zFmXyk5A-xQ@mail.gmail.com>
---
 block/blk-ioc.c           |   55 +++++++++++++++++++++++++++++++++++++++-------
 include/linux/iocontext.h |    1 
 2 files changed, 48 insertions(+), 8 deletions(-)

Index: work/block/blk-ioc.c
===================================================================
--- work.orig/block/blk-ioc.c
+++ work/block/blk-ioc.c
@@ -36,11 +36,23 @@ static void icq_free_icq_rcu(struct rcu_
 	kmem_cache_free(icq->__rcu_icq_cache, icq);
 }
 
-/*
- * Exit and free an icq.  Called with both ioc and q locked.
- */
+/* Exit an icq. Called with both ioc and q locked. */
 static void ioc_exit_icq(struct io_cq *icq)
 {
+	struct elevator_type *et = icq->q->elevator->type;
+
+	if (icq->flags & ICQ_EXITED)
+		return;
+
+	if (et->ops.elevator_exit_icq_fn)
+		et->ops.elevator_exit_icq_fn(icq);
+
+	icq->flags |= ICQ_EXITED;
+}
+
+/* Release an icq.  Called with both ioc and q locked. */
+static void ioc_destroy_icq(struct io_cq *icq)
+{
 	struct io_context *ioc = icq->ioc;
 	struct request_queue *q = icq->q;
 	struct elevator_type *et = q->elevator->type;
@@ -60,8 +72,7 @@ static void ioc_exit_icq(struct io_cq *i
 	if (rcu_dereference_raw(ioc->icq_hint) == icq)
 		rcu_assign_pointer(ioc->icq_hint, NULL);
 
-	if (et->ops.elevator_exit_icq_fn)
-		et->ops.elevator_exit_icq_fn(icq);
+	ioc_exit_icq(icq);
 
 	/*
 	 * @icq->q might have gone away by the time RCU callback runs
@@ -95,7 +106,7 @@ static void ioc_release_fn(struct work_s
 		struct request_queue *q = icq->q;
 
 		if (spin_trylock(q->queue_lock)) {
-			ioc_exit_icq(icq);
+			ioc_destroy_icq(icq);
 			spin_unlock(q->queue_lock);
 		} else {
 			spin_unlock_irqrestore(&ioc->lock, flags);
@@ -142,13 +153,41 @@ EXPORT_SYMBOL(put_io_context);
 void exit_io_context(struct task_struct *task)
 {
 	struct io_context *ioc;
+	struct io_cq *icq;
+	struct hlist_node *n;
+	unsigned long flags;
 
 	task_lock(task);
 	ioc = task->io_context;
 	task->io_context = NULL;
 	task_unlock(task);
 
-	atomic_dec(&ioc->nr_tasks);
+	if (!atomic_dec_and_test(&ioc->nr_tasks)) {
+		put_io_context(ioc);
+		return;
+	}
+
+	/*
+	 * Need ioc lock to walk icq_list and q lock to exit icq.  Perform
+	 * reverse double locking.  Read comment in ioc_release_fn() for
+	 * explanation on the nested locking annotation.
+	 */
+retry:
+	spin_lock_irqsave_nested(&ioc->lock, flags, 1);
+	hlist_for_each_entry(icq, n, &ioc->icq_list, ioc_node) {
+		if (icq->flags & ICQ_EXITED)
+			continue;
+		if (spin_trylock(icq->q->queue_lock)) {
+			ioc_exit_icq(icq);
+			spin_unlock(icq->q->queue_lock);
+		} else {
+			spin_unlock_irqrestore(&ioc->lock, flags);
+			cpu_relax();
+			goto retry;
+		}
+	}
+	spin_unlock_irqrestore(&ioc->lock, flags);
+
 	put_io_context(ioc);
 }
 
@@ -168,7 +207,7 @@ void ioc_clear_queue(struct request_queu
 		struct io_context *ioc = icq->ioc;
 
 		spin_lock(&ioc->lock);
-		ioc_exit_icq(icq);
+		ioc_destroy_icq(icq);
 		spin_unlock(&ioc->lock);
 	}
 }
Index: work/include/linux/iocontext.h
===================================================================
--- work.orig/include/linux/iocontext.h
+++ work/include/linux/iocontext.h
@@ -8,6 +8,7 @@
 enum {
 	ICQ_IOPRIO_CHANGED	= 1 << 0,
 	ICQ_CGROUP_CHANGED	= 1 << 1,
+	ICQ_EXITED		= 1 << 2,
 
 	ICQ_CHANGED_MASK	= ICQ_IOPRIO_CHANGED | ICQ_CGROUP_CHANGED,
 };
