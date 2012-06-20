Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab2FTOeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 10:34:21 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:36253 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756610Ab2FTOeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 10:34:19 -0400
From: Roland Stigge <stigge@antcom.de>
To: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org, aletes.xgr@gmail.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] gpio: gpio-lpc32xx: Add gpio_to_irq mapping
Date: Wed, 20 Jun 2012 16:33:52 +0200
Message-Id: <1340202832-16850-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch helps mapping with gpio_to_irq for the GPIOs that are irq enabled.

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
Applies to 3.5-rc3

 drivers/gpio/gpio-lpc32xx.c |   65 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

--- linux-2.6.orig/drivers/gpio/gpio-lpc32xx.c
+++ linux-2.6/drivers/gpio/gpio-lpc32xx.c
@@ -28,6 +28,7 @@
 #include <mach/hardware.h>
 #include <mach/platform.h>
 #include <mach/gpio-lpc32xx.h>
+#include <mach/irqs.h>
 
 #define LPC32XX_GPIO_P3_INP_STATE		_GPREG(0x000)
 #define LPC32XX_GPIO_P3_OUTP_SET		_GPREG(0x004)
@@ -367,6 +368,66 @@ static int lpc32xx_gpio_request(struct g
 	return -EINVAL;
 }
 
+static int lpc32xx_gpio_to_irq_p01(struct gpio_chip *chip, unsigned offset)
+{
+	return IRQ_LPC32XX_P0_P1_IRQ;
+}
+
+static const char lpc32xx_gpio_to_irq_gpio_p3_table[] = {
+	IRQ_LPC32XX_GPIO_00,
+	IRQ_LPC32XX_GPIO_01,
+	IRQ_LPC32XX_GPIO_02,
+	IRQ_LPC32XX_GPIO_03,
+	IRQ_LPC32XX_GPIO_04,
+	IRQ_LPC32XX_GPIO_05,
+};
+
+static int lpc32xx_gpio_to_irq_gpio_p3(struct gpio_chip *chip, unsigned offset)
+{
+	if (offset < ARRAY_SIZE(lpc32xx_gpio_to_irq_gpio_p3_table))
+		return lpc32xx_gpio_to_irq_gpio_p3_table[offset];
+	return -ENXIO;
+}
+
+static const char lpc32xx_gpio_to_irq_gpi_p3_table[] = {
+	IRQ_LPC32XX_GPI_00,
+	IRQ_LPC32XX_GPI_01,
+	IRQ_LPC32XX_GPI_02,
+	IRQ_LPC32XX_GPI_03,
+	IRQ_LPC32XX_GPI_04,
+	IRQ_LPC32XX_GPI_05,
+	IRQ_LPC32XX_GPI_06,
+	IRQ_LPC32XX_GPI_07,
+	IRQ_LPC32XX_GPI_08,
+	IRQ_LPC32XX_GPI_09,
+	-ENXIO, /* 10 */
+	-ENXIO, /* 11 */
+	-ENXIO, /* 12 */
+	-ENXIO, /* 13 */
+	-ENXIO, /* 14 */
+	-ENXIO, /* 15 */
+	-ENXIO, /* 16 */
+	-ENXIO, /* 17 */
+	-ENXIO, /* 18 */
+	IRQ_LPC32XX_GPI_19,
+	-ENXIO, /* 20 */
+	-ENXIO, /* 21 */
+	-ENXIO, /* 22 */
+	-ENXIO, /* 23 */
+	-ENXIO, /* 24 */
+	-ENXIO, /* 25 */
+	-ENXIO, /* 26 */
+	-ENXIO, /* 27 */
+	IRQ_LPC32XX_GPI_28,
+};
+
+static int lpc32xx_gpio_to_irq_gpi_p3(struct gpio_chip *chip, unsigned offset)
+{
+	if (offset < ARRAY_SIZE(lpc32xx_gpio_to_irq_gpi_p3_table))
+		return lpc32xx_gpio_to_irq_gpi_p3_table[offset];
+	return -ENXIO;
+}
+
 static struct lpc32xx_gpio_chip lpc32xx_gpiochip[] = {
 	{
 		.chip = {
@@ -376,6 +437,7 @@ static struct lpc32xx_gpio_chip lpc32xx_
 			.direction_output	= lpc32xx_gpio_dir_output_p012,
 			.set			= lpc32xx_gpio_set_value_p012,
 			.request		= lpc32xx_gpio_request,
+			.to_irq			= lpc32xx_gpio_to_irq_p01,
 			.base			= LPC32XX_GPIO_P0_GRP,
 			.ngpio			= LPC32XX_GPIO_P0_MAX,
 			.names			= gpio_p0_names,
@@ -391,6 +453,7 @@ static struct lpc32xx_gpio_chip lpc32xx_
 			.direction_output	= lpc32xx_gpio_dir_output_p012,
 			.set			= lpc32xx_gpio_set_value_p012,
 			.request		= lpc32xx_gpio_request,
+			.to_irq			= lpc32xx_gpio_to_irq_p01,
 			.base			= LPC32XX_GPIO_P1_GRP,
 			.ngpio			= LPC32XX_GPIO_P1_MAX,
 			.names			= gpio_p1_names,
@@ -421,6 +484,7 @@ static struct lpc32xx_gpio_chip lpc32xx_
 			.direction_output	= lpc32xx_gpio_dir_output_p3,
 			.set			= lpc32xx_gpio_set_value_p3,
 			.request		= lpc32xx_gpio_request,
+			.to_irq			= lpc32xx_gpio_to_irq_gpio_p3,
 			.base			= LPC32XX_GPIO_P3_GRP,
 			.ngpio			= LPC32XX_GPIO_P3_MAX,
 			.names			= gpio_p3_names,
@@ -434,6 +498,7 @@ static struct lpc32xx_gpio_chip lpc32xx_
 			.direction_input	= lpc32xx_gpio_dir_in_always,
 			.get			= lpc32xx_gpi_get_value,
 			.request		= lpc32xx_gpio_request,
+			.to_irq			= lpc32xx_gpio_to_irq_gpi_p3,
 			.base			= LPC32XX_GPI_P3_GRP,
 			.ngpio			= LPC32XX_GPI_P3_MAX,
 			.names			= gpi_p3_names,
