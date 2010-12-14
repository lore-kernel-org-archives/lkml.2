Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117Ab0LNVQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:16:27 -0500
Received: from 206.83.70.71.ptr.us.xo.net ([206.83.70.71]:55630 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760007Ab0LNVQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:16:24 -0500
Message-Id: <201012142116.oBELGNRF026232@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 14 Dec 2010 16:07:25 -0500
Subject: [PATCH] arch/tile: handle rt_sigreturn() more cleanly
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 14 Dec 2010 21:16:23.0895 (UTC) FILETIME=[29543E70:01CB9BD4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current tile rt_sigreturn() syscall pattern uses the common idiom
of loading up pt_regs with all the saved registers from the time of
the signal, then anticipating the fact that we will clobber the ABI
"return value" register (r0) as we return from the syscall by setting
the rt_sigreturn return value to whatever random value was in the pt_regs
for r0.

However, this breaks in our 64-bit kernel when running "compat" tasks,
since we always sign-extend the "return value" register to properly
handle returned pointers that are in the upper 2GB of the 32-bit compat
address space.  Doing this to the sigreturn path then causes occasional
random corruption of the 64-bit r0 register.

Instead, we stop doing the crazy "load the return-value register"
hack in sigreturn.  We already have some sigreturn-specific assembly
code that we use to pass the pt_regs pointer to C code.  We extend that
code to also set the link register to point to a spot a few instructions
after the usual syscall return address so we don't clobber the saved r0.
Now it no longer matters what the rt_sigreturn syscall returns, and the
pt_regs structure can be cleanly and completely reloaded.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/signal.h   |    2 +-
 arch/tile/kernel/compat_signal.c |    6 +++---
 arch/tile/kernel/intvec_32.S     |   24 +++++++++++++++++++++---
 arch/tile/kernel/signal.c        |   10 ++++------
 4 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/arch/tile/include/asm/signal.h b/arch/tile/include/asm/signal.h
index c1ee1d6..81d92a4 100644
--- a/arch/tile/include/asm/signal.h
+++ b/arch/tile/include/asm/signal.h
@@ -25,7 +25,7 @@
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 struct pt_regs;
-int restore_sigcontext(struct pt_regs *, struct sigcontext __user *, long *);
+int restore_sigcontext(struct pt_regs *, struct sigcontext __user *);
 int setup_sigcontext(struct sigcontext __user *, struct pt_regs *);
 void do_signal(struct pt_regs *regs);
 #endif
diff --git a/arch/tile/kernel/compat_signal.c b/arch/tile/kernel/compat_signal.c
index 543d6a3..dbb0dfc 100644
--- a/arch/tile/kernel/compat_signal.c
+++ b/arch/tile/kernel/compat_signal.c
@@ -290,12 +290,12 @@ long compat_sys_sigaltstack(const struct compat_sigaltstack __user *uss_ptr,
 	return ret;
 }
 
+/* The assembly shim for this function arranges to ignore the return value. */
 long compat_sys_rt_sigreturn(struct pt_regs *regs)
 {
 	struct compat_rt_sigframe __user *frame =
 		(struct compat_rt_sigframe __user *) compat_ptr(regs->sp);
 	sigset_t set;
-	long r0;
 
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
@@ -308,13 +308,13 @@ long compat_sys_rt_sigreturn(struct pt_regs *regs)
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 
-	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &r0))
+	if (restore_sigcontext(regs, &frame->uc.uc_mcontext))
 		goto badframe;
 
 	if (compat_sys_sigaltstack(&frame->uc.uc_stack, NULL, regs) != 0)
 		goto badframe;
 
-	return r0;
+	return 0;
 
 badframe:
 	force_sig(SIGSEGV, current);
diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index f582162..5eed4a0 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -1342,8 +1342,8 @@ handle_syscall:
 	lw      r20, r20
 
 	/* Jump to syscall handler. */
-	jalr    r20; .Lhandle_syscall_link:
-	FEEDBACK_REENTER(handle_syscall)
+	jalr    r20
+.Lhandle_syscall_link: /* value of "lr" after "jalr r20" above */
 
 	/*
 	 * Write our r0 onto the stack so it gets restored instead
@@ -1352,6 +1352,9 @@ handle_syscall:
 	PTREGS_PTR(r29, PTREGS_OFFSET_REG(0))
 	sw      r29, r0
 
+.Lsyscall_sigreturn_skip:
+	FEEDBACK_REENTER(handle_syscall)
+
 	/* Do syscall trace again, if requested. */
 	lw	r30, r31
 	andi    r30, r30, _TIF_SYSCALL_TRACE
@@ -1536,9 +1539,24 @@ STD_ENTRY_LOCAL(bad_intr)
 	};                                              \
 	STD_ENDPROC(_##x)
 
+/*
+ * Special-case sigreturn to not write r0 to the stack on return.
+ * This is technically more efficient, but it also avoids difficulties
+ * in the 64-bit OS when handling 32-bit compat code, since we must not
+ * sign-extend r0 for the sigreturn return-value case.
+ */
+#define PTREGS_SYSCALL_SIGRETURN(x, reg)                \
+	STD_ENTRY(_##x);                                \
+	addli   lr, lr, .Lsyscall_sigreturn_skip - .Lhandle_syscall_link; \
+	{                                               \
+	 PTREGS_PTR(reg, PTREGS_OFFSET_BASE);           \
+	 j      x                                       \
+	};                                              \
+	STD_ENDPROC(_##x)
+
 PTREGS_SYSCALL(sys_execve, r3)
 PTREGS_SYSCALL(sys_sigaltstack, r2)
-PTREGS_SYSCALL(sys_rt_sigreturn, r0)
+PTREGS_SYSCALL_SIGRETURN(sys_rt_sigreturn, r0)
 PTREGS_SYSCALL(sys_cmpxchg_badaddr, r1)
 
 /* Save additional callee-saves to pt_regs, put address in r4 and jump. */
diff --git a/arch/tile/kernel/signal.c b/arch/tile/kernel/signal.c
index 757407e..1260321 100644
--- a/arch/tile/kernel/signal.c
+++ b/arch/tile/kernel/signal.c
@@ -52,7 +52,7 @@ SYSCALL_DEFINE3(sigaltstack, const stack_t __user *, uss,
  */
 
 int restore_sigcontext(struct pt_regs *regs,
-		       struct sigcontext __user *sc, long *pr0)
+		       struct sigcontext __user *sc)
 {
 	int err = 0;
 	int i;
@@ -75,17 +75,15 @@ int restore_sigcontext(struct pt_regs *regs,
 
 	regs->faultnum = INT_SWINT_1_SIGRETURN;
 
-	err |= __get_user(*pr0, &sc->gregs[0]);
 	return err;
 }
 
-/* sigreturn() returns long since it restores r0 in the interrupted code. */
+/* The assembly shim for this function arranges to ignore the return value. */
 SYSCALL_DEFINE1(rt_sigreturn, struct pt_regs *, regs)
 {
 	struct rt_sigframe __user *frame =
 		(struct rt_sigframe __user *)(regs->sp);
 	sigset_t set;
-	long r0;
 
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
@@ -98,13 +96,13 @@ SYSCALL_DEFINE1(rt_sigreturn, struct pt_regs *, regs)
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 
-	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &r0))
+	if (restore_sigcontext(regs, &frame->uc.uc_mcontext))
 		goto badframe;
 
 	if (do_sigaltstack(&frame->uc.uc_stack, NULL, regs->sp) == -EFAULT)
 		goto badframe;
 
-	return r0;
+	return 0;
 
 badframe:
 	force_sig(SIGSEGV, current);
-- 
1.6.5.2

