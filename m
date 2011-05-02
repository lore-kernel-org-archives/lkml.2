Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab1EBXLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 19:11:53 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:54332 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424Ab1EBXJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 19:09:26 -0400
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 May 2011 19:09:25 EDT
Message-Id: <201105022254.p42MsP7L030351@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 2 May 2011 14:50:06 -0400
Subject: [PATCH] arch/tile: support TIF_NOTIFY_RESUME
To: linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>
X-OriginalArrivalTime: 02 May 2011 22:54:25.0706 (UTC) FILETIME=[E294A0A0:01CC091B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This support is required for CONFIG_KEYS, NFSv4 kernel DNS, etc.
The change is slightly more complex than the minimal thing, since
I took advantage of having to go into the assembly code to just
move a bunch of stuff into C code: specifically, the schedule(),
do_async_page_fault(), do_signal(), and single_step_once() support,
in addition to the TIF_NOTIFY_RESUME support.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/processor.h   |    2 +
 arch/tile/include/asm/thread_info.h |    5 +-
 arch/tile/include/asm/traps.h       |    4 +
 arch/tile/kernel/intvec_32.S        |  114 +++++-----------------------------
 arch/tile/kernel/process.c          |   48 +++++++++++++++
 arch/tile/kernel/single_step.c      |    8 +++
 arch/tile/mm/fault.c                |    6 +-
 7 files changed, 87 insertions(+), 100 deletions(-)

diff --git a/arch/tile/include/asm/processor.h b/arch/tile/include/asm/processor.h
index e688947..d6b43dd 100644
--- a/arch/tile/include/asm/processor.h
+++ b/arch/tile/include/asm/processor.h
@@ -215,6 +215,8 @@ static inline void release_thread(struct task_struct *dead_task)
 
 extern int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
 
+extern int do_work_pending(struct pt_regs *regs, u32 flags);
+
 
 /*
  * Return saved (kernel) PC of a blocked thread.
diff --git a/arch/tile/include/asm/thread_info.h b/arch/tile/include/asm/thread_info.h
index 3405b52..bc4f562 100644
--- a/arch/tile/include/asm/thread_info.h
+++ b/arch/tile/include/asm/thread_info.h
@@ -125,6 +125,7 @@ extern void cpu_idle_on_new_stack(struct thread_info *old_ti,
 #define TIF_SYSCALL_AUDIT	5	/* syscall auditing active */
 #define TIF_SECCOMP		6	/* secure computing */
 #define TIF_MEMDIE		7	/* OOM killer at work */
+#define TIF_NOTIFY_RESUME	8	/* callback before returning to user */
 
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
@@ -134,10 +135,12 @@ extern void cpu_idle_on_new_stack(struct thread_info *old_ti,
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 #define _TIF_MEMDIE		(1<<TIF_MEMDIE)
+#define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 
 /* Work to do on any return to user space. */
 #define _TIF_ALLWORK_MASK \
-  (_TIF_SIGPENDING|_TIF_NEED_RESCHED|_TIF_SINGLESTEP|_TIF_ASYNC_TLB)
+  (_TIF_SIGPENDING|_TIF_NEED_RESCHED|_TIF_SINGLESTEP|\
+   _TIF_ASYNC_TLB|_TIF_NOTIFY_RESUME)
 
 /*
  * Thread-synchronous status.
diff --git a/arch/tile/include/asm/traps.h b/arch/tile/include/asm/traps.h
index d06e35f..5f20f92 100644
--- a/arch/tile/include/asm/traps.h
+++ b/arch/tile/include/asm/traps.h
@@ -15,10 +15,14 @@
 #ifndef _ASM_TILE_TRAPS_H
 #define _ASM_TILE_TRAPS_H
 
+#include <arch/chip.h>
+
 /* mm/fault.c */
 void do_page_fault(struct pt_regs *, int fault_num,
 		   unsigned long address, unsigned long write);
+#if CHIP_HAS_TILE_DMA() || CHIP_HAS_SN_PROC()
 void do_async_page_fault(struct pt_regs *);
+#endif
 
 #ifndef __tilegx__
 /*
diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index fffcfa6..f35c312 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -851,14 +851,27 @@ STD_ENTRY(interrupt_return)
 	/* Check to see if there is any work to do before returning to user. */
 	{
 	 addi   r29, r32, THREAD_INFO_FLAGS_OFFSET
-	 moveli r28, lo16(_TIF_ALLWORK_MASK)
+	 moveli r1, lo16(_TIF_ALLWORK_MASK)
 	}
 	{
 	 lw     r29, r29
-	 auli   r28, r28, ha16(_TIF_ALLWORK_MASK)
+	 auli   r1, r1, ha16(_TIF_ALLWORK_MASK)
 	}
-	and     r28, r29, r28
-	bnz     r28, .Lwork_pending
+	and     r1, r29, r1
+	bzt     r1, .Lrestore_all
+
+	/*
+	 * Make sure we have all the registers saved for signal
+	 * handling or single-step.  Call out to C code to figure out
+	 * exactly what we need to do for each flag bit, then if
+	 * necessary, reload the flags and recheck.
+	 */
+	push_extra_callee_saves r0
+	{
+	 PTREGS_PTR(r0, PTREGS_OFFSET_BASE)
+	 jal    do_work_pending
+	}
+	bnz     r0, .Lresume_userspace
 
 	/*
 	 * In the NMI case we
@@ -1099,99 +1112,6 @@ STD_ENTRY(interrupt_return)
 	pop_reg r50
 	pop_reg r51, sp, PTREGS_OFFSET_REG(29) - PTREGS_OFFSET_REG(51)
 	j .Lcontinue_restore_regs
-
-.Lwork_pending:
-	/* Mask the reschedule flag */
-	andi    r28, r29, _TIF_NEED_RESCHED
-
-	{
-	 /*
-	  * If the NEED_RESCHED flag is called, we call schedule(), which
-	  * may drop this context right here and go do something else.
-	  * On return, jump back to .Lresume_userspace and recheck.
-	  */
-	 bz     r28, .Lasync_tlb
-
-	 /* Mask the async-tlb flag */
-	 andi   r28, r29, _TIF_ASYNC_TLB
-	}
-
-	jal     schedule
-	FEEDBACK_REENTER(interrupt_return)
-
-	/* Reload the flags and check again */
-	j       .Lresume_userspace
-
-.Lasync_tlb:
-	{
-	 bz     r28, .Lneed_sigpending
-
-	 /* Mask the sigpending flag */
-	 andi   r28, r29, _TIF_SIGPENDING
-	}
-
-	PTREGS_PTR(r0, PTREGS_OFFSET_BASE)
-	jal     do_async_page_fault
-	FEEDBACK_REENTER(interrupt_return)
-
-	/*
-	 * Go restart the "resume userspace" process.  We may have
-	 * fired a signal, and we need to disable interrupts again.
-	 */
-	j       .Lresume_userspace
-
-.Lneed_sigpending:
-	/*
-	 * At this point we are either doing signal handling or single-step,
-	 * so either way make sure we have all the registers saved.
-	 */
-	push_extra_callee_saves r0
-
-	{
-	 /* If no signal pending, skip to singlestep check */
-	 bz     r28, .Lneed_singlestep
-
-	 /* Mask the singlestep flag */
-	 andi   r28, r29, _TIF_SINGLESTEP
-	}
-
-	jal     do_signal
-	FEEDBACK_REENTER(interrupt_return)
-
-	/* Reload the flags and check again */
-	j       .Lresume_userspace
-
-.Lneed_singlestep:
-	{
-	 /* Get a pointer to the EX1 field */
-	 PTREGS_PTR(r29, PTREGS_OFFSET_EX1)
-
-	 /* If we get here, our bit must be set. */
-	 bz     r28, .Lwork_confusion
-	}
-	/* If we are in priv mode, don't single step */
-	lw      r28, r29
-	andi    r28, r28, SPR_EX_CONTEXT_1_1__PL_MASK  /* mask off ICS */
-	bnz     r28, .Lrestore_all
-
-	/* Allow interrupts within the single step code */
-	TRACE_IRQS_ON  /* Note: clobbers registers r0-r29 */
-	IRQ_ENABLE(r20, r21)
-
-	/* try to single-step the current instruction */
-	PTREGS_PTR(r0, PTREGS_OFFSET_BASE)
-	jal     single_step_once
-	FEEDBACK_REENTER(interrupt_return)
-
-	/* Re-disable interrupts.  TRACE_IRQS_OFF in .Lrestore_all. */
-	IRQ_DISABLE(r20,r21)
-
-	j       .Lrestore_all
-
-.Lwork_confusion:
-	move    r0, r28
-	panic   "thread_info allwork flags unhandled on userspace resume: %#x"
-
 	STD_ENDPROC(interrupt_return)
 
 	/*
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index d006510..8e86334 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -25,10 +25,13 @@
 #include <linux/hardirq.h>
 #include <linux/syscalls.h>
 #include <linux/kernel.h>
+#include <linux/tracehook.h>
+#include <linux/signal.h>
 #include <asm/system.h>
 #include <asm/stack.h>
 #include <asm/homecache.h>
 #include <asm/syscalls.h>
+#include <asm/traps.h>
 #ifdef CONFIG_HARDWALL
 #include <asm/hardwall.h>
 #endif
@@ -546,6 +549,51 @@ struct task_struct *__sched _switch_to(struct task_struct *prev,
 	return __switch_to(prev, next, next_current_ksp0(next));
 }
 
+/*
+ * This routine is called on return from interrupt if any of the
+ * TIF_WORK_MASK flags are set in thread_info->flags.  It is
+ * entered with interrupts disabled so we don't miss an event
+ * that modified the thread_info flags.  If any flag is set, we
+ * handle it and return, and the calling assembly code will
+ * re-disable interrupts, reload the thread flags, and call back
+ * if more flags need to be handled.
+ *
+ * We return whether we need to check the thread_info flags again
+ * or not.  Note that we don't clear TIF_SINGLESTEP here, so it's
+ * important that it be tested last, and then claim that we don't
+ * need to recheck the flags.
+ */
+int do_work_pending(struct pt_regs *regs, u32 thread_info_flags)
+{
+	if (thread_info_flags & _TIF_NEED_RESCHED) {
+		schedule();
+		return 1;
+	}
+#if CHIP_HAS_TILE_DMA() || CHIP_HAS_SN_PROC()
+	if (thread_info_flags & _TIF_ASYNC_TLB) {
+		do_async_page_fault(regs);
+		return 1;
+	}
+#endif
+	if (thread_info_flags & _TIF_SIGPENDING) {
+		do_signal(regs);
+		return 1;
+	}
+	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
+		clear_thread_flag(TIF_NOTIFY_RESUME);
+		tracehook_notify_resume(regs);
+		if (current->replacement_session_keyring)
+			key_replace_session_keyring();
+		return 1;
+	}
+	if (thread_info_flags & _TIF_SINGLESTEP) {
+		if ((regs->ex1 & SPR_EX_CONTEXT_1_1__PL_MASK) == 0)
+			single_step_once(regs);
+		return 0;
+	}
+	panic("work_pending: bad flags %#x\n", thread_info_flags);
+}
+
 /* Note there is an implicit fifth argument if (clone_flags & CLONE_SETTLS). */
 SYSCALL_DEFINE5(clone, unsigned long, clone_flags, unsigned long, newsp,
 		void __user *, parent_tidptr, void __user *, child_tidptr,
diff --git a/arch/tile/kernel/single_step.c b/arch/tile/kernel/single_step.c
index 84a729e..86df5a2 100644
--- a/arch/tile/kernel/single_step.c
+++ b/arch/tile/kernel/single_step.c
@@ -318,6 +318,14 @@ void single_step_once(struct pt_regs *regs)
 "    .popsection\n"
 	);
 
+	/*
+	 * Enable interrupts here to allow touching userspace and the like.
+	 * The callers expect this: do_trap() already has interrupts
+	 * enabled, and do_work_pending() handles functions that enable
+	 * interrupts internally.
+	 */
+	local_irq_enable();
+
 	if (state == NULL) {
 		/* allocate a page of writable, executable memory */
 		state = kmalloc(sizeof(struct single_step_state), GFP_KERNEL);
diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
index 51f8663..24ca54a 100644
--- a/arch/tile/mm/fault.c
+++ b/arch/tile/mm/fault.c
@@ -732,6 +732,7 @@ void do_page_fault(struct pt_regs *regs, int fault_num,
 		panic("Bad fault number %d in do_page_fault", fault_num);
 	}
 
+#if CHIP_HAS_TILE_DMA() || CHIP_HAS_SN_PROC()
 	if (EX1_PL(regs->ex1) != USER_PL) {
 		struct async_tlb *async;
 		switch (fault_num) {
@@ -775,6 +776,7 @@ void do_page_fault(struct pt_regs *regs, int fault_num,
 			return;
 		}
 	}
+#endif
 
 	handle_page_fault(regs, fault_num, is_page_fault, address, write);
 }
@@ -801,8 +803,6 @@ static void handle_async_page_fault(struct pt_regs *regs,
 				  async->address, async->is_write);
 	}
 }
-#endif /* CHIP_HAS_TILE_DMA() || CHIP_HAS_SN_PROC() */
-
 
 /*
  * This routine effectively re-issues asynchronous page faults
@@ -824,6 +824,8 @@ void do_async_page_fault(struct pt_regs *regs)
 	handle_async_page_fault(regs, &current->thread.sn_async_tlb);
 #endif
 }
+#endif /* CHIP_HAS_TILE_DMA() || CHIP_HAS_SN_PROC() */
+
 
 void vmalloc_sync_all(void)
 {
-- 
1.6.5.2

