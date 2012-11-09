Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab2KILaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 06:30:07 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38982 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab2KIL37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:29:59 -0500
From: "hongbo.zhang" <hongbo.zhang@linaro.org>
To: linux-acpi@vger.kernel.org, rui.zhang@intel.com
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        amit.kachhap@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, linaro-kernel@lists.linaro.org,
        STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>
Subject: [PATCH V5 1/2] Thermal: Add ST-Ericsson DB8500 thermal driver.
Date: Fri,  9 Nov 2012 19:29:07 +0800
Message-Id: <1352460548-3494-2-git-send-email-hongbo.zhang@linaro.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352460548-3494-1-git-send-email-hongbo.zhang@linaro.com>
References: <1352460548-3494-1-git-send-email-hongbo.zhang@linaro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "hongbo.zhang" <hongbo.zhang@linaro.com>

This driver is based on the thermal management framework in thermal_sys.c. A
thermal zone device is created with the trip points to which cooling devices
can be bound, the current cooling device is cpufreq, e.g. CPU frequency is
clipped down to cool the CPU, and other cooling devices can be added and bound
to the trip points dynamically.  The platform specific PRCMU interrupts are
used to active thermal update when trip points are reached.

Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>
Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Francesco Lavra <francescolavra.fl@gmail.com>
---
 .../devicetree/bindings/thermal/db8500-thermal.txt |  44 ++
 drivers/thermal/Kconfig                            |  20 +
 drivers/thermal/Makefile                           |   2 +
 drivers/thermal/db8500_cpufreq_cooling.c           | 108 +++++
 drivers/thermal/db8500_thermal.c                   | 531 +++++++++++++++++++++
 include/linux/platform_data/db8500_thermal.h       |  38 ++
 6 files changed, 743 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/thermal/db8500-thermal.txt
 create mode 100644 drivers/thermal/db8500_cpufreq_cooling.c
 create mode 100644 drivers/thermal/db8500_thermal.c
 create mode 100644 include/linux/platform_data/db8500_thermal.h

diff --git a/Documentation/devicetree/bindings/thermal/db8500-thermal.txt b/Documentation/devicetree/bindings/thermal/db8500-thermal.txt
new file mode 100644
index 0000000..2e1c06f
--- /dev/null
+++ b/Documentation/devicetree/bindings/thermal/db8500-thermal.txt
@@ -0,0 +1,44 @@
+* ST-Ericsson DB8500 Thermal
+
+** Thermal node properties:
+
+- compatible : "stericsson,db8500-thermal";
+- reg : address range of the thermal sensor registers;
+- interrupts : interrupts generated from PRCMU;
+- interrupt-names : "IRQ_HOTMON_LOW" and "IRQ_HOTMON_HIGH";
+- num-trips : number of total trip points, this is required, set it 0 if none,
+  if greater than 0, the following properties must be defined;
+- tripN-temp : temperature of trip point N, should be in ascending order;
+- tripN-type : type of trip point N, should be one of "active" "passive" "hot"
+  "critical";
+- tripN-cdev-num : number of the cooling devices which can be bound to trip
+  point N, this is required if trip point N is defined, set it 0 if none,
+  otherwise the following cooling device names must be defined;
+- tripN-cdev-nameM : name of the No. M cooling device of trip point N;
+
+Usually the num-trips and tripN-*** are separated in board related dts files.
+
+Example:
+thermal@801573c0 {
+	compatible = "stericsson,db8500-thermal";
+	reg = <0x801573c0 0x40>;
+	interrupts = <21 0x4>, <22 0x4>;
+	interrupt-names = "IRQ_HOTMON_LOW", "IRQ_HOTMON_HIGH";
+
+	num-trips = <3>;
+
+	trip0-temp = <75000>;
+	trip0-type = "active";
+	trip0-cdev-num = <1>;
+	trip0-cdev-name0 = "thermal-cpufreq-0";
+
+	trip1-temp = <80000>;
+	trip1-type = "active";
+	trip1-cdev-num = <2>;
+	trip1-cdev-name0 = "thermal-cpufreq-0";
+	trip1-cdev-name1 = "thermal-fan";
+
+	trip2-temp = <85000>;
+	trip2-type = "critical";
+	trip2-cdev-num = <0>;
+}
diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index e1cb6bd..54c8fd0 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -31,6 +31,26 @@ config CPU_THERMAL
 	  and not the ACPI interface.
 	  If you want this support, you should say Y here.
 
+config DB8500_THERMAL
+	bool "DB8500 thermal management"
+	depends on THERMAL
+	default y
+	help
+	  Adds DB8500 thermal management implementation according to the thermal
+	  management framework. A thermal zone with several trip points will be
+	  created. Cooling devices can be bound to the trip points to cool this
+	  thermal zone if trip points reached.
+
+config DB8500_CPUFREQ_COOLING
+	tristate "DB8500 cpufreq cooling"
+	depends on CPU_THERMAL
+	default y
+	help
+	  Adds DB8500 cpufreq cooling devices, and these cooling devices can be
+	  bound to thermal zone trip points. When a trip point reached, the
+	  bound cpufreq cooling device turns active to set CPU frequency low to
+	  cool down the CPU.
+
 config SPEAR_THERMAL
 	bool "SPEAr thermal sensor driver"
 	depends on THERMAL
diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
index 885550d..c7a8dab 100644
--- a/drivers/thermal/Makefile
+++ b/drivers/thermal/Makefile
@@ -7,3 +7,5 @@ obj-$(CONFIG_CPU_THERMAL)		+= cpu_cooling.o
 obj-$(CONFIG_SPEAR_THERMAL)		+= spear_thermal.o
 obj-$(CONFIG_RCAR_THERMAL)	+= rcar_thermal.o
 obj-$(CONFIG_EXYNOS_THERMAL)		+= exynos_thermal.o
+obj-$(CONFIG_DB8500_THERMAL)		+= db8500_thermal.o
+obj-$(CONFIG_DB8500_CPUFREQ_COOLING)	+= db8500_cpufreq_cooling.o
diff --git a/drivers/thermal/db8500_cpufreq_cooling.c b/drivers/thermal/db8500_cpufreq_cooling.c
new file mode 100644
index 0000000..4cf8e72
--- /dev/null
+++ b/drivers/thermal/db8500_cpufreq_cooling.c
@@ -0,0 +1,108 @@
+/*
+ * db8500_cpufreq_cooling.c - DB8500 cpufreq works as cooling device.
+ *
+ * Copyright (C) 2012 ST-Ericsson
+ * Copyright (C) 2012 Linaro Ltd.
+ *
+ * Author: Hongbo Zhang <hongbo.zhang@linaro.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/cpu_cooling.h>
+#include <linux/cpufreq.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+static int db8500_cpufreq_cooling_probe(struct platform_device *pdev)
+{
+	struct thermal_cooling_device *cdev;
+	struct cpumask mask_val;
+
+	/* make sure cpufreq driver has been initialized */
+	if (!cpufreq_frequency_get_table(0))
+		return -EPROBE_DEFER;
+
+	cpumask_set_cpu(0, &mask_val);
+	cdev = cpufreq_cooling_register(&mask_val);
+
+	if (IS_ERR_OR_NULL(cdev)) {
+		dev_err(&pdev->dev, "Failed to register cooling device\n");
+		return PTR_ERR(cdev);
+	}
+
+	platform_set_drvdata(pdev, cdev);
+
+	dev_info(&pdev->dev, "Cooling device registered: %s\n",	cdev->type);
+
+	return 0;
+}
+
+static int db8500_cpufreq_cooling_remove(struct platform_device *pdev)
+{
+	struct thermal_cooling_device *cdev = platform_get_drvdata(pdev);
+
+	cpufreq_cooling_unregister(cdev);
+
+	return 0;
+}
+
+static int db8500_cpufreq_cooling_suspend(struct platform_device *pdev,
+		pm_message_t state)
+{
+	return -ENOSYS;
+}
+
+static int db8500_cpufreq_cooling_resume(struct platform_device *pdev)
+{
+	return -ENOSYS;
+}
+
+#ifdef CONFIG_OF
+static const struct of_device_id db8500_cpufreq_cooling_match[] = {
+	{ .compatible = "stericsson,db8500-cpufreq-cooling" },
+	{},
+};
+#else
+#define db8500_cpufreq_cooling_match NULL
+#endif
+
+static struct platform_driver db8500_cpufreq_cooling_driver = {
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "db8500-cpufreq-cooling",
+		.of_match_table = db8500_cpufreq_cooling_match,
+	},
+	.probe = db8500_cpufreq_cooling_probe,
+	.suspend = db8500_cpufreq_cooling_suspend,
+	.resume = db8500_cpufreq_cooling_resume,
+	.remove = db8500_cpufreq_cooling_remove,
+};
+
+static int __init db8500_cpufreq_cooling_init(void)
+{
+	return platform_driver_register(&db8500_cpufreq_cooling_driver);
+}
+
+static void __exit db8500_cpufreq_cooling_exit(void)
+{
+	platform_driver_unregister(&db8500_cpufreq_cooling_driver);
+}
+
+/* Should be later than db8500_cpufreq_register */
+late_initcall(db8500_cpufreq_cooling_init);
+module_exit(db8500_cpufreq_cooling_exit);
+
+MODULE_AUTHOR("Hongbo Zhang <hongbo.zhang@stericsson.com>");
+MODULE_DESCRIPTION("DB8500 cpufreq cooling driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/thermal/db8500_thermal.c b/drivers/thermal/db8500_thermal.c
new file mode 100644
index 0000000..94ec358
--- /dev/null
+++ b/drivers/thermal/db8500_thermal.c
@@ -0,0 +1,531 @@
+/*
+ * db8500_thermal.c - DB8500 Thermal Management Implementation
+ *
+ * Copyright (C) 2012 ST-Ericsson
+ * Copyright (C) 2012 Linaro Ltd.
+ *
+ * Author: Hongbo Zhang <hongbo.zhang@linaro.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/cpu_cooling.h>
+#include <linux/interrupt.h>
+#include <linux/mfd/dbx500-prcmu.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_data/db8500_thermal.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/thermal.h>
+
+#define PRCMU_DEFAULT_MEASURE_TIME	0xFFF
+#define PRCMU_DEFAULT_LOW_TEMP		0
+
+struct db8500_thermal_zone {
+	struct thermal_zone_device *therm_dev;
+	struct mutex th_lock;
+	struct work_struct therm_work;
+	struct db8500_thsens_platform_data *trip_tab;
+	enum thermal_device_mode mode;
+	enum thermal_trend trend;
+	unsigned long cur_temp_pseudo;
+	unsigned int cur_index;
+};
+
+/* Local function to check if thermal zone matches cooling devices */
+static int db8500_thermal_match_cdev(struct thermal_cooling_device *cdev,
+		struct db8500_trip_point *trip_point)
+{
+	int i;
+
+	if (!strlen(cdev->type))
+		return -EINVAL;
+
+	for (i = 0; i < COOLING_DEV_MAX; i++) {
+		if (!strcmp(trip_point->cdev_name[i], cdev->type))
+			return 0;
+	}
+
+	return -ENODEV;
+}
+
+/* Callback to bind cooling device to thermal zone */
+static int db8500_cdev_bind(struct thermal_zone_device *thermal,
+		struct thermal_cooling_device *cdev)
+{
+	struct db8500_thermal_zone *pzone = thermal->devdata;
+	struct db8500_thsens_platform_data *ptrips = pzone->trip_tab;
+	unsigned long max_state, upper, lower;
+	int i, ret = -EINVAL;
+
+	cdev->ops->get_max_state(cdev, &max_state);
+
+	for (i = 0; i < ptrips->num_trips; i++) {
+		if (db8500_thermal_match_cdev(cdev, &ptrips->trip_points[i]))
+			continue;
+
+		upper = lower = i > max_state ? max_state : i;
+
+		ret = thermal_zone_bind_cooling_device(thermal, i, cdev,
+			upper, lower);
+
+		dev_info(&cdev->device, "%s bind to %d: %d-%s\n", cdev->type,
+			i, ret, ret ? "fail" : "succeed");
+	}
+
+	return ret;
+}
+
+/* Callback to unbind cooling device from thermal zone */
+static int db8500_cdev_unbind(struct thermal_zone_device *thermal,
+		struct thermal_cooling_device *cdev)
+{
+	struct db8500_thermal_zone *pzone = thermal->devdata;
+	struct db8500_thsens_platform_data *ptrips = pzone->trip_tab;
+	int i, ret = -EINVAL;
+
+	for (i = 0; i < ptrips->num_trips; i++) {
+		if (db8500_thermal_match_cdev(cdev, &ptrips->trip_points[i]))
+			continue;
+
+		ret = thermal_zone_unbind_cooling_device(thermal, i, cdev);
+
+		dev_info(&cdev->device, "%s unbind from %d: %s\n", cdev->type,
+			i, ret ? "fail" : "succeed");
+	}
+
+	return ret;
+}
+
+/* Callback to get current temperature */
+static int db8500_sys_get_temp(struct thermal_zone_device *thermal,
+		unsigned long *temp)
+{
+	struct db8500_thermal_zone *pzone = thermal->devdata;
+
+	/*
+	 * TODO: There is no PRCMU interface to get temperature data currently,
+	 * so a pseudo temperature is returned , it works for thermal framework
+	 * and this will be fixed when the PRCMU interface is available.
+	 */
+	*temp = pzone->cur_temp_pseudo;
+
+	return 0;
+}
+
+/* Callback to get temperature changing trend */
+static int db8500_sys_get_trend(struct thermal_zone_device *thermal,
+		int trip, enum thermal_trend *trend)
+{
+	struct db8500_thermal_zone *pzone = thermal->devdata;
+
+	*trend = pzone->trend;
+
+	return 0;
+}
+
+/* Callback to get thermal zone mode */
+static int db8500_sys_get_mode(struct thermal_zone_device *thermal,
+		enum thermal_device_mode *mode)
+{
+	struct db8500_thermal_zone *pzone = thermal->devdata;
+
+	mutex_lock(&pzone->th_lock);
+	*mode = pzone->mode;
+	mutex_unlock(&pzone->th_lock);
+
+	return 0;
+}
+
+/* Callback to set thermal zone mode */
+static int db8500_sys_set_mode(struct thermal_zone_device *thermal,
+		enum thermal_device_mode mode)
+{
+	struct db8500_thermal_zone *pzone = thermal->devdata;
+
+	mutex_lock(&pzone->th_lock);
+
+	pzone->mode = mode;
+	if (mode == THERMAL_DEVICE_ENABLED)
+		schedule_work(&pzone->therm_work);
+
+	mutex_unlock(&pzone->th_lock);
+
+	return 0;
+}
+
+/* Callback to get trip point type */
+static int db8500_sys_get_trip_type(struct thermal_zone_device *thermal,
+		int trip, enum thermal_trip_type *type)
+{
+	struct db8500_thermal_zone *pzone = thermal->devdata;
+	struct db8500_thsens_platform_data *ptrips = pzone->trip_tab;
+
+	if (trip >= ptrips->num_trips)
+		return -EINVAL;
+
+	*type = ptrips->trip_points[trip].type;
+
+	return 0;
+}
+
+/* Callback to get trip point temperature */
+static int db8500_sys_get_trip_temp(struct thermal_zone_device *thermal,
+		int trip, unsigned long *temp)
+{
+	struct db8500_thermal_zone *pzone = thermal->devdata;
+	struct db8500_thsens_platform_data *ptrips = pzone->trip_tab;
+
+	if (trip >= ptrips->num_trips)
+		return -EINVAL;
+
+	*temp = ptrips->trip_points[trip].temp;
+
+	return 0;
+}
+
+/* Callback to get critical trip point temperature */
+static int db8500_sys_get_crit_temp(struct thermal_zone_device *thermal,
+		unsigned long *temp)
+{
+	struct db8500_thermal_zone *pzone = thermal->devdata;
+	struct db8500_thsens_platform_data *ptrips = pzone->trip_tab;
+	int i;
+
+	for (i = ptrips->num_trips - 1; i > 0; i--) {
+		if (ptrips->trip_points[i].type == THERMAL_TRIP_CRITICAL) {
+			*temp = ptrips->trip_points[i].temp;
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
+static struct thermal_zone_device_ops thdev_ops = {
+	.bind = db8500_cdev_bind,
+	.unbind = db8500_cdev_unbind,
+	.get_temp = db8500_sys_get_temp,
+	.get_trend = db8500_sys_get_trend,
+	.get_mode = db8500_sys_get_mode,
+	.set_mode = db8500_sys_set_mode,
+	.get_trip_type = db8500_sys_get_trip_type,
+	.get_trip_temp = db8500_sys_get_trip_temp,
+	.get_crit_temp = db8500_sys_get_crit_temp,
+};
+
+static void db8500_thermal_update_config(struct db8500_thermal_zone *pzone,
+		unsigned int idx, enum thermal_trend trend,
+		unsigned long next_low, unsigned long next_high)
+{
+	prcmu_stop_temp_sense();
+
+	pzone->cur_index = idx;
+	pzone->cur_temp_pseudo = (next_low + next_high)/2;
+	pzone->trend = trend;
+
+	prcmu_config_hotmon((u8)(next_low/1000), (u8)(next_high/1000));
+	prcmu_start_temp_sense(PRCMU_DEFAULT_MEASURE_TIME);
+}
+
+static irqreturn_t prcmu_low_irq_handler(int irq, void *irq_data)
+{
+	struct db8500_thermal_zone *pzone = irq_data;
+	struct db8500_thsens_platform_data *ptrips = pzone->trip_tab;
+	unsigned int idx = pzone->cur_index;
+	unsigned long next_low, next_high;
+
+	if (unlikely(idx == 0))
+		/* Meaningless for thermal management, ignoring it */
+		return IRQ_HANDLED;
+
+	if (idx == 1) {
+		next_high = ptrips->trip_points[0].temp;
+		next_low = PRCMU_DEFAULT_LOW_TEMP;
+	} else {
+		next_high = ptrips->trip_points[idx-1].temp;
+		next_low = ptrips->trip_points[idx-2].temp;
+	}
+	idx -= 1;
+
+	db8500_thermal_update_config(pzone, idx, THERMAL_TREND_DROPPING,
+		next_low, next_high);
+
+	dev_dbg(&pzone->therm_dev->device,
+		"PRCMU set max %ld, min %ld\n", next_high, next_low);
+
+	schedule_work(&pzone->therm_work);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t prcmu_high_irq_handler(int irq, void *irq_data)
+{
+	struct db8500_thermal_zone *pzone = irq_data;
+	struct db8500_thsens_platform_data *ptrips = pzone->trip_tab;
+	unsigned int idx = pzone->cur_index;
+	unsigned long next_low, next_high;
+
+	if (idx < ptrips->num_trips - 1) {
+		next_high = ptrips->trip_points[idx+1].temp;
+		next_low = ptrips->trip_points[idx].temp;
+		idx += 1;
+
+		db8500_thermal_update_config(pzone, idx, THERMAL_TREND_RAISING,
+			next_low, next_high);
+
+		dev_dbg(&pzone->therm_dev->device,
+		"PRCMU set max %ld, min %ld\n", next_high, next_low);
+	} else if (idx == ptrips->num_trips - 1)
+		pzone->cur_temp_pseudo = ptrips->trip_points[idx].temp + 1;
+
+	schedule_work(&pzone->therm_work);
+
+	return IRQ_HANDLED;
+}
+
+static void db8500_thermal_work(struct work_struct *work)
+{
+	enum thermal_device_mode cur_mode;
+	struct db8500_thermal_zone *pzone;
+
+	pzone = container_of(work, struct db8500_thermal_zone, therm_work);
+
+	mutex_lock(&pzone->th_lock);
+	cur_mode = pzone->mode;
+	mutex_unlock(&pzone->th_lock);
+
+	if (cur_mode == THERMAL_DEVICE_DISABLED)
+		return;
+
+	thermal_zone_device_update(pzone->therm_dev);
+	dev_dbg(&pzone->therm_dev->device, "thermal work finished.\n");
+}
+
+#ifdef CONFIG_OF
+static struct db8500_thsens_platform_data*
+		db8500_thermal_parse_dt(struct platform_device *pdev)
+{
+	struct db8500_thsens_platform_data *ptrips;
+	struct device_node *np = pdev->dev.of_node;
+	char prop_name[32];
+	const char *tmp_str;
+	u32 tmp_data;
+	int i, j;
+
+	ptrips = devm_kzalloc(&pdev->dev, sizeof(*ptrips), GFP_KERNEL);
+	if (!ptrips)
+		return NULL;
+
+	if (of_property_read_u32(np, "num-trips", &tmp_data))
+		goto err_parse_dt;
+
+	if (tmp_data > THERMAL_MAX_TRIPS)
+		goto err_parse_dt;
+
+	ptrips->num_trips = tmp_data;
+
+	for (i = 0; i < ptrips->num_trips; i++) {
+		sprintf(prop_name, "trip%d-temp", i);
+		if (of_property_read_u32(np, prop_name, &tmp_data))
+			goto err_parse_dt;
+
+		ptrips->trip_points[i].temp = tmp_data;
+
+		sprintf(prop_name, "trip%d-type", i);
+		if (of_property_read_string(np, prop_name, &tmp_str))
+			goto err_parse_dt;
+
+		if (!strcmp(tmp_str, "active"))
+			ptrips->trip_points[i].type = THERMAL_TRIP_ACTIVE;
+		else if (!strcmp(tmp_str, "passive"))
+			ptrips->trip_points[i].type = THERMAL_TRIP_PASSIVE;
+		else if (!strcmp(tmp_str, "hot"))
+			ptrips->trip_points[i].type = THERMAL_TRIP_HOT;
+		else if (!strcmp(tmp_str, "critical"))
+			ptrips->trip_points[i].type = THERMAL_TRIP_CRITICAL;
+		else
+			goto err_parse_dt;
+
+		sprintf(prop_name, "trip%d-cdev-num", i);
+		if (of_property_read_u32(np, prop_name, &tmp_data))
+			goto err_parse_dt;
+
+		if (tmp_data > COOLING_DEV_MAX)
+			goto err_parse_dt;
+
+		for (j = 0; j < tmp_data; j++) {
+			sprintf(prop_name, "trip%d-cdev-name%d", i, j);
+			if (of_property_read_string(np, prop_name, &tmp_str))
+				goto err_parse_dt;
+
+			if (strlen(tmp_str) >= THERMAL_NAME_LENGTH)
+				goto err_parse_dt;
+
+			strcpy(ptrips->trip_points[i].cdev_name[j], tmp_str);
+		}
+	}
+	return ptrips;
+
+err_parse_dt:
+	dev_err(&pdev->dev, "Parsing device tree data error.\n");
+	return NULL;
+}
+#else
+static inline struct db8500_thsens_platform_data*
+		db8500_thermal_parse_dt(struct platform_device *pdev)
+{
+	return NULL;
+}
+#endif
+
+static int db8500_thermal_probe(struct platform_device *pdev)
+{
+	struct db8500_thermal_zone *pzone = NULL;
+	struct db8500_thsens_platform_data *ptrips = NULL;
+	struct device_node *np = pdev->dev.of_node;
+	int low_irq, high_irq, ret = 0;
+	unsigned long dft_low, dft_high;
+
+	if (np)
+		ptrips = db8500_thermal_parse_dt(pdev);
+	else
+		ptrips = dev_get_platdata(&pdev->dev);
+
+	if (!ptrips)
+		return -EINVAL;
+
+	pzone = devm_kzalloc(&pdev->dev, sizeof(*pzone), GFP_KERNEL);
+	if (!pzone)
+		return -ENOMEM;
+
+	mutex_init(&pzone->th_lock);
+	mutex_lock(&pzone->th_lock);
+
+	pzone->mode = THERMAL_DEVICE_DISABLED;
+	pzone->trip_tab = ptrips;
+
+	INIT_WORK(&pzone->therm_work, db8500_thermal_work);
+
+	low_irq = platform_get_irq_byname(pdev, "IRQ_HOTMON_LOW");
+	if (low_irq < 0) {
+		dev_err(&pdev->dev, "Get IRQ_HOTMON_LOW failed.\n");
+		return low_irq;
+	}
+
+	ret = devm_request_threaded_irq(&pdev->dev, low_irq, NULL,
+		prcmu_low_irq_handler, IRQF_NO_SUSPEND | IRQF_ONESHOT,
+		"dbx500_temp_low", pzone);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to allocate temp low irq.\n");
+		return ret;
+	}
+
+	high_irq = platform_get_irq_byname(pdev, "IRQ_HOTMON_HIGH");
+	if (high_irq < 0) {
+		dev_err(&pdev->dev, "Get IRQ_HOTMON_HIGH failed.\n");
+		return high_irq;
+	}
+
+	ret = devm_request_threaded_irq(&pdev->dev, high_irq, NULL,
+		prcmu_high_irq_handler, IRQF_NO_SUSPEND | IRQF_ONESHOT,
+		"dbx500_temp_high", pzone);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to allocate temp high irq.\n");
+		return ret;
+	}
+
+	pzone->therm_dev = thermal_zone_device_register("db8500_thermal_zone",
+		ptrips->num_trips, 0, pzone, &thdev_ops, 0, 0);
+
+	if (IS_ERR_OR_NULL(pzone->therm_dev)) {
+		dev_err(&pdev->dev, "Register thermal zone device failed.\n");
+		return PTR_ERR(pzone->therm_dev);
+	}
+	dev_info(&pdev->dev, "Thermal zone device registered.\n");
+
+	dft_low = PRCMU_DEFAULT_LOW_TEMP;
+	dft_high = ptrips->trip_points[0].temp;
+
+	db8500_thermal_update_config(pzone, 0, THERMAL_TREND_STABLE,
+		dft_low, dft_high);
+
+	platform_set_drvdata(pdev, pzone);
+	pzone->mode = THERMAL_DEVICE_ENABLED;
+	mutex_unlock(&pzone->th_lock);
+
+	return 0;
+}
+
+static int db8500_thermal_remove(struct platform_device *pdev)
+{
+	struct db8500_thermal_zone *pzone = platform_get_drvdata(pdev);
+
+	thermal_zone_device_unregister(pzone->therm_dev);
+	cancel_work_sync(&pzone->therm_work);
+	mutex_destroy(&pzone->th_lock);
+
+	return 0;
+}
+
+static int db8500_thermal_suspend(struct platform_device *pdev,
+		pm_message_t state)
+{
+	struct db8500_thermal_zone *pzone = platform_get_drvdata(pdev);
+
+	flush_work(&pzone->therm_work);
+	prcmu_stop_temp_sense();
+
+	return 0;
+}
+
+static int db8500_thermal_resume(struct platform_device *pdev)
+{
+	struct db8500_thermal_zone *pzone = platform_get_drvdata(pdev);
+	struct db8500_thsens_platform_data *ptrips = pzone->trip_tab;
+	unsigned long dft_low, dft_high;
+
+	dft_low = PRCMU_DEFAULT_LOW_TEMP;
+	dft_high = ptrips->trip_points[0].temp;
+
+	db8500_thermal_update_config(pzone, 0, THERMAL_TREND_STABLE,
+		dft_low, dft_high);
+
+	return 0;
+}
+
+#ifdef CONFIG_OF
+static const struct of_device_id db8500_thermal_match[] = {
+	{ .compatible = "stericsson,db8500-thermal" },
+	{},
+};
+#else
+#define db8500_thermal_match NULL
+#endif
+
+static struct platform_driver db8500_thermal_driver = {
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "db8500-thermal",
+		.of_match_table = db8500_thermal_match,
+	},
+	.probe = db8500_thermal_probe,
+	.suspend = db8500_thermal_suspend,
+	.resume = db8500_thermal_resume,
+	.remove = db8500_thermal_remove,
+};
+
+module_platform_driver(db8500_thermal_driver);
+
+MODULE_AUTHOR("Hongbo Zhang <hongbo.zhang@stericsson.com>");
+MODULE_DESCRIPTION("DB8500 thermal driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/platform_data/db8500_thermal.h b/include/linux/platform_data/db8500_thermal.h
new file mode 100644
index 0000000..3bf6090
--- /dev/null
+++ b/include/linux/platform_data/db8500_thermal.h
@@ -0,0 +1,38 @@
+/*
+ * db8500_thermal.h - DB8500 Thermal Management Implementation
+ *
+ * Copyright (C) 2012 ST-Ericsson
+ * Copyright (C) 2012 Linaro Ltd.
+ *
+ * Author: Hongbo Zhang <hongbo.zhang@linaro.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _DB8500_THERMAL_H_
+#define _DB8500_THERMAL_H_
+
+#include <linux/thermal.h>
+
+#define COOLING_DEV_MAX 8
+
+struct db8500_trip_point {
+	unsigned long temp;
+	enum thermal_trip_type type;
+	char cdev_name[COOLING_DEV_MAX][THERMAL_NAME_LENGTH];
+};
+
+struct db8500_thsens_platform_data {
+	struct db8500_trip_point trip_points[THERMAL_MAX_TRIPS];
+	int num_trips;
+};
+
+#endif /* _DB8500_THERMAL_H_ */
-- 
1.7.11.3

