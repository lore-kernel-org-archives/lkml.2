Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab1EPXfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 19:35:51 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:34393 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab1EPXfs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 19:35:48 -0400
From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCHv4 5/6] TPS65911: Add support for added GPIO lines
Date: Mon, 16 May 2011 18:35:42 -0500
Message-Id: <9C4A98CC-5D10-444E-92EB-2E210B86407B@slimlogic.co.uk>
Cc: broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        grant.likely@secretlab.ca
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPIO 1 to 8 are added for TPS65911 chip version. The gpio driver
now handles more than one gpio lines. Subsequent versions of the
chip family can add new GPIO lines with minimal driver changes.

Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
---
 drivers/gpio/tps65910-gpio.c |   29 +++++++++-----
 include/linux/mfd/tps65910.h |   90 ++++++-----------------------------------
 2 files changed, 33 insertions(+), 86 deletions(-)

diff --git a/drivers/gpio/tps65910-gpio.c b/drivers/gpio/tps65910-gpio.c
index f3ae376..8d1ddfd 100644
--- a/drivers/gpio/tps65910-gpio.c
+++ b/drivers/gpio/tps65910-gpio.c
@@ -25,9 +25,9 @@ static int tps65910_gpio_get(struct gpio_chip *gc, unsigned offset)
 	struct tps65910 *tps65910 = container_of(gc, struct tps65910, gpio);
 	uint8_t val;
 
-	tps65910->read(tps65910, TPS65910_GPIO0, 1, &val);
+	tps65910->read(tps65910, TPS65910_GPIO0 + offset, 1, &val);
 
-	if (val & GPIO0_GPIO_STS_MASK)
+	if (val & GPIO_STS_MASK)
 		return 1;
 
 	return 0;
@@ -39,11 +39,11 @@ static void tps65910_gpio_set(struct gpio_chip *gc, unsigned offset,
 	struct tps65910 *tps65910 = container_of(gc, struct tps65910, gpio);
 
 	if (value)
-		tps65910_set_bits(tps65910, TPS65910_GPIO0,
-					GPIO0_GPIO_SET_MASK);
+		tps65910_set_bits(tps65910, TPS65910_GPIO0 + offset,
+						GPIO_SET_MASK);
 	else
-		tps65910_clear_bits(tps65910, TPS65910_GPIO0,
-					GPIO0_GPIO_SET_MASK);
+		tps65910_clear_bits(tps65910, TPS65910_GPIO0 + offset,
+						GPIO_SET_MASK);
 }
 
 static int tps65910_gpio_output(struct gpio_chip *gc, unsigned offset,
@@ -54,15 +54,16 @@ static int tps65910_gpio_output(struct gpio_chip *gc, unsigned offset,
 	/* Set the initial value */
 	tps65910_gpio_set(gc, 0, value);
 
-	return tps65910_set_bits(tps65910, TPS65910_GPIO0, GPIO0_GPIO_CFG_MASK);
+	return tps65910_set_bits(tps65910, TPS65910_GPIO0 + offset,
+						GPIO_CFG_MASK);
 }
 
 static int tps65910_gpio_input(struct gpio_chip *gc, unsigned offset)
 {
 	struct tps65910 *tps65910 = container_of(gc, struct tps65910, gpio);
 
-	return tps65910_clear_bits(tps65910, TPS65910_GPIO0,
-					GPIO0_GPIO_CFG_MASK);
+	return tps65910_clear_bits(tps65910, TPS65910_GPIO0 + offset,
+						GPIO_CFG_MASK);
 }
 
 void tps65910_gpio_init(struct tps65910 *tps65910, int gpio_base)
@@ -76,7 +77,15 @@ void tps65910_gpio_init(struct tps65910 *tps65910, int gpio_base)
 	tps65910->gpio.label		= tps65910->i2c_client->name;
 	tps65910->gpio.dev		= tps65910->dev;
 	tps65910->gpio.base		= gpio_base;
-	tps65910->gpio.ngpio		= 1;
+
+	switch(tps65910_chip_id(tps65910)) {
+	case TPS65910:
+		tps65910->gpio.ngpio	= 6;
+	case TPS65911:
+		tps65910->gpio.ngpio	= 9;
+	default:
+		return;
+	}
 	tps65910->gpio.can_sleep	= 1;
 
 	tps65910->gpio.direction_input	= tps65910_gpio_input;
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index 32bb7b8..5f77006 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -101,6 +101,9 @@
 #define TPS65910_GPIO3					0x63
 #define TPS65910_GPIO4					0x64
 #define TPS65910_GPIO5					0x65
+#define TPS65910_GPIO6					0x66
+#define TPS65910_GPIO7					0x67
+#define TPS65910_GPIO8					0x68
 #define TPS65910_JTAGVERNUM				0x80
 #define TPS65910_MAX_REGISTER				0x80
 
@@ -650,82 +653,17 @@
 #define INT_MSK3_GPIO4_R_IT_MSK_SHIFT			0
 
 
-/*Register GPIO0  (0x80) register.RegisterDescription */
-#define GPIO0_GPIO_DEB_MASK				0x10
-#define GPIO0_GPIO_DEB_SHIFT				4
-#define GPIO0_GPIO_PUEN_MASK				0x08
-#define GPIO0_GPIO_PUEN_SHIFT				3
-#define GPIO0_GPIO_CFG_MASK				0x04
-#define GPIO0_GPIO_CFG_SHIFT				2
-#define GPIO0_GPIO_STS_MASK				0x02
-#define GPIO0_GPIO_STS_SHIFT				1
-#define GPIO0_GPIO_SET_MASK				0x01
-#define GPIO0_GPIO_SET_SHIFT				0
-
-
-/*Register GPIO1  (0x80) register.RegisterDescription */
-#define GPIO1_GPIO_DEB_MASK				0x10
-#define GPIO1_GPIO_DEB_SHIFT				4
-#define GPIO1_GPIO_PUEN_MASK				0x08
-#define GPIO1_GPIO_PUEN_SHIFT				3
-#define GPIO1_GPIO_CFG_MASK				0x04
-#define GPIO1_GPIO_CFG_SHIFT				2
-#define GPIO1_GPIO_STS_MASK				0x02
-#define GPIO1_GPIO_STS_SHIFT				1
-#define GPIO1_GPIO_SET_MASK				0x01
-#define GPIO1_GPIO_SET_SHIFT				0
-
-
-/*Register GPIO2  (0x80) register.RegisterDescription */
-#define GPIO2_GPIO_DEB_MASK				0x10
-#define GPIO2_GPIO_DEB_SHIFT				4
-#define GPIO2_GPIO_PUEN_MASK			 	0x08
-#define GPIO2_GPIO_PUEN_SHIFT				3
-#define GPIO2_GPIO_CFG_MASK				0x04
-#define GPIO2_GPIO_CFG_SHIFT				2
-#define GPIO2_GPIO_STS_MASK				0x02
-#define GPIO2_GPIO_STS_SHIFT				1
-#define GPIO2_GPIO_SET_MASK				0x01
-#define GPIO2_GPIO_SET_SHIFT				0
-
-
-/*Register GPIO3  (0x80) register.RegisterDescription */
-#define GPIO3_GPIO_DEB_MASK				0x10
-#define GPIO3_GPIO_DEB_SHIFT				4
-#define GPIO3_GPIO_PUEN_MASK				0x08
-#define GPIO3_GPIO_PUEN_SHIFT				3
-#define GPIO3_GPIO_CFG_MASK				0x04
-#define GPIO3_GPIO_CFG_SHIFT				2
-#define GPIO3_GPIO_STS_MASK			 	0x02
-#define GPIO3_GPIO_STS_SHIFT				1
-#define GPIO3_GPIO_SET_MASK				0x01
-#define GPIO3_GPIO_SET_SHIFT				0
-
-
-/*Register GPIO4  (0x80) register.RegisterDescription */
-#define GPIO4_GPIO_DEB_MASK				0x10
-#define GPIO4_GPIO_DEB_SHIFT				4
-#define GPIO4_GPIO_PUEN_MASK				0x08
-#define GPIO4_GPIO_PUEN_SHIFT				3
-#define GPIO4_GPIO_CFG_MASK				0x04
-#define GPIO4_GPIO_CFG_SHIFT				2
-#define GPIO4_GPIO_STS_MASK				0x02
-#define GPIO4_GPIO_STS_SHIFT				1
-#define GPIO4_GPIO_SET_MASK				0x01
-#define GPIO4_GPIO_SET_SHIFT				0
-
-
-/*Register GPIO5  (0x80) register.RegisterDescription */
-#define GPIO5_GPIO_DEB_MASK				0x10
-#define GPIO5_GPIO_DEB_SHIFT				4
-#define GPIO5_GPIO_PUEN_MASK				0x08
-#define GPIO5_GPIO_PUEN_SHIFT				3
-#define GPIO5_GPIO_CFG_MASK				0x04
-#define GPIO5_GPIO_CFG_SHIFT				2
-#define GPIO5_GPIO_STS_MASK				0x02
-#define GPIO5_GPIO_STS_SHIFT				1
-#define GPIO5_GPIO_SET_MASK				0x01
-#define GPIO5_GPIO_SET_SHIFT				0
+/*Register GPIO  (0x80) register.RegisterDescription */
+#define GPIO_DEB_MASK                           0x10
+#define GPIO_DEB_SHIFT                          4
+#define GPIO_PUEN_MASK                          0x08
+#define GPIO_PUEN_SHIFT                         3
+#define GPIO_CFG_MASK                           0x04
+#define GPIO_CFG_SHIFT                          2
+#define GPIO_STS_MASK                           0x02
+#define GPIO_STS_SHIFT                          1
+#define GPIO_SET_MASK                           0x01
+#define GPIO_SET_SHIFT                          0
 
 
 /*Register JTAGVERNUM  (0x80) register.RegisterDescription */
-- 
1.7.1

