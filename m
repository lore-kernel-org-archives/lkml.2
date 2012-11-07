Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab2KGPD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 10:03:58 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18416 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab2KGPD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 10:03:56 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 07 Nov 2012 06:50:39 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <linus.walleij@linaro.org>, <grant.likely@secretlab.ca>
CC: <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/2] gpio: tegra: fix suspend/resume apis
Date: Wed, 7 Nov 2012 20:31:32 +0530
Message-ID: <1352300492-24779-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1352300492-24779-1-git-send-email-ldewangan@nvidia.com>
References: <1352300492-24779-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following are changes done to fix the suspend/resume
functionality of tegra gpio driver:
- Protect suspend/resume callbacks with CONFIG_PM_SLEEP
  because CONFIG_PM doesn't actually enable any of the PM callbacks, it
  only allows to enable CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME.
  This means if CONFIG_PM is used to protect system sleep callbacks
  then it may end up unreferenced if only runtime PM is enabled.

- Fix the suspend/resume APIs declaration as per callback prototype.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/gpio/gpio-tegra.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index 6c08613..9c1884b 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -27,6 +27,7 @@
 #include <linux/module.h>
 #include <linux/irqdomain.h>
 #include <linux/pinctrl/consumer.h>
+#include <linux/pm.h>
 
 #include <asm/mach/irq.h>
 
@@ -64,7 +65,7 @@ struct tegra_gpio_bank {
 	int bank;
 	int irq;
 	spinlock_t lvl_lock[4];
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	u32 cnf[4];
 	u32 out[4];
 	u32 oe[4];
@@ -285,8 +286,8 @@ static void tegra_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 
 }
 
-#ifdef CONFIG_PM
-void tegra_gpio_resume(void)
+#ifdef CONFIG_PM_SLEEP
+static int  tegra_gpio_resume(struct device *dev)
 {
 	unsigned long flags;
 	int b;
@@ -308,9 +309,10 @@ void tegra_gpio_resume(void)
 	}
 
 	local_irq_restore(flags);
+	return 0;
 }
 
-void tegra_gpio_suspend(void)
+static int tegra_gpio_suspend(struct device *dev)
 {
 	unsigned long flags;
 	int b;
@@ -330,6 +332,7 @@ void tegra_gpio_suspend(void)
 		}
 	}
 	local_irq_restore(flags);
+	return 0;
 }
 
 static int tegra_gpio_wake_enable(struct irq_data *d, unsigned int enable)
@@ -345,11 +348,15 @@ static struct irq_chip tegra_gpio_irq_chip = {
 	.irq_mask	= tegra_gpio_irq_mask,
 	.irq_unmask	= tegra_gpio_irq_unmask,
 	.irq_set_type	= tegra_gpio_irq_set_type,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.irq_set_wake	= tegra_gpio_wake_enable,
 #endif
 };
 
+static const struct dev_pm_ops tegra_gpio_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(tegra_gpio_suspend, tegra_gpio_resume)
+};
+
 struct tegra_gpio_soc_config {
 	u32 bank_stride;
 	u32 upper_offset;
@@ -489,6 +496,7 @@ static struct platform_driver tegra_gpio_driver = {
 	.driver		= {
 		.name	= "tegra-gpio",
 		.owner	= THIS_MODULE,
+		.pm	= &tegra_gpio_pm_ops,
 		.of_match_table = tegra_gpio_of_match,
 	},
 	.probe		= tegra_gpio_probe,
-- 
1.7.1.1

