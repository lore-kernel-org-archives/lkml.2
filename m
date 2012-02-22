Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab2BVKYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 05:24:14 -0500
Received: from mail-pw0-f48.google.com ([209.85.160.48]:35873 "EHLO
	mail-pw0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440Ab2BVKYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 05:24:12 -0500
X-Greylist: delayed 482 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Feb 2012 05:24:12 EST
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        linaro-dev@lists.linaro.org, amit.kachhap@linaro.org,
        durgadoss.r@intel.com, rob.lee@linaro.org, patches@linaro.org
Subject: [PATCH 3/4] thermal: Add generic cpuhotplug cooling implementation
Date: Wed, 22 Feb 2012 15:44:09 +0530
Message-Id: <1329905650-30161-4-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1329905650-30161-1-git-send-email-amit.kachhap@linaro.org>
References: <1329905650-30161-1-git-send-email-amit.kachhap@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for generic cpu thermal cooling low level
implementations using cpuhotplug based on the thermal level requested
from user. Different cpu related cooling devices can be registered by the
user and the binding of these cooling devices to the corresponding
trip points can be easily done as the registration API's return the
cooling device pointer. The user of these api's are responsible for
passing the cpumask.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
---
 Documentation/thermal/cpu-cooling-api.txt |   17 +++
 drivers/thermal/cpu_cooling.c             |  174 +++++++++++++++++++++++++++++
 include/linux/cpu_cooling.h               |   17 +++
 3 files changed, 208 insertions(+), 0 deletions(-)

diff --git a/Documentation/thermal/cpu-cooling-api.txt b/Documentation/thermal/cpu-cooling-api.txt
index 04de67c..bdaf509 100644
--- a/Documentation/thermal/cpu-cooling-api.txt
+++ b/Documentation/thermal/cpu-cooling-api.txt
@@ -38,3 +38,20 @@ the cooling device pointer.
     This interface function unregisters the "thermal-cpufreq-%x" cooling device.
 
     cdev: Cooling device pointer which has to be unregistered.
+
+1.2 cpuhotplug registration api's
+
+1.2.1 struct thermal_cooling_device *cpuhotplug_cooling_register(
+	const struct cpumask *mask_val)
+
+    This interface function registers the cpuhotplug cooling device with the name
+    "cpu-hotplug-%x". This api can support multiple instance of cpuhotplug cooling
+    devices.
+
+    mask_val: all the allowed cpu's which can be hotplugged out.
+
+1.1.2 void cpuhotplug_cooling_unregister(struct thermal_cooling_device *cdev)
+
+    This interface function unregisters the "thermal-cpuhotplug-%x" cooling device.
+
+    cdev: Cooling device pointer which has to be unregistered.
diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 298f550..3d2d87f 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -48,6 +48,21 @@ static struct cpufreq_cooling_device *notify_cpufreq;
 static DEFINE_PER_CPU(unsigned int, max_policy_freq);
 #endif /*CONFIG_CPU_FREQ*/
 
+#ifdef CONFIG_HOTPLUG_CPU
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
+#endif /*CONFIG_HOTPLUG_CPU*/
+
+
 static int get_idr(struct idr *idr, struct mutex *lock, int *id)
 {
 	int err;
@@ -308,3 +323,162 @@ void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
 }
 EXPORT_SYMBOL(cpufreq_cooling_unregister);
 #endif /*CONFIG_CPU_FREQ*/
+
+#ifdef CONFIG_HOTPLUG_CPU
+/*
+ * cpu hotplug cooling device callback functions
+ */
+static int cpuhotplug_get_max_state(struct thermal_cooling_device *cdev,
+				 unsigned long *state)
+{
+	struct hotplug_cooling_device *hotplug_dev = NULL;
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
+	*state = 1;
+	return 0;
+}
+
+static int cpuhotplug_get_cur_state(struct thermal_cooling_device *cdev,
+				 unsigned long *state)
+{
+	struct hotplug_cooling_device *hotplug_dev = NULL;
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
+	/*
+	* This cooling device may be of type ACTIVE, so state field can
+	* be 0 or 1
+	*/
+	*state = hotplug_dev->hotplug_state;
+	return 0;
+}
+
+/*This cooling may be as ACTIVE type*/
+static int cpuhotplug_set_cur_state(struct thermal_cooling_device *cdev,
+				 unsigned long state)
+{
+	int cpuid, this_cpu = smp_processor_id();
+	struct hotplug_cooling_device *hotplug_dev = NULL;
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
+#endif /*CONFIG_HOTPLUG_CPU*/
diff --git a/include/linux/cpu_cooling.h b/include/linux/cpu_cooling.h
index 5dc5632..8d195d5 100644
--- a/include/linux/cpu_cooling.h
+++ b/include/linux/cpu_cooling.h
@@ -50,5 +50,22 @@ static inline void cpufreq_cooling_unregister(
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

