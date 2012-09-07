Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760520Ab2IGLP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 07:15:56 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50655 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760457Ab2IGLPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 07:15:42 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 19/19] gpio: Enable the tc3298x GPIO expander driver for Device Tree
Date: Fri,  7 Sep 2012 12:14:59 +0100
Message-Id: <1347016499-29354-20-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we provide a means to probe and extract vital information
from Device Tree when booting with it enabled. Without this
patch sub-devices wouldn't be able to reference the tc3589x-gpio
expander from Device Tree.

CC: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/gpio/gpio-tc3589x.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/gpio/gpio-tc3589x.c b/drivers/gpio/gpio-tc3589x.c
index 6e89009..1e48317 100644
--- a/drivers/gpio/gpio-tc3589x.c
+++ b/drivers/gpio/gpio-tc3589x.c
@@ -11,6 +11,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/gpio.h>
+#include <linux/of.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
 #include <linux/interrupt.h>
@@ -286,7 +287,8 @@ static struct irq_domain_ops tc3589x_irq_ops = {
         .xlate  = irq_domain_xlate_twocell,
 };
 
-static int tc3589x_gpio_irq_init(struct tc3589x_gpio *tc3589x_gpio)
+static int tc3589x_gpio_irq_init(struct tc3589x_gpio *tc3589x_gpio,
+				struct device_node *np)
 {
 	int base = tc3589x_gpio->irq_base;
 
@@ -297,7 +299,7 @@ static int tc3589x_gpio_irq_init(struct tc3589x_gpio *tc3589x_gpio)
 	}
 	else {
 		tc3589x_gpio->domain = irq_domain_add_linear(
-			NULL, tc3589x_gpio->chip.ngpio,
+			np, tc3589x_gpio->chip.ngpio,
 			&tc3589x_irq_ops, tc3589x_gpio);
 	}
 
@@ -313,13 +315,17 @@ static int __devinit tc3589x_gpio_probe(struct platform_device *pdev)
 {
 	struct tc3589x *tc3589x = dev_get_drvdata(pdev->dev.parent);
 	struct tc3589x_gpio_platform_data *pdata;
+	struct device_node *np = pdev->dev.of_node;
 	struct tc3589x_gpio *tc3589x_gpio;
 	int ret;
 	int irq;
 
 	pdata = tc3589x->pdata->gpio;
-	if (!pdata)
-		return -ENODEV;
+
+	if (!(pdata || np)) {
+		dev_err(&pdev->dev, "No platform data or Device Tree found\n");
+		return -EINVAL;
+	}
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
@@ -337,9 +343,11 @@ static int __devinit tc3589x_gpio_probe(struct platform_device *pdev)
 	tc3589x_gpio->chip = template_chip;
 	tc3589x_gpio->chip.ngpio = tc3589x->num_gpio;
 	tc3589x_gpio->chip.dev = &pdev->dev;
-	tc3589x_gpio->chip.base = pdata->gpio_base;
+	tc3589x_gpio->chip.base = (pdata) ? pdata->gpio_base : -1;
 
-	tc3589x_gpio->irq_base = tc3589x->irq_base + TC3589x_INT_GPIO(0);
+#ifdef CONFIG_OF_GPIO
+        tc3589x_gpio->chip.of_node = np;
+#endif
 
 	tc3589x_gpio->irq_base = tc3589x->irq_base ?
 		tc3589x->irq_base + TC3589x_INT_GPIO(0) : 0;
@@ -350,7 +358,7 @@ static int __devinit tc3589x_gpio_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto out_free;
 
-	ret = tc3589x_gpio_irq_init(tc3589x_gpio);
+	ret = tc3589x_gpio_irq_init(tc3589x_gpio, np);
 	if (ret)
 		goto out_free;
 
@@ -367,7 +375,7 @@ static int __devinit tc3589x_gpio_probe(struct platform_device *pdev)
 		goto out_freeirq;
 	}
 
-	if (pdata->setup)
+	if (pdata && pdata->setup)
 		pdata->setup(tc3589x, tc3589x_gpio->chip.base);
 
 	platform_set_drvdata(pdev, tc3589x_gpio);
@@ -389,7 +397,7 @@ static int __devexit tc3589x_gpio_remove(struct platform_device *pdev)
 	int irq = platform_get_irq(pdev, 0);
 	int ret;
 
-	if (pdata->remove)
+	if (pdata && pdata->remove)
 		pdata->remove(tc3589x, tc3589x_gpio->chip.base);
 
 	ret = gpiochip_remove(&tc3589x_gpio->chip);
-- 
1.7.9.5

