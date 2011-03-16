Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab1CPCEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 22:04:50 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:51057 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab1CPCEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 22:04:49 -0400
Date: Wed, 16 Mar 2011 10:39:11 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v6 2/2] MAX8997/8966 RTC Driver Initial Release
In-reply-to: <1300239551-21285-1-git-send-email-myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>, Joe Perches <joe@perches.com>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Message-id: <1300239551-21285-3-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
References: <1300239551-21285-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 16 Mar 2011 01:39:11.0961 (UTC)
 FILETIME=[F36B6C90:01CBE37A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for RTC functionality for MAX8997/8966 chips.

The 16ms delay is somehow required by MAX8997 chips (at least for the
initial releases) and it can be enabled by .delay in platform_data.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/rtc/Kconfig         |   10 +
 drivers/rtc/Makefile        |    1 +
 drivers/rtc/rtc-max8997.c   |  476 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/max8997.h |    5 +-
 4 files changed, 491 insertions(+), 1 deletions(-)
 create mode 100644 drivers/rtc/rtc-max8997.c

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 4941cad..8dc93e8 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -196,6 +196,16 @@ config RTC_DRV_MAX8925
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-max8925.
 
+config RTC_DRV_MAX8997
+	tristate "Maxim MAX8997/8966"
+	depends on MFD_MAX8997
+	help
+	  If you say yes here you will get support for the
+	  RTC of Maxim MAX8997 and MAX8966 PMIC.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-max8997.
+
 config RTC_DRV_MAX8998
 	tristate "Maxim MAX8998"
 	depends on MFD_MAX8998
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 2afdaf3..8b74d41 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -61,6 +61,7 @@ obj-$(CONFIG_RTC_DRV_M48T86)	+= rtc-m48t86.o
 obj-$(CONFIG_RTC_MXC)		+= rtc-mxc.o
 obj-$(CONFIG_RTC_DRV_MAX6900)	+= rtc-max6900.o
 obj-$(CONFIG_RTC_DRV_MAX8925)	+= rtc-max8925.o
+obj-$(CONFIG_RTC_DRV_MAX8997)	+= rtc-max8997.o
 obj-$(CONFIG_RTC_DRV_MAX8998)	+= rtc-max8998.o
 obj-$(CONFIG_RTC_DRV_MAX6902)	+= rtc-max6902.o
 obj-$(CONFIG_RTC_DRV_MC13XXX)	+= rtc-mc13xxx.o
diff --git a/drivers/rtc/rtc-max8997.c b/drivers/rtc/rtc-max8997.c
new file mode 100644
index 0000000..b1a4b66
--- /dev/null
+++ b/drivers/rtc/rtc-max8997.c
@@ -0,0 +1,476 @@
+/*
+ * rtc-max8997.c - RTC driver for Maxim 8966 and 8997
+ *
+ * Copyright (C) 2011 Samsung Electronics
+ * MyungJoo Ham <myungjoo.ham@samsung.com>
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <linux/bcd.h>
+#include <linux/delay.h>
+#include <linux/mutex.h>
+#include <linux/printk.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/rtc.h>
+#include <linux/mfd/max8997.h>
+#include <linux/mfd/max8997-private.h>
+
+/* Allow RTC Update */
+#define MAX8997_RTC_UPDATE1_ENABLE_UPDATE	(1 << 0)
+/*
+ * Set Interrupt Mode (about how the interrupt is cleared.)
+ * Set the bit in order to let inetrrupt be cleared with register read
+ * Unset the bit in order to let it be cleared by writing 0.
+ */
+#define MAX8997_RTC_UPDATE1_INT_READ_CLEAR	(1 << 1)
+
+/* Mode between BCD(1) and Binary(0) */
+#define MAX8997_RTC_CTRL_BCD			(1 << 0)
+/* Mode between 24hrs(1) and 12hrs(0) */
+#define MAX8997_RTC_CTRL_Mode24_12		(1 << 1)
+
+struct rtc_data {
+	struct mutex		lock;
+	struct i2c_client	*i2c;
+	struct max8997_dev	*iodev;
+
+	struct device		*dev;
+	struct rtc_device	*rtc_dev;
+
+	int irq;
+	bool delay;
+};
+
+enum {
+	RTC_SEC = 0,
+	RTC_MIN,
+	RTC_HOUR,
+	RTC_WEEKDAY,
+	RTC_MONTH,
+	RTC_YEAR,
+	RTC_MONTHDAY,
+	RTC_DATA_SIZE,
+};
+
+static inline int wday_8997_to_kernel(u8 shifted)
+{
+	int counter = -1;
+	while (shifted) {
+		shifted >>= 1;
+		counter++;
+	}
+	return counter;
+}
+
+static void __maybe_unused dump(struct rtc_data *rtc)
+{
+	int i;
+	u8 buf[48];
+
+	for (i = 0; i < 48; i++)
+		max8997_read_reg(rtc->i2c, i, &buf[i]);
+	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET, 16, 1,
+			buf, sizeof(buf), false);
+}
+
+static inline u8 wday_kernel_to_8997(u8 wday)
+{
+	return 1 << wday;
+}
+
+static void data_to_tm(u8 *data, struct rtc_time *tm)
+{
+	/* Binary Mode (not BCD) */
+	tm->tm_sec = bcd2bin(data[RTC_SEC] & 0x7f);
+	tm->tm_min = bcd2bin(data[RTC_MIN] & 0x7f);
+	tm->tm_hour = bcd2bin(data[RTC_HOUR] & 0x3f); /* 24 hour mode */
+	tm->tm_wday = wday_8997_to_kernel(data[RTC_WEEKDAY] & 0x7f);
+	tm->tm_mon = bcd2bin(data[RTC_MONTH] & 0x1f) - 1;
+	tm->tm_year = bcd2bin(data[RTC_YEAR] & 0x7f) + 100;
+	tm->tm_mday = bcd2bin(data[RTC_MONTHDAY] & 0x3f);
+	tm->tm_yday = 0;
+	tm->tm_isdst = 0;
+}
+
+static int tm_to_data(struct rtc_time *tm, u8 *data)
+{
+	data[RTC_SEC] = bin2bcd(tm->tm_sec) & 0x7f;
+	data[RTC_MIN] = bin2bcd(tm->tm_min) & 0x7f;
+	data[RTC_HOUR] = bin2bcd(tm->tm_hour) & 0x3f;
+	data[RTC_WEEKDAY] = wday_kernel_to_8997(tm->tm_wday) & 0x7f;
+	data[RTC_MONTH] = bin2bcd(tm->tm_mon + 1) & 0x1f;
+	data[RTC_YEAR] = bin2bcd((tm->tm_year > 100) ? (tm->tm_year - 100) : 0)
+			& 0x7f;
+	data[RTC_MONTHDAY] = bin2bcd(tm->tm_mday) & 0x3f;
+
+	/* MAX8997 RTC cannot deal with years prior to 2000 */
+	if (tm->tm_year < 100) {
+		pr_err("MAX8997 RTC cannot handle the year %d. "
+				"Assume it's 2000.\n", 1900 + tm->tm_year);
+		return -EINVAL;
+	} else {
+		return 0;
+	}
+}
+
+static int max8997_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct rtc_data *rtc = dev_get_drvdata(dev);
+	u8 data[RTC_DATA_SIZE];
+	int ret;
+
+	mutex_lock(&rtc->lock);
+	ret = max8997_bulk_read(rtc->i2c, MAX8997_RTC_SEC, RTC_DATA_SIZE, data);
+	mutex_unlock(&rtc->lock);
+
+	if (ret < 0)
+		return ret;
+
+	data_to_tm(data, tm);
+
+	return rtc_valid_tm(tm);
+}
+
+static int max8997_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct rtc_data *rtc = dev_get_drvdata(dev);
+	u8 data[RTC_DATA_SIZE];
+	int ret;
+
+	ret = tm_to_data(tm, data);
+	if (ret)
+		return ret;
+
+	mutex_lock(&rtc->lock);
+
+	/* Allow RTC Update */
+	max8997_write_reg(rtc->i2c, MAX8997_RTC_UPDATE1,
+			MAX8997_RTC_UPDATE1_ENABLE_UPDATE |
+			MAX8997_RTC_UPDATE1_INT_READ_CLEAR);
+
+	ret = max8997_bulk_write(rtc->i2c, MAX8997_RTC_SEC,
+				RTC_DATA_SIZE, data);
+
+	if (rtc->delay)
+		msleep(20);
+
+	mutex_unlock(&rtc->lock);
+
+	return ret;
+}
+
+static int max8997_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct rtc_data *rtc = dev_get_drvdata(dev);
+	u8 data[RTC_DATA_SIZE];
+	u8 val;
+	int i;
+	int ret;
+
+	mutex_lock(&rtc->lock);
+	ret = max8997_bulk_read(rtc->i2c, MAX8997_RTC_ALARM1_SEC,
+				RTC_DATA_SIZE, data);
+
+	if (ret < 0)
+		goto exit;
+
+	data_to_tm(data, &alrm->time);
+
+	alrm->enabled = 0;
+	for (i = 0; i < RTC_DATA_SIZE; i++)
+		if (data[i] & (1 << 7)) {
+			alrm->enabled = 1;
+			break;
+		}
+
+	alrm->pending = 0;
+	ret = max8997_read_reg(rtc->iodev->i2c, MAX8997_REG_STATUS1, &val);
+	if (val & (1 << 4)) /* "RTCA1" */
+		alrm->pending = 1;
+exit:
+	mutex_unlock(&rtc->lock);
+	return ret;
+}
+
+static int max8997_rtc_start_alarm(struct rtc_data *rtc)
+{
+	u8 data[RTC_DATA_SIZE];
+	int ret;
+
+	/* Should be locked before entering here */
+	if (!mutex_is_locked(&rtc->lock))
+		dev_warn(rtc->dev, "%s should have mutex locked.\n", __func__);
+
+	ret = max8997_bulk_read(rtc->i2c, MAX8997_RTC_ALARM1_SEC,
+				RTC_DATA_SIZE, data);
+	if (rtc < 0)
+		goto exit;
+
+	data[RTC_SEC] |= (1 << 7);
+	data[RTC_MIN] |= (1 << 7);
+	data[RTC_HOUR] |= (1 << 7);
+	data[RTC_WEEKDAY] &= ~(1 << 7);
+	if (data[RTC_MONTH] & 0x1f)
+		data[RTC_MONTH] |= (1 << 7);
+	if (data[RTC_YEAR] & 0x7f)
+		data[RTC_YEAR] |= (1 << 7);
+	if (data[RTC_MONTHDAY] & 0x3f)
+		data[RTC_MONTHDAY] |= (1 << 7);
+
+	/* Allow RTC Update */
+	max8997_write_reg(rtc->i2c, MAX8997_RTC_UPDATE1,
+			MAX8997_RTC_UPDATE1_ENABLE_UPDATE |
+			MAX8997_RTC_UPDATE1_INT_READ_CLEAR);
+
+	ret = max8997_bulk_write(rtc->i2c, MAX8997_RTC_ALARM1_SEC,
+				RTC_DATA_SIZE, data);
+	if (ret < 0)
+		goto exit;
+	if (rtc->delay)
+		msleep(20);
+
+exit:
+	return ret;
+}
+
+static int max8997_rtc_stop_alarm(struct rtc_data *rtc)
+{
+	u8 data[RTC_DATA_SIZE];
+	int ret;
+	int i;
+
+	/* Should be locked before entering here */
+	if (!mutex_is_locked(&rtc->lock))
+		dev_warn(rtc->dev, "%s should have mutex locked.\n", __func__);
+
+	ret = max8997_bulk_read(rtc->i2c, MAX8997_RTC_ALARM1_SEC,
+				RTC_DATA_SIZE, data);
+	if (rtc < 0)
+		goto exit;
+
+	for (i = 0; i < RTC_DATA_SIZE; i++)
+		data[i] &= ~(1 << 7);
+
+	/* Allow RTC Update */
+	max8997_write_reg(rtc->i2c, MAX8997_RTC_UPDATE1,
+			MAX8997_RTC_UPDATE1_ENABLE_UPDATE |
+			MAX8997_RTC_UPDATE1_INT_READ_CLEAR);
+
+	ret = max8997_bulk_write(rtc->i2c, MAX8997_RTC_ALARM1_SEC,
+				RTC_DATA_SIZE, data);
+	if (ret < 0)
+		goto exit;
+	if (rtc->delay)
+		msleep(20);
+
+exit:
+	return ret;
+}
+
+static int max8997_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct rtc_data *rtc = dev_get_drvdata(dev);
+	u8 data[RTC_DATA_SIZE];
+	int ret;
+
+	ret = tm_to_data(&alrm->time, data);
+	if (ret)
+		return ret;
+
+	mutex_lock(&rtc->lock);
+	ret = max8997_rtc_stop_alarm(rtc);
+	if (ret < 0)
+		goto exit;
+
+	if (alrm->enabled) {
+		data[RTC_SEC] |= (1 << 7);
+		data[RTC_MIN] |= (1 << 7);
+		data[RTC_HOUR] |= (1 << 7);
+		data[RTC_WEEKDAY] &= ~(1 << 7);
+		if (data[RTC_MONTH] & 0x1f)
+			data[RTC_MONTH] |= (1 << 7);
+		if (data[RTC_YEAR] & 0x7f)
+			data[RTC_YEAR] |= (1 << 7);
+		if (data[RTC_MONTHDAY] & 0x3f)
+			data[RTC_MONTHDAY] |= (1 << 7);
+	}
+
+	/* Allow RTC Update */
+	max8997_write_reg(rtc->i2c, MAX8997_RTC_UPDATE1,
+			MAX8997_RTC_UPDATE1_ENABLE_UPDATE |
+			MAX8997_RTC_UPDATE1_INT_READ_CLEAR);
+
+	ret = max8997_bulk_write(rtc->i2c, MAX8997_RTC_ALARM1_SEC,
+				RTC_DATA_SIZE, data);
+	if (ret < 0)
+		goto exit;
+	if (rtc->delay)
+		msleep(20);
+
+exit:
+	mutex_unlock(&rtc->lock);
+	return ret;
+}
+
+static int max8997_rtc_alarm_irq_enable(struct device *dev,
+					unsigned int enabled)
+{
+	struct rtc_data *rtc = dev_get_drvdata(dev);
+	int ret;
+
+	mutex_lock(&rtc->lock);
+	if (enabled)
+		ret = max8997_rtc_start_alarm(rtc);
+	else
+		ret = max8997_rtc_stop_alarm(rtc);
+	mutex_unlock(&rtc->lock);
+
+	return ret;
+}
+
+static irqreturn_t max8997_rtc_alarm_irq(int irq, void *data)
+{
+	struct rtc_data *rtc = data;
+
+	rtc_update_irq(rtc->rtc_dev, 1, RTC_IRQF | RTC_AF);
+
+	return IRQ_HANDLED;
+}
+
+static const struct rtc_class_ops max8997_rtc_ops = {
+	.read_time		= max8997_rtc_read_time,
+	.set_time		= max8997_rtc_set_time,
+	.read_alarm		= max8997_rtc_read_alarm,
+	.set_alarm		= max8997_rtc_set_alarm,
+	.alarm_irq_enable	= max8997_rtc_alarm_irq_enable,
+};
+
+static __devinit int rtc_probe(struct platform_device *pdev)
+{
+	struct max8997_dev *iodev = dev_get_drvdata(pdev->dev.parent);
+	struct max8997_platform_data *pdata = dev_get_platdata(iodev->dev);
+	struct rtc_data *rtc;
+	int ret = 0;
+	u8 val;
+
+	if (!pdata) {
+		dev_err(pdev->dev.parent, "No platform init data supplied.\n");
+		return -ENODEV;
+	}
+
+	rtc = kzalloc(sizeof(struct rtc_data), GFP_KERNEL);
+	if (!rtc)
+		return -ENOMEM;
+
+	mutex_init(&rtc->lock);
+	mutex_lock(&rtc->lock);
+	rtc->i2c = iodev->rtc;
+	rtc->dev = &pdev->dev;
+	rtc->iodev = iodev;
+	rtc->irq = iodev->irq_base + MAX8997_PMICIRQ_RTCA1;
+
+	if (pdata->delay)
+		rtc->delay = true;
+
+	platform_set_drvdata(pdev, rtc);
+
+	val = MAX8997_RTC_CTRL_BCD |
+		MAX8997_RTC_CTRL_Mode24_12;
+	max8997_write_reg(rtc->i2c, MAX8997_RTC_CTRLMASK, val);
+
+	val = MAX8997_RTC_CTRL_BCD |
+		MAX8997_RTC_CTRL_Mode24_12;
+	max8997_write_reg(rtc->i2c, MAX8997_RTC_CTRL, val);
+
+	/* Allow RTC Update */
+	val = MAX8997_RTC_UPDATE1_ENABLE_UPDATE |
+		MAX8997_RTC_UPDATE1_INT_READ_CLEAR;
+	max8997_write_reg(rtc->i2c, MAX8997_RTC_UPDATE1, val);
+
+	if (pdata->wakeup)
+		device_init_wakeup(&pdev->dev, 1);
+
+	rtc->rtc_dev = rtc_device_register("max8997-rtc", &pdev->dev,
+			&max8997_rtc_ops, THIS_MODULE);
+	if (IS_ERR_OR_NULL(rtc->rtc_dev)) {
+		ret = PTR_ERR(rtc->rtc_dev);
+
+		dev_err(&pdev->dev, "Failed to register RTC device: %d\n", ret);
+		if (ret == 0)
+			ret = -EINVAL;
+		goto err;
+	}
+
+	ret = request_threaded_irq(rtc->irq, NULL, max8997_rtc_alarm_irq, 0,
+			"max8997-rtc-alarm1", rtc);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to request alarm IRQ %d (%d)\n",
+				rtc->irq, ret);
+		goto err;
+	}
+
+	goto exit;
+err:
+	kfree(rtc);
+exit:
+	mutex_unlock(&rtc->lock);
+	return ret;
+}
+
+static __devexit int rtc_remove(struct platform_device *pdev)
+{
+	struct rtc_data *rtc = platform_get_drvdata(pdev);
+
+	rtc_device_unregister(rtc->rtc_dev);
+	free_irq(rtc->irq, rtc);
+	kfree(rtc);
+
+	return 0;
+}
+
+static const struct platform_device_id rtc_id[] = {
+	{ "max8997-rtc", 0 },
+	{ },
+};
+
+static struct platform_driver max8997_rtc_driver = {
+	.driver = {
+		.name = "max8997-rtc",
+		.owner = THIS_MODULE,
+	},
+	.probe = rtc_probe,
+	.remove = __devexit_p(rtc_remove),
+	.id_table = rtc_id,
+};
+
+static int __init max8997_rtc_init(void)
+{
+	return platform_driver_register(&max8997_rtc_driver);
+}
+subsys_initcall(max8997_rtc_init);
+
+static void __exit max8997_rtc_cleanup(void)
+{
+	platform_driver_unregister(&max8997_rtc_driver);
+}
+module_exit(max8997_rtc_cleanup);
+
+MODULE_DESCRIPTION("MAXIM 8997/8966 RTC Driver");
+MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:max8997-rtc");
diff --git a/include/linux/mfd/max8997.h b/include/linux/mfd/max8997.h
index 60931d0..83f39b7 100644
--- a/include/linux/mfd/max8997.h
+++ b/include/linux/mfd/max8997.h
@@ -109,7 +109,10 @@ struct max8997_platform_data {
 
 	/* MUIC: Not implemented */
 	/* HAPTIC: Not implemented */
-	/* RTC: Not implemented */
+
+	/* ---- RTC ---- */
+	bool delay; /* The MAX8997 RTC write delay is requred. */
+
 	/* Flash: Not implemented */
 	/* Charger control: Not implemented */
 };
-- 
1.7.1

