Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863Ab1CYIpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 04:45:44 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41335 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab1CYIpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 04:45:35 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: devicetree-discuss@lists.ozlabs.org, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 1/5] mmc: sdhci: make sdhci-pltfm device drivers self registered
Date: Fri, 25 Mar 2011 16:48:47 +0800
Message-Id: <1301042931-4869-2-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
References: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch turns the common stuff in sdhci-pltfm.c into functions, and
add device drivers their own .probe and .remove which in turn call
into the common functions, so that those sdhci-pltfm device drivers
register itself and keep all device specific things away from common
sdhci-pltfm file.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/mmc/host/Kconfig           |   24 +++--
 drivers/mmc/host/Makefile          |   11 +-
 drivers/mmc/host/sdhci-cns3xxx.c   |   67 +++++++++++++-
 drivers/mmc/host/sdhci-dove.c      |   69 +++++++++++++-
 drivers/mmc/host/sdhci-esdhc-imx.c |   97 +++++++++++++++----
 drivers/mmc/host/sdhci-pltfm.c     |  165 ++-----------------------------
 drivers/mmc/host/sdhci-pltfm.h     |   14 ++-
 drivers/mmc/host/sdhci-tegra.c     |  187 +++++++++++++++++++++---------------
 include/linux/mmc/sdhci-pltfm.h    |    6 -
 9 files changed, 360 insertions(+), 280 deletions(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index afe8c6f..1db9347 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -113,20 +113,17 @@ config MMC_SDHCI_OF_HLWD
 	  If unsure, say N.
 
 config MMC_SDHCI_PLTFM
-	tristate "SDHCI support on the platform specific bus"
+	bool
 	depends on MMC_SDHCI
 	help
-	  This selects the platform specific bus support for Secure Digital Host
-	  Controller Interface.
-
-	  If you have a controller with this interface, say Y or M here.
-
-	  If unsure, say N.
+	  This selects the platform common function support for Secure Digital
+	  Host Controller Interface.
 
 config MMC_SDHCI_CNS3XXX
 	bool "SDHCI support on the Cavium Networks CNS3xxx SoC"
 	depends on ARCH_CNS3XXX
-	depends on MMC_SDHCI_PLTFM
+	depends on MMC_SDHCI
+	select MMC_SDHCI_PLTFM
 	help
 	  This selects the SDHCI support for CNS3xxx System-on-Chip devices.
 
@@ -134,7 +131,9 @@ config MMC_SDHCI_CNS3XXX
 
 config MMC_SDHCI_ESDHC_IMX
 	bool "SDHCI platform support for the Freescale eSDHC i.MX controller"
-	depends on MMC_SDHCI_PLTFM && (ARCH_MX25 || ARCH_MX35 || ARCH_MX5)
+	depends on ARCH_MX25 || ARCH_MX35 || ARCH_MX5
+	depends on MMC_SDHCI
+	select MMC_SDHCI_PLTFM
 	select MMC_SDHCI_IO_ACCESSORS
 	help
 	  This selects the Freescale eSDHC controller support on the platform
@@ -145,7 +144,8 @@ config MMC_SDHCI_ESDHC_IMX
 config MMC_SDHCI_DOVE
 	bool "SDHCI support on Marvell's Dove SoC"
 	depends on ARCH_DOVE
-	depends on MMC_SDHCI_PLTFM
+	depends on MMC_SDHCI
+	select MMC_SDHCI_PLTFM
 	select MMC_SDHCI_IO_ACCESSORS
 	help
 	  This selects the Secure Digital Host Controller Interface in
@@ -155,7 +155,9 @@ config MMC_SDHCI_DOVE
 
 config MMC_SDHCI_TEGRA
 	tristate "SDHCI platform support for the Tegra SD/MMC Controller"
-	depends on MMC_SDHCI_PLTFM && ARCH_TEGRA
+	depends on ARCH_TEGRA
+	depends on MMC_SDHCI
+	select MMC_SDHCI_PLTFM
 	select MMC_SDHCI_IO_ACCESSORS
 	help
 	  This selects the Tegra SD/MMC controller. If you have a Tegra
diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index e834fb2..1d8e43d 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -36,12 +36,11 @@ obj-$(CONFIG_MMC_SH_MMCIF)	+= sh_mmcif.o
 obj-$(CONFIG_MMC_JZ4740)	+= jz4740_mmc.o
 obj-$(CONFIG_MMC_USHC)		+= ushc.o
 
-obj-$(CONFIG_MMC_SDHCI_PLTFM)			+= sdhci-platform.o
-sdhci-platform-y				:= sdhci-pltfm.o
-sdhci-platform-$(CONFIG_MMC_SDHCI_CNS3XXX)	+= sdhci-cns3xxx.o
-sdhci-platform-$(CONFIG_MMC_SDHCI_ESDHC_IMX)	+= sdhci-esdhc-imx.o
-sdhci-platform-$(CONFIG_MMC_SDHCI_DOVE)		+= sdhci-dove.o
-sdhci-platform-$(CONFIG_MMC_SDHCI_TEGRA)	+= sdhci-tegra.o
+obj-$(CONFIG_MMC_SDHCI_PLTFM)		+= sdhci-pltfm.o
+obj-$(CONFIG_MMC_SDHCI_CNS3XXX)		+= sdhci-cns3xxx.o
+obj-$(CONFIG_MMC_SDHCI_ESDHC_IMX)	+= sdhci-esdhc-imx.o
+obj-$(CONFIG_MMC_SDHCI_DOVE)		+= sdhci-dove.o
+obj-$(CONFIG_MMC_SDHCI_TEGRA)		+= sdhci-tegra.o
 
 obj-$(CONFIG_MMC_SDHCI_OF)	+= sdhci-of.o
 sdhci-of-y				:= sdhci-of-core.o
diff --git a/drivers/mmc/host/sdhci-cns3xxx.c b/drivers/mmc/host/sdhci-cns3xxx.c
index 9ebd1d7..95b9080 100644
--- a/drivers/mmc/host/sdhci-cns3xxx.c
+++ b/drivers/mmc/host/sdhci-cns3xxx.c
@@ -86,7 +86,7 @@ static struct sdhci_ops sdhci_cns3xxx_ops = {
 	.set_clock	= sdhci_cns3xxx_set_clock,
 };
 
-struct sdhci_pltfm_data sdhci_cns3xxx_pdata = {
+static struct sdhci_pltfm_data sdhci_cns3xxx_pdata = {
 	.ops = &sdhci_cns3xxx_ops,
 	.quirks = SDHCI_QUIRK_BROKEN_DMA |
 		  SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
@@ -95,3 +95,68 @@ struct sdhci_pltfm_data sdhci_cns3xxx_pdata = {
 		  SDHCI_QUIRK_BROKEN_TIMEOUT_VAL |
 		  SDHCI_QUIRK_NONSTANDARD_CLOCK,
 };
+
+static int __devinit sdhci_cns3xxx_probe(struct platform_device *pdev)
+{
+	struct sdhci_host *host;
+	int ret;
+
+	host = sdhci_pltfm_init(pdev, &sdhci_cns3xxx_pdata);
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
+static int __devexit sdhci_cns3xxx_remove(struct platform_device *pdev)
+{
+	struct sdhci_host *host = platform_get_drvdata(pdev);
+	int dead = 0;
+	u32 scratch;
+
+	scratch = readl(host->ioaddr + SDHCI_INT_STATUS);
+	if (scratch == (u32)-1)
+		dead = 1;
+
+	sdhci_remove_host(host, dead);
+	sdhci_pltfm_free(pdev);
+
+	return 0;
+}
+
+static struct platform_driver sdhci_cns3xxx_driver = {
+	.driver		= {
+		.name	= "sdhci-cns3xxx",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= sdhci_cns3xxx_probe,
+	.remove		= __devexit_p(sdhci_cns3xxx_remove),
+#ifdef CONFIG_PM
+	.suspend	= sdhci_pltfm_suspend,
+	.resume		= sdhci_pltfm_resume,
+#endif
+};
+
+static int __init sdhci_cns3xxx_init(void)
+{
+	return platform_driver_register(&sdhci_cns3xxx_driver);
+}
+module_init(sdhci_cns3xxx_init);
+
+static void __exit sdhci_cns3xxx_exit(void)
+{
+	platform_driver_unregister(&sdhci_cns3xxx_driver);
+}
+module_exit(sdhci_cns3xxx_exit);
+
+MODULE_DESCRIPTION("SDHCI driver for CNS3xxx");
+MODULE_AUTHOR("Anton Vorontsov <avorontsov@mvista.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/mmc/host/sdhci-dove.c b/drivers/mmc/host/sdhci-dove.c
index 2aeef4f..6926d4a 100644
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
@@ -61,10 +61,75 @@ static struct sdhci_ops sdhci_dove_ops = {
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
+	sdhci_remove_host(host, dead);
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
+module_init(sdhci_dove_init);
+
+static void __exit sdhci_dove_exit(void)
+{
+	platform_driver_unregister(&sdhci_dove_driver);
+}
+module_exit(sdhci_dove_exit);
+
+MODULE_DESCRIPTION("SDHCI driver for Dove");
+MODULE_AUTHOR("Saeed Bishara <saeed@marvell.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index 9b82910..c9eb507 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -100,15 +100,39 @@ static unsigned int esdhc_pltfm_get_min_clock(struct sdhci_host *host)
 	return clk_get_rate(pltfm_host->clk) / 256 / 16;
 }
 
-static int esdhc_pltfm_init(struct sdhci_host *host, struct sdhci_pltfm_data *pdata)
+static struct sdhci_ops sdhci_esdhc_ops = {
+	.read_w = esdhc_readw_le,
+	.write_w = esdhc_writew_le,
+	.write_b = esdhc_writeb_le,
+	.set_clock = esdhc_set_clock,
+	.get_max_clock = esdhc_pltfm_get_max_clock,
+	.get_min_clock = esdhc_pltfm_get_min_clock,
+};
+
+static struct sdhci_pltfm_data sdhci_esdhc_imx_pdata = {
+	.quirks = ESDHC_DEFAULT_QUIRKS | SDHCI_QUIRK_BROKEN_ADMA,
+	/* ADMA has issues. Might be fixable */
+	.ops = &sdhci_esdhc_ops,
+};
+
+static int __devinit sdhci_esdhc_imx_probe(struct platform_device *pdev)
 {
-	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct sdhci_pltfm_host *pltfm_host;
+	struct sdhci_host *host;
 	struct clk *clk;
+	int ret;
+
+	host = sdhci_pltfm_init(pdev, &sdhci_esdhc_imx_pdata);
+	if (!host)
+		return -ENOMEM;
+
+	pltfm_host = sdhci_priv(host);
 
 	clk = clk_get(mmc_dev(host->mmc), NULL);
 	if (IS_ERR(clk)) {
 		dev_err(mmc_dev(host->mmc), "clk err\n");
-		return PTR_ERR(clk);
+		ret = PTR_ERR(clk);
+		goto err_clk_get;
 	}
 	clk_enable(clk);
 	pltfm_host->clk = clk;
@@ -120,30 +144,67 @@ static int esdhc_pltfm_init(struct sdhci_host *host, struct sdhci_pltfm_data *pd
 	if (cpu_is_mx25() || cpu_is_mx35())
 		host->quirks |= SDHCI_QUIRK_NO_MULTIBLOCK;
 
+	ret = sdhci_add_host(host);
+	if (ret)
+		goto err_add_host;
+
 	return 0;
+
+err_add_host:
+	clk_disable(pltfm_host->clk);
+	clk_put(pltfm_host->clk);
+err_clk_get:
+	sdhci_pltfm_free(pdev);
+	return ret;
 }
 
-static void esdhc_pltfm_exit(struct sdhci_host *host)
+static int __devexit sdhci_esdhc_imx_remove(struct platform_device *pdev)
 {
+	struct sdhci_host *host = platform_get_drvdata(pdev);
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	int dead = 0;
+	u32 scratch;
+
+	scratch = readl(host->ioaddr + SDHCI_INT_STATUS);
+	if (scratch == (u32)-1)
+		dead = 1;
+
+	sdhci_remove_host(host, dead);
 
 	clk_disable(pltfm_host->clk);
 	clk_put(pltfm_host->clk);
+
+	sdhci_pltfm_free(pdev);
+
+	return 0;
 }
 
-static struct sdhci_ops sdhci_esdhc_ops = {
-	.read_w = esdhc_readw_le,
-	.write_w = esdhc_writew_le,
-	.write_b = esdhc_writeb_le,
-	.set_clock = esdhc_set_clock,
-	.get_max_clock = esdhc_pltfm_get_max_clock,
-	.get_min_clock = esdhc_pltfm_get_min_clock,
+static struct platform_driver sdhci_esdhc_imx_driver = {
+	.driver		= {
+		.name	= "sdhci-esdhc-imx",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= sdhci_esdhc_imx_probe,
+	.remove		= __devexit_p(sdhci_esdhc_imx_remove),
+#ifdef CONFIG_PM
+	.suspend	= sdhci_pltfm_suspend,
+	.resume		= sdhci_pltfm_resume,
+#endif
 };
 
-struct sdhci_pltfm_data sdhci_esdhc_imx_pdata = {
-	.quirks = ESDHC_DEFAULT_QUIRKS | SDHCI_QUIRK_BROKEN_ADMA,
-	/* ADMA has issues. Might be fixable */
-	.ops = &sdhci_esdhc_ops,
-	.init = esdhc_pltfm_init,
-	.exit = esdhc_pltfm_exit,
-};
+static int __init sdhci_esdhc_imx_init(void)
+{
+	return platform_driver_register(&sdhci_esdhc_imx_driver);
+}
+
+static void __exit sdhci_esdhc_imx_exit(void)
+{
+	platform_driver_unregister(&sdhci_esdhc_imx_driver);
+}
+
+module_init(sdhci_esdhc_imx_init);
+module_exit(sdhci_esdhc_imx_exit);
+
+MODULE_DESCRIPTION("SDHCI driver for i.MX eSDHC");
+MODULE_AUTHOR("Wolfram Sang <w.sang@pengutronix.de>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/mmc/host/sdhci-pltfm.c b/drivers/mmc/host/sdhci-pltfm.c
index ccc04ac..63e45aa 100644
--- a/drivers/mmc/host/sdhci-pltfm.c
+++ b/drivers/mmc/host/sdhci-pltfm.c
@@ -22,70 +22,22 @@
  * Inspired by sdhci-pci.c, by Pierre Ossman
  */
 
-#include <linux/delay.h>
-#include <linux/highmem.h>
-#include <linux/mod_devicetable.h>
-#include <linux/platform_device.h>
-
-#include <linux/mmc/host.h>
-
-#include <linux/io.h>
-#include <linux/mmc/sdhci-pltfm.h>
+#include <linux/err.h>
 
 #include "sdhci.h"
 #include "sdhci-pltfm.h"
 
-/*****************************************************************************\
- *                                                                           *
- * SDHCI core callbacks                                                      *
- *                                                                           *
-\*****************************************************************************/
-
 static struct sdhci_ops sdhci_pltfm_ops = {
 };
 
-/*****************************************************************************\
- *                                                                           *
- * Device probing/removal                                                    *
- *                                                                           *
-\*****************************************************************************/
-#if defined(CONFIG_OF)
-#include <linux/of_device.h>
-static const struct of_device_id sdhci_dt_ids[] = {
-	{ .compatible = "nvidia,tegra250-sdhci", .data = &sdhci_tegra_dt_pdata },
-	{ }
-};
-MODULE_DEVICE_TABLE(platform, sdhci_dt_ids);
-
-static const struct of_device_id *sdhci_get_of_device_id(struct platform_device *pdev)
-{
-	return of_match_device(sdhci_dt_ids, &pdev->dev);
-}
-#else
-#define shdci_dt_ids NULL
-static inline struct of_device_id *sdhci_get_of_device_id(struct platform_device *pdev)
-{
-	return NULL;
-}
-#endif
-
-static int __devinit sdhci_pltfm_probe(struct platform_device *pdev)
+struct sdhci_host *sdhci_pltfm_init(struct platform_device *pdev,
+				    struct sdhci_pltfm_data *pdata)
 {
-	const struct platform_device_id *platid = platform_get_device_id(pdev);
-	const struct of_device_id *dtid = sdhci_get_of_device_id(pdev);
-	struct sdhci_pltfm_data *pdata;
 	struct sdhci_host *host;
 	struct sdhci_pltfm_host *pltfm_host;
 	struct resource *iomem;
 	int ret;
 
-	if (platid && platid->driver_data)
-		pdata = (void *)platid->driver_data;
-	else if (dtid && dtid->data)
-		pdata = dtid->data;
-	else
-		pdata = pdev->dev.platform_data;
-
 	iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!iomem) {
 		ret = -ENOMEM;
@@ -93,8 +45,7 @@ static int __devinit sdhci_pltfm_probe(struct platform_device *pdev)
 	}
 
 	if (resource_size(iomem) < 0x100)
-		dev_err(&pdev->dev, "Invalid iomem size. You may "
-			"experience problems.\n");
+		dev_err(&pdev->dev, "Invalid iomem size!\n");
 
 	/* Some PCI-based MFD need the parent here */
 	if (pdev->dev.parent != &platform_bus)
@@ -109,7 +60,7 @@ static int __devinit sdhci_pltfm_probe(struct platform_device *pdev)
 
 	pltfm_host = sdhci_priv(host);
 
-	host->hw_name = "platform";
+	host->hw_name = dev_name(&pdev->dev);
 	if (pdata && pdata->ops)
 		host->ops = pdata->ops;
 	else
@@ -132,136 +83,42 @@ static int __devinit sdhci_pltfm_probe(struct platform_device *pdev)
 		goto err_remap;
 	}
 
-	if (pdata && pdata->init) {
-		ret = pdata->init(host, pdata);
-		if (ret)
-			goto err_plat_init;
-	}
-
-	ret = sdhci_add_host(host);
-	if (ret)
-		goto err_add_host;
-
 	platform_set_drvdata(pdev, host);
 
-	return 0;
+	return host;
 
-err_add_host:
-	if (pdata && pdata->exit)
-		pdata->exit(host);
-err_plat_init:
-	iounmap(host->ioaddr);
 err_remap:
 	release_mem_region(iomem->start, resource_size(iomem));
 err_request:
 	sdhci_free_host(host);
 err:
-	printk(KERN_ERR"Probing of sdhci-pltfm failed: %d\n", ret);
-	return ret;
+	pr_err("%s failed %d\n", __func__, ret);
+	return NULL;
 }
 
-static int __devexit sdhci_pltfm_remove(struct platform_device *pdev)
+void sdhci_pltfm_free(struct platform_device *pdev)
 {
-	const struct platform_device_id *platid = platform_get_device_id(pdev);
-	const struct of_device_id *dtid = sdhci_get_of_device_id(pdev);
-	struct sdhci_pltfm_data *pdata;
 	struct sdhci_host *host = platform_get_drvdata(pdev);
 	struct resource *iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	int dead;
-	u32 scratch;
 
-	if (platid && platid->driver_data)
-		pdata = (void *)platid->driver_data;
-	else if (dtid && dtid->data)
-		pdata = dtid->data;
-	else
-		pdata = pdev->dev.platform_data;
-
-	dead = 0;
-	scratch = readl(host->ioaddr + SDHCI_INT_STATUS);
-	if (scratch == (u32)-1)
-		dead = 1;
-
-	sdhci_remove_host(host, dead);
-	if (pdata && pdata->exit)
-		pdata->exit(host);
 	iounmap(host->ioaddr);
 	release_mem_region(iomem->start, resource_size(iomem));
 	sdhci_free_host(host);
 	platform_set_drvdata(pdev, NULL);
-
-	return 0;
 }
 
-static const struct platform_device_id sdhci_pltfm_ids[] = {
-	{ "sdhci", },
-#ifdef CONFIG_MMC_SDHCI_CNS3XXX
-	{ "sdhci-cns3xxx", (kernel_ulong_t)&sdhci_cns3xxx_pdata },
-#endif
-#ifdef CONFIG_MMC_SDHCI_ESDHC_IMX
-	{ "sdhci-esdhc-imx", (kernel_ulong_t)&sdhci_esdhc_imx_pdata },
-#endif
-#ifdef CONFIG_MMC_SDHCI_DOVE
-	{ "sdhci-dove", (kernel_ulong_t)&sdhci_dove_pdata },
-#endif
-#ifdef CONFIG_MMC_SDHCI_TEGRA
-	{ "sdhci-tegra", (kernel_ulong_t)&sdhci_tegra_pdata },
-#endif
-	{ },
-};
-MODULE_DEVICE_TABLE(platform, sdhci_pltfm_ids);
-
 #ifdef CONFIG_PM
-static int sdhci_pltfm_suspend(struct platform_device *dev, pm_message_t state)
+int sdhci_pltfm_suspend(struct platform_device *dev, pm_message_t state)
 {
 	struct sdhci_host *host = platform_get_drvdata(dev);
 
 	return sdhci_suspend_host(host, state);
 }
 
-static int sdhci_pltfm_resume(struct platform_device *dev)
+int sdhci_pltfm_resume(struct platform_device *dev)
 {
 	struct sdhci_host *host = platform_get_drvdata(dev);
 
 	return sdhci_resume_host(host);
 }
-#else
-#define sdhci_pltfm_suspend	NULL
-#define sdhci_pltfm_resume	NULL
 #endif	/* CONFIG_PM */
-
-static struct platform_driver sdhci_pltfm_driver = {
-	.driver = {
-		.name	= "sdhci",
-		.owner	= THIS_MODULE,
-		.of_match_table = sdhci_dt_ids,
-	},
-	.probe		= sdhci_pltfm_probe,
-	.remove		= __devexit_p(sdhci_pltfm_remove),
-	.id_table	= sdhci_pltfm_ids,
-	.suspend	= sdhci_pltfm_suspend,
-	.resume		= sdhci_pltfm_resume,
-};
-
-/*****************************************************************************\
- *                                                                           *
- * Driver init/exit                                                          *
- *                                                                           *
-\*****************************************************************************/
-
-static int __init sdhci_drv_init(void)
-{
-	return platform_driver_register(&sdhci_pltfm_driver);
-}
-
-static void __exit sdhci_drv_exit(void)
-{
-	platform_driver_unregister(&sdhci_pltfm_driver);
-}
-
-module_init(sdhci_drv_init);
-module_exit(sdhci_drv_exit);
-
-MODULE_DESCRIPTION("Secure Digital Host Controller Interface platform driver");
-MODULE_AUTHOR("Mocean Laboratories <info@mocean-labs.com>");
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/mmc/host/sdhci-pltfm.h b/drivers/mmc/host/sdhci-pltfm.h
index c67523d..a3e4be0 100644
--- a/drivers/mmc/host/sdhci-pltfm.h
+++ b/drivers/mmc/host/sdhci-pltfm.h
@@ -13,6 +13,7 @@
 
 #include <linux/clk.h>
 #include <linux/types.h>
+#include <linux/platform_device.h>
 #include <linux/mmc/sdhci-pltfm.h>
 
 struct sdhci_pltfm_host {
@@ -20,10 +21,13 @@ struct sdhci_pltfm_host {
 	u32 scratchpad; /* to handle quirks across io-accessor calls */
 };
 
-extern struct sdhci_pltfm_data sdhci_cns3xxx_pdata;
-extern struct sdhci_pltfm_data sdhci_esdhc_imx_pdata;
-extern struct sdhci_pltfm_data sdhci_dove_pdata;
-extern struct sdhci_pltfm_data sdhci_tegra_pdata;
-extern struct sdhci_pltfm_data sdhci_tegra_dt_pdata;
+extern struct sdhci_host *sdhci_pltfm_init(struct platform_device *pdev,
+					   struct sdhci_pltfm_data *pdata);
+extern void sdhci_pltfm_free(struct platform_device *pdev);
+
+#ifdef CONFIG_PM
+extern int sdhci_pltfm_suspend(struct platform_device *dev, pm_message_t state);
+extern int sdhci_pltfm_resume(struct platform_device *dev);
+#endif
 
 #endif /* _DRIVERS_MMC_SDHCI_PLTFM_H */
diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index c3d6f83..cfcd521 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -119,19 +119,58 @@ static int tegra_sdhci_8bit(struct sdhci_host *host, int bus_width)
 }
 
 
-static int tegra_sdhci_pltfm_init(struct sdhci_host *host,
-				  struct sdhci_pltfm_data *pdata)
+static struct sdhci_ops tegra_sdhci_ops = {
+	.get_ro     = tegra_sdhci_get_ro,
+	.read_l     = tegra_sdhci_readl,
+	.read_w     = tegra_sdhci_readw,
+	.write_l    = tegra_sdhci_writel,
+	.platform_8bit_width = tegra_sdhci_8bit,
+};
+
+static struct sdhci_pltfm_data sdhci_tegra_pdata = {
+	.quirks = SDHCI_QUIRK_BROKEN_TIMEOUT_VAL |
+		  SDHCI_QUIRK_SINGLE_POWER_WRITE |
+		  SDHCI_QUIRK_NO_HISPD_BIT |
+		  SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC,
+	.ops  = &tegra_sdhci_ops,
+};
+
+static int __devinit sdhci_tegra_probe(struct platform_device *pdev)
 {
-	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
-	struct platform_device *pdev = to_platform_device(mmc_dev(host->mmc));
+	struct sdhci_pltfm_host *pltfm_host;
 	struct tegra_sdhci_platform_data *plat;
+	struct sdhci_host *host;
 	struct clk *clk;
 	int rc;
 
+	host = sdhci_pltfm_init(pdev, &sdhci_tegra_pdata);
+	if (!host)
+		return -ENOMEM;
+
+	pltfm_host = sdhci_priv(host);
+
 	plat = pdev->dev.platform_data;
+
+#ifdef CONFIG_OF
+	plat = kzalloc(sizeof(*plat), GFP_KERNEL);
+	if (!plat) {
+		rc = -ENOMEM;
+		goto err_no_plat;
+	}
+	pdev->dev.platform_data = plat;
+
+	plat->cd_gpio = of_get_gpio(pdev->dev.of_node, 0);
+	plat->wp_gpio = of_get_gpio(pdev->dev.of_node, 1);
+	plat->power_gpio = of_get_gpio(pdev->dev.of_node, 2);
+
+	dev_info(&pdev->dev, "using gpios cd=%i, wp=%i power=%i\n",
+		plat->cd_gpio, plat->wp_gpio, plat->power_gpio);
+#endif
+
 	if (plat == NULL) {
 		dev_err(mmc_dev(host->mmc), "missing platform data\n");
-		return -ENXIO;
+		rc = -ENXIO;
+		goto err_no_plat;
 	}
 
 	if (gpio_is_valid(plat->power_gpio)) {
@@ -139,7 +178,7 @@ static int tegra_sdhci_pltfm_init(struct sdhci_host *host,
 		if (rc) {
 			dev_err(mmc_dev(host->mmc),
 				"failed to allocate power gpio\n");
-			goto out;
+			goto err_power_req;
 		}
 		tegra_gpio_enable(plat->power_gpio);
 		gpio_direction_output(plat->power_gpio, 1);
@@ -150,7 +189,7 @@ static int tegra_sdhci_pltfm_init(struct sdhci_host *host,
 		if (rc) {
 			dev_err(mmc_dev(host->mmc),
 				"failed to allocate cd gpio\n");
-			goto out_power;
+			goto err_cd_req;
 		}
 		tegra_gpio_enable(plat->cd_gpio);
 		gpio_direction_input(plat->cd_gpio);
@@ -161,7 +200,7 @@ static int tegra_sdhci_pltfm_init(struct sdhci_host *host,
 
 		if (rc)	{
 			dev_err(mmc_dev(host->mmc), "request irq error\n");
-			goto out_cd;
+			goto err_cd_irq_req;
 		}
 
 	}
@@ -171,7 +210,7 @@ static int tegra_sdhci_pltfm_init(struct sdhci_host *host,
 		if (rc) {
 			dev_err(mmc_dev(host->mmc),
 				"failed to allocate wp gpio\n");
-			goto out_cd;
+			goto err_wp_req;
 		}
 		tegra_gpio_enable(plat->wp_gpio);
 		gpio_direction_input(plat->wp_gpio);
@@ -181,7 +220,7 @@ static int tegra_sdhci_pltfm_init(struct sdhci_host *host,
 	if (IS_ERR(clk)) {
 		dev_err(mmc_dev(host->mmc), "clk err\n");
 		rc = PTR_ERR(clk);
-		goto out_wp;
+		goto err_clk_get;
 	}
 	clk_enable(clk);
 	pltfm_host->clk = clk;
@@ -189,62 +228,56 @@ static int tegra_sdhci_pltfm_init(struct sdhci_host *host,
 	if (plat->is_8bit)
 		host->mmc->caps |= MMC_CAP_8_BIT_DATA;
 
+	rc = sdhci_add_host(host);
+	if (rc)
+		goto err_add_host;
+
 	return 0;
 
-out_wp:
+err_add_host:
+	clk_disable(pltfm_host->clk);
+	clk_put(pltfm_host->clk);
+err_clk_get:
 	if (gpio_is_valid(plat->wp_gpio)) {
 		tegra_gpio_disable(plat->wp_gpio);
 		gpio_free(plat->wp_gpio);
 	}
-
-out_cd:
+err_wp_req:
+	if (gpio_is_valid(plat->cd_gpio)) {
+		free_irq(gpio_to_irq(plat->cd_gpio), host);
+	}
+err_cd_irq_req:
 	if (gpio_is_valid(plat->cd_gpio)) {
 		tegra_gpio_disable(plat->cd_gpio);
 		gpio_free(plat->cd_gpio);
 	}
-
-out_power:
+err_cd_req:
 	if (gpio_is_valid(plat->power_gpio)) {
 		tegra_gpio_disable(plat->power_gpio);
 		gpio_free(plat->power_gpio);
 	}
-
-out:
+err_power_req:
+#ifdef CONFIG_OF
+	kfree(plat);
+#endif
+err_no_plat:
+	sdhci_pltfm_free(pdev);
 	return rc;
 }
 
-static int tegra_sdhci_pltfm_dt_init(struct sdhci_host *host,
-				     struct sdhci_pltfm_data *pdata)
+static int __devexit sdhci_tegra_remove(struct platform_device *pdev)
 {
-	struct platform_device *pdev = to_platform_device(mmc_dev(host->mmc));
+	struct sdhci_host *host = platform_get_drvdata(pdev);
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct tegra_sdhci_platform_data *plat;
+	int dead = 0;
+	u32 scratch;
 
-	if (pdev->dev.platform_data) {
-		dev_err(&pdev->dev, "%s: platform_data not NULL; aborting\n",
-			__func__);
-		return -ENODEV;
-	}
+	scratch = readl(host->ioaddr + SDHCI_INT_STATUS);
+	if (scratch == (u32)-1)
+		dead = 1;
 
-	plat = kzalloc(sizeof(*plat), GFP_KERNEL);
-	if (!plat)
-		return -ENOMEM;
-	pdev->dev.platform_data = plat;
-
-	plat->cd_gpio = of_get_gpio(pdev->dev.of_node, 0);
-	plat->wp_gpio = of_get_gpio(pdev->dev.of_node, 1);
-	plat->power_gpio = of_get_gpio(pdev->dev.of_node, 2);
-
-	dev_info(&pdev->dev, "using gpios cd=%i, wp=%i power=%i\n",
-		plat->cd_gpio, plat->wp_gpio, plat->power_gpio);
-
-	return tegra_sdhci_pltfm_init(host, pdata);
-}
-
-static void tegra_sdhci_pltfm_exit(struct sdhci_host *host)
-{
-	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
-	struct platform_device *pdev = to_platform_device(mmc_dev(host->mmc));
-	struct tegra_sdhci_platform_data *plat;
+	sdhci_remove_host(host, dead);
 
 	plat = pdev->dev.platform_data;
 
@@ -263,44 +296,44 @@ static void tegra_sdhci_pltfm_exit(struct sdhci_host *host)
 		gpio_free(plat->power_gpio);
 	}
 
+#ifdef CONFIG_OF
+	kfree(pdev->dev.platform_data);
+	pdev->dev.platform_data = NULL;
+#endif
+
 	clk_disable(pltfm_host->clk);
 	clk_put(pltfm_host->clk);
-}
 
-static void tegra_sdhci_pltfm_dt_exit(struct sdhci_host *host)
-{
-	struct platform_device *pdev = to_platform_device(mmc_dev(host->mmc));
-
-	tegra_sdhci_pltfm_exit(host);
+	sdhci_pltfm_free(pdev);
 
-	kfree(pdev->dev.platform_data);
-	pdev->dev.platform_data = NULL;
+	return 0;
 }
 
-static struct sdhci_ops tegra_sdhci_ops = {
-	.get_ro     = tegra_sdhci_get_ro,
-	.read_l     = tegra_sdhci_readl,
-	.read_w     = tegra_sdhci_readw,
-	.write_l    = tegra_sdhci_writel,
-	.platform_8bit_width = tegra_sdhci_8bit,
+static struct platform_driver sdhci_tegra_driver = {
+	.driver		= {
+		.name	= "sdhci-tegra",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= sdhci_tegra_probe,
+	.remove		= __devexit_p(sdhci_tegra_remove),
+#ifdef CONFIG_PM
+	.suspend	= sdhci_pltfm_suspend,
+	.resume		= sdhci_pltfm_resume,
+#endif
 };
 
-struct sdhci_pltfm_data sdhci_tegra_pdata = {
-	.quirks = SDHCI_QUIRK_BROKEN_TIMEOUT_VAL |
-		  SDHCI_QUIRK_SINGLE_POWER_WRITE |
-		  SDHCI_QUIRK_NO_HISPD_BIT |
-		  SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC,
-	.ops  = &tegra_sdhci_ops,
-	.init = tegra_sdhci_pltfm_init,
-	.exit = tegra_sdhci_pltfm_exit,
-};
+static int __init sdhci_tegra_init(void)
+{
+	return platform_driver_register(&sdhci_tegra_driver);
+}
+module_init(sdhci_tegra_init);
 
-struct sdhci_pltfm_data sdhci_tegra_dt_pdata = {
-	.quirks = SDHCI_QUIRK_BROKEN_TIMEOUT_VAL |
-		  SDHCI_QUIRK_SINGLE_POWER_WRITE |
-		  SDHCI_QUIRK_NO_HISPD_BIT |
-		  SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC,
-	.ops  = &tegra_sdhci_ops,
-	.init = tegra_sdhci_pltfm_dt_init,
-	.exit = tegra_sdhci_pltfm_dt_exit,
-};
+static void __exit sdhci_tegra_exit(void)
+{
+	platform_driver_unregister(&sdhci_tegra_driver);
+}
+module_exit(sdhci_tegra_exit);
+
+MODULE_DESCRIPTION("SDHCI driver for Tegra");
+MODULE_AUTHOR(" Google, Inc.");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mmc/sdhci-pltfm.h b/include/linux/mmc/sdhci-pltfm.h
index 548d59d..f1c2ac3 100644
--- a/include/linux/mmc/sdhci-pltfm.h
+++ b/include/linux/mmc/sdhci-pltfm.h
@@ -15,21 +15,15 @@
 #define _SDHCI_PLTFM_H
 
 struct sdhci_ops;
-struct sdhci_host;
 
 /**
  * struct sdhci_pltfm_data - SDHCI platform-specific information & hooks
  * @ops: optional pointer to the platform-provided SDHCI ops
  * @quirks: optional SDHCI quirks
- * @init: optional hook that is called during device probe, before the
- *        driver tries to access any SDHCI registers
- * @exit: optional hook that is called during device removal
  */
 struct sdhci_pltfm_data {
 	struct sdhci_ops *ops;
 	unsigned int quirks;
-	int (*init)(struct sdhci_host *host, struct sdhci_pltfm_data *pdata);
-	void (*exit)(struct sdhci_host *host);
 };
 
 #endif /* _SDHCI_PLTFM_H */
-- 
1.7.1

