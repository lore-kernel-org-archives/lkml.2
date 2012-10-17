Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab2JQMkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 08:40:08 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:41931 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756862Ab2JQMhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 08:37:46 -0400
From: Roland Stigge <stigge@antcom.de>
To: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RFC 06/15 v5] gpio-lpc32xx: Add block GPIO API
Date: Wed, 17 Oct 2012 14:31:38 +0200
Message-Id: <1350477107-26512-7-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350477107-26512-1-git-send-email-stigge@antcom.de>
References: <1350477107-26512-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds block GPIO API support to the LPC32xx driver.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 drivers/gpio/gpio-lpc32xx.c |   82 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

--- linux-2.6.orig/drivers/gpio/gpio-lpc32xx.c
+++ linux-2.6/drivers/gpio/gpio-lpc32xx.c
@@ -297,6 +297,22 @@ static int lpc32xx_gpio_get_value_p3(str
 	return __get_gpio_state_p3(group, pin);
 }
 
+static unsigned long lpc32xx_gpio_get_block_p3(struct gpio_chip *chip,
+					       unsigned long mask)
+{
+	struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
+	u32 bits = __raw_readl(group->gpio_grp->inp_state);
+
+	/* In P3_INP_STATE, the 6 GPIOs are scattered over the register,
+	 * rearranging to bits 0-5
+	 */
+	bits >>= 10;
+	bits &= 0x401F;
+	bits |= (bits & 0x4000) >> 9;
+
+	return bits & mask & 0x3F;
+}
+
 static int lpc32xx_gpi_get_value(struct gpio_chip *chip, unsigned pin)
 {
 	struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
@@ -304,6 +320,15 @@ static int lpc32xx_gpi_get_value(struct
 	return __get_gpi_state_p3(group, pin);
 }
 
+static unsigned long lpc32xx_gpi_get_block(struct gpio_chip *chip,
+					   unsigned long mask)
+{
+	struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
+	u32 bits = __raw_readl(group->gpio_grp->inp_state);
+
+	return bits & mask;
+}
+
 static int lpc32xx_gpio_dir_output_p012(struct gpio_chip *chip, unsigned pin,
 	int value)
 {
@@ -351,6 +376,27 @@ static void lpc32xx_gpio_set_value_p3(st
 	__set_gpio_level_p3(group, pin, value);
 }
 
+static void lpc32xx_gpio_set_block_p3(struct gpio_chip *chip,
+				      unsigned long mask,
+				      unsigned long values)
+{
+	struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
+	u32 set_bits = values & mask;
+	u32 clr_bits = ~values & mask;
+
+	/* States of GPIO 0-5 start at bit 25 */
+	set_bits <<= 25;
+	clr_bits <<= 25;
+
+	/* Note: On LPC32xx, GPOs can only be set at once or cleared at once,
+	 *       but not set and cleared at once
+	 */
+	if (set_bits)
+		__raw_writel(set_bits, group->gpio_grp->outp_set);
+	if (clr_bits)
+		__raw_writel(clr_bits, group->gpio_grp->outp_clr);
+}
+
 static void lpc32xx_gpo_set_value(struct gpio_chip *chip, unsigned pin,
 	int value)
 {
@@ -366,6 +412,31 @@ static int lpc32xx_gpo_get_value(struct
 	return __get_gpo_state_p3(group, pin);
 }
 
+static void lpc32xx_gpo_set_block(struct gpio_chip *chip, unsigned long mask,
+				  unsigned long values)
+{
+	struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
+	u32 set_bits = values & mask;
+	u32 clr_bits = ~values & mask;
+
+	/* Note: On LPC32xx, GPOs can only be set at once or cleared at once,
+	 *       but not set and cleared at once
+	 */
+	if (set_bits)
+		__raw_writel(set_bits, group->gpio_grp->outp_set);
+	if (clr_bits)
+		__raw_writel(clr_bits, group->gpio_grp->outp_clr);
+}
+
+static unsigned long lpc32xx_gpo_get_block(struct gpio_chip *chip,
+					   unsigned long mask)
+{
+	struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
+	u32 bits = __raw_readl(group->gpio_grp->outp_state);
+
+	return bits & mask;
+}
+
 static int lpc32xx_gpio_request(struct gpio_chip *chip, unsigned pin)
 {
 	if (pin < chip->ngpio)
@@ -440,8 +511,10 @@ static struct lpc32xx_gpio_chip lpc32xx_
 			.label			= "gpio_p0",
 			.direction_input	= lpc32xx_gpio_dir_input_p012,
 			.get			= lpc32xx_gpio_get_value_p012,
+			.get_block		= lpc32xx_gpi_get_block,
 			.direction_output	= lpc32xx_gpio_dir_output_p012,
 			.set			= lpc32xx_gpio_set_value_p012,
+			.set_block		= lpc32xx_gpo_set_block,
 			.request		= lpc32xx_gpio_request,
 			.to_irq			= lpc32xx_gpio_to_irq_p01,
 			.base			= LPC32XX_GPIO_P0_GRP,
@@ -456,8 +529,10 @@ static struct lpc32xx_gpio_chip lpc32xx_
 			.label			= "gpio_p1",
 			.direction_input	= lpc32xx_gpio_dir_input_p012,
 			.get			= lpc32xx_gpio_get_value_p012,
+			.get_block		= lpc32xx_gpi_get_block,
 			.direction_output	= lpc32xx_gpio_dir_output_p012,
 			.set			= lpc32xx_gpio_set_value_p012,
+			.set_block		= lpc32xx_gpo_set_block,
 			.request		= lpc32xx_gpio_request,
 			.to_irq			= lpc32xx_gpio_to_irq_p01,
 			.base			= LPC32XX_GPIO_P1_GRP,
@@ -472,8 +547,10 @@ static struct lpc32xx_gpio_chip lpc32xx_
 			.label			= "gpio_p2",
 			.direction_input	= lpc32xx_gpio_dir_input_p012,
 			.get			= lpc32xx_gpio_get_value_p012,
+			.get_block		= lpc32xx_gpi_get_block,
 			.direction_output	= lpc32xx_gpio_dir_output_p012,
 			.set			= lpc32xx_gpio_set_value_p012,
+			.set_block		= lpc32xx_gpo_set_block,
 			.request		= lpc32xx_gpio_request,
 			.base			= LPC32XX_GPIO_P2_GRP,
 			.ngpio			= LPC32XX_GPIO_P2_MAX,
@@ -487,8 +564,10 @@ static struct lpc32xx_gpio_chip lpc32xx_
 			.label			= "gpio_p3",
 			.direction_input	= lpc32xx_gpio_dir_input_p3,
 			.get			= lpc32xx_gpio_get_value_p3,
+			.get_block		= lpc32xx_gpio_get_block_p3,
 			.direction_output	= lpc32xx_gpio_dir_output_p3,
 			.set			= lpc32xx_gpio_set_value_p3,
+			.set_block		= lpc32xx_gpio_set_block_p3,
 			.request		= lpc32xx_gpio_request,
 			.to_irq			= lpc32xx_gpio_to_irq_gpio_p3,
 			.base			= LPC32XX_GPIO_P3_GRP,
@@ -503,6 +582,7 @@ static struct lpc32xx_gpio_chip lpc32xx_
 			.label			= "gpi_p3",
 			.direction_input	= lpc32xx_gpio_dir_in_always,
 			.get			= lpc32xx_gpi_get_value,
+			.get_block		= lpc32xx_gpi_get_block,
 			.request		= lpc32xx_gpio_request,
 			.to_irq			= lpc32xx_gpio_to_irq_gpi_p3,
 			.base			= LPC32XX_GPI_P3_GRP,
@@ -517,7 +597,9 @@ static struct lpc32xx_gpio_chip lpc32xx_
 			.label			= "gpo_p3",
 			.direction_output	= lpc32xx_gpio_dir_out_always,
 			.set			= lpc32xx_gpo_set_value,
+			.set_block		= lpc32xx_gpo_set_block,
 			.get			= lpc32xx_gpo_get_value,
+			.get_block		= lpc32xx_gpo_get_block,
 			.request		= lpc32xx_gpio_request,
 			.base			= LPC32XX_GPO_P3_GRP,
 			.ngpio			= LPC32XX_GPO_P3_MAX,
