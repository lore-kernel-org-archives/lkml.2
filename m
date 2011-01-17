Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1AQIf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 03:35:29 -0500
Received: from mail.windriver.com ([147.11.1.11]:50282 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab1AQIfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 03:35:13 -0500
From: "Stanley.Miao" <stanley.miao@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/3] Add ARM kernel debug macros for locating the boot problems quickly
Date: Mon, 17 Jan 2011 16:42:09 +0800
Message-Id: <1295253729-23153-4-git-send-email-stanley.miao@windriver.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1295253729-23153-1-git-send-email-stanley.miao@windriver.com>
References: <1295253729-23153-1-git-send-email-stanley.miao@windriver.com>
X-OriginalArrivalTime: 17 Jan 2011 08:35:02.0716 (UTC) FILETIME=[6F44FFC0:01CBB621]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we are porting Linux to a new board, we ofter encounter the problems
that the board can't boot up and there is no any messages output in
console. These debug macros can help the developers print registers' value
or messages easily and locate the root cause quickly.

All these debug macros are under CONFIG_DEBUG_LL. When CONFIG_DEBUG_LL is
enabled, the following messages will be printed in the boot procedure.

Uncompressing Linux... done, booting the kernel.
r13:005454ec
stext enter.
__lookup_processor_type enter.
__lookup_machine_type enter.
__vet_atags enter.
__create_page_tables enter.
__enable_mmu enter.
__mmap_switched enter.
__lookup_processor_type enter.
__lookup_machine_type enter.
secondary_startup enter.
__lookup_processor_type enter.
__enable_mmu enter.
__secondary_switched enter.
Linux version 2.6.38.rc1 ...

Signed-off-by: Stanley.Miao <stanley.miao@windriver.com>
---
 arch/arm/kernel/debug_macro.S |   88 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/head-common.S |    8 ++++
 arch/arm/kernel/head.S        |   19 +++++++--
 arch/arm/kernel/vmlinux.lds.S |    7 +++
 4 files changed, 118 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm/kernel/debug_macro.S

diff --git a/arch/arm/kernel/debug_macro.S b/arch/arm/kernel/debug_macro.S
new file mode 100644
index 0000000..033acf3
--- /dev/null
+++ b/arch/arm/kernel/debug_macro.S
@@ -0,0 +1,88 @@
+/*
+ *  linux/arch/arm/kernel/debug_macro.S
+ *
+ *  Copyright (c) 2011 Wind River Systems, Inc.
+ *  Stanley.Miao <stanley.miao@windriver.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ *  32-bit debugging code
+ */
+
+#ifdef CONFIG_DEBUG_LL
+
+	.macro  kputc,val
+	mov     r0, \val
+	bl      printch
+	.endm
+
+	.macro	dbgmsg, str
+	stmfd   sp!, {r0-r3, lr}
+	adr	r0, \str
+	bl	printascii
+	ldmfd   sp!, {r0-r3, lr}
+	.endm
+
+	.macro  read_reg reg, num
+	stmfd	sp!, {r0-r4, lr}
+	kputc	#'r'
+	mov	r4, #\num
+	cmp	r4, #10
+	blt	901f
+	sub	r4, r4, #10
+	kputc	#'1'
+901:	add	r0, r4, #'0'
+	bl	printch
+	kputc   #':'
+	ldmfd	sp, {r0-r4, lr}
+	mov     r0, \reg
+	bl      printhex8
+	kputc   #'\n'
+	ldmfd   sp!, {r0-r4, lr}
+	.endm
+
+	.macro	PRINT_SCTLR
+	stmfd	sp!, {r0-r4, lr}
+	kputc	#'S'
+	kputc	#'C'
+	kputc	#'T'
+	kputc	#'L'
+	kputc	#'R'
+	kputc	#':'
+	mrc	p15, 0, r0, c1, c0, 0
+	bl	printhex8
+	kputc	#'\n'
+	ldmfd   sp!, {r0-r4, lr}
+	.endm
+
+	.macro	PRINT_CPSR
+	stmfd	sp!, {r0-r4, lr}
+	kputc	#'C'
+	kputc	#'P'
+	kputc	#'S'
+	kputc	#'R'
+	kputc	#':'
+	mrs	r0, cpsr
+	bl	printhex8
+	kputc	#'\n'
+	ldmfd   sp!, {r0-r4, lr}
+	.endm
+
+#define DBG_MSG(x)	dbgmsg dbg_##x
+#define PRINT_REG(x)	read_reg r##x, x
+
+#undef ENDPROC
+#define ENDPROC(name) \
+	.type name, %function; \
+		END(name); \
+	dbg_##name:; \
+	.ascii #name; \
+	.asciz " enter.\n"; \
+	.align 2
+
+#else
+#define DBG_MSG(x)
+#define PRINT_REG(x)
+#endif
diff --git a/arch/arm/kernel/head-common.S b/arch/arm/kernel/head-common.S
index 37cfa88..f916bb8 100644
--- a/arch/arm/kernel/head-common.S
+++ b/arch/arm/kernel/head-common.S
@@ -74,6 +74,7 @@ str_a3:	.asciz	"\nPlease check your kernel config and/or bootloader.\n"
  *  r5 = mach_info pointer in physical address space
  */
 __lookup_machine_type:
+	DBG_MSG(__lookup_machine_type)
 	adr	r3, __lookup_machine_type_data
 	ldmia	r3, {r4, r5, r6}
 	sub	r3, r3, r4			@ get offset between virt&phys
@@ -114,6 +115,7 @@ __lookup_machine_type_data:
  *  r5, r6 corrupted
  */
 __vet_atags:
+	DBG_MSG(__vet_atags)
 	tst	r2, #0x3			@ aligned?
 	bne	1f
 
@@ -149,6 +151,7 @@ ENDPROC(__vet_atags)
  */
 	__INIT
 __mmap_switched:
+	DBG_MSG(__mmap_switched)
 	adr	r3, __mmap_switched_data
 
 	ldmia	r3!, {r4, r5, r6, r7}
@@ -225,6 +228,7 @@ ENDPROC(lookup_processor_type)
  */
 	__CPUINIT
 __lookup_processor_type:
+	DBG_MSG(__lookup_processor_type)
 	adr	r3, __lookup_processor_type_data
 	ldmia	r3, {r4 - r6}
 	sub	r3, r3, r4			@ get offset between virt&phys
@@ -284,3 +288,7 @@ __error:
 1:	mov	r0, r0
 	b	1b
 ENDPROC(__error)
+
+		.align
+		.section ".boot.stack", "aw"
+boot_stack:	.space 512
diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index dd6b369..bde50cd 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -33,6 +33,7 @@
 #define KERNEL_RAM_VADDR	(PAGE_OFFSET + TEXT_OFFSET)
 #define KERNEL_RAM_PADDR	(PHYS_OFFSET + TEXT_OFFSET)
 
+#include "debug_macro.S"
 
 /*
  * swapper_pg_dir is the virtual address of the initial page table.
@@ -82,6 +83,9 @@
 ENTRY(stext)
 	setmode	PSR_F_BIT | PSR_I_BIT | SVC_MODE, r9 @ ensure svc mode
 						@ and irqs disabled
+	ldr	r13, =(__stack_end - PAGE_OFFSET + PHYS_OFFSET)
+	PRINT_REG(13)
+	DBG_MSG(stext)
 	mrc	p15, 0, r9, c0, c0		@ get processor id
 	bl	__lookup_processor_type		@ r5=procinfo r9=cpuid
 	movs	r10, r5				@ invalid processor (r5=0)?
@@ -102,8 +106,8 @@ ENTRY(stext)
 	 * above.  On return, the CPU will be ready for the MMU to be
 	 * turned on, and r0 will hold the CPU control register value.
 	 */
-	ldr	r13, =__mmap_switched		@ address to jump to after
-						@ mmu has been enabled
+	ldr	r0, =__mmap_switched		@ address to jump to after
+	str	r0, [r13, #-4]!			@ mmu has been enabled
 	adr	lr, BSYM(1f)			@ return (PIC) address
  ARM(	add	pc, r10, #PROCINFO_INITFUNC	)
  THUMB(	add	r12, r10, #PROCINFO_INITFUNC	)
@@ -126,6 +130,7 @@ ENDPROC(stext)
  *  r4 = physical page table address
  */
 __create_page_tables:
+	DBG_MSG(__create_page_tables)
 	pgtbl	r4				@ page table address
 
 	/*
@@ -278,6 +283,8 @@ ENTRY(secondary_startup)
 	 * as it has already been validated by the primary processor.
 	 */
 	setmode	PSR_F_BIT | PSR_I_BIT | SVC_MODE, r9
+	ldr	r13, =(__stack_end - PAGE_OFFSET + PHYS_OFFSET)
+	DBG_MSG(secondary_startup)
 	mrc	p15, 0, r9, c0, c0		@ get processor id
 	bl	__lookup_processor_type
 	movs	r10, r5				@ invalid processor?
@@ -292,7 +299,7 @@ ENTRY(secondary_startup)
 	sub	r4, r4, r5			@ mmu has been enabled
 	ldr	r4, [r7, r4]			@ get secondary_data.pgdir
 	adr	lr, BSYM(__enable_mmu)		@ return address
-	mov	r13, r12			@ __secondary_switched address
+	str	r12, [r13, #-4]!		@ __secondary_switched address
  ARM(	add	pc, r10, #PROCINFO_INITFUNC	) @ initialise processor
 						  @ (return control reg)
  THUMB(	add	r12, r10, #PROCINFO_INITFUNC	)
@@ -303,6 +310,7 @@ ENDPROC(secondary_startup)
 	 * r6  = &secondary_data
 	 */
 ENTRY(__secondary_switched)
+	DBG_MSG(__secondary_switched)
 	ldr	sp, [r7, #4]			@ get secondary_data.stack
 	mov	fp, #0
 	b	secondary_start_kernel
@@ -330,6 +338,7 @@ __secondary_data:
  *  r13 = *virtual* address to jump to upon completion
  */
 __enable_mmu:
+	DBG_MSG(__enable_mmu)
 #ifdef CONFIG_ALIGNMENT_TRAP
 	orr	r0, r0, #CR_A
 #else
@@ -373,7 +382,9 @@ __turn_mmu_on:
 	mcr	p15, 0, r0, c1, c0, 0		@ write control reg
 	mrc	p15, 0, r3, c0, c0, 0		@ read id reg
 	mov	r3, r3
-	mov	r3, r13
+	sub	r13, r13, #PHYS_OFFSET
+	add	r13, r13, #PAGE_OFFSET
+	ldr	r3, [r13], #4
 	mov	pc, r3
 __enable_mmu_end:
 ENDPROC(__turn_mmu_on)
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index cead889..5030bc0 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -246,6 +246,13 @@ SECTIONS
 #endif
 
 	BSS_SECTION(0, 0, 0)
+	.stack : {
+		. = ALIGN(4);
+		__stack_start = .;
+		*(.boot.stack)
+		. = ALIGN(4);
+		__stack_end = .;
+	}
 	_end = .;
 
 	STABS_DEBUG
-- 
1.5.4.3

