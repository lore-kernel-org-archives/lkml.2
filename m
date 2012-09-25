Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab2IYQN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:13:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757879Ab2IYQNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:54 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 34/57] power: ab8500_fg: add power cut feature for ab8505
Date: Tue, 25 Sep 2012 10:12:31 -0600
Message-Id: <1348589574-25655-35-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rikard Olsson <rikard.p.olsson@stericsson.com>

Add support for a power cut feature which allows user to
configure when ab8505 should shut down system due to low
battery.

Signed-off-by: Rikard Olsson <rikard.p.olsson@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Martin SJOBLOM <martin.w.sjoblom@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_fg.c            |  488 +++++++++++++++++++++++++++++++++-
 include/linux/mfd/abx500.h           |   10 +
 include/linux/mfd/abx500/ab8500-bm.h |    8 +
 3 files changed, 502 insertions(+), 4 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 5e4a46b..fde189a 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -2351,6 +2351,64 @@ static int ab8500_fg_init_hw_registers(struct ab8500_fg *di)
 		dev_err(di->dev, "BattOk init write failed.\n");
 		goto out;
 	}
+
+	if ((is_ab8505(di->parent) || is_ab9540(di->parent)) &&
+			abx500_get_chip_id(di->dev) >= AB8500_CUT2P0) {
+		ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
+			AB8505_RTC_PCUT_MAX_TIME_REG,
+					 di->bat->fg_params->pcut_max_time);
+
+		if (ret) {
+			dev_err(di->dev,
+				"%s write failed AB8505_RTC_PCUT_MAX_TIME_REG\n",
+				 __func__);
+			goto out;
+		};
+
+		ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
+			AB8505_RTC_PCUT_FLAG_TIME_REG,
+					 di->bat->fg_params->pcut_flag_time);
+
+		if (ret) {
+			dev_err(di->dev,
+			"%s write failed AB8505_RTC_PCUT_FLAG_TIME_REG\n",
+			 __func__);
+			goto out;
+		};
+
+		ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
+			AB8505_RTC_PCUT_RESTART_REG,
+			di->bat->fg_params->pcut_max_restart);
+
+		if (ret) {
+			dev_err(di->dev,
+			"%s write failed AB8505_RTC_PCUT_RESTART_REG\n",
+			 __func__);
+			goto out;
+		};
+
+		ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
+			AB8505_RTC_PCUT_DEBOUNCE_REG,
+					 di->bat->fg_params->pcut_debunce_time);
+
+		if (ret) {
+			dev_err(di->dev,
+			"%s write failed AB8505_RTC_PCUT_DEBOUNCE_REG\n",
+			 __func__);
+			goto out;
+		};
+
+		ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
+			AB8505_RTC_PCUT_CTL_STATUS_REG,
+					 di->bat->fg_params->pcut_enable);
+
+		if (ret) {
+			dev_err(di->dev,
+			"%s write failed AB8505_RTC_PCUT_CTL_STATUS_REG\n",
+			 __func__);
+			goto out;
+		};
+	}
 out:
 	return ret;
 }
@@ -2572,22 +2630,433 @@ static ssize_t ab8500_show_capacity(struct device *dev,
 	return scnprintf(buf, PAGE_SIZE, "%d\n", capacity);
 }
 
+static ssize_t ab8505_powercut_flagtime_read(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	int ret;
+	u8 reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
+		AB8505_RTC_PCUT_FLAG_TIME_REG, &reg_value);
+
+	if (ret < 0) {
+		dev_err(dev, "Failed to read AB8505_RTC_PCUT_FLAG_TIME_REG\n");
+		goto fail;
+	}
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", (reg_value & 0x7F));
+
+fail:
+	return ret;
+}
+
+static ssize_t ab8505_powercut_flagtime_write(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	int ret;
+	long unsigned reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	if (kstrtoul(buf, 10, &reg_value) != 0)
+		goto fail;
+
+	if (reg_value > 0x7F) {
+		dev_err(dev, "Incorrect parameter, echo 0 (1.98s) - 127 (15.625ms) for flagtime\n");
+		goto fail;
+	}
+
+	ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
+		AB8505_RTC_PCUT_FLAG_TIME_REG, (u8)reg_value);
+
+	if (ret < 0)
+		dev_err(dev, "Failed to set AB8505_RTC_PCUT_FLAG_TIME_REG\n");
+
+fail:
+	return count;
+}
+
+static ssize_t ab8505_powercut_maxtime_read(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	int ret;
+	u8 reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
+		AB8505_RTC_PCUT_MAX_TIME_REG, &reg_value);
+
+	if (ret < 0) {
+		dev_err(dev, "Failed to read AB8505_RTC_PCUT_MAX_TIME_REG\n");
+		goto fail;
+	}
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", (reg_value & 0x7F));
+
+fail:
+	return ret;
+
+}
+
+static ssize_t ab8505_powercut_maxtime_write(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	int ret;
+	long unsigned int reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	if (kstrtoul(buf, 10, &reg_value) != 0)
+		goto fail;
+
+	if (reg_value > 0x7F) {
+		dev_err(dev, "Incorrect parameter, echo 0 (0.0s) - 127 (1.98s) for maxtime\n");
+		goto fail;
+	}
+
+	ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
+		AB8505_RTC_PCUT_MAX_TIME_REG, (u8)reg_value);
+
+	if (ret < 0)
+		dev_err(dev, "Failed to set AB8505_RTC_PCUT_MAX_TIME_REG\n");
+
+fail:
+	return count;
+}
+
+static ssize_t ab8505_powercut_restart_read(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	int ret;
+	u8 reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
+		AB8505_RTC_PCUT_RESTART_REG, &reg_value);
+
+	if (ret < 0) {
+		dev_err(dev, "Failed to read AB8505_RTC_PCUT_RESTART_REG\n");
+		goto fail;
+	}
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", (reg_value & 0xF));
+
+fail:
+	return ret;
+}
+
+static ssize_t ab8505_powercut_restart_write(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	int ret;
+	unsigned long int reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	if (kstrtoul(buf, 10, &reg_value) != 0)
+		goto fail;
+
+	if (reg_value > 0xF) {
+		dev_err(dev, "Incorrect parameter, echo 0 - 15 for number of restart\n");
+		goto fail;
+	}
+
+	ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
+		AB8505_RTC_PCUT_RESTART_REG, (u8)reg_value);
+
+	if (ret < 0)
+		dev_err(dev, "Failed to set AB8505_RTC_PCUT_RESTART_REG\n");
+
+fail:
+	return count;
+
+}
+
+static ssize_t ab8505_powercut_timer_read(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	int ret;
+	u8 reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
+		AB8505_RTC_PCUT_TIME_REG, &reg_value);
+
+	if (ret < 0) {
+		dev_err(dev, "Failed to read AB8505_RTC_PCUT_TIME_REG\n");
+		goto fail;
+	}
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", (reg_value & 0x7F));
+
+fail:
+	return ret;
+}
+
+static ssize_t ab8505_powercut_restart_counter_read(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	int ret;
+	u8 reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
+		AB8505_RTC_PCUT_RESTART_REG, &reg_value);
+
+	if (ret < 0) {
+		dev_err(dev, "Failed to read AB8505_RTC_PCUT_RESTART_REG\n");
+		goto fail;
+	}
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", (reg_value & 0xF0) >> 4);
+
+fail:
+	return ret;
+}
+
+static ssize_t ab8505_powercut_read(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	int ret;
+	u8 reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
+		AB8505_RTC_PCUT_CTL_STATUS_REG, &reg_value);
+
+	if (ret < 0)
+		goto fail;
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", (reg_value & 0x1));
+
+fail:
+	return ret;
+}
+
+static ssize_t ab8505_powercut_write(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	int ret;
+	unsigned long int reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	if (kstrtoul(buf, 10, &reg_value) != 0)
+		goto fail;
+
+	if (reg_value > 0x1) {
+		dev_err(dev, "Incorrect parameter, echo 0/1 to disable/enable Pcut feature\n");
+		goto fail;
+	}
+
+	ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
+		AB8505_RTC_PCUT_CTL_STATUS_REG, (u8)reg_value);
+
+	if (ret < 0)
+		dev_err(dev, "Failed to set AB8505_RTC_PCUT_CTL_STATUS_REG\n");
+
+fail:
+	return count;
+}
+
+static ssize_t ab8505_powercut_flag_read(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+
+	int ret;
+	u8 reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
+		AB8505_RTC_PCUT_CTL_STATUS_REG,  &reg_value);
+
+	if (ret < 0) {
+		dev_err(dev, "Failed to read AB8505_RTC_PCUT_CTL_STATUS_REG\n");
+		goto fail;
+	}
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", ((reg_value & 0x10) >> 4));
+
+fail:
+	return ret;
+}
+
+static ssize_t ab8505_powercut_debounce_read(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	int ret;
+	u8 reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
+		AB8505_RTC_PCUT_DEBOUNCE_REG,  &reg_value);
+
+	if (ret < 0) {
+		dev_err(dev, "Failed to read AB8505_RTC_PCUT_DEBOUNCE_REG\n");
+		goto fail;
+	}
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", (reg_value & 0x7));
+
+fail:
+	return ret;
+}
+
+static ssize_t ab8505_powercut_debounce_write(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	int ret;
+	unsigned long int reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	if (kstrtoul(buf, 10, &reg_value) != 0)
+		goto fail;
+
+	if (reg_value > 0x7) {
+		dev_err(dev, "Incorrect parameter, echo 0 to 7 for debounce setting\n");
+		goto fail;
+	}
+
+	ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
+		AB8505_RTC_PCUT_DEBOUNCE_REG, (u8)reg_value);
+
+	if (ret < 0)
+		dev_err(dev, "Failed to set AB8505_RTC_PCUT_DEBOUNCE_REG\n");
+
+fail:
+	return count;
+}
+
+static ssize_t ab8505_powercut_enable_status_read(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	int ret;
+	u8 reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
+		AB8505_RTC_PCUT_CTL_STATUS_REG, &reg_value);
+
+	if (ret < 0) {
+		dev_err(dev, "Failed to read AB8505_RTC_PCUT_CTL_STATUS_REG\n");
+		goto fail;
+	}
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", ((reg_value & 0x20) >> 5));
+
+fail:
+	return ret;
+}
+
 static struct device_attribute ab8500_fg_sysfs_psy_attrs[] = {
 	__ATTR(capacity, S_IRUGO, ab8500_show_capacity, NULL),
 };
 
+static struct device_attribute ab8505_fg_sysfs_psy_attrs[] = {
+	__ATTR(powercut_flagtime, (S_IRUGO | S_IWUGO),
+				ab8505_powercut_flagtime_read,
+				ab8505_powercut_flagtime_write),
+	__ATTR(powercut_maxtime, (S_IRUGO | S_IWUGO),
+				ab8505_powercut_maxtime_read,
+				ab8505_powercut_maxtime_write),
+	__ATTR(powercut_restart_max, (S_IRUGO | S_IWUGO),
+				ab8505_powercut_restart_read,
+				ab8505_powercut_restart_write),
+	__ATTR(powercut_timer, S_IRUGO, ab8505_powercut_timer_read, NULL),
+	__ATTR(powercut_restart_counter, S_IRUGO,
+				ab8505_powercut_restart_counter_read, NULL),
+	__ATTR(powercut_enable, (S_IRUGO | S_IWUGO), ab8505_powercut_read,
+							 ab8505_powercut_write),
+	__ATTR(powercut_flag, S_IRUGO, ab8505_powercut_flag_read, NULL),
+	__ATTR(powercut_debounce_time, (S_IRUGO | S_IWUGO),
+				ab8505_powercut_debounce_read,
+				ab8505_powercut_debounce_write),
+	__ATTR(powercut_enable_status, S_IRUGO,
+				ab8505_powercut_enable_status_read, NULL),
+};
+
 static int ab8500_fg_sysfs_psy_create_attrs(struct device *dev)
 {
-	unsigned int i;
+	unsigned int i, j;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
 
 	for (i = 0; i < ARRAY_SIZE(ab8500_fg_sysfs_psy_attrs); i++)
 		if (device_create_file(dev, &ab8500_fg_sysfs_psy_attrs[i]))
-			goto sysfs_psy_create_attrs_failed;
+			goto sysfs_psy_create_attrs_failed_ab8500;
+
+	if ((is_ab8505(di->parent) || is_ab9540(di->parent)) &&
+			abx500_get_chip_id(dev->parent) >= AB8500_CUT2P0) {
+		for (j = 0; j < ARRAY_SIZE(ab8505_fg_sysfs_psy_attrs); j++)
+			if (device_create_file(dev,
+					&ab8505_fg_sysfs_psy_attrs[j]))
+				goto sysfs_psy_create_attrs_failed_ab8505;
+	}
 
 	return 0;
 
-sysfs_psy_create_attrs_failed:
-	dev_err(dev, "Failed creating sysfs psy attrs.\n");
+sysfs_psy_create_attrs_failed_ab8505:
+	dev_err(dev, "Failed creating sysfs psy attrs for ab8505.\n");
+	while (j--)
+		device_remove_file(dev, &ab8505_fg_sysfs_psy_attrs[i]);
+
+sysfs_psy_create_attrs_failed_ab8500:
+	dev_err(dev, "Failed creating sysfs psy attrs for ab8500.\n");
 	while (i--)
 		device_remove_file(dev, &ab8500_fg_sysfs_psy_attrs[i]);
 
@@ -2597,9 +3066,20 @@ sysfs_psy_create_attrs_failed:
 static void ab8500_fg_sysfs_psy_remove_attrs(struct device *dev)
 {
 	unsigned int i;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
 
 	for (i = 0; i < ARRAY_SIZE(ab8500_fg_sysfs_psy_attrs); i++)
 		(void)device_remove_file(dev, &ab8500_fg_sysfs_psy_attrs[i]);
+
+	if ((is_ab8505(di->parent) || is_ab9540(di->parent)) &&
+			abx500_get_chip_id(dev->parent) >= AB8500_CUT2P0) {
+		for (i = 0; i < ARRAY_SIZE(ab8505_fg_sysfs_psy_attrs); i++)
+			(void)device_remove_file(dev,
+					&ab8505_fg_sysfs_psy_attrs[i]);
+	}
 }
 /* Exposure to the sysfs interface <<END>> */
 
diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index eef1ddc..97e918f 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -204,6 +204,11 @@ struct abx500_fg;
  *				points.
  * @maint_thres			This is the threshold where we stop reporting
  *				battery full while in maintenance, in per cent
+ * @pcut_enable:		Enable power cut feature in ab8505
+ * @pcut_max_time:		Max time threshold
+ * @pcut_flag_time:		Flagtime threshold
+ * @pcut_max_restart:		Max number of restarts
+ * @pcut_debunce_time:		Sets battery debounce time
  */
 struct abx500_fg_parameters {
 	int recovery_sleep_timer;
@@ -221,6 +226,11 @@ struct abx500_fg_parameters {
 	int battok_raising_th_sel1;
 	int user_cap_limit;
 	int maint_thres;
+	bool pcut_enable;
+	u8 pcut_max_time;
+	u8 pcut_flag_time;
+	u8 pcut_max_restart;
+	u8 pcut_debunce_time;
 };
 
 /**
diff --git a/include/linux/mfd/abx500/ab8500-bm.h b/include/linux/mfd/abx500/ab8500-bm.h
index 175197c..cd15ea3 100644
--- a/include/linux/mfd/abx500/ab8500-bm.h
+++ b/include/linux/mfd/abx500/ab8500-bm.h
@@ -235,6 +235,14 @@
 /* Battery type */
 #define BATTERY_UNKNOWN			00
 
+/* Registers for pcut feature in ab8505 and ab9540 */
+#define AB8505_RTC_PCUT_CTL_STATUS_REG 0x12
+#define AB8505_RTC_PCUT_TIME_REG       0x13
+#define AB8505_RTC_PCUT_MAX_TIME_REG   0x14
+#define AB8505_RTC_PCUT_FLAG_TIME_REG  0x15
+#define AB8505_RTC_PCUT_RESTART_REG    0x16
+#define AB8505_RTC_PCUT_DEBOUNCE_REG   0x17
+
 /**
  * struct res_to_temp - defines one point in a temp to res curve. To
  * be used in battery packs that combines the identification resistor with a
-- 
1.7.5.4

