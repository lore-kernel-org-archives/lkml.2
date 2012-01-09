Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab2AIK2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 05:28:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:39403 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab2AIK2o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 05:28:44 -0500
Message-ID: <1326104915.2442.53.camel@twins>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
From: Peter Zijlstra <peterz@infradead.org>
To: Youquan Song <youquan.song@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
        hpa@zytor.com, akpm@linux-foundation.org, stable@vger.kernel.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com, len.brown@intel.com,
        anhua.xu@intel.com, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>,
        Paul Turner <pjt@google.com>
Date: Mon, 09 Jan 2012 11:28:35 +0100
In-Reply-To: <1326103578.2442.50.camel@twins>
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com>
	 <1326103578.2442.50.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-09 at 11:06 +0100, Peter Zijlstra wrote:
> I'm >< close to committing a patch removing all the power_saving
> magic from the scheduler. 

Unless someone steps up that says they care about this crap and are
willing to clean it up this goes in...

And that very much includes ripping out the current interface and
replacing it with something sane, the current setup of {0,1,2}x{0,1,2}
possible configuration settings is completely unacceptable, esp since
people seem to want to inflate that to 27 or worse.

---
 Documentation/ABI/testing/sysfs-devices-system-cpu |   25 ----
 Documentation/scheduler/sched-domains.txt          |    4 -
 arch/x86/kernel/smpboot.c                          |    3 +-
 drivers/base/cpu.c                                 |    4 -
 include/linux/cpu.h                                |    2 -
 include/linux/sched.h                              |   46 --------
 include/linux/topology.h                           |    4 -
 kernel/sched/core.c                                |   95 ----------------
 kernel/sched/fair.c                                |  116 +-------------------
 tools/power/cpupower/man/cpupower-set.1            |    9 --
 tools/power/cpupower/utils/helpers/sysfs.c         |   35 +------
 11 files changed, 4 insertions(+), 339 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index e7be75b..5dab364 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -9,31 +9,6 @@ Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
 
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
@@ -61,10 +61,6 @@ might have just one domain covering its one NUMA level.
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
index 66d250c..5f33068 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -414,8 +414,7 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
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
index 3991502..b0c9b87 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -259,10 +259,6 @@ int __init cpu_dev_init(void)
 	int err;
 
 	err = sysdev_class_register(&cpu_sysdev_class);
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-	if (!err)
-		err = sched_create_sysfs_power_savings_entries(&cpu_sysdev_class);
-#endif
 
 	return err;
 }
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 305c263..9a2fdcb 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -35,8 +35,6 @@ extern void cpu_remove_sysdev_attr(struct sysdev_attribute *attr);
 extern int cpu_add_sysdev_attr_group(struct attribute_group *attrs);
 extern void cpu_remove_sysdev_attr_group(struct attribute_group *attrs);
 
-extern int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls);
-
 #ifdef CONFIG_HOTPLUG_CPU
 extern void unregister_cpu(struct cpu *cpu);
 extern ssize_t arch_cpu_probe(const char *, size_t);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index cf0eb34..65985d3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -848,54 +848,8 @@ enum cpu_idle_type {
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
index e26db03..3416d5e 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -135,8 +135,6 @@ int arch_update_cpu_topology(void);
 				| 0*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
-				| sd_balance_for_mc_power()		\
-				| sd_power_saving_flags()		\
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
@@ -168,8 +166,6 @@ int arch_update_cpu_topology(void);
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
-				| sd_balance_for_package_power()	\
-				| sd_power_saving_flags()		\
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4dbfd04..ee2bcfd 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5924,8 +5924,6 @@ static const struct cpumask *cpu_cpu_mask(int cpu)
 	return cpumask_of_node(cpu_to_node(cpu));
 }
 
-int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
-
 struct sd_data {
 	struct sched_domain **__percpu sd;
 	struct sched_group **__percpu sg;
@@ -6635,99 +6633,6 @@ void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
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
-static ssize_t sched_mc_power_savings_show(struct sysdev_class *class,
-					   struct sysdev_class_attribute *attr,
-					   char *page)
-{
-	return sprintf(page, "%u\n", sched_mc_power_savings);
-}
-static ssize_t sched_mc_power_savings_store(struct sysdev_class *class,
-					    struct sysdev_class_attribute *attr,
-					    const char *buf, size_t count)
-{
-	return sched_power_savings_store(buf, count, 0);
-}
-static SYSDEV_CLASS_ATTR(sched_mc_power_savings, 0644,
-			 sched_mc_power_savings_show,
-			 sched_mc_power_savings_store);
-#endif
-
-#ifdef CONFIG_SCHED_SMT
-static ssize_t sched_smt_power_savings_show(struct sysdev_class *dev,
-					    struct sysdev_class_attribute *attr,
-					    char *page)
-{
-	return sprintf(page, "%u\n", sched_smt_power_savings);
-}
-static ssize_t sched_smt_power_savings_store(struct sysdev_class *dev,
-					     struct sysdev_class_attribute *attr,
-					     const char *buf, size_t count)
-{
-	return sched_power_savings_store(buf, count, 1);
-}
-static SYSDEV_CLASS_ATTR(sched_smt_power_savings, 0644,
-		   sched_smt_power_savings_show,
-		   sched_smt_power_savings_store);
-#endif
-
-int __init sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
-{
-	int err = 0;
-
-#ifdef CONFIG_SCHED_SMT
-	if (smt_capable())
-		err = sysfs_create_file(&cls->kset.kobj,
-					&attr_sched_smt_power_savings.attr);
-#endif
-#ifdef CONFIG_SCHED_MC
-	if (!err && mc_capable())
-		err = sysfs_create_file(&cls->kset.kobj,
-					&attr_sched_mc_power_savings.attr);
-#endif
-	return err;
-}
-#endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
-
 /*
  * Update cpusets according to cpu_active mask.  If cpusets are
  * disabled, cpuset_update_active_cpus() becomes a simple wrapper
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8e42de9..f0f140b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4413,27 +4413,7 @@ static int need_active_balance(struct sched_domain *sd, int idle,
 		if ((sd->flags & SD_ASYM_PACKING) && busiest_cpu > this_cpu)
 			return 1;
 
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
+		return 0;
 	}
 
 	return unlikely(sd->nr_balance_failed > sd->cache_nice_tries+2);
@@ -4735,104 +4715,10 @@ static struct {
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
diff --git a/tools/power/cpupower/man/cpupower-set.1 b/tools/power/cpupower/man/cpupower-set.1
index c4954a9..9dbd536 100644
--- a/tools/power/cpupower/man/cpupower-set.1
+++ b/tools/power/cpupower/man/cpupower-set.1
@@ -85,15 +85,6 @@ Adjust the kernel's multi-core scheduler support.
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
index c634302..5650127 100644
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

