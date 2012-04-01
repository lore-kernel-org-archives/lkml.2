Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab2DAPf3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 11:35:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42358 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751820Ab2DAPf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 11:35:27 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH/RFC] ARM: amba: Remove AMBA level regulator support
Date: Sun,  1 Apr 2012 16:29:40 +0100
Message-Id: <1333294181-27653-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AMBA bus regulator support is being used to model on/off switches
for power domains which isn't terribly idiomatic for modern kernels with
the generic power domain code and creates integration problems on platforms
which don't use regulators for their power domains as it's hard to tell
the difference between a regulator that is needed but failed to be provided
and one that isn't supposed to be there (though DT does make that easier).

Platforms that wish to use the regulator API to manage their power domains
can indirect via the power domain interface.

The impact should be minimal since currently there are no mainline
systems which actually provide a vcore regulator so none need updating.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

RFC because there's some disagreement about this.

 drivers/amba/bus.c       |   42 +-----------------------------------------
 drivers/spi/spi-pl022.c  |    2 --
 include/linux/amba/bus.h |    8 --------
 3 files changed, 1 insertions(+), 51 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 01c2cf4..cc27322 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -247,8 +247,7 @@ static int amba_pm_restore(struct device *dev)
 /*
  * Hooks to provide runtime PM of the pclk (bus clock).  It is safe to
  * enable/disable the bus clock at runtime PM suspend/resume as this
- * does not result in loss of context.  However, disabling vcore power
- * would do, so we leave that to the driver.
+ * does not result in loss of context.
  */
 static int amba_pm_runtime_suspend(struct device *dev)
 {
@@ -354,39 +353,6 @@ static void amba_put_disable_pclk(struct amba_device *pcdev)
 	clk_put(pclk);
 }
 
-static int amba_get_enable_vcore(struct amba_device *pcdev)
-{
-	struct regulator *vcore = regulator_get(&pcdev->dev, "vcore");
-	int ret;
-
-	pcdev->vcore = vcore;
-
-	if (IS_ERR(vcore)) {
-		/* It is OK not to supply a vcore regulator */
-		if (PTR_ERR(vcore) == -ENODEV)
-			return 0;
-		return PTR_ERR(vcore);
-	}
-
-	ret = regulator_enable(vcore);
-	if (ret) {
-		regulator_put(vcore);
-		pcdev->vcore = ERR_PTR(-ENODEV);
-	}
-
-	return ret;
-}
-
-static void amba_put_disable_vcore(struct amba_device *pcdev)
-{
-	struct regulator *vcore = pcdev->vcore;
-
-	if (!IS_ERR(vcore)) {
-		regulator_disable(vcore);
-		regulator_put(vcore);
-	}
-}
-
 /*
  * These are the device model conversion veneers; they convert the
  * device model structures to our more specific structures.
@@ -399,10 +365,6 @@ static int amba_probe(struct device *dev)
 	int ret;
 
 	do {
-		ret = amba_get_enable_vcore(pcdev);
-		if (ret)
-			break;
-
 		ret = amba_get_enable_pclk(pcdev);
 		if (ret)
 			break;
@@ -420,7 +382,6 @@ static int amba_probe(struct device *dev)
 		pm_runtime_put_noidle(dev);
 
 		amba_put_disable_pclk(pcdev);
-		amba_put_disable_vcore(pcdev);
 	} while (0);
 
 	return ret;
@@ -442,7 +403,6 @@ static int amba_remove(struct device *dev)
 	pm_runtime_put_noidle(dev);
 
 	amba_put_disable_pclk(pcdev);
-	amba_put_disable_vcore(pcdev);
 
 	return ret;
 }
diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index 96f0da6..09c925a 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -2195,7 +2195,6 @@ static int pl022_runtime_suspend(struct device *dev)
 	struct pl022 *pl022 = dev_get_drvdata(dev);
 
 	clk_disable(pl022->clk);
-	amba_vcore_disable(pl022->adev);
 
 	return 0;
 }
@@ -2204,7 +2203,6 @@ static int pl022_runtime_resume(struct device *dev)
 {
 	struct pl022 *pl022 = dev_get_drvdata(dev);
 
-	amba_vcore_enable(pl022->adev);
 	clk_enable(pl022->clk);
 
 	return 0;
diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index 7847e19..63a59ac 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -19,7 +19,6 @@
 #include <linux/mod_devicetable.h>
 #include <linux/err.h>
 #include <linux/resource.h>
-#include <linux/regulator/consumer.h>
 
 #define AMBA_NR_IRQS	2
 #define AMBA_CID	0xb105f00d
@@ -30,7 +29,6 @@ struct amba_device {
 	struct device		dev;
 	struct resource		res;
 	struct clk		*pclk;
-	struct regulator	*vcore;
 	u64			dma_mask;
 	unsigned int		periphid;
 	unsigned int		irq[AMBA_NR_IRQS];
@@ -75,12 +73,6 @@ void amba_release_regions(struct amba_device *);
 #define amba_pclk_disable(d)	\
 	do { if (!IS_ERR((d)->pclk)) clk_disable((d)->pclk); } while (0)
 
-#define amba_vcore_enable(d)	\
-	(IS_ERR((d)->vcore) ? 0 : regulator_enable((d)->vcore))
-
-#define amba_vcore_disable(d)	\
-	do { if (!IS_ERR((d)->vcore)) regulator_disable((d)->vcore); } while (0)
-
 /* Some drivers don't use the struct amba_device */
 #define AMBA_CONFIG_BITS(a) (((a) >> 24) & 0xff)
 #define AMBA_REV_BITS(a) (((a) >> 20) & 0x0f)
-- 
1.7.9.1

