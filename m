Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab0KBRNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 13:13:07 -0400
Received: from king.tilera.com ([72.1.168.226]:13543 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254Ab0KBRM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 13:12:58 -0400
Message-Id: <201011021712.oA2HCsMe028141@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 2 Nov 2010 13:05:34 -0400
Subject: [PATCH] drivers/i2c: add support for tile architecture "bus" for I2C devices
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
X-OriginalArrivalTime: 02 Nov 2010 17:12:55.0752 (UTC) FILETIME=[30D90480:01CB7AB1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change enables the Linux driver to access i2c devices via
the Tilera hypervisor's virtualized API.

Note that the arch/tile/include/hv/ headers are "upstream" headers
that likely benefit less from LKML review.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/hv/drv_i2cm_intf.h |   68 +++++++
 drivers/i2c/busses/Kconfig           |   10 +
 drivers/i2c/busses/Makefile          |    1 +
 drivers/i2c/busses/i2c-tile.c        |  324 ++++++++++++++++++++++++++++++++++
 4 files changed, 403 insertions(+), 0 deletions(-)
 create mode 100644 arch/tile/include/hv/drv_i2cm_intf.h
 create mode 100644 drivers/i2c/busses/i2c-tile.c

diff --git a/arch/tile/include/hv/drv_i2cm_intf.h b/arch/tile/include/hv/drv_i2cm_intf.h
new file mode 100644
index 0000000..6584a72
--- /dev/null
+++ b/arch/tile/include/hv/drv_i2cm_intf.h
@@ -0,0 +1,68 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/**
+ * @file drv_i2cm_intf.h
+ * Interface definitions for the I2CM driver.
+ *
+ * The I2C Master interface driver provides a manner for supervisors to
+ * access the I2C devices on the I2C bus.
+ *
+ * When the supervisor issues an I2C data transaction, it stores the i2c
+ * device slave address and the data offset within the device in the offset
+ * of the HV I2C device handle. The low half-word contains the slave address
+ * while the data offset is stored in byte 2 and 3. For the write access,
+ * the first 1 or 2 bytes of the write data contain the device data address
+ * if the data offset field of the HV device handle offset is 0; otherwise,
+ * the write data are puse data payload. For the read access, it is always
+ * preceded by a dummy write access which should contain an either 1-byte or
+ * 2-byte device data address while the read message holds no addressing
+ * information.
+ */
+
+#ifndef _SYS_HV_INCLUDE_DRV_I2CM_INTF_H
+#define _SYS_HV_INCLUDE_DRV_I2CM_INTF_H
+
+/** Maximum size of an HV I2C transfer. */
+#define HV_I2CM_CHUNK_SIZE 128
+
+/** Length of the i2c device name. */
+#define I2C_DEV_NAME_SIZE   20
+
+/** I2C device descriptor, to be exported to the client OS. */
+typedef struct
+{
+  char name[I2C_DEV_NAME_SIZE];   /**< Device name, e.g. "24c512". */
+  uint32_t addr;                  /**< I2C device slave address */
+}
+tile_i2c_desc_t;
+
+/** Get the number of i2c devices. Read-only, takes a 4-byte value. */
+#define I2C_GET_NUM_DEVS_OFF   0xF0000000
+
+/** Get i2c device info. Read-only, takes an array of tile_i2c_desc_t's. */
+#define I2C_GET_DEV_INFO_OFF   0xF0000004
+
+/** This structure is used to encode the I2C device slave address
+ *  and the chip data offset and is passed to the HV in the offset
+ *  of the i2cm HV device file.
+ */
+typedef struct
+{
+  uint32_t addr:8;               /**< I2C device slave address */
+  uint32_t data_offset:24;       /**< I2C device data offset */
+}
+tile_i2c_addr_desc_t;
+
+#endif /* _SYS_HV_INCLUDE_DRV_I2CM_INTF_H */
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 3a6321c..5d8d8ab 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -607,6 +607,16 @@ config I2C_STU300
 	  This driver can also be built as a module. If so, the module
 	  will be called i2c-stu300.
 
+config I2C_TILE
+	tristate "Tilera I2C hypervisor interface"
+	depends on TILE
+	help
+	  This supports the Tilera hypervisor interface for
+	  communicating with I2C devices attached to the chip.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called i2c-tile.
+
 config I2C_VERSATILE
 	tristate "ARM Versatile/Realview I2C bus support"
 	depends on ARCH_VERSATILE || ARCH_REALVIEW || ARCH_VEXPRESS
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 84cb16a..0a739eb 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -58,6 +58,7 @@ obj-$(CONFIG_I2C_SH7760)	+= i2c-sh7760.o
 obj-$(CONFIG_I2C_SH_MOBILE)	+= i2c-sh_mobile.o
 obj-$(CONFIG_I2C_SIMTEC)	+= i2c-simtec.o
 obj-$(CONFIG_I2C_STU300)	+= i2c-stu300.o
+obj-$(CONFIG_I2C_TILE)		+= i2c-tile.o
 obj-$(CONFIG_I2C_VERSATILE)	+= i2c-versatile.o
 obj-$(CONFIG_I2C_OCTEON)	+= i2c-octeon.o
 obj-$(CONFIG_I2C_XILINX)	+= i2c-xiic.o
diff --git a/drivers/i2c/busses/i2c-tile.c b/drivers/i2c/busses/i2c-tile.c
new file mode 100644
index 0000000..b4e8988
--- /dev/null
+++ b/drivers/i2c/busses/i2c-tile.c
@@ -0,0 +1,324 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * Tilera-specific I2C driver.
+ *
+ * This source code is derived from the following driver:
+ *
+ * i2c Support for Atmel's AT91 Two-Wire Interface (TWI)
+ *
+ * Copyright (C) 2004 Rick Bronson
+ * Converted to 2.6 by Andrew Victor <andrew@sanpeople.com>
+ *
+ * Borrowed heavily from original work by:
+ * Copyright (C) 2000 Philip Edelbrock <phil@stimpy.netroedge.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/errno.h>
+#include <linux/platform_device.h>
+#include <linux/uaccess.h>
+#include <hv/hypervisor.h>
+#include <hv/drv_i2cm_intf.h>
+
+#define DRV_NAME	"i2c-tile"
+
+static char i2cm_device[16] = "i2cm/0";
+
+/* Handle for hypervisor device. */
+static int i2cm_hv_devhdl;
+
+/*
+ * The I2C platform device.
+ */
+static struct platform_device *i2c_platform_device;
+
+static int xfer_msg(struct i2c_adapter *adap, struct i2c_msg *pmsg)
+{
+	int retval = 0;
+	int data_offset = 0;
+	int addr = pmsg->addr;
+	int length = pmsg->len;
+	char *buf = pmsg->buf;
+
+	/* HV uses 8-bit slave addresses. */
+	addr <<= 1;
+
+	while (length) {
+		int hv_retval;
+		tile_i2c_addr_desc_t hv_offset = {
+			.addr = addr,
+			.data_offset = data_offset,
+		};
+
+		int bytes_this_pass = length;
+		if (bytes_this_pass > HV_I2CM_CHUNK_SIZE)
+			bytes_this_pass = HV_I2CM_CHUNK_SIZE;
+
+		if (pmsg->flags & I2C_M_RD)
+			hv_retval = hv_dev_pread(i2cm_hv_devhdl, 0,
+					(HV_VirtAddr) buf,
+					bytes_this_pass,
+					*(int *) &hv_offset);
+		else
+			hv_retval = hv_dev_pwrite(i2cm_hv_devhdl, 0,
+					(HV_VirtAddr) buf,
+					bytes_this_pass,
+					*(int *) &hv_offset);
+		if (hv_retval < 0) {
+			pr_err(DRV_NAME ": %s failed, error %d\n",
+				(pmsg->flags & I2C_M_RD) ? "hv_dev_pread" :
+				"hv_dev_pwrite", hv_retval);
+			if (hv_retval == HV_ENODEV)
+				retval = -ENODEV;
+			else
+				retval = -EIO;
+			break;
+		}
+
+		buf += hv_retval;
+		data_offset += hv_retval;
+		length -= hv_retval;
+	}
+
+	return retval;
+}
+
+/*
+ * Generic I2C master transfer routine.
+ */
+static int tile_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *pmsg,
+			 int num)
+{
+	int ret, i;
+
+	/* We don't support ten bit chip address. */
+	if (pmsg->flags & I2C_M_TEN)
+		return -EINVAL;
+
+	for (i = 0; i < num; i++) {
+		if (pmsg->len && pmsg->buf) {
+
+			ret = xfer_msg(adap, pmsg);
+			if (ret)
+				return ret;
+
+			pmsg++;
+		} else
+			return -EINVAL;
+	}
+
+	return i;
+}
+
+/*
+ * Return list of supported functionality.
+ */
+static u32 tile_i2c_functionality(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_I2C;
+}
+
+static const struct i2c_algorithm tile_i2c_algorithm = {
+	.master_xfer	= tile_i2c_xfer,
+	.functionality	= tile_i2c_functionality,
+};
+
+/*
+ * This routine is called to register all I2C devices that are connected to
+ * the I2C bus. This should be done at arch_initcall time, before declaring
+ * the I2C adapter. This function does the following:
+ *
+ * 1. Retrieve the I2C device list from the HV which selectively grants the
+ *    access permission of individual I2C devices, and build an array of struct
+ *    i2c_board_info.
+ * 2. Statically declare these I2C devices by calling
+ *    i2c_register_board_info().
+ */
+static int __init tile_i2c_dev_init(void)
+{
+	int ret;
+	int i;
+	int i2c_devs = 0;
+	struct i2c_board_info *tile_i2c_devices;
+	int i2c_desc_size;
+	tile_i2c_desc_t *tile_i2c_desc;
+
+	/* Open the HV i2cm device. */
+	i2cm_hv_devhdl = hv_dev_open((HV_VirtAddr)i2cm_device, 0);
+	if (i2cm_hv_devhdl < 0) {
+		switch (i2cm_hv_devhdl) {
+		case HV_ENODEV:
+			return -ENODEV;
+		default:
+			return (ssize_t)i2cm_hv_devhdl;
+		}
+	}
+
+	ret = hv_dev_pread(i2cm_hv_devhdl, 0, (HV_VirtAddr)&i2c_devs,
+			sizeof(i2c_devs), I2C_GET_NUM_DEVS_OFF);
+	if (ret <= 0) {
+		pr_err(DRV_NAME ": hv_dev_pread(I2C_GET_NUM_DEVS_OFF)"
+		       " failed, error %d\n", ret);
+		return -EIO;
+	}
+
+	if (i2c_devs == 0)
+		return 0;
+
+	pr_info(DRV_NAME ": detected %d I2C devices.\n", i2c_devs);
+
+	i2c_desc_size = i2c_devs * sizeof(tile_i2c_desc_t);
+	tile_i2c_desc = kzalloc(i2c_desc_size, GFP_KERNEL);
+	if (!tile_i2c_desc)
+		return -ENOMEM;
+
+	ret = hv_dev_pread(i2cm_hv_devhdl, 0, (HV_VirtAddr)tile_i2c_desc,
+			i2c_desc_size, I2C_GET_DEV_INFO_OFF);
+	if (ret <= 0) {
+		pr_err(DRV_NAME ": hv_dev_pread(I2C_GET_DEV_INFO_OFF)"
+		       " failed, error %d\n", ret);
+		return -EIO;
+	}
+
+	i2c_desc_size = i2c_devs * sizeof(struct i2c_board_info);
+	tile_i2c_devices = kzalloc(i2c_desc_size, GFP_KERNEL);
+	if (!tile_i2c_devices)
+		return -ENOMEM;
+
+	for (i = 0; i < i2c_devs; i++) {
+		strncpy(tile_i2c_devices[i].type, tile_i2c_desc[i].name,
+			I2C_NAME_SIZE);
+		/* HV uses 8-bit slave addresses, convert to 7bit for Linux. */
+		tile_i2c_devices[i].addr = tile_i2c_desc[i].addr >> 1;
+	}
+
+	ret = i2c_register_board_info(0, tile_i2c_devices, i2c_devs);
+
+	kfree(tile_i2c_desc);
+	kfree(tile_i2c_devices);
+
+	return ret;
+}
+arch_initcall(tile_i2c_dev_init);
+
+/*
+ * I2C adapter probe routine which registers the I2C adapter with the I2C core.
+ */
+static int __devinit tile_i2c_probe(struct platform_device *dev)
+{
+	struct i2c_adapter *adapter;
+	int ret;
+
+	adapter = kzalloc(sizeof(struct i2c_adapter), GFP_KERNEL);
+	if (adapter == NULL) {
+		ret = -ENOMEM;
+		goto malloc_err;
+	}
+
+	adapter->owner   = THIS_MODULE;
+
+	/*
+	 * If "dev->id" is negative we consider it as zero.
+	 * The reason to do so is to avoid sysfs names that only make
+	 * sense when there are multiple adapters.
+	 */
+	adapter->nr = dev->id != -1 ? dev->id : 0;
+	snprintf(adapter->name, sizeof(adapter->name), "tile_i2c-i2c.%u",
+		 adapter->nr);
+
+	adapter->algo = &tile_i2c_algorithm;
+	adapter->class = I2C_CLASS_HWMON;
+	adapter->dev.parent = &dev->dev;
+
+	ret = i2c_add_numbered_adapter(adapter);
+	if (ret < 0) {
+		pr_info(DRV_NAME ": %s registration failed\n",
+			adapter->name);
+		goto add_adapter_err;
+	}
+
+	platform_set_drvdata(dev, adapter);
+
+	return 0;
+
+add_adapter_err:
+	kfree(adapter);
+malloc_err:
+	return ret;
+}
+
+/*
+ * I2C adapter cleanup routine.
+ */
+static int __devexit tile_i2c_remove(struct platform_device *dev)
+{
+	struct i2c_adapter *adapter = platform_get_drvdata(dev);
+	int rc;
+
+	rc = i2c_del_adapter(adapter);
+	platform_set_drvdata(dev, NULL);
+
+	kfree(adapter);
+
+	return rc;
+}
+
+static struct platform_driver tile_i2c_driver = {
+	.driver		= {
+		.name	= DRV_NAME,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= tile_i2c_probe,
+	.remove		= __devexit_p(tile_i2c_remove),
+};
+
+/*
+ * Driver init routine.
+ */
+static int __init tile_i2c_init(void)
+{
+	int err;
+
+	err = platform_driver_register(&tile_i2c_driver);
+	if (err)
+		return err;
+
+	i2c_platform_device =
+		platform_device_register_simple(DRV_NAME, -1, NULL, 0);
+	if (IS_ERR(i2c_platform_device)) {
+		err = PTR_ERR(i2c_platform_device);
+		goto unreg_platform_driver;
+	}
+
+	return 0;
+
+unreg_platform_driver:
+	platform_driver_unregister(&tile_i2c_driver);
+	return err;
+}
+
+/*
+ * Driver cleanup routine.
+ */
+static void __exit tile_i2c_exit(void)
+{
+	platform_driver_unregister(&tile_i2c_driver);
+}
+
+module_init(tile_i2c_init);
+module_exit(tile_i2c_exit);
-- 
1.6.5.2

