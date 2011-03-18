Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862Ab1CRV7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:59:35 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4839 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932835Ab1CRV70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:59:26 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6289"; a="80850518"
X-IronPort-AV: E=Sophos;i="4.63,205,1299484800"; 
   d="scan'208";a="37045035"
From: Carl Vanderlip <carlv@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>, linux-fbdev@vger.kernel.org,
        Carl Vanderlip <carlv@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 16/20] video: msm: Set the EBI1 clock to 128MHz when performing blits
Date: Fri, 18 Mar 2011 14:59:22 -0700
Message-Id: <1300485562-27560-1-git-send-email-carlv@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes sure that the MDP (locked to AXI) and the AXI/ABI1 run at the
maximum frequency during blit operations.

Authors:
Dima Zavin <dima@android.com>
Rebecca Schultz Zavin <rebecca@android.com>
Colin Cross <ccross@android.com>

Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>
---
 drivers/video/msm/mdp.c    |   11 +++++++++++
 drivers/video/msm/mdp_hw.h |    1 +
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
index b03204d..0bb19fa 100644
--- a/drivers/video/msm/mdp.c
+++ b/drivers/video/msm/mdp.c
@@ -52,6 +52,7 @@ static int locked_enable_mdp_irq(struct mdp_info *mdp, uint32_t mask)
 	}
 	/* if the mdp irq is not already enabled enable it */
 	if (!mdp_irq_mask) {
+		clk_set_rate(mdp->ebi1_clk, 128000000);
 		clk_enable(mdp->clk);
 		enable_irq(mdp->irq);
 	}
@@ -656,6 +657,13 @@ int mdp_probe(struct platform_device *pdev)
 		goto error_get_mdp_clk;
 	}
 
+	mdp->ebi1_clk = clk_get(NULL, "ebi1_clk");
+	if (IS_ERR(mdp->ebi1_clk)) {
+		pr_err("mdp: failed to get ebi1 clk\n");
+		ret = PTR_ERR(mdp->ebi1_clk);
+		goto error_get_ebi1_clk;
+	}
+
 	ret = request_irq(mdp->irq, mdp_isr, IRQF_DISABLED, "msm_mdp", mdp);
 	if (ret)
 		goto error_request_irq;
@@ -681,6 +689,9 @@ int mdp_probe(struct platform_device *pdev)
 error_device_register:
 	free_irq(mdp->irq, mdp);
 error_request_irq:
+	clk_put(mdp->ebi1_clk);
+error_get_ebi1_clk:
+	clk_put(mdp->clk);
 error_get_mdp_clk:
 error_mddi_pmdh_register:
 	iounmap(mdp->base);
diff --git a/drivers/video/msm/mdp_hw.h b/drivers/video/msm/mdp_hw.h
index fdf9e5e..7485a9e 100644
--- a/drivers/video/msm/mdp_hw.h
+++ b/drivers/video/msm/mdp_hw.h
@@ -46,6 +46,7 @@ struct mdp_info {
 	char * __iomem base;
 	int irq;
 	struct clk *clk;
+	struct clk *ebi1_clk;
 	struct mdp_out_interface out_if[MSM_MDP_NUM_INTERFACES];
 	int format;
 	int pack_pattern;
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

