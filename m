Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112Ab2EYXPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 19:15:19 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44508 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759071Ab2EYXPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 19:15:16 -0400
From: Fabio Estevam <festevam@gmail.com>
To: kernel@pengutronix.de
Cc: shawn.guo@freescale.com, Fabio Estevam <fabio.estevam@freescale.com>,
        Vinod Koul <vinod.koul@intel.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/15] dma: imx-sdma: Use clk_prepare_enable/clk_disable_unprepare
Date: Fri, 25 May 2012 20:14:45 -0300
Message-Id: <1337987696-31728-4-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1337987696-31728-1-git-send-email-festevam@gmail.com>
References: <1337987696-31728-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Prepare the clock before enabling it.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: <linux-kernel@vger.kernel.org>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/dma/imx-sdma.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index fb4f499..b6174e6 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -868,8 +868,8 @@ static int sdma_alloc_chan_resources(struct dma_chan *chan)
 	sdmac->peripheral_type = data->peripheral_type;
 	sdmac->event_id0 = data->dma_request;
 
-	clk_enable(sdmac->sdma->clk_ipg);
-	clk_enable(sdmac->sdma->clk_ahb);
+	clk_prepare_enable(sdmac->sdma->clk_ipg);
+	clk_prepare_enable(sdmac->sdma->clk_ahb);
 
 	ret = sdma_request_channel(sdmac);
 	if (ret)
@@ -906,8 +906,8 @@ static void sdma_free_chan_resources(struct dma_chan *chan)
 
 	dma_free_coherent(NULL, PAGE_SIZE, sdmac->bd, sdmac->bd_phys);
 
-	clk_disable(sdma->clk_ipg);
-	clk_disable(sdma->clk_ahb);
+	clk_disable_unprepare(sdma->clk_ipg);
+	clk_disable_unprepare(sdma->clk_ahb);
 }
 
 static struct dma_async_tx_descriptor *sdma_prep_slave_sg(
@@ -1180,14 +1180,14 @@ static void sdma_load_firmware(const struct firmware *fw, void *context)
 	addr = (void *)header + header->script_addrs_start;
 	ram_code = (void *)header + header->ram_code_start;
 
-	clk_enable(sdma->clk_ipg);
-	clk_enable(sdma->clk_ahb);
+	clk_prepare_enable(sdma->clk_ipg);
+	clk_prepare_enable(sdma->clk_ahb);
 	/* download the RAM image for SDMA */
 	sdma_load_script(sdma, ram_code,
 			header->ram_code_size,
 			addr->ram_code_start_addr);
-	clk_disable(sdma->clk_ipg);
-	clk_disable(sdma->clk_ahb);
+	clk_disable_unprepare(sdma->clk_ipg);
+	clk_disable_unprepare(sdma->clk_ahb);
 
 	sdma_add_scripts(sdma, addr);
 
@@ -1229,8 +1229,8 @@ static int __init sdma_init(struct sdma_engine *sdma)
 		return -ENODEV;
 	}
 
-	clk_enable(sdma->clk_ipg);
-	clk_enable(sdma->clk_ahb);
+	clk_prepare_enable(sdma->clk_ipg);
+	clk_prepare_enable(sdma->clk_ahb);
 
 	/* Be sure SDMA has not started yet */
 	writel_relaxed(0, sdma->regs + SDMA_H_C0PTR);
@@ -1283,14 +1283,14 @@ static int __init sdma_init(struct sdma_engine *sdma)
 	/* Initializes channel's priorities */
 	sdma_set_channel_priority(&sdma->channel[0], 7);
 
-	clk_disable(sdma->clk_ipg);
-	clk_disable(sdma->clk_ahb);
+	clk_disable_unprepare(sdma->clk_ipg);
+	clk_disable_unprepare(sdma->clk_ahb);
 
 	return 0;
 
 err_dma_alloc:
-	clk_disable(sdma->clk_ipg);
-	clk_disable(sdma->clk_ahb);
+	clk_disable_unprepare(sdma->clk_ipg);
+	clk_disable_unprepare(sdma->clk_ahb);
 	dev_err(sdma->dev, "initialisation failed with %d\n", ret);
 	return ret;
 }
-- 
1.7.1

