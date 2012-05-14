Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab2ENKxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 06:53:13 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:56977 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755806Ab2ENKxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 06:53:10 -0400
X-Greylist: delayed 656 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 May 2012 06:52:58 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAB3hsE9bdWOb/2dsb2JhbABEs3CBB4IWAQUnQBIQUVcGE4gSujaRIgSVfYERiEeGaIJr
X-IronPort-AV: E=Sophos;i="4.75,585,1330902000"; 
   d="scan'208";a="990372070"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] Staging: ipack: add proper device model into ipack_bus_register.
Date: Mon, 14 May 2012 12:41:26 +0200
Message-Id: <1336992089-2733-3-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336992089-2733-1-git-send-email-siglesias@igalia.com>
References: <1336992089-2733-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a proper device model to the driver. The carrier boards are
managed like other ipack device, the way to recognize them is using the
platform data field from struct device.

The carrier driver should register itself as ipack_driver before it registers a
new bus device. It should implement the match/probe functions to recognize the
device as bus device using the field platform_data that was filled by ipack
driver before.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   70 +++++++++++++++++++++++--------
 drivers/staging/ipack/bridges/tpci200.h |    2 +-
 drivers/staging/ipack/devices/ipoctal.c |    5 +--
 drivers/staging/ipack/ipack.c           |   68 ++++++++++++++++++++++++------
 drivers/staging/ipack/ipack.h           |   55 +++++++++++++-----------
 5 files changed, 140 insertions(+), 60 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 4e812a7..c7bfb98 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -17,6 +17,7 @@
 #include "tpci200.h"
 
 static struct ipack_bus_ops tpci200_bus_ops;
+static struct ipack_driver tpci200_ipack_drv;
 
 /* TPCI200 controls registers */
 static int control_reg[] = {
@@ -407,7 +408,7 @@ static struct ipack_device *tpci200_slot_register(const char *board_name,
 		goto err_unlock;
 	}
 
-	dev = kzalloc(sizeof(struct ipack_device), GFP_KERNEL);
+	dev = ipack_device_register(tpci200->info->ipack_bus, slot_position);
 	if (dev == NULL) {
 		pr_info("Slot [%s %d:%d] Unable to allocate memory for new slot !\n",
 			TPCI200_SHORTNAME,
@@ -426,8 +427,6 @@ static struct ipack_device *tpci200_slot_register(const char *board_name,
 
 	strncpy(dev->board_name, board_name, size-1);
 	dev->board_name[size-1] = '\0';
-	dev->bus_nr = tpci200->info->drv.bus_nr;
-	dev->slot = slot_position;
 	/*
 	 * Give the same IRQ number as the slot number.
 	 * The TPCI200 has assigned his own two IRQ by PCI bus driver
@@ -445,15 +444,9 @@ static struct ipack_device *tpci200_slot_register(const char *board_name,
 	dev->ops = &tpci200_bus_ops;
 	tpci200->slots[slot_position].dev = dev;
 
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
@@ -1116,20 +1109,19 @@ static int tpci200_pciprobe(struct pci_dev *pdev,
 		return -ENODEV;
 	}
 
-	tpci200->info->drv.dev = &pdev->dev;
-	tpci200->info->drv.slots = TPCI200_NB_SLOT;
-
-	/* Register the bus in the industry pack driver */
-	ret = ipack_bus_register(&tpci200->info->drv);
-	if (ret < 0) {
+	/* Register the carrier in the industry pack bus driver */
+	tpci200->info->ipack_bus = ipack_bus_register(&tpci200_ipack_drv, 0,
+						      TPCI200_NB_SLOT);
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
@@ -1141,7 +1133,8 @@ static void __tpci200_pci_remove(struct tpci200_board *tpci200)
 	tpci200_uninstall(tpci200);
 	tpci200_remove_sysfs_files(tpci200);
 	list_del(&tpci200->list);
-	ipack_bus_unregister(&tpci200->info->drv);
+	ipack_bus_unregister(tpci200->info->ipack_bus);
+	kfree(tpci200->info);
 	kfree(tpci200);
 }
 
@@ -1171,9 +1164,49 @@ static struct pci_driver tpci200_pci_drv = {
 	.remove = __devexit_p(tpci200_pci_remove),
 };
 
+static int tpci200_ipack_match(struct ipack_device *dev)
+{
+	/*
+	 * If this device is a bus device, platform_data
+	 * has a pointer to the corresponding ipack_driver
+	 */
+	if ((dev->dev.platform_data) &&
+	    (dev->dev.platform_data == &tpci200_ipack_drv))
+		return 0;
+
+	return -ENODEV;
+}
+
+static int tpci200_ipack_probe(struct ipack_device *dev)
+{
+	/*
+	 * Already matched the device with the driver in
+	 * the match function. There is not needed to do more.
+	 */
+	return 0;
+}
+
+static struct ipack_driver_ops tpci200_ipack_drv_ops = {
+	.match = tpci200_ipack_match,
+	.probe = tpci200_ipack_probe,
+	.remove = NULL,
+};
+
 static int __init tpci200_drvr_init_module(void)
 {
-	return pci_register_driver(&tpci200_pci_drv);
+	int ret;
+
+	tpci200_ipack_drv.ops = &tpci200_ipack_drv_ops;
+	ret = ipack_driver_register(&tpci200_ipack_drv, THIS_MODULE,
+				    KBUILD_MODNAME);
+	if (ret)
+		return ret;
+
+	ret = pci_register_driver(&tpci200_pci_drv);
+	if (ret)
+		ipack_driver_unregister(&tpci200_ipack_drv);
+
+	return ret;
 }
 
 static void __exit tpci200_drvr_exit_module(void)
@@ -1184,6 +1217,7 @@ static void __exit tpci200_drvr_exit_module(void)
 		__tpci200_pci_remove(tpci200);
 
 	pci_unregister_driver(&tpci200_pci_drv);
+	ipack_driver_unregister(&tpci200_ipack_drv);
 }
 
 MODULE_DESCRIPTION("TEWS TPCI-200 device driver");
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
index c88f391..7e370d3 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -868,11 +868,8 @@ static struct ipack_driver_ops ipoctal_drv_ops = {
 
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
index ad06e06..50b914a 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -13,10 +13,12 @@
 
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include "ipack.h"
 
 #define to_ipack_dev(device) container_of(device, struct ipack_device, dev)
 #define to_ipack_driver(drv) container_of(drv, struct ipack_driver, driver)
+#define to_ipack_bus(device) container_of(device, struct ipack_bus_device, dev.dev)
 
 /* used when allocating bus numbers */
 #define IPACK_MAXBUS              64
@@ -28,13 +30,25 @@ struct ipack_busmap {
 };
 static struct ipack_busmap busmap;
 
+static void ipack_device_release(struct device *dev)
+{
+	struct ipack_device *device = to_ipack_dev(dev);
+	kfree(device);
+}
+
+static void ipack_bus_release(struct device *dev)
+{
+	struct ipack_bus_device *bus = to_ipack_bus(dev);
+	kfree(bus);
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
@@ -92,21 +106,43 @@ error_find_busnum:
 	return busnum;
 }
 
-int ipack_bus_register(struct ipack_bus_device *bus)
+struct ipack_bus_device *ipack_bus_register(struct ipack_driver *drv, int irqv, int slots)
 {
 	int bus_nr;
+	struct ipack_bus_device *bus;
+
+	bus = kzalloc(sizeof(struct ipack_bus_device), GFP_KERNEL);
+	if (!bus)
+		return NULL;
 
 	bus_nr = ipack_assign_bus_number();
 	if (bus_nr < 0)
-		return -1;
+		goto err_bus_register;
 
 	bus->bus_nr = bus_nr;
-	return 0;
+	bus->vector = irqv;
+	bus->slots = slots;
+	bus->dev.dev.platform_data = &drv->driver;
+	bus->dev.dev.bus = &ipack_bus_type;
+	bus->dev.dev.release = ipack_bus_release;
+	dev_set_name(&bus->dev.dev, "ipack-bus%d", bus_nr);
+
+	if (device_register(&bus->dev.dev) < 0) {
+		pr_err(KBUILD_MODNAME ": failed to register bus device %d\n",
+			bus_nr);
+		goto err_bus_register;
+	}
+	return bus;
+
+err_bus_register:
+	kfree(bus);
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(ipack_bus_register);
 
 int ipack_bus_unregister(struct ipack_bus_device *bus)
 {
+	device_unregister(&bus->dev.dev);
 	mutex_lock(&ipack_mutex);
 	clear_bit(bus->bus_nr, busmap.busmap);
 	mutex_unlock(&ipack_mutex);
@@ -114,8 +150,11 @@ int ipack_bus_unregister(struct ipack_bus_device *bus)
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
@@ -127,26 +166,31 @@ void ipack_driver_unregister(struct ipack_driver *edrv)
 }
 EXPORT_SYMBOL_GPL(ipack_driver_unregister);
 
-static void ipack_device_release(struct device *dev)
-{
-}
-
-int ipack_device_register(struct ipack_device *dev)
+struct ipack_device *ipack_device_register(struct ipack_bus_device *bus, int slot)
 {
 	int ret;
+	struct ipack_device *dev;
+
+	dev = kzalloc(sizeof(struct ipack_device), GFP_KERNEL);
+	if (!dev)
+		return NULL;
 
 	dev->dev.bus = &ipack_bus_type;
 	dev->dev.release = ipack_device_release;
+	dev->dev.parent = &bus->dev.dev;
+	dev->slot = slot;
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
index 7f408ad..524ea93 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -94,36 +94,16 @@ struct ipack_driver_ops {
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
@@ -162,7 +142,7 @@ struct ipack_bus_ops {
  *	@vector: IRQ base vector. IRQ vectors are $vector + $slot_number
  */
 struct ipack_bus_device {
-	struct device *dev;
+	struct ipack_device dev;
 	int slots;
 	int bus_nr;
 	int vector;
@@ -171,12 +151,37 @@ struct ipack_bus_device {
 /**
  *	ipack_bus_register -- register a new ipack bus
  *
- * The carrier board device driver should call this function to register itself
- * as available bus in ipack.
+ * @drv: pointer to struct ipack_driver that corresponds to the carrier driver
+ * @irqv: IRQ vector for the bus device.
+ * @slots: numer of slots available in the bus device.
+ *
+ * The carrier board device should call this function to register itself as
+ * available bus device in ipack. It will call the match(), probe() functions of
+ * the driver with the field 'platform_data' in struct device filled with the
+ * pointer to ipack_driver given here.
  */
-int ipack_bus_register(struct ipack_bus_device *bus);
+struct ipack_bus_device *ipack_bus_register(struct ipack_driver *drv, int irqv, int slots);
 
 /**
  *	ipack_bus_unregister -- unregister an ipack bus
  */
 int ipack_bus_unregister(struct ipack_bus_device *bus);
+
+/*
+ *	ipack_driver_register -- Register a new driver
+ *
+ * Called by a ipack driver to register itself as a driver
+ * that can manage ipack devices.
+ */
+
+int ipack_driver_register(struct ipack_driver *edrv, struct module *owner, char *name);
+void ipack_driver_unregister(struct ipack_driver *edrv);
+
+/*
+ *	ipack_device_register -- register a new mezzanine device
+ *
+ * Register a new ipack device (mezzanine device). The call is done by
+ * the carrier device driver.
+ */
+struct ipack_device *ipack_device_register(struct ipack_bus_device *bus, int slot);
+void ipack_device_unregister(struct ipack_device *dev);
-- 
1.7.10

