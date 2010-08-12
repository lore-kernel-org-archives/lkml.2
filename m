Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388Ab0HLAMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:12:34 -0400
Received: from kroah.org ([198.145.64.141]:47923 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933208Ab0HLAIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:08:50 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:17 2010
Message-Id: <20100812000617.375453972@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:06:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andrew Bird <ajb@spheresystems.co.uk>
Subject: [51/67] USB: option: add huawei k3765 k4505 devices to work properly
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

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
@@ -145,6 +145,8 @@ static void option_instat_callback(struc
 #define HUAWEI_PRODUCT_E143D			0x143D
 #define HUAWEI_PRODUCT_E143E			0x143E
 #define HUAWEI_PRODUCT_E143F			0x143F
+#define HUAWEI_PRODUCT_K4505			0x1464
+#define HUAWEI_PRODUCT_K3765			0x1465
 #define HUAWEI_PRODUCT_E14AC			0x14AC
 #define HUAWEI_PRODUCT_ETS1220			0x1803
 
@@ -483,6 +485,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E143D, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E143E, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E143F, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4505, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3765, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_ETS1220, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E14AC) },
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_9508) },
@@ -1019,6 +1023,13 @@ static int option_probe(struct usb_seria
 		serial->interface->cur_altsetting->desc.bInterfaceClass != 0xff)
 		return -ENODEV;
 
+	/* Don't bind network interfaces on Huawei K3765 & K4505 */
+	if (serial->dev->descriptor.idVendor == HUAWEI_VENDOR_ID &&
+		(serial->dev->descriptor.idProduct == HUAWEI_PRODUCT_K3765 ||
+			serial->dev->descriptor.idProduct == HUAWEI_PRODUCT_K4505) &&
+		serial->interface->cur_altsetting->desc.bInterfaceNumber == 1)
+		return -ENODEV;
+
 	data = serial->private = kzalloc(sizeof(struct usb_wwan_intf_private), GFP_KERNEL);
 
 	if (!data)


