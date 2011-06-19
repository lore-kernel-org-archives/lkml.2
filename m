Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab1FSLpa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 07:45:30 -0400
Received: from mail.southpole.se ([193.12.106.18]:37738 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab1FSLpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 07:45:08 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 01/19] OpenRISC: Boot code
Date: Sun, 19 Jun 2011 13:43:27 +0200
Message-Id: <1308483825-6023-2-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308483825-6023-1-git-send-email-jonas@southpole.se>
References: <1308483825-6023-1-git-send-email-jonas@southpole.se>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Architecture code and early setup routines for booting Linux.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/openrisc/kernel/entry.S     | 1134 +++++++++++++++++++++++++++
 arch/openrisc/kernel/head.S      | 1607 ++++++++++++++++++++++++++++++++++++++
 arch/openrisc/kernel/init_task.c |   41 +
 arch/openrisc/kernel/setup.c     |  393 ++++++++++
 4 files changed, 3175 insertions(+), 0 deletions(-)
 create mode 100644 arch/openrisc/kernel/entry.S
 create mode 100644 arch/openrisc/kernel/head.S
 create mode 100644 arch/openrisc/kernel/init_task.c
 create mode 100644 arch/openrisc/kernel/setup.c

diff --git a/arch/openrisc/kernel/entry.S b/arch/openrisc/kernel/entry.S
new file mode 100644
index 0000000..7a967cb
--- /dev/null
+++ b/arch/openrisc/kernel/entry.S
@@ -0,0 +1,1134 @@
+/*
+ * OpenRISC entry.S
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * Modifications for the OpenRISC architecture:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2005 Gyorgy Jeney <nog@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/linkage.h>
+
+#include <asm/processor.h>
+#include <asm/unistd.h>
+#include <asm/thread_info.h>
+#include <asm/errno.h>
+#include <asm/spr_defs.h>
+#include <asm/page.h>
+#include <asm/mmu.h>
+#include <asm/pgtable.h>
+#include <asm/asm-offsets.h>
+
+#define DISABLE_INTERRUPTS(t1,t2)			\
+	l.mfspr t2,r0,SPR_SR				;\
+	l.movhi	t1,hi(~(SPR_SR_IEE|SPR_SR_TEE))		;\
+	l.ori	t1,t1,lo(~(SPR_SR_IEE|SPR_SR_TEE))	;\
+	l.and   t2,t2,t1				;\
+	l.mtspr r0,t2,SPR_SR
+
+#define ENABLE_INTERRUPTS(t1)				\
+	l.mfspr	t1,r0,SPR_SR				;\
+	l.ori	t1,t1,lo(SPR_SR_IEE|SPR_SR_TEE)		;\
+	l.mtspr	r0,t1,SPR_SR
+
+/* =========================================================[ macros ]=== */
+
+/*
+ * We need to disable interrupts at beginning of RESTORE_ALL
+ * since interrupt might come in after we've loaded EPC return address
+ * and overwrite EPC with address somewhere in RESTORE_ALL
+ * which is of course wrong!
+ */
+
+#define RESTORE_ALL						\
+	DISABLE_INTERRUPTS(r3,r4)				;\
+	l.lwz   r3,PT_PC(r1)					;\
+	l.mtspr r0,r3,SPR_EPCR_BASE				;\
+	l.lwz   r3,PT_SR(r1)					;\
+	l.mtspr r0,r3,SPR_ESR_BASE				;\
+	l.lwz   r2,PT_GPR2(r1)					;\
+	l.lwz   r3,PT_GPR3(r1)					;\
+	l.lwz   r4,PT_GPR4(r1)					;\
+	l.lwz   r5,PT_GPR5(r1)					;\
+	l.lwz   r6,PT_GPR6(r1)					;\
+	l.lwz   r7,PT_GPR7(r1)					;\
+	l.lwz   r8,PT_GPR8(r1)					;\
+	l.lwz   r9,PT_GPR9(r1)					;\
+	l.lwz   r10,PT_GPR10(r1)					;\
+	l.lwz   r11,PT_GPR11(r1)					;\
+	l.lwz   r12,PT_GPR12(r1)					;\
+	l.lwz   r13,PT_GPR13(r1)					;\
+	l.lwz   r14,PT_GPR14(r1)					;\
+	l.lwz   r15,PT_GPR15(r1)					;\
+	l.lwz   r16,PT_GPR16(r1)					;\
+	l.lwz   r17,PT_GPR17(r1)					;\
+	l.lwz   r18,PT_GPR18(r1)					;\
+	l.lwz   r19,PT_GPR19(r1)					;\
+	l.lwz   r20,PT_GPR20(r1)					;\
+	l.lwz   r21,PT_GPR21(r1)					;\
+	l.lwz   r22,PT_GPR22(r1)					;\
+	l.lwz   r23,PT_GPR23(r1)					;\
+	l.lwz   r24,PT_GPR24(r1)					;\
+	l.lwz   r25,PT_GPR25(r1)					;\
+	l.lwz   r26,PT_GPR26(r1)					;\
+	l.lwz   r27,PT_GPR27(r1)					;\
+	l.lwz   r28,PT_GPR28(r1)					;\
+	l.lwz   r29,PT_GPR29(r1)					;\
+	l.lwz   r30,PT_GPR30(r1)					;\
+	l.lwz   r31,PT_GPR31(r1)					;\
+	l.lwz   r1,PT_SP(r1)					;\
+	l.rfe
+
+
+#define EXCEPTION_ENTRY(handler)				\
+	.global	handler						;\
+handler:							;\
+	/* r1, EPCR, ESR a already saved */			;\
+	l.sw	PT_GPR2(r1),r2					;\
+	l.sw    PT_GPR3(r1),r3					;\
+	l.sw    PT_ORIG_GPR11(r1),r11				;\
+	/* r4 already save */					;\
+	l.sw    PT_GPR5(r1),r5					;\
+	l.sw    PT_GPR6(r1),r6					;\
+	l.sw    PT_GPR7(r1),r7					;\
+	l.sw    PT_GPR8(r1),r8					;\
+	l.sw    PT_GPR9(r1),r9					;\
+	/* r10 already saved */					;\
+	l.sw    PT_GPR11(r1),r11					;\
+	/* r12 already saved */					;\
+	l.sw    PT_GPR13(r1),r13					;\
+	l.sw    PT_GPR14(r1),r14					;\
+	l.sw    PT_GPR15(r1),r15					;\
+	l.sw    PT_GPR16(r1),r16					;\
+	l.sw    PT_GPR17(r1),r17					;\
+	l.sw    PT_GPR18(r1),r18					;\
+	l.sw    PT_GPR19(r1),r19					;\
+	l.sw    PT_GPR20(r1),r20					;\
+	l.sw    PT_GPR21(r1),r21					;\
+	l.sw    PT_GPR22(r1),r22					;\
+	l.sw    PT_GPR23(r1),r23					;\
+	l.sw    PT_GPR24(r1),r24					;\
+	l.sw    PT_GPR25(r1),r25					;\
+	l.sw    PT_GPR26(r1),r26					;\
+	l.sw    PT_GPR27(r1),r27					;\
+	l.sw    PT_GPR28(r1),r28					;\
+	l.sw    PT_GPR29(r1),r29					;\
+	/* r30 already save */					;\
+/*        l.sw    PT_GPR30(r1),r30*/					;\
+	l.sw    PT_GPR31(r1),r31					;\
+	l.sw    PT_SYSCALLNO(r1),r0
+
+#define UNHANDLED_EXCEPTION(handler,vector)			\
+	.global	handler						;\
+handler:							;\
+	/* r1, EPCR, ESR already saved */			;\
+	l.sw    PT_GPR2(r1),r2					;\
+	l.sw    PT_GPR3(r1),r3					;\
+	l.sw    PT_ORIG_GPR11(r1),r11				;\
+	l.sw    PT_GPR5(r1),r5					;\
+	l.sw    PT_GPR6(r1),r6					;\
+	l.sw    PT_GPR7(r1),r7					;\
+	l.sw    PT_GPR8(r1),r8					;\
+	l.sw    PT_GPR9(r1),r9					;\
+	/* r10 already saved */					;\
+	l.sw    PT_GPR11(r1),r11					;\
+	/* r12 already saved */					;\
+	l.sw    PT_GPR13(r1),r13					;\
+	l.sw    PT_GPR14(r1),r14					;\
+	l.sw    PT_GPR15(r1),r15					;\
+	l.sw    PT_GPR16(r1),r16					;\
+	l.sw    PT_GPR17(r1),r17					;\
+	l.sw    PT_GPR18(r1),r18					;\
+	l.sw    PT_GPR19(r1),r19					;\
+	l.sw    PT_GPR20(r1),r20					;\
+	l.sw    PT_GPR21(r1),r21					;\
+	l.sw    PT_GPR22(r1),r22					;\
+	l.sw    PT_GPR23(r1),r23					;\
+	l.sw    PT_GPR24(r1),r24					;\
+	l.sw    PT_GPR25(r1),r25					;\
+	l.sw    PT_GPR26(r1),r26					;\
+	l.sw    PT_GPR27(r1),r27					;\
+	l.sw    PT_GPR28(r1),r28					;\
+	l.sw    PT_GPR29(r1),r29					;\
+	/* r31 already saved */					;\
+	l.sw    PT_GPR30(r1),r30					;\
+/*        l.sw    PT_GPR31(r1),r31	*/				;\
+	l.sw    PT_SYSCALLNO(r1),r0				;\
+	l.addi	r3,r1,0						;\
+	/* r4 is exception EA */				;\
+	l.addi	r5,r0,vector					;\
+	l.jal	unhandled_exception				;\
+	 l.nop							;\
+	l.j	_ret_from_exception				;\
+	 l.nop
+
+/*
+ * NOTE: one should never assume that SPR_EPC, SPR_ESR, SPR_EEAR
+ *       contain the same values as when exception we're handling
+ *	 occured. in fact they never do. if you need them use
+ *	 values saved on stack (for SPR_EPC, SPR_ESR) or content
+ *       of r4 (for SPR_EEAR). for details look at EXCEPTION_HANDLE()
+ *       in 'arch/or32/kernel/head.S'
+ */
+
+/* =====================================================[ exceptions] === */
+
+/* ---[ 0x100: RESET exception ]----------------------------------------- */
+
+EXCEPTION_ENTRY(_tng_kernel_start)
+	l.jal	_start
+	 l.andi r0,r0,0
+
+/* ---[ 0x200: BUS exception ]------------------------------------------- */
+
+EXCEPTION_ENTRY(_bus_fault_handler)
+	/* r4: EA of fault (set by EXCEPTION_HANDLE) */
+	l.jal   do_bus_fault
+	 l.addi  r3,r1,0 /* pt_regs */
+
+	l.j     _ret_from_exception
+	 l.nop
+
+/* ---[ 0x300: Data Page Fault exception ]------------------------------- */
+
+EXCEPTION_ENTRY(_data_page_fault_handler)
+	/* set up parameters for do_page_fault */
+	l.addi  r3,r1,0                    // pt_regs
+	/* r4 set be EXCEPTION_HANDLE */   // effective address of fault
+	l.ori   r5,r0,0x300                // exception vector
+
+	/*
+	 * __PHX__: TODO
+	 *
+	 * all this can be written much simpler. look at
+	 * DTLB miss handler in the CONFIG_GUARD_PROTECTED_CORE part
+	 */
+#ifdef CONFIG_OPENRISC_NO_SPR_SR_DSX
+	l.lwz   r6,PT_PC(r3)                  // address of an offending insn
+	l.lwz   r6,0(r6)                   // instruction that caused pf
+
+	l.srli  r6,r6,26                   // check opcode for jump insn
+	l.sfeqi r6,0                       // l.j
+	l.bf    8f
+	l.sfeqi r6,1                       // l.jal
+	l.bf    8f
+	l.sfeqi r6,3                       // l.bnf
+	l.bf    8f
+	l.sfeqi r6,4                       // l.bf
+	l.bf    8f
+	l.sfeqi r6,0x11                    // l.jr
+	l.bf    8f
+	l.sfeqi r6,0x12                    // l.jalr
+	l.bf    8f
+
+	l.nop
+
+	l.j     9f
+	l.nop
+8:
+
+	l.lwz   r6,PT_PC(r3)                  // address of an offending insn
+	l.addi  r6,r6,4
+	l.lwz   r6,0(r6)                   // instruction that caused pf
+	l.srli  r6,r6,26                   // get opcode
+9:
+
+#else
+
+	l.mfspr r6,r0,SPR_SR		   // SR
+//	l.lwz	r6,PT_SR(r3)		   // ESR
+	l.andi	r6,r6,SPR_SR_DSX	   // check for delay slot exception
+	l.sfeqi	r6,0x1			   // exception happened in delay slot
+	l.bnf	7f
+	l.lwz	r6,PT_PC(r3)		   // address of an offending insn
+
+	l.addi	r6,r6,4			   // offending insn is in delay slot
+7:
+	l.lwz   r6,0(r6)                   // instruction that caused pf
+	l.srli  r6,r6,26                   // check opcode for write access
+#endif
+
+	l.sfgeui r6,0x34		   // check opcode for write access
+	l.bnf   1f
+	l.sfleui r6,0x37
+	l.bnf   1f
+	l.ori   r6,r0,0x1                  // write access
+	l.j     2f
+	l.nop
+1:	l.ori   r6,r0,0x0                  // !write access
+2:
+
+	/* call fault.c handler in or32/mm/fault.c */
+	l.jal   do_page_fault
+	l.nop
+	l.j     _ret_from_exception
+	l.nop
+
+/* ---[ 0x400: Insn Page Fault exception ]------------------------------- */
+
+EXCEPTION_ENTRY(_insn_page_fault_handler)
+	/* set up parameters for do_page_fault */
+	l.addi  r3,r1,0                    // pt_regs
+	/* r4 set be EXCEPTION_HANDLE */   // effective address of fault
+	l.ori   r5,r0,0x400                // exception vector
+	l.ori	r6,r0,0x0		   // !write access
+
+	/* call fault.c handler in or32/mm/fault.c */
+	l.jal   do_page_fault
+	l.nop
+	l.j     _ret_from_exception
+	l.nop
+
+
+/* ---[ 0x500: Timer exception ]----------------------------------------- */
+
+EXCEPTION_ENTRY(_timer_handler)
+	l.jal	timer_interrupt
+	 l.addi r3,r1,0 /* pt_regs */
+
+	l.j    _ret_from_intr
+	 l.nop
+
+/* ---[ 0x600: Aligment exception ]-------------------------------------- */
+
+EXCEPTION_ENTRY(_alignment_handler)
+	/* r4: EA of fault (set by EXCEPTION_HANDLE) */
+	l.jal   do_unaligned_access
+	 l.addi  r3,r1,0 /* pt_regs */
+
+	l.j     _ret_from_exception
+	 l.nop
+
+#if 0
+EXCEPTION_ENTRY(_aligment_handler)
+//        l.mfspr r2,r0,SPR_EEAR_BASE     /* Load the efective addres */
+	l.addi	r2,r4,0
+//        l.mfspr r5,r0,SPR_EPCR_BASE     /* Load the insn address */
+	l.lwz   r5,PT_PC(r1)
+
+	l.lwz   r3,0(r5)                /* Load insn */
+	l.srli  r4,r3,26                /* Shift left to get the insn opcode */
+
+	l.sfeqi r4,0x00                 /* Check if the load/store insn is in delay slot */
+	l.bf    jmp
+	l.sfeqi r4,0x01
+	l.bf    jmp
+	l.sfeqi r4,0x03
+	l.bf    jmp
+	l.sfeqi r4,0x04
+	l.bf    jmp
+	l.sfeqi r4,0x11
+	l.bf    jr
+	l.sfeqi r4,0x12
+	l.bf    jr
+	l.nop
+	l.j     1f
+	l.addi  r5,r5,4                 /* Increment PC to get return insn address */
+
+jmp:
+	l.slli  r4,r3,6                 /* Get the signed extended jump length */
+	l.srai  r4,r4,4
+
+	l.lwz   r3,4(r5)                /* Load the real load/store insn */
+
+	l.add   r5,r5,r4                /* Calculate jump target address */
+
+	l.j     1f
+	l.srli  r4,r3,26                /* Shift left to get the insn opcode */
+
+jr:
+	l.slli  r4,r3,9                 /* Shift to get the reg nb */
+	l.andi  r4,r4,0x7c
+
+	l.lwz   r3,4(r5)                /* Load the real load/store insn */
+
+	l.add   r4,r4,r1                /* Load the jump register value from the stack */
+	l.lwz   r5,0(r4)
+
+	l.srli  r4,r3,26                /* Shift left to get the insn opcode */
+
+
+1:
+//	  l.mtspr r0,r5,SPR_EPCR_BASE
+	l.sw	PT_PC(r1),r5
+
+	l.sfeqi r4,0x26
+	l.bf    lhs
+	l.sfeqi r4,0x25
+	l.bf    lhz
+	l.sfeqi r4,0x22
+	l.bf    lws
+	l.sfeqi r4,0x21
+	l.bf    lwz
+	l.sfeqi r4,0x37
+	l.bf    sh
+	l.sfeqi r4,0x35
+	l.bf    sw
+	l.nop
+
+1:      l.j     1b                      /* I don't know what to do */
+	l.nop
+
+lhs:    l.lbs   r5,0(r2)
+	l.slli  r5,r5,8
+	l.lbz   r6,1(r2)
+	l.or    r5,r5,r6
+	l.srli  r4,r3,19
+	l.andi  r4,r4,0x7c
+	l.add   r4,r4,r1
+	l.j     align_end
+	l.sw    0(r4),r5
+
+lhz:    l.lbz   r5,0(r2)
+	l.slli  r5,r5,8
+	l.lbz   r6,1(r2)
+	l.or    r5,r5,r6
+	l.srli  r4,r3,19
+	l.andi  r4,r4,0x7c
+	l.add   r4,r4,r1
+	l.j     align_end
+	l.sw    0(r4),r5
+
+lws:    l.lbs   r5,0(r2)
+	l.slli  r5,r5,24
+	l.lbz   r6,1(r2)
+	l.slli  r6,r6,16
+	l.or    r5,r5,r6
+	l.lbz   r6,2(r2)
+	l.slli  r6,r6,8
+	l.or    r5,r5,r6
+	l.lbz   r6,3(r2)
+	l.or    r5,r5,r6
+	l.srli  r4,r3,19
+	l.andi  r4,r4,0x7c
+	l.add   r4,r4,r1
+	l.j     align_end
+	l.sw    0(r4),r5
+
+lwz:    l.lbz   r5,0(r2)
+	l.slli  r5,r5,24
+	l.lbz   r6,1(r2)
+	l.slli  r6,r6,16
+	l.or    r5,r5,r6
+	l.lbz   r6,2(r2)
+	l.slli  r6,r6,8
+	l.or    r5,r5,r6
+	l.lbz   r6,3(r2)
+	l.or    r5,r5,r6
+	l.srli  r4,r3,19
+	l.andi  r4,r4,0x7c
+	l.add   r4,r4,r1
+	l.j     align_end
+	l.sw    0(r4),r5
+
+sh:
+	l.srli  r4,r3,9
+	l.andi  r4,r4,0x7c
+	l.add   r4,r4,r1
+	l.lwz   r5,0(r4)
+	l.sb    1(r2),r5
+	l.srli  r5,r5,8
+	l.j     align_end
+	l.sb    0(r2),r5
+
+sw:
+	l.srli  r4,r3,9
+	l.andi  r4,r4,0x7c
+	l.add   r4,r4,r1
+	l.lwz   r5,0(r4)
+	l.sb    3(r2),r5
+	l.srli  r5,r5,8
+	l.sb    2(r2),r5
+	l.srli  r5,r5,8
+	l.sb    1(r2),r5
+	l.srli  r5,r5,8
+	l.j     align_end
+	l.sb    0(r2),r5
+
+align_end:
+	l.j    _ret_from_intr
+	l.nop
+#endif
+
+/* ---[ 0x700: Illegal insn exception ]---------------------------------- */
+
+EXCEPTION_ENTRY(_illegal_instruction_handler)
+	/* r4: EA of fault (set by EXCEPTION_HANDLE) */
+	l.jal   do_illegal_instruction
+	 l.addi  r3,r1,0 /* pt_regs */
+
+	l.j     _ret_from_exception
+	 l.nop
+
+/* ---[ 0x800: External interrupt exception ]---------------------------- */
+
+EXCEPTION_ENTRY(_external_irq_handler)
+#ifdef CONFIG_OPENRISC_ESR_EXCEPTION_BUG_CHECK
+	l.lwz	r4,PT_SR(r1)		// were interrupts enabled ?
+	l.andi	r4,r4,SPR_SR_IEE
+	l.sfeqi	r4,0
+	l.bnf	1f			// ext irq enabled, all ok.
+	l.nop
+
+	l.addi  r1,r1,-0x8
+	l.movhi r3,hi(42f)
+	l.ori	r3,r3,lo(42f)
+	l.sw    0x0(r1),r3
+	l.jal   printk
+	l.sw    0x4(r1),r4
+	l.addi  r1,r1,0x8
+
+	.section .rodata, "a"
+42:
+		.string "\n\rESR interrupt bug: in _external_irq_handler (ESR %x)\n\r"
+		.align 4
+	.previous
+
+	l.ori	r4,r4,SPR_SR_IEE	// fix the bug
+//	l.sw	PT_SR(r1),r4
+1:
+#endif
+	l.addi	r3,r1,0
+	l.movhi	r8,hi(do_IRQ)
+	l.ori	r8,r8,lo(do_IRQ)
+	l.jalr r8
+	l.nop
+	l.j    _ret_from_intr
+	l.nop
+
+/* ---[ 0x900: DTLB miss exception ]------------------------------------- */
+
+
+/* ---[ 0xa00: ITLB miss exception ]------------------------------------- */
+
+
+/* ---[ 0xb00: Range exception ]----------------------------------------- */
+
+UNHANDLED_EXCEPTION(_vector_0xb00,0xb00)
+
+/* ---[ 0xc00: Syscall exception ]--------------------------------------- */
+
+/*
+ * Syscalls are a special type of exception in that they are
+ * _explicitly_ invoked by userspace and can therefore be
+ * held to conform to the same ABI as normal functions with
+ * respect to whether registers are preserved across the call
+ * or not.
+ */
+
+/* Upon syscall entry we just save the callee-saved registers
+ * and not the call-clobbered ones.
+ */
+
+_string_syscall_return:
+	.string "syscall return %ld \n\r\0"
+	.align 4
+
+ENTRY(_sys_call_handler)
+	/* syscalls run with interrupts enabled */
+	ENABLE_INTERRUPTS(r29)		// enable interrupts, r29 is temp
+
+	/* r1, EPCR, ESR a already saved */
+	l.sw	PT_GPR2(r1),r2
+	/* r3-r8 must be saved because syscall restart relies
+	 * on us being able to restart the syscall args... technically
+	 * they should be clobbered, otherwise
+	 */
+	l.sw    PT_GPR3(r1),r3
+	/* r4 already saved */
+	/* r4 holds the EEAR address of the fault, load the original r4 */
+	l.lwz	r4,PT_GPR4(r1)
+	l.sw    PT_GPR5(r1),r5
+	l.sw    PT_GPR6(r1),r6
+	l.sw    PT_GPR7(r1),r7
+	l.sw    PT_GPR8(r1),r8
+	l.sw    PT_GPR9(r1),r9
+	/* r10 already saved */
+	l.sw    PT_GPR11(r1),r11
+	l.sw    PT_ORIG_GPR11(r1),r11
+	/* r12,r13 already saved */
+
+	/* r14-r28 (even) aren't touched by the syscall fast path below
+	 * so we don't need to save them.  However, the functions that return
+	 * to userspace via a call to switch() DO need to save these because
+	 * switch() effectively clobbers them... saving these registers for
+	 * such functions is handled in their syscall wrappers (see fork, vfork,
+	 * and clone, below).
+
+	/* r30 is the only register we clobber in the fast path */
+	/* r30 already saved */
+/*	l.sw    PT_GPR30(r1),r30 */
+	/* This is used by do_signal to determine whether to check for
+	 * syscall restart or not */
+	l.sw    PT_SYSCALLNO(r1),r11
+
+_syscall_check_trace_enter:
+	/* If TIF_SYSCALL_TRACE is set, then we want to do syscall tracing */
+	l.lwz	r30,TI_FLAGS(r10)
+	l.andi	r30,r30,_TIF_SYSCALL_TRACE
+	l.sfne	r30,r0
+	l.bf	_syscall_trace_enter
+	 l.nop
+
+_syscall_check:
+	/* Ensure that the syscall number is reasonable */
+	l.sfgeui r11,__NR_syscalls
+	l.bf	_syscall_badsys
+	 l.nop
+
+_syscall_call:
+	l.movhi r29,hi(sys_call_table)
+	l.ori   r29,r29,lo(sys_call_table)
+	l.slli  r11,r11,2
+	l.add   r29,r29,r11
+	l.lwz   r29,0(r29)
+
+	l.jalr  r29
+	 l.nop
+
+_syscall_return:
+	/* All syscalls return here... just pay attention to ret_from_fork
+	 * which does it in a round-about way.
+	 */
+	l.sw    PT_GPR11(r1),r11           // save return value
+
+#if 0
+_syscall_debug:
+	l.movhi r3,hi(_string_syscall_return)
+	l.ori   r3,r3,lo(_string_syscall_return)
+	l.ori   r27,r0,1
+	l.sw    -4(r1),r27
+	l.sw    -8(r1),r11
+	l.addi  r1,r1,-8
+	l.movhi r27,hi(printk)
+	l.ori   r27,r27,lo(printk)
+	l.jalr  r27
+	 l.nop
+	l.addi  r1,r1,8
+#endif
+
+_syscall_check_trace_leave:
+	/* r30 is a callee-saved register so this should still hold the
+	 * _TIF_SYSCALL_TRACE flag from _syscall_check_trace_enter above...
+	 * _syscall_trace_leave expects syscall result to be in pt_regs->r11.
+	 */
+	l.sfne	r30,r0
+	l.bf	_syscall_trace_leave
+	 l.nop
+
+/* This is where the exception-return code begins... interrupts need to be
+ * disabled the rest of the way here because we can't afford to miss any
+ * interrupts that set NEED_RESCHED or SIGNALPENDING... really true? */
+
+_syscall_check_work:
+	/* Here we need to disable interrupts */
+	DISABLE_INTERRUPTS(r27,r29)
+	l.lwz	r30,TI_FLAGS(r10)
+	l.andi	r30,r30,_TIF_WORK_MASK
+	l.sfne	r30,r0
+
+	l.bnf	_syscall_resume_userspace
+	 l.nop
+
+	/* Work pending follows a different return path, so we need to
+	 * make sure that all the call-saved registers get into pt_regs
+	 * before branching...
+	 */
+	l.sw    PT_GPR14(r1),r14
+	l.sw    PT_GPR16(r1),r16
+	l.sw    PT_GPR18(r1),r18
+	l.sw    PT_GPR20(r1),r20
+	l.sw    PT_GPR22(r1),r22
+	l.sw    PT_GPR24(r1),r24
+	l.sw    PT_GPR26(r1),r26
+	l.sw    PT_GPR28(r1),r28
+
+	/* _work_pending needs to be called with interrupts disabled */
+	l.j	_work_pending
+	 l.nop
+
+_syscall_resume_userspace:
+//	ENABLE_INTERRUPTS(r29)
+
+
+/* This is the hot path for returning to userspace from a syscall.  If there's
+ * work to be done and the branch to _work_pending was taken above, then the
+ * return to userspace will be done via the normal exception return path...
+ * that path restores _all_ registers and will overwrite the "clobbered"
+ * registers with whatever garbage is in pt_regs -- that's OK because those
+ * registers are clobbered anyway and because the extra work is insignificant
+ * in the context of the extra work that _work_pending is doing.
+
+/* Once again, syscalls are special and only guarantee to preserve the
+ * same registers as a normal function call */
+
+/* The assumption here is that the registers r14-r28 (even) are untouched and
+ * don't need to be restored... be sure that that's really the case!
+ */
+
+/* This is still too much... we should only be restoring what we actually
+ * clobbered... we should even be using 'scratch' (odd) regs above so that
+ * we don't need to restore anything, hardly...
+ */
+
+	l.lwz	r2,PT_GPR2(r1)
+
+	/* Restore args */
+	/* r3-r8 are technically clobbered, but syscall restart needs these
+	 * to be restored...
+	 */
+	l.lwz	r3,PT_GPR3(r1)
+	l.lwz	r4,PT_GPR4(r1)
+	l.lwz	r5,PT_GPR5(r1)
+	l.lwz	r6,PT_GPR6(r1)
+	l.lwz	r7,PT_GPR7(r1)
+	l.lwz	r8,PT_GPR8(r1)
+
+	l.lwz	r9,PT_GPR9(r1)
+	l.lwz	r10,PT_GPR10(r1)
+	l.lwz	r11,PT_GPR11(r1)
+
+	/* r30 is the only register we clobber in the fast path */
+	l.lwz	r30,PT_GPR30(r1)
+
+	/* Here we use r13-r19 (odd) as scratch regs */
+	l.lwz   r13,PT_PC(r1)
+	l.lwz   r15,PT_SR(r1)
+	l.lwz	r1,PT_SP(r1)
+	/* Interrupts need to be disabled for setting EPCR and ESR
+	 * so that another interrupt doesn't come in here and clobber
+	 * them before we can use them for our l.rfe */
+	DISABLE_INTERRUPTS(r17,r19)
+	l.mtspr r0,r13,SPR_EPCR_BASE
+	l.mtspr r0,r15,SPR_ESR_BASE
+	l.rfe
+
+/* End of hot path!
+ * Keep the below tracing and error handling out of the hot path...
+*/
+
+_syscall_trace_enter:
+	/* Here we pass pt_regs to do_syscall_trace_enter.  Make sure
+	 * that function is really getting all the info it needs as
+	 * pt_regs isn't a complete set of userspace regs, just the
+	 * ones relevant to the syscall...
+	 *
+	 * Note use of delay slot for setting argument.
+	 */
+	l.jal	do_syscall_trace_enter
+	 l.addi	r3,r1,0
+
+	/* Restore arguments (not preserved across do_syscall_trace_enter)
+	 * so that we can do the syscall for real and return to the syscall
+	 * hot path.
+	 */
+	l.lwz	r11,PT_SYSCALLNO(r1)
+	l.lwz	r3,PT_GPR3(r1)
+	l.lwz	r4,PT_GPR4(r1)
+	l.lwz	r5,PT_GPR5(r1)
+	l.lwz	r6,PT_GPR6(r1)
+	l.lwz	r7,PT_GPR7(r1)
+
+	l.j	_syscall_check
+	 l.lwz	r8,PT_GPR8(r1)
+
+_syscall_trace_leave:
+	l.jal	do_syscall_trace_leave
+	 l.addi	r3,r1,0
+
+	l.j	_syscall_check_work
+	 l.nop
+
+_syscall_badsys:
+	/* Here we effectively pretend to have executed an imaginary
+	 * syscall that returns -ENOSYS and then return to the regular
+	 * syscall hot path.
+	 * Note that "return value" is set in the delay slot...
+	 */
+	l.j	_syscall_return
+	 l.addi	r11,r0,-ENOSYS
+
+/******* END SYSCALL HANDLING *******/
+
+/* ---[ 0xd00: Trap exception ]------------------------------------------ */
+
+UNHANDLED_EXCEPTION(_vector_0xd00,0xd00)
+
+/* ---[ 0xe00: Trap exception ]------------------------------------------ */
+
+EXCEPTION_ENTRY(_trap_handler)
+	/* r4: EA of fault (set by EXCEPTION_HANDLE) */
+	l.jal   do_trap
+	 l.addi  r3,r1,0 /* pt_regs */
+
+	l.j     _ret_from_exception
+	 l.nop
+
+/* ---[ 0xf00: Reserved exception ]-------------------------------------- */
+
+UNHANDLED_EXCEPTION(_vector_0xf00,0xf00)
+
+/* ---[ 0x1000: Reserved exception ]------------------------------------- */
+
+UNHANDLED_EXCEPTION(_vector_0x1000,0x1000)
+
+/* ---[ 0x1100: Reserved exception ]------------------------------------- */
+
+UNHANDLED_EXCEPTION(_vector_0x1100,0x1100)
+
+/* ---[ 0x1200: Reserved exception ]------------------------------------- */
+
+UNHANDLED_EXCEPTION(_vector_0x1200,0x1200)
+
+/* ---[ 0x1300: Reserved exception ]------------------------------------- */
+
+UNHANDLED_EXCEPTION(_vector_0x1300,0x1300)
+
+/* ---[ 0x1400: Reserved exception ]------------------------------------- */
+
+UNHANDLED_EXCEPTION(_vector_0x1400,0x1400)
+
+/* ---[ 0x1500: Reserved exception ]------------------------------------- */
+
+UNHANDLED_EXCEPTION(_vector_0x1500,0x1500)
+
+/* ---[ 0x1600: Reserved exception ]------------------------------------- */
+
+UNHANDLED_EXCEPTION(_vector_0x1600,0x1600)
+
+/* ---[ 0x1700: Reserved exception ]------------------------------------- */
+
+UNHANDLED_EXCEPTION(_vector_0x1700,0x1700)
+
+/* ---[ 0x1800: Reserved exception ]------------------------------------- */
+
+UNHANDLED_EXCEPTION(_vector_0x1800,0x1800)
+
+/* ---[ 0x1900: Reserved exception ]------------------------------------- */
+
+UNHANDLED_EXCEPTION(_vector_0x1900,0x1900)
+
+/* ---[ 0x1a00: Reserved exception ]------------------------------------- */
+
+UNHANDLED_EXCEPTION(_vector_0x1a00,0x1a00)
+
+/* ---[ 0x1b00: Reserved exception ]------------------------------------- */
+
+UNHANDLED_EXCEPTION(_vector_0x1b00,0x1b00)
+
+/* ---[ 0x1c00: Reserved exception ]------------------------------------- */
+
+UNHANDLED_EXCEPTION(_vector_0x1c00,0x1c00)
+
+/* ---[ 0x1d00: Reserved exception ]------------------------------------- */
+
+UNHANDLED_EXCEPTION(_vector_0x1d00,0x1d00)
+
+/* ---[ 0x1e00: Reserved exception ]------------------------------------- */
+
+UNHANDLED_EXCEPTION(_vector_0x1e00,0x1e00)
+
+/* ---[ 0x1f00: Reserved exception ]------------------------------------- */
+
+UNHANDLED_EXCEPTION(_vector_0x1f00,0x1f00)
+
+/* ========================================================[ return ] === */
+
+_work_pending:
+	/*
+	 * if (current_thread_info->flags & _TIF_NEED_RESCHED)
+	 *     schedule();
+	 */
+	l.lwz   r5,TI_FLAGS(r10)
+	l.andi	r3,r5,_TIF_NEED_RESCHED
+	l.sfnei r3,0
+	l.bnf   _work_notifysig
+	 l.nop
+	l.jal   schedule
+	 l.nop
+	l.j	_resume_userspace
+	 l.nop
+
+/* Handle pending signals and notify-resume requests.
+ * do_notify_resume must be passed the latest pushed pt_regs, not
+ * necessarily the "userspace" ones.  Also, pt_regs->syscallno
+ * must be set so that the syscall restart functionality works.
+ */
+_work_notifysig:
+	l.jal	do_notify_resume
+	 l.ori	r3,r1,0		  /* pt_regs */
+
+_resume_userspace:
+	DISABLE_INTERRUPTS(r3,r4)
+	l.lwz	r3,TI_FLAGS(r10)
+	l.andi	r3,r3,_TIF_WORK_MASK
+	l.sfnei	r3,0
+	l.bf	_work_pending
+	 l.nop
+
+_restore_all:
+	RESTORE_ALL
+	/* This returns to userspace code */
+
+
+ENTRY(_ret_from_intr)
+ENTRY(_ret_from_exception)
+	l.lwz	r4,PT_SR(r1)
+	l.andi	r3,r4,SPR_SR_SM
+	l.sfeqi	r3,0
+	l.bnf	_restore_all
+	 l.nop
+	l.j	_resume_userspace
+	 l.nop
+
+ENTRY(ret_from_fork)
+	l.jal	schedule_tail
+	 l.nop
+
+	/* _syscall_returns expect r11 to contain return value */
+	l.lwz	r11,PT_GPR11(r1)
+
+	/* The syscall fast path return expects call-saved registers
+	 * r12-r28 to be untouched, so we restore them here as they
+	 * will have been effectively clobbered when arriving here
+	 * via the call to switch()
+	 */
+	l.lwz	r12,PT_GPR12(r1)
+	l.lwz	r14,PT_GPR14(r1)
+	l.lwz	r16,PT_GPR16(r1)
+	l.lwz	r18,PT_GPR18(r1)
+	l.lwz	r20,PT_GPR20(r1)
+	l.lwz	r22,PT_GPR22(r1)
+	l.lwz	r24,PT_GPR24(r1)
+	l.lwz	r26,PT_GPR26(r1)
+	l.lwz	r28,PT_GPR28(r1)
+
+	l.j	_syscall_return
+	 l.nop
+
+/* Since syscalls don't save call-clobbered registers, the args to
+ * kernel_thread_helper will need to be passed through callee-saved
+ * registers and copied to the parameter registers when the thread
+ * begins running.
+ *
+ * See arch/openrisc/kernel/process.c:
+ * The args are passed as follows:
+ *   arg1 (r3) : passed in r20
+ *   arg2 (r4) : passed in r22
+ */
+
+ENTRY(_kernel_thread_helper)
+	l.or	r3,r20,r0
+	l.or	r4,r22,r0
+	l.movhi	r31,hi(kernel_thread_helper)
+	l.ori	r31,r31,lo(kernel_thread_helper)
+	l.jr	r31
+	 l.nop
+
+
+/* ========================================================[ switch ] === */
+
+/*
+ * This routine switches between two different tasks.  The process
+ * state of one is saved on its kernel stack.  Then the state
+ * of the other is restored from its kernel stack.  The memory
+ * management hardware is updated to the second process's state.
+ * Finally, we can return to the second process, via the 'return'.
+ *
+ * Note: there are two ways to get to the "going out" portion
+ * of this code; either by coming in via the entry (_switch)
+ * or via "fork" which must set up an environment equivalent
+ * to the "_switch" path.  If you change this (or in particular, the
+ * SAVE_REGS macro), you'll have to change the fork code also.
+ */
+
+
+/* _switch MUST never lay on page boundry, cause it runs from
+ * effective addresses and beeing interrupted by iTLB miss would kill it.
+ * dTLB miss seams to never accour in the bad place since data accesses
+ * are from task structures which are always page aligned.
+ *
+ * The problem happens in RESTORE_ALL_NO_R11 where we first set the EPCR
+ * register, then load the previous register values and only at the end call
+ * the l.rfe instruction. If get TLB miss in beetwen the EPCR register gets
+ * garbled and we end up calling l.rfe with the wrong EPCR. (same probably
+ * holds for ESR)
+ *
+ * To avoid this problems it is sufficient to align _switch to
+ * some nice round number smaller than it's size...
+ */
+
+/* ABI rules apply here... we either enter _switch via schedule() or via
+ * an imaginary call to which we shall return at return_from_fork.  Either
+ * way, we are a function call and only need to preserve the callee-saved
+ * registers when we return.  As such, we don't need to save the registers
+ * on the stack that we won't be returning as they were...
+ */
+
+	.align 0x400
+ENTRY(_switch)
+	/* We don't store SR as _switch only gets called in a context where
+	 * the SR will be the same going in and coming out... */
+
+	/* Set up new pt_regs struct for saving task state */
+	l.addi  r1,r1,-(INT_FRAME_SIZE)
+
+	/* No need to store r1/PT_SP as it goes into KSP below */
+	l.sw    PT_GPR2(r1),r2
+	l.sw    PT_GPR9(r1),r9
+	/* This is wrong, r12 shouldn't be here... but GCC is broken for the time being
+	 * and expects r12 to be callee-saved... */
+	l.sw    PT_GPR12(r1),r12
+	l.sw    PT_GPR14(r1),r14
+	l.sw    PT_GPR16(r1),r16
+	l.sw    PT_GPR18(r1),r18
+	l.sw    PT_GPR20(r1),r20
+	l.sw    PT_GPR22(r1),r22
+	l.sw    PT_GPR24(r1),r24
+	l.sw    PT_GPR26(r1),r26
+	l.sw    PT_GPR28(r1),r28
+	l.sw    PT_GPR30(r1),r30
+
+	l.addi	r11,r10,0			/* Save old 'current' to 'last' return value*/
+
+	/* We use thread_info->ksp for storing the address of the above
+	 * structure so that we can get back to it later... we don't want
+	 * to lose the value of thread_info->ksp, though, so store it as
+	 * pt_regs->sp so that we can easily restore it when we are made
+	 * live again...
+	 */
+
+	/* Save the old value of thread_info->ksp as pt_regs->sp */
+	l.lwz	r29,TI_KSP(r10)
+	l.sw	PT_SP(r1),r29
+
+	/* Swap kernel stack pointers */
+	l.sw    TI_KSP(r10),r1			/* Save old stack pointer */
+	l.or	r10,r4,r0			/* Set up new current_thread_info */
+	l.lwz   r1,TI_KSP(r10)			/* Load new stack pointer */
+
+	/* Restore the old value of thread_info->ksp */
+	l.lwz	r29,PT_SP(r1)
+	l.sw	TI_KSP(r10),r29
+
+	/* ...and restore the registers, except r11 because the return value
+	 * has already been set above.
+	 */
+	l.lwz   r2,PT_GPR2(r1)
+	l.lwz   r9,PT_GPR9(r1)
+	/* No need to restore r10 */
+	/* ...and do not restore r11 */
+
+	/* This is wrong, r12 shouldn't be here... but GCC is broken for the time being
+	 * and expects r12 to be callee-saved... */
+	l.lwz   r12,PT_GPR12(r1)
+	l.lwz   r14,PT_GPR14(r1)
+	l.lwz   r16,PT_GPR16(r1)
+	l.lwz   r18,PT_GPR18(r1)
+	l.lwz   r20,PT_GPR20(r1)
+	l.lwz   r22,PT_GPR22(r1)
+	l.lwz   r24,PT_GPR24(r1)
+	l.lwz   r26,PT_GPR26(r1)
+	l.lwz   r28,PT_GPR28(r1)
+	l.lwz   r30,PT_GPR30(r1)
+
+	/* Unwind stack to pre-switch state */
+	l.addi  r1,r1,(INT_FRAME_SIZE)
+
+	/* Return via the link-register back to where we 'came from', where that can be
+	 * either schedule() or return_from_fork()... */
+	l.jr	r9
+	 l.nop
+
+/* ==================================================================== */
+
+/* These all use the delay slot for setting the argument register, so the
+ * jump is always happening after the l.addi instruction.
+ *
+ * These are all just wrappers that don't touch the link-register r9, so the
+ * return from the "real" syscall function will return back to the syscall
+ * code that did the l.jal that brought us here.
+ */
+
+/* fork requires that we save all the callee-saved registers because they
+ * are all effectively clobbered by the call to _switch.  Here we store
+ * all the registers that aren't touched by the syscall fast path and thus
+ * weren't saved there.
+ */
+
+_fork_save_extra_regs_and_call:
+	l.sw    PT_GPR14(r1),r14
+	l.sw    PT_GPR16(r1),r16
+	l.sw    PT_GPR18(r1),r18
+	l.sw    PT_GPR20(r1),r20
+	l.sw    PT_GPR22(r1),r22
+	l.sw    PT_GPR24(r1),r24
+	l.sw    PT_GPR26(r1),r26
+	l.jr	r29
+	 l.sw    PT_GPR28(r1),r28
+
+ENTRY(sys_clone)
+	l.movhi	r29,hi(_sys_clone)
+	l.ori	r29,r29,lo(_sys_clone)
+	l.j	_fork_save_extra_regs_and_call
+	 l.addi	r7,r1,0
+
+ENTRY(sys_fork)
+	l.movhi	r29,hi(_sys_fork)
+	l.ori	r29,r29,lo(_sys_fork)
+	l.j	_fork_save_extra_regs_and_call
+	 l.addi	r3,r1,0
+
+ENTRY(sys_vfork)
+	l.movhi	r29,hi(_sys_vfork)
+	l.ori	r29,r29,lo(_sys_vfork)
+	l.j	_fork_save_extra_regs_and_call
+	 l.addi	r3,r1,0
+
+ENTRY(sys_execve)
+	l.j	_sys_execve
+	 l.addi	r6,r1,0
+
+ENTRY(sys_sigaltstack)
+	l.j	_sys_sigaltstack
+	 l.addi	r5,r1,0
+
+ENTRY(sys_rt_sigreturn)
+	l.j	_sys_rt_sigreturn
+	 l.addi	r3,r1,0
+
+/* This is a catch-all syscall for atomic instructions for the OpenRISC 1000.
+ * The functions takes a variable number of parameters depending on which
+ * particular flavour of atomic you want... parameter 1 is a flag identifying
+ * the atomic in question.  Currently, this function implements the
+ * following variants:
+ *
+ * XCHG:
+ *  @flag: 1
+ *  @ptr1:
+ *  @ptr2:
+ * Atomically exchange the values in pointers 1 and 2.
+ *
+ */
+
+ENTRY(sys_or1k_atomic)
+	/* FIXME: This ignores r3 and always does an XCHG */
+	DISABLE_INTERRUPTS(r17,r19)
+	l.lwz	r30,0(r4)
+	l.lwz	r28,0(r5)
+	l.sw	0(r4),r28
+	l.sw	0(r5),r30
+	ENABLE_INTERRUPTS(r17)
+	l.jr	r9
+	 l.or	r11,r0,r0
+
+/* ============================================================[ EOF ]=== */
diff --git a/arch/openrisc/kernel/head.S b/arch/openrisc/kernel/head.S
new file mode 100644
index 0000000..c75018d
--- /dev/null
+++ b/arch/openrisc/kernel/head.S
@@ -0,0 +1,1607 @@
+/*
+ * OpenRISC head.S
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
+#include <linux/linkage.h>
+#include <linux/threads.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <asm/processor.h>
+#include <asm/page.h>
+#include <asm/mmu.h>
+#include <asm/pgtable.h>
+#include <asm/cache.h>
+#include <asm/spr_defs.h>
+#include <asm/asm-offsets.h>
+
+#define tophys(rd,rs)				\
+	l.movhi	rd,hi(-KERNELBASE)		;\
+	l.add	rd,rd,rs
+
+#define CLEAR_GPR(gpr)				\
+	l.or    gpr,r0,r0
+
+#define LOAD_SYMBOL_2_GPR(gpr,symbol)		\
+	l.movhi gpr,hi(symbol)			;\
+	l.ori   gpr,gpr,lo(symbol)
+
+
+#define UART_BASE_ADD      0x90000000
+
+#define EXCEPTION_SR  (SPR_SR_DME | SPR_SR_IME | SPR_SR_DCE | SPR_SR_ICE | SPR_SR_SM)
+#define SYSCALL_SR  (SPR_SR_DME | SPR_SR_IME | SPR_SR_DCE | SPR_SR_ICE | SPR_SR_IEE | SPR_SR_TEE | SPR_SR_SM)
+
+/* ============================================[ tmp store locations ]=== */
+
+/*
+ * emergency_print temporary stores
+ */
+#define EMERGENCY_PRINT_STORE_GPR4	l.sw    0x20(r0),r4
+#define EMERGENCY_PRINT_LOAD_GPR4	l.lwz   r4,0x20(r0)
+
+#define EMERGENCY_PRINT_STORE_GPR5	l.sw    0x24(r0),r5
+#define EMERGENCY_PRINT_LOAD_GPR5	l.lwz   r5,0x24(r0)
+
+#define EMERGENCY_PRINT_STORE_GPR6	l.sw    0x28(r0),r6
+#define EMERGENCY_PRINT_LOAD_GPR6	l.lwz   r6,0x28(r0)
+
+#define EMERGENCY_PRINT_STORE_GPR7	l.sw    0x2c(r0),r7
+#define EMERGENCY_PRINT_LOAD_GPR7	l.lwz   r7,0x2c(r0)
+
+#define EMERGENCY_PRINT_STORE_GPR8	l.sw    0x30(r0),r8
+#define EMERGENCY_PRINT_LOAD_GPR8	l.lwz   r8,0x30(r0)
+
+#define EMERGENCY_PRINT_STORE_GPR9	l.sw    0x34(r0),r9
+#define EMERGENCY_PRINT_LOAD_GPR9	l.lwz   r9,0x34(r0)
+
+
+/*
+ * TLB miss handlers temorary stores
+ */
+#define EXCEPTION_STORE_GPR9		l.sw    0x10(r0),r9
+#define EXCEPTION_LOAD_GPR9		l.lwz   r9,0x10(r0)
+
+#define EXCEPTION_STORE_GPR2		l.sw    0x64(r0),r2
+#define EXCEPTION_LOAD_GPR2		l.lwz   r2,0x64(r0)
+
+#define EXCEPTION_STORE_GPR3		l.sw    0x68(r0),r3
+#define EXCEPTION_LOAD_GPR3		l.lwz   r3,0x68(r0)
+
+#define EXCEPTION_STORE_GPR4		l.sw    0x6c(r0),r4
+#define EXCEPTION_LOAD_GPR4		l.lwz   r4,0x6c(r0)
+
+#define EXCEPTION_STORE_GPR5		l.sw    0x70(r0),r5
+#define EXCEPTION_LOAD_GPR5		l.lwz   r5,0x70(r0)
+
+#define EXCEPTION_STORE_GPR6		l.sw    0x74(r0),r6
+#define EXCEPTION_LOAD_GPR6		l.lwz   r6,0x74(r0)
+
+
+/*
+ * EXCEPTION_HANDLE temporary stores
+ */
+
+#define EXCEPTION_T_STORE_GPR30		l.sw    0x78(r0),r30
+#define EXCEPTION_T_LOAD_GPR30(reg)	l.lwz   reg,0x78(r0)
+
+#define EXCEPTION_T_STORE_GPR10		l.sw    0x7c(r0),r10
+#define EXCEPTION_T_LOAD_GPR10(reg)	l.lwz   reg,0x7c(r0)
+
+#define EXCEPTION_T_STORE_SP		l.sw	0x80(r0),r1
+#define EXCEPTION_T_LOAD_SP(reg)	l.lwz   reg,0x80(r0)
+
+/*
+ * For UNHANLDED_EXCEPTION
+ */
+
+#define EXCEPTION_T_STORE_GPR31		l.sw    0x84(r0),r31
+#define EXCEPTION_T_LOAD_GPR31(reg)	l.lwz   reg,0x84(r0)
+
+/* =========================================================[ macros ]=== */
+
+
+#define GET_CURRENT_PGD(reg,t1)					\
+	LOAD_SYMBOL_2_GPR(reg,current_pgd)			;\
+	tophys  (t1,reg)					;\
+	l.lwz   reg,0(t1)
+
+
+/*
+ * DSCR: this is a common hook for handling exceptions. it will save
+ *       the needed registers, set up stack and pointer to current
+ *	 then jump to the handler while enabling MMU
+ *
+ * PRMS: handler	- a function to jump to. it has to save the
+ *			remaining registers to kernel stack, call
+ *			appropriate arch-independant exception handler
+ *			and finaly jump to ret_from_except
+ *
+ * PREQ: unchanged state from the time exception happened
+ *
+ * POST: SAVED the following registers original value
+ *	       to the new created exception frame pointed to by r1
+ *
+ *	 r1  - ksp	pointing to the new (exception) frame
+ *	 r4  - EEAR     exception EA
+ *	 r10 - current	pointing to current_thread_info struct
+ *	 r12 - syscall  0, since we didn't come from syscall
+ *	 r13 - temp	it actually contains new SR, not needed anymore
+ *	 r31 - handler	address of the handler we'll jump to
+ *
+ *	 handler has to save remaining registers to the exception
+ *	 ksp frame *before* tainting them!
+ *
+ * NOTE: this function is not reentrant per se. reentrancy is guaranteed
+ *       by processor disabling all exceptions/interrupts when exception
+ *	 accours.
+ *
+ * OPTM: no need to make it so wasteful to extract ksp when in user mode
+ */
+
+#define EXCEPTION_HANDLE(handler)				\
+	EXCEPTION_T_STORE_GPR30					;\
+	l.mfspr r30,r0,SPR_ESR_BASE				;\
+	l.andi  r30,r30,SPR_SR_SM				;\
+	l.sfeqi r30,0						;\
+	EXCEPTION_T_STORE_GPR10					;\
+	l.bnf   2f                            /* kernel_mode */	;\
+	 EXCEPTION_T_STORE_SP                 /* delay slot */	;\
+1: /* user_mode:   */						;\
+	LOAD_SYMBOL_2_GPR(r1,current_thread_info_set)		;\
+	tophys  (r30,r1)					;\
+	/* r10: current_thread_info  */				;\
+	l.lwz   r10,0(r30)					;\
+	tophys  (r30,r10)					;\
+	l.lwz   r1,(TI_KSP)(r30)				;\
+	/* fall through */					;\
+2: /* kernel_mode: */						;\
+	/* create new stack frame, save only needed gprs */	;\
+	/* r1: KSP, r10: current, r4: EEAR, r31: __pa(KSP) */	;\
+	/* r12:	temp, syscall indicator */			;\
+	l.addi  r1,r1,-(INT_FRAME_SIZE)				;\
+	/* r1 is KSP, r30 is __pa(KSP) */			;\
+	tophys  (r30,r1)					;\
+	l.sw    PT_GPR12(r30),r12				;\
+	l.mfspr r12,r0,SPR_EPCR_BASE				;\
+	l.sw    PT_PC(r30),r12					;\
+	l.mfspr r12,r0,SPR_ESR_BASE				;\
+	l.sw    PT_SR(r30),r12					;\
+	/* save r30 */						;\
+	EXCEPTION_T_LOAD_GPR30(r12)				;\
+	l.sw	PT_GPR30(r30),r12				;\
+	/* save r10 as was prior to exception */		;\
+	EXCEPTION_T_LOAD_GPR10(r12)				;\
+	l.sw	PT_GPR10(r30),r12				;\
+	/* save PT_SP as was prior to exception */		;\
+	EXCEPTION_T_LOAD_SP(r12)				;\
+	l.sw	PT_SP(r30),r12					;\
+	/* save exception r4, set r4 = EA */			;\
+	l.sw	PT_GPR4(r30),r4					;\
+	l.mfspr r4,r0,SPR_EEAR_BASE				;\
+	/* r12 == 1 if we come from syscall */			;\
+	CLEAR_GPR(r12)						;\
+	/* ----- turn on MMU ----- */				;\
+	l.ori	r30,r0,(EXCEPTION_SR)				;\
+	l.mtspr	r0,r30,SPR_ESR_BASE				;\
+	/* r30:	EA address of handler */			;\
+	LOAD_SYMBOL_2_GPR(r30,handler)				;\
+	l.mtspr r0,r30,SPR_EPCR_BASE				;\
+	l.rfe
+
+/*
+ * this doesn't work
+ *
+ *
+ * #ifdef CONFIG_JUMP_UPON_UNHANDLED_EXCEPTION
+ * #define UNHANDLED_EXCEPTION(handler)				\
+ *	l.ori   r3,r0,0x1					;\
+ *	l.mtspr r0,r3,SPR_SR					;\
+ *      l.movhi r3,hi(0xf0000100)				;\
+ *      l.ori   r3,r3,lo(0xf0000100)				;\
+ *	l.jr	r3						;\
+ *	l.nop	1
+ *
+ * #endif
+ */
+
+/* DSCR: this is the same as EXCEPTION_HANDLE(), we are just
+ *       a bit more carefull (if we have a PT_SP or current pointer
+ *       corruption) and set them up from 'current_set'
+ *
+ */
+#define UNHANDLED_EXCEPTION(handler)				\
+	EXCEPTION_T_STORE_GPR31					;\
+	EXCEPTION_T_STORE_GPR10					;\
+	EXCEPTION_T_STORE_SP					;\
+	/* temporary store r3, r9 into r1, r10 */		;\
+	l.addi	r1,r3,0x0					;\
+	l.addi	r10,r9,0x0					;\
+	/* the string referenced by r3 must be low enough */	;\
+	l.jal	_emergency_print				;\
+	l.ori	r3,r0,lo(_string_unhandled_exception)		;\
+	l.mfspr	r3,r0,SPR_NPC					;\
+	l.jal	_emergency_print_nr				;\
+	l.andi	r3,r3,0x1f00					;\
+	/* the string referenced by r3 must be low enough */	;\
+	l.jal	_emergency_print				;\
+	l.ori	r3,r0,lo(_string_epc_prefix)			;\
+	l.jal	_emergency_print_nr				;\
+	l.mfspr	r3,r0,SPR_EPCR_BASE				;\
+	l.jal	_emergency_print				;\
+	l.ori	r3,r0,lo(_string_nl)				;\
+	/* end of printing */					;\
+	l.addi	r3,r1,0x0					;\
+	l.addi	r9,r10,0x0					;\
+	/* extract current, ksp from current_set */		;\
+	LOAD_SYMBOL_2_GPR(r1,_unhandled_stack_top)		;\
+	LOAD_SYMBOL_2_GPR(r10,init_thread_union)		;\
+	/* create new stack frame, save only needed gprs */	;\
+	/* r1: KSP, r10: current, r31: __pa(KSP) */		;\
+	/* r12:	temp, syscall indicator, r13 temp */		;\
+	l.addi  r1,r1,-(INT_FRAME_SIZE)				;\
+	/* r1 is KSP, r31 is __pa(KSP) */			;\
+	tophys  (r31,r1)					;\
+	l.sw    PT_GPR12(r31),r12					;\
+	l.mfspr r12,r0,SPR_EPCR_BASE				;\
+	l.sw    PT_PC(r31),r12					;\
+	l.mfspr r12,r0,SPR_ESR_BASE				;\
+	l.sw    PT_SR(r31),r12					;\
+	/* save r31 */						;\
+	EXCEPTION_T_LOAD_GPR31(r12)				;\
+	l.sw	PT_GPR31(r31),r12					;\
+	/* save r10 as was prior to exception */		;\
+	EXCEPTION_T_LOAD_GPR10(r12)				;\
+	l.sw	PT_GPR10(r31),r12					;\
+	/* save PT_SP as was prior to exception */			;\
+	EXCEPTION_T_LOAD_SP(r12)				;\
+	l.sw	PT_SP(r31),r12					;\
+	l.sw    PT_GPR13(r31),r13					;\
+	/* --> */						;\
+	/* save exception r4, set r4 = EA */			;\
+	l.sw	PT_GPR4(r31),r4					;\
+	l.mfspr r4,r0,SPR_EEAR_BASE				;\
+	/* r12 == 1 if we come from syscall */			;\
+	CLEAR_GPR(r12)						;\
+	/* ----- play a MMU trick ----- */			;\
+	l.ori	r31,r0,(EXCEPTION_SR)				;\
+	l.mtspr	r0,r31,SPR_ESR_BASE				;\
+	/* r31:	EA address of handler */			;\
+	LOAD_SYMBOL_2_GPR(r31,handler)				;\
+	l.mtspr r0,r31,SPR_EPCR_BASE				;\
+	l.rfe
+
+/* =====================================================[ exceptions] === */
+
+/* ---[ 0x100: RESET exception ]----------------------------------------- */
+    .org 0x100
+	/* Jump to .init code at _start which lives in the .head section
+	 * and will be discarded after boot.
+	 */
+	LOAD_SYMBOL_2_GPR(r4, _start)
+	tophys	(r3,r4)			/* MMU disabled */
+	l.jr	r3
+	 l.nop
+
+/* ---[ 0x200: BUS exception ]------------------------------------------- */
+    .org 0x200
+_dispatch_bus_fault:
+	EXCEPTION_HANDLE(_bus_fault_handler)
+
+/* ---[ 0x300: Data Page Fault exception ]------------------------------- */
+    .org 0x300
+_dispatch_do_dpage_fault:
+//      totaly disable timer interrupt
+// 	l.mtspr	r0,r0,SPR_TTMR
+//	DEBUG_TLB_PROBE(0x300)
+//	EXCEPTION_DEBUG_VALUE_ER_ENABLED(0x300)
+	EXCEPTION_HANDLE(_data_page_fault_handler)
+
+/* ---[ 0x400: Insn Page Fault exception ]------------------------------- */
+    .org 0x400
+_dispatch_do_ipage_fault:
+//      totaly disable timer interrupt
+//	l.mtspr	r0,r0,SPR_TTMR
+//	DEBUG_TLB_PROBE(0x400)
+//	EXCEPTION_DEBUG_VALUE_ER_ENABLED(0x400)
+	EXCEPTION_HANDLE(_insn_page_fault_handler)
+
+/* ---[ 0x500: Timer exception ]----------------------------------------- */
+    .org 0x500
+	EXCEPTION_HANDLE(_timer_handler)
+
+/* ---[ 0x600: Aligment exception ]-------------------------------------- */
+    .org 0x600
+	EXCEPTION_HANDLE(_alignment_handler)
+
+/* ---[ 0x700: Illegal insn exception ]---------------------------------- */
+    .org 0x700
+	EXCEPTION_HANDLE(_illegal_instruction_handler)
+
+/* ---[ 0x800: External interrupt exception ]---------------------------- */
+    .org 0x800
+	EXCEPTION_HANDLE(_external_irq_handler)
+
+/* ---[ 0x900: DTLB miss exception ]------------------------------------- */
+    .org 0x900
+	l.j	boot_dtlb_miss_handler
+	l.nop
+
+/* ---[ 0xa00: ITLB miss exception ]------------------------------------- */
+    .org 0xa00
+	l.j	boot_itlb_miss_handler
+	l.nop
+
+/* ---[ 0xb00: Range exception ]----------------------------------------- */
+    .org 0xb00
+	UNHANDLED_EXCEPTION(_vector_0xb00)
+
+/* ---[ 0xc00: Syscall exception ]--------------------------------------- */
+    .org 0xc00
+	EXCEPTION_HANDLE(_sys_call_handler)
+
+/* ---[ 0xd00: Trap exception ]------------------------------------------ */
+    .org 0xd00
+	UNHANDLED_EXCEPTION(_vector_0xd00)
+
+/* ---[ 0xe00: Trap exception ]------------------------------------------ */
+    .org 0xe00
+//	UNHANDLED_EXCEPTION(_vector_0xe00)
+	EXCEPTION_HANDLE(_trap_handler)
+
+/* ---[ 0xf00: Reserved exception ]-------------------------------------- */
+    .org 0xf00
+	UNHANDLED_EXCEPTION(_vector_0xf00)
+
+/* ---[ 0x1000: Reserved exception ]------------------------------------- */
+    .org 0x1000
+	UNHANDLED_EXCEPTION(_vector_0x1000)
+
+/* ---[ 0x1100: Reserved exception ]------------------------------------- */
+    .org 0x1100
+	UNHANDLED_EXCEPTION(_vector_0x1100)
+
+/* ---[ 0x1200: Reserved exception ]------------------------------------- */
+    .org 0x1200
+	UNHANDLED_EXCEPTION(_vector_0x1200)
+
+/* ---[ 0x1300: Reserved exception ]------------------------------------- */
+    .org 0x1300
+	UNHANDLED_EXCEPTION(_vector_0x1300)
+
+/* ---[ 0x1400: Reserved exception ]------------------------------------- */
+    .org 0x1400
+	UNHANDLED_EXCEPTION(_vector_0x1400)
+
+/* ---[ 0x1500: Reserved exception ]------------------------------------- */
+    .org 0x1500
+	UNHANDLED_EXCEPTION(_vector_0x1500)
+
+/* ---[ 0x1600: Reserved exception ]------------------------------------- */
+    .org 0x1600
+	UNHANDLED_EXCEPTION(_vector_0x1600)
+
+/* ---[ 0x1700: Reserved exception ]------------------------------------- */
+    .org 0x1700
+	UNHANDLED_EXCEPTION(_vector_0x1700)
+
+/* ---[ 0x1800: Reserved exception ]------------------------------------- */
+    .org 0x1800
+	UNHANDLED_EXCEPTION(_vector_0x1800)
+
+/* ---[ 0x1900: Reserved exception ]------------------------------------- */
+    .org 0x1900
+	UNHANDLED_EXCEPTION(_vector_0x1900)
+
+/* ---[ 0x1a00: Reserved exception ]------------------------------------- */
+    .org 0x1a00
+	UNHANDLED_EXCEPTION(_vector_0x1a00)
+
+/* ---[ 0x1b00: Reserved exception ]------------------------------------- */
+    .org 0x1b00
+	UNHANDLED_EXCEPTION(_vector_0x1b00)
+
+/* ---[ 0x1c00: Reserved exception ]------------------------------------- */
+    .org 0x1c00
+	UNHANDLED_EXCEPTION(_vector_0x1c00)
+
+/* ---[ 0x1d00: Reserved exception ]------------------------------------- */
+    .org 0x1d00
+	UNHANDLED_EXCEPTION(_vector_0x1d00)
+
+/* ---[ 0x1e00: Reserved exception ]------------------------------------- */
+    .org 0x1e00
+	UNHANDLED_EXCEPTION(_vector_0x1e00)
+
+/* ---[ 0x1f00: Reserved exception ]------------------------------------- */
+    .org 0x1f00
+	UNHANDLED_EXCEPTION(_vector_0x1f00)
+
+    .org 0x2000
+/* ===================================================[ kernel start ]=== */
+
+/*    .text*/
+
+/* This early stuff belongs in HEAD, but some of the functions below definitely
+ * don't... */
+
+	__HEAD
+	.global _start
+_start:
+	/*
+	 * ensure a deterministic start
+	 */
+
+	l.ori	r3,r0,0x1
+	l.mtspr	r0,r3,SPR_SR
+
+	CLEAR_GPR(r1)
+	CLEAR_GPR(r2)
+	CLEAR_GPR(r3)
+	CLEAR_GPR(r4)
+	CLEAR_GPR(r5)
+	CLEAR_GPR(r6)
+	CLEAR_GPR(r7)
+	CLEAR_GPR(r8)
+	CLEAR_GPR(r9)
+	CLEAR_GPR(r10)
+	CLEAR_GPR(r11)
+	CLEAR_GPR(r12)
+	CLEAR_GPR(r13)
+	CLEAR_GPR(r14)
+	CLEAR_GPR(r15)
+	CLEAR_GPR(r16)
+	CLEAR_GPR(r17)
+	CLEAR_GPR(r18)
+	CLEAR_GPR(r19)
+	CLEAR_GPR(r20)
+	CLEAR_GPR(r21)
+	CLEAR_GPR(r22)
+	CLEAR_GPR(r23)
+	CLEAR_GPR(r24)
+	CLEAR_GPR(r25)
+	CLEAR_GPR(r26)
+	CLEAR_GPR(r27)
+	CLEAR_GPR(r28)
+	CLEAR_GPR(r29)
+	CLEAR_GPR(r30)
+	CLEAR_GPR(r31)
+
+	/*
+	 * set up initial ksp and current
+	 */
+	LOAD_SYMBOL_2_GPR(r1,init_thread_union+0x2000)	// setup kernel stack
+	LOAD_SYMBOL_2_GPR(r10,init_thread_union)	// setup current
+	tophys	(r31,r10)
+	l.sw	TI_KSP(r31), r1
+
+	l.ori	r4,r0,0x0
+
+
+	/*
+	 * .data contains initialized data,
+	 * .bss contains uninitialized data - clear it up
+	 */
+clear_bss:
+	LOAD_SYMBOL_2_GPR(r24, __bss_start)
+	LOAD_SYMBOL_2_GPR(r26, _end)
+	tophys(r28,r24)
+	tophys(r30,r26)
+	CLEAR_GPR(r24)
+	CLEAR_GPR(r26)
+1:
+	l.sw    (0)(r28),r0
+	l.sfltu r28,r30
+	l.bf    1b
+	l.addi  r28,r28,4
+
+enable_ic:
+	l.jal	_ic_enable
+	 l.nop
+
+enable_dc:
+	l.jal	_dc_enable
+	 l.nop
+
+flush_tlb:
+	/*
+	 *  I N V A L I D A T E   T L B   e n t r i e s
+	 */
+	LOAD_SYMBOL_2_GPR(r5,SPR_DTLBMR_BASE(0))
+	LOAD_SYMBOL_2_GPR(r6,SPR_ITLBMR_BASE(0))
+	l.addi	r7,r0,128 /* Maximum number of sets */
+1:
+	l.mtspr	r5,r0,0x0
+	l.mtspr	r6,r0,0x0
+
+	l.addi	r5,r5,1
+	l.addi	r6,r6,1
+	l.sfeq	r7,r0
+	l.bnf	1b
+	 l.addi	r7,r7,-1
+
+
+/* The MMU needs to be enabled before or32_early_setup is called */
+
+enable_mmu:
+	/*
+	 * enable dmmu & immu
+	 * SR[5] = 0, SR[6] = 0, 6th and 7th bit of SR set to 0
+	 */
+	l.mfspr	r30,r0,SPR_SR
+	l.movhi	r28,hi(SPR_SR_DME | SPR_SR_IME)
+	l.ori	r28,r28,lo(SPR_SR_DME | SPR_SR_IME)
+	l.or	r30,r30,r28
+	l.mtspr	r0,r30,SPR_SR
+	l.nop
+	l.nop
+	l.nop
+	l.nop
+	l.nop
+	l.nop
+	l.nop
+	l.nop
+	l.nop
+	l.nop
+	l.nop
+	l.nop
+	l.nop
+	l.nop
+	l.nop
+	l.nop
+
+	// reset the simulation counters
+	l.nop 5
+
+	LOAD_SYMBOL_2_GPR(r24, or32_early_setup)
+	l.jalr r24
+	 l.nop
+
+clear_regs:
+	/*
+	 * clear all GPRS to increase determinism
+	 */
+	CLEAR_GPR(r2)
+	CLEAR_GPR(r3)
+	CLEAR_GPR(r4)
+	CLEAR_GPR(r5)
+	CLEAR_GPR(r6)
+	CLEAR_GPR(r7)
+	CLEAR_GPR(r8)
+	CLEAR_GPR(r9)
+	CLEAR_GPR(r11)
+	CLEAR_GPR(r12)
+	CLEAR_GPR(r13)
+	CLEAR_GPR(r14)
+	CLEAR_GPR(r15)
+	CLEAR_GPR(r16)
+	CLEAR_GPR(r17)
+	CLEAR_GPR(r18)
+	CLEAR_GPR(r19)
+	CLEAR_GPR(r20)
+	CLEAR_GPR(r21)
+	CLEAR_GPR(r22)
+	CLEAR_GPR(r23)
+	CLEAR_GPR(r24)
+	CLEAR_GPR(r25)
+	CLEAR_GPR(r26)
+	CLEAR_GPR(r27)
+	CLEAR_GPR(r28)
+	CLEAR_GPR(r29)
+	CLEAR_GPR(r30)
+	CLEAR_GPR(r31)
+
+jump_start_kernel:
+	/*
+	 * jump to kernel entry (start_kernel)
+	 */
+	LOAD_SYMBOL_2_GPR(r30, start_kernel)
+	l.jr    r30
+	 l.nop
+
+/* ========================================[ cache ]=== */
+
+	/* aligment here so we don't change memory offsets with
+	 * memory controler defined
+	 */
+	.align 0x2000
+
+_ic_enable:
+	/* Check if IC present and skip enabling otherwise */
+	l.mfspr r24,r0,SPR_UPR
+	l.andi  r26,r24,SPR_UPR_ICP
+	l.sfeq  r26,r0
+	l.bf	9f
+	l.nop
+
+	/* Disable IC */
+	l.mfspr r6,r0,SPR_SR
+	l.addi  r5,r0,-1
+	l.xori  r5,r5,SPR_SR_ICE
+	l.and   r5,r6,r5
+	l.mtspr r0,r5,SPR_SR
+
+	/* Establish cache block size
+	   If BS=0, 16;
+	   If BS=1, 32;
+	   r14 contain block size
+	*/
+	l.mfspr r24,r0,SPR_ICCFGR
+	l.andi	r26,r24,SPR_ICCFGR_CBS
+	l.srli	r28,r26,7
+	l.ori	r30,r0,16
+	l.sll	r14,r30,r28
+
+	/* Establish number of cache sets
+	   r16 contains number of cache sets
+	   r28 contains log(# of cache sets)
+	*/
+	l.andi  r26,r24,SPR_ICCFGR_NCS
+	l.srli 	r28,r26,3
+	l.ori   r30,r0,1
+	l.sll   r16,r30,r28
+
+	/* Invalidate IC */
+	l.addi  r6,r0,0
+	l.sll   r5,r14,r28
+//        l.mul   r5,r14,r16
+//	l.trap  1
+//	l.addi  r5,r0,IC_SIZE
+1:
+	l.mtspr r0,r6,SPR_ICBIR
+	l.sfne  r6,r5
+	l.bf    1b
+	l.add   r6,r6,r14
+ //       l.addi   r6,r6,IC_LINE
+
+	/* Enable IC */
+	l.mfspr r6,r0,SPR_SR
+	l.ori   r6,r6,SPR_SR_ICE
+	l.mtspr r0,r6,SPR_SR
+	l.nop
+	l.nop
+	l.nop
+	l.nop
+	l.nop
+	l.nop
+	l.nop
+	l.nop
+	l.nop
+	l.nop
+9:
+	l.jr    r9
+	l.nop
+
+_dc_enable:
+	/* Check if DC present and skip enabling otherwise */
+	l.mfspr r24,r0,SPR_UPR
+	l.andi  r26,r24,SPR_UPR_DCP
+	l.sfeq  r26,r0
+	l.bf	9f
+	l.nop
+
+	/* Disable DC */
+	l.mfspr r6,r0,SPR_SR
+	l.addi  r5,r0,-1
+	l.xori  r5,r5,SPR_SR_DCE
+	l.and   r5,r6,r5
+	l.mtspr r0,r5,SPR_SR
+
+	/* Establish cache block size
+	   If BS=0, 16;
+	   If BS=1, 32;
+	   r14 contain block size
+	*/
+	l.mfspr r24,r0,SPR_DCCFGR
+	l.andi	r26,r24,SPR_DCCFGR_CBS
+	l.srli	r28,r26,7
+	l.ori	r30,r0,16
+	l.sll	r14,r30,r28
+
+	/* Establish number of cache sets
+	   r16 contains number of cache sets
+	   r28 contains log(# of cache sets)
+	*/
+	l.andi  r26,r24,SPR_DCCFGR_NCS
+	l.srli 	r28,r26,3
+	l.ori   r30,r0,1
+	l.sll   r16,r30,r28
+
+	/* Invalidate DC */
+	l.addi  r6,r0,0
+	l.sll   r5,r14,r28
+1:
+	l.mtspr r0,r6,SPR_DCBIR
+	l.sfne  r6,r5
+	l.bf    1b
+	l.add   r6,r6,r14
+
+	/* Enable DC */
+	l.mfspr r6,r0,SPR_SR
+	l.ori   r6,r6,SPR_SR_DCE
+	l.mtspr r0,r6,SPR_SR
+9:
+	l.jr    r9
+	l.nop
+
+/* ===============================================[ page table masks ]=== */
+
+/* bit 4 is used in hardware as write back cache bit. we never use this bit
+ * explicitly, so we can reuse it as _PAGE_FILE bit and mask it out when
+ * writing into hardware pte's
+ */
+
+#define DTLB_UP_CONVERT_MASK  0x3fa
+#define ITLB_UP_CONVERT_MASK  0x3a
+
+/* for SMP we'd have (this is a bit subtle, CC must be always set
+ * for SMP, but since we have _PAGE_PRESENT bit always defined
+ * we can just modify the mask)
+ */
+#define DTLB_SMP_CONVERT_MASK  0x3fb
+#define ITLB_SMP_CONVERT_MASK  0x3b
+
+/* ---[ boot dtlb miss handler ]----------------------------------------- */
+
+boot_dtlb_miss_handler:
+
+/* mask for DTLB_MR register: - (0) sets V (valid) bit,
+ *                            - (31-12) sets bits belonging to VPN (31-12)
+ */
+#define DTLB_MR_MASK 0xfffff001
+
+/* mask for DTLB_TR register: - (2) sets CI (cache inhibit) bit,
+ *			      - (4) sets A (access) bit,
+ *                            - (5) sets D (dirty) bit,
+ *                            - (8) sets SRE (superuser read) bit
+ *                            - (9) sets SWE (superuser write) bit
+ *                            - (31-12) sets bits belonging to VPN (31-12)
+ */
+#define DTLB_TR_MASK 0xfffff332
+
+/* These are for masking out the VPN/PPN value from the MR/TR registers...
+ * it's not the same as the PFN */
+#define VPN_MASK 0xfffff000
+#define PPN_MASK 0xfffff000
+
+
+	EXCEPTION_STORE_GPR6
+
+#if 0
+	l.mfspr r6,r0,SPR_ESR_BASE	   //
+	l.andi  r6,r6,SPR_SR_SM            // are we in kernel mode ?
+	l.sfeqi r6,0                       // r6 == 0x1 --> SM
+	l.bf    exit_with_no_dtranslation  //
+	l.nop
+#endif
+
+	/* this could be optimized by moving storing of
+	 * non r6 registers here, and jumping r6 restore
+	 * if not in supervisor mode
+	 */
+
+	EXCEPTION_STORE_GPR2
+	EXCEPTION_STORE_GPR3
+	EXCEPTION_STORE_GPR4
+	EXCEPTION_STORE_GPR5
+
+	l.mfspr r4,r0,SPR_EEAR_BASE        // get the offending EA
+
+immediate_translation:
+	CLEAR_GPR(r6)
+
+	l.srli	r3,r4,0xd                  // r3 <- r4 / 8192 (sets are relative to page size (8Kb) NOT VPN size (4Kb)
+
+	l.mfspr r6, r0, SPR_DMMUCFGR
+	l.andi	r6, r6, SPR_DMMUCFGR_NTS
+	l.srli	r6, r6, SPR_DMMUCFGR_NTS_OFF
+	l.ori	r5, r0, 0x1
+	l.sll	r5, r5, r6 	// r5 = number DMMU sets
+	l.addi	r6, r5, -1  	// r6 = nsets mask
+	l.and	r2, r3, r6	// r2 <- r3 % NSETS_MASK
+
+	l.or    r6,r6,r4                   // r6 <- r4
+	l.ori   r6,r6,~(VPN_MASK)          // r6 <- VPN :VPN .xfff - clear up lo(r6) to 0x**** *fff
+	l.movhi r5,hi(DTLB_MR_MASK)        // r5 <- ffff:0000.x000
+	l.ori   r5,r5,lo(DTLB_MR_MASK)     // r5 <- ffff:1111.x001 - apply DTLB_MR_MASK
+	l.and   r5,r5,r6                   // r5 <- VPN :VPN .x001 - we have DTLBMR entry
+	l.mtspr r2,r5,SPR_DTLBMR_BASE(0)   // set DTLBMR
+
+	/* set up DTLB with no translation for EA <= 0xbfffffff */
+	LOAD_SYMBOL_2_GPR(r6,0xbfffffff)
+	l.sfgeu  r6,r4                     // flag if r6 >= r4 (if 0xbfffffff >= EA)
+	l.bf     1f                        // goto out
+	l.and    r3,r4,r4                  // delay slot :: 24 <- r4 (if flag==1)
+
+	tophys(r3,r4)                      // r3 <- PA
+1:
+	l.ori   r3,r3,~(PPN_MASK)          // r3 <- PPN :PPN .xfff - clear up lo(r6) to 0x**** *fff
+	l.movhi r5,hi(DTLB_TR_MASK)        // r5 <- ffff:0000.x000
+	l.ori   r5,r5,lo(DTLB_TR_MASK)     // r5 <- ffff:1111.x330 - apply DTLB_MR_MASK
+	l.and   r5,r5,r3                   // r5 <- PPN :PPN .x330 - we have DTLBTR entry
+	l.mtspr r2,r5,SPR_DTLBTR_BASE(0)   // set DTLBTR
+
+	EXCEPTION_LOAD_GPR6
+	EXCEPTION_LOAD_GPR5
+	EXCEPTION_LOAD_GPR4
+	EXCEPTION_LOAD_GPR3
+	EXCEPTION_LOAD_GPR2
+
+	l.rfe                              // SR <- ESR, PC <- EPC
+
+exit_with_no_dtranslation:
+	/* EA out of memory or not in supervisor mode */
+	EXCEPTION_LOAD_GPR6
+	EXCEPTION_LOAD_GPR4
+	l.j	_dispatch_bus_fault
+
+/* ---[ boot itlb miss handler ]----------------------------------------- */
+
+boot_itlb_miss_handler:
+
+/* mask for ITLB_MR register: - sets V (valid) bit,
+ *                            - sets bits belonging to VPN (15-12)
+ */
+#define ITLB_MR_MASK 0xfffff001
+
+/* mask for ITLB_TR register: - sets A (access) bit,
+ *                            - sets SXE (superuser execute) bit
+ *                            - sets bits belonging to VPN (15-12)
+ */
+#define ITLB_TR_MASK 0xfffff050
+
+/*
+#define VPN_MASK 0xffffe000
+#define PPN_MASK 0xffffe000
+*/
+
+
+
+	EXCEPTION_STORE_GPR2
+	EXCEPTION_STORE_GPR3
+	EXCEPTION_STORE_GPR4
+	EXCEPTION_STORE_GPR5
+	EXCEPTION_STORE_GPR6
+
+#if 0
+	l.mfspr r6,r0,SPR_ESR_BASE         //
+	l.andi  r6,r6,SPR_SR_SM            // are we in kernel mode ?
+	l.sfeqi r6,0                       // r6 == 0x1 --> SM
+	l.bf    exit_with_no_itranslation
+	l.nop
+#endif
+
+
+	l.mfspr r4,r0,SPR_EEAR_BASE        // get the offending EA
+
+earlyearly:
+	CLEAR_GPR(r6)
+
+	l.srli  r3,r4,0xd                  // r3 <- r4 / 8192 (sets are relative to page size (8Kb) NOT VPN size (4Kb)
+
+	l.mfspr r6, r0, SPR_IMMUCFGR
+	l.andi	r6, r6, SPR_IMMUCFGR_NTS
+	l.srli	r6, r6, SPR_IMMUCFGR_NTS_OFF
+	l.ori	r5, r0, 0x1
+	l.sll	r5, r5, r6 	// r5 = number IMMU sets from IMMUCFGR
+	l.addi	r6, r5, -1  	// r6 = nsets mask
+	l.and	r2, r3, r6	// r2 <- r3 % NSETS_MASK
+
+	l.or    r6,r6,r4                   // r6 <- r4
+	l.ori   r6,r6,~(VPN_MASK)          // r6 <- VPN :VPN .xfff - clear up lo(r6) to 0x**** *fff
+	l.movhi r5,hi(ITLB_MR_MASK)        // r5 <- ffff:0000.x000
+	l.ori   r5,r5,lo(ITLB_MR_MASK)     // r5 <- ffff:1111.x001 - apply ITLB_MR_MASK
+	l.and   r5,r5,r6                   // r5 <- VPN :VPN .x001 - we have ITLBMR entry
+	l.mtspr r2,r5,SPR_ITLBMR_BASE(0)   // set ITLBMR
+
+	/*
+	 * set up ITLB with no translation for EA <= 0x0fffffff
+	 *
+	 * we need this for head.S mapping (EA = PA). if we move all functions
+	 * which run with mmu enabled into entry.S, we might be able to eliminate this.
+	 *
+	 */
+	LOAD_SYMBOL_2_GPR(r6,0x0fffffff)
+	l.sfgeu  r6,r4                     // flag if r6 >= r4 (if 0xb0ffffff >= EA)
+	l.bf     1f                        // goto out
+	l.and    r3,r4,r4                  // delay slot :: 24 <- r4 (if flag==1)
+
+	tophys(r3,r4)                      // r3 <- PA
+1:
+	l.ori   r3,r3,~(PPN_MASK)          // r3 <- PPN :PPN .xfff - clear up lo(r6) to 0x**** *fff
+	l.movhi r5,hi(ITLB_TR_MASK)        // r5 <- ffff:0000.x000
+	l.ori   r5,r5,lo(ITLB_TR_MASK)     // r5 <- ffff:1111.x050 - apply ITLB_MR_MASK
+	l.and   r5,r5,r3                   // r5 <- PPN :PPN .x050 - we have ITLBTR entry
+	l.mtspr r2,r5,SPR_ITLBTR_BASE(0)   // set ITLBTR
+
+	EXCEPTION_LOAD_GPR6
+	EXCEPTION_LOAD_GPR5
+	EXCEPTION_LOAD_GPR4
+	EXCEPTION_LOAD_GPR3
+	EXCEPTION_LOAD_GPR2
+
+	l.rfe                              // SR <- ESR, PC <- EPC
+
+exit_with_no_itranslation:
+	EXCEPTION_LOAD_GPR4
+	EXCEPTION_LOAD_GPR6
+	l.j    _dispatch_bus_fault
+	l.nop
+
+/* ====================================================================== */
+/*
+ * Stuff below here shouldn't go into .head section... maybe this stuff
+ * can be moved to entry.S ???
+ */
+
+/* ==============================================[ DTLB miss handler ]=== */
+
+/*
+ * Comments:
+ *   Exception handlers are entered with MMU off so the following handler
+ *   needs to use physical addressing
+ *
+ */
+
+	.text
+ENTRY(dtlb_miss_handler)
+	EXCEPTION_STORE_GPR2
+	EXCEPTION_STORE_GPR3
+	EXCEPTION_STORE_GPR4
+	EXCEPTION_STORE_GPR5
+	EXCEPTION_STORE_GPR6
+	/*
+	 * get EA of the miss
+	 */
+	l.mfspr	r2,r0,SPR_EEAR_BASE
+	/*
+	 * pmd = (pmd_t *)(current_pgd + pgd_index(daddr));
+	 */
+	GET_CURRENT_PGD(r3,r5)		// r3 is current_pgd, r5 is temp
+	l.srli	r4,r2,0x18		// >> PAGE_SHIFT + (PAGE_SHIFT - 2)
+	l.slli	r4,r4,0x2		// to get address << 2
+	l.add	r5,r4,r3		// r4 is pgd_index(daddr)
+	/*
+	 * if (pmd_none(*pmd))
+	 *   goto pmd_none:
+	 */
+	tophys	(r4,r5)
+	l.lwz	r3,0x0(r4)		// get *pmd value
+	l.sfne	r3,r0
+	l.bnf	d_pmd_none
+	 l.andi	r3,r3,~PAGE_MASK //0x1fff		// ~PAGE_MASK
+	/*
+	 * if (pmd_bad(*pmd))
+	 *   pmd_clear(pmd)
+	 *   goto pmd_bad:
+	 */
+//	l.sfeq	r3,r0			// check *pmd value
+//	l.bf	d_pmd_good
+	l.addi	r3,r0,0xffffe000	// PAGE_MASK
+//	l.j	d_pmd_bad
+//	l.sw	0x0(r4),r0		// clear pmd
+d_pmd_good:
+	/*
+	 * pte = *pte_offset(pmd, daddr);
+	 */
+	l.lwz	r4,0x0(r4)		// get **pmd value
+	l.and	r4,r4,r3		// & PAGE_MASK
+	l.srli	r5,r2,0xd		// >> PAGE_SHIFT, r2 == EEAR
+	l.andi	r3,r5,0x7ff		// (1UL << PAGE_SHIFT - 2) - 1
+	l.slli	r3,r3,0x2		// to get address << 2
+	l.add	r3,r3,r4
+	l.lwz	r2,0x0(r3)		// this is pte at last
+	/*
+	 * if (!pte_present(pte))
+	 */
+	l.andi	r4,r2,0x1
+	l.sfne	r4,r0			// is pte present
+	l.bnf	d_pte_not_present
+	l.addi	r3,r0,0xffffe3fa	// PAGE_MASK | DTLB_UP_CONVERT_MASK
+	/*
+	 * fill DTLB TR register
+	 */
+	l.and	r4,r2,r3		// apply the mask
+	// Determine number of DMMU sets
+	l.mfspr r6, r0, SPR_DMMUCFGR
+	l.andi	r6, r6, SPR_DMMUCFGR_NTS
+	l.srli	r6, r6, SPR_DMMUCFGR_NTS_OFF
+	l.ori	r3, r0, 0x1
+	l.sll	r3, r3, r6 	// r3 = number DMMU sets DMMUCFGR
+	l.addi	r6, r3, -1  	// r6 = nsets mask
+	l.and	r5, r5, r6	// calc offset:	 & (NUM_TLB_ENTRIES-1)
+	                                                   //NUM_TLB_ENTRIES
+	l.mtspr	r5,r4,SPR_DTLBTR_BASE(0)
+	/*
+	 * fill DTLB MR register
+	 */
+	l.mfspr	r2,r0,SPR_EEAR_BASE
+	l.addi	r3,r0,0xffffe000	// PAGE_MASK
+	l.and	r4,r2,r3		// apply PAGE_MASK to EA (__PHX__ do we really need this?)
+	l.ori	r4,r4,0x1		// set hardware valid bit: DTBL_MR entry
+	l.mtspr	r5,r4,SPR_DTLBMR_BASE(0)
+
+	EXCEPTION_LOAD_GPR2
+	EXCEPTION_LOAD_GPR3
+	EXCEPTION_LOAD_GPR4
+	EXCEPTION_LOAD_GPR5
+	EXCEPTION_LOAD_GPR6
+	l.rfe
+d_pmd_bad:
+	l.nop	1
+	EXCEPTION_LOAD_GPR2
+	EXCEPTION_LOAD_GPR3
+	EXCEPTION_LOAD_GPR4
+	EXCEPTION_LOAD_GPR5
+	EXCEPTION_LOAD_GPR6
+	l.rfe
+d_pmd_none:
+d_pte_not_present:
+	EXCEPTION_LOAD_GPR2
+	EXCEPTION_LOAD_GPR3
+	EXCEPTION_LOAD_GPR4
+	EXCEPTION_LOAD_GPR5
+	EXCEPTION_LOAD_GPR6
+	l.j	_dispatch_do_dpage_fault
+	l.nop
+
+/* ==============================================[ ITLB miss handler ]=== */
+ENTRY(itlb_miss_handler)
+	EXCEPTION_STORE_GPR2
+	EXCEPTION_STORE_GPR3
+	EXCEPTION_STORE_GPR4
+	EXCEPTION_STORE_GPR5
+	EXCEPTION_STORE_GPR6
+	/*
+	 * get EA of the miss
+	 */
+	l.mfspr	r2,r0,SPR_EEAR_BASE
+
+	/*
+	 * pmd = (pmd_t *)(current_pgd + pgd_index(daddr));
+	 *
+	 */
+	GET_CURRENT_PGD(r3,r5)		// r3 is current_pgd, r5 is temp
+	l.srli	r4,r2,0x18		// >> PAGE_SHIFT + (PAGE_SHIFT - 2)
+	l.slli	r4,r4,0x2		// to get address << 2
+	l.add	r5,r4,r3		// r4 is pgd_index(daddr)
+	/*
+	 * if (pmd_none(*pmd))
+	 *   goto pmd_none:
+	 */
+	tophys	(r4,r5)
+	l.lwz	r3,0x0(r4)		// get *pmd value
+	l.sfne	r3,r0
+	l.bnf	i_pmd_none
+	l.andi	r3,r3,0x1fff		// ~PAGE_MASK
+	/*
+	 * if (pmd_bad(*pmd))
+	 *   pmd_clear(pmd)
+	 *   goto pmd_bad:
+	 */
+
+//	l.sfeq	r3,r0			// check *pmd value
+//	l.bf	i_pmd_good
+	l.addi	r3,r0,0xffffe000	// PAGE_MASK
+//	l.j	i_pmd_bad
+//	l.sw	0x0(r4),r0		// clear pmd
+
+i_pmd_good:
+	/*
+	 * pte = *pte_offset(pmd, iaddr);
+	 *
+	 */
+	l.lwz	r4,0x0(r4)		// get **pmd value
+	l.and	r4,r4,r3		// & PAGE_MASK
+	l.srli	r5,r2,0xd		// >> PAGE_SHIFT, r2 == EEAR
+	l.andi	r3,r5,0x7ff		// (1UL << PAGE_SHIFT - 2) - 1
+	l.slli	r3,r3,0x2		// to get address << 2
+	l.add	r3,r3,r4
+	l.lwz	r2,0x0(r3)		// this is pte at last
+	/*
+	 * if (!pte_present(pte))
+	 *
+	 */
+	l.andi	r4,r2,0x1
+	l.sfne	r4,r0			// is pte present
+	l.bnf	i_pte_not_present
+	l.addi	r3,r0,0xffffe03a	// PAGE_MASK | ITLB_UP_CONVERT_MASK
+	/*
+	 * fill ITLB TR register
+	 */
+	l.and	r4,r2,r3		// apply the mask
+	l.andi	r3,r2,0x7c0		// _PAGE_EXEC | _PAGE_SRE | _PAGE_SWE |  _PAGE_URE | _PAGE_UWE
+//	l.andi	r3,r2,0x400		// _PAGE_EXEC
+	l.sfeq	r3,r0
+	l.bf	itlb_tr_fill //_workaround
+	// Determine number of IMMU sets
+	l.mfspr r6, r0, SPR_IMMUCFGR
+	l.andi	r6, r6, SPR_IMMUCFGR_NTS
+	l.srli	r6, r6, SPR_IMMUCFGR_NTS_OFF
+	l.ori	r3, r0, 0x1
+	l.sll	r3, r3, r6 	// r3 = number IMMU sets IMMUCFGR
+	l.addi	r6, r3, -1  	// r6 = nsets mask
+	l.and	r5, r5, r6	// calc offset:	 & (NUM_TLB_ENTRIES-1)
+
+/*
+ * __PHX__ :: fixme
+ * we should not just blindly set executable flags,
+ * but it does help with ping. the clean way would be to find out
+ * (and fix it) why stack doesn't have execution permissions
+ */
+
+itlb_tr_fill_workaround:
+	l.ori	r4,r4,0xc0		// | (SPR_ITLBTR_UXE | ITLBTR_SXE)
+itlb_tr_fill:
+	l.mtspr	r5,r4,SPR_ITLBTR_BASE(0)
+	/*
+	 * fill DTLB MR register
+	 */
+	l.mfspr	r2,r0,SPR_EEAR_BASE
+	l.addi	r3,r0,0xffffe000	// PAGE_MASK
+	l.and	r4,r2,r3		// apply PAGE_MASK to EA (__PHX__ do we really need this?)
+	l.ori	r4,r4,0x1		// set hardware valid bit: DTBL_MR entry
+	l.mtspr	r5,r4,SPR_ITLBMR_BASE(0)
+
+	EXCEPTION_LOAD_GPR2
+	EXCEPTION_LOAD_GPR3
+	EXCEPTION_LOAD_GPR4
+	EXCEPTION_LOAD_GPR5
+	EXCEPTION_LOAD_GPR6
+	l.rfe
+
+i_pmd_bad:
+	l.nop	1
+	EXCEPTION_LOAD_GPR2
+	EXCEPTION_LOAD_GPR3
+	EXCEPTION_LOAD_GPR4
+	EXCEPTION_LOAD_GPR5
+	EXCEPTION_LOAD_GPR6
+	l.rfe
+i_pmd_none:
+i_pte_not_present:
+	EXCEPTION_LOAD_GPR2
+	EXCEPTION_LOAD_GPR3
+	EXCEPTION_LOAD_GPR4
+	EXCEPTION_LOAD_GPR5
+	EXCEPTION_LOAD_GPR6
+	l.j	_dispatch_do_ipage_fault
+	l.nop
+
+/* ==============================================[ boot tlb handlers ]=== */
+
+
+/* =================================================[ debugging aids ]=== */
+
+	.align 64
+_immu_trampoline:
+	.space 64
+_immu_trampoline_top:
+
+#define TRAMP_SLOT_0		(0x0)
+#define TRAMP_SLOT_1		(0x4)
+#define TRAMP_SLOT_2		(0x8)
+#define TRAMP_SLOT_3		(0xc)
+#define TRAMP_SLOT_4		(0x10)
+#define TRAMP_SLOT_5		(0x14)
+#define TRAMP_FRAME_SIZE	(0x18)
+
+ENTRY(_immu_trampoline_workaround)
+	// r2 EEA
+	// r6 is physical EEA
+	tophys(r6,r2)
+
+	LOAD_SYMBOL_2_GPR(r5,_immu_trampoline)
+	tophys	(r3,r5)			// r3 is trampoline (physical)
+
+	LOAD_SYMBOL_2_GPR(r4,0x15000000)
+	l.sw	TRAMP_SLOT_0(r3),r4
+	l.sw	TRAMP_SLOT_1(r3),r4
+	l.sw	TRAMP_SLOT_4(r3),r4
+	l.sw	TRAMP_SLOT_5(r3),r4
+
+					// EPC = EEA - 0x4
+	l.lwz	r4,0x0(r6)		// load op @ EEA + 0x0 (fc address)
+	l.sw	TRAMP_SLOT_3(r3),r4	// store it to _immu_trampoline_data
+	l.lwz	r4,-0x4(r6)		// load op @ EEA - 0x4 (f8 address)
+	l.sw	TRAMP_SLOT_2(r3),r4	// store it to _immu_trampoline_data
+
+	l.srli  r5,r4,26                // check opcode for write access
+	l.sfeqi r5,0                    // l.j
+	l.bf    0f
+	l.sfeqi r5,0x11                 // l.jr
+	l.bf    1f
+	l.sfeqi r5,1                    // l.jal
+	l.bf    2f
+	l.sfeqi r5,0x12                 // l.jalr
+	l.bf    3f
+	l.sfeqi r5,3                    // l.bnf
+	l.bf    4f
+	l.sfeqi r5,4                    // l.bf
+	l.bf    5f
+99:
+	l.nop
+	l.j	99b			// should never happen
+	l.nop	1
+
+	// r2 is EEA
+	// r3 is trampoline address (physical)
+	// r4 is instruction
+	// r6 is physical(EEA)
+	//
+	// r5
+
+2:	// l.jal
+
+	/* 19 20 aa aa	l.movhi r9,0xaaaa
+	 * a9 29 bb bb  l.ori	r9,0xbbbb
+	 *
+	 * where 0xaaaabbbb is EEA + 0x4 shifted right 2
+	 */
+
+	l.addi	r6,r2,0x4		// this is 0xaaaabbbb
+
+					// l.movhi r9,0xaaaa
+	l.ori	r5,r0,0x1920		// 0x1920 == l.movhi r9
+	l.sh	(TRAMP_SLOT_0+0x0)(r3),r5
+	l.srli	r5,r6,16
+	l.sh	(TRAMP_SLOT_0+0x2)(r3),r5
+
+					// l.ori   r9,0xbbbb
+	l.ori	r5,r0,0xa929		// 0xa929 == l.ori r9
+	l.sh	(TRAMP_SLOT_1+0x0)(r3),r5
+	l.andi	r5,r6,0xffff
+	l.sh	(TRAMP_SLOT_1+0x2)(r3),r5
+
+	/* falthrough, need to set up new jump offset */
+
+
+0:	// l.j
+	l.slli	r6,r4,6			// original offset shifted left 6 - 2
+//	l.srli	r6,r6,6			// original offset shifted right 2
+
+	l.slli	r4,r2,4			// old jump position: EEA shifted left 4
+//	l.srli	r4,r4,6			// old jump position: shifted right 2
+
+	l.addi	r5,r3,0xc		// new jump position (physical)
+	l.slli	r5,r5,4			// new jump position: shifted left 4
+
+	// calculate new jump offset
+	// new_off = old_off + (old_jump - new_jump)
+
+	l.sub	r5,r4,r5		// old_jump - new_jump
+	l.add	r5,r6,r5		// orig_off + (old_jump - new_jump)
+	l.srli	r5,r5,6			// new offset shifted right 2
+
+	// r5 is new jump offset
+					// l.j has opcode 0x0...
+	l.sw	TRAMP_SLOT_2(r3),r5	// write it back
+
+	l.j	trampoline_out
+	l.nop
+
+/* ----------------------------- */
+
+3:	// l.jalr
+
+	/* 19 20 aa aa	l.movhi r9,0xaaaa
+	 * a9 29 bb bb  l.ori	r9,0xbbbb
+	 *
+	 * where 0xaaaabbbb is EEA + 0x4 shifted right 2
+	 */
+
+	l.addi	r6,r2,0x4		// this is 0xaaaabbbb
+
+					// l.movhi r9,0xaaaa
+	l.ori	r5,r0,0x1920		// 0x1920 == l.movhi r9
+	l.sh	(TRAMP_SLOT_0+0x0)(r3),r5
+	l.srli	r5,r6,16
+	l.sh	(TRAMP_SLOT_0+0x2)(r3),r5
+
+					// l.ori   r9,0xbbbb
+	l.ori	r5,r0,0xa929		// 0xa929 == l.ori r9
+	l.sh	(TRAMP_SLOT_1+0x0)(r3),r5
+	l.andi	r5,r6,0xffff
+	l.sh	(TRAMP_SLOT_1+0x2)(r3),r5
+
+	l.lhz	r5,(TRAMP_SLOT_2+0x0)(r3)	// load hi part of jump instruction
+	l.andi	r5,r5,0x3ff		// clear out opcode part
+	l.ori	r5,r5,0x4400		// opcode changed from l.jalr -> l.jr
+	l.sh	(TRAMP_SLOT_2+0x0)(r3),r5 // write it back
+
+	/* falthrough */
+
+1:	// l.jr
+	l.j	trampoline_out
+	l.nop
+
+/* ----------------------------- */
+
+4:	// l.bnf
+5:	// l.bf
+	l.slli	r6,r4,6			// original offset shifted left 6 - 2
+//	l.srli	r6,r6,6			// original offset shifted right 2
+
+	l.slli	r4,r2,4			// old jump position: EEA shifted left 4
+//	l.srli	r4,r4,6			// old jump position: shifted right 2
+
+	l.addi	r5,r3,0xc		// new jump position (physical)
+	l.slli	r5,r5,4			// new jump position: shifted left 4
+
+	// calculate new jump offset
+	// new_off = old_off + (old_jump - new_jump)
+
+	l.add	r6,r6,r4		// (orig_off + old_jump)
+	l.sub	r6,r6,r5		// (orig_off + old_jump) - new_jump
+	l.srli	r6,r6,6			// new offset shifted right 2
+
+	// r6 is new jump offset
+	l.lwz	r4,(TRAMP_SLOT_2+0x0)(r3)	// load jump instruction
+	l.srli	r4,r4,16
+	l.andi	r4,r4,0xfc00		// get opcode part
+	l.slli	r4,r4,16
+	l.or	r6,r4,r6		// l.b(n)f new offset
+	l.sw	TRAMP_SLOT_2(r3),r6	// write it back
+
+	/* we need to add l.j to EEA + 0x8 */
+	tophys	(r4,r2)			// may not be needed (due to shifts down_
+	l.addi	r4,r4,(0x8 - 0x8)	// jump target = r2 + 0x8 (compensate for 0x8)
+					// jump position = r5 + 0x8 (0x8 compensated)
+	l.sub	r4,r4,r5		// jump offset = target - new_position + 0x8
+
+	l.slli	r4,r4,4			// the amount of info in imediate of jump
+	l.srli	r4,r4,6			// jump instruction with offset
+	l.sw	TRAMP_SLOT_4(r3),r4	// write it to 4th slot
+
+	/* fallthrough */
+
+trampoline_out:
+	// set up new EPC to point to our trampoline code
+	LOAD_SYMBOL_2_GPR(r5,_immu_trampoline)
+	l.mtspr	r0,r5,SPR_EPCR_BASE
+
+	// immu_trampoline is (4x) CACHE_LINE aligned
+	// and only 6 instructions long,
+	// so we need to invalidate only 2 lines
+
+	/* Establish cache block size
+	   If BS=0, 16;
+	   If BS=1, 32;
+	   r14 contain block size
+	*/
+	l.mfspr r21,r0,SPR_ICCFGR
+	l.andi	r21,r21,SPR_ICCFGR_CBS
+	l.srli	r21,r21,7
+	l.ori	r23,r0,16
+	l.sll	r14,r23,r21
+
+	l.mtspr	r0,r5,SPR_ICBIR
+	l.add	r5,r5,r14
+	l.mtspr	r0,r5,SPR_ICBIR
+
+	l.jr	r9
+	l.nop
+
+
+/*
+ * DSCR: prints a string referenced by r3.
+ *
+ * PRMS: r3     	- address of the first character of null
+ *			terminated string to be printed
+ *
+ * PREQ: UART at UART_BASE_ADD has to be initialized
+ *
+ * POST: caller should be aware that r3, r9 are changed
+ */
+ENTRY(_emergency_print)
+	EMERGENCY_PRINT_STORE_GPR4
+	EMERGENCY_PRINT_STORE_GPR5
+	EMERGENCY_PRINT_STORE_GPR6
+	EMERGENCY_PRINT_STORE_GPR7
+2:
+	l.lbz	r7,0(r3)
+	l.sfeq	r7,r0
+	l.bf	9f
+	l.nop
+
+// putc:
+	l.movhi r4,hi(UART_BASE_ADD)
+
+	l.addi  r6,r0,0x20
+1:      l.lbz   r5,5(r4)
+	l.andi  r5,r5,0x20
+	l.sfeq  r5,r6
+	l.bnf   1b
+	l.nop
+
+	l.sb    0(r4),r7
+
+	l.addi  r6,r0,0x60
+1:      l.lbz   r5,5(r4)
+	l.andi  r5,r5,0x60
+	l.sfeq  r5,r6
+	l.bnf   1b
+	l.nop
+
+	/* next character */
+	l.j	2b
+	l.addi	r3,r3,0x1
+
+9:
+	EMERGENCY_PRINT_LOAD_GPR7
+	EMERGENCY_PRINT_LOAD_GPR6
+	EMERGENCY_PRINT_LOAD_GPR5
+	EMERGENCY_PRINT_LOAD_GPR4
+	l.jr	r9
+	l.nop
+
+ENTRY(_emergency_print_nr)
+	EMERGENCY_PRINT_STORE_GPR4
+	EMERGENCY_PRINT_STORE_GPR5
+	EMERGENCY_PRINT_STORE_GPR6
+	EMERGENCY_PRINT_STORE_GPR7
+	EMERGENCY_PRINT_STORE_GPR8
+
+	l.addi	r8,r0,32		// shift register
+
+1:	/* remove leading zeros */
+	l.addi	r8,r8,-0x4
+	l.srl	r7,r3,r8
+	l.andi	r7,r7,0xf
+
+	/* don't skip the last zero if number == 0x0 */
+	l.sfeqi	r8,0x4
+	l.bf	2f
+	l.nop
+
+	l.sfeq	r7,r0
+	l.bf	1b
+	l.nop
+
+2:
+	l.srl	r7,r3,r8
+
+	l.andi	r7,r7,0xf
+	l.sflts	r8,r0
+	l.bf	9f
+
+	l.sfgtui r7,0x9
+	l.bnf	8f
+	l.nop
+	l.addi	r7,r7,0x27
+
+8:
+	l.addi	r7,r7,0x30
+// putc:
+	l.movhi r4,hi(UART_BASE_ADD)
+
+	l.addi  r6,r0,0x20
+1:      l.lbz   r5,5(r4)
+	l.andi  r5,r5,0x20
+	l.sfeq  r5,r6
+	l.bnf   1b
+	l.nop
+
+	l.sb    0(r4),r7
+
+	l.addi  r6,r0,0x60
+1:      l.lbz   r5,5(r4)
+	l.andi  r5,r5,0x60
+	l.sfeq  r5,r6
+	l.bnf   1b
+	l.nop
+
+	/* next character */
+	l.j	2b
+	l.addi	r8,r8,-0x4
+
+9:
+	EMERGENCY_PRINT_LOAD_GPR8
+	EMERGENCY_PRINT_LOAD_GPR7
+	EMERGENCY_PRINT_LOAD_GPR6
+	EMERGENCY_PRINT_LOAD_GPR5
+	EMERGENCY_PRINT_LOAD_GPR4
+	l.jr	r9
+	l.nop
+
+
+/*
+ * This should be used for debugging only.
+ * It messes up the Linux early serial output
+ * somehow, so use it sparingly and essentially
+ * only if you need to debug something that goes wrong
+ * before Linux gets the early serial going.
+ *
+ * Furthermore, you'll have to make sure you set the
+ * UART_DEVISOR correctly according to the system
+ * clock rate.
+ *
+ *
+ */
+
+
+
+#define SYS_CLK            20000000
+//#define SYS_CLK            1843200
+#define OR32_CONSOLE_BAUD  115200
+#define UART_DIVISOR       SYS_CLK/(16*OR32_CONSOLE_BAUD)
+
+ENTRY(_early_uart_init)
+	l.movhi	r3,hi(UART_BASE_ADD)
+
+	l.addi	r4,r0,0x7
+	l.sb	0x2(r3),r4
+
+	l.addi	r4,r0,0x0
+	l.sb	0x1(r3),r4
+
+	l.addi	r4,r0,0x3
+	l.sb	0x3(r3),r4
+
+	l.lbz	r5,3(r3)
+	l.ori	r4,r5,0x80
+	l.sb	0x3(r3),r4
+	l.addi	r4,r0,((UART_DIVISOR>>8) & 0x000000ff)
+	l.sb	UART_DLM(r3),r4
+	l.addi  r4,r0,((UART_DIVISOR) & 0x000000ff)
+	l.sb	UART_DLL(r3),r4
+	l.sb	0x3(r3),r5
+
+	l.jr	r9
+	l.nop
+
+_string_copying_linux:
+	.string "\n\n\n\n\n\rCopying Linux... \0"
+
+_string_ok_booting:
+	.string "Ok, booting the kernel.\n\r\0"
+
+_string_unhandled_exception:
+	.string "\n\rRunarunaround: Unhandled exception 0x\0"
+
+_string_epc_prefix:
+	.string ": EPC=0x\0"
+
+_string_nl:
+	.string "\n\r\0"
+
+	.global	_string_esr_irq_bug
+_string_esr_irq_bug:
+	.string "\n\rESR external interrupt bug, for details look into entry.S\n\r\0"
+
+
+
+/* ========================================[ page aligned structures ]=== */
+
+/*
+ * .data section should be page aligned
+ *	(look into arch/or32/kernel/vmlinux.lds)
+ */
+	.section .data,"aw"
+	.align	8192
+	.global  empty_zero_page
+empty_zero_page:
+	.space  8192
+
+	.global  swapper_pg_dir
+swapper_pg_dir:
+	.space  8192
+
+	.global	_unhandled_stack
+_unhandled_stack:
+	.space	8192
+_unhandled_stack_top:
+
+/* ============================================================[ EOF ]=== */
diff --git a/arch/openrisc/kernel/init_task.c b/arch/openrisc/kernel/init_task.c
new file mode 100644
index 0000000..d05c338
--- /dev/null
+++ b/arch/openrisc/kernel/init_task.c
@@ -0,0 +1,41 @@
+/*
+ * OpenRISC init_task.c
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
+#include <linux/init_task.h>
+#include <linux/mqueue.h>
+
+static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
+static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
+
+/*
+ * Initial thread structure.
+ *
+ * We need to make sure that this is THREAD_SIZE aligned due to the
+ * way process stacks are handled. This is done by having a special
+ * "init_task" linker map entry..
+ */
+union thread_union init_thread_union __init_task_data =
+	{ INIT_THREAD_INFO(init_task) };
+
+/*
+ * Initial task structure.
+ *
+ * All other task structs will be allocated on slabs in fork.c
+ */
+struct task_struct init_task = INIT_TASK(init_task);
+
+EXPORT_SYMBOL(init_task);
diff --git a/arch/openrisc/kernel/setup.c b/arch/openrisc/kernel/setup.c
new file mode 100644
index 0000000..da1b12f
--- /dev/null
+++ b/arch/openrisc/kernel/setup.c
@@ -0,0 +1,393 @@
+/*
+ * OpenRISC setup.c
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
+ *
+ * This file handles the architecture-dependent parts of initialization
+ */
+
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/stddef.h>
+#include <linux/unistd.h>
+#include <linux/ptrace.h>
+#include <linux/slab.h>
+#include <linux/tty.h>
+#include <linux/ioport.h>
+#include <linux/delay.h>
+#include <linux/console.h>
+#include <linux/init.h>
+#include <linux/bootmem.h>
+#include <linux/seq_file.h>
+#include <linux/serial.h>
+#include <linux/initrd.h>
+#include <linux/of_fdt.h>
+#include <linux/of.h>
+#include <linux/memblock.h>
+#include <linux/device.h>
+#include <linux/of_platform.h>
+
+#include <asm/segment.h>
+#include <asm/system.h>
+#include <asm/smp.h>
+#include <asm/pgtable.h>
+#include <asm/types.h>
+#include <asm/setup.h>
+#include <asm/io.h>
+#include <asm/cpuinfo.h>
+
+/*
+ * Setup options
+ */
+
+extern int root_mountflags;
+extern char _stext, _etext, _edata, _end;
+extern int __init setup_early_serial8250_console(char *cmdline);
+#ifdef CONFIG_BLK_DEV_INITRD
+extern char __initrd_start, __initrd_end;
+extern char __initramfs_start;
+#endif
+
+extern u32 __dtb_start[];
+
+unsigned long or32_mem_size = 0;
+
+#ifdef CONFIG_CMDLINE
+char __initdata cmd_line[COMMAND_LINE_SIZE] = CONFIG_CMDLINE;
+#else
+char __initdata cmd_line[COMMAND_LINE_SIZE] = "console=uart,mmio,0x90000000,115200";
+#endif
+
+extern const unsigned long text_start, edata; /* set by the linker script */
+
+static unsigned long __init setup_memory(void)
+{
+	unsigned long bootmap_size;
+	unsigned long ram_start_pfn;
+	unsigned long free_ram_start_pfn;
+	unsigned long ram_end_pfn;
+	phys_addr_t memory_start, memory_end;
+	struct memblock_region* region;
+
+	memory_end = memory_start = 0;
+
+        /* Find main memory where is the kernel */
+	for_each_memblock(memory, region) {
+                memory_start = region->base;
+                memory_end = region->base + region->size;
+		printk(KERN_INFO "%s: Memory: 0x%x-0x%x\n", __func__,
+			memory_start, memory_end);
+	}
+
+	if (! memory_end) {
+		panic("No memory!");
+	}
+
+	ram_start_pfn = PFN_UP(memory_start);
+	/* free_ram_start_pfn is first page after kernel */
+	free_ram_start_pfn = PFN_UP(__pa(&_end));
+	ram_end_pfn = PFN_DOWN(memblock_end_of_DRAM());
+
+	max_pfn = ram_end_pfn;
+
+	/*
+	 * initialize the boot-time allocator (with low memory only).
+	 *
+	 * This makes the memory from the end of the kernel to the end of
+	 * RAM usable.
+	 * init_bootmem sets the global values min_low_pfn, max_low_pfn.
+	 */
+	bootmap_size = init_bootmem(free_ram_start_pfn,
+				    ram_end_pfn-ram_start_pfn);
+	free_bootmem(PFN_PHYS(free_ram_start_pfn),
+		     (ram_end_pfn-free_ram_start_pfn)<< PAGE_SHIFT);
+	reserve_bootmem(PFN_PHYS(free_ram_start_pfn), bootmap_size,
+			BOOTMEM_DEFAULT);
+
+	for_each_memblock(reserved, region) {
+		printk("Reserved - 0x%08x-0x%08x\n",
+			(u32) region->base, (u32) region->size);
+		reserve_bootmem(region->base, region->size, BOOTMEM_DEFAULT);
+	}
+
+	return(ram_end_pfn);
+}
+
+
+struct cpuinfo cpuinfo;
+
+static void print_cpuinfo(void) {
+	unsigned long upr = mfspr(SPR_UPR);
+	unsigned long vr = mfspr(SPR_VR);
+	unsigned int version;
+	unsigned int revision;
+
+	version = (vr & SPR_VR_VER) >> 24;
+	revision = (vr & SPR_VR_REV);
+
+	printk(KERN_INFO "CPU: OpenRISC-%x (revision %d) @%d MHz\n",
+		version, revision, cpuinfo.clock_frequency / 1000000);
+
+	if (!(upr & SPR_UPR_UP)) {
+		printk(KERN_INFO "-- no UPR register... unable to detect configuration\n");
+		return;
+	}
+
+	if (upr & SPR_UPR_DCP)
+		printk(KERN_INFO "-- dcache: %4d bytes total, %2d bytes/line, %d way(s)\n",
+			cpuinfo.dcache_size, cpuinfo.dcache_block_size, 1);
+	else
+		printk(KERN_INFO "-- dcache disabled\n");
+	if (upr & SPR_UPR_ICP)
+		printk(KERN_INFO "-- icache: %4d bytes total, %2d bytes/line, %d way(s)\n",
+			cpuinfo.icache_size, cpuinfo.icache_block_size, 1);
+	else
+		printk(KERN_INFO "-- icache disabled\n");
+
+	if (upr & SPR_UPR_DMP)
+		printk(KERN_INFO "-- dmmu: %4d entries, %lu way(s)\n",
+			1 << ((mfspr(SPR_DMMUCFGR) & SPR_DMMUCFGR_NTS) >> 2),
+			1 + (mfspr(SPR_DMMUCFGR) & SPR_DMMUCFGR_NTW));
+	if (upr & SPR_UPR_IMP)
+		printk(KERN_INFO "-- immu: %4d entries, %lu way(s)\n",
+			1 << ((mfspr(SPR_IMMUCFGR) & SPR_IMMUCFGR_NTS) >> 2),
+			1 + (mfspr(SPR_IMMUCFGR) & SPR_IMMUCFGR_NTW));
+
+	printk(KERN_INFO "-- additional features:\n");
+	if (upr & SPR_UPR_DUP)
+		printk(KERN_INFO "-- debug unit\n");
+	if (upr & SPR_UPR_PCUP)
+		printk(KERN_INFO "-- performance counters\n");
+	if (upr & SPR_UPR_PMP)
+		printk(KERN_INFO "-- power management\n");
+	if (upr & SPR_UPR_PICP)
+		printk(KERN_INFO "-- PIC\n");
+	if (upr & SPR_UPR_TTP)
+		printk(KERN_INFO "-- timer\n");
+	if (upr & SPR_UPR_CUP)
+		printk(KERN_INFO "-- custom unit(s)\n");
+}
+
+static inline unsigned int fcpu(struct device_node *cpu, char *n)
+{
+        int *val;
+        return (val = (int *) of_get_property(cpu, n, NULL)) ? *val : 0;
+}
+
+extern void __ic_enable(u32 icache_size, u32 icache_block_size);
+extern void __dc_enable(u32 dcache_size, u32 dcache_block_size);
+
+void __init setup_cpuinfo(void)
+{
+        struct device_node *cpu = NULL;
+	unsigned long iccfgr,dccfgr;
+	unsigned long cache_set_size, cache_ways;;
+
+//        cpu = (struct device_node *) of_find_node_by_type(NULL, "cpu");
+        cpu = (struct device_node *) of_find_compatible_node(NULL, NULL, "opencores,openrisc-1200");
+        if (!cpu) {
+		panic("No compatible CPU found in device tree...\n");
+	}
+
+	iccfgr = mfspr(SPR_ICCFGR);
+	cache_ways = 1 << (iccfgr & SPR_ICCFGR_NCW);
+	cache_set_size = 1 << ((iccfgr & SPR_ICCFGR_NCS) >> 3);
+	cpuinfo.icache_block_size = 16 << ((iccfgr & SPR_ICCFGR_CBS) >> 7);
+	cpuinfo.icache_size = cache_set_size * cache_ways * cpuinfo.icache_block_size;
+
+	dccfgr = mfspr(SPR_DCCFGR);
+	cache_ways = 1 << (dccfgr & SPR_DCCFGR_NCW);
+	cache_set_size = 1 << ((dccfgr & SPR_DCCFGR_NCS) >> 3);
+	cpuinfo.dcache_block_size = 16 << ((dccfgr & SPR_DCCFGR_CBS) >> 7);
+	cpuinfo.dcache_size = cache_set_size * cache_ways * cpuinfo.dcache_block_size;
+
+
+
+	cpuinfo.clock_frequency =  fcpu(cpu, "clock-frequency");
+
+	of_node_put(cpu);
+
+	print_cpuinfo();
+
+//	printk("IC ENABLE........................\n");
+//	__ic_enable(cpuinfo.icache_size, cpuinfo.icache_block_size);
+//	__dc_enable(cpuinfo.dcache_size, cpuinfo.dcache_block_size);
+}
+
+void __init or32_early_setup(/*unsigned long fdt*/ void) {
+
+	early_init_devtree((void *) __dtb_start);
+
+
+/*	if (fdt)
+		printk("FDT at 0x%08x\n", fdt);
+	else*/
+		printk("Compiled-in FDT at 0x%08x\n",
+		       (unsigned int)__dtb_start);
+
+//	printk("FDT: size %lx\n", ((struct boot_param_header*) __dtb_start)->totalsize);
+
+}
+
+const struct of_device_id openrisc_bus_ids[] = {
+        { .type = "soc", },
+        { .compatible = "soc", },
+        {},
+};
+
+static int __init openrisc_device_probe(void)
+{
+        of_platform_bus_probe(NULL, openrisc_bus_ids, NULL);
+        return 0;
+}
+device_initcall(openrisc_device_probe);
+
+
+static inline unsigned long extract_value_bits(unsigned long reg,
+					       short bit_nr, short width)
+{
+	return((reg >> bit_nr) & (0 << width));
+}
+
+static inline unsigned long extract_value(unsigned long reg,
+					  unsigned long mask)
+{
+	while (!(mask & 0x1)) {
+		reg  = reg  >> 1;
+		mask = mask >> 1;
+	}
+	return(mask & reg);
+}
+
+void __init detect_unit_config(unsigned long upr, unsigned long mask,
+			       char *text, void (*func)(void))
+{
+        if (text != NULL)
+		printk("%s", text);
+
+	if ( upr & mask ) {
+		if (func != NULL)
+			func();
+		else
+			printk("present\n");
+	}
+	else
+		printk("not present\n");
+}
+
+void __init setup_arch(char **cmdline_p)
+{
+	unsigned long max_low_pfn;
+
+	unflatten_device_tree();
+
+	setup_cpuinfo();
+
+	/* process 1's initial memory region is the kernel code/data */
+	init_mm.start_code = (unsigned long) &_stext;
+	init_mm.end_code =   (unsigned long) &_etext;
+	init_mm.end_data =   (unsigned long) &_edata;
+	init_mm.brk =        (unsigned long) &_end;
+
+#ifdef CONFIG_BLK_DEV_INITRD
+	initrd_start = (unsigned long)&__initrd_start;
+	initrd_end = (unsigned long)&__initrd_end;
+	if (initrd_start == initrd_end) {
+		initrd_start = 0;
+		initrd_end = 0;
+	}
+	initrd_below_start_ok = 1;
+#endif
+
+        /* setup bootmem allocator */
+	max_low_pfn = setup_memory();
+
+	/* paging_init() sets up the MMU and marks all pages as reserved */
+	paging_init();
+
+#if defined(CONFIG_VT) && defined(CONFIG_DUMMY_CONSOLE)
+	if(!conswitchp)
+		conswitchp = &dummy_con;
+#endif
+
+	*cmdline_p = cmd_line;
+
+	printk("OpenRISC Linux -- http://openrisc.net\n");
+}
+
+static int show_cpuinfo(struct seq_file *m, void *v)
+{
+	unsigned long vr;
+	int version, revision;
+
+	vr = mfspr(SPR_VR);
+	version = (vr & SPR_VR_VER) >> 24;
+	revision = vr & SPR_VR_REV;
+
+	return seq_printf(m,
+		"cpu\t\t: OpenRISC-%x\n"
+		"revision\t: %d\n"
+		"dcache size\t: %d bytes\n"
+		"dcache block size\t: %d bytes\n"
+		"icache size\t: %d bytes\n"
+		"icache block size\t: %d bytes\n"
+		"immu\t\t: %d entries, %lu ways\n"
+		"dmmu\t\t: %d entries, %lu ways\n"
+		"bogomips\t: %lu.%02lu\n",
+
+		version,
+		revision,
+		cpuinfo.dcache_size,
+		cpuinfo.dcache_block_size,
+		cpuinfo.icache_size,
+		cpuinfo.icache_block_size,
+		1 << ((mfspr(SPR_DMMUCFGR) & SPR_DMMUCFGR_NTS) >> 2),
+		1 + (mfspr(SPR_DMMUCFGR) & SPR_DMMUCFGR_NTW),
+		1 << ((mfspr(SPR_IMMUCFGR) & SPR_IMMUCFGR_NTS) >> 2),
+		1 + (mfspr(SPR_IMMUCFGR) & SPR_IMMUCFGR_NTW),
+		(loops_per_jiffy * HZ) / 500000,
+		((loops_per_jiffy * HZ) / 5000) % 100);
+}
+
+static void *c_start(struct seq_file *m, loff_t *pos)
+{
+	/* We only have one CPU... */
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
+struct seq_operations cpuinfo_op = {
+	start:  c_start,
+	next:   c_next,
+	stop:   c_stop,
+	show:   show_cpuinfo,
+};
+
+/*RGD this awful hack is because our compiler does
+ *support the "weak" attribute correctly at this time
+ *once we do (support weak) this should be removed!!
+ */
+void __start_notes(void){}
+void __stop_notes(void){}
-- 
1.7.4.1

