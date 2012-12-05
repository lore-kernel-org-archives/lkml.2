Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab2LEQUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:20:52 -0500
Received: from multi.imgtec.com ([194.200.65.239]:55549 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845Ab2LEQJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:28 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 14/44] metag: Memory management
Date: Wed, 5 Dec 2012 16:08:32 +0000
Message-ID: <1354723742-6195-15-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add memory management files for metag.

Meta's 32bit virtual address space is split into two halves:
 - local (0x08000000-0x7fffffff): traditionally local to a hardware
   thread and incoherent between hardware threads. Each hardware thread
   has it's own local MMU table. On Meta2 the local space can be
   globally coherent (GCOn) if the cache partitions coincide.
 - global (0x88000000-0xffff0000): coherent and traditionally global
   between hardware threads. On Meta2, each hardware thread has it's own
   global MMU table.

The low 128MiB of each half is non-MMUable and maps directly to the
physical address space:
 - 0x00010000-0x07ffffff: contains Meta core registers and maps SoC bus
 - 0x80000000-0x87ffffff: contains low latency global core memories

Linux usually further splits the local virtual address space like this:
 - 0x08000000-0x3fffffff: user mappings
 - 0x40000000-0x7fffffff: kernel mappings

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/asm/mmu.h         |   77 ++++++
 arch/metag/include/asm/mmu_context.h |  113 +++++++++
 arch/metag/include/asm/page.h        |  128 ++++++++++
 arch/metag/include/asm/pgalloc.h     |   79 ++++++
 arch/metag/include/asm/pgtable.h     |  370 ++++++++++++++++++++++++++++
 arch/metag/mm/extable.c              |   15 ++
 arch/metag/mm/fault.c                |  239 ++++++++++++++++++
 arch/metag/mm/init.c                 |  448 ++++++++++++++++++++++++++++++++++
 arch/metag/mm/mmu-meta1.c            |  157 ++++++++++++
 arch/metag/mm/mmu-meta2.c            |  208 ++++++++++++++++
 10 files changed, 1834 insertions(+), 0 deletions(-)
 create mode 100644 arch/metag/include/asm/mmu.h
 create mode 100644 arch/metag/include/asm/mmu_context.h
 create mode 100644 arch/metag/include/asm/page.h
 create mode 100644 arch/metag/include/asm/pgalloc.h
 create mode 100644 arch/metag/include/asm/pgtable.h
 create mode 100644 arch/metag/mm/extable.c
 create mode 100644 arch/metag/mm/fault.c
 create mode 100644 arch/metag/mm/init.c
 create mode 100644 arch/metag/mm/mmu-meta1.c
 create mode 100644 arch/metag/mm/mmu-meta2.c

diff --git a/arch/metag/include/asm/mmu.h b/arch/metag/include/asm/mmu.h
new file mode 100644
index 0000000..9c32114
--- /dev/null
+++ b/arch/metag/include/asm/mmu.h
@@ -0,0 +1,77 @@
+#ifndef __MMU_H
+#define __MMU_H
+
+#ifdef CONFIG_METAG_USER_TCM
+#include <linux/list.h>
+#endif
+
+#ifdef CONFIG_HUGETLB_PAGE
+#include <asm/page.h>
+#endif
+
+typedef struct {
+	/* Software pgd base pointer used for Meta 1.x MMU. */
+	unsigned long pgd_base;
+#ifdef CONFIG_METAG_USER_TCM
+	struct list_head tcm;
+#endif
+#ifdef CONFIG_HUGETLB_PAGE
+#if HPAGE_SHIFT < HUGEPT_SHIFT
+	/* last partially filled huge page table address */
+	unsigned long part_huge;
+#endif
+#endif
+} mm_context_t;
+
+/* Given a virtual address, return the pte for the top level 4meg entry
+ * that maps that address.
+ * Returns 0 (an empty pte) if that range is not mapped.
+ */
+unsigned long mmu_read_first_level_page(unsigned long vaddr);
+
+/* Given a linear (virtual) address, return the second level 4k pte
+ * that maps that address.  Returns 0 if the address is not mapped.
+ */
+unsigned long mmu_read_second_level_page(unsigned long vaddr);
+
+/* Get the virtual base address of the MMU */
+unsigned long mmu_get_base(void);
+
+/* Initialize the MMU. */
+void mmu_init(unsigned long mem_end);
+
+#ifdef CONFIG_METAG_META21_MMU
+/*
+ * For cpu "cpu" calculate and return the address of the
+ * MMCU_TnLOCAL_TABLE_PHYS0 if running in local-space or
+ * MMCU_TnGLOBAL_TABLE_PHYS0 if running in global-space.
+ */
+static inline unsigned long mmu_phys0_addr(unsigned int cpu)
+{
+	unsigned long phys0;
+
+	phys0 = (MMCU_T0LOCAL_TABLE_PHYS0 +
+		(MMCU_TnX_TABLE_PHYSX_STRIDE * cpu)) +
+		(MMCU_TXG_TABLE_PHYSX_OFFSET * is_global_space(PAGE_OFFSET));
+
+	return phys0;
+}
+
+/*
+ * For cpu "cpu" calculate and return the address of the
+ * MMCU_TnLOCAL_TABLE_PHYS1 if running in local-space or
+ * MMCU_TnGLOBAL_TABLE_PHYS1 if running in global-space.
+ */
+static inline unsigned long mmu_phys1_addr(unsigned int cpu)
+{
+	unsigned long phys1;
+
+	phys1 = (MMCU_T0LOCAL_TABLE_PHYS1 +
+		(MMCU_TnX_TABLE_PHYSX_STRIDE * cpu)) +
+		(MMCU_TXG_TABLE_PHYSX_OFFSET * is_global_space(PAGE_OFFSET));
+
+	return phys1;
+}
+#endif /* CONFIG_METAG_META21_MMU */
+
+#endif
diff --git a/arch/metag/include/asm/mmu_context.h b/arch/metag/include/asm/mmu_context.h
new file mode 100644
index 0000000..ae2a71b
--- /dev/null
+++ b/arch/metag/include/asm/mmu_context.h
@@ -0,0 +1,113 @@
+#ifndef __METAG_MMU_CONTEXT_H
+#define __METAG_MMU_CONTEXT_H
+
+#include <asm-generic/mm_hooks.h>
+
+#include <asm/page.h>
+#include <asm/mmu.h>
+#include <asm/tlbflush.h>
+#include <asm/cacheflush.h>
+
+#include <linux/io.h>
+
+static inline void enter_lazy_tlb(struct mm_struct *mm,
+				  struct task_struct *tsk)
+{
+}
+
+static inline int init_new_context(struct task_struct *tsk,
+				   struct mm_struct *mm)
+{
+#ifndef CONFIG_METAG_META21_MMU
+	/* We use context to store a pointer to the page holding the
+	 * pgd of a process while it is running. While a process is not
+	 * running the pgd and context fields should be equal.
+	 */
+	mm->context.pgd_base = (unsigned long) mm->pgd;
+#endif
+#ifdef CONFIG_METAG_USER_TCM
+	INIT_LIST_HEAD(&mm->context.tcm);
+#endif
+	return 0;
+}
+
+#ifdef CONFIG_METAG_USER_TCM
+
+#include <linux/slab.h>
+#include <asm/tcm.h>
+
+static inline void destroy_context(struct mm_struct *mm)
+{
+	struct tcm_allocation *pos, *n;
+
+	list_for_each_entry_safe(pos, n,  &mm->context.tcm, list) {
+		tcm_free(pos->tag, pos->addr, pos->size);
+		list_del(&pos->list);
+		kfree(pos);
+	}
+}
+#else
+#define destroy_context(mm)		do { } while (0)
+#endif
+
+#ifdef CONFIG_METAG_META21_MMU
+static inline void load_pgd(pgd_t *pgd, int thread)
+{
+	unsigned long phys0 = mmu_phys0_addr(thread);
+	unsigned long phys1 = mmu_phys1_addr(thread);
+
+	/*
+	 *  0x900 2Gb address space
+	 *  The permission bits apply to MMU table region which gives a 2MB
+	 *  window into physical memory. We especially don't want userland to be
+	 *  able to access this.
+	 */
+	metag_out32(0x900 | _PAGE_CACHEABLE | _PAGE_PRIV | _PAGE_WRITE |
+		    _PAGE_PRESENT, phys0);
+	/* Set new MMU base address */
+	metag_out32(__pa(pgd) & MMCU_TBLPHYS1_ADDR_BITS, phys1);
+}
+#endif
+
+static inline void switch_mmu(struct mm_struct *prev, struct mm_struct *next)
+{
+#ifdef CONFIG_METAG_META21_MMU
+	load_pgd(next->pgd, hard_processor_id());
+#else
+	unsigned int i;
+
+	/* prev->context == prev->pgd in the case where we are initially
+	   switching from the init task to the first process. */
+	if (prev->context.pgd_base != (unsigned long) prev->pgd) {
+		for (i = FIRST_USER_PGD_NR; i < USER_PTRS_PER_PGD; i++)
+			((pgd_t *) prev->context.pgd_base)[i] = prev->pgd[i];
+	} else
+		prev->pgd = (pgd_t *)mmu_get_base();
+
+	next->pgd = prev->pgd;
+	prev->pgd = (pgd_t *) prev->context.pgd_base;
+
+	for (i = FIRST_USER_PGD_NR; i < USER_PTRS_PER_PGD; i++)
+		next->pgd[i] = ((pgd_t *) next->context.pgd_base)[i];
+
+	flush_cache_all();
+#endif
+	flush_tlb_all();
+}
+
+static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
+			     struct task_struct *tsk)
+{
+	if (prev != next)
+		switch_mmu(prev, next);
+}
+
+static inline void activate_mm(struct mm_struct *prev_mm,
+			       struct mm_struct *next_mm)
+{
+	switch_mmu(prev_mm, next_mm);
+}
+
+#define deactivate_mm(tsk, mm)   do { } while (0)
+
+#endif
diff --git a/arch/metag/include/asm/page.h b/arch/metag/include/asm/page.h
new file mode 100644
index 0000000..b12345b
--- /dev/null
+++ b/arch/metag/include/asm/page.h
@@ -0,0 +1,128 @@
+#ifndef _METAG_PAGE_H
+#define _METAG_PAGE_H
+
+#include <linux/const.h>
+
+#include <asm/metag_mem.h>
+
+/* PAGE_SHIFT determines the page size */
+#if defined(CONFIG_PAGE_SIZE_4K)
+#define PAGE_SHIFT	12
+#elif defined(CONFIG_PAGE_SIZE_8K)
+#define PAGE_SHIFT	13
+#elif defined(CONFIG_PAGE_SIZE_16K)
+#define PAGE_SHIFT	14
+#endif
+
+#define PAGE_SIZE	(_AC(1, UL) << PAGE_SHIFT)
+#define PAGE_MASK	(~(PAGE_SIZE-1))
+
+#if defined(CONFIG_HUGETLB_PAGE_SIZE_8K)
+# define HPAGE_SHIFT	13
+#elif defined(CONFIG_HUGETLB_PAGE_SIZE_16K)
+# define HPAGE_SHIFT	14
+#elif defined(CONFIG_HUGETLB_PAGE_SIZE_32K)
+# define HPAGE_SHIFT	15
+#elif defined(CONFIG_HUGETLB_PAGE_SIZE_64K)
+# define HPAGE_SHIFT	16
+#elif defined(CONFIG_HUGETLB_PAGE_SIZE_128K)
+# define HPAGE_SHIFT	17
+#elif defined(CONFIG_HUGETLB_PAGE_SIZE_256K)
+# define HPAGE_SHIFT	18
+#elif defined(CONFIG_HUGETLB_PAGE_SIZE_512K)
+# define HPAGE_SHIFT	19
+#elif defined(CONFIG_HUGETLB_PAGE_SIZE_1M)
+# define HPAGE_SHIFT	20
+#elif defined(CONFIG_HUGETLB_PAGE_SIZE_2M)
+# define HPAGE_SHIFT	21
+#elif defined(CONFIG_HUGETLB_PAGE_SIZE_4M)
+# define HPAGE_SHIFT	22
+#endif
+
+#ifdef CONFIG_HUGETLB_PAGE
+# define HPAGE_SIZE		(1UL << HPAGE_SHIFT)
+# define HPAGE_MASK		(~(HPAGE_SIZE-1))
+# define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT-PAGE_SHIFT)
+/*
+ * We define our own hugetlb_get_unmapped_area so we don't corrupt 2nd level
+ * page tables with normal pages in them.
+ */
+# define HUGEPT_SHIFT		(22)
+# define HUGEPT_ALIGN		(1 << HUGEPT_SHIFT)
+# define HUGEPT_MASK		(HUGEPT_ALIGN - 1)
+# define ALIGN_HUGEPT(x)	ALIGN(x, HUGEPT_ALIGN)
+# define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
+#endif
+
+#ifndef __ASSEMBLY__
+
+/* On the Meta, we would like to know if the address (heap) we have is
+ * in local or global space.
+ */
+#define is_global_space(addr)	((addr) > 0x7fffffff)
+#define is_local_space(addr)	(!(is_global_space(addr))
+
+extern void clear_page(void *to);
+extern void copy_page(void *to, void *from);
+
+#define clear_user_page(page, vaddr, pg)        clear_page(page)
+#define copy_user_page(to, from, vaddr, pg)     copy_page(to, from)
+
+/*
+ * These are used to make use of C type-checking..
+ */
+typedef struct { unsigned long pte; } pte_t;
+typedef struct { unsigned long pgd; } pgd_t;
+typedef struct { unsigned long pgprot; } pgprot_t;
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
+/* The kernel must now ALWAYS live at either 0xC0000000 or 0x40000000 - that
+ * being either global or local space.
+ */
+#define PAGE_OFFSET		(CONFIG_PAGE_OFFSET)
+
+#if PAGE_OFFSET >= LINGLOBAL_BASE
+#define META_MEMORY_BASE  LINGLOBAL_BASE
+#define META_MEMORY_LIMIT LINGLOBAL_LIMIT
+#else
+#define META_MEMORY_BASE  LINLOCAL_BASE
+#define META_MEMORY_LIMIT LINLOCAL_LIMIT
+#endif
+
+/* Offset between physical and virtual mapping of kernel memory. */
+extern unsigned int meta_memoffset;
+
+#define __pa(x) ((unsigned long)(((unsigned long)(x)) - meta_memoffset))
+#define __va(x) ((void *)((unsigned long)(((unsigned long)(x)) + meta_memoffset)))
+
+extern unsigned long pfn_base;
+#define ARCH_PFN_OFFSET         (pfn_base)
+#define virt_to_page(kaddr)     pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
+#define page_to_virt(page)      __va(page_to_pfn(page) << PAGE_SHIFT)
+#define virt_addr_valid(kaddr)  pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
+#define page_to_phys(page)      (page_to_pfn(page) << PAGE_SHIFT)
+#ifdef CONFIG_FLATMEM
+extern unsigned long max_pfn;
+extern unsigned long min_low_pfn;
+#define pfn_valid(pfn)		((pfn) >= min_low_pfn && (pfn) < max_pfn)
+#endif
+
+#define pfn_to_kaddr(pfn)	__va((pfn) << PAGE_SHIFT)
+
+#define VM_DATA_DEFAULT_FLAGS   (VM_READ | VM_WRITE | VM_EXEC | \
+				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+
+#include <asm-generic/memory_model.h>
+#include <asm-generic/getorder.h>
+
+#endif /* __ASSMEBLY__ */
+
+#endif /* _METAG_PAGE_H */
diff --git a/arch/metag/include/asm/pgalloc.h b/arch/metag/include/asm/pgalloc.h
new file mode 100644
index 0000000..275d928
--- /dev/null
+++ b/arch/metag/include/asm/pgalloc.h
@@ -0,0 +1,79 @@
+#ifndef _METAG_PGALLOC_H
+#define _METAG_PGALLOC_H
+
+#include <linux/threads.h>
+#include <linux/mm.h>
+
+#define pmd_populate_kernel(mm, pmd, pte) \
+	set_pmd(pmd, __pmd(_PAGE_TABLE | __pa(pte)))
+
+#define pmd_populate(mm, pmd, pte) \
+	set_pmd(pmd, __pmd(_PAGE_TABLE | page_to_phys(pte)))
+
+#define pmd_pgtable(pmd) pmd_page(pmd)
+
+/*
+ * Allocate and free page tables.
+ */
+#ifdef CONFIG_METAG_META21_MMU
+static inline void pgd_ctor(pgd_t *pgd)
+{
+	memcpy(pgd + USER_PTRS_PER_PGD,
+	       swapper_pg_dir + USER_PTRS_PER_PGD,
+	       (PTRS_PER_PGD - USER_PTRS_PER_PGD) * sizeof(pgd_t));
+}
+#else
+#define pgd_ctor(x)	do { } while (0)
+#endif
+
+static inline pgd_t *pgd_alloc(struct mm_struct *mm)
+{
+	pgd_t *pgd = (pgd_t *)get_zeroed_page(GFP_KERNEL);
+	if (pgd)
+		pgd_ctor(pgd);
+	return pgd;
+}
+
+static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
+{
+	free_page((unsigned long)pgd);
+}
+
+static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
+					  unsigned long address)
+{
+	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL | __GFP_REPEAT |
+					      __GFP_ZERO);
+	return pte;
+}
+
+static inline pgtable_t pte_alloc_one(struct mm_struct *mm,
+				      unsigned long address)
+{
+	struct page *pte;
+	pte = alloc_pages(GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO, 0);
+	if (pte)
+		pgtable_page_ctor(pte);
+	return pte;
+}
+
+static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
+{
+	free_page((unsigned long)pte);
+}
+
+static inline void pte_free(struct mm_struct *mm, pgtable_t pte)
+{
+	pgtable_page_dtor(pte);
+	__free_page(pte);
+}
+
+#define __pte_free_tlb(tlb, pte, addr)				\
+	do {							\
+		pgtable_page_dtor(pte);				\
+		tlb_remove_page((tlb), (pte));			\
+	} while (0)
+
+#define check_pgt_cache()	do { } while (0)
+
+#endif
diff --git a/arch/metag/include/asm/pgtable.h b/arch/metag/include/asm/pgtable.h
new file mode 100644
index 0000000..1cd13d5
--- /dev/null
+++ b/arch/metag/include/asm/pgtable.h
@@ -0,0 +1,370 @@
+/*
+ * Macros and functions to manipulate Meta page tables.
+ */
+
+#ifndef _METAG_PGTABLE_H
+#define _METAG_PGTABLE_H
+
+#include <asm-generic/pgtable-nopmd.h>
+
+/* Invalid regions on Meta: 0x00000000-0x001FFFFF and 0xFFFF0000-0xFFFFFFFF */
+#if PAGE_OFFSET >= LINGLOBAL_BASE
+#define CONSISTENT_START	0xF7000000
+#define CONSISTENT_END		0xF73FFFFF
+#define VMALLOC_START		0xF8000000
+#define VMALLOC_END		0xFFFEFFFF
+#else
+#define CONSISTENT_START	0x77000000
+#define CONSISTENT_END		0x773FFFFF
+#define VMALLOC_START		0x78000000
+#define VMALLOC_END		0x7FFFFFFF
+#endif
+
+/*
+ * Definitions for MMU descriptors
+ *
+ * These are the hardware bits in the MMCU pte entries.
+ * Derived from the Meta toolkit headers.
+ */
+#define _PAGE_PRESENT		MMCU_ENTRY_VAL_BIT
+#define _PAGE_WRITE		MMCU_ENTRY_WR_BIT
+#define _PAGE_PRIV		MMCU_ENTRY_PRIV_BIT
+/* Write combine bit - this can cause writes to occur out of order */
+#define _PAGE_WR_COMBINE	MMCU_ENTRY_WRC_BIT
+/* Sys coherent bit - this bit is never used by Linux */
+#define _PAGE_SYS_COHERENT	MMCU_ENTRY_SYS_BIT
+#define _PAGE_ALWAYS_ZERO_1	0x020
+#define _PAGE_CACHE_CTRL0	0x040
+#define _PAGE_CACHE_CTRL1	0x080
+#define _PAGE_ALWAYS_ZERO_2	0x100
+#define _PAGE_ALWAYS_ZERO_3	0x200
+#define _PAGE_ALWAYS_ZERO_4	0x400
+#define _PAGE_ALWAYS_ZERO_5	0x800
+
+/* These are software bits that we stuff into the gaps in the hardware
+ * pte entries that are not used.  Note, these DO get stored in the actual
+ * hardware, but the hardware just does not use them.
+ */
+#define _PAGE_ACCESSED		_PAGE_ALWAYS_ZERO_1
+#define _PAGE_DIRTY		_PAGE_ALWAYS_ZERO_2
+#define _PAGE_FILE		_PAGE_ALWAYS_ZERO_3
+
+/* Pages owned, and protected by, the kernel. */
+#define _PAGE_KERNEL		_PAGE_PRIV
+
+/* No cacheing of this page */
+#define _PAGE_CACHE_WIN0	(MMCU_CWIN_UNCACHED << MMCU_ENTRY_CWIN_S)
+/* burst cacheing - good for data streaming */
+#define _PAGE_CACHE_WIN1	(MMCU_CWIN_BURST << MMCU_ENTRY_CWIN_S)
+/* One cache way per thread */
+#define _PAGE_CACHE_WIN2	(MMCU_CWIN_C1SET << MMCU_ENTRY_CWIN_S)
+/* Full on cacheing */
+#define _PAGE_CACHE_WIN3	(MMCU_CWIN_CACHED << MMCU_ENTRY_CWIN_S)
+
+#define _PAGE_CACHEABLE		(_PAGE_CACHE_WIN3 | _PAGE_WR_COMBINE)
+
+/* which bits are used for cache control ... */
+#define _PAGE_CACHE_MASK	(_PAGE_CACHE_CTRL0 | _PAGE_CACHE_CTRL1 | \
+				 _PAGE_WR_COMBINE)
+
+/* This is a mask of the bits that pte_modify is allowed to change. */
+#define _PAGE_CHG_MASK		(PAGE_MASK)
+
+#define _PAGE_SZ_SHIFT		1
+#define _PAGE_SZ_4K		(0x0)
+#define _PAGE_SZ_8K		(0x1 << _PAGE_SZ_SHIFT)
+#define _PAGE_SZ_16K		(0x2 << _PAGE_SZ_SHIFT)
+#define _PAGE_SZ_32K		(0x3 << _PAGE_SZ_SHIFT)
+#define _PAGE_SZ_64K		(0x4 << _PAGE_SZ_SHIFT)
+#define _PAGE_SZ_128K		(0x5 << _PAGE_SZ_SHIFT)
+#define _PAGE_SZ_256K		(0x6 << _PAGE_SZ_SHIFT)
+#define _PAGE_SZ_512K		(0x7 << _PAGE_SZ_SHIFT)
+#define _PAGE_SZ_1M		(0x8 << _PAGE_SZ_SHIFT)
+#define _PAGE_SZ_2M		(0x9 << _PAGE_SZ_SHIFT)
+#define _PAGE_SZ_4M		(0xa << _PAGE_SZ_SHIFT)
+#define _PAGE_SZ_MASK		(0xf << _PAGE_SZ_SHIFT)
+
+#if defined(CONFIG_PAGE_SIZE_4K)
+#define _PAGE_SZ		(_PAGE_SZ_4K)
+#elif defined(CONFIG_PAGE_SIZE_8K)
+#define _PAGE_SZ		(_PAGE_SZ_8K)
+#elif defined(CONFIG_PAGE_SIZE_16K)
+#define _PAGE_SZ		(_PAGE_SZ_16K)
+#endif
+#define _PAGE_TABLE		(_PAGE_SZ | _PAGE_PRESENT)
+
+#if defined(CONFIG_HUGETLB_PAGE_SIZE_8K)
+# define _PAGE_SZHUGE		(_PAGE_SZ_8K)
+#elif defined(CONFIG_HUGETLB_PAGE_SIZE_16K)
+# define _PAGE_SZHUGE		(_PAGE_SZ_16K)
+#elif defined(CONFIG_HUGETLB_PAGE_SIZE_32K)
+# define _PAGE_SZHUGE		(_PAGE_SZ_32K)
+#elif defined(CONFIG_HUGETLB_PAGE_SIZE_64K)
+# define _PAGE_SZHUGE		(_PAGE_SZ_64K)
+#elif defined(CONFIG_HUGETLB_PAGE_SIZE_128K)
+# define _PAGE_SZHUGE		(_PAGE_SZ_128K)
+#elif defined(CONFIG_HUGETLB_PAGE_SIZE_256K)
+# define _PAGE_SZHUGE		(_PAGE_SZ_256K)
+#elif defined(CONFIG_HUGETLB_PAGE_SIZE_512K)
+# define _PAGE_SZHUGE		(_PAGE_SZ_512K)
+#elif defined(CONFIG_HUGETLB_PAGE_SIZE_1M)
+# define _PAGE_SZHUGE		(_PAGE_SZ_1M)
+#elif defined(CONFIG_HUGETLB_PAGE_SIZE_2M)
+# define _PAGE_SZHUGE		(_PAGE_SZ_2M)
+#elif defined(CONFIG_HUGETLB_PAGE_SIZE_4M)
+# define _PAGE_SZHUGE		(_PAGE_SZ_4M)
+#endif
+
+/*
+ * The Linux memory management assumes a three-level page table setup. On
+ * Meta, we use that, but "fold" the mid level into the top-level page
+ * table.
+ */
+
+/* PGDIR_SHIFT determines the size of the area a second-level page table can
+ * map. This is always 4MB.
+ */
+
+#define PGDIR_SHIFT	22
+#define PGDIR_SIZE	(1UL << PGDIR_SHIFT)
+#define PGDIR_MASK	(~(PGDIR_SIZE-1))
+
+/*
+ * Entries per page directory level: we use a two-level, so
+ * we don't really have any PMD directory physically. First level tables
+ * always map 2Gb (local or global) at a granularity of 4MB, second-level
+ * tables map 4MB with a granularity between 4MB and 4kB (between 1 and
+ * 1024 entries).
+ */
+#define PTRS_PER_PTE	(PGDIR_SIZE/PAGE_SIZE)
+#define HPTRS_PER_PTE	(PGDIR_SIZE/HPAGE_SIZE)
+#define PTRS_PER_PGD	512
+
+#define USER_PTRS_PER_PGD	256
+#define FIRST_USER_ADDRESS	META_MEMORY_BASE
+#define FIRST_USER_PGD_NR	pgd_index(FIRST_USER_ADDRESS)
+
+#define PAGE_NONE	__pgprot(_PAGE_PRESENT | _PAGE_ACCESSED | \
+				 _PAGE_CACHEABLE)
+
+#define PAGE_SHARED	__pgprot(_PAGE_PRESENT | _PAGE_WRITE | \
+				 _PAGE_ACCESSED | _PAGE_CACHEABLE)
+#define PAGE_SHARED_C	PAGE_SHARED
+#define PAGE_COPY	__pgprot(_PAGE_PRESENT | _PAGE_ACCESSED | \
+				 _PAGE_CACHEABLE)
+#define PAGE_COPY_C	PAGE_COPY
+
+#define PAGE_READONLY	__pgprot(_PAGE_PRESENT | _PAGE_ACCESSED | \
+				 _PAGE_CACHEABLE)
+#define PAGE_KERNEL	__pgprot(_PAGE_PRESENT | _PAGE_DIRTY | \
+				 _PAGE_ACCESSED | _PAGE_WRITE | \
+				 _PAGE_CACHEABLE | _PAGE_KERNEL)
+
+#define __P000	PAGE_NONE
+#define __P001	PAGE_READONLY
+#define __P010	PAGE_COPY
+#define __P011	PAGE_COPY
+#define __P100	PAGE_READONLY
+#define __P101	PAGE_READONLY
+#define __P110	PAGE_COPY_C
+#define __P111	PAGE_COPY_C
+
+#define __S000	PAGE_NONE
+#define __S001	PAGE_READONLY
+#define __S010	PAGE_SHARED
+#define __S011	PAGE_SHARED
+#define __S100	PAGE_READONLY
+#define __S101	PAGE_READONLY
+#define __S110	PAGE_SHARED_C
+#define __S111	PAGE_SHARED_C
+
+#ifndef __ASSEMBLY__
+
+#include <asm/page.h>
+
+/* zero page used for uninitialized stuff */
+extern unsigned long empty_zero_page;
+#define ZERO_PAGE(vaddr)	(virt_to_page(empty_zero_page))
+
+/* Certain architectures need to do special things when pte's
+ * within a page table are directly modified.  Thus, the following
+ * hook is made available.
+ */
+#define set_pte(pteptr, pteval) ((*(pteptr)) = (pteval))
+#define set_pte_at(mm, addr, ptep, pteval) set_pte(ptep, pteval)
+
+#define set_pmd(pmdptr, pmdval) (*(pmdptr) = pmdval)
+
+#define pte_pfn(pte)		(pte_val(pte) >> PAGE_SHIFT)
+
+#define pfn_pte(pfn, prot)	__pte(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
+
+#define pte_none(x)		(!pte_val(x))
+#define pte_present(x)		(pte_val(x) & _PAGE_PRESENT)
+#define pte_clear(mm, addr, xp)	do { pte_val(*(xp)) = 0; } while (0)
+
+#define pmd_none(x)		(!pmd_val(x))
+#define pmd_bad(x)		((pmd_val(x) & ~(PAGE_MASK | _PAGE_SZ_MASK)) \
+					!= (_PAGE_TABLE & ~_PAGE_SZ_MASK))
+#define pmd_present(x)		(pmd_val(x) & _PAGE_PRESENT)
+#define pmd_clear(xp)		do { pmd_val(*(xp)) = 0; } while (0)
+
+#define pte_page(x)		pfn_to_page(pte_pfn(x))
+
+/*
+ * The following only work if pte_present() is true.
+ * Undefined behaviour if not..
+ */
+
+static inline int pte_write(pte_t pte)   { return pte_val(pte) & _PAGE_WRITE; }
+static inline int pte_dirty(pte_t pte)   { return pte_val(pte) & _PAGE_DIRTY; }
+static inline int pte_young(pte_t pte)   { return pte_val(pte) & _PAGE_ACCESSED; }
+static inline int pte_file(pte_t pte)    { return pte_val(pte) & _PAGE_FILE; }
+static inline int pte_special(pte_t pte) { return 0; }
+
+static inline pte_t pte_wrprotect(pte_t pte) { pte_val(pte) &= (~_PAGE_WRITE); return pte; }
+static inline pte_t pte_mkclean(pte_t pte)   { pte_val(pte) &= ~_PAGE_DIRTY; return pte; }
+static inline pte_t pte_mkold(pte_t pte)     { pte_val(pte) &= ~_PAGE_ACCESSED; return pte; }
+static inline pte_t pte_mkwrite(pte_t pte)   { pte_val(pte) |= _PAGE_WRITE; return pte; }
+static inline pte_t pte_mkdirty(pte_t pte)   { pte_val(pte) |= _PAGE_DIRTY; return pte; }
+static inline pte_t pte_mkyoung(pte_t pte)   { pte_val(pte) |= _PAGE_ACCESSED; return pte; }
+static inline pte_t pte_mkspecial(pte_t pte) { return pte; }
+static inline pte_t pte_mkhuge(pte_t pte)    { return pte; }
+
+/*
+ * Macro and implementation to make a page protection as uncacheable.
+ */
+#define pgprot_writecombine(prot)					\
+	__pgprot(pgprot_val(prot) & ~(_PAGE_CACHE_CTRL1 | _PAGE_CACHE_CTRL0))
+
+#define pgprot_noncached(prot)						\
+	__pgprot(pgprot_val(prot) & ~_PAGE_CACHEABLE)
+
+
+/*
+ * Conversion functions: convert a page and protection to a page entry,
+ * and a page entry and page directory to the page they refer to.
+ */
+
+#define mk_pte(page, pgprot)	pfn_pte(page_to_pfn(page), (pgprot))
+
+static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
+{
+	pte_val(pte) = (pte_val(pte) & _PAGE_CHG_MASK) | pgprot_val(newprot);
+	return pte;
+}
+
+static inline unsigned long pmd_page_vaddr(pmd_t pmd)
+{
+	unsigned long paddr = pmd_val(pmd) & PAGE_MASK;
+	if (!paddr)
+		return 0;
+	return (unsigned long)__va(paddr);
+}
+
+#define pmd_page(pmd)		(pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT))
+#define pmd_page_shift(pmd)	(12 + ((pmd_val(pmd) & _PAGE_SZ_MASK) \
+					>> _PAGE_SZ_SHIFT))
+#define pmd_num_ptrs(pmd)	(PGDIR_SIZE >> pmd_page_shift(pmd))
+
+/*
+ * Each pgd is only 2k, mapping 2Gb (local or global). If we're in global
+ * space drop the top bit before indexing the pgd.
+ */
+#if PAGE_OFFSET >= LINGLOBAL_BASE
+#define pgd_index(address)	((((address) & ~0x80000000) >> PGDIR_SHIFT) \
+							& (PTRS_PER_PGD-1))
+#else
+#define pgd_index(address)	(((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
+#endif
+
+#define pgd_offset(mm, address)	((mm)->pgd + pgd_index(address))
+
+#define pgd_offset_k(address)	pgd_offset(&init_mm, address)
+
+#define pmd_index(address)	(((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
+
+/* Find an entry in the second-level page table.. */
+#if !defined(CONFIG_HUGETLB_PAGE)
+  /* all pages are of size (1 << PAGE_SHIFT), so no need to read 1st level pt */
+# define pte_index(pmd, address) \
+	(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
+#else
+  /* some pages are huge, so read 1st level pt to find out */
+# define pte_index(pmd, address) \
+	(((address) >> pmd_page_shift(pmd)) & (pmd_num_ptrs(pmd) - 1))
+#endif
+#define pte_offset_kernel(dir, address) \
+	((pte_t *) pmd_page_vaddr(*(dir)) + pte_index(*(dir), address))
+#define pte_offset_map(dir, address)		pte_offset_kernel(dir, address)
+#define pte_offset_map_nested(dir, address)	pte_offset_kernel(dir, address)
+
+#define pte_unmap(pte)		do { } while (0)
+#define pte_unmap_nested(pte)	do { } while (0)
+
+#define pte_ERROR(e) \
+	pr_err("%s:%d: bad pte %08lx.\n", __FILE__, __LINE__, pte_val(e))
+#define pgd_ERROR(e) \
+	pr_err("%s:%d: bad pgd %08lx.\n", __FILE__, __LINE__, pgd_val(e))
+
+/*
+ * Meta doesn't have any external MMU info: the kernel page
+ * tables contain all the necessary information.
+ */
+static inline void update_mmu_cache(struct vm_area_struct *vma,
+				    unsigned long address, pte_t *pte)
+{
+}
+
+/*
+ * Encode and decode a swap entry (must be !pte_none(e) && !pte_present(e))
+ * Since PAGE_PRESENT is bit 1, we can use the bits above that.
+ */
+#define __swp_type(x)			(((x).val >> 1) & 0xff)
+#define __swp_offset(x)			((x).val >> 10)
+#define __swp_entry(type, offset)	((swp_entry_t) { ((type) << 1) | \
+					 ((offset) << 10) })
+#define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
+#define __swp_entry_to_pte(x)		((pte_t) { (x).val })
+
+#define PTE_FILE_MAX_BITS	22
+#define pte_to_pgoff(x)		(pte_val(x) >> 10)
+#define pgoff_to_pte(x)		__pte(((x) << 10) | _PAGE_FILE)
+
+#define kern_addr_valid(addr)	(1)
+
+#define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
+	remap_pfn_range(vma, vaddr, pfn, size, prot)
+
+/*
+ * No page table caches to initialise
+ */
+#define pgtable_cache_init()	do { } while (0)
+
+extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
+void paging_init(unsigned long mem_end);
+
+#ifdef CONFIG_METAG_META12
+/* This is a workaround for an issue in Meta 1 cores. These cores cache
+ * invalid entries in the TLB so we always need to flush whenever we add
+ * a new pte. Unfortunately we can only flush the whole TLB not shoot down
+ * single entries so this is sub-optimal. This implementation ensures that
+ * we will get a flush at the second attempt, so we may still get repeated
+ * faults, we just don't overflow the kernel stack handling them.
+ */
+#define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
+#define ptep_set_access_flags(__vma, __address, __ptep, __entry, __dirty) \
+({									  \
+	int __changed = !pte_same(*(__ptep), __entry);			  \
+	if (__changed) {						  \
+		set_pte_at((__vma)->vm_mm, (__address), __ptep, __entry); \
+	}								  \
+	flush_tlb_page(__vma, __address);				  \
+	__changed;							  \
+})
+#endif
+
+#include <asm-generic/pgtable.h>
+
+#endif /* __ASSEMBLY__ */
+#endif /* _METAG_PGTABLE_H */
diff --git a/arch/metag/mm/extable.c b/arch/metag/mm/extable.c
new file mode 100644
index 0000000..2a21eae
--- /dev/null
+++ b/arch/metag/mm/extable.c
@@ -0,0 +1,15 @@
+
+#include <linux/module.h>
+#include <linux/uaccess.h>
+
+int fixup_exception(struct pt_regs *regs)
+{
+	const struct exception_table_entry *fixup;
+	unsigned long pc = instruction_pointer(regs);
+
+	fixup = search_exception_tables(pc);
+	if (fixup)
+		regs->ctx.CurrPC = fixup->fixup;
+
+	return fixup != NULL;
+}
diff --git a/arch/metag/mm/fault.c b/arch/metag/mm/fault.c
new file mode 100644
index 0000000..2c75bf7
--- /dev/null
+++ b/arch/metag/mm/fault.c
@@ -0,0 +1,239 @@
+/*
+ *  Meta page fault handling.
+ *
+ *  Copyright (C) 2005-2012 Imagination Technologies Ltd.
+ */
+
+#include <linux/mman.h>
+#include <linux/mm.h>
+#include <linux/kernel.h>
+#include <linux/ptrace.h>
+#include <linux/interrupt.h>
+#include <linux/uaccess.h>
+
+#include <asm/tlbflush.h>
+#include <asm/mmu.h>
+#include <asm/traps.h>
+
+/* Clear any pending catch buffer state. */
+static void clear_cbuf_entry(struct pt_regs *regs, unsigned long addr,
+			     unsigned int trapno)
+{
+	PTBICTXEXTCB0 cbuf = regs->extcb0;
+
+	switch (trapno) {
+		/* Instruction fetch faults leave no catch buffer state. */
+	case TBIXXF_SIGNUM_IGF:
+	case TBIXXF_SIGNUM_IPF:
+		return;
+	default:
+		if (cbuf[0].CBAddr == addr) {
+			cbuf[0].CBAddr = 0;
+			cbuf[0].CBFlags &= ~TXCATCH0_FAULT_BITS;
+
+			/* And, as this is the ONLY catch entry, we
+			 * need to clear the cbuf bit from the context!
+			 */
+			regs->ctx.SaveMask &= ~(TBICTX_CBUF_BIT |
+						TBICTX_XCBF_BIT);
+
+			return;
+		}
+		pr_err("Failed to clear cbuf entry!\n");
+	}
+}
+
+int show_unhandled_signals = 1;
+
+int do_page_fault(struct pt_regs *regs, unsigned long address,
+		  unsigned int write_access, unsigned int trapno)
+{
+	struct task_struct *tsk;
+	struct mm_struct *mm;
+	struct vm_area_struct *vma, *prev_vma;
+	siginfo_t info;
+	int fault;
+	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
+				(write_access ? FAULT_FLAG_WRITE : 0);
+
+	tsk = current;
+
+	if ((address >= VMALLOC_START) && (address < VMALLOC_END)) {
+		/*
+		 * Synchronize this task's top level page-table
+		 * with the 'reference' page table.
+		 *
+		 * Do _not_ use "tsk" here. We might be inside
+		 * an interrupt in the middle of a task switch..
+		 */
+		int offset = pgd_index(address);
+		pgd_t *pgd, *pgd_k;
+		pud_t *pud, *pud_k;
+		pmd_t *pmd, *pmd_k;
+		pte_t *pte_k;
+
+		pgd = ((pgd_t *)mmu_get_base()) + offset;
+		pgd_k = swapper_pg_dir + offset;
+
+		/* This will never happen with the folded page table. */
+		if (!pgd_present(*pgd)) {
+			if (!pgd_present(*pgd_k))
+				goto bad_area_nosemaphore;
+			set_pgd(pgd, *pgd_k);
+			return 0;
+		}
+
+		pud = pud_offset(pgd, address);
+		pud_k = pud_offset(pgd_k, address);
+		if (!pud_present(*pud_k))
+			goto bad_area_nosemaphore;
+		set_pud(pud, *pud_k);
+
+		pmd = pmd_offset(pud, address);
+		pmd_k = pmd_offset(pud_k, address);
+		if (!pmd_present(*pmd_k))
+			goto bad_area_nosemaphore;
+		set_pmd(pmd, *pmd_k);
+
+		pte_k = pte_offset_kernel(pmd_k, address);
+		if (!pte_present(*pte_k))
+			goto bad_area_nosemaphore;
+
+		/* May only be needed on Chorus2 */
+		flush_tlb_all();
+		return 0;
+	}
+
+	mm = tsk->mm;
+
+	if (in_atomic() || !mm)
+		goto no_context;
+
+retry:
+	down_read(&mm->mmap_sem);
+
+	vma = find_vma_prev(mm, address, &prev_vma);
+
+	if (!vma || address < vma->vm_start)
+		goto check_expansion;
+
+good_area:
+	if (write_access) {
+		if (!(vma->vm_flags & VM_WRITE))
+			goto bad_area;
+	} else {
+		if (!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)))
+			goto bad_area;
+	}
+
+	/*
+	 * If for any reason at all we couldn't handle the fault,
+	 * make sure we exit gracefully rather than endlessly redo
+	 * the fault.
+	 */
+	fault = handle_mm_fault(mm, vma, address, flags);
+
+	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+		return 0;
+
+	if (unlikely(fault & VM_FAULT_ERROR)) {
+		if (fault & VM_FAULT_OOM)
+			goto out_of_memory;
+		else if (fault & VM_FAULT_SIGBUS)
+			goto do_sigbus;
+		BUG();
+	}
+	if (flags & FAULT_FLAG_ALLOW_RETRY) {
+		if (fault & VM_FAULT_MAJOR)
+			tsk->maj_flt++;
+		else
+			tsk->min_flt++;
+		if (fault & VM_FAULT_RETRY) {
+			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+			flags |= FAULT_FLAG_TRIED;
+
+			/*
+			 * No need to up_read(&mm->mmap_sem) as we would
+			 * have already released it in __lock_page_or_retry
+			 * in mm/filemap.c.
+			 */
+
+			goto retry;
+		}
+	}
+
+	up_read(&mm->mmap_sem);
+	return 0;
+
+check_expansion:
+	vma = prev_vma;
+	if (vma && (expand_stack(vma, address) == 0))
+		goto good_area;
+
+bad_area:
+	up_read(&mm->mmap_sem);
+
+bad_area_nosemaphore:
+	if (user_mode(regs)) {
+		info.si_signo = SIGSEGV;
+		info.si_errno = 0;
+		info.si_code = SEGV_MAPERR;
+		info.si_addr = (__force void __user *)address;
+		info.si_trapno = trapno;
+
+		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
+		    printk_ratelimit()) {
+			pr_info("%s%s[%d]: segfault at %lx pc %08x sp %08x write %d trap %#x (%s)",
+			       task_pid_nr(tsk) > 1 ? KERN_INFO : KERN_EMERG,
+			       tsk->comm, task_pid_nr(tsk), address,
+			       regs->ctx.CurrPC, regs->ctx.AX[0].U0,
+			       write_access, trapno, trap_name(trapno));
+			print_vma_addr(" in ", regs->ctx.CurrPC);
+			print_vma_addr(" rtp in ", regs->ctx.DX[4].U1);
+			printk("\n");
+			show_regs(regs);
+		}
+		force_sig_info(SIGSEGV, &info, tsk);
+		return 1;
+	}
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
+	info.si_addr = (__force void __user *)address;
+	info.si_trapno = trapno;
+	force_sig_info(SIGBUS, &info, tsk);
+
+	/* Kernel mode? Handle exceptions or die */
+	if (!user_mode(regs))
+		goto no_context;
+
+	return 1;
+
+	/*
+	 * We ran out of memory, or some other thing happened to us that made
+	 * us unable to handle the page fault gracefully.
+	 */
+out_of_memory:
+	up_read(&mm->mmap_sem);
+	if (user_mode(regs))
+		do_group_exit(SIGKILL);
+
+no_context:
+	/* Are we prepared to handle this kernel fault?  */
+	if (fixup_exception(regs)) {
+		clear_cbuf_entry(regs, address, trapno);
+		return 1;
+	}
+
+	die("Oops", regs, (write_access << 15) | trapno, address);
+	do_exit(SIGKILL);
+}
diff --git a/arch/metag/mm/init.c b/arch/metag/mm/init.c
new file mode 100644
index 0000000..514376d
--- /dev/null
+++ b/arch/metag/mm/init.c
@@ -0,0 +1,448 @@
+/*
+ *  Copyright (C) 2005,2006,2007,2008,2009,2010 Imagination Technologies
+ *
+ */
+
+#include <linux/mm.h>
+#include <linux/swap.h>
+#include <linux/init.h>
+#include <linux/bootmem.h>
+#include <linux/pagemap.h>
+#include <linux/percpu.h>
+#include <linux/memblock.h>
+#include <linux/initrd.h>
+#include <linux/of_fdt.h>
+
+#include <asm/setup.h>
+#include <asm/page.h>
+#include <asm/pgalloc.h>
+#include <asm/mmu.h>
+#include <asm/mmu_context.h>
+#include <asm/sections.h>
+#include <asm/tlb.h>
+#include <asm/user_gateway.h>
+#include <asm/mmzone.h>
+#include <asm/fixmap.h>
+
+unsigned long pfn_base;
+
+pgd_t swapper_pg_dir[PTRS_PER_PGD] __page_aligned_data;
+
+unsigned long empty_zero_page;
+
+extern char __user_gateway_start;
+extern char __user_gateway_end;
+
+void *gateway_page;
+
+/*
+ * Insert the gateway page into a set of page tables, creating the
+ * page tables if necessary.
+ */
+static void insert_gateway_page(pgd_t *pgd, unsigned long address)
+{
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	BUG_ON(!pgd_present(*pgd));
+
+	pud = pud_offset(pgd, address);
+	BUG_ON(!pud_present(*pud));
+
+	pmd = pmd_offset(pud, address);
+	if (!pmd_present(*pmd)) {
+		pte = alloc_bootmem_pages(PAGE_SIZE);
+		set_pmd(pmd, __pmd(_PAGE_TABLE | __pa(pte)));
+	}
+
+	pte = pte_offset_kernel(pmd, address);
+	set_pte(pte, pfn_pte(__pa(gateway_page) >> PAGE_SHIFT, PAGE_READONLY));
+}
+
+/* Alloc and map a page in a known location accessible to userspace. */
+static void __init user_gateway_init(void)
+{
+	unsigned long address = USER_GATEWAY_PAGE;
+	int offset = pgd_index(address);
+	pgd_t *pgd;
+
+	gateway_page = alloc_bootmem_pages(PAGE_SIZE);
+
+	pgd = swapper_pg_dir + offset;
+	insert_gateway_page(pgd, address);
+
+#ifdef CONFIG_METAG_META12
+	/*
+	 * Insert the gateway page into our current page tables even
+	 * though we've already inserted it into our reference page
+	 * table (swapper_pg_dir). This is because with a META1 mmu we
+	 * copy just the user address range and not the gateway page
+	 * entry on context switch, see switch_mmu().
+	 */
+	pgd = (pgd_t *)mmu_get_base() + offset;
+	insert_gateway_page(pgd, address);
+#endif /* CONFIG_METAG_META12 */
+
+	BUG_ON((&__user_gateway_end - &__user_gateway_start) > PAGE_SIZE);
+
+	gateway_page += (address & ~PAGE_MASK);
+
+	memcpy(gateway_page, &__user_gateway_start,
+	       &__user_gateway_end - &__user_gateway_start);
+
+	/*
+	 * We don't need to flush the TLB here, there should be no mapping
+	 * present at boot for this address and only valid mappings are in
+	 * the TLB (apart from on Meta 1.x, but those cached invalid
+	 * mappings should be impossible to hit here).
+	 *
+	 * We don't flush the code cache here even though we have written
+	 * code through the data cache and they may not be coherent. At
+	 * this point we assume there is no stale data in the code cache
+	 * for this address so there is no need to flush.
+	 */
+}
+
+static void __init allocate_pgdat(unsigned int nid)
+{
+	unsigned long start_pfn, end_pfn;
+#ifdef CONFIG_NEED_MULTIPLE_NODES
+	unsigned long phys;
+#endif
+
+	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
+
+#ifdef CONFIG_NEED_MULTIPLE_NODES
+	phys = __memblock_alloc_base(sizeof(struct pglist_data),
+				SMP_CACHE_BYTES, end_pfn << PAGE_SHIFT);
+	/* Retry with all of system memory */
+	if (!phys)
+		phys = __memblock_alloc_base(sizeof(struct pglist_data),
+					     SMP_CACHE_BYTES,
+					     memblock_end_of_DRAM());
+	if (!phys)
+		panic("Can't allocate pgdat for node %d\n", nid);
+
+	NODE_DATA(nid) = __va(phys);
+	memset(NODE_DATA(nid), 0, sizeof(struct pglist_data));
+
+	NODE_DATA(nid)->bdata = &bootmem_node_data[nid];
+#endif
+
+	NODE_DATA(nid)->node_start_pfn = start_pfn;
+	NODE_DATA(nid)->node_spanned_pages = end_pfn - start_pfn;
+}
+
+static void __init bootmem_init_one_node(unsigned int nid)
+{
+	unsigned long total_pages, paddr;
+	unsigned long end_pfn;
+	struct pglist_data *p;
+
+	p = NODE_DATA(nid);
+
+	/* Nothing to do.. */
+	if (!p->node_spanned_pages)
+		return;
+
+	end_pfn = p->node_start_pfn + p->node_spanned_pages;
+#ifdef CONFIG_HIGHMEM
+	if (end_pfn > max_low_pfn)
+		end_pfn = max_low_pfn;
+#endif
+
+	total_pages = bootmem_bootmap_pages(end_pfn - p->node_start_pfn);
+
+	paddr = memblock_alloc(total_pages << PAGE_SHIFT, PAGE_SIZE);
+	if (!paddr)
+		panic("Can't allocate bootmap for nid[%d]\n", nid);
+
+	init_bootmem_node(p, paddr >> PAGE_SHIFT, p->node_start_pfn, end_pfn);
+
+	free_bootmem_with_active_regions(nid, end_pfn);
+
+	/*
+	 * XXX Handle initial reservations for the system memory node
+	 * only for the moment, we'll refactor this later for handling
+	 * reservations in other nodes.
+	 */
+	if (nid == 0) {
+		struct memblock_region *reg;
+
+		/* Reserve the sections we're already using. */
+		for_each_memblock(reserved, reg) {
+			unsigned long size = reg->size;
+
+#ifdef CONFIG_HIGHMEM
+			/* ...but not highmem */
+			if (PFN_DOWN(reg->base) >= highstart_pfn)
+				continue;
+
+			if (PFN_UP(reg->base + size) > highstart_pfn)
+				size = (highstart_pfn - PFN_DOWN(reg->base))
+				       << PAGE_SHIFT;
+#endif
+
+			reserve_bootmem(reg->base, size, BOOTMEM_DEFAULT);
+		}
+	}
+
+	sparse_memory_present_with_active_regions(nid);
+}
+
+static void __init do_init_bootmem(void)
+{
+	struct memblock_region *reg;
+	int i;
+
+	/* Add active regions with valid PFNs. */
+	for_each_memblock(memory, reg) {
+		unsigned long start_pfn, end_pfn;
+		start_pfn = memblock_region_memory_base_pfn(reg);
+		end_pfn = memblock_region_memory_end_pfn(reg);
+		memblock_set_node(PFN_PHYS(start_pfn),
+				  PFN_PHYS(end_pfn - start_pfn), 0);
+	}
+
+	/* All of system RAM sits in node 0 for the non-NUMA case */
+	allocate_pgdat(0);
+	node_set_online(0);
+
+	soc_mem_setup();
+
+	for_each_online_node(i)
+		bootmem_init_one_node(i);
+
+	sparse_init();
+}
+
+extern char _heap_start[];
+
+static void __init init_and_reserve_mem(void)
+{
+	unsigned long start_pfn, heap_start;
+	u64 base = min_low_pfn << PAGE_SHIFT;
+	u64 size = (max_low_pfn << PAGE_SHIFT) - base;
+
+	heap_start = (unsigned long) &_heap_start;
+
+	memblock_add(base, size);
+
+	/*
+	 * Partially used pages are not usable - thus
+	 * we are rounding upwards:
+	 */
+	start_pfn = PFN_UP(__pa(heap_start));
+
+	/*
+	 * Reserve the kernel text.
+	 */
+	memblock_reserve(base, (PFN_PHYS(start_pfn) + PAGE_SIZE - 1) - base);
+
+#ifdef CONFIG_HIGHMEM
+	/*
+	 * Add & reserve highmem, so page structures are initialised.
+	 */
+	base = highstart_pfn << PAGE_SHIFT;
+	size = (highend_pfn << PAGE_SHIFT) - base;
+	if (size) {
+		memblock_add(base, size);
+		memblock_reserve(base, size);
+	}
+#endif
+}
+
+#ifdef CONFIG_HIGHMEM
+/*
+ * Ensure we have allocated page tables in swapper_pg_dir for the
+ * fixed mappings range from 'start' to 'end'.
+ */
+static void __init allocate_pgtables(unsigned long start, unsigned long end)
+{
+	pgd_t *pgd;
+	pmd_t *pmd;
+	pte_t *pte;
+	int i, j;
+	unsigned long vaddr;
+
+	vaddr = start;
+	i = pgd_index(vaddr);
+	j = pmd_index(vaddr);
+	pgd = swapper_pg_dir + i;
+
+	for ( ; (i < PTRS_PER_PGD) && (vaddr != end); pgd++, i++) {
+		pmd = (pmd_t *)pgd;
+		for (; (j < PTRS_PER_PMD) && (vaddr != end); pmd++, j++) {
+			vaddr += PMD_SIZE;
+
+			if (!pmd_none(*pmd))
+				continue;
+
+			pte = (pte_t *)alloc_bootmem_low_pages(PAGE_SIZE);
+			pmd_populate_kernel(&init_mm, pmd, pte);
+		}
+		j = 0;
+	}
+}
+
+static void __init fixedrange_init(void)
+{
+	unsigned long vaddr, end;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	/*
+	 * Fixed mappings:
+	 */
+	vaddr = __fix_to_virt(__end_of_fixed_addresses - 1) & PMD_MASK;
+	end = (FIXADDR_TOP + PMD_SIZE - 1) & PMD_MASK;
+	allocate_pgtables(vaddr, end);
+
+	/*
+	 * Permanent kmaps:
+	 */
+	vaddr = PKMAP_BASE;
+	allocate_pgtables(vaddr, vaddr + PAGE_SIZE*LAST_PKMAP);
+
+	pgd = swapper_pg_dir + pgd_index(vaddr);
+	pud = pud_offset(pgd, vaddr);
+	pmd = pmd_offset(pud, vaddr);
+	pte = pte_offset_kernel(pmd, vaddr);
+	pkmap_page_table = pte;
+}
+#endif /* CONFIG_HIGHMEM */
+
+/*
+ * paging_init() continues the virtual memory environment setup which
+ * was begun by the code in arch/metag/kernel/setup.c.
+ */
+void __init paging_init(unsigned long mem_end)
+{
+	unsigned long max_zone_pfns[MAX_NR_ZONES];
+	int nid;
+
+	init_and_reserve_mem();
+
+	memblock_allow_resize();
+
+	memblock_dump_all();
+
+	nodes_clear(node_online_map);
+
+	init_new_context(&init_task, &init_mm);
+
+	memset(swapper_pg_dir, 0, sizeof(swapper_pg_dir));
+
+	do_init_bootmem();
+	mmu_init(mem_end);
+
+#ifdef CONFIG_HIGHMEM
+	fixedrange_init();
+	kmap_init();
+#endif
+
+	/* Initialize the zero page to a bootmem page, already zeroed. */
+	empty_zero_page = (unsigned long)alloc_bootmem_pages(PAGE_SIZE);
+
+	user_gateway_init();
+
+	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
+
+	for_each_online_node(nid) {
+		pg_data_t *pgdat = NODE_DATA(nid);
+		unsigned long low, start_pfn;
+
+		start_pfn = pgdat->bdata->node_min_pfn;
+		low = pgdat->bdata->node_low_pfn;
+
+		if (max_zone_pfns[ZONE_NORMAL] < low)
+			max_zone_pfns[ZONE_NORMAL] = low;
+
+#ifdef CONFIG_HIGHMEM
+		max_zone_pfns[ZONE_HIGHMEM] = highend_pfn;
+#endif
+		pr_info("Node %u: start_pfn = 0x%lx, low = 0x%lx\n",
+			nid, start_pfn, low);
+	}
+
+	free_area_init_nodes(max_zone_pfns);
+}
+
+void __init mem_init(void)
+{
+	int nid;
+
+#ifdef CONFIG_HIGHMEM
+	unsigned long tmp;
+	for (tmp = highstart_pfn; tmp < highend_pfn; tmp++) {
+		struct page *page = pfn_to_page(tmp);
+		ClearPageReserved(page);
+		init_page_count(page);
+		__free_page(page);
+		totalhigh_pages++;
+	}
+	totalram_pages += totalhigh_pages;
+	num_physpages += totalhigh_pages;
+#endif /* CONFIG_HIGHMEM */
+
+	for_each_online_node(nid) {
+		pg_data_t *pgdat = NODE_DATA(nid);
+		unsigned long node_pages = 0;
+
+		num_physpages += pgdat->node_present_pages;
+
+		if (pgdat->node_spanned_pages)
+			node_pages = free_all_bootmem_node(pgdat);
+
+		totalram_pages += node_pages;
+	}
+
+	pr_info("Memory: %luk/%luk available\n",
+		(unsigned long)nr_free_pages() << (PAGE_SHIFT - 10),
+		num_physpages << (PAGE_SHIFT - 10));
+
+	show_mem(0);
+
+	return;
+}
+
+static void free_init_pages(char *what, unsigned long begin, unsigned long end)
+{
+	unsigned long addr;
+
+	for (addr = begin; addr < end; addr += PAGE_SIZE) {
+		ClearPageReserved(virt_to_page(addr));
+		init_page_count(virt_to_page(addr));
+		memset((void *)addr, POISON_FREE_INITMEM, PAGE_SIZE);
+		free_page(addr);
+		totalram_pages++;
+	}
+	pr_info("Freeing %s: %luk freed\n", what, (end - begin) >> 10);
+}
+
+void free_initmem(void)
+{
+	free_init_pages("unused kernel memory",
+			(unsigned long)(&__init_begin),
+			(unsigned long)(&__init_end));
+}
+
+#ifdef CONFIG_BLK_DEV_INITRD
+void free_initrd_mem(unsigned long start, unsigned long end)
+{
+	end = end & PAGE_MASK;
+	free_init_pages("initrd memory", start, end);
+}
+#endif
+
+#ifdef CONFIG_OF_FLATTREE
+void __init early_init_dt_setup_initrd_arch(unsigned long start,
+					    unsigned long end)
+{
+	pr_err("%s(%lx, %lx)\n",
+	       __func__, start, end);
+}
+#endif /* CONFIG_OF_FLATTREE */
diff --git a/arch/metag/mm/mmu-meta1.c b/arch/metag/mm/mmu-meta1.c
new file mode 100644
index 0000000..91f4255
--- /dev/null
+++ b/arch/metag/mm/mmu-meta1.c
@@ -0,0 +1,157 @@
+/*
+ *  Copyright (C) 2005,2006,2007,2008,2009 Imagination Technologies
+ *
+ * Meta 1 MMU handling code.
+ *
+ */
+
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/io.h>
+
+#include <asm/mmu.h>
+
+#define DM3_BASE (LINSYSDIRECT_BASE + (MMCU_DIRECTMAPn_ADDR_SCALE * 3))
+
+/*
+ * This contains the physical address of the top level 2k pgd table.
+ */
+static unsigned long mmu_base_phys;
+
+/*
+ * Given a physical address, return a mapped virtual address that can be used
+ * to access that location.
+ * In practice, we use the DirectMap region to make this happen.
+ */
+static unsigned long map_addr(unsigned long phys)
+{
+	static unsigned long dm_base = 0xFFFFFFFF;
+	int offset;
+
+	offset = phys - dm_base;
+
+	/* Are we in the current map range ? */
+	if ((offset < 0) || (offset >= MMCU_DIRECTMAPn_ADDR_SCALE)) {
+		/* Calculate new DM area */
+		dm_base = phys & ~(MMCU_DIRECTMAPn_ADDR_SCALE - 1);
+
+		/* Actually map it in! */
+		metag_out32(dm_base, MMCU_DIRECTMAP3_ADDR);
+
+		/* And calculate how far into that area our reference is */
+		offset = phys - dm_base;
+	}
+
+	return DM3_BASE + offset;
+}
+
+/*
+ * Return the physical address of the base of our pgd table.
+ */
+static inline unsigned long __get_mmu_base(void)
+{
+	unsigned long base_phys;
+	unsigned int stride;
+
+	if (is_global_space(PAGE_OFFSET))
+		stride = 4;
+	else
+		stride = hard_processor_id();	/* [0..3] */
+
+	base_phys = metag_in32(MMCU_TABLE_PHYS_ADDR);
+	base_phys += (0x800 * stride);
+
+	return base_phys;
+}
+
+/* Given a virtual address, return the virtual address of the relevant pgd */
+static unsigned long pgd_entry_addr(unsigned long virt)
+{
+	unsigned long pgd_phys;
+	unsigned long pgd_virt;
+
+	if (!mmu_base_phys)
+		mmu_base_phys = __get_mmu_base();
+
+	/*
+	 * Are we trying to map a global address.  If so, then index
+	 * the global pgd table instead of our local one.
+	 */
+	if (is_global_space(virt)) {
+		/* Scale into 2gig map */
+		virt &= ~0x80000000;
+	}
+
+	/* Base of the pgd table plus our 4Meg entry, 4bytes each */
+	pgd_phys = mmu_base_phys + ((virt >> PGDIR_SHIFT) * 4);
+
+	pgd_virt = map_addr(pgd_phys);
+
+	return pgd_virt;
+}
+
+/* Given a virtual address, return the virtual address of the relevant pte */
+static unsigned long pgtable_entry_addr(unsigned long virt)
+{
+	unsigned long pgtable_phys;
+	unsigned long pgtable_virt, pte_virt;
+
+	/* Find the physical address of the 4MB page table*/
+	pgtable_phys = metag_in32(pgd_entry_addr(virt)) & MMCU_ENTRY_ADDR_BITS;
+
+	/* Map it to a virtual address */
+	pgtable_virt = map_addr(pgtable_phys);
+
+	/* And index into it for our pte */
+	pte_virt = pgtable_virt + ((virt >> PAGE_SHIFT) & 0x3FF) * 4;
+
+	return pte_virt;
+}
+
+unsigned long mmu_read_first_level_page(unsigned long vaddr)
+{
+	return metag_in32(pgd_entry_addr(vaddr));
+}
+
+unsigned long mmu_read_second_level_page(unsigned long vaddr)
+{
+	return metag_in32(pgtable_entry_addr(vaddr));
+}
+
+unsigned long mmu_get_base(void)
+{
+	static unsigned long __base;
+
+	/* Find the base of our MMU pgd table */
+	if (!__base)
+		__base = pgd_entry_addr(0);
+
+	return __base;
+}
+
+void __init mmu_init(unsigned long mem_end)
+{
+	unsigned long entry, addr;
+	pgd_t *p_swapper_pg_dir;
+
+	/*
+	 * Now copy over any MMU pgd entries already in the mmu page tables
+	 * over to our root init process (swapper_pg_dir) map.  This map is
+	 * then inherited by all other processes, which means all processes
+	 * inherit a map of the kernel space.
+	 */
+	addr = PAGE_OFFSET;
+	entry = pgd_index(PAGE_OFFSET);
+	p_swapper_pg_dir = pgd_offset_k(0) + entry;
+
+	while (addr <= META_MEMORY_LIMIT) {
+		unsigned long pgd_entry;
+		/* copy over the current MMU value */
+		pgd_entry = mmu_read_first_level_page(addr);
+		pgd_val(*p_swapper_pg_dir) = pgd_entry;
+
+		p_swapper_pg_dir++;
+		addr += PGDIR_SIZE;
+		entry++;
+	}
+}
diff --git a/arch/metag/mm/mmu-meta2.c b/arch/metag/mm/mmu-meta2.c
new file mode 100644
index 0000000..f3d38c4
--- /dev/null
+++ b/arch/metag/mm/mmu-meta2.c
@@ -0,0 +1,208 @@
+/*
+ * Copyright (C) 2008,2009,2010,2011 Imagination Technologies Ltd.
+ *
+ * Meta 2 enhanced mode MMU handling code.
+ *
+ */
+
+#include <linux/mm.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <linux/bootmem.h>
+#include <linux/syscore_ops.h>
+
+#include <asm/mmu.h>
+#include <asm/mmu_context.h>
+
+unsigned long mmu_read_first_level_page(unsigned long vaddr)
+{
+	unsigned int cpu = hard_processor_id();
+	unsigned long offset, linear_base, linear_limit;
+	unsigned int phys0;
+	pgd_t *pgd, entry;
+
+	if (is_global_space(vaddr))
+		vaddr &= ~0x80000000;
+
+	offset = vaddr >> PGDIR_SHIFT;
+
+	phys0 = metag_in32(mmu_phys0_addr(cpu));
+
+	/* Top bit of linear base is always zero. */
+	linear_base = (phys0 >> PGDIR_SHIFT) & 0x1ff;
+
+	/* Limit in the range 0 (4MB) to 9 (2GB). */
+	linear_limit = 1 << ((phys0 >> 8) & 0xf);
+	linear_limit += linear_base;
+
+	/*
+	 * If offset is below linear base or above the limit then no
+	 * mapping exists.
+	 */
+	if (offset < linear_base || offset > linear_limit)
+		return 0;
+
+	offset -= linear_base;
+	pgd = (pgd_t *)mmu_get_base();
+	entry = pgd[offset];
+
+	return pgd_val(entry);
+}
+
+unsigned long mmu_read_second_level_page(unsigned long vaddr)
+{
+	unsigned long entry = TBIXCACHE_RD(vaddr & PAGE_MASK);
+	return entry;
+}
+
+unsigned long mmu_get_base(void)
+{
+	unsigned int cpu = hard_processor_id();
+	unsigned long stride;
+
+	stride = cpu * LINSYSMEMTnX_STRIDE;
+
+	/*
+	 * Bits 18:2 of the MMCU_TnLocal_TABLE_PHYS1 register should be
+	 * used as an offset to the start of the top-level pgd table.
+	 */
+	stride += (metag_in32(mmu_phys1_addr(cpu)) & 0x7fffc);
+
+	if (is_global_space(PAGE_OFFSET))
+		stride += LINSYSMEMTXG_OFFSET;
+
+	return LINSYSMEMT0L_BASE + stride;
+}
+
+#define FIRST_LEVEL_MASK	0xffffffc0
+#define SECOND_LEVEL_MASK	0xfffff000
+#define SECOND_LEVEL_ALIGN	64
+
+static void repriv_mmu_tables(void)
+{
+	unsigned long phys0_addr;
+	unsigned int g;
+
+	/*
+	 * Check that all the mmu table regions are priv protected, and if not
+	 * fix them and emit a warning. If we left them without priv protection
+	 * then userland processes would have access to a 2M window into
+	 * physical memory near where the page tables are.
+	 */
+	phys0_addr = MMCU_T0LOCAL_TABLE_PHYS0;
+	for (g = 0; g < 2; ++g) {
+		unsigned int t, phys0;
+		unsigned long flags;
+		for (t = 0; t < 4; ++t) {
+			__global_lock2(flags);
+			phys0 = metag_in32(phys0_addr);
+			if ((phys0 & _PAGE_PRESENT) && !(phys0 & _PAGE_PRIV)) {
+				pr_warn("Fixing priv protection on T%d %s MMU table region\n",
+					t,
+					g ? "global" : "local");
+				phys0 |= _PAGE_PRIV;
+				metag_out32(phys0, phys0_addr);
+			}
+			__global_unlock2(flags);
+
+			phys0_addr += MMCU_TnX_TABLE_PHYSX_STRIDE;
+		}
+
+		phys0_addr += MMCU_TXG_TABLE_PHYSX_OFFSET
+			    - 4*MMCU_TnX_TABLE_PHYSX_STRIDE;
+	}
+}
+
+#ifdef CONFIG_METAG_SUSPEND_MEM
+static void mmu_resume(void)
+{
+	/*
+	 * If a full suspend to RAM has happened then the original bad MMU table
+	 * priv may have been restored, so repriv them again.
+	 */
+	repriv_mmu_tables();
+}
+#else
+#define mmu_resume NULL
+#endif	/* CONFIG_METAG_SUSPEND_MEM */
+
+static struct syscore_ops mmu_syscore_ops = {
+	.resume  = mmu_resume,
+};
+
+void __init mmu_init(unsigned long mem_end)
+{
+	unsigned long entry, addr;
+	pgd_t *p_swapper_pg_dir;
+#ifdef CONFIG_KERNEL_4M_PAGES
+	unsigned long mem_size = mem_end - PAGE_OFFSET;
+	unsigned int pages = DIV_ROUND_UP(mem_size, 1 << 22);
+	unsigned int second_level_entry = 0;
+	unsigned long *second_level_table;
+#endif
+
+	/*
+	 * Now copy over any MMU pgd entries already in the mmu page tables
+	 * over to our root init process (swapper_pg_dir) map.  This map is
+	 * then inherited by all other processes, which means all processes
+	 * inherit a map of the kernel space.
+	 */
+	addr = META_MEMORY_BASE;
+	entry = pgd_index(META_MEMORY_BASE);
+	p_swapper_pg_dir = pgd_offset_k(0) + entry;
+
+	while (entry < (PTRS_PER_PGD - pgd_index(META_MEMORY_BASE))) {
+		unsigned long pgd_entry;
+		/* copy over the current MMU value */
+		pgd_entry = mmu_read_first_level_page(addr);
+		pgd_val(*p_swapper_pg_dir) = pgd_entry;
+
+		p_swapper_pg_dir++;
+		addr += PGDIR_SIZE;
+		entry++;
+	}
+
+#ifdef CONFIG_KERNEL_4M_PAGES
+	/*
+	 * At this point we can also map the kernel with 4MB pages to
+	 * reduce TLB pressure.
+	 */
+	second_level_table = alloc_bootmem_pages(SECOND_LEVEL_ALIGN * pages);
+
+	addr = PAGE_OFFSET;
+	entry = pgd_index(PAGE_OFFSET);
+	p_swapper_pg_dir = pgd_offset_k(0) + entry;
+
+	while (pages > 0) {
+		unsigned long phys_addr, second_level_phys;
+		pte_t *pte = (pte_t *)&second_level_table[second_level_entry];
+
+		phys_addr = __pa(addr);
+
+		second_level_phys = __pa(pte);
+
+		pgd_val(*p_swapper_pg_dir) = ((second_level_phys &
+					       FIRST_LEVEL_MASK) |
+					      _PAGE_SZ_4M |
+					      _PAGE_PRESENT);
+
+		pte_val(*pte) = ((phys_addr & SECOND_LEVEL_MASK) |
+				 _PAGE_PRESENT | _PAGE_DIRTY |
+				 _PAGE_ACCESSED | _PAGE_WRITE |
+				 _PAGE_CACHEABLE | _PAGE_KERNEL);
+
+		p_swapper_pg_dir++;
+		addr += PGDIR_SIZE;
+		/* Second level pages must be 64byte aligned. */
+		second_level_entry += (SECOND_LEVEL_ALIGN /
+				       sizeof(unsigned long));
+		pages--;
+	}
+	load_pgd(swapper_pg_dir, hard_processor_id());
+	flush_tlb_all();
+#endif
+
+	repriv_mmu_tables();
+	register_syscore_ops(&mmu_syscore_ops);
+}
-- 
1.7.7.6


