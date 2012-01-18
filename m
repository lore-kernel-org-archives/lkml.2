Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124Ab2ARJVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:21:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57911 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab2ARJVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:21:42 -0500
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        linaro-dev@lists.linaro.org, amit.kachhap@linaro.org,
        vincent.guittot@linaro.org, rob.lee@linaro.org, patches@linaro.org
Subject: [linux-pm][RFC PATCH] thermal: Add support to report cooling statistics achieved by cooling devices
Date: Wed, 18 Jan 2012 14:51:07 +0530
Message-Id: <1326878467-17766-1-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a sysfs node code to report effective cooling of all cooling devices
attached to each trip points of a thermal zone. The cooling data reported
will be absolute if the higher temperature trip points are arranged first
otherwise the cooling stats is the cumulative effect of the earlier
invoked cooling handlers.

The basic assumption is that cooling devices will bring down the temperature
in a symmetric manner and those statistics can be stored back and used for
further tuning of the system.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
---
 Documentation/thermal/sysfs-api.txt |   10 ++++
 drivers/thermal/thermal_sys.c       |   96 +++++++++++++++++++++++++++++++++++
 include/linux/thermal.h             |    8 +++
 3 files changed, 114 insertions(+), 0 deletions(-)

diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-api.txt
index b61e46f..1db9a9d 100644
--- a/Documentation/thermal/sysfs-api.txt
+++ b/Documentation/thermal/sysfs-api.txt
@@ -209,6 +209,13 @@ passive
 	Valid values: 0 (disabled) or greater than 1000
 	RW, Optional
 
+trip_stats
+	This attribute presents the effective cooling generated from all the
+	cooling devices attached to a trip point. The output is a pair of value
+	for each trip point. Each pair represents
+	(trip index, cooling temperature difference in millidegree Celsius)
+	RO, Optional
+
 *****************************
 * Cooling device attributes *
 *****************************
@@ -261,6 +268,9 @@ method, the sys I/F structure will be built like this:
     |---cdev0_trip_point:	1	/* cdev0 can be used for passive */
     |---cdev1:			--->/sys/class/thermal/cooling_device3
     |---cdev1_trip_point:	2	/* cdev1 can be used for active[0]*/
+    |---trip_stats		0 0
+				1 8000	/*trip 1 causes 8 degree Celsius drop*/
+				2 3000	/*trip 2 causes 3 degree Celsius drop*/
 
 |cooling_device0:
     |---type:			Processor
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index dd9a574..47e7b6e 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -92,6 +92,64 @@ static void release_idr(struct idr *idr, struct mutex *lock, int id)
 	if (lock)
 		mutex_unlock(lock);
 }
+static void update_cooling_stats(struct thermal_zone_device *tz, long cur_temp)
+{
+	int count, max_index, cur_interval;
+	long trip_temp, max_temp = 0, cool_temp;
+	static int last_trip_level = -1;
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
+		last_trip_level = -1;
+		return;
+	}
+
+	cur_interval = tz->stat[max_index].interval_ptr;
+	cool_temp = tz->last_temperature - cur_temp;
+
+	if (last_trip_level != max_index) {
+		if (++cur_interval == INTERVAL_HISTORY)
+			cur_interval = 0;
+		tz->stat[max_index].cool_temp[cur_interval] = cool_temp;
+		tz->stat[max_index].interval_ptr = cur_interval;
+		last_trip_level = max_index;
+	} else {
+		tz->stat[max_index].cool_temp[cur_interval] += cool_temp;
+	}
+}
+
+static int calculate_cooling_temp_avg(struct thermal_zone_device *tz, int trip,
+					int *avg_cool)
+{
+	int result = 0, count = 0, used_data = 0;
+
+	if (trip > THERMAL_MAX_TRIPS)
+		return -EINVAL;
+
+	*avg_cool = 0;
+	for (count = 0; count < INTERVAL_HISTORY; count++) {
+		if (tz->stat[trip].cool_temp[count] > 0) {
+			*avg_cool += tz->stat[trip].cool_temp[count];
+			used_data++;
+		}
+	}
+	if (used_data > 1)
+		*avg_cool = (*avg_cool)/used_data;
+	return result;
+}
 
 /* sys I/F for thermal zone */
 
@@ -493,6 +551,26 @@ temp_crit_show(struct device *dev, struct device_attribute *attr,
 	return sprintf(buf, "%ld\n", temperature);
 }
 
+static ssize_t
+thermal_cooling_trip_stats_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct thermal_zone_device *tz = to_thermal_zone(dev);
+	int avg_cool = 0, result, trip_index;
+	ssize_t len = 0;
+
+	for (trip_index = 0; trip_index < tz->trips; trip_index++) {
+		result  = calculate_cooling_temp_avg(tz,
+						trip_index, &avg_cool);
+		if (!result)
+			len += sprintf(buf + len, "%d %d\n",
+					trip_index, avg_cool);
+	}
+	return len;
+}
+static DEVICE_ATTR(trip_stats, 0444,
+		   thermal_cooling_trip_stats_show, NULL);
 
 static struct thermal_hwmon_device *
 thermal_hwmon_lookup_by_type(const struct thermal_zone_device *tz)
@@ -1049,6 +1127,8 @@ void thermal_zone_device_update(struct thermal_zone_device *tz)
 		goto leave;
 	}
 
+	update_cooling_stats(tz, temp);
+
 	for (count = 0; count < tz->trips; count++) {
 		tz->ops->get_trip_type(tz, count, &trip_type);
 		tz->ops->get_trip_temp(tz, count, &trip_temp);
@@ -1181,6 +1261,13 @@ struct thermal_zone_device *thermal_zone_device_register(char *type,
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
@@ -1207,6 +1294,12 @@ struct thermal_zone_device *thermal_zone_device_register(char *type,
 			passive = 1;
 	}
 
+	if (trips > 0) {
+		result = device_create_file(&tz->device, &dev_attr_trip_stats);
+		if (result)
+			goto unregister;
+	}
+
 	if (!passive)
 		result = device_create_file(&tz->device,
 					    &dev_attr_passive);
@@ -1282,6 +1375,9 @@ void thermal_zone_device_unregister(struct thermal_zone_device *tz)
 	for (count = 0; count < tz->trips; count++)
 		TRIP_POINT_ATTR_REMOVE(&tz->device, count);
 
+	if (tz->trips > 0)
+		device_remove_file(&tz->device, &dev_attr_trip_stats);
+
 	thermal_remove_hwmon_sysfs(tz);
 	release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
 	idr_destroy(&tz->idr);
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 47b4a27..47504c7 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -72,6 +72,13 @@ struct thermal_cooling_device_ops {
 #define THERMAL_TRIPS_NONE -1
 #define THERMAL_MAX_TRIPS 12
 #define THERMAL_NAME_LENGTH 20
+#define INTERVAL_HISTORY 12
+
+struct thermal_cooling_stats {
+	int cool_temp[INTERVAL_HISTORY];
+	int interval_ptr;
+};
+
 struct thermal_cooling_device {
 	int id;
 	char type[THERMAL_NAME_LENGTH];
@@ -102,6 +109,7 @@ struct thermal_zone_device {
 	struct list_head cooling_devices;
 	struct idr idr;
 	struct mutex lock;	/* protect cooling devices list */
+	struct thermal_cooling_stats *stat;
 	struct list_head node;
 	struct delayed_work poll_queue;
 };
-- 
1.7.1

