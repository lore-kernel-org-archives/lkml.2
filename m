Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab1A1Ome (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:42:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:53397 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791Ab1A1Omb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:42:31 -0500
Date: Fri, 28 Jan 2011 14:42:00 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tj@kernel.org, tglx@linutronix.de, rientjes@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tj@kernel.org, tglx@linutronix.de, rientjes@google.com, mingo@elte.hu
In-Reply-To: <1295789862-25482-15-git-send-email-tj@kernel.org>
References: <1295789862-25482-15-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86: Unify CPU -> NUMA node mapping between 32 and 64bit
Message-ID: <tip-645a79195f66eb68ef3ab2b21d9829ac3aa085a9@git.kernel.org>
Git-Commit-ID: 645a79195f66eb68ef3ab2b21d9829ac3aa085a9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 28 Jan 2011 14:42:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  645a79195f66eb68ef3ab2b21d9829ac3aa085a9
Gitweb:     http://git.kernel.org/tip/645a79195f66eb68ef3ab2b21d9829ac3aa085a9
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Sun, 23 Jan 2011 14:37:40 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 28 Jan 2011 14:54:09 +0100

x86: Unify CPU -> NUMA node mapping between 32 and 64bit

Unlike 64bit, 32bit has been using its own cpu_to_node_map[] for
CPU -> NUMA node mapping.  Replace it with early_percpu variable
x86_cpu_to_node_map and share the mapping code with 64bit.

* USE_PERCPU_NUMA_NODE_ID is now enabled for 32bit too.

* x86_cpu_to_node_map and numa_set/clear_node() are moved from
  numa_64 to numa.  For now, on 32bit, x86_cpu_to_node_map is initialized
  with 0 instead of NUMA_NO_NODE.  This is to avoid introducing unexpected
  behavior change and will be updated once init path is unified.

* srat_detect_node() is now enabled for x86_32 too.  It calls
  numa_set_node() and initializes the mapping making explicit
  cpu_to_node_map[] updates from map/unmap_cpu_to_node() unnecessary.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: eric.dumazet@gmail.com
Cc: yinghai@kernel.org
Cc: brgerst@gmail.com
Cc: gorcunov@gmail.com
Cc: penberg@kernel.org
Cc: shaohui.zheng@intel.com
Cc: rientjes@google.com
LKML-Reference: <1295789862-25482-15-git-send-email-tj@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: David Rientjes <rientjes@google.com>
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
index d5ed94d..95c36c4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1705,7 +1705,7 @@ config HAVE_ARCH_EARLY_PFN_TO_NID
 	depends on NUMA
 
 config USE_PERCPU_NUMA_NODE_ID
-	def_bool X86_64
+	def_bool y
 	depends on NUMA
 
 menu "Power management and ACPI options"
diff --git a/arch/x86/include/asm/numa.h b/arch/x86/include/asm/numa.h
index 5e01c76..2b21fff 100644
--- a/arch/x86/include/asm/numa.h
+++ b/arch/x86/include/asm/numa.h
@@ -30,4 +30,12 @@ static inline void set_apicid_to_node(int apicid, s16 node)
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
index 4982a9c..6ead9f3 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -30,8 +30,6 @@ extern void setup_node_bootmem(int nodeid, unsigned long start,
 
 extern void __init init_cpu_to_node(void);
 extern int __cpuinit numa_cpu_node(int cpu);
-extern void __cpuinit numa_set_node(int cpu, int node);
-extern void __cpuinit numa_clear_node(int cpu);
 extern void __cpuinit numa_add_cpu(int cpu);
 extern void __cpuinit numa_remove_cpu(int cpu);
 
@@ -43,8 +41,6 @@ void numa_emu_cmdline(char *);
 #else
 static inline void init_cpu_to_node(void)		{ }
 static inline int numa_cpu_node(int cpu)		{ return NUMA_NO_NODE; }
-static inline void numa_set_node(int cpu, int node)	{ }
-static inline void numa_clear_node(int cpu)		{ }
 static inline void numa_add_cpu(int cpu, int node)	{ }
 static inline void numa_remove_cpu(int cpu)		{ }
 #endif
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 21899cc3..b101c17 100644
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
index a7bca59..a2c5121 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -590,12 +590,7 @@ static void acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
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
index 3cce8f2..77858fd 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -233,7 +233,7 @@ static void __cpuinit init_amd_k7(struct cpuinfo_x86 *c)
 }
 #endif
 
-#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
+#ifdef CONFIG_NUMA
 /*
  * To workaround broken NUMA config.  Read the comment in
  * srat_detect_node().
@@ -338,7 +338,7 @@ EXPORT_SYMBOL_GPL(amd_get_nb_id);
 
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
index b5147f0..71f4727 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -233,6 +233,7 @@ void __init setup_per_cpu_areas(void)
 		per_cpu(irq_stack_ptr, cpu) =
 			per_cpu(irq_stack_union.irq_stack, cpu) +
 			IRQ_STACK_SIZE - 64;
+#endif
 #ifdef CONFIG_NUMA
 		per_cpu(x86_cpu_to_node_map, cpu) =
 			early_per_cpu_map(x86_cpu_to_node_map, cpu);
@@ -246,7 +247,6 @@ void __init setup_per_cpu_areas(void)
 		 */
 		set_cpu_numa_node(cpu, early_cpu_to_node(cpu));
 #endif
-#endif
 		/*
 		 * Up to this point, the boot CPU has been using .init.data
 		 * area.  Reload any changed state for the boot CPU.
@@ -263,7 +263,7 @@ void __init setup_per_cpu_areas(void)
 #ifdef CONFIG_X86_32
 	early_per_cpu_ptr(x86_cpu_to_logical_apicid) = NULL;
 #endif
-#if defined(CONFIG_X86_64) && defined(CONFIG_NUMA)
+#ifdef CONFIG_NUMA
 	early_per_cpu_ptr(x86_cpu_to_node_map) = NULL;
 #endif
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index b7cfce5..2c20382 100644
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
index 480b357..187810b 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -36,6 +36,44 @@ cpumask_var_t node_to_cpumask_map[MAX_NUMNODES];
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
@@ -62,6 +100,37 @@ void __init setup_node_to_cpumask_map(void)
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
@@ -84,4 +153,5 @@ const struct cpumask *cpumask_of_node(int node)
 	return node_to_cpumask_map[node];
 }
 EXPORT_SYMBOL(cpumask_of_node);
-#endif
+
+#endif	/* CONFIG_DEBUG_PER_CPU_MAPS */
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 1e1026f..f545940 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -30,12 +30,6 @@ static unsigned long __initdata nodemap_addr;
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
@@ -732,34 +726,6 @@ int __cpuinit numa_cpu_node(int cpu)
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
 
 #ifndef CONFIG_NUMA_EMU
@@ -887,37 +853,6 @@ void __cpuinit numa_remove_cpu(int cpu)
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
