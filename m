Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab1HYXqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 19:46:04 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35627 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab1HYXoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 19:44:13 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH v3 07/13] gpio/tegra: Convert to a platform device
Date: Thu, 25 Aug 2011 17:43:38 -0600
Message-Id: <1314315824-9687-8-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314315824-9687-1-git-send-email-swarren@nvidia.com>
References: <1314315824-9687-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/gpio/gpio-tegra.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index df64536..4da4839 100644
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
 
@@ -332,7 +332,7 @@ static struct irq_chip tegra_gpio_irq_chip = {
  */
 static struct lock_class_key gpio_lock_class;
 
-static int __init tegra_gpio_init(void)
+static int __init tegra_gpio_probe(struct platform_device *pdev)
 {
 	struct tegra_gpio_bank *bank;
 	int gpio;
@@ -346,15 +346,6 @@ static int __init tegra_gpio_init(void)
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
@@ -383,6 +374,18 @@ static int __init tegra_gpio_init(void)
 	return 0;
 }
 
+static struct platform_driver tegra_gpio_driver = {
+	.driver		= {
+		.name	= "tegra-gpio",
+		.owner	= THIS_MODULE,
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

