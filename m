Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab3AGHUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 02:20:11 -0500
Received: from mga03.intel.com ([143.182.124.21]:19149 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387Ab3AGHSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 02:18:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,422,1355126400"; 
   d="scan'208";a="240732782"
From: Durgadoss R <durgadoss.r@intel.com>
To: rui.zhang@intel.com, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, eduardo.valentin@ti.com,
        hongbo.zhang@linaro.org, wni@nvidia.com,
        Durgadoss R <durgadoss.r@intel.com>
Subject: [PATCH 2/9] Thermal: Create zone level APIs
Date: Mon,  7 Jan 2013 12:43:19 +0530
Message-Id: <1357542806-20449-3-git-send-email-durgadoss.r@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357542806-20449-1-git-send-email-durgadoss.r@intel.com>
References: <1357542806-20449-1-git-send-email-durgadoss.r@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new thermal_zone structure to
thermal.h. Also, adds zone level APIs to the thermal
framework.

A thermal zone is a hot spot on the platform, which
can have one or more sensors and cooling devices attached
to it. These sensors can be mapped to a set of cooling
devices, which when throttled, can help to bring down
the temperature of the hot spot.

Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
---
 drivers/thermal/thermal_sys.c |  196 +++++++++++++++++++++++++++++++++++++++++
 include/linux/thermal.h       |   22 +++++
 2 files changed, 218 insertions(+)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index b2becb9..513b0fc 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -44,19 +44,46 @@ MODULE_DESCRIPTION("Generic thermal management sysfs support");
 MODULE_LICENSE("GPL");
 
 static DEFINE_IDR(thermal_tz_idr);
+static DEFINE_IDR(thermal_zone_idr);
 static DEFINE_IDR(thermal_cdev_idr);
 static DEFINE_IDR(thermal_sensor_idr);
 static DEFINE_MUTEX(thermal_idr_lock);
 
 static LIST_HEAD(thermal_tz_list);
 static LIST_HEAD(thermal_sensor_list);
+static LIST_HEAD(thermal_zone_list);
 static LIST_HEAD(thermal_cdev_list);
 static LIST_HEAD(thermal_governor_list);
 
 static DEFINE_MUTEX(thermal_list_lock);
 static DEFINE_MUTEX(sensor_list_lock);
+static DEFINE_MUTEX(zone_list_lock);
 static DEFINE_MUTEX(thermal_governor_lock);
 
+#define for_each_thermal_sensor(pos) \
+	list_for_each_entry(pos, &thermal_sensor_list, node)
+
+#define for_each_thermal_zone(pos) \
+	list_for_each_entry(pos, &thermal_zone_list, node)
+
+#define GET_INDEX(tz, ptr, type)			\
+({							\
+	int i, ret = -EINVAL;				\
+	do {						\
+		if (!tz || !ptr)			\
+			break;				\
+		mutex_lock(&type##_list_lock);		\
+		for (i = 0; i < tz->type##_indx; i++) {	\
+			if (tz->type##s[i] == ptr) {	\
+				ret = i;		\
+				break;			\
+			}				\
+		}					\
+		mutex_unlock(&type##_list_lock);	\
+	} while (0);					\
+	ret;						\
+})
+
 static struct thermal_governor *__find_governor(const char *name)
 {
 	struct thermal_governor *pos;
@@ -419,15 +446,44 @@ static void thermal_zone_device_check(struct work_struct *work)
 	thermal_zone_device_update(tz);
 }
 
+static void remove_sensor_from_zone(struct thermal_zone *tz,
+				struct thermal_sensor *ts)
+{
+	int j, indx;
+
+	indx = GET_INDEX(tz, ts, sensor);
+	if (indx < 0)
+		return;
+
+	sysfs_remove_link(&tz->device.kobj, kobject_name(&ts->device.kobj));
+
+	/* Shift the entries in the tz->sensors array */
+	for (j = indx; j < MAX_SENSORS_PER_ZONE - 1; j++)
+		tz->sensors[j] = tz->sensors[j + 1];
+
+	tz->sensor_indx--;
+}
+
 /* sys I/F for thermal zone */
 
 #define to_thermal_zone(_dev) \
 	container_of(_dev, struct thermal_zone_device, device)
 
+#define to_zone(_dev) \
+	container_of(_dev, struct thermal_zone, device)
+
 #define to_thermal_sensor(_dev) \
 	container_of(_dev, struct thermal_sensor, device)
 
 static ssize_t
+zone_name_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct thermal_zone *tz = to_zone(dev);
+
+	return sprintf(buf, "%s\n", tz->name);
+}
+
+static ssize_t
 sensor_name_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct thermal_sensor *ts = to_thermal_sensor(dev);
@@ -809,6 +865,8 @@ static DEVICE_ATTR(policy, S_IRUGO | S_IWUSR, policy_show, policy_store);
 static DEVICE_ATTR(sensor_name, 0444, sensor_name_show, NULL);
 static DEVICE_ATTR(temp_input, 0444, sensor_temp_show, NULL);
 
+static DEVICE_ATTR(zone_name, 0444, zone_name_show, NULL);
+
 /* sys I/F for cooling device */
 #define to_cooling_device(_dev)	\
 	container_of(_dev, struct thermal_cooling_device, device)
@@ -1654,6 +1712,136 @@ static int enable_sensor_thresholds(struct thermal_sensor *ts, int count)
 	return 0;
 }
 
+struct thermal_zone *create_thermal_zone(const char *name, void *devdata)
+{
+	struct thermal_zone *tz;
+	int ret;
+
+	if (!name || (name && strlen(name) >= THERMAL_NAME_LENGTH))
+		return ERR_PTR(-EINVAL);
+
+	tz = kzalloc(sizeof(*tz), GFP_KERNEL);
+	if (!tz)
+		return ERR_PTR(-ENOMEM);
+
+	idr_init(&tz->idr);
+	ret = get_idr(&thermal_zone_idr, &thermal_idr_lock, &tz->id);
+	if (ret)
+		goto exit_free;
+
+	strcpy(tz->name, name);
+	tz->devdata = devdata;
+	tz->device.class = &thermal_class;
+
+	dev_set_name(&tz->device, "zone%d", tz->id);
+	ret = device_register(&tz->device);
+	if (ret)
+		goto exit_idr;
+
+	ret = device_create_file(&tz->device, &dev_attr_zone_name);
+	if (ret)
+		goto exit_unregister;
+
+	/* Add this zone to the global list of thermal zones */
+	mutex_lock(&zone_list_lock);
+	list_add_tail(&tz->node, &thermal_zone_list);
+	mutex_unlock(&zone_list_lock);
+	return tz;
+
+exit_unregister:
+	device_unregister(&tz->device);
+exit_idr:
+	release_idr(&thermal_zone_idr, &thermal_idr_lock, tz->id);
+exit_free:
+	kfree(tz);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL(create_thermal_zone);
+
+void remove_thermal_zone(struct thermal_zone *tz)
+{
+	struct thermal_zone *pos, *next;
+	bool found = false;
+
+	if (!tz)
+		return;
+
+	mutex_lock(&zone_list_lock);
+
+	list_for_each_entry_safe(pos, next, &thermal_zone_list, node) {
+		if (pos == tz) {
+			list_del(&tz->node);
+			found = true;
+			break;
+		}
+	}
+
+	if (!found)
+		goto exit;
+
+	device_remove_file(&tz->device, &dev_attr_zone_name);
+
+	release_idr(&thermal_zone_idr, &thermal_idr_lock, tz->id);
+	idr_destroy(&tz->idr);
+
+	device_unregister(&tz->device);
+	kfree(tz);
+exit:
+	mutex_unlock(&zone_list_lock);
+	return;
+}
+EXPORT_SYMBOL(remove_thermal_zone);
+
+struct thermal_sensor *get_sensor_by_name(const char *name)
+{
+	struct thermal_sensor *pos;
+	struct thermal_sensor *ts = NULL;
+
+	mutex_lock(&sensor_list_lock);
+	for_each_thermal_sensor(pos) {
+		if (!strnicmp(pos->name, name, THERMAL_NAME_LENGTH)) {
+			ts = pos;
+			break;
+		}
+	}
+	mutex_unlock(&sensor_list_lock);
+	return ts;
+}
+EXPORT_SYMBOL(get_sensor_by_name);
+
+int add_sensor_to_zone(struct thermal_zone *tz, struct thermal_sensor *ts)
+{
+	int ret;
+
+	if (!tz || !ts)
+		return -EINVAL;
+
+	mutex_lock(&zone_list_lock);
+
+	/* Ensure we are not adding the same sensor again!! */
+	ret = GET_INDEX(tz, ts, sensor);
+	if (ret >= 0) {
+		ret = -EEXIST;
+		goto exit_zone;
+	}
+
+	mutex_lock(&sensor_list_lock);
+
+	ret = sysfs_create_link(&tz->device.kobj, &ts->device.kobj,
+				kobject_name(&ts->device.kobj));
+	if (ret)
+		goto exit_sensor;
+
+	tz->sensors[tz->sensor_indx++] = ts;
+
+exit_sensor:
+	mutex_unlock(&sensor_list_lock);
+exit_zone:
+	mutex_unlock(&zone_list_lock);
+	return ret;
+}
+EXPORT_SYMBOL(add_sensor_to_zone);
+
 /**
  * thermal_sensor_register - register a new thermal sensor
  * @name:	name of the thermal sensor
@@ -1730,6 +1918,7 @@ EXPORT_SYMBOL(thermal_sensor_register);
 void thermal_sensor_unregister(struct thermal_sensor *ts)
 {
 	int i;
+	struct thermal_zone *tz;
 	struct thermal_sensor *pos, *next;
 	bool found = false;
 
@@ -1749,6 +1938,13 @@ void thermal_sensor_unregister(struct thermal_sensor *ts)
 	if (!found)
 		return;
 
+	mutex_lock(&zone_list_lock);
+
+	for_each_thermal_zone(tz)
+		remove_sensor_from_zone(tz, ts);
+
+	mutex_unlock(&zone_list_lock);
+
 	for (i = 0; i < ts->thresholds; i++) {
 		device_remove_file(&ts->device, &ts->thresh_attrs[i].attr);
 		if (ts->ops->get_hyst) {
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index a49cb38..f5b9540 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -49,6 +49,8 @@
 /* Default Thermal Governor: Does Linear Throttling */
 #define DEFAULT_THERMAL_GOVERNOR	"step_wise"
 
+#define MAX_SENSORS_PER_ZONE		5
+
 struct thermal_sensor;
 struct thermal_zone_device;
 struct thermal_cooling_device;
@@ -194,6 +196,21 @@ struct thermal_zone_device {
 	struct delayed_work poll_queue;
 };
 
+struct thermal_zone {
+	char name[THERMAL_NAME_LENGTH];
+	int id;
+	void *devdata;
+	struct thermal_zone *ops;
+	struct thermal_governor *governor;
+	struct idr idr;
+	struct device device;
+	struct list_head node;
+
+	/* Sensor level information */
+	int sensor_indx; /* index into 'sensors' array */
+	struct thermal_sensor *sensors[MAX_SENSORS_PER_ZONE];
+};
+
 /* Structure that holds thermal governor information */
 struct thermal_governor {
 	char name[THERMAL_NAME_LENGTH];
@@ -266,6 +283,11 @@ struct thermal_sensor *thermal_sensor_register(const char *, int,
 				struct thermal_sensor_ops *, void *);
 void thermal_sensor_unregister(struct thermal_sensor *);
 
+struct thermal_zone *create_thermal_zone(const char *, void *);
+void remove_thermal_zone(struct thermal_zone *);
+int add_sensor_to_zone(struct thermal_zone *, struct thermal_sensor *);
+struct thermal_sensor *get_sensor_by_name(const char *);
+
 #ifdef CONFIG_NET
 extern int thermal_generate_netlink_event(u32 orig, enum events event);
 #else
-- 
1.7.9.5

