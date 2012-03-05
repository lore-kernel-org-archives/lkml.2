Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab2CEPru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 10:47:50 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:44774 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab2CEPrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 10:47:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of glikely@secretlab.ca designates 10.68.244.99 as permitted sender) smtp.mail=glikely@secretlab.ca
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>, Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>, Dilan Lee <dilee@nvidia.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] drivercore: Add driver probe deferral mechanism
Date: Mon,  5 Mar 2012 08:47:41 -0700
Message-Id: <1330962461-9061-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow drivers to report at probe time that they cannot get all the resources
required by the device, and should be retried at a later time.

This should completely solve the problem of getting devices
initialized in the right order.  Right now this is mostly handled by
mucking about with initcall ordering which is a complete hack, and
doesn't even remotely handle the case where device drivers are in
modules.  This approach completely sidesteps the issues by allowing
driver registration to occur in any order, and any driver can request
to be retried after a few more other drivers get probed.

v4: - Integrate Manjunath's addition of a separate workqueue
    - Change -EAGAIN to -EPROBE_DEFER for drivers to trigger deferral
    - Update comment blocks to reflect how the code really works
v3: - Hold off workqueue scheduling until late_initcall so that the bulk
      of driver probes are complete before we start retrying deferred devices.
    - Tested with simple use cases.  Still needs more testing though.
      Using it to get rid of the gpio early_initcall madness, or to replace
      the ASoC internal probe deferral code would be ideal.
v2: - added locking so it should no longer be utterly broken in that regard
    - remove device from deferred list at device_del time.
    - Still completely untested with any real use case, but has been
      boot tested.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dilan Lee <dilee@nvidia.com>
Cc: Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Tony Lindgren <tony@atomide.com>
---

Hi Greg,

This has been through several revisions now and I think it's ready to go
in.  The summary from the last discussion is that users need to have the
dpm_list order adjusted if they defer themselves, but that is something
which just cannot be performed by the core code (It needs to be manipulated
mid-probe() call).

I know that not everybody is happy with this approach, but I've yet to
see a better alternative.  However, it is *really easy* to find all the
users of deferred probe since any user must return -EPROBE_DEFER explicitly.
If/when a better approach is found, all the users will be easy to find
and modify.

If this patch is not merged, then I'm going to have to merge another round
of patches that futz with initcall ordering to get some drivers to probe
correctly.  :-(

g.

 drivers/base/base.h    |    1 +
 drivers/base/core.c    |    2 +
 drivers/base/dd.c      |  138 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/device.h |    5 ++
 include/linux/errno.h  |    1 +
 5 files changed, 146 insertions(+), 1 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index b858dfd..2c13dea 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -105,6 +105,7 @@ extern void bus_remove_driver(struct device_driver *drv);
 
 extern void driver_detach(struct device_driver *drv);
 extern int driver_probe_device(struct device_driver *drv, struct device *dev);
+extern void driver_deferred_probe_del(struct device *dev);
 static inline int driver_match_device(struct device_driver *drv,
 				      struct device *dev)
 {
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 74dda4f..d4ff7ad 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -644,6 +644,7 @@ void device_initialize(struct device *dev)
 {
 	dev->kobj.kset = devices_kset;
 	kobject_init(&dev->kobj, &device_ktype);
+	INIT_LIST_HEAD(&dev->deferred_probe);
 	INIT_LIST_HEAD(&dev->dma_pools);
 	mutex_init(&dev->mutex);
 	lockdep_set_novalidate_class(&dev->mutex);
@@ -1188,6 +1189,7 @@ void device_del(struct device *dev)
 	device_remove_file(dev, &uevent_attr);
 	device_remove_attrs(dev);
 	bus_remove_device(dev);
+	driver_deferred_probe_del(dev);
 
 	/*
 	 * Some platform devices are driven without driver attached
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 142e3d600..442b764 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -28,6 +28,133 @@
 #include "base.h"
 #include "power/power.h"
 
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
+ * pending list.  A successful driver probe will trigger moving all devices
+ * from the pending to the active list so that the workqueue will eventually
+ * retry them.
+ *
+ * The deferred_probe_mutex must be held any time the deferred_probe_*_list
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
+	 * This block processes every device in the deferred 'active' list.
+	 * Each device is removed from the active list and passed to
+	 * bus_probe_device() to re-attempt the probe.  The loop continues
+	 * until every device in the active list is removed and retried.
+	 *
+	 * Note: Once the device is removed from the list and the mutex is
+	 * released, it is possible for the device get freed by another thread
+	 * and cause a illegal pointer dereference.  This code uses
+	 * get/put_device() to ensure the device structure cannot disappear
+	 * from under our feet.
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
+	if (WARN_ON(!deferred_wq))
+		return -ENOMEM;
+
+	driver_deferred_probe_enable = true;
+	driver_deferred_probe_trigger();
+	return 0;
+}
+late_initcall(deferred_probe_initcall);
 
 static void driver_bound(struct device *dev)
 {
@@ -42,6 +169,11 @@ static void driver_bound(struct device *dev)
 
 	klist_add_tail(&dev->p->knode_driver, &dev->driver->p->klist_devices);
 
+	/* Make sure the device is no longer in one of the deferred lists
+	 * and kick off retrying all pending devices */
+	driver_deferred_probe_del(dev);
+	driver_deferred_probe_trigger();
+
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 					     BUS_NOTIFY_BOUND_DRIVER, dev);
@@ -142,7 +274,11 @@ probe_failed:
 	driver_sysfs_remove(dev);
 	dev->driver = NULL;
 
-	if (ret != -ENODEV && ret != -ENXIO) {
+	if (ret == -EPROBE_DEFER) {
+		/* Driver requested deferred probing */
+		dev_info(dev, "Driver %s requests probe deferral\n", drv->name);
+		driver_deferred_probe_add(dev);
+	} else if (ret != -ENODEV && ret != -ENXIO) {
 		/* driver matched but the probe failed */
 		printk(KERN_WARNING
 		       "%s: probe of %s failed with error %d\n",
diff --git a/include/linux/device.h b/include/linux/device.h
index b63fb39..adf090d 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -587,6 +587,10 @@ struct device_dma_parameters {
  * @mutex:	Mutex to synchronize calls to its driver.
  * @bus:	Type of bus device is on.
  * @driver:	Which driver has allocated this
+ * @deferred_probe: entry in deferred_probe_list which is used to retry the
+ * 		binding of drivers which were unable to get all the resources
+ * 		needed by the device; typically because it depends on another
+ * 		driver getting probed first.
  * @platform_data: Platform data specific to the device.
  * 		Example: For devices on custom boards, as typical of embedded
  * 		and SOC based hardware, Linux often uses platform_data to point
@@ -646,6 +650,7 @@ struct device {
 	struct bus_type	*bus;		/* type of bus device is on */
 	struct device_driver *driver;	/* which driver has allocated this
 					   device */
+	struct list_head	deferred_probe;
 	void		*platform_data;	/* Platform specific data, device
 					   core doesn't touch it */
 	struct dev_pm_info	power;
diff --git a/include/linux/errno.h b/include/linux/errno.h
index 4668583..2d09bfa 100644
--- a/include/linux/errno.h
+++ b/include/linux/errno.h
@@ -16,6 +16,7 @@
 #define ERESTARTNOHAND	514	/* restart if no handler.. */
 #define ENOIOCTLCMD	515	/* No ioctl command */
 #define ERESTART_RESTARTBLOCK 516 /* restart by calling sys_restart_syscall */
+#define EPROBE_DEFER	517	/* Driver requests probe retry */
 
 /* Defined for the NFSv3 protocol */
 #define EBADHANDLE	521	/* Illegal NFS file handle */
-- 
1.7.9

