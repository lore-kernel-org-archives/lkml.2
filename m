Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263Ab2C1WoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 18:44:16 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:50229 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933080Ab2C1Wnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 18:43:31 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v5 5/5] x86: Remove #ifdef CONFIG_SMP sections by moving smp_num_siblings into common.c
Date: Wed, 28 Mar 2012 19:43:07 -0300
Message-Id: <1332974587-15452-6-git-send-email-kjwinchester@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1332974587-15452-1-git-send-email-kjwinchester@gmail.com>
References: <20120227115905.GB9943@elte.hu>
 <1332974587-15452-1-git-send-email-kjwinchester@gmail.com>
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
 arch/x86/kernel/cpu/amd.c            |    5 +----
 arch/x86/kernel/cpu/common.c         |    4 ++++
 arch/x86/kernel/cpu/perf_event_p4.c  |    4 ++--
 arch/x86/kernel/cpu/proc.c           |    5 ++---
 arch/x86/kernel/process.c            |    5 ++---
 arch/x86/kernel/smpboot.c            |    4 ----
 arch/x86/oprofile/nmi_int.c          |    6 ------
 arch/x86/oprofile/op_model_p4.c      |    6 ------
 11 files changed, 16 insertions(+), 47 deletions(-)

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
index 408152e..8202cda 100644
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
index 5ffa396..1590480 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -174,11 +174,9 @@ static inline void arch_fix_phys_package_id(int num, u32 slot)
 struct pci_bus;
 void x86_pci_root_bus_resources(int bus, struct list_head *resources);
 
-#ifdef CONFIG_SMP
 #define mc_capable()	((boot_cpu_data.x86_max_cores > 1) && \
 			(cpumask_weight(cpu_core_mask(0)) != nr_cpu_ids))
-#define smt_capable()			(smp_num_siblings > 1)
-#endif
+#define smt_capable()	(smp_num_siblings > 1)
 
 #ifdef CONFIG_NUMA
 extern int get_mp_bus_to_node(int busnum);
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 1cd9d51..37a95075 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -9,6 +9,7 @@
 #include <asm/processor.h>
 #include <asm/apic.h>
 #include <asm/cpu.h>
+#include <asm/smp.h>
 #include <asm/pci-direct.h>
 
 #ifdef CONFIG_X86_64
@@ -263,7 +264,6 @@ static int __cpuinit nearby_node(int apicid)
  *     Assumption: Number of cores in each internal node is the same.
  * (2) AMD processors supporting compute units
  */
-#ifdef CONFIG_X86_HT
 static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 {
 	u32 nodes, cores_per_cu = 1;
@@ -307,7 +307,6 @@ static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 		c->compute_unit_id %= cus_per_node;
 	}
 }
-#endif
 
 /*
  * On a AMD dual core setup the lower bits of the APIC id distingush the cores.
@@ -315,7 +314,6 @@ static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
  */
 static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 {
-#ifdef CONFIG_X86_HT
 	unsigned bits;
 
 	bits = c->x86_coreid_bits;
@@ -326,7 +324,6 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 	/* use socket ID also for last level cache */
 	c->llc_id = c->phys_proc_id;
 	amd_get_topology(c);
-#endif
 }
 
 int amd_get_nb_id(int cpu)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 6567cda..26963aa 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -49,6 +49,10 @@ cpumask_var_t cpu_initialized_mask;
 cpumask_var_t cpu_callout_mask;
 cpumask_var_t cpu_callin_mask;
 
+/* Number of siblings per CPU package */
+int smp_num_siblings = 1;
+EXPORT_SYMBOL(smp_num_siblings);
+
 /* representing cpus for which sibling maps can be computed */
 cpumask_var_t cpu_sibling_setup_mask;
 
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
index 8022c66..4fbaacb 100644
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
 		seq_printf(m, "siblings\t: %d\n",
@@ -20,7 +20,6 @@ static void show_cpuinfo_core(struct seq_file *m, struct cpuinfo_x86 *c,
 		seq_printf(m, "apicid\t\t: %d\n", c->apicid);
 		seq_printf(m, "initial apicid\t: %d\n", c->initial_apicid);
 	}
-#endif
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 14baf78..e9a0d2c 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -1,7 +1,6 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
-#include <linux/smp.h>
 #include <linux/prctl.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
@@ -17,6 +16,7 @@
 #include <asm/cpu.h>
 #include <asm/system.h>
 #include <asm/apic.h>
+#include <asm/smp.h>
 #include <asm/syscalls.h>
 #include <asm/idle.h>
 #include <asm/uaccess.h>
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
index 88b8320..67ac7c3 100644
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
1.7.9.5

