Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab2LNQU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:20:56 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:48910 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab2LNQUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:20:19 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Yang QU <yang.qu@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 20/21] gpio: ab8500: Fix ab8540 setting direction output error
Date: Fri, 14 Dec 2012 16:19:38 +0000
Message-Id: <1355501979-1157-21-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
References: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang QU <yang.qu@stericsson.com>

Set GpioPullUpDownSel register for direction output function as GPIO51
to GPIO54 not share the same register with other GPIOs on AB8540.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Yang QU <yang.qu@stericsson.com>
Reviewed-by: Patrick DELAUNAY <patrick.delaunay@stericsson.com>
Reviewed-by: Xiao Mei ZHANG <xiaomei.zhang@stericsson.com>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
Reviewed-by: Maxime COQUELIN <maxime.coquelin@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Reviewed-by: Mattias WALLIN <mattias.wallin@stericsson.com>
---
 drivers/gpio/gpio-ab8500.c |   33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/gpio-ab8500.c b/drivers/gpio/gpio-ab8500.c
index edc3037..ed5832e 100644
--- a/drivers/gpio/gpio-ab8500.c
+++ b/drivers/gpio/gpio-ab8500.c
@@ -86,6 +86,8 @@
 #define AB8500_NUM_VIR_GPIO_IRQ	16
 #define AB8540_GPIO_PULL_UPDOWN_MASK	0x03
 #define AB8540_GPIO_VINSEL_MASK	0x03
+#define AB8540_GPIOX_VBAT_START	51
+#define AB8540_GPIOX_VBAT_END	54
 
 enum ab8500_gpio_action {
 	NONE,
@@ -222,6 +224,7 @@ static void ab8500_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
 static int ab8500_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
 					int val)
 {
+	struct ab8500_gpio *ab8500_gpio = to_ab8500_gpio(chip);
 	int ret;
 	/* set direction as output */
 	ret = ab8500_gpio_set_bits(chip, AB8500_GPIO_DIR1_REG, offset, 1);
@@ -231,6 +234,18 @@ static int ab8500_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
 	ret = ab8500_gpio_set_bits(chip, AB8500_GPIO_PUD1_REG, offset, 1);
 	if (ret < 0)
 		return ret;
+	/*
+	 * Disable both pull down and pull up for GPIO51 to GPIO54 (GPIO1_VBAT
+	 * to GPIO4_VBAT).
+	 */
+	if (is_ab8540(ab8500_gpio->parent)) {
+		if (offset >= (AB8540_GPIOX_VBAT_START - 1)
+			&& offset <= (AB8540_GPIOX_VBAT_END - 1))
+			ret = ab8540_config_pull_updown(ab8500_gpio->dev,
+				AB8500_PIN_GPIO(offset + 1), AB8540_GPIO_PULL_NONE);
+		if (ret < 0)
+			return ret;
+	}
 	/* set the output as 1 or 0 */
 	return ab8500_gpio_set_bits(chip, AB8500_GPIO_OUT1_REG, offset, val);
 
@@ -278,10 +293,10 @@ static unsigned int irq_to_rising(unsigned int irq)
 	int offset = irq - ab8500_gpio->irq_base;
 	int new_irq;
 	if (is_ab8540(ab8500_gpio->parent)) {
-		new_irq = offset * 2 +  AB8540_INT_GPIO43R
+		new_irq = offset * 2 + AB8540_INT_GPIO43R
 			+ ab8500_gpio->parent->irq_base;
 	} else
-		new_irq = offset +  AB8500_INT_GPIO6R
+		new_irq = offset + AB8500_INT_GPIO6R
 			+ ab8500_gpio->parent->irq_base;
 	return new_irq;
 }
@@ -292,10 +307,10 @@ static unsigned int irq_to_falling(unsigned int irq)
 	int offset = irq - ab8500_gpio->irq_base;
 	int new_irq;
 	if (is_ab8540(ab8500_gpio->parent)) {
-		new_irq = offset * 2 +  AB8540_INT_GPIO43F
+		new_irq = offset * 2 + AB8540_INT_GPIO43F
 			+ ab8500_gpio->parent->irq_base;
 	} else
-		new_irq = offset +  AB8500_INT_GPIO6F
+		new_irq = offset + AB8500_INT_GPIO6F
 			+ ab8500_gpio->parent->irq_base;
 	return new_irq;
 
@@ -670,12 +685,13 @@ int ab8540_config_pull_updown(struct device *dev,
 	u8 pos;
 	int ret;
 
-	if ((gpio < AB8500_PIN_GPIO(51)) || (gpio > AB8500_PIN_GPIO(54))) {
+	if ((gpio < AB8500_PIN_GPIO(AB8540_GPIOX_VBAT_START))
+		|| (gpio > AB8500_PIN_GPIO(AB8540_GPIOX_VBAT_END))) {
 		ret = -EINVAL;
 		goto out;
 	}
 
-	pos = (gpio - AB8500_PIN_GPIO(51)) << 1;
+	pos = (gpio - AB8500_PIN_GPIO(AB8540_GPIOX_VBAT_START)) << 1;
 
 	ret = abx500_mask_and_set_register_interruptible(dev,
 			AB8500_MISC, AB8540_GPIO_PULL_UPDOWN_REG,
@@ -694,12 +710,13 @@ int ab8540_gpio_config_vinsel(struct device *dev,
 	u8 pos;
 	int ret;
 
-	if ((gpio < AB8500_PIN_GPIO(51)) || (gpio > AB8500_PIN_GPIO(54))) {
+	if ((gpio < AB8500_PIN_GPIO(AB8540_GPIOX_VBAT_START))
+		|| (gpio > AB8500_PIN_GPIO(AB8540_GPIOX_VBAT_END))) {
 		ret = -EINVAL;
 		goto out;
 	}
 
-	pos = (gpio - AB8500_PIN_GPIO(51)) << 1;
+	pos = (gpio - AB8500_PIN_GPIO(AB8540_GPIOX_VBAT_START)) << 1;
 
 	ret = abx500_mask_and_set_register_interruptible(dev,
 			AB8500_MISC, AB8540_GPIO_VINSEL_REG,
-- 
1.7.9.5

