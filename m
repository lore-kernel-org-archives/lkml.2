Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab1DBIoy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 04:44:54 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:54018 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463Ab1DBIow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 04:44:52 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Alessandro Zummo'" <a.zummo@towertech.it>
Cc: <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        "Arnd Bergmann" <arnd@arndb.de>
Subject: [PATCH] unicore32: move rtc-puv3.c to drivers/rtc directory
Date: Sat, 2 Apr 2011 16:44:04 +0800
Message-ID: <002301cbf112$227bdfc0$67739f40$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
thread-index: AcvxEfX4cPeVw4d9TDe092oVtHhNRQ==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 MAINTAINERS                            |    1 +
 arch/unicore32/Kconfig                 |    4 -
 arch/unicore32/configs/debug_defconfig |    6 +-
 arch/unicore32/kernel/Makefile         |    1 -
 arch/unicore32/kernel/rtc.c            |  371 --------------------------------
 drivers/rtc/Kconfig                    |    9 +
 drivers/rtc/Makefile                   |    1 +
 drivers/rtc/rtc-puv3.c                 |  371 ++++++++++++++++++++++++++++++++
 8 files changed, 385 insertions(+), 379 deletions(-)
 delete mode 100644 arch/unicore32/kernel/rtc.c
 create mode 100644 drivers/rtc/rtc-puv3.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 6b4b9cd..63abd72 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4907,6 +4907,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/epip/linux-2.6-unicore32.gi
 F:	drivers/input/serio/i8042-unicore32io.h
 F:	drivers/i2c/busses/i2c-puv3.c
 F:	drivers/video/fb-puv3.c
+F:	drivers/rtc/rtc-puv3.c
 
 PMC SIERRA MaxRAID DRIVER
 M:	Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index 04e0249..b52e9a3 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -232,10 +232,6 @@ config PUV3_PWM
 	help
 	  Enable support for NB0916 PWM controllers
 
-config PUV3_RTC
-	tristate "PKUnity v3 RTC Support"
-	depends on !ARCH_FPGA
-
 if PUV3_NB0916
 
 menu "PKUnity NetBook-0916 Features"
diff --git a/arch/unicore32/configs/debug_defconfig b/arch/unicore32/configs/debug_defconfig
index 919d451..a396914 100644
--- a/arch/unicore32/configs/debug_defconfig
+++ b/arch/unicore32/configs/debug_defconfig
@@ -61,7 +61,6 @@ CONFIG_I2C_BATTERY_BQ27200=n
 CONFIG_I2C_EEPROM_AT24=n
 CONFIG_LCD_BACKLIGHT=n
 
-CONFIG_PUV3_RTC=y
 CONFIG_PUV3_MUSB=n
 CONFIG_PUV3_AC97=n
 CONFIG_PUV3_NAND=n
@@ -164,8 +163,9 @@ CONFIG_LEDS_TRIGGER_IDE_DISK=y
 CONFIG_LEDS_TRIGGER_HEARTBEAT=y
 
 #	Real Time Clock
-CONFIG_RTC_LIB=m
-CONFIG_RTC_CLASS=m
+CONFIG_RTC_LIB=y
+CONFIG_RTC_CLASS=y
+CONFIG_RTC_DRV_PUV3=y
 
 ### File systems
 CONFIG_EXT2_FS=m
diff --git a/arch/unicore32/kernel/Makefile b/arch/unicore32/kernel/Makefile
index ec23a2f..aeb0f18 100644
--- a/arch/unicore32/kernel/Makefile
+++ b/arch/unicore32/kernel/Makefile
@@ -16,7 +16,6 @@ obj-$(CONFIG_UNICORE_FPU_F64)	+= fpu-ucf64.o
 obj-$(CONFIG_ARCH_PUV3)		+= clock.o irq.o time.o
 
 obj-$(CONFIG_PUV3_GPIO)		+= gpio.o
-obj-$(CONFIG_PUV3_RTC)		+= rtc.o
 obj-$(CONFIG_PUV3_PWM)		+= pwm.o
 obj-$(CONFIG_PUV3_PM)		+= pm.o sleep.o
 obj-$(CONFIG_HIBERNATION)	+= hibernate.o hibernate_asm.o
diff --git a/arch/unicore32/kernel/rtc.c b/arch/unicore32/kernel/rtc.c
deleted file mode 100644
index 8cad70b..0000000
--- a/arch/unicore32/kernel/rtc.c
+++ /dev/null
@@ -1,371 +0,0 @@
-/*
- * linux/arch/unicore32/kernel/rtc.c
- *
- * Code specific to PKUnity SoC and UniCore ISA
- *
- *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
- *	Copyright (C) 2001-2010 Guan Xuetao
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/fs.h>
-#include <linux/string.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/interrupt.h>
-#include <linux/rtc.h>
-#include <linux/bcd.h>
-#include <linux/clk.h>
-#include <linux/log2.h>
-#include <linux/slab.h>
-#include <linux/uaccess.h>
-#include <linux/io.h>
-
-#include <asm/irq.h>
-#include <mach/hardware.h>
-
-static struct resource *puv3_rtc_mem;
-
-static int puv3_rtc_alarmno = IRQ_RTCAlarm;
-static int puv3_rtc_tickno  = IRQ_RTC;
-
-static DEFINE_SPINLOCK(puv3_rtc_pie_lock);
-
-/* IRQ Handlers */
-
-static irqreturn_t puv3_rtc_alarmirq(int irq, void *id)
-{
-	struct rtc_device *rdev = id;
-
-	writel(readl(RTC_RTSR) | RTC_RTSR_AL, RTC_RTSR);
-	rtc_update_irq(rdev, 1, RTC_AF | RTC_IRQF);
-	return IRQ_HANDLED;
-}
-
-static irqreturn_t puv3_rtc_tickirq(int irq, void *id)
-{
-	struct rtc_device *rdev = id;
-
-	writel(readl(RTC_RTSR) | RTC_RTSR_HZ, RTC_RTSR);
-	rtc_update_irq(rdev, 1, RTC_PF | RTC_IRQF);
-	return IRQ_HANDLED;
-}
-
-/* Update control registers */
-static void puv3_rtc_setaie(int to)
-{
-	unsigned int tmp;
-
-	pr_debug("%s: aie=%d\n", __func__, to);
-
-	tmp = readl(RTC_RTSR) & ~RTC_RTSR_ALE;
-
-	if (to)
-		tmp |= RTC_RTSR_ALE;
-
-	writel(tmp, RTC_RTSR);
-}
-
-static int puv3_rtc_setpie(struct device *dev, int enabled)
-{
-	unsigned int tmp;
-
-	pr_debug("%s: pie=%d\n", __func__, enabled);
-
-	spin_lock_irq(&puv3_rtc_pie_lock);
-	tmp = readl(RTC_RTSR) & ~RTC_RTSR_HZE;
-
-	if (enabled)
-		tmp |= RTC_RTSR_HZE;
-
-	writel(tmp, RTC_RTSR);
-	spin_unlock_irq(&puv3_rtc_pie_lock);
-
-	return 0;
-}
-
-/* Time read/write */
-
-static int puv3_rtc_gettime(struct device *dev, struct rtc_time *rtc_tm)
-{
-	rtc_time_to_tm(readl(RTC_RCNR), rtc_tm);
-
-	pr_debug("read time %02x.%02x.%02x %02x/%02x/%02x\n",
-		 rtc_tm->tm_year, rtc_tm->tm_mon, rtc_tm->tm_mday,
-		 rtc_tm->tm_hour, rtc_tm->tm_min, rtc_tm->tm_sec);
-
-	return 0;
-}
-
-static int puv3_rtc_settime(struct device *dev, struct rtc_time *tm)
-{
-	unsigned long rtc_count = 0;
-
-	pr_debug("set time %02d.%02d.%02d %02d/%02d/%02d\n",
-		 tm->tm_year, tm->tm_mon, tm->tm_mday,
-		 tm->tm_hour, tm->tm_min, tm->tm_sec);
-
-	rtc_tm_to_time(tm, &rtc_count);
-	writel(rtc_count, RTC_RCNR);
-
-	return 0;
-}
-
-static int puv3_rtc_getalarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	struct rtc_time *alm_tm = &alrm->time;
-
-	rtc_time_to_tm(readl(RTC_RTAR), alm_tm);
-
-	alrm->enabled = readl(RTC_RTSR) & RTC_RTSR_ALE;
-
-	pr_debug("read alarm %02x %02x.%02x.%02x %02x/%02x/%02x\n",
-		 alrm->enabled,
-		 alm_tm->tm_year, alm_tm->tm_mon, alm_tm->tm_mday,
-		 alm_tm->tm_hour, alm_tm->tm_min, alm_tm->tm_sec);
-
-	return 0;
-}
-
-static int puv3_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	struct rtc_time *tm = &alrm->time;
-	unsigned long rtcalarm_count = 0;
-
-	pr_debug("puv3_rtc_setalarm: %d, %02x/%02x/%02x %02x.%02x.%02x\n",
-		 alrm->enabled,
-		 tm->tm_mday & 0xff, tm->tm_mon & 0xff, tm->tm_year & 0xff,
-		 tm->tm_hour & 0xff, tm->tm_min & 0xff, tm->tm_sec);
-
-	rtc_tm_to_time(tm, &rtcalarm_count);
-	writel(rtcalarm_count, RTC_RTAR);
-
-	puv3_rtc_setaie(alrm->enabled);
-
-	if (alrm->enabled)
-		enable_irq_wake(puv3_rtc_alarmno);
-	else
-		disable_irq_wake(puv3_rtc_alarmno);
-
-	return 0;
-}
-
-static int puv3_rtc_proc(struct device *dev, struct seq_file *seq)
-{
-	seq_printf(seq, "periodic_IRQ\t: %s\n",
-		     (readl(RTC_RTSR) & RTC_RTSR_HZE) ? "yes" : "no");
-	return 0;
-}
-
-static int puv3_rtc_open(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct rtc_device *rtc_dev = platform_get_drvdata(pdev);
-	int ret;
-
-	ret = request_irq(puv3_rtc_alarmno, puv3_rtc_alarmirq,
-			  IRQF_DISABLED,  "pkunity-rtc alarm", rtc_dev);
-
-	if (ret) {
-		dev_err(dev, "IRQ%d error %d\n", puv3_rtc_alarmno, ret);
-		return ret;
-	}
-
-	ret = request_irq(puv3_rtc_tickno, puv3_rtc_tickirq,
-			  IRQF_DISABLED,  "pkunity-rtc tick", rtc_dev);
-
-	if (ret) {
-		dev_err(dev, "IRQ%d error %d\n", puv3_rtc_tickno, ret);
-		goto tick_err;
-	}
-
-	return ret;
-
- tick_err:
-	free_irq(puv3_rtc_alarmno, rtc_dev);
-	return ret;
-}
-
-static void puv3_rtc_release(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct rtc_device *rtc_dev = platform_get_drvdata(pdev);
-
-	/* do not clear AIE here, it may be needed for wake */
-
-	puv3_rtc_setpie(dev, 0);
-	free_irq(puv3_rtc_alarmno, rtc_dev);
-	free_irq(puv3_rtc_tickno, rtc_dev);
-}
-
-static const struct rtc_class_ops puv3_rtcops = {
-	.open		= puv3_rtc_open,
-	.release	= puv3_rtc_release,
-	.read_time	= puv3_rtc_gettime,
-	.set_time	= puv3_rtc_settime,
-	.read_alarm	= puv3_rtc_getalarm,
-	.set_alarm	= puv3_rtc_setalarm,
-	.proc	        = puv3_rtc_proc,
-};
-
-static void puv3_rtc_enable(struct platform_device *pdev, int en)
-{
-	if (!en) {
-		writel(readl(RTC_RTSR) & ~RTC_RTSR_HZE, RTC_RTSR);
-	} else {
-		/* re-enable the device, and check it is ok */
-
-		if ((readl(RTC_RTSR) & RTC_RTSR_HZE) == 0) {
-			dev_info(&pdev->dev, "rtc disabled, re-enabling\n");
-			writel(readl(RTC_RTSR) | RTC_RTSR_HZE, RTC_RTSR);
-		}
-	}
-}
-
-static int puv3_rtc_remove(struct platform_device *dev)
-{
-	struct rtc_device *rtc = platform_get_drvdata(dev);
-
-	platform_set_drvdata(dev, NULL);
-	rtc_device_unregister(rtc);
-
-	puv3_rtc_setpie(&dev->dev, 0);
-	puv3_rtc_setaie(0);
-
-	release_resource(puv3_rtc_mem);
-	kfree(puv3_rtc_mem);
-
-	return 0;
-}
-
-static int puv3_rtc_probe(struct platform_device *pdev)
-{
-	struct rtc_device *rtc;
-	struct resource *res;
-	int ret;
-
-	pr_debug("%s: probe=%p\n", __func__, pdev);
-
-	/* find the IRQs */
-
-	puv3_rtc_tickno = platform_get_irq(pdev, 1);
-	if (puv3_rtc_tickno < 0) {
-		dev_err(&pdev->dev, "no irq for rtc tick\n");
-		return -ENOENT;
-	}
-
-	puv3_rtc_alarmno = platform_get_irq(pdev, 0);
-	if (puv3_rtc_alarmno < 0) {
-		dev_err(&pdev->dev, "no irq for alarm\n");
-		return -ENOENT;
-	}
-
-	pr_debug("PKUnity_rtc: tick irq %d, alarm irq %d\n",
-		 puv3_rtc_tickno, puv3_rtc_alarmno);
-
-	/* get the memory region */
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "failed to get memory region resource\n");
-		return -ENOENT;
-	}
-
-	puv3_rtc_mem = request_mem_region(res->start,
-					 res->end-res->start+1,
-					 pdev->name);
-
-	if (puv3_rtc_mem == NULL) {
-		dev_err(&pdev->dev, "failed to reserve memory region\n");
-		ret = -ENOENT;
-		goto err_nores;
-	}
-
-	puv3_rtc_enable(pdev, 1);
-
-	/* register RTC and exit */
-
-	rtc = rtc_device_register("pkunity", &pdev->dev, &puv3_rtcops,
-				  THIS_MODULE);
-
-	if (IS_ERR(rtc)) {
-		dev_err(&pdev->dev, "cannot attach rtc\n");
-		ret = PTR_ERR(rtc);
-		goto err_nortc;
-	}
-
-	/* platform setup code should have handled this; sigh */
-	if (!device_can_wakeup(&pdev->dev))
-		device_init_wakeup(&pdev->dev, 1);
-
-	platform_set_drvdata(pdev, rtc);
-	return 0;
-
- err_nortc:
-	puv3_rtc_enable(pdev, 0);
-	release_resource(puv3_rtc_mem);
-
- err_nores:
-	return ret;
-}
-
-#ifdef CONFIG_PM
-
-/* RTC Power management control */
-
-static int ticnt_save;
-
-static int puv3_rtc_suspend(struct platform_device *pdev, pm_message_t state)
-{
-	/* save RTAR for anyone using periodic interrupts */
-	ticnt_save = readl(RTC_RTAR);
-	puv3_rtc_enable(pdev, 0);
-	return 0;
-}
-
-static int puv3_rtc_resume(struct platform_device *pdev)
-{
-	puv3_rtc_enable(pdev, 1);
-	writel(ticnt_save, RTC_RTAR);
-	return 0;
-}
-#else
-#define puv3_rtc_suspend NULL
-#define puv3_rtc_resume  NULL
-#endif
-
-static struct platform_driver puv3_rtcdrv = {
-	.probe		= puv3_rtc_probe,
-	.remove		= __devexit_p(puv3_rtc_remove),
-	.suspend	= puv3_rtc_suspend,
-	.resume		= puv3_rtc_resume,
-	.driver		= {
-		.name	= "PKUnity-v3-RTC",
-		.owner	= THIS_MODULE,
-	}
-};
-
-static char __initdata banner[] = "PKUnity-v3 RTC, (c) 2009 PKUnity Co.\n";
-
-static int __init puv3_rtc_init(void)
-{
-	printk(banner);
-	return platform_driver_register(&puv3_rtcdrv);
-}
-
-static void __exit puv3_rtc_exit(void)
-{
-	platform_driver_unregister(&puv3_rtcdrv);
-}
-
-module_init(puv3_rtc_init);
-module_exit(puv3_rtc_exit);
-
-MODULE_DESCRIPTION("RTC Driver for the PKUnity v3 chip");
-MODULE_AUTHOR("Hu Dongliang");
-MODULE_LICENSE("GPL v2");
-
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index e187887..e25e1b8 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -995,4 +995,13 @@ config RTC_DRV_TEGRA
 	  This drive can also be built as a module. If so, the module
 	  will be called rtc-tegra.
 
+config RTC_DRV_PUV3
+	tristate "PKUnity v3 RTC support"
+	depends on ARCH_PUV3
+	help
+	  This enables support for the RTC in the PKUnity-v3 SoCs.
+
+	  This drive can also be built as a module. If so, the module
+	  will be called rtc-puv3.
+
 endif # RTC_CLASS
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index ca91c3c..0eacb7c 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -75,6 +75,7 @@ obj-$(CONFIG_RTC_DRV_PCF50633)	+= rtc-pcf50633.o
 obj-$(CONFIG_RTC_DRV_PL030)	+= rtc-pl030.o
 obj-$(CONFIG_RTC_DRV_PL031)	+= rtc-pl031.o
 obj-$(CONFIG_RTC_DRV_PS3)	+= rtc-ps3.o
+obj-$(CONFIG_RTC_DRV_PUV3)	+= rtc-puv3.o
 obj-$(CONFIG_RTC_DRV_PXA)	+= rtc-pxa.o
 obj-$(CONFIG_RTC_DRV_R9701)	+= rtc-r9701.o
 obj-$(CONFIG_RTC_DRV_RP5C01)	+= rtc-rp5c01.o
diff --git a/drivers/rtc/rtc-puv3.c b/drivers/rtc/rtc-puv3.c
new file mode 100644
index 0000000..8cad70b
--- /dev/null
+++ b/drivers/rtc/rtc-puv3.c
@@ -0,0 +1,371 @@
+/*
+ * linux/arch/unicore32/kernel/rtc.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
+ *	Copyright (C) 2001-2010 Guan Xuetao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/string.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/rtc.h>
+#include <linux/bcd.h>
+#include <linux/clk.h>
+#include <linux/log2.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+
+#include <asm/irq.h>
+#include <mach/hardware.h>
+
+static struct resource *puv3_rtc_mem;
+
+static int puv3_rtc_alarmno = IRQ_RTCAlarm;
+static int puv3_rtc_tickno  = IRQ_RTC;
+
+static DEFINE_SPINLOCK(puv3_rtc_pie_lock);
+
+/* IRQ Handlers */
+
+static irqreturn_t puv3_rtc_alarmirq(int irq, void *id)
+{
+	struct rtc_device *rdev = id;
+
+	writel(readl(RTC_RTSR) | RTC_RTSR_AL, RTC_RTSR);
+	rtc_update_irq(rdev, 1, RTC_AF | RTC_IRQF);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t puv3_rtc_tickirq(int irq, void *id)
+{
+	struct rtc_device *rdev = id;
+
+	writel(readl(RTC_RTSR) | RTC_RTSR_HZ, RTC_RTSR);
+	rtc_update_irq(rdev, 1, RTC_PF | RTC_IRQF);
+	return IRQ_HANDLED;
+}
+
+/* Update control registers */
+static void puv3_rtc_setaie(int to)
+{
+	unsigned int tmp;
+
+	pr_debug("%s: aie=%d\n", __func__, to);
+
+	tmp = readl(RTC_RTSR) & ~RTC_RTSR_ALE;
+
+	if (to)
+		tmp |= RTC_RTSR_ALE;
+
+	writel(tmp, RTC_RTSR);
+}
+
+static int puv3_rtc_setpie(struct device *dev, int enabled)
+{
+	unsigned int tmp;
+
+	pr_debug("%s: pie=%d\n", __func__, enabled);
+
+	spin_lock_irq(&puv3_rtc_pie_lock);
+	tmp = readl(RTC_RTSR) & ~RTC_RTSR_HZE;
+
+	if (enabled)
+		tmp |= RTC_RTSR_HZE;
+
+	writel(tmp, RTC_RTSR);
+	spin_unlock_irq(&puv3_rtc_pie_lock);
+
+	return 0;
+}
+
+/* Time read/write */
+
+static int puv3_rtc_gettime(struct device *dev, struct rtc_time *rtc_tm)
+{
+	rtc_time_to_tm(readl(RTC_RCNR), rtc_tm);
+
+	pr_debug("read time %02x.%02x.%02x %02x/%02x/%02x\n",
+		 rtc_tm->tm_year, rtc_tm->tm_mon, rtc_tm->tm_mday,
+		 rtc_tm->tm_hour, rtc_tm->tm_min, rtc_tm->tm_sec);
+
+	return 0;
+}
+
+static int puv3_rtc_settime(struct device *dev, struct rtc_time *tm)
+{
+	unsigned long rtc_count = 0;
+
+	pr_debug("set time %02d.%02d.%02d %02d/%02d/%02d\n",
+		 tm->tm_year, tm->tm_mon, tm->tm_mday,
+		 tm->tm_hour, tm->tm_min, tm->tm_sec);
+
+	rtc_tm_to_time(tm, &rtc_count);
+	writel(rtc_count, RTC_RCNR);
+
+	return 0;
+}
+
+static int puv3_rtc_getalarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct rtc_time *alm_tm = &alrm->time;
+
+	rtc_time_to_tm(readl(RTC_RTAR), alm_tm);
+
+	alrm->enabled = readl(RTC_RTSR) & RTC_RTSR_ALE;
+
+	pr_debug("read alarm %02x %02x.%02x.%02x %02x/%02x/%02x\n",
+		 alrm->enabled,
+		 alm_tm->tm_year, alm_tm->tm_mon, alm_tm->tm_mday,
+		 alm_tm->tm_hour, alm_tm->tm_min, alm_tm->tm_sec);
+
+	return 0;
+}
+
+static int puv3_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct rtc_time *tm = &alrm->time;
+	unsigned long rtcalarm_count = 0;
+
+	pr_debug("puv3_rtc_setalarm: %d, %02x/%02x/%02x %02x.%02x.%02x\n",
+		 alrm->enabled,
+		 tm->tm_mday & 0xff, tm->tm_mon & 0xff, tm->tm_year & 0xff,
+		 tm->tm_hour & 0xff, tm->tm_min & 0xff, tm->tm_sec);
+
+	rtc_tm_to_time(tm, &rtcalarm_count);
+	writel(rtcalarm_count, RTC_RTAR);
+
+	puv3_rtc_setaie(alrm->enabled);
+
+	if (alrm->enabled)
+		enable_irq_wake(puv3_rtc_alarmno);
+	else
+		disable_irq_wake(puv3_rtc_alarmno);
+
+	return 0;
+}
+
+static int puv3_rtc_proc(struct device *dev, struct seq_file *seq)
+{
+	seq_printf(seq, "periodic_IRQ\t: %s\n",
+		     (readl(RTC_RTSR) & RTC_RTSR_HZE) ? "yes" : "no");
+	return 0;
+}
+
+static int puv3_rtc_open(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rtc_device *rtc_dev = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = request_irq(puv3_rtc_alarmno, puv3_rtc_alarmirq,
+			  IRQF_DISABLED,  "pkunity-rtc alarm", rtc_dev);
+
+	if (ret) {
+		dev_err(dev, "IRQ%d error %d\n", puv3_rtc_alarmno, ret);
+		return ret;
+	}
+
+	ret = request_irq(puv3_rtc_tickno, puv3_rtc_tickirq,
+			  IRQF_DISABLED,  "pkunity-rtc tick", rtc_dev);
+
+	if (ret) {
+		dev_err(dev, "IRQ%d error %d\n", puv3_rtc_tickno, ret);
+		goto tick_err;
+	}
+
+	return ret;
+
+ tick_err:
+	free_irq(puv3_rtc_alarmno, rtc_dev);
+	return ret;
+}
+
+static void puv3_rtc_release(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rtc_device *rtc_dev = platform_get_drvdata(pdev);
+
+	/* do not clear AIE here, it may be needed for wake */
+
+	puv3_rtc_setpie(dev, 0);
+	free_irq(puv3_rtc_alarmno, rtc_dev);
+	free_irq(puv3_rtc_tickno, rtc_dev);
+}
+
+static const struct rtc_class_ops puv3_rtcops = {
+	.open		= puv3_rtc_open,
+	.release	= puv3_rtc_release,
+	.read_time	= puv3_rtc_gettime,
+	.set_time	= puv3_rtc_settime,
+	.read_alarm	= puv3_rtc_getalarm,
+	.set_alarm	= puv3_rtc_setalarm,
+	.proc	        = puv3_rtc_proc,
+};
+
+static void puv3_rtc_enable(struct platform_device *pdev, int en)
+{
+	if (!en) {
+		writel(readl(RTC_RTSR) & ~RTC_RTSR_HZE, RTC_RTSR);
+	} else {
+		/* re-enable the device, and check it is ok */
+
+		if ((readl(RTC_RTSR) & RTC_RTSR_HZE) == 0) {
+			dev_info(&pdev->dev, "rtc disabled, re-enabling\n");
+			writel(readl(RTC_RTSR) | RTC_RTSR_HZE, RTC_RTSR);
+		}
+	}
+}
+
+static int puv3_rtc_remove(struct platform_device *dev)
+{
+	struct rtc_device *rtc = platform_get_drvdata(dev);
+
+	platform_set_drvdata(dev, NULL);
+	rtc_device_unregister(rtc);
+
+	puv3_rtc_setpie(&dev->dev, 0);
+	puv3_rtc_setaie(0);
+
+	release_resource(puv3_rtc_mem);
+	kfree(puv3_rtc_mem);
+
+	return 0;
+}
+
+static int puv3_rtc_probe(struct platform_device *pdev)
+{
+	struct rtc_device *rtc;
+	struct resource *res;
+	int ret;
+
+	pr_debug("%s: probe=%p\n", __func__, pdev);
+
+	/* find the IRQs */
+
+	puv3_rtc_tickno = platform_get_irq(pdev, 1);
+	if (puv3_rtc_tickno < 0) {
+		dev_err(&pdev->dev, "no irq for rtc tick\n");
+		return -ENOENT;
+	}
+
+	puv3_rtc_alarmno = platform_get_irq(pdev, 0);
+	if (puv3_rtc_alarmno < 0) {
+		dev_err(&pdev->dev, "no irq for alarm\n");
+		return -ENOENT;
+	}
+
+	pr_debug("PKUnity_rtc: tick irq %d, alarm irq %d\n",
+		 puv3_rtc_tickno, puv3_rtc_alarmno);
+
+	/* get the memory region */
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "failed to get memory region resource\n");
+		return -ENOENT;
+	}
+
+	puv3_rtc_mem = request_mem_region(res->start,
+					 res->end-res->start+1,
+					 pdev->name);
+
+	if (puv3_rtc_mem == NULL) {
+		dev_err(&pdev->dev, "failed to reserve memory region\n");
+		ret = -ENOENT;
+		goto err_nores;
+	}
+
+	puv3_rtc_enable(pdev, 1);
+
+	/* register RTC and exit */
+
+	rtc = rtc_device_register("pkunity", &pdev->dev, &puv3_rtcops,
+				  THIS_MODULE);
+
+	if (IS_ERR(rtc)) {
+		dev_err(&pdev->dev, "cannot attach rtc\n");
+		ret = PTR_ERR(rtc);
+		goto err_nortc;
+	}
+
+	/* platform setup code should have handled this; sigh */
+	if (!device_can_wakeup(&pdev->dev))
+		device_init_wakeup(&pdev->dev, 1);
+
+	platform_set_drvdata(pdev, rtc);
+	return 0;
+
+ err_nortc:
+	puv3_rtc_enable(pdev, 0);
+	release_resource(puv3_rtc_mem);
+
+ err_nores:
+	return ret;
+}
+
+#ifdef CONFIG_PM
+
+/* RTC Power management control */
+
+static int ticnt_save;
+
+static int puv3_rtc_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	/* save RTAR for anyone using periodic interrupts */
+	ticnt_save = readl(RTC_RTAR);
+	puv3_rtc_enable(pdev, 0);
+	return 0;
+}
+
+static int puv3_rtc_resume(struct platform_device *pdev)
+{
+	puv3_rtc_enable(pdev, 1);
+	writel(ticnt_save, RTC_RTAR);
+	return 0;
+}
+#else
+#define puv3_rtc_suspend NULL
+#define puv3_rtc_resume  NULL
+#endif
+
+static struct platform_driver puv3_rtcdrv = {
+	.probe		= puv3_rtc_probe,
+	.remove		= __devexit_p(puv3_rtc_remove),
+	.suspend	= puv3_rtc_suspend,
+	.resume		= puv3_rtc_resume,
+	.driver		= {
+		.name	= "PKUnity-v3-RTC",
+		.owner	= THIS_MODULE,
+	}
+};
+
+static char __initdata banner[] = "PKUnity-v3 RTC, (c) 2009 PKUnity Co.\n";
+
+static int __init puv3_rtc_init(void)
+{
+	printk(banner);
+	return platform_driver_register(&puv3_rtcdrv);
+}
+
+static void __exit puv3_rtc_exit(void)
+{
+	platform_driver_unregister(&puv3_rtcdrv);
+}
+
+module_init(puv3_rtc_init);
+module_exit(puv3_rtc_exit);
+
+MODULE_DESCRIPTION("RTC Driver for the PKUnity v3 chip");
+MODULE_AUTHOR("Hu Dongliang");
+MODULE_LICENSE("GPL v2");
+
-- 
1.6.2.2


