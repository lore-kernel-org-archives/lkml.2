Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab2JQMib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 08:38:31 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:39889 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756867Ab2JQMh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 08:37:56 -0400
From: Roland Stigge <stigge@antcom.de>
To: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RFC 15/15 v5] gpio-ucb1400: Add block GPIO API
Date: Wed, 17 Oct 2012 14:31:47 +0200
Message-Id: <1350477107-26512-16-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350477107-26512-1-git-send-email-stigge@antcom.de>
References: <1350477107-26512-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds block GPIO API support to the gpio-ucb1400 driver.

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 drivers/gpio/gpio-ucb1400.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- linux-2.6.orig/drivers/gpio/gpio-ucb1400.c
+++ linux-2.6/drivers/gpio/gpio-ucb1400.c
@@ -45,6 +45,27 @@ static void ucb1400_gpio_set(struct gpio
 	ucb1400_gpio_set_value(gpio->ac97, off, val);
 }
 
+static unsigned long ucb1400_gpio_get_block(struct gpio_chip *gc,
+					    unsigned long mask)
+{
+	struct ucb1400_gpio *gpio;
+	gpio = container_of(gc, struct ucb1400_gpio, gc);
+	return ucb1400_reg_read(gpio->ac97, UCB_IO_DATA) & mask;
+}
+
+static void ucb1400_gpio_set_block(struct gpio_chip *gc, unsigned long mask,
+				   unsigned long values)
+{
+	struct ucb1400_gpio *gpio;
+	u16 tmp;
+	gpio = container_of(gc, struct ucb1400_gpio, gc);
+
+	tmp = ucb1400_reg_read(gpio->ac97, UCB_IO_DATA) & ~mask;
+	tmp |= values & mask;
+
+	ucb1400_reg_write(gpio->ac97, UCB_IO_DATA, tmp);
+}
+
 static int ucb1400_gpio_probe(struct platform_device *dev)
 {
 	struct ucb1400_gpio *ucb = dev->dev.platform_data;
@@ -66,6 +87,8 @@ static int ucb1400_gpio_probe(struct pla
 	ucb->gc.direction_output = ucb1400_gpio_dir_out;
 	ucb->gc.get = ucb1400_gpio_get;
 	ucb->gc.set = ucb1400_gpio_set;
+	ucb->gc.get_block = ucb1400_gpio_get_block;
+	ucb->gc.set_block = ucb1400_gpio_set_block;
 	ucb->gc.can_sleep = 1;
 
 	err = gpiochip_add(&ucb->gc);
