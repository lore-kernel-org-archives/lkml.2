Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab1GUSfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:35:41 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:53685 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab1GUSfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:35:39 -0400
Message-ID: <4E287177.6020605@linux.vnet.ibm.com>
Date: Fri, 22 Jul 2011 02:35:35 +0800
From: Cheng Xu <chengxu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Paul Mckenney <paulmck@linux.vnet.ibm.com>
Subject: [RFC PATCH] sched: lockdep circular locking error (rcu_node_level_0
 vs rq->lock)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated version of Peter Zijlstra's patch at
https://lkml.org/lkml/2011/7/12/344 that successfully boots on IBM JS22
Blade (with two Power6 quad-core CPUs). It might not be needed, but I am
posting it just in case.

Summary of changes,
1. migration_call(): added a semicolon
2. sched_exec(): added a rcu_read_unlock() call in a code path
3. double_unlock_balance(): added a rcu_read_unlock() call
4. rq_attach_root(): changed 2nd rcu_read_lock() to rcu_read_unlock()
5. finish_lock_switch(): used rcu_read_lock() to replace rcu_read_acquire(),
   which might be problematic; similarly, 
   context_switch(): used rcu_read_unlock() to replace rcu_read_release().

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Cheng Xu <chengxu@linux.vnet.ibm.com>
---
 kernel/sched.c      |   78 ++++++++++++++++++++++++++++++++++++++------------
 kernel/sched_fair.c |   14 ++++++--
 kernel/sched_rt.c   |    6 ++++
 3 files changed, 75 insertions(+), 23 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index fde6ff9..b6bf557 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -892,6 +892,7 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 	 * prev into current:
 	 */
 	spin_acquire(&rq->lock.dep_map, 0, 0, _THIS_IP_);
+	rcu_read_lock();
 
 	raw_spin_unlock_irq(&rq->lock);
 }
@@ -960,6 +961,7 @@ static struct rq *task_rq_lock(struct task_struct *p, unsigned long *flags)
 	struct rq *rq;
 
 	for (;;) {
+		rcu_read_lock();
 		raw_spin_lock_irqsave(&p->pi_lock, *flags);
 		rq = task_rq(p);
 		raw_spin_lock(&rq->lock);
@@ -967,6 +969,7 @@ static struct rq *task_rq_lock(struct task_struct *p, unsigned long *flags)
 			return rq;
 		raw_spin_unlock(&rq->lock);
 		raw_spin_unlock_irqrestore(&p->pi_lock, *flags);
+		rcu_read_unlock();
 	}
 }
 
@@ -983,6 +986,7 @@ task_rq_unlock(struct rq *rq, struct task_struct *p, unsigned long *flags)
 {
 	raw_spin_unlock(&rq->lock);
 	raw_spin_unlock_irqrestore(&p->pi_lock, *flags);
+	rcu_read_unlock();
 }
 
 /*
@@ -995,6 +999,7 @@ static struct rq *this_rq_lock(void)
 
 	local_irq_disable();
 	rq = this_rq();
+	rcu_read_lock();
 	raw_spin_lock(&rq->lock);
 
 	return rq;
@@ -1042,10 +1047,12 @@ static enum hrtimer_restart hrtick(struct hrtimer *timer)
 
 	WARN_ON_ONCE(cpu_of(rq) != smp_processor_id());
 
+	rcu_read_lock();
 	raw_spin_lock(&rq->lock);
 	update_rq_clock(rq);
 	rq->curr->sched_class->task_tick(rq, rq->curr, 1);
 	raw_spin_unlock(&rq->lock);
+	rcu_read_unlock();
 
 	return HRTIMER_NORESTART;
 }
@@ -1058,10 +1065,12 @@ static void __hrtick_start(void *arg)
 {
 	struct rq *rq = arg;
 
+	rcu_read_lock();
 	raw_spin_lock(&rq->lock);
 	hrtimer_restart(&rq->hrtick_timer);
 	rq->hrtick_csd_pending = 0;
 	raw_spin_unlock(&rq->lock);
+	rcu_read_unlock();
 }
 
 /*
@@ -1190,10 +1199,14 @@ static void resched_cpu(int cpu)
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
 
-	if (!raw_spin_trylock_irqsave(&rq->lock, flags))
+	rcu_read_lock();
+	if (!raw_spin_trylock_irqsave(&rq->lock, flags)) {
+		rcu_read_unlock();
 		return;
+	}
 	resched_task(cpu_curr(cpu));
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
+	rcu_read_unlock();
 }
 
 #ifdef CONFIG_NO_HZ
@@ -1672,6 +1685,7 @@ static inline void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
 	__releases(busiest->lock)
 {
 	raw_spin_unlock(&busiest->lock);
+	rcu_read_unlock();
 	lock_set_subclass(&this_rq->lock.dep_map, 0, _RET_IP_);
 }
 
@@ -1685,6 +1699,7 @@ static void double_rq_lock(struct rq *rq1, struct rq *rq2)
 	__acquires(rq1->lock)
 	__acquires(rq2->lock)
 {
+	rcu_read_lock();
 	BUG_ON(!irqs_disabled());
 	if (rq1 == rq2) {
 		raw_spin_lock(&rq1->lock);
@@ -1715,6 +1730,7 @@ static void double_rq_unlock(struct rq *rq1, struct rq *rq2)
 		raw_spin_unlock(&rq2->lock);
 	else
 		__release(rq2->lock);
+	rcu_read_unlock();
 }
 
 #else /* CONFIG_SMP */
@@ -1731,6 +1747,7 @@ static void double_rq_lock(struct rq *rq1, struct rq *rq2)
 {
 	BUG_ON(!irqs_disabled());
 	BUG_ON(rq1 != rq2);
+	rcu_read_lock();
 	raw_spin_lock(&rq1->lock);
 	__acquire(rq2->lock);	/* Fake it out ;) */
 }
@@ -1747,6 +1764,7 @@ static void double_rq_unlock(struct rq *rq1, struct rq *rq2)
 {
 	BUG_ON(rq1 != rq2);
 	raw_spin_unlock(&rq1->lock);
+	rcu_read_unlock();
 	__release(rq2->lock);
 }
 
@@ -2548,6 +2566,7 @@ static void sched_ttwu_do_pending(struct task_struct *list)
 {
 	struct rq *rq = this_rq();
 
+	rcu_read_lock();
 	raw_spin_lock(&rq->lock);
 
 	while (list) {
@@ -2557,6 +2576,7 @@ static void sched_ttwu_do_pending(struct task_struct *list)
 	}
 
 	raw_spin_unlock(&rq->lock);
+	rcu_read_unlock();
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -2677,6 +2697,7 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 	int cpu, success = 0;
 
 	smp_wmb();
+	rcu_read_lock();
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
 	if (!(p->state & state))
 		goto out;
@@ -2730,6 +2751,7 @@ stat:
 	ttwu_stat(p, cpu, wake_flags);
 out:
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+	rcu_read_unlock();
 
 	return success;
 }
@@ -2750,6 +2772,7 @@ static void try_to_wake_up_local(struct task_struct *p)
 	BUG_ON(p == current);
 	lockdep_assert_held(&rq->lock);
 
+	rcu_read_lock();
 	if (!raw_spin_trylock(&p->pi_lock)) {
 		raw_spin_unlock(&rq->lock);
 		raw_spin_lock(&p->pi_lock);
@@ -2766,6 +2789,7 @@ static void try_to_wake_up_local(struct task_struct *p)
 	ttwu_stat(p, smp_processor_id(), 0);
 out:
 	raw_spin_unlock(&p->pi_lock);
+	rcu_read_unlock();
 }
 
 /**
@@ -2875,9 +2899,11 @@ void sched_fork(struct task_struct *p)
 	 *
 	 * Silence PROVE_RCU.
 	 */
+	rcu_read_lock();
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
 	set_task_cpu(p, cpu);
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+	rcu_read_unlock();
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	if (likely(sched_info_on()))
@@ -2909,6 +2935,7 @@ void wake_up_new_task(struct task_struct *p)
 	unsigned long flags;
 	struct rq *rq;
 
+	rcu_read_lock();
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
 #ifdef CONFIG_SMP
 	/*
@@ -3058,6 +3085,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	local_irq_enable();
 #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 	finish_lock_switch(rq, prev);
+	rcu_read_unlock();
 
 	fire_sched_in_preempt_notifiers(current);
 	if (mm)
@@ -3087,10 +3115,12 @@ static inline void post_schedule(struct rq *rq)
 	if (rq->post_schedule) {
 		unsigned long flags;
 
+		rcu_read_lock();
 		raw_spin_lock_irqsave(&rq->lock, flags);
 		if (rq->curr->sched_class->post_schedule)
 			rq->curr->sched_class->post_schedule(rq);
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
+		rcu_read_unlock();
 
 		rq->post_schedule = 0;
 	}
@@ -3173,6 +3203,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	 */
 #ifndef __ARCH_WANT_UNLOCKED_CTXSW
 	spin_release(&rq->lock.dep_map, 1, _THIS_IP_);
+	rcu_read_unlock();
 #endif
 
 	/* Here we just switch the register state and the stack. */
@@ -3639,6 +3670,7 @@ void sched_exec(void)
 	unsigned long flags;
 	int dest_cpu;
 
+	rcu_read_lock();
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
 	dest_cpu = p->sched_class->select_task_rq(p, SD_BALANCE_EXEC, 0);
 	if (dest_cpu == smp_processor_id())
@@ -3648,11 +3680,13 @@ void sched_exec(void)
 		struct migration_arg arg = { p, dest_cpu };
 
 		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+		rcu_read_unlock();
 		stop_one_cpu(task_cpu(p), migration_cpu_stop, &arg);
 		return;
 	}
 unlock:
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+	rcu_read_unlock();
 }
 
 #endif
@@ -4094,11 +4128,13 @@ void scheduler_tick(void)
 
 	sched_clock_tick();
 
+	rcu_read_lock();
 	raw_spin_lock(&rq->lock);
 	update_rq_clock(rq);
 	update_cpu_load_active(rq);
 	curr->sched_class->task_tick(rq, curr, 0);
 	raw_spin_unlock(&rq->lock);
+	rcu_read_unlock();
 
 	perf_event_task_tick();
 
@@ -4263,6 +4299,7 @@ need_resched:
 	if (sched_feat(HRTICK))
 		hrtick_clear(rq);
 
+	rcu_read_lock();
 	raw_spin_lock_irq(&rq->lock);
 
 	switch_count = &prev->nivcsw;
@@ -4323,8 +4360,10 @@ need_resched:
 		 */
 		cpu = smp_processor_id();
 		rq = cpu_rq(cpu);
-	} else
+	} else {
 		raw_spin_unlock_irq(&rq->lock);
+		rcu_read_unlock();
+	}
 
 	post_schedule(rq);
 
@@ -5168,8 +5207,7 @@ recheck:
 	if (unlikely(policy == p->policy && (!rt_policy(policy) ||
 			param->sched_priority == p->rt_priority))) {
 
-		__task_rq_unlock(rq);
-		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+		task_rq_unlock(rq, p, &flags);
 		return 0;
 	}
 
@@ -5540,9 +5578,9 @@ SYSCALL_DEFINE0(sched_yield)
 	 * Since we are going to call schedule() anyway, there's
 	 * no need to preempt or enable interrupts:
 	 */
-	__release(rq->lock);
-	spin_release(&rq->lock.dep_map, 1, _THIS_IP_);
-	do_raw_spin_unlock(&rq->lock);
+	preempt_disable();
+	raw_spin_unlock(&rq->lock);
+	rcu_read_unlock();
 	preempt_enable_no_resched();
 
 	schedule();
@@ -5901,6 +5939,7 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
 
+	rcu_read_lock();
 	raw_spin_lock_irqsave(&rq->lock, flags);
 
 	__sched_fork(idle);
@@ -5908,25 +5947,14 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	idle->se.exec_start = sched_clock();
 
 	do_set_cpus_allowed(idle, cpumask_of(cpu));
-	/*
-	 * We're having a chicken and egg problem, even though we are
-	 * holding rq->lock, the cpu isn't yet set to this cpu so the
-	 * lockdep check in task_group() will fail.
-	 *
-	 * Similar case to sched_fork(). / Alternatively we could
-	 * use task_rq_lock() here and obtain the other rq->lock.
-	 *
-	 * Silence PROVE_RCU
-	 */
-	rcu_read_lock();
 	__set_task_cpu(idle, cpu);
-	rcu_read_unlock();
 
 	rq->curr = rq->idle = idle;
 #if defined(CONFIG_SMP)
 	idle->on_cpu = 1;
 #endif
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
+	rcu_read_unlock();
 
 	/* Set the preempt count _outside_ the spinlocks! */
 	task_thread_info(idle)->preempt_count = 0;
@@ -6094,6 +6122,7 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 	rq_src = cpu_rq(src_cpu);
 	rq_dest = cpu_rq(dest_cpu);
 
+	rcu_read_lock();
 	raw_spin_lock(&p->pi_lock);
 	double_rq_lock(rq_src, rq_dest);
 	/* Already moved. */
@@ -6118,6 +6147,7 @@ done:
 fail:
 	double_rq_unlock(rq_src, rq_dest);
 	raw_spin_unlock(&p->pi_lock);
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -6447,6 +6477,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 
 	case CPU_ONLINE:
 		/* Update our root-domain */
+		rcu_read_lock();
 		raw_spin_lock_irqsave(&rq->lock, flags);
 		if (rq->rd) {
 			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
@@ -6454,12 +6485,14 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 			set_rq_online(rq);
 		}
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
+		rcu_read_unlock();
 		break;
 
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DYING:
 		sched_ttwu_pending();
 		/* Update our root-domain */
+		rcu_read_lock();
 		raw_spin_lock_irqsave(&rq->lock, flags);
 		if (rq->rd) {
 			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
@@ -6468,6 +6501,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		migrate_tasks(cpu);
 		BUG_ON(rq->nr_running != 1); /* the migration thread */
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
+		rcu_read_unlock();
 
 		migrate_nr_uninterruptible(rq);
 		calc_global_load_remove(rq);
@@ -6726,6 +6760,7 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 	struct root_domain *old_rd = NULL;
 	unsigned long flags;
 
+	rcu_read_lock();
 	raw_spin_lock_irqsave(&rq->lock, flags);
 
 	if (rq->rd) {
@@ -6753,6 +6788,7 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 		set_rq_online(rq);
 
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
+	rcu_read_unlock();
 
 	if (old_rd)
 		call_rcu_sched(&old_rd->rcu, free_rootdomain);
@@ -8272,6 +8308,7 @@ void normalize_rt_tasks(void)
 			continue;
 		}
 
+		rcu_read_lock();
 		raw_spin_lock(&p->pi_lock);
 		rq = __task_rq_lock(p);
 
@@ -8279,6 +8316,7 @@ void normalize_rt_tasks(void)
 
 		__task_rq_unlock(rq);
 		raw_spin_unlock(&p->pi_lock);
+		rcu_read_unlock();
 	} while_each_thread(g, p);
 
 	read_unlock_irqrestore(&tasklist_lock, flags);
@@ -8619,10 +8657,12 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 
 		se = tg->se[i];
 		/* Propagate contribution to hierarchy */
+		rcu_read_lock();
 		raw_spin_lock_irqsave(&rq->lock, flags);
 		for_each_sched_entity(se)
 			update_cfs_shares(group_cfs_rq(se));
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
+		rcu_read_unlock();
 	}
 
 done:
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c768588..3c955f7 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2209,6 +2209,7 @@ static int update_shares_cpu(struct task_group *tg, int cpu)
 	rq = cpu_rq(cpu);
 	cfs_rq = tg->cfs_rq[cpu];
 
+	rcu_read_lock();
 	raw_spin_lock_irqsave(&rq->lock, flags);
 
 	update_rq_clock(rq);
@@ -2221,6 +2222,7 @@ static int update_shares_cpu(struct task_group *tg, int cpu)
 	update_cfs_shares(cfs_rq);
 
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
+	rcu_read_unlock();
 
 	return 0;
 }
@@ -3501,10 +3503,10 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 	/*
 	 * Drop the rq->lock, but keep IRQ/preempt disabled.
 	 */
+	rcu_read_lock();
 	raw_spin_unlock(&this_rq->lock);
 
 	update_shares(this_cpu);
-	rcu_read_lock();
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
 		int balance = 1;
@@ -3526,9 +3528,9 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 			break;
 		}
 	}
-	rcu_read_unlock();
 
 	raw_spin_lock(&this_rq->lock);
+	rcu_read_unlock();
 
 	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
 		/*
@@ -3553,6 +3555,7 @@ static int active_load_balance_cpu_stop(void *data)
 	struct rq *target_rq = cpu_rq(target_cpu);
 	struct sched_domain *sd;
 
+	rcu_read_lock();
 	raw_spin_lock_irq(&busiest_rq->lock);
 
 	/* make sure the requested cpu hasn't gone down in the meantime */
@@ -3575,7 +3578,6 @@ static int active_load_balance_cpu_stop(void *data)
 	double_lock_balance(busiest_rq, target_rq);
 
 	/* Search for an sd spanning us and the target CPU. */
-	rcu_read_lock();
 	for_each_domain(target_cpu, sd) {
 		if ((sd->flags & SD_LOAD_BALANCE) &&
 		    cpumask_test_cpu(busiest_cpu, sched_domain_span(sd)))
@@ -3591,11 +3593,11 @@ static int active_load_balance_cpu_stop(void *data)
 		else
 			schedstat_inc(sd, alb_failed);
 	}
-	rcu_read_unlock();
 	double_unlock_balance(busiest_rq, target_rq);
 out_unlock:
 	busiest_rq->active_balance = 0;
 	raw_spin_unlock_irq(&busiest_rq->lock);
+	rcu_read_unlock();
 	return 0;
 }
 
@@ -3982,10 +3984,12 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
 			break;
 		}
 
+		rcu_read_lock();
 		raw_spin_lock_irq(&this_rq->lock);
 		update_rq_clock(this_rq);
 		update_cpu_load(this_rq);
 		raw_spin_unlock_irq(&this_rq->lock);
+		rcu_read_unlock();
 
 		rebalance_domains(balance_cpu, CPU_IDLE);
 
@@ -4135,6 +4139,7 @@ static void task_fork_fair(struct task_struct *p)
 	struct rq *rq = this_rq();
 	unsigned long flags;
 
+	rcu_read_lock();
 	raw_spin_lock_irqsave(&rq->lock, flags);
 
 	update_rq_clock(rq);
@@ -4163,6 +4168,7 @@ static void task_fork_fair(struct task_struct *p)
 	se->vruntime -= cfs_rq->min_vruntime;
 
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
+	rcu_read_unlock();
 }
 
 /*
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 10d0182..6e8a375 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -494,9 +494,11 @@ static void disable_runtime(struct rq *rq)
 {
 	unsigned long flags;
 
+	rcu_read_lock();
 	raw_spin_lock_irqsave(&rq->lock, flags);
 	__disable_runtime(rq);
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
+	rcu_read_unlock();
 }
 
 static void __enable_runtime(struct rq *rq)
@@ -527,9 +529,11 @@ static void enable_runtime(struct rq *rq)
 {
 	unsigned long flags;
 
+	rcu_read_lock();
 	raw_spin_lock_irqsave(&rq->lock, flags);
 	__enable_runtime(rq);
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
+	rcu_read_unlock();
 }
 
 static int balance_runtime(struct rt_rq *rt_rq)
@@ -565,6 +569,7 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);
 		struct rq *rq = rq_of_rt_rq(rt_rq);
 
+		rcu_read_lock();
 		raw_spin_lock(&rq->lock);
 		if (rt_rq->rt_time) {
 			u64 runtime;
@@ -597,6 +602,7 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 		if (enqueue)
 			sched_rt_rq_enqueue(rt_rq);
 		raw_spin_unlock(&rq->lock);
+		rcu_read_unlock();
 	}
 
 	return idle;
-- 
1.7.1


