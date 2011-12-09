Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab1LIXV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 18:21:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51387 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890Ab1LIXVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 18:21:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 3/4] PM / Sleep: Remove forward-only callbacks from platform bus type
Date: Sat, 10 Dec 2011 00:21:48 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
References: <201112100018.38536.rjw@sisk.pl>
In-Reply-To: <201112100018.38536.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112100021.48275.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The forward-only PM callbacks provided by the platform bus type are
not necessary any more, because the PM core executes driver callbacks
when the corresponding subsystem callbacks are not present, so drop
them.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/platform.c         |  115 ----------------------------------------
 include/linux/platform_device.h |   30 ----------
 2 files changed, 1 insertion(+), 144 deletions(-)

Index: linux/drivers/base/platform.c
===================================================================
--- linux.orig/drivers/base/platform.c
+++ linux/drivers/base/platform.c
@@ -700,25 +700,6 @@ static int platform_legacy_resume(struct
 	return ret;
 }
 
-int platform_pm_prepare(struct device *dev)
-{
-	struct device_driver *drv = dev->driver;
-	int ret = 0;
-
-	if (drv && drv->pm && drv->pm->prepare)
-		ret = drv->pm->prepare(dev);
-
-	return ret;
-}
-
-void platform_pm_complete(struct device *dev)
-{
-	struct device_driver *drv = dev->driver;
-
-	if (drv && drv->pm && drv->pm->complete)
-		drv->pm->complete(dev);
-}
-
 #endif /* CONFIG_PM_SLEEP */
 
 #ifdef CONFIG_SUSPEND
@@ -741,22 +722,6 @@ int platform_pm_suspend(struct device *d
 	return ret;
 }
 
-int platform_pm_suspend_noirq(struct device *dev)
-{
-	struct device_driver *drv = dev->driver;
-	int ret = 0;
-
-	if (!drv)
-		return 0;
-
-	if (drv->pm) {
-		if (drv->pm->suspend_noirq)
-			ret = drv->pm->suspend_noirq(dev);
-	}
-
-	return ret;
-}
-
 int platform_pm_resume(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
@@ -775,22 +740,6 @@ int platform_pm_resume(struct device *de
 	return ret;
 }
 
-int platform_pm_resume_noirq(struct device *dev)
-{
-	struct device_driver *drv = dev->driver;
-	int ret = 0;
-
-	if (!drv)
-		return 0;
-
-	if (drv->pm) {
-		if (drv->pm->resume_noirq)
-			ret = drv->pm->resume_noirq(dev);
-	}
-
-	return ret;
-}
-
 #endif /* CONFIG_SUSPEND */
 
 #ifdef CONFIG_HIBERNATE_CALLBACKS
@@ -813,22 +762,6 @@ int platform_pm_freeze(struct device *de
 	return ret;
 }
 
-int platform_pm_freeze_noirq(struct device *dev)
-{
-	struct device_driver *drv = dev->driver;
-	int ret = 0;
-
-	if (!drv)
-		return 0;
-
-	if (drv->pm) {
-		if (drv->pm->freeze_noirq)
-			ret = drv->pm->freeze_noirq(dev);
-	}
-
-	return ret;
-}
-
 int platform_pm_thaw(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
@@ -847,22 +780,6 @@ int platform_pm_thaw(struct device *dev)
 	return ret;
 }
 
-int platform_pm_thaw_noirq(struct device *dev)
-{
-	struct device_driver *drv = dev->driver;
-	int ret = 0;
-
-	if (!drv)
-		return 0;
-
-	if (drv->pm) {
-		if (drv->pm->thaw_noirq)
-			ret = drv->pm->thaw_noirq(dev);
-	}
-
-	return ret;
-}
-
 int platform_pm_poweroff(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
@@ -881,22 +798,6 @@ int platform_pm_poweroff(struct device *
 	return ret;
 }
 
-int platform_pm_poweroff_noirq(struct device *dev)
-{
-	struct device_driver *drv = dev->driver;
-	int ret = 0;
-
-	if (!drv)
-		return 0;
-
-	if (drv->pm) {
-		if (drv->pm->poweroff_noirq)
-			ret = drv->pm->poweroff_noirq(dev);
-	}
-
-	return ret;
-}
-
 int platform_pm_restore(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
@@ -913,22 +814,6 @@ int platform_pm_restore(struct device *d
 	}
 
 	return ret;
-}
-
-int platform_pm_restore_noirq(struct device *dev)
-{
-	struct device_driver *drv = dev->driver;
-	int ret = 0;
-
-	if (!drv)
-		return 0;
-
-	if (drv->pm) {
-		if (drv->pm->restore_noirq)
-			ret = drv->pm->restore_noirq(dev);
-	}
-
-	return ret;
 }
 
 #endif /* CONFIG_HIBERNATE_CALLBACKS */
Index: linux/include/linux/platform_device.h
===================================================================
--- linux.orig/include/linux/platform_device.h
+++ linux/include/linux/platform_device.h
@@ -264,62 +264,34 @@ static inline char *early_platform_drive
 }
 #endif /* MODULE */
 
-#ifdef CONFIG_PM_SLEEP
-extern int platform_pm_prepare(struct device *dev);
-extern void platform_pm_complete(struct device *dev);
-#else
-#define platform_pm_prepare	NULL
-#define platform_pm_complete	NULL
-#endif
-
 #ifdef CONFIG_SUSPEND
 extern int platform_pm_suspend(struct device *dev);
-extern int platform_pm_suspend_noirq(struct device *dev);
 extern int platform_pm_resume(struct device *dev);
-extern int platform_pm_resume_noirq(struct device *dev);
 #else
 #define platform_pm_suspend		NULL
 #define platform_pm_resume		NULL
-#define platform_pm_suspend_noirq	NULL
-#define platform_pm_resume_noirq	NULL
 #endif
 
 #ifdef CONFIG_HIBERNATE_CALLBACKS
 extern int platform_pm_freeze(struct device *dev);
-extern int platform_pm_freeze_noirq(struct device *dev);
 extern int platform_pm_thaw(struct device *dev);
-extern int platform_pm_thaw_noirq(struct device *dev);
 extern int platform_pm_poweroff(struct device *dev);
-extern int platform_pm_poweroff_noirq(struct device *dev);
 extern int platform_pm_restore(struct device *dev);
-extern int platform_pm_restore_noirq(struct device *dev);
 #else
 #define platform_pm_freeze		NULL
 #define platform_pm_thaw		NULL
 #define platform_pm_poweroff		NULL
 #define platform_pm_restore		NULL
-#define platform_pm_freeze_noirq	NULL
-#define platform_pm_thaw_noirq		NULL
-#define platform_pm_poweroff_noirq	NULL
-#define platform_pm_restore_noirq	NULL
 #endif
 
 #ifdef CONFIG_PM_SLEEP
 #define USE_PLATFORM_PM_SLEEP_OPS \
-	.prepare = platform_pm_prepare, \
-	.complete = platform_pm_complete, \
 	.suspend = platform_pm_suspend, \
 	.resume = platform_pm_resume, \
 	.freeze = platform_pm_freeze, \
 	.thaw = platform_pm_thaw, \
 	.poweroff = platform_pm_poweroff, \
-	.restore = platform_pm_restore, \
-	.suspend_noirq = platform_pm_suspend_noirq, \
-	.resume_noirq = platform_pm_resume_noirq, \
-	.freeze_noirq = platform_pm_freeze_noirq, \
-	.thaw_noirq = platform_pm_thaw_noirq, \
-	.poweroff_noirq = platform_pm_poweroff_noirq, \
-	.restore_noirq = platform_pm_restore_noirq,
+	.restore = platform_pm_restore,
 #else
 #define USE_PLATFORM_PM_SLEEP_OPS
 #endif

