Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab1GBQaU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 12:30:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39758 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab1GBQaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 12:30:02 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: [PATCH 6/6] x86: Don't use frame pointer to save old stack on irq entry
Date: Sat,  2 Jul 2011 18:29:44 +0200
Message-Id: <1309624184-9790-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309624184-9790-1-git-send-email-fweisbec@gmail.com>
References: <1309624184-9790-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rbp is used in SAVE_ARGS_IRQ to save the old stack pointer
in order to restore it later in ret_from_intr.

It is convenient because we save its value in the irq regs
and it's easily restored using the leave instruction.

However this is a kind of abuse of the frame pointer which
role is to help unwinding the kernel by chaining frames
together, each node following the return address to the
previous frame.

But although we are breaking the frame by changing the stack
pointer, there is no preceding return address before the new
frame. Hence using the frame pointer to link the two stacks
breaks the stack unwinders that find a random value instead of
a return address here.

There is no workaround that can work in every case. We are using
the fixup_bp_irq_link() function to dereference that abused frame
pointer in the case of non nesting interrupt (which means stack
changed).
But that doesn't fix the case of interrupts that don't change the
stack (but we still have the unconditional frame link), which is
the case of hardirq interrupting softirq. We have no way to detect
this transition so the frame irq link is considered as a real frame
pointer and the return address is dereferenced but it is still a
spurious one.

There are two possible results of this: either the spurious return
address, a random stack value, luckily belongs to the kernel text
and then the unwinding can continue and we just have a weird entry
in the stack trace. Or it doesn't belong to the kernel text and
unwinding stops there.

This is the reason why stacktraces (including perf callchains) on
irqs that interrupted softirqs don't work very well.

To solve this, we don't save the old stack pointer on rbp anymore
but we save it to a scratch register that we push on the new
stack and that we pop back later on irq return.

This preserves the whole frame chain without spurious return addresses
in the middle and drops the need for the horrid fixup_bp_irq_link()
workaround.

And finally irqs that interrupt softirq are sanely unwinded.

Before:

    99.81%         perf  [kernel.kallsyms]  [k] perf_pending_event
                   |
                   --- perf_pending_event
                       irq_work_run
                       smp_irq_work_interrupt
                       irq_work_interrupt
                      |
                      |--41.60%-- __read
                      |          |
                      |          |--99.90%-- create_worker
                      |          |          bench_sched_messaging
                      |          |          cmd_bench
                      |          |          run_builtin
                      |          |          main
                      |          |          __libc_start_main
                      |           --0.10%-- [...]

After:

     1.64%  swapper  [kernel.kallsyms]  [k] perf_pending_event
            |
            --- perf_pending_event
                irq_work_run
                smp_irq_work_interrupt
                irq_work_interrupt
               |
               |--95.00%-- arch_irq_work_raise
               |          irq_work_queue
               |          __perf_event_overflow
               |          perf_swevent_overflow
               |          perf_swevent_event
               |          perf_tp_event
               |          perf_trace_softirq
               |          __do_softirq
               |          call_softirq
               |          do_softirq
               |          irq_exit
               |          |
               |          |--73.68%-- smp_apic_timer_interrupt
               |          |          apic_timer_interrupt
               |          |          |
               |          |          |--96.43%-- amd_e400_idle
               |          |          |          cpu_idle
               |          |          |          start_secondary

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jan Beulich <JBeulich@novell.com>
---
 arch/x86/kernel/dumpstack_64.c |   30 ------------------------------
 arch/x86/kernel/entry_64.S     |   27 +++++++++++++++------------
 2 files changed, 15 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 788295c..19853ad 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -105,34 +105,6 @@ in_irq_stack(unsigned long *stack, unsigned long *irq_stack,
 }
 
 /*
- * We are returning from the irq stack and go to the previous one.
- * If the previous stack is also in the irq stack, then bp in the first
- * frame of the irq stack points to the previous, interrupted one.
- * Otherwise we have another level of indirection: We first save
- * the bp of the previous stack, then we switch the stack to the irq one
- * and save a new bp that links to the previous one.
- * (See save_args())
- */
-static inline unsigned long
-fixup_bp_irq_link(unsigned long bp, unsigned long *stack,
-		  unsigned long *irq_stack, unsigned long *irq_stack_end)
-{
-#ifdef CONFIG_FRAME_POINTER
-	struct stack_frame *frame = (struct stack_frame *)bp;
-	unsigned long next;
-
-	if (!in_irq_stack(stack, irq_stack, irq_stack_end)) {
-		if (!probe_kernel_address(&frame->next_frame, next))
-			return next;
-		else
-			WARN_ONCE(1, "Perf: bad frame pointer = %p in "
-				  "callchain\n", &frame->next_frame);
-	}
-#endif
-	return bp;
-}
-
-/*
  * x86-64 can have up to three kernel stacks:
  * process stack
  * interrupt stack
@@ -208,8 +180,6 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 				 * pointer (index -1 to end) in the IRQ stack:
 				 */
 				stack = (unsigned long *) (irq_stack_end[-1]);
-				bp = fixup_bp_irq_link(bp, stack, irq_stack,
-						       irq_stack_end);
 				irq_stack_end = NULL;
 				ops->stack(data, "EOI");
 				continue;
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 6131432..d656f68 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -310,8 +310,11 @@ ENDPROC(native_usergs_sysret64)
 	movq_cfi r10, R10-RBP
 	movq_cfi r11, R11-RBP
 
-	movq_cfi rbp, 0		/* push %rbp */
-	movq %rsp, %rbp
+	/* Save rbp so that we can unwind from get_irq_regs() */
+	movq_cfi rbp, 0
+
+	/* Save previous stack value */
+	movq %rsp, %rsi
 
 	leaq -RBP(%rsp),%rdi	/* arg1 for handler */
 	testl $3, CS(%rdi)
@@ -327,10 +330,11 @@ ENDPROC(native_usergs_sysret64)
 	jne 2f
 	mov PER_CPU_VAR(irq_stack_ptr),%rsp
 	EMPTY_FRAME 0
-	/*
-	 * We entered an interrupt context - irqs are off:
-	 */
-2:	TRACE_IRQS_OFF
+
+2:	/* Store previous stack value */
+	pushq %rsi
+	/* We entered an interrupt context - irqs are off: */
+	TRACE_IRQS_OFF
 	.endm
 
 ENTRY(save_rest)
@@ -804,15 +808,14 @@ ret_from_intr:
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	decl PER_CPU_VAR(irq_count)
-	leaveq
 
-	CFI_RESTORE		rbp
+	/* Restore saved previous stack */
+	popq %rsi
+	leaq 16(%rsi), %rsp
+
 	CFI_DEF_CFA_REGISTER	rsp
-	CFI_ADJUST_CFA_OFFSET	-8
+	CFI_ADJUST_CFA_OFFSET	-16
 
-	/* we did not save rbx, restore only from ARGOFFSET */
-	addq $8, %rsp
-	CFI_ADJUST_CFA_OFFSET	-8
 exit_intr:
 	GET_THREAD_INFO(%rcx)
 	testl $3,CS-ARGOFFSET(%rsp)
-- 
1.7.5.4

