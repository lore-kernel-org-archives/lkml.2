Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab1HHWdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 18:33:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55704 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031Ab1HHWcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 18:32:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 3/4] PM / Domains: Use power.sybsys_data to reduce overhead
Date: Tue, 9 Aug 2011 00:32:25 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc1+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>
References: <201108090028.12698.rjw@sisk.pl>
In-Reply-To: <201108090028.12698.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108090032.25499.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Currently pm_genpd_runtime_resume() has to walk the list of devices
from the device's PM domain to find the corresponding device list
object containing the need_restore field to check if the driver's
.runtime_resume() callback should be executed for the device.
This is suboptimal and can be simplified by using power.sybsys_data
to store device information used by the generic PM domains code.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/pm-sh7372.c |    6 --
 drivers/base/power/domain.c        |   87 ++++++++++++-------------------------
 include/linux/pm.h                 |    9 +++
 include/linux/pm_domain.h          |    6 --
 include/linux/pm_runtime.h         |   10 ++++
 5 files changed, 51 insertions(+), 67 deletions(-)

Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -422,12 +422,21 @@ enum rpm_request {
 
 struct wakeup_source;
 
+struct pm_domain_data {
+	struct list_head list_node;
+	struct device *dev;
+	bool need_restore;
+};
+
 struct pm_subsys_data {
 	struct mutex lock;
 	unsigned int refcount;
 #ifdef CONFIG_PM_CLK
 	struct list_head clock_list;
 #endif
+#ifdef CONFIG_PM_GENERIC_DOMAINS
+	struct pm_domain_data domain_data;
+#endif
 };
 
 struct dev_pm_info {
Index: linux-2.6/include/linux/pm_domain.h
===================================================================
--- linux-2.6.orig/include/linux/pm_domain.h
+++ linux-2.6/include/linux/pm_domain.h
@@ -61,12 +61,6 @@ struct gpd_link {
 	struct list_head slave_node;
 };
 
-struct dev_list_entry {
-	struct list_head node;
-	struct device *dev;
-	bool need_restore;
-};
-
 #ifdef CONFIG_PM_GENERIC_DOMAINS
 extern int pm_genpd_add_device(struct generic_pm_domain *genpd,
 			       struct device *dev);
Index: linux-2.6/drivers/base/power/domain.c
===================================================================
--- linux-2.6.orig/drivers/base/power/domain.c
+++ linux-2.6/drivers/base/power/domain.c
@@ -181,18 +181,18 @@ int pm_genpd_poweron(struct generic_pm_d
 
 /**
  * __pm_genpd_save_device - Save the pre-suspend state of a device.
- * @dle: Device list entry of the device to save the state of.
+ * @pdd: Domain data of the device to save the state of.
  * @genpd: PM domain the device belongs to.
  */
-static int __pm_genpd_save_device(struct dev_list_entry *dle,
+static int __pm_genpd_save_device(struct pm_domain_data *pdd,
 				  struct generic_pm_domain *genpd)
 	__releases(&genpd->lock) __acquires(&genpd->lock)
 {
-	struct device *dev = dle->dev;
+	struct device *dev = pdd->dev;
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
 
-	if (dle->need_restore)
+	if (pdd->need_restore)
 		return 0;
 
 	mutex_unlock(&genpd->lock);
@@ -210,24 +210,24 @@ static int __pm_genpd_save_device(struct
 	mutex_lock(&genpd->lock);
 
 	if (!ret)
-		dle->need_restore = true;
+		pdd->need_restore = true;
 
 	return ret;
 }
 
 /**
  * __pm_genpd_restore_device - Restore the pre-suspend state of a device.
- * @dle: Device list entry of the device to restore the state of.
+ * @pdd: Domain data of the device to restore the state of.
  * @genpd: PM domain the device belongs to.
  */
-static void __pm_genpd_restore_device(struct dev_list_entry *dle,
+static void __pm_genpd_restore_device(struct pm_domain_data *pdd,
 				      struct generic_pm_domain *genpd)
 	__releases(&genpd->lock) __acquires(&genpd->lock)
 {
-	struct device *dev = dle->dev;
+	struct device *dev = pdd->dev;
 	struct device_driver *drv = dev->driver;
 
-	if (!dle->need_restore)
+	if (!pdd->need_restore)
 		return;
 
 	mutex_unlock(&genpd->lock);
@@ -244,7 +244,7 @@ static void __pm_genpd_restore_device(st
 
 	mutex_lock(&genpd->lock);
 
-	dle->need_restore = false;
+	pdd->need_restore = false;
 }
 
 /**
@@ -286,7 +286,7 @@ void genpd_queue_power_off_work(struct g
 static int pm_genpd_poweroff(struct generic_pm_domain *genpd)
 	__releases(&genpd->lock) __acquires(&genpd->lock)
 {
-	struct dev_list_entry *dle;
+	struct pm_domain_data *pdd;
 	struct gpd_link *link;
 	unsigned int not_suspended;
 	int ret = 0;
@@ -308,8 +308,8 @@ static int pm_genpd_poweroff(struct gene
 		return -EBUSY;
 
 	not_suspended = 0;
-	list_for_each_entry(dle, &genpd->dev_list, node)
-		if (dle->dev->driver && !pm_runtime_suspended(dle->dev))
+	list_for_each_entry(pdd, &genpd->dev_list, list_node)
+		if (pdd->dev->driver && !pm_runtime_suspended(pdd->dev))
 			not_suspended++;
 
 	if (not_suspended > genpd->in_progress)
@@ -332,9 +332,9 @@ static int pm_genpd_poweroff(struct gene
 	genpd->status = GPD_STATE_BUSY;
 	genpd->poweroff_task = current;
 
-	list_for_each_entry_reverse(dle, &genpd->dev_list, node) {
+	list_for_each_entry_reverse(pdd, &genpd->dev_list, list_node) {
 		ret = atomic_read(&genpd->sd_count) == 0 ?
-			__pm_genpd_save_device(dle, genpd) : -EBUSY;
+			__pm_genpd_save_device(pdd, genpd) : -EBUSY;
 
 		if (genpd_abort_poweroff(genpd))
 			goto out;
@@ -433,24 +433,6 @@ static int pm_genpd_runtime_suspend(stru
 }
 
 /**
- * __pm_genpd_runtime_resume - Resume a device belonging to I/O PM domain.
- * @dev: Device to resume.
- * @genpd: PM domain the device belongs to.
- */
-static void __pm_genpd_runtime_resume(struct device *dev,
-				      struct generic_pm_domain *genpd)
-{
-	struct dev_list_entry *dle;
-
-	list_for_each_entry(dle, &genpd->dev_list, node) {
-		if (dle->dev == dev) {
-			__pm_genpd_restore_device(dle, genpd);
-			break;
-		}
-	}
-}
-
-/**
  * pm_genpd_runtime_resume - Resume a device belonging to I/O PM domain.
  * @dev: Device to resume.
  *
@@ -495,7 +477,7 @@ static int pm_genpd_runtime_resume(struc
 		mutex_lock(&genpd->lock);
 	}
 	finish_wait(&genpd->status_wait_queue, &wait);
-	__pm_genpd_runtime_resume(dev, genpd);
+	__pm_genpd_restore_device(&dev->power.subsys_data->domain_data, genpd);
 	genpd->resume_count--;
 	genpd_set_active(genpd);
 	wake_up_all(&genpd->status_wait_queue);
@@ -510,8 +492,6 @@ static int pm_genpd_runtime_resume(struc
 #else
 
 static inline void genpd_power_off_work_fn(struct work_struct *work) {}
-static inline void __pm_genpd_runtime_resume(struct device *dev,
-					     struct generic_pm_domain *genpd) {}
 
 #define pm_genpd_runtime_suspend	NULL
 #define pm_genpd_runtime_resume		NULL
@@ -1068,7 +1048,7 @@ static void pm_genpd_complete(struct dev
  */
 int pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev)
 {
-	struct dev_list_entry *dle;
+	struct pm_domain_data *pdd;
 	int ret = 0;
 
 	dev_dbg(dev, "%s()\n", __func__);
@@ -1088,26 +1068,20 @@ int pm_genpd_add_device(struct generic_p
 		goto out;
 	}
 
-	list_for_each_entry(dle, &genpd->dev_list, node)
-		if (dle->dev == dev) {
+	list_for_each_entry(pdd, &genpd->dev_list, list_node)
+		if (pdd->dev == dev) {
 			ret = -EINVAL;
 			goto out;
 		}
 
-	dle = kzalloc(sizeof(*dle), GFP_KERNEL);
-	if (!dle) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	dle->dev = dev;
-	dle->need_restore = false;
-	list_add_tail(&dle->node, &genpd->dev_list);
 	genpd->device_count++;
 
-	spin_lock_irq(&dev->power.lock);
 	dev->pm_domain = &genpd->domain;
-	spin_unlock_irq(&dev->power.lock);
+	dev_pm_get_subsys_data(dev);
+	pdd = &dev->power.subsys_data->domain_data;
+	pdd->dev = dev;
+	pdd->need_restore = false;
+	list_add_tail(&pdd->list_node, &genpd->dev_list);
 
  out:
 	genpd_release_lock(genpd);
@@ -1123,7 +1097,7 @@ int pm_genpd_add_device(struct generic_p
 int pm_genpd_remove_device(struct generic_pm_domain *genpd,
 			   struct device *dev)
 {
-	struct dev_list_entry *dle;
+	struct pm_domain_data *pdd;
 	int ret = -EINVAL;
 
 	dev_dbg(dev, "%s()\n", __func__);
@@ -1138,17 +1112,16 @@ int pm_genpd_remove_device(struct generi
 		goto out;
 	}
 
-	list_for_each_entry(dle, &genpd->dev_list, node) {
-		if (dle->dev != dev)
+	list_for_each_entry(pdd, &genpd->dev_list, list_node) {
+		if (pdd->dev != dev)
 			continue;
 
-		spin_lock_irq(&dev->power.lock);
+		list_del_init(&pdd->list_node);
+		pdd->dev = NULL;
+		dev_pm_put_subsys_data(dev);
 		dev->pm_domain = NULL;
-		spin_unlock_irq(&dev->power.lock);
 
 		genpd->device_count--;
-		list_del(&dle->node);
-		kfree(dle);
 
 		ret = 0;
 		break;
Index: linux-2.6/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/pm-sh7372.c
+++ linux-2.6/arch/arm/mach-shmobile/pm-sh7372.c
@@ -114,11 +114,9 @@ void sh7372_add_device_to_domain(struct
 {
 	struct device *dev = &pdev->dev;
 
-	if (!dev->power.subsys_data) {
-		pm_clk_create(dev);
-		pm_clk_add(dev, NULL);
-	}
 	pm_genpd_add_device(&sh7372_pd->genpd, dev);
+	if (pm_clk_no_clocks(dev))
+		pm_clk_add(dev, NULL);
 }
 
 struct sh7372_pm_domain sh7372_a4lc = {
Index: linux-2.6/include/linux/pm_runtime.h
===================================================================
--- linux-2.6.orig/include/linux/pm_runtime.h
+++ linux-2.6/include/linux/pm_runtime.h
@@ -258,6 +258,12 @@ struct pm_clk_notifier_block {
 };
 
 #ifdef CONFIG_PM_CLK
+static inline bool pm_clk_no_clocks(struct device *dev)
+{
+	return dev && dev->power.subsys_data
+		&& list_empty(&dev->power.subsys_data->clock_list);
+}
+
 extern void pm_clk_init(struct device *dev);
 extern int pm_clk_create(struct device *dev);
 extern void pm_clk_destroy(struct device *dev);
@@ -266,6 +272,10 @@ extern void pm_clk_remove(struct device
 extern int pm_clk_suspend(struct device *dev);
 extern int pm_clk_resume(struct device *dev);
 #else
+static inline bool pm_clk_no_clocks(struct device *dev)
+{
+	return true;
+}
 static inline void pm_clk_init(struct device *dev)
 {
 }

