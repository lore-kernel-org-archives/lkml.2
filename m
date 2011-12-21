Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab1LUMBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:01:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43196 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab1LUMBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:01:03 -0500
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: linux-pm@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        linaro-dev@lists.linaro.org, lm-sensors@lm-sensors.org,
        amit.kachhap@linaro.org, patches@linaro.org
Subject: [RFC PATCH 3/3] ARM: exynos4: Add thermal sensor driver platform device support
Date: Wed, 21 Dec 2011 17:29:58 +0530
Message-Id: <1324468798-20423-4-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1324468798-20423-1-git-send-email-amit.kachhap@linaro.org>
References: <1324468798-20423-1-git-send-email-amit.kachhap@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds necessary source definations needed for TMU driver and
the platform device support.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
---
 arch/arm/mach-exynos/Kconfig              |   12 +++++
 arch/arm/mach-exynos/Makefile             |    1 +
 arch/arm/mach-exynos/clock.c              |    4 ++
 arch/arm/mach-exynos/dev-tmu.c            |   64 +++++++++++++++++++++++++++++
 arch/arm/mach-exynos/include/mach/irqs.h  |    2 +
 arch/arm/mach-exynos/include/mach/map.h   |    1 +
 arch/arm/mach-exynos/mach-origen.c        |    1 +
 arch/arm/plat-samsung/include/plat/devs.h |    1 +
 8 files changed, 86 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-exynos/dev-tmu.c

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 724ec0f..cfc6119 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -82,6 +82,17 @@ config EXYNOS4_DEV_DWMCI
 	help
 	  Compile in platform device definitions for DWMCI
 
+config EXYNOS4_DEV_TMU
+	bool "Exynos4 tmu device support"
+	default n
+	depends on ARCH_EXYNOS4
+	---help---
+	  Compile in platform device definitions for TMU. This macro also
+	  enables compilation hwmon base TMU driver and also allows compilation
+	  of the platform device files. The platform data in this case is trip
+	  temperature and some tmu h/w configurations related parameter.
+
+
 config EXYNOS4_SETUP_I2C1
 	bool
 	help
@@ -288,6 +299,7 @@ config MACH_ORIGEN
 	select SAMSUNG_DEV_BACKLIGHT
 	select SAMSUNG_DEV_PWM
 	select EXYNOS4_DEV_PD
+	select EXYNOS4_DEV_TMU
 	select EXYNOS4_SETUP_FIMD0
 	select EXYNOS4_SETUP_SDHCI
 	select EXYNOS4_SETUP_USB_PHY
diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
index 59069a3..d2493e8 100644
--- a/arch/arm/mach-exynos/Makefile
+++ b/arch/arm/mach-exynos/Makefile
@@ -44,6 +44,7 @@ obj-$(CONFIG_EXYNOS4_DEV_AHCI)		+= dev-ahci.o
 obj-$(CONFIG_EXYNOS4_DEV_PD)		+= dev-pd.o
 obj-$(CONFIG_EXYNOS4_DEV_SYSMMU)	+= dev-sysmmu.o
 obj-$(CONFIG_EXYNOS4_DEV_DWMCI)		+= dev-dwmci.o
+obj-$(CONFIG_EXYNOS4_DEV_TMU)           += dev-tmu.o
 
 obj-$(CONFIG_EXYNOS4_SETUP_FIMC)	+= setup-fimc.o
 obj-$(CONFIG_EXYNOS4_SETUP_FIMD0)	+= setup-fimd0.o
diff --git a/arch/arm/mach-exynos/clock.c b/arch/arm/mach-exynos/clock.c
index 2894f0a..edecc5e 100644
--- a/arch/arm/mach-exynos/clock.c
+++ b/arch/arm/mach-exynos/clock.c
@@ -567,6 +567,10 @@ static struct clk init_clocks_off[] = {
 		.enable		= exynos4_clk_ip_peril_ctrl,
 		.ctrlbit	= (1 << 15),
 	}, {
+		.name		= "tmu_apbif",
+		.enable		= exynos4_clk_ip_perir_ctrl,
+		.ctrlbit	= (1 << 17),
+	}, {
 		.name		= "keypad",
 		.enable		= exynos4_clk_ip_perir_ctrl,
 		.ctrlbit	= (1 << 16),
diff --git a/arch/arm/mach-exynos/dev-tmu.c b/arch/arm/mach-exynos/dev-tmu.c
new file mode 100644
index 0000000..2e98912
--- /dev/null
+++ b/arch/arm/mach-exynos/dev-tmu.c
@@ -0,0 +1,64 @@
+/* linux/arch/arm/mach-exynos4/dev-tmu.c
+ *
+ * Copyright 2011 by SAMSUNG
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/platform_data/exynos4_tmu.h>
+#include <asm/irq.h>
+
+#include <mach/irqs.h>
+#include <mach/map.h>
+#include <plat/devs.h>
+
+static struct resource exynos4_tmu_resource[] = {
+	[0] = {
+		.start	= EXYNOS4_PA_TMU,
+		.end	= EXYNOS4_PA_TMU + 0xFFFF - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= IRQ_TMU_TRIG0,
+		.end	= IRQ_TMU_TRIG0,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct exynos4_tmu_platform_data default_tmu_data = {
+	.threshold = 80,
+	.trigger_levels[0] = 2,
+	.trigger_levels[1] = 5,
+	.trigger_levels[2] = 20,
+	.trigger_levels[3] = 30,
+	.trigger_level0_en = 1,
+	.trigger_level1_en = 1,
+	.trigger_level2_en = 1,
+	.trigger_level3_en = 1,
+	.gain = 15,
+	.reference_voltage = 7,
+	.cal_type = TYPE_ONE_POINT_TRIMMING,
+	.freq_tab[0] = {
+		.freq_clip_pctg[0] = 30,
+		},
+	.freq_tab[1] = {
+		.freq_clip_pctg[0] = 99,
+		},
+	.freq_tab_count = 2,
+};
+
+struct platform_device exynos4_device_tmu = {
+	.name		= "exynos4-tmu",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(exynos4_tmu_resource),
+	.resource	= exynos4_tmu_resource,
+	.dev	= {
+		.platform_data	= &default_tmu_data,
+	},
+};
diff --git a/arch/arm/mach-exynos/include/mach/irqs.h b/arch/arm/mach-exynos/include/mach/irqs.h
index dfd4b7e..d66a24b 100644
--- a/arch/arm/mach-exynos/include/mach/irqs.h
+++ b/arch/arm/mach-exynos/include/mach/irqs.h
@@ -125,6 +125,8 @@
 #define COMBINER_GROUP(x)	((x) * MAX_IRQ_IN_COMBINER + IRQ_SPI(128))
 #define COMBINER_IRQ(x, y)	(COMBINER_GROUP(x) + y)
 
+#define IRQ_TMU_TRIG0		COMBINER_IRQ(2, 4)
+#define IRQ_TMU_TRIG1		COMBINER_IRQ(3, 4)
 #define IRQ_SYSMMU_MDMA0_0	COMBINER_IRQ(4, 0)
 #define IRQ_SYSMMU_SSS_0	COMBINER_IRQ(4, 1)
 #define IRQ_SYSMMU_FIMC0_0	COMBINER_IRQ(4, 2)
diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-exynos/include/mach/map.h
index 058541d..0d79b88 100644
--- a/arch/arm/mach-exynos/include/mach/map.h
+++ b/arch/arm/mach-exynos/include/mach/map.h
@@ -66,6 +66,7 @@
 #define EXYNOS4_PA_COREPERI		0x10500000
 #define EXYNOS4_PA_TWD			0x10500600
 #define EXYNOS4_PA_L2CC			0x10502000
+#define EXYNOS4_PA_TMU			0x100C0000
 
 #define EXYNOS4_PA_MDMA			0x10810000
 #define EXYNOS4_PA_PDMA0		0x12680000
diff --git a/arch/arm/mach-exynos/mach-origen.c b/arch/arm/mach-exynos/mach-origen.c
index f80b563..699140a 100644
--- a/arch/arm/mach-exynos/mach-origen.c
+++ b/arch/arm/mach-exynos/mach-origen.c
@@ -615,6 +615,7 @@ static struct platform_device *origen_devices[] __initdata = {
 	&exynos4_device_pd[PD_MFC],
 	&origen_device_gpiokeys,
 	&origen_lcd_hv070wsa,
+	&exynos4_device_tmu,
 };
 
 /* LCD Backlight data */
diff --git a/arch/arm/plat-samsung/include/plat/devs.h b/arch/arm/plat-samsung/include/plat/devs.h
index ab633c9..74cbf0d 100644
--- a/arch/arm/plat-samsung/include/plat/devs.h
+++ b/arch/arm/plat-samsung/include/plat/devs.h
@@ -135,6 +135,7 @@ extern struct platform_device exynos4_device_pcm2;
 extern struct platform_device exynos4_device_pd[];
 extern struct platform_device exynos4_device_spdif;
 extern struct platform_device exynos4_device_sysmmu;
+extern struct platform_device exynos4_device_tmu;
 
 extern struct platform_device samsung_asoc_dma;
 extern struct platform_device samsung_asoc_idma;
-- 
1.7.1

