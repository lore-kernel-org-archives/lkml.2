Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab2JRUvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:51:21 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42631 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449Ab2JRUvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:51:13 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 13/19] x86, mm: only call early_ioremap_page_table_range_init() once
Date: Thu, 18 Oct 2012 13:50:24 -0700
Message-Id: <1350593430-24470-17-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 32bit, We should not keep calling that during every init_memory_mapping.

Need to update page_table_range_init() to count the pages for kmap page table
at first, and use new added alloc_low_pages() to get pages in sequence.
That will conform requirement that page table need to be in low to high order.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init.c    |   13 +++++--------
 arch/x86/mm/init_32.c |   47 +++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 46 insertions(+), 14 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index de71c0d..4eece3c 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -334,14 +334,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
 						   mr[i].page_size_mask);
 
-#ifdef CONFIG_X86_32
-	early_ioremap_page_table_range_init();
-
-	load_cr3(swapper_pg_dir);
-#endif
-
-	__flush_tlb_all();
-
 	add_pfn_range_mapped(start >> PAGE_SHIFT, ret >> PAGE_SHIFT);
 
 	return ret >> PAGE_SHIFT;
@@ -435,7 +427,12 @@ void __init init_mem_mapping(void)
 		/* can we preseve max_low_pfn ?*/
 		max_low_pfn = max_pfn;
 	}
+#else
+	early_ioremap_page_table_range_init();
+	load_cr3(swapper_pg_dir);
+	__flush_tlb_all();
 #endif
+
 	early_memtest(0, max_pfn_mapped << PAGE_SHIFT);
 }
 
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index a7f2df1..ef7f0dc 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -135,8 +135,39 @@ pte_t * __init populate_extra_pte(unsigned long vaddr)
 	return one_page_table_init(pmd) + pte_idx;
 }
 
+static unsigned long __init
+page_table_range_init_count(unsigned long start, unsigned long end)
+{
+	unsigned long count = 0;
+#ifdef CONFIG_HIGHMEM
+	int pmd_idx_kmap_begin = fix_to_virt(FIX_KMAP_END) >> PMD_SHIFT;
+	int pmd_idx_kmap_end = fix_to_virt(FIX_KMAP_BEGIN) >> PMD_SHIFT;
+	int pgd_idx, pmd_idx;
+	unsigned long vaddr;
+
+	if (pmd_idx_kmap_begin == pmd_idx_kmap_end)
+		return count;
+
+	vaddr = start;
+	pgd_idx = pgd_index(vaddr);
+
+	for ( ; (pgd_idx < PTRS_PER_PGD) && (vaddr != end); pgd_idx++) {
+		for (; (pmd_idx < PTRS_PER_PMD) && (vaddr != end);
+							pmd_idx++) {
+			if ((vaddr >> PMD_SHIFT) >= pmd_idx_kmap_begin &&
+			    (vaddr >> PMD_SHIFT) <= pmd_idx_kmap_end)
+				count++;
+			vaddr += PMD_SIZE;
+		}
+		pmd_idx = 0;
+	}
+#endif
+	return count;
+}
+
 static pte_t *__init page_table_kmap_check(pte_t *pte, pmd_t *pmd,
-					   unsigned long vaddr, pte_t *lastpte)
+					   unsigned long vaddr, pte_t *lastpte,
+					   void **adr)
 {
 #ifdef CONFIG_HIGHMEM
 	/*
@@ -150,16 +181,15 @@ static pte_t *__init page_table_kmap_check(pte_t *pte, pmd_t *pmd,
 
 	if (pmd_idx_kmap_begin != pmd_idx_kmap_end
 	    && (vaddr >> PMD_SHIFT) >= pmd_idx_kmap_begin
-	    && (vaddr >> PMD_SHIFT) <= pmd_idx_kmap_end
-	    && ((__pa(pte) >> PAGE_SHIFT) < pgt_buf_start
-		|| (__pa(pte) >> PAGE_SHIFT) >= pgt_buf_end)) {
+	    && (vaddr >> PMD_SHIFT) <= pmd_idx_kmap_end) {
 		pte_t *newpte;
 		int i;
 
 		BUG_ON(after_bootmem);
-		newpte = alloc_low_page();
+		newpte = *adr;
 		for (i = 0; i < PTRS_PER_PTE; i++)
 			set_pte(newpte + i, pte[i]);
+		*adr = (void *)(((unsigned long)(*adr)) + PAGE_SIZE);
 
 		paravirt_alloc_pte(&init_mm, __pa(newpte) >> PAGE_SHIFT);
 		set_pmd(pmd, __pmd(__pa(newpte)|_PAGE_TABLE));
@@ -193,6 +223,11 @@ page_table_range_init(unsigned long start, unsigned long end, pgd_t *pgd_base)
 	pgd_t *pgd;
 	pmd_t *pmd;
 	pte_t *pte = NULL;
+	unsigned long count = page_table_range_init_count(start, end);
+	void *adr = NULL;
+
+	if (count)
+		adr = alloc_low_pages(count);
 
 	vaddr = start;
 	pgd_idx = pgd_index(vaddr);
@@ -205,7 +240,7 @@ page_table_range_init(unsigned long start, unsigned long end, pgd_t *pgd_base)
 		for (; (pmd_idx < PTRS_PER_PMD) && (vaddr != end);
 							pmd++, pmd_idx++) {
 			pte = page_table_kmap_check(one_page_table_init(pmd),
-			                            pmd, vaddr, pte);
+						    pmd, vaddr, pte, &adr);
 
 			vaddr += PMD_SIZE;
 		}
-- 
1.7.7

