Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab3AGHSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 02:18:32 -0500
Received: from mga03.intel.com ([143.182.124.21]:19149 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647Ab3AGHS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 02:18:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,422,1355126400"; 
   d="scan'208";a="240732809"
From: Durgadoss R <durgadoss.r@intel.com>
To: rui.zhang@intel.com, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, eduardo.valentin@ti.com,
        hongbo.zhang@linaro.org, wni@nvidia.com,
        Durgadoss R <durgadoss.r@intel.com>
Subject: [PATCH 5/9] Thermal: Create 'mapX' sysfs node for a zone
Date: Mon,  7 Jan 2013 12:43:22 +0530
Message-Id: <1357542806-20449-6-git-send-email-durgadoss.r@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357542806-20449-1-git-send-email-durgadoss.r@intel.com>
References: <1357542806-20449-1-git-send-email-durgadoss.r@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates a thermal map sysfs node under
/sys/class/thermal/zoneX/. This contains
entries named map0, map1 .. mapN. Each map has the
following space separated values:
trip_type sensor_name cdev_name trip_mask weights

Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
---
 drivers/thermal/thermal_sys.c |  122 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/thermal.h       |   19 +++++++
 2 files changed, 139 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 1958bb8..5f806d1 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -509,6 +509,39 @@ static void remove_cdev_from_zone(struct thermal_zone *tz,
 	tz->cdev_indx--;
 }
 
+static inline void __clean_map_entry(struct thermal_zone *tz, int i)
+{
+	device_remove_file(&tz->device, &tz->map_attr[i]->attr);
+	kfree(tz->map_attr[i]);
+	tz->map[i] = NULL;
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
@@ -901,6 +934,39 @@ policy_show(struct device *dev, struct device_attribute *devattr, char *buf)
 }
 
 static ssize_t
+map_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	char *trip;
+	int i, indx, ret = 0;
+	struct thermal_map *map;
+	struct thermal_zone *tz = to_zone(dev);
+
+	if (!sscanf(attr->attr.name, "map%d", &indx))
+		return -EINVAL;
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
 active_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	int i, indx, ret = 0;
@@ -1639,8 +1705,10 @@ void thermal_cooling_device_unregister(struct thermal_cooling_device *cdev)
 
 	mutex_lock(&zone_list_lock);
 
-	for_each_thermal_zone(tmp_tz)
+	for_each_thermal_zone(tmp_tz) {
 		remove_cdev_from_zone(tmp_tz, cdev);
+		remove_cdev_map_entry(tmp_tz, cdev);
+	}
 
 	mutex_unlock(&zone_list_lock);
 
@@ -1978,6 +2046,9 @@ void remove_thermal_zone(struct thermal_zone *tz)
 				kobject_name(&tz->cdevs[i]->device.kobj));
 	}
 
+	for (i = 0; i < MAX_MAPS_PER_ZONE; i++)
+		__clean_map_entry(tz, i);
+
 	release_idr(&thermal_zone_idr, &thermal_idr_lock, tz->id);
 	idr_destroy(&tz->idr);
 
@@ -2023,6 +2094,51 @@ struct thermal_sensor *get_sensor_by_name(const char *name)
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
+	tz->map_attr[indx] = kzalloc(sizeof(struct thermal_attr), GFP_KERNEL);
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
+	ret = device_create_file(&tz->device, &tz->map_attr[indx]->attr);
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
@@ -2227,8 +2343,10 @@ void thermal_sensor_unregister(struct thermal_sensor *ts)
 
 	mutex_lock(&zone_list_lock);
 
-	for_each_thermal_zone(tz)
+	for_each_thermal_zone(tz) {
 		remove_sensor_from_zone(tz, ts);
+		remove_sensor_map_entry(tz, ts);
+	}
 
 	mutex_unlock(&zone_list_lock);
 
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 474547d..187fadb 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -54,6 +54,9 @@
 
 #define MAX_CDEVS_PER_ZONE		5
 
+/* If we map each sensor with every possible cdev for a zone */
+#define MAX_MAPS_PER_ZONE	(MAX_SENSORS_PER_ZONE * MAX_CDEVS_PER_ZONE)
+
 struct thermal_sensor;
 struct thermal_zone_device;
 struct thermal_cooling_device;
@@ -159,6 +162,16 @@ struct thermal_attr {
 	char name[THERMAL_NAME_LENGTH];
 };
 
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
@@ -248,6 +261,10 @@ struct thermal_zone {
 	/* Thermal sensors trip information */
 	struct thermal_trip_point *sensor_trip[MAX_SENSORS_PER_ZONE];
 	struct thermal_trip_attr *trip_attr[MAX_SENSORS_PER_ZONE];
+
+	/* Thermal map information */
+	struct thermal_map *map[MAX_MAPS_PER_ZONE];
+	struct thermal_attr *map_attr[MAX_MAPS_PER_ZONE];
 };
 
 /* Structure that holds thermal governor information */
@@ -333,6 +350,8 @@ struct thermal_cooling_device *get_cdev_by_name(const char *);
 int add_sensor_trip_info(struct thermal_zone *, struct thermal_sensor *,
 			struct thermal_trip_point *);
 
+int add_map_entry(struct thermal_zone *, struct thermal_map *);
+
 #ifdef CONFIG_NET
 extern int thermal_generate_netlink_event(u32 orig, enum events event);
 #else
-- 
1.7.9.5

