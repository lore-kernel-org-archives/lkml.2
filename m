Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab2LSBwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 20:52:31 -0500
Received: from mga03.intel.com ([143.182.124.21]:50674 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237Ab2LSBwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 20:52:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,313,1355126400"; 
   d="scan'208";a="233627000"
From: David Cohen <david.a.cohen@intel.com>
To: grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        David Cohen <david.a.cohen@intel.com>
Subject: [PATCH 1/3] gpio-langwell: cleanup driver
Date: Tue, 18 Dec 2012 17:52:11 -0800
Message-Id: <1355881933-15182-2-git-send-email-david.a.cohen@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355881933-15182-1-git-send-email-david.a.cohen@intel.com>
References: <1355881933-15182-1-git-send-email-david.a.cohen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up cosmetic issues, remove useless functions and add
to_lnw_priv() macro to replace many usages of container_of().

Change-Id: I70a8fadd20a42493271d91633739bdddff19c8d8
Signed-off-by: David Cohen <david.a.cohen@intel.com>
---
 drivers/gpio/gpio-langwell.c |   64 ++++++++++++++----------------------------
 1 file changed, 21 insertions(+), 43 deletions(-)

diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
index 202a992..8220c04 100644
--- a/drivers/gpio/gpio-langwell.c
+++ b/drivers/gpio/gpio-langwell.c
@@ -71,10 +71,12 @@ struct lnw_gpio {
 	struct irq_domain		*domain;
 };
 
+#define to_lnw_priv(chip)	container_of(chip, struct lnw_gpio, chip)
+
 static void __iomem *gpio_reg(struct gpio_chip *chip, unsigned offset,
 			enum GPIO_REG reg_type)
 {
-	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
+	struct lnw_gpio *lnw = to_lnw_priv(chip);
 	unsigned nreg = chip->ngpio / 32;
 	u8 reg = offset / 32;
 	void __iomem *ptr;
@@ -86,7 +88,7 @@ static void __iomem *gpio_reg(struct gpio_chip *chip, unsigned offset,
 static void __iomem *gpio_reg_2bit(struct gpio_chip *chip, unsigned offset,
 				   enum GPIO_REG reg_type)
 {
-	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
+	struct lnw_gpio *lnw = to_lnw_priv(chip);
 	unsigned nreg = chip->ngpio / 32;
 	u8 reg = offset / 16;
 	void __iomem *ptr;
@@ -130,7 +132,7 @@ static void lnw_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 
 static int lnw_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
 {
-	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
+	struct lnw_gpio *lnw = to_lnw_priv(chip);
 	void __iomem *gpdr = gpio_reg(chip, offset, GPDR);
 	u32 value;
 	unsigned long flags;
@@ -153,7 +155,7 @@ static int lnw_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
 static int lnw_gpio_direction_output(struct gpio_chip *chip,
 			unsigned offset, int value)
 {
-	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
+	struct lnw_gpio *lnw = to_lnw_priv(chip);
 	void __iomem *gpdr = gpio_reg(chip, offset, GPDR);
 	unsigned long flags;
 
@@ -176,7 +178,7 @@ static int lnw_gpio_direction_output(struct gpio_chip *chip,
 
 static int lnw_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 {
-	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
+	struct lnw_gpio *lnw = to_lnw_priv(chip);
 	return irq_create_mapping(lnw->domain, offset);
 }
 
@@ -215,19 +217,14 @@ static int lnw_irq_type(struct irq_data *d, unsigned type)
 	return 0;
 }
 
-static void lnw_irq_unmask(struct irq_data *d)
-{
-}
-
-static void lnw_irq_mask(struct irq_data *d)
-{
-}
+static void lnw_irq_noop(struct irq_data *d) {}
 
 static struct irq_chip lnw_irqchip = {
 	.name		= "LNW-GPIO",
-	.irq_mask	= lnw_irq_mask,
-	.irq_unmask	= lnw_irq_unmask,
+	.irq_mask	= lnw_irq_noop,
+	.irq_unmask	= lnw_irq_noop,
 	.irq_set_type	= lnw_irq_type,
+	.irq_ack	= lnw_irq_noop,
 };
 
 static DEFINE_PCI_DEVICE_TABLE(lnw_gpio_ids) = {   /* pin number */
@@ -299,17 +296,6 @@ static const struct irq_domain_ops lnw_gpio_irq_ops = {
 	.xlate = irq_domain_xlate_twocell,
 };
 
-#ifdef CONFIG_PM
-static int lnw_gpio_runtime_resume(struct device *dev)
-{
-	return 0;
-}
-
-static int lnw_gpio_runtime_suspend(struct device *dev)
-{
-	return 0;
-}
-
 static int lnw_gpio_runtime_idle(struct device *dev)
 {
 	int err = pm_schedule_suspend(dev, 500);
@@ -320,16 +306,8 @@ static int lnw_gpio_runtime_idle(struct device *dev)
 	return -EBUSY;
 }
 
-#else
-#define lnw_gpio_runtime_suspend	NULL
-#define lnw_gpio_runtime_resume		NULL
-#define lnw_gpio_runtime_idle		NULL
-#endif
-
 static const struct dev_pm_ops lnw_gpio_pm_ops = {
-	.runtime_suspend = lnw_gpio_runtime_suspend,
-	.runtime_resume = lnw_gpio_runtime_resume,
-	.runtime_idle = lnw_gpio_runtime_idle,
+	SET_RUNTIME_PM_OPS(NULL, NULL, lnw_gpio_runtime_idle)
 };
 
 static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
@@ -349,7 +327,7 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 	retval = pci_request_regions(pdev, "langwell_gpio");
 	if (retval) {
 		dev_err(&pdev->dev, "error requesting resources\n");
-		goto err2;
+		goto err;
 	}
 	/* get the gpio_base from bar1 */
 	start = pci_resource_start(pdev, 1);
@@ -358,7 +336,7 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 	if (!base) {
 		dev_err(&pdev->dev, "error mapping bar1\n");
 		retval = -EFAULT;
-		goto err3;
+		goto err2;
 	}
 	gpio_base = *((u32 *)base + 1);
 	/* release the IO mapping, since we already get the info from bar1 */
@@ -370,21 +348,21 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 	if (!base) {
 		dev_err(&pdev->dev, "error mapping bar0\n");
 		retval = -EFAULT;
-		goto err3;
+		goto err2;
 	}
 
-	lnw = devm_kzalloc(&pdev->dev, sizeof(struct lnw_gpio), GFP_KERNEL);
+	lnw = devm_kzalloc(&pdev->dev, sizeof(*lnw), GFP_KERNEL);
 	if (!lnw) {
 		dev_err(&pdev->dev, "can't allocate langwell_gpio chip data\n");
 		retval = -ENOMEM;
-		goto err3;
+		goto err2;
 	}
 
 	lnw->domain = irq_domain_add_linear(pdev->dev.of_node, ngpio,
 					    &lnw_gpio_irq_ops, lnw);
 	if (!lnw->domain) {
 		retval = -ENOMEM;
-		goto err3;
+		goto err2;
 	}
 
 	lnw->reg_base = base;
@@ -403,7 +381,7 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 	retval = gpiochip_add(&lnw->chip);
 	if (retval) {
 		dev_err(&pdev->dev, "langwell gpiochip_add error %d\n", retval);
-		goto err3;
+		goto err2;
 	}
 
 	lnw_irq_init_hw(lnw);
@@ -418,9 +396,9 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 
 	return 0;
 
-err3:
-	pci_release_regions(pdev);
 err2:
+	pci_release_regions(pdev);
+err:
 	pci_disable_device(pdev);
 	return retval;
 }
-- 
1.7.10.4

