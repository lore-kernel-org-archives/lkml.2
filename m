Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab2BUCGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 21:06:31 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63257 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab2BUCGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 21:06:24 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of kjwinchester@gmail.com designates 10.229.78.98 as permitted sender) smtp.mail=kjwinchester@gmail.com; dkim=pass header.i=kjwinchester@gmail.com
From: Kevin Winchester <kjwinchester@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] x86: Move per cpu cpu_llc_id to a field in struct cpuinfo_x86
Date: Mon, 20 Feb 2012 22:06:03 -0400
Message-Id: <1329789966-693-3-git-send-email-kjwinchester@gmail.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329789966-693-1-git-send-email-kjwinchester@gmail.com>
References: <20120217115627.GA25601@elte.hu>
 <1329789966-693-1-git-send-email-kjwinchester@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simplifies the various code paths using this field as it
groups the per-cpu data together.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
---
 arch/x86/include/asm/processor.h      |    2 ++
 arch/x86/include/asm/smp.h            |    2 --
 arch/x86/kernel/apic/apic_numachip.c  |    2 +-
 arch/x86/kernel/cpu/amd.c             |   14 ++++----------
 arch/x86/kernel/cpu/common.c          |    1 +
 arch/x86/kernel/cpu/intel_cacheinfo.c |   11 ++---------
 arch/x86/kernel/smpboot.c             |   18 ++++++++----------
 7 files changed, 18 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 0c8b574..2d4eb6f 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -111,6 +111,8 @@ struct cpuinfo_x86 {
 	u16			cpu_index;
 	u32			microcode;
 	cpumask_t		llc_shared_map;
+	/* cpus sharing the last level cache: */
+	u16			llc_id;
 } __attribute__((__aligned__(SMP_CACHE_BYTES)));
 
 #define X86_VENDOR_INTEL	0
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index f7599d0..40d1c96 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -33,8 +33,6 @@ static inline bool cpu_has_ht_siblings(void)
 
 DECLARE_PER_CPU(cpumask_var_t, cpu_sibling_map);
 DECLARE_PER_CPU(cpumask_var_t, cpu_core_map);
-/* cpus sharing the last level cache: */
-DECLARE_PER_CPU(u16, cpu_llc_id);
 DECLARE_PER_CPU(int, cpu_number);
 
 static inline struct cpumask *cpu_sibling_mask(int cpu)
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index 09d3d8c..73c46cf 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -202,7 +202,7 @@ static void __init map_csrs(void)
 static void fixup_cpu_id(struct cpuinfo_x86 *c, int node)
 {
 	c->phys_proc_id = node;
-	per_cpu(cpu_llc_id, smp_processor_id()) = node;
+	c->llc_id = node;
 }
 
 static int __init numachip_system_init(void)
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 0a44b90..1cd9d51 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -268,7 +268,6 @@ static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 {
 	u32 nodes, cores_per_cu = 1;
 	u8 node_id;
-	int cpu = smp_processor_id();
 
 	/* get information required for multi-node processors */
 	if (cpu_has(c, X86_FEATURE_TOPOEXT)) {
@@ -301,7 +300,7 @@ static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 		cus_per_node = cores_per_node / cores_per_cu;
 
 		/* store NodeID, use llc_shared_map to store sibling info */
-		per_cpu(cpu_llc_id, cpu) = node_id;
+		c->llc_id = node_id;
 
 		/* core id has to be in the [0 .. cores_per_node - 1] range */
 		c->cpu_core_id %= cores_per_node;
@@ -318,7 +317,6 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_HT
 	unsigned bits;
-	int cpu = smp_processor_id();
 
 	bits = c->x86_coreid_bits;
 	/* Low order bits define the core id (index of core in socket) */
@@ -326,18 +324,14 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 	/* Convert the initial APIC ID into the socket ID */
 	c->phys_proc_id = c->initial_apicid >> bits;
 	/* use socket ID also for last level cache */
-	per_cpu(cpu_llc_id, cpu) = c->phys_proc_id;
+	c->llc_id = c->phys_proc_id;
 	amd_get_topology(c);
 #endif
 }
 
 int amd_get_nb_id(int cpu)
 {
-	int id = 0;
-#ifdef CONFIG_SMP
-	id = per_cpu(cpu_llc_id, cpu);
-#endif
-	return id;
+	return cpu_data(cpu).llc_id;
 }
 EXPORT_SYMBOL_GPL(amd_get_nb_id);
 
@@ -350,7 +344,7 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 
 	node = numa_cpu_node(cpu);
 	if (node == NUMA_NO_NODE)
-		node = per_cpu(cpu_llc_id, cpu);
+		node = c->llc_id;
 
 	/*
 	 * If core numbers are inconsistent, it's likely a multi-fabric platform,
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 8b6a3bb..7052410 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -787,6 +787,7 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 	c->x86_model_id[0] = '\0';  /* Unset */
 	c->x86_max_cores = 1;
 	c->x86_coreid_bits = 0;
+	c->llc_id = BAD_APICID;
 #ifdef CONFIG_X86_64
 	c->x86_clflush_size = 64;
 	c->x86_phys_bits = 36;
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index a9cd551..5ddd6ef 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -579,9 +579,6 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 	unsigned int new_l1d = 0, new_l1i = 0; /* Cache sizes from cpuid(4) */
 	unsigned int new_l2 = 0, new_l3 = 0, i; /* Cache sizes from cpuid(4) */
 	unsigned int l2_id = 0, l3_id = 0, num_threads_sharing, index_msb;
-#ifdef CONFIG_X86_HT
-	unsigned int cpu = c->cpu_index;
-#endif
 
 	if (c->cpuid_level > 3) {
 		static int is_initialized;
@@ -700,16 +697,12 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 
 	if (new_l2) {
 		l2 = new_l2;
-#ifdef CONFIG_X86_HT
-		per_cpu(cpu_llc_id, cpu) = l2_id;
-#endif
+		c->llc_id = l2_id;
 	}
 
 	if (new_l3) {
 		l3 = new_l3;
-#ifdef CONFIG_X86_HT
-		per_cpu(cpu_llc_id, cpu) = l3_id;
-#endif
+		c->llc_id = l3_id;
 	}
 
 	c->x86_cache_size = l3 ? l3 : (l2 ? l2 : (l1i+l1d));
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 1c20aa2..fb2ef30 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -116,9 +116,6 @@ static struct task_struct *idle_thread_array[NR_CPUS] __cpuinitdata ;
 int smp_num_siblings = 1;
 EXPORT_SYMBOL(smp_num_siblings);
 
-/* Last level cache ID of each logical CPU */
-DEFINE_PER_CPU(u16, cpu_llc_id) = BAD_APICID;
-
 /* representing HT siblings of each logical CPU */
 DEFINE_PER_CPU(cpumask_var_t, cpu_sibling_map);
 EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
@@ -353,7 +350,7 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 
 			if (cpu_has(c, X86_FEATURE_TOPOEXT)) {
 				if (c->phys_proc_id == o->phys_proc_id &&
-				    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i) &&
+				    c->llc_id == o->llc_id &&
 				    c->compute_unit_id == o->compute_unit_id)
 					link_thread_siblings(cpu, i);
 			} else if (c->phys_proc_id == o->phys_proc_id &&
@@ -374,12 +371,13 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 	}
 
 	for_each_cpu(i, cpu_sibling_setup_mask) {
-		if (per_cpu(cpu_llc_id, cpu) != BAD_APICID &&
-		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i)) {
+		struct cpuinfo_x86 *o = &cpu_data(i);
+
+		if (c->llc_id != BAD_APICID && c->llc_id == o->llc_id) {
 			cpumask_set_cpu(i, &c->llc_shared_map);
-			cpumask_set_cpu(cpu, &cpu_data(i).llc_shared_map);
+			cpumask_set_cpu(cpu, &o->llc_shared_map);
 		}
-		if (c->phys_proc_id == cpu_data(i).phys_proc_id) {
+		if (c->phys_proc_id == o->phys_proc_id) {
 			cpumask_set_cpu(i, cpu_core_mask(cpu));
 			cpumask_set_cpu(cpu, cpu_core_mask(i));
 			/*
@@ -397,9 +395,9 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 				 * the other cpus in this package
 				 */
 				if (i != cpu)
-					cpu_data(i).booted_cores++;
+					o->booted_cores++;
 			} else if (i != cpu && !c->booted_cores)
-				c->booted_cores = cpu_data(i).booted_cores;
+				c->booted_cores = o->booted_cores;
 		}
 	}
 }
-- 
1.7.9

