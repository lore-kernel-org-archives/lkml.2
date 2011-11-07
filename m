Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab1KGAIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 19:08:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53722 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab1KGAIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 19:08:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 4/7] PM / Domains: Rework system suspend callback routines
Date: Mon, 7 Nov 2011 01:08:11 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Kevin Hilman <khilman@ti.com>, jean.pihet@newoldbits.com
References: <201111070101.33960.rjw@sisk.pl>
In-Reply-To: <201111070101.33960.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111070108.11727.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The current generic PM domains code attempts to use the generic
system suspend operations along with the domains' device stop/start
routines, which requires device drivers to assume that their
system suspend/resume (and hibernation/restore) callbacks will always
be used with generic PM domains.  However, in theory, the same
hardware may be used in devices that don't belong to any PM domain,
in which case it would be necessary to add "fake" PM domains to
satisfy the above assumption.  Also, the domain the hardware belongs
to may not be handled with the help of the generic code.

To allow device drivers that may be used along with the generic PM
domains code of more flexibility, add new device callbacks, .freeze(),
.freeze_late(), .thaw_early() and .thaw(), that can be supplied by
the drivers in addition to their "standard" system suspend and
hibernation callbacks.  These new callbacks, if defined, will be used
by the generic PM domains code for the handling of system suspend and
hibernation instead of the "standard" ones.  This will allow drivers
to be designed to work with generic PM domains as well as without
them.

For backwards compatibility, introduce default .freeze(), .thaw(),
.freeze_late() and .thaw_early() callback routines for PM domains that
will execute pm_generic_suspend(), pm_generic_resume(),
pm_generic_suspend_noirq() and pm_generic_resume_noirq(),
respectively, for the given device if its driver doesn't provide its
own implementations of .freeze(), .thaw(), .freeze_late() and
.thaw_early() (this works slightly differently from the current code,
but its existing users don't care anyway).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |  189 +++++++++++++++++++-------------------------
 include/linux/pm_domain.h   |    4 
 2 files changed, 87 insertions(+), 106 deletions(-)

Index: linux/include/linux/pm_domain.h
===================================================================
--- linux.orig/include/linux/pm_domain.h
+++ linux/include/linux/pm_domain.h
@@ -28,6 +28,10 @@ struct gpd_dev_ops {
 	int (*stop)(struct device *dev);
 	int (*save_state)(struct device *dev);
 	int (*restore_state)(struct device *dev);
+	int (*freeze)(struct device *dev);
+	int (*freeze_late)(struct device *dev);
+	int (*thaw_early)(struct device *dev);
+	int (*thaw)(struct device *dev);
 	bool (*active_wakeup)(struct device *dev);
 };
 
Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -560,6 +560,26 @@ static bool genpd_dev_active_wakeup(stru
 	return GENPD_DEV_CALLBACK(genpd, bool, active_wakeup, dev);
 }
 
+static int genpd_freeze_dev(struct generic_pm_domain *genpd, struct device *dev)
+{
+	return GENPD_DEV_CALLBACK(genpd, int, freeze, dev);
+}
+
+static int genpd_freeze_late(struct generic_pm_domain *genpd, struct device *dev)
+{
+	return GENPD_DEV_CALLBACK(genpd, int, freeze_late, dev);
+}
+
+static int genpd_thaw_early(struct generic_pm_domain *genpd, struct device *dev)
+{
+	return GENPD_DEV_CALLBACK(genpd, int, thaw_early, dev);
+}
+
+static int genpd_thaw_dev(struct generic_pm_domain *genpd, struct device *dev)
+{
+	return GENPD_DEV_CALLBACK(genpd, int, thaw, dev);
+}
+
 /**
  * pm_genpd_sync_poweroff - Synchronously power off a PM domain and its masters.
  * @genpd: PM domain to power off, if possible.
@@ -694,27 +714,6 @@ static int pm_genpd_prepare(struct devic
 }
 
 /**
- * pm_genpd_suspend - Suspend a device belonging to an I/O PM domain.
- * @dev: Device to suspend.
- *
- * Suspend a device under the assumption that its pm_domain field points to the
- * domain member of an object of type struct generic_pm_domain representing
- * a PM domain consisting of I/O devices.
- */
-static int pm_genpd_suspend(struct device *dev)
-{
-	struct generic_pm_domain *genpd;
-
-	dev_dbg(dev, "%s()\n", __func__);
-
-	genpd = dev_to_genpd(dev);
-	if (IS_ERR(genpd))
-		return -EINVAL;
-
-	return genpd->suspend_power_off ? 0 : pm_generic_suspend(dev);
-}
-
-/**
  * pm_genpd_suspend_noirq - Late suspend of a device from an I/O PM domain.
  * @dev: Device to suspend.
  *
@@ -736,7 +735,7 @@ static int pm_genpd_suspend_noirq(struct
 	if (genpd->suspend_power_off)
 		return 0;
 
-	ret = pm_generic_suspend_noirq(dev);
+	ret = genpd_freeze_late(genpd, dev);
 	if (ret)
 		return ret;
 
@@ -787,28 +786,7 @@ static int pm_genpd_resume_noirq(struct
 	genpd->suspended_count--;
 	genpd_start_dev(genpd, dev);
 
-	return pm_generic_resume_noirq(dev);
-}
-
-/**
- * pm_genpd_resume - Resume a device belonging to an I/O power domain.
- * @dev: Device to resume.
- *
- * Resume a device under the assumption that its pm_domain field points to the
- * domain member of an object of type struct generic_pm_domain representing
- * a power domain consisting of I/O devices.
- */
-static int pm_genpd_resume(struct device *dev)
-{
-	struct generic_pm_domain *genpd;
-
-	dev_dbg(dev, "%s()\n", __func__);
-
-	genpd = dev_to_genpd(dev);
-	if (IS_ERR(genpd))
-		return -EINVAL;
-
-	return genpd->suspend_power_off ? 0 : pm_generic_resume(dev);
+	return genpd_thaw_early(genpd, dev);
 }
 
 /**
@@ -829,14 +807,14 @@ static int pm_genpd_freeze(struct device
 	if (IS_ERR(genpd))
 		return -EINVAL;
 
-	return genpd->suspend_power_off ? 0 : pm_generic_freeze(dev);
+	return genpd->suspend_power_off ? 0 : genpd_freeze_dev(genpd, dev);
 }
 
 /**
  * pm_genpd_freeze_noirq - Late freeze of a device from an I/O power domain.
  * @dev: Device to freeze.
  *
- * Carry out a late freeze of a device under the assumption that its
+ * Carry out a late "freeze" of a device under the assumption that its
  * pm_domain field points to the domain member of an object of type
  * struct generic_pm_domain representing a power domain consisting of I/O
  * devices.
@@ -855,7 +833,7 @@ static int pm_genpd_freeze_noirq(struct
 	if (genpd->suspend_power_off)
 		return 0;
 
-	ret = pm_generic_freeze_noirq(dev);
+	ret = genpd_freeze_late(genpd, dev);
 	if (ret)
 		return ret;
 
@@ -868,7 +846,7 @@ static int pm_genpd_freeze_noirq(struct
  * pm_genpd_thaw_noirq - Early thaw of a device from an I/O power domain.
  * @dev: Device to thaw.
  *
- * Carry out an early thaw of a device under the assumption that its
+ * Carry out an early "thaw" of a device under the assumption that its
  * pm_domain field points to the domain member of an object of type
  * struct generic_pm_domain representing a power domain consisting of I/O
  * devices.
@@ -888,7 +866,7 @@ static int pm_genpd_thaw_noirq(struct de
 
 	genpd_start_dev(genpd, dev);
 
-	return pm_generic_thaw_noirq(dev);
+	return genpd_thaw_early(genpd, dev);
 }
 
 /**
@@ -909,28 +887,7 @@ static int pm_genpd_thaw(struct device *
 	if (IS_ERR(genpd))
 		return -EINVAL;
 
-	return genpd->suspend_power_off ? 0 : pm_generic_thaw(dev);
-}
-
-/**
- * pm_genpd_dev_poweroff - Power off a device belonging to an I/O PM domain.
- * @dev: Device to suspend.
- *
- * Power off a device under the assumption that its pm_domain field points to
- * the domain member of an object of type struct generic_pm_domain representing
- * a PM domain consisting of I/O devices.
- */
-static int pm_genpd_dev_poweroff(struct device *dev)
-{
-	struct generic_pm_domain *genpd;
-
-	dev_dbg(dev, "%s()\n", __func__);
-
-	genpd = dev_to_genpd(dev);
-	if (IS_ERR(genpd))
-		return -EINVAL;
-
-	return genpd->suspend_power_off ? 0 : pm_generic_poweroff(dev);
+	return genpd->suspend_power_off ? 0 : genpd_thaw_dev(genpd, dev);
 }
 
 /**
@@ -944,7 +901,6 @@ static int pm_genpd_dev_poweroff(struct
 static int pm_genpd_dev_poweroff_noirq(struct device *dev)
 {
 	struct generic_pm_domain *genpd;
-	int ret;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
@@ -955,10 +911,6 @@ static int pm_genpd_dev_poweroff_noirq(s
 	if (genpd->suspend_power_off)
 		return 0;
 
-	ret = pm_generic_poweroff_noirq(dev);
-	if (ret)
-		return ret;
-
 	if (dev->power.wakeup_path && genpd_dev_active_wakeup(genpd, dev))
 		return 0;
 
@@ -1014,28 +966,7 @@ static int pm_genpd_restore_noirq(struct
 	genpd->suspended_count--;
 	genpd_start_dev(genpd, dev);
 
-	return pm_generic_restore_noirq(dev);
-}
-
-/**
- * pm_genpd_restore - Restore a device belonging to an I/O power domain.
- * @dev: Device to resume.
- *
- * Restore a device under the assumption that its pm_domain field points to the
- * domain member of an object of type struct generic_pm_domain representing
- * a power domain consisting of I/O devices.
- */
-static int pm_genpd_restore(struct device *dev)
-{
-	struct generic_pm_domain *genpd;
-
-	dev_dbg(dev, "%s()\n", __func__);
-
-	genpd = dev_to_genpd(dev);
-	if (IS_ERR(genpd))
-		return -EINVAL;
-
-	return genpd->suspend_power_off ? 0 : pm_generic_restore(dev);
+	return genpd_thaw_early(genpd, dev);
 }
 
 /**
@@ -1077,18 +1008,14 @@ static void pm_genpd_complete(struct dev
 #else
 
 #define pm_genpd_prepare		NULL
-#define pm_genpd_suspend		NULL
 #define pm_genpd_suspend_noirq		NULL
 #define pm_genpd_resume_noirq		NULL
-#define pm_genpd_resume			NULL
 #define pm_genpd_freeze			NULL
 #define pm_genpd_freeze_noirq		NULL
 #define pm_genpd_thaw_noirq		NULL
 #define pm_genpd_thaw			NULL
 #define pm_genpd_dev_poweroff_noirq	NULL
-#define pm_genpd_dev_poweroff		NULL
 #define pm_genpd_restore_noirq		NULL
-#define pm_genpd_restore		NULL
 #define pm_genpd_complete		NULL
 
 #endif /* CONFIG_PM_SLEEP */
@@ -1354,6 +1281,8 @@ int pm_genpd_remove_callbacks(struct dev
 }
 EXPORT_SYMBOL_GPL(pm_genpd_remove_callbacks);
 
+/* Default device callbacks for generic PM domains. */
+
 /**
  * pm_genpd_default_save_state - Default "save device state" for PM domians.
  * @dev: Device to handle.
@@ -1393,6 +1322,50 @@ static int pm_genpd_default_restore_stat
 }
 
 /**
+ * pm_genpd_default_freeze - Default "device freeze" for PM domians.
+ * @dev: Device to handle.
+ */
+static int pm_genpd_default_freeze(struct device *dev)
+{
+	int (*cb)(struct device *__dev) = dev_gpd_data(dev)->ops.freeze;
+
+	return cb ? cb(dev) : pm_generic_suspend(dev);
+}
+
+/**
+ * pm_genpd_default_freeze_late - Default "late device freeze" for PM domians.
+ * @dev: Device to handle.
+ */
+static int pm_genpd_default_freeze_late(struct device *dev)
+{
+	int (*cb)(struct device *__dev) = dev_gpd_data(dev)->ops.freeze_late;
+
+	return cb ? cb(dev) : pm_generic_suspend_noirq(dev);
+}
+
+/**
+ * pm_genpd_default_thaw_early - Default "early device thaw" for PM domians.
+ * @dev: Device to handle.
+ */
+static int pm_genpd_default_thaw_early(struct device *dev)
+{
+	int (*cb)(struct device *__dev) = dev_gpd_data(dev)->ops.thaw_early;
+
+	return cb ? cb(dev) : pm_generic_resume_noirq(dev);
+}
+
+/**
+ * pm_genpd_default_thaw - Default "device thaw" for PM domians.
+ * @dev: Device to handle.
+ */
+static int pm_genpd_default_thaw(struct device *dev)
+{
+	int (*cb)(struct device *__dev) = dev_gpd_data(dev)->ops.thaw;
+
+	return cb ? cb(dev) : pm_generic_resume(dev);
+}
+
+/**
  * pm_genpd_init - Initialize a generic I/O PM domain object.
  * @genpd: PM domain object to initialize.
  * @gov: PM domain governor to associate with the domain (may be NULL).
@@ -1422,21 +1395,25 @@ void pm_genpd_init(struct generic_pm_dom
 	genpd->domain.ops.runtime_resume = pm_genpd_runtime_resume;
 	genpd->domain.ops.runtime_idle = pm_generic_runtime_idle;
 	genpd->domain.ops.prepare = pm_genpd_prepare;
-	genpd->domain.ops.suspend = pm_genpd_suspend;
+	genpd->domain.ops.suspend = pm_genpd_freeze;
 	genpd->domain.ops.suspend_noirq = pm_genpd_suspend_noirq;
 	genpd->domain.ops.resume_noirq = pm_genpd_resume_noirq;
-	genpd->domain.ops.resume = pm_genpd_resume;
+	genpd->domain.ops.resume = pm_genpd_thaw;
 	genpd->domain.ops.freeze = pm_genpd_freeze;
 	genpd->domain.ops.freeze_noirq = pm_genpd_freeze_noirq;
 	genpd->domain.ops.thaw_noirq = pm_genpd_thaw_noirq;
 	genpd->domain.ops.thaw = pm_genpd_thaw;
-	genpd->domain.ops.poweroff = pm_genpd_dev_poweroff;
+	genpd->domain.ops.poweroff = pm_genpd_freeze;
 	genpd->domain.ops.poweroff_noirq = pm_genpd_dev_poweroff_noirq;
 	genpd->domain.ops.restore_noirq = pm_genpd_restore_noirq;
-	genpd->domain.ops.restore = pm_genpd_restore;
+	genpd->domain.ops.restore = pm_genpd_thaw;
 	genpd->domain.ops.complete = pm_genpd_complete;
 	genpd->dev_ops.save_state = pm_genpd_default_save_state;
 	genpd->dev_ops.restore_state = pm_genpd_default_restore_state;
+	genpd->dev_ops.freeze = pm_genpd_default_freeze;
+	genpd->dev_ops.freeze_late = pm_genpd_default_freeze_late;
+	genpd->dev_ops.thaw_early = pm_genpd_default_thaw_early;
+	genpd->dev_ops.thaw = pm_genpd_default_thaw;
 	mutex_lock(&gpd_list_lock);
 	list_add(&genpd->gpd_list_node, &gpd_list);
 	mutex_unlock(&gpd_list_lock);

