Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab1DKLWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 07:22:49 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41908 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab1DKLWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 07:22:10 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, tglx@linutronix.de, cbouatmailru@gmail.com,
        grant.likely@secretlab.ca, arnd@arndb.de, nico@fluxnic.net,
        Jamie Iles <jamie@jamieiles.com>
Subject: [PATCHv3 6/7] basic_mmio_gpio: support different input/output registers
Date: Mon, 11 Apr 2011 12:21:53 +0100
Message-Id: <1302520914-22816-7-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1302520914-22816-1-git-send-email-jamie@jamieiles.com>
References: <1302520914-22816-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some controllers have separate input and output registers.  For these
controllers, use "set" for the output and "dat" for the input.

Changes since v2: reuse "set" for output and "dat" for input rather than
adding a new "in" register.

Signed-off-by: Jamie Iles <jamie@jamieiles.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/gpio/basic_mmio_gpio.c |   38 +++++++++++++++++++++++++++++++++-----
 1 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
index 728bc67..6b99489 100644
--- a/drivers/gpio/basic_mmio_gpio.c
+++ b/drivers/gpio/basic_mmio_gpio.c
@@ -185,6 +185,24 @@ static void bgpio_set_with_clear(struct gpio_chip *gc, unsigned int gpio,
 		bgc->write_reg(bgc->reg_clr, mask);
 }
 
+static void bgpio_set_set(struct gpio_chip *gc, unsigned int gpio, int val)
+{
+	struct bgpio_chip *bgc = to_bgpio_chip(gc);
+	unsigned long mask = bgc->pin2mask(bgc, gpio);
+	unsigned long flags;
+
+	spin_lock_irqsave(&bgc->lock, flags);
+
+	if (val)
+		bgc->data |= mask;
+	else
+		bgc->data &= ~mask;
+
+	bgc->write_reg(bgc->reg_set, bgc->data);
+
+	spin_unlock_irqrestore(&bgc->lock, flags);
+}
+
 static int bgpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
 {
 	return 0;
@@ -245,10 +263,12 @@ static int bgpio_setup_accessors(struct platform_device *pdev,
 
 /*
  * Create the device and allocate the resources.  For setting GPIO's there are
- * two supported configurations:
+ * three supported configurations:
  *
- *	- single output register resource (named "dat").
+ *	- single input/output register resource (named "dat").
  *	- set/clear pair (named "set" and "clr").
+ *	- single output register resource and single input resource ("set" and
+ *	dat").
  *
  * For the single output register, this drives a 1 by setting a bit and a zero
  * by clearing a bit.  For the set clr pair, this drives a 1 by setting a bit
@@ -292,12 +312,21 @@ static int bgpio_setup_io(struct platform_device *pdev,
 			return -ENOMEM;
 
 		bgc->gc.set = bgpio_set_with_clear;
-	} else if (res_set || res_clr) {
-		return -EINVAL;
+	} else if (res_set && !res_clr) {
+		if (resource_size(res_set) != resource_size(res_dat))
+			return -EINVAL;
+
+		bgc->reg_set = bgpio_request_and_map(&pdev->dev, res_set);
+		if (!bgc->reg_set)
+			return -ENOMEM;
+
+		bgc->gc.set = bgpio_set_set;
 	} else {
 		bgc->gc.set = bgpio_set;
 	}
 
+	bgc->gc.get = bgpio_get;
+
 	return 0;
 }
 
@@ -336,7 +365,6 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
 	bgc->gc.ngpio = ngpio;
 	bgc->gc.direction_input = bgpio_dir_in;
 	bgc->gc.direction_output = bgpio_dir_out;
-	bgc->gc.get = bgpio_get;
 	bgc->gc.dev = dev;
 	bgc->gc.label = dev_name(dev);
 
-- 
1.7.4.2

