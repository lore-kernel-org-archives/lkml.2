Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab1GHBYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 21:24:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:56205 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab1GHBYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 21:24:35 -0400
X-AuditID: cbfee61a-b7c53ae000002dc1-b7-4e165c516767
Date: Fri, 08 Jul 2011 10:24:52 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3] ARM: EXYNOS4: Support for generic I/O power domains on
 EXYNOS4210
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Sylwester Nawrocki <snjw23@gmail.com>,
        linux-pm@lists.linux-foundation.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <4E165C64.8090808@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
X-OriginalArrivalTime: 08 Jul 2011 01:24:44.0892 (UTC)
 FILETIME=[D1B2B1C0:01CC3D0D]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic power domains support to implement support for
power domain on EXYNOS4210.

I refer to the following patch to implement what configure
the clock-gating control register for block to turn off/on:
http://git.infradead.org/users/kmpark/linux-2.6-samsung/commit/39a81876d034dcbdc2a4c4c4b847b3b49e38870c

This patch is based on following "pm-domains" branch.
http://git.kernel.org/?p=linux/kernel/git/rafael/suspend-2.6.git;a=shortlog;h=refs/heads/pm-domains

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin.park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos4/Kconfig                      |    1 +
 arch/arm/mach-exynos4/Makefile                     |    1 +
 arch/arm/mach-exynos4/include/mach/pm-exynos4210.h |   53 ++++++
 arch/arm/mach-exynos4/include/mach/regs-clock.h    |    8 +
 arch/arm/mach-exynos4/mach-nuri.c                  |   18 ++
 arch/arm/mach-exynos4/pm-exynos4210.c              |  184 ++++++++++++++++++++
 6 files changed, 265 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-exynos4/include/mach/pm-exynos4210.h
 create mode 100644 arch/arm/mach-exynos4/pm-exynos4210.c

diff --git a/arch/arm/mach-exynos4/Kconfig b/arch/arm/mach-exynos4/Kconfig
index 1435fc3..c5357b5 100644
--- a/arch/arm/mach-exynos4/Kconfig
+++ b/arch/arm/mach-exynos4/Kconfig
@@ -183,6 +183,7 @@ config MACH_NURI
 	select EXYNOS4_SETUP_SDHCI
 	select EXYNOS4_SETUP_USB_PHY
 	select SAMSUNG_DEV_PWM
+	select PM_GENERIC_DOMAINS if PM
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
index 0000000..ab09034
--- /dev/null
+++ b/arch/arm/mach-exynos4/include/mach/pm-exynos4210.h
@@ -0,0 +1,53 @@
+/* linux/arch/arm/mach-exynos4/include/mach/pm-exynos4.h
+ *
+ * Exynos4 Power management support
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef PM_EXYNOS4210_H
+#define PM_EXYNOS4210_H
+
+#include <linux/pm_domain.h>
+#include <plat/pd.h>
+
+struct platform_device;
+
+struct exynos4210_pm_domain {
+	struct generic_pm_domain genpd;
+
+	const char *name;
+	void __iomem *base;
+	u32 mask;
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
+extern struct exynos4210_pm_domain exynos4210_pd_mfc;
+extern struct exynos4210_pm_domain exynos4210_pd_g3d;
+extern struct exynos4210_pm_domain exynos4210_pd_lcd0;
+extern struct exynos4210_pm_domain exynos4210_pd_lcd1;
+extern struct exynos4210_pm_domain exynos4210_pd_tv;
+extern struct exynos4210_pm_domain exynos4210_pd_cam;
+extern struct exynos4210_pm_domain exynos4210_pd_gps;
+
+extern void exynos4210_init_pm_domain(struct exynos4210_pm_domain *exynos4210_pd);
+extern void exynos4210_add_device_to_domain(struct exynos4210_pm_domain *exynos4210_pd,
+				struct platform_device *pdev);
+#else
+#define exynos4210_init_pm_domain(pd) do { } while(0)
+#define exynos4_add_device_to_domain(pd, pdev) do { } while(0)
+#endif /* CONFIG_PM */
+
+#endif /* PM_EXYNOS4210_H */
diff --git a/arch/arm/mach-exynos4/include/mach/regs-clock.h b/arch/arm/mach-exynos4/include/mach/regs-clock.h
index 6e311c1..bc0fda9 100644
--- a/arch/arm/mach-exynos4/include/mach/regs-clock.h
+++ b/arch/arm/mach-exynos4/include/mach/regs-clock.h
@@ -171,6 +171,14 @@
 #define S5P_CLKDIV_BUS_GPLR_SHIFT	(4)
 #define S5P_CLKDIV_BUS_GPLR_MASK	(0x7 << S5P_CLKDIV_BUS_GPLR_SHIFT)
 
+#define S5P_CLKGATE_BLOCK_CAM		(1<<0)
+#define S5P_CLKGATE_BLOCK_TV		(1<<1)
+#define S5P_CLKGATE_BLOCK_MFC		(1<<2)
+#define S5P_CLKGATE_BLOCK_G3D		(1<<3)
+#define S5P_CLKGATE_BLOCK_LCD0		(1<<4)
+#define S5P_CLKGATE_BLOCK_LCD1		(1<<5)
+#define S5P_CLKGATE_BLOCK_GPS		(1<<7)
+
 /* Compatibility defines and inclusion */
 
 #include <mach/regs-pmu.h>
diff --git a/arch/arm/mach-exynos4/mach-nuri.c b/arch/arm/mach-exynos4/mach-nuri.c
index 642702b..816c6f4 100644
--- a/arch/arm/mach-exynos4/mach-nuri.c
+++ b/arch/arm/mach-exynos4/mach-nuri.c
@@ -37,6 +37,7 @@
 #include <plat/iic.h>
 
 #include <mach/map.h>
+#include <mach/pm-exynos4210.h>
 
 /* Following are default values for UCON, ULCON and UFCON UART registers */
 #define NURI_UCON_DEFAULT	(S3C2410_UCON_TXILEVEL |	\
@@ -376,6 +377,21 @@ static struct platform_device *nuri_devices[] __initdata = {
 	&nuri_backlight_device,
 };
 
+static void __init nuri_power_domain_init(void)
+{
+	/* Initialize power-domain */
+	exynos4210_init_pm_domain(&exynos4210_pd_mfc);
+	exynos4210_init_pm_domain(&exynos4210_pd_g3d);
+	exynos4210_init_pm_domain(&exynos4210_pd_lcd0);
+	exynos4210_init_pm_domain(&exynos4210_pd_lcd1);
+	exynos4210_init_pm_domain(&exynos4210_pd_tv);
+	exynos4210_init_pm_domain(&exynos4210_pd_cam);
+	exynos4210_init_pm_domain(&exynos4210_pd_gps);
+
+	/* Add device to power-domain */
+	exynos4210_add_device_to_domain(&exynos4210_pd_lcd0, &nuri_lcd_device);
+}
+
 static void __init nuri_map_io(void)
 {
 	s5p_init_io(NULL, 0, S5P_VA_CHIPID);
@@ -398,6 +414,8 @@ static void __init nuri_machine_init(void)
 
 	/* Last */
 	platform_add_devices(nuri_devices, ARRAY_SIZE(nuri_devices));
+
+	nuri_power_domain_init();
 }
 
 MACHINE_START(NURI, "NURI")
diff --git a/arch/arm/mach-exynos4/pm-exynos4210.c b/arch/arm/mach-exynos4/pm-exynos4210.c
new file mode 100644
index 0000000..f44dcef
--- /dev/null
+++ b/arch/arm/mach-exynos4/pm-exynos4210.c
@@ -0,0 +1,184 @@
+/* linux/arch/arm/mach-exynos4/pm-exynos4210.c
+ *
+ * Exynos4210 Power management support
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
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
+#include <linux/pm_runtime.h>
+#include <linux/platform_device.h>
+#include <linux/pm_domain.h>
+#include <linux/io.h>
+
+#include <mach/regs-pmu.h>
+#include <mach/regs-clock.h>
+#include <mach/pm-exynos4210.h>
+
+#ifdef CONFIG_PM
+static DEFINE_SPINLOCK(clkgate_block_lock);
+
+static int pd_power_down(struct generic_pm_domain *genpd)
+{
+	struct exynos4210_pm_domain *exynos4210_pd = to_exynos4210_pd(genpd);
+	u32 timeout;
+
+	/* Disable the power of power-domain */
+	__raw_writel(0, exynos4210_pd->base);
+
+	/* Wait max 1ms */
+	timeout = 10;
+	while (__raw_readl(exynos4210_pd->base + 0x4) & S5P_INT_LOCAL_PWR_EN) {
+		if (timeout == 0) {
+			printk(KERN_ERR "Power domain %s disable failed.\n",
+				exynos4210_pd->name);
+			return -ETIMEDOUT;
+		}
+		timeout--;
+		udelay(100);
+	}
+
+	/* Configure the clock-gating control register for block to turn off */
+	if (exynos4210_pd->mask) {
+		unsigned long flags;
+		u32 reg;
+
+		spin_lock_irqsave(&clkgate_block_lock, flags);
+		reg = __raw_readl(S5P_CLKGATE_BLOCK);
+		reg &= ~exynos4210_pd->mask;
+		__raw_writel(reg, S5P_CLKGATE_BLOCK);
+		spin_unlock_irqrestore(&clkgate_block_lock, flags);
+	}
+
+	return 0;
+}
+
+static int pd_power_up(struct generic_pm_domain *genpd)
+{
+	struct exynos4210_pm_domain *exynos4210_pd = to_exynos4210_pd(genpd);
+	u32 timeout;
+
+	/* Enable power domain */
+	__raw_writel(S5P_INT_LOCAL_PWR_EN, exynos4210_pd->base);
+
+	/* Wait max 1ms */
+	timeout = 10;
+	while ((__raw_readl(exynos4210_pd->base + 0x4) & S5P_INT_LOCAL_PWR_EN)
+		!= S5P_INT_LOCAL_PWR_EN) {
+		if (timeout == 0) {
+			printk(KERN_ERR "Power domain %s enable failed.\n",
+				exynos4210_pd->name);
+			return -ETIMEDOUT;
+		}
+		timeout--;
+		udelay(100);
+	}
+
+	/* Configure the clock-gating control register for block to turn on */
+	if (exynos4210_pd->mask) {
+		unsigned long flags;
+		u32 reg;
+
+		spin_lock_irqsave(&clkgate_block_lock, flags);
+		reg = __raw_readl(S5P_CLKGATE_BLOCK);
+		reg |= exynos4210_pd->mask;
+		__raw_writel(reg, S5P_CLKGATE_BLOCK);
+		spin_unlock_irqrestore(&clkgate_block_lock, flags);
+	}
+
+	return 0;
+}
+
+static bool pd_active_wakeup(struct device *dev)
+{
+	return true;
+}
+
+void exynos4210_init_pm_domain(struct exynos4210_pm_domain *exynos4210_pd)
+{
+	struct generic_pm_domain *genpd;
+
+	if (!exynos4210_pd)
+		return;
+
+	genpd = &exynos4210_pd->genpd;
+
+	pm_genpd_init(genpd, NULL, false);
+	genpd->stop_device = pm_clk_suspend;
+	genpd->start_device = pm_clk_resume;
+	genpd->active_wakeup = pd_active_wakeup;
+	genpd->power_off = pd_power_down;
+	genpd->power_on = pd_power_up;
+
+	if (exynos4210_pd->boot_on)
+		pd_power_up(&exynos4210_pd->genpd);
+}
+
+void exynos4210_add_device_to_domain(struct exynos4210_pm_domain *exynos4210_pd,
+				struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+
+	if (exynos4210_pd && pdev)
+		pm_genpd_add_device(&exynos4210_pd->genpd, dev);
+}
+
+struct exynos4210_pm_domain exynos4210_pd_mfc = {
+	.name		= "PD_MFC",
+	.base		= S5P_PMU_MFC_CONF,
+	.mask		= S5P_CLKGATE_BLOCK_MFC,
+	.boot_on	= 0,
+};
+
+struct exynos4210_pm_domain exynos4210_pd_g3d = {
+	.name		= "PD_G3D",
+	.base		= S5P_PMU_G3D_CONF,
+	.mask		= S5P_CLKGATE_BLOCK_G3D,
+	.boot_on	= 0,
+};
+
+struct exynos4210_pm_domain exynos4210_pd_lcd0 = {
+	.name		= "PD_LCD0",
+	.base		= S5P_PMU_LCD0_CONF,
+	.mask		= S5P_CLKGATE_BLOCK_LCD0,
+	.boot_on	= 1,
+};
+
+struct exynos4210_pm_domain exynos4210_pd_lcd1 = {
+	.name		= "PD_LCD1",
+	.base		= S5P_PMU_LCD1_CONF,
+	.mask		= S5P_CLKGATE_BLOCK_LCD1,
+	.boot_on	= 0,
+};
+
+struct exynos4210_pm_domain exynos4210_pd_tv = {
+	.name		= "PD_TV",
+	.base		= S5P_PMU_TV_CONF,
+	.mask		= S5P_CLKGATE_BLOCK_TV,
+	.boot_on	= 0,
+};
+
+struct exynos4210_pm_domain exynos4210_pd_cam = {
+	.name		= "PD_CAM",
+	.base		= S5P_PMU_CAM_CONF,
+	.mask		= S5P_CLKGATE_BLOCK_CAM,
+	.boot_on	= 0,
+};
+
+struct exynos4210_pm_domain exynos4210_pd_gps = {
+	.name		= "PD_GPS",
+	.base		= S5P_PMU_GPS_CONF,
+	.mask		= S5P_CLKGATE_BLOCK_GPS,
+	.boot_on	= 0,
+};
+
+#endif	/* CONFIG_PM */
-- 
1.7.0.4

