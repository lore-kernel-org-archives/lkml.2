Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab2GDTJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 15:09:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60298 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932117Ab2GDTJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 15:09:17 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Oritz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: arizona: Move digital core supply management to the regulator API
Date: Wed,  4 Jul 2012 20:09:12 +0100
Message-Id: <1341428952-5271-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than open coding the enable GPIO control in the MFD core use the
API to push the management on to the regulator driver. The immediate
advantage is slight for most systems but this will in future allow device
configurations where an external regulator is used for DCVDD.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c       |   65 ++++++++++++++++++++------------------
 include/linux/mfd/arizona/core.h |    1 +
 2 files changed, 36 insertions(+), 30 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 51e8c5a..d5ef6fa 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/err.h>
 #include <linux/gpio.h>
 #include <linux/interrupt.h>
 #include <linux/mfd/core.h>
@@ -28,7 +29,6 @@
 static const char *wm5102_core_supplies[] = {
 	"AVDD",
 	"DBVDD1",
-	"DCVDD",
 };
 
 int arizona_clk32k_enable(struct arizona *arizona)
@@ -223,8 +223,11 @@ static int arizona_runtime_resume(struct device *dev)
 	struct arizona *arizona = dev_get_drvdata(dev);
 	int ret;
 
-	if (arizona->pdata.ldoena)
-		gpio_set_value_cansleep(arizona->pdata.ldoena, 1);
+	ret = regulator_enable(arizona->dcvdd);
+	if (ret != 0) {
+		dev_err(arizona->dev, "Failed to enable DCVDD: %d\n", ret);
+		return ret;
+	}
 
 	regcache_cache_only(arizona->regmap, false);
 
@@ -241,11 +244,9 @@ static int arizona_runtime_suspend(struct device *dev)
 {
 	struct arizona *arizona = dev_get_drvdata(dev);
 
-	if (arizona->pdata.ldoena) {
-		gpio_set_value_cansleep(arizona->pdata.ldoena, 0);
-		regcache_cache_only(arizona->regmap, true);
-		regcache_mark_dirty(arizona->regmap);
-	}
+	regulator_disable(arizona->dcvdd);
+	regcache_cache_only(arizona->regmap, true);
+	regcache_mark_dirty(arizona->regmap);
 
 	return 0;
 }
@@ -314,6 +315,13 @@ int __devinit arizona_dev_init(struct arizona *arizona)
 		goto err_early;
 	}
 
+	arizona->dcvdd = devm_regulator_get(arizona->dev, "DCVDD");
+	if (IS_ERR(arizona->dcvdd)) {
+		ret = PTR_ERR(arizona->dcvdd);
+		dev_err(dev, "Failed to request DCVDD: %d\n", ret);
+		goto err_early;
+	}
+
 	ret = regulator_bulk_enable(arizona->num_core_supplies,
 				    arizona->core_supplies);
 	if (ret != 0) {
@@ -322,6 +330,12 @@ int __devinit arizona_dev_init(struct arizona *arizona)
 		goto err_early;
 	}
 
+	ret = regulator_enable(arizona->dcvdd);
+	if (ret != 0) {
+		dev_err(dev, "Failed to enable DCVDD: %d\n", ret);
+		goto err_enable;
+	}
+
 	if (arizona->pdata.reset) {
 		/* Start out with /RESET low to put the chip into reset */
 		ret = gpio_request_one(arizona->pdata.reset,
@@ -329,35 +343,25 @@ int __devinit arizona_dev_init(struct arizona *arizona)
 				       "arizona /RESET");
 		if (ret != 0) {
 			dev_err(dev, "Failed to request /RESET: %d\n", ret);
-			goto err_enable;
+			goto err_dcvdd;
 		}
 
 		gpio_set_value_cansleep(arizona->pdata.reset, 1);
 	}
 
-	if (arizona->pdata.ldoena) {
-		ret = gpio_request_one(arizona->pdata.ldoena,
-				       GPIOF_DIR_OUT | GPIOF_INIT_HIGH,
-				       "arizona LDOENA");
-		if (ret != 0) {
-			dev_err(dev, "Failed to request LDOENA: %d\n", ret);
-			goto err_reset;
-		}
-	}
-
 	regcache_cache_only(arizona->regmap, false);
 
 	ret = regmap_read(arizona->regmap, ARIZONA_SOFTWARE_RESET, &reg);
 	if (ret != 0) {
 		dev_err(dev, "Failed to read ID register: %d\n", ret);
-		goto err_ldoena;
+		goto err_reset;
 	}
 
 	ret = regmap_read(arizona->regmap, ARIZONA_DEVICE_REVISION,
 			  &arizona->rev);
 	if (ret != 0) {
 		dev_err(dev, "Failed to read revision register: %d\n", ret);
-		goto err_ldoena;
+		goto err_reset;
 	}
 	arizona->rev &= ARIZONA_DEVICE_REVISION_MASK;
 
@@ -374,7 +378,7 @@ int __devinit arizona_dev_init(struct arizona *arizona)
 
 	default:
 		dev_err(arizona->dev, "Unknown device ID %x\n", reg);
-		goto err_ldoena;
+		goto err_reset;
 	}
 
 	dev_info(dev, "%s revision %c\n", type_name, arizona->rev + 'A');
@@ -387,7 +391,7 @@ int __devinit arizona_dev_init(struct arizona *arizona)
 		ret = regmap_write(arizona->regmap, ARIZONA_SOFTWARE_RESET, 0);
 		if (ret != 0) {
 			dev_err(dev, "Failed to reset device: %d\n", ret);
-			goto err_ldoena;
+			goto err_reset;
 		}
 	}
 
@@ -424,7 +428,7 @@ int __devinit arizona_dev_init(struct arizona *arizona)
 		dev_err(arizona->dev, "Invalid 32kHz clock source: %d\n",
 			arizona->pdata.clk32k_src);
 		ret = -EINVAL;
-		goto err_ldoena;
+		goto err_reset;
 	}
 
 	for (i = 0; i < ARIZONA_MAX_INPUT; i++) {
@@ -470,7 +474,7 @@ int __devinit arizona_dev_init(struct arizona *arizona)
 	/* Set up for interrupts */
 	ret = arizona_irq_init(arizona);
 	if (ret != 0)
-		goto err_ldoena;
+		goto err_reset;
 
 	arizona_request_irq(arizona, ARIZONA_IRQ_CLKGEN_ERR, "CLKGEN error",
 			    arizona_clkgen_err, arizona);
@@ -491,20 +495,21 @@ int __devinit arizona_dev_init(struct arizona *arizona)
 		goto err_irq;
 	}
 
+#ifdef CONFIG_PM_RUNTIME
+	regulator_disable(arizona->dcvdd);
+#endif
+
 	return 0;
 
 err_irq:
 	arizona_irq_exit(arizona);
-err_ldoena:
-	if (arizona->pdata.ldoena) {
-		gpio_set_value_cansleep(arizona->pdata.ldoena, 0);
-		gpio_free(arizona->pdata.ldoena);
-	}
 err_reset:
 	if (arizona->pdata.reset) {
 		gpio_set_value_cansleep(arizona->pdata.reset, 1);
 		gpio_free(arizona->pdata.reset);
 	}
+err_dcvdd:
+	regulator_disable(arizona->dcvdd);
 err_enable:
 	regulator_bulk_disable(ARRAY_SIZE(arizona->core_supplies),
 			       arizona->core_supplies);	
diff --git a/include/linux/mfd/arizona/core.h b/include/linux/mfd/arizona/core.h
index 0157d84..3ef32b4 100644
--- a/include/linux/mfd/arizona/core.h
+++ b/include/linux/mfd/arizona/core.h
@@ -77,6 +77,7 @@ struct arizona {
 
 	int num_core_supplies;
 	struct regulator_bulk_data core_supplies[ARIZONA_MAX_CORE_SUPPLIES];
+	struct regulator *dcvdd;
 
 	struct arizona_pdata pdata;
 
-- 
1.7.10

