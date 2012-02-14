Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760492Ab2BNLm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:42:59 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:57742 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760442Ab2BNLmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:42:46 -0500
From: Matt Fleming <matt@console-pimps.org>
To: linux-arch@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-am33-list@redhat.com
Subject: [PATCH 20/40] mn10300: Use set_current_blocked() and block_sigmask()
Date: Tue, 14 Feb 2012 11:40:53 +0000
Message-Id: <1329219673-28711-21-git-send-email-matt@console-pimps.org>
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
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-am33-list@redhat.com
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/mn10300/kernel/signal.c |   32 ++++++++++----------------------
 1 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/arch/mn10300/kernel/signal.c b/arch/mn10300/kernel/signal.c
index 690f4e9..bd77c6d 100644
--- a/arch/mn10300/kernel/signal.c
+++ b/arch/mn10300/kernel/signal.c
@@ -38,12 +38,13 @@
  */
 asmlinkage long sys_sigsuspend(int history0, int history1, old_sigset_t mask)
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
@@ -172,10 +173,7 @@ asmlinkage long sys_sigreturn(void)
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(current_frame(), &frame->sc, &d0))
 		goto badframe;
@@ -203,10 +201,7 @@ asmlinkage long sys_rt_sigreturn(void)
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(current_frame(), &frame->uc.uc_mcontext, &d0))
 		goto badframe;
@@ -476,15 +471,8 @@ static int handle_signal(int sig,
 	else
 		ret = setup_frame(sig, ka, oldset, regs);
 
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
 }
-- 
1.7.4.4

