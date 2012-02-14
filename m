Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760183Ab2BNLl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:41:29 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:44692 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759905Ab2BNLlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:41:23 -0500
From: Matt Fleming <matt@console-pimps.org>
To: linux-arch@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-alpha@vger.kernel.org
Subject: [PATCH 01/40] alpha: Use set_current_blocked() and block_sigmask()
Date: Tue, 14 Feb 2012 11:40:34 +0000
Message-Id: <1329219673-28711-2-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
References: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

As described in e6fa16ab ("signal: sigprocmask() should do
retarget_shared_pending()") the modification of current->blocked is
incorrect as we need to check for shared signals we're about to block.

Also, use the new helper function introduced in commit 5e6292c0f28f
("signal: add block_sigmask() for adding sigmask to current->blocked")
which centralises the code for updating current->blocked after
successfully delivering a signal and reduces the amount of duplicate
code across architectures. In the past some architectures got this
code wrong, so using this helper function should stop that from
happening again.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-alpha@vger.kernel.org
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/alpha/kernel/signal.c |   31 ++++++++++---------------------
 1 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/arch/alpha/kernel/signal.c b/arch/alpha/kernel/signal.c
index 6f7feb5..35f2ef4 100644
--- a/arch/alpha/kernel/signal.c
+++ b/arch/alpha/kernel/signal.c
@@ -120,12 +120,13 @@ SYSCALL_DEFINE5(rt_sigaction, int, sig, const struct sigaction __user *, act,
  */
 SYSCALL_DEFINE1(sigsuspend, old_sigset_t, mask)
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
@@ -238,10 +239,7 @@ do_sigreturn(struct sigcontext __user *sc, struct pt_regs *regs,
 		goto give_sigsegv;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(sc, regs, sw))
 		goto give_sigsegv;
@@ -276,10 +274,7 @@ do_rt_sigreturn(struct rt_sigframe __user *frame, struct pt_regs *regs,
 		goto give_sigsegv;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(&frame->uc.uc_mcontext, regs, sw))
 		goto give_sigsegv;
@@ -501,14 +496,8 @@ handle_signal(int sig, struct k_sigaction *ka, siginfo_t *info,
 	else
 		ret = setup_frame(sig, ka, oldset, regs, sw);
 
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

