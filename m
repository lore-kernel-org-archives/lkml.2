Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779Ab2CSGSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:18:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39826 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756607Ab2CSGSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 02:18:18 -0400
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: linux-pm@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        linaro-dev@lists.linaro.org, lm-sensors@lm-sensors.org,
        amit.kachhap@linaro.org, patches@linaro.org, eduardo.valentin@ti.com,
        durgadoss.r@intel.com
Subject: [PATCH V2 3/6] thermal: Add generic cpuhotplug cooling implementation
Date: Mon, 19 Mar 2012 11:47:41 +0530
Message-Id: <1332137864-12943-4-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1332137864-12943-1-git-send-email-amit.kachhap@linaro.org>
References: <1332137864-12943-1-git-send-email-amit.kachhap@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for generic cpu thermal cooling low level
implementations using cpuhotplug based on the thermal level requested
from user. Different cpu related cooling devices can be registered by the
user and the binding of these cooling devices to the corresponding
trip points can be easily done as the registration APIs return the
cooling device pointer. The user of these APIs are responsible for
passing the cpumask.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
---
 Documentation/thermal/cpu-cooling-api.txt |   16 +++
 drivers/thermal/Kconfig                   |    2 +-
 drivers/thermal/cpu_cooling.c             |  170 +++++++++++++++++++++++++++++
 include/linux/cpu_cooling.h               |   17 +++
 4 files changed, 204 insertions(+), 1 deletions(-)

diff --git a/Documentation/thermal/cpu-cooling-api.txt b/Documentation/thermal/cpu-cooling-api.txt
index 3720341..6eb648e 100644
--- a/Documentation/thermal/cpu-cooling-api.txt
+++ b/Documentation/thermal/cpu-cooling-api.txt
@@ -38,6 +38,22 @@ the cooling device pointer.
 
     cdev: Cooling device pointer which has to be unregistered.
 
+1.2 cpuhotplug registration APIs
+1.2.1 struct thermal_cooling_device *cpuhotplug_cooling_register(
+	const struct cpumask *mask_val)
+
+    This interface function registers the cpuhotplug cooling device with the name
+    "cpu-hotplug-%x". This api can support multiple instances of cpuhotplug
+    cooling devices.
+
+    mask_val: all the allowed cpu's which can be hotplugged out.
+
+1.1.2 void cpuhotplug_cooling_unregister(struct thermal_cooling_device *cdev)
+
+    This interface function unregisters the "thermal-cpuhotplug-%x" cooling
+    device.
+
+    cdev: Cooling device pointer which has to be unregistered.
 
 2. CPU cooling action notifier interface
 
diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index df738f2..24c43e3 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -21,7 +21,7 @@ config THERMAL_HWMON
 
 config CPU_THERMAL
 	bool "generic cpu cooling support"
-	depends on THERMAL && CPU_FREQ
+	depends on THERMAL && CPU_FREQ && HOTPLUG_CPU
 	help
 	  This implements the generic cpu cooling mechanism through frequency
 	  reduction, cpu hotplug and any other ways of reducing temperature. An
diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index ee2c96d..1f3aa79 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -46,6 +46,19 @@ static DEFINE_IDR(cpufreq_idr);
 static DEFINE_PER_CPU(unsigned int, max_policy_freq);
 static struct freq_clip_table *notify_table;
 static int notify_state;
+
+struct hotplug_cooling_device {
+	int id;
+	struct thermal_cooling_device *cool_dev;
+	unsigned int hotplug_state;
+	const struct cpumask *allowed_cpus;
+	struct list_head node;
+};
+
+static LIST_HEAD(cooling_cpuhotplug_list);
+static DEFINE_MUTEX(cooling_cpuhotplug_lock);
+static DEFINE_IDR(cpuhotplug_idr);
+
 static BLOCKING_NOTIFIER_HEAD(cputherm_state_notifier_list);
 
 static int get_idr(struct idr *idr, struct mutex *lock, int *id)
@@ -357,3 +370,160 @@ void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
 	kfree(cpufreq_dev);
 }
 EXPORT_SYMBOL(cpufreq_cooling_unregister);
+
+/*
+ * cpu hotplug cooling device callback functions
+ */
+static int cpuhotplug_get_max_state(struct thermal_cooling_device *cdev,
+				 unsigned long *state)
+{
+	int ret = -EINVAL;
+	struct hotplug_cooling_device *hotplug_dev;
+
+	/*
+	* This cooling device may be of type ACTIVE, so state field can
+	* be 0 or 1
+	*/
+	mutex_lock(&cooling_cpuhotplug_lock);
+	list_for_each_entry(hotplug_dev, &cooling_cpuhotplug_list, node) {
+		if (hotplug_dev && hotplug_dev->cool_dev == cdev) {
+			*state = 1;
+			ret = 0;
+			break;
+		}
+	}
+	mutex_unlock(&cooling_cpuhotplug_lock);
+	return ret;
+}
+
+static int cpuhotplug_get_cur_state(struct thermal_cooling_device *cdev,
+				 unsigned long *state)
+{
+	int ret = -EINVAL;
+	struct hotplug_cooling_device *hotplug_dev;
+
+	mutex_lock(&cooling_cpuhotplug_lock);
+	list_for_each_entry(hotplug_dev, &cooling_cpuhotplug_list, node) {
+		if (hotplug_dev && hotplug_dev->cool_dev == cdev) {
+			*state = hotplug_dev->hotplug_state;
+			ret = 0;
+			break;
+		}
+	}
+	mutex_unlock(&cooling_cpuhotplug_lock);
+	return ret;
+}
+
+/*This cooling may be as ACTIVE type*/
+static int cpuhotplug_set_cur_state(struct thermal_cooling_device *cdev,
+				 unsigned long state)
+{
+	int cpuid, this_cpu = smp_processor_id();
+	struct hotplug_cooling_device *hotplug_dev;
+
+	mutex_lock(&cooling_cpuhotplug_lock);
+	list_for_each_entry(hotplug_dev, &cooling_cpuhotplug_list, node)
+		if (hotplug_dev && hotplug_dev->cool_dev == cdev)
+			break;
+
+	mutex_unlock(&cooling_cpuhotplug_lock);
+	if (!hotplug_dev || hotplug_dev->cool_dev != cdev)
+		return -EINVAL;
+
+	if (hotplug_dev->hotplug_state == state)
+		return 0;
+
+	/*
+	* This cooling device may be of type ACTIVE, so state field can
+	* be 0 or 1
+	*/
+	if (state == 1) {
+		for_each_cpu(cpuid, hotplug_dev->allowed_cpus) {
+			if (cpu_online(cpuid) && (cpuid != this_cpu))
+				cpu_down(cpuid);
+		}
+	} else if (state == 0) {
+		for_each_cpu(cpuid, hotplug_dev->allowed_cpus) {
+			if (!cpu_online(cpuid) && (cpuid != this_cpu))
+				cpu_up(cpuid);
+		}
+	} else {
+		return -EINVAL;
+	}
+
+	hotplug_dev->hotplug_state = state;
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
+	struct hotplug_cooling_device *hotplug_dev;
+	int ret = 0;
+	char dev_name[THERMAL_NAME_LENGTH];
+
+	hotplug_dev =
+		kzalloc(sizeof(struct hotplug_cooling_device), GFP_KERNEL);
+
+	if (!hotplug_dev)
+		return ERR_PTR(-ENOMEM);
+
+	ret = get_idr(&cpuhotplug_idr, &cooling_cpuhotplug_lock,
+			&hotplug_dev->id);
+	if (ret) {
+		kfree(hotplug_dev);
+		return ERR_PTR(-EINVAL);
+	}
+
+	sprintf(dev_name, "cpu-hotplug-%u", hotplug_dev->id);
+
+	hotplug_dev->hotplug_state = 0;
+	hotplug_dev->allowed_cpus = mask_val;
+	cool_dev = thermal_cooling_device_register(dev_name, hotplug_dev,
+						&cpuhotplug_cooling_ops);
+	if (!cool_dev) {
+		release_idr(&cpuhotplug_idr, &cooling_cpuhotplug_lock,
+				hotplug_dev->id);
+		kfree(hotplug_dev);
+		return ERR_PTR(-EINVAL);
+	}
+
+	hotplug_dev->cool_dev = cool_dev;
+	mutex_lock(&cooling_cpuhotplug_lock);
+	list_add_tail(&hotplug_dev->node, &cooling_cpuhotplug_list);
+	mutex_unlock(&cooling_cpuhotplug_lock);
+
+	return cool_dev;
+}
+EXPORT_SYMBOL(cpuhotplug_cooling_register);
+
+void cpuhotplug_cooling_unregister(struct thermal_cooling_device *cdev)
+{
+	struct hotplug_cooling_device *hotplug_dev = NULL;
+
+	mutex_lock(&cooling_cpuhotplug_lock);
+	list_for_each_entry(hotplug_dev, &cooling_cpuhotplug_list, node)
+		if (hotplug_dev && hotplug_dev->cool_dev == cdev)
+			break;
+
+	if (!hotplug_dev || hotplug_dev->cool_dev != cdev) {
+		mutex_unlock(&cooling_cpuhotplug_lock);
+		return;
+	}
+
+	list_del(&hotplug_dev->node);
+	mutex_unlock(&cooling_cpuhotplug_lock);
+	thermal_cooling_device_unregister(hotplug_dev->cool_dev);
+	release_idr(&cpuhotplug_idr, &cooling_cpuhotplug_lock,
+						hotplug_dev->id);
+	kfree(hotplug_dev);
+}
+EXPORT_SYMBOL(cpuhotplug_cooling_unregister);
diff --git a/include/linux/cpu_cooling.h b/include/linux/cpu_cooling.h
index 12efa01..5a3698c 100644
--- a/include/linux/cpu_cooling.h
+++ b/include/linux/cpu_cooling.h
@@ -57,5 +57,22 @@ static inline void cpufreq_cooling_unregister(
 	return;
 }
 #endif	/*CONFIG_CPU_FREQ*/
+#ifdef CONFIG_HOTPLUG_CPU
+extern struct thermal_cooling_device *cpuhotplug_cooling_register(
+	const struct cpumask *mask_val);
+
+extern void cpuhotplug_cooling_unregister(struct thermal_cooling_device *cdev);
+#else /*!CONFIG_HOTPLUG_CPU*/
+static inline struct thermal_cooling_device *cpuhotplug_cooling_register(
+	const struct cpumask *mask_val)
+{
+	return NULL;
+}
+static inline void cpuhotplug_cooling_unregister(
+				struct thermal_cooling_device *cdev)
+{
+	return;
+}
+#endif /*CONFIG_HOTPLUG_CPU*/
 
 #endif /* __CPU_COOLING_H__ */
-- 
1.7.1

