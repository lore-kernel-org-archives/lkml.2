Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab1HKN5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:57:45 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60057 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751830Ab1HKN5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:57:37 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 09/41] ia64: Use set_current_blocked()
Date: Thu, 11 Aug 2011 14:56:43 +0100
Message-Id: <1313071035-12047-10-git-send-email-matt@console-pimps.org>
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
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/ia64/kernel/signal.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/ia64/kernel/signal.c b/arch/ia64/kernel/signal.c
index 7bdafc8..1261b2f 100644
--- a/arch/ia64/kernel/signal.c
+++ b/arch/ia64/kernel/signal.c
@@ -201,13 +201,7 @@ ia64_rt_sigreturn (struct sigscratch *scr)
 		goto give_sigsegv;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-
-	spin_lock_irq(&current->sighand->siglock);
-	{
-		current->blocked = set;
-		recalc_sigpending();
-	}
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(sc, scr))
 		goto give_sigsegv;
@@ -424,15 +418,15 @@ static long
 handle_signal (unsigned long sig, struct k_sigaction *ka, siginfo_t *info, sigset_t *oldset,
 	       struct sigscratch *scr)
 {
+	sigset_t blocked;
+
 	if (!setup_frame(sig, ka, info, oldset, scr))
 		return 0;
 
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
+	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
 	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&current->blocked, sig);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+		sigaddset(&blocked, sig);
+	set_current_blocked(&blocked);
 
 	/*
 	 * Let tracing know that we've done the handler setup.
-- 
1.7.4.4

