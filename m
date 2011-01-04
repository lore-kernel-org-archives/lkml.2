Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697Ab1ADFZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 00:25:23 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:29137 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab1ADFYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 00:24:31 -0500
Date: Tue, 04 Jan 2011 14:17:39 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v4 1/3] MFD MAX8998/LP3974: Support LP3974 RTC
In-reply-to: <20101224113805.GI27832@sortiz-mobl>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Message-id: <1294118261-18906-2-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
References: <20101224113805.GI27832@sortiz-mobl>
X-OriginalArrivalTime: 04 Jan 2011 05:17:41.0827 (UTC)
 FILETIME=[B62DF930:01CBABCE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first releases of LP3974 have a large delay in RTC registers,
which requires 2 seconds of delay after writing to a rtc register
(recommended by National Semiconductor's engineers)
before reading it.

If "rtc_delay" field of the platform data is true, the rtc driver
assumes that such delays are required. Although we have not seen
LP3974s without requiring such delays, we assume that such LP3974s
will be released soon (or they have done so already) and they are
supported by "lp3974" without setting "rtc_delay" at the platform
data.

This patch adds delays with msleep when writing values to RTC registers
if the platform data has rtc_delay set.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/max8998.c       |   26 ++++++++++++++++++--
 drivers/regulator/max8998.c |    7 +++++
 drivers/rtc/rtc-max8998.c   |   54 +++++++++++++++++++++++++++++++++++++++----
 include/linux/mfd/max8998.h |    4 +++
 4 files changed, 83 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
index 5ce00ad..bbfe867 100644
--- a/drivers/mfd/max8998.c
+++ b/drivers/mfd/max8998.c
@@ -42,6 +42,14 @@ static struct mfd_cell max8998_devs[] = {
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
 int max8998_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
 {
 	struct max8998_dev *max8998 = i2c_get_clientdata(i2c);
@@ -146,11 +154,23 @@ static int max8998_i2c_probe(struct i2c_client *i2c,
 
 	max8998_irq_init(max8998);
 
-	ret = mfd_add_devices(max8998->dev, -1,
-			      max8998_devs, ARRAY_SIZE(max8998_devs),
-			      NULL, 0);
 	pm_runtime_set_active(max8998->dev);
 
+	switch (id->driver_data) {
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
 
diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index ed5253c..d183756 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -836,6 +836,12 @@ static int __devexit max8998_pmic_remove(struct platform_device *pdev)
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
@@ -843,6 +849,7 @@ static struct platform_driver max8998_pmic_driver = {
 	},
 	.probe = max8998_pmic_probe,
 	.remove = __devexit_p(max8998_pmic_remove),
+	.id_table = max8998_pmic_id,
 };
 
 static int __init max8998_pmic_init(void)
diff --git a/drivers/rtc/rtc-max8998.c b/drivers/rtc/rtc-max8998.c
index f22dee3..3f7bc6b 100644
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
@@ -224,6 +252,7 @@ static const struct rtc_class_ops max8998_rtc_ops = {
 static int __devinit max8998_rtc_probe(struct platform_device *pdev)
 {
 	struct max8998_dev *max8998 = dev_get_drvdata(pdev->dev.parent);
+	struct max8998_platform_data *pdata = dev_get_platdata(max8998->dev);
 	struct max8998_rtc_info *info;
 	int ret;
 
@@ -249,10 +278,18 @@ static int __devinit max8998_rtc_probe(struct platform_device *pdev)
 
 	ret = request_threaded_irq(info->irq, NULL, max8998_rtc_alarm_irq, 0,
 			"rtc-alarm0", info);
+
 	if (ret < 0)
 		dev_err(&pdev->dev, "Failed to request alarm IRQ: %d: %d\n",
 			info->irq, ret);
 
+	dev_info(&pdev->dev, "RTC CHIP NAME: %s\n", pdev->id_entry->name);
+	if (pdata->rtc_delay) {
+		info->lp3974_bug_workaround = true;
+		dev_warn(&pdev->dev, "LP3974 with RTC REGERR option."
+				" RTC updates will be extremely slow.\n");
+	}
+
 	return 0;
 
 out_rtc:
@@ -273,6 +310,12 @@ static int __devexit max8998_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct platform_device_id max8998_rtc_id[] = {
+	{ "max8998-rtc", TYPE_MAX8998 },
+	{ "lp3974-rtc", TYPE_LP3974 },
+	{ }
+};
+
 static struct platform_driver max8998_rtc_driver = {
 	.driver		= {
 		.name	= "max8998-rtc",
@@ -280,6 +323,7 @@ static struct platform_driver max8998_rtc_driver = {
 	},
 	.probe		= max8998_rtc_probe,
 	.remove		= __devexit_p(max8998_rtc_remove),
+	.id_table	= max8998_rtc_id,
 };
 
 static int __init max8998_rtc_init(void)
diff --git a/include/linux/mfd/max8998.h b/include/linux/mfd/max8998.h
index 686a744..c22b9a4 100644
--- a/include/linux/mfd/max8998.h
+++ b/include/linux/mfd/max8998.h
@@ -76,6 +76,9 @@ struct max8998_regulator_data {
  * @buck1_set1: BUCK1 gpio pin 1 to set output voltage
  * @buck1_set2: BUCK1 gpio pin 2 to set output voltage
  * @buck2_set3: BUCK2 gpio pin to set output voltage
+ * @wakeup: Allow to wake up from suspend
+ * @rtc_delay: LP3974 RTC chip bug that requires delay after a register
+ * write before reading it.
  */
 struct max8998_platform_data {
 	struct max8998_regulator_data	*regulators;
@@ -89,6 +92,7 @@ struct max8998_platform_data {
 	int				buck1_set2;
 	int				buck2_set3;
 	bool				wakeup;
+	bool				rtc_delay;
 };
 
 #endif /*  __LINUX_MFD_MAX8998_H */
-- 
1.7.1

