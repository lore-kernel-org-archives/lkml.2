Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab2IQHjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 03:39:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:53975 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162Ab2IQHjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 03:39:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,433,1344236400"; 
   d="scan'208";a="193796119"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 3/7] dw_dmac: get number of channels from hardware if possible
Date: Mon, 17 Sep 2012 10:39:33 +0300
Message-Id: <1347867577-13170-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case the controller has the encoded parameters feature enabled the driver
will use it to get the number of channels. In the future it will be used for
the other important parameters as well.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c      |   33 +++++++++++++++++++++++----------
 drivers/dma/dw_dmac_regs.h |    4 ++++
 2 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 75ab5af..2a3b730 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1376,6 +1376,10 @@ static int __devinit dw_probe(struct platform_device *pdev)
 	struct resource		*io;
 	struct dw_dma		*dw;
 	size_t			size;
+	void __iomem		*regs;
+	bool			autocfg;
+	unsigned int		dw_params;
+	unsigned int		nr_channels;
 	int			irq;
 	int			err;
 	int			i;
@@ -1392,23 +1396,32 @@ static int __devinit dw_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
-	size = sizeof(struct dw_dma);
-	size += pdata->nr_channels * sizeof(struct dw_dma_chan);
+	regs = devm_request_and_ioremap(&pdev->dev, io);
+	if (!regs)
+		return -EBUSY;
+
+	dw_params = dma_raw_readl(regs, DW_PARAMS);
+	autocfg = dw_params >> DW_PARAMS_EN & 0x1;
+
+	if (autocfg)
+		nr_channels = (dw_params >> DW_PARAMS_NR_CHAN & 0x7) + 1;
+	else
+		nr_channels = pdata->nr_channels;
+
+	size = sizeof(struct dw_dma) + nr_channels * sizeof(struct dw_dma_chan);
 	dw = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
 	if (!dw)
 		return -ENOMEM;
 
-	dw->regs = devm_request_and_ioremap(&pdev->dev, io);
-	if (!dw->regs)
-		return -EBUSY;
-
 	dw->clk = devm_clk_get(&pdev->dev, "hclk");
 	if (IS_ERR(dw->clk))
 		return PTR_ERR(dw->clk);
 	clk_prepare_enable(dw->clk);
 
+	dw->regs = regs;
+
 	/* Calculate all channel mask before DMA setup */
-	dw->all_chan_mask = (1 << pdata->nr_channels) - 1;
+	dw->all_chan_mask = (1 << nr_channels) - 1;
 
 	/* force dma off, just in case */
 	dw_dma_off(dw);
@@ -1426,7 +1439,7 @@ static int __devinit dw_probe(struct platform_device *pdev)
 	tasklet_init(&dw->tasklet, dw_dma_tasklet, (unsigned long)dw);
 
 	INIT_LIST_HEAD(&dw->dma.channels);
-	for (i = 0; i < pdata->nr_channels; i++) {
+	for (i = 0; i < nr_channels; i++) {
 		struct dw_dma_chan	*dwc = &dw->chan[i];
 
 		dwc->chan.device = &dw->dma;
@@ -1439,7 +1452,7 @@ static int __devinit dw_probe(struct platform_device *pdev)
 
 		/* 7 is highest priority & 0 is lowest. */
 		if (pdata->chan_priority == CHAN_PRIORITY_ASCENDING)
-			dwc->priority = pdata->nr_channels - i - 1;
+			dwc->priority = nr_channels - i - 1;
 		else
 			dwc->priority = i;
 
@@ -1480,7 +1493,7 @@ static int __devinit dw_probe(struct platform_device *pdev)
 	dma_writel(dw, CFG, DW_CFG_DMA_EN);
 
 	printk(KERN_INFO "%s: DesignWare DMA Controller, %d channels\n",
-			dev_name(&pdev->dev), pdata->nr_channels);
+			dev_name(&pdev->dev), nr_channels);
 
 	dma_async_device_register(&dw->dma);
 
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index 4633d39..0f96965 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -104,6 +104,10 @@ struct dw_dma_regs {
 #define dma_raw_writel(addr, name, val) \
 	writel((val), (addr) + offsetof(struct dw_dma_regs, name))
 
+/* Bitfields in DW_PARAMS */
+#define DW_PARAMS_NR_CHAN	8		/* number of channels */
+#define DW_PARAMS_EN		28		/* encoded parameters */
+
 /* Bitfields in CTL_LO */
 #define DWC_CTLL_INT_EN		(1 << 0)	/* irqs enabled? */
 #define DWC_CTLL_DST_WIDTH(n)	((n)<<1)	/* bytes per element */
-- 
1.7.10.4

