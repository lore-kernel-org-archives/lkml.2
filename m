Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab2GAN3f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 09:29:35 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52851 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab2GAN3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 09:29:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAJd=RBBSEVOUL-J=gGWO4FpbtC30_A8eb6HyKK48ZdjmNn_y-Q@mail.gmail.com>
References: <CAJd=RBBSEVOUL-J=gGWO4FpbtC30_A8eb6HyKK48ZdjmNn_y-Q@mail.gmail.com>
Date: Sun, 1 Jul 2012 21:29:33 +0800
Message-ID: <CAJd=RBAvEn5O+XUkdsUJp6MfMXPwQc04xiCZLoeE5NyA42+2Mg@mail.gmail.com>
Subject: Re: [RFC patch] BFS: 421-1
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 1, 2012 at 9:27 PM, Hillf Danton <dhillf@gmail.com> wrote:
> With 15 patches collected, the 421-1 is ready with iso untouched.
> Note diff is based not on 420 but on 421.

Here is the diff on 420.


--- a/kernel/sched/bfs.c	Sun Jul  1 20:44:00 2012
+++ b/kernel/sched/bfs.c	Fri Jun 15 20:00:52 2012
@@ -113,7 +113,6 @@
 #define USER_PRIO(p)		((p) - MAX_RT_PRIO)
 #define TASK_USER_PRIO(p)	USER_PRIO((p)->static_prio)
 #define MAX_USER_PRIO		(USER_PRIO(MAX_PRIO))
-#define SCHED_PRIO(p)		((p) + MAX_RT_PRIO)
 #define STOP_PRIO		(MAX_RT_PRIO - 1)

 /*
@@ -133,7 +132,7 @@

 void print_scheduler_version(void)
 {
-	printk(KERN_INFO "BFS CPU scheduler v0.420 by Con Kolivas.\n");
+	printk(KERN_INFO "BFS 421-1 based on v0.420 by Con Kolivas\n");
 }

 /*
@@ -150,6 +149,19 @@ int rr_interval __read_mostly = 6;
  */
 int sched_iso_cpu __read_mostly = 70;

+#ifdef CONFIG_SMP
+enum {
+	EDL_CK,		//default
+	EDL_MS,		//map cache distance to milliseconds
+	EDL_NONE,	//strict edl
+};
+int edl_mode = EDL_CK;
+
+unsigned long	grab_rq_lock = 0,
+		wait_rq_lock = 0,
+		tsk_csw = 0,
+		cpu_csw = 0;
+#endif
 /*
  * The relative length of deadline for each priority(nice) level.
  */
@@ -247,7 +259,6 @@ struct rq {
 	int rq_time_slice;
 	u64 rq_last_ran;
 	int rq_prio;
-	bool rq_running; /* There is a task running */

 	/* Accurate timekeeping data */
 	u64 timekeep_clock;
@@ -313,7 +324,6 @@ struct rq {
 };

 DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
-static DEFINE_MUTEX(sched_hotcpu_mutex);

 #ifdef CONFIG_SMP
 /*
@@ -322,17 +332,11 @@ static DEFINE_MUTEX(sched_hotcpu_mutex);
  */
 static DEFINE_MUTEX(sched_domains_mutex);

-/*
- * By default the system creates a single root-domain with all cpus as
- * members (mimicking the global state we have today).
- */
-static struct root_domain def_root_domain;

 int __weak arch_sd_sibling_asym_packing(void)
 {
        return 0*SD_ASYM_PACKING;
 }
-#endif

 #define rcu_dereference_check_sched_domain(p) \
 	rcu_dereference_check((p), \
@@ -347,6 +351,9 @@ int __weak arch_sd_sibling_asym_packing(
  */
 #define for_each_domain(cpu, __sd) \
 	for (__sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd);
__sd; __sd = __sd->parent)
+#else
+#define for_each_domain(cpu, __sd)	BUILD_BUG()
+#endif

 static inline void update_rq_clock(struct rq *rq);

@@ -528,12 +535,6 @@ static inline struct rq *task_grq_lock_i
 	return task_rq(p);
 }

-static inline void time_task_grq_lock_irq(struct task_struct *p)
-	__acquires(grq.lock)
-{
-	struct rq *rq = task_grq_lock_irq(p);
-	update_clocks(rq);
-}

 static inline void task_grq_unlock_irq(void)
 	__releases(grq.lock)
@@ -698,6 +699,16 @@ static bool isoprio_suitable(void)
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
@@ -711,42 +722,16 @@ static void enqueue_task(struct task_str
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

-/*
- * Returns the relative length of deadline all compared to the shortest
- * deadline which is that of nice -20.
- */
-static inline int task_prio_ratio(struct task_struct *p)
-{
-	return prio_ratios[TASK_USER_PRIO(p)];
-}
-
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
@@ -1007,15 +992,11 @@ static void activate_task(struct task_st
 {
 	update_clocks(rq);

-	/*
-	 * Sleep time is in units of nanosecs, so shift by 20 to get a
-	 * milliseconds-range estimation of the amount of time that the task
-	 * spent sleeping:
-	 */
+	/* Sleep time is tracked in units of nanosecs, but reported in ms */
 	if (unlikely(prof_on == SLEEP_PROFILING)) {
 		if (p->state == TASK_UNINTERRUPTIBLE)
 			profile_hits(SLEEP_PROFILING, (void *)get_wchan(p),
-				     (rq->clock - p->last_ran) >> 20);
+					NS_TO_MS(rq->clock - p->last_ran));
 	}

 	p->prio = effective_prio(p);
@@ -1050,16 +1031,10 @@ void set_task_cpu(struct task_struct *p,
 	WARN_ON_ONCE(debug_locks && !lockdep_is_held(&grq.lock));
 #endif
 	trace_sched_migrate_task(p, cpu);
-	if (task_cpu(p) != cpu)
+	if (task_cpu(p) != cpu) {
+		task_thread_info(p)->cpu = cpu;
 		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, NULL, 0);
-
-	/*
-	 * After ->cpu is set up to a new value, task_grq_lock(p, ...) can be
-	 * successfully executed on another CPU. We must ensure that updates of
-	 * per-task data have been completed by this moment.
-	 */
-	smp_wmb();
-	task_thread_info(p)->cpu = cpu;
+	}
 }

 static inline void clear_sticky(struct task_struct *p)
@@ -1078,6 +1053,8 @@ resched_closest_idle(struct rq *rq, int
 {
 	cpumask_t tmpmask;

+	if (!grq.idle_cpus)
+		return;
 	cpus_and(tmpmask, p->cpus_allowed, grq.cpu_idle_map);
 	cpu_clear(cpu, tmpmask);
 	if (cpus_empty(tmpmask))
@@ -1095,6 +1072,7 @@ resched_closest_idle(struct rq *rq, int
 static inline void
 swap_sticky(struct rq *rq, int cpu, struct task_struct *p)
 {
+	return;
 	if (rq->sticky_task) {
 		if (rq->sticky_task == p) {
 			p->sticky = true;
@@ -1145,6 +1123,13 @@ static inline void unstick_task(struct r
  */
 static inline void take_task(int cpu, struct task_struct *p)
 {
+#ifdef CONFIG_SMP
+	if (p != current) {
+		tsk_csw++;
+		if (cpu != task_cpu(p))
+			cpu_csw++;
+	}
+#endif
 	set_task_cpu(p, cpu);
 	dequeue_task(p);
 	clear_sticky(p);
@@ -1217,11 +1202,6 @@ inline int task_curr(const struct task_s
 }

 #ifdef CONFIG_SMP
-struct migration_req {
-	struct task_struct *task;
-	int dest_cpu;
-};
-
 /*
  * wait_task_inactive - wait for a thread to unschedule.
  *
@@ -1423,7 +1403,6 @@ static void try_preempt(struct task_stru
 	struct rq *highest_prio_rq = NULL;
 	int cpu, highest_prio;
 	u64 latest_deadline;
-	cpumask_t tmp;

 	/*
 	 * We clear the sticky flag here because for a task to have called
@@ -1441,14 +1420,10 @@ static void try_preempt(struct task_stru
 	if (p->policy == SCHED_IDLEPRIO)
 		return;

-	if (likely(online_cpus(p)))
-		cpus_and(tmp, cpu_online_map, p->cpus_allowed);
-	else
-		return;
-
-	highest_prio = latest_deadline = 0;
+	highest_prio = p->prio;
+	latest_deadline = p->deadline;

-	for_each_cpu_mask(cpu, tmp) {
+	for_each_cpu_and(cpu, cpu_online_mask, tsk_cpus_allowed(p)) {
 		struct rq *rq;
 		int rq_prio;

@@ -1457,16 +1432,17 @@ static void try_preempt(struct task_stru
 		if (rq_prio < highest_prio)
 			continue;

-		if (rq_prio > highest_prio ||
-		    deadline_after(rq->rq_deadline, latest_deadline)) {
+		if (rq_prio > highest_prio)
+			goto set;
+		if (deadline_after(rq->rq_deadline, latest_deadline)) {
 			latest_deadline = rq->rq_deadline;
-			highest_prio = rq_prio;
+set:			highest_prio = rq_prio;
 			highest_prio_rq = rq;
 		}
 	}

 	if (likely(highest_prio_rq)) {
-		if (can_preempt(p, highest_prio, highest_prio_rq->rq_deadline))
+		//if (can_preempt(p, highest_prio, highest_prio_rq->rq_deadline))
 			resched_task(highest_prio_rq->curr);
 	}
 }
@@ -1485,34 +1461,18 @@ static void try_preempt(struct task_stru
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
+#else
+	schedstat_inc(rq, ttwu_local);
+#endif
 	schedstat_inc(rq, ttwu_count);
-#endif /* CONFIG_SCHEDSTATS */
+#endif
 }

 static inline void ttwu_activate(struct task_struct *p, struct rq *rq,
@@ -1593,7 +1553,7 @@ static bool try_to_wake_up(struct task_s
 	if (task_queued(p) || task_running(p))
 		goto out_running;

-	ttwu_activate(p, rq, wake_flags & WF_SYNC);
+	ttwu_activate(p, rq, !!(wake_flags & WF_SYNC));
 	success = true;

 out_running:
@@ -1601,7 +1561,7 @@ out_running:
 out_unlock:
 	task_grq_unlock(&flags);

-	ttwu_stat(p, cpu, wake_flags);
+	ttwu_stat(p, success);

 	put_cpu();

@@ -1627,13 +1587,9 @@ static void try_to_wake_up_local(struct
 		return;

 	if (!task_queued(p)) {
-		if (likely(!task_running(p))) {
-			schedstat_inc(rq, ttwu_count);
-			schedstat_inc(rq, ttwu_local);
-		}
 		ttwu_activate(p, rq, false);
-		ttwu_stat(p, smp_processor_id(), 0);
 		success = true;
+		ttwu_stat(p, success);
 	}
 	ttwu_post_activation(p, rq, success);
 }
@@ -1681,7 +1637,6 @@ void sched_fork(struct task_struct *p)
 	 * event cannot wake it up and insert it on the runqueue either.
 	 */
 	p->state = TASK_RUNNING;
-	set_task_cpu(p, cpu);

 	/* Should be reset in fork.c but done here for ease of bfs patching */
 	p->sched_time = p->stime_pc = p->utime_pc = 0;
@@ -1719,6 +1674,11 @@ void sched_fork(struct task_struct *p)
 		memset(&p->sched_info, 0, sizeof(p->sched_info));
 #endif

+#ifdef CONFIG_SCHEDSTATS
+#ifdef CONFIG_SMP
+	p->wakeup_cpu = -1;
+#endif
+#endif
 	p->on_cpu = false;
 	clear_sticky(p);

@@ -1726,8 +1686,6 @@ void sched_fork(struct task_struct *p)
 	/* Want to start with kernel preemption disabled. */
 	task_thread_info(p)->preempt_count = 1;
 #endif
-	if (unlikely(p->policy == SCHED_FIFO))
-		goto out;
 	/*
 	 * Share the timeslice between parent and child, thus the
 	 * total amount of pending timeslices in the system doesn't change,
@@ -1738,6 +1696,9 @@ void sched_fork(struct task_struct *p)
 	 * is always equal to current->deadline.
 	 */
 	rq = task_grq_lock_irq(curr);
+	set_task_cpu(p, cpu);
+	if (unlikely(p->policy == SCHED_FIFO))
+		goto out;
 	if (likely(rq->rq_time_slice >= RESCHED_US * 2)) {
 		rq->rq_time_slice /= 2;
 		p->time_slice = rq->rq_time_slice;
@@ -1753,8 +1714,8 @@ void sched_fork(struct task_struct *p)
 		time_slice_expired(p);
 	}
 	p->last_ran = rq->rq_last_ran;
-	task_grq_unlock_irq();
 out:
+	task_grq_unlock_irq();
 	put_cpu();
 }

@@ -1771,7 +1732,7 @@ void wake_up_new_task(struct task_struct
 	unsigned long flags;
 	struct rq *rq;

-	rq = task_grq_lock(p, &flags);
+	rq = task_grq_lock(p->parent, &flags);
 	p->state = TASK_RUNNING;
 	parent = p->parent;
 	/* Unnecessary but small chance that the parent changed CPU */
@@ -2063,7 +2024,8 @@ unsigned long nr_active(void)
 /* Beyond a task running on this CPU, load is equal everywhere on BFS */
 unsigned long this_cpu_load(void)
 {
-	return this_rq()->rq_running +
+	struct rq *rq = this_rq();
+	return (rq->curr != rq->idle) +
 		((queued_notrunning() + nr_uninterruptible()) / grq.noc);
 }

@@ -2598,28 +2560,6 @@ static void account_guest_time(struct ta
 	}
 }

-/*
- * Account system cpu time to a process and desired cpustat field
- * @p: the process that the cpu time gets accounted to
- * @cputime: the cpu time spent in kernel space since the last update
- * @cputime_scaled: cputime scaled by cpu frequency
- * @target_cputime64: pointer to cpustat field that has to be updated
- */
-static inline
-void __account_system_time(struct task_struct *p, cputime_t cputime,
-			cputime_t cputime_scaled, cputime64_t *target_cputime64)
-{
-	/* Add system time to process. */
-	p->stime += (__force u64)cputime;
-	p->stimescaled += (__force u64)cputime_scaled;
-	account_group_system_time(p, cputime);
-
-	/* Add system time to cpustat. */
-	*target_cputime64 += (__force u64)cputime;
-
-	/* Account for system time used */
-	acct_update_integrals(p);
-}

 /*
  * Account system cpu time to a process.
@@ -2764,12 +2704,8 @@ static void task_running_tick(struct rq
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
@@ -2805,15 +2741,15 @@ static void task_running_tick(struct rq
 	} else if (rq->rq_time_slice >= RESCHED_US)
 			return;

-	/* p->time_slice < RESCHED_US. We only modify task_struct under grq lock */
+	/*
+	 * With irq disabled, current is descheduled without global lock
+	 * held and IPI cared.
+	 */
 	p = rq->curr;
-	grq_lock();
-	requeue_task(p);
-	set_tsk_need_resched(p);
-	grq_unlock();
+	if (!test_tsk_need_resched(p))
+		set_tsk_need_resched(p);
 }

-void wake_up_idle_cpu(int cpu);

 /*
  * This function gets called by the timer code, with HZ frequency.
@@ -2822,8 +2758,7 @@ void wake_up_idle_cpu(int cpu);
  */
 void scheduler_tick(void)
 {
-	int cpu __maybe_unused = smp_processor_id();
-	struct rq *rq = cpu_rq(cpu);
+	struct rq *rq = this_rq();

 	sched_clock_tick();
 	/* grq lock not grabbed, so only update rq clock */
@@ -3065,18 +3000,24 @@ task_struct *earliest_deadline_task(stru
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
+			dl = p->deadline;
+#ifdef CONFIG_SMP
+			switch (edl_mode) {
+			default:
+			case EDL_CK:
+				dl <<= locality_diff(p, rq) + scaling_rq(rq);
+				break;
+			case EDL_MS:
+				dl += MS_TO_NS(locality_diff(p, rq) +
+						4* scaling_rq(rq));
+			case EDL_NONE:
+				break;
+			}
+#endif

 			if (deadline_before(dl, earliest_deadline)) {
 				earliest_deadline = dl;
@@ -3087,6 +3028,7 @@ task_struct *earliest_deadline_task(stru

 out_take:
 	take_task(cpu, edt);
+	sched_info_dequeued(edt);
 	return edt;
 }

@@ -3143,10 +3085,6 @@ static inline void set_rq_task(struct rq
 	rq->rq_last_ran = p->last_ran = rq->clock;
 	rq->rq_policy = p->policy;
 	rq->rq_prio = p->prio;
-	if (p != rq->idle)
-		rq->rq_running = true;
-	else
-		rq->rq_running = false;
 }

 static void reset_rq_task(struct rq *rq, struct task_struct *p)
@@ -3177,6 +3115,11 @@ need_resched:
 	deactivate = false;
 	schedule_debug(prev);

+#ifdef CONFIG_SMP
+	grab_rq_lock++;
+	if (grunqueue_is_locked())
+		wait_rq_lock++;
+#endif
 	grq_lock_irq();

 	switch_count = &prev->nivcsw;
@@ -3286,6 +3229,8 @@ need_resched:
 		++*switch_count;

 		context_switch(rq, prev, next); /* unlocks the grq */
+#ifdef CONFIG_SCHEDSTATS
+#ifdef CONFIG_SMP
 		/*
 		 * The context switch have flipped the stack from under us
 		 * and restored the local variables which were saved when
@@ -3295,6 +3240,29 @@ need_resched:
 		cpu = smp_processor_id();
 		rq = cpu_rq(cpu);
 		idle = rq->idle;
+		next = rq->curr;
+		if (next == idle || next->wakeup_cpu < 0)
+			goto skip;
+
+		if (cpu == next->wakeup_cpu)
+			schedstat_inc(rq, ttwu_local);
+
+		else if (cpu_online(next->wakeup_cpu)) {
+			struct sched_domain *sd;
+
+			rcu_read_lock();
+			for_each_domain(next->wakeup_cpu, sd) {
+				if (cpumask_test_cpu(cpu, sched_domain_span(sd))) {
+					schedstat_inc(sd, ttwu_wake_remote);
+					break;
+				}
+			}
+			rcu_read_unlock();
+		}
+		next->wakeup_cpu = -1;
+skip:
+#endif
+#endif
 	} else
 		grq_unlock_irq();

@@ -3853,7 +3821,8 @@ void rt_mutex_setprio(struct task_struct
 		resched_task(p);
 	if (queued) {
 		enqueue_task(p);
-		try_preempt(p, rq);
+		if (prio < oldprio)
+			try_preempt(p, rq);
 	}

 	task_grq_unlock(&flags);
@@ -4567,7 +4536,6 @@ SYSCALL_DEFINE0(sched_yield)
 	p = current;
 	grq_lock_irq();
 	schedstat_inc(task_rq(p), yld_count);
-	requeue_task(p);

 	/*
 	 * Since we are going to call schedule() anyway, there's
@@ -4824,7 +4792,7 @@ SYSCALL_DEFINE2(sched_rr_get_interval, p
 		goto out_unlock;

 	grq_lock_irqsave(&flags);
-	time_slice = p->policy == SCHED_FIFO ? 0 : MS_TO_NS(task_timeslice(p));
+	time_slice = p->policy == SCHED_FIFO ? 0 : MS_TO_NS(rr_interval);
 	grq_unlock_irqrestore(&flags);

 	rcu_read_unlock();
@@ -4951,51 +4919,7 @@ void select_nohz_load_balancer(int stop_
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

-#endif /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
-
-static inline void resched_cpu(int cpu)
-{
-	unsigned long flags;
-
-	grq_lock_irqsave(&flags);
-	resched_task(cpu_curr(cpu));
-	grq_unlock_irqrestore(&flags);
-}

 /*
  * In the semi idle case, use the nearest busy cpu for migrating timers
@@ -5117,8 +5041,7 @@ int set_cpus_allowed_ptr(struct task_str
 			running_wrong = true;
 		} else
 			resched_task(p);
-	} else
-		set_task_cpu(p, cpumask_any_and(cpu_active_mask, new_mask));
+	}

 out:
 	if (queued)
@@ -5153,7 +5076,8 @@ static void break_sole_affinity(int src_
 				       task_pid_nr(p), p->comm, src_cpu);
 			}
 		}
-		clear_sticky(p);
+		if (task_sticky(p) && task_cpu(p) == src_cpu)
+			clear_sticky(p);
 	} while_each_thread(t, p);
 }

--- a/kernel/sysctl.c	Sun Jul  1 21:06:54 2012
+++ b/kernel/sysctl.c	Tue Jun 12 20:04:02 2012
@@ -125,6 +125,13 @@ static int __maybe_unused one_hundred =
 #ifdef CONFIG_SCHED_BFS
 extern int rr_interval;
 extern int sched_iso_cpu;
+#ifdef CONFIG_SMP
+extern int edl_mode;
+extern unsigned long grab_rq_lock,
+			wait_rq_lock,
+			tsk_csw,
+			cpu_csw;
+#endif
 static int __read_mostly one_thousand = 1000;
 #endif
 #ifdef CONFIG_PRINTK
@@ -876,6 +883,43 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one_hundred,
 	},
+#ifdef CONFIG_SMP
+	{
+		.procname	= "edl_mode",
+		.data		= &edl_mode,
+		.maxlen		= sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "cpu_csw",
+		.data		= &cpu_csw,
+		.maxlen		= sizeof (unsigned long),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
+	{
+		.procname	= "tsk_csw",
+		.data		= &tsk_csw,
+		.maxlen		= sizeof (unsigned long),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
+	{
+		.procname	= "grab_rq_lock",
+		.data		= &grab_rq_lock,
+		.maxlen		= sizeof (unsigned long),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
+	{
+		.procname	= "wait_rq_lock",
+		.data		= &wait_rq_lock,
+		.maxlen		= sizeof (unsigned long),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
+#endif
 #endif
 #if defined(CONFIG_S390) && defined(CONFIG_SMP)
 	{
--
