Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800Ab1KGQRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:17:25 -0500
Received: from service87.mimecast.com ([91.220.42.44]:49840 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932761Ab1KGQRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:17:21 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 08/16] ARM: LPAE: Page table maintenance for the 3-level format
Date: Mon,  7 Nov 2011 16:16:50 +0000
Message-Id: <1320682618-1182-9-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Nov 2011 16:17:12.0216 (UTC) FILETIME=[B4C96980:01CC9D68]
X-MC-Unique: 111110716171904101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id pA7GJW2M015305

This patch modifies the pgd/pmd/pte manipulation functions to support
the 3-level page table format. Since there is no need for an 'ext'
argument to cpu_set_pte_ext(), this patch conditionally defines a
different prototype for this function when CONFIG_ARM_LPAE.

The patch also introduces the L_PGD_SWAPPER flag to mark pgd entries
pointing to pmd tables pre-allocated in the swapper_pg_dir and avoid
trying to free them at run-time. This flag is 0 with the classic page
table format.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/include/asm/pgalloc.h        |   24 +++++++++++++++
 arch/arm/include/asm/pgtable-3level.h |   53 +++++++++++++++++++++++++++++++++
 arch/arm/include/asm/proc-fns.h       |   21 +++++++++++++
 arch/arm/mm/ioremap.c                 |    8 +++--
 arch/arm/mm/pgd.c                     |   51 +++++++++++++++++++++++++++++--
 5 files changed, 150 insertions(+), 7 deletions(-)

diff --git a/arch/arm/include/asm/pgalloc.h b/arch/arm/include/asm/pgalloc.h
index 7418894..943504f 100644
--- a/arch/arm/include/asm/pgalloc.h
+++ b/arch/arm/include/asm/pgalloc.h
@@ -25,6 +25,26 @@
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
+static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
+{
+	set_pud(pud, __pud(__pa(pmd) | PMD_TYPE_TABLE));
+}
+
+#else	/* !CONFIG_ARM_LPAE */
+
 /*
  * Since we have only two-level page tables, these are trivial
  */
@@ -32,6 +52,8 @@
 #define pmd_free(mm, pmd)		do { } while (0)
 #define pud_populate(mm,pmd,pte)	BUG()
 
+#endif	/* CONFIG_ARM_LPAE */
+
 extern pgd_t *pgd_alloc(struct mm_struct *mm);
 extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);
 
@@ -109,7 +131,9 @@ static inline void __pmd_populate(pmd_t *pmdp, phys_addr_t pte,
 {
 	pmdval_t pmdval = (pte + PTE_HWTABLE_OFF) | prot;
 	pmdp[0] = __pmd(pmdval);
+#ifndef CONFIG_ARM_LPAE
 	pmdp[1] = __pmd(pmdval + 256 * sizeof(pte_t));
+#endif
 	flush_pmd_entry(pmdp);
 }
 
diff --git a/arch/arm/include/asm/pgtable-3level.h b/arch/arm/include/asm/pgtable-3level.h
index 79bf0ac..759af70 100644
--- a/arch/arm/include/asm/pgtable-3level.h
+++ b/arch/arm/include/asm/pgtable-3level.h
@@ -99,4 +99,57 @@
 #define L_PTE_MT_DEV_CACHED	(_AT(pteval_t, 3) << 2)	/* normal inner write-back */
 #define L_PTE_MT_MASK		(_AT(pteval_t, 7) << 2)
 
+/*
+ * Software PGD flags.
+ */
+#define L_PGD_SWAPPER		(_AT(pgdval_t, 1) << 55)	/* swapper_pg_dir entry */
+
+#ifndef __ASSEMBLY__
+
+#define pud_none(pud)		(!pud_val(pud))
+#define pud_bad(pud)		(!(pud_val(pud) & 2))
+#define pud_present(pud)	(pud_val(pud))
+
+#define pud_clear(pudp)			\
+	do {				\
+		*pudp = __pud(0);	\
+		clean_pmd_entry(pudp);	\
+	} while (0)
+
+#define set_pud(pudp, pud)		\
+	do {				\
+		*pudp = pud;		\
+		flush_pmd_entry(pudp);	\
+	} while (0)
+
+static inline pmd_t *pud_page_vaddr(pud_t pud)
+{
+	return __va(pud_val(pud) & PHYS_MASK & (s32)PAGE_MASK);
+}
+
+/* Find an entry in the second-level page table.. */
+#define pmd_index(addr)		(((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
+static inline pmd_t *pmd_offset(pud_t *pud, unsigned long addr)
+{
+	return (pmd_t *)pud_page_vaddr(*pud) + pmd_index(addr);
+}
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
+#define set_pte_ext(ptep,pte,ext) cpu_set_pte_ext(ptep,__pte(pte_val(pte)|(ext)))
+
+#endif /* __ASSEMBLY__ */
+
 #endif /* _ASM_PGTABLE_3LEVEL_H */
diff --git a/arch/arm/include/asm/proc-fns.h b/arch/arm/include/asm/proc-fns.h
index 9e92cb2..f3628fb 100644
--- a/arch/arm/include/asm/proc-fns.h
+++ b/arch/arm/include/asm/proc-fns.h
@@ -65,7 +65,11 @@ extern struct processor {
 	 * Set a possibly extended PTE.  Non-extended PTEs should
 	 * ignore 'ext'.
 	 */
+#ifdef CONFIG_ARM_LPAE
+	void (*set_pte_ext)(pte_t *ptep, pte_t pte);
+#else
 	void (*set_pte_ext)(pte_t *ptep, pte_t pte, unsigned int ext);
+#endif
 
 	/* Suspend/resume */
 	unsigned int suspend_size;
@@ -79,7 +83,11 @@ extern void cpu_proc_fin(void);
 extern int cpu_do_idle(void);
 extern void cpu_dcache_clean_area(void *, int);
 extern void cpu_do_switch_mm(unsigned long pgd_phys, struct mm_struct *mm);
+#ifdef CONFIG_ARM_LPAE
+extern void cpu_set_pte_ext(pte_t *ptep, pte_t pte);
+#else
 extern void cpu_set_pte_ext(pte_t *ptep, pte_t pte, unsigned int ext);
+#endif
 extern void cpu_reset(unsigned long addr) __attribute__((noreturn));
 
 /* These three are private to arch/arm/kernel/suspend.c */
@@ -107,6 +115,18 @@ extern void cpu_resume(void);
 
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
@@ -115,6 +135,7 @@ extern void cpu_resume(void);
 		pg &= ~0x3fff;				\
 		(pgd_t *)phys_to_virt(pg);		\
 	})
+#endif
 
 #endif
 
diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index c3fa40d..d1f78ba 100644
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
@@ -202,11 +202,13 @@ void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
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
@@ -228,7 +230,7 @@ void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
  		return NULL;
  	addr = (unsigned long)area->addr;
 
-#ifndef CONFIG_SMP
+#if !defined(CONFIG_SMP) && !defined(CONFIG_ARM_LPAE)
 	if (DOMAIN_IO == 0 &&
 	    (((cpu_architecture() >= CPU_ARCH_ARMv6) && (get_cr() & CR_XP)) ||
 	       cpu_is_xsc3()) && pfn >= 0x100000 &&
@@ -320,7 +322,7 @@ __arm_ioremap_exec(unsigned long phys_addr, size_t size, bool cached)
 void __iounmap(volatile void __iomem *io_addr)
 {
 	void *addr = (void *)(PAGE_MASK & (unsigned long)io_addr);
-#ifndef CONFIG_SMP
+#if !defined(CONFIG_SMP) && !defined(CONFIG_ARM_LPAE)
 	struct vm_struct **p, *tmp;
 
 	/*
diff --git a/arch/arm/mm/pgd.c b/arch/arm/mm/pgd.c
index b2027c1..a3e78cc 100644
--- a/arch/arm/mm/pgd.c
+++ b/arch/arm/mm/pgd.c
@@ -10,6 +10,7 @@
 #include <linux/mm.h>
 #include <linux/gfp.h>
 #include <linux/highmem.h>
+#include <linux/slab.h>
 
 #include <asm/pgalloc.h>
 #include <asm/page.h>
@@ -17,6 +18,14 @@
 
 #include "mm.h"
 
+#ifdef CONFIG_ARM_LPAE
+#define __pgd_alloc()	kmalloc(PTRS_PER_PGD * sizeof(pgd_t), GFP_KERNEL)
+#define __pgd_free(pgd)	kfree(pgd)
+#else
+#define __pgd_alloc()	(pgd_t *)__get_free_pages(GFP_KERNEL, 2)
+#define __pgd_free(pgd)	free_pages((unsigned long)pgd, 2)
+#endif
+
 /*
  * need to get a 16k page for level 1
  */
@@ -27,7 +36,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	pmd_t *new_pmd, *init_pmd;
 	pte_t *new_pte, *init_pte;
 
-	new_pgd = (pgd_t *)__get_free_pages(GFP_KERNEL, 2);
+	new_pgd = __pgd_alloc();
 	if (!new_pgd)
 		goto no_pgd;
 
@@ -42,10 +51,25 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 
 	clean_dcache_area(new_pgd, PTRS_PER_PGD * sizeof(pgd_t));
 
+#ifdef CONFIG_ARM_LPAE
+	/*
+	 * Allocate PMD table for modules and pkmap mappings.
+	 */
+	new_pud = pud_alloc(mm, new_pgd + pgd_index(MODULES_VADDR),
+			    MODULES_VADDR);
+	if (!new_pud)
+		goto no_pud;
+
+	new_pmd = pmd_alloc(mm, new_pud, 0);
+	if (!new_pmd)
+		goto no_pmd;
+#endif
+
 	if (!vectors_high()) {
 		/*
 		 * On ARM, first page must always be allocated since it
-		 * contains the machine vectors.
+		 * contains the machine vectors. The vectors are always high
+		 * with LPAE.
 		 */
 		new_pud = pud_alloc(mm, new_pgd, 0);
 		if (!new_pud)
@@ -74,7 +98,7 @@ no_pte:
 no_pmd:
 	pud_free(mm, new_pud);
 no_pud:
-	free_pages((unsigned long)new_pgd, 2);
+	__pgd_free(new_pgd);
 no_pgd:
 	return NULL;
 }
@@ -111,5 +135,24 @@ no_pud:
 	pgd_clear(pgd);
 	pud_free(mm, pud);
 no_pgd:
-	free_pages((unsigned long) pgd_base, 2);
+#ifdef CONFIG_ARM_LPAE
+	/*
+	 * Free modules/pkmap or identity pmd tables.
+	 */
+	for (pgd = pgd_base; pgd < pgd_base + PTRS_PER_PGD; pgd++) {
+		if (pgd_none_or_clear_bad(pgd))
+			continue;
+		if (pgd_val(*pgd) & L_PGD_SWAPPER)
+			continue;
+		pud = pud_offset(pgd, 0);
+		if (pud_none_or_clear_bad(pud))
+			continue;
+		pmd = pmd_offset(pud, 0);
+		pud_clear(pud);
+		pmd_free(mm, pmd);
+		pgd_clear(pgd);
+		pud_free(mm, pud);
+	}
+#endif
+	__pgd_free(pgd_base);
 }

