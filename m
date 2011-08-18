Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab1HRTKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:10:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47578 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab1HRTKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:10:41 -0400
Date: Thu, 18 Aug 2011 20:10:39 +0100
To: richard@nod.at
Subject: Subject: [PATCH 70/91] um: merge signal_{32,64}.c
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7zD-0007zK-TP@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/x86/um/Makefile                  |    2 +-
 arch/x86/um/asm/ptrace_64.h           |    2 +-
 arch/x86/um/{signal_32.c => signal.c} |  223 ++++++++++++++++++++++++++-----
 arch/x86/um/signal_64.c               |  236 ---------------------------------
 arch/x86/um/sys_call_table_32.S       |    2 -
 arch/x86/um/sysrq_64.c                |    2 +-
 6 files changed, 189 insertions(+), 278 deletions(-)
 rename arch/x86/um/{signal_32.c => signal.c} (72%)
 delete mode 100644 arch/x86/um/signal_64.c

diff --git a/arch/x86/um/Makefile b/arch/x86/um/Makefile
index df41989..ffe1008 100644
--- a/arch/x86/um/Makefile
+++ b/arch/x86/um/Makefile
@@ -9,7 +9,7 @@ else
 endif
 
 obj-y = bug.o bugs_$(BITS).o delay_$(BITS).o fault.o ksyms.o ldt.o \
-	ptrace_$(BITS).o ptrace_user.o setjmp_$(BITS).o signal_$(BITS).o \
+	ptrace_$(BITS).o ptrace_user.o setjmp_$(BITS).o signal.o \
 	stub_$(BITS).o stub_segv.o syscalls_$(BITS).o \
 	sys_call_table_$(BITS).o sysrq_$(BITS).o tls_$(BITS).o \
 	mem_$(BITS).o subarch.o os-$(OS)/
diff --git a/arch/x86/um/asm/ptrace_64.h b/arch/x86/um/asm/ptrace_64.h
index 83d8c47..706a0d8 100644
--- a/arch/x86/um/asm/ptrace_64.h
+++ b/arch/x86/um/asm/ptrace_64.h
@@ -40,7 +40,7 @@
 
 #define PT_REGS_ORIG_RAX(r) UPT_ORIG_RAX(&(r)->regs)
 #define PT_REGS_RIP(r) UPT_IP(&(r)->regs)
-#define PT_REGS_RSP(r) UPT_SP(&(r)->regs)
+#define PT_REGS_SP(r) UPT_SP(&(r)->regs)
 
 #define PT_REGS_EFLAGS(r) UPT_EFLAGS(&(r)->regs)
 
diff --git a/arch/x86/um/signal_32.c b/arch/x86/um/signal.c
similarity index 72%
rename from arch/x86/um/signal_32.c
rename to arch/x86/um/signal.c
index 7a206d8..4883b95 100644
--- a/arch/x86/um/signal_32.c
+++ b/arch/x86/um/signal.c
@@ -1,15 +1,21 @@
 /*
- * Copyright (C) 2004 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+ * Copyright (C) 2003 PathScale, Inc.
+ * Copyright (C) 2003 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
+
+#include <linux/personality.h>
 #include <linux/ptrace.h>
+#include <linux/kernel.h>
 #include <asm/unistd.h>
 #include <asm/uaccess.h>
 #include <asm/ucontext.h>
 #include "frame_kern.h"
 #include "skas.h"
 
+#ifdef CONFIG_X86_32
+
 /*
  * FPU tag word conversions.
  */
@@ -142,6 +148,8 @@ static int convert_fxsr_from_user(struct user_fxsr_struct *fxsave,
 
 extern int have_fpx_regs;
 
+#endif
+
 static int copy_sc_from_user(struct pt_regs *regs,
 			     struct sigcontext __user *from)
 {
@@ -152,14 +160,14 @@ static int copy_sc_from_user(struct pt_regs *regs,
 	if (err)
 		return err;
 
-	pid = userspace_pid[current_thread_info()->cpu];
-
 #define GETREG(regno, regname) regs->regs.gp[HOST_##regno] = sc.regname
 
+#ifdef CONFIG_X86_32
 	GETREG(GS, gs);
 	GETREG(FS, fs);
 	GETREG(ES, es);
 	GETREG(DS, ds);
+#endif
 	GETREG(DI, di);
 	GETREG(SI, si);
 	GETREG(BP, bp);
@@ -169,11 +177,28 @@ static int copy_sc_from_user(struct pt_regs *regs,
 	GETREG(CX, cx);
 	GETREG(AX, ax);
 	GETREG(IP, ip);
+
+#ifdef CONFIG_X86_64
+	GETREG(R8, r8);
+	GETREG(R9, r9);
+	GETREG(R10, r10);
+	GETREG(R11, r11);
+	GETREG(R12, r12);
+	GETREG(R13, r13);
+	GETREG(R14, r14);
+	GETREG(R15, r15);
+#endif
+
 	GETREG(CS, cs);
 	GETREG(EFLAGS, flags);
+#ifdef CONFIG_X86_32
 	GETREG(SS, ss);
+#endif
 
 #undef GETREG
+
+	pid = userspace_pid[current_thread_info()->cpu];
+#ifdef CONFIG_X86_32
 	if (have_fpx_regs) {
 		struct user_fxsr_struct fpx;
 
@@ -194,7 +219,9 @@ static int copy_sc_from_user(struct pt_regs *regs,
 			       -err);
 			return 1;
 		}
-	} else {
+	} else
+#endif
+	{
 		struct user_i387_struct fp;
 
 		err = copy_from_user(&fp, sc.fpstate,
@@ -210,43 +237,66 @@ static int copy_sc_from_user(struct pt_regs *regs,
 			return 1;
 		}
 	}
-
 	return 0;
 }
 
 static int copy_sc_to_user(struct sigcontext __user *to,
-			   struct _fpstate __user *to_fp, struct pt_regs *regs)
+			   struct _fpstate __user *to_fp, struct pt_regs *regs,
+			   unsigned long mask)
 {
 	struct sigcontext sc;
 	struct faultinfo * fi = &current->thread.arch.faultinfo;
 	int err, pid;
 	memset(&sc, 0, sizeof(struct sigcontext));
 
-	sc.gs = REGS_GS(regs->regs.gp);
-	sc.fs = REGS_FS(regs->regs.gp);
-	sc.es = REGS_ES(regs->regs.gp);
-	sc.ds = REGS_DS(regs->regs.gp);
-	sc.di = REGS_EDI(regs->regs.gp);
-	sc.si = REGS_ESI(regs->regs.gp);
-	sc.bp = REGS_EBP(regs->regs.gp);
-	sc.sp = REGS_SP(regs->regs.gp);
-	sc.bx = REGS_EBX(regs->regs.gp);
-	sc.dx = REGS_EDX(regs->regs.gp);
-	sc.cx = REGS_ECX(regs->regs.gp);
-	sc.ax = REGS_EAX(regs->regs.gp);
-	sc.ip = REGS_IP(regs->regs.gp);
-	sc.cs = REGS_CS(regs->regs.gp);
-	sc.flags = REGS_EFLAGS(regs->regs.gp);
-	sc.sp_at_signal = regs->regs.gp[UESP];
-	sc.ss = regs->regs.gp[SS];
+#define PUTREG(regno, regname) sc.regname = regs->regs.gp[HOST_##regno]
+
+#ifdef CONFIG_X86_32
+	PUTREG(GS, gs);
+	PUTREG(FS, fs);
+	PUTREG(ES, es);
+	PUTREG(DS, ds);
+#endif
+	PUTREG(DI, di);
+	PUTREG(SI, si);
+	PUTREG(BP, bp);
+	PUTREG(SP, sp);
+	PUTREG(BX, bx);
+	PUTREG(DX, dx);
+	PUTREG(CX, cx);
+	PUTREG(AX, ax);
+#ifdef CONFIG_X86_64
+	PUTREG(R8, r8);
+	PUTREG(R9, r9);
+	PUTREG(R10, r10);
+	PUTREG(R11, r11);
+	PUTREG(R12, r12);
+	PUTREG(R13, r13);
+	PUTREG(R14, r14);
+	PUTREG(R15, r15);
+#endif
+
 	sc.cr2 = fi->cr2;
 	sc.err = fi->error_code;
 	sc.trapno = fi->trap_no;
-
-	to_fp = (to_fp ? to_fp : (struct _fpstate __user *) (to + 1));
+	PUTREG(IP, ip);
+	PUTREG(CS, cs);
+	PUTREG(EFLAGS, flags);
+#ifdef CONFIG_X86_32
+	PUTREG(SP, sp_at_signal);
+	PUTREG(SS, ss);
+#endif
+#undef PUTREG
+	sc.oldmask = mask;
 	sc.fpstate = to_fp;
 
+	err = copy_to_user(to, &sc, sizeof(struct sigcontext));
+	if (err)
+		return 1;
+
 	pid = userspace_pid[current_thread_info()->cpu];
+
+#ifdef CONFIG_X86_32
 	if (have_fpx_regs) {
 		struct user_fxsr_struct fpx;
 
@@ -269,8 +319,9 @@ static int copy_sc_to_user(struct sigcontext __user *to,
 		if (copy_to_user(&to_fp->_fxsr_env[0], &fpx,
 				 sizeof(struct user_fxsr_struct)))
 			return 1;
-	}
-	else {
+	} else
+#endif
+	{
 		struct user_i387_struct fp;
 
 		err = save_fp_registers(pid, (unsigned long *) &fp);
@@ -278,9 +329,10 @@ static int copy_sc_to_user(struct sigcontext __user *to,
 			return 1;
 	}
 
-	return copy_to_user(to, &sc, sizeof(sc));
+	return 0;
 }
 
+#ifdef CONFIG_X86_32
 static int copy_ucontext_to_user(struct ucontext __user *uc,
 				 struct _fpstate __user *fp, sigset_t *set,
 				 unsigned long sp)
@@ -290,7 +342,7 @@ static int copy_ucontext_to_user(struct ucontext __user *uc,
 	err |= put_user(current->sas_ss_sp, &uc->uc_stack.ss_sp);
 	err |= put_user(sas_ss_flags(sp), &uc->uc_stack.ss_flags);
 	err |= put_user(current->sas_ss_size, &uc->uc_stack.ss_size);
-	err |= copy_sc_to_user(&uc->uc_mcontext, fp, &current->thread.regs);
+	err |= copy_sc_to_user(&uc->uc_mcontext, fp, &current->thread.regs, 0);
 	err |= copy_to_user(&uc->uc_sigmask, set, sizeof(*set));
 	return err;
 }
@@ -337,8 +389,7 @@ int setup_signal_stack_sc(unsigned long stack_top, int sig,
 
 	err |= __put_user(restorer, &frame->pretcode);
 	err |= __put_user(sig, &frame->sig);
-	err |= copy_sc_to_user(&frame->sc, NULL, regs);
-	err |= __put_user(mask->sig[0], &frame->sc.oldmask);
+	err |= copy_sc_to_user(&frame->sc, &frame->fpstate, regs, mask->sig[0]);
 	if (_NSIG_WORDS > 1)
 		err |= __copy_to_user(&frame->extramask, &mask->sig[1],
 				      sizeof(frame->extramask));
@@ -418,7 +469,7 @@ int setup_signal_stack_si(unsigned long stack_top, int sig,
 	return 0;
 }
 
-long sys_sigreturn(struct pt_regs regs)
+long sys_sigreturn(struct pt_regs *regs)
 {
 	unsigned long sp = PT_REGS_SP(&current->thread.regs);
 	struct sigframe __user *frame = (struct sigframe __user *)(sp - 8);
@@ -447,16 +498,103 @@ long sys_sigreturn(struct pt_regs regs)
 	return 0;
 }
 
-long sys_rt_sigreturn(struct pt_regs regs)
+#else
+
+struct rt_sigframe
+{
+	char __user *pretcode;
+	struct ucontext uc;
+	struct siginfo info;
+	struct _fpstate fpstate;
+};
+
+int setup_signal_stack_si(unsigned long stack_top, int sig,
+			  struct k_sigaction *ka, struct pt_regs * regs,
+			  siginfo_t *info, sigset_t *set)
+{
+	struct rt_sigframe __user *frame;
+	int err = 0;
+	struct task_struct *me = current;
+
+	frame = (struct rt_sigframe __user *)
+		round_down(stack_top - sizeof(struct rt_sigframe), 16);
+	/* Subtract 128 for a red zone and 8 for proper alignment */
+	frame = (struct rt_sigframe __user *) ((unsigned long) frame - 128 - 8);
+
+	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
+		goto out;
+
+	if (ka->sa.sa_flags & SA_SIGINFO) {
+		err |= copy_siginfo_to_user(&frame->info, info);
+		if (err)
+			goto out;
+	}
+
+	/* Create the ucontext.  */
+	err |= __put_user(0, &frame->uc.uc_flags);
+	err |= __put_user(0, &frame->uc.uc_link);
+	err |= __put_user(me->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
+	err |= __put_user(sas_ss_flags(PT_REGS_SP(regs)),
+			  &frame->uc.uc_stack.ss_flags);
+	err |= __put_user(me->sas_ss_size, &frame->uc.uc_stack.ss_size);
+	err |= copy_sc_to_user(&frame->uc.uc_mcontext, &frame->fpstate, regs,
+			       set->sig[0]);
+	err |= __put_user(&frame->fpstate, &frame->uc.uc_mcontext.fpstate);
+	if (sizeof(*set) == 16) {
+		__put_user(set->sig[0], &frame->uc.uc_sigmask.sig[0]);
+		__put_user(set->sig[1], &frame->uc.uc_sigmask.sig[1]);
+	}
+	else
+		err |= __copy_to_user(&frame->uc.uc_sigmask, set,
+				      sizeof(*set));
+
+	/*
+	 * Set up to return from userspace.  If provided, use a stub
+	 * already in userspace.
+	 */
+	/* x86-64 should always use SA_RESTORER. */
+	if (ka->sa.sa_flags & SA_RESTORER)
+		err |= __put_user(ka->sa.sa_restorer, &frame->pretcode);
+	else
+		/* could use a vstub here */
+		return err;
+
+	if (err)
+		return err;
+
+	/* Set up registers for signal handler */
+	{
+		struct exec_domain *ed = current_thread_info()->exec_domain;
+		if (unlikely(ed && ed->signal_invmap && sig < 32))
+			sig = ed->signal_invmap[sig];
+	}
+
+	PT_REGS_SP(regs) = (unsigned long) frame;
+	PT_REGS_RDI(regs) = sig;
+	/* In case the signal handler was declared without prototypes */
+	PT_REGS_RAX(regs) = 0;
+
+	/*
+	 * This also works for non SA_SIGINFO handlers because they expect the
+	 * next argument after the signal number on the stack.
+	 */
+	PT_REGS_RSI(regs) = (unsigned long) &frame->info;
+	PT_REGS_RDX(regs) = (unsigned long) &frame->uc;
+	PT_REGS_RIP(regs) = (unsigned long) ka->sa.sa_handler;
+ out:
+	return err;
+}
+#endif
+
+long sys_rt_sigreturn(struct pt_regs *regs)
 {
 	unsigned long sp = PT_REGS_SP(&current->thread.regs);
 	struct rt_sigframe __user *frame =
-		(struct rt_sigframe __user *) (sp - 4);
-	sigset_t set;
+		(struct rt_sigframe __user *)(sp - sizeof(long));
 	struct ucontext __user *uc = &frame->uc;
-	int sig_size = _NSIG_WORDS * sizeof(unsigned long);
+	sigset_t set;
 
-	if (copy_from_user(&set, &uc->uc_sigmask, sig_size))
+	if (copy_from_user(&set, &uc->uc_sigmask, sizeof(set)))
 		goto segfault;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
@@ -473,3 +611,14 @@ long sys_rt_sigreturn(struct pt_regs regs)
 	force_sig(SIGSEGV, current);
 	return 0;
 }
+
+#ifdef CONFIG_X86_32
+long ptregs_sigreturn(void)
+{
+	return sys_sigreturn(NULL);
+}
+long ptregs_rt_sigreturn(void)
+{
+	return sys_rt_sigreturn(NULL);
+}
+#endif
diff --git a/arch/x86/um/signal_64.c b/arch/x86/um/signal_64.c
deleted file mode 100644
index 74c2598..0000000
--- a/arch/x86/um/signal_64.c
+++ /dev/null
@@ -1,236 +0,0 @@
-/*
- * Copyright (C) 2003 PathScale, Inc.
- * Copyright (C) 2003 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
- * Licensed under the GPL
- */
-
-#include <linux/personality.h>
-#include <linux/ptrace.h>
-#include <linux/kernel.h>
-#include <asm/unistd.h>
-#include <asm/uaccess.h>
-#include <asm/ucontext.h>
-#include "frame_kern.h"
-#include "skas.h"
-
-static int copy_sc_from_user(struct pt_regs *regs,
-			     struct sigcontext __user *from)
-{
-	struct sigcontext sc;
-	struct user_i387_struct fp;
-	void __user *buf;
-	int err;
-
-	err = copy_from_user(&sc, from, sizeof(sc));
-	if (err)
-		return err;
-
-#define GETREG(regno, regname) regs->regs.gp[HOST_##regno] = sc.regname
-
-	GETREG(R8, r8);
-	GETREG(R9, r9);
-	GETREG(R10, r10);
-	GETREG(R11, r11);
-	GETREG(R12, r12);
-	GETREG(R13, r13);
-	GETREG(R14, r14);
-	GETREG(R15, r15);
-	GETREG(DI, di);
-	GETREG(SI, si);
-	GETREG(BP, bp);
-	GETREG(BX, bx);
-	GETREG(DX, dx);
-	GETREG(AX, ax);
-	GETREG(CX, cx);
-	GETREG(SP, sp);
-	GETREG(IP, ip);
-	GETREG(EFLAGS, flags);
-	GETREG(CS, cs);
-#undef GETREG
-
-	buf = sc.fpstate;
-
-	err = copy_from_user(&fp, buf, sizeof(struct user_i387_struct));
-	if (err)
-		return 1;
-
-	err = restore_fp_registers(userspace_pid[current_thread_info()->cpu],
-				   (unsigned long *) &fp);
-	if (err < 0) {
-		printk(KERN_ERR "copy_sc_from_user - "
-		       "restore_fp_registers failed, errno = %d\n",
-		       -err);
-		return 1;
-	}
-
-	return 0;
-}
-
-static int copy_sc_to_user(struct sigcontext __user *to,
-			   struct _fpstate __user *to_fp, struct pt_regs *regs,
-			   unsigned long mask)
-{
-	struct faultinfo * fi = &current->thread.arch.faultinfo;
-	struct sigcontext sc;
-	struct user_i387_struct fp;
-	int err = 0;
-	memset(&sc, 0, sizeof(struct sigcontext));
-
-#define PUTREG(regno, regname) sc.regname = regs->regs.gp[HOST_##regno]
-
-	PUTREG(DI, di);
-	PUTREG(SI, si);
-	PUTREG(BP, bp);
-	PUTREG(SP, sp);
-	PUTREG(BX, bx);
-	PUTREG(DX, dx);
-	PUTREG(CX, cx);
-	PUTREG(AX, ax);
-	PUTREG(R8, r8);
-	PUTREG(R9, r9);
-	PUTREG(R10, r10);
-	PUTREG(R11, r11);
-	PUTREG(R12, r12);
-	PUTREG(R13, r13);
-	PUTREG(R14, r14);
-	PUTREG(R15, r15);
-	PUTREG(CS, cs); /* XXX x86_64 doesn't do this */
-
-	sc.cr2 = fi->cr2;
-	sc.err = fi->error_code;
-	sc.trapno = fi->trap_no;
-
-	PUTREG(IP, ip);
-	PUTREG(EFLAGS, flags);
-#undef PUTREG
-
-	sc.oldmask = mask;
-
-	err = copy_to_user(to, &sc, sizeof(struct sigcontext));
-	if (err)
-		return 1;
-
-	err = save_fp_registers(userspace_pid[current_thread_info()->cpu],
-				(unsigned long *) &fp);
-	if (err < 0) {
-		printk(KERN_ERR "copy_sc_from_user - restore_fp_registers "
-		       "failed, errno = %d\n", -err);
-		return 1;
-	}
-
-	if (copy_to_user(to_fp, &fp, sizeof(struct user_i387_struct)))
-		return 1;
-
-	return err;
-}
-
-struct rt_sigframe
-{
-	char __user *pretcode;
-	struct ucontext uc;
-	struct siginfo info;
-	struct _fpstate fpstate;
-};
-
-int setup_signal_stack_si(unsigned long stack_top, int sig,
-			  struct k_sigaction *ka, struct pt_regs * regs,
-			  siginfo_t *info, sigset_t *set)
-{
-	struct rt_sigframe __user *frame;
-	int err = 0;
-	struct task_struct *me = current;
-
-	frame = (struct rt_sigframe __user *)
-		round_down(stack_top - sizeof(struct rt_sigframe), 16);
-	/* Subtract 128 for a red zone and 8 for proper alignment */
-	frame = (struct rt_sigframe __user *) ((unsigned long) frame - 128 - 8);
-
-	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto out;
-
-	if (ka->sa.sa_flags & SA_SIGINFO) {
-		err |= copy_siginfo_to_user(&frame->info, info);
-		if (err)
-			goto out;
-	}
-
-	/* Create the ucontext.  */
-	err |= __put_user(0, &frame->uc.uc_flags);
-	err |= __put_user(0, &frame->uc.uc_link);
-	err |= __put_user(me->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
-	err |= __put_user(sas_ss_flags(PT_REGS_RSP(regs)),
-			  &frame->uc.uc_stack.ss_flags);
-	err |= __put_user(me->sas_ss_size, &frame->uc.uc_stack.ss_size);
-	err |= copy_sc_to_user(&frame->uc.uc_mcontext, &frame->fpstate, regs,
-			       set->sig[0]);
-	err |= __put_user(&frame->fpstate, &frame->uc.uc_mcontext.fpstate);
-	if (sizeof(*set) == 16) {
-		__put_user(set->sig[0], &frame->uc.uc_sigmask.sig[0]);
-		__put_user(set->sig[1], &frame->uc.uc_sigmask.sig[1]);
-	}
-	else
-		err |= __copy_to_user(&frame->uc.uc_sigmask, set,
-				      sizeof(*set));
-
-	/*
-	 * Set up to return from userspace.  If provided, use a stub
-	 * already in userspace.
-	 */
-	/* x86-64 should always use SA_RESTORER. */
-	if (ka->sa.sa_flags & SA_RESTORER)
-		err |= __put_user(ka->sa.sa_restorer, &frame->pretcode);
-	else
-		/* could use a vstub here */
-		return err;
-
-	if (err)
-		return err;
-
-	/* Set up registers for signal handler */
-	{
-		struct exec_domain *ed = current_thread_info()->exec_domain;
-		if (unlikely(ed && ed->signal_invmap && sig < 32))
-			sig = ed->signal_invmap[sig];
-	}
-
-	PT_REGS_RSP(regs) = (unsigned long) frame;
-	PT_REGS_RDI(regs) = sig;
-	/* In case the signal handler was declared without prototypes */
-	PT_REGS_RAX(regs) = 0;
-
-	/*
-	 * This also works for non SA_SIGINFO handlers because they expect the
-	 * next argument after the signal number on the stack.
-	 */
-	PT_REGS_RSI(regs) = (unsigned long) &frame->info;
-	PT_REGS_RDX(regs) = (unsigned long) &frame->uc;
-	PT_REGS_RIP(regs) = (unsigned long) ka->sa.sa_handler;
- out:
-	return err;
-}
-
-long sys_rt_sigreturn(struct pt_regs *regs)
-{
-	unsigned long sp = PT_REGS_SP(&current->thread.regs);
-	struct rt_sigframe __user *frame =
-		(struct rt_sigframe __user *)(sp - 8);
-	struct ucontext __user *uc = &frame->uc;
-	sigset_t set;
-
-	if (copy_from_user(&set, &uc->uc_sigmask, sizeof(set)))
-		goto segfault;
-
-	sigdelsetmask(&set, ~_BLOCKABLE);
-	set_current_blocked(&set);
-
-	if (copy_sc_from_user(&current->thread.regs, &uc->uc_mcontext))
-		goto segfault;
-
-	/* Avoid ERESTART handling */
-	PT_REGS_SYSCALL_NR(&current->thread.regs) = -1;
-	return PT_REGS_SYSCALL_RET(&current->thread.regs);
-
- segfault:
-	force_sig(SIGSEGV, current);
-	return 0;
-}
diff --git a/arch/x86/um/sys_call_table_32.S b/arch/x86/um/sys_call_table_32.S
index c3431cf..a7ca80d 100644
--- a/arch/x86/um/sys_call_table_32.S
+++ b/arch/x86/um/sys_call_table_32.S
@@ -13,10 +13,8 @@
 #define ptregs_execve sys_execve
 #define ptregs_iopl sys_iopl
 #define ptregs_vm86old sys_vm86old
-#define ptregs_sigreturn sys_sigreturn
 #define ptregs_clone sys_clone
 #define ptregs_vm86 sys_vm86
-#define ptregs_rt_sigreturn sys_rt_sigreturn
 #define ptregs_sigaltstack sys_sigaltstack
 #define ptregs_vfork sys_vfork
 
diff --git a/arch/x86/um/sysrq_64.c b/arch/x86/um/sysrq_64.c
index f4f82be..e891343 100644
--- a/arch/x86/um/sysrq_64.c
+++ b/arch/x86/um/sysrq_64.c
@@ -20,7 +20,7 @@ void __show_regs(struct pt_regs *regs)
 		current->comm, print_tainted(), init_utsname()->release);
 	printk(KERN_INFO "RIP: %04lx:[<%016lx>]\n", PT_REGS_CS(regs) & 0xffff,
 	       PT_REGS_RIP(regs));
-	printk(KERN_INFO "RSP: %016lx  EFLAGS: %08lx\n", PT_REGS_RSP(regs),
+	printk(KERN_INFO "RSP: %016lx  EFLAGS: %08lx\n", PT_REGS_SP(regs),
 	       PT_REGS_EFLAGS(regs));
 	printk(KERN_INFO "RAX: %016lx RBX: %016lx RCX: %016lx\n",
 	       PT_REGS_RAX(regs), PT_REGS_RBX(regs), PT_REGS_RCX(regs));
-- 
1.7.2.5


