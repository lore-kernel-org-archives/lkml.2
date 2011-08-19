Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab1HSQwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:52:16 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:57362 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932075Ab1HSQsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:48:06 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH v2 30/43] sh: Use set_current_blocked() and block_sigmask()
Date: Fri, 19 Aug 2011 17:46:46 +0100
Message-Id: <1313772419-21951-31-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

As described in e6fa16ab ("signal: sigprocmask() should do
retarget_shared_pending()") the modification of current->blocked is
incorrect as we need to check whether the signal we're about to block
is pending in the shared queue.

Also, use the new helper function block_sigmask() which centralises
the code for updating current->blocked after successfully delivering a
signal and reduces the amount of duplicate code across
architectures. In the past some architectures got this code wrong, so
using this helper function should stop that from happening again.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---

v2 of this patch depends on "[PATCH 01/43] signal: Add block_sigmask()
for adding sigmask to current->blocked" so they need to go through the
same tree but this patch would benefit from some maintainer ACK's.

 arch/sh/kernel/signal_32.c |   32 ++++++++++----------------------
 arch/sh/kernel/signal_64.c |   37 ++++++++++---------------------------
 2 files changed, 20 insertions(+), 49 deletions(-)

diff --git a/arch/sh/kernel/signal_32.c b/arch/sh/kernel/signal_32.c
index 7a00304..68ecb69 100644
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
@@ -548,14 +542,8 @@ handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
 	else
 		ret = setup_frame(sig, ka, oldset, regs);
 
-	if (ret == 0) {
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
-		if (!(ka->sa.sa_flags & SA_NODEFER))
-			sigaddset(&current->blocked,sig);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
-	}
+	if (ret == 0)
+		block_sigmask(ka, sig);
 
 	return ret;
 }
diff --git a/arch/sh/kernel/signal_64.c b/arch/sh/kernel/signal_64.c
index c0e7d10..cc94365 100644
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
@@ -738,14 +727,8 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	else
 		ret = setup_frame(sig, ka, oldset, regs);
 
-	if (ret == 0) {
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
-		if (!(ka->sa.sa_flags & SA_NODEFER))
-			sigaddset(&current->blocked,sig);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
-	}
+	if (ret == 0)
+		block_sigmask(ka, sig);
 
 	return ret;
 }
-- 
1.7.4.4

