Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab1F2QPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 12:15:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50825 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab1F2QPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 12:15:21 -0400
Date: Wed, 29 Jun 2011 18:15:17 +0200
From: Tejun Heo <tj@kernel.org>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: "Seidel, Conny" <Conny.Seidel@amd.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 32bit NUMA and fakeNUMA broken for AMD CPUs
Message-ID: <20110629161517.GN3386@htj.dyndns.org>
References: <20110621174131.054f0422.conny.seidel_amd.com@marah.osrc.amd.com>
 <20110626102235.GC12200@mtj.dyndns.org>
 <20110626223807.47cef5c6.conny.seidel_amd.com@marah.osrc.amd.com>
 <20110628174613.GP478@escobedo.osrc.amd.com>
 <20110629094451.GJ3386@htj.dyndns.org>
 <20110629123409.GL3386@htj.dyndns.org>
 <20110629125507.GQ478@escobedo.osrc.amd.com>
 <20110629130349.GM3386@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629130349.GM3386@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans, can you please apply the following patch and post the boot log
from both SPARSEMEM and DISCONTIGMEM kernels?  On SPARSEMEM, it should
reject NUMA config and boot w/ flatmem.

Thanks.

diff --git a/arch/x86/include/asm/mmzone_32.h b/arch/x86/include/asm/mmzone_32.h
index 224e8c5..0b6c75b 100644
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
+	return((int) physnode_map[(pfn) / PAGES_PER_SECTIONS]);
 #else
 	return 0;
 #endif
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index f5510d8..9d643e2 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -496,6 +496,7 @@ static bool __init numa_meminfo_cover_memory(const struct numa_meminfo *mi)
 
 static int __init numa_register_memblks(struct numa_meminfo *mi)
 {
+	unsigned long pfn_align;
 	int i, nid;
 
 	/* Account for nodes with cpus and no memory */
@@ -511,6 +512,15 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 
 	/* for out of order entries */
 	sort_node_map();
+
+	pfn_align = node_map_pfn_alignment();
+	if (pfn_align && pfn_align < PAGES_PER_SECTION) {
+		printk(KERN_WARNING "Node alignment %LuMB < min %LuMB, rejecting NUMA config\n",
+		       (u64)pfn_align << PAGE_SHIFT >> 20,
+		       (u64)PAGES_PER_SECTION << PAGE_SHIFT >> 20);
+		return -EINVAL;
+	}
+
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
index 4e8985a..2ae7dbc 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4585,6 +4585,34 @@ void __init sort_node_map(void)
 			cmp_node_active_region, NULL);
 }
 
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
+		mask = ~((1 << __ffs(start)) - 1);
+		while (mask && last_end <= (start & (mask << 1)))
+			mask <<= 1;
+
+		accl_mask |= mask;
+	}
+
+	return ~accl_mask + 1;
+}
+
 /* Find the lowest pfn for a node */
 static unsigned long __init find_min_pfn_for_node(int nid)
 {
