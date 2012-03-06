Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031432Ab2CFW3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 17:29:38 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:58274 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030811Ab2CFW3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 17:29:37 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/4] pinctrl/coh901: use generic pinconf enums and parameters
Date: Tue, 6 Mar 2012 23:05:25 +0100
Message-ID: <1331071525-24699-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Adjust the COH 901 driver to use the standard enums for
biasing and driving pins, alter signature of config function
to suit the framework.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-coh901.c |   56 +++++++++-----------------------------
 1 files changed, 13 insertions(+), 43 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-coh901.c b/drivers/pinctrl/pinctrl-coh901.c
index b90c011..724234c 100644
--- a/drivers/pinctrl/pinctrl-coh901.c
+++ b/drivers/pinctrl/pinctrl-coh901.c
@@ -26,36 +26,6 @@
 #include <mach/gpio-u300.h>
 
 /*
- * Bias modes for U300 GPIOs
- *
- * GPIO_U300_CONFIG_BIAS_UNKNOWN: this bias mode is not known to us
- * GPIO_U300_CONFIG_BIAS_FLOAT: no specific bias, the GPIO will float or state
- *	is not controlled by software
- * GPIO_U300_CONFIG_BIAS_PULL_UP: the GPIO will be pulled up (usually with high
- *	impedance to VDD)
- */
-#define GPIO_U300_CONFIG_BIAS_UNKNOWN	0x1000
-#define GPIO_U300_CONFIG_BIAS_FLOAT	0x1001
-#define GPIO_U300_CONFIG_BIAS_PULL_UP	0x1002
-
-/*
- * Drive modes for U300 GPIOs (output)
- *
- * GPIO_U300_CONFIG_DRIVE_PUSH_PULL: the GPIO will be driven actively high and
- *	low, this is the most typical case and is typically achieved with two
- *	active transistors on the output
- * GPIO_U300_CONFIG_DRIVE_OPEN_DRAIN: the GPIO will be driven with open drain
- *	(open collector) which means it is usually wired with other output
- *	ports which are then pulled up with an external resistor
- * GPIO_U300_CONFIG_DRIVE_OPEN_SOURCE: the GPIO will be driven with open drain
- *	(open emitter) which is the same as open drain mutatis mutandis but
- *	pulled to ground
- */
-#define GPIO_U300_CONFIG_DRIVE_PUSH_PULL	0x2000
-#define GPIO_U300_CONFIG_DRIVE_OPEN_DRAIN	0x2001
-#define GPIO_U300_CONFIG_DRIVE_OPEN_SOURCE	0x2002
-
-/*
  * Register definitions for COH 901 335 variant
  */
 #define U300_335_PORT_STRIDE				(0x1C)
@@ -181,12 +151,12 @@ struct u300_gpio_confdata {
 #define BS365_GPIO_NUM_PORTS 5
 
 #define U300_FLOATING_INPUT { \
-	.bias_mode = GPIO_U300_CONFIG_BIAS_FLOAT, \
+	.bias_mode = PIN_CONFIG_BIAS_HIGH_IMPEDANCE, \
 	.output = false, \
 }
 
 #define U300_PULL_UP_INPUT { \
-	.bias_mode = GPIO_U300_CONFIG_BIAS_PULL_UP, \
+	.bias_mode = PIN_CONFIG_BIAS_PULL_UP, \
 	.output = false, \
 }
 
@@ -449,7 +419,7 @@ static int u300_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 }
 
 static int u300_gpio_config(struct gpio_chip *chip, unsigned offset,
-		     u16 param, unsigned long *data)
+			    enum pin_config_param param, unsigned long data)
 {
 	struct u300_gpio *gpio = to_u300_gpio(chip);
 	unsigned long flags;
@@ -457,16 +427,16 @@ static int u300_gpio_config(struct gpio_chip *chip, unsigned offset,
 
 	local_irq_save(flags);
 	switch (param) {
-	case GPIO_U300_CONFIG_BIAS_UNKNOWN:
-	case GPIO_U300_CONFIG_BIAS_FLOAT:
+	case PIN_CONFIG_BIAS_DISABLE:
+	case PIN_CONFIG_BIAS_HIGH_IMPEDANCE:
 		val = readl(U300_PIN_REG(offset, per));
 		writel(val | U300_PIN_BIT(offset), U300_PIN_REG(offset, per));
 		break;
-	case GPIO_U300_CONFIG_BIAS_PULL_UP:
+	case PIN_CONFIG_BIAS_PULL_UP:
 		val = readl(U300_PIN_REG(offset, per));
 		writel(val & ~U300_PIN_BIT(offset), U300_PIN_REG(offset, per));
 		break;
-	case GPIO_U300_CONFIG_DRIVE_PUSH_PULL:
+	case PIN_CONFIG_DRIVE_PUSH_PULL:
 		val = readl(U300_PIN_REG(offset, pcr));
 		val &= ~(U300_GPIO_PXPCR_PIN_MODE_MASK
 			 << ((offset & 0x07) << 1));
@@ -474,7 +444,7 @@ static int u300_gpio_config(struct gpio_chip *chip, unsigned offset,
 			<< ((offset & 0x07) << 1));
 		writel(val, U300_PIN_REG(offset, pcr));
 		break;
-	case GPIO_U300_CONFIG_DRIVE_OPEN_DRAIN:
+	case PIN_CONFIG_DRIVE_OPEN_DRAIN:
 		val = readl(U300_PIN_REG(offset, pcr));
 		val &= ~(U300_GPIO_PXPCR_PIN_MODE_MASK
 			 << ((offset & 0x07) << 1));
@@ -482,7 +452,7 @@ static int u300_gpio_config(struct gpio_chip *chip, unsigned offset,
 			<< ((offset & 0x07) << 1));
 		writel(val, U300_PIN_REG(offset, pcr));
 		break;
-	case GPIO_U300_CONFIG_DRIVE_OPEN_SOURCE:
+	case PIN_CONFIG_DRIVE_OPEN_SOURCE:
 		val = readl(U300_PIN_REG(offset, pcr));
 		val &= ~(U300_GPIO_PXPCR_PIN_MODE_MASK
 			 << ((offset & 0x07) << 1));
@@ -651,12 +621,12 @@ static void __init u300_gpio_init_pin(struct u300_gpio *gpio,
 
 		/* Deactivate bias mode for output */
 		u300_gpio_config(&gpio->chip, offset,
-				 GPIO_U300_CONFIG_BIAS_FLOAT,
-				 NULL);
+				 PIN_CONFIG_BIAS_HIGH_IMPEDANCE,
+				 0);
 
 		/* Set drive mode for output */
 		u300_gpio_config(&gpio->chip, offset,
-				 GPIO_U300_CONFIG_DRIVE_PUSH_PULL, NULL);
+				 PIN_CONFIG_DRIVE_PUSH_PULL, 0);
 
 		dev_dbg(gpio->dev, "set up pin %d as output, value: %d\n",
 			offset, conf->outval);
@@ -667,7 +637,7 @@ static void __init u300_gpio_init_pin(struct u300_gpio *gpio,
 		u300_gpio_set(&gpio->chip, offset, 0);
 
 		/* Set bias mode for input */
-		u300_gpio_config(&gpio->chip, offset, conf->bias_mode, NULL);
+		u300_gpio_config(&gpio->chip, offset, conf->bias_mode, 0);
 
 		dev_dbg(gpio->dev, "set up pin %d as input, bias: %04x\n",
 			offset, conf->bias_mode);
-- 
1.7.8

