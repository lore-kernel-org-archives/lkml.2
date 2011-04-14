Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab1DNIhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:37:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:49721 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756642Ab1DNIhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:37:14 -0400
Date: Thu, 14 Apr 2011 08:36:51 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-0122ec5b02f766c355b3168df53a6c038a24fa0d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        frank.rowand@am.sony.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110405152729.232781355@chello.nl>
References: <20110405152729.232781355@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/locking] sched: Add p->pi_lock to task_rq_lock()
Git-Commit-ID: 0122ec5b02f766c355b3168df53a6c038a24fa0d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Apr 2011 08:36:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0122ec5b02f766c355b3168df53a6c038a24fa0d
Gitweb:     http://git.kernel.org/tip/0122ec5b02f766c355b3168df53a6c038a24fa0d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 Apr 2011 17:23:51 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Apr 2011 08:52:38 +0200

sched: Add p->pi_lock to task_rq_lock()

In order to be able to call set_task_cpu() while either holding
p->pi_lock or task_rq(p)->lock we need to hold both locks in order to
stabilize task_rq().

This makes task_rq_lock() acquire both locks, and have
__task_rq_lock() validate that p->pi_lock is held. This increases the
locking overhead for most scheduler syscalls but allows reduction of
rq->lock contention for some scheduler hot paths (ttwu).

Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110405152729.232781355@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |  103 +++++++++++++++++++++++++------------------------------
 1 files changed, 47 insertions(+), 56 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 6b269b7..f155127 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -599,7 +599,7 @@ static inline int cpu_of(struct rq *rq)
  * Return the group to which this tasks belongs.
  *
  * We use task_subsys_state_check() and extend the RCU verification
- * with lockdep_is_held(&task_rq(p)->lock) because cpu_cgroup_attach()
+ * with lockdep_is_held(&p->pi_lock) because cpu_cgroup_attach()
  * holds that lock for each task it moves into the cgroup. Therefore
  * by holding that lock, we pin the task to the current cgroup.
  */
@@ -609,7 +609,7 @@ static inline struct task_group *task_group(struct task_struct *p)
 	struct cgroup_subsys_state *css;
 
 	css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
-			lockdep_is_held(&task_rq(p)->lock));
+			lockdep_is_held(&p->pi_lock));
 	tg = container_of(css, struct task_group, css);
 
 	return autogroup_task_group(p, tg);
@@ -924,23 +924,15 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
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
@@ -951,22 +943,22 @@ static inline struct rq *__task_rq_lock(struct task_struct *p)
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
 
@@ -976,10 +968,13 @@ static void __task_rq_unlock(struct rq *rq)
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
@@ -2175,6 +2170,11 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
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
@@ -2270,7 +2270,7 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		ncsw = 0;
 		if (!match_state || p->state == match_state)
 			ncsw = p->nvcsw | LONG_MIN; /* sets MSB */
-		task_rq_unlock(rq, &flags);
+		task_rq_unlock(rq, p, &flags);
 
 		/*
 		 * If it changed from the expected state, bail out now.
@@ -2652,6 +2652,7 @@ static void __sched_fork(struct task_struct *p)
  */
 void sched_fork(struct task_struct *p, int clone_flags)
 {
+	unsigned long flags;
 	int cpu = get_cpu();
 
 	__sched_fork(p);
@@ -2702,9 +2703,9 @@ void sched_fork(struct task_struct *p, int clone_flags)
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
@@ -2753,7 +2754,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 	set_task_cpu(p, cpu);
 
 	p->state = TASK_RUNNING;
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, p, &flags);
 #endif
 
 	rq = task_rq_lock(p, &flags);
@@ -2765,7 +2766,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 	if (p->sched_class->task_woken)
 		p->sched_class->task_woken(rq, p);
 #endif
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, p, &flags);
 	put_cpu();
 }
 
@@ -3490,12 +3491,12 @@ void sched_exec(void)
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
@@ -3532,7 +3533,7 @@ unsigned long long task_delta_exec(struct task_struct *p)
 
 	rq = task_rq_lock(p, &flags);
 	ns = do_task_delta_exec(p, rq);
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, p, &flags);
 
 	return ns;
 }
@@ -3550,7 +3551,7 @@ unsigned long long task_sched_runtime(struct task_struct *p)
 
 	rq = task_rq_lock(p, &flags);
 	ns = p->se.sum_exec_runtime + do_task_delta_exec(p, rq);
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, p, &flags);
 
 	return ns;
 }
@@ -3574,7 +3575,7 @@ unsigned long long thread_group_sched_runtime(struct task_struct *p)
 	rq = task_rq_lock(p, &flags);
 	thread_group_cputime(p, &totals);
 	ns = totals.sum_exec_runtime + do_task_delta_exec(p, rq);
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, p, &flags);
 
 	return ns;
 }
@@ -4693,16 +4694,13 @@ EXPORT_SYMBOL(sleep_on_timeout);
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
@@ -4727,7 +4725,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 		enqueue_task(rq, p, oldprio < prio ? ENQUEUE_HEAD : 0);
 
 	check_class_changed(rq, p, prev_class, oldprio);
-	task_rq_unlock(rq, &flags);
+	__task_rq_unlock(rq);
 }
 
 #endif
@@ -4775,7 +4773,7 @@ void set_user_nice(struct task_struct *p, long nice)
 			resched_task(rq->curr);
 	}
 out_unlock:
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, p, &flags);
 }
 EXPORT_SYMBOL(set_user_nice);
 
@@ -5003,20 +5001,17 @@ recheck:
 	/*
 	 * make sure no PI-waiters arrive (or leave) while we are
 	 * changing the priority of the task:
-	 */
-	raw_spin_lock_irqsave(&p->pi_lock, flags);
-	/*
+	 *
 	 * To be able to change p->policy safely, the appropriate
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
 
@@ -5040,8 +5035,7 @@ recheck:
 		if (rt_bandwidth_enabled() && rt_policy(policy) &&
 				task_group(p)->rt_bandwidth.rt_runtime == 0 &&
 				!task_group_is_autogroup(task_group(p))) {
-			__task_rq_unlock(rq);
-			raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+			task_rq_unlock(rq, p, &flags);
 			return -EPERM;
 		}
 	}
@@ -5050,8 +5044,7 @@ recheck:
 	/* recheck policy now with rq lock held */
 	if (unlikely(oldpolicy != -1 && oldpolicy != p->policy)) {
 		policy = oldpolicy = -1;
-		__task_rq_unlock(rq);
-		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+		task_rq_unlock(rq, p, &flags);
 		goto recheck;
 	}
 	on_rq = p->on_rq;
@@ -5073,8 +5066,7 @@ recheck:
 		activate_task(rq, p, 0);
 
 	check_class_changed(rq, p, prev_class, oldprio);
-	__task_rq_unlock(rq);
-	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+	task_rq_unlock(rq, p, &flags);
 
 	rt_mutex_adjust_pi(p);
 
@@ -5666,7 +5658,7 @@ SYSCALL_DEFINE2(sched_rr_get_interval, pid_t, pid,
 
 	rq = task_rq_lock(p, &flags);
 	time_slice = p->sched_class->get_rr_interval(rq, p);
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, p, &flags);
 
 	rcu_read_unlock();
 	jiffies_to_timespec(time_slice, &t);
@@ -5889,8 +5881,7 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 	unsigned int dest_cpu;
 	int ret = 0;
 
-	raw_spin_lock_irqsave(&p->pi_lock, flags);
-	rq = __task_rq_lock(p);
+	rq = task_rq_lock(p, &flags);
 
 	if (!cpumask_intersects(new_mask, cpu_active_mask)) {
 		ret = -EINVAL;
@@ -5918,15 +5909,13 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
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
@@ -5954,6 +5943,7 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 	rq_src = cpu_rq(src_cpu);
 	rq_dest = cpu_rq(dest_cpu);
 
+	raw_spin_lock(&p->pi_lock);
 	double_rq_lock(rq_src, rq_dest);
 	/* Already moved. */
 	if (task_cpu(p) != src_cpu)
@@ -5976,6 +5966,7 @@ done:
 	ret = 1;
 fail:
 	double_rq_unlock(rq_src, rq_dest);
+	raw_spin_unlock(&p->pi_lock);
 	return ret;
 }
 
@@ -8702,7 +8693,7 @@ void sched_move_task(struct task_struct *tsk)
 	if (on_rq)
 		enqueue_task(rq, tsk, 0);
 
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, tsk, &flags);
 }
 #endif /* CONFIG_CGROUP_SCHED */
 
