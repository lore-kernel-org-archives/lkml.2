Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab0IRIkL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 04:40:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33944 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab0IRIkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 04:40:07 -0400
Date: Sat, 18 Sep 2010 09:40:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Richard Henderson <rth@twiddle.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org
Subject: [PATCH 2/4] alpha: unb0rk sigsuspend() and rt_sigsuspend()
Message-ID: <20100918084006.GB31363@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Old code used to set regs->r0 and regs->r19 to force the right
return value.  Leaving that after switch to ERESTARTNOHAND
was a Bad Idea(tm), since now that screws the restart - if we
hit the case when get_signal_to_deliver() returns 0, we will
step back to syscall insn, with v0 set to EINTR and a3 to 1.
The latter won't matter, since EINTR is 4, aka __NR_write.

Testcase:

	#include <signal.h>
	#define _GNU_SOURCE
	#include <unistd.h>
	#include <sys/syscall.h>

	main()
	{
		sigset_t mask;
		sigemptyset(&mask);
		sigaddset(&mask, SIGCONT);
		sigprocmask(SIG_SETMASK, &mask, NULL);
		kill(0, SIGCONT);
		syscall(__NR_sigsuspend, 1, "b0rken\n", 7);
	}

results on alpha in immediate message to stdout...

Fix is obvious; moreover, since we don't need regs anymore, we can
switch to normal prototypes for these guys and lose the wrappers.
Even better, rt_sigsuspend() is identical to generic version in
kernel/signal.c now.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/alpha/include/asm/unistd.h |    1 +
 arch/alpha/kernel/entry.S       |   32 --------------------------------
 arch/alpha/kernel/signal.c      |   38 +-------------------------------------
 3 files changed, 2 insertions(+), 69 deletions(-)

diff --git a/arch/alpha/include/asm/unistd.h b/arch/alpha/include/asm/unistd.h
index 804e531..f92c9f6 100644
--- a/arch/alpha/include/asm/unistd.h
+++ b/arch/alpha/include/asm/unistd.h
@@ -463,6 +463,7 @@
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
+#define __ARCH_WANT_SYS_RT_SIGSUSPEND
 
 /* "Conditional" syscalls.  What we want is
 
diff --git a/arch/alpha/kernel/entry.S b/arch/alpha/kernel/entry.S
index b45d913..bceb325 100644
--- a/arch/alpha/kernel/entry.S
+++ b/arch/alpha/kernel/entry.S
@@ -779,38 +779,6 @@ sys_rt_sigreturn:
 .end sys_rt_sigreturn
 
 	.align	4
-	.globl	sys_sigsuspend
-	.ent	sys_sigsuspend
-sys_sigsuspend:
-	.prologue 0
-	mov	$sp, $17
-	br	$1, do_switch_stack
-	mov	$sp, $18
-	subq	$sp, 16, $sp
-	stq	$26, 0($sp)
-	jsr	$26, do_sigsuspend
-	ldq	$26, 0($sp)
-	lda	$sp, SWITCH_STACK_SIZE+16($sp)
-	ret
-.end sys_sigsuspend
-
-	.align	4
-	.globl	sys_rt_sigsuspend
-	.ent	sys_rt_sigsuspend
-sys_rt_sigsuspend:
-	.prologue 0
-	mov	$sp, $18
-	br	$1, do_switch_stack
-	mov	$sp, $19
-	subq	$sp, 16, $sp
-	stq	$26, 0($sp)
-	jsr	$26, do_rt_sigsuspend
-	ldq	$26, 0($sp)
-	lda	$sp, SWITCH_STACK_SIZE+16($sp)
-	ret
-.end sys_rt_sigsuspend
-
-	.align	4
 	.globl	sys_sethae
 	.ent	sys_sethae
 sys_sethae:
diff --git a/arch/alpha/kernel/signal.c b/arch/alpha/kernel/signal.c
index e5b1b3c..0f6b51a 100644
--- a/arch/alpha/kernel/signal.c
+++ b/arch/alpha/kernel/signal.c
@@ -144,8 +144,7 @@ SYSCALL_DEFINE5(rt_sigaction, int, sig, const struct sigaction __user *, act,
 /*
  * Atomically swap in the new signal mask, and wait for a signal.
  */
-asmlinkage int
-do_sigsuspend(old_sigset_t mask, struct pt_regs *regs, struct switch_stack *sw)
+SYSCALL_DEFINE1(sigsuspend, old_sigset_t, mask)
 {
 	mask &= _BLOCKABLE;
 	spin_lock_irq(&current->sighand->siglock);
@@ -154,41 +153,6 @@ do_sigsuspend(old_sigset_t mask, struct pt_regs *regs, struct switch_stack *sw)
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 
-	/* Indicate EINTR on return from any possible signal handler,
-	   which will not come back through here, but via sigreturn.  */
-	regs->r0 = EINTR;
-	regs->r19 = 1;
-
-	current->state = TASK_INTERRUPTIBLE;
-	schedule();
-	set_thread_flag(TIF_RESTORE_SIGMASK);
-	return -ERESTARTNOHAND;
-}
-
-asmlinkage int
-do_rt_sigsuspend(sigset_t __user *uset, size_t sigsetsize,
-		 struct pt_regs *regs, struct switch_stack *sw)
-{
-	sigset_t set;
-
-	/* XXX: Don't preclude handling different sized sigset_t's.  */
-	if (sigsetsize != sizeof(sigset_t))
-		return -EINVAL;
-	if (copy_from_user(&set, uset, sizeof(set)))
-		return -EFAULT;
-
-	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->saved_sigmask = current->blocked;
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
-
-	/* Indicate EINTR on return from any possible signal handler,
-	   which will not come back through here, but via sigreturn.  */
-	regs->r0 = EINTR;
-	regs->r19 = 1;
-
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
 	set_thread_flag(TIF_RESTORE_SIGMASK);
-- 
1.5.6.5

