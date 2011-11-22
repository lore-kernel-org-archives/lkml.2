Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab1KVK4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 05:56:07 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:61414 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab1KVK4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 05:56:04 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: vinod.koul@intel.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3/3] dmaengine: at_hdmac: simplify device selection from platform data or DT
Date: Tue, 22 Nov 2011 11:55:54 +0100
Message-Id: <6ff0eeb5f91d31d6768a33e02826cbb885abbf55.1321959137.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <25000153a64c2845223be78ee55e01e034613601.1321959137.git.nicolas.ferre@atmel.com>
References: <25000153a64c2845223be78ee55e01e034613601.1321959137.git.nicolas.ferre@atmel.com>
In-Reply-To: <25000153a64c2845223be78ee55e01e034613601.1321959137.git.nicolas.ferre@atmel.com>
References: <25000153a64c2845223be78ee55e01e034613601.1321959137.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using a configuration structure simplify the finding of SoC
dependent parameters. Both platform data and device tree ids are
using these structures.
This will separate data from code and remove the need for an enum.

Idea from Grant Likely.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/at_hdmac.c      |   63 +++++++++++++++++++++----------------------
 drivers/dma/at_hdmac_regs.h |    7 -----
 2 files changed, 31 insertions(+), 39 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 30ec030..97f87b2 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1177,14 +1177,22 @@ static void atc_free_chan_resources(struct dma_chan *chan)
 
 /*--  Module Management  -----------------------------------------------*/
 
+/* cap_mask is a multi-u32 bitfield, fill it with proper C code. */
+static struct at_dma_platform_data at91sam9rl_config = {
+	.nr_channels = 2,
+};
+static struct at_dma_platform_data at91sam9g45_config = {
+	.nr_channels = 8,
+};
+
 #if defined(CONFIG_OF)
 static const struct of_device_id atmel_dma_dt_ids[] = {
 	{
 		.compatible = "atmel,at91sam9rl-dma",
-		.data = (void *)ATDMA_DEVTYPE_SAM9RL
+		.data = &at91sam9rl_config,
 	}, {
 		.compatible = "atmel,at91sam9g45-dma",
-		.data = (void *)ATDMA_DEVTYPE_SAM9G45
+		.data = &at91sam9g45_config,
 	}, {
 		/* sentinel */
 	}
@@ -1196,26 +1204,27 @@ MODULE_DEVICE_TABLE(of, atmel_dma_dt_ids);
 static const struct platform_device_id atdma_devtypes[] = {
 	{
 		.name = "at91sam9rl_dma",
-		.driver_data = ATDMA_DEVTYPE_SAM9RL,
+		.driver_data = (unsigned long) &at91sam9rl_config,
 	}, {
 		.name = "at91sam9g45_dma",
-		.driver_data = ATDMA_DEVTYPE_SAM9G45,
+		.driver_data = (unsigned long) &at91sam9g45_config,
 	}, {
 		/* sentinel */
 	}
 };
 
-static inline enum atdma_devtype __init at_dma_get_driver_data(
-					struct platform_device *pdev)
+static inline struct at_dma_platform_data * __init at_dma_get_driver_data(
+						struct platform_device *pdev)
 {
 	if (pdev->dev.of_node) {
 		const struct of_device_id *match;
 		match = of_match_node(atmel_dma_dt_ids, pdev->dev.of_node);
 		if (match == NULL)
-			return ATDMA_DEVTYPE_UNDEFINED;
-		return (enum atdma_devtype)match->data;
+			return NULL;
+		return match->data;
 	}
-	return platform_get_device_id(pdev)->driver_data;
+	return (struct at_dma_platform_data *)
+			platform_get_device_id(pdev)->driver_data;
 }
 
 /**
@@ -1242,26 +1251,17 @@ static int __init at_dma_probe(struct platform_device *pdev)
 	int			irq;
 	int			err;
 	int			i;
-	u32                     nr_channels;
-	dma_cap_mask_t          cap_mask = {};
-	enum atdma_devtype	atdmatype;
+	struct at_dma_platform_data *plat_dat;
 
-	dma_cap_set(DMA_MEMCPY, cap_mask);
+	/* setup platform data for each SoC */
+	dma_cap_set(DMA_MEMCPY, at91sam9rl_config.cap_mask);
+	dma_cap_set(DMA_MEMCPY, at91sam9g45_config.cap_mask);
+	dma_cap_set(DMA_SLAVE, at91sam9g45_config.cap_mask);
 
 	/* get DMA parameters from controller type */
-	atdmatype = at_dma_get_driver_data(pdev);
-
-	switch (atdmatype) {
-	case ATDMA_DEVTYPE_SAM9RL:
-		nr_channels = 2;
-		break;
-	case ATDMA_DEVTYPE_SAM9G45:
-		nr_channels = 8;
-		dma_cap_set(DMA_SLAVE, cap_mask);
-		break;
-	default:
-		return -EINVAL;
-	}
+	plat_dat = at_dma_get_driver_data(pdev);
+	if (!plat_dat)
+		return -ENODEV;
 
 	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!io)
@@ -1272,15 +1272,14 @@ static int __init at_dma_probe(struct platform_device *pdev)
 		return irq;
 
 	size = sizeof(struct at_dma);
-	size += nr_channels * sizeof(struct at_dma_chan);
+	size += plat_dat->nr_channels * sizeof(struct at_dma_chan);
 	atdma = kzalloc(size, GFP_KERNEL);
 	if (!atdma)
 		return -ENOMEM;
 
 	/* discover transaction capabilities */
-	atdma->dma_common.cap_mask = cap_mask;
-	atdma->all_chan_mask = (1 << nr_channels) - 1;
-	atdma->devtype = atdmatype;
+	atdma->dma_common.cap_mask = plat_dat->cap_mask;
+	atdma->all_chan_mask = (1 << plat_dat->nr_channels) - 1;
 
 	size = resource_size(io);
 	if (!request_mem_region(io->start, size, pdev->dev.driver->name)) {
@@ -1326,7 +1325,7 @@ static int __init at_dma_probe(struct platform_device *pdev)
 
 	/* initialize channels related values */
 	INIT_LIST_HEAD(&atdma->dma_common.channels);
-	for (i = 0; i < nr_channels; i++) {
+	for (i = 0; i < plat_dat->nr_channels; i++) {
 		struct at_dma_chan	*atchan = &atdma->chan[i];
 
 		atchan->chan_common.device = &atdma->dma_common;
@@ -1371,7 +1370,7 @@ static int __init at_dma_probe(struct platform_device *pdev)
 	dev_info(&pdev->dev, "Atmel AHB DMA Controller ( %s%s), %d channels\n",
 	  dma_has_cap(DMA_MEMCPY, atdma->dma_common.cap_mask) ? "cpy " : "",
 	  dma_has_cap(DMA_SLAVE, atdma->dma_common.cap_mask)  ? "slave " : "",
-	  nr_channels);
+	  plat_dat->nr_channels);
 
 	dma_async_device_register(&atdma->dma_common);
 
diff --git a/drivers/dma/at_hdmac_regs.h b/drivers/dma/at_hdmac_regs.h
index d7d6737..dcaedfc 100644
--- a/drivers/dma/at_hdmac_regs.h
+++ b/drivers/dma/at_hdmac_regs.h
@@ -248,12 +248,6 @@ static inline struct at_dma_chan *to_at_dma_chan(struct dma_chan *dchan)
 
 /*--  Controller  ------------------------------------------------------*/
 
-enum atdma_devtype {
-	ATDMA_DEVTYPE_UNDEFINED = 0,
-	ATDMA_DEVTYPE_SAM9RL,	/* compatible with SAM9RL DMA controller */
-	ATDMA_DEVTYPE_SAM9G45,	/* compatible with SAM9G45 DMA controller */
-};
-
 /**
  * struct at_dma - internal representation of an Atmel HDMA Controller
  * @chan_common: common dmaengine dma_device object members
@@ -267,7 +261,6 @@ enum atdma_devtype {
  */
 struct at_dma {
 	struct dma_device	dma_common;
-	enum atdma_devtype	devtype;
 	void __iomem		*regs;
 	struct clk		*clk;
 	u32			save_imr;
-- 
1.7.5.4

