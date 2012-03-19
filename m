Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030445Ab2CSGSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:18:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34583 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab2CSGSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 02:18:34 -0400
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: linux-pm@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        linaro-dev@lists.linaro.org, lm-sensors@lm-sensors.org,
        amit.kachhap@linaro.org, patches@linaro.org, eduardo.valentin@ti.com,
        durgadoss.r@intel.com
Subject: [PATCH V2 6/6] ARM: exynos4: Add thermal sensor driver platform device support
Date: Mon, 19 Mar 2012 11:47:44 +0530
Message-Id: <1332137864-12943-7-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1332137864-12943-1-git-send-email-amit.kachhap@linaro.org>
References: <1332137864-12943-1-git-send-email-amit.kachhap@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds necessary source definations needed for TMU driver and
the platform device support.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
---
 arch/arm/mach-exynos/Kconfig              |   11 +++++++
 arch/arm/mach-exynos/Makefile             |    1 +
 arch/arm/mach-exynos/clock.c              |    4 ++
 arch/arm/mach-exynos/dev-tmu.c            |   39 ++++++++++++++++++++++++
 arch/arm/mach-exynos/include/mach/irqs.h  |    2 +
 arch/arm/mach-exynos/include/mach/map.h   |    1 +
 arch/arm/mach-exynos/mach-origen.c        |    1 +
 arch/arm/plat-samsung/include/plat/devs.h |    1 +
 drivers/thermal/exynos4_thermal.c         |   47 +++++++++++++++++++++++++++++
 9 files changed, 107 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-exynos/dev-tmu.c

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 5d602f6..03968a6 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -160,6 +160,16 @@ config EXYNOS4_SETUP_SPI
 	help
 	  Common setup code for SPI GPIO configurations.
 
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
 # machine support
 
 if ARCH_EXYNOS4
@@ -199,6 +209,7 @@ config MACH_SMDKV310
 	select SAMSUNG_DEV_PWM
 	select EXYNOS4_DEV_USB_OHCI
 	select EXYNOS4_DEV_SYSMMU
+	select EXYNOS4_DEV_TMU
 	select EXYNOS4_SETUP_FIMD0
 	select EXYNOS4_SETUP_I2C1
 	select EXYNOS4_SETUP_KEYPAD
diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
index 5fc202c..9b62e69 100644
--- a/arch/arm/mach-exynos/Makefile
+++ b/arch/arm/mach-exynos/Makefile
@@ -50,6 +50,7 @@ obj-$(CONFIG_EXYNOS4_DEV_SYSMMU)	+= dev-sysmmu.o
 obj-$(CONFIG_EXYNOS4_DEV_DWMCI)		+= dev-dwmci.o
 obj-$(CONFIG_EXYNOS4_DEV_DMA)		+= dma.o
 obj-$(CONFIG_EXYNOS4_DEV_USB_OHCI)	+= dev-ohci.o
+obj-$(CONFIG_EXYNOS4_DEV_TMU)		+= dev-tmu.o
 
 obj-$(CONFIG_ARCH_EXYNOS4)		+= setup-i2c0.o
 obj-$(CONFIG_EXYNOS4_SETUP_FIMC)	+= setup-fimc.o
diff --git a/arch/arm/mach-exynos/clock.c b/arch/arm/mach-exynos/clock.c
index 187287a..3b15397 100644
--- a/arch/arm/mach-exynos/clock.c
+++ b/arch/arm/mach-exynos/clock.c
@@ -560,6 +560,10 @@ static struct clk init_clocks_off[] = {
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
index 0000000..e37f0f5
--- /dev/null
+++ b/arch/arm/mach-exynos/dev-tmu.c
@@ -0,0 +1,39 @@
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
+struct platform_device exynos4_device_tmu = {
+	.name		= "exynos4-tmu",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(exynos4_tmu_resource),
+	.resource	= exynos4_tmu_resource,
+};
diff --git a/arch/arm/mach-exynos/include/mach/irqs.h b/arch/arm/mach-exynos/include/mach/irqs.h
index f77bce0..f98d2e4 100644
--- a/arch/arm/mach-exynos/include/mach/irqs.h
+++ b/arch/arm/mach-exynos/include/mach/irqs.h
@@ -128,6 +128,8 @@
 #define COMBINER_GROUP(x)	((x) * MAX_IRQ_IN_COMBINER + IRQ_SPI(128))
 #define COMBINER_IRQ(x, y)	(COMBINER_GROUP(x) + y)
 
+#define IRQ_TMU_TRIG0		COMBINER_IRQ(2, 4)
+#define IRQ_TMU_TRIG1		COMBINER_IRQ(3, 4)
 #define IRQ_SYSMMU_MDMA0_0	COMBINER_IRQ(4, 0)
 #define IRQ_SYSMMU_SSS_0	COMBINER_IRQ(4, 1)
 #define IRQ_SYSMMU_FIMC0_0	COMBINER_IRQ(4, 2)
diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-exynos/include/mach/map.h
index c754a22..bc11f1f 100644
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
index 0679b8a..5d56e53 100644
--- a/arch/arm/mach-exynos/mach-origen.c
+++ b/arch/arm/mach-exynos/mach-origen.c
@@ -630,6 +630,7 @@ static struct platform_device *origen_devices[] __initdata = {
 	&exynos4_device_pd[PD_MFC],
 	&origen_device_gpiokeys,
 	&origen_lcd_hv070wsa,
+	&exynos4_device_tmu,
 };
 
 /* LCD Backlight data */
diff --git a/arch/arm/plat-samsung/include/plat/devs.h b/arch/arm/plat-samsung/include/plat/devs.h
index 4214ea0..0960405 100644
--- a/arch/arm/plat-samsung/include/plat/devs.h
+++ b/arch/arm/plat-samsung/include/plat/devs.h
@@ -130,6 +130,7 @@ extern struct platform_device exynos4_device_pcm2;
 extern struct platform_device exynos4_device_pd[];
 extern struct platform_device exynos4_device_spdif;
 extern struct platform_device exynos4_device_sysmmu;
+extern struct platform_device exynos4_device_tmu;
 
 extern struct platform_device samsung_asoc_dma;
 extern struct platform_device samsung_asoc_idma;
diff --git a/drivers/thermal/exynos4_thermal.c b/drivers/thermal/exynos4_thermal.c
index e5be944..7f8b867 100644
--- a/drivers/thermal/exynos4_thermal.c
+++ b/drivers/thermal/exynos4_thermal.c
@@ -573,12 +573,58 @@ static struct thermal_sensor_conf exynos4_sensor_conf = {
 	.read_temperature	= (int (*)(void *))exynos4_tmu_read,
 };
 
+#if defined(CONFIG_CPU_EXYNOS4210)
+static struct exynos4_tmu_platform_data exynos4_default_tmu_data = {
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
+		.freq_clip_max = 800 * 1000,
+	},
+	.freq_tab[1] = {
+		.freq_clip_max = 200 * 1000,
+	},
+	.freq_tab_count = 2,
+};
+#define EXYNOS4210_TMU_DRV_DATA ((kernel_ulong_t)&exynos4_default_tmu_data)
+#else
+#define EXYNOS4210_TMU_DRV_DATA ((kernel_ulong_t)NULL)
+#endif
+
+static struct platform_device_id exynos4_tmu_driver_ids[] = {
+	{
+		.name		= "exynos4-tmu",
+		.driver_data    = EXYNOS4210_TMU_DRV_DATA,
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, exynos4_tmu_driver_ids);
+
+static inline struct  exynos4_tmu_platform_data *exynos4_get_driver_data(
+			struct platform_device *pdev)
+{
+	return (struct exynos4_tmu_platform_data *)
+			platform_get_device_id(pdev)->driver_data;
+}
+
 static int __devinit exynos4_tmu_probe(struct platform_device *pdev)
 {
 	struct exynos4_tmu_data *data;
 	struct exynos4_tmu_platform_data *pdata = pdev->dev.platform_data;
 	int ret, i;
 
+	if (!pdata)
+		pdata = exynos4_get_driver_data(pdev);
+
 	if (!pdata) {
 		dev_err(&pdev->dev, "No platform init data supplied.\n");
 		return -ENODEV;
@@ -733,6 +779,7 @@ static struct platform_driver exynos4_tmu_driver = {
 	.remove	= __devexit_p(exynos4_tmu_remove),
 	.suspend = exynos4_tmu_suspend,
 	.resume = exynos4_tmu_resume,
+	.id_table = exynos4_tmu_driver_ids,
 };
 
 module_platform_driver(exynos4_tmu_driver);
-- 
1.7.1

