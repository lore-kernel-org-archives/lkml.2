Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab1DROKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:10:14 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:58187 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab1DROJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:09:42 -0400
X-ASG-Debug-ID: 1303135781-082c703b0001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        a.zummo@towertech.it, johnpol@2ka.mipt.ru, cbou@mail.ru,
        dwmw2@infradead.org, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
X-ASG-Orig-Subj: [PATCH 03/14] rtc: add 88pm860x rtc
Subject: [PATCH 03/14] rtc: add 88pm860x rtc
Date: Mon, 18 Apr 2011 22:04:00 +0800
X-ASG-Orig-Subj: [PATCH 03/14] rtc: add 88pm860x rtc
Message-Id: <1303135451-26362-4-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <2011041801>
References: <2011041801>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1303135781
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support RTC component in 88PM860x. Also support synchronize time from
88PM860x RTC to another RTC device. It should be implemented in
sync callback API.

While 88PM860x RTC is enabled, it can do RTC calibration to gurantee
enough power is supplied on VRTC domain of 88PM860x.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
---
 drivers/mfd/88pm860x-core.c  |   31 +++
 drivers/rtc/Kconfig          |   10 +
 drivers/rtc/Makefile         |    1 +
 drivers/rtc/rtc-88pm860x.c   |  426 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/88pm860x.h |    6 +
 5 files changed, 474 insertions(+), 0 deletions(-)
 create mode 100644 drivers/rtc/rtc-88pm860x.c

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index b03cdd3..f114ec7 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -57,6 +57,10 @@ static struct resource regulator_resources[] __initdata = {
 	{PM8607_ID_LDO15, PM8607_ID_LDO15, "ldo-15", IORESOURCE_IO,},
 };
 
+static struct resource rtc_resources[] __devinitdata = {
+	{PM8607_IRQ_RTC, PM8607_IRQ_RTC, "rtc", IORESOURCE_IRQ,},
+};
+
 static struct resource touch_resources[] __initdata = {
 	{PM8607_IRQ_PEN, PM8607_IRQ_PEN, "touch", IORESOURCE_IRQ,},
 };
@@ -126,6 +130,10 @@ static struct mfd_cell regulator_devs[] __initdata = {
 	{"88pm860x-regulator", 17,},
 };
 
+static struct mfd_cell rtc_devs[] = {
+	{"88pm860x-rtc", -1,},
+};
+
 static struct mfd_cell touch_devs[] __initdata = {
 	{"88pm860x-touch", -1,},
 };
@@ -148,6 +156,7 @@ static struct pm860x_led_pdata led_pdata[ARRAY_SIZE(led_devs)];
 static struct regulator_init_data regulator_pdata[ARRAY_SIZE(regulator_devs)];
 static struct pm860x_touch_pdata touch_pdata;
 static struct pm860x_power_pdata power_pdata;
+static struct pm860x_rtc_pdata rtc_pdata;
 
 struct pm860x_irq_data {
 	int	reg;
@@ -588,6 +597,27 @@ out:
 	return;
 }
 
+static void __devinit device_rtc_init(struct pm860x_chip *chip,
+				      struct i2c_client *i2c,
+				      struct pm860x_platform_data *pdata)
+{
+	int ret;
+
+	if ((pdata == NULL) || (pdata->rtc == NULL))
+		return;
+
+	memcpy(&rtc_pdata, pdata->rtc, sizeof(struct pm860x_rtc_pdata));
+	rtc_devs[0].platform_data = &rtc_pdata;
+	rtc_devs[0].pdata_size = sizeof(rtc_pdata);
+	rtc_devs[0].num_resources = ARRAY_SIZE(rtc_resources);
+	rtc_devs[0].resources = &rtc_resources[0];
+	ret = mfd_add_devices(chip->dev, 0, &rtc_devs[0],
+			      ARRAY_SIZE(rtc_devs), &rtc_resources[0],
+			      chip->irq_base);
+	if (ret < 0)
+		dev_err(chip->dev, "Failed to add rtc subdev\n");
+}
+
 static void __devinit device_touch_init(struct pm860x_chip *chip,
 					struct i2c_client *i2c,
 					struct pm860x_platform_data *pdata)
@@ -719,6 +749,7 @@ static void __devinit device_8607_init(struct pm860x_chip *chip,
 		goto out;
 
 	device_regulator_init(chip, i2c, pdata);
+	device_rtc_init(chip, i2c, pdata);
 	device_onkey_init(chip, i2c, pdata);
 	device_touch_init(chip, i2c, pdata);
 	device_power_init(chip, i2c, pdata);
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index e187887..286f51e 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -128,6 +128,16 @@ comment "I2C RTC drivers"
 
 if I2C
 
+config RTC_DRV_88PM860X
+	tristate "Marvell 88PM860x"
+	depends on RTC_CLASS && I2C && MFD_88PM860X
+	help
+	  If you say yes here you get support for RTC function in Marvell
+	  88PM860x chips.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-88pm860x.
+
 config RTC_DRV_DS1307
 	tristate "Dallas/Maxim DS1307/37/38/39/40, ST M41T00, EPSON RX-8025"
 	help
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index ca91c3c..e3d6fb0 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -15,6 +15,7 @@ rtc-core-$(CONFIG_RTC_INTF_SYSFS) += rtc-sysfs.o
 
 # Keep the list ordered.
 
+obj-$(CONFIG_RTC_DRV_88PM860X)  += rtc-88pm860x.o
 obj-$(CONFIG_RTC_DRV_AB3100)	+= rtc-ab3100.o
 obj-$(CONFIG_RTC_DRV_AB8500)	+= rtc-ab8500.o
 obj-$(CONFIG_RTC_DRV_AT32AP700X)+= rtc-at32ap700x.o
diff --git a/drivers/rtc/rtc-88pm860x.c b/drivers/rtc/rtc-88pm860x.c
new file mode 100644
index 0000000..864e6c4
--- /dev/null
+++ b/drivers/rtc/rtc-88pm860x.c
@@ -0,0 +1,426 @@
+/*
+ * Real Time Clock driver for Marvell 88PM860x PMIC
+ *
+ * Copyright (c) 2010 Marvell International Ltd.
+ * Author:	Haojian Zhuang <haojian.zhuang@marvell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/rtc.h>
+#include <linux/delay.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/88pm860x.h>
+
+#define VRTC_CALIBRATION
+
+struct pm860x_rtc_info {
+	struct pm860x_chip	*chip;
+	struct i2c_client	*i2c;
+	struct rtc_device	*rtc_dev;
+	struct device		*dev;
+	struct delayed_work	calib_work;
+
+	int			irq;
+	int			vrtc;
+	int			(*sync)(unsigned int ticks);
+};
+
+#define REG_VRTC_MEAS1		0x7D
+
+#define REG0_ADDR		0xB0
+#define REG1_ADDR		0xB2
+#define REG2_ADDR		0xB4
+#define REG3_ADDR		0xB6
+
+#define REG0_DATA		0xB1
+#define REG1_DATA		0xB3
+#define REG2_DATA		0xB5
+#define REG3_DATA		0xB7
+
+/* bit definitions of Measurement Enable Register 2 (0x51) */
+#define MEAS2_VRTC		(1 << 0)
+
+/* bit definitions of RTC Register 1 (0xA0) */
+#define ALARM_EN		(1 << 3)
+#define ALARM_WAKEUP		(1 << 4)
+#define ALARM			(1 << 5)
+#define RTC1_USE_XO		(1 << 7)
+
+#define VRTC_CALIB_INTERVAL	(HZ * 60 * 10)		/* 10 minutes */
+
+static irqreturn_t rtc_update_handler(int irq, void *data)
+{
+	struct pm860x_rtc_info *info = (struct pm860x_rtc_info *)data;
+	int mask;
+
+	mask = ALARM | ALARM_WAKEUP;
+	pm860x_set_bits(info->i2c, PM8607_RTC1, mask | ALARM_EN, mask);
+	rtc_update_irq(info->rtc_dev, 1, RTC_AF);
+	return IRQ_HANDLED;
+}
+
+static int pm860x_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct pm860x_rtc_info *info = dev_get_drvdata(dev);
+
+	if (enabled)
+		pm860x_set_bits(info->i2c, PM8607_RTC1, ALARM, ALARM);
+	else
+		pm860x_set_bits(info->i2c, PM8607_RTC1, ALARM, 0);
+	return 0;
+}
+
+/*
+ * Calculate the next alarm time given the requested alarm time mask
+ * and the current time.
+ */
+static void rtc_next_alarm_time(struct rtc_time *next, struct rtc_time *now,
+				struct rtc_time *alrm)
+{
+	unsigned long next_time;
+	unsigned long now_time;
+
+	next->tm_year = now->tm_year;
+	next->tm_mon = now->tm_mon;
+	next->tm_mday = now->tm_mday;
+	next->tm_hour = alrm->tm_hour;
+	next->tm_min = alrm->tm_min;
+	next->tm_sec = alrm->tm_sec;
+
+	rtc_tm_to_time(now, &now_time);
+	rtc_tm_to_time(next, &next_time);
+
+	if (next_time < now_time) {
+		/* Advance one day */
+		next_time += 60 * 60 * 24;
+		rtc_time_to_tm(next_time, next);
+	}
+}
+
+static int pm860x_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct pm860x_rtc_info *info = dev_get_drvdata(dev);
+	unsigned char buf[8];
+	unsigned long ticks, base, data;
+
+	pm860x_page_bulk_read(info->i2c, REG0_ADDR, 8, buf);
+	dev_dbg(info->dev, "%x-%x-%x-%x-%x-%x-%x-%x\n", buf[0], buf[1],
+		buf[2], buf[3], buf[4], buf[5], buf[6], buf[7]);
+	base = (buf[1] << 24) | (buf[3] << 16) | (buf[5] << 8) | buf[7];
+
+	/* load 32-bit read-only counter */
+	pm860x_bulk_read(info->i2c, PM8607_RTC_COUNTER1, 4, buf);
+	data = (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	ticks = base + data;
+	dev_dbg(info->dev, "get base:0x%lx, RO count:0x%lx, ticks:0x%lx\n",
+		base, data, ticks);
+
+	rtc_time_to_tm(ticks, tm);
+
+	return 0;
+}
+
+static int pm860x_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct pm860x_rtc_info *info = dev_get_drvdata(dev);
+	unsigned char buf[4];
+	unsigned long ticks, base, data;
+
+	if ((tm->tm_year < 70) || (tm->tm_year > 138)) {
+		dev_dbg(info->dev, "Set time %d out of range. "
+			"Please set time between 1970 to 2038.\n",
+			1900 + tm->tm_year);
+		return -EINVAL;
+	}
+	rtc_tm_to_time(tm, &ticks);
+
+	/* load 32-bit read-only counter */
+	pm860x_bulk_read(info->i2c, PM8607_RTC_COUNTER1, 4, buf);
+	data = (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	base = ticks - data;
+	dev_dbg(info->dev, "set base:0x%lx, RO count:0x%lx, ticks:0x%lx\n",
+		base, data, ticks);
+
+	pm860x_page_reg_write(info->i2c, REG0_DATA, (base >> 24) & 0xFF);
+	pm860x_page_reg_write(info->i2c, REG1_DATA, (base >> 16) & 0xFF);
+	pm860x_page_reg_write(info->i2c, REG2_DATA, (base >> 8) & 0xFF);
+	pm860x_page_reg_write(info->i2c, REG3_DATA, base & 0xFF);
+
+	if (info->sync)
+		info->sync(ticks);
+	return 0;
+}
+
+static int pm860x_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct pm860x_rtc_info *info = dev_get_drvdata(dev);
+	unsigned char buf[8];
+	unsigned long ticks, base, data;
+	int ret;
+
+	pm860x_page_bulk_read(info->i2c, REG0_ADDR, 8, buf);
+	dev_dbg(info->dev, "%x-%x-%x-%x-%x-%x-%x-%x\n", buf[0], buf[1],
+		buf[2], buf[3], buf[4], buf[5], buf[6], buf[7]);
+	base = (buf[1] << 24) | (buf[3] << 16) | (buf[5] << 8) | buf[7];
+
+	pm860x_bulk_read(info->i2c, PM8607_RTC_EXPIRE1, 4, buf);
+	data = (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	ticks = base + data;
+	dev_dbg(info->dev, "get base:0x%lx, RO count:0x%lx, ticks:0x%lx\n",
+		base, data, ticks);
+
+	rtc_time_to_tm(ticks, &alrm->time);
+	ret = pm860x_reg_read(info->i2c, PM8607_RTC1);
+	alrm->enabled = (ret & ALARM_EN) ? 1 : 0;
+	alrm->pending = (ret & (ALARM | ALARM_WAKEUP)) ? 1 : 0;
+	return 0;
+}
+
+static int pm860x_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct pm860x_rtc_info *info = dev_get_drvdata(dev);
+	struct rtc_time now_tm, alarm_tm;
+	unsigned long ticks, base, data;
+	unsigned char buf[8];
+	int mask;
+
+	pm860x_set_bits(info->i2c, PM8607_RTC1, ALARM_EN, 0);
+
+	pm860x_page_bulk_read(info->i2c, REG0_ADDR, 8, buf);
+	dev_dbg(info->dev, "%x-%x-%x-%x-%x-%x-%x-%x\n", buf[0], buf[1],
+		buf[2], buf[3], buf[4], buf[5], buf[6], buf[7]);
+	base = (buf[1] << 24) | (buf[3] << 16) | (buf[5] << 8) | buf[7];
+
+	/* load 32-bit read-only counter */
+	pm860x_bulk_read(info->i2c, PM8607_RTC_COUNTER1, 4, buf);
+	data = (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	ticks = base + data;
+	dev_dbg(info->dev, "get base:0x%lx, RO count:0x%lx, ticks:0x%lx\n",
+		base, data, ticks);
+
+	rtc_time_to_tm(ticks, &now_tm);
+	rtc_next_alarm_time(&alarm_tm, &now_tm, &alrm->time);
+	/* get new ticks for alarm in 24 hours */
+	rtc_tm_to_time(&alarm_tm, &ticks);
+	data = ticks - base;
+
+	buf[0] = data & 0xff;
+	buf[1] = (data >> 8) & 0xff;
+	buf[2] = (data >> 16) & 0xff;
+	buf[3] = (data >> 24) & 0xff;
+	pm860x_bulk_write(info->i2c, PM8607_RTC_EXPIRE1, 4, buf);
+	if (alrm->enabled) {
+		mask = ALARM | ALARM_WAKEUP | ALARM_EN;
+		pm860x_set_bits(info->i2c, PM8607_RTC1, mask, mask);
+	} else {
+		mask = ALARM | ALARM_WAKEUP | ALARM_EN;
+		pm860x_set_bits(info->i2c, PM8607_RTC1, mask,
+				ALARM | ALARM_WAKEUP);
+	}
+	return 0;
+}
+
+static const struct rtc_class_ops pm860x_rtc_ops = {
+	.read_time	= pm860x_rtc_read_time,
+	.set_time	= pm860x_rtc_set_time,
+	.read_alarm	= pm860x_rtc_read_alarm,
+	.set_alarm	= pm860x_rtc_set_alarm,
+	.alarm_irq_enable = pm860x_rtc_alarm_irq_enable,
+};
+
+#ifdef VRTC_CALIBRATION
+static void calibrate_vrtc_work(struct work_struct *work)
+{
+	struct pm860x_rtc_info *info = container_of(work,
+		struct pm860x_rtc_info, calib_work.work);
+	unsigned char buf[2];
+	unsigned int sum, data, mean, vrtc_set;
+	int i;
+
+	for (i = 0, sum = 0; i < 16; i++) {
+		msleep(100);
+		pm860x_bulk_read(info->i2c, REG_VRTC_MEAS1, 2, buf);
+		data = (buf[0] << 4) | buf[1];
+		data = (data * 5400) >> 12;	/* convert to mv */
+		sum += data;
+	}
+	mean = sum >> 4;
+	vrtc_set = 2700 + (info->vrtc & 0x3) * 200;
+	dev_dbg(info->dev, "mean:%d, vrtc_set:%d\n", mean, vrtc_set);
+
+	sum = pm860x_reg_read(info->i2c, PM8607_RTC_MISC1);
+	data = sum & 0x3;
+	if ((mean + 200) < vrtc_set) {
+		/* try higher voltage */
+		if (++data == 4)
+			goto out;
+		data = (sum & 0xf8) | (data & 0x3);
+		pm860x_reg_write(info->i2c, PM8607_RTC_MISC1, data);
+	} else if ((mean - 200) > vrtc_set) {
+		/* try lower voltage */
+		if (data-- == 0)
+			goto out;
+		data = (sum & 0xf8) | (data & 0x3);
+		pm860x_reg_write(info->i2c, PM8607_RTC_MISC1, data);
+	} else
+		goto out;
+	dev_dbg(info->dev, "set 0x%x to RTC_MISC1\n", data);
+	/* trigger next calibration since VRTC is updated */
+	schedule_delayed_work(&info->calib_work, VRTC_CALIB_INTERVAL);
+	return;
+out:
+	/* disable measurement */
+	pm860x_set_bits(info->i2c, PM8607_MEAS_EN2, MEAS2_VRTC, 0);
+	dev_dbg(info->dev, "finish VRTC calibration\n");
+	return;
+}
+#endif
+
+static int __devinit pm860x_rtc_probe(struct platform_device *pdev)
+{
+	struct pm860x_chip *chip = dev_get_drvdata(pdev->dev.parent);
+	struct pm860x_rtc_pdata *pdata = NULL;
+	struct pm860x_rtc_info *info;
+	struct rtc_time tm;
+	unsigned long ticks = 0;
+	int ret;
+
+	pdata = pdev->dev.platform_data;
+	if (pdata == NULL) {
+		dev_err(&pdev->dev, "No platform data!\n");
+		return -EINVAL;
+	}
+
+	info = kzalloc(sizeof(struct pm860x_rtc_info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+	info->irq = platform_get_irq(pdev, 0);
+	if (info->irq < 0) {
+		dev_err(&pdev->dev, "No IRQ resource!\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	info->chip = chip;
+	info->i2c = (chip->id == CHIP_PM8607) ? chip->client : chip->companion;
+	info->dev = &pdev->dev;
+	dev_set_drvdata(&pdev->dev, info);
+
+	ret = request_threaded_irq(info->irq, NULL, rtc_update_handler,
+				   IRQF_ONESHOT, "rtc", info);
+	if (ret < 0) {
+		dev_err(chip->dev, "Failed to request IRQ: #%d: %d\n",
+			info->irq, ret);
+		goto out;
+	}
+
+	/* set addresses of 32-bit base value for RTC time */
+	pm860x_page_reg_write(info->i2c, REG0_ADDR, REG0_DATA);
+	pm860x_page_reg_write(info->i2c, REG1_ADDR, REG1_DATA);
+	pm860x_page_reg_write(info->i2c, REG2_ADDR, REG2_DATA);
+	pm860x_page_reg_write(info->i2c, REG3_ADDR, REG3_DATA);
+
+	ret = pm860x_rtc_read_time(&pdev->dev, &tm);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to read initial time.\n");
+		goto out_rtc;
+	}
+	if ((tm.tm_year < 70) || (tm.tm_year > 138)) {
+		tm.tm_year = 70;
+		tm.tm_mon = 0;
+		tm.tm_mday = 1;
+		tm.tm_hour = 0;
+		tm.tm_min = 0;
+		tm.tm_sec = 0;
+		ret = pm860x_rtc_set_time(&pdev->dev, &tm);
+		if (ret < 0) {
+			dev_err(&pdev->dev, "Failed to set initial time.\n");
+			goto out_rtc;
+		}
+	}
+	rtc_tm_to_time(&tm, &ticks);
+	if (pdata->sync) {
+		pdata->sync(ticks);
+		info->sync = pdata->sync;
+	}
+
+	info->rtc_dev = rtc_device_register("88pm860x-rtc", &pdev->dev,
+					    &pm860x_rtc_ops, THIS_MODULE);
+	ret = PTR_ERR(info->rtc_dev);
+	if (IS_ERR(info->rtc_dev)) {
+		dev_err(&pdev->dev, "Failed to register RTC device: %d\n", ret);
+		goto out_rtc;
+	}
+
+	/*
+	 * enable internal XO instead of internal 3.25MHz clock since it can
+	 * free running in PMIC power-down state.
+	 */
+	pm860x_set_bits(info->i2c, PM8607_RTC1, RTC1_USE_XO, RTC1_USE_XO);
+
+#ifdef VRTC_CALIBRATION
+	/* <00> -- 2.7V, <01> -- 2.9V, <10> -- 3.1V, <11> -- 3.3V */
+	info->vrtc = pdata->vrtc & 0x3;
+	pm860x_set_bits(info->i2c, PM8607_MEAS_EN2, MEAS2_VRTC, MEAS2_VRTC);
+
+	/* calibrate VRTC */
+	INIT_DELAYED_WORK(&info->calib_work, calibrate_vrtc_work);
+	schedule_delayed_work(&info->calib_work, VRTC_CALIB_INTERVAL);
+#endif	/* VRTC_CALIBRATION */
+	return 0;
+out_rtc:
+	free_irq(info->irq, info);
+out:
+	kfree(info);
+	return ret;
+}
+
+static int __devexit pm860x_rtc_remove(struct platform_device *pdev)
+{
+	struct pm860x_rtc_info *info = platform_get_drvdata(pdev);
+
+#ifdef VRTC_CALIBRATION
+	flush_scheduled_work();
+	/* disable measurement */
+	pm860x_set_bits(info->i2c, PM8607_MEAS_EN2, MEAS2_VRTC, 0);
+#endif	/* VRTC_CALIBRATION */
+
+	platform_set_drvdata(pdev, NULL);
+	rtc_device_unregister(info->rtc_dev);
+	free_irq(info->irq, info);
+	kfree(info);
+	return 0;
+}
+
+static struct platform_driver pm860x_rtc_driver = {
+	.driver		= {
+		.name	= "88pm860x-rtc",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= pm860x_rtc_probe,
+	.remove		= __devexit_p(pm860x_rtc_remove),
+};
+
+static int __init pm860x_rtc_init(void)
+{
+	return platform_driver_register(&pm860x_rtc_driver);
+}
+module_init(pm860x_rtc_init);
+
+static void __exit pm860x_rtc_exit(void)
+{
+	platform_driver_unregister(&pm860x_rtc_driver);
+}
+module_exit(pm860x_rtc_exit);
+
+MODULE_DESCRIPTION("Marvell 88PM860x RTC driver");
+MODULE_AUTHOR("Haojian Zhuang <haojian.zhuang@marvell.com>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/88pm860x.h b/include/linux/mfd/88pm860x.h
index 8fba797..63b4fb8 100644
--- a/include/linux/mfd/88pm860x.h
+++ b/include/linux/mfd/88pm860x.h
@@ -330,6 +330,11 @@ struct pm860x_led_pdata {
 	unsigned long	flags;
 };
 
+struct pm860x_rtc_pdata {
+	int		(*sync)(unsigned int ticks);
+	int		vrtc;
+};
+
 struct pm860x_touch_pdata {
 	int		gpadc_prebias;
 	int		slot_cycle;
@@ -349,6 +354,7 @@ struct pm860x_power_pdata {
 struct pm860x_platform_data {
 	struct pm860x_backlight_pdata	*backlight;
 	struct pm860x_led_pdata		*led;
+	struct pm860x_rtc_pdata		*rtc;
 	struct pm860x_touch_pdata	*touch;
 	struct pm860x_power_pdata	*power;
 	struct regulator_init_data	*regulator;
-- 
1.5.6.5

