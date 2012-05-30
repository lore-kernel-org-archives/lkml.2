Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab2E3Nha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 09:37:30 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:40773 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab2E3Nh2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 09:37:28 -0400
MIME-Version: 1.0
Date: Wed, 30 May 2012 21:37:23 +0800
Message-ID: <CAJd=RBB1s-_VOtoDsBbLidS51HwW6e98p=U-4mL-spByUMvETw@mail.gmail.com>
Subject: [patch] BFS 420: a tiny step forward
From: Hillf Danton <dhillf@gmail.com>
To: Emmanuel Benisty <benisty.e@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

With 21 patches collected, BFS v0.421, derived from v0.420 by Con Kolivas, is
ready in monolithic diff. Thanks for those messages received while preparing
the patches.

This version is prepared specially for Emmanuel Benisty <benisty.e@gmail.com>,
the first want to try the changes.

Feedback welcome.
			Hillf


--- a/include/linux/sched.h	Mon May 14 20:44:38 2012
+++ b/include/linux/sched.h	Wed May 30 21:04:10 2012
@@ -1255,6 +1255,11 @@ struct task_struct {
 	struct list_head run_list;
 	u64 last_ran;
 	u64 sched_time; /* sched_clock time spent running */
+#ifdef CONFIG_SCHEDSTATS
+#ifdef CONFIG_SMP
+	int wakeup_cpu; //for ttwu stat
+#endif
+#endif
 #ifdef CONFIG_SMP
 	bool sticky; /* Soft affined flag */
 #endif
--- a/kernel/sched/bfs.c	Mon May 14 20:50:38 2012
+++ b/kernel/sched/bfs.c	Wed May 30 21:24:10 2012
@@ -133,7 +133,7 @@

 void print_scheduler_version(void)
 {
-	printk(KERN_INFO "BFS CPU scheduler v0.420 by Con Kolivas.\n");
+	printk(KERN_INFO "BFS v0.421 derived from v0.420 by Con Kolivas\n");
 }

 /*
@@ -322,11 +322,6 @@ static DEFINE_MUTEX(sched_hotcpu_mutex);
  */
 static DEFINE_MUTEX(sched_domains_mutex);

-/*
- * By default the system creates a single root-domain with all cpus as
- * members (mimicking the global state we have today).
- */
-static struct root_domain def_root_domain;

 int __weak arch_sd_sibling_asym_packing(void)
 {
@@ -698,6 +693,16 @@ static bool isoprio_suitable(void)
 	return !grq.iso_refractory;
 }

+static void __enqueue_task(struct task_struct *p, bool at_head)
+{
+	__set_bit(p->prio, grq.prio_bitmap);
+	if (at_head)
+		list_add(&p->run_list, grq.queue + p->prio);
+	else
+		list_add_tail(&p->run_list, grq.queue + p->prio);
+	sched_info_queued(p);
+}
+
 /*
  * Adding to the global runqueue. Enter with grq locked.
  */
@@ -711,42 +716,16 @@ static void enqueue_task(struct task_str
 		else
 			p->prio = NORMAL_PRIO;
 	}
-	__set_bit(p->prio, grq.prio_bitmap);
-	list_add_tail(&p->run_list, grq.queue + p->prio);
-	sched_info_queued(p);
+	__enqueue_task(p, false);
 }

 /* Only idle task does this as a real time task*/
 static inline void enqueue_task_head(struct task_struct *p)
 {
-	__set_bit(p->prio, grq.prio_bitmap);
-	list_add(&p->run_list, grq.queue + p->prio);
-	sched_info_queued(p);
+	__enqueue_task(p, true);
 }

-static inline void requeue_task(struct task_struct *p)
-{
-	sched_info_queued(p);
-}
-
-/*
- * Returns the relative length of deadline all compared to the shortest
- * deadline which is that of nice -20.
- */
-static inline int task_prio_ratio(struct task_struct *p)
-{
-	return prio_ratios[TASK_USER_PRIO(p)];
-}

-/*
- * task_timeslice - all tasks of all priorities get the exact same timeslice
- * length. CPU distribution is handled by giving different deadlines to
- * tasks of different priorities. Use 128 as the base value for fast shifts.
- */
-static inline int task_timeslice(struct task_struct *p)
-{
-	return (rr_interval * task_prio_ratio(p) / 128);
-}

 #ifdef CONFIG_SMP
 /*
@@ -1095,6 +1074,7 @@ resched_closest_idle(struct rq *rq, int
 static inline void
 swap_sticky(struct rq *rq, int cpu, struct task_struct *p)
 {
+	return;
 	if (rq->sticky_task) {
 		if (rq->sticky_task == p) {
 			p->sticky = true;
@@ -1145,6 +1125,30 @@ static inline void unstick_task(struct r
  */
 static inline void take_task(int cpu, struct task_struct *p)
 {
+#ifdef CONFIG_SCHEDSTATS
+#ifdef CONFIG_SMP
+	if (p->wakeup_cpu == -1)
+		goto skip;
+
+	if (cpu == p->wakeup_cpu) {
+		schedstat_inc(cpu_rq(cpu), ttwu_local);
+	}
+	else if (cpu_online(p->wakeup_cpu)) {
+		struct sched_domain *sd;
+
+		rcu_read_lock();
+		for_each_domain(p->wakeup_cpu, sd) {
+			if (cpumask_test_cpu(cpu, sched_domain_span(sd))) {
+				schedstat_inc(sd, ttwu_wake_remote);
+				break;
+			}
+		}
+		rcu_read_unlock();
+	}
+	p->wakeup_cpu = -1;
+skip:
+#endif
+#endif
 	set_task_cpu(p, cpu);
 	dequeue_task(p);
 	clear_sticky(p);
@@ -1423,7 +1427,6 @@ static void try_preempt(struct task_stru
 	struct rq *highest_prio_rq = NULL;
 	int cpu, highest_prio;
 	u64 latest_deadline;
-	cpumask_t tmp;

 	/*
 	 * We clear the sticky flag here because for a task to have called
@@ -1441,14 +1444,10 @@ static void try_preempt(struct task_stru
 	if (p->policy == SCHED_IDLEPRIO)
 		return;

-	if (likely(online_cpus(p)))
-		cpus_and(tmp, cpu_online_map, p->cpus_allowed);
-	else
-		return;
+	highest_prio = p->prio;
+	latest_deadline = p->deadline;

-	highest_prio = latest_deadline = 0;
-
-	for_each_cpu_mask(cpu, tmp) {
+	for_each_cpu_and(cpu, cpu_online_map, p->cpus_allowed) {
 		struct rq *rq;
 		int rq_prio;

@@ -1466,7 +1465,7 @@ static void try_preempt(struct task_stru
 	}

 	if (likely(highest_prio_rq)) {
-		if (can_preempt(p, highest_prio, highest_prio_rq->rq_deadline))
+		//if (can_preempt(p, highest_prio, highest_prio_rq->rq_deadline))
 			resched_task(highest_prio_rq->curr);
 	}
 }
@@ -1485,34 +1484,16 @@ static void try_preempt(struct task_stru
 }
 #endif /* CONFIG_SMP */

-static void
-ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
+static void ttwu_stat(struct task_struct *p, bool success)
 {
 #ifdef CONFIG_SCHEDSTATS
 	struct rq *rq = this_rq();
-
 #ifdef CONFIG_SMP
-	int this_cpu = smp_processor_id();
-
-	if (cpu == this_cpu)
-		schedstat_inc(rq, ttwu_local);
-	else {
-		struct sched_domain *sd;
-
-		rcu_read_lock();
-		for_each_domain(this_cpu, sd) {
-			if (cpumask_test_cpu(cpu, sched_domain_span(sd))) {
-				schedstat_inc(sd, ttwu_wake_remote);
-				break;
-			}
-		}
-		rcu_read_unlock();
-	}
-
-#endif /* CONFIG_SMP */
-
+	if (success)
+		p->wakeup_cpu = smp_processor_id();
+#endif
 	schedstat_inc(rq, ttwu_count);
-#endif /* CONFIG_SCHEDSTATS */
+#endif
 }

 static inline void ttwu_activate(struct task_struct *p, struct rq *rq,
@@ -1534,6 +1515,8 @@ static inline void ttwu_post_activation(
 					bool success)
 {
 	trace_sched_wakeup(p, success);
+	if (!success)
+		return;
 	p->state = TASK_RUNNING;

 	/*
@@ -1579,6 +1562,8 @@ static bool try_to_wake_up(struct task_s
 	/* This barrier is undocumented, probably for p->state? くそ */
 	smp_wmb();

+	if (!(p->state & state))
+		goto out;
 	/*
 	 * No need to do time_lock_grq as we only need to update the rq clock
 	 * if we activate the task
@@ -1593,7 +1578,7 @@ static bool try_to_wake_up(struct task_s
 	if (task_queued(p) || task_running(p))
 		goto out_running;

-	ttwu_activate(p, rq, wake_flags & WF_SYNC);
+	ttwu_activate(p, rq, !!(wake_flags & WF_SYNC));
 	success = true;

 out_running:
@@ -1601,7 +1586,8 @@ out_running:
 out_unlock:
 	task_grq_unlock(&flags);

-	ttwu_stat(p, cpu, wake_flags);
+out:
+	ttwu_stat(p, success);

 	put_cpu();

@@ -1624,18 +1610,17 @@ static void try_to_wake_up_local(struct
 	lockdep_assert_held(&grq.lock);

 	if (!(p->state & TASK_NORMAL))
-		return;
+		goto out;

-	if (!task_queued(p)) {
-		if (likely(!task_running(p))) {
-			schedstat_inc(rq, ttwu_count);
-			schedstat_inc(rq, ttwu_local);
-		}
-		ttwu_activate(p, rq, false);
-		ttwu_stat(p, smp_processor_id(), 0);
-		success = true;
-	}
+	if (task_queued(p) || task_running(p))
+		goto out;
+
+	ttwu_activate(p, rq, false);
+	success = true;
+
+out:
 	ttwu_post_activation(p, rq, success);
+	ttwu_stat(p, success);
 }

 /**
@@ -1719,6 +1704,11 @@ void sched_fork(struct task_struct *p)
 		memset(&p->sched_info, 0, sizeof(p->sched_info));
 #endif

+#ifdef CONFIG_SCHEDSTATS
+#ifdef CONFIG_SMP
+	p->wakeup_cpu = -1;
+#endif
+#endif
 	p->on_cpu = false;
 	clear_sticky(p);

@@ -1771,7 +1761,7 @@ void wake_up_new_task(struct task_struct
 	unsigned long flags;
 	struct rq *rq;

-	rq = task_grq_lock(p, &flags);
+	rq = task_grq_lock(p->parent, &flags);
 	p->state = TASK_RUNNING;
 	parent = p->parent;
 	/* Unnecessary but small chance that the parent changed CPU */
@@ -2764,12 +2754,8 @@ static void task_running_tick(struct rq
 {
 	struct task_struct *p;

-	/*
-	 * If a SCHED_ISO task is running we increment the iso_ticks. In
-	 * order to prevent SCHED_ISO tasks from causing starvation in the
-	 * presence of true RT tasks we account those as iso_ticks as well.
-	 */
-	if ((rt_queue(rq) || (iso_queue(rq) && !grq.iso_refractory))) {
+	/* Increase iso ticks only if a SCHED_ISO task is running */
+	if (iso_queue(rq) && isoprio_suitable()) {
 		if (grq.iso_ticks <= (ISO_PERIOD * 128) - 128)
 			iso_tick();
 	} else
@@ -2808,12 +2794,10 @@ static void task_running_tick(struct rq
 	/* p->time_slice < RESCHED_US. We only modify task_struct under grq lock */
 	p = rq->curr;
 	grq_lock();
-	requeue_task(p);
 	set_tsk_need_resched(p);
 	grq_unlock();
 }

-void wake_up_idle_cpu(int cpu);

 /*
  * This function gets called by the timer code, with HZ frequency.
@@ -2822,8 +2806,7 @@ void wake_up_idle_cpu(int cpu);
  */
 void scheduler_tick(void)
 {
-	int cpu __maybe_unused = smp_processor_id();
-	struct rq *rq = cpu_rq(cpu);
+	struct rq *rq = this_rq();

 	sched_clock_tick();
 	/* grq lock not grabbed, so only update rq clock */
@@ -3065,18 +3048,12 @@ task_struct *earliest_deadline_task(stru
 				continue;

 			/*
-			 * Soft affinity happens here by not scheduling a task
-			 * with its sticky flag set that ran on a different CPU
-			 * last when the CPU is scaling, or by greatly biasing
-			 * against its deadline when not, based on cpu cache
-			 * locality.
+			 * Soft affinity happens here by biasing against its
+			 * deadline when the CPU is scaling, based on cpu
+			 * cache locality.
 			 */
-			if (task_sticky(p) && task_rq(p) != rq) {
-				if (scaling_rq(rq))
-					continue;
-				dl = p->deadline << locality_diff(p, rq);
-			} else
-				dl = p->deadline;
+			dl = p->deadline << (locality_diff(p, rq) +
+							!!scaling_rq(rq));

 			if (deadline_before(dl, earliest_deadline)) {
 				earliest_deadline = dl;
@@ -3087,6 +3064,7 @@ task_struct *earliest_deadline_task(stru

 out_take:
 	take_task(cpu, edt);
+	sched_info_dequeued(edt);
 	return edt;
 }

@@ -3853,7 +3831,8 @@ void rt_mutex_setprio(struct task_struct
 		resched_task(p);
 	if (queued) {
 		enqueue_task(p);
-		try_preempt(p, rq);
+		if (prio < oldprio)
+			try_preempt(p, rq);
 	}

 	task_grq_unlock(&flags);
@@ -4567,7 +4546,6 @@ SYSCALL_DEFINE0(sched_yield)
 	p = current;
 	grq_lock_irq();
 	schedstat_inc(task_rq(p), yld_count);
-	requeue_task(p);

 	/*
 	 * Since we are going to call schedule() anyway, there's
@@ -4824,7 +4802,7 @@ SYSCALL_DEFINE2(sched_rr_get_interval, p
 		goto out_unlock;

 	grq_lock_irqsave(&flags);
-	time_slice = p->policy == SCHED_FIFO ? 0 : MS_TO_NS(task_timeslice(p));
+	time_slice = p->policy == SCHED_FIFO ? 0 : MS_TO_NS(rr_interval);
 	grq_unlock_irqrestore(&flags);

 	rcu_read_unlock();
@@ -4951,51 +4929,7 @@ void select_nohz_load_balancer(int stop_
 }

 void set_cpu_sd_state_idle(void) {}
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-/**
- * lowest_flag_domain - Return lowest sched_domain containing flag.
- * @cpu:	The cpu whose lowest level of sched domain is to
- *		be returned.
- * @flag:	The flag to check for the lowest sched_domain
- *		for the given cpu.
- *
- * Returns the lowest sched_domain of a cpu which contains the given flag.
- */
-static inline struct sched_domain *lowest_flag_domain(int cpu, int flag)
-{
-	struct sched_domain *sd;
-
-	for_each_domain(cpu, sd)
-		if (sd && (sd->flags & flag))
-			break;
-
-	return sd;
-}
-
-/**
- * for_each_flag_domain - Iterates over sched_domains containing the flag.
- * @cpu:	The cpu whose domains we're iterating over.
- * @sd:		variable holding the value of the power_savings_sd
- *		for cpu.
- * @flag:	The flag to filter the sched_domains to be iterated.
- *
- * Iterates over all the scheduler domains for a given cpu that has the 'flag'
- * set, starting from the lowest sched_domain to the highest.
- */
-#define for_each_flag_domain(cpu, sd, flag) \
-	for (sd = lowest_flag_domain(cpu, flag); \
-		(sd && (sd->flags & flag)); sd = sd->parent)
-
-#endif /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
-
-static inline void resched_cpu(int cpu)
-{
-	unsigned long flags;

-	grq_lock_irqsave(&flags);
-	resched_task(cpu_curr(cpu));
-	grq_unlock_irqrestore(&flags);
-}

 /*
  * In the semi idle case, use the nearest busy cpu for migrating timers
@@ -5117,8 +5051,7 @@ int set_cpus_allowed_ptr(struct task_str
 			running_wrong = true;
 		} else
 			resched_task(p);
-	} else
-		set_task_cpu(p, cpumask_any_and(cpu_active_mask, new_mask));
+	}

 out:
 	if (queued)
@@ -5153,7 +5086,8 @@ static void break_sole_affinity(int src_
 				       task_pid_nr(p), p->comm, src_cpu);
 			}
 		}
-		clear_sticky(p);
+		if (task_sticky(p) && task_cpu(p) == src_cpu)
+			clear_sticky(p);
 	} while_each_thread(t, p);
 }

@@ -5422,7 +5356,7 @@ migration_call(struct notifier_block *nf
 		/* Update our root-domain */
 		grq_lock_irqsave(&flags);
 		if (rq->rd) {
-			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
+			BUG_ON(cpumask_test_cpu(cpu, rq->rd->span));

 			set_rq_online(rq);
 		}
--
