Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab1DEPb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:31:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:60397 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab1DEPbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:31:24 -0400
Message-Id: <20110405152729.192366907@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 05 Apr 2011 17:23:50 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 12/21] sched: Also serialize ttwu_local() with p->pi_lock
References: <20110405152338.692966333@chello.nl>
Content-Disposition: inline; filename=sched-ttwu_local.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we now serialize ttwu() using p->pi_lock, we also need to
serialize ttwu_local() using that, otherwise, once we drop the
rq->lock from ttwu() it can race with ttwu_local().

Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2560,9 +2560,9 @@ static int try_to_wake_up(struct task_st
  * try_to_wake_up_local - try to wake up a local task with rq lock held
  * @p: the thread to be awakened
  *
- * Put @p on the run-queue if it's not already there.  The caller must
+ * Put @p on the run-queue if it's not already there. The caller must
  * ensure that this_rq() is locked, @p is bound to this_rq() and not
- * the current task.  this_rq() stays locked over invocation.
+ * the current task.
  */
 static void try_to_wake_up_local(struct task_struct *p)
 {
@@ -2570,16 +2570,21 @@ static void try_to_wake_up_local(struct 
 
 	BUG_ON(rq != this_rq());
 	BUG_ON(p == current);
-	lockdep_assert_held(&rq->lock);
+
+	raw_spin_unlock(&rq->lock);
+	raw_spin_lock(&p->pi_lock);
+	raw_spin_lock(&rq->lock);
 
 	if (!(p->state & TASK_NORMAL))
-		return;
+		goto out;
 
 	if (!p->on_rq)
 		activate_task(rq, p, ENQUEUE_WAKEUP);
 
 	ttwu_post_activation(p, rq, 0);
 	ttwu_stat(rq, p, smp_processor_id(), 0);
+out:
+	raw_spin_unlock(&p->pi_lock);
 }
 
 /**
@@ -4084,6 +4089,7 @@ pick_next_task(struct rq *rq)
  */
 asmlinkage void __sched schedule(void)
 {
+	struct task_struct *to_wakeup = NULL;
 	struct task_struct *prev, *next;
 	unsigned long *switch_count;
 	struct rq *rq;
@@ -4114,13 +4120,8 @@ asmlinkage void __sched schedule(void)
 			 * task to maintain concurrency.  If so, wake
 			 * up the task.
 			 */
-			if (prev->flags & PF_WQ_WORKER) {
-				struct task_struct *to_wakeup;
-
+			if (prev->flags & PF_WQ_WORKER)
 				to_wakeup = wq_worker_sleeping(prev, cpu);
-				if (to_wakeup)
-					try_to_wake_up_local(to_wakeup);
-			}
 			deactivate_task(rq, prev, DEQUEUE_SLEEP);
 			prev->on_rq = 0;
 		}
@@ -4137,8 +4138,13 @@ asmlinkage void __sched schedule(void)
 		raw_spin_lock(&rq->lock);
 	}
 
+	/*
+	 * All three: try_to_wake_up_local(), pre_schedule() and idle_balance()
+	 * can drop rq->lock.
+	 */
+	if (to_wakeup)
+		try_to_wake_up_local(to_wakeup);
 	pre_schedule(rq, prev);
-
 	if (unlikely(!rq->nr_running))
 		idle_balance(cpu, rq);
 


