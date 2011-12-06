Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933431Ab1LFNnD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 08:43:03 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:64342 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933195Ab1LFNmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 08:42:07 -0500
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Ball <cjb@laptop.org>,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [MXS MMC 4/5] Check the return codes of clk_enable() and mxs_reset_block()
Date: Tue,  6 Dec 2011 14:41:29 +0100
Message-Id: <b4779523002ceef3e95887bbcf7ed570cdd93a95.1323177907.git.LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <e668bb1ab5fbe406ef604a18f59292a05149ae51.1323177907.git.LW@KARO-electronics.de>
References: <cover.1323177907.git.LW@KARO-electronics.de>
 <1ebaeb7f7ed88b1d82f5fc3a01c0661f38e2a16d.1323177907.git.LW@KARO-electronics.de>
 <d935557e044d2ebc56b4e70487b519fe722e9017.1323177907.git.LW@KARO-electronics.de>
 <e668bb1ab5fbe406ef604a18f59292a05149ae51.1323177907.git.LW@KARO-electronics.de>
In-Reply-To: <cover.1323177907.git.LW@KARO-electronics.de>
References: <cover.1323177907.git.LW@KARO-electronics.de>
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
---
 drivers/mmc/host/mxs-mmc.c |   26 +++++++++++++++++++++-----
 1 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index a9b70d2..0003d03 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -185,11 +185,14 @@ static int mxs_mmc_get_cd(struct mmc_host *mmc)
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
@@ -214,6 +217,7 @@ static void mxs_mmc_reset(struct mxs_mmc_host *host)
 
 	writel(ctrl0, host->base + HW_SSP_CTRL0);
 	writel(ctrl1, host->base + HW_SSP_CTRL1);
+	return 0;
 }
 
 static void mxs_mmc_start_cmd(struct mxs_mmc_host *host,
@@ -712,9 +716,19 @@ static int mxs_mmc_probe(struct platform_device *pdev)
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
@@ -829,7 +843,9 @@ static int mxs_mmc_resume(struct device *dev)
 	struct mxs_mmc_host *host = mmc_priv(mmc);
 	int ret = 0;
 
-	clk_enable(host->clk);
+	ret = clk_enable(host->clk);
+	if (ret)
+		return ret;
 
 	ret = mmc_resume_host(mmc);
 
-- 
1.5.6.5

