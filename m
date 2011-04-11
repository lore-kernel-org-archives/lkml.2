Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab1DKLW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 07:22:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41908 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab1DKLWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 07:22:12 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, tglx@linutronix.de, cbouatmailru@gmail.com,
        grant.likely@secretlab.ca, arnd@arndb.de, nico@fluxnic.net,
        Jamie Iles <jamie@jamieiles.com>
Subject: [PATCHv3 7/7] basic_mmio_gpio: support direction registers
Date: Mon, 11 Apr 2011 12:21:54 +0100
Message-Id: <1302520914-22816-8-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1302520914-22816-1-git-send-email-jamie@jamieiles.com>
References: <1302520914-22816-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most controllers require the direction of a GPIO to be set by writing to
a direction register.  Add support for either an input direction
register or an output direction register.

Signed-off-by: Jamie Iles <jamie@jamieiles.com>
Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/gpio/basic_mmio_gpio.c |  114 +++++++++++++++++++++++++++++++++++++++-
 1 files changed, 112 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
index 6b99489..f4afd96 100644
--- a/drivers/gpio/basic_mmio_gpio.c
+++ b/drivers/gpio/basic_mmio_gpio.c
@@ -70,6 +70,7 @@ struct bgpio_chip {
 	void __iomem *reg_dat;
 	void __iomem *reg_set;
 	void __iomem *reg_clr;
+	void __iomem *reg_dir;
 
 	/* Number of bits (GPIOs): <register width> * 8. */
 	int bits;
@@ -88,6 +89,9 @@ struct bgpio_chip {
 
 	/* Shadowed data register to clear/set bits safely. */
 	unsigned long data;
+
+	/* Shadowed direction registers to clear/set direction safely. */
+	unsigned long dir;
 };
 
 static struct bgpio_chip *to_bgpio_chip(struct gpio_chip *gc)
@@ -203,15 +207,80 @@ static void bgpio_set_set(struct gpio_chip *gc, unsigned int gpio, int val)
 	spin_unlock_irqrestore(&bgc->lock, flags);
 }
 
+static int bgpio_simple_dir_in(struct gpio_chip *gc, unsigned int gpio)
+{
+	return 0;
+}
+
+static int bgpio_simple_dir_out(struct gpio_chip *gc, unsigned int gpio,
+				int val)
+{
+	gc->set(gc, gpio, val);
+
+	return 0;
+}
+
 static int bgpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
 {
+	struct bgpio_chip *bgc = to_bgpio_chip(gc);
+	unsigned long flags;
+
+	spin_lock_irqsave(&bgc->lock, flags);
+
+	bgc->dir &= ~bgc->pin2mask(bgc, gpio);
+	bgc->write_reg(bgc->reg_dir, bgc->dir);
+
+	spin_unlock_irqrestore(&bgc->lock, flags);
+
 	return 0;
 }
 
 static int bgpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
 {
+	struct bgpio_chip *bgc = to_bgpio_chip(gc);
+	unsigned long flags;
+
+	gc->set(gc, gpio, val);
+
+	spin_lock_irqsave(&bgc->lock, flags);
+
+	bgc->dir |= bgc->pin2mask(bgc, gpio);
+	bgc->write_reg(bgc->reg_dir, bgc->dir);
+
+	spin_unlock_irqrestore(&bgc->lock, flags);
+
+	return 0;
+}
+
+static int bgpio_dir_in_inv(struct gpio_chip *gc, unsigned int gpio)
+{
+	struct bgpio_chip *bgc = to_bgpio_chip(gc);
+	unsigned long flags;
+
+	spin_lock_irqsave(&bgc->lock, flags);
+
+	bgc->dir |= bgc->pin2mask(bgc, gpio);
+	bgc->write_reg(bgc->reg_dir, bgc->dir);
+
+	spin_unlock_irqrestore(&bgc->lock, flags);
+
+	return 0;
+}
+
+static int bgpio_dir_out_inv(struct gpio_chip *gc, unsigned int gpio, int val)
+{
+	struct bgpio_chip *bgc = to_bgpio_chip(gc);
+	unsigned long flags;
+
 	gc->set(gc, gpio, val);
 
+	spin_lock_irqsave(&bgc->lock, flags);
+
+	bgc->dir &= ~bgc->pin2mask(bgc, gpio);
+	bgc->write_reg(bgc->reg_dir, bgc->dir);
+
+	spin_unlock_irqrestore(&bgc->lock, flags);
+
 	return 0;
 }
 
@@ -274,6 +343,14 @@ static int bgpio_setup_accessors(struct platform_device *pdev,
  * by clearing a bit.  For the set clr pair, this drives a 1 by setting a bit
  * in the set register and clears it by setting a bit in the clear register.
  * The configuration is detected by which resources are present.
+ *
+ * For setting the GPIO direction, there are three supported configurations:
+ *
+ *	- simple bidirection GPIO that requires no configuration.
+ *	- an output direction register (named "dirout") where a 1 bit
+ *	indicates the GPIO is an output.
+ *	- an input direction register (named "dirin") where a 1 bit indicates
+ *	the GPIO is an input.
  */
 static int bgpio_setup_io(struct platform_device *pdev,
 			  struct bgpio_chip *bgc)
@@ -330,6 +407,37 @@ static int bgpio_setup_io(struct platform_device *pdev,
 	return 0;
 }
 
+static int bgpio_setup_direction(struct platform_device *pdev,
+				 struct bgpio_chip *bgc)
+{
+	struct resource *res_dirout;
+	struct resource *res_dirin;
+
+	res_dirout = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+						  "dirout");
+	res_dirin = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dirin");
+	if (res_dirout && res_dirin) {
+		return -EINVAL;
+	} else if (res_dirout) {
+		bgc->reg_dir = bgpio_request_and_map(&pdev->dev, res_dirout);
+		if (!bgc->reg_dir)
+			return -ENOMEM;
+		bgc->gc.direction_output = bgpio_dir_out;
+		bgc->gc.direction_input = bgpio_dir_in;
+	} else if (res_dirin) {
+		bgc->reg_dir = bgpio_request_and_map(&pdev->dev, res_dirin);
+		if (!bgc->reg_dir)
+			return -ENOMEM;
+		bgc->gc.direction_output = bgpio_dir_out_inv;
+		bgc->gc.direction_input = bgpio_dir_in_inv;
+	} else {
+		bgc->gc.direction_output = bgpio_simple_dir_out;
+		bgc->gc.direction_input = bgpio_simple_dir_in;
+	}
+
+	return 0;
+}
+
 static int __devinit bgpio_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -360,11 +468,13 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
 		return ret;
 
 	spin_lock_init(&bgc->lock);
+	ret = bgpio_setup_direction(pdev, bgc);
+	if (ret)
+		return ret;
+
 	bgc->data = bgc->read_reg(bgc->reg_dat);
 
 	bgc->gc.ngpio = ngpio;
-	bgc->gc.direction_input = bgpio_dir_in;
-	bgc->gc.direction_output = bgpio_dir_out;
 	bgc->gc.dev = dev;
 	bgc->gc.label = dev_name(dev);
 
-- 
1.7.4.2

