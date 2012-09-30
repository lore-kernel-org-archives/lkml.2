Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab2I3H6a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 03:58:30 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:33007 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab2I3H5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 03:57:46 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 11/13] x86: Only direct map addresses that are marked as E820_RAM
Date: Sun, 30 Sep 2012 00:57:22 -0700
Message-Id: <1348991844-12285-12-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348991844-12285-1-git-send-email-yinghai@kernel.org>
References: <1348991844-12285-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Shin <jacob.shin@amd.com>

Currently direct mappings are created for [ 0 to max_low_pfn<<PAGE_SHIFT )
and [ 4GB to max_pfn<<PAGE_SHIFT ), which may include regions that are not
backed by actual DRAM. This is fine for holes under 4GB which are covered
by fixed and variable range MTRRs to be UC. However, we run into trouble
on higher memory addresses which cannot be covered by MTRRs.

Our system with 1TB of RAM has an e820 that looks like this:

 BIOS-e820: [mem 0x0000000000000000-0x00000000000983ff] usable
 BIOS-e820: [mem 0x0000000000098400-0x000000000009ffff] reserved
 BIOS-e820: [mem 0x00000000000d0000-0x00000000000fffff] reserved
 BIOS-e820: [mem 0x0000000000100000-0x00000000c7ebffff] usable
 BIOS-e820: [mem 0x00000000c7ec0000-0x00000000c7ed7fff] ACPI data
 BIOS-e820: [mem 0x00000000c7ed8000-0x00000000c7ed9fff] ACPI NVS
 BIOS-e820: [mem 0x00000000c7eda000-0x00000000c7ffffff] reserved
 BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
 BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
 BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved
 BIOS-e820: [mem 0x0000000100000000-0x000000e037ffffff] usable
 BIOS-e820: [mem 0x000000e038000000-0x000000fcffffffff] reserved
 BIOS-e820: [mem 0x0000010000000000-0x0000011ffeffffff] usable

and so direct mappings are created for huge memory hole between
0x000000e038000000 to 0x0000010000000000. Even though the kernel never
generates memory accesses in that region, since the page tables mark
them incorrectly as being WB, our (AMD) processor ends up causing a MCE
while doing some memory bookkeeping/optimizations around that area.

This patch iterates through e820 and only direct maps ranges that are
marked as E820_RAM, and keeps track of those pfn ranges. Depending on
the alignment of E820 ranges, this may possibly result in using smaller
size (i.e. 4K instead of 2M or 1G) page tables.

-v2: move changes from setup.c to mm/init.c, also use for_each_mem_pfn_range
	instead.  - Yinghai Lu
-v3: add calculate_all_table_space_size() to get correct needed page table
	size. - Yinghai Lu

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
---
 arch/x86/include/asm/page_types.h |    8 +--
 arch/x86/kernel/setup.c           |    8 ++-
 arch/x86/mm/init.c                |  119 +++++++++++++++++++++++++++++++++----
 arch/x86/mm/init_64.c             |    6 +-
 4 files changed, 116 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index 45aae6e..54c9787 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -51,13 +51,7 @@ static inline phys_addr_t get_max_mapped(void)
 	return (phys_addr_t)max_pfn_mapped << PAGE_SHIFT;
 }
 
-static inline bool pfn_range_is_mapped(unsigned long start_pfn,
-					unsigned long end_pfn)
-{
-	return end_pfn <= max_low_pfn_mapped ||
-	       (end_pfn > (1UL << (32 - PAGE_SHIFT)) &&
-		end_pfn <= max_pfn_mapped);
-}
+bool pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn);
 
 extern unsigned long init_memory_mapping(unsigned long start,
 					 unsigned long end);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d3da223..4989f80 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -115,9 +115,11 @@
 #include <asm/prom.h>
 
 /*
- * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
- * The direct mapping extends to max_pfn_mapped, so that we can directly access
- * apertures, ACPI and other tables without having to play with fixmaps.
+ * max_low_pfn_mapped: highest direct mapped pfn under 4GB
+ * max_pfn_mapped:     highest direct mapped pfn over 4GB
+ *
+ * The direct mapping only covers E820_RAM regions, so the ranges and gaps are
+ * represented by pfn_mapped
  */
 unsigned long max_low_pfn_mapped;
 unsigned long max_pfn_mapped;
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index d4b40d4..3237c9b 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -234,6 +234,38 @@ static unsigned long __init calculate_table_space_size(unsigned long begin,
 	return tables;
 }
 
+static unsigned long __init calculate_all_table_space_size(void)
+{
+	unsigned long start_pfn, end_pfn;
+	unsigned long tables;
+	int i;
+
+	/* the ISA range is always mapped regardless of memory holes */
+	tables = calculate_table_space_size(0, ISA_END_ADDRESS);
+
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
+		u64 start = start_pfn << PAGE_SHIFT;
+		u64 end = end_pfn << PAGE_SHIFT;
+
+		if (end <= ISA_END_ADDRESS)
+			continue;
+
+		if (start < ISA_END_ADDRESS)
+			start = ISA_END_ADDRESS;
+#ifdef CONFIG_X86_32
+		/* on 32 bit, we only map up to max_low_pfn */
+		if ((start >> PAGE_SHIFT) >= max_low_pfn)
+			continue;
+
+		if ((end >> PAGE_SHIFT) > max_low_pfn)
+			end = max_low_pfn << PAGE_SHIFT;
+#endif
+		tables += calculate_table_space_size(start, end);
+	}
+
+	return tables;
+}
+
 static void __init find_early_table_space(unsigned long start,
 					  unsigned long good_end,
 					  unsigned long tables)
@@ -249,6 +281,33 @@ static void __init find_early_table_space(unsigned long start,
 	pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
 }
 
+static struct range pfn_mapped[E820_X_MAX];
+static int nr_pfn_mapped;
+
+static void add_pfn_range_mapped(unsigned long start_pfn, unsigned long end_pfn)
+{
+	nr_pfn_mapped = add_range_with_merge(pfn_mapped, E820_X_MAX,
+					     nr_pfn_mapped, start_pfn, end_pfn);
+	nr_pfn_mapped = clean_sort_range(pfn_mapped, E820_X_MAX);
+
+	max_pfn_mapped = max(max_pfn_mapped, end_pfn);
+
+	if (end_pfn <= (1UL << (32 - PAGE_SHIFT)))
+		max_low_pfn_mapped = max(max_low_pfn_mapped, end_pfn);
+}
+
+bool pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn)
+{
+	int i;
+
+	for (i = 0; i < nr_pfn_mapped; i++)
+		if ((start_pfn >= pfn_mapped[i].start) &&
+		    (end_pfn <= pfn_mapped[i].end))
+			return true;
+
+	return false;
+}
+
 /*
  * Setup the direct mapping of the physical memory at PAGE_OFFSET.
  * This runs before bootmem is initialized and gets pages directly from
@@ -280,9 +339,55 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 
 	__flush_tlb_all();
 
+	add_pfn_range_mapped(start >> PAGE_SHIFT, ret >> PAGE_SHIFT);
+
 	return ret >> PAGE_SHIFT;
 }
 
+/*
+ * Iterate through E820 memory map and create direct mappings for only E820_RAM
+ * regions. We cannot simply create direct mappings for all pfns from
+ * [0 to max_low_pfn) and [4GB to max_pfn) because of possible memory holes in
+ * high addresses that cannot be marked as UC by fixed/variable range MTRRs.
+ * Depending on the alignment of E820 ranges, this may possibly result in using
+ * smaller size (i.e. 4K instead of 2M or 1G) page tables.
+ */
+static void __init init_all_memory_mapping(void)
+{
+	unsigned long start_pfn, end_pfn;
+	int i;
+
+	/* the ISA range is always mapped regardless of memory holes */
+	init_memory_mapping(0, ISA_END_ADDRESS);
+
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
+		u64 start = start_pfn << PAGE_SHIFT;
+		u64 end = end_pfn << PAGE_SHIFT;
+
+		if (end <= ISA_END_ADDRESS)
+			continue;
+
+		if (start < ISA_END_ADDRESS)
+			start = ISA_END_ADDRESS;
+#ifdef CONFIG_X86_32
+		/* on 32 bit, we only map up to max_low_pfn */
+		if ((start >> PAGE_SHIFT) >= max_low_pfn)
+			continue;
+
+		if ((end >> PAGE_SHIFT) > max_low_pfn)
+			end = max_low_pfn << PAGE_SHIFT;
+#endif
+		init_memory_mapping(start, end);
+	}
+
+#ifdef CONFIG_X86_64
+	if (max_pfn > max_low_pfn) {
+		/* can we preseve max_low_pfn ?*/
+		max_low_pfn = max_pfn;
+	}
+#endif
+}
+
 void __init init_mem_mapping(void)
 {
 	unsigned long tables, good_end, end;
@@ -303,23 +408,15 @@ void __init init_mem_mapping(void)
 	end = max_low_pfn << PAGE_SHIFT;
 	good_end = max_pfn_mapped << PAGE_SHIFT;
 #endif
-	tables = calculate_table_space_size(0, end);
+	tables = calculate_all_table_space_size();
 	find_early_table_space(0, good_end, tables);
 	printk(KERN_DEBUG "kernel direct mapping tables up to %#lx @ [mem %#010lx-%#010lx] prealloc\n",
 		end - 1, pgt_buf_start << PAGE_SHIFT,
 		(pgt_buf_top << PAGE_SHIFT) - 1);
 
-	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
-	max_pfn_mapped = max_low_pfn_mapped;
+	max_pfn_mapped = 0; /* will get exact value next */
+	init_all_memory_mapping();
 
-#ifdef CONFIG_X86_64
-	if (max_pfn > max_low_pfn) {
-		max_pfn_mapped = init_memory_mapping(1UL<<32,
-						     max_pfn<<PAGE_SHIFT);
-		/* can we preseve max_low_pfn ?*/
-		max_low_pfn = max_pfn;
-	}
-#endif
 	/*
 	 * Reserve the kernel pagetable pages we used (pgt_buf_start -
 	 * pgt_buf_end) and free the other ones (pgt_buf_end - pgt_buf_top)
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 2b6b4a3..ab558eb 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -657,13 +657,11 @@ int arch_add_memory(int nid, u64 start, u64 size)
 {
 	struct pglist_data *pgdat = NODE_DATA(nid);
 	struct zone *zone = pgdat->node_zones + ZONE_NORMAL;
-	unsigned long last_mapped_pfn, start_pfn = start >> PAGE_SHIFT;
+	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	int ret;
 
-	last_mapped_pfn = init_memory_mapping(start, start + size);
-	if (last_mapped_pfn > max_pfn_mapped)
-		max_pfn_mapped = last_mapped_pfn;
+	init_memory_mapping(start, start + size);
 
 	ret = __add_pages(nid, zone, start_pfn, nr_pages);
 	WARN_ON_ONCE(ret);
-- 
1.7.7

