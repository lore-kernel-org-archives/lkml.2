Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab2IGQ2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:28:36 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34218 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2IGQ1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:27:52 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 04/31] arm64: MMU definitions
Date: Fri,  7 Sep 2012 17:26:39 +0100
Message-Id: <1347035226-18649-5-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Sep 2012 16:27:49.0019 (UTC) FILETIME=[B85796B0:01CD8D15]
X-MC-Unique: 112090717275013701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q87GSmgm008344

The virtual memory layout is described in
Documentation/arm64/memory.txt. This patch adds the MMU definitions for
the 4KB and 64KB translation table configurations. The SECTION_SIZE is
2MB with 4KB page and 512MB with 64KB page configuration.

PHYS_OFFSET is calculated at run-time and stored in a variable (no
run-time code patching at this stage).

On the current implementation, both user and kernel address spaces are
512G (39-bit) each with a maximum of 256G for the RAM linear mapping.
Linux uses 3 levels of translation tables with the 4K page configuration
and 2 levels with the 64K configuration. Extending the memory space
beyond 39-bit with the 4K pages or 42-bit with 64K pages requires an
additional level of translation tables.

The SPARSEMEM configuration is global to all AArch64 platforms and
allows for 1GB sections with SPARSEMEM_VMEMMAP enabled by default.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 Documentation/arm64/memory.txt                |   69 +++++
 arch/arm64/include/asm/memory.h               |  144 +++++++++++
 arch/arm64/include/asm/mmu.h                  |   27 ++
 arch/arm64/include/asm/pgtable-2level-hwdef.h |   43 ++++
 arch/arm64/include/asm/pgtable-2level-types.h |   60 +++++
 arch/arm64/include/asm/pgtable-3level-hwdef.h |   50 ++++
 arch/arm64/include/asm/pgtable-3level-types.h |   66 +++++
 arch/arm64/include/asm/pgtable-hwdef.h        |   94 +++++++
 arch/arm64/include/asm/pgtable.h              |  328 +++++++++++++++++++++++++
 arch/arm64/include/asm/sparsemem.h            |   24 ++
 10 files changed, 905 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/arm64/memory.txt
 create mode 100644 arch/arm64/include/asm/memory.h
 create mode 100644 arch/arm64/include/asm/mmu.h
 create mode 100644 arch/arm64/include/asm/pgtable-2level-hwdef.h
 create mode 100644 arch/arm64/include/asm/pgtable-2level-types.h
 create mode 100644 arch/arm64/include/asm/pgtable-3level-hwdef.h
 create mode 100644 arch/arm64/include/asm/pgtable-3level-types.h
 create mode 100644 arch/arm64/include/asm/pgtable-hwdef.h
 create mode 100644 arch/arm64/include/asm/pgtable.h
 create mode 100644 arch/arm64/include/asm/sparsemem.h

diff --git a/Documentation/arm64/memory.txt b/Documentation/arm64/memory.txt
new file mode 100644
index 0000000..7210af7
--- /dev/null
+++ b/Documentation/arm64/memory.txt
@@ -0,0 +1,69 @@
+		     Memory Layout on AArch64 Linux
+		     ==============================
+
+Author: Catalin Marinas <catalin.marinas@arm.com>
+Date  : 20 February 2012
+
+This document describes the virtual memory layout used by the AArch64
+Linux kernel. The architecture allows up to 4 levels of translation
+tables with a 4KB page size and up to 3 levels with a 64KB page size.
+
+AArch64 Linux uses 3 levels of translation tables with the 4KB page
+configuration, allowing 39-bit (512GB) virtual addresses for both user
+and kernel. With 64KB pages, only 2 levels of translation tables are
+used but the memory layout is the same.
+
+User addresses have bits 63:39 set to 0 while the kernel addresses have
+the same bits set to 1. TTBRx selection is given by bit 63 of the
+virtual address. The swapper_pg_dir contains only kernel (global)
+mappings while the user pgd contains only user (non-global) mappings.
+The swapper_pgd_dir address is written to TTBR1 and never written to
+TTBR0.
+
+
+AArch64 Linux memory layout:
+
+Start			End			Size		Use
+-----------------------------------------------------------------------
+0000000000000000	0000007fffffffff	 512GB		user
+
+ffffff8000000000	ffffffbbfffeffff	~240GB		vmalloc
+
+ffffffbbffff0000	ffffffbcffffffff	  64KB		[guard page]
+
+ffffffbc00000000	ffffffbdffffffff	   8GB		vmemmap
+
+ffffffbe00000000	ffffffbffbffffff	  ~8GB		[guard, future vmmemap]
+
+ffffffbffc000000	ffffffbfffffffff	  64MB		modules
+
+ffffffc000000000	ffffffffffffffff	 256GB		memory
+
+
+Translation table lookup with 4KB pages:
+
++--------+--------+--------+--------+--------+--------+--------+--------+
+|63    56|55    48|47    40|39    32|31    24|23    16|15     8|7      0|
++--------+--------+--------+--------+--------+--------+--------+--------+
+ |                 |         |         |         |         |
+ |                 |         |         |         |         v
+ |                 |         |         |         |   [11:0]  in-page offset
+ |                 |         |         |         +-> [20:12] L3 index
+ |                 |         |         +-----------> [29:21] L2 index
+ |                 |         +---------------------> [38:30] L1 index
+ |                 +-------------------------------> [47:39] L0 index (not used)
+ +-------------------------------------------------> [63] TTBR0/1
+
+
+Translation table lookup with 64KB pages:
+
++--------+--------+--------+--------+--------+--------+--------+--------+
+|63    56|55    48|47    40|39    32|31    24|23    16|15     8|7      0|
++--------+--------+--------+--------+--------+--------+--------+--------+
+ |                 |    |               |              |
+ |                 |    |               |              v
+ |                 |    |               |            [15:0]  in-page offset
+ |                 |    |               +----------> [28:16] L3 index
+ |                 |    +--------------------------> [41:29] L2 index (only 38:29 used)
+ |                 +-------------------------------> [47:42] L1 index (not used)
+ +-------------------------------------------------> [63] TTBR0/1
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
new file mode 100644
index 0000000..1cac16a
--- /dev/null
+++ b/arch/arm64/include/asm/memory.h
@@ -0,0 +1,144 @@
+/*
+ * Based on arch/arm/include/asm/memory.h
+ *
+ * Copyright (C) 2000-2002 Russell King
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ * Note: this file should not be included by non-asm/.h files
+ */
+#ifndef __ASM_MEMORY_H
+#define __ASM_MEMORY_H
+
+#include <linux/compiler.h>
+#include <linux/const.h>
+#include <linux/types.h>
+#include <asm/sizes.h>
+
+/*
+ * Allow for constants defined here to be used from assembly code
+ * by prepending the UL suffix only with actual C code compilation.
+ */
+#define UL(x) _AC(x, UL)
+
+/*
+ * PAGE_OFFSET - the virtual address of the start of the kernel image.
+ * VA_BITS - the maximum number of bits for virtual addresses.
+ * TASK_SIZE - the maximum size of a user space task.
+ * TASK_UNMAPPED_BASE - the lower boundary of the mmap VM area.
+ * The module space lives between the addresses given by TASK_SIZE
+ * and PAGE_OFFSET - it must be within 128MB of the kernel text.
+ */
+#define PAGE_OFFSET		UL(0xffffffc000000000)
+#define MODULES_END		(PAGE_OFFSET)
+#define MODULES_VADDR		(MODULES_END - SZ_64M)
+#define VA_BITS			(39)
+#define TASK_SIZE_64		(UL(1) << VA_BITS)
+
+#ifdef CONFIG_COMPAT
+#define TASK_SIZE_32		UL(0x100000000)
+#define TASK_SIZE		(test_thread_flag(TIF_32BIT) ? \
+				TASK_SIZE_32 : TASK_SIZE_64)
+#else
+#define TASK_SIZE		TASK_SIZE_64
+#endif /* CONFIG_COMPAT */
+
+#define TASK_UNMAPPED_BASE	(PAGE_ALIGN(TASK_SIZE / 4))
+
+#if TASK_SIZE_64 > MODULES_VADDR
+#error Top of 64-bit user space clashes with start of module space
+#endif
+
+/*
+ * Physical vs virtual RAM address space conversion.  These are
+ * private definitions which should NOT be used outside memory.h
+ * files.  Use virt_to_phys/phys_to_virt/__pa/__va instead.
+ */
+#define __virt_to_phys(x)	(((phys_addr_t)(x) - PAGE_OFFSET + PHYS_OFFSET))
+#define __phys_to_virt(x)	((unsigned long)((x) - PHYS_OFFSET + PAGE_OFFSET))
+
+/*
+ * Convert a physical address to a Page Frame Number and back
+ */
+#define	__phys_to_pfn(paddr)	((unsigned long)((paddr) >> PAGE_SHIFT))
+#define	__pfn_to_phys(pfn)	((phys_addr_t)(pfn) << PAGE_SHIFT)
+
+/*
+ * Convert a page to/from a physical address
+ */
+#define page_to_phys(page)	(__pfn_to_phys(page_to_pfn(page)))
+#define phys_to_page(phys)	(pfn_to_page(__phys_to_pfn(phys)))
+
+/*
+ * Memory types available.
+ */
+#define MT_DEVICE_nGnRnE	0
+#define MT_DEVICE_nGnRE		1
+#define MT_DEVICE_GRE		2
+#define MT_NORMAL_NC		3
+#define MT_NORMAL		4
+
+#ifndef __ASSEMBLY__
+
+extern phys_addr_t		memstart_addr;
+/* PHYS_OFFSET - the physical address of the start of memory. */
+#define PHYS_OFFSET		({ memstart_addr; })
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
+ * Note: Drivers should NOT use these.  They are the wrong
+ * translation for translating DMA addresses.  Use the driver
+ * DMA support - see dma-mapping.h.
+ */
+static inline phys_addr_t virt_to_phys(const volatile void *x)
+{
+	return __virt_to_phys((unsigned long)(x));
+}
+
+static inline void *phys_to_virt(phys_addr_t x)
+{
+	return (void *)(__phys_to_virt(x));
+}
+
+/*
+ * Drivers should NOT use these either.
+ */
+#define __pa(x)			__virt_to_phys((unsigned long)(x))
+#define __va(x)			((void *)__phys_to_virt((phys_addr_t)(x)))
+#define pfn_to_kaddr(pfn)	__va((pfn) << PAGE_SHIFT)
+
+/*
+ *  virt_to_page(k)	convert a _valid_ virtual address to struct page *
+ *  virt_addr_valid(k)	indicates whether a virtual address is valid
+ */
+#define ARCH_PFN_OFFSET		PHYS_PFN_OFFSET
+
+#define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
+#define	virt_addr_valid(kaddr)	(((void *)(kaddr) >= (void *)PAGE_OFFSET) && \
+				 ((void *)(kaddr) < (void *)high_memory))
+
+#endif
+
+#include <asm-generic/memory_model.h>
+
+#endif
diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
new file mode 100644
index 0000000..c72ad38
--- /dev/null
+++ b/arch/arm64/include/asm/mmu.h
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_MMU_H
+#define __ASM_MMU_H
+
+typedef struct {
+	unsigned int id;
+	raw_spinlock_t id_lock;
+	void *vdso;
+} mm_context_t;
+
+#define ASID(mm)	((mm)->context.id & 0xffff)
+
+#endif
diff --git a/arch/arm64/include/asm/pgtable-2level-hwdef.h b/arch/arm64/include/asm/pgtable-2level-hwdef.h
new file mode 100644
index 0000000..0a8ed3f
--- /dev/null
+++ b/arch/arm64/include/asm/pgtable-2level-hwdef.h
@@ -0,0 +1,43 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_PGTABLE_2LEVEL_HWDEF_H
+#define __ASM_PGTABLE_2LEVEL_HWDEF_H
+
+/*
+ * With LPAE and 64KB pages, there are 2 levels of page tables. Each level has
+ * 8192 entries of 8 bytes each, occupying a 64KB page. Levels 0 and 1 are not
+ * used. The 2nd level table (PGD for Linux) can cover a range of 4TB, each
+ * entry representing 512MB. The user and kernel address spaces are limited to
+ * 512GB and therefore we only use 1024 entries in the PGD.
+ */
+#define PTRS_PER_PTE		8192
+#define PTRS_PER_PGD		1024
+
+/*
+ * PGDIR_SHIFT determines the size a top-level page table entry can map.
+ */
+#define PGDIR_SHIFT		29
+#define PGDIR_SIZE		(_AC(1, UL) << PGDIR_SHIFT)
+#define PGDIR_MASK		(~(PGDIR_SIZE-1))
+
+/*
+ * section address mask and size definitions.
+ */
+#define SECTION_SHIFT		29
+#define SECTION_SIZE		(_AC(1, UL) << SECTION_SHIFT)
+#define SECTION_MASK		(~(SECTION_SIZE-1))
+
+#endif
diff --git a/arch/arm64/include/asm/pgtable-2level-types.h b/arch/arm64/include/asm/pgtable-2level-types.h
new file mode 100644
index 0000000..3c3ca7d
--- /dev/null
+++ b/arch/arm64/include/asm/pgtable-2level-types.h
@@ -0,0 +1,60 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_PGTABLE_2LEVEL_TYPES_H
+#define __ASM_PGTABLE_2LEVEL_TYPES_H
+
+typedef u64 pteval_t;
+typedef u64 pgdval_t;
+typedef pgdval_t pmdval_t;
+
+#undef STRICT_MM_TYPECHECKS
+
+#ifdef STRICT_MM_TYPECHECKS
+
+/*
+ * These are used to make use of C type-checking..
+ */
+typedef struct { pteval_t pte; } pte_t;
+typedef struct { pgdval_t pgd; } pgd_t;
+typedef struct { pteval_t pgprot; } pgprot_t;
+
+#define pte_val(x)      ((x).pte)
+#define pgd_val(x)	((x).pgd)
+#define pgprot_val(x)   ((x).pgprot)
+
+#define __pte(x)        ((pte_t) { (x) } )
+#define __pgd(x)	((pgd_t) { (x) } )
+#define __pgprot(x)     ((pgprot_t) { (x) } )
+
+#else	/* !STRICT_MM_TYPECHECKS */
+
+typedef pteval_t pte_t;
+typedef pgdval_t pgd_t;
+typedef pteval_t pgprot_t;
+
+#define pte_val(x)	(x)
+#define pgd_val(x)	(x)
+#define pgprot_val(x)	(x)
+
+#define __pte(x)	(x)
+#define __pgd(x)	(x)
+#define __pgprot(x)	(x)
+
+#endif	/* STRICT_MM_TYPECHECKS */
+
+#include <asm-generic/pgtable-nopmd.h>
+
+#endif	/* __ASM_PGTABLE_2LEVEL_TYPES_H */
diff --git a/arch/arm64/include/asm/pgtable-3level-hwdef.h b/arch/arm64/include/asm/pgtable-3level-hwdef.h
new file mode 100644
index 0000000..3dbf941
--- /dev/null
+++ b/arch/arm64/include/asm/pgtable-3level-hwdef.h
@@ -0,0 +1,50 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_PGTABLE_3LEVEL_HWDEF_H
+#define __ASM_PGTABLE_3LEVEL_HWDEF_H
+
+/*
+ * With LPAE and 4KB pages, there are 3 levels of page tables. Each level has
+ * 512 entries of 8 bytes each, occupying a 4K page. The first level table
+ * covers a range of 512GB, each entry representing 1GB. The user and kernel
+ * address spaces are limited to 512GB each.
+ */
+#define PTRS_PER_PTE		512
+#define PTRS_PER_PMD		512
+#define PTRS_PER_PGD		512
+
+/*
+ * PGDIR_SHIFT determines the size a top-level page table entry can map.
+ */
+#define PGDIR_SHIFT		30
+#define PGDIR_SIZE		(_AC(1, UL) << PGDIR_SHIFT)
+#define PGDIR_MASK		(~(PGDIR_SIZE-1))
+
+/*
+ * PMD_SHIFT determines the size a middle-level page table entry can map.
+ */
+#define PMD_SHIFT		21
+#define PMD_SIZE		(_AC(1, UL) << PMD_SHIFT)
+#define PMD_MASK		(~(PMD_SIZE-1))
+
+/*
+ * section address mask and size definitions.
+ */
+#define SECTION_SHIFT		21
+#define SECTION_SIZE		(_AC(1, UL) << SECTION_SHIFT)
+#define SECTION_MASK		(~(SECTION_SIZE-1))
+
+#endif
diff --git a/arch/arm64/include/asm/pgtable-3level-types.h b/arch/arm64/include/asm/pgtable-3level-types.h
new file mode 100644
index 0000000..4489615
--- /dev/null
+++ b/arch/arm64/include/asm/pgtable-3level-types.h
@@ -0,0 +1,66 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_PGTABLE_3LEVEL_TYPES_H
+#define __ASM_PGTABLE_3LEVEL_TYPES_H
+
+typedef u64 pteval_t;
+typedef u64 pmdval_t;
+typedef u64 pgdval_t;
+
+#undef STRICT_MM_TYPECHECKS
+
+#ifdef STRICT_MM_TYPECHECKS
+
+/*
+ * These are used to make use of C type-checking..
+ */
+typedef struct { pteval_t pte; } pte_t;
+typedef struct { pmdval_t pmd; } pmd_t;
+typedef struct { pgdval_t pgd; } pgd_t;
+typedef struct { pteval_t pgprot; } pgprot_t;
+
+#define pte_val(x)      ((x).pte)
+#define pmd_val(x)      ((x).pmd)
+#define pgd_val(x)	((x).pgd)
+#define pgprot_val(x)   ((x).pgprot)
+
+#define __pte(x)        ((pte_t) { (x) } )
+#define __pmd(x)        ((pmd_t) { (x) } )
+#define __pgd(x)	((pgd_t) { (x) } )
+#define __pgprot(x)     ((pgprot_t) { (x) } )
+
+#else	/* !STRICT_MM_TYPECHECKS */
+
+typedef pteval_t pte_t;
+typedef pmdval_t pmd_t;
+typedef pgdval_t pgd_t;
+typedef pteval_t pgprot_t;
+
+#define pte_val(x)	(x)
+#define pmd_val(x)	(x)
+#define pgd_val(x)	(x)
+#define pgprot_val(x)	(x)
+
+#define __pte(x)	(x)
+#define __pmd(x)	(x)
+#define __pgd(x)	(x)
+#define __pgprot(x)	(x)
+
+#endif	/* STRICT_MM_TYPECHECKS */
+
+#include <asm-generic/pgtable-nopud.h>
+
+#endif	/* __ASM_PGTABLE_3LEVEL_TYPES_H */
diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
new file mode 100644
index 0000000..0f3b458
--- /dev/null
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -0,0 +1,94 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_PGTABLE_HWDEF_H
+#define __ASM_PGTABLE_HWDEF_H
+
+#ifdef CONFIG_ARM64_64K_PAGES
+#include <asm/pgtable-2level-hwdef.h>
+#else
+#include <asm/pgtable-3level-hwdef.h>
+#endif
+
+/*
+ * Hardware page table definitions.
+ *
+ * Level 2 descriptor (PMD).
+ */
+#define PMD_TYPE_MASK		(_AT(pmdval_t, 3) << 0)
+#define PMD_TYPE_FAULT		(_AT(pmdval_t, 0) << 0)
+#define PMD_TYPE_TABLE		(_AT(pmdval_t, 3) << 0)
+#define PMD_TYPE_SECT		(_AT(pmdval_t, 1) << 0)
+
+/*
+ * Section
+ */
+#define PMD_SECT_S		(_AT(pmdval_t, 3) << 8)
+#define PMD_SECT_AF		(_AT(pmdval_t, 1) << 10)
+#define PMD_SECT_NG		(_AT(pmdval_t, 1) << 11)
+#define PMD_SECT_XN		(_AT(pmdval_t, 1) << 54)
+
+/*
+ * AttrIndx[2:0] encoding (mapping attributes defined in the MAIR* registers).
+ */
+#define PMD_ATTRINDX(t)		(_AT(pmdval_t, (t)) << 2)
+#define PMD_ATTRINDX_MASK	(_AT(pmdval_t, 7) << 2)
+
+/*
+ * Level 3 descriptor (PTE).
+ */
+#define PTE_TYPE_MASK		(_AT(pteval_t, 3) << 0)
+#define PTE_TYPE_FAULT		(_AT(pteval_t, 0) << 0)
+#define PTE_TYPE_PAGE		(_AT(pteval_t, 3) << 0)
+#define PTE_USER		(_AT(pteval_t, 1) << 6)		/* AP[1] */
+#define PTE_RDONLY		(_AT(pteval_t, 1) << 7)		/* AP[2] */
+#define PTE_SHARED		(_AT(pteval_t, 3) << 8)		/* SH[1:0], inner shareable */
+#define PTE_AF			(_AT(pteval_t, 1) << 10)	/* Access Flag */
+#define PTE_NG			(_AT(pteval_t, 1) << 11)	/* nG */
+#define PTE_XN			(_AT(pteval_t, 1) << 54)	/* XN */
+
+/*
+ * AttrIndx[2:0] encoding (mapping attributes defined in the MAIR* registers).
+ */
+#define PTE_ATTRINDX(t)		(_AT(pteval_t, (t)) << 2)
+#define PTE_ATTRINDX_MASK	(_AT(pteval_t, 7) << 2)
+
+/*
+ * 40-bit physical address supported.
+ */
+#define PHYS_MASK_SHIFT		(40)
+#define PHYS_MASK		((UL(1) << PHYS_MASK_SHIFT) - 1)
+
+/*
+ * TCR flags.
+ */
+#define TCR_TxSZ(x)		(((UL(64) - (x)) << 16) | ((UL(64) - (x)) << 0))
+#define TCR_IRGN_NC		((UL(0) << 8) | (UL(0) << 24))
+#define TCR_IRGN_WBWA		((UL(1) << 8) | (UL(1) << 24))
+#define TCR_IRGN_WT		((UL(2) << 8) | (UL(2) << 24))
+#define TCR_IRGN_WBnWA		((UL(3) << 8) | (UL(3) << 24))
+#define TCR_IRGN_MASK		((UL(3) << 8) | (UL(3) << 24))
+#define TCR_ORGN_NC		((UL(0) << 10) | (UL(0) << 26))
+#define TCR_ORGN_WBWA		((UL(1) << 10) | (UL(1) << 26))
+#define TCR_ORGN_WT		((UL(2) << 10) | (UL(2) << 26))
+#define TCR_ORGN_WBnWA		((UL(3) << 10) | (UL(3) << 26))
+#define TCR_ORGN_MASK		((UL(3) << 10) | (UL(3) << 26))
+#define TCR_SHARED		((UL(3) << 12) | (UL(3) << 28))
+#define TCR_TG0_64K		(UL(1) << 14)
+#define TCR_TG1_64K		(UL(1) << 30)
+#define TCR_IPS_40BIT		(UL(2) << 32)
+#define TCR_ASID16		(UL(1) << 36)
+
+#endif
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
new file mode 100644
index 0000000..6981da0
--- /dev/null
+++ b/arch/arm64/include/asm/pgtable.h
@@ -0,0 +1,328 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_PGTABLE_H
+#define __ASM_PGTABLE_H
+
+#include <asm/proc-fns.h>
+
+#include <asm/memory.h>
+#include <asm/pgtable-hwdef.h>
+
+/*
+ * Software defined PTE bits definition.
+ */
+#define PTE_VALID		(_AT(pteval_t, 1) << 0)	/* pte_present() check */
+#define PTE_FILE		(_AT(pteval_t, 1) << 2)	/* only when !pte_present() */
+#define PTE_DIRTY		(_AT(pteval_t, 1) << 55)
+#define PTE_SPECIAL		(_AT(pteval_t, 1) << 56)
+
+/*
+ * VMALLOC and SPARSEMEM_VMEMMAP ranges.
+ */
+#define VMALLOC_START		UL(0xffffff8000000000)
+#define VMALLOC_END		(PAGE_OFFSET - UL(0x400000000) - SZ_64K)
+
+#define vmemmap			((struct page *)(VMALLOC_END + SZ_64K))
+
+#define FIRST_USER_ADDRESS	0
+
+#ifndef __ASSEMBLY__
+extern void __pte_error(const char *file, int line, unsigned long val);
+extern void __pmd_error(const char *file, int line, unsigned long val);
+extern void __pgd_error(const char *file, int line, unsigned long val);
+
+#define pte_ERROR(pte)		__pte_error(__FILE__, __LINE__, pte_val(pte))
+#ifndef CONFIG_ARM64_64K_PAGES
+#define pmd_ERROR(pmd)		__pmd_error(__FILE__, __LINE__, pmd_val(pmd))
+#endif
+#define pgd_ERROR(pgd)		__pgd_error(__FILE__, __LINE__, pgd_val(pgd))
+
+/*
+ * The pgprot_* and protection_map entries will be fixed up at runtime to
+ * include the cachable and bufferable bits based on memory policy, as well as
+ * any architecture dependent bits like global/ASID and SMP shared mapping
+ * bits.
+ */
+#define _PAGE_DEFAULT		PTE_TYPE_PAGE | PTE_AF
+
+extern pgprot_t pgprot_default;
+
+#define _MOD_PROT(p, b)	__pgprot(pgprot_val(p) | (b))
+
+#define PAGE_NONE		_MOD_PROT(pgprot_default, PTE_NG | PTE_XN | PTE_RDONLY)
+#define PAGE_SHARED		_MOD_PROT(pgprot_default, PTE_USER | PTE_NG | PTE_XN)
+#define PAGE_SHARED_EXEC	_MOD_PROT(pgprot_default, PTE_USER | PTE_NG)
+#define PAGE_COPY		_MOD_PROT(pgprot_default, PTE_USER | PTE_NG | PTE_XN | PTE_RDONLY)
+#define PAGE_COPY_EXEC		_MOD_PROT(pgprot_default, PTE_USER | PTE_NG | PTE_RDONLY)
+#define PAGE_READONLY		_MOD_PROT(pgprot_default, PTE_USER | PTE_NG | PTE_XN | PTE_RDONLY)
+#define PAGE_READONLY_EXEC	_MOD_PROT(pgprot_default, PTE_USER | PTE_NG | PTE_RDONLY)
+#define PAGE_KERNEL		_MOD_PROT(pgprot_default, PTE_XN | PTE_DIRTY)
+#define PAGE_KERNEL_EXEC	_MOD_PROT(pgprot_default, PTE_DIRTY)
+
+#define __PAGE_NONE		__pgprot(_PAGE_DEFAULT | PTE_NG | PTE_XN | PTE_RDONLY)
+#define __PAGE_SHARED		__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG | PTE_XN)
+#define __PAGE_SHARED_EXEC	__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG)
+#define __PAGE_COPY		__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG | PTE_XN | PTE_RDONLY)
+#define __PAGE_COPY_EXEC	__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG | PTE_RDONLY)
+#define __PAGE_READONLY		__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG | PTE_XN | PTE_RDONLY)
+#define __PAGE_READONLY_EXEC	__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG | PTE_RDONLY)
+
+#endif /* __ASSEMBLY__ */
+
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
+#define ZERO_PAGE(vaddr)	(empty_zero_page)
+
+#define pte_pfn(pte)		((pte_val(pte) & PHYS_MASK) >> PAGE_SHIFT)
+
+#define pfn_pte(pfn,prot)	(__pte(((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot)))
+
+#define pte_none(pte)		(!pte_val(pte))
+#define pte_clear(mm,addr,ptep)	set_pte(ptep, __pte(0))
+#define pte_page(pte)		(pfn_to_page(pte_pfn(pte)))
+#define pte_offset_kernel(dir,addr)	(pmd_page_vaddr(*(dir)) + __pte_index(addr))
+
+#define pte_offset_map(dir,addr)	pte_offset_kernel((dir), (addr))
+#define pte_offset_map_nested(dir,addr)	pte_offset_kernel((dir), (addr))
+#define pte_unmap(pte)			do { } while (0)
+#define pte_unmap_nested(pte)		do { } while (0)
+
+/*
+ * The following only work if pte_present(). Undefined behaviour otherwise.
+ */
+#define pte_present(pte)	(pte_val(pte) & PTE_VALID)
+#define pte_dirty(pte)		(pte_val(pte) & PTE_DIRTY)
+#define pte_young(pte)		(pte_val(pte) & PTE_AF)
+#define pte_special(pte)	(pte_val(pte) & PTE_SPECIAL)
+#define pte_write(pte)		(!(pte_val(pte) & PTE_RDONLY))
+#define pte_exec(pte)		(!(pte_val(pte) & PTE_XN))
+
+#define pte_present_exec_user(pte) \
+	((pte_val(pte) & (PTE_VALID | PTE_USER | PTE_XN)) == \
+	 (PTE_VALID | PTE_USER))
+
+#define PTE_BIT_FUNC(fn,op) \
+static inline pte_t pte_##fn(pte_t pte) { pte_val(pte) op; return pte; }
+
+PTE_BIT_FUNC(wrprotect, |= PTE_RDONLY);
+PTE_BIT_FUNC(mkwrite,   &= ~PTE_RDONLY);
+PTE_BIT_FUNC(mkclean,   &= ~PTE_DIRTY);
+PTE_BIT_FUNC(mkdirty,   |= PTE_DIRTY);
+PTE_BIT_FUNC(mkold,     &= ~PTE_AF);
+PTE_BIT_FUNC(mkyoung,   |= PTE_AF);
+PTE_BIT_FUNC(mkspecial, |= PTE_SPECIAL);
+
+static inline void set_pte(pte_t *ptep, pte_t pte)
+{
+	*ptep = pte;
+}
+
+extern void __sync_icache_dcache(pte_t pteval);
+
+static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
+			      pte_t *ptep, pte_t pte)
+{
+	if (pte_present_exec_user(pte))
+		__sync_icache_dcache(pte);
+	set_pte(ptep, pte);
+}
+
+/*
+ * Huge pte definitions.
+ */
+#define pte_huge(pte)		((pte_val(pte) & PTE_TYPE_MASK) == PTE_TYPE_HUGEPAGE)
+#define pte_mkhuge(pte)		(__pte((pte_val(pte) & ~PTE_TYPE_MASK) | PTE_TYPE_HUGEPAGE))
+
+#define __pgprot_modify(prot,mask,bits)		\
+	__pgprot((pgprot_val(prot) & ~(mask)) | (bits))
+
+#define __HAVE_ARCH_PTE_SPECIAL
+
+/*
+ * Mark the prot value as uncacheable and unbufferable.
+ */
+#define pgprot_noncached(prot) \
+	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_nGnRnE))
+#define pgprot_writecombine(prot) \
+	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_GRE))
+#define pgprot_dmacoherent(prot) \
+	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_NORMAL_NC))
+#define __HAVE_PHYS_MEM_ACCESS_PROT
+struct file;
+extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
+				     unsigned long size, pgprot_t vma_prot);
+
+#define pmd_none(pmd)		(!pmd_val(pmd))
+#define pmd_present(pmd)	(pmd_val(pmd))
+
+#define pmd_bad(pmd)		(!(pmd_val(pmd) & 2))
+
+static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
+{
+	*pmdp = pmd;
+	dsb();
+}
+
+static inline void pmd_clear(pmd_t *pmdp)
+{
+	set_pmd(pmdp, __pmd(0));
+}
+
+static inline pte_t *pmd_page_vaddr(pmd_t pmd)
+{
+	return __va(pmd_val(pmd) & PHYS_MASK & (s32)PAGE_MASK);
+}
+
+#define pmd_page(pmd)		pfn_to_page(__phys_to_pfn(pmd_val(pmd) & PHYS_MASK))
+
+/*
+ * Conversion functions: convert a page and protection to a page entry,
+ * and a page entry and page directory to the page they refer to.
+ */
+#define mk_pte(page,prot)	pfn_pte(page_to_pfn(page),prot)
+
+#ifndef CONFIG_ARM64_64K_PAGES
+
+#define pud_none(pud)		(!pud_val(pud))
+#define pud_bad(pud)		(!(pud_val(pud) & 2))
+#define pud_present(pud)	(pud_val(pud))
+
+static inline void set_pud(pud_t *pudp, pud_t pud)
+{
+	*pudp = pud;
+	dsb();
+}
+
+static inline void pud_clear(pud_t *pudp)
+{
+	set_pud(pudp, __pud(0));
+}
+
+static inline pmd_t *pud_page_vaddr(pud_t pud)
+{
+	return __va(pud_val(pud) & PHYS_MASK & (s32)PAGE_MASK);
+}
+
+#endif	/* CONFIG_ARM64_64K_PAGES */
+
+/* to find an entry in a page-table-directory */
+#define pgd_index(addr)		(((addr) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
+
+#define pgd_offset(mm, addr)	((mm)->pgd+pgd_index(addr))
+
+/* to find an entry in a kernel page-table-directory */
+#define pgd_offset_k(addr)	pgd_offset(&init_mm, addr)
+
+/* Find an entry in the second-level page table.. */
+#ifndef CONFIG_ARM64_64K_PAGES
+#define pmd_index(addr)		(((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
+static inline pmd_t *pmd_offset(pud_t *pud, unsigned long addr)
+{
+	return (pmd_t *)pud_page_vaddr(*pud) + pmd_index(addr);
+}
+#endif
+
+/* Find an entry in the third-level page table.. */
+#define __pte_index(addr)	(((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
+
+static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
+{
+	const pteval_t mask = PTE_USER | PTE_XN | PTE_RDONLY;
+	pte_val(pte) = (pte_val(pte) & ~mask) | (pgprot_val(newprot) & mask);
+	return pte;
+}
+
+extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
+extern pgd_t idmap_pg_dir[PTRS_PER_PGD];
+
+#define SWAPPER_DIR_SIZE	(3 * PAGE_SIZE)
+#define IDMAP_DIR_SIZE		(2 * PAGE_SIZE)
+
+/*
+ * Encode and decode a swap entry:
+ *	bits 0-1:	present (must be zero)
+ *	bit  2:		PTE_FILE
+ *	bits 3-8:	swap type
+ *	bits 9-63:	swap offset
+ */
+#define __SWP_TYPE_SHIFT	3
+#define __SWP_TYPE_BITS		6
+#define __SWP_TYPE_MASK		((1 << __SWP_TYPE_BITS) - 1)
+#define __SWP_OFFSET_SHIFT	(__SWP_TYPE_BITS + __SWP_TYPE_SHIFT)
+
+#define __swp_type(x)		(((x).val >> __SWP_TYPE_SHIFT) & __SWP_TYPE_MASK)
+#define __swp_offset(x)		((x).val >> __SWP_OFFSET_SHIFT)
+#define __swp_entry(type,offset) ((swp_entry_t) { ((type) << __SWP_TYPE_SHIFT) | ((offset) << __SWP_OFFSET_SHIFT) })
+
+#define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
+#define __swp_entry_to_pte(swp)	((pte_t) { (swp).val })
+
+/*
+ * Ensure that there are not more swap files than can be encoded in the kernel
+ * the PTEs.
+ */
+#define MAX_SWAPFILES_CHECK() BUILD_BUG_ON(MAX_SWAPFILES_SHIFT > __SWP_TYPE_BITS)
+
+/*
+ * Encode and decode a file entry:
+ *	bits 0-1:	present (must be zero)
+ *	bit  2:		PTE_FILE
+ *	bits 3-63:	file offset / PAGE_SIZE
+ */
+#define pte_file(pte)		(pte_val(pte) & PTE_FILE)
+#define pte_to_pgoff(x)		(pte_val(x) >> 3)
+#define pgoff_to_pte(x)		__pte(((x) << 3) | PTE_FILE)
+
+#define PTE_FILE_MAX_BITS	61
+
+extern int kern_addr_valid(unsigned long addr);
+
+#include <asm-generic/pgtable.h>
+
+/*
+ * remap a physical page `pfn' of size `size' with page protection `prot'
+ * into virtual address `from'
+ */
+#define io_remap_pfn_range(vma,from,pfn,size,prot) \
+		remap_pfn_range(vma, from, pfn, size, prot)
+
+#define pgtable_cache_init() do { } while (0)
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* __ASM_PGTABLE_H */
diff --git a/arch/arm64/include/asm/sparsemem.h b/arch/arm64/include/asm/sparsemem.h
new file mode 100644
index 0000000..1be62bc
--- /dev/null
+++ b/arch/arm64/include/asm/sparsemem.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_SPARSEMEM_H
+#define __ASM_SPARSEMEM_H
+
+#ifdef CONFIG_SPARSEMEM
+#define MAX_PHYSMEM_BITS	40
+#define SECTION_SIZE_BITS	30
+#endif
+
+#endif

