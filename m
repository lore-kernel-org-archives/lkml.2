Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab2KGJwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:52:35 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:58047 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab2KGJsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:48:30 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, arnd@arndb.de,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC PATCH v1 11/31] ARC: Low level IRQ/Trap/Exception(non-MMU) Handling
Date: Wed,  7 Nov 2012 10:47:34 +0100
Message-Id: <1352281674-2186-12-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/entry.h |  495 ++++++++++++++++++++++++++++++++++++
 arch/arc/kernel/entry.S      |  577 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 1072 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/include/asm/entry.h
 create mode 100644 arch/arc/kernel/entry.S

diff --git a/arch/arc/include/asm/entry.h b/arch/arc/include/asm/entry.h
new file mode 100644
index 0000000..3e0a9f4
--- /dev/null
+++ b/arch/arc/include/asm/entry.h
@@ -0,0 +1,495 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Vineetg: Aug 28th 2008: Bug #94984
+ *  -Zero Overhead Loop Context shd be cleared when entering IRQ/EXcp/Trap
+ *   Normally CPU does this automatically, however when doing FAKE rtie,
+ *   we also need to explicitly do this. The problem in macros
+ *   FAKE_RET_FROM_EXCPN and FAKE_RET_FROM_EXCPN_LOCK_IRQ was that this bit
+ *   was being "CLEARED" rather then "SET". Actually "SET" clears ZOL context
+ *
+ * Vineetg: May 5th 2008
+ *  - Defined Stack Switching Macro to be reused in all intr/excp hdlrs
+ *  - Shaved off 11 instructions from RESTORE_ALL_INT1 by using the
+ *      address Write back load ld.ab instead of seperate ld/add instn
+ *
+ * Amit Bhor, Sameer Dhavale: Codito Technologies 2004
+ */
+
+#ifndef __ASM_ARC_ENTRY_H
+#define __ASM_ARC_ENTRY_H
+
+#ifdef __ASSEMBLY__
+#include <asm/unistd.h>		/* For NR_syscalls defination */
+#include <asm/asm-offsets.h>
+#include <asm/arcregs.h>
+#include <asm/ptrace.h>
+#include <asm/thread_info.h>	/* For THREAD_SIZE */
+
+/* Note on the LD/ST addr modes with addr reg wback
+ *
+ * LD.a same as LD.aw
+ *
+ * LD.a    reg1, [reg2, x]  => Pre Incr
+ *      Eff Addr for load = [reg2 + x]
+ *
+ * LD.ab   reg1, [reg2, x]  => Post Incr
+ *      Eff Addr for load = [reg2]
+ */
+
+/*--------------------------------------------------------------
+ * Save caller saved registers (scratch registers) ( r0 - r12 )
+ * Registers are pushed / popped in the order defined in struct ptregs
+ * in asm/ptrace.h
+ *-------------------------------------------------------------*/
+.macro  SAVE_CALLER_SAVED
+	st.a    r0, [sp, -4]
+	st.a    r1, [sp, -4]
+	st.a    r2, [sp, -4]
+	st.a    r3, [sp, -4]
+	st.a    r4, [sp, -4]
+	st.a    r5, [sp, -4]
+	st.a    r6, [sp, -4]
+	st.a    r7, [sp, -4]
+	st.a    r8, [sp, -4]
+	st.a    r9, [sp, -4]
+	st.a    r10, [sp, -4]
+	st.a    r11, [sp, -4]
+	st.a    r12, [sp, -4]
+.endm
+
+/*--------------------------------------------------------------
+ * Restore caller saved registers (scratch registers)
+ *-------------------------------------------------------------*/
+.macro RESTORE_CALLER_SAVED
+	ld.ab   r12, [sp, 4]
+	ld.ab   r11, [sp, 4]
+	ld.ab   r10, [sp, 4]
+	ld.ab   r9, [sp, 4]
+	ld.ab   r8, [sp, 4]
+	ld.ab   r7, [sp, 4]
+	ld.ab   r6, [sp, 4]
+	ld.ab   r5, [sp, 4]
+	ld.ab   r4, [sp, 4]
+	ld.ab   r3, [sp, 4]
+	ld.ab   r2, [sp, 4]
+	ld.ab   r1, [sp, 4]
+	ld.ab   r0, [sp, 4]
+.endm
+
+
+/*--------------------------------------------------------------
+ * Save callee saved registers (non scratch registers) ( r13 - r25 )
+ *  on kernel stack.
+ * User mode callee regs need to be saved in case of
+ *    -fork and friends for replicating from parent to child
+ *    -before going into do_signal( ) for ptrace/core-dump
+ * Special case handling is required for r25 in case it is used by kernel
+ *  for caching task ptr. Low level exception/ISR save user mode r25
+ *  into task->thread.user_r25. So it needs to be retrieved from there and
+ *  saved into kernel stack wit rest of callee reg-file
+ *-------------------------------------------------------------*/
+.macro SAVE_CALLEE_SAVED_USER
+	st.a    r13, [sp, -4]
+	st.a    r14, [sp, -4]
+	st.a    r15, [sp, -4]
+	st.a    r16, [sp, -4]
+	st.a    r17, [sp, -4]
+	st.a    r18, [sp, -4]
+	st.a    r19, [sp, -4]
+	st.a    r20, [sp, -4]
+	st.a    r21, [sp, -4]
+	st.a    r22, [sp, -4]
+	st.a    r23, [sp, -4]
+	st.a    r24, [sp, -4]
+	st.a    r25, [sp, -4]
+
+	/* move up by 1 word to "create" callee_regs->"stack_place_holder" */
+	sub sp, sp, 4
+.endm
+
+/*--------------------------------------------------------------
+ * Save callee saved registers (non scratch registers) ( r13 - r25 )
+ * kernel mode callee regs needed to be saved in case of context switch
+ * If r25 is used for caching task pointer then that need not be saved
+ * as it can be re-created from current task global
+ *-------------------------------------------------------------*/
+.macro SAVE_CALLEE_SAVED_KERNEL
+	st.a    r13, [sp, -4]
+	st.a    r14, [sp, -4]
+	st.a    r15, [sp, -4]
+	st.a    r16, [sp, -4]
+	st.a    r17, [sp, -4]
+	st.a    r18, [sp, -4]
+	st.a    r19, [sp, -4]
+	st.a    r20, [sp, -4]
+	st.a    r21, [sp, -4]
+	st.a    r22, [sp, -4]
+	st.a    r23, [sp, -4]
+	st.a    r24, [sp, -4]
+	st.a    r25, [sp, -4]
+	sub     sp, sp, 4
+.endm
+
+/*--------------------------------------------------------------
+ * RESTORE_CALLEE_SAVED:
+ * Loads callee (non scratch) Reg File by popping from Kernel mode stack.
+ *  This is reverse of SAVE_CALLEE_SAVED,
+ *
+ * NOTE:
+ * Ideally this shd only be called in switch_to for loading
+ *  switched-IN task's CALLEE Reg File.
+ *  For all other cases RESTORE_CALLEE_SAVED_FAST must be used
+ *  which simply pops the stack w/o touching regs.
+ *-------------------------------------------------------------*/
+.macro RESTORE_CALLEE_SAVED_KERNEL
+
+	add     sp, sp, 4   /* skip "callee_regs->stack_place_holder" */
+	ld.ab   r25, [sp, 4]
+	ld.ab   r24, [sp, 4]
+	ld.ab   r23, [sp, 4]
+	ld.ab   r22, [sp, 4]
+	ld.ab   r21, [sp, 4]
+	ld.ab   r20, [sp, 4]
+	ld.ab   r19, [sp, 4]
+	ld.ab   r18, [sp, 4]
+	ld.ab   r17, [sp, 4]
+	ld.ab   r16, [sp, 4]
+	ld.ab   r15, [sp, 4]
+	ld.ab   r14, [sp, 4]
+	ld.ab   r13, [sp, 4]
+
+.endm
+
+/*--------------------------------------------------------------
+ * Super FAST Restore callee saved regs by simply re-adjusting SP
+ *-------------------------------------------------------------*/
+.macro DISCARD_CALLEE_SAVED_USER
+	add     sp, sp, 14 * 4
+.endm
+
+/*--------------------------------------------------------------
+ * Restore User mode r25 saved in task_struct->thread.user_r25
+ *-------------------------------------------------------------*/
+.macro RESTORE_USER_R25
+	ld  r25, [r25, TASK_THREAD + THREAD_USER_R25]
+.endm
+
+/*-------------------------------------------------------------
+ * given a tsk struct, get to the base of it's kernel mode stack
+ * tsk->thread_info is really a PAGE, whose bottom hoists stack
+ * which grows upwards towards thread_info
+ *------------------------------------------------------------*/
+
+.macro GET_TSK_STACK_BASE tsk, out
+
+	/* Get task->thread_info (this is essentially start of a PAGE) */
+	ld  \out, [\tsk, TASK_THREAD_INFO]
+
+	/* Go to end of page where stack begins (grows upwards) */
+	add2 \out, \out, (THREAD_SIZE - 4)/4   /* one word GUTTER */
+
+.endm
+
+/*--------------------------------------------------------------
+ * Switch to Kernel Mode stack if SP points to User Mode stack
+ *
+ * Entry   : r9 contains pre-IRQ/exception/trap status32
+ * Exit    : SP is set to kernel mode stack pointer
+ * Clobbers: r9
+ *-------------------------------------------------------------*/
+
+.macro SWITCH_TO_KERNEL_STK
+
+	/* User Mode when this happened ? Yes: Proceed to switch stack */
+	bbit1   r9, STATUS_U_BIT, 88f
+
+	/* OK we were already in kernel mode when this event happened, thus can
+	 * assume SP is kernel mode SP. _NO_ need to do any stack switching
+	 */
+
+	/* Save Pre Intr/Exception KERNEL MODE SP on kernel stack
+	 * safe-keeping not really needed, but it keeps the epilogue code
+	 * (SP restore) simpler/uniform.
+	 */
+	b.d	77f
+
+	st.a	sp, [sp, -12]	; Make room for orig_r0 and orig_r8
+
+88: /*------Intr/Ecxp happened in user mode, "switch" stack ------ */
+
+	GET_CURR_TASK_ON_CPU   r9
+
+	/* With current tsk in r9, get it's kernel mode stack base */
+	GET_TSK_STACK_BASE  r9, r9
+
+#ifdef PT_REGS_CANARY
+	st	0xabcdabcd, [r9, 0]
+#endif
+
+	/* Save Pre Intr/Exception User SP on kernel stack */
+	st.a    sp, [r9, -12]	; Make room for orig_r0 and orig_r8
+
+	/* CAUTION:
+	 * SP should be set at the very end when we are done with everything
+	 * In case of 2 levels of interrupt we depend on value of SP to assume
+	 * that everything else is done (loading r25 etc)
+	 */
+
+	/* set SP to point to kernel mode stack */
+	mov sp, r9
+
+77: /* ----- Stack Switched to kernel Mode, Now save REG FILE ----- */
+
+.endm
+
+/*------------------------------------------------------------
+ * "FAKE" a rtie to return from CPU Exception context
+ * This is to re-enable Exceptions within exception
+ * Look at EV_ProtV to see how this is actually used
+ *-------------------------------------------------------------*/
+
+.macro FAKE_RET_FROM_EXCPN  reg
+
+	ld  \reg, [sp, PT_status32]
+	bic  \reg, \reg, (STATUS_U_MASK|STATUS_DE_MASK)
+	bset \reg, \reg, STATUS_L_BIT
+	sr  \reg, [erstatus]
+	mov \reg, 55f
+	sr  \reg, [eret]
+
+	rtie
+55:
+.endm
+
+/*
+ * @reg [OUT] &thread_info of "current"
+ */
+.macro GET_CURR_THR_INFO_FROM_SP  reg
+	and \reg, sp, ~(THREAD_SIZE - 1)
+.endm
+
+/*
+ * @reg [OUT] thread_info->flags of "current"
+ */
+.macro GET_CURR_THR_INFO_FLAGS  reg
+	GET_CURR_THR_INFO_FROM_SP  \reg
+	ld  \reg, [\reg, THREAD_INFO_FLAGS]
+.endm
+
+/*--------------------------------------------------------------
+ * For early Exception Prologue, a core reg is temporarily needed to
+ * code the rest of prolog (stack switching). This is done by stashing
+ * it to memory (non-SMP case) or SCRATCH0 Aux Reg (SMP).
+ *
+ * Before saving the full regfile - this reg is restored back, only
+ * to be saved again on kernel mode stack, as part of ptregs.
+ *-------------------------------------------------------------*/
+.macro EXCPN_PROLOG_FREEUP_REG	reg
+	st  \reg, [@ex_saved_reg1]
+.endm
+
+.macro EXCPN_PROLOG_RESTORE_REG	reg
+	ld  \reg, [@ex_saved_reg1]
+.endm
+
+/*--------------------------------------------------------------
+ * Save all registers used by Exceptions (TLB Miss, Prot-V, Mem err etc)
+ * Requires SP to be already switched to kernel mode Stack
+ * sp points to the next free element on the stack at exit of this macro.
+ * Registers are pushed / popped in the order defined in struct ptregs
+ * in asm/ptrace.h
+ * Note that syscalls are implemented via TRAP which is also a exception
+ * from CPU's point of view
+ *-------------------------------------------------------------*/
+.macro SAVE_ALL_EXCEPTION   marker
+
+	/* Restore r9 used to code the early prologue */
+	EXCPN_PROLOG_RESTORE_REG  r9
+
+	/* Save the complete regfile now */
+
+	/* orig_r8 marker:
+	 * syscalls   -> 1 to NR_SYSCALLS
+	 * Exceptions -> NR_SYSCALLS + 1
+	 * Break-point-> NR_SYSCALLS + 2
+	 */
+	st      \marker, [sp, 8]
+	st      r0, [sp, 4]    /* orig_r0, needed only for sys calls */
+	SAVE_CALLER_SAVED
+	st.a    r26, [sp, -4]   /* gp */
+	st.a    fp, [sp, -4]
+	st.a    blink, [sp, -4]
+	lr	r9, [eret]
+	st.a    r9, [sp, -4]
+	lr	r9, [erstatus]
+	st.a    r9, [sp, -4]
+	st.a    lp_count, [sp, -4]
+	lr	r9, [lp_end]
+	st.a    r9, [sp, -4]
+	lr	r9, [lp_start]
+	st.a    r9, [sp, -4]
+	lr	r9, [erbta]
+	st.a    r9, [sp, -4]
+
+#ifdef PT_REGS_CANARY
+	mov   r9, 0xdeadbeef
+	st    r9, [sp, -4]
+#endif
+
+	/* move up by 1 word to "create" pt_regs->"stack_place_holder" */
+	sub sp, sp, 4
+.endm
+
+/*--------------------------------------------------------------
+ * Save scratch regs for exceptions
+ *-------------------------------------------------------------*/
+.macro SAVE_ALL_SYS
+	SAVE_ALL_EXCEPTION  (NR_syscalls + 1)
+.endm
+
+/*--------------------------------------------------------------
+ * Save scratch regs for sys calls
+ *-------------------------------------------------------------*/
+.macro SAVE_ALL_TRAP
+	SAVE_ALL_EXCEPTION  r8
+.endm
+
+/*--------------------------------------------------------------
+ * Restore all registers used by system call or Exceptions
+ * SP should always be pointing to the next free stack element
+ * when entering this macro.
+ *
+ * NOTE:
+ *
+ * It is recommended that lp_count/ilink1/ilink2 not be used as a dest reg
+ * for memory load operations. If used in that way interrupts are deffered
+ * by hardware and that is not good.
+ *-------------------------------------------------------------*/
+.macro RESTORE_ALL_SYS
+
+	add sp, sp, 4       /* hop over unused "pt_regs->stack_place_holder" */
+
+	ld.ab   r9, [sp, 4]
+	sr	r9, [erbta]
+	ld.ab   r9, [sp, 4]
+	sr	r9, [lp_start]
+	ld.ab   r9, [sp, 4]
+	sr	r9, [lp_end]
+	ld.ab   r9, [sp, 4]
+	mov	lp_count, r9
+	ld.ab   r9, [sp, 4]
+	sr	r9, [erstatus]
+	ld.ab   r9, [sp, 4]
+	sr	r9, [eret]
+	ld.ab   blink, [sp, 4]
+	ld.ab   fp, [sp, 4]
+	ld.ab   r26, [sp, 4]    /* gp */
+	RESTORE_CALLER_SAVED
+
+	ld  sp, [sp] /* restore original sp */
+	/* orig_r0 and orig_r8 skipped automatically */
+.endm
+
+
+/*--------------------------------------------------------------
+ * Save all registers used by interrupt handlers.
+ *-------------------------------------------------------------*/
+.macro SAVE_ALL_INT1
+
+	/* restore original r9 , saved in int1_saved_reg
+	* It will be saved on stack in macro: SAVE_CALLER_SAVED
+	*/
+	ld  r9, [@int1_saved_reg]
+
+	/* now we are ready to save the remaining context :) */
+	st     -1, [sp, 8]    /* orig_r8, -1 for interuppt level one */
+	st      0, [sp, 4]    /* orig_r0 , N/A for IRQ */
+	SAVE_CALLER_SAVED
+	st.a    r26, [sp, -4]   /* gp */
+	st.a    fp, [sp, -4]
+	st.a    blink, [sp, -4]
+	st.a    ilink1, [sp, -4]
+	lr	r9, [status32_l1]
+	st.a    r9, [sp, -4]
+	st.a    lp_count, [sp, -4]
+	lr	r9, [lp_end]
+	st.a    r9, [sp, -4]
+	lr	r9, [lp_start]
+	st.a    r9, [sp, -4]
+	lr	r9, [bta_l1]
+	st.a    r9, [sp, -4]
+
+#ifdef PT_REGS_CANARY
+	mov   r9, 0xdeadbee1
+	st    r9, [sp, -4]
+#endif
+	/* move up by 1 word to "create" pt_regs->"stack_place_holder" */
+	sub sp, sp, 4
+.endm
+
+/*--------------------------------------------------------------
+ * Restore all registers used by interrupt handlers.
+ *
+ * NOTE:
+ *
+ * It is recommended that lp_count/ilink1/ilink2 not be used as a dest reg
+ * for memory load operations. If used in that way interrupts are deffered
+ * by hardware and that is not good.
+ *-------------------------------------------------------------*/
+
+.macro RESTORE_ALL_INT1
+	add sp, sp, 4       /* hop over unused "pt_regs->stack_place_holder" */
+
+	ld.ab   r9, [sp, 4] /* Actual reg file */
+	sr	r9, [bta_l1]
+	ld.ab   r9, [sp, 4]
+	sr	r9, [lp_start]
+	ld.ab   r9, [sp, 4]
+	sr	r9, [lp_end]
+	ld.ab   r9, [sp, 4]
+	mov	lp_count, r9
+	ld.ab   r9, [sp, 4]
+	sr	r9, [status32_l1]
+	ld.ab   r9, [sp, 4]
+	mov	ilink1, r9
+	ld.ab   blink, [sp, 4]
+	ld.ab   fp, [sp, 4]
+	ld.ab   r26, [sp, 4]    /* gp */
+	RESTORE_CALLER_SAVED
+
+	ld  sp, [sp] /* restore original sp */
+	/* orig_r0 and orig_r8 skipped automatically */
+.endm
+
+/* Get CPU-ID of this core */
+.macro  GET_CPU_ID  reg
+	lr  \reg, [identity]
+	lsr \reg, \reg, 8
+	bmsk \reg, \reg, 7
+.endm
+
+.macro  GET_CURR_TASK_ON_CPU    reg
+	ld  \reg, [@_current_task]
+.endm
+
+.macro  SET_CURR_TASK_ON_CPU    tsk, tmp
+	st  \tsk, [@_current_task]
+.endm
+
+/* ------------------------------------------------------------------
+ * Get the ptr to some field of Current Task at @off in task struct
+ */
+
+.macro GET_CURR_TASK_FIELD_PTR  off,  reg
+	GET_CURR_TASK_ON_CPU  \reg
+	add \reg, \reg, \off
+.endm
+
+#endif  /* __ASSEMBLY__ */
+
+#endif  /* __ASM_ARC_ENTRY_H */
diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
new file mode 100644
index 0000000..b829052
--- /dev/null
+++ b/arch/arc/kernel/entry.S
@@ -0,0 +1,577 @@
+/*
+ * Low Level Interrupts/Traps/Exceptions(non-TLB) Handling for ARC
+ *
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * vineetg: Nov 2010:
+ *  -Vector table jumps (@8 bytes) converted into branches (@4 bytes)
+ *  -To maintain the slot size of 8 bytes/vector, added nop, which is
+ *   not executed at runtime.
+ *
+ * vineetg: Nov 2009 (Everything needed for TIF_RESTORE_SIGMASK)
+ *  -do_signal()invoked upon TIF_RESTORE_SIGMASK as well
+ *  -Wrappers for sys_{,rt_}sigsuspend() nolonger needed as they don't
+ *   need ptregs anymore
+ *
+ * Vineetg: Oct 2009
+ *  -In a rare scenario, Process gets a Priv-V exception and gets scheduled
+ *   out. Since we don't do FAKE RTIE for Priv-V, CPU excpetion state remains
+ *   active (AE bit enabled).  This causes a double fault for a subseq valid
+ *   exception. Thus FAKE RTIE needed in low level Priv-Violation handler.
+ *   Instr Error could also cause similar scenario, so same there as well.
+ *
+ * Vineetg: Aug 28th 2008: Bug #94984
+ *  -Zero Overhead Loop Context shd be cleared when entering IRQ/EXcp/Trap
+ *   Normally CPU does this automatically, however when doing FAKE rtie,
+ *   we need to explicitly do this. The problem in macros
+ *   FAKE_RET_FROM_EXCPN and FAKE_RET_FROM_EXCPN_LOCK_IRQ was that this bit
+ *   was being "CLEARED" rather then "SET". Since it is Loop INHIBIT Bit,
+ *   setting it and not clearing it clears ZOL context
+ *
+ * Vineetg: Dec 22, 2007
+ *    Minor Surgery of Low Level ISR to make it SMP safe
+ *    - MMU_SCRATCH0 Reg used for freeing up r9 in Level 1 ISR
+ *    - _current_task is made an array of NR_CPUS
+ *    - Access of _current_task wrapped inside a macro so that if hardware
+ *       team agrees for a dedicated reg, no other code is touched
+ *
+ * Amit Bhor, Rahul Trivedi, Kanika Nema, Sameer Dhavale : Codito Tech 2004
+ */
+
+/*------------------------------------------------------------------
+ *    Function                            ABI
+ *------------------------------------------------------------------
+ *
+ *  Arguments                           r0 - r7
+ *  Caller Saved Registers              r0 - r12
+ *  Callee Saved Registers              r13- r25
+ *  Global Pointer (gp)                 r26
+ *  Frame Pointer (fp)                  r27
+ *  Stack Pointer (sp)                  r28
+ *  Interrupt link register (ilink1)    r29
+ *  Interrupt link register (ilink2)    r30
+ *  Branch link register (blink)        r31
+ *------------------------------------------------------------------
+ */
+
+	.cpu A7
+
+;############################ Vector Table #################################
+
+.macro VECTOR  lbl
+#if 1   /* Just in case, build breaks */
+	j   \lbl
+#else
+	b   \lbl
+	nop
+#endif
+.endm
+
+	.section .vector, "ax",@progbits
+	.align 4
+
+/* Each entry in the vector table must occupy 2 words. Since it is a jump
+ * across sections (.vector to .text) we are gauranteed that 'j somewhere'
+ * will use the 'j limm' form of the intrsuction as long as somewhere is in
+ * a section other than .vector.
+ */
+
+; ********* Critical System Events **********************
+VECTOR   res_service             ; 0x0, Restart Vector  (0x0)
+VECTOR   mem_service             ; 0x8, Mem exception   (0x1)
+VECTOR   instr_service           ; 0x10, Instrn Error   (0x2)
+
+; ******************** Device ISRs **********************
+VECTOR   handle_interrupt_level1
+
+VECTOR   handle_interrupt_level1
+
+VECTOR   handle_interrupt_level1
+
+VECTOR   handle_interrupt_level1
+
+.rept   25
+VECTOR   handle_interrupt_level1 ; Other devices
+.endr
+
+/* FOR ARC600: timer = 0x3, uart = 0x8, emac = 0x10 */
+
+; ******************** Exceptions **********************
+VECTOR   EV_MachineCheck         ; 0x100, Fatal Machine check   (0x20)
+VECTOR   EV_TLBMissI             ; 0x108, Intruction TLB miss   (0x21)
+VECTOR   EV_TLBMissD             ; 0x110, Data TLB miss         (0x22)
+VECTOR   EV_TLBProtV             ; 0x118, Protection Violation  (0x23)
+				 ;         or Misaligned Access
+VECTOR   EV_PrivilegeV           ; 0x120, Privilege Violation   (0x24)
+VECTOR   EV_Trap                 ; 0x128, Trap exception        (0x25)
+VECTOR   EV_Extension            ; 0x130, Extn Intruction Excp  (0x26)
+
+.rept   24
+VECTOR   reserved                ; Reserved Exceptions
+.endr
+
+#include <linux/linkage.h>   /* ARC_{EXTRY,EXIT} */
+#include <asm/entry.h>       /* SAVE_ALL_{INT1,INT2,TRAP...} */
+#include <asm/errno.h>
+#include <asm/arcregs.h>
+#include <asm/irqflags.h>
+
+;##################### Scratch Mem for IRQ stack switching #############
+
+	.section .data		; NOT .global
+	.align 32
+	.type   int1_saved_reg, @object
+	.size   int1_saved_reg, 4
+int1_saved_reg:
+	.zero 4
+
+; ---------------------------------------------
+	.section .text, "ax",@progbits
+
+res_service:		; processor restart
+	flag    0x1     ; not implemented
+	nop
+	nop
+
+reserved:		; processor restart
+	rtie            ; jump to processor initializations
+
+;##################### Interrupt Handling ##############################
+
+; ---------------------------------------------
+;  Level 1 ISR
+; ---------------------------------------------
+ARC_ENTRY handle_interrupt_level1
+
+	/* free up r9 as scratchpad */
+	st   r9, [@int1_saved_reg]
+
+	;Which mode (user/kernel) was the system in when intr occured
+	lr  r9, [status32_l1]
+
+	SWITCH_TO_KERNEL_STK
+	SAVE_ALL_INT1
+
+	lr  r0, [icause1]
+	and r0, r0, 0x1f
+
+	bl.d  @arch_do_IRQ
+	mov r1, sp
+
+	mov r8,0x1
+	sr r8, [AUX_IRQ_LV12]       ; clear bit in Sticky Status Reg
+
+	b   ret_from_exception
+ARC_EXIT handle_interrupt_level1
+
+;################### Non TLB Exception Handling #############################
+
+; ---------------------------------------------
+; Instruction Error Exception Handler
+; ---------------------------------------------
+
+ARC_ENTRY instr_service
+
+	EXCPN_PROLOG_FREEUP_REG r9
+
+	lr  r9, [erstatus]
+
+	SWITCH_TO_KERNEL_STK
+	SAVE_ALL_SYS
+
+	lr  r0, [ecr]
+	lr  r1, [efa]
+
+	mov r2, sp
+
+	FAKE_RET_FROM_EXCPN r9
+
+	bl  do_insterror_or_kprobe
+	b   ret_from_exception
+ARC_EXIT instr_service
+
+; ---------------------------------------------
+; Memory Error Exception Handler
+; ---------------------------------------------
+
+ARC_ENTRY mem_service
+
+	EXCPN_PROLOG_FREEUP_REG r9
+
+	lr  r9, [erstatus]
+
+	SWITCH_TO_KERNEL_STK
+	SAVE_ALL_SYS
+
+	lr  r0, [ecr]
+	lr  r1, [efa]
+	mov r2, sp
+	bl  do_memory_error
+	b   ret_from_exception
+ARC_EXIT mem_service
+
+; ---------------------------------------------
+; Machine Check Exception Handler
+; ---------------------------------------------
+
+ARC_ENTRY EV_MachineCheck
+
+	EXCPN_PROLOG_FREEUP_REG r9
+	lr  r9, [erstatus]
+
+	SWITCH_TO_KERNEL_STK
+	SAVE_ALL_SYS
+
+	lr  r0, [ecr]
+	lr  r1, [efa]
+	mov r2, sp
+
+	brne    r0, 0x200100, 1f
+	bl      do_tlb_overlap_fault
+	b       ret_from_exception
+
+1:
+	; DEAD END: can't do much, display Regs and HALT
+	SAVE_CALLEE_SAVED_USER
+
+	GET_CURR_TASK_FIELD_PTR   TASK_THREAD, r10
+	st  sp, [r10, THREAD_CALLEE_REG]
+
+	j  do_machine_check_fault
+
+ARC_EXIT EV_MachineCheck
+
+; ---------------------------------------------
+; Protection Violation Exception Handler
+; ---------------------------------------------
+
+ARC_ENTRY EV_TLBProtV
+
+	EXCPN_PROLOG_FREEUP_REG r9
+
+	;Which mode (user/kernel) was the system in when Exception occured
+	lr  r9, [erstatus]
+
+	SWITCH_TO_KERNEL_STK
+	SAVE_ALL_SYS
+
+	;---------(3) Save some more regs-----------------
+	;  vineetg: Mar 6th: Random Seg Fault issue #1
+	;  ecr and efa were not saved in case an Intr sneaks in
+	;  after fake rtie
+	;
+	lr  r3, [ecr]
+	lr  r4, [efa]
+
+	; --------(4) Return from CPU Exception Mode ---------
+	;  Fake a rtie, but rtie to next label
+	;  That way, subsequently, do_page_fault ( ) executes in pure kernel
+	;  mode with further Exceptions enabled
+
+	FAKE_RET_FROM_EXCPN r9
+
+	;------ (5) Type of Protection Violation? ----------
+	;
+	; ProtV Hardware Exception is triggered for Access Faults of 2 types
+	;   -Access Violaton (WRITE to READ ONLY Page) - for linux COW
+	;   -Unaligned Access (READ/WRITE on odd boundary)
+	;
+	cmp r3, 0x230400    ; Misaligned data access ?
+	beq 4f
+
+	;========= (6a) Access Violation Processing ========
+	cmp r3, 0x230100
+	mov r1, 0x0              ; if LD exception ? write = 0
+	mov.ne r1, 0x1           ; else write = 1
+
+	mov r2, r4              ; faulting address
+	mov r0, sp              ; pt_regs
+	bl  do_page_fault
+	b   ret_from_exception
+
+	;========== (6b) Non aligned access ============
+4:
+	mov r0, r3              ; cause code
+	mov r1, r4              ; faulting address
+	mov r2, sp              ; pt_regs
+
+	bl  do_misaligned_access
+	b   ret_from_exception
+
+ARC_EXIT EV_TLBProtV
+
+; ---------------------------------------------
+; Privilege Violation Exception Handler
+; ---------------------------------------------
+ARC_ENTRY EV_PrivilegeV
+
+	EXCPN_PROLOG_FREEUP_REG r9
+
+	lr  r9, [erstatus]
+
+	SWITCH_TO_KERNEL_STK
+	SAVE_ALL_SYS
+
+	lr  r0, [ecr]
+	lr  r1, [efa]
+	mov r2, sp
+
+	FAKE_RET_FROM_EXCPN r9
+
+	bl  do_privilege_fault
+	b   ret_from_exception
+ARC_EXIT EV_PrivilegeV
+
+; ---------------------------------------------
+; Extension Instruction Exception Handler
+; ---------------------------------------------
+ARC_ENTRY EV_Extension
+
+	EXCPN_PROLOG_FREEUP_REG r9
+	lr  r9, [erstatus]
+
+	SWITCH_TO_KERNEL_STK
+	SAVE_ALL_SYS
+
+	lr  r0, [ecr]
+	lr  r1, [efa]
+	mov r2, sp
+	bl  do_extension_fault
+	b   ret_from_exception
+ARC_EXIT EV_Extension
+
+;################### Break Point TRAP ##########################
+
+	; ======= (5b) Trap is due to Break-Point =========
+
+trap_with_param:
+
+	;make sure orig_r8 is a positive value
+	st  NR_syscalls + 2, [sp, PT_orig_r8]
+
+	mov r0, r12
+	lr  r1, [efa]
+	mov r2, sp
+
+	; Now that we have read EFA, its safe to do "fake" rtie
+	;   and get out of CPU exception mode
+	FAKE_RET_FROM_EXCPN r11
+
+	; Save callee regs in case gdb wants to have a look
+	; SP will grow up by size of CALLEE Reg-File
+	; NOTE: clobbers r12
+	SAVE_CALLEE_SAVED_USER
+
+	; save location of saved Callee Regs @ thread_struct->pc
+	GET_CURR_TASK_FIELD_PTR   TASK_THREAD, r10
+	st  sp, [r10, THREAD_CALLEE_REG]
+
+	; Call the trap handler
+	bl  do_non_swi_trap
+
+	; unwind stack to discard Callee saved Regs
+	DISCARD_CALLEE_SAVED_USER
+
+	b   ret_from_exception
+
+;##################### Trap Handling ##############################
+;
+; EV_Trap caused by TRAP_S and TRAP0 instructions.
+;------------------------------------------------------------------
+;   (1) System Calls
+;       :parameters in r0-r7.
+;       :r8 has the system call number
+;   (2) Break Points
+;------------------------------------------------------------------
+
+ARC_ENTRY EV_Trap
+
+	; Need at least 1 reg to code the early exception prolog
+	EXCPN_PROLOG_FREEUP_REG r9
+
+	;Which mode (user/kernel) was the system in when intr occured
+	lr  r9, [erstatus]
+
+	SWITCH_TO_KERNEL_STK
+	SAVE_ALL_TRAP
+
+	;------- (4) What caused the Trap --------------
+	lr     r12, [ecr]
+	and.f  0, r12, ECR_PARAM_MASK
+	bnz    trap_with_param
+
+	; ======= (5a) Trap is due to System Call ========
+
+	; Before doing anything, return from CPU Exception Mode
+	FAKE_RET_FROM_EXCPN r11
+
+	;============ This is normal System Call case ==========
+	; Sys-call num shd not exceed the total system calls avail
+	cmp     r8,  NR_syscalls
+	mov.hi  r0, -ENOSYS
+	bhi     ret_from_system_call
+
+	; Offset into the syscall_table and call handler
+	ld.as   r9,[sys_call_table, r8]
+	jl      [r9]        ; Entry into Sys Call Handler
+
+	; fall through to ret_from_system_call
+ARC_EXIT EV_Trap
+
+ARC_ENTRY ret_from_system_call
+
+	st  r0, [sp, PT_r0]     ; sys call return value in pt_regs
+
+	; fall through yet again to ret_from_exception
+
+;############# Return from Intr/Excp/Trap (Linux Specifics) ##############
+;
+; If ret to user mode do we need to handle signals, schedule() et al.
+
+ARC_ENTRY ret_from_exception
+
+	; Pre-{IRQ,Trap,Exception} K/U mode from pt_regs->status32
+	ld  r8, [sp, PT_status32]   ; returning to User/Kernel Mode
+
+#ifdef CONFIG_PREEMPT
+	bbit0  r8, STATUS_U_BIT, resume_kernel_mode
+#else
+	bbit0  r8, STATUS_U_BIT, restore_regs
+#endif
+
+resume_user_mode_begin:
+
+	; Before returning to User mode check-for-and-complete any pending work
+	; such as rescheduling/signal-delivery etc.
+	; Disable IRQs to ensures that chk for pending work itself is atomic
+	; (and we don't end up missing a NEED_RESCHED/SIGPENDING due to an
+	; interim IRQ).
+	;
+	; IRQs would be re-enabled by one of the ensuing functions such as
+	; schedule()or worst case RTIE will automatically re-enable them,
+	; based on cpu state prior to this event.
+
+	IRQ_DISABLE	r10
+
+	; Fast Path return to user mode if no pending work
+	GET_CURR_THR_INFO_FLAGS   r9
+	and.f  0,  r9, _TIF_WORK_MASK
+	bz     restore_regs
+
+	; --- task preemption ---
+	bbit0  r9, TIF_NEED_RESCHED, 1f
+	bl     @schedule		; blnz yields relocation errors
+	b      resume_user_mode_begin	; loop back to start of U mode ret
+
+1:
+	; --- signal handling  ---
+	mov r0, sp	; pt_regs for arg to do_signal()/do_notify_resume()
+
+	; --------- check for signals/restore-sigmask ------------
+	bbit0  r9, TIF_SIGPENDING, chk_next_work
+
+	; save CALLEE Regs.
+	; (i)  If this signal causes coredump - full regfile needed
+	; (ii) If signal is SIGTRAP/SIGSTOP, task is being traced thus
+	;      tracer might call PEEKUSR for a CALLEE reg
+	;
+	; NOTE: SP will grow up by size of CALLEE Reg-File
+	SAVE_CALLEE_SAVED_USER		; clobbers r12
+
+	; save location of saved Callee Regs @ thread_struct->callee
+	GET_CURR_TASK_FIELD_PTR   TASK_THREAD, r10
+	st  sp, [r10, THREAD_CALLEE_REG]
+
+	bl  @do_signal
+
+	; unwind SP for cheap discard of Callee saved Regs
+	DISCARD_CALLEE_SAVED_USER
+
+	b      resume_user_mode_begin	; loop back to start of U mode ret
+
+	; --- notify_resume ---
+chk_next_work:
+	btst   r9, TIF_NOTIFY_RESUME
+	blnz   @do_notify_resume
+
+	;--------- All things done, go back to Userland ------
+
+	b restore_regs
+
+#ifdef CONFIG_PREEMPT
+
+resume_kernel_mode:
+
+	; Can't preempt if preemption disabled
+	GET_CURR_THR_INFO_FROM_SP   r10
+	ld  r8, [r10, THREAD_INFO_PREEMPT_COUNT]
+	brne  r8, 0, restore_regs
+
+	; check if this task's NEED_RESCHED flag set
+	ld  r9, [r10, THREAD_INFO_FLAGS]
+	bbit0  r9, TIF_NEED_RESCHED, restore_regs
+
+	IRQ_DISABLE	r9
+
+	; Invoke PREEMPTION
+	bl      preempt_schedule_irq
+
+	; preempt_schedule_irq() always returns with IRQ disabled
+#endif
+
+	; fall through
+
+;############# Return from Intr/Excp/Trap (ARC Specifics) ##############
+;
+; Restore the saved sys context (common exit-path for EXCPN/IRQ/Trap)
+; IRQ shd definitely not happen between now and rtie
+
+restore_regs :
+
+	; Disable Interrupts while restoring reg-file back
+	; XXX can this be optimised out
+	IRQ_DISABLE_SAVE    r9, r10	;@r10 has prisitine (pre-disable) copy
+
+	; Restore REG File. In case multiple Events outstanding,
+	; use the same priorty as rtie: EXCPN, L2 IRQ, L1 IRQ, None
+	; Note that we use realtime STATUS32 (not pt_regs->status32) to
+	; decide that.
+
+	; if Returning from Exception
+	bbit0  r10, STATUS_AE_BIT, not_exception
+	RESTORE_ALL_SYS
+	rtie
+
+	; Not Exception so maybe Interrupts (Level 1 or 2)
+
+not_exception:
+
+	bbit0  r10, STATUS_A1_BIT, not_level1_interrupt
+
+	;return from level 1
+
+	RESTORE_ALL_INT1
+debug_marker_l1:
+	rtie
+
+not_level1_interrupt:
+
+	;this case is for syscalls or Exceptions (with fake rtie)
+
+	RESTORE_ALL_SYS
+debug_marker_syscall:
+	rtie
+
+ARC_EXIT ret_from_exception
+
+ARC_ENTRY ret_from_fork
+	; when the forked child comes here from the __switch_to function
+	; r0 has the last task pointer.
+	; put last task in scheduler queue
+	bl  @schedule_tail
+	b @ret_from_exception
+ARC_EXIT ret_from_fork
-- 
1.7.4.1

