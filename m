Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936Ab2C1WoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 18:44:23 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:45430 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933290Ab2C1Wn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 18:43:29 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v5 4/5] x86: Move per cpu cpu_core_map to a field in struct cpuinfo_x86
Date: Wed, 28 Mar 2012 19:43:06 -0300
Message-Id: <1332974587-15452-5-git-send-email-kjwinchester@gmail.com>
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
 arch/x86/include/asm/processor.h |    5 +++++
 arch/x86/include/asm/smp.h       |    3 +--
 arch/x86/include/asm/topology.h  |    2 +-
 arch/x86/kernel/smpboot.c        |   11 +----------
 arch/x86/xen/smp.c               |    4 ----
 drivers/cpufreq/powernow-k8.c    |    7 -------
 6 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 774efb5..22af2da 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -115,6 +115,11 @@ struct cpuinfo_x86 {
 	u16			llc_id;
 	/* representing HT siblings of each logical CPU */
 	cpumask_t		sibling_map;
+	/*
+	 * representing all execution threads on a logical CPU, i.e. per
+	 * physical socket
+	 */
+	cpumask_t		core_map;
 } __attribute__((__aligned__(SMP_CACHE_BYTES)));
 
 #define X86_VENDOR_INTEL	0
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index ef01857..408152e 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -31,7 +31,6 @@ static inline bool cpu_has_ht_siblings(void)
 	return has_siblings;
 }
 
-DECLARE_PER_CPU(cpumask_var_t, cpu_core_map);
 DECLARE_PER_CPU(int, cpu_number);
 
 static inline struct cpumask *cpu_sibling_mask(int cpu)
@@ -41,7 +40,7 @@ static inline struct cpumask *cpu_sibling_mask(int cpu)
 
 static inline struct cpumask *cpu_core_mask(int cpu)
 {
-	return per_cpu(cpu_core_map, cpu);
+	return &cpu_data(cpu).core_map;
 }
 
 static inline struct cpumask *cpu_llc_shared_mask(int cpu)
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 5297acbf..5ffa396 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -160,7 +160,7 @@ extern const struct cpumask *cpu_coregroup_mask(int cpu);
 #ifdef ENABLE_TOPO_DEFINES
 #define topology_physical_package_id(cpu)	(cpu_data(cpu).phys_proc_id)
 #define topology_core_id(cpu)			(cpu_data(cpu).cpu_core_id)
-#define topology_core_cpumask(cpu)		(per_cpu(cpu_core_map, cpu))
+#define topology_core_cpumask(cpu)		(&cpu_data(cpu).core_map)
 #define topology_thread_cpumask(cpu)		(&cpu_data(cpu).sibling_map)
 
 /* indicates that pointers to the topology cpumask_t maps are valid */
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 4946501..88b8320 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -116,10 +116,6 @@ static struct task_struct *idle_thread_array[NR_CPUS] __cpuinitdata ;
 int smp_num_siblings = 1;
 EXPORT_SYMBOL(smp_num_siblings);
 
-/* representing HT and core siblings of each logical CPU */
-DEFINE_PER_CPU(cpumask_var_t, cpu_core_map);
-EXPORT_PER_CPU_SYMBOL(cpu_core_map);
-
 /* Per CPU bogomips and other parameters */
 DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
@@ -391,7 +387,7 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	/*
 	 * For perf, we return last level cache shared map.
-	 * And for power savings, we return cpu_core_map
+	 * And for power savings, we return core map.
 	 */
 	if ((sched_mc_power_savings || sched_smt_power_savings) &&
 	    !(cpu_has(c, X86_FEATURE_AMD_DCM)))
@@ -1015,8 +1011,6 @@ static void __init smp_cpu_index_default(void)
  */
 void __init native_smp_prepare_cpus(unsigned int max_cpus)
 {
-	unsigned int i;
-
 	preempt_disable();
 	smp_cpu_index_default();
 
@@ -1028,9 +1022,6 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	mb();
 
 	current_thread_info()->cpu = 0;  /* needed? */
-	for_each_possible_cpu(i) {
-		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
-	}
 	set_cpu_sibling_map(0);
 
 
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index c80cf8b..53f774d 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -212,7 +212,6 @@ static void __init xen_smp_prepare_boot_cpu(void)
 static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 {
 	unsigned cpu;
-	unsigned int i;
 
 	if (skip_ioapic_setup) {
 		char *m = (max_cpus == 0) ?
@@ -228,9 +227,6 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 	smp_store_cpu_info(0);
 	cpu_data(0).x86_max_cores = 1;
 
-	for_each_possible_cpu(i) {
-		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
-	}
 	set_cpu_sibling_map(0);
 
 	if (xen_smp_intr_init(0))
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index c0e8164..f81fdb5 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -67,13 +67,6 @@ static struct msr __percpu *msrs;
 
 static struct cpufreq_driver cpufreq_amd64_driver;
 
-#ifndef CONFIG_SMP
-static inline const struct cpumask *cpu_core_mask(int cpu)
-{
-	return cpumask_of(0);
-}
-#endif
-
 /* Return a frequency in MHz, given an input fid */
 static u32 find_freq_from_fid(u32 fid)
 {
-- 
1.7.9.5

