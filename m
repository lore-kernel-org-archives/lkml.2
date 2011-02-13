Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab1BMGgC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 01:36:02 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:56109 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab1BMGfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 01:35:55 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "'Greg KH'" <greg@kroah.com>
Subject: [PATCHv2 06/11] unicore32 core architecture: mm related: generic codes
Date: Sun, 13 Feb 2011 14:35:45 +0800
Message-ID: <02ed01cbcb48$3e3781a0$baa684e0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcvLSDRND8sO2LhwThSv/6XX2+WATw==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes generic codes for memory management.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/cache.h    |   27 ++
 arch/unicore32/include/asm/memblock.h |   46 +++
 arch/unicore32/include/asm/memory.h   |  123 ++++++++
 arch/unicore32/include/asm/page.h     |   80 +++++
 arch/unicore32/include/asm/tlb.h      |   98 +++++++
 arch/unicore32/include/mach/map.h     |   20 ++
 arch/unicore32/include/mach/memory.h  |   58 ++++
 arch/unicore32/mm/Kconfig             |   50 ++++
 arch/unicore32/mm/Makefile            |   15 +
 arch/unicore32/mm/init.c              |  517 +++++++++++++++++++++++++++++++++
 arch/unicore32/mm/iomap.c             |   56 ++++
 arch/unicore32/mm/ioremap.c           |  261 +++++++++++++++++
 arch/unicore32/mm/mm.h                |   39 +++
 13 files changed, 1390 insertions(+), 0 deletions(-)
 create mode 100644 arch/unicore32/include/asm/cache.h
 create mode 100644 arch/unicore32/include/asm/memblock.h
 create mode 100644 arch/unicore32/include/asm/memory.h
 create mode 100644 arch/unicore32/include/asm/page.h
 create mode 100644 arch/unicore32/include/asm/tlb.h
 create mode 100644 arch/unicore32/include/mach/map.h
 create mode 100644 arch/unicore32/include/mach/memory.h
 create mode 100644 arch/unicore32/mm/Kconfig
 create mode 100644 arch/unicore32/mm/Makefile
 create mode 100644 arch/unicore32/mm/init.c
 create mode 100644 arch/unicore32/mm/iomap.c
 create mode 100644 arch/unicore32/mm/ioremap.c
 create mode 100644 arch/unicore32/mm/mm.h

diff --git a/arch/unicore32/include/asm/cache.h b/arch/unicore32/include/asm/cache.h
new file mode 100644
index 0000000..ad8f795
--- /dev/null
+++ b/arch/unicore32/include/asm/cache.h
@@ -0,0 +1,27 @@
+/*
+ * linux/arch/unicore32/include/asm/cache.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_CACHE_H__
+#define __UNICORE_CACHE_H__
+
+#define L1_CACHE_SHIFT		(5)
+#define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
+
+/*
+ * Memory returned by kmalloc() may be used for DMA, so we must make
+ * sure that all such allocations are cache aligned. Otherwise,
+ * unrelated code may cause parts of the buffer to be read into the
+ * cache before the transfer is done, causing old data to be seen by
+ * the CPU.
+ */
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
+
+#endif
diff --git a/arch/unicore32/include/asm/memblock.h b/arch/unicore32/include/asm/memblock.h
new file mode 100644
index 0000000..a8a5d8d
--- /dev/null
+++ b/arch/unicore32/include/asm/memblock.h
@@ -0,0 +1,46 @@
+/*
+ * linux/arch/unicore32/include/asm/memblock.h
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
+#ifndef __UNICORE_MEMBLOCK_H__
+#define __UNICORE_MEMBLOCK_H__
+
+/*
+ * Memory map description
+ */
+# define NR_BANKS 8
+
+struct membank {
+	unsigned long start;
+	unsigned long size;
+	unsigned int highmem;
+};
+
+struct meminfo {
+	int nr_banks;
+	struct membank bank[NR_BANKS];
+};
+
+extern struct meminfo meminfo;
+
+#define for_each_bank(iter, mi)				\
+	for (iter = 0; iter < (mi)->nr_banks; iter++)
+
+#define bank_pfn_start(bank)	__phys_to_pfn((bank)->start)
+#define bank_pfn_end(bank)	__phys_to_pfn((bank)->start + (bank)->size)
+#define bank_pfn_size(bank)	((bank)->size >> PAGE_SHIFT)
+#define bank_phys_start(bank)	((bank)->start)
+#define bank_phys_end(bank)	((bank)->start + (bank)->size)
+#define bank_phys_size(bank)	((bank)->size)
+
+extern void uc32_memblock_init(struct meminfo *);
+
+#endif
diff --git a/arch/unicore32/include/asm/memory.h b/arch/unicore32/include/asm/memory.h
new file mode 100644
index 0000000..5eddb99
--- /dev/null
+++ b/arch/unicore32/include/asm/memory.h
@@ -0,0 +1,123 @@
+/*
+ * linux/arch/unicore32/include/asm/memory.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ *  Note: this file should not be included by non-asm/.h files
+ */
+#ifndef __UNICORE_MEMORY_H__
+#define __UNICORE_MEMORY_H__
+
+#include <linux/compiler.h>
+#include <linux/const.h>
+#include <asm/sizes.h>
+#include <mach/memory.h>
+
+/*
+ * Allow for constants defined here to be used from assembly code
+ * by prepending the UL suffix only with actual C code compilation.
+ */
+#define UL(x) _AC(x, UL)
+
+/*
+ * PAGE_OFFSET - the virtual address of the start of the kernel image
+ * TASK_SIZE - the maximum size of a user space task.
+ * TASK_UNMAPPED_BASE - the lower boundary of the mmap VM area
+ */
+#define PAGE_OFFSET		UL(0xC0000000)
+#define TASK_SIZE		(PAGE_OFFSET - UL(0x41000000))
+#define TASK_UNMAPPED_BASE	(PAGE_OFFSET / 3)
+
+/*
+ * The module space lives between the addresses given by TASK_SIZE
+ * and PAGE_OFFSET - it must be within 32MB of the kernel text.
+ */
+#define MODULES_VADDR		(PAGE_OFFSET - 16*1024*1024)
+#if TASK_SIZE > MODULES_VADDR
+#error Top of user space clashes with start of module space
+#endif
+
+#define MODULES_END		(PAGE_OFFSET)
+
+/*
+ * Allow 16MB-aligned ioremap pages
+ */
+#define IOREMAP_MAX_ORDER	24
+
+/*
+ * Physical vs virtual RAM address space conversion.  These are
+ * private definitions which should NOT be used outside memory.h
+ * files.  Use virt_to_phys/phys_to_virt/__pa/__va instead.
+ */
+#ifndef __virt_to_phys
+#define __virt_to_phys(x)	((x) - PAGE_OFFSET + PHYS_OFFSET)
+#define __phys_to_virt(x)	((x) - PHYS_OFFSET + PAGE_OFFSET)
+#endif
+
+/*
+ * Convert a physical address to a Page Frame Number and back
+ */
+#define	__phys_to_pfn(paddr)	((paddr) >> PAGE_SHIFT)
+#define	__pfn_to_phys(pfn)	((pfn) << PAGE_SHIFT)
+
+/*
+ * Convert a page to/from a physical address
+ */
+#define page_to_phys(page)	(__pfn_to_phys(page_to_pfn(page)))
+#define phys_to_page(phys)	(pfn_to_page(__phys_to_pfn(phys)))
+
+#ifndef __ASSEMBLY__
+
+#ifndef arch_adjust_zones
+#define arch_adjust_zones(size, holes) do { } while (0)
+#endif
+
+/*
+ * PFNs are used to describe any physical page; this means
+ * PFN 0 == physical address 0.
+ *
+ * This is the PFN of the first RAM page in the kernel
+ * direct-mapped view.  We assume this is the first page
+ * of RAM in the mem_map as well.
+ */
+#define PHYS_PFN_OFFSET	(PHYS_OFFSET >> PAGE_SHIFT)
+
+/*
+ * Drivers should NOT use these either.
+ */
+#define __pa(x)			__virt_to_phys((unsigned long)(x))
+#define __va(x)			((void *)__phys_to_virt((unsigned long)(x)))
+#define pfn_to_kaddr(pfn)	__va((pfn) << PAGE_SHIFT)
+
+/*
+ * Conversion between a struct page and a physical address.
+ *
+ * Note: when converting an unknown physical address to a
+ * struct page, the resulting pointer must be validated
+ * using VALID_PAGE().  It must return an invalid struct page
+ * for any physical address not corresponding to a system
+ * RAM address.
+ *
+ *  page_to_pfn(page)	convert a struct page * to a PFN number
+ *  pfn_to_page(pfn)	convert a _valid_ PFN number to struct page *
+ *
+ *  virt_to_page(k)	convert a _valid_ virtual address to struct page *
+ *  virt_addr_valid(k)	indicates whether a virtual address is valid
+ */
+#define ARCH_PFN_OFFSET		PHYS_PFN_OFFSET
+
+#define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
+#define virt_addr_valid(kaddr)	((unsigned long)(kaddr) >= PAGE_OFFSET && \
+		(unsigned long)(kaddr) < (unsigned long)high_memory)
+
+#endif
+
+#include <asm-generic/memory_model.h>
+
+#endif
diff --git a/arch/unicore32/include/asm/page.h b/arch/unicore32/include/asm/page.h
new file mode 100644
index 0000000..594b322
--- /dev/null
+++ b/arch/unicore32/include/asm/page.h
@@ -0,0 +1,80 @@
+/*
+ * linux/arch/unicore32/include/asm/page.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_PAGE_H__
+#define __UNICORE_PAGE_H__
+
+/* PAGE_SHIFT determines the page size */
+#define PAGE_SHIFT		12
+#define PAGE_SIZE		(_AC(1, UL) << PAGE_SHIFT)
+#define PAGE_MASK		(~(PAGE_SIZE-1))
+
+#ifndef __ASSEMBLY__
+
+struct page;
+struct vm_area_struct;
+
+#define clear_page(page)	memset((void *)(page), 0, PAGE_SIZE)
+extern void copy_page(void *to, const void *from);
+
+#define clear_user_page(page, vaddr, pg)	clear_page(page)
+#define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
+
+#undef STRICT_MM_TYPECHECKS
+
+#ifdef STRICT_MM_TYPECHECKS
+/*
+ * These are used to make use of C type-checking..
+ */
+typedef struct { unsigned long pte; } pte_t;
+typedef struct { unsigned long pgd; } pgd_t;
+typedef struct { unsigned long pgprot; } pgprot_t;
+
+#define pte_val(x)      ((x).pte)
+#define pgd_val(x)	((x).pgd)
+#define pgprot_val(x)   ((x).pgprot)
+
+#define __pte(x)        ((pte_t) { (x) })
+#define __pgd(x)	((pgd_t) { (x) })
+#define __pgprot(x)     ((pgprot_t) { (x) })
+
+#else
+/*
+ * .. while these make it easier on the compiler
+ */
+typedef unsigned long pte_t;
+typedef unsigned long pgd_t;
+typedef unsigned long pgprot_t;
+
+#define pte_val(x)      (x)
+#define pgd_val(x)      (x)
+#define pgprot_val(x)   (x)
+
+#define __pte(x)        (x)
+#define __pgd(x)	(x)
+#define __pgprot(x)     (x)
+
+#endif /* STRICT_MM_TYPECHECKS */
+
+typedef struct page *pgtable_t;
+
+extern int pfn_valid(unsigned long);
+
+#include <asm/memory.h>
+
+#endif /* !__ASSEMBLY__ */
+
+#define VM_DATA_DEFAULT_FLAGS \
+	(VM_READ | VM_WRITE | VM_EXEC | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+
+#include <asm-generic/getorder.h>
+
+#endif
diff --git a/arch/unicore32/include/asm/tlb.h b/arch/unicore32/include/asm/tlb.h
new file mode 100644
index 0000000..02ee40e
--- /dev/null
+++ b/arch/unicore32/include/asm/tlb.h
@@ -0,0 +1,98 @@
+/*
+ * linux/arch/unicore32/include/asm/tlb.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_TLB_H__
+#define __UNICORE_TLB_H__
+
+#include <asm/cacheflush.h>
+#include <asm/tlbflush.h>
+#include <asm/pgalloc.h>
+
+/*
+ * TLB handling.  This allows us to remove pages from the page
+ * tables, and efficiently handle the TLB issues.
+ */
+struct mmu_gather {
+	struct mm_struct	*mm;
+	unsigned int		fullmm;
+	unsigned long		range_start;
+	unsigned long		range_end;
+};
+
+DECLARE_PER_CPU(struct mmu_gather, mmu_gathers);
+
+static inline struct mmu_gather *
+tlb_gather_mmu(struct mm_struct *mm, unsigned int full_mm_flush)
+{
+	struct mmu_gather *tlb = &get_cpu_var(mmu_gathers);
+
+	tlb->mm = mm;
+	tlb->fullmm = full_mm_flush;
+
+	return tlb;
+}
+
+static inline void
+tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
+{
+	if (tlb->fullmm)
+		flush_tlb_mm(tlb->mm);
+
+	/* keep the page table cache within bounds */
+	check_pgt_cache();
+
+	put_cpu_var(mmu_gathers);
+}
+
+/*
+ * Memorize the range for the TLB flush.
+ */
+static inline void
+tlb_remove_tlb_entry(struct mmu_gather *tlb, pte_t *ptep, unsigned long addr)
+{
+	if (!tlb->fullmm) {
+		if (addr < tlb->range_start)
+			tlb->range_start = addr;
+		if (addr + PAGE_SIZE > tlb->range_end)
+			tlb->range_end = addr + PAGE_SIZE;
+	}
+}
+
+/*
+ * In the case of tlb vma handling, we can optimise these away in the
+ * case where we're doing a full MM flush.  When we're doing a munmap,
+ * the vmas are adjusted to only cover the region to be torn down.
+ */
+static inline void
+tlb_start_vma(struct mmu_gather *tlb, struct vm_area_struct *vma)
+{
+	if (!tlb->fullmm) {
+		flush_cache_range(vma, vma->vm_start, vma->vm_end);
+		tlb->range_start = TASK_SIZE;
+		tlb->range_end = 0;
+	}
+}
+
+static inline void
+tlb_end_vma(struct mmu_gather *tlb, struct vm_area_struct *vma)
+{
+	if (!tlb->fullmm && tlb->range_end > 0)
+		flush_tlb_range(vma, tlb->range_start, tlb->range_end);
+}
+
+#define tlb_remove_page(tlb, page)	free_page_and_swap_cache(page)
+#define pte_free_tlb(tlb, ptep, addr)	pte_free((tlb)->mm, ptep)
+#define pmd_free_tlb(tlb, pmdp, addr)	pmd_free((tlb)->mm, pmdp)
+#define pud_free_tlb(tlb, x, addr)      do { } while (0)
+
+#define tlb_migrate_finish(mm)		do { } while (0)
+
+#endif
diff --git a/arch/unicore32/include/mach/map.h b/arch/unicore32/include/mach/map.h
new file mode 100644
index 0000000..55c9365
--- /dev/null
+++ b/arch/unicore32/include/mach/map.h
@@ -0,0 +1,20 @@
+/*
+ * linux/arch/unicore32/include/mach/map.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ *  Page table mapping constructs and function prototypes
+ */
+#define MT_DEVICE		0
+#define MT_DEVICE_CACHED	2
+#define MT_KUSER		7
+#define MT_HIGH_VECTORS		8
+#define MT_MEMORY		9
+#define MT_ROM			10
+
diff --git a/arch/unicore32/include/mach/memory.h b/arch/unicore32/include/mach/memory.h
new file mode 100644
index 0000000..541949d
--- /dev/null
+++ b/arch/unicore32/include/mach/memory.h
@@ -0,0 +1,58 @@
+/*
+ * linux/arch/unicore32/include/mach/memory.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __MACH_PUV3_MEMORY_H__
+#define __MACH_PUV3_MEMORY_H__
+
+#include <mach/hardware.h>
+
+/* Physical DRAM offset. */
+#define PHYS_OFFSET	UL(0x00000000)
+/* The base address of exception vectors. */
+#define VECTORS_BASE	UL(0xffff0000)
+/* The base address of kuser area. */
+#define KUSER_BASE	UL(0x80000000)
+
+#ifdef __ASSEMBLY__
+/* The byte offset of the kernel image in RAM from the start of RAM. */
+#define KERNEL_IMAGE_START	0x00408000
+#endif
+
+#if !defined(__ASSEMBLY__) && defined(CONFIG_PCI)
+
+void puv3_pci_adjust_zones(unsigned long *size, unsigned long *holes);
+
+#define arch_adjust_zones(size, holes) \
+	puv3_pci_adjust_zones(size, holes)
+
+#endif
+
+/*
+ * PCI controller in PKUnity-3 masks highest 5-bit for upstream channel,
+ * so we must limit the DMA allocation within 128M physical memory for
+ * supporting PCI devices.
+ */
+#define PCI_DMA_THRESHOLD	(PHYS_OFFSET + SZ_128M - 1)
+
+#define is_pcibus_device(dev)	(dev &&			\
+				(strncmp(dev->bus->name, "pci", 3) == 0))
+
+#define __virt_to_pcibus(x)     (__virt_to_phys(x) + PKUNITY_PCIAHB_BASE)
+#define __pcibus_to_virt(x)     __phys_to_virt((x) - PKUNITY_PCIAHB_BASE)
+
+/* kuser area */
+#define KUSER_VECPAGE_BASE	(KUSER_BASE + UL(0x3fff0000))
+#define KUSER_UNIGFX_BASE	(KUSER_BASE + PKUNITY_UNIGFX_MMAP_BASE)
+/* kuser_vecpage (0xbfff0000) is ro, and vectors page (0xffff0000) is rw */
+#define kuser_vecpage_to_vectors(x)	((x) - (KUSER_VECPAGE_BASE)	\
+					+ (VECTORS_BASE))
+
+#endif
diff --git a/arch/unicore32/mm/Kconfig b/arch/unicore32/mm/Kconfig
new file mode 100644
index 0000000..5f77fb3
--- /dev/null
+++ b/arch/unicore32/mm/Kconfig
@@ -0,0 +1,50 @@
+comment "Processor Type"
+
+# Select CPU types depending on the architecture selected.  This selects
+# which CPUs we support in the kernel image, and the compiler instruction
+# optimiser behaviour.
+
+config CPU_UCV2
+	def_bool y
+
+comment "Processor Features"
+
+config CPU_ICACHE_DISABLE
+	bool "Disable I-Cache (I-bit)"
+	help
+	  Say Y here to disable the processor instruction cache. Unless
+	  you have a reason not to or are unsure, say N.
+
+config CPU_DCACHE_DISABLE
+	bool "Disable D-Cache (D-bit)"
+	help
+	  Say Y here to disable the processor data cache. Unless
+	  you have a reason not to or are unsure, say N.
+
+config CPU_DCACHE_WRITETHROUGH
+	bool "Force write through D-cache"
+	help
+	  Say Y here to use the data cache in writethrough mode. Unless you
+	  specifically require this or are unsure, say N.
+
+config CPU_DCACHE_LINE_DISABLE
+	bool "Disable D-cache line ops"
+	default y
+	help
+	  Say Y here to disable the data cache line operations.
+
+config CPU_TLB_SINGLE_ENTRY_DISABLE
+	bool "Disable TLB single entry ops"
+	default y
+	help
+	  Say Y here to disable the TLB single entry operations.
+
+config SWIOTLB
+	def_bool y
+
+config IOMMU_HELPER
+	def_bool SWIOTLB
+
+config NEED_SG_DMA_LENGTH
+	def_bool SWIOTLB
+
diff --git a/arch/unicore32/mm/Makefile b/arch/unicore32/mm/Makefile
new file mode 100644
index 0000000..f3ff410
--- /dev/null
+++ b/arch/unicore32/mm/Makefile
@@ -0,0 +1,15 @@
+#
+# Makefile for the linux unicore-specific parts of the memory manager.
+#
+
+obj-y				:= extable.o fault.o init.o pgd.o mmu.o
+obj-y				+= iomap.o flush.o ioremap.o
+
+obj-$(CONFIG_SWIOTLB)		+= dma-swiotlb.o
+
+obj-$(CONFIG_MODULES)		+= proc-syms.o
+
+obj-$(CONFIG_ALIGNMENT_TRAP)	+= alignment.o
+
+obj-$(CONFIG_CPU_UCV2)		+= cache-ucv2.o tlb-ucv2.o proc-ucv2.o
+
diff --git a/arch/unicore32/mm/init.c b/arch/unicore32/mm/init.c
new file mode 100644
index 0000000..3dbe370
--- /dev/null
+++ b/arch/unicore32/mm/init.c
@@ -0,0 +1,517 @@
+/*
+ *  linux/arch/unicore32/mm/init.c
+ *
+ *  Copyright (C) 2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/swap.h>
+#include <linux/init.h>
+#include <linux/bootmem.h>
+#include <linux/mman.h>
+#include <linux/nodemask.h>
+#include <linux/initrd.h>
+#include <linux/highmem.h>
+#include <linux/gfp.h>
+#include <linux/memblock.h>
+#include <linux/sort.h>
+#include <linux/dma-mapping.h>
+
+#include <asm/sections.h>
+#include <asm/setup.h>
+#include <asm/sizes.h>
+#include <asm/tlb.h>
+#include <mach/map.h>
+
+#include "mm.h"
+
+static unsigned long phys_initrd_start __initdata = 0x01000000;
+static unsigned long phys_initrd_size __initdata = SZ_8M;
+
+static int __init early_initrd(char *p)
+{
+	unsigned long start, size;
+	char *endp;
+
+	start = memparse(p, &endp);
+	if (*endp == ',') {
+		size = memparse(endp + 1, NULL);
+
+		phys_initrd_start = start;
+		phys_initrd_size = size;
+	}
+	return 0;
+}
+early_param("initrd", early_initrd);
+
+/*
+ * This keeps memory configuration data used by a couple memory
+ * initialization functions, as well as show_mem() for the skipping
+ * of holes in the memory map.  It is populated by uc32_add_memory().
+ */
+struct meminfo meminfo;
+
+void show_mem(void)
+{
+	int free = 0, total = 0, reserved = 0;
+	int shared = 0, cached = 0, slab = 0, i;
+	struct meminfo *mi = &meminfo;
+
+	printk(KERN_DEFAULT "Mem-info:\n");
+	show_free_areas();
+
+	for_each_bank(i, mi) {
+		struct membank *bank = &mi->bank[i];
+		unsigned int pfn1, pfn2;
+		struct page *page, *end;
+
+		pfn1 = bank_pfn_start(bank);
+		pfn2 = bank_pfn_end(bank);
+
+		page = pfn_to_page(pfn1);
+		end  = pfn_to_page(pfn2 - 1) + 1;
+
+		do {
+			total++;
+			if (PageReserved(page))
+				reserved++;
+			else if (PageSwapCache(page))
+				cached++;
+			else if (PageSlab(page))
+				slab++;
+			else if (!page_count(page))
+				free++;
+			else
+				shared += page_count(page) - 1;
+			page++;
+		} while (page < end);
+	}
+
+	printk(KERN_DEFAULT "%d pages of RAM\n", total);
+	printk(KERN_DEFAULT "%d free pages\n", free);
+	printk(KERN_DEFAULT "%d reserved pages\n", reserved);
+	printk(KERN_DEFAULT "%d slab pages\n", slab);
+	printk(KERN_DEFAULT "%d pages shared\n", shared);
+	printk(KERN_DEFAULT "%d pages swap cached\n", cached);
+}
+
+static void __init find_limits(unsigned long *min, unsigned long *max_low,
+	unsigned long *max_high)
+{
+	struct meminfo *mi = &meminfo;
+	int i;
+
+	*min = -1UL;
+	*max_low = *max_high = 0;
+
+	for_each_bank(i, mi) {
+		struct membank *bank = &mi->bank[i];
+		unsigned long start, end;
+
+		start = bank_pfn_start(bank);
+		end = bank_pfn_end(bank);
+
+		if (*min > start)
+			*min = start;
+		if (*max_high < end)
+			*max_high = end;
+		if (bank->highmem)
+			continue;
+		if (*max_low < end)
+			*max_low = end;
+	}
+}
+
+static void __init uc32_bootmem_init(unsigned long start_pfn,
+	unsigned long end_pfn)
+{
+	struct memblock_region *reg;
+	unsigned int boot_pages;
+	phys_addr_t bitmap;
+	pg_data_t *pgdat;
+
+	/*
+	 * Allocate the bootmem bitmap page.  This must be in a region
+	 * of memory which has already been mapped.
+	 */
+	boot_pages = bootmem_bootmap_pages(end_pfn - start_pfn);
+	bitmap = memblock_alloc_base(boot_pages << PAGE_SHIFT, L1_CACHE_BYTES,
+				__pfn_to_phys(end_pfn));
+
+	/*
+	 * Initialise the bootmem allocator, handing the
+	 * memory banks over to bootmem.
+	 */
+	node_set_online(0);
+	pgdat = NODE_DATA(0);
+	init_bootmem_node(pgdat, __phys_to_pfn(bitmap), start_pfn, end_pfn);
+
+	/* Free the lowmem regions from memblock into bootmem. */
+	for_each_memblock(memory, reg) {
+		unsigned long start = memblock_region_memory_base_pfn(reg);
+		unsigned long end = memblock_region_memory_end_pfn(reg);
+
+		if (end >= end_pfn)
+			end = end_pfn;
+		if (start >= end)
+			break;
+
+		free_bootmem(__pfn_to_phys(start), (end - start) << PAGE_SHIFT);
+	}
+
+	/* Reserve the lowmem memblock reserved regions in bootmem. */
+	for_each_memblock(reserved, reg) {
+		unsigned long start = memblock_region_reserved_base_pfn(reg);
+		unsigned long end = memblock_region_reserved_end_pfn(reg);
+
+		if (end >= end_pfn)
+			end = end_pfn;
+		if (start >= end)
+			break;
+
+		reserve_bootmem(__pfn_to_phys(start),
+			(end - start) << PAGE_SHIFT, BOOTMEM_DEFAULT);
+	}
+}
+
+static void __init uc32_bootmem_free(unsigned long min, unsigned long max_low,
+	unsigned long max_high)
+{
+	unsigned long zone_size[MAX_NR_ZONES], zhole_size[MAX_NR_ZONES];
+	struct memblock_region *reg;
+
+	/*
+	 * initialise the zones.
+	 */
+	memset(zone_size, 0, sizeof(zone_size));
+
+	/*
+	 * The memory size has already been determined.  If we need
+	 * to do anything fancy with the allocation of this memory
+	 * to the zones, now is the time to do it.
+	 */
+	zone_size[0] = max_low - min;
+
+	/*
+	 * Calculate the size of the holes.
+	 *  holes = node_size - sum(bank_sizes)
+	 */
+	memcpy(zhole_size, zone_size, sizeof(zhole_size));
+	for_each_memblock(memory, reg) {
+		unsigned long start = memblock_region_memory_base_pfn(reg);
+		unsigned long end = memblock_region_memory_end_pfn(reg);
+
+		if (start < max_low) {
+			unsigned long low_end = min(end, max_low);
+			zhole_size[0] -= low_end - start;
+		}
+	}
+
+	/*
+	 * Adjust the sizes according to any special requirements for
+	 * this machine type.
+	 */
+	arch_adjust_zones(zone_size, zhole_size);
+
+	free_area_init_node(0, zone_size, min, zhole_size);
+}
+
+int pfn_valid(unsigned long pfn)
+{
+	return memblock_is_memory(pfn << PAGE_SHIFT);
+}
+EXPORT_SYMBOL(pfn_valid);
+
+static void uc32_memory_present(void)
+{
+}
+
+static int __init meminfo_cmp(const void *_a, const void *_b)
+{
+	const struct membank *a = _a, *b = _b;
+	long cmp = bank_pfn_start(a) - bank_pfn_start(b);
+	return cmp < 0 ? -1 : cmp > 0 ? 1 : 0;
+}
+
+void __init uc32_memblock_init(struct meminfo *mi)
+{
+	int i;
+
+	sort(&meminfo.bank, meminfo.nr_banks, sizeof(meminfo.bank[0]),
+		meminfo_cmp, NULL);
+
+	memblock_init();
+	for (i = 0; i < mi->nr_banks; i++)
+		memblock_add(mi->bank[i].start, mi->bank[i].size);
+
+	/* Register the kernel text, kernel data and initrd with memblock. */
+	memblock_reserve(__pa(_text), _end - _text);
+
+#ifdef CONFIG_BLK_DEV_INITRD
+	if (phys_initrd_size) {
+		memblock_reserve(phys_initrd_start, phys_initrd_size);
+
+		/* Now convert initrd to virtual addresses */
+		initrd_start = __phys_to_virt(phys_initrd_start);
+		initrd_end = initrd_start + phys_initrd_size;
+	}
+#endif
+
+	uc32_mm_memblock_reserve();
+
+	memblock_analyze();
+	memblock_dump_all();
+}
+
+void __init bootmem_init(void)
+{
+	unsigned long min, max_low, max_high;
+
+	max_low = max_high = 0;
+
+	find_limits(&min, &max_low, &max_high);
+
+	uc32_bootmem_init(min, max_low);
+
+#ifdef CONFIG_SWIOTLB
+	swiotlb_init(1);
+#endif
+	/*
+	 * Sparsemem tries to allocate bootmem in memory_present(),
+	 * so must be done after the fixed reservations
+	 */
+	uc32_memory_present();
+
+	/*
+	 * sparse_init() needs the bootmem allocator up and running.
+	 */
+	sparse_init();
+
+	/*
+	 * Now free the memory - free_area_init_node needs
+	 * the sparse mem_map arrays initialized by sparse_init()
+	 * for memmap_init_zone(), otherwise all PFNs are invalid.
+	 */
+	uc32_bootmem_free(min, max_low, max_high);
+
+	high_memory = __va((max_low << PAGE_SHIFT) - 1) + 1;
+
+	/*
+	 * This doesn't seem to be used by the Linux memory manager any
+	 * more, but is used by ll_rw_block.  If we can get rid of it, we
+	 * also get rid of some of the stuff above as well.
+	 *
+	 * Note: max_low_pfn and max_pfn reflect the number of _pages_ in
+	 * the system, not the maximum PFN.
+	 */
+	max_low_pfn = max_low - PHYS_PFN_OFFSET;
+	max_pfn = max_high - PHYS_PFN_OFFSET;
+}
+
+static inline int free_area(unsigned long pfn, unsigned long end, char *s)
+{
+	unsigned int pages = 0, size = (end - pfn) << (PAGE_SHIFT - 10);
+
+	for (; pfn < end; pfn++) {
+		struct page *page = pfn_to_page(pfn);
+		ClearPageReserved(page);
+		init_page_count(page);
+		__free_page(page);
+		pages++;
+	}
+
+	if (size && s)
+		printk(KERN_INFO "Freeing %s memory: %dK\n", s, size);
+
+	return pages;
+}
+
+static inline void
+free_memmap(unsigned long start_pfn, unsigned long end_pfn)
+{
+	struct page *start_pg, *end_pg;
+	unsigned long pg, pgend;
+
+	/*
+	 * Convert start_pfn/end_pfn to a struct page pointer.
+	 */
+	start_pg = pfn_to_page(start_pfn - 1) + 1;
+	end_pg = pfn_to_page(end_pfn);
+
+	/*
+	 * Convert to physical addresses, and
+	 * round start upwards and end downwards.
+	 */
+	pg = PAGE_ALIGN(__pa(start_pg));
+	pgend = __pa(end_pg) & PAGE_MASK;
+
+	/*
+	 * If there are free pages between these,
+	 * free the section of the memmap array.
+	 */
+	if (pg < pgend)
+		free_bootmem(pg, pgend - pg);
+}
+
+/*
+ * The mem_map array can get very big.  Free the unused area of the memory map.
+ */
+static void __init free_unused_memmap(struct meminfo *mi)
+{
+	unsigned long bank_start, prev_bank_end = 0;
+	unsigned int i;
+
+	/*
+	 * This relies on each bank being in address order.
+	 * The banks are sorted previously in bootmem_init().
+	 */
+	for_each_bank(i, mi) {
+		struct membank *bank = &mi->bank[i];
+
+		bank_start = bank_pfn_start(bank);
+
+		/*
+		 * If we had a previous bank, and there is a space
+		 * between the current bank and the previous, free it.
+		 */
+		if (prev_bank_end && prev_bank_end < bank_start)
+			free_memmap(prev_bank_end, bank_start);
+
+		/*
+		 * Align up here since the VM subsystem insists that the
+		 * memmap entries are valid from the bank end aligned to
+		 * MAX_ORDER_NR_PAGES.
+		 */
+		prev_bank_end = ALIGN(bank_pfn_end(bank), MAX_ORDER_NR_PAGES);
+	}
+}
+
+/*
+ * mem_init() marks the free areas in the mem_map and tells us how much
+ * memory is free.  This is done after various parts of the system have
+ * claimed their memory after the kernel image.
+ */
+void __init mem_init(void)
+{
+	unsigned long reserved_pages, free_pages;
+	struct memblock_region *reg;
+	int i;
+
+	max_mapnr   = pfn_to_page(max_pfn + PHYS_PFN_OFFSET) - mem_map;
+
+	/* this will put all unused low memory onto the freelists */
+	free_unused_memmap(&meminfo);
+
+	totalram_pages += free_all_bootmem();
+
+	reserved_pages = free_pages = 0;
+
+	for_each_bank(i, &meminfo) {
+		struct membank *bank = &meminfo.bank[i];
+		unsigned int pfn1, pfn2;
+		struct page *page, *end;
+
+		pfn1 = bank_pfn_start(bank);
+		pfn2 = bank_pfn_end(bank);
+
+		page = pfn_to_page(pfn1);
+		end  = pfn_to_page(pfn2 - 1) + 1;
+
+		do {
+			if (PageReserved(page))
+				reserved_pages++;
+			else if (!page_count(page))
+				free_pages++;
+			page++;
+		} while (page < end);
+	}
+
+	/*
+	 * Since our memory may not be contiguous, calculate the
+	 * real number of pages we have in this system
+	 */
+	printk(KERN_INFO "Memory:");
+	num_physpages = 0;
+	for_each_memblock(memory, reg) {
+		unsigned long pages = memblock_region_memory_end_pfn(reg) -
+			memblock_region_memory_base_pfn(reg);
+		num_physpages += pages;
+		printk(" %ldMB", pages >> (20 - PAGE_SHIFT));
+	}
+	printk(" = %luMB total\n", num_physpages >> (20 - PAGE_SHIFT));
+
+	printk(KERN_NOTICE "Memory: %luk/%luk available, %luk reserved, %luK highmem\n",
+		nr_free_pages() << (PAGE_SHIFT-10),
+		free_pages << (PAGE_SHIFT-10),
+		reserved_pages << (PAGE_SHIFT-10),
+		totalhigh_pages << (PAGE_SHIFT-10));
+
+	printk(KERN_NOTICE "Virtual kernel memory layout:\n"
+		"    vector  : 0x%08lx - 0x%08lx   (%4ld kB)\n"
+		"    vmalloc : 0x%08lx - 0x%08lx   (%4ld MB)\n"
+		"    lowmem  : 0x%08lx - 0x%08lx   (%4ld MB)\n"
+		"    modules : 0x%08lx - 0x%08lx   (%4ld MB)\n"
+		"      .init : 0x%p" " - 0x%p" "   (%4d kB)\n"
+		"      .text : 0x%p" " - 0x%p" "   (%4d kB)\n"
+		"      .data : 0x%p" " - 0x%p" "   (%4d kB)\n",
+
+		VECTORS_BASE, VECTORS_BASE + PAGE_SIZE,
+		DIV_ROUND_UP(PAGE_SIZE, SZ_1K),
+		VMALLOC_START, VMALLOC_END,
+		DIV_ROUND_UP((VMALLOC_END - VMALLOC_START), SZ_1M),
+		PAGE_OFFSET, (unsigned long)high_memory,
+		DIV_ROUND_UP(((unsigned long)high_memory - PAGE_OFFSET), SZ_1M),
+		MODULES_VADDR, MODULES_END,
+		DIV_ROUND_UP((MODULES_END - MODULES_VADDR), SZ_1M),
+
+		__init_begin, __init_end,
+		DIV_ROUND_UP((__init_end - __init_begin), SZ_1K),
+		_stext, _etext,
+		DIV_ROUND_UP((_etext - _stext), SZ_1K),
+		_sdata, _edata,
+		DIV_ROUND_UP((_edata - _sdata), SZ_1K));
+
+	BUILD_BUG_ON(TASK_SIZE				> MODULES_VADDR);
+	BUG_ON(TASK_SIZE				> MODULES_VADDR);
+
+	if (PAGE_SIZE >= 16384 && num_physpages <= 128) {
+		/*
+		 * On a machine this small we won't get
+		 * anywhere without overcommit, so turn
+		 * it on by default.
+		 */
+		sysctl_overcommit_memory = OVERCOMMIT_ALWAYS;
+	}
+}
+
+void free_initmem(void)
+{
+	totalram_pages += free_area(__phys_to_pfn(__pa(__init_begin)),
+				    __phys_to_pfn(__pa(__init_end)),
+				    "init");
+}
+
+#ifdef CONFIG_BLK_DEV_INITRD
+
+static int keep_initrd;
+
+void free_initrd_mem(unsigned long start, unsigned long end)
+{
+	if (!keep_initrd)
+		totalram_pages += free_area(__phys_to_pfn(__pa(start)),
+					    __phys_to_pfn(__pa(end)),
+					    "initrd");
+}
+
+static int __init keepinitrd_setup(char *__unused)
+{
+	keep_initrd = 1;
+	return 1;
+}
+
+__setup("keepinitrd", keepinitrd_setup);
+#endif
diff --git a/arch/unicore32/mm/iomap.c b/arch/unicore32/mm/iomap.c
new file mode 100644
index 0000000..a7e1a3d
--- /dev/null
+++ b/arch/unicore32/mm/iomap.c
@@ -0,0 +1,56 @@
+/*
+ * linux/arch/unicore32/mm/iomap.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Map IO port and PCI memory spaces so that {read,write}[bwl] can
+ * be used to access this memory.
+ */
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/ioport.h>
+#include <linux/io.h>
+
+#ifdef __io
+void __iomem *ioport_map(unsigned long port, unsigned int nr)
+{
+	/* we map PC lagcy 64K IO port to PCI IO space 0x80030000 */
+	return (void __iomem *) (unsigned long)
+			io_p2v((port & 0xffff) + PKUNITY_PCILIO_BASE);
+}
+EXPORT_SYMBOL(ioport_map);
+
+void ioport_unmap(void __iomem *addr)
+{
+}
+EXPORT_SYMBOL(ioport_unmap);
+#endif
+
+#ifdef CONFIG_PCI
+void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
+{
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len   = pci_resource_len(dev, bar);
+	unsigned long flags = pci_resource_flags(dev, bar);
+
+	if (!len || !start)
+		return NULL;
+	if (maxlen && len > maxlen)
+		len = maxlen;
+	if (flags & IORESOURCE_IO)
+		return ioport_map(start, len);
+	if (flags & IORESOURCE_MEM) {
+		if (flags & IORESOURCE_CACHEABLE)
+			return ioremap(start, len);
+		return ioremap_nocache(start, len);
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(pci_iomap);
+#endif
diff --git a/arch/unicore32/mm/ioremap.c b/arch/unicore32/mm/ioremap.c
new file mode 100644
index 0000000..b7a6055
--- /dev/null
+++ b/arch/unicore32/mm/ioremap.c
@@ -0,0 +1,261 @@
+/*
+ * linux/arch/unicore32/mm/ioremap.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ *
+ * Re-map IO memory to kernel address space so that we can access it.
+ *
+ * This allows a driver to remap an arbitrary region of bus memory into
+ * virtual space.  One should *only* use readl, writel, memcpy_toio and
+ * so on with such remapped areas.
+ *
+ * Because UniCore only has a 32-bit address space we can't address the
+ * whole of the (physical) PCI space at once.  PCI huge-mode addressing
+ * allows us to circumvent this restriction by splitting PCI space into
+ * two 2GB chunks and mapping only one at a time into processor memory.
+ * We use MMU protection domains to trap any attempt to access the bank
+ * that is not currently mapped.  (This isn't fully implemented yet.)
+ */
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+#include <linux/io.h>
+
+#include <asm/cputype.h>
+#include <asm/cacheflush.h>
+#include <asm/mmu_context.h>
+#include <asm/pgalloc.h>
+#include <asm/tlbflush.h>
+#include <asm/sizes.h>
+
+#include <mach/map.h>
+#include "mm.h"
+
+/*
+ * Used by ioremap() and iounmap() code to mark (super)section-mapped
+ * I/O regions in vm_struct->flags field.
+ */
+#define VM_UNICORE_SECTION_MAPPING	0x80000000
+
+int ioremap_page(unsigned long virt, unsigned long phys,
+		 const struct mem_type *mtype)
+{
+	return ioremap_page_range(virt, virt + PAGE_SIZE, phys,
+				  __pgprot(mtype->prot_pte));
+}
+EXPORT_SYMBOL(ioremap_page);
+
+/*
+ * Section support is unsafe on SMP - If you iounmap and ioremap a region,
+ * the other CPUs will not see this change until their next context switch.
+ * Meanwhile, (eg) if an interrupt comes in on one of those other CPUs
+ * which requires the new ioremap'd region to be referenced, the CPU will
+ * reference the _old_ region.
+ *
+ * Note that get_vm_area_caller() allocates a guard 4K page, so we need to
+ * mask the size back to 4MB aligned or we will overflow in the loop below.
+ */
+static void unmap_area_sections(unsigned long virt, unsigned long size)
+{
+	unsigned long addr = virt, end = virt + (size & ~(SZ_4M - 1));
+	pgd_t *pgd;
+
+	flush_cache_vunmap(addr, end);
+	pgd = pgd_offset_k(addr);
+	do {
+		pmd_t pmd, *pmdp = pmd_offset((pud_t *)pgd, addr);
+
+		pmd = *pmdp;
+		if (!pmd_none(pmd)) {
+			/*
+			 * Clear the PMD from the page table, and
+			 * increment the kvm sequence so others
+			 * notice this change.
+			 *
+			 * Note: this is still racy on SMP machines.
+			 */
+			pmd_clear(pmdp);
+
+			/*
+			 * Free the page table, if there was one.
+			 */
+			if ((pmd_val(pmd) & PMD_TYPE_MASK) == PMD_TYPE_TABLE)
+				pte_free_kernel(&init_mm, pmd_page_vaddr(pmd));
+		}
+
+		addr += PGDIR_SIZE;
+		pgd++;
+	} while (addr < end);
+
+	flush_tlb_kernel_range(virt, end);
+}
+
+static int
+remap_area_sections(unsigned long virt, unsigned long pfn,
+		    size_t size, const struct mem_type *type)
+{
+	unsigned long addr = virt, end = virt + size;
+	pgd_t *pgd;
+
+	/*
+	 * Remove and free any PTE-based mapping, and
+	 * sync the current kernel mapping.
+	 */
+	unmap_area_sections(virt, size);
+
+	pgd = pgd_offset_k(addr);
+	do {
+		pmd_t *pmd = pmd_offset((pud_t *)pgd, addr);
+
+		set_pmd(pmd, __pmd(__pfn_to_phys(pfn) | type->prot_sect));
+		pfn += SZ_4M >> PAGE_SHIFT;
+		flush_pmd_entry(pmd);
+
+		addr += PGDIR_SIZE;
+		pgd++;
+	} while (addr < end);
+
+	return 0;
+}
+
+void __iomem *__uc32_ioremap_pfn_caller(unsigned long pfn,
+	unsigned long offset, size_t size, unsigned int mtype, void *caller)
+{
+	const struct mem_type *type;
+	int err;
+	unsigned long addr;
+	struct vm_struct *area;
+
+	/*
+	 * High mappings must be section aligned
+	 */
+	if (pfn >= 0x100000 && (__pfn_to_phys(pfn) & ~SECTION_MASK))
+		return NULL;
+
+	/*
+	 * Don't allow RAM to be mapped
+	 */
+	if (pfn_valid(pfn)) {
+		printk(KERN_WARNING "BUG: Your driver calls ioremap() on\n"
+			"system memory.  This leads to architecturally\n"
+			"unpredictable behaviour, and ioremap() will fail in\n"
+			"the next kernel release. Please fix your driver.\n");
+		WARN_ON(1);
+	}
+
+	type = get_mem_type(mtype);
+	if (!type)
+		return NULL;
+
+	/*
+	 * Page align the mapping size, taking account of any offset.
+	 */
+	size = PAGE_ALIGN(offset + size);
+
+	area = get_vm_area_caller(size, VM_IOREMAP, caller);
+	if (!area)
+		return NULL;
+	addr = (unsigned long)area->addr;
+
+	if (!((__pfn_to_phys(pfn) | size | addr) & ~PMD_MASK)) {
+		area->flags |= VM_UNICORE_SECTION_MAPPING;
+		err = remap_area_sections(addr, pfn, size, type);
+	} else
+		err = ioremap_page_range(addr, addr + size, __pfn_to_phys(pfn),
+					 __pgprot(type->prot_pte));
+
+	if (err) {
+		vunmap((void *)addr);
+		return NULL;
+	}
+
+	flush_cache_vmap(addr, addr + size);
+	return (void __iomem *) (offset + addr);
+}
+
+void __iomem *__uc32_ioremap_caller(unsigned long phys_addr, size_t size,
+	unsigned int mtype, void *caller)
+{
+	unsigned long last_addr;
+	unsigned long offset = phys_addr & ~PAGE_MASK;
+	unsigned long pfn = __phys_to_pfn(phys_addr);
+
+	/*
+	 * Don't allow wraparound or zero size
+	 */
+	last_addr = phys_addr + size - 1;
+	if (!size || last_addr < phys_addr)
+		return NULL;
+
+	return __uc32_ioremap_pfn_caller(pfn, offset, size, mtype, caller);
+}
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
+void __iomem *
+__uc32_ioremap_pfn(unsigned long pfn, unsigned long offset, size_t size,
+		  unsigned int mtype)
+{
+	return __uc32_ioremap_pfn_caller(pfn, offset, size, mtype,
+			__builtin_return_address(0));
+}
+EXPORT_SYMBOL(__uc32_ioremap_pfn);
+
+void __iomem *
+__uc32_ioremap(unsigned long phys_addr, size_t size)
+{
+	return __uc32_ioremap_caller(phys_addr, size, MT_DEVICE,
+			__builtin_return_address(0));
+}
+EXPORT_SYMBOL(__uc32_ioremap);
+
+void __iomem *
+__uc32_ioremap_cached(unsigned long phys_addr, size_t size)
+{
+	return __uc32_ioremap_caller(phys_addr, size, MT_DEVICE_CACHED,
+			__builtin_return_address(0));
+}
+EXPORT_SYMBOL(__uc32_ioremap_cached);
+
+void __uc32_iounmap(volatile void __iomem *io_addr)
+{
+	void *addr = (void *)(PAGE_MASK & (unsigned long)io_addr);
+	struct vm_struct **p, *tmp;
+
+	/*
+	 * If this is a section based mapping we need to handle it
+	 * specially as the VM subsystem does not know how to handle
+	 * such a beast. We need the lock here b/c we need to clear
+	 * all the mappings before the area can be reclaimed
+	 * by someone else.
+	 */
+	write_lock(&vmlist_lock);
+	for (p = &vmlist ; (tmp = *p) ; p = &tmp->next) {
+		if ((tmp->flags & VM_IOREMAP) && (tmp->addr == addr)) {
+			if (tmp->flags & VM_UNICORE_SECTION_MAPPING) {
+				unmap_area_sections((unsigned long)tmp->addr,
+						    tmp->size);
+			}
+			break;
+		}
+	}
+	write_unlock(&vmlist_lock);
+
+	vunmap(addr);
+}
+EXPORT_SYMBOL(__uc32_iounmap);
diff --git a/arch/unicore32/mm/mm.h b/arch/unicore32/mm/mm.h
new file mode 100644
index 0000000..3296bca
--- /dev/null
+++ b/arch/unicore32/mm/mm.h
@@ -0,0 +1,39 @@
+/*
+ * linux/arch/unicore32/mm/mm.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+/* the upper-most page table pointer */
+extern pmd_t *top_pmd;
+extern int sysctl_overcommit_memory;
+
+#define TOP_PTE(x)	pte_offset_kernel(top_pmd, x)
+
+static inline pmd_t *pmd_off(pgd_t *pgd, unsigned long virt)
+{
+	return pmd_offset((pud_t *)pgd, virt);
+}
+
+static inline pmd_t *pmd_off_k(unsigned long virt)
+{
+	return pmd_off(pgd_offset_k(virt), virt);
+}
+
+struct mem_type {
+	unsigned int prot_pte;
+	unsigned int prot_l1;
+	unsigned int prot_sect;
+};
+
+const struct mem_type *get_mem_type(unsigned int type);
+
+extern void __flush_dcache_page(struct address_space *, struct page *);
+
+void __init bootmem_init(void);
+void uc32_mm_memblock_reserve(void);
-- 
1.7.0.4


