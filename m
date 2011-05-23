Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab1EWI2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 04:28:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43376 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab1EWI2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 04:28:05 -0400
X-AuditID: cbfee61b-b7c62ae0000056ed-1f-4dda1a9305a9
Date: Mon, 23 May 2011 17:27:58 +0900
From: Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 4/4] Move the s5pc100 GPIO to drivers/gpio
To: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, kgene.kim@samsung.com, linux-arm-kernel@lists.infradead.org
Message-id: <20110523082758.GA6209@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 23 May 2011 08:28:02.0812 (UTC)
 FILETIME=[55093BC0:01CC1923]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

Move the Samsung s5pc100 SoC GPIO driver to drivers/gpio

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-s5pc100/Makefile  |    2 +-
 arch/arm/mach-s5pc100/gpiolib.c |  355 ---------------------------------------
 drivers/gpio/Kconfig            |    6 +
 drivers/gpio/Makefile           |    1 +
 drivers/gpio/gpio-s5pc100.c     |  355 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 363 insertions(+), 356 deletions(-)
 delete mode 100644 arch/arm/mach-s5pc100/gpiolib.c
 create mode 100644 drivers/gpio/gpio-s5pc100.c

diff --git a/arch/arm/mach-s5pc100/Makefile b/arch/arm/mach-s5pc100/Makefile
index eecab57..a5e6e60 100644
--- a/arch/arm/mach-s5pc100/Makefile
+++ b/arch/arm/mach-s5pc100/Makefile
@@ -11,7 +11,7 @@ obj-				:=
 
 # Core support for S5PC100 system
 
-obj-$(CONFIG_CPU_S5PC100)	+= cpu.o init.o clock.o gpiolib.o
+obj-$(CONFIG_CPU_S5PC100)	+= cpu.o init.o clock.o
 obj-$(CONFIG_CPU_S5PC100)	+= setup-i2c0.o
 obj-$(CONFIG_CPU_S5PC100)	+= dma.o
 
diff --git a/arch/arm/mach-s5pc100/gpiolib.c b/arch/arm/mach-s5pc100/gpiolib.c
deleted file mode 100644
index 2842394..0000000
--- a/arch/arm/mach-s5pc100/gpiolib.c
+++ /dev/null
@@ -1,355 +0,0 @@
-/* linux/arch/arm/mach-s5pc100/gpiolib.c
- *
- * Copyright (c) 2010 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com
- *
- *  Copyright 2009 Samsung Electronics Co
- *  Kyungmin Park <kyungmin.park@samsung.com>
- *
- * S5PC100 - GPIOlib support
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
-
-#include <mach/map.h>
-#include <mach/regs-gpio.h>
-
-#include <plat/gpio-core.h>
-#include <plat/gpio-cfg.h>
-#include <plat/gpio-cfg-helpers.h>
-
-/* S5PC100 GPIO bank summary:
- *
- * Bank	GPIOs	Style	INT Type
- * A0	8	4Bit	GPIO_INT0
- * A1	5	4Bit	GPIO_INT1
- * B	8	4Bit	GPIO_INT2
- * C	5	4Bit	GPIO_INT3
- * D	7	4Bit	GPIO_INT4
- * E0	8	4Bit	GPIO_INT5
- * E1	6	4Bit	GPIO_INT6
- * F0	8	4Bit	GPIO_INT7
- * F1	8	4Bit	GPIO_INT8
- * F2	8	4Bit	GPIO_INT9
- * F3	4	4Bit	GPIO_INT10
- * G0	8	4Bit	GPIO_INT11
- * G1	3	4Bit	GPIO_INT12
- * G2	7	4Bit	GPIO_INT13
- * G3	7	4Bit	GPIO_INT14
- * H0	8	4Bit	WKUP_INT
- * H1	8	4Bit	WKUP_INT
- * H2	8	4Bit	WKUP_INT
- * H3	8	4Bit	WKUP_INT
- * I	8	4Bit	GPIO_INT15
- * J0	8	4Bit	GPIO_INT16
- * J1	5	4Bit	GPIO_INT17
- * J2	8	4Bit	GPIO_INT18
- * J3	8	4Bit	GPIO_INT19
- * J4	4	4Bit	GPIO_INT20
- * K0	8	4Bit	None
- * K1	6	4Bit	None
- * K2	8	4Bit	None
- * K3	8	4Bit	None
- * L0	8	4Bit	None
- * L1	8	4Bit	None
- * L2	8	4Bit	None
- * L3	8	4Bit	None
- */
-
-static struct s3c_gpio_cfg gpio_cfg = {
-	.set_config	= s3c_gpio_setcfg_s3c64xx_4bit,
-	.set_pull	= s3c_gpio_setpull_updown,
-	.get_pull	= s3c_gpio_getpull_updown,
-};
-
-static struct s3c_gpio_cfg gpio_cfg_eint = {
-	.cfg_eint	= 0xf,
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
- * GPIO bank's base address given the index of the bank in the
- * list of all gpio banks.
- */
-#define S5PC100_BANK_BASE(bank_nr)	(S5P_VA_GPIO + ((bank_nr) * 0x20))
-
-/*
- * Following are the gpio banks in S5PC100.
- *
- * The 'config' member when left to NULL, is initialized to the default
- * structure gpio_cfg in the init function below.
- *
- * The 'base' member is also initialized in the init function below.
- * Note: The initialization of 'base' member of s3c_gpio_chip structure
- * uses the above macro and depends on the banks being listed in order here.
- */
-static struct s3c_gpio_chip s5pc100_gpio_chips[] = {
-	{
-		.chip	= {
-			.base	= S5PC100_GPA0(0),
-			.ngpio	= S5PC100_GPIO_A0_NR,
-			.label	= "GPA0",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PC100_GPA1(0),
-			.ngpio	= S5PC100_GPIO_A1_NR,
-			.label	= "GPA1",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PC100_GPB(0),
-			.ngpio	= S5PC100_GPIO_B_NR,
-			.label	= "GPB",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PC100_GPC(0),
-			.ngpio	= S5PC100_GPIO_C_NR,
-			.label	= "GPC",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PC100_GPD(0),
-			.ngpio	= S5PC100_GPIO_D_NR,
-			.label	= "GPD",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PC100_GPE0(0),
-			.ngpio	= S5PC100_GPIO_E0_NR,
-			.label	= "GPE0",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PC100_GPE1(0),
-			.ngpio	= S5PC100_GPIO_E1_NR,
-			.label	= "GPE1",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PC100_GPF0(0),
-			.ngpio	= S5PC100_GPIO_F0_NR,
-			.label	= "GPF0",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PC100_GPF1(0),
-			.ngpio	= S5PC100_GPIO_F1_NR,
-			.label	= "GPF1",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PC100_GPF2(0),
-			.ngpio	= S5PC100_GPIO_F2_NR,
-			.label	= "GPF2",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PC100_GPF3(0),
-			.ngpio	= S5PC100_GPIO_F3_NR,
-			.label	= "GPF3",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PC100_GPG0(0),
-			.ngpio	= S5PC100_GPIO_G0_NR,
-			.label	= "GPG0",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PC100_GPG1(0),
-			.ngpio	= S5PC100_GPIO_G1_NR,
-			.label	= "GPG1",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PC100_GPG2(0),
-			.ngpio	= S5PC100_GPIO_G2_NR,
-			.label	= "GPG2",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PC100_GPG3(0),
-			.ngpio	= S5PC100_GPIO_G3_NR,
-			.label	= "GPG3",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PC100_GPI(0),
-			.ngpio	= S5PC100_GPIO_I_NR,
-			.label	= "GPI",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PC100_GPJ0(0),
-			.ngpio	= S5PC100_GPIO_J0_NR,
-			.label	= "GPJ0",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PC100_GPJ1(0),
-			.ngpio	= S5PC100_GPIO_J1_NR,
-			.label	= "GPJ1",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PC100_GPJ2(0),
-			.ngpio	= S5PC100_GPIO_J2_NR,
-			.label	= "GPJ2",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PC100_GPJ3(0),
-			.ngpio	= S5PC100_GPIO_J3_NR,
-			.label	= "GPJ3",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PC100_GPJ4(0),
-			.ngpio	= S5PC100_GPIO_J4_NR,
-			.label	= "GPJ4",
-		},
-	}, {
-		.config	= &gpio_cfg_noint,
-		.chip	= {
-			.base	= S5PC100_GPK0(0),
-			.ngpio	= S5PC100_GPIO_K0_NR,
-			.label	= "GPK0",
-		},
-	}, {
-		.config	= &gpio_cfg_noint,
-		.chip	= {
-			.base	= S5PC100_GPK1(0),
-			.ngpio	= S5PC100_GPIO_K1_NR,
-			.label	= "GPK1",
-		},
-	}, {
-		.config	= &gpio_cfg_noint,
-		.chip	= {
-			.base	= S5PC100_GPK2(0),
-			.ngpio	= S5PC100_GPIO_K2_NR,
-			.label	= "GPK2",
-		},
-	}, {
-		.config	= &gpio_cfg_noint,
-		.chip	= {
-			.base	= S5PC100_GPK3(0),
-			.ngpio	= S5PC100_GPIO_K3_NR,
-			.label	= "GPK3",
-		},
-	}, {
-		.config	= &gpio_cfg_noint,
-		.chip	= {
-			.base	= S5PC100_GPL0(0),
-			.ngpio	= S5PC100_GPIO_L0_NR,
-			.label	= "GPL0",
-		},
-	}, {
-		.config	= &gpio_cfg_noint,
-		.chip	= {
-			.base	= S5PC100_GPL1(0),
-			.ngpio	= S5PC100_GPIO_L1_NR,
-			.label	= "GPL1",
-		},
-	}, {
-		.config	= &gpio_cfg_noint,
-		.chip	= {
-			.base	= S5PC100_GPL2(0),
-			.ngpio	= S5PC100_GPIO_L2_NR,
-			.label	= "GPL2",
-		},
-	}, {
-		.config	= &gpio_cfg_noint,
-		.chip	= {
-			.base	= S5PC100_GPL3(0),
-			.ngpio	= S5PC100_GPIO_L3_NR,
-			.label	= "GPL3",
-		},
-	}, {
-		.config	= &gpio_cfg_noint,
-		.chip	= {
-			.base	= S5PC100_GPL4(0),
-			.ngpio	= S5PC100_GPIO_L4_NR,
-			.label	= "GPL4",
-		},
-	}, {
-		.base	= (S5P_VA_GPIO + 0xC00),
-		.config	= &gpio_cfg_eint,
-		.irq_base = IRQ_EINT(0),
-		.chip	= {
-			.base	= S5PC100_GPH0(0),
-			.ngpio	= S5PC100_GPIO_H0_NR,
-			.label	= "GPH0",
-			.to_irq = samsung_gpiolib_to_irq,
-		},
-	}, {
-		.base	= (S5P_VA_GPIO + 0xC20),
-		.config	= &gpio_cfg_eint,
-		.irq_base = IRQ_EINT(8),
-		.chip	= {
-			.base	= S5PC100_GPH1(0),
-			.ngpio	= S5PC100_GPIO_H1_NR,
-			.label	= "GPH1",
-			.to_irq = samsung_gpiolib_to_irq,
-		},
-	}, {
-		.base	= (S5P_VA_GPIO + 0xC40),
-		.config	= &gpio_cfg_eint,
-		.irq_base = IRQ_EINT(16),
-		.chip	= {
-			.base	= S5PC100_GPH2(0),
-			.ngpio	= S5PC100_GPIO_H2_NR,
-			.label	= "GPH2",
-			.to_irq = samsung_gpiolib_to_irq,
-		},
-	}, {
-		.base	= (S5P_VA_GPIO + 0xC60),
-		.config	= &gpio_cfg_eint,
-		.irq_base = IRQ_EINT(24),
-		.chip	= {
-			.base	= S5PC100_GPH3(0),
-			.ngpio	= S5PC100_GPIO_H3_NR,
-			.label	= "GPH3",
-			.to_irq = samsung_gpiolib_to_irq,
-		},
-	},
-};
-
-static __init int s5pc100_gpiolib_init(void)
-{
-	struct s3c_gpio_chip *chip = s5pc100_gpio_chips;
-	int nr_chips = ARRAY_SIZE(s5pc100_gpio_chips);
-	int gpioint_group = 0;
-	int i;
-
-	for (i = 0; i < nr_chips; i++, chip++) {
-		if (chip->config == NULL) {
-			chip->config = &gpio_cfg;
-			chip->group = gpioint_group++;
-		}
-		if (chip->base == NULL)
-			chip->base = S5PC100_BANK_BASE(i);
-	}
-
-	samsung_gpiolib_add_4bit_chips(s5pc100_gpio_chips, nr_chips);
-	s5p_register_gpioint_bank(IRQ_GPIOINT, 0, S5P_GPIOINT_GROUP_MAXNR);
-
-	return 0;
-}
-core_initcall(s5pc100_gpiolib_init);
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 1ab0728..d90dfa3 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -93,6 +93,12 @@ config GPIO_PLAT_SAMSUNG
 	help
 	  Say yes here to support Samsung SoCs GPIO library
 
+config GPIO_S5PC100
+	bool "Samsung S5PC100 GPIO library support"
+	default y if CPU_S5PC100
+	help
+	  Say yes here to support Samsung S5PC100 SoCs GPIO library
+
 config GPIO_S5PV210
 	bool "Samsung S5PV210/S5PC110 GPIO library support"
 	default y if CPU_S5PV210
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index a54992b..c42edc3 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_GPIO_ADP5588)	+= adp5588-gpio.o
 obj-$(CONFIG_GPIO_BASIC_MMIO)	+= basic_mmio_gpio.o
 obj-$(CONFIG_GPIO_EXYNOS4)	+= gpio-exynos4.o
 obj-$(CONFIG_GPIO_PLAT_SAMSUNG)	+= gpio-plat-samsung.o
+obj-$(CONFIG_GPIO_S5PC100)	+= gpio-s5pc100.o
 obj-$(CONFIG_GPIO_S5PV210)	+= gpio-s5pv210.o
 obj-$(CONFIG_GPIO_LANGWELL)	+= langwell_gpio.o
 obj-$(CONFIG_GPIO_MAX730X)	+= max730x.o
diff --git a/drivers/gpio/gpio-s5pc100.c b/drivers/gpio/gpio-s5pc100.c
new file mode 100644
index 0000000..2842394
--- /dev/null
+++ b/drivers/gpio/gpio-s5pc100.c
@@ -0,0 +1,355 @@
+/* linux/arch/arm/mach-s5pc100/gpiolib.c
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ *  Copyright 2009 Samsung Electronics Co
+ *  Kyungmin Park <kyungmin.park@samsung.com>
+ *
+ * S5PC100 - GPIOlib support
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
+
+#include <mach/map.h>
+#include <mach/regs-gpio.h>
+
+#include <plat/gpio-core.h>
+#include <plat/gpio-cfg.h>
+#include <plat/gpio-cfg-helpers.h>
+
+/* S5PC100 GPIO bank summary:
+ *
+ * Bank	GPIOs	Style	INT Type
+ * A0	8	4Bit	GPIO_INT0
+ * A1	5	4Bit	GPIO_INT1
+ * B	8	4Bit	GPIO_INT2
+ * C	5	4Bit	GPIO_INT3
+ * D	7	4Bit	GPIO_INT4
+ * E0	8	4Bit	GPIO_INT5
+ * E1	6	4Bit	GPIO_INT6
+ * F0	8	4Bit	GPIO_INT7
+ * F1	8	4Bit	GPIO_INT8
+ * F2	8	4Bit	GPIO_INT9
+ * F3	4	4Bit	GPIO_INT10
+ * G0	8	4Bit	GPIO_INT11
+ * G1	3	4Bit	GPIO_INT12
+ * G2	7	4Bit	GPIO_INT13
+ * G3	7	4Bit	GPIO_INT14
+ * H0	8	4Bit	WKUP_INT
+ * H1	8	4Bit	WKUP_INT
+ * H2	8	4Bit	WKUP_INT
+ * H3	8	4Bit	WKUP_INT
+ * I	8	4Bit	GPIO_INT15
+ * J0	8	4Bit	GPIO_INT16
+ * J1	5	4Bit	GPIO_INT17
+ * J2	8	4Bit	GPIO_INT18
+ * J3	8	4Bit	GPIO_INT19
+ * J4	4	4Bit	GPIO_INT20
+ * K0	8	4Bit	None
+ * K1	6	4Bit	None
+ * K2	8	4Bit	None
+ * K3	8	4Bit	None
+ * L0	8	4Bit	None
+ * L1	8	4Bit	None
+ * L2	8	4Bit	None
+ * L3	8	4Bit	None
+ */
+
+static struct s3c_gpio_cfg gpio_cfg = {
+	.set_config	= s3c_gpio_setcfg_s3c64xx_4bit,
+	.set_pull	= s3c_gpio_setpull_updown,
+	.get_pull	= s3c_gpio_getpull_updown,
+};
+
+static struct s3c_gpio_cfg gpio_cfg_eint = {
+	.cfg_eint	= 0xf,
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
+ * GPIO bank's base address given the index of the bank in the
+ * list of all gpio banks.
+ */
+#define S5PC100_BANK_BASE(bank_nr)	(S5P_VA_GPIO + ((bank_nr) * 0x20))
+
+/*
+ * Following are the gpio banks in S5PC100.
+ *
+ * The 'config' member when left to NULL, is initialized to the default
+ * structure gpio_cfg in the init function below.
+ *
+ * The 'base' member is also initialized in the init function below.
+ * Note: The initialization of 'base' member of s3c_gpio_chip structure
+ * uses the above macro and depends on the banks being listed in order here.
+ */
+static struct s3c_gpio_chip s5pc100_gpio_chips[] = {
+	{
+		.chip	= {
+			.base	= S5PC100_GPA0(0),
+			.ngpio	= S5PC100_GPIO_A0_NR,
+			.label	= "GPA0",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PC100_GPA1(0),
+			.ngpio	= S5PC100_GPIO_A1_NR,
+			.label	= "GPA1",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PC100_GPB(0),
+			.ngpio	= S5PC100_GPIO_B_NR,
+			.label	= "GPB",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PC100_GPC(0),
+			.ngpio	= S5PC100_GPIO_C_NR,
+			.label	= "GPC",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PC100_GPD(0),
+			.ngpio	= S5PC100_GPIO_D_NR,
+			.label	= "GPD",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PC100_GPE0(0),
+			.ngpio	= S5PC100_GPIO_E0_NR,
+			.label	= "GPE0",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PC100_GPE1(0),
+			.ngpio	= S5PC100_GPIO_E1_NR,
+			.label	= "GPE1",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PC100_GPF0(0),
+			.ngpio	= S5PC100_GPIO_F0_NR,
+			.label	= "GPF0",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PC100_GPF1(0),
+			.ngpio	= S5PC100_GPIO_F1_NR,
+			.label	= "GPF1",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PC100_GPF2(0),
+			.ngpio	= S5PC100_GPIO_F2_NR,
+			.label	= "GPF2",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PC100_GPF3(0),
+			.ngpio	= S5PC100_GPIO_F3_NR,
+			.label	= "GPF3",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PC100_GPG0(0),
+			.ngpio	= S5PC100_GPIO_G0_NR,
+			.label	= "GPG0",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PC100_GPG1(0),
+			.ngpio	= S5PC100_GPIO_G1_NR,
+			.label	= "GPG1",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PC100_GPG2(0),
+			.ngpio	= S5PC100_GPIO_G2_NR,
+			.label	= "GPG2",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PC100_GPG3(0),
+			.ngpio	= S5PC100_GPIO_G3_NR,
+			.label	= "GPG3",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PC100_GPI(0),
+			.ngpio	= S5PC100_GPIO_I_NR,
+			.label	= "GPI",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PC100_GPJ0(0),
+			.ngpio	= S5PC100_GPIO_J0_NR,
+			.label	= "GPJ0",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PC100_GPJ1(0),
+			.ngpio	= S5PC100_GPIO_J1_NR,
+			.label	= "GPJ1",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PC100_GPJ2(0),
+			.ngpio	= S5PC100_GPIO_J2_NR,
+			.label	= "GPJ2",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PC100_GPJ3(0),
+			.ngpio	= S5PC100_GPIO_J3_NR,
+			.label	= "GPJ3",
+		},
+	}, {
+		.chip	= {
+			.base	= S5PC100_GPJ4(0),
+			.ngpio	= S5PC100_GPIO_J4_NR,
+			.label	= "GPJ4",
+		},
+	}, {
+		.config	= &gpio_cfg_noint,
+		.chip	= {
+			.base	= S5PC100_GPK0(0),
+			.ngpio	= S5PC100_GPIO_K0_NR,
+			.label	= "GPK0",
+		},
+	}, {
+		.config	= &gpio_cfg_noint,
+		.chip	= {
+			.base	= S5PC100_GPK1(0),
+			.ngpio	= S5PC100_GPIO_K1_NR,
+			.label	= "GPK1",
+		},
+	}, {
+		.config	= &gpio_cfg_noint,
+		.chip	= {
+			.base	= S5PC100_GPK2(0),
+			.ngpio	= S5PC100_GPIO_K2_NR,
+			.label	= "GPK2",
+		},
+	}, {
+		.config	= &gpio_cfg_noint,
+		.chip	= {
+			.base	= S5PC100_GPK3(0),
+			.ngpio	= S5PC100_GPIO_K3_NR,
+			.label	= "GPK3",
+		},
+	}, {
+		.config	= &gpio_cfg_noint,
+		.chip	= {
+			.base	= S5PC100_GPL0(0),
+			.ngpio	= S5PC100_GPIO_L0_NR,
+			.label	= "GPL0",
+		},
+	}, {
+		.config	= &gpio_cfg_noint,
+		.chip	= {
+			.base	= S5PC100_GPL1(0),
+			.ngpio	= S5PC100_GPIO_L1_NR,
+			.label	= "GPL1",
+		},
+	}, {
+		.config	= &gpio_cfg_noint,
+		.chip	= {
+			.base	= S5PC100_GPL2(0),
+			.ngpio	= S5PC100_GPIO_L2_NR,
+			.label	= "GPL2",
+		},
+	}, {
+		.config	= &gpio_cfg_noint,
+		.chip	= {
+			.base	= S5PC100_GPL3(0),
+			.ngpio	= S5PC100_GPIO_L3_NR,
+			.label	= "GPL3",
+		},
+	}, {
+		.config	= &gpio_cfg_noint,
+		.chip	= {
+			.base	= S5PC100_GPL4(0),
+			.ngpio	= S5PC100_GPIO_L4_NR,
+			.label	= "GPL4",
+		},
+	}, {
+		.base	= (S5P_VA_GPIO + 0xC00),
+		.config	= &gpio_cfg_eint,
+		.irq_base = IRQ_EINT(0),
+		.chip	= {
+			.base	= S5PC100_GPH0(0),
+			.ngpio	= S5PC100_GPIO_H0_NR,
+			.label	= "GPH0",
+			.to_irq = samsung_gpiolib_to_irq,
+		},
+	}, {
+		.base	= (S5P_VA_GPIO + 0xC20),
+		.config	= &gpio_cfg_eint,
+		.irq_base = IRQ_EINT(8),
+		.chip	= {
+			.base	= S5PC100_GPH1(0),
+			.ngpio	= S5PC100_GPIO_H1_NR,
+			.label	= "GPH1",
+			.to_irq = samsung_gpiolib_to_irq,
+		},
+	}, {
+		.base	= (S5P_VA_GPIO + 0xC40),
+		.config	= &gpio_cfg_eint,
+		.irq_base = IRQ_EINT(16),
+		.chip	= {
+			.base	= S5PC100_GPH2(0),
+			.ngpio	= S5PC100_GPIO_H2_NR,
+			.label	= "GPH2",
+			.to_irq = samsung_gpiolib_to_irq,
+		},
+	}, {
+		.base	= (S5P_VA_GPIO + 0xC60),
+		.config	= &gpio_cfg_eint,
+		.irq_base = IRQ_EINT(24),
+		.chip	= {
+			.base	= S5PC100_GPH3(0),
+			.ngpio	= S5PC100_GPIO_H3_NR,
+			.label	= "GPH3",
+			.to_irq = samsung_gpiolib_to_irq,
+		},
+	},
+};
+
+static __init int s5pc100_gpiolib_init(void)
+{
+	struct s3c_gpio_chip *chip = s5pc100_gpio_chips;
+	int nr_chips = ARRAY_SIZE(s5pc100_gpio_chips);
+	int gpioint_group = 0;
+	int i;
+
+	for (i = 0; i < nr_chips; i++, chip++) {
+		if (chip->config == NULL) {
+			chip->config = &gpio_cfg;
+			chip->group = gpioint_group++;
+		}
+		if (chip->base == NULL)
+			chip->base = S5PC100_BANK_BASE(i);
+	}
+
+	samsung_gpiolib_add_4bit_chips(s5pc100_gpio_chips, nr_chips);
+	s5p_register_gpioint_bank(IRQ_GPIOINT, 0, S5P_GPIOINT_GROUP_MAXNR);
+
+	return 0;
+}
+core_initcall(s5pc100_gpiolib_init);
-- 
1.7.5.1.300.gc565c

