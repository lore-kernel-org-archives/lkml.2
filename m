Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab1HKN5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:57:42 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60053 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751803Ab1HKN5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:57:36 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH 08/41] h8300: Use set_current_blocked()
Date: Thu, 11 Aug 2011 14:56:42 +0100
Message-Id: <1313071035-12047-9-git-send-email-matt@console-pimps.org>
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
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/h8300/kernel/signal.c |   36 +++++++++++++-----------------------
 1 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/arch/h8300/kernel/signal.c b/arch/h8300/kernel/signal.c
index af842c3..4c06f98 100644
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
@@ -463,6 +453,8 @@ static void
 handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	      sigset_t *oldset,	struct pt_regs * regs)
 {
+	sigset_t blocked;
+
 	/* are we from a system call? */
 	if (regs->orig_er0 >= 0) {
 		switch (regs->er0) {
@@ -489,12 +481,10 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	else
 		setup_frame(sig, ka, oldset, regs);
 
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
+	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
 	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&current->blocked,sig);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+		sigaddset(&blocked, sig);
+	set_current_blocked(&blocked);
 }
 
 /*
-- 
1.7.4.4

