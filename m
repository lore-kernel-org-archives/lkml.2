Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab2IGQ2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:28:14 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34181 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab2IGQ1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:27:52 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 02/31] arm64: Kernel booting and initialisation
Date: Fri,  7 Sep 2012 17:26:37 +0100
Message-Id: <1347035226-18649-3-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Sep 2012 16:27:48.0253 (UTC) FILETIME=[B7E2B4D0:01CD8D15]
X-MC-Unique: 112090717275004101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q87GTQSf008356

The patch adds the kernel booting and the initial setup code.
Documentation/arm64/booting.txt describes the booting protocol on the
AArch64 Linux kernel. This is subject to change following the work on
boot standardisation, ACPI.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Nicolas Pitre <nico@linaro.org>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 Documentation/arm64/booting.txt |  152 ++++++++++++
 arch/arm64/include/asm/setup.h  |   26 ++
 arch/arm64/kernel/head.S        |  510 +++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/setup.c       |  351 +++++++++++++++++++++++++++
 4 files changed, 1039 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/arm64/booting.txt
 create mode 100644 arch/arm64/include/asm/setup.h
 create mode 100644 arch/arm64/kernel/head.S
 create mode 100644 arch/arm64/kernel/setup.c

diff --git a/Documentation/arm64/booting.txt b/Documentation/arm64/booting.txt
new file mode 100644
index 0000000..9c4d388
--- /dev/null
+++ b/Documentation/arm64/booting.txt
@@ -0,0 +1,152 @@
+			Booting AArch64 Linux
+			=====================
+
+Author: Will Deacon <will.deacon@arm.com>
+Date  : 07 September 2012
+
+This document is based on the ARM booting document by Russell King and
+is relevant to all public releases of the AArch64 Linux kernel.
+
+The AArch64 exception model is made up of a number of exception levels
+(EL0 - EL3), with EL0 and EL1 having a secure and a non-secure
+counterpart.  EL2 is the hypervisor level and exists only in non-secure
+mode. EL3 is the highest priority level and exists only in secure mode.
+
+For the purposes of this document, we will use the term `boot loader'
+simply to define all software that executes on the CPU(s) before control
+is passed to the Linux kernel.  This may include secure monitor and
+hypervisor code, or it may just be a handful of instructions for
+preparing a minimal boot environment.
+
+Essentially, the boot loader should provide (as a minimum) the
+following:
+
+1. Setup and initialise the RAM
+2. Setup the device tree
+3. Decompress the kernel image
+4. Call the kernel image
+
+
+1. Setup and initialise RAM
+---------------------------
+
+Requirement: MANDATORY
+
+The boot loader is expected to find and initialise all RAM that the
+kernel will use for volatile data storage in the system.  It performs
+this in a machine dependent manner.  (It may use internal algorithms
+to automatically locate and size all RAM, or it may use knowledge of
+the RAM in the machine, or any other method the boot loader designer
+sees fit.)
+
+
+2. Setup the device tree
+-------------------------
+
+Requirement: MANDATORY
+
+The device tree blob (dtb) must be no bigger than 2 megabytes in size
+and placed at a 2-megabyte boundary within the first 512 megabytes from
+the start of the kernel image. This is to allow the kernel to map the
+blob using a single section mapping in the initial page tables.
+
+
+3. Decompress the kernel image
+------------------------------
+
+Requirement: OPTIONAL
+
+The AArch64 kernel does not currently provide a decompressor and
+therefore requires decompression (gzip etc.) to be performed by the boot
+loader if a compressed Image target (e.g. Image.gz) is used.  For
+bootloaders that do not implement this requirement, the uncompressed
+Image target is available instead.
+
+
+4. Call the kernel image
+------------------------
+
+Requirement: MANDATORY
+
+The decompressed kernel image contains a 32-byte header as follows:
+
+  u32 magic	= 0x14000008;	/* branch to stext, little-endian */
+  u32 res0	= 0;		/* reserved */
+  u64 text_offset;		/* Image load offset */
+  u64 res1	= 0;		/* reserved */
+  u64 res2	= 0;		/* reserved */
+
+The image must be placed at the specified offset (currently 0x80000)
+from the start of the system RAM and called there. The start of the
+system RAM must be aligned to 2MB.
+
+Before jumping into the kernel, the following conditions must be met:
+
+- Quiesce all DMA capable devices so that memory does not get
+  corrupted by bogus network packets or disk data.  This will save
+  you many hours of debug.
+
+- Primary CPU general-purpose register settings
+  x0 = physical address of device tree blob (dtb) in system RAM.
+  x1 = 0 (reserved for future use)
+  x2 = 0 (reserved for future use)
+  x3 = 0 (reserved for future use)
+
+- CPU mode
+  All forms of interrupts must be masked in PSTATE.DAIF (Debug, SError,
+  IRQ and FIQ).
+  The CPU must be in either EL2 (RECOMMENDED in order to have access to
+  the virtualisation extensions) or non-secure EL1.
+
+- Caches, MMUs
+  The MMU must be off.
+  Instruction cache may be on or off.
+  Data cache must be off and invalidated.
+  External caches (if present) must be configured and disabled.
+
+- Architected timers
+  CNTFRQ must be programmed with the timer frequency.
+  If entering the kernel at EL1, CNTHCTL_EL2 must have EL1PCTEN (bit 0)
+  set where available.
+
+- Coherency
+  All CPUs to be booted by the kernel must be part of the same coherency
+  domain on entry to the kernel.  This may require IMPLEMENTATION DEFINED
+  initialisation to enable the receiving of maintenance operations on
+  each CPU.
+
+- System registers
+  All writable architected system registers at the exception level where
+  the kernel image will be entered must be initialised by software at a
+  higher exception level to prevent execution in an UNKNOWN state.
+
+The boot loader is expected to enter the kernel on each CPU in the
+following manner:
+
+- The primary CPU must jump directly to the first instruction of the
+  kernel image.  The device tree blob passed by this CPU must contain
+  for each CPU node:
+
+    1. An 'enable-method' property. Currently, the only supported value
+       for this field is the string "spin-table".
+
+    2. A 'cpu-release-addr' property identifying a 64-bit,
+       zero-initialised memory location.
+
+  It is expected that the bootloader will generate these device tree
+  properties and insert them into the blob prior to kernel entry.
+
+- Any secondary CPUs must spin outside of the kernel in a reserved area
+  of memory (communicated to the kernel by a /memreserve/ region in the
+  device tree) polling their cpu-release-addr location, which must be
+  contained in the reserved region.  A wfe instruction may be inserted
+  to reduce the overhead of the busy-loop and a sev will be issued by
+  the primary CPU.  When a read of the location pointed to by the
+  cpu-release-addr returns a non-zero value, the CPU must jump directly
+  to this value.
+
+- Secondary CPU general-purpose register settings
+  x0 = 0 (reserved for future use)
+  x1 = 0 (reserved for future use)
+  x2 = 0 (reserved for future use)
+  x3 = 0 (reserved for future use)
diff --git a/arch/arm64/include/asm/setup.h b/arch/arm64/include/asm/setup.h
new file mode 100644
index 0000000..9cf2e46
--- /dev/null
+++ b/arch/arm64/include/asm/setup.h
@@ -0,0 +1,26 @@
+/*
+ * Based on arch/arm/include/asm/setup.h
+ *
+ * Copyright (C) 1997-1999 Russell King
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
+#ifndef __ASM_SETUP_H
+#define __ASM_SETUP_H
+
+#include <linux/types.h>
+
+#define COMMAND_LINE_SIZE	2048
+
+#endif
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
new file mode 100644
index 0000000..b158f17
--- /dev/null
+++ b/arch/arm64/kernel/head.S
@@ -0,0 +1,510 @@
+/*
+ * Low-level CPU initialisation
+ * Based on arch/arm/kernel/head.S
+ *
+ * Copyright (C) 1994-2002 Russell King
+ * Copyright (C) 2003-2012 ARM Ltd.
+ * Authors:	Catalin Marinas <catalin.marinas@arm.com>
+ *		Will Deacon <will.deacon@arm.com>
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
+
+#include <linux/linkage.h>
+#include <linux/init.h>
+
+#include <asm/assembler.h>
+#include <asm/ptrace.h>
+#include <asm/asm-offsets.h>
+#include <asm/memory.h>
+#include <asm/thread_info.h>
+#include <asm/pgtable-hwdef.h>
+#include <asm/pgtable.h>
+#include <asm/page.h>
+
+/*
+ * swapper_pg_dir is the virtual address of the initial page table. We place
+ * the page tables 3 * PAGE_SIZE below KERNEL_RAM_VADDR. The idmap_pg_dir has
+ * 2 pages and is placed below swapper_pg_dir.
+ */
+#define KERNEL_RAM_VADDR	(PAGE_OFFSET + TEXT_OFFSET)
+
+#if (KERNEL_RAM_VADDR & 0xfffff) != 0x80000
+#error KERNEL_RAM_VADDR must start at 0xXXX80000
+#endif
+
+#define SWAPPER_DIR_SIZE	(3 * PAGE_SIZE)
+#define IDMAP_DIR_SIZE		(2 * PAGE_SIZE)
+
+	.globl	swapper_pg_dir
+	.equ	swapper_pg_dir, KERNEL_RAM_VADDR - SWAPPER_DIR_SIZE
+
+	.globl	idmap_pg_dir
+	.equ	idmap_pg_dir, swapper_pg_dir - IDMAP_DIR_SIZE
+
+	.macro	pgtbl, ttb0, ttb1, phys
+	add	\ttb1, \phys, #TEXT_OFFSET - SWAPPER_DIR_SIZE
+	sub	\ttb0, \ttb1, #IDMAP_DIR_SIZE
+	.endm
+
+#ifdef CONFIG_ARM64_64K_PAGES
+#define BLOCK_SHIFT	PAGE_SHIFT
+#define BLOCK_SIZE	PAGE_SIZE
+#else
+#define BLOCK_SHIFT	SECTION_SHIFT
+#define BLOCK_SIZE	SECTION_SIZE
+#endif
+
+#define KERNEL_START	KERNEL_RAM_VADDR
+#define KERNEL_END	_end
+
+/*
+ * Initial memory map attributes.
+ */
+#ifndef CONFIG_SMP
+#define PTE_FLAGS	PTE_ATTRINDX(MT_NORMAL) | PTE_AF
+#define PMD_FLAGS	PMD_ATTRINDX(MT_NORMAL) | PMD_SECT_AF
+#else
+#define PTE_FLAGS	PTE_ATTRINDX(MT_NORMAL) | PTE_AF | PTE_SHARED
+#define PMD_FLAGS	PMD_ATTRINDX(MT_NORMAL) | PMD_SECT_AF | PMD_SECT_S
+#endif
+
+#ifdef CONFIG_ARM64_64K_PAGES
+#define MM_MMUFLAGS	PTE_TYPE_PAGE | PTE_FLAGS
+#define IO_MMUFLAGS	PTE_TYPE_PAGE | PTE_XN | PTE_FLAGS
+#else
+#define MM_MMUFLAGS	PMD_TYPE_SECT | PMD_FLAGS
+#define IO_MMUFLAGS	PMD_TYPE_SECT | PMD_SECT_XN | PMD_FLAGS
+#endif
+
+/*
+ * Kernel startup entry point.
+ * ---------------------------
+ *
+ * The requirements are:
+ *   MMU = off, D-cache = off, I-cache = on or off,
+ *   x0 = physical address to the FDT blob.
+ *
+ * This code is mostly position independent so you call this at
+ * __pa(PAGE_OFFSET + TEXT_OFFSET).
+ *
+ * Note that the callee-saved registers are used for storing variables
+ * that are useful before the MMU is enabled. The allocations are described
+ * in the entry routines.
+ */
+	__HEAD
+
+	/*
+	 * DO NOT MODIFY. Image header expected by Linux boot-loaders.
+	 */
+	b	stext				// branch to kernel start, magic
+	.long	0				// reserved
+	.quad	TEXT_OFFSET			// Image load offset from start of RAM
+	.quad	0				// reserved
+	.quad	0				// reserved
+
+ENTRY(stext)
+	mov	x21, x0				// x21=FDT
+	bl	el2_setup			// Drop to EL1
+	mrs	x22, midr_el1			// x22=cpuid
+	mov	x0, x22
+	bl	lookup_processor_type
+	mov	x23, x0				// x23=current cpu_table
+	cbz	x23, __error_p			// invalid processor (x23=0)?
+	bl	__calc_phys_offset		// x24=PHYS_OFFSET, x28=PHYS_OFFSET-PAGE_OFFSET
+	bl	__vet_fdt
+	bl	__create_page_tables		// x25=TTBR0, x26=TTBR1
+	/*
+	 * The following calls CPU specific code in a position independent
+	 * manner. See arch/arm64/mm/proc.S for details. x23 = base of
+	 * cpu_info structure selected by lookup_processor_type above.
+	 * On return, the CPU will be ready for the MMU to be turned on and
+	 * the TCR will have been set.
+	 */
+	ldr	x27, __switch_data		// address to jump to after
+						// MMU has been enabled
+	adr	lr, __enable_mmu		// return (PIC) address
+	ldr	x12, [x23, #CPU_INFO_SETUP]
+	add	x12, x12, x28			// __virt_to_phys
+	br	x12				// initialise processor
+ENDPROC(stext)
+
+/*
+ * If we're fortunate enough to boot at EL2, ensure that the world is
+ * sane before dropping to EL1.
+ */
+ENTRY(el2_setup)
+	mrs	x0, CurrentEL
+	cmp	x0, #PSR_MODE_EL2t
+	ccmp	x0, #PSR_MODE_EL2h, #0x4, ne
+	b.eq	1f
+	ret
+
+	/* Hyp configuration. */
+1:	mov	x0, #(1 << 31)			// 64-bit EL1
+	msr	hcr_el2, x0
+
+	/* Generic timers. */
+	mrs	x0, cnthctl_el2
+	orr	x0, x0, #3			// Enable EL1 physical timers
+	msr	cnthctl_el2, x0
+
+	/* Populate ID registers. */
+	mrs	x0, midr_el1
+	mrs	x1, mpidr_el1
+	msr	vpidr_el2, x0
+	msr	vmpidr_el2, x1
+
+	/* sctlr_el1 */
+	mov	x0, #0x0800			// Set/clear RES{1,0} bits
+	movk	x0, #0x30d0, lsl #16
+	msr	sctlr_el1, x0
+
+	/* Coprocessor traps. */
+	mov	x0, #0x33ff
+	msr	cptr_el2, x0			// Disable copro. traps to EL2
+
+#ifdef CONFIG_COMPAT
+	msr	hstr_el2, xzr			// Disable CP15 traps to EL2
+#endif
+
+	/* spsr */
+	mov	x0, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
+		      PSR_MODE_EL1h)
+	msr	spsr_el2, x0
+	msr	elr_el2, lr
+	eret
+ENDPROC(el2_setup)
+
+	.align	3
+2:	.quad	.
+	.quad	PAGE_OFFSET
+
+#ifdef CONFIG_SMP
+	.pushsection    .smp.pen.text, "ax"
+	.align	3
+1:	.quad	.
+	.quad	secondary_holding_pen_release
+
+	/*
+	 * This provides a "holding pen" for platforms to hold all secondary
+	 * cores are held until we're ready for them to initialise.
+	 */
+ENTRY(secondary_holding_pen)
+	bl	el2_setup			// Drop to EL1
+	mrs	x0, mpidr_el1
+	and	x0, x0, #15			// CPU number
+	adr	x1, 1b
+	ldp	x2, x3, [x1]
+	sub	x1, x1, x2
+	add	x3, x3, x1
+pen:	ldr	x4, [x3]
+	cmp	x4, x0
+	b.eq	secondary_startup
+	wfe
+	b	pen
+ENDPROC(secondary_holding_pen)
+	.popsection
+
+ENTRY(secondary_startup)
+	/*
+	 * Common entry point for secondary CPUs.
+	 */
+	mrs	x22, midr_el1			// x22=cpuid
+	mov	x0, x22
+	bl	lookup_processor_type
+	mov	x23, x0				// x23=current cpu_table
+	cbz	x23, __error_p			// invalid processor (x23=0)?
+
+	bl	__calc_phys_offset		// x24=phys offset
+	pgtbl	x25, x26, x24			// x25=TTBR0, x26=TTBR1
+	ldr	x12, [x23, #CPU_INFO_SETUP]
+	add	x12, x12, x28			// __virt_to_phys
+	blr	x12				// initialise processor
+
+	ldr	x21, =secondary_data
+	ldr	x27, =__secondary_switched	// address to jump to after enabling the MMU
+	b	__enable_mmu
+ENDPROC(secondary_startup)
+
+ENTRY(__secondary_switched)
+	ldr	x0, [x21]			// get secondary_data.stack
+	mov	sp, x0
+	mov	x29, #0
+	b	secondary_start_kernel
+ENDPROC(__secondary_switched)
+#endif	/* CONFIG_SMP */
+
+/*
+ * Setup common bits before finally enabling the MMU. Essentially this is just
+ * loading the page table pointer and vector base registers.
+ *
+ * On entry to this code, x0 must contain the SCTLR_EL1 value for turning on
+ * the MMU.
+ */
+__enable_mmu:
+	ldr	x5, =vectors
+	msr	vbar_el1, x5
+	msr	ttbr0_el1, x25			// load TTBR0
+	msr	ttbr1_el1, x26			// load TTBR1
+	isb
+	b	__turn_mmu_on
+ENDPROC(__enable_mmu)
+
+/*
+ * Enable the MMU. This completely changes the structure of the visible memory
+ * space. You will not be able to trace execution through this.
+ *
+ *  x0  = system control register
+ *  x27 = *virtual* address to jump to upon completion
+ *
+ * other registers depend on the function called upon completion
+ */
+	.align	6
+__turn_mmu_on:
+	msr	sctlr_el1, x0
+	isb
+	br	x27
+ENDPROC(__turn_mmu_on)
+
+/*
+ * Calculate the start of physical memory.
+ */
+__calc_phys_offset:
+	adr	x0, 1f
+	ldp	x1, x2, [x0]
+	sub	x28, x0, x1			// x28 = PHYS_OFFSET - PAGE_OFFSET
+	add	x24, x2, x28			// x24 = PHYS_OFFSET
+	ret
+ENDPROC(__calc_phys_offset)
+
+	.align 3
+1:	.quad	.
+	.quad	PAGE_OFFSET
+
+/*
+ * Macro to populate the PGD for the corresponding block entry in the next
+ * level (tbl) for the given virtual address.
+ *
+ * Preserves:	pgd, tbl, virt
+ * Corrupts:	tmp1, tmp2
+ */
+	.macro	create_pgd_entry, pgd, tbl, virt, tmp1, tmp2
+	lsr	\tmp1, \virt, #PGDIR_SHIFT
+	and	\tmp1, \tmp1, #PTRS_PER_PGD - 1	// PGD index
+	orr	\tmp2, \tbl, #3			// PGD entry table type
+	str	\tmp2, [\pgd, \tmp1, lsl #3]
+	.endm
+
+/*
+ * Macro to populate block entries in the page table for the start..end
+ * virtual range (inclusive).
+ *
+ * Preserves:	tbl, flags
+ * Corrupts:	phys, start, end, pstate
+ */
+	.macro	create_block_map, tbl, flags, phys, start, end, idmap=0
+	lsr	\phys, \phys, #BLOCK_SHIFT
+	.if	\idmap
+	and	\start, \phys, #PTRS_PER_PTE - 1	// table index
+	.else
+	lsr	\start, \start, #BLOCK_SHIFT
+	and	\start, \start, #PTRS_PER_PTE - 1	// table index
+	.endif
+	orr	\phys, \flags, \phys, lsl #BLOCK_SHIFT	// table entry
+	.ifnc	\start,\end
+	lsr	\end, \end, #BLOCK_SHIFT
+	and	\end, \end, #PTRS_PER_PTE - 1		// table end index
+	.endif
+9999:	str	\phys, [\tbl, \start, lsl #3]		// store the entry
+	.ifnc	\start,\end
+	add	\start, \start, #1			// next entry
+	add	\phys, \phys, #BLOCK_SIZE		// next block
+	cmp	\start, \end
+	b.ls	9999b
+	.endif
+	.endm
+
+/*
+ * Setup the initial page tables. We only setup the barest amount which is
+ * required to get the kernel running. The following sections are required:
+ *   - identity mapping to enable the MMU (low address, TTBR0)
+ *   - first few MB of the kernel linear mapping to jump to once the MMU has
+ *     been enabled, including the FDT blob (TTBR1)
+ */
+__create_page_tables:
+	pgtbl	x25, x26, x24			// idmap_pg_dir and swapper_pg_dir addresses
+
+	/*
+	 * Clear the idmap and swapper page tables.
+	 */
+	mov	x0, x25
+	add	x6, x26, #SWAPPER_DIR_SIZE
+1:	stp	xzr, xzr, [x0], #16
+	stp	xzr, xzr, [x0], #16
+	stp	xzr, xzr, [x0], #16
+	stp	xzr, xzr, [x0], #16
+	cmp	x0, x6
+	b.lo	1b
+
+	ldr	x7, =MM_MMUFLAGS
+
+	/*
+	 * Create the identity mapping.
+	 */
+	add	x0, x25, #PAGE_SIZE		// section table address
+	adr	x3, __turn_mmu_on		// virtual/physical address
+	create_pgd_entry x25, x0, x3, x5, x6
+	create_block_map x0, x7, x3, x5, x5, idmap=1
+
+	/*
+	 * Map the kernel image (starting with PHYS_OFFSET).
+	 */
+	add	x0, x26, #PAGE_SIZE		// section table address
+	mov	x5, #PAGE_OFFSET
+	create_pgd_entry x26, x0, x5, x3, x6
+	ldr	x6, =KERNEL_END - 1
+	mov	x3, x24				// phys offset
+	create_block_map x0, x7, x3, x5, x6
+
+	/*
+	 * Map the FDT blob (maximum 2MB; must be within 512MB of
+	 * PHYS_OFFSET).
+	 */
+	mov	x3, x21				// FDT phys address
+	and	x3, x3, #~((1 << 21) - 1)	// 2MB aligned
+	mov	x6, #PAGE_OFFSET
+	sub	x5, x3, x24			// subtract PHYS_OFFSET
+	tst	x5, #~((1 << 29) - 1)		// within 512MB?
+	csel	x21, xzr, x21, ne		// zero the FDT pointer
+	b.ne	1f
+	add	x5, x5, x6			// __va(FDT blob)
+	add	x6, x5, #1 << 21		// 2MB for the FDT blob
+	sub	x6, x6, #1			// inclusive range
+	create_block_map x0, x7, x3, x5, x6
+1:
+	ret
+ENDPROC(__create_page_tables)
+	.ltorg
+
+	.align	3
+	.type	__switch_data, %object
+__switch_data:
+	.quad	__mmap_switched
+	.quad	__data_loc			// x4
+	.quad	_data				// x5
+	.quad	__bss_start			// x6
+	.quad	_end				// x7
+	.quad	processor_id			// x4
+	.quad	__fdt_pointer			// x5
+	.quad	memstart_addr			// x6
+	.quad	init_thread_union + THREAD_START_SP // sp
+
+/*
+ * The following fragment of code is executed with the MMU on in MMU mode, and
+ * uses absolute addresses; this is not position independent.
+ */
+__mmap_switched:
+	adr	x3, __switch_data + 8
+
+	ldp	x4, x5, [x3], #16
+	ldp	x6, x7, [x3], #16
+	cmp	x4, x5				// Copy data segment if needed
+1:	ccmp	x5, x6, #4, ne
+	b.eq	2f
+	ldr	x16, [x4], #8
+	str	x16, [x5], #8
+	b	1b
+2:
+1:	cmp	x6, x7
+	b.hs	2f
+	str	xzr, [x6], #8			// Clear BSS
+	b	1b
+2:
+	ldp	x4, x5, [x3], #16
+	ldr	x6, [x3], #8
+	ldr	x16, [x3]
+	mov	sp, x16
+	str	x22, [x4]			// Save processor ID
+	str	x21, [x5]			// Save FDT pointer
+	str	x24, [x6]			// Save PHYS_OFFSET
+	mov	x29, #0
+	b	start_kernel
+ENDPROC(__mmap_switched)
+
+/*
+ * Exception handling. Something went wrong and we can't proceed. We ought to
+ * tell the user, but since we don't have any guarantee that we're even
+ * running on the right architecture, we do virtually nothing.
+ */
+__error_p:
+ENDPROC(__error_p)
+
+__error:
+1:	nop
+	b	1b
+ENDPROC(__error)
+
+/*
+ * This function gets the processor ID in w0 and searches the cpu_table[] for
+ * a match. It returns a pointer to the struct cpu_info it found. The
+ * cpu_table[] must end with an empty (all zeros) structure.
+ *
+ * This routine can be called via C code and it needs to work with the MMU
+ * both disabled and enabled (the offset is calculated automatically).
+ */
+ENTRY(lookup_processor_type)
+	adr	x1, __lookup_processor_type_data
+	ldp	x2, x3, [x1]
+	sub	x1, x1, x2			// get offset between VA and PA
+	add	x3, x3, x1			// convert VA to PA
+1:
+	ldp	w5, w6, [x3]			// load cpu_id_val and cpu_id_mask
+	cbz	w5, 2f				// end of list?
+	and	w6, w6, w0
+	cmp	w5, w6
+	b.eq	3f
+	add	x3, x3, #CPU_INFO_SZ
+	b	1b
+2:
+	mov	x3, #0				// unknown processor
+3:
+	mov	x0, x3
+	ret
+ENDPROC(lookup_processor_type)
+
+	.align	3
+	.type	__lookup_processor_type_data, %object
+__lookup_processor_type_data:
+	.quad	.
+	.quad	cpu_table
+	.size	__lookup_processor_type_data, . - __lookup_processor_type_data
+
+/*
+ * Determine validity of the x21 FDT pointer.
+ * The dtb must be 8-byte aligned and live in the first 512M of memory.
+ */
+__vet_fdt:
+	tst	x21, #0x7
+	b.ne	1f
+	cmp	x21, x24
+	b.lt	1f
+	mov	x0, #(1 << 29)
+	add	x0, x0, x24
+	cmp	x21, x0
+	b.ge	1f
+	ret
+1:
+	mov	x21, #0
+	ret
+ENDPROC(__vet_fdt)
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
new file mode 100644
index 0000000..79f2971
--- /dev/null
+++ b/arch/arm64/kernel/setup.c
@@ -0,0 +1,351 @@
+/*
+ * Based on arch/arm/kernel/setup.c
+ *
+ * Copyright (C) 1995-2001 Russell King
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
+
+#include <linux/export.h>
+#include <linux/kernel.h>
+#include <linux/stddef.h>
+#include <linux/ioport.h>
+#include <linux/delay.h>
+#include <linux/utsname.h>
+#include <linux/initrd.h>
+#include <linux/console.h>
+#include <linux/bootmem.h>
+#include <linux/seq_file.h>
+#include <linux/screen_info.h>
+#include <linux/init.h>
+#include <linux/kexec.h>
+#include <linux/crash_dump.h>
+#include <linux/root_dev.h>
+#include <linux/cpu.h>
+#include <linux/interrupt.h>
+#include <linux/smp.h>
+#include <linux/fs.h>
+#include <linux/proc_fs.h>
+#include <linux/memblock.h>
+#include <linux/of_fdt.h>
+
+#include <asm/cputype.h>
+#include <asm/elf.h>
+#include <asm/cputable.h>
+#include <asm/sections.h>
+#include <asm/setup.h>
+#include <asm/cacheflush.h>
+#include <asm/tlbflush.h>
+#include <asm/traps.h>
+#include <asm/memblock.h>
+
+extern void paging_init(void);
+
+unsigned int processor_id;
+EXPORT_SYMBOL(processor_id);
+
+unsigned int elf_hwcap __read_mostly;
+EXPORT_SYMBOL_GPL(elf_hwcap);
+
+static const char *cpu_name;
+static const char *machine_name;
+phys_addr_t __fdt_pointer __initdata;
+
+/*
+ * Standard memory resources
+ */
+static struct resource mem_res[] = {
+	{
+		.name = "Kernel code",
+		.start = 0,
+		.end = 0,
+		.flags = IORESOURCE_MEM
+	},
+	{
+		.name = "Kernel data",
+		.start = 0,
+		.end = 0,
+		.flags = IORESOURCE_MEM
+	}
+};
+
+#define kernel_code mem_res[0]
+#define kernel_data mem_res[1]
+
+void __init early_print(const char *str, ...)
+{
+	char buf[256];
+	va_list ap;
+
+	va_start(ap, str);
+	vsnprintf(buf, sizeof(buf), str, ap);
+	va_end(ap);
+
+	printk("%s", buf);
+}
+
+static void __init setup_processor(void)
+{
+	struct cpu_info *cpu_info;
+
+	/*
+	 * locate processor in the list of supported processor
+	 * types.  The linker builds this table for us from the
+	 * entries in arch/arm/mm/proc.S
+	 */
+	cpu_info = lookup_processor_type(read_cpuid_id());
+	if (!cpu_info) {
+		printk("CPU configuration botched (ID %08x), unable to continue.\n",
+		       read_cpuid_id());
+		while (1);
+	}
+
+	cpu_name = cpu_info->cpu_name;
+
+	printk("CPU: %s [%08x] revision %d\n",
+	       cpu_name, read_cpuid_id(), read_cpuid_id() & 15);
+
+	sprintf(init_utsname()->machine, "aarch64");
+	elf_hwcap = 0;
+
+	cpu_proc_init();
+}
+
+static void __init setup_machine_fdt(phys_addr_t dt_phys)
+{
+	struct boot_param_header *devtree;
+	unsigned long dt_root;
+
+	/* Check we have a non-NULL DT pointer */
+	if (!dt_phys) {
+		early_print("\n"
+			"Error: NULL or invalid device tree blob\n"
+			"The dtb must be 8-byte aligned and passed in the first 512MB of memory\n"
+			"\nPlease check your bootloader.\n");
+
+		while (true)
+			cpu_relax();
+
+	}
+
+	devtree = phys_to_virt(dt_phys);
+
+	/* Check device tree validity */
+	if (be32_to_cpu(devtree->magic) != OF_DT_HEADER) {
+		early_print("\n"
+			"Error: invalid device tree blob at physical address 0x%p (virtual address 0x%p)\n"
+			"Expected 0x%x, found 0x%x\n"
+			"\nPlease check your bootloader.\n",
+			dt_phys, devtree, OF_DT_HEADER,
+			be32_to_cpu(devtree->magic));
+
+		while (true)
+			cpu_relax();
+	}
+
+	initial_boot_params = devtree;
+	dt_root = of_get_flat_dt_root();
+
+	machine_name = of_get_flat_dt_prop(dt_root, "model", NULL);
+	if (!machine_name)
+		machine_name = of_get_flat_dt_prop(dt_root, "compatible", NULL);
+	if (!machine_name)
+		machine_name = "<unknown>";
+	pr_info("Machine: %s\n", machine_name);
+
+	/* Retrieve various information from the /chosen node */
+	of_scan_flat_dt(early_init_dt_scan_chosen, boot_command_line);
+	/* Initialize {size,address}-cells info */
+	of_scan_flat_dt(early_init_dt_scan_root, NULL);
+	/* Setup memory, calling early_init_dt_add_memory_arch */
+	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
+}
+
+void __init early_init_dt_add_memory_arch(u64 base, u64 size)
+{
+	size &= PAGE_MASK;
+	memblock_add(base, size);
+}
+
+void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
+{
+	return __va(memblock_alloc(size, align));
+}
+
+/*
+ * Limit the memory size that was specified via FDT.
+ */
+static int __init early_mem(char *p)
+{
+	phys_addr_t limit;
+
+	if (!p)
+		return 1;
+
+	limit = memparse(p, &p) & PAGE_MASK;
+	pr_notice("Memory limited to %lldMB\n", limit >> 20);
+
+	memblock_enforce_memory_limit(limit);
+
+	return 0;
+}
+early_param("mem", early_mem);
+
+static void __init request_standard_resources(void)
+{
+	struct memblock_region *region;
+	struct resource *res;
+
+	kernel_code.start   = virt_to_phys(_text);
+	kernel_code.end     = virt_to_phys(_etext - 1);
+	kernel_data.start   = virt_to_phys(_sdata);
+	kernel_data.end     = virt_to_phys(_end - 1);
+
+	for_each_memblock(memory, region) {
+		res = alloc_bootmem_low(sizeof(*res));
+		res->name  = "System RAM";
+		res->start = __pfn_to_phys(memblock_region_memory_base_pfn(region));
+		res->end = __pfn_to_phys(memblock_region_memory_end_pfn(region)) - 1;
+		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+
+		request_resource(&iomem_resource, res);
+
+		if (kernel_code.start >= res->start &&
+		    kernel_code.end <= res->end)
+			request_resource(res, &kernel_code);
+		if (kernel_data.start >= res->start &&
+		    kernel_data.end <= res->end)
+			request_resource(res, &kernel_data);
+	}
+}
+
+void __init setup_arch(char **cmdline_p)
+{
+	setup_processor();
+
+	setup_machine_fdt(__fdt_pointer);
+
+	init_mm.start_code = (unsigned long) _text;
+	init_mm.end_code   = (unsigned long) _etext;
+	init_mm.end_data   = (unsigned long) _edata;
+	init_mm.brk	   = (unsigned long) _end;
+
+	*cmdline_p = boot_command_line;
+
+	parse_early_param();
+
+	arm64_memblock_init();
+
+	paging_init();
+	request_standard_resources();
+
+	unflatten_device_tree();
+
+#ifdef CONFIG_SMP
+	smp_init_cpus();
+#endif
+
+#ifdef CONFIG_VT
+#if defined(CONFIG_VGA_CONSOLE)
+	conswitchp = &vga_con;
+#elif defined(CONFIG_DUMMY_CONSOLE)
+	conswitchp = &dummy_con;
+#endif
+#endif
+}
+
+static DEFINE_PER_CPU(struct cpu, cpu_data);
+
+static int __init topology_init(void)
+{
+	int i;
+
+	for_each_possible_cpu(i) {
+		struct cpu *cpu = &per_cpu(cpu_data, i);
+		cpu->hotpluggable = 1;
+		register_cpu(cpu, i);
+	}
+
+	return 0;
+}
+subsys_initcall(topology_init);
+
+static const char *hwcap_str[] = {
+	"fp",
+	"asimd",
+	NULL
+};
+
+static int c_show(struct seq_file *m, void *v)
+{
+	int i;
+
+	seq_printf(m, "Processor\t: %s rev %d (%s)\n",
+		   cpu_name, read_cpuid_id() & 15, ELF_PLATFORM);
+
+	for_each_online_cpu(i) {
+		/*
+		 * glibc reads /proc/cpuinfo to determine the number of
+		 * online processors, looking for lines beginning with
+		 * "processor".  Give glibc what it expects.
+		 */
+#ifdef CONFIG_SMP
+		seq_printf(m, "processor\t: %d\n", i);
+#endif
+		seq_printf(m, "BogoMIPS\t: %lu.%02lu\n\n",
+			   loops_per_jiffy / (500000UL/HZ),
+			   loops_per_jiffy / (5000UL/HZ) % 100);
+	}
+
+	/* dump out the processor features */
+	seq_puts(m, "Features\t: ");
+
+	for (i = 0; hwcap_str[i]; i++)
+		if (elf_hwcap & (1 << i))
+			seq_printf(m, "%s ", hwcap_str[i]);
+
+	seq_printf(m, "\nCPU implementer\t: 0x%02x\n", read_cpuid_id() >> 24);
+	seq_printf(m, "CPU architecture: AArch64\n");
+	seq_printf(m, "CPU variant\t: 0x%x\n", (read_cpuid_id() >> 20) & 15);
+	seq_printf(m, "CPU part\t: 0x%03x\n", (read_cpuid_id() >> 4) & 0xfff);
+	seq_printf(m, "CPU revision\t: %d\n", read_cpuid_id() & 15);
+
+	seq_puts(m, "\n");
+
+	seq_printf(m, "Hardware\t: %s\n", machine_name);
+
+	return 0;
+}
+
+static void *c_start(struct seq_file *m, loff_t *pos)
+{
+	return *pos < 1 ? (void *)1 : NULL;
+}
+
+static void *c_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	++*pos;
+	return NULL;
+}
+
+static void c_stop(struct seq_file *m, void *v)
+{
+}
+
+const struct seq_operations cpuinfo_op = {
+	.start	= c_start,
+	.next	= c_next,
+	.stop	= c_stop,
+	.show	= c_show
+};

