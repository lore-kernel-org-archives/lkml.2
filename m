Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab2JQMh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 08:37:58 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:39888 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756764Ab2JQMhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 08:37:55 -0400
From: Roland Stigge <stigge@antcom.de>
To: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RFC 14/15 v5] gpio-vt8500: Add block GPIO API
Date: Wed, 17 Oct 2012 14:31:46 +0200
Message-Id: <1350477107-26512-15-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350477107-26512-1-git-send-email-stigge@antcom.de>
References: <1350477107-26512-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds block GPIO API support to the gpio-vt8500 driver.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 drivers/gpio/gpio-vt8500.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- linux-2.6.orig/drivers/gpio/gpio-vt8500.c
+++ linux-2.6/drivers/gpio/gpio-vt8500.c
@@ -209,6 +209,28 @@ static void vt8500_gpio_set_value(struct
 	writel_relaxed(val, vt8500_chip->base + vt8500_chip->regs->data_out);
 }
 
+static unsigned long vt8500_gpio_get_block(struct gpio_chip *chip,
+					   unsigned long mask)
+{
+	struct vt8500_gpio_chip *vt8500_chip = to_vt8500(chip);
+
+	return readl_relaxed(vt8500_chip->base + vt8500_chip->regs->data_in) &
+								mask;
+}
+
+static void vt8500_gpio_set_block(struct gpio_chip *chip, unsigned long mask,
+				  unsigned long  values)
+{
+	struct vt8500_gpio_chip *vt8500_chip = to_vt8500(chip);
+
+	u32 val = readl_relaxed(vt8500_chip->base +
+				vt8500_chip->regs->data_out);
+	val &= ~mask;
+	val |= values & mask;
+
+	writel_relaxed(val, vt8500_chip->base + vt8500_chip->regs->data_out);
+}
+
 static int vt8500_of_xlate(struct gpio_chip *gc,
 			    const struct of_phandle_args *gpiospec, u32 *flags)
 {
@@ -251,6 +273,8 @@ static int vt8500_add_chips(struct platf
 		chip->direction_output = vt8500_gpio_direction_output;
 		chip->get = vt8500_gpio_get_value;
 		chip->set = vt8500_gpio_set_value;
+		chip->get_block = vt8500_gpio_get_block;
+		chip->set_block = vt8500_gpio_set_block;
 		chip->can_sleep = 0;
 		chip->base = pin_cnt;
 		chip->ngpio = data->banks[i].ngpio;
