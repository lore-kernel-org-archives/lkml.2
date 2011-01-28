Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab1A1On3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:43:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:53427 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178Ab1A1On1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:43:27 -0500
Date: Fri, 28 Jan 2011 14:42:46 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        eric.dumazet@gmail.com, penberg@kernel.org, tj@kernel.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, penberg@kernel.org, tj@kernel.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1295789862-25482-17-git-send-email-tj@kernel.org>
References: <1295789862-25482-17-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86: Unify NUMA initialization between 32 and 64bit
Message-ID: <tip-8db78cc4b4048e3add40bca1bc3e55057c319256@git.kernel.org>
Git-Commit-ID: 8db78cc4b4048e3add40bca1bc3e55057c319256
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 28 Jan 2011 14:42:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8db78cc4b4048e3add40bca1bc3e55057c319256
Gitweb:     http://git.kernel.org/tip/8db78cc4b4048e3add40bca1bc3e55057c319256
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Sun, 23 Jan 2011 14:37:42 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 28 Jan 2011 14:54:10 +0100

x86: Unify NUMA initialization between 32 and 64bit

Now that everything else is unified, NUMA initialization can be
unified too.

* numa_init_array() and init_cpu_to_node() are moved from
  numa_64 to numa.

* numa_32::initmem_init() is updated to call numa_init_array()
  and setup_arch() to call init_cpu_to_node() on 32bit too.

* x86_cpu_to_node_map is now initialized to NUMA_NO_NODE on
  32bit too. This is safe now as numa_init_array() will initialize
  it early during boot.

This makes NUMA mapping fully initialized before
setup_per_cpu_areas() on 32bit too and thus makes the first
percpu chunk which contains all the static variables and some of
dynamic area allocated with NUMA affinity correctly considered.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: yinghai@kernel.org
Cc: brgerst@gmail.com
Cc: gorcunov@gmail.com
Cc: shaohui.zheng@intel.com
Cc: rientjes@google.com
LKML-Reference: <1295789862-25482-17-git-send-email-tj@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
---
 arch/x86/include/asm/numa.h    |    4 ++
 arch/x86/include/asm/numa_64.h |    3 --
 arch/x86/kernel/setup.c        |    2 -
 arch/x86/mm/numa.c             |   76 +++++++++++++++++++++++++++++++++++++--
 arch/x86/mm/numa_32.c          |    1 +
 arch/x86/mm/numa_64.c          |   75 ---------------------------------------
 6 files changed, 77 insertions(+), 84 deletions(-)

diff --git a/arch/x86/include/asm/numa.h b/arch/x86/include/asm/numa.h
index d3964b2..26fc6e2 100644
--- a/arch/x86/include/asm/numa.h
+++ b/arch/x86/include/asm/numa.h
@@ -34,11 +34,15 @@ static inline void set_apicid_to_node(int apicid, s16 node)
 #ifdef CONFIG_NUMA
 extern void __cpuinit numa_set_node(int cpu, int node);
 extern void __cpuinit numa_clear_node(int cpu);
+extern void __init numa_init_array(void);
+extern void __init init_cpu_to_node(void);
 extern void __cpuinit numa_add_cpu(int cpu);
 extern void __cpuinit numa_remove_cpu(int cpu);
 #else	/* CONFIG_NUMA */
 static inline void numa_set_node(int cpu, int node)	{ }
 static inline void numa_clear_node(int cpu)		{ }
+static inline void numa_init_array(void)		{ }
+static inline void init_cpu_to_node(void)		{ }
 static inline void numa_add_cpu(int cpu)		{ }
 static inline void numa_remove_cpu(int cpu)		{ }
 #endif	/* CONFIG_NUMA */
diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index 123f185..2819afa 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -13,7 +13,6 @@ extern int compute_hash_shift(struct bootnode *nodes, int numblks,
 
 #define ZONE_ALIGN (1UL << (MAX_ORDER+PAGE_SHIFT))
 
-extern void numa_init_array(void);
 extern int numa_off;
 
 extern unsigned long numa_free_all_bootmem(void);
@@ -28,7 +27,6 @@ extern void setup_node_bootmem(int nodeid, unsigned long start,
  */
 #define NODE_MIN_SIZE (4*1024*1024)
 
-extern void __init init_cpu_to_node(void);
 extern int __cpuinit numa_cpu_node(int cpu);
 
 #ifdef CONFIG_NUMA_EMU
@@ -37,7 +35,6 @@ extern int __cpuinit numa_cpu_node(int cpu);
 void numa_emu_cmdline(char *);
 #endif /* CONFIG_NUMA_EMU */
 #else
-static inline void init_cpu_to_node(void)		{ }
 static inline int numa_cpu_node(int cpu)		{ return NUMA_NO_NODE; }
 #endif
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d3cfe26..1202341 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1040,9 +1040,7 @@ void __init setup_arch(char **cmdline_p)
 
 	prefill_possible_map();
 
-#ifdef CONFIG_X86_64
 	init_cpu_to_node();
-#endif
 
 	init_apic_mappings();
 	ioapic_and_gsi_init();
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 75abecb..bf60715 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -38,11 +38,7 @@ EXPORT_SYMBOL(node_to_cpumask_map);
 /*
  * Map cpu index to node index
  */
-#ifdef CONFIG_X86_32
-DEFINE_EARLY_PER_CPU(int, x86_cpu_to_node_map, 0);
-#else
 DEFINE_EARLY_PER_CPU(int, x86_cpu_to_node_map, NUMA_NO_NODE);
-#endif
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_node_map);
 
 void __cpuinit numa_set_node(int cpu, int node)
@@ -99,6 +95,78 @@ void __init setup_node_to_cpumask_map(void)
 	pr_debug("Node to cpumask map for %d nodes\n", nr_node_ids);
 }
 
+/*
+ * There are unfortunately some poorly designed mainboards around that
+ * only connect memory to a single CPU. This breaks the 1:1 cpu->node
+ * mapping. To avoid this fill in the mapping for all possible CPUs,
+ * as the number of CPUs is not known yet. We round robin the existing
+ * nodes.
+ */
+void __init numa_init_array(void)
+{
+	int rr, i;
+
+	rr = first_node(node_online_map);
+	for (i = 0; i < nr_cpu_ids; i++) {
+		if (early_cpu_to_node(i) != NUMA_NO_NODE)
+			continue;
+		numa_set_node(i, rr);
+		rr = next_node(rr, node_online_map);
+		if (rr == MAX_NUMNODES)
+			rr = first_node(node_online_map);
+	}
+}
+
+static __init int find_near_online_node(int node)
+{
+	int n, val;
+	int min_val = INT_MAX;
+	int best_node = -1;
+
+	for_each_online_node(n) {
+		val = node_distance(node, n);
+
+		if (val < min_val) {
+			min_val = val;
+			best_node = n;
+		}
+	}
+
+	return best_node;
+}
+
+/*
+ * Setup early cpu_to_node.
+ *
+ * Populate cpu_to_node[] only if x86_cpu_to_apicid[],
+ * and apicid_to_node[] tables have valid entries for a CPU.
+ * This means we skip cpu_to_node[] initialisation for NUMA
+ * emulation and faking node case (when running a kernel compiled
+ * for NUMA on a non NUMA box), which is OK as cpu_to_node[]
+ * is already initialized in a round robin manner at numa_init_array,
+ * prior to this call, and this initialization is good enough
+ * for the fake NUMA cases.
+ *
+ * Called before the per_cpu areas are setup.
+ */
+void __init init_cpu_to_node(void)
+{
+	int cpu;
+	u16 *cpu_to_apicid = early_per_cpu_ptr(x86_cpu_to_apicid);
+
+	BUG_ON(cpu_to_apicid == NULL);
+
+	for_each_possible_cpu(cpu) {
+		int node = numa_cpu_node(cpu);
+
+		if (node == NUMA_NO_NODE)
+			continue;
+		if (!node_online(node))
+			node = find_near_online_node(node);
+		numa_set_node(cpu, node);
+	}
+}
+
 #ifndef CONFIG_DEBUG_PER_CPU_MAPS
 
 # ifndef CONFIG_NUMA_EMU
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 8d91d22..505bb04 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -367,6 +367,7 @@ void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
 	 */
 
 	get_memcfg_numa();
+	numa_init_array();
 
 	kva_pages = roundup(calculate_numa_remap_pages(), PTRS_PER_PTE);
 
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 14664f5..f548fbf 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -224,28 +224,6 @@ setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
 	node_set_online(nodeid);
 }
 
-/*
- * There are unfortunately some poorly designed mainboards around that
- * only connect memory to a single CPU. This breaks the 1:1 cpu->node
- * mapping. To avoid this fill in the mapping for all possible CPUs,
- * as the number of CPUs is not known yet. We round robin the existing
- * nodes.
- */
-void __init numa_init_array(void)
-{
-	int rr, i;
-
-	rr = first_node(node_online_map);
-	for (i = 0; i < nr_cpu_ids; i++) {
-		if (early_cpu_to_node(i) != NUMA_NO_NODE)
-			continue;
-		numa_set_node(i, rr);
-		rr = next_node(rr, node_online_map);
-		if (rr == MAX_NUMNODES)
-			rr = first_node(node_online_map);
-	}
-}
-
 #ifdef CONFIG_NUMA_EMU
 /* Numa emulation */
 static struct bootnode nodes[MAX_NUMNODES] __initdata;
@@ -664,59 +642,6 @@ unsigned long __init numa_free_all_bootmem(void)
 	return pages;
 }
 
-#ifdef CONFIG_NUMA
-
-static __init int find_near_online_node(int node)
-{
-	int n, val;
-	int min_val = INT_MAX;
-	int best_node = -1;
-
-	for_each_online_node(n) {
-		val = node_distance(node, n);
-
-		if (val < min_val) {
-			min_val = val;
-			best_node = n;
-		}
-	}
-
-	return best_node;
-}
-
-/*
- * Setup early cpu_to_node.
- *
- * Populate cpu_to_node[] only if x86_cpu_to_apicid[],
- * and apicid_to_node[] tables have valid entries for a CPU.
- * This means we skip cpu_to_node[] initialisation for NUMA
- * emulation and faking node case (when running a kernel compiled
- * for NUMA on a non NUMA box), which is OK as cpu_to_node[]
- * is already initialized in a round robin manner at numa_init_array,
- * prior to this call, and this initialization is good enough
- * for the fake NUMA cases.
- *
- * Called before the per_cpu areas are setup.
- */
-void __init init_cpu_to_node(void)
-{
-	int cpu;
-	u16 *cpu_to_apicid = early_per_cpu_ptr(x86_cpu_to_apicid);
-
-	BUG_ON(cpu_to_apicid == NULL);
-
-	for_each_possible_cpu(cpu) {
-		int node = numa_cpu_node(cpu);
-
-		if (node == NUMA_NO_NODE)
-			continue;
-		if (!node_online(node))
-			node = find_near_online_node(node);
-		numa_set_node(cpu, node);
-	}
-}
-#endif
-
 int __cpuinit numa_cpu_node(int cpu)
 {
 	int apicid = early_per_cpu(x86_cpu_to_apicid, cpu);
