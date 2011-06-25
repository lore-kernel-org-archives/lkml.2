Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab1FYVbv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 17:31:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58117 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195Ab1FYVbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 17:31:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 4/10 v6] PM: Introduce generic "noirq" callback routines for subsystems (v2)
Date: Sat, 25 Jun 2011 23:27:05 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, Magnus Damm <magnus.damm@gmail.com>,
        Paul Walmsley <paul@pwsan.com>, Kevin Hilman <khilman@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
References: <201106112223.04972.rjw@sisk.pl> <201106252324.13454.rjw@sisk.pl>
In-Reply-To: <201106252324.13454.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106252327.05799.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Introduce generic "noirq" power management callback routines for
subsystems in addition to the "regular" generic PM callback routines.

The new routines will be used, among other things, for implementing
system-wide PM transitions support for generic PM domains.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/runtime_pm.txt |   32 +++++++++++-
 drivers/base/power/generic_ops.c   |   98 +++++++++++++++++++++++++++++++------
 include/linux/pm.h                 |    6 ++
 3 files changed, 119 insertions(+), 17 deletions(-)

Index: linux-2.6/drivers/base/power/generic_ops.c
===================================================================
--- linux-2.6.orig/drivers/base/power/generic_ops.c
+++ linux-2.6/drivers/base/power/generic_ops.c
@@ -94,12 +94,13 @@ int pm_generic_prepare(struct device *de
  * __pm_generic_call - Generic suspend/freeze/poweroff/thaw subsystem callback.
  * @dev: Device to handle.
  * @event: PM transition of the system under way.
+ * @bool: Whether or not this is the "noirq" stage.
  *
  * If the device has not been suspended at run time, execute the
  * suspend/freeze/poweroff/thaw callback provided by its driver, if defined, and
  * return its error code.  Otherwise, return zero.
  */
-static int __pm_generic_call(struct device *dev, int event)
+static int __pm_generic_call(struct device *dev, int event, bool noirq)
 {
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int (*callback)(struct device *);
@@ -109,16 +110,16 @@ static int __pm_generic_call(struct devi
 
 	switch (event) {
 	case PM_EVENT_SUSPEND:
-		callback = pm->suspend;
+		callback = noirq ? pm->suspend_noirq : pm->suspend;
 		break;
 	case PM_EVENT_FREEZE:
-		callback = pm->freeze;
+		callback = noirq ? pm->freeze_noirq : pm->freeze;
 		break;
 	case PM_EVENT_HIBERNATE:
-		callback = pm->poweroff;
+		callback = noirq ? pm->poweroff_noirq : pm->poweroff;
 		break;
 	case PM_EVENT_THAW:
-		callback = pm->thaw;
+		callback = noirq ? pm->thaw_noirq : pm->thaw;
 		break;
 	default:
 		callback = NULL;
@@ -129,42 +130,82 @@ static int __pm_generic_call(struct devi
 }
 
 /**
+ * pm_generic_suspend_noirq - Generic suspend_noirq callback for subsystems.
+ * @dev: Device to suspend.
+ */
+int pm_generic_suspend_noirq(struct device *dev)
+{
+	return __pm_generic_call(dev, PM_EVENT_SUSPEND, true);
+}
+EXPORT_SYMBOL_GPL(pm_generic_suspend_noirq);
+
+/**
  * pm_generic_suspend - Generic suspend callback for subsystems.
  * @dev: Device to suspend.
  */
 int pm_generic_suspend(struct device *dev)
 {
-	return __pm_generic_call(dev, PM_EVENT_SUSPEND);
+	return __pm_generic_call(dev, PM_EVENT_SUSPEND, false);
 }
 EXPORT_SYMBOL_GPL(pm_generic_suspend);
 
 /**
+ * pm_generic_freeze_noirq - Generic freeze_noirq callback for subsystems.
+ * @dev: Device to freeze.
+ */
+int pm_generic_freeze_noirq(struct device *dev)
+{
+	return __pm_generic_call(dev, PM_EVENT_FREEZE, true);
+}
+EXPORT_SYMBOL_GPL(pm_generic_freeze_noirq);
+
+/**
  * pm_generic_freeze - Generic freeze callback for subsystems.
  * @dev: Device to freeze.
  */
 int pm_generic_freeze(struct device *dev)
 {
-	return __pm_generic_call(dev, PM_EVENT_FREEZE);
+	return __pm_generic_call(dev, PM_EVENT_FREEZE, false);
 }
 EXPORT_SYMBOL_GPL(pm_generic_freeze);
 
 /**
+ * pm_generic_poweroff_noirq - Generic poweroff_noirq callback for subsystems.
+ * @dev: Device to handle.
+ */
+int pm_generic_poweroff_noirq(struct device *dev)
+{
+	return __pm_generic_call(dev, PM_EVENT_HIBERNATE, true);
+}
+EXPORT_SYMBOL_GPL(pm_generic_poweroff_noirq);
+
+/**
  * pm_generic_poweroff - Generic poweroff callback for subsystems.
  * @dev: Device to handle.
  */
 int pm_generic_poweroff(struct device *dev)
 {
-	return __pm_generic_call(dev, PM_EVENT_HIBERNATE);
+	return __pm_generic_call(dev, PM_EVENT_HIBERNATE, false);
 }
 EXPORT_SYMBOL_GPL(pm_generic_poweroff);
 
 /**
+ * pm_generic_thaw_noirq - Generic thaw_noirq callback for subsystems.
+ * @dev: Device to thaw.
+ */
+int pm_generic_thaw_noirq(struct device *dev)
+{
+	return __pm_generic_call(dev, PM_EVENT_THAW, true);
+}
+EXPORT_SYMBOL_GPL(pm_generic_thaw_noirq);
+
+/**
  * pm_generic_thaw - Generic thaw callback for subsystems.
  * @dev: Device to thaw.
  */
 int pm_generic_thaw(struct device *dev)
 {
-	return __pm_generic_call(dev, PM_EVENT_THAW);
+	return __pm_generic_call(dev, PM_EVENT_THAW, false);
 }
 EXPORT_SYMBOL_GPL(pm_generic_thaw);
 
@@ -172,12 +213,13 @@ EXPORT_SYMBOL_GPL(pm_generic_thaw);
  * __pm_generic_resume - Generic resume/restore callback for subsystems.
  * @dev: Device to handle.
  * @event: PM transition of the system under way.
+ * @bool: Whether or not this is the "noirq" stage.
  *
  * Execute the resume/resotre callback provided by the @dev's driver, if
  * defined.  If it returns 0, change the device's runtime PM status to 'active'.
  * Return the callback's error code.
  */
-static int __pm_generic_resume(struct device *dev, int event)
+static int __pm_generic_resume(struct device *dev, int event, bool noirq)
 {
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int (*callback)(struct device *);
@@ -188,10 +230,10 @@ static int __pm_generic_resume(struct de
 
 	switch (event) {
 	case PM_EVENT_RESUME:
-		callback = pm->resume;
+		callback = noirq ? pm->resume_noirq : pm->resume;
 		break;
 	case PM_EVENT_RESTORE:
-		callback = pm->restore;
+		callback = noirq ? pm->restore_noirq : pm->restore;
 		break;
 	default:
 		callback = NULL;
@@ -202,7 +244,7 @@ static int __pm_generic_resume(struct de
 		return 0;
 
 	ret = callback(dev);
-	if (!ret && pm_runtime_enabled(dev)) {
+	if (!ret && !noirq && pm_runtime_enabled(dev)) {
 		pm_runtime_disable(dev);
 		pm_runtime_set_active(dev);
 		pm_runtime_enable(dev);
@@ -212,22 +254,42 @@ static int __pm_generic_resume(struct de
 }
 
 /**
+ * pm_generic_resume_noirq - Generic resume_noirq callback for subsystems.
+ * @dev: Device to resume.
+ */
+int pm_generic_resume_noirq(struct device *dev)
+{
+	return __pm_generic_resume(dev, PM_EVENT_RESUME, true);
+}
+EXPORT_SYMBOL_GPL(pm_generic_resume_noirq);
+
+/**
  * pm_generic_resume - Generic resume callback for subsystems.
  * @dev: Device to resume.
  */
 int pm_generic_resume(struct device *dev)
 {
-	return __pm_generic_resume(dev, PM_EVENT_RESUME);
+	return __pm_generic_resume(dev, PM_EVENT_RESUME, false);
 }
 EXPORT_SYMBOL_GPL(pm_generic_resume);
 
 /**
+ * pm_generic_restore_noirq - Generic restore_noirq callback for subsystems.
+ * @dev: Device to restore.
+ */
+int pm_generic_restore_noirq(struct device *dev)
+{
+	return __pm_generic_resume(dev, PM_EVENT_RESTORE, true);
+}
+EXPORT_SYMBOL_GPL(pm_generic_restore_noirq);
+
+/**
  * pm_generic_restore - Generic restore callback for subsystems.
  * @dev: Device to restore.
  */
 int pm_generic_restore(struct device *dev)
 {
-	return __pm_generic_resume(dev, PM_EVENT_RESTORE);
+	return __pm_generic_resume(dev, PM_EVENT_RESTORE, false);
 }
 EXPORT_SYMBOL_GPL(pm_generic_restore);
 
@@ -256,11 +318,17 @@ struct dev_pm_ops generic_subsys_pm_ops
 #ifdef CONFIG_PM_SLEEP
 	.prepare = pm_generic_prepare,
 	.suspend = pm_generic_suspend,
+	.suspend_noirq = pm_generic_suspend_noirq,
 	.resume = pm_generic_resume,
+	.resume_noirq = pm_generic_resume_noirq,
 	.freeze = pm_generic_freeze,
+	.freeze_noirq = pm_generic_freeze_noirq,
 	.thaw = pm_generic_thaw,
+	.thaw_noirq = pm_generic_thaw_noirq,
 	.poweroff = pm_generic_poweroff,
+	.poweroff_noirq = pm_generic_poweroff_noirq,
 	.restore = pm_generic_restore,
+	.restore_noirq = pm_generic_restore_noirq,
 	.complete = pm_generic_complete,
 #endif
 #ifdef CONFIG_PM_RUNTIME
Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -553,11 +553,17 @@ extern void __suspend_report_result(cons
 extern int device_pm_wait_for_dev(struct device *sub, struct device *dev);
 
 extern int pm_generic_prepare(struct device *dev);
+extern int pm_generic_suspend_noirq(struct device *dev);
 extern int pm_generic_suspend(struct device *dev);
+extern int pm_generic_resume_noirq(struct device *dev);
 extern int pm_generic_resume(struct device *dev);
+extern int pm_generic_freeze_noirq(struct device *dev);
 extern int pm_generic_freeze(struct device *dev);
+extern int pm_generic_thaw_noirq(struct device *dev);
 extern int pm_generic_thaw(struct device *dev);
+extern int pm_generic_restore_noirq(struct device *dev);
 extern int pm_generic_restore(struct device *dev);
+extern int pm_generic_poweroff_noirq(struct device *dev);
 extern int pm_generic_poweroff(struct device *dev);
 extern void pm_generic_complete(struct device *dev);
 
Index: linux-2.6/Documentation/power/runtime_pm.txt
===================================================================
--- linux-2.6.orig/Documentation/power/runtime_pm.txt
+++ linux-2.6/Documentation/power/runtime_pm.txt
@@ -590,32 +590,60 @@ driver/base/power/generic_ops.c:
       callback provided by its driver and return its result, or return 0 if not
       defined
 
+  int pm_generic_suspend_noirq(struct device *dev);
+    - if pm_runtime_suspended(dev) returns "false", invoke the ->suspend_noirq()
+      callback provided by the device's driver and return its result, or return
+      0 if not defined
+
   int pm_generic_resume(struct device *dev);
     - invoke the ->resume() callback provided by the driver of this device and,
       if successful, change the device's runtime PM status to 'active'
 
+  int pm_generic_resume_noirq(struct device *dev);
+    - invoke the ->resume_noirq() callback provided by the driver of this device
+
   int pm_generic_freeze(struct device *dev);
     - if the device has not been suspended at run time, invoke the ->freeze()
       callback provided by its driver and return its result, or return 0 if not
       defined
 
+  int pm_generic_freeze_noirq(struct device *dev);
+    - if pm_runtime_suspended(dev) returns "false", invoke the ->freeze_noirq()
+      callback provided by the device's driver and return its result, or return
+      0 if not defined
+
   int pm_generic_thaw(struct device *dev);
     - if the device has not been suspended at run time, invoke the ->thaw()
       callback provided by its driver and return its result, or return 0 if not
       defined
 
+  int pm_generic_thaw_noirq(struct device *dev);
+    - if pm_runtime_suspended(dev) returns "false", invoke the ->thaw_noirq()
+      callback provided by the device's driver and return its result, or return
+      0 if not defined
+
   int pm_generic_poweroff(struct device *dev);
     - if the device has not been suspended at run time, invoke the ->poweroff()
       callback provided by its driver and return its result, or return 0 if not
       defined
 
+  int pm_generic_poweroff_noirq(struct device *dev);
+    - if pm_runtime_suspended(dev) returns "false", run the ->poweroff_noirq()
+      callback provided by the device's driver and return its result, or return
+      0 if not defined
+
   int pm_generic_restore(struct device *dev);
     - invoke the ->restore() callback provided by the driver of this device and,
       if successful, change the device's runtime PM status to 'active'
 
+  int pm_generic_restore_noirq(struct device *dev);
+    - invoke the ->restore_noirq() callback provided by the device's driver
+
 These functions can be assigned to the ->runtime_idle(), ->runtime_suspend(),
-->runtime_resume(), ->suspend(), ->resume(), ->freeze(), ->thaw(), ->poweroff(),
-or ->restore() callback pointers in the subsystem-level dev_pm_ops structures.
+->runtime_resume(), ->suspend(), ->suspend_noirq(), ->resume(),
+->resume_noirq(), ->freeze(), ->freeze_noirq(), ->thaw(), ->thaw_noirq(),
+->poweroff(), ->poweroff_noirq(), ->restore(), ->restore_noirq() callback
+pointers in the subsystem-level dev_pm_ops structures.
 
 If a subsystem wishes to use all of them at the same time, it can simply assign
 the GENERIC_SUBSYS_PM_OPS macro, defined in include/linux/pm.h, to its

