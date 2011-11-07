Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab1KGAI3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 19:08:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53722 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853Ab1KGAI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 19:08:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 3/7] PM / Domains: Introduce "save/restore state" device callbacks
Date: Mon, 7 Nov 2011 01:07:29 +0100
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
Message-Id: <201111070107.29828.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The current PM domains code uses device drivers' .runtime_suspend()
and .runtime_resume() callbacks as the "save device state" and
"restore device state" operations, which may not be appropriate in
general, because it forces drivers to assume that they always will
be used with generic PM domains.  However, in theory, the same
hardware may be used in devices that don't belong to any PM
domain, in which case it would be necessary to add "fake" PM
domains to satisfy the above assumption.  It also may be located in
a PM domain that's not handled with the help of the generic code.

To allow device drivers that may be used along with the generic PM
domains code of more flexibility, introduce new device callbacks,
.save_state() and .restore_state(), that can be supplied by the
drivers in addition to their "standard" runtime PM callbacks.  This
will allow the drivers to be designed to work with generic PM domains
as well as without them.

For backwards compatibility, introduce default .save_state() and
.restore_state() callback routines for PM domains that will execute
a device driver's .runtime_suspend() and .runtime_resume() callbacks,
respectively, for the given device if the driver doesn't provide its
own implementations of .save_state() and .restore_state().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |   68 ++++++++++++++++++++++++++++++++++++--------
 include/linux/pm_domain.h   |    2 +
 2 files changed, 58 insertions(+), 12 deletions(-)

Index: linux/include/linux/pm_domain.h
===================================================================
--- linux.orig/include/linux/pm_domain.h
+++ linux/include/linux/pm_domain.h
@@ -26,6 +26,8 @@ struct dev_power_governor {
 struct gpd_dev_ops {
 	int (*start)(struct device *dev);
 	int (*stop)(struct device *dev);
+	int (*save_state)(struct device *dev);
+	int (*restore_state)(struct device *dev);
 	bool (*active_wakeup)(struct device *dev);
 };
 
Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -55,6 +55,16 @@ static int genpd_start_dev(struct generi
 	return GENPD_DEV_CALLBACK(genpd, int, start, dev);
 }
 
+static int genpd_save_dev(struct generic_pm_domain *genpd, struct device *dev)
+{
+	return GENPD_DEV_CALLBACK(genpd, int, save_state, dev);
+}
+
+static int genpd_restore_dev(struct generic_pm_domain *genpd, struct device *dev)
+{
+	return GENPD_DEV_CALLBACK(genpd, int, restore_state, dev);
+}
+
 static bool genpd_sd_counter_dec(struct generic_pm_domain *genpd)
 {
 	bool ret = false;
@@ -216,7 +226,6 @@ static int __pm_genpd_save_device(struct
 {
 	struct generic_pm_domain_data *gpd_data = to_gpd_data(pdd);
 	struct device *dev = pdd->dev;
-	struct device_driver *drv = dev->driver;
 	int ret = 0;
 
 	if (gpd_data->need_restore)
@@ -224,11 +233,9 @@ static int __pm_genpd_save_device(struct
 
 	mutex_unlock(&genpd->lock);
 
-	if (drv && drv->pm && drv->pm->runtime_suspend) {
-		genpd_start_dev(genpd, dev);
-		ret = drv->pm->runtime_suspend(dev);
-		genpd_stop_dev(genpd, dev);
-	}
+	genpd_start_dev(genpd, dev);
+	ret = genpd_save_dev(genpd, dev);
+	genpd_stop_dev(genpd, dev);
 
 	mutex_lock(&genpd->lock);
 
@@ -249,18 +256,15 @@ static void __pm_genpd_restore_device(st
 {
 	struct generic_pm_domain_data *gpd_data = to_gpd_data(pdd);
 	struct device *dev = pdd->dev;
-	struct device_driver *drv = dev->driver;
 
 	if (!gpd_data->need_restore)
 		return;
 
 	mutex_unlock(&genpd->lock);
 
-	if (drv && drv->pm && drv->pm->runtime_resume) {
-		genpd_start_dev(genpd, dev);
-		drv->pm->runtime_resume(dev);
-		genpd_stop_dev(genpd, dev);
-	}
+	genpd_start_dev(genpd, dev);
+	genpd_restore_dev(genpd, dev);
+	genpd_stop_dev(genpd, dev);
 
 	mutex_lock(&genpd->lock);
 
@@ -1351,6 +1355,44 @@ int pm_genpd_remove_callbacks(struct dev
 EXPORT_SYMBOL_GPL(pm_genpd_remove_callbacks);
 
 /**
+ * pm_genpd_default_save_state - Default "save device state" for PM domians.
+ * @dev: Device to handle.
+ */
+static int pm_genpd_default_save_state(struct device *dev)
+{
+	int (*cb)(struct device *__dev);
+	struct device_driver *drv = dev->driver;
+
+	cb = dev_gpd_data(dev)->ops.save_state;
+	if (cb)
+		return cb(dev);
+
+	if (drv && drv->pm && drv->pm->runtime_suspend)
+		return drv->pm->runtime_suspend(dev);
+
+	return 0;
+}
+
+/**
+ * pm_genpd_default_restore_state - Default PM domians "restore device state".
+ * @dev: Device to handle.
+ */
+static int pm_genpd_default_restore_state(struct device *dev)
+{
+	int (*cb)(struct device *__dev);
+	struct device_driver *drv = dev->driver;
+
+	cb = dev_gpd_data(dev)->ops.restore_state;
+	if (cb)
+		return cb(dev);
+
+	if (drv && drv->pm && drv->pm->runtime_resume)
+		return drv->pm->runtime_resume(dev);
+
+	return 0;
+}
+
+/**
  * pm_genpd_init - Initialize a generic I/O PM domain object.
  * @genpd: PM domain object to initialize.
  * @gov: PM domain governor to associate with the domain (may be NULL).
@@ -1393,6 +1435,8 @@ void pm_genpd_init(struct generic_pm_dom
 	genpd->domain.ops.restore_noirq = pm_genpd_restore_noirq;
 	genpd->domain.ops.restore = pm_genpd_restore;
 	genpd->domain.ops.complete = pm_genpd_complete;
+	genpd->dev_ops.save_state = pm_genpd_default_save_state;
+	genpd->dev_ops.restore_state = pm_genpd_default_restore_state;
 	mutex_lock(&gpd_list_lock);
 	list_add(&genpd->gpd_list_node, &gpd_list);
 	mutex_unlock(&gpd_list_lock);

