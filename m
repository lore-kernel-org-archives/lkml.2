Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933911Ab1CYIpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 04:45:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44441 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933773Ab1CYIpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 04:45:43 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: devicetree-discuss@lists.ozlabs.org, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 2/5] mmc: sdhci: eliminate sdhci_of_host and sdhci_of_data
Date: Fri, 25 Mar 2011 16:48:48 +0800
Message-Id: <1301042931-4869-3-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
References: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is to migrate the use of sdhci_of_host and sdhci_of_data
to sdhci_pltfm_host and sdhci_pltfm_data, so that the former pair can
be eliminated.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/mmc/host/sdhci-of-core.c  |   30 +++++++++++++++---------------
 drivers/mmc/host/sdhci-of-esdhc.c |   36 +++++++++++++++++++-----------------
 drivers/mmc/host/sdhci-of-hlwd.c  |   20 +++++++++++---------
 drivers/mmc/host/sdhci-of.h       |   15 +++------------
 drivers/mmc/host/sdhci-pltfm.h    |    4 ++++
 5 files changed, 52 insertions(+), 53 deletions(-)

diff --git a/drivers/mmc/host/sdhci-of-core.c b/drivers/mmc/host/sdhci-of-core.c
index dd84124..a6c0132 100644
--- a/drivers/mmc/host/sdhci-of-core.c
+++ b/drivers/mmc/host/sdhci-of-core.c
@@ -59,7 +59,7 @@ void sdhci_be32bs_writel(struct sdhci_host *host, u32 val, int reg)
 
 void sdhci_be32bs_writew(struct sdhci_host *host, u16 val, int reg)
 {
-	struct sdhci_of_host *of_host = sdhci_priv(host);
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	int base = reg & ~0x3;
 	int shift = (reg & 0x2) * 8;
 
@@ -69,10 +69,10 @@ void sdhci_be32bs_writew(struct sdhci_host *host, u16 val, int reg)
 		 * Postpone this write, we must do it together with a
 		 * command write that is down below.
 		 */
-		of_host->xfer_mode_shadow = val;
+		pltfm_host->xfer_mode_shadow = val;
 		return;
 	case SDHCI_COMMAND:
-		sdhci_be32bs_writel(host, val << 16 | of_host->xfer_mode_shadow,
+		sdhci_be32bs_writel(host, val << 16 | pltfm_host->xfer_mode_shadow,
 				    SDHCI_TRANSFER_MODE);
 		return;
 	}
@@ -128,9 +128,9 @@ static int __devinit sdhci_of_probe(struct platform_device *ofdev,
 				 const struct of_device_id *match)
 {
 	struct device_node *np = ofdev->dev.of_node;
-	struct sdhci_of_data *sdhci_of_data = match->data;
+	struct sdhci_pltfm_data *pdata = match->data;
 	struct sdhci_host *host;
-	struct sdhci_of_host *of_host;
+	struct sdhci_pltfm_host *pltfm_host;
 	const __be32 *clk;
 	int size;
 	int ret;
@@ -138,11 +138,11 @@ static int __devinit sdhci_of_probe(struct platform_device *ofdev,
 	if (!of_device_is_available(np))
 		return -ENODEV;
 
-	host = sdhci_alloc_host(&ofdev->dev, sizeof(*of_host));
+	host = sdhci_alloc_host(&ofdev->dev, sizeof(*pltfm_host));
 	if (IS_ERR(host))
 		return -ENOMEM;
 
-	of_host = sdhci_priv(host);
+	pltfm_host = sdhci_priv(host);
 	dev_set_drvdata(&ofdev->dev, host);
 
 	host->ioaddr = of_iomap(np, 0);
@@ -158,9 +158,9 @@ static int __devinit sdhci_of_probe(struct platform_device *ofdev,
 	}
 
 	host->hw_name = dev_name(&ofdev->dev);
-	if (sdhci_of_data) {
-		host->quirks = sdhci_of_data->quirks;
-		host->ops = &sdhci_of_data->ops;
+	if (pdata) {
+		host->quirks = pdata->quirks;
+		host->ops = &pdata->ops;
 	}
 
 	if (of_get_property(np, "sdhci,auto-cmd12", NULL))
@@ -175,7 +175,7 @@ static int __devinit sdhci_of_probe(struct platform_device *ofdev,
 
 	clk = of_get_property(np, "clock-frequency", &size);
 	if (clk && size == sizeof(*clk) && *clk)
-		of_host->clock = be32_to_cpup(clk);
+		pltfm_host->clock = be32_to_cpup(clk);
 
 	ret = sdhci_add_host(host);
 	if (ret)
@@ -205,12 +205,12 @@ static int __devexit sdhci_of_remove(struct platform_device *ofdev)
 
 static const struct of_device_id sdhci_of_match[] = {
 #ifdef CONFIG_MMC_SDHCI_OF_ESDHC
-	{ .compatible = "fsl,mpc8379-esdhc", .data = &sdhci_esdhc, },
-	{ .compatible = "fsl,mpc8536-esdhc", .data = &sdhci_esdhc, },
-	{ .compatible = "fsl,esdhc", .data = &sdhci_esdhc, },
+	{ .compatible = "fsl,mpc8379-esdhc", .data = &sdhci_esdhc_pdata, },
+	{ .compatible = "fsl,mpc8536-esdhc", .data = &sdhci_esdhc_pdata, },
+	{ .compatible = "fsl,esdhc", .data = &sdhci_esdhc_pdata, },
 #endif
 #ifdef CONFIG_MMC_SDHCI_OF_HLWD
-	{ .compatible = "nintendo,hollywood-sdhci", .data = &sdhci_hlwd, },
+	{ .compatible = "nintendo,hollywood-sdhci", .data = &sdhci_hlwd_pdata, },
 #endif
 	{ .compatible = "generic-sdhci", },
 	{},
diff --git a/drivers/mmc/host/sdhci-of-esdhc.c b/drivers/mmc/host/sdhci-of-esdhc.c
index fcd0e1f..702a98b 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -60,30 +60,32 @@ static int esdhc_of_enable_dma(struct sdhci_host *host)
 
 static unsigned int esdhc_of_get_max_clock(struct sdhci_host *host)
 {
-	struct sdhci_of_host *of_host = sdhci_priv(host);
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 
-	return of_host->clock;
+	return pltfm_host->clock;
 }
 
 static unsigned int esdhc_of_get_min_clock(struct sdhci_host *host)
 {
-	struct sdhci_of_host *of_host = sdhci_priv(host);
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 
-	return of_host->clock / 256 / 16;
+	return pltfm_host->clock / 256 / 16;
 }
 
-struct sdhci_of_data sdhci_esdhc = {
+static struct sdhci_ops sdhci_esdhc_ops = {
+	.read_l = sdhci_be32bs_readl,
+	.read_w = esdhc_readw,
+	.read_b = sdhci_be32bs_readb,
+	.write_l = sdhci_be32bs_writel,
+	.write_w = esdhc_writew,
+	.write_b = esdhc_writeb,
+	.set_clock = esdhc_set_clock,
+	.enable_dma = esdhc_of_enable_dma,
+	.get_max_clock = esdhc_of_get_max_clock,
+	.get_min_clock = esdhc_of_get_min_clock,
+};
+
+struct sdhci_pltfm_data sdhci_esdhc_pdata = {
 	.quirks = ESDHC_DEFAULT_QUIRKS,
-	.ops = {
-		.read_l = sdhci_be32bs_readl,
-		.read_w = esdhc_readw,
-		.read_b = sdhci_be32bs_readb,
-		.write_l = sdhci_be32bs_writel,
-		.write_w = esdhc_writew,
-		.write_b = esdhc_writeb,
-		.set_clock = esdhc_set_clock,
-		.enable_dma = esdhc_of_enable_dma,
-		.get_max_clock = esdhc_of_get_max_clock,
-		.get_min_clock = esdhc_of_get_min_clock,
-	},
+	.ops = &sdhci_esdhc_ops,
 };
diff --git a/drivers/mmc/host/sdhci-of-hlwd.c b/drivers/mmc/host/sdhci-of-hlwd.c
index 68ddb75..380e896 100644
--- a/drivers/mmc/host/sdhci-of-hlwd.c
+++ b/drivers/mmc/host/sdhci-of-hlwd.c
@@ -51,15 +51,17 @@ static void sdhci_hlwd_writeb(struct sdhci_host *host, u8 val, int reg)
 	udelay(SDHCI_HLWD_WRITE_DELAY);
 }
 
-struct sdhci_of_data sdhci_hlwd = {
+static struct sdhci_ops sdhci_hlwd_ops = {
+	.read_l = sdhci_be32bs_readl,
+	.read_w = sdhci_be32bs_readw,
+	.read_b = sdhci_be32bs_readb,
+	.write_l = sdhci_hlwd_writel,
+	.write_w = sdhci_hlwd_writew,
+	.write_b = sdhci_hlwd_writeb,
+};
+
+struct sdhci_pltfm_data sdhci_hlwd_pdata = {
 	.quirks = SDHCI_QUIRK_32BIT_DMA_ADDR |
 		  SDHCI_QUIRK_32BIT_DMA_SIZE,
-	.ops = {
-		.read_l = sdhci_be32bs_readl,
-		.read_w = sdhci_be32bs_readw,
-		.read_b = sdhci_be32bs_readb,
-		.write_l = sdhci_hlwd_writel,
-		.write_w = sdhci_hlwd_writew,
-		.write_b = sdhci_hlwd_writeb,
-	},
+	.ops = &sdhci_hlwd_ops,
 };
diff --git a/drivers/mmc/host/sdhci-of.h b/drivers/mmc/host/sdhci-of.h
index ad09ad9..5bdb5e7 100644
--- a/drivers/mmc/host/sdhci-of.h
+++ b/drivers/mmc/host/sdhci-of.h
@@ -18,16 +18,7 @@
 
 #include <linux/types.h>
 #include "sdhci.h"
-
-struct sdhci_of_data {
-	unsigned int quirks;
-	struct sdhci_ops ops;
-};
-
-struct sdhci_of_host {
-	unsigned int clock;
-	u16 xfer_mode_shadow;
-};
+#include "sdhci-pltfm.h"
 
 extern u32 sdhci_be32bs_readl(struct sdhci_host *host, int reg);
 extern u16 sdhci_be32bs_readw(struct sdhci_host *host, int reg);
@@ -36,7 +27,7 @@ extern void sdhci_be32bs_writel(struct sdhci_host *host, u32 val, int reg);
 extern void sdhci_be32bs_writew(struct sdhci_host *host, u16 val, int reg);
 extern void sdhci_be32bs_writeb(struct sdhci_host *host, u8 val, int reg);
 
-extern struct sdhci_of_data sdhci_esdhc;
-extern struct sdhci_of_data sdhci_hlwd;
+extern struct sdhci_pltfm_data sdhci_esdhc_pdata;
+extern struct sdhci_pltfm_data sdhci_hlwd_pdata;
 
 #endif /* __SDHCI_OF_H */
diff --git a/drivers/mmc/host/sdhci-pltfm.h b/drivers/mmc/host/sdhci-pltfm.h
index a3e4be0..12afe86 100644
--- a/drivers/mmc/host/sdhci-pltfm.h
+++ b/drivers/mmc/host/sdhci-pltfm.h
@@ -19,6 +19,10 @@
 struct sdhci_pltfm_host {
 	struct clk *clk;
 	u32 scratchpad; /* to handle quirks across io-accessor calls */
+
+	/* migrate from sdhci_of_host */
+	unsigned int clock;
+	u16 xfer_mode_shadow;
 };
 
 extern struct sdhci_host *sdhci_pltfm_init(struct platform_device *pdev,
-- 
1.7.1

