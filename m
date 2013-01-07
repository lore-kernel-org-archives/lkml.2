Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab3AGAOl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 19:14:41 -0500
Received: from mail-gh0-f179.google.com ([209.85.160.179]:63901 "EHLO
	mail-gh0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab3AGAOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 19:14:38 -0500
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>
Cc: jonghwa3.lee@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] thermal: exynos: Use the framework for temperature emulation support
Date: Sun,  6 Jan 2013 16:08:16 -0800
Message-Id: <1357517296-31402-2-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1357517296-31402-1-git-send-email-amit.daniel@samsung.com>
References: <1357517296-31402-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the driver specific sysfs support of the temperature
emulation and uses the newly added core thermal framework for thermal
emulation. A platform specific handler is added to support this.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 Documentation/thermal/exynos_thermal_emulation |    6 +-
 drivers/thermal/exynos_thermal.c               |  154 ++++++++++--------------
 2 files changed, 64 insertions(+), 96 deletions(-)

diff --git a/Documentation/thermal/exynos_thermal_emulation b/Documentation/thermal/exynos_thermal_emulation
index b73bbfb..570a52d 100644
--- a/Documentation/thermal/exynos_thermal_emulation
+++ b/Documentation/thermal/exynos_thermal_emulation
@@ -14,10 +14,10 @@ manually with software code and TMU will read current temperature from user valu
 sensor's value.
 
 Enabling CONFIG_EXYNOS_THERMAL_EMUL option will make this support in available.
-When it's enabled, sysfs node will be created under
-/sys/bus/platform/devices/'exynos device name'/ with name of 'emulation'.
+When it's enabled, sysfs node will be created as
+/sys/devices/virtual/thermal/thermal_zone'zone id'/emul_temp.
 
-The sysfs node, 'emulation', will contain value 0 for the initial state. When you input any
+The sysfs node, 'emul_node', will contain value 0 for the initial state. When you input any
 temperature you want to update to sysfs node, it automatically enable emulation mode and
 current temperature will be changed into it.
 (Exynos also supports user changable delay time which would be used to delay of
diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
index 68c9280..a657903 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -145,6 +145,7 @@ struct	thermal_cooling_conf {
 struct thermal_sensor_conf {
 	char name[SENSOR_NAME_LEN];
 	int (*read_temperature)(void *data);
+	int (*write_emul_temp)(void *data, unsigned long temp);
 	struct thermal_trip_point_conf trip_data;
 	struct thermal_cooling_conf cooling_data;
 	void *private_data;
@@ -369,6 +370,23 @@ static int exynos_get_temp(struct thermal_zone_device *thermal,
 	return 0;
 }
 
+/* Get temperature callback functions for thermal zone */
+static int exynos_set_emul_temp(struct thermal_zone_device *thermal,
+						unsigned long temp)
+{
+	void *data;
+	int ret = -EINVAL;
+
+	if (!th_zone->sensor_conf) {
+		pr_info("Temperature sensor not initialised\n");
+		return -EINVAL;
+	}
+	data = th_zone->sensor_conf->private_data;
+	if (th_zone->sensor_conf->write_emul_temp)
+		ret = th_zone->sensor_conf->write_emul_temp(data, temp);
+	return ret;
+}
+
 /* Get the temperature trend */
 static int exynos_get_trend(struct thermal_zone_device *thermal,
 			int trip, enum thermal_trend *trend)
@@ -392,6 +410,7 @@ static struct thermal_zone_device_ops const exynos_dev_ops = {
 	.bind = exynos_bind,
 	.unbind = exynos_unbind,
 	.get_temp = exynos_get_temp,
+	.set_emul_temp = exynos_set_emul_temp,
 	.get_trend = exynos_get_trend,
 	.get_mode = exynos_get_mode,
 	.set_mode = exynos_set_mode,
@@ -714,6 +733,44 @@ static int exynos_tmu_read(struct exynos_tmu_data *data)
 	return temp;
 }
 
+#ifdef CONFIG_EXYNOS_THERMAL_EMUL
+static int exynos_tmu_set_emulation(struct exynos_tmu_data *data,
+					unsigned long temp)
+{
+	unsigned int reg;
+	int ret = -EINVAL;
+
+	if (data->soc == SOC_ARCH_EXYNOS4210)
+		goto out;
+
+	if (temp && temp < MCELSIUS)
+		goto out;
+
+	mutex_lock(&data->lock);
+	clk_enable(data->clk);
+
+	reg = readl(data->base + EXYNOS_EMUL_CON);
+
+	if (temp) {
+		temp /= MCELSIUS;
+
+		reg = (EXYNOS_EMUL_TIME << EXYNOS_EMUL_TIME_SHIFT) |
+			(temp_to_code(data, temp)
+			 << EXYNOS_EMUL_DATA_SHIFT) | EXYNOS_EMUL_ENABLE;
+	} else {
+		reg &= ~EXYNOS_EMUL_ENABLE;
+	}
+
+	writel(reg, data->base + EXYNOS_EMUL_CON);
+
+	clk_disable(data->clk);
+	mutex_unlock(&data->lock);
+	return 0;
+out:
+	return ret;
+}
+#endif/*CONFIG_EXYNOS_THERMAL_EMUL*/
+
 static void exynos_tmu_work(struct work_struct *work)
 {
 	struct exynos_tmu_data *data = container_of(work,
@@ -853,93 +910,6 @@ static inline struct  exynos_tmu_platform_data *exynos_get_driver_data(
 			platform_get_device_id(pdev)->driver_data;
 }
 
-#ifdef CONFIG_EXYNOS_THERMAL_EMUL
-static ssize_t exynos_tmu_emulation_show(struct device *dev,
-					 struct device_attribute *attr,
-					 char *buf)
-{
-	struct platform_device *pdev = container_of(dev,
-					struct platform_device, dev);
-	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
-	unsigned int reg;
-	u8 temp_code;
-	int temp = 0;
-
-	if (data->soc == SOC_ARCH_EXYNOS4210)
-		goto out;
-
-	mutex_lock(&data->lock);
-	clk_enable(data->clk);
-	reg = readl(data->base + EXYNOS_EMUL_CON);
-	clk_disable(data->clk);
-	mutex_unlock(&data->lock);
-
-	if (reg & EXYNOS_EMUL_ENABLE) {
-		reg >>= EXYNOS_EMUL_DATA_SHIFT;
-		temp_code = reg & EXYNOS_EMUL_DATA_MASK;
-		temp = code_to_temp(data, temp_code);
-	}
-out:
-	return sprintf(buf, "%d\n", temp * MCELSIUS);
-}
-
-static ssize_t exynos_tmu_emulation_store(struct device *dev,
-					struct device_attribute *attr,
-					const char *buf, size_t count)
-{
-	struct platform_device *pdev = container_of(dev,
-					struct platform_device, dev);
-	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
-	unsigned int reg;
-	int temp;
-
-	if (data->soc == SOC_ARCH_EXYNOS4210)
-		goto out;
-
-	if (!sscanf(buf, "%d\n", &temp) || temp < 0)
-		return -EINVAL;
-
-	mutex_lock(&data->lock);
-	clk_enable(data->clk);
-
-	reg = readl(data->base + EXYNOS_EMUL_CON);
-
-	if (temp) {
-		/* Both CELSIUS and MCELSIUS type are available for input */
-		if (temp > MCELSIUS)
-			temp /= MCELSIUS;
-
-		reg = (EXYNOS_EMUL_TIME << EXYNOS_EMUL_TIME_SHIFT) |
-			(temp_to_code(data, (temp / MCELSIUS))
-			 << EXYNOS_EMUL_DATA_SHIFT) | EXYNOS_EMUL_ENABLE;
-	} else {
-		reg &= ~EXYNOS_EMUL_ENABLE;
-	}
-
-	writel(reg, data->base + EXYNOS_EMUL_CON);
-
-	clk_disable(data->clk);
-	mutex_unlock(&data->lock);
-
-out:
-	return count;
-}
-
-static DEVICE_ATTR(emulation, 0644, exynos_tmu_emulation_show,
-					exynos_tmu_emulation_store);
-static int create_emulation_sysfs(struct device *dev)
-{
-	return device_create_file(dev, &dev_attr_emulation);
-}
-static void remove_emulation_sysfs(struct device *dev)
-{
-	device_remove_file(dev, &dev_attr_emulation);
-}
-#else
-static inline int create_emulation_sysfs(struct device *dev) { return 0; }
-static inline void remove_emulation_sysfs(struct device *dev) {}
-#endif
-
 static int __devinit exynos_tmu_probe(struct platform_device *pdev)
 {
 	struct exynos_tmu_data *data;
@@ -1016,6 +986,10 @@ static int __devinit exynos_tmu_probe(struct platform_device *pdev)
 
 	/* Register the sensor with thermal management interface */
 	(&exynos_sensor_conf)->private_data = data;
+#ifdef CONFIG_EXYNOS_THERMAL_EMUL
+	(&exynos_sensor_conf)->write_emul_temp =
+		(int (*)(void *, unsigned long))exynos_tmu_set_emulation;
+#endif
 	exynos_sensor_conf.trip_data.trip_count = pdata->trigger_level0_en +
 			pdata->trigger_level1_en + pdata->trigger_level2_en +
 			pdata->trigger_level3_en;
@@ -1041,10 +1015,6 @@ static int __devinit exynos_tmu_probe(struct platform_device *pdev)
 		goto err_clk;
 	}
 
-	ret = create_emulation_sysfs(&pdev->dev);
-	if (ret)
-		dev_err(&pdev->dev, "Failed to create emulation mode sysfs node\n");
-
 	return 0;
 err_clk:
 	platform_set_drvdata(pdev, NULL);
@@ -1056,8 +1026,6 @@ static int __devexit exynos_tmu_remove(struct platform_device *pdev)
 {
 	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
 
-	remove_emulation_sysfs(&pdev->dev);
-
 	exynos_tmu_control(pdev, false);
 
 	exynos_unregister_thermal();
-- 
1.7.5.4

