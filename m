Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab1HKOCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:02:45 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60129 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752497Ab1HKN6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:58:05 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 23/41] powerpc: Use set_current_blocked()
Date: Thu, 11 Aug 2011 14:56:57 +0100
Message-Id: <1313071035-12047-24-git-send-email-matt@console-pimps.org>
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
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/powerpc/kernel/signal.c    |   16 ++++++----------
 arch/powerpc/kernel/signal_32.c |   11 ++++++-----
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
index 2300426..8f6731f 100644
--- a/arch/powerpc/kernel/signal.c
+++ b/arch/powerpc/kernel/signal.c
@@ -56,10 +56,7 @@ void __user * get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
 void restore_sigmask(sigset_t *set)
 {
 	sigdelsetmask(set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = *set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(set);
 }
 
 static void check_syscall_restart(struct pt_regs *regs, struct k_sigaction *ka,
@@ -167,13 +164,12 @@ static int do_signal_pending(sigset_t *oldset, struct pt_regs *regs)
 
 	regs->trap = 0;
 	if (ret) {
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked, &current->blocked,
-			  &ka.sa.sa_mask);
+		sigset_t blocked;
+
+		sigorsets(&blocked, &current->blocked, &ka.sa.sa_mask);
 		if (!(ka.sa.sa_flags & SA_NODEFER))
-			sigaddset(&current->blocked, signr);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
+			sigaddset(&blocked, signr);
+		set_current_blocked(&blocked);
 
 		/*
 		 * A signal was successfully delivered; the saved sigmask is in
diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index 78b76dc..5fc9d19 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -242,12 +242,13 @@ static inline int restore_general_regs(struct pt_regs *regs,
  */
 long sys_sigsuspend(old_sigset_t mask)
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
-- 
1.7.4.4

