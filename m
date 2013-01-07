Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab3AGHS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 02:18:56 -0500
Received: from mga03.intel.com ([143.182.124.21]:19149 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab3AGHSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 02:18:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,422,1355126400"; 
   d="scan'208";a="240732871"
From: Durgadoss R <durgadoss.r@intel.com>
To: rui.zhang@intel.com, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, eduardo.valentin@ti.com,
        hongbo.zhang@linaro.org, wni@nvidia.com,
        Durgadoss R <durgadoss.r@intel.com>
Subject: [PATCH 9/9] Thermal: Dummy driver used for testing
Date: Mon,  7 Jan 2013 12:43:26 +0530
Message-Id: <1357542806-20449-10-git-send-email-durgadoss.r@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357542806-20449-1-git-send-email-durgadoss.r@intel.com>
References: <1357542806-20449-1-git-send-email-durgadoss.r@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch has a dummy driver that can be used for
testing purposes. This patch is not for merge.

Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
---
 drivers/thermal/Kconfig        |    5 +
 drivers/thermal/Makefile       |    3 +
 drivers/thermal/thermal_test.c |  329 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 337 insertions(+)
 create mode 100644 drivers/thermal/thermal_test.c

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index c5ba3340..3b92a76 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -136,4 +136,9 @@ config DB8500_CPUFREQ_COOLING
 	  bound cpufreq cooling device turns active to set CPU frequency low to
 	  cool down the CPU.
 
+config THERMAL_TEST
+	tristate "test driver"
+	help
+	  Enable this to test the thermal framework.
+
 endif
diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
index d8da683..02c3edb 100644
--- a/drivers/thermal/Makefile
+++ b/drivers/thermal/Makefile
@@ -18,3 +18,6 @@ obj-$(CONFIG_RCAR_THERMAL)	+= rcar_thermal.o
 obj-$(CONFIG_EXYNOS_THERMAL)	+= exynos_thermal.o
 obj-$(CONFIG_DB8500_THERMAL)	+= db8500_thermal.o
 obj-$(CONFIG_DB8500_CPUFREQ_COOLING)	+= db8500_cpufreq_cooling.o
+
+# dummy driver for testing
+obj-$(CONFIG_THERMAL_TEST)	+= thermal_test.o
diff --git a/drivers/thermal/thermal_test.c b/drivers/thermal/thermal_test.c
new file mode 100644
index 0000000..137b562
--- /dev/null
+++ b/drivers/thermal/thermal_test.c
@@ -0,0 +1,329 @@
+/*
+ * thermal_test.c - This driver can be used to test Thermal
+ *			   Framework changes. Not specific to any
+ *			   platform. Fills the log buffer generously ;)
+ *
+ * Copyright (C) 2012 Intel Corporation
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * Author: Durgadoss R <durgadoss.r@intel.com>
+ */
+
+#define pr_fmt(fmt)  "thermal_test: " fmt
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/param.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/pm.h>
+#include <linux/platform_device.h>
+#include <linux/thermal.h>
+
+#define MAX_THERMAL_ZONES	2
+#define MAX_THERMAL_SENSORS	2
+#define MAX_COOLING_DEVS	4
+#define NUM_THRESHOLDS		3
+
+static struct ts_data {
+	int curr_temp;
+	int flag;
+} ts_data;
+
+int active_trips[10] = {100, 90, 80, 70, 60, 50, 40, 30, 20, 10};
+int passive_trips[5] = {100, 90, 60, 50, 40};
+int wts[5] = {50, 50, 50, 50, 40};
+
+static struct platform_device *pdev;
+static unsigned long cur_cdev_state = 2;
+static struct thermal_sensor *ts, *ts1;
+static struct thermal_zone *tz;
+static struct thermal_cooling_device *cdev;
+
+static long thermal_thresholds[NUM_THRESHOLDS] = {30000, 40000, 50000};
+
+static struct thermal_trip_point trip = {
+	.hot = 90,
+	.crit = 100,
+	.num_passive_trips = 5,
+	.passive_trips = passive_trips,
+	.num_active_trips = 10,
+	.active_trips = active_trips,
+	.active_trip_mask = 0xCFF,
+};
+
+static struct thermal_trip_point trip1 = {
+	.hot = 95,
+	.crit = 125,
+	.num_passive_trips = 0,
+	.passive_trips = passive_trips,
+	.num_active_trips = 6,
+	.active_trips = active_trips,
+	.active_trip_mask = 0xFF,
+};
+
+static struct thermal_map map = {
+	.trip_type = THERMAL_TRIP_PASSIVE,
+	.sensor_name = "ts",
+	.cdev_name = "cdev",
+	.num_weights = 5,
+	.trip_mask = 0x0F,
+	.weights = wts,
+};
+
+static int read_cur_state(struct thermal_cooling_device *cdev,
+			unsigned long *state)
+{
+	*state = cur_cdev_state;
+	return 0;
+}
+
+static int write_cur_state(struct thermal_cooling_device *cdev,
+			unsigned long state)
+{
+	cur_cdev_state = state;
+	return 0;
+}
+
+static int read_max_state(struct thermal_cooling_device *cdev,
+			unsigned long *state)
+{
+	*state = 5;
+	return 0;
+}
+
+static int read_curr_temp(struct thermal_sensor *ts, long *temp)
+{
+	*temp = ts_data.curr_temp;
+	return 0;
+}
+
+static ssize_t
+flag_show(struct device *dev, struct device_attribute *devattr, char *buf)
+{
+	return sprintf(buf, "%d\n", ts_data.flag);
+}
+
+static ssize_t
+flag_store(struct device *dev, struct device_attribute *attr,
+		    const char *buf, size_t count)
+{
+	long flag;
+
+	if (kstrtol(buf, 10, &flag))
+		return -EINVAL;
+
+	ts_data.flag = flag;
+
+	if (flag == 0) {
+		thermal_sensor_unregister(ts);
+		ts = NULL;
+		pr_err("thermal_sensor_unregister (ts) done\n");
+	} else if (flag == 1) {
+		thermal_sensor_unregister(ts1);
+		ts1 = NULL;
+		pr_err("thermal_sensor_unregister (ts1) done\n");
+	} else if (flag == 2) {
+		thermal_cooling_device_unregister(cdev);
+		cdev = NULL;
+		pr_err("cdev unregister (cdev) done\n");
+	} else if (flag == 3) {
+		if (tz)
+			remove_thermal_zone(tz);
+		tz = NULL;
+		pr_err("removed thermal zone\n");
+	}
+
+	return count;
+}
+
+static ssize_t
+temp_show(struct device *dev, struct device_attribute *devattr, char *buf)
+{
+	return sprintf(buf, "%d\n", ts_data.curr_temp);
+}
+
+static int read_threshold(struct thermal_sensor *ts, int indx, long *val)
+{
+	if (indx < 0 || indx >= NUM_THRESHOLDS)
+		return -EINVAL;
+
+	*val = thermal_thresholds[indx];
+	return 0;
+}
+
+static int write_threshold(struct thermal_sensor *ts, int indx, long val)
+{
+	if (indx < 0 || indx >= NUM_THRESHOLDS)
+		return -EINVAL;
+
+	thermal_thresholds[indx] = val;
+	return 0;
+}
+
+static ssize_t
+temp_store(struct device *dev, struct device_attribute *attr,
+		    const char *buf, size_t count)
+{
+	long temp;
+
+	if (kstrtol(buf, 10, &temp))
+		return -EINVAL;
+
+	ts_data.curr_temp = temp;
+	return count;
+}
+
+static struct thermal_sensor_ops ts_ops = {
+	.get_temp = read_curr_temp,
+	.get_threshold = read_threshold,
+	.set_threshold = write_threshold,
+};
+
+static struct thermal_sensor_ops ts1_ops = {
+	.get_temp = read_curr_temp,
+	.get_threshold = read_threshold,
+	.set_threshold = write_threshold,
+};
+
+static struct thermal_cooling_device_ops cdev_ops = {
+	.get_cur_state = read_cur_state,
+	.set_cur_state = write_cur_state,
+	.get_max_state = read_max_state,
+};
+
+static DEVICE_ATTR(test_temp, S_IRUGO | S_IWUSR, temp_show, temp_store);
+static DEVICE_ATTR(sensor_enable, S_IRUGO | S_IWUSR, flag_show, flag_store);
+
+static int thermal_test_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	ts_data.curr_temp = 30000;
+	ts_data.flag = 1;
+
+	ts = thermal_sensor_register("ts", NUM_THRESHOLDS, &ts_ops, &ts_data);
+	if (!ts) {
+		pr_err("thermal_sensor_register failed:\n");
+		return -EINVAL;
+	}
+
+	ts1 = thermal_sensor_register("ts1", NUM_THRESHOLDS, &ts1_ops, NULL);
+
+	cdev = thermal_cooling_device_register("cdev", NULL, &cdev_ops);
+	if (!cdev) {
+		pr_err("cdev_register failed:\n");
+		return -EINVAL;
+	}
+
+	device_create_file(&pdev->dev, &dev_attr_test_temp);
+	device_create_file(&pdev->dev, &dev_attr_sensor_enable);
+
+	/* Create a zone */
+	tz = create_thermal_zone("myZone", NULL);
+	if (!tz) {
+		pr_err("create_thermal_zone failed:\n");
+		return -EINVAL;
+	}
+
+	pr_err("Zone created successfully..\n");
+
+	ret = add_sensor_to_zone(tz, ts);
+	if (ret) {
+		pr_err("add_sensor_to_zone failed:%d\n", ret);
+		return ret;
+	}
+
+	ret = add_sensor_to_zone(tz, ts1);
+	pr_err("add_sensor (ts1) ret_val: %d\n", ret);
+
+	ret = add_cdev_to_zone(tz, cdev);
+	pr_err("add_cdev_to_zone (cdev) ret_val: %d\n", ret);
+
+	ret = add_sensor_trip_info(tz, ts, &trip);
+	ret = add_sensor_trip_info(tz, ts1, &trip1);
+	pr_err("add_sensor_trip_info (ts) ret_val: %d\n", ret);
+
+	ret = add_map_entry(tz, &map);
+	pr_err("add_map_entry (ts) ret_val: %d\n", ret);
+
+	return 0;
+}
+
+static int thermal_test_remove(struct platform_device *pdev)
+{
+	device_remove_file(&pdev->dev, &dev_attr_test_temp);
+	device_remove_file(&pdev->dev, &dev_attr_sensor_enable);
+
+	return 0;
+}
+
+/*********************************************************************
+ *		Driver initialization and finalization
+ *********************************************************************/
+
+#define DRIVER_NAME "thermal_test"
+
+static const struct platform_device_id therm_id_table[] = {
+	{ DRIVER_NAME, 1 },
+};
+
+static struct platform_driver thermal_test_driver = {
+	.driver = {
+		.name = DRIVER_NAME,
+		.owner = THIS_MODULE,
+	},
+	.probe = thermal_test_probe,
+	.remove = __devexit_p(thermal_test_remove),
+	.id_table = therm_id_table,
+};
+
+static int __init thermal_test_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&thermal_test_driver);
+	if (ret) {
+		pr_err("platform driver register failed:%d\n", ret);
+		return ret;
+	}
+
+	pdev = platform_device_register_simple(DRIVER_NAME, -1, NULL, 0);
+	if (IS_ERR(pdev)) {
+		ret = PTR_ERR(pdev);
+		pr_err("platform device register failed:%d\n", ret);
+		platform_driver_unregister(&thermal_test_driver);
+	}
+
+	return ret;
+}
+
+static void __exit thermal_test_exit(void)
+{
+	pr_err("in thermal_test_exit\n");
+	platform_device_unregister(pdev);
+	platform_driver_unregister(&thermal_test_driver);
+}
+
+module_init(thermal_test_init);
+module_exit(thermal_test_exit);
+
+MODULE_AUTHOR("Durgadoss R <durgadoss.r@intel.com>");
+MODULE_DESCRIPTION("A dummy driver to test Thermal Framework");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

