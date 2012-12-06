Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965129Ab2LFKwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 05:52:19 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36545 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965096Ab2LFKwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 05:52:14 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: [PATCH v2 2/3] gpio: twl4030: Cache the direction and output states in private data
Date: Thu, 6 Dec 2012 11:52:06 +0100
Message-ID: <1354791127-20545-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1354791127-20545-1-git-send-email-peter.ujfalusi@ti.com>
References: <1354791127-20545-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more coherent locking in the driver. Use bitfield to store the GPIO
direction and if the pin is configured as output store the status also in a
bitfiled.
In this way we can just look at these bitfields when we need information
about the pin status and only reach out to the chip when it is needed.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/gpio/gpio-twl4030.c | 99 ++++++++++++++++++++++++++++++---------------
 1 file changed, 66 insertions(+), 33 deletions(-)

diff --git a/drivers/gpio/gpio-twl4030.c b/drivers/gpio/gpio-twl4030.c
index c092739..a38e6e9c 100644
--- a/drivers/gpio/gpio-twl4030.c
+++ b/drivers/gpio/gpio-twl4030.c
@@ -64,14 +64,15 @@
 /* Mask for GPIO registers when aggregated into a 32-bit integer */
 #define GPIO_32_MASK			0x0003ffff
 
-/* Data structures */
-static DEFINE_MUTEX(gpio_lock);
-
 struct gpio_twl4030_priv {
 	struct gpio_chip gpio_chip;
+	struct mutex mutex;
 	int irq_base;
 
+	/* Bitfields for state caching */
 	unsigned int usage_count;
+	unsigned int direction;
+	unsigned int out_state;
 };
 
 /*----------------------------------------------------------------------*/
@@ -130,7 +131,7 @@ static inline int gpio_twl4030_read(u8 address)
 
 /*----------------------------------------------------------------------*/
 
-static u8 cached_leden;		/* protected by gpio_lock */
+static u8 cached_leden;
 
 /* The LED lines are open drain outputs ... a FET pulls to GND, so an
  * external pullup is needed.  We could also expose the integrated PWM
@@ -144,14 +145,12 @@ static void twl4030_led_set_value(int led, int value)
 	if (led)
 		mask <<= 1;
 
-	mutex_lock(&gpio_lock);
 	if (value)
 		cached_leden &= ~mask;
 	else
 		cached_leden |= mask;
 	status = twl_i2c_write_u8(TWL4030_MODULE_LED, cached_leden,
 				  TWL4030_LED_LEDEN_REG);
-	mutex_unlock(&gpio_lock);
 }
 
 static int twl4030_set_gpio_direction(int gpio, int is_input)
@@ -162,7 +161,6 @@ static int twl4030_set_gpio_direction(int gpio, int is_input)
 	u8 base = REG_GPIODATADIR1 + d_bnk;
 	int ret = 0;
 
-	mutex_lock(&gpio_lock);
 	ret = gpio_twl4030_read(base);
 	if (ret >= 0) {
 		if (is_input)
@@ -172,7 +170,6 @@ static int twl4030_set_gpio_direction(int gpio, int is_input)
 
 		ret = gpio_twl4030_write(base, reg);
 	}
-	mutex_unlock(&gpio_lock);
 	return ret;
 }
 
@@ -212,7 +209,7 @@ static int twl_request(struct gpio_chip *chip, unsigned offset)
 	struct gpio_twl4030_priv *priv = to_gpio_twl4030(chip);
 	int status = 0;
 
-	mutex_lock(&gpio_lock);
+	mutex_lock(&priv->mutex);
 
 	/* Support the two LED outputs as output-only GPIOs. */
 	if (offset >= TWL4030_GPIO_MAX) {
@@ -271,7 +268,7 @@ done:
 	if (!status)
 		priv->usage_count |= BIT(offset);
 
-	mutex_unlock(&gpio_lock);
+	mutex_unlock(&priv->mutex);
 	return status;
 }
 
@@ -279,64 +276,98 @@ static void twl_free(struct gpio_chip *chip, unsigned offset)
 {
 	struct gpio_twl4030_priv *priv = to_gpio_twl4030(chip);
 
+	mutex_lock(&priv->mutex);
 	if (offset >= TWL4030_GPIO_MAX) {
 		twl4030_led_set_value(offset - TWL4030_GPIO_MAX, 1);
 		return;
 	}
 
-	mutex_lock(&gpio_lock);
-
 	priv->usage_count &= ~BIT(offset);
 
 	/* on last use, switch off GPIO module */
 	if (!priv->usage_count)
 		gpio_twl4030_write(REG_GPIO_CTRL, 0x0);
 
-	mutex_unlock(&gpio_lock);
+	mutex_unlock(&priv->mutex);
 }
 
 static int twl_direction_in(struct gpio_chip *chip, unsigned offset)
 {
-	return (offset < TWL4030_GPIO_MAX)
-		? twl4030_set_gpio_direction(offset, 1)
-		: -EINVAL;
+	struct gpio_twl4030_priv *priv = to_gpio_twl4030(chip);
+	int ret;
+
+	mutex_lock(&priv->mutex);
+	if (offset < TWL4030_GPIO_MAX)
+		ret = twl4030_set_gpio_direction(offset, 1);
+	else
+		ret = -EINVAL;
+
+	if (!ret)
+		priv->direction &= ~BIT(offset);
+
+	mutex_unlock(&priv->mutex);
+
+	return ret;
 }
 
 static int twl_get(struct gpio_chip *chip, unsigned offset)
 {
 	struct gpio_twl4030_priv *priv = to_gpio_twl4030(chip);
+	int ret;
 	int status = 0;
 
-	if (!(priv->usage_count & BIT(offset)))
-		return -EPERM;
+	mutex_lock(&priv->mutex);
+	if (!(priv->usage_count & BIT(offset))) {
+		ret = -EPERM;
+		goto out;
+	}
 
-	if (offset < TWL4030_GPIO_MAX)
-		status = twl4030_get_gpio_datain(offset);
-	else if (offset == TWL4030_GPIO_MAX)
-		status = cached_leden & LEDEN_LEDAON;
+	if (priv->direction & BIT(offset))
+		status = priv->out_state & BIT(offset);
 	else
-		status = cached_leden & LEDEN_LEDBON;
+		status = twl4030_get_gpio_datain(offset);
 
-	return (status < 0) ? 0 : status;
+	ret = (status <= 0) ? 0 : 1;
+out:
+	mutex_unlock(&priv->mutex);
+	dev_err(chip->dev, "%s: offset %d value %d\n", __func__, offset, ret);
+	return ret;
 }
 
-static int twl_direction_out(struct gpio_chip *chip, unsigned offset, int value)
+static void twl_set(struct gpio_chip *chip, unsigned offset, int value)
 {
-	if (offset < TWL4030_GPIO_MAX) {
+	struct gpio_twl4030_priv *priv = to_gpio_twl4030(chip);
+
+	dev_err(chip->dev, "%s: offset %d value %d\n", __func__, offset, value);
+	mutex_lock(&priv->mutex);
+	if (offset < TWL4030_GPIO_MAX)
 		twl4030_set_gpio_dataout(offset, value);
-		return twl4030_set_gpio_direction(offset, 0);
-	} else {
+	else
 		twl4030_led_set_value(offset - TWL4030_GPIO_MAX, value);
-		return 0;
-	}
+
+	if (value)
+		priv->out_state |= BIT(offset);
+	else
+		priv->out_state &= ~BIT(offset);
+
+	mutex_unlock(&priv->mutex);
 }
 
-static void twl_set(struct gpio_chip *chip, unsigned offset, int value)
+static int twl_direction_out(struct gpio_chip *chip, unsigned offset, int value)
 {
+	struct gpio_twl4030_priv *priv = to_gpio_twl4030(chip);
+
+	dev_err(chip->dev, "%s: offset %d value %d\n", __func__, offset, value);
+	mutex_lock(&priv->mutex);
 	if (offset < TWL4030_GPIO_MAX)
 		twl4030_set_gpio_dataout(offset, value);
-	else
-		twl4030_led_set_value(offset - TWL4030_GPIO_MAX, value);
+
+	priv->direction |= BIT(offset);
+	mutex_unlock(&priv->mutex);
+
+	twl_set(chip, offset, value);
+
+	return 0;
 }
 
 static int twl_to_irq(struct gpio_chip *chip, unsigned offset)
@@ -469,6 +500,8 @@ no_irqs:
 	priv->gpio_chip.ngpio = TWL4030_GPIO_MAX;
 	priv->gpio_chip.dev = &pdev->dev;
 
+	mutex_init(&priv->mutex);
+
 	if (node)
 		pdata = of_gpio_twl4030(&pdev->dev);
 
-- 
1.8.0

