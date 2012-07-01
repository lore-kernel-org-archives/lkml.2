Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab2GAN1g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 09:27:36 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38775 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282Ab2GAN1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 09:27:34 -0400
MIME-Version: 1.0
Date: Sun, 1 Jul 2012 21:27:33 +0800
Message-ID: <CAJd=RBBSEVOUL-J=gGWO4FpbtC30_A8eb6HyKK48ZdjmNn_y-Q@mail.gmail.com>
Subject: [RFC patch] BFS: 421-1
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 15 patches collected, the 421-1 is ready with iso untouched.
Note diff is based not on 420 but on 421.


--- a/kernel/sched/bfs.c	Sun Jul  1 20:39:30 2012
+++ b/kernel/sched/bfs.c	Fri Jun 15 20:00:52 2012
@@ -113,7 +113,6 @@
 #define USER_PRIO(p)		((p) - MAX_RT_PRIO)
 #define TASK_USER_PRIO(p)	USER_PRIO((p)->static_prio)
 #define MAX_USER_PRIO		(USER_PRIO(MAX_PRIO))
-#define SCHED_PRIO(p)		((p) + MAX_RT_PRIO)
 #define STOP_PRIO		(MAX_RT_PRIO - 1)

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
@@ -327,7 +337,6 @@ int __weak arch_sd_sibling_asym_packing(
 {
        return 0*SD_ASYM_PACKING;
 }
-#endif

 #define rcu_dereference_check_sched_domain(p) \
 	rcu_dereference_check((p), \
@@ -342,6 +351,9 @@ int __weak arch_sd_sibling_asym_packing(
  */
 #define for_each_domain(cpu, __sd) \
 	for (__sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd);
__sd; __sd = __sd->parent)
+#else
+#define for_each_domain(cpu, __sd)	BUILD_BUG()
+#endif

 static inline void update_rq_clock(struct rq *rq);

@@ -523,12 +535,6 @@ static inline struct rq *task_grq_lock_i
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
@@ -986,15 +992,11 @@ static void activate_task(struct task_st
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
@@ -1029,16 +1031,10 @@ void set_task_cpu(struct task_struct *p,
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
@@ -1057,6 +1053,8 @@ resched_closest_idle(struct rq *rq, int
 {
 	cpumask_t tmpmask;

+	if (!grq.idle_cpus)
+		return;
 	cpus_and(tmpmask, p->cpus_allowed, grq.cpu_idle_map);
 	cpu_clear(cpu, tmpmask);
 	if (cpus_empty(tmpmask))
@@ -1125,29 +1123,12 @@ static inline void unstick_task(struct r
  */
 static inline void take_task(int cpu, struct task_struct *p)
 {
-#ifdef CONFIG_SCHEDSTATS
 #ifdef CONFIG_SMP
-	if (p->wakeup_cpu == -1)
-		goto skip;
-
-	if (cpu == p->wakeup_cpu) {
-		schedstat_inc(cpu_rq(cpu), ttwu_local);
+	if (p != current) {
+		tsk_csw++;
+		if (cpu != task_cpu(p))
+			cpu_csw++;
 	}
-	else if (cpu_online(p->wakeup_cpu)) {
-		struct sched_domain *sd;
-
-		rcu_read_lock();
-		for_each_domain(p->wakeup_cpu, sd) {
-			if (cpumask_test_cpu(cpu, sched_domain_span(sd))) {
-				schedstat_inc(sd, ttwu_wake_remote);
-				break;
-			}
-		}
-		rcu_read_unlock();
-	}
-	p->wakeup_cpu = -1;
-skip:
-#endif
 #endif
 	set_task_cpu(p, cpu);
 	dequeue_task(p);
@@ -1221,11 +1202,6 @@ inline int task_curr(const struct task_s
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
@@ -1456,10 +1432,11 @@ static void try_preempt(struct task_stru
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
@@ -1660,7 +1637,6 @@ void sched_fork(struct task_struct *p)
 	 * event cannot wake it up and insert it on the runqueue either.
 	 */
 	p->state = TASK_RUNNING;
-	set_task_cpu(p, cpu);

 	/* Should be reset in fork.c but done here for ease of bfs patching */
 	p->sched_time = p->stime_pc = p->utime_pc = 0;
@@ -1710,8 +1686,6 @@ void sched_fork(struct task_struct *p)
 	/* Want to start with kernel preemption disabled. */
 	task_thread_info(p)->preempt_count = 1;
 #endif
-	if (unlikely(p->policy == SCHED_FIFO))
-		goto out;
 	/*
 	 * Share the timeslice between parent and child, thus the
 	 * total amount of pending timeslices in the system doesn't change,
@@ -1722,6 +1696,9 @@ void sched_fork(struct task_struct *p)
 	 * is always equal to current->deadline.
 	 */
 	rq = task_grq_lock_irq(curr);
+	set_task_cpu(p, cpu);
+	if (unlikely(p->policy == SCHED_FIFO))
+		goto out;
 	if (likely(rq->rq_time_slice >= RESCHED_US * 2)) {
 		rq->rq_time_slice /= 2;
 		p->time_slice = rq->rq_time_slice;
@@ -1737,8 +1714,8 @@ void sched_fork(struct task_struct *p)
 		time_slice_expired(p);
 	}
 	p->last_ran = rq->rq_last_ran;
-	task_grq_unlock_irq();
 out:
+	task_grq_unlock_irq();
 	put_cpu();
 }

@@ -2047,7 +2024,8 @@ unsigned long nr_active(void)
 /* Beyond a task running on this CPU, load is equal everywhere on BFS */
 unsigned long this_cpu_load(void)
 {
-	return this_rq()->rq_running +
+	struct rq *rq = this_rq();
+	return (rq->curr != rq->idle) +
 		((queued_notrunning() + nr_uninterruptible()) / grq.noc);
 }

@@ -2582,28 +2560,6 @@ static void account_guest_time(struct ta
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
@@ -2785,11 +2741,13 @@ static void task_running_tick(struct rq
 	} else if (rq->rq_time_slice >= RESCHED_US)
 			return;

-	/* p->time_slice < RESCHED_US. We only modify task_struct under grq lock */
+	/*
+	 * With irq disabled, current is descheduled without global lock
+	 * held and IPI cared.
+	 */
 	p = rq->curr;
-	grq_lock();
-	set_tsk_need_resched(p);
-	grq_unlock();
+	if (!test_tsk_need_resched(p))
+		set_tsk_need_resched(p);
 }


@@ -3048,7 +3006,17 @@ task_struct *earliest_deadline_task(stru
 			 */
 			dl = p->deadline;
 #ifdef CONFIG_SMP
-			dl <<= locality_diff(p, rq) + scaling_rq(rq);
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
 #endif

 			if (deadline_before(dl, earliest_deadline)) {
@@ -3117,10 +3085,6 @@ static inline void set_rq_task(struct rq
 	rq->rq_last_ran = p->last_ran = rq->clock;
 	rq->rq_policy = p->policy;
 	rq->rq_prio = p->prio;
-	if (p != rq->idle)
-		rq->rq_running = true;
-	else
-		rq->rq_running = false;
 }

 static void reset_rq_task(struct rq *rq, struct task_struct *p)
@@ -3151,6 +3115,11 @@ need_resched:
 	deactivate = false;
 	schedule_debug(prev);

+#ifdef CONFIG_SMP
+	grab_rq_lock++;
+	if (grunqueue_is_locked())
+		wait_rq_lock++;
+#endif
 	grq_lock_irq();

 	switch_count = &prev->nivcsw;
@@ -3260,6 +3229,8 @@ need_resched:
 		++*switch_count;

 		context_switch(rq, prev, next); /* unlocks the grq */
+#ifdef CONFIG_SCHEDSTATS
+#ifdef CONFIG_SMP
 		/*
 		 * The context switch have flipped the stack from under us
 		 * and restored the local variables which were saved when
@@ -3269,6 +3240,29 @@ need_resched:
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

@@ -5352,7 +5346,7 @@ migration_call(struct notifier_block *nf
 		/* Update our root-domain */
 		grq_lock_irqsave(&flags);
 		if (rq->rd) {
-			BUG_ON(cpumask_test_cpu(cpu, rq->rd->span));
+			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));

 			set_rq_online(rq);
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
