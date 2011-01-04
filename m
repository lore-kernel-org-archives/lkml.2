Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab1ADPMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 10:12:18 -0500
Received: from canuck.infradead.org ([134.117.69.58]:54855 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab1ADPMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 10:12:14 -0500
Message-Id: <20110104150102.862431889@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jan 2011 15:59:40 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 11/18] sched: Add p->pi_lock to task_rq_lock()
References: <20110104145929.772813816@chello.nl>
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
---
 kernel/sched.c |   81 ++++++++++++++++++++++++++-------------------------------
 1 file changed, 37 insertions(+), 44 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -602,7 +602,7 @@ static inline int cpu_of(struct rq *rq)
  * Return the group to which this tasks belongs.
  *
  * We use task_subsys_state_check() and extend the RCU verification
- * with lockdep_is_held(&task_rq(p)->lock) because cpu_cgroup_attach()
+ * with lockdep_is_held(&p->pi_lock) because cpu_cgroup_attach()
  * holds that lock for each task it moves into the cgroup. Therefore
  * by holding that lock, we pin the task to the current cgroup.
  */
@@ -612,7 +612,7 @@ static inline struct task_group *task_gr
 	struct cgroup_subsys_state *css;
 
 	css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
-			lockdep_is_held(&task_rq(p)->lock));
+			lockdep_is_held(&p->pi_lock));
 	tg = container_of(css, struct task_group, css);
 
 	return autogroup_task_group(p, tg);
@@ -928,23 +928,15 @@ static inline void finish_lock_switch(st
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
@@ -955,22 +947,22 @@ static inline struct rq *__task_rq_lock(
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
 
@@ -980,10 +972,13 @@ static void __task_rq_unlock(struct rq *
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
@@ -2115,6 +2110,11 @@ void set_task_cpu(struct task_struct *p,
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
@@ -2210,7 +2210,7 @@ unsigned long wait_task_inactive(struct 
 		ncsw = 0;
 		if (!match_state || p->state == match_state)
 			ncsw = p->nvcsw | LONG_MIN; /* sets MSB */
-		task_rq_unlock(rq, &flags);
+		task_rq_unlock(rq, p, &flags);
 
 		/*
 		 * If it changed from the expected state, bail out now.
@@ -2596,6 +2596,7 @@ static void __sched_fork(struct task_str
  */
 void sched_fork(struct task_struct *p, int clone_flags)
 {
+	unsigned long flags;
 	int cpu = get_cpu();
 
 	__sched_fork(p);
@@ -2646,9 +2647,9 @@ void sched_fork(struct task_struct *p, i
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
@@ -3472,7 +3473,7 @@ unsigned long long task_delta_exec(struc
 
 	rq = task_rq_lock(p, &flags);
 	ns = do_task_delta_exec(p, rq);
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, p, &flags);
 
 	return ns;
 }
@@ -3490,7 +3491,7 @@ unsigned long long task_sched_runtime(st
 
 	rq = task_rq_lock(p, &flags);
 	ns = p->se.sum_exec_runtime + do_task_delta_exec(p, rq);
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, p, &flags);
 
 	return ns;
 }
@@ -3514,7 +3515,7 @@ unsigned long long thread_group_sched_ru
 	rq = task_rq_lock(p, &flags);
 	thread_group_cputime(p, &totals);
 	ns = totals.sum_exec_runtime + do_task_delta_exec(p, rq);
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, p, &flags);
 
 	return ns;
 }
@@ -4538,16 +4539,13 @@ EXPORT_SYMBOL(sleep_on_timeout);
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
@@ -4573,7 +4571,7 @@ void rt_mutex_setprio(struct task_struct
 
 		check_class_changed(rq, p, prev_class, oldprio, running);
 	}
-	task_rq_unlock(rq, &flags);
+	__task_rq_unlock(rq);
 }
 
 #endif
@@ -4621,7 +4619,7 @@ void set_user_nice(struct task_struct *p
 			resched_task(rq->curr);
 	}
 out_unlock:
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, p, &flags);
 }
 EXPORT_SYMBOL(set_user_nice);
 
@@ -4843,13 +4841,11 @@ static int __sched_setscheduler(struct t
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
@@ -4902,8 +4898,7 @@ static int __sched_setscheduler(struct t
 
 		check_class_changed(rq, p, prev_class, oldprio, running);
 	}
-	__task_rq_unlock(rq);
-	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+	task_rq_unlock(rq, p, &flags);
 
 	rt_mutex_adjust_pi(p);
 
@@ -5432,7 +5427,7 @@ SYSCALL_DEFINE2(sched_rr_get_interval, p
 
 	rq = task_rq_lock(p, &flags);
 	time_slice = p->sched_class->get_rr_interval(rq, p);
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, p, &flags);
 
 	rcu_read_unlock();
 	jiffies_to_timespec(time_slice, &t);
@@ -5655,8 +5650,7 @@ int set_cpus_allowed_ptr(struct task_str
 	unsigned int dest_cpu;
 	int ret = 0;
 
-	raw_spin_lock_irqsave(&p->pi_lock, flags);
-	rq = __task_rq_lock(p);
+	rq = task_rq_lock(p, &flags);
 
 	if (!cpumask_intersects(new_mask, cpu_active_mask)) {
 		ret = -EINVAL;
@@ -5691,8 +5685,7 @@ int set_cpus_allowed_ptr(struct task_str
 		return 0;
 	}
 out:
-	__task_rq_unlock(rq);
-	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+	task_rq_unlock(rq, p, &flags);
 
 	return ret;
 }
@@ -8463,7 +8456,7 @@ void sched_move_task(struct task_struct 
 	if (on_rq)
 		enqueue_task(rq, tsk, 0);
 
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, tsk, &flags);
 }
 #endif /* CONFIG_CGROUP_SCHED */
 


