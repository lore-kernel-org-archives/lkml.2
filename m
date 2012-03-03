Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab2CCLJI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 06:09:08 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:33277 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab2CCLI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 06:08:26 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of amitdanielk@gmail.com designates 10.68.225.231 as permitted sender) smtp.mail=amitdanielk@gmail.com; dkim=pass header.i=amitdanielk@gmail.com
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: linux-pm@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        linaro-dev@lists.linaro.org, lm-sensors@lm-sensors.org,
        amit.kachhap@linaro.org, eduardo.valentin@ti.com,
        durgadoss.r@intel.com, patches@linaro.org
Subject: [PATCH 1/4] thermal: exynos: Add thermal interface support for linux thermal layer
Date: Sat,  3 Mar 2012 16:36:04 +0530
Message-Id: <1330772767-16120-2-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1330772767-16120-1-git-send-email-amit.kachhap@linaro.org>
References: <1330772767-16120-1-git-send-email-amit.kachhap@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This codes uses the generic linux thermal layer and creates a bridge
between temperature sensors, linux thermal framework and cooling devices
for samsung exynos platform. This layer recieves or monitor the
temperature from the sensor and informs the generic thermal layer to take
the necessary cooling action.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
---
 drivers/thermal/Kconfig          |    8 +
 drivers/thermal/Makefile         |    1 +
 drivers/thermal/exynos_thermal.c |  272 ++++++++++++++++++++++++++++++++++++++
 include/linux/exynos_thermal.h   |   72 ++++++++++
 4 files changed, 353 insertions(+), 0 deletions(-)
 create mode 100644 drivers/thermal/exynos_thermal.c
 create mode 100644 include/linux/exynos_thermal.h

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 298c1cd..4e8df56 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -29,3 +29,11 @@ config CPU_THERMAL
 	  This will be useful for platforms using the generic thermal interface
 	  and not the ACPI interface.
 	  If you want this support, you should say Y or M here.
+
+config SAMSUNG_THERMAL_INTERFACE
+	bool "Samsung Thermal interface support"
+	depends on THERMAL && CPU_THERMAL
+	help
+	  This is a samsung thermal interface which will be used as
+	  a link between sensors and cooling devices with linux thermal
+	  framework.
diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
index 655cbc4..c67b6b2 100644
--- a/drivers/thermal/Makefile
+++ b/drivers/thermal/Makefile
@@ -4,3 +4,4 @@
 
 obj-$(CONFIG_THERMAL)		+= thermal_sys.o
 obj-$(CONFIG_CPU_THERMAL)	+= cpu_cooling.o
+obj-$(CONFIG_SAMSUNG_THERMAL_INTERFACE)	+= exynos_thermal.o
diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
new file mode 100644
index 0000000..878d45c
--- /dev/null
+++ b/drivers/thermal/exynos_thermal.c
@@ -0,0 +1,272 @@
+/* linux/drivers/thermal/exynos_thermal.c
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/thermal.h>
+#include <linux/platform_device.h>
+#include <linux/cpufreq.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/cpu_cooling.h>
+#include <linux/exynos_thermal.h>
+
+#define MAX_COOLING_DEVICE 4
+struct exynos4_thermal_zone {
+	unsigned int idle_interval;
+	unsigned int active_interval;
+	struct thermal_zone_device *therm_dev;
+	struct thermal_cooling_device *cool_dev[MAX_COOLING_DEVICE];
+	unsigned int cool_dev_size;
+	struct platform_device *exynos4_dev;
+	struct thermal_sensor_conf *sensor_conf;
+};
+
+static struct exynos4_thermal_zone *th_zone;
+
+static int exynos4_get_mode(struct thermal_zone_device *thermal,
+			    enum thermal_device_mode *mode)
+{
+	if (th_zone->sensor_conf) {
+		pr_info("Temperature sensor not initialised\n");
+		*mode = THERMAL_DEVICE_DISABLED;
+	} else
+		*mode = THERMAL_DEVICE_ENABLED;
+	return 0;
+}
+
+static int exynos4_set_mode(struct thermal_zone_device *thermal,
+			    enum thermal_device_mode mode)
+{
+	if (!th_zone->therm_dev) {
+		pr_notice("thermal zone not registered\n");
+		return 0;
+	}
+	if (mode == THERMAL_DEVICE_ENABLED)
+		th_zone->therm_dev->polling_delay =
+				th_zone->active_interval*1000;
+	else
+		th_zone->therm_dev->polling_delay =
+				th_zone->idle_interval*1000;
+
+	thermal_zone_device_update(th_zone->therm_dev);
+	pr_info("thermal polling set for duration=%d sec\n",
+				th_zone->therm_dev->polling_delay/1000);
+	return 0;
+}
+
+/*This may be called from interrupt based temperature sensor*/
+void exynos4_report_trigger(void)
+{
+	unsigned int monitor_temp;
+
+	if (!th_zone || !th_zone->therm_dev)
+		return;
+
+	monitor_temp = th_zone->sensor_conf->trip_data.trip_val[0];
+
+	thermal_zone_device_update(th_zone->therm_dev);
+
+	mutex_lock(&th_zone->therm_dev->lock);
+	if (th_zone->therm_dev->last_temperature > monitor_temp)
+		th_zone->therm_dev->polling_delay =
+					th_zone->active_interval*1000;
+	else
+		th_zone->therm_dev->polling_delay =
+					th_zone->idle_interval*1000;
+
+	kobject_uevent(&th_zone->therm_dev->device.kobj, KOBJ_CHANGE);
+	mutex_unlock(&th_zone->therm_dev->lock);
+}
+
+static int exynos4_get_trip_type(struct thermal_zone_device *thermal, int trip,
+				 enum thermal_trip_type *type)
+{
+	if (trip == 0 || trip == 1)
+		*type = THERMAL_TRIP_STATE_ACTIVE;
+	else if (trip == 2)
+		*type = THERMAL_TRIP_CRITICAL;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
+static int exynos4_get_trip_temp(struct thermal_zone_device *thermal, int trip,
+				 unsigned long *temp)
+{
+	/*Monitor zone*/
+	if (trip == 0)
+		*temp = th_zone->sensor_conf->trip_data.trip_val[0];
+	/*Warn zone*/
+	else if (trip == 1)
+		*temp = th_zone->sensor_conf->trip_data.trip_val[1];
+	/*Panic zone*/
+	else if (trip == 2)
+		*temp = th_zone->sensor_conf->trip_data.trip_val[2];
+	else
+		return -EINVAL;
+	/*convert the temperature into millicelsius*/
+	*temp = *temp * 1000;
+
+	return 0;
+}
+
+static int exynos4_get_crit_temp(struct thermal_zone_device *thermal,
+				 unsigned long *temp)
+{
+	/*Panic zone*/
+	*temp = th_zone->sensor_conf->trip_data.trip_val[2];
+	/*convert the temperature into millicelsius*/
+	*temp = *temp * 1000;
+	return 0;
+}
+
+static int exynos4_bind(struct thermal_zone_device *thermal,
+			struct thermal_cooling_device *cdev)
+{
+	/* if the cooling device is the one from exynos4 bind it */
+	if (cdev != th_zone->cool_dev[0])
+		return 0;
+
+	if (thermal_zone_bind_cooling_device(thermal, 0, cdev)) {
+		pr_err("error binding cooling dev\n");
+		return -EINVAL;
+	}
+	if (thermal_zone_bind_cooling_device(thermal, 1, cdev)) {
+		pr_err("error binding cooling dev\n");
+		return -EINVAL;
+	}
+
+	return 0;
+
+}
+
+static int exynos4_unbind(struct thermal_zone_device *thermal,
+			  struct thermal_cooling_device *cdev)
+{
+	if (cdev != th_zone->cool_dev[0])
+		return 0;
+
+	if (thermal_zone_unbind_cooling_device(thermal, 0, cdev)) {
+		pr_err("error unbinding cooling dev\n");
+		return -EINVAL;
+	}
+	if (thermal_zone_unbind_cooling_device(thermal, 1, cdev)) {
+		pr_err("error unbinding cooling dev\n");
+		return -EINVAL;
+	}
+	return 0;
+
+}
+
+static int exynos4_get_temp(struct thermal_zone_device *thermal,
+			       unsigned long *temp)
+{
+	void *data;
+
+	if (!th_zone->sensor_conf) {
+		pr_info("Temperature sensor not initialised\n");
+		return -EINVAL;
+	}
+	data = th_zone->sensor_conf->private_data;
+	*temp = th_zone->sensor_conf->read_temperature(data);
+	/*convert the temperature into millicelsius*/
+	*temp = *temp * 1000;
+	return 0;
+}
+
+/* bind callback functions to thermalzone */
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
+int exynos4_register_thermal(struct thermal_sensor_conf *sensor_conf)
+{
+	int ret, count, tab_size;
+	struct freq_pctg_table *tab_ptr;
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
+	tab_ptr = (struct freq_pctg_table *)sensor_conf->cooling_data.freq_data;
+	tab_size = sensor_conf->cooling_data.freq_pctg_count;
+
+	/*Register the cpufreq cooling device*/
+	th_zone->cool_dev_size = 1;
+	count = 0;
+	th_zone->cool_dev[count] = cpufreq_cooling_register(
+			(struct freq_pctg_table *)&(tab_ptr[count]),
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
+				3, NULL, &exynos4_dev_ops, 0, 0, 0, 1000);
+	if (IS_ERR(th_zone->therm_dev)) {
+		pr_err("Failed to register thermal zone device\n");
+		ret = -EINVAL;
+		goto err_unregister;
+	}
+
+	th_zone->active_interval = 1;
+	th_zone->idle_interval = 10;
+
+	exynos4_set_mode(th_zone->therm_dev, THERMAL_DEVICE_DISABLED);
+
+	pr_info("Exynos: Kernel Thermal management registered\n");
+
+	return 0;
+
+err_unregister:
+	exynos4_unregister_thermal();
+	return ret;
+}
+EXPORT_SYMBOL(exynos4_register_thermal);
+
+void exynos4_unregister_thermal(void)
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
+EXPORT_SYMBOL(exynos4_unregister_thermal);
diff --git a/include/linux/exynos_thermal.h b/include/linux/exynos_thermal.h
new file mode 100644
index 0000000..186e409
--- /dev/null
+++ b/include/linux/exynos_thermal.h
@@ -0,0 +1,72 @@
+/* linux/include/linux/exynos_thermal.h
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef THERMAL_INTERFACE_H
+#define THERMAL_INTERFACE_H
+/* CPU Zone information */
+
+#define SENSOR_NAME_LEN	16
+#define MAX_TRIP_COUNT	8
+
+#define PANIC_ZONE      4
+#define WARN_ZONE       3
+#define MONITOR_ZONE    2
+#define SAFE_ZONE       1
+#define NO_ACTION       0
+
+
+struct	thermal_trip_point_conf {
+	int trip_val[MAX_TRIP_COUNT];
+	int trip_count;
+};
+
+struct	thermal_cooling_conf {
+	struct freq_pctg_table freq_data[MAX_TRIP_COUNT];
+	int freq_pctg_count;
+};
+
+/**
+ * struct exynos4_tmu_platform_data
+ * @name: name of the temperature sensor
+ * @read_temperature: A function pointer to read temperature info
+ * @private_data: Temperature sensor private data
+ * @sensor_data: Sensor specific information like trigger temperature, level
+ */
+struct thermal_sensor_conf {
+	char	name[SENSOR_NAME_LEN];
+	int	(*read_temperature)(void *data);
+	struct	thermal_trip_point_conf trip_data;
+	struct	thermal_cooling_conf cooling_data;
+	void	*private_data;
+};
+
+/**
+ * exynos4_register_thermal: Register to the exynos thermal interface.
+ * @sensor_conf:   Structure containing temperature sensor information
+ *
+ * returns zero on success, else negative errno.
+ */
+int exynos4_register_thermal(struct thermal_sensor_conf *sensor_conf);
+
+/**
+ * exynos4_unregister_thermal: Un-register from the exynos thermal interface.
+ *
+ * return not applicable.
+ */
+void exynos4_unregister_thermal(void);
+
+/**
+ * exynos4_report_trigger: Report any trigger level crossed in the
+ *	temperature sensor. This may be useful to take any cooling action.
+ *
+ * return not applicable.
+ */
+extern void exynos4_report_trigger(void);
+#endif
-- 
1.7.1

