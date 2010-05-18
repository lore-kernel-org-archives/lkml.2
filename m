Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab0ERHn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 03:43:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:4864 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755740Ab0ERHnZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 03:43:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,254,1272870000"; 
   d="scan'208,223";a="518862523"
Date: Tue, 18 May 2010 15:40:25 +0800
From: "Du, Alek" <alek.du@intel.com>
To: David Brownell <david-b@pacbell.net>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] gpio: add Penwell gpio support
Message-ID: <20100518154025.4aaff2ee@dxy2>
Organization: Intel Corp.
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 963f6e83843b0f94f8a5337def6e897ec5bb99bf Mon Sep 17 00:00:00 2001
From: Alek Du <alek.du@intel.com>
Date: Thu, 25 Feb 2010 14:32:46 +0800
Subject: [PATCH] gpio: add Penwell gpio support

Intel Penwell chip has two 96 pins GPIO blocks, which are very similiar as
Intel Langwell chip GPIO block, except for pin number difference. This
patch expends the original Langwell GPIO driver to support Penwell's.

Signed-off-by: Alek Du <alek.du@intel.com>
---
 drivers/gpio/Kconfig         |    4 +-
 drivers/gpio/langwell_gpio.c |   83 ++++++++++++++++++++++++++----------------
 2 files changed, 53 insertions(+), 34 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index da82355..e6822a3 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -264,10 +264,10 @@ config GPIO_BT8XX
 	  If unsure, say N.
 
 config GPIO_LANGWELL
-	bool "Intel Moorestown Platform Langwell GPIO support"
+	bool "Intel Langwell/Penwell GPIO support"
 	depends on PCI
 	help
-	  Say Y here to support Intel Moorestown platform GPIO.
+	  Say Y here to support Intel Langwell/Penwell GPIO.
 
 config GPIO_TIMBERDALE
 	bool "Support for timberdale GPIO IP"
diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
index 00c3a14..0693f71 100644
--- a/drivers/gpio/langwell_gpio.c
+++ b/drivers/gpio/langwell_gpio.c
@@ -17,6 +17,7 @@
 
 /* Supports:
  * Moorestown platform Langwell chip.
+ * Medfield platform Penwell chip.
  */
 
 #include <linux/module.h>
@@ -31,44 +32,65 @@
 #include <linux/gpio.h>
 #include <linux/slab.h>
 
-struct lnw_gpio_register {
-	u32	GPLR[2];
-	u32	GPDR[2];
-	u32	GPSR[2];
-	u32	GPCR[2];
-	u32	GRER[2];
-	u32	GFER[2];
-	u32	GEDR[2];
+/*
+ * Langwell chip has 64 pins and thus there are 2 32bit registers to control
+ * each feature, while Penwell chip has 96 pins for each block, and need 3 32bit
+ * registers to control them, so we only define the order here instead of a
+ * structure, to get a bit offset for a pin (use GPDR as an example):
+ *
+ * nreg = ngpio / 32;
+ * reg = offset / 32;
+ * bit = offset % 32;
+ * reg_addr = reg_base + GPDR * nreg * 4 + reg * 4;
+ *
+ * so the bit of reg_addr is to control pin offset's GPDR feature
+*/
+
+enum GPIO_REG {
+	GPLR = 0,	/* pin level read-only */
+	GPDR,		/* pin direction */
+	GPSR,		/* pin set */
+	GPCR,		/* pin clear */
+	GRER,		/* rising edge detect */
+	GFER,		/* falling edge detect */
+	GEDR,		/* edge detect result */
 };
 
 struct lnw_gpio {
 	struct gpio_chip		chip;
-	struct lnw_gpio_register 	*reg_base;
+	void				*reg_base;
 	spinlock_t			lock;
 	unsigned			irq_base;
 };
 
-static int lnw_gpio_get(struct gpio_chip *chip, unsigned offset)
+static inline void __iomem *gpio_reg(struct gpio_chip *chip, unsigned offset,
+			enum GPIO_REG reg_type)
 {
 	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
+	unsigned nreg = chip->ngpio / 32;
 	u8 reg = offset / 32;
-	void __iomem *gplr;
+	void __iomem *ptr;
+
+	ptr = (void __iomem *)(lnw->reg_base + reg_type * nreg * 4 + reg * 4);
+	return ptr;
+}
+
+static int lnw_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	void __iomem *gplr = gpio_reg(chip, offset, GPLR);
 
-	gplr = (void __iomem *)(&lnw->reg_base->GPLR[reg]);
 	return readl(gplr) & BIT(offset % 32);
 }
 
 static void lnw_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 {
-	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
-	u8 reg = offset / 32;
 	void __iomem *gpsr, *gpcr;
 
 	if (value) {
-		gpsr = (void __iomem *)(&lnw->reg_base->GPSR[reg]);
+		gpsr = gpio_reg(chip, offset, GPSR);
 		writel(BIT(offset % 32), gpsr);
 	} else {
-		gpcr = (void __iomem *)(&lnw->reg_base->GPCR[reg]);
+		gpcr = gpio_reg(chip, offset, GPCR);
 		writel(BIT(offset % 32), gpcr);
 	}
 }
@@ -76,12 +98,10 @@ static void lnw_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 static int lnw_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
 {
 	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
-	u8 reg = offset / 32;
+	void __iomem *gpdr = gpio_reg(chip, offset, GPDR);
 	u32 value;
 	unsigned long flags;
-	void __iomem *gpdr;
 
-	gpdr = (void __iomem *)(&lnw->reg_base->GPDR[reg]);
 	spin_lock_irqsave(&lnw->lock, flags);
 	value = readl(gpdr);
 	value &= ~BIT(offset % 32);
@@ -94,12 +114,10 @@ static int lnw_gpio_direction_output(struct gpio_chip *chip,
 			unsigned offset, int value)
 {
 	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
-	u8 reg = offset / 32;
+	void __iomem *gpdr = gpio_reg(chip, offset, GPDR);
 	unsigned long flags;
-	void __iomem *gpdr;
 
 	lnw_gpio_set(chip, offset, value);
-	gpdr = (void __iomem *)(&lnw->reg_base->GPDR[reg]);
 	spin_lock_irqsave(&lnw->lock, flags);
 	value = readl(gpdr);
 	value |= BIT(offset % 32);;
@@ -118,11 +136,10 @@ static int lnw_irq_type(unsigned irq, unsigned type)
 {
 	struct lnw_gpio *lnw = get_irq_chip_data(irq);
 	u32 gpio = irq - lnw->irq_base;
-	u8 reg = gpio / 32;
 	unsigned long flags;
 	u32 value;
-	void __iomem *grer = (void __iomem *)(&lnw->reg_base->GRER[reg]);
-	void __iomem *gfer = (void __iomem *)(&lnw->reg_base->GFER[reg]);
+	void __iomem *grer = gpio_reg(&lnw->chip, gpio, GRER);
+	void __iomem *gfer = gpio_reg(&lnw->chip, gpio, GFER);
 
 	if (gpio >= lnw->chip.ngpio)
 		return -EINVAL;
@@ -158,8 +175,10 @@ static struct irq_chip lnw_irqchip = {
 	.set_type	= lnw_irq_type,
 };
 
-static struct pci_device_id lnw_gpio_ids[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080f) },
+static struct pci_device_id lnw_gpio_ids[] = {      /* pin number */
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080f), .driver_data = 64 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x081f), .driver_data = 96 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x081a), .driver_data = 96 },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, lnw_gpio_ids);
@@ -167,17 +186,17 @@ MODULE_DEVICE_TABLE(pci, lnw_gpio_ids);
 static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
 {
 	struct lnw_gpio *lnw = (struct lnw_gpio *)get_irq_data(irq);
-	u32 reg, gpio;
+	u32 base, gpio;
 	void __iomem *gedr;
 	u32 gedr_v;
 
 	/* check GPIO controller to check which pin triggered the interrupt */
-	for (reg = 0; reg < lnw->chip.ngpio / 32; reg++) {
-		gedr = (void __iomem *)(&lnw->reg_base->GEDR[reg]);
+	for (base = 0; base < lnw->chip.ngpio; base += 32) {
+		gedr = gpio_reg(&lnw->chip, base, GEDR);
 		gedr_v = readl(gedr);
 		if (!gedr_v)
 			continue;
-		for (gpio = reg*32; gpio < reg*32+32; gpio++)
+		for (gpio = base; gpio < base + 32; gpio++)
 			if (gedr_v & BIT(gpio % 32)) {
 				pr_debug("pin %d triggered\n", gpio);
 				generic_handle_irq(lnw->irq_base + gpio);
@@ -245,7 +264,7 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 	lnw->chip.set = lnw_gpio_set;
 	lnw->chip.to_irq = lnw_gpio_to_irq;
 	lnw->chip.base = gpio_base;
-	lnw->chip.ngpio = 64;
+	lnw->chip.ngpio = id->driver_data;
 	lnw->chip.can_sleep = 0;
 	pci_set_drvdata(pdev, lnw);
 	retval = gpiochip_add(&lnw->chip);
-- 
1.7.0.4
