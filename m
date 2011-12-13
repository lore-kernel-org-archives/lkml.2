Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab1LMPNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 10:13:48 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47037 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab1LMPNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 10:13:44 -0500
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org, rui.zhang@intel.com,
        linaro-dev@lists.linaro.org, amit.kachhap@linaro.org,
        patches@linaro.org
Subject: [RFC PATCH 2/2] thermal: Add generic cpu cooling implementation
Date: Tue, 13 Dec 2011 20:43:16 +0530
Message-Id: <1323789196-4942-3-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1323789196-4942-1-git-send-email-amit.kachhap@linaro.org>
References: <1323789196-4942-1-git-send-email-amit.kachhap@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for generic cpu thermal cooling low level
implementations using frequency scaling and cpuhotplugg currently.
Different cpu related cooling devices can be registered by the
user and the binding of these cooling devices to the corresponding
trip points can be easily done as the registration API's return the
cooling device pointer.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
---
 Documentation/thermal/cpu-cooling-api.txt |   52 +++++
 drivers/thermal/Kconfig                   |   11 +
 drivers/thermal/Makefile                  |    1 +
 drivers/thermal/cpu_cooling.c             |  302 +++++++++++++++++++++++++++++
 include/linux/cpu_cooling.h               |   45 +++++
 5 files changed, 411 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/thermal/cpu-cooling-api.txt
 create mode 100644 drivers/thermal/cpu_cooling.c
 create mode 100644 include/linux/cpu_cooling.h

diff --git a/Documentation/thermal/cpu-cooling-api.txt b/Documentation/thermal/cpu-cooling-api.txt
new file mode 100644
index 0000000..d30b4f2
--- /dev/null
+++ b/Documentation/thermal/cpu-cooling-api.txt
@@ -0,0 +1,52 @@
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
+devices to the trip types is left for the user. The registration api's returns
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
+	"thermal-cpufreq".
+
+    tab_ptr: The table containing the percentage of frequency to be clipped for
+    each cooling state.
+	.freq_clip_pctg[NR_CPUS]:Percentage of frequency to be clipped for each
+	 cpu.
+	.polling_interval: polling interval for this cooling state.
+    tab_size: the total number of cooling state.
+    mask_val: all the allowed cpu's where frequency clipping can happen.
+
+1.1.2 void cpufreq_cooling_unregister(void)
+
+    This interface function unregisters the "thermal-cpufreq" cooling device.
+
+
+1.2 cpuhotplug registration api's
+
+1.2.1 struct thermal_cooling_device *cpuhotplug_cooling_register(
+	const struct cpumask *mask_val)
+
+    This interface function registers the cpuhotplug cooling device with the name
+	"thermal-cpuhotplug".
+
+    mask_val: all the allowed cpu's which can be hotplugged out.
+
+1.1.2 void cpuhotplug_cooling_unregister(void)
+
+    This interface function unregisters the "thermal-cpuhotplug" cooling device.
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
index 0000000..cdd148c
--- /dev/null
+++ b/drivers/thermal/cpu_cooling.c
@@ -0,0 +1,302 @@
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
+	struct thermal_cooling_device *cool_dev;
+	struct freq_pctg_table *tab_ptr;
+	unsigned int tab_size;
+	unsigned int cpufreq_state;
+	const struct cpumask *allowed_cpus;
+};
+
+static struct cpufreq_cooling_device *cpufreq_device;
+
+/*Below codes defines functions to be used for cpufreq as cooling device*/
+static bool is_cpufreq_valid(int cpu)
+{
+	struct cpufreq_policy policy;
+	if (!cpufreq_get_policy(&policy, cpu))
+		return true;
+	return false;
+}
+
+static int cpufreq_apply_cooling(int cooling_state)
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
+	unsigned int cpu = policy->cpu, th_pctg = 0, level;
+
+	if (event != CPUFREQ_ADJUST)
+		return 0;
+
+	level = cpufreq_device->cpufreq_state;
+
+	if (level > 0) {
+		th_table =
+			&(cpufreq_device->tab_ptr[level - 1]);
+		th_pctg = th_table->freq_clip_pctg[cpu];
+	}
+
+	max_freq =
+		(policy->cpuinfo.max_freq * (100 - th_pctg)) / 100;
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
+	*state = cpufreq_device->tab_size;
+	return 0;
+}
+
+static int cpufreq_get_cur_state(struct thermal_cooling_device *cdev,
+				 unsigned long *state)
+{
+	*state = cpufreq_device->cpufreq_state;
+	return 0;
+}
+
+/*This cooling may be as PASSIVE/STATE_ACTIVE type*/
+static int cpufreq_set_cur_state(struct thermal_cooling_device *cdev,
+				 unsigned long state)
+{
+	cpufreq_apply_cooling(state);
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
+
+	if (tab_ptr == NULL || tab_size == 0)
+		return ERR_PTR(-EINVAL);
+
+	cpufreq_device =
+		kzalloc(sizeof(struct cpufreq_cooling_device), GFP_KERNEL);
+
+	if (!cpufreq_device)
+		return ERR_PTR(-ENOMEM);
+
+	cool_dev = thermal_cooling_device_register("thermal-cpufreq", NULL,
+						&cpufreq_cooling_ops);
+	if (!cool_dev) {
+		kfree(cpufreq_device);
+		return ERR_PTR(-EINVAL);
+	}
+
+	cpufreq_device->tab_ptr = tab_ptr;
+	cpufreq_device->tab_size = tab_size;
+	cpufreq_device->cool_dev = cool_dev;
+	cpufreq_device->allowed_cpus = mask_val;
+
+	cpufreq_register_notifier(&thermal_cpufreq_notifier_block,
+						CPUFREQ_POLICY_NOTIFIER);
+	return cool_dev;
+}
+EXPORT_SYMBOL(cpufreq_cooling_register);
+
+void cpufreq_cooling_unregister(void)
+{
+	cpufreq_unregister_notifier(&thermal_cpufreq_notifier_block,
+						CPUFREQ_POLICY_NOTIFIER);
+	thermal_cooling_device_unregister(cpufreq_device->cool_dev);
+	kfree(cpufreq_device);
+}
+EXPORT_SYMBOL(cpufreq_cooling_unregister);
+#else /*!CONFIG_CPU_FREQ*/
+struct thermal_cooling_device *cpufreq_cooling_register(
+	struct freq_pctg_table *tab_ptr, unsigned int tab_size)
+{
+	return NULL;
+}
+EXPORT_SYMBOL(cpufreq_cooling_register);
+void cpufreq_cooling_unregister(void)
+{
+	return;
+}
+EXPORT_SYMBOL(cpufreq_cooling_unregister);
+#endif /*CONFIG_CPU_FREQ*/
+
+#ifdef CONFIG_HOTPLUG_CPU
+
+struct hotplug_cooling_device {
+	struct thermal_cooling_device *cool_dev;
+	unsigned int hotplug_state;
+	const struct cpumask *allowed_cpus;
+};
+static struct hotplug_cooling_device *hotplug_device;
+
+/*
+ * cpu hotplug cooling device callback functions
+ */
+static int cpuhotplug_get_max_state(struct thermal_cooling_device *cdev,
+				 unsigned long *state)
+{
+	*state = 1;
+	return 0;
+}
+
+static int cpuhotplug_get_cur_state(struct thermal_cooling_device *cdev,
+				 unsigned long *state)
+{
+	/*This cooling device may be of type ACTIVE, so state field
+	can be 0 or 1*/
+	*state = hotplug_device->hotplug_state;
+	return 0;
+}
+
+/*This cooling may be as PASSIVE/STATE_ACTIVE type*/
+static int cpuhotplug_set_cur_state(struct thermal_cooling_device *cdev,
+				 unsigned long state)
+{
+	int cpuid, this_cpu = smp_processor_id();
+
+	if (hotplug_device->hotplug_state == state)
+		return 0;
+
+	/*This cooling device may be of type ACTIVE, so state field
+	can be 0 or 1*/
+	if (state == 1) {
+		for_each_cpu(cpuid, hotplug_device->allowed_cpus) {
+			if (cpu_online(cpuid) && (cpuid != this_cpu))
+				cpu_down(cpuid);
+		}
+	} else if (state == 0) {
+		for_each_cpu(cpuid, hotplug_device->allowed_cpus) {
+			if (!cpu_online(cpuid) && (cpuid != this_cpu))
+				cpu_up(cpuid);
+		}
+	} else
+		return -EINVAL;
+
+	hotplug_device->hotplug_state = state;
+
+	return 0;
+}
+/* bind hotplug callbacks to cpu hotplug cooling device */
+static struct thermal_cooling_device_ops cpuhotplug_cooling_ops = {
+	.get_max_state = cpuhotplug_get_max_state,
+	.get_cur_state = cpuhotplug_get_cur_state,
+	.set_cur_state = cpuhotplug_set_cur_state,
+};
+
+struct thermal_cooling_device *cpuhotplug_cooling_register(
+	const struct cpumask *mask_val)
+{
+	struct thermal_cooling_device *cool_dev;
+
+	hotplug_device =
+		kzalloc(sizeof(struct hotplug_cooling_device), GFP_KERNEL);
+
+	if (!hotplug_device)
+		return ERR_PTR(-ENOMEM);
+
+	cool_dev = thermal_cooling_device_register("thermal-cpuhotplug", NULL,
+						&cpuhotplug_cooling_ops);
+	if (!cool_dev) {
+		kfree(hotplug_device);
+		return ERR_PTR(-EINVAL);
+	}
+
+	hotplug_device->cool_dev = cool_dev;
+	hotplug_device->hotplug_state = 0;
+	hotplug_device->allowed_cpus = mask_val;
+
+	return cool_dev;
+}
+EXPORT_SYMBOL(cpuhotplug_cooling_register);
+
+void cpuhotplug_cooling_unregister(void)
+{
+	thermal_cooling_device_unregister(hotplug_device->cool_dev);
+	kfree(hotplug_device);
+}
+EXPORT_SYMBOL(cpuhotplug_cooling_unregister);
+#else /*!CONFIG_HOTPLUG_CPU*/
+struct thermal_cooling_device *cpuhotplug_cooling_register(
+	const struct cpumask *mask_val)
+{
+	return NULL;
+}
+EXPORT_SYMBOL(cpuhotplug_cooling_register);
+void cpuhotplug_cooling_unregister(void)
+{
+	return;
+}
+EXPORT_SYMBOL(cpuhotplug_cooling_unregister);
+#endif /*CONFIG_HOTPLUG_CPU*/
diff --git a/include/linux/cpu_cooling.h b/include/linux/cpu_cooling.h
new file mode 100644
index 0000000..0c57375
--- /dev/null
+++ b/include/linux/cpu_cooling.h
@@ -0,0 +1,45 @@
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
+	unsigned int freq_clip_pctg[NR_CPUS];
+	unsigned int polling_interval;
+};
+
+extern struct thermal_cooling_device *cpufreq_cooling_register(
+	struct freq_pctg_table *tab_ptr, unsigned int tab_size,
+	const struct cpumask *mask_val);
+
+extern void cpufreq_cooling_unregister(void);
+
+extern struct thermal_cooling_device *cpuhotplug_cooling_register(
+	const struct cpumask *mask_val);
+
+extern void cpuhotplug_cooling_unregister(void);
+
+#endif /* __CPU_COOLING_H__ */
-- 
1.7.1

