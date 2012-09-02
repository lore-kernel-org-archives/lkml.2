Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab2IBHs7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 03:48:59 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:40992 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960Ab2IBHri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 03:47:38 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 12/13] x86, mm: Use func pointer to table size calculation and mapping.
Date: Sun,  2 Sep 2012 00:46:58 -0700
Message-Id: <1346572019-15806-13-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346572019-15806-1-git-send-email-yinghai@kernel.org>
References: <1346572019-15806-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They all need to go over ram range in same sequence. So add shared function
to reduce duplicated code.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init.c |   64 ++++++++++++++++++---------------------------------
 1 files changed, 23 insertions(+), 41 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 7830db9..343d925 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -243,14 +243,15 @@ static unsigned long __init calculate_table_space_size(unsigned long start,
 	return tables;
 }
 
-static unsigned long __init calculate_all_table_space_size(void)
+static void __init with_all_ram_ranges(
+			void (*work_fn)(unsigned long, unsigned long, void *),
+			void *data)
 {
 	unsigned long start_pfn, end_pfn;
-	unsigned long tables;
 	int i;
 
 	/* the ISA range is always mapped regardless of memory holes */
-	tables = calculate_table_space_size(0, ISA_END_ADDRESS);
+	work_fn(0, ISA_END_ADDRESS, data);
 
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
 		u64 start = start_pfn << PAGE_SHIFT;
@@ -269,10 +270,15 @@ static unsigned long __init calculate_all_table_space_size(void)
 		if ((end >> PAGE_SHIFT) > max_low_pfn)
 			end = max_low_pfn << PAGE_SHIFT;
 #endif
-		tables += calculate_table_space_size(start, end);
+		work_fn(start, end, data);
 	}
+}
 
-	return tables;
+static void __init size_work_fn(unsigned long start, unsigned long end, void *data)
+{
+	unsigned long *size = data;
+
+	*size += calculate_table_space_size(start, end);
 }
 
 static void __init find_early_table_space(unsigned long start,
@@ -361,45 +367,15 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
  * Depending on the alignment of E820 ranges, this may possibly result in using
  * smaller size (i.e. 4K instead of 2M or 1G) page tables.
  */
-static void __init init_all_memory_mapping(void)
+static void __init mapping_work_fn(unsigned long start, unsigned long end,
+					 void *data)
 {
-	unsigned long start_pfn, end_pfn;
-	int i;
-
-	/* the ISA range is always mapped regardless of memory holes */
-	init_memory_mapping(0, ISA_END_ADDRESS);
-
-	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
-		u64 start = start_pfn << PAGE_SHIFT;
-		u64 end = end_pfn << PAGE_SHIFT;
-
-		if (end <= ISA_END_ADDRESS)
-			continue;
-
-		if (start < ISA_END_ADDRESS)
-			start = ISA_END_ADDRESS;
-#ifdef CONFIG_X86_32
-		/* on 32 bit, we only map up to max_low_pfn */
-		if ((start >> PAGE_SHIFT) >= max_low_pfn)
-			continue;
-
-		if ((end >> PAGE_SHIFT) > max_low_pfn)
-			end = max_low_pfn << PAGE_SHIFT;
-#endif
-		init_memory_mapping(start, end);
-	}
-
-#ifdef CONFIG_X86_64
-	if (max_pfn > max_low_pfn) {
-		/* can we preseve max_low_pfn ?*/
-		max_low_pfn = max_pfn;
-	}
-#endif
+	init_memory_mapping(start, end);
 }
 
 void __init init_mem_mapping(void)
 {
-	unsigned long tables, good_end, end;
+	unsigned long tables = 0, good_end, end;
 
 	probe_page_size_mask();
 
@@ -417,15 +393,21 @@ void __init init_mem_mapping(void)
 	end = max_low_pfn << PAGE_SHIFT;
 	good_end = max_pfn_mapped << PAGE_SHIFT;
 #endif
-	tables = calculate_all_table_space_size();
+	with_all_ram_ranges(size_work_fn, &tables);
 	find_early_table_space(0, good_end, tables);
 	printk(KERN_DEBUG "kernel direct mapping tables up to %#lx @ [mem %#010lx-%#010lx] prealloc\n",
 		end - 1, pgt_buf_start << PAGE_SHIFT,
 		(pgt_buf_top << PAGE_SHIFT) - 1);
 
 	max_pfn_mapped = 0; /* will get exact value next */
-	init_all_memory_mapping();
+	with_all_ram_ranges(mapping_work_fn, NULL);
 
+#ifdef CONFIG_X86_64
+	if (max_pfn > max_low_pfn) {
+		/* can we preseve max_low_pfn ?*/
+		max_low_pfn = max_pfn;
+	}
+#endif
 	/*
 	 * Reserve the kernel pagetable pages we used (pgt_buf_start -
 	 * pgt_buf_end) and free the other ones (pgt_buf_end - pgt_buf_top)
-- 
1.7.7

