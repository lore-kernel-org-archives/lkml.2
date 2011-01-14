Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab1ANAfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 19:35:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60973 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087Ab1ANAfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 19:35:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH] PM: Do not create wakeup sysfs files for devices that cannot wakeup
Date: Fri, 14 Jan 2011 01:34:43 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101140134.43342.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Currently, wakeup sysfs attributes are created for all devices,
regardless of whether or not they are wakeup-capable.  This is
excessive and complicates wakeup device identification from user
space (i.e. to identify wakeup-capable devices user space has to read
/sys/devices/.../power/wakeup for all devices and see if these files
are not empty).

Fix this issue by avoiding to create wakeup sysfs files for devices
that cannot wake up the system from sleep states (i.e. whose
power.can_wakeup flags are unset during registration) and modify
device_set_wakeup_capable() so that it adds (or removes) the relevant
sysfs attributes if a device's wakeup capability status is changed.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/power.h  |   15 +++-----
 drivers/base/power/sysfs.c  |   81 +++++++++++++++++++++++++++-----------------
 drivers/base/power/wakeup.c |   26 ++++++++++++++
 include/linux/pm_runtime.h  |    6 +++
 include/linux/pm_wakeup.h   |   10 +----
 5 files changed, 91 insertions(+), 47 deletions(-)

Index: linux-2.6/drivers/base/power/sysfs.c
===================================================================
--- linux-2.6.orig/drivers/base/power/sysfs.c
+++ linux-2.6/drivers/base/power/sysfs.c
@@ -431,9 +431,20 @@ static ssize_t async_store(struct device
 static DEVICE_ATTR(async, 0644, async_show, async_store);
 #endif /* CONFIG_PM_ADVANCED_DEBUG */
 
-static struct attribute * power_attrs[] = {
-	&dev_attr_wakeup.attr,
+static struct attribute *power_attrs[] = {
+#ifdef CONFIG_PM_ADVANCED_DEBUG
+	&dev_attr_async.attr,
+#endif
+	NULL,
+};
+static struct attribute_group pm_attr_group = {
+	.name	= power_group_name,
+	.attrs	= power_attrs,
+};
+
+static struct attribute *wakeup_attrs[] = {
 #ifdef CONFIG_PM_SLEEP
+	&dev_attr_wakeup.attr,
 	&dev_attr_wakeup_count.attr,
 	&dev_attr_wakeup_active_count.attr,
 	&dev_attr_wakeup_hit_count.attr,
@@ -442,32 +453,26 @@ static struct attribute * power_attrs[]
 	&dev_attr_wakeup_max_time_ms.attr,
 	&dev_attr_wakeup_last_time_ms.attr,
 #endif
-#ifdef CONFIG_PM_ADVANCED_DEBUG
-	&dev_attr_async.attr,
-#ifdef CONFIG_PM_RUNTIME
-	&dev_attr_runtime_status.attr,
-	&dev_attr_runtime_usage.attr,
-	&dev_attr_runtime_active_kids.attr,
-	&dev_attr_runtime_enabled.attr,
-#endif
-#endif
 	NULL,
 };
-static struct attribute_group pm_attr_group = {
+static struct attribute_group pm_wakeup_attr_group = {
 	.name	= power_group_name,
-	.attrs	= power_attrs,
+	.attrs	= wakeup_attrs,
 };
 
-#ifdef CONFIG_PM_RUNTIME
-
 static struct attribute *runtime_attrs[] = {
-#ifndef CONFIG_PM_ADVANCED_DEBUG
+#ifdef CONFIG_PM_RUNTIME
 	&dev_attr_runtime_status.attr,
-#endif
 	&dev_attr_control.attr,
 	&dev_attr_runtime_suspended_time.attr,
 	&dev_attr_runtime_active_time.attr,
 	&dev_attr_autosuspend_delay_ms.attr,
+#ifdef CONFIG_PM_ADVANCED_DEBUG
+	&dev_attr_runtime_usage.attr,
+	&dev_attr_runtime_active_kids.attr,
+	&dev_attr_runtime_enabled.attr,
+#endif
+#endif /* CONFIG_PM_RUNTIME */
 	NULL,
 };
 static struct attribute_group pm_runtime_attr_group = {
@@ -480,35 +485,49 @@ int dpm_sysfs_add(struct device *dev)
 	int rc;
 
 	rc = sysfs_create_group(&dev->kobj, &pm_attr_group);
-	if (rc == 0 && !dev->power.no_callbacks) {
+	if (rc)
+		return rc;
+
+	if (pm_runtime_callbacks_present(dev)) {
 		rc = sysfs_merge_group(&dev->kobj, &pm_runtime_attr_group);
 		if (rc)
-			sysfs_remove_group(&dev->kobj, &pm_attr_group);
+			goto err_out;
+	}
+
+	if (device_can_wakeup(dev)) {
+		rc = sysfs_merge_group(&dev->kobj, &pm_wakeup_attr_group);
+		if (rc) {
+			if (pm_runtime_callbacks_present(dev))
+				sysfs_unmerge_group(&dev->kobj,
+						    &pm_runtime_attr_group);
+			goto err_out;
+		}
 	}
+	return 0;
+
+ err_out:
+	sysfs_remove_group(&dev->kobj, &pm_attr_group);
 	return rc;
 }
 
-void rpm_sysfs_remove(struct device *dev)
+int wakeup_sysfs_add(struct device *dev)
 {
-	sysfs_unmerge_group(&dev->kobj, &pm_runtime_attr_group);
+	return sysfs_merge_group(&dev->kobj, &pm_wakeup_attr_group);
 }
 
-void dpm_sysfs_remove(struct device *dev)
+void wakeup_sysfs_remove(struct device *dev)
 {
-	rpm_sysfs_remove(dev);
-	sysfs_remove_group(&dev->kobj, &pm_attr_group);
+	sysfs_unmerge_group(&dev->kobj, &pm_wakeup_attr_group);
 }
 
-#else /* CONFIG_PM_RUNTIME */
-
-int dpm_sysfs_add(struct device * dev)
+void rpm_sysfs_remove(struct device *dev)
 {
-	return sysfs_create_group(&dev->kobj, &pm_attr_group);
+	sysfs_unmerge_group(&dev->kobj, &pm_runtime_attr_group);
 }
 
-void dpm_sysfs_remove(struct device * dev)
+void dpm_sysfs_remove(struct device *dev)
 {
+	rpm_sysfs_remove(dev);
+	sysfs_unmerge_group(&dev->kobj, &pm_wakeup_attr_group);
 	sysfs_remove_group(&dev->kobj, &pm_attr_group);
 }
-
-#endif
Index: linux-2.6/include/linux/pm_runtime.h
===================================================================
--- linux-2.6.orig/include/linux/pm_runtime.h
+++ linux-2.6/include/linux/pm_runtime.h
@@ -87,6 +87,11 @@ static inline bool pm_runtime_enabled(st
 	return !dev->power.disable_depth;
 }
 
+static inline bool pm_runtime_callbacks_present(struct device *dev)
+{
+	return !dev->power.no_callbacks;
+}
+
 static inline void pm_runtime_mark_last_busy(struct device *dev)
 {
 	ACCESS_ONCE(dev->power.last_busy) = jiffies;
@@ -133,6 +138,7 @@ static inline int pm_generic_runtime_res
 static inline void pm_runtime_no_callbacks(struct device *dev) {}
 static inline void pm_runtime_irq_safe(struct device *dev) {}
 
+static inline bool pm_runtime_callbacks_present(struct device *dev) { return false; }
 static inline void pm_runtime_mark_last_busy(struct device *dev) {}
 static inline void __pm_runtime_use_autosuspend(struct device *dev,
 						bool use) {}
Index: linux-2.6/drivers/base/power/power.h
===================================================================
--- linux-2.6.orig/drivers/base/power/power.h
+++ linux-2.6/drivers/base/power/power.h
@@ -61,16 +61,15 @@ static inline void device_pm_move_last(s
 extern int dpm_sysfs_add(struct device *);
 extern void dpm_sysfs_remove(struct device *);
 extern void rpm_sysfs_remove(struct device *);
+extern int wakeup_sysfs_add(struct device *dev);
+extern void wakeup_sysfs_remove(struct device *dev);
 
 #else /* CONFIG_PM */
 
-static inline int dpm_sysfs_add(struct device *dev)
-{
-	return 0;
-}
-
-static inline void dpm_sysfs_remove(struct device *dev)
-{
-}
+static inline int dpm_sysfs_add(struct device *dev) { return 0; }
+static inline void dpm_sysfs_remove(struct device *dev) {}
+static inline void rpm_sysfs_remove(struct device *) {}
+static inline int wakeup_sysfs_add(struct device *dev) { return 0; }
+static inline void wakeup_sysfs_remove(struct device *dev) {}
 
 #endif
Index: linux-2.6/include/linux/pm_wakeup.h
===================================================================
--- linux-2.6.orig/include/linux/pm_wakeup.h
+++ linux-2.6/include/linux/pm_wakeup.h
@@ -62,18 +62,11 @@ struct wakeup_source {
  * Changes to device_may_wakeup take effect on the next pm state change.
  */
 
-static inline void device_set_wakeup_capable(struct device *dev, bool capable)
-{
-	dev->power.can_wakeup = capable;
-}
-
 static inline bool device_can_wakeup(struct device *dev)
 {
 	return dev->power.can_wakeup;
 }
 
-
-
 static inline bool device_may_wakeup(struct device *dev)
 {
 	return dev->power.can_wakeup && !!dev->power.wakeup;
@@ -88,6 +81,7 @@ extern struct wakeup_source *wakeup_sour
 extern void wakeup_source_unregister(struct wakeup_source *ws);
 extern int device_wakeup_enable(struct device *dev);
 extern int device_wakeup_disable(struct device *dev);
+extern void device_set_wakeup_capable(struct device *dev, bool capable);
 extern int device_init_wakeup(struct device *dev, bool val);
 extern int device_set_wakeup_enable(struct device *dev, bool enable);
 extern void __pm_stay_awake(struct wakeup_source *ws);
@@ -144,7 +138,7 @@ static inline int device_wakeup_disable(
 
 static inline int device_init_wakeup(struct device *dev, bool val)
 {
-	dev->power.can_wakeup = val;
+	device_set_wakeup_capable(dev, val);
 	return val ? -EINVAL : 0;
 }
 
Index: linux-2.6/drivers/base/power/wakeup.c
===================================================================
--- linux-2.6.orig/drivers/base/power/wakeup.c
+++ linux-2.6/drivers/base/power/wakeup.c
@@ -228,6 +228,32 @@ int device_wakeup_disable(struct device
 EXPORT_SYMBOL_GPL(device_wakeup_disable);
 
 /**
+ * device_set_wakeup_capable - Set/reset device wakeup capability flag.
+ * @dev: Device to handle.
+ * @capable: Whether or not @dev is capable of waking up the system from sleep.
+ *
+ * If @capable is set, set the @dev's power.can_wakeup flag and add its
+ * wakeup-related attributes to sysfs.  Otherwise, unset the @dev's
+ * power.can_wakeup flag and remove its wakeup-related attributes from sysfs.
+ */
+void device_set_wakeup_capable(struct device *dev, bool capable)
+{
+	if (!!dev->power.can_wakeup == !!capable)
+		return;
+
+	if (device_is_registered(dev)) {
+		if (capable) {
+			if (wakeup_sysfs_add(dev))
+				return;
+		} else {
+			wakeup_sysfs_remove(dev);
+		}
+	}
+	dev->power.can_wakeup = capable;
+}
+EXPORT_SYMBOL_GPL(device_set_wakeup_capable);
+
+/**
  * device_init_wakeup - Device wakeup initialization.
  * @dev: Device to handle.
  * @enable: Whether or not to enable @dev as a wakeup device.
