Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab1H3TR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 15:17:29 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19586 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363Ab1H3TPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 15:15:22 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6454"; a="114068345"
Message-Id: <20110830190802.462665808@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Aug 2011 14:07:58 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Cc: Linas Vepstas <linas@codeaurora.org>
Subject: [patch v2 29/35] Hexagon: Add page table header files & etc.
References: <20110830190729.923334292@codeaurora.org>
Content-Disposition: inline; filename=pgtables-highmem.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed highmem as we currently don't need it (and it didn't
quite work).

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Signed-off-by: Linas Vepstas <linas@codeaurora.org>

---
 arch/hexagon/include/asm/fixmap.h      |   73 ++++
 arch/hexagon/include/asm/highmem.h     |  111 +++++++
 arch/hexagon/include/asm/mmu.h         |   34 ++
 arch/hexagon/include/asm/mmu_context.h |  100 ++++++
 arch/hexagon/include/asm/page.h        |  157 ++++++++++
 arch/hexagon/include/asm/pgalloc.h     |  146 +++++++++
 arch/hexagon/include/asm/pgtable.h     |  518 +++++++++++++++++++++++++++++++++
 arch/hexagon/mm/pgalloc.c              |   25 +
 8 files changed, 1164 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/include/asm/fixmap.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/fixmap.h	2011-08-25 14:51:46.553968751 -0500
@@ -0,0 +1,73 @@
+/*
+ * Fixmap support for Hexagon - enough to support highmem features
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_FIXMAP_H
+#define _ASM_FIXMAP_H
+
+/*
+ * A lot of the fixmap info is already in mem-layout.h
+ */
+#include <asm/mem-layout.h>
+
+/*
+ * Full fixmap support involves set_fixmap() functions, but
+ * these may not be needed if all we're after is an area for
+ * highmem kernel mappings.
+ */
+#define	__fix_to_virt(x)	(FIXADDR_TOP - ((x) << PAGE_SHIFT))
+#define	__virt_to_fix(x)	((FIXADDR_TOP - ((x)&PAGE_MASK)) >> PAGE_SHIFT)
+
+extern void __this_fixmap_does_not_exist(void);
+
+/**
+ * fix_to_virt -- "index to address" translation.
+ *
+ * If anyone tries to use the idx directly without translation,
+ * we catch the bug with a NULL-deference kernel oops. Illegal
+ * ranges of incoming indices are caught too.
+ */
+static inline unsigned long fix_to_virt(const unsigned int idx)
+{
+	/*
+	 * This branch gets completely eliminated after inlining,
+	 * except when someone tries to use fixaddr indices in an
+	 * illegal way. (such as mixing up address types or using
+	 * out-of-range indices).
+	 *
+	 * If it doesn't get removed, the linker will complain
+	 * loudly with a reasonably clear error message..
+	 */
+	if (idx >= __end_of_fixed_addresses)
+		__this_fixmap_does_not_exist();
+
+	return __fix_to_virt(idx);
+}
+
+static inline unsigned long virt_to_fix(const unsigned long vaddr)
+{
+	BUG_ON(vaddr >= FIXADDR_TOP || vaddr < FIXADDR_START);
+	return __virt_to_fix(vaddr);
+}
+
+#define kmap_get_fixmap_pte(vaddr) \
+	pte_offset_kernel(pmd_offset(pud_offset(pgd_offset_k(vaddr), \
+				(vaddr)), (vaddr)), (vaddr))
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/highmem.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/highmem.h	2011-08-25 14:51:46.553968751 -0500
@@ -0,0 +1,111 @@
+/*
+ * Highmem definitions for the Hexagon architecture
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_HIGHMEM_H
+#define _ASM_HIGHMEM_H
+
+#ifdef __KERNEL__
+
+#include <linux/init.h>
+
+#define NR_TLB_LINES		64
+
+#ifndef __ASSEMBLY__
+
+#include <linux/interrupt.h>
+#include <asm/kmap_types.h>
+#include <asm/pgtable.h>
+#include <asm/fixmap.h>
+
+/*
+ * Indicate the memory range of "high memory";
+ * look at how this changes for noncontig mem configs
+ */
+extern unsigned long highstart_pfn, highend_pfn;
+
+/* Default kmap page protection; used in mm/highmem.c  */
+extern pgprot_t kmap_prot;
+
+#define flush_cache_kmaps()  do { \
+	printk(KERN_INFO "flush_cache_kmaps not implemented yet\n");\
+} while (0)
+
+extern void __init kmap_init(void);
+extern void *kmap_high(struct page *page);   /*  defined in mm/highmem.c  */
+extern void kunmap_high(struct page *page);  /*  defined in mm/highmem.c  */
+
+/* Use the defaults in <linux/highmem.h> if CONFIG_HIGHMEM not set */
+/**
+ * kmap - creates kernel mapping for a page
+ * @page: pointer to page struct (in mem_map)
+ *
+ * Looks like this routine checks to see if the page is actually in the
+ * highmem range in the first place; if not, then it gives the
+ * logical/virtual address of the page back.
+ *
+ * Otherwise it calls kmap_high, which returns the logical address of
+ * the newly mapped highmem page.  The code seems to indicate that ALL
+ * kmaps go into the "permanent kernel mapping" array, which is a static
+ * size array.
+ *
+ * This code repeatedly calls page_address over and over again.
+ * XXX Todo: fix the above ...
+ *
+ * The map_new_virtual call is the guy that actually "flushes zero pkmaps"
+ * when it searches for a free kmap slot.  If it doesn't find one, then it
+ * sleeps in a waitqueue.
+ *
+ * A pkmap_count of 1 means "need flush".
+ * A pkmap_count of 0 means it's available.
+ */
+extern void *kmap_hexagon(struct page *page);
+#define kmap(p)		kmap_hexagon((p))
+
+/**
+ * kunmap - unmaps a kernel mapping
+ * @page: pointer to page struct
+ *
+ * If it's not in highmem, then you ain't unmapping anybody.
+ *
+ * If it is in highmem, it calls kunmap_high, which magically
+ * removes the mapping or something.  Seems to only decrement pkmap_count
+ * for the page.  If the pkmap_count was decremented to 1, that means it's
+ * ready to be flushed.
+ *
+ * It also is responsible for waking anybody up that was waiting for a kmap
+ * to free up.
+ */
+extern void kunmap_hexagon(struct page *page);
+#define kunmap(p)	kunmap_hexagon((p))
+
+extern struct page *kmap_atomic_to_page_hexagon(void *ptr);
+#define kmap_atomic_to_page(p)	kmap_atomic_to_page_hexagon((p))
+
+extern void *kmap_atomic_prot(struct page *page, pgprot_t prot);
+extern void __kunmap_atomic(void *);
+
+static inline void *__kmap_atomic(struct page *page)
+{
+	return kmap_atomic_prot(page, kmap_prot);
+}
+
+#endif /* !__ASSEMBLY__ */
+#endif /* __KERNEL__ */
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/mmu_context.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/mmu_context.h	2011-08-25 14:51:46.553968751 -0500
@@ -0,0 +1,100 @@
+/*
+ * MM context support for the Hexagon architecture
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_MMU_CONTEXT_H
+#define _ASM_MMU_CONTEXT_H
+
+#include <asm/setup.h>
+#include <asm/page.h>
+#include <asm/pgalloc.h>
+#include <asm/mem-layout.h>
+
+static inline void destroy_context(struct mm_struct *mm)
+{
+}
+
+/*
+ * VM port hides all TLB management, so "lazy TLB" isn't very
+ * meaningful.  Even for ports to architectures with visble TLBs,
+ * this is almost invariably a null function.
+ */
+static inline void enter_lazy_tlb(struct mm_struct *mm,
+	struct task_struct *tsk)
+{
+}
+
+/*
+ * Architecture-specific actions, if any, for memory map deactivation.
+ */
+static inline void deactivate_mm(struct task_struct *tsk,
+	struct mm_struct *mm)
+{
+}
+
+/**
+ * init_new_context - initialize context related info for new mm_struct instance
+ * @tsk: pointer to a task struct
+ * @mm: pointer to a new mm struct
+ */
+static inline int init_new_context(struct task_struct *tsk,
+					struct mm_struct *mm)
+{
+	/* mm->context is set up by pgd_alloc */
+	return 0;
+}
+
+/*
+ *  Switch active mm context
+ */
+static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
+				struct task_struct *tsk)
+{
+	int l1;
+
+	/*
+	 * For virtual machine, we have to update system map if it's been
+	 * touched.
+	 */
+	if (next->context.generation < prev->context.generation) {
+		for (l1 = MIN_KERNEL_SEG; l1 <= max_kernel_seg; l1++)
+			next->pgd[l1] = init_mm.pgd[l1];
+
+		next->context.generation = prev->context.generation;
+	}
+
+	__vmnewmap((void *)next->context.ptbase);
+}
+
+/*
+ *  Activate new memory map for task
+ */
+static inline void activate_mm(struct mm_struct *prev, struct mm_struct *next)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	switch_mm(prev, next, current_thread_info()->task);
+	local_irq_restore(flags);
+}
+
+/*  Generic hooks for arch_dup_mmap and arch_exit_mmap  */
+#include <asm-generic/mm_hooks.h>
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/mmu.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/mmu.h	2011-08-25 14:51:46.553968751 -0500
@@ -0,0 +1,34 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_MMU_H
+#define _ASM_MMU_H
+
+/*
+ * Architecture-specific state for a mm_struct.
+ * For the Hexagon Virtual Machine, it can be a copy
+ * of the pointer to the page table base.
+ */
+struct mm_context {
+	unsigned long long generation;
+	unsigned long ptbase;
+};
+
+typedef struct mm_context mm_context_t;
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/page.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/page.h	2011-08-25 14:51:46.563968765 -0500
@@ -0,0 +1,157 @@
+/*
+ * Page management definitions for the Hexagon architecture
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_PAGE_H
+#define _ASM_PAGE_H
+
+#include <linux/const.h>
+
+/*  This is probably not the most graceful way to handle this.  */
+
+#ifdef CONFIG_PAGE_SIZE_4KB
+#define PAGE_SHIFT 12
+#define HEXAGON_L1_PTE_SIZE __HVM_PDE_S_4KB
+#endif
+
+#ifdef CONFIG_PAGE_SIZE_16KB
+#define PAGE_SHIFT 14
+#define HEXAGON_L1_PTE_SIZE __HVM_PDE_S_16KB
+#endif
+
+#ifdef CONFIG_PAGE_SIZE_64KB
+#define PAGE_SHIFT 16
+#define HEXAGON_L1_PTE_SIZE __HVM_PDE_S_64KB
+#endif
+
+#ifdef CONFIG_PAGE_SIZE_256KB
+#define PAGE_SHIFT 18
+#define HEXAGON_L1_PTE_SIZE __HVM_PDE_S_256KB
+#endif
+
+#ifdef CONFIG_PAGE_SIZE_1MB
+#define PAGE_SHIFT 20
+#define HEXAGON_L1_PTE_SIZE __HVM_PDE_S_1MB
+#endif
+
+/*
+ *  These should be defined in hugetlb.h, but apparently not.
+ *  "Huge" for us should be 4MB or 16MB, which are both represented
+ *  in L1 PTE's.  Right now, it's set up for 4MB.
+ */
+#ifdef CONFIG_HUGETLB_PAGE
+#define HPAGE_SHIFT 22
+#define HPAGE_SIZE (1UL << HPAGE_SHIFT)
+#define HPAGE_MASK (~(HPAGE_SIZE-1))
+#define HUGETLB_PAGE_ORDER (HPAGE_SHIFT-PAGE_SHIFT)
+#define HVM_HUGEPAGE_SIZE 0x5
+#endif
+
+#define PAGE_SIZE  (1UL << PAGE_SHIFT)
+#define PAGE_MASK  (~((1 << PAGE_SHIFT) - 1))
+
+#ifdef __KERNEL__
+#ifndef __ASSEMBLY__
+
+/*
+ * This is for PFN_DOWN, which mm.h needs.  Seems the right place to pull it in.
+ */
+#include <linux/pfn.h>
+
+/*
+ * We implement a two-level architecture-specific page table structure.
+ * Null intermediate page table level (pmd, pud) definitions will come from
+ * asm-generic/pagetable-nopmd.h and asm-generic/pagetable-nopud.h
+ */
+typedef struct { unsigned long pte; } pte_t;
+typedef struct { unsigned long pgd; } pgd_t;
+typedef struct { unsigned long pgprot; } pgprot_t;
+typedef struct page *pgtable_t;
+
+#define pte_val(x)     ((x).pte)
+#define pgd_val(x)     ((x).pgd)
+#define pgprot_val(x)  ((x).pgprot)
+#define __pte(x)       ((pte_t) { (x) })
+#define __pgd(x)       ((pgd_t) { (x) })
+#define __pgprot(x)    ((pgprot_t) { (x) })
+
+/*
+ * We need a __pa and a __va routine for kernel space.
+ * MIPS says they're only used during mem_init.
+ * also, check if we need a PHYS_OFFSET.
+ */
+#define __pa(x) ((unsigned long)(x) - PAGE_OFFSET)
+#define __va(x) ((void *)((unsigned long)(x) + PAGE_OFFSET))
+
+/* The "page frame" descriptor is defined in linux/mm.h */
+struct page;
+
+/* Returns page frame descriptor for virtual address. */
+#define virt_to_page(kaddr) pfn_to_page(PFN_DOWN(__pa(kaddr)))
+
+/* Default vm area behavior seems to be full access  */
+#define VM_DATA_DEFAULT_FLAGS (VM_READ | VM_WRITE | VM_EXEC | \
+				VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+
+#define pfn_valid(pfn) ((pfn) < max_mapnr)
+#define virt_addr_valid(kaddr) pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
+
+/*  Need to not use a define for linesize; may move this to another file.  */
+static inline void clear_page(void *page)
+{
+	/*  This can only be done on pages with L1 WB cache */
+	asm volatile(
+		"	loop0(1f,%1);\n"
+		"1:	{ dczeroa(%0);\n"
+		"	  %0 = add(%0,#32); }:endloop0\n"
+		: "+r" (page)
+		: "r" (PAGE_SIZE/32)
+		: "lc0", "sa0", "memory"
+	);
+}
+
+#define copy_page(to, from)	memcpy((to), (from), PAGE_SIZE)
+
+/*
+ * Under assumption that kernel always "sees" user map...
+ */
+#define clear_user_page(page, vaddr, pg)	clear_page(page)
+#define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
+
+/*
+ * page_to_phys - convert page to physical address
+ * @page - pointer to page entry in mem_map
+ */
+#define page_to_phys(page)      (page_to_pfn(page) << PAGE_SHIFT)
+
+/*
+ * For port to Hexagon Virtual Machine, MAYBE we check for attempts
+ * to reference reserved HVM space, but in any case, the VM will be
+ * protected.
+ */
+#define kern_addr_valid(addr)   (1)
+
+#include <asm-generic/memory_model.h>
+/* XXX Todo: implement assembly-optimized version of getorder. */
+#include <asm-generic/getorder.h>
+
+#endif /* ifdef __ASSEMBLY__ */
+#endif /* ifdef __KERNEL__ */
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/pgalloc.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/pgalloc.h	2011-08-25 14:51:46.563968765 -0500
@@ -0,0 +1,146 @@
+/*
+ * Page table support for the Hexagon architecture
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_PGALLOC_H
+#define _ASM_PGALLOC_H
+
+#include <asm/mem-layout.h>
+#include <asm/atomic.h>
+
+#define check_pgt_cache() do {} while (0)
+
+extern unsigned long long kmap_generation;
+
+/*
+ * Page table creation interface
+ */
+static inline pgd_t *pgd_alloc(struct mm_struct *mm)
+{
+	pgd_t *pgd;
+
+	pgd = (pgd_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+
+	/*
+	 * There may be better ways to do this, but to ensure
+	 * that new address spaces always contain the kernel
+	 * base mapping, and to ensure that the user area is
+	 * initially marked invalid, initialize the new map
+	 * map with a copy of the kernel's persistent map.
+	 */
+
+	memcpy(pgd, swapper_pg_dir, PTRS_PER_PGD*sizeof(pgd_t *));
+	mm->context.generation = kmap_generation;
+
+	/* Physical version is what is passed to virtual machine on switch */
+	mm->context.ptbase = __pa(pgd);
+
+	return pgd;
+}
+
+static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
+{
+	free_page((unsigned long) pgd);
+}
+
+static inline struct page *pte_alloc_one(struct mm_struct *mm,
+					 unsigned long address)
+{
+	struct page *pte;
+
+	pte = alloc_page(GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO);
+
+	if (pte)
+		pgtable_page_ctor(pte);
+
+	return pte;
+}
+
+/* _kernel variant gets to use a different allocator */
+static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
+					  unsigned long address)
+{
+	gfp_t flags =  GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO;
+	return (pte_t *) __get_free_page(flags);
+}
+
+static inline void pte_free(struct mm_struct *mm, struct page *pte)
+{
+	pgtable_page_dtor(pte);
+	__free_page(pte);
+}
+
+static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
+{
+	free_page((unsigned long)pte);
+}
+
+static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
+				pgtable_t pte)
+{
+	/*
+	 * Conveniently, zero in 3 LSB means indirect 4K page table.
+	 * Not so convenient when you're trying to vary the page size.
+	 */
+	set_pmd(pmd, __pmd(((unsigned long)page_to_pfn(pte) << PAGE_SHIFT) |
+		HEXAGON_L1_PTE_SIZE));
+}
+
+/*
+ * Other architectures seem to have ways of making all processes
+ * share the same pmd's for their kernel mappings, but the v0.3
+ * Hexagon VM spec has a "monolithic" L1 table for user and kernel
+ * segments.  We track "generations" of the kernel map to minimize
+ * overhead, and update the "slave" copies of the kernel mappings
+ * as part of switch_mm.  However, we still need to update the
+ * kernel map of the active thread who's calling pmd_populate_kernel...
+ */
+static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd,
+				       pte_t *pte)
+{
+	extern spinlock_t kmap_gen_lock;
+	pmd_t *ppmd;
+	int pmdindex;
+
+	spin_lock(&kmap_gen_lock);
+	kmap_generation++;
+	mm->context.generation = kmap_generation;
+	current->active_mm->context.generation = kmap_generation;
+	spin_unlock(&kmap_gen_lock);
+
+	set_pmd(pmd, __pmd(((unsigned long)__pa(pte)) | HEXAGON_L1_PTE_SIZE));
+
+	/*
+	 * Now the "slave" copy of the current thread.
+	 * This is pointer arithmetic, not byte addresses!
+	 */
+	pmdindex = (pgd_t *)pmd - mm->pgd;
+	ppmd = (pmd_t *)current->active_mm->pgd + pmdindex;
+	set_pmd(ppmd, __pmd(((unsigned long)__pa(pte)) | HEXAGON_L1_PTE_SIZE));
+	if (pmdindex > max_kernel_seg)
+		max_kernel_seg = pmdindex;
+}
+
+#define __pte_free_tlb(tlb, pte, addr)		\
+do {						\
+	pgtable_page_dtor((pte));		\
+	tlb_remove_page((tlb), (pte));		\
+} while (0)
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/pgtable.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/pgtable.h	2011-08-25 16:02:15.099105924 -0500
@@ -0,0 +1,518 @@
+/*
+ * Page table support for the Hexagon architecture
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_PGTABLE_H
+#define _ASM_PGTABLE_H
+
+/*
+ * Page table definitions for Qualcomm Hexagon processor.
+ */
+#include <linux/swap.h>
+#include <asm/page.h>
+#include <asm-generic/pgtable-nopmd.h>
+
+/* A handy thing to have if one has the RAM. Declared in head.S */
+extern unsigned long empty_zero_page;
+extern unsigned long zero_page_mask;
+
+/*
+ * The PTE model described here is that of the Hexagon Virtual Machine,
+ * which autonomously walks 2-level page tables.  At a lower level, we
+ * also describe the RISCish software-loaded TLB entry structure of
+ * the underlying Hexagon processor. A kernel built to run on the
+ * virtual machine has no need to know about the underlying hardware.
+ */
+#include <asm/vm_mmu.h>
+
+/*
+ * To maximize the comfort level for the PTE manipulation macros,
+ * define the "well known" architecture-specific bits.
+ */
+#define _PAGE_READ	__HVM_PTE_R
+#define _PAGE_WRITE	__HVM_PTE_W
+#define _PAGE_EXECUTE	__HVM_PTE_X
+#define _PAGE_USER	__HVM_PTE_U
+
+/*
+ * We have a total of 4 "soft" bits available in the abstract PTE.
+ * The two mandatory software bits are Dirty and Accessed.
+ * To make nonlinear swap work according to the more recent
+ * model, we want a low order "Present" bit to indicate whether
+ * the PTE describes MMU programming or swap space.
+ */
+#define _PAGE_PRESENT	(1<<0)
+#define _PAGE_DIRTY	(1<<1)
+#define _PAGE_ACCESSED	(1<<2)
+
+/*
+ * _PAGE_FILE is only meaningful if _PAGE_PRESENT is false, while
+ * _PAGE_DIRTY is only meaningful if _PAGE_PRESENT is true.
+ * So we can overload the bit...
+ */
+#define _PAGE_FILE	_PAGE_DIRTY /* set:  pagecache, unset = swap */
+
+/*
+ * For now, let's say that Valid and Present are the same thing.
+ * Alternatively, we could say that it's the "or" of R, W, and X
+ * permissions.
+ */
+#define _PAGE_VALID	_PAGE_PRESENT
+
+/*
+ * We're not defining _PAGE_GLOBAL here, since there's no concept
+ * of global pages or ASIDs exposed to the Hexagon Virtual Machine,
+ * and we want to use the same page table structures and macros in
+ * the native kernel as we do in the virtual machine kernel.
+ * So we'll put up with a bit of inefficiency for now...
+ */
+
+/*
+ * Top "FOURTH" level (pgd), which for the Hexagon VM is really
+ * only the second from the bottom, pgd and pud both being collapsed.
+ * Each entry represents 4MB of virtual address space, 4K of table
+ * thus maps the full 4GB.
+ */
+#define PGDIR_SHIFT 22
+#define PTRS_PER_PGD 1024
+
+#define PGDIR_SIZE (1UL << PGDIR_SHIFT)
+#define PGDIR_MASK (~(PGDIR_SIZE-1))
+
+#ifdef CONFIG_PAGE_SIZE_4KB
+#define PTRS_PER_PTE 1024
+#endif
+
+#ifdef CONFIG_PAGE_SIZE_16KB
+#define PTRS_PER_PTE 256
+#endif
+
+#ifdef CONFIG_PAGE_SIZE_64KB
+#define PTRS_PER_PTE 64
+#endif
+
+#ifdef CONFIG_PAGE_SIZE_256KB
+#define PTRS_PER_PTE 16
+#endif
+
+#ifdef CONFIG_PAGE_SIZE_1MB
+#define PTRS_PER_PTE 4
+#endif
+
+/*  Any bigger and the PTE disappears.  */
+#define pgd_ERROR(e) \
+	printk(KERN_ERR "%s:%d: bad pgd %08lx.\n", __FILE__, __LINE__,\
+		pgd_val(e))
+
+/*
+ * Page Protection Constants. Includes (in this variant) cache attributes.
+ */
+extern unsigned long _dflt_cache_att;
+
+#define PAGE_NONE	__pgprot(_PAGE_PRESENT | _PAGE_USER | \
+				_dflt_cache_att)
+#define PAGE_READONLY	__pgprot(_PAGE_PRESENT | _PAGE_USER | \
+				_PAGE_READ | _PAGE_EXECUTE | _dflt_cache_att)
+#define PAGE_COPY	PAGE_READONLY
+#define PAGE_EXEC	__pgprot(_PAGE_PRESENT | _PAGE_USER | \
+				_PAGE_READ | _PAGE_EXECUTE | _dflt_cache_att)
+#define PAGE_COPY_EXEC	PAGE_EXEC
+#define PAGE_SHARED	__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_READ | \
+				_PAGE_EXECUTE | _PAGE_WRITE | _dflt_cache_att)
+#define PAGE_KERNEL	__pgprot(_PAGE_PRESENT | _PAGE_READ | \
+				_PAGE_WRITE | _PAGE_EXECUTE | _dflt_cache_att)
+
+
+/*
+ * Aliases for mapping mmap() protection bits to page protections.
+ * These get used for static initialization, so using the _dflt_cache_att
+ * variable for the default cache attribute isn't workable. If the
+ * default gets changed at boot time, the boot option code has to
+ * update data structures like the protaction_map[] array.
+ */
+#define CACHEDEF	(CACHE_DEFAULT << 6)
+
+/* Private (copy-on-write) page protections. */
+#define __P000 __pgprot(_PAGE_PRESENT | _PAGE_USER | CACHEDEF)
+#define __P001 __pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_READ | CACHEDEF)
+#define __P010 __P000	/* Write-only copy-on-write */
+#define __P011 __P001	/* Read/Write copy-on-write */
+#define __P100 __pgprot(_PAGE_PRESENT | _PAGE_USER | \
+			_PAGE_EXECUTE | CACHEDEF)
+#define __P101 __pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_EXECUTE | \
+			_PAGE_READ | CACHEDEF)
+#define __P110 __P100	/* Write/execute copy-on-write */
+#define __P111 __P101	/* Read/Write/Execute, copy-on-write */
+
+/* Shared page protections. */
+#define __S000 __P000
+#define __S001 __P001
+#define __S010 __pgprot(_PAGE_PRESENT | _PAGE_USER | \
+			_PAGE_WRITE | CACHEDEF)
+#define __S011 __pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_READ | \
+			_PAGE_WRITE | CACHEDEF)
+#define __S100 __pgprot(_PAGE_PRESENT | _PAGE_USER | \
+			_PAGE_EXECUTE | CACHEDEF)
+#define __S101 __P101
+#define __S110 __pgprot(_PAGE_PRESENT | _PAGE_USER | \
+			_PAGE_EXECUTE | _PAGE_WRITE | CACHEDEF)
+#define __S111 __pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_READ | \
+			_PAGE_EXECUTE | _PAGE_WRITE | CACHEDEF)
+
+extern pgd_t swapper_pg_dir[PTRS_PER_PGD];  /* located in head.S */
+
+/* Seems to be zero even in architectures where the zero page is firewalled? */
+#define FIRST_USER_ADDRESS 0
+#define pte_special(pte)	0
+#define pte_mkspecial(pte)	(pte)
+
+/*  HUGETLB not working currently  */
+#ifdef CONFIG_HUGETLB_PAGE
+#define pte_mkhuge(pte) __pte((pte_val(pte) & ~0x3) | HVM_HUGEPAGE_SIZE)
+#endif
+
+/*
+ * For now, assume that higher-level code will do TLB/MMU invalidations
+ * and don't insert that overhead into this low-level function.
+ */
+extern void sync_icache_dcache(pte_t pte);
+
+#define pte_present_exec_user(pte) \
+	((pte_val(pte) & (_PAGE_EXECUTE | _PAGE_USER)) == \
+	(_PAGE_EXECUTE | _PAGE_USER))
+
+static inline void set_pte(pte_t *ptep, pte_t pteval)
+{
+	/*  should really be using pte_exec, if it weren't declared later. */
+	if (pte_present_exec_user(pteval))
+		sync_icache_dcache(pteval);
+
+	*ptep = pteval;
+}
+
+/*
+ * For the Hexagon Virtual Machine MMU (or its emulation), a null/invalid
+ * L1 PTE (PMD/PGD) has 7 in the least significant bits. For the L2 PTE
+ * (Linux PTE), the key is to have bits 11..9 all zero.  We'd use 0x7
+ * as a universal null entry, but some of those least significant bits
+ * are interpreted by software.
+ */
+#define _NULL_PMD	0x7
+#define _NULL_PTE	0x0
+
+static inline void pmd_clear(pmd_t *pmd_entry_ptr)
+{
+	 pmd_val(*pmd_entry_ptr) = _NULL_PMD;
+}
+
+/*
+ * Conveniently, a null PTE value is invalid.
+ */
+static inline void pte_clear(struct mm_struct *mm, unsigned long addr,
+				pte_t *ptep)
+{
+	pte_val(*ptep) = _NULL_PTE;
+}
+
+#ifdef NEED_PMD_INDEX_DESPITE_BEING_2_LEVEL
+/**
+ * pmd_index - returns the index of the entry in the PMD page
+ * which would control the given virtual address
+ */
+#define pmd_index(address) (((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
+
+#endif
+
+/**
+ * pgd_index - returns the index of the entry in the PGD page
+ * which would control the given virtual address
+ *
+ * This returns the *index* for the address in the pgd_t
+ */
+#define pgd_index(address) (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
+
+/*
+ * pgd_offset - find an offset in a page-table-directory
+ */
+#define pgd_offset(mm, addr) ((mm)->pgd + pgd_index(addr))
+
+/*
+ * pgd_offset_k - get kernel (init_mm) pgd entry pointer for addr
+ */
+#define pgd_offset_k(address) pgd_offset(&init_mm, address)
+
+/**
+ * pmd_none - check if pmd_entry is mapped
+ * @pmd_entry:  pmd entry
+ *
+ * MIPS checks it against that "invalid pte table" thing.
+ */
+static inline int pmd_none(pmd_t pmd)
+{
+	return pmd_val(pmd) == _NULL_PMD;
+}
+
+/**
+ * pmd_present - is there a page table behind this?
+ * Essentially the inverse of pmd_none.  We maybe
+ * save an inline instruction by defining it this
+ * way, instead of simply "!pmd_none".
+ */
+static inline int pmd_present(pmd_t pmd)
+{
+	return pmd_val(pmd) != (unsigned long)_NULL_PMD;
+}
+
+/**
+ * pmd_bad - check if a PMD entry is "bad". That might mean swapped out.
+ * As we have no known cause of badness, it's null, as it is for many
+ * architectures.
+ */
+static inline int pmd_bad(pmd_t pmd)
+{
+	return 0;
+}
+
+/*
+ * pmd_page - converts a PMD entry to a page pointer
+ */
+#define pmd_page(pmd)  (pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT))
+#define pmd_pgtable(pmd) pmd_page(pmd)
+
+/**
+ * pte_none - check if pte is mapped
+ * @pte: pte_t entry
+ */
+static inline int pte_none(pte_t pte)
+{
+	return pte_val(pte) == _NULL_PTE;
+};
+
+/*
+ * pte_present - check if page is present
+ */
+static inline int pte_present(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_PRESENT;
+}
+
+/* mk_pte - make a PTE out of a page pointer and protection bits */
+#define mk_pte(page, pgprot) pfn_pte(page_to_pfn(page), (pgprot))
+
+/* pte_page - returns a page (frame pointer/descriptor?) based on a PTE */
+#define pte_page(x) pfn_to_page(pte_pfn(x))
+
+/* pte_mkold - mark PTE as not recently accessed */
+static inline pte_t pte_mkold(pte_t pte)
+{
+	pte_val(pte) &= ~_PAGE_ACCESSED;
+	return pte;
+}
+
+/* pte_mkyoung - mark PTE as recently accessed */
+static inline pte_t pte_mkyoung(pte_t pte)
+{
+	pte_val(pte) |= _PAGE_ACCESSED;
+	return pte;
+}
+
+/* pte_mkclean - mark page as in sync with backing store */
+static inline pte_t pte_mkclean(pte_t pte)
+{
+	pte_val(pte) &= ~_PAGE_DIRTY;
+	return pte;
+}
+
+/* pte_mkdirty - mark page as modified */
+static inline pte_t pte_mkdirty(pte_t pte)
+{
+	pte_val(pte) |= _PAGE_DIRTY;
+	return pte;
+}
+
+/* pte_young - "is PTE marked as accessed"? */
+static inline int pte_young(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_ACCESSED;
+}
+
+/* pte_dirty - "is PTE dirty?" */
+static inline int pte_dirty(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_DIRTY;
+}
+
+/* pte_modify - set protection bits on PTE */
+static inline pte_t pte_modify(pte_t pte, pgprot_t prot)
+{
+	pte_val(pte) &= PAGE_MASK;
+	pte_val(pte) |= pgprot_val(prot);
+	return pte;
+}
+
+/* pte_wrprotect - mark page as not writable */
+static inline pte_t pte_wrprotect(pte_t pte)
+{
+	pte_val(pte) &= ~_PAGE_WRITE;
+	return pte;
+}
+
+/* pte_mkwrite - mark page as writable */
+static inline pte_t pte_mkwrite(pte_t pte)
+{
+	pte_val(pte) |= _PAGE_WRITE;
+	return pte;
+}
+
+/* pte_mkexec - mark PTE as executable */
+static inline pte_t pte_mkexec(pte_t pte)
+{
+	pte_val(pte) |= _PAGE_EXECUTE;
+	return pte;
+}
+
+/* pte_read - "is PTE marked as readable?" */
+static inline int pte_read(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_READ;
+}
+
+/* pte_write - "is PTE marked as writable?" */
+static inline int pte_write(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_WRITE;
+}
+
+
+/* pte_exec - "is PTE marked as executable?" */
+static inline int pte_exec(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_EXECUTE;
+}
+
+/* __pte_to_swp_entry - extract swap entry from PTE */
+#define __pte_to_swp_entry(pte) ((swp_entry_t) { pte_val(pte) })
+
+/* __swp_entry_to_pte - extract PTE from swap entry */
+#define __swp_entry_to_pte(x) ((pte_t) { (x).val })
+
+/* pfn_pte - convert page number and protection value to page table entry */
+#define pfn_pte(pfn, pgprot) __pte((pfn << PAGE_SHIFT) | pgprot_val(pgprot))
+
+/* pte_pfn - convert pte to page frame number */
+#define pte_pfn(pte) (pte_val(pte) >> PAGE_SHIFT)
+#define set_pmd(pmdptr, pmdval) (*(pmdptr) = (pmdval))
+
+/*
+ * set_pte_at - update page table and do whatever magic may be
+ * necessary to make the underlying hardware/firmware take note.
+ *
+ * VM may require a virtual instruction to alert the MMU.
+ */
+#define set_pte_at(mm, addr, ptep, pte) set_pte(ptep, pte)
+
+/*
+ * May need to invoke the virtual machine as well...
+ */
+#define pte_unmap(pte)		do { } while (0)
+#define pte_unmap_nested(pte)	do { } while (0)
+
+/*
+ * pte_offset_map - returns the linear address of the page table entry
+ * corresponding to an address
+ */
+#define pte_offset_map(dir, address)                                    \
+	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
+
+#define pte_offset_map_nested(pmd, addr) pte_offset_map(pmd, addr)
+
+/* pte_offset_kernel - kernel version of pte_offset */
+#define pte_offset_kernel(dir, address) \
+	((pte_t *) (unsigned long) __va(pmd_val(*dir) & PAGE_MASK) \
+				+  __pte_offset(address))
+
+/* ZERO_PAGE - returns the globally shared zero page */
+#define ZERO_PAGE(vaddr) (virt_to_page(&empty_zero_page))
+
+#define __pte_offset(address) (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
+
+/* Nothing special about IO remapping at this point */
+#define io_remap_pfn_range(vma, vaddr, pfn, size, prot) \
+	remap_pfn_range(vma, vaddr, pfn, size, prot)
+
+/*  I think this is in case we have page table caches; needed by init/main.c  */
+#define pgtable_cache_init()    do { } while (0)
+
+/*
+ * Swap/file PTE definitions.  If _PAGE_PRESENT is zero, the rest of the
+ * PTE is interpreted as swap information.  Depending on the _PAGE_FILE
+ * bit, the remaining free bits are eitehr interpreted as a file offset
+ * or a swap type/offset tuple.  Rather than have the TLB fill handler
+ * test _PAGE_PRESENT, we're going to reserve the permissions bits
+ * and set them to all zeros for swap entries, which speeds up the
+ * miss handler at the cost of 3 bits of offset.  That trade-off can
+ * be revisited if necessary, but Hexagon processor architecture and
+ * target applications suggest a lot of TLB misses and not much swap space.
+ *
+ * Format of swap PTE:
+ *	bit	0:	Present (zero)
+ *	bit	1:	_PAGE_FILE (zero)
+ *	bits	2-6:	swap type (arch independent layer uses 5 bits max)
+ *	bits	7-9:	bits 2:0 of offset
+ *	bits 10-12:	effectively _PAGE_PROTNONE (all zero)
+ *	bits 13-31:  bits 21:3 of swap offset
+ *
+ * Format of file PTE:
+ *	bit	0:	Present (zero)
+ *	bit	1:	_PAGE_FILE (zero)
+ *	bits	2-9:	bits 7:0 of offset
+ *	bits 10-12:	effectively _PAGE_PROTNONE (all zero)
+ *	bits 13-31:  bits 26:8 of swap offset
+ *
+ * The split offset makes some of the following macros a little gnarly,
+ * but there's plenty of precedent for this sort of thing.
+ */
+#define PTE_FILE_MAX_BITS     27
+
+/* Used for swap PTEs */
+#define __swp_type(swp_pte)		(((swp_pte).val >> 2) & 0x1f)
+
+#define __swp_offset(swp_pte) \
+	((((swp_pte).val >> 7) & 0x7) | (((swp_pte).val >> 10) & 0x003ffff8))
+
+#define __swp_entry(type, offset) \
+	((swp_entry_t)	{ \
+		((type << 2) | \
+		 ((offset & 0x3ffff8) << 10) | ((offset & 0x7) << 7)) })
+
+/* Used for file PTEs */
+#define pte_file(pte) \
+	((pte_val(pte) & (_PAGE_FILE | _PAGE_PRESENT)) == _PAGE_FILE)
+
+#define pte_to_pgoff(pte) \
+	(((pte_val(pte) >> 2) & 0xff) | ((pte_val(pte) >> 5) & 0x07ffff00))
+
+#define pgoff_to_pte(off) \
+	((pte_t) { ((((off) & 0x7ffff00) << 5) | (((off) & 0xff) << 2)\
+	| _PAGE_FILE) })
+
+/*  Oh boy.  There are a lot of possible arch overrides found in this file.  */
+#include <asm-generic/pgtable.h>
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/mm/pgalloc.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/mm/pgalloc.c	2011-08-25 14:51:46.563968765 -0500
@@ -0,0 +1,25 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/init.h>
+
+void __init pgtable_cache_init(void)
+{
+}
+
+

--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

