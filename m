Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab0GVMPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 08:15:30 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58574 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab0GVMPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 08:15:21 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 22 Jul 2010 14:16:34 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv4 2/5] USB: gadget: Use new composite features in some gadgets
In-reply-to: <89baa7d196b5e1d8427c90a78f2aa0cda4331d7a.1279794289.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        David Brownell <david-b@pacbell.net>,
        Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        stable <stable@kernel.org>
Message-id: <c50b89e66cc80f2f89e5c7d4948969e167eb9185.1279794289.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <e2d14d0a730dde4b716c0e086761ef65ba9afda8.1278619472.git.m.nazarewicz@samsung.com>
 <89baa7d196b5e1d8427c90a78f2aa0cda4331d7a.1279794289.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch FunctionFS, Mass Storage and Multifunction gadgets
use the new features of composite framework.  Because it
handles default strings there is no longer the need for the
gadgets drivers to handle many of the strings.

This also adds the "needs_serial" to Mass Storage Gadget and
Multifunction Composite Gadget which fills the iSerialNumber
as well.  This in effect, makes some hosts happier.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reported-by: Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>
Cc: stable <stable@kernel.org>
---
 drivers/usb/gadget/g_ffs.c        |   29 ++++---------------
 drivers/usb/gadget/mass_storage.c |   56 +-----------------------------------
 drivers/usb/gadget/multi.c        |   48 +------------------------------
 3 files changed, 10 insertions(+), 123 deletions(-)

diff --git a/drivers/usb/gadget/g_ffs.c b/drivers/usb/gadget/g_ffs.c
index d1af253..4ba24d1 100644
--- a/drivers/usb/gadget/g_ffs.c
+++ b/drivers/usb/gadget/g_ffs.c
@@ -105,8 +105,6 @@ static const struct usb_descriptor_header *gfs_otg_desc[] = {
 /* string IDs are assigned dynamically */
 
 enum {
-	GFS_STRING_MANUFACTURER_IDX,
-	GFS_STRING_PRODUCT_IDX,
 #ifdef CONFIG_USB_FUNCTIONFS_RNDIS
 	GFS_STRING_RNDIS_CONFIG_IDX,
 #endif
@@ -118,13 +116,7 @@ enum {
 #endif
 };
 
-static       char gfs_manufacturer[50];
-static const char gfs_driver_desc[] = DRIVER_DESC;
-static const char gfs_short_name[]  = DRIVER_NAME;
-
 static struct usb_string gfs_strings[] = {
-	[GFS_STRING_MANUFACTURER_IDX].s = gfs_manufacturer,
-	[GFS_STRING_PRODUCT_IDX].s = gfs_driver_desc,
 #ifdef CONFIG_USB_FUNCTIONFS_RNDIS
 	[GFS_STRING_RNDIS_CONFIG_IDX].s = "FunctionFS + RNDIS",
 #endif
@@ -201,7 +193,8 @@ static int gfs_bind(struct usb_composite_dev *cdev);
 static int gfs_unbind(struct usb_composite_dev *cdev);
 
 static struct usb_composite_driver gfs_driver = {
-	.name		= gfs_short_name,
+	.name		= DRIVER_NAME,
+	.iProduct	= DRIVER_DESC,
 	.dev		= &gfs_dev_desc,
 	.strings	= gfs_dev_strings,
 	.bind		= gfs_bind,
@@ -281,20 +274,10 @@ static int gfs_bind(struct usb_composite_dev *cdev)
 	gfs_dev_desc.idVendor  = cpu_to_le16(gfs_vendor_id);
 	gfs_dev_desc.idProduct = cpu_to_le16(gfs_product_id);
 
-	snprintf(gfs_manufacturer, sizeof gfs_manufacturer, "%s %s with %s",
-		 init_utsname()->sysname, init_utsname()->release,
-		 cdev->gadget->name);
-	ret = usb_string_id(cdev);
-	if (unlikely(ret < 0))
-		goto error;
-	gfs_strings[GFS_STRING_MANUFACTURER_IDX].id = ret;
-	gfs_dev_desc.iManufacturer = ret;
-
-	ret = usb_string_id(cdev);
-	if (unlikely(ret < 0))
-		goto error;
-	gfs_strings[GFS_STRING_PRODUCT_IDX].id = ret;
-	gfs_dev_desc.iProduct = ret;
+	/* Make sure composite glue gets fresh descriptors each time. */
+	gfs_dev_desc.iManufacturer = 0;
+	gfs_dev_desc.iProduct      = 0;
+	gfs_dev_desc.iSerialNumber = 0;
 
 #ifdef CONFIG_USB_FUNCTIONFS_RNDIS
 	ret = usb_string_id(cdev);
diff --git a/drivers/usb/gadget/mass_storage.c b/drivers/usb/gadget/mass_storage.c
index 705cc1f..6a1dcd1 100644
--- a/drivers/usb/gadget/mass_storage.c
+++ b/drivers/usb/gadget/mass_storage.c
@@ -98,32 +98,6 @@ static const struct usb_descriptor_header *otg_desc[] = {
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
 
 /****************************** Configurations ******************************/
 
@@ -181,33 +155,6 @@ static int __init msg_bind(struct usb_composite_dev *cdev)
 	struct usb_gadget *gadget = cdev->gadget;
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
@@ -223,8 +170,9 @@ static int __init msg_bind(struct usb_composite_dev *cdev)
 
 static struct usb_composite_driver msg_driver = {
 	.name		= "g_mass_storage",
+	.iProduct	= DRIVER_DESC,
+	.needs_serial	= 1,
 	.dev		= &msg_device_desc,
-	.strings	= dev_strings,
 	.bind		= msg_bind,
 };
 
diff --git a/drivers/usb/gadget/multi.c b/drivers/usb/gadget/multi.c
index a930d7f..b9ed05b 100644
--- a/drivers/usb/gadget/multi.c
+++ b/drivers/usb/gadget/multi.c
@@ -116,29 +116,6 @@ static const struct usb_descriptor_header *otg_desc[] = {
 };
 
 
-/* string IDs are assigned dynamically */
-
-#define STRING_MANUFACTURER_IDX		0
-#define STRING_PRODUCT_IDX		1
-
-static char manufacturer[50];
-
-static struct usb_string strings_dev[] = {
-	[STRING_MANUFACTURER_IDX].s = manufacturer,
-	[STRING_PRODUCT_IDX].s = DRIVER_DESC,
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
 static u8 hostaddr[ETH_ALEN];
 
 
@@ -258,7 +235,6 @@ static int __init multi_bind(struct usb_composite_dev *cdev)
 		goto fail1;
 	}
 
-
 	gcnum = usb_gadget_controller_number(gadget);
 	if (gcnum >= 0)
 		device_desc.bcdDevice = cpu_to_le16(0x0300 | gcnum);
@@ -272,27 +248,6 @@ static int __init multi_bind(struct usb_composite_dev *cdev)
 		device_desc.bcdDevice = cpu_to_le16(0x0300 | 0x0099);
 	}
 
-
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
-		goto fail2;
-	strings_dev[STRING_MANUFACTURER_IDX].id = status;
-	device_desc.iManufacturer = status;
-
-	status = usb_string_id(cdev);
-	if (status < 0)
-		goto fail2;
-	strings_dev[STRING_PRODUCT_IDX].id = status;
-	device_desc.iProduct = status;
-
 #ifdef USB_ETH_RNDIS
 	/* register our first configuration */
 	status = usb_add_config(cdev, &rndis_config_driver);
@@ -333,8 +288,9 @@ static int __exit multi_unbind(struct usb_composite_dev *cdev)
 
 static struct usb_composite_driver multi_driver = {
 	.name		= "g_multi",
+	.iProduct	= DRIVER_DESC,
+	.needs_serial	= 1,
 	.dev		= &device_desc,
-	.strings	= dev_strings,
 	.bind		= multi_bind,
 	.unbind		= __exit_p(multi_unbind),
 };
-- 
1.7.1

