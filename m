Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab1EDPHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:07:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49083 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab1EDPHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:07:54 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, cbouatmailru@gmail.com, linux@arm.linux.org.uk,
        tglx@linutronix.de, arnd@arndb.de, nico@fluxnic.net,
        alan@lxorguk.ukuu.org.uk, Jamie Iles <jamie@jamieiles.com>
Subject: [RFC PATCH 3/3] gpio/langwell: convert to use basic_mmio_gpio library
Date: Wed,  4 May 2011 16:07:37 +0100
Message-Id: <1304521657-8527-4-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1304521657-8527-1-git-send-email-jamie@jamieiles.com>
References: <1304521657-8527-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the basic_mmio_gpio library for register accessors.  The driver is
now only concerned with hardware initialisation and interrupts.
---
 drivers/gpio/Kconfig         |    1 +
 drivers/gpio/langwell_gpio.c |  253 ++++++++++++++++++++---------------------
 2 files changed, 124 insertions(+), 130 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 898cdb2..a0e3370 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -349,6 +349,7 @@ config GPIO_BT8XX
 config GPIO_LANGWELL
 	bool "Intel Langwell/Penwell GPIO support"
 	depends on PCI && X86
+	select GPIO_BASIC_MMIO_CORE
 	help
 	  Say Y here to support Intel Langwell/Penwell GPIO.
 
diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
index 1b06f67..a2898cd 100644
--- a/drivers/gpio/langwell_gpio.c
+++ b/drivers/gpio/langwell_gpio.c
@@ -33,6 +33,7 @@
 #include <linux/io.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
+#include <linux/basic_mmio_gpio.h>
 
 /*
  * Langwell chip has 64 pins and thus there are 2 32bit registers to control
@@ -58,106 +59,53 @@ enum GPIO_REG {
 	GEDR,		/* edge detect result */
 };
 
-struct lnw_gpio {
-	struct gpio_chip		chip;
-	void				*reg_base;
-	spinlock_t			lock;
+struct lnw_bank {
+	struct bgpio_chip		bgc;
+	void __iomem			*grer, *gfer, *gedr;
 	unsigned			irq_base;
 };
 
-static void __iomem *gpio_reg(struct gpio_chip *chip, unsigned offset,
-			enum GPIO_REG reg_type)
-{
-	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
-	unsigned nreg = chip->ngpio / 32;
-	u8 reg = offset / 32;
-	void __iomem *ptr;
-
-	ptr = (void __iomem *)(lnw->reg_base + reg_type * nreg * 4 + reg * 4);
-	return ptr;
-}
-
-static int lnw_gpio_get(struct gpio_chip *chip, unsigned offset)
-{
-	void __iomem *gplr = gpio_reg(chip, offset, GPLR);
-
-	return readl(gplr) & BIT(offset % 32);
-}
-
-static void lnw_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
-{
-	void __iomem *gpsr, *gpcr;
-
-	if (value) {
-		gpsr = gpio_reg(chip, offset, GPSR);
-		writel(BIT(offset % 32), gpsr);
-	} else {
-		gpcr = gpio_reg(chip, offset, GPCR);
-		writel(BIT(offset % 32), gpcr);
-	}
-}
-
-static int lnw_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+static inline struct lnw_bank *to_lnw_bank(struct bgpio_chip *bgc)
 {
-	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
-	void __iomem *gpdr = gpio_reg(chip, offset, GPDR);
-	u32 value;
-	unsigned long flags;
-
-	spin_lock_irqsave(&lnw->lock, flags);
-	value = readl(gpdr);
-	value &= ~BIT(offset % 32);
-	writel(value, gpdr);
-	spin_unlock_irqrestore(&lnw->lock, flags);
-	return 0;
+	return container_of(bgc, struct lnw_bank, bgc);
 }
 
-static int lnw_gpio_direction_output(struct gpio_chip *chip,
-			unsigned offset, int value)
-{
-	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
-	void __iomem *gpdr = gpio_reg(chip, offset, GPDR);
-	unsigned long flags;
-
-	lnw_gpio_set(chip, offset, value);
-	spin_lock_irqsave(&lnw->lock, flags);
-	value = readl(gpdr);
-	value |= BIT(offset % 32);
-	writel(value, gpdr);
-	spin_unlock_irqrestore(&lnw->lock, flags);
-	return 0;
-}
+struct lnw_gpio {
+	struct lnw_bank			banks[3];
+	int				nr_banks;
+	void __iomem			*reg_base;
+};
 
 static int lnw_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 {
-	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
-	return lnw->irq_base + offset;
+	struct bgpio_chip *bgc = to_bgpio_chip(chip);
+	struct lnw_bank *bank = to_lnw_bank(bgc);
+
+	return bank->irq_base + offset;
 }
 
 static int lnw_irq_type(struct irq_data *d, unsigned type)
 {
-	struct lnw_gpio *lnw = irq_data_get_irq_chip_data(d);
-	u32 gpio = d->irq - lnw->irq_base;
+	struct lnw_bank *bank = irq_data_get_irq_chip_data(d);
+	u32 gpio = d->irq - bank->irq_base;
 	unsigned long flags;
 	u32 value;
-	void __iomem *grer = gpio_reg(&lnw->chip, gpio, GRER);
-	void __iomem *gfer = gpio_reg(&lnw->chip, gpio, GFER);
 
-	if (gpio >= lnw->chip.ngpio)
+	if (gpio >= bank->bgc.gc.ngpio)
 		return -EINVAL;
-	spin_lock_irqsave(&lnw->lock, flags);
+	spin_lock_irqsave(&bank->bgc.lock, flags);
 	if (type & IRQ_TYPE_EDGE_RISING)
-		value = readl(grer) | BIT(gpio % 32);
+		value = readl(bank->grer) | BIT(gpio % 32);
 	else
-		value = readl(grer) & (~BIT(gpio % 32));
-	writel(value, grer);
+		value = readl(bank->grer) & (~BIT(gpio % 32));
+	writel(value, bank->grer);
 
 	if (type & IRQ_TYPE_EDGE_FALLING)
-		value = readl(gfer) | BIT(gpio % 32);
+		value = readl(bank->gfer) | BIT(gpio % 32);
 	else
-		value = readl(gfer) & (~BIT(gpio % 32));
-	writel(value, gfer);
-	spin_unlock_irqrestore(&lnw->lock, flags);
+		value = readl(bank->gfer) & (~BIT(gpio % 32));
+	writel(value, bank->gfer);
+	spin_unlock_irqrestore(&bank->bgc.lock, flags);
 
 	return 0;
 }
@@ -192,30 +140,101 @@ static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
 	u32 base, gpio, mask;
 	unsigned long pending;
-	void __iomem *gedr;
+	int i;
 
 	/* check GPIO controller to check which pin triggered the interrupt */
-	for (base = 0; base < lnw->chip.ngpio; base += 32) {
-		gedr = gpio_reg(&lnw->chip, base, GEDR);
-		pending = readl(gedr);
+	for (base = 0, i = 0; i < lnw->nr_banks; base += 32, i++) {
+		struct lnw_bank *bank = &lnw->banks[i];
+
+		pending = readl(bank->gedr);
 		while (pending) {
 			gpio = __ffs(pending) - 1;
 			mask = BIT(gpio);
 			pending &= ~mask;
 			/* Clear before handling so we can't lose an edge */
-			writel(mask, gedr);
-			generic_handle_irq(lnw->irq_base + base + gpio);
+			writel(mask, bank->gedr);
+			generic_handle_irq(bank->irq_base + gpio);
 		}
 	}
 
 	chip->irq_eoi(data);
 }
 
+static int bank_init(struct lnw_bank *bank, struct device *dev,
+		     void __iomem *reg_base, int bank_nr, int ngpio)
+{
+	unsigned nreg = ngpio / 32;
+	void __iomem *dat = reg_base + GPLR * nreg * 4 + bank_nr * 4;
+	void __iomem *dirout = reg_base + GPDR * nreg * 4 + bank_nr * 4;
+	void __iomem *set = reg_base + GPSR * nreg * 4 + bank_nr * 4;
+	void __iomem *clr = reg_base + GPCR * nreg * 4 + bank_nr * 4;
+
+	bank->grer = reg_base + GRER * nreg * 4 + bank_nr * 4;
+	bank->gfer = reg_base + GFER * nreg * 4 + bank_nr * 4;
+	bank->gedr = reg_base + GEDR * nreg * 4 + bank_nr * 4;
+
+	return bgpio_init(&bank->bgc, dev, 4, dat, set, clr, dirout, NULL, 0);
+}
+
+static int lnw_init_banks(struct lnw_gpio *lnw, int nr_banks,
+			  struct device *dev, int irq_base, int gpio_base)
+{
+	int retval, i;
+	lnw->nr_banks = nr_banks;
+
+	for (i = 0; i < lnw->nr_banks; i++) {
+		struct lnw_bank *bank = &lnw->banks[i];
+		int j;
+
+		retval = bank_init(bank, dev, lnw->reg_base, i, nr_banks * 32);
+		if (retval) {
+			dev_err(dev, "langwell failed to init bank %d (%d)\n",
+				i, retval);
+			goto out_remove;
+		}
+		bank->bgc.gc.ngpio = 32;
+		bank->bgc.gc.base = gpio_base + i * 32;
+
+		if (irq_base > 0) {
+			bank->irq_base = irq_base + i * 32;
+			bank->bgc.gc.to_irq = lnw_gpio_to_irq;
+			for (j = 0; j < 32; j++) {
+				irq_set_chip_and_handler_name(
+					j + bank->irq_base, &lnw_irqchip,
+					handle_simple_irq, "demux");
+				irq_set_chip_data(j + bank->irq_base, bank);
+			}
+		}
+
+		retval = gpiochip_add(&bank->bgc.gc);
+		if (retval) {
+			dev_err(dev, "langwell gpiochip_add error %d\n",
+				retval);
+			goto out_remove;
+		}
+	}
+
+	return 0;
+
+out_remove:
+	while (--i >= 0) {
+		int j;
+		struct lnw_bank *bank = &lnw->banks[i];
+		bgpio_remove(&bank->bgc);
+		if (irq_base > 0) {
+			for (j = 0; j < 32; ++j)
+				irq_set_chip_and_handler(j + bank->irq_base,
+							 NULL, NULL);
+		}
+	}
+
+	return retval;
+}
+
 static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
-			const struct pci_device_id *id)
+				    const struct pci_device_id *id)
 {
 	void *base;
-	int i;
 	resource_size_t start, len;
 	struct lnw_gpio *lnw;
 	u32 irq_base;
@@ -259,32 +278,17 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 		retval = -ENOMEM;
 		goto err4;
 	}
+
 	lnw->reg_base = base;
-	lnw->irq_base = irq_base;
-	lnw->chip.label = dev_name(&pdev->dev);
-	lnw->chip.direction_input = lnw_gpio_direction_input;
-	lnw->chip.direction_output = lnw_gpio_direction_output;
-	lnw->chip.get = lnw_gpio_get;
-	lnw->chip.set = lnw_gpio_set;
-	lnw->chip.to_irq = lnw_gpio_to_irq;
-	lnw->chip.base = gpio_base;
-	lnw->chip.ngpio = id->driver_data;
-	lnw->chip.can_sleep = 0;
-	pci_set_drvdata(pdev, lnw);
-	retval = gpiochip_add(&lnw->chip);
-	if (retval) {
-		dev_err(&pdev->dev, "langwell gpiochip_add error %d\n", retval);
+	retval = lnw_init_banks(lnw, id->driver_data / 32, &pdev->dev,
+				irq_base, gpio_base);
+	if (retval)
 		goto err5;
-	}
+
+	pci_set_drvdata(pdev, lnw);
 	irq_set_handler_data(pdev->irq, lnw);
 	irq_set_chained_handler(pdev->irq, lnw_irq_handler);
-	for (i = 0; i < lnw->chip.ngpio; i++) {
-		irq_set_chip_and_handler_name(i + lnw->irq_base, &lnw_irqchip,
-					      handle_simple_irq, "demux");
-		irq_set_chip_data(i + lnw->irq_base, lnw);
-	}
 
-	spin_lock_init(&lnw->lock);
 	goto done;
 err5:
 	kfree(lnw);
@@ -304,11 +308,9 @@ static struct pci_driver lnw_gpio_driver = {
 	.probe		= lnw_gpio_probe,
 };
 
-
 static int __devinit wp_gpio_probe(struct platform_device *pdev)
 {
 	struct lnw_gpio *lnw;
-	struct gpio_chip *gc;
 	struct resource *rc;
 	int retval = 0;
 
@@ -327,24 +329,10 @@ static int __devinit wp_gpio_probe(struct platform_device *pdev)
 		retval = -EINVAL;
 		goto err_kmalloc;
 	}
-	spin_lock_init(&lnw->lock);
-	gc = &lnw->chip;
-	gc->label = dev_name(&pdev->dev);
-	gc->owner = THIS_MODULE;
-	gc->direction_input = lnw_gpio_direction_input;
-	gc->direction_output = lnw_gpio_direction_output;
-	gc->get = lnw_gpio_get;
-	gc->set = lnw_gpio_set;
-	gc->to_irq = NULL;
-	gc->base = 0;
-	gc->ngpio = 64;
-	gc->can_sleep = 0;
-	retval = gpiochip_add(gc);
-	if (retval) {
-		dev_err(&pdev->dev, "whitneypoint gpiochip_add error %d\n",
-								retval);
+
+	retval = lnw_init_banks(lnw, 2, &pdev->dev, -1, 0);
+	if (retval)
 		goto err_ioremap;
-	}
 	platform_set_drvdata(pdev, lnw);
 	return 0;
 err_ioremap:
@@ -357,10 +345,15 @@ err_kmalloc:
 static int __devexit wp_gpio_remove(struct platform_device *pdev)
 {
 	struct lnw_gpio *lnw = platform_get_drvdata(pdev);
-	int err;
-	err = gpiochip_remove(&lnw->chip);
-	if (err)
-		dev_err(&pdev->dev, "failed to remove gpio_chip.\n");
+	int i, err;
+
+	for (i = 0; i < lnw->nr_banks; ++i) {
+		struct lnw_bank *bank = &lnw->banks[i];
+
+		err = bgpio_remove(&bank->bgc);
+		if (err)
+			dev_err(&pdev->dev, "failed to remove gpio_chip.\n");
+	}
 	iounmap(lnw->reg_base);
 	kfree(lnw);
 	platform_set_drvdata(pdev, NULL);
-- 
1.7.4.4

