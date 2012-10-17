Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab2JQMjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 08:39:09 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:58310 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755587Ab2JQMhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 08:37:48 -0400
From: Roland Stigge <stigge@antcom.de>
To: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RFC 11/15 v5] gpio-max732x: Add block GPIO API
Date: Wed, 17 Oct 2012 14:31:43 +0200
Message-Id: <1350477107-26512-12-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350477107-26512-1-git-send-email-stigge@antcom.de>
References: <1350477107-26512-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds block GPIO API support to the gpio-max732x driver.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 drivers/gpio/gpio-max732x.c |   59 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

--- linux-2.6.orig/drivers/gpio/gpio-max732x.c
+++ linux-2.6/drivers/gpio/gpio-max732x.c
@@ -219,6 +219,63 @@ out:
 	mutex_unlock(&chip->lock);
 }
 
+static unsigned long max732x_gpio_get_block(struct gpio_chip *gc,
+					    unsigned long mask)
+{
+	struct max732x_chip *chip;
+	uint8_t lo = 0;
+	uint8_t hi = 0;
+	int ret;
+
+	chip = container_of(gc, struct max732x_chip, gpio_chip);
+
+	if (mask & 0xFF) {
+		ret = max732x_readb(chip, is_group_a(chip, 0), &lo);
+		if (ret < 0)
+			return 0;
+	}
+	if (mask & 0xFF00) {
+		ret = max732x_readb(chip, is_group_a(chip, 8), &hi);
+		if (ret < 0)
+			return 0;
+	}
+
+	return (((unsigned long)hi << 8) | lo) & mask;
+}
+
+static void max732x_gpio_set_block(struct gpio_chip *gc, unsigned long mask,
+				   unsigned long values)
+{
+	struct max732x_chip *chip;
+	uint8_t reg_out;
+	uint8_t lo_mask = mask & 0xFF;
+	uint8_t hi_mask = (mask >> 8) & 0xFF;
+	int ret;
+
+	chip = container_of(gc, struct max732x_chip, gpio_chip);
+
+	mutex_lock(&chip->lock);
+
+	if (lo_mask) {
+		reg_out = (chip->reg_out[0] & ~lo_mask) | (values & lo_mask);
+		ret = max732x_writeb(chip, is_group_a(chip, 0), reg_out);
+		if (ret < 0)
+			goto out;
+		chip->reg_out[0] = reg_out;
+	}
+	if (hi_mask) {
+		reg_out = (chip->reg_out[1] & ~hi_mask) |
+			((values >> 8) & hi_mask);
+		ret = max732x_writeb(chip, is_group_a(chip, 8), reg_out);
+		if (ret < 0)
+			goto out;
+		chip->reg_out[1] = reg_out;
+	}
+
+out:
+	mutex_unlock(&chip->lock);
+}
+
 static int max732x_gpio_direction_input(struct gpio_chip *gc, unsigned off)
 {
 	struct max732x_chip *chip;
@@ -562,8 +619,10 @@ static int __devinit max732x_setup_gpio(
 	if (chip->dir_output) {
 		gc->direction_output = max732x_gpio_direction_output;
 		gc->set = max732x_gpio_set_value;
+		gc->set_block = max732x_gpio_set_block;
 	}
 	gc->get = max732x_gpio_get_value;
+	gc->get_block = max732x_gpio_get_block;
 	gc->can_sleep = 1;
 
 	gc->base = gpio_start;
