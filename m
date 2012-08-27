Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab2H0XqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 19:46:11 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:37167 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab2H0XqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 19:46:10 -0400
MBOX-Line: From nobody Mon Aug 27 17:36:10 2012
Subject: [PATCH 2/5] hwrng: OMAP: store per-device data in per-device
 variables, not file statics
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
From: Paul Walmsley <paul@pwsan.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 27 Aug 2012 17:36:10 -0600
Message-ID: <20120827233609.15045.38385.stgit@dusk.lan>
In-Reply-To: <20120827232922.15045.56522.stgit@dusk.lan>
References: <20120827232922.15045.56522.stgit@dusk.lan>
User-Agent: StGit/0.16-37-g27ac3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Encapsulate all of the RNG per-device state into a single per-device
structure record, as opposed to a set of per-driver file variables.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/char/hw_random/omap-rng.c |  115 +++++++++++++++++++++++++------------
 1 file changed, 77 insertions(+), 38 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 4fbdceb..e0f0b98 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -23,6 +23,7 @@
 #include <linux/platform_device.h>
 #include <linux/hw_random.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 
 #include <asm/io.h>
 
@@ -46,26 +47,38 @@
 #define RNG_SYSSTATUS		0x44		/* System status
 							[0] = RESETDONE */
 
-static void __iomem *rng_base;
-static struct clk *rng_ick;
-static struct platform_device *rng_dev;
+/**
+ * struct omap_rng_private_data - RNG IP block-specific data
+ * @base: virtual address of the beginning of the RNG IP block registers
+ * @clk: RNG clock
+ * @mem_res: struct resource * for the IP block registers physical memory
+ */
+struct omap_rng_private_data {
+	void __iomem *base;
+	struct clk *clk;
+	struct resource *mem_res;
+};
 
-static inline u32 omap_rng_read_reg(int reg)
+static inline u32 omap_rng_read_reg(struct omap_rng_private_data *priv, int reg)
 {
-	return __raw_readl(rng_base + reg);
+	return __raw_readl(priv->base + reg);
 }
 
-static inline void omap_rng_write_reg(int reg, u32 val)
+static inline void omap_rng_write_reg(struct omap_rng_private_data *priv,
+				      int reg, u32 val)
 {
-	__raw_writel(val, rng_base + reg);
+	__raw_writel(val, priv->base + reg);
 }
 
 static int omap_rng_data_present(struct hwrng *rng, int wait)
 {
+	struct omap_rng_private_data *priv;
 	int data, i;
 
+	priv = (struct omap_rng_private_data *)rng->priv;
+
 	for (i = 0; i < 20; i++) {
-		data = omap_rng_read_reg(RNG_STAT_REG) ? 0 : 1;
+		data = omap_rng_read_reg(priv, RNG_STAT_REG) ? 0 : 1;
 		if (data || !wait)
 			break;
 		/* RNG produces data fast enough (2+ MBit/sec, even
@@ -80,9 +93,13 @@ static int omap_rng_data_present(struct hwrng *rng, int wait)
 
 static int omap_rng_data_read(struct hwrng *rng, u32 *data)
 {
-	*data = omap_rng_read_reg(RNG_OUT_REG);
+	struct omap_rng_private_data *priv;
+
+	priv = (struct omap_rng_private_data *)rng->priv;
+
+	*data = omap_rng_read_reg(priv, RNG_OUT_REG);
 
-	return 4;
+	return sizeof(u32);
 }
 
 static struct hwrng omap_rng_ops = {
@@ -93,69 +110,85 @@ static struct hwrng omap_rng_ops = {
 
 static int __devinit omap_rng_probe(struct platform_device *pdev)
 {
-	struct resource *res;
+	struct omap_rng_private_data *priv;
 	int ret;
 
-	/*
-	 * A bit ugly, and it will never actually happen but there can
-	 * be only one RNG and this catches any bork
-	 */
-	if (rng_dev)
-		return -EBUSY;
+	priv = kzalloc(sizeof(struct omap_rng_private_data), GFP_KERNEL);
+	if (!priv) {
+		dev_err(&pdev->dev, "could not allocate memory\n");
+		return -ENOMEM;
+	};
+
+	omap_rng_ops.priv = (unsigned long)priv;
+	dev_set_drvdata(&pdev->dev, priv);
 
 	if (cpu_is_omap24xx()) {
-		rng_ick = clk_get(&pdev->dev, "ick");
-		if (IS_ERR(rng_ick)) {
+		priv->clk = clk_get(&pdev->dev, "ick");
+		if (IS_ERR(priv->clk)) {
 			dev_err(&pdev->dev, "Could not get rng_ick\n");
-			ret = PTR_ERR(rng_ick);
+			ret = PTR_ERR(priv->clk);
 			return ret;
-		} else
-			clk_enable(rng_ick);
+		} else {
+			clk_enable(priv->clk);
+		}
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	priv->mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!priv->mem_res) {
+		ret = -ENOENT;
+		goto err_ioremap;
+	}
 
-	rng_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!rng_base) {
+	priv->base = devm_request_and_ioremap(&pdev->dev, priv->mem_res);
+	if (!priv->base) {
 		ret = -ENOMEM;
 		goto err_ioremap;
 	}
-	dev_set_drvdata(&pdev->dev, res);
+	dev_set_drvdata(&pdev->dev, priv);
 
 	ret = hwrng_register(&omap_rng_ops);
 	if (ret)
 		goto err_register;
 
 	dev_info(&pdev->dev, "OMAP Random Number Generator ver. %02x\n",
-		omap_rng_read_reg(RNG_REV_REG));
-	omap_rng_write_reg(RNG_MASK_REG, 0x1);
+		 omap_rng_read_reg(priv, RNG_REV_REG));
+
 
-	rng_dev = pdev;
+	omap_rng_write_reg(priv, RNG_MASK_REG, 0x1);
 
 	return 0;
 
 err_register:
-	rng_base = NULL;
+	priv->base = NULL;
 err_ioremap:
 	if (cpu_is_omap24xx()) {
-		clk_disable(rng_ick);
-		clk_put(rng_ick);
+		clk_disable(priv->clk);
+		clk_put(priv->clk);
 	}
+
+	kfree(priv);
+
 	return ret;
 }
 
 static int __exit omap_rng_remove(struct platform_device *pdev)
 {
+	struct omap_rng_private_data *priv = dev_get_drvdata(&pdev->dev);
+
 	hwrng_unregister(&omap_rng_ops);
 
-	omap_rng_write_reg(RNG_MASK_REG, 0x0);
+	omap_rng_write_reg(priv, RNG_MASK_REG, 0x0);
+
+	iounmap(priv->base);
 
 	if (cpu_is_omap24xx()) {
-		clk_disable(rng_ick);
-		clk_put(rng_ick);
+		clk_disable(priv->clk);
+		clk_put(priv->clk);
 	}
 
-	rng_base = NULL;
+	release_mem_region(priv->mem_res->start, resource_size(priv->mem_res));
+
+	kfree(priv);
 
 	return 0;
 }
@@ -164,13 +197,19 @@ static int __exit omap_rng_remove(struct platform_device *pdev)
 
 static int omap_rng_suspend(struct device *dev)
 {
-	omap_rng_write_reg(RNG_MASK_REG, 0x0);
+	struct omap_rng_private_data *priv = dev_get_drvdata(dev);
+
+	omap_rng_write_reg(priv, RNG_MASK_REG, 0x0);
+
 	return 0;
 }
 
 static int omap_rng_resume(struct device *dev)
 {
-	omap_rng_write_reg(RNG_MASK_REG, 0x1);
+	struct omap_rng_private_data *priv = dev_get_drvdata(dev);
+
+	omap_rng_write_reg(priv, RNG_MASK_REG, 0x1);
+
 	return 0;
 }
 


