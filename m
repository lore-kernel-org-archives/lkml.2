Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab0GAWSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:18:04 -0400
Received: from kroah.org ([198.145.64.141]:47237 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758189Ab0GAUtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:49:45 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:29 2010
Message-Id: <20100701173429.385907295@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:33:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       spark <spark@bandrich.com>
Subject: [patch 030/164] USB: option.c: Add Pirelli VID/PID and indicate Pirellis modem interface is 0xff
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: spark <spark@bandrich.com>

commit 33c387529b7931248c6637bf9720ac7504a0b28b upstream.

Signed-off-by: spark <spark@bandrich.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -334,6 +334,24 @@ static int  option_resume(struct usb_ser
 #define ALCATEL_VENDOR_ID			0x1bbb
 #define ALCATEL_PRODUCT_X060S			0x0000
 
+#define PIRELLI_VENDOR_ID			0x1266
+#define PIRELLI_PRODUCT_C100_1			0x1002
+#define PIRELLI_PRODUCT_C100_2			0x1003
+#define PIRELLI_PRODUCT_1004			0x1004
+#define PIRELLI_PRODUCT_1005			0x1005
+#define PIRELLI_PRODUCT_1006			0x1006
+#define PIRELLI_PRODUCT_1007			0x1007
+#define PIRELLI_PRODUCT_1008			0x1008
+#define PIRELLI_PRODUCT_1009			0x1009
+#define PIRELLI_PRODUCT_100A			0x100a
+#define PIRELLI_PRODUCT_100B			0x100b
+#define PIRELLI_PRODUCT_100C			0x100c
+#define PIRELLI_PRODUCT_100D			0x100d
+#define PIRELLI_PRODUCT_100E			0x100e
+#define PIRELLI_PRODUCT_100F			0x100f
+#define PIRELLI_PRODUCT_1011			0x1011
+#define PIRELLI_PRODUCT_1012			0x1012
+
 /* Airplus products */
 #define AIRPLUS_VENDOR_ID			0x1011
 #define AIRPLUS_PRODUCT_MCD650			0x3198
@@ -823,6 +841,24 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
 	{ USB_DEVICE(FOUR_G_SYSTEMS_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14) },
 	{ USB_DEVICE(HAIER_VENDOR_ID, HAIER_PRODUCT_CE100) },
+	/* Pirelli  */
+	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_C100_1)},
+	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_C100_2)},
+	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_1004)},
+	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_1005)},
+	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_1006)},
+	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_1007)},
+	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_1008)},
+	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_1009)},
+	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_100A)},
+	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_100B) },
+	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_100C) },
+	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_100D) },
+	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_100E) },
+	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_100F) },
+	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_1011)},
+	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_1012)},
+
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
@@ -945,12 +981,19 @@ static int option_probe(struct usb_seria
 			const struct usb_device_id *id)
 {
 	struct option_intf_private *data;
+
 	/* D-Link DWM 652 still exposes CD-Rom emulation interface in modem mode */
 	if (serial->dev->descriptor.idVendor == DLINK_VENDOR_ID &&
 		serial->dev->descriptor.idProduct == DLINK_PRODUCT_DWM_652 &&
 		serial->interface->cur_altsetting->desc.bInterfaceClass == 0x8)
 		return -ENODEV;
 
+	/* Bandrich modem and AT command interface is 0xff */
+	if ((serial->dev->descriptor.idVendor == BANDRICH_VENDOR_ID ||
+		serial->dev->descriptor.idVendor == PIRELLI_VENDOR_ID) &&
+		serial->interface->cur_altsetting->desc.bInterfaceClass != 0xff)
+		return -ENODEV;
+
 	data = serial->private = kzalloc(sizeof(struct option_intf_private), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;


