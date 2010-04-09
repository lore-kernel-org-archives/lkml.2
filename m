Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab0DIBAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 21:00:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54144
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751264Ab0DIBAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 21:00:02 -0400
Date: Thu, 08 Apr 2010 18:00:05 -0700 (PDT)
Message-Id: <20100408.180005.76674367.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: aarcange@redhat.com, avi@redhat.com, tglx@linutronix.de, riel@redhat.com,
       mingo@elte.hu, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       benh@kernel.crashing.org, hugh.dickins@tiscali.co.uk, mel@csn.ul.ie,
       npiggin@suse.de
Subject: [PATCH 1/4] sparc64: Kill page table quicklists.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


They are pointless and make it harder to use RCU page
table freeing and share code with other architectures.

BTW, this is the second time this has happened, see
commit 3c936465249f863f322154ff1aaa628b84ee5750
("[SPARC64]: Kill pgtable quicklists and use SLAB.")

:-)

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/Kconfig                  |    4 ----
 arch/sparc/include/asm/pgalloc_64.h |   32 +++++++++++++++-----------------
 arch/sparc/mm/tsb.c                 |   11 +++++++++++
 3 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 6db5136..2ca63c9 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -82,10 +82,6 @@ config IOMMU_HELPER
 	bool
 	default y if SPARC64
 
-config QUICKLIST
-	bool
-	default y if SPARC64
-
 config STACKTRACE_SUPPORT
 	bool
 	default y if SPARC64
diff --git a/arch/sparc/include/asm/pgalloc_64.h b/arch/sparc/include/asm/pgalloc_64.h
index 4e5e087..cb4867d 100644
--- a/arch/sparc/include/asm/pgalloc_64.h
+++ b/arch/sparc/include/asm/pgalloc_64.h
@@ -5,7 +5,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
-#include <linux/quicklist.h>
 
 #include <asm/spitfire.h>
 #include <asm/cpudata.h>
@@ -14,69 +13,68 @@
 
 /* Page table allocation/freeing. */
 
+extern struct kmem_cache *pgtable_cache;
+
 static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	return quicklist_alloc(0, GFP_KERNEL, NULL);
+	return kmem_cache_alloc(pgtable_cache, GFP_KERNEL);
 }
 
 static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
-	quicklist_free(0, NULL, pgd);
+	kmem_cache_free(pgtable_cache, pgd);
 }
 
 #define pud_populate(MM, PUD, PMD)	pud_set(PUD, PMD)
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return quicklist_alloc(0, GFP_KERNEL, NULL);
+	return kmem_cache_alloc(pgtable_cache,
+				GFP_KERNEL|__GFP_REPEAT);
 }
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 {
-	quicklist_free(0, NULL, pmd);
+	kmem_cache_free(pgtable_cache, pmd);
 }
 
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 					  unsigned long address)
 {
-	return quicklist_alloc(0, GFP_KERNEL, NULL);
+	return (pte_t *)__get_free_page(GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO);
 }
 
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm,
 					unsigned long address)
 {
 	struct page *page;
-	void *pg;
+	pte_t *pte;
 
-	pg = quicklist_alloc(0, GFP_KERNEL, NULL);
-	if (!pg)
+	pte = pte_alloc_one_kernel(mm, address);
+	if (!pte)
 		return NULL;
-	page = virt_to_page(pg);
+	page = virt_to_page(pte);
 	pgtable_page_ctor(page);
 	return page;
 }
 
 static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
 {
-	quicklist_free(0, NULL, pte);
+	free_page((unsigned long)pte);
 }
 
 static inline void pte_free(struct mm_struct *mm, pgtable_t ptepage)
 {
 	pgtable_page_dtor(ptepage);
-	quicklist_free_page(0, NULL, ptepage);
+	__free_page(ptepage);
 }
 
-
 #define pmd_populate_kernel(MM, PMD, PTE)	pmd_set(PMD, PTE)
 #define pmd_populate(MM,PMD,PTE_PAGE)		\
 	pmd_populate_kernel(MM,PMD,page_address(PTE_PAGE))
 #define pmd_pgtable(pmd) pmd_page(pmd)
 
-static inline void check_pgt_cache(void)
-{
-	quicklist_trim(0, NULL, 25, 16);
-}
+#define check_pgt_cache()	do { } while (0)
 
 #define __pte_free_tlb(tlb, pte, addr)	pte_free((tlb)->mm, pte)
 #define __pmd_free_tlb(tlb, pmd, addr)	pmd_free((tlb)->mm, pmd)
diff --git a/arch/sparc/mm/tsb.c b/arch/sparc/mm/tsb.c
index 9484615..cb3e2bc 100644
--- a/arch/sparc/mm/tsb.c
+++ b/arch/sparc/mm/tsb.c
@@ -236,6 +236,8 @@ static void setup_tsb_params(struct mm_struct *mm, unsigned long tsb_idx, unsign
 	}
 }
 
+struct kmem_cache *pgtable_cache __read_mostly;
+
 static struct kmem_cache *tsb_caches[8] __read_mostly;
 
 static const char *tsb_cache_names[8] = {
@@ -253,6 +255,15 @@ void __init pgtable_cache_init(void)
 {
 	unsigned long i;
 
+	pgtable_cache = kmem_cache_create("pgtable_cache",
+					  PAGE_SIZE, PAGE_SIZE,
+					  0,
+					  _clear_page);
+	if (!pgtable_cache) {
+		prom_printf("pgtable_cache_init(): Could not create!\n");
+		prom_halt();
+	}
+
 	for (i = 0; i < 8; i++) {
 		unsigned long size = 8192 << i;
 		const char *name = tsb_cache_names[i];
-- 
1.6.6.1

