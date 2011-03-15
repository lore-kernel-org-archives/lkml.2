Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab1COUXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:23:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57904 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204Ab1COUXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 16:23:46 -0400
Date: Tue, 15 Mar 2011 21:23:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpu changes for v2.6.39
Message-ID: <20110315202340.GA21094@elte.hu>
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

Please pull the latest x86-cpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-cpu-for-linus

 Thanks,

	Ingo

------------------>
Yinghai Lu (3):
      x86: Move llc_shared_map out of cpu_info
      x86: Don't copy per_cpu cpuinfo for BSP two times
      x86: Fix and clean up generic_processor_info()


 arch/x86/include/asm/processor.h      |    4 ---
 arch/x86/include/asm/smp.h            |    7 +++++
 arch/x86/kernel/apic/apic.c           |   39 +++++++++++++++--------------
 arch/x86/kernel/cpu/intel_cacheinfo.c |    4 +-
 arch/x86/kernel/cpu/mcheck/mce_amd.c  |    7 +---
 arch/x86/kernel/smpboot.c             |   44 +++++++++-----------------------
 6 files changed, 44 insertions(+), 61 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 45636ce..4c25ab4 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
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
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 1f46951..bc6f84e 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -23,6 +23,8 @@ extern unsigned int num_processors;
 
 DECLARE_PER_CPU(cpumask_var_t, cpu_sibling_map);
 DECLARE_PER_CPU(cpumask_var_t, cpu_core_map);
+/* cpus sharing the last level cache: */
+DECLARE_PER_CPU(cpumask_var_t, cpu_llc_shared_map);
 DECLARE_PER_CPU(u16, cpu_llc_id);
 DECLARE_PER_CPU(int, cpu_number);
 
@@ -36,6 +38,11 @@ static inline struct cpumask *cpu_core_mask(int cpu)
 	return per_cpu(cpu_core_map, cpu);
 }
 
+static inline struct cpumask *cpu_llc_shared_mask(int cpu)
+{
+	return per_cpu(cpu_llc_shared_map, cpu);
+}
+
 DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
 DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 06c196d..628dcdb 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1925,17 +1925,6 @@ void __cpuinit generic_processor_info(int apicid, int version)
 {
 	int cpu;
 
-	/*
-	 * Validate version
-	 */
-	if (version == 0x0) {
-		pr_warning("BIOS bug, APIC version is 0 for CPU#%d! "
-			   "fixing up to 0x10. (tell your hw vendor)\n",
-				version);
-		version = 0x10;
-	}
-	apic_version[apicid] = version;
-
 	if (num_processors >= nr_cpu_ids) {
 		int max = nr_cpu_ids;
 		int thiscpu = max + disabled_cpus;
@@ -1949,22 +1938,34 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	}
 
 	num_processors++;
-	cpu = cpumask_next_zero(-1, cpu_present_mask);
-
-	if (version != apic_version[boot_cpu_physical_apicid])
-		WARN_ONCE(1,
-			"ACPI: apic version mismatch, bootcpu: %x cpu %d: %x\n",
-			apic_version[boot_cpu_physical_apicid], cpu, version);
-
-	physid_set(apicid, phys_cpu_present_map);
 	if (apicid == boot_cpu_physical_apicid) {
 		/*
 		 * x86_bios_cpu_apicid is required to have processors listed
 		 * in same order as logical cpu numbers. Hence the first
 		 * entry is BSP, and so on.
+		 * boot_cpu_init() already hold bit 0 in cpu_present_mask
+		 * for BSP.
 		 */
 		cpu = 0;
+	} else
+		cpu = cpumask_next_zero(-1, cpu_present_mask);
+
+	/*
+	 * Validate version
+	 */
+	if (version == 0x0) {
+		pr_warning("BIOS bug: APIC version is 0 for CPU %d/0x%x, fixing up to 0x10\n",
+			   cpu, apicid);
+		version = 0x10;
 	}
+	apic_version[apicid] = version;
+
+	if (version != apic_version[boot_cpu_physical_apicid]) {
+		pr_warning("BIOS bug: APIC version mismatch, boot CPU: %x, CPU %d: version %x\n",
+			apic_version[boot_cpu_physical_apicid], cpu, version);
+	}
+
+	physid_set(apicid, phys_cpu_present_map);
 	if (apicid > max_physical_apicid)
 		max_physical_apicid = apicid;
 
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index ec2c19a..5419a26 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -732,11 +732,11 @@ static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
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
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 5bf2fac..167f97b 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -527,15 +527,12 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
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
@@ -555,7 +552,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		if (err)
 			goto out;
 
-		cpumask_copy(b->cpus, c->llc_shared_map);
+		cpumask_copy(b->cpus, cpu_llc_shared_mask(cpu));
 		per_cpu(threshold_banks, cpu)[bank] = b;
 
 		goto out;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 03273b6..592214d 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -130,6 +130,8 @@ EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
 DEFINE_PER_CPU(cpumask_var_t, cpu_core_map);
 EXPORT_PER_CPU_SYMBOL(cpu_core_map);
 
+DEFINE_PER_CPU(cpumask_var_t, cpu_llc_shared_map);
+
 /* Per CPU bogomips and other parameters */
 DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
@@ -355,23 +357,6 @@ notrace static void __cpuinit start_secondary(void *unused)
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
@@ -381,7 +366,7 @@ void __cpuinit smp_store_cpu_info(int id)
 {
 	struct cpuinfo_x86 *c = &cpu_data(id);
 
-	copy_cpuinfo_x86(c, &boot_cpu_data);
+	*c = boot_cpu_data;
 	c->cpu_index = id;
 	if (id != 0)
 		identify_secondary_cpu(c);
@@ -389,15 +374,12 @@ void __cpuinit smp_store_cpu_info(int id)
 
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
 
 
@@ -425,7 +407,7 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 		cpumask_set_cpu(cpu, cpu_sibling_mask(cpu));
 	}
 
-	cpumask_set_cpu(cpu, c->llc_shared_map);
+	cpumask_set_cpu(cpu, cpu_llc_shared_mask(cpu));
 
 	if (__this_cpu_read(cpu_info.x86_max_cores) == 1) {
 		cpumask_copy(cpu_core_mask(cpu), cpu_sibling_mask(cpu));
@@ -436,8 +418,8 @@ void __cpuinit set_cpu_sibling_map(int cpu)
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
@@ -476,7 +458,7 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
 	    !(cpu_has(c, X86_FEATURE_AMD_DCM)))
 		return cpu_core_mask(cpu);
 	else
-		return c->llc_shared_map;
+		return cpu_llc_shared_mask(cpu);
 }
 
 static void impress_friends(void)
@@ -1089,13 +1071,13 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 
 	preempt_disable();
 	smp_cpu_index_default();
-	memcpy(__this_cpu_ptr(&cpu_info), &boot_cpu_data, sizeof(cpu_info));
-	cpumask_copy(cpu_callin_mask, cpumask_of(0));
-	mb();
+
 	/*
 	 * Setup boot CPU information
 	 */
 	smp_store_cpu_info(0); /* Final full version of the data */
+	cpumask_copy(cpu_callin_mask, cpumask_of(0));
+	mb();
 #ifdef CONFIG_X86_32
 	boot_cpu_logical_apicid = logical_smp_processor_id();
 #endif
@@ -1103,7 +1085,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	for_each_possible_cpu(i) {
 		zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
 		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
-		zalloc_cpumask_var(&cpu_data(i).llc_shared_map, GFP_KERNEL);
+		zalloc_cpumask_var(&per_cpu(cpu_llc_shared_map, i), GFP_KERNEL);
 	}
 	set_cpu_sibling_map(0);
 
