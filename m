Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471Ab2EOI4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 04:56:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:52554 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758309Ab2EOI4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 04:56:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="144133778"
From: Jenny TC <jenny.tc@intel.com>
To: khali@linux-fr.org, guenter.roeck@ericsson.com
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Jenny TC <jenny.tc@intel.com>
Subject: [PATCH] hwmon: Generic ADC support for hwmon
Date: Tue, 15 May 2012 19:56:48 +0530
Message-Id: <1337092008-31263-1-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently drivers are using custom APIs to communicate with ADC driver.
So it make sense to have generic APIs to commnicate with ADC drivers.
This patch introduces generic APIs to communicate with ADC drivers.

Signed-off-by: Jenny TC <jenny.tc@intel.com>
---
 drivers/hwmon/Kconfig     |    9 ++
 drivers/hwmon/Makefile    |    1 +
 drivers/hwmon/hwmon-adc.c |  212 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/hwmon-adc.h |   47 ++++++++++
 4 files changed, 269 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hwmon/hwmon-adc.c
 create mode 100644 include/linux/hwmon-adc.h

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 8deedc1..203ed9d 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -37,6 +37,15 @@ config HWMON_DEBUG_CHIP
 	  a problem with I2C support and want to see more of what is going
 	  on.
 
+config HWMON_ADC
+	bool "Hardware Monitoring Generic ADC support"
+	default n
+	help
+	  Say Y here if you want the generic ADC support for Hardware Monitoring
+	  Subsystem. Select this to enable the generic ADC driver APIs.
+	  This enables a set of APIs to register an ADC device with hwmon
+	  subsystem along with generic APIs to communicate with ADC driver
+
 comment "Native drivers"
 
 config SENSORS_ABITUGURU
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 6d3f11f..d91450f 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -4,6 +4,7 @@
 
 obj-$(CONFIG_HWMON)		+= hwmon.o
 obj-$(CONFIG_HWMON_VID)		+= hwmon-vid.o
+obj-$(CONFIG_HWMON_ADC)		+= hwmon-adc.o
 
 # APCI drivers
 obj-$(CONFIG_SENSORS_ACPI_POWER) += acpi_power_meter.o
diff --git a/drivers/hwmon/hwmon-adc.c b/drivers/hwmon/hwmon-adc.c
new file mode 100644
index 0000000..53c910e
--- /dev/null
+++ b/drivers/hwmon/hwmon-adc.c
@@ -0,0 +1,212 @@
+/*
+ *  hwmon-adc.c - Generic adc support for hardware monitoring  subsystem.
+ *
+ *  Copyright (C) 2012 Intel Corp
+ *
+ *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * Author : Jenny TC <jenny.tc@intel.com>
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-adc.h>
+
+LIST_HEAD(adc_lst);
+DEFINE_MUTEX(list_lock);
+
+struct hwmon_adc {
+	struct device *hwdev;
+	struct hwmon_adc_ops *adc_ops;
+	struct list_head list;
+};
+
+/**
+ * hwmon_adc_device_register - register adc device w/ hwmon
+ * @dev: the device to register
+ *
+ * hwmon_adc_device_unregister() must be called when the device is no
+ * longer needed.
+ *
+ * Returns the pointer to the new device.
+ */
+struct device *hwmon_adc_device_register(struct device *dev,
+					 struct hwmon_adc_ops *adc_ops)
+{
+	struct hwmon_adc *adc_node;
+	struct device *hwdev;
+
+	hwdev = hwmon_device_register(dev);
+	if (IS_ERR(hwdev))
+		return hwdev;
+
+	adc_node = kzalloc(sizeof(struct hwmon_adc), GFP_ATOMIC);
+	adc_node->hwdev = hwdev;
+	adc_node->adc_ops = adc_ops;
+	mutex_lock(&list_lock);
+	list_add(&adc_node->list, &adc_lst);
+	mutex_unlock(&list_lock);
+
+	return hwdev;
+}
+EXPORT_SYMBOL(hwmon_adc_device_register);
+
+/**
+ * hwmon_adc_device_unregister - removes the previously registered hwmon class device
+ *
+ * @dev: the class device to destroy
+ */
+void hwmon_adc_device_unregister(struct device *hwdev)
+{
+
+	struct list_head *p, *n;
+	struct hwmon_adc *tmp;
+
+	mutex_lock(&list_lock);
+	list_for_each_safe(p, n, &adc_lst) {
+		tmp = list_entry(p, struct hwmon_adc, list);
+		if (tmp->hwdev == hwdev) {
+			hwmon_device_unregister(hwdev);
+			list_del(&tmp->list);
+			kfree(tmp);
+			break;
+		}
+	}
+	mutex_unlock(&list_lock);
+}
+EXPORT_SYMBOL(hwmon_adc_device_unregister);
+
+static struct hwmon_adc_ops *__get_ops_byname(char *name)
+{
+	struct list_head *l;
+	struct hwmon_adc *tmp;
+	struct hwmon_adc_ops *ops = NULL;
+
+	mutex_lock(&list_lock);
+	list_for_each(l, &adc_lst) {
+		tmp = list_entry(l, struct hwmon_adc, list);
+		if (!strcmp(dev_driver_string(tmp->hwdev->parent), name)) {
+			ops =  tmp->adc_ops;
+			break;
+		}
+	}
+	mutex_unlock(&list_lock);
+	return ops;
+}
+
+/**
+ * hwmon_adc_read_adc_channel - read an ADC channel
+ * @adc_name : adc device name
+ * @channel  : channel to read
+ * @adc_val  : pointer to store adc value
+ *
+ * Returns the return value from read_adc callback function on success
+ * else return -ENODEV
+ */
+int hwmon_adc_read_channel(char *adc_name, int channel, unsigned int *adc_val)
+{
+	struct hwmon_adc_ops *adc_ops;
+
+	adc_ops = __get_ops_byname(adc_name);
+
+	if (adc_ops && adc_ops->read_adc)
+		return adc_ops->read_adc(channel, adc_val);
+
+	return -ENODEV;
+}
+EXPORT_SYMBOL(hwmon_adc_read_channel);
+
+/**
+ * hwmon_adc_read_adc_channel - read multiple ADC channels
+ * @adc_name : adc device name
+ * @channel  : channels to read
+ * @adc_val  : pointer to store adc values
+ * @count    : number of channels to read
+ *
+ * Returns the return value from read_adc_multi callback function on success
+ * else return -ENODEV
+ */
+int hwmon_adc_read_channel_multi(char *adc_name, int *channel,
+		unsigned int *adc_val, int count)
+{
+	struct hwmon_adc_ops *adc_ops;
+
+	adc_ops = __get_ops_byname(adc_name);
+
+	if (adc_ops && adc_ops->read_adc_multi)
+		return adc_ops->read_adc_multi(channel, adc_val, count);
+
+	return -ENODEV;
+}
+EXPORT_SYMBOL(hwmon_adc_read_channel_multi);
+
+/**
+ * hwmon_adc_convert_channel - convert raw ADC value
+ * to voltage/current/temperature etc.
+ *
+ * @adc_name : adc device name
+ * @channel  : channel to convert
+ * @adc_val  : adc value to convert
+ * @cvtd_val : pointer to store converted value
+ *
+ * Returns the return value from convert_adcval callback function on success
+ * else return -ENODEV
+ */
+int hwmon_adc_convert_adcval(char *adc_name, int channel, unsigned int adc_val,
+		      int *cvtd_val)
+{
+	struct hwmon_adc_ops *adc_ops;
+
+	adc_ops = __get_ops_byname(adc_name);
+
+	if (adc_ops && adc_ops->convert_adcval)
+		return adc_ops->convert_adcval(channel, adc_val, cvtd_val);
+
+	return -ENODEV;
+
+}
+EXPORT_SYMBOL(hwmon_adc_convert_adcval);
+
+/**
+ * hwmon_adc_convert_channel - convert raw ADC value
+ * to voltage/current/temperature etc.
+ *
+ * @adc_name : adc device name
+ * @channel  : channels to convert
+ * @adc_val  : adc values to convert
+ * @cvtd_val : pointer to store converted values
+ * @count    : number of channels to convert
+ *
+ * Returns the return value from convert_adcval_multi callback function on
+ * success else return -ENODEV
+ */
+int hwmon_adc_convert_adcval_multi(char *adc_name, int *channel,
+		unsigned int *adc_val, int *cvtd_val, int count)
+{
+
+	struct hwmon_adc_ops *adc_ops;
+
+	adc_ops = __get_ops_byname(adc_name);
+
+	if (adc_ops && adc_ops->convert_adcval_multi)
+		return adc_ops->convert_adcval_multi(channel, adc_val, cvtd_val,
+						     count);
+	return -ENODEV;
+}
+EXPORT_SYMBOL(hwmon_adc_convert_adcval_multi);
diff --git a/include/linux/hwmon-adc.h b/include/linux/hwmon-adc.h
new file mode 100644
index 0000000..c4e9fc0
--- /dev/null
+++ b/include/linux/hwmon-adc.h
@@ -0,0 +1,47 @@
+/*
+ *  hwmon-adc.h - Header file for hardware monitoring generic adc support.
+ *
+ *  This file declares helper functions for generic adc support for hardware
+ *  monitoring subsystem.
+ *
+ *  Copyright (C) 2012 Intel Corp
+ *
+ *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * Author : Jenny TC <jenny.tc@intel.com>
+ */
+#ifndef _LINUX_HWMON_ADC_H
+#define _LINUX_HWMON_ADC_H
+struct hwmon_adc_ops {
+	int (*read_adc) (int channel, unsigned int *adc_val);
+	int (*read_adc_multi) (int *channel, unsigned int *adc_val, int count);
+	int (*convert_adcval) (int channel, unsigned int adc_val,
+					int *cvtd_val);
+	int (*convert_adcval_multi) (int *channel, unsigned int *adc_val,
+			int *cvtd_val, int count);
+};
+struct device *hwmon_adc_device_register(struct device *dev,
+		struct hwmon_adc_ops *adc_ops);
+void hwmon_adc_device_unregister(struct device *dev);
+int hwmon_adc_read_channel(char *adc_name, int channel, unsigned int *adc_val);
+int hwmon_adc_read_channel_multi(char *adc_name, int *channel,
+			unsigned int *adc_val, int count);
+int hwmon_adc_convert_adcval(char *adc_name, int channel, unsigned int adc_val,
+			int *cvtd_val);
+int hwmon_adc_convert_adcval_multi(char *adc_name, int *channel,
+			unsigned int *adc_val, int *cvtd_val, int count);
+#endif
-- 
1.7.1

