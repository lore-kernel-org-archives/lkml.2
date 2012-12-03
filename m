Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab2LCPDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 10:03:54 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50540 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab2LCPDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 10:03:52 -0500
Subject: [PATCH 8/9] goldfish: real time clock
To: arve@android.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        mikechan@google.com
From: Alan Cox <alan@linux.intel.com>
Date: Mon, 03 Dec 2012 15:06:11 +0000
Message-ID: <20121203150608.16826.78775.stgit@bob.linux.org.uk>
In-Reply-To: <20121203150310.16826.3363.stgit@bob.linux.org.uk>
References: <20121203150310.16826.3363.stgit@bob.linux.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@google.com>

Gets the current time from the host. Alarms are not supported yet.

Signed-off-by: Mike A. Chan <mikechan@google.com>
Signed-off-by: Arve Hjønnevåg <arve@android.com>
[Ported to 3.4]
Signed-off-by: Tom Keel <thomas.keel@intel.com>
[Cleaned up to use ioremap, types, unload etc]
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/include/asm/goldfish.h |    7 ++
 drivers/rtc/Kconfig             |    9 ++
 drivers/rtc/Makefile            |    1 
 drivers/rtc/rtc-goldfish.c      |  146 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 163 insertions(+)
 create mode 100644 drivers/rtc/rtc-goldfish.c


diff --git a/arch/x86/include/asm/goldfish.h b/arch/x86/include/asm/goldfish.h
index d5fcf6d..28a0b9e 100644
--- a/arch/x86/include/asm/goldfish.h
+++ b/arch/x86/include/asm/goldfish.h
@@ -33,4 +33,11 @@
 
 #define GOLDFISH_TTY_BASE	(0x2000)
 
+#define GOLDFISH_TIME_LOW		0x00
+#define GOLDFISH_TIME_HIGH		0x04
+#define GOLDFISH_ALARM_LOW		0x08
+#define GOLDFISH_ALARM_HIGH		0x0C
+#define GOLDFISH_CLEAR_TIMER_INT	0x10
+#define GOLDFISH_CLEAR_ALARM		0x14
+
 #endif
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 5bb0314..358bfa2 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -948,6 +948,15 @@ config RTC_DRV_BFIN
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-bfin.
 
+config RTC_DRV_GOLDFISH
+	tristate "GOLDFISH"
+	depends on GOLDFISH
+	help
+	  RTC driver for Goldfish Virtual Platform
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-goldfish.
+
 config RTC_DRV_RS5C313
 	tristate "Ricoh RS5C313"
 	depends on SH_LANDISK
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 59e2132..9a00537 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_RTC_DRV_EM3027)	+= rtc-em3027.o
 obj-$(CONFIG_RTC_DRV_EP93XX)	+= rtc-ep93xx.o
 obj-$(CONFIG_RTC_DRV_FM3130)	+= rtc-fm3130.o
 obj-$(CONFIG_RTC_DRV_GENERIC)	+= rtc-generic.o
+obj-$(CONFIG_RTC_DRV_GOLDFISH)	+= rtc-goldfish.o
 obj-$(CONFIG_RTC_DRV_IMXDI)	+= rtc-imxdi.o
 obj-$(CONFIG_RTC_DRV_ISL1208)	+= rtc-isl1208.o
 obj-$(CONFIG_RTC_DRV_ISL12022)	+= rtc-isl12022.o
diff --git a/drivers/rtc/rtc-goldfish.c b/drivers/rtc/rtc-goldfish.c
new file mode 100644
index 0000000..2534913
--- /dev/null
+++ b/drivers/rtc/rtc-goldfish.c
@@ -0,0 +1,146 @@
+/*
+ * drivers/rtc/rtc-goldfish.c
+ *
+ * Copyright (C) 2007 Google, Inc.
+ * Copyright (C) 2012 Intel, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/platform_device.h>
+#include <linux/rtc.h>
+#include <linux/export.h>
+#include <linux/slab.h>
+
+#include <asm/goldfish.h>
+
+struct goldfish_rtc {
+	void __iomem *base;
+	u32 irq;
+	struct rtc_device *rtc;
+};
+
+static irqreturn_t goldfish_rtc_interrupt(int irq, void *dev_id)
+{
+	struct goldfish_rtc	*qrtc = dev_id;
+	unsigned long		events = 0;
+
+	writel(1, qrtc->base + GOLDFISH_CLEAR_TIMER_INT);
+	events = RTC_IRQF | RTC_AF;
+
+	rtc_update_irq(qrtc->rtc, 1, events);
+
+	return IRQ_HANDLED;
+}
+
+static int goldfish_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	int64_t time;
+	struct goldfish_rtc *qrtc = platform_get_drvdata(
+						to_platform_device(dev));
+
+	time = readl(qrtc->base + GOLDFISH_TIME_LOW);
+	time |= (int64_t)readl(qrtc->base + GOLDFISH_TIME_HIGH) << 32;
+	do_div(time, NSEC_PER_SEC);
+
+	rtc_time_to_tm(time, tm);
+	return 0;
+}
+
+static const struct rtc_class_ops goldfish_rtc_ops = {
+	.read_time	= goldfish_rtc_read_time,
+};
+
+static int goldfish_rtc_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct resource *r;
+	struct goldfish_rtc *qrtc;
+
+	qrtc = kzalloc(sizeof(*qrtc), GFP_KERNEL);
+	if (qrtc == NULL) {
+		ret = -ENOMEM;
+		goto err_qrtc_alloc_failed;
+	}
+	platform_set_drvdata(pdev, qrtc);
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (r == NULL) {
+		ret = -ENODEV;
+		goto err_no_io_base;
+	}
+	qrtc->base = ioremap(r->start, 0x18);
+	if (qrtc->base == NULL) {
+		ret = -ENOMEM;
+		goto err_no_io_base;
+	}
+	qrtc->irq = platform_get_irq(pdev, 0);
+	if (qrtc->irq < 0) {
+		ret = -ENODEV;
+		goto err_no_irq;
+	}
+	qrtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
+					&goldfish_rtc_ops, THIS_MODULE);
+	if (IS_ERR(qrtc->rtc)) {
+		ret = PTR_ERR(qrtc->rtc);
+		goto err_rtc_device_register_failed;
+	}
+
+	ret = request_irq(qrtc->irq, goldfish_rtc_interrupt, 0, pdev->name, qrtc);
+	if (ret)
+		goto request_irq;
+
+	return 0;
+
+	free_irq(qrtc->irq, qrtc);
+request_irq:
+	rtc_device_unregister(qrtc->rtc);
+err_rtc_device_register_failed:
+err_no_irq:
+	iounmap(qrtc->base);
+err_no_io_base:
+	kfree(qrtc);
+err_qrtc_alloc_failed:
+	return ret;
+}
+
+static int goldfish_rtc_remove(struct platform_device *pdev)
+{
+	struct goldfish_rtc	*qrtc = platform_get_drvdata(pdev);
+	free_irq(qrtc->irq, qrtc);
+	rtc_device_unregister(qrtc->rtc);
+	iounmap(qrtc->base);
+	kfree(qrtc);
+	return 0;
+}
+
+static struct platform_driver goldfish_timer = {
+	.probe = goldfish_rtc_probe,
+	.remove = goldfish_rtc_remove,
+	.driver = {
+		.name = "goldfish_rtc"
+	}
+};
+
+static int __devinit goldfish_rtc_init(void)
+{
+	return platform_driver_register(&goldfish_timer);
+}
+
+static void goldfish_rtc_exit(void)
+{
+	return platform_driver_unregister(&goldfish_timer);
+}
+
+module_init(goldfish_rtc_init);
+module_exit(goldfish_rtc_exit);

