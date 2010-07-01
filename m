Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab0GANln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 09:41:43 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14317 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab0GANll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 09:41:41 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 01 Jul 2010 15:42:19 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv2 1/2] USB: gadget: mass/file storage: set serial number
In-reply-to: <c73431dbedd41f94c5f471fb5e466943cee870c1.1277974263.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg KH <greg@kroah.com>, Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org,
       Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
       stable <stable@kernel.org>
Message-id: <624a27be8a9a4492976afaa8df78c07051cc6e25.1277987700.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
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
This time a code that works with .35-rc3.

Because I feel this should get into .35 and this patch breaks the
"usb-gadget-g_multi-code-clean-up-and-refactoring.patch" patch updated
g_multi clean up patch follows this one.

This is patch fixes an issue with Windows not recognising the mass
storage properly so it's not a stability or security fix.  As such, it
is non-critical to include it in stable kernels.  Nonetheless, it does
fix some bug.

 drivers/usb/gadget/file_storage.c   |   10 +---------
 drivers/usb/gadget/mass_storage.c   |   31 +++++++++++++++++++------------
 drivers/usb/gadget/multi.c          |   12 ++++++++++++
 drivers/usb/gadget/storage_common.c |   12 ++++++++++++
 4 files changed, 44 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index 7993267..16decb8 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -3447,15 +3447,7 @@ static int __ref fsg_bind(struct usb_gadget *gadget)
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
index 904d14b..c3690b8 100644
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
 
@@ -167,7 +167,6 @@ static struct usb_configuration msg_config_driver = {
 	.label			= "Linux File-Backed Storage",
 	.bind			= msg_do_config,
 	.bConfigurationValue	= 1,
-	/* .iConfiguration = DYNAMIC */
 	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
 };
 
@@ -181,7 +180,8 @@ static int __ref msg_bind(struct usb_composite_dev *cdev)
 	struct usb_gadget *gadget = cdev->gadget;
 	int status;
 
-	/* Allocate string descriptor numbers ... note that string
+	/*
+	 * Allocate string descriptor numbers ... note that string
 	 * contents can be overridden by the composite_dev glue.
 	 */
 
@@ -201,6 +201,13 @@ static int __ref msg_bind(struct usb_composite_dev *cdev)
 	strings_dev[STRING_PRODUCT_IDX].id = status;
 	msg_device_desc.iProduct = status;
 
+	fsg_string_serial_fill(serial, DRIVER_VERSION);
+	status = usb_string_id(cdev);
+	if (status < 0)
+		return status;
+	strings_dev[STRING_SERIAL_IDX].id = status;
+	msg_device_desc.iSerialNumber = status;
+
 	status = usb_string_id(cdev);
 	if (status < 0)
 		return status;
diff --git a/drivers/usb/gadget/multi.c b/drivers/usb/gadget/multi.c
index a930d7f..6f7447b 100644
--- a/drivers/usb/gadget/multi.c
+++ b/drivers/usb/gadget/multi.c
@@ -120,12 +120,15 @@ static const struct usb_descriptor_header *otg_desc[] = {
 
 #define STRING_MANUFACTURER_IDX		0
 #define STRING_PRODUCT_IDX		1
+#define STRING_SERIAL_IDX		2
 
 static char manufacturer[50];
+static char serial[13];
 
 static struct usb_string strings_dev[] = {
 	[STRING_MANUFACTURER_IDX].s = manufacturer,
 	[STRING_PRODUCT_IDX].s = DRIVER_DESC,
+	[STRING_SERIAL_IDX].s = serial,
 	{  } /* end of list */
 };
 
@@ -281,6 +284,9 @@ static int __init multi_bind(struct usb_composite_dev *cdev)
 	snprintf(manufacturer, sizeof manufacturer, "%s %s with %s",
 	         init_utsname()->sysname, init_utsname()->release,
 	         gadget->name);
+
+	fsg_string_serial_fill(serial, DRIVER_VERSION);
+
 	status = usb_string_id(cdev);
 	if (status < 0)
 		goto fail2;
@@ -293,6 +299,12 @@ static int __init multi_bind(struct usb_composite_dev *cdev)
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
index 04c462f..00acae1 100644
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

