Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab1DHORE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 10:17:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40223 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983Ab1DHORC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 10:17:02 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, tglx@linutronix.de, cbouatmailru@gmail.com,
        grant.likely@secretlab.ca, arnd@arndb.de, nico@fluxnic.net,
        Jamie Iles <jamie@jamieiles.com>
Subject: [PATCHv2 1/7] basic_mmio_gpio: remove runtime width/endianness evaluation
Date: Fri,  8 Apr 2011 15:16:45 +0100
Message-Id: <1302272211-30242-2-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1302272211-30242-1-git-send-email-jamie@jamieiles.com>
References: <1302272211-30242-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove endianness/width calculations at runtime by installing function
pointers for bit-to-mask conversion and register accessors.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/gpio/basic_mmio_gpio.c |  136 +++++++++++++++++++++++++++-------------
 1 files changed, 92 insertions(+), 44 deletions(-)

diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
index 3addea6..e935a24 100644
--- a/drivers/gpio/basic_mmio_gpio.c
+++ b/drivers/gpio/basic_mmio_gpio.c
@@ -63,6 +63,10 @@ o        `                     ~~~~\___/~~~~    ` controller in FPGA is ,.`
 
 struct bgpio_chip {
 	struct gpio_chip gc;
+
+	unsigned long (*read_reg)(void __iomem *reg);
+	void (*write_reg)(void __iomem *reg, unsigned long data);
+
 	void __iomem *reg_dat;
 	void __iomem *reg_set;
 	void __iomem *reg_clr;
@@ -74,7 +78,7 @@ struct bgpio_chip {
 	 * Some GPIO controllers work with the big-endian bits notation,
 	 * e.g. in a 8-bits register, GPIO7 is the least significant bit.
 	 */
-	int big_endian_bits;
+	unsigned long (*pin2mask)(struct bgpio_chip *bgc, unsigned int pin);
 
 	/*
 	 * Used to lock bgpio_chip->data. Also, this is needed to keep
@@ -91,70 +95,77 @@ static struct bgpio_chip *to_bgpio_chip(struct gpio_chip *gc)
 	return container_of(gc, struct bgpio_chip, gc);
 }
 
-static unsigned long bgpio_in(struct bgpio_chip *bgc)
+static void bgpio_write8(void __iomem *reg, unsigned long data)
 {
-	switch (bgc->bits) {
-	case 8:
-		return __raw_readb(bgc->reg_dat);
-	case 16:
-		return __raw_readw(bgc->reg_dat);
-	case 32:
-		return __raw_readl(bgc->reg_dat);
-#if BITS_PER_LONG >= 64
-	case 64:
-		return __raw_readq(bgc->reg_dat);
-#endif
-	}
-	return -EINVAL;
+	__raw_writeb(data, reg);
 }
 
-static void bgpio_out(struct bgpio_chip *bgc, void __iomem *reg,
-		      unsigned long data)
+static unsigned long bgpio_read8(void __iomem *reg)
 {
-	switch (bgc->bits) {
-	case 8:
-		__raw_writeb(data, reg);
-		return;
-	case 16:
-		__raw_writew(data, reg);
-		return;
-	case 32:
-		__raw_writel(data, reg);
-		return;
+	return __raw_readb(reg);
+}
+
+static void bgpio_write16(void __iomem *reg, unsigned long data)
+{
+	__raw_writew(data, reg);
+}
+
+static unsigned long bgpio_read16(void __iomem *reg)
+{
+	return __raw_readw(reg);
+}
+
+static void bgpio_write32(void __iomem *reg, unsigned long data)
+{
+	__raw_writel(data, reg);
+}
+
+static unsigned long bgpio_read32(void __iomem *reg)
+{
+	return __raw_readl(reg);
+}
+
 #if BITS_PER_LONG >= 64
-	case 64:
-		__raw_writeq(data, reg);
-		return;
-#endif
-	}
+static void bgpio_write64(void __iomem *reg, unsigned long data)
+{
+	__raw_writeq(data, reg);
 }
 
+static unsigned long bgpio_read64(void __iomem *reg)
+{
+	return __raw_readq(reg);
+}
+#endif /* BITS_PER_LONG >= 64 */
+
 static unsigned long bgpio_pin2mask(struct bgpio_chip *bgc, unsigned int pin)
 {
-	if (bgc->big_endian_bits)
-		return 1 << (bgc->bits - 1 - pin);
-	else
-		return 1 << pin;
+	return 1 << pin;
+}
+
+static unsigned long bgpio_pin2mask_be(struct bgpio_chip *bgc,
+				       unsigned int pin)
+{
+	return 1 << (bgc->bits - 1 - pin);
 }
 
 static int bgpio_get(struct gpio_chip *gc, unsigned int gpio)
 {
 	struct bgpio_chip *bgc = to_bgpio_chip(gc);
 
-	return bgpio_in(bgc) & bgpio_pin2mask(bgc, gpio);
+	return bgc->read_reg(bgc->reg_dat) & bgc->pin2mask(bgc, gpio);
 }
 
 static void bgpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
 {
 	struct bgpio_chip *bgc = to_bgpio_chip(gc);
-	unsigned long mask = bgpio_pin2mask(bgc, gpio);
+	unsigned long mask = bgc->pin2mask(bgc, gpio);
 	unsigned long flags;
 
 	if (bgc->reg_set) {
 		if (val)
-			bgpio_out(bgc, bgc->reg_set, mask);
+			bgc->write_reg(bgc->reg_set, mask);
 		else
-			bgpio_out(bgc, bgc->reg_clr, mask);
+			bgc->write_reg(bgc->reg_clr, mask);
 		return;
 	}
 
@@ -165,7 +176,7 @@ static void bgpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
 	else
 		bgc->data &= ~mask;
 
-	bgpio_out(bgc, bgc->reg_dat, bgc->data);
+	bgc->write_reg(bgc->reg_dat, bgc->data);
 
 	spin_unlock_irqrestore(&bgc->lock, flags);
 }
@@ -181,9 +192,44 @@ static int bgpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
 	return 0;
 }
 
-static int __devinit bgpio_probe(struct platform_device *pdev)
+static int bgpio_setup_accessors(struct platform_device *pdev,
+				 struct bgpio_chip *bgc)
 {
 	const struct platform_device_id *platid = platform_get_device_id(pdev);
+
+	switch (bgc->bits) {
+	case 8:
+		bgc->read_reg	= bgpio_read8;
+		bgc->write_reg	= bgpio_write8;
+		break;
+	case 16:
+		bgc->read_reg	= bgpio_read16;
+		bgc->write_reg	= bgpio_write16;
+		break;
+	case 32:
+		bgc->read_reg	= bgpio_read32;
+		bgc->write_reg	= bgpio_write32;
+		break;
+#if BITS_PER_LONG >= 64
+	case 64:
+		bgc->read_reg	= bgpio_read64;
+		bgc->write_reg	= bgpio_write64;
+		break;
+#endif /* BITS_PER_LONG >= 64 */
+	default:
+		dev_err(&pdev->dev, "unsupported data width %u bits\n",
+			bgc->bits);
+		return -EINVAL;
+	}
+
+	bgc->pin2mask = strcmp(platid->name, "basic-mmio-gpio-be") ?
+		bgpio_pin2mask : bgpio_pin2mask_be;
+
+	return 0;
+}
+
+static int __devinit bgpio_probe(struct platform_device *pdev)
+{
 	struct device *dev = &pdev->dev;
 	struct bgpio_pdata *pdata = dev_get_platdata(dev);
 	struct bgpio_chip *bgc;
@@ -232,9 +278,11 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
 	spin_lock_init(&bgc->lock);
 
 	bgc->bits = bits;
-	bgc->big_endian_bits = !strcmp(platid->name, "basic-mmio-gpio-be");
-	bgc->data = bgpio_in(bgc);
+	ret = bgpio_setup_accessors(pdev, bgc);
+	if (ret)
+		return ret;
 
+	bgc->data = bgc->read_reg(bgc->reg_dat);
 	bgc->gc.ngpio = bits;
 	bgc->gc.direction_input = bgpio_dir_in;
 	bgc->gc.direction_output = bgpio_dir_out;
-- 
1.7.4.2

