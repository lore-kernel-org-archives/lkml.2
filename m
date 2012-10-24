Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397Ab2JXL70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:59:26 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36016 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758364Ab2JXL7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:59:21 -0400
From: "hongbo.zhang" <hongbo.zhang@linaro.org>
To: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>
Subject: [PATCH V2 4/6] Thermal: Remove the cooling_cpufreq_list.
Date: Wed, 24 Oct 2012 19:58:18 +0800
Message-Id: <1351079900-32236-5-git-send-email-hongbo.zhang@linaro.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1351079900-32236-1-git-send-email-hongbo.zhang@linaro.com>
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
 <1351079900-32236-1-git-send-email-hongbo.zhang@linaro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "hongbo.zhang" <hongbo.zhang@linaro.com>

Problem of using this list is that the cpufreq_get_max_state callback will be
called when register cooling device by thermal_cooling_device_register, but
this list isn't ready at this moment. What's more, there is no need to maintain
such a list, we can get cpufreq_cooling_device instance by the private
thermal_cooling_device.devdata.

Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>
---
 drivers/thermal/cpu_cooling.c | 81 +++++++++----------------------------------
 1 file changed, 16 insertions(+), 65 deletions(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 415b041..cc80d29 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -58,8 +58,9 @@ struct cpufreq_cooling_device {
 };
 static LIST_HEAD(cooling_cpufreq_list);
 static DEFINE_IDR(cpufreq_idr);
+static DEFINE_MUTEX(cooling_cpufreq_lock);
 
-static struct mutex cooling_cpufreq_lock;
+static unsigned int cpufreq_dev_count;
 
 /* notify_table passes value to the CPUFREQ_ADJUST callback function. */
 #define NOTIFY_INVALID NULL
@@ -241,20 +242,12 @@ static int cpufreq_get_max_state(struct thermal_cooling_device *cdev,
 				 unsigned long *state)
 {
 	int ret = -EINVAL, i = 0;
-	struct cpufreq_cooling_device *cpufreq_device;
+	struct cpufreq_cooling_device *cpufreq_device = cdev->devdata;
 	struct cpumask *maskPtr;
 	unsigned int cpu;
 	struct cpufreq_frequency_table *table;
 	unsigned long count = 0;
 
-	mutex_lock(&cooling_cpufreq_lock);
-	list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node) {
-		if (cpufreq_device && cpufreq_device->cool_dev == cdev)
-			break;
-	}
-	if (cpufreq_device == NULL)
-		goto return_get_max_state;
-
 	maskPtr = &cpufreq_device->allowed_cpus;
 	cpu = cpumask_any(maskPtr);
 	table = cpufreq_frequency_get_table(cpu);
@@ -276,7 +269,6 @@ static int cpufreq_get_max_state(struct thermal_cooling_device *cdev,
 	}
 
 return_get_max_state:
-	mutex_unlock(&cooling_cpufreq_lock);
 	return ret;
 }
 
@@ -288,20 +280,10 @@ return_get_max_state:
 static int cpufreq_get_cur_state(struct thermal_cooling_device *cdev,
 				 unsigned long *state)
 {
-	int ret = -EINVAL;
-	struct cpufreq_cooling_device *cpufreq_device;
-
-	mutex_lock(&cooling_cpufreq_lock);
-	list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node) {
-		if (cpufreq_device && cpufreq_device->cool_dev == cdev) {
-			*state = cpufreq_device->cpufreq_state;
-			ret = 0;
-			break;
-		}
-	}
-	mutex_unlock(&cooling_cpufreq_lock);
+	struct cpufreq_cooling_device *cpufreq_device = cdev->devdata;
 
-	return ret;
+	*state = cpufreq_device->cpufreq_state;
+	return 0;
 }
 
 /**
@@ -312,22 +294,9 @@ static int cpufreq_get_cur_state(struct thermal_cooling_device *cdev,
 static int cpufreq_set_cur_state(struct thermal_cooling_device *cdev,
 				 unsigned long state)
 {
-	int ret = -EINVAL;
-	struct cpufreq_cooling_device *cpufreq_device;
-
-	mutex_lock(&cooling_cpufreq_lock);
-	list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node) {
-		if (cpufreq_device && cpufreq_device->cool_dev == cdev) {
-			ret = 0;
-			break;
-		}
-	}
-	if (!ret)
-		ret = cpufreq_apply_cooling(cpufreq_device, state);
+	struct cpufreq_cooling_device *cpufreq_device = cdev->devdata;
 
-	mutex_unlock(&cooling_cpufreq_lock);
-
-	return ret;
+	return cpufreq_apply_cooling(cpufreq_device, state);
 }
 
 /* Bind cpufreq callbacks to thermal cooling device ops */
@@ -351,7 +320,7 @@ struct thermal_cooling_device *cpufreq_cooling_register(
 {
 	struct thermal_cooling_device *cool_dev;
 	struct cpufreq_cooling_device *cpufreq_dev = NULL;
-	unsigned int cpufreq_dev_count = 0, min = 0, max = 0;
+	unsigned int min = 0, max = 0;
 	char dev_name[THERMAL_NAME_LENGTH];
 	int ret = 0, i;
 	struct cpufreq_policy policy;
@@ -360,9 +329,6 @@ struct thermal_cooling_device *cpufreq_cooling_register(
 	if (!cpufreq_frequency_get_table(cpumask_any(clip_cpus)))
 		return ERR_PTR(-EPROBE_DEFER);
 
-	list_for_each_entry(cpufreq_dev, &cooling_cpufreq_list, node)
-		cpufreq_dev_count++;
-
 	/*Verify that all the clip cpus have same freq_min, freq_max limit*/
 	for_each_cpu(i, clip_cpus) {
 		/*continue if cpufreq policy not found and not return error*/
@@ -384,9 +350,6 @@ struct thermal_cooling_device *cpufreq_cooling_register(
 
 	cpumask_copy(&cpufreq_dev->allowed_cpus, clip_cpus);
 
-	if (cpufreq_dev_count == 0)
-		mutex_init(&cooling_cpufreq_lock);
-
 	ret = get_idr(&cpufreq_idr, &cpufreq_dev->id);
 	if (ret) {
 		kfree(cpufreq_dev);
@@ -405,12 +368,12 @@ struct thermal_cooling_device *cpufreq_cooling_register(
 	cpufreq_dev->cool_dev = cool_dev;
 	cpufreq_dev->cpufreq_state = 0;
 	mutex_lock(&cooling_cpufreq_lock);
-	list_add_tail(&cpufreq_dev->node, &cooling_cpufreq_list);
 
 	/* Register the notifier for first cpufreq cooling device */
 	if (cpufreq_dev_count == 0)
 		cpufreq_register_notifier(&thermal_cpufreq_notifier_block,
 						CPUFREQ_POLICY_NOTIFIER);
+	cpufreq_dev_count++;
 
 	mutex_unlock(&cooling_cpufreq_lock);
 	return cool_dev;
@@ -423,33 +386,21 @@ EXPORT_SYMBOL(cpufreq_cooling_register);
  */
 void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
 {
-	struct cpufreq_cooling_device *cpufreq_dev = NULL;
-	unsigned int cpufreq_dev_count = 0;
+	struct cpufreq_cooling_device *cpufreq_dev = cdev->devdata;
 
-	mutex_lock(&cooling_cpufreq_lock);
-	list_for_each_entry(cpufreq_dev, &cooling_cpufreq_list, node) {
-		if (cpufreq_dev && cpufreq_dev->cool_dev == cdev)
-			break;
-		cpufreq_dev_count++;
-	}
-
-	if (!cpufreq_dev || cpufreq_dev->cool_dev != cdev) {
-		mutex_unlock(&cooling_cpufreq_lock);
-		return;
-	}
+	thermal_cooling_device_unregister(cpufreq_dev->cool_dev);
 
-	list_del(&cpufreq_dev->node);
+	mutex_lock(&cooling_cpufreq_lock);
+	cpufreq_dev_count--;
 
 	/* Unregister the notifier for the last cpufreq cooling device */
-	if (cpufreq_dev_count == 1) {
+	if (cpufreq_dev_count == 0) {
 		cpufreq_unregister_notifier(&thermal_cpufreq_notifier_block,
 					CPUFREQ_POLICY_NOTIFIER);
 	}
 	mutex_unlock(&cooling_cpufreq_lock);
-	thermal_cooling_device_unregister(cpufreq_dev->cool_dev);
+
 	release_idr(&cpufreq_idr, cpufreq_dev->id);
-	if (cpufreq_dev_count == 1)
-		mutex_destroy(&cooling_cpufreq_lock);
 	kfree(cpufreq_dev);
 }
 EXPORT_SYMBOL(cpufreq_cooling_unregister);
-- 
1.7.11.3

