Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab1DNXTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 19:19:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52196 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472Ab1DNXSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 19:18:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 1/2] shmobile: Use power domains for platform runtime PM
Date: Fri, 15 Apr 2011 01:18:09 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201104130205.26988.rjw@sisk.pl> <201104150116.01634.rjw@sisk.pl>
In-Reply-To: <201104150116.01634.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104150118.10251.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

shmobile platforms replace the runtime PM callbacks of the platform
bus type with their own routines, but this means that the callbacks
are replaced system-wide.  This may not be the right approach if the
platform devices on the system are not of the same type (e.g. some
of them belong to an SoC and the others are located in separate
chips), because in those cases they may require different handling.
Thus it is better to use power domains to override the platform bus
type's PM handling, as it generally is possible to use different
power domains for devices with different PM requirements.

Define a default power domain for shmobile in both the SH and ARM
falvors and use it to override the platform bus type's PM callbacks.
Since the suspend and hibernate callbacks of the new "default" power
domains need to be the same and the platform bus type's suspend and
hibernate callbacks for the time being, export those callbacks so
that can be used outside of the platform bus type code.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/pm_runtime.c      |   38 ++++++++++++++++----
 arch/sh/kernel/cpu/shmobile/pm_runtime.c |   46 +++++++++++++++++++------
 drivers/base/platform.c                  |   57 +++++++++----------------------
 include/linux/platform_device.h          |   40 +++++++++++++++++++++
 4 files changed, 123 insertions(+), 58 deletions(-)

Index: linux-2.6/arch/arm/mach-shmobile/pm_runtime.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/pm_runtime.c
+++ linux-2.6/arch/arm/mach-shmobile/pm_runtime.c
@@ -66,11 +66,11 @@ static void platform_pm_runtime_bug(stru
 		dev_err(dev, "runtime pm suspend before resume\n");
 }
 
-int platform_pm_runtime_suspend(struct device *dev)
+static int default_platform_runtime_suspend(struct device *dev)
 {
 	struct pm_runtime_data *prd = __to_prd(dev);
 
-	dev_dbg(dev, "platform_pm_runtime_suspend()\n");
+	dev_dbg(dev, "%s()\n", __func__);
 
 	platform_pm_runtime_bug(dev, prd);
 
@@ -82,11 +82,11 @@ int platform_pm_runtime_suspend(struct d
 	return 0;
 }
 
-int platform_pm_runtime_resume(struct device *dev)
+static int default_platform_runtime_resume(struct device *dev)
 {
 	struct pm_runtime_data *prd = __to_prd(dev);
 
-	dev_dbg(dev, "platform_pm_runtime_resume()\n");
+	dev_dbg(dev, "%s()\n", __func__);
 
 	platform_pm_runtime_init(dev, prd);
 
@@ -98,12 +98,34 @@ int platform_pm_runtime_resume(struct de
 	return 0;
 }
 
-int platform_pm_runtime_idle(struct device *dev)
+static int default_platform_runtime_idle(struct device *dev)
 {
 	/* suspend synchronously to disable clocks immediately */
 	return pm_runtime_suspend(dev);
 }
 
+static struct dev_power_domain default_power_domain = {
+	.ops = {
+		.prepare = platform_pm_prepare,
+		.complete = platform_pm_complete,
+		.suspend = platform_pm_suspend,
+		.resume = platform_pm_resume,
+		.freeze = platform_pm_freeze,
+		.thaw = platform_pm_thaw,
+		.poweroff = platform_pm_poweroff,
+		.restore = platform_pm_restore,
+		.suspend_noirq = platform_pm_suspend_noirq,
+		.resume_noirq = platform_pm_resume_noirq,
+		.freeze_noirq = platform_pm_freeze_noirq,
+		.thaw_noirq = platform_pm_thaw_noirq,
+		.poweroff_noirq = platform_pm_poweroff_noirq,
+		.restore_noirq = platform_pm_restore_noirq,
+		.runtime_suspend = default_platform_runtime_suspend,
+		.runtime_resume = default_platform_runtime_resume,
+		.runtime_idle = default_platform_runtime_idle,
+	},
+};
+
 static int platform_bus_notify(struct notifier_block *nb,
 			       unsigned long action, void *data)
 {
@@ -114,10 +136,12 @@ static int platform_bus_notify(struct no
 
 	if (action == BUS_NOTIFY_BIND_DRIVER) {
 		prd = devres_alloc(__devres_release, sizeof(*prd), GFP_KERNEL);
-		if (prd)
+		if (prd) {
 			devres_add(dev, prd);
-		else
+			dev->pwr_domain = &default_power_domain;
+		} else {
 			dev_err(dev, "unable to alloc memory for runtime pm\n");
+		}
 	}
 
 	return 0;
Index: linux-2.6/arch/sh/kernel/cpu/shmobile/pm_runtime.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/cpu/shmobile/pm_runtime.c
+++ linux-2.6/arch/sh/kernel/cpu/shmobile/pm_runtime.c
@@ -139,7 +139,7 @@ void platform_pm_runtime_suspend_idle(vo
 	queue_work(pm_wq, &hwblk_work);
 }
 
-int platform_pm_runtime_suspend(struct device *dev)
+static int default_platform_runtime_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct pdev_archdata *ad = &pdev->archdata;
@@ -147,7 +147,7 @@ int platform_pm_runtime_suspend(struct d
 	int hwblk = ad->hwblk_id;
 	int ret = 0;
 
-	dev_dbg(dev, "platform_pm_runtime_suspend() [%d]\n", hwblk);
+	dev_dbg(dev, "%s() [%d]\n", __func__, hwblk);
 
 	/* ignore off-chip platform devices */
 	if (!hwblk)
@@ -183,20 +183,20 @@ int platform_pm_runtime_suspend(struct d
 	mutex_unlock(&ad->mutex);
 
 out:
-	dev_dbg(dev, "platform_pm_runtime_suspend() [%d] returns %d\n",
-		hwblk, ret);
+	dev_dbg(dev, "%s() [%d] returns %d\n",
+		 __func__, hwblk, ret);
 
 	return ret;
 }
 
-int platform_pm_runtime_resume(struct device *dev)
+static int default_platform_runtime_resume(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct pdev_archdata *ad = &pdev->archdata;
 	int hwblk = ad->hwblk_id;
 	int ret = 0;
 
-	dev_dbg(dev, "platform_pm_runtime_resume() [%d]\n", hwblk);
+	dev_dbg(dev, "%s() [%d]\n", __func__, hwblk);
 
 	/* ignore off-chip platform devices */
 	if (!hwblk)
@@ -228,19 +228,19 @@ int platform_pm_runtime_resume(struct de
 	 */
 	mutex_unlock(&ad->mutex);
 out:
-	dev_dbg(dev, "platform_pm_runtime_resume() [%d] returns %d\n",
-		hwblk, ret);
+	dev_dbg(dev, "%s() [%d] returns %d\n",
+		__func__, hwblk, ret);
 
 	return ret;
 }
 
-int platform_pm_runtime_idle(struct device *dev)
+static int default_platform_runtime_idle(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	int hwblk = pdev->archdata.hwblk_id;
 	int ret = 0;
 
-	dev_dbg(dev, "platform_pm_runtime_idle() [%d]\n", hwblk);
+	dev_dbg(dev, "%s() [%d]\n", __func__, hwblk);
 
 	/* ignore off-chip platform devices */
 	if (!hwblk)
@@ -252,10 +252,32 @@ int platform_pm_runtime_idle(struct devi
 	/* suspend synchronously to disable clocks immediately */
 	ret = pm_runtime_suspend(dev);
 out:
-	dev_dbg(dev, "platform_pm_runtime_idle() [%d] done!\n", hwblk);
+	dev_dbg(dev, "%s() [%d] done!\n", __func__, hwblk);
 	return ret;
 }
 
+static struct dev_power_domain default_power_domain = {
+	.ops = {
+		.prepare = platform_pm_prepare,
+		.complete = platform_pm_complete,
+		.suspend = platform_pm_suspend,
+		.resume = platform_pm_resume,
+		.freeze = platform_pm_freeze,
+		.thaw = platform_pm_thaw,
+		.poweroff = platform_pm_poweroff,
+		.restore = platform_pm_restore,
+		.suspend_noirq = platform_pm_suspend_noirq,
+		.resume_noirq = platform_pm_resume_noirq,
+		.freeze_noirq = platform_pm_freeze_noirq,
+		.thaw_noirq = platform_pm_thaw_noirq,
+		.poweroff_noirq = platform_pm_poweroff_noirq,
+		.restore_noirq = platform_pm_restore_noirq,
+		.runtime_suspend = default_platform_runtime_suspend,
+		.runtime_resume = default_platform_runtime_resume,
+		.runtime_idle = default_platform_runtime_idle,
+	},
+};
+
 static int platform_bus_notify(struct notifier_block *nb,
 			       unsigned long action, void *data)
 {
@@ -276,6 +298,7 @@ static int platform_bus_notify(struct no
 		hwblk_disable(hwblk_info, hwblk);
 		/* make sure driver re-inits itself once */
 		__set_bit(PDEV_ARCHDATA_FLAG_INIT, &pdev->archdata.flags);
+		dev->pwr_domain = &default_power_domain;
 		break;
 	/* TODO: add BUS_NOTIFY_BIND_DRIVER and increase idle count */
 	case BUS_NOTIFY_BOUND_DRIVER:
@@ -289,6 +312,7 @@ static int platform_bus_notify(struct no
 		__set_bit(PDEV_ARCHDATA_FLAG_INIT, &pdev->archdata.flags);
 		break;
 	case BUS_NOTIFY_DEL_DEVICE:
+		dev->pwr_domain = NULL;
 		break;
 	}
 	return 0;
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
 
Index: linux-2.6/include/linux/platform_device.h
===================================================================
--- linux-2.6.orig/include/linux/platform_device.h
+++ linux-2.6/include/linux/platform_device.h
@@ -205,4 +205,44 @@ static inline char *early_platform_drive
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
 #endif /* _PLATFORM_DEVICE_H_ */

