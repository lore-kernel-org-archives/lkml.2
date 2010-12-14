Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304Ab0LNPKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 10:10:05 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:39839 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759261Ab0LNPKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 10:10:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=c6UeYQzVy/RtMKKIlaX6YaxABscimk6ZYKjAxpMcWzkpIQhIsexkNP/yZp2KdTbwH4
         9QK8XyJ4YOYKaQxd/n4dFroBRwG7NmcSxYC7vZndJnnI6rqdNuRAAXyTFYSyZcW5mkdD
         MsLXk8NrnXj87n7m/mkqjiCoS1VSO2J9oSwHQ=
From: Hans Ulli Kroll <ulli.kroll@googlemail.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>
Subject: [PATCH 1/2] RTC: Add core rtc support for Gemini Soc devices
Date: Tue, 14 Dec 2010 16:08:26 +0100
Message-Id: <1292339307-14336-2-git-send-email-ulli.kroll@googlemail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292339307-14336-1-git-send-email-ulli.kroll@googlemail.com>
References: <1292339307-14336-1-git-send-email-ulli.kroll@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

driver for the rtc device
on Cortina Systems CS3516 or StormlinkSemi SL3516 aka Gemini SoC

Signed-off-by: Hans Ulli Kroll <ulli.kroll@googlemail.com>
---
 MAINTAINERS              |    1 +
 drivers/rtc/Kconfig      |    9 ++
 drivers/rtc/Makefile     |    1 +
 drivers/rtc/rtc-gemini.c |  206 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 217 insertions(+), 0 deletions(-)
 create mode 100644 drivers/rtc/rtc-gemini.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 0094224..1987d46 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -619,6 +619,7 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 T:	git git://git.berlios.de/gemini-board
 S:	Maintained
 F:	arch/arm/mach-gemini/
+F:	drivers/rtc/rtc-gemini.c
 
 ARM/EBSA110 MACHINE SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 2883428..da14253 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -839,6 +839,15 @@ config RTC_DRV_BFIN
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-bfin.
 
+config RTC_DRV_GEMINI
+	tristate "Gemini SoC RTC"
+	help
+	  If you say Y here you will get support for the
+	  RTC found on Gemini SoC's.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-gemini.
+
 config RTC_DRV_RS5C313
 	tristate "Ricoh RS5C313"
 	depends on SH_LANDISK
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 4c2832d..779e42c 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_RTC_DRV_DS3234)	+= rtc-ds3234.o
 obj-$(CONFIG_RTC_DRV_EFI)	+= rtc-efi.o
 obj-$(CONFIG_RTC_DRV_EP93XX)	+= rtc-ep93xx.o
 obj-$(CONFIG_RTC_DRV_FM3130)	+= rtc-fm3130.o
+obj-$(CONFIG_RTC_DRV_GEMINI)	+= rtc-gemini.o
 obj-$(CONFIG_RTC_DRV_GENERIC)	+= rtc-generic.o
 obj-$(CONFIG_RTC_DRV_IMXDI)	+= rtc-imxdi.o
 obj-$(CONFIG_RTC_DRV_ISL1208)	+= rtc-isl1208.o
diff --git a/drivers/rtc/rtc-gemini.c b/drivers/rtc/rtc-gemini.c
new file mode 100644
index 0000000..111bb67
--- /dev/null
+++ b/drivers/rtc/rtc-gemini.c
@@ -0,0 +1,206 @@
+/*
+ *  Gemini OnChip RTC
+ *
+ *  Copyright (C) 2009 Janos Laube <janos.dev@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Original code for older kernel 2.6.15 are form Stormlinksemi
+ * first update from Janos Laube for > 2.6.29 kernels
+ *
+ * checkpatch fixes and usage off rtc-lib code
+ * Hans Ulli Kroll <ulli.kroll@googlemail.com>
+ */
+
+#include <linux/rtc.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+
+#include <mach/hardware.h>
+
+#define DRV_NAME        "rtc-gemini"
+#define DRV_VERSION     "0.2"
+
+struct gemini_rtc {
+	struct rtc_device	*rtc_dev;
+	void __iomem		*rtc_base;
+	int			rtc_irq;
+};
+
+enum gemini_rtc_offsets {
+	GEMINI_RTC_SECOND	= 0x00,
+	GEMINI_RTC_MINUTE	= 0x04,
+	GEMINI_RTC_HOUR		= 0x08,
+	GEMINI_RTC_DAYS		= 0x0C,
+	GEMINI_RTC_ALARM_SECOND	= 0x10,
+	GEMINI_RTC_ALARM_MINUTE	= 0x14,
+	GEMINI_RTC_ALARM_HOUR	= 0x18,
+	GEMINI_RTC_RECORD	= 0x1C,
+	GEMINI_RTC_CR		= 0x20
+};
+
+static irqreturn_t gemini_rtc_interrupt(int irq, void *dev)
+{
+	return IRQ_HANDLED;
+}
+
+/*
+ * Looks like the RTC in the Gemini SoC is (totaly) broken
+ * We can't read/write directly the time from RTC registers.
+ * We must do some "offset" calculation to get the real time
+ *
+ * This FIX works pretty fine and Stormlinksemi aka Cortina-Networks does
+ * the same thing, without the rtc-lib.c calls.
+ */
+
+static int gemini_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct gemini_rtc *rtc = dev_get_drvdata(dev);
+
+	unsigned int  days, hour, min, sec;
+	unsigned long offset, time;
+
+	sec  = ioread32(rtc->rtc_base + GEMINI_RTC_SECOND);
+	min  = ioread32(rtc->rtc_base + GEMINI_RTC_MINUTE);
+	hour = ioread32(rtc->rtc_base + GEMINI_RTC_HOUR);
+	days = ioread32(rtc->rtc_base + GEMINI_RTC_DAYS);
+	offset = ioread32(rtc->rtc_base + GEMINI_RTC_RECORD);
+
+	time = offset + days * 86400 + hour * 3600 + min * 60 + sec;
+
+	rtc_time_to_tm(time, tm);
+
+	return 0;
+}
+
+static int gemini_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct gemini_rtc *rtc = dev_get_drvdata(dev);
+	unsigned int sec, min, hour, day;
+	unsigned long offset, time;
+
+	if (tm->tm_year >= 2148)	/* EPOCH Year + 179 */
+		return -EINVAL;
+
+	rtc_tm_to_time(tm , &time);
+
+	sec = ioread32(rtc->rtc_base + GEMINI_RTC_SECOND);
+	min = ioread32(rtc->rtc_base + GEMINI_RTC_MINUTE);
+	hour = ioread32(rtc->rtc_base + GEMINI_RTC_HOUR);
+	day = ioread32(rtc->rtc_base + GEMINI_RTC_DAYS);
+
+	offset = time - (day*86400 + hour*3600 + min*60 + sec);
+
+	iowrite32(offset, rtc->rtc_base + GEMINI_RTC_RECORD);
+	iowrite32(0x01, rtc->rtc_base + GEMINI_RTC_CR);
+
+	return 0;
+}
+
+static struct rtc_class_ops gemini_rtc_ops = {
+	.read_time     = gemini_rtc_read_time,
+	.set_time      = gemini_rtc_set_time,
+};
+
+static int __devinit gemini_rtc_probe(struct platform_device *pdev)
+{
+	struct gemini_rtc *rtc;
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	int ret;
+
+	rtc = kzalloc(sizeof(*rtc), GFP_KERNEL);
+	if (unlikely(!rtc))
+		return -ENOMEM;
+	platform_set_drvdata(pdev, rtc);
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res) {
+		ret = -ENODEV;
+		goto err_mem;
+	}
+	rtc->rtc_irq = res->start;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		ret = -ENODEV;
+		goto err_mem;
+	}
+	rtc->rtc_base =	devm_ioremap(&pdev->dev, res->start,
+				res->end - res->start + 1);
+
+	ret = request_irq(rtc->rtc_irq, gemini_rtc_interrupt,
+				IRQF_SHARED, pdev->name, dev);
+	if (unlikely(ret))
+		goto err_mem;
+
+	rtc->rtc_dev =	rtc_device_register(pdev->name, dev,
+				&gemini_rtc_ops, THIS_MODULE);
+	if (unlikely(IS_ERR(rtc->rtc_dev))) {
+		ret = PTR_ERR(rtc->rtc_dev);
+		goto err_irq;
+	}
+	return 0;
+
+err_irq:
+	free_irq(rtc->rtc_irq, dev);
+
+err_mem:
+	kfree(rtc);
+	return ret;
+}
+
+static int __devexit gemini_rtc_remove(struct platform_device *pdev)
+{
+	struct gemini_rtc *rtc = platform_get_drvdata(pdev);
+	struct device *dev = &pdev->dev;
+
+	free_irq(rtc->rtc_irq, dev);
+	rtc_device_unregister(rtc->rtc_dev);
+	platform_set_drvdata(pdev, NULL);
+	kfree(rtc);
+
+	return 0;
+}
+
+static struct platform_driver gemini_rtc_driver = {
+	.driver		= {
+		.name	= "rtc-gemini",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= gemini_rtc_probe,
+	.remove		= __devexit_p(gemini_rtc_remove),
+};
+
+static int __init gemini_rtc_init(void)
+{
+	return platform_driver_register(&gemini_rtc_driver);
+}
+
+static void __exit gemini_rtc_exit(void)
+{
+	platform_driver_unregister(&gemini_rtc_driver);
+}
+
+module_init(gemini_rtc_init);
+module_exit(gemini_rtc_exit);
+
+MODULE_AUTHOR("Hans Ulli Kroll <ulli.kroll@googlemail.com>");
+MODULE_DESCRIPTION("RTC driver for Gemini SoC");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
+MODULE_ALIAS("platform:" DRV_NAME);
+
-- 
1.7.3.2

