Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255Ab2JSKyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:54:20 -0400
Received: from mail.df.lth.se ([194.47.250.12]:21817 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757502Ab2JSKyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:54:15 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 4/4 v2] gpio/tegra: convert to use linear irqdomain
Date: Fri, 19 Oct 2012 12:54:12 +0200
Message-Id: <1350644052-31926-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Tegra driver tries to do the work of irq_domain_add_linear()
by reserving a bunch of descriptors somewhere and keeping track
of the base offset, then calling irq_domain_add_legacy(). Let's
stop doing that and simply use the linear IRQ domain.

For this to work: use irq_create_mapping() in the IRQ iterator
so that the descriptors get allocated here.

Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Make sure that irq_create_mapping() is called for every IRQ
  on probe() and update the commit message.
---
 drivers/gpio/gpio-tegra.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index d982593..c7c175a 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -380,7 +380,6 @@ static int __devinit tegra_gpio_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *match;
 	struct tegra_gpio_soc_config *config;
-	int irq_base;
 	struct resource *res;
 	struct tegra_gpio_bank *bank;
 	int gpio;
@@ -417,14 +416,11 @@ static int __devinit tegra_gpio_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	irq_base = irq_alloc_descs(-1, 0, tegra_gpio_chip.ngpio, 0);
-	if (irq_base < 0) {
-		dev_err(&pdev->dev, "Couldn't allocate IRQ numbers\n");
-		return -ENODEV;
-	}
-	irq_domain = irq_domain_add_legacy(pdev->dev.of_node,
-					   tegra_gpio_chip.ngpio, irq_base, 0,
+	irq_domain = irq_domain_add_linear(pdev->dev.of_node,
+					   tegra_gpio_chip.ngpio,
 					   &irq_domain_simple_ops, NULL);
+	if (!irq_domain)
+		return -ENODEV;
 
 	for (i = 0; i < tegra_gpio_bank_count; i++) {
 		res = platform_get_resource(pdev, IORESOURCE_IRQ, i);
@@ -464,7 +460,7 @@ static int __devinit tegra_gpio_probe(struct platform_device *pdev)
 	gpiochip_add(&tegra_gpio_chip);
 
 	for (gpio = 0; gpio < tegra_gpio_chip.ngpio; gpio++) {
-		int irq = irq_find_mapping(irq_domain, gpio);
+		int irq = irq_create_mapping(irq_domain, gpio);
 		/* No validity check; all Tegra GPIOs are valid IRQs */
 
 		bank = &tegra_gpio_banks[GPIO_BANK(gpio)];
-- 
1.7.11.7

