Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab0GAJSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 05:18:20 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51113 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab0GAJQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 05:16:57 -0400
Date: Thu, 01 Jul 2010 11:17:44 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH] USB: gadget: mass storage: use proper device class in device
 desc
To: linux-usb@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <59b191a020300966e20eef4e942bc75982d792fb.1277735580.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the bDeviceClass, bDeviceSubClass, bDeviceProtocol
to match the real class and protocol instead of leaving it as per
interface.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
Hello Alan,

Each time I see the device descriptor of the File Storage Gadget
I wonder if it shouldn't be set to the real value rather then leaving
it as per interface.

Is there a reason to leave it as per interface?  Will chenging it to
the real value change anything?

I checked my pendrive and an IDE<->USB adapter they as well use a per
interface class but maybe it'll be better to use proper call any way?

 drivers/usb/gadget/file_storage.c |    6 +++++-
 drivers/usb/gadget/mass_storage.c |    4 +++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index d57c09f..1f76ea0 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -544,7 +544,9 @@ device_desc = {
 	.bDescriptorType =	USB_DT_DEVICE,
 
 	.bcdUSB =		cpu_to_le16(0x0200),
-	.bDeviceClass =		USB_CLASS_PER_INTERFACE,
+	.bDeviceClass =		USB_CLASS_MASS_STORAGE,
+	.bDeviceSubClass =	USB_SC_SCSI, /* Adjusted during fsg_bind() */
+	.bDeviceProtocol =	USB_PR_BULK, /* Adjusted during fsg_bind() */
 
 	/* The next three values can be overridden by module parameters */
 	.idVendor =		cpu_to_le16(FSG_VENDOR_ID),
@@ -3450,7 +3452,9 @@ static int __ref fsg_bind(struct usb_gadget *gadget)
 	i = (transport_is_cbi() ? 3 : 2);	// Number of endpoints
 	fsg_intf_desc.bNumEndpoints = i;
 	fsg_intf_desc.bInterfaceSubClass = mod_data.protocol_type;
+	device_desc.bDeviceSubClass = mod_data.protocol_type;
 	fsg_intf_desc.bInterfaceProtocol = mod_data.transport_type;
+	device_desc.bDeviceProtocol = mod_data.transport_type;
 	fsg_fs_function[i + FSG_FS_FUNCTION_PRE_EP_ENTRIES] = NULL;
 
 	if (gadget_is_dualspeed(gadget)) {
diff --git a/drivers/usb/gadget/mass_storage.c b/drivers/usb/gadget/mass_storage.c
index 585f255..59054a4 100644
--- a/drivers/usb/gadget/mass_storage.c
+++ b/drivers/usb/gadget/mass_storage.c
@@ -70,7 +70,9 @@ static struct usb_device_descriptor msg_device_desc = {
 	.bDescriptorType =	USB_DT_DEVICE,
 
 	.bcdUSB =		cpu_to_le16(0x0200),
-	.bDeviceClass =		USB_CLASS_PER_INTERFACE,
+	.bDeviceClass =		USB_CLASS_MASS_STORAGE,
+	.bDeviceSubClass =	USB_SC_SCSI,
+	.bDeviceProtocol =	USB_PR_BULK,
 
 	/* Vendor and product id can be overridden by module parameters.  */
 	.idVendor =		cpu_to_le16(FSG_VENDOR_ID),
-- 
1.7.1

