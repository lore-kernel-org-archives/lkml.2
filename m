Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785Ab1DNLEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 07:04:31 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:54849 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758728Ab1DNLE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 07:04:29 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zz936eKc8kzz1202hzz15d4R8275bh84d07hz32i2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:kcinpunhjhc02.kpit.com;RD:none;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Joe Perches <joe@perches.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dajun Chen <Dajun.Chen@diasemi.com>,
        Paul Gortmaker <p_gortmaker@yahoo.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 14 Apr 2011 16:32:23 +0530
Subject: [PATCHv1 3/11] RTC: RTC module of DA9052 PMIC driver
Thread-Topic: [PATCHv1 3/11] RTC: RTC module of DA9052 PMIC driver
Thread-Index: Acv6k26CbWebrTo7Ss+K4jxs5UwbVA==
Message-ID: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B6777D5@KCINPUNHJCMS01.kpit.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3EB4gGC019164

Hi Joe,


RTC Driver for Dialog Semiconductor DA9052 PMICs.

Changes made since last submission:
. Directly calling 'request_threaded_irq' instead of calling MFD function
. Formatting changes done
. Defined a macro for error notification
. Ported on 2.6.38.2 kernel
Linux Kernel Version: 2.6.38.2

Signed-off-by: D. Chen <dchen@diasemi.com>
---
diff -Naur linux-2.6.38.2/drivers/rtc/Kconfig wrk_linux-2.6.38.2/drivers/rtc/Kconfig
--- linux-2.6.38.2/drivers/rtc/Kconfig	2011-03-27 23:37:20.000000000 +0500
+++ wrk_linux-2.6.38.2/drivers/rtc/Kconfig	2011-04-14 14:38:59.000000000 +0500
@@ -475,6 +475,13 @@
 	style programming interface is mostly conserved, but any
 	updates are done via IPC calls to the system controller FW.

+config RTC_DRV_DA9052
+	tristate "Dialog DA9052 RTC"
+	depends on PMIC_DA9052
+	help
+	  Say y here to support the RTC driver for
+	  Dialog Semiconductor DA9052 PMIC.
+
 config RTC_DRV_DS1216
 	tristate "Dallas DS1216"
 	depends on SNI_RM
diff -Naur linux-2.6.38.2/drivers/rtc/Makefile wrk_linux-2.6.38.2/drivers/rtc/Makefile
--- linux-2.6.38.2/drivers/rtc/Makefile	2011-03-27 23:37:20.000000000 +0500
+++ wrk_linux-2.6.38.2/drivers/rtc/Makefile	2011-04-14 14:43:16.000000000 +0500
@@ -28,6 +28,7 @@
 obj-$(CONFIG_RTC_DRV_BQ4802)	+= rtc-bq4802.o
 obj-$(CONFIG_RTC_DRV_CMOS)	+= rtc-cmos.o
 obj-$(CONFIG_RTC_DRV_COH901331)	+= rtc-coh901331.o
+obj-$(CONFIG_RTC_DRV_DA9052)	+= rtc-da9052.o
 obj-$(CONFIG_RTC_DRV_DAVINCI)	+= rtc-davinci.o
 obj-$(CONFIG_RTC_DRV_DM355EVM)	+= rtc-dm355evm.o
 obj-$(CONFIG_RTC_DRV_VRTC)	+= rtc-mrst.o
diff -Naur linux-2.6.38.2/drivers/rtc/rtc-da9052.c wrk_linux-2.6.38.2/drivers/rtc/rtc-da9052.c
--- linux-2.6.38.2/drivers/rtc/rtc-da9052.c	1970-01-01 05:00:00.000000000 +0500
+++ wrk_linux-2.6.38.2/drivers/rtc/rtc-da9052.c	2011-04-14 14:38:46.000000000 +0500
@@ -0,0 +1,340 @@
+/*
+ * Real time clock driver for DA9052
+ *
+ *Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ *Author: Dajun Chen <dajun.chen@diasemi.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/platform_device.h>
+#include <linux/rtc.h>
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/reg.h>
+
+#define rtc_err(da9052, fmt, ...) \
+		dev_err(da9052->dev, "%s: " fmt, __func__, ##__VA_ARGS__)
+
+struct da9052_rtc {
+	struct rtc_device *rtc;
+	struct da9052 *da9052;
+	int irq;
+};
+
+static int da9052_rtc_enable_alarm(struct da9052 *da9052, bool enable)
+{
+	int ret = 0;
+	if (enable) {
+		ret = da9052_set_bits(da9052, DA9052_ALARM_Y_REG,
+					DA9052_ALARM_Y_ALARM_ON);
+		if (ret != 0)
+			rtc_err(da9052, "Failed to enable ALM: %d\n", ret);
+	} else {
+		ret = da9052_clear_bits(da9052, DA9052_ALARM_Y_REG,
+					DA9052_ALARM_Y_ALARM_ON);
+		if (ret != 0)
+			rtc_err(da9052, "da9052_rtc_enable_alarm write error %d\n",
+					ret);
+	}
+	return ret;
+}
+
+static irqreturn_t da9052_rtc_irq(int irq, void *data)
+{
+	struct da9052_rtc *rtc = data;
+	int ret = 0;
+
+	ret = da9052_reg_read(rtc->da9052, DA9052_ALARM_MI_REG);
+	if (ret < 0) {
+		rtc_err(rtc->da9052, "da9052_rtc_notifier read error %d\n",
+					ret);
+		return IRQ_NONE;
+	}
+	if (ret & DA9052_ALARMMI_ALARMTYPE)
+		da9052_rtc_enable_alarm(rtc->da9052, 0);
+
+	return IRQ_HANDLED;
+}
+
+static int da9052_read_alarm(struct da9052 *da9052, struct rtc_time *rtc_tm)
+{
+
+	int ret = 0;
+	uint8_t v[5] = {0, 0, 0, 0, 0};
+	ret = da9052_group_read(da9052, DA9052_ALARM_MI_REG, 5, v);
+	if (ret != 0) {
+		rtc_err(da9052, "Failed to group read ALM: %d\n", ret);
+		return ret;
+	}
+
+	rtc_tm->tm_year = v[4] & DA9052_RTC_YEAR;
+	rtc_tm->tm_mon  = v[3] & DA9052_RTC_MONTH;
+	rtc_tm->tm_mday = v[2] & DA9052_RTC_DAY;
+	rtc_tm->tm_hour = v[1] & DA9052_RTC_HOUR;
+	rtc_tm->tm_min  = v[0] & DA9052_RTC_MIN;
+
+	ret = rtc_valid_tm(rtc_tm);
+	if (ret != 0)
+		return ret;
+
+	rtc_tm->tm_year += 100;
+	rtc_tm->tm_mon -= 1;
+
+	return ret;
+}
+
+static int da9052_set_alarm(struct da9052 *da9052, struct rtc_time *rtc_tm)
+{
+	int ret = 0;
+	uint8_t v[3] = {0, 0, 0};
+
+	rtc_tm->tm_sec = 0;
+	rtc_tm->tm_year -= 100;
+	rtc_tm->tm_mon += 1;
+
+	ret = rtc_valid_tm(rtc_tm);
+	if (ret)
+		return ret;
+
+	ret = da9052_reg_update(da9052, DA9052_ALARM_MI_REG,
+				DA9052_RTC_MIN, rtc_tm->tm_min);
+	if (ret != 0) {
+		rtc_err(da9052, "Failed to write ALRM MIN: %d\n", ret);
+		return ret;
+	}
+
+	ret = da9052_reg_update(da9052, DA9052_ALARM_Y_REG,
+				DA9052_RTC_YEAR, rtc_tm->tm_year);
+	if (ret != 0) {
+		rtc_err(da9052, "Failed to write ALRM YEAR: %d\n", ret);
+		return ret;
+	}
+
+	v[0] = rtc_tm->tm_hour;
+	v[1] = rtc_tm->tm_mday;
+	v[2] = rtc_tm->tm_mon;
+
+	return da9052_group_write(da9052, DA9052_ALARM_H_REG, 3, v);
+}
+
+static int da9052_rtc_get_alarm_status(struct da9052 *da9052)
+{
+	int ret = 0;
+	ret = da9052_reg_read(da9052, DA9052_ALARM_Y_REG);
+	if (ret < 0) {
+		rtc_err(da9052, "Failed to read ALM: %d\n", ret);
+		return ret;
+	}
+	ret &= DA9052_ALARM_Y_ALARM_ON;
+	return (ret > 0) ? 1 : 0;
+}
+
+static int da9052_rtc_read_time
+			(struct device *dev, struct rtc_time *rtc_tm)
+{
+	struct da9052_rtc *rtc = dev_get_drvdata(dev);
+	uint8_t v[6] = {0, 0, 0, 0, 0, 0};
+	int ret;
+
+	ret = da9052_group_read(rtc->da9052, DA9052_COUNT_S_REG, 6, v);
+	if (ret != 0) {
+		rtc_err(rtc->da9052, "Failed to read RTC time : %d\n",
+					ret);
+		return ret;
+	}
+
+	rtc_tm->tm_year = v[5] & DA9052_RTC_YEAR;
+	rtc_tm->tm_mon  = v[4] & DA9052_RTC_MONTH;
+	rtc_tm->tm_mday = v[3] & DA9052_RTC_DAY;
+	rtc_tm->tm_hour = v[2] & DA9052_RTC_HOUR;
+	rtc_tm->tm_min  = v[1] & DA9052_RTC_MIN;
+	rtc_tm->tm_sec  = v[0] & DA9052_RTC_SEC;
+
+	ret = rtc_valid_tm(rtc_tm);
+	if (ret != 0) {
+		rtc_err(rtc->da9052, "da9052_rtc_read_time valid time failed %d\n",
+					ret);
+		return ret;
+	}
+
+	rtc_tm->tm_year += 100;
+	rtc_tm->tm_mon -= 1;
+
+	return 0;
+}
+
+
+static int da9052_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	int ret;
+	struct da9052_rtc *rtc;
+	uint8_t v[6] = {0, 0, 0, 0, 0, 0};
+
+	rtc = dev_get_drvdata(dev);
+
+	tm->tm_year -= 100;
+	tm->tm_mon += 1;
+
+	ret = rtc_valid_tm(tm);
+	if (ret != 0)
+		return ret;
+
+	v[0] = tm->tm_sec;
+	v[1] = tm->tm_min;
+	v[2] = tm->tm_hour;
+	v[3] = tm->tm_mday;
+	v[4] = tm->tm_mon;
+	v[5] = tm->tm_year;
+	return da9052_group_write(rtc->da9052, DA9052_COUNT_S_REG, 6, v);
+}
+
+static int da9052_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	int ret = 0;
+	struct rtc_time *tm = &alrm->time;
+	struct da9052_rtc *rtc = dev_get_drvdata(dev);
+
+	ret = da9052_read_alarm(rtc->da9052, tm);
+
+	if (ret)
+		return ret;
+
+	alrm->enabled = da9052_rtc_get_alarm_status(rtc->da9052);
+
+	return 0;
+}
+
+static int da9052_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	int ret = 0;
+	struct rtc_time *tm = &alrm->time;
+	struct da9052_rtc *rtc = dev_get_drvdata(dev);
+
+	ret = da9052_set_alarm(rtc->da9052, tm);
+
+	if (ret)
+		return ret;
+
+	ret = da9052_rtc_enable_alarm(rtc->da9052, 1);
+
+	return ret;
+}
+
+static int da9052_rtc_update_irq_enable(struct device *dev,
+		unsigned int enabled)
+{
+	struct da9052_rtc *rtc = dev_get_drvdata(dev);
+
+	if (enabled)
+		return da9052_set_bits(rtc->da9052, DA9052_ALARM_Y_REG,
+					DA9052_ALARM_Y_TICK_ON);
+	else
+		return da9052_clear_bits(rtc->da9052, DA9052_ALARM_Y_REG,
+					 DA9052_ALARM_Y_TICK_ON);
+}
+
+static int da9052_rtc_alarm_irq_enable(struct device *dev,
+			unsigned int enabled)
+{
+	struct da9052_rtc *rtc = dev_get_drvdata(dev);
+
+	if (enabled)
+		return da9052_rtc_enable_alarm(rtc->da9052, enabled);
+	else
+		return da9052_rtc_enable_alarm(rtc->da9052, enabled);
+}
+
+static const struct rtc_class_ops da9052_rtc_ops = {
+	.read_time	= da9052_rtc_read_time,
+	.set_time	= da9052_rtc_set_time,
+	.read_alarm	= da9052_rtc_read_alarm,
+	.set_alarm	= da9052_rtc_set_alarm,
+	.update_irq_enable = da9052_rtc_update_irq_enable,
+	.alarm_irq_enable = da9052_rtc_alarm_irq_enable,
+};
+
+static int __devinit da9052_rtc_probe(struct platform_device *pdev)
+{
+	struct da9052_rtc *rtc;
+	int ret = 0;
+
+	rtc = kzalloc(sizeof(struct da9052_rtc), GFP_KERNEL);
+	if (!rtc)
+		return -ENOMEM;
+
+	rtc->da9052 = dev_get_drvdata(pdev->dev.parent);
+	rtc->irq = platform_get_irq_byname(pdev, "ALM");
+
+	ret = request_threaded_irq(rtc->da9052->irq_base + rtc->irq,
+				NULL, da9052_rtc_irq,
+				IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				"ALM", rtc);
+	if (ret != 0) {
+		rtc_err(rtc->da9052, "DA9052 RTC failed irq registration: %d\n",
+					ret);
+		goto err_mem;
+	}
+
+	da9052_set_bits(rtc->da9052, DA9052_ALARM_Y_REG,
+			DA9052_ALARM_Y_TICK_ON);
+
+	rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
+				       &da9052_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc->rtc)) {
+		ret = PTR_ERR(rtc->rtc);
+		goto err_free_irq;
+	}
+
+	platform_set_drvdata(pdev, rtc);
+
+	return 0;
+
+err_free_irq:
+	free_irq(rtc->da9052->irq_base + rtc->irq, NULL);
+err_mem:
+	kfree(rtc);
+	return ret;
+}
+
+static int __devexit da9052_rtc_remove(struct platform_device *pdev)
+{
+	struct da9052_rtc *rtc = pdev->dev.platform_data;
+
+	rtc_device_unregister(rtc->rtc);
+	free_irq(rtc->da9052->irq_base + rtc->irq, NULL);
+	platform_set_drvdata(pdev, NULL);
+	kfree(rtc);
+
+	return 0;
+}
+
+static struct platform_driver da9052_rtc_driver = {
+	.driver.name	= "da9052-rtc",
+	.driver.owner	= THIS_MODULE,
+	.probe		= da9052_rtc_probe,
+	.remove	= __devexit_p(da9052_rtc_remove),
+};
+
+static int __init da9052_rtc_init(void)
+{
+	return platform_driver_register(&da9052_rtc_driver);
+}
+module_init(da9052_rtc_init);
+
+static void __exit da9052_rtc_exit(void)
+{
+	platform_driver_unregister(&da9052_rtc_driver);
+}
+module_exit(da9052_rtc_exit);
+
+MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>");
+MODULE_DESCRIPTION("RTC driver for Dialog DA9052 PMIC");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:da9052-rtc");
+

Regards,
Ashish J


ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
