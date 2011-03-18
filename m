Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932767Ab1CRVyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:54:22 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11025 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723Ab1CRVyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:54:20 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6289"; a="80848480"
X-IronPort-AV: E=Sophos;i="4.63,205,1299484800"; 
   d="scan'208";a="37044658"
From: Carl Vanderlip <carlv@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>, linux-fbdev@vger.kernel.org,
        Carl Vanderlip <carlv@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/20] video: msm: Move clk to mdp_info struct
Date: Fri, 18 Mar 2011 14:54:16 -0700
Message-Id: <1300485256-27044-1-git-send-email-carlv@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move local clock variable into mdp_info struct for easier access.

Authors:
Dima Zavin <dima@android.com>
Rebecca Schultz Zavin <rebecca@android.com>
Colin Cross <ccross@android.com>

Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>
---
 drivers/video/msm/mdp.c    |   17 +++++++++--------
 drivers/video/msm/mdp_hw.h |    1 +
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
index 9fb9f1a..e68df14 100644
--- a/drivers/video/msm/mdp.c
+++ b/drivers/video/msm/mdp.c
@@ -43,7 +43,6 @@ static uint16_t mdp_default_ccs[] = {
 static DECLARE_WAIT_QUEUE_HEAD(mdp_dma2_waitqueue);
 static DECLARE_WAIT_QUEUE_HEAD(mdp_ppp_waitqueue);
 static struct msmfb_callback *dma_callback;
-static struct clk *clk;
 static unsigned int mdp_irq_mask;
 DEFINE_MUTEX(mdp_mutex);
 
@@ -62,8 +61,7 @@ static int locked_enable_mdp_irq(struct mdp_info *mdp, uint32_t mask)
 	}
 	/* if the mdp irq is not already enabled enable it */
 	if (!mdp_irq_mask) {
-		if (clk)
-			clk_enable(clk);
+		clk_enable(mdp->clk);
 		enable_irq(mdp->irq);
 	}
 
@@ -98,8 +96,8 @@ static int locked_disable_mdp_irq(struct mdp_info *mdp, uint32_t mask)
 	/* if no one is waiting on the interrupt, disable it */
 	if (!mdp_irq_mask) {
 		disable_irq_nosync(mdp->irq);
-		if (clk)
-			clk_disable(clk);
+		if (mdp->clk)
+			clk_disable(mdp->clk);
 	}
 	return 0;
 }
@@ -428,10 +426,11 @@ int mdp_probe(struct platform_device *pdev)
 	mdp->mdp_dev.blit = mdp_blit;
 	mdp->mdp_dev.set_grp_disp = mdp_set_grp_disp;
 
-	clk = clk_get(&pdev->dev, "mdp_clk");
-	if (IS_ERR(clk)) {
+	mdp->clk = clk_get(&pdev->dev, "mdp_clk");
+	if (IS_ERR(mdp->clk)) {
 		printk(KERN_INFO "mdp: failed to get mdp clk");
-		return PTR_ERR(clk);
+		ret = PTR_ERR(mdp->clk);
+		goto error_get_mdp_clk;
 	}
 
 	ret = request_irq(mdp->irq, mdp_isr, IRQF_DISABLED, "msm_mdp", mdp);
@@ -467,6 +466,7 @@ int mdp_probe(struct platform_device *pdev)
 	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0174);
 	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x017c);
 
+	clk_enable(mdp->clk);
 	/* comp.plane 2 & 3 */
 	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0114);
 	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0118);
@@ -505,6 +505,7 @@ int mdp_probe(struct platform_device *pdev)
 error_device_register:
 	free_irq(mdp->irq, mdp);
 error_request_irq:
+error_get_mdp_clk:
 	iounmap(mdp->base);
 error_get_irq:
 error_ioremap:
diff --git a/drivers/video/msm/mdp_hw.h b/drivers/video/msm/mdp_hw.h
index 05a3164..54b3934 100644
--- a/drivers/video/msm/mdp_hw.h
+++ b/drivers/video/msm/mdp_hw.h
@@ -23,6 +23,7 @@ struct mdp_info {
 	struct mdp_device mdp_dev;
 	char * __iomem base;
 	int irq;
+	struct clk *clk;
 };
 struct mdp_blit_req;
 struct mdp_device;
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

