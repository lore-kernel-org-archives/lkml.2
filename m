Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab1IQAw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 20:52:28 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27878 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629Ab1IQAqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 20:46:35 -0400
Message-Id: <e97c6e$3hnnvp@wolverine02.qualcomm.com>
X-IronPort-AV: E=McAfee;i="5400,1158,6471"; a="119267321"
From: Richard Kuo <rkuo@codeaurora.org>
Date: Wed, 14 Sep 2011 13:18:58 -0500
Subject: [PATCH v4 14/36] Hexagon: Add signal functions
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Signed-off-by: Linas Vepstas <linas@codeaurora.org>
---
 arch/hexagon/include/asm/sigcontext.h |   33 +++
 arch/hexagon/include/asm/signal.h     |   26 +++
 arch/hexagon/include/asm/vdso.h       |   31 +++
 arch/hexagon/kernel/signal.c          |  345 +++++++++++++++++++++++++++++++++
 arch/hexagon/kernel/trampoline.S      |   35 ++++
 arch/hexagon/kernel/vdso.c            |  101 ++++++++++
 6 files changed, 571 insertions(+), 0 deletions(-)
 create mode 100644 arch/hexagon/include/asm/sigcontext.h
 create mode 100644 arch/hexagon/include/asm/signal.h
 create mode 100644 arch/hexagon/include/asm/vdso.h
 create mode 100644 arch/hexagon/kernel/signal.c
 create mode 100644 arch/hexagon/kernel/trampoline.S
 create mode 100644 arch/hexagon/kernel/vdso.c

diff --git a/arch/hexagon/include/asm/sigcontext.h b/arch/hexagon/include/asm/sigcontext.h
new file mode 100644
index 0000000..ce6dcd9
--- /dev/null
+++ b/arch/hexagon/include/asm/sigcontext.h
@@ -0,0 +1,33 @@
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
+#include <asm/user.h>
+
+/*
+ * Signal context structure - contains all info to do with the state
+ * before the signal handler was invoked.  Note: only add new entries
+ * to the end of the structure.
+ */
+struct sigcontext {
+	struct user_regs_struct sc_regs;
+} __aligned(8);
+
+#endif
diff --git a/arch/hexagon/include/asm/signal.h b/arch/hexagon/include/asm/signal.h
new file mode 100644
index 0000000..471c056
--- /dev/null
+++ b/arch/hexagon/include/asm/signal.h
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
diff --git a/arch/hexagon/include/asm/vdso.h b/arch/hexagon/include/asm/vdso.h
new file mode 100644
index 0000000..2e429a3
--- /dev/null
+++ b/arch/hexagon/include/asm/vdso.h
@@ -0,0 +1,31 @@
+/*
+ * vDSO implementation for Hexagon
+ *
+ * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
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
+#ifndef __ASM_VDSO_H
+#define __ASM_VDSO_H
+
+#include <linux/types.h>
+
+struct hexagon_vdso {
+	u32 rt_signal_trampoline[2];
+};
+
+#endif /* __ASM_VDSO_H */
+
diff --git a/arch/hexagon/kernel/signal.c b/arch/hexagon/kernel/signal.c
new file mode 100644
index 0000000..b45be31
--- /dev/null
+++ b/arch/hexagon/kernel/signal.c
@@ -0,0 +1,345 @@
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
+#include <linux/tracehook.h>
+#include <asm/registers.h>
+#include <asm/thread_info.h>
+#include <asm/unistd.h>
+#include <asm/uaccess.h>
+#include <asm/ucontext.h>
+#include <asm/cacheflush.h>
+#include <asm/signal.h>
+#include <asm/vdso.h>
+
+#define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
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
+	unsigned long tmp;
+	int err = 0;
+
+	err |= copy_to_user(&sc->sc_regs.r0, &regs->r00,
+			    32*sizeof(unsigned long));
+
+	err |= __put_user(regs->sa0, &sc->sc_regs.sa0);
+	err |= __put_user(regs->lc0, &sc->sc_regs.lc0);
+	err |= __put_user(regs->sa1, &sc->sc_regs.sa1);
+	err |= __put_user(regs->lc1, &sc->sc_regs.lc1);
+	err |= __put_user(regs->m0, &sc->sc_regs.m0);
+	err |= __put_user(regs->m1, &sc->sc_regs.m1);
+	err |= __put_user(regs->usr, &sc->sc_regs.usr);
+	err |= __put_user(regs->preds, &sc->sc_regs.p3_0);
+	err |= __put_user(regs->gp, &sc->sc_regs.gp);
+	err |= __put_user(regs->ugp, &sc->sc_regs.ugp);
+
+	tmp = pt_elr(regs); err |= __put_user(tmp, &sc->sc_regs.pc);
+	tmp = pt_cause(regs); err |= __put_user(tmp, &sc->sc_regs.cause);
+	tmp = pt_badva(regs); err |= __put_user(tmp, &sc->sc_regs.badva);
+
+	return err;
+}
+
+static int restore_sigcontext(struct pt_regs *regs,
+			      struct sigcontext __user *sc)
+{
+	unsigned long tmp;
+	int err = 0;
+
+	err |= copy_from_user(&regs->r00, &sc->sc_regs.r0,
+			      32 * sizeof(unsigned long));
+
+	err |= __get_user(regs->sa0, &sc->sc_regs.sa0);
+	err |= __get_user(regs->lc0, &sc->sc_regs.lc0);
+	err |= __get_user(regs->sa1, &sc->sc_regs.sa1);
+	err |= __get_user(regs->lc1, &sc->sc_regs.lc1);
+	err |= __get_user(regs->m0, &sc->sc_regs.m0);
+	err |= __get_user(regs->m1, &sc->sc_regs.m1);
+	err |= __get_user(regs->usr, &sc->sc_regs.usr);
+	err |= __get_user(regs->preds, &sc->sc_regs.p3_0);
+	err |= __get_user(regs->gp, &sc->sc_regs.gp);
+	err |= __get_user(regs->ugp, &sc->sc_regs.ugp);
+
+	err |= __get_user(tmp, &sc->sc_regs.pc); pt_set_elr(regs, tmp);
+
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
+	struct hexagon_vdso *vdso = current->mm->context.vdso;
+
+	frame = get_sigframe(ka, regs, sizeof(struct rt_sigframe));
+
+	if (!access_ok(VERIFY_WRITE, frame, sizeof(struct rt_sigframe)))
+		goto	sigsegv;
+
+	if (copy_siginfo_to_user(&frame->info, info))
+		goto	sigsegv;
+
+	/* The on-stack signal trampoline is no longer executed;
+	 * however, the libgcc signal frame unwinding code checks for
+	 * the presence of these two numeric magic values.
+	 */
+	err |= __put_user(0x7800d166, &frame->tramp[0]);
+	err |= __put_user(0x5400c004, &frame->tramp[1]);
+	err |= setup_sigcontext(regs, &frame->uc.uc_mcontext);
+	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
+	if (err)
+		goto sigsegv;
+
+	/* Load r0/r1 pair with signumber/siginfo pointer... */
+	regs->r0100 = ((unsigned long long)((unsigned long)&frame->info) << 32)
+		| (unsigned long long)signr;
+	regs->r02 = (unsigned long) &frame->uc;
+	regs->r31 = (unsigned long) vdso->rt_signal_trampoline;
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
+
+			tracehook_signal_handler(signo, &info, &sigact, regs,
+				test_thread_flag(TIF_SINGLESTEP));
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
diff --git a/arch/hexagon/kernel/trampoline.S b/arch/hexagon/kernel/trampoline.S
new file mode 100644
index 0000000..06c36c0
--- /dev/null
+++ b/arch/hexagon/kernel/trampoline.S
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
diff --git a/arch/hexagon/kernel/vdso.c b/arch/hexagon/kernel/vdso.c
new file mode 100644
index 0000000..5ae4134
--- /dev/null
+++ b/arch/hexagon/kernel/vdso.c
@@ -0,0 +1,101 @@
+/*
+ * vDSO implementation for Hexagon
+ *
+ * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
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
+#include <linux/err.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+
+#include <asm/vdso.h>
+
+static struct page *vdso_page;
+
+/* Create a vDSO page holding the signal trampoline.
+ * We want this for a non-executable stack.
+ */
+static int __init vdso_init(void)
+{
+	struct hexagon_vdso *vdso;
+
+	vdso_page = alloc_page(GFP_KERNEL);
+	if (!vdso_page)
+		panic("Cannot allocate vdso");
+
+	vdso = vmap(&vdso_page, 1, 0, PAGE_KERNEL);
+	if (!vdso)
+		panic("Cannot map vdso");
+	clear_page(vdso);
+
+	/* Install the signal trampoline; currently looks like this:
+	 *	r6 = #__NR_rt_sigreturn;
+	 *	trap0(#1);
+	 */
+	vdso->rt_signal_trampoline[0] = __rt_sigtramp_template[0];
+	vdso->rt_signal_trampoline[1] = __rt_sigtramp_template[1];
+
+	vunmap(vdso);
+
+	return 0;
+}
+arch_initcall(vdso_init);
+
+/*
+ * Called from binfmt_elf.  Create a VMA for the vDSO page.
+ */
+int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
+{
+	int ret;
+	unsigned long vdso_base;
+	struct mm_struct *mm = current->mm;
+
+	down_write(&mm->mmap_sem);
+
+	/* Try to get it loaded right near ld.so/glibc. */
+	vdso_base = STACK_TOP;
+
+	vdso_base = get_unmapped_area(NULL, vdso_base, PAGE_SIZE, 0, 0);
+	if (IS_ERR_VALUE(vdso_base)) {
+		ret = vdso_base;
+		goto up_fail;
+	}
+
+	/* MAYWRITE to allow gdb to COW and set breakpoints. */
+	ret = install_special_mapping(mm, vdso_base, PAGE_SIZE,
+				      VM_READ|VM_EXEC|
+				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
+				      VM_ALWAYSDUMP,
+				      &vdso_page);
+
+	if (ret)
+		goto up_fail;
+
+	mm->context.vdso = (void *)vdso_base;
+
+up_fail:
+	up_write(&mm->mmap_sem);
+	return ret;
+}
+
+const char *arch_vma_name(struct vm_area_struct *vma)
+{
+	if (vma->vm_mm && vma->vm_start == (long)vma->vm_mm->context.vdso)
+		return "[vdso]";
+	return NULL;
+}
+
-- 
1.7.1


--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
