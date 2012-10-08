Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab2JHIMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 04:12:32 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36146 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700Ab2JHIJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 04:09:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Huang Ying <ying.huang@intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        Jean Pihet <j-pihet@ti.com>, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/7] PM / QoS: Make it possible to expose PM QoS device flags to user space
Date: Mon, 08 Oct 2012 10:07:58 +0200
Message-ID: <5925717.MuPWJfgSgk@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.0-2.10-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1413438.1MkXj8vjQK@vostro.rjw.lan>
References: <201209282351.10663.rjw@sisk.pl> <1413438.1MkXj8vjQK@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Define two device PM QoS flags, PM_QOS_FLAG_NO_POWER_OFF
and PM_QOS_FLAG_REMOTE_WAKEUP, and introduce routines
dev_pm_qos_expose_flags() and dev_pm_qos_hide_flags() allowing the
caller to expose those two flags to user space or to hide them
from it, respectively.

After the flags have been exposed, user space will see two
additional sysfs attributes, pm_qos_no_power_off and
pm_qos_remote_wakeup, under the device's /sys/devices/.../power/
directory.  Then, writing 1 to one of them will update the
PM QoS flags request owned by user space so that the corresponding
flag is requested to be set.  In turn, writing 0 to one of them
will cause the corresponding flag in the user space's request to
be cleared (however, the owners of the other PM QoS flags requests
for the same device may still request the flag to be set and it
may be effectively set even if user space doesn't request that).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Jean Pihet <j-pihet@ti.com>
---
 Documentation/ABI/testing/sysfs-devices-power |   31 ++++
 drivers/base/power/power.h                    |    6 
 drivers/base/power/qos.c                      |  167 ++++++++++++++++++++------
 drivers/base/power/sysfs.c                    |   95 +++++++++++++-
 include/linux/pm.h                            |    1 
 include/linux/pm_qos.h                        |   26 ++++
 6 files changed, 278 insertions(+), 48 deletions(-)

Index: linux/include/linux/pm_qos.h
===================================================================
--- linux.orig/include/linux/pm_qos.h
+++ linux/include/linux/pm_qos.h
@@ -34,6 +34,9 @@ enum pm_qos_flags_status {
 #define PM_QOS_NETWORK_THROUGHPUT_DEFAULT_VALUE	0
 #define PM_QOS_DEV_LAT_DEFAULT_VALUE		0
 
+#define PM_QOS_FLAG_NO_POWER_OFF	(1 << 0)
+#define PM_QOS_FLAG_REMOTE_WAKEUP	(1 << 1)
+
 struct pm_qos_request {
 	struct plist_node node;
 	int pm_qos_class;
@@ -86,6 +89,8 @@ struct pm_qos_flags {
 struct dev_pm_qos {
 	struct pm_qos_constraints latency;
 	struct pm_qos_flags flags;
+	struct dev_pm_qos_request *latency_req;
+	struct dev_pm_qos_request *flags_req;
 };
 
 /* Action requested to pm_qos_update_target */
@@ -187,10 +192,31 @@ static inline int dev_pm_qos_add_ancesto
 #ifdef CONFIG_PM_RUNTIME
 int dev_pm_qos_expose_latency_limit(struct device *dev, s32 value);
 void dev_pm_qos_hide_latency_limit(struct device *dev);
+int dev_pm_qos_expose_flags(struct device *dev, s32 value);
+void dev_pm_qos_hide_flags(struct device *dev);
+int dev_pm_qos_update_flags(struct device *dev, s32 mask, bool set);
+
+static inline s32 dev_pm_qos_requested_latency(struct device *dev)
+{
+	return dev->power.qos->latency_req->data.pnode.prio;
+}
+
+static inline s32 dev_pm_qos_requested_flags(struct device *dev)
+{
+	return dev->power.qos->flags_req->data.flr.flags;
+}
 #else
 static inline int dev_pm_qos_expose_latency_limit(struct device *dev, s32 value)
 			{ return 0; }
 static inline void dev_pm_qos_hide_latency_limit(struct device *dev) {}
+static inline int dev_pm_qos_expose_flags(struct device *dev, s32 value)
+			{ return 0; }
+static inline void dev_pm_qos_hide_flags(struct device *dev) {}
+static inline int dev_pm_qos_update_flags(struct device *dev, s32 m, bool set)
+			{ return 0; }
+
+static inline s32 dev_pm_qos_requested_latency(struct device *dev) { return 0; }
+static inline s32 dev_pm_qos_requested_flags(struct device *dev) { return 0; }
 #endif
 
 #endif
Index: linux/include/linux/pm.h
===================================================================
--- linux.orig/include/linux/pm.h
+++ linux/include/linux/pm.h
@@ -548,7 +548,6 @@ struct dev_pm_info {
 	unsigned long		active_jiffies;
 	unsigned long		suspended_jiffies;
 	unsigned long		accounting_timestamp;
-	struct dev_pm_qos_request *pq_req;
 #endif
 	struct pm_subsys_data	*subsys_data;  /* Owned by the subsystem. */
 	struct dev_pm_qos	*qos;
Index: linux/drivers/base/power/qos.c
===================================================================
--- linux.orig/drivers/base/power/qos.c
+++ linux/drivers/base/power/qos.c
@@ -40,6 +40,7 @@
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/export.h>
+#include <linux/pm_runtime.h>
 
 #include "power.h"
 
@@ -322,6 +323,36 @@ int dev_pm_qos_add_request(struct device
 EXPORT_SYMBOL_GPL(dev_pm_qos_add_request);
 
 /**
+ * __dev_pm_qos_update_request - Modify an existing device PM QoS request.
+ * @req : PM QoS request to modify.
+ * @new_value: New value to request.
+ */
+int __dev_pm_qos_update_request(struct dev_pm_qos_request *req, s32 new_value)
+{
+	s32 curr_value;
+	int ret = 0;
+
+	if (!req->dev->power.qos)
+		return -ENODEV;
+
+	switch(req->type) {
+	case DEV_PM_QOS_LATENCY:
+		curr_value = req->data.pnode.prio;
+		break;
+	case DEV_PM_QOS_FLAGS:
+		curr_value = req->data.flr.flags;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (curr_value != new_value)
+		ret = apply_constraint(req, PM_QOS_UPDATE_REQ, new_value);
+
+	return ret;
+}
+
+/**
  * dev_pm_qos_update_request - modifies an existing qos request
  * @req : handle to list element holding a dev_pm_qos request to use
  * @new_value: defines the qos request
@@ -336,11 +367,9 @@ EXPORT_SYMBOL_GPL(dev_pm_qos_add_request
  * -EINVAL in case of wrong parameters, -ENODEV if the device has been
  * removed from the system
  */
-int dev_pm_qos_update_request(struct dev_pm_qos_request *req,
-			      s32 new_value)
+int dev_pm_qos_update_request(struct dev_pm_qos_request *req, s32 new_value)
 {
-	s32 curr_value;
-	int ret = 0;
+	int ret;
 
 	if (!req) /*guard against callers passing in null */
 		return -EINVAL;
@@ -350,29 +379,9 @@ int dev_pm_qos_update_request(struct dev
 		return -EINVAL;
 
 	mutex_lock(&dev_pm_qos_mtx);
-
-	if (!req->dev->power.qos) {
-		ret = -ENODEV;
-		goto out;
-	}
-
-	switch(req->type) {
-	case DEV_PM_QOS_LATENCY:
-		curr_value = req->data.pnode.prio;
-		break;
-	case DEV_PM_QOS_FLAGS:
-		curr_value = req->data.flr.flags;
-		break;
-	default:
-		ret = -EINVAL;
-		goto out;
-	}
-
-	if (curr_value != new_value)
-		ret = apply_constraint(req, PM_QOS_UPDATE_REQ, new_value);
-
- out:
+	__dev_pm_qos_update_request(req, new_value);
 	mutex_unlock(&dev_pm_qos_mtx);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(dev_pm_qos_update_request);
@@ -533,10 +542,19 @@ int dev_pm_qos_add_ancestor_request(stru
 EXPORT_SYMBOL_GPL(dev_pm_qos_add_ancestor_request);
 
 #ifdef CONFIG_PM_RUNTIME
-static void __dev_pm_qos_drop_user_request(struct device *dev)
+static void __dev_pm_qos_drop_user_request(struct device *dev,
+					   enum dev_pm_qos_req_type type)
 {
-	dev_pm_qos_remove_request(dev->power.pq_req);
-	dev->power.pq_req = NULL;
+	switch(type) {
+	case DEV_PM_QOS_LATENCY:
+		dev_pm_qos_remove_request(dev->power.qos->latency_req);
+		dev->power.qos->latency_req = NULL;
+		break;
+	case DEV_PM_QOS_FLAGS:
+		dev_pm_qos_remove_request(dev->power.qos->flags_req);
+		dev->power.qos->flags_req = NULL;
+		break;
+	}
 }
 
 /**
@@ -552,7 +570,7 @@ int dev_pm_qos_expose_latency_limit(stru
 	if (!device_is_registered(dev) || value < 0)
 		return -EINVAL;
 
-	if (dev->power.pq_req)
+	if (dev->power.qos && dev->power.qos->latency_req)
 		return -EEXIST;
 
 	req = kzalloc(sizeof(*req), GFP_KERNEL);
@@ -563,10 +581,10 @@ int dev_pm_qos_expose_latency_limit(stru
 	if (ret < 0)
 		return ret;
 
-	dev->power.pq_req = req;
-	ret = pm_qos_sysfs_add(dev);
+	dev->power.qos->latency_req = req;
+	ret = pm_qos_sysfs_add_latency(dev);
 	if (ret)
-		__dev_pm_qos_drop_user_request(dev);
+		__dev_pm_qos_drop_user_request(dev, DEV_PM_QOS_LATENCY);
 
 	return ret;
 }
@@ -578,10 +596,87 @@ EXPORT_SYMBOL_GPL(dev_pm_qos_expose_late
  */
 void dev_pm_qos_hide_latency_limit(struct device *dev)
 {
-	if (dev->power.pq_req) {
-		pm_qos_sysfs_remove(dev);
-		__dev_pm_qos_drop_user_request(dev);
+	if (dev->power.qos && dev->power.qos->latency_req) {
+		pm_qos_sysfs_remove_latency(dev);
+		__dev_pm_qos_drop_user_request(dev, DEV_PM_QOS_LATENCY);
 	}
 }
 EXPORT_SYMBOL_GPL(dev_pm_qos_hide_latency_limit);
+
+/**
+ * dev_pm_qos_expose_flags - Expose PM QoS flags of a device to user space.
+ * @dev: Device whose PM QoS flags are to be exposed to user space.
+ * @val: Initial values of the flags.
+ */
+int dev_pm_qos_expose_flags(struct device *dev, s32 val)
+{
+	struct dev_pm_qos_request *req;
+	int ret;
+
+	if (!device_is_registered(dev))
+		return -EINVAL;
+
+	if (dev->power.qos && dev->power.qos->flags_req)
+		return -EEXIST;
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	ret = dev_pm_qos_add_request(dev, req, DEV_PM_QOS_FLAGS, val);
+	if (ret < 0)
+		return ret;
+
+	dev->power.qos->flags_req = req;
+	ret = pm_qos_sysfs_add_flags(dev);
+	if (ret)
+		__dev_pm_qos_drop_user_request(dev, DEV_PM_QOS_FLAGS);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dev_pm_qos_expose_flags);
+
+/**
+ * dev_pm_qos_hide_flags - Hide PM QoS flags of a device from user space.
+ * @dev: Device whose PM QoS flags are to be hidden from user space.
+ */
+void dev_pm_qos_hide_flags(struct device *dev)
+{
+	if (dev->power.qos && dev->power.qos->flags_req) {
+		pm_qos_sysfs_remove_flags(dev);
+		__dev_pm_qos_drop_user_request(dev, DEV_PM_QOS_FLAGS);
+	}
+}
+EXPORT_SYMBOL_GPL(dev_pm_qos_hide_flags);
+
+/**
+ * dev_pm_qos_update_flags - Update PM QoS flags request owned by user space.
+ * @dev: Device to update the PM QoS flags request for.
+ * @mask: Flags to set/clear.
+ * @set: Whether to set or clear the flags (true means set).
+ */
+int dev_pm_qos_update_flags(struct device *dev, s32 mask, bool set)
+{
+	s32 value;
+	int ret;
+
+	if (!dev->power.qos || !dev->power.qos->flags_req)
+		return -EINVAL;
+
+	pm_runtime_get_sync(dev);
+	mutex_lock(&dev_pm_qos_mtx);
+
+	value = dev_pm_qos_requested_flags(dev);
+	if (set)
+		value |= mask;
+	else
+		value &= ~mask;
+
+	ret = __dev_pm_qos_update_request(dev->power.qos->flags_req, value);
+
+	mutex_unlock(&dev_pm_qos_mtx);
+	pm_runtime_put(dev);
+
+	return ret;
+}
 #endif /* CONFIG_PM_RUNTIME */
Index: linux/drivers/base/power/power.h
===================================================================
--- linux.orig/drivers/base/power/power.h
+++ linux/drivers/base/power/power.h
@@ -93,8 +93,10 @@ extern void dpm_sysfs_remove(struct devi
 extern void rpm_sysfs_remove(struct device *dev);
 extern int wakeup_sysfs_add(struct device *dev);
 extern void wakeup_sysfs_remove(struct device *dev);
-extern int pm_qos_sysfs_add(struct device *dev);
-extern void pm_qos_sysfs_remove(struct device *dev);
+extern int pm_qos_sysfs_add_latency(struct device *dev);
+extern void pm_qos_sysfs_remove_latency(struct device *dev);
+extern int pm_qos_sysfs_add_flags(struct device *dev);
+extern void pm_qos_sysfs_remove_flags(struct device *dev);
 
 #else /* CONFIG_PM */
 
Index: linux/drivers/base/power/sysfs.c
===================================================================
--- linux.orig/drivers/base/power/sysfs.c
+++ linux/drivers/base/power/sysfs.c
@@ -221,7 +221,7 @@ static DEVICE_ATTR(autosuspend_delay_ms,
 static ssize_t pm_qos_latency_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", dev->power.pq_req->data.pnode.prio);
+	return sprintf(buf, "%d\n", dev_pm_qos_requested_latency(dev));
 }
 
 static ssize_t pm_qos_latency_store(struct device *dev,
@@ -237,12 +237,67 @@ static ssize_t pm_qos_latency_store(stru
 	if (value < 0)
 		return -EINVAL;
 
-	ret = dev_pm_qos_update_request(dev->power.pq_req, value);
+	ret = dev_pm_qos_update_request(dev->power.qos->latency_req, value);
 	return ret < 0 ? ret : n;
 }
 
 static DEVICE_ATTR(pm_qos_resume_latency_us, 0644,
 		   pm_qos_latency_show, pm_qos_latency_store);
+
+static ssize_t pm_qos_no_power_off_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	return sprintf(buf, "%d\n", !!(dev_pm_qos_requested_flags(dev)
+					& PM_QOS_FLAG_NO_POWER_OFF));
+}
+
+static ssize_t pm_qos_no_power_off_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t n)
+{
+	int ret;
+
+	if (kstrtoint(buf, 0, &ret))
+		return -EINVAL;
+
+	if (ret != 0 && ret != 1)
+		return -EINVAL;
+
+	ret = dev_pm_qos_update_flags(dev, PM_QOS_FLAG_NO_POWER_OFF, ret);
+	return ret < 0 ? ret : n;
+}
+
+static DEVICE_ATTR(pm_qos_no_power_off, 0644,
+		   pm_qos_no_power_off_show, pm_qos_no_power_off_store);
+
+static ssize_t pm_qos_remote_wakeup_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	return sprintf(buf, "%d\n", !!(dev_pm_qos_requested_flags(dev)
+					& PM_QOS_FLAG_REMOTE_WAKEUP));
+}
+
+static ssize_t pm_qos_remote_wakeup_store(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t n)
+{
+	s32 value;
+	int ret;
+
+	if (kstrtoint(buf, 0, &ret))
+		return -EINVAL;
+
+	if (ret != 0 && ret != 1)
+		return -EINVAL;
+
+	ret = dev_pm_qos_update_flags(dev, PM_QOS_FLAG_REMOTE_WAKEUP, ret);
+	return ret < 0 ? ret : n;
+}
+
+static DEVICE_ATTR(pm_qos_remote_wakeup, 0644,
+		   pm_qos_remote_wakeup_show, pm_qos_remote_wakeup_store);
 #endif /* CONFIG_PM_RUNTIME */
 
 #ifdef CONFIG_PM_SLEEP
@@ -564,15 +619,27 @@ static struct attribute_group pm_runtime
 	.attrs	= runtime_attrs,
 };
 
-static struct attribute *pm_qos_attrs[] = {
+static struct attribute *pm_qos_latency_attrs[] = {
 #ifdef CONFIG_PM_RUNTIME
 	&dev_attr_pm_qos_resume_latency_us.attr,
 #endif /* CONFIG_PM_RUNTIME */
 	NULL,
 };
-static struct attribute_group pm_qos_attr_group = {
+static struct attribute_group pm_qos_latency_attr_group = {
+	.name	= power_group_name,
+	.attrs	= pm_qos_latency_attrs,
+};
+
+static struct attribute *pm_qos_flags_attrs[] = {
+#ifdef CONFIG_PM_RUNTIME
+	&dev_attr_pm_qos_no_power_off.attr,
+	&dev_attr_pm_qos_remote_wakeup.attr,
+#endif /* CONFIG_PM_RUNTIME */
+	NULL,
+};
+static struct attribute_group pm_qos_flags_attr_group = {
 	.name	= power_group_name,
-	.attrs	= pm_qos_attrs,
+	.attrs	= pm_qos_flags_attrs,
 };
 
 int dpm_sysfs_add(struct device *dev)
@@ -615,14 +682,24 @@ void wakeup_sysfs_remove(struct device *
 	sysfs_unmerge_group(&dev->kobj, &pm_wakeup_attr_group);
 }
 
-int pm_qos_sysfs_add(struct device *dev)
+int pm_qos_sysfs_add_latency(struct device *dev)
+{
+	return sysfs_merge_group(&dev->kobj, &pm_qos_latency_attr_group);
+}
+
+void pm_qos_sysfs_remove_latency(struct device *dev)
+{
+	sysfs_unmerge_group(&dev->kobj, &pm_qos_latency_attr_group);
+}
+
+int pm_qos_sysfs_add_flags(struct device *dev)
 {
-	return sysfs_merge_group(&dev->kobj, &pm_qos_attr_group);
+	return sysfs_merge_group(&dev->kobj, &pm_qos_flags_attr_group);
 }
 
-void pm_qos_sysfs_remove(struct device *dev)
+void pm_qos_sysfs_remove_flags(struct device *dev)
 {
-	sysfs_unmerge_group(&dev->kobj, &pm_qos_attr_group);
+	sysfs_unmerge_group(&dev->kobj, &pm_qos_flags_attr_group);
 }
 
 void rpm_sysfs_remove(struct device *dev)
Index: linux/Documentation/ABI/testing/sysfs-devices-power
===================================================================
--- linux.orig/Documentation/ABI/testing/sysfs-devices-power
+++ linux/Documentation/ABI/testing/sysfs-devices-power
@@ -204,3 +204,34 @@ Description:
 
 		This attribute has no effect on system-wide suspend/resume and
 		hibernation.
+
+What:		/sys/devices/.../power/pm_qos_no_power_off
+Date:		September 2012
+Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Description:
+		The /sys/devices/.../power/pm_qos_no_power_off attribute
+		is used for manipulating the PM QoS "no power off" flag.  If
+		set, this flag indicates to the kernel that power should not
+		be removed entirely from the device.
+
+		Not all drivers support this attribute.  If it isn't supported,
+		it is not present.
+
+		This attribute has no effect on system-wide suspend/resume and
+		hibernation.
+
+What:		/sys/devices/.../power/pm_qos_remote_wakeup
+Date:		September 2012
+Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Description:
+		The /sys/devices/.../power/pm_qos_remote_wakeup attribute
+		is used for manipulating the PM QoS "remote wakeup required"
+		flag.  If set, this flag indicates to the kernel that the
+		device is a source of user events that have to be signaled from
+		its low-power states.
+
+		Not all drivers support this attribute.  If it isn't supported,
+		it is not present.
+
+		This attribute has no effect on system-wide suspend/resume and
+		hibernation.

