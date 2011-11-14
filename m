Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab1KNIMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 03:12:06 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58688 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab1KNIMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 03:12:03 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
Date: Mon, 14 Nov 2011 17:12:02 +0900
X-Google-Sender-Auth: bWrJr0fm3DpuKu2KuxFjZIBJ8fU
Message-ID: <CAJ0PZbTWQnw5ZTok0iOJT7_Q9h9nQ5SBnhCjvYXBF1ni0dR02Q@mail.gmail.com>
Subject: [PATCH v2 1/2] HWMON: add interfaces to read/write hwmon values
 inside kernel
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: LKML <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Cc: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, dg77.kim@samsung.com,
        kyungmin.park@samsung.com,
        =?UTF-8?B?7ZWo66qF7KO8?= <myungjoo.ham@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds in-kernel interface for HWMON so that kernel code may
read and set HWMON's LMSENSOR values directly.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

---
Changes from v1:
- Keep hwmon_register_device() API as it was.
- Add sysfs entries register/unregister functions
- Alter get/set APIs to lower the overhead
- Access LMSENSOR values with integers, not strings
- Get hwmon device based on device name
---
 drivers/hwmon/hwmon.c |  353 ++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/hwmon.h |   34 +++++
 2 files changed, 386 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index 6460487..2992987 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -21,6 +21,9 @@
 #include <linux/gfp.h>
 #include <linux/spinlock.h>
 #include <linux/pci.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>

 #define HWMON_ID_PREFIX "hwmon"
 #define HWMON_ID_FORMAT HWMON_ID_PREFIX "%d"
@@ -29,6 +32,17 @@ static struct class *hwmon_class;

 static DEFINE_IDA(hwmon_ida);

+struct hwmon_property {
+	struct list_head node;
+	const struct attribute *attr;
+	struct hwmon_property_head *head;
+};
+
+struct hwmon_property_head {
+	struct mutex lock;
+	struct list_head head;
+};
+
 /**
  * hwmon_device_register - register w/ hwmon
  * @dev: the device to register
@@ -42,6 +56,7 @@ struct device *hwmon_device_register(struct device *dev)
 {
 	struct device *hwdev;
 	int id;
+	struct hwmon_property_head *data;

 	id = ida_simple_get(&hwmon_ida, 0, 0, GFP_KERNEL);
 	if (id < 0)
@@ -50,12 +65,47 @@ struct device *hwmon_device_register(struct device *dev)
 	hwdev = device_create(hwmon_class, dev, MKDEV(0, 0), NULL,
 			      HWMON_ID_FORMAT, id);

-	if (IS_ERR(hwdev))
+	if (IS_ERR(hwdev)) {
 		ida_simple_remove(&hwmon_ida, id);
+		goto out;
+	}
+
+	data = kzalloc(sizeof(struct hwmon_property_head), GFP_KERNEL);
+	if (data == NULL)
+		return ERR_PTR(-ENOMEM);

+	INIT_LIST_HEAD(&data->head);
+	mutex_init(&data->lock);
+	dev_set_drvdata(hwdev, data);
+out:
 	return hwdev;
 }

+static inline void _hwmon_free_prop(struct hwmon_property *prop)
+{
+	list_del(&prop->node);
+	prop->attr = NULL;
+	prop->head = NULL;
+	kfree(prop);
+}
+
+/**
+ * hwmon_unregister_all_properties - removes every property registered
+ *
+ * @hwmon: the class device to unregister sysfs properties.
+ */
+void hwmon_unregister_all_properties(struct device *hwmon)
+{
+	struct hwmon_property_head *data = dev_get_drvdata(hwmon);
+	struct hwmon_property *pos, *tmp;
+
+	mutex_lock(&data->lock);
+	list_for_each_entry_safe(pos, tmp, &data->head, node) {
+		_hwmon_free_prop(pos);
+	}
+	mutex_unlock(&data->lock);
+}
+
 /**
  * hwmon_device_unregister - removes the previously registered class device
  *
@@ -64,6 +114,11 @@ struct device *hwmon_device_register(struct device *dev)
 void hwmon_device_unregister(struct device *dev)
 {
 	int id;
+	struct hwmon_property_head *data = dev_get_drvdata(dev);
+
+	hwmon_unregister_all_properties(dev);
+	mutex_destroy(&data->lock);
+	kfree(data);

 	if (likely(sscanf(dev_name(dev), HWMON_ID_FORMAT, &id) == 1)) {
 		device_unregister(dev);
@@ -73,6 +128,302 @@ void hwmon_device_unregister(struct device *dev)
 			"hwmon_device_unregister() failed: bad class ID!\n");
 }

+/**
+ * hwmon_register_property - register one sysfs entry for hwmon framework
+ *
+ * @hwmon: the class device
+ * @attr: a sysfs entry to be registered.
+ */
+struct hwmon_property *hwmon_register_property(struct device *hwmon,
+					const struct device_attribute *attr)
+{
+	struct hwmon_property_head *data = dev_get_drvdata(hwmon);
+	struct hwmon_property *entry;
+
+	entry = kzalloc(sizeof(struct hwmon_property), GFP_KERNEL);
+	if (!entry)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_lock(&data->lock);
+	entry->head = data;
+	entry->attr = &attr->attr;
+	list_add_tail(&entry->node, &data->head);
+	mutex_unlock(&data->lock);
+
+	return entry;
+}
+
+/**
+ * hwmon_unregister_property - unregister the sysfs entry registered to hwmon
+ *
+ * @hwmon: the class device
+ * @prop: hwmon_property entry to be unregistered
+ *
+ * Note that hwmon_device_unregister automatically unregister every property.
+ */
+int hwmon_unregister_property(struct device *hwmon,
+			      struct hwmon_property *prop)
+{
+	struct hwmon_property_head *data = dev_get_drvdata(hwmon);
+	struct hwmon_property *pos, *tmp;
+	int err = -EINVAL;
+
+	if (prop == NULL)
+		return -EINVAL;
+	if (!prop->attr || !prop->node.next || !prop->node.prev)
+		return -EINVAL;
+
+	mutex_lock(&data->lock);
+	list_for_each_entry_safe(pos, tmp, &data->head, node) {
+		if (prop == pos) {
+			_hwmon_free_prop(pos);
+			err = 0;
+			break;
+		}
+	}
+	mutex_unlock(&data->lock);
+
+	return err;
+}
+
+/**
+ * hwmon_register_properties - register a group of sysfs attributes
+ *
+ * @hwmon: hwmon class device to register sysfs entries.
+ * @attrs: a sysfs attribute group to be registered.
+ */
+int hwmon_register_properties(struct device *hwmon,
+			      const struct attribute_group *attrs)
+{
+	int i = 0, j, err = 0;
+	struct attribute **_attrs;
+	struct hwmon_property *prop;
+	struct hwmon_property_head *data = dev_get_drvdata(hwmon);
+
+	if (!attrs)
+		return -EINVAL;
+	_attrs = attrs->attrs;
+	if (!_attrs)
+		return -EINVAL;
+
+	mutex_lock(&data->lock);
+
+	while (_attrs[i]) {
+		prop = kzalloc(sizeof(struct hwmon_property), GFP_KERNEL);
+		if (!prop) {
+			err = -ENOMEM;
+			break;
+		}
+		prop->head = data;
+		prop->attr = _attrs[i];
+		list_add_tail(&prop->node, &data->head);
+		i++;
+	}
+	if (err && i > 0) {
+		struct hwmon_property *pos, *tmp;
+
+		/* nodes are added to tail. remove from head */
+		j = 0;
+		list_for_each_entry_safe(pos, tmp, &data->head, node) {
+			if (pos->attr == _attrs[j]) {
+				_hwmon_free_prop(pos);
+
+				j++;
+				if (j >= i)
+					break;
+			}
+		}
+	}
+
+	mutex_unlock(&data->lock);
+
+	return err;
+}
+
+/**
+ * hwmon_unregister_properties - unregister a group of attributes registered
+ *
+ * @hwmon: hwmon class device to register sysfs entries.
+ * @attrs: a sysfs attribute group to be unregistered.
+ *
+ * Note that hwmon_device_unregister automatically unregister every property.
+ */
+int hwmon_unregister_properties(struct device *hwmon,
+				const struct attribute_group *attrs)
+{
+	struct hwmon_property_head *data = dev_get_drvdata(hwmon);
+	struct attribute **_attrs;
+	struct hwmon_property *pos, *tmp;
+	int i = 0;
+
+	if (!attrs)
+		return -EINVAL;
+	_attrs = attrs->attrs;
+	if (!_attrs)
+		return -EINVAL;
+
+	mutex_lock(&data->lock);
+
+	/*
+	 * Assuming that hwmon_register_properties was used, try to
+	 * remove in the inserted order first.
+	 */
+	list_for_each_entry_safe(pos, tmp, &data->head, node) {
+		if (_attrs[i] == NULL)
+			break;
+		if (pos->attr == _attrs[i]) {
+			_hwmon_free_prop(pos);
+			i++;
+		}
+	}
+
+	/* If it wasn't inserted in the order of attrs */
+	while (_attrs[i]) {
+		list_for_each_entry_safe(pos, tmp, &data->head, node) {
+			if (pos->attr == _attrs[i]) {
+				_hwmon_free_prop(pos);
+				break;
+			}
+		}
+		i++;
+	}
+
+	mutex_unlock(&data->lock);
+	return 0;
+}
+
+/**
+ * hwmon_get_property - get hwmon property based on an LMSENSOR sysfs name.
+ *
+ * @hwmon - hwmon class device
+ * @name - LMSENSOR sysfs name (e.g., "temp1_input")
+ */
+struct hwmon_property *hwmon_get_property(struct device *hwmon,
+					  const char *name)
+{
+	struct hwmon_property_head *data = dev_get_drvdata(hwmon);
+	struct hwmon_property *pos;
+
+	mutex_lock(&data->lock);
+	list_for_each_entry(pos, &data->head, node) {
+		if (!strcmp(name, pos->attr->name))
+			goto out;
+	}
+	pos = ERR_PTR(-EINVAL);
+out:
+	mutex_unlock(&data->lock);
+	return pos;
+}
+
+/**
+ * hwmon_get_value - get the sysfs entry value of the hwmon device.
+ *
+ * @hwmon - hwmon class device
+ * @prop - hwmon property (use hwmon_get_property() to get one)
+ * @value - integer value from prop.
+ */
+int hwmon_get_value(struct device *hwmon, struct hwmon_property *prop,
+		    int *value)
+{
+	int err = -EINVAL;
+	struct device_attribute *devattr;
+	char buf[13]; /* 32b int max string length = 12 */
+
+	if (!prop || !prop->attr || !prop->head)
+		return -EINVAL;
+
+	mutex_lock(&prop->head->lock);
+
+	devattr = container_of(prop->attr, struct device_attribute, attr);
+
+	if (!devattr->show)
+		goto out;
+
+	err = devattr->show(hwmon->parent, devattr, buf);
+	if (strnlen(buf, 13) >= 13) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	err = sscanf(buf, "%d", value);
+	if (err >= 0)
+		err = 0;
+out:
+	mutex_unlock(&prop->head->lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(hwmon_get_value);
+
+/**
+ * hwmon_set_value - set the sysfs entry value of the hwmon device.
+ *
+ * @hwmon - hwmon class device
+ * @prop - hwmon property (use hwmon_get_property() to get one)
+ * @value - integer value to set prop
+ */
+int hwmon_set_value(struct device *hwmon, struct hwmon_property *prop,
+		    int value)
+{
+	int err = -EINVAL, count;
+	struct device_attribute *devattr;
+	char buf[13]; /* 32b int max string length = 12 */
+
+	if (!prop || !prop->attr || !prop->head)
+		return -EINVAL;
+
+	mutex_lock(&prop->head->lock);
+
+	devattr = container_of(prop->attr, struct device_attribute, attr);
+
+	if (!devattr->store)
+		goto out;
+
+	count = snprintf(buf, 13, "%d\n", value);
+
+	err = devattr->store(hwmon->parent, devattr, buf, count);
+out:
+	mutex_unlock(&prop->head->lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(hwmon_set_value);
+
+static int hwmon_dev_match(struct device *dev, void *data)
+{
+	if (dev->class == hwmon_class)
+		return 1;
+	return 0;
+}
+
+/**
+ * hwmon_find_device - find the hwmon device of the given device
+ *
+ * @dev - a parent device of a hwmon class device
+ */
+struct device *hwmon_find_device(struct device *dev)
+{
+	return device_find_child(dev, NULL, hwmon_dev_match);
+}
+
+static int hwmon_parent_name_match(struct device *dev, void *data)
+{
+	char *devname = data;
+
+	if (!strcmp(dev_name(dev->parent), devname))
+		return 1;
+	return 0;
+}
+
+/**
+ * hwmon_find_device_name - find the hwmon device with device name
+ *
+ * @name - device name of the parent device of a hwmon class device
+ */
+struct device *hwmon_find_device_name(char *devname)
+{
+	return class_find_device(hwmon_class, NULL, devname,
+				 hwmon_parent_name_match);
+}
+
 static void __init hwmon_pci_quirks(void)
 {
 #if defined CONFIG_X86 && defined CONFIG_PCI
diff --git a/include/linux/hwmon.h b/include/linux/hwmon.h
index 6b6ee70..2244580 100644
--- a/include/linux/hwmon.h
+++ b/include/linux/hwmon.h
@@ -20,6 +20,40 @@ struct device *hwmon_device_register(struct device *dev);

 void hwmon_device_unregister(struct device *dev);

+struct hwmon_property;
+
+/*
+ * Register property: add the sysfs entry for the hwmon framework
+ *		     so that the hwmon property can be accessed with
+ *		     hwmon_get_value()/hwmon_set_value().
+ * Unregister property: the reverse.
+ *
+ * Note that register/unregister property functions do not touch
+ * sysfs itself. The user should call sysfs_create/update/merge/...
+ * themselves.
+ */
+extern struct hwmon_property *hwmon_register_property(struct device *hwmon,
+					const struct device_attribute *attr);
+extern int hwmon_unregister_property(struct device *hwmon,
+				     struct hwmon_property *);
+extern int hwmon_register_properties(struct device *hwmon,
+				     const struct attribute_group *attrs);
+extern int hwmon_unregister_properties(struct device *hwmon,
+				       const struct attribute_group *attrs);
+
+/* Note that hwmon_device_unregister does the same anyway */
+extern void hwmon_unregister_all_properties(struct device *hwmon);
+
+extern struct device *hwmon_find_device(struct device *dev);
+extern struct device *hwmon_find_device_name(char *devname);
+
+extern struct hwmon_property *hwmon_get_property(struct device *hwmon,
+						 const char *name);
+extern int hwmon_get_value(struct device *hwmon, struct hwmon_property * prop,
+			   int *value);
+extern int hwmon_set_value(struct device *hwmon, struct hwmon_property * prop,
+			   int value);
+
 /* Scale user input to sensible values */
 static inline int SENSORS_LIMIT(long value, long low, long high)
 {
-- 
1.7.4.1
