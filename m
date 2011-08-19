Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab1HSQsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:48:41 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:57382 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756387Ab1HSQsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:48:31 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [PATCH v2 35/43] unicore32: Use set_current_blocked() and block_sigmask()
Date: Fri, 19 Aug 2011 17:46:51 +0100
Message-Id: <1313772419-21951-36-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

As described in e6fa16ab ("signal: sigprocmask() should do
retarget_shared_pending()") the modification of current->blocked is
incorrect as we need to check whether the signal we're about to block
is pending in the shared queue.

Also, use the new helper function block_sigmask() which centralises
the code for updating current->blocked after successfully delivering a
signal and reduces the amount of duplicate code across
architectures. In the past some architectures got this code wrong, so
using this helper function should stop that from happening again.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---

v2 of this patch depends on "[PATCH 01/43] signal: Add block_sigmask()
for adding sigmask to current->blocked" so they need to go through the
same tree but this patch would benefit from some maintainer ACK's.

Guan, I dropped your Acked-by because I felt this patch changed quite
dramatically since v1 and warrants another review. I hope that's OK.

 arch/unicore32/kernel/signal.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/unicore32/kernel/signal.c b/arch/unicore32/kernel/signal.c
index b163fca..960c029 100644
--- a/arch/unicore32/kernel/signal.c
+++ b/arch/unicore32/kernel/signal.c
@@ -63,10 +63,7 @@ static int restore_sigframe(struct pt_regs *regs, struct sigframe __user *sf)
 	err = __copy_from_user(&set, &sf->uc.uc_sigmask, sizeof(set));
 	if (err == 0) {
 		sigdelsetmask(&set, ~_BLOCKABLE);
-		spin_lock_irq(&current->sighand->siglock);
-		current->blocked = set;
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
+		set_current_blocked(&set);
 	}
 
 	err |= __get_user(regs->UCreg_00, &sf->uc.uc_mcontext.regs.UCreg_00);
@@ -372,13 +369,7 @@ static int handle_signal(unsigned long sig, struct k_sigaction *ka,
 	/*
 	 * Block the signal if we were successful.
 	 */
-	spin_lock_irq(&tsk->sighand->siglock);
-	sigorsets(&tsk->blocked, &tsk->blocked,
-		  &ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&tsk->blocked, sig);
-	recalc_sigpending();
-	spin_unlock_irq(&tsk->sighand->siglock);
+	block_sigmask(ka, sig);
 
 	return 0;
 }
-- 
1.7.4.4

