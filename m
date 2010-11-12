Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab0KLSBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:01:08 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50894 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756446Ab0KLSBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:01:02 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 04/20] ARM: LPAE: Do not assume Linux PTEs are always at PTRS_PER_PTE offset
Date: Fri, 12 Nov 2010 18:00:24 +0000
Message-Id: <1289584840-18097-5-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.3.2.164.g6f10c
In-Reply-To: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 12 Nov 2010 18:00:49.0391 (UTC) FILETIME=[89CD07F0:01CB8293]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Placing the Linux PTEs at a 2KB offset inside a page is a workaround for
the 2-level page table format where not enough spare bits are available.
With LPAE this is no longer required. This patch changes such assumption
by using a different macro, LINUX_PTE_OFFSET, which is defined to
PTRS_PER_PTE for the 2-level page tables.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/include/asm/pgalloc.h        |    6 +++---
 arch/arm/include/asm/pgtable-2level.h |    1 +
 arch/arm/include/asm/pgtable.h        |    6 +++---
 arch/arm/mm/fault.c                   |    2 +-
 arch/arm/mm/mmu.c                     |    3 ++-
 5 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/arm/include/asm/pgalloc.h b/arch/arm/include/asm/pgalloc.h
index b12cc98..c2a1f64 100644
--- a/arch/arm/include/asm/pgalloc.h
+++ b/arch/arm/include/asm/pgalloc.h
@@ -62,7 +62,7 @@ pte_alloc_one_kernel(struct mm_struct *mm, unsigned long addr)
 	pte = (pte_t *)__get_free_page(PGALLOC_GFP);
 	if (pte) {
 		clean_dcache_area(pte, sizeof(pte_t) * PTRS_PER_PTE);
-		pte += PTRS_PER_PTE;
+		pte += LINUX_PTE_OFFSET;
 	}
 
 	return pte;
@@ -95,7 +95,7 @@ pte_alloc_one(struct mm_struct *mm, unsigned long addr)
 static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
 {
 	if (pte) {
-		pte -= PTRS_PER_PTE;
+		pte -= LINUX_PTE_OFFSET;
 		free_page((unsigned long)pte);
 	}
 }
@@ -128,7 +128,7 @@ pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmdp, pte_t *ptep)
 	 * The pmd must be loaded with the physical
 	 * address of the PTE table
 	 */
-	pte_ptr -= PTRS_PER_PTE * sizeof(void *);
+	pte_ptr -= LINUX_PTE_OFFSET * sizeof(void *);
 	__pmd_populate(pmdp, __pa(pte_ptr) | _PAGE_KERNEL_TABLE);
 }
 
diff --git a/arch/arm/include/asm/pgtable-2level.h b/arch/arm/include/asm/pgtable-2level.h
index d60bda9..36bdef7 100644
--- a/arch/arm/include/asm/pgtable-2level.h
+++ b/arch/arm/include/asm/pgtable-2level.h
@@ -71,6 +71,7 @@
 #define PTRS_PER_PTE		512
 #define PTRS_PER_PMD		1
 #define PTRS_PER_PGD		2048
+#define LINUX_PTE_OFFSET	PTRS_PER_PTE
 
 /*
  * PMD_SHIFT determines the size of the area a second-level page table can map
diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 17e7ba6..ea08ab7 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -135,8 +135,8 @@ extern struct page *empty_zero_page;
 #define __pte_map(dir)		pmd_page_vaddr(*(dir))
 #define __pte_unmap(pte)	do { } while (0)
 #else
-#define __pte_map(dir)		((pte_t *)kmap_atomic(pmd_page(*(dir))) + PTRS_PER_PTE)
-#define __pte_unmap(pte)	kunmap_atomic((pte - PTRS_PER_PTE))
+#define __pte_map(dir)		((pte_t *)kmap_atomic(pmd_page(*(dir))) + LINUX_PTE_OFFSET)
+#define __pte_unmap(pte)	kunmap_atomic((pte - LINUX_PTE_OFFSET))
 #endif
 
 #define set_pte_ext(ptep,pte,ext) cpu_set_pte_ext(ptep,pte,ext)
@@ -232,7 +232,7 @@ static inline pte_t *pmd_page_vaddr(pmd_t pmd)
 	unsigned long ptr;
 
 	ptr = pmd_val(pmd) & ~(PTRS_PER_PTE * sizeof(void *) - 1);
-	ptr += PTRS_PER_PTE * sizeof(void *);
+	ptr += LINUX_PTE_OFFSET * sizeof(void *);
 
 	return __va(ptr);
 }
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 1e21e12..5da7b0c 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -108,7 +108,7 @@ void show_pte(struct mm_struct *mm, unsigned long addr)
 
 		pte = pte_offset_map(pmd, addr);
 		printk(", *pte=%08lx", pte_val(*pte));
-		printk(", *ppte=%08lx", pte_val(pte[-PTRS_PER_PTE]));
+		printk(", *ppte=%08lx", pte_val(pte[-LINUX_PTE_OFFSET]));
 		pte_unmap(pte);
 	} while(0);
 
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 5e3adca..7324fbc 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -535,7 +535,8 @@ static void __init *early_alloc(unsigned long sz)
 static pte_t * __init early_pte_alloc(pmd_t *pmd, unsigned long addr, unsigned long prot)
 {
 	if (pmd_none(*pmd)) {
-		pte_t *pte = early_alloc(2 * PTRS_PER_PTE * sizeof(pte_t));
+		pte_t *pte = early_alloc((LINUX_PTE_OFFSET +
+					  PTRS_PER_PTE) * sizeof(pte_t));
 		__pmd_populate(pmd, __pa(pte) | prot);
 	}
 	BUG_ON(pmd_bad(*pmd));
