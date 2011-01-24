Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab1AXR42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 12:56:28 -0500
Received: from service87.mimecast.com ([94.185.240.25]:51127 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753975Ab1AXR4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 12:56:25 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 09/19] ARM: LPAE: Page table maintenance for the 3-level format
Date: Mon, 24 Jan 2011 17:55:51 +0000
Message-Id: <1295891761-18366-10-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.3.2.164.g6f10c.dirty
In-Reply-To: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 24 Jan 2011 17:56:12.0819 (UTC) FILETIME=[FD1B3E30:01CBBBEF]
X-MC-Unique: 111012417562204201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p0OHuY0e031553

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
 arch/arm/include/asm/cpu-multi32.h    |    8 ++++
 arch/arm/include/asm/cpu-single.h     |    4 ++
 arch/arm/include/asm/pgalloc.h        |   24 ++++++++++++
 arch/arm/include/asm/pgtable-2level.h |    5 +++
 arch/arm/include/asm/pgtable-3level.h |    5 +++
 arch/arm/include/asm/pgtable.h        |   60 ++++++++++++++++++++++++++++++-
 arch/arm/include/asm/proc-fns.h       |   13 +++++++
 arch/arm/mm/ioremap.c                 |    8 +++--
 arch/arm/mm/pgd.c                     |   64 +++++++++++++++++++++++++--------
 arch/arm/mm/proc-v7.S                 |    8 ++++
 10 files changed, 180 insertions(+), 19 deletions(-)

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
index 841293e..9acaa0a 100644
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
 extern pgd_t *pgd_alloc(struct mm_struct *mm);
 extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);
 
@@ -107,7 +129,9 @@ static inline void __pmd_populate(pmd_t *pmdp, phys_addr_t pte,
 {
 	pmdval_t pmdval = (pte + PTE_HWTABLE_OFF) | prot;
 	pmdp[0] = __pmd(pmdval);
+#ifndef CONFIG_ARM_LPAE
 	pmdp[1] = __pmd(pmdval + 256 * sizeof(pte_t));
+#endif
 	flush_pmd_entry(pmdp);
 }
 
diff --git a/arch/arm/include/asm/pgtable-2level.h b/arch/arm/include/asm/pgtable-2level.h
index 470457e..c21924d 100644
--- a/arch/arm/include/asm/pgtable-2level.h
+++ b/arch/arm/include/asm/pgtable-2level.h
@@ -140,4 +140,9 @@
 #define L_PTE_MT_DEV_CACHED	(_AT(pteval_t, 0x0b) << 2)	/* 1011 */
 #define L_PTE_MT_MASK		(_AT(pteval_t, 0x0f) << 2)
 
+/*
+ * Software PGD flags.
+ */
+#define L_PGD_SWAPPER		(_AT(pgdval_t, 0))		/* compatibility with LPAE */
+
 #endif /* _ASM_PGTABLE_2LEVEL_H */
diff --git a/arch/arm/include/asm/pgtable-3level.h b/arch/arm/include/asm/pgtable-3level.h
index ac45358..14a3e28 100644
--- a/arch/arm/include/asm/pgtable-3level.h
+++ b/arch/arm/include/asm/pgtable-3level.h
@@ -98,4 +98,9 @@
 #define L_PTE_MT_DEV_CACHED	(_AT(pteval_t, 3) << 2)	/* normal inner write-back */
 #define L_PTE_MT_MASK		(_AT(pteval_t, 7) << 2)
 
+/*
+ * Software PGD flags.
+ */
+#define L_PGD_SWAPPER		(_AT(pgdval_t, 1) << 55)	/* swapper_pg_dir entry */
+
 #endif /* _ASM_PGTABLE_3LEVEL_H */
diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index b474478..a833701 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -164,6 +164,31 @@ extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 /* to find an entry in a kernel page-table-directory */
 #define pgd_offset_k(addr)	pgd_offset(&init_mm, addr)
 
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
+static inline pmd_t *pgd_page_vaddr(pgd_t pgd)
+{
+	return __va(pgd_val(pgd) & PHYS_MASK & (s32)PAGE_MASK);
+}
+
+#else	/* !CONFIG_ARM_LPAE */
+
 /*
  * The "pgd_xxx()" functions here are trivial for a folded two-level
  * setup: the pgd is never bad, and a pmd always exists (as it's folded
@@ -175,12 +200,38 @@ extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 #define pgd_clear(pgdp)		do { } while (0)
 #define set_pgd(pgd,pgdp)	do { } while (0)
 
+#endif	/* CONFIG_ARM_LPAE */
 
 /* Find an entry in the second-level page table.. */
+#ifdef CONFIG_ARM_LPAE
+#define pmd_index(addr)		(((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
+#define pmd_offset(pgdp, addr)	((pmd_t *)(pgd_page_vaddr(*(pgdp))) + \
+				 pmd_index(addr))
+#else
 #define pmd_offset(dir, addr)	((pmd_t *)(dir))
+#endif
 
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
+#else	/* !CONFIG_ARM_LPAE */
+
 #define pmd_bad(pmd)		(pmd_val(pmd) & 2)
 
 #define copy_pmd(pmdpd,pmdps)		\
@@ -197,6 +248,8 @@ extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 		clean_pmd_entry(pmdp);	\
 	} while (0)
 
+#endif	/* CONFIG_ARM_LPAE */
+
 static inline pte_t *pmd_page_vaddr(pmd_t pmd)
 {
 	return __va(pmd_val(pmd) & PHYS_MASK & (s32)PAGE_MASK);
@@ -229,9 +282,14 @@ static inline pte_t *pmd_page_vaddr(pmd_t pmd)
 #define pte_page(pte)		pfn_to_page(pte_pfn(pte))
 #define mk_pte(page,prot)	pfn_pte(page_to_pfn(page), prot)
 
-#define set_pte_ext(ptep,pte,ext) cpu_set_pte_ext(ptep,pte,ext)
 #define pte_clear(mm,addr,ptep)	set_pte_ext(ptep, __pte(0), 0)
 
+#ifdef CONFIG_ARM_LPAE
+#define set_pte_ext(ptep,pte,ext) cpu_set_pte_ext(ptep,__pte(pte_val(pte)|(ext)))
+#else
+#define set_pte_ext(ptep,pte,ext) cpu_set_pte_ext(ptep,pte,ext)
+#endif
+
 #if __LINUX_ARM_ARCH__ < 6
 static inline void __sync_icache_dcache(pte_t pteval)
 {
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
index ab50627..6bdf42c 100644
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
@@ -221,7 +223,7 @@ void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
  		return NULL;
  	addr = (unsigned long)area->addr;
 
-#ifndef CONFIG_SMP
+#if !defined(CONFIG_SMP) && !defined(CONFIG_ARM_LPAE)
 	if (DOMAIN_IO == 0 &&
 	    (((cpu_architecture() >= CPU_ARCH_ARMv6) && (get_cr() & CR_XP)) ||
 	       cpu_is_xsc3()) && pfn >= 0x100000 &&
@@ -292,7 +294,7 @@ EXPORT_SYMBOL(__arm_ioremap);
 void __iounmap(volatile void __iomem *io_addr)
 {
 	void *addr = (void *)(PAGE_MASK & (unsigned long)io_addr);
-#ifndef CONFIG_SMP
+#if !defined(CONFIG_SMP) && !defined(CONFIG_ARM_LPAE)
 	struct vm_struct **p, *tmp;
 
 	/*
diff --git a/arch/arm/mm/pgd.c b/arch/arm/mm/pgd.c
index 709244c..003587d 100644
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
@@ -26,7 +35,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	pmd_t *new_pmd, *init_pmd;
 	pte_t *new_pte, *init_pte;
 
-	new_pgd = (pgd_t *)__get_free_pages(GFP_KERNEL, 2);
+	new_pgd = __pgd_alloc();
 	if (!new_pgd)
 		goto no_pgd;
 
@@ -41,12 +50,21 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 
 	clean_dcache_area(new_pgd, PTRS_PER_PGD * sizeof(pgd_t));
 
+#ifdef CONFIG_ARM_LPAE
+	/*
+	 * Allocate PMD table for modules and pkmap mappings.
+	 */
+	new_pmd = pmd_alloc(mm, new_pgd + pgd_index(MODULES_VADDR), 0);
+	if (!new_pmd)
+		goto no_pmd;
+#endif
+
 	if (!vectors_high()) {
 		/*
 		 * On ARM, first page must always be allocated since it
 		 * contains the machine vectors.
 		 */
-		new_pmd = pmd_alloc(mm, new_pgd, 0);
+		new_pmd = pmd_alloc(mm, new_pgd + pgd_index(0), 0);
 		if (!new_pmd)
 			goto no_pmd;
 
@@ -66,7 +84,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 no_pte:
 	pmd_free(mm, new_pmd);
 no_pmd:
-	free_pages((unsigned long)new_pgd, 2);
+	__pgd_free(new_pgd);
 no_pgd:
 	return NULL;
 }
@@ -80,20 +98,36 @@ void pgd_free(struct mm_struct *mm, pgd_t *pgd_base)
 	if (!pgd_base)
 		return;
 
-	pgd = pgd_base + pgd_index(0);
-	if (pgd_none_or_clear_bad(pgd))
-		goto no_pgd;
+	if (!vectors_high()) {
+		pgd = pgd_base + pgd_index(0);
+		if (pgd_none_or_clear_bad(pgd))
+			goto no_pgd;
 
-	pmd = pmd_offset(pgd, 0);
-	if (pmd_none_or_clear_bad(pmd))
-		goto no_pmd;
+		pmd = pmd_offset(pgd, 0);
+		if (pmd_none_or_clear_bad(pmd))
+			goto no_pmd;
 
-	pte = pmd_pgtable(*pmd);
-	pmd_clear(pmd);
-	pte_free(mm, pte);
+		pte = pmd_pgtable(*pmd);
+		pmd_clear(pmd);
+		pte_free(mm, pte);
 no_pmd:
-	pgd_clear(pgd);
-	pmd_free(mm, pmd);
+		pgd_clear(pgd);
+		pmd_free(mm, pmd);
+	}
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
+		pmd = pmd_offset(pgd, 0);
+		pgd_clear(pgd);
+		pmd_free(mm, pmd);
+	}
+#endif
+	__pgd_free(pgd_base);
 }
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index bb0faa1..9be03a5 100644
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
+	orreq	r2, #L_PTE_RDONLY
+1:	strd	r2, r3, [r0]
+#else	/* !CONFIG_ARM_LPAE */
 	str	r1, [r0]			@ linux version
 
 	bic	r3, r1, #0x000003f0
@@ -162,6 +169,7 @@ ENTRY(cpu_v7_set_pte_ext)
  ARM(	str	r3, [r0, #2048]! )
  THUMB(	add	r0, r0, #2048 )
  THUMB(	str	r3, [r0] )
+#endif	/* CONFIG_ARM_LPAE */
 	mcr	p15, 0, r0, c7, c10, 1		@ flush_pte
 #endif
 	mov	pc, lr

