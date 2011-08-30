Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab1H3TV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 15:21:58 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42334 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267Ab1H3TPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 15:15:02 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6454"; a="113875026"
Message-Id: <20110830190801.077449004@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Aug 2011 14:07:43 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Cc: Linas Vepstas <linas@codeaurora.org>
Subject: [patch v2 14/35] Hexagon: Add signal functions
References: <20110830190729.923334292@codeaurora.org>
Content-Disposition: inline; filename=signals.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Signed-off-by: Linas Vepstas <linas@codeaurora.org>

---
 arch/hexagon/include/asm/sigcontext.h |   32 +++
 arch/hexagon/include/asm/signal.h     |   26 ++
 arch/hexagon/kernel/signal.c          |  325 ++++++++++++++++++++++++++++++++++
 arch/hexagon/kernel/trampoline.S      |   35 +++
 4 files changed, 418 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/include/asm/sigcontext.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/sigcontext.h	2011-08-24 18:45:48.193877157 -0500
@@ -0,0 +1,32 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_SIGCONTEXT_H
+#define _ASM_SIGCONTEXT_H
+
+#include <asm/registers.h>
+
+/*
+ * Signal context structure - contains all info to do with the state
+ * before the signal handler was invoked.
+ */
+struct sigcontext {
+	struct pt_regs sc_regs;
+};
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/signal.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/signal.h	2011-08-24 18:45:48.193877157 -0500
@@ -0,0 +1,26 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_SIGNAL_H
+#define _ASM_SIGNAL_H
+
+extern unsigned long __rt_sigtramp_template[2];
+
+#include <asm-generic/signal.h>
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/kernel/signal.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/kernel/signal.c	2011-08-24 18:45:48.193877157 -0500
@@ -0,0 +1,325 @@
+/*
+ * Signal support for Hexagon processor
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/linkage.h>
+#include <linux/syscalls.h>
+#include <linux/freezer.h>
+#include <asm/registers.h>
+#include <asm/thread_info.h>
+#include <asm/unistd.h>
+#include <asm/uaccess.h>
+#include <asm/ucontext.h>
+#include <asm/cacheflush.h>
+#include <asm/signal.h>
+
+#define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
+
+struct sigframe {
+	unsigned long tramp[2];
+	struct sigcontext sc;
+	sigset_t mask;
+};
+
+struct rt_sigframe {
+	unsigned long tramp[2];
+	struct siginfo info;
+	struct ucontext uc;
+};
+
+static void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
+			  size_t frame_size)
+{
+	unsigned long sp = regs->r29;
+
+	/* Switch to signal stack if appropriate */
+	if ((ka->sa.sa_flags & SA_ONSTACK) && (sas_ss_flags(sp) == 0))
+		sp = current->sas_ss_sp + current->sas_ss_size;
+
+	return (void __user *)((sp - frame_size) & ~(sizeof(long long) - 1));
+}
+
+static int setup_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc)
+{
+	int err = 0;
+
+	/*
+	 * Need to revisit if we're leaking anything inappropriate to user
+	 * stack.
+	 */
+
+	err |= copy_to_user(&sc->sc_regs, regs, sizeof(struct pt_regs));
+	return err;
+}
+
+static int restore_sigcontext(struct pt_regs *regs,
+			      struct sigcontext __user *sc)
+{
+	int err = 0;
+
+	/*
+	 * Should only restore vmel in case user stack is corrupted,
+	 * bogus status shouldn't be used in the rte.
+	 */
+
+	err |= copy_from_user(regs, &sc->sc_regs,
+			      offsetof(struct pt_regs, hvmer.vmel)
+			      + sizeof(unsigned long));
+	return err;
+}
+
+/*
+ * Setup signal stack frame with siginfo structure
+ */
+static int setup_rt_frame(int signr, struct k_sigaction *ka, siginfo_t *info,
+			  sigset_t *set,  struct pt_regs *regs)
+{
+	int err = 0;
+	struct rt_sigframe __user *frame;
+
+	frame = get_sigframe(ka, regs, sizeof(struct rt_sigframe));
+
+	if (!access_ok(VERIFY_WRITE, frame, sizeof(struct rt_sigframe)))
+		goto	sigsegv;
+
+	if (copy_siginfo_to_user(&frame->info, info))
+		goto	sigsegv;
+
+	err |= __put_user(__rt_sigtramp_template[0], &frame->tramp[0]);
+	err |= __put_user(__rt_sigtramp_template[1], &frame->tramp[1]);
+	flush_dcache_range((unsigned long)&frame->tramp[0],
+			   (unsigned long)&frame->tramp[2]);
+	flush_icache_range((unsigned long)&frame->tramp[0],
+			   (unsigned long)&frame->tramp[2]);
+	mb();
+
+	err |= setup_sigcontext(regs, &frame->uc.uc_mcontext);
+	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
+	if (err)
+		goto sigsegv;
+
+	/* Load r0/r1 pair with signumber/siginfo pointer... */
+	regs->r0100 = ((unsigned long long)((unsigned long)&frame->info) << 32)
+		| (unsigned long long)signr;
+	regs->r02 = (unsigned long) &frame->uc;
+	regs->r31 = (unsigned long) frame->tramp;
+	pt_psp(regs) = (unsigned long) frame;
+	pt_set_elr(regs, (unsigned long)ka->sa.sa_handler);
+
+	return 0;
+
+sigsegv:
+	force_sigsegv(signr, current);
+	return -EFAULT;
+}
+
+/*
+ * Setup invocation of signal handler
+ */
+static int handle_signal(int sig, siginfo_t *info, struct k_sigaction *ka,
+			 sigset_t *oldset, struct pt_regs *regs)
+{
+	int rc;
+
+	/*
+	 * If we're handling a signal that aborted a system call,
+	 * set up the error return value before adding the signal
+	 * frame to the stack.
+	 */
+
+	if (regs->syscall_nr >= 0) {
+		switch (regs->r00) {
+		case -ERESTART_RESTARTBLOCK:
+		case -ERESTARTNOHAND:
+			regs->r00 = -EINTR;
+			break;
+		case -ERESTARTSYS:
+			if (!(ka->sa.sa_flags & SA_RESTART)) {
+				regs->r00 = -EINTR;
+				break;
+			}
+			/* Fall through */
+		case -ERESTARTNOINTR:
+			regs->r06 = regs->syscall_nr;
+			pt_set_elr(regs, pt_elr(regs) - 4);
+			regs->r00 = regs->restart_r0;
+			break;
+		default:
+			break;
+		}
+	}
+
+	/*
+	 * Set up the stack frame; not doing the SA_SIGINFO thing.  We
+	 * only set up the rt_frame flavor.
+	 */
+	rc = setup_rt_frame(sig, ka, info, oldset, regs);
+
+	/* If there was an error on setup, no signal was delivered. */
+	if (rc)
+		return rc;
+
+	spin_lock_irq(&current->sighand->siglock);
+	sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
+	if (!(ka->sa.sa_flags & SA_NODEFER))
+		sigaddset(&current->blocked, sig);
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+
+	return 0;
+}
+
+/*
+ * Called from return-from-event code.
+ */
+static void do_signal(struct pt_regs *regs)
+{
+	struct k_sigaction sigact;
+	siginfo_t info;
+	int signo;
+
+	if (!user_mode(regs))
+		return;
+
+	if (try_to_freeze())
+		goto no_signal;
+
+	signo = get_signal_to_deliver(&info, &sigact, regs, NULL);
+
+	if (signo > 0) {
+		sigset_t *oldset;
+
+		if (test_thread_flag(TIF_RESTORE_SIGMASK))
+			oldset = &current->saved_sigmask;
+		else
+			oldset = &current->blocked;
+
+		if (handle_signal(signo, &info, &sigact, oldset, regs) == 0) {
+			/*
+			 * Successful delivery case.  The saved sigmask is
+			 * stored in the signal frame, and will be restored
+			 * by sigreturn.  We can clear the TIF flag.
+			 */
+			clear_thread_flag(TIF_RESTORE_SIGMASK);
+		}
+		return;
+	}
+
+no_signal:
+	/*
+	 * If we came from a system call, handle the restart.
+	 */
+	if (regs->syscall_nr >= 0) {
+		switch (regs->r00) {
+		case -ERESTARTNOHAND:
+		case -ERESTARTSYS:
+		case -ERESTARTNOINTR:
+			regs->r06 = regs->syscall_nr;
+			break;
+		case -ERESTART_RESTARTBLOCK:
+			regs->r06 = __NR_restart_syscall;
+			break;
+		default:
+			goto no_restart;
+		}
+		pt_set_elr(regs, pt_elr(regs) - 4);
+		regs->r00 = regs->restart_r0;
+	}
+
+no_restart:
+	/* If there's no signal to deliver, put the saved sigmask back */
+	if (test_thread_flag(TIF_RESTORE_SIGMASK)) {
+		clear_thread_flag(TIF_RESTORE_SIGMASK);
+		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
+	}
+}
+
+void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags)
+{
+	if (thread_info_flags & _TIF_SIGPENDING)
+		do_signal(regs);
+
+	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
+		clear_thread_flag(TIF_NOTIFY_RESUME);
+		if (current->replacement_session_keyring)
+			key_replace_session_keyring();
+	}
+}
+
+/*
+ * Architecture-specific wrappers for signal-related system calls
+ */
+asmlinkage int sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss)
+{
+	struct pt_regs *regs = current_thread_info()->regs;
+
+	return do_sigaltstack(uss, uoss, regs->r29);
+}
+
+asmlinkage int sys_rt_sigreturn(void)
+{
+	struct pt_regs *regs = current_thread_info()->regs;
+	struct rt_sigframe __user *frame;
+	sigset_t blocked;
+
+	frame = (struct rt_sigframe __user *)pt_psp(regs);
+	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
+		goto badframe;
+	if (__copy_from_user(&blocked, &frame->uc.uc_sigmask, sizeof(blocked)))
+		goto badframe;
+
+	sigdelsetmask(&blocked, ~_BLOCKABLE);
+	spin_lock_irq(&current->sighand->siglock);
+	current->blocked = blocked;
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+
+	if (restore_sigcontext(regs, &frame->uc.uc_mcontext))
+		goto badframe;
+
+	/* Restore the user's stack as well */
+	pt_psp(regs) = regs->r29;
+
+	/*
+	 * Leave a trace in the stack frame that this was a sigreturn.
+	 * If the system call is to replay, we've already restored the
+	 * number in the GPR slot and it will be regenerated on the
+	 * new system call trap entry. Note that if restore_sigcontext()
+	 * did something other than a bulk copy of the pt_regs struct,
+	 * we could avoid this assignment by simply not overwriting
+	 * regs->syscall_nr.
+	 */
+	regs->syscall_nr = __NR_rt_sigreturn;
+
+	/*
+	 * If we were meticulous, we'd only call this if we knew that
+	 * we were actually going to use an alternate stack, and we'd
+	 * consider any error to be fatal.  What we do here, in common
+	 * with many other architectures, is call it blindly and only
+	 * consider the -EFAULT return case to be proof of a problem.
+	 */
+	if (do_sigaltstack(&frame->uc.uc_stack, NULL, pt_psp(regs)) == -EFAULT)
+		goto badframe;
+
+	return 0;
+
+badframe:
+	force_sig(SIGSEGV, current);
+	return 0;
+}
Index: linux-hexagon-kernel/arch/hexagon/kernel/trampoline.S
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/kernel/trampoline.S	2011-08-24 18:45:48.193877157 -0500
@@ -0,0 +1,35 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+/*
+ * Trampoline sequences to be copied onto user stack.
+ * This consumes a little more space than hand-assembling
+ * immediate constants for use in C, but is more portable
+ * to future tweaks to the Hexagon instruction set.
+ */
+
+#include <asm/unistd.h>
+
+/*  Sig trampolines - call sys_sigreturn or sys_rt_sigreturn as appropriate */
+
+/*  plain sigreturn is gone.  */
+
+	.globl __rt_sigtramp_template
+__rt_sigtramp_template:
+	r6 = #__NR_rt_sigreturn;
+	trap0(#1);

--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

