Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab1HEWPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 18:15:45 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37603 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab1HEWPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 18:15:43 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Arnd Bergmann <arnd@arndb.de>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 1/2] gpio/tegra: Remove use of irq_to_gpio
Date: Fri,  5 Aug 2011 16:15:33 -0600
Message-Id: <1312582534-10871-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_to_gpio is being removed. Replace the only use of that API by
the ARM Tegra sub-architecture.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
This patch depends on changes in Grant's gpio/next tree: at least the
move from arch/arm/mach-tegra/gpio.c to drivers/gpio/gpio-tegra.c.

 drivers/gpio/gpio-tegra.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index 747eb40..7b9663b 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -331,6 +331,7 @@ static struct lock_class_key gpio_lock_class;
 static int __init tegra_gpio_init(void)
 {
 	struct tegra_gpio_bank *bank;
+	int gpio;
 	int i;
 	int j;
 
@@ -352,14 +353,17 @@ static int __init tegra_gpio_init(void)
 
 	gpiochip_add(&tegra_gpio_chip);
 
-	for (i = INT_GPIO_BASE; i < (INT_GPIO_BASE + TEGRA_NR_GPIOS); i++) {
-		bank = &tegra_gpio_banks[GPIO_BANK(irq_to_gpio(i))];
+	for (gpio = 0; gpio < TEGRA_NR_GPIOS; gpio++) {
+		int irq = gpio_to_irq(gpio);
+		/* No validity check; all Tegra GPIOs are valid IRQs */
 
-		irq_set_lockdep_class(i, &gpio_lock_class);
-		irq_set_chip_data(i, bank);
-		irq_set_chip_and_handler(i, &tegra_gpio_irq_chip,
+		bank = &tegra_gpio_banks[GPIO_BANK(gpio)];
+
+		irq_set_lockdep_class(irq, &gpio_lock_class);
+		irq_set_chip_data(irq, bank);
+		irq_set_chip_and_handler(irq, &tegra_gpio_irq_chip,
 					 handle_simple_irq);
-		set_irq_flags(i, IRQF_VALID);
+		set_irq_flags(irq, IRQF_VALID);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(tegra_gpio_banks); i++) {
-- 
1.7.0.4

