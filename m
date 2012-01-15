Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab2AONqV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 08:46:21 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:49524 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752184Ab2AONqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 08:46:19 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+IsT0FaUqILVLCqbGuhJMVkjMqDzGU6eoXECaIHU
	Ip5+7Bo4KhaNSy
Subject: Re: [PATCH] specific do_timer_cpu value for nohz off mode
From: Mike Galbraith <efault@gmx.de>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20111108191149.GA7236@sgi.com>
References: <20111108191149.GA7236@sgi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 15 Jan 2012 14:46:08 +0100
Message-ID: <1326635168.6352.88.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-08 at 13:11 -0600, Dimitri Sivanich wrote:
> Resending this.
> 
> 
> Allow manual override of the tick_do_timer_cpu.

Bigger button below.

> While not necessarily harmful, doing jiffies updates on an application cpu
> does cause some extra overhead that HPC benchmarking people notice.  They
> prefer to have OS activity isolated to certain cpus.  They like reproducibility
> of results, and having jiffies updates bouncing around introduces variability.


> +#ifdef CONFIG_NO_HZ
> +	/* nohz mode not supported */
> +	if (tick_nohz_enabled)
> +		return -EINVAL;
> +#endif

Uhuh, we have something in common, your HPC folks don't like NO_HZ
because it makes loads of jitter, my RT jitter test proggy hates it to
pieces for the same reason.  I can't just config it out like you though.

Aside: how come your HPC folks aren't griping about (SGI monster) boxen
ticking all at the same time?  That makes my 64 core box jitter plenty.

Anyway, if you boot one of your monster boxen nohz=off, or in this case,
just don't build with NO_HZ, the electric meter spins a lot faster than
with NO_HZ, yes?  So I wonder if something like the below would help.
Seems to me cpusets is the right place to do this kind of tweaking,
though this particular patch may be eligible for an "award" or two :)

Turning NO_HZ off is probably not as good as just building without
NO_HZ, but for me, running an all pinned RT load in an isolated set and
distro config, I can switch an isolated cpuset to "sched_hpc", and only
the part of the box that NEEDS to kill NO_HZ does so, RT test proggy
becomes happy without booting nohz=off, and the partition can resume
green machine mode when done doing whatever required turning NO_HZ off,
and in my case rt push/pull as well to further improve jitter, since
it's not only a jitter source, but a waste of cycles for a 100% pinned
and isolated load.

Poke sched_hpc, CPU0 starts ticking, becomes jiffies knave (you need),
isolated partition also starts ticking (we both need).  Or, poke
sched_hpc_rt, it'll do that and turn rt push/pull off as well, which I
don't desperately need, but it does cut remaining jitter in half.

There's space for other "isolate me harder" buttons, though one would
hope the space would never be used.. these two are ugly enough.  I
couldn't figure out how to make it any prettier.

---
 include/linux/sched.h    |   29 ++++++
 init/Kconfig             |   11 ++
 kernel/cpuset.c          |  203 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c      |   95 +++++++++++++++++++++
 kernel/sched/fair.c      |    4 
 kernel/sched/rt.c        |   18 +++-
 kernel/sched/sched.h     |   17 +++
 kernel/time/tick-sched.c |    2 
 8 files changed, 372 insertions(+), 7 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -271,6 +271,35 @@ extern void init_idle_bootup_task(struct
 
 extern int runqueue_is_locked(int cpu);
 
+/* Cpuset runqueue behavior modifier bits */
+enum
+{
+	RQ_TICK=0,
+	RQ_HPC,
+	RQ_HPCRT,
+	RQ_CLEAR=~0,
+};
+
+#ifdef CONFIG_HPC_CPUSETS
+extern int runqueue_is_flagged(int cpu, int nr);
+extern int runqueue_is_isolated(int cpu);
+extern void cpuset_flags_set(int cpu, unsigned bits);
+extern void cpuset_flags_clr(int cpu, unsigned bits);
+
+#ifdef CONFIG_NO_HZ
+static inline int sched_needs_cpu(int cpu)
+{
+	return runqueue_is_flagged(cpu, RQ_TICK);
+}
+#endif
+#else /* !CONFIG_HPC_CPUSETS */
+static inline int runqueue_is_flagged(int cpu, int nr) { return 0; }
+static inline int runqueue_is_isolated(int cpu) { return 0; }
+static inline int sched_needs_cpu(int cpu) { return 0; }
+static inline void cpuset_flag_set(int cpu, unsigned bits) { }
+static inline void cpuset_flag_clr(int cpu, unsigned bits) { }
+#endif /* CONFIG_HPC_CPUSETS */
+
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
 extern void select_nohz_load_balancer(int stop_tick);
 extern void set_cpu_sd_state_idle(void);
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -624,6 +624,17 @@ config PROC_PID_CPUSET
 	depends on CPUSETS
 	default y
 
+config HPC_CPUSETS
+	bool "HPC cpusets"
+	depends on CPUSETS && SMP
+	default n
+	help
+	  This option provides per CPUSET scheduler behavior control switches.
+	  This is primarily useful on large SMP systems where some partitions
+	  may be dedicated to sensitive HPC applications, while others are not.
+
+	  Say N if unsure.
+
 config CGROUP_CPUACCT
 	bool "Simple CPU accounting cgroup subsystem"
 	help
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -145,6 +145,8 @@ typedef enum {
 	CS_SCHED_LOAD_BALANCE,
 	CS_SPREAD_PAGE,
 	CS_SPREAD_SLAB,
+	CS_SCHED_HPC,
+	CS_SCHED_HPCRT,
 } cpuset_flagbits_t;
 
 /* convenient tests for these bits */
@@ -183,6 +185,16 @@ static inline int is_spread_slab(const s
 	return test_bit(CS_SPREAD_SLAB, &cs->flags);
 }
 
+static inline int is_sched_hpc(const struct cpuset *cs)
+{
+	return test_bit(CS_SCHED_HPC, &cs->flags);
+}
+
+static inline int is_sched_hpc_rt(const struct cpuset *cs)
+{
+	return test_bit(CS_SCHED_HPCRT, &cs->flags);
+}
+
 static struct cpuset top_cpuset = {
 	.flags = ((1 << CS_CPU_EXCLUSIVE) | (1 << CS_MEM_EXCLUSIVE)),
 };
@@ -382,6 +394,147 @@ static void free_trial_cpuset(struct cpu
 	kfree(trial);
 }
 
+#ifdef CONFIG_HPC_CPUSETS
+static int
+validate_sched_change(const struct cpuset *cur, const struct cpuset *trial)
+{
+	int cpu;
+
+	if (!is_sched_hpc(trial))
+		return 0;
+
+	cpu = cpumask_first(trial->cpus_allowed);
+
+	if (cur == &top_cpuset || !is_cpu_exclusive(cur))
+		return -EINVAL;
+	/*
+	 * HPC cpusets may not contain the boot CPU,
+	 * and must be completely isolated or empty.
+	 */
+	if (!cpu || is_sched_load_balance(cur))
+		return -EINVAL;
+	if (cpu < nr_cpu_ids && !runqueue_is_isolated(cpu))
+		return -EINVAL;
+
+	/* Handle CPUs entering or leaving the set */
+	if (!cpumask_equal(cur->cpus_allowed, trial->cpus_allowed)) {
+		cpumask_var_t delta;
+		int entering, cpu;
+		unsigned bits;
+
+		if (!zalloc_cpumask_var(&delta, GFP_KERNEL))
+			return -ENOMEM;
+
+		cpumask_xor(delta, cur->cpus_allowed, trial->cpus_allowed);
+		entering = cpumask_weight(cur->cpus_allowed) <
+				cpumask_weight(trial->cpus_allowed);
+
+		bits = (1 << RQ_TICK) | (1 << RQ_HPC);
+		if (is_sched_hpc_rt(trial))
+			bits |= 1 << RQ_HPCRT;
+
+		if (entering) {
+			for_each_cpu(cpu, delta) {
+				if (runqueue_is_isolated(cpu))
+					continue;
+				free_cpumask_var(delta);
+					return -EINVAL;
+			}
+		}
+
+		for_each_cpu(cpu, delta) {
+			if (entering)
+				cpuset_flags_set(cpu, bits);
+			else
+				cpuset_flags_clr(cpu, bits);
+		}
+		free_cpumask_var(delta);
+	}
+
+	return 0;
+}
+
+/*
+ * update_sched_flags - update scheduler modifier flags in cpusets.
+ * @bit: the bit changing state.
+ * @cs: the cpuset in which flags need to be updated:
+ * @turning_on: whether we're turning the bit on or off.
+ *
+ * Called with cgroup_mutex held.  Turn scheduler modifiers on/off,
+ * updating runqueue flags for associated CPUs.  Set/clear of a flag
+ * which invalidates modifiers recursively clears invalidated flags
+ * for child cpusets and their associated CPUs.
+ *
+ * No return value.
+ */
+static void
+update_sched_flags(cpuset_flagbits_t bit, struct cpuset *cs, int turning_on)
+{
+	struct cgroup *cont;
+	struct cpuset *child;
+	unsigned cpu, bits = 0, recursive = 0;
+
+	switch (bit) {
+	case CS_CPU_EXCLUSIVE:
+		if (turning_on)
+			return;
+		bits = RQ_CLEAR;
+		recursive = 1;
+		break;
+	case CS_SCHED_LOAD_BALANCE:
+		if (!turning_on)
+			return;
+		if (is_sched_hpc(cs)) {
+			bits |= (1 << RQ_TICK) | (1 << RQ_HPC);
+			clear_bit(CS_SCHED_HPC, &cs->flags);
+		}
+		if (is_sched_hpc_rt(cs)) {
+			bits |= (1 << RQ_HPCRT);
+			clear_bit(CS_SCHED_HPCRT, &cs->flags);
+		}
+		recursive = 1;
+		break;
+	case CS_SCHED_HPC:
+		bits = (1 << RQ_TICK) | (1 << RQ_HPC);
+		break;
+	case CS_SCHED_HPCRT:
+		bits = (1 << RQ_HPCRT);
+		break;
+	default:
+		return;
+	}
+
+	if (recursive) {
+		list_for_each_entry(cont, &cs->css.cgroup->children, sibling) {
+			child = cgroup_cs(cont);
+			update_sched_flags(bit, child, turning_on);
+		}
+		turning_on = 0;
+	}
+
+	if (!bits)
+		return;
+
+	for_each_cpu(cpu, cs->cpus_allowed) {
+		if (turning_on)
+			cpuset_flags_set(cpu, bits);
+		else
+			cpuset_flags_clr(cpu, bits);
+	}
+}
+
+#else /* !CONFIG_HPC_CPUSETS */
+
+static int
+validate_sched_change(const struct cpuset *cur, const struct cpuset *trial)
+{
+	return 0;
+}
+static void
+update_sched_flags(cpuset_flagbits_t bit, struct cpuset *cs, int turning_on) { }
+
+#endif /* CONFIG_HPC_CPUSETS */
+
 /*
  * validate_change() - Used to validate that any proposed cpuset change
  *		       follows the structural rules for cpusets.
@@ -406,6 +559,7 @@ static int validate_change(const struct
 {
 	struct cgroup *cont;
 	struct cpuset *c, *par;
+	int ret;
 
 	/* Each of our child cpusets must be a subset of us */
 	list_for_each_entry(cont, &cur->css.cgroup->children, sibling) {
@@ -413,6 +567,10 @@ static int validate_change(const struct
 			return -EBUSY;
 	}
 
+	ret = validate_sched_change(cur, trial);
+	if (ret)
+		return ret;
+
 	/* Remaining checks don't apply to root cpuset */
 	if (cur == &top_cpuset)
 		return 0;
@@ -1250,6 +1408,7 @@ static int update_flag(cpuset_flagbits_t
 	struct cpuset *trialcs;
 	int balance_flag_changed;
 	int spread_flag_changed;
+	int sched_flag_changed;
 	struct ptr_heap heap;
 	int err;
 
@@ -1273,6 +1432,11 @@ static int update_flag(cpuset_flagbits_t
 	balance_flag_changed = (is_sched_load_balance(cs) !=
 				is_sched_load_balance(trialcs));
 
+	sched_flag_changed = balance_flag_changed;
+	sched_flag_changed |= (is_cpu_exclusive(cs) != is_cpu_exclusive(trialcs));
+	sched_flag_changed |= (is_sched_hpc(cs) != is_sched_hpc(trialcs));
+	sched_flag_changed |= (is_sched_hpc_rt(cs) != is_sched_hpc_rt(trialcs));
+
 	spread_flag_changed = ((is_spread_slab(cs) != is_spread_slab(trialcs))
 			|| (is_spread_page(cs) != is_spread_page(trialcs)));
 
@@ -1283,6 +1447,9 @@ static int update_flag(cpuset_flagbits_t
 	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed)
 		async_rebuild_sched_domains();
 
+	if (sched_flag_changed)
+		update_sched_flags(bit, cs, turning_on);
+
 	if (spread_flag_changed)
 		update_tasks_flags(cs, &heap);
 	heap_free(&heap);
@@ -1488,6 +1655,8 @@ typedef enum {
 	FILE_MEMORY_PRESSURE,
 	FILE_SPREAD_PAGE,
 	FILE_SPREAD_SLAB,
+	FILE_SCHED_HPC,
+	FILE_SCHED_HPCRT,
 } cpuset_filetype_t;
 
 static int cpuset_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
@@ -1527,6 +1696,18 @@ static int cpuset_write_u64(struct cgrou
 	case FILE_SPREAD_SLAB:
 		retval = update_flag(CS_SPREAD_SLAB, cs, val);
 		break;
+	case FILE_SCHED_HPC:
+		if (!val && is_sched_hpc_rt(cs))
+			retval = update_flag(CS_SCHED_HPCRT, cs, val);
+		if (!retval)
+			retval = update_flag(CS_SCHED_HPC, cs, val);
+		break;
+	case FILE_SCHED_HPCRT:
+		if (val && !is_sched_hpc(cs))
+			retval = update_flag(CS_SCHED_HPC, cs, val);
+		if (!retval)
+			retval = update_flag(CS_SCHED_HPCRT, cs, val);
+		break;
 	default:
 		retval = -EINVAL;
 		break;
@@ -1676,6 +1857,10 @@ static u64 cpuset_read_u64(struct cgroup
 		return is_mem_hardwall(cs);
 	case FILE_SCHED_LOAD_BALANCE:
 		return is_sched_load_balance(cs);
+	case FILE_SCHED_HPC:
+		return is_sched_hpc(cs);
+	case FILE_SCHED_HPCRT:
+		return is_sched_hpc_rt(cs);
 	case FILE_MEMORY_MIGRATE:
 		return is_memory_migrate(cs);
 	case FILE_MEMORY_PRESSURE_ENABLED:
@@ -1765,8 +1950,22 @@ static struct cftype files[] = {
 		.write_s64 = cpuset_write_s64,
 		.private = FILE_SCHED_RELAX_DOMAIN_LEVEL,
 	},
+#ifdef CONFIG_HPC_CPUSETS
+	{
+		.name = "sched_hpc",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_SCHED_HPC,
+	},
 
 	{
+		.name = "sched_hpc_rt",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_SCHED_HPCRT,
+	},
+#endif
+	{
 		.name = "memory_migrate",
 		.read_u64 = cpuset_read_u64,
 		.write_u64 = cpuset_write_u64,
@@ -1906,6 +2105,10 @@ static void cpuset_destroy(struct cgroup
 {
 	struct cpuset *cs = cgroup_cs(cont);
 
+	if (is_sched_hpc_rt(cs))
+		update_flag(CS_SCHED_HPCRT, cs, 0);
+	if (is_sched_hpc(cs))
+		update_flag(CS_SCHED_HPC, cs, 0);
 	if (is_sched_load_balance(cs))
 		update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
 
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1957,14 +1957,14 @@ static void finish_task_switch(struct rq
 /* assumes rq->lock is held */
 static inline void pre_schedule(struct rq *rq, struct task_struct *prev)
 {
-	if (prev->sched_class->pre_schedule)
+	if (prev->sched_class->pre_schedule && !rq_flag(rq, RQ_HPCRT))
 		prev->sched_class->pre_schedule(rq, prev);
 }
 
 /* rq->lock is NOT held, but preemption is disabled */
 static inline void post_schedule(struct rq *rq)
 {
-	if (rq->post_schedule) {
+	if (rq->post_schedule && !rq_flag(rq, RQ_HPCRT)) {
 		unsigned long flags;
 
 		raw_spin_lock_irqsave(&rq->lock, flags);
@@ -2986,6 +2986,92 @@ void thread_group_times(struct task_stru
 }
 #endif
 
+#ifdef CONFIG_HPC_CPUSETS
+extern int tick_do_timer_cpu __read_mostly;
+static int nr_hpc_cpus;
+
+#ifndef CONFIG_NO_HZ
+static inline void wake_up_idle_cpu(int cpu) { }
+#endif
+
+/* Called with cgroup_mutex held */
+void cpuset_flags_set(int cpu, unsigned bits)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long flags;
+	int nr;
+
+	raw_spin_lock_irqsave(&rq->lock, flags);
+	/* Set blocker flags before taking any action */
+	rq->cpuset_flags |= bits;
+	for (nr = 0; bits; nr++) {
+		if (!(bits & (1 << nr)))
+			continue;
+		switch (nr) {
+		case RQ_TICK:
+			break;
+		case RQ_HPC:
+			/* Ensure that jiffies doesn't go stale */
+			if (!nr_hpc_cpus++) {
+				tick_do_timer_cpu = 0;
+				/* safe, CPU0 is modifier excluded */
+				cpuset_flags_set(0, 1 << RQ_TICK);
+				wake_up_idle_cpu(0);
+			}
+			break;
+		case RQ_HPCRT:
+			cpupri_set(&rq->rd->cpupri, cpu, CPUPRI_INVALID);
+			break;
+		}
+		bits &= ~(1 << nr);
+	}
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
+}
+
+/* Called with cgroup_mutex held */
+void cpuset_flags_clr(int cpu, unsigned bits)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long flags;
+	unsigned nr, clear = bits, cleared = 0;
+
+	raw_spin_lock_irqsave(&rq->lock, flags);
+	bits &= rq->cpuset_flags;
+	rq->cpuset_flags &= ~bits;
+	for (nr = 0; bits; nr++) {
+		if (!(bits & (1 << nr)))
+			continue;
+		switch (nr) {
+		case RQ_TICK:
+			break;
+		case RQ_HPC:
+			/* Let CPU0 resume nohz mode */
+			if (nr_hpc_cpus && !--nr_hpc_cpus)
+				cpuset_flags_clr(0, 1 << RQ_TICK);
+			break;
+		case RQ_HPCRT:
+			cpupri_set(&rq->rd->cpupri, cpu, rq->rt.highest_prio.curr);
+			break;
+		}
+		bits &= ~(1 << nr);
+		cleared |= (1 << nr);
+	}
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
+
+	WARN_ON_ONCE(clear != RQ_CLEAR && clear != cleared);
+}
+
+int runqueue_is_isolated(int cpu)
+{
+	return !cpu_rq(cpu)->sd;
+}
+
+int runqueue_is_flagged(int cpu, int nr)
+{
+	return rq_flag(cpu_rq(cpu), nr);
+}
+#endif /* CONFIG_HPC_CPUSETS */
+
 /*
  * This function gets called by the timer code, with HZ frequency.
  * We call it with interrupts disabled.
@@ -3007,6 +3093,8 @@ void scheduler_tick(void)
 	perf_event_task_tick();
 
 #ifdef CONFIG_SMP
+	if (rq_flag(rq, RQ_HPC))
+		return;
 	rq->idle_balance = idle_cpu(cpu);
 	trigger_load_balance(rq, cpu);
 #endif
@@ -6940,6 +7028,9 @@ void __init sched_init(void)
 #ifdef CONFIG_NO_HZ
 		rq->nohz_flags = 0;
 #endif
+#ifdef CONFIG_HPC_CPUSETS
+		rq->cpuset_flags = 0;
+#endif
 #endif
 		init_rq_hrtick(rq);
 		atomic_set(&rq->nr_iowait, 0);
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4620,6 +4620,9 @@ void idle_balance(int this_cpu, struct r
 	int pulled_task = 0;
 	unsigned long next_balance = jiffies + HZ;
 
+	if (!this_rq->sd)
+		return;
+
 	this_rq->idle_stamp = this_rq->clock;
 
 	if (this_rq->avg_idle < sysctl_sched_migration_cost)
@@ -4914,6 +4917,7 @@ void select_nohz_load_balancer(int stop_
 	}
 	return;
 }
+
 #endif
 
 static DEFINE_SPINLOCK(balancing);
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -917,8 +917,13 @@ inc_rt_prio_smp(struct rt_rq *rt_rq, int
 {
 	struct rq *rq = rq_of_rt_rq(rt_rq);
 
-	if (rq->online && prio < prev_prio)
-		cpupri_set(&rq->rd->cpupri, rq->cpu, prio);
+	if (!rq->online || prio >= prev_prio)
+		return;
+
+	if (rq_flag(rq, SCHED_HPCRT))
+		return;
+
+	cpupri_set(&rq->rd->cpupri, rq->cpu, prio);
 }
 
 static void
@@ -926,8 +931,13 @@ dec_rt_prio_smp(struct rt_rq *rt_rq, int
 {
 	struct rq *rq = rq_of_rt_rq(rt_rq);
 
-	if (rq->online && rt_rq->highest_prio.curr != prev_prio)
-		cpupri_set(&rq->rd->cpupri, rq->cpu, rt_rq->highest_prio.curr);
+	if (!rq->online || rt_rq->highest_prio.curr == prev_prio)
+		return;
+
+	if (rq_flag(rq, SCHED_HPCRT))
+		return;
+
+	cpupri_set(&rq->rd->cpupri, rq->cpu, rt_rq->highest_prio.curr);
 }
 
 #else /* CONFIG_SMP */
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -424,6 +424,11 @@ struct rq {
 	int cpu;
 	int online;
 
+#ifdef CONFIG_CPUSETS
+	/* cpuset scheduler modifiers */
+	unsigned int cpuset_flags;
+#endif
+
 	u64 rt_avg;
 	u64 age_stamp;
 	u64 idle_stamp;
@@ -539,6 +544,18 @@ DECLARE_PER_CPU(int, sd_llc_id);
 
 #endif /* CONFIG_SMP */
 
+#ifdef CONFIG_HPC_CPUSETS
+static inline int rq_flag(struct rq *rq, int nr)
+{
+	return rq->cpuset_flags & (1 << nr);
+}
+#else
+static inline int rq_flag(struct rq *rq, int nr)
+{
+	return 0;
+}
+#endif
+
 #include "stats.h"
 #include "auto_group.h"
 
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -327,7 +327,7 @@ static void tick_nohz_stop_sched_tick(st
 	} while (read_seqretry(&xtime_lock, seq));
 
 	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
-	    arch_needs_cpu(cpu)) {
+	    arch_needs_cpu(cpu) || sched_needs_cpu(cpu)) {
 		next_jiffies = last_jiffies + 1;
 		delta_jiffies = 1;
 	} else {



