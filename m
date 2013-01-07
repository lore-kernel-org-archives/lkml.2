Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab3AGHSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 02:18:23 -0500
Received: from mga03.intel.com ([143.182.124.21]:19149 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115Ab3AGHSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 02:18:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,422,1355126400"; 
   d="scan'208";a="240732775"
From: Durgadoss R <durgadoss.r@intel.com>
To: rui.zhang@intel.com, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, eduardo.valentin@ti.com,
        hongbo.zhang@linaro.org, wni@nvidia.com,
        Durgadoss R <durgadoss.r@intel.com>
Subject: [PATCH 1/9] Thermal: Create sensor level APIs
Date: Mon,  7 Jan 2013 12:43:18 +0530
Message-Id: <1357542806-20449-2-git-send-email-durgadoss.r@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357542806-20449-1-git-send-email-durgadoss.r@intel.com>
References: <1357542806-20449-1-git-send-email-durgadoss.r@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates sensor level APIs, in the
generic thermal framework.

A Thermal sensor is a piece of hardware that can report
temperature of the spot in which it is placed. A thermal
sensor driver reads the temperature from this sensor
and reports it out. This kind of driver can be in
any subsystem. If the sensor needs to participate
in platform thermal management, the corresponding
driver can use the APIs introduced in this patch, to
register(or unregister) with the thermal framework.

Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
---
 drivers/thermal/thermal_sys.c |  280 +++++++++++++++++++++++++++++++++++++++++
 include/linux/thermal.h       |   29 +++++
 2 files changed, 309 insertions(+)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 8f0f37b..b2becb9 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -45,13 +45,16 @@ MODULE_LICENSE("GPL");
 
 static DEFINE_IDR(thermal_tz_idr);
 static DEFINE_IDR(thermal_cdev_idr);
+static DEFINE_IDR(thermal_sensor_idr);
 static DEFINE_MUTEX(thermal_idr_lock);
 
 static LIST_HEAD(thermal_tz_list);
+static LIST_HEAD(thermal_sensor_list);
 static LIST_HEAD(thermal_cdev_list);
 static LIST_HEAD(thermal_governor_list);
 
 static DEFINE_MUTEX(thermal_list_lock);
+static DEFINE_MUTEX(sensor_list_lock);
 static DEFINE_MUTEX(thermal_governor_lock);
 
 static struct thermal_governor *__find_governor(const char *name)
@@ -421,6 +424,103 @@ static void thermal_zone_device_check(struct work_struct *work)
 #define to_thermal_zone(_dev) \
 	container_of(_dev, struct thermal_zone_device, device)
 
+#define to_thermal_sensor(_dev) \
+	container_of(_dev, struct thermal_sensor, device)
+
+static ssize_t
+sensor_name_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct thermal_sensor *ts = to_thermal_sensor(dev);
+
+	return sprintf(buf, "%s\n", ts->name);
+}
+
+static ssize_t
+sensor_temp_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	int ret;
+	long val;
+	struct thermal_sensor *ts = to_thermal_sensor(dev);
+
+	ret = ts->ops->get_temp(ts, &val);
+
+	return ret ? ret : sprintf(buf, "%ld\n", val);
+}
+
+static ssize_t
+hyst_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	int indx, ret;
+	long val;
+	struct thermal_sensor *ts = to_thermal_sensor(dev);
+
+	if (!sscanf(attr->attr.name, "threshold%d_hyst", &indx))
+		return -EINVAL;
+
+	ret = ts->ops->get_hyst(ts, indx, &val);
+
+	return ret ? ret : sprintf(buf, "%ld\n", val);
+}
+
+static ssize_t
+hyst_store(struct device *dev, struct device_attribute *attr,
+				   const char *buf, size_t count)
+{
+	int indx, ret;
+	long val;
+	struct thermal_sensor *ts = to_thermal_sensor(dev);
+
+	if (!ts->ops->set_hyst)
+		return -EPERM;
+
+	if (!sscanf(attr->attr.name, "threshold%d_hyst", &indx))
+		return -EINVAL;
+
+	if (kstrtol(buf, 10, &val))
+		return -EINVAL;
+
+	ret = ts->ops->set_hyst(ts, indx, val);
+
+	return ret ? ret : count;
+}
+
+static ssize_t
+threshold_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	int indx, ret;
+	long val;
+	struct thermal_sensor *ts = to_thermal_sensor(dev);
+
+	if (!sscanf(attr->attr.name, "threshold%d", &indx))
+		return -EINVAL;
+
+	ret = ts->ops->get_threshold(ts, indx, &val);
+
+	return ret ? ret : sprintf(buf, "%ld\n", val);
+}
+
+static ssize_t
+threshold_store(struct device *dev, struct device_attribute *attr,
+				   const char *buf, size_t count)
+{
+	int indx, ret;
+	long val;
+	struct thermal_sensor *ts = to_thermal_sensor(dev);
+
+	if (!ts->ops->set_threshold)
+		return -EPERM;
+
+	if (!sscanf(attr->attr.name, "threshold%d", &indx))
+		return -EINVAL;
+
+	if (kstrtol(buf, 10, &val))
+		return -EINVAL;
+
+	ret = ts->ops->set_threshold(ts, indx, val);
+
+	return ret ? ret : count;
+}
+
 static ssize_t
 type_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -705,6 +805,10 @@ static DEVICE_ATTR(mode, 0644, mode_show, mode_store);
 static DEVICE_ATTR(passive, S_IRUGO | S_IWUSR, passive_show, passive_store);
 static DEVICE_ATTR(policy, S_IRUGO | S_IWUSR, policy_show, policy_store);
 
+/* Thermal sensor attributes */
+static DEVICE_ATTR(sensor_name, 0444, sensor_name_show, NULL);
+static DEVICE_ATTR(temp_input, 0444, sensor_temp_show, NULL);
+
 /* sys I/F for cooling device */
 #define to_cooling_device(_dev)	\
 	container_of(_dev, struct thermal_cooling_device, device)
@@ -1491,6 +1595,182 @@ static void remove_trip_attrs(struct thermal_zone_device *tz)
 }
 
 /**
+ * enable_sensor_thresholds - create sysfs nodes for thresholdX
+ * @ts:		the thermal sensor
+ * @count:	Number of thresholds supported by sensor hardware
+ *
+ * 'Thresholds' are temperatures programmed into the sensor hardware,
+ * on crossing which the sensor generates an interrupt. 'Trip points'
+ * are temperatures which the thermal manager/governor thinks, some
+ * action should be taken when the sensor reaches the value.
+ */
+static int enable_sensor_thresholds(struct thermal_sensor *ts, int count)
+{
+	int i;
+	int size = sizeof(struct thermal_attr) * count;
+
+	ts->thresh_attrs = kzalloc(size, GFP_KERNEL);
+	if (!ts->thresh_attrs)
+		return -ENOMEM;
+
+	if (ts->ops->get_hyst) {
+		ts->hyst_attrs = kzalloc(size, GFP_KERNEL);
+		if (!ts->hyst_attrs) {
+			kfree(ts->thresh_attrs);
+			return -ENOMEM;
+		}
+	}
+
+	ts->thresholds = count;
+
+	/* Create threshold attributes */
+	for (i = 0; i < count; i++) {
+		snprintf(ts->thresh_attrs[i].name, THERMAL_NAME_LENGTH,
+						 "threshold%d", i);
+
+		sysfs_attr_init(&ts->thresh_attrs[i].attr.attr);
+		ts->thresh_attrs[i].attr.attr.name = ts->thresh_attrs[i].name;
+		ts->thresh_attrs[i].attr.attr.mode = S_IRUGO | S_IWUSR;
+		ts->thresh_attrs[i].attr.show = threshold_show;
+		ts->thresh_attrs[i].attr.store = threshold_store;
+
+		device_create_file(&ts->device, &ts->thresh_attrs[i].attr);
+
+		/* Create threshold_hyst attributes */
+		if (!ts->ops->get_hyst)
+			continue;
+
+		snprintf(ts->hyst_attrs[i].name, THERMAL_NAME_LENGTH,
+						 "threshold%d_hyst", i);
+
+		sysfs_attr_init(&ts->hyst_attrs[i].attr.attr);
+		ts->hyst_attrs[i].attr.attr.name = ts->hyst_attrs[i].name;
+		ts->hyst_attrs[i].attr.attr.mode = S_IRUGO | S_IWUSR;
+		ts->hyst_attrs[i].attr.show = hyst_show;
+		ts->hyst_attrs[i].attr.store = hyst_store;
+
+		device_create_file(&ts->device, &ts->hyst_attrs[i].attr);
+	}
+	return 0;
+}
+
+/**
+ * thermal_sensor_register - register a new thermal sensor
+ * @name:	name of the thermal sensor
+ * @count:	Number of thresholds supported by hardware
+ * @ops:	standard thermal sensor callbacks
+ * @devdata:	private device data
+ */
+struct thermal_sensor *thermal_sensor_register(const char *name, int count,
+			struct thermal_sensor_ops *ops, void *devdata)
+{
+	struct thermal_sensor *ts;
+	int ret;
+
+	if (!name || (name && strlen(name) >= THERMAL_NAME_LENGTH))
+		return ERR_PTR(-EINVAL);
+
+	if (!ops || !ops->get_temp)
+		return ERR_PTR(-EINVAL);
+
+	ts = kzalloc(sizeof(*ts), GFP_KERNEL);
+	if (!ts)
+		return ERR_PTR(-ENOMEM);
+
+	idr_init(&ts->idr);
+	ret = get_idr(&thermal_sensor_idr, &thermal_idr_lock, &ts->id);
+	if (ret)
+		goto exit_free;
+
+	strcpy(ts->name, name);
+	ts->ops = ops;
+	ts->devdata = devdata;
+	ts->device.class = &thermal_class;
+
+	dev_set_name(&ts->device, "sensor%d", ts->id);
+	ret = device_register(&ts->device);
+	if (ret)
+		goto exit_idr;
+
+	ret = device_create_file(&ts->device, &dev_attr_sensor_name);
+	if (ret)
+		goto exit_unregister;
+
+	ret = device_create_file(&ts->device, &dev_attr_temp_input);
+	if (ret)
+		goto exit_name;
+
+	if (count > 0 && ts->ops->get_threshold) {
+		ret = enable_sensor_thresholds(ts, count);
+		if (ret)
+			goto exit_temp;
+	}
+
+	/* Add this sensor to the global list of sensors */
+	mutex_lock(&sensor_list_lock);
+	list_add_tail(&ts->node, &thermal_sensor_list);
+	mutex_unlock(&sensor_list_lock);
+
+	return ts;
+
+exit_temp:
+	device_remove_file(&ts->device, &dev_attr_temp_input);
+exit_name:
+	device_remove_file(&ts->device, &dev_attr_sensor_name);
+exit_unregister:
+	device_unregister(&ts->device);
+exit_idr:
+	release_idr(&thermal_sensor_idr, &thermal_idr_lock, ts->id);
+exit_free:
+	kfree(ts);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL(thermal_sensor_register);
+
+void thermal_sensor_unregister(struct thermal_sensor *ts)
+{
+	int i;
+	struct thermal_sensor *pos, *next;
+	bool found = false;
+
+	if (!ts)
+		return;
+
+	mutex_lock(&sensor_list_lock);
+	list_for_each_entry_safe(pos, next, &thermal_sensor_list, node) {
+		if (pos == ts) {
+			list_del(&ts->node);
+			found = true;
+			break;
+		}
+	}
+	mutex_unlock(&sensor_list_lock);
+
+	if (!found)
+		return;
+
+	for (i = 0; i < ts->thresholds; i++) {
+		device_remove_file(&ts->device, &ts->thresh_attrs[i].attr);
+		if (ts->ops->get_hyst) {
+			device_remove_file(&ts->device,
+					&ts->hyst_attrs[i].attr);
+		}
+	}
+
+	device_remove_file(&ts->device, &dev_attr_sensor_name);
+	device_remove_file(&ts->device, &dev_attr_temp_input);
+
+	release_idr(&thermal_sensor_idr, &thermal_idr_lock, ts->id);
+	idr_destroy(&ts->idr);
+
+	device_unregister(&ts->device);
+
+	kfree(ts);
+	return;
+}
+EXPORT_SYMBOL(thermal_sensor_unregister);
+
+/**
  * thermal_zone_device_register - register a new thermal zone device
  * @type:	the thermal zone device type
  * @trips:	the number of trip points the thermal zone support
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 807f214..a49cb38 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -49,6 +49,7 @@
 /* Default Thermal Governor: Does Linear Throttling */
 #define DEFAULT_THERMAL_GOVERNOR	"step_wise"
 
+struct thermal_sensor;
 struct thermal_zone_device;
 struct thermal_cooling_device;
 
@@ -127,6 +128,15 @@ struct thermal_cooling_device_ops {
 	int (*set_cur_state) (struct thermal_cooling_device *, unsigned long);
 };
 
+struct thermal_sensor_ops {
+	int (*get_temp) (struct thermal_sensor *, long *);
+	int (*get_trend) (struct thermal_sensor *, int, enum thermal_trend *);
+	int (*set_threshold) (struct thermal_sensor *, int, long);
+	int (*get_threshold) (struct thermal_sensor *, int, long *);
+	int (*set_hyst) (struct thermal_sensor *, int, long);
+	int (*get_hyst) (struct thermal_sensor *, int, long *);
+};
+
 struct thermal_cooling_device {
 	int id;
 	char type[THERMAL_NAME_LENGTH];
@@ -144,6 +154,21 @@ struct thermal_attr {
 	char name[THERMAL_NAME_LENGTH];
 };
 
+struct thermal_sensor {
+	char name[THERMAL_NAME_LENGTH];
+	int id;
+	int temp;
+	int prev_temp;
+	int thresholds;
+	void *devdata;
+	struct idr idr;
+	struct device device;
+	struct list_head node;
+	struct thermal_sensor_ops *ops;
+	struct thermal_attr *thresh_attrs;
+	struct thermal_attr *hyst_attrs;
+};
+
 struct thermal_zone_device {
 	int id;
 	char type[THERMAL_NAME_LENGTH];
@@ -237,6 +262,10 @@ void notify_thermal_framework(struct thermal_zone_device *, int);
 int thermal_register_governor(struct thermal_governor *);
 void thermal_unregister_governor(struct thermal_governor *);
 
+struct thermal_sensor *thermal_sensor_register(const char *, int,
+				struct thermal_sensor_ops *, void *);
+void thermal_sensor_unregister(struct thermal_sensor *);
+
 #ifdef CONFIG_NET
 extern int thermal_generate_netlink_event(u32 orig, enum events event);
 #else
-- 
1.7.9.5

