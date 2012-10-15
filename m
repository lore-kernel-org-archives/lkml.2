Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab2JOXcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 19:32:10 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:48210 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752611Ab2JOXcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:32:09 -0400
From: Roland Stigge <stigge@antcom.de>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com,
        daniel-gl@gmx.net, gregkh@linuxfoundation.org, rmallon@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RFC 09/11 v4] gpio-pl061: Add block GPIO API
Date: Tue, 16 Oct 2012 01:31:25 +0200
Message-Id: <1350343887-7344-10-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350343887-7344-1-git-send-email-stigge@antcom.de>
References: <1350343887-7344-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds block GPIO API support to the gpio-pl061 driver.

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 drivers/gpio/gpio-pl061.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- linux-2.6.orig/drivers/gpio/gpio-pl061.c
+++ linux-2.6/drivers/gpio/gpio-pl061.c
@@ -123,6 +123,21 @@ static void pl061_set_value(struct gpio_
 	writeb(!!value << offset, chip->base + (1 << (offset + 2)));
 }
 
+static unsigned long pl061_get_block(struct gpio_chip *gc, unsigned long mask)
+{
+	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
+
+	return !!readb(chip->base + (mask << 2));
+}
+
+static void pl061_set_block(struct gpio_chip *gc, unsigned long mask,
+			    unsigned long values)
+{
+	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
+
+	writeb(values & mask, chip->base + (mask << 2));
+}
+
 static int pl061_to_irq(struct gpio_chip *gc, unsigned offset)
 {
 	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
@@ -256,6 +271,8 @@ static int pl061_probe(struct amba_devic
 	chip->gc.direction_output = pl061_direction_output;
 	chip->gc.get = pl061_get_value;
 	chip->gc.set = pl061_set_value;
+	chip->gc.get_block = pl061_get_block;
+	chip->gc.set_block = pl061_set_block;
 	chip->gc.to_irq = pl061_to_irq;
 	chip->gc.ngpio = PL061_GPIO_NR;
 	chip->gc.label = dev_name(&dev->dev);
