Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab2HXSqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 14:46:30 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37785 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab2HXSqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 14:46:25 -0400
From: Michal Nazarewicz <mpn@google.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: gadget: get rid of USB_GADGET_{DUAL,SUPER}SPEED
Date: Fri, 24 Aug 2012 20:46:18 +0200
Message-Id: <8c7e6429f51fd5f21f1c62ae53c553b1f0fd0a1c.1345833862.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

This commit removes USB_GADGET_DUALSPEED and USB_GADGET_SUPERSPEED
Kconfig options.  Since now kernel allows many UDC drivers to be
compiled, those options may turn to no longer be valid.  For
instance, if someone decides to build UDC that supports super
speed and UDC that supports high speed only, the latter will be
"assumed" to support super speed since USB_GADGET_SUPERSPEED will
be selected by the former.

The test of whether CONFIG_USB_GADGET_*SPEED was defined was just
an optimisation which removed otherwise dead code (ie. if UDC is
not dual speed, there is no need to handle cases that can happen
if speed is high).  This commit removes those checks.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 Hi,

 I've sent this patch quite a while ago but it did not got picked up
 for some reason.  Looking at the archives[1] I could not figure out
 a reason why this patch should be omitted so I'm resending it.

 This is rebase on top of v3.6-rc3.

 [1] https://groups.google.com/forum/?fromgroups=#!topic/linux.kernel/cUOFAhPGNhE

 drivers/usb/chipidea/Kconfig   |    1 -
 drivers/usb/dwc3/Kconfig       |    2 --
 drivers/usb/gadget/Kconfig     |   25 -------------------------
 drivers/usb/gadget/composite.c |    9 +--------
 drivers/usb/gadget/inode.c     |   15 ++++-----------
 drivers/usb/gadget/u_ether.c   |    7 -------
 drivers/usb/musb/Kconfig       |    1 -
 include/linux/usb/gadget.h     |   19 ++-----------------
 8 files changed, 7 insertions(+), 72 deletions(-)

diff --git a/drivers/usb/chipidea/Kconfig b/drivers/usb/chipidea/Kconfig
index 47e499c..1ea932a 100644
--- a/drivers/usb/chipidea/Kconfig
+++ b/drivers/usb/chipidea/Kconfig
@@ -13,7 +13,6 @@ if USB_CHIPIDEA
 config USB_CHIPIDEA_UDC
 	bool "ChipIdea device controller"
 	depends on USB_GADGET=y || USB_GADGET=USB_CHIPIDEA
-	select USB_GADGET_DUALSPEED
 	help
 	  Say Y here to enable device controller functionality of the
 	  ChipIdea driver.
diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
index d13c60f..f6a6e07 100644
--- a/drivers/usb/dwc3/Kconfig
+++ b/drivers/usb/dwc3/Kconfig
@@ -2,8 +2,6 @@ config USB_DWC3
 	tristate "DesignWare USB3 DRD Core Support"
 	depends on (USB && USB_GADGET)
 	select USB_OTG_UTILS
-	select USB_GADGET_DUALSPEED
-	select USB_GADGET_SUPERSPEED
 	select USB_XHCI_PLATFORM if USB_SUPPORT && USB_XHCI_HCD
 	help
 	  Say Y or M here if your system has a Dual Role SuperSpeed
diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 51ab5fd..2ba0d0e 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -154,7 +154,6 @@ config USB_LPC32XX
 
 config USB_ATMEL_USBA
 	tristate "Atmel USBA"
-	select USB_GADGET_DUALSPEED
 	depends on AVR32 || ARCH_AT91SAM9RL || ARCH_AT91SAM9G45
 	help
 	  USBA is the integrated high-speed USB Device controller on
@@ -163,7 +162,6 @@ config USB_ATMEL_USBA
 config USB_FSL_USB2
 	tristate "Freescale Highspeed USB DR Peripheral Controller"
 	depends on FSL_SOC || ARCH_MXC
-	select USB_GADGET_DUALSPEED
 	select USB_FSL_MPH_DR_OF if OF
 	help
 	   Some of Freescale PowerPC and i.MX processors have a High Speed
@@ -179,7 +177,6 @@ config USB_FSL_USB2
 config USB_FUSB300
 	tristate "Faraday FUSB300 USB Peripheral Controller"
 	depends on !PHYS_ADDR_T_64BIT
-	select USB_GADGET_DUALSPEED
 	help
 	   Faraday usb device controller FUSB300 driver
 
@@ -227,7 +224,6 @@ config USB_PXA25X_SMALL
 
 config USB_R8A66597
 	tristate "Renesas R8A66597 USB Peripheral Controller"
-	select USB_GADGET_DUALSPEED
 	help
 	   R8A66597 is a discrete USB host and peripheral controller chip that
 	   supports both full and high speed USB 2.0 data transfers.
@@ -240,7 +236,6 @@ config USB_R8A66597
 config USB_RENESAS_USBHS_UDC
 	tristate 'Renesas USBHS controller'
 	depends on USB_RENESAS_USBHS
-	select USB_GADGET_DUALSPEED
 	help
 	   Renesas USBHS is a discrete USB host and peripheral controller chip
 	   that supports both full and high speed USB 2.0 data transfers.
@@ -268,7 +263,6 @@ config USB_PXA27X
 config USB_S3C_HSOTG
 	tristate "S3C HS/OtG USB Device controller"
 	depends on S3C_DEV_USB_HSOTG
-	select USB_GADGET_DUALSPEED
 	help
 	  The Samsung S3C64XX USB2.0 high-speed gadget controller
 	  integrated into the S3C64XX series SoC.
@@ -305,7 +299,6 @@ config USB_S3C2410_DEBUG
 config USB_S3C_HSUDC
 	tristate "S3C2416, S3C2443 and S3C2450 USB Device Controller"
 	depends on ARCH_S3C24XX
-	select USB_GADGET_DUALSPEED
 	help
 	  Samsung's S3C2416, S3C2443 and S3C2450 is an ARM9 based SoC
 	  integrated with dual speed USB 2.0 device controller. It has
@@ -315,7 +308,6 @@ config USB_S3C_HSUDC
 
 config USB_MV_UDC
 	tristate "Marvell USB2.0 Device Controller"
-	select USB_GADGET_DUALSPEED
 	help
 	  Marvell Socs (including PXA and MMP series) include a high speed
 	  USB2.0 OTG controller, which can be configured as high speed or
@@ -338,14 +330,12 @@ config USB_MV_U3D
 config USB_GADGET_MUSB_HDRC
 	tristate "Inventra HDRC USB Peripheral (TI, ADI, ...)"
 	depends on USB_MUSB_HDRC
-	select USB_GADGET_DUALSPEED
 	help
 	  This OTG-capable silicon IP is used in dual designs including
 	  the TI DaVinci, OMAP 243x, OMAP 343x, TUSB 6010, and ADI Blackfin
 
 config USB_M66592
 	tristate "Renesas M66592 USB Peripheral Controller"
-	select USB_GADGET_DUALSPEED
 	help
 	   M66592 is a discrete USB peripheral controller chip that
 	   supports both full and high speed USB 2.0 data transfers.
@@ -362,7 +352,6 @@ config USB_M66592
 config USB_AMD5536UDC
 	tristate "AMD5536 UDC"
 	depends on PCI
-	select USB_GADGET_DUALSPEED
 	help
 	   The AMD5536 UDC is part of the AMD Geode CS5536, an x86 southbridge.
 	   It is a USB Highspeed DMA capable USB device controller. Beside ep0
@@ -389,7 +378,6 @@ config USB_FSL_QE
 
 config USB_NET2272
 	tristate "PLX NET2272"
-	select USB_GADGET_DUALSPEED
 	help
 	  PLX NET2272 is a USB peripheral controller which supports
 	  both full and high speed USB 2.0 data transfers.
@@ -413,7 +401,6 @@ config USB_NET2272_DMA
 config USB_NET2280
 	tristate "NetChip 228x"
 	depends on PCI
-	select USB_GADGET_DUALSPEED
 	help
 	   NetChip 2280 / 2282 is a PCI based USB peripheral controller which
 	   supports both full and high speed USB 2.0 data transfers.
@@ -443,7 +430,6 @@ config USB_GOKU
 config USB_EG20T
 	tristate "Intel EG20T PCH/LAPIS Semiconductor IOH(ML7213/ML7831) UDC"
 	depends on PCI
-	select USB_GADGET_DUALSPEED
 	help
 	  This is a USB device driver for EG20T PCH.
 	  EG20T PCH is the platform controller hub that is used in Intel's
@@ -470,8 +456,6 @@ config USB_EG20T
 config USB_DUMMY_HCD
 	tristate "Dummy HCD (DEVELOPMENT)"
 	depends on USB=y || (USB=m && USB_GADGET=m)
-	select USB_GADGET_DUALSPEED
-	select USB_GADGET_SUPERSPEED
 	help
 	  This host controller driver emulates USB, looping all data transfer
 	  requests back to a USB "gadget driver" in the same host.  The host
@@ -496,15 +480,6 @@ config USB_DUMMY_HCD
 
 endmenu
 
-# Selected by UDC drivers that support high-speed operation.
-config USB_GADGET_DUALSPEED
-	bool
-
-# Selected by UDC drivers that support super-speed opperation
-config USB_GADGET_SUPERSPEED
-	bool
-	depends on USB_GADGET_DUALSPEED
-
 #
 # USB Gadget Drivers
 #
diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 3f72110..f8a481c 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1585,12 +1585,6 @@ composite_resume(struct usb_gadget *gadget)
 /*-------------------------------------------------------------------------*/
 
 static struct usb_gadget_driver composite_driver = {
-#ifdef CONFIG_USB_GADGET_SUPERSPEED
-	.max_speed	= USB_SPEED_SUPER,
-#else
-	.max_speed	= USB_SPEED_HIGH,
-#endif
-
 	.unbind		= composite_unbind,
 
 	.setup		= composite_setup,
@@ -1635,8 +1629,7 @@ int usb_composite_probe(struct usb_composite_driver *driver,
 		driver->iProduct = driver->name;
 	composite_driver.function =  (char *) driver->name;
 	composite_driver.driver.name = driver->name;
-	composite_driver.max_speed =
-		min_t(u8, composite_driver.max_speed, driver->max_speed);
+	composite_driver.max_speed = driver->max_speed;
 	composite = driver;
 	composite_gadget_bind = bind;
 
diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index e58b164..ae13a10 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -828,7 +828,6 @@ ep_config (struct file *fd, const char __user *buf, size_t len, loff_t *ptr)
 		if (value == 0)
 			data->state = STATE_EP_ENABLED;
 		break;
-#ifdef	CONFIG_USB_GADGET_DUALSPEED
 	case USB_SPEED_HIGH:
 		/* fails if caller didn't provide that descriptor... */
 		ep->desc = &data->hs_desc;
@@ -836,7 +835,6 @@ ep_config (struct file *fd, const char __user *buf, size_t len, loff_t *ptr)
 		if (value == 0)
 			data->state = STATE_EP_ENABLED;
 		break;
-#endif
 	default:
 		DBG(data->dev, "unconnected, %s init abandoned\n",
 				data->name);
@@ -1324,7 +1322,6 @@ static const struct file_operations ep0_io_operations = {
  * Unrecognized ep0 requests may be handled in user space.
  */
 
-#ifdef	CONFIG_USB_GADGET_DUALSPEED
 static void make_qualifier (struct dev_data *dev)
 {
 	struct usb_qualifier_descriptor		qual;
@@ -1347,7 +1344,6 @@ static void make_qualifier (struct dev_data *dev)
 
 	memcpy (dev->rbuf, &qual, sizeof qual);
 }
-#endif
 
 static int
 config_buf (struct dev_data *dev, u8 type, unsigned index)
@@ -1427,7 +1423,6 @@ gadgetfs_setup (struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 			dev->dev->bMaxPacketSize0 = dev->gadget->ep0->maxpacket;
 			req->buf = dev->dev;
 			break;
-#ifdef	CONFIG_USB_GADGET_DUALSPEED
 		case USB_DT_DEVICE_QUALIFIER:
 			if (!dev->hs_config)
 				break;
@@ -1437,7 +1432,6 @@ gadgetfs_setup (struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 			break;
 		case USB_DT_OTHER_SPEED_CONFIG:
 			// FALLTHROUGH
-#endif
 		case USB_DT_CONFIG:
 			value = config_buf (dev,
 					w_value >> 8,
@@ -1763,11 +1757,6 @@ gadgetfs_suspend (struct usb_gadget *gadget)
 }
 
 static struct usb_gadget_driver gadgetfs_driver = {
-#ifdef	CONFIG_USB_GADGET_DUALSPEED
-	.max_speed	= USB_SPEED_HIGH,
-#else
-	.max_speed	= USB_SPEED_FULL,
-#endif
 	.function	= (char *) driver_desc,
 	.unbind		= gadgetfs_unbind,
 	.setup		= gadgetfs_setup,
@@ -1900,6 +1889,10 @@ dev_config (struct file *fd, const char __user *buf, size_t len, loff_t *ptr)
 
 	/* triggers gadgetfs_bind(); then we can enumerate. */
 	spin_unlock_irq (&dev->lock);
+	if (dev->hs_config)
+		gadgetfs_driver.max_speed = USB_SPEED_HIGH;
+	else
+		gadgetfs_driver.max_speed = USB_SPEED_FULL;
 	value = usb_gadget_probe_driver(&gadgetfs_driver, gadgetfs_bind);
 	if (value != 0) {
 		kfree (dev->buf);
diff --git a/drivers/usb/gadget/u_ether.c b/drivers/usb/gadget/u_ether.c
index 0e52309..7631d97 100644
--- a/drivers/usb/gadget/u_ether.c
+++ b/drivers/usb/gadget/u_ether.c
@@ -83,17 +83,10 @@ struct eth_dev {
 
 #define DEFAULT_QLEN	2	/* double buffering by default */
 
-
-#ifdef CONFIG_USB_GADGET_DUALSPEED
-
 static unsigned qmult = 5;
 module_param(qmult, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(qmult, "queue length multiplier at high/super speed");
 
-#else	/* full speed (low speed doesn't do bulk) */
-#define qmult		1
-#endif
-
 /* for dual-speed hardware, use deeper queues at high/super speed */
 static inline int qlen(struct usb_gadget *gadget)
 {
diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index 6259f0d..09f6856 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -12,7 +12,6 @@ config USB_MUSB_HDRC
 	select TWL4030_USB if MACH_OMAP_3430SDP
 	select TWL6030_USB if MACH_OMAP_4430SDP || MACH_OMAP4_PANDA
 	select USB_OTG_UTILS
-	select USB_GADGET_DUALSPEED
 	help
 	  Say Y here if your system has a dual role high speed USB
 	  controller based on the Mentor Graphics silicon IP.  Then
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index 9517466..d05b220 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -558,14 +558,7 @@ static inline struct usb_gadget *dev_to_usb_gadget(struct device *dev)
  */
 static inline int gadget_is_dualspeed(struct usb_gadget *g)
 {
-#ifdef CONFIG_USB_GADGET_DUALSPEED
-	/* runtime test would check "g->max_speed" ... that might be
-	 * useful to work around hardware bugs, but is mostly pointless
-	 */
-	return 1;
-#else
-	return 0;
-#endif
+	return g->max_speed >= USB_SPEED_HIGH;
 }
 
 /**
@@ -575,15 +568,7 @@ static inline int gadget_is_dualspeed(struct usb_gadget *g)
  */
 static inline int gadget_is_superspeed(struct usb_gadget *g)
 {
-#ifdef CONFIG_USB_GADGET_SUPERSPEED
-	/*
-	 * runtime test would check "g->max_speed" ... that might be
-	 * useful to work around hardware bugs, but is mostly pointless
-	 */
-	return 1;
-#else
-	return 0;
-#endif
+	return g->max_speed >= USB_SPEED_SUPER;
 }
 
 /**
-- 
1.7.7.3

