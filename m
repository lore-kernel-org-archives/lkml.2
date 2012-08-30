Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab2H3XHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 19:07:25 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:33887 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab2H3XHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 19:07:22 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 5/8] x86, mm: Find early page table only one time
Date: Thu, 30 Aug 2012 16:06:12 -0700
Message-Id: <1346367975-6446-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346367975-6446-1-git-send-email-yinghai@kernel.org>
References: <2e8c14cd-b82a-49e6-8d5e-85dbe86da6ca@email.android.com>
 <1346367975-6446-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should not do that in every calling of init_memory_mapping.
Actually in early time, only need do once.

Also move down early_memtest.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init.c |   71 +++++++++++++++++++++++++++-------------------------
 1 files changed, 37 insertions(+), 34 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index cca9b7d..c3e4341 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -37,7 +37,7 @@ struct map_range {
 
 static int page_size_mask;
 
-static void __init find_early_table_space(struct map_range *mr,
+static void __init find_early_table_space(unsigned long begin,
 					  unsigned long end)
 {
 	unsigned long puds, pmds, ptes, tables, start = 0, good_end = end;
@@ -64,8 +64,8 @@ static void __init find_early_table_space(struct map_range *mr,
 		extra += PMD_SIZE;
 #endif
 		/* The first 2/4M doesn't use large pages. */
-		if (mr->start < PMD_SIZE)
-			extra += mr->end - mr->start;
+		if (begin < PMD_SIZE)
+			extra += (PMD_SIZE - start) >> PAGE_SHIFT;
 
 		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	} else
@@ -265,15 +265,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	nr_range = 0;
 	nr_range = split_mem_range(mr, nr_range, start, end);
 
-	/*
-	 * Find space for the kernel direct mapping tables.
-	 *
-	 * Later we should allocate these tables in the local node of the
-	 * memory mapped. Unfortunately this is done currently before the
-	 * nodes are discovered.
-	 */
-	if (!after_bootmem)
-		find_early_table_space(&mr[0], end);
 
 	for (i = 0; i < nr_range; i++)
 		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
@@ -287,6 +278,36 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 
 	__flush_tlb_all();
 
+	return ret >> PAGE_SHIFT;
+}
+
+void __init init_mem_mapping(void)
+{
+	probe_page_size_mask();
+
+	/*
+	 * Find space for the kernel direct mapping tables.
+	 *
+	 * Later we should allocate these tables in the local node of the
+	 * memory mapped. Unfortunately this is done currently before the
+	 * nodes are discovered.
+	 */
+#ifdef CONFIG_X86_64
+	find_early_table_space(0, max_pfn<<PAGE_SHIFT);
+#else
+	find_early_table_space(0, max_low_pfn<<PAGE_SHIFT);
+#endif
+	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
+	max_pfn_mapped = max_low_pfn_mapped;
+
+#ifdef CONFIG_X86_64
+	if (max_pfn > max_low_pfn) {
+		max_pfn_mapped = init_memory_mapping(1UL<<32,
+						     max_pfn<<PAGE_SHIFT);
+		/* can we preseve max_low_pfn ?*/
+		max_low_pfn = max_pfn;
+	}
+#endif
 	/*
 	 * Reserve the kernel pagetable pages we used (pgt_buf_start -
 	 * pgt_buf_end) and free the other ones (pgt_buf_end - pgt_buf_top)
@@ -302,32 +323,14 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	 * RO all the pagetable pages, including the ones that are beyond
 	 * pgt_buf_end at that time.
 	 */
-	if (!after_bootmem && pgt_buf_end > pgt_buf_start)
+	if (pgt_buf_end > pgt_buf_start)
 		x86_init.mapping.pagetable_reserve(PFN_PHYS(pgt_buf_start),
 				PFN_PHYS(pgt_buf_end));
 
-	if (!after_bootmem)
-		early_memtest(start, end);
-
-	return ret >> PAGE_SHIFT;
-}
-
-void __init init_mem_mapping(void)
-{
-	probe_page_size_mask();
-
-	/* max_pfn_mapped is updated here */
-	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
-	max_pfn_mapped = max_low_pfn_mapped;
+	/* stop the wrong using */
+	pgt_buf_top = 0;
 
-#ifdef CONFIG_X86_64
-	if (max_pfn > max_low_pfn) {
-		max_pfn_mapped = init_memory_mapping(1UL<<32,
-						     max_pfn<<PAGE_SHIFT);
-		/* can we preseve max_low_pfn ?*/
-		max_low_pfn = max_pfn;
-	}
-#endif
+	early_memtest(0, max_pfn << PAGE_SHIFT);
 }
 
 /*
-- 
1.7.7

