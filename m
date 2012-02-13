Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257Ab2BMXVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 18:21:21 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7489 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab2BMXVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 18:21:18 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 13 Feb 2012 15:21:18 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] gpio: tegra: Fix build issue due to irq_domain rework.
Date: Mon, 13 Feb 2012 16:21:15 -0700
Message-Id: <1329175275-19404-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7da5a66 "irq_domain: Remove 'new' irq_domain in favour of the
ppc one" changed the set of available irq domain APIs. Update the Tegra
GPIO driver to account for those changes, to solve a build break.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
With this patch, next-20120206 works. There are one or two other issues
that prevent more recent nexts from working though; I'm still tracking
those down. However, I think this patch is fine by itself, since it solves
all issues in next-20120206.

 drivers/gpio/gpio-tegra.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index 98f3980..6f17671 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -75,7 +75,7 @@ struct tegra_gpio_bank {
 #endif
 };
 
-static struct irq_domain irq_domain;
+static struct irq_domain *irq_domain;
 static void __iomem *regs;
 static u32 tegra_gpio_bank_count;
 static struct tegra_gpio_bank *tegra_gpio_banks;
@@ -141,7 +141,7 @@ static int tegra_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
 
 static int tegra_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 {
-	return irq_domain_to_irq(&irq_domain, offset);
+	return irq_find_mapping(irq_domain, offset);
 }
 
 static struct gpio_chip tegra_gpio_chip = {
@@ -372,11 +372,9 @@ static int __devinit tegra_gpio_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "Couldn't allocate IRQ numbers\n");
 		return -ENODEV;
 	}
-	irq_domain.irq_base = irq_base;
-	irq_domain.nr_irq = tegra_gpio_chip.ngpio;
-	irq_domain.ops = &irq_domain_simple_ops;
-	irq_domain.of_node = pdev->dev.of_node;
-	irq_domain_add(&irq_domain);
+	irq_domain = irq_domain_add_legacy(pdev->dev.of_node,
+					   tegra_gpio_chip.ngpio, irq_base, 0,
+					   &irq_domain_simple_ops, NULL);
 
 	for (i = 0; i < tegra_gpio_bank_count; i++) {
 		res = platform_get_resource(pdev, IORESOURCE_IRQ, i);
@@ -416,7 +414,7 @@ static int __devinit tegra_gpio_probe(struct platform_device *pdev)
 	gpiochip_add(&tegra_gpio_chip);
 
 	for (gpio = 0; gpio < tegra_gpio_chip.ngpio; gpio++) {
-		int irq = irq_domain_to_irq(&irq_domain, gpio);
+		int irq = irq_find_mapping(irq_domain, gpio);
 		/* No validity check; all Tegra GPIOs are valid IRQs */
 
 		bank = &tegra_gpio_banks[GPIO_BANK(gpio)];
-- 
1.7.0.4

