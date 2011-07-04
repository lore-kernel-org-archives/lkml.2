Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab1GDRMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 13:12:07 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60522 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757446Ab1GDRMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 13:12:02 -0400
Subject: [PATCH] drivercore: Add driver probe deferral mechanism
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "David S. Miller" <davem@davemloft.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 04 Jul 2011 11:11:59 -0600
Message-ID: <20110704170949.11059.92774.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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

This still is not tested, but I'd like to get early feedback on if
this is the correct approach.

v2: - added locking so it should no longer be utterly broken in that regard
    - remove device from deferred list at device_del time.
    - Still completely untested with any real use case, but has been boot tested.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

Mark, I'm particularly interested in your thoughts on this approach.
It is decidedly "low-tech" in its approach to handling device
dependencies, but it has the advantage of being simple and should
handle a wide range of use-cases reliably.  Would this work for ALSA
SoC probing?

g.


 drivers/base/base.h    |    1 +
 drivers/base/core.c    |    2 ++
 drivers/base/dd.c      |   64 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/device.h |    5 ++++
 4 files changed, 71 insertions(+), 1 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index a34dca0..9641309 100644
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
index bc8729d..0d37e18 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -588,6 +588,7 @@ void device_initialize(struct device *dev)
 {
 	dev->kobj.kset = devices_kset;
 	kobject_init(&dev->kobj, &device_ktype);
+	INIT_LIST_HEAD(&dev->deferred_probe);
 	INIT_LIST_HEAD(&dev->dma_pools);
 	mutex_init(&dev->mutex);
 	lockdep_set_novalidate_class(&dev->mutex);
@@ -1119,6 +1120,7 @@ void device_del(struct device *dev)
 	device_remove_file(dev, &uevent_attr);
 	device_remove_attrs(dev);
 	bus_remove_device(dev);
+	driver_deferred_probe_del(dev);
 
 	/*
 	 * Some platform devices are driven without driver attached
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 6658da7..ccbf3d3 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -28,6 +28,62 @@
 #include "base.h"
 #include "power/power.h"
 
+/**
+ * deferred_probe_work_func() - Retry probing devices in the deferred list.
+ */
+static DEFINE_MUTEX(deferred_probe_mutex);
+static LIST_HEAD(deferred_probe_list);
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
+	list_for_each_entry(dev, &deferred_probe_list, deferred_probe) {
+		bool removed;
+		get_device(dev);
+		mutex_unlock(&deferred_probe_mutex);
+
+		bus_probe_device(dev);
+
+		mutex_lock(&deferred_probe_mutex);
+		removed = list_empty(&dev->deferred_probe);
+		put_device(dev);
+		if (removed)
+			break;
+	}
+	mutex_unlock(&deferred_probe_mutex);
+}
+static DECLARE_WORK(deferred_probe_work, deferred_probe_work_func);
+
+static void driver_deferred_probe_add(struct device *dev)
+{
+	mutex_lock(&deferred_probe_mutex);
+	if (list_empty(&dev->deferred_probe))
+		list_add(&dev->deferred_probe, &deferred_probe_list);
+	mutex_unlock(&deferred_probe_mutex);
+}
+
+void driver_deferred_probe_del(struct device *dev)
+{
+	mutex_lock(&deferred_probe_mutex);
+	if (!list_empty(&dev->deferred_probe))
+		list_del_init(&dev->deferred_probe);
+	mutex_unlock(&deferred_probe_mutex);
+}
 
 static void driver_bound(struct device *dev)
 {
@@ -41,6 +97,8 @@ static void driver_bound(struct device *dev)
 		 __func__, dev->driver->name);
 
 	klist_add_tail(&dev->p->knode_driver, &dev->driver->p->klist_devices);
+	driver_deferred_probe_del(dev);
+	schedule_work(&deferred_probe_work);
 
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
@@ -142,7 +200,11 @@ probe_failed:
 	driver_sysfs_remove(dev);
 	dev->driver = NULL;
 
-	if (ret != -ENODEV && ret != -ENXIO) {
+	if (ret == -EAGAIN) {
+		/* Driver requested deferred probing */
+		dev_info(dev, "Driver %s requests probe deferral\n", drv->name);
+		driver_deferred_probe_add(dev);
+	} else if (ret != -ENODEV && ret != -ENXIO) {
 		/* driver matched but the probe failed */
 		printk(KERN_WARNING
 		       "%s: probe of %s failed with error %d\n",
diff --git a/include/linux/device.h b/include/linux/device.h
index e4f62d8..b44a3b1 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -506,6 +506,10 @@ struct device_dma_parameters {
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
@@ -564,6 +568,7 @@ struct device {
 	struct bus_type	*bus;		/* type of bus device is on */
 	struct device_driver *driver;	/* which driver has allocated this
 					   device */
+	struct list_head	deferred_probe;
 	void		*platform_data;	/* Platform specific data, device
 					   core doesn't touch it */
 	struct dev_pm_info	power;

