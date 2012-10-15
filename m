Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab2JOXcQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 19:32:16 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:42091 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754893Ab2JOXcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:32:14 -0400
From: Roland Stigge <stigge@antcom.de>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com,
        daniel-gl@gmx.net, gregkh@linuxfoundation.org, rmallon@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RFC 11/11 v4] gpio-pcf857x: Add block GPIO API
Date: Tue, 16 Oct 2012 01:31:27 +0200
Message-Id: <1350343887-7344-12-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350343887-7344-1-git-send-email-stigge@antcom.de>
References: <1350343887-7344-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds block GPIO API support to the gpio-pcf857x driver.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 drivers/gpio/gpio-pcf857x.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- linux-2.6.orig/drivers/gpio/gpio-pcf857x.c
+++ linux-2.6/drivers/gpio/gpio-pcf857x.c
@@ -158,6 +158,28 @@ static void pcf857x_set(struct gpio_chip
 	pcf857x_output(chip, offset, value);
 }
 
+static unsigned long pcf857x_get_block(struct gpio_chip *chip,
+				       unsigned long mask)
+{
+	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
+	int		value;
+
+	value = gpio->read(gpio->client);
+	return (value < 0) ? 0 : (value & mask);
+}
+
+static void pcf857x_set_block(struct gpio_chip *chip, unsigned long mask,
+			      unsigned long values)
+{
+	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
+
+	mutex_lock(&gpio->lock);
+	gpio->out &= ~mask;
+	gpio->out |= values & mask;
+	gpio->write(gpio->client, gpio->out);
+	mutex_unlock(&gpio->lock);
+}
+
 /*-------------------------------------------------------------------------*/
 
 static int pcf857x_to_irq(struct gpio_chip *chip, unsigned offset)
@@ -280,6 +302,8 @@ static int pcf857x_probe(struct i2c_clie
 	gpio->chip.owner		= THIS_MODULE;
 	gpio->chip.get			= pcf857x_get;
 	gpio->chip.set			= pcf857x_set;
+	gpio->chip.get_block		= pcf857x_get_block;
+	gpio->chip.set_block		= pcf857x_set_block;
 	gpio->chip.direction_input	= pcf857x_input;
 	gpio->chip.direction_output	= pcf857x_output;
 	gpio->chip.ngpio		= id->driver_data;
