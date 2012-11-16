Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab2KPRef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:34:35 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:55139 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab2KPRec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:34:32 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwEAAl4plBbdWOb/2dsb2JhbABEwmaBCIJMQBKBPhOGEIIBvmGMM4UNA5V8kEOCcIFaCRcC
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net, jens.taprogge@taprogge.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH] ipack: move header files to include/linux
Date: Fri, 16 Nov 2012 18:34:36 +0100
Message-Id: <1353087276-4861-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move ipack header files to include/linux/ directory where they belong to.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/ipack/carriers/tpci200.h |    3 +-
 drivers/ipack/devices/ipoctal.c  |    2 +-
 drivers/ipack/ipack.c            |    2 +-
 drivers/ipack/ipack.h            |  215 --------------------------------------
 drivers/ipack/ipack_ids.h        |   32 ------
 include/linux/ipack.h            |  214 +++++++++++++++++++++++++++++++++++++
 include/linux/ipack_ids.h        |   32 ++++++
 7 files changed, 249 insertions(+), 251 deletions(-)
 delete mode 100644 drivers/ipack/ipack.h
 delete mode 100644 drivers/ipack/ipack_ids.h
 create mode 100644 include/linux/ipack.h
 create mode 100644 include/linux/ipack_ids.h

diff --git a/drivers/ipack/carriers/tpci200.h b/drivers/ipack/carriers/tpci200.h
index 8d9be27..a7a151d 100644
--- a/drivers/ipack/carriers/tpci200.h
+++ b/drivers/ipack/carriers/tpci200.h
@@ -20,8 +20,7 @@
 #include <linux/spinlock.h>
 #include <linux/swab.h>
 #include <linux/io.h>
-
-#include "../ipack.h"
+#include <linux/ipack.h>
 
 #define TPCI200_NB_SLOT               0x4
 #define TPCI200_NB_BAR                0x6
diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index 783f120..c06ab39 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -22,7 +22,7 @@
 #include <linux/slab.h>
 #include <linux/atomic.h>
 #include <linux/io.h>
-#include "../ipack.h"
+#include <linux/ipack.h>
 #include "ipoctal.h"
 #include "scc2698.h"
 
diff --git a/drivers/ipack/ipack.c b/drivers/ipack/ipack.c
index 6d5079d..7ec6b20 100644
--- a/drivers/ipack/ipack.c
+++ b/drivers/ipack/ipack.c
@@ -13,7 +13,7 @@
 #include <linux/slab.h>
 #include <linux/idr.h>
 #include <linux/io.h>
-#include "ipack.h"
+#include <linux/ipack.h>
 
 #define to_ipack_dev(device) container_of(device, struct ipack_device, dev)
 #define to_ipack_driver(drv) container_of(drv, struct ipack_driver, driver)
diff --git a/drivers/ipack/ipack.h b/drivers/ipack/ipack.h
deleted file mode 100644
index 6760bfa..0000000
--- a/drivers/ipack/ipack.h
+++ /dev/null
@@ -1,215 +0,0 @@
-/*
- * Industry-pack bus.
- *
- * Copyright (C) 2011-2012 CERN (www.cern.ch)
- * Author: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; version 2 of the License.
- */
-
-#include <linux/mod_devicetable.h>
-#include <linux/device.h>
-#include <linux/interrupt.h>
-
-#include "ipack_ids.h"
-
-#define IPACK_IDPROM_OFFSET_I			0x01
-#define IPACK_IDPROM_OFFSET_P			0x03
-#define IPACK_IDPROM_OFFSET_A			0x05
-#define IPACK_IDPROM_OFFSET_C			0x07
-#define IPACK_IDPROM_OFFSET_MANUFACTURER_ID	0x09
-#define IPACK_IDPROM_OFFSET_MODEL		0x0B
-#define IPACK_IDPROM_OFFSET_REVISION		0x0D
-#define IPACK_IDPROM_OFFSET_RESERVED		0x0F
-#define IPACK_IDPROM_OFFSET_DRIVER_ID_L		0x11
-#define IPACK_IDPROM_OFFSET_DRIVER_ID_H		0x13
-#define IPACK_IDPROM_OFFSET_NUM_BYTES		0x15
-#define IPACK_IDPROM_OFFSET_CRC			0x17
-
-struct ipack_bus_ops;
-struct ipack_driver;
-
-enum ipack_space {
-	IPACK_IO_SPACE    = 0,
-	IPACK_ID_SPACE,
-	IPACK_INT_SPACE,
-	IPACK_MEM8_SPACE,
-	IPACK_MEM16_SPACE,
-	/* Dummy for counting the number of entries.  Must remain the last
-	 * entry */
-	IPACK_SPACE_COUNT,
-};
-
-/**
- */
-struct ipack_region {
-	phys_addr_t start;
-	size_t      size;
-};
-
-/**
- *	struct ipack_device
- *
- *	@slot: Slot where the device is plugged in the carrier board
- *	@bus: ipack_bus_device where the device is plugged to.
- *	@id_space: Virtual address to ID space.
- *	@io_space: Virtual address to IO space.
- *	@mem_space: Virtual address to MEM space.
- *	@dev: device in kernel representation.
- *
- * Warning: Direct access to mapped memory is possible but the endianness
- * is not the same with PCI carrier or VME carrier. The endianness is managed
- * by the carrier board throught bus->ops.
- */
-struct ipack_device {
-	unsigned int slot;
-	struct ipack_bus_device *bus;
-	struct device dev;
-	void (*release) (struct ipack_device *dev);
-	struct ipack_region      region[IPACK_SPACE_COUNT];
-	u8                      *id;
-	size_t			 id_avail;
-	u32			 id_vendor;
-	u32			 id_device;
-	u8			 id_format;
-	unsigned int		 id_crc_correct:1;
-	unsigned int		 speed_8mhz:1;
-	unsigned int		 speed_32mhz:1;
-};
-
-/**
- * struct ipack_driver_ops -- Callbacks to IPack device driver
- *
- * @probe:  Probe function
- * @remove: Prepare imminent removal of the device.  Services provided by the
- *          device should be revoked.
- */
-
-struct ipack_driver_ops {
-	int (*probe) (struct ipack_device *dev);
-	void (*remove) (struct ipack_device *dev);
-};
-
-/**
- * struct ipack_driver -- Specific data to each ipack device driver
- *
- * @driver: Device driver kernel representation
- * @ops:    Callbacks provided by the IPack device driver
- */
-struct ipack_driver {
-	struct device_driver driver;
-	const struct ipack_device_id *id_table;
-	const struct ipack_driver_ops *ops;
-};
-
-/**
- *	struct ipack_bus_ops - available operations on a bridge module
- *
- *	@map_space: map IP address space
- *	@unmap_space: unmap IP address space
- *	@request_irq: request IRQ
- *	@free_irq: free IRQ
- *	@get_clockrate: Returns the clockrate the carrier is currently
- *		communicating with the device at.
- *	@set_clockrate: Sets the clock-rate for carrier / module communication.
- *		Should return -EINVAL if the requested speed is not supported.
- *	@get_error: Returns the error state for the slot the device is attached
- *		to.
- *	@get_timeout: Returns 1 if the communication with the device has
- *		previously timed out.
- *	@reset_timeout: Resets the state returned by get_timeout.
- */
-struct ipack_bus_ops {
-	int (*request_irq) (struct ipack_device *dev,
-			    irqreturn_t (*handler)(void *), void *arg);
-	int (*free_irq) (struct ipack_device *dev);
-	int (*get_clockrate) (struct ipack_device *dev);
-	int (*set_clockrate) (struct ipack_device *dev, int mherz);
-	int (*get_error) (struct ipack_device *dev);
-	int (*get_timeout) (struct ipack_device *dev);
-	int (*reset_timeout) (struct ipack_device *dev);
-};
-
-/**
- *	struct ipack_bus_device
- *
- *	@dev: pointer to carrier device
- *	@slots: number of slots available
- *	@bus_nr: ipack bus number
- *	@ops: bus operations for the mezzanine drivers
- */
-struct ipack_bus_device {
-	struct device *parent;
-	int slots;
-	int bus_nr;
-	const struct ipack_bus_ops *ops;
-};
-
-/**
- *	ipack_bus_register -- register a new ipack bus
- *
- * @parent: pointer to the parent device, if any.
- * @slots: number of slots available in the bus device.
- * @ops: bus operations for the mezzanine drivers.
- *
- * The carrier board device should call this function to register itself as
- * available bus device in ipack.
- */
-struct ipack_bus_device *ipack_bus_register(struct device *parent, int slots,
-					    const struct ipack_bus_ops *ops);
-
-/**
- *	ipack_bus_unregister -- unregister an ipack bus
- */
-int ipack_bus_unregister(struct ipack_bus_device *bus);
-
-/**
- * ipack_driver_register -- Register a new ipack device driver
- *
- * Called by a ipack driver to register itself as a driver
- * that can manage ipack devices.
- */
-int ipack_driver_register(struct ipack_driver *edrv, struct module *owner,
-			  const char *name);
-void ipack_driver_unregister(struct ipack_driver *edrv);
-
-/**
- *	ipack_device_register -- register an IPack device with the kernel
- *	@dev: the new device to register.
- *
- *	Register a new IPack device ("module" in IndustryPack jargon). The call
- *	is done by the carrier driver.  The carrier should populate the fields
- *	bus and slot as well as the region array of @dev prior to calling this
- *	function.  The rest of the fields will be allocated and populated
- *	during registration.
- *
- *	Return zero on success or error code on failure.
- */
-int ipack_device_register(struct ipack_device *dev);
-void ipack_device_unregister(struct ipack_device *dev);
-
-/**
- * DEFINE_IPACK_DEVICE_TABLE - macro used to describe a IndustryPack table
- * @_table: device table name
- *
- * This macro is used to create a struct ipack_device_id array (a device table)
- * in a generic manner.
- */
-#define DEFINE_IPACK_DEVICE_TABLE(_table) \
-	const struct ipack_device_id _table[] __devinitconst
-
-/**
- * IPACK_DEVICE - macro used to describe a specific IndustryPack device
- * @_format: the format version (currently either 1 or 2, 8 bit value)
- * @vend:    the 8 or 24 bit IndustryPack Vendor ID
- * @dev:     the 8 or 16  bit IndustryPack Device ID
- *
- * This macro is used to create a struct ipack_device_id that matches a specific
- * device.
- */
-#define IPACK_DEVICE(_format, vend, dev) \
-	 .format = (_format), \
-	 .vendor = (vend), \
-	 .device = (dev)
diff --git a/drivers/ipack/ipack_ids.h b/drivers/ipack/ipack_ids.h
deleted file mode 100644
index 8153fee..0000000
--- a/drivers/ipack/ipack_ids.h
+++ /dev/null
@@ -1,32 +0,0 @@
-/*
- * IndustryPack Fromat, Vendor and Device IDs.
- */
-
-/* ID section format versions */
-#define IPACK_ID_VERSION_INVALID	0x00
-#define IPACK_ID_VERSION_1		0x01
-#define IPACK_ID_VERSION_2		0x02
-
-/* Vendors and devices. Sort key: vendor first, device next. */
-#define IPACK1_VENDOR_ID_RESERVED1	0x00
-#define IPACK1_VENDOR_ID_RESERVED2	0xFF
-#define IPACK1_VENDOR_ID_UNREGISTRED01	0x01
-#define IPACK1_VENDOR_ID_UNREGISTRED02	0x02
-#define IPACK1_VENDOR_ID_UNREGISTRED03	0x03
-#define IPACK1_VENDOR_ID_UNREGISTRED04	0x04
-#define IPACK1_VENDOR_ID_UNREGISTRED05	0x05
-#define IPACK1_VENDOR_ID_UNREGISTRED06	0x06
-#define IPACK1_VENDOR_ID_UNREGISTRED07	0x07
-#define IPACK1_VENDOR_ID_UNREGISTRED08	0x08
-#define IPACK1_VENDOR_ID_UNREGISTRED09	0x09
-#define IPACK1_VENDOR_ID_UNREGISTRED10	0x0A
-#define IPACK1_VENDOR_ID_UNREGISTRED11	0x0B
-#define IPACK1_VENDOR_ID_UNREGISTRED12	0x0C
-#define IPACK1_VENDOR_ID_UNREGISTRED13	0x0D
-#define IPACK1_VENDOR_ID_UNREGISTRED14	0x0E
-#define IPACK1_VENDOR_ID_UNREGISTRED15	0x0F
-
-#define IPACK1_VENDOR_ID_SBS            0xF0
-#define IPACK1_DEVICE_ID_SBS_OCTAL_232  0x22
-#define IPACK1_DEVICE_ID_SBS_OCTAL_422  0x2A
-#define IPACK1_DEVICE_ID_SBS_OCTAL_485  0x48
diff --git a/include/linux/ipack.h b/include/linux/ipack.h
new file mode 100644
index 0000000..e40d2a9
--- /dev/null
+++ b/include/linux/ipack.h
@@ -0,0 +1,214 @@
+/*
+ * Industry-pack bus.
+ *
+ * Copyright (C) 2011-2012 CERN (www.cern.ch)
+ * Author: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; version 2 of the License.
+ */
+
+#include <linux/mod_devicetable.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/ipack_ids.h>
+
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
+struct ipack_bus_ops;
+struct ipack_driver;
+
+enum ipack_space {
+	IPACK_IO_SPACE    = 0,
+	IPACK_ID_SPACE,
+	IPACK_INT_SPACE,
+	IPACK_MEM8_SPACE,
+	IPACK_MEM16_SPACE,
+	/* Dummy for counting the number of entries.  Must remain the last
+	 * entry */
+	IPACK_SPACE_COUNT,
+};
+
+/**
+ */
+struct ipack_region {
+	phys_addr_t start;
+	size_t      size;
+};
+
+/**
+ *	struct ipack_device
+ *
+ *	@slot: Slot where the device is plugged in the carrier board
+ *	@bus: ipack_bus_device where the device is plugged to.
+ *	@id_space: Virtual address to ID space.
+ *	@io_space: Virtual address to IO space.
+ *	@mem_space: Virtual address to MEM space.
+ *	@dev: device in kernel representation.
+ *
+ * Warning: Direct access to mapped memory is possible but the endianness
+ * is not the same with PCI carrier or VME carrier. The endianness is managed
+ * by the carrier board throught bus->ops.
+ */
+struct ipack_device {
+	unsigned int slot;
+	struct ipack_bus_device *bus;
+	struct device dev;
+	void (*release) (struct ipack_device *dev);
+	struct ipack_region      region[IPACK_SPACE_COUNT];
+	u8                      *id;
+	size_t			 id_avail;
+	u32			 id_vendor;
+	u32			 id_device;
+	u8			 id_format;
+	unsigned int		 id_crc_correct:1;
+	unsigned int		 speed_8mhz:1;
+	unsigned int		 speed_32mhz:1;
+};
+
+/**
+ * struct ipack_driver_ops -- Callbacks to IPack device driver
+ *
+ * @probe:  Probe function
+ * @remove: Prepare imminent removal of the device.  Services provided by the
+ *          device should be revoked.
+ */
+
+struct ipack_driver_ops {
+	int (*probe) (struct ipack_device *dev);
+	void (*remove) (struct ipack_device *dev);
+};
+
+/**
+ * struct ipack_driver -- Specific data to each ipack device driver
+ *
+ * @driver: Device driver kernel representation
+ * @ops:    Callbacks provided by the IPack device driver
+ */
+struct ipack_driver {
+	struct device_driver driver;
+	const struct ipack_device_id *id_table;
+	const struct ipack_driver_ops *ops;
+};
+
+/**
+ *	struct ipack_bus_ops - available operations on a bridge module
+ *
+ *	@map_space: map IP address space
+ *	@unmap_space: unmap IP address space
+ *	@request_irq: request IRQ
+ *	@free_irq: free IRQ
+ *	@get_clockrate: Returns the clockrate the carrier is currently
+ *		communicating with the device at.
+ *	@set_clockrate: Sets the clock-rate for carrier / module communication.
+ *		Should return -EINVAL if the requested speed is not supported.
+ *	@get_error: Returns the error state for the slot the device is attached
+ *		to.
+ *	@get_timeout: Returns 1 if the communication with the device has
+ *		previously timed out.
+ *	@reset_timeout: Resets the state returned by get_timeout.
+ */
+struct ipack_bus_ops {
+	int (*request_irq) (struct ipack_device *dev,
+			    irqreturn_t (*handler)(void *), void *arg);
+	int (*free_irq) (struct ipack_device *dev);
+	int (*get_clockrate) (struct ipack_device *dev);
+	int (*set_clockrate) (struct ipack_device *dev, int mherz);
+	int (*get_error) (struct ipack_device *dev);
+	int (*get_timeout) (struct ipack_device *dev);
+	int (*reset_timeout) (struct ipack_device *dev);
+};
+
+/**
+ *	struct ipack_bus_device
+ *
+ *	@dev: pointer to carrier device
+ *	@slots: number of slots available
+ *	@bus_nr: ipack bus number
+ *	@ops: bus operations for the mezzanine drivers
+ */
+struct ipack_bus_device {
+	struct device *parent;
+	int slots;
+	int bus_nr;
+	const struct ipack_bus_ops *ops;
+};
+
+/**
+ *	ipack_bus_register -- register a new ipack bus
+ *
+ * @parent: pointer to the parent device, if any.
+ * @slots: number of slots available in the bus device.
+ * @ops: bus operations for the mezzanine drivers.
+ *
+ * The carrier board device should call this function to register itself as
+ * available bus device in ipack.
+ */
+struct ipack_bus_device *ipack_bus_register(struct device *parent, int slots,
+					    const struct ipack_bus_ops *ops);
+
+/**
+ *	ipack_bus_unregister -- unregister an ipack bus
+ */
+int ipack_bus_unregister(struct ipack_bus_device *bus);
+
+/**
+ * ipack_driver_register -- Register a new ipack device driver
+ *
+ * Called by a ipack driver to register itself as a driver
+ * that can manage ipack devices.
+ */
+int ipack_driver_register(struct ipack_driver *edrv, struct module *owner,
+			  const char *name);
+void ipack_driver_unregister(struct ipack_driver *edrv);
+
+/**
+ *	ipack_device_register -- register an IPack device with the kernel
+ *	@dev: the new device to register.
+ *
+ *	Register a new IPack device ("module" in IndustryPack jargon). The call
+ *	is done by the carrier driver.  The carrier should populate the fields
+ *	bus and slot as well as the region array of @dev prior to calling this
+ *	function.  The rest of the fields will be allocated and populated
+ *	during registration.
+ *
+ *	Return zero on success or error code on failure.
+ */
+int ipack_device_register(struct ipack_device *dev);
+void ipack_device_unregister(struct ipack_device *dev);
+
+/**
+ * DEFINE_IPACK_DEVICE_TABLE - macro used to describe a IndustryPack table
+ * @_table: device table name
+ *
+ * This macro is used to create a struct ipack_device_id array (a device table)
+ * in a generic manner.
+ */
+#define DEFINE_IPACK_DEVICE_TABLE(_table) \
+	const struct ipack_device_id _table[] __devinitconst
+
+/**
+ * IPACK_DEVICE - macro used to describe a specific IndustryPack device
+ * @_format: the format version (currently either 1 or 2, 8 bit value)
+ * @vend:    the 8 or 24 bit IndustryPack Vendor ID
+ * @dev:     the 8 or 16  bit IndustryPack Device ID
+ *
+ * This macro is used to create a struct ipack_device_id that matches a specific
+ * device.
+ */
+#define IPACK_DEVICE(_format, vend, dev) \
+	 .format = (_format), \
+	 .vendor = (vend), \
+	 .device = (dev)
diff --git a/include/linux/ipack_ids.h b/include/linux/ipack_ids.h
new file mode 100644
index 0000000..8153fee
--- /dev/null
+++ b/include/linux/ipack_ids.h
@@ -0,0 +1,32 @@
+/*
+ * IndustryPack Fromat, Vendor and Device IDs.
+ */
+
+/* ID section format versions */
+#define IPACK_ID_VERSION_INVALID	0x00
+#define IPACK_ID_VERSION_1		0x01
+#define IPACK_ID_VERSION_2		0x02
+
+/* Vendors and devices. Sort key: vendor first, device next. */
+#define IPACK1_VENDOR_ID_RESERVED1	0x00
+#define IPACK1_VENDOR_ID_RESERVED2	0xFF
+#define IPACK1_VENDOR_ID_UNREGISTRED01	0x01
+#define IPACK1_VENDOR_ID_UNREGISTRED02	0x02
+#define IPACK1_VENDOR_ID_UNREGISTRED03	0x03
+#define IPACK1_VENDOR_ID_UNREGISTRED04	0x04
+#define IPACK1_VENDOR_ID_UNREGISTRED05	0x05
+#define IPACK1_VENDOR_ID_UNREGISTRED06	0x06
+#define IPACK1_VENDOR_ID_UNREGISTRED07	0x07
+#define IPACK1_VENDOR_ID_UNREGISTRED08	0x08
+#define IPACK1_VENDOR_ID_UNREGISTRED09	0x09
+#define IPACK1_VENDOR_ID_UNREGISTRED10	0x0A
+#define IPACK1_VENDOR_ID_UNREGISTRED11	0x0B
+#define IPACK1_VENDOR_ID_UNREGISTRED12	0x0C
+#define IPACK1_VENDOR_ID_UNREGISTRED13	0x0D
+#define IPACK1_VENDOR_ID_UNREGISTRED14	0x0E
+#define IPACK1_VENDOR_ID_UNREGISTRED15	0x0F
+
+#define IPACK1_VENDOR_ID_SBS            0xF0
+#define IPACK1_DEVICE_ID_SBS_OCTAL_232  0x22
+#define IPACK1_DEVICE_ID_SBS_OCTAL_422  0x2A
+#define IPACK1_DEVICE_ID_SBS_OCTAL_485  0x48
-- 
1.7.10.4

