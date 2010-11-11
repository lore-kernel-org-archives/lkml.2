Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab0KKLDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:03:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:41226 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755602Ab0KKLDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:03:20 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/9] x86: Unify cpu/apicid <-> NUMA node mapping between 32 and 64bit
Date: Thu, 11 Nov 2010 12:02:40 +0100
Message-Id: <1289473363-29440-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289473363-29440-1-git-send-email-tj@kernel.org>
References: <1289473363-29440-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Nov 2010 11:02:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mapping between cpu/apicid and node is done via apicid_to_node[]
on 64bit and apicid_2_node[] + apic->numa_cpu_node() on 32bit.  This
difference makes it difficult to further unify 32 and 64bit NUMA
hanlding.

This patch unifies it by replacing both apicid_to_node[] and
apicid_2_node[] with __apicid_to_node[] array, which is accessed by
two accessors - set_apicid_to_node() and numa_cpu_node().  On 64bit,
numa_cpu_node() always consults __apicid_to_node[] directly while
32bit goes through apic->numa_cpu_node() method to allow apic
implementation to override it.

There are several places where using numa_cpu_node() is awkward and
the override doesn't matter.  In those places, __apicid_to_node[] are
used directly.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/mpspec.h  |    1 -
 arch/x86/include/asm/numa.h    |   31 +++++++++++++++++++++++++++++++
 arch/x86/include/asm/numa_32.h |    6 ++++++
 arch/x86/include/asm/numa_64.h |    5 ++---
 arch/x86/kernel/acpi/boot.c    |    3 +--
 arch/x86/kernel/apic/apic.c    |    6 +++++-
 arch/x86/kernel/cpu/amd.c      |   14 +++++++-------
 arch/x86/kernel/cpu/intel.c    |    3 +--
 arch/x86/kernel/smpboot.c      |    6 +-----
 arch/x86/mm/k8topology_64.c    |    2 +-
 arch/x86/mm/numa.c             |    6 +++++-
 arch/x86/mm/numa_32.c          |    6 ++++++
 arch/x86/mm/numa_64.c          |   18 +++++++++---------
 arch/x86/mm/srat_32.c          |    2 +-
 arch/x86/mm/srat_64.c          |   10 +++++-----
 15 files changed, 81 insertions(+), 38 deletions(-)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 018ffc1..ae78732 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -24,7 +24,6 @@ extern int pic_mode;
 #define MAX_IRQ_SOURCES		256
 
 extern unsigned int def_to_bigsmp;
-extern u8 apicid_2_node[];
 
 #ifdef CONFIG_X86_NUMAQ
 extern int mp_bus_id_to_node[MAX_MP_BUSSES];
diff --git a/arch/x86/include/asm/numa.h b/arch/x86/include/asm/numa.h
index 27da400..e40bf6f 100644
--- a/arch/x86/include/asm/numa.h
+++ b/arch/x86/include/asm/numa.h
@@ -1,5 +1,36 @@
+#ifndef _ASM_X86_NUMA_H
+#define _ASM_X86_NUMA_H
+
+#include <asm/apicdef.h>
+
+#ifdef CONFIG_NUMA
+/*
+ * __apicid_to_node[] stores the raw mapping between physical apicid
+ * and node and is used to initialize cpu_to_node mapping.
+ *
+ * The mapping may be overridden by apic->numa_cpu_node() on 32bit and
+ * thus should be accessed by the accessors - set_apicid_to_node() and
+ * numa_cpu_node().
+ *
+ * If the user knows that it doesn't care about 32bit APIC-specific
+ * overrides, __apicid_to_node[] may be used directly.
+ */
+extern s16 __apicid_to_node[MAX_LOCAL_APIC];
+
+static inline void set_apicid_to_node(int apicid, s16 node)
+{
+	__apicid_to_node[apicid] = node;
+}
+#else	/* CONFIG_NUMA */
+static inline void set_apicid_to_node(int apicid, s16 node)
+{
+}
+#endif	/* CONFIG_NUMA */
+
 #ifdef CONFIG_X86_32
 # include "numa_32.h"
 #else
 # include "numa_64.h"
 #endif
+
+#endif	/* _ASM_X86_NUMA_H */
diff --git a/arch/x86/include/asm/numa_32.h b/arch/x86/include/asm/numa_32.h
index a372290..d30eb6c 100644
--- a/arch/x86/include/asm/numa_32.h
+++ b/arch/x86/include/asm/numa_32.h
@@ -4,6 +4,12 @@
 extern int pxm_to_nid(int pxm);
 extern void numa_remove_cpu(int cpu);
 
+#ifdef CONFIG_NUMA
+extern int __cpuinit numa_cpu_node(int apicid);
+#else	/* CONFIG_NUMA */
+static inline int numa_cpu_node(int cpu)		{ return NUMA_NO_NODE; }
+#endif	/* CONFIG_NUMA */
+
 #ifdef CONFIG_HIGHMEM
 extern void set_highmem_pages_init(void);
 #else
diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index 823e070..17171ee 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -2,7 +2,6 @@
 #define _ASM_X86_NUMA_64_H
 
 #include <linux/nodemask.h>
-#include <asm/apicdef.h>
 
 struct bootnode {
 	u64 start;
@@ -17,8 +16,6 @@ extern int compute_hash_shift(struct bootnode *nodes, int numblks,
 extern void numa_init_array(void);
 extern int numa_off;
 
-extern s16 apicid_to_node[MAX_LOCAL_APIC];
-
 extern unsigned long numa_free_all_bootmem(void);
 extern void setup_node_bootmem(int nodeid, unsigned long start,
 			       unsigned long end);
@@ -32,6 +29,7 @@ extern void setup_node_bootmem(int nodeid, unsigned long start,
 #define NODE_MIN_SIZE (4*1024*1024)
 
 extern void __init init_cpu_to_node(void);
+extern int __cpuinit numa_cpu_node(int cpu);
 extern void __cpuinit numa_set_node(int cpu, int node);
 extern void __cpuinit numa_clear_node(int cpu);
 extern void __cpuinit numa_add_cpu(int cpu);
@@ -43,6 +41,7 @@ extern void __cpuinit numa_remove_cpu(int cpu);
 #endif /* CONFIG_NUMA_EMU */
 #else
 static inline void init_cpu_to_node(void)		{ }
+static inline int numa_cpu_node(int cpu)		{ return NUMA_NO_NODE; }
 static inline void numa_set_node(int cpu, int node)	{ }
 static inline void numa_clear_node(int cpu)		{ }
 static inline void numa_add_cpu(int cpu, int node)	{ }
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 71232b9..edff4f5 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -583,11 +583,10 @@ static void acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
 	nid = acpi_get_node(handle);
 	if (nid == -1 || !node_online(nid))
 		return;
+	set_apicid_to_node(physid, nid);
 #ifdef CONFIG_X86_64
-	apicid_to_node[physid] = nid;
 	numa_set_node(cpu, nid);
 #else /* CONFIG_X86_32 */
-	apicid_2_node[physid] = nid;
 	cpu_to_node_map[cpu] = nid;
 #endif
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 0676454..3e20f4f 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2011,7 +2011,11 @@ void default_init_apic_ldr(void)
 int default_numa_cpu_node(int cpu)
 {
 #ifdef CONFIG_NUMA
-	return apicid_2_node[early_per_cpu(x86_cpu_to_apicid, cpu)];
+	int apicid = early_per_cpu(x86_cpu_to_apicid, cpu);
+
+	if (apicid != BAD_APICID)
+		return __apicid_to_node[apicid];
+	return NUMA_NO_NODE;
 #else
 	return 0;
 #endif
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 9e093f8..aa3c613 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -239,12 +239,12 @@ static int __cpuinit nearby_node(int apicid)
 	int i, node;
 
 	for (i = apicid - 1; i >= 0; i--) {
-		node = apicid_to_node[i];
+		node = __apicid_to_node[i];
 		if (node != NUMA_NO_NODE && node_online(node))
 			return node;
 	}
 	for (i = apicid + 1; i < MAX_LOCAL_APIC; i++) {
-		node = apicid_to_node[i];
+		node = __apicid_to_node[i];
 		if (node != NUMA_NO_NODE && node_online(node))
 			return node;
 	}
@@ -339,10 +339,10 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 	int node;
 	unsigned apicid = c->apicid;
 
-	node = per_cpu(cpu_llc_id, cpu);
+	node = numa_cpu_node(cpu);
+	if (node == NUMA_NO_NODE)
+		node = per_cpu(cpu_llc_id, cpu);
 
-	if (apicid_to_node[apicid] != NUMA_NO_NODE)
-		node = apicid_to_node[apicid];
 	if (!node_online(node)) {
 		/* Two possibilities here:
 		   - The CPU is missing memory and no node was created.
@@ -357,8 +357,8 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 		int ht_nodeid = c->initial_apicid;
 
 		if (ht_nodeid >= 0 &&
-		    apicid_to_node[ht_nodeid] != NUMA_NO_NODE)
-			node = apicid_to_node[ht_nodeid];
+		    __apicid_to_node[ht_nodeid] != NUMA_NO_NODE)
+			node = __apicid_to_node[ht_nodeid];
 		/* Pick a nearby node */
 		if (!node_online(node))
 			node = nearby_node(apicid);
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index d16c2c5..6052004 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -279,11 +279,10 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
 	unsigned node;
 	int cpu = smp_processor_id();
-	int apicid = cpu_has_apic ? hard_smp_processor_id() : c->apicid;
 
 	/* Don't do the funky fallback heuristics the AMD version employs
 	   for now. */
-	node = apicid_to_node[apicid];
+	node = numa_cpu_node(cpu);
 	if (node == NUMA_NO_NODE || !node_online(node)) {
 		/* reuse the value from init_cpu_to_node() */
 		node = cpu_to_node(cpu);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 963c44b..4b8b72d 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -71,10 +71,6 @@
 #include <asm/smpboot_hooks.h>
 #include <asm/i8259.h>
 
-#ifdef CONFIG_X86_32
-u8 apicid_2_node[MAX_LOCAL_APIC];
-#endif
-
 /* State of each CPU */
 DEFINE_PER_CPU(int, cpu_state) = { 0 };
 
@@ -170,7 +166,7 @@ static void map_cpu_to_logical_apicid(void)
 	int cpu = smp_processor_id();
 	int node;
 
-	node = apic->numa_cpu_node(cpu);
+	node = numa_cpu_node(cpu);
 	if (!node_online(node))
 		node = first_online_node;
 
diff --git a/arch/x86/mm/k8topology_64.c b/arch/x86/mm/k8topology_64.c
index 804a3b6..484d80c 100644
--- a/arch/x86/mm/k8topology_64.c
+++ b/arch/x86/mm/k8topology_64.c
@@ -228,7 +228,7 @@ int __init k8_scan_nodes(void)
 				nodes[i].start >> PAGE_SHIFT,
 				nodes[i].end >> PAGE_SHIFT);
 		for (j = apicid_base; j < cores + apicid_base; j++)
-			apicid_to_node[(i << bits) + j] = i;
+			set_apicid_to_node((i << bits) + j, i);
 		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
 	}
 
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 787c52c..63db99c 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -4,8 +4,12 @@
 #include <linux/bootmem.h>
 
 /*
- * Which logical CPUs are on which nodes
+ * apicid, cpu, node mappings
  */
+s16 __apicid_to_node[MAX_LOCAL_APIC] __cpuinitdata = {
+	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
+};
+
 cpumask_var_t node_to_cpumask_map[MAX_NUMNODES];
 EXPORT_SYMBOL(node_to_cpumask_map);
 
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 84a3e4c..9f27ae2 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -110,6 +110,12 @@ void set_pmd_pfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags);
 
 static unsigned long kva_start_pfn;
 static unsigned long kva_pages;
+
+int __cpuinit numa_cpu_node(int cpu)
+{
+	return apic->numa_cpu_node(cpu);
+}
+
 /*
  * FLAT - support for basic PC memory model with discontig enabled, essentially
  *        a single node with all available processors in it with a flat
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 7ffc9b7..47ca1b0 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -26,10 +26,6 @@ EXPORT_SYMBOL(node_data);
 
 struct memnode memnode;
 
-s16 apicid_to_node[MAX_LOCAL_APIC] __cpuinitdata = {
-	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
-};
-
 int numa_off __initdata;
 static unsigned long __initdata nodemap_addr;
 static unsigned long __initdata nodemap_size;
@@ -721,12 +717,8 @@ void __init init_cpu_to_node(void)
 	BUG_ON(cpu_to_apicid == NULL);
 
 	for_each_possible_cpu(cpu) {
-		int node;
-		u16 apicid = cpu_to_apicid[cpu];
+		int node = numa_cpu_node(cpu);
 
-		if (apicid == BAD_APICID)
-			continue;
-		node = apicid_to_node[apicid];
 		if (node == NUMA_NO_NODE)
 			continue;
 		if (!node_online(node))
@@ -736,6 +728,14 @@ void __init init_cpu_to_node(void)
 }
 #endif
 
+int __cpuinit numa_cpu_node(int cpu)
+{
+	int apicid = early_per_cpu(x86_cpu_to_apicid, cpu);
+
+	if (apicid != BAD_APICID)
+		return __apicid_to_node[apicid];
+	return NUMA_NO_NODE;
+}
 
 void __cpuinit numa_set_node(int cpu, int node)
 {
diff --git a/arch/x86/mm/srat_32.c b/arch/x86/mm/srat_32.c
index e55e748..7fcae55 100644
--- a/arch/x86/mm/srat_32.c
+++ b/arch/x86/mm/srat_32.c
@@ -255,7 +255,7 @@ int __init get_memcfg_from_srat(void)
 			 num_memory_chunks);
 
 	for (i = 0; i < MAX_LOCAL_APIC; i++)
-		apicid_2_node[i] = pxm_to_node(apicid_to_pxm[i]);
+		set_apicid_to_node(i, pxm_to_node(apicid_to_pxm[i]));
 
 	for (j = 0; j < num_memory_chunks; j++){
 		struct node_memory_chunk_s * chunk = &node_memory_chunk[j];
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index a35cb9d..1af9c6e 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -79,7 +79,7 @@ static __init void bad_srat(void)
 	printk(KERN_ERR "SRAT: SRAT not used.\n");
 	acpi_numa = -1;
 	for (i = 0; i < MAX_LOCAL_APIC; i++)
-		apicid_to_node[i] = NUMA_NO_NODE;
+		set_apicid_to_node(i, NUMA_NO_NODE);
 	for (i = 0; i < MAX_NUMNODES; i++) {
 		nodes[i].start = nodes[i].end = 0;
 		nodes_add[i].start = nodes_add[i].end = 0;
@@ -134,7 +134,7 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 	}
 
 	apic_id = pa->apic_id;
-	apicid_to_node[apic_id] = node;
+	set_apicid_to_node(apic_id, node);
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
 	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u\n",
@@ -168,7 +168,7 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 		apic_id = (pa->apic_id << 8) | pa->local_sapic_eid;
 	else
 		apic_id = pa->apic_id;
-	apicid_to_node[apic_id] = node;
+	set_apicid_to_node(apic_id, node);
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
 	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u\n",
@@ -512,13 +512,13 @@ void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
 		 * node, it must now point to the fake node ID.
 		 */
 		for (j = 0; j < MAX_LOCAL_APIC; j++)
-			if (apicid_to_node[j] == nid &&
+			if (__apicid_to_node[j] == nid &&
 			    fake_apicid_to_node[j] == NUMA_NO_NODE)
 				fake_apicid_to_node[j] = i;
 	}
 	for (i = 0; i < num_nodes; i++)
 		__acpi_map_pxm_to_node(fake_node_to_pxm_map[i], i);
-	memcpy(apicid_to_node, fake_apicid_to_node, sizeof(apicid_to_node));
+	memcpy(__apicid_to_node, fake_apicid_to_node, sizeof(__apicid_to_node));
 
 	nodes_clear(nodes_parsed);
 	for (i = 0; i < num_nodes; i++)
-- 
1.7.1

