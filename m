Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab0GHUvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:51:22 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:10875 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab0GHUvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:51:17 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 08 Jul 2010 22:52:28 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv3 3/3] USB: gadget: g_multi: code clean up and refactoring
In-reply-to: <d11707c57b68ae8112c3fd0de4eab9fcde8cb760.1278619472.git.m.nazarewicz@samsung.com>
To: m.nazarewicz@samsung.com
Cc: mina86@mina86.com, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Message-id: <5b8eb066aca09cc80f392240044799d84fb57c72.1278619472.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <20100708183425.GB31823@kroah.com>
 <e2d14d0a730dde4b716c0e086761ef65ba9afda8.1278619472.git.m.nazarewicz@samsung.com>
 <d11707c57b68ae8112c3fd0de4eab9fcde8cb760.1278619472.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Multifunction Composite Gadget have been cleaned up
and refactored so hopefully it looks prettier and works
at least as good as before changes.

A Kconfig has also been fixed to make it impossible to build
FunctionFS gadget with no configurations.  With this patch, if
RNDIS is not chosen by the user CDC is force-selected.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/Kconfig |    1 +
 drivers/usb/gadget/multi.c |  274 ++++++++++++++++++++++++--------------------
 2 files changed, 152 insertions(+), 123 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 591ae9f..027f61b 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -863,6 +863,7 @@ config USB_G_NOKIA
 config USB_G_MULTI
 	tristate "Multifunction Composite Gadget (EXPERIMENTAL)"
 	depends on BLOCK && NET
+	select USB_G_MULTI_CDC if !USB_G_MULTI_RNDIS
 	help
 	  The Multifunction Composite Gadget provides Ethernet (RNDIS
 	  and/or CDC Ethernet), mass storage and ACM serial link
diff --git a/drivers/usb/gadget/multi.c b/drivers/usb/gadget/multi.c
index 777fdbf..eef7336 100644
--- a/drivers/usb/gadget/multi.c
+++ b/drivers/usb/gadget/multi.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2008 David Brownell
  * Copyright (C) 2008 Nokia Corporation
- * Copyright (C) 2009 Samsung Electronics
+ * Copyright (C) 2009-2010 Samsung Electronics
  * Author: Michal Nazarewicz (m.nazarewicz@samsung.com)
  *
  * This program is free software; you can redistribute it and/or modify
@@ -24,6 +24,7 @@
 
 #include <linux/kernel.h>
 #include <linux/utsname.h>
+#include <linux/module.h>
 
 
 #if defined USB_ETH_RNDIS
@@ -35,14 +36,14 @@
 
 
 #define DRIVER_DESC		"Multifunction Composite Gadget"
-#define DRIVER_VERSION		"2009/07/21"
+#define DRIVER_VERSION		"2010/07/01"
 
-/*-------------------------------------------------------------------------*/
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_AUTHOR("Michal Nazarewicz");
+MODULE_LICENSE("GPL");
 
-#define MULTI_VENDOR_NUM	0x0525	/* XXX NetChip */
-#define MULTI_PRODUCT_NUM	0xa4ab	/* XXX */
 
-/*-------------------------------------------------------------------------*/
+/***************************** All the files... *****************************/
 
 /*
  * kbuild is not very cooperative with respect to linking separately
@@ -57,6 +58,8 @@
 #include "config.c"
 #include "epautoconf.c"
 
+#include "f_mass_storage.c"
+
 #include "u_serial.c"
 #include "f_acm.c"
 
@@ -68,13 +71,24 @@
 #endif
 #include "u_ether.c"
 
-#undef DBG     /* u_ether.c has broken idea about macros */
-#undef VDBG    /* so clean up after it */
-#undef ERROR
-#undef INFO
-#include "f_mass_storage.c"
 
-/*-------------------------------------------------------------------------*/
+
+/***************************** Device Descriptor ****************************/
+
+#define MULTI_VENDOR_NUM	0x0525	/* XXX NetChip */
+#define MULTI_PRODUCT_NUM	0xa4ab	/* XXX */
+
+
+enum {
+	__MULTI_NO_CONFIG,
+#ifdef CONFIG_USB_G_MULTI_RNDIS
+	MULTI_RNDIS_CONFIG_NUM,
+#endif
+#ifdef CONFIG_USB_G_MULTI_CDC
+	MULTI_CDC_CONFIG_NUM,
+#endif
+};
+
 
 static struct usb_device_descriptor device_desc = {
 	.bLength =		sizeof device_desc,
@@ -82,83 +96,87 @@ static struct usb_device_descriptor device_desc = {
 
 	.bcdUSB =		cpu_to_le16(0x0200),
 
-	/* .bDeviceClass =		USB_CLASS_COMM, */
-	/* .bDeviceSubClass =	0, */
-	/* .bDeviceProtocol =	0, */
-	.bDeviceClass =		0xEF,
+	.bDeviceClass =		USB_CLASS_MISC /* 0xEF */,
 	.bDeviceSubClass =	2,
 	.bDeviceProtocol =	1,
-	/* .bMaxPacketSize0 = f(hardware) */
 
 	/* Vendor and product id can be overridden by module parameters.  */
 	.idVendor =		cpu_to_le16(MULTI_VENDOR_NUM),
 	.idProduct =		cpu_to_le16(MULTI_PRODUCT_NUM),
-	/* .bcdDevice = f(hardware) */
-	/* .iManufacturer = DYNAMIC */
-	/* .iProduct = DYNAMIC */
-	/* NO SERIAL NUMBER */
-	.bNumConfigurations =	1,
 };
 
-static struct usb_otg_descriptor otg_descriptor = {
-	.bLength =		sizeof otg_descriptor,
-	.bDescriptorType =	USB_DT_OTG,
-
-	/* REVISIT SRP-only hardware is possible, although
-	 * it would not be called "OTG" ...
-	 */
-	.bmAttributes =		USB_OTG_SRP | USB_OTG_HNP,
-};
 
 static const struct usb_descriptor_header *otg_desc[] = {
-	(struct usb_descriptor_header *) &otg_descriptor,
+	(struct usb_descriptor_header *) &(struct usb_otg_descriptor){
+		.bLength =		sizeof(struct usb_otg_descriptor),
+		.bDescriptorType =	USB_DT_OTG,
+
+		/*
+		 * REVISIT SRP-only hardware is possible, although
+		 * it would not be called "OTG" ...
+		 */
+		.bmAttributes =		USB_OTG_SRP | USB_OTG_HNP,
+	},
 	NULL,
 };
 
 
 /* string IDs are assigned dynamically */
 
-#define STRING_MANUFACTURER_IDX		0
-#define STRING_PRODUCT_IDX		1
-#define STRING_SERIAL_IDX		2
+enum {
+	MULTI_STRING_MANUFACTURER_IDX,
+	MULTI_STRING_PRODUCT_IDX,
+	MULTI_STRING_SERIAL_IDX,
+#ifdef CONFIG_USB_G_MULTI_RNDIS
+	MULTI_STRING_RNDIS_CONFIG_IDX,
+#endif
+#ifdef CONFIG_USB_G_MULTI_CDC
+	MULTI_STRING_CDC_CONFIG_IDX,
+#endif
+};
 
 static char manufacturer[50];
 static char serial[13];
 
 static struct usb_string strings_dev[] = {
-	[STRING_MANUFACTURER_IDX].s = manufacturer,
-	[STRING_PRODUCT_IDX].s = DRIVER_DESC,
-	[STRING_SERIAL_IDX].s = serial,
+	[MULTI_STRING_MANUFACTURER_IDX].s = manufacturer,
+	[MULTI_STRING_PRODUCT_IDX].s      = DRIVER_DESC,
+	[MULTI_STRING_SERIAL_IDX].s       = serial,
+#ifdef CONFIG_USB_G_MULTI_RNDIS
+	[MULTI_STRING_RNDIS_CONFIG_IDX].s = "Multifunction with RNDIS",
+#endif
+#ifdef CONFIG_USB_G_MULTI_CDC
+	[MULTI_STRING_CDC_CONFIG_IDX].s   = "Multifunction with CDC ECM",
+#endif
 	{  } /* end of list */
 };
 
-static struct usb_gadget_strings stringtab_dev = {
-	.language	= 0x0409,	/* en-us */
-	.strings	= strings_dev,
-};
-
 static struct usb_gadget_strings *dev_strings[] = {
-	&stringtab_dev,
+	&(struct usb_gadget_strings){
+		.language	= 0x0409,	/* en-us */
+		.strings	= strings_dev,
+	},
 	NULL,
 };
 
-static u8 hostaddr[ETH_ALEN];
 
 
 
 /****************************** Configurations ******************************/
 
-static struct fsg_module_parameters mod_data = {
-	.stall = 1
-};
-FSG_MODULE_PARAMETERS(/* no prefix */, mod_data);
+static struct fsg_module_parameters fsg_mod_data = { .stall = 1 };
+FSG_MODULE_PARAMETERS(/* no prefix */, fsg_mod_data);
 
-static struct fsg_common *fsg_common;
+static struct fsg_common fsg_common;
 
+static u8 hostaddr[ETH_ALEN];
+
+
+/********** RNDIS **********/
 
 #ifdef USB_ETH_RNDIS
 
-static int __init rndis_do_config(struct usb_configuration *c)
+static __ref int rndis_do_config(struct usb_configuration *c)
 {
 	int ret;
 
@@ -175,26 +193,42 @@ static int __init rndis_do_config(struct usb_configuration *c)
 	if (ret < 0)
 		return ret;
 
-	ret = fsg_bind_config(c->cdev, c, fsg_common);
+	ret = fsg_bind_config(c->cdev, c, &fsg_common);
 	if (ret < 0)
 		return ret;
 
 	return 0;
 }
 
-static struct usb_configuration rndis_config_driver = {
-	.label			= "Multifunction Composite (RNDIS + MS + ACM)",
-	.bind			= rndis_do_config,
-	.bConfigurationValue	= 2,
-	/* .iConfiguration = DYNAMIC */
-	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
-};
+static int rndis_config_register(struct usb_composite_dev *cdev)
+{
+	static struct usb_configuration config = {
+		.bind			= rndis_do_config,
+		.bConfigurationValue	= MULTI_RNDIS_CONFIG_NUM,
+		.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
+	};
+
+	config.label          = strings_dev[MULTI_STRING_RNDIS_CONFIG_IDX].s;
+	config.iConfiguration = strings_dev[MULTI_STRING_RNDIS_CONFIG_IDX].id;
+
+	return usb_add_config(cdev, &config);
+}
+
+#else
+
+static int rndis_config_register(struct usb_composite_dev *cdev)
+{
+	return 0;
+}
 
 #endif
 
+
+/********** CDC ECM **********/
+
 #ifdef CONFIG_USB_G_MULTI_CDC
 
-static int __init cdc_do_config(struct usb_configuration *c)
+static __ref int cdc_do_config(struct usb_configuration *c)
 {
 	int ret;
 
@@ -211,20 +245,33 @@ static int __init cdc_do_config(struct usb_configuration *c)
 	if (ret < 0)
 		return ret;
 
-	ret = fsg_bind_config(c->cdev, c, fsg_common);
+	ret = fsg_bind_config(c->cdev, c, &fsg_common);
 	if (ret < 0)
 		return ret;
 
 	return 0;
 }
 
-static struct usb_configuration cdc_config_driver = {
-	.label			= "Multifunction Composite (CDC + MS + ACM)",
-	.bind			= cdc_do_config,
-	.bConfigurationValue	= 1,
-	/* .iConfiguration = DYNAMIC */
-	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
-};
+static int cdc_config_register(struct usb_composite_dev *cdev)
+{
+	static struct usb_configuration config = {
+		.bind			= cdc_do_config,
+		.bConfigurationValue	= MULTI_CDC_CONFIG_NUM,
+		.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
+	};
+
+	config.label          = strings_dev[MULTI_STRING_CDC_CONFIG_IDX].s;
+	config.iConfiguration = strings_dev[MULTI_STRING_CDC_CONFIG_IDX].id;
+
+	return usb_add_config(cdev, &config);
+}
+
+#else
+
+static int cdc_config_register(struct usb_composite_dev *cdev)
+{
+	return 0;
+}
 
 #endif
 
@@ -233,7 +280,7 @@ static struct usb_configuration cdc_config_driver = {
 /****************************** Gadget Bind ******************************/
 
 
-static int __init multi_bind(struct usb_composite_dev *cdev)
+static int __ref multi_bind(struct usb_composite_dev *cdev)
 {
 	struct usb_gadget *gadget = cdev->gadget;
 	int status, gcnum;
@@ -255,76 +302,60 @@ static int __init multi_bind(struct usb_composite_dev *cdev)
 		goto fail0;
 
 	/* set up mass storage function */
-	fsg_common = fsg_common_from_params(0, cdev, &mod_data);
-	if (IS_ERR(fsg_common)) {
-		status = PTR_ERR(fsg_common);
-		goto fail1;
+	{
+		void *retp;
+		retp = fsg_common_from_params(&fsg_common, cdev, &fsg_mod_data);
+		if (IS_ERR(retp)) {
+			status = PTR_ERR(retp);
+			goto fail1;
+		}
 	}
 
-
+	/* set bcdDevice */
 	gcnum = usb_gadget_controller_number(gadget);
-	if (gcnum >= 0)
+	if (gcnum >= 0) {
 		device_desc.bcdDevice = cpu_to_le16(0x0300 | gcnum);
-	else {
-		/* We assume that can_support_ecm() tells the truth;
-		 * but if the controller isn't recognized at all then
-		 * that assumption is a bit more likely to be wrong.
-		 */
-		WARNING(cdev, "controller '%s' not recognized\n",
-		        gadget->name);
+	} else {
+		WARNING(cdev, "controller '%s' not recognized\n", gadget->name);
 		device_desc.bcdDevice = cpu_to_le16(0x0300 | 0x0099);
 	}
 
-
-	/* Allocate string descriptor numbers ... note that string
-	 * contents can be overridden by the composite_dev glue.
-	 */
-
-	/* device descriptor strings: manufacturer, product */
+	/* allocate string descriptor numbers */
 	snprintf(manufacturer, sizeof manufacturer, "%s %s with %s",
 	         init_utsname()->sysname, init_utsname()->release,
 	         gadget->name);
 
 	fsg_string_serial_fill(serial, DRIVER_VERSION);
 
-	status = usb_string_id(cdev);
-	if (status < 0)
-		goto fail2;
-	strings_dev[STRING_MANUFACTURER_IDX].id = status;
-	device_desc.iManufacturer = status;
-
-	status = usb_string_id(cdev);
-	if (status < 0)
+	status = usb_string_ids_tab(cdev, strings_dev);
+	if (unlikely(status < 0))
 		goto fail2;
-	strings_dev[STRING_PRODUCT_IDX].id = status;
-	device_desc.iProduct = status;
 
-	status = usb_string_id(cdev);
-	if (status < 0)
-		goto fail2;
-	strings_dev[STRING_SERIAL_IDX].id = status;
-	device_desc.iSerialNumber = status;
+	device_desc.iManufacturer =
+		strings_dev[MULTI_STRING_MANUFACTURER_IDX].id;
+	device_desc.iProduct      =
+		strings_dev[MULTI_STRING_PRODUCT_IDX].id;
+	device_desc.iSerialNumber =
+		strings_dev[MULTI_STRING_SERIAL_IDX].id;
 
-#ifdef USB_ETH_RNDIS
-	/* register our first configuration */
-	status = usb_add_config(cdev, &rndis_config_driver);
-	if (status < 0)
+	/* register configurations */
+	status = rndis_config_register(cdev);
+	if (unlikely(status < 0))
 		goto fail2;
-#endif
 
-#ifdef CONFIG_USB_G_MULTI_CDC
-	/* register our second configuration */
-	status = usb_add_config(cdev, &cdc_config_driver);
-	if (status < 0)
+	status = cdc_config_register(cdev);
+	if (unlikely(status < 0))
 		goto fail2;
-#endif
 
-	dev_info(&gadget->dev, DRIVER_DESC ", version: " DRIVER_VERSION "\n");
-	fsg_common_put(fsg_common);
+	/* we're done */
+	dev_info(&gadget->dev, DRIVER_DESC "\n");
+	fsg_common_put(&fsg_common);
 	return 0;
 
+
+	/* error recovery */
 fail2:
-	fsg_common_put(fsg_common);
+	fsg_common_put(&fsg_common);
 fail1:
 	gserial_cleanup();
 fail0:
@@ -351,18 +382,15 @@ static struct usb_composite_driver multi_driver = {
 	.unbind		= __exit_p(multi_unbind),
 };
 
-MODULE_DESCRIPTION(DRIVER_DESC);
-MODULE_AUTHOR("Michal Nazarewicz");
-MODULE_LICENSE("GPL");
 
-static int __init g_multi_init(void)
+static int __init multi_init(void)
 {
 	return usb_composite_register(&multi_driver);
 }
-module_init(g_multi_init);
+module_init(multi_init);
 
-static void __exit g_multi_cleanup(void)
+static void __exit multi_exit(void)
 {
 	usb_composite_unregister(&multi_driver);
 }
-module_exit(g_multi_cleanup);
+module_exit(multi_exit);
-- 
1.7.1

