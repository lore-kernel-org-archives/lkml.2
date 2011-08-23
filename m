Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab1HWRjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 13:39:47 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6747 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab1HWRjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 13:39:33 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6446"; a="112353751"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Sahitya Tummala <stummala@codeaurora.org>
Subject: [PATCH 6/6] mmc: msm_sdcc: Handle dma resource not present case
Date: Tue, 23 Aug 2011 10:39:18 -0700
Message-Id: <1314121158-3319-7-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1314121158-3319-1-git-send-email-davidb@codeaurora.org>
References: <1314121158-3319-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Subhash Jadavani <subhashj@codeaurora.org>

If DMA resource is not available then SDCC driver
should atleast work in PIO data transfer mode.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 drivers/mmc/host/msm_sdcc.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index a835ac0..61c7d38 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -1242,9 +1242,13 @@ msmsdcc_probe(struct platform_device *pdev)
 	/*
 	 * Setup DMA
 	 */
-	ret = msmsdcc_init_dma(host);
-	if (ret)
-		goto ioremap_free;
+	if (host->dmares) {
+		ret = msmsdcc_init_dma(host);
+		if (ret)
+			goto ioremap_free;
+	} else {
+		host->dma.channel = -1;
+	}
 
 	/* Get our clocks */
 	host->pclk = clk_get(&pdev->dev, "sdc_pclk");
@@ -1388,8 +1392,9 @@ msmsdcc_probe(struct platform_device *pdev)
  pclk_put:
 	clk_put(host->pclk);
 dma_free:
-	dma_free_coherent(NULL, sizeof(struct msmsdcc_nc_dmadata),
-				host->dma.nc, host->dma.nc_busaddr);
+	if (host->dmares)
+		dma_free_coherent(NULL, sizeof(struct msmsdcc_nc_dmadata),
+					host->dma.nc, host->dma.nc_busaddr);
 ioremap_free:
 	tasklet_kill(&host->dma_tlet);
 	iounmap(host->base);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

