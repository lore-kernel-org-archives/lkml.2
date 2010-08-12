Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596Ab0HLAXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:23:48 -0400
Received: from kroah.org ([198.145.64.141]:60273 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759563Ab0HLAE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:04:27 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:01:26 2010
Message-Id: <20100812000126.529168372@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:00:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andrew Bird <ajb@spheresystems.co.uk>
Subject: [36/54] USB: option: add huawei k3765 k4505 devices to work properly
In-Reply-To: <20100812000249.GA30948@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrew Bird <ajb@spheresystems.co.uk>

commit 0372a754be9aa43e19fd86c9bc04796d43b55e38 upstream.

This patch adds the product IDs of Huawei's K3765 and K4505 mobile
broadband usb modems to option.c. It also adds a quirk to the option
probe function so that binding to the device's network interface(class
0xff) is avoided. This is necessary to allow another driver to bind to
that, and to avoid programs like wvdial opening a nonfunctioning tty
during modem discovery.

Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -166,6 +166,8 @@ static int  option_resume(struct usb_ser
 #define HUAWEI_PRODUCT_E143D			0x143D
 #define HUAWEI_PRODUCT_E143E			0x143E
 #define HUAWEI_PRODUCT_E143F			0x143F
+#define HUAWEI_PRODUCT_K4505			0x1464
+#define HUAWEI_PRODUCT_K3765			0x1465
 #define HUAWEI_PRODUCT_E14AC			0x14AC
 #define HUAWEI_PRODUCT_ETS1220			0x1803
 
@@ -504,6 +506,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E143D, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E143E, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E143F, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4505, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3765, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_ETS1220, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E14AC) },
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_9508) },
@@ -1048,6 +1052,13 @@ static int option_probe(struct usb_seria
 		serial->interface->cur_altsetting->desc.bInterfaceClass != 0xff)
 		return -ENODEV;
 
+	/* Don't bind network interfaces on Huawei K3765 & K4505 */
+	if (serial->dev->descriptor.idVendor == HUAWEI_VENDOR_ID &&
+		(serial->dev->descriptor.idProduct == HUAWEI_PRODUCT_K3765 ||
+			serial->dev->descriptor.idProduct == HUAWEI_PRODUCT_K4505) &&
+		serial->interface->cur_altsetting->desc.bInterfaceNumber == 1)
+		return -ENODEV;
+
 	data = serial->private = kzalloc(sizeof(struct option_intf_private), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;


