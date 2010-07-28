Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab0G1MMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 08:12:34 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43833 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab0G1MMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 08:12:31 -0400
Date: Wed, 28 Jul 2010 14:13:52 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv5 2/3] USB: gadget: Use new composite features in some gadgets
In-reply-to: <38424b23c94ddcff6f1808161912f362c2ccae39.1280316431.git.m.nazarewicz@samsung.com>
To: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <7b3ddf05e135e8147d1011a81f9069d9cd78aa62.1280316431.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <38424b23c94ddcff6f1808161912f362c2ccae39.1280316431.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch FunctionFS, Mass Storage and Multifunction gadgets
use the new features of composite framework.  Because it
handles default strings there is no longer the need for the
gadgets drivers to handle many of the strings.

This also adds the "needs_serial" to Mass Storage Gadget and
Multifunction Composite Gadget which makes composite issue
a warning if user space has not provided iSerialNumber
parameter.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/g_ffs.c        |   47 +++-------------------
 drivers/usb/gadget/mass_storage.c |   78 +++++--------------------------------
 drivers/usb/gadget/multi.c        |   19 +--------
 3 files changed, 19 insertions(+), 125 deletions(-)

diff --git a/drivers/usb/gadget/g_ffs.c b/drivers/usb/gadget/g_ffs.c
index a9474f8..b7287ba 100644
--- a/drivers/usb/gadget/g_ffs.c
+++ b/drivers/usb/gadget/g_ffs.c
@@ -53,9 +53,6 @@ MODULE_AUTHOR("Michal Nazarewicz");
 MODULE_LICENSE("GPL");
 
 
-static unsigned short gfs_vendor_id    = 0x0525;	/* XXX NetChip */
-static unsigned short gfs_product_id   = 0xa4ac;	/* XXX */
-
 static struct usb_device_descriptor gfs_dev_desc = {
 	.bLength		= sizeof gfs_dev_desc,
 	.bDescriptorType	= USB_DT_DEVICE,
@@ -63,14 +60,8 @@ static struct usb_device_descriptor gfs_dev_desc = {
 	.bcdUSB			= cpu_to_le16(0x0200),
 	.bDeviceClass		= USB_CLASS_PER_INTERFACE,
 
-	/* Vendor and product id can be overridden by module parameters.  */
-	/* .idVendor		= cpu_to_le16(gfs_vendor_id), */
-	/* .idProduct		= cpu_to_le16(gfs_product_id), */
-	/* .bcdDevice		= f(hardware) */
-	/* .iManufacturer	= DYNAMIC */
-	/* .iProduct		= DYNAMIC */
-	/* NO SERIAL NUMBER */
-	.bNumConfigurations	= 1,
+	.idVendor		= cpu_to_le16(0x0525),
+	.idProduct		= cpu_to_le16(0xa4ac),
 };
 
 #define GFS_MODULE_PARAM_DESC(name, field) \
@@ -82,10 +73,6 @@ module_param_named(usb_subclass, gfs_dev_desc.bDeviceSubClass, byte,   0644);
 GFS_MODULE_PARAM_DESC(usb_subclass, bDeviceSubClass);
 module_param_named(usb_protocol, gfs_dev_desc.bDeviceProtocol, byte,   0644);
 GFS_MODULE_PARAM_DESC(usb_protocol, bDeviceProtocol);
-module_param_named(usb_vendor,   gfs_vendor_id,                ushort, 0644);
-GFS_MODULE_PARAM_DESC(usb_vendor, idVendor);
-module_param_named(usb_product,  gfs_product_id,               ushort, 0644);
-GFS_MODULE_PARAM_DESC(usb_product, idProduct);
 
 
 
@@ -105,19 +92,7 @@ static const struct usb_descriptor_header *gfs_otg_desc[] = {
 
 /* string IDs are assigned dynamically */
 
-enum {
-	GFS_STRING_MANUFACTURER_IDX,
-	GFS_STRING_PRODUCT_IDX,
-	GFS_STRING_FIRST_CONFIG_IDX,
-};
-
-static       char gfs_manufacturer[50];
-static const char gfs_driver_desc[] = DRIVER_DESC;
-static const char gfs_short_name[]  = DRIVER_NAME;
-
 static struct usb_string gfs_strings[] = {
-	[GFS_STRING_MANUFACTURER_IDX].s = gfs_manufacturer,
-	[GFS_STRING_PRODUCT_IDX].s = gfs_driver_desc,
 #ifdef CONFIG_USB_FUNCTIONFS_RNDIS
 	{ .s = "FunctionFS + RNDIS" },
 #endif
@@ -168,11 +143,12 @@ static int gfs_unbind(struct usb_composite_dev *cdev);
 static int gfs_do_config(struct usb_configuration *c);
 
 static struct usb_composite_driver gfs_driver = {
-	.name		= gfs_short_name,
+	.name		= DRIVER_NAME,
 	.dev		= &gfs_dev_desc,
 	.strings	= gfs_dev_strings,
 	.bind		= gfs_bind,
 	.unbind		= gfs_unbind,
+	.iProduct	= DRIVER_DESC,
 };
 
 
@@ -245,20 +221,10 @@ static int gfs_bind(struct usb_composite_dev *cdev)
 	if (unlikely(ret < 0))
 		goto error_quick;
 
-	gfs_dev_desc.idVendor  = cpu_to_le16(gfs_vendor_id);
-	gfs_dev_desc.idProduct = cpu_to_le16(gfs_product_id);
-
-	snprintf(gfs_manufacturer, sizeof gfs_manufacturer, "%s %s with %s",
-		 init_utsname()->sysname, init_utsname()->release,
-		 cdev->gadget->name);
-
 	ret = usb_string_ids_tab(cdev, gfs_strings);
 	if (unlikely(ret < 0))
 		goto error;
 
-	gfs_dev_desc.iManufacturer = gfs_strings[GFS_STRING_MANUFACTURER_IDX].id;
-	gfs_dev_desc.iProduct      = gfs_strings[GFS_STRING_PRODUCT_IDX].id;
-
 	ret = functionfs_bind(gfs_ffs_data, cdev);
 	if (unlikely(ret < 0))
 		goto error;
@@ -266,9 +232,8 @@ static int gfs_bind(struct usb_composite_dev *cdev)
 	for (i = 0; i < ARRAY_SIZE(gfs_configurations); ++i) {
 		struct gfs_configuration *c = gfs_configurations + i;
 
-		ret = GFS_STRING_FIRST_CONFIG_IDX + i;
-		c->c.label			= gfs_strings[ret].s;
-		c->c.iConfiguration		= gfs_strings[ret].id;
+		c->c.label			= gfs_strings[i].s;
+		c->c.iConfiguration		= gfs_strings[i].id;
 		c->c.bind			= gfs_do_config;
 		c->c.bConfigurationValue	= 1 + i;
 		c->c.bmAttributes		= USB_CONFIG_ATT_SELFPOWER;
diff --git a/drivers/usb/gadget/mass_storage.c b/drivers/usb/gadget/mass_storage.c
index 585f255..0354d69 100644
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
@@ -173,7 +143,6 @@ static struct usb_configuration msg_config_driver = {
 	.label			= "Linux File-Backed Storage",
 	.bind			= msg_do_config,
 	.bConfigurationValue	= 1,
-	/* .iConfiguration = DYNAMIC */
 	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
 };
 
@@ -184,43 +153,15 @@ static struct usb_configuration msg_config_driver = {
 
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
-	if (status < 0)
-		return status;
-
-	dev_info(&gadget->dev, DRIVER_DESC ", version: " DRIVER_VERSION "\n");
-	set_bit(0, &msg_registered);
-	return 0;
+	if (status >= 0) {
+		dev_info(&cdev->gadget->dev,
+			 DRIVER_DESC ", version: " DRIVER_VERSION "\n");
+		set_bit(0, &msg_registered);
+	}
+	return status;
 }
 
 
@@ -230,8 +171,9 @@ static int __ref msg_bind(struct usb_composite_dev *cdev)
 static struct usb_composite_driver msg_driver = {
 	.name		= "g_mass_storage",
 	.dev		= &msg_device_desc,
-	.strings	= dev_strings,
 	.bind		= msg_bind,
+	.iProduct	= DRIVER_DESC,
+	.needs_serial	= 1,
 };
 
 MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/usb/gadget/multi.c b/drivers/usb/gadget/multi.c
index 795d762..8f7d512 100644
--- a/drivers/usb/gadget/multi.c
+++ b/drivers/usb/gadget/multi.c
@@ -121,8 +121,6 @@ static const struct usb_descriptor_header *otg_desc[] = {
 
 
 enum {
-	MULTI_STRING_MANUFACTURER_IDX,
-	MULTI_STRING_PRODUCT_IDX,
 #ifdef CONFIG_USB_G_MULTI_RNDIS
 	MULTI_STRING_RNDIS_CONFIG_IDX,
 #endif
@@ -131,11 +129,7 @@ enum {
 #endif
 };
 
-static char manufacturer[50];
-
 static struct usb_string strings_dev[] = {
-	[MULTI_STRING_MANUFACTURER_IDX].s = manufacturer,
-	[MULTI_STRING_PRODUCT_IDX].s      = DRIVER_DESC,
 #ifdef CONFIG_USB_G_MULTI_RNDIS
 	[MULTI_STRING_RNDIS_CONFIG_IDX].s = "Multifunction with RNDIS",
 #endif
@@ -314,20 +308,11 @@ static int __ref multi_bind(struct usb_composite_dev *cdev)
 		device_desc.bcdDevice = cpu_to_le16(0x0300 | 0x0099);
 	}
 
-	/* allocate string descriptor numbers */
-	snprintf(manufacturer, sizeof manufacturer, "%s %s with %s",
-	         init_utsname()->sysname, init_utsname()->release,
-	         gadget->name);
-
+	/* allocate string IDs */
 	status = usb_string_ids_tab(cdev, strings_dev);
 	if (unlikely(status < 0))
 		goto fail2;
 
-	device_desc.iManufacturer =
-		strings_dev[MULTI_STRING_MANUFACTURER_IDX].id;
-	device_desc.iProduct      =
-		strings_dev[MULTI_STRING_PRODUCT_IDX].id;
-
 	/* register configurations */
 	status = rndis_config_register(cdev);
 	if (unlikely(status < 0))
@@ -370,6 +355,8 @@ static struct usb_composite_driver multi_driver = {
 	.strings	= dev_strings,
 	.bind		= multi_bind,
 	.unbind		= __exit_p(multi_unbind),
+	.iProduct	= DRIVER_DESC,
+	.needs_serial	= 1,
 };
 
 
-- 
1.7.1

