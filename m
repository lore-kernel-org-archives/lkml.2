Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab1GVPZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 11:25:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53054 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab1GVPZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 11:25:17 -0400
Date: Fri, 22 Jul 2011 17:24:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/signal changes for v3.1
Message-ID: <20110722152430.GA23965@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-signal-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-signal-for-linus

 Thanks,

	Ingo

------------------>
Oleg Nesterov (4):
      x86, signals: Convert the IA32_EMULATION code to use set_current_blocked()
      x86, signals: Convert the X86_32 code to use set_current_blocked()
      x86, do_signal: Simplify the TS_RESTORE_SIGMASK logic
      x86: Kill handle_signal()->set_fs()


 arch/x86/ia32/ia32_signal.c |   22 +++++++----------
 arch/x86/kernel/signal.c    |   56 +++++++++++++-----------------------------
 2 files changed, 27 insertions(+), 51 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 588a7aa..6557769 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -127,15 +127,17 @@ int copy_siginfo_from_user32(siginfo_t *to, compat_siginfo_t __user *from)
 
 asmlinkage long sys32_sigsuspend(int history0, int history1, old_sigset_t mask)
 {
-	mask &= _BLOCKABLE;
-	spin_lock_irq(&current->sighand->siglock);
+	sigset_t blocked;
+
 	current->saved_sigmask = current->blocked;
-	siginitset(&current->blocked, mask);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+
+	mask &= _BLOCKABLE;
+	siginitset(&blocked, mask);
+	set_current_blocked(&blocked);
 
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
+
 	set_restore_sigmask();
 	return -ERESTARTNOHAND;
 }
@@ -279,10 +281,7 @@ asmlinkage long sys32_sigreturn(struct pt_regs *regs)
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (ia32_restore_sigcontext(regs, &frame->sc, &ax))
 		goto badframe;
@@ -308,10 +307,7 @@ asmlinkage long sys32_rt_sigreturn(struct pt_regs *regs)
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (ia32_restore_sigcontext(regs, &frame->uc.uc_mcontext, &ax))
 		goto badframe;
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 40a2493..54ddaeb2 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -485,17 +485,18 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 asmlinkage int
 sys_sigsuspend(int history0, int history1, old_sigset_t mask)
 {
-	mask &= _BLOCKABLE;
-	spin_lock_irq(&current->sighand->siglock);
+	sigset_t blocked;
+
 	current->saved_sigmask = current->blocked;
-	siginitset(&current->blocked, mask);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+
+	mask &= _BLOCKABLE;
+	siginitset(&blocked, mask);
+	set_current_blocked(&blocked);
 
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
-	set_restore_sigmask();
 
+	set_restore_sigmask();
 	return -ERESTARTNOHAND;
 }
 
@@ -572,10 +573,7 @@ unsigned long sys_sigreturn(struct pt_regs *regs)
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->sc, &ax))
 		goto badframe;
@@ -653,11 +651,15 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 
 static int
 setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-	       sigset_t *set, struct pt_regs *regs)
+		struct pt_regs *regs)
 {
 	int usig = signr_convert(sig);
+	sigset_t *set = &current->blocked;
 	int ret;
 
+	if (current_thread_info()->status & TS_RESTORE_SIGMASK)
+		set = &current->saved_sigmask;
+
 	/* Set up the stack frame */
 	if (is_ia32) {
 		if (ka->sa.sa_flags & SA_SIGINFO)
@@ -672,12 +674,13 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		return -EFAULT;
 	}
 
+	current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
 	return ret;
 }
 
 static int
 handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
-	      sigset_t *oldset, struct pt_regs *regs)
+		struct pt_regs *regs)
 {
 	sigset_t blocked;
 	int ret;
@@ -712,20 +715,11 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	    likely(test_and_clear_thread_flag(TIF_FORCED_TF)))
 		regs->flags &= ~X86_EFLAGS_TF;
 
-	ret = setup_rt_frame(sig, ka, info, oldset, regs);
+	ret = setup_rt_frame(sig, ka, info, regs);
 
 	if (ret)
 		return ret;
 
-#ifdef CONFIG_X86_64
-	/*
-	 * This has nothing to do with segment registers,
-	 * despite the name.  This magic affects uaccess.h
-	 * macros' behavior.  Reset it to the normal setting.
-	 */
-	set_fs(USER_DS);
-#endif
-
 	/*
 	 * Clear the direction flag as per the ABI for function entry.
 	 */
@@ -767,7 +761,6 @@ static void do_signal(struct pt_regs *regs)
 	struct k_sigaction ka;
 	siginfo_t info;
 	int signr;
-	sigset_t *oldset;
 
 	/*
 	 * We want the common case to go fast, which is why we may in certain
@@ -779,23 +772,10 @@ static void do_signal(struct pt_regs *regs)
 	if (!user_mode(regs))
 		return;
 
-	if (current_thread_info()->status & TS_RESTORE_SIGMASK)
-		oldset = &current->saved_sigmask;
-	else
-		oldset = &current->blocked;
-
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 	if (signr > 0) {
 		/* Whee! Actually deliver the signal.  */
-		if (handle_signal(signr, &info, &ka, oldset, regs) == 0) {
-			/*
-			 * A signal was successfully delivered; the saved
-			 * sigmask will have been stored in the signal frame,
-			 * and will be restored by sigreturn, so we can simply
-			 * clear the TS_RESTORE_SIGMASK flag.
-			 */
-			current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
-		}
+		handle_signal(signr, &info, &ka, regs);
 		return;
 	}
 
@@ -823,7 +803,7 @@ static void do_signal(struct pt_regs *regs)
 	 */
 	if (current_thread_info()->status & TS_RESTORE_SIGMASK) {
 		current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
-		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
+		set_current_blocked(&current->saved_sigmask);
 	}
 }
 
