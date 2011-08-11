Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259Ab1HKN6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:58:13 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60134 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751682Ab1HKN6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:58:06 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Chen Liqin <liqin.chen@sunplusct.com>,
        Lennox Wu <lennox.wu@gmail.com>
Subject: [PATCH 24/41] score: Don't mask signals if we fail to setup signal stack
Date: Thu, 11 Aug 2011 14:56:58 +0100
Message-Id: <1313071035-12047-25-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

If setup_rt_frame() returns -EFAULT then we must not block any signals
in the current process.

Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/score/kernel/signal.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/score/kernel/signal.c b/arch/score/kernel/signal.c
index aa57440..bf9e33e 100644
--- a/arch/score/kernel/signal.c
+++ b/arch/score/kernel/signal.c
@@ -272,12 +272,14 @@ static int handle_signal(unsigned long sig, siginfo_t *info,
 	 */
 	ret = setup_rt_frame(ka, regs, sig, oldset, info);
 
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&current->blocked, sig);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	if (ret == 0) {
+		spin_lock_irq(&current->sighand->siglock);
+		sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
+		if (!(ka->sa.sa_flags & SA_NODEFER))
+			sigaddset(&current->blocked, sig);
+		recalc_sigpending();
+		spin_unlock_irq(&current->sighand->siglock);
+	}
 
 	return ret;
 }
-- 
1.7.4.4

