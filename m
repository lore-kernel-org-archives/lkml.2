Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab1HKOCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:02:16 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60141 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752536Ab1HKN6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:58:07 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Chen Liqin <liqin.chen@sunplusct.com>,
        Lennox Wu <lennox.wu@gmail.com>
Subject: [PATCH 25/41] score: Use set_current_blocked()
Date: Thu, 11 Aug 2011 14:56:59 +0100
Message-Id: <1313071035-12047-26-git-send-email-matt@console-pimps.org>
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
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/score/kernel/signal.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/score/kernel/signal.c b/arch/score/kernel/signal.c
index bf9e33e..3ba0298 100644
--- a/arch/score/kernel/signal.c
+++ b/arch/score/kernel/signal.c
@@ -159,10 +159,7 @@ score_rt_sigreturn(struct pt_regs *regs)
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	sig = restore_sigcontext(regs, &frame->rs_uc.uc_mcontext);
 	if (sig < 0)
@@ -273,12 +270,12 @@ static int handle_signal(unsigned long sig, siginfo_t *info,
 	ret = setup_rt_frame(ka, regs, sig, oldset, info);
 
 	if (ret == 0) {
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
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
-- 
1.7.4.4

