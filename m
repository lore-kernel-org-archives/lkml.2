Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab1FCBIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 21:08:31 -0400
Received: from smtp-out-212.synserver.de ([212.40.185.212]:1458 "EHLO
	smtp-out-212.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab1FCBIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 21:08:30 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 8419
From: Lars-Peter Clausen <lars@metafoo.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/4] PM / MIPS: Use struct syscore_ops instead of sysdevs for PM (v2)
Date: Fri,  3 Jun 2011 03:06:48 +0200
Message-Id: <1307063211-10098-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Convert some MIPS architecture's code to using struct syscore_ops
objects for power management instead of sysdev classes and sysdevs.

This simplifies the code and reduces the kernel's memory footprint.
It also is necessary for removing sysdevs from the kernel entirely in
the future.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Acked-and-tested-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 arch/mips/jz4740/gpio.c |   52 +++++++++++++++++++---------------------------
 1 files changed, 22 insertions(+), 30 deletions(-)

diff --git a/arch/mips/jz4740/gpio.c b/arch/mips/jz4740/gpio.c
index 73031f7..4397972 100644
--- a/arch/mips/jz4740/gpio.c
+++ b/arch/mips/jz4740/gpio.c
@@ -18,7 +18,7 @@
 #include <linux/init.h>
 
 #include <linux/spinlock.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/io.h>
 #include <linux/gpio.h>
 #include <linux/delay.h>
@@ -86,7 +86,6 @@ struct jz_gpio_chip {
 	spinlock_t lock;
 
 	struct gpio_chip gpio_chip;
-	struct sys_device sysdev;
 };
 
 static struct jz_gpio_chip jz4740_gpio_chips[];
@@ -459,49 +458,47 @@ static struct jz_gpio_chip jz4740_gpio_chips[] = {
 	JZ4740_GPIO_CHIP(D),
 };
 
-static inline struct jz_gpio_chip *sysdev_to_chip(struct sys_device *dev)
+static void jz4740_gpio_suspend_chip(struct jz_gpio_chip *chip)
 {
-	return container_of(dev, struct jz_gpio_chip, sysdev);
+	chip->suspend_mask = readl(chip->base + JZ_REG_GPIO_MASK);
+	writel(~(chip->wakeup), chip->base + JZ_REG_GPIO_MASK_SET);
+	writel(chip->wakeup, chip->base + JZ_REG_GPIO_MASK_CLEAR);
 }
 
-static int jz4740_gpio_suspend(struct sys_device *dev, pm_message_t state)
+static int jz4740_gpio_suspend(void)
 {
-	struct jz_gpio_chip *chip = sysdev_to_chip(dev);
+	int i;
 
-	chip->suspend_mask = readl(chip->base + JZ_REG_GPIO_MASK);
-	writel(~(chip->wakeup), chip->base + JZ_REG_GPIO_MASK_SET);
-	writel(chip->wakeup, chip->base + JZ_REG_GPIO_MASK_CLEAR);
+	for (i = 0; i < ARRAY_SIZE(jz4740_gpio_chips); i++)
+		jz4740_gpio_suspend_chip(&jz4740_gpio_chips[i]);
 
 	return 0;
 }
 
-static int jz4740_gpio_resume(struct sys_device *dev)
+static void jz4740_gpio_resume_chip(struct jz_gpio_chip *chip)
 {
-	struct jz_gpio_chip *chip = sysdev_to_chip(dev);
 	uint32_t mask = chip->suspend_mask;
 
 	writel(~mask, chip->base + JZ_REG_GPIO_MASK_CLEAR);
 	writel(mask, chip->base + JZ_REG_GPIO_MASK_SET);
+}
 
-	return 0;
+static void jz4740_gpio_resume(void)
+{
+	int i;
+
+	for (i = ARRAY_SIZE(jz4740_gpio_chips) - 1; i >= 0 ; i--)
+		jz4740_gpio_resume_chip(&jz4740_gpio_chips[i]);
 }
 
-static struct sysdev_class jz4740_gpio_sysdev_class = {
-	.name = "gpio",
+static struct syscore_ops jz4740_gpio_syscore_ops = {
 	.suspend = jz4740_gpio_suspend,
 	.resume = jz4740_gpio_resume,
 };
 
-static int jz4740_gpio_chip_init(struct jz_gpio_chip *chip, unsigned int id)
+static void jz4740_gpio_chip_init(struct jz_gpio_chip *chip, unsigned int id)
 {
-	int ret, irq;
-
-	chip->sysdev.id = id;
-	chip->sysdev.cls = &jz4740_gpio_sysdev_class;
-	ret = sysdev_register(&chip->sysdev);
-
-	if (ret)
-		return ret;
+	int irq;
 
 	spin_lock_init(&chip->lock);
 
@@ -519,22 +516,17 @@ static int jz4740_gpio_chip_init(struct jz_gpio_chip *chip, unsigned int id)
 		irq_set_chip_and_handler(irq, &jz_gpio_irq_chip,
 					 handle_level_irq);
 	}
-
-	return 0;
 }
 
 static int __init jz4740_gpio_init(void)
 {
 	unsigned int i;
-	int ret;
-
-	ret = sysdev_class_register(&jz4740_gpio_sysdev_class);
-	if (ret)
-		return ret;
 
 	for (i = 0; i < ARRAY_SIZE(jz4740_gpio_chips); ++i)
 		jz4740_gpio_chip_init(&jz4740_gpio_chips[i], i);
 
+	register_syscore_ops(&jz4740_gpio_syscore_ops);
+
 	printk(KERN_INFO "JZ4740 GPIO initialized\n");
 
 	return 0;
-- 
1.7.2.5

