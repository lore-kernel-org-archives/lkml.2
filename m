Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab2IGQ2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:28:21 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34192 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab2IGQ1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:27:52 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 03/31] arm64: Exception handling
Date: Fri,  7 Sep 2012 17:26:38 +0100
Message-Id: <1347035226-18649-4-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Sep 2012 16:27:48.0628 (UTC) FILETIME=[B81BED40:01CD8D15]
X-MC-Unique: 112090717275009401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q87GSZMf008340

The patch contains the exception entry code (kernel/entry.S), pt_regs
structure and related accessors, undefined instruction trapping and
stack tracing.

AArch64 Linux kernel (including kernel threads) runs in EL1 mode using
the SP1 stack. The vectors don't have a fixed address, only alignment
(2^11) requirements.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm64/include/asm/ptrace.h     |  212 +++++++++++
 arch/arm64/include/asm/stacktrace.h |   29 ++
 arch/arm64/include/asm/traps.h      |   30 ++
 arch/arm64/kernel/entry.S           |  695 +++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/stacktrace.c      |  127 +++++++
 arch/arm64/kernel/traps.c           |  348 ++++++++++++++++++
 6 files changed, 1441 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm64/include/asm/ptrace.h
 create mode 100644 arch/arm64/include/asm/stacktrace.h
 create mode 100644 arch/arm64/include/asm/traps.h
 create mode 100644 arch/arm64/kernel/entry.S
 create mode 100644 arch/arm64/kernel/stacktrace.c
 create mode 100644 arch/arm64/kernel/traps.c

diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
new file mode 100644
index 0000000..b0a2e1f
--- /dev/null
+++ b/arch/arm64/include/asm/ptrace.h
@@ -0,0 +1,212 @@
+/*
+ * Based on arch/arm/include/asm/ptrace.h
+ *
+ * Copyright (C) 1996-2003 Russell King
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
+#ifndef __ASM_PTRACE_H
+#define __ASM_PTRACE_H
+
+#include <linux/types.h>
+
+#include <asm/hwcap.h>
+
+#define PTRACE_GETREGS		12
+#define PTRACE_SETREGS		13
+#define PTRACE_GETFPSIMDREGS	14
+#define PTRACE_SETFPSIMDREGS	15
+/* PTRACE_ATTACH is 16 */
+/* PTRACE_DETACH is 17 */
+#define PTRACE_GET_THREAD_AREA	22
+#define PTRACE_SET_SYSCALL	23
+#define PTRACE_GETHBPREGS	29
+#define PTRACE_SETHBPREGS	30
+
+/* AArch32-specific ptrace requests */
+#define COMPAT_PTRACE_GETVFPREGS	27
+#define COMPAT_PTRACE_SETVFPREGS	28
+
+/*
+ * PSR bits
+ */
+#define PSR_MODE_EL0t	0x00000000
+#define PSR_MODE_EL1t	0x00000004
+#define PSR_MODE_EL1h	0x00000005
+#define PSR_MODE_EL2t	0x00000008
+#define PSR_MODE_EL2h	0x00000009
+#define PSR_MODE_EL3t	0x0000000c
+#define PSR_MODE_EL3h	0x0000000d
+#define PSR_MODE_MASK	0x0000000f
+
+/* AArch32 CPSR bits */
+#define PSR_MODE32_BIT		0x00000010
+#define COMPAT_PSR_MODE_USR	0x00000010
+#define COMPAT_PSR_T_BIT	0x00000020
+#define COMPAT_PSR_IT_MASK	0x0600fc00	/* If-Then execution state mask */
+
+/* AArch64 SPSR bits */
+#define PSR_F_BIT	0x00000040
+#define PSR_I_BIT	0x00000080
+#define PSR_A_BIT	0x00000100
+#define PSR_D_BIT	0x00000200
+#define PSR_Q_BIT	0x08000000
+#define PSR_V_BIT	0x10000000
+#define PSR_C_BIT	0x20000000
+#define PSR_Z_BIT	0x40000000
+#define PSR_N_BIT	0x80000000
+
+/*
+ * Groups of PSR bits
+ */
+#define PSR_f		0xff000000	/* Flags		*/
+#define PSR_s		0x00ff0000	/* Status		*/
+#define PSR_x		0x0000ff00	/* Extension		*/
+#define PSR_c		0x000000ff	/* Control		*/
+
+/*
+ * These are 'magic' values for PTRACE_PEEKUSR that return info about where a
+ * process is located in memory.
+ */
+#define PT_TEXT_ADDR		0x10000
+#define PT_DATA_ADDR		0x10004
+#define PT_TEXT_END_ADDR	0x10008
+
+#ifndef __ASSEMBLY__
+
+/*
+ * User structures for general purpose, floating point and debug registers.
+ */
+struct user_pt_regs {
+	__u64		regs[31];
+	__u64		sp;
+	__u64		pc;
+	__u64		pstate;
+};
+
+struct user_fpsimd_state {
+	__uint128_t	vregs[32];
+	__u32		fpsr;
+	__u32		fpcr;
+};
+
+struct user_hwdebug_state {
+	__u32		dbg_info;
+	struct {
+		__u64	addr;
+		__u32	ctrl;
+	}		dbg_regs[16];
+};
+
+#ifdef __KERNEL__
+
+/* sizeof(struct user) for AArch32 */
+#define COMPAT_USER_SZ	296
+/* AArch32 uses x13 as the stack pointer... */
+#define compat_sp	regs[13]
+/* ... and x14 as the link register. */
+#define compat_lr	regs[14]
+
+/*
+ * This struct defines the way the registers are stored on the stack during an
+ * exception. Note that sizeof(struct pt_regs) has to be a multiple of 16 (for
+ * stack alignment). struct user_pt_regs must form a prefix of struct pt_regs.
+ */
+struct pt_regs {
+	union {
+		struct user_pt_regs user_regs;
+		struct {
+			u64 regs[31];
+			u64 sp;
+			u64 pc;
+			u64 pstate;
+		};
+	};
+	u64 orig_x0;
+	u64 syscallno;
+};
+
+#define arch_has_single_step()	(1)
+
+#ifdef CONFIG_COMPAT
+#define compat_thumb_mode(regs) \
+	(((regs)->pstate & COMPAT_PSR_T_BIT))
+#else
+#define compat_thumb_mode(regs) (0)
+#endif
+
+#define user_mode(regs)	\
+	(((regs)->pstate & PSR_MODE_MASK) == PSR_MODE_EL0t)
+
+#define compat_user_mode(regs)	\
+	(((regs)->pstate & (PSR_MODE32_BIT | PSR_MODE_MASK)) == \
+	 (PSR_MODE32_BIT | PSR_MODE_EL0t))
+
+#define processor_mode(regs) \
+	((regs)->pstate & PSR_MODE_MASK)
+
+#define interrupts_enabled(regs) \
+	(!((regs)->pstate & PSR_I_BIT))
+
+#define fast_interrupts_enabled(regs) \
+	(!((regs)->pstate & PSR_F_BIT))
+
+#define user_stack_pointer(regs) \
+	((regs)->sp)
+
+/*
+ * Are the current registers suitable for user mode? (used to maintain
+ * security in signal handlers)
+ */
+static inline int valid_user_regs(struct user_pt_regs *regs)
+{
+	if (user_mode(regs) && (regs->pstate & PSR_I_BIT) == 0) {
+		regs->pstate &= ~(PSR_F_BIT | PSR_A_BIT);
+
+		/* The T bit is reserved for AArch64 */
+		if (!(regs->pstate & PSR_MODE32_BIT))
+			regs->pstate &= ~COMPAT_PSR_T_BIT;
+
+		return 1;
+	}
+
+	/*
+	 * Force PSR to something logical...
+	 */
+	regs->pstate &= PSR_f | PSR_s | (PSR_x & ~PSR_A_BIT) | \
+			COMPAT_PSR_T_BIT | PSR_MODE32_BIT;
+
+	if (!(regs->pstate & PSR_MODE32_BIT)) {
+		regs->pstate &= ~COMPAT_PSR_T_BIT;
+		regs->pstate |= PSR_MODE_EL0t;
+	}
+
+	return 0;
+}
+
+#define instruction_pointer(regs)	(regs)->pc
+
+#ifdef CONFIG_SMP
+extern unsigned long profile_pc(struct pt_regs *regs);
+#else
+#define profile_pc(regs) instruction_pointer(regs)
+#endif
+
+extern int aarch32_break_trap(struct pt_regs *regs);
+
+#endif /* __KERNEL__ */
+
+#endif /* __ASSEMBLY__ */
+
+#endif
diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
new file mode 100644
index 0000000..7318f6d
--- /dev/null
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -0,0 +1,29 @@
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
+#ifndef __ASM_STACKTRACE_H
+#define __ASM_STACKTRACE_H
+
+struct stackframe {
+	unsigned long fp;
+	unsigned long sp;
+	unsigned long pc;
+};
+
+extern int unwind_frame(struct stackframe *frame);
+extern void walk_stackframe(struct stackframe *frame,
+			    int (*fn)(struct stackframe *, void *), void *data);
+
+#endif	/* __ASM_STACKTRACE_H */
diff --git a/arch/arm64/include/asm/traps.h b/arch/arm64/include/asm/traps.h
new file mode 100644
index 0000000..10ca8ff
--- /dev/null
+++ b/arch/arm64/include/asm/traps.h
@@ -0,0 +1,30 @@
+/*
+ * Based on arch/arm/include/asm/traps.h
+ *
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
+#ifndef __ASM_TRAP_H
+#define __ASM_TRAP_H
+
+static inline int in_exception_text(unsigned long ptr)
+{
+	extern char __exception_text_start[];
+	extern char __exception_text_end[];
+
+	return ptr >= (unsigned long)&__exception_text_start &&
+	       ptr < (unsigned long)&__exception_text_end;
+}
+
+#endif
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
new file mode 100644
index 0000000..ed2e58f
--- /dev/null
+++ b/arch/arm64/kernel/entry.S
@@ -0,0 +1,695 @@
+/*
+ * Low-level exception handling code
+ *
+ * Copyright (C) 2012 ARM Ltd.
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
+#include <linux/init.h>
+#include <linux/linkage.h>
+
+#include <asm/assembler.h>
+#include <asm/asm-offsets.h>
+#include <asm/errno.h>
+#include <asm/thread_info.h>
+#include <asm/unistd.h>
+
+/*
+ * Bad Abort numbers
+ *-----------------
+ */
+#define BAD_SYNC	0
+#define BAD_IRQ		1
+#define BAD_FIQ		2
+#define BAD_ERROR	3
+
+	.macro	kernel_entry, el, regsize = 64
+	sub	sp, sp, #S_FRAME_SIZE - S_LR	// room for LR, SP, SPSR, ELR
+	.if	\regsize == 32
+	mov	w0, w0				// zero upper 32 bits of x0
+	.endif
+	push	x28, x29
+	push	x26, x27
+	push	x24, x25
+	push	x22, x23
+	push	x20, x21
+	push	x18, x19
+	push	x16, x17
+	push	x14, x15
+	push	x12, x13
+	push	x10, x11
+	push	x8, x9
+	push	x6, x7
+	push	x4, x5
+	push	x2, x3
+	push	x0, x1
+	.if	\el == 0
+	mrs	x21, sp_el0
+	.else
+	add	x21, sp, #S_FRAME_SIZE
+	.endif
+	mrs	x22, elr_el1
+	mrs	x23, spsr_el1
+	stp	lr, x21, [sp, #S_LR]
+	stp	x22, x23, [sp, #S_PC]
+
+	/*
+	 * Set syscallno to -1 by default (overridden later if real syscall).
+	 */
+	.if	\el == 0
+	mvn	x21, xzr
+	str	x21, [sp, #S_SYSCALLNO]
+	.endif
+
+	/*
+	 * Registers that may be useful after this macro is invoked:
+	 *
+	 * x21 - aborted SP
+	 * x22 - aborted PC
+	 * x23 - aborted PSTATE
+	*/
+	.endm
+
+	.macro	kernel_exit, el, ret = 0
+	ldp	x21, x22, [sp, #S_PC]		// load ELR, SPSR
+	.if	\el == 0
+	ldr	x23, [sp, #S_SP]		// load return stack pointer
+	.endif
+	.if	\ret
+	ldr	x1, [sp, #S_X1]			// preserve x0 (syscall return)
+	add	sp, sp, S_X2
+	.else
+	pop	x0, x1
+	.endif
+	pop	x2, x3				// load the rest of the registers
+	pop	x4, x5
+	pop	x6, x7
+	pop	x8, x9
+	msr	elr_el1, x21			// set up the return data
+	msr	spsr_el1, x22
+	.if	\el == 0
+	msr	sp_el0, x23
+	.endif
+	pop	x10, x11
+	pop	x12, x13
+	pop	x14, x15
+	pop	x16, x17
+	pop	x18, x19
+	pop	x20, x21
+	pop	x22, x23
+	pop	x24, x25
+	pop	x26, x27
+	pop	x28, x29
+	ldr	lr, [sp], #S_FRAME_SIZE - S_LR	// load LR and restore SP
+	eret					// return to kernel
+	.endm
+
+	.macro	get_thread_info, rd
+	mov	\rd, sp
+	and	\rd, \rd, #~((1 << 13) - 1)	// top of 8K stack
+	.endm
+
+/*
+ * These are the registers used in the syscall handler, and allow us to
+ * have in theory up to 7 arguments to a function - x0 to x6.
+ *
+ * x7 is reserved for the system call number in 32-bit mode.
+ */
+sc_nr	.req	x25		// number of system calls
+scno	.req	x26		// syscall number
+stbl	.req	x27		// syscall table pointer
+tsk	.req	x28		// current thread_info
+
+/*
+ * Interrupt handling.
+ */
+	.macro	irq_handler
+	ldr	x1, handle_arch_irq
+	mov	x0, sp
+	blr	x1
+	.endm
+
+	.text
+
+/*
+ * Exception vectors.
+ */
+	.macro	ventry	label
+	.align	7
+	b	\label
+	.endm
+
+	.align	11
+ENTRY(vectors)
+	ventry	el1_sync_invalid		// Synchronous EL1t
+	ventry	el1_irq_invalid			// IRQ EL1t
+	ventry	el1_fiq_invalid			// FIQ EL1t
+	ventry	el1_error_invalid		// Error EL1t
+
+	ventry	el1_sync			// Synchronous EL1h
+	ventry	el1_irq				// IRQ EL1h
+	ventry	el1_fiq_invalid			// FIQ EL1h
+	ventry	el1_error_invalid		// Error EL1h
+
+	ventry	el0_sync			// Synchronous 64-bit EL0
+	ventry	el0_irq				// IRQ 64-bit EL0
+	ventry	el0_fiq_invalid			// FIQ 64-bit EL0
+	ventry	el0_error_invalid		// Error 64-bit EL0
+
+#ifdef CONFIG_COMPAT
+	ventry	el0_sync_compat			// Synchronous 32-bit EL0
+	ventry	el0_irq_compat			// IRQ 32-bit EL0
+	ventry	el0_fiq_invalid_compat		// FIQ 32-bit EL0
+	ventry	el0_error_invalid_compat	// Error 32-bit EL0
+#else
+	ventry	el0_sync_invalid		// Synchronous 32-bit EL0
+	ventry	el0_irq_invalid			// IRQ 32-bit EL0
+	ventry	el0_fiq_invalid			// FIQ 32-bit EL0
+	ventry	el0_error_invalid		// Error 32-bit EL0
+#endif
+END(vectors)
+
+/*
+ * Invalid mode handlers
+ */
+	.macro	inv_entry, el, reason, regsize = 64
+	kernel_entry el, \regsize
+	mov	x0, sp
+	mov	x1, #\reason
+	mrs	x2, esr_el1
+	b	bad_mode
+	.endm
+
+el0_sync_invalid:
+	inv_entry 0, BAD_SYNC
+ENDPROC(el0_sync_invalid)
+
+el0_irq_invalid:
+	inv_entry 0, BAD_IRQ
+ENDPROC(el0_irq_invalid)
+
+el0_fiq_invalid:
+	inv_entry 0, BAD_FIQ
+ENDPROC(el0_fiq_invalid)
+
+el0_error_invalid:
+	inv_entry 0, BAD_ERROR
+ENDPROC(el0_error_invalid)
+
+#ifdef CONFIG_COMPAT
+el0_fiq_invalid_compat:
+	inv_entry 0, BAD_FIQ, 32
+ENDPROC(el0_fiq_invalid_compat)
+
+el0_error_invalid_compat:
+	inv_entry 0, BAD_ERROR, 32
+ENDPROC(el0_error_invalid_compat)
+#endif
+
+el1_sync_invalid:
+	inv_entry 1, BAD_SYNC
+ENDPROC(el1_sync_invalid)
+
+el1_irq_invalid:
+	inv_entry 1, BAD_IRQ
+ENDPROC(el1_irq_invalid)
+
+el1_fiq_invalid:
+	inv_entry 1, BAD_FIQ
+ENDPROC(el1_fiq_invalid)
+
+el1_error_invalid:
+	inv_entry 1, BAD_ERROR
+ENDPROC(el1_error_invalid)
+
+/*
+ * EL1 mode handlers.
+ */
+	.align	6
+el1_sync:
+	kernel_entry 1
+	mrs	x1, esr_el1			// read the syndrome register
+	lsr	x24, x1, #26			// exception class
+	cmp	x24, #0x25			// data abort in EL1
+	b.eq	el1_da
+	cmp	x24, #0x18			// configurable trap
+	b.eq	el1_undef
+	cmp	x24, #0x26			// stack alignment exception
+	b.eq	el1_sp_pc
+	cmp	x24, #0x22			// pc alignment exception
+	b.eq	el1_sp_pc
+	cmp	x24, #0x00			// unknown exception in EL1
+	b.eq	el1_undef
+	cmp	x24, #0x30			// debug exception in EL1
+	b.ge	el1_dbg
+	b	el1_inv
+el1_da:
+	/*
+	 * Data abort handling
+	 */
+	mrs	x0, far_el1
+	enable_dbg_if_not_stepping x2
+	// re-enable interrupts if they were enabled in the aborted context
+	tbnz	x23, #7, 1f			// PSR_I_BIT
+	enable_irq
+1:
+	mov	x2, sp				// struct pt_regs
+	bl	do_mem_abort
+
+	// disable interrupts before pulling preserved data off the stack
+	disable_irq
+	kernel_exit 1
+el1_sp_pc:
+	/*
+	 * Stack or PC alignment exception handling
+	 */
+	mrs	x0, far_el1
+	mov	x1, x25
+	mov	x2, sp
+	b	do_sp_pc_abort
+el1_undef:
+	/*
+	 * Undefined instruction
+	 */
+	mov	x0, sp
+	b	do_undefinstr
+el1_dbg:
+	/*
+	 * Debug exception handling
+	 */
+	tbz	x24, #0, el1_inv		// EL1 only
+	mrs	x0, far_el1
+	mov	x2, sp				// struct pt_regs
+	bl	do_debug_exception
+
+	kernel_exit 1
+el1_inv:
+	// TODO: add support for undefined instructions in kernel mode
+	mov	x0, sp
+	mov	x1, #BAD_SYNC
+	mrs	x2, esr_el1
+	b	bad_mode
+ENDPROC(el1_sync)
+
+	.align	6
+el1_irq:
+	kernel_entry 1
+	enable_dbg_if_not_stepping x0
+#ifdef CONFIG_TRACE_IRQFLAGS
+	bl	trace_hardirqs_off
+#endif
+#ifdef CONFIG_PREEMPT
+	get_thread_info tsk
+	ldr	x24, [tsk, #TI_PREEMPT]		// get preempt count
+	add	x0, x24, #1			// increment it
+	str	x0, [tsk, #TI_PREEMPT]
+#endif
+	irq_handler
+#ifdef CONFIG_PREEMPT
+	str	x24, [tsk, #TI_PREEMPT]		// restore preempt count
+	cbnz	x24, 1f				// preempt count != 0
+	ldr	x0, [tsk, #TI_FLAGS]		// get flags
+	tbz	x0, #TIF_NEED_RESCHED, 1f	// needs rescheduling?
+	bl	el1_preempt
+1:
+#endif
+#ifdef CONFIG_TRACE_IRQFLAGS
+	bl	trace_hardirqs_on
+#endif
+	kernel_exit 1
+ENDPROC(el1_irq)
+
+#ifdef CONFIG_PREEMPT
+el1_preempt:
+	mov	x24, lr
+1:	enable_dbg
+	bl	preempt_schedule_irq		// irq en/disable is done inside
+	ldr	x0, [tsk, #TI_FLAGS]		// get new tasks TI_FLAGS
+	tbnz	x0, #TIF_NEED_RESCHED, 1b	// needs rescheduling?
+	ret	x24
+#endif
+
+/*
+ * EL0 mode handlers.
+ */
+	.align	6
+el0_sync:
+	kernel_entry 0
+	mrs	x25, esr_el1			// read the syndrome register
+	lsr	x24, x25, #26			// exception class
+	cmp	x24, #0x15			// SVC in 64-bit state
+	b.eq	el0_svc
+	adr	lr, ret_from_exception
+	cmp	x24, #0x24			// data abort in EL0
+	b.eq	el0_da
+	cmp	x24, #0x20			// instruction abort in EL0
+	b.eq	el0_ia
+	cmp	x24, #0x07			// FP/ASIMD access
+	b.eq	el0_fpsimd_acc
+	cmp	x24, #0x2c			// FP/ASIMD exception
+	b.eq	el0_fpsimd_exc
+	cmp	x24, #0x18			// configurable trap
+	b.eq	el0_undef
+	cmp	x24, #0x26			// stack alignment exception
+	b.eq	el0_sp_pc
+	cmp	x24, #0x22			// pc alignment exception
+	b.eq	el0_sp_pc
+	cmp	x24, #0x00			// unknown exception in EL0
+	b.eq	el0_undef
+	cmp	x24, #0x30			// debug exception in EL0
+	b.ge	el0_dbg
+	b	el0_inv
+
+#ifdef CONFIG_COMPAT
+	.align	6
+el0_sync_compat:
+	kernel_entry 0, 32
+	mrs	x25, esr_el1			// read the syndrome register
+	lsr	x24, x25, #26			// exception class
+	cmp	x24, #0x11			// SVC in 32-bit state
+	b.eq	el0_svc_compat
+	adr	lr, ret_from_exception
+	cmp	x24, #0x24			// data abort in EL0
+	b.eq	el0_da
+	cmp	x24, #0x20			// instruction abort in EL0
+	b.eq	el0_ia
+	cmp	x24, #0x07			// FP/ASIMD access
+	b.eq	el0_fpsimd_acc
+	cmp	x24, #0x28			// FP/ASIMD exception
+	b.eq	el0_fpsimd_exc
+	cmp	x24, #0x00			// unknown exception in EL0
+	b.eq	el0_undef
+	cmp	x24, #0x30			// debug exception in EL0
+	b.ge	el0_dbg
+	b	el0_inv
+el0_svc_compat:
+	/*
+	 * AArch32 syscall handling
+	 */
+	adr	stbl, compat_sys_call_table	// load compat syscall table pointer
+	uxtw	scno, w7			// syscall number in w7 (r7)
+	mov     sc_nr, #__NR_compat_syscalls
+	b	el0_svc_naked
+
+	.align	6
+el0_irq_compat:
+	kernel_entry 0, 32
+	b	el0_irq_naked
+#endif
+
+el0_da:
+	/*
+	 * Data abort handling
+	 */
+	mrs	x0, far_el1
+	disable_step x1
+	isb
+	enable_dbg
+	// enable interrupts before calling the main handler
+	enable_irq
+	mov	x1, x25
+	mov	x2, sp
+	b	do_mem_abort
+el0_ia:
+	/*
+	 * Instruction abort handling
+	 */
+	mrs	x0, far_el1
+	disable_step x1
+	isb
+	enable_dbg
+	// enable interrupts before calling the main handler
+	enable_irq
+	orr	x1, x25, #1 << 24		// use reserved ISS bit for instruction aborts
+	mov	x2, sp
+	b	do_mem_abort
+el0_fpsimd_acc:
+	/*
+	 * Floating Point or Advanced SIMD access
+	 */
+	mov	x0, x25
+	mov	x1, sp
+	b	do_fpsimd_acc
+el0_fpsimd_exc:
+	/*
+	 * Floating Point or Advanced SIMD exception
+	 */
+	mov	x0, x25
+	mov	x1, sp
+	b	do_fpsimd_exc
+el0_sp_pc:
+	/*
+	 * Stack or PC alignment exception handling
+	 */
+	mrs	x0, far_el1
+	disable_step x1
+	isb
+	enable_dbg
+	// enable interrupts before calling the main handler
+	enable_irq
+	mov	x1, x25
+	mov	x2, sp
+	b	do_sp_pc_abort
+el0_undef:
+	/*
+	 * Undefined instruction
+	 */
+	mov	x0, sp
+	b	do_undefinstr
+el0_dbg:
+	/*
+	 * Debug exception handling
+	 */
+	tbnz	x24, #0, el0_inv		// EL0 only
+	mrs	x0, far_el1
+	disable_step x1
+	mov	x1, x25
+	mov	x2, sp
+	b	do_debug_exception
+el0_inv:
+	mov	x0, sp
+	mov	x1, #BAD_SYNC
+	mrs	x2, esr_el1
+	b	bad_mode
+ENDPROC(el0_sync)
+
+	.align	6
+el0_irq:
+	kernel_entry 0
+el0_irq_naked:
+	disable_step x1
+	isb
+	enable_dbg
+#ifdef CONFIG_TRACE_IRQFLAGS
+	bl	trace_hardirqs_off
+#endif
+	get_thread_info tsk
+#ifdef CONFIG_PREEMPT
+	ldr	x24, [tsk, #TI_PREEMPT]		// get preempt count
+	add	x23, x24, #1			// increment it
+	str	x23, [tsk, #TI_PREEMPT]
+#endif
+	irq_handler
+#ifdef CONFIG_PREEMPT
+	ldr	x0, [tsk, #TI_PREEMPT]
+	str	x24, [tsk, #TI_PREEMPT]
+	cmp	x0, x23
+	b.eq	1f
+	mov	x1, #0
+	str	x1, [x1]			// BUG
+1:
+#endif
+#ifdef CONFIG_TRACE_IRQFLAGS
+	bl	trace_hardirqs_on
+#endif
+	b	ret_to_user
+ENDPROC(el0_irq)
+
+/*
+ * This is the return code to user mode for abort handlers
+ */
+ENTRY(ret_from_exception)
+	get_thread_info tsk
+	b	ret_to_user
+ENDPROC(ret_from_exception)
+
+/*
+ * Register switch for AArch64. The callee-saved registers need to be saved
+ * and restored. On entry:
+ *   x0 = previous task_struct (must be preserved across the switch)
+ *   x1 = next task_struct
+ * Previous and next are guaranteed not to be the same.
+ *
+ */
+ENTRY(cpu_switch_to)
+	add	x8, x0, #THREAD_CPU_CONTEXT
+	mov	x9, sp
+	stp	x19, x20, [x8], #16		// store callee-saved registers
+	stp	x21, x22, [x8], #16
+	stp	x23, x24, [x8], #16
+	stp	x25, x26, [x8], #16
+	stp	x27, x28, [x8], #16
+	stp	x29, x9, [x8], #16
+	str	lr, [x8]
+	add	x8, x1, #THREAD_CPU_CONTEXT
+	ldp	x19, x20, [x8], #16		// restore callee-saved registers
+	ldp	x21, x22, [x8], #16
+	ldp	x23, x24, [x8], #16
+	ldp	x25, x26, [x8], #16
+	ldp	x27, x28, [x8], #16
+	ldp	x29, x9, [x8], #16
+	ldr	lr, [x8]
+	mov	sp, x9
+	ret
+ENDPROC(cpu_switch_to)
+
+/*
+ * This is the fast syscall return path.  We do as little as possible here,
+ * and this includes saving x0 back into the kernel stack.
+ */
+ret_fast_syscall:
+	disable_irq				// disable interrupts
+	ldr	x1, [tsk, #TI_FLAGS]
+	and	x2, x1, #_TIF_WORK_MASK
+	cbnz	x2, fast_work_pending
+	tbz	x1, #TIF_SINGLESTEP, fast_exit
+	disable_dbg
+	enable_step x2
+fast_exit:
+	kernel_exit 0, ret = 1
+
+/*
+ * Ok, we need to do extra processing, enter the slow path.
+ */
+fast_work_pending:
+	str	x0, [sp, #S_X0]			// returned x0
+work_pending:
+	tbnz	x1, #TIF_NEED_RESCHED, work_resched
+	/* TIF_SIGPENDING or TIF_NOTIFY_RESUME case */
+	ldr	x2, [sp, #S_PSTATE]
+	mov	x0, sp				// 'regs'
+	tst	x2, #PSR_MODE_MASK		// user mode regs?
+	b.ne	no_work_pending			// returning to kernel
+	bl	do_notify_resume
+	b	ret_to_user
+work_resched:
+	enable_dbg
+	bl	schedule
+
+/*
+ * "slow" syscall return path.
+ */
+ENTRY(ret_to_user)
+	disable_irq				// disable interrupts
+	ldr	x1, [tsk, #TI_FLAGS]
+	and	x2, x1, #_TIF_WORK_MASK
+	cbnz	x2, work_pending
+	tbz	x1, #TIF_SINGLESTEP, no_work_pending
+	disable_dbg
+	enable_step x2
+no_work_pending:
+	kernel_exit 0, ret = 0
+ENDPROC(ret_to_user)
+
+/*
+ * This is how we return from a fork.
+ */
+ENTRY(ret_from_fork)
+	bl	schedule_tail
+	get_thread_info tsk
+	b	ret_to_user
+ENDPROC(ret_from_fork)
+
+/*
+ * SVC handler.
+ */
+	.align	6
+ENTRY(el0_svc)
+	adrp	stbl, sys_call_table		// load syscall table pointer
+	uxtw	scno, w8			// syscall number in w8
+	mov	sc_nr, #__NR_syscalls
+el0_svc_naked:					// compat entry point
+	stp	x0, scno, [sp, #S_ORIG_X0]	// save the original x0 and syscall number
+	disable_step x16
+	isb
+	enable_dbg
+	enable_irq
+
+	get_thread_info tsk
+	ldr	x16, [tsk, #TI_FLAGS]		// check for syscall tracing
+	tbnz	x16, #TIF_SYSCALL_TRACE, __sys_trace // are we tracing syscalls?
+	adr	lr, ret_fast_syscall		// return address
+	cmp     scno, sc_nr                     // check upper syscall limit
+	b.hs	ni_sys
+	ldr	x16, [stbl, scno, lsl #3]	// address in the syscall table
+	br	x16				// call sys_* routine
+ni_sys:
+	mov	x0, sp
+	b	do_ni_syscall
+ENDPROC(el0_svc)
+
+	/*
+	 * This is the really slow path.  We're going to be doing context
+	 * switches, and waiting for our parent to respond.
+	 */
+__sys_trace:
+	mov	x1, sp
+	mov	w0, #0				// trace entry
+	bl	syscall_trace
+	adr	lr, __sys_trace_return		// return address
+	uxtw	scno, w0			// syscall number (possibly new)
+	mov	x1, sp				// pointer to regs
+	cmp	scno, sc_nr			// check upper syscall limit
+	b.hs	ni_sys
+	ldp	x0, x1, [sp]			// restore the syscall args
+	ldp	x2, x3, [sp, #S_X2]
+	ldp	x4, x5, [sp, #S_X4]
+	ldp	x6, x7, [sp, #S_X6]
+	ldr	x16, [stbl, scno, lsl #3]	// address in the syscall table
+	br	x16				// call sys_* routine
+
+__sys_trace_return:
+	str	x0, [sp]			// save returned x0
+	mov	x1, sp
+	mov	w0, #1				// trace exit
+	bl	syscall_trace
+	b	ret_to_user
+
+/*
+ * Special system call wrappers.
+ */
+ENTRY(sys_execve_wrapper)
+	mov	x3, sp
+	b	sys_execve
+ENDPROC(sys_execve_wrapper)
+
+ENTRY(sys_clone_wrapper)
+	mov	x5, sp
+	b	sys_clone
+ENDPROC(sys_clone_wrapper)
+
+ENTRY(sys_rt_sigreturn_wrapper)
+	mov	x0, sp
+	b	sys_rt_sigreturn
+ENDPROC(sys_rt_sigreturn_wrapper)
+
+ENTRY(sys_sigaltstack_wrapper)
+	ldr	x2, [sp, #S_SP]
+	b	sys_sigaltstack
+ENDPROC(sys_sigaltstack_wrapper)
+
+ENTRY(handle_arch_irq)
+	.quad	0
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
new file mode 100644
index 0000000..d25459f
--- /dev/null
+++ b/arch/arm64/kernel/stacktrace.c
@@ -0,0 +1,127 @@
+/*
+ * Stack tracing support
+ *
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
+#include <linux/kernel.h>
+#include <linux/export.h>
+#include <linux/sched.h>
+#include <linux/stacktrace.h>
+
+#include <asm/stacktrace.h>
+
+/*
+ * AArch64 PCS assigns the frame pointer to x29.
+ *
+ * A simple function prologue looks like this:
+ * 	sub	sp, sp, #0x10
+ *   	stp	x29, x30, [sp]
+ *	mov	x29, sp
+ *
+ * A simple function epilogue looks like this:
+ *	mov	sp, x29
+ *	ldp	x29, x30, [sp]
+ *	add	sp, sp, #0x10
+ */
+int unwind_frame(struct stackframe *frame)
+{
+	unsigned long high, low;
+	unsigned long fp = frame->fp;
+
+	low  = frame->sp;
+	high = ALIGN(low, THREAD_SIZE);
+
+	if (fp < low || fp > high || fp & 0xf)
+		return -EINVAL;
+
+	frame->sp = fp + 0x10;
+	frame->fp = *(unsigned long *)(fp);
+	frame->pc = *(unsigned long *)(fp + 8);
+
+	return 0;
+}
+
+void notrace walk_stackframe(struct stackframe *frame,
+		     int (*fn)(struct stackframe *, void *), void *data)
+{
+	while (1) {
+		int ret;
+
+		if (fn(frame, data))
+			break;
+		ret = unwind_frame(frame);
+		if (ret < 0)
+			break;
+	}
+}
+EXPORT_SYMBOL(walk_stackframe);
+
+#ifdef CONFIG_STACKTRACE
+struct stack_trace_data {
+	struct stack_trace *trace;
+	unsigned int no_sched_functions;
+	unsigned int skip;
+};
+
+static int save_trace(struct stackframe *frame, void *d)
+{
+	struct stack_trace_data *data = d;
+	struct stack_trace *trace = data->trace;
+	unsigned long addr = frame->pc;
+
+	if (data->no_sched_functions && in_sched_functions(addr))
+		return 0;
+	if (data->skip) {
+		data->skip--;
+		return 0;
+	}
+
+	trace->entries[trace->nr_entries++] = addr;
+
+	return trace->nr_entries >= trace->max_entries;
+}
+
+void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
+{
+	struct stack_trace_data data;
+	struct stackframe frame;
+
+	data.trace = trace;
+	data.skip = trace->skip;
+
+	if (tsk != current) {
+		data.no_sched_functions = 1;
+		frame.fp = thread_saved_fp(tsk);
+		frame.sp = thread_saved_sp(tsk);
+		frame.pc = thread_saved_pc(tsk);
+	} else {
+		register unsigned long current_sp asm("sp");
+		data.no_sched_functions = 0;
+		frame.fp = (unsigned long)__builtin_frame_address(0);
+		frame.sp = current_sp;
+		frame.pc = (unsigned long)save_stack_trace_tsk;
+	}
+
+	walk_stackframe(&frame, save_trace, &data);
+	if (trace->nr_entries < trace->max_entries)
+		trace->entries[trace->nr_entries++] = ULONG_MAX;
+}
+
+void save_stack_trace(struct stack_trace *trace)
+{
+	save_stack_trace_tsk(current, trace);
+}
+EXPORT_SYMBOL_GPL(save_stack_trace);
+#endif
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
new file mode 100644
index 0000000..3883f84
--- /dev/null
+++ b/arch/arm64/kernel/traps.c
@@ -0,0 +1,348 @@
+/*
+ * Based on arch/arm/kernel/traps.c
+ *
+ * Copyright (C) 1995-2009 Russell King
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
+#include <linux/signal.h>
+#include <linux/personality.h>
+#include <linux/kallsyms.h>
+#include <linux/spinlock.h>
+#include <linux/uaccess.h>
+#include <linux/hardirq.h>
+#include <linux/kdebug.h>
+#include <linux/module.h>
+#include <linux/kexec.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/syscalls.h>
+
+#include <asm/atomic.h>
+#include <asm/traps.h>
+#include <asm/stacktrace.h>
+#include <asm/exception.h>
+#include <asm/system_misc.h>
+
+static const char *handler[]= {
+	"Synchronous Abort",
+	"IRQ",
+	"FIQ",
+	"Error"
+};
+
+int show_unhandled_signals = 1;
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
+	printk("%s%s(0x%016lx to 0x%016lx)\n", lvl, str, bottom, top);
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
+				unsigned int val;
+				if (__get_user(val, (unsigned int *)p) == 0)
+					sprintf(str + i * 9, " %08x", val);
+				else
+					sprintf(str + i * 9, " ????????");
+			}
+		}
+		printk("%s%04lx:%s\n", lvl, first & 0xffff, str);
+	}
+
+	set_fs(fs);
+}
+
+static void dump_backtrace_entry(unsigned long where, unsigned long stack)
+{
+	print_ip_sym(where);
+	if (in_exception_text(where))
+		dump_mem("", "Exception stack", stack,
+			 stack + sizeof(struct pt_regs));
+}
+
+static void dump_instr(const char *lvl, struct pt_regs *regs)
+{
+	unsigned long addr = instruction_pointer(regs);
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
+			p += sprintf(p, i == 0 ? "(%08x) " : "%08x ", val);
+		else {
+			p += sprintf(p, "bad PC value");
+			break;
+		}
+	}
+	printk("%sCode: %s\n", lvl, str);
+
+	set_fs(fs);
+}
+
+static void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
+{
+	struct stackframe frame;
+	const register unsigned long current_sp asm ("sp");
+
+	pr_debug("%s(regs = %p tsk = %p)\n", __func__, regs, tsk);
+
+	if (!tsk)
+		tsk = current;
+
+	if (regs) {
+		frame.fp = regs->regs[29];
+		frame.sp = regs->sp;
+		frame.pc = regs->pc;
+	} else if (tsk == current) {
+		frame.fp = (unsigned long)__builtin_frame_address(0);
+		frame.sp = current_sp;
+		frame.pc = (unsigned long)dump_backtrace;
+	} else {
+		/*
+		 * task blocked in __switch_to
+		 */
+		frame.fp = thread_saved_fp(tsk);
+		frame.sp = thread_saved_sp(tsk);
+		frame.pc = thread_saved_pc(tsk);
+	}
+
+	printk("Call trace:\n");
+	while (1) {
+		unsigned long where = frame.pc;
+		int ret;
+
+		ret = unwind_frame(&frame);
+		if (ret < 0)
+			break;
+		dump_backtrace_entry(where, frame.sp);
+	}
+}
+
+void dump_stack(void)
+{
+	dump_backtrace(NULL, NULL);
+}
+
+EXPORT_SYMBOL(dump_stack);
+
+void show_stack(struct task_struct *tsk, unsigned long *sp)
+{
+	dump_backtrace(NULL, tsk);
+	barrier();
+}
+
+#ifdef CONFIG_PREEMPT
+#define S_PREEMPT " PREEMPT"
+#else
+#define S_PREEMPT ""
+#endif
+#ifdef CONFIG_SMP
+#define S_SMP " SMP"
+#else
+#define S_SMP ""
+#endif
+
+static int __die(const char *str, int err, struct thread_info *thread,
+		 struct pt_regs *regs)
+{
+	struct task_struct *tsk = thread->task;
+	static int die_counter;
+	int ret;
+
+	pr_emerg("Internal error: %s: %x [#%d]" S_PREEMPT S_SMP "\n",
+		 str, err, ++die_counter);
+
+	/* trap and error numbers are mostly meaningless on ARM */
+	ret = notify_die(DIE_OOPS, str, regs, err, 0, SIGSEGV);
+	if (ret == NOTIFY_STOP)
+		return ret;
+
+	print_modules();
+	__show_regs(regs);
+	pr_emerg("Process %.*s (pid: %d, stack limit = 0x%p)\n",
+		 TASK_COMM_LEN, tsk->comm, task_pid_nr(tsk), thread + 1);
+
+	if (!user_mode(regs) || in_interrupt()) {
+		dump_mem(KERN_EMERG, "Stack: ", regs->sp,
+			 THREAD_SIZE + (unsigned long)task_stack_page(tsk));
+		dump_backtrace(regs, tsk);
+		dump_instr(KERN_EMERG, regs);
+	}
+
+	return ret;
+}
+
+static DEFINE_RAW_SPINLOCK(die_lock);
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
+	raw_spin_lock_irq(&die_lock);
+	console_verbose();
+	bust_spinlocks(1);
+	ret = __die(str, err, thread, regs);
+
+	if (regs && kexec_should_crash(thread->task))
+		crash_kexec(regs);
+
+	bust_spinlocks(0);
+	add_taint(TAINT_DIE);
+	raw_spin_unlock_irq(&die_lock);
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
+void arm64_notify_die(const char *str, struct pt_regs *regs,
+		      struct siginfo *info, int err)
+{
+	if (user_mode(regs))
+		force_sig_info(info->si_signo, info, current);
+	else
+		die(str, regs, err);
+}
+
+asmlinkage void __exception do_undefinstr(struct pt_regs *regs)
+{
+	siginfo_t info;
+	void __user *pc = (void __user *)instruction_pointer(regs);
+
+#ifdef CONFIG_COMPAT
+	/* check for AArch32 breakpoint instructions */
+	if (compat_user_mode(regs) && aarch32_break_trap(regs) == 0)
+		return;
+#endif
+
+	if (show_unhandled_signals) {
+		pr_info("%s[%d]: undefined instruction: pc=%p\n",
+			current->comm, task_pid_nr(current), pc);
+		dump_instr(KERN_INFO, regs);
+	}
+
+	info.si_signo = SIGILL;
+	info.si_errno = 0;
+	info.si_code  = ILL_ILLOPC;
+	info.si_addr  = pc;
+
+	arm64_notify_die("Oops - undefined instruction", regs, &info, 0);
+}
+
+long compat_arm_syscall(struct pt_regs *regs);
+
+asmlinkage long do_ni_syscall(struct pt_regs *regs)
+{
+#ifdef CONFIG_COMPAT
+	long ret;
+	if (is_compat_task()) {
+		ret = compat_arm_syscall(regs);
+		if (ret != -ENOSYS)
+			return ret;
+	}
+#endif
+
+	if (show_unhandled_signals) {
+		pr_info("%s[%d]: syscall %d\n", current->comm,
+			task_pid_nr(current), (int)regs->syscallno);
+		dump_instr("", regs);
+		if (user_mode(regs))
+			__show_regs(regs);
+	}
+
+	return sys_ni_syscall();
+}
+
+/*
+ * bad_mode handles the impossible case in the exception vector.
+ */
+asmlinkage void bad_mode(struct pt_regs *regs, int reason, unsigned int esr)
+{
+	console_verbose();
+
+	pr_crit("Bad mode in %s handler detected, code 0x%08x\n",
+		handler[reason], esr);
+
+	die("Oops - bad mode", regs, 0);
+	local_irq_disable();
+	panic("bad mode");
+}
+
+void __pte_error(const char *file, int line, unsigned long val)
+{
+	printk("%s:%d: bad pte %016lx.\n", file, line, val);
+}
+
+void __pmd_error(const char *file, int line, unsigned long val)
+{
+	printk("%s:%d: bad pmd %016lx.\n", file, line, val);
+}
+
+void __pgd_error(const char *file, int line, unsigned long val)
+{
+	printk("%s:%d: bad pgd %016lx.\n", file, line, val);
+}
+
+void __init trap_init(void)
+{
+	return;
+}

