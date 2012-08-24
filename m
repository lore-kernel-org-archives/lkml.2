Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432Ab2HXNHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 09:07:44 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:49938 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751146Ab2HXNHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 09:07:39 -0400
From: Roland Stigge <stigge@antcom.de>
To: linux@arm.linux.org.uk, artem.bityutskiy@linux.intel.com,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 1/2] mtd: lpc32xx_slc: Cleanup after DT-only conversion
Date: Fri, 24 Aug 2012 15:06:51 +0200
Message-Id: <1345813612-4234-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LPC32xx's DT-only conversion of the SLC NAND driver makes NAND config via
platform_data obsolete. Dropped by this patch.

Further, the driver really needs CONFIG_OF, which is already reflected by the
dependency on ARCH_LPC32XX which depends on CONFIG_OF. So also dropping
CONFIG_OF ifdefs.

There is still platform_data necessary to supply the dma_filter callback for
the dma engine. This is a completely different data structure than the old
platform_data for NAND config, so renaming some old "pdata" variable to "ncfg"
to prevent confusion with the new platform data.

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 drivers/mtd/nand/lpc32xx_slc.c |   52 ++++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 31 deletions(-)

--- linux-2.6.orig/drivers/mtd/nand/lpc32xx_slc.c
+++ linux-2.6/drivers/mtd/nand/lpc32xx_slc.c
@@ -732,45 +732,38 @@ static int lpc32xx_nand_dma_setup(struct
 	return 0;
 }
 
-#ifdef CONFIG_OF
 static struct lpc32xx_nand_cfg_slc *lpc32xx_parse_dt(struct device *dev)
 {
-	struct lpc32xx_nand_cfg_slc *pdata;
+	struct lpc32xx_nand_cfg_slc *ncfg;
 	struct device_node *np = dev->of_node;
 
-	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata) {
-		dev_err(dev, "could not allocate memory for platform data\n");
+	ncfg = devm_kzalloc(dev, sizeof(*ncfg), GFP_KERNEL);
+	if (!ncfg) {
+		dev_err(dev, "could not allocate memory for NAND config\n");
 		return NULL;
 	}
 
-	of_property_read_u32(np, "nxp,wdr-clks", &pdata->wdr_clks);
-	of_property_read_u32(np, "nxp,wwidth", &pdata->wwidth);
-	of_property_read_u32(np, "nxp,whold", &pdata->whold);
-	of_property_read_u32(np, "nxp,wsetup", &pdata->wsetup);
-	of_property_read_u32(np, "nxp,rdr-clks", &pdata->rdr_clks);
-	of_property_read_u32(np, "nxp,rwidth", &pdata->rwidth);
-	of_property_read_u32(np, "nxp,rhold", &pdata->rhold);
-	of_property_read_u32(np, "nxp,rsetup", &pdata->rsetup);
-
-	if (!pdata->wdr_clks || !pdata->wwidth || !pdata->whold ||
-	    !pdata->wsetup || !pdata->rdr_clks || !pdata->rwidth ||
-	    !pdata->rhold || !pdata->rsetup) {
+	of_property_read_u32(np, "nxp,wdr-clks", &ncfg->wdr_clks);
+	of_property_read_u32(np, "nxp,wwidth", &ncfg->wwidth);
+	of_property_read_u32(np, "nxp,whold", &ncfg->whold);
+	of_property_read_u32(np, "nxp,wsetup", &ncfg->wsetup);
+	of_property_read_u32(np, "nxp,rdr-clks", &ncfg->rdr_clks);
+	of_property_read_u32(np, "nxp,rwidth", &ncfg->rwidth);
+	of_property_read_u32(np, "nxp,rhold", &ncfg->rhold);
+	of_property_read_u32(np, "nxp,rsetup", &ncfg->rsetup);
+
+	if (!ncfg->wdr_clks || !ncfg->wwidth || !ncfg->whold ||
+	    !ncfg->wsetup || !ncfg->rdr_clks || !ncfg->rwidth ||
+	    !ncfg->rhold || !ncfg->rsetup) {
 		dev_err(dev, "chip parameters not specified correctly\n");
 		return NULL;
 	}
 
-	pdata->use_bbt = of_get_nand_on_flash_bbt(np);
-	pdata->wp_gpio = of_get_named_gpio(np, "gpios", 0);
+	ncfg->use_bbt = of_get_nand_on_flash_bbt(np);
+	ncfg->wp_gpio = of_get_named_gpio(np, "gpios", 0);
 
-	return pdata;
+	return ncfg;
 }
-#else
-static struct lpc32xx_nand_cfg_slc *lpc32xx_parse_dt(struct device *dev)
-{
-	return NULL;
-}
-#endif
 
 /*
  * Probe for NAND controller
@@ -806,10 +799,9 @@ static int __devinit lpc32xx_nand_probe(
 
 	if (pdev->dev.of_node)
 		host->ncfg = lpc32xx_parse_dt(&pdev->dev);
-	else
-		host->ncfg = pdev->dev.platform_data;
 	if (!host->ncfg) {
-		dev_err(&pdev->dev, "Missing platform data\n");
+		dev_err(&pdev->dev,
+			"Missing or bad NAND config from device tree\n");
 		return -ENOENT;
 	}
 	if (host->ncfg->wp_gpio == -EPROBE_DEFER)
@@ -1035,13 +1027,11 @@ static int lpc32xx_nand_suspend(struct p
 #define lpc32xx_nand_suspend NULL
 #endif
 
-#if defined(CONFIG_OF)
 static const struct of_device_id lpc32xx_nand_match[] = {
 	{ .compatible = "nxp,lpc3220-slc" },
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, lpc32xx_nand_match);
-#endif
 
 static struct platform_driver lpc32xx_nand_driver = {
 	.probe		= lpc32xx_nand_probe,
