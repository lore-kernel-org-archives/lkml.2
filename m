Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab1FSLpZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 07:45:25 -0400
Received: from mail.southpole.se ([193.12.106.18]:37741 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab1FSLpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 07:45:09 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 04/19] OpenRISC: Signal handling
Date: Sun, 19 Jun 2011 13:43:30 +0200
Message-Id: <1308483825-6023-5-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308483825-6023-1-git-send-email-jonas@southpole.se>
References: <1308483825-6023-1-git-send-email-jonas@southpole.se>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/openrisc/include/asm/sigcontext.h |   38 +++
 arch/openrisc/kernel/signal.c          |  410 ++++++++++++++++++++++++++++++++
 2 files changed, 448 insertions(+), 0 deletions(-)
 create mode 100644 arch/openrisc/include/asm/sigcontext.h
 create mode 100644 arch/openrisc/kernel/signal.c

diff --git a/arch/openrisc/include/asm/sigcontext.h b/arch/openrisc/include/asm/sigcontext.h
new file mode 100644
index 0000000..54a5c50
--- /dev/null
+++ b/arch/openrisc/include/asm/sigcontext.h
@@ -0,0 +1,38 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_SIGCONTEXT_H
+#define __ASM_OPENRISC_SIGCONTEXT_H
+
+#include <asm/ptrace.h>
+
+/* This struct is saved by setup_frame in signal.c, to keep the current
+   context while a signal handler is executed. It's restored by sys_sigreturn.
+
+   To keep things simple, we use pt_regs here even though normally you just
+   specify the list of regs to save. Then we can use copy_from_user on the
+   entire regs instead of a bunch of get_user's as well...
+*/
+
+struct sigcontext {
+	struct pt_regs regs;  /* needs to be first */
+	unsigned long oldmask;
+	unsigned long usp;    /* usp before stacking this gunk on it */
+};
+
+#endif /* __ASM_OPENRISC_SIGCONTEXT_H */
diff --git a/arch/openrisc/kernel/signal.c b/arch/openrisc/kernel/signal.c
new file mode 100644
index 0000000..f34c703
--- /dev/null
+++ b/arch/openrisc/kernel/signal.c
@@ -0,0 +1,410 @@
+/*
+ * OpenRISC signal.c
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * Modifications for the OpenRISC architecture:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/kernel.h>
+#include <linux/signal.h>
+#include <linux/errno.h>
+#include <linux/wait.h>
+#include <linux/ptrace.h>
+#include <linux/unistd.h>
+#include <linux/stddef.h>
+#include <linux/tracehook.h>
+
+#include <asm/processor.h>
+#include <asm/ucontext.h>
+#include <asm/uaccess.h>
+
+#include "ptrace.h"
+
+#define DEBUG_SIG 0
+
+#define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
+
+asmlinkage long
+_sys_sigaltstack(const stack_t *uss, stack_t *uoss, struct pt_regs *regs)
+{
+	return do_sigaltstack(uss, uoss, regs->sp);
+}
+
+struct rt_sigframe {
+	struct siginfo *pinfo;
+	void *puc;
+	struct siginfo info;
+	struct ucontext uc;
+	unsigned char retcode[16];  /* trampoline code */
+};
+
+
+static int restore_sigcontext(struct pt_regs *regs, struct sigcontext *sc)
+{
+	unsigned int err = 0;
+	unsigned long old_usp;
+
+	/* Alwys make any pending restarted system call return -EINTR */
+	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+
+	/* restore the regs from &sc->regs (same as sc, since regs is first)
+	 * (sc is already checked for VERIFY_READ since the sigframe was
+	 *  checked in sys_sigreturn previously)
+	 */
+
+	if (__copy_from_user(regs, sc, sizeof(struct pt_regs)))
+                goto badframe;
+
+	/* make sure the SM-bit is cleared so user-mode cannot fool us */
+	regs->sr &= ~SPR_SR_SM;
+
+	/* restore the old USP as it was before we stacked the sc etc.
+	 * (we cannot just pop the sigcontext since we aligned the sp and
+	 *  stuff after pushing it)
+	 */
+
+	err |= __get_user(old_usp, &sc->usp);
+
+	regs->sp = old_usp;
+
+	/* TODO: the other ports use regs->orig_XX to disable syscall checks
+	 * after this completes, but we don't use that mechanism. maybe we can
+	 * use it now ?
+	 */
+
+	return err;
+
+badframe:
+	return 1;
+}
+
+asmlinkage long
+_sys_rt_sigreturn(struct pt_regs *regs)
+{
+	struct rt_sigframe *frame = (struct rt_sigframe __user *)regs->sp;
+	sigset_t set;
+	stack_t st;
+
+        /*
+         * Since we stacked the signal on a dword boundary,
+         * then frame should be dword aligned here.  If it's
+         * not, then the user is trying to mess with us.
+         */
+        if (((long)frame) & 3)
+                goto badframe;
+
+	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
+		goto badframe;
+	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
+		goto badframe;
+
+	sigdelsetmask(&set, ~_BLOCKABLE);
+	spin_lock_irq(&current->sighand->siglock);
+	current->blocked = set;
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+
+	if (restore_sigcontext(regs, &frame->uc.uc_mcontext))
+		goto badframe;
+
+	if (__copy_from_user(&st, &frame->uc.uc_stack, sizeof(st)))
+		goto badframe;
+	/* It is more difficult to avoid calling this function than to
+	   call it and ignore errors.  */
+	do_sigaltstack(&st, NULL, regs->sp);
+
+	single_step_trap(current);
+
+	return regs->gpr[11];
+
+badframe:
+	force_sig(SIGSEGV, current);
+	return 0;
+}
+
+/*
+ * Set up a signal frame.
+ */
+
+static int setup_sigcontext(struct sigcontext *sc, struct pt_regs *regs,
+			    unsigned long mask)
+{
+	int err = 0;
+	unsigned long usp = regs->sp;
+
+	/* copy the regs. they are first in sc so we can use sc directly */
+
+	err |= __copy_to_user(sc, regs, sizeof(struct pt_regs));
+
+	/* then some other stuff */
+
+	err |= __put_user(mask, &sc->oldmask);
+
+	err |= __put_user(usp, &sc->usp);
+
+	return err;
+}
+
+static inline unsigned long
+align_sigframe(unsigned long sp)
+{
+	return (sp & ~3UL);
+}
+
+/*
+ * Work out where the signal frame should go.  It's either on the user stack
+ * or the alternate stack.
+ */
+
+static inline void __user *
+get_sigframe(struct k_sigaction *ka, struct pt_regs * regs, size_t frame_size)
+{
+	unsigned long sp = regs->sp;
+	int onsigstack = on_sig_stack(sp);
+
+	/* redzone */
+	sp -= STACK_FRAME_OVERHEAD;
+
+	/* This is the X/Open sanctioned signal stack switching.  */
+	if ((ka->sa.sa_flags & SA_ONSTACK) && !onsigstack) {
+		if (current->sas_ss_size)
+			sp = current->sas_ss_sp + current->sas_ss_size;
+	}
+
+	sp = align_sigframe(sp - frame_size);
+
+	/*
+	 * If we are on the alternate signal stack and would overflow it, don't.
+	 * Return an always-bogus address instead so we will die with SIGSEGV.
+	 */
+	if (onsigstack && !likely(on_sig_stack(sp)))
+		return (void __user *)-1L;
+
+	return (void __user *)sp;
+}
+
+/* grab and setup a signal frame.
+ *
+ * basically we stack a lot of state info, and arrange for the
+ * user-mode program to return to the kernel using either a
+ * trampoline which performs the syscall sigreturn, or a provided
+ * user-mode trampoline.
+ */
+static void setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+			   sigset_t *set, struct pt_regs * regs)
+{
+	struct rt_sigframe *frame;
+	unsigned long return_ip;
+	int err = 0;
+
+	frame = get_sigframe(ka, regs, sizeof(*frame));
+
+	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
+		goto give_sigsegv;
+
+	err |= __put_user(&frame->info, &frame->pinfo);
+	err |= __put_user(&frame->uc, &frame->puc);
+
+	if (ka->sa.sa_flags & SA_SIGINFO)
+		err |= copy_siginfo_to_user(&frame->info, info);
+	if (err)
+		goto give_sigsegv;
+
+	/* Clear all the bits of the ucontext we don't use.  */
+        err |= __clear_user(&frame->uc, offsetof(struct ucontext, uc_mcontext));
+        err |= __put_user(0, &frame->uc.uc_flags);
+        err |= __put_user(NULL, &frame->uc.uc_link);
+        err |= __put_user((void *)current->sas_ss_sp,
+                        &frame->uc.uc_stack.ss_sp);
+        err |= __put_user(sas_ss_flags(regs->sp),
+                        &frame->uc.uc_stack.ss_flags);
+        err |= __put_user(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
+	err |= setup_sigcontext(&frame->uc.uc_mcontext, regs, set->sig[0]);
+
+	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
+
+	if (err)
+		goto give_sigsegv;
+
+	/* trampoline - the desired return ip is the retcode itself */
+	return_ip = (unsigned long)&frame->retcode;
+	/* This is l.ori r11,r0,__NR_sigreturn, l.sys 1 */
+	err |= __put_user(0xa960        , (short *)(frame->retcode+0));
+	err |= __put_user(__NR_rt_sigreturn, (short *)(frame->retcode+2));
+	err |= __put_user(0x20000001, (unsigned long *)(frame->retcode+4));
+	err |= __put_user(0x15000000, (unsigned long *)(frame->retcode+8));
+
+	if (err)
+		goto give_sigsegv;
+
+	/* TODO what is the current->exec_domain stuff and invmap ? */
+
+	/* Set up registers for signal handler */
+	regs->pc = (unsigned long) ka->sa.sa_handler; /* what we enter NOW   */
+	regs->gpr[9] = (unsigned long) return_ip;    /* what we enter LATER */
+	regs->gpr[3] = (unsigned long) sig;          /* arg 1: signo */
+        regs->gpr[4] = (unsigned long) &frame->info; /* arg 2: (siginfo_t*) */
+        regs->gpr[5] = (unsigned long) &frame->uc;   /* arg 3: ucontext */
+
+	/* actually move the usp to reflect the stacked frame */
+	regs->sp = (unsigned long)frame;
+
+	return;
+
+give_sigsegv:
+	if (sig == SIGSEGV)
+		ka->sa.sa_handler = SIG_DFL;
+	force_sig(SIGSEGV, current);
+}
+
+static inline void
+handle_signal(unsigned long sig,
+	      siginfo_t *info, struct k_sigaction *ka,
+	      sigset_t *oldset, struct pt_regs * regs)
+{
+	setup_rt_frame(sig, ka, info, oldset, regs);
+
+	if (ka->sa.sa_flags & SA_ONESHOT)
+		ka->sa.sa_handler = SIG_DFL;
+
+	spin_lock_irq(&current->sighand->siglock);
+	sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
+	if (!(ka->sa.sa_flags & SA_NODEFER))
+		sigaddset(&current->blocked, sig);
+	recalc_sigpending();
+
+	spin_unlock_irq(&current->sighand->siglock);
+}
+
+/*
+ * Note that 'init' is a special process: it doesn't get signals it doesn't
+ * want to handle. Thus you cannot kill init even with a SIGKILL even by
+ * mistake.
+ *
+ * Also note that the regs structure given here as an argument, is the latest
+ * pushed pt_regs. It may or may not be the same as the first pushed registers
+ * when the initial usermode->kernelmode transition took place. Therefore
+ * we can use user_mode(regs) to see if we came directly from kernel or user
+ * mode below.
+ */
+
+void do_signal(struct pt_regs *regs)
+{
+	siginfo_t info;
+	int signr;
+	struct k_sigaction ka;
+
+	/*
+	 * We want the common case to go fast, which
+	 * is why we may in certain cases get here from
+	 * kernel mode. Just return without doing anything
+	 * if so.
+	 */
+	if (!user_mode(regs))
+		return;
+
+	single_step_clear(current);
+
+	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
+
+	/* If we are coming out of a syscall then we need
+	 * to check if the syscall was interrupted and wants to be
+	 * restarted after handling the signal.  If so, the original
+	 * syscall number is put back into r11 and the PC rewound to
+	 * point at the l.sys instruction that resulted in the
+	 * original syscall.  Syscall results other than the four
+	 * below mean that the syscall executed to completion and no
+	 * restart is necessary.
+	 */
+	if (regs->syscallno) {
+		int restart = 0;
+
+		switch(regs->gpr[11]) {
+		case -ERESTART_RESTARTBLOCK:
+		case -ERESTARTNOHAND:
+			/* Restart if there is no signal handler */
+			restart = (signr <= 0);
+			break;
+		case -ERESTARTSYS:
+			/* Restart if there no signal handler or
+			 * SA_RESTART flag is set */
+			restart = (signr <= 0 || (ka.sa.sa_flags & SA_RESTART));
+			break;
+		case -ERESTARTNOINTR:
+			/* Always restart */
+			restart = 1;
+			break;
+		}
+
+		if (restart) {
+			if (regs->gpr[11] == -ERESTART_RESTARTBLOCK)
+				regs->gpr[11] = __NR_restart_syscall;
+			else
+				regs->gpr[11] = regs->orig_gpr11;
+			regs->pc -= 4;
+		} else {
+			regs->gpr[11] = -EINTR;
+		}
+	}
+
+	if (signr <= 0) {
+		/* no signal to deliver so we just put the saved sigmask
+		 * back */
+		if (test_thread_flag(TIF_RESTORE_SIGMASK)) {
+			clear_thread_flag(TIF_RESTORE_SIGMASK);
+			sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
+		}
+
+	} else { /* signr > 0 */
+		sigset_t *oldset;
+
+		if (current_thread_info()->flags & _TIF_RESTORE_SIGMASK)
+			oldset = &current->saved_sigmask;
+		else
+			oldset = &current->blocked;
+
+		/* Whee!  Actually deliver the signal.  */
+		handle_signal(signr, &info, &ka, oldset, regs);
+		/* a signal was successfully delivered; the saved
+		 * sigmask will have been stored in the signal frame,
+		 * and will be restored by sigreturn, so we can simply
+		 * clear the TIF_RESTORE_SIGMASK flag */
+		if (test_thread_flag(TIF_RESTORE_SIGMASK))
+			clear_thread_flag(TIF_RESTORE_SIGMASK);
+
+		tracehook_signal_handler(signr, &info, &ka, regs,
+					 test_thread_flag(TIF_SINGLESTEP));
+	}
+
+	single_step_set(current);
+
+	return;
+}
+
+asmlinkage void
+do_notify_resume(struct pt_regs *regs)
+{
+	if (current_thread_info()->flags & _TIF_SIGPENDING)
+		do_signal(regs);
+
+
+	if (current_thread_info()->flags & _TIF_NOTIFY_RESUME) {
+		clear_thread_flag(TIF_NOTIFY_RESUME);
+		tracehook_notify_resume(regs);
+		if (current->replacement_session_keyring)
+			key_replace_session_keyring();
+	}
+}
-- 
1.7.4.1

