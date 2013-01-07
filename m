Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab3AGHSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 02:18:30 -0500
Received: from mga03.intel.com ([143.182.124.21]:19149 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572Ab3AGHSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 02:18:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,422,1355126400"; 
   d="scan'208";a="240732791"
From: Durgadoss R <durgadoss.r@intel.com>
To: rui.zhang@intel.com, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, eduardo.valentin@ti.com,
        hongbo.zhang@linaro.org, wni@nvidia.com,
        Durgadoss R <durgadoss.r@intel.com>
Subject: [PATCH 3/9] Thermal: Add APIs to bind cdev to new zone structure
Date: Mon,  7 Jan 2013 12:43:20 +0530
Message-Id: <1357542806-20449-4-git-send-email-durgadoss.r@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357542806-20449-1-git-send-email-durgadoss.r@intel.com>
References: <1357542806-20449-1-git-send-email-durgadoss.r@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates new APIs to add/remove a
cdev to/from a zone. This patch does not change
the old cooling device implementation.

Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
---
 drivers/thermal/thermal_sys.c |   80 +++++++++++++++++++++++++++++++++++++++++
 include/linux/thermal.h       |    9 +++++
 2 files changed, 89 insertions(+)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 513b0fc..332bd61 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -58,6 +58,7 @@ static LIST_HEAD(thermal_governor_list);
 static DEFINE_MUTEX(thermal_list_lock);
 static DEFINE_MUTEX(sensor_list_lock);
 static DEFINE_MUTEX(zone_list_lock);
+static DEFINE_MUTEX(cdev_list_lock);
 static DEFINE_MUTEX(thermal_governor_lock);
 
 #define for_each_thermal_sensor(pos) \
@@ -84,6 +85,9 @@ static DEFINE_MUTEX(thermal_governor_lock);
 	ret;						\
 })
 
+#define for_each_cdev(pos) \
+	list_for_each_entry(pos, &thermal_cdev_list, node)
+
 static struct thermal_governor *__find_governor(const char *name)
 {
 	struct thermal_governor *pos;
@@ -464,6 +468,24 @@ static void remove_sensor_from_zone(struct thermal_zone *tz,
 	tz->sensor_indx--;
 }
 
+static void remove_cdev_from_zone(struct thermal_zone *tz,
+				struct thermal_cooling_device *cdev)
+{
+	int j, indx;
+
+	indx = GET_INDEX(tz, cdev, cdev);
+	if (indx < 0)
+		return;
+
+	sysfs_remove_link(&tz->device.kobj, kobject_name(&cdev->device.kobj));
+
+	/* Shift the entries in the tz->cdevs array */
+	for (j = indx; j < MAX_CDEVS_PER_ZONE - 1; j++)
+		tz->cdevs[j] = tz->cdevs[j + 1];
+
+	tz->cdev_indx--;
+}
+
 /* sys I/F for thermal zone */
 
 #define to_thermal_zone(_dev) \
@@ -1460,6 +1482,7 @@ void thermal_cooling_device_unregister(struct thermal_cooling_device *cdev)
 	int i;
 	const struct thermal_zone_params *tzp;
 	struct thermal_zone_device *tz;
+	struct thermal_zone *tmp_tz;
 	struct thermal_cooling_device *pos = NULL;
 
 	if (!cdev)
@@ -1497,6 +1520,13 @@ void thermal_cooling_device_unregister(struct thermal_cooling_device *cdev)
 
 	mutex_unlock(&thermal_list_lock);
 
+	mutex_lock(&zone_list_lock);
+
+	for_each_thermal_zone(tmp_tz)
+		remove_cdev_from_zone(tmp_tz, cdev);
+
+	mutex_unlock(&zone_list_lock);
+
 	if (cdev->type[0])
 		device_remove_file(&cdev->device, &dev_attr_cdev_type);
 	device_remove_file(&cdev->device, &dev_attr_max_state);
@@ -1792,6 +1822,23 @@ exit:
 }
 EXPORT_SYMBOL(remove_thermal_zone);
 
+struct thermal_cooling_device *get_cdev_by_name(const char *name)
+{
+	struct thermal_cooling_device *pos;
+	struct thermal_cooling_device *cdev = NULL;
+
+	mutex_lock(&cdev_list_lock);
+	for_each_cdev(pos) {
+		if (!strnicmp(pos->type, name, THERMAL_NAME_LENGTH)) {
+			cdev = pos;
+			break;
+		}
+	}
+	mutex_unlock(&cdev_list_lock);
+	return cdev;
+}
+EXPORT_SYMBOL(get_cdev_by_name);
+
 struct thermal_sensor *get_sensor_by_name(const char *name)
 {
 	struct thermal_sensor *pos;
@@ -1842,6 +1889,39 @@ exit_zone:
 }
 EXPORT_SYMBOL(add_sensor_to_zone);
 
+int add_cdev_to_zone(struct thermal_zone *tz,
+			struct thermal_cooling_device *cdev)
+{
+	int ret;
+
+	if (!tz || !cdev)
+		return -EINVAL;
+
+	mutex_lock(&zone_list_lock);
+
+	/* Ensure we are not adding the same cdev again!! */
+	ret = GET_INDEX(tz, cdev, cdev);
+	if (ret >= 0) {
+		ret = -EEXIST;
+		goto exit_zone;
+	}
+
+	mutex_lock(&cdev_list_lock);
+	ret = sysfs_create_link(&tz->device.kobj, &cdev->device.kobj,
+				kobject_name(&cdev->device.kobj));
+	if (ret)
+		goto exit_cdev;
+
+	tz->cdevs[tz->cdev_indx++] = cdev;
+
+exit_cdev:
+	mutex_unlock(&cdev_list_lock);
+exit_zone:
+	mutex_unlock(&zone_list_lock);
+	return ret;
+}
+EXPORT_SYMBOL(add_cdev_to_zone);
+
 /**
  * thermal_sensor_register - register a new thermal sensor
  * @name:	name of the thermal sensor
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index f5b9540..12cc953 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -51,6 +51,8 @@
 
 #define MAX_SENSORS_PER_ZONE		5
 
+#define MAX_CDEVS_PER_ZONE		5
+
 struct thermal_sensor;
 struct thermal_zone_device;
 struct thermal_cooling_device;
@@ -209,6 +211,10 @@ struct thermal_zone {
 	/* Sensor level information */
 	int sensor_indx; /* index into 'sensors' array */
 	struct thermal_sensor *sensors[MAX_SENSORS_PER_ZONE];
+
+	/* cdev level information */
+	int cdev_indx; /* index into 'cdevs' array */
+	struct thermal_cooling_device *cdevs[MAX_CDEVS_PER_ZONE];
 };
 
 /* Structure that holds thermal governor information */
@@ -288,6 +294,9 @@ void remove_thermal_zone(struct thermal_zone *);
 int add_sensor_to_zone(struct thermal_zone *, struct thermal_sensor *);
 struct thermal_sensor *get_sensor_by_name(const char *);
 
+int add_cdev_to_zone(struct thermal_zone *, struct thermal_cooling_device *);
+struct thermal_cooling_device *get_cdev_by_name(const char *);
+
 #ifdef CONFIG_NET
 extern int thermal_generate_netlink_event(u32 orig, enum events event);
 #else
-- 
1.7.9.5

