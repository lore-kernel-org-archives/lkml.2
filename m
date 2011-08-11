Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab1HKN6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:58:15 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60150 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752591Ab1HKN6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:58:11 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 27/41] sh: Use set_current_blocked()
Date: Thu, 11 Aug 2011 14:57:01 +0100
Message-Id: <1313071035-12047-28-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

As described in e6fa16ab ("signal: sigprocmask() should do
retarget_shared_pending()") the modification of current->blocked is
incorrect as we need to check whether the signal we're about to block
is pending in the shared queue.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/sh/kernel/signal_32.c |   32 +++++++++++++-------------------
 arch/sh/kernel/signal_64.c |   37 +++++++++++++------------------------
 2 files changed, 26 insertions(+), 43 deletions(-)

diff --git a/arch/sh/kernel/signal_32.c b/arch/sh/kernel/signal_32.c
index 7a00304..c97705f 100644
--- a/arch/sh/kernel/signal_32.c
+++ b/arch/sh/kernel/signal_32.c
@@ -58,12 +58,13 @@ sys_sigsuspend(old_sigset_t mask,
 	       unsigned long r5, unsigned long r6, unsigned long r7,
 	       struct pt_regs __regs)
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
@@ -240,11 +241,7 @@ asmlinkage int sys_sigreturn(unsigned long r4, unsigned long r5,
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->sc, &r0))
 		goto badframe;
@@ -274,10 +271,7 @@ asmlinkage int sys_rt_sigreturn(unsigned long r4, unsigned long r5,
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &r0))
 		goto badframe;
@@ -549,12 +543,12 @@ handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
 		ret = setup_frame(sig, ka, oldset, regs);
 
 	if (ret == 0) {
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
+		sigset_t blocked;
+
+		sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
 		if (!(ka->sa.sa_flags & SA_NODEFER))
-			sigaddset(&current->blocked,sig);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
+			sigaddset(&blocked, sig);
+		set_current_blocked(&blocked);
 	}
 
 	return ret;
diff --git a/arch/sh/kernel/signal_64.c b/arch/sh/kernel/signal_64.c
index c0e7d10..14d5ed4 100644
--- a/arch/sh/kernel/signal_64.c
+++ b/arch/sh/kernel/signal_64.c
@@ -163,14 +163,13 @@ sys_sigsuspend(old_sigset_t mask,
 	       unsigned long r6, unsigned long r7,
 	       struct pt_regs * regs)
 {
-	sigset_t saveset;
+	sigset_t saveset, blocked;
 
-	mask &= _BLOCKABLE;
-	spin_lock_irq(&current->sighand->siglock);
 	saveset = current->blocked;
-	siginitset(&current->blocked, mask);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+
+	mask &= _BLOCKABLE;
+	siginitset(&blocked, mask);
+	set_current_blocked(&blocked);
 
 	REF_REG_RET = -EINTR;
 	while (1) {
@@ -202,11 +201,8 @@ sys_rt_sigsuspend(sigset_t *unewset, size_t sigsetsize,
 	if (copy_from_user(&newset, unewset, sizeof(newset)))
 		return -EFAULT;
 	sigdelsetmask(&newset, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
 	saveset = current->blocked;
-	current->blocked = newset;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&newset);
 
 	REF_REG_RET = -EINTR;
 	while (1) {
@@ -412,11 +408,7 @@ asmlinkage int sys_sigreturn(unsigned long r2, unsigned long r3,
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->sc, &ret))
 		goto badframe;
@@ -449,10 +441,7 @@ asmlinkage int sys_rt_sigreturn(unsigned long r2, unsigned long r3,
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &ret))
 		goto badframe;
@@ -739,12 +728,12 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 		ret = setup_frame(sig, ka, oldset, regs);
 
 	if (ret == 0) {
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
+		sigset_t blocked;
+
+		sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
 		if (!(ka->sa.sa_flags & SA_NODEFER))
-			sigaddset(&current->blocked,sig);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
+			sigaddset(&blocked, sig);
+		set_current_blocked(&blocked);
 	}
 
 	return ret;
-- 
1.7.4.4

