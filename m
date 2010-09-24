Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab0IXFUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 01:20:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41070 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab0IXFUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 01:20:44 -0400
Date: Fri, 24 Sep 2010 06:20:35 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: [PATCH 1/5] m32r: fix rt_sigsuspend()
Message-ID: <20100924052035.GL19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_signal() should know about saved_mask for it to work...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/m32r/include/asm/signal.h |    1 -
 arch/m32r/include/asm/unistd.h |    1 +
 arch/m32r/kernel/entry.S       |    3 +-
 arch/m32r/kernel/signal.c      |   48 ++++++++++------------------------------
 4 files changed, 14 insertions(+), 39 deletions(-)

diff --git a/arch/m32r/include/asm/signal.h b/arch/m32r/include/asm/signal.h
index 9c1acb2..b2eeb0d 100644
--- a/arch/m32r/include/asm/signal.h
+++ b/arch/m32r/include/asm/signal.h
@@ -157,7 +157,6 @@ typedef struct sigaltstack {
 #undef __HAVE_ARCH_SIG_BITOPS
 
 struct pt_regs;
-extern int do_signal(struct pt_regs *regs, sigset_t *oldset);
 
 #define ptrace_signal_deliver(regs, cookie)	do { } while (0)
 
diff --git a/arch/m32r/include/asm/unistd.h b/arch/m32r/include/asm/unistd.h
index 7612577..c705456 100644
--- a/arch/m32r/include/asm/unistd.h
+++ b/arch/m32r/include/asm/unistd.h
@@ -351,6 +351,7 @@
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT /*will be unused*/
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_RT_SIGACTION
+#define __ARCH_WANT_SYS_RT_SIGSUSPEND
 
 #define __IGNORE_lchown
 #define __IGNORE_setuid
diff --git a/arch/m32r/kernel/entry.S b/arch/m32r/kernel/entry.S
index 4038698..90149da 100644
--- a/arch/m32r/kernel/entry.S
+++ b/arch/m32r/kernel/entry.S
@@ -235,8 +235,7 @@ work_resched:
 work_notifysig:				; deal with pending signals and
 					; notify-resume requests
 	mv	r0, sp			; arg1 : struct pt_regs *regs
-	ldi	r1, #0			; arg2 : sigset_t *oldset
-	mv	r2, r9			; arg3 : __u32 thread_info_flags
+	ldi	r1, r9			; arg2 : __u32 thread_info_flags
 	bl	do_notify_resume
 	bra	restore_all
 
diff --git a/arch/m32r/kernel/signal.c b/arch/m32r/kernel/signal.c
index 144b0f1..acd69f7 100644
--- a/arch/m32r/kernel/signal.c
+++ b/arch/m32r/kernel/signal.c
@@ -28,37 +28,6 @@
 
 #define DEBUG_SIG 0
 
-#define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
-
-int do_signal(struct pt_regs *, sigset_t *);
-
-asmlinkage int
-sys_rt_sigsuspend(sigset_t __user *unewset, size_t sigsetsize,
-		  unsigned long r2, unsigned long r3, unsigned long r4,
-		  unsigned long r5, unsigned long r6, struct pt_regs *regs)
-{
-	sigset_t newset;
-
-	/* XXX: Don't preclude handling different sized sigset_t's.  */
-	if (sigsetsize != sizeof(sigset_t))
-		return -EINVAL;
-
-	if (copy_from_user(&newset, unewset, sizeof(newset)))
-		return -EFAULT;
-	sigdelsetmask(&newset, sigmask(SIGKILL)|sigmask(SIGSTOP));
-
-	spin_lock_irq(&current->sighand->siglock);
-	current->saved_sigmask = current->blocked;
-	current->blocked = newset;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
-
-	current->state = TASK_INTERRUPTIBLE;
-	schedule();
-	set_thread_flag(TIF_RESTORE_SIGMASK);
-	return -ERESTARTNOHAND;
-}
-
 asmlinkage int
 sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 		unsigned long r2, unsigned long r3, unsigned long r4,
@@ -332,12 +301,13 @@ handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
  * want to handle. Thus you cannot kill init even with a SIGKILL even by
  * mistake.
  */
-int do_signal(struct pt_regs *regs, sigset_t *oldset)
+static int do_signal(struct pt_regs *regs)
 {
 	siginfo_t info;
 	int signr;
 	struct k_sigaction ka;
 	unsigned short inst;
+	sigset_t *oldset;
 
 	/*
 	 * We want the common case to go fast, which
@@ -351,7 +321,9 @@ int do_signal(struct pt_regs *regs, sigset_t *oldset)
 	if (try_to_freeze()) 
 		goto no_signal;
 
-	if (!oldset)
+	if (test_thread_flag(TIF_RESTORE_SIGMASK))
+		oldset = &current->saved_sigmask;
+	else
 		oldset = &current->blocked;
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
@@ -364,6 +336,7 @@ int do_signal(struct pt_regs *regs, sigset_t *oldset)
 
 		/* Whee!  Actually deliver the signal.  */
 		handle_signal(signr, &ka, &info, oldset, regs);
+		clear_thread_flag(TIF_RESTORE_SIGMASK);
 		return 1;
 	}
 
@@ -391,6 +364,10 @@ int do_signal(struct pt_regs *regs, sigset_t *oldset)
 				regs->bpc -= 4;
 		}
 	}
+	if (test_thread_flag(TIF_RESTORE_SIGMASK)) {
+		clear_thread_flag(TIF_RESTORE_SIGMASK);
+		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
+	}
 	return 0;
 }
 
@@ -398,8 +375,7 @@ int do_signal(struct pt_regs *regs, sigset_t *oldset)
  * notification of userspace execution resumption
  * - triggered by current->work.notify_resume
  */
-void do_notify_resume(struct pt_regs *regs, sigset_t *oldset,
-		      __u32 thread_info_flags)
+void do_notify_resume(struct pt_regs *regs, __u32 thread_info_flags)
 {
 	/* Pending single-step? */
 	if (thread_info_flags & _TIF_SINGLESTEP)
@@ -407,7 +383,7 @@ void do_notify_resume(struct pt_regs *regs, sigset_t *oldset,
 
 	/* deal with pending signal delivery */
 	if (thread_info_flags & _TIF_SIGPENDING)
-		do_signal(regs,oldset);
+		do_signal(regs);
 
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
-- 
1.5.6.5

