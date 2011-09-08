Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab1IIAXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 20:23:41 -0400
Received: from mail.infrascan.de ([188.40.84.136]:34739 "EHLO infrascan.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756779Ab1IIAXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 20:23:30 -0400
X-Greylist: delayed 4200 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Sep 2011 20:23:29 EDT
From: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>
To: balbi@ti.com, gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Klaus Schwarzkopf <schwarzkopf@sensortherm.de>
Subject: [PATCH] usb: add new usb gadget for ACM and mass storage
Date: Thu,  8 Sep 2011 20:24:47 +0200
Message-Id: <1315506287-31368-1-git-send-email-schwarzkopf@sensortherm.de>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver provides two functions in one configuration:
a mass storage, and a CDC ACM (serial port) link.
Heavily based on multi.c and cdc2.c

Signed-off-by: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>
---
 drivers/usb/gadget/Kconfig  |   10 ++
 drivers/usb/gadget/Makefile |    2 +
 drivers/usb/gadget/acm_ms.c |  269 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/usb/gadget.h  |    1 +
 4 files changed, 282 insertions(+), 0 deletions(-)
 create mode 100644 drivers/usb/gadget/acm_ms.c

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 029e288..2592ba7 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -959,6 +959,16 @@ config USB_G_NOKIA
 	  It's only really useful for N900 hardware. If you're building
 	  a kernel for N900, say Y or M here. If unsure, say N.
 
+config USB_G_ACM_MS
+	tristate "CDC Composite Device (ACM and mass storage)"
+	depends on BLOCK
+	help
+	  This driver provides two functions in one configuration:
+	  a mass storage, and a CDC ACM (serial port) link.
+
+	  Say "y" to link the driver statically, or "m" to build a
+	  dynamically linked module called "g_acm_ms".
+
 config USB_G_MULTI
 	tristate "Multifunction Composite Gadget (EXPERIMENTAL)"
 	depends on BLOCK && NET
diff --git a/drivers/usb/gadget/Makefile b/drivers/usb/gadget/Makefile
index 4fe92b1..3876d8c 100644
--- a/drivers/usb/gadget/Makefile
+++ b/drivers/usb/gadget/Makefile
@@ -49,6 +49,7 @@ g_dbgp-y			:= dbgp.o
 g_nokia-y			:= nokia.o
 g_webcam-y			:= webcam.o
 g_ncm-y				:= ncm.o
+g_acm_ms-y			:= acm_ms.o
 
 obj-$(CONFIG_USB_ZERO)		+= g_zero.o
 obj-$(CONFIG_USB_AUDIO)		+= g_audio.o
@@ -67,3 +68,4 @@ obj-$(CONFIG_USB_G_MULTI)	+= g_multi.o
 obj-$(CONFIG_USB_G_NOKIA)	+= g_nokia.o
 obj-$(CONFIG_USB_G_WEBCAM)	+= g_webcam.o
 obj-$(CONFIG_USB_G_NCM)		+= g_ncm.o
+obj-$(CONFIG_USB_G_ACM_MS)	+= g_acm_ms.o
diff --git a/drivers/usb/gadget/acm_ms.c b/drivers/usb/gadget/acm_ms.c
new file mode 100644
index 0000000..64d0f79
--- /dev/null
+++ b/drivers/usb/gadget/acm_ms.c
@@ -0,0 +1,269 @@
+/*
+ * cdc2.c -- CDC Composite driver, with ACM and mass storage support
+ *
+ * Copyright (C) 2008 David Brownell
+ * Copyright (C) 2008 Nokia Corporation
+ * Author: David Brownell
+ * Modified: Klaus Schwarzkopf
+ *
+ * Heavily based on multi.c and cdc2.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/utsname.h>
+
+#include "u_serial.h"
+
+
+#define DRIVER_DESC		"CDC Composite Gadget (ACM + MS)"
+#define DRIVER_VERSION		"2011/09/08"
+
+/*-------------------------------------------------------------------------*/
+
+/* DO NOT REUSE THESE IDs with a protocol-incompatible driver!!  Ever!!
+ * Instead:  allocate your own, using normal USB-IF procedures.
+ */
+#define CDC_VENDOR_NUM	0x1d6b	/* Linux Foundation */
+#define CDC_PRODUCT_NUM	0x0106	/* CDC Composite: ACM + MS*/
+
+/*-------------------------------------------------------------------------*/
+
+/*
+ * Kbuild is not very cooperative with respect to linking separately
+ * compiled library objects into one module.  So for now we won't use
+ * separate compilation ... ensuring init/exit sections work to shrink
+ * the runtime footprint, and giving us at least some parts of what
+ * a "gcc --combine ... part1.c part2.c part3.c ... " build would.
+ */
+
+#include "composite.c"
+#include "usbstring.c"
+#include "config.c"
+#include "epautoconf.c"
+#include "u_serial.c"
+#include "f_acm.c"
+#include "f_mass_storage.c"
+
+/*-------------------------------------------------------------------------*/
+
+static struct usb_device_descriptor device_desc = {
+	.bLength =		sizeof device_desc,
+	.bDescriptorType =	USB_DT_DEVICE,
+
+	.bcdUSB =		cpu_to_le16(0x0200),
+
+	.bDeviceClass =		USB_CLASS_COMM,
+	.bDeviceSubClass =	0,
+	.bDeviceProtocol =	0,
+	/* .bMaxPacketSize0 = f(hardware) */
+
+	/* Vendor and product id can be overridden by module parameters.  */
+	.idVendor =		cpu_to_le16(CDC_VENDOR_NUM),
+	.idProduct =		cpu_to_le16(CDC_PRODUCT_NUM),
+	/* .bcdDevice = f(hardware) */
+	/* .iManufacturer = DYNAMIC */
+	/* .iProduct = DYNAMIC */
+	/* NO SERIAL NUMBER */
+	.bNumConfigurations =	1,
+};
+
+static struct usb_otg_descriptor otg_descriptor = {
+	.bLength =		sizeof otg_descriptor,
+	.bDescriptorType =	USB_DT_OTG,
+
+	/* REVISIT SRP-only hardware is possible, although
+	 * it would not be called "OTG" ...
+	 */
+	.bmAttributes =		USB_OTG_SRP | USB_OTG_HNP,
+};
+
+static const struct usb_descriptor_header *otg_desc[] = {
+	(struct usb_descriptor_header *) &otg_descriptor,
+	NULL,
+};
+
+
+/* string IDs are assigned dynamically */
+
+#define STRING_MANUFACTURER_IDX		0
+#define STRING_PRODUCT_IDX		1
+
+static char manufacturer[50];
+
+static struct usb_string strings_dev[] = {
+	[STRING_MANUFACTURER_IDX].s = manufacturer,
+	[STRING_PRODUCT_IDX].s = DRIVER_DESC,
+	{  } /* end of list */
+};
+
+static struct usb_gadget_strings stringtab_dev = {
+	.language	= 0x0409,	/* en-us */
+	.strings	= strings_dev,
+};
+
+static struct usb_gadget_strings *dev_strings[] = {
+	&stringtab_dev,
+	NULL,
+};
+
+/****************************** Configurations ******************************/
+
+static struct fsg_module_parameters fsg_mod_data = { .stall = 1 };
+FSG_MODULE_PARAMETERS(/* no prefix */, fsg_mod_data);
+
+static struct fsg_common fsg_common;
+
+/*-------------------------------------------------------------------------*/
+
+/*
+ * We _always_ have both CDC ECM and CDC ACM functions.
+ */
+static int __init cdc_do_config(struct usb_configuration *c)
+{
+	int	status;
+
+	if (gadget_is_otg(c->cdev->gadget)) {
+		c->descriptors = otg_desc;
+		c->bmAttributes |= USB_CONFIG_ATT_WAKEUP;
+	}
+
+
+	status = acm_bind_config(c, 0);
+	if (status < 0)
+		return status;
+
+	status = fsg_bind_config(c->cdev, c, &fsg_common);
+	if (status < 0)
+		return status;
+
+	return 0;
+}
+
+static struct usb_configuration cdc_config_driver = {
+	.label			= DRIVER_DESC,
+	.bConfigurationValue	= 1,
+	/* .iConfiguration = DYNAMIC */
+	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
+};
+
+/*-------------------------------------------------------------------------*/
+
+static int __init cdc_bind(struct usb_composite_dev *cdev)
+{
+	int			gcnum;
+	struct usb_gadget	*gadget = cdev->gadget;
+	int			status;
+
+
+	/* set up serial link layer */
+	status = gserial_setup(cdev->gadget, 1);
+	if (status < 0)
+		return status;
+
+	/* set up mass storage function */
+	{
+		void *retp;
+		retp = fsg_common_from_params(&fsg_common, cdev, &fsg_mod_data);
+		if (IS_ERR(retp)) {
+			status = PTR_ERR(retp);
+			goto fail0;
+		}
+	}
+
+	gcnum = usb_gadget_controller_number(gadget);
+	if (gcnum >= 0)
+		device_desc.bcdDevice = cpu_to_le16(0x0300 | gcnum);
+	else {
+		/* We assume that can_support_ecm() tells the truth;
+		 * but if the controller isn't recognized at all then
+		 * that assumption is a bit more likely to be wrong.
+		 */
+		WARNING(cdev, "controller '%s' not recognized; trying %s\n",
+				gadget->name,
+				cdc_config_driver.label);
+		device_desc.bcdDevice =
+			cpu_to_le16(0x0300 | 0x0099);
+	}
+
+
+	/* Allocate string descriptor numbers ... note that string
+	 * contents can be overridden by the composite_dev glue.
+	 */
+
+	/* device descriptor strings: manufacturer, product */
+	snprintf(manufacturer, sizeof manufacturer, "%s %s with %s",
+		init_utsname()->sysname, init_utsname()->release,
+		gadget->name);
+	status = usb_string_id(cdev);
+	if (status < 0)
+		goto fail1;
+	strings_dev[STRING_MANUFACTURER_IDX].id = status;
+	device_desc.iManufacturer = status;
+
+	status = usb_string_id(cdev);
+	if (status < 0)
+		goto fail1;
+	strings_dev[STRING_PRODUCT_IDX].id = status;
+	device_desc.iProduct = status;
+
+	/* register our configuration */
+	status = usb_add_config(cdev, &cdc_config_driver, cdc_do_config);
+	if (status < 0)
+		goto fail1;
+
+	dev_info(&gadget->dev, "%s, version: " DRIVER_VERSION "\n",
+			DRIVER_DESC);
+	fsg_common_put(&fsg_common);
+	return 0;
+
+	/* error recovery */
+fail1:
+	fsg_common_put(&fsg_common);
+fail0:
+	gserial_cleanup();
+	return status;
+}
+
+static int __exit cdc_unbind(struct usb_composite_dev *cdev)
+{
+	gserial_cleanup();
+
+	return 0;
+}
+
+static struct usb_composite_driver cdc_driver = {
+	.name		= "g_acm_ms",
+	.dev		= &device_desc,
+	.strings	= dev_strings,
+	.unbind		= __exit_p(cdc_unbind),
+};
+
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_AUTHOR("Klaus Schwarzkopf");
+MODULE_LICENSE("GPL");
+
+static int __init init(void)
+{
+	return usb_composite_probe(&cdc_driver, cdc_bind);
+}
+module_init(init);
+
+static void __exit cleanup(void)
+{
+	usb_composite_unregister(&cdc_driver);
+}
+module_exit(cleanup);
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index dd1571d..f623f3d 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -15,6 +15,7 @@
 #ifndef __LINUX_USB_GADGET_H
 #define __LINUX_USB_GADGET_H
 
+#include <linux/device.h>
 #include <linux/slab.h>
 
 struct usb_ep;
-- 
1.7.0.4

