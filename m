Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab1HZNTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 09:19:01 -0400
Received: from smtp-out.google.com ([74.125.121.67]:32792 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab1HZNS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 09:18:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:date:message-id:x-mailer:
	in-reply-to:references:x-system-of-record;
	b=Yr+6yP6eFaQOLQgfkFtP22n5nFaXVc2UGs6Hr+AJ4GZrs5o/qmM5XF0ORXfrzhdZH
	KBBv1nKGPSHsWbpIF62jA==
From: Michal Nazarewicz <mnazarewicz@google.com>
To: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>
Cc: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Dave Young" <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv5 4/4] usb: gadget: get rid of USB_GADGET_{DUAL,SUPER}SPEED
Date: Fri, 26 Aug 2011 15:18:37 +0200
Message-Id: <4b5e561ce923ca69b17ecb183e21e2520e977799.1314364323.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1314364322.git.mina86@mina86.com>
References: <cover.1314364322.git.mina86@mina86.com>
X-System-Of-Record: true
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
---
 drivers/usb/gadget/Kconfig        |   32 --------------------------------
 drivers/usb/gadget/composite.c    |    9 +--------
 drivers/usb/gadget/file_storage.c |    4 ----
 drivers/usb/gadget/inode.c        |   15 ++++-----------
 drivers/usb/gadget/printer.c      |   37 +++++--------------------------------
 drivers/usb/gadget/u_ether.c      |    7 -------
 include/linux/usb/gadget.h        |   19 ++-----------------
 7 files changed, 12 insertions(+), 111 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index fe56379..168fb3b 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -133,7 +133,6 @@ config USB_AT91
 
 config USB_ATMEL_USBA
 	tristate "Atmel USBA"
-	select USB_GADGET_DUALSPEED
 	depends on AVR32 || ARCH_AT91CAP9 || ARCH_AT91SAM9RL || ARCH_AT91SAM9G45
 	help
 	  USBA is the integrated high-speed USB Device controller on
@@ -142,7 +141,6 @@ config USB_ATMEL_USBA
 config USB_FSL_USB2
 	tristate "Freescale Highspeed USB DR Peripheral Controller"
 	depends on FSL_SOC || ARCH_MXC
-	select USB_GADGET_DUALSPEED
 	select USB_FSL_MPH_DR_OF if OF
 	help
 	   Some of Freescale PowerPC processors have a High Speed
@@ -158,7 +156,6 @@ config USB_FSL_USB2
 config USB_FUSB300
 	tristate "Faraday FUSB300 USB Peripheral Controller"
 	depends on !PHYS_ADDR_T_64BIT
-	select USB_GADGET_DUALSPEED
 	help
 	   Faraday usb device controller FUSB300 driver
 
@@ -206,7 +203,6 @@ config USB_PXA25X_SMALL
 
 config USB_R8A66597
 	tristate "Renesas R8A66597 USB Peripheral Controller"
-	select USB_GADGET_DUALSPEED
 	help
 	   R8A66597 is a discrete USB host and peripheral controller chip that
 	   supports both full and high speed USB 2.0 data transfers.
@@ -220,7 +216,6 @@ config USB_RENESAS_USBHS_UDC
 	tristate 'Renesas USBHS controller'
 	depends on SUPERH || ARCH_SHMOBILE
 	depends on USB_RENESAS_USBHS
-	select USB_GADGET_DUALSPEED
 	help
 	   Renesas USBHS is a discrete USB host and peripheral controller chip
 	   that supports both full and high speed USB 2.0 data transfers.
@@ -249,7 +244,6 @@ config USB_S3C_HSOTG
 	tristate "S3C HS/OtG USB Device controller"
 	depends on S3C_DEV_USB_HSOTG
 	select USB_GADGET_S3C_HSOTG_PIO
-	select USB_GADGET_DUALSPEED
 	help
 	  The Samsung S3C64XX USB2.0 high-speed gadget controller
 	  integrated into the S3C64XX series SoC.
@@ -286,7 +280,6 @@ config USB_S3C2410_DEBUG
 config USB_S3C_HSUDC
 	tristate "S3C2416, S3C2443 and S3C2450 USB Device Controller"
 	depends on ARCH_S3C2410
-	select USB_GADGET_DUALSPEED
 	help
 	  Samsung's S3C2416, S3C2443 and S3C2450 is an ARM9 based SoC
 	  integrated with dual speed USB 2.0 device controller. It has
@@ -297,7 +290,6 @@ config USB_S3C_HSUDC
 config USB_PXA_U2O
 	tristate "PXA9xx Processor USB2.0 controller"
 	depends on ARCH_MMP
-	select USB_GADGET_DUALSPEED
 	help
 	  PXA9xx Processor series include a high speed USB2.0 device
 	  controller, which support high speed and full speed USB peripheral.
@@ -305,8 +297,6 @@ config USB_PXA_U2O
 config USB_GADGET_DWC3
 	tristate "DesignWare USB3.0 (DRD) Controller"
 	depends on USB_DWC3
-	select USB_GADGET_DUALSPEED
-	select USB_GADGET_SUPERSPEED
 	help
 	  DesignWare USB3.0 controller is a SuperSpeed USB3.0 Controller
 	  which can be configured for peripheral-only, host-only, hub-only
@@ -322,14 +312,12 @@ config USB_GADGET_DWC3
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
@@ -346,7 +334,6 @@ config USB_M66592
 config USB_AMD5536UDC
 	tristate "AMD5536 UDC"
 	depends on PCI
-	select USB_GADGET_DUALSPEED
 	help
 	   The AMD5536 UDC is part of the AMD Geode CS5536, an x86 southbridge.
 	   It is a USB Highspeed DMA capable USB device controller. Beside ep0
@@ -374,7 +361,6 @@ config USB_FSL_QE
 config USB_CI13XXX_PCI
 	tristate "MIPS USB CI13xxx PCI UDC"
 	depends on PCI
-	select USB_GADGET_DUALSPEED
 	help
 	  MIPS USB IP core family device controller
 	  Currently it only supports IP part number CI13412
@@ -385,7 +371,6 @@ config USB_CI13XXX_PCI
 
 config USB_NET2272
 	tristate "PLX NET2272"
-	select USB_GADGET_DUALSPEED
 	help
 	  PLX NET2272 is a USB peripheral controller which supports
 	  both full and high speed USB 2.0 data transfers.
@@ -409,7 +394,6 @@ config USB_NET2272_DMA
 config USB_NET2280
 	tristate "NetChip 228x"
 	depends on PCI
-	select USB_GADGET_DUALSPEED
 	help
 	   NetChip 2280 / 2282 is a PCI based USB peripheral controller which
 	   supports both full and high speed USB 2.0 data transfers.
@@ -440,7 +424,6 @@ config USB_LANGWELL
 	tristate "Intel Langwell USB Device Controller"
 	depends on PCI
 	depends on !PHYS_ADDR_T_64BIT
-	select USB_GADGET_DUALSPEED
 	help
 	   Intel Langwell USB Device Controller is a High-Speed USB
 	   On-The-Go device controller.
@@ -455,7 +438,6 @@ config USB_LANGWELL
 config USB_EG20T
 	tristate "Intel EG20T PCH/OKI SEMICONDUCTOR ML7213 IOH UDC"
 	depends on PCI
-	select USB_GADGET_DUALSPEED
 	help
 	  This is a USB device driver for EG20T PCH.
 	  EG20T PCH is the platform controller hub that is used in Intel's
@@ -477,7 +459,6 @@ config USB_EG20T
 config USB_CI13XXX_MSM
 	tristate "MIPS USB CI13xxx for MSM"
 	depends on ARCH_MSM
-	select USB_GADGET_DUALSPEED
 	select USB_MSM_OTG
 	help
 	  MSM SoC has chipidea USB controller.  This driver uses
@@ -498,8 +479,6 @@ config USB_CI13XXX_MSM
 config USB_DUMMY_HCD
 	tristate "Dummy HCD (DEVELOPMENT)"
 	depends on USB=y || (USB=m && USB_GADGET=m)
-	select USB_GADGET_DUALSPEED
-	select USB_GADGET_SUPERSPEED
 	help
 	  This host controller driver emulates USB, looping all data transfer
 	  requests back to a USB "gadget driver" in the same host.  The host
@@ -524,17 +503,6 @@ config USB_DUMMY_HCD
 
 endchoice
 
-# Selected by UDC drivers that support high-speed operation.
-config USB_GADGET_DUALSPEED
-	bool
-	depends on USB_GADGET
-
-# Selected by UDC drivers that support super-speed opperation
-config USB_GADGET_SUPERSPEED
-	bool
-	depends on USB_GADGET
-	depends on USB_GADGET_DUALSPEED
-
 #
 # USB Gadget Drivers
 #
diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 13c5689..88122ec 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1542,12 +1542,6 @@ composite_resume(struct usb_gadget *gadget)
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
@@ -1592,8 +1586,7 @@ int usb_composite_probe(struct usb_composite_driver *driver,
 		driver->iProduct = driver->name;
 	composite_driver.function =  (char *) driver->name;
 	composite_driver.driver.name = driver->name;
-	composite_driver.max_speed = min((u8)composite_driver.max_speed,
-					 (u8)driver->max_speed);
+	composite_driver.max_speed = driver->max_speed;
 	composite = driver;
 	composite_gadget_bind = bind;
 
diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index 3a50196..8e8daf2 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -3554,11 +3554,7 @@ static void fsg_resume(struct usb_gadget *gadget)
 /*-------------------------------------------------------------------------*/
 
 static struct usb_gadget_driver		fsg_driver = {
-#ifdef CONFIG_USB_GADGET_DUALSPEED
 	.max_speed	= USB_SPEED_HIGH,
-#else
-	.max_speed	= USB_SPEED_FULL,
-#endif
 	.function	= (char *) fsg_string_product,
 	.unbind		= fsg_unbind,
 	.disconnect	= fsg_disconnect,
diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index 4bd48ea..fee9ef3 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -837,7 +837,6 @@ ep_config (struct file *fd, const char __user *buf, size_t len, loff_t *ptr)
 		if (value == 0)
 			data->state = STATE_EP_ENABLED;
 		break;
-#ifdef	CONFIG_USB_GADGET_DUALSPEED
 	case USB_SPEED_HIGH:
 		/* fails if caller didn't provide that descriptor... */
 		ep->desc = &data->hs_desc;
@@ -845,7 +844,6 @@ ep_config (struct file *fd, const char __user *buf, size_t len, loff_t *ptr)
 		if (value == 0)
 			data->state = STATE_EP_ENABLED;
 		break;
-#endif
 	default:
 		DBG(data->dev, "unconnected, %s init abandoned\n",
 				data->name);
@@ -1331,7 +1329,6 @@ static const struct file_operations ep0_io_operations = {
  * Unrecognized ep0 requests may be handled in user space.
  */
 
-#ifdef	CONFIG_USB_GADGET_DUALSPEED
 static void make_qualifier (struct dev_data *dev)
 {
 	struct usb_qualifier_descriptor		qual;
@@ -1354,7 +1351,6 @@ static void make_qualifier (struct dev_data *dev)
 
 	memcpy (dev->rbuf, &qual, sizeof qual);
 }
-#endif
 
 static int
 config_buf (struct dev_data *dev, u8 type, unsigned index)
@@ -1434,7 +1430,6 @@ gadgetfs_setup (struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 			dev->dev->bMaxPacketSize0 = dev->gadget->ep0->maxpacket;
 			req->buf = dev->dev;
 			break;
-#ifdef	CONFIG_USB_GADGET_DUALSPEED
 		case USB_DT_DEVICE_QUALIFIER:
 			if (!dev->hs_config)
 				break;
@@ -1444,7 +1439,6 @@ gadgetfs_setup (struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 			break;
 		case USB_DT_OTHER_SPEED_CONFIG:
 			// FALLTHROUGH
-#endif
 		case USB_DT_CONFIG:
 			value = config_buf (dev,
 					w_value >> 8,
@@ -1773,11 +1767,6 @@ gadgetfs_suspend (struct usb_gadget *gadget)
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
@@ -1910,6 +1899,10 @@ dev_config (struct file *fd, const char __user *buf, size_t len, loff_t *ptr)
 
 	/* triggers gadgetfs_bind(); then we can enumerate. */
 	spin_unlock_irq (&dev->lock);
+	if (dev->hs_config)
+		gadgetfs_driver.max_speed = USB_SPEED_HIGH;
+	else
+		gadgetfs_driver.max_speed = USB_SPEED_FULL;
 	value = usb_gadget_probe_driver(&gadgetfs_driver, gadgetfs_bind);
 	if (value != 0) {
 		kfree (dev->buf);
diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
index 2b9965b..0595c75 100644
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -164,12 +164,6 @@ module_param(qlen, uint, S_IRUGO|S_IWUSR);
 
 #define QLEN	qlen
 
-#ifdef CONFIG_USB_GADGET_DUALSPEED
-#define DEVSPEED	USB_SPEED_HIGH
-#else   /* full speed (low speed doesn't do bulk) */
-#define DEVSPEED        USB_SPEED_FULL
-#endif
-
 /*-------------------------------------------------------------------------*/
 
 #define xprintk(d, level, fmt, args...) \
@@ -288,8 +282,6 @@ static const struct usb_descriptor_header *fs_printer_function [11] = {
 	NULL
 };
 
-#ifdef	CONFIG_USB_GADGET_DUALSPEED
-
 /*
  * usb 2.0 devices need to expose both high speed and full speed
  * descriptors, unless they only run at full speed.
@@ -328,13 +320,6 @@ static const struct usb_descriptor_header *hs_printer_function [11] = {
 /* maxpacket and other transfer characteristics vary by speed. */
 #define ep_desc(g, hs, fs) (((g)->speed == USB_SPEED_HIGH)?(hs):(fs))
 
-#else
-
-/* if there's no high speed support, maxpacket doesn't change. */
-#define ep_desc(g, hs, fs) (((void)(g)), (fs))
-
-#endif	/* !CONFIG_USB_GADGET_DUALSPEED */
-
 /*-------------------------------------------------------------------------*/
 
 /* descriptors that are built on-demand */
@@ -990,23 +975,15 @@ config_buf(enum usb_device_speed speed, u8 *buf, u8 type, unsigned index,
 {
 	int					len;
 	const struct usb_descriptor_header	**function;
-#ifdef CONFIG_USB_GADGET_DUALSPEED
 	int					hs = (speed == USB_SPEED_HIGH);
 
+	if (index >= device_desc.bNumConfigurations)
+		return -EINVAL;
+
 	if (type == USB_DT_OTHER_SPEED_CONFIG)
 		hs = !hs;
 
-	if (hs) {
-		function = hs_printer_function;
-	} else {
-		function = fs_printer_function;
-	}
-#else
-	function = fs_printer_function;
-#endif
-
-	if (index >= device_desc.bNumConfigurations)
-		return -EINVAL;
+	function = hs ? hs_printer_function : fs_printer_function;
 
 	/* for now, don't advertise srp-only devices */
 	if (!is_otg)
@@ -1148,7 +1125,6 @@ printer_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 				value = min(wLength, (u16) sizeof device_desc);
 				memcpy(req->buf, &device_desc, value);
 				break;
-#ifdef CONFIG_USB_GADGET_DUALSPEED
 			case USB_DT_DEVICE_QUALIFIER:
 				if (!gadget_is_dualspeed(gadget))
 					break;
@@ -1167,7 +1143,6 @@ printer_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 				if (!gadget_is_dualspeed(gadget))
 					break;
 				/* FALLTHROUGH */
-#endif /* CONFIG_USB_GADGET_DUALSPEED */
 			case USB_DT_CONFIG:
 				value = config_buf(gadget->speed, req->buf,
 						wValue >> 8,
@@ -1452,11 +1427,9 @@ autoconf_fail:
 		goto autoconf_fail;
 	out_ep->driver_data = out_ep;	/* claim */
 
-#ifdef	CONFIG_USB_GADGET_DUALSPEED
 	/* assumes that all endpoints are dual-speed */
 	hs_ep_in_desc.bEndpointAddress = fs_ep_in_desc.bEndpointAddress;
 	hs_ep_out_desc.bEndpointAddress = fs_ep_out_desc.bEndpointAddress;
-#endif	/* DUALSPEED */
 
 	usb_gadget_set_selfpowered(gadget);
 
@@ -1544,7 +1517,7 @@ fail:
 /*-------------------------------------------------------------------------*/
 
 static struct usb_gadget_driver printer_driver = {
-	.max_speed	= DEVSPEED,
+	.max_speed	= USB_SPEED_HIGH,
 
 	.function	= (char *) driver_desc,
 	.unbind		= printer_unbind,
diff --git a/drivers/usb/gadget/u_ether.c b/drivers/usb/gadget/u_ether.c
index dfed4c1..8642abb 100644
--- a/drivers/usb/gadget/u_ether.c
+++ b/drivers/usb/gadget/u_ether.c
@@ -92,17 +92,10 @@ struct eth_dev {
 
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
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index c8ea048..22404cf 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -548,14 +548,7 @@ static inline struct usb_gadget *dev_to_usb_gadget(struct device *dev)
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
@@ -565,15 +558,7 @@ static inline int gadget_is_dualspeed(struct usb_gadget *g)
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
1.7.3.1

