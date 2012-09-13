Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab2IMUHL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 16:07:11 -0400
Received: from shmail0.sohard.de ([212.114.139.117]:43349 "EHLO
	shmail0.sohard.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab2IMUHJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 16:07:09 -0400
Date: Thu, 13 Sep 2012 22:07:07 +0200 (CEST)
From: Rene Buergel <rene.buergel@sohard.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4]: ezusb: remove dependency to usb_serial interface
Message-ID: <0c08f47e-3a4b-4437-8768-d40aae679ff7@shmail0>
In-Reply-To: <25c2a6f7-a559-4222-9c69-fb1c8229c238@shmail0>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Originating-IP: [77.190.106.167]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Win)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the dependency on the usb_serial interface and names 
some magic constants

Signed-off-by: René Bürgel <rene.buergel@sohard.de>
--
diff --git a/drivers/usb/serial/ezusb.c b/drivers/usb/serial/ezusb.c
index 800e8eb..3048b52d 100644
--- a/drivers/usb/serial/ezusb.c
+++ b/drivers/usb/serial/ezusb.c
@@ -9,24 +9,24 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/tty.h>
 #include <linux/module.h>
 #include <linux/usb.h>
-#include <linux/usb/serial.h>
 
 /* EZ-USB Control and Status Register.  Bit 0 controls 8051 reset */
 #define CPUCS_REG    0x7F92
 
-int ezusb_writememory(struct usb_serial *serial, int address,
+/* Command for writing to internal memory */
+#define WRITE_INT_RAM 0xA0
+
+int ezusb_writememory(struct usb_device *dev, int address,
 				unsigned char *data, int length, __u8 request)
 {
 	int result;
 	unsigned char *transfer_buffer;
 
-	if (!serial->dev) {
+	if (!dev) {
 		printk(KERN_ERR "ezusb: %s - no physical device present, "
 		       "failing.\n", __func__);
 		return -ENODEV;
@@ -34,25 +34,25 @@ int ezusb_writememory(struct usb_serial *serial, int address,
 
 	transfer_buffer = kmemdup(data, length, GFP_KERNEL);
 	if (!transfer_buffer) {
-		dev_err(&serial->dev->dev, "%s - kmalloc(%d) failed.\n",
+		dev_err(&dev->dev, "%s - kmalloc(%d) failed.\n",
 							__func__, length);
 		return -ENOMEM;
 	}
-	result = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-		     request, 0x40, address, 0, transfer_buffer, length, 3000);
+	result = usb_control_msg(dev, usb_sndctrlpipe(dev, 0), request,
+				 USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+				 address, 0, transfer_buffer, length, 3000);
+
 	kfree(transfer_buffer);
 	return result;
 }
 EXPORT_SYMBOL_GPL(ezusb_writememory);
 
-int ezusb_set_reset(struct usb_serial *serial, unsigned char reset_bit)
+int ezusb_set_reset(struct usb_device *dev, unsigned char reset_bit)
 {
-	int response;
-
-	response = ezusb_writememory(serial, CPUCS_REG, &reset_bit, 1, 0xa0);
+	int response = ezusb_writememory(dev, CPUCS_REG, &reset_bit, 1, WRITE_INT_RAM);
 	if (response < 0)
-		dev_err(&serial->dev->dev, "%s- %d failed\n",
-						__func__, reset_bit);
+		dev_err(&dev->dev, "%s-%d failed: %d\n",
+						__func__, reset_bit, response);
 	return response;
 }
 EXPORT_SYMBOL_GPL(ezusb_set_reset);
diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index af0b70e..f0d4f3f 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -1241,12 +1241,12 @@ static int keyspan_fake_startup(struct usb_serial *serial)
 	dbg("Uploading Keyspan %s firmware.", fw_name);
 
 		/* download the firmware image */
-	response = ezusb_set_reset(serial, 1);
+	response = ezusb_set_reset(serial->dev, 1);
 
 	record = (const struct ihex_binrec *)fw->data;
 
 	while (record) {
-		response = ezusb_writememory(serial, be32_to_cpu(record->addr),
+		response = ezusb_writememory(serial->dev, be32_to_cpu(record->addr),
 					     (unsigned char *)record->data,
 					     be16_to_cpu(record->len), 0xa0);
 		if (response < 0) {
@@ -1260,7 +1260,7 @@ static int keyspan_fake_startup(struct usb_serial *serial)
 	release_firmware(fw);
 		/* bring device out of reset. Renumeration will occur in a
 		   moment and the new device will bind to the real driver */
-	response = ezusb_set_reset(serial, 0);
+	response = ezusb_set_reset(serial->dev, 0);
 
 	/* we don't want this device to have a driver assigned to it. */
 	return 1;
diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index a4ac3cf..1290b6f 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -682,7 +682,7 @@ static int keyspan_pda_fake_startup(struct usb_serial *serial)
 	const struct firmware *fw;
 
 	/* download the firmware here ... */
-	response = ezusb_set_reset(serial, 1);
+	response = ezusb_set_reset(serial->dev, 1);
 
 	if (0) { ; }
 #ifdef KEYSPAN
@@ -707,7 +707,7 @@ static int keyspan_pda_fake_startup(struct usb_serial *serial)
 	record = (const struct ihex_binrec *)fw->data;
 
 	while (record) {
-		response = ezusb_writememory(serial, be32_to_cpu(record->addr),
+		response = ezusb_writememory(serial->dev, be32_to_cpu(record->addr),
 					     (unsigned char *)record->data,
 					     be16_to_cpu(record->len), 0xa0);
 		if (response < 0) {
@@ -722,7 +722,7 @@ static int keyspan_pda_fake_startup(struct usb_serial *serial)
 	release_firmware(fw);
 	/* bring device out of reset. Renumeration will occur in a moment
 	   and the new device will bind to the real driver */
-	response = ezusb_set_reset(serial, 0);
+	response = ezusb_set_reset(serial->dev, 0);
 
 	/* we want this device to fail to have a driver assigned to it. */
 	return 1;
diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index 473635e..fc72591 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -213,13 +213,13 @@ static int whiteheat_firmware_download(struct usb_serial *serial,
 		goto out;
 	}
 	ret = 0;
-	response = ezusb_set_reset (serial, 1);
+	response = ezusb_set_reset(serial->dev, 1);
 
 	record = (const struct ihex_binrec *)loader_fw->data;
 	while (record) {
-		response = ezusb_writememory (serial, be32_to_cpu(record->addr),
-					      (unsigned char *)record->data,
-					      be16_to_cpu(record->len), 0xa0);
+		response = ezusb_writememory(serial->dev, be32_to_cpu(record->addr),
+					     (unsigned char *)record->data,
+					     be16_to_cpu(record->len), 0xa0);
 		if (response < 0) {
 			dev_err(&serial->dev->dev, "%s - ezusb_writememory "
 				"failed for loader (%d %04X %p %d)\n",
@@ -230,15 +230,15 @@ static int whiteheat_firmware_download(struct usb_serial *serial,
 		record = ihex_next_binrec(record);
 	}
 
-	response = ezusb_set_reset(serial, 0);
+	response = ezusb_set_reset(serial->dev, 0);
 
 	record = (const struct ihex_binrec *)firmware_fw->data;
 	while (record && be32_to_cpu(record->addr) < 0x1b40)
 		record = ihex_next_binrec(record);
 	while (record) {
-		response = ezusb_writememory (serial, be32_to_cpu(record->addr),
-					      (unsigned char *)record->data,
-					      be16_to_cpu(record->len), 0xa3);
+		response = ezusb_writememory(serial->dev, be32_to_cpu(record->addr),
+					     (unsigned char *)record->data,
+					     be16_to_cpu(record->len), 0xa3);
 		if (response < 0) {
 			dev_err(&serial->dev->dev, "%s - ezusb_writememory "
 				"failed for first firmware step "
@@ -250,13 +250,13 @@ static int whiteheat_firmware_download(struct usb_serial *serial,
 		++record;
 	}
 
-	response = ezusb_set_reset(serial, 1);
+	response = ezusb_set_reset(serial->dev, 1);
 
 	record = (const struct ihex_binrec *)firmware_fw->data;
 	while (record && be32_to_cpu(record->addr) < 0x1b40) {
-		response = ezusb_writememory (serial, be32_to_cpu(record->addr),
-					      (unsigned char *)record->data,
-					      be16_to_cpu(record->len), 0xa0);
+		response = ezusb_writememory(serial->dev, be32_to_cpu(record->addr),
+					     (unsigned char *)record->data,
+					     be16_to_cpu(record->len), 0xa0);
 		if (response < 0) {
 			dev_err(&serial->dev->dev, "%s - ezusb_writememory "
 				"failed for second firmware step "
@@ -268,7 +268,7 @@ static int whiteheat_firmware_download(struct usb_serial *serial,
 		++record;
 	}
 	ret = 0;
-	response = ezusb_set_reset (serial, 0);
+	response = ezusb_set_reset(serial->dev, 0);
  out:
 	release_firmware(loader_fw);
 	release_firmware(firmware_fw);
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 86c0b45..a101507 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -301,9 +301,9 @@ extern void usb_serial_port_softint(struct usb_serial_port *port);
 extern int usb_serial_suspend(struct usb_interface *intf, pm_message_t message);
 extern int usb_serial_resume(struct usb_interface *intf);
 
-extern int ezusb_writememory(struct usb_serial *serial, int address,
+extern int ezusb_writememory(struct usb_device *dev, int address,
 			     unsigned char *data, int length, __u8 bRequest);
-extern int ezusb_set_reset(struct usb_serial *serial, unsigned char reset_bit);
+extern int ezusb_set_reset(struct usb_device *dev, unsigned char reset_bit);
 
 /* USB Serial console functions */
 #ifdef CONFIG_USB_SERIAL_CONSOLE
