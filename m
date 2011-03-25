Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933948Ab1CYIqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 04:46:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44441 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933773Ab1CYIqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 04:46:01 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: devicetree-discuss@lists.ozlabs.org, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 4/5] mmc: sdhci: consolidate sdhci-of-esdhc and sdhci-esdhc-imx
Date: Fri, 25 Mar 2011 16:48:50 +0800
Message-Id: <1301042931-4869-5-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
References: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to consolidate SDHCI driver for Freescale eSDHC
controller found on both MPCxxx and i.MX platforms.  It turns
sdhci-of-esdhc.c and sdhci-esdhc-imx.c into one sdhci-esdhc.c,
which gets the same pair of .probe and .remove serving two cases.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/mmc/host/Kconfig           |   38 ++--
 drivers/mmc/host/Makefile          |    3 +-
 drivers/mmc/host/sdhci-esdhc-imx.c |  210 ------------------
 drivers/mmc/host/sdhci-esdhc.c     |  413 ++++++++++++++++++++++++++++++++++++
 drivers/mmc/host/sdhci-of-esdhc.c  |  162 --------------
 drivers/mmc/host/sdhci-pltfm.c     |    2 +
 drivers/mmc/host/sdhci-pltfm.h     |    2 -
 7 files changed, 439 insertions(+), 391 deletions(-)
 delete mode 100644 drivers/mmc/host/sdhci-esdhc-imx.c
 create mode 100644 drivers/mmc/host/sdhci-esdhc.c
 delete mode 100644 drivers/mmc/host/sdhci-of-esdhc.c

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 9f360b5..e39c145 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -81,17 +81,6 @@ config MMC_RICOH_MMC
 
 	  If unsure, say Y.
 
-config MMC_SDHCI_OF_ESDHC
-	bool "SDHCI OF support for the Freescale eSDHC controller"
-	depends on MMC_SDHCI
-	depends on PPC_OF
-	select MMC_SDHCI_PLTFM
-	select MMC_SDHCI_BIG_ENDIAN_32BIT_BYTE_SWAPPER
-	help
-	  This selects the Freescale eSDHC controller support.
-
-	  If unsure, say N.
-
 config MMC_SDHCI_OF_HLWD
 	bool "SDHCI OF support for the Nintendo Wii SDHCI controllers"
 	depends on MMC_SDHCI
@@ -122,15 +111,34 @@ config MMC_SDHCI_CNS3XXX
 
 	  If unsure, say N.
 
+config MMC_SDHCI_ESDHC
+	bool
+	depends on MMC_SDHCI
+	select MMC_SDHCI_PLTFM
+	help
+	  This selects SDHCI driver for Freescale eSDHC controller.
+
+config MMC_SDHCI_ESDHC_MPC
+	bool "SDHCI support for the Freescale eSDHC MPC controller"
+	depends on MMC_SDHCI
+	depends on PPC_OF
+	select MMC_SDHCI_ESDHC
+	select MMC_SDHCI_BIG_ENDIAN_32BIT_BYTE_SWAPPER
+	help
+	  This selects the Freescale eSDHC controller support on platforms
+	  like mpc8379/mpc8536.
+
+	  If unsure, say N.
+
 config MMC_SDHCI_ESDHC_IMX
-	bool "SDHCI platform support for the Freescale eSDHC i.MX controller"
+	bool "SDHCI support for the Freescale eSDHC i.MX controller"
 	depends on ARCH_MX25 || ARCH_MX35 || ARCH_MX5
 	depends on MMC_SDHCI
-	select MMC_SDHCI_PLTFM
+	select MMC_SDHCI_ESDHC
 	select MMC_SDHCI_IO_ACCESSORS
 	help
-	  This selects the Freescale eSDHC controller support on the platform
-	  bus, found on platforms like mx35/51.
+	  This selects the Freescale eSDHC controller support on platforms
+	  like mx35/51.
 
 	  If unsure, say N.
 
diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index 0ea8815..e6e3aaa 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -38,10 +38,9 @@ obj-$(CONFIG_MMC_USHC)		+= ushc.o
 
 obj-$(CONFIG_MMC_SDHCI_PLTFM)		+= sdhci-pltfm.o
 obj-$(CONFIG_MMC_SDHCI_CNS3XXX)		+= sdhci-cns3xxx.o
-obj-$(CONFIG_MMC_SDHCI_ESDHC_IMX)	+= sdhci-esdhc-imx.o
+obj-$(CONFIG_MMC_SDHCI_ESDHC)		+= sdhci-esdhc.o
 obj-$(CONFIG_MMC_SDHCI_DOVE)		+= sdhci-dove.o
 obj-$(CONFIG_MMC_SDHCI_TEGRA)		+= sdhci-tegra.o
-obj-$(CONFIG_MMC_SDHCI_OF_ESDHC)	+= sdhci-of-esdhc.o
 obj-$(CONFIG_MMC_SDHCI_OF_HLWD)		+= sdhci-of-hlwd.o
 
 ifeq ($(CONFIG_CB710_DEBUG),y)
diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
deleted file mode 100644
index c9eb507..0000000
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ /dev/null
@@ -1,210 +0,0 @@
-/*
- * Freescale eSDHC i.MX controller driver for the platform bus.
- *
- * derived from the OF-version.
- *
- * Copyright (c) 2010 Pengutronix e.K.
- *   Author: Wolfram Sang <w.sang@pengutronix.de>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License.
- */
-
-#include <linux/io.h>
-#include <linux/delay.h>
-#include <linux/err.h>
-#include <linux/clk.h>
-#include <linux/mmc/host.h>
-#include <linux/mmc/sdhci-pltfm.h>
-#include <mach/hardware.h>
-#include "sdhci.h"
-#include "sdhci-pltfm.h"
-#include "sdhci-esdhc.h"
-
-static inline void esdhc_clrset_le(struct sdhci_host *host, u32 mask, u32 val, int reg)
-{
-	void __iomem *base = host->ioaddr + (reg & ~0x3);
-	u32 shift = (reg & 0x3) * 8;
-
-	writel(((readl(base) & ~(mask << shift)) | (val << shift)), base);
-}
-
-static u16 esdhc_readw_le(struct sdhci_host *host, int reg)
-{
-	if (unlikely(reg == SDHCI_HOST_VERSION))
-		reg ^= 2;
-
-	return readw(host->ioaddr + reg);
-}
-
-static void esdhc_writew_le(struct sdhci_host *host, u16 val, int reg)
-{
-	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
-
-	switch (reg) {
-	case SDHCI_TRANSFER_MODE:
-		/*
-		 * Postpone this write, we must do it together with a
-		 * command write that is down below.
-		 */
-		pltfm_host->scratchpad = val;
-		return;
-	case SDHCI_COMMAND:
-		writel(val << 16 | pltfm_host->scratchpad,
-			host->ioaddr + SDHCI_TRANSFER_MODE);
-		return;
-	case SDHCI_BLOCK_SIZE:
-		val &= ~SDHCI_MAKE_BLKSZ(0x7, 0);
-		break;
-	}
-	esdhc_clrset_le(host, 0xffff, val, reg);
-}
-
-static void esdhc_writeb_le(struct sdhci_host *host, u8 val, int reg)
-{
-	u32 new_val;
-
-	switch (reg) {
-	case SDHCI_POWER_CONTROL:
-		/*
-		 * FSL put some DMA bits here
-		 * If your board has a regulator, code should be here
-		 */
-		return;
-	case SDHCI_HOST_CONTROL:
-		/* FSL messed up here, so we can just keep those two */
-		new_val = val & (SDHCI_CTRL_LED | SDHCI_CTRL_4BITBUS);
-		/* ensure the endianess */
-		new_val |= ESDHC_HOST_CONTROL_LE;
-		/* DMA mode bits are shifted */
-		new_val |= (val & SDHCI_CTRL_DMA_MASK) << 5;
-
-		esdhc_clrset_le(host, 0xffff, new_val, reg);
-		return;
-	}
-	esdhc_clrset_le(host, 0xff, val, reg);
-}
-
-static unsigned int esdhc_pltfm_get_max_clock(struct sdhci_host *host)
-{
-	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
-
-	return clk_get_rate(pltfm_host->clk);
-}
-
-static unsigned int esdhc_pltfm_get_min_clock(struct sdhci_host *host)
-{
-	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
-
-	return clk_get_rate(pltfm_host->clk) / 256 / 16;
-}
-
-static struct sdhci_ops sdhci_esdhc_ops = {
-	.read_w = esdhc_readw_le,
-	.write_w = esdhc_writew_le,
-	.write_b = esdhc_writeb_le,
-	.set_clock = esdhc_set_clock,
-	.get_max_clock = esdhc_pltfm_get_max_clock,
-	.get_min_clock = esdhc_pltfm_get_min_clock,
-};
-
-static struct sdhci_pltfm_data sdhci_esdhc_imx_pdata = {
-	.quirks = ESDHC_DEFAULT_QUIRKS | SDHCI_QUIRK_BROKEN_ADMA,
-	/* ADMA has issues. Might be fixable */
-	.ops = &sdhci_esdhc_ops,
-};
-
-static int __devinit sdhci_esdhc_imx_probe(struct platform_device *pdev)
-{
-	struct sdhci_pltfm_host *pltfm_host;
-	struct sdhci_host *host;
-	struct clk *clk;
-	int ret;
-
-	host = sdhci_pltfm_init(pdev, &sdhci_esdhc_imx_pdata);
-	if (!host)
-		return -ENOMEM;
-
-	pltfm_host = sdhci_priv(host);
-
-	clk = clk_get(mmc_dev(host->mmc), NULL);
-	if (IS_ERR(clk)) {
-		dev_err(mmc_dev(host->mmc), "clk err\n");
-		ret = PTR_ERR(clk);
-		goto err_clk_get;
-	}
-	clk_enable(clk);
-	pltfm_host->clk = clk;
-
-	if (cpu_is_mx35() || cpu_is_mx51())
-		host->quirks |= SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;
-
-	/* Fix errata ENGcm07207 which is present on i.MX25 and i.MX35 */
-	if (cpu_is_mx25() || cpu_is_mx35())
-		host->quirks |= SDHCI_QUIRK_NO_MULTIBLOCK;
-
-	ret = sdhci_add_host(host);
-	if (ret)
-		goto err_add_host;
-
-	return 0;
-
-err_add_host:
-	clk_disable(pltfm_host->clk);
-	clk_put(pltfm_host->clk);
-err_clk_get:
-	sdhci_pltfm_free(pdev);
-	return ret;
-}
-
-static int __devexit sdhci_esdhc_imx_remove(struct platform_device *pdev)
-{
-	struct sdhci_host *host = platform_get_drvdata(pdev);
-	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
-	int dead = 0;
-	u32 scratch;
-
-	scratch = readl(host->ioaddr + SDHCI_INT_STATUS);
-	if (scratch == (u32)-1)
-		dead = 1;
-
-	sdhci_remove_host(host, dead);
-
-	clk_disable(pltfm_host->clk);
-	clk_put(pltfm_host->clk);
-
-	sdhci_pltfm_free(pdev);
-
-	return 0;
-}
-
-static struct platform_driver sdhci_esdhc_imx_driver = {
-	.driver		= {
-		.name	= "sdhci-esdhc-imx",
-		.owner	= THIS_MODULE,
-	},
-	.probe		= sdhci_esdhc_imx_probe,
-	.remove		= __devexit_p(sdhci_esdhc_imx_remove),
-#ifdef CONFIG_PM
-	.suspend	= sdhci_pltfm_suspend,
-	.resume		= sdhci_pltfm_resume,
-#endif
-};
-
-static int __init sdhci_esdhc_imx_init(void)
-{
-	return platform_driver_register(&sdhci_esdhc_imx_driver);
-}
-
-static void __exit sdhci_esdhc_imx_exit(void)
-{
-	platform_driver_unregister(&sdhci_esdhc_imx_driver);
-}
-
-module_init(sdhci_esdhc_imx_init);
-module_exit(sdhci_esdhc_imx_exit);
-
-MODULE_DESCRIPTION("SDHCI driver for i.MX eSDHC");
-MODULE_AUTHOR("Wolfram Sang <w.sang@pengutronix.de>");
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/mmc/host/sdhci-esdhc.c b/drivers/mmc/host/sdhci-esdhc.c
new file mode 100644
index 0000000..b3d1bc1
--- /dev/null
+++ b/drivers/mmc/host/sdhci-esdhc.c
@@ -0,0 +1,413 @@
+/*
+ * Freescale eSDHC controller driver for MPCxxx and i.MX.
+ *
+ * Copyright (c) 2007 Freescale Semiconductor, Inc.
+ *   Author: Xiaobo Xie <X.Xie@freescale.com>
+ *
+ * Copyright (c) 2009 MontaVista Software, Inc.
+ *   Author: Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * Copyright (c) 2010 Pengutronix e.K.
+ *   Author: Wolfram Sang <w.sang@pengutronix.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License.
+ */
+
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <linux/mmc/host.h>
+#include <linux/mmc/sdhci-pltfm.h>
+#ifdef CONFIG_MMC_SDHCI_ESDHC_IMX
+#include <mach/hardware.h>
+#endif
+#include "sdhci.h"
+#include "sdhci-pltfm.h"
+
+/*
+ * Ops and quirks for the Freescale eSDHC controller.
+ */
+
+#define ESDHC_DEFAULT_QUIRKS	(SDHCI_QUIRK_FORCE_BLK_SZ_2048 | \
+				SDHCI_QUIRK_BROKEN_CARD_DETECTION | \
+				SDHCI_QUIRK_NO_BUSY_IRQ | \
+				SDHCI_QUIRK_NONSTANDARD_CLOCK | \
+				SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK | \
+				SDHCI_QUIRK_PIO_NEEDS_DELAY | \
+				SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET | \
+				SDHCI_QUIRK_NO_CARD_NO_RESET)
+
+#define ESDHC_SYSTEM_CONTROL	0x2c
+#define ESDHC_CLOCK_MASK	0x0000fff0
+#define ESDHC_PREDIV_SHIFT	8
+#define ESDHC_DIVIDER_SHIFT	4
+#define ESDHC_CLOCK_PEREN	0x00000004
+#define ESDHC_CLOCK_HCKEN	0x00000002
+#define ESDHC_CLOCK_IPGEN	0x00000001
+
+/* pltfm-specific */
+#define ESDHC_HOST_CONTROL_LE	0x20
+
+/* OF-specific */
+#define ESDHC_DMA_SYSCTL	0x40c
+#define ESDHC_DMA_SNOOP		0x00000040
+
+#define ESDHC_HOST_CONTROL_RES	0x05
+
+static inline void esdhc_set_clock(struct sdhci_host *host, unsigned int clock)
+{
+	int pre_div = 2;
+	int div = 1;
+	u32 temp;
+
+	temp = sdhci_readl(host, ESDHC_SYSTEM_CONTROL);
+	temp &= ~(ESDHC_CLOCK_IPGEN | ESDHC_CLOCK_HCKEN | ESDHC_CLOCK_PEREN
+		| ESDHC_CLOCK_MASK);
+	sdhci_writel(host, temp, ESDHC_SYSTEM_CONTROL);
+
+	if (clock == 0)
+		goto out;
+
+	while (host->max_clk / pre_div / 16 > clock && pre_div < 256)
+		pre_div *= 2;
+
+	while (host->max_clk / pre_div / div > clock && div < 16)
+		div++;
+
+	dev_dbg(mmc_dev(host->mmc), "desired SD clock: %d, actual: %d\n",
+		clock, host->max_clk / pre_div / div);
+
+	pre_div >>= 1;
+	div--;
+
+	temp = sdhci_readl(host, ESDHC_SYSTEM_CONTROL);
+	temp |= (ESDHC_CLOCK_IPGEN | ESDHC_CLOCK_HCKEN | ESDHC_CLOCK_PEREN
+		| (div << ESDHC_DIVIDER_SHIFT)
+		| (pre_div << ESDHC_PREDIV_SHIFT));
+	sdhci_writel(host, temp, ESDHC_SYSTEM_CONTROL);
+	mdelay(100);
+out:
+	host->clock = clock;
+}
+
+#ifdef CONFIG_MMC_SDHCI_ESDHC_MPC
+static u16 esdhc_readw(struct sdhci_host *host, int reg)
+{
+	u16 ret;
+
+	if (unlikely(reg == SDHCI_HOST_VERSION))
+		ret = in_be16(host->ioaddr + reg);
+	else
+		ret = sdhci_be32bs_readw(host, reg);
+	return ret;
+}
+
+static void esdhc_writew(struct sdhci_host *host, u16 val, int reg)
+{
+	if (reg == SDHCI_BLOCK_SIZE) {
+		/*
+		 * Two last DMA bits are reserved, and first one is used for
+		 * non-standard blksz of 4096 bytes that we don't support
+		 * yet. So clear the DMA boundary bits.
+		 */
+		val &= ~SDHCI_MAKE_BLKSZ(0x7, 0);
+	}
+	sdhci_be32bs_writew(host, val, reg);
+}
+
+static void esdhc_writeb(struct sdhci_host *host, u8 val, int reg)
+{
+	/* Prevent SDHCI core from writing reserved bits (e.g. HISPD). */
+	if (reg == SDHCI_HOST_CONTROL)
+		val &= ~ESDHC_HOST_CONTROL_RES;
+	sdhci_be32bs_writeb(host, val, reg);
+}
+
+static int esdhc_mpc_enable_dma(struct sdhci_host *host)
+{
+	setbits32(host->ioaddr + ESDHC_DMA_SYSCTL, ESDHC_DMA_SNOOP);
+	return 0;
+}
+
+static unsigned int esdhc_mpc_get_max_clock(struct sdhci_host *host)
+{
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+
+	return pltfm_host->clock;
+}
+
+static unsigned int esdhc_mpc_get_min_clock(struct sdhci_host *host)
+{
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+
+	return pltfm_host->clock / 256 / 16;
+}
+
+static struct sdhci_ops sdhci_esdhc_mpc_ops = {
+	.read_l = sdhci_be32bs_readl,
+	.read_w = esdhc_readw,
+	.read_b = sdhci_be32bs_readb,
+	.write_l = sdhci_be32bs_writel,
+	.write_w = esdhc_writew,
+	.write_b = esdhc_writeb,
+	.set_clock = esdhc_set_clock,
+	.enable_dma = esdhc_mpc_enable_dma,
+	.get_max_clock = esdhc_mpc_get_max_clock,
+	.get_min_clock = esdhc_mpc_get_min_clock,
+};
+
+static struct sdhci_pltfm_data sdhci_esdhc_mpc_pdata = {
+	.quirks = ESDHC_DEFAULT_QUIRKS,
+	.ops = &sdhci_esdhc_mpc_ops,
+};
+#endif
+
+#ifdef CONFIG_MMC_SDHCI_ESDHC_IMX
+static inline void esdhc_clrset_le(struct sdhci_host *host, u32 mask, u32 val, int reg)
+{
+	void __iomem *base = host->ioaddr + (reg & ~0x3);
+	u32 shift = (reg & 0x3) * 8;
+
+	writel(((readl(base) & ~(mask << shift)) | (val << shift)), base);
+}
+
+static u16 esdhc_readw_le(struct sdhci_host *host, int reg)
+{
+	if (unlikely(reg == SDHCI_HOST_VERSION))
+		reg ^= 2;
+
+	return readw(host->ioaddr + reg);
+}
+
+static void esdhc_writew_le(struct sdhci_host *host, u16 val, int reg)
+{
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+
+	switch (reg) {
+	case SDHCI_TRANSFER_MODE:
+		/*
+		 * Postpone this write, we must do it together with a
+		 * command write that is down below.
+		 */
+		pltfm_host->scratchpad = val;
+		return;
+	case SDHCI_COMMAND:
+		writel(val << 16 | pltfm_host->scratchpad,
+			host->ioaddr + SDHCI_TRANSFER_MODE);
+		return;
+	case SDHCI_BLOCK_SIZE:
+		val &= ~SDHCI_MAKE_BLKSZ(0x7, 0);
+		break;
+	}
+	esdhc_clrset_le(host, 0xffff, val, reg);
+}
+
+static void esdhc_writeb_le(struct sdhci_host *host, u8 val, int reg)
+{
+	u32 new_val;
+
+	switch (reg) {
+	case SDHCI_POWER_CONTROL:
+		/*
+		 * FSL put some DMA bits here
+		 * If your board has a regulator, code should be here
+		 */
+		return;
+	case SDHCI_HOST_CONTROL:
+		/* FSL messed up here, so we can just keep those two */
+		new_val = val & (SDHCI_CTRL_LED | SDHCI_CTRL_4BITBUS);
+		/* ensure the endianess */
+		new_val |= ESDHC_HOST_CONTROL_LE;
+		/* DMA mode bits are shifted */
+		new_val |= (val & SDHCI_CTRL_DMA_MASK) << 5;
+
+		esdhc_clrset_le(host, 0xffff, new_val, reg);
+		return;
+	}
+	esdhc_clrset_le(host, 0xff, val, reg);
+}
+
+static unsigned int esdhc_imx_get_max_clock(struct sdhci_host *host)
+{
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+
+	return clk_get_rate(pltfm_host->clk);
+}
+
+static unsigned int esdhc_imx_get_min_clock(struct sdhci_host *host)
+{
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+
+	return clk_get_rate(pltfm_host->clk) / 256 / 16;
+}
+
+static struct sdhci_ops sdhci_esdhc_imx_ops = {
+	.read_w = esdhc_readw_le,
+	.write_w = esdhc_writew_le,
+	.write_b = esdhc_writeb_le,
+	.set_clock = esdhc_set_clock,
+	.get_max_clock = esdhc_imx_get_max_clock,
+	.get_min_clock = esdhc_imx_get_min_clock,
+};
+
+static struct sdhci_pltfm_data sdhci_esdhc_imx_pdata = {
+	.quirks = ESDHC_DEFAULT_QUIRKS | SDHCI_QUIRK_BROKEN_ADMA,
+	/* ADMA has issues. Might be fixable */
+	.ops = &sdhci_esdhc_imx_ops,
+};
+#endif
+
+#if defined(CONFIG_OF)
+#include <linux/of_device.h>
+static const struct of_device_id sdhci_esdhc_dt_ids[] = {
+#ifdef CONFIG_MMC_SDHCI_ESDHC_IMX
+	{ .compatible = "fsl,imx-esdhc", .data = &sdhci_esdhc_imx_pdata },
+#endif
+#ifdef CONFIG_MMC_SDHCI_ESDHC_MPC
+	{ .compatible = "fsl,mpc8379-esdhc", .data = &sdhci_esdhc_mpc_pdata },
+	{ .compatible = "fsl,mpc8536-esdhc", .data = &sdhci_esdhc_mpc_pdata },
+	{ .compatible = "fsl,esdhc", .data = &sdhci_esdhc_mpc_pdata },
+#endif
+	{ }
+};
+MODULE_DEVICE_TABLE(platform, sdhci_esdhc_dt_ids);
+
+static const struct of_device_id *
+sdhci_esdhc_get_of_device_id(struct platform_device *pdev)
+{
+	return of_match_device(sdhci_esdhc_dt_ids, &pdev->dev);
+}
+#else
+#define sdhci_esdhc_dt_ids NULL
+static inline struct of_device_id *
+sdhci_esdhc_get_of_device_id(struct platform_device *pdev)
+{
+	return NULL;
+}
+#endif
+
+static const struct platform_device_id sdhci_esdhc_pltfm_ids[] = {
+#ifdef CONFIG_MMC_SDHCI_ESDHC_IMX
+	{ "sdhci-esdhc-imx", (kernel_ulong_t)&sdhci_esdhc_imx_pdata },
+#endif
+	{ }
+};
+MODULE_DEVICE_TABLE(platform, sdhci_esdhc_pltfm_ids);
+
+#ifndef CONFIG_MMC_SDHCI_ESDHC_IMX
+#define cpu_is_mx25()	(0)
+#define cpu_is_mx35()	(0)
+#define cpu_is_mx51()	(0)
+#endif
+
+static int __devinit sdhci_esdhc_probe(struct platform_device *pdev)
+{
+	const struct platform_device_id *platid = platform_get_device_id(pdev);
+	const struct of_device_id *dtid = sdhci_esdhc_get_of_device_id(pdev);
+	struct sdhci_pltfm_data *pdata;
+	struct sdhci_pltfm_host *pltfm_host;
+	struct sdhci_host *host;
+	struct clk *clk;
+	int ret;
+
+	if (platid && platid->driver_data)
+		pdata = (void *)platid->driver_data;
+	else if (dtid && dtid->data)
+		pdata = dtid->data;
+	else
+		pdata = pdev->dev.platform_data;
+
+	host = sdhci_pltfm_init(pdev, pdata);
+	if (!host)
+		return -ENOMEM;
+
+	sdhci_get_of_property(pdev);
+
+	pltfm_host = sdhci_priv(host);
+
+	clk = clk_get(mmc_dev(host->mmc), NULL);
+	if (IS_ERR(clk)) {
+		dev_err(mmc_dev(host->mmc), "clk err\n");
+		ret = PTR_ERR(clk);
+		goto err_clk_get;
+	}
+	clk_enable(clk);
+	pltfm_host->clk = clk;
+
+	if (cpu_is_mx35() || cpu_is_mx51())
+		host->quirks |= SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;
+
+	/* Fix errata ENGcm07207 which is present on i.MX25 and i.MX35 */
+	if (cpu_is_mx25() || cpu_is_mx35())
+		host->quirks |= SDHCI_QUIRK_NO_MULTIBLOCK;
+
+	ret = sdhci_add_host(host);
+	if (ret)
+		goto err_add_host;
+
+	return 0;
+
+err_add_host:
+	clk_disable(pltfm_host->clk);
+	clk_put(pltfm_host->clk);
+err_clk_get:
+	sdhci_pltfm_free(pdev);
+	return ret;
+}
+
+static int __devexit sdhci_esdhc_remove(struct platform_device *pdev)
+{
+	struct sdhci_host *host = platform_get_drvdata(pdev);
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	int dead = 0;
+	u32 scratch;
+
+	scratch = readl(host->ioaddr + SDHCI_INT_STATUS);
+	if (scratch == (u32)-1)
+		dead = 1;
+
+	sdhci_remove_host(host, dead);
+
+	clk_disable(pltfm_host->clk);
+	clk_put(pltfm_host->clk);
+
+	sdhci_pltfm_free(pdev);
+
+	return 0;
+}
+
+static struct platform_driver sdhci_esdhc_driver = {
+	.driver = {
+		.name = "sdhci-esdhc",
+		.owner = THIS_MODULE,
+		.of_match_table = sdhci_esdhc_dt_ids,
+	},
+	.probe = sdhci_esdhc_probe,
+	.remove = __devexit_p(sdhci_esdhc_remove),
+	.id_table = sdhci_esdhc_pltfm_ids,
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
+MODULE_DESCRIPTION("SDHCI driver for Freescale eSDHC");
+MODULE_AUTHOR("Xiaobo Xie <X.Xie@freescale.com>, "
+	      "Anton Vorontsov <avorontsov@ru.mvista.com>, "
+	      "Wolfram Sang <w.sang@pengutronix.de>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/mmc/host/sdhci-of-esdhc.c b/drivers/mmc/host/sdhci-of-esdhc.c
deleted file mode 100644
index ccd182f..0000000
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ /dev/null
@@ -1,162 +0,0 @@
-/*
- * Freescale eSDHC controller driver.
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
-#include <linux/io.h>
-#include <linux/delay.h>
-#include <linux/mmc/host.h>
-#include "sdhci-pltfm.h"
-#include "sdhci.h"
-#include "sdhci-esdhc.h"
-
-static u16 esdhc_readw(struct sdhci_host *host, int reg)
-{
-	u16 ret;
-
-	if (unlikely(reg == SDHCI_HOST_VERSION))
-		ret = in_be16(host->ioaddr + reg);
-	else
-		ret = sdhci_be32bs_readw(host, reg);
-	return ret;
-}
-
-static void esdhc_writew(struct sdhci_host *host, u16 val, int reg)
-{
-	if (reg == SDHCI_BLOCK_SIZE) {
-		/*
-		 * Two last DMA bits are reserved, and first one is used for
-		 * non-standard blksz of 4096 bytes that we don't support
-		 * yet. So clear the DMA boundary bits.
-		 */
-		val &= ~SDHCI_MAKE_BLKSZ(0x7, 0);
-	}
-	sdhci_be32bs_writew(host, val, reg);
-}
-
-static void esdhc_writeb(struct sdhci_host *host, u8 val, int reg)
-{
-	/* Prevent SDHCI core from writing reserved bits (e.g. HISPD). */
-	if (reg == SDHCI_HOST_CONTROL)
-		val &= ~ESDHC_HOST_CONTROL_RES;
-	sdhci_be32bs_writeb(host, val, reg);
-}
-
-static int esdhc_of_enable_dma(struct sdhci_host *host)
-{
-	setbits32(host->ioaddr + ESDHC_DMA_SYSCTL, ESDHC_DMA_SNOOP);
-	return 0;
-}
-
-static unsigned int esdhc_of_get_max_clock(struct sdhci_host *host)
-{
-	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
-
-	return pltfm_host->clock;
-}
-
-static unsigned int esdhc_of_get_min_clock(struct sdhci_host *host)
-{
-	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
-
-	return pltfm_host->clock / 256 / 16;
-}
-
-static struct sdhci_ops sdhci_esdhc_ops = {
-	.read_l = sdhci_be32bs_readl,
-	.read_w = esdhc_readw,
-	.read_b = sdhci_be32bs_readb,
-	.write_l = sdhci_be32bs_writel,
-	.write_w = esdhc_writew,
-	.write_b = esdhc_writeb,
-	.set_clock = esdhc_set_clock,
-	.enable_dma = esdhc_of_enable_dma,
-	.get_max_clock = esdhc_of_get_max_clock,
-	.get_min_clock = esdhc_of_get_min_clock,
-};
-
-static struct sdhci_pltfm_data sdhci_esdhc_pdata = {
-	.quirks = ESDHC_DEFAULT_QUIRKS,
-	.ops = &sdhci_esdhc_ops,
-};
-
-static int __devinit sdhci_esdhc_probe(struct platform_device *pdev)
-{
-	struct sdhci_host *host;
-	int ret;
-
-	host = sdhci_pltfm_init(pdev, &sdhci_esdhc_pdata);
-	if (!host)
-		return -ENOMEM;
-
-	sdhci_get_of_property(pdev);
-
-	ret = sdhci_add_host(host);
-	if (ret)
-		goto err_add_host;
-
-	return 0;
-
-err_add_host:
-	sdhci_pltfm_free(pdev);
-	return ret;
-}
-
-static int __devexit sdhci_esdhc_remove(struct platform_device *pdev)
-{
-	struct sdhci_host *host = platform_get_drvdata(pdev);
-
-	sdhci_remove_host(host, 0);
-	sdhci_pltfm_free(pdev);
-
-	return 0;
-}
-
-static const struct of_device_id sdhci_esdhc_of_match[] = {
-	{ .compatible = "fsl,mpc8379-esdhc" },
-	{ .compatible = "fsl,mpc8536-esdhc" },
-	{ .compatible = "fsl,esdhc" },
-	{ }
-};
-MODULE_DEVICE_TABLE(of, sdhci_esdhc_of_match);
-
-static struct platform_driver sdhci_esdhc_driver = {
-	.driver = {
-		.name = "sdhci-esdhc",
-		.owner = THIS_MODULE,
-		.of_match_table = sdhci_esdhc_of_match,
-	},
-	.probe = sdhci_esdhc_probe,
-	.remove = __devexit_p(sdhci_esdhc_remove),
-#ifdef CONFIG_PM
-	.suspend = sdhci_pltfm_suspend,
-	.resume = sdhci_pltfm_resume,
-#endif
-};
-
-static int __init sdhci_esdhc_init(void)
-{
-	return platform_driver_register(&sdhci_esdhc_driver);
-}
-module_init(sdhci_esdhc_init);
-
-static void __exit sdhci_esdhc_exit(void)
-{
-	platform_driver_unregister(&sdhci_esdhc_driver);
-}
-module_exit(sdhci_esdhc_exit);
-
-MODULE_DESCRIPTION("Secure Digital Host Controller Interface OF driver");
-MODULE_AUTHOR("Xiaobo Xie <X.Xie@freescale.com>, "
-	      "Anton Vorontsov <avorontsov@ru.mvista.com>");
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/mmc/host/sdhci-pltfm.c b/drivers/mmc/host/sdhci-pltfm.c
index 4e998f1..004cc83 100644
--- a/drivers/mmc/host/sdhci-pltfm.c
+++ b/drivers/mmc/host/sdhci-pltfm.c
@@ -126,6 +126,8 @@ void sdhci_get_of_property(struct platform_device *pdev)
 			pltfm_host->clock = be32_to_cpup(clk);
 	}
 }
+#else
+void sdhci_get_of_property(struct platform_device *pdev) { }
 #endif
 
 struct sdhci_host *sdhci_pltfm_init(struct platform_device *pdev,
diff --git a/drivers/mmc/host/sdhci-pltfm.h b/drivers/mmc/host/sdhci-pltfm.h
index 2f38056..05fe25d 100644
--- a/drivers/mmc/host/sdhci-pltfm.h
+++ b/drivers/mmc/host/sdhci-pltfm.h
@@ -35,9 +35,7 @@ extern void sdhci_be32bs_writew(struct sdhci_host *host, u16 val, int reg);
 extern void sdhci_be32bs_writeb(struct sdhci_host *host, u8 val, int reg);
 #endif
 
-#ifdef CONFIG_OF
 extern void sdhci_get_of_property(struct platform_device *pdev);
-#endif
 
 extern struct sdhci_host *sdhci_pltfm_init(struct platform_device *pdev,
 					   struct sdhci_pltfm_data *pdata);
-- 
1.7.1

