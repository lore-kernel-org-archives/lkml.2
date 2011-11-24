Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab1KXASD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 19:18:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55009 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739Ab1KXASA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 19:18:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [Update 3x][PATCH 3/7] PM / Domains: Rework system suspend callback routines (v2)
Date: Thu, 24 Nov 2011 01:20:47 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Kevin Hilman <khilman@ti.com>, jean.pihet@newoldbits.com
References: <201111070101.33960.rjw@sisk.pl> <201111191456.40453.rjw@sisk.pl> <201111191459.46620.rjw@sisk.pl>
In-Reply-To: <201111191459.46620.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111240120.47716.rjw@sisk.pl>
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
domains code of more flexibility, add new device callbacks,
.suspend(), .suspend_late(), .resume_early(), .resume(), .freeze(),
.freeze_late(), .thaw_early(), and .thaw(), that can be supplied by
the drivers in addition to their "standard" system suspend and
hibernation callbacks.  These new callbacks, if defined, will be used
by the generic PM domains code for the handling of system suspend and
hibernation instead of the "standard" ones.  This will allow drivers
to be designed to work with generic PM domains as well as without
them.

For backwards compatibility, introduce default implementations of the
new callbacks for PM domains that will execute pm_generic_suspend(),
pm_generic_suspend_noirq(), pm_generic_resume_noirq(),
pm_generic_resume(), pm_generic_freeze(), pm_generic_freeze_noirq(),
pm_generic_thaw_noirq(), and pm_generic_thaw(), respectively, for the
given device if its driver doesn't define those callbacks.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

When I started to work on documentation updates, I realized that
.freeze()/.thaw() callbacks (and their late/early versions) couldn't
be used as .suspend()/.resume() for two reasons.  First, for some
devices .suspend() has to make wakeup preparations, while .freeze()
need not (and even shouldn't) do that.  Second, .resume() ususally
has to restore the device's state from memory, while .thaw() need
not (and even shouldn't) do that.  Therefore, a complete set of
suspend/resume _and_ freeze/thaw device callbacks for PM domains
is needed.

Thanks,
Rafael

---
 drivers/base/power/domain.c |  249 ++++++++++++++++++++++++++------------------
 include/linux/pm_domain.h   |    8 +
 2 files changed, 158 insertions(+), 99 deletions(-)

Index: linux/include/linux/pm_domain.h
===================================================================
--- linux.orig/include/linux/pm_domain.h
+++ linux/include/linux/pm_domain.h
@@ -28,6 +28,14 @@ struct gpd_dev_ops {
 	int (*stop)(struct device *dev);
 	int (*save_state)(struct device *dev);
 	int (*restore_state)(struct device *dev);
+	int (*suspend)(struct device *dev);
+	int (*suspend_late)(struct device *dev);
+	int (*resume_early)(struct device *dev);
+	int (*resume)(struct device *dev);
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
@@ -561,6 +561,46 @@ static bool genpd_dev_active_wakeup(stru
 	return GENPD_DEV_CALLBACK(genpd, bool, active_wakeup, dev);
 }
 
+static int genpd_suspend_dev(struct generic_pm_domain *genpd, struct device *dev)
+{
+	return GENPD_DEV_CALLBACK(genpd, int, suspend, dev);
+}
+
+static int genpd_suspend_late(struct generic_pm_domain *genpd, struct device *dev)
+{
+	return GENPD_DEV_CALLBACK(genpd, int, suspend_late, dev);
+}
+
+static int genpd_resume_early(struct generic_pm_domain *genpd, struct device *dev)
+{
+	return GENPD_DEV_CALLBACK(genpd, int, resume_early, dev);
+}
+
+static int genpd_resume_dev(struct generic_pm_domain *genpd, struct device *dev)
+{
+	return GENPD_DEV_CALLBACK(genpd, int, resume, dev);
+}
+
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
@@ -712,7 +752,7 @@ static int pm_genpd_suspend(struct devic
 	if (IS_ERR(genpd))
 		return -EINVAL;
 
-	return genpd->suspend_power_off ? 0 : pm_generic_suspend(dev);
+	return genpd->suspend_power_off ? 0 : genpd_suspend_dev(genpd, dev);
 }
 
 /**
@@ -737,7 +777,7 @@ static int pm_genpd_suspend_noirq(struct
 	if (genpd->suspend_power_off)
 		return 0;
 
-	ret = pm_generic_suspend_noirq(dev);
+	ret = genpd_suspend_late(genpd, dev);
 	if (ret)
 		return ret;
 
@@ -788,7 +828,7 @@ static int pm_genpd_resume_noirq(struct
 	genpd->suspended_count--;
 	genpd_start_dev(genpd, dev);
 
-	return pm_generic_resume_noirq(dev);
+	return genpd_resume_early(genpd, dev);
 }
 
 /**
@@ -809,7 +849,7 @@ static int pm_genpd_resume(struct device
 	if (IS_ERR(genpd))
 		return -EINVAL;
 
-	return genpd->suspend_power_off ? 0 : pm_generic_resume(dev);
+	return genpd->suspend_power_off ? 0 : genpd_resume_dev(genpd, dev);
 }
 
 /**
@@ -830,7 +870,7 @@ static int pm_genpd_freeze(struct device
 	if (IS_ERR(genpd))
 		return -EINVAL;
 
-	return genpd->suspend_power_off ? 0 : pm_generic_freeze(dev);
+	return genpd->suspend_power_off ? 0 : genpd_freeze_dev(genpd, dev);
 }
 
 /**
@@ -856,7 +896,7 @@ static int pm_genpd_freeze_noirq(struct
 	if (genpd->suspend_power_off)
 		return 0;
 
-	ret = pm_generic_freeze_noirq(dev);
+	ret = genpd_freeze_late(genpd, dev);
 	if (ret)
 		return ret;
 
@@ -889,7 +929,7 @@ static int pm_genpd_thaw_noirq(struct de
 
 	genpd_start_dev(genpd, dev);
 
-	return pm_generic_thaw_noirq(dev);
+	return genpd_thaw_early(genpd, dev);
 }
 
 /**
@@ -910,70 +950,7 @@ static int pm_genpd_thaw(struct device *
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
-}
-
-/**
- * pm_genpd_dev_poweroff_noirq - Late power off of a device from a PM domain.
- * @dev: Device to suspend.
- *
- * Carry out a late powering off of a device under the assumption that its
- * pm_domain field points to the domain member of an object of type
- * struct generic_pm_domain representing a PM domain consisting of I/O devices.
- */
-static int pm_genpd_dev_poweroff_noirq(struct device *dev)
-{
-	struct generic_pm_domain *genpd;
-	int ret;
-
-	dev_dbg(dev, "%s()\n", __func__);
-
-	genpd = dev_to_genpd(dev);
-	if (IS_ERR(genpd))
-		return -EINVAL;
-
-	if (genpd->suspend_power_off)
-		return 0;
-
-	ret = pm_generic_poweroff_noirq(dev);
-	if (ret)
-		return ret;
-
-	if (dev->power.wakeup_path && genpd_dev_active_wakeup(genpd, dev))
-		return 0;
-
-	genpd_stop_dev(genpd, dev);
-
-	/*
-	 * Since all of the "noirq" callbacks are executed sequentially, it is
-	 * guaranteed that this function will never run twice in parallel for
-	 * the same PM domain, so it is not necessary to use locking here.
-	 */
-	genpd->suspended_count++;
-	pm_genpd_sync_poweroff(genpd);
-
-	return 0;
+	return genpd->suspend_power_off ? 0 : genpd_thaw_dev(genpd, dev);
 }
 
 /**
@@ -1015,28 +992,7 @@ static int pm_genpd_restore_noirq(struct
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
+	return genpd_resume_early(genpd, dev);
 }
 
 /**
@@ -1086,10 +1042,7 @@ static void pm_genpd_complete(struct dev
 #define pm_genpd_freeze_noirq		NULL
 #define pm_genpd_thaw_noirq		NULL
 #define pm_genpd_thaw			NULL
-#define pm_genpd_dev_poweroff_noirq	NULL
-#define pm_genpd_dev_poweroff		NULL
 #define pm_genpd_restore_noirq		NULL
-#define pm_genpd_restore		NULL
 #define pm_genpd_complete		NULL
 
 #endif /* CONFIG_PM_SLEEP */
@@ -1361,6 +1314,8 @@ int pm_genpd_remove_callbacks(struct dev
 }
 EXPORT_SYMBOL_GPL(pm_genpd_remove_callbacks);
 
+/* Default device callbacks for generic PM domains. */
+
 /**
  * pm_genpd_default_save_state - Default "save device state" for PM domians.
  * @dev: Device to handle.
@@ -1400,6 +1355,94 @@ static int pm_genpd_default_restore_stat
 }
 
 /**
+ * pm_genpd_default_suspend - Default "device suspend" for PM domians.
+ * @dev: Device to handle.
+ */
+static int pm_genpd_default_suspend(struct device *dev)
+{
+	int (*cb)(struct device *__dev) = dev_gpd_data(dev)->ops.freeze;
+
+	return cb ? cb(dev) : pm_generic_suspend(dev);
+}
+
+/**
+ * pm_genpd_default_suspend_late - Default "late device suspend" for PM domians.
+ * @dev: Device to handle.
+ */
+static int pm_genpd_default_suspend_late(struct device *dev)
+{
+	int (*cb)(struct device *__dev) = dev_gpd_data(dev)->ops.freeze_late;
+
+	return cb ? cb(dev) : pm_generic_suspend_noirq(dev);
+}
+
+/**
+ * pm_genpd_default_resume_early - Default "early device resume" for PM domians.
+ * @dev: Device to handle.
+ */
+static int pm_genpd_default_resume_early(struct device *dev)
+{
+	int (*cb)(struct device *__dev) = dev_gpd_data(dev)->ops.thaw_early;
+
+	return cb ? cb(dev) : pm_generic_resume_noirq(dev);
+}
+
+/**
+ * pm_genpd_default_resume - Default "device resume" for PM domians.
+ * @dev: Device to handle.
+ */
+static int pm_genpd_default_resume(struct device *dev)
+{
+	int (*cb)(struct device *__dev) = dev_gpd_data(dev)->ops.thaw;
+
+	return cb ? cb(dev) : pm_generic_resume(dev);
+}
+
+/**
+ * pm_genpd_default_freeze - Default "device freeze" for PM domians.
+ * @dev: Device to handle.
+ */
+static int pm_genpd_default_freeze(struct device *dev)
+{
+	int (*cb)(struct device *__dev) = dev_gpd_data(dev)->ops.freeze;
+
+	return cb ? cb(dev) : pm_generic_freeze(dev);
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
+	return cb ? cb(dev) : pm_generic_freeze_noirq(dev);
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
+	return cb ? cb(dev) : pm_generic_thaw_noirq(dev);
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
+	return cb ? cb(dev) : pm_generic_thaw(dev);
+}
+
+/**
  * pm_genpd_init - Initialize a generic I/O PM domain object.
  * @genpd: PM domain object to initialize.
  * @gov: PM domain governor to associate with the domain (may be NULL).
@@ -1437,13 +1480,21 @@ void pm_genpd_init(struct generic_pm_dom
 	genpd->domain.ops.freeze_noirq = pm_genpd_freeze_noirq;
 	genpd->domain.ops.thaw_noirq = pm_genpd_thaw_noirq;
 	genpd->domain.ops.thaw = pm_genpd_thaw;
-	genpd->domain.ops.poweroff = pm_genpd_dev_poweroff;
-	genpd->domain.ops.poweroff_noirq = pm_genpd_dev_poweroff_noirq;
+	genpd->domain.ops.poweroff = pm_genpd_suspend;
+	genpd->domain.ops.poweroff_noirq = pm_genpd_suspend_noirq;
 	genpd->domain.ops.restore_noirq = pm_genpd_restore_noirq;
-	genpd->domain.ops.restore = pm_genpd_restore;
+	genpd->domain.ops.restore = pm_genpd_resume;
 	genpd->domain.ops.complete = pm_genpd_complete;
 	genpd->dev_ops.save_state = pm_genpd_default_save_state;
 	genpd->dev_ops.restore_state = pm_genpd_default_restore_state;
+	genpd->dev_ops.freeze = pm_genpd_default_suspend;
+	genpd->dev_ops.freeze_late = pm_genpd_default_suspend_late;
+	genpd->dev_ops.thaw_early = pm_genpd_default_resume_early;
+	genpd->dev_ops.thaw = pm_genpd_default_resume;
+	genpd->dev_ops.freeze = pm_genpd_default_freeze;
+	genpd->dev_ops.freeze_late = pm_genpd_default_freeze_late;
+	genpd->dev_ops.thaw_early = pm_genpd_default_thaw_early;
+	genpd->dev_ops.thaw = pm_genpd_default_thaw;
 	mutex_lock(&gpd_list_lock);
 	list_add(&genpd->gpd_list_node, &gpd_list);
 	mutex_unlock(&gpd_list_lock);

