Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab1DXVpx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 17:45:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47234 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757880Ab1DXVoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 17:44:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 2/9] PM: Export platform bus type's default PM callbacks
Date: Sun, 24 Apr 2011 23:37:31 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>
References: <201104130205.26988.rjw@sisk.pl> <201104170135.19388.rjw@sisk.pl> <201104242330.13607.rjw@sisk.pl>
In-Reply-To: <201104242330.13607.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104242337.31524.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Export the default PM callbacks defined for the platform bus type so
that they can be used by power domains for suspending and resuming
platform devices in the future.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/platform.c         |   72 ++++++++++------------------------------
 include/linux/platform_device.h |   60 +++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+), 54 deletions(-)

Index: linux-2.6/drivers/base/platform.c
===================================================================
--- linux-2.6.orig/drivers/base/platform.c
+++ linux-2.6/drivers/base/platform.c
@@ -667,7 +667,7 @@ static int platform_legacy_resume(struct
 	return ret;
 }
 
-static int platform_pm_prepare(struct device *dev)
+int platform_pm_prepare(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
@@ -678,7 +678,7 @@ static int platform_pm_prepare(struct de
 	return ret;
 }
 
-static void platform_pm_complete(struct device *dev)
+void platform_pm_complete(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
 
@@ -686,16 +686,11 @@ static void platform_pm_complete(struct
 		drv->pm->complete(dev);
 }
 
-#else /* !CONFIG_PM_SLEEP */
-
-#define platform_pm_prepare		NULL
-#define platform_pm_complete		NULL
-
-#endif /* !CONFIG_PM_SLEEP */
+#endif /* CONFIG_PM_SLEEP */
 
 #ifdef CONFIG_SUSPEND
 
-int __weak platform_pm_suspend(struct device *dev)
+int platform_pm_suspend(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
@@ -713,7 +708,7 @@ int __weak platform_pm_suspend(struct de
 	return ret;
 }
 
-int __weak platform_pm_suspend_noirq(struct device *dev)
+int platform_pm_suspend_noirq(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
@@ -729,7 +724,7 @@ int __weak platform_pm_suspend_noirq(str
 	return ret;
 }
 
-int __weak platform_pm_resume(struct device *dev)
+int platform_pm_resume(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
@@ -747,7 +742,7 @@ int __weak platform_pm_resume(struct dev
 	return ret;
 }
 
-int __weak platform_pm_resume_noirq(struct device *dev)
+int platform_pm_resume_noirq(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
@@ -763,18 +758,11 @@ int __weak platform_pm_resume_noirq(stru
 	return ret;
 }
 
-#else /* !CONFIG_SUSPEND */
-
-#define platform_pm_suspend		NULL
-#define platform_pm_resume		NULL
-#define platform_pm_suspend_noirq	NULL
-#define platform_pm_resume_noirq	NULL
-
-#endif /* !CONFIG_SUSPEND */
+#endif /* CONFIG_SUSPEND */
 
 #ifdef CONFIG_HIBERNATE_CALLBACKS
 
-static int platform_pm_freeze(struct device *dev)
+int platform_pm_freeze(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
@@ -792,7 +780,7 @@ static int platform_pm_freeze(struct dev
 	return ret;
 }
 
-static int platform_pm_freeze_noirq(struct device *dev)
+int platform_pm_freeze_noirq(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
@@ -808,7 +796,7 @@ static int platform_pm_freeze_noirq(stru
 	return ret;
 }
 
-static int platform_pm_thaw(struct device *dev)
+int platform_pm_thaw(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
@@ -826,7 +814,7 @@ static int platform_pm_thaw(struct devic
 	return ret;
 }
 
-static int platform_pm_thaw_noirq(struct device *dev)
+int platform_pm_thaw_noirq(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
@@ -842,7 +830,7 @@ static int platform_pm_thaw_noirq(struct
 	return ret;
 }
 
-static int platform_pm_poweroff(struct device *dev)
+int platform_pm_poweroff(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
@@ -860,7 +848,7 @@ static int platform_pm_poweroff(struct d
 	return ret;
 }
 
-static int platform_pm_poweroff_noirq(struct device *dev)
+int platform_pm_poweroff_noirq(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
@@ -876,7 +864,7 @@ static int platform_pm_poweroff_noirq(st
 	return ret;
 }
 
-static int platform_pm_restore(struct device *dev)
+int platform_pm_restore(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
@@ -894,7 +882,7 @@ static int platform_pm_restore(struct de
 	return ret;
 }
 
-static int platform_pm_restore_noirq(struct device *dev)
+int platform_pm_restore_noirq(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
@@ -910,18 +898,7 @@ static int platform_pm_restore_noirq(str
 	return ret;
 }
 
-#else /* !CONFIG_HIBERNATE_CALLBACKS */
-
-#define platform_pm_freeze		NULL
-#define platform_pm_thaw		NULL
-#define platform_pm_poweroff		NULL
-#define platform_pm_restore		NULL
-#define platform_pm_freeze_noirq	NULL
-#define platform_pm_thaw_noirq		NULL
-#define platform_pm_poweroff_noirq	NULL
-#define platform_pm_restore_noirq	NULL
-
-#endif /* !CONFIG_HIBERNATE_CALLBACKS */
+#endif /* CONFIG_HIBERNATE_CALLBACKS */
 
 #ifdef CONFIG_PM_RUNTIME
 
@@ -949,23 +926,10 @@ int __weak platform_pm_runtime_idle(stru
 #endif /* !CONFIG_PM_RUNTIME */
 
 static const struct dev_pm_ops platform_dev_pm_ops = {
-	.prepare = platform_pm_prepare,
-	.complete = platform_pm_complete,
-	.suspend = platform_pm_suspend,
-	.resume = platform_pm_resume,
-	.freeze = platform_pm_freeze,
-	.thaw = platform_pm_thaw,
-	.poweroff = platform_pm_poweroff,
-	.restore = platform_pm_restore,
-	.suspend_noirq = platform_pm_suspend_noirq,
-	.resume_noirq = platform_pm_resume_noirq,
-	.freeze_noirq = platform_pm_freeze_noirq,
-	.thaw_noirq = platform_pm_thaw_noirq,
-	.poweroff_noirq = platform_pm_poweroff_noirq,
-	.restore_noirq = platform_pm_restore_noirq,
 	.runtime_suspend = platform_pm_runtime_suspend,
 	.runtime_resume = platform_pm_runtime_resume,
 	.runtime_idle = platform_pm_runtime_idle,
+	USE_PLATFORM_PM_SLEEP_OPS
 };
 
 struct bus_type platform_bus_type = {
Index: linux-2.6/include/linux/platform_device.h
===================================================================
--- linux-2.6.orig/include/linux/platform_device.h
+++ linux-2.6/include/linux/platform_device.h
@@ -205,4 +205,64 @@ static inline char *early_platform_drive
 }
 #endif /* MODULE */
 
+#ifdef CONFIG_PM_SLEEP
+extern int platform_pm_prepare(struct device *dev);
+extern void platform_pm_complete(struct device *dev);
+#else
+#define platform_pm_prepare	NULL
+#define platform_pm_complete	NULL
+#endif
+
+#ifdef CONFIG_SUSPEND
+extern int platform_pm_suspend(struct device *dev);
+extern int platform_pm_suspend_noirq(struct device *dev);
+extern int platform_pm_resume(struct device *dev);
+extern int platform_pm_resume_noirq(struct device *dev);
+#else
+#define platform_pm_suspend		NULL
+#define platform_pm_resume		NULL
+#define platform_pm_suspend_noirq	NULL
+#define platform_pm_resume_noirq	NULL
+#endif
+
+#ifdef CONFIG_HIBERNATE_CALLBACKS
+extern int platform_pm_freeze(struct device *dev);
+extern int platform_pm_freeze_noirq(struct device *dev);
+extern int platform_pm_thaw(struct device *dev);
+extern int platform_pm_thaw_noirq(struct device *dev);
+extern int platform_pm_poweroff(struct device *dev);
+extern int platform_pm_poweroff_noirq(struct device *dev);
+extern int platform_pm_restore(struct device *dev);
+extern int platform_pm_restore_noirq(struct device *dev);
+#else
+#define platform_pm_freeze		NULL
+#define platform_pm_thaw		NULL
+#define platform_pm_poweroff		NULL
+#define platform_pm_restore		NULL
+#define platform_pm_freeze_noirq	NULL
+#define platform_pm_thaw_noirq		NULL
+#define platform_pm_poweroff_noirq	NULL
+#define platform_pm_restore_noirq	NULL
+#endif
+
+#ifdef CONFIG_PM_SLEEP
+#define USE_PLATFORM_PM_SLEEP_OPS \
+	.prepare = platform_pm_prepare, \
+	.complete = platform_pm_complete, \
+	.suspend = platform_pm_suspend, \
+	.resume = platform_pm_resume, \
+	.freeze = platform_pm_freeze, \
+	.thaw = platform_pm_thaw, \
+	.poweroff = platform_pm_poweroff, \
+	.restore = platform_pm_restore, \
+	.suspend_noirq = platform_pm_suspend_noirq, \
+	.resume_noirq = platform_pm_resume_noirq, \
+	.freeze_noirq = platform_pm_freeze_noirq, \
+	.thaw_noirq = platform_pm_thaw_noirq, \
+	.poweroff_noirq = platform_pm_poweroff_noirq, \
+	.restore_noirq = platform_pm_restore_noirq,
+#else
+#define USE_PLATFORM_PM_SLEEP_OPS
+#endif
+
 #endif /* _PLATFORM_DEVICE_H_ */

