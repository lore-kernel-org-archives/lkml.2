Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935387Ab1ETFpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 01:45:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27888 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932611Ab1ETFpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 01:45:12 -0400
X-AuditID: cbfee61a-b7ce2ae000001a8f-23-4dd5ffe32df0
Date: Fri, 20 May 2011 14:45:00 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH 3/4] Move the s5pv210 GPIO to drivers/gpio
To: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, kgene.kim@samsung.com, linux-arm-kernel@lists.infradead.org
Message-id: <20110520054500.GA9966@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 20 May 2011 05:45:06.0424 (UTC)
 FILETIME=[129D8F80:01CC16B1]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

Move the Samsung s5pv210 SoC GPIO driver to drivers/gpio

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-s5pv210/Makefile  |    2 +-
 arch/arm/mach-s5pv210/gpiolib.c |  288 ---------------------------------------
 drivers/gpio/Kconfig            |    6 +
 drivers/gpio/Makefile           |    1 +
 drivers/gpio/s5pv210-gpio.c     |  288 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 296 insertions(+), 289 deletions(-)
 delete mode 100644 arch/arm/mach-s5pv210/gpiolib.c
 create mode 100644 drivers/gpio/s5pv210-gpio.c

diff --git a/arch/arm/mach-s5pv210/Makefile b/arch/arm/mach-s5pv210/Makefile
index 11f1790..50907ac 100644
--- a/arch/arm/mach-s5pv210/Makefile
+++ b/arch/arm/mach-s5pv210/Makefile
@@ -12,7 +12,7 @@ obj-				:=
 
 # Core support for S5PV210 system
 
-obj-$(CONFIG_CPU_S5PV210)	+= cpu.o init.o clock.o dma.o gpiolib.o
+obj-$(CONFIG_CPU_S5PV210)	+= cpu.o init.o clock.o dma.o
 obj-$(CONFIG_CPU_S5PV210)	+= setup-i2c0.o
 obj-$(CONFIG_S5PV210_PM)	+= pm.o sleep.o
 obj-$(CONFIG_CPU_FREQ)		+= cpufreq.o
diff --git a/arch/arm/mach-s5pv210/gpiolib.c b/arch/arm/mach-s5pv210/gpiolib.c
deleted file mode 100644
index 1ba20a7..0000000
--- a/arch/arm/mach-s5pv210/gpiolib.c
+++ /dev/null
@@ -1,288 +0,0 @@
-/* linux/arch/arm/mach-s5pv210/gpiolib.c
- *
- * Copyright (c) 2010 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com/
- *
- * S5PV210 - GPIOlib support
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/kernel.h>
-#include <linux/irq.h>
-#include <linux/io.h>
-#include <linux/gpio.h>
-#include <plat/gpio-core.h>
-#include <plat/gpio-cfg.h>
-#include <plat/gpio-cfg-helpers.h>
-#include <mach/map.h>
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
-/* GPIO bank's base address given the index of the bank in the
- * list of all gpio banks.
- */
-#define S5PV210_BANK_BASE(bank_nr)	(S5P_VA_GPIO + ((bank_nr) * 0x20))
-
-/*
- * Following are the gpio banks in v210.
- *
- * The 'config' member when left to NULL, is initialized to the default
- * structure gpio_cfg in the init function below.
- *
- * The 'base' member is also initialized in the init function below.
- * Note: The initialization of 'base' member of s3c_gpio_chip structure
- * uses the above macro and depends on the banks being listed in order here.
- */
-static struct s3c_gpio_chip s5pv210_gpio_4bit[] = {
-	{
-		.chip	= {
-			.base	= S5PV210_GPA0(0),
-			.ngpio	= S5PV210_GPIO_A0_NR,
-			.label	= "GPA0",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPA1(0),
-			.ngpio	= S5PV210_GPIO_A1_NR,
-			.label	= "GPA1",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPB(0),
-			.ngpio	= S5PV210_GPIO_B_NR,
-			.label	= "GPB",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPC0(0),
-			.ngpio	= S5PV210_GPIO_C0_NR,
-			.label	= "GPC0",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPC1(0),
-			.ngpio	= S5PV210_GPIO_C1_NR,
-			.label	= "GPC1",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPD0(0),
-			.ngpio	= S5PV210_GPIO_D0_NR,
-			.label	= "GPD0",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPD1(0),
-			.ngpio	= S5PV210_GPIO_D1_NR,
-			.label	= "GPD1",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPE0(0),
-			.ngpio	= S5PV210_GPIO_E0_NR,
-			.label	= "GPE0",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPE1(0),
-			.ngpio	= S5PV210_GPIO_E1_NR,
-			.label	= "GPE1",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPF0(0),
-			.ngpio	= S5PV210_GPIO_F0_NR,
-			.label	= "GPF0",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPF1(0),
-			.ngpio	= S5PV210_GPIO_F1_NR,
-			.label	= "GPF1",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPF2(0),
-			.ngpio	= S5PV210_GPIO_F2_NR,
-			.label	= "GPF2",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPF3(0),
-			.ngpio	= S5PV210_GPIO_F3_NR,
-			.label	= "GPF3",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPG0(0),
-			.ngpio	= S5PV210_GPIO_G0_NR,
-			.label	= "GPG0",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPG1(0),
-			.ngpio	= S5PV210_GPIO_G1_NR,
-			.label	= "GPG1",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPG2(0),
-			.ngpio	= S5PV210_GPIO_G2_NR,
-			.label	= "GPG2",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPG3(0),
-			.ngpio	= S5PV210_GPIO_G3_NR,
-			.label	= "GPG3",
-		},
-	}, {
-		.config	= &gpio_cfg_noint,
-		.chip	= {
-			.base	= S5PV210_GPI(0),
-			.ngpio	= S5PV210_GPIO_I_NR,
-			.label	= "GPI",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPJ0(0),
-			.ngpio	= S5PV210_GPIO_J0_NR,
-			.label	= "GPJ0",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPJ1(0),
-			.ngpio	= S5PV210_GPIO_J1_NR,
-			.label	= "GPJ1",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPJ2(0),
-			.ngpio	= S5PV210_GPIO_J2_NR,
-			.label	= "GPJ2",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPJ3(0),
-			.ngpio	= S5PV210_GPIO_J3_NR,
-			.label	= "GPJ3",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPJ4(0),
-			.ngpio	= S5PV210_GPIO_J4_NR,
-			.label	= "GPJ4",
-		},
-	}, {
-		.config	= &gpio_cfg_noint,
-		.chip	= {
-			.base	= S5PV210_MP01(0),
-			.ngpio	= S5PV210_GPIO_MP01_NR,
-			.label	= "MP01",
-		},
-	}, {
-		.config	= &gpio_cfg_noint,
-		.chip	= {
-			.base	= S5PV210_MP02(0),
-			.ngpio	= S5PV210_GPIO_MP02_NR,
-			.label	= "MP02",
-		},
-	}, {
-		.config	= &gpio_cfg_noint,
-		.chip	= {
-			.base	= S5PV210_MP03(0),
-			.ngpio	= S5PV210_GPIO_MP03_NR,
-			.label	= "MP03",
-		},
-	}, {
-		.config	= &gpio_cfg_noint,
-		.chip	= {
-			.base	= S5PV210_MP04(0),
-			.ngpio	= S5PV210_GPIO_MP04_NR,
-			.label	= "MP04",
-		},
-	}, {
-		.config	= &gpio_cfg_noint,
-		.chip	= {
-			.base	= S5PV210_MP05(0),
-			.ngpio	= S5PV210_GPIO_MP05_NR,
-			.label	= "MP05",
-		},
-	}, {
-		.base	= (S5P_VA_GPIO + 0xC00),
-		.config	= &gpio_cfg_noint,
-		.irq_base = IRQ_EINT(0),
-		.chip	= {
-			.base	= S5PV210_GPH0(0),
-			.ngpio	= S5PV210_GPIO_H0_NR,
-			.label	= "GPH0",
-			.to_irq = samsung_gpiolib_to_irq,
-		},
-	}, {
-		.base	= (S5P_VA_GPIO + 0xC20),
-		.config	= &gpio_cfg_noint,
-		.irq_base = IRQ_EINT(8),
-		.chip	= {
-			.base	= S5PV210_GPH1(0),
-			.ngpio	= S5PV210_GPIO_H1_NR,
-			.label	= "GPH1",
-			.to_irq = samsung_gpiolib_to_irq,
-		},
-	}, {
-		.base	= (S5P_VA_GPIO + 0xC40),
-		.config	= &gpio_cfg_noint,
-		.irq_base = IRQ_EINT(16),
-		.chip	= {
-			.base	= S5PV210_GPH2(0),
-			.ngpio	= S5PV210_GPIO_H2_NR,
-			.label	= "GPH2",
-			.to_irq = samsung_gpiolib_to_irq,
-		},
-	}, {
-		.base	= (S5P_VA_GPIO + 0xC60),
-		.config	= &gpio_cfg_noint,
-		.irq_base = IRQ_EINT(24),
-		.chip	= {
-			.base	= S5PV210_GPH3(0),
-			.ngpio	= S5PV210_GPIO_H3_NR,
-			.label	= "GPH3",
-			.to_irq = samsung_gpiolib_to_irq,
-		},
-	},
-};
-
-static __init int s5pv210_gpiolib_init(void)
-{
-	struct s3c_gpio_chip *chip = s5pv210_gpio_4bit;
-	int nr_chips = ARRAY_SIZE(s5pv210_gpio_4bit);
-	int gpioint_group = 0;
-	int i = 0;
-
-	for (i = 0; i < nr_chips; i++, chip++) {
-		if (chip->config == NULL) {
-			chip->config = &gpio_cfg;
-			chip->group = gpioint_group++;
-		}
-		if (chip->base == NULL)
-			chip->base = S5PV210_BANK_BASE(i);
-	}
-
-	samsung_gpiolib_add_4bit_chips(s5pv210_gpio_4bit, nr_chips);
-	s5p_register_gpioint_bank(IRQ_GPIOINT, 0, S5P_GPIOINT_GROUP_MAXNR);
-
-	return 0;
-}
-core_initcall(s5pv210_gpiolib_init);
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 03e7310..5da12fc 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -87,6 +87,12 @@ config GPIO_SAMSUNG
 	help
 	  Say yes here to support Samsung SoCs GPIO library
 
+config GPIO_S5PV210
+	bool "Samsung S5PV210/S5PC110 GPIO library support"
+	default y if CPU_S5PV210
+	help
+	  Say yes here to support Samsung S5PV210/S5PC110 SoC GPIO library
+
 config GPIO_IT8761E
 	tristate "IT8761E GPIO support"
 	depends on GPIOLIB
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 978ab87..d738a31 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_GPIO_ADP5588)	+= adp5588-gpio.o
 obj-$(CONFIG_GPIO_BASIC_MMIO)	+= basic_mmio_gpio.o
 obj-$(CONFIG_GPIO_EXYNOS4)	+= exynos4-gpio.o
 obj-$(CONFIG_GPIO_SAMSUNG)	+= samsung-gpiolib.o
+obj-$(CONFIG_GPIO_S5PV210)	+= s5pv210-gpio.o
 obj-$(CONFIG_GPIO_LANGWELL)	+= langwell_gpio.o
 obj-$(CONFIG_GPIO_MAX730X)	+= max730x.o
 obj-$(CONFIG_GPIO_MAX7300)	+= max7300.o
diff --git a/drivers/gpio/s5pv210-gpio.c b/drivers/gpio/s5pv210-gpio.c
new file mode 100644
index 0000000..1ba20a7
--- /dev/null
+++ b/drivers/gpio/s5pv210-gpio.c
@@ -0,0 +1,288 @@
+/* linux/arch/arm/mach-s5pv210/gpiolib.c
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * S5PV210 - GPIOlib support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/irq.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+#include <plat/gpio-core.h>
+#include <plat/gpio-cfg.h>
+#include <plat/gpio-cfg-helpers.h>
+#include <mach/map.h>
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
+/* GPIO bank's base address given the index of the bank in the
+ * list of all gpio banks.
+ */
+#define S5PV210_BANK_BASE(bank_nr)	(S5P_VA_GPIO + ((bank_nr) * 0x20))
+
+/*
+ * Following are the gpio banks in v210.
+ *
+ * The 'config' member when left to NULL, is initialized to the default
+ * structure gpio_cfg in the init function below.
+ *
+ * The 'base' member is also initialized in the init function below.
+ * Note: The initialization of 'base' member of s3c_gpio_chip structure
+ * uses the above macro and depends on the banks being listed in order here.
+ */
+static struct s3c_gpio_chip s5pv210_gpio_4bit[] = {
+	{
+		.chip	= {
+			.base	= S5PV210_GPA0(0),
+			.ngpio	= S5PV210_GPIO_A0_NR,
+			.label	= "GPA0",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PV210_GPA1(0),
+			.ngpio	= S5PV210_GPIO_A1_NR,
+			.label	= "GPA1",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PV210_GPB(0),
+			.ngpio	= S5PV210_GPIO_B_NR,
+			.label	= "GPB",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PV210_GPC0(0),
+			.ngpio	= S5PV210_GPIO_C0_NR,
+			.label	= "GPC0",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PV210_GPC1(0),
+			.ngpio	= S5PV210_GPIO_C1_NR,
+			.label	= "GPC1",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PV210_GPD0(0),
+			.ngpio	= S5PV210_GPIO_D0_NR,
+			.label	= "GPD0",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PV210_GPD1(0),
+			.ngpio	= S5PV210_GPIO_D1_NR,
+			.label	= "GPD1",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PV210_GPE0(0),
+			.ngpio	= S5PV210_GPIO_E0_NR,
+			.label	= "GPE0",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PV210_GPE1(0),
+			.ngpio	= S5PV210_GPIO_E1_NR,
+			.label	= "GPE1",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PV210_GPF0(0),
+			.ngpio	= S5PV210_GPIO_F0_NR,
+			.label	= "GPF0",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PV210_GPF1(0),
+			.ngpio	= S5PV210_GPIO_F1_NR,
+			.label	= "GPF1",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PV210_GPF2(0),
+			.ngpio	= S5PV210_GPIO_F2_NR,
+			.label	= "GPF2",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PV210_GPF3(0),
+			.ngpio	= S5PV210_GPIO_F3_NR,
+			.label	= "GPF3",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PV210_GPG0(0),
+			.ngpio	= S5PV210_GPIO_G0_NR,
+			.label	= "GPG0",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PV210_GPG1(0),
+			.ngpio	= S5PV210_GPIO_G1_NR,
+			.label	= "GPG1",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PV210_GPG2(0),
+			.ngpio	= S5PV210_GPIO_G2_NR,
+			.label	= "GPG2",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PV210_GPG3(0),
+			.ngpio	= S5PV210_GPIO_G3_NR,
+			.label	= "GPG3",
+		},
+	}, {
+		.config	= &gpio_cfg_noint,
+		.chip	= {
+			.base	= S5PV210_GPI(0),
+			.ngpio	= S5PV210_GPIO_I_NR,
+			.label	= "GPI",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PV210_GPJ0(0),
+			.ngpio	= S5PV210_GPIO_J0_NR,
+			.label	= "GPJ0",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PV210_GPJ1(0),
+			.ngpio	= S5PV210_GPIO_J1_NR,
+			.label	= "GPJ1",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PV210_GPJ2(0),
+			.ngpio	= S5PV210_GPIO_J2_NR,
+			.label	= "GPJ2",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PV210_GPJ3(0),
+			.ngpio	= S5PV210_GPIO_J3_NR,
+			.label	= "GPJ3",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PV210_GPJ4(0),
+			.ngpio	= S5PV210_GPIO_J4_NR,
+			.label	= "GPJ4",
+		},
+	}, {
+		.config	= &gpio_cfg_noint,
+		.chip	= {
+			.base	= S5PV210_MP01(0),
+			.ngpio	= S5PV210_GPIO_MP01_NR,
+			.label	= "MP01",
+		},
+	}, {
+		.config	= &gpio_cfg_noint,
+		.chip	= {
+			.base	= S5PV210_MP02(0),
+			.ngpio	= S5PV210_GPIO_MP02_NR,
+			.label	= "MP02",
+		},
+	}, {
+		.config	= &gpio_cfg_noint,
+		.chip	= {
+			.base	= S5PV210_MP03(0),
+			.ngpio	= S5PV210_GPIO_MP03_NR,
+			.label	= "MP03",
+		},
+	}, {
+		.config	= &gpio_cfg_noint,
+		.chip	= {
+			.base	= S5PV210_MP04(0),
+			.ngpio	= S5PV210_GPIO_MP04_NR,
+			.label	= "MP04",
+		},
+	}, {
+		.config	= &gpio_cfg_noint,
+		.chip	= {
+			.base	= S5PV210_MP05(0),
+			.ngpio	= S5PV210_GPIO_MP05_NR,
+			.label	= "MP05",
+		},
+	}, {
+		.base	= (S5P_VA_GPIO + 0xC00),
+		.config	= &gpio_cfg_noint,
+		.irq_base = IRQ_EINT(0),
+		.chip	= {
+			.base	= S5PV210_GPH0(0),
+			.ngpio	= S5PV210_GPIO_H0_NR,
+			.label	= "GPH0",
+			.to_irq = samsung_gpiolib_to_irq,
+		},
+	}, {
+		.base	= (S5P_VA_GPIO + 0xC20),
+		.config	= &gpio_cfg_noint,
+		.irq_base = IRQ_EINT(8),
+		.chip	= {
+			.base	= S5PV210_GPH1(0),
+			.ngpio	= S5PV210_GPIO_H1_NR,
+			.label	= "GPH1",
+			.to_irq = samsung_gpiolib_to_irq,
+		},
+	}, {
+		.base	= (S5P_VA_GPIO + 0xC40),
+		.config	= &gpio_cfg_noint,
+		.irq_base = IRQ_EINT(16),
+		.chip	= {
+			.base	= S5PV210_GPH2(0),
+			.ngpio	= S5PV210_GPIO_H2_NR,
+			.label	= "GPH2",
+			.to_irq = samsung_gpiolib_to_irq,
+		},
+	}, {
+		.base	= (S5P_VA_GPIO + 0xC60),
+		.config	= &gpio_cfg_noint,
+		.irq_base = IRQ_EINT(24),
+		.chip	= {
+			.base	= S5PV210_GPH3(0),
+			.ngpio	= S5PV210_GPIO_H3_NR,
+			.label	= "GPH3",
+			.to_irq = samsung_gpiolib_to_irq,
+		},
+	},
+};
+
+static __init int s5pv210_gpiolib_init(void)
+{
+	struct s3c_gpio_chip *chip = s5pv210_gpio_4bit;
+	int nr_chips = ARRAY_SIZE(s5pv210_gpio_4bit);
+	int gpioint_group = 0;
+	int i = 0;
+
+	for (i = 0; i < nr_chips; i++, chip++) {
+		if (chip->config == NULL) {
+			chip->config = &gpio_cfg;
+			chip->group = gpioint_group++;
+		}
+		if (chip->base == NULL)
+			chip->base = S5PV210_BANK_BASE(i);
+	}
+
+	samsung_gpiolib_add_4bit_chips(s5pv210_gpio_4bit, nr_chips);
+	s5p_register_gpioint_bank(IRQ_GPIOINT, 0, S5P_GPIOINT_GROUP_MAXNR);
+
+	return 0;
+}
+core_initcall(s5pv210_gpiolib_init);
-- 
1.7.5.1.300.gc565c

