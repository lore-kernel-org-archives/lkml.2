Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab1HWRkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 13:40:37 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29318 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab1HWRj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 13:39:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6446"; a="112157108"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Sahitya Tummala <stummala@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 1/6] mmc: msm_sdcc: Handle error cases in probe
Date: Tue, 23 Aug 2011 10:39:13 -0700
Message-Id: <1314121158-3319-2-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1314121158-3319-1-git-send-email-davidb@codeaurora.org>
References: <1314121158-3319-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sahitya Tummala <stummala@codeaurora.org>

Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 drivers/mmc/host/msm_sdcc.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index cfe0c89..0f0b4fd 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -1215,7 +1215,7 @@ msmsdcc_probe(struct platform_device *pdev)
 	host->base = ioremap(memres->start, PAGE_SIZE);
 	if (!host->base) {
 		ret = -ENOMEM;
-		goto out;
+		goto host_free;
 	}
 
 	host->cmd_irqres = cmd_irqres;
@@ -1230,13 +1230,15 @@ msmsdcc_probe(struct platform_device *pdev)
 	/*
 	 * Setup DMA
 	 */
-	msmsdcc_init_dma(host);
+	ret = msmsdcc_init_dma(host);
+	if (ret)
+		goto ioremap_free;
 
 	/* Get our clocks */
 	host->pclk = clk_get(&pdev->dev, "sdc_pclk");
 	if (IS_ERR(host->pclk)) {
 		ret = PTR_ERR(host->pclk);
-		goto host_free;
+		goto dma_free;
 	}
 
 	host->clk = clk_get(&pdev->dev, "sdc_clk");
@@ -1377,6 +1379,12 @@ msmsdcc_probe(struct platform_device *pdev)
 	clk_put(host->clk);
  pclk_put:
 	clk_put(host->pclk);
+dma_free:
+	dma_free_coherent(NULL, sizeof(struct msmsdcc_nc_dmadata),
+				host->dma.nc, host->dma.nc_busaddr);
+ioremap_free:
+	tasklet_kill(&host->dma_tlet);
+	iounmap(host->base);
  host_free:
 	mmc_free_host(mmc);
  out:
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

