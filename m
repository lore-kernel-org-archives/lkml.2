Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab1BMGdg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 01:33:36 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:43157 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab1BMGd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 01:33:27 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "'Greg KH'" <greg@kroah.com>
Subject: [PATCHv2 04/11] unicore32 core architecture: low level entry and setup codes
Date: Sun, 13 Feb 2011 14:33:19 +0800
Message-ID: <02e901cbcb47$e73d9380$b5b8ba80$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcvLR+NMsnhBZkIIQn+P6yRYn9BTjA==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements low level entry and setup codes.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/traps.h |   21 +
 arch/unicore32/kernel/entry.S      |  824 ++++++++++++++++++++++++++++++++++++
 arch/unicore32/kernel/head.S       |  252 +++++++++++
 arch/unicore32/kernel/setup.c      |  360 ++++++++++++++++
 arch/unicore32/kernel/setup.h      |   30 ++
 arch/unicore32/kernel/traps.c      |  333 +++++++++++++++
 6 files changed, 1820 insertions(+), 0 deletions(-)
 create mode 100644 arch/unicore32/include/asm/traps.h
 create mode 100644 arch/unicore32/kernel/entry.S
 create mode 100644 arch/unicore32/kernel/head.S
 create mode 100644 arch/unicore32/kernel/setup.c
 create mode 100644 arch/unicore32/kernel/setup.h
 create mode 100644 arch/unicore32/kernel/traps.c

diff --git a/arch/unicore32/include/asm/traps.h b/arch/unicore32/include/asm/traps.h
new file mode 100644
index 0000000..66e17a7
--- /dev/null
+++ b/arch/unicore32/include/asm/traps.h
@@ -0,0 +1,21 @@
+/*
+ * linux/arch/unicore32/include/asm/traps.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_TRAP_H__
+#define __UNICORE_TRAP_H__
+
+extern void __init early_trap_init(void);
+extern void dump_backtrace_entry(unsigned long where,
+		unsigned long from, unsigned long frame);
+
+extern void do_DataAbort(unsigned long addr, unsigned int fsr,
+		 struct pt_regs *regs);
+#endif
diff --git a/arch/unicore32/kernel/entry.S b/arch/unicore32/kernel/entry.S
new file mode 100644
index 0000000..83698b7
--- /dev/null
+++ b/arch/unicore32/kernel/entry.S
@@ -0,0 +1,824 @@
+/*
+ * linux/arch/unicore32/kernel/entry.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ *  Low-level vector interface routines
+ */
+#include <linux/init.h>
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+#include <asm/errno.h>
+#include <asm/thread_info.h>
+#include <asm/memory.h>
+#include <asm/unistd.h>
+#include <generated/asm-offsets.h>
+#include "debug-macro.S"
+
+@
+@ Most of the stack format comes from struct pt_regs, but with
+@ the addition of 8 bytes for storing syscall args 5 and 6.
+@
+#define S_OFF		8
+
+/*
+ * The SWI code relies on the fact that R0 is at the bottom of the stack
+ * (due to slow/fast restore user regs).
+ */
+#if S_R0 != 0
+#error "Please fix"
+#endif
+
+	.macro	zero_fp
+#ifdef CONFIG_FRAME_POINTER
+	mov	fp, #0
+#endif
+	.endm
+
+	.macro	alignment_trap, rtemp
+#ifdef CONFIG_ALIGNMENT_TRAP
+	ldw	\rtemp, .LCcralign
+	ldw	\rtemp, [\rtemp]
+	movc	p0.c1, \rtemp, #0
+#endif
+	.endm
+
+	.macro	load_user_sp_lr, rd, rtemp, offset = 0
+	mov	\rtemp, asr
+	xor	\rtemp, \rtemp, #(PRIV_MODE ^ SUSR_MODE)
+	mov.a	asr, \rtemp			@ switch to the SUSR mode
+
+	ldw	sp, [\rd+], #\offset		@ load sp_user
+	ldw	lr, [\rd+], #\offset + 4	@ load lr_user
+
+	xor	\rtemp, \rtemp, #(PRIV_MODE ^ SUSR_MODE)
+	mov.a	asr, \rtemp			@ switch back to the PRIV mode
+	.endm
+
+	.macro	priv_exit, rpsr
+	mov.a	bsr, \rpsr
+	ldm.w	(r0 - r15), [sp]+
+	ldm.b	(r16 - pc), [sp]+		@ load r0 - pc, asr
+	.endm
+
+	.macro	restore_user_regs, fast = 0, offset = 0
+	ldw	r1, [sp+], #\offset + S_PSR	@ get calling asr
+	ldw	lr, [sp+], #\offset + S_PC	@ get pc
+	mov.a	bsr, r1				@ save in bsr_priv
+	.if	\fast
+	add	sp, sp, #\offset + S_R1		@ r0 is syscall return value
+	ldm.w	(r1 - r15), [sp]+		@ get calling r1 - r15
+	ldur	(r16 - lr), [sp]+		@ get calling r16 - lr
+	.else
+	ldm.w	(r0 - r15), [sp]+		@ get calling r0 - r15
+	ldur	(r16 - lr), [sp]+		@ get calling r16 - lr
+	.endif
+	nop
+	add	sp, sp, #S_FRAME_SIZE - S_R16
+	mov.a	pc, lr				@ return
+						@ and move bsr_priv into asr
+	.endm
+
+	.macro	get_thread_info, rd
+	mov	\rd, sp >> #13
+	mov	\rd, \rd << #13
+	.endm
+
+	.macro	get_irqnr_and_base, irqnr, irqstat, base, tmp
+	ldw	\base, =(io_p2v(PKUNITY_INTC_BASE))
+	ldw	\irqstat, [\base+], #0xC	@ INTC_ICIP
+	ldw	\tmp,	  [\base+], #0x4	@ INTC_ICMR
+	and.a	\irqstat, \irqstat, \tmp
+	beq	1001f
+	cntlz	\irqnr, \irqstat
+	rsub	\irqnr, \irqnr, #31
+1001:	/* EQ will be set if no irqs pending */
+	.endm
+
+#ifdef CONFIG_DEBUG_LL
+	.macro	printreg, reg, temp
+		adr	\temp, 901f
+		stm	(r0-r3), [\temp]+
+		stw	lr, [\temp+], #0x10
+		mov	r0, \reg
+		b.l	printhex8
+		mov	r0, #':'
+		b.l	printch
+		mov	r0, pc
+		b.l	printhex8
+		adr	r0, 902f
+		b.l	printascii
+		adr	\temp, 901f
+		ldm	(r0-r3), [\temp]+
+		ldw	lr, [\temp+], #0x10
+		b	903f
+901:	.word	0, 0, 0, 0, 0	@ r0-r3, lr
+902:	.asciz	": epip4d\n"
+	.align
+903:
+	.endm
+#endif
+
+/*
+ * These are the registers used in the syscall handler, and allow us to
+ * have in theory up to 7 arguments to a function - r0 to r6.
+ *
+ * Note that tbl == why is intentional.
+ *
+ * We must set at least "tsk" and "why" when calling ret_with_reschedule.
+ */
+scno	.req	r21		@ syscall number
+tbl	.req	r22		@ syscall table pointer
+why	.req	r22		@ Linux syscall (!= 0)
+tsk	.req	r23		@ current thread_info
+
+/*
+ * Interrupt handling.  Preserves r17, r18, r19
+ */
+	.macro	intr_handler
+1:	get_irqnr_and_base r0, r6, r5, lr
+	beq	2f
+	mov	r1, sp
+	@
+	@ routine called with r0 = irq number, r1 = struct pt_regs *
+	@
+	adr	lr, 1b
+	b	asm_do_IRQ
+2:
+	.endm
+
+/*
+ * PRIV mode handlers
+ */
+	.macro	priv_entry
+	sub	sp, sp, #(S_FRAME_SIZE - 4)
+	stm	(r1 - r15), [sp]+
+	add	r5, sp, #S_R15
+	stm	(r16 - r28), [r5]+
+
+	ldm	(r1 - r3), [r0]+
+	add	r5, sp, #S_SP - 4	@ here for interlock avoidance
+	mov	r4, #-1			@  ""  ""      ""       ""
+	add	r0, sp, #(S_FRAME_SIZE - 4)
+	stw.w	r1, [sp+], #-4		@ save the "real" r0 copied
+					@ from the exception stack
+
+	mov	r1, lr
+
+	@
+	@ We are now ready to fill in the remaining blanks on the stack:
+	@
+	@  r0 - sp_priv
+	@  r1 - lr_priv
+	@  r2 - lr_<exception>, already fixed up for correct return/restart
+	@  r3 - bsr_<exception>
+	@  r4 - orig_r0 (see pt_regs definition in ptrace.h)
+	@
+	stm	(r0 - r4), [r5]+
+	.endm
+
+/*
+ * User mode handlers
+ *
+ */
+	.macro	user_entry
+	sub	sp, sp, #S_FRAME_SIZE
+	stm	(r1 - r15), [sp+]
+	add	r4, sp, #S_R16
+	stm	(r16 - r28), [r4]+
+
+	ldm	(r1 - r3), [r0]+
+	add	r0, sp, #S_PC		@ here for interlock avoidance
+	mov	r4, #-1			@  ""  ""     ""        ""
+
+	stw	r1, [sp]		@ save the "real" r0 copied
+					@ from the exception stack
+
+	@
+	@ We are now ready to fill in the remaining blanks on the stack:
+	@
+	@  r2 - lr_<exception>, already fixed up for correct return/restart
+	@  r3 - bsr_<exception>
+	@  r4 - orig_r0 (see pt_regs definition in ptrace.h)
+	@
+	@ Also, separately save sp_user and lr_user
+	@
+	stm	(r2 - r4), [r0]+
+	stur	(sp, lr), [r0-]
+
+	@
+	@ Enable the alignment trap while in kernel mode
+	@
+	alignment_trap r0
+
+	@
+	@ Clear FP to mark the first stack frame
+	@
+	zero_fp
+	.endm
+
+	.text
+
+@
+@ __invalid - generic code for failed exception
+@			(re-entrant version of handlers)
+@
+__invalid:
+	sub	sp, sp, #S_FRAME_SIZE
+	stm	(r1 - r15), [sp+]
+	add	r1, sp, #S_R16
+	stm	(r16 - r28, sp, lr), [r1]+
+
+	zero_fp
+
+	ldm	(r4 - r6), [r0]+
+	add	r0, sp, #S_PC		@ here for interlock avoidance
+	mov	r7, #-1			@  ""   ""    ""        ""
+	stw	r4, [sp]		@ save preserved r0
+	stm	(r5 - r7), [r0]+	@ lr_<exception>,
+					@ asr_<exception>, "old_r0"
+
+	mov	r0, sp
+	mov	r1, asr
+	b	bad_mode
+ENDPROC(__invalid)
+
+	.align	5
+__dabt_priv:
+	priv_entry
+
+	@
+	@ get ready to re-enable interrupts if appropriate
+	@
+	mov	r17, asr
+	cand.a	r3, #PSR_I_BIT
+	bne	1f
+	andn	r17, r17, #PSR_I_BIT
+1:
+
+	@
+	@ Call the processor-specific abort handler:
+	@
+	@  r2 - aborted context pc
+	@  r3 - aborted context asr
+	@
+	@ The abort handler must return the aborted address in r0, and
+	@ the fault status register in r1.
+	@
+	movc	r1, p0.c3, #0		@ get FSR
+	movc	r0, p0.c4, #0		@ get FAR
+
+	@
+	@ set desired INTR state, then call main handler
+	@
+	mov.a	asr, r17
+	mov	r2, sp
+	b.l	do_DataAbort
+
+	@
+	@ INTRs off again before pulling preserved data off the stack
+	@
+	disable_irq r0
+
+	@
+	@ restore BSR and restart the instruction
+	@
+	ldw	r2, [sp+], #S_PSR
+	priv_exit r2				@ return from exception
+ENDPROC(__dabt_priv)
+
+	.align	5
+__intr_priv:
+	priv_entry
+
+	intr_handler
+
+	mov	r0, #0				@ epip4d
+	movc	p0.c5, r0, #14
+	nop; nop; nop; nop; nop; nop; nop; nop
+
+	ldw	r4, [sp+], #S_PSR		@ irqs are already disabled
+
+	priv_exit r4				@ return from exception
+ENDPROC(__intr_priv)
+
+	.ltorg
+
+	.align	5
+__extn_priv:
+	priv_entry
+
+	mov	r0, sp				@ struct pt_regs *regs
+	mov	r1, asr
+	b	bad_mode			@ not supported
+ENDPROC(__extn_priv)
+
+	.align	5
+__pabt_priv:
+	priv_entry
+
+	@
+	@ re-enable interrupts if appropriate
+	@
+	mov	r17, asr
+	cand.a	r3, #PSR_I_BIT
+	bne	1f
+	andn	r17, r17, #PSR_I_BIT
+1:
+
+	@
+	@ set args, then call main handler
+	@
+	@  r0 - address of faulting instruction
+	@  r1 - pointer to registers on stack
+	@
+	mov	r0, r2			@ pass address of aborted instruction
+	mov	r1, #5
+	mov.a	asr, r17
+	mov	r2, sp			@ regs
+	b.l	do_PrefetchAbort	@ call abort handler
+
+	@
+	@ INTRs off again before pulling preserved data off the stack
+	@
+	disable_irq r0
+
+	@
+	@ restore BSR and restart the instruction
+	@
+	ldw	r2, [sp+], #S_PSR
+	priv_exit r2			@ return from exception
+ENDPROC(__pabt_priv)
+
+	.align	5
+.LCcralign:
+	.word	cr_alignment
+
+	.align	5
+__dabt_user:
+	user_entry
+
+#ifdef CONFIG_UNICORE_FPU_F64
+	cff	ip, s31
+	cand.a	ip, #0x08000000		@ FPU execption traps?
+	beq	209f
+
+	ldw	ip, [sp+], #S_PC
+	add	ip, ip, #4
+	stw	ip, [sp+], #S_PC
+	@
+	@ fall through to the emulation code, which returns using r19 if
+	@ it has emulated the instruction, or the more conventional lr
+	@ if we are to treat this as a real extended instruction
+	@
+	@  r0 - instruction
+	@
+1:	ldw.u	r0, [r2]
+	adr	r19, ret_from_exception
+	adr	lr, 209f
+	@
+	@ fallthrough to call do_uc_f64
+	@
+/*
+ * Check whether the instruction is a co-processor instruction.
+ * If yes, we need to call the relevant co-processor handler.
+ *
+ * Note that we don't do a full check here for the co-processor
+ * instructions; all instructions with bit 27 set are well
+ * defined.  The only instructions that should fault are the
+ * co-processor instructions.
+ *
+ * Emulators may wish to make use of the following registers:
+ *  r0  = instruction opcode.
+ *  r2  = PC
+ *  r19 = normal "successful" return address
+ *  r20 = this threads thread_info structure.
+ *  lr  = unrecognised instruction return address
+ */
+	get_thread_info r20			@ get current thread
+	and	r8, r0, #0x00003c00		@ mask out CP number
+	mov	r7, #1
+	stb	r7, [r20+], #TI_USED_CP + 2	@ set appropriate used_cp[]
+
+	@ F64 hardware support entry point.
+	@  r0  = faulted instruction
+	@  r19 = return address
+	@  r20 = fp_state
+	enable_irq r4
+	add	r20, r20, #TI_FPSTATE	@ r20 = workspace
+	cff	r1, s31			@ get fpu FPSCR
+	andn    r2, r1, #0x08000000
+	ctf     r2, s31			@ clear 27 bit
+	mov	r2, sp			@ nothing stacked - regdump is at TOS
+	mov	lr, r19			@ setup for a return to the user code
+
+	@ Now call the C code to package up the bounce to the support code
+	@   r0 holds the trigger instruction
+	@   r1 holds the FPSCR value
+	@   r2 pointer to register dump
+	b	ucf64_exchandler
+209:
+#endif
+	@
+	@ Call the processor-specific abort handler:
+	@
+	@  r2 - aborted context pc
+	@  r3 - aborted context asr
+	@
+	@ The abort handler must return the aborted address in r0, and
+	@ the fault status register in r1.
+	@
+	movc	r1, p0.c3, #0		@ get FSR
+	movc	r0, p0.c4, #0		@ get FAR
+
+	@
+	@ INTRs on, then call the main handler
+	@
+	enable_irq r2
+	mov	r2, sp
+	adr	lr, ret_from_exception
+	b	do_DataAbort
+ENDPROC(__dabt_user)
+
+	.align	5
+__intr_user:
+	user_entry
+
+	get_thread_info tsk
+
+	intr_handler
+
+	mov	why, #0
+	b	ret_to_user
+ENDPROC(__intr_user)
+
+	.ltorg
+
+	.align	5
+__extn_user:
+	user_entry
+
+	mov	r0, sp
+	mov	r1, asr
+	b	bad_mode
+ENDPROC(__extn_user)
+
+	.align	5
+__pabt_user:
+	user_entry
+
+	mov	r0, r2			@ pass address of aborted instruction.
+	mov	r1, #5
+	enable_irq r1			@ Enable interrupts
+	mov	r2, sp			@ regs
+	b.l	do_PrefetchAbort	@ call abort handler
+	/* fall through */
+/*
+ * This is the return code to user mode for abort handlers
+ */
+ENTRY(ret_from_exception)
+	get_thread_info tsk
+	mov	why, #0
+	b	ret_to_user
+ENDPROC(__pabt_user)
+ENDPROC(ret_from_exception)
+
+/*
+ * Register switch for UniCore V2 processors
+ * r0 = previous task_struct, r1 = previous thread_info, r2 = next thread_info
+ * previous and next are guaranteed not to be the same.
+ */
+ENTRY(__switch_to)
+	add	ip, r1, #TI_CPU_SAVE
+	stm.w	(r4 - r15), [ip]+
+	stm.w	(r16 - r27, sp, lr), [ip]+
+
+#ifdef	CONFIG_UNICORE_FPU_F64
+	add	ip, r1, #TI_FPSTATE
+	sfm.w	(f0  - f7 ), [ip]+
+	sfm.w	(f8  - f15), [ip]+
+	sfm.w	(f16 - f23), [ip]+
+	sfm.w	(f24 - f31), [ip]+
+	cff	r4, s31
+	stw	r4, [ip]
+
+	add	ip, r2, #TI_FPSTATE
+	lfm.w	(f0  - f7 ), [ip]+
+	lfm.w	(f8  - f15), [ip]+
+	lfm.w	(f16 - f23), [ip]+
+	lfm.w	(f24 - f31), [ip]+
+	ldw	r4, [ip]
+	ctf	r4, s31
+#endif
+	add	ip, r2, #TI_CPU_SAVE
+	ldm.w	(r4 - r15), [ip]+
+	ldm	(r16 - r27, sp, pc), [ip]+	@ Load all regs saved previously
+ENDPROC(__switch_to)
+
+	.align	5
+/*
+ * This is the fast syscall return path.  We do as little as
+ * possible here, and this includes saving r0 back into the PRIV
+ * stack.
+ */
+ret_fast_syscall:
+	disable_irq r1				@ disable interrupts
+	ldw	r1, [tsk+], #TI_FLAGS
+	cand.a	r1, #_TIF_WORK_MASK
+	bne	fast_work_pending
+
+	@ fast_restore_user_regs
+	restore_user_regs fast = 1, offset = S_OFF
+
+/*
+ * Ok, we need to do extra processing, enter the slow path.
+ */
+fast_work_pending:
+	stw.w	r0, [sp+], #S_R0+S_OFF		@ returned r0
+work_pending:
+	cand.a	r1, #_TIF_NEED_RESCHED
+	bne	work_resched
+	cand.a	r1, #_TIF_SIGPENDING|_TIF_NOTIFY_RESUME
+	beq	no_work_pending
+	mov	r0, sp				@ 'regs'
+	mov	r2, why				@ 'syscall'
+	cand.a	r1, #_TIF_SIGPENDING		@ delivering a signal?
+	cmovne	why, #0				@ prevent further restarts
+	b.l	do_notify_resume
+	b	ret_slow_syscall		@ Check work again
+
+work_resched:
+	b.l	schedule
+/*
+ * "slow" syscall return path.  "why" tells us if this was a real syscall.
+ */
+ENTRY(ret_to_user)
+ret_slow_syscall:
+	disable_irq r1				@ disable interrupts
+	get_thread_info tsk			@ epip4d, one path error?!
+	ldw	r1, [tsk+], #TI_FLAGS
+	cand.a	r1, #_TIF_WORK_MASK
+	bne	work_pending
+no_work_pending:
+	@ slow_restore_user_regs
+	restore_user_regs fast = 0, offset = 0
+ENDPROC(ret_to_user)
+
+/*
+ * This is how we return from a fork.
+ */
+ENTRY(ret_from_fork)
+	b.l	schedule_tail
+	get_thread_info tsk
+	ldw	r1, [tsk+], #TI_FLAGS		@ check for syscall tracing
+	mov	why, #1
+	cand.a	r1, #_TIF_SYSCALL_TRACE		@ are we tracing syscalls?
+	beq	ret_slow_syscall
+	mov	r1, sp
+	mov	r0, #1				@ trace exit [IP = 1]
+	b.l	syscall_trace
+	b	ret_slow_syscall
+ENDPROC(ret_from_fork)
+
+/*=============================================================================
+ * SWI handler
+ *-----------------------------------------------------------------------------
+ */
+	.align	5
+ENTRY(vector_swi)
+	sub	sp, sp, #S_FRAME_SIZE
+	stm	(r0 - r15), [sp]+		@ Calling r0 - r15
+	add	r8, sp, #S_R16
+	stm	(r16 - r28), [r8]+		@ Calling r16 - r28
+	add	r8, sp, #S_PC
+	stur	(sp, lr), [r8-]			@ Calling sp, lr
+	mov	r8, bsr				@ called from non-REAL mode
+	stw	lr, [sp+], #S_PC		@ Save calling PC
+	stw	r8, [sp+], #S_PSR		@ Save ASR
+	stw	r0, [sp+], #S_OLD_R0		@ Save OLD_R0
+	zero_fp
+
+	/*
+	 * Get the system call number.
+	 */
+	sub	ip, lr, #4
+	ldw.u	scno, [ip]			@ get SWI instruction
+
+#ifdef CONFIG_ALIGNMENT_TRAP
+	ldw	ip, __cr_alignment
+	ldw	ip, [ip]
+	movc	p0.c1, ip, #0                   @ update control register
+#endif
+	enable_irq ip
+
+	get_thread_info tsk
+	ldw	tbl, =sys_call_table		@ load syscall table pointer
+
+	andn	scno, scno, #0xff000000		@ mask off SWI op-code
+	andn	scno, scno, #0x00ff0000		@ mask off SWI op-code
+
+	stm.w	(r4, r5), [sp-]			@ push fifth and sixth args
+	ldw	ip, [tsk+], #TI_FLAGS		@ check for syscall tracing
+	cand.a	ip, #_TIF_SYSCALL_TRACE		@ are we tracing syscalls?
+	bne	__sys_trace
+
+	csub.a	scno, #__NR_syscalls		@ check upper syscall limit
+	adr	lr, ret_fast_syscall		@ return address
+	bea	1f
+	ldw	pc, [tbl+], scno << #2		@ call sys_* routine
+1:
+	add	r1, sp, #S_OFF
+2:	mov	why, #0				@ no longer a real syscall
+	b	sys_ni_syscall			@ not private func
+
+	/*
+	 * This is the really slow path.  We're going to be doing
+	 * context switches, and waiting for our parent to respond.
+	 */
+__sys_trace:
+	mov	r2, scno
+	add	r1, sp, #S_OFF
+	mov	r0, #0				@ trace entry [IP = 0]
+	b.l	syscall_trace
+
+	adr	lr, __sys_trace_return		@ return address
+	mov	scno, r0			@ syscall number (possibly new)
+	add	r1, sp, #S_R0 + S_OFF		@ pointer to regs
+	csub.a	scno, #__NR_syscalls		@ check upper syscall limit
+	bea	2b
+	ldm	(r0 - r3), [r1]+		@ have to reload r0 - r3
+	ldw	pc, [tbl+], scno << #2		@ call sys_* routine
+
+__sys_trace_return:
+	stw.w	r0, [sp+], #S_R0 + S_OFF	@ save returned r0
+	mov	r2, scno
+	mov	r1, sp
+	mov	r0, #1				@ trace exit [IP = 1]
+	b.l	syscall_trace
+	b	ret_slow_syscall
+
+	.align	5
+#ifdef CONFIG_ALIGNMENT_TRAP
+	.type	__cr_alignment, #object
+__cr_alignment:
+	.word	cr_alignment
+#endif
+	.ltorg
+
+ENTRY(sys_execve)
+		add	r3, sp, #S_OFF
+		b	__sys_execve
+ENDPROC(sys_execve)
+
+ENTRY(sys_clone)
+		add	ip, sp, #S_OFF
+		stw	ip, [sp+], #4
+		b	__sys_clone
+ENDPROC(sys_clone)
+
+ENTRY(sys_rt_sigreturn)
+		add	r0, sp, #S_OFF
+		mov	why, #0		@ prevent syscall restart handling
+		b	__sys_rt_sigreturn
+ENDPROC(sys_rt_sigreturn)
+
+ENTRY(sys_sigaltstack)
+		ldw	r2, [sp+], #S_OFF + S_SP
+		b	do_sigaltstack
+ENDPROC(sys_sigaltstack)
+
+	__INIT
+
+/*
+ * Vector stubs.
+ *
+ * This code is copied to 0xffff0200 so we can use branches in the
+ * vectors, rather than ldr's.  Note that this code must not
+ * exceed 0x300 bytes.
+ *
+ * Common stub entry macro:
+ *   Enter in INTR mode, bsr = PRIV/USER ASR, lr = PRIV/USER PC
+ *
+ * SP points to a minimal amount of processor-private memory, the address
+ * of which is copied into r0 for the mode specific abort handler.
+ */
+	.macro	vector_stub, name, mode
+	.align	5
+
+vector_\name:
+	@
+	@ Save r0, lr_<exception> (parent PC) and bsr_<exception>
+	@ (parent ASR)
+	@
+	stw	r0, [sp]
+	stw	lr, [sp+], #4		@ save r0, lr
+	mov	lr, bsr
+	stw	lr, [sp+], #8		@ save bsr
+
+	@
+	@ Prepare for PRIV mode.  INTRs remain disabled.
+	@
+	mov	r0, asr
+	xor	r0, r0, #(\mode ^ PRIV_MODE)
+	mov.a	bsr, r0
+
+	@
+	@ the branch table must immediately follow this code
+	@
+	and	lr, lr, #0x03
+	add	lr, lr, #1
+	mov	r0, sp
+	ldw	lr, [pc+], lr << #2
+	mov.a	pc, lr			@ branch to handler in PRIV mode
+ENDPROC(vector_\name)
+	.align	2
+	@ handler addresses follow this label
+	.endm
+
+	.globl	__stubs_start
+__stubs_start:
+/*
+ * Interrupt dispatcher
+ */
+	vector_stub	intr, INTR_MODE
+
+	.long	__intr_user			@  0  (USER)
+	.long	__invalid			@  1
+	.long	__invalid			@  2
+	.long	__intr_priv			@  3  (PRIV)
+
+/*
+ * Data abort dispatcher
+ * Enter in ABT mode, bsr = USER ASR, lr = USER PC
+ */
+	vector_stub	dabt, ABRT_MODE
+
+	.long	__dabt_user			@  0  (USER)
+	.long	__invalid			@  1
+	.long	__invalid			@  2  (INTR)
+	.long	__dabt_priv			@  3  (PRIV)
+
+/*
+ * Prefetch abort dispatcher
+ * Enter in ABT mode, bsr = USER ASR, lr = USER PC
+ */
+	vector_stub	pabt, ABRT_MODE
+
+	.long	__pabt_user			@  0 (USER)
+	.long	__invalid			@  1
+	.long	__invalid			@  2 (INTR)
+	.long	__pabt_priv			@  3 (PRIV)
+
+/*
+ * Undef instr entry dispatcher
+ * Enter in EXTN mode, bsr = PRIV/USER ASR, lr = PRIV/USER PC
+ */
+	vector_stub	extn, EXTN_MODE
+
+	.long	__extn_user			@  0 (USER)
+	.long	__invalid			@  1
+	.long	__invalid			@  2 (INTR)
+	.long	__extn_priv			@  3 (PRIV)
+
+/*
+ * We group all the following data together to optimise
+ * for CPUs with separate I & D caches.
+ */
+	.align	5
+
+.LCvswi:
+	.word	vector_swi
+
+	.globl	__stubs_end
+__stubs_end:
+
+	.equ	stubs_offset, __vectors_start + 0x200 - __stubs_start
+
+	.globl	__vectors_start
+__vectors_start:
+	jepriv	SYS_ERROR0
+	b	vector_extn + stubs_offset
+	ldw	pc, .LCvswi + stubs_offset
+	b	vector_pabt + stubs_offset
+	b	vector_dabt + stubs_offset
+	jepriv	SYS_ERROR0
+	b	vector_intr + stubs_offset
+	jepriv	SYS_ERROR0
+
+	.globl	__vectors_end
+__vectors_end:
+
+	.data
+
+	.globl	cr_alignment
+	.globl	cr_no_alignment
+cr_alignment:
+	.space	4
+cr_no_alignment:
+	.space	4
diff --git a/arch/unicore32/kernel/head.S b/arch/unicore32/kernel/head.S
new file mode 100644
index 0000000..92255f3
--- /dev/null
+++ b/arch/unicore32/kernel/head.S
@@ -0,0 +1,252 @@
+/*
+ * linux/arch/unicore32/kernel/head.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/linkage.h>
+#include <linux/init.h>
+
+#include <asm/assembler.h>
+#include <asm/ptrace.h>
+#include <generated/asm-offsets.h>
+#include <asm/memory.h>
+#include <asm/thread_info.h>
+#include <asm/system.h>
+#include <asm/pgtable-hwdef.h>
+
+#if (PHYS_OFFSET & 0x003fffff)
+#error "PHYS_OFFSET must be at an even 4MiB boundary!"
+#endif
+
+#define KERNEL_RAM_VADDR	(PAGE_OFFSET + KERNEL_IMAGE_START)
+#define KERNEL_RAM_PADDR	(PHYS_OFFSET + KERNEL_IMAGE_START)
+
+#define KERNEL_PGD_PADDR	(KERNEL_RAM_PADDR - 0x1000)
+#define KERNEL_PGD_VADDR	(KERNEL_RAM_VADDR - 0x1000)
+
+#define KERNEL_START		KERNEL_RAM_VADDR
+#define KERNEL_END		_end
+
+/*
+ * swapper_pg_dir is the virtual address of the initial page table.
+ * We place the page tables 4K below KERNEL_RAM_VADDR.  Therefore, we must
+ * make sure that KERNEL_RAM_VADDR is correctly set.  Currently, we expect
+ * the least significant 16 bits to be 0x8000, but we could probably
+ * relax this restriction to KERNEL_RAM_VADDR >= PAGE_OFFSET + 0x1000.
+ */
+#if (KERNEL_RAM_VADDR & 0xffff) != 0x8000
+#error KERNEL_RAM_VADDR must start at 0xXXXX8000
+#endif
+
+	.globl	swapper_pg_dir
+	.equ	swapper_pg_dir, KERNEL_RAM_VADDR - 0x1000
+
+/*
+ * Kernel startup entry point.
+ * ---------------------------
+ *
+ * This is normally called from the decompressor code.  The requirements
+ * are: MMU = off, D-cache = off, I-cache = dont care
+ *
+ * This code is mostly position independent, so if you link the kernel at
+ * 0xc0008000, you call this at __pa(0xc0008000).
+ */
+	__HEAD
+ENTRY(stext)
+	@ set asr
+	mov	r0, #PRIV_MODE			@ ensure priv mode
+	or	r0, #PSR_R_BIT | PSR_I_BIT	@ disable irqs
+	mov.a	asr, r0
+
+	@ process identify
+	movc	r0, p0.c0, #0			@ cpuid
+	movl	r1, 0xff00ffff			@ mask
+	movl	r2, 0x4d000863			@ value
+	and	r0, r1, r0
+	cxor.a	r0, r2
+	bne	__error_p			@ invalid processor id
+
+	/*
+	 * Clear the 4K level 1 swapper page table
+	 */
+	movl	r0, #KERNEL_PGD_PADDR		@ page table address
+	mov	r1, #0
+	add	r2, r0, #0x1000
+101:	stw.w	r1, [r0]+, #4
+	stw.w	r1, [r0]+, #4
+	stw.w	r1, [r0]+, #4
+	stw.w	r1, [r0]+, #4
+	cxor.a	r0, r2
+	bne	101b
+
+	movl	r4, #KERNEL_PGD_PADDR		@ page table address
+	mov	r7, #PMD_TYPE_SECT | PMD_PRESENT	@ page size: section
+	or	r7, r7, #PMD_SECT_CACHEABLE		@ cacheable
+	or	r7, r7, #PMD_SECT_READ | PMD_SECT_WRITE | PMD_SECT_EXEC
+
+	/*
+	 * Create identity mapping for first 4MB of kernel to
+	 * cater for the MMU enable.  This identity mapping
+	 * will be removed by paging_init().  We use our current program
+	 * counter to determine corresponding section base address.
+	 */
+	mov	r6, pc
+	mov	r6, r6 >> #22			@ start of kernel section
+	or	r1, r7, r6 << #22		@ flags + kernel base
+	stw	r1, [r4+], r6 << #2		@ identity mapping
+
+	/*
+	 * Now setup the pagetables for our kernel direct
+	 * mapped region.
+	 */
+	add	r0, r4,  #(KERNEL_START & 0xff000000) >> 20
+	stw.w	r1, [r0+], #(KERNEL_START & 0x00c00000) >> 20
+	movl	r6, #(KERNEL_END - 1)
+	add	r0, r0, #4
+	add	r6, r4, r6 >> #20
+102:	csub.a	r0, r6
+	add	r1, r1, #1 << 22
+	bua	103f
+	stw.w	r1, [r0]+, #4
+	b	102b
+103:
+	/*
+	 * Then map first 4MB of ram in case it contains our boot params.
+	 */
+	add	r0, r4, #PAGE_OFFSET >> 20
+	or	r6, r7, #(PHYS_OFFSET & 0xffc00000)
+	stw	r6, [r0]
+
+	ldw	r15, __switch_data		@ address to jump to after
+
+	/*
+	 * Initialise TLB, Caches, and MMU state ready to switch the MMU
+	 * on.
+	 */
+	mov	r0, #0
+	movc	p0.c5, r0, #28			@ cache invalidate all
+	nop8
+	movc	p0.c6, r0, #6			@ TLB invalidate all
+	nop8
+
+	/*
+	 * ..V. .... ..TB IDAM
+	 * ..1. .... ..01 1111
+	 */
+	movl	r0, #0x201f			@ control register setting
+
+	/*
+	 * Setup common bits before finally enabling the MMU.  Essentially
+	 * this is just loading the page table pointer and domain access
+	 * registers.
+	 */
+	#ifndef CONFIG_ALIGNMENT_TRAP
+		andn	r0, r0, #CR_A
+	#endif
+	#ifdef CONFIG_CPU_DCACHE_DISABLE
+		andn	r0, r0, #CR_D
+	#endif
+	#ifdef CONFIG_CPU_DCACHE_WRITETHROUGH
+		andn	r0, r0, #CR_B
+	#endif
+	#ifdef CONFIG_CPU_ICACHE_DISABLE
+		andn	r0, r0, #CR_I
+	#endif
+
+	movc	p0.c2, r4, #0			@ set pgd
+	b	__turn_mmu_on
+ENDPROC(stext)
+
+/*
+ * Enable the MMU.  This completely changes the stucture of the visible
+ * memory space.  You will not be able to trace execution through this.
+ *
+ *  r0  = cp#0 control register
+ *  r15 = *virtual* address to jump to upon completion
+ */
+	.align	5
+__turn_mmu_on:
+	mov	r0, r0
+	movc	p0.c1, r0, #0			@ write control reg
+	nop					@ fetch inst by phys addr
+	mov	pc, r15
+	nop8					@ fetch inst by phys addr
+ENDPROC(__turn_mmu_on)
+
+/*
+ * Setup the initial page tables.  We only setup the barest
+ * amount which are required to get the kernel running, which
+ * generally means mapping in the kernel code.
+ *
+ * r9  = cpuid
+ * r10 = procinfo
+ *
+ * Returns:
+ *  r0, r3, r6, r7 corrupted
+ *  r4 = physical page table address
+ */
+	.ltorg
+
+	.align	2
+	.type	__switch_data, %object
+__switch_data:
+	.long	__mmap_switched
+	.long	__bss_start			@ r6
+	.long	_end				@ r7
+	.long	cr_alignment			@ r8
+	.long	init_thread_union + THREAD_START_SP @ sp
+
+/*
+ * The following fragment of code is executed with the MMU on in MMU mode,
+ * and uses absolute addresses; this is not position independent.
+ *
+ *  r0  = cp#0 control register
+ */
+__mmap_switched:
+	adr	r3, __switch_data + 4
+
+	ldm.w	(r6, r7, r8), [r3]+
+	ldw	sp, [r3]
+
+	mov	fp, #0				@ Clear BSS (and zero fp)
+203:	csub.a	r6, r7
+	bea	204f
+	stw.w	fp, [r6]+,#4
+	b	203b
+204:
+	andn	r1, r0, #CR_A			@ Clear 'A' bit
+	stm	(r0, r1), [r8]+			@ Save control register values
+	b	start_kernel
+ENDPROC(__mmap_switched)
+
+/*
+ * Exception handling.  Something went wrong and we can't proceed.  We
+ * ought to tell the user, but since we don't have any guarantee that
+ * we're even running on the right architecture, we do virtually nothing.
+ *
+ * If CONFIG_DEBUG_LL is set we try to print out something about the error
+ * and hope for the best (useful if bootloader fails to pass a proper
+ * machine ID for example).
+ */
+__error_p:
+#ifdef CONFIG_DEBUG_LL
+	adr	r0, str_p1
+	b.l	printascii
+	mov	r0, r9
+	b.l	printhex8
+	adr	r0, str_p2
+	b.l	printascii
+901:	nop8
+	b	901b
+str_p1:	.asciz	"\nError: unrecognized processor variant (0x"
+str_p2:	.asciz	").\n"
+	.align
+#endif
+ENDPROC(__error_p)
+
diff --git a/arch/unicore32/kernel/setup.c b/arch/unicore32/kernel/setup.c
new file mode 100644
index 0000000..1e175a8
--- /dev/null
+++ b/arch/unicore32/kernel/setup.c
@@ -0,0 +1,360 @@
+/*
+ * linux/arch/unicore32/kernel/setup.c
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
+#include <linux/root_dev.h>
+#include <linux/cpu.h>
+#include <linux/interrupt.h>
+#include <linux/smp.h>
+#include <linux/fs.h>
+#include <linux/proc_fs.h>
+#include <linux/memblock.h>
+#include <linux/elf.h>
+#include <linux/io.h>
+
+#include <asm/cputype.h>
+#include <asm/sections.h>
+#include <asm/setup.h>
+#include <asm/cacheflush.h>
+#include <asm/tlbflush.h>
+#include <asm/traps.h>
+
+#include "setup.h"
+
+#ifndef MEM_SIZE
+#define MEM_SIZE	(16*1024*1024)
+#endif
+
+struct stack {
+	u32 irq[3];
+	u32 abt[3];
+	u32 und[3];
+} ____cacheline_aligned;
+
+static struct stack stacks[NR_CPUS];
+
+char elf_platform[ELF_PLATFORM_SIZE];
+EXPORT_SYMBOL(elf_platform);
+
+static char __initdata cmd_line[COMMAND_LINE_SIZE];
+
+static char default_command_line[COMMAND_LINE_SIZE] __initdata = CONFIG_CMDLINE;
+
+/*
+ * Standard memory resources
+ */
+static struct resource mem_res[] = {
+	{
+		.name = "Video RAM",
+		.start = 0,
+		.end = 0,
+		.flags = IORESOURCE_MEM
+	},
+	{
+		.name = "Kernel text",
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
+#define video_ram   mem_res[0]
+#define kernel_code mem_res[1]
+#define kernel_data mem_res[2]
+
+/*
+ * These functions re-use the assembly code in head.S, which
+ * already provide the required functionality.
+ */
+static void __init setup_processor(void)
+{
+	printk(KERN_DEFAULT "CPU: UniCore-II [%08x] revision %d, cr=%08lx\n",
+	       uc32_cpuid, (int)(uc32_cpuid >> 16) & 15, cr_alignment);
+
+	sprintf(init_utsname()->machine, "puv3");
+	sprintf(elf_platform, "ucv2");
+}
+
+/*
+ * cpu_init - initialise one CPU.
+ *
+ * cpu_init sets up the per-CPU stacks.
+ */
+void cpu_init(void)
+{
+	unsigned int cpu = smp_processor_id();
+	struct stack *stk = &stacks[cpu];
+
+	/*
+	 * setup stacks for re-entrant exception handlers
+	 */
+	__asm__ (
+	"mov.a	asr, %1\n\t"
+	"add	sp, %0, %2\n\t"
+	"mov.a	asr, %3\n\t"
+	"add	sp, %0, %4\n\t"
+	"mov.a	asr, %5\n\t"
+	"add	sp, %0, %6\n\t"
+	"mov.a	asr, %7"
+	    :
+	    : "r" (stk),
+	      "r" (PSR_R_BIT | PSR_I_BIT | INTR_MODE),
+	      "I" (offsetof(struct stack, irq[0])),
+	      "r" (PSR_R_BIT | PSR_I_BIT | ABRT_MODE),
+	      "I" (offsetof(struct stack, abt[0])),
+	      "r" (PSR_R_BIT | PSR_I_BIT | EXTN_MODE),
+	      "I" (offsetof(struct stack, und[0])),
+	      "r" (PSR_R_BIT | PSR_I_BIT | PRIV_MODE)
+	: "r30", "cc");
+}
+
+static int __init uc32_add_memory(unsigned long start, unsigned long size)
+{
+	struct membank *bank = &meminfo.bank[meminfo.nr_banks];
+
+	if (meminfo.nr_banks >= NR_BANKS) {
+		printk(KERN_CRIT "NR_BANKS too low, "
+			"ignoring memory at %#lx\n", start);
+		return -EINVAL;
+	}
+
+	/*
+	 * Ensure that start/size are aligned to a page boundary.
+	 * Size is appropriately rounded down, start is rounded up.
+	 */
+	size -= start & ~PAGE_MASK;
+
+	bank->start = PAGE_ALIGN(start);
+	bank->size  = size & PAGE_MASK;
+
+	/*
+	 * Check whether this memory region has non-zero size or
+	 * invalid node number.
+	 */
+	if (bank->size == 0)
+		return -EINVAL;
+
+	meminfo.nr_banks++;
+	return 0;
+}
+
+/*
+ * Pick out the memory size.  We look for mem=size@start,
+ * where start and size are "size[KkMm]"
+ */
+static int __init early_mem(char *p)
+{
+	static int usermem __initdata = 1;
+	unsigned long size, start;
+	char *endp;
+
+	/*
+	 * If the user specifies memory size, we
+	 * blow away any automatically generated
+	 * size.
+	 */
+	if (usermem) {
+		usermem = 0;
+		meminfo.nr_banks = 0;
+	}
+
+	start = PHYS_OFFSET;
+	size  = memparse(p, &endp);
+	if (*endp == '@')
+		start = memparse(endp + 1, NULL);
+
+	uc32_add_memory(start, size);
+
+	return 0;
+}
+early_param("mem", early_mem);
+
+static void __init
+request_standard_resources(struct meminfo *mi)
+{
+	struct resource *res;
+	int i;
+
+	kernel_code.start   = virt_to_phys(_stext);
+	kernel_code.end     = virt_to_phys(_etext - 1);
+	kernel_data.start   = virt_to_phys(_sdata);
+	kernel_data.end     = virt_to_phys(_end - 1);
+
+	for (i = 0; i < mi->nr_banks; i++) {
+		if (mi->bank[i].size == 0)
+			continue;
+
+		res = alloc_bootmem_low(sizeof(*res));
+		res->name  = "System RAM";
+		res->start = mi->bank[i].start;
+		res->end   = mi->bank[i].start + mi->bank[i].size - 1;
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
+
+	video_ram.start = PKUNITY_UNIGFX_MMAP_BASE;
+	video_ram.end   = PKUNITY_UNIGFX_MMAP_BASE + PKUNITY_UNIGFX_MMAP_SIZE;
+	request_resource(&iomem_resource, &video_ram);
+}
+
+static void (*init_machine)(void) __initdata;
+
+static int __init customize_machine(void)
+{
+	/* customizes platform devices, or adds new ones */
+	if (init_machine)
+		init_machine();
+	return 0;
+}
+arch_initcall(customize_machine);
+
+void __init setup_arch(char **cmdline_p)
+{
+	char *from = default_command_line;
+
+	setup_processor();
+
+	init_mm.start_code = (unsigned long) _stext;
+	init_mm.end_code   = (unsigned long) _etext;
+	init_mm.end_data   = (unsigned long) _edata;
+	init_mm.brk	   = (unsigned long) _end;
+
+	/* parse_early_param needs a boot_command_line */
+	strlcpy(boot_command_line, from, COMMAND_LINE_SIZE);
+
+	/* populate cmd_line too for later use, preserving boot_command_line */
+	strlcpy(cmd_line, boot_command_line, COMMAND_LINE_SIZE);
+	*cmdline_p = cmd_line;
+
+	parse_early_param();
+
+	uc32_memblock_init(&meminfo);
+
+	paging_init();
+	request_standard_resources(&meminfo);
+
+	cpu_init();
+
+	/*
+	 * Set up various architecture-specific pointers
+	 */
+	init_machine = puv3_core_init;
+
+#ifdef CONFIG_VT
+#if defined(CONFIG_VGA_CONSOLE)
+	conswitchp = &vga_con;
+#elif defined(CONFIG_DUMMY_CONSOLE)
+	conswitchp = &dummy_con;
+#endif
+#endif
+	early_trap_init();
+}
+
+static struct cpu cpuinfo_unicore;
+
+static int __init topology_init(void)
+{
+	int i;
+
+	for_each_possible_cpu(i)
+		register_cpu(&cpuinfo_unicore, i);
+
+	return 0;
+}
+subsys_initcall(topology_init);
+
+#ifdef CONFIG_HAVE_PROC_CPU
+static int __init proc_cpu_init(void)
+{
+	struct proc_dir_entry *res;
+
+	res = proc_mkdir("cpu", NULL);
+	if (!res)
+		return -ENOMEM;
+	return 0;
+}
+fs_initcall(proc_cpu_init);
+#endif
+
+static int c_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "Processor\t: UniCore-II rev %d (%s)\n",
+		   (int)(uc32_cpuid >> 16) & 15, elf_platform);
+
+	seq_printf(m, "BogoMIPS\t: %lu.%02lu\n",
+		   loops_per_jiffy / (500000/HZ),
+		   (loops_per_jiffy / (5000/HZ)) % 100);
+
+	/* dump out the processor features */
+	seq_puts(m, "Features\t: CMOV UC-F64");
+
+	seq_printf(m, "\nCPU implementer\t: 0x%02x\n", uc32_cpuid >> 24);
+	seq_printf(m, "CPU architecture: 2\n");
+	seq_printf(m, "CPU revision\t: %d\n", (uc32_cpuid >> 16) & 15);
+
+	seq_printf(m, "Cache type\t: write-back\n"
+			"Cache clean\t: cp0 c5 ops\n"
+			"Cache lockdown\t: not support\n"
+			"Cache format\t: Harvard\n");
+
+	seq_puts(m, "\n");
+
+	seq_printf(m, "Hardware\t: PKUnity v3\n");
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
diff --git a/arch/unicore32/kernel/setup.h b/arch/unicore32/kernel/setup.h
new file mode 100644
index 0000000..dcd1306
--- /dev/null
+++ b/arch/unicore32/kernel/setup.h
@@ -0,0 +1,30 @@
+/*
+ * linux/arch/unicore32/kernel/setup.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_KERNEL_SETUP_H__
+#define __UNICORE_KERNEL_SETUP_H__
+
+extern void paging_init(void);
+extern void puv3_core_init(void);
+
+extern void puv3_ps2_init(void);
+extern void pci_puv3_preinit(void);
+extern void __init puv3_init_gpio(void);
+
+extern void setup_mm_for_reboot(char mode);
+
+extern char __stubs_start[], __stubs_end[];
+extern char __vectors_start[], __vectors_end[];
+
+extern void kernel_thread_helper(void);
+
+extern void __init early_signal_init(void);
+#endif
diff --git a/arch/unicore32/kernel/traps.c b/arch/unicore32/kernel/traps.c
new file mode 100644
index 0000000..25abbb1
--- /dev/null
+++ b/arch/unicore32/kernel/traps.c
@@ -0,0 +1,333 @@
+/*
+ * linux/arch/unicore32/kernel/traps.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ *  'traps.c' handles hardware exceptions after we have saved some state.
+ *  Mostly a debugging aid, but will probably kill the offending process.
+ */
+#include <linux/module.h>
+#include <linux/signal.h>
+#include <linux/spinlock.h>
+#include <linux/personality.h>
+#include <linux/kallsyms.h>
+#include <linux/kdebug.h>
+#include <linux/uaccess.h>
+#include <linux/delay.h>
+#include <linux/hardirq.h>
+#include <linux/init.h>
+#include <linux/uaccess.h>
+#include <linux/atomic.h>
+#include <linux/unistd.h>
+
+#include <asm/cacheflush.h>
+#include <asm/system.h>
+#include <asm/traps.h>
+
+#include "setup.h"
+
+static void dump_mem(const char *, const char *, unsigned long, unsigned long);
+
+void dump_backtrace_entry(unsigned long where,
+		unsigned long from, unsigned long frame)
+{
+#ifdef CONFIG_KALLSYMS
+	printk(KERN_DEFAULT "[<%08lx>] (%pS) from [<%08lx>] (%pS)\n",
+			where, (void *)where, from, (void *)from);
+#else
+	printk(KERN_DEFAULT "Function entered at [<%08lx>] from [<%08lx>]\n",
+			where, from);
+#endif
+}
+
+/*
+ * Stack pointers should always be within the kernels view of
+ * physical memory.  If it is not there, then we can't dump
+ * out any information relating to the stack.
+ */
+static int verify_stack(unsigned long sp)
+{
+	if (sp < PAGE_OFFSET ||
+	    (sp > (unsigned long)high_memory && high_memory != NULL))
+		return -EFAULT;
+
+	return 0;
+}
+
+/*
+ * Dump out the contents of some memory nicely...
+ */
+static void dump_mem(const char *lvl, const char *str, unsigned long bottom,
+		     unsigned long top)
+{
+	unsigned long first;
+	mm_segment_t fs;
+	int i;
+
+	/*
+	 * We need to switch to kernel mode so that we can use __get_user
+	 * to safely read from kernel space.  Note that we now dump the
+	 * code first, just in case the backtrace kills us.
+	 */
+	fs = get_fs();
+	set_fs(KERNEL_DS);
+
+	printk(KERN_DEFAULT "%s%s(0x%08lx to 0x%08lx)\n",
+			lvl, str, bottom, top);
+
+	for (first = bottom & ~31; first < top; first += 32) {
+		unsigned long p;
+		char str[sizeof(" 12345678") * 8 + 1];
+
+		memset(str, ' ', sizeof(str));
+		str[sizeof(str) - 1] = '\0';
+
+		for (p = first, i = 0; i < 8 && p < top; i++, p += 4) {
+			if (p >= bottom && p < top) {
+				unsigned long val;
+				if (__get_user(val, (unsigned long *)p) == 0)
+					sprintf(str + i * 9, " %08lx", val);
+				else
+					sprintf(str + i * 9, " ????????");
+			}
+		}
+		printk(KERN_DEFAULT "%s%04lx:%s\n", lvl, first & 0xffff, str);
+	}
+
+	set_fs(fs);
+}
+
+static void dump_instr(const char *lvl, struct pt_regs *regs)
+{
+	unsigned long addr = instruction_pointer(regs);
+	const int width = 8;
+	mm_segment_t fs;
+	char str[sizeof("00000000 ") * 5 + 2 + 1], *p = str;
+	int i;
+
+	/*
+	 * We need to switch to kernel mode so that we can use __get_user
+	 * to safely read from kernel space.  Note that we now dump the
+	 * code first, just in case the backtrace kills us.
+	 */
+	fs = get_fs();
+	set_fs(KERNEL_DS);
+
+	for (i = -4; i < 1; i++) {
+		unsigned int val, bad;
+
+		bad = __get_user(val, &((u32 *)addr)[i]);
+
+		if (!bad)
+			p += sprintf(p, i == 0 ? "(%0*x) " : "%0*x ",
+					width, val);
+		else {
+			p += sprintf(p, "bad PC value");
+			break;
+		}
+	}
+	printk(KERN_DEFAULT "%sCode: %s\n", lvl, str);
+
+	set_fs(fs);
+}
+
+static void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
+{
+	unsigned int fp, mode;
+	int ok = 1;
+
+	printk(KERN_DEFAULT "Backtrace: ");
+
+	if (!tsk)
+		tsk = current;
+
+	if (regs) {
+		fp = regs->UCreg_fp;
+		mode = processor_mode(regs);
+	} else if (tsk != current) {
+		fp = thread_saved_fp(tsk);
+		mode = 0x10;
+	} else {
+		asm("mov %0, fp" : "=r" (fp) : : "cc");
+		mode = 0x10;
+	}
+
+	if (!fp) {
+		printk("no frame pointer");
+		ok = 0;
+	} else if (verify_stack(fp)) {
+		printk("invalid frame pointer 0x%08x", fp);
+		ok = 0;
+	} else if (fp < (unsigned long)end_of_stack(tsk))
+		printk("frame pointer underflow");
+	printk("\n");
+
+	if (ok)
+		c_backtrace(fp, mode);
+}
+
+void dump_stack(void)
+{
+	dump_backtrace(NULL, NULL);
+}
+EXPORT_SYMBOL(dump_stack);
+
+void show_stack(struct task_struct *tsk, unsigned long *sp)
+{
+	dump_backtrace(NULL, tsk);
+	barrier();
+}
+
+static int __die(const char *str, int err, struct thread_info *thread,
+		struct pt_regs *regs)
+{
+	struct task_struct *tsk = thread->task;
+	static int die_counter;
+	int ret;
+
+	printk(KERN_EMERG "Internal error: %s: %x [#%d]\n",
+	       str, err, ++die_counter);
+	sysfs_printk_last_file();
+
+	/* trap and error numbers are mostly meaningless on UniCore */
+	ret = notify_die(DIE_OOPS, str, regs, err, tsk->thread.trap_no, \
+			SIGSEGV);
+	if (ret == NOTIFY_STOP)
+		return ret;
+
+	print_modules();
+	__show_regs(regs);
+	printk(KERN_EMERG "Process %.*s (pid: %d, stack limit = 0x%p)\n",
+		TASK_COMM_LEN, tsk->comm, task_pid_nr(tsk), thread + 1);
+
+	if (!user_mode(regs) || in_interrupt()) {
+		dump_mem(KERN_EMERG, "Stack: ", regs->UCreg_sp,
+			 THREAD_SIZE + (unsigned long)task_stack_page(tsk));
+		dump_backtrace(regs, tsk);
+		dump_instr(KERN_EMERG, regs);
+	}
+
+	return ret;
+}
+
+DEFINE_SPINLOCK(die_lock);
+
+/*
+ * This function is protected against re-entrancy.
+ */
+void die(const char *str, struct pt_regs *regs, int err)
+{
+	struct thread_info *thread = current_thread_info();
+	int ret;
+
+	oops_enter();
+
+	spin_lock_irq(&die_lock);
+	console_verbose();
+	bust_spinlocks(1);
+	ret = __die(str, err, thread, regs);
+
+	bust_spinlocks(0);
+	add_taint(TAINT_DIE);
+	spin_unlock_irq(&die_lock);
+	oops_exit();
+
+	if (in_interrupt())
+		panic("Fatal exception in interrupt");
+	if (panic_on_oops)
+		panic("Fatal exception");
+	if (ret != NOTIFY_STOP)
+		do_exit(SIGSEGV);
+}
+
+void uc32_notify_die(const char *str, struct pt_regs *regs,
+		struct siginfo *info, unsigned long err, unsigned long trap)
+{
+	if (user_mode(regs)) {
+		current->thread.error_code = err;
+		current->thread.trap_no = trap;
+
+		force_sig_info(info->si_signo, info, current);
+	} else
+		die(str, regs, err);
+}
+
+/*
+ * bad_mode handles the impossible case in the vectors.  If you see one of
+ * these, then it's extremely serious, and could mean you have buggy hardware.
+ * It never returns, and never tries to sync.  We hope that we can at least
+ * dump out some state information...
+ */
+asmlinkage void bad_mode(struct pt_regs *regs, unsigned int reason)
+{
+	console_verbose();
+
+	printk(KERN_CRIT "Bad mode detected with reason 0x%x\n", reason);
+
+	die("Oops - bad mode", regs, 0);
+	local_irq_disable();
+	panic("bad mode");
+}
+
+void __pte_error(const char *file, int line, unsigned long val)
+{
+	printk(KERN_DEFAULT "%s:%d: bad pte %08lx.\n", file, line, val);
+}
+
+void __pmd_error(const char *file, int line, unsigned long val)
+{
+	printk(KERN_DEFAULT "%s:%d: bad pmd %08lx.\n", file, line, val);
+}
+
+void __pgd_error(const char *file, int line, unsigned long val)
+{
+	printk(KERN_DEFAULT "%s:%d: bad pgd %08lx.\n", file, line, val);
+}
+
+asmlinkage void __div0(void)
+{
+	printk(KERN_DEFAULT "Division by zero in kernel.\n");
+	dump_stack();
+}
+EXPORT_SYMBOL(__div0);
+
+void abort(void)
+{
+	BUG();
+
+	/* if that doesn't kill us, halt */
+	panic("Oops failed to kill thread");
+}
+EXPORT_SYMBOL(abort);
+
+void __init trap_init(void)
+{
+	return;
+}
+
+void __init early_trap_init(void)
+{
+	unsigned long vectors = VECTORS_BASE;
+
+	/*
+	 * Copy the vectors, stubs (in entry-unicore.S)
+	 * into the vector page, mapped at 0xffff0000, and ensure these
+	 * are visible to the instruction stream.
+	 */
+	memcpy((void *)vectors,
+			__vectors_start,
+			__vectors_end - __vectors_start);
+	memcpy((void *)vectors + 0x200,
+			__stubs_start,
+			__stubs_end - __stubs_start);
+
+	early_signal_init();
+
+	flush_icache_range(vectors, vectors + PAGE_SIZE);
+}
-- 
1.7.0.4


