Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab2DNHHq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 03:07:46 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:47917 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab2DNHHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 03:07:44 -0400
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
To: rtc-linux@googlegroups.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Anish Trivedi <anish@freescale.com>, Eric Miao <eric.miao@linaro.org>,
        Anson Huang <b20788@freescale.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH v2] rtc: add support for Freescale SNVS RTC
Date: Sat, 14 Apr 2012 15:07:17 +0800
Message-Id: <1334387237-23519-1-git-send-email-paul.liu@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>

This adds an RTC driver for the Low Power (LP) section of SNVS.
It hooks into the /dev/rtc interface and supports ioctl to complete RTC
features. This driver supports device tree bindings.
It only uses the RTC hw in non-secure mode.

Signed-off-by: Anish Trivedi <anish@freescale.com>
Signed-off-by: Eric Miao <eric.miao@linaro.org>
Signed-off-by: Anson Huang <b20788@freescale.com>
Signed-off-by: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
---
 Documentation/devicetree/bindings/rtc/snvs-rtc.txt |   18 +
 drivers/rtc/Kconfig                                |   10 +
 drivers/rtc/Makefile                               |    1 +
 drivers/rtc/rtc-snvs.c                             |  644 ++++++++++++++++++++
 4 files changed, 673 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rtc/snvs-rtc.txt
 create mode 100644 drivers/rtc/rtc-snvs.c

diff --git a/Documentation/devicetree/bindings/rtc/snvs-rtc.txt b/Documentation/devicetree/bindings/rtc/snvs-rtc.txt
new file mode 100644
index 0000000..95b0a75
--- /dev/null
+++ b/Documentation/devicetree/bindings/rtc/snvs-rtc.txt
@@ -0,0 +1,18 @@
+* Freescale SNVS RTC
+
+Required properties:
+- compatible : Should be "fsl,snvs-rtc"
+- reg: physical base address of the controller and length of memory mapped
+  region.
+- interrupts: Two interrupt numbers to the cpu should be specified. First
+  interrupt number is the consolidated interrupt in non TrustZone. The second
+  interrupt number is the security interrupt in TrustZone. The number of cells
+  representing a interrupt depends on the parent interrupt controller.
+
+Example:
+
+snvs@020cc000 {
+	compatible = "fsl,snvs-rtc";
+	reg = <0x020cc000 0x4000>;
+	interrupts = <0 19 0x04 0 20 0x04>;
+};
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 8c8377d..6597ab6 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -641,6 +641,16 @@ config RTC_MXC
 	   This driver can also be built as a module, if so, the module
 	   will be called "rtc-mxc".
 
+config RTC_DRV_SNVS
+	tristate "Freescale SNVS Real Time Clock"
+	depends on ARCH_MXC
+	help
+	   If you say yes here you get support for the Freescale SNVS
+	   Low Power (LP) RTC module.
+
+	   This driver can also be built as a module, if so, the module
+	   will be called "rtc-snvs".
+
 config RTC_DRV_BQ4802
 	tristate "TI BQ4802"
 	help
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 727ae77..c91042b 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -95,6 +95,7 @@ obj-$(CONFIG_RTC_DRV_S35390A)	+= rtc-s35390a.o
 obj-$(CONFIG_RTC_DRV_S3C)	+= rtc-s3c.o
 obj-$(CONFIG_RTC_DRV_SA1100)	+= rtc-sa1100.o
 obj-$(CONFIG_RTC_DRV_SH)	+= rtc-sh.o
+obj-$(CONFIG_RTC_DRV_SNVS)	+= rtc-snvs.o
 obj-$(CONFIG_RTC_DRV_SPEAR)	+= rtc-spear.o
 obj-$(CONFIG_RTC_DRV_STARFIRE)	+= rtc-starfire.o
 obj-$(CONFIG_RTC_DRV_STK17TA8)	+= rtc-stk17ta8.o
diff --git a/drivers/rtc/rtc-snvs.c b/drivers/rtc/rtc-snvs.c
new file mode 100644
index 0000000..a717084
--- /dev/null
+++ b/drivers/rtc/rtc-snvs.c
@@ -0,0 +1,644 @@
+/*
+ * Copyright (C) 2011 Freescale Semiconductor, Inc.
+ */
+
+/*
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
+ */
+/*
+ * Implementation based on rtc-ds1553.c
+ */
+
+/*
+ * RTC Real Time Clock (RTC) Driver
+ *
+ * Secure Real Time Clock (SRTC) interface in Freescale's SNVS module
+ *
+ * This file contains Real Time Clock interface for Linux. The Freescale
+ * SNVS module's Low Power (LP) SRTC functionality is utilized in this driver,
+ * in non-secure mode.
+ */
+
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/rtc.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+#include <linux/sched.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_address.h>
+
+/* Register definitions */
+#define SNVS_HPSR	0x14	/* HP Status Register */
+#define SNVS_LPCR	0x38	/* LP Control Register */
+#define SNVS_LPSR	0x4C	/* LP Status Register */
+#define SNVS_LPSRTCMR	0x50	/* LP Secure Real Time Counter MSB Register */
+#define SNVS_LPSRTCLR	0x54	/* LP Secure Real Time Counter LSB Register */
+#define SNVS_LPTAR	0x58	/* LP Time Alarm Register */
+#define SNVS_LPSMCMR	0x5C	/* LP Secure Monotonic Counter MSB Register */
+#define SNVS_LPSMCLR	0x60	/* LP Secure Monotonic Counter LSB Register */
+#define SNVS_LPPGDR	0x64	/* LP Power Glitch Detector Register */
+#define SNVS_LPGPR	0x68	/* LP General Purpose Register */
+
+/* Bit Definitions */
+#define SNVS_HPSR_SSM_ST_MASK	0x00000F00
+#define SNVS_HPSR_SSM_ST_SHIFT	8
+
+#define SNVS_LPCR_SRTC_ENV	(1 << 0)
+#define SNVS_LPCR_LPTA_EN	(1 << 1)
+#define SNVS_LPCR_LPWUI_EN	(1 << 3)
+#define SNVS_LPCR_ALL_INT_EN	(SNVS_LPCR_LPTA_EN | SNVS_LPCR_LPWUI_EN)
+#define SNVS_LPSR_LPTA		(1 << 0)
+#define SNVS_LPPGDR_INIT	0x41736166
+
+/* Other defines */
+#define SSM_ST_CHECK		0x9
+#define SSM_ST_NON_SECURE	0xB
+#define CNTR_TO_SECS_SH 15	/* Converts 47-bit counter to 32-bit seconds */
+
+struct rtc_drv_data {
+	struct rtc_device *rtc;
+	void __iomem *ioaddr;
+	int irq;
+	bool irq_enable;
+};
+
+static DEFINE_SPINLOCK(rtc_lock);
+static int64_t time_diff;
+
+/**
+ * rtc_read_lp_counter() - Read the LP counter
+ *
+ * @ioaddr: I/O address of the rtc
+ *
+ * LP counter register reads should always use this function.
+ * This function reads 2 consective times from LP counter register
+ * until the 2 values match. This is to avoid reading corrupt
+ * value if the counter is in the middle of updating
+ */
+static inline u32 rtc_read_lp_counter(void __iomem *ioaddr)
+{
+	u64 read1, read2;
+	u32 counter_sec;
+
+	do {
+		/* MSB */
+		read1 = readl(ioaddr + SNVS_LPSRTCMR);
+		read1 <<= 32;
+		/* LSB */
+		read1 |= readl(ioaddr + SNVS_LPSRTCLR);
+
+		/* MSB */
+		read2 = readl(ioaddr + SNVS_LPSRTCMR);
+		read2 <<= 32;
+		/* LSB */
+		read2 |= readl(ioaddr + SNVS_LPSRTCLR);
+	} while (read1 != read2);
+
+	/* Convert 47-bit counter to 32-bit raw second count */
+	counter_sec = (u32) (read1 >> CNTR_TO_SECS_SH);
+
+	return counter_sec;
+}
+
+/**
+ * rtc_write_sync_lp() - write data to registers
+ *
+ * @ioaddr: I/O address of the rtc
+ *
+ * This function does write synchronization for writes to the lp srtc block.
+ * To take care of the asynchronous CKIL clock, all writes from the IP domain
+ * will be synchronized to the CKIL domain.
+ */
+static inline void rtc_write_sync_lp(void __iomem *ioaddr)
+{
+	unsigned int i, count1, count2, count3;
+
+	/* Wait for 3 CKIL cycles */
+	for (i = 0; i < 3; i++) {
+		/* Do consective reads of LSB of counter to ensure integrity */
+		do {
+			count1 = readl(ioaddr + SNVS_LPSRTCLR);
+			count2 = readl(ioaddr + SNVS_LPSRTCLR);
+		} while (count1 != count2);
+
+		/* Now wait until counter value changes */
+		do {
+			do {
+				count2 = readl(ioaddr + SNVS_LPSRTCLR);
+				count3 = readl(ioaddr + SNVS_LPSRTCLR);
+			} while (count2 != count3);
+		} while (count3 == count1);
+	}
+}
+
+/**
+ * rtc_update_alarm() - update RTC alarm registers
+ *
+ * @dev: the dev of rtc
+ * @alrm: the new alarm value to be updated in the RTC
+ *
+ * Returns 0 if successful; non-zero otherwise.
+ *
+ * This function updates the RTC alarm registers and then clears all the
+ * interrupt status bits.
+ */
+static int rtc_update_alarm(struct device *dev, struct rtc_time *alrm)
+{
+	struct rtc_drv_data *pdata = dev_get_drvdata(dev);
+	void __iomem *ioaddr = pdata->ioaddr;
+	struct rtc_time alarm_tm, now_tm;
+	unsigned long now, time, lp_cr;
+	int ret;
+
+	now = rtc_read_lp_counter(ioaddr);
+	rtc_time_to_tm(now, &now_tm);
+
+	alarm_tm.tm_year = now_tm.tm_year;
+	alarm_tm.tm_mon = now_tm.tm_mon;
+	alarm_tm.tm_mday = now_tm.tm_mday;
+
+	alarm_tm.tm_hour = alrm->tm_hour;
+	alarm_tm.tm_min = alrm->tm_min;
+	alarm_tm.tm_sec = alrm->tm_sec;
+
+	rtc_tm_to_time(&now_tm, &now);
+	rtc_tm_to_time(&alarm_tm, &time);
+
+	if (time < now) {
+		time += 60 * 60 * 24;
+		rtc_time_to_tm(time, &alarm_tm);
+	}
+	ret = rtc_tm_to_time(&alarm_tm, &time);
+
+	/* Have to clear LPTA_EN before programming new alarm time in LPTAR */
+	lp_cr = readl(ioaddr + SNVS_LPCR);
+	writel(lp_cr & ~SNVS_LPCR_LPTA_EN, ioaddr + SNVS_LPCR);
+	rtc_write_sync_lp(ioaddr);
+
+	writel(time, ioaddr + SNVS_LPTAR);
+
+	/* clear alarm interrupt status bit */
+	writel(SNVS_LPSR_LPTA, ioaddr + SNVS_LPSR);
+
+	return ret;
+}
+
+/**
+ * snvs_rtc_interrupt() - This function is the RTC interrupt service routine.
+ *
+ * @irq:    RTC IRQ number
+ * @dev_id: device ID which is not used
+ *
+ * Returns IRQ_HANDLED as defined in the include/linux/interrupt.h file.
+ */
+static irqreturn_t snvs_rtc_interrupt(int irq, void *dev_id)
+{
+	struct platform_device *pdev = dev_id;
+	struct rtc_drv_data *pdata = platform_get_drvdata(pdev);
+	void __iomem *ioaddr = pdata->ioaddr;
+	u32 lp_status, lp_cr;
+	u32 events = 0;
+
+	lp_status = readl(ioaddr + SNVS_LPSR);
+	lp_cr = readl(ioaddr + SNVS_LPCR);
+
+	/* update irq data & counter */
+	if (lp_status & SNVS_LPSR_LPTA) {
+		if (lp_cr & SNVS_LPCR_LPTA_EN)
+			events |= (RTC_AF | RTC_IRQF);
+
+		/* disable further lp alarm interrupts */
+		lp_cr &= ~(SNVS_LPCR_LPTA_EN | SNVS_LPCR_LPWUI_EN);
+	}
+
+	/* Update interrupt enables */
+	writel(lp_cr, ioaddr + SNVS_LPCR);
+
+	/* If no interrupts are enabled, turn off interrupts in kernel */
+	if (((lp_cr & SNVS_LPCR_ALL_INT_EN) == 0) && (pdata->irq_enable)) {
+		disable_irq_nosync(pdata->irq);
+		pdata->irq_enable = false;
+	}
+
+	/* clear interrupt status */
+	writel(lp_status, ioaddr + SNVS_LPSR);
+
+	rtc_write_sync_lp(ioaddr);
+	rtc_update_irq(pdata->rtc, 1, events);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * snvs_rtc_read_time() - This function reads the current RTC time into tm
+ *                        in Gregorian date.
+ *
+ * @tm: contains the RTC time value upon return
+ *
+ * Returns 0 if successful; non-zero otherwise.
+ */
+static int snvs_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct rtc_drv_data *pdata = dev_get_drvdata(dev);
+	void __iomem *ioaddr = pdata->ioaddr;
+
+	rtc_time_to_tm(rtc_read_lp_counter(ioaddr), tm);
+
+	return 0;
+}
+
+/**
+ * snvs_rtc_set_time() - This function sets the internal RTC time based on tm
+ *                       in Gregorian date.
+ *
+ * @tm: the time value to be set in the RTC
+ *
+ * Returns 0 if successful; non-zero otherwise.
+ */
+static int snvs_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct rtc_drv_data *pdata = dev_get_drvdata(dev);
+	void __iomem *ioaddr = pdata->ioaddr;
+	unsigned long time;
+	int ret;
+	u32 lp_cr;
+	u64 old_time_47bit, new_time_47bit;
+	unsigned long timeout;
+
+	ret = rtc_tm_to_time(tm, &time);
+	if (ret != 0)
+		return ret;
+
+	old_time_47bit = (((u64) (readl(ioaddr + SNVS_LPSRTCMR) &
+		((0x1 << CNTR_TO_SECS_SH) - 1)) << 32) |
+		((u64) readl(ioaddr + SNVS_LPSRTCLR)));
+
+	/* Disable RTC first */
+	lp_cr = readl(ioaddr + SNVS_LPCR) & ~SNVS_LPCR_SRTC_ENV;
+	writel(lp_cr, ioaddr + SNVS_LPCR);
+	timeout = jiffies + msecs_to_jiffies(3000);
+	while (readl(ioaddr + SNVS_LPCR) & SNVS_LPCR_SRTC_ENV) {
+		if (time_after(jiffies, timeout)) {
+			dev_err(dev, "timeout on temporarily disabling RTC\n");
+			return -EBUSY;
+		}
+	}
+
+	/* Write 32-bit time to 47-bit timer, leaving 15 LSBs blank */
+	writel(time << CNTR_TO_SECS_SH, ioaddr + SNVS_LPSRTCLR);
+	writel(time >> (32 - CNTR_TO_SECS_SH), ioaddr + SNVS_LPSRTCMR);
+
+	/* Enable RTC again */
+	writel(lp_cr | SNVS_LPCR_SRTC_ENV, ioaddr + SNVS_LPCR);
+	timeout = jiffies + msecs_to_jiffies(3000);
+	while (!(readl(ioaddr + SNVS_LPCR) & SNVS_LPCR_SRTC_ENV)) {
+		if (time_after(jiffies, timeout)) {
+			dev_err(dev, "timeout on enabling RTC back\n");
+			return -EBUSY;
+		}
+	}
+
+	rtc_write_sync_lp(ioaddr);
+
+	new_time_47bit = (((u64) (readl(ioaddr + SNVS_LPSRTCMR) &
+		((0x1 << CNTR_TO_SECS_SH) - 1)) << 32) |
+		((u64) readl(ioaddr + SNVS_LPSRTCLR)));
+
+	time_diff = new_time_47bit - old_time_47bit;
+
+	return 0;
+}
+
+/**
+ * snvs_rtc_read_data() - Read data from RTC
+ *
+ * @alrm: contains the RTC alarm value upon return
+ *
+ * Returns 0 if successful; non-zero otherwise.
+ *
+ * This function reads the current alarm value into the passed in \b alrm
+ * argument. It updates the \b alrm's pending field value based on the whether
+ * an alarm interrupt occurs or not.
+ */
+static int snvs_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct rtc_drv_data *pdata = dev_get_drvdata(dev);
+	void __iomem *ioaddr = pdata->ioaddr;
+
+	rtc_time_to_tm(readl(ioaddr + SNVS_LPTAR), &alrm->time);
+	alrm->pending =
+	    ((readl(ioaddr + SNVS_LPSR) & SNVS_LPSR_LPTA) != 0) ? 1 : 0;
+
+	return 0;
+}
+
+/**
+ * snvs_rtc_set_alarm() - This function sets the RTC alarm based on passed
+ *                        in alrm.
+ *
+ * @alrm: the alarm value to be set in the RTC
+ *
+ * Returns 0 if successful; non-zero otherwise.
+ */
+static int snvs_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct rtc_drv_data *pdata = dev_get_drvdata(dev);
+	void __iomem *ioaddr = pdata->ioaddr;
+	unsigned long lock_flags = 0;
+	u32 lp_cr;
+	int ret;
+
+	ret = rtc_valid_tm(&alrm->time);
+	if (ret)
+		return ret;
+
+	spin_lock_irqsave(&rtc_lock, lock_flags);
+
+	ret = rtc_update_alarm(dev, &alrm->time);
+	if (ret)
+		goto out;
+
+	lp_cr = readl(ioaddr + SNVS_LPCR);
+
+	if (alrm->enabled)
+		lp_cr |= (SNVS_LPCR_LPTA_EN | SNVS_LPCR_LPWUI_EN);
+	else
+		lp_cr &= ~(SNVS_LPCR_LPTA_EN | SNVS_LPCR_LPWUI_EN);
+
+	if (lp_cr & SNVS_LPCR_ALL_INT_EN) {
+		if (!pdata->irq_enable) {
+			enable_irq(pdata->irq);
+			pdata->irq_enable = true;
+		}
+	} else {
+		if (pdata->irq_enable) {
+			disable_irq(pdata->irq);
+			pdata->irq_enable = false;
+		}
+	}
+
+	writel(lp_cr, ioaddr + SNVS_LPCR);
+
+out:
+	rtc_write_sync_lp(ioaddr);
+	spin_unlock_irqrestore(&rtc_lock, lock_flags);
+
+	return ret;
+}
+
+/**
+ * snvs_rtc_proc() - provide /proc/driver/rtc file
+ *
+ * @seq:  buffer to hold the information that the driver wants to write
+ *
+ * Returns the number of bytes written into the rtc file.
+ *
+ * This function is used to provide the content for the /proc/driver/rtc
+ * file.
+ */
+static int snvs_rtc_proc(struct device *dev, struct seq_file *seq)
+{
+	struct rtc_drv_data *pdata = dev_get_drvdata(dev);
+	void __iomem *ioaddr = pdata->ioaddr;
+
+	seq_printf(seq, "alarm_IRQ\t: %s\n",
+		   (((readl(ioaddr + SNVS_LPCR)) & SNVS_LPCR_LPTA_EN) !=
+		    0) ? "yes" : "no");
+
+	return 0;
+}
+
+static int snvs_rtc_alarm_irq_enable(struct device *dev, unsigned int enable)
+{
+	struct rtc_drv_data *pdata = dev_get_drvdata(dev);
+	void __iomem *ioaddr = pdata->ioaddr;
+	u32 lp_cr;
+	unsigned long lock_flags = 0;
+
+	spin_lock_irqsave(&rtc_lock, lock_flags);
+
+	if (enable) {
+		if (!pdata->irq_enable) {
+			enable_irq(pdata->irq);
+			pdata->irq_enable = true;
+		}
+		lp_cr = readl(ioaddr + SNVS_LPCR);
+		lp_cr |= (SNVS_LPCR_LPTA_EN | SNVS_LPCR_LPWUI_EN);
+		writel(lp_cr, ioaddr + SNVS_LPCR);
+	} else {
+		lp_cr = readl(ioaddr + SNVS_LPCR);
+		lp_cr &= ~(SNVS_LPCR_LPTA_EN | SNVS_LPCR_LPWUI_EN);
+		if (((lp_cr & SNVS_LPCR_ALL_INT_EN) == 0)
+		    && (pdata->irq_enable)) {
+			disable_irq(pdata->irq);
+			pdata->irq_enable = false;
+		}
+		writel(lp_cr, ioaddr + SNVS_LPCR);
+	}
+
+	rtc_write_sync_lp(ioaddr);
+	spin_unlock_irqrestore(&rtc_lock, lock_flags);
+
+	return 0;
+}
+
+/* The RTC driver structure */
+static struct rtc_class_ops snvs_rtc_ops = {
+	.read_time = snvs_rtc_read_time,
+	.set_time = snvs_rtc_set_time,
+	.read_alarm = snvs_rtc_read_alarm,
+	.set_alarm = snvs_rtc_set_alarm,
+	.proc = snvs_rtc_proc,
+	.alarm_irq_enable = snvs_rtc_alarm_irq_enable,
+};
+
+/* SNVS RTC Power management control */
+static int __devinit snvs_rtc_probe(struct platform_device *pdev)
+{
+	struct timespec tv;
+	struct rtc_device *rtc;
+	struct rtc_drv_data *pdata = NULL;
+	void __iomem *ioaddr;
+	u32 lp_cr;
+	int ret = 0;
+
+	ioaddr = of_iomap(pdev->dev.of_node, 0);
+	if (!ioaddr)
+		return -EADDRNOTAVAIL;
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
+
+	pdata->ioaddr = ioaddr;
+
+	/* Configure and enable the RTC */
+	pdata->irq = platform_get_irq(pdev, 0);
+	if (pdata->irq >= 0) {
+		if (request_irq(pdata->irq, snvs_rtc_interrupt, IRQF_SHARED,
+				pdev->name, pdev) < 0) {
+			dev_warn(&pdev->dev, "interrupt not available.\n");
+			pdata->irq = -1;
+		} else {
+			disable_irq(pdata->irq);
+			pdata->irq_enable = false;
+		}
+	}
+
+	/* initialize glitch detect */
+	writel(SNVS_LPPGDR_INIT, ioaddr + SNVS_LPPGDR);
+	udelay(100);
+
+	/* clear lp interrupt status */
+	writel(0xFFFFFFFF, ioaddr + SNVS_LPSR);
+
+	/* Enable RTC */
+	lp_cr = readl(ioaddr + SNVS_LPCR);
+	if ((lp_cr & SNVS_LPCR_SRTC_ENV) == 0)
+		writel(lp_cr | SNVS_LPCR_SRTC_ENV, ioaddr + SNVS_LPCR);
+	udelay(100);
+
+	writel(0xFFFFFFFF, ioaddr + SNVS_LPSR);
+	udelay(100);
+
+	platform_set_drvdata(pdev, pdata);
+
+	rtc = rtc_device_register(pdev->name, &pdev->dev,
+				  &snvs_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc)) {
+		ret = PTR_ERR(rtc);
+		goto err_out;
+	}
+
+	pdata->rtc = rtc;
+
+	tv.tv_nsec = 0;
+	tv.tv_sec = rtc_read_lp_counter(ioaddr);
+
+	/* By default, devices should wakeup if they can */
+	/* So snvs is set as "should wakeup" as it can */
+	device_init_wakeup(&pdev->dev, 1);
+
+	return ret;
+
+err_out:
+	iounmap(ioaddr);
+	if (pdata->irq >= 0)
+		free_irq(pdata->irq, pdev);
+
+	return ret;
+}
+
+static int __devexit snvs_rtc_remove(struct platform_device *pdev)
+{
+	struct rtc_drv_data *pdata = platform_get_drvdata(pdev);
+	rtc_device_unregister(pdata->rtc);
+	if (pdata->irq >= 0)
+		free_irq(pdata->irq, pdev);
+	iounmap(pdata->ioaddr);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+/**
+ * snvs_rtc_suspend() - handling suspend
+ *
+ * @pdev: device descriptor
+ * @state: power state to enter.
+ *
+ * The function always returns 0.
+ *
+ * This function is called to save the system time delta relative to
+ * the SNVS RTC when enterring a low power state. This time delta is
+ * then used on resume to adjust the system time to account for time
+ * loss while suspended.
+ */
+static int snvs_rtc_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct rtc_drv_data *pdata = platform_get_drvdata(pdev);
+
+	if (device_may_wakeup(&pdev->dev)) {
+		enable_irq_wake(pdata->irq);
+	} else {
+		if (pdata->irq_enable)
+			disable_irq(pdata->irq);
+	}
+
+	return 0;
+}
+
+/**
+ * snvs_rtc_resume() - handling resume
+ *
+ * @pdev: device descriptor
+ *
+ * The function always returns 0.
+ *
+ * This function is called to correct the system time based on the
+ * current SNVS RTC time relative to the time delta saved during
+ * suspend.
+ */
+static int snvs_rtc_resume(struct platform_device *pdev)
+{
+	struct rtc_drv_data *pdata = platform_get_drvdata(pdev);
+
+	if (device_may_wakeup(&pdev->dev)) {
+		disable_irq_wake(pdata->irq);
+	} else {
+		if (pdata->irq_enable)
+			enable_irq(pdata->irq);
+	}
+
+	return 0;
+}
+#endif
+
+static const struct of_device_id __devinitdata snvs_dt_ids[] = {
+	{ .compatible = "fsl,snvs-rtc" },
+	{ /* sentinel */ }
+};
+
+/* Contains pointers to the power management callback functions. */
+static struct platform_driver snvs_rtc_driver = {
+	.driver = {
+		.name	= "snvs_rtc",
+		.owner	= THIS_MODULE,
+		.of_match_table = snvs_dt_ids,
+	},
+	.probe = snvs_rtc_probe,
+	.remove = __exit_p(snvs_rtc_remove),
+#ifdef CONFIG_PM
+	.suspend = snvs_rtc_suspend,
+	.resume = snvs_rtc_resume,
+#endif
+};
+
+module_platform_driver(snvs_rtc_driver);
+
+MODULE_AUTHOR("Anish Trivedi <anish@freescale.com>, "
+	      "Eric Miao <eric.miao@linaro.org>, "
+	      "Anson Huang <b20788@freescale.com>, "
+	      "Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>");
+MODULE_DESCRIPTION("SNVS Realtime Clock Driver (RTC)");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:snvs-rtc");
-- 
1.7.9.5

