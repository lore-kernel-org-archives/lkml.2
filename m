Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796Ab2JLTMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 15:12:16 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:33690 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753699Ab2JLTMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 15:12:10 -0400
From: Roland Stigge <stigge@antcom.de>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RFC 5/6 v3] gpio-lpc32xx: Add block GPIO API
Date: Fri, 12 Oct 2012 21:11:24 +0200
Message-Id: <1350069085-13283-6-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350069085-13283-1-git-send-email-stigge@antcom.de>
References: <1350069085-13283-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds block GPIO API support to the LPC32xx driver.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 drivers/gpio/gpio-lpc32xx.c |   78 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

--- linux-2.6.orig/drivers/gpio/gpio-lpc32xx.c
+++ linux-2.6/drivers/gpio/gpio-lpc32xx.c
@@ -297,6 +297,21 @@ static int lpc32xx_gpio_get_value_p3(str
 	return __get_gpio_state_p3(group, pin);
 }
 
+static unsigned lpc32xx_gpio_get_block_p3(struct gpio_chip *chip, unsigned mask)
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
@@ -304,6 +319,14 @@ static int lpc32xx_gpi_get_value(struct
 	return __get_gpi_state_p3(group, pin);
 }
 
+static unsigned lpc32xx_gpi_get_block(struct gpio_chip *chip, unsigned mask)
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
@@ -351,6 +374,26 @@ static void lpc32xx_gpio_set_value_p3(st
 	__set_gpio_level_p3(group, pin, value);
 }
 
+static void lpc32xx_gpio_set_block_p3(struct gpio_chip *chip, unsigned mask,
+				      unsigned values)
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
@@ -366,6 +409,30 @@ static int lpc32xx_gpo_get_value(struct
 	return __get_gpo_state_p3(group, pin);
 }
 
+static void lpc32xx_gpo_set_block(struct gpio_chip *chip, unsigned mask,
+				  unsigned values)
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
+static unsigned lpc32xx_gpo_get_block(struct gpio_chip *chip, unsigned mask)
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
@@ -440,8 +507,10 @@ static struct lpc32xx_gpio_chip lpc32xx_
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
@@ -456,8 +525,10 @@ static struct lpc32xx_gpio_chip lpc32xx_
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
@@ -472,8 +543,10 @@ static struct lpc32xx_gpio_chip lpc32xx_
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
@@ -487,8 +560,10 @@ static struct lpc32xx_gpio_chip lpc32xx_
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
@@ -503,6 +578,7 @@ static struct lpc32xx_gpio_chip lpc32xx_
 			.label			= "gpi_p3",
 			.direction_input	= lpc32xx_gpio_dir_in_always,
 			.get			= lpc32xx_gpi_get_value,
+			.get_block		= lpc32xx_gpi_get_block,
 			.request		= lpc32xx_gpio_request,
 			.to_irq			= lpc32xx_gpio_to_irq_gpi_p3,
 			.base			= LPC32XX_GPI_P3_GRP,
@@ -517,7 +593,9 @@ static struct lpc32xx_gpio_chip lpc32xx_
 			.label			= "gpo_p3",
 			.direction_output	= lpc32xx_gpio_dir_out_always,
 			.set			= lpc32xx_gpo_set_value,
+			.set_block		= lpc32xx_gpo_set_block,
 			.get			= lpc32xx_gpo_get_value,
+			.get_block		= lpc32xx_gpo_get_block,
 			.request		= lpc32xx_gpio_request,
 			.base			= LPC32XX_GPO_P3_GRP,
 			.ngpio			= LPC32XX_GPO_P3_MAX,
