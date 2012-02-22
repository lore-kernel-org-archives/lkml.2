Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab2BVKWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 05:22:22 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61532 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab2BVKWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 05:22:19 -0500
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        linaro-dev@lists.linaro.org, amit.kachhap@linaro.org,
        durgadoss.r@intel.com, rob.lee@linaro.org, patches@linaro.org
Subject: [PATCH 2/4] thermal: Add generic cpufreq cooling implementation
Date: Wed, 22 Feb 2012 15:44:08 +0530
Message-Id: <1329905650-30161-3-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1329905650-30161-1-git-send-email-amit.kachhap@linaro.org>
References: <1329905650-30161-1-git-send-email-amit.kachhap@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for generic cpu thermal cooling low level
implementations using frequency scaling up/down based on the request
from user. Different cpu related cooling devices can be registered by the
user and the binding of these cooling devices to the corresponding
trip points can be easily done as the registration API's return the
cooling device pointer. The user of these api's are responsible for
passing clipping frequency in percentages.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
---
 Documentation/thermal/cpu-cooling-api.txt |   40 ++++
 drivers/thermal/Kconfig                   |   11 +
 drivers/thermal/Makefile                  |    1 +
 drivers/thermal/cpu_cooling.c             |  310 +++++++++++++++++++++++++++++
 include/linux/cpu_cooling.h               |   54 +++++
 5 files changed, 416 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/thermal/cpu-cooling-api.txt
 create mode 100644 drivers/thermal/cpu_cooling.c
 create mode 100644 include/linux/cpu_cooling.h

diff --git a/Documentation/thermal/cpu-cooling-api.txt b/Documentation/thermal/cpu-cooling-api.txt
new file mode 100644
index 0000000..04de67c
--- /dev/null
+++ b/Documentation/thermal/cpu-cooling-api.txt
@@ -0,0 +1,40 @@
+CPU cooling api's How To
+===================================
+
+Written by Amit Daniel Kachhap <amit.kachhap@linaro.org>
+
+Updated: 13 Dec 2011
+
+Copyright (c)  2011 Samsung Electronics Co., Ltd(http://www.samsung.com)
+
+0. Introduction
+
+The generic cpu cooling(freq clipping, cpuhotplug) provides
+registration/unregistration api's to the user. The binding of the cooling
+devices to the trip point is left for the user. The registration api's returns
+the cooling device pointer.
+
+1. cpufreq cooling api's
+
+1.1 cpufreq registration api's
+1.1.1 struct thermal_cooling_device *cpufreq_cooling_register(
+	struct freq_pctg_table *tab_ptr, unsigned int tab_size,
+	const struct cpumask *mask_val)
+
+    This interface function registers the cpufreq cooling device with the name
+    "thermal-cpufreq-%x". This api can support multiple instance of cpufreq cooling
+    devices.
+
+    tab_ptr: The table containing the percentage of frequency to be clipped for
+    each cooling state.
+	.freq_clip_pctg: Percentage of frequency to be clipped for each allowed
+	 cpus.
+	.polling_interval: polling interval for this cooling state.
+    tab_size: the total number of cooling state.
+    mask_val: all the allowed cpu's where frequency clipping can happen.
+
+1.1.2 void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
+
+    This interface function unregisters the "thermal-cpufreq-%x" cooling device.
+
+    cdev: Cooling device pointer which has to be unregistered.
diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index f7f71b2..298c1cd 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -18,3 +18,14 @@ config THERMAL_HWMON
 	depends on THERMAL
 	depends on HWMON=y || HWMON=THERMAL
 	default y
+
+config CPU_THERMAL
+	bool "generic cpu cooling support"
+	depends on THERMAL
+	help
+	  This implements the generic cpu cooling mechanism through frequency
+	  reduction, cpu hotplug and any other ways of reducing temperature. An
+	  ACPI version of this already exists(drivers/acpi/processor_thermal.c).
+	  This will be useful for platforms using the generic thermal interface
+	  and not the ACPI interface.
+	  If you want this support, you should say Y or M here.
diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
index 31108a0..655cbc4 100644
--- a/drivers/thermal/Makefile
+++ b/drivers/thermal/Makefile
@@ -3,3 +3,4 @@
 #
 
 obj-$(CONFIG_THERMAL)		+= thermal_sys.o
+obj-$(CONFIG_CPU_THERMAL)	+= cpu_cooling.o
diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
new file mode 100644
index 0000000..298f550
--- /dev/null
+++ b/drivers/thermal/cpu_cooling.c
@@ -0,0 +1,310 @@
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
+#ifdef CONFIG_CPU_FREQ
+struct cpufreq_cooling_device {
+	int id;
+	struct thermal_cooling_device *cool_dev;
+	struct freq_pctg_table *tab_ptr;
+	unsigned int tab_size;
+	unsigned int cpufreq_state;
+	const struct cpumask *allowed_cpus;
+	struct list_head node;
+};
+
+static LIST_HEAD(cooling_cpufreq_list);
+static DEFINE_MUTEX(cooling_cpufreq_lock);
+static DEFINE_IDR(cpufreq_idr);
+static struct cpufreq_cooling_device *notify_cpufreq;
+static DEFINE_PER_CPU(unsigned int, max_policy_freq);
+#endif /*CONFIG_CPU_FREQ*/
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
+#ifdef CONFIG_CPU_FREQ
+/*Below codes defines functions to be used for cpufreq as cooling device*/
+static bool is_cpufreq_valid(int cpu)
+{
+	struct cpufreq_policy policy;
+	if (!cpufreq_get_policy(&policy, cpu))
+		return true;
+	return false;
+}
+
+static int cpufreq_apply_cooling(struct cpufreq_cooling_device *cpufreq_device,
+				unsigned long cooling_state)
+{
+	int cpuid, this_cpu = smp_processor_id();
+
+	if (!is_cpufreq_valid(this_cpu))
+		return 0;
+
+	if (cooling_state > cpufreq_device->tab_size)
+		return -EINVAL;
+
+	/*Check if last cooling level is same as current cooling level*/
+	if (cpufreq_device->cpufreq_state == cooling_state)
+		return 0;
+
+	cpufreq_device->cpufreq_state = cooling_state;
+
+	/*cpufreq thermal notifier uses this cpufreq device pointer*/
+	notify_cpufreq = cpufreq_device;
+
+	for_each_cpu(cpuid, cpufreq_device->allowed_cpus) {
+		if (is_cpufreq_valid(cpuid))
+			cpufreq_update_policy(cpuid);
+	}
+
+	return 0;
+}
+
+static int thermal_cpufreq_notifier(struct notifier_block *nb,
+					unsigned long event, void *data)
+{
+	struct cpufreq_policy *policy = data;
+	struct freq_pctg_table *th_table;
+	unsigned long max_freq = 0;
+	unsigned int th_pctg = 0, level;
+
+	if (event != CPUFREQ_ADJUST)
+		return 0;
+
+	if (!notify_cpufreq)
+		return 0;
+
+	level = notify_cpufreq->cpufreq_state;
+
+	if (level > 0) {
+		th_table =
+			&(notify_cpufreq->tab_ptr[level - 1]);
+		th_pctg = th_table->freq_clip_pctg;
+		max_freq =
+		(policy->cpuinfo.max_freq * (100 - th_pctg)) / 100;
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
+	cpufreq_verify_within_limits(policy, 0, max_freq);
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
+	struct cpufreq_cooling_device *cpufreq_device = NULL;
+
+	mutex_lock(&cooling_cpufreq_lock);
+	list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node)
+		if (cpufreq_device && cpufreq_device->cool_dev == cdev)
+			break;
+
+	mutex_unlock(&cooling_cpufreq_lock);
+	if (!cpufreq_device || cpufreq_device->cool_dev != cdev)
+		return -EINVAL;
+
+	*state = cpufreq_device->tab_size;
+	return 0;
+}
+
+static int cpufreq_get_cur_state(struct thermal_cooling_device *cdev,
+				 unsigned long *state)
+{
+	struct cpufreq_cooling_device *cpufreq_device = NULL;
+
+	mutex_lock(&cooling_cpufreq_lock);
+	list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node)
+		if (cpufreq_device && cpufreq_device->cool_dev == cdev)
+			break;
+
+	mutex_unlock(&cooling_cpufreq_lock);
+	if (!cpufreq_device || cpufreq_device->cool_dev != cdev)
+		return -EINVAL;
+	*state = cpufreq_device->cpufreq_state;
+	return 0;
+}
+
+/*This cooling may be as PASSIVE/ACTIVE type*/
+static int cpufreq_set_cur_state(struct thermal_cooling_device *cdev,
+				 unsigned long state)
+{
+	struct cpufreq_cooling_device *cpufreq_device = NULL;
+
+	mutex_lock(&cooling_cpufreq_lock);
+	list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node)
+		if (cpufreq_device && cpufreq_device->cool_dev == cdev)
+			break;
+
+	mutex_unlock(&cooling_cpufreq_lock);
+	if (!cpufreq_device || cpufreq_device->cool_dev != cdev)
+		return -EINVAL;
+
+	cpufreq_apply_cooling(cpufreq_device, state);
+	return 0;
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
+	.notifier_call = thermal_cpufreq_notifier,
+};
+
+struct thermal_cooling_device *cpufreq_cooling_register(
+	struct freq_pctg_table *tab_ptr, unsigned int tab_size,
+	const struct cpumask *mask_val)
+{
+	struct thermal_cooling_device *cool_dev;
+	struct cpufreq_cooling_device *cpufreq_dev = NULL;
+	unsigned int count = 0;
+	char dev_name[THERMAL_NAME_LENGTH];
+	int ret = 0, id = 0;
+
+	if (tab_ptr == NULL || tab_size == 0)
+		return ERR_PTR(-EINVAL);
+
+	list_for_each_entry(cpufreq_dev, &cooling_cpufreq_list, node)
+		count++;
+
+	cpufreq_dev =
+		kzalloc(sizeof(struct cpufreq_cooling_device), GFP_KERNEL);
+
+	if (!cpufreq_dev)
+		return ERR_PTR(-ENOMEM);
+
+	cpufreq_dev->tab_ptr = tab_ptr;
+	cpufreq_dev->tab_size = tab_size;
+	cpufreq_dev->allowed_cpus = mask_val;
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
+	if (count == 0)
+		cpufreq_register_notifier(&thermal_cpufreq_notifier_block,
+						CPUFREQ_POLICY_NOTIFIER);
+	return cool_dev;
+}
+EXPORT_SYMBOL(cpufreq_cooling_register);
+
+void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
+{
+	struct cpufreq_cooling_device *cpufreq_dev = NULL;
+	unsigned int count = 0;
+
+	mutex_lock(&cooling_cpufreq_lock);
+	list_for_each_entry(cpufreq_dev, &cooling_cpufreq_list, node) {
+		if (cpufreq_dev && cpufreq_dev->cool_dev == cdev)
+			break;
+		count++;
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
+	if (count == 1)
+		cpufreq_unregister_notifier(&thermal_cpufreq_notifier_block,
+					CPUFREQ_POLICY_NOTIFIER);
+
+	thermal_cooling_device_unregister(cpufreq_dev->cool_dev);
+	release_idr(&cpufreq_idr, &cooling_cpufreq_lock, cpufreq_dev->id);
+	kfree(cpufreq_dev);
+}
+EXPORT_SYMBOL(cpufreq_cooling_unregister);
+#endif /*CONFIG_CPU_FREQ*/
diff --git a/include/linux/cpu_cooling.h b/include/linux/cpu_cooling.h
new file mode 100644
index 0000000..5dc5632
--- /dev/null
+++ b/include/linux/cpu_cooling.h
@@ -0,0 +1,54 @@
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
+struct freq_pctg_table {
+	unsigned int freq_clip_pctg;
+	unsigned int polling_interval;
+};
+
+#ifdef CONFIG_CPU_FREQ
+struct thermal_cooling_device *cpufreq_cooling_register(
+	struct freq_pctg_table *tab_ptr, unsigned int tab_size,
+	const struct cpumask *mask_val);
+
+void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev);
+#else /*!CONFIG_CPU_FREQ*/
+static inline struct thermal_cooling_device *cpufreq_cooling_register(
+	struct freq_pctg_table *tab_ptr, unsigned int tab_size,
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

