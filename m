Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab1LUMB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:01:29 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58812 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab1LUMA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:00:58 -0500
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: linux-pm@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        linaro-dev@lists.linaro.org, lm-sensors@lm-sensors.org,
        amit.kachhap@linaro.org, patches@linaro.org
Subject: [RFC PATCH 2/3] thermal: exynos4: Register the tmu sensor with the thermal interface layer
Date: Wed, 21 Dec 2011 17:29:57 +0530
Message-Id: <1324468798-20423-3-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1324468798-20423-1-git-send-email-amit.kachhap@linaro.org>
References: <1324468798-20423-1-git-send-email-amit.kachhap@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export and register information from the hwmon tmu sensor to the samsung
exynos kernel thermal framework where different cooling devices and thermal
zone are binded. The exported information is based according to the data
structure thermal_sensor_conf present in exynos_thermal.h. HWMON sysfs
functions are currently left although all of them are present in generic
linux thermal layer.
Also the platform data structure is modified to pass frequency cooling
in percentages for each thermal level.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
---
 drivers/hwmon/exynos4_tmu.c               |   34 ++++++++++++++++++++++++++--
 include/linux/platform_data/exynos4_tmu.h |    7 ++++++
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/exynos4_tmu.c b/drivers/hwmon/exynos4_tmu.c
index f2359a0..6912a7f 100644
--- a/drivers/hwmon/exynos4_tmu.c
+++ b/drivers/hwmon/exynos4_tmu.c
@@ -37,6 +37,9 @@
 #include <linux/hwmon-sysfs.h>
 
 #include <linux/platform_data/exynos4_tmu.h>
+#ifdef CONFIG_SAMSUNG_THERMAL_INTERFACE
+#include <linux/exynos_thermal.h>
+#endif
 
 #define EXYNOS4_TMU_REG_TRIMINFO	0x0
 #define EXYNOS4_TMU_REG_CONTROL		0x20
@@ -248,10 +251,13 @@ static void exynos4_tmu_work(struct work_struct *work)
 
 	kobject_uevent(&data->hwmon_dev->kobj, KOBJ_CHANGE);
 
-	enable_irq(data->irq);
 
 	clk_disable(data->clk);
 	mutex_unlock(&data->lock);
+#ifdef CONFIG_SAMSUNG_THERMAL_INTERFACE
+	exynos4_report_trigger();
+#endif
+	enable_irq(data->irq);
 }
 
 static irqreturn_t exynos4_tmu_irq(int irq, void *id)
@@ -345,6 +351,14 @@ static const struct attribute_group exynos4_tmu_attr_group = {
 	.attrs = exynos4_tmu_attributes,
 };
 
+#ifdef CONFIG_SAMSUNG_THERMAL_INTERFACE
+static struct thermal_sensor_conf exynos4_sensor_conf = {
+	.name			= "exynos4-therm",
+	.read_temperature	= (int (*)(void *))exynos4_tmu_read,
+};
+#endif
+/*CONFIG_SAMSUNG_THERMAL_INTERFACE*/
+
 static int __devinit exynos4_tmu_probe(struct platform_device *pdev)
 {
 	struct exynos4_tmu_data *data;
@@ -432,9 +446,20 @@ static int __devinit exynos4_tmu_probe(struct platform_device *pdev)
 	}
 
 	exynos4_tmu_control(pdev, true);
-
+#ifdef CONFIG_SAMSUNG_THERMAL_INTERFACE
+	(&exynos4_sensor_conf)->private_data = data;
+	(&exynos4_sensor_conf)->sensor_data = pdata;
+	ret = exynos4_register_thermal(&exynos4_sensor_conf);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to register thermal interface\n");
+		goto err_hwmon_device;
+	}
+#endif
 	return 0;
-
+#ifdef CONFIG_SAMSUNG_THERMAL_INTERFACE
+err_hwmon_device:
+	hwmon_device_unregister(data->hwmon_dev);
+#endif
 err_create_group:
 	sysfs_remove_group(&pdev->dev.kobj, &exynos4_tmu_attr_group);
 err_clk:
@@ -458,6 +483,9 @@ static int __devexit exynos4_tmu_remove(struct platform_device *pdev)
 
 	exynos4_tmu_control(pdev, false);
 
+#ifdef CONFIG_SAMSUNG_THERMAL_INTERFACE
+	exynos4_unregister_thermal();
+#endif
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&pdev->dev.kobj, &exynos4_tmu_attr_group);
 
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

