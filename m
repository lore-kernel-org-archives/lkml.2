Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab1EIWKN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:10:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34868 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932201Ab1EIWKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 18:10:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [Update][PATCH 3/5] PM: System-wide power transitions support for generic power domains
Date: Tue, 10 May 2011 00:10:28 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <201104290154.12966.rjw@sisk.pl> <201105082320.57185.rjw@sisk.pl> <201105082324.19674.rjw@sisk.pl>
In-Reply-To: <201105082324.19674.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105100010.28810.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make generic power domains support system-wide power transitions
(system suspend and hibernation).  Add suspend, resume, freeze and
thaw callbacks to be associated with struct generic_power_domain
objects and make pm_genpd_init() use them as appropriate.

The new callbacks do nothing for devices belonging to power domains
that were powered down at run time (before the transition).  For the
other devices the action carried out depends on the type of the
transition.  During system suspend the power domain ->suspend()
callback executes pm_generic_suspend() for the device, while the
power domain ->suspend_noirq() callback stops the device and
eventually removes power from the power domain it belongs to (after
all devices in the power domain have been stopped).  During system
resume the power domain ->resume_noirq() callback powers up the power
domain (when executed for the first time for the given power domain)
and starts the device, while the ->resume() callback executes
pm_generic_resume() for the device.  Finally, the ->complete()
callback executes pm_runtime_idle() for the device which should put
it back into the suspended state if its runtime PM usage count is
equal to zero at that time.

The actions carried out during hibernation and resume from it are
analogous to the ones described above.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

Hi,

In this version of the patch I added ->prepare() and ->complete() power domain
callbacks behaving as described in the changelog (ie. doing nothing if power
has been removed from the power domain).  On the system I tested this patch
none of the drivers implements ->prepare() and ->complete(), so I didn't see
the problem before.

I also made the system-wide PM callbacks access genpd->power_is_off without
locking, because that test cannot race with the runtime PM code modifying
that field.

Thanks,
Rafael

---
 drivers/base/power/domain.c |  328 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pm_domain.h   |    2 
 2 files changed, 330 insertions(+)

Index: linux-2.6/drivers/base/power/domain.c
===================================================================
--- linux-2.6.orig/drivers/base/power/domain.c
+++ linux-2.6/drivers/base/power/domain.c
@@ -273,6 +273,316 @@ static int pm_genpd_runtime_resume(struc
 
 #endif /* CONFIG_PM_RUNTIME */
 
+#ifdef CONFIG_PM_SLEEP
+
+/**
+ * pm_genpd_prepare - Start power transition of a device in a power domain.
+ * @dev: Device to start the transition of.
+ *
+ * Start a power transition of a device (during a system-wide power transition)
+ * under the assumption that its pwr_domain field points to the domain member of
+ * an object of type struct generic_power_domain representing a power domain
+ * consisting of I/O devices.
+ */
+static int pm_genpd_prepare(struct device *dev)
+{
+	struct generic_power_domain *genpd;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	if (IS_ERR_OR_NULL(dev->pwr_domain))
+		return -EINVAL;
+
+	genpd = container_of(dev->pwr_domain,
+			     struct generic_power_domain, domain);
+
+	return genpd->power_is_off ? 0 : pm_generic_prepare(dev);
+}
+
+/**
+ * pm_genpd_suspend - Suspend a device belonging to an I/O power domain.
+ * @dev: Device to suspend.
+ *
+ * Suspend a device under the assumption that its pwr_domain field points to the
+ * domain member of an object of type struct generic_power_domain representing
+ * a power domain consisting of I/O devices.
+ */
+static int pm_genpd_suspend(struct device *dev)
+{
+	struct generic_power_domain *genpd;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	if (IS_ERR_OR_NULL(dev->pwr_domain))
+		return -EINVAL;
+
+	genpd = container_of(dev->pwr_domain,
+			     struct generic_power_domain, domain);
+
+	if (genpd->power_is_off)
+		return 0;
+
+	/*
+	 * If the device is in the (runtime) "suspended" state, call
+	 * ->start_device() for it, if defined.
+	 */
+	pm_runtime_resume(dev);
+
+	return pm_generic_suspend(dev);
+}
+
+/**
+ * pm_genpd_suspend_noirq - Late suspend of a device from an I/O power domain.
+ * @dev: Device to suspend.
+ *
+ * Carry out a late suspend of a device under the assumption that its
+ * pwr_domain field points to the domain member of an object of type
+ * struct generic_power_domain representing a power domain consisting of I/O
+ * devices.
+ */
+static int pm_genpd_suspend_noirq(struct device *dev)
+{
+	struct generic_power_domain *genpd;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	if (IS_ERR_OR_NULL(dev->pwr_domain))
+		return -EINVAL;
+
+	genpd = container_of(dev->pwr_domain,
+			     struct generic_power_domain, domain);
+
+	if (genpd->power_is_off)
+		return 0;
+
+	if (genpd->stop_device)
+		genpd->stop_device(dev);
+
+	mutex_lock(&genpd->lock);
+	if (++genpd->suspended_count == genpd->device_count) {
+		if (genpd->power_off)
+			genpd->power_off(&genpd->domain);
+	}
+	mutex_unlock(&genpd->lock);
+
+	return 0;
+}
+
+/**
+ * pm_genpd_resume_noirq - Early resume of a device from an I/O power domain.
+ * @dev: Device to resume.
+ *
+ * Carry out an early resume of a device under the assumption that its
+ * pwr_domain field points to the domain member of an object of type
+ * struct generic_power_domain representing a power domain consisting of I/O
+ * devices.
+ */
+static int pm_genpd_resume_noirq(struct device *dev)
+{
+	struct generic_power_domain *genpd;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	if (IS_ERR_OR_NULL(dev->pwr_domain))
+		return -EINVAL;
+
+	genpd = container_of(dev->pwr_domain,
+			     struct generic_power_domain, domain);
+
+	if (genpd->power_is_off)
+		return 0;
+
+	mutex_lock(&genpd->lock);
+	if (genpd->suspended_count == genpd->device_count) {
+		if (genpd->power_on) {
+			int ret = genpd->power_on(&genpd->domain);
+			if (ret) {
+				mutex_unlock(&genpd->lock);
+				return ret;
+			}
+		}
+	}
+	genpd->suspended_count--;
+	mutex_unlock(&genpd->lock);
+
+	if (genpd->start_device)
+		genpd->start_device(dev);
+
+	return 0;
+}
+
+/**
+ * pm_genpd_resume - Resume a device belonging to an I/O power domain.
+ * @dev: Device to resume.
+ *
+ * Resume a device under the assumption that its pwr_domain field points to the
+ * domain member of an object of type struct generic_power_domain representing
+ * a power domain consisting of I/O devices.
+ */
+static int pm_genpd_resume(struct device *dev)
+{
+	struct generic_power_domain *genpd;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	if (IS_ERR_OR_NULL(dev->pwr_domain))
+		return -EINVAL;
+
+	genpd = container_of(dev->pwr_domain,
+			     struct generic_power_domain, domain);
+
+	return genpd->power_is_off ? 0 : pm_generic_resume(dev);
+}
+
+/**
+ * pm_genpd_freeze - Freeze a device belonging to an I/O power domain.
+ * @dev: Device to freeze.
+ *
+ * Freeze a device under the assumption that its pwr_domain field points to the
+ * domain member of an object of type struct generic_power_domain representing
+ * a power domain consisting of I/O devices.
+ */
+static int pm_genpd_freeze(struct device *dev)
+{
+	struct generic_power_domain *genpd;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	if (IS_ERR_OR_NULL(dev->pwr_domain))
+		return -EINVAL;
+
+	genpd = container_of(dev->pwr_domain,
+			     struct generic_power_domain, domain);
+
+	if (genpd->power_is_off)
+		return 0;
+
+	/*
+	 * If the device is in the (runtime) "suspended" state, call
+	 * ->start_device() for it, if defined.
+	 */
+	pm_runtime_resume(dev);
+
+	return pm_generic_freeze(dev);
+}
+
+/**
+ * pm_genpd_freeze_noirq - Late freeze of a device from an I/O power domain.
+ * @dev: Device to freeze.
+ *
+ * Carry out a late freeze of a device under the assumption that its
+ * pwr_domain field points to the domain member of an object of type
+ * struct generic_power_domain representing a power domain consisting of I/O
+ * devices.
+ */
+static int pm_genpd_freeze_noirq(struct device *dev)
+{
+	struct generic_power_domain *genpd;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	if (IS_ERR_OR_NULL(dev->pwr_domain))
+		return -EINVAL;
+
+	genpd = container_of(dev->pwr_domain,
+			     struct generic_power_domain, domain);
+
+	if (!genpd->power_is_off && genpd->stop_device)
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
+ * pwr_domain field points to the domain member of an object of type
+ * struct generic_power_domain representing a power domain consisting of I/O
+ * devices.
+ */
+static int pm_genpd_thaw_noirq(struct device *dev)
+{
+	struct generic_power_domain *genpd;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	if (IS_ERR_OR_NULL(dev->pwr_domain))
+		return -EINVAL;
+
+	genpd = container_of(dev->pwr_domain,
+			     struct generic_power_domain, domain);
+
+	if (!genpd->power_is_off && genpd->start_device)
+		genpd->start_device(dev);
+
+	return 0;
+}
+
+/**
+ * pm_genpd_thaw - Thaw a device belonging to an I/O power domain.
+ * @dev: Device to thaw.
+ *
+ * Thaw a device under the assumption that its pwr_domain field points to the
+ * domain member of an object of type struct generic_power_domain representing
+ * a power domain consisting of I/O devices.
+ */
+static int pm_genpd_thaw(struct device *dev)
+{
+	struct generic_power_domain *genpd;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	if (IS_ERR_OR_NULL(dev->pwr_domain))
+		return -EINVAL;
+
+	genpd = container_of(dev->pwr_domain,
+			     struct generic_power_domain, domain);
+
+	return genpd->power_is_off ? 0 : pm_generic_thaw(dev);
+}
+
+/**
+ * pm_genpd_complete - Complete power transition of a device in a power domain.
+ * @dev: Device to complete the transition of.
+ *
+ * Complete a power transition of a device (during a system-wide power
+ * transition) under the assumption that its pwr_domain field points to the
+ * domain member of an object of type struct generic_power_domain representing
+ * a power domain consisting of I/O devices.
+ */
+static void pm_genpd_complete(struct device *dev)
+{
+	struct generic_power_domain *genpd;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	if (IS_ERR_OR_NULL(dev->pwr_domain))
+		return;
+
+	genpd = container_of(dev->pwr_domain,
+			     struct generic_power_domain, domain);
+
+	if (!genpd->power_is_off)
+		pm_generic_complete(dev);
+}
+
+#else
+
+#define pm_genpd_prepare	NULL
+#define pm_genpd_suspend	NULL
+#define pm_genpd_suspend_noirq	NULL
+#define pm_genpd_resume_noirq	NULL
+#define pm_genpd_resume		NULL
+#define pm_genpd_freeze		NULL
+#define pm_genpd_freeze_noirq	NULL
+#define pm_genpd_thaw_noirq	NULL
+#define pm_genpd_thaw		NULL
+#define pm_genpd_complete	NULL
+
+#endif /* CONFIG_PM_SLEEP */
+
 /**
  * pm_genpd_add_device - Add a device to an I/O power domain.
  * @genpd: Power domain to add the device to.
@@ -304,6 +614,7 @@ int pm_genpd_add_device(struct generic_p
 
 	dle->dev = dev;
 	list_add_tail(&dle->node, &genpd->device_list);
+	genpd->device_count++;
 
 	spin_lock_irq(&dev->power.lock);
 	dev->pwr_domain = &genpd->domain;
@@ -341,6 +652,7 @@ int pm_genpd_remove_device(struct generi
 		dev->pwr_domain = NULL;
 		spin_unlock_irq(&dev->power.lock);
 
+		genpd->device_count--;
 		list_del(&dle->node);
 		kfree(dle);
 
@@ -438,7 +750,23 @@ void pm_genpd_init(struct generic_power_
 	genpd->gov = gov;
 	genpd->in_progress = 0;
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
+	genpd->domain.ops.poweroff = pm_genpd_suspend;
+	genpd->domain.ops.poweroff_noirq = pm_genpd_suspend_noirq;
+	genpd->domain.ops.restore_noirq = pm_genpd_resume_noirq;
+	genpd->domain.ops.restore = pm_genpd_resume;
+	genpd->domain.ops.complete = pm_genpd_complete;
 }
Index: linux-2.6/include/linux/pm_domain.h
===================================================================
--- linux-2.6.orig/include/linux/pm_domain.h
+++ linux-2.6/include/linux/pm_domain.h
@@ -25,6 +25,8 @@ struct generic_power_domain {
 	struct dev_power_governor *gov;
 	unsigned int in_progress;
 	bool power_is_off;
+	unsigned int device_count;
+	unsigned int suspended_count;
 	int (*power_off)(struct dev_power_domain *domain);
 	int (*power_on)(struct dev_power_domain *domain);
 	int (*start_device)(struct device *dev);

