Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab0LVGYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 01:24:14 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:40604 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab0LVGYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 01:24:12 -0500
Date: Wed, 22 Dec 2010 15:23:07 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v2 2/6] MFD MAX8998/LP3974: Support LP3974 RTC
In-reply-to: <20101221155004.GA21871@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Message-id: <1292998991-26968-3-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
References: <20101221155004.GA21871@opensource.wolfsonmicro.com>
X-OriginalArrivalTime: 22 Dec 2010 06:23:11.0780 (UTC)
 FILETIME=[B53E7640:01CBA1A0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first releases of LP3974 have a large delay in RTC registers,
which requires 2 seconds of delay after writing to a rtc register
(recommended by National Semiconductor's engineers)
before reading it. If the device name is "lp3974-regerr", the rtc driver
assumes that such delays are required. If the device name is "lp3974",
the rtc driver does not. Although we have not seen LP3974s without
requiring such delays, we assume that such LP3974s will be released
soon (or they have done so already) and they are supported by "lp3974".

This patch adds delays with msleep when writing values to RTC registers
if the device name is "lp3974-regerr".

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/max8998.c               |   41 ++++++++++++++++++++++++--
 drivers/regulator/max8998.c         |    7 ++++
 drivers/rtc/rtc-max8998.c           |   55 +++++++++++++++++++++++++++++++---
 include/linux/mfd/max8998-private.h |    1 +
 4 files changed, 96 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
index 5ce00ad..8b9eed1 100644
--- a/drivers/mfd/max8998.c
+++ b/drivers/mfd/max8998.c
@@ -42,6 +42,22 @@ static struct mfd_cell max8998_devs[] = {
 	},
 };
 
+static struct mfd_cell lp3974_devs[] = {
+	{
+		.name = "lp3974-pmic",
+	}, {
+		.name = "lp3974-rtc",
+	},
+};
+
+static struct mfd_cell lp3974_regerr_devs[] = {
+	{
+		.name = "lp3974-pmic",
+	}, {
+		.name = "lp3974-rtc-regerr",
+	},
+};
+
 int max8998_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
 {
 	struct max8998_dev *max8998 = i2c_get_clientdata(i2c);
@@ -146,11 +162,29 @@ static int max8998_i2c_probe(struct i2c_client *i2c,
 
 	max8998_irq_init(max8998);
 
-	ret = mfd_add_devices(max8998->dev, -1,
-			      max8998_devs, ARRAY_SIZE(max8998_devs),
-			      NULL, 0);
 	pm_runtime_set_active(max8998->dev);
 
+	switch (id->driver_data) {
+	case TYPE_LP3974_REGERR:
+		ret = mfd_add_devices(max8998->dev, -1,
+				lp3974_regerr_devs,
+				ARRAY_SIZE(lp3974_regerr_devs),
+				NULL, 0);
+		break;
+	case TYPE_LP3974:
+		ret = mfd_add_devices(max8998->dev, -1,
+				lp3974_devs, ARRAY_SIZE(lp3974_devs),
+				NULL, 0);
+		break;
+	case TYPE_MAX8998:
+		ret = mfd_add_devices(max8998->dev, -1,
+				max8998_devs, ARRAY_SIZE(max8998_devs),
+				NULL, 0);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
 	if (ret < 0)
 		goto err;
 
@@ -179,6 +213,7 @@ static int max8998_i2c_remove(struct i2c_client *i2c)
 static const struct i2c_device_id max8998_i2c_id[] = {
 	{ "max8998", TYPE_MAX8998 },
 	{ "lp3974", TYPE_LP3974},
+	{ "lp3974-regerr", TYPE_LP3974_REGERR },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, max8998_i2c_id);
diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 5c20756..65e23d3 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -831,6 +831,12 @@ static int __devexit max8998_pmic_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct platform_device_id max8998_pmic_id[] = {
+	{ "max8998-pmic", TYPE_MAX8998 },
+	{ "lp3974-pmic", TYPE_LP3974 },
+	{ }
+};
+
 static struct platform_driver max8998_pmic_driver = {
 	.driver = {
 		.name = "max8998-pmic",
@@ -838,6 +844,7 @@ static struct platform_driver max8998_pmic_driver = {
 	},
 	.probe = max8998_pmic_probe,
 	.remove = __devexit_p(max8998_pmic_remove),
+	.id_table = max8998_pmic_id,
 };
 
 static int __init max8998_pmic_init(void)
diff --git a/drivers/rtc/rtc-max8998.c b/drivers/rtc/rtc-max8998.c
index f22dee3..421ef0e 100644
--- a/drivers/rtc/rtc-max8998.c
+++ b/drivers/rtc/rtc-max8998.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/mfd/max8998.h>
 #include <linux/mfd/max8998-private.h>
+#include <linux/delay.h>
 
 #define MAX8998_RTC_SEC			0x00
 #define MAX8998_RTC_MIN			0x01
@@ -73,6 +74,7 @@ struct max8998_rtc_info {
 	struct i2c_client	*rtc;
 	struct rtc_device	*rtc_dev;
 	int irq;
+	bool lp3974_bug_workaround;
 };
 
 static void max8998_data_to_tm(u8 *data, struct rtc_time *tm)
@@ -124,10 +126,16 @@ static int max8998_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	struct max8998_rtc_info *info = dev_get_drvdata(dev);
 	u8 data[8];
+	int ret;
 
 	max8998_tm_to_data(tm, data);
 
-	return max8998_bulk_write(info->rtc, MAX8998_RTC_SEC, 8, data);
+	ret = max8998_bulk_write(info->rtc, MAX8998_RTC_SEC, 8, data);
+
+	if (info->lp3974_bug_workaround)
+		msleep(2000);
+
+	return ret;
 }
 
 static int max8998_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
@@ -163,12 +171,29 @@ static int max8998_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 static int max8998_rtc_stop_alarm(struct max8998_rtc_info *info)
 {
-	return max8998_write_reg(info->rtc, MAX8998_ALARM0_CONF, 0);
+	int ret = max8998_write_reg(info->rtc, MAX8998_ALARM0_CONF, 0);
+
+	if (info->lp3974_bug_workaround)
+		msleep(2000);
+
+	return ret;
 }
 
 static int max8998_rtc_start_alarm(struct max8998_rtc_info *info)
 {
-	return max8998_write_reg(info->rtc, MAX8998_ALARM0_CONF, 0x77);
+	int ret;
+	u8 alarm0_conf = 0x77;
+
+	/* LP3974 with delay bug chips has rtc alarm bugs with "MONTH" field */
+	if (info->lp3974_bug_workaround)
+		alarm0_conf = 0x57;
+
+	ret = max8998_write_reg(info->rtc, MAX8998_ALARM0_CONF, alarm0_conf);
+
+	if (info->lp3974_bug_workaround)
+		msleep(2000);
+
+	return ret;
 }
 
 static int max8998_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
@@ -187,10 +212,13 @@ static int max8998_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	if (ret < 0)
 		return ret;
 
+	if (info->lp3974_bug_workaround)
+		msleep(2000);
+
 	if (alrm->enabled)
-		return max8998_rtc_start_alarm(info);
+		ret = max8998_rtc_start_alarm(info);
 
-	return 0;
+	return ret;
 }
 
 static int max8998_rtc_alarm_irq_enable(struct device *dev,
@@ -249,10 +277,18 @@ static int __devinit max8998_rtc_probe(struct platform_device *pdev)
 
 	ret = request_threaded_irq(info->irq, NULL, max8998_rtc_alarm_irq, 0,
 			"rtc-alarm0", info);
+
 	if (ret < 0)
 		dev_err(&pdev->dev, "Failed to request alarm IRQ: %d: %d\n",
 			info->irq, ret);
 
+	dev_info(&pdev->dev, "RTC CHIP NAME: %s\n", pdev->id_entry->name);
+	if (pdev->id_entry->driver_data == TYPE_LP3974_REGERR) {
+		info->lp3974_bug_workaround = true;
+		dev_warn(&pdev->dev, "LP3974 with RTC REGERR option."
+				" RTC updates will be extremely slow.\n");
+	}
+
 	return 0;
 
 out_rtc:
@@ -273,6 +309,14 @@ static int __devexit max8998_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct platform_device_id max8998_rtc_id[] = {
+	{ "max8998-rtc", TYPE_MAX8998 },
+	{ "lp3974-rtc", TYPE_LP3974 },
+	/* REGERR: requires 1 ~ 2 s of delay after writing to RTC registers */
+	{ "lp3974-rtc-regerr", TYPE_LP3974_REGERR },
+	{ }
+};
+
 static struct platform_driver max8998_rtc_driver = {
 	.driver		= {
 		.name	= "max8998-rtc",
@@ -280,6 +324,7 @@ static struct platform_driver max8998_rtc_driver = {
 	},
 	.probe		= max8998_rtc_probe,
 	.remove		= __devexit_p(max8998_rtc_remove),
+	.id_table	= max8998_rtc_id,
 };
 
 static int __init max8998_rtc_init(void)
diff --git a/include/linux/mfd/max8998-private.h b/include/linux/mfd/max8998-private.h
index effa5d3..f107f42 100644
--- a/include/linux/mfd/max8998-private.h
+++ b/include/linux/mfd/max8998-private.h
@@ -105,6 +105,7 @@ enum {
 enum {
 	TYPE_MAX8998 = 0, /* Default */
 	TYPE_LP3974,	/* National version of MAX8998 */
+	TYPE_LP3974_REGERR, /* National version of MAX8998 with RTC REG BUG */
 	TYPE_LP3979,	/* Added AVS */
 };
 
-- 
1.7.1

