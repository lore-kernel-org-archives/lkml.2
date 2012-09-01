Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab2IAJod (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 05:44:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54204 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab2IAJoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 05:44:32 -0400
Message-ID: <1346492667.10234.3.camel@phoenix>
Subject: [PATCH] gpio: tps65912: Convert to use devm_kzalloc API
From: Axel Lin <axel.lin@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Margarita Olaya <magi@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Date: Sat, 01 Sep 2012 17:44:27 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/gpio-tps65912.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/gpio/gpio-tps65912.c b/drivers/gpio/gpio-tps65912.c
index 79e66c0..99106d1 100644
--- a/drivers/gpio/gpio-tps65912.c
+++ b/drivers/gpio/gpio-tps65912.c
@@ -70,7 +70,6 @@ static int tps65912_gpio_input(struct gpio_chip *gc, unsigned offset)
 
 	return tps65912_clear_bits(tps65912, TPS65912_GPIO1 + offset,
 								GPIO_CFG_MASK);
-
 }
 
 static struct gpio_chip template_chip = {
@@ -92,7 +91,8 @@ static int __devinit tps65912_gpio_probe(struct platform_device *pdev)
 	struct tps65912_gpio_data *tps65912_gpio;
 	int ret;
 
-	tps65912_gpio = kzalloc(sizeof(*tps65912_gpio), GFP_KERNEL);
+	tps65912_gpio = devm_kzalloc(&pdev->dev, sizeof(*tps65912_gpio),
+				     GFP_KERNEL);
 	if (tps65912_gpio == NULL)
 		return -ENOMEM;
 
@@ -105,28 +105,19 @@ static int __devinit tps65912_gpio_probe(struct platform_device *pdev)
 	ret = gpiochip_add(&tps65912_gpio->gpio_chip);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to register gpiochip, %d\n", ret);
-		goto err;
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, tps65912_gpio);
 
 	return ret;
-
-err:
-	kfree(tps65912_gpio);
-	return ret;
 }
 
 static int __devexit tps65912_gpio_remove(struct platform_device *pdev)
 {
 	struct tps65912_gpio_data  *tps65912_gpio = platform_get_drvdata(pdev);
-	int ret;
-
-	ret = gpiochip_remove(&tps65912_gpio->gpio_chip);
-	if (ret == 0)
-		kfree(tps65912_gpio);
 
-	return ret;
+	return gpiochip_remove(&tps65912_gpio->gpio_chip);
 }
 
 static struct platform_driver tps65912_gpio_driver = {
-- 
1.7.9.5



