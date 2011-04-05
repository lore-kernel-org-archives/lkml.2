Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab1DEPbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:31:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:60389 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab1DEPbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:31:22 -0400
Message-Id: <20110405152728.990364093@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 05 Apr 2011 17:23:45 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 07/21] sched: Serialize p->cpus_allowed and ttwu() using p->pi_lock
References: <20110405152338.692966333@chello.nl>
Content-Disposition: inline; filename=sched-pi_lock-wakeup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently p->pi_lock already serializes p->sched_class, also put
p->cpus_allowed and try_to_wake_up() under it, this prepares the way
to do the first part of ttwu() without holding rq->lock.

By having p->sched_class and p->cpus_allowed serialized by p->pi_lock,
we prepare the way to call select_task_rq() without holding rq->lock.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
---
 kernel/sched.c |   37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2301,7 +2301,7 @@ void task_oncpu_function_call(struct tas
 
 #ifdef CONFIG_SMP
 /*
- * ->cpus_allowed is protected by either TASK_WAKING or rq->lock held.
+ * ->cpus_allowed is protected by both rq->lock and p->pi_lock
  */
 static int select_fallback_rq(int cpu, struct task_struct *p)
 {
@@ -2334,7 +2334,7 @@ static int select_fallback_rq(int cpu, s
 }
 
 /*
- * The caller (fork, wakeup) owns TASK_WAKING, ->cpus_allowed is stable.
+ * The caller (fork, wakeup) owns p->pi_lock, ->cpus_allowed is stable.
  */
 static inline
 int select_task_rq(struct rq *rq, struct task_struct *p, int sd_flags, int wake_flags)
@@ -2450,7 +2450,8 @@ static int try_to_wake_up(struct task_st
 	this_cpu = get_cpu();
 
 	smp_wmb();
-	rq = task_rq_lock(p, &flags);
+	raw_spin_lock_irqsave(&p->pi_lock, flags);
+	rq = __task_rq_lock(p);
 	if (!(p->state & state))
 		goto out;
 
@@ -2508,7 +2509,8 @@ static int try_to_wake_up(struct task_st
 	ttwu_stat(rq, p, cpu, wake_flags);
 	success = 1;
 out:
-	task_rq_unlock(rq, &flags);
+	__task_rq_unlock(rq);
+	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 	put_cpu();
 
 	return success;
@@ -4543,6 +4545,8 @@ void rt_mutex_setprio(struct task_struct
 
 	BUG_ON(prio < 0 || prio > MAX_PRIO);
 
+	lockdep_assert_held(&p->pi_lock);
+
 	rq = task_rq_lock(p, &flags);
 
 	trace_sched_pi_setprio(p, prio);
@@ -5150,7 +5154,6 @@ long sched_getaffinity(pid_t pid, struct
 {
 	struct task_struct *p;
 	unsigned long flags;
-	struct rq *rq;
 	int retval;
 
 	get_online_cpus();
@@ -5165,9 +5168,9 @@ long sched_getaffinity(pid_t pid, struct
 	if (retval)
 		goto out_unlock;
 
-	rq = task_rq_lock(p, &flags);
+	raw_spin_lock_irqsave(&p->pi_lock, flags);
 	cpumask_and(mask, &p->cpus_allowed, cpu_online_mask);
-	task_rq_unlock(rq, &flags);
+	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 
 out_unlock:
 	rcu_read_unlock();
@@ -5652,18 +5655,8 @@ int set_cpus_allowed_ptr(struct task_str
 	unsigned int dest_cpu;
 	int ret = 0;
 
-	/*
-	 * Serialize against TASK_WAKING so that ttwu() and wunt() can
-	 * drop the rq->lock and still rely on ->cpus_allowed.
-	 */
-again:
-	while (task_is_waking(p))
-		cpu_relax();
-	rq = task_rq_lock(p, &flags);
-	if (task_is_waking(p)) {
-		task_rq_unlock(rq, &flags);
-		goto again;
-	}
+	raw_spin_lock_irqsave(&p->pi_lock, flags);
+	rq = __task_rq_lock(p);
 
 	if (!cpumask_intersects(new_mask, cpu_active_mask)) {
 		ret = -EINVAL;
@@ -5691,13 +5684,15 @@ int set_cpus_allowed_ptr(struct task_str
 	if (migrate_task(p, rq)) {
 		struct migration_arg arg = { p, dest_cpu };
 		/* Need help from migration thread: drop lock and wait. */
-		task_rq_unlock(rq, &flags);
+		__task_rq_unlock(rq);
+		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
 		tlb_migrate_finish(p->mm);
 		return 0;
 	}
 out:
-	task_rq_unlock(rq, &flags);
+	__task_rq_unlock(rq);
+	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 
 	return ret;
 }


