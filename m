Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161043Ab2ERKUY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:20:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42154 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab2ERKUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:20:20 -0400
Date: Fri, 18 May 2012 03:19:44 -0700
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-8e7fbcbc22c12414bcc9dfdd683637f58fb32759@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, arjan@linux.intel.com,
        a.p.zijlstra@chello.nl, peterz@infradead.org,
        akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        vincent.guittot@linaro.org, tglx@linutronix.de,
        svaidy@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, arjan@linux.intel.com,
        torvalds@linux-foundation.org, peterz@infradead.org,
        akpm@linux-foundation.org, vincent.guittot@linaro.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        svaidy@linux.vnet.ibm.com
In-Reply-To: <1326104915.2442.53.camel@twins>
References: <1326104915.2442.53.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Remove stale power aware scheduling remnants and dysfunctional knobs
Git-Commit-ID: 8e7fbcbc22c12414bcc9dfdd683637f58fb32759
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:19:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e7fbcbc22c12414bcc9dfdd683637f58fb32759
Gitweb:     http://git.kernel.org/tip/8e7fbcbc22c12414bcc9dfdd683637f58fb32759
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 9 Jan 2012 11:28:35 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 17 May 2012 13:48:56 +0200

sched: Remove stale power aware scheduling remnants and dysfunctional knobs

It's been broken forever (i.e. it's not scheduling in a power
aware fashion), as reported by Suresh and others sending
patches, and nobody cares enough to fix it properly ...
so remove it to make space free for something better.

There's various problems with the code as it stands today, first
and foremost the user interface which is bound to topology
levels and has multiple values per level. This results in a
state explosion which the administrator or distro needs to
master and almost nobody does.

Furthermore large configuration state spaces aren't good, it
means the thing doesn't just work right because it's either
under so many impossibe to meet constraints, or even if
there's an achievable state workloads have to be aware of
it precisely and can never meet it for dynamic workloads.

So pushing this kind of decision to user-space was a bad idea
even with a single knob - it's exponentially worse with knobs
on every node of the topology.

There is a proposal to replace the user interface with a single
3 state knob:

 sched_balance_policy := { performance, power, auto }

where 'auto' would be the preferred default which looks at things
like Battery/AC mode and possible cpufreq state or whatever the hw
exposes to show us power use expectations - but there's been no
progress on it in the past many months.

Aside from that, the actual implementation of the various knobs
is known to be broken. There have been sporadic attempts at
fixing things but these always stop short of reaching a mergable
state.

Therefore this wholesale removal with the hopes of spurring
people who care to come forward once again and work on a
coherent replacement.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1326104915.2442.53.camel@twins
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |   25 --
 Documentation/scheduler/sched-domains.txt          |    4 -
 arch/x86/kernel/smpboot.c                          |    3 +-
 drivers/base/cpu.c                                 |    4 -
 include/linux/cpu.h                                |    2 -
 include/linux/sched.h                              |   47 ----
 include/linux/topology.h                           |    5 -
 kernel/sched/core.c                                |   94 -------
 kernel/sched/fair.c                                |  275 +-------------------
 tools/power/cpupower/man/cpupower-set.1            |    9 -
 tools/power/cpupower/utils/helpers/sysfs.c         |   35 +---
 11 files changed, 5 insertions(+), 498 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index e7be75b..5dab364 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -9,31 +9,6 @@ Description:
 
 		/sys/devices/system/cpu/cpu#/
 
-What:		/sys/devices/system/cpu/sched_mc_power_savings
-		/sys/devices/system/cpu/sched_smt_power_savings
-Date:		June 2006
-Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
-Description:	Discover and adjust the kernel's multi-core scheduler support.
-
-		Possible values are:
-
-		0 - No power saving load balance (default value)
-		1 - Fill one thread/core/package first for long running threads
-		2 - Also bias task wakeups to semi-idle cpu package for power
-		    savings
-
-		sched_mc_power_savings is dependent upon SCHED_MC, which is
-		itself architecture dependent.
-
-		sched_smt_power_savings is dependent upon SCHED_SMT, which
-		is itself architecture dependent.
-
-		The two files are independent of each other. It is possible
-		that one file may be present without the other.
-
-		Introduced by git commit 5c45bf27.
-
-
 What:		/sys/devices/system/cpu/kernel_max
 		/sys/devices/system/cpu/offline
 		/sys/devices/system/cpu/online
diff --git a/Documentation/scheduler/sched-domains.txt b/Documentation/scheduler/sched-domains.txt
index b7ee379..443f0c7 100644
--- a/Documentation/scheduler/sched-domains.txt
+++ b/Documentation/scheduler/sched-domains.txt
@@ -61,10 +61,6 @@ The implementor should read comments in include/linux/sched.h:
 struct sched_domain fields, SD_FLAG_*, SD_*_INIT to get an idea of
 the specifics and what to tune.
 
-For SMT, the architecture must define CONFIG_SCHED_SMT and provide a
-cpumask_t cpu_sibling_map[NR_CPUS], where cpu_sibling_map[i] is the mask of
-all "i"'s siblings as well as "i" itself.
-
 Architectures may retain the regular override the default SD_*_INIT flags
 while using the generic domain builder in kernel/sched.c if they wish to
 retain the traditional SMT->SMP->NUMA topology (or some subset of that). This
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index e84c1bb..256c20c 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -429,8 +429,7 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
 	 * For perf, we return last level cache shared map.
 	 * And for power savings, we return cpu_core_map
 	 */
-	if ((sched_mc_power_savings || sched_smt_power_savings) &&
-	    !(cpu_has(c, X86_FEATURE_AMD_DCM)))
+	if (!(cpu_has(c, X86_FEATURE_AMD_DCM)))
 		return cpu_core_mask(cpu);
 	else
 		return cpu_llc_shared_mask(cpu);
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index adf937b..6345294 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -330,8 +330,4 @@ void __init cpu_dev_init(void)
 		panic("Failed to register CPU subsystem");
 
 	cpu_dev_register_generic();
-
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-	sched_create_sysfs_power_savings_entries(cpu_subsys.dev_root);
-#endif
 }
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index ee28844..7230bb5 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -36,8 +36,6 @@ extern void cpu_remove_dev_attr(struct device_attribute *attr);
 extern int cpu_add_dev_attr_group(struct attribute_group *attrs);
 extern void cpu_remove_dev_attr_group(struct attribute_group *attrs);
 
-extern int sched_create_sysfs_power_savings_entries(struct device *dev);
-
 #ifdef CONFIG_HOTPLUG_CPU
 extern void unregister_cpu(struct cpu *cpu);
 extern ssize_t arch_cpu_probe(const char *, size_t);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4a559bf..3d64480 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -855,61 +855,14 @@ enum cpu_idle_type {
 #define SD_WAKE_AFFINE		0x0020	/* Wake task to waking CPU */
 #define SD_PREFER_LOCAL		0x0040  /* Prefer to keep tasks local to this domain */
 #define SD_SHARE_CPUPOWER	0x0080	/* Domain members share cpu power */
-#define SD_POWERSAVINGS_BALANCE	0x0100	/* Balance for power savings */
 #define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg resources */
 #define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
 #define SD_ASYM_PACKING		0x0800  /* Place busy groups earlier in the domain */
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
-};
-
-extern int sched_mc_power_savings, sched_smt_power_savings;
-
-static inline int sd_balance_for_mc_power(void)
-{
-	if (sched_smt_power_savings)
-		return SD_POWERSAVINGS_BALANCE;
-
-	if (!sched_mc_power_savings)
-		return SD_PREFER_SIBLING;
-
-	return 0;
-}
-
-static inline int sd_balance_for_package_power(void)
-{
-	if (sched_mc_power_savings | sched_smt_power_savings)
-		return SD_POWERSAVINGS_BALANCE;
-
-	return SD_PREFER_SIBLING;
-}
-
 extern int __weak arch_sd_sibiling_asym_packing(void);
 
-/*
- * Optimise SD flags for power savings:
- * SD_BALANCE_NEWIDLE helps aggressive task consolidation and power savings.
- * Keep default SD flags if sched_{smt,mc}_power_saving=0
- */
-
-static inline int sd_power_saving_flags(void)
-{
-	if (sched_mc_power_savings | sched_smt_power_savings)
-		return SD_BALANCE_NEWIDLE;
-
-	return 0;
-}
-
 struct sched_group_power {
 	atomic_t ref;
 	/*
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 4f59bf3..09558d1 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -98,7 +98,6 @@ int arch_update_cpu_topology(void);
 				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
 				| 1*SD_SHARE_CPUPOWER			\
-				| 0*SD_POWERSAVINGS_BALANCE		\
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
 				| 0*SD_PREFER_SIBLING			\
@@ -134,8 +133,6 @@ int arch_update_cpu_topology(void);
 				| 0*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
-				| sd_balance_for_mc_power()		\
-				| sd_power_saving_flags()		\
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
@@ -167,8 +164,6 @@ int arch_update_cpu_topology(void);
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
-				| sd_balance_for_package_power()	\
-				| sd_power_saving_flags()		\
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index bd314d7..24ca677 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5929,8 +5929,6 @@ static const struct cpumask *cpu_cpu_mask(int cpu)
 	return cpumask_of_node(cpu_to_node(cpu));
 }
 
-int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
-
 struct sd_data {
 	struct sched_domain **__percpu sd;
 	struct sched_group **__percpu sg;
@@ -6322,7 +6320,6 @@ sd_numa_init(struct sched_domain_topology_level *tl, int cpu)
 					| 0*SD_WAKE_AFFINE
 					| 0*SD_PREFER_LOCAL
 					| 0*SD_SHARE_CPUPOWER
-					| 0*SD_POWERSAVINGS_BALANCE
 					| 0*SD_SHARE_PKG_RESOURCES
 					| 1*SD_SERIALIZE
 					| 0*SD_PREFER_SIBLING
@@ -6819,97 +6816,6 @@ match2:
 	mutex_unlock(&sched_domains_mutex);
 }
 
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-static void reinit_sched_domains(void)
-{
-	get_online_cpus();
-
-	/* Destroy domains first to force the rebuild */
-	partition_sched_domains(0, NULL, NULL);
-
-	rebuild_sched_domains();
-	put_online_cpus();
-}
-
-static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
-{
-	unsigned int level = 0;
-
-	if (sscanf(buf, "%u", &level) != 1)
-		return -EINVAL;
-
-	/*
-	 * level is always be positive so don't check for
-	 * level < POWERSAVINGS_BALANCE_NONE which is 0
-	 * What happens on 0 or 1 byte write,
-	 * need to check for count as well?
-	 */
-
-	if (level >= MAX_POWERSAVINGS_BALANCE_LEVELS)
-		return -EINVAL;
-
-	if (smt)
-		sched_smt_power_savings = level;
-	else
-		sched_mc_power_savings = level;
-
-	reinit_sched_domains();
-
-	return count;
-}
-
-#ifdef CONFIG_SCHED_MC
-static ssize_t sched_mc_power_savings_show(struct device *dev,
-					   struct device_attribute *attr,
-					   char *buf)
-{
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
-}
-static DEVICE_ATTR(sched_smt_power_savings, 0644,
-		   sched_smt_power_savings_show,
-		   sched_smt_power_savings_store);
-#endif
-
-int __init sched_create_sysfs_power_savings_entries(struct device *dev)
-{
-	int err = 0;
-
-#ifdef CONFIG_SCHED_SMT
-	if (smt_capable())
-		err = device_create_file(dev, &dev_attr_sched_smt_power_savings);
-#endif
-#ifdef CONFIG_SCHED_MC
-	if (!err && mc_capable())
-		err = device_create_file(dev, &dev_attr_sched_mc_power_savings);
-#endif
-	return err;
-}
-#endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
-
 /*
  * Update cpusets according to cpu_active mask.  If cpusets are
  * disabled, cpuset_update_active_cpus() becomes a simple wrapper
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0b42f44..940e6d1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2721,7 +2721,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 		 * If power savings logic is enabled for a domain, see if we
 		 * are not overloaded, if so, don't balance wider.
 		 */
-		if (tmp->flags & (SD_POWERSAVINGS_BALANCE|SD_PREFER_LOCAL)) {
+		if (tmp->flags & (SD_PREFER_LOCAL)) {
 			unsigned long power = 0;
 			unsigned long nr_running = 0;
 			unsigned long capacity;
@@ -2734,9 +2734,6 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 
 			capacity = DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE);
 
-			if (tmp->flags & SD_POWERSAVINGS_BALANCE)
-				nr_running /= 2;
-
 			if (nr_running < capacity)
 				want_sd = 0;
 		}
@@ -3435,14 +3432,6 @@ struct sd_lb_stats {
 	unsigned int  busiest_group_weight;
 
 	int group_imb; /* Is there imbalance in this sd */
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-	int power_savings_balance; /* Is powersave balance needed for this sd */
-	struct sched_group *group_min; /* Least loaded group in sd */
-	struct sched_group *group_leader; /* Group which relieves group_min */
-	unsigned long min_load_per_task; /* load_per_task in group_min */
-	unsigned long leader_nr_running; /* Nr running of group_leader */
-	unsigned long min_nr_running; /* Nr running of group_min */
-#endif
 };
 
 /*
@@ -3486,147 +3475,6 @@ static inline int get_sd_load_idx(struct sched_domain *sd,
 	return load_idx;
 }
 
-
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-/**
- * init_sd_power_savings_stats - Initialize power savings statistics for
- * the given sched_domain, during load balancing.
- *
- * @sd: Sched domain whose power-savings statistics are to be initialized.
- * @sds: Variable containing the statistics for sd.
- * @idle: Idle status of the CPU at which we're performing load-balancing.
- */
-static inline void init_sd_power_savings_stats(struct sched_domain *sd,
-	struct sd_lb_stats *sds, enum cpu_idle_type idle)
-{
-	/*
-	 * Busy processors will not participate in power savings
-	 * balance.
-	 */
-	if (idle == CPU_NOT_IDLE || !(sd->flags & SD_POWERSAVINGS_BALANCE))
-		sds->power_savings_balance = 0;
-	else {
-		sds->power_savings_balance = 1;
-		sds->min_nr_running = ULONG_MAX;
-		sds->leader_nr_running = 0;
-	}
-}
-
-/**
- * update_sd_power_savings_stats - Update the power saving stats for a
- * sched_domain while performing load balancing.
- *
- * @group: sched_group belonging to the sched_domain under consideration.
- * @sds: Variable containing the statistics of the sched_domain
- * @local_group: Does group contain the CPU for which we're performing
- * 		load balancing ?
- * @sgs: Variable containing the statistics of the group.
- */
-static inline void update_sd_power_savings_stats(struct sched_group *group,
-	struct sd_lb_stats *sds, int local_group, struct sg_lb_stats *sgs)
-{
-
-	if (!sds->power_savings_balance)
-		return;
-
-	/*
-	 * If the local group is idle or completely loaded
-	 * no need to do power savings balance at this domain
-	 */
-	if (local_group && (sds->this_nr_running >= sgs->group_capacity ||
-				!sds->this_nr_running))
-		sds->power_savings_balance = 0;
-
-	/*
-	 * If a group is already running at full capacity or idle,
-	 * don't include that group in power savings calculations
-	 */
-	if (!sds->power_savings_balance ||
-		sgs->sum_nr_running >= sgs->group_capacity ||
-		!sgs->sum_nr_running)
-		return;
-
-	/*
-	 * Calculate the group which has the least non-idle load.
-	 * This is the group from where we need to pick up the load
-	 * for saving power
-	 */
-	if ((sgs->sum_nr_running < sds->min_nr_running) ||
-	    (sgs->sum_nr_running == sds->min_nr_running &&
-	     group_first_cpu(group) > group_first_cpu(sds->group_min))) {
-		sds->group_min = group;
-		sds->min_nr_running = sgs->sum_nr_running;
-		sds->min_load_per_task = sgs->sum_weighted_load /
-						sgs->sum_nr_running;
-	}
-
-	/*
-	 * Calculate the group which is almost near its
-	 * capacity but still has some space to pick up some load
-	 * from other group and save more power
-	 */
-	if (sgs->sum_nr_running + 1 > sgs->group_capacity)
-		return;
-
-	if (sgs->sum_nr_running > sds->leader_nr_running ||
-	    (sgs->sum_nr_running == sds->leader_nr_running &&
-	     group_first_cpu(group) < group_first_cpu(sds->group_leader))) {
-		sds->group_leader = group;
-		sds->leader_nr_running = sgs->sum_nr_running;
-	}
-}
-
-/**
- * check_power_save_busiest_group - see if there is potential for some power-savings balance
- * @env: load balance environment
- * @sds: Variable containing the statistics of the sched_domain
- *	under consideration.
- *
- * Description:
- * Check if we have potential to perform some power-savings balance.
- * If yes, set the busiest group to be the least loaded group in the
- * sched_domain, so that it's CPUs can be put to idle.
- *
- * Returns 1 if there is potential to perform power-savings balance.
- * Else returns 0.
- */
-static inline
-int check_power_save_busiest_group(struct lb_env *env, struct sd_lb_stats *sds)
-{
-	if (!sds->power_savings_balance)
-		return 0;
-
-	if (sds->this != sds->group_leader ||
-			sds->group_leader == sds->group_min)
-		return 0;
-
-	env->imbalance = sds->min_load_per_task;
-	sds->busiest = sds->group_min;
-
-	return 1;
-
-}
-#else /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
-static inline void init_sd_power_savings_stats(struct sched_domain *sd,
-	struct sd_lb_stats *sds, enum cpu_idle_type idle)
-{
-	return;
-}
-
-static inline void update_sd_power_savings_stats(struct sched_group *group,
-	struct sd_lb_stats *sds, int local_group, struct sg_lb_stats *sgs)
-{
-	return;
-}
-
-static inline
-int check_power_save_busiest_group(struct lb_env *env, struct sd_lb_stats *sds)
-{
-	return 0;
-}
-#endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
-
-
 unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu)
 {
 	return SCHED_POWER_SCALE;
@@ -3932,7 +3780,6 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 	if (child && child->flags & SD_PREFER_SIBLING)
 		prefer_sibling = 1;
 
-	init_sd_power_savings_stats(env->sd, sds, env->idle);
 	load_idx = get_sd_load_idx(env->sd, env->idle);
 
 	do {
@@ -3981,7 +3828,6 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 			sds->group_imb = sgs.group_imb;
 		}
 
-		update_sd_power_savings_stats(sg, sds, local_group, &sgs);
 		sg = sg->next;
 	} while (sg != env->sd->groups);
 }
@@ -4276,12 +4122,6 @@ force_balance:
 	return sds.busiest;
 
 out_balanced:
-	/*
-	 * There is no obvious imbalance. But check if we can do some balancing
-	 * to save power.
-	 */
-	if (check_power_save_busiest_group(env, &sds))
-		return sds.busiest;
 ret:
 	env->imbalance = 0;
 	return NULL;
@@ -4359,28 +4199,6 @@ static int need_active_balance(struct lb_env *env)
 		 */
 		if ((sd->flags & SD_ASYM_PACKING) && env->src_cpu > env->dst_cpu)
 			return 1;
-
-		/*
-		 * The only task running in a non-idle cpu can be moved to this
-		 * cpu in an attempt to completely freeup the other CPU
-		 * package.
-		 *
-		 * The package power saving logic comes from
-		 * find_busiest_group(). If there are no imbalance, then
-		 * f_b_g() will return NULL. However when sched_mc={1,2} then
-		 * f_b_g() will select a group from which a running task may be
-		 * pulled to this cpu in order to make the other package idle.
-		 * If there is no opportunity to make a package idle and if
-		 * there are no imbalance, then f_b_g() will return NULL and no
-		 * action will be taken in load_balance_newidle().
-		 *
-		 * Under normal task pull operation due to imbalance, there
-		 * will be more than one task in the source run queue and
-		 * move_tasks() will succeed.  ld_moved will be true and this
-		 * active balance code will not be triggered.
-		 */
-		if (sched_mc_power_savings < POWERSAVINGS_BALANCE_WAKEUP)
-			return 0;
 	}
 
 	return unlikely(sd->nr_balance_failed > sd->cache_nice_tries+2);
@@ -4700,104 +4518,15 @@ static struct {
 	unsigned long next_balance;     /* in jiffy units */
 } nohz ____cacheline_aligned;
 
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
-		if (sd->flags & flag)
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
-/**
- * find_new_ilb - Finds the optimum idle load balancer for nomination.
- * @cpu:	The cpu which is nominating a new idle_load_balancer.
- *
- * Returns:	Returns the id of the idle load balancer if it exists,
- *		Else, returns >= nr_cpu_ids.
- *
- * This algorithm picks the idle load balancer such that it belongs to a
- * semi-idle powersavings sched_domain. The idea is to try and avoid
- * completely idle packages/cores just for the purpose of idle load balancing
- * when there are other idle cpu's which are better suited for that job.
- */
-static int find_new_ilb(int cpu)
+static inline int find_new_ilb(int call_cpu)
 {
 	int ilb = cpumask_first(nohz.idle_cpus_mask);
-	struct sched_group *ilbg;
-	struct sched_domain *sd;
 
-	/*
-	 * Have idle load balancer selection from semi-idle packages only
-	 * when power-aware load balancing is enabled
-	 */
-	if (!(sched_smt_power_savings || sched_mc_power_savings))
-		goto out_done;
-
-	/*
-	 * Optimize for the case when we have no idle CPUs or only one
-	 * idle CPU. Don't walk the sched_domain hierarchy in such cases
-	 */
-	if (cpumask_weight(nohz.idle_cpus_mask) < 2)
-		goto out_done;
-
-	rcu_read_lock();
-	for_each_flag_domain(cpu, sd, SD_POWERSAVINGS_BALANCE) {
-		ilbg = sd->groups;
-
-		do {
-			if (ilbg->group_weight !=
-				atomic_read(&ilbg->sgp->nr_busy_cpus)) {
-				ilb = cpumask_first_and(nohz.idle_cpus_mask,
-							sched_group_cpus(ilbg));
-				goto unlock;
-			}
-
-			ilbg = ilbg->next;
-
-		} while (ilbg != sd->groups);
-	}
-unlock:
-	rcu_read_unlock();
-
-out_done:
 	if (ilb < nr_cpu_ids && idle_cpu(ilb))
 		return ilb;
 
 	return nr_cpu_ids;
 }
-#else /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
-static inline int find_new_ilb(int call_cpu)
-{
-	return nr_cpu_ids;
-}
-#endif
 
 /*
  * Kick a CPU to do the nohz balancing, if it is time for it. We pick the
diff --git a/tools/power/cpupower/man/cpupower-set.1 b/tools/power/cpupower/man/cpupower-set.1
index c4954a9..9dbd536 100644
--- a/tools/power/cpupower/man/cpupower-set.1
+++ b/tools/power/cpupower/man/cpupower-set.1
@@ -85,15 +85,6 @@ Possible values are:
 savings
 .RE
 
-sched_mc_power_savings is dependent upon SCHED_MC, which is
-itself architecture dependent.
-
-sched_smt_power_savings is dependent upon SCHED_SMT, which
-is itself architecture dependent.
-
-The two files are independent of each other. It is possible
-that one file may be present without the other.
-
 .SH "SEE ALSO"
 cpupower-info(1), cpupower-monitor(1), powertop(1)
 .PP
diff --git a/tools/power/cpupower/utils/helpers/sysfs.c b/tools/power/cpupower/utils/helpers/sysfs.c
index c634302..96e28c1 100644
--- a/tools/power/cpupower/utils/helpers/sysfs.c
+++ b/tools/power/cpupower/utils/helpers/sysfs.c
@@ -362,22 +362,7 @@ char *sysfs_get_cpuidle_driver(void)
  */
 int sysfs_get_sched(const char *smt_mc)
 {
-	unsigned long value;
-	char linebuf[MAX_LINE_LEN];
-	char *endp;
-	char path[SYSFS_PATH_MAX];
-
-	if (strcmp("mc", smt_mc) && strcmp("smt", smt_mc))
-		return -EINVAL;
-
-	snprintf(path, sizeof(path),
-		PATH_TO_CPU "sched_%s_power_savings", smt_mc);
-	if (sysfs_read_file(path, linebuf, MAX_LINE_LEN) == 0)
-		return -1;
-	value = strtoul(linebuf, &endp, 0);
-	if (endp == linebuf || errno == ERANGE)
-		return -1;
-	return value;
+	return -ENODEV;
 }
 
 /*
@@ -388,21 +373,5 @@ int sysfs_get_sched(const char *smt_mc)
  */
 int sysfs_set_sched(const char *smt_mc, int val)
 {
-	char linebuf[MAX_LINE_LEN];
-	char path[SYSFS_PATH_MAX];
-	struct stat statbuf;
-
-	if (strcmp("mc", smt_mc) && strcmp("smt", smt_mc))
-		return -EINVAL;
-
-	snprintf(path, sizeof(path),
-		PATH_TO_CPU "sched_%s_power_savings", smt_mc);
-	sprintf(linebuf, "%d", val);
-
-	if (stat(path, &statbuf) != 0)
-		return -ENODEV;
-
-	if (sysfs_write_file(path, linebuf, MAX_LINE_LEN) == 0)
-		return -1;
-	return 0;
+	return -ENODEV;
 }
