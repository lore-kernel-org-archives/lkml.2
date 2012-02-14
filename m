Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307Ab2BNLm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:42:28 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:57674 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760218Ab2BNLmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:42:23 -0500
From: Matt Fleming <matt@console-pimps.org>
To: linux-arch@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH 10/40] h8300: Use set_current_blocked() and block_sigmask()
Date: Tue, 14 Feb 2012 11:40:43 +0000
Message-Id: <1329219673-28711-11-git-send-email-matt@console-pimps.org>
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
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/h8300/kernel/signal.c |   33 +++++++++------------------------
 1 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/arch/h8300/kernel/signal.c b/arch/h8300/kernel/signal.c
index af842c3..cd63f5a 100644
--- a/arch/h8300/kernel/signal.c
+++ b/arch/h8300/kernel/signal.c
@@ -57,14 +57,13 @@ asmlinkage int do_signal(struct pt_regs *regs, sigset_t *oldset);
 asmlinkage int do_sigsuspend(struct pt_regs *regs)
 {
 	old_sigset_t mask = regs->er3;
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
 
 	regs->er0 = -EINTR;
 	while (1) {
@@ -90,11 +89,8 @@ do_rt_sigsuspend(struct pt_regs *regs)
 		return -EFAULT;
 	sigdelsetmask(&newset, ~_BLOCKABLE);
 
-	spin_lock_irq(&current->sighand->siglock);
 	saveset = current->blocked;
-	current->blocked = newset;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&newset);
 
 	regs->er0 = -EINTR;
 	while (1) {
@@ -232,10 +228,7 @@ asmlinkage int do_sigreturn(unsigned long __unused,...)
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 	
 	if (restore_sigcontext(regs, &frame->sc, &er0))
 		goto badframe;
@@ -260,10 +253,7 @@ asmlinkage int do_rt_sigreturn(unsigned long __unused,...)
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_unlock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_lock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 	
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &er0))
 		goto badframe;
@@ -489,12 +479,7 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	else
 		setup_frame(sig, ka, oldset, regs);
 
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&current->blocked,sig);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	block_sigmask(ka, sig);
 }
 
 /*
-- 
1.7.4.4

