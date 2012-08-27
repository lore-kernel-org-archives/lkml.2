Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab2H0Xp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 19:45:29 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:37158 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab2H0Xp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 19:45:28 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Aug 2012 19:45:28 EDT
MBOX-Line: From nobody Mon Aug 27 17:36:11 2012
Subject: [PATCH 3/5] hwrng: OMAP: convert to use runtime PM
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
From: Paul Walmsley <paul@pwsan.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 27 Aug 2012 17:36:11 -0600
Message-ID: <20120827233610.15045.10090.stgit@dusk.lan>
In-Reply-To: <20120827232922.15045.56522.stgit@dusk.lan>
References: <20120827232922.15045.56522.stgit@dusk.lan>
User-Agent: StGit/0.16-37-g27ac3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the OMAP onboard hardware RNG driver to use runtime PM.

This allows us to remove some OMAP-specific cpu_is_omap*() calls from
the RNG driver.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/char/hw_random/omap-rng.c |   35 +++++++++--------------------------
 1 file changed, 9 insertions(+), 26 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index e0f0b98..748fcc8 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -18,12 +18,12 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/random.h>
-#include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/hw_random.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 
 #include <asm/io.h>
 
@@ -50,12 +50,10 @@
 /**
  * struct omap_rng_private_data - RNG IP block-specific data
  * @base: virtual address of the beginning of the RNG IP block registers
- * @clk: RNG clock
  * @mem_res: struct resource * for the IP block registers physical memory
  */
 struct omap_rng_private_data {
 	void __iomem *base;
-	struct clk *clk;
 	struct resource *mem_res;
 };
 
@@ -122,17 +120,6 @@ static int __devinit omap_rng_probe(struct platform_device *pdev)
 	omap_rng_ops.priv = (unsigned long)priv;
 	dev_set_drvdata(&pdev->dev, priv);
 
-	if (cpu_is_omap24xx()) {
-		priv->clk = clk_get(&pdev->dev, "ick");
-		if (IS_ERR(priv->clk)) {
-			dev_err(&pdev->dev, "Could not get rng_ick\n");
-			ret = PTR_ERR(priv->clk);
-			return ret;
-		} else {
-			clk_enable(priv->clk);
-		}
-	}
-
 	priv->mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!priv->mem_res) {
 		ret = -ENOENT;
@@ -146,6 +133,9 @@ static int __devinit omap_rng_probe(struct platform_device *pdev)
 	}
 	dev_set_drvdata(&pdev->dev, priv);
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_get_sync(&pdev->dev);
+
 	ret = hwrng_register(&omap_rng_ops);
 	if (ret)
 		goto err_register;
@@ -153,19 +143,14 @@ static int __devinit omap_rng_probe(struct platform_device *pdev)
 	dev_info(&pdev->dev, "OMAP Random Number Generator ver. %02x\n",
 		 omap_rng_read_reg(priv, RNG_REV_REG));
 
-
 	omap_rng_write_reg(priv, RNG_MASK_REG, 0x1);
 
 	return 0;
 
 err_register:
 	priv->base = NULL;
+	pm_runtime_disable(&pdev->dev);
 err_ioremap:
-	if (cpu_is_omap24xx()) {
-		clk_disable(priv->clk);
-		clk_put(priv->clk);
-	}
-
 	kfree(priv);
 
 	return ret;
@@ -179,12 +164,8 @@ static int __exit omap_rng_remove(struct platform_device *pdev)
 
 	omap_rng_write_reg(priv, RNG_MASK_REG, 0x0);
 
-	iounmap(priv->base);
-
-	if (cpu_is_omap24xx()) {
-		clk_disable(priv->clk);
-		clk_put(priv->clk);
-	}
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 
 	release_mem_region(priv->mem_res->start, resource_size(priv->mem_res));
 
@@ -200,6 +181,7 @@ static int omap_rng_suspend(struct device *dev)
 	struct omap_rng_private_data *priv = dev_get_drvdata(dev);
 
 	omap_rng_write_reg(priv, RNG_MASK_REG, 0x0);
+	pm_runtime_put_sync(dev);
 
 	return 0;
 }
@@ -208,6 +190,7 @@ static int omap_rng_resume(struct device *dev)
 {
 	struct omap_rng_private_data *priv = dev_get_drvdata(dev);
 
+	pm_runtime_get_sync(dev);
 	omap_rng_write_reg(priv, RNG_MASK_REG, 0x1);
 
 	return 0;


