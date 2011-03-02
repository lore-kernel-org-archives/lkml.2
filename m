Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab1CBRrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:47:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:45931 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756596Ab1CBRqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:46:49 -0500
Message-Id: <20110302174121.124040063@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 02 Mar 2011 18:38:43 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 12/22] sched: Also serialize ttwu_local() with p->pi_lock
References: <20110302173831.295031866@chello.nl>
Content-Disposition: inline; filename=sched-ttwu_local.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we now serialize ttwu() using p->pi_lock, we also need to
serialize ttwu_local() using that, otherwise, once we drop the
rq->lock from ttwu() it can race with ttwu_local().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 kernel/sched.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2559,9 +2559,9 @@ static int try_to_wake_up(struct task_st
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
@@ -2569,16 +2569,21 @@ static void try_to_wake_up_local(struct 
 
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
@@ -4082,6 +4087,7 @@ pick_next_task(struct rq *rq)
  */
 asmlinkage void __sched schedule(void)
 {
+	struct task_struct *to_wakeup = NULL;
 	struct task_struct *prev, *next;
 	unsigned long *switch_count;
 	struct rq *rq;
@@ -4115,21 +4121,21 @@ asmlinkage void __sched schedule(void)
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
 		switch_count = &prev->nvcsw;
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
 


