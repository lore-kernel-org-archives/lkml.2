Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760299Ab2BNLuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:50:22 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:57660 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760199Ab2BNLmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:42:11 -0500
From: Matt Fleming <matt@console-pimps.org>
To: linux-arch@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: [PATCH 08/40] cris: Use set_current_blocked() and block_sigmask()
Date: Tue, 14 Feb 2012 11:40:41 +0000
Message-Id: <1329219673-28711-9-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
References: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

As described in e6fa16ab ("signal: sigprocmask() should do
retarget_shared_pending()") the modification of current->blocked is
incorrect as we need to check whether the signal we're about to block
is pending in the shared queue.

Also, use the new helper function introduced in commit 5e6292c0f28f
("signal: add block_sigmask() for adding sigmask to current->blocked")
which centralises the code for updating current->blocked after
successfully delivering a signal and reduces the amount of duplicate
code across architectures. In the past some architectures got this
code wrong, so using this helper function should stop that from
happening again.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/cris/arch-v10/kernel/signal.c |   34 +++++++++++---------------------
 arch/cris/arch-v32/kernel/signal.c |   37 ++++++++++-------------------------
 2 files changed, 23 insertions(+), 48 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/signal.c b/arch/cris/arch-v10/kernel/signal.c
index e78fe49..a6e1ff0 100644
--- a/arch/cris/arch-v10/kernel/signal.c
+++ b/arch/cris/arch-v10/kernel/signal.c
@@ -50,12 +50,14 @@ void do_signal(int canrestart, struct pt_regs *regs);
 int sys_sigsuspend(old_sigset_t mask, long r11, long r12, long r13, long mof,
 	long srp, struct pt_regs *regs)
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
+
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
 	set_thread_flag(TIF_RESTORE_SIGMASK);
@@ -184,10 +186,7 @@ asmlinkage int sys_sigreturn(long r10, long r11, long r12, long r13, long mof,
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->sc))
 		goto badframe;
@@ -223,10 +222,7 @@ asmlinkage int sys_rt_sigreturn(long r10, long r11, long r12, long r13,
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext))
 		goto badframe;
@@ -468,15 +464,9 @@ static inline int handle_signal(int canrestart, unsigned long sig,
 	else
 		ret = setup_frame(sig, ka, oldset, regs);
 
-	if (ret == 0) {
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked, &current->blocked,
-			&ka->sa.sa_mask);
-		if (!(ka->sa.sa_flags & SA_NODEFER))
-			sigaddset(&current->blocked, sig);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
-	}
+	if (ret == 0)
+		block_sigmask(ka, sig);
+
 	return ret;
 }
 
diff --git a/arch/cris/arch-v32/kernel/signal.c b/arch/cris/arch-v32/kernel/signal.c
index ce4ab1a..e7ea1ea 100644
--- a/arch/cris/arch-v32/kernel/signal.c
+++ b/arch/cris/arch-v32/kernel/signal.c
@@ -62,12 +62,14 @@ int
 sys_sigsuspend(old_sigset_t mask, long r11, long r12, long r13, long mof,
 	       long srp, struct pt_regs *regs)
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
+
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
 	set_thread_flag(TIF_RESTORE_SIGMASK);
@@ -176,12 +178,7 @@ sys_sigreturn(long r10, long r11, long r12, long r13, long mof, long srp,
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-
-	current->blocked = set;
-
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->sc))
 		goto badframe;
@@ -222,12 +219,7 @@ sys_rt_sigreturn(long r10, long r11, long r12, long r13, long mof, long srp,
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-
-	current->blocked = set;
-
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext))
 		goto badframe;
@@ -515,15 +507,8 @@ handle_signal(int canrestart, unsigned long sig,
 	if (ka->sa.sa_flags & SA_ONESHOT)
 		ka->sa.sa_handler = SIG_DFL;
 
-	if (ret == 0) {
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked, &current->blocked,
-			&ka->sa.sa_mask);
-		if (!(ka->sa.sa_flags & SA_NODEFER))
-			sigaddset(&current->blocked, sig);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
-	}
+	if (ret == 0)
+		block_sigmask(ka, sig);
 
 	return ret;
 }
-- 
1.7.4.4

