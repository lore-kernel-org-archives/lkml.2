Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353Ab1KBShD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:37:03 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18091 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363Ab1KBSg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:36:57 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133706949"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 04/34] msm: clock: Support one lock per clock
Date: Wed,  2 Nov 2011 11:36:01 -0700
Message-Id: <1320258991-22325-5-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/clock.c |   19 +++++++++++--------
 arch/arm/mach-msm/clock.h |    2 ++
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-msm/clock.c b/arch/arm/mach-msm/clock.c
index a9dabde..aa4a450 100644
--- a/arch/arm/mach-msm/clock.c
+++ b/arch/arm/mach-msm/clock.c
@@ -26,19 +26,17 @@
 
 #include "clock.h"
 
-static DEFINE_SPINLOCK(clocks_lock);
-
 /*
  * Standard clock functions defined in include/linux/clk.h
  */
 int clk_enable(struct clk *clk)
 {
 	unsigned long flags;
-	spin_lock_irqsave(&clocks_lock, flags);
+	spin_lock_irqsave(&clk->lock, flags);
 	clk->count++;
 	if (clk->count == 1)
 		clk->ops->enable(clk);
-	spin_unlock_irqrestore(&clocks_lock, flags);
+	spin_unlock_irqrestore(&clk->lock, flags);
 	return 0;
 }
 EXPORT_SYMBOL(clk_enable);
@@ -46,12 +44,12 @@ EXPORT_SYMBOL(clk_enable);
 void clk_disable(struct clk *clk)
 {
 	unsigned long flags;
-	spin_lock_irqsave(&clocks_lock, flags);
+	spin_lock_irqsave(&clk->lock, flags);
 	BUG_ON(clk->count == 0);
 	clk->count--;
 	if (clk->count == 0)
 		clk->ops->disable(clk);
-	spin_unlock_irqrestore(&clocks_lock, flags);
+	spin_unlock_irqrestore(&clk->lock, flags);
 }
 EXPORT_SYMBOL(clk_disable);
 
@@ -137,8 +135,13 @@ static unsigned msm_num_clocks;
 
 void __init msm_clock_init(struct clk_lookup *clock_tbl, size_t num_clocks)
 {
+	unsigned n;
+
 	clkdev_add_table(clock_tbl, num_clocks);
 
+	for (n = 0; n < num_clocks; n++)
+		spin_lock_init(&clock_tbl[n].clk->lock);
+
 	ebi1_clk = clk_get(NULL, "ebi1_clk");
 	BUG_ON(ebi1_clk == NULL);
 
@@ -161,12 +164,12 @@ static int __init clock_late_init(void)
 
 		clock_debug_add(clk);
 		if (clk->flags & CLKFLAG_AUTO_OFF) {
-			spin_lock_irqsave(&clocks_lock, flags);
+			spin_lock_irqsave(&clk->lock, flags);
 			if (!clk->count) {
 				count++;
 				clk->ops->auto_off(clk);
 			}
-			spin_unlock_irqrestore(&clocks_lock, flags);
+			spin_unlock_irqrestore(&clk->lock, flags);
 		}
 	}
 	pr_info("clock_late_init() disabled %d unused clocks\n", count);
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index 7fe1598..89506a8 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -19,6 +19,7 @@
 
 #include <linux/init.h>
 #include <linux/list.h>
+#include <linux/spinlock.h>
 #include <mach/clk.h>
 
 #define CLKFLAG_INVERT			0x00000001
@@ -53,6 +54,7 @@ struct clk {
 	uint32_t flags;
 	struct clk_ops *ops;
 	const char *dbg_name;
+	spinlock_t lock;
 };
 
 #define OFF CLKFLAG_AUTO_OFF
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

