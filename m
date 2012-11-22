Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab2KVUvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:51:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964897Ab2KVS6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:37 -0500
Date: Wed, 21 Nov 2012 18:07:49 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-719272c45b821d38608fc333700bde1a89c56c59@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-30-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-30-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm:
  only call early_ioremap_page_table_range_init() once
Git-Commit-ID: 719272c45b821d38608fc333700bde1a89c56c59
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 18:07:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  719272c45b821d38608fc333700bde1a89c56c59
Gitweb:     http://git.kernel.org/tip/719272c45b821d38608fc333700bde1a89c56c59
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:39:06 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:29 -0800

x86, mm: only call early_ioremap_page_table_range_init() once

On 32bit, before patcheset that only set page table for ram, we only
call that one time.

Now, we are calling that during every init_memory_mapping if we have holes
under max_low_pfn.

We should only call it one time after all ranges under max_low_page get
mapped just like we did before.

Also that could avoid the risk to run out of pgt_buf in BRK.

Need to update page_table_range_init() to count the pages for kmap page table
at first, and use new added alloc_low_pages() to get pages in sequence.
That will conform to the requirement that pages need to be in low to high order.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-30-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init.c    | 13 +++++--------
 arch/x86/mm/init_32.c | 47 +++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 46 insertions(+), 14 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index cb4f8ba..bed4888 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -343,14 +343,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
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
@@ -447,7 +439,12 @@ void __init init_mem_mapping(void)
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
index a7f2df1..0ae1ba8 100644
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
+		return 0;
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
