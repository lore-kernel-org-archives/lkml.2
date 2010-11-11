Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab0KKLDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:03:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:41227 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535Ab0KKLDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:03:20 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 8/9] x86: Unify node_to_cpumask_map handling between 32 and 64bit
Date: Thu, 11 Nov 2010 12:02:42 +0100
Message-Id: <1289473363-29440-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289473363-29440-1-git-send-email-tj@kernel.org>
References: <1289473363-29440-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Nov 2010 11:02:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_32 has been managing node_to_cpumask_map explicitly from
map_cpu_to_node() and friends in a rather ugly way.  With previous
changes, it's now possible to simply share the code with 64bit.

* numa_add/remove_cpu() are moved from numa_64 to numa.

* identify_cpu() now calls numa_add_cpu() for 32bit too.  This makes
  the explicit mask management from map_cpu_to_node() unnecessary.

* The whole x86_32 specific map_cpu_to_node() chunk is no longer
  necessary.  Dropped.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/numa.h    |   18 +++++++++++++
 arch/x86/include/asm/numa_32.h |    1 -
 arch/x86/include/asm/numa_64.h |    4 ---
 arch/x86/kernel/cpu/common.c   |    2 +-
 arch/x86/kernel/smpboot.c      |   47 ----------------------------------
 arch/x86/mm/numa.c             |   33 ++++++++++++++++++++++++
 arch/x86/mm/numa_64.c          |   55 ----------------------------------------
 7 files changed, 52 insertions(+), 108 deletions(-)

diff --git a/arch/x86/include/asm/numa.h b/arch/x86/include/asm/numa.h
index 97078b8..77f8bcb 100644
--- a/arch/x86/include/asm/numa.h
+++ b/arch/x86/include/asm/numa.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_X86_NUMA_H
 #define _ASM_X86_NUMA_H
 
+#include <asm/topology.h>
 #include <asm/apicdef.h>
 
 #ifdef CONFIG_NUMA
@@ -36,9 +37,26 @@ static inline void set_apicid_to_node(int apicid, s16 node)
 #ifdef CONFIG_NUMA
 extern void __cpuinit numa_set_node(int cpu, int node);
 extern void __cpuinit numa_clear_node(int cpu);
+
+# ifdef CONFIG_DEBUG_PER_CPU_MAPS
+extern void __cpuinit numa_add_cpu(int cpu);
+extern void __cpuinit numa_remove_cpu(int cpu);
+# else	/* CONFIG_DEBUG_PER_CPU_MAPS */
+static inline void __cpuinit numa_add_cpu(int cpu)
+{
+	cpumask_set_cpu(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
+}
+static inline void __cpuinit numa_remove_cpu(int cpu)
+{
+	cpumask_clear_cpu(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
+}
+# endif	/* CONFIG_DEBUG_PER_CPU_MAPS */
+
 #else	/* CONFIG_NUMA */
 static inline void numa_set_node(int cpu, int node)	{ }
 static inline void numa_clear_node(int cpu)		{ }
+static inline void numa_add_cpu(int cpu)		{ }
+static inline void numa_remove_cpu(int cpu)		{ }
 #endif	/* CONFIG_NUMA */
 
 #endif	/* _ASM_X86_NUMA_H */
diff --git a/arch/x86/include/asm/numa_32.h b/arch/x86/include/asm/numa_32.h
index d30eb6c..ba0ea62 100644
--- a/arch/x86/include/asm/numa_32.h
+++ b/arch/x86/include/asm/numa_32.h
@@ -2,7 +2,6 @@
 #define _ASM_X86_NUMA_32_H
 
 extern int pxm_to_nid(int pxm);
-extern void numa_remove_cpu(int cpu);
 
 #ifdef CONFIG_NUMA
 extern int __cpuinit numa_cpu_node(int apicid);
diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index 96691a0..6331190 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -30,8 +30,6 @@ extern void setup_node_bootmem(int nodeid, unsigned long start,
 
 extern void __init init_cpu_to_node(void);
 extern int __cpuinit numa_cpu_node(int cpu);
-extern void __cpuinit numa_add_cpu(int cpu);
-extern void __cpuinit numa_remove_cpu(int cpu);
 
 #ifdef CONFIG_NUMA_EMU
 #define FAKE_NODE_MIN_SIZE	((u64)64 << 20)
@@ -40,8 +38,6 @@ extern void __cpuinit numa_remove_cpu(int cpu);
 #else
 static inline void init_cpu_to_node(void)		{ }
 static inline int numa_cpu_node(int cpu)		{ return NUMA_NO_NODE; }
-static inline void numa_add_cpu(int cpu, int node)	{ }
-static inline void numa_remove_cpu(int cpu)		{ }
 #endif
 
 #endif /* _ASM_X86_NUMA_64_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4b68bda..0e9a1d7 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -869,7 +869,7 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 
 	select_idle_routine(c);
 
-#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
+#ifdef CONFIG_NUMA
 	numa_add_cpu(smp_processor_id());
 #endif
 }
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index b78ce8c..b152077 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -132,49 +132,6 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
 
 atomic_t init_deasserted;
 
-#if defined(CONFIG_NUMA) && defined(CONFIG_X86_32)
-/* set up a mapping between cpu and node. */
-static void map_cpu_to_node(int cpu, int node)
-{
-	printk(KERN_INFO "Mapping cpu %d to node %d\n", cpu, node);
-	cpumask_set_cpu(cpu, node_to_cpumask_map[node]);
-}
-
-/* undo a mapping between cpu and node. */
-static void unmap_cpu_to_node(int cpu)
-{
-	int node;
-
-	printk(KERN_INFO "Unmapping cpu %d from all nodes\n", cpu);
-	for (node = 0; node < MAX_NUMNODES; node++)
-		cpumask_clear_cpu(cpu, node_to_cpumask_map[node]);
-}
-#else /* !(CONFIG_NUMA && CONFIG_X86_32) */
-#define map_cpu_to_node(cpu, node)	({})
-#define unmap_cpu_to_node(cpu)	({})
-#endif
-
-#ifdef CONFIG_X86_32
-static void map_cpu_to_logical_apicid(void)
-{
-	int cpu = smp_processor_id();
-	int node;
-
-	node = numa_cpu_node(cpu);
-	if (!node_online(node))
-		node = first_online_node;
-
-	map_cpu_to_node(cpu, node);
-}
-
-void numa_remove_cpu(int cpu)
-{
-	unmap_cpu_to_node(cpu);
-}
-#else
-#define map_cpu_to_logical_apicid()  do {} while (0)
-#endif
-
 /*
  * Report back to the Boot Processor.
  * Running on AP.
@@ -242,7 +199,6 @@ static void __cpuinit smp_callin(void)
 		apic->smp_callin_clear_local_apic();
 	setup_local_APIC();
 	end_local_APIC_setup();
-	map_cpu_to_logical_apicid();
 
 	/*
 	 * Need to setup vector mappings before we enable interrupts.
@@ -946,7 +902,6 @@ static __init void disable_smp(void)
 		physid_set_mask_of_physid(boot_cpu_physical_apicid, &phys_cpu_present_map);
 	else
 		physid_set_mask_of_physid(0, &phys_cpu_present_map);
-	map_cpu_to_logical_apicid();
 	cpumask_set_cpu(0, cpu_sibling_mask(0));
 	cpumask_set_cpu(0, cpu_core_mask(0));
 }
@@ -1125,8 +1080,6 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 
 	end_local_APIC_setup();
 
-	map_cpu_to_logical_apicid();
-
 	if (apic->setup_portio_remap)
 		apic->setup_portio_remap();
 
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index b23b5fe..c52c267 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -109,6 +109,39 @@ int early_cpu_to_node(int cpu)
 	return per_cpu(x86_cpu_to_node_map, cpu);
 }
 
+static void __cpuinit numa_set_cpumask(int cpu, int enable)
+{
+	int node = early_cpu_to_node(cpu);
+	struct cpumask *mask;
+	char buf[64];
+
+	mask = node_to_cpumask_map[node];
+	if (mask == NULL) {
+		printk(KERN_ERR "node_to_cpumask_map[%i] NULL\n", node);
+		dump_stack();
+		return;
+	}
+
+	if (enable)
+		cpumask_set_cpu(cpu, mask);
+	else
+		cpumask_clear_cpu(cpu, mask);
+
+	cpulist_scnprintf(buf, sizeof(buf), mask);
+	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
+		enable ? "numa_add_cpu" : "numa_remove_cpu", cpu, node, buf);
+}
+
+void __cpuinit numa_add_cpu(int cpu)
+{
+	numa_set_cpumask(cpu, 1);
+}
+
+void __cpuinit numa_remove_cpu(int cpu)
+{
+	numa_set_cpumask(cpu, 0);
+}
+
 /*
  * Returns a pointer to the bitmask of CPUs on Node 'node'.
  */
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 121b26d..c8c2e29 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -730,58 +730,3 @@ int __cpuinit numa_cpu_node(int cpu)
 		return __apicid_to_node[apicid];
 	return NUMA_NO_NODE;
 }
-
-#ifndef CONFIG_DEBUG_PER_CPU_MAPS
-
-void __cpuinit numa_add_cpu(int cpu)
-{
-	cpumask_set_cpu(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
-}
-
-void __cpuinit numa_remove_cpu(int cpu)
-{
-	cpumask_clear_cpu(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
-}
-
-#else /* CONFIG_DEBUG_PER_CPU_MAPS */
-
-/*
- * --------- debug versions of the numa functions ---------
- */
-static void __cpuinit numa_set_cpumask(int cpu, int enable)
-{
-	int node = early_cpu_to_node(cpu);
-	struct cpumask *mask;
-	char buf[64];
-
-	mask = node_to_cpumask_map[node];
-	if (mask == NULL) {
-		printk(KERN_ERR "node_to_cpumask_map[%i] NULL\n", node);
-		dump_stack();
-		return;
-	}
-
-	if (enable)
-		cpumask_set_cpu(cpu, mask);
-	else
-		cpumask_clear_cpu(cpu, mask);
-
-	cpulist_scnprintf(buf, sizeof(buf), mask);
-	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
-		enable ? "numa_add_cpu" : "numa_remove_cpu", cpu, node, buf);
-}
-
-void __cpuinit numa_add_cpu(int cpu)
-{
-	numa_set_cpumask(cpu, 1);
-}
-
-void __cpuinit numa_remove_cpu(int cpu)
-{
-	numa_set_cpumask(cpu, 0);
-}
-/*
- * --------- end of debug versions of the numa functions ---------
- */
-
-#endif /* CONFIG_DEBUG_PER_CPU_MAPS */
-- 
1.7.1

