Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab2BNLnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:43:45 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:57814 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760555Ab2BNLnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:43:24 -0500
From: Matt Fleming <matt@console-pimps.org>
To: linux-arch@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: [PATCH 28/40] score: Don't mask signals if we fail to setup signal stack
Date: Tue, 14 Feb 2012 11:41:01 +0000
Message-Id: <1329219673-28711-29-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
References: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

If setup_rt_frame() returns -EFAULT then we must not block any signals
in the current process.

Acked-by: Oleg Nesterov <oleg@redhat.com>
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

