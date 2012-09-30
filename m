Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab2I3H7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 03:59:22 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:33001 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab2I3H5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 03:57:45 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 01/13] x86, mm: Add global page_size_mask and probe one time only
Date: Sun, 30 Sep 2012 00:57:12 -0700
Message-Id: <1348991844-12285-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348991844-12285-1-git-send-email-yinghai@kernel.org>
References: <1348991844-12285-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we pass around use_gbpages and use_pse for calculating page table size,
Later we will need to calculate page table size for every ram range, that
mean those calculation will be done several times.

Those info are the same for all ram range and could be stored in page_size_mask
and only probe them one time.

Move htat probing code from in init_memory_mapping into separated function
probe_page_size_mask, and call it before all init_memory_mapping.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
---
 arch/x86/include/asm/pgtable.h |    1 +
 arch/x86/kernel/setup.c        |    1 +
 arch/x86/mm/init.c             |   66 +++++++++++++++++++---------------------
 3 files changed, 33 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 402704f..c6f5779 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -598,6 +598,7 @@ static inline int pgd_none(pgd_t pgd)
 #ifndef __ASSEMBLY__
 
 extern int direct_gbpages;
+void probe_page_size_mask(void);
 
 /* local pte updates need not use xchg for locking */
 static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 4f16547..20581d7 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -912,6 +912,7 @@ void __init setup_arch(char **cmdline_p)
 	setup_real_mode();
 
 	init_gbpages();
+	probe_page_size_mask();
 
 	/* max_pfn_mapped is updated here */
 	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index ab1f6a9..7903d54 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -35,8 +35,10 @@ struct map_range {
 	unsigned page_size_mask;
 };
 
-static void __init find_early_table_space(struct map_range *mr, unsigned long end,
-					  int use_pse, int use_gbpages)
+static int page_size_mask;
+
+static void __init find_early_table_space(struct map_range *mr,
+					  unsigned long end)
 {
 	unsigned long puds, pmds, ptes, tables, start = 0, good_end = end;
 	phys_addr_t base;
@@ -44,7 +46,7 @@ static void __init find_early_table_space(struct map_range *mr, unsigned long en
 	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
 	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
 
-	if (use_gbpages) {
+	if (page_size_mask & (1 << PG_LEVEL_1G)) {
 		unsigned long extra;
 
 		extra = end - ((end>>PUD_SHIFT) << PUD_SHIFT);
@@ -54,7 +56,7 @@ static void __init find_early_table_space(struct map_range *mr, unsigned long en
 
 	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
 
-	if (use_pse) {
+	if (page_size_mask & (1 << PG_LEVEL_2M)) {
 		unsigned long extra;
 
 		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
@@ -90,6 +92,30 @@ static void __init find_early_table_space(struct map_range *mr, unsigned long en
 		(pgt_buf_top << PAGE_SHIFT) - 1);
 }
 
+void probe_page_size_mask(void)
+{
+#if !defined(CONFIG_DEBUG_PAGEALLOC) && !defined(CONFIG_KMEMCHECK)
+	/*
+	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
+	 * This will simplify cpa(), which otherwise needs to support splitting
+	 * large pages into small in interrupt context, etc.
+	 */
+	if (direct_gbpages)
+		page_size_mask |= 1 << PG_LEVEL_1G;
+	if (cpu_has_pse)
+		page_size_mask |= 1 << PG_LEVEL_2M;
+#endif
+
+	/* Enable PSE if available */
+	if (cpu_has_pse)
+		set_in_cr4(X86_CR4_PSE);
+
+	/* Enable PGE if available */
+	if (cpu_has_pge) {
+		set_in_cr4(X86_CR4_PGE);
+		__supported_pte_mask |= _PAGE_GLOBAL;
+	}
+}
 void __init native_pagetable_reserve(u64 start, u64 end)
 {
 	memblock_reserve(start, end - start);
@@ -125,45 +151,15 @@ static int __meminit save_mr(struct map_range *mr, int nr_range,
 unsigned long __init_refok init_memory_mapping(unsigned long start,
 					       unsigned long end)
 {
-	unsigned long page_size_mask = 0;
 	unsigned long start_pfn, end_pfn;
 	unsigned long ret = 0;
 	unsigned long pos;
-
 	struct map_range mr[NR_RANGE_MR];
 	int nr_range, i;
-	int use_pse, use_gbpages;
 
 	printk(KERN_INFO "init_memory_mapping: [mem %#010lx-%#010lx]\n",
 	       start, end - 1);
 
-#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
-	/*
-	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
-	 * This will simplify cpa(), which otherwise needs to support splitting
-	 * large pages into small in interrupt context, etc.
-	 */
-	use_pse = use_gbpages = 0;
-#else
-	use_pse = cpu_has_pse;
-	use_gbpages = direct_gbpages;
-#endif
-
-	/* Enable PSE if available */
-	if (cpu_has_pse)
-		set_in_cr4(X86_CR4_PSE);
-
-	/* Enable PGE if available */
-	if (cpu_has_pge) {
-		set_in_cr4(X86_CR4_PGE);
-		__supported_pte_mask |= _PAGE_GLOBAL;
-	}
-
-	if (use_gbpages)
-		page_size_mask |= 1 << PG_LEVEL_1G;
-	if (use_pse)
-		page_size_mask |= 1 << PG_LEVEL_2M;
-
 	memset(mr, 0, sizeof(mr));
 	nr_range = 0;
 
@@ -267,7 +263,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	 * nodes are discovered.
 	 */
 	if (!after_bootmem)
-		find_early_table_space(&mr[0], end, use_pse, use_gbpages);
+		find_early_table_space(&mr[0], end);
 
 	for (i = 0; i < nr_range; i++)
 		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
-- 
1.7.7

