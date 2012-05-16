Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab2EPUuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 16:50:12 -0400
Received: from nbd.name ([46.4.11.11]:46703 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755067Ab2EPUuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 16:50:09 -0400
From: John Crispin <blogic@openwrt.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-mips@linux-mips.org, John Crispin <blogic@openwrt.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3 1/3] GPIO: MIPS: lantiq: move gpio-stp and gpio-ebu to the subsystem folder
Date: Wed, 16 May 2012 22:49:52 +0200
Message-Id: <1337201394-11431-1-git-send-email-blogic@openwrt.org>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the 2 drivers from arch/mips/lantiq/xway/ to the subsystem and make them
buildable.

The following 2 patches will convert the drivers to OF.

Signed-off-by: John Crispin <blogic@openwrt.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org
---
This patch is part of a series moving the mips/lantiq target to OF and clkdev
support. The patch, once Acked, should go upstream via Ralf's MIPS tree.

 arch/mips/lantiq/xway/Makefile   |    2 +-
 arch/mips/lantiq/xway/gpio_ebu.c |  126 -------------------------------
 arch/mips/lantiq/xway/gpio_stp.c |  152 --------------------------------------
 drivers/gpio/Kconfig             |   18 +++++
 drivers/gpio/Makefile            |    2 +
 drivers/gpio/gpio-mm-lantiq.c    |  126 +++++++++++++++++++++++++++++++
 drivers/gpio/gpio-stp-xway.c     |  152 ++++++++++++++++++++++++++++++++++++++
 7 files changed, 299 insertions(+), 279 deletions(-)
 delete mode 100644 arch/mips/lantiq/xway/gpio_ebu.c
 delete mode 100644 arch/mips/lantiq/xway/gpio_stp.c
 create mode 100644 drivers/gpio/gpio-mm-lantiq.c
 create mode 100644 drivers/gpio/gpio-stp-xway.c

diff --git a/arch/mips/lantiq/xway/Makefile b/arch/mips/lantiq/xway/Makefile
index edef6c5..dc3194f 100644
--- a/arch/mips/lantiq/xway/Makefile
+++ b/arch/mips/lantiq/xway/Makefile
@@ -1 +1 @@
-obj-y := prom.o sysctrl.o clk.o reset.o gpio.o gpio_stp.o gpio_ebu.o dma.o
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
diff --git a/arch/mips/lantiq/xway/gpio_stp.c b/arch/mips/lantiq/xway/gpio_stp.c
deleted file mode 100644
index d674f1b..0000000
--- a/arch/mips/lantiq/xway/gpio_stp.c
+++ /dev/null
@@ -1,152 +0,0 @@
-/*
- *  This program is free software; you can redistribute it and/or modify it
- *  under the terms of the GNU General Public License version 2 as published
- *  by the Free Software Foundation.
- *
- *  Copyright (C) 2007 John Crispin <blogic@openwrt.org>
- *
- */
-
-#include <linux/slab.h>
-#include <linux/init.h>
-#include <linux/export.h>
-#include <linux/types.h>
-#include <linux/platform_device.h>
-#include <linux/mutex.h>
-#include <linux/io.h>
-#include <linux/gpio.h>
-
-#include <lantiq_soc.h>
-
-#define LTQ_STP_CON0		0x00
-#define LTQ_STP_CON1		0x04
-#define LTQ_STP_CPU0		0x08
-#define LTQ_STP_CPU1		0x0C
-#define LTQ_STP_AR		0x10
-
-#define LTQ_STP_CON_SWU		(1 << 31)
-#define LTQ_STP_2HZ		0
-#define LTQ_STP_4HZ		(1 << 23)
-#define LTQ_STP_8HZ		(2 << 23)
-#define LTQ_STP_10HZ		(3 << 23)
-#define LTQ_STP_SPEED_MASK	(0xf << 23)
-#define LTQ_STP_UPD_FPI		(1 << 31)
-#define LTQ_STP_UPD_MASK	(3 << 30)
-#define LTQ_STP_ADSL_SRC	(3 << 24)
-
-#define LTQ_STP_GROUP0		(1 << 0)
-
-#define LTQ_STP_RISING		0
-#define LTQ_STP_FALLING		(1 << 26)
-#define LTQ_STP_EDGE_MASK	(1 << 26)
-
-#define ltq_stp_r32(reg)	__raw_readl(ltq_stp_membase + reg)
-#define ltq_stp_w32(val, reg)	__raw_writel(val, ltq_stp_membase + reg)
-#define ltq_stp_w32_mask(clear, set, reg) \
-		ltq_w32((ltq_r32(ltq_stp_membase + reg) & ~(clear)) | (set), \
-		ltq_stp_membase + (reg))
-
-static int ltq_stp_shadow = 0xffff;
-static void __iomem *ltq_stp_membase;
-
-static void ltq_stp_set(struct gpio_chip *chip, unsigned offset, int value)
-{
-	if (value)
-		ltq_stp_shadow |= (1 << offset);
-	else
-		ltq_stp_shadow &= ~(1 << offset);
-	ltq_stp_w32(ltq_stp_shadow, LTQ_STP_CPU0);
-}
-
-static int ltq_stp_direction_output(struct gpio_chip *chip, unsigned offset,
-	int value)
-{
-	ltq_stp_set(chip, offset, value);
-
-	return 0;
-}
-
-static struct gpio_chip ltq_stp_chip = {
-	.label = "ltq_stp",
-	.direction_output = ltq_stp_direction_output,
-	.set = ltq_stp_set,
-	.base = 48,
-	.ngpio = 24,
-	.can_sleep = 1,
-	.owner = THIS_MODULE,
-};
-
-static int ltq_stp_hw_init(void)
-{
-	/* sane defaults */
-	ltq_stp_w32(0, LTQ_STP_AR);
-	ltq_stp_w32(0, LTQ_STP_CPU0);
-	ltq_stp_w32(0, LTQ_STP_CPU1);
-	ltq_stp_w32(LTQ_STP_CON_SWU, LTQ_STP_CON0);
-	ltq_stp_w32(0, LTQ_STP_CON1);
-
-	/* rising or falling edge */
-	ltq_stp_w32_mask(LTQ_STP_EDGE_MASK, LTQ_STP_FALLING, LTQ_STP_CON0);
-
-	/* per default stp 15-0 are set */
-	ltq_stp_w32_mask(0, LTQ_STP_GROUP0, LTQ_STP_CON1);
-
-	/* stp are update periodically by the FPI bus */
-	ltq_stp_w32_mask(LTQ_STP_UPD_MASK, LTQ_STP_UPD_FPI, LTQ_STP_CON1);
-
-	/* set stp update speed */
-	ltq_stp_w32_mask(LTQ_STP_SPEED_MASK, LTQ_STP_8HZ, LTQ_STP_CON1);
-
-	/* tell the hardware that pin (led) 0 and 1 are controlled
-	 *  by the dsl arc
-	 */
-	ltq_stp_w32_mask(0, LTQ_STP_ADSL_SRC, LTQ_STP_CON0);
-
-	ltq_pmu_enable(PMU_LED);
-	return 0;
-}
-
-static int __devinit ltq_stp_probe(struct platform_device *pdev)
-{
-	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	int ret = 0;
-
-	if (!res)
-		return -ENOENT;
-	res = devm_request_mem_region(&pdev->dev, res->start,
-		resource_size(res), dev_name(&pdev->dev));
-	if (!res) {
-		dev_err(&pdev->dev, "failed to request STP memory\n");
-		return -EBUSY;
-	}
-	ltq_stp_membase = devm_ioremap_nocache(&pdev->dev, res->start,
-		resource_size(res));
-	if (!ltq_stp_membase) {
-		dev_err(&pdev->dev, "failed to remap STP memory\n");
-		return -ENOMEM;
-	}
-	ret = gpiochip_add(&ltq_stp_chip);
-	if (!ret)
-		ret = ltq_stp_hw_init();
-
-	return ret;
-}
-
-static struct platform_driver ltq_stp_driver = {
-	.probe = ltq_stp_probe,
-	.driver = {
-		.name = "ltq_stp",
-		.owner = THIS_MODULE,
-	},
-};
-
-int __init ltq_stp_init(void)
-{
-	int ret = platform_driver_register(&ltq_stp_driver);
-
-	if (ret)
-		pr_info("ltq_stp: error registering platfom driver");
-	return ret;
-}
-
-postcore_initcall(ltq_stp_init);
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index e03653d..8fae079 100644
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
@@ -306,6 +314,16 @@ config GPIO_STMPE
 	  This enables support for the GPIOs found on the STMPE I/O
 	  Expanders.
 
+config GPIO_STP_XWAY
+	bool "XWAY STP GPIOs"
+	depends on SOC_XWAY
+	help
+	  This enables support for the Serial To Parallel (STP) unit found on
+	  XWAY SoC. The STP allows the SoC to drive a shift registers cascade,
+	  that can be up to 24 bit. This peripheral is aimed at driving leds.
+	  Some of the gpios/leds can be auto updated by the soc with dsl and
+	  phy status.
+
 config GPIO_TC3589X
 	bool "TC3589X GPIOs"
 	depends on MFD_TC3589X
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 007f54b..ed1c96d 100644
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
@@ -49,6 +50,7 @@ obj-$(CONFIG_ARCH_SA1100)	+= gpio-sa1100.o
 obj-$(CONFIG_GPIO_SCH)		+= gpio-sch.o
 obj-$(CONFIG_GPIO_SODAVILLE)	+= gpio-sodaville.o
 obj-$(CONFIG_GPIO_STMPE)	+= gpio-stmpe.o
+obj-$(CONFIG_GPIO_STP_XWAY)	+= gpio-stp-xway.o
 obj-$(CONFIG_GPIO_SX150X)	+= gpio-sx150x.o
 obj-$(CONFIG_GPIO_TC3589X)	+= gpio-tc3589x.o
 obj-$(CONFIG_ARCH_TEGRA)	+= gpio-tegra.o
diff --git a/drivers/gpio/gpio-mm-lantiq.c b/drivers/gpio/gpio-mm-lantiq.c
new file mode 100644
index 0000000..b91c7f1
--- /dev/null
+++ b/drivers/gpio/gpio-mm-lantiq.c
@@ -0,0 +1,126 @@
+/*
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under the terms of the GNU General Public License version 2 as published
+ *  by the Free Software Foundation.
+ *
+ *  Copyright (C) 2010 John Crispin <blogic@openwrt.org>
+ */
+
+#include <linux/init.h>
+#include <linux/export.h>
+#include <linux/types.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <linux/gpio.h>
+#include <linux/io.h>
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
+/* we keep a shadow value of the last value written to the ebu */
+static int ltq_ebu_gpio_shadow = 0x0;
+static void __iomem *ltq_ebu_gpio_membase;
+
+static void ltq_ebu_apply(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ebu_lock, flags);
+	ltq_ebu_w32(LTQ_EBU_BUSCON, LTQ_EBU_BUSCON1);
+	*((__u16 *)ltq_ebu_gpio_membase) = ltq_ebu_gpio_shadow;
+	ltq_ebu_w32(LTQ_EBU_BUSCON | LTQ_EBU_WP, LTQ_EBU_BUSCON1);
+	spin_unlock_irqrestore(&ebu_lock, flags);
+}
+
+static void ltq_ebu_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	if (value)
+		ltq_ebu_gpio_shadow |= (1 << offset);
+	else
+		ltq_ebu_gpio_shadow &= ~(1 << offset);
+	ltq_ebu_apply();
+}
+
+static int ltq_ebu_direction_output(struct gpio_chip *chip, unsigned offset,
+	int value)
+{
+	ltq_ebu_set(chip, offset, value);
+
+	return 0;
+}
+
+static struct gpio_chip ltq_ebu_chip = {
+	.label = "ltq_ebu",
+	.direction_output = ltq_ebu_direction_output,
+	.set = ltq_ebu_set,
+	.base = 72,
+	.ngpio = 16,
+	.can_sleep = 1,
+	.owner = THIS_MODULE,
+};
+
+static int ltq_ebu_probe(struct platform_device *pdev)
+{
+	int ret = 0;
+	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	if (!res) {
+		dev_err(&pdev->dev, "failed to get memory resource\n");
+		return -ENOENT;
+	}
+
+	res = devm_request_mem_region(&pdev->dev, res->start,
+		resource_size(res), dev_name(&pdev->dev));
+	if (!res) {
+		dev_err(&pdev->dev, "failed to request memory resource\n");
+		return -EBUSY;
+	}
+
+	ltq_ebu_gpio_membase = devm_ioremap_nocache(&pdev->dev, res->start,
+		resource_size(res));
+	if (!ltq_ebu_gpio_membase) {
+		dev_err(&pdev->dev, "Failed to ioremap mem region\n");
+		return -ENOMEM;
+	}
+
+	/* grab the default shadow value passed form the platform code */
+	ltq_ebu_gpio_shadow = (unsigned int) pdev->dev.platform_data;
+
+	/* tell the ebu controller which memory address we will be using */
+	ltq_ebu_w32(pdev->resource->start | 0x1, LTQ_EBU_ADDRSEL1);
+
+	/* write protect the region */
+	ltq_ebu_w32(LTQ_EBU_BUSCON | LTQ_EBU_WP, LTQ_EBU_BUSCON1);
+
+	ret = gpiochip_add(&ltq_ebu_chip);
+	if (!ret)
+		ltq_ebu_apply();
+	return ret;
+}
+
+static struct platform_driver ltq_ebu_driver = {
+	.probe = ltq_ebu_probe,
+	.driver = {
+		.name = "ltq_ebu",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init ltq_ebu_init(void)
+{
+	int ret = platform_driver_register(&ltq_ebu_driver);
+
+	if (ret)
+		pr_info("ltq_ebu : Error registering platfom driver!");
+	return ret;
+}
+
+postcore_initcall(ltq_ebu_init);
diff --git a/drivers/gpio/gpio-stp-xway.c b/drivers/gpio/gpio-stp-xway.c
new file mode 100644
index 0000000..d674f1b
--- /dev/null
+++ b/drivers/gpio/gpio-stp-xway.c
@@ -0,0 +1,152 @@
+/*
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under the terms of the GNU General Public License version 2 as published
+ *  by the Free Software Foundation.
+ *
+ *  Copyright (C) 2007 John Crispin <blogic@openwrt.org>
+ *
+ */
+
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/export.h>
+#include <linux/types.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+
+#include <lantiq_soc.h>
+
+#define LTQ_STP_CON0		0x00
+#define LTQ_STP_CON1		0x04
+#define LTQ_STP_CPU0		0x08
+#define LTQ_STP_CPU1		0x0C
+#define LTQ_STP_AR		0x10
+
+#define LTQ_STP_CON_SWU		(1 << 31)
+#define LTQ_STP_2HZ		0
+#define LTQ_STP_4HZ		(1 << 23)
+#define LTQ_STP_8HZ		(2 << 23)
+#define LTQ_STP_10HZ		(3 << 23)
+#define LTQ_STP_SPEED_MASK	(0xf << 23)
+#define LTQ_STP_UPD_FPI		(1 << 31)
+#define LTQ_STP_UPD_MASK	(3 << 30)
+#define LTQ_STP_ADSL_SRC	(3 << 24)
+
+#define LTQ_STP_GROUP0		(1 << 0)
+
+#define LTQ_STP_RISING		0
+#define LTQ_STP_FALLING		(1 << 26)
+#define LTQ_STP_EDGE_MASK	(1 << 26)
+
+#define ltq_stp_r32(reg)	__raw_readl(ltq_stp_membase + reg)
+#define ltq_stp_w32(val, reg)	__raw_writel(val, ltq_stp_membase + reg)
+#define ltq_stp_w32_mask(clear, set, reg) \
+		ltq_w32((ltq_r32(ltq_stp_membase + reg) & ~(clear)) | (set), \
+		ltq_stp_membase + (reg))
+
+static int ltq_stp_shadow = 0xffff;
+static void __iomem *ltq_stp_membase;
+
+static void ltq_stp_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	if (value)
+		ltq_stp_shadow |= (1 << offset);
+	else
+		ltq_stp_shadow &= ~(1 << offset);
+	ltq_stp_w32(ltq_stp_shadow, LTQ_STP_CPU0);
+}
+
+static int ltq_stp_direction_output(struct gpio_chip *chip, unsigned offset,
+	int value)
+{
+	ltq_stp_set(chip, offset, value);
+
+	return 0;
+}
+
+static struct gpio_chip ltq_stp_chip = {
+	.label = "ltq_stp",
+	.direction_output = ltq_stp_direction_output,
+	.set = ltq_stp_set,
+	.base = 48,
+	.ngpio = 24,
+	.can_sleep = 1,
+	.owner = THIS_MODULE,
+};
+
+static int ltq_stp_hw_init(void)
+{
+	/* sane defaults */
+	ltq_stp_w32(0, LTQ_STP_AR);
+	ltq_stp_w32(0, LTQ_STP_CPU0);
+	ltq_stp_w32(0, LTQ_STP_CPU1);
+	ltq_stp_w32(LTQ_STP_CON_SWU, LTQ_STP_CON0);
+	ltq_stp_w32(0, LTQ_STP_CON1);
+
+	/* rising or falling edge */
+	ltq_stp_w32_mask(LTQ_STP_EDGE_MASK, LTQ_STP_FALLING, LTQ_STP_CON0);
+
+	/* per default stp 15-0 are set */
+	ltq_stp_w32_mask(0, LTQ_STP_GROUP0, LTQ_STP_CON1);
+
+	/* stp are update periodically by the FPI bus */
+	ltq_stp_w32_mask(LTQ_STP_UPD_MASK, LTQ_STP_UPD_FPI, LTQ_STP_CON1);
+
+	/* set stp update speed */
+	ltq_stp_w32_mask(LTQ_STP_SPEED_MASK, LTQ_STP_8HZ, LTQ_STP_CON1);
+
+	/* tell the hardware that pin (led) 0 and 1 are controlled
+	 *  by the dsl arc
+	 */
+	ltq_stp_w32_mask(0, LTQ_STP_ADSL_SRC, LTQ_STP_CON0);
+
+	ltq_pmu_enable(PMU_LED);
+	return 0;
+}
+
+static int __devinit ltq_stp_probe(struct platform_device *pdev)
+{
+	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	int ret = 0;
+
+	if (!res)
+		return -ENOENT;
+	res = devm_request_mem_region(&pdev->dev, res->start,
+		resource_size(res), dev_name(&pdev->dev));
+	if (!res) {
+		dev_err(&pdev->dev, "failed to request STP memory\n");
+		return -EBUSY;
+	}
+	ltq_stp_membase = devm_ioremap_nocache(&pdev->dev, res->start,
+		resource_size(res));
+	if (!ltq_stp_membase) {
+		dev_err(&pdev->dev, "failed to remap STP memory\n");
+		return -ENOMEM;
+	}
+	ret = gpiochip_add(&ltq_stp_chip);
+	if (!ret)
+		ret = ltq_stp_hw_init();
+
+	return ret;
+}
+
+static struct platform_driver ltq_stp_driver = {
+	.probe = ltq_stp_probe,
+	.driver = {
+		.name = "ltq_stp",
+		.owner = THIS_MODULE,
+	},
+};
+
+int __init ltq_stp_init(void)
+{
+	int ret = platform_driver_register(&ltq_stp_driver);
+
+	if (ret)
+		pr_info("ltq_stp: error registering platfom driver");
+	return ret;
+}
+
+postcore_initcall(ltq_stp_init);
-- 
1.7.9.1

