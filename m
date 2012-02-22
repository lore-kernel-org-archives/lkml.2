Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab2BVXdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 18:33:22 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51218 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab2BVXdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 18:33:03 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of kjwinchester@gmail.com designates 10.229.76.195 as permitted sender) smtp.mail=kjwinchester@gmail.com; dkim=pass header.i=kjwinchester@gmail.com
From: Kevin Winchester <kjwinchester@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/5] x86: Remove #ifdef CONFIG_SMP sections by moving smp_num_siblings into common.c
Date: Wed, 22 Feb 2012 19:32:31 -0400
Message-Id: <1329953551-17074-6-git-send-email-kjwinchester@gmail.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329953551-17074-1-git-send-email-kjwinchester@gmail.com>
References: <20120222092745.GA30339@elte.hu>
 <1329953551-17074-1-git-send-email-kjwinchester@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smp_num_siblings was defined in arch/x86/kernel/smpboot.c, making it
necessary to wrap any UP relevant code referencing it with #ifdef
CONFIG_SMP.

Instead, move the definition to arch/x86/kernel/cpu/common.c, thus
making it available always.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
---
 arch/x86/include/asm/perf_event_p4.h |   14 +++-----------
 arch/x86/include/asm/smp.h           |    6 +-----
 arch/x86/include/asm/topology.h      |    4 +---
 arch/x86/kernel/cpu/amd.c            |    4 ----
 arch/x86/kernel/cpu/common.c         |    6 ++++--
 arch/x86/kernel/cpu/perf_event_p4.c  |    4 ++--
 arch/x86/kernel/cpu/proc.c           |    5 ++---
 arch/x86/kernel/cpu/topology.c       |    2 --
 arch/x86/kernel/process.c            |    3 +--
 arch/x86/kernel/smpboot.c            |    4 ----
 arch/x86/oprofile/nmi_int.c          |    6 ------
 arch/x86/oprofile/op_model_p4.c      |    6 ------
 12 files changed, 14 insertions(+), 50 deletions(-)

diff --git a/arch/x86/include/asm/perf_event_p4.h b/arch/x86/include/asm/perf_event_p4.h
index 29a65c2..cfe41dc 100644
--- a/arch/x86/include/asm/perf_event_p4.h
+++ b/arch/x86/include/asm/perf_event_p4.h
@@ -8,6 +8,8 @@
 #include <linux/cpu.h>
 #include <linux/bitops.h>
 
+#include <asm/smp.h>
+
 /*
  * NetBurst has performance MSRs shared between
  * threads if HT is turned on, ie for both logical
@@ -177,20 +179,10 @@ static inline u64 p4_clear_ht_bit(u64 config)
 	return config & ~P4_CONFIG_HT;
 }
 
-static inline int p4_ht_active(void)
-{
-#ifdef CONFIG_SMP
-	return smp_num_siblings > 1;
-#endif
-	return 0;
-}
-
 static inline int p4_ht_thread(int cpu)
 {
-#ifdef CONFIG_SMP
 	if (smp_num_siblings == 2)
-		return cpu != cpumask_first(&cpu_data(cpu).sibling_map));
-#endif
+		return cpu != cpumask_first(&cpu_data(cpu).sibling_map);
 	return 0;
 }
 
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 75aea4d..787127e 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -24,11 +24,7 @@ extern unsigned int num_processors;
 
 static inline bool cpu_has_ht_siblings(void)
 {
-	bool has_siblings = false;
-#ifdef CONFIG_SMP
-	has_siblings = cpu_has_ht && smp_num_siblings > 1;
-#endif
-	return has_siblings;
+	return cpu_has_ht && smp_num_siblings > 1;
 }
 
 DECLARE_PER_CPU(int, cpu_number);
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 58438a1b..7250ad1 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -174,11 +174,9 @@ static inline void arch_fix_phys_package_id(int num, u32 slot)
 struct pci_bus;
 void x86_pci_root_bus_resources(int bus, struct list_head *resources);
 
-#ifdef CONFIG_SMP
 #define mc_capable()	((boot_cpu_data.x86_max_cores > 1) && \
 			(cpumask_weight(&boot_cpu_data.core_map) != nr_cpu_ids))
-#define smt_capable()			(smp_num_siblings > 1)
-#endif
+#define smt_capable()	(smp_num_siblings > 1)
 
 #ifdef CONFIG_NUMA
 extern int get_mp_bus_to_node(int busnum);
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 1cd9d51..a8b46df 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -263,7 +263,6 @@ static int __cpuinit nearby_node(int apicid)
  *     Assumption: Number of cores in each internal node is the same.
  * (2) AMD processors supporting compute units
  */
-#ifdef CONFIG_X86_HT
 static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 {
 	u32 nodes, cores_per_cu = 1;
@@ -307,7 +306,6 @@ static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 		c->compute_unit_id %= cus_per_node;
 	}
 }
-#endif
 
 /*
  * On a AMD dual core setup the lower bits of the APIC id distingush the cores.
@@ -315,7 +313,6 @@ static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
  */
 static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 {
-#ifdef CONFIG_X86_HT
 	unsigned bits;
 
 	bits = c->x86_coreid_bits;
@@ -326,7 +323,6 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 	/* use socket ID also for last level cache */
 	c->llc_id = c->phys_proc_id;
 	amd_get_topology(c);
-#endif
 }
 
 int amd_get_nb_id(int cpu)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index ad2a148..8343f54 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -48,6 +48,10 @@ cpumask_var_t cpu_initialized_mask;
 cpumask_var_t cpu_callout_mask;
 cpumask_var_t cpu_callin_mask;
 
+/* Number of siblings per CPU package */
+int smp_num_siblings = 1;
+EXPORT_SYMBOL(smp_num_siblings);
+
 /* representing cpus for which sibling maps can be computed */
 cpumask_var_t cpu_sibling_setup_mask;
 
@@ -453,7 +457,6 @@ void __cpuinit cpu_detect_cache_sizes(struct cpuinfo_x86 *c)
 
 void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 {
-#ifdef CONFIG_X86_HT
 	u32 eax, ebx, ecx, edx;
 	int index_msb, core_bits;
 	static bool printed;
@@ -499,7 +502,6 @@ out:
 		       c->cpu_core_id);
 		printed = 1;
 	}
-#endif
 }
 
 static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index ef484d9..9d1413d 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -775,7 +775,7 @@ static int p4_validate_raw_event(struct perf_event *event)
 	 * if an event is shared across the logical threads
 	 * the user needs special permissions to be able to use it
 	 */
-	if (p4_ht_active() && p4_event_bind_map[v].shared) {
+	if (smt_capable() && p4_event_bind_map[v].shared) {
 		if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
 			return -EACCES;
 	}
@@ -816,7 +816,7 @@ static int p4_hw_config(struct perf_event *event)
 	event->hw.config = p4_config_pack_escr(escr) |
 			   p4_config_pack_cccr(cccr);
 
-	if (p4_ht_active() && p4_ht_thread(cpu))
+	if (smt_capable() && p4_ht_thread(cpu))
 		event->hw.config = p4_set_ht_bit(event->hw.config);
 
 	if (event->attr.type == PERF_TYPE_RAW) {
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index e6e07c2..aef8b27 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -1,16 +1,16 @@
-#include <linux/smp.h>
 #include <linux/timex.h>
 #include <linux/string.h>
 #include <linux/seq_file.h>
 #include <linux/cpufreq.h>
 
+#include <asm/smp.h>
+
 /*
  *	Get CPU information for use by the procfs.
  */
 static void show_cpuinfo_core(struct seq_file *m, struct cpuinfo_x86 *c,
 			      unsigned int cpu)
 {
-#ifdef CONFIG_SMP
 	if (c->x86_max_cores * smp_num_siblings > 1) {
 		seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
 		seq_printf(m, "siblings\t: %d\n", cpumask_weight(&c->core_map));
@@ -19,7 +19,6 @@ static void show_cpuinfo_core(struct seq_file *m, struct cpuinfo_x86 *c,
 		seq_printf(m, "apicid\t\t: %d\n", c->apicid);
 		seq_printf(m, "initial apicid\t: %d\n", c->initial_apicid);
 	}
-#endif
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/topology.c b/arch/x86/kernel/cpu/topology.c
index 4397e98..d4ee471 100644
--- a/arch/x86/kernel/cpu/topology.c
+++ b/arch/x86/kernel/cpu/topology.c
@@ -28,7 +28,6 @@
  */
 void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
 {
-#ifdef CONFIG_SMP
 	unsigned int eax, ebx, ecx, edx, sub_index;
 	unsigned int ht_mask_width, core_plus_mask_width;
 	unsigned int core_select_mask, core_level_siblings;
@@ -95,5 +94,4 @@ void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
 		printed = 1;
 	}
 	return;
-#endif
 }
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 14baf78..c992254 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -587,12 +587,11 @@ static void amd_e400_idle(void)
 
 void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 {
-#ifdef CONFIG_SMP
 	if (pm_idle == poll_idle && smp_num_siblings > 1) {
 		printk_once(KERN_WARNING "WARNING: polling idle and HT enabled,"
 			" performance may degrade.\n");
 	}
-#endif
+
 	if (pm_idle)
 		return;
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3a4908d..4c5a5e5 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -112,10 +112,6 @@ static struct task_struct *idle_thread_array[NR_CPUS] __cpuinitdata ;
 #define set_idle_for_cpu(x, p)   (idle_thread_array[(x)] = (p))
 #endif
 
-/* Number of siblings per CPU package */
-int smp_num_siblings = 1;
-EXPORT_SYMBOL(smp_num_siblings);
-
 /* Per CPU bogomips and other parameters */
 DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 26b8a85..346e7ac 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -572,11 +572,6 @@ static int __init p4_init(char **cpu_type)
 	if (cpu_model > 6 || cpu_model == 5)
 		return 0;
 
-#ifndef CONFIG_SMP
-	*cpu_type = "i386/p4";
-	model = &op_p4_spec;
-	return 1;
-#else
 	switch (smp_num_siblings) {
 	case 1:
 		*cpu_type = "i386/p4";
@@ -588,7 +583,6 @@ static int __init p4_init(char **cpu_type)
 		model = &op_p4_ht2_spec;
 		return 1;
 	}
-#endif
 
 	printk(KERN_INFO "oprofile: P4 HyperThreading detected with > 2 threads\n");
 	printk(KERN_INFO "oprofile: Reverting to timer mode.\n");
diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index ae3503e..c6bcb22 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -42,21 +42,15 @@ static unsigned int num_controls = NUM_CONTROLS_NON_HT;
    kernel boot-time. */
 static inline void setup_num_counters(void)
 {
-#ifdef CONFIG_SMP
 	if (smp_num_siblings == 2) {
 		num_counters = NUM_COUNTERS_HT2;
 		num_controls = NUM_CONTROLS_HT2;
 	}
-#endif
 }
 
 static inline int addr_increment(void)
 {
-#ifdef CONFIG_SMP
 	return smp_num_siblings == 2 ? 2 : 1;
-#else
-	return 1;
-#endif
 }
 
 
-- 
1.7.9

