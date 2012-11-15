Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767892Ab2KOOAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:00:48 -0500
Received: from antcom.de ([188.40.178.216]:50520 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767850Ab2KOOAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:00:47 -0500
From: Roland Stigge <stigge@antcom.de>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, w.sang@pengutronix.de,
        jbe@pengutronix.de
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] gpio: gpio-max710x: Support device tree probing
Date: Thu, 15 Nov 2012 14:59:40 +0100
Message-Id: <1352987980-5112-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For probing via device tree, we need to support the case without platform_data.
In this case, chip.base is set to -1 for automatic numbering.

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 drivers/gpio/gpio-max730x.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- linux-2.6.orig/drivers/gpio/gpio-max730x.c
+++ linux-2.6/drivers/gpio/gpio-max730x.c
@@ -167,10 +167,6 @@ int __devinit __max730x_probe(struct max
 	int i, ret;
 
 	pdata = dev->platform_data;
-	if (!pdata || !pdata->base) {
-		dev_err(dev, "incorrect or missing platform data\n");
-		return -EINVAL;
-	}
 
 	mutex_init(&ts->lock);
 	dev_set_drvdata(dev, ts);
@@ -178,7 +174,12 @@ int __devinit __max730x_probe(struct max
 	/* Power up the chip and disable IRQ output */
 	ts->write(dev, 0x04, 0x01);
 
-	ts->input_pullup_active = pdata->input_pullup_active;
+	if (pdata) {
+		ts->input_pullup_active = pdata->input_pullup_active;
+		ts->chip.base = pdata->base;
+	} else {
+		ts->chip.base = -1;
+	}
 	ts->chip.label = dev->driver->name;
 
 	ts->chip.direction_input = max7301_direction_input;
@@ -186,7 +187,6 @@ int __devinit __max730x_probe(struct max
 	ts->chip.direction_output = max7301_direction_output;
 	ts->chip.set = max7301_set;
 
-	ts->chip.base = pdata->base;
 	ts->chip.ngpio = PIN_NUMBER;
 	ts->chip.can_sleep = 1;
 	ts->chip.dev = dev;
