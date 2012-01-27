Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab2A0Qaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 11:30:30 -0500
Received: from mail.work-microwave.de ([62.245.205.51]:32926 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754741Ab2A0Qa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 11:30:28 -0500
From: Roland Stigge <stigge@antcom.de>
To: w.sang@pengutronix.de, grant.likely@secretlab.ca, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 2/2] LPC32XX: Add output reading to GPO P3
Date: Fri, 27 Jan 2012 17:29:56 +0100
Message-Id: <1327681796-2445-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.8.3
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The chip offers the function to detect the current state of output of the GPO
P3 pins. Useful for reading GPIO output state in Linux' GPIO API, e.g. via
sysfs

Signed-off-by: Roland Stigge <stigge@antcom.de>

diff --git a/drivers/gpio/gpio-lpc32xx.c b/drivers/gpio/gpio-lpc32xx.c
index 21b65e5..9bd59cf 100644
--- a/drivers/gpio/gpio-lpc32xx.c
+++ b/drivers/gpio/gpio-lpc32xx.c
@@ -62,9 +62,11 @@
 #define GPIO3_PIN_IN_SEL(x, y)		(((x) >> GPIO3_PIN_IN_SHIFT(y)) & 1)
 #define GPIO3_PIN5_IN_SEL(x)		(((x) >> 24) & 1)
 #define GPI3_PIN_IN_SEL(x, y)		(((x) >> (y)) & 1)
+#define GPO3_PIN_IN_SEL(x, y)		(((x) >> (y)) & 1)
 
 struct gpio_regs {
 	void __iomem *inp_state;
+	void __iomem *outp_state;
 	void __iomem *outp_set;
 	void __iomem *outp_clr;
 	void __iomem *dir_set;
@@ -145,6 +147,7 @@ static struct gpio_regs gpio_grp_regs_p2 = {
 
 static struct gpio_regs gpio_grp_regs_p3 = {
 	.inp_state	= LPC32XX_GPIO_P3_INP_STATE,
+	.outp_state	= LPC32XX_GPIO_P3_OUTP_STATE,
 	.outp_set	= LPC32XX_GPIO_P3_OUTP_SET,
 	.outp_clr	= LPC32XX_GPIO_P3_OUTP_CLR,
 	.dir_set	= LPC32XX_GPIO_P2_DIR_SET,
@@ -240,6 +243,12 @@ static int __get_gpi_state_p3(struct lpc32xx_gpio_chip *group,
 	return GPI3_PIN_IN_SEL(__raw_readl(group->gpio_grp->inp_state), pin);
 }
 
+static int __get_gpo_state_p3(struct lpc32xx_gpio_chip *group,
+	unsigned pin)
+{
+	return GPO3_PIN_IN_SEL(__raw_readl(group->gpio_grp->outp_state), pin);
+}
+
 /*
  * GENERIC_GPIO primitives.
  */
@@ -340,6 +349,13 @@ static void lpc32xx_gpo_set_value(struct gpio_chip *chip, unsigned pin,
 	__set_gpo_level_p3(group, pin, value);
 }
 
+static int lpc32xx_gpo_get_value(struct gpio_chip *chip, unsigned pin)
+{
+	struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
+
+	return __get_gpo_state_p3(group, pin);
+}
+
 static int lpc32xx_gpio_request(struct gpio_chip *chip, unsigned pin)
 {
 	if (pin < chip->ngpio)
@@ -427,6 +443,7 @@ static struct lpc32xx_gpio_chip lpc32xx_gpiochip[] = {
 			.label			= "gpo_p3",
 			.direction_output	= lpc32xx_gpio_dir_out_always,
 			.set			= lpc32xx_gpo_set_value,
+			.get			= lpc32xx_gpo_get_value,
 			.request		= lpc32xx_gpio_request,
 			.base			= LPC32XX_GPO_P3_GRP,
 			.ngpio			= LPC32XX_GPO_P3_MAX,
