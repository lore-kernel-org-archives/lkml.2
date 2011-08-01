Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab1HAK3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 06:29:52 -0400
Received: from cernmx31.cern.ch ([137.138.144.179]:18500 "EHLO
	CERNMX31.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab1HAK3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 06:29:35 -0400
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <gregkh@suse.de>
CC: <martyn.welch@ge.com>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 7/8] staging: vme: add struct vme_dev for VME devices
Date: Mon, 1 Aug 2011 12:20:52 +0200
Message-ID: <1312194053-32310-8-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
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
 drivers/staging/vme/devices/vme_user.c |   16 ++---
 drivers/staging/vme/vme.c              |  120 +++++++++++++------------------
 drivers/staging/vme/vme.h              |   37 +++++++---
 drivers/staging/vme/vme_bridge.h       |    5 +-
 4 files changed, 86 insertions(+), 92 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index 7ed4a5c..aff4f92 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -116,7 +116,7 @@ static struct driver_stats statistics;
 
 static struct cdev *vme_user_cdev;		/* Character device */
 static struct class *vme_user_sysfs_class;	/* Sysfs class */
-static struct device *vme_user_bridge;		/* Pointer to bridge device */
+static struct vme_dev *vme_user_bridge;		/* Pointer to user device */
 
 static struct vme_bridge *vme_user_bus;		/* Pointer to bridge */
 
@@ -137,8 +137,8 @@ static ssize_t vme_user_write(struct file *, const char __user *, size_t,
 static loff_t vme_user_llseek(struct file *, loff_t, int);
 static long vme_user_unlocked_ioctl(struct file *, unsigned int, unsigned long);
 
-static int __devinit vme_user_probe(struct device *, int, int);
-static int __devexit vme_user_remove(struct device *, int, int);
+static int __devinit vme_user_probe(struct vme_dev *);
+static int __devexit vme_user_remove(struct vme_dev *);
 
 static const struct file_operations vme_user_fops = {
 	.open = vme_user_open,
@@ -691,8 +691,7 @@ err_nocard:
  * as practical. We will therefore reserve the buffers and request the images
  * here so that we don't have to do it later.
  */
-static int __devinit vme_user_probe(struct device *dev, int cur_bus,
-	int cur_slot)
+static int __devinit vme_user_probe(struct vme_dev *vdev)
 {
 	int i, err;
 	char name[12];
@@ -704,7 +703,7 @@ static int __devinit vme_user_probe(struct device *dev, int cur_bus,
 		err = -EINVAL;
 		goto err_dev;
 	}
-	vme_user_bridge = dev;
+	vme_user_bridge = vdev;
 
 	/* Initialise descriptors */
 	for (i = 0; i < VME_DEVS; i++) {
@@ -831,7 +830,7 @@ static int __devinit vme_user_probe(struct device *dev, int cur_bus,
 	 * to fall over in case the bridge module is removed while the vme_user
 	 * driver is still loaded.
 	 */
-	vme_user_bus = vme_bridge_get(cur_bus);
+	vme_user_bus = vme_bridge_get(vdev->id.bus);
 	if (!vme_user_bus) {
 		printk(KERN_ERR "%s: vme_bridge_get failed\n", driver_name);
 		err = -EINVAL;
@@ -882,8 +881,7 @@ err_dev:
 	return err;
 }
 
-static int __devexit vme_user_remove(struct device *dev, int cur_bus,
-	int cur_slot)
+static int __devexit vme_user_remove(struct vme_dev *dev)
 {
 	int i;
 
diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index 81a33dc..5220d43 100644
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
@@ -280,7 +276,7 @@ static int vme_check_window(vme_address_t aspace, unsigned long long vme_base,
  * Request a slave image with specific attributes, return some unique
  * identifier.
  */
-struct vme_resource *vme_slave_request(struct device *dev,
+struct vme_resource *vme_slave_request(struct vme_dev *vdev,
 	vme_address_t address, vme_cycle_t cycle)
 {
 	struct vme_bridge *bridge;
@@ -289,7 +285,7 @@ struct vme_resource *vme_slave_request(struct device *dev,
 	struct vme_slave_resource *slave_image = NULL;
 	struct vme_resource *resource = NULL;
 
-	bridge = dev_to_bridge(dev);
+	bridge = vdev->bridge;
 	if (bridge == NULL) {
 		printk(KERN_ERR "Can't find VME bus\n");
 		goto err_bus;
@@ -436,7 +432,7 @@ EXPORT_SYMBOL(vme_slave_free);
  * Request a master image with specific attributes, return some unique
  * identifier.
  */
-struct vme_resource *vme_master_request(struct device *dev,
+struct vme_resource *vme_master_request(struct vme_dev *vdev,
 	vme_address_t address, vme_cycle_t cycle, vme_width_t dwidth)
 {
 	struct vme_bridge *bridge;
@@ -445,7 +441,7 @@ struct vme_resource *vme_master_request(struct device *dev,
 	struct vme_master_resource *master_image = NULL;
 	struct vme_resource *resource = NULL;
 
-	bridge = dev_to_bridge(dev);
+	bridge = vdev->bridge;
 	if (bridge == NULL) {
 		printk(KERN_ERR "Can't find VME bus\n");
 		goto err_bus;
@@ -694,7 +690,8 @@ EXPORT_SYMBOL(vme_master_free);
  * Request a DMA controller with specific attributes, return some unique
  * identifier.
  */
-struct vme_resource *vme_dma_request(struct device *dev, vme_dma_route_t route)
+struct vme_resource *vme_dma_request(struct vme_dev *vdev,
+	vme_dma_route_t route)
 {
 	struct vme_bridge *bridge;
 	struct list_head *dma_pos = NULL;
@@ -705,7 +702,7 @@ struct vme_resource *vme_dma_request(struct device *dev, vme_dma_route_t route)
 	/* XXX Not checking resource attributes */
 	printk(KERN_ERR "No VME resource Attribute tests done\n");
 
-	bridge = dev_to_bridge(dev);
+	bridge = vdev->bridge;
 	if (bridge == NULL) {
 		printk(KERN_ERR "Can't find VME bus\n");
 		goto err_bus;
@@ -1038,13 +1035,13 @@ void vme_irq_handler(struct vme_bridge *bridge, int level, int statid)
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
@@ -1081,11 +1078,11 @@ int vme_irq_request(struct device *dev, int level, int statid,
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
@@ -1116,11 +1113,11 @@ void vme_irq_free(struct device *dev, int level, int statid)
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
@@ -1143,7 +1140,7 @@ EXPORT_SYMBOL(vme_irq_generate);
 /*
  * Request the location monitor, return resource or NULL
  */
-struct vme_resource *vme_lm_request(struct device *dev)
+struct vme_resource *vme_lm_request(struct vme_dev *vdev)
 {
 	struct vme_bridge *bridge;
 	struct list_head *lm_pos = NULL;
@@ -1151,7 +1148,7 @@ struct vme_resource *vme_lm_request(struct device *dev)
 	struct vme_lm_resource *lm = NULL;
 	struct vme_resource *resource = NULL;
 
-	bridge = dev_to_bridge(dev);
+	bridge = vdev->bridge;
 	if (bridge == NULL) {
 		printk(KERN_ERR "Can't find VME bus\n");
 		goto err_bus;
@@ -1332,11 +1329,11 @@ void vme_lm_free(struct vme_resource *resource)
 }
 EXPORT_SYMBOL(vme_lm_free);
 
-int vme_get_slot(struct device *bus)
+int vme_get_slot(struct vme_dev *vdev)
 {
 	struct vme_bridge *bridge;
 
-	bridge = dev_to_bridge(bus);
+	bridge = vdev->bridge;
 	if (bridge == NULL) {
 		printk(KERN_ERR "Can't find VME bus\n");
 		return -EINVAL;
@@ -1408,7 +1405,7 @@ static void vme_remove_bus(struct vme_bridge *bridge)
 
 int vme_register_bridge(struct vme_bridge *bridge)
 {
-	struct device *dev;
+	struct vme_dev *vdev;
 	int retval;
 	int i;
 
@@ -1421,20 +1418,23 @@ int vme_register_bridge(struct vme_bridge *bridge)
 	 * specification.
 	 */
 	for (i = 0; i < VME_SLOTS_MAX; i++) {
-		dev = &bridge->dev[i];
-		memset(dev, 0, sizeof(struct device));
-
-		dev->parent = bridge->parent;
-		dev->bus = &vme_bus_type;
+		vdev = &bridge->dev[i];
+		memset(vdev, 0, sizeof(struct vme_dev));
+
+		vdev->id.bus = bridge->num;
+		vdev->id.slot = i + 1;
+		vdev->bridge = bridge;
+		vdev->dev.parent = bridge->parent;
+		vdev->dev.bus = &vme_bus_type;
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
@@ -1443,8 +1443,8 @@ int vme_register_bridge(struct vme_bridge *bridge)
 
 err_reg:
 	while (--i >= 0) {
-		dev = &bridge->dev[i];
-		device_unregister(dev);
+		vdev = &bridge->dev[i];
+		device_unregister(&vdev->dev);
 	}
 	vme_remove_bus(bridge);
 	return retval;
@@ -1454,12 +1454,12 @@ EXPORT_SYMBOL(vme_register_bridge);
 void vme_unregister_bridge(struct vme_bridge *bridge)
 {
 	int i;
-	struct device *dev;
+	struct vme_dev *vdev;
 
 
 	for (i = 0; i < VME_SLOTS_MAX; i++) {
-		dev = &bridge->dev[i];
-		device_unregister(dev);
+		vdev = &bridge->dev[i];
+		device_unregister(&vdev->dev);
 	}
 	vme_remove_bus(bridge);
 }
@@ -1485,32 +1485,6 @@ EXPORT_SYMBOL(vme_unregister_driver);
 
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
-		if (&bridge->dev[num] == dev)
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
@@ -1521,15 +1495,17 @@ static struct vme_driver *dev_to_vme_driver(struct device *dev)
 
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
@@ -1549,7 +1525,7 @@ static int vme_bus_match(struct device *dev, struct device_driver *drv)
 				return 1;
 
 			if ((driver->bind_table[i].slot == VME_SLOT_CURRENT) &&
-				(num == vme_get_slot(dev)))
+				(num == vme_get_slot(vdev)))
 				return 1;
 		}
 		i++;
@@ -1564,13 +1540,15 @@ static int vme_bus_probe(struct device *dev)
 {
 	struct vme_bridge *bridge;
 	struct vme_driver *driver;
+	struct vme_dev *vdev;
 	int retval = -ENODEV;
 
 	driver = dev_to_vme_driver(dev);
-	bridge = dev_to_bridge(dev);
+	vdev = dev_to_vme_dev(dev);
+	bridge = vdev->bridge;
 
 	if (driver->probe != NULL)
-		retval = driver->probe(dev, bridge->num, vme_calc_slot(dev));
+		retval = driver->probe(vdev);
 
 	return retval;
 }
@@ -1579,13 +1557,15 @@ static int vme_bus_remove(struct device *dev)
 {
 	struct vme_bridge *bridge;
 	struct vme_driver *driver;
+	struct vme_dev *vdev;
 	int retval = -ENODEV;
 
 	driver = dev_to_vme_driver(dev);
-	bridge = dev_to_bridge(dev);
+	vdev = dev_to_vme_dev(dev);
+	bridge = vdev->bridge;
 
 	if (driver->remove != NULL)
-		retval = driver->remove(dev, bridge->num, vme_calc_slot(dev));
+		retval = driver->remove(vdev);
 
 	return retval;
 }
diff --git a/drivers/staging/vme/vme.h b/drivers/staging/vme/vme.h
index bda6fdf..6e37939 100644
--- a/drivers/staging/vme/vme.h
+++ b/drivers/staging/vme/vme.h
@@ -93,17 +93,34 @@ extern struct bus_type vme_bus_type;
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
@@ -114,7 +131,7 @@ void vme_free_consistent(struct vme_resource *, size_t,  void *,
 
 size_t vme_get_size(struct vme_resource *);
 
-struct vme_resource *vme_slave_request(struct device *, vme_address_t,
+struct vme_resource *vme_slave_request(struct vme_dev *, vme_address_t,
 	vme_cycle_t);
 int vme_slave_set(struct vme_resource *, int, unsigned long long,
 	unsigned long long, dma_addr_t, vme_address_t, vme_cycle_t);
@@ -122,7 +139,7 @@ int vme_slave_get(struct vme_resource *, int *, unsigned long long *,
 	unsigned long long *, dma_addr_t *, vme_address_t *, vme_cycle_t *);
 void vme_slave_free(struct vme_resource *);
 
-struct vme_resource *vme_master_request(struct device *, vme_address_t,
+struct vme_resource *vme_master_request(struct vme_dev *, vme_address_t,
 	vme_cycle_t, vme_width_t);
 int vme_master_set(struct vme_resource *, int, unsigned long long,
 	unsigned long long, vme_address_t, vme_cycle_t, vme_width_t);
@@ -134,7 +151,7 @@ unsigned int vme_master_rmw(struct vme_resource *, unsigned int, unsigned int,
 	unsigned int, loff_t);
 void vme_master_free(struct vme_resource *);
 
-struct vme_resource *vme_dma_request(struct device *, vme_dma_route_t);
+struct vme_resource *vme_dma_request(struct vme_dev *, vme_dma_route_t);
 struct vme_dma_list *vme_new_dma_list(struct vme_resource *);
 struct vme_dma_attr *vme_dma_pattern_attribute(u32, vme_pattern_t);
 struct vme_dma_attr *vme_dma_pci_attribute(dma_addr_t);
@@ -147,12 +164,12 @@ int vme_dma_list_exec(struct vme_dma_list *);
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
@@ -162,7 +179,7 @@ int vme_lm_attach(struct vme_resource *, int, void (*callback)(int));
 int vme_lm_detach(struct vme_resource *, int);
 void vme_lm_free(struct vme_resource *);
 
-int vme_get_slot(struct device *);
+int vme_get_slot(struct vme_dev *);
 
 int vme_register_driver(struct vme_driver *);
 void vme_unregister_driver(struct vme_driver *);
diff --git a/drivers/staging/vme/vme_bridge.h b/drivers/staging/vme/vme_bridge.h
index 5f70848..e5ea767 100644
--- a/drivers/staging/vme/vme_bridge.h
+++ b/drivers/staging/vme/vme_bridge.h
@@ -115,9 +115,8 @@ struct vme_bridge {
 	struct list_head bus_list; /* list of VME buses */
 	struct module *owner;	/* module that owns the bridge */
 
-	struct device dev[VME_SLOTS_MAX];	/* Device registered with
-						 * device model on VME bus
-						 */
+	struct vme_dev dev[VME_SLOTS_MAX];	/* Device registered
+						 * on VME bus */
 
 	/* Interrupt callbacks */
 	struct vme_irq irq[7];
-- 
1.7.4.1

