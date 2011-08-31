Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab1HaKJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 06:09:16 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:15710 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab1HaKJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 06:09:14 -0400
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <gregkh@suse.de>
CC: <martyn.welch@ge.com>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 2/3] staging: vme: add struct vme_dev for VME devices
Date: Wed, 31 Aug 2011 12:05:45 +0200
Message-ID: <1314785146-19163-3-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314785146-19163-1-git-send-email-manohar.vanga@cern.ch>
References: <1314785146-19163-1-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using a vanilla 'struct device' for VME devices, add new
'struct vme_dev'. Modifications have been made to the VME framework
API as well as all in-tree VME drivers.

The new vme_dev structure has the following advantages from the
current model used by the driver:

    * Driver functions (probe, remove) now receive a VME device
      instead of a pointer to the bridge device (cleaner design)
    * It's easier to differenciate API calls as bridge-based or
      device-based (ie. cleaner interface).

Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>
---
 drivers/staging/vme/devices/vme_user.c |   14 ++--
 drivers/staging/vme/vme.c              |  128 +++++++++++++-------------------
 drivers/staging/vme/vme.h              |   37 +++++++---
 drivers/staging/vme/vme_api.txt        |   41 ++++++++---
 drivers/staging/vme/vme_bridge.h       |    5 +-
 5 files changed, 117 insertions(+), 108 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index 3cbeb2a..bb33dc2 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -116,7 +116,7 @@ static struct driver_stats statistics;
 
 static struct cdev *vme_user_cdev;		/* Character device */
 static struct class *vme_user_sysfs_class;	/* Sysfs class */
-static struct device *vme_user_bridge;		/* Pointer to bridge device */
+static struct vme_dev *vme_user_bridge;		/* Pointer to user device */
 
 
 static const int type[VME_DEVS] = {	MASTER_MINOR,	MASTER_MINOR,
@@ -135,8 +135,8 @@ static ssize_t vme_user_write(struct file *, const char __user *, size_t,
 static loff_t vme_user_llseek(struct file *, loff_t, int);
 static long vme_user_unlocked_ioctl(struct file *, unsigned int, unsigned long);
 
-static int __devinit vme_user_probe(struct device *, int, int);
-static int __devexit vme_user_remove(struct device *, int, int);
+static int __devinit vme_user_probe(struct vme_dev *);
+static int __devexit vme_user_remove(struct vme_dev *);
 
 static const struct file_operations vme_user_fops = {
 	.open = vme_user_open,
@@ -689,8 +689,7 @@ err_nocard:
  * as practical. We will therefore reserve the buffers and request the images
  * here so that we don't have to do it later.
  */
-static int __devinit vme_user_probe(struct device *dev, int cur_bus,
-	int cur_slot)
+static int __devinit vme_user_probe(struct vme_dev *vdev)
 {
 	int i, err;
 	char name[12];
@@ -702,7 +701,7 @@ static int __devinit vme_user_probe(struct device *dev, int cur_bus,
 		err = -EINVAL;
 		goto err_dev;
 	}
-	vme_user_bridge = dev;
+	vme_user_bridge = vdev;
 
 	/* Initialise descriptors */
 	for (i = 0; i < VME_DEVS; i++) {
@@ -865,8 +864,7 @@ err_dev:
 	return err;
 }
 
-static int __devexit vme_user_remove(struct device *dev, int cur_bus,
-	int cur_slot)
+static int __devexit vme_user_remove(struct vme_dev *dev)
 {
 	int i;
 
diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index 810fe1f..76e08f3 100644
--- a/drivers/staging/vme/vme.c
+++ b/drivers/staging/vme/vme.c
@@ -42,13 +42,9 @@ static DEFINE_MUTEX(vme_buses_lock);
 static void __exit vme_exit(void);
 static int __init vme_init(void);
 
-
-/*
- * Find the bridge resource associated with a specific device resource
- */
-static struct vme_bridge *dev_to_bridge(struct device *dev)
+static struct vme_dev *dev_to_vme_dev(struct device *dev)
 {
-	return dev->platform_data;
+	return container_of(dev, struct vme_dev, dev);
 }
 
 /*
@@ -236,7 +232,7 @@ static int vme_check_window(vme_address_t aspace, unsigned long long vme_base,
  * Request a slave image with specific attributes, return some unique
  * identifier.
  */
-struct vme_resource *vme_slave_request(struct device *dev,
+struct vme_resource *vme_slave_request(struct vme_dev *vdev,
 	vme_address_t address, vme_cycle_t cycle)
 {
 	struct vme_bridge *bridge;
@@ -245,7 +241,7 @@ struct vme_resource *vme_slave_request(struct device *dev,
 	struct vme_slave_resource *slave_image = NULL;
 	struct vme_resource *resource = NULL;
 
-	bridge = dev_to_bridge(dev);
+	bridge = vdev->bridge;
 	if (bridge == NULL) {
 		printk(KERN_ERR "Can't find VME bus\n");
 		goto err_bus;
@@ -392,7 +388,7 @@ EXPORT_SYMBOL(vme_slave_free);
  * Request a master image with specific attributes, return some unique
  * identifier.
  */
-struct vme_resource *vme_master_request(struct device *dev,
+struct vme_resource *vme_master_request(struct vme_dev *vdev,
 	vme_address_t address, vme_cycle_t cycle, vme_width_t dwidth)
 {
 	struct vme_bridge *bridge;
@@ -401,7 +397,7 @@ struct vme_resource *vme_master_request(struct device *dev,
 	struct vme_master_resource *master_image = NULL;
 	struct vme_resource *resource = NULL;
 
-	bridge = dev_to_bridge(dev);
+	bridge = vdev->bridge;
 	if (bridge == NULL) {
 		printk(KERN_ERR "Can't find VME bus\n");
 		goto err_bus;
@@ -650,7 +646,8 @@ EXPORT_SYMBOL(vme_master_free);
  * Request a DMA controller with specific attributes, return some unique
  * identifier.
  */
-struct vme_resource *vme_dma_request(struct device *dev, vme_dma_route_t route)
+struct vme_resource *vme_dma_request(struct vme_dev *vdev,
+	vme_dma_route_t route)
 {
 	struct vme_bridge *bridge;
 	struct list_head *dma_pos = NULL;
@@ -661,7 +658,7 @@ struct vme_resource *vme_dma_request(struct device *dev, vme_dma_route_t route)
 	/* XXX Not checking resource attributes */
 	printk(KERN_ERR "No VME resource Attribute tests done\n");
 
-	bridge = dev_to_bridge(dev);
+	bridge = vdev->bridge;
 	if (bridge == NULL) {
 		printk(KERN_ERR "Can't find VME bus\n");
 		goto err_bus;
@@ -994,13 +991,13 @@ void vme_irq_handler(struct vme_bridge *bridge, int level, int statid)
 }
 EXPORT_SYMBOL(vme_irq_handler);
 
-int vme_irq_request(struct device *dev, int level, int statid,
+int vme_irq_request(struct vme_dev *vdev, int level, int statid,
 	void (*callback)(int, int, void *),
 	void *priv_data)
 {
 	struct vme_bridge *bridge;
 
-	bridge = dev_to_bridge(dev);
+	bridge = vdev->bridge;
 	if (bridge == NULL) {
 		printk(KERN_ERR "Can't find VME bus\n");
 		return -EINVAL;
@@ -1037,11 +1034,11 @@ int vme_irq_request(struct device *dev, int level, int statid,
 }
 EXPORT_SYMBOL(vme_irq_request);
 
-void vme_irq_free(struct device *dev, int level, int statid)
+void vme_irq_free(struct vme_dev *vdev, int level, int statid)
 {
 	struct vme_bridge *bridge;
 
-	bridge = dev_to_bridge(dev);
+	bridge = vdev->bridge;
 	if (bridge == NULL) {
 		printk(KERN_ERR "Can't find VME bus\n");
 		return;
@@ -1072,11 +1069,11 @@ void vme_irq_free(struct device *dev, int level, int statid)
 }
 EXPORT_SYMBOL(vme_irq_free);
 
-int vme_irq_generate(struct device *dev, int level, int statid)
+int vme_irq_generate(struct vme_dev *vdev, int level, int statid)
 {
 	struct vme_bridge *bridge;
 
-	bridge = dev_to_bridge(dev);
+	bridge = vdev->bridge;
 	if (bridge == NULL) {
 		printk(KERN_ERR "Can't find VME bus\n");
 		return -EINVAL;
@@ -1099,7 +1096,7 @@ EXPORT_SYMBOL(vme_irq_generate);
 /*
  * Request the location monitor, return resource or NULL
  */
-struct vme_resource *vme_lm_request(struct device *dev)
+struct vme_resource *vme_lm_request(struct vme_dev *vdev)
 {
 	struct vme_bridge *bridge;
 	struct list_head *lm_pos = NULL;
@@ -1107,7 +1104,7 @@ struct vme_resource *vme_lm_request(struct device *dev)
 	struct vme_lm_resource *lm = NULL;
 	struct vme_resource *resource = NULL;
 
-	bridge = dev_to_bridge(dev);
+	bridge = vdev->bridge;
 	if (bridge == NULL) {
 		printk(KERN_ERR "Can't find VME bus\n");
 		goto err_bus;
@@ -1288,11 +1285,11 @@ void vme_lm_free(struct vme_resource *resource)
 }
 EXPORT_SYMBOL(vme_lm_free);
 
-int vme_slot_get(struct device *bus)
+int vme_slot_get(struct vme_dev *vdev)
 {
 	struct vme_bridge *bridge;
 
-	bridge = dev_to_bridge(bus);
+	bridge = vdev->bridge;
 	if (bridge == NULL) {
 		printk(KERN_ERR "Can't find VME bus\n");
 		return -EINVAL;
@@ -1340,12 +1337,12 @@ static void vme_remove_bus(struct vme_bridge *bridge)
 
 static void vme_dev_release(struct device *dev)
 {
-	kfree(dev);
+	kfree(dev_to_vme_dev(dev));
 }
 
 int vme_register_bridge(struct vme_bridge *bridge)
 {
-	struct device *dev;
+	struct vme_dev *vdev;
 	int retval;
 	int i;
 
@@ -1358,26 +1355,29 @@ int vme_register_bridge(struct vme_bridge *bridge)
 	 * specification.
 	 */
 	for (i = 0; i < VME_SLOTS_MAX; i++) {
-		bridge->dev[i] = kzalloc(sizeof(struct device), GFP_KERNEL);
+		bridge->dev[i] = kzalloc(sizeof(struct vme_dev), GFP_KERNEL);
 		if (!bridge->dev[i]) {
 			retval = -ENOMEM;
 			goto err_devalloc;
 		}
-		dev = bridge->dev[i];
-		memset(dev, 0, sizeof(struct device));
-
-		dev->parent = bridge->parent;
-		dev->bus = &vme_bus_type;
-		dev->release = vme_dev_release;
+		vdev = bridge->dev[i];
+		memset(vdev, 0, sizeof(struct vme_dev));
+
+		vdev->id.bus = bridge->num;
+		vdev->id.slot = i + 1;
+		vdev->bridge = bridge;
+		vdev->dev.parent = bridge->parent;
+		vdev->dev.bus = &vme_bus_type;
+		vdev->dev.release = vme_dev_release;
 		/*
 		 * We save a pointer to the bridge in platform_data so that we
 		 * can get to it later. We keep driver_data for use by the
 		 * driver that binds against the slot
 		 */
-		dev->platform_data = bridge;
-		dev_set_name(dev, "vme-%x.%x", bridge->num, i + 1);
+		vdev->dev.platform_data = bridge;
+		dev_set_name(&vdev->dev, "vme-%x.%x", bridge->num, i + 1);
 
-		retval = device_register(dev);
+		retval = device_register(&vdev->dev);
 		if (retval)
 			goto err_reg;
 	}
@@ -1385,11 +1385,11 @@ int vme_register_bridge(struct vme_bridge *bridge)
 	return retval;
 
 err_reg:
-	kfree(dev);
+	kfree(vdev);
 err_devalloc:
 	while (--i >= 0) {
-		dev = bridge->dev[i];
-		device_unregister(dev);
+		vdev = bridge->dev[i];
+		device_unregister(&vdev->dev);
 	}
 	vme_remove_bus(bridge);
 	return retval;
@@ -1399,12 +1399,12 @@ EXPORT_SYMBOL(vme_register_bridge);
 void vme_unregister_bridge(struct vme_bridge *bridge)
 {
 	int i;
-	struct device *dev;
+	struct vme_dev *vdev;
 
 
 	for (i = 0; i < VME_SLOTS_MAX; i++) {
-		dev = bridge->dev[i];
-		device_unregister(dev);
+		vdev = bridge->dev[i];
+		device_unregister(&vdev->dev);
 	}
 	vme_remove_bus(bridge);
 }
@@ -1430,32 +1430,6 @@ EXPORT_SYMBOL(vme_unregister_driver);
 
 /* - Bus Registration ------------------------------------------------------ */
 
-static int vme_calc_slot(struct device *dev)
-{
-	struct vme_bridge *bridge;
-	int num;
-
-	bridge = dev_to_bridge(dev);
-
-	/* Determine slot number */
-	num = 0;
-	while (num < VME_SLOTS_MAX) {
-		if (bridge->dev[num] == dev)
-			break;
-
-		num++;
-	}
-	if (num == VME_SLOTS_MAX) {
-		dev_err(dev, "Failed to identify slot\n");
-		num = 0;
-		goto err_dev;
-	}
-	num++;
-
-err_dev:
-	return num;
-}
-
 static struct vme_driver *dev_to_vme_driver(struct device *dev)
 {
 	if (dev->driver == NULL)
@@ -1466,15 +1440,17 @@ static struct vme_driver *dev_to_vme_driver(struct device *dev)
 
 static int vme_bus_match(struct device *dev, struct device_driver *drv)
 {
+	struct vme_dev *vdev;
 	struct vme_bridge *bridge;
 	struct vme_driver *driver;
 	int i, num;
 
-	bridge = dev_to_bridge(dev);
+	vdev = dev_to_vme_dev(dev);
+	bridge = vdev->bridge;
 	driver = container_of(drv, struct vme_driver, driver);
 
-	num = vme_calc_slot(dev);
-	if (!num)
+	num = vdev->id.slot;
+	if (num <= 0 || num >= VME_SLOTS_MAX)
 		goto err_dev;
 
 	if (driver->bind_table == NULL) {
@@ -1494,7 +1470,7 @@ static int vme_bus_match(struct device *dev, struct device_driver *drv)
 				return 1;
 
 			if ((driver->bind_table[i].slot == VME_SLOT_CURRENT) &&
-				(num == vme_slot_get(dev)))
+				(num == vme_slot_get(vdev)))
 				return 1;
 		}
 		i++;
@@ -1507,30 +1483,30 @@ err_table:
 
 static int vme_bus_probe(struct device *dev)
 {
-	struct vme_bridge *bridge;
 	struct vme_driver *driver;
+	struct vme_dev *vdev;
 	int retval = -ENODEV;
 
 	driver = dev_to_vme_driver(dev);
-	bridge = dev_to_bridge(dev);
+	vdev = dev_to_vme_dev(dev);
 
 	if (driver->probe != NULL)
-		retval = driver->probe(dev, bridge->num, vme_calc_slot(dev));
+		retval = driver->probe(vdev);
 
 	return retval;
 }
 
 static int vme_bus_remove(struct device *dev)
 {
-	struct vme_bridge *bridge;
 	struct vme_driver *driver;
+	struct vme_dev *vdev;
 	int retval = -ENODEV;
 
 	driver = dev_to_vme_driver(dev);
-	bridge = dev_to_bridge(dev);
+	vdev = dev_to_vme_dev(dev);
 
 	if (driver->remove != NULL)
-		retval = driver->remove(dev, bridge->num, vme_calc_slot(dev));
+		retval = driver->remove(vdev);
 
 	return retval;
 }
diff --git a/drivers/staging/vme/vme.h b/drivers/staging/vme/vme.h
index 4155d8c..d442cce 100644
--- a/drivers/staging/vme/vme.h
+++ b/drivers/staging/vme/vme.h
@@ -91,17 +91,34 @@ extern struct bus_type vme_bus_type;
 #define VME_SLOT_CURRENT	-1
 #define VME_SLOT_ALL		-2
 
+/**
+ * VME device identifier structure
+ * @bus: The bus ID of the bus the device is on
+ * @slot: The slot this device is plugged into
+ */
 struct vme_device_id {
 	int bus;
 	int slot;
 };
 
+/**
+ * Structure representing a VME device
+ * @id: The ID of the device (currently the bus and slot number)
+ * @bridge: Pointer to the bridge device this device is on
+ * @dev: Internal device structure
+ */
+struct vme_dev {
+	struct vme_device_id id;
+	struct vme_bridge *bridge;
+	struct device dev;
+};
+
 struct vme_driver {
 	struct list_head node;
 	const char *name;
 	const struct vme_device_id *bind_table;
-	int (*probe)  (struct device *, int, int);
-	int (*remove) (struct device *, int, int);
+	int (*probe)  (struct vme_dev *);
+	int (*remove) (struct vme_dev *);
 	void (*shutdown) (void);
 	struct device_driver    driver;
 };
@@ -112,7 +129,7 @@ void vme_free_consistent(struct vme_resource *, size_t,  void *,
 
 size_t vme_get_size(struct vme_resource *);
 
-struct vme_resource *vme_slave_request(struct device *, vme_address_t,
+struct vme_resource *vme_slave_request(struct vme_dev *, vme_address_t,
 	vme_cycle_t);
 int vme_slave_set(struct vme_resource *, int, unsigned long long,
 	unsigned long long, dma_addr_t, vme_address_t, vme_cycle_t);
@@ -120,7 +137,7 @@ int vme_slave_get(struct vme_resource *, int *, unsigned long long *,
 	unsigned long long *, dma_addr_t *, vme_address_t *, vme_cycle_t *);
 void vme_slave_free(struct vme_resource *);
 
-struct vme_resource *vme_master_request(struct device *, vme_address_t,
+struct vme_resource *vme_master_request(struct vme_dev *, vme_address_t,
 	vme_cycle_t, vme_width_t);
 int vme_master_set(struct vme_resource *, int, unsigned long long,
 	unsigned long long, vme_address_t, vme_cycle_t, vme_width_t);
@@ -132,7 +149,7 @@ unsigned int vme_master_rmw(struct vme_resource *, unsigned int, unsigned int,
 	unsigned int, loff_t);
 void vme_master_free(struct vme_resource *);
 
-struct vme_resource *vme_dma_request(struct device *, vme_dma_route_t);
+struct vme_resource *vme_dma_request(struct vme_dev *, vme_dma_route_t);
 struct vme_dma_list *vme_new_dma_list(struct vme_resource *);
 struct vme_dma_attr *vme_dma_pattern_attribute(u32, vme_pattern_t);
 struct vme_dma_attr *vme_dma_pci_attribute(dma_addr_t);
@@ -145,12 +162,12 @@ int vme_dma_list_exec(struct vme_dma_list *);
 int vme_dma_list_free(struct vme_dma_list *);
 int vme_dma_free(struct vme_resource *);
 
-int vme_irq_request(struct device *, int, int,
+int vme_irq_request(struct vme_dev *, int, int,
 	void (*callback)(int, int, void *), void *);
-void vme_irq_free(struct device *, int, int);
-int vme_irq_generate(struct device *, int, int);
+void vme_irq_free(struct vme_dev *, int, int);
+int vme_irq_generate(struct vme_dev *, int, int);
 
-struct vme_resource * vme_lm_request(struct device *);
+struct vme_resource * vme_lm_request(struct vme_dev *);
 int vme_lm_count(struct vme_resource *);
 int vme_lm_set(struct vme_resource *, unsigned long long, vme_address_t,
 	vme_cycle_t);
@@ -160,7 +177,7 @@ int vme_lm_attach(struct vme_resource *, int, void (*callback)(int));
 int vme_lm_detach(struct vme_resource *, int);
 void vme_lm_free(struct vme_resource *);
 
-int vme_slot_get(struct device *);
+int vme_slot_get(struct vme_dev *);
 
 int vme_register_driver(struct vme_driver *);
 void vme_unregister_driver(struct vme_driver *);
diff --git a/drivers/staging/vme/vme_api.txt b/drivers/staging/vme/vme_api.txt
index 4910e92..03f4813 100644
--- a/drivers/staging/vme/vme_api.txt
+++ b/drivers/staging/vme/vme_api.txt
@@ -20,8 +20,8 @@ registration function. The structure is as follows:
 		struct list_head node;
 		char *name;
 		const struct vme_device_id *bind_table;
-		int (*probe)  (struct device *, int, int);
-		int (*remove) (struct device *, int, int);
+		int (*probe)  (struct vme_dev *);
+		int (*remove) (struct vme_dev *);
 		void (*shutdown) (void);
 		struct device_driver    driver;
 	};
@@ -33,7 +33,26 @@ to the probe routine.
 
 The arguments of the probe routine are as follows:
 
-	probe(struct device *dev, int bus, int slot);
+	probe(struct vme_dev *dev);
+
+The device structure looks like the following:
+
+	struct vme_dev {
+		struct vme_device_id id;
+		struct vme_bridge *bridge;
+		struct device dev;
+	};
+
+The 'bridge' field contains a pointer to the bridge device. The 'id' field
+contains information useful for the probe function:
+
+	struct vme_device_id {
+		int bus;
+		int slot;
+	};
+
+'bus' is the number of the bus the device being probed is on. 'slot' refers
+to the specific slot on the VME bus.
 
 The '.bind_table' is a pointer to an array of type 'vme_device_id':
 
@@ -71,13 +90,13 @@ specific window or DMA channel (which may be used by a different driver) this
 driver allows a resource to be assigned based on the required attributes of the
 driver in question:
 
-	struct vme_resource * vme_master_request(struct device *dev,
+	struct vme_resource * vme_master_request(struct vme_dev *dev,
 		vme_address_t aspace, vme_cycle_t cycle, vme_width_t width);
 
-	struct vme_resource * vme_slave_request(struct device *dev,
+	struct vme_resource * vme_slave_request(struct vme_dev *dev,
 		vme_address_t aspace, vme_cycle_t cycle);
 
-	struct vme_resource *vme_dma_request(struct device *dev,
+	struct vme_resource *vme_dma_request(struct vme_dev *dev,
 		vme_dma_route_t route);
 
 For slave windows these attributes are split into those of type 'vme_address_t'
@@ -301,10 +320,10 @@ status ID combination. Any given combination can only be assigned a single
 callback function. A void pointer parameter is provided, the value of which is
 passed to the callback function, the use of this pointer is user undefined:
 
-	int vme_irq_request(struct device *dev, int level, int statid,
+	int vme_irq_request(struct vme_dev *dev, int level, int statid,
 		void (*callback)(int, int, void *), void *priv);
 
-	void vme_irq_free(struct device *dev, int level, int statid);
+	void vme_irq_free(struct vme_dev *dev, int level, int statid);
 
 The callback parameters are as follows. Care must be taken in writing a callback
 function, callback functions run in interrupt context:
@@ -318,7 +337,7 @@ Interrupt Generation
 The following function can be used to generate a VME interrupt at a given VME
 level and VME status ID:
 
-	int vme_irq_generate(struct device *dev, int level, int statid);
+	int vme_irq_generate(struct vme_dev *dev, int level, int statid);
 
 
 Location monitors
@@ -334,7 +353,7 @@ Location Monitor Management
 The following functions are provided to request the use of a block of location
 monitors and to free them after they are no longer required:
 
-	struct vme_resource * vme_lm_request(struct device *dev);
+	struct vme_resource * vme_lm_request(struct vme_dev *dev);
 
 	void vme_lm_free(struct vme_resource * res);
 
@@ -380,4 +399,4 @@ Slot Detection
 
 This function returns the slot ID of the provided bridge.
 
-	int vme_slot_get(struct device *dev);
+	int vme_slot_get(struct vme_dev *dev);
diff --git a/drivers/staging/vme/vme_bridge.h b/drivers/staging/vme/vme_bridge.h
index 4b8566e..6dd2f4c 100644
--- a/drivers/staging/vme/vme_bridge.h
+++ b/drivers/staging/vme/vme_bridge.h
@@ -114,9 +114,8 @@ struct vme_bridge {
 	void *driver_priv;	/* Private pointer for the bridge driver */
 	struct list_head bus_list; /* list of VME buses */
 
-	struct device *dev[VME_SLOTS_MAX];	/* Device registered with
-						 * device model on VME bus
-						 */
+	struct vme_dev *dev[VME_SLOTS_MAX];	/* Device registered
+						 * on VME bus */
 
 	/* Interrupt callbacks */
 	struct vme_irq irq[7];
-- 
1.7.4.1

