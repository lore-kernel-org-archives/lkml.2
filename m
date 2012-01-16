Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab2APQXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 11:23:06 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:35543 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab2APQXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 11:23:03 -0500
Subject: [RFC PATCH v1 1/2] sched: unified sched_powersavings sysfs tunable
To: Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Indan Zupancic <indan@nul.nu>,
        Youquan Song <youquan.song@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Mon, 16 Jan 2012 21:52:41 +0530
Message-ID: <20120116162241.29759.13220.stgit@localhost>
In-Reply-To: <20120116161740.29759.4679.stgit@localhost>
References: <20120116161740.29759.4679.stgit@localhost>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12011616-2674-0000-0000-0000030172D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Combine the sched_mc_powersavings and sched_smt_powersavings sysfs
tunables into a single sysfs tunable:

/sys/devices/system/cpu/sched_powersavings={0,1,2}

		0 - Power savings disabled (performance mode)
		1 - Default kernel settings.  Automatic powersave
		    vs performance tradeoff by the kernel
		2 - Maximum power savings

The kernel will default to '1' which is equivalent to
sched_mc_powersavings=1 or consolidate at package level.

Max power saving setting '2' would consolidate to sibling threads and
also do aggressive active balancing.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---
 arch/x86/Kconfig          |   20 ++++--------
 arch/x86/kernel/smpboot.c |    2 +
 block/blk.h               |   11 ++++---
 drivers/base/cpu.c        |    2 +
 include/linux/sched.h     |   29 +++++++++--------
 include/linux/topology.h  |    9 +----
 kernel/sched/core.c       |   75 +++++++++++----------------------------------
 kernel/sched/fair.c       |   23 +++++++-------
 8 files changed, 62 insertions(+), 109 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6c14ecd..ee615af 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -788,23 +788,15 @@ config NR_CPUS
 	  This is purely to save memory - each supported CPU adds
 	  approximately eight kilobytes to the kernel image.
 
-config SCHED_SMT
-	bool "SMT (Hyperthreading) scheduler support"
-	depends on X86_HT
-	---help---
-	  SMT scheduler support improves the CPU scheduler's decision making
-	  when dealing with Intel Pentium 4 chips with HyperThreading at a
-	  cost of slightly increased overhead in some places. If unsure say
-	  N here.
-
-config SCHED_MC
+config SCHED_POWERSAVE
 	def_bool y
-	prompt "Multi-core scheduler support"
+	prompt "Power save support in scheduler"
 	depends on X86_HT
 	---help---
-	  Multi-core scheduler support improves the CPU scheduler's decision
-	  making when dealing with multi-core CPU chips at a cost of slightly
-	  increased overhead in some places. If unsure say N here.
+	  Power saving feature in scheduler optimizes task placement
+	  in a multi-core or mulit-threaded system whenever possible.
+	  Default kernel settings would suit most applications, while
+	  sysfs tunables can be used to control this feature at runtime.
 
 config IRQ_TIME_ACCOUNTING
 	bool "Fine granularity task level IRQ time accounting"
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 66d250c..1d60cdd 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -414,7 +414,7 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
 	 * For perf, we return last level cache shared map.
 	 * And for power savings, we return cpu_core_map
 	 */
-	if ((sched_mc_power_savings || sched_smt_power_savings) &&
+	if ((sched_power_savings) &&
 	    !(cpu_has(c, X86_FEATURE_AMD_DCM)))
 		return cpu_core_mask(cpu);
 	else
diff --git a/block/blk.h b/block/blk.h
index 7efd772..1457107 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -167,14 +167,15 @@ static inline int queue_congestion_off_threshold(struct request_queue *q)
 static inline int blk_cpu_to_group(int cpu)
 {
 	int group = NR_CPUS;
-#ifdef CONFIG_SCHED_MC
-	const struct cpumask *mask = cpu_coregroup_mask(cpu);
-	group = cpumask_first(mask);
-#elif defined(CONFIG_SCHED_SMT)
-	group = cpumask_first(topology_thread_cpumask(cpu));
+#ifdef CONFIG_SCHED_POWERSAVE
+	if (smt_capable())
+		group = cpumask_first(topology_thread_cpumask(cpu));
+	else	
+		group = cpumask_first(cpu_coregroup_mask(cpu));
 #else
 	return cpu;
 #endif
+	/* Possible dead code?? */
 	if (likely(group < NR_CPUS))
 		return group;
 	return cpu;
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index db87e78..dbaa35f 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -299,7 +299,7 @@ void __init cpu_dev_init(void)
 
 	cpu_dev_register_generic();
 
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
+#ifdef CONFIG_SCHED_POWERSAVE
 	sched_create_sysfs_power_savings_entries(cpu_subsys.dev_root);
 #endif
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4032ec1..5c33bbc 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -850,33 +850,34 @@ enum cpu_idle_type {
 #define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
 #define SD_OVERLAP		0x2000	/* sched_domains of this level overlap */
 
-enum powersavings_balance_level {
-	POWERSAVINGS_BALANCE_NONE = 0,  /* No power saving load balance */
-	POWERSAVINGS_BALANCE_BASIC,	/* Fill one thread/core/package
-					 * first for long running threads
-					 */
-	POWERSAVINGS_BALANCE_WAKEUP,	/* Also bias task wakeups to semi-idle
-					 * cpu package for power savings
-					 */
-	MAX_POWERSAVINGS_BALANCE_LEVELS
+enum powersavings_level {
+	POWERSAVINGS_DISABLED = 0,	/* Max performance */
+	POWERSAVINGS_DEFAULT,		/* Kernel default policy, automatic powersave */
+					/* vs performance tradeoff */
+	POWERSAVINGS_MAX		/* Favour power savings over peformance */
 };
 
-extern int sched_mc_power_savings, sched_smt_power_savings;
+extern int sched_power_savings;
 
 static inline int sd_balance_for_mc_power(void)
 {
-	if (sched_smt_power_savings)
+	switch (sched_power_savings) {
+	case POWERSAVINGS_MAX:
 		return SD_POWERSAVINGS_BALANCE;
 
-	if (!sched_mc_power_savings)
+	case POWERSAVINGS_DISABLED:
 		return SD_PREFER_SIBLING;
 
+	default:
+		break;
+	}
+
 	return 0;
 }
 
 static inline int sd_balance_for_package_power(void)
 {
-	if (sched_mc_power_savings | sched_smt_power_savings)
+	if (sched_power_savings != POWERSAVINGS_DISABLED)
 		return SD_POWERSAVINGS_BALANCE;
 
 	return SD_PREFER_SIBLING;
@@ -892,7 +893,7 @@ extern int __weak arch_sd_sibiling_asym_packing(void);
 
 static inline int sd_power_saving_flags(void)
 {
-	if (sched_mc_power_savings | sched_smt_power_savings)
+	if (sched_power_savings != POWERSAVINGS_DISABLED)
 		return SD_BALANCE_NEWIDLE;
 
 	return 0;
diff --git a/include/linux/topology.h b/include/linux/topology.h
index e26db03..61f3659 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -79,10 +79,7 @@ int arch_update_cpu_topology(void);
  * (Only non-zero and non-null fields need be specified.)
  */
 
-#ifdef CONFIG_SCHED_SMT
-/* MCD - Do we really need this?  It is always on if CONFIG_SCHED_SMT is,
- * so can't we drop this in favor of CONFIG_SCHED_SMT?
- */
+#ifdef CONFIG_SCHED_POWERSAVE
 #define ARCH_HAS_SCHED_WAKE_IDLE
 /* Common values for SMT siblings */
 #ifndef SD_SIBLING_INIT
@@ -110,9 +107,7 @@ int arch_update_cpu_topology(void);
 	.smt_gain		= 1178,	/* 15% */			\
 }
 #endif
-#endif /* CONFIG_SCHED_SMT */
 
-#ifdef CONFIG_SCHED_MC
 /* Common values for MC siblings. for now mostly derived from SD_CPU_INIT */
 #ifndef SD_MC_INIT
 #define SD_MC_INIT (struct sched_domain) {				\
@@ -142,7 +137,7 @@ int arch_update_cpu_topology(void);
 	.balance_interval	= 1,					\
 }
 #endif
-#endif /* CONFIG_SCHED_MC */
+#endif /* CONFIG_SCHED_POWERSAVE */
 
 /* Common values for CPUs */
 #ifndef SD_CPU_INIT
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index df00cb0..f303db8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5924,7 +5924,7 @@ static const struct cpumask *cpu_cpu_mask(int cpu)
 	return cpumask_of_node(cpu_to_node(cpu));
 }
 
-int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
+int sched_power_savings = POWERSAVINGS_DEFAULT;
 
 struct sd_data {
 	struct sched_domain **__percpu sd;
@@ -6150,10 +6150,8 @@ SD_INIT_FUNC(CPU)
  SD_INIT_FUNC(ALLNODES)
  SD_INIT_FUNC(NODE)
 #endif
-#ifdef CONFIG_SCHED_SMT
+#ifdef CONFIG_SCHED_POWERSAVE
  SD_INIT_FUNC(SIBLING)
-#endif
-#ifdef CONFIG_SCHED_MC
  SD_INIT_FUNC(MC)
 #endif
 #ifdef CONFIG_SCHED_BOOK
@@ -6250,7 +6248,7 @@ static void claim_allocations(int cpu, struct sched_domain *sd)
 		*per_cpu_ptr(sdd->sgp, cpu) = NULL;
 }
 
-#ifdef CONFIG_SCHED_SMT
+#ifdef CONFIG_SCHED_POWERSAVE
 static const struct cpumask *cpu_smt_mask(int cpu)
 {
 	return topology_thread_cpumask(cpu);
@@ -6261,10 +6259,8 @@ static const struct cpumask *cpu_smt_mask(int cpu)
  * Topology list, bottom-up.
  */
 static struct sched_domain_topology_level default_topology[] = {
-#ifdef CONFIG_SCHED_SMT
+#ifdef CONFIG_SCHED_POWERSAVE
 	{ sd_init_SIBLING, cpu_smt_mask, },
-#endif
-#ifdef CONFIG_SCHED_MC
 	{ sd_init_MC, cpu_coregroup_mask, },
 #endif
 #ifdef CONFIG_SCHED_BOOK
@@ -6635,7 +6631,7 @@ match2:
 	mutex_unlock(&sched_domains_mutex);
 }
 
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
+#if defined(CONFIG_SCHED_POWERSAVE)
 static void reinit_sched_domains(void)
 {
 	get_online_cpus();
@@ -6647,7 +6643,9 @@ static void reinit_sched_domains(void)
 	put_online_cpus();
 }
 
-static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
+static ssize_t sched_power_savings_store(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t count)
 {
 	unsigned int level = 0;
 
@@ -6656,75 +6654,40 @@ static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
 
 	/*
 	 * level is always be positive so don't check for
-	 * level < POWERSAVINGS_BALANCE_NONE which is 0
+	 * level < POWERSAVINGS_DEFAULT which is 0
 	 * What happens on 0 or 1 byte write,
 	 * need to check for count as well?
 	 */
 
-	if (level >= MAX_POWERSAVINGS_BALANCE_LEVELS)
+	if (level > POWERSAVINGS_MAX)
 		return -EINVAL;
 
-	if (smt)
-		sched_smt_power_savings = level;
-	else
-		sched_mc_power_savings = level;
+		sched_power_savings = level;
 
 	reinit_sched_domains();
 
 	return count;
 }
 
-#ifdef CONFIG_SCHED_MC
-static ssize_t sched_mc_power_savings_show(struct device *dev,
+static ssize_t sched_power_savings_show(struct device *dev,
 					   struct device_attribute *attr,
 					   char *buf)
 {
-	return sprintf(buf, "%u\n", sched_mc_power_savings);
-}
-static ssize_t sched_mc_power_savings_store(struct device *dev,
-					    struct device_attribute *attr,
-					    const char *buf, size_t count)
-{
-	return sched_power_savings_store(buf, count, 0);
-}
-static DEVICE_ATTR(sched_mc_power_savings, 0644,
-		   sched_mc_power_savings_show,
-		   sched_mc_power_savings_store);
-#endif
-
-#ifdef CONFIG_SCHED_SMT
-static ssize_t sched_smt_power_savings_show(struct device *dev,
-					    struct device_attribute *attr,
-					    char *buf)
-{
-	return sprintf(buf, "%u\n", sched_smt_power_savings);
-}
-static ssize_t sched_smt_power_savings_store(struct device *dev,
-					    struct device_attribute *attr,
-					     const char *buf, size_t count)
-{
-	return sched_power_savings_store(buf, count, 1);
+	return sprintf(buf, "%u\n", sched_power_savings);
 }
-static DEVICE_ATTR(sched_smt_power_savings, 0644,
-		   sched_smt_power_savings_show,
-		   sched_smt_power_savings_store);
-#endif
+static DEVICE_ATTR(sched_power_savings, 0644,
+		   sched_power_savings_show,
+		   sched_power_savings_store);
 
 int __init sched_create_sysfs_power_savings_entries(struct device *dev)
 {
 	int err = 0;
 
-#ifdef CONFIG_SCHED_SMT
-	if (smt_capable())
-		err = device_create_file(dev, &dev_attr_sched_smt_power_savings);
-#endif
-#ifdef CONFIG_SCHED_MC
-	if (!err && mc_capable())
-		err = device_create_file(dev, &dev_attr_sched_mc_power_savings);
-#endif
+	if (mc_capable() || smt_capable())
+		err = device_create_file(dev, &dev_attr_sched_power_savings);
 	return err;
 }
-#endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
+#endif /* CONFIG_SCHED_POWERSAVE */
 
 /*
  * Update cpusets according to cpu_active mask.  If cpusets are
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 84adb2d..bae6ec8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3497,7 +3497,7 @@ struct sd_lb_stats {
 	unsigned int  busiest_group_weight;
 
 	int group_imb; /* Is there imbalance in this sd */
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
+#ifdef CONFIG_SCHED_POWERSAVE
 	int power_savings_balance; /* Is powersave balance needed for this sd */
 	struct sched_group *group_min; /* Least loaded group in sd */
 	struct sched_group *group_leader; /* Group which relieves group_min */
@@ -3549,7 +3549,7 @@ static inline int get_sd_load_idx(struct sched_domain *sd,
 }
 
 
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
+#ifdef CONFIG_SCHED_POWERSAVE
 /**
  * init_sd_power_savings_stats - Initialize power savings statistics for
  * the given sched_domain, during load balancing.
@@ -3669,7 +3669,7 @@ static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
 	return 1;
 
 }
-#else /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
+#else /* CONFIG_SCHED_POWERSAVE */
 static inline void init_sd_power_savings_stats(struct sched_domain *sd,
 	struct sd_lb_stats *sds, enum cpu_idle_type idle)
 {
@@ -3687,7 +3687,7 @@ static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
 {
 	return 0;
 }
-#endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
+#endif /* CONFIG_SCHED_POWERSAVE */
 
 
 unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu)
@@ -4422,9 +4422,10 @@ static int need_active_balance(struct sched_domain *sd, int idle,
 		 *
 		 * The package power saving logic comes from
 		 * find_busiest_group(). If there are no imbalance, then
-		 * f_b_g() will return NULL. However when sched_mc={1,2} then
-		 * f_b_g() will select a group from which a running task may be
-		 * pulled to this cpu in order to make the other package idle.
+		 * f_b_g() will return NULL. However when
+		 * sched_powersavings={1,2} then f_b_g() will select a group
+		 * from which a running task may be pulled to this cpu
+		 * in order to make the other package idle.
 		 * If there is no opportunity to make a package idle and if
 		 * there are no imbalance, then f_b_g() will return NULL and no
 		 * action will be taken in load_balance_newidle().
@@ -4434,7 +4435,7 @@ static int need_active_balance(struct sched_domain *sd, int idle,
 		 * move_tasks() will succeed.  ld_moved will be true and this
 		 * active balance code will not be triggered.
 		 */
-		if (sched_mc_power_savings < POWERSAVINGS_BALANCE_WAKEUP)
+		if (sched_power_savings < POWERSAVINGS_MAX)
 			return 0;
 	}
 
@@ -4739,7 +4740,7 @@ static struct {
 	unsigned long next_balance;     /* in jiffy units */
 } nohz ____cacheline_aligned;
 
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
+#ifdef CONFIG_SCHED_POWERSAVE
 /**
  * lowest_flag_domain - Return lowest sched_domain containing flag.
  * @cpu:	The cpu whose lowest level of sched domain is to
@@ -4796,7 +4797,7 @@ static int find_new_ilb(int cpu)
 	 * Have idle load balancer selection from semi-idle packages only
 	 * when power-aware load balancing is enabled
 	 */
-	if (!(sched_smt_power_savings || sched_mc_power_savings))
+	if (!(sched_power_savings))
 		goto out_done;
 
 	/*
@@ -4831,7 +4832,7 @@ out_done:
 
 	return nr_cpu_ids;
 }
-#else /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
+#else /*  (CONFIG_SCHED_POWERSAVE) */
 static inline int find_new_ilb(int call_cpu)
 {
 	return nr_cpu_ids;

