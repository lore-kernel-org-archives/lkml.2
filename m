Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab1HKN5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:57:48 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60044 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751522Ab1HKN50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:57:26 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [PATCH 06/41] cris: Use set_current_blocked()
Date: Thu, 11 Aug 2011 14:56:40 +0100
Message-Id: <1313071035-12047-7-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@linux.intel.com>

As described in e6fa16ab ("signal: sigprocmask() should do
retarget_shared_pending()") the modification of current->blocked is
incorrect as we need to check whether the signal we're about to block
is pending in the shared queue.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
---
 arch/cris/arch-v10/kernel/signal.c |   33 +++++++++++++------------------
 arch/cris/arch-v32/kernel/signal.c |   37 +++++++++++++----------------------
 2 files changed, 28 insertions(+), 42 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/signal.c b/arch/cris/arch-v10/kernel/signal.c
index e78fe49..9f8c29c 100644
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
@@ -469,13 +465,12 @@ static inline int handle_signal(int canrestart, unsigned long sig,
 		ret = setup_frame(sig, ka, oldset, regs);
 
 	if (ret == 0) {
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked, &current->blocked,
-			&ka->sa.sa_mask);
+		sigset_t blocked;
+
+		sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
 		if (!(ka->sa.sa_flags & SA_NODEFER))
-			sigaddset(&current->blocked, sig);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
+			sigaddset(&blocked, sig);
+		set_current_blocked(&blocked);
 	}
 	return ret;
 }
diff --git a/arch/cris/arch-v32/kernel/signal.c b/arch/cris/arch-v32/kernel/signal.c
index ce4ab1a..e493656 100644
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
@@ -516,13 +508,12 @@ handle_signal(int canrestart, unsigned long sig,
 		ka->sa.sa_handler = SIG_DFL;
 
 	if (ret == 0) {
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked, &current->blocked,
-			&ka->sa.sa_mask);
+		sigset_t blocked;
+
+		sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
 		if (!(ka->sa.sa_flags & SA_NODEFER))
-			sigaddset(&current->blocked, sig);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
+			sigaddset(&blocked, sig);
+		set_current_blocked(&blocked);
 	}
 
 	return ret;
-- 
1.7.4.4

