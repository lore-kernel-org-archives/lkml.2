Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab1DEPbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:31:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58013 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab1DEPbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:31:34 -0400
Message-Id: <20110405152729.232781355@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 05 Apr 2011 17:23:51 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 13/21] sched: Add p->pi_lock to task_rq_lock()
References: <20110405152338.692966333@chello.nl>
Content-Disposition: inline; filename=sched-ttwu-task_rq_lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to be able to call set_task_cpu() while either holding
p->pi_lock or task_rq(p)->lock we need to hold both locks in order to
stabilize task_rq().

This makes task_rq_lock() acquire both locks, and have
__task_rq_lock() validate that p->pi_lock is held. This increases the
locking overhead for most scheduler syscalls but allows reduction of
rq->lock contention for some scheduler hot paths (ttwu).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
---
 kernel/sched.c |  103 ++++++++++++++++++++++++++-------------------------------
 1 file changed, 47 insertions(+), 56 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -600,7 +600,7 @@ static inline int cpu_of(struct rq *rq)
  * Return the group to which this tasks belongs.
  *
  * We use task_subsys_state_check() and extend the RCU verification
- * with lockdep_is_held(&task_rq(p)->lock) because cpu_cgroup_attach()
+ * with lockdep_is_held(&p->pi_lock) because cpu_cgroup_attach()
  * holds that lock for each task it moves into the cgroup. Therefore
  * by holding that lock, we pin the task to the current cgroup.
  */
@@ -610,7 +610,7 @@ static inline struct task_group *task_gr
 	struct cgroup_subsys_state *css;
 
 	css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
-			lockdep_is_held(&task_rq(p)->lock));
+			lockdep_is_held(&p->pi_lock));
 	tg = container_of(css, struct task_group, css);
 
 	return autogroup_task_group(p, tg);
@@ -926,23 +926,15 @@ static inline void finish_lock_switch(st
 #endif /* __ARCH_WANT_UNLOCKED_CTXSW */
 
 /*
- * Check whether the task is waking, we use this to synchronize ->cpus_allowed
- * against ttwu().
- */
-static inline int task_is_waking(struct task_struct *p)
-{
-	return unlikely(p->state == TASK_WAKING);
-}
-
-/*
- * __task_rq_lock - lock the runqueue a given task resides on.
- * Must be called interrupts disabled.
+ * __task_rq_lock - lock the rq @p resides on.
  */
 static inline struct rq *__task_rq_lock(struct task_struct *p)
 	__acquires(rq->lock)
 {
 	struct rq *rq;
 
+	lockdep_assert_held(&p->pi_lock);
+
 	for (;;) {
 		rq = task_rq(p);
 		raw_spin_lock(&rq->lock);
@@ -953,22 +945,22 @@ static inline struct rq *__task_rq_lock(
 }
 
 /*
- * task_rq_lock - lock the runqueue a given task resides on and disable
- * interrupts. Note the ordering: we can safely lookup the task_rq without
- * explicitly disabling preemption.
+ * task_rq_lock - lock p->pi_lock and lock the rq @p resides on.
  */
 static struct rq *task_rq_lock(struct task_struct *p, unsigned long *flags)
+	__acquires(p->pi_lock)
 	__acquires(rq->lock)
 {
 	struct rq *rq;
 
 	for (;;) {
-		local_irq_save(*flags);
+		raw_spin_lock_irqsave(&p->pi_lock, *flags);
 		rq = task_rq(p);
 		raw_spin_lock(&rq->lock);
 		if (likely(rq == task_rq(p)))
 			return rq;
-		raw_spin_unlock_irqrestore(&rq->lock, *flags);
+		raw_spin_unlock(&rq->lock);
+		raw_spin_unlock_irqrestore(&p->pi_lock, *flags);
 	}
 }
 
@@ -978,10 +970,13 @@ static void __task_rq_unlock(struct rq *
 	raw_spin_unlock(&rq->lock);
 }
 
-static inline void task_rq_unlock(struct rq *rq, unsigned long *flags)
+static inline void
+task_rq_unlock(struct rq *rq, struct task_struct *p, unsigned long *flags)
 	__releases(rq->lock)
+	__releases(p->pi_lock)
 {
-	raw_spin_unlock_irqrestore(&rq->lock, *flags);
+	raw_spin_unlock(&rq->lock);
+	raw_spin_unlock_irqrestore(&p->pi_lock, *flags);
 }
 
 /*
@@ -2178,6 +2173,11 @@ void set_task_cpu(struct task_struct *p,
 	 */
 	WARN_ON_ONCE(p->state != TASK_RUNNING && p->state != TASK_WAKING &&
 			!(task_thread_info(p)->preempt_count & PREEMPT_ACTIVE));
+
+#ifdef CONFIG_LOCKDEP
+	WARN_ON_ONCE(debug_locks && !(lockdep_is_held(&p->pi_lock) ||
+				      lockdep_is_held(&task_rq(p)->lock)));
+#endif
 #endif
 
 	trace_sched_migrate_task(p, new_cpu);
@@ -2273,7 +2273,7 @@ unsigned long wait_task_inactive(struct 
 		ncsw = 0;
 		if (!match_state || p->state == match_state)
 			ncsw = p->nvcsw | LONG_MIN; /* sets MSB */
-		task_rq_unlock(rq, &flags);
+		task_rq_unlock(rq, p, &flags);
 
 		/*
 		 * If it changed from the expected state, bail out now.
@@ -2639,6 +2639,7 @@ static void __sched_fork(struct task_str
  */
 void sched_fork(struct task_struct *p, int clone_flags)
 {
+	unsigned long flags;
 	int cpu = get_cpu();
 
 	__sched_fork(p);
@@ -2689,9 +2690,9 @@ void sched_fork(struct task_struct *p, i
 	 *
 	 * Silence PROVE_RCU.
 	 */
-	rcu_read_lock();
+	raw_spin_lock_irqsave(&p->pi_lock, flags);
 	set_task_cpu(p, cpu);
-	rcu_read_unlock();
+	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	if (likely(sched_info_on()))
@@ -2740,7 +2741,7 @@ void wake_up_new_task(struct task_struct
 	set_task_cpu(p, cpu);
 
 	p->state = TASK_RUNNING;
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, p, &flags);
 #endif
 
 	rq = task_rq_lock(p, &flags);
@@ -2751,7 +2752,7 @@ void wake_up_new_task(struct task_struct
 	if (p->sched_class->task_woken)
 		p->sched_class->task_woken(rq, p);
 #endif
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, p, &flags);
 	put_cpu();
 }
 
@@ -3476,12 +3477,12 @@ void sched_exec(void)
 	    likely(cpu_active(dest_cpu)) && need_migrate_task(p)) {
 		struct migration_arg arg = { p, dest_cpu };
 
-		task_rq_unlock(rq, &flags);
+		task_rq_unlock(rq, p, &flags);
 		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
 		return;
 	}
 unlock:
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, p, &flags);
 }
 
 #endif
@@ -3518,7 +3519,7 @@ unsigned long long task_delta_exec(struc
 
 	rq = task_rq_lock(p, &flags);
 	ns = do_task_delta_exec(p, rq);
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, p, &flags);
 
 	return ns;
 }
@@ -3536,7 +3537,7 @@ unsigned long long task_sched_runtime(st
 
 	rq = task_rq_lock(p, &flags);
 	ns = p->se.sum_exec_runtime + do_task_delta_exec(p, rq);
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, p, &flags);
 
 	return ns;
 }
@@ -3560,7 +3561,7 @@ unsigned long long thread_group_sched_ru
 	rq = task_rq_lock(p, &flags);
 	thread_group_cputime(p, &totals);
 	ns = totals.sum_exec_runtime + do_task_delta_exec(p, rq);
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, p, &flags);
 
 	return ns;
 }
@@ -4675,16 +4676,13 @@ EXPORT_SYMBOL(sleep_on_timeout);
  */
 void rt_mutex_setprio(struct task_struct *p, int prio)
 {
-	unsigned long flags;
 	int oldprio, on_rq, running;
 	struct rq *rq;
 	const struct sched_class *prev_class;
 
 	BUG_ON(prio < 0 || prio > MAX_PRIO);
 
-	lockdep_assert_held(&p->pi_lock);
-
-	rq = task_rq_lock(p, &flags);
+	rq = __task_rq_lock(p);
 
 	trace_sched_pi_setprio(p, prio);
 	oldprio = p->prio;
@@ -4709,7 +4707,7 @@ void rt_mutex_setprio(struct task_struct
 		enqueue_task(rq, p, oldprio < prio ? ENQUEUE_HEAD : 0);
 
 	check_class_changed(rq, p, prev_class, oldprio);
-	task_rq_unlock(rq, &flags);
+	__task_rq_unlock(rq);
 }
 
 #endif
@@ -4757,7 +4755,7 @@ void set_user_nice(struct task_struct *p
 			resched_task(rq->curr);
 	}
 out_unlock:
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, p, &flags);
 }
 EXPORT_SYMBOL(set_user_nice);
 
@@ -4979,20 +4977,17 @@ static int __sched_setscheduler(struct t
 	/*
 	 * make sure no PI-waiters arrive (or leave) while we are
 	 * changing the priority of the task:
-	 */
-	raw_spin_lock_irqsave(&p->pi_lock, flags);
-	/*
+	 *
 	 * To be able to change p->policy safely, the apropriate
 	 * runqueue lock must be held.
 	 */
-	rq = __task_rq_lock(p);
+	rq = task_rq_lock(p, &flags);
 
 	/*
 	 * Changing the policy of the stop threads its a very bad idea
 	 */
 	if (p == rq->stop) {
-		__task_rq_unlock(rq);
-		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+		task_rq_unlock(rq, p, &flags);
 		return -EINVAL;
 	}
 
@@ -5005,8 +5000,7 @@ static int __sched_setscheduler(struct t
 		if (rt_bandwidth_enabled() && rt_policy(policy) &&
 				task_group(p)->rt_bandwidth.rt_runtime == 0 &&
 				!task_group_is_autogroup(task_group(p))) {
-			__task_rq_unlock(rq);
-			raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+			task_rq_unlock(rq, p, &flags);
 			return -EPERM;
 		}
 	}
@@ -5015,8 +5009,7 @@ static int __sched_setscheduler(struct t
 	/* recheck policy now with rq lock held */
 	if (unlikely(oldpolicy != -1 && oldpolicy != p->policy)) {
 		policy = oldpolicy = -1;
-		__task_rq_unlock(rq);
-		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+		task_rq_unlock(rq, p, &flags);
 		goto recheck;
 	}
 	on_rq = p->on_rq;
@@ -5038,8 +5031,7 @@ static int __sched_setscheduler(struct t
 		activate_task(rq, p, 0);
 
 	check_class_changed(rq, p, prev_class, oldprio);
-	__task_rq_unlock(rq);
-	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+	task_rq_unlock(rq, p, &flags);
 
 	rt_mutex_adjust_pi(p);
 
@@ -5620,7 +5612,7 @@ SYSCALL_DEFINE2(sched_rr_get_interval, p
 
 	rq = task_rq_lock(p, &flags);
 	time_slice = p->sched_class->get_rr_interval(rq, p);
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, p, &flags);
 
 	rcu_read_unlock();
 	jiffies_to_timespec(time_slice, &t);
@@ -5843,8 +5835,7 @@ int set_cpus_allowed_ptr(struct task_str
 	unsigned int dest_cpu;
 	int ret = 0;
 
-	raw_spin_lock_irqsave(&p->pi_lock, flags);
-	rq = __task_rq_lock(p);
+	rq = task_rq_lock(p, &flags);
 
 	if (!cpumask_intersects(new_mask, cpu_active_mask)) {
 		ret = -EINVAL;
@@ -5872,15 +5863,13 @@ int set_cpus_allowed_ptr(struct task_str
 	if (need_migrate_task(p)) {
 		struct migration_arg arg = { p, dest_cpu };
 		/* Need help from migration thread: drop lock and wait. */
-		__task_rq_unlock(rq);
-		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+		task_rq_unlock(rq, p, &flags);
 		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
 		tlb_migrate_finish(p->mm);
 		return 0;
 	}
 out:
-	__task_rq_unlock(rq);
-	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+	task_rq_unlock(rq, p, &flags);
 
 	return ret;
 }
@@ -5908,6 +5897,7 @@ static int __migrate_task(struct task_st
 	rq_src = cpu_rq(src_cpu);
 	rq_dest = cpu_rq(dest_cpu);
 
+	raw_spin_lock(&p->pi_lock);
 	double_rq_lock(rq_src, rq_dest);
 	/* Already moved. */
 	if (task_cpu(p) != src_cpu)
@@ -5930,6 +5920,7 @@ static int __migrate_task(struct task_st
 	ret = 1;
 fail:
 	double_rq_unlock(rq_src, rq_dest);
+	raw_spin_unlock(&p->pi_lock);
 	return ret;
 }
 
@@ -8656,7 +8647,7 @@ void sched_move_task(struct task_struct 
 	if (on_rq)
 		enqueue_task(rq, tsk, 0);
 
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, tsk, &flags);
 }
 #endif /* CONFIG_CGROUP_SCHED */
 


