Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab1GBVQX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 17:16:23 -0400
Received: from mail.southpole.se ([193.12.106.18]:45873 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709Ab1GBVQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 17:16:13 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH v2 03/19] OpenRISC: Memory management
Date: Sat,  2 Jul 2011 23:15:36 +0200
Message-Id: <1309641352-18714-4-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309641352-18714-1-git-send-email-jonas@southpole.se>
References: <1309641352-18714-1-git-send-email-jonas@southpole.se>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/openrisc/include/asm/cache.h       |   29 ++
 arch/openrisc/include/asm/fixmap.h      |   88 ++++++
 arch/openrisc/include/asm/memblock.h    |   24 ++
 arch/openrisc/include/asm/mmu.h         |   26 ++
 arch/openrisc/include/asm/mmu_context.h |   43 +++
 arch/openrisc/include/asm/page.h        |  112 ++++++++
 arch/openrisc/include/asm/pgalloc.h     |  142 ++++++++++
 arch/openrisc/include/asm/pgtable.h     |  449 +++++++++++++++++++++++++++++++
 arch/openrisc/include/asm/tlb.h         |   34 +++
 arch/openrisc/include/asm/tlbflush.h    |   72 +++++
 arch/openrisc/include/asm/uaccess.h     |  385 ++++++++++++++++++++++++++
 arch/openrisc/mm/fault.c                |  338 +++++++++++++++++++++++
 arch/openrisc/mm/init.c                 |  283 +++++++++++++++++++
 arch/openrisc/mm/ioremap.c              |  113 ++++++++
 arch/openrisc/mm/tlb.c                  |  191 +++++++++++++
 15 files changed, 2329 insertions(+), 0 deletions(-)
 create mode 100644 arch/openrisc/include/asm/cache.h
 create mode 100644 arch/openrisc/include/asm/fixmap.h
 create mode 100644 arch/openrisc/include/asm/memblock.h
 create mode 100644 arch/openrisc/include/asm/mmu.h
 create mode 100644 arch/openrisc/include/asm/mmu_context.h
 create mode 100644 arch/openrisc/include/asm/page.h
 create mode 100644 arch/openrisc/include/asm/pgalloc.h
 create mode 100644 arch/openrisc/include/asm/pgtable.h
 create mode 100644 arch/openrisc/include/asm/tlb.h
 create mode 100644 arch/openrisc/include/asm/tlbflush.h
 create mode 100644 arch/openrisc/include/asm/uaccess.h
 create mode 100644 arch/openrisc/mm/fault.c
 create mode 100644 arch/openrisc/mm/init.c
 create mode 100644 arch/openrisc/mm/ioremap.c
 create mode 100644 arch/openrisc/mm/tlb.c

diff --git a/arch/openrisc/include/asm/cache.h b/arch/openrisc/include/asm/cache.h
new file mode 100644
index 0000000..4ce7a01
--- /dev/null
+++ b/arch/openrisc/include/asm/cache.h
@@ -0,0 +1,29 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_CACHE_H
+#define __ASM_OPENRISC_CACHE_H
+
+/* FIXME: How can we replace these with values from the CPU...
+ * they shouldn't be hard-coded!
+ */
+
+#define L1_CACHE_BYTES 16
+#define L1_CACHE_SHIFT 4
+
+#endif /* __ASM_OPENRISC_CACHE_H */
diff --git a/arch/openrisc/include/asm/fixmap.h b/arch/openrisc/include/asm/fixmap.h
new file mode 100644
index 0000000..a6d27ad23
--- /dev/null
+++ b/arch/openrisc/include/asm/fixmap.h
@@ -0,0 +1,88 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_FIXMAP_H
+#define __ASM_OPENRISC_FIXMAP_H
+
+/* Why exactly do we need 2 empty pages between the top of the fixed
+ * addresses and the top of virtual memory?  Something is using that
+ * memory space but not sure what right now... If you find it, leave
+ * a comment here.
+ */
+#define FIXADDR_TOP	((unsigned long) (-2*PAGE_SIZE))
+
+#include <linux/kernel.h>
+//#include <linux/threads.h>
+#include <asm/page.h>
+
+/*
+ * On OpenRISC we use these special fixed_addresses for doing ioremap
+ * early in the boot process before memory initialization is complete.
+ * This is used, in particular, by the early serial console code.
+ *
+ * It's not really 'fixmap', per se, but fits loosely into the same
+ * paradigm.
+ */
+enum fixed_addresses {
+	/*
+	 * FIX_IOREMAP entries are useful for mapping physical address
+	 * space before ioremap() is useable, e.g. really early in boot
+	 * before kmalloc() is working.
+	 */
+#define FIX_N_IOREMAPS  32
+	FIX_IOREMAP_BEGIN,
+	FIX_IOREMAP_END = FIX_IOREMAP_BEGIN + FIX_N_IOREMAPS - 1,
+	__end_of_fixed_addresses
+};
+
+#define FIXADDR_SIZE		(__end_of_fixed_addresses << PAGE_SHIFT)
+/* FIXADDR_BOTTOM might be a better name here... */
+#define FIXADDR_START		(FIXADDR_TOP - FIXADDR_SIZE)
+
+#define __fix_to_virt(x)	(FIXADDR_TOP - ((x) << PAGE_SHIFT))
+#define __virt_to_fix(x)	((FIXADDR_TOP - ((x)&PAGE_MASK)) >> PAGE_SHIFT)
+
+/*
+ * 'index to address' translation. If anyone tries to use the idx
+ * directly without tranlation, we catch the bug with a NULL-deference
+ * kernel oops. Illegal ranges of incoming indices are caught too.
+ */
+static __always_inline unsigned long fix_to_virt(const unsigned int idx)
+{
+	/*
+	 * this branch gets completely eliminated after inlining,
+	 * except when someone tries to use fixaddr indices in an
+	 * illegal way. (such as mixing up address types or using
+	 * out-of-range indices).
+	 *
+	 * If it doesn't get removed, the linker will complain
+	 * loudly with a reasonably clear error message..
+	 */
+	if (idx >= __end_of_fixed_addresses)
+		BUG();
+
+        return __fix_to_virt(idx);
+}
+
+static inline unsigned long virt_to_fix(const unsigned long vaddr)
+{
+	BUG_ON(vaddr >= FIXADDR_TOP || vaddr < FIXADDR_START);
+	return __virt_to_fix(vaddr);
+}
+
+#endif
diff --git a/arch/openrisc/include/asm/memblock.h b/arch/openrisc/include/asm/memblock.h
new file mode 100644
index 0000000..bbe5a1c
--- /dev/null
+++ b/arch/openrisc/include/asm/memblock.h
@@ -0,0 +1,24 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_MEMBLOCK_H
+#define __ASM_OPENRISC_MEMBLOCK_H
+
+/* empty */
+
+#endif /* __ASM_OPENRISC_MEMBLOCK_H */
diff --git a/arch/openrisc/include/asm/mmu.h b/arch/openrisc/include/asm/mmu.h
new file mode 100644
index 0000000..d069bc2
--- /dev/null
+++ b/arch/openrisc/include/asm/mmu.h
@@ -0,0 +1,26 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_MMU_H
+#define __ASM_OPENRISC_MMU_H
+
+#ifndef __ASSEMBLY__
+typedef unsigned long mm_context_t;
+#endif
+
+#endif
diff --git a/arch/openrisc/include/asm/mmu_context.h b/arch/openrisc/include/asm/mmu_context.h
new file mode 100644
index 0000000..a823716
--- /dev/null
+++ b/arch/openrisc/include/asm/mmu_context.h
@@ -0,0 +1,43 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_MMU_CONTEXT_H
+#define __ASM_OPENRISC_MMU_CONTEXT_H
+
+#include <asm-generic/mm_hooks.h>
+
+extern int init_new_context(struct task_struct *tsk, struct mm_struct *mm);
+extern void destroy_context(struct mm_struct *mm);
+extern void switch_mm(struct mm_struct *prev, struct mm_struct *next,
+		      struct task_struct *tsk);
+
+#define deactivate_mm(tsk,mm)	do { } while (0)
+
+#define activate_mm(prev,next) switch_mm((prev),(next),NULL)
+
+/* current active pgd - this is similar to other processors pgd
+ * registers like cr3 on the i386
+ */
+
+extern volatile pgd_t *current_pgd;   /* defined in arch/openrisc/mm/fault.c */
+
+static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
+{
+}
+
+#endif
diff --git a/arch/openrisc/include/asm/page.h b/arch/openrisc/include/asm/page.h
new file mode 100644
index 0000000..037b844
--- /dev/null
+++ b/arch/openrisc/include/asm/page.h
@@ -0,0 +1,112 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_PAGE_H
+#define __ASM_OPENRISC_PAGE_H
+
+
+/* PAGE_SHIFT determines the page size */
+
+#define PAGE_SHIFT      13
+#ifdef __ASSEMBLY__
+#define PAGE_SIZE       (1 << PAGE_SHIFT)
+#else
+#define PAGE_SIZE       (1UL << PAGE_SHIFT)
+#endif
+#define PAGE_MASK       (~(PAGE_SIZE-1))
+
+#define PAGE_OFFSET		0xc0000000
+#define KERNELBASE  		PAGE_OFFSET
+
+/* #define ARCH_PFN_OFFSET	(PAGE_OFFSET >> PAGE_SHIFT) */
+
+/* This is not necessarily the right place for this, but it's needed by
+ * drivers/of/fdt.c
+ */
+#include <asm/setup.h>
+
+#ifndef __ASSEMBLY__
+
+#define get_user_page(vaddr)            __get_free_page(GFP_KERNEL)
+#define free_user_page(page, addr)      free_page(addr)
+
+#define clear_page(page)        memset((page), 0, PAGE_SIZE)
+#define copy_page(to,from)      memcpy((to), (from), PAGE_SIZE)
+
+#define clear_user_page(page, vaddr, pg)        clear_page(page)
+#define copy_user_page(to, from, vaddr, pg)     copy_page(to, from)
+
+/*
+ * These are used to make use of C type-checking..
+ */
+typedef struct {
+        unsigned long pte;
+} pte_t;
+typedef struct {
+        unsigned long pgd;
+} pgd_t;
+typedef struct {
+        unsigned long pgprot;
+} pgprot_t;
+typedef struct page *pgtable_t;
+
+#define pte_val(x)	((x).pte)
+#define pgd_val(x)	((x).pgd)
+#define pgprot_val(x)	((x).pgprot)
+
+#define __pte(x)	((pte_t) { (x) } )
+#define __pgd(x)	((pgd_t) { (x) } )
+#define __pgprot(x)	((pgprot_t) { (x) } )
+
+extern unsigned long memory_start;
+extern unsigned long memory_end;
+
+#endif /* !__ASSEMBLY__ */
+
+
+#ifndef __ASSEMBLY__
+
+/* from linker script */
+
+#define __va(x) ((void *)((unsigned long)(x) + PAGE_OFFSET))
+#define __pa(x) ((unsigned long) (x) - PAGE_OFFSET)
+
+#define virt_to_pfn(kaddr)      (__pa(kaddr) >> PAGE_SHIFT)
+#define pfn_to_virt(pfn)        __va((pfn) << PAGE_SHIFT)
+
+#define virt_to_page(addr)      (mem_map + (((unsigned long)(addr)-PAGE_OFFSET) >> PAGE_SHIFT))
+#define page_to_virt(page)      ((((page) - mem_map) << PAGE_SHIFT) + PAGE_OFFSET)
+
+#define page_to_phys(page)      ((dma_addr_t)page_to_pfn(page) << PAGE_SHIFT)
+
+#define pfn_valid(pfn)          ((pfn) < max_mapnr)
+
+#define virt_addr_valid(kaddr)  (((void *)(kaddr) >= (void *)PAGE_OFFSET) && \
+                                ((void *)(kaddr) < (void *)memory_end))
+
+#endif /* __ASSEMBLY__ */
+
+
+#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
+				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+
+
+#include <asm-generic/memory_model.h>
+#include <asm-generic/getorder.h>
+
+#endif /* __ASM_OPENRISC_PAGE_H */
diff --git a/arch/openrisc/include/asm/pgalloc.h b/arch/openrisc/include/asm/pgalloc.h
new file mode 100644
index 0000000..339bb52
--- /dev/null
+++ b/arch/openrisc/include/asm/pgalloc.h
@@ -0,0 +1,142 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_PGALLOC_H
+#define __ASM_OPENRISC_PGALLOC_H
+
+#include <asm/page.h>
+#include <linux/threads.h>
+#include <linux/mm.h>
+#include <linux/memblock.h>
+#include <linux/bootmem.h>
+
+extern int mem_init_done;
+
+#if 1
+#define pmd_populate_kernel(mm, pmd, pte) \
+                 set_pmd(pmd, __pmd(_KERNPG_TABLE + __pa(pte)))
+
+static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd, struct page *pte)
+{
+	set_pmd(pmd, __pmd(_KERNPG_TABLE +
+			   ((unsigned long)page_to_pfn(pte) <<
+			    (unsigned long) PAGE_SHIFT)));
+}
+#endif
+
+#if 0
+#define pmd_populate_kernel(mm, pmd, pte) \
+                 set_pmd(pmd, __pmd(_KERNPG_TABLE + __pa(pte)))
+#define pmd_populate(mm, pmd, pte) \
+                set_pmd(pmd, __pmd(__pa(pte)))
+
+#endif
+
+#if 0
+/* __PHX__ check */
+#define pmd_populate_kernel(mm, pmd, pte) pmd_set(pmd, pte)
+#define pmd_populate(mm, pmd, pte) pmd_set(pmd, page_address(pte))
+#endif
+
+
+#if 1
+/*
+ * Allocate and free page tables.
+ */
+
+static inline pgd_t *pgd_alloc(struct mm_struct *mm)
+{
+	pgd_t *ret = (pgd_t *)__get_free_page(GFP_KERNEL);
+
+	if (ret) {
+		memset(ret, 0, USER_PTRS_PER_PGD * sizeof(pgd_t));
+		memcpy(ret + USER_PTRS_PER_PGD, swapper_pg_dir + USER_PTRS_PER_PGD,
+		       (PTRS_PER_PGD - USER_PTRS_PER_PGD) * sizeof(pgd_t));
+
+	}
+	return ret;
+}
+#endif
+
+#if 0
+/* __PHX__ check, this is supposed to be 2.6 style, but
+ * we use current_pgd (from mm->pgd) to load kernel pages
+ * so we need it initialized.
+ */
+extern inline pgd_t *pgd_alloc (struct mm_struct *mm)
+{
+	return (pgd_t *)get_zeroed_page(GFP_KERNEL);
+}
+#endif
+
+static inline void pgd_free (struct mm_struct *mm, pgd_t *pgd)
+{
+	free_page((unsigned long)pgd);
+}
+
+/**
+ * OK, this one's a bit tricky... ioremap can get called before memory is
+ * initialized (early serial console does this) and will want to alloc a page
+ * for its mapping.  No userspace pages will ever get allocated before memory
+ * is initialized so this applies only to kernel pages.  In the event that
+ * this is called before memory is initialized we allocate the page using
+ * the memblock infrastructure.
+ */
+
+static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
+{
+	pte_t* pte;
+
+	if (likely(mem_init_done)) {
+		pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT);
+	} else {
+		pte = (pte_t *) alloc_bootmem_low_pages(PAGE_SIZE);
+//		pte = (pte_t *) __va(memblock_alloc(PAGE_SIZE, PAGE_SIZE));
+	}
+
+	if (pte)
+		clear_page(pte);
+	return pte;
+}
+
+static inline struct page *pte_alloc_one(struct mm_struct *mm, unsigned long address)
+{
+	struct page *pte;
+	pte = alloc_pages(GFP_KERNEL|__GFP_REPEAT, 0);
+	if (pte)
+		clear_page(page_address(pte));
+	return pte;
+}
+
+static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
+{
+	free_page((unsigned long)pte);
+}
+
+static inline void pte_free(struct mm_struct *mm, struct page *pte)
+{
+	__free_page(pte);
+}
+
+
+#define __pte_free_tlb(tlb,pte,addr) tlb_remove_page((tlb),(pte))
+#define pmd_pgtable(pmd) pmd_page(pmd)
+
+#define check_pgt_cache()          do { } while (0)
+
+#endif
diff --git a/arch/openrisc/include/asm/pgtable.h b/arch/openrisc/include/asm/pgtable.h
new file mode 100644
index 0000000..3d5792a
--- /dev/null
+++ b/arch/openrisc/include/asm/pgtable.h
@@ -0,0 +1,449 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* or32 pgtable.h - macros and functions to manipulate page tables
+ *
+ * Based on:
+ * include/asm-cris/pgtable.h
+ */
+
+#ifndef __ASM_OPENRISC_PGTABLE_H
+#define __ASM_OPENRISC_PGTABLE_H
+
+//#include <asm-generic/4level-fixup.h>
+#include <asm-generic/pgtable-nopmd.h>
+
+#ifndef __ASSEMBLY__
+#include <asm/mmu.h>
+#include <asm/fixmap.h>
+
+/*
+ * The Linux memory management assumes a three-level page table setup. On
+ * or32, we use that, but "fold" the mid level into the top-level page
+ * table. Since the MMU TLB is software loaded through an interrupt, it
+ * supports any page table structure, so we could have used a three-level
+ * setup, but for the amounts of memory we normally use, a two-level is
+ * probably more efficient.
+ *
+ * This file contains the functions and defines necessary to modify and use
+ * the or32 page table tree.
+ */
+
+extern void paging_init(void);
+
+/* Certain architectures need to do special things when pte's
+ * within a page table are directly modified.  Thus, the following
+ * hook is made available.
+ */
+#define set_pte(pteptr, pteval) ((*(pteptr)) = (pteval))
+#define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
+/*
+ * (pmds are folded into pgds so this doesn't get actually called,
+ * but the define is needed for a generic inline function.)
+ */
+#define set_pmd(pmdptr, pmdval) (*(pmdptr) = pmdval)
+
+#define PGDIR_SHIFT	(PAGE_SHIFT + (PAGE_SHIFT-2))
+#define PGDIR_SIZE	(1UL << PGDIR_SHIFT)
+#define PGDIR_MASK	(~(PGDIR_SIZE-1))
+
+/*
+ * entries per page directory level: we use a two-level, so
+ * we don't really have any PMD directory physically.
+ * pointers are 4 bytes so we can use the page size and
+ * divide it by 4 (shift by 2).
+ */
+#define PTRS_PER_PTE	(1UL << (PAGE_SHIFT-2))
+
+#define PTRS_PER_PGD	(1UL << (PAGE_SHIFT-2))
+
+/* calculate how many PGD entries a user-level program can use
+ * the first mappable virtual address is 0
+ * (TASK_SIZE is the maximum virtual address space)
+ */
+
+#define USER_PTRS_PER_PGD       (TASK_SIZE/PGDIR_SIZE)
+#define FIRST_USER_ADDRESS      0
+
+/*
+ * Kernels own virtual memory area.
+ */
+
+/*
+ * The size and location of the vmalloc area are chosen so that modules
+ * placed in this area aren't more than a 28-bit signed offset from any
+ * kernel functions that they may need.  This greatly simplifies handling
+ * of the relocations for l.j and l.jal instructions as we don't need to
+ * introduce any trampolines for reaching "distant" code.
+ *
+ * 64 MB of vmalloc area is comparable to what's available on other arches.
+ */
+
+#define VMALLOC_START	(PAGE_OFFSET-0x04000000)
+#define VMALLOC_END	(PAGE_OFFSET)
+#define VMALLOC_VMADDR(x) ((unsigned long)(x))
+
+/* Define some higher level generic page attributes.
+ *
+ * If you change _PAGE_CI definition be sure to change it in
+ * io.h for ioremap_nocache() too.
+ */
+
+/*
+ * An OR32 PTE looks like this:
+ *
+ * |  31 ... 10 |  9  |  8 ... 6  |  5  |  4  |  3  |  2  |  1  |  0  |
+ *  Phys pg.num    L     PP Index    D     A    WOM   WBC   CI    CC
+ *
+ *  L  : link
+ *  PPI: Page protection index
+ *  D  : Dirty
+ *  A  : Accessed
+ *  WOM: Weakly ordered memory
+ *  WBC: Write-back cache
+ *  CI : Cache inhibit
+ *  CC : Cache coherent
+ *
+ * The protection bits below should correspond to the layout of the actual
+ * PTE as per above
+ */
+
+#define _PAGE_CC       0x001 /* software: pte contains a translation */
+#define _PAGE_CI       0x002 /* cache inhibit          */
+#define _PAGE_WBC      0x004 /* write back cache       */
+#define _PAGE_FILE     0x004 /* set: pagecache, unset: swap (when !PRESENT) */
+#define _PAGE_WOM      0x008 /* weakly ordered memory  */
+
+#define _PAGE_A        0x010 /* accessed               */
+#define _PAGE_D        0x020 /* dirty                  */
+#define _PAGE_URE      0x040 /* user read enable       */
+#define _PAGE_UWE      0x080 /* user write enable      */
+
+#define _PAGE_SRE      0x100 /* superuser read enable  */
+#define _PAGE_SWE      0x200 /* superuser write enable */
+#define _PAGE_EXEC     0x400 /* software: page is executable */
+#define _PAGE_U_SHARED 0x800 /* software: page is shared in user space */
+
+/* 0x001 is cache coherency bit, which should always be set to
+ *       1 - for SMP (when we support it)
+ *       0 - otherwise
+ *
+ * we just reuse this bit in software for _PAGE_PRESENT and
+ * force it to 0 when loading it into TLB.
+ */
+#define _PAGE_PRESENT  _PAGE_CC
+#define _PAGE_USER     _PAGE_URE
+#define _PAGE_WRITE    (_PAGE_UWE | _PAGE_SWE)
+#define _PAGE_DIRTY    _PAGE_D
+#define _PAGE_ACCESSED _PAGE_A
+#define _PAGE_NO_CACHE _PAGE_CI
+#define _PAGE_SHARED   _PAGE_U_SHARED
+#define _PAGE_READ     (_PAGE_URE | _PAGE_SRE)
+
+#define _PAGE_CHG_MASK	(PAGE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
+#define _PAGE_BASE     (_PAGE_PRESENT | _PAGE_ACCESSED)
+#define _PAGE_ALL      (_PAGE_PRESENT | _PAGE_ACCESSED)
+#define _KERNPG_TABLE   (_PAGE_BASE | _PAGE_SRE | _PAGE_SWE | _PAGE_ACCESSED | _PAGE_DIRTY)
+
+#define PAGE_NONE       __pgprot(_PAGE_ALL)
+#define PAGE_READONLY   __pgprot(_PAGE_ALL | _PAGE_URE | _PAGE_SRE )
+#define PAGE_READONLY_X __pgprot(_PAGE_ALL | _PAGE_URE | _PAGE_SRE | _PAGE_EXEC)
+#define PAGE_SHARED     __pgprot(_PAGE_ALL | _PAGE_URE | _PAGE_SRE | _PAGE_UWE | _PAGE_SWE | _PAGE_SHARED)
+#define PAGE_SHARED_X   __pgprot(_PAGE_ALL | _PAGE_URE | _PAGE_SRE | _PAGE_UWE | _PAGE_SWE | _PAGE_SHARED | _PAGE_EXEC)
+#define PAGE_COPY       __pgprot(_PAGE_ALL | _PAGE_URE | _PAGE_SRE )
+#define PAGE_COPY_X     __pgprot(_PAGE_ALL | _PAGE_URE | _PAGE_SRE | _PAGE_EXEC)
+
+#define PAGE_KERNEL     __pgprot(_PAGE_ALL | _PAGE_SRE | _PAGE_SWE | _PAGE_SHARED | _PAGE_DIRTY | _PAGE_EXEC)
+#define PAGE_KERNEL_RO  __pgprot(_PAGE_ALL | _PAGE_SRE | _PAGE_SHARED | _PAGE_DIRTY | _PAGE_EXEC)
+#define PAGE_KERNEL_NOCACHE __pgprot(_PAGE_ALL | _PAGE_SRE | _PAGE_SWE | _PAGE_SHARED | _PAGE_DIRTY | _PAGE_EXEC | _PAGE_CI)
+
+#define __P000	PAGE_NONE
+#define __P001	PAGE_READONLY_X
+#define __P010	PAGE_COPY
+#define __P011	PAGE_COPY_X
+#define __P100	PAGE_READONLY
+#define __P101	PAGE_READONLY_X
+#define __P110	PAGE_COPY
+#define __P111	PAGE_COPY_X
+
+#define __S000	PAGE_NONE
+#define __S001	PAGE_READONLY_X
+#define __S010	PAGE_SHARED
+#define __S011	PAGE_SHARED_X
+#define __S100	PAGE_READONLY
+#define __S101	PAGE_READONLY_X
+#define __S110	PAGE_SHARED
+#define __S111	PAGE_SHARED_X
+
+/* zero page used for uninitialized stuff */
+extern unsigned long empty_zero_page[2048];
+#define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
+
+/* number of bits that fit into a memory pointer */
+#define BITS_PER_PTR			(8*sizeof(unsigned long))
+
+/* to align the pointer to a pointer address */
+#define PTR_MASK			(~(sizeof(void*)-1))
+
+/* sizeof(void*)==1<<SIZEOF_PTR_LOG2 */
+/* 64-bit machines, beware!  SRB. */
+#define SIZEOF_PTR_LOG2			2
+
+/* to find an entry in a page-table */
+#define PAGE_PTR(address) \
+((unsigned long)(address)>>(PAGE_SHIFT-SIZEOF_PTR_LOG2)&PTR_MASK&~PAGE_MASK)
+
+/* to set the page-dir */
+#define SET_PAGE_DIR(tsk,pgdir)
+
+#define pte_none(x)	(!pte_val(x))
+#define pte_present(x)	(pte_val(x) & _PAGE_PRESENT)
+#define pte_clear(mm,addr,xp)	do { pte_val(*(xp)) = 0; } while (0)
+
+#define pmd_none(x)	(!pmd_val(x))
+#define	pmd_bad(x)	((pmd_val(x) & (~PAGE_MASK)) != _KERNPG_TABLE)
+#define pmd_present(x)	(pmd_val(x) & _PAGE_PRESENT)
+#define pmd_clear(xp)	do { pmd_val(*(xp)) = 0; } while (0)
+
+/*
+ * The following only work if pte_present() is true.
+ * Undefined behaviour if not..
+ */
+
+static inline int pte_read(pte_t pte)           { return pte_val(pte) & _PAGE_READ; }
+static inline int pte_write(pte_t pte)          { return pte_val(pte) & _PAGE_WRITE; }
+static inline int pte_exec(pte_t pte)           { return pte_val(pte) & _PAGE_EXEC; }
+static inline int pte_dirty(pte_t pte)          { return pte_val(pte) & _PAGE_DIRTY; }
+static inline int pte_young(pte_t pte)          { return pte_val(pte) & _PAGE_ACCESSED; }
+static inline int pte_file(pte_t pte)           { return pte_val(pte) & _PAGE_FILE; }
+static inline int pte_special(pte_t pte)	{ return 0; }
+static inline pte_t pte_mkspecial(pte_t pte)    { return pte; }
+
+static inline pte_t pte_wrprotect(pte_t pte)
+{
+        pte_val(pte) &= ~(_PAGE_WRITE);
+        return pte;
+}
+
+static inline pte_t pte_rdprotect(pte_t pte)
+{
+        pte_val(pte) &= ~(_PAGE_READ);
+	return pte;
+}
+
+static inline pte_t pte_exprotect(pte_t pte)
+{
+        pte_val(pte) &= ~(_PAGE_EXEC);
+	return pte;
+}
+
+static inline pte_t pte_mkclean(pte_t pte)
+{
+	pte_val(pte) &= ~(_PAGE_DIRTY);
+	return pte;
+}
+
+static inline pte_t pte_mkold(pte_t pte)
+{
+	pte_val(pte) &= ~(_PAGE_ACCESSED);
+	return pte;
+}
+
+static inline pte_t pte_mkwrite(pte_t pte)
+{
+        pte_val(pte) |= _PAGE_WRITE;
+        return pte;
+}
+
+static inline pte_t pte_mkread(pte_t pte)
+{
+        pte_val(pte) |= _PAGE_READ;
+        return pte;
+}
+
+static inline pte_t pte_mkexec(pte_t pte)
+{
+        pte_val(pte) |= _PAGE_EXEC;
+        return pte;
+}
+
+static inline pte_t pte_mkdirty(pte_t pte)
+{
+        pte_val(pte) |= _PAGE_DIRTY;
+        return pte;
+}
+
+static inline pte_t pte_mkyoung(pte_t pte)
+{
+        pte_val(pte) |= _PAGE_ACCESSED;
+        return pte;
+}
+
+/*
+ * Conversion functions: convert a page and protection to a page entry,
+ * and a page entry and page directory to the page they refer to.
+ */
+
+/* What actually goes as arguments to the various functions is less than
+ * obvious, but a rule of thumb is that struct page's goes as struct page *,
+ * really physical DRAM addresses are unsigned long's, and DRAM "virtual"
+ * addresses (the 0xc0xxxxxx's) goes as void *'s.
+ */
+
+static inline pte_t __mk_pte(void * page, pgprot_t pgprot)
+{
+	pte_t pte;
+	/* the PTE needs a physical address */
+	pte_val(pte) = __pa(page) | pgprot_val(pgprot);
+	return pte;
+}
+
+#define mk_pte(page, pgprot) __mk_pte(page_address(page), (pgprot))
+
+#define mk_pte_phys(physpage, pgprot) \
+({                                                                      \
+        pte_t __pte;                                                    \
+                                                                        \
+        pte_val(__pte) = (physpage) + pgprot_val(pgprot);               \
+        __pte;                                                          \
+})
+
+static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
+{ pte_val(pte) = (pte_val(pte) & _PAGE_CHG_MASK) | pgprot_val(newprot); return pte; }
+
+
+/* pte_val refers to a page in the 0x0xxxxxxx physical DRAM interval
+ * __pte_page(pte_val) refers to the "virtual" DRAM interval
+ * pte_pagenr refers to the page-number counted starting from the virtual DRAM start
+ */
+
+static inline unsigned long __pte_page(pte_t pte)
+{
+	/* the PTE contains a physical address */
+	return (unsigned long)__va(pte_val(pte) & PAGE_MASK);
+}
+
+#define pte_pagenr(pte)         ((__pte_page(pte) - PAGE_OFFSET) >> PAGE_SHIFT)
+
+/* permanent address of a page */
+
+#define __page_address(page)    (PAGE_OFFSET + (((page) - mem_map) << PAGE_SHIFT))
+#define pte_page(pte)           (mem_map+pte_pagenr(pte))
+
+/* only the pte's themselves need to point to physical DRAM (see above)
+ * the pagetable links are purely handled within the kernel SW and thus
+ * don't need the __pa and __va transformations.
+ */
+
+extern inline void pmd_set(pmd_t * pmdp, pte_t * ptep)
+{ pmd_val(*pmdp) = _KERNPG_TABLE | (unsigned long) ptep; }
+
+#define pmd_page(pmd)		(pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT))
+#define pmd_page_kernel(pmd)    ((unsigned long) __va(pmd_val(pmd) & PAGE_MASK))
+
+/* to find an entry in a page-table-directory. */
+#define pgd_index(address)      ((address >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
+
+#define __pgd_offset(address)   pgd_index(address)
+
+#define pgd_offset(mm, address) ((mm)->pgd+pgd_index(address))
+
+/* to find an entry in a kernel page-table-directory */
+#define pgd_offset_k(address) pgd_offset(&init_mm, address)
+
+#define __pmd_offset(address) \
+                (((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
+
+/*
+ * the pte page can be thought of an array like this: pte_t[PTRS_PER_PTE]
+ *
+ * this macro returns the index of the entry in the pte page which would
+ * control the given virtual address
+ */
+#define __pte_offset(address)                   \
+	(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
+#define pte_offset_kernel(dir, address)         \
+	((pte_t *) pmd_page_kernel(*(dir)) +  __pte_offset(address))
+#define pte_offset_map(dir, address)	        \
+	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
+#define pte_offset_map_nested(dir, address)     \
+        pte_offset_map(dir, address)
+
+#define pte_unmap(pte)          do { } while (0)
+#define pte_unmap_nested(pte)   do { } while (0)
+#define pte_pfn(x)		((unsigned long)(((x).pte)) >> PAGE_SHIFT)
+#define pfn_pte(pfn, prot)	__pte((((pfn) << PAGE_SHIFT)) | pgprot_val(prot))
+
+#define pte_ERROR(e) \
+        printk("%s:%d: bad pte %p(%08lx).\n", __FILE__, __LINE__, &(e), pte_val(e))
+#define pgd_ERROR(e) \
+        printk("%s:%d: bad pgd %p(%08lx).\n", __FILE__, __LINE__, &(e), pgd_val(e))
+
+extern pgd_t swapper_pg_dir[PTRS_PER_PGD]; /* defined in head.S */
+
+/*
+ * or32 doesn't have any external MMU info: the kernel page
+ * tables contain all the necessary information.
+ *
+ * Actually I am not sure on what this could be used for.
+ */
+static inline void update_mmu_cache(struct vm_area_struct * vma,
+	unsigned long address, pte_t * pte)
+{
+}
+
+/* __PHX__ FIXME, SWAP, this probably doesn't work */
+
+/* Encode and de-code a swap entry (must be !pte_none(e) && !pte_present(e)) */
+/* Since the PAGE_PRESENT bit is bit 4, we can use the bits above */
+
+#define __swp_type(x)			(((x).val >> 5) & 0x7f)
+#define __swp_offset(x)			((x).val >> 12)
+#define __swp_entry(type, offset)	((swp_entry_t) { ((type) << 5) | ((offset) << 12) })
+#define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
+#define __swp_entry_to_pte(x)		((pte_t) { (x).val })
+
+/* Encode and decode a nonlinear file mapping entry */
+
+#define PTE_FILE_MAX_BITS               26
+#define pte_to_pgoff(x)	                (pte_val(x) >> 6)
+#define pgoff_to_pte(x)	                __pte(((x) << 6) | _PAGE_FILE)
+
+#define kern_addr_valid(addr)           (1)
+
+#define io_remap_pfn_range(vma, vaddr, pfn, size, prot)         \
+                remap_pfn_range(vma, vaddr, pfn, size, prot)
+
+#include <asm-generic/pgtable.h>
+
+void *consistent_alloc(int gfp, size_t size, dma_addr_t *dma_handle);
+void consistent_free(void *vaddr);
+void consistent_sync(void *vaddr, size_t size, int direction);
+void consistent_sync_page(struct page *page, unsigned long offset,
+        size_t size, int direction);
+
+/*
+ * No page table caches to initialise
+ */
+#define pgtable_cache_init()            do { } while (0)
+#define io_remap_page_range     	remap_page_range
+
+typedef pte_t *pte_addr_t;
+
+#endif /* __ASSEMBLY__ */
+#endif /* __ASM_OPENRISC_PGTABLE_H */
diff --git a/arch/openrisc/include/asm/tlb.h b/arch/openrisc/include/asm/tlb.h
new file mode 100644
index 0000000..fa4376a
--- /dev/null
+++ b/arch/openrisc/include/asm/tlb.h
@@ -0,0 +1,34 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_TLB_H__
+#define __ASM_OPENRISC_TLB_H__
+
+/*
+ * or32 doesn't need any special per-pte or
+ * per-vma handling..
+ */
+#define tlb_start_vma(tlb, vma) do { } while (0)
+#define tlb_end_vma(tlb, vma) do { } while (0)
+#define __tlb_remove_tlb_entry(tlb, ptep, address) do { } while (0)
+
+#define tlb_flush(tlb) flush_tlb_mm((tlb)->mm)
+#include <linux/pagemap.h>
+#include <asm-generic/tlb.h>
+
+#endif /* __ASM_OPENRISC_TLB_H__ */
diff --git a/arch/openrisc/include/asm/tlbflush.h b/arch/openrisc/include/asm/tlbflush.h
new file mode 100644
index 0000000..91adaf9
--- /dev/null
+++ b/arch/openrisc/include/asm/tlbflush.h
@@ -0,0 +1,72 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_TLBFLUSH_H
+#define __ASM_OPENRISC_TLBFLUSH_H
+
+#include <linux/mm.h>
+#include <asm/processor.h>
+#include <asm/pgtable.h>
+#include <asm/pgalloc.h>
+#include <asm/current.h>
+/*#include <asm/spr_defs.h>*/
+#include <linux/sched.h>
+
+/*
+ * TLB flushing (implemented in arch/or32/mm/tlb.c):
+ *
+ *  - flush_tlb() flushes the current mm struct TLBs
+ *  - flush_tlb_all() flushes all processes TLBs
+ *  - flush_tlb_mm(mm) flushes the specified mm context TLB's
+ *  - flush_tlb_page(vma, vmaddr) flushes one page
+ *  - flush_tlb_range(mm, start, end) flushes a range of pages
+ *
+ */
+
+void flush_tlb_all(void);
+void flush_tlb_mm(struct mm_struct* mm);
+void flush_tlb_page(struct vm_area_struct* vma, unsigned long addr);
+void flush_tlb_range(struct vm_area_struct* vma,
+		     unsigned long start,
+		     unsigned long end);
+
+
+#if 0
+static inline void flush_tlb_pgtables(struct mm_struct *mm,
+                                      unsigned long start, unsigned long end)
+{
+        /* OR32 does not keep any page table caches in TLB */
+}
+
+#endif
+
+static inline void flush_tlb(void)
+{
+	flush_tlb_mm(current->mm);
+}
+
+static inline void flush_tlb_kernel_range(unsigned long start,
+					  unsigned long end)
+{
+	flush_tlb_range(NULL, start, end);
+}
+
+
+
+
+#endif /* __ASM_OPENRISC_TLBFLUSH_H */
diff --git a/arch/openrisc/include/asm/uaccess.h b/arch/openrisc/include/asm/uaccess.h
new file mode 100644
index 0000000..a163341
--- /dev/null
+++ b/arch/openrisc/include/asm/uaccess.h
@@ -0,0 +1,385 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_UACCESS_H
+#define __ASM_OPENRISC_UACCESS_H
+
+/*
+ * User space memory access functions
+ */
+#include <linux/errno.h>
+#include <linux/thread_info.h>
+#include <linux/prefetch.h>
+#include <linux/string.h>
+#include <asm/page.h>
+#include <asm/thread_info.h>
+
+#define VERIFY_READ	0
+#define VERIFY_WRITE	1
+
+/*
+ * The fs value determines whether argument validity checking should be
+ * performed or not.  If get_fs() == USER_DS, checking is performed, with
+ * get_fs() == KERNEL_DS, checking is bypassed.
+ *
+ * For historical reasons, these macros are grossly misnamed.
+ */
+
+//#define MAKE_MM_SEG(s)	((mm_segment_t) s)
+
+/* addr_limit is the maximum accessible address for the task. we misuse
+ * the KERNEL_DS and USER_DS values to both assign and compare the
+ * addr_limit values through the equally misnamed get/set_fs macros.
+ * (see above)
+ */
+
+#define KERNEL_DS	(~0UL)
+#define get_ds()	(KERNEL_DS)
+
+#define USER_DS		(TASK_SIZE)
+#define get_fs()	(current_thread_info()->addr_limit)
+#define set_fs(x)	(current_thread_info()->addr_limit = (x))
+
+#define segment_eq(a,b)	((a) == (b))
+
+#if 0
+
+#define __kernel_ok (segment_eq(get_fs(), KERNEL_DS))
+#define __user_ok(addr,size) (((size) <= TASK_SIZE)&&((addr) <= TASK_SIZE-(size)))
+#endif
+
+/* Ensure that the range from addr to addr+size is all within the process'
+ * address space
+ */
+//#define __range_ok(addr,size) (size <= TASK_SIZE && addr <= (TASK_SIZE-size))
+#define __range_ok(addr,size) (size <= get_fs() && addr <= (get_fs()-size))
+
+/* Ensure that addr is below task's addr_limit */
+#define __addr_ok(addr) ((unsigned long) addr < get_fs())
+
+//#define __access_ok(addr,size) (__kernel_ok || __user_ok((addr),(size)))
+//#define __access_ok(addr,size) (__range_ok(addr,size))
+//#define access_ok(type,addr,size) __access_ok((unsigned long)(addr),(size))
+#define access_ok(type,addr,size) __range_ok((unsigned long)addr,(unsigned long)size)
+
+
+/*
+ * The exception table consists of pairs of addresses: the first is the
+ * address of an instruction that is allowed to fault, and the second is
+ * the address at which the program should continue.  No registers are
+ * modified, so it is entirely up to the continuation code to figure out
+ * what to do.
+ *
+ * All the routines below use bits of fixup code that are out of line
+ * with the main instruction path.  This means when everything is well,
+ * we don't even have to jump over them.  Further, they do not intrude
+ * on our cache or tlb entries.
+ */
+
+struct exception_table_entry
+{
+	unsigned long insn, fixup;
+};
+
+/* Returns 0 if exception not found and fixup otherwise.  */
+extern unsigned long search_exception_table(unsigned long);
+extern void sort_exception_table(void);
+
+/*
+ * These are the main single-value transfer routines.  They automatically
+ * use the right size if we just have the right pointer type.
+ *
+ * This gets kind of ugly. We want to return _two_ values in "get_user()"
+ * and yet we don't want to do any pointers, because that is too much
+ * of a performance impact. Thus we have a few rather ugly macros here,
+ * and hide all the uglyness from the user.
+ *
+ * The "__xxx" versions of the user access functions are versions that
+ * do not verify the address space, that must have been done previously
+ * with a separate "access_ok()" call (this is used when we do multiple
+ * accesses to the same area of user memory).
+ *
+ * As we use the same address space for kernel and user data on the
+ * PowerPC, we can just do these as direct assignments.  (Of course, the
+ * exception handling means that it's no longer "just"...)
+ */
+#define get_user(x,ptr) \
+  __get_user_check((x),(ptr),sizeof(*(ptr)))
+#define put_user(x,ptr) \
+  __put_user_check((__typeof__(*(ptr)))(x),(ptr),sizeof(*(ptr)))
+
+#define __get_user(x,ptr) \
+  __get_user_nocheck((x),(ptr),sizeof(*(ptr)))
+#define __put_user(x,ptr) \
+  __put_user_nocheck((__typeof__(*(ptr)))(x),(ptr),sizeof(*(ptr)))
+
+extern long __put_user_bad(void);
+
+#define __put_user_nocheck(x,ptr,size)			\
+({							\
+	long __pu_err;					\
+	__put_user_size((x),(ptr),(size),__pu_err);	\
+	__pu_err;					\
+})
+
+#define __put_user_check(x,ptr,size)				\
+({								\
+	long __pu_err = -EFAULT;				\
+	__typeof__(*(ptr)) *__pu_addr = (ptr);			\
+	if (access_ok(VERIFY_WRITE,__pu_addr,size))		\
+		__put_user_size((x),__pu_addr,(size),__pu_err);	\
+	__pu_err;						\
+})
+
+#define __put_user_size(x,ptr,size,retval)			\
+do {								\
+	retval = 0;						\
+	switch (size) {						\
+	  case 1: __put_user_asm(x,ptr,retval,"l.sb"); break;	\
+	  case 2: __put_user_asm(x,ptr,retval,"l.sh"); break;	\
+	  case 4: __put_user_asm(x,ptr,retval,"l.sw"); break;	\
+	  case 8: __put_user_asm2(x,ptr,retval); break;		\
+	  default: __put_user_bad();				\
+	}							\
+} while (0)
+
+struct __large_struct { unsigned long buf[100]; };
+#define __m(x) (*(struct __large_struct *)(x))
+
+/*
+ * We don't tell gcc that we are accessing memory, but this is OK
+ * because we do not write to any memory gcc knows about, so there
+ * are no aliasing issues.
+ */
+#define __put_user_asm(x, addr, err, op)			\
+	__asm__ __volatile__(					\
+		"1:	"op" 0(%2),%1\n"			\
+		"2:\n"						\
+		".section .fixup,\"ax\"\n"			\
+		"3:	l.addi %0,r0,%3\n"			\
+		"	l.j 2b\n"				\
+		"	l.nop \n"				\
+		".previous\n"					\
+		".section __ex_table,\"a\"\n"			\
+		"	.align 2\n"				\
+		"	.long 1b,3b\n"				\
+		".previous"					\
+		: "=r"(err)					\
+		: "r"(x), "r"(addr), "i"(-EFAULT), "0"(err))
+
+#define __put_user_asm2(x, addr, err)				\
+	__asm__ __volatile__(					\
+		"1:	l.sw 0(%2),%1\n"			\
+		"2:	l.sw 4(%2),%H1\n"			\
+		"3:\n"						\
+		".section .fixup,\"ax\"\n"			\
+		"4:	l.addi %0,r0,%3\n"			\
+		"	l.j 3b\n"				\
+		"	l.nop \n"				\
+		".previous\n"					\
+		".section __ex_table,\"a\"\n"			\
+		"	.align 2\n"				\
+		"	.long 1b,4b\n"				\
+		"	.long 2b,4b\n"				\
+		".previous"					\
+		: "=r"(err)					\
+		: "r"(x), "r"(addr), "i"(-EFAULT), "0"(err))
+
+#define __get_user_nocheck(x,ptr,size)				\
+({								\
+	long __gu_err, __gu_val;				\
+	__get_user_size(__gu_val,(ptr),(size),__gu_err);	\
+	(x) = (__typeof__(*(ptr)))__gu_val;			\
+	__gu_err;						\
+})
+
+#define __get_user_check(x,ptr,size)					\
+({									\
+	long __gu_err = -EFAULT, __gu_val = 0;				\
+	const __typeof__(*(ptr)) *__gu_addr = (ptr);			\
+	if (access_ok(VERIFY_READ,__gu_addr,size))			\
+		__get_user_size(__gu_val,__gu_addr,(size),__gu_err);	\
+	(x) = (__typeof__(*(ptr)))__gu_val;				\
+	__gu_err;							\
+})
+
+extern long __get_user_bad(void);
+
+#define __get_user_size(x,ptr,size,retval)			\
+do {								\
+	retval = 0;						\
+	switch (size) {						\
+	  case 1: __get_user_asm(x,ptr,retval,"l.lbz"); break;	\
+	  case 2: __get_user_asm(x,ptr,retval,"l.lhz"); break;	\
+	  case 4: __get_user_asm(x,ptr,retval,"l.lwz"); break;	\
+	  case 8: __get_user_asm2(x, ptr, retval);		\
+	  default: (x) = __get_user_bad();			\
+	}							\
+} while (0)
+
+#define __get_user_asm(x, addr, err, op)		\
+	__asm__ __volatile__(				\
+		"1:	"op" %1,0(%2)\n"		\
+		"2:\n"					\
+		".section .fixup,\"ax\"\n"		\
+		"3:	l.addi %0,r0,%3\n"		\
+		"	l.addi %1,r0,0\n"		\
+		"	l.j 2b\n"			\
+		"	l.nop \n"			\
+		".previous\n"				\
+		".section __ex_table,\"a\"\n"		\
+		"	.align 2\n"			\
+		"	.long 1b,3b\n"			\
+		".previous"				\
+		: "=r"(err), "=r"(x)			\
+		: "r"(addr), "i"(-EFAULT), "0"(err))
+
+#define __get_user_asm2(x, addr, err)			\
+	__asm__ __volatile__(				\
+		"1:	l.lwz %1,0(%2)\n"		\
+		"2:	l.lwz %H1,4(%2)\n"		\
+		"3:\n"					\
+		".section .fixup,\"ax\"\n"		\
+		"4:	l.addi %0,r0,%3\n"		\
+		"	l.addi %1,r0,0\n"		\
+		"	l.addi %H1,r0,0\n"		\
+		"	l.j 3b\n"			\
+		"	l.nop \n"			\
+		".previous\n"				\
+		".section __ex_table,\"a\"\n"		\
+		"	.align 2\n"			\
+		"	.long 1b,4b\n"			\
+		"	.long 2b,4b\n"			\
+		".previous"				\
+		: "=r"(err), "=&r"(x)			\
+		: "r"(addr), "i"(-EFAULT), "0"(err))
+
+/* more complex routines */
+
+extern unsigned long __must_check
+__copy_tofrom_user(void *to, const void *from, unsigned long size);
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+#define __copy_from_user(to, from, size) \
+	__copy_tofrom_user(to, from, size)
+#define __copy_to_user(to, from, size) \
+	__copy_tofrom_user(to, from, size)
+
+#define __copy_to_user_inatomic __copy_to_user
+#define __copy_from_user_inatomic __copy_from_user
+
+static inline unsigned long
+copy_from_user(void *to, const void *from, unsigned long n)
+{
+	unsigned long over;
+
+	if (access_ok(VERIFY_READ, from, n))
+		return __copy_tofrom_user(to, from, n);
+	if ((unsigned long)from < TASK_SIZE) {
+		over = (unsigned long)from + n - TASK_SIZE;
+		return __copy_tofrom_user(to, from, n - over) + over;
+	}
+	return n;
+}
+
+static inline unsigned long
+copy_to_user(void *to, const void *from, unsigned long n)
+{
+	unsigned long over;
+
+	if (access_ok(VERIFY_WRITE, to, n))
+		return __copy_tofrom_user(to, from, n);
+	if ((unsigned long)to < TASK_SIZE) {
+		over = (unsigned long)to + n - TASK_SIZE;
+		return __copy_tofrom_user(to, from, n - over) + over;
+	}
+	return n;
+}
+
+
+extern unsigned long __clear_user(void *addr, unsigned long size);
+
+static inline __must_check unsigned long
+clear_user(void *addr, unsigned long size)
+{
+
+	if (access_ok(VERIFY_WRITE, addr, size))
+		return __clear_user(addr, size);
+	if ((unsigned long)addr < TASK_SIZE) {
+		unsigned long over = (unsigned long)addr + size - TASK_SIZE;
+		return __clear_user(addr, size - over) + over;
+	}
+	return size;
+}
+
+extern int __strncpy_from_user(char *dst, const char *src, long count);
+
+static inline long
+strncpy_from_user(char *dst, const char *src, long count)
+{
+	if (access_ok(VERIFY_READ, src, 1))
+		return __strncpy_from_user(dst, src, count);
+	return -EFAULT;
+}
+
+/*
+ * Return the size of a string (including the ending 0)
+ *
+ * Return 0 for error
+ */
+
+extern int __strnlen_user(const char *str, long len, unsigned long top);
+
+/*
+ * Returns the length of the string at str (including the null byte),
+ * or 0 if we hit a page we can't access,
+ * or something > len if we didn't find a null byte.
+ *
+ * The `top' parameter to __strnlen_user is to make sure that
+ * we can never overflow from the user area into kernel space.
+ */
+static inline long strnlen_user(const char __user *str, long len)
+{
+//	unsigned long top = __kernel_ok? ~0UL: TASK_SIZE - 1;
+
+	unsigned long top = (unsigned long) get_fs();
+	unsigned long res = 0;
+
+	if (__addr_ok(str))
+		res = __strnlen_user(str, len, top);
+
+	return res;
+}
+
+//#define strlen_user(str) strnlen_user(str, 0x7ffffffe)
+#define strlen_user(str) strnlen_user(str, TASK_SIZE-1)
+
+#endif	/* __ASM_OPENRISC_UACCESS_H */
diff --git a/arch/openrisc/mm/fault.c b/arch/openrisc/mm/fault.c
new file mode 100644
index 0000000..a5dce82
--- /dev/null
+++ b/arch/openrisc/mm/fault.c
@@ -0,0 +1,338 @@
+/*
+ * OpenRISC fault.c
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * Modifications for the OpenRISC architecture:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/mm.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+
+#include <asm/uaccess.h>
+#include <asm/siginfo.h>
+#include <asm/signal.h>
+
+#define NUM_TLB_ENTRIES 64
+#define TLB_OFFSET(add) (((add) >> PAGE_SHIFT) & (NUM_TLB_ENTRIES-1))
+
+unsigned long pte_misses;	/* updated by do_page_fault() */
+unsigned long pte_errors;	/* updated by do_page_fault() */
+
+/* __PHX__ :: - check the vmalloc_fault in do_page_fault()
+ *            - also look into include/asm-or32/mmu_context.h
+ */
+volatile pgd_t *current_pgd;
+
+extern void die(char *, struct pt_regs *, long);
+
+/*
+ * This routine handles page faults.  It determines the address,
+ * and the problem, and then passes it off to one of the appropriate
+ * routines.
+ *
+ * If this routine detects a bad access, it returns 1, otherwise it
+ * returns 0.
+ */
+
+asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long address,
+			      unsigned long vector, int write_acc)
+{
+	struct task_struct *tsk;
+	struct mm_struct *mm;
+	struct vm_area_struct *vma;
+	siginfo_t info;
+	int fault;
+
+	tsk = current;
+
+	/*
+	 * We fault-in kernel-space virtual memory on-demand. The
+	 * 'reference' page table is init_mm.pgd.
+	 *
+	 * NOTE! We MUST NOT take any locks for this case. We may
+	 * be in an interrupt or a critical region, and should
+	 * only copy the information from the master page table,
+	 * nothing more.
+	 *
+	 * NOTE2: This is done so that, when updating the vmalloc
+	 * mappings we don't have to walk all processes pgdirs and
+	 * add the high mappings all at once. Instead we do it as they
+	 * are used. However vmalloc'ed page entries have the PAGE_GLOBAL
+	 * bit set so sometimes the TLB can use a lingering entry.
+	 *
+	 * This verifies that the fault happens in kernel space
+	 * and that the fault was not a protection error.
+	 */
+
+	if (address >= VMALLOC_START &&
+	    (vector != 0x300 && vector != 0x400) &&
+	    !user_mode(regs))
+		goto vmalloc_fault;
+
+	/* If exceptions were enabled, we can reenable them here */
+	if (user_mode(regs)) {
+		/* Exception was in userspace: reenable interrupts */
+		local_irq_enable();
+	} else {
+		/* If exception was in a syscall, then IRQ's may have
+		 * been enabled or disabled.  If they were enabled,
+		 * reenable them.
+		 */
+		if (regs->sr && (SPR_SR_IEE | SPR_SR_TEE))
+			local_irq_enable();
+	}
+
+	mm = tsk->mm;
+	info.si_code = SEGV_MAPERR;
+
+	/*
+	 * If we're in an interrupt or have no user
+	 * context, we must not take the fault..
+	 */
+
+	if (in_interrupt() || !mm)
+		goto no_context;
+
+	down_read(&mm->mmap_sem);
+	vma = find_vma(mm, address);
+
+	if (!vma)
+		goto bad_area;
+
+	if (vma->vm_start <= address)
+		goto good_area;
+
+	if (!(vma->vm_flags & VM_GROWSDOWN))
+		goto bad_area;
+
+	if (user_mode(regs)) {
+		/*
+		 * accessing the stack below usp is always a bug.
+		 * we get page-aligned addresses so we can only check
+		 * if we're within a page from usp, but that might be
+		 * enough to catch brutal errors at least.
+		 */
+		if (address + PAGE_SIZE < regs->sp)
+			goto bad_area;
+	}
+	if (expand_stack(vma, address))
+		goto bad_area;
+
+	/*
+	 * Ok, we have a good vm_area for this memory access, so
+	 * we can handle it..
+	 */
+
+good_area:
+	info.si_code = SEGV_ACCERR;
+
+	/* first do some preliminary protection checks */
+
+	if (write_acc) {
+		if (!(vma->vm_flags & VM_WRITE))
+			goto bad_area;
+	} else {
+		/* not present */
+		if (!(vma->vm_flags & (VM_READ | VM_EXEC)))
+			goto bad_area;
+	}
+
+	/* are we trying to execute nonexecutable area */
+	if ((vector == 0x400) && !(vma->vm_page_prot.pgprot & _PAGE_EXEC))
+		goto bad_area;
+
+	/*
+	 * If for any reason at all we couldn't handle the fault,
+	 * make sure we exit gracefully rather than endlessly redo
+	 * the fault.
+	 */
+
+	fault = handle_mm_fault(mm, vma, address, write_acc);
+	if (unlikely(fault & VM_FAULT_ERROR)) {
+		if (fault & VM_FAULT_OOM)
+			goto out_of_memory;
+		else if (fault & VM_FAULT_SIGBUS)
+			goto do_sigbus;
+		BUG();
+	}
+	/*RGD modeled on Cris */
+	if (fault & VM_FAULT_MAJOR)
+		tsk->maj_flt++;
+	else
+		tsk->min_flt++;
+
+	up_read(&mm->mmap_sem);
+	return;
+
+	/*
+	 * Something tried to access memory that isn't in our memory map..
+	 * Fix it, but check if it's kernel or user first..
+	 */
+
+bad_area:
+	up_read(&mm->mmap_sem);
+
+bad_area_nosemaphore:
+
+	/* User mode accesses just cause a SIGSEGV */
+
+	if (user_mode(regs)) {
+		info.si_signo = SIGSEGV;
+		info.si_errno = 0;
+		/* info.si_code has been set above */
+		info.si_addr = (void *)address;
+		force_sig_info(SIGSEGV, &info, tsk);
+		return;
+	}
+
+no_context:
+
+	/* Are we prepared to handle this kernel fault?
+	 *
+	 * (The kernel has valid exception-points in the source
+	 *  when it acesses user-memory. When it fails in one
+	 *  of those points, we find it in a table and do a jump
+	 *  to some fixup code that loads an appropriate error
+	 *  code)
+	 */
+
+	{
+		const struct exception_table_entry *entry;
+
+		__asm__ __volatile__("l.nop 42");
+
+		if ((entry = search_exception_tables(regs->pc)) != NULL) {
+			/* Adjust the instruction pointer in the stackframe */
+			regs->pc = entry->fixup;
+			return;
+		}
+	}
+
+	/*
+	 * Oops. The kernel tried to access some bad page. We'll have to
+	 * terminate things with extreme prejudice.
+	 */
+
+	if ((unsigned long)(address) < PAGE_SIZE)
+		printk(KERN_ALERT
+		       "Unable to handle kernel NULL pointer dereference");
+	else
+		printk(KERN_ALERT "Unable to handle kernel access");
+	printk(" at virtual address 0x%08lx\n", address);
+
+	die("Oops", regs, write_acc);
+
+	do_exit(SIGKILL);
+
+	/*
+	 * We ran out of memory, or some other thing happened to us that made
+	 * us unable to handle the page fault gracefully.
+	 */
+
+out_of_memory:
+	__asm__ __volatile__("l.nop 42");
+	__asm__ __volatile__("l.nop 1");
+
+	up_read(&mm->mmap_sem);
+	printk("VM: killing process %s\n", tsk->comm);
+	if (user_mode(regs))
+		do_exit(SIGKILL);
+	goto no_context;
+
+do_sigbus:
+	up_read(&mm->mmap_sem);
+
+	/*
+	 * Send a sigbus, regardless of whether we were in kernel
+	 * or user mode.
+	 */
+	info.si_signo = SIGBUS;
+	info.si_errno = 0;
+	info.si_code = BUS_ADRERR;
+	info.si_addr = (void *)address;
+	force_sig_info(SIGBUS, &info, tsk);
+
+	/* Kernel mode? Handle exceptions or die */
+	if (!user_mode(regs))
+		goto no_context;
+	return;
+
+vmalloc_fault:
+	{
+		/*
+		 * Synchronize this task's top level page-table
+		 * with the 'reference' page table.
+		 *
+		 * Use current_pgd instead of tsk->active_mm->pgd
+		 * since the latter might be unavailable if this
+		 * code is executed in a misfortunately run irq
+		 * (like inside schedule() between switch_mm and
+		 *  switch_to...).
+		 */
+
+		int offset = pgd_index(address);
+		pgd_t *pgd, *pgd_k;
+		pud_t *pud, *pud_k;
+		pmd_t *pmd, *pmd_k;
+		pte_t *pte_k;
+
+/*
+		phx_warn("do_page_fault(): vmalloc_fault will not work, "
+			 "since current_pgd assign a proper value somewhere\n"
+			 "anyhow we don't need this at the moment\n");
+
+		phx_mmu("vmalloc_fault");
+*/
+		pgd = (pgd_t *)current_pgd + offset;
+		pgd_k = init_mm.pgd + offset;
+
+		/* Since we're two-level, we don't need to do both
+		 * set_pgd and set_pmd (they do the same thing). If
+		 * we go three-level at some point, do the right thing
+		 * with pgd_present and set_pgd here.
+		 *
+		 * Also, since the vmalloc area is global, we don't
+		 * need to copy individual PTE's, it is enough to
+		 * copy the pgd pointer into the pte page of the
+		 * root task. If that is there, we'll find our pte if
+		 * it exists.
+		 */
+
+		pud = pud_offset(pgd, address);
+		pud_k = pud_offset(pgd_k, address);
+		if (!pud_present(*pud_k))
+			goto no_context;
+
+		pmd = pmd_offset(pud, address);
+		pmd_k = pmd_offset(pud_k, address);
+
+		if (!pmd_present(*pmd_k))
+			goto bad_area_nosemaphore;
+
+		set_pmd(pmd, *pmd_k);
+
+		/* Make sure the actual PTE exists as well to
+		 * catch kernel vmalloc-area accesses to non-mapped
+		 * addresses. If we don't do this, this will just
+		 * silently loop forever.
+		 */
+
+		pte_k = pte_offset_kernel(pmd_k, address);
+		if (!pte_present(*pte_k))
+			goto no_context;
+
+		return;
+	}
+}
diff --git a/arch/openrisc/mm/init.c b/arch/openrisc/mm/init.c
new file mode 100644
index 0000000..069191f
--- /dev/null
+++ b/arch/openrisc/mm/init.c
@@ -0,0 +1,283 @@
+/*
+ * OpenRISC idle.c
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * Modifications for the OpenRISC architecture:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/signal.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/ptrace.h>
+#include <linux/mman.h>
+#include <linux/mm.h>
+#include <linux/swap.h>
+#include <linux/smp.h>
+#include <linux/bootmem.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/blkdev.h>	/* for initrd_* */
+#include <linux/pagemap.h>
+#include <linux/memblock.h>
+
+#include <asm/system.h>
+#include <asm/segment.h>
+#include <asm/pgalloc.h>
+#include <asm/pgtable.h>
+#include <asm/dma.h>
+#include <asm/io.h>
+#include <asm/tlb.h>
+#include <asm/mmu_context.h>
+#include <asm/kmap_types.h>
+#include <asm/fixmap.h>
+#include <asm/tlbflush.h>
+
+int mem_init_done = 0;
+
+DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
+
+static void __init zone_sizes_init(void)
+{
+	unsigned long zones_size[MAX_NR_ZONES];
+
+	/* Clear the zone sizes */
+	memset(zones_size, 0, sizeof(zones_size));
+
+	/*
+	 * We use only ZONE_NORMAL
+	 */
+	zones_size[ZONE_NORMAL] = max_low_pfn;
+
+	free_area_init(zones_size);
+}
+
+extern const char _s_kernel_ro[], _e_kernel_ro[];
+
+/*
+ * Map all physical memory into kernel's address space.
+ *
+ * This is explicitly coded for two-level page tables, so if you need
+ * something else then this needs to change.
+ */
+static void __init map_ram(void)
+{
+	unsigned long v, p, e;
+	pgprot_t prot;
+	pgd_t *pge;
+	pud_t *pue;
+	pmd_t *pme;
+	pte_t *pte;
+	/* These mark extents of read-only kernel pages...
+	 * ...from vmlinux.lds.S
+	 */
+	struct memblock_region *region;
+
+	v = PAGE_OFFSET;
+
+	for_each_memblock(memory, region) {
+		p = (u32) region->base & PAGE_MASK;
+		e = p + (u32) region->size;
+
+		v = (u32) __va(p);
+		pge = pgd_offset_k(v);
+
+		while (p < e) {
+			int j;
+			pue = pud_offset(pge, v);
+			pme = pmd_offset(pue, v);
+
+			if ((u32) pue != (u32) pge || (u32) pme != (u32) pge) {
+				panic
+				    ("%s: OR1K kernel hardcoded for two-level page tables",
+				     __func__);
+			}
+
+			/* Alloc one page for holding PTE's... */
+			pte = (pte_t *) alloc_bootmem_low_pages(PAGE_SIZE);
+			set_pmd(pme, __pmd(_KERNPG_TABLE + __pa(pte)));
+
+			/* Fill the newly allocated page with PTE'S */
+			for (j = 0; p < e && j < PTRS_PER_PGD;
+			     v += PAGE_SIZE, p += PAGE_SIZE, j++, pte++) {
+				if (v >= (u32) _e_kernel_ro ||
+				    v < (u32) _s_kernel_ro)
+					prot = PAGE_KERNEL;
+				else
+					prot = PAGE_KERNEL_RO;
+
+				set_pte(pte, mk_pte_phys(p, prot));
+			}
+
+			pge++;
+		}
+
+		printk(KERN_INFO "%s: Memory: 0x%x-0x%x\n", __func__,
+		       region->base, region->base + region->size);
+	}
+}
+
+void __init paging_init(void)
+{
+	extern void tlb_init(void);
+
+	unsigned long end;
+	int i;
+
+	printk("Setting up paging and PTEs.\n");
+
+	/* clear out the init_mm.pgd that will contain the kernel's mappings */
+
+	for (i = 0; i < PTRS_PER_PGD; i++)
+		swapper_pg_dir[i] = __pgd(0);
+
+	/* make sure the current pgd table points to something sane
+	 * (even if it is most probably not used until the next
+	 *  switch_mm)
+	 */
+	current_pgd = init_mm.pgd;
+
+	end = (unsigned long)__va(max_low_pfn * PAGE_SIZE);
+
+	map_ram();
+
+	zone_sizes_init();
+
+	/* self modifying code ;) */
+	/* Since the old TLB miss handler has been running up until now,
+	 * the kernel pages are still all RW, so we can still modify the
+	 * text directly... after this change and a TLB flush, the kernel
+	 * pages will become RO.
+	 */
+	{
+		extern unsigned long dtlb_miss_handler;
+		extern unsigned long itlb_miss_handler;
+
+		unsigned long *dtlb_vector = __va(0x900);
+		unsigned long *itlb_vector = __va(0xa00);
+
+		printk("dtlb_miss_handler %p\n", &dtlb_miss_handler);
+		*dtlb_vector = ((unsigned long)&dtlb_miss_handler -
+				(unsigned long)dtlb_vector) >> 2;
+
+		printk("itlb_miss_handler %p\n", &itlb_miss_handler);
+		*itlb_vector = ((unsigned long)&itlb_miss_handler -
+				(unsigned long)itlb_vector) >> 2;
+	}
+
+	/* Invalidate instruction caches after code modification */
+	mtspr(SPR_ICBIR, 0x900);
+	mtspr(SPR_ICBIR, 0xa00);
+
+	/* New TLB miss handlers and kernel page tables are in now place.
+	 * Make sure that page flags get updated for all pages in TLB by
+	 * flushing the TLB and forcing all TLB entries to be recreated
+	 * from their page table flags.
+	 */
+	flush_tlb_all();
+}
+
+/* References to section boundaries */
+
+extern char _stext, _etext, _edata, __bss_start, _end;
+extern char __init_begin, __init_end;
+
+static int __init free_pages_init(void)
+{
+	int reservedpages, pfn;
+
+	/* this will put all low memory onto the freelists */
+	totalram_pages = free_all_bootmem();
+
+	reservedpages = 0;
+	for (pfn = 0; pfn < max_low_pfn; pfn++) {
+		/*
+		 * Only count reserved RAM pages
+		 */
+		if (PageReserved(mem_map + pfn))
+			reservedpages++;
+	}
+
+	return reservedpages;
+}
+
+static void __init set_max_mapnr_init(void)
+{
+	max_mapnr = num_physpages = max_low_pfn;
+}
+
+void __init mem_init(void)
+{
+	int codesize, reservedpages, datasize, initsize;
+
+	if (!mem_map)
+		BUG();
+
+	set_max_mapnr_init();
+
+	high_memory = (void *)__va(max_low_pfn * PAGE_SIZE);
+
+	/* clear the zero-page */
+	memset((void *)empty_zero_page, 0, PAGE_SIZE);
+
+	reservedpages = free_pages_init();
+
+	codesize = (unsigned long)&_etext - (unsigned long)&_stext;
+	datasize = (unsigned long)&_edata - (unsigned long)&_etext;
+	initsize = (unsigned long)&__init_end - (unsigned long)&__init_begin;
+
+	printk(KERN_INFO
+	       "Memory: %luk/%luk available (%dk kernel code, %dk reserved, %dk data, %dk init, %ldk highmem)\n",
+	       (unsigned long)nr_free_pages() << (PAGE_SHIFT - 10),
+	       max_mapnr << (PAGE_SHIFT - 10), codesize >> 10,
+	       reservedpages << (PAGE_SHIFT - 10), datasize >> 10,
+	       initsize >> 10, (unsigned long)(0 << (PAGE_SHIFT - 10))
+	    );
+
+	printk("mem_init_done ...........................................\n");
+	mem_init_done = 1;
+	return;
+}
+
+#ifdef CONFIG_BLK_DEV_INITRD
+void free_initrd_mem(unsigned long start, unsigned long end)
+{
+	printk(KERN_INFO "Freeing initrd memory: %ldk freed\n",
+	       (end - start) >> 10);
+
+	for (; start < end; start += PAGE_SIZE) {
+		ClearPageReserved(virt_to_page(start));
+		init_page_count(virt_to_page(start));
+		free_page(start);
+		totalram_pages++;
+	}
+}
+#endif
+
+void free_initmem(void)
+{
+	unsigned long addr;
+
+	addr = (unsigned long)(&__init_begin);
+	for (; addr < (unsigned long)(&__init_end); addr += PAGE_SIZE) {
+		ClearPageReserved(virt_to_page(addr));
+		init_page_count(virt_to_page(addr));
+		free_page(addr);
+		totalram_pages++;
+	}
+	printk(KERN_INFO "Freeing unused kernel memory: %luk freed\n",
+	       ((unsigned long)&__init_end -
+		(unsigned long)&__init_begin) >> 10);
+}
diff --git a/arch/openrisc/mm/ioremap.c b/arch/openrisc/mm/ioremap.c
new file mode 100644
index 0000000..5e12976
--- /dev/null
+++ b/arch/openrisc/mm/ioremap.c
@@ -0,0 +1,113 @@
+/*
+ * OpenRISC ioremap.c
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * Modifications for the OpenRISC architecture:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/vmalloc.h>
+#include <linux/io.h>
+#include <asm/pgalloc.h>
+#include <asm/kmap_types.h>
+#include <asm/fixmap.h>
+#include <asm/bug.h>
+#include <asm/pgtable.h>
+#include <linux/sched.h>
+#include <asm/tlbflush.h>
+
+extern int mem_init_done;
+
+static unsigned int fixmaps_used __initdata;
+
+/*
+ * Remap an arbitrary physical address space into the kernel virtual
+ * address space. Needed when the kernel wants to access high addresses
+ * directly.
+ *
+ * NOTE! We need to allow non-page-aligned mappings too: we will obviously
+ * have to convert them into an offset in a page-aligned mapping, but the
+ * caller shouldn't need to know that small detail.
+ */
+void __iomem* __init_refok
+__ioremap(phys_addr_t addr, unsigned long size, unsigned long flags)
+{
+	phys_addr_t p;
+	unsigned long v;
+	unsigned long offset, last_addr;
+	struct vm_struct *area = NULL;
+	pgprot_t prot;
+
+	/* Don't allow wraparound or zero size */
+	last_addr = addr + size - 1;
+	if (!size || last_addr < addr)
+		return NULL;
+
+	/*
+	 * Mappings have to be page-aligned
+	 */
+	offset = addr & ~PAGE_MASK;
+	p = addr & PAGE_MASK;
+	size = PAGE_ALIGN(last_addr+1) - p;
+
+	if (likely (mem_init_done)) {
+		area = get_vm_area(size, VM_IOREMAP);
+		if (!area)
+			return NULL;
+		v = (unsigned long) area->addr;
+	} else {
+		if ((fixmaps_used + (size >> PAGE_SHIFT)) > FIX_N_IOREMAPS)
+			return NULL;
+		v = fix_to_virt(FIX_IOREMAP_BEGIN+fixmaps_used);
+		fixmaps_used += (size >> PAGE_SHIFT);
+	}
+
+	prot = __pgprot(_PAGE_ALL | _PAGE_SRE | _PAGE_SWE |
+			_PAGE_SHARED | _PAGE_DIRTY | _PAGE_EXEC | flags);
+
+	if (ioremap_page_range(v, v + size, p, prot)) {
+		if (likely(mem_init_done))
+			vfree(area->addr);
+		else
+			fixmaps_used -= (size >> PAGE_SHIFT);
+		return NULL;
+	}
+
+
+	return (void __iomem *) (offset + (char *)v);
+}
+
+void iounmap(void *addr)
+{
+	/* If the page is from the fixmap pool then we just clear out
+	 * the fixmap mapping.
+	 */
+	if (unlikely((unsigned long)addr > FIXADDR_START)) {
+		/* This is a bit broken... we don't really know
+		 * how big the area is so it's difficult to know
+		 * how many fixed pages to invalidate...
+		 * just flush tlb and hope for the best...
+		 * consider this a FIXME
+		 *
+		 * Really we should be clearing out one or more page
+		 * table entries for these virtual addresses so that
+		 * future references cause a page fault... for now, we
+		 * rely on two things:
+		 *   i)  this code never gets called on known boards
+		 *   ii) invalid accesses to the freed areas aren't made
+		 */
+		flush_tlb_all();
+		return;
+	}
+
+	return vfree((void *) (PAGE_MASK & (unsigned long) addr));
+}
diff --git a/arch/openrisc/mm/tlb.c b/arch/openrisc/mm/tlb.c
new file mode 100644
index 0000000..498f29b
--- /dev/null
+++ b/arch/openrisc/mm/tlb.c
@@ -0,0 +1,191 @@
+/*
+ * OpenRISC tlb.c
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * Modifications for the OpenRISC architecture:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Julius Baxter <julius.baxter@orsoc.se>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/ptrace.h>
+#include <linux/mman.h>
+#include <linux/mm.h>
+#include <linux/init.h>
+
+#include <asm/system.h>
+#include <asm/segment.h>
+#include <asm/tlbflush.h>
+#include <asm/pgtable.h>
+#include <asm/mmu_context.h>
+#include <asm/spr_defs.h>
+
+#define NO_CONTEXT -1
+
+#define NUM_DTLB_SETS (1 << ((mfspr(SPR_IMMUCFGR) & SPR_IMMUCFGR_NTS) >> \
+			    SPR_DMMUCFGR_NTS_OFF))
+#define NUM_ITLB_SETS (1 << ((mfspr(SPR_IMMUCFGR) & SPR_IMMUCFGR_NTS) >> \
+			    SPR_IMMUCFGR_NTS_OFF))
+#define DTLB_OFFSET(addr) (((addr) >> PAGE_SHIFT) & (NUM_DTLB_SETS-1))
+#define ITLB_OFFSET(addr) (((addr) >> PAGE_SHIFT) & (NUM_ITLB_SETS-1))
+/*
+ * Invalidate all TLB entries.
+ *
+ * This comes down to setting the 'valid' bit for all xTLBMR registers to 0.
+ * Easiest way to accomplish this is to just zero out the xTLBMR register
+ * completely.
+ *
+ */
+
+void flush_tlb_all(void)
+{
+	int i;
+	unsigned long num_tlb_sets;
+
+	/* Determine number of sets for IMMU. */
+	/* FIXME: Assumption is I & D nsets equal. */
+	num_tlb_sets = NUM_ITLB_SETS;
+
+	for (i = 0; i < num_tlb_sets; i++) {
+		mtspr_off(SPR_DTLBMR_BASE(0), i, 0);
+		mtspr_off(SPR_ITLBMR_BASE(0), i, 0);
+	}
+}
+
+#define have_dtlbeir (mfspr(SPR_DMMUCFGR) & SPR_DMMUCFGR_TEIRI)
+#define have_itlbeir (mfspr(SPR_IMMUCFGR) & SPR_IMMUCFGR_TEIRI)
+
+/*
+ * Invalidate a single page.  This is what the xTLBEIR register is for.
+ *
+ * There's no point in checking the vma for PAGE_EXEC to determine whether it's
+ * the data or instruction TLB that should be flushed... that would take more
+ * than the few instructions that the following compiles down to!
+ *
+ * The case where we don't have the xTLBEIR register really only works for
+ * MMU's with a single way and is hard-coded that way.
+ */
+
+#define flush_dtlb_page_eir(addr) mtspr(SPR_DTLBEIR, addr)
+#define flush_dtlb_page_no_eir(addr) mtspr_off(SPR_DTLBMR_BASE(0), DTLB_OFFSET(addr), 0);
+
+#define flush_itlb_page_eir(addr) mtspr(SPR_ITLBEIR, addr)
+#define flush_itlb_page_no_eir(addr) mtspr_off(SPR_ITLBMR_BASE(0), ITLB_OFFSET(addr), 0);
+
+void flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
+{
+	if (have_dtlbeir)
+		flush_dtlb_page_eir(addr);
+	else
+		flush_dtlb_page_no_eir(addr);
+
+	if (have_itlbeir)
+		flush_itlb_page_eir(addr);
+	else
+		flush_itlb_page_no_eir(addr);
+}
+
+void flush_tlb_range(struct vm_area_struct *vma,
+		     unsigned long start, unsigned long end)
+{
+	int addr;
+	bool dtlbeir;
+	bool itlbeir;
+
+	dtlbeir = have_dtlbeir;
+	itlbeir = have_itlbeir;
+
+	for (addr = start; addr < end; addr += PAGE_SIZE) {
+		if (dtlbeir)
+			flush_dtlb_page_eir(addr);
+		else
+			flush_dtlb_page_no_eir(addr);
+
+		if (itlbeir)
+			flush_itlb_page_eir(addr);
+		else
+			flush_itlb_page_no_eir(addr);
+	}
+}
+
+/*
+ * Invalidate the selected mm context only.
+ *
+ * FIXME: Due to some bug here, we're flushing everything for now.
+ * This should be changed to loop over over mm and call flush_tlb_range.
+ */
+
+void flush_tlb_mm(struct mm_struct *mm)
+{
+
+	/* Was seeing bugs with the mm struct passed to us. Scrapped most of
+	   this function. */
+	/* Several architctures do this */
+	flush_tlb_all();
+}
+
+/* called in schedule() just before actually doing the switch_to */
+
+void switch_mm(struct mm_struct *prev, struct mm_struct *next,
+	       struct task_struct *next_tsk)
+{
+	/* remember the pgd for the fault handlers
+	 * this is similar to the pgd register in some other CPU's.
+	 * we need our own copy of it because current and active_mm
+	 * might be invalid at points where we still need to derefer
+	 * the pgd.
+	 */
+	current_pgd = next->pgd;
+
+	/* We don't have context support implemented, so flush all
+	 * entries belonging to previous map
+	 */
+
+	if (prev != next)
+		flush_tlb_mm(prev);
+
+}
+
+/*
+ * Initialize the context related info for a new mm_struct
+ * instance.
+ */
+
+int init_new_context(struct task_struct *tsk, struct mm_struct *mm)
+{
+	mm->context = NO_CONTEXT;
+	return 0;
+}
+
+/* called by __exit_mm to destroy the used MMU context if any before
+ * destroying the mm itself. this is only called when the last user of the mm
+ * drops it.
+ */
+
+void destroy_context(struct mm_struct *mm)
+{
+	flush_tlb_mm(mm);
+
+}
+
+/* called once during VM initialization, from init.c */
+
+void __init tlb_init(void)
+{
+	/* Do nothing... */
+	/* invalidate the entire TLB */
+	/* flush_tlb_all(); */
+}
-- 
1.7.4.1

