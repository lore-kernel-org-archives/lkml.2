Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760388Ab2BNLtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:49:22 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:57684 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760195Ab2BNLm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:42:26 -0500
From: Matt Fleming <matt@console-pimps.org>
To: linux-arch@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 12/40] ia64: Use set_current_blocked() and block_sigmask()
Date: Tue, 14 Feb 2012 11:40:45 +0000
Message-Id: <1329219673-28711-13-git-send-email-matt@console-pimps.org>
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
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/ia64/kernel/signal.c |   15 ++-------------
 1 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/arch/ia64/kernel/signal.c b/arch/ia64/kernel/signal.c
index 7bdafc8..7523501 100644
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
@@ -427,12 +421,7 @@ handle_signal (unsigned long sig, struct k_sigaction *ka, siginfo_t *info, sigse
 	if (!setup_frame(sig, ka, info, oldset, scr))
 		return 0;
 
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&current->blocked, sig);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	block_sigmask(ka, sig);
 
 	/*
 	 * Let tracing know that we've done the handler setup.
-- 
1.7.4.4

