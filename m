Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab1GVPWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 11:22:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45089 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab1GVPWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 11:22:21 -0400
Date: Fri, 22 Jul 2011 17:21:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/numa changes for v3.1
Message-ID: <20110722152131.GA23434@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-numa-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-numa-for-linus


out-of-topic modifications in x86-numa-for-linus:
-------------------------------------------------
include/linux/mm.h                 # 1e01979: x86, numa: Implement pfn -> nid m
mm/page_alloc.c                    # 1e01979: x86, numa: Implement pfn -> nid m

 Thanks,

	Ingo

------------------>
Tejun Heo (2):
      x86, mm: s/PAGES_PER_ELEMENT/PAGES_PER_SECTION/
      x86, numa: Implement pfn -> nid mapping granularity check


 arch/x86/include/asm/mmzone_32.h |    6 ++--
 arch/x86/mm/numa.c               |   15 ++++++++++
 arch/x86/mm/numa_32.c            |    6 ++--
 include/linux/mm.h               |    1 +
 mm/page_alloc.c                  |   54 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 76 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/mmzone_32.h b/arch/x86/include/asm/mmzone_32.h
index ffa037f..55728e1 100644
--- a/arch/x86/include/asm/mmzone_32.h
+++ b/arch/x86/include/asm/mmzone_32.h
@@ -34,15 +34,15 @@ static inline void resume_map_numa_kva(pgd_t *pgd) {}
  *    64Gb / 4096bytes/page = 16777216 pages
  */
 #define MAX_NR_PAGES 16777216
-#define MAX_ELEMENTS 1024
-#define PAGES_PER_ELEMENT (MAX_NR_PAGES/MAX_ELEMENTS)
+#define MAX_SECTIONS 1024
+#define PAGES_PER_SECTION (MAX_NR_PAGES/MAX_SECTIONS)
 
 extern s8 physnode_map[];
 
 static inline int pfn_to_nid(unsigned long pfn)
 {
 #ifdef CONFIG_NUMA
-	return((int) physnode_map[(pfn) / PAGES_PER_ELEMENT]);
+	return((int) physnode_map[(pfn) / PAGES_PER_SECTION]);
 #else
 	return 0;
 #endif
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index f5510d8..fbeaaf4 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -496,6 +496,7 @@ static bool __init numa_meminfo_cover_memory(const struct numa_meminfo *mi)
 
 static int __init numa_register_memblks(struct numa_meminfo *mi)
 {
+	unsigned long uninitialized_var(pfn_align);
 	int i, nid;
 
 	/* Account for nodes with cpus and no memory */
@@ -511,6 +512,20 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 
 	/* for out of order entries */
 	sort_node_map();
+
+	/*
+	 * If sections array is gonna be used for pfn -> nid mapping, check
+	 * whether its granularity is fine enough.
+	 */
+#ifdef NODE_NOT_IN_PAGE_FLAGS
+	pfn_align = node_map_pfn_alignment();
+	if (pfn_align && pfn_align < PAGES_PER_SECTION) {
+		printk(KERN_WARNING "Node alignment %LuMB < min %LuMB, rejecting NUMA config\n",
+		       PFN_PHYS(pfn_align) >> 20,
+		       PFN_PHYS(PAGES_PER_SECTION) >> 20);
+		return -EINVAL;
+	}
+#endif
 	if (!numa_meminfo_cover_memory(mi))
 		return -EINVAL;
 
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 849a975..3adebe7 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -41,7 +41,7 @@
  *     physnode_map[16-31] = 1;
  *     physnode_map[32- ] = -1;
  */
-s8 physnode_map[MAX_ELEMENTS] __read_mostly = { [0 ... (MAX_ELEMENTS - 1)] = -1};
+s8 physnode_map[MAX_SECTIONS] __read_mostly = { [0 ... (MAX_SECTIONS - 1)] = -1};
 EXPORT_SYMBOL(physnode_map);
 
 void memory_present(int nid, unsigned long start, unsigned long end)
@@ -52,8 +52,8 @@ void memory_present(int nid, unsigned long start, unsigned long end)
 			nid, start, end);
 	printk(KERN_DEBUG "  Setting physnode_map array to node %d for pfns:\n", nid);
 	printk(KERN_DEBUG "  ");
-	for (pfn = start; pfn < end; pfn += PAGES_PER_ELEMENT) {
-		physnode_map[pfn / PAGES_PER_ELEMENT] = nid;
+	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
+		physnode_map[pfn / PAGES_PER_SECTION] = nid;
 		printk(KERN_CONT "%lx ", pfn);
 	}
 	printk(KERN_CONT "\n");
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9670f71..c70a326 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1313,6 +1313,7 @@ extern void remove_active_range(unsigned int nid, unsigned long start_pfn,
 					unsigned long end_pfn);
 extern void remove_all_active_ranges(void);
 void sort_node_map(void);
+unsigned long node_map_pfn_alignment(void);
 unsigned long __absent_pages_in_range(int nid, unsigned long start_pfn,
 						unsigned long end_pfn);
 extern unsigned long absent_pages_in_range(unsigned long start_pfn,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4e8985a..9119faa 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4585,6 +4585,60 @@ void __init sort_node_map(void)
 			cmp_node_active_region, NULL);
 }
 
+/**
+ * node_map_pfn_alignment - determine the maximum internode alignment
+ *
+ * This function should be called after node map is populated and sorted.
+ * It calculates the maximum power of two alignment which can distinguish
+ * all the nodes.
+ *
+ * For example, if all nodes are 1GiB and aligned to 1GiB, the return value
+ * would indicate 1GiB alignment with (1 << (30 - PAGE_SHIFT)).  If the
+ * nodes are shifted by 256MiB, 256MiB.  Note that if only the last node is
+ * shifted, 1GiB is enough and this function will indicate so.
+ *
+ * This is used to test whether pfn -> nid mapping of the chosen memory
+ * model has fine enough granularity to avoid incorrect mapping for the
+ * populated node map.
+ *
+ * Returns the determined alignment in pfn's.  0 if there is no alignment
+ * requirement (single node).
+ */
+unsigned long __init node_map_pfn_alignment(void)
+{
+	unsigned long accl_mask = 0, last_end = 0;
+	int last_nid = -1;
+	int i;
+
+	for_each_active_range_index_in_nid(i, MAX_NUMNODES) {
+		int nid = early_node_map[i].nid;
+		unsigned long start = early_node_map[i].start_pfn;
+		unsigned long end = early_node_map[i].end_pfn;
+		unsigned long mask;
+
+		if (!start || last_nid < 0 || last_nid == nid) {
+			last_nid = nid;
+			last_end = end;
+			continue;
+		}
+
+		/*
+		 * Start with a mask granular enough to pin-point to the
+		 * start pfn and tick off bits one-by-one until it becomes
+		 * too coarse to separate the current node from the last.
+		 */
+		mask = ~((1 << __ffs(start)) - 1);
+		while (mask && last_end <= (start & (mask << 1)))
+			mask <<= 1;
+
+		/* accumulate all internode masks */
+		accl_mask |= mask;
+	}
+
+	/* convert mask to number of pages */
+	return ~accl_mask + 1;
+}
+
 /* Find the lowest pfn for a node */
 static unsigned long __init find_min_pfn_for_node(int nid)
 {
