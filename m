Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab2CCLJP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 06:09:15 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63045 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab2CCLIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 06:08:36 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of amitdanielk@gmail.com designates 10.68.240.164 as permitted sender) smtp.mail=amitdanielk@gmail.com; dkim=pass header.i=amitdanielk@gmail.com
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: linux-pm@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        linaro-dev@lists.linaro.org, lm-sensors@lm-sensors.org,
        amit.kachhap@linaro.org, eduardo.valentin@ti.com,
        durgadoss.r@intel.com, patches@linaro.org
Subject: [PATCH 3/4] thermal: exynos4: Register the tmu sensor with the thermal interface layer
Date: Sat,  3 Mar 2012 16:36:06 +0530
Message-Id: <1330772767-16120-4-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1330772767-16120-1-git-send-email-amit.kachhap@linaro.org>
References: <1330772767-16120-1-git-send-email-amit.kachhap@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export and register information from the tmu temperature sensor to the samsung
exynos kernel thermal framework where different cooling devices and thermal
zone are binded. The exported information is based according to the data
structure thermal_sensor_conf present in exynos_thermal.h. HWMON sysfs
functions are removed as all of them are present in generic linux thermal layer.

Also the platform data structure is modified to pass frequency cooling
in percentages for each thermal level.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
---
 Documentation/mfd/exynos4_tmu             |   35 +-------
 drivers/mfd/exynos4_tmu.c                 |  139 +++++++----------------------
 include/linux/platform_data/exynos4_tmu.h |    7 ++
 3 files changed, 44 insertions(+), 137 deletions(-)

diff --git a/Documentation/mfd/exynos4_tmu b/Documentation/mfd/exynos4_tmu
index c3c6b41..2b46f67 100644
--- a/Documentation/mfd/exynos4_tmu
+++ b/Documentation/mfd/exynos4_tmu
@@ -46,36 +46,7 @@ The threshold levels are defined as follows:
   The threshold and each trigger_level are set
   through the corresponding registers.
 
-When an interrupt occurs, this driver notify user space of
-one of four threshold levels for the interrupt
-through kobject_uevent_env and sysfs_notify functions.
+When an interrupt occurs, this driver notify kernel thermal framework
+with the function exynos4_report_trigger.
 Although an interrupt condition for level_0 can be set,
-it is not notified to user space through sysfs_notify function.
-
-Sysfs Interface
----------------
-name		name of the temperature sensor
-		RO
-
-temp1_input	temperature
-		RO
-
-temp1_max	temperature for level_1 interrupt
-		RO
-
-temp1_crit	temperature for level_2 interrupt
-		RO
-
-temp1_emergency	temperature for level_3 interrupt
-		RO
-
-temp1_max_alarm	alarm for level_1 interrupt
-		RO
-
-temp1_crit_alarm
-		alarm for level_2 interrupt
-		RO
-
-temp1_emergency_alarm
-		alarm for level_3 interrupt
-		RO
+it can be used to synchronize the cooling action.
diff --git a/drivers/mfd/exynos4_tmu.c b/drivers/mfd/exynos4_tmu.c
index f2359a0..e343923 100644
--- a/drivers/mfd/exynos4_tmu.c
+++ b/drivers/mfd/exynos4_tmu.c
@@ -33,10 +33,10 @@
 #include <linux/io.h>
 #include <linux/mutex.h>
 
-#include <linux/hwmon.h>
-#include <linux/hwmon-sysfs.h>
-
 #include <linux/platform_data/exynos4_tmu.h>
+#ifdef CONFIG_SAMSUNG_THERMAL_INTERFACE
+#include <linux/exynos_thermal.h>
+#endif
 
 #define EXYNOS4_TMU_REG_TRIMINFO	0x0
 #define EXYNOS4_TMU_REG_CONTROL		0x20
@@ -70,7 +70,6 @@
 
 struct exynos4_tmu_data {
 	struct exynos4_tmu_platform_data *pdata;
-	struct device *hwmon_dev;
 	struct resource *mem;
 	void __iomem *base;
 	int irq;
@@ -246,12 +245,12 @@ static void exynos4_tmu_work(struct work_struct *work)
 
 	writel(EXYNOS4_TMU_INTCLEAR_VAL, data->base + EXYNOS4_TMU_REG_INTCLEAR);
 
-	kobject_uevent(&data->hwmon_dev->kobj, KOBJ_CHANGE);
-
-	enable_irq(data->irq);
-
 	clk_disable(data->clk);
 	mutex_unlock(&data->lock);
+#ifdef CONFIG_SAMSUNG_THERMAL_INTERFACE
+	exynos4_report_trigger();
+#endif
+	enable_irq(data->irq);
 }
 
 static irqreturn_t exynos4_tmu_irq(int irq, void *id)
@@ -264,92 +263,19 @@ static irqreturn_t exynos4_tmu_irq(int irq, void *id)
 	return IRQ_HANDLED;
 }
 
-static ssize_t exynos4_tmu_show_name(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	return sprintf(buf, "exynos4-tmu\n");
-}
-
-static ssize_t exynos4_tmu_show_temp(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct exynos4_tmu_data *data = dev_get_drvdata(dev);
-	int ret;
-
-	ret = exynos4_tmu_read(data);
-	if (ret < 0)
-		return ret;
-
-	/* convert from degree Celsius to millidegree Celsius */
-	return sprintf(buf, "%d\n", ret * 1000);
-}
-
-static ssize_t exynos4_tmu_show_alarm(struct device *dev,
-		struct device_attribute *devattr, char *buf)
-{
-	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
-	struct exynos4_tmu_data *data = dev_get_drvdata(dev);
-	struct exynos4_tmu_platform_data *pdata = data->pdata;
-	int temp;
-	unsigned int trigger_level;
-
-	temp = exynos4_tmu_read(data);
-	if (temp < 0)
-		return temp;
-
-	trigger_level = pdata->threshold + pdata->trigger_levels[attr->index];
-
-	return sprintf(buf, "%d\n", !!(temp > trigger_level));
-}
-
-static ssize_t exynos4_tmu_show_level(struct device *dev,
-		struct device_attribute *devattr, char *buf)
-{
-	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
-	struct exynos4_tmu_data *data = dev_get_drvdata(dev);
-	struct exynos4_tmu_platform_data *pdata = data->pdata;
-	unsigned int temp = pdata->threshold +
-			pdata->trigger_levels[attr->index];
-
-	return sprintf(buf, "%u\n", temp * 1000);
-}
-
-static DEVICE_ATTR(name, S_IRUGO, exynos4_tmu_show_name, NULL);
-static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, exynos4_tmu_show_temp, NULL, 0);
-
-static SENSOR_DEVICE_ATTR(temp1_max_alarm, S_IRUGO,
-		exynos4_tmu_show_alarm, NULL, 1);
-static SENSOR_DEVICE_ATTR(temp1_crit_alarm, S_IRUGO,
-		exynos4_tmu_show_alarm, NULL, 2);
-static SENSOR_DEVICE_ATTR(temp1_emergency_alarm, S_IRUGO,
-		exynos4_tmu_show_alarm, NULL, 3);
-
-static SENSOR_DEVICE_ATTR(temp1_max, S_IRUGO, exynos4_tmu_show_level, NULL, 1);
-static SENSOR_DEVICE_ATTR(temp1_crit, S_IRUGO, exynos4_tmu_show_level, NULL, 2);
-static SENSOR_DEVICE_ATTR(temp1_emergency, S_IRUGO,
-		exynos4_tmu_show_level, NULL, 3);
-
-static struct attribute *exynos4_tmu_attributes[] = {
-	&dev_attr_name.attr,
-	&sensor_dev_attr_temp1_input.dev_attr.attr,
-	&sensor_dev_attr_temp1_max_alarm.dev_attr.attr,
-	&sensor_dev_attr_temp1_crit_alarm.dev_attr.attr,
-	&sensor_dev_attr_temp1_emergency_alarm.dev_attr.attr,
-	&sensor_dev_attr_temp1_max.dev_attr.attr,
-	&sensor_dev_attr_temp1_crit.dev_attr.attr,
-	&sensor_dev_attr_temp1_emergency.dev_attr.attr,
-	NULL,
-};
-
-static const struct attribute_group exynos4_tmu_attr_group = {
-	.attrs = exynos4_tmu_attributes,
+#ifdef CONFIG_SAMSUNG_THERMAL_INTERFACE
+static struct thermal_sensor_conf exynos4_sensor_conf = {
+	.name			= "exynos4-therm",
+	.read_temperature	= (int (*)(void *))exynos4_tmu_read,
 };
+#endif
+/*CONFIG_SAMSUNG_THERMAL_INTERFACE*/
 
 static int __devinit exynos4_tmu_probe(struct platform_device *pdev)
 {
 	struct exynos4_tmu_data *data;
 	struct exynos4_tmu_platform_data *pdata = pdev->dev.platform_data;
-	int ret;
+	int ret, i;
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "No platform init data supplied.\n");
@@ -418,25 +344,27 @@ static int __devinit exynos4_tmu_probe(struct platform_device *pdev)
 		goto err_clk;
 	}
 
-	ret = sysfs_create_group(&pdev->dev.kobj, &exynos4_tmu_attr_group);
+	exynos4_tmu_control(pdev, true);
+#ifdef CONFIG_SAMSUNG_THERMAL_INTERFACE
+	(&exynos4_sensor_conf)->private_data = data;
+	exynos4_sensor_conf.trip_data.trip_count = 3;
+	for (i = 0; i < exynos4_sensor_conf.trip_data.trip_count; i++)
+		exynos4_sensor_conf.trip_data.trip_val[i] =
+			pdata->threshold + pdata->trigger_levels[i + 1];
+
+	exynos4_sensor_conf.cooling_data.freq_pctg_count =
+						pdata->freq_tab_count;
+	for (i = 0; i < pdata->freq_tab_count; i++)
+		exynos4_sensor_conf.cooling_data.freq_data[i].freq_clip_pctg =
+					pdata->freq_tab[i].freq_clip_pctg;
+
+	ret = exynos4_register_thermal(&exynos4_sensor_conf);
 	if (ret) {
-		dev_err(&pdev->dev, "Failed to create sysfs group\n");
+		dev_err(&pdev->dev, "Failed to register thermal interface\n");
 		goto err_clk;
 	}
-
-	data->hwmon_dev = hwmon_device_register(&pdev->dev);
-	if (IS_ERR(data->hwmon_dev)) {
-		ret = PTR_ERR(data->hwmon_dev);
-		dev_err(&pdev->dev, "Failed to register hwmon device\n");
-		goto err_create_group;
-	}
-
-	exynos4_tmu_control(pdev, true);
-
+#endif
 	return 0;
-
-err_create_group:
-	sysfs_remove_group(&pdev->dev.kobj, &exynos4_tmu_attr_group);
 err_clk:
 	platform_set_drvdata(pdev, NULL);
 	clk_put(data->clk);
@@ -458,8 +386,9 @@ static int __devexit exynos4_tmu_remove(struct platform_device *pdev)
 
 	exynos4_tmu_control(pdev, false);
 
-	hwmon_device_unregister(data->hwmon_dev);
-	sysfs_remove_group(&pdev->dev.kobj, &exynos4_tmu_attr_group);
+#ifdef CONFIG_SAMSUNG_THERMAL_INTERFACE
+	exynos4_unregister_thermal();
+#endif
 
 	clk_put(data->clk);
 
diff --git a/include/linux/platform_data/exynos4_tmu.h b/include/linux/platform_data/exynos4_tmu.h
index 39e038c..642c508 100644
--- a/include/linux/platform_data/exynos4_tmu.h
+++ b/include/linux/platform_data/exynos4_tmu.h
@@ -21,6 +21,7 @@
 
 #ifndef _LINUX_EXYNOS4_TMU_H
 #define _LINUX_EXYNOS4_TMU_H
+#include <linux/cpu_cooling.h>
 
 enum calibration_type {
 	TYPE_ONE_POINT_TRIMMING,
@@ -64,6 +65,9 @@ enum calibration_type {
  *	in the positive-TC generator block
  *	0 <= reference_voltage <= 31
  * @cal_type: calibration type for temperature
+ * @freq_pctg_table: Table representing frequency reduction percentage.
+ * @freq_tab_count: Count of the above table as frequency reduction may
+ *	applicable to only some of the trigger levels.
  *
  * This structure is required for configuration of exynos4_tmu driver.
  */
@@ -79,5 +83,8 @@ struct exynos4_tmu_platform_data {
 	u8 reference_voltage;
 
 	enum calibration_type cal_type;
+
+	struct freq_pctg_table freq_tab[4];
+	unsigned int freq_tab_count;
 };
 #endif /* _LINUX_EXYNOS4_TMU_H */
-- 
1.7.1

