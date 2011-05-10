Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab1EJNks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 09:40:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47621 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753006Ab1EJNkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 09:40:47 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH] langwell_gpio: add runtime pm support
To: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Date: Tue, 10 May 2011 14:23:45 +0100
Message-ID: <20110510132318.31013.78989.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kristen Carlson Accardi <kristen@linux.intel.com>

While this is essentially a no-op for this driver, it has the
side effect of letting the PMU driver snoop D3 requests from
the PCI core for this driver.

This is only for langwell, not for whitney point.

Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>

[This went me->Dirk->me->upstream before the signed off confuses]
---

 drivers/gpio/langwell_gpio.c |   65 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
index 560ab64..6f88e37 100644
--- a/drivers/gpio/langwell_gpio.c
+++ b/drivers/gpio/langwell_gpio.c
@@ -33,6 +33,7 @@
 #include <linux/io.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 
 /*
  * Langwell chip has 64 pins and thus there are 2 32bit registers to control
@@ -63,6 +64,7 @@ struct lnw_gpio {
 	void				*reg_base;
 	spinlock_t			lock;
 	unsigned			irq_base;
+	struct pci_dev			*pdev;
 };
 
 static void __iomem *gpio_reg(struct gpio_chip *chip, unsigned offset,
@@ -104,11 +106,18 @@ static int lnw_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
 	u32 value;
 	unsigned long flags;
 
+	if (lnw->pdev)
+		pm_runtime_get(&lnw->pdev->dev);
+
 	spin_lock_irqsave(&lnw->lock, flags);
 	value = readl(gpdr);
 	value &= ~BIT(offset % 32);
 	writel(value, gpdr);
 	spin_unlock_irqrestore(&lnw->lock, flags);
+
+	if (lnw->pdev)
+		pm_runtime_put(&lnw->pdev->dev);
+
 	return 0;
 }
 
@@ -120,11 +129,19 @@ static int lnw_gpio_direction_output(struct gpio_chip *chip,
 	unsigned long flags;
 
 	lnw_gpio_set(chip, offset, value);
+
+	if (lnw->pdev)
+		pm_runtime_get(&lnw->pdev->dev);
+
 	spin_lock_irqsave(&lnw->lock, flags);
 	value = readl(gpdr);
 	value |= BIT(offset % 32);;
 	writel(value, gpdr);
 	spin_unlock_irqrestore(&lnw->lock, flags);
+
+	if (lnw->pdev)
+		pm_runtime_put(&lnw->pdev->dev);
+
 	return 0;
 }
 
@@ -145,6 +162,10 @@ static int lnw_irq_type(struct irq_data *d, unsigned type)
 
 	if (gpio >= lnw->chip.ngpio)
 		return -EINVAL;
+
+	if (lnw->pdev)
+		pm_runtime_get(&lnw->pdev->dev);
+
 	spin_lock_irqsave(&lnw->lock, flags);
 	if (type & IRQ_TYPE_EDGE_RISING)
 		value = readl(grer) | BIT(gpio % 32);
@@ -159,6 +180,9 @@ static int lnw_irq_type(struct irq_data *d, unsigned type)
 	writel(value, gfer);
 	spin_unlock_irqrestore(&lnw->lock, flags);
 
+	if (lnw->pdev)
+		pm_runtime_put(&lnw->pdev->dev);
+
 	return 0;
 }
 
@@ -211,6 +235,39 @@ static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
 	chip->irq_eoi(data);
 }
 
+#ifdef CONFIG_PM
+static int lnw_gpio_runtime_resume(struct device *dev)
+{
+	return 0;
+}
+
+static int lnw_gpio_runtime_suspend(struct device *dev)
+{
+	return 0;
+}
+
+static int lnw_gpio_runtime_idle(struct device *dev)
+{
+	int err = pm_schedule_suspend(dev, 500);
+
+	if (!err)
+		return 0;
+
+	return -EBUSY;
+}
+
+#else
+#define lnw_gpio_runtime_suspend	NULL
+#define lnw_gpio_runtime_resume		NULL
+#define lnw_gpio_runtime_idle		NULL
+#endif
+
+static const struct dev_pm_ops lnw_gpio_pm_ops = {
+	.runtime_suspend = lnw_gpio_runtime_suspend,
+	.runtime_resume = lnw_gpio_runtime_resume,
+	.runtime_idle = lnw_gpio_runtime_idle,
+};
+
 static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 			const struct pci_device_id *id)
 {
@@ -270,6 +327,7 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 	lnw->chip.base = gpio_base;
 	lnw->chip.ngpio = id->driver_data;
 	lnw->chip.can_sleep = 0;
+	lnw->pdev = pdev;
 	pci_set_drvdata(pdev, lnw);
 	retval = gpiochip_add(&lnw->chip);
 	if (retval) {
@@ -285,6 +343,10 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 	}
 
 	spin_lock_init(&lnw->lock);
+
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_allow(&pdev->dev);
+
 	goto done;
 err5:
 	kfree(lnw);
@@ -302,6 +364,9 @@ static struct pci_driver lnw_gpio_driver = {
 	.name		= "langwell_gpio",
 	.id_table	= lnw_gpio_ids,
 	.probe		= lnw_gpio_probe,
+	.driver		= {
+		.pm	= &lnw_gpio_pm_ops,
+	},
 };
 
 

