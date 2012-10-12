Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab2JLTMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 15:12:13 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:41880 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758791Ab2JLTMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 15:12:10 -0400
From: Roland Stigge <stigge@antcom.de>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RFC 4/6 v3] gpio-max730x: Add block GPIO API
Date: Fri, 12 Oct 2012 21:11:23 +0200
Message-Id: <1350069085-13283-5-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350069085-13283-1-git-send-email-stigge@antcom.de>
References: <1350069085-13283-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds block GPIO API support to the MAX730x driver.

Due to hardware constraints in this chip, simultaneous access to GPIO lines can
only be done in groups of 8: GPIOs 0-7, 8-15, 16-23, 24-27. However, setting
and clearing will be done at once.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 drivers/gpio/gpio-max730x.c |   60 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

--- linux-2.6.orig/drivers/gpio/gpio-max730x.c
+++ linux-2.6/drivers/gpio/gpio-max730x.c
@@ -146,6 +146,43 @@ static int max7301_get(struct gpio_chip
 	return level;
 }
 
+static unsigned max7301_get_block(struct gpio_chip *chip, unsigned mask)
+{
+	struct max7301 *ts = container_of(chip, struct max7301, chip);
+	int i, j;
+	unsigned result = 0;
+
+	for (i = 0; i < 4; i++) {
+		if ((mask >> (i * 8)) & 0xFF) { /* i/o only if necessary */
+			u8 in_level = ts->read(ts->dev, 0x44 + i * 8);
+			u8 in_mask = 0;
+			u8 out_level = (ts->out_level >> (i * 8 + 4)) & 0xFF;
+			u8 out_mask = 0;
+
+			for (j = 0; j < 8; j++) {
+				int offset = 4 + i * 8 + j;
+				int config = (ts->port_config[offset >> 2] >>
+					      ((offset & 3) << 1)) &
+					PIN_CONFIG_MASK;
+
+				switch (config) {
+				case PIN_CONFIG_OUT:
+					out_mask |= BIT(j);
+					break;
+				case PIN_CONFIG_IN_WO_PULLUP:
+				case PIN_CONFIG_IN_PULLUP:
+					in_mask |= BIT(j);
+				}
+			}
+
+			result |= ((unsigned)(in_level & in_mask) |
+				   (out_level & out_mask)) << (i * 8);
+		}
+	}
+
+	return result & mask;
+}
+
 static void max7301_set(struct gpio_chip *chip, unsigned offset, int value)
 {
 	struct max7301 *ts = container_of(chip, struct max7301, chip);
@@ -160,6 +197,27 @@ static void max7301_set(struct gpio_chip
 	mutex_unlock(&ts->lock);
 }
 
+static
+void max7301_set_block(struct gpio_chip *chip, unsigned mask, unsigned values)
+{
+	struct max7301 *ts = container_of(chip, struct max7301, chip);
+	unsigned changes;
+	int i;
+
+	mutex_lock(&ts->lock);
+
+	changes = (ts->out_level ^ (values << 4)) & (mask << 4);
+	ts->out_level ^= changes;
+
+	for (i = 0; i < 4; i++) {
+		if ((changes >> (i * 8 + 4)) & 0xFF) /* i/o only on change */
+			ts->write(ts->dev, 0x44 + i * 8,
+				  (ts->out_level >> (i * 8 + 4)) & 0xFF);
+	}
+
+	mutex_unlock(&ts->lock);
+}
+
 int __devinit __max730x_probe(struct max7301 *ts)
 {
 	struct device *dev = ts->dev;
@@ -183,8 +241,10 @@ int __devinit __max730x_probe(struct max
 
 	ts->chip.direction_input = max7301_direction_input;
 	ts->chip.get = max7301_get;
+	ts->chip.get_block = max7301_get_block;
 	ts->chip.direction_output = max7301_direction_output;
 	ts->chip.set = max7301_set;
+	ts->chip.set_block = max7301_set_block;
 
 	ts->chip.base = pdata->base;
 	ts->chip.ngpio = PIN_NUMBER;
