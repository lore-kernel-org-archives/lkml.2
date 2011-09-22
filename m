Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab1IVVGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 17:06:55 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44080 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab1IVVGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 17:06:24 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@fluxnic.net>,
        Olof Johansson <olof@lixom.net>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-tegra@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 3/4] gpio/tegra: Convert to a platform device
Date: Thu, 22 Sep 2011 15:06:06 -0600
Message-Id: <1316725567-17881-4-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316725567-17881-1-git-send-email-swarren@nvidia.com>
References: <1316725567-17881-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
See patch 0000 for details on dependencies.

 drivers/gpio/gpio-tegra.c |   31 ++++++++++++++++++++-----------
 1 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index 6b65207..849da25 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -20,10 +20,10 @@
 #include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
-
 #include <linux/io.h>
 #include <linux/gpio.h>
 #include <linux/of.h>
+#include <linux/platform_device.h>
 
 #include <asm/mach/irq.h>
 
@@ -333,7 +333,7 @@ static struct irq_chip tegra_gpio_irq_chip = {
  */
 static struct lock_class_key gpio_lock_class;
 
-static int __init tegra_gpio_init(void)
+static int __init tegra_gpio_probe(struct platform_device *pdev)
 {
 	struct tegra_gpio_bank *bank;
 	int gpio;
@@ -347,15 +347,6 @@ static int __init tegra_gpio_init(void)
 		}
 	}
 
-#ifdef CONFIG_OF_GPIO
-	/*
-	 * This isn't ideal, but it gets things hooked up until this
-	 * driver is converted into a platform_device
-	 */
-	tegra_gpio_chip.of_node = of_find_compatible_node(NULL, NULL,
-						"nvidia,tegra20-gpio");
-#endif /* CONFIG_OF_GPIO */
-
 	gpiochip_add(&tegra_gpio_chip);
 
 	for (gpio = 0; gpio < TEGRA_NR_GPIOS; gpio++) {
@@ -384,6 +375,24 @@ static int __init tegra_gpio_init(void)
 	return 0;
 }
 
+static struct of_device_id tegra_gpio_of_match[] __devinitdata = {
+	{ .compatible = "nvidia,tegra20-gpio", },
+	{ },
+};
+
+static struct platform_driver tegra_gpio_driver = {
+	.driver		= {
+		.name	= "tegra-gpio",
+		.owner	= THIS_MODULE,
+		.of_match_table = tegra_gpio_of_match,
+	},
+	.probe		= tegra_gpio_probe,
+};
+
+static int __init tegra_gpio_init(void)
+{
+	return platform_driver_register(&tegra_gpio_driver);
+}
 postcore_initcall(tegra_gpio_init);
 
 void __init tegra_gpio_config(struct tegra_gpio_table *table, int num)
-- 
1.7.0.4

