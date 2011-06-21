Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab1FUXrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 19:47:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33156 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196Ab1FUXqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 19:46:43 -0400
Message-Id: <20110621233648.861571721@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 22 Jun 2011 01:34:46 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [RFC][PATCH 2/3] sched, workqueue: Move WQ-sleeper wakeup
References: <20110621233444.094372367@chello.nl>
Content-Disposition: inline; filename=tglx2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While Thomas was annoyed with the block bits, he found no reason for the WQ
bits to be as they are, the signal thing can only avoid a wakeup, extra wakeups
for the WQ bits increase concurrency (in as far as signals are relevant to
kthreads at all).

Moving the WQ bits allow us to do away with try_to_wake_up_local, removing
more lines.

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   60 ++++++++++++---------------------------------------------
 1 file changed, 13 insertions(+), 47 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2703,40 +2703,6 @@ try_to_wake_up(struct task_struct *p, un
 }
 
 /**
- * try_to_wake_up_local - try to wake up a local task with rq lock held
- * @p: the thread to be awakened
- *
- * Put @p on the run-queue if it's not already there. The caller must
- * ensure that this_rq() is locked, @p is bound to this_rq() and not
- * the current task.
- */
-static void try_to_wake_up_local(struct task_struct *p)
-{
-	struct rq *rq = task_rq(p);
-
-	BUG_ON(rq != this_rq());
-	BUG_ON(p == current);
-	lockdep_assert_held(&rq->lock);
-
-	if (!raw_spin_trylock(&p->pi_lock)) {
-		raw_spin_unlock(&rq->lock);
-		raw_spin_lock(&p->pi_lock);
-		raw_spin_lock(&rq->lock);
-	}
-
-	if (!(p->state & TASK_NORMAL))
-		goto out;
-
-	if (!p->on_rq)
-		ttwu_activate(rq, p, ENQUEUE_WAKEUP);
-
-	ttwu_do_wakeup(rq, p, 0);
-	ttwu_stat(p, smp_processor_id(), 0);
-out:
-	raw_spin_unlock(&p->pi_lock);
-}
-
-/**
  * wake_up_process - Wake up a specific process
  * @p: The process to be woken up.
  *
@@ -4215,6 +4181,19 @@ static inline void sched_submit_work(voi
 
 	if (tsk->state && !(preempt_count() & PREEMPT_ACTIVE)) {
 		/*
+		 * If a worker went to sleep, notify and ask workqueue
+		 * whether it wants to wake up a task to maintain
+		 * concurrency.
+		 */
+		if (tsk->flags & PF_WQ_WORKER) {
+			struct task_struct *to_wakeup;
+
+			to_wakeup = wq_worker_sleeping(tsk, smp_processor_id());
+			if (to_wakeup)
+				wake_up_process(to_wakeup);
+		}
+
+		/*
 		 * If we are going to sleep and we have plugged IO
 		 * queued, make sure to submit it to avoid deadlocks.
 		 */
@@ -4256,19 +4235,6 @@ asmlinkage void __sched schedule(void)
 		} else {
 			deactivate_task(rq, prev, DEQUEUE_SLEEP);
 			prev->on_rq = 0;
-
-			/*
-			 * If a worker went to sleep, notify and ask workqueue
-			 * whether it wants to wake up a task to maintain
-			 * concurrency.
-			 */
-			if (prev->flags & PF_WQ_WORKER) {
-				struct task_struct *to_wakeup;
-
-				to_wakeup = wq_worker_sleeping(prev, cpu);
-				if (to_wakeup)
-					try_to_wake_up_local(to_wakeup);
-			}
 		}
 		switch_count = &prev->nvcsw;
 	}


