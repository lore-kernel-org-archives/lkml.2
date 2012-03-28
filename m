Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053Ab2C1Wox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 18:44:53 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41590 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933285Ab2C1Wn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 18:43:27 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v5 3/5] x86: Move per cpu cpu_sibling_map to a field in struct cpuinfo_x86
Date: Wed, 28 Mar 2012 19:43:05 -0300
Message-Id: <1332974587-15452-4-git-send-email-kjwinchester@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1332974587-15452-1-git-send-email-kjwinchester@gmail.com>
References: <20120227115905.GB9943@elte.hu>
 <1332974587-15452-1-git-send-email-kjwinchester@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simplifies the various code paths using this field as it
groups the per-cpu data together.

Acked-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
---
 arch/x86/include/asm/perf_event_p4.h |    2 +-
 arch/x86/include/asm/processor.h     |    2 ++
 arch/x86/include/asm/smp.h           |    3 +--
 arch/x86/include/asm/topology.h      |    2 +-
 arch/x86/kernel/smpboot.c            |    5 -----
 arch/x86/oprofile/op_model_p4.c      |    5 +----
 arch/x86/xen/smp.c                   |    1 -
 drivers/cpufreq/p4-clockmod.c        |    2 --
 drivers/cpufreq/speedstep-ich.c      |    2 --
 drivers/hwmon/coretemp.c             |    4 ----
 10 files changed, 6 insertions(+), 22 deletions(-)

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
index 6dbe14e..774efb5 100644
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
index aba8895..ef01857 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -31,13 +31,12 @@ static inline bool cpu_has_ht_siblings(void)
 	return has_siblings;
 }
 
-DECLARE_PER_CPU(cpumask_var_t, cpu_sibling_map);
 DECLARE_PER_CPU(cpumask_var_t, cpu_core_map);
 DECLARE_PER_CPU(int, cpu_number);
 
 static inline struct cpumask *cpu_sibling_mask(int cpu)
 {
-	return per_cpu(cpu_sibling_map, cpu);
+	return &cpu_data(cpu).sibling_map;
 }
 
 static inline struct cpumask *cpu_core_mask(int cpu)
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
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index abc25d8..4946501 100644
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
@@ -1033,7 +1029,6 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 
 	current_thread_info()->cpu = 0;  /* needed? */
 	for_each_possible_cpu(i) {
-		zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
 		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
 	}
 	set_cpu_sibling_map(0);
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
index df3d5cb..c80cf8b 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -229,7 +229,6 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 	cpu_data(0).x86_max_cores = 1;
 
 	for_each_possible_cpu(i) {
-		zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
 		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
 	}
 	set_cpu_sibling_map(0);
diff --git a/drivers/cpufreq/p4-clockmod.c b/drivers/cpufreq/p4-clockmod.c
index 827629c9..67bf403 100644
--- a/drivers/cpufreq/p4-clockmod.c
+++ b/drivers/cpufreq/p4-clockmod.c
@@ -204,9 +204,7 @@ static int cpufreq_p4_cpu_init(struct cpufreq_policy *policy)
 	int cpuid = 0;
 	unsigned int i;
 
-#ifdef CONFIG_SMP
 	cpumask_copy(policy->cpus, cpu_sibling_mask(policy->cpu));
-#endif
 
 	/* Errata workaround */
 	cpuid = (c->x86 << 8) | (c->x86_model << 4) | c->x86_mask;
diff --git a/drivers/cpufreq/speedstep-ich.c b/drivers/cpufreq/speedstep-ich.c
index 7432b3a..f0c48bc 100644
--- a/drivers/cpufreq/speedstep-ich.c
+++ b/drivers/cpufreq/speedstep-ich.c
@@ -333,9 +333,7 @@ static int speedstep_cpu_init(struct cpufreq_policy *policy)
 	struct get_freqs gf;
 
 	/* only run on CPU to be set, or on its sibling */
-#ifdef CONFIG_SMP
 	cpumask_copy(policy->cpus, cpu_sibling_mask(policy->cpu));
-#endif
 	policy_cpu = cpumask_any_and(policy->cpus, cpu_online_mask);
 
 	/* detect low and high frequency and transition latency */
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 0d3141f..3399dc3 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -62,11 +62,7 @@ MODULE_PARM_DESC(tjmax, "TjMax value in degrees Celsius");
 #define TO_CORE_ID(cpu)		(cpu_data(cpu).cpu_core_id)
 #define TO_ATTR_NO(cpu)		(TO_CORE_ID(cpu) + BASE_SYSFS_ATTR_NO)
 
-#ifdef CONFIG_SMP
 #define for_each_sibling(i, cpu)	for_each_cpu(i, cpu_sibling_mask(cpu))
-#else
-#define for_each_sibling(i, cpu)	for (i = 0; false; )
-#endif
 
 /*
  * Per-Core Temperature Data
-- 
1.7.9.5

