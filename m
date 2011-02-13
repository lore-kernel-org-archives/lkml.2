Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403Ab1BMGix (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 01:38:53 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:56115 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab1BMGiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 01:38:46 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "'Greg KH'" <greg@kroah.com>
Subject: [PATCHv2 08/11] unicore32 core architecture: mm related: consistent device DMA handling
Date: Sun, 13 Feb 2011 14:38:36 +0800
Message-ID: <02f101cbcb48$a46271b0$ed275510$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcvLSJigkn/Y7zrATFKCjlTXmaV1+Q==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements consistent device DMA handling of memory management.
DMA device operations are also here.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/cacheflush.h  |  211 +++++++++++++++++++++++++++++
 arch/unicore32/include/asm/dma-mapping.h |  124 +++++++++++++++++
 arch/unicore32/include/asm/dma.h         |   23 ++++
 arch/unicore32/include/asm/tlbflush.h    |  195 +++++++++++++++++++++++++++
 arch/unicore32/include/mach/dma.h        |   41 ++++++
 arch/unicore32/kernel/dma.c              |  180 +++++++++++++++++++++++++
 arch/unicore32/mm/cache-ucv2.S           |  212 ++++++++++++++++++++++++++++++
 arch/unicore32/mm/dma-swiotlb.c          |   34 +++++
 arch/unicore32/mm/flush.c                |   98 ++++++++++++++
 arch/unicore32/mm/tlb-ucv2.S             |   89 +++++++++++++
 10 files changed, 1207 insertions(+), 0 deletions(-)
 create mode 100644 arch/unicore32/include/asm/cacheflush.h
 create mode 100644 arch/unicore32/include/asm/dma-mapping.h
 create mode 100644 arch/unicore32/include/asm/dma.h
 create mode 100644 arch/unicore32/include/asm/tlbflush.h
 create mode 100644 arch/unicore32/include/mach/dma.h
 create mode 100644 arch/unicore32/kernel/dma.c
 create mode 100644 arch/unicore32/mm/cache-ucv2.S
 create mode 100644 arch/unicore32/mm/dma-swiotlb.c
 create mode 100644 arch/unicore32/mm/flush.c
 create mode 100644 arch/unicore32/mm/tlb-ucv2.S

diff --git a/arch/unicore32/include/asm/cacheflush.h b/arch/unicore32/include/asm/cacheflush.h
new file mode 100644
index 0000000..c0301e6
--- /dev/null
+++ b/arch/unicore32/include/asm/cacheflush.h
@@ -0,0 +1,211 @@
+/*
+ * linux/arch/unicore32/include/asm/cacheflush.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_CACHEFLUSH_H__
+#define __UNICORE_CACHEFLUSH_H__
+
+#include <linux/mm.h>
+
+#include <asm/shmparam.h>
+
+#define CACHE_COLOUR(vaddr)	((vaddr & (SHMLBA - 1)) >> PAGE_SHIFT)
+
+/*
+ * This flag is used to indicate that the page pointed to by a pte is clean
+ * and does not require cleaning before returning it to the user.
+ */
+#define PG_dcache_clean PG_arch_1
+
+/*
+ *	MM Cache Management
+ *	===================
+ *
+ *	The arch/unicore32/mm/cache.S files implement these methods.
+ *
+ *	Start addresses are inclusive and end addresses are exclusive;
+ *	start addresses should be rounded down, end addresses up.
+ *
+ *	See Documentation/cachetlb.txt for more information.
+ *	Please note that the implementation of these, and the required
+ *	effects are cache-type (VIVT/VIPT/PIPT) specific.
+ *
+ *	flush_icache_all()
+ *
+ *		Unconditionally clean and invalidate the entire icache.
+ *		Currently only needed for cache-v6.S and cache-v7.S, see
+ *		__flush_icache_all for the generic implementation.
+ *
+ *	flush_kern_all()
+ *
+ *		Unconditionally clean and invalidate the entire cache.
+ *
+ *	flush_user_all()
+ *
+ *		Clean and invalidate all user space cache entries
+ *		before a change of page tables.
+ *
+ *	flush_user_range(start, end, flags)
+ *
+ *		Clean and invalidate a range of cache entries in the
+ *		specified address space before a change of page tables.
+ *		- start - user start address (inclusive, page aligned)
+ *		- end   - user end address   (exclusive, page aligned)
+ *		- flags - vma->vm_flags field
+ *
+ *	coherent_kern_range(start, end)
+ *
+ *		Ensure coherency between the Icache and the Dcache in the
+ *		region described by start, end.  If you have non-snooping
+ *		Harvard caches, you need to implement this function.
+ *		- start  - virtual start address
+ *		- end    - virtual end address
+ *
+ *	coherent_user_range(start, end)
+ *
+ *		Ensure coherency between the Icache and the Dcache in the
+ *		region described by start, end.  If you have non-snooping
+ *		Harvard caches, you need to implement this function.
+ *		- start  - virtual start address
+ *		- end    - virtual end address
+ *
+ *	flush_kern_dcache_area(kaddr, size)
+ *
+ *		Ensure that the data held in page is written back.
+ *		- kaddr  - page address
+ *		- size   - region size
+ *
+ *	DMA Cache Coherency
+ *	===================
+ *
+ *	dma_flush_range(start, end)
+ *
+ *		Clean and invalidate the specified virtual address range.
+ *		- start  - virtual start address
+ *		- end    - virtual end address
+ */
+
+extern void __cpuc_flush_icache_all(void);
+extern void __cpuc_flush_kern_all(void);
+extern void __cpuc_flush_user_all(void);
+extern void __cpuc_flush_user_range(unsigned long, unsigned long, unsigned int);
+extern void __cpuc_coherent_kern_range(unsigned long, unsigned long);
+extern void __cpuc_coherent_user_range(unsigned long, unsigned long);
+extern void __cpuc_flush_dcache_area(void *, size_t);
+extern void __cpuc_flush_kern_dcache_area(void *addr, size_t size);
+
+/*
+ * These are private to the dma-mapping API.  Do not use directly.
+ * Their sole purpose is to ensure that data held in the cache
+ * is visible to DMA, or data written by DMA to system memory is
+ * visible to the CPU.
+ */
+extern void __cpuc_dma_clean_range(unsigned long, unsigned long);
+extern void __cpuc_dma_flush_range(unsigned long, unsigned long);
+
+/*
+ * Copy user data from/to a page which is mapped into a different
+ * processes address space.  Really, we want to allow our "user
+ * space" model to handle this.
+ */
+extern void copy_to_user_page(struct vm_area_struct *, struct page *,
+	unsigned long, void *, const void *, unsigned long);
+#define copy_from_user_page(vma, page, vaddr, dst, src, len)	\
+	do {							\
+		memcpy(dst, src, len);				\
+	} while (0)
+
+/*
+ * Convert calls to our calling convention.
+ */
+/* Invalidate I-cache */
+static inline void __flush_icache_all(void)
+{
+	asm("movc	p0.c5, %0, #20;\n"
+	    "nop; nop; nop; nop; nop; nop; nop; nop\n"
+	    :
+	    : "r" (0));
+}
+
+#define flush_cache_all()		__cpuc_flush_kern_all()
+
+extern void flush_cache_mm(struct mm_struct *mm);
+extern void flush_cache_range(struct vm_area_struct *vma,
+		unsigned long start, unsigned long end);
+extern void flush_cache_page(struct vm_area_struct *vma,
+		unsigned long user_addr, unsigned long pfn);
+
+#define flush_cache_dup_mm(mm) flush_cache_mm(mm)
+
+/*
+ * flush_cache_user_range is used when we want to ensure that the
+ * Harvard caches are synchronised for the user space address range.
+ * This is used for the UniCore private sys_cacheflush system call.
+ */
+#define flush_cache_user_range(vma, start, end) \
+	__cpuc_coherent_user_range((start) & PAGE_MASK, PAGE_ALIGN(end))
+
+/*
+ * Perform necessary cache operations to ensure that data previously
+ * stored within this range of addresses can be executed by the CPU.
+ */
+#define flush_icache_range(s, e)	__cpuc_coherent_kern_range(s, e)
+
+/*
+ * Perform necessary cache operations to ensure that the TLB will
+ * see data written in the specified area.
+ */
+#define clean_dcache_area(start, size)	cpu_dcache_clean_area(start, size)
+
+/*
+ * flush_dcache_page is used when the kernel has written to the page
+ * cache page at virtual address page->virtual.
+ *
+ * If this page isn't mapped (ie, page_mapping == NULL), or it might
+ * have userspace mappings, then we _must_ always clean + invalidate
+ * the dcache entries associated with the kernel mapping.
+ *
+ * Otherwise we can defer the operation, and clean the cache when we are
+ * about to change to user space.  This is the same method as used on SPARC64.
+ * See update_mmu_cache for the user space part.
+ */
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
+extern void flush_dcache_page(struct page *);
+
+#define flush_dcache_mmap_lock(mapping)			\
+	spin_lock_irq(&(mapping)->tree_lock)
+#define flush_dcache_mmap_unlock(mapping)		\
+	spin_unlock_irq(&(mapping)->tree_lock)
+
+#define flush_icache_user_range(vma, page, addr, len)	\
+	flush_dcache_page(page)
+
+/*
+ * We don't appear to need to do anything here.  In fact, if we did, we'd
+ * duplicate cache flushing elsewhere performed by flush_dcache_page().
+ */
+#define flush_icache_page(vma, page)	do { } while (0)
+
+/*
+ * flush_cache_vmap() is used when creating mappings (eg, via vmap,
+ * vmalloc, ioremap etc) in kernel space for pages.  On non-VIPT
+ * caches, since the direct-mappings of these pages may contain cached
+ * data, we need to do a full cache flush to ensure that writebacks
+ * don't corrupt data placed into these pages via the new mappings.
+ */
+static inline void flush_cache_vmap(unsigned long start, unsigned long end)
+{
+}
+
+static inline void flush_cache_vunmap(unsigned long start, unsigned long end)
+{
+}
+
+#endif
diff --git a/arch/unicore32/include/asm/dma-mapping.h b/arch/unicore32/include/asm/dma-mapping.h
new file mode 100644
index 0000000..9258e59
--- /dev/null
+++ b/arch/unicore32/include/asm/dma-mapping.h
@@ -0,0 +1,124 @@
+/*
+ * linux/arch/unicore32/include/asm/dma-mapping.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_DMA_MAPPING_H__
+#define __UNICORE_DMA_MAPPING_H__
+
+#ifdef __KERNEL__
+
+#include <linux/mm_types.h>
+#include <linux/scatterlist.h>
+#include <linux/swiotlb.h>
+
+#include <asm-generic/dma-coherent.h>
+
+#include <asm/memory.h>
+#include <asm/cacheflush.h>
+
+extern struct dma_map_ops swiotlb_dma_map_ops;
+
+static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+{
+	return &swiotlb_dma_map_ops;
+}
+
+static inline int dma_supported(struct device *dev, u64 mask)
+{
+	struct dma_map_ops *dma_ops = get_dma_ops(dev);
+
+	if (unlikely(dma_ops == NULL))
+		return 0;
+
+	return dma_ops->dma_supported(dev, mask);
+}
+
+static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	struct dma_map_ops *dma_ops = get_dma_ops(dev);
+
+	if (dma_ops->mapping_error)
+		return dma_ops->mapping_error(dev, dma_addr);
+
+	return 0;
+}
+
+#include <asm-generic/dma-mapping-common.h>
+
+static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
+{
+	if (dev && dev->dma_mask)
+		return addr + size - 1 <= *dev->dma_mask;
+
+	return 1;
+}
+
+static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
+{
+	return paddr;
+}
+
+static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
+{
+	return daddr;
+}
+
+static inline void dma_mark_clean(void *addr, size_t size) {}
+
+static inline int dma_set_mask(struct device *dev, u64 dma_mask)
+{
+	if (!dev->dma_mask || !dma_supported(dev, dma_mask))
+		return -EIO;
+
+	*dev->dma_mask = dma_mask;
+
+	return 0;
+}
+
+static inline void *dma_alloc_coherent(struct device *dev, size_t size,
+				       dma_addr_t *dma_handle, gfp_t flag)
+{
+	struct dma_map_ops *dma_ops = get_dma_ops(dev);
+
+	return dma_ops->alloc_coherent(dev, size, dma_handle, flag);
+}
+
+static inline void dma_free_coherent(struct device *dev, size_t size,
+				     void *cpu_addr, dma_addr_t dma_handle)
+{
+	struct dma_map_ops *dma_ops = get_dma_ops(dev);
+
+	dma_ops->free_coherent(dev, size, cpu_addr, dma_handle);
+}
+
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
+#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
+
+static inline void dma_cache_sync(struct device *dev, void *vaddr,
+		size_t size, enum dma_data_direction direction)
+{
+	unsigned long start = (unsigned long)vaddr;
+	unsigned long end   = start + size;
+
+	switch (direction) {
+	case DMA_NONE:
+		BUG();
+	case DMA_FROM_DEVICE:
+	case DMA_BIDIRECTIONAL:	/* writeback and invalidate */
+		__cpuc_dma_flush_range(start, end);
+		break;
+	case DMA_TO_DEVICE:		/* writeback only */
+		__cpuc_dma_clean_range(start, end);
+		break;
+	}
+}
+
+#endif /* __KERNEL__ */
+#endif
diff --git a/arch/unicore32/include/asm/dma.h b/arch/unicore32/include/asm/dma.h
new file mode 100644
index 0000000..38dfff9
--- /dev/null
+++ b/arch/unicore32/include/asm/dma.h
@@ -0,0 +1,23 @@
+/*
+ * linux/arch/unicore32/include/asm/dma.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __UNICORE_DMA_H__
+#define __UNICORE_DMA_H__
+
+#include <asm/memory.h>
+#include <asm-generic/dma.h>
+
+#ifdef CONFIG_PCI
+extern int isa_dma_bridge_buggy;
+#endif
+
+#endif /* __UNICORE_DMA_H__ */
diff --git a/arch/unicore32/include/asm/tlbflush.h b/arch/unicore32/include/asm/tlbflush.h
new file mode 100644
index 0000000..e446ac8
--- /dev/null
+++ b/arch/unicore32/include/asm/tlbflush.h
@@ -0,0 +1,195 @@
+/*
+ * linux/arch/unicore32/include/asm/tlbflush.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_TLBFLUSH_H__
+#define __UNICORE_TLBFLUSH_H__
+
+#ifndef __ASSEMBLY__
+
+#include <linux/sched.h>
+
+extern void __cpu_flush_user_tlb_range(unsigned long, unsigned long,
+					struct vm_area_struct *);
+extern void __cpu_flush_kern_tlb_range(unsigned long, unsigned long);
+
+/*
+ *	TLB Management
+ *	==============
+ *
+ *	The arch/unicore/mm/tlb-*.S files implement these methods.
+ *
+ *	The TLB specific code is expected to perform whatever tests it
+ *	needs to determine if it should invalidate the TLB for each
+ *	call.  Start addresses are inclusive and end addresses are
+ *	exclusive; it is safe to round these addresses down.
+ *
+ *	flush_tlb_all()
+ *
+ *		Invalidate the entire TLB.
+ *
+ *	flush_tlb_mm(mm)
+ *
+ *		Invalidate all TLB entries in a particular address
+ *		space.
+ *		- mm	- mm_struct describing address space
+ *
+ *	flush_tlb_range(mm,start,end)
+ *
+ *		Invalidate a range of TLB entries in the specified
+ *		address space.
+ *		- mm	- mm_struct describing address space
+ *		- start - start address (may not be aligned)
+ *		- end	- end address (exclusive, may not be aligned)
+ *
+ *	flush_tlb_page(vaddr,vma)
+ *
+ *		Invalidate the specified page in the specified address range.
+ *		- vaddr - virtual address (may not be aligned)
+ *		- vma	- vma_struct describing address range
+ *
+ *	flush_kern_tlb_page(kaddr)
+ *
+ *		Invalidate the TLB entry for the specified page.  The address
+ *		will be in the kernels virtual memory space.  Current uses
+ *		only require the D-TLB to be invalidated.
+ *		- kaddr - Kernel virtual memory address
+ */
+
+static inline void local_flush_tlb_all(void)
+{
+	const int zero = 0;
+
+	/* TLB invalidate all */
+	asm("movc p0.c6, %0, #6; nop; nop; nop; nop; nop; nop; nop; nop"
+		: : "r" (zero) : "cc");
+}
+
+static inline void local_flush_tlb_mm(struct mm_struct *mm)
+{
+	const int zero = 0;
+
+	if (cpumask_test_cpu(get_cpu(), mm_cpumask(mm))) {
+		/* TLB invalidate all */
+		asm("movc p0.c6, %0, #6; nop; nop; nop; nop; nop; nop; nop; nop"
+			: : "r" (zero) : "cc");
+	}
+	put_cpu();
+}
+
+static inline void
+local_flush_tlb_page(struct vm_area_struct *vma, unsigned long uaddr)
+{
+	if (cpumask_test_cpu(smp_processor_id(), mm_cpumask(vma->vm_mm))) {
+#ifndef CONFIG_CPU_TLB_SINGLE_ENTRY_DISABLE
+		/* iTLB invalidate page */
+		asm("movc p0.c6, %0, #5; nop; nop; nop; nop; nop; nop; nop; nop"
+			: : "r" (uaddr & PAGE_MASK) : "cc");
+		/* dTLB invalidate page */
+		asm("movc p0.c6, %0, #3; nop; nop; nop; nop; nop; nop; nop; nop"
+			: : "r" (uaddr & PAGE_MASK) : "cc");
+#else
+		/* TLB invalidate all */
+		asm("movc p0.c6, %0, #6; nop; nop; nop; nop; nop; nop; nop; nop"
+			: : "r" (uaddr & PAGE_MASK) : "cc");
+#endif
+	}
+}
+
+static inline void local_flush_tlb_kernel_page(unsigned long kaddr)
+{
+#ifndef CONFIG_CPU_TLB_SINGLE_ENTRY_DISABLE
+	/* iTLB invalidate page */
+	asm("movc p0.c6, %0, #5; nop; nop; nop; nop; nop; nop; nop; nop"
+		: : "r" (kaddr & PAGE_MASK) : "cc");
+	/* dTLB invalidate page */
+	asm("movc p0.c6, %0, #3; nop; nop; nop; nop; nop; nop; nop; nop"
+		: : "r" (kaddr & PAGE_MASK) : "cc");
+#else
+	/* TLB invalidate all */
+	asm("movc p0.c6, %0, #6; nop; nop; nop; nop; nop; nop; nop; nop"
+		: : "r" (kaddr & PAGE_MASK) : "cc");
+#endif
+}
+
+/*
+ *	flush_pmd_entry
+ *
+ *	Flush a PMD entry (word aligned, or double-word aligned) to
+ *	RAM if the TLB for the CPU we are running on requires this.
+ *	This is typically used when we are creating PMD entries.
+ *
+ *	clean_pmd_entry
+ *
+ *	Clean (but don't drain the write buffer) if the CPU requires
+ *	these operations.  This is typically used when we are removing
+ *	PMD entries.
+ */
+static inline void flush_pmd_entry(pmd_t *pmd)
+{
+#ifndef CONFIG_CPU_DCACHE_LINE_DISABLE
+	/* flush dcache line, see dcacheline_flush in proc-macros.S */
+	asm("mov	r1, %0 << #20\n"
+		"ldw	r2, =_stext\n"
+		"add	r2, r2, r1 >> #20\n"
+		"ldw	r1, [r2+], #0x0000\n"
+		"ldw	r1, [r2+], #0x1000\n"
+		"ldw	r1, [r2+], #0x2000\n"
+		"ldw	r1, [r2+], #0x3000\n"
+		: : "r" (pmd) : "r1", "r2");
+#else
+	/* flush dcache all */
+	asm("movc p0.c5, %0, #14; nop; nop; nop; nop; nop; nop; nop; nop"
+		: : "r" (pmd) : "cc");
+#endif
+}
+
+static inline void clean_pmd_entry(pmd_t *pmd)
+{
+#ifndef CONFIG_CPU_DCACHE_LINE_DISABLE
+	/* clean dcache line */
+	asm("movc p0.c5, %0, #11; nop; nop; nop; nop; nop; nop; nop; nop"
+		: : "r" (__pa(pmd) & ~(L1_CACHE_BYTES - 1)) : "cc");
+#else
+	/* clean dcache all */
+	asm("movc p0.c5, %0, #10; nop; nop; nop; nop; nop; nop; nop; nop"
+		: : "r" (pmd) : "cc");
+#endif
+}
+
+/*
+ * Convert calls to our calling convention.
+ */
+#define local_flush_tlb_range(vma, start, end)	\
+	__cpu_flush_user_tlb_range(start, end, vma)
+#define local_flush_tlb_kernel_range(s, e)	\
+	__cpu_flush_kern_tlb_range(s, e)
+
+#define flush_tlb_all		local_flush_tlb_all
+#define flush_tlb_mm		local_flush_tlb_mm
+#define flush_tlb_page		local_flush_tlb_page
+#define flush_tlb_kernel_page	local_flush_tlb_kernel_page
+#define flush_tlb_range		local_flush_tlb_range
+#define flush_tlb_kernel_range	local_flush_tlb_kernel_range
+
+/*
+ * if PG_dcache_clean is not set for the page, we need to ensure that any
+ * cache entries for the kernels virtual memory range are written
+ * back to the page.
+ */
+extern void update_mmu_cache(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep);
+
+extern void do_bad_area(unsigned long addr, unsigned int fsr,
+		struct pt_regs *regs);
+
+#endif
+
+#endif
diff --git a/arch/unicore32/include/mach/dma.h b/arch/unicore32/include/mach/dma.h
new file mode 100644
index 0000000..3e3224a
--- /dev/null
+++ b/arch/unicore32/include/mach/dma.h
@@ -0,0 +1,41 @@
+/*
+ * linux/arch/unicore32/include/mach/dma.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __MACH_PUV3_DMA_H__
+#define __MACH_PUV3_DMA_H__
+
+/*
+ * The PKUnity has six internal DMA channels.
+ */
+#define MAX_DMA_CHANNELS	6
+
+typedef enum {
+	DMA_PRIO_HIGH = 0,
+	DMA_PRIO_MEDIUM = 1,
+	DMA_PRIO_LOW = 2
+} puv3_dma_prio;
+
+/*
+ * DMA registration
+ */
+
+extern int puv3_request_dma(char *name,
+			 puv3_dma_prio prio,
+			 void (*irq_handler)(int, void *),
+			 void (*err_handler)(int, void *),
+			 void *data);
+
+extern void puv3_free_dma(int dma_ch);
+
+#define puv3_stop_dma(ch)		(DMAC_CONFIG(ch) &= ~DMAC_CONFIG_EN)
+#define puv3_resume_dma(ch)             (DMAC_CONFIG(ch) |= DMAC_CONFIG_EN)
+
+#endif /* __MACH_PUV3_DMA_H__ */
diff --git a/arch/unicore32/kernel/dma.c b/arch/unicore32/kernel/dma.c
new file mode 100644
index 0000000..b8dcc25
--- /dev/null
+++ b/arch/unicore32/kernel/dma.c
@@ -0,0 +1,180 @@
+/*
+ * linux/arch/unicore32/kernel/dma.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
+ *	Copyright (C) 2001-2010 Guan Xuetao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/errno.h>
+
+#include <asm/system.h>
+#include <asm/irq.h>
+#include <mach/hardware.h>
+#include <mach/dma.h>
+
+struct dma_channel {
+	char *name;
+	puv3_dma_prio prio;
+	void (*irq_handler)(int, void *);
+	void (*err_handler)(int, void *);
+	void *data;
+};
+
+static struct dma_channel dma_channels[MAX_DMA_CHANNELS];
+
+int puv3_request_dma(char *name, puv3_dma_prio prio,
+			 void (*irq_handler)(int, void *),
+			 void (*err_handler)(int, void *),
+			 void *data)
+{
+	unsigned long flags;
+	int i, found = 0;
+
+	/* basic sanity checks */
+	if (!name)
+		return -EINVAL;
+
+	local_irq_save(flags);
+
+	do {
+		/* try grabbing a DMA channel with the requested priority */
+		for (i = 0; i < MAX_DMA_CHANNELS; i++) {
+			if ((dma_channels[i].prio == prio) &&
+			    !dma_channels[i].name) {
+				found = 1;
+				break;
+			}
+		}
+		/* if requested prio group is full, try a hier priority */
+	} while (!found && prio--);
+
+	if (found) {
+		dma_channels[i].name = name;
+		dma_channels[i].irq_handler = irq_handler;
+		dma_channels[i].err_handler = err_handler;
+		dma_channels[i].data = data;
+	} else {
+		printk(KERN_WARNING "No more available DMA channels for %s\n",
+				name);
+		i = -ENODEV;
+	}
+
+	local_irq_restore(flags);
+	return i;
+}
+EXPORT_SYMBOL(puv3_request_dma);
+
+void puv3_free_dma(int dma_ch)
+{
+	unsigned long flags;
+
+	if (!dma_channels[dma_ch].name) {
+		printk(KERN_CRIT
+			"%s: trying to free channel %d which is already freed\n",
+			__func__, dma_ch);
+		return;
+	}
+
+	local_irq_save(flags);
+	dma_channels[dma_ch].name = NULL;
+	dma_channels[dma_ch].err_handler = NULL;
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL(puv3_free_dma);
+
+static irqreturn_t dma_irq_handler(int irq, void *dev_id)
+{
+	int i, dint = DMAC_ITCSR;
+
+	for (i = 0; i < MAX_DMA_CHANNELS; i++) {
+		if (dint & DMAC_CHANNEL(i)) {
+			struct dma_channel *channel = &dma_channels[i];
+
+			/* Clear TC interrupt of channel i */
+			DMAC_ITCCR = DMAC_CHANNEL(i);
+			DMAC_ITCCR = 0;
+
+			if (channel->name && channel->irq_handler) {
+				channel->irq_handler(i, channel->data);
+			} else {
+				/*
+				 * IRQ for an unregistered DMA channel:
+				 * let's clear the interrupts and disable it.
+				 */
+				printk(KERN_WARNING "spurious IRQ for"
+						" DMA channel %d\n", i);
+			}
+		}
+	}
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t dma_err_handler(int irq, void *dev_id)
+{
+	int i, dint = DMAC_IESR;
+
+	for (i = 0; i < MAX_DMA_CHANNELS; i++) {
+		if (dint & DMAC_CHANNEL(i)) {
+			struct dma_channel *channel = &dma_channels[i];
+
+			/* Clear Err interrupt of channel i */
+			DMAC_IECR = DMAC_CHANNEL(i);
+			DMAC_IECR = 0;
+
+			if (channel->name && channel->err_handler) {
+				channel->err_handler(i, channel->data);
+			} else {
+				/*
+				 * IRQ for an unregistered DMA channel:
+				 * let's clear the interrupts and disable it.
+				 */
+				printk(KERN_WARNING "spurious IRQ for"
+						" DMA channel %d\n", i);
+			}
+		}
+	}
+	return IRQ_HANDLED;
+}
+
+int __init puv3_init_dma(void)
+{
+	int i, ret;
+
+	/* dma channel priorities on v8 processors:
+	 * ch 0 - 1  <--> (0) DMA_PRIO_HIGH
+	 * ch 2 - 3  <--> (1) DMA_PRIO_MEDIUM
+	 * ch 4 - 5  <--> (2) DMA_PRIO_LOW
+	 */
+	for (i = 0; i < MAX_DMA_CHANNELS; i++) {
+		puv3_stop_dma(i);
+		dma_channels[i].name = NULL;
+		dma_channels[i].prio = min((i & 0x7) >> 1, DMA_PRIO_LOW);
+	}
+
+	ret = request_irq(IRQ_DMA, dma_irq_handler, 0, "DMA", NULL);
+	if (ret) {
+		printk(KERN_CRIT "Can't register IRQ for DMA\n");
+		return ret;
+	}
+
+	ret = request_irq(IRQ_DMAERR, dma_err_handler, 0, "DMAERR", NULL);
+	if (ret) {
+		printk(KERN_CRIT "Can't register IRQ for DMAERR\n");
+		free_irq(IRQ_DMA, "DMA");
+		return ret;
+	}
+
+	return 0;
+}
+
+postcore_initcall(puv3_init_dma);
diff --git a/arch/unicore32/mm/cache-ucv2.S b/arch/unicore32/mm/cache-ucv2.S
new file mode 100644
index 0000000..ecaa172
--- /dev/null
+++ b/arch/unicore32/mm/cache-ucv2.S
@@ -0,0 +1,212 @@
+/*
+ * linux/arch/unicore32/mm/cache-ucv2.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ *  This is the "shell" of the UniCore-v2 processor support.
+ */
+#include <linux/linkage.h>
+#include <linux/init.h>
+#include <asm/assembler.h>
+#include <asm/page.h>
+
+#include "proc-macros.S"
+
+/*
+ *	__cpuc_flush_icache_all()
+ *	__cpuc_flush_kern_all()
+ *	__cpuc_flush_user_all()
+ *
+ *	Flush the entire cache.
+ */
+ENTRY(__cpuc_flush_icache_all)
+	/*FALLTHROUGH*/
+ENTRY(__cpuc_flush_kern_all)
+	/*FALLTHROUGH*/
+ENTRY(__cpuc_flush_user_all)
+	mov	r0, #0
+	movc	p0.c5, r0, #14			@ Dcache flush all
+	nop8
+
+	mov	r0, #0
+	movc	p0.c5, r0, #20			@ Icache invalidate all
+	nop8
+
+	mov	pc, lr
+
+/*
+ *	__cpuc_flush_user_range(start, end, flags)
+ *
+ *	Flush a range of TLB entries in the specified address space.
+ *
+ *	- start - start address (may not be aligned)
+ *	- end   - end address (exclusive, may not be aligned)
+ *	- flags	- vm_area_struct flags describing address space
+ */
+ENTRY(__cpuc_flush_user_range)
+	cxor.a	r2, #0
+	beq	__cpuc_dma_flush_range
+
+#ifndef CONFIG_CPU_DCACHE_LINE_DISABLE
+	andn	r0, r0, #CACHE_LINESIZE - 1	@ Safety check
+	sub	r1, r1, r0
+	csub.a	r1, #MAX_AREA_SIZE
+	bsg	2f
+
+	andn	r1, r1, #CACHE_LINESIZE - 1
+	add	r1, r1, #CACHE_LINESIZE
+
+101:	dcacheline_flush	r0, r11, r12
+
+	add	r0, r0, #CACHE_LINESIZE
+	sub.a	r1, r1, #CACHE_LINESIZE
+	bns	101b
+	b	3f
+#endif
+2:	mov	ip, #0
+	movc	p0.c5, ip, #14			@ Dcache flush all
+	nop8
+
+3:	mov	ip, #0
+	movc	p0.c5, ip, #20			@ Icache invalidate all
+	nop8
+
+	mov	pc, lr
+
+/*
+ *	__cpuc_coherent_kern_range(start,end)
+ *	__cpuc_coherent_user_range(start,end)
+ *
+ *	Ensure that the I and D caches are coherent within specified
+ *	region.  This is typically used when code has been written to
+ *	a memory region, and will be executed.
+ *
+ *	- start   - virtual start address of region
+ *	- end     - virtual end address of region
+ */
+ENTRY(__cpuc_coherent_kern_range)
+	/* FALLTHROUGH */
+ENTRY(__cpuc_coherent_user_range)
+#ifndef CONFIG_CPU_DCACHE_LINE_DISABLE
+	andn	r0, r0, #CACHE_LINESIZE - 1	@ Safety check
+	sub	r1, r1, r0
+	csub.a	r1, #MAX_AREA_SIZE
+	bsg	2f
+
+	andn	r1, r1, #CACHE_LINESIZE - 1
+	add	r1, r1, #CACHE_LINESIZE
+
+	@ r0 va2pa r10
+	mov	r9, #PAGE_SZ
+	sub	r9, r9, #1			@ PAGE_MASK
+101:	va2pa	r0, r10, r11, r12, r13, 2f	@ r10 is PA
+	b	103f
+102:	cand.a	r0, r9
+	beq	101b
+
+103:	movc	p0.c5, r10, #11			@ Dcache clean line of R10
+	nop8
+
+	add	r0, r0, #CACHE_LINESIZE
+	add	r10, r10, #CACHE_LINESIZE
+	sub.a	r1, r1, #CACHE_LINESIZE
+	bns	102b
+	b	3f
+#endif
+2:	mov	ip, #0
+	movc	p0.c5, ip, #10			@ Dcache clean all
+	nop8
+
+3:	mov	ip, #0
+	movc	p0.c5, ip, #20			@ Icache invalidate all
+	nop8
+
+	mov	pc, lr
+
+/*
+ *	__cpuc_flush_kern_dcache_area(void *addr, size_t size)
+ *
+ *	- addr	- kernel address
+ *	- size	- region size
+ */
+ENTRY(__cpuc_flush_kern_dcache_area)
+	mov	ip, #0
+	movc	p0.c5, ip, #14			@ Dcache flush all
+	nop8
+	mov	pc, lr
+
+/*
+ *	__cpuc_dma_clean_range(start,end)
+ *	- start   - virtual start address of region
+ *	- end     - virtual end address of region
+ */
+ENTRY(__cpuc_dma_clean_range)
+#ifndef CONFIG_CPU_DCACHE_LINE_DISABLE
+	andn	r0, r0, #CACHE_LINESIZE - 1
+	sub	r1, r1, r0
+	andn	r1, r1, #CACHE_LINESIZE - 1
+	add	r1, r1, #CACHE_LINESIZE
+
+	csub.a	r1, #MAX_AREA_SIZE
+	bsg	2f
+
+	@ r0 va2pa r10
+	mov	r9, #PAGE_SZ
+	sub	r9, r9, #1			@ PAGE_MASK
+101:	va2pa	r0, r10, r11, r12, r13, 2f	@ r10 is PA
+	b	1f
+102:	cand.a	r0, r9
+	beq	101b
+
+1:	movc	p0.c5, r10, #11			@ Dcache clean line of R10
+	nop8
+	add	r0, r0, #CACHE_LINESIZE
+	add	r10, r10, #CACHE_LINESIZE
+	sub.a	r1, r1, #CACHE_LINESIZE
+	bns	102b
+	mov	pc, lr
+#endif
+2:	mov	ip, #0
+	movc	p0.c5, ip, #10			@ Dcache clean all
+	nop8
+
+	mov	pc, lr
+
+/*
+ *	__cpuc_dma_inv_range(start,end)
+ *	__cpuc_dma_flush_range(start,end)
+ *	- start   - virtual start address of region
+ *	- end     - virtual end address of region
+ */
+__cpuc_dma_inv_range:
+	/* FALLTHROUGH */
+ENTRY(__cpuc_dma_flush_range)
+#ifndef CONFIG_CPU_DCACHE_LINE_DISABLE
+	andn	r0, r0, #CACHE_LINESIZE - 1
+	sub	r1, r1, r0
+	andn	r1, r1, #CACHE_LINESIZE - 1
+	add	r1, r1, #CACHE_LINESIZE
+
+	csub.a	r1, #MAX_AREA_SIZE
+	bsg	2f
+
+	@ r0 va2pa r10
+101:	dcacheline_flush	r0, r11, r12
+
+	add	r0, r0, #CACHE_LINESIZE
+	sub.a	r1, r1, #CACHE_LINESIZE
+	bns	101b
+	mov	pc, lr
+#endif
+2:	mov	ip, #0
+	movc	p0.c5, ip, #14			@ Dcache flush all
+	nop8
+
+	mov	pc, lr
+
diff --git a/arch/unicore32/mm/dma-swiotlb.c b/arch/unicore32/mm/dma-swiotlb.c
new file mode 100644
index 0000000..bfa9fbb
--- /dev/null
+++ b/arch/unicore32/mm/dma-swiotlb.c
@@ -0,0 +1,34 @@
+/*
+ * Contains routines needed to support swiotlb for UniCore32.
+ *
+ * Copyright (C) 2010 Guan Xuetao
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+#include <linux/pci.h>
+#include <linux/cache.h>
+#include <linux/module.h>
+#include <linux/dma-mapping.h>
+#include <linux/swiotlb.h>
+#include <linux/bootmem.h>
+
+#include <asm/dma.h>
+
+struct dma_map_ops swiotlb_dma_map_ops = {
+	.alloc_coherent = swiotlb_alloc_coherent,
+	.free_coherent = swiotlb_free_coherent,
+	.map_sg = swiotlb_map_sg_attrs,
+	.unmap_sg = swiotlb_unmap_sg_attrs,
+	.dma_supported = swiotlb_dma_supported,
+	.map_page = swiotlb_map_page,
+	.unmap_page = swiotlb_unmap_page,
+	.sync_single_for_cpu = swiotlb_sync_single_for_cpu,
+	.sync_single_for_device = swiotlb_sync_single_for_device,
+	.sync_sg_for_cpu = swiotlb_sync_sg_for_cpu,
+	.sync_sg_for_device = swiotlb_sync_sg_for_device,
+	.mapping_error = swiotlb_dma_mapping_error,
+};
+EXPORT_SYMBOL(swiotlb_dma_map_ops);
diff --git a/arch/unicore32/mm/flush.c b/arch/unicore32/mm/flush.c
new file mode 100644
index 0000000..93478cc
--- /dev/null
+++ b/arch/unicore32/mm/flush.c
@@ -0,0 +1,98 @@
+/*
+ * linux/arch/unicore32/mm/flush.c
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
+#include <linux/mm.h>
+#include <linux/pagemap.h>
+
+#include <asm/cacheflush.h>
+#include <asm/system.h>
+#include <asm/tlbflush.h>
+
+void flush_cache_mm(struct mm_struct *mm)
+{
+}
+
+void flush_cache_range(struct vm_area_struct *vma, unsigned long start,
+		unsigned long end)
+{
+	if (vma->vm_flags & VM_EXEC)
+		__flush_icache_all();
+}
+
+void flush_cache_page(struct vm_area_struct *vma, unsigned long user_addr,
+		unsigned long pfn)
+{
+}
+
+static void flush_ptrace_access(struct vm_area_struct *vma, struct page *page,
+			 unsigned long uaddr, void *kaddr, unsigned long len)
+{
+	/* VIPT non-aliasing D-cache */
+	if (vma->vm_flags & VM_EXEC) {
+		unsigned long addr = (unsigned long)kaddr;
+
+		__cpuc_coherent_kern_range(addr, addr + len);
+	}
+}
+
+/*
+ * Copy user data from/to a page which is mapped into a different
+ * processes address space.  Really, we want to allow our "user
+ * space" model to handle this.
+ *
+ * Note that this code needs to run on the current CPU.
+ */
+void copy_to_user_page(struct vm_area_struct *vma, struct page *page,
+		       unsigned long uaddr, void *dst, const void *src,
+		       unsigned long len)
+{
+	memcpy(dst, src, len);
+	flush_ptrace_access(vma, page, uaddr, dst, len);
+}
+
+void __flush_dcache_page(struct address_space *mapping, struct page *page)
+{
+	/*
+	 * Writeback any data associated with the kernel mapping of this
+	 * page.  This ensures that data in the physical page is mutually
+	 * coherent with the kernels mapping.
+	 */
+	__cpuc_flush_kern_dcache_area(page_address(page), PAGE_SIZE);
+}
+
+/*
+ * Ensure cache coherency between kernel mapping and userspace mapping
+ * of this page.
+ */
+void flush_dcache_page(struct page *page)
+{
+	struct address_space *mapping;
+
+	/*
+	 * The zero page is never written to, so never has any dirty
+	 * cache lines, and therefore never needs to be flushed.
+	 */
+	if (page == ZERO_PAGE(0))
+		return;
+
+	mapping = page_mapping(page);
+
+	if (mapping && !mapping_mapped(mapping))
+		clear_bit(PG_dcache_clean, &page->flags);
+	else {
+		__flush_dcache_page(mapping, page);
+		if (mapping)
+			__flush_icache_all();
+		set_bit(PG_dcache_clean, &page->flags);
+	}
+}
+EXPORT_SYMBOL(flush_dcache_page);
diff --git a/arch/unicore32/mm/tlb-ucv2.S b/arch/unicore32/mm/tlb-ucv2.S
new file mode 100644
index 0000000..061d455
--- /dev/null
+++ b/arch/unicore32/mm/tlb-ucv2.S
@@ -0,0 +1,89 @@
+/*
+ * linux/arch/unicore32/mm/tlb-ucv2.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/init.h>
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+#include <asm/page.h>
+#include <asm/tlbflush.h>
+#include "proc-macros.S"
+
+/*
+ *	__cpu_flush_user_tlb_range(start, end, vma)
+ *
+ *	Invalidate a range of TLB entries in the specified address space.
+ *
+ *	- start - start address (may not be aligned)
+ *	- end   - end address (exclusive, may not be aligned)
+ *	- vma   - vma_struct describing address range
+ */
+ENTRY(__cpu_flush_user_tlb_range)
+#ifndef	CONFIG_CPU_TLB_SINGLE_ENTRY_DISABLE
+	mov	r0, r0 >> #PAGE_SHIFT		@ align address
+	mov	r0, r0 << #PAGE_SHIFT
+	vma_vm_flags r2, r2			@ get vma->vm_flags
+1:
+	movc	p0.c6, r0, #3
+	nop8
+
+	cand.a	r2, #VM_EXEC			@ Executable area ?
+	beq	2f
+
+	movc	p0.c6, r0, #5
+	nop8
+2:
+	add	r0, r0, #PAGE_SZ
+	csub.a	r0, r1
+	beb	1b
+#else
+	movc	p0.c6, r0, #2
+	nop8
+
+	cand.a	r2, #VM_EXEC			@ Executable area ?
+	beq	2f
+
+	movc	p0.c6, r0, #4
+	nop8
+2:
+#endif
+	mov	pc, lr
+
+/*
+ *	__cpu_flush_kern_tlb_range(start,end)
+ *
+ *	Invalidate a range of kernel TLB entries
+ *
+ *	- start - start address (may not be aligned)
+ *	- end   - end address (exclusive, may not be aligned)
+ */
+ENTRY(__cpu_flush_kern_tlb_range)
+#ifndef	CONFIG_CPU_TLB_SINGLE_ENTRY_DISABLE
+	mov	r0, r0 >> #PAGE_SHIFT		@ align address
+	mov	r0, r0 << #PAGE_SHIFT
+1:
+	movc	p0.c6, r0, #3
+	nop8
+
+	movc	p0.c6, r0, #5
+	nop8
+
+	add	r0, r0, #PAGE_SZ
+	csub.a	r0, r1
+	beb	1b
+#else
+	movc	p0.c6, r0, #2
+	nop8
+
+	movc	p0.c6, r0, #4
+	nop8
+#endif
+	mov	pc, lr
+
-- 
1.7.0.4


