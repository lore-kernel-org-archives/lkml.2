Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab1A1Omb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:42:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:53395 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791Ab1A1Om3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:42:29 -0500
Date: Fri, 28 Jan 2011 14:41:39 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        penberg@kernel.org, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        penberg@kernel.org, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com, mingo@elte.hu
In-Reply-To: <1295789862-25482-14-git-send-email-tj@kernel.org>
References: <1295789862-25482-14-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86: Unify cpu/apicid <-> NUMA node mapping between 32 and 64bit
Message-ID: <tip-bbc9e2f452d9c4b166d1f9a78d941d80173312fe@git.kernel.org>
Git-Commit-ID: bbc9e2f452d9c4b166d1f9a78d941d80173312fe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 28 Jan 2011 14:41:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bbc9e2f452d9c4b166d1f9a78d941d80173312fe
Gitweb:     http://git.kernel.org/tip/bbc9e2f452d9c4b166d1f9a78d941d80173312fe
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Sun, 23 Jan 2011 14:37:39 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 28 Jan 2011 14:54:09 +0100

x86: Unify cpu/apicid <-> NUMA node mapping between 32 and 64bit

The mapping between cpu/apicid and node is done via
apicid_to_node[] on 64bit and apicid_2_node[] +
apic->x86_32_numa_cpu_node() on 32bit. This difference makes it
difficult to further unify 32 and 64bit NUMA handling.

This patch unifies it by replacing both apicid_to_node[] and
apicid_2_node[] with __apicid_to_node[] array, which is accessed
by two accessors - set_apicid_to_node() and numa_cpu_node().  On
64bit, numa_cpu_node() always consults __apicid_to_node[]
directly while 32bit goes through apic->numa_cpu_node() method
to allow apic implementations to override it.

srat_detect_node() for amd cpus contains workaround for broken
NUMA configuration which assumes relationship between APIC ID,
HT node ID and NUMA topology.  Leave it to access
__apicid_to_node[] directly as mapping through CPU might result
in undesirable behavior change.  The comment is reformatted and
updated to note the ugliness.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Cc: eric.dumazet@gmail.com
Cc: yinghai@kernel.org
Cc: brgerst@gmail.com
Cc: gorcunov@gmail.com
Cc: shaohui.zheng@intel.com
Cc: rientjes@google.com
LKML-Reference: <1295789862-25482-14-git-send-email-tj@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: David Rientjes <rientjes@google.com>
---
 arch/x86/include/asm/mpspec.h  |    1 -
 arch/x86/include/asm/numa.h    |   28 +++++++++++++++++++++++
 arch/x86/include/asm/numa_32.h |    6 +++++
 arch/x86/include/asm/numa_64.h |    5 +--
 arch/x86/kernel/acpi/boot.c    |    3 +-
 arch/x86/kernel/apic/apic.c    |    2 +-
 arch/x86/kernel/cpu/amd.c      |   47 +++++++++++++++++++++++++--------------
 arch/x86/kernel/cpu/intel.c    |    3 +-
 arch/x86/kernel/smpboot.c      |    6 +----
 arch/x86/mm/amdtopology_64.c   |    4 +-
 arch/x86/mm/numa.c             |    6 ++++-
 arch/x86/mm/numa_32.c          |    6 +++++
 arch/x86/mm/numa_64.c          |   26 +++++++++------------
 arch/x86/mm/srat_32.c          |    2 +-
 arch/x86/mm/srat_64.c          |   12 +++++-----
 15 files changed, 101 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index edc2a45..9c7d95f 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -25,7 +25,6 @@ extern int pic_mode;
 #define MAX_IRQ_SOURCES		256
 
 extern unsigned int def_to_bigsmp;
-extern u8 apicid_2_node[];
 
 #ifdef CONFIG_X86_NUMAQ
 extern int mp_bus_id_to_node[MAX_MP_BUSSES];
diff --git a/arch/x86/include/asm/numa.h b/arch/x86/include/asm/numa.h
index 27da400..5e01c76 100644
--- a/arch/x86/include/asm/numa.h
+++ b/arch/x86/include/asm/numa.h
@@ -1,5 +1,33 @@
+#ifndef _ASM_X86_NUMA_H
+#define _ASM_X86_NUMA_H
+
+#include <asm/apicdef.h>
+
+#ifdef CONFIG_NUMA
+/*
+ * __apicid_to_node[] stores the raw mapping between physical apicid and
+ * node and is used to initialize cpu_to_node mapping.
+ *
+ * The mapping may be overridden by apic->numa_cpu_node() on 32bit and thus
+ * should be accessed by the accessors - set_apicid_to_node() and
+ * numa_cpu_node().
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
index b0ef2b4..cdf8043 100644
--- a/arch/x86/include/asm/numa_32.h
+++ b/arch/x86/include/asm/numa_32.h
@@ -6,6 +6,12 @@ extern int numa_off;
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
index 0493be3..4982a9c 100644
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
@@ -44,6 +42,7 @@ void numa_emu_cmdline(char *);
 #endif /* CONFIG_NUMA_EMU */
 #else
 static inline void init_cpu_to_node(void)		{ }
+static inline int numa_cpu_node(int cpu)		{ return NUMA_NO_NODE; }
 static inline void numa_set_node(int cpu, int node)	{ }
 static inline void numa_clear_node(int cpu)		{ }
 static inline void numa_add_cpu(int cpu, int node)	{ }
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index b3a7113..a7bca59 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -589,11 +589,10 @@ static void acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
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
index 0f4f3c1..4686ea5 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2026,7 +2026,7 @@ int default_x86_32_numa_cpu_node(int cpu)
 	int apicid = early_per_cpu(x86_cpu_to_apicid, cpu);
 
 	if (apicid != BAD_APICID)
-		return apicid_2_node[apicid];
+		return __apicid_to_node[apicid];
 	return NUMA_NO_NODE;
 #else
 	return 0;
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 7c7bedb..3cce8f2 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -234,17 +234,21 @@ static void __cpuinit init_amd_k7(struct cpuinfo_x86 *c)
 #endif
 
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
+/*
+ * To workaround broken NUMA config.  Read the comment in
+ * srat_detect_node().
+ */
 static int __cpuinit nearby_node(int apicid)
 {
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
@@ -339,26 +343,35 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 	int node;
 	unsigned apicid = c->apicid;
 
-	node = per_cpu(cpu_llc_id, cpu);
+	node = numa_cpu_node(cpu);
+	if (node == NUMA_NO_NODE)
+		node = per_cpu(cpu_llc_id, cpu);
 
-	if (apicid_to_node[apicid] != NUMA_NO_NODE)
-		node = apicid_to_node[apicid];
 	if (!node_online(node)) {
-		/* Two possibilities here:
-		   - The CPU is missing memory and no node was created.
-		   In that case try picking one from a nearby CPU
-		   - The APIC IDs differ from the HyperTransport node IDs
-		   which the K8 northbridge parsing fills in.
-		   Assume they are all increased by a constant offset,
-		   but in the same order as the HT nodeids.
-		   If that doesn't result in a usable node fall back to the
-		   path for the previous case.  */
-
+		/*
+		 * Two possibilities here:
+		 *
+		 * - The CPU is missing memory and no node was created.  In
+		 *   that case try picking one from a nearby CPU.
+		 *
+		 * - The APIC IDs differ from the HyperTransport node IDs
+		 *   which the K8 northbridge parsing fills in.  Assume
+		 *   they are all increased by a constant offset, but in
+		 *   the same order as the HT nodeids.  If that doesn't
+		 *   result in a usable node fall back to the path for the
+		 *   previous case.
+		 *
+		 * This workaround operates directly on the mapping between
+		 * APIC ID and NUMA node, assuming certain relationship
+		 * between APIC ID, HT node ID and NUMA topology.  As going
+		 * through CPU mapping may alter the outcome, directly
+		 * access __apicid_to_node[].
+		 */
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
index 5319cdd..b7cfce5 100644
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
 
-	node = apic->x86_32_numa_cpu_node(cpu);
+	node = numa_cpu_node(cpu);
 	if (!node_online(node))
 		node = first_online_node;
 
diff --git a/arch/x86/mm/amdtopology_64.c b/arch/x86/mm/amdtopology_64.c
index f21962c..c7fae38 100644
--- a/arch/x86/mm/amdtopology_64.c
+++ b/arch/x86/mm/amdtopology_64.c
@@ -247,7 +247,7 @@ void __init amd_fake_nodes(const struct bootnode *nodes, int nr_nodes)
 		__acpi_map_pxm_to_node(nid, i);
 #endif
 	}
-	memcpy(apicid_to_node, fake_apicid_to_node, sizeof(apicid_to_node));
+	memcpy(__apicid_to_node, fake_apicid_to_node, sizeof(__apicid_to_node));
 }
 #endif /* CONFIG_NUMA_EMU */
 
@@ -285,7 +285,7 @@ int __init amd_scan_nodes(void)
 				nodes[i].start >> PAGE_SHIFT,
 				nodes[i].end >> PAGE_SHIFT);
 		for (j = apicid_base; j < cores + apicid_base; j++)
-			apicid_to_node[(i << bits) + j] = i;
+			set_apicid_to_node((i << bits) + j, i);
 		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
 	}
 
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index ebf6d78..480b357 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -26,8 +26,12 @@ static __init int numa_setup(char *opt)
 early_param("numa", numa_setup);
 
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
index 84a3e4c..8d91d22 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -110,6 +110,12 @@ void set_pmd_pfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags);
 
 static unsigned long kva_start_pfn;
 static unsigned long kva_pages;
+
+int __cpuinit numa_cpu_node(int cpu)
+{
+	return apic->x86_32_numa_cpu_node(cpu);
+}
+
 /*
  * FLAT - support for basic PC memory model with discontig enabled, essentially
  *        a single node with all available processors in it with a flat
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 95ea155..1e1026f 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -26,10 +26,6 @@ EXPORT_SYMBOL(node_data);
 
 struct memnode memnode;
 
-s16 apicid_to_node[MAX_LOCAL_APIC] __cpuinitdata = {
-	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
-};
-
 static unsigned long __initdata nodemap_addr;
 static unsigned long __initdata nodemap_size;
 
@@ -716,12 +712,8 @@ void __init init_cpu_to_node(void)
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
@@ -731,6 +723,14 @@ void __init init_cpu_to_node(void)
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
@@ -776,13 +776,9 @@ void __cpuinit numa_remove_cpu(int cpu)
 void __cpuinit numa_add_cpu(int cpu)
 {
 	unsigned long addr;
-	u16 apicid;
-	int physnid;
-	int nid = NUMA_NO_NODE;
+	int physnid, nid;
 
-	apicid = early_per_cpu(x86_cpu_to_apicid, cpu);
-	if (apicid != BAD_APICID)
-		nid = apicid_to_node[apicid];
+	nid = numa_cpu_node(cpu);
 	if (nid == NUMA_NO_NODE)
 		nid = early_cpu_to_node(cpu);
 	BUG_ON(nid == NUMA_NO_NODE || !node_online(nid));
diff --git a/arch/x86/mm/srat_32.c b/arch/x86/mm/srat_32.c
index 6027a48..48651c6 100644
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
index 603d285..9a97261 100644
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
@@ -138,7 +138,7 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
 		return;
 	}
-	apicid_to_node[apic_id] = node;
+	set_apicid_to_node(apic_id, node);
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
 	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u\n",
@@ -178,7 +178,7 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 		return;
 	}
 
-	apicid_to_node[apic_id] = node;
+	set_apicid_to_node(apic_id, node);
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
 	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u\n",
@@ -521,7 +521,7 @@ void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
 		 * node, it must now point to the fake node ID.
 		 */
 		for (j = 0; j < MAX_LOCAL_APIC; j++)
-			if (apicid_to_node[j] == nid &&
+			if (__apicid_to_node[j] == nid &&
 			    fake_apicid_to_node[j] == NUMA_NO_NODE)
 				fake_apicid_to_node[j] = i;
 	}
@@ -532,13 +532,13 @@ void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
 	 * value.
 	 */
 	for (i = 0; i < MAX_LOCAL_APIC; i++)
-		if (apicid_to_node[i] != NUMA_NO_NODE &&
+		if (__apicid_to_node[i] != NUMA_NO_NODE &&
 		    fake_apicid_to_node[i] == NUMA_NO_NODE)
 			fake_apicid_to_node[i] = 0;
 
 	for (i = 0; i < num_nodes; i++)
 		__acpi_map_pxm_to_node(fake_node_to_pxm_map[i], i);
-	memcpy(apicid_to_node, fake_apicid_to_node, sizeof(apicid_to_node));
+	memcpy(__apicid_to_node, fake_apicid_to_node, sizeof(__apicid_to_node));
 
 	nodes_clear(nodes_parsed);
 	for (i = 0; i < num_nodes; i++)
