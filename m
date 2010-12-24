Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab0LXMmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 07:42:39 -0500
Received: from canuck.infradead.org ([134.117.69.58]:54555 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab0LXMm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 07:42:27 -0500
Message-Id: <20101224123743.153269445@chello.nl>
User-Agent: quilt/0.48-1
Date: Fri, 24 Dec 2010 13:23:51 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 13/17] sched: Remove rq->lock from the first half of ttwu()
References: <20101224122338.172750730@chello.nl>
Content-Disposition: inline; filename=sched-ttwu-optimize.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently ttwu() does two rq->lock acquisitions, once on the task's
old rq, holding it over the p->state fiddling and load-balance pass.
Then it drops the old rq->lock to acquire the new rq->lock.

By having serialized ttwu(), p->sched_class, p->cpus_allowed with
p->pi_lock, we can now drop the whole first rq->lock acquisition.

The p->pi_lock serializing concurrent ttwu() calls protects p->state,
which we will set to TASK_WAKING to bridge possible p->pi_lock to
rq->lock gaps and serialize set_task_cpu() calls against
task_rq_lock().

The p->pi_lock serialization of p->sched_class allows us to call
scheduling class methods without holding the rq->lock, and the
serialization of p->cpus_allowed allows us to do the load-balancing
bits without races.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c      |   57 ++++++++++++++++++++++++++--------------------------
 kernel/sched_fair.c |    3 --
 2 files changed, 30 insertions(+), 30 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2440,69 +2440,70 @@ ttwu_post_activation(struct task_struct 
  * Returns %true if @p was woken up, %false if it was already running
  * or @state didn't match @p's state.
  */
-static int try_to_wake_up(struct task_struct *p, unsigned int state,
-			  int wake_flags)
+static int
+try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 {
-	int cpu, orig_cpu, this_cpu, success = 0;
+	int cpu, this_cpu, success = 0;
 	unsigned long flags;
-	unsigned long en_flags = ENQUEUE_WAKEUP;
 	struct rq *rq;
 
 	this_cpu = get_cpu();
 
 	smp_wmb();
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
-	rq = __task_rq_lock(p);
 	if (!(p->state & state))
 		goto out;
 
 	cpu = task_cpu(p);
 
-	if (p->on_rq)
-		goto out_running;
+	if (p->on_rq) {
+		rq = __task_rq_lock(p);
+		if (p->on_rq)
+			goto out_running;
+		__task_rq_unlock(rq);
+	}
 
-	orig_cpu = cpu;
 #ifdef CONFIG_SMP
-	if (unlikely(task_running(rq, p)))
-		goto out_activate;
+	while (p->on_cpu)
+		cpu_relax();
 
 	p->sched_contributes_to_load = !!task_contributes_to_load(p);
 	p->state = TASK_WAKING;
+	/*
+	 * Separate the TASK_WAKING write from the rq->lock unlock wait.
+	 *
+	 * We need to wait for the current rq->lock owner to finish because
+	 * existing task_rq_lock() holders will not have observed
+	 * TASK_WAKING yet and we don't want to move the task from under
+	 * their feet.
+	 */
+	smp_mb();
+	raw_spin_unlock_wait(&task_rq(p)->lock);
 
-	if (p->sched_class->task_waking) {
+	if (p->sched_class->task_waking)
 		p->sched_class->task_waking(p);
-		en_flags |= ENQUEUE_WAKING;
-	}
 
 	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
-	if (cpu != orig_cpu)
-		set_task_cpu(p, cpu);
-	__task_rq_unlock(rq);
+#endif /* CONFIG_SMP */
 
 	rq = cpu_rq(cpu);
 	raw_spin_lock(&rq->lock);
 
-	/*
-	 * We migrated the task without holding either rq->lock, however
-	 * since the task is not on the task list itself, nobody else
-	 * will try and migrate the task, hence the rq should match the
-	 * cpu we just moved it to.
-	 */
-	WARN_ON(task_cpu(p) != cpu);
-	WARN_ON(p->state != TASK_WAKING);
+#ifdef CONFIG_SMP
+	if (cpu != task_cpu(p))
+		set_task_cpu(p, cpu);
 
 	if (p->sched_contributes_to_load)
 		rq->nr_uninterruptible--;
+#endif
 
-out_activate:
-#endif /* CONFIG_SMP */
-	activate_task(rq, p, en_flags);
+	activate_task(rq, p, ENQUEUE_WAKEUP | ENQUEUE_WAKING);
 out_running:
 	ttwu_post_activation(p, rq, wake_flags);
 	ttwu_stat(rq, p, cpu, wake_flags);
 	success = 1;
-out:
 	__task_rq_unlock(rq);
+out:
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 	put_cpu();
 
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1343,8 +1343,7 @@ static void task_waking_fair(struct task
 	struct sched_entity *se = &p->se;
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
-	lockdep_assert_held(&task_rq(p)->lock);
-
+	// XXX racy on 32bit
 	se->vruntime -= cfs_rq->min_vruntime;
 }
 


