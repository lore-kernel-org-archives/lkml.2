Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab2BNLqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:46:10 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:57855 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932328Ab2BNLn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:43:58 -0500
From: Matt Fleming <matt@console-pimps.org>
To: linux-arch@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH 33/40] tile: Use set_current_blocked() and block_sigmask()
Date: Tue, 14 Feb 2012 11:41:06 +0000
Message-Id: <1329219673-28711-34-git-send-email-matt@console-pimps.org>
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
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/tile/kernel/compat_signal.c |    5 +----
 arch/tile/kernel/signal.c        |   13 ++-----------
 2 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/arch/tile/kernel/compat_signal.c b/arch/tile/kernel/compat_signal.c
index a7869ad..77763cc 100644
--- a/arch/tile/kernel/compat_signal.c
+++ b/arch/tile/kernel/compat_signal.c
@@ -303,10 +303,7 @@ long compat_sys_rt_sigreturn(struct pt_regs *regs)
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext))
 		goto badframe;
diff --git a/arch/tile/kernel/signal.c b/arch/tile/kernel/signal.c
index bedaf4e..f79d4b8 100644
--- a/arch/tile/kernel/signal.c
+++ b/arch/tile/kernel/signal.c
@@ -97,10 +97,7 @@ SYSCALL_DEFINE1(rt_sigreturn, struct pt_regs *, regs)
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext))
 		goto badframe;
@@ -286,13 +283,7 @@ static int handle_signal(unsigned long sig, siginfo_t *info,
 		 * the work_pending path in the return-to-user code, and
 		 * either way we can re-enable interrupts unconditionally.
 		 */
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked,
-			  &current->blocked, &ka->sa.sa_mask);
-		if (!(ka->sa.sa_flags & SA_NODEFER))
-			sigaddset(&current->blocked, sig);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
+		block_sigmask(ka, sig);
 	}
 
 	return ret;
-- 
1.7.4.4

