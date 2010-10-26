Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab0JZBNE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:13:04 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:37300 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166Ab0JZBMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:12:22 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>, "Emilio G. Cota" <cota@braap.org>
Subject: [PATCH 27/30] staging/vme: rework the bus model
Date: Mon, 25 Oct 2010 21:11:13 -0400
Message-Id: <1288055476-19438-28-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1288055476-19438-1-git-send-email-cota@braap.org>
References: <1288055476-19438-1-git-send-email-cota@braap.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

The way in which VME devices and drivers are currently bound together
involves unnecessary contortions. Controlling a device with a VME driver
requires the following steps, in this order:

- installing the VME core, eg insmod vme.ko
- installing the VME boards' drivers, where the devices to be controlled
  are passed to the VME core through the so-called bind tables.  Note that
  these modules are hooking stuff onto the VME core while the bridge driver
  that provides the bus they'll to attach hasn't yet been loaded.
- insmod of the VME bridge driver. 32 devices (called slots) are _always_
  created, and then the bus's .match method is called for each of them.
  This works because the boards' drivers have already hooked stuff onto
  the VME core (see previous step.)

There are a few things I dislike about the above:

* installing drivers even before the bridges they need are present
  seems counter-intuitive and wrong.
* a VME bus may need more than 32 devices--the relation to the 32 slots on
  a VME crate is artificial and confusing:
	* Some VME cards may be best treated in the kernel as several
	  independent devices, and therefore it is pointless to limit the
	  number of devices on the bus.
	* In VME jargon, a slot is a physical place where hardware is sitting,
	  and is clearly out of the kernel's control. Users may thus have a
	  misleading impression of 'this is what's on slot X', and then go
	  to the crate and see that slot X is empty.
* .probe and .remove pass a pointer to a struct device representing a VME
  bridge, instead of representing the device to be added/removed.
	* a bridge's module may be removed anytime and things do fall over;
	  there is no refcounting at all and thus all drivers attached to
	  the removed bus will oops.
* the so-called "bind table" is tricky, unnecessary and boring code that just
  duplicates what modparam's arrays do.

The appended implements a new driver model for VME that is free of the
shortcomings described above.

In short, a VME driver calls vme_register_driver, which takes the number of
devices to be matched as a parameter, say n. Then the driver's .match method
is called n times for each bus registered on the VME core. That is,
if there are m VME buses registered, m * n devices are created and passed
to .match. Devices that do match are probed, while devices that don't match
are removed. The only difference between this and what happens in most
buses is that here .match is passed down from the bus to the drivers, which
in VME are the only ones that can tell whether or not a particular device is
present.

A VME device is thus uniquely identified by the triplet
(driver_name,bus_id,dev_id), formatted as '$driver_name-$bus_id.$dev_id'.

The VME bus has no auto-discovery capabilities, an illness which the ISA
bus also suffers from. Not surprisingly then, most of the appended code has
been adapted from drivers/base/isa.c, added to the kernel in a5117ba7da. For
further explanations please read that a5117ba7da's commit message. The major
difference here is that several VME buses can coexist whereas in ISA only
a single bus is supported.

To make things easier to digest, this patch just adds functions with _ng
appended, a suffix which will be removed once all callers of the original
functions have been converted to the new ones.

Signed-off-by: Emilio G. Cota <cota@braap.org>
---
 drivers/staging/vme/vme.c |  391 +++++++++++++++++++++++++++++++++++++--------
 drivers/staging/vme/vme.h |   43 +++++
 2 files changed, 369 insertions(+), 65 deletions(-)

diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index 96eb98e..5ecfecc 100644
--- a/drivers/staging/vme/vme.c
+++ b/drivers/staging/vme/vme.c
@@ -34,6 +34,20 @@
 #include "vme.h"
 
 /*
+ * A VME device is uniquely identified by a device id, a bus id and a driver
+ * controlling it.
+ * Devices of VME drivers are kept internally in a singly-linked list as
+ * described in the struct below.
+ */
+struct vme_dev {
+	struct device dev;
+	struct device *next;
+	unsigned int bus_id;
+	unsigned int id;
+};
+#define to_vme_dev(x) container_of((x), struct vme_dev, dev)
+
+/*
  * List of registered buses (bridges) and available bus numbers, both protected
  * by the same mutex.
  */
@@ -53,6 +67,48 @@ static struct vme_bridge *dev_to_bridge(struct device *dev)
 	return dev->platform_data;
 }
 
+/**
+ * vme_get_bridge - increments the reference count of a VME bridge
+ * @bus_id:	bus id of the bridge being referenced
+ *
+ * If found, a pointer to the bridge is returned and the reference count
+ * of the module that owns it is incremented.
+ * On success, it can be assumed that the bridge won't be removed until
+ * the corresponding call to vme_put_bridge().
+ * Normally drivers should call vme_get_bridge() in their .probe method,
+ * and vme_put_bridge() when releasing the device, e.g. in .remove.
+ */
+struct vme_bridge *vme_get_bridge(unsigned int bus_id)
+{
+	struct vme_bridge *bridge;
+	struct vme_bridge *retp = NULL;
+
+	mutex_lock(&vme_buses_lock);
+	list_for_each_entry(bridge, &vme_buses_list, buses_list) {
+		if (bridge->num == bus_id) {
+			if (try_module_get(bridge->owner))
+				retp = bridge;
+			break;
+		}
+	}
+	mutex_unlock(&vme_buses_lock);
+	return retp;
+}
+EXPORT_SYMBOL(vme_get_bridge);
+
+/**
+ * vme_put_bridge - decrease the reference count of a bridge
+ * @bridge:	bridge being referenced
+ *
+ * This function decrements the reference count of the module that controls
+ * the bridge. It must come after a call to vme_get_bridge().
+ */
+void vme_put_bridge(struct vme_bridge *bridge)
+{
+	module_put(bridge->owner);
+}
+EXPORT_SYMBOL(vme_put_bridge);
+
 /*
  * Find the bridge that the resource is associated with.
  */
@@ -232,21 +288,14 @@ static int vme_check_window(vme_address_t aspace, unsigned long long vme_base,
  * Request a slave image with specific attributes, return some unique
  * identifier.
  */
-struct vme_resource *vme_slave_request(struct device *dev,
-	vme_address_t address, vme_cycle_t cycle)
+struct vme_resource
+*vme_slave_request_ng(struct vme_bridge *bridge, vme_address_t address, vme_cycle_t cycle)
 {
-	struct vme_bridge *bridge;
 	struct list_head *slave_pos = NULL;
 	struct vme_slave_resource *allocated_image = NULL;
 	struct vme_slave_resource *slave_image = NULL;
 	struct vme_resource *resource = NULL;
 
-	bridge = dev_to_bridge(dev);
-	if (bridge == NULL) {
-		printk(KERN_ERR "Can't find VME bus\n");
-		goto err_bus;
-	}
-
 	/* Loop through slave resources */
 	list_for_each(slave_pos, &bridge->slave_resources) {
 		slave_image = list_entry(slave_pos,
@@ -291,7 +340,17 @@ err_alloc:
 	slave_image->locked = 0;
 	mutex_unlock(&slave_image->mtx);
 err_image:
-err_bus:
+	return NULL;
+}
+EXPORT_SYMBOL(vme_slave_request_ng);
+
+struct vme_resource
+*vme_slave_request(struct device *dev, vme_address_t address, vme_cycle_t cycle)
+{
+	struct vme_bridge *bridge = dev_to_bridge(dev);
+
+	if (bridge)
+		return vme_slave_request_ng(bridge, address, cycle);
 	return NULL;
 }
 EXPORT_SYMBOL(vme_slave_request);
@@ -388,21 +447,15 @@ EXPORT_SYMBOL(vme_slave_free);
  * Request a master image with specific attributes, return some unique
  * identifier.
  */
-struct vme_resource *vme_master_request(struct device *dev,
-	vme_address_t address, vme_cycle_t cycle, vme_width_t dwidth)
+struct vme_resource
+*vme_master_request_ng(struct vme_bridge *bridge, vme_address_t address,
+		      vme_cycle_t cycle, vme_width_t dwidth)
 {
-	struct vme_bridge *bridge;
 	struct list_head *master_pos = NULL;
 	struct vme_master_resource *allocated_image = NULL;
 	struct vme_master_resource *master_image = NULL;
 	struct vme_resource *resource = NULL;
 
-	bridge = dev_to_bridge(dev);
-	if (bridge == NULL) {
-		printk(KERN_ERR "Can't find VME bus\n");
-		goto err_bus;
-	}
-
 	/* Loop through master resources */
 	list_for_each(master_pos, &bridge->master_resources) {
 		master_image = list_entry(master_pos,
@@ -451,7 +504,18 @@ err_alloc:
 	master_image->locked = 0;
 	spin_unlock(&master_image->lock);
 err_image:
-err_bus:
+	return NULL;
+}
+EXPORT_SYMBOL(vme_master_request_ng);
+
+struct vme_resource
+*vme_master_request(struct device *dev, vme_address_t address,
+		    vme_cycle_t cycle, vme_width_t dwidth)
+{
+	struct vme_bridge *bridge = dev_to_bridge(dev);
+
+	if (bridge)
+		return vme_master_request_ng(bridge, address, cycle, dwidth);
 	return NULL;
 }
 EXPORT_SYMBOL(vme_master_request);
@@ -647,9 +711,9 @@ EXPORT_SYMBOL(vme_master_free);
  * Request a DMA controller with specific attributes, return some unique
  * identifier.
  */
-struct vme_resource *vme_dma_request(struct device *dev, vme_dma_route_t route)
+struct vme_resource
+*vme_dma_request_ng(struct vme_bridge *bridge, vme_dma_route_t route)
 {
-	struct vme_bridge *bridge;
 	struct list_head *dma_pos = NULL;
 	struct vme_dma_resource *allocated_ctrlr = NULL;
 	struct vme_dma_resource *dma_ctrlr = NULL;
@@ -658,12 +722,6 @@ struct vme_resource *vme_dma_request(struct device *dev, vme_dma_route_t route)
 	/* XXX Not checking resource attributes */
 	printk(KERN_ERR "No VME resource Attribute tests done\n");
 
-	bridge = dev_to_bridge(dev);
-	if (bridge == NULL) {
-		printk(KERN_ERR "Can't find VME bus\n");
-		goto err_bus;
-	}
-
 	/* Loop through DMA resources */
 	list_for_each(dma_pos, &bridge->dma_resources) {
 		dma_ctrlr = list_entry(dma_pos,
@@ -707,7 +765,16 @@ err_alloc:
 	dma_ctrlr->locked = 0;
 	mutex_unlock(&dma_ctrlr->mtx);
 err_ctrlr:
-err_bus:
+	return NULL;
+}
+EXPORT_SYMBOL(vme_dma_request_ng);
+
+struct vme_resource *vme_dma_request(struct device *dev, vme_dma_route_t route)
+{
+	struct vme_bridge *bridge = dev_to_bridge(dev);
+
+	if (bridge)
+		return vme_dma_request_ng(bridge, route);
 	return NULL;
 }
 EXPORT_SYMBOL(vme_dma_request);
@@ -994,18 +1061,9 @@ void vme_irq_handler(struct vme_bridge *bridge, int level, int statid)
 }
 EXPORT_SYMBOL(vme_irq_handler);
 
-int vme_irq_request(struct device *dev, int level, int statid,
-	void (*callback)(int, int, void *),
-	void *priv_data)
+int vme_irq_request_ng(struct vme_bridge *bridge, int level, int statid,
+		       void (*callback)(int, int, void *), void *priv_data)
 {
-	struct vme_bridge *bridge;
-
-	bridge = dev_to_bridge(dev);
-	if (bridge == NULL) {
-		printk(KERN_ERR "Can't find VME bus\n");
-		return -EINVAL;
-	}
-
 	if ((level < 1) || (level > 7)) {
 		printk(KERN_ERR "Invalid interrupt level\n");
 		return -EINVAL;
@@ -1035,18 +1093,21 @@ int vme_irq_request(struct device *dev, int level, int statid,
 
 	return 0;
 }
-EXPORT_SYMBOL(vme_irq_request);
+EXPORT_SYMBOL(vme_irq_request_ng);
 
-void vme_irq_free(struct device *dev, int level, int statid)
+int vme_irq_request(struct device *dev, int level, int statid,
+		    void (*callback)(int, int, void *), void *priv_data)
 {
-	struct vme_bridge *bridge;
+	struct vme_bridge *bridge = dev_to_bridge(dev);
 
-	bridge = dev_to_bridge(dev);
-	if (bridge == NULL) {
-		printk(KERN_ERR "Can't find VME bus\n");
-		return;
-	}
+	if (bridge)
+		return vme_irq_request_ng(bridge, level, statid, callback, priv_data);
+	return -EINVAL;
+}
+EXPORT_SYMBOL(vme_irq_request);
 
+void vme_irq_free_ng(struct vme_bridge *bridge, int level, int statid)
+{
 	if ((level < 1) || (level > 7)) {
 		printk(KERN_ERR "Invalid interrupt level\n");
 		return;
@@ -1070,18 +1131,20 @@ void vme_irq_free(struct device *dev, int level, int statid)
 
 	mutex_unlock(&bridge->irq_mtx);
 }
-EXPORT_SYMBOL(vme_irq_free);
+EXPORT_SYMBOL(vme_irq_free_ng);
 
-int vme_irq_generate(struct device *dev, int level, int statid)
+void vme_irq_free(struct device *dev, int level, int statid)
 {
-	struct vme_bridge *bridge;
+	struct vme_bridge *bridge = dev_to_bridge(dev);
 
-	bridge = dev_to_bridge(dev);
-	if (bridge == NULL) {
-		printk(KERN_ERR "Can't find VME bus\n");
-		return -EINVAL;
-	}
+	if (bridge)
+		return vme_irq_free_ng(bridge, level, statid);
+	return;
+}
+EXPORT_SYMBOL(vme_irq_free);
 
+int vme_irq_generate_ng(struct vme_bridge *bridge, int level, int statid)
+{
 	if ((level < 1) || (level > 7)) {
 		printk(KERN_WARNING "Invalid interrupt level\n");
 		return -EINVAL;
@@ -1094,25 +1157,28 @@ int vme_irq_generate(struct device *dev, int level, int statid)
 
 	return bridge->irq_generate(bridge, level, statid);
 }
+EXPORT_SYMBOL(vme_irq_generate_ng);
+
+int vme_irq_generate(struct device *dev, int level, int statid)
+{
+	struct vme_bridge *bridge = dev_to_bridge(dev);
+
+	if (bridge)
+		return vme_irq_generate_ng(bridge, level, statid);
+	return -EINVAL;
+}
 EXPORT_SYMBOL(vme_irq_generate);
 
 /*
  * Request the location monitor, return resource or NULL
  */
-struct vme_resource *vme_lm_request(struct device *dev)
+struct vme_resource *vme_lm_request_ng(struct vme_bridge *bridge)
 {
-	struct vme_bridge *bridge;
 	struct list_head *lm_pos = NULL;
 	struct vme_lm_resource *allocated_lm = NULL;
 	struct vme_lm_resource *lm = NULL;
 	struct vme_resource *resource = NULL;
 
-	bridge = dev_to_bridge(dev);
-	if (bridge == NULL) {
-		printk(KERN_ERR "Can't find VME bus\n");
-		goto err_bus;
-	}
-
 	/* Loop through DMA resources */
 	list_for_each(lm_pos, &bridge->lm_resources) {
 		lm = list_entry(lm_pos,
@@ -1155,7 +1221,16 @@ err_alloc:
 	lm->locked = 0;
 	mutex_unlock(&lm->mtx);
 err_lm:
-err_bus:
+	return NULL;
+}
+EXPORT_SYMBOL(vme_lm_request_ng);
+
+struct vme_resource *vme_lm_request(struct device *dev)
+{
+	struct vme_bridge *bridge = dev_to_bridge(dev);
+
+	if (bridge)
+		return vme_lm_request_ng(bridge);
 	return NULL;
 }
 EXPORT_SYMBOL(vme_lm_request);
@@ -1424,6 +1499,28 @@ void vme_unregister_bridge(struct vme_bridge *bridge)
 }
 EXPORT_SYMBOL(vme_unregister_bridge);
 
+/**
+ * vme_register_bridge_ng - register a VME bridge in the VME core
+ * @bridge:	VME bridge to register
+ *
+ * Upon calling this function, the bridge must be ready to process requests.
+ */
+int vme_register_bridge_ng(struct vme_bridge *bridge)
+{
+	return vme_register_bus(bridge);
+}
+EXPORT_SYMBOL(vme_register_bridge_ng);
+
+/**
+ * vme_unregister_bridge_nr - unregister a VME bridge from the VME core
+ * @bridge:	VME bridge to unregister
+ */
+void vme_unregister_bridge_ng(struct vme_bridge *bridge)
+{
+	vme_unregister_bus(bridge);
+}
+EXPORT_SYMBOL(vme_unregister_bridge_ng);
+
 
 /* - Driver Registration --------------------------------------------------- */
 
@@ -1442,6 +1539,131 @@ void vme_unregister_driver(struct vme_driver *drv)
 }
 EXPORT_SYMBOL(vme_unregister_driver);
 
+static void vme_dev_release_ng(struct device *dev)
+{
+	kfree(to_vme_dev(dev));
+}
+
+/**
+ * vme_unregister_driver_ng - unregister a driver from the VME core
+ * @vme_driver:	VME driver to unregister
+ *
+ * First, all devices associated to the driver are unregistered; then the
+ * driver is removed from the core.
+ */
+void vme_unregister_driver_ng(struct vme_driver_ng *vme_driver)
+{
+	struct device *dev = vme_driver->devices;
+
+	while (dev) {
+		struct device *next_dev = to_vme_dev(dev)->next;
+
+		device_unregister(dev);
+		dev = next_dev;
+	}
+	driver_unregister(&vme_driver->driver);
+}
+EXPORT_SYMBOL(vme_unregister_driver_ng);
+
+static int
+__vme_register_driver_bus(struct vme_driver_ng *vme_driver, struct vme_bridge *bridge, unsigned int n_devs)
+{
+	unsigned int id;
+	int error;
+
+	for (id = 0; id < n_devs; id++) {
+		struct vme_dev *vme_dev;
+
+		vme_dev = kzalloc(sizeof(*vme_dev), GFP_KERNEL);
+		if (!vme_dev) {
+			error = -ENOMEM;
+			break;
+		}
+		vme_dev->dev.platform_data = vme_driver;
+		vme_dev->dev.release = vme_dev_release_ng;
+		vme_dev->dev.parent = bridge->parent;
+		vme_dev->dev.bus = &vme_bus_type;
+		vme_dev->bus_id = bridge->num;
+		vme_dev->id = id;
+		dev_set_name(&vme_dev->dev, "%s.%u-%u",
+			vme_driver->name, vme_dev->bus_id, vme_dev->id);
+
+		error = device_register(&vme_dev->dev);
+		if (error) {
+			put_device(&vme_dev->dev);
+			break;
+		}
+		/* add the device to the linked list if there's been a match */
+		if (vme_dev->dev.platform_data) {
+			vme_dev->next = vme_driver->devices;
+			vme_driver->devices = &vme_dev->dev;
+		} else {
+			device_unregister(&vme_dev->dev);
+		}
+	}
+	return error;
+}
+
+static int __vme_register_driver(struct vme_driver_ng *vme_driver, unsigned n_devs)
+{
+	struct vme_bridge *bridge;
+	int error;
+
+	/*
+	 * Since __vme_register_driver_bus may acquire vme_buses_lock, we
+	 * release the lock and temporarily increment the refcount of each
+	 * bridge we're iterating over. This way a bridge cannot be removed
+	 * while we're matching/probing devices against it.
+	 */
+	mutex_lock(&vme_buses_lock);
+	list_for_each_entry(bridge, &vme_buses_list, buses_list) {
+		if (!try_module_get(bridge->owner))
+			continue;
+		mutex_unlock(&vme_buses_lock);
+
+		error = __vme_register_driver_bus(vme_driver, bridge, n_devs);
+
+		mutex_lock(&vme_buses_lock);
+		module_put(bridge->owner);
+		if (error)
+			break;
+	}
+	mutex_unlock(&vme_buses_lock);
+	return error;
+}
+
+/**
+ * vme_register_driver_ng - register a VME driver
+ * @vme_driver:	VME driver to register in the VME core
+ * @n_devs:	Number of devices (0 to n-1) to be matched for each bus
+ *
+ * For each bus already registered in the VME core, n_devs VME devices will be
+ * created and associated to this driver. Then the .match method of the
+ * driver will be called n_devs times for each already available VME bus.
+ * If there is a match, .probe is called; otherwise the created device is
+ * removed.
+ */
+int vme_register_driver_ng(struct vme_driver_ng *vme_driver, unsigned int n_devs)
+{
+	int error;
+
+	vme_driver->driver.name = vme_driver->name;
+	vme_driver->driver.bus	= &vme_bus_type;
+	vme_driver->devices	= NULL;
+	error = driver_register(&vme_driver->driver);
+	if (error)
+		return error;
+
+	error = __vme_register_driver(vme_driver, n_devs);
+
+	if (!error && !vme_driver->devices)
+		error = -ENODEV;
+	if (error)
+		vme_unregister_driver_ng(vme_driver);
+	return error;
+}
+EXPORT_SYMBOL(vme_register_driver_ng);
+
 /* - Bus Registration ------------------------------------------------------ */
 
 static int vme_calc_slot(struct device *dev)
@@ -1549,6 +1771,45 @@ static int vme_bus_remove(struct device *dev)
 	return retval;
 }
 
+static int vme_bus_match_ng(struct device *dev, struct device_driver *drv)
+{
+	struct vme_driver_ng *vme_driver = to_vme_driver_ng(drv);
+
+	if (dev->platform_data == vme_driver) {
+		struct vme_dev *vme_dev = to_vme_dev(dev);
+
+		if (!vme_driver->match ||
+			vme_driver->match(dev, vme_dev->bus_id, vme_dev->id))
+			return 1;
+		dev->platform_data = NULL;
+	}
+	return 0;
+}
+
+static int vme_bus_probe_ng(struct device *dev)
+{
+	struct vme_driver_ng *vme_driver = dev->platform_data;
+
+	if (vme_driver->probe) {
+		struct vme_dev *vme_dev = to_vme_dev(dev);
+
+		return vme_driver->probe(dev, vme_dev->bus_id, vme_dev->id);
+	}
+	return 0;
+}
+
+static int vme_bus_remove_ng(struct device *dev)
+{
+	struct vme_driver_ng *vme_driver = dev->platform_data;
+
+	if (vme_driver->remove) {
+		struct vme_dev *vme_dev = to_vme_dev(dev);
+
+		return vme_driver->remove(dev, vme_dev->bus_id, vme_dev->id);
+	}
+	return 0;
+}
+
 struct bus_type vme_bus_type = {
 	.name = "vme",
 	.match = vme_bus_match,
diff --git a/drivers/staging/vme/vme.h b/drivers/staging/vme/vme.h
index 1c9ab64..a5dd284 100644
--- a/drivers/staging/vme/vme.h
+++ b/drivers/staging/vme/vme.h
@@ -107,6 +107,28 @@ struct vme_driver {
 	struct device_driver    driver;
 };
 
+/**
+ * struct vme_driver_ng - represent a VME driver
+ * @name: driver name
+ * @match: callback for matching devices
+ * @probe: callback for device binding
+ * @remove: callback for device unbinding
+ * @shutdown: callback for device shutdown
+ * @driver: used to attach this VME driver to the driver core
+ * @devices: pointer to the first device controlled by this driver. From this
+ * first device all others can be retrieved by traversing a list.
+ */
+struct vme_driver_ng {
+	char *name;
+	int (*match)(struct device *, unsigned int, unsigned int);
+	int (*probe)(struct device *, unsigned int, unsigned int);
+	int (*remove)(struct device *, unsigned int, unsigned int);
+	void (*shutdown)(struct device *, unsigned int, unsigned int);
+	struct device_driver driver;
+	struct device *devices;
+};
+#define to_vme_driver_ng(x) container_of((x), struct vme_driver_ng, driver)
+
 #define VME_CRCSR_BUF_SIZE (508*1024)
 #define VME_SLOTS_MAX 32
 /*
@@ -220,6 +242,7 @@ struct vme_bridge {
 	/* Bridge Info - XXX Move to private structure? */
 	struct device *parent;	/* Generic device struct (pdev->dev for PCI) */
 	struct list_head buses_list;
+	struct module *owner;	/* module that owns the bridge */
 	void *driver_priv;	/* Private pointer for the bridge driver */
 
 	struct device dev[VME_SLOTS_MAX];	/* Device registered with
@@ -283,6 +306,9 @@ size_t vme_get_size(struct vme_resource *);
 
 struct vme_resource *vme_slave_request(struct device *, vme_address_t,
 	vme_cycle_t);
+struct vme_resource *vme_slave_request_ng(struct vme_bridge *bridge,
+					  vme_address_t address,
+					  vme_cycle_t cycle);
 int vme_slave_set(struct vme_resource *, int, unsigned long long,
 	unsigned long long, dma_addr_t, vme_address_t, vme_cycle_t);
 int vme_slave_get(struct vme_resource *, int *, unsigned long long *,
@@ -291,6 +317,10 @@ void vme_slave_free(struct vme_resource *);
 
 struct vme_resource *vme_master_request(struct device *, vme_address_t,
 	vme_cycle_t, vme_width_t);
+struct vme_resource *vme_master_request_ng(struct vme_bridge *bridge,
+					   vme_address_t address,
+					   vme_cycle_t cycle,
+					   vme_width_t dwidth);
 int vme_master_set(struct vme_resource *, int, unsigned long long,
 	unsigned long long, vme_address_t, vme_cycle_t, vme_width_t);
 int vme_master_get(struct vme_resource *, int *, unsigned long long *,
@@ -302,6 +332,7 @@ unsigned int vme_master_rmw(struct vme_resource *, unsigned int, unsigned int,
 void vme_master_free(struct vme_resource *);
 
 struct vme_resource *vme_dma_request(struct device *, vme_dma_route_t);
+struct vme_resource *vme_dma_request_ng(struct vme_bridge *bridge, vme_dma_route_t route);
 struct vme_dma_list *vme_new_dma_list(struct vme_resource *);
 struct vme_dma_attr *vme_dma_pattern_attribute(u32, vme_pattern_t);
 struct vme_dma_attr *vme_dma_pci_attribute(dma_addr_t);
@@ -316,10 +347,15 @@ int vme_dma_free(struct vme_resource *);
 
 int vme_irq_request(struct device *, int, int,
 	void (*callback)(int, int, void *), void *);
+int vme_irq_request_ng(struct vme_bridge *bridge, int level, int statid,
+		       void (*callback)(int, int, void *), void *priv_data);
 void vme_irq_free(struct device *, int, int);
+void vme_irq_free_ng(struct vme_bridge *bridge, int level, int statid);
 int vme_irq_generate(struct device *, int, int);
+int vme_irq_generate_ng(struct vme_bridge *bridge, int level, int statid);
 
 struct vme_resource * vme_lm_request(struct device *);
+struct vme_resource *vme_lm_request_ng(struct vme_bridge *bridge);
 int vme_lm_count(struct vme_resource *);
 int vme_lm_set(struct vme_resource *, unsigned long long, vme_address_t,
 	vme_cycle_t);
@@ -332,12 +368,19 @@ void vme_lm_free(struct vme_resource *);
 int vme_slot_get(struct device *);
 
 int vme_register_driver(struct vme_driver *);
+int vme_register_driver_ng(struct vme_driver_ng *vme_driver, unsigned int n_devs);
 void vme_unregister_driver(struct vme_driver *);
+void vme_unregister_driver_ng(struct vme_driver_ng *vme_driver);
+
+struct vme_bridge *vme_get_bridge(unsigned int bus_id);
+void vme_put_bridge(struct vme_bridge *bridge);
 
 /* functions for VME bridges */
 void vme_irq_handler(struct vme_bridge *, int, int);
 int vme_register_bridge(struct vme_bridge *);
+int vme_register_bridge_ng(struct vme_bridge *bridge);
 void vme_unregister_bridge(struct vme_bridge *);
+void vme_unregister_bridge_ng(struct vme_bridge *bridge);
 
 
 #endif /* _VME_H_ */
-- 
1.7.1

