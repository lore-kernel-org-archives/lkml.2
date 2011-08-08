Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab1HHWc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 18:32:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55717 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327Ab1HHWcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 18:32:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 1/4] PM: Introduce struct pm_subsys_data
Date: Tue, 9 Aug 2011 00:30:59 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc1+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>
References: <201108090028.12698.rjw@sisk.pl>
In-Reply-To: <201108090028.12698.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108090030.59408.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Introduce struct pm_subsys_data that may be subclassed by subsystems
to store subsystem-specific information related to the device.  Move
the clock management fields accessed through the power.subsys_data
pointer in struct device to the new strucutre.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/pm-sh7372.c |    2 
 drivers/base/power/clock_ops.c     |  122 +++++++++++++++++++------------------
 include/linux/device.h             |    5 +
 include/linux/pm.h                 |   10 ++-
 include/linux/pm_runtime.h         |    8 +-
 5 files changed, 85 insertions(+), 62 deletions(-)

Index: linux-2.6/drivers/base/power/clock_ops.c
===================================================================
--- linux-2.6.orig/drivers/base/power/clock_ops.c
+++ linux-2.6/drivers/base/power/clock_ops.c
@@ -17,11 +17,6 @@
 
 #ifdef CONFIG_PM
 
-struct pm_clk_data {
-	struct list_head clock_list;
-	struct mutex lock;
-};
-
 enum pce_status {
 	PCE_STATUS_NONE = 0,
 	PCE_STATUS_ACQUIRED,
@@ -36,11 +31,6 @@ struct pm_clock_entry {
 	enum pce_status status;
 };
 
-static struct pm_clk_data *__to_pcd(struct device *dev)
-{
-	return dev ? dev->power.subsys_data : NULL;
-}
-
 /**
  * pm_clk_add - Start using a device clock for power management.
  * @dev: Device whose clock is going to be used for power management.
@@ -51,10 +41,10 @@ static struct pm_clk_data *__to_pcd(stru
  */
 int pm_clk_add(struct device *dev, const char *con_id)
 {
-	struct pm_clk_data *pcd = __to_pcd(dev);
+	struct pm_subsys_data *psd = dev_to_psd(dev);
 	struct pm_clock_entry *ce;
 
-	if (!pcd)
+	if (!psd)
 		return -EINVAL;
 
 	ce = kzalloc(sizeof(*ce), GFP_KERNEL);
@@ -73,9 +63,9 @@ int pm_clk_add(struct device *dev, const
 		}
 	}
 
-	mutex_lock(&pcd->lock);
-	list_add_tail(&ce->node, &pcd->clock_list);
-	mutex_unlock(&pcd->lock);
+	mutex_lock(&psd->lock);
+	list_add_tail(&ce->node, &psd->clock_list);
+	mutex_unlock(&psd->lock);
 	return 0;
 }
 
@@ -117,15 +107,15 @@ static void __pm_clk_remove(struct pm_cl
  */
 void pm_clk_remove(struct device *dev, const char *con_id)
 {
-	struct pm_clk_data *pcd = __to_pcd(dev);
+	struct pm_subsys_data *psd = dev_to_psd(dev);
 	struct pm_clock_entry *ce;
 
-	if (!pcd)
+	if (!psd)
 		return;
 
-	mutex_lock(&pcd->lock);
+	mutex_lock(&psd->lock);
 
-	list_for_each_entry(ce, &pcd->clock_list, node) {
+	list_for_each_entry(ce, &psd->clock_list, node) {
 		if (!con_id && !ce->con_id) {
 			__pm_clk_remove(ce);
 			break;
@@ -137,29 +127,45 @@ void pm_clk_remove(struct device *dev, c
 		}
 	}
 
-	mutex_unlock(&pcd->lock);
+	mutex_unlock(&psd->lock);
 }
 
 /**
  * pm_clk_init - Initialize a device's list of power management clocks.
  * @dev: Device to initialize the list of PM clocks for.
  *
- * Allocate a struct pm_clk_data object, initialize its lock member and
- * make the @dev's power.subsys_data field point to it.
+ * Initialize the lock and clock_list members of the device's pm_subsys_data
+ * object.
  */
-int pm_clk_init(struct device *dev)
+void pm_clk_init(struct device *dev)
 {
-	struct pm_clk_data *pcd;
+	struct pm_subsys_data *psd = dev_to_psd(dev);
+
+	if (!psd)
+		return;
 
-	pcd = kzalloc(sizeof(*pcd), GFP_KERNEL);
-	if (!pcd) {
+	INIT_LIST_HEAD(&psd->clock_list);
+	mutex_init(&psd->lock);
+}
+
+/**
+ * pm_clk_create - Create and initialize a device's list of PM clocks.
+ * @dev: Device to create and initialize the list of PM clocks for.
+ *
+ * Allocate a struct pm_subsys_data object, initialize its lock and clock_list
+ * members and make the @dev's power.subsys_data field point to it.
+ */
+int pm_clk_create(struct device *dev)
+{
+	struct pm_subsys_data *psd;
+
+	psd = kzalloc(sizeof(*psd), GFP_KERNEL);
+	if (!psd) {
 		dev_err(dev, "Not enough memory for PM clock data.\n");
 		return -ENOMEM;
 	}
-
-	INIT_LIST_HEAD(&pcd->clock_list);
-	mutex_init(&pcd->lock);
-	dev->power.subsys_data = pcd;
+	dev->power.subsys_data = psd;
+	pm_clk_init(dev);
 	return 0;
 }
 
@@ -168,27 +174,27 @@ int pm_clk_init(struct device *dev)
  * @dev: Device to destroy the list of PM clocks for.
  *
  * Clear the @dev's power.subsys_data field, remove the list of clock entries
- * from the struct pm_clk_data object pointed to by it before and free
+ * from the struct pm_subsys_data object pointed to by it before and free
  * that object.
  */
 void pm_clk_destroy(struct device *dev)
 {
-	struct pm_clk_data *pcd = __to_pcd(dev);
+	struct pm_subsys_data *psd = dev_to_psd(dev);
 	struct pm_clock_entry *ce, *c;
 
-	if (!pcd)
+	if (!psd)
 		return;
 
 	dev->power.subsys_data = NULL;
 
-	mutex_lock(&pcd->lock);
+	mutex_lock(&psd->lock);
 
-	list_for_each_entry_safe_reverse(ce, c, &pcd->clock_list, node)
+	list_for_each_entry_safe_reverse(ce, c, &psd->clock_list, node)
 		__pm_clk_remove(ce);
 
-	mutex_unlock(&pcd->lock);
+	mutex_unlock(&psd->lock);
 
-	kfree(pcd);
+	kfree(psd);
 }
 
 #endif /* CONFIG_PM */
@@ -218,17 +224,17 @@ static void pm_clk_acquire(struct device
  */
 int pm_clk_suspend(struct device *dev)
 {
-	struct pm_clk_data *pcd = __to_pcd(dev);
+	struct pm_subsys_data *psd = dev_to_psd(dev);
 	struct pm_clock_entry *ce;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
-	if (!pcd)
+	if (!psd)
 		return 0;
 
-	mutex_lock(&pcd->lock);
+	mutex_lock(&psd->lock);
 
-	list_for_each_entry_reverse(ce, &pcd->clock_list, node) {
+	list_for_each_entry_reverse(ce, &psd->clock_list, node) {
 		if (ce->status == PCE_STATUS_NONE)
 			pm_clk_acquire(dev, ce);
 
@@ -238,7 +244,7 @@ int pm_clk_suspend(struct device *dev)
 		}
 	}
 
-	mutex_unlock(&pcd->lock);
+	mutex_unlock(&psd->lock);
 
 	return 0;
 }
@@ -249,17 +255,17 @@ int pm_clk_suspend(struct device *dev)
  */
 int pm_clk_resume(struct device *dev)
 {
-	struct pm_clk_data *pcd = __to_pcd(dev);
+	struct pm_subsys_data *psd = dev_to_psd(dev);
 	struct pm_clock_entry *ce;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
-	if (!pcd)
+	if (!psd)
 		return 0;
 
-	mutex_lock(&pcd->lock);
+	mutex_lock(&psd->lock);
 
-	list_for_each_entry(ce, &pcd->clock_list, node) {
+	list_for_each_entry(ce, &psd->clock_list, node) {
 		if (ce->status == PCE_STATUS_NONE)
 			pm_clk_acquire(dev, ce);
 
@@ -269,7 +275,7 @@ int pm_clk_resume(struct device *dev)
 		}
 	}
 
-	mutex_unlock(&pcd->lock);
+	mutex_unlock(&psd->lock);
 
 	return 0;
 }
@@ -307,7 +313,7 @@ static int pm_clk_notify(struct notifier
 		if (dev->pm_domain)
 			break;
 
-		error = pm_clk_init(dev);
+		error = pm_clk_create(dev);
 		if (error)
 			break;
 
@@ -342,21 +348,21 @@ static int pm_clk_notify(struct notifier
  */
 int pm_clk_suspend(struct device *dev)
 {
-	struct pm_clk_data *pcd = __to_pcd(dev);
+	struct pm_subsys_data *psd = dev_to_psd(dev);
 	struct pm_clock_entry *ce;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
 	/* If there is no driver, the clocks are already disabled. */
-	if (!pcd || !dev->driver)
+	if (!psd || !dev->driver)
 		return 0;
 
-	mutex_lock(&pcd->lock);
+	mutex_lock(&psd->lock);
 
-	list_for_each_entry_reverse(ce, &pcd->clock_list, node)
+	list_for_each_entry_reverse(ce, &psd->clock_list, node)
 		clk_disable(ce->clk);
 
-	mutex_unlock(&pcd->lock);
+	mutex_unlock(&psd->lock);
 
 	return 0;
 }
@@ -367,21 +373,21 @@ int pm_clk_suspend(struct device *dev)
  */
 int pm_clk_resume(struct device *dev)
 {
-	struct pm_clk_data *pcd = __to_pcd(dev);
+	struct pm_subsys_data *psd = dev_to_psd(dev);
 	struct pm_clock_entry *ce;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
 	/* If there is no driver, the clocks should remain disabled. */
-	if (!pcd || !dev->driver)
+	if (!psd || !dev->driver)
 		return 0;
 
-	mutex_lock(&pcd->lock);
+	mutex_lock(&psd->lock);
 
-	list_for_each_entry(ce, &pcd->clock_list, node)
+	list_for_each_entry(ce, &psd->clock_list, node)
 		clk_enable(ce->clk);
 
-	mutex_unlock(&pcd->lock);
+	mutex_unlock(&psd->lock);
 
 	return 0;
 }
Index: linux-2.6/include/linux/device.h
===================================================================
--- linux-2.6.orig/include/linux/device.h
+++ linux-2.6/include/linux/device.h
@@ -636,6 +636,11 @@ static inline void set_dev_node(struct d
 }
 #endif
 
+static inline struct pm_subsys_data *dev_to_psd(struct device *dev)
+{
+	return dev ? dev->power.subsys_data : NULL;
+}
+
 static inline unsigned int dev_get_uevent_suppress(const struct device *dev)
 {
 	return dev->kobj.uevent_suppress;
Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -24,6 +24,7 @@
 #include <linux/list.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/wait.h>
 #include <linux/timer.h>
 #include <linux/completion.h>
@@ -421,6 +422,13 @@ enum rpm_request {
 
 struct wakeup_source;
 
+struct pm_subsys_data {
+	struct mutex lock;
+#ifdef CONFIG_PM_CLK
+	struct list_head clock_list;
+#endif
+};
+
 struct dev_pm_info {
 	pm_message_t		power_state;
 	unsigned int		can_wakeup:1;
@@ -462,7 +470,7 @@ struct dev_pm_info {
 	unsigned long		suspended_jiffies;
 	unsigned long		accounting_timestamp;
 #endif
-	void			*subsys_data;  /* Owned by the subsystem. */
+	struct pm_subsys_data	*subsys_data;  /* Owned by the subsystem. */
 };
 
 extern void update_pm_runtime_accounting(struct device *dev);
Index: linux-2.6/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/pm-sh7372.c
+++ linux-2.6/arch/arm/mach-shmobile/pm-sh7372.c
@@ -115,7 +115,7 @@ void sh7372_add_device_to_domain(struct
 	struct device *dev = &pdev->dev;
 
 	if (!dev->power.subsys_data) {
-		pm_clk_init(dev);
+		pm_clk_create(dev);
 		pm_clk_add(dev, NULL);
 	}
 	pm_genpd_add_device(&sh7372_pd->genpd, dev);
Index: linux-2.6/include/linux/pm_runtime.h
===================================================================
--- linux-2.6.orig/include/linux/pm_runtime.h
+++ linux-2.6/include/linux/pm_runtime.h
@@ -258,14 +258,18 @@ struct pm_clk_notifier_block {
 };
 
 #ifdef CONFIG_PM_CLK
-extern int pm_clk_init(struct device *dev);
+extern void pm_clk_init(struct device *dev);
+extern int pm_clk_create(struct device *dev);
 extern void pm_clk_destroy(struct device *dev);
 extern int pm_clk_add(struct device *dev, const char *con_id);
 extern void pm_clk_remove(struct device *dev, const char *con_id);
 extern int pm_clk_suspend(struct device *dev);
 extern int pm_clk_resume(struct device *dev);
 #else
-static inline int pm_clk_init(struct device *dev)
+static inline void pm_clk_init(struct device *dev)
+{
+}
+static inline int pm_clk_create(struct device *dev)
 {
 	return -EINVAL;
 }

