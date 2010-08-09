Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab0HIPCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 11:02:22 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36742 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919Ab0HIPBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 11:01:15 -0400
Date: Mon, 09 Aug 2010 17:02:28 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv7 3/8] USB: gadget: composite: Better string override handling
In-reply-to: <b4fe56570ecb77ec6acbab4502f7ad87b72885e1.1281365237.git.m.nazarewicz@samsung.com>
To: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
        USB <linux-usb@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        Vladimir Pankratov <scriptkid@mail.ru>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <9219d2c4e7b60f2ad1455b6c702604e84ef90e1b.1281365237.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1281365237.git.m.nazarewicz@samsung.com>
 <49ebe5a39e05aa55a19d33a2141736d215873f86.1281365237.git.m.nazarewicz@samsung.com>
 <b4fe56570ecb77ec6acbab4502f7ad87b72885e1.1281365237.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The iManufatcurer, iProduct and iSerialNumber composite module
parameters were only used when the gadget driver registers
strings for manufacturer, product and serial number.  If the
gadget never bothered to set corresponding fields in USB device
descriptors those module parameters are ignored.

This commit makes the parameters work even if the strings ID
have not been assigned.  It also changes the way IDs are
overridden -- what IDs are overridden is now saved in
usb_composite_dev structure -- which makes it unnecessary to
modify the string tables the way previous code did.

The commit also adds a iProduct and iManufatcurer fields to the
usb_composite_device structure.  If they are set, appropriate
strings are reserved and added to device descriptor.  This makes
it unnecessary for gadget drivers to maintain code for setting
those.  If iProduct is not set it defaults to
usb_composite_device::name; if iManufatcurer is not set
a default "<system> <release> with <gadget-name>" is used.

The last thing is that if needs_serial field of
usb_composite_device is set and user failed to provided
iSerialNumber parameter a warning is issued.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/composite.c |   96 ++++++++++++++++++++++++++-------------
 include/linux/usb/composite.h  |   13 +++++
 2 files changed, 77 insertions(+), 32 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index e483f80..471c759 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -24,6 +24,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/device.h>
+#include <linux/utsname.h>
 
 #include <linux/usb/composite.h>
 
@@ -69,6 +70,8 @@ static char *iSerialNumber;
 module_param(iSerialNumber, charp, 0);
 MODULE_PARM_DESC(iSerialNumber, "SerialNumber string");
 
+static char composite_manufacturer[50];
+
 /*-------------------------------------------------------------------------*/
 
 /**
@@ -599,6 +602,7 @@ static int get_string(struct usb_composite_dev *cdev,
 	struct usb_configuration	*c;
 	struct usb_function		*f;
 	int				len;
+	const char			*str;
 
 	/* Yes, not only is USB's I18N support probably more than most
 	 * folk will ever care about ... also, it's all supported here.
@@ -638,9 +642,29 @@ static int get_string(struct usb_composite_dev *cdev,
 		return s->bLength;
 	}
 
-	/* Otherwise, look up and return a specified string.  String IDs
-	 * are device-scoped, so we look up each string table we're told
-	 * about.  These lookups are infrequent; simpler-is-better here.
+	/* Otherwise, look up and return a specified string.  First
+	 * check if the string has not been overridden.
+	 */
+	if (cdev->manufacturer_override == id)
+		str = iManufacturer ?: composite->iManufacturer ?:
+			composite_manufacturer;
+	else if (cdev->product_override == id)
+		str = iProduct ?: composite->iProduct;
+	else if (cdev->serial_override == id)
+		str = iSerialNumber;
+	else
+		str = NULL;
+	if (str) {
+		struct usb_gadget_strings strings = {
+			.language = language,
+			.strings  = &(struct usb_string) { 0xff, str }
+		};
+		return usb_gadget_get_string(&strings, 0xff, buf);
+	}
+
+	/* String IDs are device-scoped, so we look up each string
+	 * table we're told about.  These lookups are infrequent;
+	 * simpler-is-better here.
 	 */
 	if (composite->strings) {
 		len = lookup_string(composite->strings, buf, language, id);
@@ -1025,26 +1049,17 @@ composite_unbind(struct usb_gadget *gadget)
 	composite = NULL;
 }
 
-static void
-string_override_one(struct usb_gadget_strings *tab, u8 id, const char *s)
+static u8 override_id(struct usb_composite_dev *cdev, u8 *desc)
 {
-	struct usb_string		*str = tab->strings;
-
-	for (str = tab->strings; str->s; str++) {
-		if (str->id == id) {
-			str->s = s;
-			return;
-		}
+	if (!*desc) {
+		int ret = usb_string_id(cdev);
+		if (unlikely(ret < 0))
+			WARNING(cdev, "failed to override string ID\n");
+		else
+			*desc = ret;
 	}
-}
 
-static void
-string_override(struct usb_gadget_strings **tab, u8 id, const char *s)
-{
-	while (*tab) {
-		string_override_one(*tab, id, s);
-		tab++;
-	}
+	return *desc;
 }
 
 static int composite_bind(struct usb_gadget *gadget)
@@ -1101,19 +1116,34 @@ static int composite_bind(struct usb_gadget *gadget)
 	cdev->desc = *composite->dev;
 	cdev->desc.bMaxPacketSize0 = gadget->ep0->maxpacket;
 
-	/* strings can't be assigned before bind() allocates the
-	 * releavnt identifiers
-	 */
-	if (cdev->desc.iManufacturer && iManufacturer)
-		string_override(composite->strings,
-			cdev->desc.iManufacturer, iManufacturer);
-	if (cdev->desc.iProduct && iProduct)
-		string_override(composite->strings,
-			cdev->desc.iProduct, iProduct);
-	if (cdev->desc.iSerialNumber && iSerialNumber)
-		string_override(composite->strings,
-			cdev->desc.iSerialNumber, iSerialNumber);
+	/* stirng overrides */
+	if (iManufacturer || !cdev->desc.iManufacturer) {
+		if (!iManufacturer && !composite->iManufacturer &&
+		    !*composite_manufacturer)
+			snprintf(composite_manufacturer,
+				 sizeof composite_manufacturer,
+				 "%s %s with %s",
+				 init_utsname()->sysname,
+				 init_utsname()->release,
+				 gadget->name);
+
+		cdev->manufacturer_override =
+			override_id(cdev, &cdev->desc.iManufacturer);
+	}
+
+	if (iProduct || (!cdev->desc.iProduct && composite->iProduct))
+		cdev->product_override =
+			override_id(cdev, &cdev->desc.iProduct);
+
+	if (iSerialNumber)
+		cdev->serial_override =
+			override_id(cdev, &cdev->desc.iSerialNumber);
+
+	/* has userspace failed to provide a serial number? */
+	if (composite->needs_serial && !cdev->desc.iSerialNumber)
+		WARNING(cdev, "userspace failed to provide iSerialNumber\n");
 
+	/* finish up */
 	status = device_create_file(&gadget->dev, &dev_attr_suspended);
 	if (status)
 		goto fail;
@@ -1211,6 +1241,8 @@ int usb_composite_register(struct usb_composite_driver *driver)
 	if (!driver || !driver->dev || !driver->bind || composite)
 		return -EINVAL;
 
+	if (!driver->iProduct)
+		driver->iProduct = driver->name;
 	if (!driver->name)
 		driver->name = "composite";
 	composite_driver.function =  (char *) driver->name;
diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index 890bc14..d590904 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -237,10 +237,17 @@ int usb_add_config(struct usb_composite_dev *,
 /**
  * struct usb_composite_driver - groups configurations into a gadget
  * @name: For diagnostics, identifies the driver.
+ * @iProduct: Used as iProduct override if @dev->iProduct is not set.
+ *	If NULL value of @name is taken.
+ * @iManufacturer: Used as iManufacturer override if @dev->iManufacturer is
+ *	not set. If NULL a default "<system> <release> with <udc>" value
+ *	will be used.
  * @dev: Template descriptor for the device, including default device
  *	identifiers.
  * @strings: tables of strings, keyed by identifiers assigned during bind()
  *	and language IDs provided in control requests
+ * @needs_serial: set to 1 if the gadget needs userspace to provide
+ * 	a serial number.  If one is not provided, warning will be printed.
  * @bind: (REQUIRED) Used to allocate resources that are shared across the
  *	whole device, such as string IDs, and add its configurations using
  *	@usb_add_config().  This may fail by returning a negative errno
@@ -265,8 +272,11 @@ int usb_add_config(struct usb_composite_dev *,
  */
 struct usb_composite_driver {
 	const char				*name;
+	const char				*iProduct;
+	const char				*iManufacturer;
 	const struct usb_device_descriptor	*dev;
 	struct usb_gadget_strings		**strings;
+	unsigned		needs_serial:1;
 
 	/* REVISIT:  bind() functions can be marked __init, which
 	 * makes trouble for section mismatch analysis.  See if
@@ -333,6 +343,9 @@ struct usb_composite_dev {
 	struct list_head		configs;
 	struct usb_composite_driver	*driver;
 	u8				next_string_id;
+	u8				manufacturer_override;
+	u8				product_override;
+	u8				serial_override;
 
 	/* the gadget driver won't enable the data pullup
 	 * while the deactivation count is nonzero.
-- 
1.7.1

