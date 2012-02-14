Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760624Ab2BNLoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:44:23 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:57893 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760585Ab2BNLoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:44:05 -0500
From: Matt Fleming <matt@console-pimps.org>
To: linux-arch@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Chris Zankel <chris@zankel.net>
Subject: [PATCH 40/40] xtensa: Use set_current_blocked() and block_sigmask()
Date: Tue, 14 Feb 2012 11:41:13 +0000
Message-Id: <1329219673-28711-41-git-send-email-matt@console-pimps.org>
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
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/xtensa/kernel/signal.c |   17 +++--------------
 1 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/arch/xtensa/kernel/signal.c b/arch/xtensa/kernel/signal.c
index 17ceab8..b69b000 100644
--- a/arch/xtensa/kernel/signal.c
+++ b/arch/xtensa/kernel/signal.c
@@ -260,10 +260,7 @@ asmlinkage long xtensa_rt_sigreturn(long a0, long a1, long a2, long a3,
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, frame))
 		goto badframe;
@@ -448,11 +445,8 @@ asmlinkage long xtensa_rt_sigsuspend(sigset_t __user *unewset,
 		return -EFAULT;
 
 	sigdelsetmask(&newset, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
 	saveset = current->blocked;
-	current->blocked = newset;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&newset);
 
 	regs->areg[2] = -EINTR;
 	while (1) {
@@ -539,12 +533,7 @@ int do_signal(struct pt_regs *regs, sigset_t *oldset)
 		if (ret)
 			return ret;
 
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked, &current->blocked, &ka.sa.sa_mask);
-		if (!(ka.sa.sa_flags & SA_NODEFER))
-			sigaddset(&current->blocked, signr);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
+		block_sigmask(&ka, signr);
 		if (current->ptrace & PT_SINGLESTEP)
 			task_pt_regs(current)->icountlevel = 1;
 
-- 
1.7.4.4

