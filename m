Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465Ab2HVWZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 18:25:43 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:52217 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933404Ab2HVWZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 18:25:37 -0400
From: Roland Stigge <stigge@antcom.de>
To: linux@arm.linux.org.uk, artem.bityutskiy@linux.intel.com,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RESEND] mtd: lpc32xx_mlc: Make driver independent of AMBA DMA engine driver
Date: Thu, 23 Aug 2012 00:25:10 +0200
Message-Id: <1345674311-16874-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the MLC NAND driver independent of the single AMBA DMA engine
driver by using the platform data provided dma_filter callback.

(This also fixes the build error of the MLC NAND driver in case of module
linking because the (not exported) reference to pl08x_filter_id is gone now.)

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
Applies to: v3.6-rc2

 drivers/mtd/nand/lpc32xx_mlc.c  |   13 +++++++++++--
 include/linux/mtd/lpc32xx_mlc.h |   20 ++++++++++++++++++++
 2 files changed, 31 insertions(+), 2 deletions(-)

--- linux-2.6.orig/drivers/mtd/nand/lpc32xx_mlc.c
+++ linux-2.6/drivers/mtd/nand/lpc32xx_mlc.c
@@ -37,7 +37,7 @@
 #include <linux/of.h>
 #include <linux/of_mtd.h>
 #include <linux/of_gpio.h>
-#include <linux/amba/pl08x.h>
+#include <linux/mtd/lpc32xx_mlc.h>
 #include <linux/io.h>
 #include <linux/mm.h>
 #include <linux/dma-mapping.h>
@@ -171,6 +171,7 @@ static struct nand_bbt_descr lpc32xx_nan
 
 struct lpc32xx_nand_host {
 	struct nand_chip	nand_chip;
+	struct lpc32xx_mlc_platform_data *pdata;
 	struct clk		*clk;
 	struct mtd_info		mtd;
 	void __iomem		*io_base;
@@ -581,9 +582,15 @@ static int lpc32xx_dma_setup(struct lpc3
 	struct mtd_info *mtd = &host->mtd;
 	dma_cap_mask_t mask;
 
+	if (!host->pdata || !host->pdata->dma_filter) {
+		dev_err(mtd->dev.parent, "no DMA platform data\n");
+		return -ENOENT;
+	}
+
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
-	host->dma_chan = dma_request_channel(mask, pl08x_filter_id, "nand-mlc");
+	host->dma_chan = dma_request_channel(mask, host->pdata->dma_filter,
+					     "nand-mlc");
 	if (!host->dma_chan) {
 		dev_err(mtd->dev.parent, "Failed to request DMA channel\n");
 		return -EBUSY;
@@ -703,6 +710,8 @@ static int __devinit lpc32xx_nand_probe(
 	}
 	lpc32xx_wp_disable(host);
 
+	host->pdata = pdev->dev.platform_data;
+
 	nand_chip->priv = host;		/* link the private data structures */
 	mtd->priv = nand_chip;
 	mtd->owner = THIS_MODULE;
--- /dev/null
+++ linux-2.6/include/linux/mtd/lpc32xx_mlc.h
@@ -0,0 +1,20 @@
+/*
+ * Platform data for LPC32xx SoC MLC NAND controller
+ *
+ * Copyright (C) 2012 Roland Stigge
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __LINUX_MTD_LPC32XX_MLC_H
+#define __LINUX_MTD_LPC32XX_MLC_H
+
+#include <linux/dmaengine.h>
+
+struct lpc32xx_mlc_platform_data {
+	bool (*dma_filter)(struct dma_chan *chan, void *filter_param);
+};
+
+#endif  /* __LINUX_MTD_LPC32XX_MLC_H */
