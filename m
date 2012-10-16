Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab2JPTdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:33:14 -0400
Received: from mail.df.lth.se ([194.47.250.12]:44919 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961Ab2JPTdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:33:08 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 7/7] gpio/tegra: convert to use linear irqdomain
Date: Tue, 16 Oct 2012 21:23:33 +0200
Message-Id: <1350415413-3723-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MXS driver tries to do the work of irq_domain_add_linear()
by reserving a bunch of descriptors somewhere and keeping track
of the base offset, then calling irq_domain_add_legacy(). Let's
stop doing that and simply use the linear IRQ domain.

Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpio-tegra.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index d982593..0234162 100644
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
-- 
1.7.11.7

