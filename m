Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab1LIXV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 18:21:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51378 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155Ab1LIXVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 18:21:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 4/4] PM / Sleep: Remove forward-only callbacks from AMBA bus type
Date: Sat, 10 Dec 2011 00:23:37 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
References: <201112100018.38536.rjw@sisk.pl>
In-Reply-To: <201112100018.38536.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112100023.37684.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The forward-only PM callbacks provided by the AMBA bus type are not
necessary any more, because the PM core executes driver callbacks
when the corresponding subsystem callbacks are not present, so drop
them.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/amba/bus.c |  136 -----------------------------------------------------
 1 file changed, 1 insertion(+), 135 deletions(-)

Index: linux/drivers/amba/bus.c
===================================================================
--- linux.orig/drivers/amba/bus.c
+++ linux/drivers/amba/bus.c
@@ -109,31 +109,7 @@ static int amba_legacy_resume(struct dev
 	return ret;
 }
 
-static int amba_pm_prepare(struct device *dev)
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
-static void amba_pm_complete(struct device *dev)
-{
-	struct device_driver *drv = dev->driver;
-
-	if (drv && drv->pm && drv->pm->complete)
-		drv->pm->complete(dev);
-}
-
-#else /* !CONFIG_PM_SLEEP */
-
-#define amba_pm_prepare		NULL
-#define amba_pm_complete		NULL
-
-#endif /* !CONFIG_PM_SLEEP */
+#endif /* CONFIG_PM_SLEEP */
 
 #ifdef CONFIG_SUSPEND
 
@@ -155,22 +131,6 @@ static int amba_pm_suspend(struct device
 	return ret;
 }
 
-static int amba_pm_suspend_noirq(struct device *dev)
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
 static int amba_pm_resume(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
@@ -189,28 +149,10 @@ static int amba_pm_resume(struct device
 	return ret;
 }
 
-static int amba_pm_resume_noirq(struct device *dev)
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
 #else /* !CONFIG_SUSPEND */
 
 #define amba_pm_suspend		NULL
 #define amba_pm_resume		NULL
-#define amba_pm_suspend_noirq	NULL
-#define amba_pm_resume_noirq	NULL
 
 #endif /* !CONFIG_SUSPEND */
 
@@ -234,22 +176,6 @@ static int amba_pm_freeze(struct device
 	return ret;
 }
 
-static int amba_pm_freeze_noirq(struct device *dev)
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
 static int amba_pm_thaw(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
@@ -268,22 +194,6 @@ static int amba_pm_thaw(struct device *d
 	return ret;
 }
 
-static int amba_pm_thaw_noirq(struct device *dev)
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
 static int amba_pm_poweroff(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
@@ -302,22 +212,6 @@ static int amba_pm_poweroff(struct devic
 	return ret;
 }
 
-static int amba_pm_poweroff_noirq(struct device *dev)
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
 static int amba_pm_restore(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
@@ -336,32 +230,12 @@ static int amba_pm_restore(struct device
 	return ret;
 }
 
-static int amba_pm_restore_noirq(struct device *dev)
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
-}
-
 #else /* !CONFIG_HIBERNATE_CALLBACKS */
 
 #define amba_pm_freeze		NULL
 #define amba_pm_thaw		NULL
 #define amba_pm_poweroff		NULL
 #define amba_pm_restore		NULL
-#define amba_pm_freeze_noirq	NULL
-#define amba_pm_thaw_noirq		NULL
-#define amba_pm_poweroff_noirq	NULL
-#define amba_pm_restore_noirq	NULL
 
 #endif /* !CONFIG_HIBERNATE_CALLBACKS */
 
@@ -402,20 +276,12 @@ static int amba_pm_runtime_resume(struct
 #ifdef CONFIG_PM
 
 static const struct dev_pm_ops amba_pm = {
-	.prepare	= amba_pm_prepare,
-	.complete	= amba_pm_complete,
 	.suspend	= amba_pm_suspend,
 	.resume		= amba_pm_resume,
 	.freeze		= amba_pm_freeze,
 	.thaw		= amba_pm_thaw,
 	.poweroff	= amba_pm_poweroff,
 	.restore	= amba_pm_restore,
-	.suspend_noirq	= amba_pm_suspend_noirq,
-	.resume_noirq	= amba_pm_resume_noirq,
-	.freeze_noirq	= amba_pm_freeze_noirq,
-	.thaw_noirq	= amba_pm_thaw_noirq,
-	.poweroff_noirq	= amba_pm_poweroff_noirq,
-	.restore_noirq	= amba_pm_restore_noirq,
 	SET_RUNTIME_PM_OPS(
 		amba_pm_runtime_suspend,
 		amba_pm_runtime_resume,

