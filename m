Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617Ab0KLSCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:02:14 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50934 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932549Ab0KLSBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:01:17 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/20] ARM: LPAE: Page table maintenance for the 3-level format
Date: Fri, 12 Nov 2010 18:00:27 +0000
Message-Id: <1289584840-18097-8-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.3.2.164.g6f10c
In-Reply-To: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 12 Nov 2010 18:00:50.0672 (UTC) FILETIME=[8A907F00:01CB8293]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the pgd/pmd/pte manipulation functions to support
the 3-level page table format. Since there is no need for an 'ext'
argument to cpu_set_pte_ext(), this patch conditionally defines a
different prototype for this function when CONFIG_ARM_LPAE.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/include/asm/cpu-multi32.h |    8 ++++
 arch/arm/include/asm/cpu-single.h  |    4 ++
 arch/arm/include/asm/pgalloc.h     |   26 ++++++++++++-
 arch/arm/include/asm/pgtable.h     |   72 ++++++++++++++++++++++++++++++++++++
 arch/arm/include/asm/proc-fns.h    |   13 ++++++
 arch/arm/mm/ioremap.c              |    8 ++-
 arch/arm/mm/pgd.c                  |   18 +++++++--
 arch/arm/mm/proc-v7.S              |    8 ++++
 8 files changed, 149 insertions(+), 8 deletions(-)

diff --git a/arch/arm/include/asm/cpu-multi32.h b/arch/arm/include/asm/cpu-multi32.h
index e2b5b0b..985fcf5 100644
--- a/arch/arm/include/asm/cpu-multi32.h
+++ b/arch/arm/include/asm/cpu-multi32.h
@@ -57,7 +57,11 @@ extern struct processor {
 	 * Set a possibly extended PTE.  Non-extended PTEs should
 	 * ignore 'ext'.
 	 */
+#ifdef CONFIG_ARM_LPAE
+	void (*set_pte_ext)(pte_t *ptep, pte_t pte);
+#else
 	void (*set_pte_ext)(pte_t *ptep, pte_t pte, unsigned int ext);
+#endif
 } processor;
 
 #define cpu_proc_init()			processor._proc_init()
@@ -65,5 +69,9 @@ extern struct processor {
 #define cpu_reset(addr)			processor.reset(addr)
 #define cpu_do_idle()			processor._do_idle()
 #define cpu_dcache_clean_area(addr,sz)	processor.dcache_clean_area(addr,sz)
+#ifdef CONFIG_ARM_LPAE
+#define cpu_set_pte_ext(ptep,pte)	processor.set_pte_ext(ptep,pte)
+#else
 #define cpu_set_pte_ext(ptep,pte,ext)	processor.set_pte_ext(ptep,pte,ext)
+#endif
 #define cpu_do_switch_mm(pgd,mm)	processor.switch_mm(pgd,mm)
diff --git a/arch/arm/include/asm/cpu-single.h b/arch/arm/include/asm/cpu-single.h
index f073a6d..f436df2 100644
--- a/arch/arm/include/asm/cpu-single.h
+++ b/arch/arm/include/asm/cpu-single.h
@@ -40,5 +40,9 @@ extern void cpu_proc_fin(void);
 extern int cpu_do_idle(void);
 extern void cpu_dcache_clean_area(void *, int);
 extern void cpu_do_switch_mm(unsigned long pgd_phys, struct mm_struct *mm);
+#ifdef CONFIG_ARM_LPAE
+extern void cpu_set_pte_ext(pte_t *ptep, pte_t pte);
+#else
 extern void cpu_set_pte_ext(pte_t *ptep, pte_t pte, unsigned int ext);
+#endif
 extern void cpu_reset(unsigned long addr) __attribute__((noreturn));
diff --git a/arch/arm/include/asm/pgalloc.h b/arch/arm/include/asm/pgalloc.h
index c2a1f64..64a303d 100644
--- a/arch/arm/include/asm/pgalloc.h
+++ b/arch/arm/include/asm/pgalloc.h
@@ -23,6 +23,26 @@
 #define _PAGE_USER_TABLE	(PMD_TYPE_TABLE | PMD_BIT4 | PMD_DOMAIN(DOMAIN_USER))
 #define _PAGE_KERNEL_TABLE	(PMD_TYPE_TABLE | PMD_BIT4 | PMD_DOMAIN(DOMAIN_KERNEL))
 
+#ifdef CONFIG_ARM_LPAE
+
+static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
+{
+	return (pmd_t *)get_zeroed_page(GFP_KERNEL | __GFP_REPEAT);
+}
+
+static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
+{
+	BUG_ON((unsigned long)pmd & (PAGE_SIZE-1));
+	free_page((unsigned long)pmd);
+}
+
+static inline void pgd_populate(struct mm_struct *mm, pgd_t *pgd, pmd_t *pmd)
+{
+	set_pgd(pgd, __pgd(__pa(pmd) | PMD_TYPE_TABLE));
+}
+
+#else	/* !CONFIG_ARM_LPAE */
+
 /*
  * Since we have only two-level page tables, these are trivial
  */
@@ -30,6 +50,8 @@
 #define pmd_free(mm, pmd)		do { } while (0)
 #define pgd_populate(mm,pmd,pte)	BUG()
 
+#endif	/* CONFIG_ARM_LPAE */
+
 extern pgd_t *get_pgd_slow(struct mm_struct *mm);
 extern void free_pgd_slow(struct mm_struct *mm, pgd_t *pgd);
 
@@ -106,10 +128,12 @@ static inline void pte_free(struct mm_struct *mm, pgtable_t pte)
 	__free_page(pte);
 }
 
-static inline void __pmd_populate(pmd_t *pmdp, unsigned long pmdval)
+static inline void __pmd_populate(pmd_t *pmdp, pmd_t pmdval)
 {
 	pmdp[0] = __pmd(pmdval);
+#ifndef CONFIG_ARM_LPAE
 	pmdp[1] = __pmd(pmdval + 256 * sizeof(pte_t));
+#endif
 	flush_pmd_entry(pmdp);
 }
 
diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 97a5de3..41236f0 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -124,7 +124,12 @@ extern pgprot_t		pgprot_kernel;
 extern struct page *empty_zero_page;
 #define ZERO_PAGE(vaddr)	(empty_zero_page)
 
+#ifdef CONFIG_ARM_LPAE
+#define pte_pfn(pte)		((pte_val(pte) & PTE_PFN_MASK) >> PAGE_SHIFT)
+#else
 #define pte_pfn(pte)		(pte_val(pte) >> PAGE_SHIFT)
+#endif
+
 #define pfn_pte(pfn,prot)	(__pte(((pfn) << PAGE_SHIFT) | pgprot_val(prot)))
 
 #define pte_none(pte)		(!pte_val(pte))
@@ -143,7 +148,11 @@ extern struct page *empty_zero_page;
 #define __pte_unmap(pte)	kunmap_atomic((pte - LINUX_PTE_OFFSET))
 #endif
 
+#ifdef CONFIG_ARM_LPAE
+#define set_pte_ext(ptep,pte,ext) cpu_set_pte_ext(ptep,(pte)|(ext))
+#else
 #define set_pte_ext(ptep,pte,ext) cpu_set_pte_ext(ptep,pte,ext)
+#endif
 
 #if __LINUX_ARM_ARCH__ < 6
 static inline void __sync_icache_dcache(pte_t pteval)
@@ -226,6 +235,30 @@ extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 
 #define pmd_none(pmd)		(!pmd_val(pmd))
 #define pmd_present(pmd)	(pmd_val(pmd))
+
+#ifdef CONFIG_ARM_LPAE
+
+#define pmd_bad(pmd)		(!(pmd_val(pmd) & 2))
+
+#define copy_pmd(pmdpd,pmdps)		\
+	do {				\
+		*pmdpd = *pmdps;	\
+		flush_pmd_entry(pmdpd);	\
+	} while (0)
+
+#define pmd_clear(pmdp)			\
+	do {				\
+		*pmdp = __pmd(0);	\
+		clean_pmd_entry(pmdp);	\
+	} while (0)
+
+static inline pte_t *pmd_page_vaddr(pmd_t pmd)
+{
+	return __va(pmd_val(pmd) & PTE_PFN_MASK);
+}
+
+#else	/* !CONFIG_ARM_LPAE */
+
 #define pmd_bad(pmd)		(pmd_val(pmd) & 2)
 
 #define copy_pmd(pmdpd,pmdps)		\
@@ -252,7 +285,13 @@ static inline pte_t *pmd_page_vaddr(pmd_t pmd)
 	return __va(ptr);
 }
 
+#endif	/* CONFIG_ARM_LPAE */
+
+#ifdef CONFIG_ARM_LPAE
+#define pmd_page(pmd)		pfn_to_page(__phys_to_pfn(pmd_val(pmd) & PTE_PFN_MASK))
+#else
 #define pmd_page(pmd)		pfn_to_page(__phys_to_pfn(pmd_val(pmd)))
+#endif
 
 /*
  * Conversion functions: convert a page and protection to a page entry,
@@ -260,6 +299,31 @@ static inline pte_t *pmd_page_vaddr(pmd_t pmd)
  */
 #define mk_pte(page,prot)	pfn_pte(page_to_pfn(page),prot)
 
+#ifdef CONFIG_ARM_LPAE
+
+#define pgd_none(pgd)		(!pgd_val(pgd))
+#define pgd_bad(pgd)		(!(pgd_val(pgd) & 2))
+#define pgd_present(pgd)	(pgd_val(pgd))
+
+#define pgd_clear(pgdp)			\
+	do {				\
+		*pgdp = __pgd(0);	\
+		clean_pmd_entry(pgdp);	\
+	} while (0)
+
+#define set_pgd(pgdp, pgd)		\
+	do {				\
+		*pgdp = pgd;		\
+		flush_pmd_entry(pgdp);	\
+	} while (0)
+
+static inline pte_t *pgd_page_vaddr(pmd_t pgd)
+{
+	return __va(pgd_val(pgd) & PTE_PFN_MASK);
+}
+
+#else	/* !CONFIG_ARM_LPAE */
+
 /*
  * The "pgd_xxx()" functions here are trivial for a folded two-level
  * setup: the pgd is never bad, and a pmd always exists (as it's folded
@@ -271,6 +335,8 @@ static inline pte_t *pmd_page_vaddr(pmd_t pmd)
 #define pgd_clear(pgdp)		do { } while (0)
 #define set_pgd(pgd,pgdp)	do { } while (0)
 
+#endif	/* CONFIG_ARM_LPAE */
+
 /* to find an entry in a page-table-directory */
 #define pgd_index(addr)		((addr) >> PGDIR_SHIFT)
 
@@ -280,7 +346,13 @@ static inline pte_t *pmd_page_vaddr(pmd_t pmd)
 #define pgd_offset_k(addr)	pgd_offset(&init_mm, addr)
 
 /* Find an entry in the second-level page table.. */
+#ifdef CONFIG_ARM_LPAE
+#define pmd_index(addr)		(((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
+#define pmd_offset(pgdp, addr)	((pmd_t *)(pgd_page_vaddr(*(pgdp))) + \
+				 pmd_index(addr))
+#else
 #define pmd_offset(dir, addr)	((pmd_t *)(dir))
+#endif
 
 /* Find an entry in the third-level page table.. */
 #define __pte_index(addr)	(((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
diff --git a/arch/arm/include/asm/proc-fns.h b/arch/arm/include/asm/proc-fns.h
index 8fdae9b..f00ae99 100644
--- a/arch/arm/include/asm/proc-fns.h
+++ b/arch/arm/include/asm/proc-fns.h
@@ -263,6 +263,18 @@
 
 #define cpu_switch_mm(pgd,mm) cpu_do_switch_mm(virt_to_phys(pgd),mm)
 
+#ifdef CONFIG_ARM_LPAE
+#define cpu_get_pgd()	\
+	({						\
+		unsigned long pg, pg2;			\
+		__asm__("mrrc	p15, 0, %0, %1, c2"	\
+			: "=r" (pg), "=r" (pg2)		\
+			:				\
+			: "cc");			\
+		pg &= ~(PTRS_PER_PGD*sizeof(pgd_t)-1);	\
+		(pgd_t *)phys_to_virt(pg);		\
+	})
+#else
 #define cpu_get_pgd()	\
 	({						\
 		unsigned long pg;			\
@@ -271,6 +283,7 @@
 		pg &= ~0x3fff;				\
 		(pgd_t *)phys_to_virt(pg);		\
 	})
+#endif
 
 #endif
 
diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index 17e7b0b..ccfb2ab 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -64,7 +64,7 @@ void __check_kvm_seq(struct mm_struct *mm)
 	} while (seq != init_mm.context.kvm_seq);
 }
 
-#ifndef CONFIG_SMP
+#if !defined(CONFIG_SMP) && !defined(CONFIG_ARM_LPAE)
 /*
  * Section support is unsafe on SMP - If you iounmap and ioremap a region,
  * the other CPUs will not see this change until their next context switch.
@@ -195,11 +195,13 @@ void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
 	unsigned long addr;
  	struct vm_struct * area;
 
+#ifndef CONFIG_ARM_LPAE
 	/*
 	 * High mappings must be supersection aligned
 	 */
 	if (pfn >= 0x100000 && (__pfn_to_phys(pfn) & ~SUPERSECTION_MASK))
 		return NULL;
+#endif
 
 	/*
 	 * Don't allow RAM to be mapped - this causes problems with ARMv6+
@@ -225,7 +227,7 @@ void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
  		return NULL;
  	addr = (unsigned long)area->addr;
 
-#ifndef CONFIG_SMP
+#if !defined(CONFIG_SMP) && !defined(CONFIG_ARM_LPAE)
 	if (DOMAIN_IO == 0 &&
 	    (((cpu_architecture() >= CPU_ARCH_ARMv6) && (get_cr() & CR_XP)) ||
 	       cpu_is_xsc3()) && pfn >= 0x100000 &&
@@ -296,7 +298,7 @@ EXPORT_SYMBOL(__arm_ioremap);
 void __iounmap(volatile void __iomem *io_addr)
 {
 	void *addr = (void *)(PAGE_MASK & (unsigned long)io_addr);
-#ifndef CONFIG_SMP
+#if !defined(CONFIG_SMP) && !defined(CONFIG_ARM_LPAE)
 	struct vm_struct **p, *tmp;
 
 	/*
diff --git a/arch/arm/mm/pgd.c b/arch/arm/mm/pgd.c
index 69bbfc6..e7c149b 100644
--- a/arch/arm/mm/pgd.c
+++ b/arch/arm/mm/pgd.c
@@ -10,6 +10,7 @@
 #include <linux/mm.h>
 #include <linux/gfp.h>
 #include <linux/highmem.h>
+#include <linux/slab.h>
 
 #include <asm/pgalloc.h>
 #include <asm/page.h>
@@ -17,7 +18,15 @@
 
 #include "mm.h"
 
+#ifdef CONFIG_ARM_LPAE
+#define alloc_pgd()	kmalloc(PTRS_PER_PGD * sizeof(pgd_t), GFP_KERNEL)
+#define free_pgd(pgd)	kfree(pgd)
+#define FIRST_KERNEL_PGD_NR	(PAGE_OFFSET >> PGDIR_SHIFT)
+#else
+#define alloc_pgd()	(pgd_t *)__get_free_pages(GFP_KERNEL, 2)
+#define free_pgd(pgd)	free_pages((unsigned long)pgd, 2)
 #define FIRST_KERNEL_PGD_NR	(FIRST_USER_PGD_NR + USER_PTRS_PER_PGD)
+#endif
 
 /*
  * need to get a 16k page for level 1
@@ -28,7 +37,7 @@ pgd_t *get_pgd_slow(struct mm_struct *mm)
 	pmd_t *new_pmd, *init_pmd;
 	pte_t *new_pte, *init_pte;
 
-	new_pgd = (pgd_t *)__get_free_pages(GFP_KERNEL, 2);
+	new_pgd = alloc_pgd();
 	if (!new_pgd)
 		goto no_pgd;
 
@@ -68,7 +77,7 @@ pgd_t *get_pgd_slow(struct mm_struct *mm)
 no_pte:
 	pmd_free(mm, new_pmd);
 no_pmd:
-	free_pages((unsigned long)new_pgd, 2);
+	free_pgd(new_pgd);
 no_pgd:
 	return NULL;
 }
@@ -81,7 +90,8 @@ void free_pgd_slow(struct mm_struct *mm, pgd_t *pgd)
 	if (!pgd)
 		return;
 
-	/* pgd is always present and good */
+	if (pgd_none(*pgd))
+		goto free;
 	pmd = pmd_off(pgd, 0);
 	if (pmd_none(*pmd))
 		goto free;
@@ -96,5 +106,5 @@ void free_pgd_slow(struct mm_struct *mm, pgd_t *pgd)
 	pte_free(mm, pte);
 	pmd_free(mm, pmd);
 free:
-	free_pages((unsigned long) pgd, 2);
+	free_pgd(pgd);
 }
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 2b5b20b..1098a49 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -130,6 +130,13 @@ ENDPROC(cpu_v7_switch_mm)
  */
 ENTRY(cpu_v7_set_pte_ext)
 #ifdef CONFIG_MMU
+#ifdef CONFIG_ARM_LPAE
+	tst	r2, #L_PTE_PRESENT
+	beq	1f
+	tst	r3, #1 << (55 - 32)		@ L_PTE_DIRTY
+	orreq	r2, #L_PTE_NOWRITE
+1:	strd	r2, r3, [r0]
+#else	/* !CONFIG_ARM_LPAE */
  ARM(	str	r1, [r0], #-2048	)	@ linux version
  THUMB(	str	r1, [r0]		)	@ linux version
  THUMB(	sub	r0, r0, #2048		)
@@ -162,6 +169,7 @@ ENTRY(cpu_v7_set_pte_ext)
 	moveq	r3, #0
 
 	str	r3, [r0]
+#endif	/* CONFIG_ARM_LPAE */
 	mcr	p15, 0, r0, c7, c10, 1		@ flush_pte
 #endif
 	mov	pc, lr
