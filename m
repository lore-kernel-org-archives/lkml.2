Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030950Ab2ERJLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 05:11:16 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:41780 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965235Ab2ERJK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 05:10:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwEABMRtk9bdWOb/2dsb2JhbABFs2eBB4JDQBKBPhOGEoIAvBSQRQOVIIEPjmaCa4Fd
X-IronPort-AV: E=Sophos;i="4.75,616,1330902000"; 
   d="scan'208";a="915536497"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] Staging: ipack: improve the register of a bus and a device in the bus.
Date: Fri, 18 May 2012 11:10:05 +0200
Message-Id: <1337332208-26057-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It adds and removes some fields in the struct ipack_device and
ipack_bus_device to make it cleaner.

The API has change to group all the operations on these structures inside
of the ipack driver.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   63 +++++++--------------------
 drivers/staging/ipack/bridges/tpci200.h |    2 +-
 drivers/staging/ipack/devices/ipoctal.c |   55 ++++++++++++++----------
 drivers/staging/ipack/ipack.c           |   57 +++++++++++++++++++------
 drivers/staging/ipack/ipack.h           |   71 +++++++++++++++++--------------
 5 files changed, 131 insertions(+), 117 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 4e812a7..392aec0 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -407,53 +407,22 @@ static struct ipack_device *tpci200_slot_register(const char *board_name,
 		goto err_unlock;
 	}
 
-	dev = kzalloc(sizeof(struct ipack_device), GFP_KERNEL);
-	if (dev == NULL) {
-		pr_info("Slot [%s %d:%d] Unable to allocate memory for new slot !\n",
-			TPCI200_SHORTNAME,
-			tpci200_number, slot_position);
-		goto err_unlock;
-	}
-
-	if (size > IPACK_BOARD_NAME_SIZE) {
-		pr_warning("Slot [%s %d:%d] name (%s) too long (%d > %d). Will be truncated!\n",
-			   TPCI200_SHORTNAME, tpci200_number, slot_position,
-			   board_name, (int)strlen(board_name),
-			   IPACK_BOARD_NAME_SIZE);
-
-		size = IPACK_BOARD_NAME_SIZE;
-	}
-
-	strncpy(dev->board_name, board_name, size-1);
-	dev->board_name[size-1] = '\0';
-	dev->bus_nr = tpci200->info->drv.bus_nr;
-	dev->slot = slot_position;
 	/*
 	 * Give the same IRQ number as the slot number.
 	 * The TPCI200 has assigned his own two IRQ by PCI bus driver
 	 */
-	dev->irq = slot_position;
-
-	dev->id_space.address = NULL;
-	dev->id_space.size = 0;
-	dev->io_space.address = NULL;
-	dev->io_space.size = 0;
-	dev->mem_space.address = NULL;
-	dev->mem_space.size = 0;
+	dev = ipack_device_register(tpci200->info->ipack_bus,
+				    slot_position, slot_position);
+	if (dev == NULL) {
+		pr_info("Slot [%d:%d] Unable to register an ipack device\n",
+			tpci200_number, slot_position);
+		goto err_unlock;
+	}
 
-	/* Give the operations structure */
-	dev->ops = &tpci200_bus_ops;
 	tpci200->slots[slot_position].dev = dev;
-
-	if (ipack_device_register(dev) < 0)
-		goto err_unregister;
-
 	mutex_unlock(&tpci200->mutex);
 	return dev;
 
-err_unregister:
-	tpci200_slot_unregister(dev);
-	kfree(dev);
 err_unlock:
 	mutex_unlock(&tpci200->mutex);
 	return NULL;
@@ -874,7 +843,6 @@ static int tpci200_slot_unregister(struct ipack_device *dev)
 
 	ipack_device_unregister(dev);
 	tpci200->slots[dev->slot].dev = NULL;
-	kfree(dev);
 	mutex_unlock(&tpci200->mutex);
 
 	return 0;
@@ -1116,20 +1084,20 @@ static int tpci200_pciprobe(struct pci_dev *pdev,
 		return -ENODEV;
 	}
 
-	tpci200->info->drv.dev = &pdev->dev;
-	tpci200->info->drv.slots = TPCI200_NB_SLOT;
-
-	/* Register the bus in the industry pack driver */
-	ret = ipack_bus_register(&tpci200->info->drv);
-	if (ret < 0) {
+	/* Register the carrier in the industry pack bus driver */
+	tpci200->info->ipack_bus = ipack_bus_register(&pdev->dev,
+						      TPCI200_NB_SLOT,
+						      &tpci200_bus_ops);
+	if (!tpci200->info->ipack_bus) {
 		pr_err("error registering the carrier on ipack driver\n");
 		tpci200_uninstall(tpci200);
 		kfree(tpci200->info);
 		kfree(tpci200);
 		return -EFAULT;
 	}
+
 	/* save the bus number given by ipack to logging purpose */
-	tpci200->number = tpci200->info->drv.bus_nr;
+	tpci200->number = tpci200->info->ipack_bus->bus_nr;
 	dev_set_drvdata(&pdev->dev, tpci200);
 	/* add the registered device in an internal linked list */
 	list_add_tail(&tpci200->list, &tpci200_list);
@@ -1141,7 +1109,8 @@ static void __tpci200_pci_remove(struct tpci200_board *tpci200)
 	tpci200_uninstall(tpci200);
 	tpci200_remove_sysfs_files(tpci200);
 	list_del(&tpci200->list);
-	ipack_bus_unregister(&tpci200->info->drv);
+	ipack_bus_unregister(tpci200->info->ipack_bus);
+	kfree(tpci200->info);
 	kfree(tpci200);
 }
 
diff --git a/drivers/staging/ipack/bridges/tpci200.h b/drivers/staging/ipack/bridges/tpci200.h
index c052107..e3a7e5d 100644
--- a/drivers/staging/ipack/bridges/tpci200.h
+++ b/drivers/staging/ipack/bridges/tpci200.h
@@ -151,7 +151,7 @@ struct tpci200_infos {
 	void __iomem			*ioidint_space;
 	void __iomem			*mem8_space;
 	spinlock_t			access_lock;
-	struct ipack_bus_device		drv;
+	struct ipack_bus_device		*ipack_bus;
 };
 struct tpci200_board {
 	struct list_head	list;
diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index c88f391..29f6fa8 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -73,7 +73,8 @@ static inline void ipoctal_write_io_reg(struct ipoctal *ipoctal,
 	unsigned long offset;
 
 	offset = ((void __iomem *) dest) - ipoctal->dev->io_space.address;
-	ipoctal->dev->ops->write8(ipoctal->dev, IPACK_IO_SPACE, offset, value);
+	ipoctal->dev->bus->ops->write8(ipoctal->dev, IPACK_IO_SPACE, offset,
+				       value);
 }
 
 static inline void ipoctal_write_cr_cmd(struct ipoctal *ipoctal,
@@ -90,7 +91,8 @@ static inline unsigned char ipoctal_read_io_reg(struct ipoctal *ipoctal,
 	unsigned char value;
 
 	offset = ((void __iomem *) src) - ipoctal->dev->io_space.address;
-	ipoctal->dev->ops->read8(ipoctal->dev, IPACK_IO_SPACE, offset, &value);
+	ipoctal->dev->bus->ops->read8(ipoctal->dev, IPACK_IO_SPACE, offset,
+				      &value);
 	return value;
 }
 
@@ -341,12 +343,12 @@ static int ipoctal_check_model(struct ipack_device *dev, unsigned char *id)
 	unsigned char manufacturerID;
 	unsigned char board_id;
 
-	dev->ops->read8(dev, IPACK_ID_SPACE,
+	dev->bus->ops->read8(dev, IPACK_ID_SPACE,
 			IPACK_IDPROM_OFFSET_MANUFACTURER_ID, &manufacturerID);
 	if (manufacturerID != IP_OCTAL_MANUFACTURER_ID)
 		return -ENODEV;
 
-	dev->ops->read8(dev, IPACK_ID_SPACE,
+	dev->bus->ops->read8(dev, IPACK_ID_SPACE,
 			IPACK_IDPROM_OFFSET_MODEL, (unsigned char *)&board_id);
 
 	switch (board_id) {
@@ -376,7 +378,8 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	char name[20];
 	unsigned char board_id;
 
-	res = ipoctal->dev->ops->map_space(ipoctal->dev, 0, IPACK_ID_SPACE);
+	res = ipoctal->dev->bus->ops->map_space(ipoctal->dev, 0,
+						IPACK_ID_SPACE);
 	if (res) {
 		pr_err("Unable to map slot [%d:%d] ID space!\n", bus_nr, slot);
 		return res;
@@ -384,18 +387,20 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 
 	res = ipoctal_check_model(ipoctal->dev, &board_id);
 	if (res) {
-		ipoctal->dev->ops->unmap_space(ipoctal->dev, IPACK_ID_SPACE);
+		ipoctal->dev->bus->ops->unmap_space(ipoctal->dev,
+						    IPACK_ID_SPACE);
 		goto out_unregister_id_space;
 	}
 	ipoctal->board_id = board_id;
 
-	res = ipoctal->dev->ops->map_space(ipoctal->dev, 0, IPACK_IO_SPACE);
+	res = ipoctal->dev->bus->ops->map_space(ipoctal->dev, 0,
+						IPACK_IO_SPACE);
 	if (res) {
 		pr_err("Unable to map slot [%d:%d] IO space!\n", bus_nr, slot);
 		goto out_unregister_id_space;
 	}
 
-	res = ipoctal->dev->ops->map_space(ipoctal->dev,
+	res = ipoctal->dev->bus->ops->map_space(ipoctal->dev,
 					   0x8000, IPACK_MEM_SPACE);
 	if (res) {
 		pr_err("Unable to map slot [%d:%d] MEM space!\n", bus_nr, slot);
@@ -434,9 +439,9 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	 * Depending of the carrier these addresses are accesible or not.
 	 * More info in the datasheet.
 	 */
-	ipoctal->dev->ops->request_irq(ipoctal->dev, vector,
+	ipoctal->dev->bus->ops->request_irq(ipoctal->dev, vector,
 				       ipoctal_irq_handler, ipoctal);
-	ipoctal->dev->ops->write8(ipoctal->dev, IPACK_ID_SPACE, 0, vector);
+	ipoctal->dev->bus->ops->write8(ipoctal->dev, IPACK_ID_SPACE, 0, vector);
 
 	/* Register the TTY device */
 
@@ -502,11 +507,11 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	return 0;
 
 out_unregister_slot_unmap:
-	ipoctal->dev->ops->unmap_space(ipoctal->dev, IPACK_ID_SPACE);
+	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_ID_SPACE);
 out_unregister_io_space:
-	ipoctal->dev->ops->unmap_space(ipoctal->dev, IPACK_IO_SPACE);
+	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_IO_SPACE);
 out_unregister_id_space:
-	ipoctal->dev->ops->unmap_space(ipoctal->dev, IPACK_MEM_SPACE);
+	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_MEM_SPACE);
 	return res;
 }
 
@@ -799,13 +804,20 @@ static int ipoctal_match(struct ipack_device *dev)
 	int res;
 	unsigned char board_id;
 
-	res = dev->ops->map_space(dev, 0, IPACK_ID_SPACE);
+	if ((!dev->bus->ops) || (!dev->bus->ops->map_space) ||
+	    (!dev->bus->ops->unmap_space))
+		return 0;
+
+	res = dev->bus->ops->map_space(dev, 0, IPACK_ID_SPACE);
 	if (res)
-		return res;
+		return 0;
 
 	res = ipoctal_check_model(dev, &board_id);
-	dev->ops->unmap_space(dev, IPACK_ID_SPACE);
-	return res;
+	dev->bus->ops->unmap_space(dev, IPACK_ID_SPACE);
+	if (!res)
+		return 1;
+
+	return 0;
 }
 
 static int ipoctal_probe(struct ipack_device *dev)
@@ -843,8 +855,8 @@ static void __ipoctal_remove(struct ipoctal *ipoctal)
 	put_tty_driver(ipoctal->tty_drv);
 
 	/* Tell the carrier board to free all the resources for this device */
-	if (ipoctal->dev->ops->remove_device != NULL)
-		ipoctal->dev->ops->remove_device(ipoctal->dev);
+	if (ipoctal->dev->bus->ops->remove_device != NULL)
+		ipoctal->dev->bus->ops->remove_device(ipoctal->dev);
 
 	list_del(&ipoctal->list);
 	kfree(ipoctal);
@@ -868,11 +880,8 @@ static struct ipack_driver_ops ipoctal_drv_ops = {
 
 static int __init ipoctal_init(void)
 {
-	driver.owner = THIS_MODULE;
 	driver.ops = &ipoctal_drv_ops;
-	driver.driver.name = KBUILD_MODNAME;
-	ipack_driver_register(&driver);
-	return 0;
+	return ipack_driver_register(&driver, THIS_MODULE, KBUILD_MODNAME);
 }
 
 static void __exit ipoctal_exit(void)
diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
index ad06e06..2b4fa51 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -13,6 +13,7 @@
 
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include "ipack.h"
 
 #define to_ipack_dev(device) container_of(device, struct ipack_device, dev)
@@ -28,13 +29,19 @@ struct ipack_busmap {
 };
 static struct ipack_busmap busmap;
 
+static void ipack_device_release(struct device *dev)
+{
+	struct ipack_device *device = to_ipack_dev(dev);
+	kfree(device);
+}
+
 static int ipack_bus_match(struct device *device, struct device_driver *driver)
 {
 	int ret;
 	struct ipack_device *dev = to_ipack_dev(device);
 	struct ipack_driver *drv = to_ipack_driver(driver);
 
-	if (!drv->ops->match)
+	if ((!drv->ops) || (!drv->ops->match))
 		return -EINVAL;
 
 	ret = drv->ops->match(dev);
@@ -92,16 +99,27 @@ error_find_busnum:
 	return busnum;
 }
 
-int ipack_bus_register(struct ipack_bus_device *bus)
+struct ipack_bus_device *ipack_bus_register(struct device *parent, int slots,
+					    struct ipack_bus_ops *ops)
 {
 	int bus_nr;
+	struct ipack_bus_device *bus;
+
+	bus = kzalloc(sizeof(struct ipack_bus_device), GFP_KERNEL);
+	if (!bus)
+		return NULL;
 
 	bus_nr = ipack_assign_bus_number();
-	if (bus_nr < 0)
-		return -1;
+	if (bus_nr < 0) {
+		kfree(bus);
+		return NULL;
+	}
 
 	bus->bus_nr = bus_nr;
-	return 0;
+	bus->parent = parent;
+	bus->slots = slots;
+	bus->ops = ops;
+	return bus;
 }
 EXPORT_SYMBOL_GPL(ipack_bus_register);
 
@@ -110,12 +128,16 @@ int ipack_bus_unregister(struct ipack_bus_device *bus)
 	mutex_lock(&ipack_mutex);
 	clear_bit(bus->bus_nr, busmap.busmap);
 	mutex_unlock(&ipack_mutex);
+	kfree(bus);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ipack_bus_unregister);
 
-int ipack_driver_register(struct ipack_driver *edrv)
+int ipack_driver_register(struct ipack_driver *edrv, struct module *owner,
+			  char *name)
 {
+	edrv->driver.owner = owner;
+	edrv->driver.name = name;
 	edrv->driver.bus = &ipack_bus_type;
 	return driver_register(&edrv->driver);
 }
@@ -127,26 +149,35 @@ void ipack_driver_unregister(struct ipack_driver *edrv)
 }
 EXPORT_SYMBOL_GPL(ipack_driver_unregister);
 
-static void ipack_device_release(struct device *dev)
-{
-}
-
-int ipack_device_register(struct ipack_device *dev)
+struct ipack_device *ipack_device_register(struct ipack_bus_device *bus,
+					   int slot, int irqv)
 {
 	int ret;
+	struct ipack_device *dev;
+
+	dev = kzalloc(sizeof(struct ipack_device), GFP_KERNEL);
+	if (!dev)
+		return NULL;
 
 	dev->dev.bus = &ipack_bus_type;
 	dev->dev.release = ipack_device_release;
+	dev->dev.parent = bus->parent;
+	dev->slot = slot;
+	dev->bus_nr = bus->bus_nr;
+	dev->irq = irqv;
+	dev->bus = bus;
 	dev_set_name(&dev->dev,
-		     "%s.%u.%u", dev->board_name, dev->bus_nr, dev->slot);
+		     "ipack-dev.%u.%u", dev->bus_nr, dev->slot);
 
 	ret = device_register(&dev->dev);
 	if (ret < 0) {
 		pr_err("error registering the device.\n");
 		dev->driver->ops->remove(dev);
+		kfree(dev);
+		return NULL;
 	}
 
-	return ret;
+	return dev;
 }
 EXPORT_SYMBOL_GPL(ipack_device_register);
 
diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index 7f408ad..d50af71 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -49,13 +49,11 @@ struct ipack_addr_space {
 /**
  *	struct ipack_device
  *
- *	@board_name: IP mezzanine board name
- *	@bus_name: IP carrier board name
  *	@bus_nr: IP bus number where the device is plugged
  *	@slot: Slot where the device is plugged in the carrier board
  *	@irq: IRQ vector
  *	@driver: Pointer to the ipack_driver that manages the device
- *	@ops: Carrier board operations to access the device
+ *	@bus: ipack_bus_device where the device is plugged to.
  *	@id_space: Virtual address to ID space.
  *	@io_space: Virtual address to IO space.
  *	@mem_space: Virtual address to MEM space.
@@ -63,7 +61,7 @@ struct ipack_addr_space {
  *
  * Warning: Direct access to mapped memory is possible but the endianness
  * is not the same with PCI carrier or VME carrier. The endianness is managed
- * by the carrier board throught @ops.
+ * by the carrier board throught bus->ops.
  */
 struct ipack_device {
 	char board_name[IPACK_BOARD_NAME_SIZE];
@@ -72,14 +70,14 @@ struct ipack_device {
 	unsigned int slot;
 	unsigned int irq;
 	struct ipack_driver *driver;
-	struct ipack_bus_ops *ops;
+	struct ipack_bus_device *bus;
 	struct ipack_addr_space id_space;
 	struct ipack_addr_space io_space;
 	struct ipack_addr_space mem_space;
 	struct device dev;
 };
 
-/*
+/**
  *	struct ipack_driver_ops -- callbacks to mezzanine driver for installing/removing one device
  *
  *	@match: Match function
@@ -94,36 +92,16 @@ struct ipack_driver_ops {
 };
 
 /**
- *	struct ipack_driver -- Specific data to each mezzanine board driver
+ *	struct ipack_driver -- Specific data to each ipack board driver
  *
  *	@driver: Device driver kernel representation
  *	@ops: Mezzanine driver operations specific for the ipack bus.
  */
 struct ipack_driver {
-	struct module *owner;
 	struct device_driver driver;
 	struct ipack_driver_ops *ops;
 };
 
-/*
- *	ipack_driver_register -- Register a new mezzanine driver
- *
- * Called by the mezzanine driver to register itself as a driver
- * that can manage ipack devices.
- */
-
-int ipack_driver_register(struct ipack_driver *edrv);
-void ipack_driver_unregister(struct ipack_driver *edrv);
-
-/*
- *	ipack_device_register -- register a new mezzanine device
- *
- * Register a new ipack device (mezzanine device). The call is done by
- * the carrier device driver.
- */
-int ipack_device_register(struct ipack_device *dev);
-void ipack_device_unregister(struct ipack_device *dev);
-
 /**
  *	struct ipack_bus_ops - available operations on a bridge module
  *
@@ -159,24 +137,51 @@ struct ipack_bus_ops {
  *	@dev: pointer to carrier device
  *	@slots: number of slots available
  *	@bus_nr: ipack bus number
- *	@vector: IRQ base vector. IRQ vectors are $vector + $slot_number
+ *	@ops: bus operations for the mezzanine drivers
  */
 struct ipack_bus_device {
-	struct device *dev;
+	struct device *parent;
 	int slots;
 	int bus_nr;
-	int vector;
+	struct ipack_bus_ops *ops;
 };
 
 /**
  *	ipack_bus_register -- register a new ipack bus
  *
- * The carrier board device driver should call this function to register itself
- * as available bus in ipack.
+ * @parent: pointer to the parent device, if any.
+ * @slots: number of slots available in the bus device.
+ * @ops: bus operations for the mezzanine drivers.
+ *
+ * The carrier board device should call this function to register itself as
+ * available bus device in ipack.
  */
-int ipack_bus_register(struct ipack_bus_device *bus);
+struct ipack_bus_device *ipack_bus_register(struct device *parent, int slots,
+					    struct ipack_bus_ops *ops);
 
 /**
  *	ipack_bus_unregister -- unregister an ipack bus
  */
 int ipack_bus_unregister(struct ipack_bus_device *bus);
+
+/**
+ *	ipack_driver_register -- Register a new driver
+ *
+ * Called by a ipack driver to register itself as a driver
+ * that can manage ipack devices.
+ */
+int ipack_driver_register(struct ipack_driver *edrv, struct module *owner, char *name);
+void ipack_driver_unregister(struct ipack_driver *edrv);
+
+/**
+ *	ipack_device_register -- register a new mezzanine device
+ *
+ * @bus: ipack bus device it is plugged to.
+ * @slot: slot position in the bus device.
+ * @irqv: IRQ vector for the mezzanine.
+ *
+ * Register a new ipack device (mezzanine device). The call is done by
+ * the carrier device driver.
+ */
+struct ipack_device *ipack_device_register(struct ipack_bus_device *bus, int slot, int irqv);
+void ipack_device_unregister(struct ipack_device *dev);
-- 
1.7.10

