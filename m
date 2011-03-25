Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933996Ab1CYIq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 04:46:59 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41335 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933468Ab1CYIpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 04:45:53 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: devicetree-discuss@lists.ozlabs.org, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 3/5] mmc: sdhci: make sdhci-of device drivers self registered
Date: Fri, 25 Mar 2011 16:48:49 +0800
Message-Id: <1301042931-4869-4-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
References: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch turns the sdhci-of-core common stuff into helper functions
added into sdhci-pltfm.c, and makes sdhci-of device drviers self
registered using the same pair of .probe and .remove used by
sdhci-pltfm device drivers.

As a result, sdhci-of-core.c and sdhci-of.h can be eliminated with
those common things merged into sdhci-pltfm.c and sdhci-pltfm.h
respectively.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/mmc/host/Kconfig          |   15 +--
 drivers/mmc/host/Makefile         |    7 +-
 drivers/mmc/host/sdhci-of-core.c  |  247 -------------------------------------
 drivers/mmc/host/sdhci-of-esdhc.c |   75 +++++++++++-
 drivers/mmc/host/sdhci-of-hlwd.c  |   73 +++++++++++-
 drivers/mmc/host/sdhci-of.h       |   33 -----
 drivers/mmc/host/sdhci-pltfm.c    |  100 +++++++++++++++-
 drivers/mmc/host/sdhci-pltfm.h    |   14 ++
 8 files changed, 263 insertions(+), 301 deletions(-)
 delete mode 100644 drivers/mmc/host/sdhci-of-core.c
 delete mode 100644 drivers/mmc/host/sdhci-of.h

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 1db9347..9f360b5 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -81,19 +81,11 @@ config MMC_RICOH_MMC
 
 	  If unsure, say Y.
 
-config MMC_SDHCI_OF
-	tristate "SDHCI support on OpenFirmware platforms"
-	depends on MMC_SDHCI && OF
-	help
-	  This selects the OF support for Secure Digital Host Controller
-	  Interfaces.
-
-	  If unsure, say N.
-
 config MMC_SDHCI_OF_ESDHC
 	bool "SDHCI OF support for the Freescale eSDHC controller"
-	depends on MMC_SDHCI_OF
+	depends on MMC_SDHCI
 	depends on PPC_OF
+	select MMC_SDHCI_PLTFM
 	select MMC_SDHCI_BIG_ENDIAN_32BIT_BYTE_SWAPPER
 	help
 	  This selects the Freescale eSDHC controller support.
@@ -102,8 +94,9 @@ config MMC_SDHCI_OF_ESDHC
 
 config MMC_SDHCI_OF_HLWD
 	bool "SDHCI OF support for the Nintendo Wii SDHCI controllers"
-	depends on MMC_SDHCI_OF
+	depends on MMC_SDHCI
 	depends on PPC_OF
+	select MMC_SDHCI_PLTFM
 	select MMC_SDHCI_BIG_ENDIAN_32BIT_BYTE_SWAPPER
 	help
 	  This selects the Secure Digital Host Controller Interface (SDHCI)
diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index 1d8e43d..0ea8815 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -41,11 +41,8 @@ obj-$(CONFIG_MMC_SDHCI_CNS3XXX)		+= sdhci-cns3xxx.o
 obj-$(CONFIG_MMC_SDHCI_ESDHC_IMX)	+= sdhci-esdhc-imx.o
 obj-$(CONFIG_MMC_SDHCI_DOVE)		+= sdhci-dove.o
 obj-$(CONFIG_MMC_SDHCI_TEGRA)		+= sdhci-tegra.o
-
-obj-$(CONFIG_MMC_SDHCI_OF)	+= sdhci-of.o
-sdhci-of-y				:= sdhci-of-core.o
-sdhci-of-$(CONFIG_MMC_SDHCI_OF_ESDHC)	+= sdhci-of-esdhc.o
-sdhci-of-$(CONFIG_MMC_SDHCI_OF_HLWD)	+= sdhci-of-hlwd.o
+obj-$(CONFIG_MMC_SDHCI_OF_ESDHC)	+= sdhci-of-esdhc.o
+obj-$(CONFIG_MMC_SDHCI_OF_HLWD)		+= sdhci-of-hlwd.o
 
 ifeq ($(CONFIG_CB710_DEBUG),y)
 	CFLAGS-cb710-mmc	+= -DDEBUG
diff --git a/drivers/mmc/host/sdhci-of-core.c b/drivers/mmc/host/sdhci-of-core.c
deleted file mode 100644
index a6c0132..0000000
--- a/drivers/mmc/host/sdhci-of-core.c
+++ /dev/null
@@ -1,247 +0,0 @@
-/*
- * OpenFirmware bindings for Secure Digital Host Controller Interface.
- *
- * Copyright (c) 2007 Freescale Semiconductor, Inc.
- * Copyright (c) 2009 MontaVista Software, Inc.
- *
- * Authors: Xiaobo Xie <X.Xie@freescale.com>
- *	    Anton Vorontsov <avorontsov@ru.mvista.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or (at
- * your option) any later version.
- */
-
-#include <linux/err.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/io.h>
-#include <linux/interrupt.h>
-#include <linux/delay.h>
-#include <linux/of.h>
-#include <linux/of_platform.h>
-#include <linux/of_address.h>
-#include <linux/of_irq.h>
-#include <linux/mmc/host.h>
-#ifdef CONFIG_PPC
-#include <asm/machdep.h>
-#endif
-#include "sdhci-of.h"
-#include "sdhci.h"
-
-#ifdef CONFIG_MMC_SDHCI_BIG_ENDIAN_32BIT_BYTE_SWAPPER
-
-/*
- * These accessors are designed for big endian hosts doing I/O to
- * little endian controllers incorporating a 32-bit hardware byte swapper.
- */
-
-u32 sdhci_be32bs_readl(struct sdhci_host *host, int reg)
-{
-	return in_be32(host->ioaddr + reg);
-}
-
-u16 sdhci_be32bs_readw(struct sdhci_host *host, int reg)
-{
-	return in_be16(host->ioaddr + (reg ^ 0x2));
-}
-
-u8 sdhci_be32bs_readb(struct sdhci_host *host, int reg)
-{
-	return in_8(host->ioaddr + (reg ^ 0x3));
-}
-
-void sdhci_be32bs_writel(struct sdhci_host *host, u32 val, int reg)
-{
-	out_be32(host->ioaddr + reg, val);
-}
-
-void sdhci_be32bs_writew(struct sdhci_host *host, u16 val, int reg)
-{
-	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
-	int base = reg & ~0x3;
-	int shift = (reg & 0x2) * 8;
-
-	switch (reg) {
-	case SDHCI_TRANSFER_MODE:
-		/*
-		 * Postpone this write, we must do it together with a
-		 * command write that is down below.
-		 */
-		pltfm_host->xfer_mode_shadow = val;
-		return;
-	case SDHCI_COMMAND:
-		sdhci_be32bs_writel(host, val << 16 | pltfm_host->xfer_mode_shadow,
-				    SDHCI_TRANSFER_MODE);
-		return;
-	}
-	clrsetbits_be32(host->ioaddr + base, 0xffff << shift, val << shift);
-}
-
-void sdhci_be32bs_writeb(struct sdhci_host *host, u8 val, int reg)
-{
-	int base = reg & ~0x3;
-	int shift = (reg & 0x3) * 8;
-
-	clrsetbits_be32(host->ioaddr + base , 0xff << shift, val << shift);
-}
-#endif /* CONFIG_MMC_SDHCI_BIG_ENDIAN_32BIT_BYTE_SWAPPER */
-
-#ifdef CONFIG_PM
-
-static int sdhci_of_suspend(struct platform_device *ofdev, pm_message_t state)
-{
-	struct sdhci_host *host = dev_get_drvdata(&ofdev->dev);
-
-	return mmc_suspend_host(host->mmc);
-}
-
-static int sdhci_of_resume(struct platform_device *ofdev)
-{
-	struct sdhci_host *host = dev_get_drvdata(&ofdev->dev);
-
-	return mmc_resume_host(host->mmc);
-}
-
-#else
-
-#define sdhci_of_suspend NULL
-#define sdhci_of_resume NULL
-
-#endif
-
-static bool __devinit sdhci_of_wp_inverted(struct device_node *np)
-{
-	if (of_get_property(np, "sdhci,wp-inverted", NULL))
-		return true;
-
-	/* Old device trees don't have the wp-inverted property. */
-#ifdef CONFIG_PPC
-	return machine_is(mpc837x_rdb) || machine_is(mpc837x_mds);
-#else
-	return false;
-#endif
-}
-
-static int __devinit sdhci_of_probe(struct platform_device *ofdev,
-				 const struct of_device_id *match)
-{
-	struct device_node *np = ofdev->dev.of_node;
-	struct sdhci_pltfm_data *pdata = match->data;
-	struct sdhci_host *host;
-	struct sdhci_pltfm_host *pltfm_host;
-	const __be32 *clk;
-	int size;
-	int ret;
-
-	if (!of_device_is_available(np))
-		return -ENODEV;
-
-	host = sdhci_alloc_host(&ofdev->dev, sizeof(*pltfm_host));
-	if (IS_ERR(host))
-		return -ENOMEM;
-
-	pltfm_host = sdhci_priv(host);
-	dev_set_drvdata(&ofdev->dev, host);
-
-	host->ioaddr = of_iomap(np, 0);
-	if (!host->ioaddr) {
-		ret = -ENOMEM;
-		goto err_addr_map;
-	}
-
-	host->irq = irq_of_parse_and_map(np, 0);
-	if (!host->irq) {
-		ret = -EINVAL;
-		goto err_no_irq;
-	}
-
-	host->hw_name = dev_name(&ofdev->dev);
-	if (pdata) {
-		host->quirks = pdata->quirks;
-		host->ops = &pdata->ops;
-	}
-
-	if (of_get_property(np, "sdhci,auto-cmd12", NULL))
-		host->quirks |= SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12;
-
-
-	if (of_get_property(np, "sdhci,1-bit-only", NULL))
-		host->quirks |= SDHCI_QUIRK_FORCE_1_BIT_DATA;
-
-	if (sdhci_of_wp_inverted(np))
-		host->quirks |= SDHCI_QUIRK_INVERTED_WRITE_PROTECT;
-
-	clk = of_get_property(np, "clock-frequency", &size);
-	if (clk && size == sizeof(*clk) && *clk)
-		pltfm_host->clock = be32_to_cpup(clk);
-
-	ret = sdhci_add_host(host);
-	if (ret)
-		goto err_add_host;
-
-	return 0;
-
-err_add_host:
-	irq_dispose_mapping(host->irq);
-err_no_irq:
-	iounmap(host->ioaddr);
-err_addr_map:
-	sdhci_free_host(host);
-	return ret;
-}
-
-static int __devexit sdhci_of_remove(struct platform_device *ofdev)
-{
-	struct sdhci_host *host = dev_get_drvdata(&ofdev->dev);
-
-	sdhci_remove_host(host, 0);
-	sdhci_free_host(host);
-	irq_dispose_mapping(host->irq);
-	iounmap(host->ioaddr);
-	return 0;
-}
-
-static const struct of_device_id sdhci_of_match[] = {
-#ifdef CONFIG_MMC_SDHCI_OF_ESDHC
-	{ .compatible = "fsl,mpc8379-esdhc", .data = &sdhci_esdhc_pdata, },
-	{ .compatible = "fsl,mpc8536-esdhc", .data = &sdhci_esdhc_pdata, },
-	{ .compatible = "fsl,esdhc", .data = &sdhci_esdhc_pdata, },
-#endif
-#ifdef CONFIG_MMC_SDHCI_OF_HLWD
-	{ .compatible = "nintendo,hollywood-sdhci", .data = &sdhci_hlwd_pdata, },
-#endif
-	{ .compatible = "generic-sdhci", },
-	{},
-};
-MODULE_DEVICE_TABLE(of, sdhci_of_match);
-
-static struct of_platform_driver sdhci_of_driver = {
-	.driver = {
-		.name = "sdhci-of",
-		.owner = THIS_MODULE,
-		.of_match_table = sdhci_of_match,
-	},
-	.probe = sdhci_of_probe,
-	.remove = __devexit_p(sdhci_of_remove),
-	.suspend = sdhci_of_suspend,
-	.resume	= sdhci_of_resume,
-};
-
-static int __init sdhci_of_init(void)
-{
-	return of_register_platform_driver(&sdhci_of_driver);
-}
-module_init(sdhci_of_init);
-
-static void __exit sdhci_of_exit(void)
-{
-	of_unregister_platform_driver(&sdhci_of_driver);
-}
-module_exit(sdhci_of_exit);
-
-MODULE_DESCRIPTION("Secure Digital Host Controller Interface OF driver");
-MODULE_AUTHOR("Xiaobo Xie <X.Xie@freescale.com>, "
-	      "Anton Vorontsov <avorontsov@ru.mvista.com>");
-MODULE_LICENSE("GPL");
diff --git a/drivers/mmc/host/sdhci-of-esdhc.c b/drivers/mmc/host/sdhci-of-esdhc.c
index 702a98b..ccd182f 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -16,7 +16,7 @@
 #include <linux/io.h>
 #include <linux/delay.h>
 #include <linux/mmc/host.h>
-#include "sdhci-of.h"
+#include "sdhci-pltfm.h"
 #include "sdhci.h"
 #include "sdhci-esdhc.h"
 
@@ -85,7 +85,78 @@ static struct sdhci_ops sdhci_esdhc_ops = {
 	.get_min_clock = esdhc_of_get_min_clock,
 };
 
-struct sdhci_pltfm_data sdhci_esdhc_pdata = {
+static struct sdhci_pltfm_data sdhci_esdhc_pdata = {
 	.quirks = ESDHC_DEFAULT_QUIRKS,
 	.ops = &sdhci_esdhc_ops,
 };
+
+static int __devinit sdhci_esdhc_probe(struct platform_device *pdev)
+{
+	struct sdhci_host *host;
+	int ret;
+
+	host = sdhci_pltfm_init(pdev, &sdhci_esdhc_pdata);
+	if (!host)
+		return -ENOMEM;
+
+	sdhci_get_of_property(pdev);
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
+static int __devexit sdhci_esdhc_remove(struct platform_device *pdev)
+{
+	struct sdhci_host *host = platform_get_drvdata(pdev);
+
+	sdhci_remove_host(host, 0);
+	sdhci_pltfm_free(pdev);
+
+	return 0;
+}
+
+static const struct of_device_id sdhci_esdhc_of_match[] = {
+	{ .compatible = "fsl,mpc8379-esdhc" },
+	{ .compatible = "fsl,mpc8536-esdhc" },
+	{ .compatible = "fsl,esdhc" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, sdhci_esdhc_of_match);
+
+static struct platform_driver sdhci_esdhc_driver = {
+	.driver = {
+		.name = "sdhci-esdhc",
+		.owner = THIS_MODULE,
+		.of_match_table = sdhci_esdhc_of_match,
+	},
+	.probe = sdhci_esdhc_probe,
+	.remove = __devexit_p(sdhci_esdhc_remove),
+#ifdef CONFIG_PM
+	.suspend = sdhci_pltfm_suspend,
+	.resume = sdhci_pltfm_resume,
+#endif
+};
+
+static int __init sdhci_esdhc_init(void)
+{
+	return platform_driver_register(&sdhci_esdhc_driver);
+}
+module_init(sdhci_esdhc_init);
+
+static void __exit sdhci_esdhc_exit(void)
+{
+	platform_driver_unregister(&sdhci_esdhc_driver);
+}
+module_exit(sdhci_esdhc_exit);
+
+MODULE_DESCRIPTION("Secure Digital Host Controller Interface OF driver");
+MODULE_AUTHOR("Xiaobo Xie <X.Xie@freescale.com>, "
+	      "Anton Vorontsov <avorontsov@ru.mvista.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/mmc/host/sdhci-of-hlwd.c b/drivers/mmc/host/sdhci-of-hlwd.c
index 380e896..52944d1 100644
--- a/drivers/mmc/host/sdhci-of-hlwd.c
+++ b/drivers/mmc/host/sdhci-of-hlwd.c
@@ -21,7 +21,7 @@
 
 #include <linux/delay.h>
 #include <linux/mmc/host.h>
-#include "sdhci-of.h"
+#include "sdhci-pltfm.h"
 #include "sdhci.h"
 
 /*
@@ -60,8 +60,77 @@ static struct sdhci_ops sdhci_hlwd_ops = {
 	.write_b = sdhci_hlwd_writeb,
 };
 
-struct sdhci_pltfm_data sdhci_hlwd_pdata = {
+static struct sdhci_pltfm_data sdhci_hlwd_pdata = {
 	.quirks = SDHCI_QUIRK_32BIT_DMA_ADDR |
 		  SDHCI_QUIRK_32BIT_DMA_SIZE,
 	.ops = &sdhci_hlwd_ops,
 };
+
+static int __devinit sdhci_hlwd_probe(struct platform_device *pdev)
+{
+	struct sdhci_host *host;
+	int ret;
+
+	host = sdhci_pltfm_init(pdev, &sdhci_hlwd_pdata);
+	if (!host)
+		return -ENOMEM;
+
+	sdhci_get_of_property(pdev);
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
+static int __devexit sdhci_hlwd_remove(struct platform_device *pdev)
+{
+	struct sdhci_host *host = platform_get_drvdata(pdev);
+
+	sdhci_remove_host(host, 0);
+	sdhci_pltfm_free(pdev);
+
+	return 0;
+}
+
+static const struct of_device_id sdhci_hlwd_of_match[] = {
+	{ .compatible = "nintendo,hollywood-sdhci" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, sdhci_hlwd_of_match);
+
+static struct platform_driver sdhci_hlwd_driver = {
+	.driver = {
+		.name = "sdhci-hlwd",
+		.owner = THIS_MODULE,
+		.of_match_table = sdhci_hlwd_of_match,
+	},
+	.probe = sdhci_hlwd_probe,
+	.remove = __devexit_p(sdhci_hlwd_remove),
+#ifdef CONFIG_PM
+	.suspend = sdhci_pltfm_suspend,
+	.resume = sdhci_pltfm_resume,
+#endif
+};
+
+static int __init sdhci_hlwd_init(void)
+{
+	return platform_driver_register(&sdhci_hlwd_driver);
+}
+module_init(sdhci_hlwd_init);
+
+static void __exit sdhci_hlwd_exit(void)
+{
+	platform_driver_unregister(&sdhci_hlwd_driver);
+}
+module_exit(sdhci_hlwd_exit);
+
+MODULE_DESCRIPTION("Secure Digital Host Controller Interface OF driver");
+MODULE_AUTHOR("Xiaobo Xie <X.Xie@freescale.com>, "
+	      "Anton Vorontsov <avorontsov@ru.mvista.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/mmc/host/sdhci-of.h b/drivers/mmc/host/sdhci-of.h
deleted file mode 100644
index 5bdb5e7..0000000
--- a/drivers/mmc/host/sdhci-of.h
+++ /dev/null
@@ -1,33 +0,0 @@
-/*
- * OpenFirmware bindings for Secure Digital Host Controller Interface.
- *
- * Copyright (c) 2007 Freescale Semiconductor, Inc.
- * Copyright (c) 2009 MontaVista Software, Inc.
- *
- * Authors: Xiaobo Xie <X.Xie@freescale.com>
- *	    Anton Vorontsov <avorontsov@ru.mvista.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or (at
- * your option) any later version.
- */
-
-#ifndef __SDHCI_OF_H
-#define __SDHCI_OF_H
-
-#include <linux/types.h>
-#include "sdhci.h"
-#include "sdhci-pltfm.h"
-
-extern u32 sdhci_be32bs_readl(struct sdhci_host *host, int reg);
-extern u16 sdhci_be32bs_readw(struct sdhci_host *host, int reg);
-extern u8 sdhci_be32bs_readb(struct sdhci_host *host, int reg);
-extern void sdhci_be32bs_writel(struct sdhci_host *host, u32 val, int reg);
-extern void sdhci_be32bs_writew(struct sdhci_host *host, u16 val, int reg);
-extern void sdhci_be32bs_writeb(struct sdhci_host *host, u8 val, int reg);
-
-extern struct sdhci_pltfm_data sdhci_esdhc_pdata;
-extern struct sdhci_pltfm_data sdhci_hlwd_pdata;
-
-#endif /* __SDHCI_OF_H */
diff --git a/drivers/mmc/host/sdhci-pltfm.c b/drivers/mmc/host/sdhci-pltfm.c
index 63e45aa..4e998f1 100644
--- a/drivers/mmc/host/sdhci-pltfm.c
+++ b/drivers/mmc/host/sdhci-pltfm.c
@@ -23,13 +23,111 @@
  */
 
 #include <linux/err.h>
-
+#include <linux/of.h>
+#ifdef CONFIG_PPC
+#include <asm/machdep.h>
+#endif
 #include "sdhci.h"
 #include "sdhci-pltfm.h"
 
 static struct sdhci_ops sdhci_pltfm_ops = {
 };
 
+#ifdef CONFIG_MMC_SDHCI_BIG_ENDIAN_32BIT_BYTE_SWAPPER
+/*
+ * These accessors are designed for big endian hosts doing I/O to
+ * little endian controllers incorporating a 32-bit hardware byte swapper.
+ */
+u32 sdhci_be32bs_readl(struct sdhci_host *host, int reg)
+{
+	return in_be32(host->ioaddr + reg);
+}
+
+u16 sdhci_be32bs_readw(struct sdhci_host *host, int reg)
+{
+	return in_be16(host->ioaddr + (reg ^ 0x2));
+}
+
+u8 sdhci_be32bs_readb(struct sdhci_host *host, int reg)
+{
+	return in_8(host->ioaddr + (reg ^ 0x3));
+}
+
+void sdhci_be32bs_writel(struct sdhci_host *host, u32 val, int reg)
+{
+	out_be32(host->ioaddr + reg, val);
+}
+
+void sdhci_be32bs_writew(struct sdhci_host *host, u16 val, int reg)
+{
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	int base = reg & ~0x3;
+	int shift = (reg & 0x2) * 8;
+
+	switch (reg) {
+	case SDHCI_TRANSFER_MODE:
+		/*
+		 * Postpone this write, we must do it together with a
+		 * command write that is down below.
+		 */
+		pltfm_host->xfer_mode_shadow = val;
+		return;
+	case SDHCI_COMMAND:
+		sdhci_be32bs_writel(host, val << 16 | pltfm_host->xfer_mode_shadow,
+				    SDHCI_TRANSFER_MODE);
+		return;
+	}
+	clrsetbits_be32(host->ioaddr + base, 0xffff << shift, val << shift);
+}
+
+void sdhci_be32bs_writeb(struct sdhci_host *host, u8 val, int reg)
+{
+	int base = reg & ~0x3;
+	int shift = (reg & 0x3) * 8;
+
+	clrsetbits_be32(host->ioaddr + base , 0xff << shift, val << shift);
+}
+#endif /* CONFIG_MMC_SDHCI_BIG_ENDIAN_32BIT_BYTE_SWAPPER */
+
+#ifdef CONFIG_OF
+static bool sdhci_of_wp_inverted(struct device_node *np)
+{
+	if (of_get_property(np, "sdhci,wp-inverted", NULL))
+		return true;
+
+	/* Old device trees don't have the wp-inverted property. */
+#ifdef CONFIG_PPC
+	return machine_is(mpc837x_rdb) || machine_is(mpc837x_mds);
+#else
+	return false;
+#endif
+}
+
+void sdhci_get_of_property(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct sdhci_host *host = platform_get_drvdata(pdev);
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	const __be32 *clk;
+	int size;
+
+	if (of_device_is_available(np)) {
+		if (of_get_property(np, "sdhci,auto-cmd12", NULL))
+			host->quirks |= SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12;
+
+		if (of_get_property(np, "sdhci,1-bit-only", NULL))
+			host->quirks |= SDHCI_QUIRK_FORCE_1_BIT_DATA;
+
+		if (sdhci_of_wp_inverted(np))
+			host->quirks |= SDHCI_QUIRK_INVERTED_WRITE_PROTECT;
+
+		clk = of_get_property(np, "clock-frequency", &size);
+		if (clk && size == sizeof(*clk) && *clk)
+			pltfm_host->clock = be32_to_cpup(clk);
+	}
+}
+#endif
+
 struct sdhci_host *sdhci_pltfm_init(struct platform_device *pdev,
 				    struct sdhci_pltfm_data *pdata)
 {
diff --git a/drivers/mmc/host/sdhci-pltfm.h b/drivers/mmc/host/sdhci-pltfm.h
index 12afe86..2f38056 100644
--- a/drivers/mmc/host/sdhci-pltfm.h
+++ b/drivers/mmc/host/sdhci-pltfm.h
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 #include <linux/platform_device.h>
 #include <linux/mmc/sdhci-pltfm.h>
+#include <linux/mmc/sdhci.h>
 
 struct sdhci_pltfm_host {
 	struct clk *clk;
@@ -25,6 +26,19 @@ struct sdhci_pltfm_host {
 	u16 xfer_mode_shadow;
 };
 
+#ifdef CONFIG_MMC_SDHCI_BIG_ENDIAN_32BIT_BYTE_SWAPPER
+extern u32 sdhci_be32bs_readl(struct sdhci_host *host, int reg);
+extern u16 sdhci_be32bs_readw(struct sdhci_host *host, int reg);
+extern u8 sdhci_be32bs_readb(struct sdhci_host *host, int reg);
+extern void sdhci_be32bs_writel(struct sdhci_host *host, u32 val, int reg);
+extern void sdhci_be32bs_writew(struct sdhci_host *host, u16 val, int reg);
+extern void sdhci_be32bs_writeb(struct sdhci_host *host, u8 val, int reg);
+#endif
+
+#ifdef CONFIG_OF
+extern void sdhci_get_of_property(struct platform_device *pdev);
+#endif
+
 extern struct sdhci_host *sdhci_pltfm_init(struct platform_device *pdev,
 					   struct sdhci_pltfm_data *pdata);
 extern void sdhci_pltfm_free(struct platform_device *pdev);
-- 
1.7.1

