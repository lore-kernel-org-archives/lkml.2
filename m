Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab1EWI1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 04:27:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:53884 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab1EWI1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 04:27:52 -0400
X-AuditID: cbfee61a-b7ce2ae000001a8f-8b-4dda1a864299
Date: Mon, 23 May 2011 17:27:45 +0900
From: Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 2/4] Move the exynos4 GPIO to drivers/gpio
To: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, kgene.kim@samsung.com, linux-arm-kernel@lists.infradead.org
Message-id: <20110523082745.GA6201@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 23 May 2011 08:27:50.0282 (UTC)
 FILETIME=[4D914EA0:01CC1923]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

Move the Samsung Exynos4 series SoCs GPIO driver to drivers/gpio

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos4/Makefile  |    2 +-
 arch/arm/mach-exynos4/gpiolib.c |  365 ---------------------------------------
 drivers/gpio/Kconfig            |    6 +
 drivers/gpio/Makefile           |    1 +
 drivers/gpio/gpio-exynos4.c     |  365 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 373 insertions(+), 366 deletions(-)
 delete mode 100644 arch/arm/mach-exynos4/gpiolib.c
 create mode 100644 drivers/gpio/gpio-exynos4.c

diff --git a/arch/arm/mach-exynos4/Makefile b/arch/arm/mach-exynos4/Makefile
index 9be104f..3bb3f57 100644
--- a/arch/arm/mach-exynos4/Makefile
+++ b/arch/arm/mach-exynos4/Makefile
@@ -13,7 +13,7 @@ obj-				:=
 # Core support for EXYNOS4 system
 
 obj-$(CONFIG_CPU_EXYNOS4210)	+= cpu.o init.o clock.o irq-combiner.o
-obj-$(CONFIG_CPU_EXYNOS4210)	+= setup-i2c0.o gpiolib.o irq-eint.o dma.o
+obj-$(CONFIG_CPU_EXYNOS4210)	+= setup-i2c0.o irq-eint.o dma.o
 obj-$(CONFIG_PM)		+= pm.o sleep.o
 obj-$(CONFIG_CPU_FREQ)		+= cpufreq.o
 
diff --git a/arch/arm/mach-exynos4/gpiolib.c b/arch/arm/mach-exynos4/gpiolib.c
deleted file mode 100644
index d54ca6a..0000000
--- a/arch/arm/mach-exynos4/gpiolib.c
+++ /dev/null
@@ -1,365 +0,0 @@
-/* linux/arch/arm/mach-exynos4/gpiolib.c
- *
- * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com
- *
- * EXYNOS4 - GPIOlib support
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
-*/
-
-#include <linux/kernel.h>
-#include <linux/irq.h>
-#include <linux/io.h>
-#include <linux/gpio.h>
-
-#include <mach/map.h>
-
-#include <plat/gpio-core.h>
-#include <plat/gpio-cfg.h>
-#include <plat/gpio-cfg-helpers.h>
-
-static struct s3c_gpio_cfg gpio_cfg = {
-	.set_config	= s3c_gpio_setcfg_s3c64xx_4bit,
-	.set_pull	= s3c_gpio_setpull_updown,
-	.get_pull	= s3c_gpio_getpull_updown,
-};
-
-static struct s3c_gpio_cfg gpio_cfg_noint = {
-	.set_config	= s3c_gpio_setcfg_s3c64xx_4bit,
-	.set_pull	= s3c_gpio_setpull_updown,
-	.get_pull	= s3c_gpio_getpull_updown,
-};
-
-/*
- * Following are the gpio banks in v310.
- *
- * The 'config' member when left to NULL, is initialized to the default
- * structure gpio_cfg in the init function below.
- *
- * The 'base' member is also initialized in the init function below.
- * Note: The initialization of 'base' member of s3c_gpio_chip structure
- * uses the above macro and depends on the banks being listed in order here.
- */
-static struct s3c_gpio_chip exynos4_gpio_part1_4bit[] = {
-	{
-		.chip	= {
-			.base	= EXYNOS4_GPA0(0),
-			.ngpio	= EXYNOS4_GPIO_A0_NR,
-			.label	= "GPA0",
-		},
-	}, {
-		.chip	= {
-			.base	= EXYNOS4_GPA1(0),
-			.ngpio	= EXYNOS4_GPIO_A1_NR,
-			.label	= "GPA1",
-		},
-	}, {
-		.chip	= {
-			.base	= EXYNOS4_GPB(0),
-			.ngpio	= EXYNOS4_GPIO_B_NR,
-			.label	= "GPB",
-		},
-	}, {
-		.chip	= {
-			.base	= EXYNOS4_GPC0(0),
-			.ngpio	= EXYNOS4_GPIO_C0_NR,
-			.label	= "GPC0",
-		},
-	}, {
-		.chip	= {
-			.base	= EXYNOS4_GPC1(0),
-			.ngpio	= EXYNOS4_GPIO_C1_NR,
-			.label	= "GPC1",
-		},
-	}, {
-		.chip	= {
-			.base	= EXYNOS4_GPD0(0),
-			.ngpio	= EXYNOS4_GPIO_D0_NR,
-			.label	= "GPD0",
-		},
-	}, {
-		.chip	= {
-			.base	= EXYNOS4_GPD1(0),
-			.ngpio	= EXYNOS4_GPIO_D1_NR,
-			.label	= "GPD1",
-		},
-	}, {
-		.chip	= {
-			.base	= EXYNOS4_GPE0(0),
-			.ngpio	= EXYNOS4_GPIO_E0_NR,
-			.label	= "GPE0",
-		},
-	}, {
-		.chip	= {
-			.base	= EXYNOS4_GPE1(0),
-			.ngpio	= EXYNOS4_GPIO_E1_NR,
-			.label	= "GPE1",
-		},
-	}, {
-		.chip	= {
-			.base	= EXYNOS4_GPE2(0),
-			.ngpio	= EXYNOS4_GPIO_E2_NR,
-			.label	= "GPE2",
-		},
-	}, {
-		.chip	= {
-			.base	= EXYNOS4_GPE3(0),
-			.ngpio	= EXYNOS4_GPIO_E3_NR,
-			.label	= "GPE3",
-		},
-	}, {
-		.chip	= {
-			.base	= EXYNOS4_GPE4(0),
-			.ngpio	= EXYNOS4_GPIO_E4_NR,
-			.label	= "GPE4",
-		},
-	}, {
-		.chip	= {
-			.base	= EXYNOS4_GPF0(0),
-			.ngpio	= EXYNOS4_GPIO_F0_NR,
-			.label	= "GPF0",
-		},
-	}, {
-		.chip	= {
-			.base	= EXYNOS4_GPF1(0),
-			.ngpio	= EXYNOS4_GPIO_F1_NR,
-			.label	= "GPF1",
-		},
-	}, {
-		.chip	= {
-			.base	= EXYNOS4_GPF2(0),
-			.ngpio	= EXYNOS4_GPIO_F2_NR,
-			.label	= "GPF2",
-		},
-	}, {
-		.chip	= {
-			.base	= EXYNOS4_GPF3(0),
-			.ngpio	= EXYNOS4_GPIO_F3_NR,
-			.label	= "GPF3",
-		},
-	},
-};
-
-static struct s3c_gpio_chip exynos4_gpio_part2_4bit[] = {
-	{
-		.chip	= {
-			.base	= EXYNOS4_GPJ0(0),
-			.ngpio	= EXYNOS4_GPIO_J0_NR,
-			.label	= "GPJ0",
-		},
-	}, {
-		.chip	= {
-			.base	= EXYNOS4_GPJ1(0),
-			.ngpio	= EXYNOS4_GPIO_J1_NR,
-			.label	= "GPJ1",
-		},
-	}, {
-		.chip	= {
-			.base	= EXYNOS4_GPK0(0),
-			.ngpio	= EXYNOS4_GPIO_K0_NR,
-			.label	= "GPK0",
-		},
-	}, {
-		.chip	= {
-			.base	= EXYNOS4_GPK1(0),
-			.ngpio	= EXYNOS4_GPIO_K1_NR,
-			.label	= "GPK1",
-		},
-	}, {
-		.chip	= {
-			.base	= EXYNOS4_GPK2(0),
-			.ngpio	= EXYNOS4_GPIO_K2_NR,
-			.label	= "GPK2",
-		},
-	}, {
-		.chip	= {
-			.base	= EXYNOS4_GPK3(0),
-			.ngpio	= EXYNOS4_GPIO_K3_NR,
-			.label	= "GPK3",
-		},
-	}, {
-		.chip	= {
-			.base	= EXYNOS4_GPL0(0),
-			.ngpio	= EXYNOS4_GPIO_L0_NR,
-			.label	= "GPL0",
-		},
-	}, {
-		.chip	= {
-			.base	= EXYNOS4_GPL1(0),
-			.ngpio	= EXYNOS4_GPIO_L1_NR,
-			.label	= "GPL1",
-		},
-	}, {
-		.chip	= {
-			.base	= EXYNOS4_GPL2(0),
-			.ngpio	= EXYNOS4_GPIO_L2_NR,
-			.label	= "GPL2",
-		},
-	}, {
-		.config	= &gpio_cfg_noint,
-		.chip	= {
-			.base	= EXYNOS4_GPY0(0),
-			.ngpio	= EXYNOS4_GPIO_Y0_NR,
-			.label	= "GPY0",
-		},
-	}, {
-		.config	= &gpio_cfg_noint,
-		.chip	= {
-			.base	= EXYNOS4_GPY1(0),
-			.ngpio	= EXYNOS4_GPIO_Y1_NR,
-			.label	= "GPY1",
-		},
-	}, {
-		.config	= &gpio_cfg_noint,
-		.chip	= {
-			.base	= EXYNOS4_GPY2(0),
-			.ngpio	= EXYNOS4_GPIO_Y2_NR,
-			.label	= "GPY2",
-		},
-	}, {
-		.config	= &gpio_cfg_noint,
-		.chip	= {
-			.base	= EXYNOS4_GPY3(0),
-			.ngpio	= EXYNOS4_GPIO_Y3_NR,
-			.label	= "GPY3",
-		},
-	}, {
-		.config	= &gpio_cfg_noint,
-		.chip	= {
-			.base	= EXYNOS4_GPY4(0),
-			.ngpio	= EXYNOS4_GPIO_Y4_NR,
-			.label	= "GPY4",
-		},
-	}, {
-		.config	= &gpio_cfg_noint,
-		.chip	= {
-			.base	= EXYNOS4_GPY5(0),
-			.ngpio	= EXYNOS4_GPIO_Y5_NR,
-			.label	= "GPY5",
-		},
-	}, {
-		.config	= &gpio_cfg_noint,
-		.chip	= {
-			.base	= EXYNOS4_GPY6(0),
-			.ngpio	= EXYNOS4_GPIO_Y6_NR,
-			.label	= "GPY6",
-		},
-	}, {
-		.base	= (S5P_VA_GPIO2 + 0xC00),
-		.config	= &gpio_cfg_noint,
-		.irq_base = IRQ_EINT(0),
-		.chip	= {
-			.base	= EXYNOS4_GPX0(0),
-			.ngpio	= EXYNOS4_GPIO_X0_NR,
-			.label	= "GPX0",
-			.to_irq	= samsung_gpiolib_to_irq,
-		},
-	}, {
-		.base	= (S5P_VA_GPIO2 + 0xC20),
-		.config	= &gpio_cfg_noint,
-		.irq_base = IRQ_EINT(8),
-		.chip	= {
-			.base	= EXYNOS4_GPX1(0),
-			.ngpio	= EXYNOS4_GPIO_X1_NR,
-			.label	= "GPX1",
-			.to_irq	= samsung_gpiolib_to_irq,
-		},
-	}, {
-		.base	= (S5P_VA_GPIO2 + 0xC40),
-		.config	= &gpio_cfg_noint,
-		.irq_base = IRQ_EINT(16),
-		.chip	= {
-			.base	= EXYNOS4_GPX2(0),
-			.ngpio	= EXYNOS4_GPIO_X2_NR,
-			.label	= "GPX2",
-			.to_irq	= samsung_gpiolib_to_irq,
-		},
-	}, {
-		.base	= (S5P_VA_GPIO2 + 0xC60),
-		.config	= &gpio_cfg_noint,
-		.irq_base = IRQ_EINT(24),
-		.chip	= {
-			.base	= EXYNOS4_GPX3(0),
-			.ngpio	= EXYNOS4_GPIO_X3_NR,
-			.label	= "GPX3",
-			.to_irq	= samsung_gpiolib_to_irq,
-		},
-	},
-};
-
-static struct s3c_gpio_chip exynos4_gpio_part3_4bit[] = {
-	{
-		.chip	= {
-			.base	= EXYNOS4_GPZ(0),
-			.ngpio	= EXYNOS4_GPIO_Z_NR,
-			.label	= "GPZ",
-		},
-	},
-};
-
-static __init int exynos4_gpiolib_init(void)
-{
-	struct s3c_gpio_chip *chip;
-	int i;
-	int group = 0;
-	int nr_chips;
-
-	/* GPIO part 1 */
-
-	chip = exynos4_gpio_part1_4bit;
-	nr_chips = ARRAY_SIZE(exynos4_gpio_part1_4bit);
-
-	for (i = 0; i < nr_chips; i++, chip++) {
-		if (chip->config == NULL) {
-			chip->config = &gpio_cfg;
-			/* Assign the GPIO interrupt group */
-			chip->group = group++;
-		}
-		if (chip->base == NULL)
-			chip->base = S5P_VA_GPIO1 + (i) * 0x20;
-	}
-
-	samsung_gpiolib_add_4bit_chips(exynos4_gpio_part1_4bit, nr_chips);
-
-	/* GPIO part 2 */
-
-	chip = exynos4_gpio_part2_4bit;
-	nr_chips = ARRAY_SIZE(exynos4_gpio_part2_4bit);
-
-	for (i = 0; i < nr_chips; i++, chip++) {
-		if (chip->config == NULL) {
-			chip->config = &gpio_cfg;
-			/* Assign the GPIO interrupt group */
-			chip->group = group++;
-		}
-		if (chip->base == NULL)
-			chip->base = S5P_VA_GPIO2 + (i) * 0x20;
-	}
-
-	samsung_gpiolib_add_4bit_chips(exynos4_gpio_part2_4bit, nr_chips);
-
-	/* GPIO part 3 */
-
-	chip = exynos4_gpio_part3_4bit;
-	nr_chips = ARRAY_SIZE(exynos4_gpio_part3_4bit);
-
-	for (i = 0; i < nr_chips; i++, chip++) {
-		if (chip->config == NULL) {
-			chip->config = &gpio_cfg;
-			/* Assign the GPIO interrupt group */
-			chip->group = group++;
-		}
-		if (chip->base == NULL)
-			chip->base = S5P_VA_GPIO3 + (i) * 0x20;
-	}
-
-	samsung_gpiolib_add_4bit_chips(exynos4_gpio_part3_4bit, nr_chips);
-	s5p_register_gpioint_bank(IRQ_GPIO_XA, 0, IRQ_GPIO1_NR_GROUPS);
-	s5p_register_gpioint_bank(IRQ_GPIO_XB, IRQ_GPIO1_NR_GROUPS, IRQ_GPIO2_NR_GROUPS);
-
-	return 0;
-}
-core_initcall(exynos4_gpiolib_init);
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index fd4bb20..28a31f1 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -81,6 +81,12 @@ config GPIO_IT8761E
 	help
 	  Say yes here to support GPIO functionality of IT8761E super I/O chip.
 
+config GPIO_EXYNOS4
+	bool "Samsung Exynos4 GPIO library support"
+	default y if CPU_EXYNOS4210
+	help
+	  Say yes here to support Samsung Exynos4 series SoCs GPIO library
+
 config GPIO_PLAT_SAMSUNG
 	bool "Samsung SoCs GPIO library support"
 	default y if SAMSUNG_GPIOLIB_4BIT
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 1321cdb..b271b93 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
 obj-$(CONFIG_GPIO_ADP5520)	+= adp5520-gpio.o
 obj-$(CONFIG_GPIO_ADP5588)	+= adp5588-gpio.o
 obj-$(CONFIG_GPIO_BASIC_MMIO)	+= basic_mmio_gpio.o
+obj-$(CONFIG_GPIO_EXYNOS4)	+= gpio-exynos4.o
 obj-$(CONFIG_GPIO_PLAT_SAMSUNG)	+= gpio-plat-samsung.o
 obj-$(CONFIG_GPIO_LANGWELL)	+= langwell_gpio.o
 obj-$(CONFIG_GPIO_MAX730X)	+= max730x.o
diff --git a/drivers/gpio/gpio-exynos4.c b/drivers/gpio/gpio-exynos4.c
new file mode 100644
index 0000000..d54ca6a
--- /dev/null
+++ b/drivers/gpio/gpio-exynos4.c
@@ -0,0 +1,365 @@
+/* linux/arch/arm/mach-exynos4/gpiolib.c
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * EXYNOS4 - GPIOlib support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/kernel.h>
+#include <linux/irq.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+
+#include <mach/map.h>
+
+#include <plat/gpio-core.h>
+#include <plat/gpio-cfg.h>
+#include <plat/gpio-cfg-helpers.h>
+
+static struct s3c_gpio_cfg gpio_cfg = {
+	.set_config	= s3c_gpio_setcfg_s3c64xx_4bit,
+	.set_pull	= s3c_gpio_setpull_updown,
+	.get_pull	= s3c_gpio_getpull_updown,
+};
+
+static struct s3c_gpio_cfg gpio_cfg_noint = {
+	.set_config	= s3c_gpio_setcfg_s3c64xx_4bit,
+	.set_pull	= s3c_gpio_setpull_updown,
+	.get_pull	= s3c_gpio_getpull_updown,
+};
+
+/*
+ * Following are the gpio banks in v310.
+ *
+ * The 'config' member when left to NULL, is initialized to the default
+ * structure gpio_cfg in the init function below.
+ *
+ * The 'base' member is also initialized in the init function below.
+ * Note: The initialization of 'base' member of s3c_gpio_chip structure
+ * uses the above macro and depends on the banks being listed in order here.
+ */
+static struct s3c_gpio_chip exynos4_gpio_part1_4bit[] = {
+	{
+		.chip	= {
+			.base	= EXYNOS4_GPA0(0),
+			.ngpio	= EXYNOS4_GPIO_A0_NR,
+			.label	= "GPA0",
+		},
+	}, {
+		.chip	= {
+			.base	= EXYNOS4_GPA1(0),
+			.ngpio	= EXYNOS4_GPIO_A1_NR,
+			.label	= "GPA1",
+		},
+	}, {
+		.chip	= {
+			.base	= EXYNOS4_GPB(0),
+			.ngpio	= EXYNOS4_GPIO_B_NR,
+			.label	= "GPB",
+		},
+	}, {
+		.chip	= {
+			.base	= EXYNOS4_GPC0(0),
+			.ngpio	= EXYNOS4_GPIO_C0_NR,
+			.label	= "GPC0",
+		},
+	}, {
+		.chip	= {
+			.base	= EXYNOS4_GPC1(0),
+			.ngpio	= EXYNOS4_GPIO_C1_NR,
+			.label	= "GPC1",
+		},
+	}, {
+		.chip	= {
+			.base	= EXYNOS4_GPD0(0),
+			.ngpio	= EXYNOS4_GPIO_D0_NR,
+			.label	= "GPD0",
+		},
+	}, {
+		.chip	= {
+			.base	= EXYNOS4_GPD1(0),
+			.ngpio	= EXYNOS4_GPIO_D1_NR,
+			.label	= "GPD1",
+		},
+	}, {
+		.chip	= {
+			.base	= EXYNOS4_GPE0(0),
+			.ngpio	= EXYNOS4_GPIO_E0_NR,
+			.label	= "GPE0",
+		},
+	}, {
+		.chip	= {
+			.base	= EXYNOS4_GPE1(0),
+			.ngpio	= EXYNOS4_GPIO_E1_NR,
+			.label	= "GPE1",
+		},
+	}, {
+		.chip	= {
+			.base	= EXYNOS4_GPE2(0),
+			.ngpio	= EXYNOS4_GPIO_E2_NR,
+			.label	= "GPE2",
+		},
+	}, {
+		.chip	= {
+			.base	= EXYNOS4_GPE3(0),
+			.ngpio	= EXYNOS4_GPIO_E3_NR,
+			.label	= "GPE3",
+		},
+	}, {
+		.chip	= {
+			.base	= EXYNOS4_GPE4(0),
+			.ngpio	= EXYNOS4_GPIO_E4_NR,
+			.label	= "GPE4",
+		},
+	}, {
+		.chip	= {
+			.base	= EXYNOS4_GPF0(0),
+			.ngpio	= EXYNOS4_GPIO_F0_NR,
+			.label	= "GPF0",
+		},
+	}, {
+		.chip	= {
+			.base	= EXYNOS4_GPF1(0),
+			.ngpio	= EXYNOS4_GPIO_F1_NR,
+			.label	= "GPF1",
+		},
+	}, {
+		.chip	= {
+			.base	= EXYNOS4_GPF2(0),
+			.ngpio	= EXYNOS4_GPIO_F2_NR,
+			.label	= "GPF2",
+		},
+	}, {
+		.chip	= {
+			.base	= EXYNOS4_GPF3(0),
+			.ngpio	= EXYNOS4_GPIO_F3_NR,
+			.label	= "GPF3",
+		},
+	},
+};
+
+static struct s3c_gpio_chip exynos4_gpio_part2_4bit[] = {
+	{
+		.chip	= {
+			.base	= EXYNOS4_GPJ0(0),
+			.ngpio	= EXYNOS4_GPIO_J0_NR,
+			.label	= "GPJ0",
+		},
+	}, {
+		.chip	= {
+			.base	= EXYNOS4_GPJ1(0),
+			.ngpio	= EXYNOS4_GPIO_J1_NR,
+			.label	= "GPJ1",
+		},
+	}, {
+		.chip	= {
+			.base	= EXYNOS4_GPK0(0),
+			.ngpio	= EXYNOS4_GPIO_K0_NR,
+			.label	= "GPK0",
+		},
+	}, {
+		.chip	= {
+			.base	= EXYNOS4_GPK1(0),
+			.ngpio	= EXYNOS4_GPIO_K1_NR,
+			.label	= "GPK1",
+		},
+	}, {
+		.chip	= {
+			.base	= EXYNOS4_GPK2(0),
+			.ngpio	= EXYNOS4_GPIO_K2_NR,
+			.label	= "GPK2",
+		},
+	}, {
+		.chip	= {
+			.base	= EXYNOS4_GPK3(0),
+			.ngpio	= EXYNOS4_GPIO_K3_NR,
+			.label	= "GPK3",
+		},
+	}, {
+		.chip	= {
+			.base	= EXYNOS4_GPL0(0),
+			.ngpio	= EXYNOS4_GPIO_L0_NR,
+			.label	= "GPL0",
+		},
+	}, {
+		.chip	= {
+			.base	= EXYNOS4_GPL1(0),
+			.ngpio	= EXYNOS4_GPIO_L1_NR,
+			.label	= "GPL1",
+		},
+	}, {
+		.chip	= {
+			.base	= EXYNOS4_GPL2(0),
+			.ngpio	= EXYNOS4_GPIO_L2_NR,
+			.label	= "GPL2",
+		},
+	}, {
+		.config	= &gpio_cfg_noint,
+		.chip	= {
+			.base	= EXYNOS4_GPY0(0),
+			.ngpio	= EXYNOS4_GPIO_Y0_NR,
+			.label	= "GPY0",
+		},
+	}, {
+		.config	= &gpio_cfg_noint,
+		.chip	= {
+			.base	= EXYNOS4_GPY1(0),
+			.ngpio	= EXYNOS4_GPIO_Y1_NR,
+			.label	= "GPY1",
+		},
+	}, {
+		.config	= &gpio_cfg_noint,
+		.chip	= {
+			.base	= EXYNOS4_GPY2(0),
+			.ngpio	= EXYNOS4_GPIO_Y2_NR,
+			.label	= "GPY2",
+		},
+	}, {
+		.config	= &gpio_cfg_noint,
+		.chip	= {
+			.base	= EXYNOS4_GPY3(0),
+			.ngpio	= EXYNOS4_GPIO_Y3_NR,
+			.label	= "GPY3",
+		},
+	}, {
+		.config	= &gpio_cfg_noint,
+		.chip	= {
+			.base	= EXYNOS4_GPY4(0),
+			.ngpio	= EXYNOS4_GPIO_Y4_NR,
+			.label	= "GPY4",
+		},
+	}, {
+		.config	= &gpio_cfg_noint,
+		.chip	= {
+			.base	= EXYNOS4_GPY5(0),
+			.ngpio	= EXYNOS4_GPIO_Y5_NR,
+			.label	= "GPY5",
+		},
+	}, {
+		.config	= &gpio_cfg_noint,
+		.chip	= {
+			.base	= EXYNOS4_GPY6(0),
+			.ngpio	= EXYNOS4_GPIO_Y6_NR,
+			.label	= "GPY6",
+		},
+	}, {
+		.base	= (S5P_VA_GPIO2 + 0xC00),
+		.config	= &gpio_cfg_noint,
+		.irq_base = IRQ_EINT(0),
+		.chip	= {
+			.base	= EXYNOS4_GPX0(0),
+			.ngpio	= EXYNOS4_GPIO_X0_NR,
+			.label	= "GPX0",
+			.to_irq	= samsung_gpiolib_to_irq,
+		},
+	}, {
+		.base	= (S5P_VA_GPIO2 + 0xC20),
+		.config	= &gpio_cfg_noint,
+		.irq_base = IRQ_EINT(8),
+		.chip	= {
+			.base	= EXYNOS4_GPX1(0),
+			.ngpio	= EXYNOS4_GPIO_X1_NR,
+			.label	= "GPX1",
+			.to_irq	= samsung_gpiolib_to_irq,
+		},
+	}, {
+		.base	= (S5P_VA_GPIO2 + 0xC40),
+		.config	= &gpio_cfg_noint,
+		.irq_base = IRQ_EINT(16),
+		.chip	= {
+			.base	= EXYNOS4_GPX2(0),
+			.ngpio	= EXYNOS4_GPIO_X2_NR,
+			.label	= "GPX2",
+			.to_irq	= samsung_gpiolib_to_irq,
+		},
+	}, {
+		.base	= (S5P_VA_GPIO2 + 0xC60),
+		.config	= &gpio_cfg_noint,
+		.irq_base = IRQ_EINT(24),
+		.chip	= {
+			.base	= EXYNOS4_GPX3(0),
+			.ngpio	= EXYNOS4_GPIO_X3_NR,
+			.label	= "GPX3",
+			.to_irq	= samsung_gpiolib_to_irq,
+		},
+	},
+};
+
+static struct s3c_gpio_chip exynos4_gpio_part3_4bit[] = {
+	{
+		.chip	= {
+			.base	= EXYNOS4_GPZ(0),
+			.ngpio	= EXYNOS4_GPIO_Z_NR,
+			.label	= "GPZ",
+		},
+	},
+};
+
+static __init int exynos4_gpiolib_init(void)
+{
+	struct s3c_gpio_chip *chip;
+	int i;
+	int group = 0;
+	int nr_chips;
+
+	/* GPIO part 1 */
+
+	chip = exynos4_gpio_part1_4bit;
+	nr_chips = ARRAY_SIZE(exynos4_gpio_part1_4bit);
+
+	for (i = 0; i < nr_chips; i++, chip++) {
+		if (chip->config == NULL) {
+			chip->config = &gpio_cfg;
+			/* Assign the GPIO interrupt group */
+			chip->group = group++;
+		}
+		if (chip->base == NULL)
+			chip->base = S5P_VA_GPIO1 + (i) * 0x20;
+	}
+
+	samsung_gpiolib_add_4bit_chips(exynos4_gpio_part1_4bit, nr_chips);
+
+	/* GPIO part 2 */
+
+	chip = exynos4_gpio_part2_4bit;
+	nr_chips = ARRAY_SIZE(exynos4_gpio_part2_4bit);
+
+	for (i = 0; i < nr_chips; i++, chip++) {
+		if (chip->config == NULL) {
+			chip->config = &gpio_cfg;
+			/* Assign the GPIO interrupt group */
+			chip->group = group++;
+		}
+		if (chip->base == NULL)
+			chip->base = S5P_VA_GPIO2 + (i) * 0x20;
+	}
+
+	samsung_gpiolib_add_4bit_chips(exynos4_gpio_part2_4bit, nr_chips);
+
+	/* GPIO part 3 */
+
+	chip = exynos4_gpio_part3_4bit;
+	nr_chips = ARRAY_SIZE(exynos4_gpio_part3_4bit);
+
+	for (i = 0; i < nr_chips; i++, chip++) {
+		if (chip->config == NULL) {
+			chip->config = &gpio_cfg;
+			/* Assign the GPIO interrupt group */
+			chip->group = group++;
+		}
+		if (chip->base == NULL)
+			chip->base = S5P_VA_GPIO3 + (i) * 0x20;
+	}
+
+	samsung_gpiolib_add_4bit_chips(exynos4_gpio_part3_4bit, nr_chips);
+	s5p_register_gpioint_bank(IRQ_GPIO_XA, 0, IRQ_GPIO1_NR_GROUPS);
+	s5p_register_gpioint_bank(IRQ_GPIO_XB, IRQ_GPIO1_NR_GROUPS, IRQ_GPIO2_NR_GROUPS);
+
+	return 0;
+}
+core_initcall(exynos4_gpiolib_init);
-- 
1.7.5.1.300.gc565c

