Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab0JGRJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 13:09:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50606 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab0JGRJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 13:09:35 -0400
Date: Thu, 07 Oct 2010 18:09:34 +0100
To: linux-m68k@vger.kernel.org
Subject: [PATCH 2/6] m68k: switch to saner sigsuspend()
Cc: linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1P3tyI-0007hW-FL@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


and saner do_signal() arguments, while we are at it

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/m68k/include/asm/thread_info_mm.h |    1 +
 arch/m68k/include/asm/unistd.h         |    1 +
 arch/m68k/kernel/entry.S               |   19 +---------
 arch/m68k/kernel/signal.c              |   64 ++++++++++---------------------
 4 files changed, 24 insertions(+), 61 deletions(-)

diff --git a/arch/m68k/include/asm/thread_info_mm.h b/arch/m68k/include/asm/thread_info_mm.h
index 3bf31dc..b2ea8be 100644
--- a/arch/m68k/include/asm/thread_info_mm.h
+++ b/arch/m68k/include/asm/thread_info_mm.h
@@ -67,5 +67,6 @@ struct thread_info {
 #define TIF_SYSCALL_TRACE	15	/* syscall trace active */
 #define TIF_MEMDIE		16	/* is terminating due to OOM killer */
 #define TIF_FREEZE		17	/* thread is freezing for suspend */
+#define TIF_RESTORE_SIGMASK	18	/* restore signal mask in do_signal */
 
 #endif	/* _ASM_M68K_THREAD_INFO_H */
diff --git a/arch/m68k/include/asm/unistd.h b/arch/m68k/include/asm/unistd.h
index b43b36b..26d851d 100644
--- a/arch/m68k/include/asm/unistd.h
+++ b/arch/m68k/include/asm/unistd.h
@@ -373,6 +373,7 @@
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
+#define __ARCH_WANT_SYS_RT_SIGSUSPEND
 
 /*
  * "Conditional" syscalls
diff --git a/arch/m68k/kernel/entry.S b/arch/m68k/kernel/entry.S
index 6360c43..3a15a03 100644
--- a/arch/m68k/kernel/entry.S
+++ b/arch/m68k/kernel/entry.S
@@ -174,9 +174,8 @@ do_signal_return:
 	subql	#4,%sp			| dummy return address
 	SAVE_SWITCH_STACK
 	pea	%sp@(SWITCH_STACK_SIZE)
-	clrl	%sp@-
 	bsrl	do_signal
-	addql	#8,%sp
+	addql	#4,%sp
 	RESTORE_SWITCH_STACK
 	addql	#4,%sp
 	tstl	%d0
@@ -290,22 +289,6 @@ ENTRY(sys_vfork)
 	RESTORE_SWITCH_STACK
 	rts
 
-ENTRY(sys_sigsuspend)
-	SAVE_SWITCH_STACK
-	pea	%sp@(SWITCH_STACK_SIZE)
-	jbsr	do_sigsuspend
-	addql	#4,%sp
-	RESTORE_SWITCH_STACK
-	rts
-
-ENTRY(sys_rt_sigsuspend)
-	SAVE_SWITCH_STACK
-	pea	%sp@(SWITCH_STACK_SIZE)
-	jbsr	do_rt_sigsuspend
-	addql	#4,%sp
-	RESTORE_SWITCH_STACK
-	rts
-
 ENTRY(sys_sigreturn)
 	SAVE_SWITCH_STACK
 	jbsr	do_sigreturn
diff --git a/arch/m68k/kernel/signal.c b/arch/m68k/kernel/signal.c
index c776c81..fa8200d 100644
--- a/arch/m68k/kernel/signal.c
+++ b/arch/m68k/kernel/signal.c
@@ -51,8 +51,6 @@
 
 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
 
-asmlinkage int do_signal(sigset_t *oldset, struct pt_regs *regs);
-
 const int frame_extra_sizes[16] = {
   [1]	= -1, /* sizeof(((struct frame *)0)->un.fmt1), */
   [2]	= sizeof(((struct frame *)0)->un.fmt2),
@@ -74,51 +72,21 @@ const int frame_extra_sizes[16] = {
 /*
  * Atomically swap in the new signal mask, and wait for a signal.
  */
-asmlinkage int do_sigsuspend(struct pt_regs *regs)
+asmlinkage int
+sys_sigsuspend(int unused0, int unused1, old_sigset_t mask)
 {
-	old_sigset_t mask = regs->d3;
-	sigset_t saveset;
-
 	mask &= _BLOCKABLE;
-	saveset = current->blocked;
+	spin_lock_irq(&current->sighand->siglock);
+	current->saved_sigmask = current->blocked;
 	siginitset(&current->blocked, mask);
 	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
 
-	regs->d0 = -EINTR;
-	while (1) {
-		current->state = TASK_INTERRUPTIBLE;
-		schedule();
-		if (do_signal(&saveset, regs))
-			return -EINTR;
-	}
-}
-
-asmlinkage int
-do_rt_sigsuspend(struct pt_regs *regs)
-{
-	sigset_t __user *unewset = (sigset_t __user *)regs->d1;
-	size_t sigsetsize = (size_t)regs->d2;
-	sigset_t saveset, newset;
-
-	/* XXX: Don't preclude handling different sized sigset_t's.  */
-	if (sigsetsize != sizeof(sigset_t))
-		return -EINVAL;
-
-	if (copy_from_user(&newset, unewset, sizeof(newset)))
-		return -EFAULT;
-	sigdelsetmask(&newset, ~_BLOCKABLE);
-
-	saveset = current->blocked;
-	current->blocked = newset;
-	recalc_sigpending();
+	current->state = TASK_INTERRUPTIBLE;
+	schedule();
+	set_restore_sigmask();
 
-	regs->d0 = -EINTR;
-	while (1) {
-		current->state = TASK_INTERRUPTIBLE;
-		schedule();
-		if (do_signal(&saveset, regs))
-			return -EINTR;
-	}
+	return -ERESTARTNOHAND;
 }
 
 asmlinkage int
@@ -1017,21 +985,25 @@ handle_signal(int sig, struct k_sigaction *ka, siginfo_t *info,
  * want to handle. Thus you cannot kill init even with a SIGKILL even by
  * mistake.
  */
-asmlinkage int do_signal(sigset_t *oldset, struct pt_regs *regs)
+asmlinkage int do_signal(struct pt_regs *regs)
 {
 	siginfo_t info;
 	struct k_sigaction ka;
 	int signr;
+	sigset_t *oldset;
 
 	current->thread.esp0 = (unsigned long) regs;
 
-	if (!oldset)
+	if (test_thread_flag(TIF_RESTORE_SIGMASK))
+		oldset = &current->saved_sigmask;
+	else
 		oldset = &current->blocked;
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 	if (signr > 0) {
 		/* Whee!  Actually deliver the signal.  */
 		handle_signal(signr, &ka, &info, oldset, regs);
+		clear_thread_flag(TIF_RESTORE_SIGMASK);
 		return 1;
 	}
 
@@ -1040,5 +1012,11 @@ asmlinkage int do_signal(sigset_t *oldset, struct pt_regs *regs)
 		/* Restart the system call - no handlers present */
 		handle_restart(regs, NULL, 0);
 
+	/* If there's no signal to deliver, we just restore the saved mask.  */
+	if (test_thread_flag(TIF_RESTORE_SIGMASK)) {
+		clear_thread_flag(TIF_RESTORE_SIGMASK);
+		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
+	}
+
 	return 0;
 }
-- 
1.5.6.5


