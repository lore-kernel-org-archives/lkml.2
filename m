Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471Ab1LHISG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 03:18:06 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:49297 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab1LHISB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 03:18:01 -0500
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Sascha Hauer <kernel@pengutronix.de>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Chris Ball <cjb@laptop.org>,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [MXS MMC v2 3/4] Check the return codes of clk_enable() and mxs_reset_block()
Date: Thu,  8 Dec 2011 09:17:46 +0100
Message-Id: <b4779523002ceef3e95887bbcf7ed570cdd93a95.1323328267.git.LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <d935557e044d2ebc56b4e70487b519fe722e9017.1323328267.git.LW@KARO-electronics.de>
References: <cover.1323328267.git.LW@KARO-electronics.de>
 <1ebaeb7f7ed88b1d82f5fc3a01c0661f38e2a16d.1323328267.git.LW@KARO-electronics.de>
 <d935557e044d2ebc56b4e70487b519fe722e9017.1323328267.git.LW@KARO-electronics.de>
In-Reply-To: <cover.1323328267.git.LW@KARO-electronics.de>
References: <cover.1323328267.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an int return value to mxs_mmc_reset(), so that the return code of
mxs_reset_block() can be promoted to the caller.
Also check the return code of clk_enable() in the probe function.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/mmc/host/mxs-mmc.c |   26 +++++++++++++++++++++-----
 1 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index a9b70d2..0003d03 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -190,11 +190,14 @@ static int mxs_mmc_get_cd(struct mmc_host *mmc)
 		 BM_SSP_STATUS_CARD_DETECT);
 }
 
-static void mxs_mmc_reset(struct mxs_mmc_host *host)
+static int mxs_mmc_reset(struct mxs_mmc_host *host)
 {
+	int ret;
 	u32 ctrl0, ctrl1;
 
-	mxs_reset_block(host->base);
+	ret = mxs_reset_block(host->base);
+	if (ret)
+		return ret;
 
 	ctrl0 = BM_SSP_CTRL0_IGNORE_CRC;
 	ctrl1 = BF_SSP(0x3, CTRL1_SSP_MODE) |
@@ -219,6 +222,7 @@ static void mxs_mmc_reset(struct mxs_mmc_host *host)
 
 	writel(ctrl0, host->base + HW_SSP_CTRL0);
 	writel(ctrl1, host->base + HW_SSP_CTRL1);
+	return 0;
 }
 
 static void mxs_mmc_start_cmd(struct mxs_mmc_host *host,
@@ -717,9 +721,19 @@ static int mxs_mmc_probe(struct platform_device *pdev)
 		ret = PTR_ERR(host->clk);
 		goto out_iounmap;
 	}
-	clk_enable(host->clk);
+	ret = clk_enable(host->clk);
+	if (ret) {
+		dev_err(mmc_dev(host->mmc),
+			"%s: failed to enable clock: %d\n", __func__, ret);
+		goto out_clk_put;
+	}
 
-	mxs_mmc_reset(host);
+	ret = mxs_mmc_reset(host);
+	if (ret) {
+		dev_err(mmc_dev(host->mmc),
+			"%s: failed to reset controller: %d\n", __func__, ret);
+		goto out_clk_put;
+	}
 
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
@@ -834,7 +848,9 @@ static int mxs_mmc_resume(struct device *dev)
 	struct mxs_mmc_host *host = mmc_priv(mmc);
 	int ret = 0;
 
-	clk_enable(host->clk);
+	ret = clk_enable(host->clk);
+	if (ret)
+		return ret;
 
 	ret = mmc_resume_host(mmc);
 
-- 
1.5.6.5

