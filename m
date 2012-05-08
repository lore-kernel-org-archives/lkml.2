Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab2EHQTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 12:19:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56888 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757297Ab2EHQTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 12:19:00 -0400
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: akpm@linux-foundation.org, linux-pm@lists.linux-foundation.org
Cc: durgadoss.r@intel.com, linux-acpi@vger.kernel.org, lenb@kernel.org,
        rui.zhang@intel.com, amit.kachhap@linaro.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org
Subject: [PATCH v3 5/6] thermal: exynos: Register the tmu sensor with the kernel thermal layer
Date: Tue,  8 May 2012 21:48:17 +0530
Message-Id: <1336493898-7039-6-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1336493898-7039-5-git-send-email-amit.kachhap@linaro.org>
References: <1336493898-7039-1-git-send-email-amit.kachhap@linaro.org>
 <1336493898-7039-2-git-send-email-amit.kachhap@linaro.org>
 <1336493898-7039-3-git-send-email-amit.kachhap@linaro.org>
 <1336493898-7039-4-git-send-email-amit.kachhap@linaro.org>
 <1336493898-7039-5-git-send-email-amit.kachhap@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code added creates a link between temperature sensors, linux thermal
framework and cooling devices for samsung exynos platform. This layer
monitors the temperature from the sensor and informs the generic thermal
layer to take the necessary cooling action.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
---
 drivers/thermal/exynos_thermal.c             |  325 +++++++++++++++++++++++++-
 include/linux/platform_data/exynos_thermal.h |    6 +
 2 files changed, 329 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
index 0966b4a..f818432 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -35,6 +35,9 @@
 #include <linux/mutex.h>
 #include <linux/err.h>
 #include <linux/platform_data/exynos_thermal.h>
+#include <linux/thermal.h>
+#include <linux/cpufreq.h>
+#include <linux/cpu_cooling.h>
 #include <linux/of.h>
 
 #include <plat/cpu.h>
@@ -117,6 +120,296 @@ struct exynos_tmu_data {
 	u8 temp_error1, temp_error2;
 };
 
+struct	thermal_trip_point_conf {
+	int trip_val[MAX_TRIP_COUNT];
+	int trip_count;
+};
+
+struct	thermal_cooling_conf {
+	struct freq_clip_table freq_data[MAX_TRIP_COUNT];
+	int freq_clip_count;
+};
+
+struct thermal_sensor_conf {
+	char name[SENSOR_NAME_LEN];
+	int (*read_temperature)(void *data);
+	struct thermal_trip_point_conf trip_data;
+	struct thermal_cooling_conf cooling_data;
+	void *private_data;
+};
+
+struct exynos_thermal_zone {
+	enum thermal_device_mode mode;
+	struct thermal_zone_device *therm_dev;
+	struct thermal_cooling_device *cool_dev[MAX_COOLING_DEVICE];
+	unsigned int cool_dev_size;
+	struct platform_device *exynos4_dev;
+	struct thermal_sensor_conf *sensor_conf;
+};
+
+static struct exynos_thermal_zone *th_zone;
+static void exynos_unregister_thermal(void);
+static int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf);
+
+/* Get mode callback functions for thermal zone */
+static int exynos_get_mode(struct thermal_zone_device *thermal,
+			enum thermal_device_mode *mode)
+{
+	if (th_zone)
+		*mode = th_zone->mode;
+	return 0;
+}
+
+/* Set mode callback functions for thermal zone */
+static int exynos_set_mode(struct thermal_zone_device *thermal,
+			enum thermal_device_mode mode)
+{
+	if (!th_zone->therm_dev) {
+		pr_notice("thermal zone not registered\n");
+		return 0;
+	}
+
+	mutex_lock(&th_zone->therm_dev->lock);
+
+	if (mode == THERMAL_DEVICE_ENABLED)
+		th_zone->therm_dev->polling_delay = IDLE_INTERVAL;
+	else
+		th_zone->therm_dev->polling_delay = 0;
+
+	mutex_unlock(&th_zone->therm_dev->lock);
+
+	th_zone->mode = mode;
+	thermal_zone_device_update(th_zone->therm_dev);
+	pr_info("thermal polling set for duration=%d msec\n",
+				th_zone->therm_dev->polling_delay);
+	return 0;
+}
+
+/*
+ * This function may be called from interrupt based temperature sensor
+ * when threshold is changed.
+ */
+static void exynos_report_trigger(void)
+{
+	unsigned int i;
+	char data[2];
+	char *envp[] = { data, NULL };
+
+	if (!th_zone || !th_zone->therm_dev)
+		return;
+
+	thermal_zone_device_update(th_zone->therm_dev);
+
+	mutex_lock(&th_zone->therm_dev->lock);
+	/* Find the level for which trip happened */
+	for (i = 0; i < th_zone->sensor_conf->trip_data.trip_count; i++) {
+		if (th_zone->therm_dev->last_temperature <
+			th_zone->sensor_conf->trip_data.trip_val[i] * 1000)
+			break;
+	}
+
+	if (th_zone->mode == THERMAL_DEVICE_ENABLED) {
+		if (i > 0)
+			th_zone->therm_dev->polling_delay = ACTIVE_INTERVAL;
+		else
+			th_zone->therm_dev->polling_delay = IDLE_INTERVAL;
+	}
+
+	sprintf(data, "%u", i);
+	kobject_uevent_env(&th_zone->therm_dev->device.kobj, KOBJ_CHANGE, envp);
+	mutex_unlock(&th_zone->therm_dev->lock);
+}
+
+/* Get trip type callback functions for thermal zone */
+static int exynos_get_trip_type(struct thermal_zone_device *thermal, int trip,
+				 enum thermal_trip_type *type)
+{
+	switch (GET_ZONE(trip)) {
+	case MONITOR_ZONE:
+	case WARN_ZONE:
+		*type = THERMAL_TRIP_STATE_INSTANCE;
+		break;
+	case PANIC_ZONE:
+		*type = THERMAL_TRIP_CRITICAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/* Get trip temperature callback functions for thermal zone */
+static int exynos_get_trip_temp(struct thermal_zone_device *thermal, int trip,
+				unsigned long *temp)
+{
+	if (trip < 0 || trip > 2)
+		return -EINVAL;
+
+	*temp = th_zone->sensor_conf->trip_data.trip_val[trip];
+	/* convert the temperature into millicelsius */
+	*temp = *temp * 1000;
+
+	return 0;
+}
+
+/* Get critical temperature callback functions for thermal zone */
+static int exynos_get_crit_temp(struct thermal_zone_device *thermal,
+				unsigned long *temp)
+{
+	int ret = 0;
+	/* Panic zone */
+	ret = exynos_get_trip_temp(thermal, GET_TRIP(PANIC_ZONE), temp);
+	return ret;
+}
+
+/* Bind callback functions for thermal zone */
+static int exynos_bind(struct thermal_zone_device *thermal,
+			struct thermal_cooling_device *cdev)
+{
+	int ret = 0;
+
+	/* if the cooling device is the one from exynos4 bind it */
+	if (cdev != th_zone->cool_dev[0])
+		return 0;
+
+	if (thermal_zone_bind_cooling_device(thermal, 0, cdev)) {
+		pr_err("error binding cooling dev inst 0\n");
+		return -EINVAL;
+	}
+	if (thermal_zone_bind_cooling_device(thermal, 1, cdev)) {
+		pr_err("error binding cooling dev inst 1\n");
+		ret = -EINVAL;
+		goto error_bind1;
+	}
+
+	return ret;
+error_bind1:
+	thermal_zone_unbind_cooling_device(thermal, 0, cdev);
+	return ret;
+}
+
+/* Unbind callback functions for thermal zone */
+static int exynos_unbind(struct thermal_zone_device *thermal,
+			struct thermal_cooling_device *cdev)
+{
+	int ret = 0;
+
+	if (cdev != th_zone->cool_dev[0])
+		return 0;
+
+	if (thermal_zone_unbind_cooling_device(thermal, 0, cdev)) {
+		pr_err("error unbinding cooling dev inst 0\n");
+		ret = -EINVAL;
+	}
+	if (thermal_zone_unbind_cooling_device(thermal, 1, cdev)) {
+		pr_err("error unbinding cooling dev inst 1\n");
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+/* Get temperature callback functions for thermal zone */
+static int exynos_get_temp(struct thermal_zone_device *thermal,
+			unsigned long *temp)
+{
+	void *data;
+
+	if (!th_zone->sensor_conf) {
+		pr_info("Temperature sensor not initialised\n");
+		return -EINVAL;
+	}
+	data = th_zone->sensor_conf->private_data;
+	*temp = th_zone->sensor_conf->read_temperature(data);
+	/* convert the temperature into millicelsius */
+	*temp = *temp * 1000;
+	return 0;
+}
+
+/* Operation callback functions for thermal zone */
+static struct thermal_zone_device_ops exynos_dev_ops = {
+	.bind = exynos_bind,
+	.unbind = exynos_unbind,
+	.get_temp = exynos_get_temp,
+	.get_mode = exynos_get_mode,
+	.set_mode = exynos_set_mode,
+	.get_trip_type = exynos_get_trip_type,
+	.get_trip_temp = exynos_get_trip_temp,
+	.get_crit_temp = exynos_get_crit_temp,
+};
+
+/* Register with the in-kernel thermal management */
+static int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf)
+{
+	int ret, count, tab_size;
+	struct freq_clip_table *tab_ptr;
+
+	if (!sensor_conf || !sensor_conf->read_temperature) {
+		pr_err("Temperature sensor not initialised\n");
+		return -EINVAL;
+	}
+
+	th_zone = kzalloc(sizeof(struct exynos_thermal_zone), GFP_KERNEL);
+	if (!th_zone) {
+		ret = -ENOMEM;
+		goto err_unregister;
+	}
+
+	th_zone->sensor_conf = sensor_conf;
+
+	tab_ptr = (struct freq_clip_table *)sensor_conf->cooling_data.freq_data;
+	tab_size = sensor_conf->cooling_data.freq_clip_count;
+
+	/* Register the cpufreq cooling device */
+	th_zone->cool_dev_size = 1;
+	count = 0;
+	th_zone->cool_dev[count] = cpufreq_cooling_register(
+			(struct freq_clip_table *)&(tab_ptr[count]),
+			tab_size, cpumask_of(0));
+
+	if (IS_ERR(th_zone->cool_dev[count])) {
+		pr_err("Failed to register cpufreq cooling device\n");
+		ret = -EINVAL;
+		th_zone->cool_dev_size = 0;
+		goto err_unregister;
+	}
+
+	th_zone->therm_dev = thermal_zone_device_register(sensor_conf->name,
+			3, NULL, &exynos_dev_ops, 0, 0, 0, IDLE_INTERVAL);
+
+	if (IS_ERR(th_zone->therm_dev)) {
+		pr_err("Failed to register thermal zone device\n");
+		ret = -EINVAL;
+		goto err_unregister;
+	}
+	th_zone->mode = THERMAL_DEVICE_ENABLED;
+
+	pr_info("Exynos: Kernel Thermal management registered\n");
+
+	return 0;
+
+err_unregister:
+	exynos_unregister_thermal();
+	return ret;
+}
+
+/* Un-Register with the in-kernel thermal management */
+static void exynos_unregister_thermal(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < th_zone->cool_dev_size; i++) {
+		if (th_zone && th_zone->cool_dev[i])
+			cpufreq_cooling_unregister(th_zone->cool_dev[i]);
+	}
+
+	if (th_zone && th_zone->therm_dev)
+		thermal_zone_device_unregister(th_zone->therm_dev);
+
+	kfree(th_zone);
+
+	pr_info("Exynos: Kernel Thermal management unregistered\n");
+}
+
 /*
  * TMU treats temperature as a mapped temperature code.
  * The temperature is converted differently depending on the calibration type.
@@ -337,6 +630,7 @@ static void exynos_tmu_work(struct work_struct *work)
 
 	clk_disable(data->clk);
 	mutex_unlock(&data->lock);
+	exynos_report_trigger();
 	enable_irq(data->irq);
 }
 
@@ -349,12 +643,16 @@ static irqreturn_t exynos_tmu_irq(int irq, void *id)
 
 	return IRQ_HANDLED;
 }
-
+static struct thermal_sensor_conf exynos_sensor_conf = {
+	.name			= "exynos-therm",
+	.read_temperature	= (int (*)(void *))exynos_tmu_read,
+}
+;
 static int __devinit exynos_tmu_probe(struct platform_device *pdev)
 {
 	struct exynos_tmu_data *data;
 	struct exynos_tmu_platform_data *pdata = pdev->dev.platform_data;
-	int ret;
+	int ret, i;
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "No platform init data supplied.\n");
@@ -432,6 +730,27 @@ static int __devinit exynos_tmu_probe(struct platform_device *pdev)
 
 	exynos_tmu_control(pdev, true);
 
+	/*Register the sensor with thermal management interface*/
+	(&exynos_sensor_conf)->private_data = data;
+	exynos_sensor_conf.trip_data.trip_count = pdata->trigger_level0_en +
+			pdata->trigger_level1_en + pdata->trigger_level2_en +
+			pdata->trigger_level3_en;
+
+	for (i = 0; i < exynos_sensor_conf.trip_data.trip_count; i++)
+		exynos_sensor_conf.trip_data.trip_val[i] =
+			pdata->threshold + pdata->trigger_levels[i];
+
+	exynos_sensor_conf.cooling_data.freq_clip_count =
+						pdata->freq_tab_count;
+	for (i = 0; i < pdata->freq_tab_count; i++)
+		exynos_sensor_conf.cooling_data.freq_data[i].freq_clip_max =
+					pdata->freq_tab[i].freq_clip_max;
+
+	ret = exynos_register_thermal(&exynos_sensor_conf);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to register thermal interface\n");
+		goto err_clk;
+	}
 	return 0;
 err_clk:
 	platform_set_drvdata(pdev, NULL);
@@ -454,6 +773,8 @@ static int __devexit exynos_tmu_remove(struct platform_device *pdev)
 
 	exynos_tmu_control(pdev, false);
 
+	exynos_unregister_thermal();
+
 	clk_put(data->clk);
 
 	free_irq(data->irq, data);
diff --git a/include/linux/platform_data/exynos_thermal.h b/include/linux/platform_data/exynos_thermal.h
index c980af6..858eaca 100644
--- a/include/linux/platform_data/exynos_thermal.h
+++ b/include/linux/platform_data/exynos_thermal.h
@@ -21,6 +21,7 @@
 
 #ifndef _LINUX_EXYNOS_THERMAL_H
 #define _LINUX_EXYNOS_THERMAL_H
+#include <linux/cpu_cooling.h>
 
 enum calibration_type {
 	TYPE_ONE_POINT_TRIMMING,
@@ -72,6 +73,9 @@ enum soc_type {
  * @type: determines the type of SOC
  * @efuse_value: platform defined fuse value
  * @cal_type: calibration type for temperature
+ * @freq_clip_table: Table representing frequency reduction percentage.
+ * @freq_tab_count: Count of the above table as frequency reduction may
+ *	applicable to only some of the trigger levels.
  *
  * This structure is required for configuration of exynos_tmu driver.
  */
@@ -90,5 +94,7 @@ struct exynos_tmu_platform_data {
 
 	enum calibration_type cal_type;
 	enum soc_type type;
+	struct freq_clip_table freq_tab[4];
+	unsigned int freq_tab_count;
 };
 #endif /* _LINUX_EXYNOS_THERMAL_H */
-- 
1.7.1

