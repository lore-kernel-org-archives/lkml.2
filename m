Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795Ab2IMUTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 16:19:23 -0400
Received: from shmail0.sohard.de ([212.114.139.117]:43601 "EHLO
	shmail0.sohard.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758233Ab2IMUTO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 16:19:14 -0400
Date: Thu, 13 Sep 2012 22:19:11 +0200 (CEST)
From: Rene Buergel <rene.buergel@sohard.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4]: ezusb: move ezusb.c from drivers/usb/serial to drivers/usb/misc
Message-ID: <f7e8f1a4-fb32-4933-ba9d-81a2f1fb7ba8@shmail0>
In-Reply-To: <7120fd46-da21-4203-8293-7dcdb70f02dc@shmail0>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Originating-IP: [77.190.106.167]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Win)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves drivers/usb/serial/ezusb.c to drivers/usb/misc/and
adapts Makefiles and Kconfigs

Signed-off-by: René Bürgel <rene.buergel@sohard.de>
--
diff --git a/drivers/usb/misc/Kconfig b/drivers/usb/misc/Kconfig
index 1bfcd02..1c63b54 100644
--- a/drivers/usb/misc/Kconfig
+++ b/drivers/usb/misc/Kconfig
@@ -244,3 +244,7 @@ config USB_YUREX
 	  To compile this driver as a module, choose M here: the
 	  module will be called yurex.
 
+config USB_EZUSB
+	bool "Functions for loading firmware on EZUSB chips"
+	help
+	    Say Y here if you need EZUSB device support.
diff --git a/drivers/usb/misc/Makefile b/drivers/usb/misc/Makefile
index 796ce7e..f1f7815 100644
--- a/drivers/usb/misc/Makefile
+++ b/drivers/usb/misc/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_USB_CYPRESS_CY7C63)	+= cypress_cy7c63.o
 obj-$(CONFIG_USB_CYTHERM)		+= cytherm.o
 obj-$(CONFIG_USB_EMI26)			+= emi26.o
 obj-$(CONFIG_USB_EMI62)			+= emi62.o
+obj-$(CONFIG_USB_EZUSB)			+= ezusb.o
 obj-$(CONFIG_USB_FTDI_ELAN)		+= ftdi-elan.o
 obj-$(CONFIG_USB_IDMOUSE)		+= idmouse.o
 obj-$(CONFIG_USB_IOWARRIOR)		+= iowarrior.o
diff --git a/drivers/usb/misc/ezusb.c b/drivers/usb/misc/ezusb.c
new file mode 100644
index 0000000..867a3e1
--- /dev/null
+++ b/drivers/usb/misc/ezusb.c
@@ -0,0 +1,163 @@
+/*
+ * EZ-USB specific functions used by some of the USB to Serial drivers.
+ *
+ * Copyright (C) 1999 - 2002 Greg Kroah-Hartman (greg@kroah.com)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License version
+ *	2 as published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/firmware.h>
+#include <linux/ihex.h>
+
+struct ezusb_fx_type {
+	/* EZ-USB Control and Status Register.  Bit 0 controls 8051 reset */
+	unsigned short cpucs_reg;
+	unsigned short max_internal_adress;
+};
+
+struct ezusb_fx_type ezusb_fx1 = {
+	.cpucs_reg = 0x7F92,
+	.max_internal_adress = 0x1B3F,
+};
+
+struct ezusb_fx_type ezusb_fx2 = {
+	.cpucs_reg = 0xE600,
+	.max_internal_adress = 0x3FFF,
+};
+
+/* Commands for writing to memory */
+#define WRITE_INT_RAM 0xA0
+#define WRITE_EXT_RAM 0xA3
+
+int ezusb_writememory(struct usb_device *dev, int address,
+				unsigned char *data, int length, __u8 request)
+{
+	int result;
+	unsigned char *transfer_buffer;
+
+	if (!dev) {
+		printk(KERN_ERR "ezusb: %s - no physical device present, "
+		       "failing.\n", __func__);
+		return -ENODEV;
+	}
+
+	transfer_buffer = kmemdup(data, length, GFP_KERNEL);
+	if (!transfer_buffer) {
+		dev_err(&dev->dev, "%s - kmalloc(%d) failed.\n",
+							__func__, length);
+		return -ENOMEM;
+	}
+	result = usb_control_msg(dev, usb_sndctrlpipe(dev, 0), request,
+				 USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+				 address, 0, transfer_buffer, length, 3000);
+
+	kfree(transfer_buffer);
+	return result;
+}
+EXPORT_SYMBOL_GPL(ezusb_writememory);
+
+int ezusb_set_reset(struct usb_device *dev, unsigned short cpucs_reg,
+			 unsigned char reset_bit)
+{
+	int response = ezusb_writememory(dev, cpucs_reg, &reset_bit, 1, WRITE_INT_RAM);
+	if (response < 0)
+		dev_err(&dev->dev, "%s-%d failed: %d\n",
+						__func__, reset_bit, response);
+	return response;
+}
+
+int ezusb_fx1_set_reset(struct usb_device *dev, unsigned char reset_bit)
+{
+	return ezusb_set_reset(dev, ezusb_fx1.cpucs_reg, reset_bit);
+}
+EXPORT_SYMBOL_GPL(ezusb_fx1_set_reset);
+
+int ezusb_fx2_set_reset(struct usb_device *dev, unsigned char reset_bit)
+{
+	return ezusb_set_reset(dev, ezusb_fx2.cpucs_reg, reset_bit);
+}
+EXPORT_SYMBOL_GPL(ezusb_fx2_set_reset);
+
+static int ezusb_ihex_firmware_download(struct usb_device *dev,
+					struct ezusb_fx_type fx,
+					const char *firmware_path)
+{
+	int ret = -ENOENT;
+	const struct firmware *firmware = NULL;
+	const struct ihex_binrec *record;
+
+	if (request_ihex_firmware(&firmware, firmware_path,
+				  &dev->dev)) {
+		dev_err(&dev->dev,
+			"%s - request \"%s\" failed\n",
+			__func__, firmware_path);
+		goto out;
+	}
+
+	ret = ezusb_set_reset(dev, fx.cpucs_reg, 0);
+	if (ret < 0)
+		goto out;
+
+	record = (const struct ihex_binrec *)firmware->data;
+	for (; record; record = ihex_next_binrec(record)) {
+		if (be32_to_cpu(record->addr) > fx.max_internal_adress) {
+			ret = ezusb_writememory(dev, be32_to_cpu(record->addr),
+						(unsigned char *)record->data,
+						be16_to_cpu(record->len), WRITE_EXT_RAM);
+			if (ret < 0) {
+				dev_err(&dev->dev, "%s - ezusb_writememory "
+					"failed writing internal memory "
+					"(%d %04X %p %d)\n", __func__, ret,
+					be32_to_cpu(record->addr), record->data,
+					be16_to_cpu(record->len));
+				goto out;
+			}
+		}
+	}
+
+	ret = ezusb_set_reset(dev, fx.cpucs_reg, 1);
+	if (ret < 0)
+		goto out;
+	record = (const struct ihex_binrec *)firmware->data;
+	for (; record; record = ihex_next_binrec(record)) {
+		if (be32_to_cpu(record->addr) <= fx.max_internal_adress) {
+			ret = ezusb_writememory(dev, be32_to_cpu(record->addr),
+						(unsigned char *)record->data,
+						be16_to_cpu(record->len), WRITE_INT_RAM);
+			if (ret < 0) {
+				dev_err(&dev->dev, "%s - ezusb_writememory "
+					"failed writing external memory "
+					"(%d %04X %p %d)\n", __func__, ret,
+					be32_to_cpu(record->addr), record->data,
+					be16_to_cpu(record->len));
+				goto out;
+			}
+		}
+	}
+	ret = ezusb_set_reset(dev, fx.cpucs_reg, 0);
+out:
+	release_firmware(firmware);
+	return ret;
+}
+
+int ezusb_fx1_ihex_firmware_download(struct usb_device *dev,
+				     const char *firmware_path)
+{
+	return ezusb_ihex_firmware_download(dev, ezusb_fx1, firmware_path);
+}
+EXPORT_SYMBOL_GPL(ezusb_fx1_ihex_firmware_download);
+
+int ezusb_fx2_ihex_firmware_download(struct usb_device *dev,
+				     const char *firmware_path)
+{
+	return ezusb_ihex_firmware_download(dev, ezusb_fx2, firmware_path);
+}
+EXPORT_SYMBOL_GPL(ezusb_fx2_ihex_firmware_download);
+
diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
index 325d291..73b5e6f 100644
--- a/drivers/usb/serial/Kconfig
+++ b/drivers/usb/serial/Kconfig
@@ -42,11 +42,6 @@ config USB_SERIAL_CONSOLE
 
 	  If unsure, say N.
 
-config USB_EZUSB
-	bool "Functions for loading firmware on EZUSB chips"
-	help
-	    Say Y here if you need EZUSB device support.
-
 config USB_SERIAL_GENERIC
 	bool "USB Generic Serial Driver"
 	help
diff --git a/drivers/usb/serial/Makefile b/drivers/usb/serial/Makefile
index 1dc483a..12b56bb 100644
--- a/drivers/usb/serial/Makefile
+++ b/drivers/usb/serial/Makefile
@@ -9,7 +9,6 @@ obj-$(CONFIG_USB_SERIAL)			+= usbserial.o
 usbserial-y := usb-serial.o generic.o bus.o
 
 usbserial-$(CONFIG_USB_SERIAL_CONSOLE)	+= console.o
-usbserial-$(CONFIG_USB_EZUSB)		+= ezusb.o
 
 obj-$(CONFIG_USB_SERIAL_AIRCABLE)		+= aircable.o
 obj-$(CONFIG_USB_SERIAL_ARK3116)		+= ark3116.o
diff --git a/drivers/usb/serial/ezusb.c b/drivers/usb/serial/ezusb.c
deleted file mode 100644
index 867a3e1..0000000
--- a/drivers/usb/serial/ezusb.c
+++ /dev/null
@@ -1,163 +0,0 @@
-/*
- * EZ-USB specific functions used by some of the USB to Serial drivers.
- *
- * Copyright (C) 1999 - 2002 Greg Kroah-Hartman (greg@kroah.com)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License version
- *	2 as published by the Free Software Foundation.
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/module.h>
-#include <linux/usb.h>
-#include <linux/firmware.h>
-#include <linux/ihex.h>
-
-struct ezusb_fx_type {
-	/* EZ-USB Control and Status Register.  Bit 0 controls 8051 reset */
-	unsigned short cpucs_reg;
-	unsigned short max_internal_adress;
-};
-
-struct ezusb_fx_type ezusb_fx1 = {
-	.cpucs_reg = 0x7F92,
-	.max_internal_adress = 0x1B3F,
-};
-
-struct ezusb_fx_type ezusb_fx2 = {
-	.cpucs_reg = 0xE600,
-	.max_internal_adress = 0x3FFF,
-};
-
-/* Commands for writing to memory */
-#define WRITE_INT_RAM 0xA0
-#define WRITE_EXT_RAM 0xA3
-
-int ezusb_writememory(struct usb_device *dev, int address,
-				unsigned char *data, int length, __u8 request)
-{
-	int result;
-	unsigned char *transfer_buffer;
-
-	if (!dev) {
-		printk(KERN_ERR "ezusb: %s - no physical device present, "
-		       "failing.\n", __func__);
-		return -ENODEV;
-	}
-
-	transfer_buffer = kmemdup(data, length, GFP_KERNEL);
-	if (!transfer_buffer) {
-		dev_err(&dev->dev, "%s - kmalloc(%d) failed.\n",
-							__func__, length);
-		return -ENOMEM;
-	}
-	result = usb_control_msg(dev, usb_sndctrlpipe(dev, 0), request,
-				 USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-				 address, 0, transfer_buffer, length, 3000);
-
-	kfree(transfer_buffer);
-	return result;
-}
-EXPORT_SYMBOL_GPL(ezusb_writememory);
-
-int ezusb_set_reset(struct usb_device *dev, unsigned short cpucs_reg,
-			 unsigned char reset_bit)
-{
-	int response = ezusb_writememory(dev, cpucs_reg, &reset_bit, 1, WRITE_INT_RAM);
-	if (response < 0)
-		dev_err(&dev->dev, "%s-%d failed: %d\n",
-						__func__, reset_bit, response);
-	return response;
-}
-
-int ezusb_fx1_set_reset(struct usb_device *dev, unsigned char reset_bit)
-{
-	return ezusb_set_reset(dev, ezusb_fx1.cpucs_reg, reset_bit);
-}
-EXPORT_SYMBOL_GPL(ezusb_fx1_set_reset);
-
-int ezusb_fx2_set_reset(struct usb_device *dev, unsigned char reset_bit)
-{
-	return ezusb_set_reset(dev, ezusb_fx2.cpucs_reg, reset_bit);
-}
-EXPORT_SYMBOL_GPL(ezusb_fx2_set_reset);
-
-static int ezusb_ihex_firmware_download(struct usb_device *dev,
-					struct ezusb_fx_type fx,
-					const char *firmware_path)
-{
-	int ret = -ENOENT;
-	const struct firmware *firmware = NULL;
-	const struct ihex_binrec *record;
-
-	if (request_ihex_firmware(&firmware, firmware_path,
-				  &dev->dev)) {
-		dev_err(&dev->dev,
-			"%s - request \"%s\" failed\n",
-			__func__, firmware_path);
-		goto out;
-	}
-
-	ret = ezusb_set_reset(dev, fx.cpucs_reg, 0);
-	if (ret < 0)
-		goto out;
-
-	record = (const struct ihex_binrec *)firmware->data;
-	for (; record; record = ihex_next_binrec(record)) {
-		if (be32_to_cpu(record->addr) > fx.max_internal_adress) {
-			ret = ezusb_writememory(dev, be32_to_cpu(record->addr),
-						(unsigned char *)record->data,
-						be16_to_cpu(record->len), WRITE_EXT_RAM);
-			if (ret < 0) {
-				dev_err(&dev->dev, "%s - ezusb_writememory "
-					"failed writing internal memory "
-					"(%d %04X %p %d)\n", __func__, ret,
-					be32_to_cpu(record->addr), record->data,
-					be16_to_cpu(record->len));
-				goto out;
-			}
-		}
-	}
-
-	ret = ezusb_set_reset(dev, fx.cpucs_reg, 1);
-	if (ret < 0)
-		goto out;
-	record = (const struct ihex_binrec *)firmware->data;
-	for (; record; record = ihex_next_binrec(record)) {
-		if (be32_to_cpu(record->addr) <= fx.max_internal_adress) {
-			ret = ezusb_writememory(dev, be32_to_cpu(record->addr),
-						(unsigned char *)record->data,
-						be16_to_cpu(record->len), WRITE_INT_RAM);
-			if (ret < 0) {
-				dev_err(&dev->dev, "%s - ezusb_writememory "
-					"failed writing external memory "
-					"(%d %04X %p %d)\n", __func__, ret,
-					be32_to_cpu(record->addr), record->data,
-					be16_to_cpu(record->len));
-				goto out;
-			}
-		}
-	}
-	ret = ezusb_set_reset(dev, fx.cpucs_reg, 0);
-out:
-	release_firmware(firmware);
-	return ret;
-}
-
-int ezusb_fx1_ihex_firmware_download(struct usb_device *dev,
-				     const char *firmware_path)
-{
-	return ezusb_ihex_firmware_download(dev, ezusb_fx1, firmware_path);
-}
-EXPORT_SYMBOL_GPL(ezusb_fx1_ihex_firmware_download);
-
-int ezusb_fx2_ihex_firmware_download(struct usb_device *dev,
-				     const char *firmware_path)
-{
-	return ezusb_ihex_firmware_download(dev, ezusb_fx2, firmware_path);
-}
-EXPORT_SYMBOL_GPL(ezusb_fx2_ihex_firmware_download);
-
