Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab1FYVb6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 17:31:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58137 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367Ab1FYVbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 17:31:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 6/10 v6] PM / Domains: System-wide transitions support for generic domains (v4)
Date: Sat, 25 Jun 2011 23:28:31 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, Magnus Damm <magnus.damm@gmail.com>,
        Paul Walmsley <paul@pwsan.com>, Kevin Hilman <khilman@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
References: <201106112223.04972.rjw@sisk.pl> <201106252324.13454.rjw@sisk.pl>
In-Reply-To: <201106252324.13454.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106252328.31882.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make generic PM domains support system-wide power transitions
(system suspend and hibernation).  Add suspend, resume, freeze, thaw,
poweroff and restore callbacks to be associated with struct
generic_pm_domain objects and make pm_genpd_init() use them as
appropriate.

The new callbacks do nothing for devices belonging to power domains
that were powered down at run time (before the transition).  For the
other devices the action carried out depends on the type of the
transition.  During system suspend the power domain .suspend()
callback executes pm_generic_suspend() for the device, while the
PM domain .suspend_noirq() callback runs pm_generic_suspend_noirq()
for it, stops it and eventually removes power from the PM domain it
belongs to (after all devices in the domain have been stopped and its
subdomains have been powered off).

During system resume the PM domain .resume_noirq() callback
restores power to the PM domain (when executed for it first time),
starts the device and executes pm_generic_resume_noirq() for it,
while the .resume() callback executes pm_generic_resume() for the
device.  Finally, the .complete() callback executes pm_runtime_idle()
for the device which should put it back into the suspended state if
its runtime PM usage count is equal to zero at that time.

The actions carried out during hibernation and resume from it are
analogous to the ones described above.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |  546 ++++++++++++++++++++++++++++++++++++++++++--
 include/linux/pm_domain.h   |   12 
 2 files changed, 543 insertions(+), 15 deletions(-)

Index: linux-2.6/drivers/base/power/domain.c
===================================================================
--- linux-2.6.orig/drivers/base/power/domain.c
+++ linux-2.6/drivers/base/power/domain.c
@@ -21,7 +21,7 @@ static struct generic_pm_domain *dev_to_
 	if (IS_ERR_OR_NULL(dev->pm_domain))
 		return ERR_PTR(-EINVAL);
 
-	return container_of(dev->pm_domain, struct generic_pm_domain, domain);
+	return pd_to_genpd(dev->pm_domain);
 }
 
 static void genpd_sd_counter_dec(struct generic_pm_domain *genpd)
@@ -46,7 +46,8 @@ static int pm_genpd_poweron(struct gener
 		mutex_lock(&genpd->parent->lock);
 	mutex_lock(&genpd->lock);
 
-	if (!genpd->power_is_off)
+	if (!genpd->power_is_off
+	    || (genpd->prepared_count > 0 && genpd->suspend_power_off))
 		goto out;
 
 	if (genpd->parent && genpd->parent->power_is_off) {
@@ -155,7 +156,7 @@ static int pm_genpd_poweroff(struct gene
 	unsigned int not_suspended;
 	int ret;
 
-	if (genpd->power_is_off)
+	if (genpd->power_is_off || genpd->prepared_count > 0)
 		return 0;
 
 	if (genpd->sd_count > 0)
@@ -260,6 +261,27 @@ static int pm_genpd_runtime_suspend(stru
 }
 
 /**
+ * __pm_genpd_runtime_resume - Resume a device belonging to I/O PM domain.
+ * @dev: Device to resume.
+ * @genpd: PM domain the device belongs to.
+ */
+static void __pm_genpd_runtime_resume(struct device *dev,
+				      struct generic_pm_domain *genpd)
+{
+	struct dev_list_entry *dle;
+
+	list_for_each_entry(dle, &genpd->dev_list, node) {
+		if (dle->dev == dev) {
+			__pm_genpd_restore_device(dle, genpd);
+			break;
+		}
+	}
+
+	if (genpd->start_device)
+		genpd->start_device(dev);
+}
+
+/**
  * pm_genpd_runtime_resume - Resume a device belonging to I/O PM domain.
  * @dev: Device to resume.
  *
@@ -270,7 +292,6 @@ static int pm_genpd_runtime_suspend(stru
 static int pm_genpd_runtime_resume(struct device *dev)
 {
 	struct generic_pm_domain *genpd;
-	struct dev_list_entry *dle;
 	int ret;
 
 	dev_dbg(dev, "%s()\n", __func__);
@@ -284,17 +305,7 @@ static int pm_genpd_runtime_resume(struc
 		return ret;
 
 	mutex_lock(&genpd->lock);
-
-	list_for_each_entry(dle, &genpd->dev_list, node) {
-		if (dle->dev == dev) {
-			__pm_genpd_restore_device(dle, genpd);
-			break;
-		}
-	}
-
-	if (genpd->start_device)
-		genpd->start_device(dev);
-
+	__pm_genpd_runtime_resume(dev, genpd);
 	mutex_unlock(&genpd->lock);
 
 	return 0;
@@ -303,12 +314,488 @@ static int pm_genpd_runtime_resume(struc
 #else
 
 static inline void genpd_power_off_work_fn(struct work_struct *work) {}
+static inline void __pm_genpd_runtime_resume(struct device *dev,
+					     struct generic_pm_domain *genpd) {}
 
 #define pm_genpd_runtime_suspend	NULL
 #define pm_genpd_runtime_resume		NULL
 
 #endif /* CONFIG_PM_RUNTIME */
 
+#ifdef CONFIG_PM_SLEEP
+
+/**
+ * pm_genpd_sync_poweroff - Synchronously power off a PM domain and its parents.
+ * @genpd: PM domain to power off, if possible.
+ *
+ * Check if the given PM domain can be powered off (during system suspend or
+ * hibernation) and do that if so.  Also, in that case propagate to its parent.
+ *
+ * This function is only called in "noirq" stages of system power transitions,
+ * so it need not acquire locks (all of the "noirq" callbacks are executed
+ * sequentially, so it is guaranteed that it will never run twice in parallel).
+ */
+static void pm_genpd_sync_poweroff(struct generic_pm_domain *genpd)
+{
+	struct generic_pm_domain *parent = genpd->parent;
+
+	if (genpd->power_is_off)
+		return;
+
+	if (genpd->suspended_count != genpd->device_count || genpd->sd_count > 0)
+		return;
+
+	if (genpd->power_off)
+		genpd->power_off(genpd);
+
+	genpd->power_is_off = true;
+	if (parent) {
+		genpd_sd_counter_dec(parent);
+		pm_genpd_sync_poweroff(parent);
+	}
+}
+
+/**
+ * pm_genpd_prepare - Start power transition of a device in a PM domain.
+ * @dev: Device to start the transition of.
+ *
+ * Start a power transition of a device (during a system-wide power transition)
+ * under the assumption that its pm_domain field points to the domain member of
+ * an object of type struct generic_pm_domain representing a PM domain
+ * consisting of I/O devices.
+ */
+static int pm_genpd_prepare(struct device *dev)
+{
+	struct generic_pm_domain *genpd;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	genpd = dev_to_genpd(dev);
+	if (IS_ERR(genpd))
+		return -EINVAL;
+
+	mutex_lock(&genpd->lock);
+
+	if (genpd->prepared_count++ == 0)
+		genpd->suspend_power_off = genpd->power_is_off;
+
+	if (genpd->suspend_power_off) {
+		mutex_unlock(&genpd->lock);
+		return 0;
+	}
+
+	/*
+	 * If the device is in the (runtime) "suspended" state, call
+	 * .start_device() for it, if defined.
+	 */
+	if (pm_runtime_suspended(dev))
+		__pm_genpd_runtime_resume(dev, genpd);
+
+	pm_runtime_disable(dev);
+
+	mutex_unlock(&genpd->lock);
+
+	return pm_generic_prepare(dev);
+}
+
+/**
+ * pm_genpd_suspend - Suspend a device belonging to an I/O PM domain.
+ * @dev: Device to suspend.
+ *
+ * Suspend a device under the assumption that its pm_domain field points to the
+ * domain member of an object of type struct generic_pm_domain representing
+ * a PM domain consisting of I/O devices.
+ */
+static int pm_genpd_suspend(struct device *dev)
+{
+	struct generic_pm_domain *genpd;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	genpd = dev_to_genpd(dev);
+	if (IS_ERR(genpd))
+		return -EINVAL;
+
+	return genpd->suspend_power_off ? 0 : pm_generic_suspend(dev);
+}
+
+/**
+ * pm_genpd_suspend_noirq - Late suspend of a device from an I/O PM domain.
+ * @dev: Device to suspend.
+ *
+ * Carry out a late suspend of a device under the assumption that its
+ * pm_domain field points to the domain member of an object of type
+ * struct generic_pm_domain representing a PM domain consisting of I/O devices.
+ */
+static int pm_genpd_suspend_noirq(struct device *dev)
+{
+	struct generic_pm_domain *genpd;
+	int ret;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	genpd = dev_to_genpd(dev);
+	if (IS_ERR(genpd))
+		return -EINVAL;
+
+	if (genpd->suspend_power_off)
+		return 0;
+
+	ret = pm_generic_suspend_noirq(dev);
+	if (ret)
+		return ret;
+
+	if (genpd->stop_device)
+		genpd->stop_device(dev);
+
+	/*
+	 * Since all of the "noirq" callbacks are executed sequentially, it is
+	 * guaranteed that this function will never run twice in parallel for
+	 * the same PM domain, so it is not necessary to use locking here.
+	 */
+	genpd->suspended_count++;
+	pm_genpd_sync_poweroff(genpd);
+
+	return 0;
+}
+
+/**
+ * pm_genpd_resume_noirq - Early resume of a device from an I/O power domain.
+ * @dev: Device to resume.
+ *
+ * Carry out an early resume of a device under the assumption that its
+ * pm_domain field points to the domain member of an object of type
+ * struct generic_pm_domain representing a power domain consisting of I/O
+ * devices.
+ */
+static int pm_genpd_resume_noirq(struct device *dev)
+{
+	struct generic_pm_domain *genpd;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	genpd = dev_to_genpd(dev);
+	if (IS_ERR(genpd))
+		return -EINVAL;
+
+	if (genpd->suspend_power_off)
+		return 0;
+
+	/*
+	 * Since all of the "noirq" callbacks are executed sequentially, it is
+	 * guaranteed that this function will never run twice in parallel for
+	 * the same PM domain, so it is not necessary to use locking here.
+	 */
+	pm_genpd_poweron(genpd);
+	genpd->suspended_count--;
+	if (genpd->start_device)
+		genpd->start_device(dev);
+
+	return pm_generic_resume_noirq(dev);
+}
+
+/**
+ * pm_genpd_resume - Resume a device belonging to an I/O power domain.
+ * @dev: Device to resume.
+ *
+ * Resume a device under the assumption that its pm_domain field points to the
+ * domain member of an object of type struct generic_pm_domain representing
+ * a power domain consisting of I/O devices.
+ */
+static int pm_genpd_resume(struct device *dev)
+{
+	struct generic_pm_domain *genpd;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	genpd = dev_to_genpd(dev);
+	if (IS_ERR(genpd))
+		return -EINVAL;
+
+	return genpd->suspend_power_off ? 0 : pm_generic_resume(dev);
+}
+
+/**
+ * pm_genpd_freeze - Freeze a device belonging to an I/O power domain.
+ * @dev: Device to freeze.
+ *
+ * Freeze a device under the assumption that its pm_domain field points to the
+ * domain member of an object of type struct generic_pm_domain representing
+ * a power domain consisting of I/O devices.
+ */
+static int pm_genpd_freeze(struct device *dev)
+{
+	struct generic_pm_domain *genpd;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	genpd = dev_to_genpd(dev);
+	if (IS_ERR(genpd))
+		return -EINVAL;
+
+	return genpd->suspend_power_off ? 0 : pm_generic_freeze(dev);
+}
+
+/**
+ * pm_genpd_freeze_noirq - Late freeze of a device from an I/O power domain.
+ * @dev: Device to freeze.
+ *
+ * Carry out a late freeze of a device under the assumption that its
+ * pm_domain field points to the domain member of an object of type
+ * struct generic_pm_domain representing a power domain consisting of I/O
+ * devices.
+ */
+static int pm_genpd_freeze_noirq(struct device *dev)
+{
+	struct generic_pm_domain *genpd;
+	int ret;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	genpd = dev_to_genpd(dev);
+	if (IS_ERR(genpd))
+		return -EINVAL;
+
+	if (genpd->suspend_power_off)
+		return 0;
+
+	ret = pm_generic_freeze_noirq(dev);
+	if (ret)
+		return ret;
+
+	if (genpd->stop_device)
+		genpd->stop_device(dev);
+
+	return 0;
+}
+
+/**
+ * pm_genpd_thaw_noirq - Early thaw of a device from an I/O power domain.
+ * @dev: Device to thaw.
+ *
+ * Carry out an early thaw of a device under the assumption that its
+ * pm_domain field points to the domain member of an object of type
+ * struct generic_pm_domain representing a power domain consisting of I/O
+ * devices.
+ */
+static int pm_genpd_thaw_noirq(struct device *dev)
+{
+	struct generic_pm_domain *genpd;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	genpd = dev_to_genpd(dev);
+	if (IS_ERR(genpd))
+		return -EINVAL;
+
+	if (genpd->suspend_power_off)
+		return 0;
+
+	if (genpd->start_device)
+		genpd->start_device(dev);
+
+	return pm_generic_thaw_noirq(dev);
+}
+
+/**
+ * pm_genpd_thaw - Thaw a device belonging to an I/O power domain.
+ * @dev: Device to thaw.
+ *
+ * Thaw a device under the assumption that its pm_domain field points to the
+ * domain member of an object of type struct generic_pm_domain representing
+ * a power domain consisting of I/O devices.
+ */
+static int pm_genpd_thaw(struct device *dev)
+{
+	struct generic_pm_domain *genpd;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	genpd = dev_to_genpd(dev);
+	if (IS_ERR(genpd))
+		return -EINVAL;
+
+	return genpd->suspend_power_off ? 0 : pm_generic_thaw(dev);
+}
+
+/**
+ * pm_genpd_dev_poweroff - Power off a device belonging to an I/O PM domain.
+ * @dev: Device to suspend.
+ *
+ * Power off a device under the assumption that its pm_domain field points to
+ * the domain member of an object of type struct generic_pm_domain representing
+ * a PM domain consisting of I/O devices.
+ */
+static int pm_genpd_dev_poweroff(struct device *dev)
+{
+	struct generic_pm_domain *genpd;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	genpd = dev_to_genpd(dev);
+	if (IS_ERR(genpd))
+		return -EINVAL;
+
+	return genpd->suspend_power_off ? 0 : pm_generic_poweroff(dev);
+}
+
+/**
+ * pm_genpd_dev_poweroff_noirq - Late power off of a device from a PM domain.
+ * @dev: Device to suspend.
+ *
+ * Carry out a late powering off of a device under the assumption that its
+ * pm_domain field points to the domain member of an object of type
+ * struct generic_pm_domain representing a PM domain consisting of I/O devices.
+ */
+static int pm_genpd_dev_poweroff_noirq(struct device *dev)
+{
+	struct generic_pm_domain *genpd;
+	int ret;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	genpd = dev_to_genpd(dev);
+	if (IS_ERR(genpd))
+		return -EINVAL;
+
+	if (genpd->suspend_power_off)
+		return 0;
+
+	ret = pm_generic_poweroff_noirq(dev);
+	if (ret)
+		return ret;
+
+	if (genpd->stop_device)
+		genpd->stop_device(dev);
+
+	/*
+	 * Since all of the "noirq" callbacks are executed sequentially, it is
+	 * guaranteed that this function will never run twice in parallel for
+	 * the same PM domain, so it is not necessary to use locking here.
+	 */
+	genpd->suspended_count++;
+	pm_genpd_sync_poweroff(genpd);
+
+	return 0;
+}
+
+/**
+ * pm_genpd_restore_noirq - Early restore of a device from an I/O power domain.
+ * @dev: Device to resume.
+ *
+ * Carry out an early restore of a device under the assumption that its
+ * pm_domain field points to the domain member of an object of type
+ * struct generic_pm_domain representing a power domain consisting of I/O
+ * devices.
+ */
+static int pm_genpd_restore_noirq(struct device *dev)
+{
+	struct generic_pm_domain *genpd;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	genpd = dev_to_genpd(dev);
+	if (IS_ERR(genpd))
+		return -EINVAL;
+
+	/*
+	 * Since all of the "noirq" callbacks are executed sequentially, it is
+	 * guaranteed that this function will never run twice in parallel for
+	 * the same PM domain, so it is not necessary to use locking here.
+	 */
+	genpd->power_is_off = true;
+	if (genpd->suspend_power_off) {
+		/*
+		 * The boot kernel might put the domain into the power on state,
+		 * so make sure it really is powered off.
+		 */
+		if (genpd->power_off)
+			genpd->power_off(genpd);
+		return 0;
+	}
+
+	pm_genpd_poweron(genpd);
+	genpd->suspended_count--;
+	if (genpd->start_device)
+		genpd->start_device(dev);
+
+	return pm_generic_restore_noirq(dev);
+}
+
+/**
+ * pm_genpd_restore - Restore a device belonging to an I/O power domain.
+ * @dev: Device to resume.
+ *
+ * Restore a device under the assumption that its pm_domain field points to the
+ * domain member of an object of type struct generic_pm_domain representing
+ * a power domain consisting of I/O devices.
+ */
+static int pm_genpd_restore(struct device *dev)
+{
+	struct generic_pm_domain *genpd;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	genpd = dev_to_genpd(dev);
+	if (IS_ERR(genpd))
+		return -EINVAL;
+
+	return genpd->suspend_power_off ? 0 : pm_generic_restore(dev);
+}
+
+/**
+ * pm_genpd_complete - Complete power transition of a device in a power domain.
+ * @dev: Device to complete the transition of.
+ *
+ * Complete a power transition of a device (during a system-wide power
+ * transition) under the assumption that its pm_domain field points to the
+ * domain member of an object of type struct generic_pm_domain representing
+ * a power domain consisting of I/O devices.
+ */
+static void pm_genpd_complete(struct device *dev)
+{
+	struct generic_pm_domain *genpd;
+	bool run_complete;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	genpd = dev_to_genpd(dev);
+	if (IS_ERR(genpd))
+		return;
+
+	mutex_lock(&genpd->lock);
+
+	run_complete = !genpd->suspend_power_off;
+	if (--genpd->prepared_count == 0)
+		genpd->suspend_power_off = false;
+
+	mutex_unlock(&genpd->lock);
+
+	if (run_complete)
+		pm_generic_complete(dev);
+
+	pm_runtime_enable(dev);
+}
+
+#else
+
+#define pm_genpd_prepare		NULL
+#define pm_genpd_suspend		NULL
+#define pm_genpd_suspend_noirq		NULL
+#define pm_genpd_resume_noirq		NULL
+#define pm_genpd_resume			NULL
+#define pm_genpd_freeze			NULL
+#define pm_genpd_freeze_noirq		NULL
+#define pm_genpd_thaw_noirq		NULL
+#define pm_genpd_thaw			NULL
+#define pm_genpd_dev_poweroff_noirq	NULL
+#define pm_genpd_dev_poweroff		NULL
+#define pm_genpd_restore_noirq		NULL
+#define pm_genpd_restore		NULL
+#define pm_genpd_complete		NULL
+
+#endif /* CONFIG_PM_SLEEP */
+
 /**
  * pm_genpd_add_device - Add a device to an I/O PM domain.
  * @genpd: PM domain to add the device to.
@@ -331,6 +818,11 @@ int pm_genpd_add_device(struct generic_p
 		goto out;
 	}
 
+	if (genpd->prepared_count > 0) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
 	list_for_each_entry(dle, &genpd->dev_list, node)
 		if (dle->dev == dev) {
 			ret = -EINVAL;
@@ -346,6 +838,7 @@ int pm_genpd_add_device(struct generic_p
 	dle->dev = dev;
 	dle->need_restore = false;
 	list_add_tail(&dle->node, &genpd->dev_list);
+	genpd->device_count++;
 
 	spin_lock_irq(&dev->power.lock);
 	dev->pm_domain = &genpd->domain;
@@ -375,6 +868,11 @@ int pm_genpd_remove_device(struct generi
 
 	mutex_lock(&genpd->lock);
 
+	if (genpd->prepared_count > 0) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
 	list_for_each_entry(dle, &genpd->dev_list, node) {
 		if (dle->dev != dev)
 			continue;
@@ -383,6 +881,7 @@ int pm_genpd_remove_device(struct generi
 		dev->pm_domain = NULL;
 		spin_unlock_irq(&dev->power.lock);
 
+		genpd->device_count--;
 		list_del(&dle->node);
 		kfree(dle);
 
@@ -390,6 +889,7 @@ int pm_genpd_remove_device(struct generi
 		break;
 	}
 
+ out:
 	mutex_unlock(&genpd->lock);
 
 	return ret;
@@ -498,7 +998,23 @@ void pm_genpd_init(struct generic_pm_dom
 	genpd->in_progress = 0;
 	genpd->sd_count = 0;
 	genpd->power_is_off = is_off;
+	genpd->device_count = 0;
+	genpd->suspended_count = 0;
 	genpd->domain.ops.runtime_suspend = pm_genpd_runtime_suspend;
 	genpd->domain.ops.runtime_resume = pm_genpd_runtime_resume;
 	genpd->domain.ops.runtime_idle = pm_generic_runtime_idle;
+	genpd->domain.ops.prepare = pm_genpd_prepare;
+	genpd->domain.ops.suspend = pm_genpd_suspend;
+	genpd->domain.ops.suspend_noirq = pm_genpd_suspend_noirq;
+	genpd->domain.ops.resume_noirq = pm_genpd_resume_noirq;
+	genpd->domain.ops.resume = pm_genpd_resume;
+	genpd->domain.ops.freeze = pm_genpd_freeze;
+	genpd->domain.ops.freeze_noirq = pm_genpd_freeze_noirq;
+	genpd->domain.ops.thaw_noirq = pm_genpd_thaw_noirq;
+	genpd->domain.ops.thaw = pm_genpd_thaw;
+	genpd->domain.ops.poweroff = pm_genpd_dev_poweroff;
+	genpd->domain.ops.poweroff_noirq = pm_genpd_dev_poweroff_noirq;
+	genpd->domain.ops.restore_noirq = pm_genpd_restore_noirq;
+	genpd->domain.ops.restore = pm_genpd_restore;
+	genpd->domain.ops.complete = pm_genpd_complete;
 }
Index: linux-2.6/include/linux/pm_domain.h
===================================================================
--- linux-2.6.orig/include/linux/pm_domain.h
+++ linux-2.6/include/linux/pm_domain.h
@@ -11,6 +11,9 @@
 
 #include <linux/device.h>
 
+#define GPD_IN_SUSPEND	1
+#define GPD_POWER_OFF	2
+
 struct dev_power_governor {
 	bool (*power_down_ok)(struct dev_pm_domain *domain);
 };
@@ -27,12 +30,21 @@ struct generic_pm_domain {
 	unsigned int in_progress;	/* Number of devices being suspended now */
 	unsigned int sd_count;	/* Number of subdomains with power "on" */
 	bool power_is_off;	/* Whether or not power has been removed */
+	unsigned int device_count;	/* Number of devices */
+	unsigned int suspended_count;	/* System suspend device counter */
+	unsigned int prepared_count;	/* Suspend counter of prepared devices */
+	bool suspend_power_off;	/* Power status before system suspend */
 	int (*power_off)(struct generic_pm_domain *domain);
 	int (*power_on)(struct generic_pm_domain *domain);
 	int (*start_device)(struct device *dev);
 	int (*stop_device)(struct device *dev);
 };
 
+static inline struct generic_pm_domain *pd_to_genpd(struct dev_pm_domain *pd)
+{
+	return container_of(pd, struct generic_pm_domain, domain);
+}
+
 struct dev_list_entry {
 	struct list_head node;
 	struct device *dev;

