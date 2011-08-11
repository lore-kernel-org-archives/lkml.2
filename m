Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab1HKN6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:58:11 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60123 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752485Ab1HKN6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:58:04 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
        Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>
Subject: [PATCH 22/41] parisc: Use set_current_blocked()
Date: Thu, 11 Aug 2011 14:56:56 +0100
Message-Id: <1313071035-12047-23-git-send-email-matt@console-pimps.org>
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
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/parisc/kernel/signal.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/parisc/kernel/signal.c b/arch/parisc/kernel/signal.c
index 12c1ed3..4d64f72 100644
--- a/arch/parisc/kernel/signal.c
+++ b/arch/parisc/kernel/signal.c
@@ -131,10 +131,7 @@ sys_rt_sigreturn(struct pt_regs *regs, int in_syscall)
 	}
 		
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	/* Good thing we saved the old gr[30], eh? */
 #ifdef CONFIG_64BIT
@@ -447,6 +444,8 @@ static long
 handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 		sigset_t *oldset, struct pt_regs *regs, int in_syscall)
 {
+	sigset_t blocked;
+
 	DBG(1,"handle_signal: sig=%ld, ka=%p, info=%p, oldset=%p, regs=%p\n",
 	       sig, ka, info, oldset, regs);
 	
@@ -454,12 +453,10 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	if (!setup_rt_frame(sig, ka, info, oldset, regs, in_syscall))
 		return 0;
 
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
+	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
 	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&current->blocked,sig);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+		sigaddset(&blocked, sig);
+	set_current_blocked(&blocked);
 
 	tracehook_signal_handler(sig, info, ka, regs, 
 		test_thread_flag(TIF_SINGLESTEP) ||
-- 
1.7.4.4

