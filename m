Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab1HKN52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:57:28 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60040 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259Ab1HKN5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:57:25 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 05/41] blackfin: Use set_current_blocked()
Date: Thu, 11 Aug 2011 14:56:39 +0100
Message-Id: <1313071035-12047-6-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@linux.intel.com>

As described in e6fa16ab ("signal: sigprocmask() should do
retarget_shared_pending()") the modification of current->blocked is
incorrect as we need to check whether the signal we're about to block
is pending in the shared queue.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
---
 arch/blackfin/kernel/signal.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/blackfin/kernel/signal.c b/arch/blackfin/kernel/signal.c
index d536f35..96b8666 100644
--- a/arch/blackfin/kernel/signal.c
+++ b/arch/blackfin/kernel/signal.c
@@ -99,10 +99,7 @@ asmlinkage int do_rt_sigreturn(unsigned long __unused)
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_block(&set);
 
 	if (rt_restore_sigcontext(regs, &frame->uc.uc_mcontext, &r0))
 		goto badframe;
@@ -267,13 +264,12 @@ handle_signal(int sig, siginfo_t *info, struct k_sigaction *ka,
 	ret = setup_rt_frame(sig, ka, info, oldset, regs);
 
 	if (ret == 0) {
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked, &current->blocked,
-			  &ka->sa.sa_mask);
+		sigset_t blocked;
+
+		sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
 		if (!(ka->sa.sa_flags & SA_NODEFER))
-			sigaddset(&current->blocked, sig);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
+			sigaddset(&blocked, sig);
+		set_current_blocked(&blocked);
 	}
 	return ret;
 }
-- 
1.7.4.4

