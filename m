Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab2IMUPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 16:15:52 -0400
Received: from shmail0.sohard.de ([212.114.139.117]:43541 "EHLO
	shmail0.sohard.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757840Ab2IMUPu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 16:15:50 -0400
Date: Thu, 13 Sep 2012 22:15:47 +0200 (CEST)
From: Rene Buergel <rene.buergel@sohard.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4]: add support for Cypress FX2LP
Message-ID: <cc3ba139-4ad3-4c24-ba89-009f59abbe14@shmail0>
In-Reply-To: <7120fd46-da21-4203-8293-7dcdb70f02dc@shmail0>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Originating-IP: [77.190.106.167]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Win)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This Patch adds support for the newer Cypress FX2LP. It also adapts 
three drivers currently using ezusb to the interface change. (whiteheat 
and keyspan[_pda])

Signed-off-by: René Bürgel <rene.buergel@...>
--
diff --git a/drivers/usb/serial/ezusb.c b/drivers/usb/serial/ezusb.c
index 3048b52d..351988d 100644
--- a/drivers/usb/serial/ezusb.c
+++ b/drivers/usb/serial/ezusb.c
@@ -14,11 +14,25 @@
 #include <linux/module.h>
 #include <linux/usb.h>
 
-/* EZ-USB Control and Status Register.  Bit 0 controls 8051 reset */
-#define CPUCS_REG    0x7F92
+struct ezusb_fx_type {
+	/* EZ-USB Control and Status Register.  Bit 0 controls 8051 reset */
+	unsigned short cpucs_reg;
+	unsigned short max_internal_adress;
+};
 
-/* Command for writing to internal memory */
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
 #define WRITE_INT_RAM 0xA0
+#define WRITE_EXT_RAM 0xA3
 
 int ezusb_writememory(struct usb_device *dev, int address,
 				unsigned char *data, int length, __u8 request)
@@ -47,13 +61,24 @@ int ezusb_writememory(struct usb_device *dev, int address,
 }
 EXPORT_SYMBOL_GPL(ezusb_writememory);
 
-int ezusb_set_reset(struct usb_device *dev, unsigned char reset_bit)
+int ezusb_set_reset(struct usb_device *dev, unsigned short cpucs_reg,
+			 unsigned char reset_bit)
 {
-	int response = ezusb_writememory(dev, CPUCS_REG, &reset_bit, 1, WRITE_INT_RAM);
+	int response = ezusb_writememory(dev, cpucs_reg, &reset_bit, 1, WRITE_INT_RAM);
 	if (response < 0)
 		dev_err(&dev->dev, "%s-%d failed: %d\n",
 						__func__, reset_bit, response);
 	return response;
 }
-EXPORT_SYMBOL_GPL(ezusb_set_reset);
 
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
diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index f0d4f3f..32bebde 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -43,6 +43,7 @@
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
+#include <linux/usb/ezusb.h>
 #include "keyspan.h"
 
 static bool debug;
@@ -1241,7 +1242,7 @@ static int keyspan_fake_startup(struct usb_serial *serial)
 	dbg("Uploading Keyspan %s firmware.", fw_name);
 
 		/* download the firmware image */
-	response = ezusb_set_reset(serial->dev, 1);
+	response = ezusb_fx1_set_reset(serial->dev, 1);
 
 	record = (const struct ihex_binrec *)fw->data;
 
@@ -1260,7 +1261,7 @@ static int keyspan_fake_startup(struct usb_serial *serial)
 	release_firmware(fw);
 		/* bring device out of reset. Renumeration will occur in a
 		   moment and the new device will bind to the real driver */
-	response = ezusb_set_reset(serial->dev, 0);
+	response = ezusb_fx1_set_reset(serial->dev, 0);
 
 	/* we don't want this device to have a driver assigned to it. */
 	return 1;
diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index 1290b6f..87c5812 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -30,6 +30,7 @@
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
+#include <linux/usb/ezusb.h>
 
 static bool debug;
 
@@ -682,7 +683,7 @@ static int keyspan_pda_fake_startup(struct usb_serial *serial)
 	const struct firmware *fw;
 
 	/* download the firmware here ... */
-	response = ezusb_set_reset(serial->dev, 1);
+	response = ezusb_fx1_set_reset(serial->dev, 1);
 
 	if (0) { ; }
 #ifdef KEYSPAN
@@ -722,7 +723,7 @@ static int keyspan_pda_fake_startup(struct usb_serial *serial)
 	release_firmware(fw);
 	/* bring device out of reset. Renumeration will occur in a moment
 	   and the new device will bind to the real driver */
-	response = ezusb_set_reset(serial->dev, 0);
+	response = ezusb_fx1_set_reset(serial->dev, 0);
 
 	/* we want this device to fail to have a driver assigned to it. */
 	return 1;
diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index fc72591..228eb64 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -32,6 +32,7 @@
 #include <linux/serial_reg.h>
 #include <linux/serial.h>
 #include <linux/usb/serial.h>
+#include <linux/usb/ezusb.h>
 #include <linux/firmware.h>
 #include <linux/ihex.h>
 #include "whiteheat.h"			/* WhiteHEAT specific commands */
@@ -213,7 +214,7 @@ static int whiteheat_firmware_download(struct usb_serial *serial,
 		goto out;
 	}
 	ret = 0;
-	response = ezusb_set_reset(serial->dev, 1);
+	response = ezusb_fx1_set_reset(serial->dev, 1);
 
 	record = (const struct ihex_binrec *)loader_fw->data;
 	while (record) {
@@ -230,7 +231,7 @@ static int whiteheat_firmware_download(struct usb_serial *serial,
 		record = ihex_next_binrec(record);
 	}
 
-	response = ezusb_set_reset(serial->dev, 0);
+	response = ezusb_fx1_set_reset(serial->dev, 0);
 
 	record = (const struct ihex_binrec *)firmware_fw->data;
 	while (record && be32_to_cpu(record->addr) < 0x1b40)
@@ -250,7 +251,7 @@ static int whiteheat_firmware_download(struct usb_serial *serial,
 		++record;
 	}
 
-	response = ezusb_set_reset(serial->dev, 1);
+	response = ezusb_fx1_set_reset(serial->dev, 1);
 
 	record = (const struct ihex_binrec *)firmware_fw->data;
 	while (record && be32_to_cpu(record->addr) < 0x1b40) {
@@ -268,7 +269,7 @@ static int whiteheat_firmware_download(struct usb_serial *serial,
 		++record;
 	}
 	ret = 0;
-	response = ezusb_set_reset(serial->dev, 0);
+	response = ezusb_fx1_set_reset(serial->dev, 0);
  out:
 	release_firmware(loader_fw);
 	release_firmware(firmware_fw);
diff --git a/include/linux/usb/ezusb.h b/include/linux/usb/ezusb.h
new file mode 100644
index 0000000..fc618d8
--- /dev/null
+++ b/include/linux/usb/ezusb.h
@@ -0,0 +1,16 @@
+#ifndef __EZUSB_H
+#define __EZUSB_H
+
+
+extern int ezusb_writememory(struct usb_device *dev, int address,
+			     unsigned char *data, int length, __u8 bRequest);
+
+extern int ezusb_fx1_set_reset(struct usb_device *dev, unsigned char reset_bit);
+extern int ezusb_fx2_set_reset(struct usb_device *dev, unsigned char reset_bit);
+
+extern int ezusb_fx1_ihex_firmware_download(struct usb_device *dev,
+					    const char *firmware_path);
+extern int ezusb_fx2_ihex_firmware_download(struct usb_device *dev,
+					    const char *firmware_path);
+
+#endif /* __EZUSB_H */
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index a101507..588861c 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -301,10 +301,6 @@ extern void usb_serial_port_softint(struct usb_serial_port *port);
 extern int usb_serial_suspend(struct usb_interface *intf, pm_message_t message);
 extern int usb_serial_resume(struct usb_interface *intf);
 
-extern int ezusb_writememory(struct usb_device *dev, int address,
-			     unsigned char *data, int length, __u8 bRequest);
-extern int ezusb_set_reset(struct usb_device *dev, unsigned char reset_bit);
-
 /* USB Serial console functions */
 #ifdef CONFIG_USB_SERIAL_CONSOLE
 extern void usb_serial_console_init(int debug, int minor);
