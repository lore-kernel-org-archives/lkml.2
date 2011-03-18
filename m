Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758Ab1CRVyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:54:11 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56623 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932691Ab1CRVyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:54:01 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6289"; a="80848366"
X-IronPort-AV: E=Sophos;i="4.63,205,1299484800"; 
   d="scan'208";a="37044643"
From: Carl Vanderlip <carlv@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>, linux-fbdev@vger.kernel.org,
        Carl Vanderlip <carlv@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/20] video: msm: add locked_enable_mdp_irq function
Date: Fri, 18 Mar 2011 14:53:58 -0700
Message-Id: <1300485238-27004-1-git-send-email-carlv@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a version of this fuction to be called in a locked context.

Authors:
Dima Zavin <dima@android.com>
Rebecca Schultz Zavin <rebecca@android.com>
Colin Cross <ccross@android.com>

Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>
---
 drivers/video/msm/mdp.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
index a078028..9fb9f1a 100644
--- a/drivers/video/msm/mdp.c
+++ b/drivers/video/msm/mdp.c
@@ -47,14 +47,12 @@ static struct clk *clk;
 static unsigned int mdp_irq_mask;
 DEFINE_MUTEX(mdp_mutex);
 
-static int enable_mdp_irq(struct mdp_info *mdp, uint32_t mask)
+static int locked_enable_mdp_irq(struct mdp_info *mdp, uint32_t mask)
 {
-	unsigned long irq_flags;
 	int ret = 0;
 
 	BUG_ON(!mask);
 
-	spin_lock_irqsave(&mdp->lock, irq_flags);
 	/* if the mask bits are already set return an error, this interrupt
 	 * is already enabled */
 	if (mdp_irq_mask & mask) {
@@ -72,7 +70,17 @@ static int enable_mdp_irq(struct mdp_info *mdp, uint32_t mask)
 	/* update the irq mask to reflect the fact that the interrupt is
 	 * enabled */
 	mdp_irq_mask |= mask;
-	spin_unlock_irqrestore(&mdp->lock, irq_flags);
+	return 0;
+}
+
+static int enable_mdp_irq(struct mdp_info *mdp, uint32_t mask)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&mdp->lock, flags);
+	ret = locked_enable_mdp_irq(mdp, mask);
+	spin_unlock_irqrestore(&mdp->lock, flags);
 	return ret;
 }
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

