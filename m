Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab2EINPC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:15:02 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3102 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757741Ab2EINO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:14:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 09 May 2012 06:14:48 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        jedu@slimlogic.co.uk, lrg@slimlogic.co.uk
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 4/4] gpio: tps65910: move this as platform driver
Date: Wed,  9 May 2012 18:40:57 +0530
Message-Id: <1336569057-3890-5-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1336569057-3890-1-git-send-email-ldewangan@nvidia.com>
References: <1336569057-3890-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the gpio-tps65910 as platform driver and register
this from tps65910 core driver as mfd sub device.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/gpio/gpio-tps65910.c |  140 ++++++++++++++++++++++++++++++-----------
 1 files changed, 102 insertions(+), 38 deletions(-)

diff --git a/drivers/gpio/gpio-tps65910.c b/drivers/gpio/gpio-tps65910.c
index 7eef648..3db5357 100644
--- a/drivers/gpio/gpio-tps65910.c
+++ b/drivers/gpio/gpio-tps65910.c
@@ -18,11 +18,23 @@
 #include <linux/errno.h>
 #include <linux/gpio.h>
 #include <linux/i2c.h>
+#include <linux/platform_device.h>
 #include <linux/mfd/tps65910.h>
 
+struct tps65910_gpio {
+	struct gpio_chip gpio_chip;
+	struct tps65910 *tps65910;
+};
+
+static inline struct tps65910_gpio *to_tps65910_gpio(struct gpio_chip *chip)
+{
+	return container_of(chip, struct tps65910_gpio, gpio_chip);
+}
+
 static int tps65910_gpio_get(struct gpio_chip *gc, unsigned offset)
 {
-	struct tps65910 *tps65910 = container_of(gc, struct tps65910, gpio);
+	struct tps65910_gpio *tps65910_gpio = to_tps65910_gpio(gc);
+	struct tps65910 *tps65910 = tps65910_gpio->tps65910;
 	uint8_t val;
 
 	tps65910->read(tps65910, TPS65910_GPIO0 + offset, 1, &val);
@@ -36,7 +48,8 @@ static int tps65910_gpio_get(struct gpio_chip *gc, unsigned offset)
 static void tps65910_gpio_set(struct gpio_chip *gc, unsigned offset,
 			      int value)
 {
-	struct tps65910 *tps65910 = container_of(gc, struct tps65910, gpio);
+	struct tps65910_gpio *tps65910_gpio = to_tps65910_gpio(gc);
+	struct tps65910 *tps65910 = tps65910_gpio->tps65910;
 
 	if (value)
 		tps65910_set_bits(tps65910, TPS65910_GPIO0 + offset,
@@ -49,7 +62,8 @@ static void tps65910_gpio_set(struct gpio_chip *gc, unsigned offset,
 static int tps65910_gpio_output(struct gpio_chip *gc, unsigned offset,
 				int value)
 {
-	struct tps65910 *tps65910 = container_of(gc, struct tps65910, gpio);
+	struct tps65910_gpio *tps65910_gpio = to_tps65910_gpio(gc);
+	struct tps65910 *tps65910 = tps65910_gpio->tps65910;
 
 	/* Set the initial value */
 	tps65910_gpio_set(gc, offset, value);
@@ -60,59 +74,109 @@ static int tps65910_gpio_output(struct gpio_chip *gc, unsigned offset,
 
 static int tps65910_gpio_input(struct gpio_chip *gc, unsigned offset)
 {
-	struct tps65910 *tps65910 = container_of(gc, struct tps65910, gpio);
+	struct tps65910_gpio *tps65910_gpio = to_tps65910_gpio(gc);
+	struct tps65910 *tps65910 = tps65910_gpio->tps65910;
 
 	return tps65910_clear_bits(tps65910, TPS65910_GPIO0 + offset,
 						GPIO_CFG_MASK);
 }
 
-void tps65910_gpio_init(struct tps65910 *tps65910, int gpio_base)
+static int __devinit tps65910_gpio_probe(struct platform_device *pdev)
 {
+	struct tps65910 *tps65910 = dev_get_drvdata(pdev->dev.parent);
+	struct tps65910_board *pdata = dev_get_platdata(tps65910->dev);
+	struct tps65910_gpio *tps65910_gpio;
 	int ret;
-	struct tps65910_board *board_data;
+	int i;
+
+	tps65910_gpio = devm_kzalloc(&pdev->dev,
+				sizeof(*tps65910_gpio), GFP_KERNEL);
+	if (!tps65910_gpio) {
+		dev_err(&pdev->dev, "Could not allocate tps65910_gpio\n");
+		return -ENOMEM;
+	}
 
-	if (!gpio_base)
-		return;
+	tps65910_gpio->tps65910 = tps65910;
 
-	tps65910->gpio.owner		= THIS_MODULE;
-	tps65910->gpio.label		= tps65910->i2c_client->name;
-	tps65910->gpio.dev		= tps65910->dev;
-	tps65910->gpio.base		= gpio_base;
+	tps65910_gpio->gpio_chip.owner = THIS_MODULE;
+	tps65910_gpio->gpio_chip.label = tps65910->i2c_client->name;
 
 	switch(tps65910_chip_id(tps65910)) {
 	case TPS65910:
-		tps65910->gpio.ngpio	= TPS65910_NUM_GPIO;
+		tps65910_gpio->gpio_chip.ngpio = TPS65910_NUM_GPIO;
 		break;
 	case TPS65911:
-		tps65910->gpio.ngpio	= TPS65911_NUM_GPIO;
+		tps65910_gpio->gpio_chip.ngpio = TPS65911_NUM_GPIO;
 		break;
 	default:
-		return;
+		return -EINVAL;
 	}
-	tps65910->gpio.can_sleep	= 1;
-
-	tps65910->gpio.direction_input	= tps65910_gpio_input;
-	tps65910->gpio.direction_output	= tps65910_gpio_output;
-	tps65910->gpio.set		= tps65910_gpio_set;
-	tps65910->gpio.get		= tps65910_gpio_get;
-
-	/* Configure sleep control for gpios */
-	board_data = dev_get_platdata(tps65910->dev);
-	if (board_data) {
-		int i;
-		for (i = 0; i < tps65910->gpio.ngpio; ++i) {
-			if (board_data->en_gpio_sleep[i]) {
-				ret = tps65910_set_bits(tps65910,
-					TPS65910_GPIO0 + i, GPIO_SLEEP_MASK);
-				if (ret < 0)
-					dev_warn(tps65910->dev,
-						"GPIO Sleep setting failed\n");
-			}
-		}
+	tps65910_gpio->gpio_chip.can_sleep = 1;
+	tps65910_gpio->gpio_chip.direction_input = tps65910_gpio_input;
+	tps65910_gpio->gpio_chip.direction_output = tps65910_gpio_output;
+	tps65910_gpio->gpio_chip.set	= tps65910_gpio_set;
+	tps65910_gpio->gpio_chip.get	= tps65910_gpio_get;
+	tps65910_gpio->gpio_chip.dev = &pdev->dev;
+	if (pdata && pdata->gpio_base)
+		tps65910_gpio->gpio_chip.base = pdata->gpio_base;
+	else
+		tps65910_gpio->gpio_chip.base = -1;
+
+	if (!pdata)
+		goto skip_init;
+
+	/* Configure sleep control for gpios if provided */
+	for (i = 0; i < tps65910_gpio->gpio_chip.ngpio; ++i) {
+		if (!pdata->en_gpio_sleep[i])
+			continue;
+
+		ret = tps65910_set_bits(tps65910,
+			TPS65910_GPIO0 + i, GPIO_SLEEP_MASK);
+		if (ret < 0)
+			dev_warn(tps65910->dev,
+				"GPIO Sleep setting failed with err %d\n", ret);
+	}
+
+skip_init:
+	ret = gpiochip_add(&tps65910_gpio->gpio_chip);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Could not register gpiochip, %d\n", ret);
+		return ret;
 	}
 
-	ret = gpiochip_add(&tps65910->gpio);
+	platform_set_drvdata(pdev, tps65910_gpio);
 
-	if (ret)
-		dev_warn(tps65910->dev, "GPIO registration failed: %d\n", ret);
+	return ret;
 }
+
+static int __devexit tps65910_gpio_remove(struct platform_device *pdev)
+{
+	struct tps65910_gpio *tps65910_gpio = platform_get_drvdata(pdev);
+
+	return gpiochip_remove(&tps65910_gpio->gpio_chip);
+}
+
+static struct platform_driver tps65910_gpio_driver = {
+	.driver.name    = "tps65910-gpio",
+	.driver.owner   = THIS_MODULE,
+	.probe		= tps65910_gpio_probe,
+	.remove		= __devexit_p(tps65910_gpio_remove),
+};
+
+static int __init tps65910_gpio_init(void)
+{
+	return platform_driver_register(&tps65910_gpio_driver);
+}
+subsys_initcall(tps65910_gpio_init);
+
+static void __exit tps65910_gpio_exit(void)
+{
+	platform_driver_unregister(&tps65910_gpio_driver);
+}
+module_exit(tps65910_gpio_exit);
+
+MODULE_AUTHOR("Graeme Gregory <gg@slimlogic.co.uk>");
+MODULE_AUTHOR("Jorge Eduardo Candelaria jedu@slimlogic.co.uk>");
+MODULE_DESCRIPTION("GPIO interface for TPS65910/TPS6511 PMICs");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:tps65910-gpio");
-- 
1.7.1.1

