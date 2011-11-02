Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933877Ab1KBSn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:43:27 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18091 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056Ab1KBShB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:37:01 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133706963"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 08/34] msm: clock: Enable/disable parent clocks generically
Date: Wed,  2 Nov 2011 11:36:05 -0700
Message-Id: <1320258991-22325-9-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

Enable the parent clocks whenever a clock is enabled and disable
a parent clock whenever a clock is disabled. This simplifies
sub-driver code by centralizing the parent enabling in the
top-level.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/clock.c |   33 +++++++++++++++++++++++++++++----
 1 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-msm/clock.c b/arch/arm/mach-msm/clock.c
index 8508c17..026bdc0 100644
--- a/arch/arm/mach-msm/clock.c
+++ b/arch/arm/mach-msm/clock.c
@@ -31,24 +31,49 @@
  */
 int clk_enable(struct clk *clk)
 {
+	int ret = 0;
 	unsigned long flags;
+	struct clk *parent;
+
+	if (!clk)
+		return 0;
+
 	spin_lock_irqsave(&clk->lock, flags);
+	if (clk->count == 0) {
+		parent = clk_get_parent(clk);
+		ret = clk_enable(parent);
+		if (ret)
+			goto out;
+
+		ret = clk->ops->enable(clk);
+		if (ret) {
+			clk_disable(parent);
+			goto out;
+		}
+	}
 	clk->count++;
-	if (clk->count == 1)
-		clk->ops->enable(clk);
+out:
 	spin_unlock_irqrestore(&clk->lock, flags);
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(clk_enable);
 
 void clk_disable(struct clk *clk)
 {
 	unsigned long flags;
+	struct clk *parent;
+
+	if (!clk)
+		return;
+
 	spin_lock_irqsave(&clk->lock, flags);
 	BUG_ON(clk->count == 0);
 	clk->count--;
-	if (clk->count == 0)
+	if (clk->count == 0) {
 		clk->ops->disable(clk);
+		parent = clk_get_parent(clk);
+		clk_disable(parent);
+	}
 	spin_unlock_irqrestore(&clk->lock, flags);
 }
 EXPORT_SYMBOL(clk_disable);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

