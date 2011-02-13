Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab1BMGhL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 01:37:11 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:56112 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332Ab1BMGhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 01:37:04 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "'Greg KH'" <greg@kroah.com>
Subject: [PATCHv2 07/11] unicore32 core architecture: mm related: fault handling
Date: Sun, 13 Feb 2011 14:36:55 +0800
Message-ID: <02ef01cbcb48$67f4ee60$37decb20$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcvLSF9Mg977B284Tk6zMLcK1+s44A==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements fault handling of memory management.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/mmu.h           |   17 +
 arch/unicore32/include/asm/mmu_context.h   |   87 +++++
 arch/unicore32/include/asm/pgalloc.h       |  110 ++++++
 arch/unicore32/include/asm/pgtable-hwdef.h |   55 +++
 arch/unicore32/include/asm/pgtable.h       |  317 +++++++++++++++++
 arch/unicore32/mm/alignment.c              |  523 +++++++++++++++++++++++++++
 arch/unicore32/mm/extable.c                |   24 ++
 arch/unicore32/mm/fault.c                  |  479 +++++++++++++++++++++++++
 arch/unicore32/mm/mmu.c                    |  533 ++++++++++++++++++++++++++++
 arch/unicore32/mm/pgd.c                    |  102 ++++++
 10 files changed, 2247 insertions(+), 0 deletions(-)
 create mode 100644 arch/unicore32/include/asm/mmu.h
 create mode 100644 arch/unicore32/include/asm/mmu_context.h
 create mode 100644 arch/unicore32/include/asm/pgalloc.h
 create mode 100644 arch/unicore32/include/asm/pgtable-hwdef.h
 create mode 100644 arch/unicore32/include/asm/pgtable.h
 create mode 100644 arch/unicore32/mm/alignment.c
 create mode 100644 arch/unicore32/mm/extable.c
 create mode 100644 arch/unicore32/mm/fault.c
 create mode 100644 arch/unicore32/mm/mmu.c
 create mode 100644 arch/unicore32/mm/pgd.c

diff --git a/arch/unicore32/include/asm/mmu.h b/arch/unicore32/include/asm/mmu.h
new file mode 100644
index 0000000..66fa341
--- /dev/null
+++ b/arch/unicore32/include/asm/mmu.h
@@ -0,0 +1,17 @@
+/*
+ * linux/arch/unicore32/include/asm/mmu.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_MMU_H__
+#define __UNICORE_MMU_H__
+
+typedef	unsigned long mm_context_t;
+
+#endif
diff --git a/arch/unicore32/include/asm/mmu_context.h b/arch/unicore32/include/asm/mmu_context.h
new file mode 100644
index 0000000..fb5e4c6
--- /dev/null
+++ b/arch/unicore32/include/asm/mmu_context.h
@@ -0,0 +1,87 @@
+/*
+ * linux/arch/unicore32/include/asm/mmu_context.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_MMU_CONTEXT_H__
+#define __UNICORE_MMU_CONTEXT_H__
+
+#include <linux/compiler.h>
+#include <linux/sched.h>
+#include <linux/io.h>
+
+#include <asm/cacheflush.h>
+#include <asm/cpu-single.h>
+
+#define init_new_context(tsk, mm)	0
+
+#define destroy_context(mm)		do { } while (0)
+
+/*
+ * This is called when "tsk" is about to enter lazy TLB mode.
+ *
+ * mm:  describes the currently active mm context
+ * tsk: task which is entering lazy tlb
+ * cpu: cpu number which is entering lazy tlb
+ *
+ * tsk->mm will be NULL
+ */
+static inline void
+enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
+{
+}
+
+/*
+ * This is the actual mm switch as far as the scheduler
+ * is concerned.  No registers are touched.  We avoid
+ * calling the CPU specific function when the mm hasn't
+ * actually changed.
+ */
+static inline void
+switch_mm(struct mm_struct *prev, struct mm_struct *next,
+	  struct task_struct *tsk)
+{
+	unsigned int cpu = smp_processor_id();
+
+	if (!cpumask_test_and_set_cpu(cpu, mm_cpumask(next)) || prev != next)
+		cpu_switch_mm(next->pgd, next);
+}
+
+#define deactivate_mm(tsk, mm)	do { } while (0)
+#define activate_mm(prev, next)	switch_mm(prev, next, NULL)
+
+/*
+ * We are inserting a "fake" vma for the user-accessible vector page so
+ * gdb and friends can get to it through ptrace and /proc/<pid>/mem.
+ * But we also want to remove it before the generic code gets to see it
+ * during process exit or the unmapping of it would  cause total havoc.
+ * (the macro is used as remove_vma() is static to mm/mmap.c)
+ */
+#define arch_exit_mmap(mm) \
+do { \
+	struct vm_area_struct *high_vma = find_vma(mm, 0xffff0000); \
+	if (high_vma) { \
+		BUG_ON(high_vma->vm_next);  /* it should be last */ \
+		if (high_vma->vm_prev) \
+			high_vma->vm_prev->vm_next = NULL; \
+		else \
+			mm->mmap = NULL; \
+		rb_erase(&high_vma->vm_rb, &mm->mm_rb); \
+		mm->mmap_cache = NULL; \
+		mm->map_count--; \
+		remove_vma(high_vma); \
+	} \
+} while (0)
+
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+#endif
diff --git a/arch/unicore32/include/asm/pgalloc.h b/arch/unicore32/include/asm/pgalloc.h
new file mode 100644
index 0000000..0213e37
--- /dev/null
+++ b/arch/unicore32/include/asm/pgalloc.h
@@ -0,0 +1,110 @@
+/*
+ * linux/arch/unicore32/include/asm/pgalloc.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_PGALLOC_H__
+#define __UNICORE_PGALLOC_H__
+
+#include <asm/pgtable-hwdef.h>
+#include <asm/processor.h>
+#include <asm/cacheflush.h>
+#include <asm/tlbflush.h>
+
+#define check_pgt_cache()		do { } while (0)
+
+#define _PAGE_USER_TABLE	(PMD_TYPE_TABLE | PMD_PRESENT)
+#define _PAGE_KERNEL_TABLE	(PMD_TYPE_TABLE | PMD_PRESENT)
+
+extern pgd_t *get_pgd_slow(struct mm_struct *mm);
+extern void free_pgd_slow(struct mm_struct *mm, pgd_t *pgd);
+
+#define pgd_alloc(mm)			get_pgd_slow(mm)
+#define pgd_free(mm, pgd)		free_pgd_slow(mm, pgd)
+
+#define PGALLOC_GFP	(GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO)
+
+/*
+ * Allocate one PTE table.
+ */
+static inline pte_t *
+pte_alloc_one_kernel(struct mm_struct *mm, unsigned long addr)
+{
+	pte_t *pte;
+
+	pte = (pte_t *)__get_free_page(PGALLOC_GFP);
+	if (pte)
+		clean_dcache_area(pte, PTRS_PER_PTE * sizeof(pte_t));
+
+	return pte;
+}
+
+static inline pgtable_t
+pte_alloc_one(struct mm_struct *mm, unsigned long addr)
+{
+	struct page *pte;
+
+	pte = alloc_pages(PGALLOC_GFP, 0);
+	if (pte) {
+		if (!PageHighMem(pte)) {
+			void *page = page_address(pte);
+			clean_dcache_area(page, PTRS_PER_PTE * sizeof(pte_t));
+		}
+		pgtable_page_ctor(pte);
+	}
+
+	return pte;
+}
+
+/*
+ * Free one PTE table.
+ */
+static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
+{
+	if (pte)
+		free_page((unsigned long)pte);
+}
+
+static inline void pte_free(struct mm_struct *mm, pgtable_t pte)
+{
+	pgtable_page_dtor(pte);
+	__free_page(pte);
+}
+
+static inline void __pmd_populate(pmd_t *pmdp, unsigned long pmdval)
+{
+	set_pmd(pmdp, __pmd(pmdval));
+	flush_pmd_entry(pmdp);
+}
+
+/*
+ * Populate the pmdp entry with a pointer to the pte.  This pmd is part
+ * of the mm address space.
+ */
+static inline void
+pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmdp, pte_t *ptep)
+{
+	unsigned long pte_ptr = (unsigned long)ptep;
+
+	/*
+	 * The pmd must be loaded with the physical
+	 * address of the PTE table
+	 */
+	__pmd_populate(pmdp, __pa(pte_ptr) | _PAGE_KERNEL_TABLE);
+}
+
+static inline void
+pmd_populate(struct mm_struct *mm, pmd_t *pmdp, pgtable_t ptep)
+{
+	__pmd_populate(pmdp,
+			page_to_pfn(ptep) << PAGE_SHIFT | _PAGE_USER_TABLE);
+}
+#define pmd_pgtable(pmd) pmd_page(pmd)
+
+#endif
diff --git a/arch/unicore32/include/asm/pgtable-hwdef.h b/arch/unicore32/include/asm/pgtable-hwdef.h
new file mode 100644
index 0000000..7314e85
--- /dev/null
+++ b/arch/unicore32/include/asm/pgtable-hwdef.h
@@ -0,0 +1,55 @@
+/*
+ * linux/arch/unicore32/include/asm/pgtable-hwdef.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_PGTABLE_HWDEF_H__
+#define __UNICORE_PGTABLE_HWDEF_H__
+
+/*
+ * Hardware page table definitions.
+ *
+ * + Level 1 descriptor (PMD)
+ *   - common
+ */
+#define PMD_TYPE_MASK		(3 << 0)
+#define PMD_TYPE_TABLE		(0 << 0)
+/*#define PMD_TYPE_LARGE	(1 << 0) */
+#define PMD_TYPE_INVALID	(2 << 0)
+#define PMD_TYPE_SECT		(3 << 0)
+
+#define PMD_PRESENT		(1 << 2)
+#define PMD_YOUNG		(1 << 3)
+
+/*#define PMD_SECT_DIRTY	(1 << 4) */
+#define PMD_SECT_CACHEABLE	(1 << 5)
+#define PMD_SECT_EXEC		(1 << 6)
+#define PMD_SECT_WRITE		(1 << 7)
+#define PMD_SECT_READ		(1 << 8)
+
+/*
+ * + Level 2 descriptor (PTE)
+ *   - common
+ */
+#define PTE_TYPE_MASK		(3 << 0)
+#define PTE_TYPE_SMALL		(0 << 0)
+#define PTE_TYPE_MIDDLE		(1 << 0)
+#define PTE_TYPE_LARGE		(2 << 0)
+#define PTE_TYPE_INVALID	(3 << 0)
+
+#define PTE_PRESENT		(1 << 2)
+#define PTE_FILE		(1 << 3)	/* only when !PRESENT */
+#define PTE_YOUNG		(1 << 3)
+#define PTE_DIRTY		(1 << 4)
+#define PTE_CACHEABLE		(1 << 5)
+#define PTE_EXEC		(1 << 6)
+#define PTE_WRITE		(1 << 7)
+#define PTE_READ		(1 << 8)
+
+#endif
diff --git a/arch/unicore32/include/asm/pgtable.h b/arch/unicore32/include/asm/pgtable.h
new file mode 100644
index 0000000..68b2f29
--- /dev/null
+++ b/arch/unicore32/include/asm/pgtable.h
@@ -0,0 +1,317 @@
+/*
+ * linux/arch/unicore32/include/asm/pgtable.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_PGTABLE_H__
+#define __UNICORE_PGTABLE_H__
+
+#include <asm-generic/pgtable-nopmd.h>
+#include <asm/cpu-single.h>
+
+#include <asm/memory.h>
+#include <asm/pgtable-hwdef.h>
+
+/*
+ * Just any arbitrary offset to the start of the vmalloc VM area: the
+ * current 8MB value just means that there will be a 8MB "hole" after the
+ * physical memory until the kernel virtual memory starts.  That means that
+ * any out-of-bounds memory accesses will hopefully be caught.
+ * The vmalloc() routines leaves a hole of 4kB between each vmalloced
+ * area for the same reason. ;)
+ *
+ * Note that platforms may override VMALLOC_START, but they must provide
+ * VMALLOC_END.  VMALLOC_END defines the (exclusive) limit of this space,
+ * which may not overlap IO space.
+ */
+#ifndef VMALLOC_START
+#define VMALLOC_OFFSET		SZ_8M
+#define VMALLOC_START		(((unsigned long)high_memory + VMALLOC_OFFSET) \
+					& ~(VMALLOC_OFFSET-1))
+#define VMALLOC_END		(0xff000000UL)
+#endif
+
+#define PTRS_PER_PTE		1024
+#define PTRS_PER_PGD		1024
+
+/*
+ * PGDIR_SHIFT determines what a third-level page table entry can map
+ */
+#define PGDIR_SHIFT		22
+
+#ifndef __ASSEMBLY__
+extern void __pte_error(const char *file, int line, unsigned long val);
+extern void __pgd_error(const char *file, int line, unsigned long val);
+
+#define pte_ERROR(pte)		__pte_error(__FILE__, __LINE__, pte_val(pte))
+#define pgd_ERROR(pgd)		__pgd_error(__FILE__, __LINE__, pgd_val(pgd))
+#endif /* !__ASSEMBLY__ */
+
+#define PGDIR_SIZE		(1UL << PGDIR_SHIFT)
+#define PGDIR_MASK		(~(PGDIR_SIZE-1))
+
+/*
+ * This is the lowest virtual address we can permit any user space
+ * mapping to be mapped at.  This is particularly important for
+ * non-high vector CPUs.
+ */
+#define FIRST_USER_ADDRESS	PAGE_SIZE
+
+#define FIRST_USER_PGD_NR	1
+#define USER_PTRS_PER_PGD	((TASK_SIZE/PGDIR_SIZE) - FIRST_USER_PGD_NR)
+
+/*
+ * section address mask and size definitions.
+ */
+#define SECTION_SHIFT		22
+#define SECTION_SIZE		(1UL << SECTION_SHIFT)
+#define SECTION_MASK		(~(SECTION_SIZE-1))
+
+#ifndef __ASSEMBLY__
+
+/*
+ * The pgprot_* and protection_map entries will be fixed up in runtime
+ * to include the cachable bits based on memory policy, as well as any
+ * architecture dependent bits.
+ */
+#define _PTE_DEFAULT		(PTE_PRESENT | PTE_YOUNG | PTE_CACHEABLE)
+
+extern pgprot_t pgprot_user;
+extern pgprot_t pgprot_kernel;
+
+#define PAGE_NONE		pgprot_user
+#define PAGE_SHARED		__pgprot(pgprot_val(pgprot_user | PTE_READ \
+								| PTE_WRITE)
+#define PAGE_SHARED_EXEC	__pgprot(pgprot_val(pgprot_user | PTE_READ \
+								| PTE_WRITE \
+								| PTE_EXEC)
+#define PAGE_COPY		__pgprot(pgprot_val(pgprot_user | PTE_READ)
+#define PAGE_COPY_EXEC		__pgprot(pgprot_val(pgprot_user | PTE_READ \
+								| PTE_EXEC)
+#define PAGE_READONLY		__pgprot(pgprot_val(pgprot_user | PTE_READ)
+#define PAGE_READONLY_EXEC	__pgprot(pgprot_val(pgprot_user | PTE_READ \
+								| PTE_EXEC)
+#define PAGE_KERNEL		pgprot_kernel
+#define PAGE_KERNEL_EXEC	__pgprot(pgprot_val(pgprot_kernel | PTE_EXEC))
+
+#define __PAGE_NONE		__pgprot(_PTE_DEFAULT)
+#define __PAGE_SHARED		__pgprot(_PTE_DEFAULT | PTE_READ \
+							| PTE_WRITE)
+#define __PAGE_SHARED_EXEC	__pgprot(_PTE_DEFAULT | PTE_READ \
+							| PTE_WRITE \
+							| PTE_EXEC)
+#define __PAGE_COPY		__pgprot(_PTE_DEFAULT | PTE_READ)
+#define __PAGE_COPY_EXEC	__pgprot(_PTE_DEFAULT | PTE_READ \
+							| PTE_EXEC)
+#define __PAGE_READONLY		__pgprot(_PTE_DEFAULT | PTE_READ)
+#define __PAGE_READONLY_EXEC	__pgprot(_PTE_DEFAULT | PTE_READ \
+							| PTE_EXEC)
+
+#endif /* __ASSEMBLY__ */
+
+/*
+ * The table below defines the page protection levels that we insert into our
+ * Linux page table version.  These get translated into the best that the
+ * architecture can perform.  Note that on UniCore hardware:
+ *  1) We cannot do execute protection
+ *  2) If we could do execute protection, then read is implied
+ *  3) write implies read permissions
+ */
+#define __P000  __PAGE_NONE
+#define __P001  __PAGE_READONLY
+#define __P010  __PAGE_COPY
+#define __P011  __PAGE_COPY
+#define __P100  __PAGE_READONLY_EXEC
+#define __P101  __PAGE_READONLY_EXEC
+#define __P110  __PAGE_COPY_EXEC
+#define __P111  __PAGE_COPY_EXEC
+
+#define __S000  __PAGE_NONE
+#define __S001  __PAGE_READONLY
+#define __S010  __PAGE_SHARED
+#define __S011  __PAGE_SHARED
+#define __S100  __PAGE_READONLY_EXEC
+#define __S101  __PAGE_READONLY_EXEC
+#define __S110  __PAGE_SHARED_EXEC
+#define __S111  __PAGE_SHARED_EXEC
+
+#ifndef __ASSEMBLY__
+/*
+ * ZERO_PAGE is a global shared page that is always zero: used
+ * for zero-mapped memory areas etc..
+ */
+extern struct page *empty_zero_page;
+#define ZERO_PAGE(vaddr)		(empty_zero_page)
+
+#define pte_pfn(pte)			(pte_val(pte) >> PAGE_SHIFT)
+#define pfn_pte(pfn, prot)		(__pte(((pfn) << PAGE_SHIFT) \
+						| pgprot_val(prot)))
+
+#define pte_none(pte)			(!pte_val(pte))
+#define pte_clear(mm, addr, ptep)	set_pte(ptep, __pte(0))
+#define pte_page(pte)			(pfn_to_page(pte_pfn(pte)))
+#define pte_offset_kernel(dir, addr)	(pmd_page_vaddr(*(dir)) \
+						+ __pte_index(addr))
+
+#define pte_offset_map(dir, addr)	(pmd_page_vaddr(*(dir)) \
+						+ __pte_index(addr))
+#define pte_unmap(pte)			do { } while (0)
+
+#define set_pte(ptep, pte)	cpu_set_pte(ptep, pte)
+
+#define set_pte_at(mm, addr, ptep, pteval)	\
+	do {					\
+		set_pte(ptep, pteval);          \
+	} while (0)
+
+/*
+ * The following only work if pte_present() is true.
+ * Undefined behaviour if not..
+ */
+#define pte_present(pte)	(pte_val(pte) & PTE_PRESENT)
+#define pte_write(pte)		(pte_val(pte) & PTE_WRITE)
+#define pte_dirty(pte)		(pte_val(pte) & PTE_DIRTY)
+#define pte_young(pte)		(pte_val(pte) & PTE_YOUNG)
+#define pte_exec(pte)		(pte_val(pte) & PTE_EXEC)
+#define pte_special(pte)	(0)
+
+#define PTE_BIT_FUNC(fn, op) \
+static inline pte_t pte_##fn(pte_t pte) { pte_val(pte) op; return pte; }
+
+PTE_BIT_FUNC(wrprotect, &= ~PTE_WRITE);
+PTE_BIT_FUNC(mkwrite,   |= PTE_WRITE);
+PTE_BIT_FUNC(mkclean,   &= ~PTE_DIRTY);
+PTE_BIT_FUNC(mkdirty,   |= PTE_DIRTY);
+PTE_BIT_FUNC(mkold,     &= ~PTE_YOUNG);
+PTE_BIT_FUNC(mkyoung,   |= PTE_YOUNG);
+
+static inline pte_t pte_mkspecial(pte_t pte) { return pte; }
+
+/*
+ * Mark the prot value as uncacheable.
+ */
+#define pgprot_noncached(prot)		\
+	__pgprot(pgprot_val(prot) & ~PTE_CACHEABLE)
+#define pgprot_writecombine(prot)	\
+	__pgprot(pgprot_val(prot) & ~PTE_CACHEABLE)
+#define pgprot_dmacoherent(prot)	\
+	__pgprot(pgprot_val(prot) & ~PTE_CACHEABLE)
+
+#define pmd_none(pmd)		(!pmd_val(pmd))
+#define pmd_present(pmd)	(pmd_val(pmd) & PMD_PRESENT)
+#define pmd_bad(pmd)		(((pmd_val(pmd) &		\
+				(PMD_PRESENT | PMD_TYPE_MASK))	\
+				!= (PMD_PRESENT | PMD_TYPE_TABLE)))
+
+#define set_pmd(pmdpd, pmdval)		\
+	do {				\
+		*(pmdpd) = pmdval;	\
+	} while (0)
+
+#define pmd_clear(pmdp)			\
+	do {				\
+		set_pmd(pmdp, __pmd(0));\
+		clean_pmd_entry(pmdp);	\
+	} while (0)
+
+#define pmd_page_vaddr(pmd) ((pte_t *)__va(pmd_val(pmd) & PAGE_MASK))
+#define pmd_page(pmd)		pfn_to_page(__phys_to_pfn(pmd_val(pmd)))
+
+/*
+ * Conversion functions: convert a page and protection to a page entry,
+ * and a page entry and page directory to the page they refer to.
+ */
+#define mk_pte(page, prot)	pfn_pte(page_to_pfn(page), prot)
+
+/* to find an entry in a page-table-directory */
+#define pgd_index(addr)		((addr) >> PGDIR_SHIFT)
+
+#define pgd_offset(mm, addr)	((mm)->pgd+pgd_index(addr))
+
+/* to find an entry in a kernel page-table-directory */
+#define pgd_offset_k(addr)	pgd_offset(&init_mm, addr)
+
+/* Find an entry in the third-level page table.. */
+#define __pte_index(addr)	(((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
+
+static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
+{
+	const unsigned long mask = PTE_EXEC | PTE_WRITE | PTE_READ;
+	pte_val(pte) = (pte_val(pte) & ~mask) | (pgprot_val(newprot) & mask);
+	return pte;
+}
+
+extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
+
+/*
+ * Encode and decode a swap entry.  Swap entries are stored in the Linux
+ * page tables as follows:
+ *
+ *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
+ *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
+ *   <--------------- offset --------------> <--- type --> 0 0 0 0 0
+ *
+ * This gives us up to 127 swap files and 32GB per swap file.  Note that
+ * the offset field is always non-zero.
+ */
+#define __SWP_TYPE_SHIFT	5
+#define __SWP_TYPE_BITS		7
+#define __SWP_TYPE_MASK		((1 << __SWP_TYPE_BITS) - 1)
+#define __SWP_OFFSET_SHIFT	(__SWP_TYPE_BITS + __SWP_TYPE_SHIFT)
+
+#define __swp_type(x)		(((x).val >> __SWP_TYPE_SHIFT)		\
+				& __SWP_TYPE_MASK)
+#define __swp_offset(x)		((x).val >> __SWP_OFFSET_SHIFT)
+#define __swp_entry(type, offset) ((swp_entry_t) {			\
+				((type) << __SWP_TYPE_SHIFT) |		\
+				((offset) << __SWP_OFFSET_SHIFT) })
+
+#define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
+#define __swp_entry_to_pte(swp)	((pte_t) { (swp).val })
+
+/*
+ * It is an error for the kernel to have more swap files than we can
+ * encode in the PTEs.  This ensures that we know when MAX_SWAPFILES
+ * is increased beyond what we presently support.
+ */
+#define MAX_SWAPFILES_CHECK()	\
+	BUILD_BUG_ON(MAX_SWAPFILES_SHIFT > __SWP_TYPE_BITS)
+
+/*
+ * Encode and decode a file entry.  File entries are stored in the Linux
+ * page tables as follows:
+ *
+ *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
+ *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
+ *   <----------------------- offset ----------------------> 1 0 0 0
+ */
+#define pte_file(pte)		(pte_val(pte) & PTE_FILE)
+#define pte_to_pgoff(x)		(pte_val(x) >> 4)
+#define pgoff_to_pte(x)		__pte(((x) << 4) | PTE_FILE)
+
+#define PTE_FILE_MAX_BITS	28
+
+/* Needs to be defined here and not in linux/mm.h, as it is arch dependent */
+/* FIXME: this is not correct */
+#define kern_addr_valid(addr)	(1)
+
+#include <asm-generic/pgtable.h>
+
+/*
+ * remap a physical page `pfn' of size `size' with page protection `prot'
+ * into virtual address `from'
+ */
+#define io_remap_pfn_range(vma, from, pfn, size, prot)	\
+		remap_pfn_range(vma, from, pfn, size, prot)
+
+#define pgtable_cache_init() do { } while (0)
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* __UNICORE_PGTABLE_H__ */
diff --git a/arch/unicore32/mm/alignment.c b/arch/unicore32/mm/alignment.c
new file mode 100644
index 0000000..28f576d
--- /dev/null
+++ b/arch/unicore32/mm/alignment.c
@@ -0,0 +1,523 @@
+/*
+ * linux/arch/unicore32/mm/alignment.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+/*
+ * TODO:
+ *  FPU ldm/stm not handling
+ */
+#include <linux/compiler.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+
+#include <asm/tlbflush.h>
+#include <asm/unaligned.h>
+
+#define CODING_BITS(i)	(i & 0xe0000120)
+
+#define LDST_P_BIT(i)	(i & (1 << 28))	/* Preindex             */
+#define LDST_U_BIT(i)	(i & (1 << 27))	/* Add offset           */
+#define LDST_W_BIT(i)	(i & (1 << 25))	/* Writeback            */
+#define LDST_L_BIT(i)	(i & (1 << 24))	/* Load                 */
+
+#define LDST_P_EQ_U(i)	((((i) ^ ((i) >> 1)) & (1 << 27)) == 0)
+
+#define LDSTH_I_BIT(i)	(i & (1 << 26))	/* half-word immed      */
+#define LDM_S_BIT(i)	(i & (1 << 26))	/* write ASR from BSR */
+#define LDM_H_BIT(i)	(i & (1 << 6))	/* select r0-r15 or r16-r31 */
+
+#define RN_BITS(i)	((i >> 19) & 31)	/* Rn                   */
+#define RD_BITS(i)	((i >> 14) & 31)	/* Rd                   */
+#define RM_BITS(i)	(i & 31)	/* Rm                   */
+
+#define REGMASK_BITS(i)	(((i & 0x7fe00) >> 3) | (i & 0x3f))
+#define OFFSET_BITS(i)	(i & 0x03fff)
+
+#define SHIFT_BITS(i)	((i >> 9) & 0x1f)
+#define SHIFT_TYPE(i)	(i & 0xc0)
+#define SHIFT_LSL	0x00
+#define SHIFT_LSR	0x40
+#define SHIFT_ASR	0x80
+#define SHIFT_RORRRX	0xc0
+
+union offset_union {
+	unsigned long un;
+	signed long sn;
+};
+
+#define TYPE_ERROR	0
+#define TYPE_FAULT	1
+#define TYPE_LDST	2
+#define TYPE_DONE	3
+#define TYPE_SWAP  4
+#define TYPE_COLS  5		/* Coprocessor load/store */
+
+#define get8_unaligned_check(val, addr, err)		\
+	__asm__(					\
+	"1:	ldb.u	%1, [%2], #1\n"			\
+	"2:\n"						\
+	"	.pushsection .fixup,\"ax\"\n"		\
+	"	.align	2\n"				\
+	"3:	mov	%0, #1\n"			\
+	"	b	2b\n"				\
+	"	.popsection\n"				\
+	"	.pushsection __ex_table,\"a\"\n"		\
+	"	.align	3\n"				\
+	"	.long	1b, 3b\n"			\
+	"	.popsection\n"				\
+	: "=r" (err), "=&r" (val), "=r" (addr)		\
+	: "0" (err), "2" (addr))
+
+#define get8t_unaligned_check(val, addr, err)		\
+	__asm__(					\
+	"1:	ldb.u	%1, [%2], #1\n"			\
+	"2:\n"						\
+	"	.pushsection .fixup,\"ax\"\n"		\
+	"	.align	2\n"				\
+	"3:	mov	%0, #1\n"			\
+	"	b	2b\n"				\
+	"	.popsection\n"				\
+	"	.pushsection __ex_table,\"a\"\n"		\
+	"	.align	3\n"				\
+	"	.long	1b, 3b\n"			\
+	"	.popsection\n"				\
+	: "=r" (err), "=&r" (val), "=r" (addr)		\
+	: "0" (err), "2" (addr))
+
+#define get16_unaligned_check(val, addr)			\
+	do {							\
+		unsigned int err = 0, v, a = addr;		\
+		get8_unaligned_check(val, a, err);		\
+		get8_unaligned_check(v, a, err);		\
+		val |= v << 8;					\
+		if (err)					\
+			goto fault;				\
+	} while (0)
+
+#define put16_unaligned_check(val, addr)			\
+	do {							\
+		unsigned int err = 0, v = val, a = addr;	\
+		__asm__(					\
+		"1:	stb.u	%1, [%2], #1\n"			\
+		"	mov	%1, %1 >> #8\n"			\
+		"2:	stb.u	%1, [%2]\n"			\
+		"3:\n"						\
+		"	.pushsection .fixup,\"ax\"\n"		\
+		"	.align	2\n"				\
+		"4:	mov	%0, #1\n"			\
+		"	b	3b\n"				\
+		"	.popsection\n"				\
+		"	.pushsection __ex_table,\"a\"\n"		\
+		"	.align	3\n"				\
+		"	.long	1b, 4b\n"			\
+		"	.long	2b, 4b\n"			\
+		"	.popsection\n"				\
+		: "=r" (err), "=&r" (v), "=&r" (a)		\
+		: "0" (err), "1" (v), "2" (a));			\
+		if (err)					\
+			goto fault;				\
+	} while (0)
+
+#define __put32_unaligned_check(ins, val, addr)			\
+	do {							\
+		unsigned int err = 0, v = val, a = addr;	\
+		__asm__(					\
+		"1:	"ins"	%1, [%2], #1\n"			\
+		"	mov	%1, %1 >> #8\n"			\
+		"2:	"ins"	%1, [%2], #1\n"			\
+		"	mov	%1, %1 >> #8\n"			\
+		"3:	"ins"	%1, [%2], #1\n"			\
+		"	mov	%1, %1 >> #8\n"			\
+		"4:	"ins"	%1, [%2]\n"			\
+		"5:\n"						\
+		"	.pushsection .fixup,\"ax\"\n"		\
+		"	.align	2\n"				\
+		"6:	mov	%0, #1\n"			\
+		"	b	5b\n"				\
+		"	.popsection\n"				\
+		"	.pushsection __ex_table,\"a\"\n"		\
+		"	.align	3\n"				\
+		"	.long	1b, 6b\n"			\
+		"	.long	2b, 6b\n"			\
+		"	.long	3b, 6b\n"			\
+		"	.long	4b, 6b\n"			\
+		"	.popsection\n"				\
+		: "=r" (err), "=&r" (v), "=&r" (a)		\
+		: "0" (err), "1" (v), "2" (a));			\
+		if (err)					\
+			goto fault;				\
+	} while (0)
+
+#define get32_unaligned_check(val, addr)			\
+	do {							\
+		unsigned int err = 0, v, a = addr;		\
+		get8_unaligned_check(val, a, err);		\
+		get8_unaligned_check(v, a, err);		\
+		val |= v << 8;					\
+		get8_unaligned_check(v, a, err);		\
+		val |= v << 16;					\
+		get8_unaligned_check(v, a, err);		\
+		val |= v << 24;					\
+		if (err)					\
+			goto fault;				\
+	} while (0)
+
+#define put32_unaligned_check(val, addr)			\
+	__put32_unaligned_check("stb.u", val, addr)
+
+#define get32t_unaligned_check(val, addr)			\
+	do {							\
+		unsigned int err = 0, v, a = addr;		\
+		get8t_unaligned_check(val, a, err);		\
+		get8t_unaligned_check(v, a, err);		\
+		val |= v << 8;					\
+		get8t_unaligned_check(v, a, err);		\
+		val |= v << 16;					\
+		get8t_unaligned_check(v, a, err);		\
+		val |= v << 24;					\
+		if (err)					\
+			goto fault;				\
+	} while (0)
+
+#define put32t_unaligned_check(val, addr)			\
+	__put32_unaligned_check("stb.u", val, addr)
+
+static void
+do_alignment_finish_ldst(unsigned long addr, unsigned long instr,
+			 struct pt_regs *regs, union offset_union offset)
+{
+	if (!LDST_U_BIT(instr))
+		offset.un = -offset.un;
+
+	if (!LDST_P_BIT(instr))
+		addr += offset.un;
+
+	if (!LDST_P_BIT(instr) || LDST_W_BIT(instr))
+		regs->uregs[RN_BITS(instr)] = addr;
+}
+
+static int
+do_alignment_ldrhstrh(unsigned long addr, unsigned long instr,
+		      struct pt_regs *regs)
+{
+	unsigned int rd = RD_BITS(instr);
+
+	/* old value 0x40002120, can't judge swap instr correctly */
+	if ((instr & 0x4b003fe0) == 0x40000120)
+		goto swp;
+
+	if (LDST_L_BIT(instr)) {
+		unsigned long val;
+		get16_unaligned_check(val, addr);
+
+		/* signed half-word? */
+		if (instr & 0x80)
+			val = (signed long)((signed short)val);
+
+		regs->uregs[rd] = val;
+	} else
+		put16_unaligned_check(regs->uregs[rd], addr);
+
+	return TYPE_LDST;
+
+swp:
+	/* only handle swap word
+	 * for swap byte should not active this alignment exception */
+	get32_unaligned_check(regs->uregs[RD_BITS(instr)], addr);
+	put32_unaligned_check(regs->uregs[RM_BITS(instr)], addr);
+	return TYPE_SWAP;
+
+fault:
+	return TYPE_FAULT;
+}
+
+static int
+do_alignment_ldrstr(unsigned long addr, unsigned long instr,
+		    struct pt_regs *regs)
+{
+	unsigned int rd = RD_BITS(instr);
+
+	if (!LDST_P_BIT(instr) && LDST_W_BIT(instr))
+		goto trans;
+
+	if (LDST_L_BIT(instr))
+		get32_unaligned_check(regs->uregs[rd], addr);
+	else
+		put32_unaligned_check(regs->uregs[rd], addr);
+	return TYPE_LDST;
+
+trans:
+	if (LDST_L_BIT(instr))
+		get32t_unaligned_check(regs->uregs[rd], addr);
+	else
+		put32t_unaligned_check(regs->uregs[rd], addr);
+	return TYPE_LDST;
+
+fault:
+	return TYPE_FAULT;
+}
+
+/*
+ * LDM/STM alignment handler.
+ *
+ * There are 4 variants of this instruction:
+ *
+ * B = rn pointer before instruction, A = rn pointer after instruction
+ *              ------ increasing address ----->
+ *	        |    | r0 | r1 | ... | rx |    |
+ * PU = 01             B                    A
+ * PU = 11        B                    A
+ * PU = 00        A                    B
+ * PU = 10             A                    B
+ */
+static int
+do_alignment_ldmstm(unsigned long addr, unsigned long instr,
+		    struct pt_regs *regs)
+{
+	unsigned int rd, rn, pc_correction, reg_correction, nr_regs, regbits;
+	unsigned long eaddr, newaddr;
+
+	if (LDM_S_BIT(instr))
+		goto bad;
+
+	pc_correction = 4;	/* processor implementation defined */
+
+	/* count the number of registers in the mask to be transferred */
+	nr_regs = hweight16(REGMASK_BITS(instr)) * 4;
+
+	rn = RN_BITS(instr);
+	newaddr = eaddr = regs->uregs[rn];
+
+	if (!LDST_U_BIT(instr))
+		nr_regs = -nr_regs;
+	newaddr += nr_regs;
+	if (!LDST_U_BIT(instr))
+		eaddr = newaddr;
+
+	if (LDST_P_EQ_U(instr))	/* U = P */
+		eaddr += 4;
+
+	/*
+	 * This is a "hint" - we already have eaddr worked out by the
+	 * processor for us.
+	 */
+	if (addr != eaddr) {
+		printk(KERN_ERR "LDMSTM: PC = %08lx, instr = %08lx, "
+		       "addr = %08lx, eaddr = %08lx\n",
+		       instruction_pointer(regs), instr, addr, eaddr);
+		show_regs(regs);
+	}
+
+	if (LDM_H_BIT(instr))
+		reg_correction = 0x10;
+	else
+		reg_correction = 0x00;
+
+	for (regbits = REGMASK_BITS(instr), rd = 0; regbits;
+	     regbits >>= 1, rd += 1)
+		if (regbits & 1) {
+			if (LDST_L_BIT(instr))
+				get32_unaligned_check(regs->
+					uregs[rd + reg_correction], eaddr);
+			else
+				put32_unaligned_check(regs->
+					uregs[rd + reg_correction], eaddr);
+			eaddr += 4;
+		}
+
+	if (LDST_W_BIT(instr))
+		regs->uregs[rn] = newaddr;
+	return TYPE_DONE;
+
+fault:
+	regs->UCreg_pc -= pc_correction;
+	return TYPE_FAULT;
+
+bad:
+	printk(KERN_ERR "Alignment trap: not handling ldm with s-bit set\n");
+	return TYPE_ERROR;
+}
+
+static int
+do_alignment(unsigned long addr, unsigned int error_code, struct pt_regs *regs)
+{
+	union offset_union offset;
+	unsigned long instr, instrptr;
+	int (*handler) (unsigned long addr, unsigned long instr,
+			struct pt_regs *regs);
+	unsigned int type;
+
+	instrptr = instruction_pointer(regs);
+	if (instrptr >= PAGE_OFFSET)
+		instr = *(unsigned long *)instrptr;
+	else {
+		__asm__ __volatile__(
+				"ldw.u	%0, [%1]\n"
+				: "=&r"(instr)
+				: "r"(instrptr));
+	}
+
+	regs->UCreg_pc += 4;
+
+	switch (CODING_BITS(instr)) {
+	case 0x40000120:	/* ldrh or strh */
+		if (LDSTH_I_BIT(instr))
+			offset.un = (instr & 0x3e00) >> 4 | (instr & 31);
+		else
+			offset.un = regs->uregs[RM_BITS(instr)];
+		handler = do_alignment_ldrhstrh;
+		break;
+
+	case 0x60000000:	/* ldr or str immediate */
+	case 0x60000100:	/* ldr or str immediate */
+	case 0x60000020:	/* ldr or str immediate */
+	case 0x60000120:	/* ldr or str immediate */
+		offset.un = OFFSET_BITS(instr);
+		handler = do_alignment_ldrstr;
+		break;
+
+	case 0x40000000:	/* ldr or str register */
+		offset.un = regs->uregs[RM_BITS(instr)];
+		{
+			unsigned int shiftval = SHIFT_BITS(instr);
+
+			switch (SHIFT_TYPE(instr)) {
+			case SHIFT_LSL:
+				offset.un <<= shiftval;
+				break;
+
+			case SHIFT_LSR:
+				offset.un >>= shiftval;
+				break;
+
+			case SHIFT_ASR:
+				offset.sn >>= shiftval;
+				break;
+
+			case SHIFT_RORRRX:
+				if (shiftval == 0) {
+					offset.un >>= 1;
+					if (regs->UCreg_asr & PSR_C_BIT)
+						offset.un |= 1 << 31;
+				} else
+					offset.un = offset.un >> shiftval |
+					    offset.un << (32 - shiftval);
+				break;
+			}
+		}
+		handler = do_alignment_ldrstr;
+		break;
+
+	case 0x80000000:	/* ldm or stm */
+	case 0x80000020:	/* ldm or stm */
+		handler = do_alignment_ldmstm;
+		break;
+
+	default:
+		goto bad;
+	}
+
+	type = handler(addr, instr, regs);
+
+	if (type == TYPE_ERROR || type == TYPE_FAULT)
+		goto bad_or_fault;
+
+	if (type == TYPE_LDST)
+		do_alignment_finish_ldst(addr, instr, regs, offset);
+
+	return 0;
+
+bad_or_fault:
+	if (type == TYPE_ERROR)
+		goto bad;
+	regs->UCreg_pc -= 4;
+	/*
+	 * We got a fault - fix it up, or die.
+	 */
+	do_bad_area(addr, error_code, regs);
+	return 0;
+
+bad:
+	/*
+	 * Oops, we didn't handle the instruction.
+	 * However, we must handle fpu instr firstly.
+	 */
+#ifdef CONFIG_UNICORE_FPU_F64
+	/* handle co.load/store */
+#define CODING_COLS                0xc0000000
+#define COLS_OFFSET_BITS(i)	(i & 0x1FF)
+#define COLS_L_BITS(i)		(i & (1<<24))
+#define COLS_FN_BITS(i)		((i>>14) & 31)
+	if ((instr & 0xe0000000) == CODING_COLS) {
+		unsigned int fn = COLS_FN_BITS(instr);
+		unsigned long val = 0;
+		if (COLS_L_BITS(instr)) {
+			get32t_unaligned_check(val, addr);
+			switch (fn) {
+#define ASM_MTF(n)	case n:						\
+			__asm__ __volatile__("MTF %0, F" __stringify(n)	\
+				: : "r"(val));				\
+			break;
+			ASM_MTF(0); ASM_MTF(1); ASM_MTF(2); ASM_MTF(3);
+			ASM_MTF(4); ASM_MTF(5); ASM_MTF(6); ASM_MTF(7);
+			ASM_MTF(8); ASM_MTF(9); ASM_MTF(10); ASM_MTF(11);
+			ASM_MTF(12); ASM_MTF(13); ASM_MTF(14); ASM_MTF(15);
+			ASM_MTF(16); ASM_MTF(17); ASM_MTF(18); ASM_MTF(19);
+			ASM_MTF(20); ASM_MTF(21); ASM_MTF(22); ASM_MTF(23);
+			ASM_MTF(24); ASM_MTF(25); ASM_MTF(26); ASM_MTF(27);
+			ASM_MTF(28); ASM_MTF(29); ASM_MTF(30); ASM_MTF(31);
+#undef ASM_MTF
+			}
+		} else {
+			switch (fn) {
+#define ASM_MFF(n)	case n:						\
+			__asm__ __volatile__("MFF %0, F" __stringify(n)	\
+				: : "r"(val));				\
+			break;
+			ASM_MFF(0); ASM_MFF(1); ASM_MFF(2); ASM_MFF(3);
+			ASM_MFF(4); ASM_MFF(5); ASM_MFF(6); ASM_MFF(7);
+			ASM_MFF(8); ASM_MFF(9); ASM_MFF(10); ASM_MFF(11);
+			ASM_MFF(12); ASM_MFF(13); ASM_MFF(14); ASM_MFF(15);
+			ASM_MFF(16); ASM_MFF(17); ASM_MFF(18); ASM_MFF(19);
+			ASM_MFF(20); ASM_MFF(21); ASM_MFF(22); ASM_MFF(23);
+			ASM_MFF(24); ASM_MFF(25); ASM_MFF(26); ASM_MFF(27);
+			ASM_MFF(28); ASM_MFF(29); ASM_MFF(30); ASM_MFF(31);
+#undef ASM_MFF
+			}
+			put32t_unaligned_check(val, addr);
+		}
+		return TYPE_COLS;
+	}
+fault:
+	return TYPE_FAULT;
+#endif
+	printk(KERN_ERR "Alignment trap: not handling instruction "
+	       "%08lx at [<%08lx>]\n", instr, instrptr);
+	return 1;
+}
+
+/*
+ * This needs to be done after sysctl_init, otherwise sys/ will be
+ * overwritten.  Actually, this shouldn't be in sys/ at all since
+ * it isn't a sysctl, and it doesn't contain sysctl information.
+ */
+static int __init alignment_init(void)
+{
+	hook_fault_code(1, do_alignment, SIGBUS, BUS_ADRALN,
+			"alignment exception");
+
+	return 0;
+}
+
+fs_initcall(alignment_init);
diff --git a/arch/unicore32/mm/extable.c b/arch/unicore32/mm/extable.c
new file mode 100644
index 0000000..6564180
--- /dev/null
+++ b/arch/unicore32/mm/extable.c
@@ -0,0 +1,24 @@
+/*
+ * linux/arch/unicore32/mm/extable.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/uaccess.h>
+
+int fixup_exception(struct pt_regs *regs)
+{
+	const struct exception_table_entry *fixup;
+
+	fixup = search_exception_tables(instruction_pointer(regs));
+	if (fixup)
+		regs->UCreg_pc = fixup->fixup;
+
+	return fixup != NULL;
+}
diff --git a/arch/unicore32/mm/fault.c b/arch/unicore32/mm/fault.c
new file mode 100644
index 0000000..283aa4b
--- /dev/null
+++ b/arch/unicore32/mm/fault.c
@@ -0,0 +1,479 @@
+/*
+ * linux/arch/unicore32/mm/fault.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/signal.h>
+#include <linux/mm.h>
+#include <linux/hardirq.h>
+#include <linux/init.h>
+#include <linux/kprobes.h>
+#include <linux/uaccess.h>
+#include <linux/page-flags.h>
+#include <linux/sched.h>
+#include <linux/io.h>
+
+#include <asm/system.h>
+#include <asm/pgtable.h>
+#include <asm/tlbflush.h>
+
+/*
+ * Fault status register encodings.  We steal bit 31 for our own purposes.
+ */
+#define FSR_LNX_PF		(1 << 31)
+
+static inline int fsr_fs(unsigned int fsr)
+{
+	/* xyabcde will be abcde+xy */
+	return (fsr & 31) + ((fsr & (3 << 5)) >> 5);
+}
+
+/*
+ * This is useful to dump out the page tables associated with
+ * 'addr' in mm 'mm'.
+ */
+void show_pte(struct mm_struct *mm, unsigned long addr)
+{
+	pgd_t *pgd;
+
+	if (!mm)
+		mm = &init_mm;
+
+	printk(KERN_ALERT "pgd = %p\n", mm->pgd);
+	pgd = pgd_offset(mm, addr);
+	printk(KERN_ALERT "[%08lx] *pgd=%08lx", addr, pgd_val(*pgd));
+
+	do {
+		pmd_t *pmd;
+		pte_t *pte;
+
+		if (pgd_none(*pgd))
+			break;
+
+		if (pgd_bad(*pgd)) {
+			printk("(bad)");
+			break;
+		}
+
+		pmd = pmd_offset((pud_t *) pgd, addr);
+		if (PTRS_PER_PMD != 1)
+			printk(", *pmd=%08lx", pmd_val(*pmd));
+
+		if (pmd_none(*pmd))
+			break;
+
+		if (pmd_bad(*pmd)) {
+			printk("(bad)");
+			break;
+		}
+
+		/* We must not map this if we have highmem enabled */
+		if (PageHighMem(pfn_to_page(pmd_val(*pmd) >> PAGE_SHIFT)))
+			break;
+
+		pte = pte_offset_map(pmd, addr);
+		printk(", *pte=%08lx", pte_val(*pte));
+		pte_unmap(pte);
+	} while (0);
+
+	printk("\n");
+}
+
+/*
+ * Oops.  The kernel tried to access some page that wasn't present.
+ */
+static void __do_kernel_fault(struct mm_struct *mm, unsigned long addr,
+		unsigned int fsr, struct pt_regs *regs)
+{
+	/*
+	 * Are we prepared to handle this kernel fault?
+	 */
+	if (fixup_exception(regs))
+		return;
+
+	/*
+	 * No handler, we'll have to terminate things with extreme prejudice.
+	 */
+	bust_spinlocks(1);
+	printk(KERN_ALERT
+	       "Unable to handle kernel %s at virtual address %08lx\n",
+	       (addr < PAGE_SIZE) ? "NULL pointer dereference" :
+	       "paging request", addr);
+
+	show_pte(mm, addr);
+	die("Oops", regs, fsr);
+	bust_spinlocks(0);
+	do_exit(SIGKILL);
+}
+
+/*
+ * Something tried to access memory that isn't in our memory map..
+ * User mode accesses just cause a SIGSEGV
+ */
+static void __do_user_fault(struct task_struct *tsk, unsigned long addr,
+		unsigned int fsr, unsigned int sig, int code,
+		struct pt_regs *regs)
+{
+	struct siginfo si;
+
+	tsk->thread.address = addr;
+	tsk->thread.error_code = fsr;
+	tsk->thread.trap_no = 14;
+	si.si_signo = sig;
+	si.si_errno = 0;
+	si.si_code = code;
+	si.si_addr = (void __user *)addr;
+	force_sig_info(sig, &si, tsk);
+}
+
+void do_bad_area(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
+{
+	struct task_struct *tsk = current;
+	struct mm_struct *mm = tsk->active_mm;
+
+	/*
+	 * If we are in kernel mode at this point, we
+	 * have no context to handle this fault with.
+	 */
+	if (user_mode(regs))
+		__do_user_fault(tsk, addr, fsr, SIGSEGV, SEGV_MAPERR, regs);
+	else
+		__do_kernel_fault(mm, addr, fsr, regs);
+}
+
+#define VM_FAULT_BADMAP		0x010000
+#define VM_FAULT_BADACCESS	0x020000
+
+/*
+ * Check that the permissions on the VMA allow for the fault which occurred.
+ * If we encountered a write fault, we must have write permission, otherwise
+ * we allow any permission.
+ */
+static inline bool access_error(unsigned int fsr, struct vm_area_struct *vma)
+{
+	unsigned int mask = VM_READ | VM_WRITE | VM_EXEC;
+
+	if (!(fsr ^ 0x12))	/* write? */
+		mask = VM_WRITE;
+	if (fsr & FSR_LNX_PF)
+		mask = VM_EXEC;
+
+	return vma->vm_flags & mask ? false : true;
+}
+
+static int __do_pf(struct mm_struct *mm, unsigned long addr, unsigned int fsr,
+		struct task_struct *tsk)
+{
+	struct vm_area_struct *vma;
+	int fault;
+
+	vma = find_vma(mm, addr);
+	fault = VM_FAULT_BADMAP;
+	if (unlikely(!vma))
+		goto out;
+	if (unlikely(vma->vm_start > addr))
+		goto check_stack;
+
+	/*
+	 * Ok, we have a good vm_area for this
+	 * memory access, so we can handle it.
+	 */
+good_area:
+	if (access_error(fsr, vma)) {
+		fault = VM_FAULT_BADACCESS;
+		goto out;
+	}
+
+	/*
+	 * If for any reason at all we couldn't handle the fault, make
+	 * sure we exit gracefully rather than endlessly redo the fault.
+	 */
+	fault = handle_mm_fault(mm, vma, addr & PAGE_MASK,
+			    (!(fsr ^ 0x12)) ? FAULT_FLAG_WRITE : 0);
+	if (unlikely(fault & VM_FAULT_ERROR))
+		return fault;
+	if (fault & VM_FAULT_MAJOR)
+		tsk->maj_flt++;
+	else
+		tsk->min_flt++;
+	return fault;
+
+check_stack:
+	if (vma->vm_flags & VM_GROWSDOWN && !expand_stack(vma, addr))
+		goto good_area;
+out:
+	return fault;
+}
+
+static int do_pf(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
+{
+	struct task_struct *tsk;
+	struct mm_struct *mm;
+	int fault, sig, code;
+
+	tsk = current;
+	mm = tsk->mm;
+
+	/*
+	 * If we're in an interrupt or have no user
+	 * context, we must not take the fault..
+	 */
+	if (in_atomic() || !mm)
+		goto no_context;
+
+	/*
+	 * As per x86, we may deadlock here.  However, since the kernel only
+	 * validly references user space from well defined areas of the code,
+	 * we can bug out early if this is from code which shouldn't.
+	 */
+	if (!down_read_trylock(&mm->mmap_sem)) {
+		if (!user_mode(regs)
+		    && !search_exception_tables(regs->UCreg_pc))
+			goto no_context;
+		down_read(&mm->mmap_sem);
+	} else {
+		/*
+		 * The above down_read_trylock() might have succeeded in
+		 * which case, we'll have missed the might_sleep() from
+		 * down_read()
+		 */
+		might_sleep();
+#ifdef CONFIG_DEBUG_VM
+		if (!user_mode(regs) &&
+		    !search_exception_tables(regs->UCreg_pc))
+			goto no_context;
+#endif
+	}
+
+	fault = __do_pf(mm, addr, fsr, tsk);
+	up_read(&mm->mmap_sem);
+
+	/*
+	 * Handle the "normal" case first - VM_FAULT_MAJOR / VM_FAULT_MINOR
+	 */
+	if (likely(!(fault &
+	       (VM_FAULT_ERROR | VM_FAULT_BADMAP | VM_FAULT_BADACCESS))))
+		return 0;
+
+	if (fault & VM_FAULT_OOM) {
+		/*
+		 * We ran out of memory, call the OOM killer, and return to
+		 * userspace (which will retry the fault, or kill us if we
+		 * got oom-killed)
+		 */
+		pagefault_out_of_memory();
+		return 0;
+	}
+
+	/*
+	 * If we are in kernel mode at this point, we
+	 * have no context to handle this fault with.
+	 */
+	if (!user_mode(regs))
+		goto no_context;
+
+	if (fault & VM_FAULT_SIGBUS) {
+		/*
+		 * We had some memory, but were unable to
+		 * successfully fix up this page fault.
+		 */
+		sig = SIGBUS;
+		code = BUS_ADRERR;
+	} else {
+		/*
+		 * Something tried to access memory that
+		 * isn't in our memory map..
+		 */
+		sig = SIGSEGV;
+		code = fault == VM_FAULT_BADACCESS ? SEGV_ACCERR : SEGV_MAPERR;
+	}
+
+	__do_user_fault(tsk, addr, fsr, sig, code, regs);
+	return 0;
+
+no_context:
+	__do_kernel_fault(mm, addr, fsr, regs);
+	return 0;
+}
+
+/*
+ * First Level Translation Fault Handler
+ *
+ * We enter here because the first level page table doesn't contain
+ * a valid entry for the address.
+ *
+ * If the address is in kernel space (>= TASK_SIZE), then we are
+ * probably faulting in the vmalloc() area.
+ *
+ * If the init_task's first level page tables contains the relevant
+ * entry, we copy the it to this task.  If not, we send the process
+ * a signal, fixup the exception, or oops the kernel.
+ *
+ * NOTE! We MUST NOT take any locks for this case. We may be in an
+ * interrupt or a critical region, and should only copy the information
+ * from the master page table, nothing more.
+ */
+static int do_ifault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
+{
+	unsigned int index;
+	pgd_t *pgd, *pgd_k;
+	pmd_t *pmd, *pmd_k;
+
+	if (addr < TASK_SIZE)
+		return do_pf(addr, fsr, regs);
+
+	if (user_mode(regs))
+		goto bad_area;
+
+	index = pgd_index(addr);
+
+	pgd = cpu_get_pgd() + index;
+	pgd_k = init_mm.pgd + index;
+
+	if (pgd_none(*pgd_k))
+		goto bad_area;
+
+	pmd_k = pmd_offset((pud_t *) pgd_k, addr);
+	pmd = pmd_offset((pud_t *) pgd, addr);
+
+	if (pmd_none(*pmd_k))
+		goto bad_area;
+
+	set_pmd(pmd, *pmd_k);
+	flush_pmd_entry(pmd);
+	return 0;
+
+bad_area:
+	do_bad_area(addr, fsr, regs);
+	return 0;
+}
+
+/*
+ * This abort handler always returns "fault".
+ */
+static int do_bad(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
+{
+	return 1;
+}
+
+static int do_good(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
+{
+	unsigned int res1, res2;
+
+	printk("dabt exception but no error!\n");
+
+	__asm__ __volatile__(
+			"mff %0,f0\n"
+			"mff %1,f1\n"
+			: "=r"(res1), "=r"(res2)
+			:
+			: "memory");
+
+	printk(KERN_EMERG "r0 :%08x  r1 :%08x\n", res1, res2);
+	panic("shut up\n");
+	return 0;
+}
+
+static struct fsr_info {
+	int (*fn) (unsigned long addr, unsigned int fsr, struct pt_regs *regs);
+	int sig;
+	int code;
+	const char *name;
+} fsr_info[] = {
+	/*
+	 * The following are the standard Unicore-I and UniCore-II aborts.
+	 */
+	{ do_good,	SIGBUS,  0,		"no error"		},
+	{ do_bad,	SIGBUS,  BUS_ADRALN,	"alignment exception"	},
+	{ do_bad,	SIGBUS,  BUS_OBJERR,	"external exception"	},
+	{ do_bad,	SIGBUS,  0,		"burst operation"	},
+	{ do_bad,	SIGBUS,  0,		"unknown 00100"		},
+	{ do_ifault,	SIGSEGV, SEGV_MAPERR,	"2nd level pt non-exist"},
+	{ do_bad,	SIGBUS,  0,		"2nd lvl large pt non-exist" },
+	{ do_bad,	SIGBUS,  0,		"invalid pte"		},
+	{ do_pf,	SIGSEGV, SEGV_MAPERR,	"page miss"		},
+	{ do_bad,	SIGBUS,  0,		"middle page miss"	},
+	{ do_bad,	SIGBUS,	 0,		"large page miss"	},
+	{ do_pf,	SIGSEGV, SEGV_MAPERR,	"super page (section) miss" },
+	{ do_bad,	SIGBUS,  0,		"unknown 01100"		},
+	{ do_bad,	SIGBUS,  0,		"unknown 01101"		},
+	{ do_bad,	SIGBUS,  0,		"unknown 01110"		},
+	{ do_bad,	SIGBUS,  0,		"unknown 01111"		},
+	{ do_bad,	SIGBUS,  0,		"addr: up 3G or IO"	},
+	{ do_pf,	SIGSEGV, SEGV_ACCERR,	"read unreadable addr"	},
+	{ do_pf,	SIGSEGV, SEGV_ACCERR,	"write unwriteable addr"},
+	{ do_pf,	SIGSEGV, SEGV_ACCERR,	"exec unexecutable addr"},
+	{ do_bad,	SIGBUS,  0,		"unknown 10100"		},
+	{ do_bad,	SIGBUS,  0,		"unknown 10101"		},
+	{ do_bad,	SIGBUS,  0,		"unknown 10110"		},
+	{ do_bad,	SIGBUS,  0,		"unknown 10111"		},
+	{ do_bad,	SIGBUS,  0,		"unknown 11000"		},
+	{ do_bad,	SIGBUS,  0,		"unknown 11001"		},
+	{ do_bad,	SIGBUS,  0,		"unknown 11010"		},
+	{ do_bad,	SIGBUS,  0,		"unknown 11011"		},
+	{ do_bad,	SIGBUS,  0,		"unknown 11100"		},
+	{ do_bad,	SIGBUS,  0,		"unknown 11101"		},
+	{ do_bad,	SIGBUS,  0,		"unknown 11110"		},
+	{ do_bad,	SIGBUS,  0,		"unknown 11111"		}
+};
+
+void __init hook_fault_code(int nr,
+		int (*fn) (unsigned long, unsigned int, struct pt_regs *),
+		int sig, int code, const char *name)
+{
+	if (nr < 0 || nr >= ARRAY_SIZE(fsr_info))
+		BUG();
+
+	fsr_info[nr].fn   = fn;
+	fsr_info[nr].sig  = sig;
+	fsr_info[nr].code = code;
+	fsr_info[nr].name = name;
+}
+
+/*
+ * Dispatch a data abort to the relevant handler.
+ */
+asmlinkage void do_DataAbort(unsigned long addr, unsigned int fsr,
+			struct pt_regs *regs)
+{
+	const struct fsr_info *inf = fsr_info + fsr_fs(fsr);
+	struct siginfo info;
+
+	if (!inf->fn(addr, fsr & ~FSR_LNX_PF, regs))
+		return;
+
+	printk(KERN_ALERT "Unhandled fault: %s (0x%03x) at 0x%08lx\n",
+	       inf->name, fsr, addr);
+
+	info.si_signo = inf->sig;
+	info.si_errno = 0;
+	info.si_code = inf->code;
+	info.si_addr = (void __user *)addr;
+	uc32_notify_die("", regs, &info, fsr, 0);
+}
+
+asmlinkage void do_PrefetchAbort(unsigned long addr,
+			unsigned int ifsr, struct pt_regs *regs)
+{
+	const struct fsr_info *inf = fsr_info + fsr_fs(ifsr);
+	struct siginfo info;
+
+	if (!inf->fn(addr, ifsr | FSR_LNX_PF, regs))
+		return;
+
+	printk(KERN_ALERT "Unhandled prefetch abort: %s (0x%03x) at 0x%08lx\n",
+	       inf->name, ifsr, addr);
+
+	info.si_signo = inf->sig;
+	info.si_errno = 0;
+	info.si_code = inf->code;
+	info.si_addr = (void __user *)addr;
+	uc32_notify_die("", regs, &info, ifsr, 0);
+}
diff --git a/arch/unicore32/mm/mmu.c b/arch/unicore32/mm/mmu.c
new file mode 100644
index 0000000..7bf3d58
--- /dev/null
+++ b/arch/unicore32/mm/mmu.c
@@ -0,0 +1,533 @@
+/*
+ * linux/arch/unicore32/mm/mmu.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/mman.h>
+#include <linux/nodemask.h>
+#include <linux/memblock.h>
+#include <linux/fs.h>
+#include <linux/bootmem.h>
+#include <linux/io.h>
+
+#include <asm/cputype.h>
+#include <asm/sections.h>
+#include <asm/setup.h>
+#include <asm/sizes.h>
+#include <asm/tlb.h>
+
+#include <mach/map.h>
+
+#include "mm.h"
+
+DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
+
+/*
+ * empty_zero_page is a special page that is used for
+ * zero-initialized data and COW.
+ */
+struct page *empty_zero_page;
+EXPORT_SYMBOL(empty_zero_page);
+
+/*
+ * The pmd table for the upper-most set of pages.
+ */
+pmd_t *top_pmd;
+
+pgprot_t pgprot_user;
+EXPORT_SYMBOL(pgprot_user);
+
+pgprot_t pgprot_kernel;
+EXPORT_SYMBOL(pgprot_kernel);
+
+static int __init noalign_setup(char *__unused)
+{
+	cr_alignment &= ~CR_A;
+	cr_no_alignment &= ~CR_A;
+	set_cr(cr_alignment);
+	return 1;
+}
+__setup("noalign", noalign_setup);
+
+void adjust_cr(unsigned long mask, unsigned long set)
+{
+	unsigned long flags;
+
+	mask &= ~CR_A;
+
+	set &= mask;
+
+	local_irq_save(flags);
+
+	cr_no_alignment = (cr_no_alignment & ~mask) | set;
+	cr_alignment = (cr_alignment & ~mask) | set;
+
+	set_cr((get_cr() & ~mask) | set);
+
+	local_irq_restore(flags);
+}
+
+struct map_desc {
+	unsigned long virtual;
+	unsigned long pfn;
+	unsigned long length;
+	unsigned int type;
+};
+
+#define PROT_PTE_DEVICE		(PTE_PRESENT | PTE_YOUNG |	\
+				PTE_DIRTY | PTE_READ | PTE_WRITE)
+#define PROT_SECT_DEVICE	(PMD_TYPE_SECT | PMD_PRESENT |	\
+				PMD_SECT_READ | PMD_SECT_WRITE)
+
+static struct mem_type mem_types[] = {
+	[MT_DEVICE] = {		  /* Strongly ordered */
+		.prot_pte	= PROT_PTE_DEVICE,
+		.prot_l1	= PMD_TYPE_TABLE | PMD_PRESENT,
+		.prot_sect	= PROT_SECT_DEVICE,
+	},
+	/*
+	 * MT_KUSER: pte for vecpage -- cacheable,
+	 *       and sect for unigfx mmap -- noncacheable
+	 */
+	[MT_KUSER] = {
+		.prot_pte  = PTE_PRESENT | PTE_YOUNG | PTE_DIRTY |
+				PTE_CACHEABLE | PTE_READ | PTE_EXEC,
+		.prot_l1   = PMD_TYPE_TABLE | PMD_PRESENT,
+		.prot_sect = PROT_SECT_DEVICE,
+	},
+	[MT_HIGH_VECTORS] = {
+		.prot_pte  = PTE_PRESENT | PTE_YOUNG | PTE_DIRTY |
+				PTE_CACHEABLE | PTE_READ | PTE_WRITE |
+				PTE_EXEC,
+		.prot_l1   = PMD_TYPE_TABLE | PMD_PRESENT,
+	},
+	[MT_MEMORY] = {
+		.prot_pte  = PTE_PRESENT | PTE_YOUNG | PTE_DIRTY |
+				PTE_WRITE | PTE_EXEC,
+		.prot_l1   = PMD_TYPE_TABLE | PMD_PRESENT,
+		.prot_sect = PMD_TYPE_SECT | PMD_PRESENT | PMD_SECT_CACHEABLE |
+				PMD_SECT_READ | PMD_SECT_WRITE | PMD_SECT_EXEC,
+	},
+	[MT_ROM] = {
+		.prot_sect = PMD_TYPE_SECT | PMD_PRESENT | PMD_SECT_CACHEABLE |
+				PMD_SECT_READ,
+	},
+};
+
+const struct mem_type *get_mem_type(unsigned int type)
+{
+	return type < ARRAY_SIZE(mem_types) ? &mem_types[type] : NULL;
+}
+EXPORT_SYMBOL(get_mem_type);
+
+/*
+ * Adjust the PMD section entries according to the CPU in use.
+ */
+static void __init build_mem_type_table(void)
+{
+	pgprot_user   = __pgprot(PTE_PRESENT | PTE_YOUNG | PTE_CACHEABLE);
+	pgprot_kernel = __pgprot(PTE_PRESENT | PTE_YOUNG |
+				 PTE_DIRTY | PTE_READ | PTE_WRITE |
+				 PTE_EXEC | PTE_CACHEABLE);
+}
+
+#define vectors_base()	(vectors_high() ? 0xffff0000 : 0)
+
+static void __init *early_alloc(unsigned long sz)
+{
+	void *ptr = __va(memblock_alloc(sz, sz));
+	memset(ptr, 0, sz);
+	return ptr;
+}
+
+static pte_t * __init early_pte_alloc(pmd_t *pmd, unsigned long addr,
+		unsigned long prot)
+{
+	if (pmd_none(*pmd)) {
+		pte_t *pte = early_alloc(PTRS_PER_PTE * sizeof(pte_t));
+		__pmd_populate(pmd, __pa(pte) | prot);
+	}
+	BUG_ON(pmd_bad(*pmd));
+	return pte_offset_kernel(pmd, addr);
+}
+
+static void __init alloc_init_pte(pmd_t *pmd, unsigned long addr,
+				  unsigned long end, unsigned long pfn,
+				  const struct mem_type *type)
+{
+	pte_t *pte = early_pte_alloc(pmd, addr, type->prot_l1);
+	do {
+		set_pte(pte, pfn_pte(pfn, __pgprot(type->prot_pte)));
+		pfn++;
+	} while (pte++, addr += PAGE_SIZE, addr != end);
+}
+
+static void __init alloc_init_section(pgd_t *pgd, unsigned long addr,
+				      unsigned long end, unsigned long phys,
+				      const struct mem_type *type)
+{
+	pmd_t *pmd = pmd_offset((pud_t *)pgd, addr);
+
+	/*
+	 * Try a section mapping - end, addr and phys must all be aligned
+	 * to a section boundary.
+	 */
+	if (((addr | end | phys) & ~SECTION_MASK) == 0) {
+		pmd_t *p = pmd;
+
+		do {
+			set_pmd(pmd, __pmd(phys | type->prot_sect));
+			phys += SECTION_SIZE;
+		} while (pmd++, addr += SECTION_SIZE, addr != end);
+
+		flush_pmd_entry(p);
+	} else {
+		/*
+		 * No need to loop; pte's aren't interested in the
+		 * individual L1 entries.
+		 */
+		alloc_init_pte(pmd, addr, end, __phys_to_pfn(phys), type);
+	}
+}
+
+/*
+ * Create the page directory entries and any necessary
+ * page tables for the mapping specified by `md'.  We
+ * are able to cope here with varying sizes and address
+ * offsets, and we take full advantage of sections.
+ */
+static void __init create_mapping(struct map_desc *md)
+{
+	unsigned long phys, addr, length, end;
+	const struct mem_type *type;
+	pgd_t *pgd;
+
+	if (md->virtual != vectors_base() && md->virtual < TASK_SIZE) {
+		printk(KERN_WARNING "BUG: not creating mapping for "
+		       "0x%08llx at 0x%08lx in user region\n",
+		       __pfn_to_phys((u64)md->pfn), md->virtual);
+		return;
+	}
+
+	if ((md->type == MT_DEVICE || md->type == MT_ROM) &&
+	    md->virtual >= PAGE_OFFSET && md->virtual < VMALLOC_END) {
+		printk(KERN_WARNING "BUG: mapping for 0x%08llx at 0x%08lx "
+		       "overlaps vmalloc space\n",
+		       __pfn_to_phys((u64)md->pfn), md->virtual);
+	}
+
+	type = &mem_types[md->type];
+
+	addr = md->virtual & PAGE_MASK;
+	phys = (unsigned long)__pfn_to_phys(md->pfn);
+	length = PAGE_ALIGN(md->length + (md->virtual & ~PAGE_MASK));
+
+	if (type->prot_l1 == 0 && ((addr | phys | length) & ~SECTION_MASK)) {
+		printk(KERN_WARNING "BUG: map for 0x%08lx at 0x%08lx can not "
+		       "be mapped using pages, ignoring.\n",
+		       __pfn_to_phys(md->pfn), addr);
+		return;
+	}
+
+	pgd = pgd_offset_k(addr);
+	end = addr + length;
+	do {
+		unsigned long next = pgd_addr_end(addr, end);
+
+		alloc_init_section(pgd, addr, next, phys, type);
+
+		phys += next - addr;
+		addr = next;
+	} while (pgd++, addr != end);
+}
+
+static void * __initdata vmalloc_min = (void *)(VMALLOC_END - SZ_128M);
+
+/*
+ * vmalloc=size forces the vmalloc area to be exactly 'size'
+ * bytes. This can be used to increase (or decrease) the vmalloc
+ * area - the default is 128m.
+ */
+static int __init early_vmalloc(char *arg)
+{
+	unsigned long vmalloc_reserve = memparse(arg, NULL);
+
+	if (vmalloc_reserve < SZ_16M) {
+		vmalloc_reserve = SZ_16M;
+		printk(KERN_WARNING
+			"vmalloc area too small, limiting to %luMB\n",
+			vmalloc_reserve >> 20);
+	}
+
+	if (vmalloc_reserve > VMALLOC_END - (PAGE_OFFSET + SZ_32M)) {
+		vmalloc_reserve = VMALLOC_END - (PAGE_OFFSET + SZ_32M);
+		printk(KERN_WARNING
+			"vmalloc area is too big, limiting to %luMB\n",
+			vmalloc_reserve >> 20);
+	}
+
+	vmalloc_min = (void *)(VMALLOC_END - vmalloc_reserve);
+	return 0;
+}
+early_param("vmalloc", early_vmalloc);
+
+static phys_addr_t lowmem_limit __initdata = SZ_1G;
+
+static void __init sanity_check_meminfo(void)
+{
+	int i, j;
+
+	lowmem_limit = __pa(vmalloc_min - 1) + 1;
+	memblock_set_current_limit(lowmem_limit);
+
+	for (i = 0, j = 0; i < meminfo.nr_banks; i++) {
+		struct membank *bank = &meminfo.bank[j];
+		*bank = meminfo.bank[i];
+		j++;
+	}
+	meminfo.nr_banks = j;
+}
+
+static inline void prepare_page_table(void)
+{
+	unsigned long addr;
+	phys_addr_t end;
+
+	/*
+	 * Clear out all the mappings below the kernel image.
+	 */
+	for (addr = 0; addr < MODULES_VADDR; addr += PGDIR_SIZE)
+		pmd_clear(pmd_off_k(addr));
+
+	for ( ; addr < PAGE_OFFSET; addr += PGDIR_SIZE)
+		pmd_clear(pmd_off_k(addr));
+
+	/*
+	 * Find the end of the first block of lowmem.
+	 */
+	end = memblock.memory.regions[0].base + memblock.memory.regions[0].size;
+	if (end >= lowmem_limit)
+		end = lowmem_limit;
+
+	/*
+	 * Clear out all the kernel space mappings, except for the first
+	 * memory bank, up to the end of the vmalloc region.
+	 */
+	for (addr = __phys_to_virt(end);
+	     addr < VMALLOC_END; addr += PGDIR_SIZE)
+		pmd_clear(pmd_off_k(addr));
+}
+
+/*
+ * Reserve the special regions of memory
+ */
+void __init uc32_mm_memblock_reserve(void)
+{
+	/*
+	 * Reserve the page tables.  These are already in use,
+	 * and can only be in node 0.
+	 */
+	memblock_reserve(__pa(swapper_pg_dir), PTRS_PER_PGD * sizeof(pgd_t));
+
+#ifdef CONFIG_PUV3_UNIGFX
+	/*
+	 * These should likewise go elsewhere.  They pre-reserve the
+	 * screen/video memory region at the 48M~64M of main system memory.
+	 */
+	memblock_reserve(PKUNITY_UNIGFX_MMAP_BASE, PKUNITY_UNIGFX_MMAP_SIZE);
+	memblock_reserve(PKUNITY_UVC_MMAP_BASE, PKUNITY_UVC_MMAP_SIZE);
+#endif
+}
+
+/*
+ * Set up device the mappings.  Since we clear out the page tables for all
+ * mappings above VMALLOC_END, we will remove any debug device mappings.
+ * This means you have to be careful how you debug this function, or any
+ * called function.  This means you can't use any function or debugging
+ * method which may touch any device, otherwise the kernel _will_ crash.
+ */
+static void __init devicemaps_init(void)
+{
+	struct map_desc map;
+	unsigned long addr;
+	void *vectors;
+
+	/*
+	 * Allocate the vector page early.
+	 */
+	vectors = early_alloc(PAGE_SIZE);
+
+	for (addr = VMALLOC_END; addr; addr += PGDIR_SIZE)
+		pmd_clear(pmd_off_k(addr));
+
+	/*
+	 * Create a mapping for UniGFX VRAM
+	 */
+#ifdef CONFIG_PUV3_UNIGFX
+	map.pfn = __phys_to_pfn(PKUNITY_UNIGFX_MMAP_BASE);
+	map.virtual = KUSER_UNIGFX_BASE;
+	map.length = PKUNITY_UNIGFX_MMAP_SIZE;
+	map.type = MT_KUSER;
+	create_mapping(&map);
+#endif
+
+	/*
+	 * Create a mapping for the machine vectors at the high-vectors
+	 * location (0xffff0000).  If we aren't using high-vectors, also
+	 * create a mapping at the low-vectors virtual address.
+	 */
+	map.pfn = __phys_to_pfn(virt_to_phys(vectors));
+	map.virtual = VECTORS_BASE;
+	map.length = PAGE_SIZE;
+	map.type = MT_HIGH_VECTORS;
+	create_mapping(&map);
+
+	/*
+	 * Create a mapping for the kuser page at the special
+	 * location (0xbfff0000) to the same vectors location.
+	 */
+	map.pfn = __phys_to_pfn(virt_to_phys(vectors));
+	map.virtual = KUSER_VECPAGE_BASE;
+	map.length = PAGE_SIZE;
+	map.type = MT_KUSER;
+	create_mapping(&map);
+
+	/*
+	 * Finally flush the caches and tlb to ensure that we're in a
+	 * consistent state wrt the writebuffer.  This also ensures that
+	 * any write-allocated cache lines in the vector page are written
+	 * back.  After this point, we can start to touch devices again.
+	 */
+	local_flush_tlb_all();
+	flush_cache_all();
+}
+
+static void __init map_lowmem(void)
+{
+	struct memblock_region *reg;
+
+	/* Map all the lowmem memory banks. */
+	for_each_memblock(memory, reg) {
+		phys_addr_t start = reg->base;
+		phys_addr_t end = start + reg->size;
+		struct map_desc map;
+
+		if (end > lowmem_limit)
+			end = lowmem_limit;
+		if (start >= end)
+			break;
+
+		map.pfn = __phys_to_pfn(start);
+		map.virtual = __phys_to_virt(start);
+		map.length = end - start;
+		map.type = MT_MEMORY;
+
+		create_mapping(&map);
+	}
+}
+
+/*
+ * paging_init() sets up the page tables, initialises the zone memory
+ * maps, and sets up the zero page, bad page and bad page tables.
+ */
+void __init paging_init(void)
+{
+	void *zero_page;
+
+	build_mem_type_table();
+	sanity_check_meminfo();
+	prepare_page_table();
+	map_lowmem();
+	devicemaps_init();
+
+	top_pmd = pmd_off_k(0xffff0000);
+
+	/* allocate the zero page. */
+	zero_page = early_alloc(PAGE_SIZE);
+
+	bootmem_init();
+
+	empty_zero_page = virt_to_page(zero_page);
+	__flush_dcache_page(NULL, empty_zero_page);
+}
+
+/*
+ * In order to soft-boot, we need to insert a 1:1 mapping in place of
+ * the user-mode pages.  This will then ensure that we have predictable
+ * results when turning the mmu off
+ */
+void setup_mm_for_reboot(char mode)
+{
+	unsigned long base_pmdval;
+	pgd_t *pgd;
+	int i;
+
+	/*
+	 * We need to access to user-mode page tables here. For kernel threads
+	 * we don't have any user-mode mappings so we use the context that we
+	 * "borrowed".
+	 */
+	pgd = current->active_mm->pgd;
+
+	base_pmdval = PMD_SECT_WRITE | PMD_SECT_READ | PMD_TYPE_SECT;
+
+	for (i = 0; i < FIRST_USER_PGD_NR + USER_PTRS_PER_PGD; i++, pgd++) {
+		unsigned long pmdval = (i << PGDIR_SHIFT) | base_pmdval;
+		pmd_t *pmd;
+
+		pmd = pmd_off(pgd, i << PGDIR_SHIFT);
+		set_pmd(pmd, __pmd(pmdval));
+		flush_pmd_entry(pmd);
+	}
+
+	local_flush_tlb_all();
+}
+
+/*
+ * Take care of architecture specific things when placing a new PTE into
+ * a page table, or changing an existing PTE.  Basically, there are two
+ * things that we need to take care of:
+ *
+ *  1. If PG_dcache_clean is not set for the page, we need to ensure
+ *     that any cache entries for the kernels virtual memory
+ *     range are written back to the page.
+ *  2. If we have multiple shared mappings of the same space in
+ *     an object, we need to deal with the cache aliasing issues.
+ *
+ * Note that the pte lock will be held.
+ */
+void update_mmu_cache(struct vm_area_struct *vma, unsigned long addr,
+	pte_t *ptep)
+{
+	unsigned long pfn = pte_pfn(*ptep);
+	struct address_space *mapping;
+	struct page *page;
+
+	if (!pfn_valid(pfn))
+		return;
+
+	/*
+	 * The zero page is never written to, so never has any dirty
+	 * cache lines, and therefore never needs to be flushed.
+	 */
+	page = pfn_to_page(pfn);
+	if (page == ZERO_PAGE(0))
+		return;
+
+	mapping = page_mapping(page);
+	if (!test_and_set_bit(PG_dcache_clean, &page->flags))
+		__flush_dcache_page(mapping, page);
+	if (mapping)
+		if (vma->vm_flags & VM_EXEC)
+			__flush_icache_all();
+}
diff --git a/arch/unicore32/mm/pgd.c b/arch/unicore32/mm/pgd.c
new file mode 100644
index 0000000..632cef7
--- /dev/null
+++ b/arch/unicore32/mm/pgd.c
@@ -0,0 +1,102 @@
+/*
+ * linux/arch/unicore32/mm/pgd.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/mm.h>
+#include <linux/gfp.h>
+#include <linux/highmem.h>
+
+#include <asm/pgalloc.h>
+#include <asm/page.h>
+#include <asm/tlbflush.h>
+
+#include "mm.h"
+
+#define FIRST_KERNEL_PGD_NR	(FIRST_USER_PGD_NR + USER_PTRS_PER_PGD)
+
+/*
+ * need to get a 4k page for level 1
+ */
+pgd_t *get_pgd_slow(struct mm_struct *mm)
+{
+	pgd_t *new_pgd, *init_pgd;
+	pmd_t *new_pmd, *init_pmd;
+	pte_t *new_pte, *init_pte;
+
+	new_pgd = (pgd_t *)__get_free_pages(GFP_KERNEL, 0);
+	if (!new_pgd)
+		goto no_pgd;
+
+	memset(new_pgd, 0, FIRST_KERNEL_PGD_NR * sizeof(pgd_t));
+
+	/*
+	 * Copy over the kernel and IO PGD entries
+	 */
+	init_pgd = pgd_offset_k(0);
+	memcpy(new_pgd + FIRST_KERNEL_PGD_NR, init_pgd + FIRST_KERNEL_PGD_NR,
+		       (PTRS_PER_PGD - FIRST_KERNEL_PGD_NR) * sizeof(pgd_t));
+
+	clean_dcache_area(new_pgd, PTRS_PER_PGD * sizeof(pgd_t));
+
+	if (!vectors_high()) {
+		/*
+		 * On UniCore, first page must always be allocated since it
+		 * contains the machine vectors.
+		 */
+		new_pmd = pmd_alloc(mm, (pud_t *)new_pgd, 0);
+		if (!new_pmd)
+			goto no_pmd;
+
+		new_pte = pte_alloc_map(mm, new_pmd, 0);
+		if (!new_pte)
+			goto no_pte;
+
+		init_pmd = pmd_offset((pud_t *)init_pgd, 0);
+		init_pte = pte_offset_map(init_pmd, 0);
+		set_pte(new_pte, *init_pte);
+		pte_unmap(init_pte);
+		pte_unmap(new_pte);
+	}
+
+	return new_pgd;
+
+no_pte:
+	pmd_free(mm, new_pmd);
+no_pmd:
+	free_pages((unsigned long)new_pgd, 0);
+no_pgd:
+	return NULL;
+}
+
+void free_pgd_slow(struct mm_struct *mm, pgd_t *pgd)
+{
+	pmd_t *pmd;
+	pgtable_t pte;
+
+	if (!pgd)
+		return;
+
+	/* pgd is always present and good */
+	pmd = pmd_off(pgd, 0);
+	if (pmd_none(*pmd))
+		goto free;
+	if (pmd_bad(*pmd)) {
+		pmd_ERROR(*pmd);
+		pmd_clear(pmd);
+		goto free;
+	}
+
+	pte = pmd_pgtable(*pmd);
+	pmd_clear(pmd);
+	pte_free(mm, pte);
+	pmd_free(mm, pmd);
+free:
+	free_pages((unsigned long) pgd, 0);
+}
-- 
1.7.0.4


