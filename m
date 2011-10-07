Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424Ab1JGEuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 00:50:12 -0400
Received: from [117.192.88.236] ([117.192.88.236]:50574 "EHLO manju-desktop"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753666Ab1JGEuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 00:50:10 -0400
To: linux-arm-kernel@lists.infradead.org
Date: Fri, 07 Oct 2011 10:05:24 +0500
Subject: [PATCH 2/5] drivercore: Add driver probe deferral mechanism
References: <1317962127-29003-1-git-send-email-manjugk@ti.com>
CC: Grant Likely <grant.likely@secretlab.ca>, linux-omap@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <greg@kroah.com>, Dilan Lee <dilee@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Message-ID: <1317962127-29003-3-git-send-email-manjugk@ti.com>
From: "G, Manjunath Kondaiah" <manjugk@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Grant Likely <grant.likely@secretlab.ca>

Allow drivers to report at probe time that they cannot get all the 
resources required by the device, and should be retried at a
later time.

This should completely solve the problem of getting devices
initialized in the right order.  Right now this is mostly handled by
mucking about with initcall ordering which is a complete hack, and
doesn't even remotely handle the case where device drivers are in
modules.  This approach completely sidesteps the issues by allowing
driver registration to occur in any order, and any driver can request
to be retried after a few more other drivers get probed.

Original patch posted by Grant Likely <grant.likely@secretlab.ca> at:
http://lwn.net/Articles/460522/

Enhancements to original patch by G, Manjunath Kondaiah <manjugk@ti.com>
 - checkpatch warning fixes
 - added Kconfig symbol CONFIG_PROBE_DEFER
 - replacing normal workqueue with singlethread_workqueue
 - handling -EPROBE_DEFER error

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: G, Manjunath Kondaiah <manjugk@ti.com>
---
Cc: linux-omap@vger.kernel.org
Cc: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Dilan Lee <dilee@nvidia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>

 drivers/base/Kconfig   |   11 ++++
 drivers/base/base.h    |    3 +
 drivers/base/core.c    |    6 ++
 drivers/base/dd.c      |  145 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h |    7 ++
 5 files changed, 172 insertions(+), 0 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 21cf46f..b412a71 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -172,6 +172,17 @@ config SYS_HYPERVISOR
 	bool
 	default n
 
+config PROBE_DEFER
+	bool "Deferred Driver Probe"
+	default y
+	help
+	  This option provides deferring driver probe if it has dependency on
+	  other driver. Without this feature, initcall ordering should be done
+	  manually to resolve driver dependencies. This feature completely side
+	  steps the issues by allowing driver registration to occur in any
+	  order, and any driver can request to be retried after a few more other
+	  drivers get probed.
+
 source "drivers/base/regmap/Kconfig"
 
 endmenu
diff --git a/drivers/base/base.h b/drivers/base/base.h
index a34dca0..95afe27 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -105,6 +105,9 @@ extern void bus_remove_driver(struct device_driver *drv);
 
 extern void driver_detach(struct device_driver *drv);
 extern int driver_probe_device(struct device_driver *drv, struct device *dev);
+#ifdef CONFIG_PROBE_DEFER
+extern void driver_deferred_probe_del(struct device *dev);
+#endif
 static inline int driver_match_device(struct device_driver *drv,
 				      struct device *dev)
 {
diff --git a/drivers/base/core.c b/drivers/base/core.c
index bc8729d..4ba8653 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -588,6 +588,9 @@ void device_initialize(struct device *dev)
 {
 	dev->kobj.kset = devices_kset;
 	kobject_init(&dev->kobj, &device_ktype);
+#ifdef CONFIG_PROBE_DEFER
+	INIT_LIST_HEAD(&dev->deferred_probe);
+#endif
 	INIT_LIST_HEAD(&dev->dma_pools);
 	mutex_init(&dev->mutex);
 	lockdep_set_novalidate_class(&dev->mutex);
@@ -1119,6 +1122,9 @@ void device_del(struct device *dev)
 	device_remove_file(dev, &uevent_attr);
 	device_remove_attrs(dev);
 	bus_remove_device(dev);
+#if defined CONFIG_PROBE_DEFER
+	driver_deferred_probe_del(dev);
+#endif
 
 	/*
 	 * Some platform devices are driven without driver attached
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 6658da7..f637da6 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -28,6 +28,136 @@
 #include "base.h"
 #include "power/power.h"
 
+#if defined CONFIG_PROBE_DEFER
+/*
+ * Deferred Probe infrastructure.
+ *
+ * Sometimes driver probe order matters, but the kernel doesn't always have
+ * dependency information which means some drivers will get probed before a
+ * resource it depends on is available.  For example, an SDHCI driver may
+ * first need a GPIO line from an i2c GPIO controller before it can be
+ * initialized.  If a required resource is not available yet, a driver can
+ * request probing to be deferred by returning -EPROBE_DEFER from its probe hook
+ *
+ * Deferred probe maintains two lists of devices, a pending list and an active
+ * list.  A driver returning -EPROBE_DEFER causes the device to be added to the
+ * pending list.
+ *
+ * The deferred_probe_mutex *must* be held any time the deferred_probe_*_list
+ * of the (struct device*)->deferred_probe pointers are manipulated
+ */
+static DEFINE_MUTEX(deferred_probe_mutex);
+static LIST_HEAD(deferred_probe_pending_list);
+static LIST_HEAD(deferred_probe_active_list);
+static struct workqueue_struct *deferred_wq;
+
+/**
+ * deferred_probe_work_func() - Retry probing devices in the active list.
+ */
+static void deferred_probe_work_func(struct work_struct *work)
+{
+	struct device *dev;
+	/*
+	 * This bit is tricky.  We want to process every device in the
+	 * deferred list, but devices can be removed from the list at any
+	 * time while inside this for-each loop.  There are two things that
+	 * need to be protected against:
+	 * - if the device is removed from the deferred_probe_list, then we
+	 *   loose our place in the loop.  Since any device can be removed
+	 *   asynchronously, list_for_each_entry_safe() wouldn't make things
+	 *   much better.  Simplest solution is to restart walking the list
+	 *   whenever the current device gets removed.  Not the most efficient,
+	 *   but is simple to implement and easy to audit for correctness.
+	 * - if the device is unregistered, and freed, then there is a risk
+	 *   of a null pointer dereference.  This code uses get/put_device()
+	 *   to ensure the device cannot disappear from under our feet.
+	 */
+	mutex_lock(&deferred_probe_mutex);
+	while (!list_empty(&deferred_probe_active_list)) {
+		dev = list_first_entry(&deferred_probe_active_list,
+					typeof(*dev), deferred_probe);
+		list_del_init(&dev->deferred_probe);
+
+		get_device(dev);
+
+		/* Drop the mutex while probing each device; the probe path
+		 * may manipulate the deferred list */
+		mutex_unlock(&deferred_probe_mutex);
+		dev_dbg(dev, "Retrying from deferred list\n");
+		bus_probe_device(dev);
+		mutex_lock(&deferred_probe_mutex);
+
+		put_device(dev);
+	}
+	mutex_unlock(&deferred_probe_mutex);
+}
+static DECLARE_WORK(deferred_probe_work, deferred_probe_work_func);
+
+static void driver_deferred_probe_add(struct device *dev)
+{
+	mutex_lock(&deferred_probe_mutex);
+	if (list_empty(&dev->deferred_probe)) {
+		dev_dbg(dev, "Added to deferred list\n");
+		list_add(&dev->deferred_probe, &deferred_probe_pending_list);
+	}
+	mutex_unlock(&deferred_probe_mutex);
+}
+
+void driver_deferred_probe_del(struct device *dev)
+{
+	mutex_lock(&deferred_probe_mutex);
+	if (!list_empty(&dev->deferred_probe)) {
+		dev_dbg(dev, "Removed from deferred list\n");
+		list_del_init(&dev->deferred_probe);
+	}
+	mutex_unlock(&deferred_probe_mutex);
+}
+
+static bool driver_deferred_probe_enable = false;
+/**
+ * driver_deferred_probe_trigger() - Kick off re-probing deferred devices
+ *
+ * This functions moves all devices from the pending list to the active
+ * list and schedules the deferred probe workqueue to process them.  It
+ * should be called anytime a driver is successfully bound to a device.
+ */
+static void driver_deferred_probe_trigger(void)
+{
+	if (!driver_deferred_probe_enable)
+		return;
+
+	/* A successful probe means that all the devices in the pending list
+	 * should be triggered to be reprobed.  Move all the deferred devices
+	 * into the active list so they can be retried by the workqueue */
+	mutex_lock(&deferred_probe_mutex);
+	list_splice_tail_init(&deferred_probe_pending_list,
+			      &deferred_probe_active_list);
+	mutex_unlock(&deferred_probe_mutex);
+
+	/* Kick the re-probe thread.  It may already be scheduled, but
+	 * it is safe to kick it again. */
+	queue_work(deferred_wq, &deferred_probe_work);
+}
+
+/**
+ * deferred_probe_initcall() - Enable probing of deferred devices
+ *
+ * We don't want to get in the way when the bulk of drivers are getting probed.
+ * Instead, this initcall makes sure that deferred probing is delayed until
+ * late_initcall time.
+ */
+static int deferred_probe_initcall(void)
+{
+	deferred_wq = create_singlethread_workqueue("deferwq");
+	if (deferred_wq == NULL)
+		return -1;
+
+	driver_deferred_probe_enable = true;
+	driver_deferred_probe_trigger();
+	return 0;
+}
+late_initcall(deferred_probe_initcall);
+#endif
 
 static void driver_bound(struct device *dev)
 {
@@ -42,6 +172,13 @@ static void driver_bound(struct device *dev)
 
 	klist_add_tail(&dev->p->knode_driver, &dev->driver->p->klist_devices);
 
+#if defined CONFIG_PROBE_DEFER
+	/* Make sure the device is no longer in one of the deferred lists
+	 * and kick off retrying all pending devices */
+	driver_deferred_probe_del(dev);
+	driver_deferred_probe_trigger();
+#endif
+
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 					     BUS_NOTIFY_BOUND_DRIVER, dev);
@@ -142,7 +279,15 @@ probe_failed:
 	driver_sysfs_remove(dev);
 	dev->driver = NULL;
 
+#if defined CONFIG_PROBE_DEFER
+	if (ret == -EPROBE_DEFER) {
+		/* Driver requested deferred probing */
+		dev_info(dev, "Driver %s requests probe deferral\n", drv->name);
+		driver_deferred_probe_add(dev);
+	} else if (ret != -ENODEV && ret != -ENXIO) {
+#else
 	if (ret != -ENODEV && ret != -ENXIO) {
+#endif
 		/* driver matched but the probe failed */
 		printk(KERN_WARNING
 		       "%s: probe of %s failed with error %d\n",
diff --git a/include/linux/device.h b/include/linux/device.h
index c20dfbf..f11963a 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -506,6 +506,10 @@ struct device_dma_parameters {
  * @mutex:	Mutex to synchronize calls to its driver.
  * @bus:	Type of bus device is on.
  * @driver:	Which driver has allocated this
+ * @deferred_probe: entry in deferred_probe_list which is used to retry the
+ *		binding of drivers which were unable to get all the resources
+ *		needed by the device; typically because it depends on another
+ *		driver getting probed first.
  * @platform_data: Platform data specific to the device.
  * 		Example: For devices on custom boards, as typical of embedded
  * 		and SOC based hardware, Linux often uses platform_data to point
@@ -564,6 +568,9 @@ struct device {
 	struct bus_type	*bus;		/* type of bus device is on */
 	struct device_driver *driver;	/* which driver has allocated this
 					   device */
+#if defined CONFIG_PROBE_DEFER
+	struct list_head	deferred_probe;
+#endif
 	void		*platform_data;	/* Platform specific data, device
 					   core doesn't touch it */
 	struct dev_pm_info	power;
-- 
1.7.4.1

