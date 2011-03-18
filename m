Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743Ab1CRVx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:53:28 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47918 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694Ab1CRVxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:53:22 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6289"; a="80646796"
X-IronPort-AV: E=Sophos;i="4.63,205,1299484800"; 
   d="scan'208";a="37044612"
From: Carl Vanderlip <carlv@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>, linux-fbdev@vger.kernel.org,
        Carl Vanderlip <carlv@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/20] video: msm: add spinlock to mdp_info struct
Date: Fri, 18 Mar 2011 14:53:09 -0700
Message-Id: <1300485189-26964-1-git-send-email-carlv@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the mdp_lock into the mdp_info struct for easier access.

Authors:
Dima Zavin <dima@android.com>
Rebecca Schultz Zavin <rebecca@android.com>
Colin Cross <ccross@android.com>

Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>
---
 drivers/video/msm/mdp.c    |   27 ++++++++++++++-------------
 drivers/video/msm/mdp_hw.h |    3 ++-
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
index 45af97d..a078028 100644
--- a/drivers/video/msm/mdp.c
+++ b/drivers/video/msm/mdp.c
@@ -45,7 +45,6 @@ static DECLARE_WAIT_QUEUE_HEAD(mdp_ppp_waitqueue);
 static struct msmfb_callback *dma_callback;
 static struct clk *clk;
 static unsigned int mdp_irq_mask;
-static DEFINE_SPINLOCK(mdp_lock);
 DEFINE_MUTEX(mdp_mutex);
 
 static int enable_mdp_irq(struct mdp_info *mdp, uint32_t mask)
@@ -55,7 +54,7 @@ static int enable_mdp_irq(struct mdp_info *mdp, uint32_t mask)
 
 	BUG_ON(!mask);
 
-	spin_lock_irqsave(&mdp_lock, irq_flags);
+	spin_lock_irqsave(&mdp->lock, irq_flags);
 	/* if the mask bits are already set return an error, this interrupt
 	 * is already enabled */
 	if (mdp_irq_mask & mask) {
@@ -73,7 +72,7 @@ static int enable_mdp_irq(struct mdp_info *mdp, uint32_t mask)
 	/* update the irq mask to reflect the fact that the interrupt is
 	 * enabled */
 	mdp_irq_mask |= mask;
-	spin_unlock_irqrestore(&mdp_lock, irq_flags);
+	spin_unlock_irqrestore(&mdp->lock, irq_flags);
 	return ret;
 }
 
@@ -102,9 +101,9 @@ static int disable_mdp_irq(struct mdp_info *mdp, uint32_t mask)
 	unsigned long irq_flags;
 	int ret;
 
-	spin_lock_irqsave(&mdp_lock, irq_flags);
+	spin_lock_irqsave(&mdp->lock, irq_flags);
 	ret = locked_disable_mdp_irq(mdp, mask);
-	spin_unlock_irqrestore(&mdp_lock, irq_flags);
+	spin_unlock_irqrestore(&mdp->lock, irq_flags);
 	return ret;
 }
 
@@ -114,7 +113,7 @@ static irqreturn_t mdp_isr(int irq, void *data)
 	unsigned long irq_flags;
 	struct mdp_info *mdp = data;
 
-	spin_lock_irqsave(&mdp_lock, irq_flags);
+	spin_lock_irqsave(&mdp->lock, irq_flags);
 
 	status = mdp_readl(mdp, MDP_INTR_STATUS);
 	mdp_writel(mdp, status, MDP_INTR_CLEAR);
@@ -134,18 +133,18 @@ static irqreturn_t mdp_isr(int irq, void *data)
 	if (status)
 		locked_disable_mdp_irq(mdp, status);
 
-	spin_unlock_irqrestore(&mdp_lock, irq_flags);
+	spin_unlock_irqrestore(&mdp->lock, irq_flags);
 	return IRQ_HANDLED;
 }
 
-static uint32_t mdp_check_mask(uint32_t mask)
+static uint32_t mdp_check_mask(struct mdp_info *mdp, uint32_t mask)
 {
 	uint32_t ret;
 	unsigned long irq_flags;
 
-	spin_lock_irqsave(&mdp_lock, irq_flags);
+	spin_lock_irqsave(&mdp->lock, irq_flags);
 	ret = mdp_irq_mask & mask;
-	spin_unlock_irqrestore(&mdp_lock, irq_flags);
+	spin_unlock_irqrestore(&mdp->lock, irq_flags);
 	return ret;
 }
 
@@ -154,16 +153,16 @@ static int mdp_wait(struct mdp_info *mdp, uint32_t mask, wait_queue_head_t *wq)
 	int ret = 0;
 	unsigned long irq_flags;
 
-	wait_event_timeout(*wq, !mdp_check_mask(mask), HZ);
+	wait_event_timeout(*wq, !mdp_check_mask(mdp, mask), HZ);
 
-	spin_lock_irqsave(&mdp_lock, irq_flags);
+	spin_lock_irqsave(&mdp->lock, irq_flags);
 	if (mdp_irq_mask & mask) {
 		locked_disable_mdp_irq(mdp, mask);
 		printk(KERN_WARNING "timeout waiting for mdp to complete %x\n",
 		       mask);
 		ret = -ETIMEDOUT;
 	}
-	spin_unlock_irqrestore(&mdp_lock, irq_flags);
+	spin_unlock_irqrestore(&mdp->lock, irq_flags);
 
 	return ret;
 }
@@ -399,6 +398,8 @@ int mdp_probe(struct platform_device *pdev)
 	if (!mdp)
 		return -ENOMEM;
 
+	spin_lock_init(&mdp->lock);
+
 	mdp->irq = platform_get_irq(pdev, 0);
 	if (mdp->irq < 0) {
 		pr_err("mdp: can not get mdp irq\n");
diff --git a/drivers/video/msm/mdp_hw.h b/drivers/video/msm/mdp_hw.h
index 4e3deb4..05a3164 100644
--- a/drivers/video/msm/mdp_hw.h
+++ b/drivers/video/msm/mdp_hw.h
@@ -1,6 +1,6 @@
 /* drivers/video/msm_fb/mdp_hw.h
  *
- * Copyright (C) 2007 QUALCOMM Incorporated
+ * Copyright (C) 2007, 2011 Code Aurora Forum. All rights reserved.
  * Copyright (C) 2007 Google Incorporated
  *
  * This software is licensed under the terms of the GNU General Public
@@ -19,6 +19,7 @@
 #include <mach/msm_fb.h>
 
 struct mdp_info {
+	spinlock_t lock;
 	struct mdp_device mdp_dev;
 	char * __iomem base;
 	int irq;
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

