Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab2HPNQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:16:10 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:44143 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932288Ab2HPNQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:16:06 -0400
From: Roland Stigge <stigge@antcom.de>
To: linux@arm.linux.org.uk, artem.bityutskiy@linux.intel.com,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] mtd: lpc32xx_slc: Make driver independent of AMBA DMA engine driver
Date: Thu, 16 Aug 2012 15:15:34 +0200
Message-Id: <1345122935-22115-2-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1345122935-22115-1-git-send-email-stigge@antcom.de>
References: <1345122935-22115-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the SLC NAND driver independent of the single AMBA DMA engine
driver by using the platform data provided dma_filter callback.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 drivers/mtd/nand/lpc32xx_slc.c  |   13 +++++++++++--
 include/linux/mtd/lpc32xx_slc.h |   20 ++++++++++++++++++++
 2 files changed, 31 insertions(+), 2 deletions(-)

--- linux-2.6.orig/drivers/mtd/nand/lpc32xx_slc.c
+++ linux-2.6/drivers/mtd/nand/lpc32xx_slc.c
@@ -37,7 +37,7 @@
 #include <linux/of.h>
 #include <linux/of_mtd.h>
 #include <linux/of_gpio.h>
-#include <linux/amba/pl08x.h>
+#include <linux/mtd/lpc32xx_slc.h>
 
 #define LPC32XX_MODNAME		"lpc32xx-nand"
 
@@ -199,6 +199,7 @@ struct lpc32xx_nand_cfg_slc {
 
 struct lpc32xx_nand_host {
 	struct nand_chip	nand_chip;
+	struct lpc32xx_slc_platform_data *pdata;
 	struct clk		*clk;
 	struct mtd_info		mtd;
 	void __iomem		*io_base;
@@ -714,9 +715,15 @@ static int lpc32xx_nand_dma_setup(struct
 	struct mtd_info *mtd = &host->mtd;
 	dma_cap_mask_t mask;
 
+	if (!host->pdata || !host->pdata->dma_filter) {
+		dev_err(mtd->dev.parent, "no DMA platform data\n");
+		return -ENOENT;
+	}
+
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
-	host->dma_chan = dma_request_channel(mask, pl08x_filter_id, "nand-slc");
+	host->dma_chan = dma_request_channel(mask, host->pdata->dma_filter,
+					     "nand-slc");
 	if (!host->dma_chan) {
 		dev_err(mtd->dev.parent, "Failed to request DMA channel\n");
 		return -EBUSY;
@@ -814,6 +821,8 @@ static int __devinit lpc32xx_nand_probe(
 	}
 	lpc32xx_wp_disable(host);
 
+	host->pdata = pdev->dev.platform_data;
+
 	mtd = &host->mtd;
 	chip = &host->nand_chip;
 	chip->priv = host;
--- /dev/null
+++ linux-2.6/include/linux/mtd/lpc32xx_slc.h
@@ -0,0 +1,20 @@
+/*
+ * Platform data for LPC32xx SoC SLC NAND controller
+ *
+ * Copyright (C) 2012 Roland Stigge
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __LINUX_MTD_LPC32XX_SLC_H
+#define __LINUX_MTD_LPC32XX_SLC_H
+
+#include <linux/dmaengine.h>
+
+struct lpc32xx_slc_platform_data {
+	bool (*dma_filter)(struct dma_chan *chan, void *filter_param);
+};
+
+#endif  /* __LINUX_MTD_LPC32XX_SLC_H */
