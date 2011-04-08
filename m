Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab1DHORQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 10:17:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40223 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757260Ab1DHORO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 10:17:14 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, tglx@linutronix.de, cbouatmailru@gmail.com,
        grant.likely@secretlab.ca, arnd@arndb.de, nico@fluxnic.net,
        Jamie Iles <jamie@jamieiles.com>
Subject: [PATCHv2 5/7] basic_mmio_gpio: detect output method at probe time
Date: Fri,  8 Apr 2011 15:16:49 +0100
Message-Id: <1302272211-30242-6-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1302272211-30242-1-git-send-email-jamie@jamieiles.com>
References: <1302272211-30242-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than detecting the output method each time in the .set()
callback, do it at probe time and set the appropriate callback.

Signed-off-by: Jamie Iles <jamie@jamieiles.com>
Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/gpio/basic_mmio_gpio.c |   88 +++++++++++++++++++++++++++-------------
 1 files changed, 59 insertions(+), 29 deletions(-)

diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
index 90f7f89..9be1867 100644
--- a/drivers/gpio/basic_mmio_gpio.c
+++ b/drivers/gpio/basic_mmio_gpio.c
@@ -161,14 +161,6 @@ static void bgpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
 	unsigned long mask = bgc->pin2mask(bgc, gpio);
 	unsigned long flags;
 
-	if (bgc->reg_set) {
-		if (val)
-			bgc->write_reg(bgc->reg_set, mask);
-		else
-			bgc->write_reg(bgc->reg_clr, mask);
-		return;
-	}
-
 	spin_lock_irqsave(&bgc->lock, flags);
 
 	if (val)
@@ -181,6 +173,18 @@ static void bgpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
 	spin_unlock_irqrestore(&bgc->lock, flags);
 }
 
+static void bgpio_set_with_clear(struct gpio_chip *gc, unsigned int gpio,
+				 int val)
+{
+	struct bgpio_chip *bgc = to_bgpio_chip(gc);
+	unsigned long mask = bgc->pin2mask(bgc, gpio);
+
+	if (val)
+		bgc->write_reg(bgc->reg_set, mask);
+	else
+		bgc->write_reg(bgc->reg_clr, mask);
+}
+
 static int bgpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
 {
 	return 0;
@@ -188,7 +192,8 @@ static int bgpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
 
 static int bgpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
 {
-	bgpio_set(gc, gpio, val);
+	gc->set(gc, gpio, val);
+
 	return 0;
 }
 
@@ -238,14 +243,52 @@ static int bgpio_setup_accessors(struct platform_device *pdev,
 	return 0;
 }
 
+/*
+ * Create the device and allocate the resources.  For setting GPIO's there are
+ * two supported configurations:
+ *
+ *	- single output register resource (named "dat").
+ *	- set/clear pair (named "set" and "clr").
+ *
+ * For the single output register, this drives a 1 by setting a bit and a zero
+ * by clearing a bit.  For the set clr pair, this drives a 1 by setting a bit
+ * in the set register and clears it by setting a bit in the clear register.
+ * The configuration is detected by which resources are present.
+ */
+static int bgpio_setup_io(struct platform_device *pdev,
+			  struct bgpio_chip *bgc)
+{
+	struct resource *res_set;
+	struct resource *res_clr;
+
+	res_set = platform_get_resource_byname(pdev, IORESOURCE_MEM, "set");
+	res_clr = platform_get_resource_byname(pdev, IORESOURCE_MEM, "clr");
+	if (res_set && res_clr) {
+		if (resource_size(res_set) != resource_size(res_clr) ||
+				resource_size(res_set) != bgc->bits)
+			return -EINVAL;
+
+		bgc->reg_set = bgpio_request_and_map(&pdev->dev, res_set);
+		bgc->reg_clr = bgpio_request_and_map(&pdev->dev, res_clr);
+		if (!bgc->reg_set || !bgc->reg_clr)
+			return -ENOMEM;
+
+		bgc->gc.set = bgpio_set_with_clear;
+	} else if (res_set || res_clr) {
+		return -EINVAL;
+	} else {
+		bgc->gc.set = bgpio_set;
+	}
+
+	return 0;
+}
+
 static int __devinit bgpio_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct bgpio_pdata *pdata = dev_get_platdata(dev);
 	struct bgpio_chip *bgc;
 	struct resource *res_dat;
-	struct resource *res_set;
-	struct resource *res_clr;
 	resource_size_t dat_sz;
 	int bits;
 	int ret;
@@ -272,23 +315,6 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
 	if (!bgc->reg_dat)
 		return -ENOMEM;
 
-	res_set = platform_get_resource_byname(pdev, IORESOURCE_MEM, "set");
-	res_clr = platform_get_resource_byname(pdev, IORESOURCE_MEM, "clr");
-	if (res_set && res_clr) {
-		if (resource_size(res_set) != resource_size(res_clr) ||
-				resource_size(res_set) != dat_sz)
-			return -EINVAL;
-
-		bgc->reg_set = bgpio_request_and_map(dev, res_set);
-		bgc->reg_clr = bgpio_request_and_map(dev, res_clr);
-		if (!bgc->reg_set || !bgc->reg_clr)
-			return -ENOMEM;
-	} else if (res_set || res_clr) {
-		return -EINVAL;
-	}
-
-	spin_lock_init(&bgc->lock);
-
 	if (pdata) {
 		bgc->gc.base = pdata->base;
 		if (pdata->ngpio > 0)
@@ -302,13 +328,17 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	ret = bgpio_setup_io(pdev, bgc);
+	if (ret)
+		return ret;
+
+	spin_lock_init(&bgc->lock);
 	bgc->data = bgc->read_reg(bgc->reg_dat);
 
 	bgc->gc.ngpio = ngpio;
 	bgc->gc.direction_input = bgpio_dir_in;
 	bgc->gc.direction_output = bgpio_dir_out;
 	bgc->gc.get = bgpio_get;
-	bgc->gc.set = bgpio_set;
 	bgc->gc.dev = dev;
 	bgc->gc.label = dev_name(dev);
 
-- 
1.7.4.2

