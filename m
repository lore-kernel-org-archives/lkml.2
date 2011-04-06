Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab1DFLLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:11:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52680 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab1DFLLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:11:23 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, tglx@linutronix.de, cbouatmailru@gmail.com,
        grant.likely@secretlab.ca, arnd@arndb.de, nico@fluxnic.net,
        Jamie Iles <jamie@jamieiles.com>
Subject: [RFC PATCH 6/7] basic_mmio_gpio: support different input/output registers
Date: Wed,  6 Apr 2011 12:11:02 +0100
Message-Id: <1302088263-12714-7-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1302088263-12714-1-git-send-email-jamie@jamieiles.com>
References: <1302088263-12714-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some controllers have separate input and output registers.  For these
controllers, allow a register named "in" to be used for reading the
value of a GPIO pin.

Signed-off-by: Jamie Iles <jamie@jamieiles.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/gpio/basic_mmio_gpio.c |   29 +++++++++++++++++++++++++++--
 1 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
index 500eb6ae..d18a866 100644
--- a/drivers/gpio/basic_mmio_gpio.c
+++ b/drivers/gpio/basic_mmio_gpio.c
@@ -70,6 +70,7 @@ struct bgpio_chip {
 	void __iomem *reg_dat;
 	void __iomem *reg_set;
 	void __iomem *reg_clr;
+	void __iomem *reg_in;
 
 	/* Number of bits (GPIOs): <register width> * 8. */
 	int bits;
@@ -149,13 +150,20 @@ static unsigned long bgpio_pin2mask_be(struct bgpio_chip *bgc,
 	return 1 << (bgc->bits - 1 - pin);
 }
 
-static int bgpio_get(struct gpio_chip *gc, unsigned int gpio)
+static int bgpio_get_dat(struct gpio_chip *gc, unsigned int gpio)
 {
 	struct bgpio_chip *bgc = to_bgpio_chip(gc);
 
 	return bgc->read_reg(bgc->reg_dat) & bgc->pin2mask(bgc, gpio);
 }
 
+static int bgpio_get_in(struct gpio_chip *gc, unsigned int gpio)
+{
+	struct bgpio_chip *bgc = to_bgpio_chip(gc);
+
+	return bgc->read_reg(bgc->reg_in) & bgc->pin2mask(bgc, gpio);
+}
+
 static void bgpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
 {
 	struct bgpio_chip *bgc = to_bgpio_chip(gc);
@@ -255,12 +263,18 @@ static int bgpio_setup_accessors(struct platform_device *pdev,
  * by clearing a bit.  For the set clr pair, this drives a 1 by setting a bit
  * in the set register and clears it by setting a bit in the clear register.
  * The configuration is detected by which resources are present.
+ *
+ * For getting GPIO values, there are two supported configurations:
+ *
+ *	- single output/input register resource (named "dat").
+ *	- separate output/input register resources (named "dat" and "in").
  */
 static int bgpio_setup_io(struct platform_device *pdev,
 			  struct bgpio_chip *bgc)
 {
 	struct resource *res_set;
 	struct resource *res_clr;
+	struct resource *res_in;
 
 	res_set = platform_get_resource_byname(pdev, IORESOURCE_MEM, "set");
 	res_clr = platform_get_resource_byname(pdev, IORESOURCE_MEM, "clr");
@@ -281,6 +295,16 @@ static int bgpio_setup_io(struct platform_device *pdev,
 		bgc->gc.set = bgpio_set;
 	}
 
+	res_in = platform_get_resource_byname(pdev, IORESOURCE_MEM, "in");
+	if (res_in) {
+		bgc->reg_in = bgpio_request_and_map(&pdev->dev, res_in);
+		if (!bgc->reg_in)
+			return -ENOMEM;
+		bgc->gc.get = bgpio_get_in;
+	} else {
+		bgc->gc.get = bgpio_get_dat;
+	}
+
 	return 0;
 }
 
@@ -316,6 +340,8 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
 	if (!bgc->reg_dat)
 		return -ENOMEM;
 
+	spin_lock_init(&bgc->lock);
+
 	if (pdata) {
 		bgc->gc.base = pdata->base;
 		if (pdata->ngpio > 0)
@@ -338,7 +364,6 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
 	bgc->gc.ngpio = ngpio;
 	bgc->gc.direction_input = bgpio_dir_in;
 	bgc->gc.direction_output = bgpio_dir_out;
-	bgc->gc.get = bgpio_get;
 	bgc->gc.dev = dev;
 	bgc->gc.label = dev_name(dev);
 
-- 
1.7.4

