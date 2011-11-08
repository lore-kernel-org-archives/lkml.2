Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab1KHOiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:38:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:43398 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab1KHOiS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:38:18 -0500
Subject: [RFC] sched: make separate sched*.c translation units
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 08 Nov 2011 15:38:03 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320763083.11519.13.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since once needs to do something at conferences and fixing compile
warnings doesn't actually require much if any attention I decided to
break up the sched.c #include "*.c" fest.

The below is the result, its compile tested for some but not all
possible CONFIG space variants (all-yes and all-no basically).

Hasn't seen a complete link/boot yet.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h    |    9 
 kernel/Makefile          |   10 
 kernel/sched.c           | 1860 ++---------------------------------------------
 kernel/sched.h           | 1048 ++++++++++++++++++++++++++
 kernel/sched_autogroup.h |   26 
 kernel/sched_debug.c     |    4 
 kernel/sched_fair.c      |  549 ++++++++++++-
 kernel/sched_idletask.c  |    4 
 kernel/sched_rt.c        |  209 +++++
 kernel/sched_stats.c     |  111 ++
 kernel/sched_stats.h     |  103 --
 kernel/sched_stoptask.c  |    4 
 12 files changed, 2009 insertions(+), 1928 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -56,7 +56,6 @@
 #include <linux/percpu.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
-#include <linux/stop_machine.h>
 #include <linux/sysctl.h>
 #include <linux/syscalls.h>
 #include <linux/times.h>
@@ -74,129 +73,17 @@
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
-#include <asm/mutex.h>
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #endif
 
-#include "sched_cpupri.h"
+#include "sched.h"
 #include "workqueue_sched.h"
-#include "sched_autogroup.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/sched.h>
 
-/*
- * Convert user-nice values [ -20 ... 0 ... 19 ]
- * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
- * and back.
- */
-#define NICE_TO_PRIO(nice)	(MAX_RT_PRIO + (nice) + 20)
-#define PRIO_TO_NICE(prio)	((prio) - MAX_RT_PRIO - 20)
-#define TASK_NICE(p)		PRIO_TO_NICE((p)->static_prio)
-
-/*
- * 'User priority' is the nice value converted to something we
- * can work with better when scaling various scheduler parameters,
- * it's a [ 0 ... 39 ] range.
- */
-#define USER_PRIO(p)		((p)-MAX_RT_PRIO)
-#define TASK_USER_PRIO(p)	USER_PRIO((p)->static_prio)
-#define MAX_USER_PRIO		(USER_PRIO(MAX_PRIO))
-
-/*
- * Helpers for converting nanosecond timing to jiffy resolution
- */
-#define NS_TO_JIFFIES(TIME)	((unsigned long)(TIME) / (NSEC_PER_SEC / HZ))
-
-#define NICE_0_LOAD		SCHED_LOAD_SCALE
-#define NICE_0_SHIFT		SCHED_LOAD_SHIFT
-
-/*
- * These are the 'tuning knobs' of the scheduler:
- *
- * default timeslice is 100 msecs (used only for SCHED_RR tasks).
- * Timeslices get refilled after they expire.
- */
-#define DEF_TIMESLICE		(100 * HZ / 1000)
-
-/*
- * single value that denotes runtime == period, ie unlimited time.
- */
-#define RUNTIME_INF	((u64)~0ULL)
-
-static inline int rt_policy(int policy)
-{
-	if (policy == SCHED_FIFO || policy == SCHED_RR)
-		return 1;
-	return 0;
-}
-
-static inline int task_has_rt_policy(struct task_struct *p)
-{
-	return rt_policy(p->policy);
-}
-
-/*
- * This is the priority-queue data structure of the RT scheduling class:
- */
-struct rt_prio_array {
-	DECLARE_BITMAP(bitmap, MAX_RT_PRIO+1); /* include 1 bit for delimiter */
-	struct list_head queue[MAX_RT_PRIO];
-};
-
-struct rt_bandwidth {
-	/* nests inside the rq lock: */
-	raw_spinlock_t		rt_runtime_lock;
-	ktime_t			rt_period;
-	u64			rt_runtime;
-	struct hrtimer		rt_period_timer;
-};
-
-static struct rt_bandwidth def_rt_bandwidth;
-
-static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun);
-
-static enum hrtimer_restart sched_rt_period_timer(struct hrtimer *timer)
-{
-	struct rt_bandwidth *rt_b =
-		container_of(timer, struct rt_bandwidth, rt_period_timer);
-	ktime_t now;
-	int overrun;
-	int idle = 0;
-
-	for (;;) {
-		now = hrtimer_cb_get_time(timer);
-		overrun = hrtimer_forward(timer, now, rt_b->rt_period);
-
-		if (!overrun)
-			break;
-
-		idle = do_sched_rt_period_timer(rt_b, overrun);
-	}
-
-	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
-}
-
-static
-void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime)
-{
-	rt_b->rt_period = ns_to_ktime(period);
-	rt_b->rt_runtime = runtime;
-
-	raw_spin_lock_init(&rt_b->rt_runtime_lock);
-
-	hrtimer_init(&rt_b->rt_period_timer,
-			CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	rt_b->rt_period_timer.function = sched_rt_period_timer;
-}
-
-static inline int rt_bandwidth_enabled(void)
-{
-	return sysctl_sched_rt_runtime >= 0;
-}
-
-static void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period)
+void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period)
 {
 	unsigned long delta;
 	ktime_t soft, hard, now;
@@ -216,580 +103,16 @@ static void start_bandwidth_timer(struct
 	}
 }
 
-static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
-{
-	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
-		return;
-
-	if (hrtimer_active(&rt_b->rt_period_timer))
-		return;
-
-	raw_spin_lock(&rt_b->rt_runtime_lock);
-	start_bandwidth_timer(&rt_b->rt_period_timer, rt_b->rt_period);
-	raw_spin_unlock(&rt_b->rt_runtime_lock);
-}
-
-#ifdef CONFIG_RT_GROUP_SCHED
-static void destroy_rt_bandwidth(struct rt_bandwidth *rt_b)
-{
-	hrtimer_cancel(&rt_b->rt_period_timer);
-}
-#endif
-
 /*
  * sched_domains_mutex serializes calls to init_sched_domains,
  * detach_destroy_domains and partition_sched_domains.
  */
-static DEFINE_MUTEX(sched_domains_mutex);
-
-#ifdef CONFIG_CGROUP_SCHED
-
-#include <linux/cgroup.h>
-
-struct cfs_rq;
-
-static LIST_HEAD(task_groups);
-
-struct cfs_bandwidth {
-#ifdef CONFIG_CFS_BANDWIDTH
-	raw_spinlock_t lock;
-	ktime_t period;
-	u64 quota, runtime;
-	s64 hierarchal_quota;
-	u64 runtime_expires;
-
-	int idle, timer_active;
-	struct hrtimer period_timer, slack_timer;
-	struct list_head throttled_cfs_rq;
-
-	/* statistics */
-	int nr_periods, nr_throttled;
-	u64 throttled_time;
-#endif
-};
-
-/* task group related information */
-struct task_group {
-	struct cgroup_subsys_state css;
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	/* schedulable entities of this group on each cpu */
-	struct sched_entity **se;
-	/* runqueue "owned" by this group on each cpu */
-	struct cfs_rq **cfs_rq;
-	unsigned long shares;
-
-	atomic_t load_weight;
-#endif
-
-#ifdef CONFIG_RT_GROUP_SCHED
-	struct sched_rt_entity **rt_se;
-	struct rt_rq **rt_rq;
-
-	struct rt_bandwidth rt_bandwidth;
-#endif
-
-	struct rcu_head rcu;
-	struct list_head list;
-
-	struct task_group *parent;
-	struct list_head siblings;
-	struct list_head children;
-
-#ifdef CONFIG_SCHED_AUTOGROUP
-	struct autogroup *autogroup;
-#endif
-
-	struct cfs_bandwidth cfs_bandwidth;
-};
-
-/* task_group_lock serializes the addition/removal of task groups */
-static DEFINE_SPINLOCK(task_group_lock);
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-
-# define ROOT_TASK_GROUP_LOAD	NICE_0_LOAD
-
-/*
- * A weight of 0 or 1 can cause arithmetics problems.
- * A weight of a cfs_rq is the sum of weights of which entities
- * are queued on this cfs_rq, so a weight of a entity should not be
- * too large, so as the shares value of a task group.
- * (The default weight is 1024 - so there's no practical
- *  limitation from this.)
- */
-#define MIN_SHARES	(1UL <<  1)
-#define MAX_SHARES	(1UL << 18)
-
-static int root_task_group_load = ROOT_TASK_GROUP_LOAD;
-#endif
-
-/* Default task group.
- *	Every task in system belong to this group at bootup.
- */
-struct task_group root_task_group;
-
-#endif	/* CONFIG_CGROUP_SCHED */
-
-/* CFS-related fields in a runqueue */
-struct cfs_rq {
-	struct load_weight load;
-	unsigned long nr_running, h_nr_running;
-
-	u64 exec_clock;
-	u64 min_vruntime;
-#ifndef CONFIG_64BIT
-	u64 min_vruntime_copy;
-#endif
-
-	struct rb_root tasks_timeline;
-	struct rb_node *rb_leftmost;
-
-	struct list_head tasks;
-	struct list_head *balance_iterator;
-
-	/*
-	 * 'curr' points to currently running entity on this cfs_rq.
-	 * It is set to NULL otherwise (i.e when none are currently running).
-	 */
-	struct sched_entity *curr, *next, *last, *skip;
-
-#ifdef	CONFIG_SCHED_DEBUG
-	unsigned int nr_spread_over;
-#endif
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	struct rq *rq;	/* cpu runqueue to which this cfs_rq is attached */
-
-	/*
-	 * leaf cfs_rqs are those that hold tasks (lowest schedulable entity in
-	 * a hierarchy). Non-leaf lrqs hold other higher schedulable entities
-	 * (like users, containers etc.)
-	 *
-	 * leaf_cfs_rq_list ties together list of leaf cfs_rq's in a cpu. This
-	 * list is used during load balance.
-	 */
-	int on_list;
-	struct list_head leaf_cfs_rq_list;
-	struct task_group *tg;	/* group that "owns" this runqueue */
-
-#ifdef CONFIG_SMP
-	/*
-	 * the part of load.weight contributed by tasks
-	 */
-	unsigned long task_weight;
-
-	/*
-	 *   h_load = weight * f(tg)
-	 *
-	 * Where f(tg) is the recursive weight fraction assigned to
-	 * this group.
-	 */
-	unsigned long h_load;
-
-	/*
-	 * Maintaining per-cpu shares distribution for group scheduling
-	 *
-	 * load_stamp is the last time we updated the load average
-	 * load_last is the last time we updated the load average and saw load
-	 * load_unacc_exec_time is currently unaccounted execution time
-	 */
-	u64 load_avg;
-	u64 load_period;
-	u64 load_stamp, load_last, load_unacc_exec_time;
-
-	unsigned long load_contribution;
-#endif
-#ifdef CONFIG_CFS_BANDWIDTH
-	int runtime_enabled;
-	u64 runtime_expires;
-	s64 runtime_remaining;
-
-	u64 throttled_timestamp;
-	int throttled, throttle_count;
-	struct list_head throttled_list;
-#endif
-#endif
-};
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-#ifdef CONFIG_CFS_BANDWIDTH
-static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
-{
-	return &tg->cfs_bandwidth;
-}
-
-static inline u64 default_cfs_period(void);
-static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun);
-static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b);
-
-static enum hrtimer_restart sched_cfs_slack_timer(struct hrtimer *timer)
-{
-	struct cfs_bandwidth *cfs_b =
-		container_of(timer, struct cfs_bandwidth, slack_timer);
-	do_sched_cfs_slack_timer(cfs_b);
-
-	return HRTIMER_NORESTART;
-}
-
-static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
-{
-	struct cfs_bandwidth *cfs_b =
-		container_of(timer, struct cfs_bandwidth, period_timer);
-	ktime_t now;
-	int overrun;
-	int idle = 0;
-
-	for (;;) {
-		now = hrtimer_cb_get_time(timer);
-		overrun = hrtimer_forward(timer, now, cfs_b->period);
-
-		if (!overrun)
-			break;
-
-		idle = do_sched_cfs_period_timer(cfs_b, overrun);
-	}
-
-	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
-}
-
-static void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
-{
-	raw_spin_lock_init(&cfs_b->lock);
-	cfs_b->runtime = 0;
-	cfs_b->quota = RUNTIME_INF;
-	cfs_b->period = ns_to_ktime(default_cfs_period());
-
-	INIT_LIST_HEAD(&cfs_b->throttled_cfs_rq);
-	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	cfs_b->period_timer.function = sched_cfs_period_timer;
-	hrtimer_init(&cfs_b->slack_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	cfs_b->slack_timer.function = sched_cfs_slack_timer;
-}
-
-static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq)
-{
-	cfs_rq->runtime_enabled = 0;
-	INIT_LIST_HEAD(&cfs_rq->throttled_list);
-}
-
-/* requires cfs_b->lock, may release to reprogram timer */
-static void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
-{
-	/*
-	 * The timer may be active because we're trying to set a new bandwidth
-	 * period or because we're racing with the tear-down path
-	 * (timer_active==0 becomes visible before the hrtimer call-back
-	 * terminates).  In either case we ensure that it's re-programmed
-	 */
-	while (unlikely(hrtimer_active(&cfs_b->period_timer))) {
-		raw_spin_unlock(&cfs_b->lock);
-		/* ensure cfs_b->lock is available while we wait */
-		hrtimer_cancel(&cfs_b->period_timer);
-
-		raw_spin_lock(&cfs_b->lock);
-		/* if someone else restarted the timer then we're done */
-		if (cfs_b->timer_active)
-			return;
-	}
-
-	cfs_b->timer_active = 1;
-	start_bandwidth_timer(&cfs_b->period_timer, cfs_b->period);
-}
-
-static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
-{
-	hrtimer_cancel(&cfs_b->period_timer);
-	hrtimer_cancel(&cfs_b->slack_timer);
-}
-#else
-static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
-static void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
-static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
-
-static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
-{
-	return NULL;
-}
-#endif /* CONFIG_CFS_BANDWIDTH */
-#endif /* CONFIG_FAIR_GROUP_SCHED */
-
-/* Real-Time classes' related field in a runqueue: */
-struct rt_rq {
-	struct rt_prio_array active;
-	unsigned long rt_nr_running;
-#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
-	struct {
-		int curr; /* highest queued rt task prio */
-#ifdef CONFIG_SMP
-		int next; /* next highest */
-#endif
-	} highest_prio;
-#endif
-#ifdef CONFIG_SMP
-	unsigned long rt_nr_migratory;
-	unsigned long rt_nr_total;
-	int overloaded;
-	struct plist_head pushable_tasks;
-#endif
-	int rt_throttled;
-	u64 rt_time;
-	u64 rt_runtime;
-	/* Nests inside the rq lock: */
-	raw_spinlock_t rt_runtime_lock;
-
-#ifdef CONFIG_RT_GROUP_SCHED
-	unsigned long rt_nr_boosted;
-
-	struct rq *rq;
-	struct list_head leaf_rt_rq_list;
-	struct task_group *tg;
-#endif
-};
-
-#ifdef CONFIG_SMP
-
-/*
- * We add the notion of a root-domain which will be used to define per-domain
- * variables. Each exclusive cpuset essentially defines an island domain by
- * fully partitioning the member cpus from any other cpuset. Whenever a new
- * exclusive cpuset is created, we also create and attach a new root-domain
- * object.
- *
- */
-struct root_domain {
-	atomic_t refcount;
-	atomic_t rto_count;
-	struct rcu_head rcu;
-	cpumask_var_t span;
-	cpumask_var_t online;
-
-	/*
-	 * The "RT overload" flag: it gets set if a CPU has more than
-	 * one runnable RT task.
-	 */
-	cpumask_var_t rto_mask;
-	struct cpupri cpupri;
-};
-
-/*
- * By default the system creates a single root-domain with all cpus as
- * members (mimicking the global state we have today).
- */
-static struct root_domain def_root_domain;
-
-#endif /* CONFIG_SMP */
-
-/*
- * This is the main, per-CPU runqueue data structure.
- *
- * Locking rule: those places that want to lock multiple runqueues
- * (such as the load balancing or the thread migration code), lock
- * acquire operations must be ordered by ascending &runqueue.
- */
-struct rq {
-	/* runqueue lock: */
-	raw_spinlock_t lock;
-
-	/*
-	 * nr_running and cpu_load should be in the same cacheline because
-	 * remote CPUs use both these fields when doing load calculation.
-	 */
-	unsigned long nr_running;
-	#define CPU_LOAD_IDX_MAX 5
-	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
-	unsigned long last_load_update_tick;
-#ifdef CONFIG_NO_HZ
-	u64 nohz_stamp;
-	unsigned char nohz_balance_kick;
-#endif
-	int skip_clock_update;
-
-	/* capture load from *all* tasks on this cpu: */
-	struct load_weight load;
-	unsigned long nr_load_updates;
-	u64 nr_switches;
-
-	struct cfs_rq cfs;
-	struct rt_rq rt;
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	/* list of leaf cfs_rq on this cpu: */
-	struct list_head leaf_cfs_rq_list;
-#endif
-#ifdef CONFIG_RT_GROUP_SCHED
-	struct list_head leaf_rt_rq_list;
-#endif
-
-	/*
-	 * This is part of a global counter where only the total sum
-	 * over all CPUs matters. A task can increase this counter on
-	 * one CPU and if it got migrated afterwards it may decrease
-	 * it on another CPU. Always updated under the runqueue lock:
-	 */
-	unsigned long nr_uninterruptible;
-
-	struct task_struct *curr, *idle, *stop;
-	unsigned long next_balance;
-	struct mm_struct *prev_mm;
-
-	u64 clock;
-	u64 clock_task;
-
-	atomic_t nr_iowait;
-
-#ifdef CONFIG_SMP
-	struct root_domain *rd;
-	struct sched_domain *sd;
-
-	unsigned long cpu_power;
-
-	unsigned char idle_balance;
-	/* For active balancing */
-	int post_schedule;
-	int active_balance;
-	int push_cpu;
-	struct cpu_stop_work active_balance_work;
-	/* cpu of this runqueue: */
-	int cpu;
-	int online;
-
-	u64 rt_avg;
-	u64 age_stamp;
-	u64 idle_stamp;
-	u64 avg_idle;
-#endif
-
-#ifdef CONFIG_IRQ_TIME_ACCOUNTING
-	u64 prev_irq_time;
-#endif
-#ifdef CONFIG_PARAVIRT
-	u64 prev_steal_time;
-#endif
-#ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
-	u64 prev_steal_time_rq;
-#endif
-
-	/* calc_load related fields */
-	unsigned long calc_load_update;
-	long calc_load_active;
-
-#ifdef CONFIG_SCHED_HRTICK
-#ifdef CONFIG_SMP
-	int hrtick_csd_pending;
-	struct call_single_data hrtick_csd;
-#endif
-	struct hrtimer hrtick_timer;
-#endif
-
-#ifdef CONFIG_SCHEDSTATS
-	/* latency stats */
-	struct sched_info rq_sched_info;
-	unsigned long long rq_cpu_time;
-	/* could above be rq->cfs_rq.exec_clock + rq->rt_rq.rt_runtime ? */
-
-	/* sys_sched_yield() stats */
-	unsigned int yld_count;
-
-	/* schedule() stats */
-	unsigned int sched_switch;
-	unsigned int sched_count;
-	unsigned int sched_goidle;
-
-	/* try_to_wake_up() stats */
-	unsigned int ttwu_count;
-	unsigned int ttwu_local;
-#endif
-
-#ifdef CONFIG_SMP
-	struct llist_head wake_list;
-#endif
-};
-
-static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
-
-
-static void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags);
-
-static inline int cpu_of(struct rq *rq)
-{
-#ifdef CONFIG_SMP
-	return rq->cpu;
-#else
-	return 0;
-#endif
-}
-
-#define rcu_dereference_check_sched_domain(p) \
-	rcu_dereference_check((p), \
-			      lockdep_is_held(&sched_domains_mutex))
-
-/*
- * The domain tree (rq->sd) is protected by RCU's quiescent state transition.
- * See detach_destroy_domains: synchronize_sched for details.
- *
- * The domain tree of any CPU may only be accessed from within
- * preempt-disabled sections.
- */
-#define for_each_domain(cpu, __sd) \
-	for (__sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd); __sd; __sd = __sd->parent)
-
-#define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
-#define this_rq()		(&__get_cpu_var(runqueues))
-#define task_rq(p)		cpu_rq(task_cpu(p))
-#define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
-#define raw_rq()		(&__raw_get_cpu_var(runqueues))
-
-#ifdef CONFIG_CGROUP_SCHED
-
-/*
- * Return the group to which this tasks belongs.
- *
- * We use task_subsys_state_check() and extend the RCU verification with
- * pi->lock and rq->lock because cpu_cgroup_attach() holds those locks for each
- * task it moves into the cgroup. Therefore by holding either of those locks,
- * we pin the task to the current cgroup.
- */
-static inline struct task_group *task_group(struct task_struct *p)
-{
-	struct task_group *tg;
-	struct cgroup_subsys_state *css;
-
-	css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
-			lockdep_is_held(&p->pi_lock) ||
-			lockdep_is_held(&task_rq(p)->lock));
-	tg = container_of(css, struct task_group, css);
-
-	return autogroup_task_group(p, tg);
-}
-
-/* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
-static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
-{
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
-	p->se.parent = task_group(p)->se[cpu];
-#endif
-
-#ifdef CONFIG_RT_GROUP_SCHED
-	p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
-	p->rt.parent = task_group(p)->rt_se[cpu];
-#endif
-}
-
-#else /* CONFIG_CGROUP_SCHED */
-
-static inline void set_task_rq(struct task_struct *p, unsigned int cpu) { }
-static inline struct task_group *task_group(struct task_struct *p)
-{
-	return NULL;
-}
-
-#endif /* CONFIG_CGROUP_SCHED */
+DEFINE_MUTEX(sched_domains_mutex);
+DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 
 static void update_rq_clock_task(struct rq *rq, s64 delta);
 
-static void update_rq_clock(struct rq *rq)
+void update_rq_clock(struct rq *rq)
 {
 	s64 delta;
 
@@ -802,40 +125,10 @@ static void update_rq_clock(struct rq *r
 }
 
 /*
- * Tunables that become constants when CONFIG_SCHED_DEBUG is off:
- */
-#ifdef CONFIG_SCHED_DEBUG
-# define const_debug __read_mostly
-#else
-# define const_debug static const
-#endif
-
-/**
- * runqueue_is_locked - Returns true if the current cpu runqueue is locked
- * @cpu: the processor in question.
- *
- * This interface allows printk to be called with the runqueue lock
- * held and know whether or not it is OK to wake up the klogd.
- */
-int runqueue_is_locked(int cpu)
-{
-	return raw_spin_is_locked(&cpu_rq(cpu)->lock);
-}
-
-/*
  * Debugging: various feature bits
  */
 
 #define SCHED_FEAT(name, enabled)	\
-	__SCHED_FEAT_##name ,
-
-enum {
-#include "sched_features.h"
-};
-
-#undef SCHED_FEAT
-
-#define SCHED_FEAT(name, enabled)	\
 	(1UL << __SCHED_FEAT_##name) * enabled |
 
 const_debug unsigned int sysctl_sched_features =
@@ -934,8 +227,6 @@ late_initcall(sched_init_debug);
 
 #endif
 
-#define sched_feat(x) (sysctl_sched_features & (1UL << __SCHED_FEAT_##x))
-
 /*
  * Number of tasks to iterate in a single balance run.
  * Limited because this is done with IRQs disabled.
@@ -950,126 +241,21 @@ const_debug unsigned int sysctl_sched_nr
  */
 const_debug unsigned int sysctl_sched_time_avg = MSEC_PER_SEC;
 
-/*
- * period over which we measure -rt task cpu usage in us.
- * default: 1s
- */
-unsigned int sysctl_sched_rt_period = 1000000;
-
-static __read_mostly int scheduler_running;
-
-/*
- * part of the period that we allow rt tasks to run in us.
- * default: 0.95s
- */
-int sysctl_sched_rt_runtime = 950000;
-
-static inline u64 global_rt_period(void)
-{
-	return (u64)sysctl_sched_rt_period * NSEC_PER_USEC;
-}
-
-static inline u64 global_rt_runtime(void)
-{
-	if (sysctl_sched_rt_runtime < 0)
-		return RUNTIME_INF;
-
-	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
-}
-
-#ifndef prepare_arch_switch
-# define prepare_arch_switch(next)	do { } while (0)
-#endif
-#ifndef finish_arch_switch
-# define finish_arch_switch(prev)	do { } while (0)
-#endif
-
-static inline int task_current(struct rq *rq, struct task_struct *p)
-{
-	return rq->curr == p;
-}
-
-static inline int task_running(struct rq *rq, struct task_struct *p)
-{
-#ifdef CONFIG_SMP
-	return p->on_cpu;
-#else
-	return task_current(rq, p);
-#endif
-}
-
-#ifndef __ARCH_WANT_UNLOCKED_CTXSW
-static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
-{
-#ifdef CONFIG_SMP
-	/*
-	 * We can optimise this out completely for !SMP, because the
-	 * SMP rebalancing from interrupt is the only thing that cares
-	 * here.
-	 */
-	next->on_cpu = 1;
-#endif
-}
-
-static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
-{
-#ifdef CONFIG_SMP
-	/*
-	 * After ->on_cpu is cleared, the task can be moved to a different CPU.
-	 * We must ensure this doesn't happen until the switch is completely
-	 * finished.
-	 */
-	smp_wmb();
-	prev->on_cpu = 0;
-#endif
-#ifdef CONFIG_DEBUG_SPINLOCK
-	/* this is a valid case when another task releases the spinlock */
-	rq->lock.owner = current;
-#endif
-	/*
-	 * If we are tracking spinlock dependencies then we have to
-	 * fix up the runqueue lock - which gets 'carried over' from
-	 * prev into current:
-	 */
-	spin_acquire(&rq->lock.dep_map, 0, 0, _THIS_IP_);
-
-	raw_spin_unlock_irq(&rq->lock);
-}
+/*
+ * period over which we measure -rt task cpu usage in us.
+ * default: 1s
+ */
+unsigned int sysctl_sched_rt_period = 1000000;
+
+__read_mostly int scheduler_running;
+
+/*
+ * part of the period that we allow rt tasks to run in us.
+ * default: 0.95s
+ */
+int sysctl_sched_rt_runtime = 950000;
 
-#else /* __ARCH_WANT_UNLOCKED_CTXSW */
-static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
-{
-#ifdef CONFIG_SMP
-	/*
-	 * We can optimise this out completely for !SMP, because the
-	 * SMP rebalancing from interrupt is the only thing that cares
-	 * here.
-	 */
-	next->on_cpu = 1;
-#endif
-#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-	raw_spin_unlock_irq(&rq->lock);
-#else
-	raw_spin_unlock(&rq->lock);
-#endif
-}
 
-static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
-{
-#ifdef CONFIG_SMP
-	/*
-	 * After ->on_cpu is cleared, the task can be moved to a different CPU.
-	 * We must ensure this doesn't happen until the switch is completely
-	 * finished.
-	 */
-	smp_wmb();
-	prev->on_cpu = 0;
-#endif
-#ifndef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-	local_irq_enable();
-#endif
-}
-#endif /* __ARCH_WANT_UNLOCKED_CTXSW */
 
 /*
  * __task_rq_lock - lock the rq @p resides on.
@@ -1152,20 +338,6 @@ static struct rq *this_rq_lock(void)
  * rq->lock.
  */
 
-/*
- * Use hrtick when:
- *  - enabled by features
- *  - hrtimer is actually high res
- */
-static inline int hrtick_enabled(struct rq *rq)
-{
-	if (!sched_feat(HRTICK))
-		return 0;
-	if (!cpu_active(cpu_of(rq)))
-		return 0;
-	return hrtimer_is_hres_active(&rq->hrtick_timer);
-}
-
 static void hrtick_clear(struct rq *rq)
 {
 	if (hrtimer_active(&rq->hrtick_timer))
@@ -1209,7 +381,7 @@ static void __hrtick_start(void *arg)
  *
  * called with rq->lock held and irqs disabled
  */
-static void hrtick_start(struct rq *rq, u64 delay)
+void hrtick_start(struct rq *rq, u64 delay)
 {
 	struct hrtimer *timer = &rq->hrtick_timer;
 	ktime_t time = ktime_add_ns(timer->base->get_time(), delay);
@@ -1304,7 +476,7 @@ static inline void init_hrtick(void)
 #define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
 #endif
 
-static void resched_task(struct task_struct *p)
+void resched_task(struct task_struct *p)
 {
 	int cpu;
 
@@ -1325,7 +497,7 @@ static void resched_task(struct task_str
 		smp_send_reschedule(cpu);
 }
 
-static void resched_cpu(int cpu)
+void resched_cpu(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
@@ -1418,12 +590,7 @@ static inline bool got_nohz_idle_kick(vo
 
 #endif /* CONFIG_NO_HZ */
 
-static u64 sched_avg_period(void)
-{
-	return (u64)sysctl_sched_time_avg * NSEC_PER_MSEC / 2;
-}
-
-static void sched_avg_update(struct rq *rq)
+void sched_avg_update(struct rq *rq)
 {
 	s64 period = sched_avg_period();
 
@@ -1439,487 +606,61 @@ static void sched_avg_update(struct rq *
 	}
 }
 
-static void sched_rt_avg_update(struct rq *rq, u64 rt_delta)
-{
-	rq->rt_avg += rt_delta;
-	sched_avg_update(rq);
-}
-
 #else /* !CONFIG_SMP */
-static void resched_task(struct task_struct *p)
+void resched_task(struct task_struct *p)
 {
 	assert_raw_spin_locked(&task_rq(p)->lock);
 	set_tsk_need_resched(p);
 }
-
-static void sched_rt_avg_update(struct rq *rq, u64 rt_delta)
-{
-}
-
-static void sched_avg_update(struct rq *rq)
-{
-}
 #endif /* CONFIG_SMP */
 
-#if BITS_PER_LONG == 32
-# define WMULT_CONST	(~0UL)
-#else
-# define WMULT_CONST	(1UL << 32)
-#endif
-
-#define WMULT_SHIFT	32
-
-/*
- * Shift right and round:
- */
-#define SRR(x, y) (((x) + (1UL << ((y) - 1))) >> (y))
-
-/*
- * delta *= weight / lw
- */
-static unsigned long
-calc_delta_mine(unsigned long delta_exec, unsigned long weight,
-		struct load_weight *lw)
-{
-	u64 tmp;
-
-	/*
-	 * weight can be less than 2^SCHED_LOAD_RESOLUTION for task group sched
-	 * entities since MIN_SHARES = 2. Treat weight as 1 if less than
-	 * 2^SCHED_LOAD_RESOLUTION.
-	 */
-	if (likely(weight > (1UL << SCHED_LOAD_RESOLUTION)))
-		tmp = (u64)delta_exec * scale_load_down(weight);
-	else
-		tmp = (u64)delta_exec;
-
-	if (!lw->inv_weight) {
-		unsigned long w = scale_load_down(lw->weight);
-
-		if (BITS_PER_LONG > 32 && unlikely(w >= WMULT_CONST))
-			lw->inv_weight = 1;
-		else if (unlikely(!w))
-			lw->inv_weight = WMULT_CONST;
-		else
-			lw->inv_weight = WMULT_CONST / w;
-	}
-
-	/*
-	 * Check whether we'd overflow the 64-bit multiplication:
-	 */
-	if (unlikely(tmp > WMULT_CONST))
-		tmp = SRR(SRR(tmp, WMULT_SHIFT/2) * lw->inv_weight,
-			WMULT_SHIFT/2);
-	else
-		tmp = SRR(tmp * lw->inv_weight, WMULT_SHIFT);
-
-	return (unsigned long)min(tmp, (u64)(unsigned long)LONG_MAX);
-}
-
-static inline void update_load_add(struct load_weight *lw, unsigned long inc)
-{
-	lw->weight += inc;
-	lw->inv_weight = 0;
-}
-
-static inline void update_load_sub(struct load_weight *lw, unsigned long dec)
-{
-	lw->weight -= dec;
-	lw->inv_weight = 0;
-}
-
-static inline void update_load_set(struct load_weight *lw, unsigned long w)
-{
-	lw->weight = w;
-	lw->inv_weight = 0;
-}
-
-/*
- * To aid in avoiding the subversion of "niceness" due to uneven distribution
- * of tasks with abnormal "nice" values across CPUs the contribution that
- * each task makes to its run queue's load is weighted according to its
- * scheduling class and "nice" value. For SCHED_NORMAL tasks this is just a
- * scaled version of the new time slice allocation that they receive on time
- * slice expiry etc.
- */
-
-#define WEIGHT_IDLEPRIO                3
-#define WMULT_IDLEPRIO         1431655765
-
-/*
- * Nice levels are multiplicative, with a gentle 10% change for every
- * nice level changed. I.e. when a CPU-bound task goes from nice 0 to
- * nice 1, it will get ~10% less CPU time than another CPU-bound task
- * that remained on nice 0.
- *
- * The "10% effect" is relative and cumulative: from _any_ nice level,
- * if you go up 1 level, it's -10% CPU usage, if you go down 1 level
- * it's +10% CPU usage. (to achieve that we use a multiplier of 1.25.
- * If a task goes up by ~10% and another task goes down by ~10% then
- * the relative distance between them is ~25%.)
- */
-static const int prio_to_weight[40] = {
- /* -20 */     88761,     71755,     56483,     46273,     36291,
- /* -15 */     29154,     23254,     18705,     14949,     11916,
- /* -10 */      9548,      7620,      6100,      4904,      3906,
- /*  -5 */      3121,      2501,      1991,      1586,      1277,
- /*   0 */      1024,       820,       655,       526,       423,
- /*   5 */       335,       272,       215,       172,       137,
- /*  10 */       110,        87,        70,        56,        45,
- /*  15 */        36,        29,        23,        18,        15,
-};
-
-/*
- * Inverse (2^32/x) values of the prio_to_weight[] array, precalculated.
- *
- * In cases where the weight does not change often, we can use the
- * precalculated inverse to speed up arithmetics by turning divisions
- * into multiplications:
- */
-static const u32 prio_to_wmult[40] = {
- /* -20 */     48388,     59856,     76040,     92818,    118348,
- /* -15 */    147320,    184698,    229616,    287308,    360437,
- /* -10 */    449829,    563644,    704093,    875809,   1099582,
- /*  -5 */   1376151,   1717300,   2157191,   2708050,   3363326,
- /*   0 */   4194304,   5237765,   6557202,   8165337,  10153587,
- /*   5 */  12820798,  15790321,  19976592,  24970740,  31350126,
- /*  10 */  39045157,  49367440,  61356676,  76695844,  95443717,
- /*  15 */ 119304647, 148102320, 186737708, 238609294, 286331153,
-};
-
-/* Time spent by the tasks of the cpu accounting group executing in ... */
-enum cpuacct_stat_index {
-	CPUACCT_STAT_USER,	/* ... user mode */
-	CPUACCT_STAT_SYSTEM,	/* ... kernel mode */
-
-	CPUACCT_STAT_NSTATS,
-};
-
-#ifdef CONFIG_CGROUP_CPUACCT
-static void cpuacct_charge(struct task_struct *tsk, u64 cputime);
-static void cpuacct_update_stats(struct task_struct *tsk,
-		enum cpuacct_stat_index idx, cputime_t val);
-#else
-static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime) {}
-static inline void cpuacct_update_stats(struct task_struct *tsk,
-		enum cpuacct_stat_index idx, cputime_t val) {}
-#endif
-
-static inline void inc_cpu_load(struct rq *rq, unsigned long load)
-{
-	update_load_add(&rq->load, load);
-}
-
-static inline void dec_cpu_load(struct rq *rq, unsigned long load)
-{
-	update_load_sub(&rq->load, load);
-}
-
 #if defined(CONFIG_RT_GROUP_SCHED) || (defined(CONFIG_FAIR_GROUP_SCHED) && \
 			(defined(CONFIG_SMP) || defined(CONFIG_CFS_BANDWIDTH)))
-typedef int (*tg_visitor)(struct task_group *, void *);
-
 /*
  * Iterate task_group tree rooted at *from, calling @down when first entering a
  * node and @up when leaving it for the final time.
  *
  * Caller must hold rcu_lock or sufficient equivalent.
  */
-static int walk_tg_tree_from(struct task_group *from,
+int walk_tg_tree_from(struct task_group *from,
 			     tg_visitor down, tg_visitor up, void *data)
 {
 	struct task_group *parent, *child;
 	int ret;
 
-	parent = from;
-
-down:
-	ret = (*down)(parent, data);
-	if (ret)
-		goto out;
-	list_for_each_entry_rcu(child, &parent->children, siblings) {
-		parent = child;
-		goto down;
-
-up:
-		continue;
-	}
-	ret = (*up)(parent, data);
-	if (ret || parent == from)
-		goto out;
-
-	child = parent;
-	parent = parent->parent;
-	if (parent)
-		goto up;
-out:
-	return ret;
-}
-
-/*
- * Iterate the full tree, calling @down when first entering a node and @up when
- * leaving it for the final time.
- *
- * Caller must hold rcu_lock or sufficient equivalent.
- */
-
-static inline int walk_tg_tree(tg_visitor down, tg_visitor up, void *data)
-{
-	return walk_tg_tree_from(&root_task_group, down, up, data);
-}
-
-static int tg_nop(struct task_group *tg, void *data)
-{
-	return 0;
-}
-#endif
-
-#ifdef CONFIG_SMP
-/* Used instead of source_load when we know the type == 0 */
-static unsigned long weighted_cpuload(const int cpu)
-{
-	return cpu_rq(cpu)->load.weight;
-}
-
-/*
- * Return a low guess at the load of a migration-source cpu weighted
- * according to the scheduling class and "nice" value.
- *
- * We want to under-estimate the load of migration sources, to
- * balance conservatively.
- */
-static unsigned long source_load(int cpu, int type)
-{
-	struct rq *rq = cpu_rq(cpu);
-	unsigned long total = weighted_cpuload(cpu);
-
-	if (type == 0 || !sched_feat(LB_BIAS))
-		return total;
-
-	return min(rq->cpu_load[type-1], total);
-}
-
-/*
- * Return a high guess at the load of a migration-target cpu weighted
- * according to the scheduling class and "nice" value.
- */
-static unsigned long target_load(int cpu, int type)
-{
-	struct rq *rq = cpu_rq(cpu);
-	unsigned long total = weighted_cpuload(cpu);
-
-	if (type == 0 || !sched_feat(LB_BIAS))
-		return total;
-
-	return max(rq->cpu_load[type-1], total);
-}
-
-static unsigned long power_of(int cpu)
-{
-	return cpu_rq(cpu)->cpu_power;
-}
-
-static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
-
-static unsigned long cpu_avg_load_per_task(int cpu)
-{
-	struct rq *rq = cpu_rq(cpu);
-	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
-
-	if (nr_running)
-		return rq->load.weight / nr_running;
-
-	return 0;
-}
-
-#ifdef CONFIG_PREEMPT
-
-static void double_rq_lock(struct rq *rq1, struct rq *rq2);
-
-/*
- * fair double_lock_balance: Safely acquires both rq->locks in a fair
- * way at the expense of forcing extra atomic operations in all
- * invocations.  This assures that the double_lock is acquired using the
- * same underlying policy as the spinlock_t on this architecture, which
- * reduces latency compared to the unfair variant below.  However, it
- * also adds more overhead and therefore may reduce throughput.
- */
-static inline int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
-	__releases(this_rq->lock)
-	__acquires(busiest->lock)
-	__acquires(this_rq->lock)
-{
-	raw_spin_unlock(&this_rq->lock);
-	double_rq_lock(this_rq, busiest);
-
-	return 1;
-}
-
-#else
-/*
- * Unfair double_lock_balance: Optimizes throughput at the expense of
- * latency by eliminating extra atomic operations when the locks are
- * already in proper order on entry.  This favors lower cpu-ids and will
- * grant the double lock to lower cpus over higher ids under contention,
- * regardless of entry order into the function.
- */
-static int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
-	__releases(this_rq->lock)
-	__acquires(busiest->lock)
-	__acquires(this_rq->lock)
-{
-	int ret = 0;
-
-	if (unlikely(!raw_spin_trylock(&busiest->lock))) {
-		if (busiest < this_rq) {
-			raw_spin_unlock(&this_rq->lock);
-			raw_spin_lock(&busiest->lock);
-			raw_spin_lock_nested(&this_rq->lock,
-					      SINGLE_DEPTH_NESTING);
-			ret = 1;
-		} else
-			raw_spin_lock_nested(&busiest->lock,
-					      SINGLE_DEPTH_NESTING);
-	}
-	return ret;
-}
-
-#endif /* CONFIG_PREEMPT */
-
-/*
- * double_lock_balance - lock the busiest runqueue, this_rq is locked already.
- */
-static int double_lock_balance(struct rq *this_rq, struct rq *busiest)
-{
-	if (unlikely(!irqs_disabled())) {
-		/* printk() doesn't work good under rq->lock */
-		raw_spin_unlock(&this_rq->lock);
-		BUG_ON(1);
-	}
-
-	return _double_lock_balance(this_rq, busiest);
-}
-
-static inline void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
-	__releases(busiest->lock)
-{
-	raw_spin_unlock(&busiest->lock);
-	lock_set_subclass(&this_rq->lock.dep_map, 0, _RET_IP_);
-}
-
-/*
- * double_rq_lock - safely lock two runqueues
- *
- * Note this does not disable interrupts like task_rq_lock,
- * you need to do so manually before calling.
- */
-static void double_rq_lock(struct rq *rq1, struct rq *rq2)
-	__acquires(rq1->lock)
-	__acquires(rq2->lock)
-{
-	BUG_ON(!irqs_disabled());
-	if (rq1 == rq2) {
-		raw_spin_lock(&rq1->lock);
-		__acquire(rq2->lock);	/* Fake it out ;) */
-	} else {
-		if (rq1 < rq2) {
-			raw_spin_lock(&rq1->lock);
-			raw_spin_lock_nested(&rq2->lock, SINGLE_DEPTH_NESTING);
-		} else {
-			raw_spin_lock(&rq2->lock);
-			raw_spin_lock_nested(&rq1->lock, SINGLE_DEPTH_NESTING);
-		}
-	}
-}
-
-/*
- * double_rq_unlock - safely unlock two runqueues
- *
- * Note this does not restore interrupts like task_rq_unlock,
- * you need to do so manually after calling.
- */
-static void double_rq_unlock(struct rq *rq1, struct rq *rq2)
-	__releases(rq1->lock)
-	__releases(rq2->lock)
-{
-	raw_spin_unlock(&rq1->lock);
-	if (rq1 != rq2)
-		raw_spin_unlock(&rq2->lock);
-	else
-		__release(rq2->lock);
-}
-
-#else /* CONFIG_SMP */
-
-/*
- * double_rq_lock - safely lock two runqueues
- *
- * Note this does not disable interrupts like task_rq_lock,
- * you need to do so manually before calling.
- */
-static void double_rq_lock(struct rq *rq1, struct rq *rq2)
-	__acquires(rq1->lock)
-	__acquires(rq2->lock)
-{
-	BUG_ON(!irqs_disabled());
-	BUG_ON(rq1 != rq2);
-	raw_spin_lock(&rq1->lock);
-	__acquire(rq2->lock);	/* Fake it out ;) */
-}
-
-/*
- * double_rq_unlock - safely unlock two runqueues
- *
- * Note this does not restore interrupts like task_rq_unlock,
- * you need to do so manually after calling.
- */
-static void double_rq_unlock(struct rq *rq1, struct rq *rq2)
-	__releases(rq1->lock)
-	__releases(rq2->lock)
-{
-	BUG_ON(rq1 != rq2);
-	raw_spin_unlock(&rq1->lock);
-	__release(rq2->lock);
-}
-
-#endif
-
-static void calc_load_account_idle(struct rq *this_rq);
-static void update_sysctl(void);
-static int get_update_sysctl_factor(void);
-static void update_cpu_load(struct rq *this_rq);
-
-static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
-{
-	set_task_rq(p, cpu);
-#ifdef CONFIG_SMP
-	/*
-	 * After ->cpu is set up to a new value, task_rq_lock(p, ...) can be
-	 * successfuly executed on another CPU. We must ensure that updates of
-	 * per-task data have been completed by this moment.
-	 */
-	smp_wmb();
-	task_thread_info(p)->cpu = cpu;
-#endif
-}
-
-static const struct sched_class rt_sched_class;
+	parent = from;
 
-#define sched_class_highest (&stop_sched_class)
-#define for_each_class(class) \
-   for (class = sched_class_highest; class; class = class->next)
+down:
+	ret = (*down)(parent, data);
+	if (ret)
+		goto out;
+	list_for_each_entry_rcu(child, &parent->children, siblings) {
+		parent = child;
+		goto down;
 
-#include "sched_stats.h"
+up:
+		continue;
+	}
+	ret = (*up)(parent, data);
+	if (ret || parent == from)
+		goto out;
 
-static void inc_nr_running(struct rq *rq)
-{
-	rq->nr_running++;
+	child = parent;
+	parent = parent->parent;
+	if (parent)
+		goto up;
+out:
+	return ret;
 }
 
-static void dec_nr_running(struct rq *rq)
+
+int tg_nop(struct task_group *tg, void *data)
 {
-	rq->nr_running--;
+	return 0;
 }
+#endif
+
+void update_cpu_load(struct rq *this_rq);
 
 static void set_load_weight(struct task_struct *p)
 {
@@ -1956,7 +697,7 @@ static void dequeue_task(struct rq *rq,
 /*
  * activate_task - move a task to the runqueue.
  */
-static void activate_task(struct rq *rq, struct task_struct *p, int flags)
+void activate_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible--;
@@ -1967,7 +708,7 @@ static void activate_task(struct rq *rq,
 /*
  * deactivate_task - remove a task from the runqueue.
  */
-static void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
+void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible++;
@@ -2192,15 +933,6 @@ static int irqtime_account_si_update(voi
 
 #endif
 
-#include "sched_idletask.c"
-#include "sched_fair.c"
-#include "sched_rt.c"
-#include "sched_autogroup.c"
-#include "sched_stoptask.c"
-#ifdef CONFIG_SCHED_DEBUG
-# include "sched_debug.c"
-#endif
-
 void sched_set_stop_task(int cpu, struct task_struct *stop)
 {
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
@@ -2298,7 +1030,7 @@ static inline void check_class_changed(s
 		p->sched_class->prio_changed(rq, p, oldprio);
 }
 
-static void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
+void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
 {
 	const struct sched_class *class;
 
@@ -2324,38 +1056,6 @@ static void check_preempt_curr(struct rq
 }
 
 #ifdef CONFIG_SMP
-/*
- * Is this task likely cache-hot:
- */
-static int
-task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
-{
-	s64 delta;
-
-	if (p->sched_class != &fair_sched_class)
-		return 0;
-
-	if (unlikely(p->policy == SCHED_IDLE))
-		return 0;
-
-	/*
-	 * Buddy candidates are cache hot:
-	 */
-	if (sched_feat(CACHE_HOT_BUDDY) && this_rq()->nr_running &&
-			(&p->se == cfs_rq_of(&p->se)->next ||
-			 &p->se == cfs_rq_of(&p->se)->last))
-		return 1;
-
-	if (sysctl_sched_migration_cost == -1)
-		return 1;
-	if (sysctl_sched_migration_cost == 0)
-		return 0;
-
-	delta = now - p->se.exec_start;
-
-	return delta < (s64)sysctl_sched_migration_cost;
-}
-
 void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 {
 #ifdef CONFIG_SCHED_DEBUG
@@ -3438,7 +2138,7 @@ calc_load(unsigned long load, unsigned l
  */
 static atomic_long_t calc_load_tasks_idle;
 
-static void calc_load_account_idle(struct rq *this_rq)
+void calc_load_account_idle(struct rq *this_rq)
 {
 	long delta;
 
@@ -3725,7 +2425,7 @@ decay_load_missed(unsigned long load, un
  * scheduler tick (TICK_NSEC). With tickless idle this will not be called
  * every tick. We fix it up based on jiffies.
  */
-static void update_cpu_load(struct rq *this_rq)
+void update_cpu_load(struct rq *this_rq)
 {
 	unsigned long this_load = this_rq->load.weight;
 	unsigned long curr_jiffies = jiffies;
@@ -6114,53 +4814,6 @@ void __cpuinit init_idle(struct task_str
 	ftrace_graph_init_idle_task(idle, cpu);
 }
 
-/*
- * Increase the granularity value when there are more CPUs,
- * because with more CPUs the 'effective latency' as visible
- * to users decreases. But the relationship is not linear,
- * so pick a second-best guess by going with the log2 of the
- * number of CPUs.
- *
- * This idea comes from the SD scheduler of Con Kolivas:
- */
-static int get_update_sysctl_factor(void)
-{
-	unsigned int cpus = min_t(int, num_online_cpus(), 8);
-	unsigned int factor;
-
-	switch (sysctl_sched_tunable_scaling) {
-	case SCHED_TUNABLESCALING_NONE:
-		factor = 1;
-		break;
-	case SCHED_TUNABLESCALING_LINEAR:
-		factor = cpus;
-		break;
-	case SCHED_TUNABLESCALING_LOG:
-	default:
-		factor = 1 + ilog2(cpus);
-		break;
-	}
-
-	return factor;
-}
-
-static void update_sysctl(void)
-{
-	unsigned int factor = get_update_sysctl_factor();
-
-#define SET_SYSCTL(name) \
-	(sysctl_##name = (factor) * normalized_sysctl_##name)
-	SET_SYSCTL(sched_min_granularity);
-	SET_SYSCTL(sched_latency);
-	SET_SYSCTL(sched_wakeup_granularity);
-#undef SET_SYSCTL
-}
-
-static inline void sched_init_granularity(void)
-{
-	update_sysctl();
-}
-
 #ifdef CONFIG_SMP
 void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
 {
@@ -6347,30 +5000,6 @@ static void calc_global_load_remove(stru
 	rq->calc_load_active = 0;
 }
 
-#ifdef CONFIG_CFS_BANDWIDTH
-static void unthrottle_offline_cfs_rqs(struct rq *rq)
-{
-	struct cfs_rq *cfs_rq;
-
-	for_each_leaf_cfs_rq(rq, cfs_rq) {
-		struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
-
-		if (!cfs_rq->runtime_enabled)
-			continue;
-
-		/*
-		 * clock_task is not advancing so we just need to make sure
-		 * there's some valid quota amount
-		 */
-		cfs_rq->runtime_remaining = cfs_b->quota;
-		if (cfs_rq_throttled(cfs_rq))
-			unthrottle_cfs_rq(cfs_rq);
-	}
-}
-#else
-static void unthrottle_offline_cfs_rqs(struct rq *rq) {}
-#endif
-
 /*
  * Migrate all tasks from the rq, sleeping tasks will be migrated by
  * try_to_wake_up()->select_task_rq().
@@ -6976,6 +5605,12 @@ static int init_rootdomain(struct root_d
 	return -ENOMEM;
 }
 
+/*
+ * By default the system creates a single root-domain with all cpus as
+ * members (mimicking the global state we have today).
+ */
+struct root_domain def_root_domain;
+
 static void init_defrootdomain(void)
 {
 	init_rootdomain(&def_root_domain);
@@ -7386,6 +6021,11 @@ static void init_sched_groups_power(int
 	update_group_power(sd, cpu);
 }
 
+int __weak arch_sd_sibling_asym_packing(void)
+{
+       return 0*SD_ASYM_PACKING;
+}
+
 /*
  * Initializers for schedule domains
  * Non-inlined to reduce accumulated stack pressure in build_sched_domains()
@@ -8021,29 +6661,6 @@ static int cpuset_cpu_inactive(struct no
 	}
 }
 
-static int update_runtime(struct notifier_block *nfb,
-				unsigned long action, void *hcpu)
-{
-	int cpu = (int)(long)hcpu;
-
-	switch (action) {
-	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
-		disable_runtime(cpu_rq(cpu));
-		return NOTIFY_OK;
-
-	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		enable_runtime(cpu_rq(cpu));
-		return NOTIFY_OK;
-
-	default:
-		return NOTIFY_DONE;
-	}
-}
-
 void __init sched_init_smp(void)
 {
 	cpumask_var_t non_isolated_cpus;
@@ -8092,104 +6709,7 @@ int in_sched_functions(unsigned long add
 		&& addr < (unsigned long)__sched_text_end);
 }
 
-static void init_cfs_rq(struct cfs_rq *cfs_rq)
-{
-	cfs_rq->tasks_timeline = RB_ROOT;
-	INIT_LIST_HEAD(&cfs_rq->tasks);
-	cfs_rq->min_vruntime = (u64)(-(1LL << 20));
-#ifndef CONFIG_64BIT
-	cfs_rq->min_vruntime_copy = cfs_rq->min_vruntime;
-#endif
-}
-
-static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
-{
-	struct rt_prio_array *array;
-	int i;
-
-	array = &rt_rq->active;
-	for (i = 0; i < MAX_RT_PRIO; i++) {
-		INIT_LIST_HEAD(array->queue + i);
-		__clear_bit(i, array->bitmap);
-	}
-	/* delimiter for bitsearch: */
-	__set_bit(MAX_RT_PRIO, array->bitmap);
-
-#if defined CONFIG_SMP
-	rt_rq->highest_prio.curr = MAX_RT_PRIO;
-	rt_rq->highest_prio.next = MAX_RT_PRIO;
-	rt_rq->rt_nr_migratory = 0;
-	rt_rq->overloaded = 0;
-	plist_head_init(&rt_rq->pushable_tasks);
-#endif
-
-	rt_rq->rt_time = 0;
-	rt_rq->rt_throttled = 0;
-	rt_rq->rt_runtime = 0;
-	raw_spin_lock_init(&rt_rq->rt_runtime_lock);
-}
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
-				struct sched_entity *se, int cpu,
-				struct sched_entity *parent)
-{
-	struct rq *rq = cpu_rq(cpu);
-
-	cfs_rq->tg = tg;
-	cfs_rq->rq = rq;
-#ifdef CONFIG_SMP
-	/* allow initial update_cfs_load() to truncate */
-	cfs_rq->load_stamp = 1;
-#endif
-	init_cfs_rq_runtime(cfs_rq);
-
-	tg->cfs_rq[cpu] = cfs_rq;
-	tg->se[cpu] = se;
-
-	/* se could be NULL for root_task_group */
-	if (!se)
-		return;
-
-	if (!parent)
-		se->cfs_rq = &rq->cfs;
-	else
-		se->cfs_rq = parent->my_q;
-
-	se->my_q = cfs_rq;
-	update_load_set(&se->load, 0);
-	se->parent = parent;
-}
-#endif
-
-#ifdef CONFIG_RT_GROUP_SCHED
-static void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
-		struct sched_rt_entity *rt_se, int cpu,
-		struct sched_rt_entity *parent)
-{
-	struct rq *rq = cpu_rq(cpu);
-
-	rt_rq->highest_prio.curr = MAX_RT_PRIO;
-	rt_rq->rt_nr_boosted = 0;
-	rt_rq->rq = rq;
-	rt_rq->tg = tg;
-
-	tg->rt_rq[cpu] = rt_rq;
-	tg->rt_se[cpu] = rt_se;
-
-	if (!rt_se)
-		return;
-
-	if (!parent)
-		rt_se->rt_rq = &rq->rt;
-	else
-		rt_se->rt_rq = parent->my_q;
-
-	rt_se->my_q = rt_rq;
-	rt_se->parent = parent;
-	INIT_LIST_HEAD(&rt_se->run_list);
-}
-#endif
+struct task_group root_task_group;
 
 void __init sched_init(void)
 {
@@ -8261,7 +6781,7 @@ void __init sched_init(void)
 		init_cfs_rq(&rq->cfs);
 		init_rt_rq(&rq->rt, rq);
 #ifdef CONFIG_FAIR_GROUP_SCHED
-		root_task_group.shares = root_task_group_load;
+		root_task_group.shares = ROOT_TASK_GROUP_LOAD;
 		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
 		/*
 		 * How much cpu bandwidth does root_task_group get?
@@ -8324,10 +6844,6 @@ void __init sched_init(void)
 	INIT_HLIST_HEAD(&init_task.preempt_notifiers);
 #endif
 
-#ifdef CONFIG_SMP
-	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
-#endif
-
 #ifdef CONFIG_RT_MUTEXES
 	plist_head_init(&init_task.pi_waiters);
 #endif
@@ -8355,17 +6871,11 @@ void __init sched_init(void)
 
 #ifdef CONFIG_SMP
 	zalloc_cpumask_var(&sched_domains_tmpmask, GFP_NOWAIT);
-#ifdef CONFIG_NO_HZ
-	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
-	alloc_cpumask_var(&nohz.grp_idle_mask, GFP_NOWAIT);
-	atomic_set(&nohz.load_balancer, nr_cpu_ids);
-	atomic_set(&nohz.first_pick_cpu, nr_cpu_ids);
-	atomic_set(&nohz.second_pick_cpu, nr_cpu_ids);
-#endif
 	/* May be allocated at isolcpus cmdline parse time */
 	if (cpu_isolated_map == NULL)
 		zalloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
-#endif /* SMP */
+#endif
+	init_sched_fair_class();
 
 	scheduler_running = 1;
 }
@@ -8517,169 +7027,14 @@ void set_curr_task(int cpu, struct task_
 
 #endif
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
-static void free_fair_sched_group(struct task_group *tg)
-{
-	int i;
-
-	destroy_cfs_bandwidth(tg_cfs_bandwidth(tg));
-
-	for_each_possible_cpu(i) {
-		if (tg->cfs_rq)
-			kfree(tg->cfs_rq[i]);
-		if (tg->se)
-			kfree(tg->se[i]);
-	}
-
-	kfree(tg->cfs_rq);
-	kfree(tg->se);
-}
-
-static
-int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
-{
-	struct cfs_rq *cfs_rq;
-	struct sched_entity *se;
-	int i;
-
-	tg->cfs_rq = kzalloc(sizeof(cfs_rq) * nr_cpu_ids, GFP_KERNEL);
-	if (!tg->cfs_rq)
-		goto err;
-	tg->se = kzalloc(sizeof(se) * nr_cpu_ids, GFP_KERNEL);
-	if (!tg->se)
-		goto err;
-
-	tg->shares = NICE_0_LOAD;
-
-	init_cfs_bandwidth(tg_cfs_bandwidth(tg));
-
-	for_each_possible_cpu(i) {
-		cfs_rq = kzalloc_node(sizeof(struct cfs_rq),
-				      GFP_KERNEL, cpu_to_node(i));
-		if (!cfs_rq)
-			goto err;
-
-		se = kzalloc_node(sizeof(struct sched_entity),
-				  GFP_KERNEL, cpu_to_node(i));
-		if (!se)
-			goto err_free_rq;
-
-		init_cfs_rq(cfs_rq);
-		init_tg_cfs_entry(tg, cfs_rq, se, i, parent->se[i]);
-	}
-
-	return 1;
-
-err_free_rq:
-	kfree(cfs_rq);
-err:
-	return 0;
-}
-
-static inline void unregister_fair_sched_group(struct task_group *tg, int cpu)
-{
-	struct rq *rq = cpu_rq(cpu);
-	unsigned long flags;
-
-	/*
-	* Only empty task groups can be destroyed; so we can speculatively
-	* check on_list without danger of it being re-added.
-	*/
-	if (!tg->cfs_rq[cpu]->on_list)
-		return;
-
-	raw_spin_lock_irqsave(&rq->lock, flags);
-	list_del_leaf_cfs_rq(tg->cfs_rq[cpu]);
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
-}
-#else /* !CONFIG_FAIR_GROUP_SCHED */
-static inline void free_fair_sched_group(struct task_group *tg)
-{
-}
-
-static inline
-int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
-{
-	return 1;
-}
-
-static inline void unregister_fair_sched_group(struct task_group *tg, int cpu)
-{
-}
-#endif /* CONFIG_FAIR_GROUP_SCHED */
-
 #ifdef CONFIG_RT_GROUP_SCHED
-static void free_rt_sched_group(struct task_group *tg)
-{
-	int i;
-
-	if (tg->rt_se)
-		destroy_rt_bandwidth(&tg->rt_bandwidth);
-
-	for_each_possible_cpu(i) {
-		if (tg->rt_rq)
-			kfree(tg->rt_rq[i]);
-		if (tg->rt_se)
-			kfree(tg->rt_se[i]);
-	}
-
-	kfree(tg->rt_rq);
-	kfree(tg->rt_se);
-}
-
-static
-int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
-{
-	struct rt_rq *rt_rq;
-	struct sched_rt_entity *rt_se;
-	int i;
-
-	tg->rt_rq = kzalloc(sizeof(rt_rq) * nr_cpu_ids, GFP_KERNEL);
-	if (!tg->rt_rq)
-		goto err;
-	tg->rt_se = kzalloc(sizeof(rt_se) * nr_cpu_ids, GFP_KERNEL);
-	if (!tg->rt_se)
-		goto err;
-
-	init_rt_bandwidth(&tg->rt_bandwidth,
-			ktime_to_ns(def_rt_bandwidth.rt_period), 0);
-
-	for_each_possible_cpu(i) {
-		rt_rq = kzalloc_node(sizeof(struct rt_rq),
-				     GFP_KERNEL, cpu_to_node(i));
-		if (!rt_rq)
-			goto err;
-
-		rt_se = kzalloc_node(sizeof(struct sched_rt_entity),
-				     GFP_KERNEL, cpu_to_node(i));
-		if (!rt_se)
-			goto err_free_rq;
-
-		init_rt_rq(rt_rq, cpu_rq(i));
-		rt_rq->rt_runtime = tg->rt_bandwidth.rt_runtime;
-		init_tg_rt_entry(tg, rt_rq, rt_se, i, parent->rt_se[i]);
-	}
-
-	return 1;
-
-err_free_rq:
-	kfree(rt_rq);
-err:
-	return 0;
-}
 #else /* !CONFIG_RT_GROUP_SCHED */
-static inline void free_rt_sched_group(struct task_group *tg)
-{
-}
-
-static inline
-int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
-{
-	return 1;
-}
 #endif /* CONFIG_RT_GROUP_SCHED */
 
 #ifdef CONFIG_CGROUP_SCHED
+/* task_group_lock serializes the addition/removal of task groups */
+static DEFINE_SPINLOCK(task_group_lock);
+
 static void free_sched_group(struct task_group *tg)
 {
 	free_fair_sched_group(tg);
@@ -8785,47 +7140,6 @@ void sched_move_task(struct task_struct
 #endif /* CONFIG_CGROUP_SCHED */
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static DEFINE_MUTEX(shares_mutex);
-
-int sched_group_set_shares(struct task_group *tg, unsigned long shares)
-{
-	int i;
-	unsigned long flags;
-
-	/*
-	 * We can't change the weight of the root cgroup.
-	 */
-	if (!tg->se[0])
-		return -EINVAL;
-
-	shares = clamp(shares, scale_load(MIN_SHARES), scale_load(MAX_SHARES));
-
-	mutex_lock(&shares_mutex);
-	if (tg->shares == shares)
-		goto done;
-
-	tg->shares = shares;
-	for_each_possible_cpu(i) {
-		struct rq *rq = cpu_rq(i);
-		struct sched_entity *se;
-
-		se = tg->se[i];
-		/* Propagate contribution to hierarchy */
-		raw_spin_lock_irqsave(&rq->lock, flags);
-		for_each_sched_entity(se)
-			update_cfs_shares(group_cfs_rq(se));
-		raw_spin_unlock_irqrestore(&rq->lock, flags);
-	}
-
-done:
-	mutex_unlock(&shares_mutex);
-	return 0;
-}
-
-unsigned long sched_group_shares(struct task_group *tg)
-{
-	return tg->shares;
-}
 #endif
 
 #if defined(CONFIG_RT_GROUP_SCHED) || defined(CONFIG_CFS_BANDWIDTH)
@@ -8850,7 +7164,7 @@ static inline int tg_has_rt_tasks(struct
 	struct task_struct *g, *p;
 
 	do_each_thread(g, p) {
-		if (rt_task(p) && rt_rq_of_se(&p->rt)->tg == tg)
+		if (rt_task(p) && task_rq(p)->rt.tg == tg)
 			return 1;
 	} while_each_thread(g, p);
 
@@ -9202,7 +7516,7 @@ static int __cfs_schedulable(struct task
 static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 {
 	int i, ret = 0, runtime_enabled;
-	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
+	struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
 
 	if (tg == &root_task_group)
 		return -EINVAL;
@@ -9244,13 +7558,13 @@ static int tg_set_cfs_bandwidth(struct t
 
 	for_each_possible_cpu(i) {
 		struct cfs_rq *cfs_rq = tg->cfs_rq[i];
-		struct rq *rq = rq_of(cfs_rq);
+		struct rq *rq = cfs_rq->rq;
 
 		raw_spin_lock_irq(&rq->lock);
 		cfs_rq->runtime_enabled = runtime_enabled;
 		cfs_rq->runtime_remaining = 0;
 
-		if (cfs_rq_throttled(cfs_rq))
+		if (cfs_rq->throttled)
 			unthrottle_cfs_rq(cfs_rq);
 		raw_spin_unlock_irq(&rq->lock);
 	}
@@ -9264,7 +7578,7 @@ int tg_set_cfs_quota(struct task_group *
 {
 	u64 quota, period;
 
-	period = ktime_to_ns(tg_cfs_bandwidth(tg)->period);
+	period = ktime_to_ns(tg->cfs_bandwidth.period);
 	if (cfs_quota_us < 0)
 		quota = RUNTIME_INF;
 	else
@@ -9277,10 +7591,10 @@ long tg_get_cfs_quota(struct task_group
 {
 	u64 quota_us;
 
-	if (tg_cfs_bandwidth(tg)->quota == RUNTIME_INF)
+	if (tg->cfs_bandwidth.quota == RUNTIME_INF)
 		return -1;
 
-	quota_us = tg_cfs_bandwidth(tg)->quota;
+	quota_us = tg->cfs_bandwidth.quota;
 	do_div(quota_us, NSEC_PER_USEC);
 
 	return quota_us;
@@ -9291,7 +7605,7 @@ int tg_set_cfs_period(struct task_group
 	u64 quota, period;
 
 	period = (u64)cfs_period_us * NSEC_PER_USEC;
-	quota = tg_cfs_bandwidth(tg)->quota;
+	quota = tg->cfs_bandwidth.quota;
 
 	if (period <= 0)
 		return -EINVAL;
@@ -9303,7 +7617,7 @@ long tg_get_cfs_period(struct task_group
 {
 	u64 cfs_period_us;
 
-	cfs_period_us = ktime_to_ns(tg_cfs_bandwidth(tg)->period);
+	cfs_period_us = ktime_to_ns(tg->cfs_bandwidth.period);
 	do_div(cfs_period_us, NSEC_PER_USEC);
 
 	return cfs_period_us;
@@ -9363,13 +7677,13 @@ static u64 normalize_cfs_quota(struct ta
 static int tg_cfs_schedulable_down(struct task_group *tg, void *data)
 {
 	struct cfs_schedulable_data *d = data;
-	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
+	struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
 	s64 quota = 0, parent_quota = -1;
 
 	if (!tg->parent) {
 		quota = RUNTIME_INF;
 	} else {
-		struct cfs_bandwidth *parent_b = tg_cfs_bandwidth(tg->parent);
+		struct cfs_bandwidth *parent_b = &tg->parent->cfs_bandwidth;
 
 		quota = normalize_cfs_quota(tg, d);
 		parent_quota = parent_b->hierarchal_quota;
@@ -9413,7 +7727,7 @@ static int cpu_stats_show(struct cgroup
 		struct cgroup_map_cb *cb)
 {
 	struct task_group *tg = cgroup_tg(cgrp);
-	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
+	struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
 
 	cb->fill(cb, "nr_periods", cfs_b->nr_periods);
 	cb->fill(cb, "nr_throttled", cfs_b->nr_throttled);
@@ -9712,7 +8026,7 @@ static int cpuacct_populate(struct cgrou
  *
  * called with rq->lock held.
  */
-static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
+void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 {
 	struct cpuacct *ca;
 	int cpu;
@@ -9754,7 +8068,7 @@ static void cpuacct_charge(struct task_s
 /*
  * Charge the system/user time to the task's accounting group.
  */
-static void cpuacct_update_stats(struct task_struct *tsk,
+void cpuacct_update_stats(struct task_struct *tsk,
 		enum cpuacct_stat_index idx, cputime_t val)
 {
 	struct cpuacct *ca;
Index: linux-2.6/kernel/sched.h
===================================================================
--- /dev/null
+++ linux-2.6/kernel/sched.h
@@ -0,0 +1,1048 @@
+
+#include <linux/sched.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/stop_machine.h>
+
+#include "sched_cpupri.h"
+
+extern __read_mostly int scheduler_running;
+
+/*
+ * Convert user-nice values [ -20 ... 0 ... 19 ]
+ * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
+ * and back.
+ */
+#define NICE_TO_PRIO(nice)	(MAX_RT_PRIO + (nice) + 20)
+#define PRIO_TO_NICE(prio)	((prio) - MAX_RT_PRIO - 20)
+#define TASK_NICE(p)		PRIO_TO_NICE((p)->static_prio)
+
+/*
+ * 'User priority' is the nice value converted to something we
+ * can work with better when scaling various scheduler parameters,
+ * it's a [ 0 ... 39 ] range.
+ */
+#define USER_PRIO(p)		((p)-MAX_RT_PRIO)
+#define TASK_USER_PRIO(p)	USER_PRIO((p)->static_prio)
+#define MAX_USER_PRIO		(USER_PRIO(MAX_PRIO))
+
+/*
+ * Helpers for converting nanosecond timing to jiffy resolution
+ */
+#define NS_TO_JIFFIES(TIME)	((unsigned long)(TIME) / (NSEC_PER_SEC / HZ))
+
+#define NICE_0_LOAD		SCHED_LOAD_SCALE
+#define NICE_0_SHIFT		SCHED_LOAD_SHIFT
+
+/*
+ * These are the 'tuning knobs' of the scheduler:
+ *
+ * default timeslice is 100 msecs (used only for SCHED_RR tasks).
+ * Timeslices get refilled after they expire.
+ */
+#define DEF_TIMESLICE		(100 * HZ / 1000)
+
+/*
+ * single value that denotes runtime == period, ie unlimited time.
+ */
+#define RUNTIME_INF	((u64)~0ULL)
+
+static inline int rt_policy(int policy)
+{
+	if (policy == SCHED_FIFO || policy == SCHED_RR)
+		return 1;
+	return 0;
+}
+
+static inline int task_has_rt_policy(struct task_struct *p)
+{
+	return rt_policy(p->policy);
+}
+
+/*
+ * This is the priority-queue data structure of the RT scheduling class:
+ */
+struct rt_prio_array {
+	DECLARE_BITMAP(bitmap, MAX_RT_PRIO+1); /* include 1 bit for delimiter */
+	struct list_head queue[MAX_RT_PRIO];
+};
+
+struct rt_bandwidth {
+	/* nests inside the rq lock: */
+	raw_spinlock_t		rt_runtime_lock;
+	ktime_t			rt_period;
+	u64			rt_runtime;
+	struct hrtimer		rt_period_timer;
+};
+
+extern struct mutex sched_domains_mutex;
+
+#ifdef CONFIG_CGROUP_SCHED
+
+#include <linux/cgroup.h>
+
+struct cfs_rq;
+
+static LIST_HEAD(task_groups);
+
+struct cfs_bandwidth {
+#ifdef CONFIG_CFS_BANDWIDTH
+	raw_spinlock_t lock;
+	ktime_t period;
+	u64 quota, runtime;
+	s64 hierarchal_quota;
+	u64 runtime_expires;
+
+	int idle, timer_active;
+	struct hrtimer period_timer, slack_timer;
+	struct list_head throttled_cfs_rq;
+
+	/* statistics */
+	int nr_periods, nr_throttled;
+	u64 throttled_time;
+#endif
+};
+
+/* task group related information */
+struct task_group {
+	struct cgroup_subsys_state css;
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	/* schedulable entities of this group on each cpu */
+	struct sched_entity **se;
+	/* runqueue "owned" by this group on each cpu */
+	struct cfs_rq **cfs_rq;
+	unsigned long shares;
+
+	atomic_t load_weight;
+#endif
+
+#ifdef CONFIG_RT_GROUP_SCHED
+	struct sched_rt_entity **rt_se;
+	struct rt_rq **rt_rq;
+
+	struct rt_bandwidth rt_bandwidth;
+#endif
+
+	struct rcu_head rcu;
+	struct list_head list;
+
+	struct task_group *parent;
+	struct list_head siblings;
+	struct list_head children;
+
+#ifdef CONFIG_SCHED_AUTOGROUP
+	struct autogroup *autogroup;
+#endif
+
+	struct cfs_bandwidth cfs_bandwidth;
+};
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+#define ROOT_TASK_GROUP_LOAD	NICE_0_LOAD
+
+/*
+ * A weight of 0 or 1 can cause arithmetics problems.
+ * A weight of a cfs_rq is the sum of weights of which entities
+ * are queued on this cfs_rq, so a weight of a entity should not be
+ * too large, so as the shares value of a task group.
+ * (The default weight is 1024 - so there's no practical
+ *  limitation from this.)
+ */
+#define MIN_SHARES	(1UL <<  1)
+#define MAX_SHARES	(1UL << 18)
+#endif
+
+/* Default task group.
+ *	Every task in system belong to this group at bootup.
+ */
+extern struct task_group root_task_group;
+
+#endif	/* CONFIG_CGROUP_SCHED */
+
+/* CFS-related fields in a runqueue */
+struct cfs_rq {
+	struct load_weight load;
+	unsigned long nr_running, h_nr_running;
+
+	u64 exec_clock;
+	u64 min_vruntime;
+#ifndef CONFIG_64BIT
+	u64 min_vruntime_copy;
+#endif
+
+	struct rb_root tasks_timeline;
+	struct rb_node *rb_leftmost;
+
+	struct list_head tasks;
+	struct list_head *balance_iterator;
+
+	/*
+	 * 'curr' points to currently running entity on this cfs_rq.
+	 * It is set to NULL otherwise (i.e when none are currently running).
+	 */
+	struct sched_entity *curr, *next, *last, *skip;
+
+#ifdef	CONFIG_SCHED_DEBUG
+	unsigned int nr_spread_over;
+#endif
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	struct rq *rq;	/* cpu runqueue to which this cfs_rq is attached */
+
+	/*
+	 * leaf cfs_rqs are those that hold tasks (lowest schedulable entity in
+	 * a hierarchy). Non-leaf lrqs hold other higher schedulable entities
+	 * (like users, containers etc.)
+	 *
+	 * leaf_cfs_rq_list ties together list of leaf cfs_rq's in a cpu. This
+	 * list is used during load balance.
+	 */
+	int on_list;
+	struct list_head leaf_cfs_rq_list;
+	struct task_group *tg;	/* group that "owns" this runqueue */
+
+#ifdef CONFIG_SMP
+	/*
+	 * the part of load.weight contributed by tasks
+	 */
+	unsigned long task_weight;
+
+	/*
+	 *   h_load = weight * f(tg)
+	 *
+	 * Where f(tg) is the recursive weight fraction assigned to
+	 * this group.
+	 */
+	unsigned long h_load;
+
+	/*
+	 * Maintaining per-cpu shares distribution for group scheduling
+	 *
+	 * load_stamp is the last time we updated the load average
+	 * load_last is the last time we updated the load average and saw load
+	 * load_unacc_exec_time is currently unaccounted execution time
+	 */
+	u64 load_avg;
+	u64 load_period;
+	u64 load_stamp, load_last, load_unacc_exec_time;
+
+	unsigned long load_contribution;
+#endif /* CONFIG_SMP */
+#ifdef CONFIG_CFS_BANDWIDTH
+	int runtime_enabled;
+	u64 runtime_expires;
+	s64 runtime_remaining;
+
+	u64 throttled_timestamp;
+	int throttled, throttle_count;
+	struct list_head throttled_list;
+#endif /* CONFIG_CFS_BANDWIDTH */
+#endif /* CONFIG_FAIR_GROUP_SCHED */
+};
+
+static inline int rt_bandwidth_enabled(void)
+{
+	return sysctl_sched_rt_runtime >= 0;
+}
+
+/* Real-Time classes' related field in a runqueue: */
+struct rt_rq {
+	struct rt_prio_array active;
+	unsigned long rt_nr_running;
+#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
+	struct {
+		int curr; /* highest queued rt task prio */
+#ifdef CONFIG_SMP
+		int next; /* next highest */
+#endif
+	} highest_prio;
+#endif
+#ifdef CONFIG_SMP
+	unsigned long rt_nr_migratory;
+	unsigned long rt_nr_total;
+	int overloaded;
+	struct plist_head pushable_tasks;
+#endif
+	int rt_throttled;
+	u64 rt_time;
+	u64 rt_runtime;
+	/* Nests inside the rq lock: */
+	raw_spinlock_t rt_runtime_lock;
+
+#ifdef CONFIG_RT_GROUP_SCHED
+	unsigned long rt_nr_boosted;
+
+	struct rq *rq;
+	struct list_head leaf_rt_rq_list;
+	struct task_group *tg;
+#endif
+};
+
+#ifdef CONFIG_SMP
+
+/*
+ * We add the notion of a root-domain which will be used to define per-domain
+ * variables. Each exclusive cpuset essentially defines an island domain by
+ * fully partitioning the member cpus from any other cpuset. Whenever a new
+ * exclusive cpuset is created, we also create and attach a new root-domain
+ * object.
+ *
+ */
+struct root_domain {
+	atomic_t refcount;
+	atomic_t rto_count;
+	struct rcu_head rcu;
+	cpumask_var_t span;
+	cpumask_var_t online;
+
+	/*
+	 * The "RT overload" flag: it gets set if a CPU has more than
+	 * one runnable RT task.
+	 */
+	cpumask_var_t rto_mask;
+	struct cpupri cpupri;
+};
+
+extern struct root_domain def_root_domain;
+
+#endif /* CONFIG_SMP */
+
+/*
+ * This is the main, per-CPU runqueue data structure.
+ *
+ * Locking rule: those places that want to lock multiple runqueues
+ * (such as the load balancing or the thread migration code), lock
+ * acquire operations must be ordered by ascending &runqueue.
+ */
+struct rq {
+	/* runqueue lock: */
+	raw_spinlock_t lock;
+
+	/*
+	 * nr_running and cpu_load should be in the same cacheline because
+	 * remote CPUs use both these fields when doing load calculation.
+	 */
+	unsigned long nr_running;
+	#define CPU_LOAD_IDX_MAX 5
+	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
+	unsigned long last_load_update_tick;
+#ifdef CONFIG_NO_HZ
+	u64 nohz_stamp;
+	unsigned char nohz_balance_kick;
+#endif
+	int skip_clock_update;
+
+	/* capture load from *all* tasks on this cpu: */
+	struct load_weight load;
+	unsigned long nr_load_updates;
+	u64 nr_switches;
+
+	struct cfs_rq cfs;
+	struct rt_rq rt;
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	/* list of leaf cfs_rq on this cpu: */
+	struct list_head leaf_cfs_rq_list;
+#endif
+#ifdef CONFIG_RT_GROUP_SCHED
+	struct list_head leaf_rt_rq_list;
+#endif
+
+	/*
+	 * This is part of a global counter where only the total sum
+	 * over all CPUs matters. A task can increase this counter on
+	 * one CPU and if it got migrated afterwards it may decrease
+	 * it on another CPU. Always updated under the runqueue lock:
+	 */
+	unsigned long nr_uninterruptible;
+
+	struct task_struct *curr, *idle, *stop;
+	unsigned long next_balance;
+	struct mm_struct *prev_mm;
+
+	u64 clock;
+	u64 clock_task;
+
+	atomic_t nr_iowait;
+
+#ifdef CONFIG_SMP
+	struct root_domain *rd;
+	struct sched_domain *sd;
+
+	unsigned long cpu_power;
+
+	unsigned char idle_balance;
+	/* For active balancing */
+	int post_schedule;
+	int active_balance;
+	int push_cpu;
+	struct cpu_stop_work active_balance_work;
+	/* cpu of this runqueue: */
+	int cpu;
+	int online;
+
+	u64 rt_avg;
+	u64 age_stamp;
+	u64 idle_stamp;
+	u64 avg_idle;
+#endif
+
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+	u64 prev_irq_time;
+#endif
+#ifdef CONFIG_PARAVIRT
+	u64 prev_steal_time;
+#endif
+#ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
+	u64 prev_steal_time_rq;
+#endif
+
+	/* calc_load related fields */
+	unsigned long calc_load_update;
+	long calc_load_active;
+
+#ifdef CONFIG_SCHED_HRTICK
+#ifdef CONFIG_SMP
+	int hrtick_csd_pending;
+	struct call_single_data hrtick_csd;
+#endif
+	struct hrtimer hrtick_timer;
+#endif
+
+#ifdef CONFIG_SCHEDSTATS
+	/* latency stats */
+	struct sched_info rq_sched_info;
+	unsigned long long rq_cpu_time;
+	/* could above be rq->cfs_rq.exec_clock + rq->rt_rq.rt_runtime ? */
+
+	/* sys_sched_yield() stats */
+	unsigned int yld_count;
+
+	/* schedule() stats */
+	unsigned int sched_switch;
+	unsigned int sched_count;
+	unsigned int sched_goidle;
+
+	/* try_to_wake_up() stats */
+	unsigned int ttwu_count;
+	unsigned int ttwu_local;
+#endif
+
+#ifdef CONFIG_SMP
+	struct llist_head wake_list;
+#endif
+};
+
+static inline int cpu_of(struct rq *rq)
+{
+#ifdef CONFIG_SMP
+	return rq->cpu;
+#else
+	return 0;
+#endif
+}
+
+DECLARE_PER_CPU(struct rq, runqueues);
+
+#define rcu_dereference_check_sched_domain(p) \
+	rcu_dereference_check((p), \
+			      lockdep_is_held(&sched_domains_mutex))
+
+/*
+ * The domain tree (rq->sd) is protected by RCU's quiescent state transition.
+ * See detach_destroy_domains: synchronize_sched for details.
+ *
+ * The domain tree of any CPU may only be accessed from within
+ * preempt-disabled sections.
+ */
+#define for_each_domain(cpu, __sd) \
+	for (__sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd); __sd; __sd = __sd->parent)
+
+#define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
+#define this_rq()		(&__get_cpu_var(runqueues))
+#define task_rq(p)		cpu_rq(task_cpu(p))
+#define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
+#define raw_rq()		(&__raw_get_cpu_var(runqueues))
+
+#include "sched_stats.h"
+#include "sched_autogroup.h"
+
+#ifdef CONFIG_CGROUP_SCHED
+
+/*
+ * Return the group to which this tasks belongs.
+ *
+ * We use task_subsys_state_check() and extend the RCU verification with
+ * pi->lock and rq->lock because cpu_cgroup_attach() holds those locks for each
+ * task it moves into the cgroup. Therefore by holding either of those locks,
+ * we pin the task to the current cgroup.
+ */
+static inline struct task_group *task_group(struct task_struct *p)
+{
+	struct task_group *tg;
+	struct cgroup_subsys_state *css;
+
+	css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
+			lockdep_is_held(&p->pi_lock) ||
+			lockdep_is_held(&task_rq(p)->lock));
+	tg = container_of(css, struct task_group, css);
+
+	return autogroup_task_group(p, tg);
+}
+
+/* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
+static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
+{
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
+	p->se.parent = task_group(p)->se[cpu];
+#endif
+
+#ifdef CONFIG_RT_GROUP_SCHED
+	p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
+	p->rt.parent = task_group(p)->rt_se[cpu];
+#endif
+}
+
+#else /* CONFIG_CGROUP_SCHED */
+
+static inline void set_task_rq(struct task_struct *p, unsigned int cpu) { }
+static inline struct task_group *task_group(struct task_struct *p)
+{
+	return NULL;
+}
+
+#endif /* CONFIG_CGROUP_SCHED */
+
+static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
+{
+	set_task_rq(p, cpu);
+#ifdef CONFIG_SMP
+	/*
+	 * After ->cpu is set up to a new value, task_rq_lock(p, ...) can be
+	 * successfuly executed on another CPU. We must ensure that updates of
+	 * per-task data have been completed by this moment.
+	 */
+	smp_wmb();
+	task_thread_info(p)->cpu = cpu;
+#endif
+}
+
+/*
+ * Tunables that become constants when CONFIG_SCHED_DEBUG is off:
+ */
+#ifdef CONFIG_SCHED_DEBUG
+# define const_debug __read_mostly
+#else
+# define const_debug static const
+#endif
+
+extern const_debug unsigned int sysctl_sched_features;
+
+#define SCHED_FEAT(name, enabled)	\
+	__SCHED_FEAT_##name ,
+
+enum {
+#include "sched_features.h"
+};
+
+#undef SCHED_FEAT
+
+#define sched_feat(x) (sysctl_sched_features & (1UL << __SCHED_FEAT_##x))
+
+static inline u64 global_rt_period(void)
+{
+	return (u64)sysctl_sched_rt_period * NSEC_PER_USEC;
+}
+
+static inline u64 global_rt_runtime(void)
+{
+	if (sysctl_sched_rt_runtime < 0)
+		return RUNTIME_INF;
+
+	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
+}
+
+
+
+static inline int task_current(struct rq *rq, struct task_struct *p)
+{
+	return rq->curr == p;
+}
+
+static inline int task_running(struct rq *rq, struct task_struct *p)
+{
+#ifdef CONFIG_SMP
+	return p->on_cpu;
+#else
+	return task_current(rq, p);
+#endif
+}
+
+
+#ifndef prepare_arch_switch
+# define prepare_arch_switch(next)	do { } while (0)
+#endif
+#ifndef finish_arch_switch
+# define finish_arch_switch(prev)	do { } while (0)
+#endif
+
+#ifndef __ARCH_WANT_UNLOCKED_CTXSW
+static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
+{
+#ifdef CONFIG_SMP
+	/*
+	 * We can optimise this out completely for !SMP, because the
+	 * SMP rebalancing from interrupt is the only thing that cares
+	 * here.
+	 */
+	next->on_cpu = 1;
+#endif
+}
+
+static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
+{
+#ifdef CONFIG_SMP
+	/*
+	 * After ->on_cpu is cleared, the task can be moved to a different CPU.
+	 * We must ensure this doesn't happen until the switch is completely
+	 * finished.
+	 */
+	smp_wmb();
+	prev->on_cpu = 0;
+#endif
+#ifdef CONFIG_DEBUG_SPINLOCK
+	/* this is a valid case when another task releases the spinlock */
+	rq->lock.owner = current;
+#endif
+	/*
+	 * If we are tracking spinlock dependencies then we have to
+	 * fix up the runqueue lock - which gets 'carried over' from
+	 * prev into current:
+	 */
+	spin_acquire(&rq->lock.dep_map, 0, 0, _THIS_IP_);
+
+	raw_spin_unlock_irq(&rq->lock);
+}
+
+#else /* __ARCH_WANT_UNLOCKED_CTXSW */
+static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
+{
+#ifdef CONFIG_SMP
+	/*
+	 * We can optimise this out completely for !SMP, because the
+	 * SMP rebalancing from interrupt is the only thing that cares
+	 * here.
+	 */
+	next->on_cpu = 1;
+#endif
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+	raw_spin_unlock_irq(&rq->lock);
+#else
+	raw_spin_unlock(&rq->lock);
+#endif
+}
+
+static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
+{
+#ifdef CONFIG_SMP
+	/*
+	 * After ->on_cpu is cleared, the task can be moved to a different CPU.
+	 * We must ensure this doesn't happen until the switch is completely
+	 * finished.
+	 */
+	smp_wmb();
+	prev->on_cpu = 0;
+#endif
+#ifndef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+	local_irq_enable();
+#endif
+}
+#endif /* __ARCH_WANT_UNLOCKED_CTXSW */
+
+
+static inline void update_load_add(struct load_weight *lw, unsigned long inc)
+{
+	lw->weight += inc;
+	lw->inv_weight = 0;
+}
+
+static inline void update_load_sub(struct load_weight *lw, unsigned long dec)
+{
+	lw->weight -= dec;
+	lw->inv_weight = 0;
+}
+
+static inline void update_load_set(struct load_weight *lw, unsigned long w)
+{
+	lw->weight = w;
+	lw->inv_weight = 0;
+}
+
+/*
+ * To aid in avoiding the subversion of "niceness" due to uneven distribution
+ * of tasks with abnormal "nice" values across CPUs the contribution that
+ * each task makes to its run queue's load is weighted according to its
+ * scheduling class and "nice" value. For SCHED_NORMAL tasks this is just a
+ * scaled version of the new time slice allocation that they receive on time
+ * slice expiry etc.
+ */
+
+#define WEIGHT_IDLEPRIO                3
+#define WMULT_IDLEPRIO         1431655765
+
+/*
+ * Nice levels are multiplicative, with a gentle 10% change for every
+ * nice level changed. I.e. when a CPU-bound task goes from nice 0 to
+ * nice 1, it will get ~10% less CPU time than another CPU-bound task
+ * that remained on nice 0.
+ *
+ * The "10% effect" is relative and cumulative: from _any_ nice level,
+ * if you go up 1 level, it's -10% CPU usage, if you go down 1 level
+ * it's +10% CPU usage. (to achieve that we use a multiplier of 1.25.
+ * If a task goes up by ~10% and another task goes down by ~10% then
+ * the relative distance between them is ~25%.)
+ */
+static const int prio_to_weight[40] = {
+ /* -20 */     88761,     71755,     56483,     46273,     36291,
+ /* -15 */     29154,     23254,     18705,     14949,     11916,
+ /* -10 */      9548,      7620,      6100,      4904,      3906,
+ /*  -5 */      3121,      2501,      1991,      1586,      1277,
+ /*   0 */      1024,       820,       655,       526,       423,
+ /*   5 */       335,       272,       215,       172,       137,
+ /*  10 */       110,        87,        70,        56,        45,
+ /*  15 */        36,        29,        23,        18,        15,
+};
+
+/*
+ * Inverse (2^32/x) values of the prio_to_weight[] array, precalculated.
+ *
+ * In cases where the weight does not change often, we can use the
+ * precalculated inverse to speed up arithmetics by turning divisions
+ * into multiplications:
+ */
+static const u32 prio_to_wmult[40] = {
+ /* -20 */     48388,     59856,     76040,     92818,    118348,
+ /* -15 */    147320,    184698,    229616,    287308,    360437,
+ /* -10 */    449829,    563644,    704093,    875809,   1099582,
+ /*  -5 */   1376151,   1717300,   2157191,   2708050,   3363326,
+ /*   0 */   4194304,   5237765,   6557202,   8165337,  10153587,
+ /*   5 */  12820798,  15790321,  19976592,  24970740,  31350126,
+ /*  10 */  39045157,  49367440,  61356676,  76695844,  95443717,
+ /*  15 */ 119304647, 148102320, 186737708, 238609294, 286331153,
+};
+
+/* Time spent by the tasks of the cpu accounting group executing in ... */
+enum cpuacct_stat_index {
+	CPUACCT_STAT_USER,	/* ... user mode */
+	CPUACCT_STAT_SYSTEM,	/* ... kernel mode */
+
+	CPUACCT_STAT_NSTATS,
+};
+
+
+#define sched_class_highest (&stop_sched_class)
+#define for_each_class(class) \
+   for (class = sched_class_highest; class; class = class->next)
+
+extern const struct sched_class stop_sched_class;
+extern const struct sched_class rt_sched_class;
+extern const struct sched_class fair_sched_class;
+extern const struct sched_class idle_sched_class;
+
+
+#ifdef CONFIG_SMP
+
+extern void trigger_load_balance(struct rq *rq, int cpu);
+extern void idle_balance(int this_cpu, struct rq *this_rq);
+
+#else	/* CONFIG_SMP */
+
+static inline void idle_balance(int cpu, struct rq *rq)
+{
+}
+
+#endif
+
+extern void sysrq_sched_debug_show(void);
+extern void sched_init_granularity(void);
+extern void update_max_interval(void);
+extern void update_group_power(struct sched_domain *sd, int cpu);
+extern int update_runtime(struct notifier_block *nfb, unsigned long action, void *hcpu);
+extern void init_sched_rt_class(void);
+extern void init_sched_fair_class(void);
+
+extern void resched_task(struct task_struct *p);
+extern void resched_cpu(int cpu);
+
+extern struct rt_bandwidth def_rt_bandwidth;
+extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime);
+
+extern void update_cpu_load(struct rq *this_rq);
+
+#ifdef CONFIG_CGROUP_CPUACCT
+extern void cpuacct_charge(struct task_struct *tsk, u64 cputime);
+extern void cpuacct_update_stats(struct task_struct *tsk,
+		enum cpuacct_stat_index idx, cputime_t val);
+#else
+static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime) {}
+static inline void cpuacct_update_stats(struct task_struct *tsk,
+		enum cpuacct_stat_index idx, cputime_t val) {}
+#endif
+
+static inline void inc_nr_running(struct rq *rq)
+{
+	rq->nr_running++;
+}
+
+static inline void dec_nr_running(struct rq *rq)
+{
+	rq->nr_running--;
+}
+
+extern void update_rq_clock(struct rq *rq);
+
+extern void activate_task(struct rq *rq, struct task_struct *p, int flags);
+extern void deactivate_task(struct rq *rq, struct task_struct *p, int flags);
+
+extern void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags);
+
+static inline u64 sched_avg_period(void)
+{
+	return (u64)sysctl_sched_time_avg * NSEC_PER_MSEC / 2;
+}
+
+void calc_load_account_idle(struct rq *this_rq);
+
+#ifdef CONFIG_SCHED_HRTICK
+
+/*
+ * Use hrtick when:
+ *  - enabled by features
+ *  - hrtimer is actually high res
+ */
+static inline int hrtick_enabled(struct rq *rq)
+{
+	if (!sched_feat(HRTICK))
+		return 0;
+	if (!cpu_active(cpu_of(rq)))
+		return 0;
+	return hrtimer_is_hres_active(&rq->hrtick_timer);
+}
+
+void hrtick_start(struct rq *rq, u64 delay);
+
+#endif /* CONFIG_SCHED_HRTICK */
+
+#ifdef CONFIG_SMP
+extern void sched_avg_update(struct rq *rq);
+static inline void sched_rt_avg_update(struct rq *rq, u64 rt_delta)
+{
+	rq->rt_avg += rt_delta;
+	sched_avg_update(rq);
+}
+#else
+static inline void sched_rt_avg_update(struct rq *rq, u64 rt_delta) { }
+static inline void sched_avg_update(struct rq *rq) { }
+#endif
+
+extern void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period);
+
+#ifdef CONFIG_SMP
+#ifdef CONFIG_PREEMPT
+
+static inline void double_rq_lock(struct rq *rq1, struct rq *rq2);
+
+/*
+ * fair double_lock_balance: Safely acquires both rq->locks in a fair
+ * way at the expense of forcing extra atomic operations in all
+ * invocations.  This assures that the double_lock is acquired using the
+ * same underlying policy as the spinlock_t on this architecture, which
+ * reduces latency compared to the unfair variant below.  However, it
+ * also adds more overhead and therefore may reduce throughput.
+ */
+static inline int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
+	__releases(this_rq->lock)
+	__acquires(busiest->lock)
+	__acquires(this_rq->lock)
+{
+	raw_spin_unlock(&this_rq->lock);
+	double_rq_lock(this_rq, busiest);
+
+	return 1;
+}
+
+#else
+/*
+ * Unfair double_lock_balance: Optimizes throughput at the expense of
+ * latency by eliminating extra atomic operations when the locks are
+ * already in proper order on entry.  This favors lower cpu-ids and will
+ * grant the double lock to lower cpus over higher ids under contention,
+ * regardless of entry order into the function.
+ */
+static inline int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
+	__releases(this_rq->lock)
+	__acquires(busiest->lock)
+	__acquires(this_rq->lock)
+{
+	int ret = 0;
+
+	if (unlikely(!raw_spin_trylock(&busiest->lock))) {
+		if (busiest < this_rq) {
+			raw_spin_unlock(&this_rq->lock);
+			raw_spin_lock(&busiest->lock);
+			raw_spin_lock_nested(&this_rq->lock,
+					      SINGLE_DEPTH_NESTING);
+			ret = 1;
+		} else
+			raw_spin_lock_nested(&busiest->lock,
+					      SINGLE_DEPTH_NESTING);
+	}
+	return ret;
+}
+
+#endif /* CONFIG_PREEMPT */
+
+/*
+ * double_lock_balance - lock the busiest runqueue, this_rq is locked already.
+ */
+static inline int double_lock_balance(struct rq *this_rq, struct rq *busiest)
+{
+	if (unlikely(!irqs_disabled())) {
+		/* printk() doesn't work good under rq->lock */
+		raw_spin_unlock(&this_rq->lock);
+		BUG_ON(1);
+	}
+
+	return _double_lock_balance(this_rq, busiest);
+}
+
+static inline void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
+	__releases(busiest->lock)
+{
+	raw_spin_unlock(&busiest->lock);
+	lock_set_subclass(&this_rq->lock.dep_map, 0, _RET_IP_);
+}
+
+/*
+ * double_rq_lock - safely lock two runqueues
+ *
+ * Note this does not disable interrupts like task_rq_lock,
+ * you need to do so manually before calling.
+ */
+static inline void double_rq_lock(struct rq *rq1, struct rq *rq2)
+	__acquires(rq1->lock)
+	__acquires(rq2->lock)
+{
+	BUG_ON(!irqs_disabled());
+	if (rq1 == rq2) {
+		raw_spin_lock(&rq1->lock);
+		__acquire(rq2->lock);	/* Fake it out ;) */
+	} else {
+		if (rq1 < rq2) {
+			raw_spin_lock(&rq1->lock);
+			raw_spin_lock_nested(&rq2->lock, SINGLE_DEPTH_NESTING);
+		} else {
+			raw_spin_lock(&rq2->lock);
+			raw_spin_lock_nested(&rq1->lock, SINGLE_DEPTH_NESTING);
+		}
+	}
+}
+
+/*
+ * double_rq_unlock - safely unlock two runqueues
+ *
+ * Note this does not restore interrupts like task_rq_unlock,
+ * you need to do so manually after calling.
+ */
+static inline void double_rq_unlock(struct rq *rq1, struct rq *rq2)
+	__releases(rq1->lock)
+	__releases(rq2->lock)
+{
+	raw_spin_unlock(&rq1->lock);
+	if (rq1 != rq2)
+		raw_spin_unlock(&rq2->lock);
+	else
+		__release(rq2->lock);
+}
+
+#else /* CONFIG_SMP */
+
+/*
+ * double_rq_lock - safely lock two runqueues
+ *
+ * Note this does not disable interrupts like task_rq_lock,
+ * you need to do so manually before calling.
+ */
+static inline void double_rq_lock(struct rq *rq1, struct rq *rq2)
+	__acquires(rq1->lock)
+	__acquires(rq2->lock)
+{
+	BUG_ON(!irqs_disabled());
+	BUG_ON(rq1 != rq2);
+	raw_spin_lock(&rq1->lock);
+	__acquire(rq2->lock);	/* Fake it out ;) */
+}
+
+/*
+ * double_rq_unlock - safely unlock two runqueues
+ *
+ * Note this does not restore interrupts like task_rq_unlock,
+ * you need to do so manually after calling.
+ */
+static inline void double_rq_unlock(struct rq *rq1, struct rq *rq2)
+	__releases(rq1->lock)
+	__releases(rq2->lock)
+{
+	BUG_ON(rq1 != rq2);
+	raw_spin_unlock(&rq1->lock);
+	__release(rq2->lock);
+}
+
+#endif
+
+extern struct sched_entity *__pick_first_entity(struct cfs_rq *cfs_rq);
+extern struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq);
+extern void print_cfs_stats(struct seq_file *m, int cpu);
+extern void print_rt_stats(struct seq_file *m, int cpu);
+
+typedef int (*tg_visitor)(struct task_group *, void *);
+
+extern int walk_tg_tree_from(struct task_group *from,
+			     tg_visitor down, tg_visitor up, void *data);
+
+/*
+ * Iterate the full tree, calling @down when first entering a node and @up when
+ * leaving it for the final time.
+ *
+ * Caller must hold rcu_lock or sufficient equivalent.
+ */
+static inline int walk_tg_tree(tg_visitor down, tg_visitor up, void *data)
+{
+	return walk_tg_tree_from(&root_task_group, down, up, data);
+}
+
+extern int tg_nop(struct task_group *tg, void *data);
+
+extern void init_cfs_rq(struct cfs_rq *cfs_rq);
+extern void free_fair_sched_group(struct task_group *tg);
+extern int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent);
+extern void unregister_fair_sched_group(struct task_group *tg, int cpu);
+extern void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
+			struct sched_entity *se, int cpu,
+			struct sched_entity *parent);
+extern void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b);
+extern int sched_group_set_shares(struct task_group *tg, unsigned long shares);
+
+extern void unthrottle_offline_cfs_rqs(struct rq *rq);
+extern void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b);
+extern void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b);
+extern void unthrottle_cfs_rq(struct cfs_rq *cfs_rq);
+
+extern void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq);
+extern void free_rt_sched_group(struct task_group *tg);
+extern int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent);
+extern void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
+		struct sched_rt_entity *rt_se, int cpu,
+		struct sched_rt_entity *parent);
Index: linux-2.6/kernel/sched_debug.c
===================================================================
--- linux-2.6.orig/kernel/sched_debug.c
+++ linux-2.6/kernel/sched_debug.c
@@ -16,6 +16,8 @@
 #include <linux/kallsyms.h>
 #include <linux/utsname.h>
 
+#include "sched.h"
+
 static DEFINE_SPINLOCK(sched_debug_lock);
 
 /*
@@ -373,7 +375,7 @@ static int sched_debug_show(struct seq_f
 	return 0;
 }
 
-static void sysrq_sched_debug_show(void)
+void sysrq_sched_debug_show(void)
 {
 	sched_debug_show(NULL, NULL);
 }
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -23,6 +23,13 @@
 #include <linux/latencytop.h>
 #include <linux/sched.h>
 #include <linux/cpumask.h>
+#include <linux/slab.h>
+#include <linux/profile.h>
+#include <linux/interrupt.h>
+
+#include <trace/events/sched.h>
+
+#include "sched.h"
 
 /*
  * Targeted preemption latency for CPU-bound tasks:
@@ -103,7 +110,110 @@ unsigned int __read_mostly sysctl_sched_
 unsigned int sysctl_sched_cfs_bandwidth_slice = 5000UL;
 #endif
 
-static const struct sched_class fair_sched_class;
+/*
+ * Increase the granularity value when there are more CPUs,
+ * because with more CPUs the 'effective latency' as visible
+ * to users decreases. But the relationship is not linear,
+ * so pick a second-best guess by going with the log2 of the
+ * number of CPUs.
+ *
+ * This idea comes from the SD scheduler of Con Kolivas:
+ */
+static int get_update_sysctl_factor(void)
+{
+	unsigned int cpus = min_t(int, num_online_cpus(), 8);
+	unsigned int factor;
+
+	switch (sysctl_sched_tunable_scaling) {
+	case SCHED_TUNABLESCALING_NONE:
+		factor = 1;
+		break;
+	case SCHED_TUNABLESCALING_LINEAR:
+		factor = cpus;
+		break;
+	case SCHED_TUNABLESCALING_LOG:
+	default:
+		factor = 1 + ilog2(cpus);
+		break;
+	}
+
+	return factor;
+}
+
+static void update_sysctl(void)
+{
+	unsigned int factor = get_update_sysctl_factor();
+
+#define SET_SYSCTL(name) \
+	(sysctl_##name = (factor) * normalized_sysctl_##name)
+	SET_SYSCTL(sched_min_granularity);
+	SET_SYSCTL(sched_latency);
+	SET_SYSCTL(sched_wakeup_granularity);
+#undef SET_SYSCTL
+}
+
+void sched_init_granularity(void)
+{
+	update_sysctl();
+}
+
+#if BITS_PER_LONG == 32
+# define WMULT_CONST	(~0UL)
+#else
+# define WMULT_CONST	(1UL << 32)
+#endif
+
+#define WMULT_SHIFT	32
+
+/*
+ * Shift right and round:
+ */
+#define SRR(x, y) (((x) + (1UL << ((y) - 1))) >> (y))
+
+/*
+ * delta *= weight / lw
+ */
+static unsigned long
+calc_delta_mine(unsigned long delta_exec, unsigned long weight,
+		struct load_weight *lw)
+{
+	u64 tmp;
+
+	/*
+	 * weight can be less than 2^SCHED_LOAD_RESOLUTION for task group sched
+	 * entities since MIN_SHARES = 2. Treat weight as 1 if less than
+	 * 2^SCHED_LOAD_RESOLUTION.
+	 */
+	if (likely(weight > (1UL << SCHED_LOAD_RESOLUTION)))
+		tmp = (u64)delta_exec * scale_load_down(weight);
+	else
+		tmp = (u64)delta_exec;
+
+	if (!lw->inv_weight) {
+		unsigned long w = scale_load_down(lw->weight);
+
+		if (BITS_PER_LONG > 32 && unlikely(w >= WMULT_CONST))
+			lw->inv_weight = 1;
+		else if (unlikely(!w))
+			lw->inv_weight = WMULT_CONST;
+		else
+			lw->inv_weight = WMULT_CONST / w;
+	}
+
+	/*
+	 * Check whether we'd overflow the 64-bit multiplication:
+	 */
+	if (unlikely(tmp > WMULT_CONST))
+		tmp = SRR(SRR(tmp, WMULT_SHIFT/2) * lw->inv_weight,
+			WMULT_SHIFT/2);
+	else
+		tmp = SRR(tmp * lw->inv_weight, WMULT_SHIFT);
+
+	return (unsigned long)min(tmp, (u64)(unsigned long)LONG_MAX);
+}
+
+
+const struct sched_class fair_sched_class;
 
 /**************************************************************
  * CFS operations on generic schedulable entities:
@@ -413,7 +523,7 @@ static void __dequeue_entity(struct cfs_
 	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
 }
 
-static struct sched_entity *__pick_first_entity(struct cfs_rq *cfs_rq)
+struct sched_entity *__pick_first_entity(struct cfs_rq *cfs_rq)
 {
 	struct rb_node *left = cfs_rq->rb_leftmost;
 
@@ -434,7 +544,7 @@ static struct sched_entity *__pick_next_
 }
 
 #ifdef CONFIG_SCHED_DEBUG
-static struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
+struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
 {
 	struct rb_node *last = rb_last(&cfs_rq->tasks_timeline);
 
@@ -684,7 +794,7 @@ account_entity_enqueue(struct cfs_rq *cf
 {
 	update_load_add(&cfs_rq->load, se->load.weight);
 	if (!parent_entity(se))
-		inc_cpu_load(rq_of(cfs_rq), se->load.weight);
+		update_load_add(&rq_of(cfs_rq)->load, se->load.weight);
 	if (entity_is_task(se)) {
 		add_cfs_task_weight(cfs_rq, se->load.weight);
 		list_add(&se->group_node, &cfs_rq->tasks);
@@ -697,7 +807,7 @@ account_entity_dequeue(struct cfs_rq *cf
 {
 	update_load_sub(&cfs_rq->load, se->load.weight);
 	if (!parent_entity(se))
-		dec_cpu_load(rq_of(cfs_rq), se->load.weight);
+		update_load_sub(&rq_of(cfs_rq)->load, se->load.weight);
 	if (entity_is_task(se)) {
 		add_cfs_task_weight(cfs_rq, -se->load.weight);
 		list_del_init(&se->group_node);
@@ -1308,7 +1418,7 @@ static inline u64 sched_cfs_bandwidth_sl
  *
  * requires cfs_b->lock
  */
-static void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b)
+void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b)
 {
 	u64 now;
 
@@ -1320,6 +1430,11 @@ static void __refill_cfs_bandwidth_runti
 	cfs_b->runtime_expires = now + ktime_to_ns(cfs_b->period);
 }
 
+static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
+{
+	return &tg->cfs_bandwidth;
+}
+
 /* returns 0 on failure to allocate runtime */
 static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
@@ -1530,7 +1645,7 @@ static void throttle_cfs_rq(struct cfs_r
 	raw_spin_unlock(&cfs_b->lock);
 }
 
-static void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
+void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 {
 	struct rq *rq = rq_of(cfs_rq);
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
@@ -1830,7 +1945,111 @@ static void check_cfs_rq_runtime(struct
 
 	throttle_cfs_rq(cfs_rq);
 }
-#else
+
+static inline u64 default_cfs_period(void);
+static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun);
+static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b);
+
+static enum hrtimer_restart sched_cfs_slack_timer(struct hrtimer *timer)
+{
+	struct cfs_bandwidth *cfs_b =
+		container_of(timer, struct cfs_bandwidth, slack_timer);
+	do_sched_cfs_slack_timer(cfs_b);
+
+	return HRTIMER_NORESTART;
+}
+
+static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
+{
+	struct cfs_bandwidth *cfs_b =
+		container_of(timer, struct cfs_bandwidth, period_timer);
+	ktime_t now;
+	int overrun;
+	int idle = 0;
+
+	for (;;) {
+		now = hrtimer_cb_get_time(timer);
+		overrun = hrtimer_forward(timer, now, cfs_b->period);
+
+		if (!overrun)
+			break;
+
+		idle = do_sched_cfs_period_timer(cfs_b, overrun);
+	}
+
+	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
+}
+
+void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
+{
+	raw_spin_lock_init(&cfs_b->lock);
+	cfs_b->runtime = 0;
+	cfs_b->quota = RUNTIME_INF;
+	cfs_b->period = ns_to_ktime(default_cfs_period());
+
+	INIT_LIST_HEAD(&cfs_b->throttled_cfs_rq);
+	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	cfs_b->period_timer.function = sched_cfs_period_timer;
+	hrtimer_init(&cfs_b->slack_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	cfs_b->slack_timer.function = sched_cfs_slack_timer;
+}
+
+static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq)
+{
+	cfs_rq->runtime_enabled = 0;
+	INIT_LIST_HEAD(&cfs_rq->throttled_list);
+}
+
+/* requires cfs_b->lock, may release to reprogram timer */
+void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
+{
+	/*
+	 * The timer may be active because we're trying to set a new bandwidth
+	 * period or because we're racing with the tear-down path
+	 * (timer_active==0 becomes visible before the hrtimer call-back
+	 * terminates).  In either case we ensure that it's re-programmed
+	 */
+	while (unlikely(hrtimer_active(&cfs_b->period_timer))) {
+		raw_spin_unlock(&cfs_b->lock);
+		/* ensure cfs_b->lock is available while we wait */
+		hrtimer_cancel(&cfs_b->period_timer);
+
+		raw_spin_lock(&cfs_b->lock);
+		/* if someone else restarted the timer then we're done */
+		if (cfs_b->timer_active)
+			return;
+	}
+
+	cfs_b->timer_active = 1;
+	start_bandwidth_timer(&cfs_b->period_timer, cfs_b->period);
+}
+
+static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
+{
+	hrtimer_cancel(&cfs_b->period_timer);
+	hrtimer_cancel(&cfs_b->slack_timer);
+}
+
+void unthrottle_offline_cfs_rqs(struct rq *rq)
+{
+	struct cfs_rq *cfs_rq;
+
+	for_each_leaf_cfs_rq(rq, cfs_rq) {
+		struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
+
+		if (!cfs_rq->runtime_enabled)
+			continue;
+
+		/*
+		 * clock_task is not advancing so we just need to make sure
+		 * there's some valid quota amount
+		 */
+		cfs_rq->runtime_remaining = cfs_b->quota;
+		if (cfs_rq_throttled(cfs_rq))
+			unthrottle_cfs_rq(cfs_rq);
+	}
+}
+#else /* CONFIG_CFS_BANDWIDTH */
 static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 				     unsigned long delta_exec) {}
 static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
@@ -1852,7 +2071,17 @@ static inline int throttled_lb_pair(stru
 {
 	return 0;
 }
-#endif
+static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
+void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
+static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
+
+static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
+{
+	return NULL;
+}
+void unthrottle_offline_cfs_rqs(struct rq *rq) {}
+
+#endif /* CONFIG_CFS_BANDWIDTH */
 
 /**************************************************
  * CFS operations on tasks:
@@ -2020,6 +2249,61 @@ static void dequeue_task_fair(struct rq
 }
 
 #ifdef CONFIG_SMP
+/* Used instead of source_load when we know the type == 0 */
+static unsigned long weighted_cpuload(const int cpu)
+{
+	return cpu_rq(cpu)->load.weight;
+}
+
+/*
+ * Return a low guess at the load of a migration-source cpu weighted
+ * according to the scheduling class and "nice" value.
+ *
+ * We want to under-estimate the load of migration sources, to
+ * balance conservatively.
+ */
+static unsigned long source_load(int cpu, int type)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long total = weighted_cpuload(cpu);
+
+	if (type == 0 || !sched_feat(LB_BIAS))
+		return total;
+
+	return min(rq->cpu_load[type-1], total);
+}
+
+/*
+ * Return a high guess at the load of a migration-target cpu weighted
+ * according to the scheduling class and "nice" value.
+ */
+static unsigned long target_load(int cpu, int type)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long total = weighted_cpuload(cpu);
+
+	if (type == 0 || !sched_feat(LB_BIAS))
+		return total;
+
+	return max(rq->cpu_load[type-1], total);
+}
+
+static unsigned long power_of(int cpu)
+{
+	return cpu_rq(cpu)->cpu_power;
+}
+
+static unsigned long cpu_avg_load_per_task(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
+
+	if (nr_running)
+		return rq->load.weight / nr_running;
+
+	return 0;
+}
+
 
 static void task_waking_fair(struct task_struct *p)
 {
@@ -2760,6 +3044,38 @@ static void pull_task(struct rq *src_rq,
 }
 
 /*
+ * Is this task likely cache-hot:
+ */
+static int
+task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
+{
+	s64 delta;
+
+	if (p->sched_class != &fair_sched_class)
+		return 0;
+
+	if (unlikely(p->policy == SCHED_IDLE))
+		return 0;
+
+	/*
+	 * Buddy candidates are cache hot:
+	 */
+	if (sched_feat(CACHE_HOT_BUDDY) && this_rq()->nr_running &&
+			(&p->se == cfs_rq_of(&p->se)->next ||
+			 &p->se == cfs_rq_of(&p->se)->last))
+		return 1;
+
+	if (sysctl_sched_migration_cost == -1)
+		return 1;
+	if (sysctl_sched_migration_cost == 0)
+		return 0;
+
+	delta = now - p->se.exec_start;
+
+	return delta < (s64)sysctl_sched_migration_cost;
+}
+
+/*
  * can_migrate_task - may task p from runqueue rq be migrated to this_cpu?
  */
 static
@@ -3139,15 +3455,6 @@ struct sg_lb_stats {
 };
 
 /**
- * group_first_cpu - Returns the first cpu in the cpumask of a sched_group.
- * @group: The group whose first cpu is to be returned.
- */
-static inline unsigned int group_first_cpu(struct sched_group *group)
-{
-	return cpumask_first(sched_group_cpus(group));
-}
-
-/**
  * get_sd_load_idx - Obtain the load index for a given sched domain.
  * @sd: The sched_domain whose load_idx is to be obtained.
  * @idle: The Idle status of the CPU for whose sd load_icx is obtained.
@@ -3396,7 +3703,7 @@ static void update_cpu_power(struct sche
 	sdg->sgp->power = power;
 }
 
-static void update_group_power(struct sched_domain *sd, int cpu)
+void update_group_power(struct sched_domain *sd, int cpu)
 {
 	struct sched_domain *child = sd->child;
 	struct sched_group *group, *sdg = sd->groups;
@@ -3662,11 +3969,6 @@ static inline void update_sd_lb_stats(st
 	} while (sg != sd->groups);
 }
 
-int __weak arch_sd_sibling_asym_packing(void)
-{
-       return 0*SD_ASYM_PACKING;
-}
-
 /**
  * check_asym_packing - Check to see if the group is packed into the
  *			sched doman.
@@ -4233,7 +4535,7 @@ static int load_balance(int this_cpu, st
  * idle_balance is called by schedule() if this_cpu is about to become
  * idle. Attempts to pull tasks from other CPUs.
  */
-static void idle_balance(int this_cpu, struct rq *this_rq)
+void idle_balance(int this_cpu, struct rq *this_rq)
 {
 	struct sched_domain *sd;
 	int pulled_task = 0;
@@ -4608,7 +4910,7 @@ static unsigned long __read_mostly max_l
  * Scale the max load_balance interval with the number of CPUs in the system.
  * This trades load-balance latency on larger machines for less cross talk.
  */
-static void update_max_interval(void)
+void update_max_interval(void)
 {
 	max_load_balance_interval = HZ*num_online_cpus()/10;
 }
@@ -4810,7 +5112,7 @@ static inline int on_null_domain(int cpu
 /*
  * Trigger the SCHED_SOFTIRQ if it is time to do periodic load balancing.
  */
-static inline void trigger_load_balance(struct rq *rq, int cpu)
+void trigger_load_balance(struct rq *rq, int cpu)
 {
 	/* Don't need to rebalance while attached to NULL domain */
 	if (time_after_eq(jiffies, rq->next_balance) &&
@@ -4832,15 +5134,6 @@ static void rq_offline_fair(struct rq *r
 	update_sysctl();
 }
 
-#else	/* CONFIG_SMP */
-
-/*
- * on UP we do not need to balance between CPUs:
- */
-static inline void idle_balance(int cpu, struct rq *rq)
-{
-}
-
 #endif /* CONFIG_SMP */
 
 /*
@@ -4983,6 +5276,16 @@ static void set_curr_task_fair(struct rq
 	}
 }
 
+void init_cfs_rq(struct cfs_rq *cfs_rq)
+{
+	cfs_rq->tasks_timeline = RB_ROOT;
+	INIT_LIST_HEAD(&cfs_rq->tasks);
+	cfs_rq->min_vruntime = (u64)(-(1LL << 20));
+#ifndef CONFIG_64BIT
+	cfs_rq->min_vruntime_copy = cfs_rq->min_vruntime;
+#endif
+}
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static void task_move_group_fair(struct task_struct *p, int on_rq)
 {
@@ -5005,7 +5308,161 @@ static void task_move_group_fair(struct
 	if (!on_rq)
 		p->se.vruntime += cfs_rq_of(&p->se)->min_vruntime;
 }
+
+void free_fair_sched_group(struct task_group *tg)
+{
+	int i;
+
+	destroy_cfs_bandwidth(tg_cfs_bandwidth(tg));
+
+	for_each_possible_cpu(i) {
+		if (tg->cfs_rq)
+			kfree(tg->cfs_rq[i]);
+		if (tg->se)
+			kfree(tg->se[i]);
+	}
+
+	kfree(tg->cfs_rq);
+	kfree(tg->se);
+}
+
+int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
+{
+	struct cfs_rq *cfs_rq;
+	struct sched_entity *se;
+	int i;
+
+	tg->cfs_rq = kzalloc(sizeof(cfs_rq) * nr_cpu_ids, GFP_KERNEL);
+	if (!tg->cfs_rq)
+		goto err;
+	tg->se = kzalloc(sizeof(se) * nr_cpu_ids, GFP_KERNEL);
+	if (!tg->se)
+		goto err;
+
+	tg->shares = NICE_0_LOAD;
+
+	init_cfs_bandwidth(tg_cfs_bandwidth(tg));
+
+	for_each_possible_cpu(i) {
+		cfs_rq = kzalloc_node(sizeof(struct cfs_rq),
+				      GFP_KERNEL, cpu_to_node(i));
+		if (!cfs_rq)
+			goto err;
+
+		se = kzalloc_node(sizeof(struct sched_entity),
+				  GFP_KERNEL, cpu_to_node(i));
+		if (!se)
+			goto err_free_rq;
+
+		init_cfs_rq(cfs_rq);
+		init_tg_cfs_entry(tg, cfs_rq, se, i, parent->se[i]);
+	}
+
+	return 1;
+
+err_free_rq:
+	kfree(cfs_rq);
+err:
+	return 0;
+}
+
+void unregister_fair_sched_group(struct task_group *tg, int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long flags;
+
+	/*
+	* Only empty task groups can be destroyed; so we can speculatively
+	* check on_list without danger of it being re-added.
+	*/
+	if (!tg->cfs_rq[cpu]->on_list)
+		return;
+
+	raw_spin_lock_irqsave(&rq->lock, flags);
+	list_del_leaf_cfs_rq(tg->cfs_rq[cpu]);
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
+}
+
+void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
+			struct sched_entity *se, int cpu,
+			struct sched_entity *parent)
+{
+	struct rq *rq = cpu_rq(cpu);
+
+	cfs_rq->tg = tg;
+	cfs_rq->rq = rq;
+#ifdef CONFIG_SMP
+	/* allow initial update_cfs_load() to truncate */
+	cfs_rq->load_stamp = 1;
 #endif
+	init_cfs_rq_runtime(cfs_rq);
+
+	tg->cfs_rq[cpu] = cfs_rq;
+	tg->se[cpu] = se;
+
+	/* se could be NULL for root_task_group */
+	if (!se)
+		return;
+
+	if (!parent)
+		se->cfs_rq = &rq->cfs;
+	else
+		se->cfs_rq = parent->my_q;
+
+	se->my_q = cfs_rq;
+	update_load_set(&se->load, 0);
+	se->parent = parent;
+}
+
+static DEFINE_MUTEX(shares_mutex);
+
+int sched_group_set_shares(struct task_group *tg, unsigned long shares)
+{
+	int i;
+	unsigned long flags;
+
+	/*
+	 * We can't change the weight of the root cgroup.
+	 */
+	if (!tg->se[0])
+		return -EINVAL;
+
+	shares = clamp(shares, scale_load(MIN_SHARES), scale_load(MAX_SHARES));
+
+	mutex_lock(&shares_mutex);
+	if (tg->shares == shares)
+		goto done;
+
+	tg->shares = shares;
+	for_each_possible_cpu(i) {
+		struct rq *rq = cpu_rq(i);
+		struct sched_entity *se;
+
+		se = tg->se[i];
+		/* Propagate contribution to hierarchy */
+		raw_spin_lock_irqsave(&rq->lock, flags);
+		for_each_sched_entity(se)
+			update_cfs_shares(group_cfs_rq(se));
+		raw_spin_unlock_irqrestore(&rq->lock, flags);
+	}
+
+done:
+	mutex_unlock(&shares_mutex);
+	return 0;
+}
+#else /* CONFIG_FAIR_GROUP_SCHED */
+
+void free_fair_sched_group(struct task_group *tg) { }
+
+int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
+{
+	return 1;
+}
+
+void unregister_fair_sched_group(struct task_group *tg, int cpu) { }
+
+#endif /* CONFIG_FAIR_GROUP_SCHED */
+
 
 static unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task)
 {
@@ -5025,7 +5482,7 @@ static unsigned int get_rr_interval_fair
 /*
  * All the scheduling class methods:
  */
-static const struct sched_class fair_sched_class = {
+const struct sched_class fair_sched_class = {
 	.next			= &idle_sched_class,
 	.enqueue_task		= enqueue_task_fair,
 	.dequeue_task		= dequeue_task_fair,
@@ -5062,7 +5519,7 @@ static const struct sched_class fair_sch
 };
 
 #ifdef CONFIG_SCHED_DEBUG
-static void print_cfs_stats(struct seq_file *m, int cpu)
+void print_cfs_stats(struct seq_file *m, int cpu)
 {
 	struct cfs_rq *cfs_rq;
 
@@ -5072,3 +5529,19 @@ static void print_cfs_stats(struct seq_f
 	rcu_read_unlock();
 }
 #endif
+
+__init void init_sched_fair_class(void)
+{
+#ifdef CONFIG_SMP
+	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
+
+#ifdef CONFIG_NO_HZ
+	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
+	alloc_cpumask_var(&nohz.grp_idle_mask, GFP_NOWAIT);
+	atomic_set(&nohz.load_balancer, nr_cpu_ids);
+	atomic_set(&nohz.first_pick_cpu, nr_cpu_ids);
+	atomic_set(&nohz.second_pick_cpu, nr_cpu_ids);
+#endif
+#endif /* SMP */
+
+}
Index: linux-2.6/kernel/sched_idletask.c
===================================================================
--- linux-2.6.orig/kernel/sched_idletask.c
+++ linux-2.6/kernel/sched_idletask.c
@@ -1,3 +1,5 @@
+#include "sched.h"
+
 /*
  * idle-task scheduling class.
  *
@@ -71,7 +73,7 @@ static unsigned int get_rr_interval_idle
 /*
  * Simple, special scheduling class for the per-CPU idle tasks:
  */
-static const struct sched_class idle_sched_class = {
+const struct sched_class idle_sched_class = {
 	/* .next is NULL */
 	/* no enqueue/yield_task for idle tasks */
 
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -3,7 +3,92 @@
  * policies)
  */
 
+#include "sched.h"
+
+#include <linux/slab.h>
+
+static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun);
+
+struct rt_bandwidth def_rt_bandwidth;
+
+static enum hrtimer_restart sched_rt_period_timer(struct hrtimer *timer)
+{
+	struct rt_bandwidth *rt_b =
+		container_of(timer, struct rt_bandwidth, rt_period_timer);
+	ktime_t now;
+	int overrun;
+	int idle = 0;
+
+	for (;;) {
+		now = hrtimer_cb_get_time(timer);
+		overrun = hrtimer_forward(timer, now, rt_b->rt_period);
+
+		if (!overrun)
+			break;
+
+		idle = do_sched_rt_period_timer(rt_b, overrun);
+	}
+
+	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
+}
+
+void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime)
+{
+	rt_b->rt_period = ns_to_ktime(period);
+	rt_b->rt_runtime = runtime;
+
+	raw_spin_lock_init(&rt_b->rt_runtime_lock);
+
+	hrtimer_init(&rt_b->rt_period_timer,
+			CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	rt_b->rt_period_timer.function = sched_rt_period_timer;
+}
+
+static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
+{
+	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
+		return;
+
+	if (hrtimer_active(&rt_b->rt_period_timer))
+		return;
+
+	raw_spin_lock(&rt_b->rt_runtime_lock);
+	start_bandwidth_timer(&rt_b->rt_period_timer, rt_b->rt_period);
+	raw_spin_unlock(&rt_b->rt_runtime_lock);
+}
+
+void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
+{
+	struct rt_prio_array *array;
+	int i;
+
+	array = &rt_rq->active;
+	for (i = 0; i < MAX_RT_PRIO; i++) {
+		INIT_LIST_HEAD(array->queue + i);
+		__clear_bit(i, array->bitmap);
+	}
+	/* delimiter for bitsearch: */
+	__set_bit(MAX_RT_PRIO, array->bitmap);
+
+#if defined CONFIG_SMP
+	rt_rq->highest_prio.curr = MAX_RT_PRIO;
+	rt_rq->highest_prio.next = MAX_RT_PRIO;
+	rt_rq->rt_nr_migratory = 0;
+	rt_rq->overloaded = 0;
+	plist_head_init(&rt_rq->pushable_tasks);
+#endif
+
+	rt_rq->rt_time = 0;
+	rt_rq->rt_throttled = 0;
+	rt_rq->rt_runtime = 0;
+	raw_spin_lock_init(&rt_rq->rt_runtime_lock);
+}
+
 #ifdef CONFIG_RT_GROUP_SCHED
+static void destroy_rt_bandwidth(struct rt_bandwidth *rt_b)
+{
+	hrtimer_cancel(&rt_b->rt_period_timer);
+}
 
 #define rt_entity_is_task(rt_se) (!(rt_se)->my_q)
 
@@ -25,6 +110,91 @@ static inline struct rt_rq *rt_rq_of_se(
 	return rt_se->rt_rq;
 }
 
+void free_rt_sched_group(struct task_group *tg)
+{
+	int i;
+
+	if (tg->rt_se)
+		destroy_rt_bandwidth(&tg->rt_bandwidth);
+
+	for_each_possible_cpu(i) {
+		if (tg->rt_rq)
+			kfree(tg->rt_rq[i]);
+		if (tg->rt_se)
+			kfree(tg->rt_se[i]);
+	}
+
+	kfree(tg->rt_rq);
+	kfree(tg->rt_se);
+}
+
+void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
+		struct sched_rt_entity *rt_se, int cpu,
+		struct sched_rt_entity *parent)
+{
+	struct rq *rq = cpu_rq(cpu);
+
+	rt_rq->highest_prio.curr = MAX_RT_PRIO;
+	rt_rq->rt_nr_boosted = 0;
+	rt_rq->rq = rq;
+	rt_rq->tg = tg;
+
+	tg->rt_rq[cpu] = rt_rq;
+	tg->rt_se[cpu] = rt_se;
+
+	if (!rt_se)
+		return;
+
+	if (!parent)
+		rt_se->rt_rq = &rq->rt;
+	else
+		rt_se->rt_rq = parent->my_q;
+
+	rt_se->my_q = rt_rq;
+	rt_se->parent = parent;
+	INIT_LIST_HEAD(&rt_se->run_list);
+}
+
+int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
+{
+	struct rt_rq *rt_rq;
+	struct sched_rt_entity *rt_se;
+	int i;
+
+	tg->rt_rq = kzalloc(sizeof(rt_rq) * nr_cpu_ids, GFP_KERNEL);
+	if (!tg->rt_rq)
+		goto err;
+	tg->rt_se = kzalloc(sizeof(rt_se) * nr_cpu_ids, GFP_KERNEL);
+	if (!tg->rt_se)
+		goto err;
+
+	init_rt_bandwidth(&tg->rt_bandwidth,
+			ktime_to_ns(def_rt_bandwidth.rt_period), 0);
+
+	for_each_possible_cpu(i) {
+		rt_rq = kzalloc_node(sizeof(struct rt_rq),
+				     GFP_KERNEL, cpu_to_node(i));
+		if (!rt_rq)
+			goto err;
+
+		rt_se = kzalloc_node(sizeof(struct sched_rt_entity),
+				     GFP_KERNEL, cpu_to_node(i));
+		if (!rt_se)
+			goto err_free_rq;
+
+		init_rt_rq(rt_rq, cpu_rq(i));
+		rt_rq->rt_runtime = tg->rt_bandwidth.rt_runtime;
+		init_tg_rt_entry(tg, rt_rq, rt_se, i, parent->rt_se[i]);
+	}
+
+	return 1;
+
+err_free_rq:
+	kfree(rt_rq);
+err:
+	return 0;
+}
+
 #else /* CONFIG_RT_GROUP_SCHED */
 
 #define rt_entity_is_task(rt_se) (1)
@@ -47,6 +217,12 @@ static inline struct rt_rq *rt_rq_of_se(
 	return &rq->rt;
 }
 
+void free_rt_sched_group(struct task_group *tg) { }
+
+int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
+{
+	return 1;
+}
 #endif /* CONFIG_RT_GROUP_SCHED */
 
 #ifdef CONFIG_SMP
@@ -556,6 +732,28 @@ static void enable_runtime(struct rq *rq
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
+int update_runtime(struct notifier_block *nfb, unsigned long action, void *hcpu)
+{
+	int cpu = (int)(long)hcpu;
+
+	switch (action) {
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+		disable_runtime(cpu_rq(cpu));
+		return NOTIFY_OK;
+
+	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		enable_runtime(cpu_rq(cpu));
+		return NOTIFY_OK;
+
+	default:
+		return NOTIFY_DONE;
+	}
+}
+
 static int balance_runtime(struct rt_rq *rt_rq)
 {
 	int more = 0;
@@ -1178,8 +1376,6 @@ static void put_prev_task_rt(struct rq *
 /* Only try algorithms three times */
 #define RT_MAX_TRIES 3
 
-static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep);
-
 static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
 {
 	if (!task_running(rq, p) &&
@@ -1653,13 +1849,14 @@ static void switched_from_rt(struct rq *
 		pull_rt_task(rq);
 }
 
-static inline void init_sched_rt_class(void)
+void init_sched_rt_class(void)
 {
 	unsigned int i;
 
-	for_each_possible_cpu(i)
+	for_each_possible_cpu(i) {
 		zalloc_cpumask_var_node(&per_cpu(local_cpu_mask, i),
 					GFP_KERNEL, cpu_to_node(i));
+	}
 }
 #endif /* CONFIG_SMP */
 
@@ -1800,7 +1997,7 @@ static unsigned int get_rr_interval_rt(s
 		return 0;
 }
 
-static const struct sched_class rt_sched_class = {
+const struct sched_class rt_sched_class = {
 	.next			= &fair_sched_class,
 	.enqueue_task		= enqueue_task_rt,
 	.dequeue_task		= dequeue_task_rt,
@@ -1835,7 +2032,7 @@ static const struct sched_class rt_sched
 #ifdef CONFIG_SCHED_DEBUG
 extern void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq);
 
-static void print_rt_stats(struct seq_file *m, int cpu)
+void print_rt_stats(struct seq_file *m, int cpu)
 {
 	rt_rq_iter_t iter;
 	struct rt_rq *rt_rq;
Index: linux-2.6/kernel/sched_stoptask.c
===================================================================
--- linux-2.6.orig/kernel/sched_stoptask.c
+++ linux-2.6/kernel/sched_stoptask.c
@@ -1,3 +1,5 @@
+#include "sched.h"
+
 /*
  * stop-task scheduling class.
  *
@@ -80,7 +82,7 @@ get_rr_interval_stop(struct rq *rq, stru
 /*
  * Simple, special scheduling class for the per-CPU stop tasks:
  */
-static const struct sched_class stop_sched_class = {
+const struct sched_class stop_sched_class = {
 	.next			= &rt_sched_class,
 
 	.enqueue_task		= enqueue_task_stop,
Index: linux-2.6/kernel/sched_autogroup.h
===================================================================
--- linux-2.6.orig/kernel/sched_autogroup.h
+++ linux-2.6/kernel/sched_autogroup.h
@@ -1,5 +1,8 @@
 #ifdef CONFIG_SCHED_AUTOGROUP
 
+#include <linux/kref.h>
+#include <linux/rwsem.h>
+
 struct autogroup {
 	/*
 	 * reference doesn't mean how many thread attach to this
@@ -13,9 +16,28 @@ struct autogroup {
 	int			nice;
 };
 
-static inline bool task_group_is_autogroup(struct task_group *tg);
+extern void autogroup_init(struct task_struct *init_task);
+extern void autogroup_free(struct task_group *tg);
+
+static inline bool task_group_is_autogroup(struct task_group *tg)
+{
+	return !!tg->autogroup;
+}
+
+extern bool task_wants_autogroup(struct task_struct *p, struct task_group *tg);
+
 static inline struct task_group *
-autogroup_task_group(struct task_struct *p, struct task_group *tg);
+autogroup_task_group(struct task_struct *p, struct task_group *tg)
+{
+	int enabled = ACCESS_ONCE(sysctl_sched_autogroup_enabled);
+
+	if (enabled && task_wants_autogroup(p, tg))
+		return p->signal->autogroup->tg;
+
+	return tg;
+}
+
+extern int autogroup_path(struct task_group *tg, char *buf, int buflen);
 
 #else /* !CONFIG_SCHED_AUTOGROUP */
 
Index: linux-2.6/kernel/sched_stats.c
===================================================================
--- /dev/null
+++ linux-2.6/kernel/sched_stats.c
@@ -0,0 +1,111 @@
+
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/seq_file.h>
+#include <linux/proc_fs.h>
+
+#include "sched.h"
+
+/*
+ * bump this up when changing the output format or the meaning of an existing
+ * format, so that tools can adapt (or abort)
+ */
+#define SCHEDSTAT_VERSION 15
+
+static int show_schedstat(struct seq_file *seq, void *v)
+{
+	int cpu;
+	int mask_len = DIV_ROUND_UP(NR_CPUS, 32) * 9;
+	char *mask_str = kmalloc(mask_len, GFP_KERNEL);
+
+	if (mask_str == NULL)
+		return -ENOMEM;
+
+	seq_printf(seq, "version %d\n", SCHEDSTAT_VERSION);
+	seq_printf(seq, "timestamp %lu\n", jiffies);
+	for_each_online_cpu(cpu) {
+		struct rq *rq = cpu_rq(cpu);
+#ifdef CONFIG_SMP
+		struct sched_domain *sd;
+		int dcount = 0;
+#endif
+
+		/* runqueue-specific stats */
+		seq_printf(seq,
+		    "cpu%d %u %u %u %u %u %u %llu %llu %lu",
+		    cpu, rq->yld_count,
+		    rq->sched_switch, rq->sched_count, rq->sched_goidle,
+		    rq->ttwu_count, rq->ttwu_local,
+		    rq->rq_cpu_time,
+		    rq->rq_sched_info.run_delay, rq->rq_sched_info.pcount);
+
+		seq_printf(seq, "\n");
+
+#ifdef CONFIG_SMP
+		/* domain-specific stats */
+		rcu_read_lock();
+		for_each_domain(cpu, sd) {
+			enum cpu_idle_type itype;
+
+			cpumask_scnprintf(mask_str, mask_len,
+					  sched_domain_span(sd));
+			seq_printf(seq, "domain%d %s", dcount++, mask_str);
+			for (itype = CPU_IDLE; itype < CPU_MAX_IDLE_TYPES;
+					itype++) {
+				seq_printf(seq, " %u %u %u %u %u %u %u %u",
+				    sd->lb_count[itype],
+				    sd->lb_balanced[itype],
+				    sd->lb_failed[itype],
+				    sd->lb_imbalance[itype],
+				    sd->lb_gained[itype],
+				    sd->lb_hot_gained[itype],
+				    sd->lb_nobusyq[itype],
+				    sd->lb_nobusyg[itype]);
+			}
+			seq_printf(seq,
+				   " %u %u %u %u %u %u %u %u %u %u %u %u\n",
+			    sd->alb_count, sd->alb_failed, sd->alb_pushed,
+			    sd->sbe_count, sd->sbe_balanced, sd->sbe_pushed,
+			    sd->sbf_count, sd->sbf_balanced, sd->sbf_pushed,
+			    sd->ttwu_wake_remote, sd->ttwu_move_affine,
+			    sd->ttwu_move_balance);
+		}
+		rcu_read_unlock();
+#endif
+	}
+	kfree(mask_str);
+	return 0;
+}
+
+static int schedstat_open(struct inode *inode, struct file *file)
+{
+	unsigned int size = PAGE_SIZE * (1 + num_online_cpus() / 32);
+	char *buf = kmalloc(size, GFP_KERNEL);
+	struct seq_file *m;
+	int res;
+
+	if (!buf)
+		return -ENOMEM;
+	res = single_open(file, show_schedstat, NULL);
+	if (!res) {
+		m = file->private_data;
+		m->buf = buf;
+		m->size = size;
+	} else
+		kfree(buf);
+	return res;
+}
+
+static const struct file_operations proc_schedstat_operations = {
+	.open    = schedstat_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = single_release,
+};
+
+static int __init proc_schedstat_init(void)
+{
+	proc_create("schedstat", 0, NULL, &proc_schedstat_operations);
+	return 0;
+}
+module_init(proc_schedstat_init);
Index: linux-2.6/kernel/sched_stats.h
===================================================================
--- linux-2.6.orig/kernel/sched_stats.h
+++ linux-2.6/kernel/sched_stats.h
@@ -1,108 +1,5 @@
 
 #ifdef CONFIG_SCHEDSTATS
-/*
- * bump this up when changing the output format or the meaning of an existing
- * format, so that tools can adapt (or abort)
- */
-#define SCHEDSTAT_VERSION 15
-
-static int show_schedstat(struct seq_file *seq, void *v)
-{
-	int cpu;
-	int mask_len = DIV_ROUND_UP(NR_CPUS, 32) * 9;
-	char *mask_str = kmalloc(mask_len, GFP_KERNEL);
-
-	if (mask_str == NULL)
-		return -ENOMEM;
-
-	seq_printf(seq, "version %d\n", SCHEDSTAT_VERSION);
-	seq_printf(seq, "timestamp %lu\n", jiffies);
-	for_each_online_cpu(cpu) {
-		struct rq *rq = cpu_rq(cpu);
-#ifdef CONFIG_SMP
-		struct sched_domain *sd;
-		int dcount = 0;
-#endif
-
-		/* runqueue-specific stats */
-		seq_printf(seq,
-		    "cpu%d %u %u %u %u %u %u %llu %llu %lu",
-		    cpu, rq->yld_count,
-		    rq->sched_switch, rq->sched_count, rq->sched_goidle,
-		    rq->ttwu_count, rq->ttwu_local,
-		    rq->rq_cpu_time,
-		    rq->rq_sched_info.run_delay, rq->rq_sched_info.pcount);
-
-		seq_printf(seq, "\n");
-
-#ifdef CONFIG_SMP
-		/* domain-specific stats */
-		rcu_read_lock();
-		for_each_domain(cpu, sd) {
-			enum cpu_idle_type itype;
-
-			cpumask_scnprintf(mask_str, mask_len,
-					  sched_domain_span(sd));
-			seq_printf(seq, "domain%d %s", dcount++, mask_str);
-			for (itype = CPU_IDLE; itype < CPU_MAX_IDLE_TYPES;
-					itype++) {
-				seq_printf(seq, " %u %u %u %u %u %u %u %u",
-				    sd->lb_count[itype],
-				    sd->lb_balanced[itype],
-				    sd->lb_failed[itype],
-				    sd->lb_imbalance[itype],
-				    sd->lb_gained[itype],
-				    sd->lb_hot_gained[itype],
-				    sd->lb_nobusyq[itype],
-				    sd->lb_nobusyg[itype]);
-			}
-			seq_printf(seq,
-				   " %u %u %u %u %u %u %u %u %u %u %u %u\n",
-			    sd->alb_count, sd->alb_failed, sd->alb_pushed,
-			    sd->sbe_count, sd->sbe_balanced, sd->sbe_pushed,
-			    sd->sbf_count, sd->sbf_balanced, sd->sbf_pushed,
-			    sd->ttwu_wake_remote, sd->ttwu_move_affine,
-			    sd->ttwu_move_balance);
-		}
-		rcu_read_unlock();
-#endif
-	}
-	kfree(mask_str);
-	return 0;
-}
-
-static int schedstat_open(struct inode *inode, struct file *file)
-{
-	unsigned int size = PAGE_SIZE * (1 + num_online_cpus() / 32);
-	char *buf = kmalloc(size, GFP_KERNEL);
-	struct seq_file *m;
-	int res;
-
-	if (!buf)
-		return -ENOMEM;
-	res = single_open(file, show_schedstat, NULL);
-	if (!res) {
-		m = file->private_data;
-		m->buf = buf;
-		m->size = size;
-	} else
-		kfree(buf);
-	return res;
-}
-
-static const struct file_operations proc_schedstat_operations = {
-	.open    = schedstat_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = single_release,
-};
-
-static int __init proc_schedstat_init(void)
-{
-	proc_create("schedstat", 0, NULL, &proc_schedstat_operations);
-	return 0;
-}
-module_init(proc_schedstat_init);
 
 /*
  * Expects runqueue lock to be held for atomicity of update
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -925,6 +925,15 @@ static inline struct cpumask *sched_grou
 	return to_cpumask(sg->cpumask);
 }
 
+/**
+ * group_first_cpu - Returns the first cpu in the cpumask of a sched_group.
+ * @group: The group whose first cpu is to be returned.
+ */
+static inline unsigned int group_first_cpu(struct sched_group *group)
+{
+	return cpumask_first(sched_group_cpus(group));
+}
+
 struct sched_domain_attr {
 	int relax_domain_level;
 };
Index: linux-2.6/kernel/Makefile
===================================================================
--- linux-2.6.orig/kernel/Makefile
+++ linux-2.6/kernel/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
+obj-y     = fork.o exec_domain.o panic.o printk.o \
 	    cpu.o exit.o itimer.o time.o softirq.o resource.o \
 	    sysctl.o sysctl_binary.o capability.o ptrace.o timer.o user.o \
 	    signal.o sys.o kmod.o workqueue.o pid.o \
@@ -10,8 +10,12 @@ obj-y     = sched.o fork.o exec_domain.o
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o \
-	    async.o range.o
-obj-y += groups.o
+	    async.o range.o groups.o
+
+obj-y += sched.o sched_idletask.o sched_fair.o sched_rt.o sched_stoptask.o
+obj-$(CONFIG_SCHED_AUTOGROUP) += sched_autogroup.o
+obj-$(CONFIG_SCHEDSTATS) += sched_stats.o
+obj-$(CONFIG_SCHED_DEBUG) += sched_debug.o
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files

