Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab2KMUws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 15:52:48 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:34207 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188Ab2KMUwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 15:52:46 -0500
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, Till Harbaum <till@harbaum.org>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH] i2c: i2c-tiny-usb: Add parameter for optional i2c-devices.
Date: Tue, 13 Nov 2012 21:52:20 +0100
Message-Id: <1352839940-7559-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <50A2AC28.7050304@ahsoftware.de>
References: <50A2AC28.7050304@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it possible to define i2c-devices at the kernel command line
or as a module parameter.

Format is devname1@addr1,devname2@addr2,...

Example for the kernel command line:

   i2c-tiny-usb.devices=ds1307@0x68,pcf8563@0x51

The devices will be probed using the standard probe mechanism,
the definition of up to 8 devices is allowed.

Cc: Till Harbaum <till@harbaum.org>
Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/i2c/busses/i2c-tiny-usb.c | 40 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/i2c/busses/i2c-tiny-usb.c b/drivers/i2c/busses/i2c-tiny-usb.c
index 0510636..2096092 100644
--- a/drivers/i2c/busses/i2c-tiny-usb.c
+++ b/drivers/i2c/busses/i2c-tiny-usb.c
@@ -40,6 +40,11 @@ module_param(delay, ushort, 0);
 MODULE_PARM_DESC(delay, "bit delay in microseconds "
 		 "(default is 10us for 100kHz max)");
 
+#define MAX_OPTIONAL_I2C_DEVICES 8
+static char *opt_devices[MAX_OPTIONAL_I2C_DEVICES];
+module_param_array_named(devices, opt_devices, charp, NULL, 0);
+MODULE_PARM_DESC(devices, "devname1@adr1,devname2@adr2,... (e.g. ds1307@0x68)");
+
 static int usb_read(struct i2c_adapter *adapter, int cmd,
 		    int value, int index, void *data, int len);
 
@@ -190,6 +195,11 @@ static int i2c_tiny_usb_probe(struct usb_interface *interface,
 	struct i2c_tiny_usb *dev;
 	int retval = -ENOMEM;
 	u16 version;
+	unsigned i;
+	struct i2c_board_info i2c_info;
+	uint addr;
+	unsigned short i2c_addr[] = { 0, I2C_CLIENT_END };
+	char *at;
 
 	dev_dbg(&interface->dev, "probing usb device\n");
 
@@ -236,6 +246,36 @@ static int i2c_tiny_usb_probe(struct usb_interface *interface,
 	/* inform user about successful attachment to i2c layer */
 	dev_info(&dev->adapter.dev, "connected i2c-tiny-usb device\n");
 
+	for (i = 0; opt_devices[i]; ++i) {
+		at = strchr(opt_devices[i], '@');
+		if (at == NULL) {
+			dev_warn(&dev->adapter.dev,
+				"address needed in device definition '%s'\n",
+				opt_devices[i]);
+			continue;
+		}
+		*at++ = 0;
+		if (kstrtouint(at, 0, &addr) || addr >= I2C_CLIENT_END) {
+			*--at = '@';
+			dev_warn(&dev->adapter.dev,
+				"wrong address in slave definition '%s'\n",
+				opt_devices[i]);
+			continue;
+		}
+		memset(&i2c_info, 0, sizeof(struct i2c_board_info));
+		strlcpy(i2c_info.type, opt_devices[i], I2C_NAME_SIZE);
+		i2c_addr[0] = addr;
+		if (i2c_new_probed_device(&dev->adapter, &i2c_info, i2c_addr,
+			NULL))
+			dev_info(&dev->adapter.dev,
+				"device %s at address 0x%02x registered\n",
+				i2c_info.type, addr);
+		else
+			dev_warn(&dev->adapter.dev,
+				"device %s at address 0x%02x not found\n",
+				i2c_info.type, addr);
+	}
+
 	return 0;
 
  error:
-- 
1.7.11.7

