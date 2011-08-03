Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab1HCJEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 05:04:54 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:57800 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753325Ab1HCJEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 05:04:42 -0400
Subject: avr32: handle_signal() bug?
From: Matt Fleming <matt@console-pimps.org>
To: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Aug 2011 10:04:39 +0100
Message-ID: <1312362279.10579.38.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey guys,

I was just looking at the code in handle_signal() and I got pretty
confused, specifically about this part...

	/*
	 * Set up the stack frame
	 */
	ret = setup_rt_frame(sig, ka, info, oldset, regs);

	/*
	 * Check that the resulting registers are sane
	 */
	ret |= !valid_user_regs(regs);

	/*
	 * Block the signal if we were unsuccessful.
	 */
	if (ret != 0 || !(ka->sa.sa_flags & SA_NODEFER)) {
		spin_lock_irq(&current->sighand->siglock);
		sigorsets(&current->blocked, &current->blocked,
			  &ka->sa.sa_mask);
		sigaddset(&current->blocked, sig);
		recalc_sigpending();
		spin_unlock_irq(&current->sighand->siglock);
	}

	if (ret == 0)
		return;

That doesn't look correct to me. Now, if we were unsuccessful in setting
up a signal frame, say, ret == -EFAULT, do we really want to block the
signal or any of the signals in the handler mask?

Is there some intricacy of the avr32 architecture that I'm missing here?
It looks to me like this code was copied from the arm implementation
from years ago before commit a6c61e9dfdd0 ("[ARM] 3168/1: Update ARM
signal delivery and masking").
    
How about this?

-------------8<-----------

>From 3fabe0f205b327dd82c2349a816f2574f2b78542 Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt.fleming@linux.intel.com>
Date: Wed, 3 Aug 2011 09:53:38 +0100
Subject: [PATCH] avr32: Don't mask signals in the error path

The current handle_signal() implementation is broken - it will mask
signals if we fail to setup the signal stack frame, which isn't the
desired behaviour, we should only be masking signals if we succeed in
setting up the stack frame. It looks like this code was copied from
the old (broken) arm implementation but wasn't updated when the arm
code was fixed in commit a6c61e9dfdd0 ("[ARM] 3168/1: Update ARM
signal delivery and masking").

Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
---
 arch/avr32/kernel/signal.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/avr32/kernel/signal.c b/arch/avr32/kernel/signal.c
index 64f886f..9c075e1 100644
--- a/arch/avr32/kernel/signal.c
+++ b/arch/avr32/kernel/signal.c
@@ -238,22 +238,21 @@ handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
 	 */
 	ret |= !valid_user_regs(regs);
 
+	if (ret != 0) {
+		force_sigsegv(sig, current);
+		return;
+	}
+
 	/*
-	 * Block the signal if we were unsuccessful.
+	 * Block the signal if we were successful.
 	 */
-	if (ret != 0 || !(ka->sa.sa_flags & SA_NODEFER)) {
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked, &current->blocked,
-			  &ka->sa.sa_mask);
+	spin_lock_irq(&current->sighand->siglock);
+	sigorsets(&current->blocked, &current->blocked,
+		  &ka->sa.sa_mask);
+	if (!(ka->sa.sa_flags & SA_NODEFER))
 		sigaddset(&current->blocked, sig);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
-	}
-
-	if (ret == 0)
-		return;
-
-	force_sigsegv(sig, current);
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
 }
 
 /*
-- 
1.7.4.4



