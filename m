Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289Ab2BNLmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:42:25 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:57668 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760195Ab2BNLmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:42:22 -0500
From: Matt Fleming <matt@console-pimps.org>
To: linux-arch@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 09/40] frv: Use set_current_blocked() and block_sigmask()
Date: Tue, 14 Feb 2012 11:40:42 +0000
Message-Id: <1329219673-28711-10-git-send-email-matt@console-pimps.org>
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
Cc: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/frv/kernel/signal.c |   32 ++++++++++----------------------
 1 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/arch/frv/kernel/signal.c b/arch/frv/kernel/signal.c
index bab0129..dfa460e 100644
--- a/arch/frv/kernel/signal.c
+++ b/arch/frv/kernel/signal.c
@@ -40,12 +40,13 @@ struct fdpic_func_descriptor {
  */
 asmlinkage int sys_sigsuspend(int history0, int history1, old_sigset_t mask)
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
@@ -158,10 +159,7 @@ asmlinkage int sys_sigreturn(void)
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(&frame->sc, &gr8))
 		goto badframe;
@@ -184,10 +182,7 @@ asmlinkage int sys_rt_sigreturn(void)
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(&frame->uc.uc_mcontext, &gr8))
 		goto badframe;
@@ -474,15 +469,8 @@ static int handle_signal(unsigned long sig, siginfo_t *info,
 	else
 		ret = setup_frame(sig, ka, oldset);
 
-	if (ret == 0) {
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked, &current->blocked,
-			  &ka->sa.sa_mask);
-		if (!(ka->sa.sa_flags & SA_NODEFER))
-			sigaddset(&current->blocked, sig);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
-	}
+	if (ret == 0)
+		block_sigmask(ka, sig);
 
 	return ret;
 
-- 
1.7.4.4

