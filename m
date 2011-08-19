Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab1HSQu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:50:56 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:57378 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756526Ab1HSQsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:48:20 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 34/43] um: Don't restore current->blocked on error
Date: Fri, 19 Aug 2011 17:46:50 +0100
Message-Id: <1313772419-21951-35-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

If we fail to setup the signal stack frame then we don't need to
restore current->blocked because it is not modified by
setup_signal_stack_*.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Richard Weinberger <richard@nod.at>
Tested-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/um/kernel/signal.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/um/kernel/signal.c b/arch/um/kernel/signal.c
index 9aa5cba..9a5ffe1 100644
--- a/arch/um/kernel/signal.c
+++ b/arch/um/kernel/signal.c
@@ -66,13 +66,9 @@ static int handle_signal(struct pt_regs *regs, unsigned long signr,
 #endif
 		err = setup_signal_stack_si(sp, signr, ka, regs, info, oldset);
 
-	if (err) {
-		spin_lock_irq(&current->sighand->siglock);
-		current->blocked = *oldset;
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
+	if (err)
 		force_sigsegv(signr, current);
-	} else
+	else
 		block_sigmask(ka, signr);
 
 	return err;
-- 
1.7.4.4

