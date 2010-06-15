Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab0FOIBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 04:01:16 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36279 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab0FOIBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 04:01:15 -0400
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH] max730x: make pullups configurable via platformdata
Date: Tue, 15 Jun 2010 10:01:01 +0200
Message-Id: <1276588861-15663-1-git-send-email-mkl@pengutronix.de>
X-Mailer: git-send-email 1.7.1
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gpios on the max730x chips have support for internal pullups
while in input mode.

This patch adds support for configuring these pullups via platform data.
A new member ("input_pullup_active") to the platform data struct is
introduced. A set bit in this variable activates the pullups while the
respective port is in input mode. This is a compatible enhancement since
unset bits lead to disables pullups which was the default in the
original driver.

_Note_: the 4 lowest bits in "input_pullup_active" are unused because
the first 4 ports of the controller are not used, too.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/gpio/max730x.c      |   22 +++++++++++++++-------
 include/linux/spi/max7301.h |    8 ++++++++
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/max730x.c b/drivers/gpio/max730x.c
index 7696a56..94ce773 100644
--- a/drivers/gpio/max730x.c
+++ b/drivers/gpio/max730x.c
@@ -54,7 +54,7 @@ static int max7301_direction_input(struct gpio_chip *chip, unsigned offset)
 {
 	struct max7301 *ts = container_of(chip, struct max7301, chip);
 	u8 *config;
-	u8 offset_bits;
+	u8 offset_bits, pin_config;
 	int ret;
 
 	/* First 4 pins are unused in the controller */
@@ -63,12 +63,15 @@ static int max7301_direction_input(struct gpio_chip *chip, unsigned offset)
 
 	config = &ts->port_config[offset >> 2];
 
+	if (ts->input_pullup_active & BIT(offset))
+		pin_config = PIN_CONFIG_IN_PULLUP;
+	else
+		pin_config = PIN_CONFIG_IN_WO_PULLUP;
+
 	mutex_lock(&ts->lock);
 
-	/* Standard GPIO API doesn't support pull-ups, has to be extended.
-	 * Hard-coding no pollup for now. */
 	*config = (*config & ~(PIN_CONFIG_MASK << offset_bits))
-			   | (PIN_CONFIG_IN_WO_PULLUP << offset_bits);
+			   | (pin_config << offset_bits);
 
 	ret = ts->write(ts->dev, 0x08 + (offset >> 2), *config);
 
@@ -177,6 +180,7 @@ int __devinit __max730x_probe(struct max7301 *ts)
 	/* Power up the chip and disable IRQ output */
 	ts->write(dev, 0x04, 0x01);
 
+	ts->input_pullup_active = pdata->input_pullup_active;
 	ts->chip.label = dev->driver->name;
 
 	ts->chip.direction_input = max7301_direction_input;
@@ -191,13 +195,17 @@ int __devinit __max730x_probe(struct max7301 *ts)
 	ts->chip.owner = THIS_MODULE;
 
 	/*
-	 * tristate all pins in hardware and cache the
+	 * initialize pullups according to platform data and cache the
 	 * register values for later use.
 	 */
 	for (i = 1; i < 8; i++) {
 		int j;
-		/* 0xAA means input with internal pullup disabled */
-		ts->write(dev, 0x08 + i, 0xAA);
+		/*
+		 * initialize port_config with "0xAA", which means
+		 * input with internal pullup disabled. This is needed
+		 * to avoid writing zeros (in the inner for loop),
+		 * which is not allowed according to the datasheet.
+		 */
 		ts->port_config[i] = 0xAA;
 		for (j = 0; j < 4; j++) {
 			int offset = (i - 1) * 4 + j;
diff --git a/include/linux/spi/max7301.h b/include/linux/spi/max7301.h
index 34af0a3..bcaa2f7 100644
--- a/include/linux/spi/max7301.h
+++ b/include/linux/spi/max7301.h
@@ -11,6 +11,7 @@ struct max7301 {
 	struct mutex	lock;
 	u8		port_config[8];	/* field 0 is unused */
 	u32		out_level;	/* cached output levels */
+	u32		input_pullup_active;
 	struct gpio_chip chip;
 	struct device *dev;
 	int (*write)(struct device *dev, unsigned int reg, unsigned int val);
@@ -20,6 +21,13 @@ struct max7301 {
 struct max7301_platform_data {
 	/* number assigned to the first GPIO */
 	unsigned	base;
+	/*
+	 * bitmask controlling the pullup configuration,
+	 *
+	 * _note_ the 4 lowest bits are unused, because the first 4
+	 * ports of the controller are not used, too.
+	 */
+	u32		input_pullup_active;
 };
 
 extern int __max730x_remove(struct device *dev);
-- 
1.7.1

