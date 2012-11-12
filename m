Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab2KLVhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:37:54 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24494 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab2KLVT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:19:27 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 03/46] x86, mm: Move down find_early_table_space()
Date: Mon, 12 Nov 2012 13:17:59 -0800
Message-Id: <1352755122-25660-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1352755122-25660-1-git-send-email-yinghai@kernel.org>
References: <20121112193044.GA11615@phenom.dumpdata.com>
 <1352755122-25660-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will need to call split_mem_range().
Move it down after that to avoid extra declaration.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init.c |  117 ++++++++++++++++++++++++++--------------------------
 1 files changed, 59 insertions(+), 58 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 6d8e102..4a372d7 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -36,64 +36,6 @@ struct map_range {
 };
 
 static int page_size_mask;
-/*
- * First calculate space needed for kernel direct mapping page tables to cover
- * mr[0].start to mr[nr_range - 1].end, while accounting for possible 2M and 1GB
- * pages. Then find enough contiguous space for those page tables.
- */
-static void __init find_early_table_space(struct map_range *mr, int nr_range)
-{
-	int i;
-	unsigned long puds = 0, pmds = 0, ptes = 0, tables;
-	unsigned long start = 0, good_end;
-	phys_addr_t base;
-
-	for (i = 0; i < nr_range; i++) {
-		unsigned long range, extra;
-
-		range = mr[i].end - mr[i].start;
-		puds += (range + PUD_SIZE - 1) >> PUD_SHIFT;
-
-		if (mr[i].page_size_mask & (1 << PG_LEVEL_1G)) {
-			extra = range - ((range >> PUD_SHIFT) << PUD_SHIFT);
-			pmds += (extra + PMD_SIZE - 1) >> PMD_SHIFT;
-		} else {
-			pmds += (range + PMD_SIZE - 1) >> PMD_SHIFT;
-		}
-
-		if (mr[i].page_size_mask & (1 << PG_LEVEL_2M)) {
-			extra = range - ((range >> PMD_SHIFT) << PMD_SHIFT);
-#ifdef CONFIG_X86_32
-			extra += PMD_SIZE;
-#endif
-			ptes += (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
-		} else {
-			ptes += (range + PAGE_SIZE - 1) >> PAGE_SHIFT;
-		}
-	}
-
-	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
-	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
-	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
-
-#ifdef CONFIG_X86_32
-	/* for fixmap */
-	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
-#endif
-	good_end = max_pfn_mapped << PAGE_SHIFT;
-
-	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
-	if (!base)
-		panic("Cannot find space for the kernel page tables");
-
-	pgt_buf_start = base >> PAGE_SHIFT;
-	pgt_buf_end = pgt_buf_start;
-	pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
-
-	printk(KERN_DEBUG "kernel direct mapping tables up to %#lx @ [mem %#010lx-%#010lx]\n",
-		mr[nr_range - 1].end - 1, pgt_buf_start << PAGE_SHIFT,
-		(pgt_buf_top << PAGE_SHIFT) - 1);
-}
 
 void probe_page_size_mask(void)
 {
@@ -250,6 +192,65 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 }
 
 /*
+ * First calculate space needed for kernel direct mapping page tables to cover
+ * mr[0].start to mr[nr_range - 1].end, while accounting for possible 2M and 1GB
+ * pages. Then find enough contiguous space for those page tables.
+ */
+static void __init find_early_table_space(struct map_range *mr, int nr_range)
+{
+	int i;
+	unsigned long puds = 0, pmds = 0, ptes = 0, tables;
+	unsigned long start = 0, good_end;
+	phys_addr_t base;
+
+	for (i = 0; i < nr_range; i++) {
+		unsigned long range, extra;
+
+		range = mr[i].end - mr[i].start;
+		puds += (range + PUD_SIZE - 1) >> PUD_SHIFT;
+
+		if (mr[i].page_size_mask & (1 << PG_LEVEL_1G)) {
+			extra = range - ((range >> PUD_SHIFT) << PUD_SHIFT);
+			pmds += (extra + PMD_SIZE - 1) >> PMD_SHIFT;
+		} else {
+			pmds += (range + PMD_SIZE - 1) >> PMD_SHIFT;
+		}
+
+		if (mr[i].page_size_mask & (1 << PG_LEVEL_2M)) {
+			extra = range - ((range >> PMD_SHIFT) << PMD_SHIFT);
+#ifdef CONFIG_X86_32
+			extra += PMD_SIZE;
+#endif
+			ptes += (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		} else {
+			ptes += (range + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		}
+	}
+
+	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
+	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
+	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
+
+#ifdef CONFIG_X86_32
+	/* for fixmap */
+	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
+#endif
+	good_end = max_pfn_mapped << PAGE_SHIFT;
+
+	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
+	if (!base)
+		panic("Cannot find space for the kernel page tables");
+
+	pgt_buf_start = base >> PAGE_SHIFT;
+	pgt_buf_end = pgt_buf_start;
+	pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
+
+	printk(KERN_DEBUG "kernel direct mapping tables up to %#lx @ [mem %#010lx-%#010lx]\n",
+		mr[nr_range - 1].end - 1, pgt_buf_start << PAGE_SHIFT,
+		(pgt_buf_top << PAGE_SHIFT) - 1);
+}
+
+/*
  * Setup the direct mapping of the physical memory at PAGE_OFFSET.
  * This runs before bootmem is initialized and gets pages directly from
  * the physical memory. To access them they are temporarily mapped.
-- 
1.7.7

