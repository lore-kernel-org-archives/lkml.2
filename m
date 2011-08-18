Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab1HRTKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:10:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47568 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab1HRTKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:10:30 -0400
Date: Thu, 18 Aug 2011 20:10:29 +0100
To: richard@nod.at
Subject: Subject: [PATCH 69/91] um: no need to play with save_sp in signal frame setup anymore
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7z3-0007xa-S0@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/x86/um/signal_32.c |   39 ++++++++-------------------------------
 arch/x86/um/signal_64.c |   33 +++++++--------------------------
 2 files changed, 15 insertions(+), 57 deletions(-)

diff --git a/arch/x86/um/signal_32.c b/arch/x86/um/signal_32.c
index 2eebdc0..7a206d8 100644
--- a/arch/x86/um/signal_32.c
+++ b/arch/x86/um/signal_32.c
@@ -215,8 +215,7 @@ static int copy_sc_from_user(struct pt_regs *regs,
 }
 
 static int copy_sc_to_user(struct sigcontext __user *to,
-			   struct _fpstate __user *to_fp, struct pt_regs *regs,
-			   unsigned long sp)
+			   struct _fpstate __user *to_fp, struct pt_regs *regs)
 {
 	struct sigcontext sc;
 	struct faultinfo * fi = &current->thread.arch.faultinfo;
@@ -230,7 +229,7 @@ static int copy_sc_to_user(struct sigcontext __user *to,
 	sc.di = REGS_EDI(regs->regs.gp);
 	sc.si = REGS_ESI(regs->regs.gp);
 	sc.bp = REGS_EBP(regs->regs.gp);
-	sc.sp = sp;
+	sc.sp = REGS_SP(regs->regs.gp);
 	sc.bx = REGS_EBX(regs->regs.gp);
 	sc.dx = REGS_EDX(regs->regs.gp);
 	sc.cx = REGS_ECX(regs->regs.gp);
@@ -291,7 +290,7 @@ static int copy_ucontext_to_user(struct ucontext __user *uc,
 	err |= put_user(current->sas_ss_sp, &uc->uc_stack.ss_sp);
 	err |= put_user(sas_ss_flags(sp), &uc->uc_stack.ss_flags);
 	err |= put_user(current->sas_ss_size, &uc->uc_stack.ss_size);
-	err |= copy_sc_to_user(&uc->uc_mcontext, fp, &current->thread.regs, sp);
+	err |= copy_sc_to_user(&uc->uc_mcontext, fp, &current->thread.regs);
 	err |= copy_to_user(&uc->uc_sigmask, set, sizeof(*set));
 	return err;
 }
@@ -324,7 +323,6 @@ int setup_signal_stack_sc(unsigned long stack_top, int sig,
 {
 	struct sigframe __user *frame;
 	void __user *restorer;
-	unsigned long save_sp = PT_REGS_SP(regs);
 	int err = 0;
 
 	/* This is the same calculation as i386 - ((sp + 4) & 15) == 0 */
@@ -337,19 +335,9 @@ int setup_signal_stack_sc(unsigned long stack_top, int sig,
 	if (ka->sa.sa_flags & SA_RESTORER)
 		restorer = ka->sa.sa_restorer;
 
-	/* Update SP now because the page fault handler refuses to extend
-	 * the stack if the faulting address is too far below the current
-	 * SP, which frame now certainly is.  If there's an error, the original
-	 * value is restored on the way out.
-	 * When writing the sigcontext to the stack, we have to write the
-	 * original value, so that's passed to copy_sc_to_user, which does
-	 * the right thing with it.
-	 */
-	PT_REGS_SP(regs) = (unsigned long) frame;
-
 	err |= __put_user(restorer, &frame->pretcode);
 	err |= __put_user(sig, &frame->sig);
-	err |= copy_sc_to_user(&frame->sc, NULL, regs, save_sp);
+	err |= copy_sc_to_user(&frame->sc, NULL, regs);
 	err |= __put_user(mask->sig[0], &frame->sc.oldmask);
 	if (_NSIG_WORDS > 1)
 		err |= __copy_to_user(&frame->extramask, &mask->sig[1],
@@ -367,7 +355,7 @@ int setup_signal_stack_sc(unsigned long stack_top, int sig,
 	err |= __put_user(0x80cd, (short __user *)(frame->retcode+6));
 
 	if (err)
-		goto err;
+		return err;
 
 	PT_REGS_SP(regs) = (unsigned long) frame;
 	PT_REGS_IP(regs) = (unsigned long) ka->sa.sa_handler;
@@ -378,10 +366,6 @@ int setup_signal_stack_sc(unsigned long stack_top, int sig,
 	if ((current->ptrace & PT_DTRACE) && (current->ptrace & PT_PTRACED))
 		ptrace_notify(SIGTRAP);
 	return 0;
-
-err:
-	PT_REGS_SP(regs) = save_sp;
-	return err;
 }
 
 int setup_signal_stack_si(unsigned long stack_top, int sig,
@@ -390,7 +374,6 @@ int setup_signal_stack_si(unsigned long stack_top, int sig,
 {
 	struct rt_sigframe __user *frame;
 	void __user *restorer;
-	unsigned long save_sp = PT_REGS_SP(regs);
 	int err = 0;
 
 	stack_top &= -8UL;
@@ -402,16 +385,13 @@ int setup_signal_stack_si(unsigned long stack_top, int sig,
 	if (ka->sa.sa_flags & SA_RESTORER)
 		restorer = ka->sa.sa_restorer;
 
-	/* See comment above about why this is here */
-	PT_REGS_SP(regs) = (unsigned long) frame;
-
 	err |= __put_user(restorer, &frame->pretcode);
 	err |= __put_user(sig, &frame->sig);
 	err |= __put_user(&frame->info, &frame->pinfo);
 	err |= __put_user(&frame->uc, &frame->puc);
 	err |= copy_siginfo_to_user(&frame->info, info);
 	err |= copy_ucontext_to_user(&frame->uc, &frame->fpstate, mask,
-				     save_sp);
+					PT_REGS_SP(regs));
 
 	/*
 	 * This is movl $,%eax ; int $0x80
@@ -425,8 +405,9 @@ int setup_signal_stack_si(unsigned long stack_top, int sig,
 	err |= __put_user(0x80cd, (short __user *)(frame->retcode+5));
 
 	if (err)
-		goto err;
+		return err;
 
+	PT_REGS_SP(regs) = (unsigned long) frame;
 	PT_REGS_IP(regs) = (unsigned long) ka->sa.sa_handler;
 	PT_REGS_EAX(regs) = (unsigned long) sig;
 	PT_REGS_EDX(regs) = (unsigned long) &frame->info;
@@ -435,10 +416,6 @@ int setup_signal_stack_si(unsigned long stack_top, int sig,
 	if ((current->ptrace & PT_DTRACE) && (current->ptrace & PT_PTRACED))
 		ptrace_notify(SIGTRAP);
 	return 0;
-
-err:
-	PT_REGS_SP(regs) = save_sp;
-	return err;
 }
 
 long sys_sigreturn(struct pt_regs regs)
diff --git a/arch/x86/um/signal_64.c b/arch/x86/um/signal_64.c
index 4e5b9b0..74c2598 100644
--- a/arch/x86/um/signal_64.c
+++ b/arch/x86/um/signal_64.c
@@ -68,7 +68,7 @@ static int copy_sc_from_user(struct pt_regs *regs,
 
 static int copy_sc_to_user(struct sigcontext __user *to,
 			   struct _fpstate __user *to_fp, struct pt_regs *regs,
-			   unsigned long mask, unsigned long sp)
+			   unsigned long mask)
 {
 	struct faultinfo * fi = &current->thread.arch.faultinfo;
 	struct sigcontext sc;
@@ -81,11 +81,7 @@ static int copy_sc_to_user(struct sigcontext __user *to,
 	PUTREG(DI, di);
 	PUTREG(SI, si);
 	PUTREG(BP, bp);
-	/*
-	 * Must use original RSP, which is passed in, rather than what's in
-	 * signal frame.
-	 */
-	sc.sp = sp;
+	PUTREG(SP, sp);
 	PUTREG(BX, bx);
 	PUTREG(DX, dx);
 	PUTREG(CX, cx);
@@ -141,7 +137,6 @@ int setup_signal_stack_si(unsigned long stack_top, int sig,
 			  siginfo_t *info, sigset_t *set)
 {
 	struct rt_sigframe __user *frame;
-	unsigned long save_sp = PT_REGS_RSP(regs);
 	int err = 0;
 	struct task_struct *me = current;
 
@@ -159,26 +154,15 @@ int setup_signal_stack_si(unsigned long stack_top, int sig,
 			goto out;
 	}
 
-	/*
-	 * Update SP now because the page fault handler refuses to extend
-	 * the stack if the faulting address is too far below the current
-	 * SP, which frame now certainly is.  If there's an error, the original
-	 * value is restored on the way out.
-	 * When writing the sigcontext to the stack, we have to write the
-	 * original value, so that's passed to copy_sc_to_user, which does
-	 * the right thing with it.
-	 */
-	PT_REGS_RSP(regs) = (unsigned long) frame;
-
 	/* Create the ucontext.  */
 	err |= __put_user(0, &frame->uc.uc_flags);
 	err |= __put_user(0, &frame->uc.uc_link);
 	err |= __put_user(me->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
-	err |= __put_user(sas_ss_flags(save_sp),
+	err |= __put_user(sas_ss_flags(PT_REGS_RSP(regs)),
 			  &frame->uc.uc_stack.ss_flags);
 	err |= __put_user(me->sas_ss_size, &frame->uc.uc_stack.ss_size);
 	err |= copy_sc_to_user(&frame->uc.uc_mcontext, &frame->fpstate, regs,
-			       set->sig[0], save_sp);
+			       set->sig[0]);
 	err |= __put_user(&frame->fpstate, &frame->uc.uc_mcontext.fpstate);
 	if (sizeof(*set) == 16) {
 		__put_user(set->sig[0], &frame->uc.uc_sigmask.sig[0]);
@@ -197,10 +181,10 @@ int setup_signal_stack_si(unsigned long stack_top, int sig,
 		err |= __put_user(ka->sa.sa_restorer, &frame->pretcode);
 	else
 		/* could use a vstub here */
-		goto restore_sp;
+		return err;
 
 	if (err)
-		goto restore_sp;
+		return err;
 
 	/* Set up registers for signal handler */
 	{
@@ -209,6 +193,7 @@ int setup_signal_stack_si(unsigned long stack_top, int sig,
 			sig = ed->signal_invmap[sig];
 	}
 
+	PT_REGS_RSP(regs) = (unsigned long) frame;
 	PT_REGS_RDI(regs) = sig;
 	/* In case the signal handler was declared without prototypes */
 	PT_REGS_RAX(regs) = 0;
@@ -222,10 +207,6 @@ int setup_signal_stack_si(unsigned long stack_top, int sig,
 	PT_REGS_RIP(regs) = (unsigned long) ka->sa.sa_handler;
  out:
 	return err;
-
-restore_sp:
-	PT_REGS_RSP(regs) = save_sp;
-	return err;
 }
 
 long sys_rt_sigreturn(struct pt_regs *regs)
-- 
1.7.2.5


