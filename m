Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab1CUIEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 04:04:52 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34292 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab1CUIEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 04:04:49 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: devicetree-discuss@lists.ozlabs.org, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, sameo@linux.intel.com, grant.likely@secretlab.ca,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 3/5] mmc: sdhci: make sdhci-dove driver self registered
Date: Mon, 21 Mar 2011 16:07:01 +0800
Message-Id: <1300694823-8300-4-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1300694823-8300-1-git-send-email-shawn.guo@linaro.org>
References: <1300694823-8300-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adds sdhci-dove its own .probe and .remove which in turn
call into the common functions provided by sdhci-pltfm.c, so that
sdhci-dove driver registers itself and keep all sdhci-dove specific
things like sdhci_dove_pdata away from sdhci-pltfm.c which is common.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/mmc/host/sdhci-dove.c  |   70 ++++++++++++++++++++++++++++++++++++++-
 drivers/mmc/host/sdhci-pltfm.c |    3 --
 drivers/mmc/host/sdhci-pltfm.h |    1 -
 3 files changed, 68 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/sdhci-dove.c b/drivers/mmc/host/sdhci-dove.c
index 2aeef4f..e985338 100644
--- a/drivers/mmc/host/sdhci-dove.c
+++ b/drivers/mmc/host/sdhci-dove.c
@@ -3,7 +3,7 @@
  *
  * Author: Saeed Bishara <saeed@marvell.com>
  *	   Mike Rapoport <mike@compulab.co.il>
- * Based on sdhci-cns3xxx.c
+ * Based on sdhci-dove.c
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -61,10 +61,76 @@ static struct sdhci_ops sdhci_dove_ops = {
 	.read_l	= sdhci_dove_readl,
 };
 
-struct sdhci_pltfm_data sdhci_dove_pdata = {
+static struct sdhci_pltfm_data sdhci_dove_pdata = {
 	.ops	= &sdhci_dove_ops,
 	.quirks	= SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER |
 		  SDHCI_QUIRK_NO_BUSY_IRQ |
 		  SDHCI_QUIRK_BROKEN_TIMEOUT_VAL |
 		  SDHCI_QUIRK_FORCE_DMA,
 };
+
+static int __devinit sdhci_dove_probe(struct platform_device *pdev)
+{
+	struct sdhci_host *host;
+	int ret;
+
+	host = sdhci_pltfm_init(pdev, &sdhci_dove_pdata);
+	if (!host)
+		return -ENOMEM;
+
+	ret = sdhci_add_host(host);
+	if (ret)
+		goto err_add_host;
+
+	return 0;
+
+err_add_host:
+	sdhci_pltfm_free(pdev);
+	return ret;
+}
+
+static int __devexit sdhci_dove_remove(struct platform_device *pdev)
+{
+	struct sdhci_host *host = platform_get_drvdata(pdev);
+	int dead = 0;
+	u32 scratch;
+
+	scratch = readl(host->ioaddr + SDHCI_INT_STATUS);
+	if (scratch == (u32)-1)
+		dead = 1;
+
+	sdhci_remove_host(pdev, dead);
+	sdhci_pltfm_free(pdev);
+
+	return 0;
+}
+
+static struct platform_driver sdhci_dove_driver = {
+	.driver		= {
+		.name	= "sdhci-dove",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= sdhci_dove_probe,
+	.remove		= __devexit_p(sdhci_dove_remove),
+#ifdef CONFIG_PM
+	.suspend	= sdhci_pltfm_suspend,
+	.resume		= sdhci_pltfm_resume,
+#endif
+};
+
+static int __init sdhci_dove_init(void)
+{
+	return platform_driver_register(&sdhci_dove_driver);
+}
+
+static void __exit sdhci_dove_exit(void)
+{
+	platform_driver_unregister(&sdhci_dove_driver);
+}
+
+module_init(sdhci_dove_init);
+module_exit(sdhci_dove_exit);
+
+MODULE_DESCRIPTION("SDHCI driver for Dove");
+MODULE_AUTHOR("Saeed Bishara <saeed@marvell.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/mmc/host/sdhci-pltfm.c b/drivers/mmc/host/sdhci-pltfm.c
index b9a904d..c4bba33 100644
--- a/drivers/mmc/host/sdhci-pltfm.c
+++ b/drivers/mmc/host/sdhci-pltfm.c
@@ -272,9 +272,6 @@ static int __devexit sdhci_pltfm_remove(struct platform_device *pdev)
 
 static const struct platform_device_id sdhci_pltfm_ids[] = {
 	{ "sdhci", },
-#ifdef CONFIG_MMC_SDHCI_DOVE
-	{ "sdhci-dove", (kernel_ulong_t)&sdhci_dove_pdata },
-#endif
 #ifdef CONFIG_MMC_SDHCI_TEGRA
 	{ "sdhci-tegra", (kernel_ulong_t)&sdhci_tegra_pdata },
 #endif
diff --git a/drivers/mmc/host/sdhci-pltfm.h b/drivers/mmc/host/sdhci-pltfm.h
index 493a8d0..d7267f0 100644
--- a/drivers/mmc/host/sdhci-pltfm.h
+++ b/drivers/mmc/host/sdhci-pltfm.h
@@ -21,7 +21,6 @@ struct sdhci_pltfm_host {
 	u32 scratchpad; /* to handle quirks across io-accessor calls */
 };
 
-extern struct sdhci_pltfm_data sdhci_dove_pdata;
 extern struct sdhci_pltfm_data sdhci_tegra_pdata;
 extern struct sdhci_pltfm_data sdhci_tegra_dt_pdata;
 
-- 
1.7.1

