Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab2LTWpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 17:45:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:15177 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab2LTWoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 17:44:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,326,1355126400"; 
   d="scan'208";a="268018222"
From: David Cohen <david.a.cohen@intel.com>
To: grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        David Cohen <david.a.cohen@intel.com>
Subject: [PATCH v2 1/2] gpio-langwell: cleanup driver
Date: Thu, 20 Dec 2012 14:45:51 -0800
Message-Id: <1356043552-14579-2-git-send-email-david.a.cohen@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1356043552-14579-1-git-send-email-david.a.cohen@intel.com>
References: <1356043552-14579-1-git-send-email-david.a.cohen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up cosmetic issues, remove useless functions and add
to_lnw_priv() macro to replace many usages of container_of().

Change-Id: I70a8fadd20a42493271d91633739bdddff19c8d8
Signed-off-by: David Cohen <david.a.cohen@intel.com>
---
 drivers/gpio/gpio-langwell.c |   51 ++++++++++++++----------------------------
 1 file changed, 17 insertions(+), 34 deletions(-)

diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
index 9b9d12e..2be69fe 100644
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
 
@@ -301,17 +303,6 @@ static const struct irq_domain_ops lnw_gpio_irq_ops = {
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
@@ -322,16 +313,8 @@ static int lnw_gpio_runtime_idle(struct device *dev)
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
@@ -351,7 +334,7 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 	retval = pci_request_regions(pdev, "langwell_gpio");
 	if (retval) {
 		dev_err(&pdev->dev, "error requesting resources\n");
-		goto err2;
+		goto err_pci_req_region;
 	}
 	/* get the gpio_base from bar1 */
 	start = pci_resource_start(pdev, 1);
@@ -360,7 +343,7 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 	if (!base) {
 		dev_err(&pdev->dev, "error mapping bar1\n");
 		retval = -EFAULT;
-		goto err3;
+		goto err_ioremap;
 	}
 	gpio_base = *((u32 *)base + 1);
 	/* release the IO mapping, since we already get the info from bar1 */
@@ -372,21 +355,21 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 	if (!base) {
 		dev_err(&pdev->dev, "error mapping bar0\n");
 		retval = -EFAULT;
-		goto err3;
+		goto err_ioremap;
 	}
 
-	lnw = devm_kzalloc(&pdev->dev, sizeof(struct lnw_gpio), GFP_KERNEL);
+	lnw = devm_kzalloc(&pdev->dev, sizeof(*lnw), GFP_KERNEL);
 	if (!lnw) {
 		dev_err(&pdev->dev, "can't allocate langwell_gpio chip data\n");
 		retval = -ENOMEM;
-		goto err3;
+		goto err_ioremap;
 	}
 
 	lnw->domain = irq_domain_add_linear(pdev->dev.of_node, ngpio,
 					    &lnw_gpio_irq_ops, lnw);
 	if (!lnw->domain) {
 		retval = -ENOMEM;
-		goto err3;
+		goto err_ioremap;
 	}
 
 	lnw->reg_base = base;
@@ -405,7 +388,7 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 	retval = gpiochip_add(&lnw->chip);
 	if (retval) {
 		dev_err(&pdev->dev, "langwell gpiochip_add error %d\n", retval);
-		goto err3;
+		goto err_ioremap;
 	}
 
 	lnw_irq_init_hw(lnw);
@@ -420,9 +403,9 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 
 	return 0;
 
-err3:
+err_ioremap:
 	pci_release_regions(pdev);
-err2:
+err_pci_req_region:
 	pci_disable_device(pdev);
 	return retval;
 }
-- 
1.7.10.4

