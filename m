Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1LHTbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 14:31:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37449 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab1LHTbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 14:31:38 -0500
X-Authority-Analysis: v=2.0 cv=QrfcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=zPYspYz4ohgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=D19gQVrFAAAA:8 a=Z4Rwk6OoAAAA:8 a=JfrnYn6hAAAA:8 a=QyXUC8HyAAAA:8 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8 a=7d_E57ReAAAA:8 a=meVymXHHAAAA:8 a=rKNloImTAUGTuCgaye0A:9 a=NY4PZ4BG_7StwTjgpkkA:7 a=jEp0ucaQiEUA:10 a=jbrJJM5MRmoA:10 a=3Rfx1nUSh_UA:10 a=Zh68SRI7RUMA:10 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=D6-X0JM3zdQA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111208193136.366941904@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 08 Dec 2011 14:30:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Paul Turner <pjt@google.com>
Subject: [RFC][PATCH 3/3] x86: Add workaround to NMI iret woes
References: <20111208193003.112037550@goodmis.org>
Content-Disposition: inline; filename=0003-x86-Add-workaround-to-NMI-iret-woes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

In x86, when an NMI goes off, the CPU goes into an NMI context that
prevents other NMIs to trigger on that CPU. If an NMI is suppose to
trigger, it has to wait till the previous NMI leaves NMI context.
At that time, the next NMI can trigger (note, only one more NMI will
trigger, as only one can be latched at a time).

The way x86 gets out of NMI context is by calling iret. The problem
with this is that this causes problems if the NMI handle either
triggers an exception, or a breakponit. Both the exception and the
breakpoint handlers will finish with an iret. If this happens while
in NMI context, the CPU will leave NMI context and a new NMI may come
in. As NMI handlers are not made to be re-entrant, this can cause
havoc with the system, not to mention, the nested NMI will write
all over the previous NMI's stack.

Linus Torvalds proposed the following workaround to this problem:

https://lkml.org/lkml/2010/7/14/264

"In fact, I wonder if we couldn't just do a software NMI disable
instead? Hav ea per-cpu variable (in the _core_ percpu areas that get
allocated statically) that points to the NMI stack frame, and just
make the NMI code itself do something like

 NMI entry:
 - load percpu NMI stack frame pointer
 - if non-zero we know we're nested, and should ignore this NMI:
    - we're returning to kernel mode, so return immediately by using
"popf/ret", which also keeps NMI's disabled in the hardware until the
"real" NMI iret happens.
    - before the popf/iret, use the NMI stack pointer to make the NMI
return stack be invalid and cause a fault
  - set the NMI stack pointer to the current stack pointer

 NMI exit (not the above "immediate exit because we nested"):
   clear the percpu NMI stack pointer
   Just do the iret.

Now, the thing is, now the "iret" is atomic. If we had a nested NMI,
we'll take a fault, and that re-does our "delayed" NMI - and NMI's
will stay masked.

And if we didn't have a nested NMI, that iret will now unmask NMI's,
and everything is happy."

I first tried to follow this advice but as I started implementing this
code a few gotchas showed up.

One, is accessing per-cpu variables in the NMI handler.

The problem is that per-cpu variables use the %gs register to get the
variable for the given CPU. But as the NMI may happen in userspace,
we must first perform a SWAPGS to get to it. The NMI handler already
does this later in the code, but its too late as we have saved off
all the registers and we don't want to do that for a disabled NMI.

Peter Zijlstra suggested to keep all variables on the stack. This
simplifies things greatly and it has the added benefit of cache locality.

Two, faulting on the iret.

I really wanted to make this work, but it was becoming very hacky, and
I never got it to be stable. The iret already had a fault handler for
userspace faulting with bad segment registers, and getting NMI to trigger
a fault and detect it was very tricky. But for strange reasons, the system
would usually take a double fault and crash. I never figured out why
and decided to go with a simple "jmp" approach. The new approach I took
also simplified things.

Finally, the last problem with Linus's approach was to have the nested
NMI handler do a ret instead of an iret to give the first NMI, NMI context
again.

The problem is that ret is much more limited than an iret. I couldn't figure
out how to get the stack back where it belonged. I could have copied the
current stack, pushed the return onto it, but my fear here is that there
may be some place that writes data below the stack pointer. I know that
is not something code should depend on, but I don't want to chance it.
I may add this feature later, but for now, an NMI handler that loses NMI
context will not get it back.

Here's what is done:

When an NMI comes in, the HW pushes the interrupt stack frame onto the
per cpu NMI stack that is selected by the IST.

A special location on the NMI stack holds a variable that is set when
the first NMI handler runs. If this variable is set then we know that
this is a nested NMI and we process the nested NMI code.

There is still a race when this variable is cleared and an NMI comes
in just before the first NMI does the return. For this case, if the
variable is cleared, we also check if the interrupted stack is the
NMI stack. If it is, then we process the nested NMI code.

Why the two tests and not just test the interrupted stack?

If the first NMI hits a breakpoint and loses NMI context, and then it
hits another breakpoint and while processing that breakpoint we get a
nested NMI. When processing a breakpoint, the stack changes to the
breakpoint stack. If another NMI comes in here we can't rely on the
interrupted stack to be the NMI stack.

If the variable is not set and the interrupted task's stack is not the
NMI stack, then we know this is the first NMI and we can process things
normally. But in order to do so, we need to do a few things first.

1) Set the stack variable that tells us that we are in an NMI handler

2) Make two copies of the interrupt stack frame.
   One copy is used to return on iret
   The other is used to restore the first one if we have a nested NMI.

This is what the stack will look like:

	  +-------------------------+
	  | original SS             |
	  | original Return RSP     |
	  | original RFLAGS         |
	  | original CS             |
	  | original RIP            |
	  +-------------------------+
	  | temp storage for rdx    |
	  +-------------------------+
	  | NMI executing variable  |
	  +-------------------------+
	  | Saved SS                |
	  | Saved Return RSP        |
	  | Saved RFLAGS            |
	  | Saved CS                |
	  | Saved RIP               |
	  +-------------------------+
	  | copied SS               |
	  | copied Return RSP       |
	  | copied RFLAGS           |
	  | copied CS               |
	  | copied RIP              |
	  +-------------------------+
	  | pt_regs                 |
	  +-------------------------+

The original stack frame contains what the HW put in when we entered
the NMI.

We store %rdx as a temp variable to use. Both the original HW stack
frame and this %rdx storage will be clobbered by nested NMIs so we
can not rely on them.

The next item is the special stack variable that is set when we execute
the rest of the NMI handler.

Then we have two copies of the interrupt stack. The second copy is
modified by any nested NMIs to let the first NMI know that we triggered
a second NMI (latched) and that we should repeat the NMI handler.

If the first NMI hits an exception or breakpoint that takes it out of
NMI context, if a second NMI comes in before the first one finishes,
it will update the copied interrupt stack to point to a fix up location
to trigger another NMI.

When the first NMI calls iret, it will instead jump to the fix up
location. This fix up location will copy the saved interrupt stack back
to the copy and execute the nmi handler again.

Note, the nested NMI knows enough to check if it preempted a previous
NMI handler while it is in the fixup location. If it has, it will not
modify the copied interrupt stack and will just leave as if nothing
happened. As the NMI handle is about to execute again, there's no reason
to latch now.

To test all this, I forced the NMI handler to call iret and take itself
out of NMI context. I also added assemble code to write to the serial to
make sure that it hits the nested path as well as the fix up path.
Everything seems to be working fine.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Turner <pjt@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_64.S |  168 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 168 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index d1d5434..b02409e 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1475,11 +1475,163 @@ ENTRY(error_exit)
 	CFI_ENDPROC
 END(error_exit)
 
+/*
+ * Test if a given stack is an NMI stack or not.
+ */
+	.macro test_in_nmi reg stack nmi_ret normal_ret
+	cmpq %\reg, \stack
+	ja \normal_ret
+	subq $4096, %\reg
+	cmpq %\reg, \stack
+	jb \normal_ret
+	jmp \nmi_ret
+	.endm
 
 	/* runs on exception stack */
 ENTRY(nmi)
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
+	/*
+	 * We allow breakpoints in NMIs. If a breakpoint occurs, then
+	 * the iretq it performs will take us out of NMI context.
+	 * This means that we can have nested NMIs where the next
+	 * NMI is using the top of the stack of the previous  NMI. We
+	 * can't let it execute because the nested NMI will corrupt the
+	 * stack of the previous NMI. NMI handlers are not re-entrant
+	 * anyway.
+	 *
+	 * To handle this case we do the following:
+	 *  Check the a special location on the stack that contains
+	 *  a variable that is set when NMIs are executing.
+	 *  The inerrupted task's stack is also checked to see if it
+	 *  is an NMI stack.
+	 *  If the variable is not set and the stack is not the NMI
+	 *  stack then:
+	 *    o Set the special variable on the stack
+	 *    o Copy the interrupt frame into a "saved" location on the stack
+	 *    o Copy the interrupt frame into a "copy" location on the stack
+	 *    o Continue processing the NMI
+	 *  If the variable is set or the previous stack is the NMI stack:
+	 *    o Modify the "copy" location to jump to the repeate_nmi
+	 *    o return back to the first NMI
+	 *
+	 * Now on exit of the first NMI, we first clear the stack variable
+	 * The NMI stack will tell any nested NMIs at that point that it is
+	 * nested. Then we pop the stack normally with iret, and if there was
+	 * a nested NMI that updated the copy interrupt stack frame, a
+	 * jump will be made to the repeat_nmi code that will handle the second
+	 * NMI.
+	 */
+
+	/* Use %rdx as out temp variable throughout */
+	pushq_cfi %rdx
+
+	/*
+	 * Check the special variable on the stack to see if NMIs are
+	 * executing.
+	 */
+	cmp $1, -8(%rsp)
+	je nested_nmi
+
+	/*
+	 * Now test if the previous stack was an NMI stack.
+	 * We need the double check. We check the NMI stack to satisfy the
+	 * race when the first NMI clears the variable before returning.
+	 * We check the variable because the first NMI could be in a
+	 * breakpoint routine using a breakpoint stack.
+	 */
+	lea 6*8(%rsp), %rdx
+	test_in_nmi rdx, 4*8(%rsp), nested_nmi, first_nmi
+
+nested_nmi:
+	/*
+	 * Do nothing if we interrupted the fixup in repeat_nmi.
+	 * It's about to repeat the NMI handler, so we are fine
+	 * with ignoring this one.
+	 */
+	leaq repeat_nmi, %rdx
+	cmpq 8(%rsp), %rdx
+	ja 1f
+	leaq end_repeat_nmi, %rdx
+	cmpq 8(%rsp), %rdx
+	ja nested_nmi_out
+
+1:
+	/* Set up the interrupted NMIs stack to jump to repeat_nmi */
+	leaq -6*8(%rsp), %rdi
+	movq %rdi, %rsp
+	pushq $__KERNEL_DS
+	pushq %rdi
+	pushfq
+	pushq $__KERNEL_CS
+	leaq repeat_nmi, %rdx
+	pushq_cfi %rdx
+
+	/* Put stack back */
+	addq $(11*8), %rsp
+
+nested_nmi_out:
+	popq_cfi %rdx
+
+	/* No need to check faults here */
+	INTERRUPT_RETURN
+
+first_nmi:
+	/*
+	 * Because nested NMIs will use the pushed location that we
+	 * stored rdx, we must keep that space available.
+	 * Here's what our stack frame will look like:
+	 * +-------------------------+
+	 * | original SS             |
+	 * | original Return RSP     |
+	 * | original RFLAGS         |
+	 * | original CS             |
+	 * | original RIP            |
+	 * +-------------------------+
+	 * | temp storage for rdx    |
+	 * +-------------------------+
+	 * | NMI executing variable  |
+	 * +-------------------------+
+	 * | Saved SS                |
+	 * | Saved Return RSP        |
+	 * | Saved RFLAGS            |
+	 * | Saved CS                |
+	 * | Saved RIP               |
+	 * +-------------------------+
+	 * | copied SS               |
+	 * | copied Return RSP       |
+	 * | copied RFLAGS           |
+	 * | copied CS               |
+	 * | copied RIP              |
+	 * +-------------------------+
+	 * | pt_regs                 |
+	 * +-------------------------+
+	 *
+	 * The saved RIP is used to fix up the copied RIP that a nested
+	 * NMI may zero out. The original stack frame and the temp storage
+	 * is also used by nested NMIs and can not be trusted on exit.
+	 */
+	/* Set the NMI executing variable on the stack. */
+	pushq_cfi $1
+
+	/* Copy the stack frame to the Saved frame */
+	pushq_cfi 6*8(%rsp)
+	pushq_cfi 6*8(%rsp)
+	pushq_cfi 6*8(%rsp)
+	pushq_cfi 6*8(%rsp)
+	pushq_cfi 6*8(%rsp)
+
+	/* Make another copy, this one may be modified by nested NMIs */
+	pushq_cfi 4*8(%rsp)
+	pushq_cfi 4*8(%rsp)
+	pushq_cfi 4*8(%rsp)
+	pushq_cfi 4*8(%rsp)
+	pushq_cfi 4*8(%rsp)
+
+	/* Do not pop rdx, nested NMIs will corrupt it */
+	movq 11*8(%rsp), %rdx
+
+restart_nmi:
 	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
@@ -1502,10 +1654,26 @@ nmi_swapgs:
 	SWAPGS_UNSAFE_STACK
 nmi_restore:
 	RESTORE_ALL 8
+	/* Clear the NMI executing stack variable */
+	movq $0, 10*8(%rsp)
 	jmp irq_return
 	CFI_ENDPROC
 END(nmi)
 
+repeat_nmi:
+	/* Update the stack variable to say we are still in NMI */
+	movq $1, 5*8(%rsp)
+
+	/* copy the saved stack back to copy stack */
+	pushq 4*8(%rsp)
+	pushq 4*8(%rsp)
+	pushq 4*8(%rsp)
+	pushq 4*8(%rsp)
+	pushq 4*8(%rsp)
+
+	jmp restart_nmi
+end_repeat_nmi:
+
 ENTRY(ignore_sysret)
 	CFI_STARTPROC
 	mov $-ENOSYS,%eax
-- 
1.7.7.3


