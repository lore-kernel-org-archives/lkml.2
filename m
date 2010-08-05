Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759926Ab0HEHus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 03:50:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42444 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759706Ab0HEHun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 03:50:43 -0400
Date: Thu, 5 Aug 2010 09:50:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] Scheduler updates for v2.6.36
Message-ID: <20100805075017.GA8524@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-core-for-linus

The most user-visible bits could be the load-balancer enhancements - hopefully 
for the better ;-)

 Thanks,

	Ingo

------------------>
Josh Hunt (1):
      sched: Use correct macro to display sched_child_runs_first in /proc/sched_debug

Michael Neuling (5):
      sched: Add asymmetric group packing option for sibling domain
      powerpc: Enable asymmetric SMT scheduling on POWER7
      sched: Fix fix_small_capacity
      sched: Fix comments to make them DocBook happy
      sched: Fix spelling of sibling

Oleg Nesterov (7):
      sched: Simplify the reacquire_kernel_lock() logic
      sched: __sched_setscheduler: Read the RLIMIT_RTPRIO value lockless
      sched: task_tick_rt: Remove the obsolete ->signal != NULL check
      sched: Remove the obsolete exit_state/signal hacks
      sched: thread_group_cputime: Simplify, document the "alive" check
      sched: run_posix_cpu_timers: Don't check ->exit_state, use lock_task_sighand()
      sched: Fix the racy usage of thread_group_cputimer() in fastpath_timer_check()

Pekka Enberg (1):
      sched: No need for bootmem special cases

Peter Zijlstra (4):
      sched_clock: Add local_clock() API and improve documentation
      powerpc: Exclude arch_sd_sibiling_asym_packing() on UP
      sched: Reduce update_group_power() calls
      sched: Revert nohz_ratelimit() for now

Srivatsa Vaddagiri (1):
      sched: Fix capacity calculations for SMT4

Suresh Siddha (1):
      sched: Update rq->clock for nohz balanced cpus

Tejun Heo (5):
      sched: define and use CPU_PRI_* enums for cpu notifier priorities
      sched: adjust when cpu_active and cpuset configurations are updated during cpu on/offlining
      sched: refactor try_to_wake_up()
      sched: add hooks for workqueue
      sched, cpuset: Drop __cpuexit from cpu hotplug callbacks

Venkatesh Pallipadi (2):
      sched: Avoid side-effect of tickless idle on update_cpu_load
      sched: Change nohz idle load balancing logic to push model


 arch/parisc/kernel/ftrace.c         |    4 +-
 arch/powerpc/include/asm/cputable.h |    3 +-
 arch/powerpc/kernel/process.c       |   11 +
 include/linux/cpu.h                 |   25 ++
 include/linux/cpuset.h              |    6 +
 include/linux/perf_event.h          |    2 +-
 include/linux/sched.h               |   59 ++--
 include/linux/topology.h            |    1 +
 kernel/cpu.c                        |    6 -
 kernel/cpuset.c                     |   21 +--
 kernel/fork.c                       |    2 +-
 kernel/hrtimer.c                    |    8 +-
 kernel/lockdep.c                    |    2 +-
 kernel/perf_event.c                 |    2 +-
 kernel/posix-cpu-timers.c           |   36 +--
 kernel/rcutorture.c                 |    3 +-
 kernel/sched.c                      |  391 +++++++++++++++++++-------
 kernel/sched_clock.c                |   95 ++++++-
 kernel/sched_cpupri.c               |    8 +-
 kernel/sched_cpupri.h               |    2 +-
 kernel/sched_debug.c                |    2 +-
 kernel/sched_fair.c                 |  532 ++++++++++++++++++++++++-----------
 kernel/sched_rt.c                   |    3 -
 kernel/sched_stats.h                |   27 +--
 kernel/time/tick-sched.c            |   10 +-
 kernel/timer.c                      |    8 +-
 kernel/trace/trace_clock.c          |    2 +-
 kernel/workqueue_sched.h            |   16 +
 28 files changed, 877 insertions(+), 410 deletions(-)
 create mode 100644 kernel/workqueue_sched.h

diff --git a/arch/parisc/kernel/ftrace.c b/arch/parisc/kernel/ftrace.c
index 9877372..5beb97b 100644
--- a/arch/parisc/kernel/ftrace.c
+++ b/arch/parisc/kernel/ftrace.c
@@ -82,7 +82,7 @@ unsigned long ftrace_return_to_handler(unsigned long retval0,
 	unsigned long ret;
 
 	pop_return_trace(&trace, &ret);
-	trace.rettime = cpu_clock(raw_smp_processor_id());
+	trace.rettime = local_clock();
 	ftrace_graph_return(&trace);
 
 	if (unlikely(!ret)) {
@@ -126,7 +126,7 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 		return;
 	}
 
-	calltime = cpu_clock(raw_smp_processor_id());
+	calltime = local_clock();
 
 	if (push_return_trace(old, calltime,
 				self_addr, &trace.depth) == -EBUSY) {
diff --git a/arch/powerpc/include/asm/cputable.h b/arch/powerpc/include/asm/cputable.h
index b0b2113..4b611ca 100644
--- a/arch/powerpc/include/asm/cputable.h
+++ b/arch/powerpc/include/asm/cputable.h
@@ -197,6 +197,7 @@ extern const char *powerpc_base_platform;
 #define CPU_FTR_SAO			LONG_ASM_CONST(0x0020000000000000)
 #define CPU_FTR_CP_USE_DCBTZ		LONG_ASM_CONST(0x0040000000000000)
 #define CPU_FTR_UNALIGNED_LD_STD	LONG_ASM_CONST(0x0080000000000000)
+#define CPU_FTR_ASYM_SMT		LONG_ASM_CONST(0x0100000000000000)
 
 #ifndef __ASSEMBLY__
 
@@ -412,7 +413,7 @@ extern const char *powerpc_base_platform;
 	    CPU_FTR_MMCRA | CPU_FTR_SMT | \
 	    CPU_FTR_COHERENT_ICACHE | CPU_FTR_LOCKLESS_TLBIE | \
 	    CPU_FTR_PURR | CPU_FTR_SPURR | CPU_FTR_REAL_LE | \
-	    CPU_FTR_DSCR | CPU_FTR_SAO)
+	    CPU_FTR_DSCR | CPU_FTR_SAO  | CPU_FTR_ASYM_SMT)
 #define CPU_FTRS_CELL	(CPU_FTR_USE_TB | CPU_FTR_LWSYNC | \
 	    CPU_FTR_PPCAS_ARCH_V2 | CPU_FTR_CTRL | \
 	    CPU_FTR_ALTIVEC_COMP | CPU_FTR_MMCRA | CPU_FTR_SMT | \
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 773424d..43855c9 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1263,3 +1263,14 @@ unsigned long randomize_et_dyn(unsigned long base)
 
 	return ret;
 }
+
+#ifdef CONFIG_SMP
+int arch_sd_sibling_asym_packing(void)
+{
+	if (cpu_has_feature(CPU_FTR_ASYM_SMT)) {
+		printk_once(KERN_INFO "Enabling Asymmetric SMT scheduling\n");
+		return SD_ASYM_PACKING;
+	}
+	return 0;
+}
+#endif
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index e287863..de6b172 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -48,6 +48,31 @@ extern ssize_t arch_cpu_release(const char *, size_t);
 #endif
 struct notifier_block;
 
+/*
+ * CPU notifier priorities.
+ */
+enum {
+	/*
+	 * SCHED_ACTIVE marks a cpu which is coming up active during
+	 * CPU_ONLINE and CPU_DOWN_FAILED and must be the first
+	 * notifier.  CPUSET_ACTIVE adjusts cpuset according to
+	 * cpu_active mask right after SCHED_ACTIVE.  During
+	 * CPU_DOWN_PREPARE, SCHED_INACTIVE and CPUSET_INACTIVE are
+	 * ordered in the similar way.
+	 *
+	 * This ordering guarantees consistent cpu_active mask and
+	 * migration behavior to all cpu notifiers.
+	 */
+	CPU_PRI_SCHED_ACTIVE	= INT_MAX,
+	CPU_PRI_CPUSET_ACTIVE	= INT_MAX - 1,
+	CPU_PRI_SCHED_INACTIVE	= INT_MIN + 1,
+	CPU_PRI_CPUSET_INACTIVE	= INT_MIN,
+
+	/* migration should happen before other stuff but after perf */
+	CPU_PRI_PERF		= 20,
+	CPU_PRI_MIGRATION	= 10,
+};
+
 #ifdef CONFIG_SMP
 /* Need to know about CPUs going up/down? */
 #if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE)
diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 457ed76..f20eb8f 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -20,6 +20,7 @@ extern int number_of_cpusets;	/* How many cpusets are defined in system? */
 
 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
+extern void cpuset_update_active_cpus(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
 extern int cpuset_cpus_allowed_fallback(struct task_struct *p);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
@@ -132,6 +133,11 @@ static inline void set_mems_allowed(nodemask_t nodemask)
 static inline int cpuset_init(void) { return 0; }
 static inline void cpuset_init_smp(void) {}
 
+static inline void cpuset_update_active_cpus(void)
+{
+	partition_sched_domains(1, NULL, NULL);
+}
+
 static inline void cpuset_cpus_allowed(struct task_struct *p,
 				       struct cpumask *mask)
 {
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 5d0266d..469e03e 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1068,7 +1068,7 @@ static inline void perf_event_disable(struct perf_event *event)		{ }
 #define perf_cpu_notifier(fn)					\
 do {								\
 	static struct notifier_block fn##_nb __cpuinitdata =	\
-		{ .notifier_call = fn, .priority = 20 };	\
+		{ .notifier_call = fn, .priority = CPU_PRI_PERF }; \
 	fn(&fn##_nb, (unsigned long)CPU_UP_PREPARE,		\
 		(void *)(unsigned long)smp_processor_id());	\
 	fn(&fn##_nb, (unsigned long)CPU_STARTING,		\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 747fcae..2091ea2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -271,19 +271,10 @@ extern int runqueue_is_locked(int cpu);
 
 extern cpumask_var_t nohz_cpu_mask;
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
-extern int select_nohz_load_balancer(int cpu);
-extern int get_nohz_load_balancer(void);
-extern int nohz_ratelimit(int cpu);
+extern void select_nohz_load_balancer(int stop_tick);
+extern int get_nohz_timer_target(void);
 #else
-static inline int select_nohz_load_balancer(int cpu)
-{
-	return 0;
-}
-
-static inline int nohz_ratelimit(int cpu)
-{
-	return 0;
-}
+static inline void select_nohz_load_balancer(int stop_tick) { }
 #endif
 
 /*
@@ -804,7 +795,7 @@ enum cpu_idle_type {
 #define SD_POWERSAVINGS_BALANCE	0x0100	/* Balance for power savings */
 #define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg resources */
 #define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
-
+#define SD_ASYM_PACKING		0x0800  /* Place busy groups earlier in the domain */
 #define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
 
 enum powersavings_balance_level {
@@ -839,6 +830,8 @@ static inline int sd_balance_for_package_power(void)
 	return SD_PREFER_SIBLING;
 }
 
+extern int __weak arch_sd_sibiling_asym_packing(void);
+
 /*
  * Optimise SD flags for power savings:
  * SD_BALANCE_NEWIDLE helps agressive task consolidation and power savings.
@@ -860,7 +853,7 @@ struct sched_group {
 	 * CPU power of this group, SCHED_LOAD_SCALE being max power for a
 	 * single CPU.
 	 */
-	unsigned int cpu_power;
+	unsigned int cpu_power, cpu_power_orig;
 
 	/*
 	 * The CPUs this group covers.
@@ -1696,6 +1689,7 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
 #define PF_VCPU		0x00000010	/* I'm a virtual CPU */
+#define PF_WQ_WORKER	0x00000020	/* I'm a workqueue worker */
 #define PF_FORKNOEXEC	0x00000040	/* forked but didn't exec */
 #define PF_MCE_PROCESS  0x00000080      /* process policy on mce errors */
 #define PF_SUPERPRIV	0x00000100	/* used super-user privileges */
@@ -1790,20 +1784,23 @@ static inline int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
 #endif
 
 /*
- * Architectures can set this to 1 if they have specified
- * CONFIG_HAVE_UNSTABLE_SCHED_CLOCK in their arch Kconfig,
- * but then during bootup it turns out that sched_clock()
- * is reliable after all:
+ * Do not use outside of architecture code which knows its limitations.
+ *
+ * sched_clock() has no promise of monotonicity or bounded drift between
+ * CPUs, use (which you should not) requires disabling IRQs.
+ *
+ * Please use one of the three interfaces below.
  */
-#ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
-extern int sched_clock_stable;
-#endif
-
-/* ftrace calls sched_clock() directly */
 extern unsigned long long notrace sched_clock(void);
+/*
+ * See the comment in kernel/sched_clock.c
+ */
+extern u64 cpu_clock(int cpu);
+extern u64 local_clock(void);
+extern u64 sched_clock_cpu(int cpu);
+
 
 extern void sched_clock_init(void);
-extern u64 sched_clock_cpu(int cpu);
 
 #ifndef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
 static inline void sched_clock_tick(void)
@@ -1818,17 +1815,19 @@ static inline void sched_clock_idle_wakeup_event(u64 delta_ns)
 {
 }
 #else
+/*
+ * Architectures can set this to 1 if they have specified
+ * CONFIG_HAVE_UNSTABLE_SCHED_CLOCK in their arch Kconfig,
+ * but then during bootup it turns out that sched_clock()
+ * is reliable after all:
+ */
+extern int sched_clock_stable;
+
 extern void sched_clock_tick(void);
 extern void sched_clock_idle_sleep_event(void);
 extern void sched_clock_idle_wakeup_event(u64 delta_ns);
 #endif
 
-/*
- * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
- * clock constructed from sched_clock():
- */
-extern unsigned long long cpu_clock(int cpu);
-
 extern unsigned long long
 task_sched_runtime(struct task_struct *task);
 extern unsigned long long thread_group_sched_runtime(struct task_struct *task);
diff --git a/include/linux/topology.h b/include/linux/topology.h
index c44df50..b572e43 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -103,6 +103,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
 				| 0*SD_PREFER_SIBLING			\
+				| arch_sd_sibling_asym_packing()	\
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 97d1b42..f6e726f 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -235,11 +235,8 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 		return -EINVAL;
 
 	cpu_hotplug_begin();
-	set_cpu_active(cpu, false);
 	err = __cpu_notify(CPU_DOWN_PREPARE | mod, hcpu, -1, &nr_calls);
 	if (err) {
-		set_cpu_active(cpu, true);
-
 		nr_calls--;
 		__cpu_notify(CPU_DOWN_FAILED | mod, hcpu, nr_calls, NULL);
 		printk("%s: attempt to take down CPU %u failed\n",
@@ -249,7 +246,6 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 
 	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
 	if (err) {
-		set_cpu_active(cpu, true);
 		/* CPU didn't die: tell everyone.  Can't complain. */
 		cpu_notify_nofail(CPU_DOWN_FAILED | mod, hcpu);
 
@@ -321,8 +317,6 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 		goto out_notify;
 	BUG_ON(!cpu_online(cpu));
 
-	set_cpu_active(cpu, true);
-
 	/* Now call notifier in preparation. */
 	cpu_notify(CPU_ONLINE | mod, hcpu);
 
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 02b9611..7146793 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2113,31 +2113,17 @@ static void scan_for_empty_cpusets(struct cpuset *root)
  * but making no active use of cpusets.
  *
  * This routine ensures that top_cpuset.cpus_allowed tracks
- * cpu_online_map on each CPU hotplug (cpuhp) event.
+ * cpu_active_mask on each CPU hotplug (cpuhp) event.
  *
  * Called within get_online_cpus().  Needs to call cgroup_lock()
  * before calling generate_sched_domains().
  */
-static int cpuset_track_online_cpus(struct notifier_block *unused_nb,
-				unsigned long phase, void *unused_cpu)
+void cpuset_update_active_cpus(void)
 {
 	struct sched_domain_attr *attr;
 	cpumask_var_t *doms;
 	int ndoms;
 
-	switch (phase) {
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
-	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
-		break;
-
-	default:
-		return NOTIFY_DONE;
-	}
-
 	cgroup_lock();
 	mutex_lock(&callback_mutex);
 	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
@@ -2148,8 +2134,6 @@ static int cpuset_track_online_cpus(struct notifier_block *unused_nb,
 
 	/* Have scheduler rebuild the domains */
 	partition_sched_domains(ndoms, doms, attr);
-
-	return NOTIFY_OK;
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
@@ -2203,7 +2187,6 @@ void __init cpuset_init_smp(void)
 	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
 	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
 
-	hotcpu_notifier(cpuset_track_online_cpus, 0);
 	hotplug_memory_notifier(cpuset_track_online_nodes, 10);
 
 	cpuset_wq = create_singlethread_workqueue("cpuset");
diff --git a/kernel/fork.c b/kernel/fork.c
index b6cce14..a82a65c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -907,7 +907,7 @@ static void copy_flags(unsigned long clone_flags, struct task_struct *p)
 {
 	unsigned long new_flags = p->flags;
 
-	new_flags &= ~PF_SUPERPRIV;
+	new_flags &= ~(PF_SUPERPRIV | PF_WQ_WORKER);
 	new_flags |= PF_FORKNOEXEC;
 	new_flags |= PF_STARTING;
 	p->flags = new_flags;
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 5c69e99..e934339 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -144,12 +144,8 @@ struct hrtimer_clock_base *lock_hrtimer_base(const struct hrtimer *timer,
 static int hrtimer_get_target(int this_cpu, int pinned)
 {
 #ifdef CONFIG_NO_HZ
-	if (!pinned && get_sysctl_timer_migration() && idle_cpu(this_cpu)) {
-		int preferred_cpu = get_nohz_load_balancer();
-
-		if (preferred_cpu >= 0)
-			return preferred_cpu;
-	}
+	if (!pinned && get_sysctl_timer_migration() && idle_cpu(this_cpu))
+		return get_nohz_timer_target();
 #endif
 	return this_cpu;
 }
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 5428679..f2852a5 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -146,7 +146,7 @@ static DEFINE_PER_CPU(struct lock_class_stats[MAX_LOCKDEP_KEYS],
 
 static inline u64 lockstat_clock(void)
 {
-	return cpu_clock(smp_processor_id());
+	return local_clock();
 }
 
 static int lock_point(unsigned long points[], unsigned long ip)
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index ff86c55..7e32b51 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -214,7 +214,7 @@ static void perf_unpin_context(struct perf_event_context *ctx)
 
 static inline u64 perf_clock(void)
 {
-	return cpu_clock(raw_smp_processor_id());
+	return local_clock();
 }
 
 /*
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 9829646..f66bdd3 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -232,31 +232,24 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
 
 void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 {
-	struct sighand_struct *sighand;
-	struct signal_struct *sig;
+	struct signal_struct *sig = tsk->signal;
 	struct task_struct *t;
 
-	*times = INIT_CPUTIME;
+	times->utime = sig->utime;
+	times->stime = sig->stime;
+	times->sum_exec_runtime = sig->sum_sched_runtime;
 
 	rcu_read_lock();
-	sighand = rcu_dereference(tsk->sighand);
-	if (!sighand)
+	/* make sure we can trust tsk->thread_group list */
+	if (!likely(pid_alive(tsk)))
 		goto out;
 
-	sig = tsk->signal;
-
 	t = tsk;
 	do {
 		times->utime = cputime_add(times->utime, t->utime);
 		times->stime = cputime_add(times->stime, t->stime);
 		times->sum_exec_runtime += t->se.sum_exec_runtime;
-
-		t = next_thread(t);
-	} while (t != tsk);
-
-	times->utime = cputime_add(times->utime, sig->utime);
-	times->stime = cputime_add(times->stime, sig->stime);
-	times->sum_exec_runtime += sig->sum_sched_runtime;
+	} while_each_thread(tsk, t);
 out:
 	rcu_read_unlock();
 }
@@ -1279,10 +1272,6 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
 {
 	struct signal_struct *sig;
 
-	/* tsk == current, ensure it is safe to use ->signal/sighand */
-	if (unlikely(tsk->exit_state))
-		return 0;
-
 	if (!task_cputime_zero(&tsk->cputime_expires)) {
 		struct task_cputime task_sample = {
 			.utime = tsk->utime,
@@ -1298,7 +1287,10 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
 	if (sig->cputimer.running) {
 		struct task_cputime group_sample;
 
-		thread_group_cputimer(tsk, &group_sample);
+		spin_lock(&sig->cputimer.lock);
+		group_sample = sig->cputimer.cputime;
+		spin_unlock(&sig->cputimer.lock);
+
 		if (task_cputime_expired(&group_sample, &sig->cputime_expires))
 			return 1;
 	}
@@ -1315,6 +1307,7 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 {
 	LIST_HEAD(firing);
 	struct k_itimer *timer, *next;
+	unsigned long flags;
 
 	BUG_ON(!irqs_disabled());
 
@@ -1325,7 +1318,8 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 	if (!fastpath_timer_check(tsk))
 		return;
 
-	spin_lock(&tsk->sighand->siglock);
+	if (!lock_task_sighand(tsk, &flags))
+		return;
 	/*
 	 * Here we take off tsk->signal->cpu_timers[N] and
 	 * tsk->cpu_timers[N] all the timers that are firing, and
@@ -1347,7 +1341,7 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 	 * that gets the timer lock before we do will give it up and
 	 * spin until we've taken care of that timer below.
 	 */
-	spin_unlock(&tsk->sighand->siglock);
+	unlock_task_sighand(tsk, &flags);
 
 	/*
 	 * Now that all the timers on our list have the firing flag,
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 6535ac8..2e2726d 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -239,8 +239,7 @@ static unsigned long
 rcu_random(struct rcu_random_state *rrsp)
 {
 	if (--rrsp->rrs_count < 0) {
-		rrsp->rrs_state +=
-			(unsigned long)cpu_clock(raw_smp_processor_id());
+		rrsp->rrs_state += (unsigned long)local_clock();
 		rrsp->rrs_count = RCU_RANDOM_REFRESH;
 	}
 	rrsp->rrs_state = rrsp->rrs_state * RCU_RANDOM_MULT + RCU_RANDOM_ADD;
diff --git a/kernel/sched.c b/kernel/sched.c
index f52a880..f6c9bb6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -77,6 +77,7 @@
 #include <asm/irq_regs.h>
 
 #include "sched_cpupri.h"
+#include "workqueue_sched.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/sched.h>
@@ -456,9 +457,10 @@ struct rq {
 	unsigned long nr_running;
 	#define CPU_LOAD_IDX_MAX 5
 	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
+	unsigned long last_load_update_tick;
 #ifdef CONFIG_NO_HZ
 	u64 nohz_stamp;
-	unsigned char in_nohz_recently;
+	unsigned char nohz_balance_kick;
 #endif
 	unsigned int skip_clock_update;
 
@@ -1193,6 +1195,27 @@ static void resched_cpu(int cpu)
 
 #ifdef CONFIG_NO_HZ
 /*
+ * In the semi idle case, use the nearest busy cpu for migrating timers
+ * from an idle cpu.  This is good for power-savings.
+ *
+ * We don't do similar optimization for completely idle system, as
+ * selecting an idle cpu will add more delays to the timers than intended
+ * (as that cpu's timer base may not be uptodate wrt jiffies etc).
+ */
+int get_nohz_timer_target(void)
+{
+	int cpu = smp_processor_id();
+	int i;
+	struct sched_domain *sd;
+
+	for_each_domain(cpu, sd) {
+		for_each_cpu(i, sched_domain_span(sd))
+			if (!idle_cpu(i))
+				return i;
+	}
+	return cpu;
+}
+/*
  * When add_timer_on() enqueues a timer into the timer wheel of an
  * idle CPU then this timer might expire before the next timer event
  * which is scheduled to wake up that CPU. In case of a completely
@@ -1232,16 +1255,6 @@ void wake_up_idle_cpu(int cpu)
 		smp_send_reschedule(cpu);
 }
 
-int nohz_ratelimit(int cpu)
-{
-	struct rq *rq = cpu_rq(cpu);
-	u64 diff = rq->clock - rq->nohz_stamp;
-
-	rq->nohz_stamp = rq->clock;
-
-	return diff < (NSEC_PER_SEC / HZ) >> 1;
-}
-
 #endif /* CONFIG_NO_HZ */
 
 static u64 sched_avg_period(void)
@@ -1652,7 +1665,7 @@ static void update_shares(struct sched_domain *sd)
 	if (root_task_group_empty())
 		return;
 
-	now = cpu_clock(raw_smp_processor_id());
+	now = local_clock();
 	elapsed = now - sd->last_update;
 
 	if (elapsed >= (s64)(u64)sysctl_sched_shares_ratelimit) {
@@ -1805,6 +1818,7 @@ static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
 static void calc_load_account_idle(struct rq *this_rq);
 static void update_sysctl(void);
 static int get_update_sysctl_factor(void);
+static void update_cpu_load(struct rq *this_rq);
 
 static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 {
@@ -2267,11 +2281,55 @@ static void update_avg(u64 *avg, u64 sample)
 }
 #endif
 
-/***
+static inline void ttwu_activate(struct task_struct *p, struct rq *rq,
+				 bool is_sync, bool is_migrate, bool is_local,
+				 unsigned long en_flags)
+{
+	schedstat_inc(p, se.statistics.nr_wakeups);
+	if (is_sync)
+		schedstat_inc(p, se.statistics.nr_wakeups_sync);
+	if (is_migrate)
+		schedstat_inc(p, se.statistics.nr_wakeups_migrate);
+	if (is_local)
+		schedstat_inc(p, se.statistics.nr_wakeups_local);
+	else
+		schedstat_inc(p, se.statistics.nr_wakeups_remote);
+
+	activate_task(rq, p, en_flags);
+}
+
+static inline void ttwu_post_activation(struct task_struct *p, struct rq *rq,
+					int wake_flags, bool success)
+{
+	trace_sched_wakeup(p, success);
+	check_preempt_curr(rq, p, wake_flags);
+
+	p->state = TASK_RUNNING;
+#ifdef CONFIG_SMP
+	if (p->sched_class->task_woken)
+		p->sched_class->task_woken(rq, p);
+
+	if (unlikely(rq->idle_stamp)) {
+		u64 delta = rq->clock - rq->idle_stamp;
+		u64 max = 2*sysctl_sched_migration_cost;
+
+		if (delta > max)
+			rq->avg_idle = max;
+		else
+			update_avg(&rq->avg_idle, delta);
+		rq->idle_stamp = 0;
+	}
+#endif
+	/* if a worker is waking up, notify workqueue */
+	if ((p->flags & PF_WQ_WORKER) && success)
+		wq_worker_waking_up(p, cpu_of(rq));
+}
+
+/**
  * try_to_wake_up - wake up a thread
- * @p: the to-be-woken-up thread
+ * @p: the thread to be awakened
  * @state: the mask of task states that can be woken
- * @sync: do a synchronous wakeup?
+ * @wake_flags: wake modifier flags (WF_*)
  *
  * Put it on the run-queue if it's not already there. The "current"
  * thread is always on the run-queue (except when the actual
@@ -2279,7 +2337,8 @@ static void update_avg(u64 *avg, u64 sample)
  * the simpler "current->state = TASK_RUNNING" to mark yourself
  * runnable without the overhead of this.
  *
- * returns failure only if the task is already active.
+ * Returns %true if @p was woken up, %false if it was already running
+ * or @state didn't match @p's state.
  */
 static int try_to_wake_up(struct task_struct *p, unsigned int state,
 			  int wake_flags)
@@ -2359,38 +2418,11 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 
 out_activate:
 #endif /* CONFIG_SMP */
-	schedstat_inc(p, se.statistics.nr_wakeups);
-	if (wake_flags & WF_SYNC)
-		schedstat_inc(p, se.statistics.nr_wakeups_sync);
-	if (orig_cpu != cpu)
-		schedstat_inc(p, se.statistics.nr_wakeups_migrate);
-	if (cpu == this_cpu)
-		schedstat_inc(p, se.statistics.nr_wakeups_local);
-	else
-		schedstat_inc(p, se.statistics.nr_wakeups_remote);
-	activate_task(rq, p, en_flags);
+	ttwu_activate(p, rq, wake_flags & WF_SYNC, orig_cpu != cpu,
+		      cpu == this_cpu, en_flags);
 	success = 1;
-
 out_running:
-	trace_sched_wakeup(p, success);
-	check_preempt_curr(rq, p, wake_flags);
-
-	p->state = TASK_RUNNING;
-#ifdef CONFIG_SMP
-	if (p->sched_class->task_woken)
-		p->sched_class->task_woken(rq, p);
-
-	if (unlikely(rq->idle_stamp)) {
-		u64 delta = rq->clock - rq->idle_stamp;
-		u64 max = 2*sysctl_sched_migration_cost;
-
-		if (delta > max)
-			rq->avg_idle = max;
-		else
-			update_avg(&rq->avg_idle, delta);
-		rq->idle_stamp = 0;
-	}
-#endif
+	ttwu_post_activation(p, rq, wake_flags, success);
 out:
 	task_rq_unlock(rq, &flags);
 	put_cpu();
@@ -2399,6 +2431,37 @@ out:
 }
 
 /**
+ * try_to_wake_up_local - try to wake up a local task with rq lock held
+ * @p: the thread to be awakened
+ *
+ * Put @p on the run-queue if it's not alredy there.  The caller must
+ * ensure that this_rq() is locked, @p is bound to this_rq() and not
+ * the current task.  this_rq() stays locked over invocation.
+ */
+static void try_to_wake_up_local(struct task_struct *p)
+{
+	struct rq *rq = task_rq(p);
+	bool success = false;
+
+	BUG_ON(rq != this_rq());
+	BUG_ON(p == current);
+	lockdep_assert_held(&rq->lock);
+
+	if (!(p->state & TASK_NORMAL))
+		return;
+
+	if (!p->se.on_rq) {
+		if (likely(!task_running(rq, p))) {
+			schedstat_inc(rq, ttwu_count);
+			schedstat_inc(rq, ttwu_local);
+		}
+		ttwu_activate(p, rq, false, false, true, ENQUEUE_WAKEUP);
+		success = true;
+	}
+	ttwu_post_activation(p, rq, 0, success);
+}
+
+/**
  * wake_up_process - Wake up a specific process
  * @p: The process to be woken up.
  *
@@ -3012,23 +3075,102 @@ static void calc_load_account_active(struct rq *this_rq)
 }
 
 /*
+ * The exact cpuload at various idx values, calculated at every tick would be
+ * load = (2^idx - 1) / 2^idx * load + 1 / 2^idx * cur_load
+ *
+ * If a cpu misses updates for n-1 ticks (as it was idle) and update gets called
+ * on nth tick when cpu may be busy, then we have:
+ * load = ((2^idx - 1) / 2^idx)^(n-1) * load
+ * load = (2^idx - 1) / 2^idx) * load + 1 / 2^idx * cur_load
+ *
+ * decay_load_missed() below does efficient calculation of
+ * load = ((2^idx - 1) / 2^idx)^(n-1) * load
+ * avoiding 0..n-1 loop doing load = ((2^idx - 1) / 2^idx) * load
+ *
+ * The calculation is approximated on a 128 point scale.
+ * degrade_zero_ticks is the number of ticks after which load at any
+ * particular idx is approximated to be zero.
+ * degrade_factor is a precomputed table, a row for each load idx.
+ * Each column corresponds to degradation factor for a power of two ticks,
+ * based on 128 point scale.
+ * Example:
+ * row 2, col 3 (=12) says that the degradation at load idx 2 after
+ * 8 ticks is 12/128 (which is an approximation of exact factor 3^8/4^8).
+ *
+ * With this power of 2 load factors, we can degrade the load n times
+ * by looking at 1 bits in n and doing as many mult/shift instead of
+ * n mult/shifts needed by the exact degradation.
+ */
+#define DEGRADE_SHIFT		7
+static const unsigned char
+		degrade_zero_ticks[CPU_LOAD_IDX_MAX] = {0, 8, 32, 64, 128};
+static const unsigned char
+		degrade_factor[CPU_LOAD_IDX_MAX][DEGRADE_SHIFT + 1] = {
+					{0, 0, 0, 0, 0, 0, 0, 0},
+					{64, 32, 8, 0, 0, 0, 0, 0},
+					{96, 72, 40, 12, 1, 0, 0},
+					{112, 98, 75, 43, 15, 1, 0},
+					{120, 112, 98, 76, 45, 16, 2} };
+
+/*
+ * Update cpu_load for any missed ticks, due to tickless idle. The backlog
+ * would be when CPU is idle and so we just decay the old load without
+ * adding any new load.
+ */
+static unsigned long
+decay_load_missed(unsigned long load, unsigned long missed_updates, int idx)
+{
+	int j = 0;
+
+	if (!missed_updates)
+		return load;
+
+	if (missed_updates >= degrade_zero_ticks[idx])
+		return 0;
+
+	if (idx == 1)
+		return load >> missed_updates;
+
+	while (missed_updates) {
+		if (missed_updates % 2)
+			load = (load * degrade_factor[idx][j]) >> DEGRADE_SHIFT;
+
+		missed_updates >>= 1;
+		j++;
+	}
+	return load;
+}
+
+/*
  * Update rq->cpu_load[] statistics. This function is usually called every
- * scheduler tick (TICK_NSEC).
+ * scheduler tick (TICK_NSEC). With tickless idle this will not be called
+ * every tick. We fix it up based on jiffies.
  */
 static void update_cpu_load(struct rq *this_rq)
 {
 	unsigned long this_load = this_rq->load.weight;
+	unsigned long curr_jiffies = jiffies;
+	unsigned long pending_updates;
 	int i, scale;
 
 	this_rq->nr_load_updates++;
 
+	/* Avoid repeated calls on same jiffy, when moving in and out of idle */
+	if (curr_jiffies == this_rq->last_load_update_tick)
+		return;
+
+	pending_updates = curr_jiffies - this_rq->last_load_update_tick;
+	this_rq->last_load_update_tick = curr_jiffies;
+
 	/* Update our load: */
-	for (i = 0, scale = 1; i < CPU_LOAD_IDX_MAX; i++, scale += scale) {
+	this_rq->cpu_load[0] = this_load; /* Fasttrack for idx 0 */
+	for (i = 1, scale = 2; i < CPU_LOAD_IDX_MAX; i++, scale += scale) {
 		unsigned long old_load, new_load;
 
 		/* scale is effectively 1 << i now, and >> i divides by scale */
 
 		old_load = this_rq->cpu_load[i];
+		old_load = decay_load_missed(old_load, pending_updates - 1, i);
 		new_load = this_load;
 		/*
 		 * Round up the averaging division if load is increasing. This
@@ -3036,9 +3178,15 @@ static void update_cpu_load(struct rq *this_rq)
 		 * example.
 		 */
 		if (new_load > old_load)
-			new_load += scale-1;
-		this_rq->cpu_load[i] = (old_load*(scale-1) + new_load) >> i;
+			new_load += scale - 1;
+
+		this_rq->cpu_load[i] = (old_load * (scale - 1) + new_load) >> i;
 	}
+}
+
+static void update_cpu_load_active(struct rq *this_rq)
+{
+	update_cpu_load(this_rq);
 
 	calc_load_account_active(this_rq);
 }
@@ -3426,7 +3574,7 @@ void scheduler_tick(void)
 
 	raw_spin_lock(&rq->lock);
 	update_rq_clock(rq);
-	update_cpu_load(rq);
+	update_cpu_load_active(rq);
 	curr->sched_class->task_tick(rq, curr, 0);
 	raw_spin_unlock(&rq->lock);
 
@@ -3598,7 +3746,6 @@ need_resched:
 	rq = cpu_rq(cpu);
 	rcu_note_context_switch(cpu);
 	prev = rq->curr;
-	switch_count = &prev->nivcsw;
 
 	release_kernel_lock(prev);
 need_resched_nonpreemptible:
@@ -3611,11 +3758,26 @@ need_resched_nonpreemptible:
 	raw_spin_lock_irq(&rq->lock);
 	clear_tsk_need_resched(prev);
 
+	switch_count = &prev->nivcsw;
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
-		if (unlikely(signal_pending_state(prev->state, prev)))
+		if (unlikely(signal_pending_state(prev->state, prev))) {
 			prev->state = TASK_RUNNING;
-		else
+		} else {
+			/*
+			 * If a worker is going to sleep, notify and
+			 * ask workqueue whether it wants to wake up a
+			 * task to maintain concurrency.  If so, wake
+			 * up the task.
+			 */
+			if (prev->flags & PF_WQ_WORKER) {
+				struct task_struct *to_wakeup;
+
+				to_wakeup = wq_worker_sleeping(prev, cpu);
+				if (to_wakeup)
+					try_to_wake_up_local(to_wakeup);
+			}
 			deactivate_task(rq, prev, DEQUEUE_SLEEP);
+		}
 		switch_count = &prev->nvcsw;
 	}
 
@@ -3637,8 +3799,10 @@ need_resched_nonpreemptible:
 
 		context_switch(rq, prev, next); /* unlocks the rq */
 		/*
-		 * the context switch might have flipped the stack from under
-		 * us, hence refresh the local variables.
+		 * The context switch have flipped the stack from under us
+		 * and restored the local variables which were saved when
+		 * this task called schedule() in the past. prev == current
+		 * is still correct, but it can be moved to another cpu/rq.
 		 */
 		cpu = smp_processor_id();
 		rq = cpu_rq(cpu);
@@ -3647,11 +3811,8 @@ need_resched_nonpreemptible:
 
 	post_schedule(rq);
 
-	if (unlikely(reacquire_kernel_lock(current) < 0)) {
-		prev = rq->curr;
-		switch_count = &prev->nivcsw;
+	if (unlikely(reacquire_kernel_lock(prev)))
 		goto need_resched_nonpreemptible;
-	}
 
 	preempt_enable_no_resched();
 	if (need_resched())
@@ -4441,12 +4602,8 @@ recheck:
 	 */
 	if (user && !capable(CAP_SYS_NICE)) {
 		if (rt_policy(policy)) {
-			unsigned long rlim_rtprio;
-
-			if (!lock_task_sighand(p, &flags))
-				return -ESRCH;
-			rlim_rtprio = task_rlimit(p, RLIMIT_RTPRIO);
-			unlock_task_sighand(p, &flags);
+			unsigned long rlim_rtprio =
+					task_rlimit(p, RLIMIT_RTPRIO);
 
 			/* can't set/change the rt policy */
 			if (policy != p->policy && !rlim_rtprio)
@@ -5816,20 +5973,49 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
  */
 static struct notifier_block __cpuinitdata migration_notifier = {
 	.notifier_call = migration_call,
-	.priority = 10
+	.priority = CPU_PRI_MIGRATION,
 };
 
+static int __cpuinit sched_cpu_active(struct notifier_block *nfb,
+				      unsigned long action, void *hcpu)
+{
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_ONLINE:
+	case CPU_DOWN_FAILED:
+		set_cpu_active((long)hcpu, true);
+		return NOTIFY_OK;
+	default:
+		return NOTIFY_DONE;
+	}
+}
+
+static int __cpuinit sched_cpu_inactive(struct notifier_block *nfb,
+					unsigned long action, void *hcpu)
+{
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_DOWN_PREPARE:
+		set_cpu_active((long)hcpu, false);
+		return NOTIFY_OK;
+	default:
+		return NOTIFY_DONE;
+	}
+}
+
 static int __init migration_init(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
 	int err;
 
-	/* Start one for the boot CPU: */
+	/* Initialize migration for the boot CPU */
 	err = migration_call(&migration_notifier, CPU_UP_PREPARE, cpu);
 	BUG_ON(err == NOTIFY_BAD);
 	migration_call(&migration_notifier, CPU_ONLINE, cpu);
 	register_cpu_notifier(&migration_notifier);
 
+	/* Register cpu active notifiers */
+	cpu_notifier(sched_cpu_active, CPU_PRI_SCHED_ACTIVE);
+	cpu_notifier(sched_cpu_inactive, CPU_PRI_SCHED_INACTIVE);
+
 	return 0;
 }
 early_initcall(migration_init);
@@ -6064,23 +6250,18 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 		free_rootdomain(old_rd);
 }
 
-static int init_rootdomain(struct root_domain *rd, bool bootmem)
+static int init_rootdomain(struct root_domain *rd)
 {
-	gfp_t gfp = GFP_KERNEL;
-
 	memset(rd, 0, sizeof(*rd));
 
-	if (bootmem)
-		gfp = GFP_NOWAIT;
-
-	if (!alloc_cpumask_var(&rd->span, gfp))
+	if (!alloc_cpumask_var(&rd->span, GFP_KERNEL))
 		goto out;
-	if (!alloc_cpumask_var(&rd->online, gfp))
+	if (!alloc_cpumask_var(&rd->online, GFP_KERNEL))
 		goto free_span;
-	if (!alloc_cpumask_var(&rd->rto_mask, gfp))
+	if (!alloc_cpumask_var(&rd->rto_mask, GFP_KERNEL))
 		goto free_online;
 
-	if (cpupri_init(&rd->cpupri, bootmem) != 0)
+	if (cpupri_init(&rd->cpupri) != 0)
 		goto free_rto_mask;
 	return 0;
 
@@ -6096,7 +6277,7 @@ out:
 
 static void init_defrootdomain(void)
 {
-	init_rootdomain(&def_root_domain, true);
+	init_rootdomain(&def_root_domain);
 
 	atomic_set(&def_root_domain.refcount, 1);
 }
@@ -6109,7 +6290,7 @@ static struct root_domain *alloc_rootdomain(void)
 	if (!rd)
 		return NULL;
 
-	if (init_rootdomain(rd, false) != 0) {
+	if (init_rootdomain(rd) != 0) {
 		kfree(rd);
 		return NULL;
 	}
@@ -7288,29 +7469,35 @@ int __init sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
 }
 #endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
 
-#ifndef CONFIG_CPUSETS
 /*
- * Add online and remove offline CPUs from the scheduler domains.
- * When cpusets are enabled they take over this function.
+ * Update cpusets according to cpu_active mask.  If cpusets are
+ * disabled, cpuset_update_active_cpus() becomes a simple wrapper
+ * around partition_sched_domains().
  */
-static int update_sched_domains(struct notifier_block *nfb,
-				unsigned long action, void *hcpu)
+static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
+			     void *hcpu)
 {
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
 	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
-		partition_sched_domains(1, NULL, NULL);
+		cpuset_update_active_cpus();
 		return NOTIFY_OK;
+	default:
+		return NOTIFY_DONE;
+	}
+}
 
+static int cpuset_cpu_inactive(struct notifier_block *nfb, unsigned long action,
+			       void *hcpu)
+{
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_DOWN_PREPARE:
+		cpuset_update_active_cpus();
+		return NOTIFY_OK;
 	default:
 		return NOTIFY_DONE;
 	}
 }
-#endif
 
 static int update_runtime(struct notifier_block *nfb,
 				unsigned long action, void *hcpu)
@@ -7356,10 +7543,8 @@ void __init sched_init_smp(void)
 	mutex_unlock(&sched_domains_mutex);
 	put_online_cpus();
 
-#ifndef CONFIG_CPUSETS
-	/* XXX: Theoretical race here - CPU may be hotplugged now */
-	hotcpu_notifier(update_sched_domains, 0);
-#endif
+	hotcpu_notifier(cpuset_cpu_active, CPU_PRI_CPUSET_ACTIVE);
+	hotcpu_notifier(cpuset_cpu_inactive, CPU_PRI_CPUSET_INACTIVE);
 
 	/* RT runtime code needs to handle some hotplug events */
 	hotcpu_notifier(update_runtime, 0);
@@ -7604,6 +7789,9 @@ void __init sched_init(void)
 
 		for (j = 0; j < CPU_LOAD_IDX_MAX; j++)
 			rq->cpu_load[j] = 0;
+
+		rq->last_load_update_tick = jiffies;
+
 #ifdef CONFIG_SMP
 		rq->sd = NULL;
 		rq->rd = NULL;
@@ -7617,6 +7805,10 @@ void __init sched_init(void)
 		rq->idle_stamp = 0;
 		rq->avg_idle = 2*sysctl_sched_migration_cost;
 		rq_attach_root(rq, &def_root_domain);
+#ifdef CONFIG_NO_HZ
+		rq->nohz_balance_kick = 0;
+		init_sched_softirq_csd(&per_cpu(remote_sched_softirq_cb, i));
+#endif
 #endif
 		init_rq_hrtick(rq);
 		atomic_set(&rq->nr_iowait, 0);
@@ -7661,8 +7853,11 @@ void __init sched_init(void)
 	zalloc_cpumask_var(&nohz_cpu_mask, GFP_NOWAIT);
 #ifdef CONFIG_SMP
 #ifdef CONFIG_NO_HZ
-	zalloc_cpumask_var(&nohz.cpu_mask, GFP_NOWAIT);
-	alloc_cpumask_var(&nohz.ilb_grp_nohz_mask, GFP_NOWAIT);
+	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
+	alloc_cpumask_var(&nohz.grp_idle_mask, GFP_NOWAIT);
+	atomic_set(&nohz.load_balancer, nr_cpu_ids);
+	atomic_set(&nohz.first_pick_cpu, nr_cpu_ids);
+	atomic_set(&nohz.second_pick_cpu, nr_cpu_ids);
 #endif
 	/* May be allocated at isolcpus cmdline parse time */
 	if (cpu_isolated_map == NULL)
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index 906a0f7..52f1a14 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -10,19 +10,55 @@
  *   Ingo Molnar <mingo@redhat.com>
  *   Guillaume Chazarain <guichaz@gmail.com>
  *
- * Create a semi stable clock from a mixture of other events, including:
- *  - gtod
+ *
+ * What:
+ *
+ * cpu_clock(i) provides a fast (execution time) high resolution
+ * clock with bounded drift between CPUs. The value of cpu_clock(i)
+ * is monotonic for constant i. The timestamp returned is in nanoseconds.
+ *
+ * ######################### BIG FAT WARNING ##########################
+ * # when comparing cpu_clock(i) to cpu_clock(j) for i != j, time can #
+ * # go backwards !!                                                  #
+ * ####################################################################
+ *
+ * There is no strict promise about the base, although it tends to start
+ * at 0 on boot (but people really shouldn't rely on that).
+ *
+ * cpu_clock(i)       -- can be used from any context, including NMI.
+ * sched_clock_cpu(i) -- must be used with local IRQs disabled (implied by NMI)
+ * local_clock()      -- is cpu_clock() on the current cpu.
+ *
+ * How:
+ *
+ * The implementation either uses sched_clock() when
+ * !CONFIG_HAVE_UNSTABLE_SCHED_CLOCK, which means in that case the
+ * sched_clock() is assumed to provide these properties (mostly it means
+ * the architecture provides a globally synchronized highres time source).
+ *
+ * Otherwise it tries to create a semi stable clock from a mixture of other
+ * clocks, including:
+ *
+ *  - GTOD (clock monotomic)
  *  - sched_clock()
  *  - explicit idle events
  *
- * We use gtod as base and the unstable clock deltas. The deltas are filtered,
- * making it monotonic and keeping it within an expected window.
+ * We use GTOD as base and use sched_clock() deltas to improve resolution. The
+ * deltas are filtered to provide monotonicity and keeping it within an
+ * expected window.
  *
  * Furthermore, explicit sleep and wakeup hooks allow us to account for time
  * that is otherwise invisible (TSC gets stopped).
  *
- * The clock: sched_clock_cpu() is monotonic per cpu, and should be somewhat
- * consistent between cpus (never more than 2 jiffies difference).
+ *
+ * Notes:
+ *
+ * The !IRQ-safetly of sched_clock() and sched_clock_cpu() comes from things
+ * like cpufreq interrupts that can change the base clock (TSC) multiplier
+ * and cause funny jumps in time -- although the filtering provided by
+ * sched_clock_cpu() should mitigate serious artifacts we cannot rely on it
+ * in general since for !CONFIG_HAVE_UNSTABLE_SCHED_CLOCK we fully rely on
+ * sched_clock().
  */
 #include <linux/spinlock.h>
 #include <linux/hardirq.h>
@@ -170,6 +206,11 @@ again:
 	return val;
 }
 
+/*
+ * Similar to cpu_clock(), but requires local IRQs to be disabled.
+ *
+ * See cpu_clock().
+ */
 u64 sched_clock_cpu(int cpu)
 {
 	struct sched_clock_data *scd;
@@ -237,9 +278,19 @@ void sched_clock_idle_wakeup_event(u64 delta_ns)
 }
 EXPORT_SYMBOL_GPL(sched_clock_idle_wakeup_event);
 
-unsigned long long cpu_clock(int cpu)
+/*
+ * As outlined at the top, provides a fast, high resolution, nanosecond
+ * time source that is monotonic per cpu argument and has bounded drift
+ * between cpus.
+ *
+ * ######################### BIG FAT WARNING ##########################
+ * # when comparing cpu_clock(i) to cpu_clock(j) for i != j, time can #
+ * # go backwards !!                                                  #
+ * ####################################################################
+ */
+u64 cpu_clock(int cpu)
 {
-	unsigned long long clock;
+	u64 clock;
 	unsigned long flags;
 
 	local_irq_save(flags);
@@ -249,6 +300,25 @@ unsigned long long cpu_clock(int cpu)
 	return clock;
 }
 
+/*
+ * Similar to cpu_clock() for the current cpu. Time will only be observed
+ * to be monotonic if care is taken to only compare timestampt taken on the
+ * same CPU.
+ *
+ * See cpu_clock().
+ */
+u64 local_clock(void)
+{
+	u64 clock;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	clock = sched_clock_cpu(smp_processor_id());
+	local_irq_restore(flags);
+
+	return clock;
+}
+
 #else /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
 
 void sched_clock_init(void)
@@ -264,12 +334,17 @@ u64 sched_clock_cpu(int cpu)
 	return sched_clock();
 }
 
-
-unsigned long long cpu_clock(int cpu)
+u64 cpu_clock(int cpu)
 {
 	return sched_clock_cpu(cpu);
 }
 
+u64 local_clock(void)
+{
+	return sched_clock_cpu(0);
+}
+
 #endif /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
 
 EXPORT_SYMBOL_GPL(cpu_clock);
+EXPORT_SYMBOL_GPL(local_clock);
diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index e6871cb..2722dc1 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -166,14 +166,10 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
  *
  * Returns: -ENOMEM if memory fails.
  */
-int cpupri_init(struct cpupri *cp, bool bootmem)
+int cpupri_init(struct cpupri *cp)
 {
-	gfp_t gfp = GFP_KERNEL;
 	int i;
 
-	if (bootmem)
-		gfp = GFP_NOWAIT;
-
 	memset(cp, 0, sizeof(*cp));
 
 	for (i = 0; i < CPUPRI_NR_PRIORITIES; i++) {
@@ -181,7 +177,7 @@ int cpupri_init(struct cpupri *cp, bool bootmem)
 
 		raw_spin_lock_init(&vec->lock);
 		vec->count = 0;
-		if (!zalloc_cpumask_var(&vec->mask, gfp))
+		if (!zalloc_cpumask_var(&vec->mask, GFP_KERNEL))
 			goto cleanup;
 	}
 
diff --git a/kernel/sched_cpupri.h b/kernel/sched_cpupri.h
index 7cb5bb6..9fc7d38 100644
--- a/kernel/sched_cpupri.h
+++ b/kernel/sched_cpupri.h
@@ -27,7 +27,7 @@ struct cpupri {
 int  cpupri_find(struct cpupri *cp,
 		 struct task_struct *p, struct cpumask *lowest_mask);
 void cpupri_set(struct cpupri *cp, int cpu, int pri);
-int cpupri_init(struct cpupri *cp, bool bootmem);
+int cpupri_init(struct cpupri *cp);
 void cpupri_cleanup(struct cpupri *cp);
 #else
 #define cpupri_set(cp, cpu, pri) do { } while (0)
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 3556539..2e1b0d1 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -332,7 +332,7 @@ static int sched_debug_show(struct seq_file *m, void *v)
 	PN(sysctl_sched_latency);
 	PN(sysctl_sched_min_granularity);
 	PN(sysctl_sched_wakeup_granularity);
-	PN(sysctl_sched_child_runs_first);
+	P(sysctl_sched_child_runs_first);
 	P(sysctl_sched_features);
 #undef PN
 #undef P
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a878b53..806d1b2 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2287,13 +2287,6 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 	unsigned long power = SCHED_LOAD_SCALE;
 	struct sched_group *sdg = sd->groups;
 
-	if (sched_feat(ARCH_POWER))
-		power *= arch_scale_freq_power(sd, cpu);
-	else
-		power *= default_scale_freq_power(sd, cpu);
-
-	power >>= SCHED_LOAD_SHIFT;
-
 	if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
 		if (sched_feat(ARCH_POWER))
 			power *= arch_scale_smt_power(sd, cpu);
@@ -2303,6 +2296,15 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 		power >>= SCHED_LOAD_SHIFT;
 	}
 
+	sdg->cpu_power_orig = power;
+
+	if (sched_feat(ARCH_POWER))
+		power *= arch_scale_freq_power(sd, cpu);
+	else
+		power *= default_scale_freq_power(sd, cpu);
+
+	power >>= SCHED_LOAD_SHIFT;
+
 	power *= scale_rt_power(cpu);
 	power >>= SCHED_LOAD_SHIFT;
 
@@ -2335,6 +2337,31 @@ static void update_group_power(struct sched_domain *sd, int cpu)
 	sdg->cpu_power = power;
 }
 
+/*
+ * Try and fix up capacity for tiny siblings, this is needed when
+ * things like SD_ASYM_PACKING need f_b_g to select another sibling
+ * which on its own isn't powerful enough.
+ *
+ * See update_sd_pick_busiest() and check_asym_packing().
+ */
+static inline int
+fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
+{
+	/*
+	 * Only siblings can have significantly less than SCHED_LOAD_SCALE
+	 */
+	if (sd->level != SD_LV_SIBLING)
+		return 0;
+
+	/*
+	 * If ~90% of the cpu_power is still there, we're good.
+	 */
+	if (group->cpu_power * 32 > group->cpu_power_orig * 29)
+		return 1;
+
+	return 0;
+}
+
 /**
  * update_sg_lb_stats - Update sched_group's statistics for load balancing.
  * @sd: The sched_domain whose statistics are to be updated.
@@ -2400,14 +2427,14 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	 * domains. In the newly idle case, we will allow all the cpu's
 	 * to do the newly idle load balance.
 	 */
-	if (idle != CPU_NEWLY_IDLE && local_group &&
-	    balance_cpu != this_cpu) {
-		*balance = 0;
-		return;
+	if (idle != CPU_NEWLY_IDLE && local_group) {
+		if (balance_cpu != this_cpu) {
+			*balance = 0;
+			return;
+		}
+		update_group_power(sd, this_cpu);
 	}
 
-	update_group_power(sd, this_cpu);
-
 	/* Adjust by relative CPU power of the group */
 	sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) / group->cpu_power;
 
@@ -2428,6 +2455,51 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 
 	sgs->group_capacity =
 		DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
+	if (!sgs->group_capacity)
+		sgs->group_capacity = fix_small_capacity(sd, group);
+}
+
+/**
+ * update_sd_pick_busiest - return 1 on busiest group
+ * @sd: sched_domain whose statistics are to be checked
+ * @sds: sched_domain statistics
+ * @sg: sched_group candidate to be checked for being the busiest
+ * @sgs: sched_group statistics
+ * @this_cpu: the current cpu
+ *
+ * Determine if @sg is a busier group than the previously selected
+ * busiest group.
+ */
+static bool update_sd_pick_busiest(struct sched_domain *sd,
+				   struct sd_lb_stats *sds,
+				   struct sched_group *sg,
+				   struct sg_lb_stats *sgs,
+				   int this_cpu)
+{
+	if (sgs->avg_load <= sds->max_load)
+		return false;
+
+	if (sgs->sum_nr_running > sgs->group_capacity)
+		return true;
+
+	if (sgs->group_imb)
+		return true;
+
+	/*
+	 * ASYM_PACKING needs to move all the work to the lowest
+	 * numbered CPUs in the group, therefore mark all groups
+	 * higher than ourself as busy.
+	 */
+	if ((sd->flags & SD_ASYM_PACKING) && sgs->sum_nr_running &&
+	    this_cpu < group_first_cpu(sg)) {
+		if (!sds->busiest)
+			return true;
+
+		if (group_first_cpu(sds->busiest) > group_first_cpu(sg))
+			return true;
+	}
+
+	return false;
 }
 
 /**
@@ -2435,7 +2507,7 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
  * @sd: sched_domain whose statistics are to be updated.
  * @this_cpu: Cpu for which load balance is currently performed.
  * @idle: Idle status of this_cpu
- * @sd_idle: Idle status of the sched_domain containing group.
+ * @sd_idle: Idle status of the sched_domain containing sg.
  * @cpus: Set of cpus considered for load balancing.
  * @balance: Should we balance.
  * @sds: variable to hold the statistics for this sched_domain.
@@ -2446,7 +2518,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 			struct sd_lb_stats *sds)
 {
 	struct sched_domain *child = sd->child;
-	struct sched_group *group = sd->groups;
+	struct sched_group *sg = sd->groups;
 	struct sg_lb_stats sgs;
 	int load_idx, prefer_sibling = 0;
 
@@ -2459,21 +2531,20 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 	do {
 		int local_group;
 
-		local_group = cpumask_test_cpu(this_cpu,
-					       sched_group_cpus(group));
+		local_group = cpumask_test_cpu(this_cpu, sched_group_cpus(sg));
 		memset(&sgs, 0, sizeof(sgs));
-		update_sg_lb_stats(sd, group, this_cpu, idle, load_idx, sd_idle,
+		update_sg_lb_stats(sd, sg, this_cpu, idle, load_idx, sd_idle,
 				local_group, cpus, balance, &sgs);
 
 		if (local_group && !(*balance))
 			return;
 
 		sds->total_load += sgs.group_load;
-		sds->total_pwr += group->cpu_power;
+		sds->total_pwr += sg->cpu_power;
 
 		/*
 		 * In case the child domain prefers tasks go to siblings
-		 * first, lower the group capacity to one so that we'll try
+		 * first, lower the sg capacity to one so that we'll try
 		 * and move all the excess tasks away.
 		 */
 		if (prefer_sibling)
@@ -2481,23 +2552,72 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 
 		if (local_group) {
 			sds->this_load = sgs.avg_load;
-			sds->this = group;
+			sds->this = sg;
 			sds->this_nr_running = sgs.sum_nr_running;
 			sds->this_load_per_task = sgs.sum_weighted_load;
-		} else if (sgs.avg_load > sds->max_load &&
-			   (sgs.sum_nr_running > sgs.group_capacity ||
-				sgs.group_imb)) {
+		} else if (update_sd_pick_busiest(sd, sds, sg, &sgs, this_cpu)) {
 			sds->max_load = sgs.avg_load;
-			sds->busiest = group;
+			sds->busiest = sg;
 			sds->busiest_nr_running = sgs.sum_nr_running;
 			sds->busiest_group_capacity = sgs.group_capacity;
 			sds->busiest_load_per_task = sgs.sum_weighted_load;
 			sds->group_imb = sgs.group_imb;
 		}
 
-		update_sd_power_savings_stats(group, sds, local_group, &sgs);
-		group = group->next;
-	} while (group != sd->groups);
+		update_sd_power_savings_stats(sg, sds, local_group, &sgs);
+		sg = sg->next;
+	} while (sg != sd->groups);
+}
+
+int __weak arch_sd_sibling_asym_packing(void)
+{
+       return 0*SD_ASYM_PACKING;
+}
+
+/**
+ * check_asym_packing - Check to see if the group is packed into the
+ *			sched doman.
+ *
+ * This is primarily intended to used at the sibling level.  Some
+ * cores like POWER7 prefer to use lower numbered SMT threads.  In the
+ * case of POWER7, it can move to lower SMT modes only when higher
+ * threads are idle.  When in lower SMT modes, the threads will
+ * perform better since they share less core resources.  Hence when we
+ * have idle threads, we want them to be the higher ones.
+ *
+ * This packing function is run on idle threads.  It checks to see if
+ * the busiest CPU in this domain (core in the P7 case) has a higher
+ * CPU number than the packing function is being run on.  Here we are
+ * assuming lower CPU number will be equivalent to lower a SMT thread
+ * number.
+ *
+ * Returns 1 when packing is required and a task should be moved to
+ * this CPU.  The amount of the imbalance is returned in *imbalance.
+ *
+ * @sd: The sched_domain whose packing is to be checked.
+ * @sds: Statistics of the sched_domain which is to be packed
+ * @this_cpu: The cpu at whose sched_domain we're performing load-balance.
+ * @imbalance: returns amount of imbalanced due to packing.
+ */
+static int check_asym_packing(struct sched_domain *sd,
+			      struct sd_lb_stats *sds,
+			      int this_cpu, unsigned long *imbalance)
+{
+	int busiest_cpu;
+
+	if (!(sd->flags & SD_ASYM_PACKING))
+		return 0;
+
+	if (!sds->busiest)
+		return 0;
+
+	busiest_cpu = group_first_cpu(sds->busiest);
+	if (this_cpu > busiest_cpu)
+		return 0;
+
+	*imbalance = DIV_ROUND_CLOSEST(sds->max_load * sds->busiest->cpu_power,
+				       SCHED_LOAD_SCALE);
+	return 1;
 }
 
 /**
@@ -2692,6 +2812,10 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (!(*balance))
 		goto ret;
 
+	if ((idle == CPU_IDLE || idle == CPU_NEWLY_IDLE) &&
+	    check_asym_packing(sd, &sds, this_cpu, imbalance))
+		return sds.busiest;
+
 	if (!sds.busiest || sds.busiest_nr_running == 0)
 		goto out_balanced;
 
@@ -2726,8 +2850,9 @@ ret:
  * find_busiest_queue - find the busiest runqueue among the cpus in group.
  */
 static struct rq *
-find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
-		   unsigned long imbalance, const struct cpumask *cpus)
+find_busiest_queue(struct sched_domain *sd, struct sched_group *group,
+		   enum cpu_idle_type idle, unsigned long imbalance,
+		   const struct cpumask *cpus)
 {
 	struct rq *busiest = NULL, *rq;
 	unsigned long max_load = 0;
@@ -2738,6 +2863,9 @@ find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
 		unsigned long capacity = DIV_ROUND_CLOSEST(power, SCHED_LOAD_SCALE);
 		unsigned long wl;
 
+		if (!capacity)
+			capacity = fix_small_capacity(sd, group);
+
 		if (!cpumask_test_cpu(i, cpus))
 			continue;
 
@@ -2777,9 +2905,19 @@ find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
 /* Working cpumask for load_balance and load_balance_newidle. */
 static DEFINE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
 
-static int need_active_balance(struct sched_domain *sd, int sd_idle, int idle)
+static int need_active_balance(struct sched_domain *sd, int sd_idle, int idle,
+			       int busiest_cpu, int this_cpu)
 {
 	if (idle == CPU_NEWLY_IDLE) {
+
+		/*
+		 * ASYM_PACKING needs to force migrate tasks from busy but
+		 * higher numbered CPUs in order to pack all tasks in the
+		 * lowest numbered CPUs.
+		 */
+		if ((sd->flags & SD_ASYM_PACKING) && busiest_cpu > this_cpu)
+			return 1;
+
 		/*
 		 * The only task running in a non-idle cpu can be moved to this
 		 * cpu in an attempt to completely freeup the other CPU
@@ -2854,7 +2992,7 @@ redo:
 		goto out_balanced;
 	}
 
-	busiest = find_busiest_queue(group, idle, imbalance, cpus);
+	busiest = find_busiest_queue(sd, group, idle, imbalance, cpus);
 	if (!busiest) {
 		schedstat_inc(sd, lb_nobusyq[idle]);
 		goto out_balanced;
@@ -2898,7 +3036,8 @@ redo:
 		schedstat_inc(sd, lb_failed[idle]);
 		sd->nr_balance_failed++;
 
-		if (need_active_balance(sd, sd_idle, idle)) {
+		if (need_active_balance(sd, sd_idle, idle, cpu_of(busiest),
+					this_cpu)) {
 			raw_spin_lock_irqsave(&busiest->lock, flags);
 
 			/* don't kick the active_load_balance_cpu_stop,
@@ -3093,13 +3232,40 @@ out_unlock:
 }
 
 #ifdef CONFIG_NO_HZ
+
+static DEFINE_PER_CPU(struct call_single_data, remote_sched_softirq_cb);
+
+static void trigger_sched_softirq(void *data)
+{
+	raise_softirq_irqoff(SCHED_SOFTIRQ);
+}
+
+static inline void init_sched_softirq_csd(struct call_single_data *csd)
+{
+	csd->func = trigger_sched_softirq;
+	csd->info = NULL;
+	csd->flags = 0;
+	csd->priv = 0;
+}
+
+/*
+ * idle load balancing details
+ * - One of the idle CPUs nominates itself as idle load_balancer, while
+ *   entering idle.
+ * - This idle load balancer CPU will also go into tickless mode when
+ *   it is idle, just like all other idle CPUs
+ * - When one of the busy CPUs notice that there may be an idle rebalancing
+ *   needed, they will kick the idle load balancer, which then does idle
+ *   load balancing for all the idle CPUs.
+ */
 static struct {
 	atomic_t load_balancer;
-	cpumask_var_t cpu_mask;
-	cpumask_var_t ilb_grp_nohz_mask;
-} nohz ____cacheline_aligned = {
-	.load_balancer = ATOMIC_INIT(-1),
-};
+	atomic_t first_pick_cpu;
+	atomic_t second_pick_cpu;
+	cpumask_var_t idle_cpus_mask;
+	cpumask_var_t grp_idle_mask;
+	unsigned long next_balance;     /* in jiffy units */
+} nohz ____cacheline_aligned;
 
 int get_nohz_load_balancer(void)
 {
@@ -3153,17 +3319,17 @@ static inline struct sched_domain *lowest_flag_domain(int cpu, int flag)
  */
 static inline int is_semi_idle_group(struct sched_group *ilb_group)
 {
-	cpumask_and(nohz.ilb_grp_nohz_mask, nohz.cpu_mask,
+	cpumask_and(nohz.grp_idle_mask, nohz.idle_cpus_mask,
 					sched_group_cpus(ilb_group));
 
 	/*
 	 * A sched_group is semi-idle when it has atleast one busy cpu
 	 * and atleast one idle cpu.
 	 */
-	if (cpumask_empty(nohz.ilb_grp_nohz_mask))
+	if (cpumask_empty(nohz.grp_idle_mask))
 		return 0;
 
-	if (cpumask_equal(nohz.ilb_grp_nohz_mask, sched_group_cpus(ilb_group)))
+	if (cpumask_equal(nohz.grp_idle_mask, sched_group_cpus(ilb_group)))
 		return 0;
 
 	return 1;
@@ -3196,7 +3362,7 @@ static int find_new_ilb(int cpu)
 	 * Optimize for the case when we have no idle CPUs or only one
 	 * idle CPU. Don't walk the sched_domain hierarchy in such cases
 	 */
-	if (cpumask_weight(nohz.cpu_mask) < 2)
+	if (cpumask_weight(nohz.idle_cpus_mask) < 2)
 		goto out_done;
 
 	for_each_flag_domain(cpu, sd, SD_POWERSAVINGS_BALANCE) {
@@ -3204,7 +3370,7 @@ static int find_new_ilb(int cpu)
 
 		do {
 			if (is_semi_idle_group(ilb_group))
-				return cpumask_first(nohz.ilb_grp_nohz_mask);
+				return cpumask_first(nohz.grp_idle_mask);
 
 			ilb_group = ilb_group->next;
 
@@ -3212,98 +3378,116 @@ static int find_new_ilb(int cpu)
 	}
 
 out_done:
-	return cpumask_first(nohz.cpu_mask);
+	return nr_cpu_ids;
 }
 #else /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
 static inline int find_new_ilb(int call_cpu)
 {
-	return cpumask_first(nohz.cpu_mask);
+	return nr_cpu_ids;
 }
 #endif
 
 /*
+ * Kick a CPU to do the nohz balancing, if it is time for it. We pick the
+ * nohz_load_balancer CPU (if there is one) otherwise fallback to any idle
+ * CPU (if there is one).
+ */
+static void nohz_balancer_kick(int cpu)
+{
+	int ilb_cpu;
+
+	nohz.next_balance++;
+
+	ilb_cpu = get_nohz_load_balancer();
+
+	if (ilb_cpu >= nr_cpu_ids) {
+		ilb_cpu = cpumask_first(nohz.idle_cpus_mask);
+		if (ilb_cpu >= nr_cpu_ids)
+			return;
+	}
+
+	if (!cpu_rq(ilb_cpu)->nohz_balance_kick) {
+		struct call_single_data *cp;
+
+		cpu_rq(ilb_cpu)->nohz_balance_kick = 1;
+		cp = &per_cpu(remote_sched_softirq_cb, cpu);
+		__smp_call_function_single(ilb_cpu, cp, 0);
+	}
+	return;
+}
+
+/*
  * This routine will try to nominate the ilb (idle load balancing)
  * owner among the cpus whose ticks are stopped. ilb owner will do the idle
- * load balancing on behalf of all those cpus. If all the cpus in the system
- * go into this tickless mode, then there will be no ilb owner (as there is
- * no need for one) and all the cpus will sleep till the next wakeup event
- * arrives...
- *
- * For the ilb owner, tick is not stopped. And this tick will be used
- * for idle load balancing. ilb owner will still be part of
- * nohz.cpu_mask..
+ * load balancing on behalf of all those cpus.
  *
- * While stopping the tick, this cpu will become the ilb owner if there
- * is no other owner. And will be the owner till that cpu becomes busy
- * or if all cpus in the system stop their ticks at which point
- * there is no need for ilb owner.
+ * When the ilb owner becomes busy, we will not have new ilb owner until some
+ * idle CPU wakes up and goes back to idle or some busy CPU tries to kick
+ * idle load balancing by kicking one of the idle CPUs.
  *
- * When the ilb owner becomes busy, it nominates another owner, during the
- * next busy scheduler_tick()
+ * Ticks are stopped for the ilb owner as well, with busy CPU kicking this
+ * ilb owner CPU in future (when there is a need for idle load balancing on
+ * behalf of all idle CPUs).
  */
-int select_nohz_load_balancer(int stop_tick)
+void select_nohz_load_balancer(int stop_tick)
 {
 	int cpu = smp_processor_id();
 
 	if (stop_tick) {
-		cpu_rq(cpu)->in_nohz_recently = 1;
-
 		if (!cpu_active(cpu)) {
 			if (atomic_read(&nohz.load_balancer) != cpu)
-				return 0;
+				return;
 
 			/*
 			 * If we are going offline and still the leader,
 			 * give up!
 			 */
-			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
+			if (atomic_cmpxchg(&nohz.load_balancer, cpu,
+					   nr_cpu_ids) != cpu)
 				BUG();
 
-			return 0;
+			return;
 		}
 
-		cpumask_set_cpu(cpu, nohz.cpu_mask);
+		cpumask_set_cpu(cpu, nohz.idle_cpus_mask);
 
-		/* time for ilb owner also to sleep */
-		if (cpumask_weight(nohz.cpu_mask) == num_active_cpus()) {
-			if (atomic_read(&nohz.load_balancer) == cpu)
-				atomic_set(&nohz.load_balancer, -1);
-			return 0;
-		}
+		if (atomic_read(&nohz.first_pick_cpu) == cpu)
+			atomic_cmpxchg(&nohz.first_pick_cpu, cpu, nr_cpu_ids);
+		if (atomic_read(&nohz.second_pick_cpu) == cpu)
+			atomic_cmpxchg(&nohz.second_pick_cpu, cpu, nr_cpu_ids);
 
-		if (atomic_read(&nohz.load_balancer) == -1) {
-			/* make me the ilb owner */
-			if (atomic_cmpxchg(&nohz.load_balancer, -1, cpu) == -1)
-				return 1;
-		} else if (atomic_read(&nohz.load_balancer) == cpu) {
+		if (atomic_read(&nohz.load_balancer) >= nr_cpu_ids) {
 			int new_ilb;
 
-			if (!(sched_smt_power_savings ||
-						sched_mc_power_savings))
-				return 1;
+			/* make me the ilb owner */
+			if (atomic_cmpxchg(&nohz.load_balancer, nr_cpu_ids,
+					   cpu) != nr_cpu_ids)
+				return;
+
 			/*
 			 * Check to see if there is a more power-efficient
 			 * ilb.
 			 */
 			new_ilb = find_new_ilb(cpu);
 			if (new_ilb < nr_cpu_ids && new_ilb != cpu) {
-				atomic_set(&nohz.load_balancer, -1);
+				atomic_set(&nohz.load_balancer, nr_cpu_ids);
 				resched_cpu(new_ilb);
-				return 0;
+				return;
 			}
-			return 1;
+			return;
 		}
 	} else {
-		if (!cpumask_test_cpu(cpu, nohz.cpu_mask))
-			return 0;
+		if (!cpumask_test_cpu(cpu, nohz.idle_cpus_mask))
+			return;
 
-		cpumask_clear_cpu(cpu, nohz.cpu_mask);
+		cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
 
 		if (atomic_read(&nohz.load_balancer) == cpu)
-			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
+			if (atomic_cmpxchg(&nohz.load_balancer, cpu,
+					   nr_cpu_ids) != cpu)
 				BUG();
 	}
-	return 0;
+	return;
 }
 #endif
 
@@ -3385,11 +3569,102 @@ out:
 		rq->next_balance = next_balance;
 }
 
+#ifdef CONFIG_NO_HZ
 /*
- * run_rebalance_domains is triggered when needed from the scheduler tick.
- * In CONFIG_NO_HZ case, the idle load balance owner will do the
+ * In CONFIG_NO_HZ case, the idle balance kickee will do the
  * rebalancing for all the cpus for whom scheduler ticks are stopped.
  */
+static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
+{
+	struct rq *this_rq = cpu_rq(this_cpu);
+	struct rq *rq;
+	int balance_cpu;
+
+	if (idle != CPU_IDLE || !this_rq->nohz_balance_kick)
+		return;
+
+	for_each_cpu(balance_cpu, nohz.idle_cpus_mask) {
+		if (balance_cpu == this_cpu)
+			continue;
+
+		/*
+		 * If this cpu gets work to do, stop the load balancing
+		 * work being done for other cpus. Next load
+		 * balancing owner will pick it up.
+		 */
+		if (need_resched()) {
+			this_rq->nohz_balance_kick = 0;
+			break;
+		}
+
+		raw_spin_lock_irq(&this_rq->lock);
+		update_rq_clock(this_rq);
+		update_cpu_load(this_rq);
+		raw_spin_unlock_irq(&this_rq->lock);
+
+		rebalance_domains(balance_cpu, CPU_IDLE);
+
+		rq = cpu_rq(balance_cpu);
+		if (time_after(this_rq->next_balance, rq->next_balance))
+			this_rq->next_balance = rq->next_balance;
+	}
+	nohz.next_balance = this_rq->next_balance;
+	this_rq->nohz_balance_kick = 0;
+}
+
+/*
+ * Current heuristic for kicking the idle load balancer
+ * - first_pick_cpu is the one of the busy CPUs. It will kick
+ *   idle load balancer when it has more than one process active. This
+ *   eliminates the need for idle load balancing altogether when we have
+ *   only one running process in the system (common case).
+ * - If there are more than one busy CPU, idle load balancer may have
+ *   to run for active_load_balance to happen (i.e., two busy CPUs are
+ *   SMT or core siblings and can run better if they move to different
+ *   physical CPUs). So, second_pick_cpu is the second of the busy CPUs
+ *   which will kick idle load balancer as soon as it has any load.
+ */
+static inline int nohz_kick_needed(struct rq *rq, int cpu)
+{
+	unsigned long now = jiffies;
+	int ret;
+	int first_pick_cpu, second_pick_cpu;
+
+	if (time_before(now, nohz.next_balance))
+		return 0;
+
+	if (!rq->nr_running)
+		return 0;
+
+	first_pick_cpu = atomic_read(&nohz.first_pick_cpu);
+	second_pick_cpu = atomic_read(&nohz.second_pick_cpu);
+
+	if (first_pick_cpu < nr_cpu_ids && first_pick_cpu != cpu &&
+	    second_pick_cpu < nr_cpu_ids && second_pick_cpu != cpu)
+		return 0;
+
+	ret = atomic_cmpxchg(&nohz.first_pick_cpu, nr_cpu_ids, cpu);
+	if (ret == nr_cpu_ids || ret == cpu) {
+		atomic_cmpxchg(&nohz.second_pick_cpu, cpu, nr_cpu_ids);
+		if (rq->nr_running > 1)
+			return 1;
+	} else {
+		ret = atomic_cmpxchg(&nohz.second_pick_cpu, nr_cpu_ids, cpu);
+		if (ret == nr_cpu_ids || ret == cpu) {
+			if (rq->nr_running)
+				return 1;
+		}
+	}
+	return 0;
+}
+#else
+static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle) { }
+#endif
+
+/*
+ * run_rebalance_domains is triggered when needed from the scheduler tick.
+ * Also triggered for nohz idle balancing (with nohz_balancing_kick set).
+ */
 static void run_rebalance_domains(struct softirq_action *h)
 {
 	int this_cpu = smp_processor_id();
@@ -3399,37 +3674,12 @@ static void run_rebalance_domains(struct softirq_action *h)
 
 	rebalance_domains(this_cpu, idle);
 
-#ifdef CONFIG_NO_HZ
 	/*
-	 * If this cpu is the owner for idle load balancing, then do the
+	 * If this cpu has a pending nohz_balance_kick, then do the
 	 * balancing on behalf of the other idle cpus whose ticks are
 	 * stopped.
 	 */
-	if (this_rq->idle_at_tick &&
-	    atomic_read(&nohz.load_balancer) == this_cpu) {
-		struct rq *rq;
-		int balance_cpu;
-
-		for_each_cpu(balance_cpu, nohz.cpu_mask) {
-			if (balance_cpu == this_cpu)
-				continue;
-
-			/*
-			 * If this cpu gets work to do, stop the load balancing
-			 * work being done for other cpus. Next load
-			 * balancing owner will pick it up.
-			 */
-			if (need_resched())
-				break;
-
-			rebalance_domains(balance_cpu, CPU_IDLE);
-
-			rq = cpu_rq(balance_cpu);
-			if (time_after(this_rq->next_balance, rq->next_balance))
-				this_rq->next_balance = rq->next_balance;
-		}
-	}
-#endif
+	nohz_idle_balance(this_cpu, idle);
 }
 
 static inline int on_null_domain(int cpu)
@@ -3439,57 +3689,17 @@ static inline int on_null_domain(int cpu)
 
 /*
  * Trigger the SCHED_SOFTIRQ if it is time to do periodic load balancing.
- *
- * In case of CONFIG_NO_HZ, this is the place where we nominate a new
- * idle load balancing owner or decide to stop the periodic load balancing,
- * if the whole system is idle.
  */
 static inline void trigger_load_balance(struct rq *rq, int cpu)
 {
-#ifdef CONFIG_NO_HZ
-	/*
-	 * If we were in the nohz mode recently and busy at the current
-	 * scheduler tick, then check if we need to nominate new idle
-	 * load balancer.
-	 */
-	if (rq->in_nohz_recently && !rq->idle_at_tick) {
-		rq->in_nohz_recently = 0;
-
-		if (atomic_read(&nohz.load_balancer) == cpu) {
-			cpumask_clear_cpu(cpu, nohz.cpu_mask);
-			atomic_set(&nohz.load_balancer, -1);
-		}
-
-		if (atomic_read(&nohz.load_balancer) == -1) {
-			int ilb = find_new_ilb(cpu);
-
-			if (ilb < nr_cpu_ids)
-				resched_cpu(ilb);
-		}
-	}
-
-	/*
-	 * If this cpu is idle and doing idle load balancing for all the
-	 * cpus with ticks stopped, is it time for that to stop?
-	 */
-	if (rq->idle_at_tick && atomic_read(&nohz.load_balancer) == cpu &&
-	    cpumask_weight(nohz.cpu_mask) == num_online_cpus()) {
-		resched_cpu(cpu);
-		return;
-	}
-
-	/*
-	 * If this cpu is idle and the idle load balancing is done by
-	 * someone else, then no need raise the SCHED_SOFTIRQ
-	 */
-	if (rq->idle_at_tick && atomic_read(&nohz.load_balancer) != cpu &&
-	    cpumask_test_cpu(cpu, nohz.cpu_mask))
-		return;
-#endif
 	/* Don't need to rebalance while attached to NULL domain */
 	if (time_after_eq(jiffies, rq->next_balance) &&
 	    likely(!on_null_domain(cpu)))
 		raise_softirq(SCHED_SOFTIRQ);
+#ifdef CONFIG_NO_HZ
+	else if (nohz_kick_needed(rq, cpu) && likely(!on_null_domain(cpu)))
+		nohz_balancer_kick(cpu);
+#endif
 }
 
 static void rq_online_fair(struct rq *rq)
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 8afb953..d10c80e 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1663,9 +1663,6 @@ static void watchdog(struct rq *rq, struct task_struct *p)
 {
 	unsigned long soft, hard;
 
-	if (!p->signal)
-		return;
-
 	/* max may change after cur was read, this will be fixed next tick */
 	soft = task_rlimit(p, RLIMIT_RTTIME);
 	hard = task_rlimit_max(p, RLIMIT_RTTIME);
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 32d2bd4..25c2f96 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -295,13 +295,7 @@ sched_info_switch(struct task_struct *prev, struct task_struct *next)
 static inline void account_group_user_time(struct task_struct *tsk,
 					   cputime_t cputime)
 {
-	struct thread_group_cputimer *cputimer;
-
-	/* tsk == current, ensure it is safe to use ->signal */
-	if (unlikely(tsk->exit_state))
-		return;
-
-	cputimer = &tsk->signal->cputimer;
+	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
 
 	if (!cputimer->running)
 		return;
@@ -325,13 +319,7 @@ static inline void account_group_user_time(struct task_struct *tsk,
 static inline void account_group_system_time(struct task_struct *tsk,
 					     cputime_t cputime)
 {
-	struct thread_group_cputimer *cputimer;
-
-	/* tsk == current, ensure it is safe to use ->signal */
-	if (unlikely(tsk->exit_state))
-		return;
-
-	cputimer = &tsk->signal->cputimer;
+	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
 
 	if (!cputimer->running)
 		return;
@@ -355,16 +343,7 @@ static inline void account_group_system_time(struct task_struct *tsk,
 static inline void account_group_exec_runtime(struct task_struct *tsk,
 					      unsigned long long ns)
 {
-	struct thread_group_cputimer *cputimer;
-	struct signal_struct *sig;
-
-	sig = tsk->signal;
-	/* see __exit_signal()->task_rq_unlock_wait() */
-	barrier();
-	if (unlikely(!sig))
-		return;
-
-	cputimer = &sig->cputimer;
+	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
 
 	if (!cputimer->running)
 		return;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 813993b..021d2f8 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -325,7 +325,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 	} while (read_seqretry(&xtime_lock, seq));
 
 	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
-	    arch_needs_cpu(cpu) || nohz_ratelimit(cpu)) {
+	    arch_needs_cpu(cpu)) {
 		next_jiffies = last_jiffies + 1;
 		delta_jiffies = 1;
 	} else {
@@ -405,13 +405,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 		 * the scheduler tick in nohz_restart_sched_tick.
 		 */
 		if (!ts->tick_stopped) {
-			if (select_nohz_load_balancer(1)) {
-				/*
-				 * sched tick not stopped!
-				 */
-				cpumask_clear_cpu(cpu, nohz_cpu_mask);
-				goto out;
-			}
+			select_nohz_load_balancer(1);
 
 			ts->idle_tick = hrtimer_get_expires(&ts->sched_timer);
 			ts->tick_stopped = 1;
diff --git a/kernel/timer.c b/kernel/timer.c
index ee305c8..48d6aec 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -679,12 +679,8 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 	cpu = smp_processor_id();
 
 #if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
-	if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu)) {
-		int preferred_cpu = get_nohz_load_balancer();
-
-		if (preferred_cpu >= 0)
-			cpu = preferred_cpu;
-	}
+	if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu))
+		cpu = get_nohz_timer_target();
 #endif
 	new_base = per_cpu(tvec_bases, cpu);
 
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 9d589d8d..1723e2b 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -56,7 +56,7 @@ u64 notrace trace_clock_local(void)
  */
 u64 notrace trace_clock(void)
 {
-	return cpu_clock(raw_smp_processor_id());
+	return local_clock();
 }
 
 
diff --git a/kernel/workqueue_sched.h b/kernel/workqueue_sched.h
new file mode 100644
index 0000000..af040ba
--- /dev/null
+++ b/kernel/workqueue_sched.h
@@ -0,0 +1,16 @@
+/*
+ * kernel/workqueue_sched.h
+ *
+ * Scheduler hooks for concurrency managed workqueue.  Only to be
+ * included from sched.c and workqueue.c.
+ */
+static inline void wq_worker_waking_up(struct task_struct *task,
+				       unsigned int cpu)
+{
+}
+
+static inline struct task_struct *wq_worker_sleeping(struct task_struct *task,
+						     unsigned int cpu)
+{
+	return NULL;
+}
