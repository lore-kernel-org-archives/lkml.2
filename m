Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab1EOXfV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 19:35:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53460 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065Ab1EOXeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 19:34:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 1/6] PM: Introduce generic prepare and complete callbacks for subsystems
Date: Mon, 16 May 2011 01:30:27 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201104290154.12966.rjw@sisk.pl> <201105082320.57185.rjw@sisk.pl> <201105160117.46927.rjw@sisk.pl>
In-Reply-To: <201105160117.46927.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105160130.28322.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Introduce generic .prepare() and .complete() power management
callbacks, currently missing, that can be used by subsystems and
power domains and export them.  Provide NULL definitions of all
the generic system sleep callbacks for CONFIG_PM_SLEEP unset.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/generic_ops.c |   39 +++++++++++++++++++++++++++++++++++++++
 include/linux/pm.h               |   26 +++++++++++++++++++-------
 2 files changed, 58 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/base/power/generic_ops.c
===================================================================
--- linux-2.6.orig/drivers/base/power/generic_ops.c
+++ linux-2.6/drivers/base/power/generic_ops.c
@@ -74,6 +74,23 @@ EXPORT_SYMBOL_GPL(pm_generic_runtime_res
 
 #ifdef CONFIG_PM_SLEEP
 /**
+ * pm_generic_prepare - Generic routine preparing a device for power transition.
+ * @dev: Device to prepare.
+ *
+ * Prepare a device for a system-wide power transition.
+ */
+int pm_generic_prepare(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (drv && drv->pm && drv->pm->prepare)
+		ret = drv->pm->prepare(dev);
+
+	return ret;
+}
+
+/**
  * __pm_generic_call - Generic suspend/freeze/poweroff/thaw subsystem callback.
  * @dev: Device to handle.
  * @event: PM transition of the system under way.
@@ -213,16 +230,38 @@ int pm_generic_restore(struct device *de
 	return __pm_generic_resume(dev, PM_EVENT_RESTORE);
 }
 EXPORT_SYMBOL_GPL(pm_generic_restore);
+
+/**
+ * pm_generic_complete - Generic routine competing a device power transition.
+ * @dev: Device to handle.
+ *
+ * Complete a device power transition during a system-wide power transition.
+ */
+void pm_generic_complete(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+
+	if (drv && drv->pm && drv->pm->complete)
+		drv->pm->complete(dev);
+
+	/*
+	 * Let runtime PM try to suspend devices that haven't been in use before
+	 * going into the system-wide sleep state we're resuming from.
+	 */
+	pm_runtime_idle(dev);
+}
 #endif /* CONFIG_PM_SLEEP */
 
 struct dev_pm_ops generic_subsys_pm_ops = {
 #ifdef CONFIG_PM_SLEEP
+	.prepare = pm_generic_prepare,
 	.suspend = pm_generic_suspend,
 	.resume = pm_generic_resume,
 	.freeze = pm_generic_freeze,
 	.thaw = pm_generic_thaw,
 	.poweroff = pm_generic_poweroff,
 	.restore = pm_generic_restore,
+	.complete = pm_generic_complete,
 #endif
 #ifdef CONFIG_PM_RUNTIME
 	.runtime_suspend = pm_generic_runtime_suspend,
Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -550,6 +550,16 @@ extern void __suspend_report_result(cons
 	} while (0)
 
 extern int device_pm_wait_for_dev(struct device *sub, struct device *dev);
+
+extern int pm_generic_prepare(struct device *dev);
+extern int pm_generic_suspend(struct device *dev);
+extern int pm_generic_resume(struct device *dev);
+extern int pm_generic_freeze(struct device *dev);
+extern int pm_generic_thaw(struct device *dev);
+extern int pm_generic_restore(struct device *dev);
+extern int pm_generic_poweroff(struct device *dev);
+extern void pm_generic_complete(struct device *dev);
+
 #else /* !CONFIG_PM_SLEEP */
 
 #define device_pm_lock() do {} while (0)
@@ -566,6 +576,15 @@ static inline int device_pm_wait_for_dev
 {
 	return 0;
 }
+
+#define pm_generic_prepare	NULL
+#define pm_generic_suspend	NULL
+#define pm_generic_resume	NULL
+#define pm_generic_freeze	NULL
+#define pm_generic_thaw		NULL
+#define pm_generic_restore	NULL
+#define pm_generic_poweroff	NULL
+#define pm_generic_complete	NULL
 #endif /* !CONFIG_PM_SLEEP */
 
 /* How to reorder dpm_list after device_move() */
@@ -576,11 +595,4 @@ enum dpm_order {
 	DPM_ORDER_DEV_LAST,
 };
 
-extern int pm_generic_suspend(struct device *dev);
-extern int pm_generic_resume(struct device *dev);
-extern int pm_generic_freeze(struct device *dev);
-extern int pm_generic_thaw(struct device *dev);
-extern int pm_generic_restore(struct device *dev);
-extern int pm_generic_poweroff(struct device *dev);
-
 #endif /* _LINUX_PM_H */

