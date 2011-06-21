Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab1FUXqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 19:46:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33157 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757475Ab1FUXqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 19:46:44 -0400
Message-Id: <20110621233648.806475812@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 22 Jun 2011 01:34:45 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [RFC][PATCH 1/3] sched, block: Move unplug
References: <20110621233444.094372367@chello.nl>
Content-Disposition: inline; filename=tglx1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas found that we're doing a horrendous amount of work in that scheduler
unplug hook while having preempt and IRQs disabled.

Move it to the head of schedule() where both preemption and IRQs are enabled
such that we don't get these silly long IRQ/preempt disable times.

This allows us to remove a lot of special magic in the unplug path,
simplifying that code as a bonus.

Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 block/blk-core.c       |   28 ++++++++--------------------
 include/linux/blkdev.h |   12 ++----------
 kernel/sched.c         |   26 ++++++++++++++++----------
 3 files changed, 26 insertions(+), 40 deletions(-)

Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c
+++ linux-2.6/block/blk-core.c
@@ -2655,25 +2655,13 @@ static int plug_rq_cmp(void *priv, struc
  * additional stack usage in driver dispatch, in places where the originally
  * plugger did not intend it.
  */
-static void queue_unplugged(struct request_queue *q, unsigned int depth,
-			    bool from_schedule)
+static void queue_unplugged(struct request_queue *q, unsigned int depth)
 	__releases(q->queue_lock)
 {
-	trace_block_unplug(q, depth, !from_schedule);
-
-	/*
-	 * If we are punting this to kblockd, then we can safely drop
-	 * the queue_lock before waking kblockd (which needs to take
-	 * this lock).
-	 */
-	if (from_schedule) {
-		spin_unlock(q->queue_lock);
-		blk_run_queue_async(q);
-	} else {
-		__blk_run_queue(q);
-		spin_unlock(q->queue_lock);
-	}
+	trace_block_unplug(q, depth, true);
 
+	__blk_run_queue(q);
+	spin_unlock(q->queue_lock);
 }
 
 static void flush_plug_callbacks(struct blk_plug *plug)
@@ -2694,7 +2682,7 @@ static void flush_plug_callbacks(struct 
 	}
 }
 
-void blk_flush_plug_list(struct blk_plug *plug, bool from_schedule)
+void blk_flush_plug_list(struct blk_plug *plug)
 {
 	struct request_queue *q;
 	unsigned long flags;
@@ -2732,7 +2720,7 @@ void blk_flush_plug_list(struct blk_plug
 			 * This drops the queue lock
 			 */
 			if (q)
-				queue_unplugged(q, depth, from_schedule);
+				queue_unplugged(q, depth);
 			q = rq->q;
 			depth = 0;
 			spin_lock(q->queue_lock);
@@ -2752,14 +2740,14 @@ void blk_flush_plug_list(struct blk_plug
 	 * This drops the queue lock
 	 */
 	if (q)
-		queue_unplugged(q, depth, from_schedule);
+		queue_unplugged(q, depth);
 
 	local_irq_restore(flags);
 }
 
 void blk_finish_plug(struct blk_plug *plug)
 {
-	blk_flush_plug_list(plug, false);
+	blk_flush_plug_list(plug);
 
 	if (plug == current->plug)
 		current->plug = NULL;
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h
+++ linux-2.6/include/linux/blkdev.h
@@ -870,22 +870,14 @@ struct blk_plug_cb {
 
 extern void blk_start_plug(struct blk_plug *);
 extern void blk_finish_plug(struct blk_plug *);
-extern void blk_flush_plug_list(struct blk_plug *, bool);
+extern void blk_flush_plug_list(struct blk_plug *);
 
 static inline void blk_flush_plug(struct task_struct *tsk)
 {
 	struct blk_plug *plug = tsk->plug;
 
 	if (plug)
-		blk_flush_plug_list(plug, false);
-}
-
-static inline void blk_schedule_flush_plug(struct task_struct *tsk)
-{
-	struct blk_plug *plug = tsk->plug;
-
-	if (plug)
-		blk_flush_plug_list(plug, true);
+		blk_flush_plug_list(plug);
 }
 
 static inline bool blk_needs_flush_plug(struct task_struct *tsk)
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -4209,6 +4209,20 @@ pick_next_task(struct rq *rq)
 	BUG(); /* the idle class will always have a runnable task */
 }
 
+static inline void sched_submit_work(void)
+{
+	struct task_struct *tsk = current;
+
+	if (tsk->state && !(preempt_count() & PREEMPT_ACTIVE)) {
+		/*
+		 * If we are going to sleep and we have plugged IO
+		 * queued, make sure to submit it to avoid deadlocks.
+		 */
+		if (blk_needs_flush_plug(tsk))
+			blk_flush_plug(tsk);
+	}
+}
+
 /*
  * schedule() is the main scheduler function.
  */
@@ -4219,6 +4233,8 @@ asmlinkage void __sched schedule(void)
 	struct rq *rq;
 	int cpu;
 
+	sched_submit_work();
+
 need_resched:
 	preempt_disable();
 	cpu = smp_processor_id();
@@ -4253,16 +4269,6 @@ asmlinkage void __sched schedule(void)
 				if (to_wakeup)
 					try_to_wake_up_local(to_wakeup);
 			}
-
-			/*
-			 * If we are going to sleep and we have plugged IO
-			 * queued, make sure to submit it to avoid deadlocks.
-			 */
-			if (blk_needs_flush_plug(prev)) {
-				raw_spin_unlock(&rq->lock);
-				blk_schedule_flush_plug(prev);
-				raw_spin_lock(&rq->lock);
-			}
 		}
 		switch_count = &prev->nvcsw;
 	}


