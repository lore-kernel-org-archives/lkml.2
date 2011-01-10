Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab1AJUKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 15:10:49 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:34627 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab1AJUKr (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 10 Jan 2011 15:10:47 -0500
Date: Mon, 10 Jan 2011 15:10:00 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
        Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: [GIT PULL] (xen) stable/xenbus for 2.6.38
Message-ID: <20110110201000.GA14157@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Linus,

Please pull the following git tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/xenbus

which has patches since git commit cf7d7e5a1980d1116ee152d25dac382b112b9c17
Linus Torvalds (1):
      Linux 2.6.37-rc5

The patchset makes the XenBus infrastructure more generic and enhances the
XenBus API to handle Xen backends (registration, watching for events, etc).
The XenBus is an "abstraction mechanism for paravirtualised drivers to
communicate between domains [..] and in general is used for configuration
negotiation" (http://wiki.xensource.com/xenwiki/XenBus).

This allows backend drivers, such as the networking, pci, etc to have the
appropriate infrastructure calls to service guest domains.

The backends that we have in the pipeline are the pci backend and the
networking. They are going through the review so they will have to wait
till the next merge window.

The benefit of pulling this git tree:
 - Allow Xen backends to work (these are the "other side" of the 
   Xen frontend drivers that have in the kernel for a long time). 
 - Cleanup of general XenBus code.
 - Modularize the XenBus frontend.

The shortlog:

Ian Campbell (3):
      xen: separate out frontend xenbus
      xen: add backend driver support
      xen/xenbus: fixup checkpatch issues in xenbus_probe*

Jeremy Fitzhardinge (11):
      xen: remove xen/evtchn.h
      xenbus/frontend: register bus earlier
      xen/xenbus: make sure backend bus is registered earlier
      xen/xenbus: make frontend bus GPL
      xen/xenbus: clean up error handling
      xen/xenbus: cleanup debug noise in xenbus_comms.c
      xen/xenbus: clean up noise in xenbus_probe.c
      xen/xenbus: clean up noise in xenbus_probe_backend.c
      xen/xenbus: clean up noise in xenbus_probe_frontend.c
      xen/netfront: select XEN_XENBUS_FRONTEND
      xen/xenbus: making backend support modular is too complex

Konrad Rzeszutek Wilk (1):
      xen/pci: Make xen-pcifront be dependent on XEN_XENBUS_FRONTEND

And the diffstat:

 drivers/block/Kconfig                      |    1 +
 drivers/net/Kconfig                        |    1 +
 drivers/pci/Kconfig                        |    1 +
 drivers/xen/Kconfig                        |   11 +
 drivers/xen/xenbus/Makefile                |    5 +
 drivers/xen/xenbus/xenbus_probe.c          |  351 +++++-----------------------
 drivers/xen/xenbus/xenbus_probe.h          |   31 ++--
 drivers/xen/xenbus/xenbus_probe_backend.c  |  276 ++++++++++++++++++++++
 drivers/xen/xenbus/xenbus_probe_frontend.c |  294 +++++++++++++++++++++++
 include/xen/xenbus.h                       |    2 +-
 10 files changed, 661 insertions(+), 312 deletions(-)

And the patches all squashed in one:

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 4b9359a..83c32cb 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -464,6 +464,7 @@ config XEN_BLKDEV_FRONTEND
 	tristate "Xen virtual block device support"
 	depends on XEN
 	default y
+	select XEN_XENBUS_FRONTEND
 	help
 	  This driver implements the front-end of the Xen virtual
 	  block device driver.  It communicates with a back-end driver
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 4f1755b..cbf0635 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2960,6 +2960,7 @@ config TILE_NET
 config XEN_NETDEV_FRONTEND
 	tristate "Xen network device frontend driver"
 	depends on XEN
+	select XEN_XENBUS_FRONTEND
 	default y
 	help
 	  The network device frontend driver allows the kernel to
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 5b1630e..a9523fd 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -45,6 +45,7 @@ config XEN_PCIDEV_FRONTEND
         depends on PCI && X86 && XEN
         select HOTPLUG
         select PCI_XEN
+	select XEN_XENBUS_FRONTEND
         default y
         help
           The PCI device frontend driver allows the kernel to import arbitrary
diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 6e6180c..5a48ce9 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -29,6 +29,14 @@ config XEN_DEV_EVTCHN
 	  firing.
 	  If in doubt, say yes.
 
+config XEN_BACKEND
+	bool "Backend driver support"
+	depends on XEN_DOM0
+	default y
+	help
+	  Support for backend device drivers that provide I/O services
+	  to other virtual machines.
+
 config XENFS
 	tristate "Xen filesystem"
 	default y
@@ -62,6 +70,9 @@ config XEN_SYS_HYPERVISOR
 	 virtual environment, /sys/hypervisor will still be present,
 	 but will have no xen contents.
 
+config XEN_XENBUS_FRONTEND
+       tristate
+
 config XEN_PLATFORM_PCI
 	tristate "xen platform pci device driver"
 	depends on XEN_PVHVM
diff --git a/drivers/xen/xenbus/Makefile b/drivers/xen/xenbus/Makefile
index 5571f5b..8dca685 100644
--- a/drivers/xen/xenbus/Makefile
+++ b/drivers/xen/xenbus/Makefile
@@ -5,3 +5,8 @@ xenbus-objs += xenbus_client.o
 xenbus-objs += xenbus_comms.o
 xenbus-objs += xenbus_xs.o
 xenbus-objs += xenbus_probe.o
+
+xenbus-be-objs-$(CONFIG_XEN_BACKEND) += xenbus_probe_backend.o
+xenbus-objs += $(xenbus-be-objs-y)
+
+obj-$(CONFIG_XEN_XENBUS_FRONTEND) += xenbus_probe_frontend.o
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index deb9c4b..baa65e7 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -56,7 +56,6 @@
 #include <xen/events.h>
 #include <xen/page.h>
 
-#include <xen/platform_pci.h>
 #include <xen/hvm.h>
 
 #include "xenbus_comms.h"
@@ -73,15 +72,6 @@ static unsigned long xen_store_mfn;
 
 static BLOCKING_NOTIFIER_HEAD(xenstore_chain);
 
-static void wait_for_devices(struct xenbus_driver *xendrv);
-
-static int xenbus_probe_frontend(const char *type, const char *name);
-
-static void xenbus_dev_shutdown(struct device *_dev);
-
-static int xenbus_dev_suspend(struct device *dev, pm_message_t state);
-static int xenbus_dev_resume(struct device *dev);
-
 /* If something in array of ids matches this device, return it. */
 static const struct xenbus_device_id *
 match_device(const struct xenbus_device_id *arr, struct xenbus_device *dev)
@@ -102,34 +92,7 @@ int xenbus_match(struct device *_dev, struct device_driver *_drv)
 
 	return match_device(drv->ids, to_xenbus_device(_dev)) != NULL;
 }
-
-static int xenbus_uevent(struct device *_dev, struct kobj_uevent_env *env)
-{
-	struct xenbus_device *dev = to_xenbus_device(_dev);
-
-	if (add_uevent_var(env, "MODALIAS=xen:%s", dev->devicetype))
-		return -ENOMEM;
-
-	return 0;
-}
-
-/* device/<type>/<id> => <type>-<id> */
-static int frontend_bus_id(char bus_id[XEN_BUS_ID_SIZE], const char *nodename)
-{
-	nodename = strchr(nodename, '/');
-	if (!nodename || strlen(nodename + 1) >= XEN_BUS_ID_SIZE) {
-		printk(KERN_WARNING "XENBUS: bad frontend %s\n", nodename);
-		return -EINVAL;
-	}
-
-	strlcpy(bus_id, nodename + 1, XEN_BUS_ID_SIZE);
-	if (!strchr(bus_id, '/')) {
-		printk(KERN_WARNING "XENBUS: bus_id %s no slash\n", bus_id);
-		return -EINVAL;
-	}
-	*strchr(bus_id, '/') = '-';
-	return 0;
-}
+EXPORT_SYMBOL_GPL(xenbus_match);
 
 
 static void free_otherend_details(struct xenbus_device *dev)
@@ -149,7 +112,30 @@ static void free_otherend_watch(struct xenbus_device *dev)
 }
 
 
-int read_otherend_details(struct xenbus_device *xendev,
+static int talk_to_otherend(struct xenbus_device *dev)
+{
+	struct xenbus_driver *drv = to_xenbus_driver(dev->dev.driver);
+
+	free_otherend_watch(dev);
+	free_otherend_details(dev);
+
+	return drv->read_otherend_details(dev);
+}
+
+
+
+static int watch_otherend(struct xenbus_device *dev)
+{
+	struct xen_bus_type *bus =
+		container_of(dev->dev.bus, struct xen_bus_type, bus);
+
+	return xenbus_watch_pathfmt(dev, &dev->otherend_watch,
+				    bus->otherend_changed,
+				    "%s/%s", dev->otherend, "state");
+}
+
+
+int xenbus_read_otherend_details(struct xenbus_device *xendev,
 				 char *id_node, char *path_node)
 {
 	int err = xenbus_gather(XBT_NIL, xendev->nodename,
@@ -174,39 +160,11 @@ int read_otherend_details(struct xenbus_device *xendev,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(xenbus_read_otherend_details);
 
-
-static int read_backend_details(struct xenbus_device *xendev)
-{
-	return read_otherend_details(xendev, "backend-id", "backend");
-}
-
-static struct device_attribute xenbus_dev_attrs[] = {
-	__ATTR_NULL
-};
-
-/* Bus type for frontend drivers. */
-static struct xen_bus_type xenbus_frontend = {
-	.root = "device",
-	.levels = 2, 		/* device/type/<id> */
-	.get_bus_id = frontend_bus_id,
-	.probe = xenbus_probe_frontend,
-	.bus = {
-		.name      = "xen",
-		.match     = xenbus_match,
-		.uevent    = xenbus_uevent,
-		.probe     = xenbus_dev_probe,
-		.remove    = xenbus_dev_remove,
-		.shutdown  = xenbus_dev_shutdown,
-		.dev_attrs = xenbus_dev_attrs,
-
-		.suspend   = xenbus_dev_suspend,
-		.resume    = xenbus_dev_resume,
-	},
-};
-
-static void otherend_changed(struct xenbus_watch *watch,
-			     const char **vec, unsigned int len)
+void xenbus_otherend_changed(struct xenbus_watch *watch,
+			     const char **vec, unsigned int len,
+			     int ignore_on_shutdown)
 {
 	struct xenbus_device *dev =
 		container_of(watch, struct xenbus_device, otherend_watch);
@@ -234,11 +192,7 @@ static void otherend_changed(struct xenbus_watch *watch,
 	 * work that can fail e.g., when the rootfs is gone.
 	 */
 	if (system_state > SYSTEM_RUNNING) {
-		struct xen_bus_type *bus = bus;
-		bus = container_of(dev->dev.bus, struct xen_bus_type, bus);
-		/* If we're frontend, drive the state machine to Closed. */
-		/* This should cause the backend to release our resources. */
-		if ((bus == &xenbus_frontend) && (state == XenbusStateClosing))
+		if (ignore_on_shutdown && (state == XenbusStateClosing))
 			xenbus_frontend_closed(dev);
 		return;
 	}
@@ -246,25 +200,7 @@ static void otherend_changed(struct xenbus_watch *watch,
 	if (drv->otherend_changed)
 		drv->otherend_changed(dev, state);
 }
-
-
-static int talk_to_otherend(struct xenbus_device *dev)
-{
-	struct xenbus_driver *drv = to_xenbus_driver(dev->dev.driver);
-
-	free_otherend_watch(dev);
-	free_otherend_details(dev);
-
-	return drv->read_otherend_details(dev);
-}
-
-
-static int watch_otherend(struct xenbus_device *dev)
-{
-	return xenbus_watch_pathfmt(dev, &dev->otherend_watch, otherend_changed,
-				    "%s/%s", dev->otherend, "state");
-}
-
+EXPORT_SYMBOL_GPL(xenbus_otherend_changed);
 
 int xenbus_dev_probe(struct device *_dev)
 {
@@ -308,8 +244,9 @@ int xenbus_dev_probe(struct device *_dev)
 fail:
 	xenbus_dev_error(dev, err, "xenbus_dev_probe on %s", dev->nodename);
 	xenbus_switch_state(dev, XenbusStateClosed);
-	return -ENODEV;
+	return err;
 }
+EXPORT_SYMBOL_GPL(xenbus_dev_probe);
 
 int xenbus_dev_remove(struct device *_dev)
 {
@@ -327,8 +264,9 @@ int xenbus_dev_remove(struct device *_dev)
 	xenbus_switch_state(dev, XenbusStateClosed);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(xenbus_dev_remove);
 
-static void xenbus_dev_shutdown(struct device *_dev)
+void xenbus_dev_shutdown(struct device *_dev)
 {
 	struct xenbus_device *dev = to_xenbus_device(_dev);
 	unsigned long timeout = 5*HZ;
@@ -349,6 +287,7 @@ static void xenbus_dev_shutdown(struct device *_dev)
  out:
 	put_device(&dev->dev);
 }
+EXPORT_SYMBOL_GPL(xenbus_dev_shutdown);
 
 int xenbus_register_driver_common(struct xenbus_driver *drv,
 				  struct xen_bus_type *bus,
@@ -362,25 +301,7 @@ int xenbus_register_driver_common(struct xenbus_driver *drv,
 
 	return driver_register(&drv->driver);
 }
-
-int __xenbus_register_frontend(struct xenbus_driver *drv,
-			       struct module *owner, const char *mod_name)
-{
-	int ret;
-
-	drv->read_otherend_details = read_backend_details;
-
-	ret = xenbus_register_driver_common(drv, &xenbus_frontend,
-					    owner, mod_name);
-	if (ret)
-		return ret;
-
-	/* If this driver is loaded as a module wait for devices to attach. */
-	wait_for_devices(drv);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(__xenbus_register_frontend);
+EXPORT_SYMBOL_GPL(xenbus_register_driver_common);
 
 void xenbus_unregister_driver(struct xenbus_driver *drv)
 {
@@ -551,24 +472,7 @@ fail:
 	kfree(xendev);
 	return err;
 }
-
-/* device/<typename>/<name> */
-static int xenbus_probe_frontend(const char *type, const char *name)
-{
-	char *nodename;
-	int err;
-
-	nodename = kasprintf(GFP_KERNEL, "%s/%s/%s",
-			     xenbus_frontend.root, type, name);
-	if (!nodename)
-		return -ENOMEM;
-
-	DPRINTK("%s", nodename);
-
-	err = xenbus_probe_node(&xenbus_frontend, type, nodename);
-	kfree(nodename);
-	return err;
-}
+EXPORT_SYMBOL_GPL(xenbus_probe_node);
 
 static int xenbus_probe_device_type(struct xen_bus_type *bus, const char *type)
 {
@@ -582,10 +486,11 @@ static int xenbus_probe_device_type(struct xen_bus_type *bus, const char *type)
 		return PTR_ERR(dir);
 
 	for (i = 0; i < dir_n; i++) {
-		err = bus->probe(type, dir[i]);
+		err = bus->probe(bus, type, dir[i]);
 		if (err)
 			break;
 	}
+
 	kfree(dir);
 	return err;
 }
@@ -605,9 +510,11 @@ int xenbus_probe_devices(struct xen_bus_type *bus)
 		if (err)
 			break;
 	}
+
 	kfree(dir);
 	return err;
 }
+EXPORT_SYMBOL_GPL(xenbus_probe_devices);
 
 static unsigned int char_count(const char *str, char c)
 {
@@ -670,32 +577,18 @@ void xenbus_dev_changed(const char *node, struct xen_bus_type *bus)
 }
 EXPORT_SYMBOL_GPL(xenbus_dev_changed);
 
-static void frontend_changed(struct xenbus_watch *watch,
-			     const char **vec, unsigned int len)
-{
-	DPRINTK("");
-
-	xenbus_dev_changed(vec[XS_WATCH_PATH], &xenbus_frontend);
-}
-
-/* We watch for devices appearing and vanishing. */
-static struct xenbus_watch fe_watch = {
-	.node = "device",
-	.callback = frontend_changed,
-};
-
-static int xenbus_dev_suspend(struct device *dev, pm_message_t state)
+int xenbus_dev_suspend(struct device *dev, pm_message_t state)
 {
 	int err = 0;
 	struct xenbus_driver *drv;
-	struct xenbus_device *xdev;
+	struct xenbus_device *xdev
+		= container_of(dev, struct xenbus_device, dev);
 
-	DPRINTK("");
+	DPRINTK("%s", xdev->nodename);
 
 	if (dev->driver == NULL)
 		return 0;
 	drv = to_xenbus_driver(dev->driver);
-	xdev = container_of(dev, struct xenbus_device, dev);
 	if (drv->suspend)
 		err = drv->suspend(xdev, state);
 	if (err)
@@ -703,21 +596,20 @@ static int xenbus_dev_suspend(struct device *dev, pm_message_t state)
 		       "xenbus: suspend %s failed: %i\n", dev_name(dev), err);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(xenbus_dev_suspend);
 
-static int xenbus_dev_resume(struct device *dev)
+int xenbus_dev_resume(struct device *dev)
 {
 	int err;
 	struct xenbus_driver *drv;
-	struct xenbus_device *xdev;
+	struct xenbus_device *xdev
+		= container_of(dev, struct xenbus_device, dev);
 
-	DPRINTK("");
+	DPRINTK("%s", xdev->nodename);
 
 	if (dev->driver == NULL)
 		return 0;
-
 	drv = to_xenbus_driver(dev->driver);
-	xdev = container_of(dev, struct xenbus_device, dev);
-
 	err = talk_to_otherend(xdev);
 	if (err) {
 		printk(KERN_WARNING
@@ -748,6 +640,7 @@ static int xenbus_dev_resume(struct device *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(xenbus_dev_resume);
 
 /* A flag to determine if xenstored is 'ready' (i.e. has started) */
 int xenstored_ready = 0;
@@ -776,11 +669,6 @@ void xenbus_probe(struct work_struct *unused)
 {
 	xenstored_ready = 1;
 
-	/* Enumerate devices in xenstore and watch for changes. */
-	xenbus_probe_devices(&xenbus_frontend);
-	register_xenbus_watch(&fe_watch);
-	xenbus_backend_probe_and_watch();
-
 	/* Notify others that xenstore is up */
 	blocking_notifier_call_chain(&xenstore_chain, 0, NULL);
 }
@@ -809,16 +697,7 @@ static int __init xenbus_init(void)
 
 	err = -ENODEV;
 	if (!xen_domain())
-		goto out_error;
-
-	/* Register ourselves with the kernel bus subsystem */
-	err = bus_register(&xenbus_frontend.bus);
-	if (err)
-		goto out_error;
-
-	err = xenbus_backend_bus_register();
-	if (err)
-		goto out_unreg_front;
+		return err;
 
 	/*
 	 * Domain0 doesn't have a store_evtchn or store_mfn yet.
@@ -874,7 +753,7 @@ static int __init xenbus_init(void)
 	if (err) {
 		printk(KERN_WARNING
 		       "XENBUS: Error initializing xenstore comms: %i\n", err);
-		goto out_unreg_back;
+		goto out_error;
 	}
 
 #ifdef CONFIG_XEN_COMPAT_XENFS
@@ -887,133 +766,13 @@ static int __init xenbus_init(void)
 
 	return 0;
 
-  out_unreg_back:
-	xenbus_backend_bus_unregister();
-
-  out_unreg_front:
-	bus_unregister(&xenbus_frontend.bus);
-
   out_error:
 	if (page != 0)
 		free_page(page);
+
 	return err;
 }
 
 postcore_initcall(xenbus_init);
 
 MODULE_LICENSE("GPL");
-
-static int is_device_connecting(struct device *dev, void *data)
-{
-	struct xenbus_device *xendev = to_xenbus_device(dev);
-	struct device_driver *drv = data;
-	struct xenbus_driver *xendrv;
-
-	/*
-	 * A device with no driver will never connect. We care only about
-	 * devices which should currently be in the process of connecting.
-	 */
-	if (!dev->driver)
-		return 0;
-
-	/* Is this search limited to a particular driver? */
-	if (drv && (dev->driver != drv))
-		return 0;
-
-	xendrv = to_xenbus_driver(dev->driver);
-	return (xendev->state < XenbusStateConnected ||
-		(xendev->state == XenbusStateConnected &&
-		 xendrv->is_ready && !xendrv->is_ready(xendev)));
-}
-
-static int exists_connecting_device(struct device_driver *drv)
-{
-	return bus_for_each_dev(&xenbus_frontend.bus, NULL, drv,
-				is_device_connecting);
-}
-
-static int print_device_status(struct device *dev, void *data)
-{
-	struct xenbus_device *xendev = to_xenbus_device(dev);
-	struct device_driver *drv = data;
-
-	/* Is this operation limited to a particular driver? */
-	if (drv && (dev->driver != drv))
-		return 0;
-
-	if (!dev->driver) {
-		/* Information only: is this too noisy? */
-		printk(KERN_INFO "XENBUS: Device with no driver: %s\n",
-		       xendev->nodename);
-	} else if (xendev->state < XenbusStateConnected) {
-		enum xenbus_state rstate = XenbusStateUnknown;
-		if (xendev->otherend)
-			rstate = xenbus_read_driver_state(xendev->otherend);
-		printk(KERN_WARNING "XENBUS: Timeout connecting "
-		       "to device: %s (local state %d, remote state %d)\n",
-		       xendev->nodename, xendev->state, rstate);
-	}
-
-	return 0;
-}
-
-/* We only wait for device setup after most initcalls have run. */
-static int ready_to_wait_for_devices;
-
-/*
- * On a 5-minute timeout, wait for all devices currently configured.  We need
- * to do this to guarantee that the filesystems and / or network devices
- * needed for boot are available, before we can allow the boot to proceed.
- *
- * This needs to be on a late_initcall, to happen after the frontend device
- * drivers have been initialised, but before the root fs is mounted.
- *
- * A possible improvement here would be to have the tools add a per-device
- * flag to the store entry, indicating whether it is needed at boot time.
- * This would allow people who knew what they were doing to accelerate their
- * boot slightly, but of course needs tools or manual intervention to set up
- * those flags correctly.
- */
-static void wait_for_devices(struct xenbus_driver *xendrv)
-{
-	unsigned long start = jiffies;
-	struct device_driver *drv = xendrv ? &xendrv->driver : NULL;
-	unsigned int seconds_waited = 0;
-
-	if (!ready_to_wait_for_devices || !xen_domain())
-		return;
-
-	while (exists_connecting_device(drv)) {
-		if (time_after(jiffies, start + (seconds_waited+5)*HZ)) {
-			if (!seconds_waited)
-				printk(KERN_WARNING "XENBUS: Waiting for "
-				       "devices to initialise: ");
-			seconds_waited += 5;
-			printk("%us...", 300 - seconds_waited);
-			if (seconds_waited == 300)
-				break;
-		}
-
-		schedule_timeout_interruptible(HZ/10);
-	}
-
-	if (seconds_waited)
-		printk("\n");
-
-	bus_for_each_dev(&xenbus_frontend.bus, NULL, drv,
-			 print_device_status);
-}
-
-#ifndef MODULE
-static int __init boot_wait_for_devices(void)
-{
-	if (xen_hvm_domain() && !xen_platform_pci_unplug)
-		return -ENODEV;
-
-	ready_to_wait_for_devices = 1;
-	wait_for_devices(NULL);
-	return 0;
-}
-
-late_initcall(boot_wait_for_devices);
-#endif
diff --git a/drivers/xen/xenbus/xenbus_probe.h b/drivers/xen/xenbus/xenbus_probe.h
index 6c5e318..2466581 100644
--- a/drivers/xen/xenbus/xenbus_probe.h
+++ b/drivers/xen/xenbus/xenbus_probe.h
@@ -36,26 +36,15 @@
 
 #define XEN_BUS_ID_SIZE			20
 
-#ifdef CONFIG_XEN_BACKEND
-extern void xenbus_backend_suspend(int (*fn)(struct device *, void *));
-extern void xenbus_backend_resume(int (*fn)(struct device *, void *));
-extern void xenbus_backend_probe_and_watch(void);
-extern int xenbus_backend_bus_register(void);
-extern void xenbus_backend_bus_unregister(void);
-#else
-static inline void xenbus_backend_suspend(int (*fn)(struct device *, void *)) {}
-static inline void xenbus_backend_resume(int (*fn)(struct device *, void *)) {}
-static inline void xenbus_backend_probe_and_watch(void) {}
-static inline int xenbus_backend_bus_register(void) { return 0; }
-static inline void xenbus_backend_bus_unregister(void) {}
-#endif
-
 struct xen_bus_type
 {
 	char *root;
 	unsigned int levels;
 	int (*get_bus_id)(char bus_id[XEN_BUS_ID_SIZE], const char *nodename);
-	int (*probe)(const char *type, const char *dir);
+	int (*probe)(struct xen_bus_type *bus, const char *type,
+		     const char *dir);
+	void (*otherend_changed)(struct xenbus_watch *watch, const char **vec,
+				 unsigned int len);
 	struct bus_type bus;
 };
 
@@ -73,4 +62,16 @@ extern int xenbus_probe_devices(struct xen_bus_type *bus);
 
 extern void xenbus_dev_changed(const char *node, struct xen_bus_type *bus);
 
+extern void xenbus_dev_shutdown(struct device *_dev);
+
+extern int xenbus_dev_suspend(struct device *dev, pm_message_t state);
+extern int xenbus_dev_resume(struct device *dev);
+
+extern void xenbus_otherend_changed(struct xenbus_watch *watch,
+				    const char **vec, unsigned int len,
+				    int ignore_on_shutdown);
+
+extern int xenbus_read_otherend_details(struct xenbus_device *xendev,
+					char *id_node, char *path_node);
+
 #endif
diff --git a/drivers/xen/xenbus/xenbus_probe_backend.c b/drivers/xen/xenbus/xenbus_probe_backend.c
new file mode 100644
index 0000000..6cf467b
--- /dev/null
+++ b/drivers/xen/xenbus/xenbus_probe_backend.c
@@ -0,0 +1,276 @@
+/******************************************************************************
+ * Talks to Xen Store to figure out what devices we have (backend half).
+ *
+ * Copyright (C) 2005 Rusty Russell, IBM Corporation
+ * Copyright (C) 2005 Mike Wray, Hewlett-Packard
+ * Copyright (C) 2005, 2006 XenSource Ltd
+ * Copyright (C) 2007 Solarflare Communications, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ */
+
+#define DPRINTK(fmt, args...)				\
+	pr_debug("xenbus_probe (%s:%d) " fmt ".\n",	\
+		 __func__, __LINE__, ##args)
+
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <linux/fcntl.h>
+#include <linux/mm.h>
+#include <linux/notifier.h>
+
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <asm/xen/hypervisor.h>
+#include <asm/hypervisor.h>
+#include <xen/xenbus.h>
+#include <xen/features.h>
+
+#include "xenbus_comms.h"
+#include "xenbus_probe.h"
+
+/* backend/<type>/<fe-uuid>/<id> => <type>-<fe-domid>-<id> */
+static int backend_bus_id(char bus_id[XEN_BUS_ID_SIZE], const char *nodename)
+{
+	int domid, err;
+	const char *devid, *type, *frontend;
+	unsigned int typelen;
+
+	type = strchr(nodename, '/');
+	if (!type)
+		return -EINVAL;
+	type++;
+	typelen = strcspn(type, "/");
+	if (!typelen || type[typelen] != '/')
+		return -EINVAL;
+
+	devid = strrchr(nodename, '/') + 1;
+
+	err = xenbus_gather(XBT_NIL, nodename, "frontend-id", "%i", &domid,
+			    "frontend", NULL, &frontend,
+			    NULL);
+	if (err)
+		return err;
+	if (strlen(frontend) == 0)
+		err = -ERANGE;
+	if (!err && !xenbus_exists(XBT_NIL, frontend, ""))
+		err = -ENOENT;
+	kfree(frontend);
+
+	if (err)
+		return err;
+
+	if (snprintf(bus_id, XEN_BUS_ID_SIZE, "%.*s-%i-%s",
+		     typelen, type, domid, devid) >= XEN_BUS_ID_SIZE)
+		return -ENOSPC;
+	return 0;
+}
+
+static int xenbus_uevent_backend(struct device *dev,
+				 struct kobj_uevent_env *env)
+{
+	struct xenbus_device *xdev;
+	struct xenbus_driver *drv;
+	struct xen_bus_type *bus;
+
+	DPRINTK("");
+
+	if (dev == NULL)
+		return -ENODEV;
+
+	xdev = to_xenbus_device(dev);
+	bus = container_of(xdev->dev.bus, struct xen_bus_type, bus);
+	if (xdev == NULL)
+		return -ENODEV;
+
+	/* stuff we want to pass to /sbin/hotplug */
+	if (add_uevent_var(env, "XENBUS_TYPE=%s", xdev->devicetype))
+		return -ENOMEM;
+
+	if (add_uevent_var(env, "XENBUS_PATH=%s", xdev->nodename))
+		return -ENOMEM;
+
+	if (add_uevent_var(env, "XENBUS_BASE_PATH=%s", bus->root))
+		return -ENOMEM;
+
+	if (dev->driver) {
+		drv = to_xenbus_driver(dev->driver);
+		if (drv && drv->uevent)
+			return drv->uevent(xdev, env);
+	}
+
+	return 0;
+}
+
+/* backend/<typename>/<frontend-uuid>/<name> */
+static int xenbus_probe_backend_unit(struct xen_bus_type *bus,
+				     const char *dir,
+				     const char *type,
+				     const char *name)
+{
+	char *nodename;
+	int err;
+
+	nodename = kasprintf(GFP_KERNEL, "%s/%s", dir, name);
+	if (!nodename)
+		return -ENOMEM;
+
+	DPRINTK("%s\n", nodename);
+
+	err = xenbus_probe_node(bus, type, nodename);
+	kfree(nodename);
+	return err;
+}
+
+/* backend/<typename>/<frontend-domid> */
+static int xenbus_probe_backend(struct xen_bus_type *bus, const char *type,
+				const char *domid)
+{
+	char *nodename;
+	int err = 0;
+	char **dir;
+	unsigned int i, dir_n = 0;
+
+	DPRINTK("");
+
+	nodename = kasprintf(GFP_KERNEL, "%s/%s/%s", bus->root, type, domid);
+	if (!nodename)
+		return -ENOMEM;
+
+	dir = xenbus_directory(XBT_NIL, nodename, "", &dir_n);
+	if (IS_ERR(dir)) {
+		kfree(nodename);
+		return PTR_ERR(dir);
+	}
+
+	for (i = 0; i < dir_n; i++) {
+		err = xenbus_probe_backend_unit(bus, nodename, type, dir[i]);
+		if (err)
+			break;
+	}
+	kfree(dir);
+	kfree(nodename);
+	return err;
+}
+
+static void frontend_changed(struct xenbus_watch *watch,
+			    const char **vec, unsigned int len)
+{
+	xenbus_otherend_changed(watch, vec, len, 0);
+}
+
+static struct device_attribute xenbus_backend_dev_attrs[] = {
+	__ATTR_NULL
+};
+
+static struct xen_bus_type xenbus_backend = {
+	.root = "backend",
+	.levels = 3,		/* backend/type/<frontend>/<id> */
+	.get_bus_id = backend_bus_id,
+	.probe = xenbus_probe_backend,
+	.otherend_changed = frontend_changed,
+	.bus = {
+		.name		= "xen-backend",
+		.match		= xenbus_match,
+		.uevent		= xenbus_uevent_backend,
+		.probe		= xenbus_dev_probe,
+		.remove		= xenbus_dev_remove,
+		.shutdown	= xenbus_dev_shutdown,
+		.dev_attrs	= xenbus_backend_dev_attrs,
+	},
+};
+
+static void backend_changed(struct xenbus_watch *watch,
+			    const char **vec, unsigned int len)
+{
+	DPRINTK("");
+
+	xenbus_dev_changed(vec[XS_WATCH_PATH], &xenbus_backend);
+}
+
+static struct xenbus_watch be_watch = {
+	.node = "backend",
+	.callback = backend_changed,
+};
+
+static int read_frontend_details(struct xenbus_device *xendev)
+{
+	return xenbus_read_otherend_details(xendev, "frontend-id", "frontend");
+}
+
+int xenbus_dev_is_online(struct xenbus_device *dev)
+{
+	int rc, val;
+
+	rc = xenbus_scanf(XBT_NIL, dev->nodename, "online", "%d", &val);
+	if (rc != 1)
+		val = 0; /* no online node present */
+
+	return val;
+}
+EXPORT_SYMBOL_GPL(xenbus_dev_is_online);
+
+int __xenbus_register_backend(struct xenbus_driver *drv,
+			      struct module *owner, const char *mod_name)
+{
+	drv->read_otherend_details = read_frontend_details;
+
+	return xenbus_register_driver_common(drv, &xenbus_backend,
+					     owner, mod_name);
+}
+EXPORT_SYMBOL_GPL(__xenbus_register_backend);
+
+static int backend_probe_and_watch(struct notifier_block *notifier,
+				   unsigned long event,
+				   void *data)
+{
+	/* Enumerate devices in xenstore and watch for changes. */
+	xenbus_probe_devices(&xenbus_backend);
+	register_xenbus_watch(&be_watch);
+
+	return NOTIFY_DONE;
+}
+
+static int __init xenbus_probe_backend_init(void)
+{
+	static struct notifier_block xenstore_notifier = {
+		.notifier_call = backend_probe_and_watch
+	};
+	int err;
+
+	DPRINTK("");
+
+	/* Register ourselves with the kernel bus subsystem */
+	err = bus_register(&xenbus_backend.bus);
+	if (err)
+		return err;
+
+	register_xenstore_notifier(&xenstore_notifier);
+
+	return 0;
+}
+subsys_initcall(xenbus_probe_backend_init);
diff --git a/drivers/xen/xenbus/xenbus_probe_frontend.c b/drivers/xen/xenbus/xenbus_probe_frontend.c
new file mode 100644
index 0000000..5bcc2d6
--- /dev/null
+++ b/drivers/xen/xenbus/xenbus_probe_frontend.c
@@ -0,0 +1,294 @@
+#define DPRINTK(fmt, args...)				\
+	pr_debug("xenbus_probe (%s:%d) " fmt ".\n",	\
+		 __func__, __LINE__, ##args)
+
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <linux/fcntl.h>
+#include <linux/mm.h>
+#include <linux/proc_fs.h>
+#include <linux/notifier.h>
+#include <linux/kthread.h>
+#include <linux/mutex.h>
+#include <linux/io.h>
+
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <asm/xen/hypervisor.h>
+#include <xen/xenbus.h>
+#include <xen/events.h>
+#include <xen/page.h>
+
+#include <xen/platform_pci.h>
+
+#include "xenbus_comms.h"
+#include "xenbus_probe.h"
+
+
+/* device/<type>/<id> => <type>-<id> */
+static int frontend_bus_id(char bus_id[XEN_BUS_ID_SIZE], const char *nodename)
+{
+	nodename = strchr(nodename, '/');
+	if (!nodename || strlen(nodename + 1) >= XEN_BUS_ID_SIZE) {
+		printk(KERN_WARNING "XENBUS: bad frontend %s\n", nodename);
+		return -EINVAL;
+	}
+
+	strlcpy(bus_id, nodename + 1, XEN_BUS_ID_SIZE);
+	if (!strchr(bus_id, '/')) {
+		printk(KERN_WARNING "XENBUS: bus_id %s no slash\n", bus_id);
+		return -EINVAL;
+	}
+	*strchr(bus_id, '/') = '-';
+	return 0;
+}
+
+/* device/<typename>/<name> */
+static int xenbus_probe_frontend(struct xen_bus_type *bus, const char *type,
+				 const char *name)
+{
+	char *nodename;
+	int err;
+
+	nodename = kasprintf(GFP_KERNEL, "%s/%s/%s", bus->root, type, name);
+	if (!nodename)
+		return -ENOMEM;
+
+	DPRINTK("%s", nodename);
+
+	err = xenbus_probe_node(bus, type, nodename);
+	kfree(nodename);
+	return err;
+}
+
+static int xenbus_uevent_frontend(struct device *_dev,
+				  struct kobj_uevent_env *env)
+{
+	struct xenbus_device *dev = to_xenbus_device(_dev);
+
+	if (add_uevent_var(env, "MODALIAS=xen:%s", dev->devicetype))
+		return -ENOMEM;
+
+	return 0;
+}
+
+
+static void backend_changed(struct xenbus_watch *watch,
+			    const char **vec, unsigned int len)
+{
+	xenbus_otherend_changed(watch, vec, len, 1);
+}
+
+static struct device_attribute xenbus_frontend_dev_attrs[] = {
+	__ATTR_NULL
+};
+
+static struct xen_bus_type xenbus_frontend = {
+	.root = "device",
+	.levels = 2,		/* device/type/<id> */
+	.get_bus_id = frontend_bus_id,
+	.probe = xenbus_probe_frontend,
+	.otherend_changed = backend_changed,
+	.bus = {
+		.name		= "xen",
+		.match		= xenbus_match,
+		.uevent		= xenbus_uevent_frontend,
+		.probe		= xenbus_dev_probe,
+		.remove		= xenbus_dev_remove,
+		.shutdown	= xenbus_dev_shutdown,
+		.dev_attrs	= xenbus_frontend_dev_attrs,
+
+		.suspend	= xenbus_dev_suspend,
+		.resume		= xenbus_dev_resume,
+	},
+};
+
+static void frontend_changed(struct xenbus_watch *watch,
+			     const char **vec, unsigned int len)
+{
+	DPRINTK("");
+
+	xenbus_dev_changed(vec[XS_WATCH_PATH], &xenbus_frontend);
+}
+
+
+/* We watch for devices appearing and vanishing. */
+static struct xenbus_watch fe_watch = {
+	.node = "device",
+	.callback = frontend_changed,
+};
+
+static int read_backend_details(struct xenbus_device *xendev)
+{
+	return xenbus_read_otherend_details(xendev, "backend-id", "backend");
+}
+
+static int is_device_connecting(struct device *dev, void *data)
+{
+	struct xenbus_device *xendev = to_xenbus_device(dev);
+	struct device_driver *drv = data;
+	struct xenbus_driver *xendrv;
+
+	/*
+	 * A device with no driver will never connect. We care only about
+	 * devices which should currently be in the process of connecting.
+	 */
+	if (!dev->driver)
+		return 0;
+
+	/* Is this search limited to a particular driver? */
+	if (drv && (dev->driver != drv))
+		return 0;
+
+	xendrv = to_xenbus_driver(dev->driver);
+	return (xendev->state < XenbusStateConnected ||
+		(xendev->state == XenbusStateConnected &&
+		 xendrv->is_ready && !xendrv->is_ready(xendev)));
+}
+
+static int exists_connecting_device(struct device_driver *drv)
+{
+	return bus_for_each_dev(&xenbus_frontend.bus, NULL, drv,
+				is_device_connecting);
+}
+
+static int print_device_status(struct device *dev, void *data)
+{
+	struct xenbus_device *xendev = to_xenbus_device(dev);
+	struct device_driver *drv = data;
+
+	/* Is this operation limited to a particular driver? */
+	if (drv && (dev->driver != drv))
+		return 0;
+
+	if (!dev->driver) {
+		/* Information only: is this too noisy? */
+		printk(KERN_INFO "XENBUS: Device with no driver: %s\n",
+		       xendev->nodename);
+	} else if (xendev->state < XenbusStateConnected) {
+		enum xenbus_state rstate = XenbusStateUnknown;
+		if (xendev->otherend)
+			rstate = xenbus_read_driver_state(xendev->otherend);
+		printk(KERN_WARNING "XENBUS: Timeout connecting "
+		       "to device: %s (local state %d, remote state %d)\n",
+		       xendev->nodename, xendev->state, rstate);
+	}
+
+	return 0;
+}
+
+/* We only wait for device setup after most initcalls have run. */
+static int ready_to_wait_for_devices;
+
+/*
+ * On a 5-minute timeout, wait for all devices currently configured.  We need
+ * to do this to guarantee that the filesystems and / or network devices
+ * needed for boot are available, before we can allow the boot to proceed.
+ *
+ * This needs to be on a late_initcall, to happen after the frontend device
+ * drivers have been initialised, but before the root fs is mounted.
+ *
+ * A possible improvement here would be to have the tools add a per-device
+ * flag to the store entry, indicating whether it is needed at boot time.
+ * This would allow people who knew what they were doing to accelerate their
+ * boot slightly, but of course needs tools or manual intervention to set up
+ * those flags correctly.
+ */
+static void wait_for_devices(struct xenbus_driver *xendrv)
+{
+	unsigned long start = jiffies;
+	struct device_driver *drv = xendrv ? &xendrv->driver : NULL;
+	unsigned int seconds_waited = 0;
+
+	if (!ready_to_wait_for_devices || !xen_domain())
+		return;
+
+	while (exists_connecting_device(drv)) {
+		if (time_after(jiffies, start + (seconds_waited+5)*HZ)) {
+			if (!seconds_waited)
+				printk(KERN_WARNING "XENBUS: Waiting for "
+				       "devices to initialise: ");
+			seconds_waited += 5;
+			printk("%us...", 300 - seconds_waited);
+			if (seconds_waited == 300)
+				break;
+		}
+
+		schedule_timeout_interruptible(HZ/10);
+	}
+
+	if (seconds_waited)
+		printk("\n");
+
+	bus_for_each_dev(&xenbus_frontend.bus, NULL, drv,
+			 print_device_status);
+}
+
+int __xenbus_register_frontend(struct xenbus_driver *drv,
+			       struct module *owner, const char *mod_name)
+{
+	int ret;
+
+	drv->read_otherend_details = read_backend_details;
+
+	ret = xenbus_register_driver_common(drv, &xenbus_frontend,
+					    owner, mod_name);
+	if (ret)
+		return ret;
+
+	/* If this driver is loaded as a module wait for devices to attach. */
+	wait_for_devices(drv);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__xenbus_register_frontend);
+
+static int frontend_probe_and_watch(struct notifier_block *notifier,
+				   unsigned long event,
+				   void *data)
+{
+	/* Enumerate devices in xenstore and watch for changes. */
+	xenbus_probe_devices(&xenbus_frontend);
+	register_xenbus_watch(&fe_watch);
+
+	return NOTIFY_DONE;
+}
+
+
+static int __init xenbus_probe_frontend_init(void)
+{
+	static struct notifier_block xenstore_notifier = {
+		.notifier_call = frontend_probe_and_watch
+	};
+	int err;
+
+	DPRINTK("");
+
+	/* Register ourselves with the kernel bus subsystem */
+	err = bus_register(&xenbus_frontend.bus);
+	if (err)
+		return err;
+
+	register_xenstore_notifier(&xenstore_notifier);
+
+	return 0;
+}
+subsys_initcall(xenbus_probe_frontend_init);
+
+#ifndef MODULE
+static int __init boot_wait_for_devices(void)
+{
+	if (xen_hvm_domain() && !xen_platform_pci_unplug)
+		return -ENODEV;
+
+	ready_to_wait_for_devices = 1;
+	wait_for_devices(NULL);
+	return 0;
+}
+
+late_initcall(boot_wait_for_devices);
+#endif
+
+MODULE_LICENSE("GPL");
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index 43e2d7d..7a1d15f 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -94,7 +94,7 @@ struct xenbus_driver {
 	int (*remove)(struct xenbus_device *dev);
 	int (*suspend)(struct xenbus_device *dev, pm_message_t state);
 	int (*resume)(struct xenbus_device *dev);
-	int (*uevent)(struct xenbus_device *, char **, int, char *, int);
+	int (*uevent)(struct xenbus_device *, struct kobj_uevent_env *);
 	struct device_driver driver;
 	int (*read_otherend_details)(struct xenbus_device *dev);
 	int (*is_ready)(struct xenbus_device *dev);
