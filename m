Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab2ECHss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 03:48:48 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:37088 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab2ECHsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 03:48:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAFo3ok9bdWOb/2dsb2JhbABEsyOBB4IKAQUnQBIQUVcGE4YRggC7BJEIBJV+hXaKTIJqgVo
X-IronPort-AV: E=Sophos;i="4.75,522,1330902000"; 
   d="scan'208";a="508220741"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Staging: IndustryPack bus for the Linux Kernel
Date: Thu,  3 May 2012 09:47:45 +0200
Message-Id: <1336031267-10689-2-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336031267-10689-1-git-send-email-siglesias@igalia.com>
References: <1336031267-10689-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add IndustryPack bus support for the Linux Kernel.

This is a virtual bus that allows to perform all the operations between
carrier and mezzanine boards.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/Kconfig        |    2 +
 drivers/staging/Makefile       |    1 +
 drivers/staging/ipack/Kconfig  |   10 +++
 drivers/staging/ipack/Makefile |    4 +
 drivers/staging/ipack/ipack.c  |  179 ++++++++++++++++++++++++++++++++++++++
 drivers/staging/ipack/ipack.h  |  186 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 382 insertions(+)

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 97d412d..b410a36 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -24,6 +24,8 @@ menuconfig STAGING
 
 if STAGING
 
+source "drivers/staging/ipack/Kconfig"
+
 source "drivers/staging/serial/Kconfig"
 
 source "drivers/staging/et131x/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index ffe7d44..23eb56b 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_OCTEON_ETHERNET)	+= octeon/
 obj-$(CONFIG_VT6655)		+= vt6655/
 obj-$(CONFIG_VT6656)		+= vt6656/
 obj-$(CONFIG_VME_BUS)		+= vme/
+obj-$(CONFIG_IPACK_BUS)		+= ipack/
 obj-$(CONFIG_DX_SEP)            += sep/
 obj-$(CONFIG_IIO)		+= iio/
 obj-$(CONFIG_ZRAM)		+= zram/
diff --git a/drivers/staging/ipack/Kconfig b/drivers/staging/ipack/Kconfig
new file mode 100644
index 0000000..c036b79
--- /dev/null
+++ b/drivers/staging/ipack/Kconfig
@@ -0,0 +1,10 @@
+#
+# IPACK configuration.
+#
+
+menuconfig IPACK_BUS
+	tristate "IndustryPack bus support"
+	depends on PCI
+	---help---
+	  If you say Y here you get support for the IndustryPack Framework.
+
diff --git a/drivers/staging/ipack/Makefile b/drivers/staging/ipack/Makefile
new file mode 100644
index 0000000..56e2340
--- /dev/null
+++ b/drivers/staging/ipack/Makefile
@@ -0,0 +1,4 @@
+#
+# Makefile for the IPACK bridge device drivers.
+#
+obj-$(CONFIG_IPACK_BUS)		+= ipack.o
diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
new file mode 100644
index 0000000..1ca2f6e
--- /dev/null
+++ b/drivers/staging/ipack/ipack.c
@@ -0,0 +1,179 @@
+/*
+ * Industry-pack bus support functions.
+ *
+ * (C) 2011 Samuel Iglesias Gonsalvez <siglesia@cern.ch>, CERN
+ * (C) 2012 Samuel Iglesias Gonsalvez <siglesias@igalia.com>, Igalia
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include "ipack.h"
+
+/* used when allocating bus numbers */
+#define IPACK_MAXBUS              64
+
+DEFINE_MUTEX(ipack_mutex);
+
+struct ipack_busmap {
+	unsigned long busmap[IPACK_MAXBUS / (8*sizeof(unsigned long))];
+};
+static struct ipack_busmap busmap;
+
+static int ipack_bus_match(struct device *device, struct device_driver *driver)
+{
+	int ret;
+	struct ipack_device *dev = container_of(device, struct ipack_device, dev);
+	struct ipack_driver *drv = container_of(driver, struct ipack_driver, driver);
+
+	ret = drv->ops->match(dev);
+	if (ret)
+		dev->driver = drv;
+
+	return ret;
+}
+
+static int ipack_bus_probe(struct device *device)
+{
+	struct ipack_device *dev = container_of(device, struct ipack_device, dev);
+
+	return dev->driver->ops->probe(dev);
+}
+
+static int ipack_bus_remove(struct device *device)
+{
+	struct ipack_device *dev = container_of(device, struct ipack_device, dev);
+
+	dev->driver->ops->remove(dev);
+	return 0;
+}
+
+struct bus_type ipack_bus_type = {
+	.name  = "ipack",
+	.probe = ipack_bus_probe,
+	.match = ipack_bus_match,
+	.remove = ipack_bus_remove,
+};
+
+static int ipack_assign_bus_number(void)
+{
+	int busnum;
+
+	mutex_lock(&ipack_mutex);
+	busnum = find_next_zero_bit(busmap.busmap, IPACK_MAXBUS, 1);
+	if (busnum >= IPACK_MAXBUS) {
+		printk(KERN_ERR "ipack: too many buses\n");
+		busnum = -1;
+		goto error_find_busnum;
+	}
+	set_bit(busnum, busmap.busmap);
+error_find_busnum:
+	mutex_unlock(&ipack_mutex);
+	return busnum;
+}
+
+int ipack_bus_register(struct ipack_bus_device *bus)
+{
+	int bus_nr;
+	bus_nr = ipack_assign_bus_number();
+	if (bus_nr < 0)
+		return -1;
+	bus->bus_nr = bus_nr;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipack_bus_register);
+
+int ipack_bus_unregister(struct ipack_bus_device *bus)
+{
+	mutex_lock(&ipack_mutex);
+	clear_bit(bus->bus_nr, busmap.busmap);
+	mutex_unlock(&ipack_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipack_bus_unregister);
+
+int ipack_driver_register(struct ipack_driver *edrv)
+{
+	int ret;
+
+	edrv->driver.bus = &ipack_bus_type;
+	ret = driver_register(&edrv->driver);
+	if (ret < 0)
+		goto exit_driver_register;
+
+exit_driver_register:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ipack_driver_register);
+
+void ipack_driver_unregister(struct ipack_driver *edrv)
+{
+	driver_unregister(&edrv->driver);
+}
+EXPORT_SYMBOL_GPL(ipack_driver_unregister);
+
+void ipack_device_release(struct device *dev)
+{
+}
+
+int ipack_device_find_drv(struct device_driver *driver, void *param)
+{
+	int ret;
+	struct ipack_device *dev = (struct ipack_device *)param;
+
+	ret = ipack_bus_match(&dev->dev, driver);
+	if (ret)
+		return !ipack_bus_probe(&dev->dev);
+
+	return ret;
+}
+
+int ipack_device_register(struct ipack_device *dev)
+{
+	int ret;
+
+	if (!bus_for_each_drv(&ipack_bus_type, NULL, dev, ipack_device_find_drv)) {
+		ret = -ENODEV;
+		goto exit_device_register;
+	}
+
+	dev->dev.bus = &ipack_bus_type;
+	dev->dev.release = ipack_device_release;
+	dev_set_name(&dev->dev, "%s.%u.%u", dev->board_name, dev->bus_nr, dev->slot);
+	ret = device_register(&dev->dev);
+	if (ret < 0) {
+		printk(KERN_ERR "ipack: error registering the device.\n");
+		dev->driver->ops->remove(dev);
+	}
+
+exit_device_register:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ipack_device_register);
+
+void ipack_device_unregister(struct ipack_device *dev)
+{
+	device_unregister(&dev->dev);
+}
+EXPORT_SYMBOL_GPL(ipack_device_unregister);
+
+static int __init ipack_init(void)
+{
+	return bus_register(&ipack_bus_type);
+}
+
+static void __exit ipack_exit(void)
+{
+	bus_unregister(&ipack_bus_type);
+}
+
+module_init(ipack_init);
+module_exit(ipack_exit);
+
+MODULE_AUTHOR("Samuel Iglesias Gonsalvez <siglesias@igalia.com>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Industry-pack bus core");
diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
new file mode 100644
index 0000000..0bffd33
--- /dev/null
+++ b/drivers/staging/ipack/ipack.h
@@ -0,0 +1,186 @@
+/*
+ * Industry-pack bus.
+ *
+ * (C) 2011 Samuel Iglesias Gonsalvez <siglesia@cern.ch>, CERN
+ * (C) 2012 Samuel Iglesias Gonsalvez <siglesias@igalia.com>, Igalia
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/device.h>
+
+#define IPACK_BOARD_NAME_SIZE			16
+#define IPACK_IRQ_NAME_SIZE			50
+#define IPACK_IDPROM_OFFSET_I			0x01
+#define IPACK_IDPROM_OFFSET_P			0x03
+#define IPACK_IDPROM_OFFSET_A			0x05
+#define IPACK_IDPROM_OFFSET_C			0x07
+#define IPACK_IDPROM_OFFSET_MANUFACTURER_ID	0x09
+#define IPACK_IDPROM_OFFSET_MODEL		0x0B
+#define IPACK_IDPROM_OFFSET_REVISION		0x0D
+#define IPACK_IDPROM_OFFSET_RESERVED		0x0F
+#define IPACK_IDPROM_OFFSET_DRIVER_ID_L		0x11
+#define IPACK_IDPROM_OFFSET_DRIVER_ID_H		0x13
+#define IPACK_IDPROM_OFFSET_NUM_BYTES		0x15
+#define IPACK_IDPROM_OFFSET_CRC			0x17
+
+extern struct bus_type ipack_bus_type;
+
+struct ipack_bus_ops;
+struct ipack_driver;
+
+enum ipack_space {
+	IPACK_IO_SPACE    = 0,
+	IPACK_ID_SPACE    = 1,
+	IPACK_MEM_SPACE   = 2,
+};
+
+/**
+ *	struct ipack_addr_space - Virtual address space mapped for a specified type.
+ *
+ *	@address: virtual address
+ *	@size: size of the mapped space
+ */
+struct ipack_addr_space {
+	void         *address;
+	unsigned int size;
+};
+
+/**
+ *	struct ipack_device
+ *
+ *	@board_name: IP mezzanine board name
+ *	@bus_name: IP carrier board name
+ *	@bus_nr: IP bus number where the device is plugged
+ *	@slot: Slot where the device is plugged in the carrier board
+ *	@irq: IRQ vector
+ *	@driver: Pointer to the ipack_driver that manages the device
+ *	@ops: Carrier board operations to access the device
+ *	@id_space: Virtual address to ID space.
+ *	@io_space: Virtual address to IO space.
+ *	@mem_space: Virtual address to MEM space.
+ *	@dev: device in kernel representation.
+ *
+ * Warning: Direct access to mapped memory is possible but the endianness
+ * is not the same with PCI carrier or VME carrier. The endianness is managed
+ * by the carrier board throught @ops.
+ */
+struct ipack_device {
+	char board_name[IPACK_BOARD_NAME_SIZE];
+	char bus_name[IPACK_BOARD_NAME_SIZE];
+	unsigned int bus_nr;
+	unsigned int slot;
+	unsigned int irq;
+	struct ipack_driver *driver;
+	struct ipack_bus_ops *ops;
+	struct ipack_addr_space id_space;
+	struct ipack_addr_space io_space;
+	struct ipack_addr_space mem_space;
+	struct device dev;
+};
+
+#define to_pack_device(n) container_of(n, struct ipack_device, dev)
+
+/*
+ *	struct ipack_driver_ops -- callbacks to mezzanine driver for installing/removing one device
+ *
+ *	@match: Match function
+ *	@probe: Probe function
+ *	@remove: tell the driver that the carrier board wants to remove one device
+ */
+
+struct ipack_driver_ops {
+	int (*match) (struct ipack_device *dev);
+	int (*probe) (struct ipack_device *dev);
+	void (*remove) (struct ipack_device *dev);
+};
+
+/**
+ *	struct ipack_driver -- Specific data to each mezzanine board driver
+ *
+ *	@driver: Device driver kernel representation
+ *	@ops: Mezzanine driver operations specific for the ipack bus.
+ */
+struct ipack_driver {
+	struct device_driver driver;
+	struct ipack_driver_ops *ops;
+};
+
+/*
+ *	ipack_driver_register -- Register a new mezzanine driver
+ *
+ * Called by the mezzanine driver to register itself as a driver
+ * that can manage ipack devices.
+ */
+
+int ipack_driver_register(struct ipack_driver *edrv);
+void ipack_driver_unregister(struct ipack_driver *edrv);
+
+/*
+ *	ipack_device_register -- register a new mezzanine device
+ *
+ * Register a new ipack device (mezzanine device). The call is done by
+ * the carrier device driver.
+ */
+int ipack_device_register(struct ipack_device *dev);
+void ipack_device_unregister(struct ipack_device *dev);
+
+/**
+ *	struct ipack_bus_ops - available operations on a bridge module
+ *
+ *	@map_space: map IP address space
+ *	@unmap_space: unmap IP address space
+ *	@request_irq: request IRQ
+ *	@free_irq: free IRQ
+ *	@read8: read unsigned char
+ *	@read16: read unsigned short
+ *	@read32: read unsigned int
+ *	@write8: read unsigned char
+ *	@write16: read unsigned short
+ *	@write32: read unsigned int
+ *	@remove_device: tell the bridge module that the device has been removed
+ */
+struct ipack_bus_ops {
+	int (*map_space) (struct ipack_device *dev, unsigned int memory_size, int space);
+	int (*unmap_space) (struct ipack_device *dev, int space);
+	int (*request_irq) (struct ipack_device *dev, int vector, int (*handler)(void *), void *arg);
+	int (*free_irq) (struct ipack_device *dev);
+	int (*read8) (struct ipack_device *dev, int space, unsigned long offset, unsigned char *value);
+	int (*read16) (struct ipack_device *dev, int space, unsigned long offset, unsigned short *value);
+	int (*read32) (struct ipack_device *dev, int space, unsigned long offset, unsigned int *value);
+	int (*write8) (struct ipack_device *dev, int space, unsigned long offset, unsigned char value);
+	int (*write16) (struct ipack_device *dev, int space, unsigned long offset, unsigned short value);
+	int (*write32) (struct ipack_device *dev, int space, unsigned long offset, unsigned int value);
+	int (*remove_device) (struct ipack_device *dev);
+};
+
+/**
+ *	struct ipack_bus_device
+ *
+ *	@dev: pointer to carrier device
+ *	@slots: number of slots available
+ *	@bus_nr: ipack bus number
+ *	@vector: IRQ base vector. IRQ vectors are $vector + $slot_number
+ */
+struct ipack_bus_device {
+	struct device *dev;
+	int slots;
+	int bus_nr;
+	int vector;
+};
+
+/**
+ *	ipack_bus_register -- register a new ipack bus
+ *
+ * The carrier board device driver should call this function to register itself
+ * as available bus in ipack.
+ */
+int ipack_bus_register(struct ipack_bus_device *bus);
+
+/**
+ *	ipack_bus_unregister -- unregister an ipack bus
+ */
+int ipack_bus_unregister(struct ipack_bus_device *bus);
-- 
1.7.10

