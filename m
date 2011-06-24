Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab1FXKGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 06:06:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34392 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab1FXKGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 06:06:48 -0400
X-AuditID: cbfee61a-b7c53ae000002dc1-4f-4e0461b616aa
Date: Fri, 24 Jun 2011 19:06:54 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH] ARM: EXYNOS4: Support for generic I/O power domains on
 EXYNOS4210
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Cc: linux-pm@lists.linux-foundation.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Message-id: <4E0461BE.5030304@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
X-OriginalArrivalTime: 24 Jun 2011 10:07:03.0101 (UTC)
 FILETIME=[76F166D0:01CC3256]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic power domains support to implement support
for power domain on EXYNOS4210.

This patch is based on your "pm-domains" branch.(v7)

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin.park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos4/Kconfig                      |    1 +
 arch/arm/mach-exynos4/Makefile                     |    1 +
 arch/arm/mach-exynos4/include/mach/pm-exynos4210.h |   78 ++++++++++++
 arch/arm/mach-exynos4/mach-nuri.c                  |   20 +++
 arch/arm/mach-exynos4/pm-exynos4210.c              |  131 ++++++++++++++++++++
 5 files changed, 231 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-exynos4/include/mach/pm-exynos4210.h
 create mode 100644 arch/arm/mach-exynos4/pm-exynos4210.c

diff --git a/arch/arm/mach-exynos4/Kconfig b/arch/arm/mach-exynos4/Kconfig
index 1435fc3..266e7f6 100644
--- a/arch/arm/mach-exynos4/Kconfig
+++ b/arch/arm/mach-exynos4/Kconfig
@@ -183,6 +183,7 @@ config MACH_NURI
 	select EXYNOS4_SETUP_SDHCI
 	select EXYNOS4_SETUP_USB_PHY
 	select SAMSUNG_DEV_PWM
+	select PM_GENERIC_DOMAINS
 	help
 	  Machine support for Samsung Mobile NURI Board.
 
diff --git a/arch/arm/mach-exynos4/Makefile b/arch/arm/mach-exynos4/Makefile
index 60fe5ec..0e9461f 100644
--- a/arch/arm/mach-exynos4/Makefile
+++ b/arch/arm/mach-exynos4/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_CPU_EXYNOS4210)	+= setup-i2c0.o irq-eint.o dma.o
 obj-$(CONFIG_PM)		+= pm.o sleep.o
 obj-$(CONFIG_CPU_FREQ)		+= cpufreq.o
 obj-$(CONFIG_CPU_IDLE)		+= cpuidle.o
+obj-$(CONFIG_CPU_EXYNOS4210)	+= pm-exynos4210.o
 
 obj-$(CONFIG_SMP)		+= platsmp.o headsmp.o
 
diff --git a/arch/arm/mach-exynos4/include/mach/pm-exynos4210.h b/arch/arm/mach-exynos4/include/mach/pm-exynos4210.h
new file mode 100644
index 0000000..fa1c7a0
--- /dev/null
+++ b/arch/arm/mach-exynos4/include/mach/pm-exynos4210.h
@@ -0,0 +1,78 @@
+/* linux/arch/arm/mach-exynos4/include/mach/pm-exynos4.h
+ *
+ * Exynos4 Power management support
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __PM_EXYNOS4210_H__
+#define __PM_EXYNOS4210_H__
+
+#include <linux/pm_domain.h>
+
+struct platform_device;
+
+struct exynos4210_pm_domain {
+	struct generic_pm_domain genpd;
+
+	const char *name;
+	void __iomem *base;
+	int boot_on;
+};
+
+static inline struct exynos4210_pm_domain *to_exynos4210_pd(
+		struct generic_pm_domain *pd)
+{
+	return container_of(pd, struct exynos4210_pm_domain, genpd);
+}
+
+#ifdef CONFIG_PM
+enum exynos4210_pd_data {
+	EXYNOS4210_PD_MFC,
+	EXYNOS4210_PD_G3D,
+	EXYNOS4210_PD_LCD0,
+	EXYNOS4210_PD_LCD1,
+	EXYNOS4210_PD_TV,
+	EXYNOS4210_PD_CAM,
+	EXYNOS4210_PD_GPS,
+	EXYNOS4210_PD_MAX_NUM
+};
+
+extern struct exynos4210_pm_domain exynos4210_pd_list[EXYNOS4210_PD_MAX_NUM];
+#define EXYNOS4210_MFC		(&exynos4210_pd_list[EXYNOS4210_PD_MFC])
+#define EXYNOS4210_G3D		(&exynos4210_pd_list[EXYNOS4210_PD_G3D])
+#define EXYNOS4210_LCD0		(&exynos4210_pd_list[EXYNOS4210_PD_LCD0])
+#define EXYNOS4210_LCD1		(&exynos4210_pd_list[EXYNOS4210_PD_LCD1])
+#define EXYNOS4210_TV		(&exynos4210_pd_list[EXYNOS4210_PD_TV])
+#define EXYNOS4210_CAM		(&exynos4210_pd_list[EXYNOS4210_PD_CAM])
+#define EXYNOS4210_GPS		(&exynos4210_pd_list[EXYNOS4210_PD_GPS])
+
+extern int exynos4210_pd_init(struct exynos4210_pm_domain *domain);
+extern int exynos4210_add_device_to_domain(struct exynos4210_pm_domain *domain,
+				struct platform_device *pdev);
+#else
+#define EXYNOS4210_MFC		NULL
+#define EXYNOS4210_G3D		NULL
+#define EXYNOS4210_LCD0		NULL
+#define EXYNOS4210_LCD1		NULL
+#define EXYNOS4210_TV		NULL
+#define EXYNOS4210_CAM		NULL
+#define EXYNOS4210_GPS		NULL
+
+extern int exynos4210_pd_init(struct exynos4210_pm_domain *domain)
+{
+	return 0;
+}
+extern int exynos4_add_device_to_domain(struct exynos4210_pm_domain *domain,
+				struct platform_device *pdev)
+{
+	return 0;
+}
+#endif /* CONFIG_PM */
+
+#endif /* __PM_EXYNOS4210_H__ */
diff --git a/arch/arm/mach-exynos4/mach-nuri.c b/arch/arm/mach-exynos4/mach-nuri.c
index 642702b..3e5c42c 100644
--- a/arch/arm/mach-exynos4/mach-nuri.c
+++ b/arch/arm/mach-exynos4/mach-nuri.c
@@ -37,6 +37,7 @@
 #include <plat/iic.h>
 
 #include <mach/map.h>
+#include <mach/pm-exynos4210.h>
 
 /* Following are default values for UCON, ULCON and UFCON UART registers */
 #define NURI_UCON_DEFAULT	(S3C2410_UCON_TXILEVEL |	\
@@ -376,6 +377,23 @@ static struct platform_device *nuri_devices[] __initdata = {
 	&nuri_backlight_device,
 };
 
+static void __init nuri_power_domain_init(void)
+{
+	int i;
+
+	for (i = 0 ; i < EXYNOS4210_PD_MAX_NUM ; i++)
+		exynos4210_pd_init(&exynos4210_pd_list[i]);
+
+	/* Add device to power-domain */
+	exynos4210_add_device_to_domain(EXYNOS4210_MFC, NULL);
+	exynos4210_add_device_to_domain(EXYNOS4210_G3D, NULL);
+	exynos4210_add_device_to_domain(EXYNOS4210_LCD0, &nuri_lcd_device);
+	exynos4210_add_device_to_domain(EXYNOS4210_LCD1, NULL);
+	exynos4210_add_device_to_domain(EXYNOS4210_TV, NULL);
+	exynos4210_add_device_to_domain(EXYNOS4210_CAM, NULL);
+	exynos4210_add_device_to_domain(EXYNOS4210_GPS, NULL);
+}
+
 static void __init nuri_map_io(void)
 {
 	s5p_init_io(NULL, 0, S5P_VA_CHIPID);
@@ -398,6 +416,8 @@ static void __init nuri_machine_init(void)
 
 	/* Last */
 	platform_add_devices(nuri_devices, ARRAY_SIZE(nuri_devices));
+
+	nuri_power_domain_init();
 }
 
 MACHINE_START(NURI, "NURI")
diff --git a/arch/arm/mach-exynos4/pm-exynos4210.c b/arch/arm/mach-exynos4/pm-exynos4210.c
new file mode 100644
index 0000000..8e95d49
--- /dev/null
+++ b/arch/arm/mach-exynos4/pm-exynos4210.c
@@ -0,0 +1,131 @@
+/* linux/arch/arm/mach-exynos4/pm-exynos4210.c
+ *
+ * Exynos4210 Power management support
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/pm.h>
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/pm_domain.h>
+#include <linux/io.h>
+
+#include <mach/regs-pmu.h>
+#include <mach/regs-clock.h>
+#include <mach/pm-exynos4210.h>
+
+struct exynos4210_pm_domain exynos4210_pd_list[] = {
+	{
+		.name		= "PD_MFC",
+		.base		= S5P_PMU_MFC_CONF,
+		.boot_on	= 0,
+	}, {
+		.name		= "PD_G3D",
+		.base		= S5P_PMU_G3D_CONF,
+		.boot_on	= 0,
+	}, {
+		.name		= "PD_LCD0",
+		.base		= S5P_PMU_LCD0_CONF,
+		.boot_on	= 1,
+	}, {
+		.name		= "PD_LCD1",
+		.base		= S5P_PMU_LCD1_CONF,
+		.boot_on	= 0,
+	}, {
+		.name		= "PD_TV",
+		.base		= S5P_PMU_TV_CONF,
+		.boot_on	= 0,
+	}, {
+		.name		= "PD_CAM",
+		.base		= S5P_PMU_CAM_CONF,
+		.boot_on	= 0,
+	}, {
+		.name		= "PD_GPS",
+		.base		= S5P_PMU_GPS_CONF,
+		.boot_on	= 0,
+	},
+};
+
+static int pd_power_down(struct generic_pm_domain *genpd)
+{
+	struct exynos4210_pm_domain *domain = to_exynos4210_pd(genpd);
+	u32 timeout;
+
+	__raw_writel(0, domain->base);
+
+	/* Wait max 1ms */
+	timeout = 10;
+	while (__raw_readl(domain->base + 0x4) & S5P_INT_LOCAL_PWR_EN) {
+		if (timeout == 0) {
+			printk(KERN_ERR "Power domain %s disable failed.\n",
+				domain->name);
+			return -ETIMEDOUT;
+		}
+		timeout--;
+		udelay(100);
+	}
+
+	return 0;
+}
+
+static int pd_power_up(struct generic_pm_domain *genpd)
+{
+	struct exynos4210_pm_domain *domain = to_exynos4210_pd(genpd);
+	u32 timeout;
+
+	__raw_writel(S5P_INT_LOCAL_PWR_EN, domain->base);
+
+	/* Wait max 1ms */
+	timeout = 10;
+	while ((__raw_readl(domain->base + 0x4) & S5P_INT_LOCAL_PWR_EN)
+		!= S5P_INT_LOCAL_PWR_EN) {
+		if (timeout == 0) {
+			printk(KERN_ERR "Power domain %s enable failed.\n",
+				domain->name);
+			return -ETIMEDOUT;
+		}
+		timeout--;
+		udelay(100);
+	}
+
+	return 0;
+}
+
+int exynos4210_pd_init(struct exynos4210_pm_domain *domain)
+{
+	struct generic_pm_domain *genpd = &domain->genpd;
+
+	pm_genpd_init(genpd, NULL, false);
+
+	genpd->stop_device = pm_runtime_clk_suspend;
+	genpd->start_device = pm_runtime_clk_resume;
+	genpd->power_off = pd_power_down;
+	genpd->power_on = pd_power_up;
+
+	if (domain->boot_on)
+		pd_power_up(genpd);
+
+	return 0;
+}
+
+int exynos4210_add_device_to_domain(struct exynos4210_pm_domain *domain,
+				struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct generic_pm_domain *genpd = &domain->genpd;
+
+	if (pdev != NULL)
+		return pm_genpd_add_device(genpd, dev);
+	else
+		return -EINVAL;
+}
