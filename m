Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab2I3H7X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 03:59:23 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20390 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab2I3H5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 03:57:44 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 06/13] x86, mm: Separate out calculate_table_space_size()
Date: Sun, 30 Sep 2012 00:57:17 -0700
Message-Id: <1348991844-12285-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348991844-12285-1-git-send-email-yinghai@kernel.org>
References: <1348991844-12285-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should take physical address range that will need to be mapped.
find_early_table_space should take range that pgt buff should be in.

Separating page table size calculating and finding early page table will
reduce confusing.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
---
 arch/x86/mm/init.c |   39 ++++++++++++++++++++++++++++-----------
 1 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index d364f6a..dc05416 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -37,11 +37,10 @@ struct map_range {
 
 static int page_size_mask;
 
-static void __init find_early_table_space(unsigned long begin,
+static unsigned long __init calculate_table_space_size(unsigned long begin,
 					  unsigned long end)
 {
-	unsigned long puds, pmds, ptes, tables, start = 0, good_end = end;
-	phys_addr_t base;
+	unsigned long puds, pmds, ptes, tables;
 
 	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
 	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
@@ -76,9 +75,17 @@ static void __init find_early_table_space(unsigned long begin,
 #ifdef CONFIG_X86_32
 	/* for fixmap */
 	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
-	good_end = max_pfn_mapped << PAGE_SHIFT;
 #endif
 
+	return tables;
+}
+
+static void __init find_early_table_space(unsigned long start,
+					  unsigned long good_end,
+					  unsigned long tables)
+{
+	phys_addr_t base;
+
 	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
 	if (!base)
 		panic("Cannot find space for the kernel page tables");
@@ -86,10 +93,6 @@ static void __init find_early_table_space(unsigned long begin,
 	pgt_buf_start = base >> PAGE_SHIFT;
 	pgt_buf_end = pgt_buf_start;
 	pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
-
-	printk(KERN_DEBUG "kernel direct mapping tables up to %#lx @ [mem %#010lx-%#010lx]\n",
-		end - 1, pgt_buf_start << PAGE_SHIFT,
-		(pgt_buf_top << PAGE_SHIFT) - 1);
 }
 
 static void __init probe_page_size_mask(void)
@@ -282,6 +285,8 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 
 void __init init_mem_mapping(void)
 {
+	unsigned long tables, good_end, end;
+
 	probe_page_size_mask();
 
 	/*
@@ -292,10 +297,18 @@ void __init init_mem_mapping(void)
 	 * nodes are discovered.
 	 */
 #ifdef CONFIG_X86_64
-	find_early_table_space(0, max_pfn<<PAGE_SHIFT);
+	end = max_pfn << PAGE_SHIFT;
+	good_end = end;
 #else
-	find_early_table_space(0, max_low_pfn<<PAGE_SHIFT);
+	end = max_low_pfn << PAGE_SHIFT;
+	good_end = max_pfn_mapped << PAGE_SHIFT;
 #endif
+	tables = calculate_table_space_size(0, end);
+	find_early_table_space(0, good_end, tables);
+	printk(KERN_DEBUG "kernel direct mapping tables up to %#lx @ [mem %#010lx-%#010lx] prealloc\n",
+		end - 1, pgt_buf_start << PAGE_SHIFT,
+		(pgt_buf_top << PAGE_SHIFT) - 1);
+
 	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
 	max_pfn_mapped = max_low_pfn_mapped;
 
@@ -322,9 +335,13 @@ void __init init_mem_mapping(void)
 	 * RO all the pagetable pages, including the ones that are beyond
 	 * pgt_buf_end at that time.
 	 */
-	if (pgt_buf_end > pgt_buf_start)
+	if (pgt_buf_end > pgt_buf_start) {
+		printk(KERN_DEBUG "kernel direct mapping tables up to %#lx @ [mem %#010lx-%#010lx] final\n",
+			end - 1, pgt_buf_start << PAGE_SHIFT,
+			(pgt_buf_end << PAGE_SHIFT) - 1);
 		x86_init.mapping.pagetable_reserve(PFN_PHYS(pgt_buf_start),
 				PFN_PHYS(pgt_buf_end));
+	}
 
 	/* stop the wrong using */
 	pgt_buf_top = 0;
-- 
1.7.7

