Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583Ab2EOMXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 08:23:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46293 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab2EOMXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 08:23:51 -0400
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: paulmck@linux.vnet.ibm.com, smuckle@quicinc.com, khilman@ti.com,
        Robin.Randhawa@arm.com, suresh.b.siddha@intel.com,
        thebigcorporation@gmail.com, venki@google.com,
        panto@antoniou-consulting.com, mingo@elte.hu, paul.brett@intel.com,
        pdeschrijver@nvidia.com, pjt@google.com, efault@gmx.de,
        fweisbec@gmail.com, geoff@infradead.org, rostedt@goodmis.org,
        tglx@linutronix.de, amit.kucheria@linaro.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linaro-sched-sig@lists.linaro.org,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com>
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
	 <CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 May 2012 14:23:29 +0200
Message-ID: <1337084609.27020.156.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 10:02 +0200, Vincent Guittot wrote:
> 
> Would you like to present the ongoing work around the load balance
> policy and the replacement for sched_mc during the scheduler
> micro-conf ? 

Not sure there's much to say that isn't already said..

As it stands nobody cares (as evident by the total lack of progress
since the last time this all came up), so I've just queued the below
patch.


---
Subject: sched: Remove all power aware scheduling
From: Peter Zijlstra <peterz@infradead.org>
Date: Mon, 09 Jan 2012 11:28:35 +0100

Its been broken forever and nobody cares enough to fix it proper..
remove it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |   25 -
 Documentation/scheduler/sched-domains.txt          |    4 
 arch/x86/kernel/smpboot.c                          |    3 
 drivers/base/cpu.c                                 |    4 
 include/linux/cpu.h                                |    2 
 include/linux/sched.h                              |   47 ---
 include/linux/topology.h                           |    5 
 kernel/sched/core.c                                |   94 -------
 kernel/sched/fair.c                                |  278 ---------------------
 tools/power/cpupower/man/cpupower-set.1            |    9 
 tools/power/cpupower/utils/helpers/sysfs.c         |   35 --
 11 files changed, 4 insertions(+), 502 deletions(-)

--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -9,31 +9,6 @@ Contact:	Linux kernel mailing list <linu
 
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
--- a/Documentation/scheduler/sched-domains.txt
+++ b/Documentation/scheduler/sched-domains.txt
@@ -61,10 +61,6 @@ might have just one domain covering its
 struct sched_domain fields, SD_FLAG_*, SD_*_INIT to get an idea of
 the specifics and what to tune.
 
-For SMT, the architecture must define CONFIG_SCHED_SMT and provide a
-cpumask_t cpu_sibling_map[NR_CPUS], where cpu_sibling_map[i] is the mask of
-all "i"'s siblings as well as "i" itself.
-
 Architectures may retain the regular override the default SD_*_INIT flags
 while using the generic domain builder in kernel/sched.c if they wish to
 retain the traditional SMT->SMP->NUMA topology (or some subset of that). This
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -413,8 +413,7 @@ const struct cpumask *cpu_coregroup_mask
 	 * For perf, we return last level cache shared map.
 	 * And for power savings, we return cpu_core_map
 	 */
-	if ((sched_mc_power_savings || sched_smt_power_savings) &&
-	    !(cpu_has(c, X86_FEATURE_AMD_DCM)))
+	if (!(cpu_has(c, X86_FEATURE_AMD_DCM)))
 		return cpu_core_mask(cpu);
 	else
 		return cpu_llc_shared_mask(cpu);
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
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -36,8 +36,6 @@ extern void cpu_remove_dev_attr(struct d
 extern int cpu_add_dev_attr_group(struct attribute_group *attrs);
 extern void cpu_remove_dev_attr_group(struct attribute_group *attrs);
 
-extern int sched_create_sysfs_power_savings_entries(struct device *dev);
-
 #ifdef CONFIG_HOTPLUG_CPU
 extern void unregister_cpu(struct cpu *cpu);
 extern ssize_t arch_cpu_probe(const char *, size_t);
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
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5920,8 +5920,6 @@ static const struct cpumask *cpu_cpu_mas
 	return cpumask_of_node(cpu_to_node(cpu));
 }
 
-int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
-
 struct sd_data {
 	struct sched_domain **__percpu sd;
 	struct sched_group **__percpu sg;
@@ -6313,7 +6311,6 @@ sd_numa_init(struct sched_domain_topolog
 					| 0*SD_WAKE_AFFINE
 					| 0*SD_PREFER_LOCAL
 					| 0*SD_SHARE_CPUPOWER
-					| 0*SD_POWERSAVINGS_BALANCE
 					| 0*SD_SHARE_PKG_RESOURCES
 					| 1*SD_SERIALIZE
 					| 0*SD_PREFER_SIBLING
@@ -6810,97 +6807,6 @@ void partition_sched_domains(int ndoms_n
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
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2721,7 +2721,7 @@ select_task_rq_fair(struct task_struct *
 		 * If power savings logic is enabled for a domain, see if we
 		 * are not overloaded, if so, don't balance wider.
 		 */
-		if (tmp->flags & (SD_POWERSAVINGS_BALANCE|SD_PREFER_LOCAL)) {
+		if (tmp->flags & (SD_PREFER_LOCAL)) {
 			unsigned long power = 0;
 			unsigned long nr_running = 0;
 			unsigned long capacity;
@@ -2734,9 +2734,6 @@ select_task_rq_fair(struct task_struct *
 
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
@@ -3486,147 +3475,6 @@ static inline int get_sd_load_idx(struct
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
@@ -3932,7 +3780,6 @@ static inline void update_sd_lb_stats(st
 	if (child && child->flags & SD_PREFER_SIBLING)
 		prefer_sibling = 1;
 
-	init_sd_power_savings_stats(env->sd, sds, env->idle);
 	load_idx = get_sd_load_idx(env->sd, env->idle);
 
 	do {
@@ -3981,7 +3828,6 @@ static inline void update_sd_lb_stats(st
 			sds->group_imb = sgs.group_imb;
 		}
 
-		update_sd_power_savings_stats(sg, sds, local_group, &sgs);
 		sg = sg->next;
 	} while (sg != env->sd->groups);
 }
@@ -4278,12 +4124,6 @@ find_busiest_group(struct lb_env *env, c
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
@@ -4361,28 +4201,6 @@ static int need_active_balance(struct lb
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
@@ -4704,104 +4522,10 @@ static struct {
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
-{
-	int ilb = cpumask_first(nohz.idle_cpus_mask);
-	struct sched_group *ilbg;
-	struct sched_domain *sd;
-
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
-	if (ilb < nr_cpu_ids && idle_cpu(ilb))
-		return ilb;
-
-	return nr_cpu_ids;
-}
-#else /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
 static inline int find_new_ilb(int call_cpu)
 {
 	return nr_cpu_ids;
 }
-#endif
 
 /*
  * Kick a CPU to do the nohz balancing, if it is time for it. We pick the
--- a/tools/power/cpupower/man/cpupower-set.1
+++ b/tools/power/cpupower/man/cpupower-set.1
@@ -85,15 +85,6 @@ Adjust the kernel's multi-core scheduler
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


