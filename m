Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab2GTIKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 04:10:36 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5494 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab2GTIKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 04:10:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 20 Jul 2012 01:10:30 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
CC: <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2] dma: tegra: enable/disable dma clock
Date: Fri, 20 Jul 2012 13:31:08 +0530
Message-ID: <1342771268-5252-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the DMA clock when allocating channel and
disable clock when freeing channels.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1 to V2:
- Enable/disable clock when allocating/freeing channels.
- rewrite the description to reflect change.

 drivers/dma/tegra20-apb-dma.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index d52dbc6..24acd71 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -1119,15 +1119,21 @@ struct dma_async_tx_descriptor *tegra_dma_prep_dma_cyclic(
 static int tegra_dma_alloc_chan_resources(struct dma_chan *dc)
 {
 	struct tegra_dma_channel *tdc = to_tegra_dma_chan(dc);
+	struct tegra_dma *tdma = tdc->tdma;
+	int ret;
 
 	dma_cookie_init(&tdc->dma_chan);
 	tdc->config_init = false;
-	return 0;
+	ret = clk_prepare_enable(tdma->dma_clk);
+	if (ret < 0)
+		dev_err(tdc2dev(tdc), "clk_prepare_enable failed: %d\n", ret);
+	return ret;
 }
 
 static void tegra_dma_free_chan_resources(struct dma_chan *dc)
 {
 	struct tegra_dma_channel *tdc = to_tegra_dma_chan(dc);
+	struct tegra_dma *tdma = tdc->tdma;
 
 	struct tegra_dma_desc *dma_desc;
 	struct tegra_dma_sg_req *sg_req;
@@ -1163,6 +1169,7 @@ static void tegra_dma_free_chan_resources(struct dma_chan *dc)
 		list_del(&sg_req->node);
 		kfree(sg_req);
 	}
+	clk_disable_unprepare(tdma->dma_clk);
 }
 
 /* Tegra20 specific DMA controller information */
@@ -1255,6 +1262,13 @@ static int __devinit tegra_dma_probe(struct platform_device *pdev)
 		}
 	}
 
+	/* Enable clock before accessing registers */
+	ret = clk_prepare_enable(tdma->dma_clk);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "clk_prepare_enable failed: %d\n", ret);
+		goto err_pm_disable;
+	}
+
 	/* Reset DMA controller */
 	tegra_periph_reset_assert(tdma->dma_clk);
 	udelay(2);
@@ -1265,6 +1279,8 @@ static int __devinit tegra_dma_probe(struct platform_device *pdev)
 	tdma_write(tdma, TEGRA_APBDMA_CONTROL, 0);
 	tdma_write(tdma, TEGRA_APBDMA_IRQ_MASK_SET, 0xFFFFFFFFul);
 
+	clk_disable_unprepare(tdma->dma_clk);
+
 	INIT_LIST_HEAD(&tdma->dma_dev.channels);
 	for (i = 0; i < cdata->nr_channels; i++) {
 		struct tegra_dma_channel *tdc = &tdma->channels[i];
-- 
1.7.1.1

