Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab2HTOBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:01:15 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:44941 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465Ab2HTOBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:01:08 -0400
From: Trevor Brandt <tjbrandt@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>, Eric Paris <eparis@redhat.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Trevor Brandt <tjbrandt@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Glauber Costa <glommer@parallels.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Cc: team-fjord@googlegroups.com
Subject: [PATCHv2 2/2] sched: Support compiling out real-time scheduling with REALTIME_SCHED.
Date: Mon, 20 Aug 2012 07:00:23 -0700
Message-Id: <1345471224-14997-2-git-send-email-tjbrandt@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345471224-14997-1-git-send-email-tjbrandt@gmail.com>
References: <y>
 <1345471224-14997-1-git-send-email-tjbrandt@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for compiling out the real-time scheduler (SCHED_FIFO
and SCHED_RR) to save space. Changes sched_set_stop_task to use
SCHED_NORMAL rather than SCHED_FIFO, since the kernel only uses this
function as a fake scheduling priority for userspace to read to avoid
exposing the stop class to userspace. Bloat-o-meter gives a space
savings of 1877 bytes with REALTIME_SCHED turned off.

Userspace works fine with REALTIME_SCHED turned off. Processes
attempting to set a real-time scheduling policy get EINVAL, exactly
the response that the sched_setscheduler manpage documents you will
get if the "scheduling policy is not one of the recognized policies."

Signed-off-by: Trevor Brandt <tjbrandt@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
v2: The second revision compiles out cpupri.c when REALTIME_SCHED=n.

 init/Kconfig             |    8 ++++++++
 kernel/sched/Makefile    |    6 ++++--
 kernel/sched/core.c      |   14 ++++++--------
 kernel/sched/cpupri.h    |    3 ++-
 kernel/sched/rt.c        |    2 --
 kernel/sched/sched.h     |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/stop_task.c |    4 ++++
 7 files changed, 70 insertions(+), 13 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 3f42cd6..1206961 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -753,6 +753,7 @@ config CFS_BANDWIDTH
 
 config RT_GROUP_SCHED
 	bool "Group scheduling for SCHED_RR/FIFO"
+	depends on REALTIME_SCHED
 	depends on EXPERIMENTAL
 	depends on CGROUP_SCHED
 	default n
@@ -972,6 +973,13 @@ menuconfig EXPERT
           environments which can tolerate a "non-standard" kernel.
           Only use this if you really know what you are doing.
 
+config REALTIME_SCHED
+	bool "Realtime Scheduler" if EXPERT
+	default y
+	help
+	  This option enables support for the realtime scheduler and the
+	  corresponding scheduling classes SCHED_FIFO and SCHED_RR.
+
 config UID16
 	bool "Enable 16-bit UID system calls" if EXPERT
 	depends on ARM || BLACKFIN || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && COMPAT) || UML || (X86_64 && IA32_EMULATION)
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index 9a7dd35..76fe500 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -11,8 +11,10 @@ ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 CFLAGS_core.o := $(PROFILING) -fno-omit-frame-pointer
 endif
 
-obj-y += core.o clock.o idle_task.o fair.o rt.o stop_task.o
-obj-$(CONFIG_SMP) += cpupri.o
+obj-y += core.o clock.o idle_task.o fair.o stop_task.o
+obj-$(CONFIG_REALTIME_SCHED) += realtime.o
+realtime-y += rt.o
+realtime-$(CONFIG_SMP) += cpupri.o
 obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
 obj-$(CONFIG_SCHEDSTATS) += stats.o
 obj-$(CONFIG_SCHED_DEBUG) += debug.o
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 478a04c..3579286 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -85,6 +85,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/sched.h>
 
+struct rt_bandwidth def_rt_bandwidth;
+
 void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period)
 {
 	unsigned long delta;
@@ -959,19 +961,15 @@ static int irqtime_account_si_update(void)
 
 void sched_set_stop_task(int cpu, struct task_struct *stop)
 {
-	struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
+	struct sched_param param = { .sched_priority = 0 };
 	struct task_struct *old_stop = cpu_rq(cpu)->stop;
 
 	if (stop) {
 		/*
-		 * Make it appear like a SCHED_FIFO task, its something
+		 * Make it appear like a SCHED_NORMAL task, its something
 		 * userspace knows about and won't get confused about.
-		 *
-		 * Also, it will make PI more or less work without too
-		 * much confusion -- but then, stop work should not
-		 * rely on PI working anyway.
 		 */
-		sched_setscheduler_nocheck(stop, SCHED_FIFO, &param);
+		sched_setscheduler_nocheck(stop, SCHED_NORMAL, &param);
 
 		stop->sched_class = &stop_sched_class;
 	}
@@ -983,7 +981,7 @@ void sched_set_stop_task(int cpu, struct task_struct *stop)
 		 * Reset it back to a normal scheduling class so that
 		 * it can die in pieces.
 		 */
-		old_stop->sched_class = &rt_sched_class;
+		old_stop->sched_class = &fair_sched_class;
 	}
 }
 
diff --git a/kernel/sched/cpupri.h b/kernel/sched/cpupri.h
index fd7914c..8ee2796 100644
--- a/kernel/sched/cpupri.h
+++ b/kernel/sched/cpupri.h
@@ -20,7 +20,7 @@ struct cpupri {
 	int               cpu_to_pri[NR_CPUS];
 };
 
-#ifdef CONFIG_SMP
+#if defined(CONFIG_SMP) && defined(CONFIG_REALTIME_SCHED)
 int  cpupri_find(struct cpupri *cp,
 		 struct task_struct *p, struct cpumask *lowest_mask);
 void cpupri_set(struct cpupri *cp, int cpu, int pri);
@@ -32,6 +32,7 @@ static inline int cpupri_init(struct cpupri *cp)
 {
 	return 0;
 }
+static inline void cpupri_cleanup(struct cpupri *cp) { }
 #endif
 
 #endif /* _LINUX_CPUPRI_H */
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index f42ae7f..4100803 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -9,8 +9,6 @@
 
 static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun);
 
-struct rt_bandwidth def_rt_bandwidth;
-
 static enum hrtimer_restart sched_rt_period_timer(struct hrtimer *timer)
 {
 	struct rt_bandwidth *rt_b =
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 98c0c26..ed41cb7 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -47,6 +47,8 @@ extern __read_mostly int scheduler_running;
  */
 #define RUNTIME_INF	((u64)~0ULL)
 
+#ifdef CONFIG_REALTIME_SCHED
+
 static inline int rt_policy(int policy)
 {
 	if (policy == SCHED_FIFO || policy == SCHED_RR)
@@ -59,6 +61,19 @@ static inline int task_has_rt_policy(struct task_struct *p)
 	return rt_policy(p->policy);
 }
 
+#else /* CONFIG_REALTIME_SCHED */
+
+static inline int rt_policy(int policy)
+{
+	return 0;
+}
+static inline int task_has_rt_policy(struct task_struct *p)
+{
+	return 0;
+}
+
+#endif /* CONFIG_REALTIME_SCHED */
+
 /*
  * This is the priority-queue data structure of the RT scheduling class:
  */
@@ -190,8 +205,17 @@ extern void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b);
 extern void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b);
 extern void unthrottle_cfs_rq(struct cfs_rq *cfs_rq);
 
+#ifdef CONFIG_REALTIME_SCHED
 extern void free_rt_sched_group(struct task_group *tg);
 extern int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent);
+#else
+static inline void free_rt_sched_group(struct task_group *tg) { }
+static inline int alloc_rt_sched_group(struct task_group *tg,
+			struct task_group *parent)
+{
+	return 1;
+}
+#endif
 extern void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
 		struct sched_rt_entity *rt_se, int cpu,
 		struct sched_rt_entity *parent);
@@ -852,7 +876,11 @@ enum cpuacct_stat_index {
    for (class = sched_class_highest; class; class = class->next)
 
 extern const struct sched_class stop_sched_class;
+#ifdef CONFIG_REALTIME_SCHED
 extern const struct sched_class rt_sched_class;
+#else
+static const struct sched_class rt_sched_class = { };
+#endif
 extern const struct sched_class fair_sched_class;
 extern const struct sched_class idle_sched_class;
 
@@ -874,15 +902,29 @@ extern void sysrq_sched_debug_show(void);
 extern void sched_init_granularity(void);
 extern void update_max_interval(void);
 extern void update_group_power(struct sched_domain *sd, int cpu);
+#ifdef CONFIG_REALTIME_SCHED
 extern int update_runtime(struct notifier_block *nfb, unsigned long action, void *hcpu);
 extern void init_sched_rt_class(void);
+#else
+static inline int update_runtime(struct notifier_block *nfb,
+			unsigned long action, void *hcpu)
+{
+	return 0;
+}
+static inline void init_sched_rt_class(void) { }
+#endif
 extern void init_sched_fair_class(void);
 
 extern void resched_task(struct task_struct *p);
 extern void resched_cpu(int cpu);
 
 extern struct rt_bandwidth def_rt_bandwidth;
+#ifdef CONFIG_REALTIME_SCHED
 extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime);
+#else
+static inline void init_rt_bandwidth(struct rt_bandwidth *rt_b,
+			u64 period, u64 runtime) { }
+#endif
 
 extern void update_cpu_load(struct rq *this_rq);
 
@@ -1150,7 +1192,11 @@ extern void print_cfs_stats(struct seq_file *m, int cpu);
 extern void print_rt_stats(struct seq_file *m, int cpu);
 
 extern void init_cfs_rq(struct cfs_rq *cfs_rq);
+#ifdef CONFIG_REALTIME_SCHED
 extern void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq);
+#else
+static inline void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq) { }
+#endif
 extern void unthrottle_offline_cfs_rqs(struct rq *rq);
 
 extern void account_cfs_bandwidth_used(int enabled, int was_enabled);
diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index 7b386e8..5c29766 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -83,7 +83,11 @@ get_rr_interval_stop(struct rq *rq, struct task_struct *task)
  * Simple, special scheduling class for the per-CPU stop tasks:
  */
 const struct sched_class stop_sched_class = {
+#ifdef CONFIG_REALTIME_SCHED
 	.next			= &rt_sched_class,
+#else
+	.next			= &fair_sched_class,
+#endif
 
 	.enqueue_task		= enqueue_task_stop,
 	.dequeue_task		= dequeue_task_stop,
-- 
1.7.9.5

