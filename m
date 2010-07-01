Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab0GAJRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 05:17:47 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51113 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab0GAJRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 05:17:05 -0400
Date: Thu, 01 Jul 2010 11:17:45 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH 2/2] USB: gadget: mass/file storage: set serial number
In-reply-to: <c73431dbedd41f94c5f471fb5e466943cee870c1.1277974263.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org,
       Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
       stable <stable@kernel.org>
Message-id: <453e261ef6edbdbc72cce8563b0f8a3246d38a84.1277971452.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <c73431dbedd41f94c5f471fb5e466943cee870c1.1277974263.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds iSerialNumber to all gadgets that use the Mass
Storage Function.  It appears that Windows has problems when
it is not set.

Not to copy the same code all over again, a fsg_string_serial_fill()
macro has been added to the storage_common.c file which is now also
used in the File Storage Gadget.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reported-by: Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>
Tested-by: Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>
Cc: stable <stable@kernel.org>
---
This is the version of the "set serial number" patch for older stable
kernels.

 drivers/usb/gadget/file_storage.c   |   10 +-------
 drivers/usb/gadget/mass_storage.c   |   45 +++++++++++++++-------------------
 drivers/usb/gadget/multi.c          |   12 +++++++++
 drivers/usb/gadget/storage_common.c |   12 +++++++++
 4 files changed, 45 insertions(+), 34 deletions(-)

diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index 29dfb02..4366af8 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -3451,15 +3451,7 @@ static int __init fsg_bind(struct usb_gadget *gadget)
 			init_utsname()->sysname, init_utsname()->release,
 			gadget->name);
 
-	/* On a real device, serial[] would be loaded from permanent
-	 * storage.  We just encode it from the driver version string. */
-	for (i = 0; i < sizeof fsg_string_serial - 2; i += 2) {
-		unsigned char		c = DRIVER_VERSION[i / 2];
-
-		if (!c)
-			break;
-		sprintf(&fsg_string_serial[i], "%02X", c);
-	}
+	fsg_string_serial_fill(fsg_string_serial, DRIVER_VERSION);
 
 	fsg->thread_task = kthread_create(fsg_main_thread, fsg,
 			"file-storage-gadget");
diff --git a/drivers/usb/gadget/mass_storage.c b/drivers/usb/gadget/mass_storage.c
index 19619fb..91661c0 100644
--- a/drivers/usb/gadget/mass_storage.c
+++ b/drivers/usb/gadget/mass_storage.c
@@ -72,21 +72,16 @@ static struct usb_device_descriptor msg_device_desc = {
 	.bcdUSB =		cpu_to_le16(0x0200),
 	.bDeviceClass =		USB_CLASS_PER_INTERFACE,
 
-	/* Vendor and product id can be overridden by module parameters.  */
 	.idVendor =		cpu_to_le16(FSG_VENDOR_ID),
 	.idProduct =		cpu_to_le16(FSG_PRODUCT_ID),
-	/* .bcdDevice = f(hardware) */
-	/* .iManufacturer = DYNAMIC */
-	/* .iProduct = DYNAMIC */
-	/* NO SERIAL NUMBER */
-	.bNumConfigurations =	1,
 };
 
 static struct usb_otg_descriptor otg_descriptor = {
 	.bLength =		sizeof otg_descriptor,
 	.bDescriptorType =	USB_DT_OTG,
 
-	/* REVISIT SRP-only hardware is possible, although
+	/*
+	 * REVISIT SRP-only hardware is possible, although
 	 * it would not be called "OTG" ...
 	 */
 	.bmAttributes =		USB_OTG_SRP | USB_OTG_HNP,
@@ -100,16 +95,21 @@ static const struct usb_descriptor_header *otg_desc[] = {
 
 /* string IDs are assigned dynamically */
 
-#define STRING_MANUFACTURER_IDX		0
-#define STRING_PRODUCT_IDX		1
-#define STRING_CONFIGURATION_IDX	2
+enum {
+	STRING_MANUFACTURER_IDX,
+	STRING_PRODUCT_IDX,
+	STRING_CONFIGURATION_IDX,
+	STRING_SERIAL_IDX
+};
 
 static char manufacturer[50];
+static char serial[13];
 
 static struct usb_string strings_dev[] = {
 	[STRING_MANUFACTURER_IDX].s = manufacturer,
 	[STRING_PRODUCT_IDX].s = DRIVER_DESC,
 	[STRING_CONFIGURATION_IDX].s = "Self Powered",
+	[STRING_SERIAL_IDX].s = serial,
 	{  } /* end of list */
 };
 
@@ -161,7 +161,6 @@ static struct usb_configuration msg_config_driver = {
 	.label			= "Linux File-Backed Storage",
 	.bind			= msg_do_config,
 	.bConfigurationValue	= 1,
-	/* .iConfiguration = DYNAMIC */
 	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
 };
 
@@ -175,25 +174,21 @@ static int __init msg_bind(struct usb_composite_dev *cdev)
 	struct usb_gadget *gadget = cdev->gadget;
 	int status;
 
-	/* Allocate string descriptor numbers ... note that string
-	 * contents can be overridden by the composite_dev glue.
-	 */
-
-	/* device descriptor strings: manufacturer, product */
+	/* Take care of strings */
 	snprintf(manufacturer, sizeof manufacturer, "%s %s with %s",
 	         init_utsname()->sysname, init_utsname()->release,
 	         gadget->name);
-	status = usb_string_id(cdev);
-	if (status < 0)
-		return status;
-	strings_dev[STRING_MANUFACTURER_IDX].id = status;
-	msg_device_desc.iManufacturer = status;
 
-	status = usb_string_id(cdev);
+	fsg_string_serial_fill(serial, DRIVER_VERSION);
+
+	status = usb_string_ids_tab(cdev, strings_dev);
 	if (status < 0)
 		return status;
-	strings_dev[STRING_PRODUCT_IDX].id = status;
-	msg_device_desc.iProduct = status;
+
+	msg_device_desc.iManufacturer =
+		strings_dev[STRING_MANUFACTURER_IDX].id;
+	msg_device_desc.iProduct = strings_dev[STRING_PRODUCT_IDX].id;
+	msg_device_desc.iSerialNumber = strings_dev[STRING_SERIAL_IDX].id;
 
 	status = usb_string_id(cdev);
 	if (status < 0)
@@ -201,7 +196,7 @@ static int __init msg_bind(struct usb_composite_dev *cdev)
 	strings_dev[STRING_CONFIGURATION_IDX].id = status;
 	msg_config_driver.iConfiguration = status;
 
-	/* register our second configuration */
+	/* Register our second configuration */
 	status = usb_add_config(cdev, &msg_config_driver);
 	if (status < 0)
 		return status;
diff --git a/drivers/usb/gadget/multi.c b/drivers/usb/gadget/multi.c
index 76496f5..4b47f19 100644
--- a/drivers/usb/gadget/multi.c
+++ b/drivers/usb/gadget/multi.c
@@ -120,12 +120,15 @@ static const struct usb_descriptor_header *otg_desc[] = {
 
 #define STRING_MANUFACTURER_IDX		0
 #define STRING_PRODUCT_IDX		1
+#define STRING_PRODUCT_IDX		2
 
 static char manufacturer[50];
+static char serial[13];
 
 static struct usb_string strings_dev[] = {
 	[STRING_MANUFACTURER_IDX].s = manufacturer,
 	[STRING_PRODUCT_IDX].s = DRIVER_DESC,
+	[STRING_SERIAL_IDX].s = serial,
 	{  } /* end of list */
 };
 
@@ -283,6 +286,9 @@ static int __init multi_bind(struct usb_composite_dev *cdev)
 	snprintf(manufacturer, sizeof manufacturer, "%s %s with %s",
 	         init_utsname()->sysname, init_utsname()->release,
 	         gadget->name);
+
+	fsg_string_serial_fill(serial, DRIVER_VERSION);
+
 	status = usb_string_id(cdev);
 	if (status < 0)
 		goto fail2;
@@ -295,6 +301,12 @@ static int __init multi_bind(struct usb_composite_dev *cdev)
 	strings_dev[STRING_PRODUCT_IDX].id = status;
 	device_desc.iProduct = status;
 
+	status = usb_string_id(cdev);
+	if (status < 0)
+		goto fail2;
+	strings_dev[STRING_SERIAL_IDX].id = status;
+	device_desc.iSerialNumber = status;
+
 #ifdef USB_ETH_RNDIS
 	/* register our first configuration */
 	status = usb_add_config(cdev, &rndis_config_driver);
diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index 868d8ee..1ba1004 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -545,6 +545,18 @@ static struct usb_gadget_strings	fsg_stringtab = {
 };
 
 
+#define fsg_string_serial_fill_n(serial, n, version) do {	\
+		unsigned char *c = version;			\
+		unsigned i = ((n) + 1) / 2;			\
+		char *s = serial;				\
+		for (; *c && --i; s += 2, ++c)			\
+			sprintf(s, "%02X", *c);			\
+	} while (0)
+
+#define fsg_string_serial_fill(serial, version)				\
+	fsg_string_serial_fill_n(serial, ARRAY_SIZE(serial), version)
+
+
  /*-------------------------------------------------------------------------*/
 
 /* If the next two routines are called while the gadget is registered,
-- 
1.7.1

