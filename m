Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab1KKGR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 01:17:58 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51832 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab1KKGR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 01:17:56 -0500
From: peiyong feng <peiyong.feng.kernel@gmail.com>
To: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, peiyong feng <peiyong.feng.kernel@gmail.com>
Subject: [PATCH] Add name match for UDC and gadget driver. Only for g_ether Signed-off-by: peiyong feng <peiyong.feng.kernel@gmail.com>
Date: Fri, 11 Nov 2011 14:17:09 +0800
Message-Id: <1320992229-13155-1-git-send-email-peiyong.feng.kernel@gmail.com>
X-Mailer: git-send-email 1.7.7.rc0.235.g8d714
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/usb/gadget/composite.c |    1 +
 drivers/usb/gadget/ether.c     |    1 +
 drivers/usb/gadget/udc-core.c  |   15 +++++++++++++++
 include/linux/usb/composite.h  |    2 ++
 include/linux/usb/gadget.h     |    1 +
 5 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index f71b078..c1d2507 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1583,6 +1583,7 @@ int usb_composite_probe(struct usb_composite_driver *driver,
 	if (!driver->iProduct)
 		driver->iProduct = driver->name;
 	composite_driver.function =  (char *) driver->name;
+	composite_driver.name    = driver->name_udc;
 	composite_driver.driver.name = driver->name;
 	composite_driver.speed = min((u8)composite_driver.speed,
 				     (u8)driver->max_speed);
diff --git a/drivers/usb/gadget/ether.c b/drivers/usb/gadget/ether.c
index 0cd764d..320b9e2 100644
--- a/drivers/usb/gadget/ether.c
+++ b/drivers/usb/gadget/ether.c
@@ -390,6 +390,7 @@ static int __exit eth_unbind(struct usb_composite_dev *cdev)
 
 static struct usb_composite_driver eth_driver = {
 	.name		= "g_ether",
+	.name_udc	= CONFIG_UDC_NAME,
 	.dev		= &device_desc,
 	.strings	= dev_strings,
 	.max_speed	= USB_SPEED_SUPER,
diff --git a/drivers/usb/gadget/udc-core.c b/drivers/usb/gadget/udc-core.c
index 022baec..9a23620 100644
--- a/drivers/usb/gadget/udc-core.c
+++ b/drivers/usb/gadget/udc-core.c
@@ -37,6 +37,7 @@
  * to hold information about udc driver and gadget together.
  */
 struct usb_udc {
+	char *name;
 	struct usb_gadget_driver	*driver;
 	struct usb_gadget		*gadget;
 	struct device			dev;
@@ -144,6 +145,13 @@ static void usb_udc_release(struct device *dev)
 }
 
 static const struct attribute_group *usb_udc_attr_groups[];
+/*set the name of udc*/
+static void usb_udc_set_name(struct usb_udc *udc,char *name)
+{
+	char *tmp = kzalloc(strlen(name)+1);
+	strcpy(tmp,name);
+	usb_udc->name = tmp;
+}
 /**
  * usb_add_gadget_udc - adds a new gadget to the udc class driver list
  * @parent: the parent device to this udc. Usually the controller
@@ -162,6 +170,7 @@ int usb_add_gadget_udc(struct device *parent, struct usb_gadget *gadget)
 		goto err1;
 
 	device_initialize(&udc->dev);
+	usb_udc_set_name(udc,gadget.name);
 	udc->dev.release = usb_udc_release;
 	udc->dev.class = udc_class;
 	udc->dev.groups = usb_udc_attr_groups;
@@ -269,6 +278,12 @@ int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
 		return -EINVAL;
 
 	mutex_lock(&udc_lock);
+	/*First we get the specific udc*/
+	list_for_each_entry(udc, &udc_list, list) {
+		if (strcmp(udc->name,driver->name)==0)
+			goto found;
+	}
+	/*We take the first one that unused*/
 	list_for_each_entry(udc, &udc_list, list) {
 		/* For now we take the first one */
 		if (!udc->driver)
diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index a316fba..029c26d 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -245,6 +245,7 @@ int usb_add_config(struct usb_composite_dev *,
 /**
  * struct usb_composite_driver - groups configurations into a gadget
  * @name: For diagnostics, identifies the driver.
+ * @name_udc: which UDC this driver attach.
  * @iProduct: Used as iProduct override if @dev->iProduct is not set.
  *	If NULL value of @name is taken.
  * @iManufacturer: Used as iManufacturer override if @dev->iManufacturer is
@@ -278,6 +279,7 @@ int usb_add_config(struct usb_composite_dev *,
  */
 struct usb_composite_driver {
 	const char				*name;
+	const char 				*name_udc;
 	const char				*iProduct;
 	const char				*iManufacturer;
 	const struct usb_device_descriptor	*dev;
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index 1d3a675..e92083f 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -824,6 +824,7 @@ static inline int usb_gadget_disconnect(struct usb_gadget *gadget)
  */
 struct usb_gadget_driver {
 	char			*function;
+	char 			*name;
 	enum usb_device_speed	speed;
 	void			(*unbind)(struct usb_gadget *);
 	int			(*setup)(struct usb_gadget *,
-- 
1.7.7.rc0.235.g8d714

