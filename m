Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab2BVU4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 15:56:43 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59114 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab2BVU4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 15:56:41 -0500
Date: Wed, 22 Feb 2012 12:56:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@i5.linux-foundation.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
cc: Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Peter Anvin <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] i387: make irq_fpu_usable() tests more robust
In-Reply-To: <alpine.LFD.2.02.1202221255150.20522@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.02.1202221256130.20522@i5.linux-foundation.org>
References: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org> <alpine.LFD.2.02.1202221255150.20522@i5.linux-foundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 13 Feb 2012 13:56:14 -0800

[ Upstream commit 5b1cbac37798805c1fee18c8cebe5c0a13975b17 and
  subsequent fix from c38e23456278e967f094b08247ffc3711b1029b2 ]

Some code - especially the crypto layer - wants to use the x86
FP/MMX/AVX register set in what may be interrupt (typically softirq)
context.

That *can* be ok, but the tests for when it was ok were somewhat
suspect.  We cannot touch the thread-specific status bits either, so
we'd better check that we're not going to try to save FP state or
anything like that.

Now, it may be that the TS bit is always cleared *before* we set the
USEDFPU bit (and only set when we had already cleared the USEDFP
before), so the TS bit test may actually have been sufficient, but it
certainly was not obviously so.

So this explicitly verifies that we will not touch the TS_USEDFPU bit,
and adds a few related sanity-checks.  Because it seems that somehow
AES-NI is corrupting user FP state.  The cause is not clear, and this
patch doesn't fix it, but while debugging it I really wanted the code to
be more obviously correct and robust.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@kernel.org	# Fixes (unimportant) bug and helps backporting
---
 arch/x86/include/asm/i387.h |   54 ++++++++++++++++++++++++++++++++++++------
 1 files changed, 46 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index cba143210780..262bea981aa5 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -307,9 +307,54 @@ static inline void __clear_fpu(struct task_struct *tsk)
 	}
 }
 
+/*
+ * Were we in an interrupt that interrupted kernel mode?
+ *
+ * We can do a kernel_fpu_begin/end() pair *ONLY* if that
+ * pair does nothing at all: TS_USEDFPU must be clear (so
+ * that we don't try to save the FPU state), and TS must
+ * be set (so that the clts/stts pair does nothing that is
+ * visible in the interrupted kernel thread).
+ */
+static inline bool interrupted_kernel_fpu_idle(void)
+{
+	return !(current_thread_info()->status & TS_USEDFPU) &&
+		(read_cr0() & X86_CR0_TS);
+}
+
+/*
+ * Were we in user mode (or vm86 mode) when we were
+ * interrupted?
+ *
+ * Doing kernel_fpu_begin/end() is ok if we are running
+ * in an interrupt context from user mode - we'll just
+ * save the FPU state as required.
+ */
+static inline bool interrupted_user_mode(void)
+{
+	struct pt_regs *regs = get_irq_regs();
+	return regs && user_mode_vm(regs);
+}
+
+/*
+ * Can we use the FPU in kernel mode with the
+ * whole "kernel_fpu_begin/end()" sequence?
+ *
+ * It's always ok in process context (ie "not interrupt")
+ * but it is sometimes ok even from an irq.
+ */
+static inline bool irq_fpu_usable(void)
+{
+	return !in_interrupt() ||
+		interrupted_user_mode() ||
+		interrupted_kernel_fpu_idle();
+}
+
 static inline void kernel_fpu_begin(void)
 {
 	struct thread_info *me = current_thread_info();
+
+	WARN_ON_ONCE(!irq_fpu_usable());
 	preempt_disable();
 	if (me->status & TS_USEDFPU)
 		__save_init_fpu(me->task);
@@ -323,14 +368,6 @@ static inline void kernel_fpu_end(void)
 	preempt_enable();
 }
 
-static inline bool irq_fpu_usable(void)
-{
-	struct pt_regs *regs;
-
-	return !in_interrupt() || !(regs = get_irq_regs()) || \
-		user_mode(regs) || (read_cr0() & X86_CR0_TS);
-}
-
 /*
  * Some instructions like VIA's padlock instructions generate a spurious
  * DNA fault but don't modify SSE registers. And these instructions
@@ -367,6 +404,7 @@ static inline void irq_ts_restore(int TS_state)
  */
 static inline void save_init_fpu(struct task_struct *tsk)
 {
+	WARN_ON_ONCE(!(task_thread_info(tsk)->status & TS_USEDFPU));
 	preempt_disable();
 	__save_init_fpu(tsk);
 	stts();
-- 
1.7.9.188.g12766.dirty

