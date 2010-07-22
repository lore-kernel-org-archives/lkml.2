Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007Ab0GVMQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 08:16:34 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58574 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab0GVMPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 08:15:24 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 22 Jul 2010 14:16:33 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv4 1/5] USB: gadget: composite: Better string override handling
In-reply-to: <e2d14d0a730dde4b716c0e086761ef65ba9afda8.1278619472.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        David Brownell <david-b@pacbell.net>,
        Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        stable <stable@kernel.org>
Message-id: <89baa7d196b5e1d8427c90a78f2aa0cda4331d7a.1279794289.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <e2d14d0a730dde4b716c0e086761ef65ba9afda8.1278619472.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The iManufatcurer, iProduct and iSerialNumber composite module
parameters are only used when the gadget driver registers
strings for manufacturer, product and serial number.  If the
gadget never bothered to set corresponding fields in USB
device descriptors those module parameters are ignored.

This patch makes the parameters even if the strings ID have
not been assigned.  It also changes the way IDs are
overridden -- what IDs are overridden is now saved in
usb_composite_dev structure -- which makes it unnecessary to
modify the string tables the way previous code did.

What's more, the patch adds default values for manufacturer,
product and serial number:

1. If the iManufatcurer string is not registered by the gadget
   driver, composite will use a "<system> <release> with
   <gadget-name>" string as the manufacturer.

2. If the iProduct string is not registered by the gadget
   driver, composite will try to use
   a usb_composite_device::iProduct value (if gadget driver
   set it) or usb_composite_device::name.

3. If the iSerialNumber string is not registered by the gadget
   driver, and usb_composite_device::needs_serial is set,
   composite will use a fake serial and issue a warning
   informing that userspace failed to provide the
   iSerialNumber module parameter.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: stable <stable@kernel.org>
---
Hello again,

The following patchset include 5 patches.

The first one (the one you are reading ;) ) fixes composite framework
to make iManufatcurer, iProduct and iSerialNumber module parameters
even if gadget drivers did not register IDs for those strings.

It also adds code to composite which provide some defaults for those
strings.  In particular, if gadget driver sets
"usb_composite_device::needs_serial" field composite will provide some
fake serial if gadget driver did not set one and userspace failed to
provide iSerialNumber.

The second patch uses this last feature in mass storage and multi
gadgets.

The next two patches are merely updates of what Greg already have in
his tree.

The last patch adds modifications to Yann Cantin's patch requested by
Alan.


So, David, what do you think about this approach?  Before you NACK
please consider the fact that it allows to move some code from gadget
drivers to the composite framework in the end simplifying everything
overally.


Also, Greg, it's more complex then the previous version so I leave it
up to you whether it'll get into the .35.  If you decide to include it
for .36 rather then .35 consider adding the patches at the beginning
as they won't apply at the end of the queue.


 drivers/usb/gadget/composite.c |   93 ++++++++++++++++++++++++++--------------
 include/linux/usb/composite.h  |   10 ++++
 2 files changed, 71 insertions(+), 32 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 391d169..8c1d924 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -69,6 +69,8 @@ static char *iSerialNumber;
 module_param(iSerialNumber, charp, 0);
 MODULE_PARM_DESC(iSerialNumber, "SerialNumber string");
 
+static char composite_manufacturer[50];
+
 /*-------------------------------------------------------------------------*/
 
 /**
@@ -599,6 +601,7 @@ static int get_string(struct usb_composite_dev *cdev,
 	struct usb_configuration	*c;
 	struct usb_function		*f;
 	int				len;
+	const char			*str;
 
 	/* Yes, not only is USB's I18N support probably more than most
 	 * folk will ever care about ... also, it's all supported here.
@@ -638,9 +641,28 @@ static int get_string(struct usb_composite_dev *cdev,
 		return s->bLength;
 	}
 
-	/* Otherwise, look up and return a specified string.  String IDs
-	 * are device-scoped, so we look up each string table we're told
-	 * about.  These lookups are infrequent; simpler-is-better here.
+	/* Otherwise, look up and return a specified string.  First
+	 * check if the string has not been overridden.
+	 */
+	if (cdev->manufacturer_override == id)
+		str = iManufacturer ?: composite_manufacturer;
+	else if (cdev->product_override == id)
+		str = iProduct ?: composite->iProduct;
+	else if (cdev->serial_override == id)
+		str = iSerialNumber ?: "0123456789AB";
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
@@ -960,26 +982,17 @@ composite_unbind(struct usb_gadget *gadget)
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
@@ -1036,18 +1049,32 @@ static int composite_bind(struct usb_gadget *gadget)
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
+		if (!cdev->desc.iManufacturer &&
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
+	if (iSerialNumber ||
+	    (composite->needs_serial && !cdev->desc.iSerialNumber)) {
+		if (!iSerialNumber)
+			WARNING(cdev, "userspace failed to provide iSerialNumber, using fake one\n");
+		cdev->serial_override =
+			override_id(cdev, &cdev->desc.iSerialNumber);
+	}
 
 	status = device_create_file(&gadget->dev, &dev_attr_suspended);
 	if (status)
@@ -1146,6 +1173,8 @@ int usb_composite_register(struct usb_composite_driver *driver)
 	if (!driver || !driver->dev || !driver->bind || composite)
 		return -EINVAL;
 
+	if (!driver->iProduct)
+		driver->iProduct = driver->name;
 	if (!driver->name)
 		driver->name = "composite";
 	composite_driver.function =  (char *) driver->name;
diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index 139353e..82174e5 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -237,10 +237,15 @@ int usb_add_config(struct usb_composite_dev *,
 /**
  * struct usb_composite_driver - groups configurations into a gadget
  * @name: For diagnostics, identifies the driver.
+ * @iProduct: Used as iProduct override if @dev->iProduct is not set.
+ *	If NULL value of @name is taken.
  * @dev: Template descriptor for the device, including default device
  *	identifiers.
  * @strings: tables of strings, keyed by identifiers assigned during bind()
  *	and language IDs provided in control requests
+ * @needs_serial: set to 1 if the gadget needs userspace to provide
+ * 	a serial number.  If one is not provided, warning will be printed
+ * 	and fake serial number provided.
  * @bind: (REQUIRED) Used to allocate resources that are shared across the
  *	whole device, such as string IDs, and add its configurations using
  *	@usb_add_config().  This may fail by returning a negative errno
@@ -265,8 +270,10 @@ int usb_add_config(struct usb_composite_dev *,
  */
 struct usb_composite_driver {
 	const char				*name;
+	const char				*iProduct;
 	const struct usb_device_descriptor	*dev;
 	struct usb_gadget_strings		**strings;
+	unsigned		needs_serial:1;
 
 	/* REVISIT:  bind() functions can be marked __init, which
 	 * makes trouble for section mismatch analysis.  See if
@@ -331,6 +338,9 @@ struct usb_composite_dev {
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

