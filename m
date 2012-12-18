Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab2LRJg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 04:36:26 -0500
Received: from mga14.intel.com ([143.182.124.37]:15832 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191Ab2LRJeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 04:34:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,308,1355126400"; 
   d="scan'208";a="233077828"
From: Durgadoss R <durgadoss.r@intel.com>
To: rui.zhang@intel.com, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hongbo.zhang@linaro.org, wni@nvidia.com,
        Durgadoss R <durgadoss.r@intel.com>
Subject: [PATCH 5/8] Thermal: Add 'thermal_map' sysfs node
Date: Tue, 18 Dec 2012 14:59:34 +0530
Message-Id: <1355822977-4804-6-git-send-email-durgadoss.r@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355822977-4804-1-git-send-email-durgadoss.r@intel.com>
References: <1355822977-4804-1-git-send-email-durgadoss.r@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates a thermal map sysfs node under
/sys/class/thermal/thermal_zoneX/. This contains
entries named map0, map1 .. mapN. Each map has the
following space separated values:
trip_type sensor_name cdev_name trip_mask weights

Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
---
 drivers/thermal/thermal_sys.c |  149 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/thermal.h       |   29 ++++++++
 2 files changed, 176 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 29ec073..a3adc00 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -506,6 +506,41 @@ static void remove_cdev_from_zone(struct thermal_zone *tz,
 	tz->cdev_indx--;
 }
 
+static void __clean_map_entry(struct thermal_zone *tz, int i)
+{
+	tz->map[i] = NULL;
+	sysfs_remove_file(tz->kobj_thermal_map, &tz->map_attr[i]->attr.attr);
+	/* Free map attributes */
+	kfree(tz->map_attr[i]);
+	tz->map_attr[i] = NULL;
+}
+
+static void remove_sensor_map_entry(struct thermal_zone *tz,
+				struct thermal_sensor *ts)
+{
+	int i;
+
+	for (i = 0; i < MAX_MAPS_PER_ZONE; i++) {
+		if (tz->map[i] && !strnicmp(ts->name, tz->map[i]->sensor_name,
+						THERMAL_NAME_LENGTH)) {
+			__clean_map_entry(tz, i);
+		}
+	}
+}
+
+static void remove_cdev_map_entry(struct thermal_zone *tz,
+				struct thermal_cooling_device *cdev)
+{
+	int i;
+
+	for (i = 0; i < MAX_MAPS_PER_ZONE; i++) {
+		if (tz->map[i] && !strnicmp(cdev->type, tz->map[i]->cdev_name,
+						THERMAL_NAME_LENGTH)) {
+			__clean_map_entry(tz, i);
+		}
+	}
+}
+
 /* sys I/F for thermal zone */
 
 #define to_thermal_zone(_dev) \
@@ -898,6 +933,52 @@ policy_show(struct device *dev, struct device_attribute *devattr, char *buf)
 }
 
 static ssize_t
+map_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
+{
+	int i, indx, ret = 0;
+	struct thermal_zone *tz;
+	struct thermal_map *map;
+	struct device *dev;
+	char *trip;
+
+	/*
+	 * For maps under /sys/class/thermal/zoneX/thermal_map/mapY:
+	 * attr		points to mapY
+	 * kobj		points to thermal_map
+	 * kobj->parent	points to zoneX
+	 */
+
+	/* Get zone pointer */
+	dev = container_of(kobj->parent, struct device, kobj);
+	tz = to_zone(dev);
+	if (!tz)
+		return -EINVAL;
+
+	sscanf(attr->attr.name, "map%d", &indx);
+
+	if (indx < 0 || indx >= MAX_MAPS_PER_ZONE)
+		return -EINVAL;
+
+	if (!tz->map[indx])
+		return sprintf(buf, "<Unavailable>\n");
+
+	map = tz->map[indx];
+
+	trip = (map->trip_type == THERMAL_TRIP_ACTIVE) ?
+					"active" : "passive";
+	ret += sprintf(buf, "%s", trip);
+	ret += sprintf(buf + ret, " %s", map->sensor_name);
+	ret += sprintf(buf + ret, " %s", map->cdev_name);
+	ret += sprintf(buf + ret, " 0x%x", map->trip_mask);
+
+	for (i = 0; i < map->num_weights; i++)
+		ret += sprintf(buf + ret, " %d", map->weights[i]);
+
+	ret += sprintf(buf + ret, "\n");
+	return ret;
+}
+
+static ssize_t
 active_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
 {
 	int i, indx, ret = 0;
@@ -1676,8 +1757,10 @@ void thermal_cooling_device_unregister(struct thermal_cooling_device *cdev)
 
 	mutex_lock(&zone_list_lock);
 
-	for_each_thermal_zone(tmp_tz)
+	for_each_thermal_zone(tmp_tz) {
 		remove_cdev_from_zone(tmp_tz, cdev);
+		remove_cdev_map_entry(tmp_tz, cdev);
+	}
 
 	mutex_unlock(&zone_list_lock);
 
@@ -1931,12 +2014,19 @@ struct thermal_zone *create_thermal_zone(const char *name, void *devdata)
 	if (!tz->kobj_thermal_trip)
 		goto exit_name;
 
+	tz->kobj_thermal_map = kobject_create_and_add("thermal_map",
+					&tz->device.kobj);
+	if (!tz->kobj_thermal_map)
+		goto exit_trip;
+
 	/* Add this zone to the global list of thermal zones */
 	mutex_lock(&zone_list_lock);
 	list_add_tail(&tz->node, &thermal_zone_list);
 	mutex_unlock(&zone_list_lock);
 	return tz;
 
+exit_trip:
+	kobject_del(tz->kobj_thermal_trip);
 exit_name:
 	device_remove_file(&tz->device, &dev_attr_zone_name);
 exit_unregister:
@@ -2000,6 +2090,12 @@ void remove_thermal_zone(struct thermal_zone *tz)
 				kobject_name(&tz->cdevs[i]->device.kobj));
 	}
 
+	for (i = 0; i < MAX_MAPS_PER_ZONE; i++)
+		__clean_map_entry(tz, i);
+
+	/* Remove /sys/class/thermal/zoneX/thermal_map */
+	kobject_del(tz->kobj_thermal_map);
+
 	release_idr(&thermal_zone_idr, &thermal_idr_lock, tz->id);
 	idr_destroy(&tz->idr);
 
@@ -2045,6 +2141,53 @@ struct thermal_sensor *get_sensor_by_name(const char *name)
 }
 EXPORT_SYMBOL(get_sensor_by_name);
 
+int add_map_entry(struct thermal_zone *tz, struct thermal_map *map)
+{
+	int ret, indx;
+
+	if (!tz || !map)
+		return -EINVAL;
+
+	mutex_lock(&zone_list_lock);
+
+	for (indx = 0; indx < MAX_MAPS_PER_ZONE; indx++) {
+		if (tz->map[indx] == NULL)
+			break;
+	}
+
+	if (indx >= MAX_MAPS_PER_ZONE) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	tz->map_attr[indx] = kzalloc(sizeof(struct thermal_map_attr),
+					GFP_KERNEL);
+	if (!tz->map_attr[indx]) {
+		ret = -ENOMEM;
+		goto exit;
+	}
+
+	sprintf(tz->map_attr[indx]->name, "map%d", indx);
+
+	tz->map_attr[indx]->attr.attr.name = tz->map_attr[indx]->name;
+	tz->map_attr[indx]->attr.attr.mode = S_IRUGO;
+	tz->map_attr[indx]->attr.show = map_show;
+
+	sysfs_attr_init(&tz->map_attr[indx]->attr.attr);
+	ret = sysfs_create_file(tz->kobj_thermal_map,
+				&tz->map_attr[indx]->attr.attr);
+	if (ret) {
+		kfree(tz->map_attr[indx]);
+		goto exit;
+	}
+
+	tz->map[indx] = map;
+exit:
+	mutex_unlock(&zone_list_lock);
+	return ret;
+}
+EXPORT_SYMBOL(add_map_entry);
+
 int add_sensor_to_zone(struct thermal_zone *tz, struct thermal_sensor *ts)
 {
 	int ret;
@@ -2251,8 +2394,10 @@ void thermal_sensor_unregister(struct thermal_sensor *ts)
 
 	mutex_lock(&zone_list_lock);
 
-	for_each_thermal_zone(tz)
+	for_each_thermal_zone(tz) {
 		remove_sensor_from_zone(tz, ts);
+		remove_sensor_map_entry(tz, ts);
+	}
 
 	mutex_unlock(&zone_list_lock);
 
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 8372f05..581dc87 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -53,6 +53,9 @@
 
 #define MAX_CDEVS_PER_ZONE		5
 
+/* If we map each sensor with every possible cdev for a zone */
+#define MAX_MAPS_PER_ZONE	(MAX_SENSORS_PER_ZONE * MAX_CDEVS_PER_ZONE)
+
 struct thermal_sensor;
 struct thermal_zone_device;
 struct thermal_cooling_device;
@@ -158,6 +161,21 @@ struct thermal_attr {
 	char name[THERMAL_NAME_LENGTH];
 };
 
+struct thermal_map_attr {
+	struct kobj_attribute attr;
+	char name[THERMAL_NAME_LENGTH];
+};
+
+struct thermal_map {
+	enum thermal_trip_type trip_type;
+	char cdev_name[THERMAL_NAME_LENGTH];
+	char sensor_name[THERMAL_NAME_LENGTH];
+
+	int trip_mask;
+	int num_weights;
+	int *weights;
+};
+
 /*
  * This structure defines the trip points for a sensor.
  * The actual values for these trip points come from
@@ -249,6 +267,15 @@ struct thermal_zone {
 	struct kobject *kobj_thermal_trip;
 	struct kobject *kobj_trip[MAX_SENSORS_PER_ZONE];
 	struct thermal_trip_point *sensor_trip[MAX_SENSORS_PER_ZONE];
+
+	/*
+	 * Thermal map information:
+	 * kobj_thermal_map: /sys/class/thermal/zoneX/thermal_map
+	 * map_attr: /sys/class/thermal/zoneX/thermal_map/mapY
+	 */
+	struct kobject *kobj_thermal_map;
+	struct thermal_map_attr *map_attr[MAX_MAPS_PER_ZONE];
+	struct thermal_map *map[MAX_MAPS_PER_ZONE];
 };
 
 /* Structure that holds thermal governor information */
@@ -332,6 +359,8 @@ int add_cdev_to_zone(struct thermal_zone *, struct thermal_cooling_device *);
 int add_sensor_trip_info(struct thermal_zone *, struct thermal_sensor *,
 			struct thermal_trip_point *);
 
+int add_map_entry(struct thermal_zone *, struct thermal_map *);
+
 #ifdef CONFIG_NET
 extern int thermal_generate_netlink_event(u32 orig, enum events event);
 #else
-- 
1.7.9.5

