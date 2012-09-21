Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab2IUMGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 08:06:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:55548 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab2IUMF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 08:05:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,462,1344236400"; 
   d="scan'208";a="224857183"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 3/6] dw_dmac: get number of channels from hardware if possible
Date: Fri, 21 Sep 2012 15:05:46 +0300
Message-Id: <1348229149-29040-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348229149-29040-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1348229149-29040-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case the controller has the encoded parameters feature enabled the driver
will use it to get the number of channels. In the future it will be used for
the other important parameters as well.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |   33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 2272f79..c964f6e 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1381,6 +1381,10 @@ static int __devinit dw_probe(struct platform_device *pdev)
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
@@ -1397,23 +1401,32 @@ static int __devinit dw_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
-	size = sizeof(struct dw_dma);
-	size += pdata->nr_channels * sizeof(struct dw_dma_chan);
+	regs = devm_request_and_ioremap(&pdev->dev, io);
+	if (!regs)
+		return -EBUSY;
+
+	dw_params = dma_read_byaddr(regs, DW_PARAMS);
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
@@ -1431,7 +1444,7 @@ static int __devinit dw_probe(struct platform_device *pdev)
 	tasklet_init(&dw->tasklet, dw_dma_tasklet, (unsigned long)dw);
 
 	INIT_LIST_HEAD(&dw->dma.channels);
-	for (i = 0; i < pdata->nr_channels; i++) {
+	for (i = 0; i < nr_channels; i++) {
 		struct dw_dma_chan	*dwc = &dw->chan[i];
 
 		dwc->chan.device = &dw->dma;
@@ -1444,7 +1457,7 @@ static int __devinit dw_probe(struct platform_device *pdev)
 
 		/* 7 is highest priority & 0 is lowest. */
 		if (pdata->chan_priority == CHAN_PRIORITY_ASCENDING)
-			dwc->priority = pdata->nr_channels - i - 1;
+			dwc->priority = nr_channels - i - 1;
 		else
 			dwc->priority = i;
 
@@ -1485,7 +1498,7 @@ static int __devinit dw_probe(struct platform_device *pdev)
 	dma_writel(dw, CFG, DW_CFG_DMA_EN);
 
 	printk(KERN_INFO "%s: DesignWare DMA Controller, %d channels\n",
-			dev_name(&pdev->dev), pdata->nr_channels);
+			dev_name(&pdev->dev), nr_channels);
 
 	dma_async_device_register(&dw->dma);
 
-- 
1.7.10.4

