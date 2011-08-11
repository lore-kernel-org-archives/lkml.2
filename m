Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab1HKOFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:05:09 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60061 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751864Ab1HKN5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:57:38 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Hirokazu Takata <takata@linux-m32r.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Kyle McMartin <kyle@redhat.com>
Subject: [PATCH 10/41] m32r: Use set_current_blocked()
Date: Thu, 11 Aug 2011 14:56:44 +0100
Message-Id: <1313071035-12047-11-git-send-email-matt@console-pimps.org>
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
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kyle McMartin <kyle@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/m32r/kernel/signal.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/m32r/kernel/signal.c b/arch/m32r/kernel/signal.c
index a08697f..98f016a 100644
--- a/arch/m32r/kernel/signal.c
+++ b/arch/m32r/kernel/signal.c
@@ -112,10 +112,7 @@ sys_rt_sigreturn(unsigned long r0, unsigned long r1,
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &result))
 		goto badframe;
@@ -274,6 +271,8 @@ static int
 handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
 	      sigset_t *oldset, struct pt_regs *regs)
 {
+	sigset_t blocked;
+
 	/* Are we from a system call? */
 	if (regs->syscall_nr >= 0) {
 		/* If so, check system call restarting.. */
@@ -300,12 +299,11 @@ handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
 	if (setup_rt_frame(sig, ka, info, oldset, regs))
 		return -EFAULT;
 
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
+	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
 	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&current->blocked,sig);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+		sigaddset(&blocked, sig);
+	set_current_blocked(&blocked);
+
 	return 0;
 }
 
-- 
1.7.4.4

