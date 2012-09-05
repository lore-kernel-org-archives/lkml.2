Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab2IEFtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 01:49:49 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17232 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757375Ab2IEFrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 01:47:12 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 07/14] x86, mm: Move down two calculate_table_space_size down.
Date: Tue,  4 Sep 2012 22:46:24 -0700
Message-Id: <1346823991-22911-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346823991-22911-1-git-send-email-yinghai@kernel.org>
References: <1346823991-22911-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So later could make it call split_mem_range...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
---
 arch/x86/mm/init.c |  116 ++++++++++++++++++++++++++--------------------------
 1 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index fcb44c5..a475d7f 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -37,64 +37,6 @@ struct map_range {
 
 static int page_size_mask;
 
-static unsigned long __init calculate_table_space_size(unsigned long begin,
-					  unsigned long end)
-{
-	unsigned long puds, pmds, ptes, tables;
-
-	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
-	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
-
-	if (page_size_mask & (1 << PG_LEVEL_1G)) {
-		unsigned long extra;
-
-		extra = end - ((end>>PUD_SHIFT) << PUD_SHIFT);
-		pmds = (extra + PMD_SIZE - 1) >> PMD_SHIFT;
-	} else
-		pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
-
-	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
-
-	if (page_size_mask & (1 << PG_LEVEL_2M)) {
-		unsigned long extra;
-
-		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
-#ifdef CONFIG_X86_32
-		extra += PMD_SIZE;
-#endif
-		/* The first 2/4M doesn't use large pages. */
-		if (begin < PMD_SIZE)
-			extra += (PMD_SIZE - begin) >> PAGE_SHIFT;
-
-		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	} else
-		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
-
-	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
-
-#ifdef CONFIG_X86_32
-	/* for fixmap */
-	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
-#endif
-
-	return tables;
-}
-
-static void __init find_early_table_space(unsigned long start,
-					  unsigned long good_end,
-					  unsigned long tables)
-{
-	phys_addr_t base;
-
-	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
-	if (!base)
-		panic("Cannot find space for the kernel page tables");
-
-	pgt_buf_start = base >> PAGE_SHIFT;
-	pgt_buf_end = pgt_buf_start;
-	pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
-}
-
 static void __init probe_page_size_mask(void)
 {
 #if !defined(CONFIG_DEBUG_PAGEALLOC) && !defined(CONFIG_KMEMCHECK)
@@ -249,6 +191,64 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 	return nr_range;
 }
 
+static unsigned long __init calculate_table_space_size(unsigned long begin,
+					  unsigned long end)
+{
+	unsigned long puds, pmds, ptes, tables;
+
+	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
+	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
+
+	if (page_size_mask & (1 << PG_LEVEL_1G)) {
+		unsigned long extra;
+
+		extra = end - ((end>>PUD_SHIFT) << PUD_SHIFT);
+		pmds = (extra + PMD_SIZE - 1) >> PMD_SHIFT;
+	} else
+		pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
+
+	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
+
+	if (page_size_mask & (1 << PG_LEVEL_2M)) {
+		unsigned long extra;
+
+		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
+#ifdef CONFIG_X86_32
+		extra += PMD_SIZE;
+#endif
+		/* The first 2/4M doesn't use large pages. */
+		if (begin < PMD_SIZE)
+			extra += (PMD_SIZE - begin) >> PAGE_SHIFT;
+
+		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	} else
+		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
+
+	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
+
+#ifdef CONFIG_X86_32
+	/* for fixmap */
+	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
+#endif
+
+	return tables;
+}
+
+static void __init find_early_table_space(unsigned long start,
+					  unsigned long good_end,
+					  unsigned long tables)
+{
+	phys_addr_t base;
+
+	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
+	if (!base)
+		panic("Cannot find space for the kernel page tables");
+
+	pgt_buf_start = base >> PAGE_SHIFT;
+	pgt_buf_end = pgt_buf_start;
+	pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
+}
+
 /*
  * Setup the direct mapping of the physical memory at PAGE_OFFSET.
  * This runs before bootmem is initialized and gets pages directly from
-- 
1.7.7

