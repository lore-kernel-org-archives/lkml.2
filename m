Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab1HKN7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:59:53 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60187 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752760Ab1HKN6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:58:40 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Chris Zankel <chris@zankel.net>
Subject: [PATCH 36/41] xtensa: Use set_current_blocked()
Date: Thu, 11 Aug 2011 14:57:10 +0100
Message-Id: <1313071035-12047-37-git-send-email-matt@console-pimps.org>
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
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/xtensa/kernel/signal.c |   19 ++++++-------------
 1 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/arch/xtensa/kernel/signal.c b/arch/xtensa/kernel/signal.c
index 17ceab8..4df5da5 100644
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
@@ -487,6 +481,7 @@ int do_signal(struct pt_regs *regs, sigset_t *oldset)
 	siginfo_t info;
 	int signr;
 	struct k_sigaction ka;
+	sigset_t blocked;
 
 	if (!user_mode(regs))
 		return 0;
@@ -539,12 +534,10 @@ int do_signal(struct pt_regs *regs, sigset_t *oldset)
 		if (ret)
 			return ret;
 
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked, &current->blocked, &ka.sa.sa_mask);
+		sigorsets(&blocked, &current->blocked, &ka.sa.sa_mask);
 		if (!(ka.sa.sa_flags & SA_NODEFER))
-			sigaddset(&current->blocked, signr);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
+			sigaddset(&blocked, signr);
+		set_current_blocked(&blocked);
 		if (current->ptrace & PT_SINGLESTEP)
 			task_pt_regs(current)->icountlevel = 1;
 
-- 
1.7.4.4

