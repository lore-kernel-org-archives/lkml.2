Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab1CUIFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 04:05:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42334 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab1CUIE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 04:04:59 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: devicetree-discuss@lists.ozlabs.org, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, sameo@linux.intel.com, grant.likely@secretlab.ca,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 4/5] mmc: sdhci: make sdhci-tegra driver self registered
Date: Mon, 21 Mar 2011 16:07:02 +0800
Message-Id: <1300694823-8300-5-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1300694823-8300-1-git-send-email-shawn.guo@linaro.org>
References: <1300694823-8300-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adds sdhci-tegra its own .probe and .remove which in turn
call into the common functions provided by sdhci-pltfm.c, so that
sdhci-tegra driver registers itself and keep all sdhci-tegra specific
things like sdhci_tegra_pdata away from sdhci-pltfm.c which is common.

As sdhci-tegra is the last one remaining in sdhci-pltfm.c, with
removing it out, the .probe and .remove in sdhci-pltfm.c together with
other things like sdhci_dt_ids and sdhci_pltfm_ids can be cleaned up
as well.

Also, having sdhci-tegra handle its own driver registration, the dt
and non-dt support of sdhci-tegra can be consolidated into one pair
of .probe and .remove hooks now.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/mmc/host/sdhci-pltfm.c |  213 +---------------------------------------
 drivers/mmc/host/sdhci-pltfm.h |    3 -
 drivers/mmc/host/sdhci-tegra.c |  189 +++++++++++++++++++++---------------
 3 files changed, 112 insertions(+), 293 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pltfm.c b/drivers/mmc/host/sdhci-pltfm.c
index c4bba33..c300234 100644
--- a/drivers/mmc/host/sdhci-pltfm.c
+++ b/drivers/mmc/host/sdhci-pltfm.c
@@ -22,25 +22,11 @@
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
 
@@ -121,164 +107,6 @@ void sdhci_pltfm_free(struct platform_device *pdev)
 	platform_set_drvdata(pdev, NULL);
 }
 
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
-{
-	const struct platform_device_id *platid = platform_get_device_id(pdev);
-	const struct of_device_id *dtid = sdhci_get_of_device_id(pdev);
-	struct sdhci_pltfm_data *pdata;
-	struct sdhci_host *host;
-	struct sdhci_pltfm_host *pltfm_host;
-	struct resource *iomem;
-	int ret;
-
-	if (platid && platid->driver_data)
-		pdata = (void *)platid->driver_data;
-	else if (dtid && dtid->data)
-		pdata = dtid->data;
-	else
-		pdata = pdev->dev.platform_data;
-
-	iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!iomem) {
-		ret = -ENOMEM;
-		goto err;
-	}
-
-	if (resource_size(iomem) < 0x100)
-		dev_err(&pdev->dev, "Invalid iomem size. You may "
-			"experience problems.\n");
-
-	/* Some PCI-based MFD need the parent here */
-	if (pdev->dev.parent != &platform_bus)
-		host = sdhci_alloc_host(pdev->dev.parent, sizeof(*pltfm_host));
-	else
-		host = sdhci_alloc_host(&pdev->dev, sizeof(*pltfm_host));
-
-	if (IS_ERR(host)) {
-		ret = PTR_ERR(host);
-		goto err;
-	}
-
-	pltfm_host = sdhci_priv(host);
-
-	host->hw_name = "platform";
-	if (pdata && pdata->ops)
-		host->ops = pdata->ops;
-	else
-		host->ops = &sdhci_pltfm_ops;
-	if (pdata)
-		host->quirks = pdata->quirks;
-	host->irq = platform_get_irq(pdev, 0);
-
-	if (!request_mem_region(iomem->start, resource_size(iomem),
-		mmc_hostname(host->mmc))) {
-		dev_err(&pdev->dev, "cannot request region\n");
-		ret = -EBUSY;
-		goto err_request;
-	}
-
-	host->ioaddr = ioremap(iomem->start, resource_size(iomem));
-	if (!host->ioaddr) {
-		dev_err(&pdev->dev, "failed to remap registers\n");
-		ret = -ENOMEM;
-		goto err_remap;
-	}
-
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
-	platform_set_drvdata(pdev, host);
-
-	return 0;
-
-err_add_host:
-	if (pdata && pdata->exit)
-		pdata->exit(host);
-err_plat_init:
-	iounmap(host->ioaddr);
-err_remap:
-	release_mem_region(iomem->start, resource_size(iomem));
-err_request:
-	sdhci_free_host(host);
-err:
-	printk(KERN_ERR"Probing of sdhci-pltfm failed: %d\n", ret);
-	return ret;
-}
-
-static int __devexit sdhci_pltfm_remove(struct platform_device *pdev)
-{
-	const struct platform_device_id *platid = platform_get_device_id(pdev);
-	const struct of_device_id *dtid = sdhci_get_of_device_id(pdev);
-	struct sdhci_pltfm_data *pdata;
-	struct sdhci_host *host = platform_get_drvdata(pdev);
-	struct resource *iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	int dead;
-	u32 scratch;
-
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
-	iounmap(host->ioaddr);
-	release_mem_region(iomem->start, resource_size(iomem));
-	sdhci_free_host(host);
-	platform_set_drvdata(pdev, NULL);
-
-	return 0;
-}
-
-static const struct platform_device_id sdhci_pltfm_ids[] = {
-	{ "sdhci", },
-#ifdef CONFIG_MMC_SDHCI_TEGRA
-	{ "sdhci-tegra", (kernel_ulong_t)&sdhci_tegra_pdata },
-#endif
-	{ },
-};
-MODULE_DEVICE_TABLE(platform, sdhci_pltfm_ids);
-
 #ifdef CONFIG_PM
 int sdhci_pltfm_suspend(struct platform_device *dev, pm_message_t state)
 {
@@ -293,43 +121,4 @@ int sdhci_pltfm_resume(struct platform_device *dev)
 
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
index d7267f0..b53b976 100644
--- a/drivers/mmc/host/sdhci-pltfm.h
+++ b/drivers/mmc/host/sdhci-pltfm.h
@@ -21,9 +21,6 @@ struct sdhci_pltfm_host {
 	u32 scratchpad; /* to handle quirks across io-accessor calls */
 };
 
-extern struct sdhci_pltfm_data sdhci_tegra_pdata;
-extern struct sdhci_pltfm_data sdhci_tegra_dt_pdata;
-
 struct sdhci_host *sdhci_pltfm_init(struct platform_device *pdev,
 				    struct sdhci_pltfm_data *pdata);
 void sdhci_pltfm_free(struct platform_device *pdev);
diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index c3d6f83..c376e74 100644
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
@@ -189,62 +228,55 @@ static int tegra_sdhci_pltfm_init(struct sdhci_host *host,
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
-{
-	struct platform_device *pdev = to_platform_device(mmc_dev(host->mmc));
-	struct tegra_sdhci_platform_data *plat;
-
-	if (pdev->dev.platform_data) {
-		dev_err(&pdev->dev, "%s: platform_data not NULL; aborting\n",
-			__func__);
-		return -ENODEV;
-	}
-
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
+static int __devexit sdhci_tegra_remove(struct platform_device *pdev)
 {
+	struct sdhci_host *host = platform_get_drvdata(pdev);
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
-	struct platform_device *pdev = to_platform_device(mmc_dev(host->mmc));
 	struct tegra_sdhci_platform_data *plat;
+	int dead = 0;
+	u32 scratch;
+
+	scratch = readl(host->ioaddr + SDHCI_INT_STATUS);
+	if (scratch == (u32)-1)
+		dead = 1;
+	sdhci_remove_host(host, dead);
 
 	plat = pdev->dev.platform_data;
 
@@ -263,44 +295,45 @@ static void tegra_sdhci_pltfm_exit(struct sdhci_host *host)
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
-
-static void tegra_sdhci_pltfm_dt_exit(struct sdhci_host *host)
-{
-	struct platform_device *pdev = to_platform_device(mmc_dev(host->mmc));
 
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
+
+module_init(sdhci_tegra_init);
+module_exit(sdhci_tegra_exit);
+
+MODULE_DESCRIPTION("SDHCI driver for Tegra");
+MODULE_AUTHOR(" Google, Inc.");
+MODULE_LICENSE("GPL v2");
-- 
1.7.1

