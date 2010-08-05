Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147Ab0HEK1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 06:27:52 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29408 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758889Ab0HEK0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 06:26:20 -0400
Date: Thu, 05 Aug 2010 12:27:39 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv6 5/7] USB: gadget: mass_storage: moved strings handling code
 to composite
In-reply-to: <f663aae67270ec7bf8732b1ba48b6030ded70355.1281002833.git.m.nazarewicz@samsung.com>
To: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
        USB <linux-usb@vger.kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <a90a95cba800f0a9d62fbb805a975548746a4009.1281002833.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1281002833.git.m.nazarewicz@samsung.com>
 <4d9f94eea017dfb5c1931aecd56c7b3de92de1ad.1281002833.git.m.nazarewicz@samsung.com>
 <c66a92a8efa1ec83017633035352ba4a936d0f94.1281002833.git.m.nazarewicz@samsung.com>
 <c59df14c2fff1e327bb37f382769dad9b41da01c.1281002833.git.m.nazarewicz@samsung.com>
 <f663aae67270ec7bf8732b1ba48b6030ded70355.1281002833.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes string registration from the Mass Storage
Gadget.  With recent changes to the composite framework, all
that we need is handled by the composite layer.  This means
composite registers a string ID for manufacturer and product.

This also adds the "needs_serial" so that composite layer will
issue a warning if user space fails to provide the iSerialNumber
module parameter.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/mass_storage.c |   72 +++---------------------------------
 1 files changed, 6 insertions(+), 66 deletions(-)

diff --git a/drivers/usb/gadget/mass_storage.c b/drivers/usb/gadget/mass_storage.c
index 585f255..493d153 100644
--- a/drivers/usb/gadget/mass_storage.c
+++ b/drivers/usb/gadget/mass_storage.c
@@ -75,10 +75,6 @@ static struct usb_device_descriptor msg_device_desc = {
 	/* Vendor and product id can be overridden by module parameters.  */
 	.idVendor =		cpu_to_le16(FSG_VENDOR_ID),
 	.idProduct =		cpu_to_le16(FSG_PRODUCT_ID),
-	/* .bcdDevice = f(hardware) */
-	/* .iManufacturer = DYNAMIC */
-	/* .iProduct = DYNAMIC */
-	/* NO SERIAL NUMBER */
 	.bNumConfigurations =	1,
 };
 
@@ -86,7 +82,8 @@ static struct usb_otg_descriptor otg_descriptor = {
 	.bLength =		sizeof otg_descriptor,
 	.bDescriptorType =	USB_DT_OTG,
 
-	/* REVISIT SRP-only hardware is possible, although
+	/*
+	 * REVISIT SRP-only hardware is possible, although
 	 * it would not be called "OTG" ...
 	 */
 	.bmAttributes =		USB_OTG_SRP | USB_OTG_HNP,
@@ -98,33 +95,6 @@ static const struct usb_descriptor_header *otg_desc[] = {
 };
 
 
-/* string IDs are assigned dynamically */
-
-#define STRING_MANUFACTURER_IDX		0
-#define STRING_PRODUCT_IDX		1
-#define STRING_CONFIGURATION_IDX	2
-
-static char manufacturer[50];
-
-static struct usb_string strings_dev[] = {
-	[STRING_MANUFACTURER_IDX].s = manufacturer,
-	[STRING_PRODUCT_IDX].s = DRIVER_DESC,
-	[STRING_CONFIGURATION_IDX].s = "Self Powered",
-	{  } /* end of list */
-};
-
-static struct usb_gadget_strings stringtab_dev = {
-	.language	= 0x0409,	/* en-us */
-	.strings	= strings_dev,
-};
-
-static struct usb_gadget_strings *dev_strings[] = {
-	&stringtab_dev,
-	NULL,
-};
-
-
-
 /****************************** Configurations ******************************/
 
 static struct fsg_module_parameters mod_data = {
@@ -173,52 +143,22 @@ static struct usb_configuration msg_config_driver = {
 	.label			= "Linux File-Backed Storage",
 	.bind			= msg_do_config,
 	.bConfigurationValue	= 1,
-	/* .iConfiguration = DYNAMIC */
 	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
 };
 
 
-
 /****************************** Gadget Bind ******************************/
 
-
 static int __ref msg_bind(struct usb_composite_dev *cdev)
 {
-	struct usb_gadget *gadget = cdev->gadget;
 	int status;
 
-	/* Allocate string descriptor numbers ... note that string
-	 * contents can be overridden by the composite_dev glue.
-	 */
-
-	/* device descriptor strings: manufacturer, product */
-	snprintf(manufacturer, sizeof manufacturer, "%s %s with %s",
-	         init_utsname()->sysname, init_utsname()->release,
-	         gadget->name);
-	status = usb_string_id(cdev);
-	if (status < 0)
-		return status;
-	strings_dev[STRING_MANUFACTURER_IDX].id = status;
-	msg_device_desc.iManufacturer = status;
-
-	status = usb_string_id(cdev);
-	if (status < 0)
-		return status;
-	strings_dev[STRING_PRODUCT_IDX].id = status;
-	msg_device_desc.iProduct = status;
-
-	status = usb_string_id(cdev);
-	if (status < 0)
-		return status;
-	strings_dev[STRING_CONFIGURATION_IDX].id = status;
-	msg_config_driver.iConfiguration = status;
-
-	/* register our second configuration */
 	status = usb_add_config(cdev, &msg_config_driver);
 	if (status < 0)
 		return status;
 
-	dev_info(&gadget->dev, DRIVER_DESC ", version: " DRIVER_VERSION "\n");
+	dev_info(&cdev->gadget->dev,
+		 DRIVER_DESC ", version: " DRIVER_VERSION "\n");
 	set_bit(0, &msg_registered);
 	return 0;
 }
@@ -226,12 +166,12 @@ static int __ref msg_bind(struct usb_composite_dev *cdev)
 
 /****************************** Some noise ******************************/
 
-
 static struct usb_composite_driver msg_driver = {
 	.name		= "g_mass_storage",
 	.dev		= &msg_device_desc,
-	.strings	= dev_strings,
 	.bind		= msg_bind,
+	.iProduct	= DRIVER_DESC,
+	.needs_serial	= 1,
 };
 
 MODULE_DESCRIPTION(DRIVER_DESC);
-- 
1.7.1

