Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab2EBIOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 04:14:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:20645 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab2EBIOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 04:14:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="139073499"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v3] gpio: langwell: convert to use irq_domain
Date: Wed,  2 May 2012 11:15:50 +0300
Message-Id: <1335946550-3092-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_domain already provides a facility to translate from hardware IRQ
numbers to Linux IRQ numbers so use that instead of open-coding the logic
in the driver.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
Changes to v2:
	- use irq_find_mapping() instead of gpio_to_irq()
	- remove irq_base as it is not used anymore

Changes to v1:
	- use linear mapping instead of legacy as suggested by Grant

 drivers/gpio/Kconfig         |    1 +
 drivers/gpio/gpio-langwell.c |   50 ++++++++++++++++++++++++-----------------
 2 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index e03653d..0a85d95 100644
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
index 52f00d3..b067357 100644
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
+	return irq_create_mapping(lnw->domain, offset);
 }
 
 static int lnw_irq_type(struct irq_data *d, unsigned type)
 {
 	struct lnw_gpio *lnw = irq_data_get_irq_chip_data(d);
-	u32 gpio = d->irq - lnw->irq_base;
+	u32 gpio = irqd_to_hwirq(d);
 	unsigned long flags;
 	u32 value;
 	void __iomem *grer = gpio_reg(&lnw->chip, gpio, GRER);
@@ -256,7 +257,8 @@ static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
 			pending &= ~mask;
 			/* Clear before handling so we can't lose an edge */
 			writel(mask, gedr);
-			generic_handle_irq(lnw->irq_base + base + gpio);
+			generic_handle_irq(irq_find_mapping(lnw->domain,
+							    base + gpio));
 		}
 	}
 
@@ -281,6 +283,24 @@ static void lnw_irq_init_hw(struct lnw_gpio *lnw)
 	}
 }
 
+static int lnw_gpio_irq_map(struct irq_domain *d, unsigned int virq,
+			    irq_hw_number_t hw)
+{
+	struct lnw_gpio *lnw = d->host_data;
+
+	irq_set_chip_and_handler_name(virq, &lnw_irqchip, handle_simple_irq,
+				      "demux");
+	irq_set_chip_data(virq, lnw);
+	irq_set_irq_type(virq, IRQ_TYPE_NONE);
+
+	return 0;
+}
+
+static const struct irq_domain_ops lnw_gpio_irq_ops = {
+	.map = lnw_gpio_irq_map,
+	.xlate = irq_domain_xlate_twocell,
+};
+
 #ifdef CONFIG_PM
 static int lnw_gpio_runtime_resume(struct device *dev)
 {
@@ -318,10 +338,8 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 			const struct pci_device_id *id)
 {
 	void *base;
-	int i;
 	resource_size_t start, len;
 	struct lnw_gpio *lnw;
-	u32 irq_base;
 	u32 gpio_base;
 	int retval = 0;
 	int ngpio = id->driver_data;
@@ -335,7 +353,7 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 		dev_err(&pdev->dev, "error requesting resources\n");
 		goto err2;
 	}
-	/* get the irq_base from bar1 */
+	/* get the gpio_base from bar1 */
 	start = pci_resource_start(pdev, 1);
 	len = pci_resource_len(pdev, 1);
 	base = ioremap_nocache(start, len);
@@ -343,7 +361,6 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 		dev_err(&pdev->dev, "error mapping bar1\n");
 		goto err3;
 	}
-	irq_base = *(u32 *)base;
 	gpio_base = *((u32 *)base + 1);
 	/* release the IO mapping, since we already get the info from bar1 */
 	iounmap(base);
@@ -364,12 +381,10 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 		goto err3;
 	}
 
-	retval = irq_alloc_descs(-1, irq_base, ngpio, 0);
-	if (retval < 0) {
-		dev_err(&pdev->dev, "can't allocate IRQ descs\n");
+	lnw->domain = irq_domain_add_linear(pdev->dev.of_node, ngpio,
+					    &lnw_gpio_irq_ops, lnw);
+	if (!lnw->domain)
 		goto err3;
-	}
-	lnw->irq_base = retval;
 
 	lnw->reg_base = base;
 	lnw->chip.label = dev_name(&pdev->dev);
@@ -387,18 +402,13 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 	retval = gpiochip_add(&lnw->chip);
 	if (retval) {
 		dev_err(&pdev->dev, "langwell gpiochip_add error %d\n", retval);
-		goto err4;
+		goto err3;
 	}
 
 	lnw_irq_init_hw(lnw);
 
 	irq_set_handler_data(pdev->irq, lnw);
 	irq_set_chained_handler(pdev->irq, lnw_irq_handler);
-	for (i = 0; i < lnw->chip.ngpio; i++) {
-		irq_set_chip_and_handler_name(i + lnw->irq_base, &lnw_irqchip,
-					      handle_simple_irq, "demux");
-		irq_set_chip_data(i + lnw->irq_base, lnw);
-	}
 
 	spin_lock_init(&lnw->lock);
 
@@ -407,8 +417,6 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 
 	return 0;
 
-err4:
-	irq_free_descs(lnw->irq_base, ngpio);
 err3:
 	pci_release_regions(pdev);
 err2:
-- 
1.7.9.1

