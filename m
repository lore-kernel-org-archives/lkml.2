Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab0GAJRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 05:17:08 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51113 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619Ab0GAJQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 05:16:59 -0400
Date: Thu, 01 Jul 2010 11:17:43 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH/RFC 2/2] USB: gadget: g_experimantal: Experimental Composite
 Gadget
In-reply-to: <c3daa3e80cab0d62c91c9792e9b696ce3cbe918b.1277902597.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <800647e5de785f0d42a47fccee984ef2dd56651b.1277902597.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1277972135.git.mina86@mina86.com>
 <c3daa3e80cab0d62c91c9792e9b696ce3cbe918b.1277902597.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new composite gadget introduced: Experimental Composite Gadget.
It is intended for developing new features and testing different
configuration and not for production use (unless you want to).

It uses the same vendor and product ID as g_multi since in default
configuration it is identical to g_multi.  After custamizing one
should consider changing ID.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/usb/gadget_experimental.txt |   76 +++
 drivers/usb/gadget/Kconfig                |  146 +++++
 drivers/usb/gadget/Makefile               |    2 +-
 drivers/usb/gadget/g_experimental.c       |  840 +++++++++++++++++++++++++++++
 4 files changed, 1063 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/usb/gadget_experimental.txt
 create mode 100644 drivers/usb/gadget/g_experimental.c

diff --git a/Documentation/usb/gadget_experimental.txt b/Documentation/usb/gadget_experimental.txt
new file mode 100644
index 0000000..e976666
--- /dev/null
+++ b/Documentation/usb/gadget_experimental.txt
@@ -0,0 +1,76 @@
+                                                             -*- org -*-
+
+* Overview
+
+The Experimental Composite Gadget (or g_experimental) is a highly
+customisable composite gadget intended as a playground for developing
+new gadget and new gadget functionalities.
+
+It is a fork of the Multifunction Composite Gadget (g_multi) created
+after it has became obvious that adding new features to g_multi will
+make it too complex.
+
+As a for of g_multi, most if not all documentation from
+[[gadget_multi.txt]] apply to g_experimental as well.
+
+In addition to what g_multi supports, g_experimental provides full
+customisation via Kconfig option (you can select each function as well
+as specify default vendor and product ID), integration with FunctionFS
+and install mode which you may also call NoCD ore ZereCD (expect the
+later is a trademark).
+
+Please not that if you use non-standard configuration you may need to
+change vendor and/or product ID.
+
+* Install mode
+
+The install mode makes the gadget appear as a plain mass storage
+device the first time it is connected (and after each disconnect).
+This lets one develop an "autorun" CD-ROM image with drivers and put
+it as the first logical unit.
+
+** Workings of the install mode
+
+As you may know, mass storage gadget may provide several logical units
+and its easier to think of them as separate drives.  When install mode
+is enabled, g_multi forces the first logical unit to be a read-only
+CD-ROM.  When install mode is enabled but mass storage itself is not
+then exactly one logical unit is set.
+
+When an eject request is made on that logical unit, the file is not
+really closed but the gadget switches it's mode to the full flagged
+gadget with all the other functions.  If mass storage is among them,
+the firs logical unit will be the CD-ROM image with drivers (which may
+be seen as a bad thing).
+
+When gadget is disconnected and connected afterwards it will work
+again in install mode.  Some heuristics are used here -- if
+disconnection (or suspend) happens no longer then 10 seconds after
+last eject on the first logical unit then on next enumeration gadget
+will claim to be full flagged otherwise it'll stick to install mode.
+
+** Interoperability with host
+
+As said, the idea behind install mode is that hosts that require
+drivers will be able to get them without the need for additional
+CD-ROM or another medium provided with the device.
+
+CD-ROM image should provide an "autorun" functionality witch will
+install drivers and eject the emulated CD-ROM to switch gadget into
+the other mode which will be handled by newly installed drivers.  If
+drivers are installed already, they should "catch" the install mode
+device by product and vendor IDs and issue an eject.
+
+This mode is not very Linux-friendly though since Linux and Linux
+based systems have no notion of autorun (which from security point of
+view is a good thing) and there's no way of adding some file on the
+image which will make gadget eject the device.
+
+Fortunately, there's USB_ModeSwitch[9] and/or udev[10] which
+should handle it just fine.  A single rule need to be added and
+everything should work fine.
+
+* Authors
+
+This document has been written by Michal Nazarewicz
+([[mailto:mina86@mina86.com]]).  Send all complains there...
diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index fc55eff..d534cc8 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -964,6 +964,152 @@ config USB_G_WEBCAM
 	  Say "y" to link the driver statically, or "m" to build a
 	  dynamically linked module called "g_webcam".
 
+config USB_G_EXPERIMENTAL
+	tristate "Experimental Composite Gadget (DEVELOPMENT) (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	select USB_G_EXPERIMENTAL_ACM if !USB_G_EXPERIMENTAL_ANYTHING
+	help
+	  The Experimental Composite Gadget provides several different
+	  configurations and functions.  It is intended as a playground
+	  for any new functionalities for composite gadgets or framework
+	  as well as for tweaking a gadget configuration before developing
+	  a final gadget.
+
+	  It is not intended for production use unless you test it and
+	  decide that it suits your needs -- it's your call.  It is a fork
+	  of less complex Multifunction Composite Gadget.
+
+	  Say "y" to link the driver statically, or "m" to build
+	  a dynamically linked module called "g_experimental".  If unsure,
+	  say "n".
+
+config USB_G_EXPERIMENTAL_ANYTHING
+	bool
+	depends on USB_G_EXPERIMENTAL
+
+config USB_G_EXPERIMENTAL_VENDOR
+	hex "Default Vendor ID"
+	depends on USB_G_EXPERIMENTAL
+	range 0 ffff
+	default 0x0525
+	help
+	  The default vendor ID to use with the gadget.  This can be
+	  overridden by module parameters.  By default it is 0x0525 which
+	  is vendor ID of NetChip who donated some product IDs to Linux.
+
+	  Linux Foundation ID is 0x1d6b.  For in house testing you may use
+	  some unused vendor ID like 0xffff.
+
+	  You should of course consult with product ID owner before using
+	  their ID.
+
+config USB_G_EXPERIMENTAL_PRODUCT
+	hex "Default Product ID"
+	depends on USB_G_EXPERIMENTAL
+	range 0 0xffff
+	default 0xa4ab
+	help
+	  The default product ID to use with the gadget.  This can be
+	  overridden by module parameters.  By default it is 0xa4ab which
+	  is the same as for Multifunction Composite Gadget.
+
+	  When customising and testing you should consider using
+	  different product IDs for different versions of this gadget.
+
+config USB_G_EXPERIMENTAL_RNDIS
+	bool "Include RNDIS function"
+	depends on USB_G_EXPERIMENTAL && NET
+	select USB_G_EXPERIMENTAL_ANYTHING
+	default y
+	help
+	  This option enables the RNDIS (Ethernet) function.  It is
+	  protocol dedicated for Windows since it's Microsoft's invention.
+
+	  If you select also CDC ECM function gadget will have two
+	  configurations one with RNDIS and another with CDC ECM.
+
+	  If unsure, say "y".
+
+config USB_G_EXPERIMENTAL_ECM
+	bool "Include CDC ECM function"
+	depends on USB_G_EXPERIMENTAL && NET
+	select USB_G_EXPERIMENTAL_ANYTHING
+	help
+	  This option enables the CDC ECM (Ethernet) function.
+
+	  If you select also RNDIS function gadget will have two
+	  configurations one with RNDIS and another with CDC ECM.
+
+	  If unsure, say "y".
+
+config USB_G_EXPERIMENTAL_ACM
+	bool "Include CDC ACM function"
+	depends on USB_G_EXPERIMENTAL
+	default y
+	help
+	  This option enables the CDC ACM (serial) function.
+
+	  If unsure, say "y".
+
+config USB_G_EXPERIMENTAL_MSF
+	bool "Include mass storage function"
+	depends on USB_G_EXPERIMENTAL && BLOCK
+	select USB_G_EXPERIMENTAL_ANYTHING
+	default y
+	help
+	  This option enables the mass storage (or UMS) function.
+
+	  If unsure, say "y".
+
+config USB_G_EXPERIMENTAL_FFS
+	bool "Include FunctionFS"
+	depends on USB_G_EXPERIMENTAL
+	default n
+	help
+	  This option enables the FunctionFS interface.
+
+	  If unsure, say "y".
+
+config USB_G_EXPERIMENTAL_FFS_PRODUCT
+	hex "Default Product ID for mode with FunctionFS"
+	depends on USB_G_EXPERIMENTAL_FFS
+	range 0 0xffff
+	default 0xa4ae
+	help
+	  The default product ID to use with the gadget when FunctionFS is
+	  enabled.  By default it is 0xa4ae.
+
+config USB_G_EXPERIMENTAL_INSTALL
+	bool "Install Mode"
+	depends on USB_G_EXPERIMENTAL && BLOCK
+	default n
+	help
+	  This option enables an "Install Mode" configuration.  You may
+	  also refer to in as NoCD or ZeroCD (although the later is
+	  a trademark).
+
+	  This mode makes gadget appear as an USB Mass Storage device
+	  emulating a CD-ROM the first time it is connected.  The intend
+	  is that you can put drivers for your gadget on the disk image.
+
+	  When eject request is sent to the logical translation unit
+	  gadget switches its mode to the full flagged gadget with all the
+	  other functions.
+
+	  When device is disconnected, gadget once again switches to the
+	  Install Mode configuration.
+
+	  If unsure, say "n".
+
+config USB_G_EXPERIMENTAL_INSTALL_PRODUCT
+	hex "Default Product ID for intstall mode"
+	depends on USB_G_EXPERIMENTAL_INSTALL
+	range 0 0xffff
+	default 0xa4ad
+	help
+	  The default product ID to use with the gadget when in install
+	  mode.  By default it is 0xa4ad.
+
 endchoice
 
 endif # USB_GADGET
diff --git a/drivers/usb/gadget/Makefile b/drivers/usb/gadget/Makefile
index 5ba5a18..3db3267 100644
--- a/drivers/usb/gadget/Makefile
+++ b/drivers/usb/gadget/Makefile
@@ -64,4 +64,4 @@ obj-$(CONFIG_USB_G_HID)		+= g_hid.o
 obj-$(CONFIG_USB_G_MULTI)	+= g_multi.o
 obj-$(CONFIG_USB_G_NOKIA)	+= g_nokia.o
 obj-$(CONFIG_USB_G_WEBCAM)	+= g_webcam.o
-
+obj-$(CONFIG_USB_G_EXPERIMENTAL)	+= g_experimental.o
diff --git a/drivers/usb/gadget/g_experimental.c b/drivers/usb/gadget/g_experimental.c
new file mode 100644
index 0000000..bc02d5a
--- /dev/null
+++ b/drivers/usb/gadget/g_experimental.c
@@ -0,1 +1,840 @@
+/*
+ * g_experimental.c -- Experimental Composite driver
+ *
+ * Copyright (C) 2008 David Brownell
+ * Copyright (C) 2008 Nokia Corporation
+ * Copyright (C) 2009,2010 Samsung Electronics
+ * Author: Michal Nazarewicz (m.nazarewicz@samsung.com)
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
+
+#include <linux/kernel.h>
+#include <linux/utsname.h>
+#include <linux/module.h>
+#include <linux/workqueue.h>
+#include <linux/jiffies.h>
+
+
+#if defined USB_ETH_RNDIS
+#  undef USB_ETH_RNDIS
+#endif
+#ifdef CONFIG_USB_G_EXPERIMENTAL_RNDIS
+#  define USB_ETH_RNDIS y
+#endif
+
+
+#define DRIVER_DESC		"Experimental Composite Gadget"
+
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_AUTHOR("Michal Nazarewicz");
+MODULE_LICENSE("GPL");
+
+
+/***************************** All the files... *****************************/
+
+/*
+ * kbuild is not very cooperative with respect to linking separately
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
+
+#if defined CONFIG_USB_G_EXPERIMENTAL_MSF || \
+	defined CONFIG_USB_G_EXPERIMENTAL_INSTALL
+#  define EXPER_USES_MSF
+#endif
+
+#if defined CONFIG_USB_G_EXPERIMENTAL_RNDIS || \
+	defined CONFIG_USB_G_EXPERIMENTAL_ECM
+#  define EXPER_HAS_ETH
+#endif
+
+
+/* Mass storage & Install Mode */
+#ifdef EXPER_USES_MSF
+#  include "f_mass_storage.c"
+static struct fsg_module_parameters fsg_mod_data = { .stall = 1 };
+FSG_MODULE_PARAMETERS(/* no prefix */, fsg_mod_data);
+static struct fsg_common fsg_common;
+#else
+#  define fsg_bind_config(cdev, conf, common)  ((int)0)
+#endif
+
+#ifdef CONFIG_USB_G_EXPERIMENTAL_INSTALL
+static unsigned install_mode = 1, next_install_mode = 1;
+#else
+#  define install_mode          false
+#  define next_install_mode     false
+#endif
+
+#ifdef CONFIG_USB_G_EXPERIMENTAL_MSF
+#  define have_msf              true
+#else
+#  define have_msf              false
+#endif
+
+/* CDC ACM */
+#ifdef CONFIG_USB_G_EXPERIMENTAL_ACM
+#  include "u_serial.c"
+#  include "f_acm.c"
+#else
+#  define acm_bind_config(conf, ports)         ((int)0)
+#endif
+
+/* FunctionFS */
+#ifdef CONFIG_USB_G_EXPERIMENTAL_FFS
+#  include "f_fs.c"
+static struct ffs_data *ffs_data, *next_ffs_data;
+static DECLARE_COMPLETION(ffs_data_completion);
+#  define have_ffs              true
+#else
+#  define functionfs_bind_config(cdev, c, ffs) ((int)0)
+#  define functionfs_bind(ffs, cdev)           ((int)0)
+#  define functionfs_unbind(ffs)               ((int)0)
+#  define functionfs_init()                    ((int)0)
+#  define functionfs_cleanup()                 do { } while (0)
+#  define ffs_data              NULL
+#  define have_ffs              false
+#endif
+
+/* Ethernet */
+#ifdef CONFIG_USB_G_EXPERIMENTAL_ECM
+#  include "f_ecm.c"
+#  include "f_subset.c"
+#endif
+
+#ifdef CONFIG_USB_G_EXPERIMENTAL_RNDIS
+#  include "f_rndis.c"
+#  include "rndis.c"
+#endif
+
+#ifdef EXPER_HAS_ETH
+#  include "u_ether.c"
+static u8 hostaddr[ETH_ALEN];
+#else
+#  define hostaddr              NULL
+#endif
+
+#ifndef CONFIG_USB_G_EXPERIMENTAL_ECM
+#  define can_support_ecm(g)    true
+#endif
+
+
+/******************************** Prototypes ********************************/
+
+static unsigned long exper_initialised;
+
+static int  exper_setup(struct usb_composite_dev *cdev);
+static void exper_cleanup(void);
+static int  exper_bind(struct usb_composite_dev *cdev);
+static int  exper_unbind(struct usb_composite_dev *cdev);
+static int  exper_register(void);
+static void exper_unregister(void);
+
+#ifdef CONFIG_USB_G_EXPERIMENTAL_INSTALL
+static int  exper_eject(struct fsg_common *common,
+			struct fsg_lun *lun, int num);
+static void exper_disconnect(struct usb_composite_dev *cdev);
+#else
+#  define exper_disconnect  NULL
+#endif
+
+
+/***************************** Device Descriptor ****************************/
+
+static struct usb_device_descriptor exper_device_desc = {
+	.bLength =		sizeof exper_device_desc,
+	.bDescriptorType =	USB_DT_DEVICE,
+
+	.bcdUSB =		cpu_to_le16(0x0200),
+
+	.bDeviceClass =		USB_CLASS_MISC /* 0xEF */,
+	.bDeviceSubClass =	2,
+	.bDeviceProtocol =	1,
+
+	.idVendor =	cpu_to_le16(CONFIG_USB_G_EXPERIMENTAL_VENDOR),
+	.idProduct =	cpu_to_le16(CONFIG_USB_G_EXPERIMENTAL_PRODUCT),
+};
+
+/* Install mode */
+#ifdef CONFIG_USB_G_EXPERIMENTAL_INSTALL
+
+static struct usb_device_descriptor install_mode_device_desc = {
+	.bLength =		sizeof install_mode_device_desc,
+	.bDescriptorType =	USB_DT_DEVICE,
+
+	.bcdUSB =		cpu_to_le16(0x0200),
+
+	.bDeviceClass =		USB_CLASS_MASS_STORAGE,
+	.bDeviceSubClass =	USB_SC_SCSI,
+	.bDeviceProtocol =	USB_PR_BULK,
+
+	.idVendor =	cpu_to_le16(CONFIG_USB_G_EXPERIMENTAL_VENDOR),
+	.idProduct =	cpu_to_le16(CONFIG_USB_G_EXPERIMENTAL_INSTALL_PRODUCT),
+};
+
+#endif
+
+/* Other descs */
+static const struct usb_descriptor_header *otg_desc[] = {
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
+	NULL,
+};
+
+
+/* Strings */
+enum {
+	EXPER_STRING_MANUFACTURER_IDX,
+	EXPER_STRING_PRODUCT_IDX,
+#ifdef CONFIG_USB_G_EXPERIMENTAL_INSTALL
+	EXPER_STRING_INSTALL_MODE_IDX,
+#endif
+	EXPER_STRING_FIRST_CFG_IDX /* Needs to be the last one */
+};
+
+static char manufacturer[50];
+
+static struct usb_string strings_dev[] = {
+	[EXPER_STRING_MANUFACTURER_IDX].s = manufacturer,
+	[EXPER_STRING_PRODUCT_IDX].s      = DRIVER_DESC,
+#ifdef CONFIG_USB_G_EXPERIMENTAL_INSTALL
+	[EXPER_STRING_INSTALL_MODE_IDX].s = "Install Mode [NoCD]",
+#endif
+
+#ifdef CONFIG_USB_G_EXPERIMENTAL_RNDIS
+	{ .s = "RNDIS Configuration" },
+#endif
+#ifdef CONFIG_USB_G_EXPERIMENTAL_ECM
+	{ .s = "ECM Configuration" },
+#endif
+#ifndef EXPER_HAS_
+	{ .s = "Configuration" },
+#endif
+	{  } /* end of list */
+};
+
+/* The driver */
+static struct usb_composite_driver exper_driver = {
+	.name		= "g_experimental",
+	.dev		= &exper_device_desc,
+	.strings	= (struct usb_gadget_strings *[]) {
+		&(struct usb_gadget_strings) {
+			.language	= 0x0409,	/* en-us */
+			.strings	= strings_dev,
+		},
+		NULL,
+	},
+	.bind		= exper_bind,
+	.unbind		= exper_unbind,
+	.disconnect	= exper_disconnect,
+	.suspend	= exper_disconnect,
+};
+
+#ifdef CONFIG_USB_G_EXPERIMENTAL_INSTALL
+#  define device_desc (*(struct usb_device_descriptor *)exper_driver.dev)
+#else
+#  define device_desc exper_device_desc
+#endif
+
+
+/****************************** Configurations ******************************/
+
+struct exper_configuration {
+	struct usb_configuration c;
+	int(*eth)(struct usb_configuration *c, u8 *addr);
+} exper_configurations[] = {
+#ifdef CONFIG_USB_G_EXPERIMENTAL_RNDIS
+	{ .eth = rndis_bind_config },
+#endif
+#ifdef CONFIG_USB_G_EXPERIMENTAL_ECM
+	{ .eth = ecm_bind_config },
+#endif
+#ifndef EXPER_HAS_ETH
+	{ },
+#endif
+};
+
+static int exper_do_config(struct usb_configuration *c)
+{
+	struct exper_configuration *ec =
+		container_of(c, struct exper_configuration, c);
+
+	int ret;
+
+	if (gadget_is_otg(c->cdev->gadget)) {
+		c->descriptors = otg_desc;
+		c->bmAttributes |= USB_CONFIG_ATT_WAKEUP;
+	}
+
+	if (ec->eth) {
+		ret = ec->eth(c, hostaddr);
+		if (unlikely(ret < 0))
+			return ret;
+	}
+
+	ret = acm_bind_config(c, 0);
+	if (unlikely(ret < 0))
+		return ret;
+
+	if (have_msf) {
+		/*
+		 * We need to check if we want mass storage since it
+		 * may have been forced on by the install mode even
+		 * though user does not want it in the proper USB
+		 * configurations.
+		 */
+		ret = fsg_bind_config(c->cdev, c, &fsg_common);
+		if (unlikely(ret < 0))
+			return ret;
+	}
+
+	if (ffs_data) {
+		ret = functionfs_bind_config(c->cdev, c, ffs_data);
+		if (unlikely(ret < 0))
+			return ret;
+	} else if (have_ffs) {
+		/*
+		 * If FFS is supported make sure that the c->interface
+		 * is properly NULL terminated and that no old pointer
+		 * to FFS intefrace reminds in the c->intefrace array.
+		 * This is consequence of the fact that the
+		 * configuration has different number of interfaces
+		 * depending on whether FFS is active or not.  There
+		 * may be different number of interfaces even with two
+		 * different FFS daemons.
+		 */
+		c->interface[c->next_interface_id] = NULL;
+	}
+
+	return 0;
+}
+
+static int add_normal_mode_configs(struct usb_composite_dev *cdev)
+{
+	int i = 0, ret;
+
+	do {
+		struct usb_configuration *c =
+			&exper_configurations[i].c;
+		c->bind			= exper_do_config;
+		c->bConfigurationValue	= i + 1;
+		c->bmAttributes		= USB_CONFIG_ATT_SELFPOWER;
+		c->iConfiguration	=
+			strings_dev[EXPER_STRING_FIRST_CFG_IDX + i].id;
+		c->label		=
+			strings_dev[EXPER_STRING_FIRST_CFG_IDX + i].s;
+
+		ret = usb_add_config(cdev, c);
+	} while (likely(ret >= 0) && ++i < ARRAY_SIZE(exper_configurations));
+
+	return ret;
+}
+
+
+/********************************* Worker ********************************/
+
+#if defined CONFIG_USB_G_EXPERIMENTAL_INSTALL || \
+	defined CONFIG_USB_G_EXPERIMENTAL_FFS
+
+#ifdef MODULE
+static unsigned exper_exiting;
+#else
+#  define exper_exiting false
+#endif
+
+
+static void exper_worker_func(struct work_struct *work)
+{
+	/* Make sure, the next state is read corretly. */
+	smp_rmb();
+
+	/* exper_exit() has been called -- no need to do anything. */
+	if (exper_exiting)
+		return;
+
+	/* Switch only if anything actually changes. */
+	if (!test_bit(0, &exper_initialised))
+		goto unregistered;
+
+	if (install_mode != next_install_mode)
+		goto registered;
+
+#ifdef CONFIG_USB_G_EXPERIMENTAL_FFS
+	if (ffs_data != next_ffs_data) {
+		if (!install_mode)
+			goto registered;
+		ffs_data = next_ffs_data;
+		complete_all(&ffs_data_completion);
+	}
+#endif
+
+	/* Ther's no reason to re-enumerate. */
+	return;
+
+
+registered:
+	/* Unregister the driver to force re-enumeration. */
+	exper_unregister();
+
+#ifdef CONFIG_USB_G_EXPERIMENTAL_FFS
+	if (ffs_data && !next_ffs_data) {
+		ffs_data = next_ffs_data;
+		complete_all(&ffs_data_completion);
+	}
+#endif
+
+	msleep(5);
+
+unregistered:
+	/*
+	 * While we were waiting the next state could change, so make
+	 * sure we are reading the changed state. This is not critical
+	 * since another worker will be scheduled anyways (see
+	 * exper_worker_schedule()) but we could avoid unnecesary
+	 * switch.  On the other hand this barier is critical for
+	 * cheking exper_exiting, read further.
+	 */
+	smp_rmb();
+
+	/* As we were waiting, exper_exit() has been called. */
+	if (exper_exiting)
+		return;
+
+#ifdef CONFIG_USB_G_EXPERIMENTAL_INSTALL
+	install_mode = next_install_mode;
+#endif
+#ifdef CONFIG_USB_G_EXPERIMENTAL_FFS
+	ffs_data = next_ffs_data;
+	complete_all(&ffs_data_completion);
+#endif
+
+	exper_register();
+}
+
+/*
+ * Configuration switching can be requested from different contexts so
+ * to avoid any troubles which may arrise from the fact that IRQs are
+ * disabled, USB functions are in unknown state, etc. we introduce
+ * a worker which does all that.  It also allows the job to be done
+ * after some delay.  For instance after eject let the mass storage
+ * function settle down.
+ */
+static DECLARE_DELAYED_WORK(exper_worker, exper_worker_func);
+
+static void exper_worker_exit(void)
+{
+#ifdef MODULE
+	exper_exiting = 1;
+#endif
+	/* See description of the usage of smp_rmb() in
+	 * exper_worker_func(). */
+	smp_wmb();
+	cancel_delayed_work_sync(&exper_worker);
+}
+
+static void exper_worker_schedule(void)
+{
+	/* Make sure the new stats is written before worker starts. */
+	smp_wmb();
+	cancel_delayed_work(&exper_worker);
+
+#ifdef CONFIG_USB_G_EXPERIMENTAL_FFS
+	INIT_COMPLETION(ffs_data_completion);
+#endif
+
+	/*
+	 * Run the worker with a 1/64 of a second (~15 ms) delay to
+	 * let everything settle up.
+	 */
+	schedule_delayed_work(&exper_worker, HZ >> 6);
+}
+
+#else
+#  define exper_worker_exit() do { } while (0)
+#endif
+
+
+/****************************** Install Mode *****************************/
+
+#ifdef CONFIG_USB_G_EXPERIMENTAL_INSTALL
+
+static int install_mode_do_config(struct usb_configuration *c)
+{
+	if (gadget_is_otg(c->cdev->gadget)) {
+		c->descriptors = otg_desc;
+		c->bmAttributes |= USB_CONFIG_ATT_WAKEUP;
+	}
+
+	return fsg_bind_config(c->cdev, c, &fsg_common);
+}
+
+static int add_install_mode_config(struct usb_composite_dev *cdev)
+{
+	static struct usb_configuration driver = {
+		.bind			= install_mode_do_config,
+		.bConfigurationValue	= 1,
+		.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
+	};
+
+	driver.iConfiguration = strings_dev[EXPER_STRING_INSTALL_MODE_IDX].id;
+	driver.label          = strings_dev[EXPER_STRING_INSTALL_MODE_IDX].s;
+	return usb_add_config(cdev, &driver);
+}
+
+
+/* Jiffies of the last eject request on LUN 0. */
+static unsigned long exper_eject_jiffies;
+
+static int exper_eject(struct fsg_common *common,
+		       struct fsg_lun *lun, int num)
+{
+	if (num)
+		return 0;
+
+	exper_eject_jiffies = jiffies;
+	next_install_mode = 0;
+	exper_worker_schedule();
+
+	return 1; /* Prevent realy unmounting the device */
+}
+
+static void exper_disconnect(struct usb_composite_dev *cdev)
+{
+	/*
+	 * Change back to install mode only if there was an eject
+	 * (this is checked by looking if exper_eject_jiffies is
+	 * non-zero), we are not switching to install mode already (no
+	 * point in doing anything if next_install_mode is aleady one)
+	 * and at least 10 seconds passed since last eject.
+	 *
+	 * Funky stuff may happen when jiffies wrap but we do not
+	 * care.
+	 */
+	if (exper_eject_jiffies && !next_install_mode &&
+	    jiffies >= exper_eject_jiffies + 10 * HZ) {
+		next_install_mode = 1;
+		exper_worker_schedule();
+	}
+}
+
+#else
+
+static int add_install_mode_config(struct usb_composite_dev *cdev)
+{
+	return 0;
+}
+
+#endif
+
+
+/******************************* FunctionFS ******************************/
+
+#ifdef CONFIG_USB_G_EXPERIMENTAL_FFS
+
+static int functionfs_ready_callback(struct ffs_data *ffs)
+{
+	if (cmpxchg(&next_ffs_data, (struct ffs_data *)NULL, ffs))
+		return -EBUSY;
+
+#ifdef CONFIG_USB_G_EXPERIMENTAL_INSTALL
+	if (!install_mode)
+		exper_eject_jiffies = jiffies;
+#endif
+
+	exper_worker_schedule();
+	return 0;
+}
+
+static void functionfs_closed_callback(struct ffs_data *ffs)
+{
+	next_ffs_data = NULL;
+
+#ifdef CONFIG_USB_G_EXPERIMENTAL_INSTALL
+	if (!install_mode)
+		exper_eject_jiffies = jiffies;
+#endif
+
+	exper_worker_schedule();
+	wait_for_completion(&ffs_data_completion);
+}
+
+static int functionfs_check_dev_callback(const char *dev_name)
+{
+	return next_ffs_data ? -EBUSY : 0;
+}
+
+#endif
+
+
+/****************************** Gadget Bind ******************************/
+
+#ifdef EXPER_USES_MSF
+
+static int exper_fsg_setup(struct usb_composite_dev *cdev)
+{
+	struct fsg_config cfg;
+	void *ret;
+
+#ifdef CONFIG_USB_G_EXPERIMENTAL_INSTALL
+	/*
+	 * In install mode, make the first logical unit a read
+	 * only removable CD-ROM.  In addition if mass storage
+	 * is used only for install mode, sot number of
+	 * logical units to 1.
+	 */
+	if (!have_msf)
+		fsg_mod_data.luns = 1;
+	fsg_mod_data.ro[0]        = 1;
+	fsg_mod_data.removable[0] = 1;
+	fsg_mod_data.cdrom[0]     = 1;
+	fsg_mod_data.ro_count        = max(fsg_mod_data.ro_count,        1u);
+	fsg_mod_data.removable_count = max(fsg_mod_data.removable_count, 1u);
+	fsg_mod_data.cdrom_count     = max(fsg_mod_data.cdrom_count,     1u);
+#endif
+
+	fsg_config_from_params(&cfg, &fsg_mod_data);
+
+#ifdef CONFIG_USB_G_EXPERIMENTAL_INSTALL
+	{
+		static const struct fsg_operations ops = {
+			.pre_eject = exper_eject,
+		};
+		cfg.ops = &ops;
+	}
+#endif
+
+	ret = fsg_common_init(&fsg_common, cdev, &cfg);
+	return unlikely(IS_ERR(ret)) ? PTR_ERR(ret) : 0;
+}
+
+#endif
+
+
+static int exper_setup(struct usb_composite_dev *cdev)
+{
+	int ret;
+
+#ifdef EXPER_HAS_ETH
+	/* set up network link layer */
+	if (!test_and_set_bit(1, &exper_initialised)) {
+		ret = gether_setup(cdev->gadget, hostaddr);
+		if (unlikely(ret < 0)) {
+			clear_bit(1, &exper_initialised);
+			goto fail;
+		}
+	}
+#endif
+
+#ifdef CONFIG_USB_G_EXPERIMENTAL_ACM
+	/* set up serial link layer */
+	if (!test_and_set_bit(2, &exper_initialised)) {
+		ret = gserial_setup(cdev->gadget, 1);
+		if (unlikely(ret < 0)) {
+			clear_bit(2, &exper_initialised);
+			goto fail;
+		}
+	}
+#endif
+
+#ifdef EXPER_USES_MSF
+	/* set up mass storage */
+	if (!test_and_set_bit(3, &exper_initialised)) {
+		ret = exper_fsg_setup(cdev);
+	} else {
+		ret = fsg_common_bind_cdev(&fsg_common, cdev);
+	}
+	if (unlikely(ret < 0)) {
+		clear_bit(3, &exper_initialised);
+		goto fail;
+	}
+#endif
+
+	return 0;
+
+fail:
+	exper_cleanup();
+	return ret;
+}
+
+static void exper_cleanup(void)
+{
+#ifdef EXPER_USES_MSF
+	if (test_and_clear_bit(3, &exper_initialised))
+		fsg_common_put(&fsg_common);
+#endif
+
+#ifdef CONFIG_USB_G_EXPERIMENTAL_ACM
+	if (test_and_clear_bit(2, &exper_initialised))
+		gserial_cleanup();
+#endif
+
+#ifdef EXPER_HAS_ETH
+	if (test_and_clear_bit(1, &exper_initialised))
+		gether_cleanup();
+#endif
+}
+
+
+static int exper_bind(struct usb_composite_dev *cdev)
+{
+	struct usb_gadget *gadget = cdev->gadget;
+	int status;
+
+	if (!can_support_ecm(cdev->gadget)) {
+		dev_err(&gadget->dev, "controller '%s' not usable\n",
+			gadget->name);
+		return -EINVAL;
+	}
+
+	/* Set up functions */
+	status = exper_setup(cdev);
+	if (unlikely(status < 0))
+		return status;
+
+	if (ffs_data && !install_mode) {
+		status = functionfs_bind(ffs_data, cdev);
+		if (unlikely(status < 0))
+			goto fail_ffs;
+	}
+
+	/* allocate string descriptor numbers */
+	if (!*manufacturer)
+		snprintf(manufacturer, sizeof manufacturer, "%s %s with %s",
+			 init_utsname()->sysname, init_utsname()->release,
+			 gadget->name);
+
+	status = usb_string_ids_tab(cdev, strings_dev);
+	if (unlikely(status < 0))
+		goto fail;
+
+	/* register configurations */
+	if (install_mode) {
+		status = add_install_mode_config(cdev);
+	} else {
+		status = add_normal_mode_configs(cdev);
+		if (unlikely(status < 0))
+			goto fail;
+	}
+
+	/* Fill the rest of the device descriptor */
+	device_desc.iManufacturer =
+		strings_dev[EXPER_STRING_MANUFACTURER_IDX].id;
+	device_desc.iProduct      =
+		strings_dev[EXPER_STRING_PRODUCT_IDX].id;
+
+	status = usb_gadget_controller_number(cdev->gadget);
+	device_desc.bcdDevice =
+		cpu_to_le16(0x300 | (status < 0 ? 0x99 : status));
+
+	/* we're done */
+	dev_info(&gadget->dev, DRIVER_DESC "\n");
+	return 0;
+
+
+	/* error recovery */
+fail:
+	if (ffs_data && !install_mode)
+fail_ffs:
+		functionfs_unbind(ffs_data);
+	exper_cleanup();
+	return status;
+}
+
+static int  exper_unbind(struct usb_composite_dev *cdev)
+{
+	if (ffs_data && !install_mode)
+		functionfs_unbind(ffs_data);
+
+#ifdef EXPER_USES_MSF
+	fsg_common_unbind_cdev(&fsg_common);
+#endif
+
+	return 0;
+}
+
+
+
+/*************************** Other init/exit ****************************/
+
+static int exper_register(void)
+{
+	int ret;
+
+	if (test_and_set_bit(0, &exper_initialised))
+		return -EBUSY;
+
+#ifdef CONFIG_USB_G_EXPERIMENTAL_INSTALL
+	exper_driver.dev = install_mode
+		? &install_mode_device_desc
+		: &exper_device_desc;
+#endif
+
+#ifdef CONFIG_USB_G_EXPERIMENTAL_FFS
+	if (!install_mode)
+		exper_device_desc.idProduct =
+			ffs_data
+			? cpu_to_le16(CONFIG_USB_G_EXPERIMENTAL_FFS_PRODUCT)
+			: cpu_to_le16(CONFIG_USB_G_EXPERIMENTAL_PRODUCT);
+#endif
+
+	ret = usb_composite_register(&exper_driver);
+	if (unlikely(ret)) {
+		clear_bit(0, &exper_initialised);
+		printk(KERN_ERR
+		       "g_experimental: failed registering the driver: %d\n",
+		       ret);
+	}
+	return ret;
+}
+
+static void exper_unregister(void)
+{
+	if (test_and_clear_bit(0, &exper_initialised))
+		usb_composite_unregister(&exper_driver);
+}
+
+
+static __init int exper_init(void)
+{
+	int ret = functionfs_init();
+	return unlikely(ret) ? ret : exper_register();
+}
+module_init(exper_init);
+
+static __exit void exper_exit(void)
+{
+	exper_worker_exit();
+	exper_unregister();
+	exper_cleanup();
+	functionfs_cleanup();
+}
+module_exit(exper_exit);
-- 
1.7.1

