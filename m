Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893Ab1CRWAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 18:00:06 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8037 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932830Ab1CRV7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:59:49 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6289"; a="80850569"
X-IronPort-AV: E=Sophos;i="4.63,205,1299484800"; 
   d="scan'208";a="37045069"
From: Carl Vanderlip <carlv@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>, linux-fbdev@vger.kernel.org,
        Carl Vanderlip <carlv@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 18/20] video: msm: Prevent DMA lockups when switching bit depths
Date: Fri, 18 Mar 2011 14:59:45 -0700
Message-Id: <1300485585-27640-1-git-send-email-carlv@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forces the lcdc off and waits a frame vsync period to prevent the MDP DMA
engine crashing if the DMA bit depth is changed.  A sleep cannot be used
because lcdc_dma_start is called in irq context.

Authors:
Dima Zavin <dima@android.com>
Rebecca Schultz Zavin <rebecca@android.com>
Colin Cross <ccross@android.com>

Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>
---
 drivers/video/msm/mdp.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
index b3f334ad..49d956a 100644
--- a/drivers/video/msm/mdp.c
+++ b/drivers/video/msm/mdp.c
@@ -564,6 +564,13 @@ void mdp_hw_init(struct mdp_info *mdp)
 	mdp_writel(mdp, 1, 0x60);
 	mdp_writel(mdp, 1, MDP_EBI2_PORTMAP_MODE);
 
+	/* disable lcdc */
+	mdp_writel(mdp, 0, MDP_LCDC_CTL);
+	/* enable auto clock gating for all blocks by default */
+	mdp_writel(mdp, 0xffffffff, MDP_CGC_EN);
+	/* reset color/gamma correct parms */
+	mdp_writel(mdp, 0, MDP_DMA_P_COLOR_CORRECT_CONFIG);
+
 	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01f8);
 	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01fc);
 	mdp_writel(mdp, 1, 0x60);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

