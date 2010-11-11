Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab0KKLDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:03:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:41236 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616Ab0KKLDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:03:20 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/9] x86: Unify CPU -> NUMA node mapping between 32 and 64bit
Date: Thu, 11 Nov 2010 12:02:41 +0100
Message-Id: <1289473363-29440-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289473363-29440-1-git-send-email-tj@kernel.org>
References: <1289473363-29440-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Nov 2010 11:02:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike 64bit, 32bit has been using its own cpu_to_node_map[] for CPU
-> NUMA node mapping.  Replace it with early_percpu variable
x86_cpu_to_node_map and share the mapping code with 64bit.

* USE_PERCPU_NUMA_NODE_ID is now enabled for 32bit too.

* x86_cpu_to_node_map and numa_set/clear_node() are moved from numa_64
  to numa.  For now, x86_cpu_to_node_map is initialized with 0 instead
  of NUMA_NO_NODE.  This is to avoid introducing unexpected behavior
  change and will be updated once init path is unified.

* srat_detect_node() is now enabled for x86_32 too.  It calls
  numa_set_node() and initializes the mapping making explicit
  cpu_to_node_map[] updates from map/unmap_cpu_to_node() unnecessary.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/Kconfig                |    2 +-
 arch/x86/include/asm/numa.h     |    8 ++++
 arch/x86/include/asm/numa_64.h  |    4 --
 arch/x86/include/asm/topology.h |   17 ---------
 arch/x86/kernel/acpi/boot.c     |    5 ---
 arch/x86/kernel/cpu/amd.c       |    4 +-
 arch/x86/kernel/cpu/intel.c     |    2 +-
 arch/x86/kernel/setup_percpu.c  |    4 +-
 arch/x86/kernel/smpboot.c       |    6 ---
 arch/x86/mm/numa.c              |   72 ++++++++++++++++++++++++++++++++++++++-
 arch/x86/mm/numa_64.c           |   65 -----------------------------------
 11 files changed, 85 insertions(+), 104 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e832768..d493c44 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1678,7 +1678,7 @@ config HAVE_ARCH_EARLY_PFN_TO_NID
 	depends on NUMA
 
 config USE_PERCPU_NUMA_NODE_ID
-	def_bool X86_64
+	def_bool y
 	depends on NUMA
 
 menu "Power management and ACPI options"
diff --git a/arch/x86/include/asm/numa.h b/arch/x86/include/asm/numa.h
index e40bf6f..97078b8 100644
--- a/arch/x86/include/asm/numa.h
+++ b/arch/x86/include/asm/numa.h
@@ -33,4 +33,12 @@ static inline void set_apicid_to_node(int apicid, s16 node)
 # include "numa_64.h"
 #endif
 
+#ifdef CONFIG_NUMA
+extern void __cpuinit numa_set_node(int cpu, int node);
+extern void __cpuinit numa_clear_node(int cpu);
+#else	/* CONFIG_NUMA */
+static inline void numa_set_node(int cpu, int node)	{ }
+static inline void numa_clear_node(int cpu)		{ }
+#endif	/* CONFIG_NUMA */
+
 #endif	/* _ASM_X86_NUMA_H */
diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index 17171ee..96691a0 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -30,8 +30,6 @@ extern void setup_node_bootmem(int nodeid, unsigned long start,
 
 extern void __init init_cpu_to_node(void);
 extern int __cpuinit numa_cpu_node(int cpu);
-extern void __cpuinit numa_set_node(int cpu, int node);
-extern void __cpuinit numa_clear_node(int cpu);
 extern void __cpuinit numa_add_cpu(int cpu);
 extern void __cpuinit numa_remove_cpu(int cpu);
 
@@ -42,8 +40,6 @@ extern void __cpuinit numa_remove_cpu(int cpu);
 #else
 static inline void init_cpu_to_node(void)		{ }
 static inline int numa_cpu_node(int cpu)		{ return NUMA_NO_NODE; }
-static inline void numa_set_node(int cpu, int node)	{ }
-static inline void numa_clear_node(int cpu)		{ }
 static inline void numa_add_cpu(int cpu, int node)	{ }
 static inline void numa_remove_cpu(int cpu)		{ }
 #endif
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 21899cc..b101c17 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -47,21 +47,6 @@
 
 #include <asm/mpspec.h>
 
-#ifdef CONFIG_X86_32
-
-/* Mappings between logical cpu number and node number */
-extern int cpu_to_node_map[];
-
-/* Returns the number of the node containing CPU 'cpu' */
-static inline int __cpu_to_node(int cpu)
-{
-	return cpu_to_node_map[cpu];
-}
-#define early_cpu_to_node __cpu_to_node
-#define cpu_to_node __cpu_to_node
-
-#else /* CONFIG_X86_64 */
-
 /* Mappings between logical cpu number and node number */
 DECLARE_EARLY_PER_CPU(int, x86_cpu_to_node_map);
 
@@ -84,8 +69,6 @@ static inline int early_cpu_to_node(int cpu)
 
 #endif /* !CONFIG_DEBUG_PER_CPU_MAPS */
 
-#endif /* CONFIG_X86_64 */
-
 /* Mappings between node number and cpus on that node. */
 extern cpumask_var_t node_to_cpumask_map[MAX_NUMNODES];
 
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index edff4f5..0ce5755 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -584,12 +584,7 @@ static void acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
 	if (nid == -1 || !node_online(nid))
 		return;
 	set_apicid_to_node(physid, nid);
-#ifdef CONFIG_X86_64
 	numa_set_node(cpu, nid);
-#else /* CONFIG_X86_32 */
-	cpu_to_node_map[cpu] = nid;
-#endif
-
 #endif
 }
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index aa3c613..4259322 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -233,7 +233,7 @@ static void __cpuinit init_amd_k7(struct cpuinfo_x86 *c)
 }
 #endif
 
-#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
+#ifdef CONFIG_NUMA
 static int __cpuinit nearby_node(int apicid)
 {
 	int i, node;
@@ -334,7 +334,7 @@ EXPORT_SYMBOL_GPL(amd_get_nb_id);
 
 static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 {
-#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
+#ifdef CONFIG_NUMA
 	int cpu = smp_processor_id();
 	int node;
 	unsigned apicid = c->apicid;
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 6052004..df86bc8 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -276,7 +276,7 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 
 static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 {
-#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
+#ifdef CONFIG_NUMA
 	unsigned node;
 	int cpu = smp_processor_id();
 
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 002b796..024e7fc 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -229,6 +229,7 @@ void __init setup_per_cpu_areas(void)
 		per_cpu(irq_stack_ptr, cpu) =
 			per_cpu(irq_stack_union.irq_stack, cpu) +
 			IRQ_STACK_SIZE - 64;
+#endif
 #ifdef CONFIG_NUMA
 		per_cpu(x86_cpu_to_node_map, cpu) =
 			early_per_cpu_map(x86_cpu_to_node_map, cpu);
@@ -242,7 +243,6 @@ void __init setup_per_cpu_areas(void)
 		 */
 		set_cpu_numa_node(cpu, early_cpu_to_node(cpu));
 #endif
-#endif
 		/*
 		 * Up to this point, the boot CPU has been using .init.data
 		 * area.  Reload any changed state for the boot CPU.
@@ -256,7 +256,7 @@ void __init setup_per_cpu_areas(void)
 	early_per_cpu_ptr(x86_cpu_to_apicid) = NULL;
 	early_per_cpu_ptr(x86_bios_cpu_apicid) = NULL;
 #endif
-#if defined(CONFIG_X86_64) && defined(CONFIG_NUMA)
+#ifdef CONFIG_NUMA
 	early_per_cpu_ptr(x86_cpu_to_node_map) = NULL;
 #endif
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 4b8b72d..b78ce8c 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -133,16 +133,11 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
 atomic_t init_deasserted;
 
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_32)
-/* which node each logical CPU is on */
-int cpu_to_node_map[NR_CPUS] __read_mostly = { [0 ... NR_CPUS-1] = 0 };
-EXPORT_SYMBOL(cpu_to_node_map);
-
 /* set up a mapping between cpu and node. */
 static void map_cpu_to_node(int cpu, int node)
 {
 	printk(KERN_INFO "Mapping cpu %d to node %d\n", cpu, node);
 	cpumask_set_cpu(cpu, node_to_cpumask_map[node]);
-	cpu_to_node_map[cpu] = node;
 }
 
 /* undo a mapping between cpu and node. */
@@ -153,7 +148,6 @@ static void unmap_cpu_to_node(int cpu)
 	printk(KERN_INFO "Unmapping cpu %d from all nodes\n", cpu);
 	for (node = 0; node < MAX_NUMNODES; node++)
 		cpumask_clear_cpu(cpu, node_to_cpumask_map[node]);
-	cpu_to_node_map[cpu] = 0;
 }
 #else /* !(CONFIG_NUMA && CONFIG_X86_32) */
 #define map_cpu_to_node(cpu, node)	({})
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 63db99c..b23b5fe 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -14,6 +14,44 @@ cpumask_var_t node_to_cpumask_map[MAX_NUMNODES];
 EXPORT_SYMBOL(node_to_cpumask_map);
 
 /*
+ * Map cpu index to node index
+ */
+#ifdef CONFIG_X86_32
+DEFINE_EARLY_PER_CPU(int, x86_cpu_to_node_map, 0);
+#else
+DEFINE_EARLY_PER_CPU(int, x86_cpu_to_node_map, NUMA_NO_NODE);
+#endif
+EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_node_map);
+
+void __cpuinit numa_set_node(int cpu, int node)
+{
+	int *cpu_to_node_map = early_per_cpu_ptr(x86_cpu_to_node_map);
+
+	/* early setting, no percpu area yet */
+	if (cpu_to_node_map) {
+		cpu_to_node_map[cpu] = node;
+		return;
+	}
+
+#ifdef CONFIG_DEBUG_PER_CPU_MAPS
+	if (cpu >= nr_cpu_ids || !cpu_possible(cpu)) {
+		printk(KERN_ERR "numa_set_node: invalid cpu# (%d)\n", cpu);
+		dump_stack();
+		return;
+	}
+#endif
+	per_cpu(x86_cpu_to_node_map, cpu) = node;
+
+	if (node != NUMA_NO_NODE)
+		set_cpu_numa_node(cpu, node);
+}
+
+void __cpuinit numa_clear_node(int cpu)
+{
+	numa_set_node(cpu, NUMA_NO_NODE);
+}
+
+/*
  * Allocate node_to_cpumask_map based on number of available nodes
  * Requires node_possible_map to be valid.
  *
@@ -40,6 +78,37 @@ void __init setup_node_to_cpumask_map(void)
 }
 
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
+
+int __cpu_to_node(int cpu)
+{
+	if (early_per_cpu_ptr(x86_cpu_to_node_map)) {
+		printk(KERN_WARNING
+			"cpu_to_node(%d): usage too early!\n", cpu);
+		dump_stack();
+		return early_per_cpu_ptr(x86_cpu_to_node_map)[cpu];
+	}
+	return per_cpu(x86_cpu_to_node_map, cpu);
+}
+EXPORT_SYMBOL(__cpu_to_node);
+
+/*
+ * Same function as cpu_to_node() but used if called before the
+ * per_cpu areas are setup.
+ */
+int early_cpu_to_node(int cpu)
+{
+	if (early_per_cpu_ptr(x86_cpu_to_node_map))
+		return early_per_cpu_ptr(x86_cpu_to_node_map)[cpu];
+
+	if (!cpu_possible(cpu)) {
+		printk(KERN_WARNING
+			"early_cpu_to_node(%d): no per_cpu area!\n", cpu);
+		dump_stack();
+		return NUMA_NO_NODE;
+	}
+	return per_cpu(x86_cpu_to_node_map, cpu);
+}
+
 /*
  * Returns a pointer to the bitmask of CPUs on Node 'node'.
  */
@@ -62,4 +131,5 @@ const struct cpumask *cpumask_of_node(int node)
 	return node_to_cpumask_map[node];
 }
 EXPORT_SYMBOL(cpumask_of_node);
-#endif
+
+#endif	/* CONFIG_DEBUG_PER_CPU_MAPS */
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 47ca1b0..121b26d 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -31,12 +31,6 @@ static unsigned long __initdata nodemap_addr;
 static unsigned long __initdata nodemap_size;
 
 /*
- * Map cpu index to node index
- */
-DEFINE_EARLY_PER_CPU(int, x86_cpu_to_node_map, NUMA_NO_NODE);
-EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_node_map);
-
-/*
  * Given a shift value, try to populate memnodemap[]
  * Returns :
  * 1 if OK
@@ -737,34 +731,6 @@ int __cpuinit numa_cpu_node(int cpu)
 	return NUMA_NO_NODE;
 }
 
-void __cpuinit numa_set_node(int cpu, int node)
-{
-	int *cpu_to_node_map = early_per_cpu_ptr(x86_cpu_to_node_map);
-
-	/* early setting, no percpu area yet */
-	if (cpu_to_node_map) {
-		cpu_to_node_map[cpu] = node;
-		return;
-	}
-
-#ifdef CONFIG_DEBUG_PER_CPU_MAPS
-	if (cpu >= nr_cpu_ids || !cpu_possible(cpu)) {
-		printk(KERN_ERR "numa_set_node: invalid cpu# (%d)\n", cpu);
-		dump_stack();
-		return;
-	}
-#endif
-	per_cpu(x86_cpu_to_node_map, cpu) = node;
-
-	if (node != NUMA_NO_NODE)
-		set_cpu_numa_node(cpu, node);
-}
-
-void __cpuinit numa_clear_node(int cpu)
-{
-	numa_set_node(cpu, NUMA_NO_NODE);
-}
-
 #ifndef CONFIG_DEBUG_PER_CPU_MAPS
 
 void __cpuinit numa_add_cpu(int cpu)
@@ -814,37 +780,6 @@ void __cpuinit numa_remove_cpu(int cpu)
 {
 	numa_set_cpumask(cpu, 0);
 }
-
-int __cpu_to_node(int cpu)
-{
-	if (early_per_cpu_ptr(x86_cpu_to_node_map)) {
-		printk(KERN_WARNING
-			"cpu_to_node(%d): usage too early!\n", cpu);
-		dump_stack();
-		return early_per_cpu_ptr(x86_cpu_to_node_map)[cpu];
-	}
-	return per_cpu(x86_cpu_to_node_map, cpu);
-}
-EXPORT_SYMBOL(__cpu_to_node);
-
-/*
- * Same function as cpu_to_node() but used if called before the
- * per_cpu areas are setup.
- */
-int early_cpu_to_node(int cpu)
-{
-	if (early_per_cpu_ptr(x86_cpu_to_node_map))
-		return early_per_cpu_ptr(x86_cpu_to_node_map)[cpu];
-
-	if (!cpu_possible(cpu)) {
-		printk(KERN_WARNING
-			"early_cpu_to_node(%d): no per_cpu area!\n", cpu);
-		dump_stack();
-		return NUMA_NO_NODE;
-	}
-	return per_cpu(x86_cpu_to_node_map, cpu);
-}
-
 /*
  * --------- end of debug versions of the numa functions ---------
  */
-- 
1.7.1

