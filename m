Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab2HPLmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 07:42:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41063 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab2HPLm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 07:42:29 -0400
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: linux-pm@lists.linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lm-sensors@lm-sensors.org,
        amit.kachhap@linaro.org, SangWook Ju <sw.ju@samsung.com>,
        Durgadoss <durgadoss.r@intel.com>, Len Brown <lenb@kernel.org>,
        Jean Delvare <khali@linux-fr.org>,
        Kyungmin Park <kmpark@infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH v6 4/6] thermal: exynos: register the tmu sensor with the kernel thermal layer
Date: Thu, 16 Aug 2012 17:11:43 +0530
Message-Id: <1345117305-8299-5-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1345117305-8299-1-git-send-email-amit.kachhap@linaro.org>
References: <1345117305-8299-1-git-send-email-amit.kachhap@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code added creates a link between temperature sensors, linux thermal
framework and cooling devices for samsung exynos platform.  This layer
monitors the temperature from the sensor and informs the generic thermal
layer to take the necessary cooling action.

[akpm@linux-foundation.org: fix comment layout]
Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: SangWook Ju <sw.ju@samsung.com>
Cc: Durgadoss <durgadoss.r@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Kyungmin Park <kmpark@infradead.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/exynos_thermal.c             |  406 +++++++++++++++++++++++++-
 include/linux/platform_data/exynos_thermal.h |   22 ++
 2 files changed, 426 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
index c9a33dd..e79cdc9 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -34,6 +34,9 @@
 #include <linux/io.h>
 #include <linux/mutex.h>
 #include <linux/platform_data/exynos_thermal.h>
+#include <linux/thermal.h>
+#include <linux/cpufreq.h>
+#include <linux/cpu_cooling.h>
 #include <linux/of.h>
 
 #include <plat/cpu.h>
@@ -94,6 +97,7 @@
 
 #define ACTIVE_INTERVAL 500
 #define IDLE_INTERVAL 10000
+#define MCELSIUS	1000
 
 /* CPU Zone information */
 #define PANIC_ZONE      4
@@ -104,6 +108,8 @@
 #define GET_ZONE(trip) (trip + 2)
 #define GET_TRIP(zone) (zone - 2)
 
+#define EXYNOS_ZONE_COUNT	3
+
 struct exynos_tmu_data {
 	struct exynos_tmu_platform_data *pdata;
 	struct resource *mem;
@@ -116,6 +122,371 @@ struct exynos_tmu_data {
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
+	bool bind;
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
+
+/* Get trip type callback functions for thermal zone */
+static int exynos_get_trip_type(struct thermal_zone_device *thermal, int trip,
+				 enum thermal_trip_type *type)
+{
+	switch (GET_ZONE(trip)) {
+	case MONITOR_ZONE:
+	case WARN_ZONE:
+		*type = THERMAL_TRIP_ACTIVE;
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
+	if (trip < GET_TRIP(MONITOR_ZONE) || trip > GET_TRIP(PANIC_ZONE))
+		return -EINVAL;
+
+	*temp = th_zone->sensor_conf->trip_data.trip_val[trip];
+	/* convert the temperature into millicelsius */
+	*temp = *temp * MCELSIUS;
+
+	return 0;
+}
+
+/* Get critical temperature callback functions for thermal zone */
+static int exynos_get_crit_temp(struct thermal_zone_device *thermal,
+				unsigned long *temp)
+{
+	int ret;
+	/* Panic zone */
+	ret = exynos_get_trip_temp(thermal, GET_TRIP(PANIC_ZONE), temp);
+	return ret;
+}
+
+static int exynos_get_frequency_level(unsigned int cpu, unsigned int freq)
+{
+	int i = 0, ret = -EINVAL;
+	struct cpufreq_frequency_table *table = NULL;
+#ifdef CONFIG_CPU_FREQ
+	table = cpufreq_frequency_get_table(cpu);
+#endif
+	if (!table)
+		return ret;
+
+	while (table[i].frequency != CPUFREQ_TABLE_END) {
+		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
+			continue;
+		if (table[i].frequency == freq)
+			return i;
+		i++;
+	}
+	return ret;
+}
+
+/* Bind callback functions for thermal zone */
+static int exynos_bind(struct thermal_zone_device *thermal,
+			struct thermal_cooling_device *cdev)
+{
+	int ret = 0, i, tab_size, level;
+	struct freq_clip_table *tab_ptr, *clip_data;
+	struct thermal_sensor_conf *data = th_zone->sensor_conf;
+
+	tab_ptr = (struct freq_clip_table *)data->cooling_data.freq_data;
+	tab_size = data->cooling_data.freq_clip_count;
+
+	if (tab_ptr == NULL || tab_size == 0)
+		return -EINVAL;
+
+	/* find the cooling device registered*/
+	for (i = 0; i < th_zone->cool_dev_size; i++)
+		if (cdev == th_zone->cool_dev[i])
+			break;
+
+	/* No matching cooling device */
+	if (i == th_zone->cool_dev_size)
+		return 0;
+
+	/* Bind the thermal zone to the cpufreq cooling device */
+	for (i = 0; i < tab_size; i++) {
+		clip_data = (struct freq_clip_table *)&(tab_ptr[i]);
+		level = exynos_get_frequency_level(0, clip_data->freq_clip_max);
+		if (level < 0)
+			return 0;
+		switch (GET_ZONE(i)) {
+		case MONITOR_ZONE:
+		case WARN_ZONE:
+			if (thermal_zone_bind_cooling_device(thermal, i, cdev,
+								level, level)) {
+				pr_err("error binding cdev inst %d\n", i);
+				ret = -EINVAL;
+			}
+			th_zone->bind = true;
+			break;
+		default:
+			ret = -EINVAL;
+		}
+	}
+
+	return ret;
+}
+
+/* Unbind callback functions for thermal zone */
+static int exynos_unbind(struct thermal_zone_device *thermal,
+			struct thermal_cooling_device *cdev)
+{
+	int ret = 0, i, tab_size;
+	struct thermal_sensor_conf *data = th_zone->sensor_conf;
+
+	if (th_zone->bind == false)
+		return 0;
+
+	tab_size = data->cooling_data.freq_clip_count;
+
+	if (tab_size == 0)
+		return -EINVAL;
+
+	/* find the cooling device registered*/
+	for (i = 0; i < th_zone->cool_dev_size; i++)
+		if (cdev == th_zone->cool_dev[i])
+			break;
+
+	/* No matching cooling device */
+	if (i == th_zone->cool_dev_size)
+		return 0;
+
+	/* Bind the thermal zone to the cpufreq cooling device */
+	for (i = 0; i < tab_size; i++) {
+		switch (GET_ZONE(i)) {
+		case MONITOR_ZONE:
+		case WARN_ZONE:
+			if (thermal_zone_unbind_cooling_device(thermal, i,
+								cdev)) {
+				pr_err("error unbinding cdev inst=%d\n", i);
+				ret = -EINVAL;
+			}
+			th_zone->bind = false;
+			break;
+		default:
+			ret = -EINVAL;
+		}
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
+	*temp = *temp * MCELSIUS;
+	return 0;
+}
+
+/* Get the temperature trend */
+static int exynos_get_trend(struct thermal_zone_device *thermal,
+			int trip, enum thermal_trend *trend)
+{
+	if (thermal->temperature >= trip)
+		*trend = THERMAL_TREND_RAISING;
+	else
+		*trend = THERMAL_TREND_DROPPING;
+
+	return 0;
+}
+/* Operation callback functions for thermal zone */
+static struct thermal_zone_device_ops const exynos_dev_ops = {
+	.bind = exynos_bind,
+	.unbind = exynos_unbind,
+	.get_temp = exynos_get_temp,
+	.get_trend = exynos_get_trend,
+	.get_mode = exynos_get_mode,
+	.set_mode = exynos_set_mode,
+	.get_trip_type = exynos_get_trip_type,
+	.get_trip_temp = exynos_get_trip_temp,
+	.get_crit_temp = exynos_get_crit_temp,
+};
+
+/*
+ * This function may be called from interrupt based temperature sensor
+ * when threshold is changed.
+ */
+static void exynos_report_trigger(void)
+{
+	unsigned int i;
+	char data[10];
+	char *envp[] = { data, NULL };
+
+	if (!th_zone || !th_zone->therm_dev)
+		return;
+	if (th_zone->bind == false) {
+		for (i = 0; i < th_zone->cool_dev_size; i++) {
+			if (!th_zone->cool_dev[i])
+				continue;
+			exynos_bind(th_zone->therm_dev,
+					th_zone->cool_dev[i]);
+		}
+	}
+
+	thermal_zone_device_update(th_zone->therm_dev);
+
+	mutex_lock(&th_zone->therm_dev->lock);
+	/* Find the level for which trip happened */
+	for (i = 0; i < th_zone->sensor_conf->trip_data.trip_count; i++) {
+		if (th_zone->therm_dev->last_temperature <
+			th_zone->sensor_conf->trip_data.trip_val[i] * MCELSIUS)
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
+	snprintf(data, sizeof(data), "%u", i);
+	kobject_uevent_env(&th_zone->therm_dev->device.kobj, KOBJ_CHANGE, envp);
+	mutex_unlock(&th_zone->therm_dev->lock);
+}
+
+/* Register with the in-kernel thermal management */
+static int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf)
+{
+	int ret;
+	struct cpumask mask_val;
+
+	if (!sensor_conf || !sensor_conf->read_temperature) {
+		pr_err("Temperature sensor not initialised\n");
+		return -EINVAL;
+	}
+
+	th_zone = kzalloc(sizeof(struct exynos_thermal_zone), GFP_KERNEL);
+	if (!th_zone)
+		return -ENOMEM;
+
+	th_zone->sensor_conf = sensor_conf;
+	cpumask_set_cpu(0, &mask_val);
+	th_zone->cool_dev[0] = cpufreq_cooling_register(&mask_val);
+	if (IS_ERR(th_zone->cool_dev[0])) {
+		pr_err("Failed to register cpufreq cooling device\n");
+		ret = -EINVAL;
+		goto err_unregister;
+	}
+	th_zone->cool_dev_size++;
+
+	th_zone->therm_dev = thermal_zone_device_register(sensor_conf->name,
+			EXYNOS_ZONE_COUNT, 0, NULL, &exynos_dev_ops, 0,
+			IDLE_INTERVAL);
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
+	int i;
+
+	if (th_zone && th_zone->therm_dev)
+		thermal_zone_device_unregister(th_zone->therm_dev);
+
+	for (i = 0; i < th_zone->cool_dev_size; i++) {
+		if (th_zone && th_zone->cool_dev[i])
+			cpufreq_cooling_unregister(th_zone->cool_dev[i]);
+	}
+
+	kfree(th_zone);
+	pr_info("Exynos: Kernel Thermal management unregistered\n");
+}
+
 /*
  * TMU treats temperature as a mapped temperature code.
  * The temperature is converted differently depending on the calibration type.
@@ -336,6 +707,7 @@ static void exynos_tmu_work(struct work_struct *work)
 
 	clk_disable(data->clk);
 	mutex_unlock(&data->lock);
+	exynos_report_trigger();
 	enable_irq(data->irq);
 }
 
@@ -348,12 +720,16 @@ static irqreturn_t exynos_tmu_irq(int irq, void *id)
 
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
@@ -431,6 +807,30 @@ static int __devinit exynos_tmu_probe(struct platform_device *pdev)
 
 	exynos_tmu_control(pdev, true);
 
+	/* Register the sensor with thermal management interface */
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
+	for (i = 0; i < pdata->freq_tab_count; i++) {
+		exynos_sensor_conf.cooling_data.freq_data[i].freq_clip_max =
+					pdata->freq_tab[i].freq_clip_max;
+		exynos_sensor_conf.cooling_data.freq_data[i].temp_level =
+					pdata->freq_tab[i].temp_level;
+	}
+
+	ret = exynos_register_thermal(&exynos_sensor_conf);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to register thermal interface\n");
+		goto err_clk;
+	}
 	return 0;
 err_clk:
 	platform_set_drvdata(pdev, NULL);
@@ -453,6 +853,8 @@ static int __devexit exynos_tmu_remove(struct platform_device *pdev)
 
 	exynos_tmu_control(pdev, false);
 
+	exynos_unregister_thermal();
+
 	clk_put(data->clk);
 
 	free_irq(data->irq, data);
diff --git a/include/linux/platform_data/exynos_thermal.h b/include/linux/platform_data/exynos_thermal.h
index a9e960a..a7bdb2f 100644
--- a/include/linux/platform_data/exynos_thermal.h
+++ b/include/linux/platform_data/exynos_thermal.h
@@ -21,6 +21,7 @@
 
 #ifndef _LINUX_EXYNOS_THERMAL_H
 #define _LINUX_EXYNOS_THERMAL_H
+#include <linux/cpu_cooling.h>
 
 enum calibration_type {
 	TYPE_ONE_POINT_TRIMMING,
@@ -33,6 +34,22 @@ enum soc_type {
 	SOC_ARCH_EXYNOS,
 };
 /**
+ * struct freq_clip_table
+ * @freq_clip_max: maximum frequency allowed for this cooling state.
+ * @temp_level: Temperature level at which the temperature clipping will
+ *	happen.
+ * @mask_val: cpumask of the allowed cpu's where the clipping will take place.
+ *
+ * This structure is required to be filled and passed to the
+ * cpufreq_cooling_unregister function.
+ */
+struct freq_clip_table {
+	unsigned int freq_clip_max;
+	unsigned int temp_level;
+	const struct cpumask *mask_val;
+};
+
+/**
  * struct exynos_tmu_platform_data
  * @threshold: basic temperature for generating interrupt
  *	       25 <= threshold <= 125 [unit: degree Celsius]
@@ -72,6 +89,9 @@ enum soc_type {
  * @type: determines the type of SOC
  * @efuse_value: platform defined fuse value
  * @cal_type: calibration type for temperature
+ * @freq_clip_table: Table representing frequency reduction percentage.
+ * @freq_tab_count: Count of the above table as frequency reduction may
+ *	applicable to only some of the trigger levels.
  *
  * This structure is required for configuration of exynos_tmu driver.
  */
@@ -90,5 +110,7 @@ struct exynos_tmu_platform_data {
 
 	enum calibration_type cal_type;
 	enum soc_type type;
+	struct freq_clip_table freq_tab[4];
+	unsigned int freq_tab_count;
 };
 #endif /* _LINUX_EXYNOS_THERMAL_H */
-- 
1.7.1

