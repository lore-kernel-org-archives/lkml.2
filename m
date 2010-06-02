Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab0FBMq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 08:46:29 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57176 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757950Ab0FBMpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 08:45:04 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 02 Jun 2010 14:45:32 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv3 11/11] USB: gadget: g_multi: Install Mode added
In-reply-to: <120b9049f9525ad39eb52203e1865dacf0aee802.1275481997.git.mina86@mina86.com>
To: linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <899590aff8822a786165eaf2ef2e2180965a0875.1275481997.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.1
References: <cover.1275481997.git.mina86@mina86.com>
 <5e151207bced1e418bcfed136a871d2da47e417e.1275481997.git.mina86@mina86.com>
 <e4cb4e647e0ebc51956d6581cd930e3d32f29b99.1275481997.git.mina86@mina86.com>
 <785f09f63fe30ba52ce15fd7cb3f5750aa279ab9.1275481997.git.mina86@mina86.com>
 <5492eaf531c8a59c7c188b9e341572c9cdaed5f2.1275481997.git.mina86@mina86.com>
 <17b54e2cc00a7f730483401f06c79c781491dc62.1275481997.git.mina86@mina86.com>
 <381c3f8318e39caaffa1ecfdf5e3cf13ed59cd27.1275481997.git.mina86@mina86.com>
 <c8725442e3c5b8c7be2cc381ed69a3dc0283ebe1.1275481997.git.mina86@mina86.com>
 <762e84e05c338446cb4c51797b4773d3db321179.1275481997.git.mina86@mina86.com>
 <3e06c1fa8a9bec733305e8e6e7fc9aa72fd840b2.1275481997.git.mina86@mina86.com>
 <120b9049f9525ad39eb52203e1865dacf0aee802.1275481997.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added an Install Mode to the Multifunction Composite Gadget.  This
mode makes the gadget appear as a mass storage device with first
logical unit simulating CD-ROM until an eject on that logical unit
is requested because then gadget switches to the "full flagged"
gadget.

The intend is that in Install Mode the gadget will provide only
a CD-ROM with drivers for host platform.  After the drivers are
intstalled the gadget will switch to the proper gadget and the
newly installed drivers will handle it.

When the device is disconnected form the host machine (or host
reboots or whatever that couses suspend or disconnect) the gadget
will switch to Install Mode again.

Because disconnect is a normal situation on re-enumeration gadget
"ignores" all disconnects and suspends during the first 10 seconds
after an eject.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/usb/gadget_multi.txt |   61 ++++
 drivers/usb/gadget/Kconfig         |   22 ++
 drivers/usb/gadget/multi.c         |  596 +++++++++++++++++++++++++++++-------
 3 files changed, 567 insertions(+), 112 deletions(-)

diff --git a/Documentation/usb/gadget_multi.txt b/Documentation/usb/gadget_multi.txt
index 65bccd8..9319f1d 100644
--- a/Documentation/usb/gadget_multi.txt
+++ b/Documentation/usb/gadget_multi.txt
@@ -18,6 +18,11 @@ RNDIS and another with CDC ECM[3].
 Please not that if you use non-standard configuration you may need to
 change vendor and/or product ID.
 
+The driver provides also an "install mode" which you may also call
+NoCD ore ZereCD (expect the later is a trademark) which lets one
+develop an image with drivers which install automatically on systems
+like Windows.
+
 * Host drivers
 
 To make use of the gadget one needs to make it work on host side --
@@ -35,6 +40,10 @@ This is also true for two configuration set-up with RNDIS
 configuration being the first one.  Linux host will use the second
 configuration with CDC ECM which should work better under Linux.
 
+The only exception is when install mode is enabled in which case the
+gadget will appear as a plain mass storage device unless it is
+ejected.  Read appropriate section of this document to find out more.
+
 ** Windows host drivers
 
 For the gadget two work under Windown two conditions have to be met:
@@ -129,6 +138,54 @@ For more exotic systems I have even less to say...
 
 Any testing and drivers *are* *welcome*!
 
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
+Fortunately, there's USB_ModeSwitch[8] and/or udev[9] which
+should handle it just fine.  A single rule need to be added and
+everything should work fine.
+
 * Authors
 
 This document has been written by Michal Nazarewicz
@@ -158,3 +215,7 @@ any user input.
 [7] Possibility to say `git rev-list --author='Your Name'
 linus/master|wc -l` returns non-zero -- priceless. :]
 
+[8] [[http://www.draisberghof.de/usb_modeswitch/]]
+
+[9] [[http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev.html]]
+
diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 8052643..21500eb 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -920,6 +920,28 @@ config USB_G_MULTI_MSF
 
 	  If unsure, say "y".
 
+config USB_G_MULTI_INSTALL
+	bool "Install Mode"
+	depends on USB_G_MULTI && BLOCK
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
 config USB_G_HID
 	tristate "HID Gadget"
 	help
diff --git a/drivers/usb/gadget/multi.c b/drivers/usb/gadget/multi.c
index 6f6fd3e..4aab815 100644
--- a/drivers/usb/gadget/multi.c
+++ b/drivers/usb/gadget/multi.c
@@ -25,6 +25,8 @@
 #include <linux/kernel.h>
 #include <linux/utsname.h>
 #include <linux/module.h>
+#include <linux/workqueue.h>
+#include <linux/jiffies.h>
 
 
 #if defined USB_ETH_RNDIS
@@ -57,18 +59,27 @@ MODULE_LICENSE("GPL");
 #include "config.c"
 #include "epautoconf.c"
 
-/* Mass storage */
-#ifdef CONFIG_USB_G_MULTI_MSF
+/* Mass storage & Install Mode */
+#if defined CONFIG_USB_G_MULTI_MSF || defined CONFIG_USB_G_MULTI_INSTALL
 #  include "f_mass_storage.c"
-
 static struct fsg_module_parameters fsg_mod_data = { .stall = 1 };
 FSG_MODULE_PARAMETERS(/* no prefix */, fsg_mod_data);
-
 static struct fsg_common fsg_common;
 #else
-#  define fsg_common_from_params(common, cdev, data) NULL
 #  define fsg_bind_config(cdev, conf, common)        ((int)0)
-#  define fsg_common_put(common)            do { } while (0)
+#endif
+
+#ifdef CONFIG_USB_G_MULTI_INSTALL
+static unsigned install_mode = 1, next_install_mode = 1;
+#else
+#  define install_mode          false
+#  define next_install_mode     false
+#endif
+
+#ifdef CONFIG_USB_G_MULTI_MSF
+#  define have_fsg              true
+#else
+#  define have_fsg              false
 #endif
 
 /* CDC ACM */
@@ -76,8 +87,6 @@ static struct fsg_common fsg_common;
 #  include "u_serial.c"
 #  include "f_acm.c"
 #else
-#  define gserial_setup(conf, ports)        ((int)0)
-#  define gserial_cleanup()                 do { } while (0)
 #  define acm_bind_config(conf, ports)      ((int)0)
 #endif
 
@@ -95,9 +104,6 @@ static struct fsg_common fsg_common;
 #if defined CONFIG_USB_G_MULTI_ECM || defined CONFIG_USB_G_MULTI_RNDIS
 #  include "u_ether.c"
 static u8 hostaddr[ETH_ALEN];
-#else
-#  define gether_setup(cdev, hostaddr) ((int)0)
-#  define gether_cleanup()             do { } while (0)
 #endif
 
 #ifndef CONFIG_USB_G_MULTI_ECM
@@ -110,14 +116,34 @@ static u8 hostaddr[ETH_ALEN];
 #endif
 
 
+/******************************** Prototypes ********************************/
+
+static unsigned long multi_initialised;
+
+static int  multi_setup(struct usb_composite_dev *cdev);
+static void multi_cleanup(void);
+static int  multi_bind(struct usb_composite_dev *cdev);
+static int  multi_register(void);
+static void multi_unregister(void);
+
+#ifdef CONFIG_USB_G_MULTI_INSTALL
+static int  multi_eject(struct fsg_common *common,
+			struct fsg_lun *lun, int num);
+static void multi_disconnect(struct usb_composite_dev *cdev);
+#else
+#  define multi_disconnect  NULL
+#endif
+
+
+
 /***************************** Device Descriptor ****************************/
 
+/* Main device */
 #define MULTI_VENDOR_NUM	0x0525	/* XXX NetChip */
 #define MULTI_PRODUCT_NUM	0xa4ab	/* XXX */
 
-
-static struct usb_device_descriptor device_desc = {
-	.bLength =		sizeof device_desc,
+static struct usb_device_descriptor multi_device_desc = {
+	.bLength =		sizeof multi_device_desc,
 	.bDescriptorType =	USB_DT_DEVICE,
 
 	.bcdUSB =		cpu_to_le16(0x0200),
@@ -136,7 +162,31 @@ static struct usb_device_descriptor device_desc = {
 #endif
 };
 
+/* Install mode */
+#ifdef CONFIG_USB_G_MULTI_INSTALL
+
+#define MULTI_INSTALL_VENDOR_NUM	0x0525	/* XXX NetChip */
+#define MULTI_INSTALL_PRODUCT_NUM	0xa4ad	/* XXX */
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
 
+	/* Vendor and product id can be overridden by module parameters.  */
+	.idVendor =		cpu_to_le16(MULTI_INSTALL_VENDOR_NUM),
+	.idProduct =		cpu_to_le16(MULTI_INSTALL_PRODUCT_NUM),
+	.bNumConfigurations =	1,
+};
+
+#endif
+
+/* Other descs */
 static const struct usb_descriptor_header *otg_desc[] = {
 	(struct usb_descriptor_header *) &(struct usb_otg_descriptor){
 		.bLength =		sizeof(struct usb_otg_descriptor),
@@ -150,9 +200,17 @@ static const struct usb_descriptor_header *otg_desc[] = {
 };
 
 
+/* Strings */
 enum {
 	MULTI_STRING_MANUFACTURER_IDX,
 	MULTI_STRING_PRODUCT_IDX,
+	MULTI_STRING_FIRST_CFG_IDX,
+#if defined CONFIG_USB_G_MULTI_RNDIS && defined CONFIG_USB_G_MULTI_ECM
+	MULTI_STRING_SECOND_CFG_IDX,
+#endif
+#ifdef CONFIG_USB_G_MULTI_INSTALL
+	MULTI_STRING_INSTALL_MODE_IDX,
+#endif
 };
 
 static char manufacturer[50];
@@ -160,24 +218,42 @@ static char manufacturer[50];
 static struct usb_string strings_dev[] = {
 	[MULTI_STRING_MANUFACTURER_IDX].s = manufacturer,
 	[MULTI_STRING_PRODUCT_IDX].s      = DRIVER_DESC,
+	[MULTI_STRING_FIRST_CFG_IDX].s    = "First Configuration",
+#if defined CONFIG_USB_G_MULTI_RNDIS && defined CONFIG_USB_G_MULTI_ECM
+	[MULTI_STRING_SECOND_CFG_IDX].s   = "Second Configuration",
+#endif
+#ifdef CONFIG_USB_G_MULTI_INSTALL
+	[MULTI_STRING_INSTALL_MODE_IDX].s = "Install Mode [NoCD]",
+#endif
 	{  } /* end of list */
 };
 
-static struct usb_gadget_strings *dev_strings[] = {
-	&(struct usb_gadget_strings){
-		.language	= 0x0409,	/* en-us */
-		.strings	= strings_dev,
+/* The driver */
+static struct usb_composite_driver multi_driver = {
+	.name		= "g_multi",
+	.dev		= &multi_device_desc,
+	.strings	= (struct usb_gadget_strings *[]) {
+		&(struct usb_gadget_strings) {
+			.language	= 0x0409,	/* en-us */
+			.strings	= strings_dev,
+		},
+		NULL,
 	},
-	NULL,
+	.bind		= multi_bind,
+	.disconnect	= multi_disconnect,
+	.suspend	= multi_disconnect,
 };
 
-
+#ifdef CONFIG_USB_G_MULTI_INSTALL
+#  define device_desc (*(struct usb_device_descriptor *)multi_driver.dev)
+#else
+#  define device_desc multi_device_desc
+#endif
 
 
 /****************************** Configurations ******************************/
 
-
-static __ref int first_do_config(struct usb_configuration *c)
+static int first_do_config(struct usb_configuration *c)
 {
 	int ret;
 
@@ -186,36 +262,51 @@ static __ref int first_do_config(struct usb_configuration *c)
 		c->bmAttributes |= USB_CONFIG_ATT_WAKEUP;
 	}
 
+	/* First configuration can have either RNDIS or ECM.  This
+	 * depends on wthether RNDIS is turned on.  If it is then
+	 * first config is always RNDIS because even if ECM is on as
+	 * well it is the second config. */
 #ifdef CONFIG_USB_G_MULTI_RNDIS
 	ret = rndis_bind_config(c, hostaddr);
 #else
 	ret = ecm_bind_config(c, hostaddr);
 #endif
-	if (ret < 0)
+	if (unlikely(ret < 0))
 		return ret;
 
 	ret = acm_bind_config(c, 0);
-	if (ret < 0)
+	if (unlikely(ret < 0))
 		return ret;
 
-	ret = fsg_bind_config(c->cdev, c, &fsg_common);
-	if (ret < 0)
-		return ret;
+	if (have_fsg) {
+		/* We need to check if we want mass storage since it
+		 * may have been forced on by the install mode even
+		 * though user does not want it in the proper USB
+		 * configurations. */
+		ret = fsg_bind_config(c->cdev, c, &fsg_common);
+		if (unlikely(ret < 0))
+			return ret;
+	}
 
 	return 0;
 }
 
-static struct usb_configuration first_config_driver = {
-	.label			= "First Configuration",
-	.bind			= first_do_config,
-	.bConfigurationValue	= 1,
-	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
-};
-
+static int add_first_config(struct usb_composite_dev *cdev)
+{
+	static struct usb_configuration driver = {
+		.bind			= first_do_config,
+		.bConfigurationValue	= 1,
+		.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
+	};
+
+	driver.iConfiguration = strings_dev[MULTI_STRING_FIRST_CFG_IDX].id;
+	driver.label          = strings_dev[MULTI_STRING_FIRST_CFG_IDX].s;
+	return usb_add_config(cdev, &driver);
+}
 
 #if defined CONFIG_USB_G_MULTI_RNDIS && defined CONFIG_USB_G_MULTI_ECM
 
-static __ref int second_do_config(struct usb_configuration *c)
+static int second_do_config(struct usb_configuration *c)
 {
 	int ret;
 
@@ -225,144 +316,425 @@ static __ref int second_do_config(struct usb_configuration *c)
 	}
 
 	ret = ecm_bind_config(c, hostaddr);
-	if (ret < 0)
+	if (unlikely(ret < 0))
 		return ret;
 
 	ret = acm_bind_config(c, 0);
-	if (ret < 0)
+	if (unlikely(ret < 0))
 		return ret;
 
-	ret = fsg_bind_config(c->cdev, c, &fsg_common);
-	if (ret < 0)
-		return ret;
+	if (have_fsg) {
+		/* We need to check if we want mass storage since it
+		 * may have been forced on by the install mode even
+		 * though user does not want it in the proper USB
+		 * configurations. */
+		ret = fsg_bind_config(c->cdev, c, &fsg_common);
+		if (unlikely(ret < 0))
+			return ret;
+	}
 
 	return 0;
 }
 
-static struct usb_configuration second_config_driver = {
-	.label			= "Second Configuration",
-	.bind			= second_do_config,
-	.bConfigurationValue	= 2,
-	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
-};
+static int add_second_config(struct usb_composite_dev *cdev)
+{
+	static struct usb_configuration driver = {
+		.bind			= second_do_config,
+		.bConfigurationValue	= 2,
+		.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
+	};
+
+	driver.iConfiguration = strings_dev[MULTI_STRING_FIRST_CFG_IDX].id;
+	driver.label          = strings_dev[MULTI_STRING_FIRST_CFG_IDX].s;
+	return usb_add_config(cdev, &driver);
+}
+
+#else
+
+static int add_second_config(struct usb_composite_dev *cdev)
+{
+	return 0;
+}
+
+#endif
+
+
+/********************************* Worker ********************************/
+
+#if defined CONFIG_USB_G_MULTI_INSTALL
+
+#ifdef MODULE
+static unsigned multi_exiting;
+#else
+#  define multi_exiting false
+#endif
+
+
+static void multi_worker_func(struct work_struct *work)
+{
+	/* Make sure, the next state is read corretly. */
+	smp_rmb();
+
+	/* multi_exit() has been called -- no need to do anything. */
+	if (multi_exiting)
+		return;
+
+	/* Switch only if anything actually changes. */
+	if (!test_bit(0, &multi_initialised))
+		goto unregistered;
 
+	if (install_mode != next_install_mode)
+		goto registered;
+
+	/* Ther's no reason to re-enumerate. */
+	return;
+
+
+registered:
+	/* Unregister the driver to force re-enumeration. */
+	multi_unregister();
+	msleep(5);
+
+unregistered:
+	/* While we were waiting the next state could change, so make
+	 * sure we are reading the changed state. This is not critical
+	 * since another worker will be scheduled anyways (see
+	 * multi_worker_schedule()) but we could avoid unnecesary
+	 * switch.  On the other hand this barier is critical for
+	 * cheking multi_exiting, read further. */
+	smp_rmb();
+
+	/* As we were waiting, multi_exit() has been called. */
+	if (multi_exiting)
+		return;
+
+#ifdef CONFIG_USB_G_MULTI_INSTALL
+	install_mode = next_install_mode;
 #endif
 
+	multi_register();
+}
+
+/* Configuration switching can be requested from different contexts so
+ * to avoid any troubles which may arrise from the fact that IRQs are
+ * disabled, USB functions are in unknown state, etc. we introduce
+ * a worker which does all that.  It also allows the job to be done
+ * after some delay.  For instance after eject let the mass storage
+ * function settle down. */
+static DECLARE_DELAYED_WORK(multi_worker, multi_worker_func);
+
+static void multi_worker_exit(void)
+{
+	multi_exiting = 1;
+	/* See description of the usage of smp_rmb() in
+	 * multi_worker_func(). */
+	smp_wmb();
+	cancel_delayed_work_sync(&multi_worker);
+}
+
+static void multi_worker_schedule(void)
+{
+	/* Make sure the new stats is written before worker starts. */
+	smp_wmb();
+	/* Cancel or wait for completion if worker is scheduled. */
+	cancel_delayed_work(&multi_worker);
+	/* Run the worker with a 1/64 of a second (~15 ms) delay to
+	 * let everything settle up. */
+	schedule_delayed_work(&multi_worker, HZ >> 6);
+}
+
+#  define __dyn_init
+#  define __dyn_ref
+#  define __dyn_exit
+#else
+#  define __dyn_init __init
+#  define __dyn_ref  __ref
+#  define __dyn_exit __exit
+#  define multi_worker_exit() do { } while (0)
+#endif
+
+
+/****************************** Install Mode *****************************/
+
+#ifdef CONFIG_USB_G_MULTI_INSTALL
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
+	driver.iConfiguration = strings_dev[MULTI_STRING_INSTALL_MODE_IDX].id;
+	driver.label          = strings_dev[MULTI_STRING_INSTALL_MODE_IDX].s;
+	return usb_add_config(cdev, &driver);
+}
+
+
+/* Jiffies of the last eject request on LUN 0. */
+static unsigned long multi_eject_jiffies;
+
+static int multi_eject(struct fsg_common *common,
+		       struct fsg_lun *lun, int num)
+{
+	if (num)
+		return 0;
+
+	multi_eject_jiffies = jiffies;
+	next_install_mode = 0;
+	multi_worker_schedule();
+
+	return 1; /* Prevent realy unmounting the device */
+}
+
+static void multi_disconnect(struct usb_composite_dev *cdev)
+{
+	printk(KERN_INFO "multi_disconnect()\n");
+
+	/* Change back to install mode only if there was an eject
+	 * (this is checked by looking if multi_eject_jiffies is
+	 * non-zero), we are not switching to install mode already (no
+	 * point in doing anything if next_install_mode is aleady one)
+	 * and at least 10 seconds passed since last eject. */
+	/* Funky stuff may happen when jiffies wrap but we do not
+	 * care. */
+	if (multi_eject_jiffies && !next_install_mode &&
+	    jiffies >= multi_eject_jiffies + 10 * HZ) {
+		next_install_mode = 1;
+		multi_worker_schedule();
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
 
 
 /****************************** Gadget Bind ******************************/
 
+#if defined CONFIG_USB_G_MULTI_MSF || defined CONFIG_USB_G_MULTI_INSTALL
 
-static int __ref multi_bind(struct usb_composite_dev *cdev)
+static int __dyn_init multi_fsg_setup(struct usb_composite_dev *cdev)
 {
-	struct usb_gadget *gadget = cdev->gadget;
-	int status, gcnum;
+	struct fsg_config cfg;
+	void *ret;
+
+#ifdef CONFIG_USB_G_MULTI_INSTALL
+	/* In install mode, make the first logical unit a read
+	 * only removable CD-ROM.  In addition if mass storage
+	 * is used only for install mode, sot number of
+	 * logical units to 1. */
+	if (!have_fsg)
+		fsg_mod_data.luns = 1;
+	fsg_mod_data.ro[0] = 1;
+	fsg_mod_data.removable[0] = 1;
+	fsg_mod_data.cdrom[0] = 1;
+	fsg_mod_data.removable_count =
+		max(fsg_mod_data.removable_count, 1u);
+#endif
 
-	if (!can_support_ecm(cdev->gadget)) {
-		dev_err(&gadget->dev, "controller '%s' not usable\n",
-		        gadget->name);
-		return -EINVAL;
+	fsg_config_from_params(&cfg, &fsg_mod_data);
+
+#ifdef CONFIG_USB_G_MULTI_INSTALL
+	{
+		static const struct fsg_operations ops = {
+			.pre_eject = multi_eject,
+		};
+		cfg.ops = &ops;
 	}
+#endif
+
+	ret = fsg_common_init(&fsg_common, cdev, &cfg);
+	return unlikely(IS_ERR(ret)) ? PTR_ERR(ret) : 0;
+}
+
+#endif
+
 
+static int __dyn_init multi_setup(struct usb_composite_dev *cdev)
+{
+	int ret;
+
+#if defined CONFIG_USB_G_MULTI_RNDIS || defined CONFIG_USB_G_MULTI_ECM
 	/* set up network link layer */
-	status = gether_setup(cdev->gadget, hostaddr);
-	if (status < 0)
-		return status;
+	if (!test_and_set_bit(1, &multi_initialised)) {
+		ret = gether_setup(cdev->gadget, hostaddr);
+		if (unlikely(ret < 0)) {
+			clear_bit(1, &multi_initialised);
+			goto fail;
+		}
+	}
+#endif
 
+#if defined CONFIG_USB_G_MULTI_ACM
 	/* set up serial link layer */
-	status = gserial_setup(cdev->gadget, 1);
-	if (status < 0)
-		goto fail0;
+	if (!test_and_set_bit(2, &multi_initialised)) {
+		ret = gserial_setup(cdev->gadget, 1);
+		if (unlikely(ret < 0)) {
+			clear_bit(2, &multi_initialised);
+			goto fail;
+		}
+	}
+#endif
 
-	/* set up mass storage function */
-	{
-		void *retp;
-		retp = fsg_common_from_params(&fsg_common, cdev, &fsg_mod_data);
-		if (IS_ERR(retp)) {
-			status = PTR_ERR(retp);
-			goto fail1;
+#if defined CONFIG_USB_G_MULTI_MSF || defined CONFIG_USB_G_MULTI_INSTALL
+	/* set up mass storage */
+	if (!test_and_set_bit(3, &multi_initialised)) {
+		ret = multi_fsg_setup(cdev);
+		if (unlikely(ret < 0)) {
+			clear_bit(3, &multi_initialised);
+			goto fail;
 		}
 	}
+#endif
 
-	/* set bcdDevice */
-	gcnum = usb_gadget_controller_number(gadget);
-	if (gcnum >= 0) {
-		device_desc.bcdDevice = cpu_to_le16(0x0300 | gcnum);
-	} else {
-		WARNING(cdev, "controller '%s' not recognized\n", gadget->name);
-		device_desc.bcdDevice = cpu_to_le16(0x0300 | 0x0099);
+	return 0;
+
+fail:
+	multi_cleanup();
+	return ret;
+}
+
+static void multi_cleanup(void)
+{
+#if defined CONFIG_USB_G_MULTI_MSF || defined CONFIG_USB_G_MULTI_INSTALL
+	if (test_and_clear_bit(3, &multi_initialised))
+		fsg_common_put(&fsg_common);
+#endif
+
+#if defined CONFIG_USB_G_MULTI_ACM
+	if (test_and_clear_bit(2, &multi_initialised))
+		gserial_cleanup();
+#endif
+
+#if defined CONFIG_USB_G_MULTI_RNDIS || defined CONFIG_USB_G_MULTI_ECM
+	if (test_and_clear_bit(1, &multi_initialised))
+		gether_cleanup();
+#endif
+}
+
+
+static int __dyn_ref multi_bind(struct usb_composite_dev *cdev)
+{
+	struct usb_gadget *gadget = cdev->gadget;
+	int status;
+
+	if (!can_support_ecm(cdev->gadget)) {
+		dev_err(&gadget->dev, "controller '%s' not usable\n",
+			gadget->name);
+		return -EINVAL;
 	}
 
-	/* allocate string descriptor numbers */
+	/* Set up functions */
+	status = multi_setup(cdev);
+	if (unlikely(status < 0))
+		return status;
 
-	snprintf(manufacturer, sizeof manufacturer, "%s %s with %s",
-	         init_utsname()->sysname, init_utsname()->release,
-	         gadget->name);
+	/* allocate string descriptor numbers */
+	if (!*manufacturer)
+		snprintf(manufacturer, sizeof manufacturer, "%s %s with %s",
+			 init_utsname()->sysname, init_utsname()->release,
+			 gadget->name);
 
 	status = usb_string_ids_tab(cdev, strings_dev);
 	if (unlikely(status < 0))
-		goto fail2;
+		goto fail;
+
+	printk(KERN_INFO "install_mode = %d\n", install_mode);
 
+	/* register configurations */
+	if (install_mode) {
+		status = add_install_mode_config(cdev);
+	} else {
+		status = add_first_config(cdev);
+		if (unlikely(status < 0))
+			goto fail;
+
+		status = add_second_config(cdev);
+		if (unlikely(status < 0))
+			goto fail;
+	}
+
+	/* Fill the rest of the device descriptor */
 	device_desc.iManufacturer =
 		strings_dev[MULTI_STRING_MANUFACTURER_IDX].id;
 	device_desc.iProduct      =
 		strings_dev[MULTI_STRING_PRODUCT_IDX].id;
 
-	/* register configurations */
-	status = usb_add_config(cdev, &first_config_driver);
-	if (unlikely(status < 0))
-		goto fail2;
-
-#if defined CONFIG_USB_G_MULTI_RNDIS && defined CONFIG_USB_G_MULTI_ECM
-	status = usb_add_config(cdev, &second_config_driver);
-	if (unlikely(status < 0))
-		goto fail2;
-#endif
+	status = usb_gadget_controller_number(cdev->gadget);
+	device_desc.bcdDevice =
+		cpu_to_le16(0x300 | (status < 0 ? 0x99 : status));
 
 	/* we're done */
 	dev_info(&gadget->dev, DRIVER_DESC "\n");
-	fsg_common_put(&fsg_common);
 	return 0;
 
 
 	/* error recovery */
-fail2:
-	fsg_common_put(&fsg_common);
-fail1:
-	gserial_cleanup();
-fail0:
-	gether_cleanup();
+fail:
+	multi_cleanup();
 	return status;
 }
 
-static int __exit multi_unbind(struct usb_composite_dev *cdev)
+
+/*************************** Other init/exit ****************************/
+
+static int __dyn_init multi_register(void)
 {
-	gserial_cleanup();
-	gether_cleanup();
-	return 0;
-}
+	int ret = 0;
 
+	if (!test_and_set_bit(0, &multi_initialised)) {
+#ifdef CONFIG_USB_G_MULTI_INSTALL
+		multi_driver.dev = install_mode
+			? &install_mode_device_desc
+			: &multi_device_desc;
+#endif
 
-/****************************** Some noise ******************************/
+		ret = usb_composite_register(&multi_driver);
+		if (unlikely(ret)) {
+			clear_bit(0, &multi_initialised);
+			printk(KERN_ERR
+			       "g_multi: failed registering the driver: %d\n",
+			       ret);
+		}
+	}
 
+	return ret;
+}
 
-static struct usb_composite_driver multi_driver = {
-	.name		= "g_multi",
-	.dev		= &device_desc,
-	.strings	= dev_strings,
-	.bind		= multi_bind,
-	.unbind		= __exit_p(multi_unbind),
-};
+static void __dyn_exit multi_unregister(void)
+{
+	if (test_and_clear_bit(0, &multi_initialised))
+		usb_composite_unregister(&multi_driver);
+}
 
 
-static int __init multi_init(void)
+static __init int multi_init(void)
 {
-	return usb_composite_register(&multi_driver);
+	return multi_register();
 }
 module_init(multi_init);
 
-static void __exit multi_exit(void)
+static __exit void multi_exit(void)
 {
-	usb_composite_unregister(&multi_driver);
+	multi_worker_exit();
+	multi_unregister();
+	multi_cleanup();
 }
 module_exit(multi_exit);
-- 
1.7.1

