Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab2ENRnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 13:43:37 -0400
Received: from nbd.name ([46.4.11.11]:55578 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757399Ab2ENRnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 13:43:35 -0400
From: John Crispin <blogic@openwrt.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, John Crispin <blogic@openwrt.org>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH V2 09/17] GPIO: MIPS: lantiq: convert gpio-ebu to OF and move it to subsystem
Date: Mon, 14 May 2012 19:42:35 +0200
Message-Id: <1337017363-14424-9-git-send-email-blogic@openwrt.org>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1337017363-14424-1-git-send-email-blogic@openwrt.org>
References: <1337017363-14424-1-git-send-email-blogic@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implements OF support and moves the driver from arch/mips/lantiq/xway/ to the
gpio subsystem.

By attaching hardware latches to the External Bus Unit (EBU) on Lantiq SoC, it
is possible to create output only gpios. This driver configures a special
memory address, which when written to, outputs 16 bit to the latches.

This driver makes use of of_mm_gpio.

Signed-off-by: John Crispin <blogic@openwrt.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org
---
This patch is part of a series moving the mips/lantiq target to OF and clkdev
support. The patch, once Acked, should go upstream via Ralf's MIPS tree.

 arch/mips/lantiq/xway/Makefile   |    2 +-
 arch/mips/lantiq/xway/gpio_ebu.c |  126 ------------------------------
 drivers/gpio/Kconfig             |    8 ++
 drivers/gpio/Makefile            |    1 +
 drivers/gpio/gpio-mm-lantiq.c    |  157 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 167 insertions(+), 127 deletions(-)
 delete mode 100644 arch/mips/lantiq/xway/gpio_ebu.c
 create mode 100644 drivers/gpio/gpio-mm-lantiq.c

diff --git a/arch/mips/lantiq/xway/Makefile b/arch/mips/lantiq/xway/Makefile
index d0a0c96..dc3194f 100644
--- a/arch/mips/lantiq/xway/Makefile
+++ b/arch/mips/lantiq/xway/Makefile
@@ -1 +1 @@
-obj-y := prom.o sysctrl.o clk.o reset.o gpio.o gpio_ebu.o dma.o
+obj-y := prom.o sysctrl.o clk.o reset.o gpio.o dma.o
diff --git a/arch/mips/lantiq/xway/gpio_ebu.c b/arch/mips/lantiq/xway/gpio_ebu.c
deleted file mode 100644
index b91c7f1..0000000
--- a/arch/mips/lantiq/xway/gpio_ebu.c
+++ /dev/null
@@ -1,126 +0,0 @@
-/*
- *  This program is free software; you can redistribute it and/or modify it
- *  under the terms of the GNU General Public License version 2 as published
- *  by the Free Software Foundation.
- *
- *  Copyright (C) 2010 John Crispin <blogic@openwrt.org>
- */
-
-#include <linux/init.h>
-#include <linux/export.h>
-#include <linux/types.h>
-#include <linux/platform_device.h>
-#include <linux/mutex.h>
-#include <linux/gpio.h>
-#include <linux/io.h>
-
-#include <lantiq_soc.h>
-
-/*
- * By attaching hardware latches to the EBU it is possible to create output
- * only gpios. This driver configures a special memory address, which when
- * written to outputs 16 bit to the latches.
- */
-
-#define LTQ_EBU_BUSCON	0x1e7ff		/* 16 bit access, slowest timing */
-#define LTQ_EBU_WP	0x80000000	/* write protect bit */
-
-/* we keep a shadow value of the last value written to the ebu */
-static int ltq_ebu_gpio_shadow = 0x0;
-static void __iomem *ltq_ebu_gpio_membase;
-
-static void ltq_ebu_apply(void)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&ebu_lock, flags);
-	ltq_ebu_w32(LTQ_EBU_BUSCON, LTQ_EBU_BUSCON1);
-	*((__u16 *)ltq_ebu_gpio_membase) = ltq_ebu_gpio_shadow;
-	ltq_ebu_w32(LTQ_EBU_BUSCON | LTQ_EBU_WP, LTQ_EBU_BUSCON1);
-	spin_unlock_irqrestore(&ebu_lock, flags);
-}
-
-static void ltq_ebu_set(struct gpio_chip *chip, unsigned offset, int value)
-{
-	if (value)
-		ltq_ebu_gpio_shadow |= (1 << offset);
-	else
-		ltq_ebu_gpio_shadow &= ~(1 << offset);
-	ltq_ebu_apply();
-}
-
-static int ltq_ebu_direction_output(struct gpio_chip *chip, unsigned offset,
-	int value)
-{
-	ltq_ebu_set(chip, offset, value);
-
-	return 0;
-}
-
-static struct gpio_chip ltq_ebu_chip = {
-	.label = "ltq_ebu",
-	.direction_output = ltq_ebu_direction_output,
-	.set = ltq_ebu_set,
-	.base = 72,
-	.ngpio = 16,
-	.can_sleep = 1,
-	.owner = THIS_MODULE,
-};
-
-static int ltq_ebu_probe(struct platform_device *pdev)
-{
-	int ret = 0;
-	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-
-	if (!res) {
-		dev_err(&pdev->dev, "failed to get memory resource\n");
-		return -ENOENT;
-	}
-
-	res = devm_request_mem_region(&pdev->dev, res->start,
-		resource_size(res), dev_name(&pdev->dev));
-	if (!res) {
-		dev_err(&pdev->dev, "failed to request memory resource\n");
-		return -EBUSY;
-	}
-
-	ltq_ebu_gpio_membase = devm_ioremap_nocache(&pdev->dev, res->start,
-		resource_size(res));
-	if (!ltq_ebu_gpio_membase) {
-		dev_err(&pdev->dev, "Failed to ioremap mem region\n");
-		return -ENOMEM;
-	}
-
-	/* grab the default shadow value passed form the platform code */
-	ltq_ebu_gpio_shadow = (unsigned int) pdev->dev.platform_data;
-
-	/* tell the ebu controller which memory address we will be using */
-	ltq_ebu_w32(pdev->resource->start | 0x1, LTQ_EBU_ADDRSEL1);
-
-	/* write protect the region */
-	ltq_ebu_w32(LTQ_EBU_BUSCON | LTQ_EBU_WP, LTQ_EBU_BUSCON1);
-
-	ret = gpiochip_add(&ltq_ebu_chip);
-	if (!ret)
-		ltq_ebu_apply();
-	return ret;
-}
-
-static struct platform_driver ltq_ebu_driver = {
-	.probe = ltq_ebu_probe,
-	.driver = {
-		.name = "ltq_ebu",
-		.owner = THIS_MODULE,
-	},
-};
-
-static int __init ltq_ebu_init(void)
-{
-	int ret = platform_driver_register(&ltq_ebu_driver);
-
-	if (ret)
-		pr_info("ltq_ebu : Error registering platfom driver!");
-	return ret;
-}
-
-postcore_initcall(ltq_ebu_init);
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 4875071..8fae079 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -96,6 +96,14 @@ config GPIO_EP93XX
 	depends on ARCH_EP93XX
 	select GPIO_GENERIC
 
+config GPIO_MM_LANTIQ
+	bool "Lantiq Memory mapped GPIOs"
+	depends on LANTIQ && SOC_XWAY
+	help
+	  This enables support for memory mapped GPIOs on the External Bus Unit
+	  (EBU) found on Lantiq SoCs. The gpios are output only as they are
+	  created by attaching a 16bit latch to the bus.
+
 config GPIO_MPC5200
 	def_bool y
 	depends on PPC_MPC52xx
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 6447841..ed1c96d 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_GPIO_MC33880)	+= gpio-mc33880.o
 obj-$(CONFIG_GPIO_MC9S08DZ60)	+= gpio-mc9s08dz60.o
 obj-$(CONFIG_GPIO_MCP23S08)	+= gpio-mcp23s08.o
 obj-$(CONFIG_GPIO_ML_IOH)	+= gpio-ml-ioh.o
+obj-$(CONFIG_GPIO_MM_LANTIQ)	+= gpio-mm-lantiq.o
 obj-$(CONFIG_GPIO_MPC5200)	+= gpio-mpc5200.o
 obj-$(CONFIG_GPIO_MPC8XXX)	+= gpio-mpc8xxx.o
 obj-$(CONFIG_GPIO_MSM_V1)	+= gpio-msm-v1.o
diff --git a/drivers/gpio/gpio-mm-lantiq.c b/drivers/gpio/gpio-mm-lantiq.c
new file mode 100644
index 0000000..9296801
--- /dev/null
+++ b/drivers/gpio/gpio-mm-lantiq.c
@@ -0,0 +1,157 @@
+/*
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under the terms of the GNU General Public License version 2 as published
+ *  by the Free Software Foundation.
+ *
+ *  Copyright (C) 2012 John Crispin <blogic@openwrt.org>
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+
+#include <lantiq_soc.h>
+
+/*
+ * By attaching hardware latches to the EBU it is possible to create output
+ * only gpios. This driver configures a special memory address, which when
+ * written to outputs 16 bit to the latches.
+ */
+
+#define LTQ_EBU_BUSCON	0x1e7ff		/* 16 bit access, slowest timing */
+#define LTQ_EBU_WP	0x80000000	/* write protect bit */
+
+struct ltq_mm {
+	struct of_mm_gpio_chip mmchip;
+	u16 shadow;	/* shadow the latches state */
+};
+
+/*
+ * ltq_mm_apply - write the shadow value to the ebu address.
+ * @chip:     Pointer to our private data structure.
+ *
+ * Write the shadow value to the EBU to set the gpios. We need to set the
+ * global EBU lock to make sure that PCI/MTD dont break.
+ */
+static void ltq_mm_apply(struct ltq_mm *chip)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ebu_lock, flags);
+	ltq_ebu_w32(LTQ_EBU_BUSCON, LTQ_EBU_BUSCON1);
+	*((__u16 *)chip->mmchip.regs) = chip->shadow;
+	ltq_ebu_w32(LTQ_EBU_BUSCON | LTQ_EBU_WP, LTQ_EBU_BUSCON1);
+	spin_unlock_irqrestore(&ebu_lock, flags);
+}
+
+/*
+ * ltq_mm_set - gpio_chip->set - set gpios.
+ * @gc:     Pointer to gpio_chip device structure.
+ * @gpio:   GPIO signal number.
+ * @val:    Value to be written to specified signal.
+ *
+ * Set the shadow value and call ltq_mm_apply.
+ */
+static void ltq_mm_set(struct gpio_chip *gc, unsigned offset, int value)
+{
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+	struct ltq_mm *chip =
+		container_of(mm_gc, struct ltq_mm, mmchip);
+
+	if (value)
+		chip->shadow |= (1 << offset);
+	else
+		chip->shadow &= ~(1 << offset);
+	ltq_mm_apply(chip);
+}
+
+/*
+ * ltq_mm_dir_out - gpio_chip->dir_out - set gpio direction.
+ * @gc:     Pointer to gpio_chip device structure.
+ * @gpio:   GPIO signal number.
+ * @val:    Value to be written to specified signal.
+ *
+ * Same as ltq_mm_set, always returns 0.
+ */
+static int ltq_mm_dir_out(struct gpio_chip *gc, unsigned offset, int value)
+{
+	ltq_mm_set(gc, offset, value);
+
+	return 0;
+}
+
+/*
+ * ltq_mm_save_regs - Set initial values of GPIO pins
+ * @mm_gc: pointer to memory mapped GPIO chip structure
+ */
+static void ltq_mm_save_regs(struct of_mm_gpio_chip *mm_gc)
+{
+	struct ltq_mm *chip =
+		container_of(mm_gc, struct ltq_mm, mmchip);
+
+	/* tell the ebu controller which memory address we will be using */
+	ltq_ebu_w32(CPHYSADDR(chip->mmchip.regs) | 0x1, LTQ_EBU_ADDRSEL1);
+
+	ltq_mm_apply(chip);
+}
+
+static int ltq_mm_probe(struct platform_device *pdev)
+{
+	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	struct ltq_mm *chip;
+	const __be32 *shadow;
+	int ret = 0;
+
+	if (!res) {
+		dev_err(&pdev->dev, "failed to get memory resource\n");
+		return -ENOENT;
+	}
+
+	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	chip->mmchip.gc.ngpio = 16;
+	chip->mmchip.gc.label = "gpio-mm-ltq";
+	chip->mmchip.gc.direction_output = ltq_mm_dir_out;
+	chip->mmchip.gc.set = ltq_mm_set;
+	chip->mmchip.save_regs = ltq_mm_save_regs;
+
+	/* store the shadow value if one was passed by the devicetree */
+	shadow = of_get_property(pdev->dev.of_node, "lantiq,shadow", NULL);
+	if (shadow)
+		chip->shadow = *shadow;
+
+	ret = of_mm_gpiochip_add(pdev->dev.of_node, &chip->mmchip);
+	if (ret)
+		kfree(chip);
+	return ret;
+}
+
+static const struct of_device_id ltq_mm_match[] = {
+	{ .compatible = "lantiq,gpio-mm" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, ltq_mm_match);
+
+static struct platform_driver ltq_mm_driver = {
+	.probe = ltq_mm_probe,
+	.driver = {
+		.name = "gpio-mm-ltq",
+		.owner = THIS_MODULE,
+		.of_match_table = ltq_mm_match,
+	},
+};
+
+static int __init ltq_mm_init(void)
+{
+	return platform_driver_register(&ltq_mm_driver);
+}
+
+subsys_initcall(ltq_mm_init);
-- 
1.7.9.1

