Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab1KDGuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 02:50:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33713 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab1KDGuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 02:50:03 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-0e-4eb38b1653cf
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: lm-sensors@lm-sensors.org
Cc: linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, dg77.kim@samsung.com,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Subject: [RFC PATCH 1/2] HWMON: add interfaces to read/write hwmon values
 inside kernel
Date: Fri, 04 Nov 2011 15:50:32 +0900
Message-id: <1320389433-1671-2-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1320389433-1671-1-git-send-email-myungjoo.ham@samsung.com>
References: <1320389433-1671-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 04 Nov 2011 06:49:43.0665 (UTC)
 FILETIME=[EF079610:01CC9ABD]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/hwmon/hwmon.c |  108 ++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/hwmon.h |   11 +++++-
 2 files changed, 117 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index a61e781..1ea6736c 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -33,13 +33,20 @@ static DEFINE_SPINLOCK(idr_lock);
 /**
  * hwmon_device_register - register w/ hwmon
  * @dev: the device to register
+ * @attrs: the sysfs attribute group managed by hwmon for the hwmon device.
  *
  * hwmon_device_unregister() must be called when the device is no
  * longer needed.
  *
  * Returns the pointer to the new device.
+ *
+ * If attrs is not null, it is used to call sysfs_create_group()
+ * for dev->kobj. And then sysfs_remove_group() is called with
+ * hwmon_device_unregister().
+ *
  */
-struct device *hwmon_device_register(struct device *dev)
+struct device *hwmon_device_register(struct device *dev,
+				     struct attribute_group *attrs)
 {
 	struct device *hwdev;
 	int id, err;
@@ -65,8 +72,17 @@ again:
 		spin_lock(&idr_lock);
 		idr_remove(&hwmon_idr, id);
 		spin_unlock(&idr_lock);
+		goto out;
 	}
 
+	if (attrs) {
+		err = sysfs_create_group(&dev->kobj, attrs);
+		if (err)
+			return ERR_PTR(err);
+	}
+
+	dev_set_drvdata(hwdev, attrs);
+out:
 	return hwdev;
 }
 
@@ -78,6 +94,10 @@ again:
 void hwmon_device_unregister(struct device *dev)
 {
 	int id;
+	struct attribute_group *attrs = dev_get_drvdata(dev);
+
+	if (attrs)
+		sysfs_remove_group(&dev->parent->kobj, attrs);
 
 	if (likely(sscanf(dev_name(dev), HWMON_ID_FORMAT, &id) == 1)) {
 		device_unregister(dev);
@@ -89,6 +109,92 @@ void hwmon_device_unregister(struct device *dev)
 			"hwmon_device_unregister() failed: bad class ID!\n");
 }
 
+static int hwmon_access_value(struct device *hwmon_dev, const char *name,
+			      char *buf, int bufsize, bool write)
+{
+	struct attribute_group *attrs;
+	struct device_attribute *attr;
+	int i, err = 0;
+
+	get_device(hwmon_dev);
+
+	attrs = dev_get_drvdata(hwmon_dev);
+	if (!attrs)
+		goto out;
+	for (i = 0; attrs->attrs[i]; i++) {
+		attr = container_of(attrs->attrs[i], struct device_attribute,
+				    attr);
+		if (!strcmp(attrs->attrs[i]->name, name))
+			goto found;
+	}
+	err = -EINVAL;
+	goto out;
+
+found:
+	if (write) {
+		if (!attr->store) {
+			err = -EINVAL;
+			goto out;
+		}
+		err = attr->store(hwmon_dev->parent, attr, buf, bufsize);
+	} else {
+		if (!attr->show) {
+			err = -EINVAL;
+			goto out;
+		}
+		err = attr->show(hwmon_dev->parent, attr, buf);
+	}
+
+out:
+	put_device(hwmon_dev);
+	return err;
+}
+
+/**
+ * hwmon_get_value - get the sysfs entry value of the hwmon device.
+ *
+ * @hwmon_dev
+ * @name
+ * @buf
+ */
+int hwmon_get_value(struct device *hwmon_dev, const char *name, char *buf)
+{
+	return hwmon_access_value(hwmon_dev, name, buf, 0, false);
+}
+EXPORT_SYMBOL_GPL(hwmon_get_value);
+
+/**
+ * hwmon_set_value - set the sysfs entry value of the hwmon device.
+ *
+ * @hwmon_dev
+ * @name
+ * @buf
+ * @bufsize
+ */
+int hwmon_set_value(struct device *hwmon_dev, const char *name, char *buf,
+		    int bufsize)
+{
+	return hwmon_access_value(hwmon_dev, name, buf, bufsize, true);
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
+ * hwmon_find_device - find the hwmon-device of the given device
+ *
+ * @dev
+ */
+struct device *hwmon_find_device(struct device *dev)
+{
+	return device_find_child(dev, NULL, hwmon_dev_match);
+}
+
 static void __init hwmon_pci_quirks(void)
 {
 #if defined CONFIG_X86 && defined CONFIG_PCI
diff --git a/include/linux/hwmon.h b/include/linux/hwmon.h
index 6b6ee70..f787cfc 100644
--- a/include/linux/hwmon.h
+++ b/include/linux/hwmon.h
@@ -16,10 +16,19 @@
 
 #include <linux/device.h>
 
-struct device *hwmon_device_register(struct device *dev);
+struct device *hwmon_device_register(struct device *dev,
+				     struct attribute_group *attrs);
 
 void hwmon_device_unregister(struct device *dev);
 
+
+extern int hwmon_get_value(struct device *hwmon_dev, const char *name,
+			   char *buf);
+extern int hwmon_set_value(struct device *hwmon_dev, const char *name,
+			   char *buf, int bufsize);
+
+extern struct device *hwmon_find_device(struct device *dev);
+
 /* Scale user input to sensible values */
 static inline int SENSORS_LIMIT(long value, long low, long high)
 {
-- 
1.7.4.1

