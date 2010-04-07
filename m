Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588Ab0DGNm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 09:42:28 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60839 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab0DGNmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 09:42:23 -0400
Date: Wed, 07 Apr 2010 15:41:32 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH 5/8] USB: g_ffs: the FunctionFS gadget driver
In-reply-to: <a5ed8238af68738effaf1610f4653d98b9435098.1270644740.git.mina86@mina86.com>
To: linux-usb@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>,
       Rupesh Gujare <rupeshgujare@gmail.com>, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>
Message-id: <922265f162fd3b45408c234d0d17e924b6f61671.1270644740.git.mina86@mina86.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1270644740.git.mina86@mina86.com>
 <033ad254a3bba337e7a37cc6071b7debc7051801.1270644740.git.mina86@mina86.com>
 <b866157fc128769a3cdf9ae76f9fc21743776778.1270644740.git.mina86@mina86.com>
 <d8e956ce78914750460877b87ba2b0f707ab8a0f.1270644740.git.mina86@mina86.com>
 <a5ed8238af68738effaf1610f4653d98b9435098.1270644740.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Function Filesystem (FunctioFS) lets one create USB
composite functions in user space in the same way as GadgetFS
lets one create USB gadgets in user space.  This allows
creation of composite gadgets such that some of the functions
are implemented in kernel space (for instance Ethernet, serial
or mass storage) and other are implemented in user space.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/usb/gadget/Kconfig  |   21 +++-
 drivers/usb/gadget/Makefile |    2 +
 drivers/usb/gadget/g_ffs.c  |  322 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 344 insertions(+), 1 deletions(-)
 create mode 100644 drivers/usb/gadget/g_ffs.c

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 11a3e0f..e71a730 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -710,6 +710,26 @@ config USB_GADGETFS
 	  Say "y" to link the driver statically, or "m" to build a
 	  dynamically linked module called "gadgetfs".
 
+config USB_FUNCTIONFS
+	tristate "Function Filesystem (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	help
+	  The Function Filesystem (FunctioFS) lets one create USB
+	  composite functions in user space in the same way as GadgetFS
+	  lets one create USB gadgets in user space.  This allows creation
+	  of composite gadgets such that some of the functions are
+	  implemented in kernel space (for instance Ethernet, serial or
+	  mass storage) and other are implemented in user space.
+
+	  Say "y" to link the driver statically, or "m" to build
+	  a dynamically linked module called "g_ffs".
+
+config USB_FUNCTIONFS_ETH
+	bool "Include Ethernet funcien"
+	depends on USB_FUNCTIONFS
+	help
+	  Include an Ethernet funcion in the Funcion Filesystem.
+
 config USB_FILE_STORAGE
 	tristate "File-backed Storage Gadget"
 	depends on BLOCK
@@ -863,7 +883,6 @@ config USB_G_MULTI_CDC
 
 	  If unsure, say "y".
 
-
 # put drivers that need isochronous transfer support (for audio
 # or video class gadget drivers), or specific hardware, here.
 
diff --git a/drivers/usb/gadget/Makefile b/drivers/usb/gadget/Makefile
index 43b51da..6d9d638 100644
--- a/drivers/usb/gadget/Makefile
+++ b/drivers/usb/gadget/Makefile
@@ -49,6 +49,8 @@ obj-$(CONFIG_USB_ZERO)		+= g_zero.o
 obj-$(CONFIG_USB_AUDIO)		+= g_audio.o
 obj-$(CONFIG_USB_ETH)		+= g_ether.o
 obj-$(CONFIG_USB_GADGETFS)	+= gadgetfs.o
+obj-$(CONFIG_USB_FUNCTIONFS)	+= g_ffs.o
+obj-$(CONFIG_USB_ETH_FUNCTIONFS)	+= g_eth_ffs.o
 obj-$(CONFIG_USB_FILE_STORAGE)	+= g_file_storage.o
 obj-$(CONFIG_USB_MASS_STORAGE)	+= g_mass_storage.o
 obj-$(CONFIG_USB_G_SERIAL)	+= g_serial.o
diff --git a/drivers/usb/gadget/g_ffs.c b/drivers/usb/gadget/g_ffs.c
new file mode 100644
index 0000000..6033f5d
--- /dev/null
+++ b/drivers/usb/gadget/g_ffs.c
@@ -0,0 +1,322 @@
+#include <linux/module.h>
+#include <linux/utsname.h>
+
+
+/*
+ * kbuild is not very cooperative with respect to linking separately
+ * compiled library objects into one module.  So for now we won't use
+ * separate compilation ... ensuring init/exit sections work to shrink
+ * the runtime footprint, and giving us at least some parts of what
+ * a "gcc --combine ... part1.c part2.c part3.c ... " build would.
+ */
+
+/* Do not mark any of the USB and composite initialization functions
+ * as __init, we use it after user space writes descriptors which is
+ * when init segments are removed. */
+#define USB_NO_INIT_SEGMENT 1
+/* Do not mark composite_unbind() and usb_composite_unregister() as
+ * __exit, we may need it even if we are not unloaded. */
+#define USB_NO_EXIT_SEGMENT 1
+
+#include "composite.c"
+#include "usbstring.c"
+#include "config.c"
+#include "epautoconf.c"
+
+#ifdef CONFIG_USB_FUNCTIONFS_ETH
+/* #  if defined USB_ETH_RNDIS */
+/* #    undef USB_ETH_RNDIS */
+/* #  endif */
+/* #  ifdef CONFIG_USB_ETH_FUNCTIONFS_RNDIS */
+/* #    define USB_ETH_RNDIS y */
+/* #  endif */
+#  include "u_ether.h"
+
+#  include "f_ecm.c"
+#  include "f_subset.c"
+/* #  ifdef USB_ETH_RNDIS */
+/* #    include "f_rndis.c" */
+/* #    include "rndis.c" */
+/* #  endif */
+#  include "u_ether.c"
+
+static u8 gfs_hostaddr[ETH_ALEN];
+#endif
+
+#include "f_fs.c"
+
+
+#define DRIVER_NAME	"g_ffs"
+#define DRIVER_DESC	"USB Function Filesystem"
+#define DRIVER_VERSION	"24 Aug 2004"
+
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_AUTHOR("Michal Nazarewicz");
+MODULE_LICENSE("GPL");
+
+
+static unsigned short gfs_vendor_id    = 0x0525;	/* XXX NetChip */
+static unsigned short gfs_product_id   = 0xa4ac;	/* XXX */
+
+static struct usb_device_descriptor gfs_dev_desc = {
+	.bLength		= sizeof gfs_dev_desc,
+	.bDescriptorType	= USB_DT_DEVICE,
+
+	.bcdUSB			= cpu_to_le16(0x0200),
+	.bDeviceClass		= USB_CLASS_PER_INTERFACE,
+
+	/* Vendor and product id can be overridden by module parameters.  */
+	/* .idVendor		= cpu_to_le16(gfs_vendor_id), */
+	/* .idProduct		= cpu_to_le16(gfs_product_id), */
+	/* .bcdDevice		= f(hardware) */
+	/* .iManufacturer	= DYNAMIC */
+	/* .iProduct		= DYNAMIC */
+	/* NO SERIAL NUMBER */
+	.bNumConfigurations	= 1,
+};
+
+#define GFS_MODULE_PARAM_DESC(name, field) \
+	MODULE_PARM_DESC(name, "Value of the " #field " field of the device descriptor sent to the host.  Takes effect only prior to the user-space driver registering to the FunctionFS.")
+
+module_param_named(usb_class,    gfs_dev_desc.bDeviceClass,    byte,   0644);
+GFS_MODULE_PARAM_DESC(usb_class, bDeviceClass);
+module_param_named(usb_subclass, gfs_dev_desc.bDeviceSubClass, byte,   0644);
+GFS_MODULE_PARAM_DESC(usb_subclass, bDeviceSubClass);
+module_param_named(usb_protocol, gfs_dev_desc.bDeviceProtocol, byte,   0644);
+GFS_MODULE_PARAM_DESC(usb_protocol, bDeviceProtocol);
+module_param_named(usb_vendor,   gfs_vendor_id,                ushort, 0644);
+GFS_MODULE_PARAM_DESC(usb_vendor, idVendor);
+module_param_named(usb_product,  gfs_product_id,               ushort, 0644);
+GFS_MODULE_PARAM_DESC(usb_product, idProduct);
+
+
+
+static const struct usb_descriptor_header *gfs_otg_desc[] = {
+	(const struct usb_descriptor_header *)
+	&(const struct usb_otg_descriptor) {
+		.bLength		= sizeof(struct usb_otg_descriptor),
+		.bDescriptorType	= USB_DT_OTG,
+
+		/* REVISIT SRP-only hardware is possible, although
+		 * it would not be called "OTG" ... */
+		.bmAttributes		= USB_OTG_SRP | USB_OTG_HNP,
+	},
+
+	NULL
+};
+
+/* string IDs are assigned dynamically */
+
+enum {
+	GFS_STRING_MANUFACTURER_IDX,
+	GFS_STRING_PRODUCT_IDX,
+	GFS_STRING_CONFIGURATION_IDX
+};
+
+static       char gfs_manufacturer[50];
+static const char gfs_driver_desc[] = DRIVER_DESC;
+static const char gfs_short_name[]  = DRIVER_NAME;
+
+static struct usb_string gfs_strings[] = {
+	[GFS_STRING_MANUFACTURER_IDX].s = gfs_manufacturer,
+	[GFS_STRING_PRODUCT_IDX].s = gfs_driver_desc,
+	[GFS_STRING_CONFIGURATION_IDX].s = "Self Powered",
+	{  } /* end of list */
+};
+
+static struct usb_gadget_strings *gfs_dev_strings[] = {
+	&(struct usb_gadget_strings) {
+		.language	= 0x0409,	/* en-us */
+		.strings	= gfs_strings,
+	},
+	NULL,
+};
+
+
+static int gfs_bind(struct usb_composite_dev *cdev);
+static int gfs_unbind(struct usb_composite_dev *cdev);
+static int gfs_do_config(struct usb_configuration *c);
+
+
+static struct usb_composite_driver gfs_driver = {
+	.name		= gfs_short_name,
+	.dev		= &gfs_dev_desc,
+	.strings	= gfs_dev_strings,
+	.bind		= gfs_bind,
+	.unbind		= gfs_unbind,
+};
+
+static struct usb_configuration gfs_config_driver = {
+	.label			= "FunctionFS",
+	.bind			= gfs_do_config,
+	.bConfigurationValue	= 1,
+	/* .iConfiguration	= DYNAMIC */
+	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
+};
+
+
+static struct ffs_data *gfs_ffs_data;
+static unsigned long gfs_registered;
+
+
+static int __init gfs_init(void)
+{
+	ENTER();
+
+	return functionfs_init();
+}
+module_init(gfs_init);
+
+static void __exit gfs_exit(void)
+{
+	ENTER();
+
+	if (test_and_clear_bit(0, &gfs_registered))
+		usb_composite_unregister(&gfs_driver);
+
+	functionfs_cleanup();
+}
+module_exit(gfs_exit);
+
+
+static int functionfs_ready_callback(struct ffs_data *ffs)
+{
+	int ret;
+
+	ENTER();
+
+	if (WARN_ON(test_and_set_bit(0, &gfs_registered)))
+		return -EBUSY;
+
+	gfs_ffs_data = ffs;
+	ret = usb_composite_register(&gfs_driver);
+	if (unlikely(ret < 0))
+		clear_bit(0, &gfs_registered);
+	return ret;
+}
+
+static void functionfs_closed_callback(struct ffs_data *ffs)
+{
+	ENTER();
+
+	if (test_and_clear_bit(0, &gfs_registered))
+		usb_composite_unregister(&gfs_driver);
+}
+
+
+static int functionfs_check_dev_callback(const char *dev_name)
+{
+	return 0;
+}
+
+
+
+static int gfs_bind(struct usb_composite_dev *cdev)
+{
+	int ret;
+
+	ENTER();
+
+	if (WARN_ON(!gfs_ffs_data))
+		return -ENODEV;
+
+#ifdef CONFIG_USB_FUNCTIONFS_ETH
+	ret = gether_setup(cdev->gadget, gfs_hostaddr);
+	if (unlikely(ret < 0))
+		goto error_quick;
+#endif
+
+	gfs_dev_desc.idVendor  = cpu_to_le16(gfs_vendor_id);
+	gfs_dev_desc.idProduct = cpu_to_le16(gfs_product_id);
+
+	snprintf(gfs_manufacturer, sizeof gfs_manufacturer, "%s %s with %s",
+		 init_utsname()->sysname, init_utsname()->release,
+		 cdev->gadget->name);
+	ret = usb_string_id(cdev);
+	if (unlikely(ret < 0))
+		goto error;
+	gfs_strings[GFS_STRING_MANUFACTURER_IDX].id = ret;
+	gfs_dev_desc.iManufacturer = ret;
+
+	ret = usb_string_id(cdev);
+	if (unlikely(ret < 0))
+		goto error;
+	gfs_strings[GFS_STRING_PRODUCT_IDX].id = ret;
+	gfs_dev_desc.iProduct = ret;
+
+	ret = usb_string_id(cdev);
+	if (unlikely(ret < 0))
+		goto error;
+	gfs_strings[GFS_STRING_CONFIGURATION_IDX].id = ret;
+	gfs_config_driver.iConfiguration = ret;
+
+	ret = functionfs_bind(gfs_ffs_data, cdev);
+	if (unlikely(ret < 0))
+		goto error;
+
+	ret = usb_add_config(cdev, &gfs_config_driver);
+	if (unlikely(ret < 0))
+		goto error_unbind;
+
+	return 0;
+
+error_unbind:
+	functionfs_unbind(gfs_ffs_data);
+error:
+#ifdef CONFIG_USB_FUNCTIONFS_ETH
+	gether_cleanup();
+error_quick:
+#endif
+	gfs_ffs_data = NULL;
+	return ret;
+}
+
+static int gfs_unbind(struct usb_composite_dev *cdev)
+{
+	ENTER();
+
+#ifdef CONFIG_USB_FUNCTIONFS_ETH
+	gether_cleanup();
+#endif
+
+	if (!WARN_ON(!gfs_ffs_data)) {
+		functionfs_unbind(gfs_ffs_data);
+		gfs_ffs_data = NULL;
+	}
+
+	return 0;
+}
+
+
+static int gfs_do_config(struct usb_configuration *c)
+{
+	int ret;
+
+	ENTER();
+
+	if (WARN_ON(!gfs_ffs_data))
+		return -ENODEV;
+
+	if (gadget_is_otg(c->cdev->gadget)) {
+		c->descriptors = gfs_otg_desc;
+		c->bmAttributes |= USB_CONFIG_ATT_WAKEUP;
+	}
+
+#ifdef CONFIG_USB_FUNCTIONFS_ETH
+	if (can_support_ecm(c->cdev->gadget)) {
+		FINFO("ecm_bind_config");
+		ret = ecm_bind_config(c, gfs_hostaddr);
+	} else {
+		FINFO("geth_bind_config");
+		ret = geth_bind_config(c, gfs_hostaddr);
+	}
+	if (unlikely(ret < 0))
+		return ret;
+#endif
+
+	ret = functionfs_add(c->cdev, c, gfs_ffs_data);
+	if (unlikely(ret < 0))
+		return ret;
+
+	return 0;
+}
-- 
1.7.0

