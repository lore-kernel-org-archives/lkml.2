Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab2BVKQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 05:16:24 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34833 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab2BVKQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 05:16:21 -0500
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        linaro-dev@lists.linaro.org, amit.kachhap@linaro.org,
        durgadoss.r@intel.com, rob.lee@linaro.org, patches@linaro.org
Subject: [PATCH 4/4] thermal: Add support to report cooling statistics achieved by cooling devices
Date: Wed, 22 Feb 2012 15:44:10 +0530
Message-Id: <1329905650-30161-5-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1329905650-30161-1-git-send-email-amit.kachhap@linaro.org>
References: <1329905650-30161-1-git-send-email-amit.kachhap@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a debugfs node code to report effective cooling of all cooling devices
attached to each trip points of a thermal zone. The cooling data reported
will be absolute if the higher temperature trip points are arranged first
otherwise the cooling stats is the cumulative effect of the earlier
invoked cooling handlers.

The basic assumption is that cooling devices will bring down the temperature
in a symmetric manner and those statistics can be stored back and used for
further tuning of the system.

e.g.
cat /sys/kernel/debug/thermal/thermal_zone0/trip_0_cooling
6000
Here trip_0 cooling devices produce 6 degree Celsius temperature drop.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
---
 drivers/thermal/thermal_sys.c |  120 +++++++++++++++++++++++++++++++++++++++++
 include/linux/thermal.h       |   13 +++++
 2 files changed, 133 insertions(+), 0 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index d4c9b20..9784551 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -34,6 +34,7 @@
 #include <linux/reboot.h>
 #include <net/netlink.h>
 #include <net/genetlink.h>
+#include <linux/debugfs.h>
 
 MODULE_AUTHOR("Zhang Rui");
 MODULE_DESCRIPTION("Generic thermal management sysfs support");
@@ -93,6 +94,97 @@ static void release_idr(struct idr *idr, struct mutex *lock, int id)
 		mutex_unlock(lock);
 }
 
+static void update_cooling_stats(struct thermal_zone_device *tz, long cur_temp)
+{
+	int count, max_index, cur_interval, used_data = 0;
+	long trip_temp, max_temp = 0, cool_temp;
+
+	if (cur_temp >= tz->last_temperature)
+		return;
+
+	/* find the trip according to last temperature */
+	for (count = 0; count < tz->trips; count++) {
+		tz->ops->get_trip_temp(tz, count, &trip_temp);
+		if (tz->last_temperature >= trip_temp) {
+			if (max_temp < trip_temp) {
+				max_temp = trip_temp;
+				max_index = count;
+			}
+		}
+	}
+
+	if (!max_temp) {
+		tz->last_trip_level = -1;
+		return;
+	}
+
+	cur_interval = tz->stat[max_index].interval_ptr;
+	cool_temp = tz->last_temperature - cur_temp;
+
+	if (tz->last_trip_level != max_index) {
+		if (++cur_interval == INTERVAL_HISTORY)
+			cur_interval = 0;
+		tz->stat[max_index].cool_temp[cur_interval] = cool_temp;
+		tz->stat[max_index].interval_ptr = cur_interval;
+		tz->last_trip_level = max_index;
+	} else {
+		tz->stat[max_index].cool_temp[cur_interval] += cool_temp;
+	}
+
+	/*Average out the cooling for this trip level*/
+	for (count = 0; count < INTERVAL_HISTORY; count++) {
+		if (tz->stat[max_index].cool_temp[count] > 0) {
+			tz->stat[max_index].avg_cool +=
+					tz->stat[max_index].cool_temp[count];
+			used_data++;
+		}
+	}
+	if (used_data > 1)
+		tz->stat[max_index].avg_cool =
+				tz->stat[max_index].avg_cool / used_data;
+	return;
+}
+
+#if defined(CONFIG_DEBUG_FS)
+/* debugfs support to debug cooling info per trip type */
+static struct dentry *thermal_debugfs_root;
+static int thermal_register_debugfs(struct thermal_zone_device *tz)
+{
+	char name[THERMAL_NAME_LENGTH];
+	int count = 0, err = 0;
+	struct dentry *d;
+
+	if (thermal_debugfs_root == NULL)
+		return -EINVAL;
+
+	sprintf(name, "thermal_zone%d", tz->id);
+	d = debugfs_create_dir(name, thermal_debugfs_root);
+	if (!d)
+		return -ENOMEM;
+	tz->d_entry = d;
+	for (count = 0; count < tz->trips; count++) {
+		sprintf(name, "trip_%d_cooling", count);
+		d = debugfs_create_u32(name, S_IRUGO, tz->d_entry,
+					(u32 *)&tz->stat[count].avg_cool);
+		if (!d) {
+			err = -ENOMEM;
+			goto err_debugfs;
+		}
+	}
+	return 0;
+
+err_debugfs:
+	debugfs_remove_recursive(tz->d_entry);
+	return err;
+}
+
+static void thermal_unregister_debugfs(struct thermal_zone_device *tz)
+{
+	debugfs_remove_recursive(tz->d_entry);
+}
+
+#endif
+
 /* sys I/F for thermal zone */
 
 #define to_thermal_zone(_dev) \
@@ -1051,6 +1143,8 @@ void thermal_zone_device_update(struct thermal_zone_device *tz)
 		goto leave;
 	}
 
+	update_cooling_stats(tz, temp);
+
 	for (count = 0; count < tz->trips; count++) {
 		tz->ops->get_trip_type(tz, count, &trip_type);
 		tz->ops->get_trip_temp(tz, count, &trip_temp);
@@ -1211,6 +1305,7 @@ struct thermal_zone_device *thermal_zone_device_register(char *type,
 	tz->tc2 = tc2;
 	tz->passive_delay = passive_delay;
 	tz->polling_delay = polling_delay;
+	tz->last_trip_level = -1;
 
 	dev_set_name(&tz->device, "thermal_zone%d", tz->id);
 	result = device_register(&tz->device);
@@ -1220,6 +1315,13 @@ struct thermal_zone_device *thermal_zone_device_register(char *type,
 		return ERR_PTR(result);
 	}
 
+	/*Allocate variables for cooling stats*/
+	tz->stat  = devm_kzalloc(&tz->device,
+				sizeof(struct thermal_cooling_stats) * trips,
+				GFP_KERNEL);
+	if (!tz->stat)
+		goto unregister;
+
 	/* sys I/F */
 	if (type) {
 		result = device_create_file(&tz->device, &dev_attr_type);
@@ -1257,6 +1359,12 @@ struct thermal_zone_device *thermal_zone_device_register(char *type,
 	if (result)
 		goto unregister;
 
+#if defined(CONFIG_DEBUG_FS)
+	result = thermal_register_debugfs(tz);
+	if (result)
+		goto unregister;
+#endif
+
 	mutex_lock(&thermal_list_lock);
 	list_add_tail(&tz->node, &thermal_tz_list);
 	if (ops->bind)
@@ -1321,6 +1429,10 @@ void thermal_zone_device_unregister(struct thermal_zone_device *tz)
 	for (count = 0; count < tz->trips; count++)
 		TRIP_POINT_ATTR_REMOVE(&tz->device, count);
 
+#if defined(CONFIG_DEBUG_FS)
+	thermal_unregister_debugfs(tz);
+#endif
+
 	thermal_remove_hwmon_sysfs(tz);
 	release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
 	idr_destroy(&tz->idr);
@@ -1440,6 +1552,11 @@ static int __init thermal_init(void)
 		mutex_destroy(&thermal_list_lock);
 	}
 	result = genetlink_init();
+#if defined(CONFIG_DEBUG_FS)
+	thermal_debugfs_root = debugfs_create_dir("thermal", NULL);
+	if (!thermal_debugfs_root)
+		result = -ENOMEM;
+#endif
 	return result;
 }
 
@@ -1451,6 +1568,9 @@ static void __exit thermal_exit(void)
 	mutex_destroy(&thermal_idr_lock);
 	mutex_destroy(&thermal_list_lock);
 	genetlink_exit();
+#if defined(CONFIG_DEBUG_FS)
+	debugfs_remove_recursive(thermal_debugfs_root);
+#endif
 }
 
 fs_initcall(thermal_init);
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 8df901f..6f15f85 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -73,6 +73,14 @@ struct thermal_cooling_device_ops {
 #define THERMAL_TRIPS_NONE -1
 #define THERMAL_MAX_TRIPS 12
 #define THERMAL_NAME_LENGTH 20
+#define INTERVAL_HISTORY 12
+
+struct thermal_cooling_stats {
+	int cool_temp[INTERVAL_HISTORY];
+	int interval_ptr;
+	int avg_cool;
+};
+
 struct thermal_cooling_device {
 	int id;
 	char type[THERMAL_NAME_LENGTH];
@@ -103,6 +111,11 @@ struct thermal_zone_device {
 	struct list_head cooling_devices;
 	struct idr idr;
 	struct mutex lock;	/* protect cooling devices list */
+	struct thermal_cooling_stats *stat;
+	int last_trip_level;
+#if defined(CONFIG_DEBUG_FS)
+	struct dentry *d_entry;
+#endif
 	struct list_head node;
 	struct delayed_work poll_queue;
 };
-- 
1.7.1

