Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab2JIGD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:03:29 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:34159 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab2JIGDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:03:22 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        SangWook Ju <sw.ju@samsung.com>, Durgadoss <durgadoss.r@intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        Kyungmin Park <kmpark@infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 19/30] hwmon: exynos4: move thermal sensor driver to driver/thermal directory
Date: Tue,  9 Oct 2012 01:54:09 -0400
Message-Id: <c48cbba6fee3587bdfe77ef850a1a0aa30a2a60f.1349761836.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0.rc1
In-Reply-To: <1349762060-25334-1-git-send-email-lenb@kernel.org>
References: <1349762060-25334-1-git-send-email-lenb@kernel.org>
In-Reply-To: <e3f25e6e5836c4790fbe395ff42e241f372d859d.1349761836.git.len.brown@intel.com>
References: <e3f25e6e5836c4790fbe395ff42e241f372d859d.1349761836.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Daniel Kachhap <amit.kachhap@linaro.org>

This movement is needed because the hwmon entries and corresponding sysfs
interface is a duplicate of utilities already provided by
driver/thermal/thermal_sys.c.  The goal is to place it in thermal folder
and add necessary functions to use the in-kernel thermal interfaces.

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
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 .../{hwmon/exynos4_tmu => thermal/exynos_thermal}  |  35 +------
 drivers/hwmon/Kconfig                              |  10 --
 drivers/hwmon/Makefile                             |   1 -
 drivers/thermal/Kconfig                            |   7 ++
 drivers/thermal/Makefile                           |   1 +
 .../exynos4_tmu.c => thermal/exynos_thermal.c}     | 113 +--------------------
 .../{exynos4_tmu.h => exynos_thermal.h}            |   8 +-
 7 files changed, 19 insertions(+), 156 deletions(-)
 rename Documentation/{hwmon/exynos4_tmu => thermal/exynos_thermal} (71%)
 rename drivers/{hwmon/exynos4_tmu.c => thermal/exynos_thermal.c} (74%)
 rename include/linux/platform_data/{exynos4_tmu.h => exynos_thermal.h} (94%)

diff --git a/Documentation/hwmon/exynos4_tmu b/Documentation/thermal/exynos_thermal
similarity index 71%
rename from Documentation/hwmon/exynos4_tmu
rename to Documentation/thermal/exynos_thermal
index c3c6b41..2b46f67 100644
--- a/Documentation/hwmon/exynos4_tmu
+++ b/Documentation/thermal/exynos_thermal
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
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index b0a2e4c..84e02b4 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -324,16 +324,6 @@ config SENSORS_DA9052_ADC
 	  This driver can also be built as module. If so, the module
 	  will be called da9052-hwmon.
 
-config SENSORS_EXYNOS4_TMU
-	tristate "Temperature sensor on Samsung EXYNOS4"
-	depends on ARCH_EXYNOS4
-	help
-	  If you say yes here you get support for TMU (Thermal Management
-	  Unit) on SAMSUNG EXYNOS4 series of SoC.
-
-	  This driver can also be built as a module. If so, the module
-	  will be called exynos4-tmu.
-
 config SENSORS_I5K_AMB
 	tristate "FB-DIMM AMB temperature sensor on Intel 5000 series chipsets"
 	depends on PCI && EXPERIMENTAL
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 7aa9811..3eafe48 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -49,7 +49,6 @@ obj-$(CONFIG_SENSORS_DS1621)	+= ds1621.o
 obj-$(CONFIG_SENSORS_EMC1403)	+= emc1403.o
 obj-$(CONFIG_SENSORS_EMC2103)	+= emc2103.o
 obj-$(CONFIG_SENSORS_EMC6W201)	+= emc6w201.o
-obj-$(CONFIG_SENSORS_EXYNOS4_TMU)	+= exynos4_tmu.o
 obj-$(CONFIG_SENSORS_F71805F)	+= f71805f.o
 obj-$(CONFIG_SENSORS_F71882FG)	+= f71882fg.o
 obj-$(CONFIG_SENSORS_F75375S)	+= f75375s.o
diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 996003b..8f2b6ea 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -46,3 +46,10 @@ config RCAR_THERMAL
 	help
 	  Enable this to plug the R-Car thermal sensor driver into the Linux
 	  thermal framework
+
+config EXYNOS_THERMAL
+	tristate "Temperature sensor on Samsung EXYNOS"
+	depends on ARCH_EXYNOS4 && THERMAL
+	help
+	  If you say yes here you get support for TMU (Thermal Managment
+	  Unit) on SAMSUNG EXYNOS series of SoC.
diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
index aae59ad..885550d 100644
--- a/drivers/thermal/Makefile
+++ b/drivers/thermal/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_THERMAL)		+= thermal_sys.o
 obj-$(CONFIG_CPU_THERMAL)		+= cpu_cooling.o
 obj-$(CONFIG_SPEAR_THERMAL)		+= spear_thermal.o
 obj-$(CONFIG_RCAR_THERMAL)	+= rcar_thermal.o
+obj-$(CONFIG_EXYNOS_THERMAL)		+= exynos_thermal.o
diff --git a/drivers/hwmon/exynos4_tmu.c b/drivers/thermal/exynos_thermal.c
similarity index 74%
rename from drivers/hwmon/exynos4_tmu.c
rename to drivers/thermal/exynos_thermal.c
index e912059..556d15b 100644
--- a/drivers/hwmon/exynos4_tmu.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -1,8 +1,9 @@
 /*
- * exynos4_tmu.c - Samsung EXYNOS4 TMU (Thermal Management Unit)
+ * exynos_thermal.c - Samsung EXYNOS TMU (Thermal Management Unit)
  *
  *  Copyright (C) 2011 Samsung Electronics
  *  Donggeun Kim <dg77.kim@samsung.com>
+ *  Amit Daniel Kachhap <amit.kachhap@linaro.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -33,10 +34,7 @@
 #include <linux/io.h>
 #include <linux/mutex.h>
 
-#include <linux/hwmon.h>
-#include <linux/hwmon-sysfs.h>
-
-#include <linux/platform_data/exynos4_tmu.h>
+#include <linux/platform_data/exynos_thermal.h>
 
 #define EXYNOS4_TMU_REG_TRIMINFO	0x0
 #define EXYNOS4_TMU_REG_CONTROL		0x20
@@ -70,7 +68,6 @@
 
 struct exynos4_tmu_data {
 	struct exynos4_tmu_platform_data *pdata;
-	struct device *hwmon_dev;
 	struct resource *mem;
 	void __iomem *base;
 	int irq;
@@ -246,8 +243,6 @@ static void exynos4_tmu_work(struct work_struct *work)
 
 	writel(EXYNOS4_TMU_INTCLEAR_VAL, data->base + EXYNOS4_TMU_REG_INTCLEAR);
 
-	kobject_uevent(&data->hwmon_dev->kobj, KOBJ_CHANGE);
-
 	enable_irq(data->irq);
 
 	clk_disable(data->clk);
@@ -264,87 +259,6 @@ static irqreturn_t exynos4_tmu_irq(int irq, void *id)
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
-};
-
 static int __devinit exynos4_tmu_probe(struct platform_device *pdev)
 {
 	struct exynos4_tmu_data *data;
@@ -418,25 +332,9 @@ static int __devinit exynos4_tmu_probe(struct platform_device *pdev)
 		goto err_clk;
 	}
 
-	ret = sysfs_create_group(&pdev->dev.kobj, &exynos4_tmu_attr_group);
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to create sysfs group\n");
-		goto err_clk;
-	}
-
-	data->hwmon_dev = hwmon_device_register(&pdev->dev);
-	if (IS_ERR(data->hwmon_dev)) {
-		ret = PTR_ERR(data->hwmon_dev);
-		dev_err(&pdev->dev, "Failed to register hwmon device\n");
-		goto err_create_group;
-	}
-
 	exynos4_tmu_control(pdev, true);
 
 	return 0;
-
-err_create_group:
-	sysfs_remove_group(&pdev->dev.kobj, &exynos4_tmu_attr_group);
 err_clk:
 	platform_set_drvdata(pdev, NULL);
 	clk_put(data->clk);
@@ -458,9 +356,6 @@ static int __devexit exynos4_tmu_remove(struct platform_device *pdev)
 
 	exynos4_tmu_control(pdev, false);
 
-	hwmon_device_unregister(data->hwmon_dev);
-	sysfs_remove_group(&pdev->dev.kobj, &exynos4_tmu_attr_group);
-
 	clk_put(data->clk);
 
 	free_irq(data->irq, data);
@@ -495,7 +390,7 @@ static int exynos4_tmu_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(exynos4_tmu_pm,
 			 exynos4_tmu_suspend, exynos4_tmu_resume);
-#define EXYNOS4_TMU_PM	&exynos4_tmu_pm
+#define EXYNOS4_TMU_PM	(&exynos4_tmu_pm)
 #else
 #define EXYNOS4_TMU_PM	NULL
 #endif
diff --git a/include/linux/platform_data/exynos4_tmu.h b/include/linux/platform_data/exynos_thermal.h
similarity index 94%
rename from include/linux/platform_data/exynos4_tmu.h
rename to include/linux/platform_data/exynos_thermal.h
index 39e038c..d6c3f93 100644
--- a/include/linux/platform_data/exynos4_tmu.h
+++ b/include/linux/platform_data/exynos_thermal.h
@@ -1,5 +1,5 @@
 /*
- * exynos4_tmu.h - Samsung EXYNOS4 TMU (Thermal Management Unit)
+ * exynos_thermal.h - Samsung EXYNOS4 TMU (Thermal Management Unit)
  *
  *  Copyright (C) 2011 Samsung Electronics
  *  Donggeun Kim <dg77.kim@samsung.com>
@@ -19,8 +19,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#ifndef _LINUX_EXYNOS4_TMU_H
-#define _LINUX_EXYNOS4_TMU_H
+#ifndef _LINUX_EXYNOS_THERMAL_H
+#define _LINUX_EXYNOS_THERMAL_H
 
 enum calibration_type {
 	TYPE_ONE_POINT_TRIMMING,
@@ -80,4 +80,4 @@ struct exynos4_tmu_platform_data {
 
 	enum calibration_type cal_type;
 };
-#endif /* _LINUX_EXYNOS4_TMU_H */
+#endif /* _LINUX_EXYNOS_THERMAL_H */
-- 
1.8.0.rc1

