Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab1HKOBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:01:11 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60158 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332Ab1HKN6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:58:14 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 29/41] tile: Use set_current_blocked()
Date: Thu, 11 Aug 2011 14:57:03 +0100
Message-Id: <1313071035-12047-30-git-send-email-matt@console-pimps.org>
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
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/tile/kernel/compat_signal.c |    5 +----
 arch/tile/kernel/signal.c        |   16 ++++++----------
 2 files changed, 7 insertions(+), 14 deletions(-)

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
index bedaf4e..6ddceec 100644
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
@@ -286,13 +283,12 @@ static int handle_signal(unsigned long sig, siginfo_t *info,
 		 * the work_pending path in the return-to-user code, and
 		 * either way we can re-enable interrupts unconditionally.
 		 */
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked,
-			  &current->blocked, &ka->sa.sa_mask);
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

