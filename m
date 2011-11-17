Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab1KQBCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 20:02:34 -0500
Received: from mail131.messagelabs.com ([216.82.242.99]:23076 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875Ab1KQBCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 20:02:33 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-131.messagelabs.com!1321491746!2750381!10
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] gpio-ep93xx: remove static variables used for debounce support
Date: Wed, 16 Nov 2011 18:02:15 -0700
User-Agent: KMail/1.9.9
CC: <rmallon@gmail.com>, <grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201111161802.15800.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the static variables used to support the gpio interrupt debounce
by pulling the register offsets into the bank definitions and saving
the ioremap'ed address in the gpio bank's private allocated data.

Each bank is now individually kzalloc'ed instead of using one alloc to
hold all the bgpio_chip data. Because of this the probe exit paths have
been cleaned up.

This patch also moves the bank definitions to the top of the source to
make future patches that convert the interrupt support to genirq cleaner.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>

---

diff --git a/drivers/gpio/gpio-ep93xx.c b/drivers/gpio/gpio-ep93xx.c
index 1c0fc37..dee9e7e 100644
--- a/drivers/gpio/gpio-ep93xx.c
+++ b/drivers/gpio/gpio-ep93xx.c
@@ -28,11 +28,51 @@
 
 #define irq_to_gpio(irq)	((irq) - gpio_to_irq(0))
 
-struct ep93xx_gpio {
-	void __iomem		*mmio_base;
-	struct bgpio_chip	bgc[8];
+struct ep93xx_gpio_bank {
+	const char	*label;
+	int		base;
+	/* GPIO data and direction register offsets */
+	unsigned char	data;
+	unsigned char	dir;
+	/* GPIO interrupt support register offsets */
+	unsigned char	debounce;
+};
+
+#define EP93XX_GPIO_BANK(_label, _base, _data, _dir,			\
+			 _debounce)					\
+	{								\
+		.label		= _label,				\
+		.base		= _base,				\
+		.data		= _data,				\
+		.dir		= _dir,					\
+		.debounce	= _debounce,				\
+	}
+
+static struct ep93xx_gpio_bank ep93xx_gpio_banks[] = {
+	EP93XX_GPIO_BANK("A",  0, 0x00, 0x10, 0xa8),
+	EP93XX_GPIO_BANK("B",  8, 0x04, 0x14, 0xc4),
+	EP93XX_GPIO_BANK("C", 40, 0x08, 0x18, 0),
+	EP93XX_GPIO_BANK("D", 24, 0x0c, 0x1c, 0),
+	EP93XX_GPIO_BANK("E", 32, 0x20, 0x24, 0),
+	EP93XX_GPIO_BANK("F", 16, 0x30, 0x34, 0x64),
+	EP93XX_GPIO_BANK("G", 48, 0x38, 0x3c, 0),
+	EP93XX_GPIO_BANK("H", 56, 0x40, 0x44, 0),
+};
+
+/*
+ * This private struct is needed to hold the debounce register
+ * address needed by the gpiolib set_debounce method.
+ */
+struct ep93xx_gpio_chip {
+	struct bgpio_chip bgc;
+	void __iomem *reg_db;
 };
 
+static struct ep93xx_gpio_chip *to_ep93xx_gpio_chip(struct bgpio_chip *bgc)
+{
+	return container_of(bgc, struct ep93xx_gpio_chip, bgc);
+}
+
 /*************************************************************************
  * Interrupt handling for EP93xx on-chip GPIOs
  *************************************************************************/
@@ -40,14 +80,12 @@ static unsigned char gpio_int_unmasked[3];
 static unsigned char gpio_int_enabled[3];
 static unsigned char gpio_int_type1[3];
 static unsigned char gpio_int_type2[3];
-static unsigned char gpio_int_debounce[3];
 
 /* Port ordering is: A B F */
 static const u8 int_type1_register_offset[3]	= { 0x90, 0xac, 0x4c };
 static const u8 int_type2_register_offset[3]	= { 0x94, 0xb0, 0x50 };
 static const u8 eoi_register_offset[3]		= { 0x98, 0xb4, 0x54 };
 static const u8 int_en_register_offset[3]	= { 0x9c, 0xb8, 0x58 };
-static const u8 int_debounce_register_offset[3]	= { 0xa8, 0xc4, 0x64 };
 
 static void ep93xx_gpio_update_int_params(unsigned port)
 {
@@ -70,21 +108,6 @@ static inline void ep93xx_gpio_int_mask(unsigned line)
 	gpio_int_unmasked[line >> 3] &= ~(1 << (line & 7));
 }
 
-static void ep93xx_gpio_int_debounce(unsigned int irq, bool enable)
-{
-	int line = irq_to_gpio(irq);
-	int port = line >> 3;
-	int port_mask = 1 << (line & 7);
-
-	if (enable)
-		gpio_int_debounce[port] |= port_mask;
-	else
-		gpio_int_debounce[port] &= ~port_mask;
-
-	__raw_writeb(gpio_int_debounce[port],
-		EP93XX_GPIO_REG(int_debounce_register_offset[port]));
-}
-
 static void ep93xx_gpio_ab_irq_handler(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned char status;
@@ -269,44 +292,26 @@ static void ep93xx_gpio_init_irq(void)
 /*************************************************************************
  * gpiolib interface for EP93xx on-chip GPIOs
  *************************************************************************/
-struct ep93xx_gpio_bank {
-	const char	*label;
-	int		data;
-	int		dir;
-	int		base;
-	bool		has_debounce;
-};
-
-#define EP93XX_GPIO_BANK(_label, _data, _dir, _base, _debounce)	\
-	{							\
-		.label		= _label,			\
-		.data		= _data,			\
-		.dir		= _dir,				\
-		.base		= _base,			\
-		.has_debounce	= _debounce,			\
-	}
-
-static struct ep93xx_gpio_bank ep93xx_gpio_banks[] = {
-	EP93XX_GPIO_BANK("A", 0x00, 0x10, 0, true),
-	EP93XX_GPIO_BANK("B", 0x04, 0x14, 8, true),
-	EP93XX_GPIO_BANK("C", 0x08, 0x18, 40, false),
-	EP93XX_GPIO_BANK("D", 0x0c, 0x1c, 24, false),
-	EP93XX_GPIO_BANK("E", 0x20, 0x24, 32, false),
-	EP93XX_GPIO_BANK("F", 0x30, 0x34, 16, true),
-	EP93XX_GPIO_BANK("G", 0x38, 0x3c, 48, false),
-	EP93XX_GPIO_BANK("H", 0x40, 0x44, 56, false),
-};
 
 static int ep93xx_gpio_set_debounce(struct gpio_chip *chip,
 				    unsigned offset, unsigned debounce)
 {
-	int gpio = chip->base + offset;
-	int irq = gpio_to_irq(gpio);
+	struct bgpio_chip *bgc = to_bgpio_chip(chip);
+	struct ep93xx_gpio_chip *ep93xx_chip = to_ep93xx_gpio_chip(bgc);
+	unsigned long mask = bgc->pin2mask(bgc, offset);
+	unsigned long flags;
+	unsigned char val;
 
-	if (irq < 0)
-		return -EINVAL;
+	spin_lock_irqsave(&bgc->lock, flags);
+
+	val = bgc->read_reg(ep93xx_chip->reg_db);
+	if (debounce)
+		val |= mask;
+	else
+		val &= ~mask;
+	bgc->write_reg(ep93xx_chip->reg_db, val);
 
-	ep93xx_gpio_int_debounce(irq, debounce ? true : false);
+	spin_unlock_irqrestore(&bgc->lock, flags);
 
 	return 0;
 }
@@ -326,9 +331,12 @@ static int ep93xx_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 	return 64 + gpio;
 }
 
-static int ep93xx_gpio_add_bank(struct bgpio_chip *bgc, struct device *dev,
-	void __iomem *mmio_base, struct ep93xx_gpio_bank *bank)
+static int __devinit ep93xx_gpio_add_bank(struct ep93xx_gpio_chip *ep93xx_chip,
+					  struct device *dev,
+					  void __iomem *mmio_base,
+					  struct ep93xx_gpio_bank *bank)
 {
+	struct bgpio_chip *bgc = &ep93xx_chip->bgc;
 	void __iomem *data = mmio_base + bank->data;
 	void __iomem *dir =  mmio_base + bank->dir;
 	int err;
@@ -340,9 +348,10 @@ static int ep93xx_gpio_add_bank(struct bgpio_chip *bgc, struct device *dev,
 	bgc->gc.label = bank->label;
 	bgc->gc.base = bank->base;
 
-	if (bank->has_debounce) {
-		bgc->gc.set_debounce = ep93xx_gpio_set_debounce;
-		bgc->gc.to_irq = ep93xx_gpio_to_irq;
+	if (bank->debounce) {
+		bgc->gc.set_debounce	= ep93xx_gpio_set_debounce;
+		bgc->gc.to_irq		= ep93xx_gpio_to_irq;
+		ep93xx_chip->reg_db	= mmio_base + bank->debounce;
 	}
 
 	return gpiochip_add(&bgc->gc);
@@ -350,33 +359,23 @@ static int ep93xx_gpio_add_bank(struct bgpio_chip *bgc, struct device *dev,
 
 static int __devinit ep93xx_gpio_probe(struct platform_device *pdev)
 {
-	struct ep93xx_gpio *ep93xx_gpio;
+	struct device *dev = &pdev->dev;
 	struct resource *res;
 	void __iomem *mmio;
 	int i;
-	int ret;
-
-	ep93xx_gpio = kzalloc(sizeof(*ep93xx_gpio), GFP_KERNEL);
-	if (!ep93xx_gpio)
-		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		ret = -ENXIO;
-		goto exit_free;
-	}
+	if (!res)
+		return -ENXIO;
 
-	if (!request_mem_region(res->start, resource_size(res), pdev->name)) {
-		ret = -EBUSY;
-		goto exit_free;
-	}
+	if (!request_mem_region(res->start, resource_size(res), pdev->name))
+		return -EBUSY;
 
 	mmio = ioremap(res->start, resource_size(res));
 	if (!mmio) {
-		ret = -ENXIO;
-		goto exit_release;
+		release_mem_region(res->start, resource_size(res));
+		return -ENXIO;
 	}
-	ep93xx_gpio->mmio_base = mmio;
 
 	/* Default all ports to GPIO */
 	ep93xx_devcfg_set_bits(EP93XX_SYSCON_DEVCFG_KEYS |
@@ -386,24 +385,24 @@ static int __devinit ep93xx_gpio_probe(struct platform_device *pdev)
 			       EP93XX_SYSCON_DEVCFG_HONIDE);
 
 	for (i = 0; i < ARRAY_SIZE(ep93xx_gpio_banks); i++) {
-		struct bgpio_chip *bgc = &ep93xx_gpio->bgc[i];
 		struct ep93xx_gpio_bank *bank = &ep93xx_gpio_banks[i];
+		struct ep93xx_gpio_chip *ep93xx_chip;
 
-		if (ep93xx_gpio_add_bank(bgc, &pdev->dev, mmio, bank))
-			dev_warn(&pdev->dev, "Unable to add gpio bank %s\n",
+		ep93xx_chip = kzalloc(sizeof(*ep93xx_chip), GFP_KERNEL);
+		if (!ep93xx_chip) {
+			dev_warn(dev, "Unable to allocate gpio bank %s\n",
+				bank->label);
+			continue;
+		}
+
+		if (ep93xx_gpio_add_bank(ep93xx_chip, dev, mmio, bank))
+			dev_warn(dev, "Unable to add gpio bank %s\n",
 				bank->label);
 	}
 
 	ep93xx_gpio_init_irq();
 
 	return 0;
-
-exit_release:
-	release_mem_region(res->start, resource_size(res));
-exit_free:
-	kfree(ep93xx_gpio);
-	dev_info(&pdev->dev, "%s failed with errno %d\n", __func__, ret);
-	return ret;
 }
 
 static struct platform_driver ep93xx_gpio_driver = {
