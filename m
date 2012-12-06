Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965113Ab2LFKwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 05:52:17 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36543 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965008Ab2LFKwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 05:52:13 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: [PATCH v2 1/3] gpio: twl4030: Introduce private structure to store variables needed runtime
Date: Thu, 6 Dec 2012 11:52:05 +0100
Message-ID: <1354791127-20545-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1354791127-20545-1-git-send-email-peter.ujfalusi@ti.com>
References: <1354791127-20545-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move most of the global variables inside a private structure and allocate
it dynamically.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/gpio/gpio-twl4030.c | 82 +++++++++++++++++++++++++++------------------
 1 file changed, 50 insertions(+), 32 deletions(-)

diff --git a/drivers/gpio/gpio-twl4030.c b/drivers/gpio/gpio-twl4030.c
index 55b4fe4..c092739 100644
--- a/drivers/gpio/gpio-twl4030.c
+++ b/drivers/gpio/gpio-twl4030.c
@@ -49,11 +49,6 @@
  * There are also two LED pins used sometimes as output-only GPIOs.
  */
 
-
-static struct gpio_chip twl_gpiochip;
-static int twl4030_gpio_base;
-static int twl4030_gpio_irq_base;
-
 /* genirq interfaces are not available to modules */
 #ifdef MODULE
 #define is_module()	true
@@ -72,11 +67,20 @@ static int twl4030_gpio_irq_base;
 /* Data structures */
 static DEFINE_MUTEX(gpio_lock);
 
-/* store usage of each GPIO. - each bit represents one GPIO */
-static unsigned int gpio_usage_count;
+struct gpio_twl4030_priv {
+	struct gpio_chip gpio_chip;
+	int irq_base;
+
+	unsigned int usage_count;
+};
 
 /*----------------------------------------------------------------------*/
 
+static inline struct gpio_twl4030_priv *to_gpio_twl4030(struct gpio_chip *chip)
+{
+	return container_of(chip, struct gpio_twl4030_priv, gpio_chip);
+}
+
 /*
  * To configure TWL4030 GPIO module registers
  */
@@ -193,10 +197,6 @@ static int twl4030_get_gpio_datain(int gpio)
 	u8 base = 0;
 	int ret = 0;
 
-	if (unlikely((gpio >= TWL4030_GPIO_MAX)
-		|| !(gpio_usage_count & BIT(gpio))))
-		return -EPERM;
-
 	base = REG_GPIODATAIN1 + d_bnk;
 	ret = gpio_twl4030_read(base);
 	if (ret > 0)
@@ -209,6 +209,7 @@ static int twl4030_get_gpio_datain(int gpio)
 
 static int twl_request(struct gpio_chip *chip, unsigned offset)
 {
+	struct gpio_twl4030_priv *priv = to_gpio_twl4030(chip);
 	int status = 0;
 
 	mutex_lock(&gpio_lock);
@@ -252,7 +253,7 @@ static int twl_request(struct gpio_chip *chip, unsigned offset)
 	}
 
 	/* on first use, turn GPIO module "on" */
-	if (!gpio_usage_count) {
+	if (!priv->usage_count) {
 		struct twl4030_gpio_platform_data *pdata;
 		u8 value = MASK_GPIO_CTRL_GPIO_ON;
 
@@ -266,16 +267,18 @@ static int twl_request(struct gpio_chip *chip, unsigned offset)
 		status = gpio_twl4030_write(REG_GPIO_CTRL, value);
 	}
 
+done:
 	if (!status)
-		gpio_usage_count |= (0x1 << offset);
+		priv->usage_count |= BIT(offset);
 
-done:
 	mutex_unlock(&gpio_lock);
 	return status;
 }
 
 static void twl_free(struct gpio_chip *chip, unsigned offset)
 {
+	struct gpio_twl4030_priv *priv = to_gpio_twl4030(chip);
+
 	if (offset >= TWL4030_GPIO_MAX) {
 		twl4030_led_set_value(offset - TWL4030_GPIO_MAX, 1);
 		return;
@@ -283,10 +286,10 @@ static void twl_free(struct gpio_chip *chip, unsigned offset)
 
 	mutex_lock(&gpio_lock);
 
-	gpio_usage_count &= ~BIT(offset);
+	priv->usage_count &= ~BIT(offset);
 
 	/* on last use, switch off GPIO module */
-	if (!gpio_usage_count)
+	if (!priv->usage_count)
 		gpio_twl4030_write(REG_GPIO_CTRL, 0x0);
 
 	mutex_unlock(&gpio_lock);
@@ -301,14 +304,19 @@ static int twl_direction_in(struct gpio_chip *chip, unsigned offset)
 
 static int twl_get(struct gpio_chip *chip, unsigned offset)
 {
+	struct gpio_twl4030_priv *priv = to_gpio_twl4030(chip);
 	int status = 0;
 
+	if (!(priv->usage_count & BIT(offset)))
+		return -EPERM;
+
 	if (offset < TWL4030_GPIO_MAX)
 		status = twl4030_get_gpio_datain(offset);
 	else if (offset == TWL4030_GPIO_MAX)
 		status = cached_leden & LEDEN_LEDAON;
 	else
 		status = cached_leden & LEDEN_LEDBON;
+
 	return (status < 0) ? 0 : status;
 }
 
@@ -333,12 +341,14 @@ static void twl_set(struct gpio_chip *chip, unsigned offset, int value)
 
 static int twl_to_irq(struct gpio_chip *chip, unsigned offset)
 {
-	return (twl4030_gpio_irq_base && (offset < TWL4030_GPIO_MAX))
-		? (twl4030_gpio_irq_base + offset)
+	struct gpio_twl4030_priv *priv = to_gpio_twl4030(chip);
+
+	return (priv->irq_base && (offset < TWL4030_GPIO_MAX))
+		? (priv->irq_base + offset)
 		: -EINVAL;
 }
 
-static struct gpio_chip twl_gpiochip = {
+static struct gpio_chip template_chip = {
 	.label			= "twl4030",
 	.owner			= THIS_MODULE,
 	.request		= twl_request,
@@ -424,8 +434,14 @@ static int __devinit gpio_twl4030_probe(struct platform_device *pdev)
 {
 	struct twl4030_gpio_platform_data *pdata = pdev->dev.platform_data;
 	struct device_node *node = pdev->dev.of_node;
+	struct gpio_twl4030_priv *priv;
 	int ret, irq_base;
 
+	priv = devm_kzalloc(&pdev->dev, sizeof(struct gpio_twl4030_priv),
+			    GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
 	/* maybe setup IRQs */
 	if (is_module()) {
 		dev_err(&pdev->dev, "can't dispatch IRQs from modules\n");
@@ -445,12 +461,13 @@ static int __devinit gpio_twl4030_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
-	twl4030_gpio_irq_base = irq_base;
+	priv->irq_base = irq_base;
 
 no_irqs:
-	twl_gpiochip.base = -1;
-	twl_gpiochip.ngpio = TWL4030_GPIO_MAX;
-	twl_gpiochip.dev = &pdev->dev;
+	priv->gpio_chip = template_chip;
+	priv->gpio_chip.base = -1;
+	priv->gpio_chip.ngpio = TWL4030_GPIO_MAX;
+	priv->gpio_chip.dev = &pdev->dev;
 
 	if (node)
 		pdata = of_gpio_twl4030(&pdev->dev);
@@ -481,23 +498,23 @@ no_irqs:
 	 * is (still) clear if use_leds is set.
 	 */
 	if (pdata->use_leds)
-		twl_gpiochip.ngpio += 2;
+		priv->gpio_chip.ngpio += 2;
 
-	ret = gpiochip_add(&twl_gpiochip);
+	ret = gpiochip_add(&priv->gpio_chip);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "could not register gpiochip, %d\n", ret);
-		twl_gpiochip.ngpio = 0;
+		priv->gpio_chip.ngpio = 0;
 		gpio_twl4030_remove(pdev);
 		goto out;
 	}
 
-	twl4030_gpio_base = twl_gpiochip.base;
+	platform_set_drvdata(pdev, priv);
 
 	if (pdata && pdata->setup) {
 		int status;
 
-		status = pdata->setup(&pdev->dev,
-				twl4030_gpio_base, TWL4030_GPIO_MAX);
+		status = pdata->setup(&pdev->dev, priv->gpio_chip.base,
+				      TWL4030_GPIO_MAX);
 		if (status)
 			dev_dbg(&pdev->dev, "setup --> %d\n", status);
 	}
@@ -510,18 +527,19 @@ out:
 static int gpio_twl4030_remove(struct platform_device *pdev)
 {
 	struct twl4030_gpio_platform_data *pdata = pdev->dev.platform_data;
+	struct gpio_twl4030_priv *priv = platform_get_drvdata(pdev);
 	int status;
 
 	if (pdata && pdata->teardown) {
-		status = pdata->teardown(&pdev->dev,
-				twl4030_gpio_base, TWL4030_GPIO_MAX);
+		status = pdata->teardown(&pdev->dev, priv->gpio_chip.base,
+					 TWL4030_GPIO_MAX);
 		if (status) {
 			dev_dbg(&pdev->dev, "teardown --> %d\n", status);
 			return status;
 		}
 	}
 
-	status = gpiochip_remove(&twl_gpiochip);
+	status = gpiochip_remove(&priv->gpio_chip);
 	if (status < 0)
 		return status;
 
-- 
1.8.0

