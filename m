Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab2DJMEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 08:04:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:24634 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764Ab2DJMEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 08:04:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="139911392"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com
Subject: [PATCH] gpio: langwell: convert to use irq_domain
Date: Tue, 10 Apr 2012 15:05:42 +0300
Message-Id: <1334059542-21517-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_domain already provides a facility to translate from hardware IRQ
numbers to Linux IRQ numbers so use that instead of open-coding the logic
in the driver.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
This applies on top of my 3 previous patches for gpio-langwell.c. I wasn't
sure about selecting IRQ_DOMAIN in the driver Kconfig but it seems not to
cause any problems when I tested this on Medfield based platform.

 drivers/gpio/Kconfig         |    1 +
 drivers/gpio/gpio-langwell.c |   21 +++++++++++++--------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index edadbda..2e8849f 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -399,6 +399,7 @@ config GPIO_BT8XX
 config GPIO_LANGWELL
 	bool "Intel Langwell/Penwell GPIO support"
 	depends on PCI && X86
+	select IRQ_DOMAIN
 	help
 	  Say Y here to support Intel Langwell/Penwell GPIO.
 
diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
index 52f00d3..028c7be 100644
--- a/drivers/gpio/gpio-langwell.c
+++ b/drivers/gpio/gpio-langwell.c
@@ -36,6 +36,7 @@
 #include <linux/gpio.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
+#include <linux/irqdomain.h>
 
 /*
  * Langwell chip has 64 pins and thus there are 2 32bit registers to control
@@ -66,8 +67,8 @@ struct lnw_gpio {
 	struct gpio_chip		chip;
 	void				*reg_base;
 	spinlock_t			lock;
-	unsigned			irq_base;
 	struct pci_dev			*pdev;
+	struct irq_domain		*domain;
 };
 
 static void __iomem *gpio_reg(struct gpio_chip *chip, unsigned offset,
@@ -176,13 +177,13 @@ static int lnw_gpio_direction_output(struct gpio_chip *chip,
 static int lnw_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 {
 	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
-	return lnw->irq_base + offset;
+	return irq_find_mapping(lnw->domain, offset);
 }
 
 static int lnw_irq_type(struct irq_data *d, unsigned type)
 {
 	struct lnw_gpio *lnw = irq_data_get_irq_chip_data(d);
-	u32 gpio = d->irq - lnw->irq_base;
+	u32 gpio = d->hwirq;
 	unsigned long flags;
 	u32 value;
 	void __iomem *grer = gpio_reg(&lnw->chip, gpio, GRER);
@@ -256,7 +257,7 @@ static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
 			pending &= ~mask;
 			/* Clear before handling so we can't lose an edge */
 			writel(mask, gedr);
-			generic_handle_irq(lnw->irq_base + base + gpio);
+			generic_handle_irq(gpio_to_irq(base + gpio));
 		}
 	}
 
@@ -369,7 +370,9 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 		dev_err(&pdev->dev, "can't allocate IRQ descs\n");
 		goto err3;
 	}
-	lnw->irq_base = retval;
+	irq_base = retval;
+	lnw->domain = irq_domain_add_legacy(NULL, ngpio, irq_base, 0,
+					    &irq_domain_simple_ops, NULL);
 
 	lnw->reg_base = base;
 	lnw->chip.label = dev_name(&pdev->dev);
@@ -395,9 +398,11 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 	irq_set_handler_data(pdev->irq, lnw);
 	irq_set_chained_handler(pdev->irq, lnw_irq_handler);
 	for (i = 0; i < lnw->chip.ngpio; i++) {
-		irq_set_chip_and_handler_name(i + lnw->irq_base, &lnw_irqchip,
+		unsigned int irq = irq_find_mapping(lnw->domain, i);
+
+		irq_set_chip_and_handler_name(irq, &lnw_irqchip,
 					      handle_simple_irq, "demux");
-		irq_set_chip_data(i + lnw->irq_base, lnw);
+		irq_set_chip_data(irq, lnw);
 	}
 
 	spin_lock_init(&lnw->lock);
@@ -408,7 +413,7 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 	return 0;
 
 err4:
-	irq_free_descs(lnw->irq_base, ngpio);
+	irq_free_descs(irq_base, ngpio);
 err3:
 	pci_release_regions(pdev);
 err2:
-- 
1.7.9.1

