Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab1HaV2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 17:28:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755613Ab1HaV2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 17:28:14 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, ming.lei@canonical.com,
        stern@rowland.harvard.edu, Mark Salter <msalter@redhat.com>
Subject: [PATCH 09/24] C6X: signal management
Date: Wed, 31 Aug 2011 17:26:44 -0400
Message-Id: <1314826019-22330-10-git-send-email-msalter@redhat.com>
In-Reply-To: <1314826019-22330-1-git-send-email-msalter@redhat.com>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/include/asm/sigcontext.h |   80 ++++++++
 arch/c6x/include/asm/signal.h     |   17 ++
 arch/c6x/kernel/signal.c          |  377 +++++++++++++++++++++++++++++++++++++
 3 files changed, 474 insertions(+), 0 deletions(-)
 create mode 100644 arch/c6x/include/asm/sigcontext.h
 create mode 100644 arch/c6x/include/asm/signal.h
 create mode 100644 arch/c6x/kernel/signal.c

diff --git a/arch/c6x/include/asm/sigcontext.h b/arch/c6x/include/asm/sigcontext.h
new file mode 100644
index 0000000..eb702f3
--- /dev/null
+++ b/arch/c6x/include/asm/sigcontext.h
@@ -0,0 +1,80 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_SIGCONTEXT_H
+#define _ASM_C6X_SIGCONTEXT_H
+
+
+struct sigcontext {
+	unsigned long  sc_mask;		/* old sigmask */
+	unsigned long  sc_sp;		/* old user stack pointer */
+
+	unsigned long  sc_a4;
+	unsigned long  sc_b4;
+	unsigned long  sc_a6;
+	unsigned long  sc_b6;
+	unsigned long  sc_a8;
+	unsigned long  sc_b8;
+
+	unsigned long  sc_a0;
+	unsigned long  sc_a1;
+	unsigned long  sc_a2;
+	unsigned long  sc_a3;
+	unsigned long  sc_a5;
+	unsigned long  sc_a7;
+	unsigned long  sc_a9;
+
+	unsigned long  sc_b0;
+	unsigned long  sc_b1;
+	unsigned long  sc_b2;
+	unsigned long  sc_b3;
+	unsigned long  sc_b5;
+	unsigned long  sc_b7;
+	unsigned long  sc_b9;
+
+	unsigned long  sc_a16;
+	unsigned long  sc_a17;
+	unsigned long  sc_a18;
+	unsigned long  sc_a19;
+	unsigned long  sc_a20;
+	unsigned long  sc_a21;
+	unsigned long  sc_a22;
+	unsigned long  sc_a23;
+	unsigned long  sc_a24;
+	unsigned long  sc_a25;
+	unsigned long  sc_a26;
+	unsigned long  sc_a27;
+	unsigned long  sc_a28;
+	unsigned long  sc_a29;
+	unsigned long  sc_a30;
+	unsigned long  sc_a31;
+
+	unsigned long  sc_b16;
+	unsigned long  sc_b17;
+	unsigned long  sc_b18;
+	unsigned long  sc_b19;
+	unsigned long  sc_b20;
+	unsigned long  sc_b21;
+	unsigned long  sc_b22;
+	unsigned long  sc_b23;
+	unsigned long  sc_b24;
+	unsigned long  sc_b25;
+	unsigned long  sc_b26;
+	unsigned long  sc_b27;
+	unsigned long  sc_b28;
+	unsigned long  sc_b29;
+	unsigned long  sc_b30;
+	unsigned long  sc_b31;
+
+	unsigned long  sc_csr;
+	unsigned long  sc_pc;
+};
+
+#endif /* _ASM_C6X_SIGCONTEXT_H */
diff --git a/arch/c6x/include/asm/signal.h b/arch/c6x/include/asm/signal.h
new file mode 100644
index 0000000..f1cd870
--- /dev/null
+++ b/arch/c6x/include/asm/signal.h
@@ -0,0 +1,17 @@
+#ifndef _ASM_C6X_SIGNAL_H
+#define _ASM_C6X_SIGNAL_H
+
+#include <asm-generic/signal.h>
+
+#ifndef __ASSEMBLY__
+#include <linux/linkage.h>
+
+struct pt_regs;
+
+extern asmlinkage int do_rt_sigreturn(struct pt_regs *regs);
+extern asmlinkage void do_notify_resume(struct pt_regs *regs,
+					u32 thread_info_flags,
+					int syscall);
+#endif
+
+#endif /* _ASM_C6X_SIGNAL_H */
diff --git a/arch/c6x/kernel/signal.c b/arch/c6x/kernel/signal.c
new file mode 100644
index 0000000..89cfabd
--- /dev/null
+++ b/arch/c6x/kernel/signal.c
@@ -0,0 +1,377 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2006, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  Updated for 2.6.34: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/uaccess.h>
+#include <linux/syscalls.h>
+#include <linux/tracehook.h>
+
+#include <asm/ucontext.h>
+#include <asm/cacheflush.h>
+
+
+#define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
+
+/*
+ * Do a signal return, undo the signal stack.
+ */
+
+#define RETCODE_SIZE (9 << 2)	/* 9 instructions = 36 bytes */
+
+struct rt_sigframe {
+	struct siginfo __user *pinfo;
+	void __user *puc;
+	struct siginfo info;
+	struct ucontext uc;
+	unsigned long retcode[RETCODE_SIZE >> 2];
+};
+
+static int restore_sigcontext(struct pt_regs *regs,
+			      struct sigcontext __user *sc)
+{
+	int err = 0;
+
+	/* The access_ok check was done by caller, so use __get_user here */
+#define COPY(x)  (err |= __get_user(regs->x, &sc->sc_##x))
+
+	COPY(sp); COPY(a4); COPY(b4); COPY(a6); COPY(b6); COPY(a8); COPY(b8);
+	COPY(a0); COPY(a1); COPY(a2); COPY(a3); COPY(a5); COPY(a7); COPY(a9);
+	COPY(b0); COPY(b1); COPY(b2); COPY(b3); COPY(b5); COPY(b7); COPY(b9);
+
+	COPY(a16); COPY(a17); COPY(a18); COPY(a19);
+	COPY(a20); COPY(a21); COPY(a22); COPY(a23);
+	COPY(a24); COPY(a25); COPY(a26); COPY(a27);
+	COPY(a28); COPY(a29); COPY(a30); COPY(a31);
+	COPY(b16); COPY(b17); COPY(b18); COPY(b19);
+	COPY(b20); COPY(b21); COPY(b22); COPY(b23);
+	COPY(b24); COPY(b25); COPY(b26); COPY(b27);
+	COPY(b28); COPY(b29); COPY(b30); COPY(b31);
+
+	COPY(csr); COPY(pc);
+
+#undef COPY
+
+	return err;
+}
+
+asmlinkage int do_rt_sigreturn(struct pt_regs *regs)
+{
+	struct rt_sigframe __user *frame;
+	sigset_t set;
+
+	/*
+	 * Since we stacked the signal on a dword boundary,
+	 * 'sp' should be dword aligned here.  If it's
+	 * not, then the user is trying to mess with us.
+	 */
+	if (regs->sp & 7)
+		goto badframe;
+
+	frame = (struct rt_sigframe __user *) ((unsigned long) regs->sp + 8);
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
+	return regs->a4;
+
+badframe:
+	force_sig(SIGSEGV, current);
+	return 0;
+}
+
+static int setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs,
+			    unsigned long mask)
+{
+	int err = 0;
+
+	err |= __put_user(mask, &sc->sc_mask);
+
+	/* The access_ok check was done by caller, so use __put_user here */
+#define COPY(x) (err |= __put_user(regs->x, &sc->sc_##x))
+
+	COPY(sp); COPY(a4); COPY(b4); COPY(a6); COPY(b6); COPY(a8); COPY(b8);
+	COPY(a0); COPY(a1); COPY(a2); COPY(a3); COPY(a5); COPY(a7); COPY(a9);
+	COPY(b0); COPY(b1); COPY(b2); COPY(b3); COPY(b5); COPY(b7); COPY(b9);
+
+	COPY(a16); COPY(a17); COPY(a18); COPY(a19);
+	COPY(a20); COPY(a21); COPY(a22); COPY(a23);
+	COPY(a24); COPY(a25); COPY(a26); COPY(a27);
+	COPY(a28); COPY(a29); COPY(a30); COPY(a31);
+	COPY(b16); COPY(b17); COPY(b18); COPY(b19);
+	COPY(b20); COPY(b21); COPY(b22); COPY(b23);
+	COPY(b24); COPY(b25); COPY(b26); COPY(b27);
+	COPY(b28); COPY(b29); COPY(b30); COPY(b31);
+
+	COPY(csr); COPY(pc);
+
+#undef COPY
+
+	return err;
+}
+
+static inline void __user *get_sigframe(struct k_sigaction *ka,
+					struct pt_regs *regs,
+					unsigned long framesize)
+{
+	unsigned long sp = regs->sp;
+
+	/*
+	 * This is the X/Open sanctioned signal stack switching.
+	 */
+	if ((ka->sa.sa_flags & SA_ONSTACK) && sas_ss_flags(sp) == 0)
+		sp = current->sas_ss_sp + current->sas_ss_size;
+
+	/*
+	 * No matter what happens, 'sp' must be dword
+	 * aligned. Otherwise, nasty things will happen
+	 */
+	return (void __user *)((sp - framesize) & ~7);
+}
+
+static int setup_rt_frame(int signr, struct k_sigaction *ka, siginfo_t *info,
+			   sigset_t *set, struct pt_regs *regs)
+{
+	struct rt_sigframe __user *frame;
+	unsigned long __user *retcode;
+	int err = 0;
+
+	frame = get_sigframe(ka, regs, sizeof(*frame));
+
+	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
+		goto segv_and_exit;
+
+	err |= __put_user(&frame->info, &frame->pinfo);
+	err |= __put_user(&frame->uc, &frame->puc);
+	err |= copy_siginfo_to_user(&frame->info, info);
+
+	/* Clear all the bits of the ucontext we don't use.  */
+	err |= __clear_user(&frame->uc, offsetof(struct ucontext, uc_mcontext));
+
+	err |= setup_sigcontext(&frame->uc.uc_mcontext,	regs, set->sig[0]);
+	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
+
+	/* Set up to return from userspace */
+	retcode = (unsigned long __user *) &frame->retcode;
+
+	/* The access_ok check was done above, so use __put_user here */
+#define COPY(x) (err |= __put_user(x, retcode++))
+
+	COPY(0x0000002AUL | (__NR_rt_sigreturn << 7));
+				/* MVK __NR_rt_sigreturn,B0 */
+	COPY(0x10000000UL);	/* SWE */
+	COPY(0x00006000UL);	/* NOP 4 */
+	COPY(0x00006000UL);	/* NOP 4 */
+	COPY(0x00006000UL);	/* NOP 4 */
+	COPY(0x00006000UL);	/* NOP 4 */
+	COPY(0x00006000UL);	/* NOP 4 */
+	COPY(0x00006000UL);	/* NOP 4 */
+	COPY(0x00006000UL);	/* NOP 4 */
+
+#undef COPY
+
+	if (err)
+		goto segv_and_exit;
+
+	flush_icache_range((unsigned long) &frame->retcode,
+			   (unsigned long) &frame->retcode + RETCODE_SIZE);
+
+	retcode = (unsigned long __user *) &frame->retcode;
+
+	/* Change user context to branch to signal handler */
+	regs->sp = (unsigned long) frame - 8;
+	regs->b3 = (unsigned long) retcode;
+	regs->pc = (unsigned long) ka->sa.sa_handler;
+
+	/* Give the signal number to the handler */
+	regs->a4 = signr;
+
+	/*
+	 * For realtime signals we must also set the second and third
+	 * arguments for the signal handler.
+	 *   -- Peter Maydell <pmaydell@chiark.greenend.org.uk> 2000-12-06
+	 */
+	regs->b4 = (unsigned long)&frame->info;
+	regs->a6 = (unsigned long)&frame->uc;
+
+	return 0;
+
+segv_and_exit:
+	force_sig(SIGSEGV, current);
+	return -EFAULT;
+}
+
+static inline void
+handle_restart(struct pt_regs *regs, struct k_sigaction *ka, int has_handler)
+{
+	switch (regs->a4) {
+	case -ERESTARTNOHAND:
+		if (!has_handler)
+			goto do_restart;
+		regs->a4 = -EINTR;
+		break;
+
+	case -ERESTARTSYS:
+		if (has_handler && !(ka->sa.sa_flags & SA_RESTART)) {
+			regs->a4 = -EINTR;
+			break;
+		}
+	/* fallthrough */
+	case -ERESTARTNOINTR:
+do_restart:
+		regs->a4 = regs->orig_a4;
+		regs->pc -= 4;
+		break;
+	}
+}
+
+/*
+ * handle the actual delivery of a signal to userspace
+ */
+static int handle_signal(int sig,
+			 siginfo_t *info, struct k_sigaction *ka,
+			 sigset_t *oldset, struct pt_regs *regs,
+			 int syscall)
+{
+	int ret;
+
+	/* Are we from a system call? */
+	if (syscall) {
+		/* If so, check system call restarting.. */
+		switch (regs->a4) {
+		case -ERESTART_RESTARTBLOCK:
+		case -ERESTARTNOHAND:
+			regs->a4 = -EINTR;
+			break;
+
+		case -ERESTARTSYS:
+			if (!(ka->sa.sa_flags & SA_RESTART)) {
+				regs->a4 = -EINTR;
+				break;
+			}
+
+			/* fallthrough */
+		case -ERESTARTNOINTR:
+			regs->a4 = regs->orig_a4;
+			regs->pc -= 4;
+		}
+	}
+
+	/* Set up the stack frame */
+	ret = setup_rt_frame(sig, ka, info, oldset, regs);
+	if (ret == 0) {
+		spin_lock_irq(&current->sighand->siglock);
+		sigorsets(&current->blocked, &current->blocked,
+			  &ka->sa.sa_mask);
+		if (!(ka->sa.sa_flags & SA_NODEFER))
+			sigaddset(&current->blocked, sig);
+		recalc_sigpending();
+		spin_unlock_irq(&current->sighand->siglock);
+	}
+
+	return ret;
+}
+
+/*
+ * handle a potential signal
+ */
+static void do_signal(struct pt_regs *regs, int syscall)
+{
+	struct k_sigaction ka;
+	siginfo_t info;
+	sigset_t *oldset;
+	int signr;
+
+	/* we want the common case to go fast, which is why we may in certain
+	 * cases get here from kernel mode */
+	if (!user_mode(regs))
+		return;
+
+	if (test_thread_flag(TIF_RESTORE_SIGMASK))
+		oldset = &current->saved_sigmask;
+	else
+		oldset = &current->blocked;
+
+	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
+	if (signr > 0) {
+		if (handle_signal(signr, &info, &ka, oldset,
+				  regs, syscall) == 0) {
+			/* a signal was successfully delivered; the saved
+			 * sigmask will have been stored in the signal frame,
+			 * and will be restored by sigreturn, so we can simply
+			 * clear the TIF_RESTORE_SIGMASK flag */
+			if (test_thread_flag(TIF_RESTORE_SIGMASK))
+				clear_thread_flag(TIF_RESTORE_SIGMASK);
+
+			tracehook_signal_handler(signr, &info, &ka, regs, 0);
+		}
+
+		return;
+	}
+
+	/* did we come from a system call? */
+	if (syscall) {
+		/* restart the system call - no handlers present */
+		switch (regs->a4) {
+		case -ERESTARTNOHAND:
+		case -ERESTARTSYS:
+		case -ERESTARTNOINTR:
+			regs->a4 = regs->orig_a4;
+			regs->pc -= 4;
+			break;
+
+		case -ERESTART_RESTARTBLOCK:
+			regs->a4 = regs->orig_a4;
+			regs->b0 = __NR_restart_syscall;
+			regs->pc -= 4;
+			break;
+		}
+	}
+
+	/* if there's no signal to deliver, we just put the saved sigmask
+	 * back */
+	if (test_thread_flag(TIF_RESTORE_SIGMASK)) {
+		clear_thread_flag(TIF_RESTORE_SIGMASK);
+		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
+	}
+}
+
+/*
+ * notification of userspace execution resumption
+ * - triggered by current->work.notify_resume
+ */
+asmlinkage void do_notify_resume(struct pt_regs *regs, u32 thread_info_flags,
+				 int syscall)
+{
+	/* deal with pending signal delivery */
+	if (thread_info_flags & ((1 << TIF_SIGPENDING) |
+				 (1 << TIF_RESTORE_SIGMASK)))
+		do_signal(regs, syscall);
+
+	if (thread_info_flags & (1 << TIF_NOTIFY_RESUME)) {
+		clear_thread_flag(TIF_NOTIFY_RESUME);
+		tracehook_notify_resume(regs);
+		if (current->replacement_session_keyring)
+			key_replace_session_keyring();
+	}
+}
-- 
1.7.6

