Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab1AUXag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 18:30:36 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:17462 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab1AUXaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 18:30:35 -0500
Message-ID: <4D3A16E8.5020608@kernel.org>
Date: Fri, 21 Jan 2011 15:29:44 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Robert Richter <robert.richter@amd.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
CC: Hans Rosenfeld <hans.rosenfeld@amd.com>,
        Alok N Kataria <akataria@vmware.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Move llc_shared_map out of cpu_info
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cpu_info is already with per_cpu, We can take llc_shared_map out of cpu_info,
and declare it as per_cpu variable directly.

So later referencing could be simple and directly instead of diving to find
cpu_info at first.

Also could make smp_store_cpu_info() much simple to avoid to do save and restore trick.


Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/processor.h      |    4 ---
 arch/x86/include/asm/smp.h            |    7 ++++++
 arch/x86/kernel/cpu/intel_cacheinfo.c |    4 +--
 arch/x86/kernel/cpu/mcheck/mce_amd.c  |    7 +-----
 arch/x86/kernel/smpboot.c             |   38 ++++++++--------------------------
 5 files changed, 21 insertions(+), 39 deletions(-)

Index: linux-2.6/arch/x86/include/asm/processor.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/processor.h
+++ linux-2.6/arch/x86/include/asm/processor.h
@@ -94,10 +94,6 @@ struct cpuinfo_x86 {
 	int			x86_cache_alignment;	/* In bytes */
 	int			x86_power;
 	unsigned long		loops_per_jiffy;
-#ifdef CONFIG_SMP
-	/* cpus sharing the last level cache: */
-	cpumask_var_t		llc_shared_map;
-#endif
 	/* cpuid returned max cores value: */
 	u16			 x86_max_cores;
 	u16			apicid;
Index: linux-2.6/arch/x86/include/asm/smp.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/smp.h
+++ linux-2.6/arch/x86/include/asm/smp.h
@@ -23,6 +23,8 @@ extern unsigned int num_processors;
 
 DECLARE_PER_CPU(cpumask_var_t, cpu_sibling_map);
 DECLARE_PER_CPU(cpumask_var_t, cpu_core_map);
+/* cpus sharing the last level cache: */
+DECLARE_PER_CPU(cpumask_var_t, cpu_llc_shared_map);
 DECLARE_PER_CPU(u16, cpu_llc_id);
 DECLARE_PER_CPU(int, cpu_number);
 
@@ -36,6 +38,11 @@ static inline struct cpumask *cpu_core_m
 	return per_cpu(cpu_core_map, cpu);
 }
 
+static inline struct cpumask *cpu_llc_shared_mask(int cpu)
+{
+	return per_cpu(cpu_llc_shared_map, cpu);
+}
+
 DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
 DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
 
Index: linux-2.6/arch/x86/kernel/cpu/intel_cacheinfo.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ linux-2.6/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -732,11 +732,11 @@ static void __cpuinit cache_shared_cpu_m
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
 	if ((index == 3) && (c->x86_vendor == X86_VENDOR_AMD)) {
-		for_each_cpu(i, c->llc_shared_map) {
+		for_each_cpu(i, cpu_llc_shared_mask(cpu)) {
 			if (!per_cpu(ici_cpuid4_info, i))
 				continue;
 			this_leaf = CPUID4_INFO_IDX(i, index);
-			for_each_cpu(sibling, c->llc_shared_map) {
+			for_each_cpu(sibling, cpu_llc_shared_mask(cpu)) {
 				if (!cpu_online(sibling))
 					continue;
 				set_bit(sibling, this_leaf->shared_cpu_map);
Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce_amd.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -527,15 +527,12 @@ static __cpuinit int threshold_create_ba
 	int i, err = 0;
 	struct threshold_bank *b = NULL;
 	char name[32];
-#ifdef CONFIG_SMP
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
-#endif
 
 	sprintf(name, "threshold_bank%i", bank);
 
 #ifdef CONFIG_SMP
 	if (cpu_data(cpu).cpu_core_id && shared_bank[bank]) {	/* symlink */
-		i = cpumask_first(c->llc_shared_map);
+		i = cpumask_first(cpu_llc_shared_mask(cpu));
 
 		/* first core not up yet */
 		if (cpu_data(i).cpu_core_id)
@@ -555,7 +552,7 @@ static __cpuinit int threshold_create_ba
 		if (err)
 			goto out;
 
-		cpumask_copy(b->cpus, c->llc_shared_map);
+		cpumask_copy(b->cpus, cpu_llc_shared_mask(cpu));
 		per_cpu(threshold_banks, cpu)[bank] = b;
 
 		goto out;
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -130,6 +130,8 @@ EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
 DEFINE_PER_CPU(cpumask_var_t, cpu_core_map);
 EXPORT_PER_CPU_SYMBOL(cpu_core_map);
 
+DEFINE_PER_CPU(cpumask_var_t, cpu_llc_shared_map);
+
 /* Per CPU bogomips and other parameters */
 DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
@@ -355,23 +357,6 @@ notrace static void __cpuinit start_seco
 	cpu_idle();
 }
 
-#ifdef CONFIG_CPUMASK_OFFSTACK
-/* In this case, llc_shared_map is a pointer to a cpumask. */
-static inline void copy_cpuinfo_x86(struct cpuinfo_x86 *dst,
-				    const struct cpuinfo_x86 *src)
-{
-	struct cpumask *llc = dst->llc_shared_map;
-	*dst = *src;
-	dst->llc_shared_map = llc;
-}
-#else
-static inline void copy_cpuinfo_x86(struct cpuinfo_x86 *dst,
-				    const struct cpuinfo_x86 *src)
-{
-	*dst = *src;
-}
-#endif /* CONFIG_CPUMASK_OFFSTACK */
-
 /*
  * The bootstrap kernel entry code has set these up. Save them for
  * a given CPU
@@ -381,7 +366,7 @@ void __cpuinit smp_store_cpu_info(int id
 {
 	struct cpuinfo_x86 *c = &cpu_data(id);
 
-	copy_cpuinfo_x86(c, &boot_cpu_data);
+	*c = boot_cpu_data;
 	c->cpu_index = id;
 	if (id != 0)
 		identify_secondary_cpu(c);
@@ -389,15 +374,12 @@ void __cpuinit smp_store_cpu_info(int id
 
 static void __cpuinit link_thread_siblings(int cpu1, int cpu2)
 {
-	struct cpuinfo_x86 *c1 = &cpu_data(cpu1);
-	struct cpuinfo_x86 *c2 = &cpu_data(cpu2);
-
 	cpumask_set_cpu(cpu1, cpu_sibling_mask(cpu2));
 	cpumask_set_cpu(cpu2, cpu_sibling_mask(cpu1));
 	cpumask_set_cpu(cpu1, cpu_core_mask(cpu2));
 	cpumask_set_cpu(cpu2, cpu_core_mask(cpu1));
-	cpumask_set_cpu(cpu1, c2->llc_shared_map);
-	cpumask_set_cpu(cpu2, c1->llc_shared_map);
+	cpumask_set_cpu(cpu1, cpu_llc_shared_mask(cpu2));
+	cpumask_set_cpu(cpu2, cpu_llc_shared_mask(cpu1));
 }
 
 
@@ -425,7 +407,7 @@ void __cpuinit set_cpu_sibling_map(int c
 		cpumask_set_cpu(cpu, cpu_sibling_mask(cpu));
 	}
 
-	cpumask_set_cpu(cpu, c->llc_shared_map);
+	cpumask_set_cpu(cpu, cpu_llc_shared_mask(cpu));
 
 	if (__this_cpu_read(cpu_info.x86_max_cores) == 1) {
 		cpumask_copy(cpu_core_mask(cpu), cpu_sibling_mask(cpu));
@@ -436,8 +418,8 @@ void __cpuinit set_cpu_sibling_map(int c
 	for_each_cpu(i, cpu_sibling_setup_mask) {
 		if (per_cpu(cpu_llc_id, cpu) != BAD_APICID &&
 		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i)) {
-			cpumask_set_cpu(i, c->llc_shared_map);
-			cpumask_set_cpu(cpu, cpu_data(i).llc_shared_map);
+			cpumask_set_cpu(i, cpu_llc_shared_mask(cpu));
+			cpumask_set_cpu(cpu, cpu_llc_shared_mask(i));
 		}
 		if (c->phys_proc_id == cpu_data(i).phys_proc_id) {
 			cpumask_set_cpu(i, cpu_core_mask(cpu));
@@ -476,7 +458,7 @@ const struct cpumask *cpu_coregroup_mask
 	    !(cpu_has(c, X86_FEATURE_AMD_DCM)))
 		return cpu_core_mask(cpu);
 	else
-		return c->llc_shared_map;
+		return cpu_llc_shared_mask(cpu);
 }
 
 static void impress_friends(void)
@@ -1103,7 +1085,7 @@ void __init native_smp_prepare_cpus(unsi
 	for_each_possible_cpu(i) {
 		zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
 		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
-		zalloc_cpumask_var(&cpu_data(i).llc_shared_map, GFP_KERNEL);
+		zalloc_cpumask_var(&per_cpu(cpu_llc_shared_map, i), GFP_KERNEL);
 	}
 	set_cpu_sibling_map(0);
 
