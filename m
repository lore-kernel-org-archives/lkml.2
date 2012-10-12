Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869Ab2JLOgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 10:36:39 -0400
Received: from atlantis.wh2.tu-dresden.de ([141.30.228.39]:55030 "EHLO
	atlantis.wh2.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757135Ab2JLOgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 10:36:35 -0400
From: Lars Poeschel <larsi@wh2.tu-dresden.de>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, jic23@cam.ac.uk, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, Lars Poeschel <poeschel@lemonage.de>
Subject: [PATCH v2 3/4] i2c: add viperboard i2c master driver
Date: Fri, 12 Oct 2012 16:34:28 +0200
Message-Id: <1350052469-27802-3-git-send-email-larsi@wh2.tu-dresden.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350052469-27802-1-git-send-email-larsi@wh2.tu-dresden.de>
References: <20120925085559.GL28670@sortiz-mobl>
 <1350052469-27802-1-git-send-email-larsi@wh2.tu-dresden.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>

This adds the mfd cell to use the i2c part of the Nano River Technologies
viperboard as i2c master.

Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
 drivers/i2c/busses/Kconfig          |   10 +
 drivers/i2c/busses/Makefile         |    1 +
 drivers/i2c/busses/i2c-viperboard.c |  442 +++++++++++++++++++++++++++++++++++
 drivers/mfd/viperboard.c            |    3 +
 4 files changed, 456 insertions(+)
 create mode 100644 drivers/i2c/busses/i2c-viperboard.c

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 42d9fdd..48344cb 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -803,6 +803,16 @@ config I2C_TINY_USB
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-tiny-usb.
 
+config I2C_VIPERBOARD
+	tristate "Viperboard I2C master support"
+	depends on MFD_VIPERBOARD && USB
+	help
+	  Say yes here to access the I2C part of the Nano River
+	  Technologies Viperboard as I2C master.
+          See viperboard API specification and Nano
+          River Tech's viperboard.h for detailed meaning
+          of the module parameters.
+
 comment "Other I2C/SMBus bus drivers"
 
 config I2C_ACORN
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 37c4182..cc3a376 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -78,6 +78,7 @@ obj-$(CONFIG_I2C_PARPORT)	+= i2c-parport.o
 obj-$(CONFIG_I2C_PARPORT_LIGHT)	+= i2c-parport-light.o
 obj-$(CONFIG_I2C_TAOS_EVM)	+= i2c-taos-evm.o
 obj-$(CONFIG_I2C_TINY_USB)	+= i2c-tiny-usb.o
+obj-$(CONFIG_I2C_VIPERBOARD)	+= i2c-viperboard.o
 
 # Other I2C/SMBus bus drivers
 obj-$(CONFIG_I2C_ACORN)		+= i2c-acorn.o
diff --git a/drivers/i2c/busses/i2c-viperboard.c b/drivers/i2c/busses/i2c-viperboard.c
new file mode 100644
index 0000000..c8da2a7
--- /dev/null
+++ b/drivers/i2c/busses/i2c-viperboard.c
@@ -0,0 +1,442 @@
+/*
+ *  Nano River Technologies viperboard i2c master driver
+ *
+ *  (C) 2012 by Lemonage GmbH
+ *  Author: Lars Poeschel <poeschel@lemonage.de>
+ *  All rights reserved.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the	License, or (at your
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
+#include <linux/platform_device.h>
+
+#include <linux/usb.h>
+#include <linux/i2c.h>
+
+#include <linux/mfd/viperboard.h>
+
+struct vprbrd_i2c {
+	struct i2c_adapter i2c;
+};
+
+/* i2c bus frequency module parameter */
+static unsigned char i2c_bus_freq = 6;
+module_param(i2c_bus_freq, byte, 0);
+MODULE_PARM_DESC(i2c_bus_freq, "i2c bus frequency (default is 6 for 100kHz)");
+
+static int vprbrd_i2c_status(struct i2c_adapter *i2c,
+	struct vprbrd_i2c_status *status, bool prev_error)
+{
+	u16 bytes_xfer;
+	int ret;
+	struct vprbrd *vb = (struct vprbrd *)i2c->algo_data;
+
+	/* check for protocol error */
+	bytes_xfer = sizeof(struct vprbrd_i2c_status);
+
+	ret = usb_control_msg(vb->usb_dev, usb_rcvctrlpipe(vb->usb_dev, 0),
+		0xe9, 0xc0, 0x0000, 0x0000, status, bytes_xfer, 100);
+
+	if (ret != bytes_xfer)
+		prev_error = true;
+
+	if (prev_error) {
+		dev_err(&i2c->dev, "failure in usb communication\n");
+		return -EREMOTEIO;
+	}
+
+	dev_dbg(&i2c->dev, "  status = %d\n", status->status);
+	if (status->status != 0x00) {
+		dev_err(&i2c->dev, "failure: i2c protocol error\n");
+		return -EPROTO;
+	}
+	return 0;
+}
+
+static int vprbrd_i2c_receive(struct usb_device *usb_dev,
+	struct vprbrd_i2c_read_msg *rmsg, int bytes_xfer)
+{
+	int ret, bytes_actual;
+	int error = 0;
+
+	/* send the read request */
+	ret = usb_bulk_msg(usb_dev,
+		usb_sndbulkpipe(usb_dev, VPRBRD_EP_OUT), rmsg,
+		sizeof(struct vprbrd_i2c_read_hdr), &bytes_actual, 100);
+
+	if ((ret < 0)
+		|| (bytes_actual != sizeof(struct vprbrd_i2c_read_hdr))) {
+		dev_err(&usb_dev->dev, "failure transmitting usb\n");
+		error = -EREMOTEIO;
+	}
+
+	/* read the actual data */
+	ret = usb_bulk_msg(usb_dev,
+		usb_rcvbulkpipe(usb_dev, VPRBRD_EP_IN), rmsg,
+		bytes_xfer, &bytes_actual, 100);
+
+	if ((ret < 0) || (bytes_xfer != bytes_actual)) {
+		dev_err(&usb_dev->dev, "failure receiving usb\n");
+		error = -EREMOTEIO;
+	}
+	return error;
+}
+
+static int vprbrd_i2c_addr(struct usb_device *usb_dev,
+	struct vprbrd_i2c_addr_msg *amsg)
+{
+	int ret, bytes_actual;
+
+	ret = usb_bulk_msg(usb_dev,
+		usb_sndbulkpipe(usb_dev, VPRBRD_EP_OUT), amsg,
+		sizeof(struct vprbrd_i2c_addr_msg), &bytes_actual, 100);
+
+	if ((ret < 0) ||
+			(sizeof(struct vprbrd_i2c_addr_msg) != bytes_actual)) {
+		dev_err(&usb_dev->dev, "failure transmitting usb\n");
+		return -EREMOTEIO;
+	}
+	return 0;
+}
+
+static int vprbrd_i2c_read(struct vprbrd *vb, struct i2c_msg *msg)
+{
+	int ret;
+	u16 remain_len, bytes_xfer, len1, len2,
+		start = 0x0000;
+	struct vprbrd_i2c_read_msg *rmsg =
+		(struct vprbrd_i2c_read_msg *)vb->buf;
+
+	remain_len = msg->len;
+	rmsg->header.cmd = VPRBRD_I2C_CMD_READ;
+	while (remain_len > 0) {
+		rmsg->header.addr = cpu_to_le16(start + 0x4000);
+		if (remain_len <= 255) {
+			len1 = remain_len;
+			len2 = 0x00;
+			rmsg->header.len0 = remain_len;
+			rmsg->header.len1 = 0x00;
+			rmsg->header.len2 = 0x00;
+			rmsg->header.len3 = 0x00;
+			rmsg->header.len4 = 0x00;
+			rmsg->header.len5 = 0x00;
+			remain_len = 0;
+		} else if (remain_len <= 510) {
+			len1 = remain_len;
+			len2 = 0x00;
+			rmsg->header.len0 = remain_len - 255;
+			rmsg->header.len1 = 0xff;
+			rmsg->header.len2 = 0x00;
+			rmsg->header.len3 = 0x00;
+			rmsg->header.len4 = 0x00;
+			rmsg->header.len5 = 0x00;
+			remain_len = 0;
+		} else if (remain_len <= 512) {
+			len1 = remain_len;
+			len2 = 0x00;
+			rmsg->header.len0 = remain_len - 510;
+			rmsg->header.len1 = 0xff;
+			rmsg->header.len2 = 0xff;
+			rmsg->header.len3 = 0x00;
+			rmsg->header.len4 = 0x00;
+			rmsg->header.len5 = 0x00;
+			remain_len = 0;
+		} else if (remain_len <= 767) {
+			len1 = 512;
+			len2 = remain_len - 512;
+			rmsg->header.len0 = 0x02;
+			rmsg->header.len1 = 0xff;
+			rmsg->header.len2 = 0xff;
+			rmsg->header.len3 = remain_len - 512;
+			rmsg->header.len4 = 0x00;
+			rmsg->header.len5 = 0x00;
+			bytes_xfer = remain_len;
+			remain_len = 0;
+		} else if (remain_len <= 1022) {
+			len1 = 512;
+			len2 = remain_len - 512;
+			rmsg->header.len0 = 0x02;
+			rmsg->header.len1 = 0xff;
+			rmsg->header.len2 = 0xff;
+			rmsg->header.len3 = remain_len - 767;
+			rmsg->header.len4 = 0xff;
+			rmsg->header.len5 = 0x00;
+			remain_len = 0;
+		} else if (remain_len <= 1024) {
+			len1 = 512;
+			len2 = remain_len - 512;
+			rmsg->header.len0 = 0x02;
+			rmsg->header.len1 = 0xff;
+			rmsg->header.len2 = 0xff;
+			rmsg->header.len3 = remain_len - 1022;
+			rmsg->header.len4 = 0xff;
+			rmsg->header.len5 = 0xff;
+			remain_len = 0;
+		} else {
+			len1 = 512;
+			len2 = 512;
+			rmsg->header.len0 = 0x02;
+			rmsg->header.len1 = 0xff;
+			rmsg->header.len2 = 0xff;
+			rmsg->header.len3 = 0x02;
+			rmsg->header.len4 = 0xff;
+			rmsg->header.len5 = 0xff;
+			remain_len -= 1024;
+			start += 1024;
+		}
+		rmsg->header.tf1 = cpu_to_le16(len1);
+		rmsg->header.tf2 = cpu_to_le16(len2);
+
+		/* first read transfer */
+		ret = vprbrd_i2c_receive(vb->usb_dev, rmsg, len1);
+		if (ret < 0)
+			return ret;
+		/* copy the received data */
+		memcpy(msg->buf + start, rmsg, len1);
+
+		/* second read transfer if neccessary */
+		if (len2 > 0) {
+			ret = vprbrd_i2c_receive(vb->usb_dev, rmsg, len2);
+			if (ret < 0)
+				return ret;
+			/* copy the received data */
+			memcpy(msg->buf + start + 512, rmsg, len2);
+		}
+	}
+	return 0;
+}
+
+static int vprbrd_i2c_write(struct vprbrd *vb, struct i2c_msg *msg)
+{
+	int ret, bytes_actual;
+	u16 remain_len, bytes_xfer,
+		start = 0x0000;
+	struct vprbrd_i2c_write_msg *wmsg =
+		(struct vprbrd_i2c_write_msg *)vb->buf;
+
+	remain_len = msg->len;
+	wmsg->header.cmd = VPRBRD_I2C_CMD_WRITE;
+	wmsg->header.last = 0x00;
+	wmsg->header.chan = 0x00;
+	wmsg->header.spi = 0x0000;
+	while (remain_len > 0) {
+		wmsg->header.addr = cpu_to_le16(start + 0x4000);
+		if (remain_len > 503) {
+			wmsg->header.len1 = 0xff;
+			wmsg->header.len2 = 0xf8;
+			remain_len -= 503;
+			bytes_xfer = 503 + sizeof(struct vprbrd_i2c_write_hdr);
+			start += 503;
+		} else if (remain_len > 255) {
+			wmsg->header.len1 = 0xff;
+			wmsg->header.len2 = (remain_len - 255);
+			bytes_xfer = remain_len +
+				sizeof(struct vprbrd_i2c_write_hdr);
+			remain_len = 0;
+		} else {
+			wmsg->header.len1 = remain_len;
+			wmsg->header.len2 = 0x00;
+			bytes_xfer = remain_len +
+				sizeof(struct vprbrd_i2c_write_hdr);
+			remain_len = 0;
+		}
+		memcpy(wmsg->data, msg->buf + start,
+			bytes_xfer - sizeof(struct vprbrd_i2c_write_hdr));
+
+		ret = usb_bulk_msg(vb->usb_dev,
+			usb_sndbulkpipe(vb->usb_dev,
+			VPRBRD_EP_OUT), wmsg,
+			bytes_xfer, &bytes_actual, 100);
+		if ((ret < 0) || (bytes_xfer != bytes_actual))
+			return -EREMOTEIO;
+	}
+	return 0;
+}
+
+static int vprbrd_i2c_xfer(struct i2c_adapter *i2c, struct i2c_msg *msgs,
+		int num)
+{
+	struct i2c_msg *pmsg;
+	int i, ret,
+		error = 0;
+	struct vprbrd *vb = (struct vprbrd *)i2c->algo_data;
+	struct vprbrd_i2c_addr_msg *amsg =
+		(struct vprbrd_i2c_addr_msg *)vb->buf;
+	struct vprbrd_i2c_status *smsg = (struct vprbrd_i2c_status *)vb->buf;
+
+	dev_dbg(&i2c->dev, "master xfer %d messages:\n", num);
+
+	for (i = 0 ; i < num ; i++) {
+		pmsg = &msgs[i];
+
+		dev_dbg(&i2c->dev,
+			"  %d: %s (flags %d) %d bytes to 0x%02x\n",
+			i, pmsg->flags & I2C_M_RD ? "read" : "write",
+			pmsg->flags, pmsg->len, pmsg->addr);
+
+		/* msgs longer than 2048 bytes are not supported by adapter */
+		if (pmsg->len > 2048)
+			return -EINVAL;
+
+		mutex_lock(&vb->lock);
+		/* directly send the message */
+		if (pmsg->flags & I2C_M_RD) {
+			/* read data */
+			amsg->cmd = VPRBRD_I2C_CMD_ADDR;
+			amsg->unknown2 = 0x00;
+			amsg->unknown3 = 0x00;
+			amsg->addr = pmsg->addr;
+			amsg->unknown1 = 0x01;
+			amsg->len = cpu_to_le16(pmsg->len);
+			/* send the addr and len, we're interested to board */
+			ret = vprbrd_i2c_addr(vb->usb_dev, amsg);
+			if (ret < 0)
+				error = ret;
+
+			ret = vprbrd_i2c_read(vb, pmsg);
+			if (ret < 0)
+				error = ret;
+
+			ret = vprbrd_i2c_status(i2c, smsg, error);
+			if (ret < 0)
+				error = ret;
+			/* in case of protocol error, return the error */
+			if (error < 0)
+				goto error;
+		} else {
+			/* write data */
+			ret = vprbrd_i2c_write(vb, pmsg);
+
+			amsg->cmd = VPRBRD_I2C_CMD_ADDR;
+			amsg->unknown2 = 0x00;
+			amsg->unknown3 = 0x00;
+			amsg->addr = pmsg->addr;
+			amsg->unknown1 = 0x00;
+			amsg->len = cpu_to_le16(pmsg->len);
+			/* send the addr, the data goes to to board */
+			ret = vprbrd_i2c_addr(vb->usb_dev, amsg);
+			if (ret < 0)
+				error = ret;
+
+			ret = vprbrd_i2c_status(i2c, smsg, error);
+			if (ret < 0)
+				error = ret;
+
+			if (error < 0)
+				goto error;
+		}
+		mutex_unlock(&vb->lock);
+	}
+	return 0;
+error:
+	mutex_unlock(&vb->lock);
+	return error;
+}
+
+static u32 vprbrd_i2c_func(struct i2c_adapter *i2c)
+{
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+}
+
+/* This is the actual algorithm we define */
+static const struct i2c_algorithm vprbrd_algorithm = {
+	.master_xfer	= vprbrd_i2c_xfer,
+	.functionality	= vprbrd_i2c_func,
+};
+
+static int __devinit vprbrd_i2c_probe(struct platform_device *pdev)
+{
+	struct vprbrd *vb = dev_get_drvdata(pdev->dev.parent);
+	struct vprbrd_i2c *vb_i2c;
+	int ret;
+	int pipe;
+
+	vb_i2c = kzalloc(sizeof(*vb_i2c), GFP_KERNEL);
+	if (vb_i2c == NULL)
+		return -ENOMEM;
+
+	/* setup i2c adapter description */
+	vb_i2c->i2c.owner = THIS_MODULE;
+	vb_i2c->i2c.class = I2C_CLASS_HWMON;
+	vb_i2c->i2c.algo = &vprbrd_algorithm;
+	vb_i2c->i2c.algo_data = vb;
+	snprintf(vb_i2c->i2c.name, sizeof(vb_i2c->i2c.name),
+		 "viperboard at bus %03d device %03d",
+		 vb->usb_dev->bus->busnum, vb->usb_dev->devnum);
+
+	/* setting the bus frequency */
+	if ((i2c_bus_freq <= VPRBRD_I2C_FREQ_10KHZ)
+		&& (i2c_bus_freq >= VPRBRD_I2C_FREQ_6MHZ)) {
+		pipe = usb_sndctrlpipe(vb->usb_dev, 0);
+		ret = usb_control_msg(vb->usb_dev, pipe, 0xe6, 0x40,
+			0x0000, 0x0000, &i2c_bus_freq, 1, 100);
+	    if (ret != 1) {
+		dev_err(&vb_i2c->i2c.dev,
+			"failure setting i2c_bus_freq to %d\n", i2c_bus_freq);
+		ret = -EIO;
+		goto error;
+	    }
+	} else {
+		dev_err(&vb_i2c->i2c.dev,
+			"invalid i2c_bus_freq setting:%d\n", i2c_bus_freq);
+		ret = -EIO;
+		goto error;
+	}
+
+	vb_i2c->i2c.dev.parent = &pdev->dev;
+
+	/* attach to i2c layer */
+	i2c_add_adapter(&vb_i2c->i2c);
+
+	platform_set_drvdata(pdev, vb_i2c);
+
+	return 0;
+
+error:
+	kfree(vb_i2c);
+	return ret;
+}
+
+static int __devexit vprbrd_i2c_remove(struct platform_device *pdev)
+{
+	struct vprbrd_i2c *vb_i2c = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = i2c_del_adapter(&vb_i2c->i2c);
+
+	return ret;
+}
+
+static struct platform_driver vprbrd_i2c_driver = {
+	.driver.name	= "viperboard-i2c",
+	.driver.owner	= THIS_MODULE,
+	.probe		= vprbrd_i2c_probe,
+	.remove		= __devexit_p(vprbrd_i2c_remove),
+};
+
+static int __init vprbrd_i2c_init(void)
+{
+	return platform_driver_register(&vprbrd_i2c_driver);
+}
+subsys_initcall(vprbrd_i2c_init);
+
+static void __exit vprbrd_i2c_exit(void)
+{
+	platform_driver_unregister(&vprbrd_i2c_driver);
+}
+module_exit(vprbrd_i2c_exit);
+
+MODULE_AUTHOR("Lars Poeschel <poeschel@lemonage.de>");
+MODULE_DESCRIPTION("I2C master driver for Nano River Techs Viperboard");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:viperboard-i2c");
diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
index 09558e7..a25e07e 100644
--- a/drivers/mfd/viperboard.c
+++ b/drivers/mfd/viperboard.c
@@ -52,6 +52,9 @@ static struct mfd_cell vprbrd_devs[] = {
 	{
 		.name = "viperboard-gpio",
 	},
+	{
+		.name = "viperboard-i2c",
+	},
 };
 
 static int vprbrd_probe(struct usb_interface *interface,
-- 
1.7.10.4

