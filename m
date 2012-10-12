Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab2JLOgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 10:36:31 -0400
Received: from atlantis.wh2.tu-dresden.de ([141.30.228.39]:55006 "EHLO
	atlantis.wh2.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756431Ab2JLOg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 10:36:28 -0400
From: Lars Poeschel <larsi@wh2.tu-dresden.de>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, jic23@cam.ac.uk, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, Lars Poeschel <poeschel@lemonage.de>
Subject: [PATCH v2 1/4] mfd: add viperboard driver
Date: Fri, 12 Oct 2012 16:34:26 +0200
Message-Id: <1350052469-27802-1-git-send-email-larsi@wh2.tu-dresden.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120925085559.GL28670@sortiz-mobl>
References: <20120925085559.GL28670@sortiz-mobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>

Add mfd driver for Nano River Technologies viperboard.

Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
 drivers/mfd/Kconfig            |   14 ++++
 drivers/mfd/Makefile           |    1 +
 drivers/mfd/viperboard.c       |  149 ++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/viperboard.h |   99 ++++++++++++++++++++++++++
 4 files changed, 263 insertions(+)
 create mode 100644 drivers/mfd/viperboard.c
 create mode 100644 include/linux/mfd/viperboard.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index b1a1462..98d9fa3 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1003,6 +1003,20 @@ config MFD_PALMAS
 	  If you say yes here you get support for the Palmas
 	  series of PMIC chips from Texas Instruments.
 
+config MFD_VIPERBOARD
+        tristate "Support for Nano River Technologies Viperboard"
+	select MFD_CORE
+	depends on USB && IIO
+        default n
+        help
+          Say yes here if you want support for Nano River Technologies
+          Viperboard.
+          There are mfd cell drivers available for i2c master, adc and
+          both gpios found on the board. The spi part does not yet
+          have a driver.
+          You need to select the mfd cell drivers seperatly.
+          The drivers do not support all features the board exposes.
+
 endmenu
 endif
 
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 79dd22d..6ab6b64 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -128,6 +128,7 @@ obj-$(CONFIG_MFD_TPS65090)	+= tps65090.o
 obj-$(CONFIG_MFD_AAT2870_CORE)	+= aat2870-core.o
 obj-$(CONFIG_MFD_INTEL_MSIC)	+= intel_msic.o
 obj-$(CONFIG_MFD_PALMAS)	+= palmas.o
+obj-$(CONFIG_MFD_VIPERBOARD)    += viperboard.o
 obj-$(CONFIG_MFD_RC5T583)	+= rc5t583.o rc5t583-irq.o
 obj-$(CONFIG_MFD_SEC_CORE)	+= sec-core.o sec-irq.o
 obj-$(CONFIG_MFD_ANATOP)	+= anatop-mfd.o
diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
new file mode 100644
index 0000000..8095ea2
--- /dev/null
+++ b/drivers/mfd/viperboard.c
@@ -0,0 +1,149 @@
+/*
+ *  Nano River Technologies viperboard driver
+ *
+ *  This is the core driver for the viperboard. There are cell drivers
+ *  available for I2C, ADC and both GPIOs. SPI is not yet supported
+ *  The drivers do not support all features the board exposes. See user
+ *  manual of the viperboard.
+ *
+ *  (C) 2012 by Lemonage GmbH
+ *  Author: Lars Poeschel <poeschel@lemonage.de>
+ *  All rights reserved.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/mutex.h>
+
+#include <linux/mfd/core.h>
+#include <linux/mfd/viperboard.h>
+
+#include <linux/usb.h>
+
+
+static const struct usb_device_id vprbrd_table[] = {
+	{ USB_DEVICE(0x2058, 0x1005) },   /* Nano River Technologies */
+	{ }                               /* Terminating entry */
+};
+
+MODULE_DEVICE_TABLE(usb, vprbrd_table);
+
+static void vprbrd_dev_release(struct device *dev)
+{
+	return;
+}
+
+static void vprbrd_free(struct vprbrd *dev)
+{
+	usb_put_dev(dev->usb_dev);
+	kfree(dev);
+}
+
+static struct mfd_cell vprbrd_devs[] = {
+};
+
+static int vprbrd_probe(struct usb_interface *interface,
+			      const struct usb_device_id *id)
+{
+	struct vprbrd *vb;
+
+	u16 version = 0;
+	int pipe, ret;
+	unsigned char buf[1];
+
+	/* allocate memory for our device state and initialize it */
+	vb = kzalloc(sizeof(*vb), GFP_KERNEL);
+	if (vb == NULL) {
+		dev_err(&interface->dev, "Out of memory\n");
+		return -ENOMEM;
+	}
+
+	device_initialize(&vb->pdev.dev);
+	vb->pdev.dev.parent = &interface->dev;
+	vb->pdev.dev.release = vprbrd_dev_release;
+	dev_set_name(&vb->pdev.dev, "%s-%s-mfd-holder",
+		dev_driver_string(&interface->dev), dev_name(&interface->dev));
+	ret = device_add(&vb->pdev.dev);
+	if (ret) {
+		dev_err(&interface->dev, "Failed to add mfd holder device.");
+		goto error;
+	}
+
+	mutex_init(&vb->lock);
+
+	vb->usb_dev = usb_get_dev(interface_to_usbdev(interface));
+
+	/* save our data pointer in this interface device */
+	usb_set_intfdata(interface, vb);
+	dev_set_drvdata(&vb->pdev.dev, vb);
+
+	/* get version information, major first, minor then */
+	pipe = usb_rcvctrlpipe(vb->usb_dev, 0);
+	ret = usb_control_msg(vb->usb_dev, pipe, 0xea, 0xc0, 0x0000,
+		0x0000, buf, 1, 100);
+	if (ret == 1)
+		version = buf[0];
+
+	ret = usb_control_msg(vb->usb_dev, pipe, 0xeb, 0xc0, 0x0000,
+		0x0000, buf, 1, 100);
+	if (ret == 1) {
+		version <<= 8;
+		version = version | buf[0];
+	}
+
+	dev_info(&interface->dev,
+		 "version %x.%02x found at bus %03d address %03d\n",
+		 version >> 8, version & 0xff,
+		 vb->usb_dev->bus->busnum, vb->usb_dev->devnum);
+
+	ret = mfd_add_devices(&vb->pdev.dev, -1, vprbrd_devs,
+				ARRAY_SIZE(vprbrd_devs), NULL, 0, NULL);
+	if (ret != 0) {
+		dev_err(&interface->dev, "Failed to add mfd devices to core.");
+		goto error;
+	}
+
+	return 0;
+
+error:
+	put_device(&vb->pdev.dev);
+	if (vb)
+		vprbrd_free(vb);
+
+	return ret;
+}
+
+static void vprbrd_disconnect(struct usb_interface *interface)
+{
+	struct vprbrd *vb = usb_get_intfdata(interface);
+
+	mfd_remove_devices(&vb->pdev.dev);
+	usb_set_intfdata(interface, NULL);
+	device_unregister(&vb->pdev.dev);
+	vprbrd_free(vb);
+
+	dev_dbg(&interface->dev, "disconnected\n");
+}
+
+static struct usb_driver vprbrd_driver = {
+	.name		= "viperboard",
+	.probe		= vprbrd_probe,
+	.disconnect	= vprbrd_disconnect,
+	.id_table	= vprbrd_table,
+};
+
+module_usb_driver(vprbrd_driver);
+
+MODULE_DESCRIPTION("Nano River Technologies viperboard mfd core driver");
+MODULE_AUTHOR("Lars Poeschel <poeschel@lemonage.de>");
+MODULE_LICENSE("GPL");
+
diff --git a/include/linux/mfd/viperboard.h b/include/linux/mfd/viperboard.h
new file mode 100644
index 0000000..3f3f777
--- /dev/null
+++ b/include/linux/mfd/viperboard.h
@@ -0,0 +1,99 @@
+/*
+ *  include/linux/mfd/viperboard.h
+ *
+ *  Nano River Technologies viperboard definitions
+ *
+ *  (C) 2012 by Lemonage GmbH
+ *  Author: Lars Poeschel <poeschel@lemonage.de>
+ *  All rights reserved.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#ifndef __MFD_VIPERBOARD_H__
+#define __MFD_VIPERBOARD_H__
+
+#include <linux/types.h>
+#include <linux/usb.h>
+
+#define VPRBRD_EP_OUT               0x02
+#define VPRBRD_EP_IN                0x86
+
+#define VPRBRD_I2C_MSG_LEN          512 /* max length of a msg on USB level */
+
+#define VPRBRD_I2C_FREQ_6MHZ        1                        /*   6 MBit/s */
+#define VPRBRD_I2C_FREQ_3MHZ        2                        /*   3 MBit/s */
+#define VPRBRD_I2C_FREQ_1MHZ        3                        /*   1 MBit/s */
+#define VPRBRD_I2C_FREQ_FAST        4                        /* 400 kbit/s */
+#define VPRBRD_I2C_FREQ_400KHZ      VPRBRD_I2C_FREQ_FAST
+#define VPRBRD_I2C_FREQ_200KHZ      5                        /* 200 kbit/s */
+#define VPRBRD_I2C_FREQ_STD         6                        /* 100 kbit/s */
+#define VPRBRD_I2C_FREQ_100KHZ      VPRBRD_I2C_FREQ_STD
+#define VPRBRD_I2C_FREQ_10KHZ       7                        /*  10 kbit/s */
+
+#define VPRBRD_I2C_CMD_WRITE        0x00
+#define VPRBRD_I2C_CMD_READ         0x01
+#define VPRBRD_I2C_CMD_ADDR         0x02
+
+struct __packed vprbrd_i2c_write_hdr {
+	u8 cmd;
+	u16 addr;
+	u8 len1;
+	u8 len2;
+	u8 last;
+	u8 chan;
+	u16 spi;
+};
+
+struct __packed vprbrd_i2c_read_hdr {
+	u8 cmd;
+	u16 addr;
+	u8 len0;
+	u8 len1;
+	u8 len2;
+	u8 len3;
+	u8 len4;
+	u8 len5;
+	u16 tf1;                        /* transfer 1 length */
+	u16 tf2;                        /* transfer 2 length */
+};
+
+struct __packed vprbrd_i2c_status {
+	u8 unknown[11];
+	u8 status;
+};
+
+struct __packed vprbrd_i2c_write_msg {
+	struct vprbrd_i2c_write_hdr header;
+	u8 data[VPRBRD_I2C_MSG_LEN
+		- sizeof(struct vprbrd_i2c_write_hdr)];
+};
+
+struct __packed vprbrd_i2c_read_msg {
+	struct vprbrd_i2c_read_hdr header;
+	u8 data[VPRBRD_I2C_MSG_LEN
+		- sizeof(struct vprbrd_i2c_read_hdr)];
+};
+
+struct __packed vprbrd_i2c_addr_msg {
+	u8 cmd;
+	u8 addr;
+	u8 unknown1;
+	u16 len;
+	u8 unknown2;
+	u8 unknown3;
+};
+
+/* Structure to hold all device specific stuff */
+struct vprbrd {
+	struct usb_device *usb_dev; /* the usb device for this device */
+	struct mutex lock;
+	u8 buf[sizeof(struct vprbrd_i2c_write_msg)];
+	struct platform_device pdev;
+};
+
+#endif /* __MFD_VIPERBOARD_H__ */
-- 
1.7.10.4

