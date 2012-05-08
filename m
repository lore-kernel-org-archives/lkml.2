Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab2EHQSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 12:18:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56888 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129Ab2EHQSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 12:18:45 -0400
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: akpm@linux-foundation.org, linux-pm@lists.linux-foundation.org
Cc: durgadoss.r@intel.com, linux-acpi@vger.kernel.org, lenb@kernel.org,
        rui.zhang@intel.com, amit.kachhap@linaro.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org
Subject: [PATCH v3 2/6] thermal: Add generic cpufreq cooling implementation
Date: Tue,  8 May 2012 21:48:14 +0530
Message-Id: <1336493898-7039-3-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1336493898-7039-2-git-send-email-amit.kachhap@linaro.org>
References: <1336493898-7039-1-git-send-email-amit.kachhap@linaro.org>
 <1336493898-7039-2-git-send-email-amit.kachhap@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for generic cpu thermal cooling low level
implementations using frequency scaling up/down based on the registration
parameters. Different cpu related cooling devices can be registered by the
user and the binding of these cooling devices to the corresponding
trip points can be easily done as the registration APIs return the
cooling device pointer. The user of these APIs are responsible for
passing clipping frequency . The drivers can also register to recieve
notification about any cooling action called. Even the driver can effect
the cooling action by modifying the default data such as freq_clip_max if
needed.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
---
 Documentation/thermal/cpu-cooling-api.txt |   60 +++++
 drivers/thermal/Kconfig                   |   11 +
 drivers/thermal/Makefile                  |    3 +-
 drivers/thermal/cpu_cooling.c             |  359 +++++++++++++++++++++++++++++
 include/linux/cpu_cooling.h               |   62 +++++
 5 files changed, 494 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/thermal/cpu-cooling-api.txt
 create mode 100644 drivers/thermal/cpu_cooling.c
 create mode 100644 include/linux/cpu_cooling.h

diff --git a/Documentation/thermal/cpu-cooling-api.txt b/Documentation/thermal/cpu-cooling-api.txt
new file mode 100644
index 0000000..3720341
--- /dev/null
+++ b/Documentation/thermal/cpu-cooling-api.txt
@@ -0,0 +1,60 @@
+CPU cooling APIs How To
+===================================
+
+Written by Amit Daniel Kachhap <amit.kachhap@linaro.org>
+
+Updated: 9 March 2012
+
+Copyright (c)  2011 Samsung Electronics Co., Ltd(http://www.samsung.com)
+
+0. Introduction
+
+The generic cpu cooling(freq clipping, cpuhotplug) provides
+registration/unregistration APIs to the caller. The binding of the cooling
+devices to the trip point is left for the user. The registration APIs returns
+the cooling device pointer.
+
+1. cpu cooling APIs
+
+1.1 cpufreq registration/unregistration APIs
+1.1.1 struct thermal_cooling_device *cpufreq_cooling_register(
+	struct freq_clip_table *tab_ptr, unsigned int tab_size,
+	const struct cpumask *mask_val)
+
+    This interface function registers the cpufreq cooling device with the name
+    "thermal-cpufreq-%x". This api can support multiple instances of cpufreq
+    cooling devices.
+
+    tab_ptr: The table containing the maximum value of frequency to be clipped
+    for each cooling state.
+	.freq_clip_max: Value of frequency to be clipped for each allowed
+	 cpus.
+    tab_size: the total number of cpufreq cooling states.
+    mask_val: all the allowed cpu's where frequency clipping can happen.
+
+1.1.2 void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
+
+    This interface function unregisters the "thermal-cpufreq-%x" cooling device.
+
+    cdev: Cooling device pointer which has to be unregistered.
+
+
+2. CPU cooling action notifier interface
+
+2.1 int cputherm_register_notifier(struct notifier_block *nb,
+	unsigned int list)
+
+    This interface registers a driver with cpu cooling layer. The driver will
+    be notified when any cpu cooling action is called.
+
+    nb: notifier function to register
+    list: CPUFREQ_COOLING_TYPE or CPUHOTPLUG_COOLING_TYPE
+
+2.2 int cputherm_unregister_notifier(struct notifier_block *nb,
+	unsigned int list)
+
+    This interface registers a driver with cpu cooling layer. The driver will
+    be notified when any cpu cooling action is called.
+
+    nb: notifier function to register
+    list: CPUFREQ_COOLING_TYPE or CPUHOTPLUG_COOLING_TYPE
diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 514a691..d9c529f 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -19,6 +19,17 @@ config THERMAL_HWMON
 	depends on HWMON=y || HWMON=THERMAL
 	default y
 
+config CPU_THERMAL
+	bool "generic cpu cooling support"
+	depends on THERMAL && CPU_FREQ
+	help
+	  This implements the generic cpu cooling mechanism through frequency
+	  reduction, cpu hotplug and any other ways of reducing temperature. An
+	  ACPI version of this already exists(drivers/acpi/processor_thermal.c).
+	  This will be useful for platforms using the generic thermal interface
+	  and not the ACPI interface.
+	  If you want this support, you should say Y or M here.
+
 config SPEAR_THERMAL
 	bool "SPEAr thermal sensor driver"
 	depends on THERMAL
diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
index a9fff0b..30c456c 100644
--- a/drivers/thermal/Makefile
+++ b/drivers/thermal/Makefile
@@ -3,4 +3,5 @@
 #
 
 obj-$(CONFIG_THERMAL)		+= thermal_sys.o
-obj-$(CONFIG_SPEAR_THERMAL)		+= spear_thermal.o
\ No newline at end of file
+obj-$(CONFIG_CPU_THERMAL)       += cpu_cooling.o
+obj-$(CONFIG_SPEAR_THERMAL)		+= spear_thermal.o
diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
new file mode 100644
index 0000000..ee2c96d
--- /dev/null
+++ b/drivers/thermal/cpu_cooling.c
@@ -0,0 +1,359 @@
+/*
+ *  linux/drivers/thermal/cpu_cooling.c
+ *
+ *  Copyright (C) 2011	Samsung Electronics Co., Ltd(http://www.samsung.com)
+ *  Copyright (C) 2011  Amit Daniel <amit.kachhap@linaro.org>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/thermal.h>
+#include <linux/platform_device.h>
+#include <linux/cpufreq.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/cpu.h>
+#include <linux/cpu_cooling.h>
+
+struct cpufreq_cooling_device {
+	int id;
+	struct thermal_cooling_device *cool_dev;
+	struct freq_clip_table *tab_ptr;
+	unsigned int tab_size;
+	unsigned int cpufreq_state;
+	const struct cpumask *allowed_cpus;
+	struct list_head node;
+};
+
+static LIST_HEAD(cooling_cpufreq_list);
+static DEFINE_MUTEX(cooling_cpufreq_lock);
+static DEFINE_IDR(cpufreq_idr);
+static DEFINE_PER_CPU(unsigned int, max_policy_freq);
+static struct freq_clip_table *notify_table;
+static int notify_state;
+static BLOCKING_NOTIFIER_HEAD(cputherm_state_notifier_list);
+
+static int get_idr(struct idr *idr, struct mutex *lock, int *id)
+{
+	int err;
+again:
+	if (unlikely(idr_pre_get(idr, GFP_KERNEL) == 0))
+		return -ENOMEM;
+
+	if (lock)
+		mutex_lock(lock);
+	err = idr_get_new(idr, NULL, id);
+	if (lock)
+		mutex_unlock(lock);
+	if (unlikely(err == -EAGAIN))
+		goto again;
+	else if (unlikely(err))
+		return err;
+
+	*id = *id & MAX_ID_MASK;
+	return 0;
+}
+
+static void release_idr(struct idr *idr, struct mutex *lock, int id)
+{
+	if (lock)
+		mutex_lock(lock);
+	idr_remove(idr, id);
+	if (lock)
+		mutex_unlock(lock);
+}
+
+int cputherm_register_notifier(struct notifier_block *nb, unsigned int list)
+{
+	int ret = 0;
+
+	switch (list) {
+	case CPUFREQ_COOLING_TYPE:
+	case CPUHOTPLUG_COOLING_TYPE:
+		ret = blocking_notifier_chain_register(
+				&cputherm_state_notifier_list, nb);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	return ret;
+}
+EXPORT_SYMBOL(cputherm_register_notifier);
+
+int cputherm_unregister_notifier(struct notifier_block *nb, unsigned int list)
+{
+	int ret = 0;
+
+	switch (list) {
+	case CPUFREQ_COOLING_TYPE:
+	case CPUHOTPLUG_COOLING_TYPE:
+		ret = blocking_notifier_chain_unregister(
+				&cputherm_state_notifier_list, nb);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	return ret;
+}
+EXPORT_SYMBOL(cputherm_unregister_notifier);
+
+/*Below codes defines functions to be used for cpufreq as cooling device*/
+static bool is_cpufreq_valid(int cpu)
+{
+	struct cpufreq_policy policy;
+	return !cpufreq_get_policy(&policy, cpu) ? true : false;
+}
+
+static int cpufreq_apply_cooling(struct cpufreq_cooling_device *cpufreq_device,
+				unsigned long cooling_state)
+{
+	unsigned int event, cpuid;
+	struct freq_clip_table *th_table;
+
+	if (cooling_state > cpufreq_device->tab_size)
+		return -EINVAL;
+
+	cpufreq_device->cpufreq_state = cooling_state;
+
+	/*cpufreq thermal notifier uses this cpufreq device pointer*/
+	notify_state = cooling_state;
+
+	if (notify_state > 0) {
+		th_table = &(cpufreq_device->tab_ptr[cooling_state - 1]);
+		memcpy(notify_table, th_table, sizeof(struct freq_clip_table));
+		event = CPUFREQ_COOLING_TYPE;
+		blocking_notifier_call_chain(&cputherm_state_notifier_list,
+						event, notify_table);
+	}
+
+	for_each_cpu(cpuid, cpufreq_device->allowed_cpus) {
+		if (is_cpufreq_valid(cpuid))
+			cpufreq_update_policy(cpuid);
+	}
+
+	notify_state = -1;
+
+	return 0;
+}
+
+static int cpufreq_thermal_notifier(struct notifier_block *nb,
+					unsigned long event, void *data)
+{
+	struct cpufreq_policy *policy = data;
+	unsigned long max_freq = 0;
+
+	if ((event != CPUFREQ_ADJUST) || (notify_state == -1))
+		return 0;
+
+	if (notify_state > 0) {
+		max_freq = notify_table->freq_clip_max;
+
+		if (per_cpu(max_policy_freq, policy->cpu) == 0)
+			per_cpu(max_policy_freq, policy->cpu) = policy->max;
+	} else {
+		if (per_cpu(max_policy_freq, policy->cpu) != 0) {
+			max_freq = per_cpu(max_policy_freq, policy->cpu);
+			per_cpu(max_policy_freq, policy->cpu) = 0;
+		} else {
+			max_freq = policy->max;
+		}
+	}
+
+	/* Never exceed user_policy.max*/
+	if (max_freq > policy->user_policy.max)
+		max_freq = policy->user_policy.max;
+
+	if (policy->max != max_freq)
+		cpufreq_verify_within_limits(policy, 0, max_freq);
+
+	return 0;
+}
+
+/*
+ * cpufreq cooling device callback functions
+ */
+static int cpufreq_get_max_state(struct thermal_cooling_device *cdev,
+				 unsigned long *state)
+{
+	int ret = -EINVAL;
+	struct cpufreq_cooling_device *cpufreq_device;
+
+	mutex_lock(&cooling_cpufreq_lock);
+	list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node) {
+		if (cpufreq_device && cpufreq_device->cool_dev == cdev) {
+			*state = cpufreq_device->tab_size;
+			ret = 0;
+			break;
+		}
+	}
+	mutex_unlock(&cooling_cpufreq_lock);
+	return ret;
+}
+
+static int cpufreq_get_cur_state(struct thermal_cooling_device *cdev,
+				 unsigned long *state)
+{
+	int ret = -EINVAL;
+	struct cpufreq_cooling_device *cpufreq_device;
+
+	mutex_lock(&cooling_cpufreq_lock);
+	list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node) {
+		if (cpufreq_device && cpufreq_device->cool_dev == cdev) {
+			*state = cpufreq_device->cpufreq_state;
+			ret = 0;
+			break;
+		}
+	}
+	mutex_unlock(&cooling_cpufreq_lock);
+	return ret;
+}
+
+/*This cooling may be as PASSIVE/ACTIVE type*/
+static int cpufreq_set_cur_state(struct thermal_cooling_device *cdev,
+				 unsigned long state)
+{
+	int ret = -EINVAL;
+	struct cpufreq_cooling_device *cpufreq_device;
+
+	mutex_lock(&cooling_cpufreq_lock);
+	list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node) {
+		if (cpufreq_device && cpufreq_device->cool_dev == cdev) {
+			ret = 0;
+			break;
+		}
+	}
+	mutex_unlock(&cooling_cpufreq_lock);
+
+	if (!ret)
+		ret = cpufreq_apply_cooling(cpufreq_device, state);
+
+	return ret;
+}
+
+/* bind cpufreq callbacks to cpufreq cooling device */
+static struct thermal_cooling_device_ops cpufreq_cooling_ops = {
+	.get_max_state = cpufreq_get_max_state,
+	.get_cur_state = cpufreq_get_cur_state,
+	.set_cur_state = cpufreq_set_cur_state,
+};
+
+static struct notifier_block thermal_cpufreq_notifier_block = {
+	.notifier_call = cpufreq_thermal_notifier,
+};
+
+struct thermal_cooling_device *cpufreq_cooling_register(
+	struct freq_clip_table *tab_ptr, unsigned int tab_size,
+	const struct cpumask *mask_val)
+{
+	struct thermal_cooling_device *cool_dev;
+	struct cpufreq_cooling_device *cpufreq_dev = NULL;
+	unsigned int cpufreq_dev_count = 0;
+	char dev_name[THERMAL_NAME_LENGTH];
+	int ret = 0, id = 0, i;
+
+	if (tab_ptr == NULL || tab_size == 0)
+		return ERR_PTR(-EINVAL);
+
+	list_for_each_entry(cpufreq_dev, &cooling_cpufreq_list, node)
+		cpufreq_dev_count++;
+
+	cpufreq_dev =
+		kzalloc(sizeof(struct cpufreq_cooling_device), GFP_KERNEL);
+
+	if (!cpufreq_dev)
+		return ERR_PTR(-ENOMEM);
+
+	if (cpufreq_dev_count == 0) {
+		notify_table = kzalloc(sizeof(struct freq_clip_table),
+					GFP_KERNEL);
+		if (!notify_table) {
+			kfree(cpufreq_dev);
+			return ERR_PTR(-ENOMEM);
+		}
+	}
+
+	cpufreq_dev->tab_ptr = tab_ptr;
+	cpufreq_dev->tab_size = tab_size;
+	cpufreq_dev->allowed_cpus = mask_val;
+
+	/* Initialize all the tab_ptr->mask_val to the passed mask_val */
+	for (i = 0; i < tab_size; i++)
+		((struct freq_clip_table *)&tab_ptr[i])->mask_val = mask_val;
+
+	ret = get_idr(&cpufreq_idr, &cooling_cpufreq_lock, &cpufreq_dev->id);
+	if (ret) {
+		kfree(cpufreq_dev);
+		return ERR_PTR(-EINVAL);
+	}
+
+	sprintf(dev_name, "thermal-cpufreq-%d", cpufreq_dev->id);
+
+	cool_dev = thermal_cooling_device_register(dev_name, cpufreq_dev,
+						&cpufreq_cooling_ops);
+	if (!cool_dev) {
+		release_idr(&cpufreq_idr, &cooling_cpufreq_lock,
+						cpufreq_dev->id);
+		kfree(cpufreq_dev);
+		return ERR_PTR(-EINVAL);
+	}
+	cpufreq_dev->id = id;
+	cpufreq_dev->cool_dev = cool_dev;
+	mutex_lock(&cooling_cpufreq_lock);
+	list_add_tail(&cpufreq_dev->node, &cooling_cpufreq_list);
+	mutex_unlock(&cooling_cpufreq_lock);
+
+	/*Register the notifier for first cpufreq cooling device*/
+	if (cpufreq_dev_count == 0)
+		cpufreq_register_notifier(&thermal_cpufreq_notifier_block,
+						CPUFREQ_POLICY_NOTIFIER);
+	return cool_dev;
+}
+EXPORT_SYMBOL(cpufreq_cooling_register);
+
+void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
+{
+	struct cpufreq_cooling_device *cpufreq_dev = NULL;
+	unsigned int cpufreq_dev_count = 0;
+
+	mutex_lock(&cooling_cpufreq_lock);
+	list_for_each_entry(cpufreq_dev, &cooling_cpufreq_list, node) {
+		if (cpufreq_dev && cpufreq_dev->cool_dev == cdev)
+			break;
+		cpufreq_dev_count++;
+	}
+
+	if (!cpufreq_dev || cpufreq_dev->cool_dev != cdev) {
+		mutex_unlock(&cooling_cpufreq_lock);
+		return;
+	}
+
+	list_del(&cpufreq_dev->node);
+	mutex_unlock(&cooling_cpufreq_lock);
+
+	/*Unregister the notifier for the last cpufreq cooling device*/
+	if (cpufreq_dev_count == 1) {
+		cpufreq_unregister_notifier(&thermal_cpufreq_notifier_block,
+					CPUFREQ_POLICY_NOTIFIER);
+		kfree(notify_table);
+	}
+
+	thermal_cooling_device_unregister(cpufreq_dev->cool_dev);
+	release_idr(&cpufreq_idr, &cooling_cpufreq_lock, cpufreq_dev->id);
+	kfree(cpufreq_dev);
+}
+EXPORT_SYMBOL(cpufreq_cooling_unregister);
diff --git a/include/linux/cpu_cooling.h b/include/linux/cpu_cooling.h
new file mode 100644
index 0000000..03fcc1e
--- /dev/null
+++ b/include/linux/cpu_cooling.h
@@ -0,0 +1,62 @@
+/*
+ *  linux/include/linux/cpu_cooling.h
+ *
+ *  Copyright (C) 2011	Samsung Electronics Co., Ltd(http://www.samsung.com)
+ *  Copyright (C) 2011  Amit Daniel <amit.kachhap@linaro.org>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
+ */
+
+#ifndef __CPU_COOLING_H__
+#define __CPU_COOLING_H__
+
+#include <linux/thermal.h>
+
+#define CPUFREQ_COOLING_TYPE		0
+#define CPUHOTPLUG_COOLING_TYPE		1
+
+struct freq_clip_table {
+	unsigned int freq_clip_max;
+	unsigned int polling_interval;
+	unsigned int temp_level;
+	const struct cpumask *mask_val;
+};
+
+int cputherm_register_notifier(struct notifier_block *nb, unsigned int list);
+int cputherm_unregister_notifier(struct notifier_block *nb, unsigned int list);
+
+#ifdef CONFIG_CPU_FREQ
+struct thermal_cooling_device *cpufreq_cooling_register(
+	struct freq_clip_table *tab_ptr, unsigned int tab_size,
+	const struct cpumask *mask_val);
+
+void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev);
+#else /*!CONFIG_CPU_FREQ*/
+static inline struct thermal_cooling_device *cpufreq_cooling_register(
+	struct freq_clip_table *tab_ptr, unsigned int tab_size,
+	const struct cpumask *mask_val)
+{
+	return NULL;
+}
+static inline void cpufreq_cooling_unregister(
+				struct thermal_cooling_device *cdev)
+{
+	return;
+}
+#endif	/*CONFIG_CPU_FREQ*/
+
+#endif /* __CPU_COOLING_H__ */
-- 
1.7.1

