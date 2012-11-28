Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817Ab2K1V6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:58:03 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:44929 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210Ab2K1Vso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:48:44 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v9 07/46] x86, mm: Find early page table buffer together
Date: Wed, 28 Nov 2012 13:47:18 -0800
Message-Id: <1354139277-17376-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
References: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should not do that in every calling of init_memory_mapping.

At the same time need to move down early_memtest, and could remove the
after_bootmem checking.

-v2: fix one early_memtest with 32bit by passing max_pfn_mapped instead.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/mm/init.c |   66 ++++++++++++++++++++++++++-------------------------
 1 files changed, 34 insertions(+), 32 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 51f919f..c618e4f 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -274,16 +274,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	memset(mr, 0, sizeof(mr));
 	nr_range = split_mem_range(mr, 0, start, end);
 
-	/*
-	 * Find space for the kernel direct mapping tables.
-	 *
-	 * Later we should allocate these tables in the local node of the
-	 * memory mapped. Unfortunately this is done currently before the
-	 * nodes are discovered.
-	 */
-	if (!after_bootmem)
-		find_early_table_space(start, end);
-
 	for (i = 0; i < nr_range; i++)
 		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
 						   mr[i].page_size_mask);
@@ -296,6 +286,36 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 
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
@@ -311,32 +331,14 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	 * RO all the pagetable pages, including the ones that are beyond
 	 * pgt_buf_end at that time.
 	 */
-	if (!after_bootmem && pgt_buf_end > pgt_buf_start)
+	if (pgt_buf_end > pgt_buf_start)
 		x86_init.mapping.pagetable_reserve(PFN_PHYS(pgt_buf_start),
 				PFN_PHYS(pgt_buf_end));
 
-	if (!after_bootmem)
-		early_memtest(start, end);
+	/* stop early pgtable allocating after we conclude it */
+	pgt_buf_top = 0;
 
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
-
-#ifdef CONFIG_X86_64
-	if (max_pfn > max_low_pfn) {
-		max_pfn_mapped = init_memory_mapping(1UL<<32,
-						     max_pfn<<PAGE_SHIFT);
-		/* can we preseve max_low_pfn ?*/
-		max_low_pfn = max_pfn;
-	}
-#endif
+	early_memtest(0, max_pfn_mapped << PAGE_SHIFT);
 }
 
 /*
-- 
1.7.7

