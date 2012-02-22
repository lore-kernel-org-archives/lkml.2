Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab2BVBqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:46:04 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:47950 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab2BVBp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:45:59 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of kjwinchester@gmail.com designates 10.229.78.203 as permitted sender) smtp.mail=kjwinchester@gmail.com; dkim=pass header.i=kjwinchester@gmail.com
From: Kevin Winchester <kjwinchester@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] x86: Move per cpu cpu_sibling_map to a field in struct cpuinfo_x86
Date: Tue, 21 Feb 2012 21:45:42 -0400
Message-Id: <1329875144-560-4-git-send-email-kjwinchester@gmail.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329875144-560-1-git-send-email-kjwinchester@gmail.com>
References: <20120221153935.GE2486@x1.osrc.amd.com>
 <1329875144-560-1-git-send-email-kjwinchester@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simplifies the various code paths using this field as it
groups the per-cpu data together.

Acked-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
---
 arch/x86/include/asm/perf_event_p4.h  |    2 +-
 arch/x86/include/asm/processor.h      |    2 ++
 arch/x86/include/asm/smp.h            |    6 ------
 arch/x86/include/asm/topology.h       |    2 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c |    4 ++--
 arch/x86/kernel/smpboot.c             |   27 +++++++++++----------------
 arch/x86/oprofile/op_model_p4.c       |    5 +----
 arch/x86/xen/smp.c                    |    1 -
 drivers/cpufreq/p4-clockmod.c         |    4 +---
 drivers/cpufreq/speedstep-ich.c       |    6 +++---
 drivers/hwmon/coretemp.c              |    6 +-----
 11 files changed, 23 insertions(+), 42 deletions(-)

diff --git a/arch/x86/include/asm/perf_event_p4.h b/arch/x86/include/asm/perf_event_p4.h
index 4f7e67e..29a65c2 100644
--- a/arch/x86/include/asm/perf_event_p4.h
+++ b/arch/x86/include/asm/perf_event_p4.h
@@ -189,7 +189,7 @@ static inline int p4_ht_thread(int cpu)
 {
 #ifdef CONFIG_SMP
 	if (smp_num_siblings == 2)
-		return cpu != cpumask_first(__get_cpu_var(cpu_sibling_map));
+		return cpu != cpumask_first(&cpu_data(cpu).sibling_map));
 #endif
 	return 0;
 }
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 2ba6d0e..266eaee 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -113,6 +113,8 @@ struct cpuinfo_x86 {
 	/* CPUs sharing the last level cache: */
 	cpumask_t		llc_shared_map;
 	u16			llc_id;
+	/* representing HT siblings of each logical CPU */
+	cpumask_t		sibling_map;
 } __attribute__((__aligned__(SMP_CACHE_BYTES)));
 
 #define X86_VENDOR_INTEL	0
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 40d1c96..b5e7cd2 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -31,15 +31,9 @@ static inline bool cpu_has_ht_siblings(void)
 	return has_siblings;
 }
 
-DECLARE_PER_CPU(cpumask_var_t, cpu_sibling_map);
 DECLARE_PER_CPU(cpumask_var_t, cpu_core_map);
 DECLARE_PER_CPU(int, cpu_number);
 
-static inline struct cpumask *cpu_sibling_mask(int cpu)
-{
-	return per_cpu(cpu_sibling_map, cpu);
-}
-
 static inline struct cpumask *cpu_core_mask(int cpu)
 {
 	return per_cpu(cpu_core_map, cpu);
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index b9676ae..5297acbf 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -161,7 +161,7 @@ extern const struct cpumask *cpu_coregroup_mask(int cpu);
 #define topology_physical_package_id(cpu)	(cpu_data(cpu).phys_proc_id)
 #define topology_core_id(cpu)			(cpu_data(cpu).cpu_core_id)
 #define topology_core_cpumask(cpu)		(per_cpu(cpu_core_map, cpu))
-#define topology_thread_cpumask(cpu)		(per_cpu(cpu_sibling_map, cpu))
+#define topology_thread_cpumask(cpu)		(&cpu_data(cpu).sibling_map)
 
 /* indicates that pointers to the topology cpumask_t maps are valid */
 #define arch_provides_topology_pointers		yes
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 5ddd6ef..7787d33 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -739,11 +739,11 @@ static int __cpuinit cache_shared_amd_cpu_map_setup(unsigned int cpu, int index)
 		}
 	} else if ((c->x86 == 0x15) && ((index == 1) || (index == 2))) {
 		ret = 1;
-		for_each_cpu(i, cpu_sibling_mask(cpu)) {
+		for_each_cpu(i, &c->sibling_map) {
 			if (!per_cpu(ici_cpuid4_info, i))
 				continue;
 			this_leaf = CPUID4_INFO_IDX(i, index);
-			for_each_cpu(sibling, cpu_sibling_mask(cpu)) {
+			for_each_cpu(sibling, &c->sibling_map) {
 				if (!cpu_online(sibling))
 					continue;
 				set_bit(sibling, this_leaf->shared_cpu_map);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index fb2ef30..991d17b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -116,10 +116,6 @@ static struct task_struct *idle_thread_array[NR_CPUS] __cpuinitdata ;
 int smp_num_siblings = 1;
 EXPORT_SYMBOL(smp_num_siblings);
 
-/* representing HT siblings of each logical CPU */
-DEFINE_PER_CPU(cpumask_var_t, cpu_sibling_map);
-EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
-
 /* representing HT and core siblings of each logical CPU */
 DEFINE_PER_CPU(cpumask_var_t, cpu_core_map);
 EXPORT_PER_CPU_SYMBOL(cpu_core_map);
@@ -328,8 +324,8 @@ void __cpuinit smp_store_cpu_info(int id)
 
 static void __cpuinit link_thread_siblings(int cpu1, int cpu2)
 {
-	cpumask_set_cpu(cpu1, cpu_sibling_mask(cpu2));
-	cpumask_set_cpu(cpu2, cpu_sibling_mask(cpu1));
+	cpumask_set_cpu(cpu1, &cpu_data(cpu2).sibling_map);
+	cpumask_set_cpu(cpu2, &cpu_data(cpu1).sibling_map);
 	cpumask_set_cpu(cpu1, cpu_core_mask(cpu2));
 	cpumask_set_cpu(cpu2, cpu_core_mask(cpu1));
 	cpumask_set_cpu(cpu1, &cpu_data(cpu2).llc_shared_map);
@@ -359,13 +355,13 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 			}
 		}
 	} else {
-		cpumask_set_cpu(cpu, cpu_sibling_mask(cpu));
+		cpumask_set_cpu(cpu, &c->sibling_map);
 	}
 
 	cpumask_set_cpu(cpu, &c->llc_shared_map);
 
 	if (__this_cpu_read(cpu_info.x86_max_cores) == 1) {
-		cpumask_copy(cpu_core_mask(cpu), cpu_sibling_mask(cpu));
+		cpumask_copy(cpu_core_mask(cpu), &c->sibling_map);
 		c->booted_cores = 1;
 		return;
 	}
@@ -383,12 +379,12 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 			/*
 			 *  Does this new cpu bringup a new core?
 			 */
-			if (cpumask_weight(cpu_sibling_mask(cpu)) == 1) {
+			if (cpumask_weight(&c->sibling_map) == 1) {
 				/*
 				 * for each core in package, increment
 				 * the booted_cores for this new cpu
 				 */
-				if (cpumask_first(cpu_sibling_mask(i)) == i)
+				if (cpumask_first(&o->sibling_map) == i)
 					c->booted_cores++;
 				/*
 				 * increment the core count for all
@@ -910,7 +906,7 @@ static __init void disable_smp(void)
 		physid_set_mask_of_physid(boot_cpu_physical_apicid, &phys_cpu_present_map);
 	else
 		physid_set_mask_of_physid(0, &phys_cpu_present_map);
-	cpumask_set_cpu(0, cpu_sibling_mask(0));
+	cpumask_set_cpu(0, &cpu_data(0).sibling_map);
 	cpumask_set_cpu(0, cpu_core_mask(0));
 }
 
@@ -1048,7 +1044,6 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 
 	current_thread_info()->cpu = 0;  /* needed? */
 	for_each_possible_cpu(i) {
-		zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
 		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
 	}
 	set_cpu_sibling_map(0);
@@ -1243,13 +1238,13 @@ static void remove_siblinginfo(int cpu)
 		/*/
 		 * last thread sibling in this cpu core going down
 		 */
-		if (cpumask_weight(cpu_sibling_mask(cpu)) == 1)
+		if (cpumask_weight(&c->sibling_map) == 1)
 			cpu_data(sibling).booted_cores--;
 	}
 
-	for_each_cpu(sibling, cpu_sibling_mask(cpu))
-		cpumask_clear_cpu(cpu, cpu_sibling_mask(sibling));
-	cpumask_clear(cpu_sibling_mask(cpu));
+	for_each_cpu(sibling, &c->sibling_map)
+		cpumask_clear_cpu(cpu, &c->sibling_map);
+	cpumask_clear(&c->sibling_map);
 	cpumask_clear(cpu_core_mask(cpu));
 	c->phys_proc_id = 0;
 	c->cpu_core_id = 0;
diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index 98ab130..ae3503e 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -370,11 +370,8 @@ static struct p4_event_binding p4_events[NUM_EVENTS] = {
    or "odd" part of all the divided resources. */
 static unsigned int get_stagger(void)
 {
-#ifdef CONFIG_SMP
 	int cpu = smp_processor_id();
-	return cpu != cpumask_first(__get_cpu_var(cpu_sibling_map));
-#endif
-	return 0;
+	return cpu != cpumask_first(&cpu_data(cpu).sibling_map);
 }
 
 
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index b9f7a86..00f32c0 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -223,7 +223,6 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 	cpu_data(0).x86_max_cores = 1;
 
 	for_each_possible_cpu(i) {
-		zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
 		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
 	}
 	set_cpu_sibling_map(0);
diff --git a/drivers/cpufreq/p4-clockmod.c b/drivers/cpufreq/p4-clockmod.c
index 6be3e07..a14b9b0 100644
--- a/drivers/cpufreq/p4-clockmod.c
+++ b/drivers/cpufreq/p4-clockmod.c
@@ -203,9 +203,7 @@ static int cpufreq_p4_cpu_init(struct cpufreq_policy *policy)
 	int cpuid = 0;
 	unsigned int i;
 
-#ifdef CONFIG_SMP
-	cpumask_copy(policy->cpus, cpu_sibling_mask(policy->cpu));
-#endif
+	cpumask_copy(policy->cpus, &c->sibling_map);
 
 	/* Errata workaround */
 	cpuid = (c->x86 << 8) | (c->x86_model << 4) | c->x86_mask;
diff --git a/drivers/cpufreq/speedstep-ich.c b/drivers/cpufreq/speedstep-ich.c
index a748ce7..630926a 100644
--- a/drivers/cpufreq/speedstep-ich.c
+++ b/drivers/cpufreq/speedstep-ich.c
@@ -326,14 +326,14 @@ static void get_freqs_on_cpu(void *_get_freqs)
 
 static int speedstep_cpu_init(struct cpufreq_policy *policy)
 {
+	struct cpuinfo_x86 *c = &cpu_data(policy->cpu);
 	int result;
 	unsigned int policy_cpu, speed;
 	struct get_freqs gf;
 
 	/* only run on CPU to be set, or on its sibling */
-#ifdef CONFIG_SMP
-	cpumask_copy(policy->cpus, cpu_sibling_mask(policy->cpu));
-#endif
+	cpumask_copy(policy->cpus, c->sibling_map);
+
 	policy_cpu = cpumask_any_and(policy->cpus, cpu_online_mask);
 
 	/* detect low and high frequency and transition latency */
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index a6c6ec3..fdf1590 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -61,11 +61,7 @@ MODULE_PARM_DESC(tjmax, "TjMax value in degrees Celsius");
 #define TO_CORE_ID(cpu)		cpu_data(cpu).cpu_core_id
 #define TO_ATTR_NO(cpu)		(TO_CORE_ID(cpu) + BASE_SYSFS_ATTR_NO)
 
-#ifdef CONFIG_SMP
-#define for_each_sibling(i, cpu)	for_each_cpu(i, cpu_sibling_mask(cpu))
-#else
-#define for_each_sibling(i, cpu)	for (i = 0; false; )
-#endif
+#define for_each_sibling(i, cpu)	for_each_cpu(i, &cpu_data(cpu).sibling_map)
 
 /*
  * Per-Core Temperature Data
-- 
1.7.9

