Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab2D2Ssi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 14:48:38 -0400
Received: from [12.216.194.151] ([12.216.194.151]:53668 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab2D2Ssg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 14:48:36 -0400
Message-ID: <201204291848.q3TImYbB018376@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Sat, 28 Apr 2012 14:51:43 -0400
Subject: [PATCH v2] arch/tile: fix up some issues in calling do_work_pending()
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20120429005505.GX6871@ZenIV.linux.org.uk>
References: <20120427172444.GA30267@redhat.com>
 <20120427184528.GL6871@ZenIV.linux.org.uk>
 <20120427202002.8ED632C0BF@topped-with-meat.com>
 <20120427211244.GO6871@ZenIV.linux.org.uk>
 <20120427212729.652542C0AF@topped-with-meat.com>
 <20120427231526.GP6871@ZenIV.linux.org.uk>
 <20120427235023.GR6871@ZenIV.linux.org.uk>
 <201204281858.q3SIwC7H014319@farm-0027.internal.tilera.com>
 <20120428205517.GW6871@ZenIV.linux.org.uk>
 <4F9C6525.3050405@tilera.com>
 <20120429005505.GX6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, we were at risk of handling thread-info flags, in particular
do_signal(), when returning from kernel space.  This could happen
after a failed kernel_execve(), or when forking a kernel thread.
The fix is to test in do_work_pending() for user_mode() and return
immediately if so; we already had this test for one of the flags,
so I just hoisted it to the top of the function.

Second, if a ptraced process updated the callee-saved registers
in the ptregs struct and then processed another thread-info flag, we
would overwrite the modifications with the original callee-saved
registers.  To fix this, we add a register to note if we've already
saved the registers once, and skip doing it on additional passes
through the loop.  To avoid a performance hit from the couple of
extra instructions involved, I modified the GET_THREAD_INFO() macro
to be guaranteed to be one instruction, then bundled it with adjacent
instructions, yielding an overall net savings.

Reported-By: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/thread_info.h |    9 ++++++-
 arch/tile/kernel/intvec_32.S        |   41 +++++++++++++++++++++++-----------
 arch/tile/kernel/intvec_64.S        |   38 +++++++++++++++++++++++--------
 arch/tile/kernel/process.c          |    7 ++++-
 4 files changed, 68 insertions(+), 27 deletions(-)

diff --git a/arch/tile/include/asm/thread_info.h b/arch/tile/include/asm/thread_info.h
index bc4f562..7594764 100644
--- a/arch/tile/include/asm/thread_info.h
+++ b/arch/tile/include/asm/thread_info.h
@@ -100,9 +100,14 @@ extern void cpu_idle_on_new_stack(struct thread_info *old_ti,
 
 #else /* __ASSEMBLY__ */
 
-/* how to get the thread information struct from ASM */
+/*
+ * How to get the thread information struct from assembly.
+ * Note that we use different macros since different architectures
+ * have different semantics in their "mm" instruction and we would
+ * like to guarantee that the macro expands to exactly one instruction.
+ */
 #ifdef __tilegx__
-#define GET_THREAD_INFO(reg) move reg, sp; mm reg, zero, LOG2_THREAD_SIZE, 63
+#define EXTRACT_THREAD_INFO(reg) mm reg, zero, LOG2_THREAD_SIZE, 63
 #else
 #define GET_THREAD_INFO(reg) mm reg, sp, zero, LOG2_THREAD_SIZE, 31
 #endif
diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index 5d56a1e..6943515 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -839,6 +839,18 @@ STD_ENTRY(interrupt_return)
 	FEEDBACK_REENTER(interrupt_return)
 
 	/*
+	 * Use r33 to hold whether we have already loaded the callee-saves
+	 * into ptregs.  We don't want to do it twice in this loop, since
+	 * then we'd clobber whatever changes are made by ptrace, etc.
+	 * Get base of stack in r32.
+	 */
+	{
+	 GET_THREAD_INFO(r32)
+	 movei  r33, 0
+	}
+
+.Lretry_work_pending:
+	/*
 	 * Disable interrupts so as to make sure we don't
 	 * miss an interrupt that sets any of the thread flags (like
 	 * need_resched or sigpending) between sampling and the iret.
@@ -848,9 +860,6 @@ STD_ENTRY(interrupt_return)
 	IRQ_DISABLE(r20, r21)
 	TRACE_IRQS_OFF  /* Note: clobbers registers r0-r29 */
 
-	/* Get base of stack in r32; note r30/31 are used as arguments here. */
-	GET_THREAD_INFO(r32)
-
 
 	/* Check to see if there is any work to do before returning to user. */
 	{
@@ -866,16 +875,18 @@ STD_ENTRY(interrupt_return)
 
 	/*
 	 * Make sure we have all the registers saved for signal
-	 * handling or single-step.  Call out to C code to figure out
-	 * exactly what we need to do for each flag bit, then if
-	 * necessary, reload the flags and recheck.
+	 * handling, notify-resume, or single-step.  Call out to C
+	 * code to figure out exactly what we need to do for each flag bit,
+	 * then if necessary, reload the flags and recheck.
 	 */
-	push_extra_callee_saves r0
 	{
 	 PTREGS_PTR(r0, PTREGS_OFFSET_BASE)
-	 jal    do_work_pending
+	 bnz    r33, 1f
 	}
-	bnz     r0, .Lresume_userspace
+	push_extra_callee_saves r0
+	movei   r33, 1
+1:	jal     do_work_pending
+	bnz     r0, .Lretry_work_pending
 
 	/*
 	 * In the NMI case we
@@ -1180,10 +1191,12 @@ handle_syscall:
 	add     r20, r20, tp
 	lw      r21, r20
 	addi    r21, r21, 1
-	sw      r20, r21
+	{
+	 sw     r20, r21
+	 GET_THREAD_INFO(r31)
+	}
 
 	/* Trace syscalls, if requested. */
-	GET_THREAD_INFO(r31)
 	addi	r31, r31, THREAD_INFO_FLAGS_OFFSET
 	lw	r30, r31
 	andi    r30, r30, _TIF_SYSCALL_TRACE
@@ -1362,7 +1375,10 @@ handle_ill:
 3:
 	/* set PC and continue */
 	lw      r26, r24
-	sw      r28, r26
+	{
+	 sw     r28, r26
+	 GET_THREAD_INFO(r0)
+	}
 
 	/*
 	 * Clear TIF_SINGLESTEP to prevent recursion if we execute an ill.
@@ -1370,7 +1386,6 @@ handle_ill:
 	 * need to clear it here and can't really impose on all other arches.
 	 * So what's another write between friends?
 	 */
-	GET_THREAD_INFO(r0)
 
 	addi    r1, r0, THREAD_INFO_FLAGS_OFFSET
 	{
diff --git a/arch/tile/kernel/intvec_64.S b/arch/tile/kernel/intvec_64.S
index 49d9d66..30ae76e 100644
--- a/arch/tile/kernel/intvec_64.S
+++ b/arch/tile/kernel/intvec_64.S
@@ -647,6 +647,20 @@ STD_ENTRY(interrupt_return)
 	FEEDBACK_REENTER(interrupt_return)
 
 	/*
+	 * Use r33 to hold whether we have already loaded the callee-saves
+	 * into ptregs.  We don't want to do it twice in this loop, since
+	 * then we'd clobber whatever changes are made by ptrace, etc.
+	 */
+	{
+	 movei  r33, 0
+	 move   r32, sp
+	}
+
+	/* Get base of stack in r32. */
+	EXTRACT_THREAD_INFO(r32)
+
+.Lretry_work_pending:
+	/*
 	 * Disable interrupts so as to make sure we don't
 	 * miss an interrupt that sets any of the thread flags (like
 	 * need_resched or sigpending) between sampling and the iret.
@@ -656,9 +670,6 @@ STD_ENTRY(interrupt_return)
 	IRQ_DISABLE(r20, r21)
 	TRACE_IRQS_OFF  /* Note: clobbers registers r0-r29 */
 
-	/* Get base of stack in r32; note r30/31 are used as arguments here. */
-	GET_THREAD_INFO(r32)
-
 
 	/* Check to see if there is any work to do before returning to user. */
 	{
@@ -674,16 +685,18 @@ STD_ENTRY(interrupt_return)
 
 	/*
 	 * Make sure we have all the registers saved for signal
-	 * handling or single-step.  Call out to C code to figure out
+	 * handling or notify-resume.  Call out to C code to figure out
 	 * exactly what we need to do for each flag bit, then if
 	 * necessary, reload the flags and recheck.
 	 */
-	push_extra_callee_saves r0
 	{
 	 PTREGS_PTR(r0, PTREGS_OFFSET_BASE)
-	 jal    do_work_pending
+	 bnez   r33, 1f
 	}
-	bnez    r0, .Lresume_userspace
+	push_extra_callee_saves r0
+	movei   r33, 1
+1:	jal     do_work_pending
+	bnez    r0, .Lretry_work_pending
 
 	/*
 	 * In the NMI case we
@@ -968,11 +981,16 @@ handle_syscall:
 	shl16insli r20, r20, hw0(irq_stat + IRQ_CPUSTAT_SYSCALL_COUNT_OFFSET)
 	add     r20, r20, tp
 	ld4s    r21, r20
-	addi    r21, r21, 1
-	st4     r20, r21
+	{
+	 addi   r21, r21, 1
+	 move   r31, sp
+	}
+	{
+	 st4    r20, r21
+	 EXTRACT_THREAD_INFO(r31)
+	}
 
 	/* Trace syscalls, if requested. */
-	GET_THREAD_INFO(r31)
 	addi	r31, r31, THREAD_INFO_FLAGS_OFFSET
 	ld	r30, r31
 	andi    r30, r30, _TIF_SYSCALL_TRACE
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 2d5ef61..54e6c64 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -567,6 +567,10 @@ struct task_struct *__sched _switch_to(struct task_struct *prev,
  */
 int do_work_pending(struct pt_regs *regs, u32 thread_info_flags)
 {
+	/* If we enter in kernel mode, do nothing and exit the caller loop. */
+	if (!user_mode(regs))
+		return 0;
+
 	if (thread_info_flags & _TIF_NEED_RESCHED) {
 		schedule();
 		return 1;
@@ -589,8 +593,7 @@ int do_work_pending(struct pt_regs *regs, u32 thread_info_flags)
 		return 1;
 	}
 	if (thread_info_flags & _TIF_SINGLESTEP) {
-		if ((regs->ex1 & SPR_EX_CONTEXT_1_1__PL_MASK) == 0)
-			single_step_once(regs);
+		single_step_once(regs);
 		return 0;
 	}
 	panic("work_pending: bad flags %#x\n", thread_info_flags);
-- 
1.6.5.2

