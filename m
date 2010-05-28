Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab0E1KCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 06:02:40 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:65148 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328Ab0E1KCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 06:02:12 -0400
Date: Fri, 28 May 2010 12:02:31 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv2 6/7] USB: gadget: g_multi: code clean up and refactoring
In-reply-to: <131cc4995ce27841167b6736acc52608c1bbe4b8.1275034701.git.mina86@mina86.com>
To: linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <2a0aef4e85af9cbc4b7b7034c8ef33a9fb4d68e4.1275034701.git.mina86@mina86.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1275034701.git.mina86@mina86.com>
 <dd6695f08a16b6e1269ea5c66bb16df4ba2d2e7b.1275034701.git.mina86@mina86.com>
 <55e838d52a2b4e37372e16d4238a82421fed11d6.1275034701.git.mina86@mina86.com>
 <e42e64aab3be6e8018f3b75f1f230ef7c3fbd481.1275034701.git.mina86@mina86.com>
 <87f7cc131d4f19eb5a0baf22cf9ce5ea2c739bb8.1275034701.git.mina86@mina86.com>
 <131cc4995ce27841167b6736acc52608c1bbe4b8.1275034701.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Multifunction Compasite Gadget have been cleaned up
and refactored so hopefully it looks prettier and works
at least as good as before changes.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/Kconfig |    1 +
 drivers/usb/gadget/multi.c |  262 +++++++++++++++++++++++++-------------------
 2 files changed, 148 insertions(+), 115 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 649c0c5..1a3270d 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -862,6 +862,7 @@ config USB_G_NOKIA
 config USB_G_MULTI
 	tristate "Multifunction Composite Gadget (EXPERIMENTAL)"
 	depends on BLOCK && NET
+	select USB_G_MULTI_CDC if ! USB_G_MULTI_RNDIS
 	help
 	  The Multifunction Composite Gadget provides Ethernet (RNDIS
 	  and/or CDC Ethernet), mass storage and ACM serial link
diff --git a/drivers/usb/gadget/multi.c b/drivers/usb/gadget/multi.c
index d3d3140..c7a5b58 100644
--- a/drivers/usb/gadget/multi.c
+++ b/drivers/usb/gadget/multi.c
@@ -24,6 +24,7 @@
 
 #include <linux/kernel.h>
 #include <linux/utsname.h>
+#include <linux/module.h>
 
 
 #if defined USB_ETH_RNDIS
@@ -35,14 +36,13 @@
 
 
 #define DRIVER_DESC		"Multifunction Composite Gadget"
-#define DRIVER_VERSION		"2009/07/21"
 
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
@@ -57,6 +57,8 @@
 #include "config.c"
 #include "epautoconf.c"
 
+#include "f_mass_storage.c"
+
 #include "u_serial.c"
 #include "f_acm.c"
 
@@ -68,13 +70,26 @@
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
+	__MULTI_NUM_CONFIGS_HELPER,
+	MULTI_NUM_CONFIGS = __MULTI_NUM_CONFIGS_HELPER - 1
+};
+
 
 static struct usb_device_descriptor device_desc = {
 	.bLength =		sizeof device_desc,
@@ -82,80 +97,81 @@ static struct usb_device_descriptor device_desc = {
 
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
+	.bNumConfigurations =	MULTI_NUM_CONFIGS,
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
+		/* REVISIT SRP-only hardware is possible, although
+		 * it would not be called "OTG" ... */
+		.bmAttributes =		USB_OTG_SRP | USB_OTG_HNP,
+	},
 	NULL,
 };
 
 
-/* string IDs are assigned dynamically */
-
-#define STRING_MANUFACTURER_IDX		0
-#define STRING_PRODUCT_IDX		1
+enum {
+	MULTI_STRING_MANUFACTURER_IDX,
+	MULTI_STRING_PRODUCT_IDX,
+#ifdef CONFIG_USB_G_MULTI_RNDIS
+	MULTI_STRING_RNDIS_CONFIG_IDX,
+#endif
+#ifdef CONFIG_USB_G_MULTI_CDC
+	MULTI_STRING_CDC_CONFIG_IDX,
+#endif
+};
 
 static char manufacturer[50];
 
 static struct usb_string strings_dev[] = {
-	[STRING_MANUFACTURER_IDX].s = manufacturer,
-	[STRING_PRODUCT_IDX].s = DRIVER_DESC,
+	[MULTI_STRING_MANUFACTURER_IDX].s = manufacturer,
+	[MULTI_STRING_PRODUCT_IDX].s      = DRIVER_DESC,
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
+
+static struct fsg_common fsg_common;
+
+static u8 hostaddr[ETH_ALEN];
 
-static struct fsg_common *fsg_common;
 
+/********** RNDIS **********/
 
 #ifdef USB_ETH_RNDIS
 
-static int __init rndis_do_config(struct usb_configuration *c)
+static __ref int rndis_do_config(struct usb_configuration *c)
 {
 	int ret;
 
@@ -172,26 +188,42 @@ static int __init rndis_do_config(struct usb_configuration *c)
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
 
@@ -208,20 +240,33 @@ static int __init cdc_do_config(struct usb_configuration *c)
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
 
@@ -230,7 +275,7 @@ static struct usb_configuration cdc_config_driver = {
 /****************************** Gadget Bind ******************************/
 
 
-static int __init multi_bind(struct usb_composite_dev *cdev)
+static int __ref multi_bind(struct usb_composite_dev *cdev)
 {
 	struct usb_gadget *gadget = cdev->gadget;
 	int status, gcnum;
@@ -252,67 +297,57 @@ static int __init multi_bind(struct usb_composite_dev *cdev)
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
 
+	/* allocate string descriptor numbers */
 
-	/* Allocate string descriptor numbers ... note that string
-	 * contents can be overridden by the composite_dev glue.
-	 */
-
-	/* device descriptor strings: manufacturer, product */
 	snprintf(manufacturer, sizeof manufacturer, "%s %s with %s",
 	         init_utsname()->sysname, init_utsname()->release,
 	         gadget->name);
-	status = usb_string_id(cdev);
-	if (status < 0)
-		goto fail2;
-	strings_dev[STRING_MANUFACTURER_IDX].id = status;
-	device_desc.iManufacturer = status;
 
-	status = usb_string_id(cdev);
-	if (status < 0)
+	status = usb_string_ids_tab(cdev, strings_dev);
+	if (unlikely(status < 0))
 		goto fail2;
-	strings_dev[STRING_PRODUCT_IDX].id = status;
-	device_desc.iProduct = status;
 
-#ifdef USB_ETH_RNDIS
-	/* register our first configuration */
-	status = usb_add_config(cdev, &rndis_config_driver);
-	if (status < 0)
+	device_desc.iManufacturer =
+		strings_dev[MULTI_STRING_MANUFACTURER_IDX].id;
+	device_desc.iProduct      =
+		strings_dev[MULTI_STRING_PRODUCT_IDX].id;
+
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
@@ -339,18 +374,15 @@ static struct usb_composite_driver multi_driver = {
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

