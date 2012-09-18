Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab2IRHCG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 03:02:06 -0400
Received: from shmail0.sohard.de ([212.114.139.117]:55098 "EHLO
	shmail0.sohard.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723Ab2IRHCE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 03:02:04 -0400
Date: Tue, 18 Sep 2012 09:02:01 +0200 (CEST)
From: Rene Buergel <rene.buergel@sohard.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3]: ezusb: add functions for firmware download
Message-ID: <75bac6a0-c31b-4ce5-bd5a-a21ef2e9ff6c@shmail0>
In-Reply-To: <bb6a1493-77bc-4d4e-ac2a-92cd8dc2f156@shmail0>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Originating-IP: [77.5.123.189]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Win)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new functions to upload firmware to the controller. The 
drivers currently using ezusb are adapted to use these new functions.

This also fixes a bug occuring during firmware loading in the 
whiteheat-driver:
The driver iterates over an ihex-formatted firmware using ++ on a "const 
struct ihex_binrec*" which leads to faulty results, because ihex data is 
read as length. The function "ihex_next_binrec(record)" has so be used 
to work correctly

Signed-off-by: René Bürgel <rene.buergel@sohard.de>
---
diff --git a/drivers/usb/serial/ezusb.c b/drivers/usb/serial/ezusb.c
index 351988d..867a3e1 100644
--- a/drivers/usb/serial/ezusb.c
+++ b/drivers/usb/serial/ezusb.c
@@ -13,6 +13,8 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/usb.h>
+#include <linux/firmware.h>
+#include <linux/ihex.h>
 
 struct ezusb_fx_type {
 	/* EZ-USB Control and Status Register.  Bit 0 controls 8051 reset */
@@ -82,3 +84,80 @@ int ezusb_fx2_set_reset(struct usb_device *dev, unsigned char reset_bit)
 	return ezusb_set_reset(dev, ezusb_fx2.cpucs_reg, reset_bit);
 }
 EXPORT_SYMBOL_GPL(ezusb_fx2_set_reset);
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
diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index f38fc98..c838aa9 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -38,8 +38,6 @@
 #include <linux/tty_flip.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
-#include <linux/firmware.h>
-#include <linux/ihex.h>
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
@@ -1169,10 +1167,7 @@ static void keyspan_close(struct usb_serial_port *port)
 /* download the firmware to a pre-renumeration device */
 static int keyspan_fake_startup(struct usb_serial *serial)
 {
-	int 				response;
-	const struct ihex_binrec 	*record;
-	char				*fw_name;
-	const struct firmware		*fw;
+	char	*fw_name;
 
 	dev_dbg(&serial->dev->dev, "Keyspan startup version %04x product %04x\n",
 		le16_to_cpu(serial->dev->descriptor.bcdDevice),
@@ -1240,34 +1235,16 @@ static int keyspan_fake_startup(struct usb_serial *serial)
 		return 1;
 	}
 
-	if (request_ihex_firmware(&fw, fw_name, &serial->dev->dev)) {
-		dev_err(&serial->dev->dev, "Required keyspan firmware image (%s) unavailable.\n", fw_name);
-		return 1;
-	}
-
 	dev_dbg(&serial->dev->dev, "Uploading Keyspan %s firmware.\n", fw_name);
 
-		/* download the firmware image */
-	response = ezusb_fx1_set_reset(serial->dev, 1);
-
-	record = (const struct ihex_binrec *)fw->data;
-
-	while (record) {
-		response = ezusb_writememory(serial->dev, be32_to_cpu(record->addr),
-					     (unsigned char *)record->data,
-					     be16_to_cpu(record->len), 0xa0);
-		if (response < 0) {
-			dev_err(&serial->dev->dev, "ezusb_writememory failed for Keyspan firmware (%d %04X %p %d)\n",
-				response, be32_to_cpu(record->addr),
-				record->data, be16_to_cpu(record->len));
-			break;
-		}
-		record = ihex_next_binrec(record);
+	if (ezusb_fx1_ihex_firmware_download(serial->dev, fw_name) < 0) {
+		dev_err(&serial->dev->dev, "failed to load firmware \"%s\"\n",
+			fw_name);
+		return -ENOENT;
 	}
-	release_firmware(fw);
-		/* bring device out of reset. Renumeration will occur in a
-		   moment and the new device will bind to the real driver */
-	response = ezusb_fx1_set_reset(serial->dev, 0);
+
+	/* after downloading firmware Renumeration will occur in a
+	  moment and the new device will bind to the real driver */
 
 	/* we don't want this device to have a driver assigned to it. */
 	return 1;
diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index dda424e..ca43ecb4 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -25,8 +25,6 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
-#include <linux/firmware.h>
-#include <linux/ihex.h>
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
@@ -675,8 +673,6 @@ static int keyspan_pda_fake_startup(struct usb_serial *serial)
 {
 	int response;
 	const char *fw_name;
-	const struct ihex_binrec *record;
-	const struct firmware *fw;
 
 	/* download the firmware here ... */
 	response = ezusb_fx1_set_reset(serial->dev, 1);
@@ -696,30 +692,15 @@ static int keyspan_pda_fake_startup(struct usb_serial *serial)
 			__func__);
 		return -ENODEV;
 	}
-	if (request_ihex_firmware(&fw, fw_name, &serial->dev->dev)) {
+
+	if (ezusb_fx1_ihex_firmware_download(serial->dev, fw_name) < 0) {
 		dev_err(&serial->dev->dev, "failed to load firmware \"%s\"\n",
 			fw_name);
 		return -ENOENT;
 	}
-	record = (const struct ihex_binrec *)fw->data;
-
-	while (record) {
-		response = ezusb_writememory(serial->dev, be32_to_cpu(record->addr),
-					     (unsigned char *)record->data,
-					     be16_to_cpu(record->len), 0xa0);
-		if (response < 0) {
-			dev_err(&serial->dev->dev, "ezusb_writememory failed "
-				"for Keyspan PDA firmware (%d %04X %p %d)\n",
-				response, be32_to_cpu(record->addr),
-				record->data, be16_to_cpu(record->len));
-			break;
-		}
-		record = ihex_next_binrec(record);
-	}
-	release_firmware(fw);
-	/* bring device out of reset. Renumeration will occur in a moment
-	   and the new device will bind to the real driver */
-	response = ezusb_fx1_set_reset(serial->dev, 0);
+
+	/* after downloading firmware Renumeration will occur in a
+	  moment and the new device will bind to the real driver */
 
 	/* we want this device to fail to have a driver assigned to it. */
 	return 1;
diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index b49af0b..11f643a 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -33,8 +33,6 @@
 #include <linux/serial.h>
 #include <linux/usb/serial.h>
 #include <linux/usb/ezusb.h>
-#include <linux/firmware.h>
-#include <linux/ihex.h>
 #include "whiteheat.h"			/* WhiteHEAT specific commands */
 
 static bool debug;
@@ -196,84 +194,15 @@ static int firm_report_tx_done(struct usb_serial_port *port);
 static int whiteheat_firmware_download(struct usb_serial *serial,
 					const struct usb_device_id *id)
 {
-	int response, ret = -ENOENT;
-	const struct firmware *loader_fw = NULL, *firmware_fw = NULL;
-	const struct ihex_binrec *record;
+	int response;
 
-	if (request_ihex_firmware(&firmware_fw, "whiteheat.fw",
-				  &serial->dev->dev)) {
-		dev_err(&serial->dev->dev,
-			"%s - request \"whiteheat.fw\" failed\n", __func__);
-		goto out;
-	}
-	if (request_ihex_firmware(&loader_fw, "whiteheat_loader.fw",
-			     &serial->dev->dev)) {
-		dev_err(&serial->dev->dev,
-			"%s - request \"whiteheat_loader.fw\" failed\n",
-			__func__);
-		goto out;
-	}
-	ret = 0;
-	response = ezusb_fx1_set_reset(serial->dev, 1);
-
-	record = (const struct ihex_binrec *)loader_fw->data;
-	while (record) {
-		response = ezusb_writememory(serial->dev, be32_to_cpu(record->addr),
-					     (unsigned char *)record->data,
-					     be16_to_cpu(record->len), 0xa0);
-		if (response < 0) {
-			dev_err(&serial->dev->dev, "%s - ezusb_writememory "
-				"failed for loader (%d %04X %p %d)\n",
-				__func__, response, be32_to_cpu(record->addr),
-				record->data, be16_to_cpu(record->len));
-			break;
-		}
-		record = ihex_next_binrec(record);
-	}
-
-	response = ezusb_fx1_set_reset(serial->dev, 0);
-
-	record = (const struct ihex_binrec *)firmware_fw->data;
-	while (record && be32_to_cpu(record->addr) < 0x1b40)
-		record = ihex_next_binrec(record);
-	while (record) {
-		response = ezusb_writememory(serial->dev, be32_to_cpu(record->addr),
-					     (unsigned char *)record->data,
-					     be16_to_cpu(record->len), 0xa3);
-		if (response < 0) {
-			dev_err(&serial->dev->dev, "%s - ezusb_writememory "
-				"failed for first firmware step "
-				"(%d %04X %p %d)\n", __func__, response,
-				be32_to_cpu(record->addr), record->data,
-				be16_to_cpu(record->len));
-			break;
-		}
-		++record;
-	}
-
-	response = ezusb_fx1_set_reset(serial->dev, 1);
-
-	record = (const struct ihex_binrec *)firmware_fw->data;
-	while (record && be32_to_cpu(record->addr) < 0x1b40) {
-		response = ezusb_writememory(serial->dev, be32_to_cpu(record->addr),
-					     (unsigned char *)record->data,
-					     be16_to_cpu(record->len), 0xa0);
-		if (response < 0) {
-			dev_err(&serial->dev->dev, "%s - ezusb_writememory "
-				"failed for second firmware step "
-				"(%d %04X %p %d)\n", __func__, response,
-				be32_to_cpu(record->addr), record->data,
-				be16_to_cpu(record->len));
-			break;
-		}
-		++record;
+	response = ezusb_fx1_ihex_firmware_download(serial->dev, "whiteheat_loader.fw");
+	if (response >= 0) {
+		response = ezusb_fx1_ihex_firmware_download(serial->dev, "whiteheat.fw");
+		if (response >= 0)
+			return 0;
 	}
-	ret = 0;
-	response = ezusb_fx1_set_reset(serial->dev, 0);
- out:
-	release_firmware(loader_fw);
-	release_firmware(firmware_fw);
-	return ret;
+	return -ENOENT;
 }
 
 
