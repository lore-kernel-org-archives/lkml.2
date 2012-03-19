Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030286Ab2CSGSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:18:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39826 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679Ab2CSGSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 02:18:30 -0400
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: linux-pm@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        linaro-dev@lists.linaro.org, lm-sensors@lm-sensors.org,
        amit.kachhap@linaro.org, patches@linaro.org, eduardo.valentin@ti.com,
        durgadoss.r@intel.com
Subject: [PATCH V2 5/6] thermal: exynos4: Register the tmu sensor with the kernel thermal layer
Date: Mon, 19 Mar 2012 11:47:43 +0530
Message-Id: <1332137864-12943-6-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1332137864-12943-1-git-send-email-amit.kachhap@linaro.org>
References: <1332137864-12943-1-git-send-email-amit.kachhap@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code added creates a link between temperature sensors, linux thermal
framework and cooling devices for samsung exynos platform. This layer
monitors the temperature from the sensor and informs the generic thermal
layer to take the necessary cooling action.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
---
 drivers/thermal/exynos4_thermal.c         |  342 ++++++++++++++++++++++++++++-
 include/linux/platform_data/exynos4_tmu.h |    7 +
 2 files changed, 345 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/exynos4_thermal.c b/drivers/thermal/exynos4_thermal.c
index ff708d5..e5be944 100644
--- a/drivers/thermal/exynos4_thermal.c
+++ b/drivers/thermal/exynos4_thermal.c
@@ -33,8 +33,11 @@
 #include <linux/kobject.h>
 #include <linux/io.h>
 #include <linux/mutex.h>
-
+#include <linux/err.h>
 #include <linux/platform_data/exynos4_tmu.h>
+#include <linux/thermal.h>
+#include <linux/cpufreq.h>
+#include <linux/cpu_cooling.h>
 
 #define EXYNOS4_TMU_REG_TRIMINFO	0x0
 #define EXYNOS4_TMU_REG_CONTROL		0x20
@@ -66,6 +69,22 @@
 #define EXYNOS4_TMU_TRIG_LEVEL3_MASK	0x1000
 #define EXYNOS4_TMU_INTCLEAR_VAL	0x1111
 
+#define SENSOR_NAME_LEN	16
+#define MAX_TRIP_COUNT	8
+#define MAX_COOLING_DEVICE 4
+
+#define ACTIVE_INTERVAL 500
+#define IDLE_INTERVAL 10000
+
+/* CPU Zone information */
+#define PANIC_ZONE      4
+#define WARN_ZONE       3
+#define MONITOR_ZONE    2
+#define SAFE_ZONE       1
+
+#define GET_ZONE(trip) (trip + 2)
+#define GET_TRIP(zone) (zone - 2)
+
 struct exynos4_tmu_data {
 	struct exynos4_tmu_platform_data *pdata;
 	struct resource *mem;
@@ -77,6 +96,296 @@ struct exynos4_tmu_data {
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
+struct exynos4_thermal_zone {
+	enum thermal_device_mode mode;
+	struct thermal_zone_device *therm_dev;
+	struct thermal_cooling_device *cool_dev[MAX_COOLING_DEVICE];
+	unsigned int cool_dev_size;
+	struct platform_device *exynos4_dev;
+	struct thermal_sensor_conf *sensor_conf;
+};
+
+static struct exynos4_thermal_zone *th_zone;
+static void exynos4_unregister_thermal(void);
+static int exynos4_register_thermal(struct thermal_sensor_conf *sensor_conf);
+
+/* Get mode callback functions for thermal zone */
+static int exynos4_get_mode(struct thermal_zone_device *thermal,
+			enum thermal_device_mode *mode)
+{
+	if (th_zone)
+		*mode = th_zone->mode;
+	return 0;
+}
+
+/* Set mode callback functions for thermal zone */
+static int exynos4_set_mode(struct thermal_zone_device *thermal,
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
+static void exynos4_report_trigger(void)
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
+static int exynos4_get_trip_type(struct thermal_zone_device *thermal, int trip,
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
+static int exynos4_get_trip_temp(struct thermal_zone_device *thermal, int trip,
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
+static int exynos4_get_crit_temp(struct thermal_zone_device *thermal,
+				unsigned long *temp)
+{
+	int ret = 0;
+	/* Panic zone */
+	ret = exynos4_get_trip_temp(thermal, GET_TRIP(PANIC_ZONE), temp);
+	return ret;
+}
+
+/* Bind callback functions for thermal zone */
+static int exynos4_bind(struct thermal_zone_device *thermal,
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
+static int exynos4_unbind(struct thermal_zone_device *thermal,
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
+static int exynos4_get_temp(struct thermal_zone_device *thermal,
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
+static struct thermal_zone_device_ops exynos4_dev_ops = {
+	.bind = exynos4_bind,
+	.unbind = exynos4_unbind,
+	.get_temp = exynos4_get_temp,
+	.get_mode = exynos4_get_mode,
+	.set_mode = exynos4_set_mode,
+	.get_trip_type = exynos4_get_trip_type,
+	.get_trip_temp = exynos4_get_trip_temp,
+	.get_crit_temp = exynos4_get_crit_temp,
+};
+
+/* Register with the in-kernel thermal management */
+static int exynos4_register_thermal(struct thermal_sensor_conf *sensor_conf)
+{
+	int ret, count, tab_size;
+	struct freq_clip_table *tab_ptr;
+
+	if (!sensor_conf || !sensor_conf->read_temperature) {
+		pr_err("Temperature sensor not initialised\n");
+		return -EINVAL;
+	}
+
+	th_zone = kzalloc(sizeof(struct exynos4_thermal_zone), GFP_KERNEL);
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
+			3, NULL, &exynos4_dev_ops, 0, 0, 0, IDLE_INTERVAL);
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
+	exynos4_unregister_thermal();
+	return ret;
+}
+
+/* Un-Register with the in-kernel thermal management */
+static void exynos4_unregister_thermal(void)
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
@@ -243,10 +552,10 @@ static void exynos4_tmu_work(struct work_struct *work)
 
 	writel(EXYNOS4_TMU_INTCLEAR_VAL, data->base + EXYNOS4_TMU_REG_INTCLEAR);
 
-	enable_irq(data->irq);
-
 	clk_disable(data->clk);
 	mutex_unlock(&data->lock);
+	exynos4_report_trigger();
+	enable_irq(data->irq);
 }
 
 static irqreturn_t exynos4_tmu_irq(int irq, void *id)
@@ -259,11 +568,16 @@ static irqreturn_t exynos4_tmu_irq(int irq, void *id)
 	return IRQ_HANDLED;
 }
 
+static struct thermal_sensor_conf exynos4_sensor_conf = {
+	.name			= "exynos4-therm",
+	.read_temperature	= (int (*)(void *))exynos4_tmu_read,
+};
+
 static int __devinit exynos4_tmu_probe(struct platform_device *pdev)
 {
 	struct exynos4_tmu_data *data;
 	struct exynos4_tmu_platform_data *pdata = pdev->dev.platform_data;
-	int ret;
+	int ret, i;
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "No platform init data supplied.\n");
@@ -334,6 +648,24 @@ static int __devinit exynos4_tmu_probe(struct platform_device *pdev)
 
 	exynos4_tmu_control(pdev, true);
 
+	/*Register the sensor with thermal management interface*/
+	(&exynos4_sensor_conf)->private_data = data;
+	exynos4_sensor_conf.trip_data.trip_count = 3;
+	for (i = 0; i < exynos4_sensor_conf.trip_data.trip_count; i++)
+		exynos4_sensor_conf.trip_data.trip_val[i] =
+			pdata->threshold + pdata->trigger_levels[i + 1];
+
+	exynos4_sensor_conf.cooling_data.freq_clip_count =
+						pdata->freq_tab_count;
+	for (i = 0; i < pdata->freq_tab_count; i++)
+		exynos4_sensor_conf.cooling_data.freq_data[i].freq_clip_max =
+					pdata->freq_tab[i].freq_clip_max;
+
+	ret = exynos4_register_thermal(&exynos4_sensor_conf);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to register thermal interface\n");
+		goto err_clk;
+	}
 	return 0;
 err_clk:
 	platform_set_drvdata(pdev, NULL);
@@ -356,6 +688,8 @@ static int __devexit exynos4_tmu_remove(struct platform_device *pdev)
 
 	exynos4_tmu_control(pdev, false);
 
+	exynos4_unregister_thermal();
+
 	clk_put(data->clk);
 
 	free_irq(data->irq, data);
diff --git a/include/linux/platform_data/exynos4_tmu.h b/include/linux/platform_data/exynos4_tmu.h
index 39e038c..ae32f19 100644
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
+ * @freq_clip_table: Table representing frequency reduction percentage.
+ * @freq_tab_count: Count of the above table as frequency reduction may
+ *	applicable to only some of the trigger levels.
  *
  * This structure is required for configuration of exynos4_tmu driver.
  */
@@ -79,5 +83,8 @@ struct exynos4_tmu_platform_data {
 	u8 reference_voltage;
 
 	enum calibration_type cal_type;
+
+	struct freq_clip_table freq_tab[4];
+	unsigned int freq_tab_count;
 };
 #endif /* _LINUX_EXYNOS4_TMU_H */
-- 
1.7.1

