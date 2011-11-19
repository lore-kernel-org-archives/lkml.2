Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab1KSR1x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 12:27:53 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48930 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab1KSR1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 12:27:51 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH 2/3] usb: gadget: replace usb_gadget::is_dualspeed with max_speed
Date: Sat, 19 Nov 2011 18:27:37 +0100
Message-Id: <e484c31d52744be95bc87f36561e5b1e5d6c2af9.1321719300.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <12833fb1f3db020248c582c1f947724056a34fe2.1321719300.git.mina86@mina86.com>
References: <12833fb1f3db020248c582c1f947724056a34fe2.1321719300.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit replaces usb_gadget's is_dualspeed field with
a max_speed field.

[ balbi@ti.com : Fixed DWC3 driver ]

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 Documentation/feature-removal-schedule.txt |   14 ++++++++++++++
 drivers/usb/dwc3/gadget.c                  |    2 +-
 drivers/usb/gadget/amd5536udc.c            |    2 +-
 drivers/usb/gadget/atmel_usba_udc.c        |    2 +-
 drivers/usb/gadget/ci13xxx_udc.c           |    7 +++++--
 drivers/usb/gadget/dummy_hcd.c             |    2 +-
 drivers/usb/gadget/epautoconf.c            |    6 +++---
 drivers/usb/gadget/fsl_udc_core.c          |    2 +-
 drivers/usb/gadget/fusb300_udc.c           |    2 +-
 drivers/usb/gadget/goku_udc.c              |    1 +
 drivers/usb/gadget/langwell_udc.c          |    2 +-
 drivers/usb/gadget/m66592-udc.c            |    2 +-
 drivers/usb/gadget/mv_udc_core.c           |    2 +-
 drivers/usb/gadget/net2272.c               |    2 +-
 drivers/usb/gadget/net2280.c               |    2 +-
 drivers/usb/gadget/omap_udc.c              |    1 +
 drivers/usb/gadget/pch_udc.c               |    2 +-
 drivers/usb/gadget/printer.c               |    4 ++--
 drivers/usb/gadget/r8a66597-udc.c          |    2 +-
 drivers/usb/gadget/s3c-hsotg.c             |    2 +-
 drivers/usb/gadget/s3c-hsudc.c             |    2 +-
 drivers/usb/gadget/udc-core.c              |   26 ++++++++++++++++++++------
 drivers/usb/musb/musb_gadget.c             |    2 +-
 drivers/usb/renesas_usbhs/mod_gadget.c     |    2 +-
 include/linux/usb/gadget.h                 |   10 +++++-----
 25 files changed, 68 insertions(+), 35 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 3d84912..a7e4ac1 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -535,6 +535,20 @@ Why:    In 3.0, we can now autodetect internal 3G device and already have
 	information log when acer-wmi initial.
 Who:    Lee, Chun-Yi <jlee@novell.com>
 
+---------------------------
+
+What:	/sys/devices/platform/_UDC_/udc/_UDC_/is_dualspeed file and
+	is_dualspeed line in /sys/devices/platform/ci13xxx_*/udc/device file.
+When:	3.8
+Why:	The is_dualspeed file is superseded by maximum_speed in the same
+	directory and is_dualspeed line in device file is superseded by
+	max_speed line in the same file.
+
+	The maximum_speed/max_speed specifies maximum speed supported by UDC.
+	To check if dualspeeed is supported, check if the value is >= 3.
+	Various possible speeds are defined in <linux/usb/ch9.h>.
+Who:	Michal Nazarewicz <mina86@mina86.com>
+
 ----------------------------
 
 What:	The XFS nodelaylog mount option
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 25dbd86..5802720 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1986,7 +1986,7 @@ int __devinit dwc3_gadget_init(struct dwc3 *dwc)
 	dev_set_name(&dwc->gadget.dev, "gadget");
 
 	dwc->gadget.ops			= &dwc3_gadget_ops;
-	dwc->gadget.is_dualspeed	= true;
+	dwc->gadget.max_speed		= USB_SPEED_SUPER;
 	dwc->gadget.speed		= USB_SPEED_UNKNOWN;
 	dwc->gadget.dev.parent		= dwc->dev;
 
diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index 45f422a..e69cdbc 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -3349,7 +3349,7 @@ static int udc_probe(struct udc *dev)
 	dev_set_name(&dev->gadget.dev, "gadget");
 	dev->gadget.dev.release = gadget_release;
 	dev->gadget.name = name;
-	dev->gadget.is_dualspeed = 1;
+	dev->gadget.max_speed = USB_SPEED_HIGH;
 
 	/* init registers, interrupts, ... */
 	startup_registers(dev);
diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
index 271a9d8..e2fb6d5 100644
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -1038,7 +1038,7 @@ static struct usba_udc the_udc = {
 	.gadget	= {
 		.ops		= &usba_udc_ops,
 		.ep_list	= LIST_HEAD_INIT(the_udc.gadget.ep_list),
-		.is_dualspeed	= 1,
+		.max_speed	= USB_SPEED_HIGH,
 		.name		= "atmel_usba_udc",
 		.dev	= {
 			.init_name	= "gadget",
diff --git a/drivers/usb/gadget/ci13xxx_udc.c b/drivers/usb/gadget/ci13xxx_udc.c
index 9a0c397..4347ecc 100644
--- a/drivers/usb/gadget/ci13xxx_udc.c
+++ b/drivers/usb/gadget/ci13xxx_udc.c
@@ -754,8 +754,11 @@ static ssize_t show_device(struct device *dev, struct device_attribute *attr,
 
 	n += scnprintf(buf + n, PAGE_SIZE - n, "speed             = %d\n",
 		       gadget->speed);
+	n += scnprintf(buf + n, PAGE_SIZE - n, "max_speed         = %d\n",
+		       gadget->max_speed);
+	/* TODO: Scheduled for removal in 3.8. */
 	n += scnprintf(buf + n, PAGE_SIZE - n, "is_dualspeed      = %d\n",
-		       gadget->is_dualspeed);
+		       gadget_is_dualspeed(gadget));
 	n += scnprintf(buf + n, PAGE_SIZE - n, "is_otg            = %d\n",
 		       gadget->is_otg);
 	n += scnprintf(buf + n, PAGE_SIZE - n, "is_a_peripheral   = %d\n",
@@ -2871,7 +2874,7 @@ static int udc_probe(struct ci13xxx_udc_driver *driver, struct device *dev,
 
 	udc->gadget.ops          = &usb_gadget_ops;
 	udc->gadget.speed        = USB_SPEED_UNKNOWN;
-	udc->gadget.is_dualspeed = 1;
+	udc->gadget.max_speed    = USB_SPEED_HIGH;
 	udc->gadget.is_otg       = 0;
 	udc->gadget.name         = driver->name;
 
diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index ab8f1b4..cf235d8 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -977,7 +977,7 @@ static int dummy_udc_probe (struct platform_device *pdev)
 
 	dum->gadget.name = gadget_name;
 	dum->gadget.ops = &dummy_ops;
-	dum->gadget.is_dualspeed = 1;
+	dum->gadget.max_speed = USB_SPEED_SUPER;
 
 	dev_set_name(&dum->gadget.dev, "gadget");
 	dum->gadget.dev.parent = &pdev->dev;
diff --git a/drivers/usb/gadget/epautoconf.c b/drivers/usb/gadget/epautoconf.c
index 596a0b4..38bcbfb 100644
--- a/drivers/usb/gadget/epautoconf.c
+++ b/drivers/usb/gadget/epautoconf.c
@@ -152,7 +152,7 @@ ep_matches (
 	switch (type) {
 	case USB_ENDPOINT_XFER_INT:
 		/* INT:  limit 64 bytes full speed, 1024 high/super speed */
-		if (!gadget->is_dualspeed && max > 64)
+		if (!gadget_is_dualspeed(gadget) && max > 64)
 			return 0;
 		/* FALLTHROUGH */
 
@@ -160,12 +160,12 @@ ep_matches (
 		/* ISO:  limit 1023 bytes full speed, 1024 high/super speed */
 		if (ep->maxpacket < max)
 			return 0;
-		if (!gadget->is_dualspeed && max > 1023)
+		if (!gadget_is_dualspeed(gadget) && max > 1023)
 			return 0;
 
 		/* BOTH:  "high bandwidth" works only at high speed */
 		if ((desc->wMaxPacketSize & cpu_to_le16(3<<11))) {
-			if (!gadget->is_dualspeed)
+			if (!gadget_is_dualspeed(gadget))
 				return 0;
 			/* configure your hardware with enough buffering!! */
 		}
diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index 1482b12..77d6d22 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -2529,7 +2529,7 @@ static int __init fsl_udc_probe(struct platform_device *pdev)
 
 	/* Setup gadget structure */
 	udc_controller->gadget.ops = &fsl_gadget_ops;
-	udc_controller->gadget.is_dualspeed = 1;
+	udc_controller->gadget.max_speed = USB_SPEED_HIGH;
 	udc_controller->gadget.ep0 = &udc_controller->eps[0].ep;
 	INIT_LIST_HEAD(&udc_controller->gadget.ep_list);
 	udc_controller->gadget.speed = USB_SPEED_UNKNOWN;
diff --git a/drivers/usb/gadget/fusb300_udc.c b/drivers/usb/gadget/fusb300_udc.c
index 74da206..6e32a60 100644
--- a/drivers/usb/gadget/fusb300_udc.c
+++ b/drivers/usb/gadget/fusb300_udc.c
@@ -1463,7 +1463,7 @@ static int __init fusb300_probe(struct platform_device *pdev)
 
 	dev_set_name(&fusb300->gadget.dev, "gadget");
 
-	fusb300->gadget.is_dualspeed = 1;
+	fusb300->gadget.max_speed = USB_SPEED_HIGH;
 	fusb300->gadget.dev.parent = &pdev->dev;
 	fusb300->gadget.dev.dma_mask = pdev->dev.dma_mask;
 	fusb300->gadget.dev.release = pdev->dev.release;
diff --git a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc.c
index 7f87805..ab9c924 100644
--- a/drivers/usb/gadget/goku_udc.c
+++ b/drivers/usb/gadget/goku_udc.c
@@ -1796,6 +1796,7 @@ static int goku_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&dev->lock);
 	dev->pdev = pdev;
 	dev->gadget.ops = &goku_ops;
+	dev->gadget.max_speed = USB_SPEED_FULL;
 
 	/* the "gadget" abstracts/virtualizes the controller */
 	dev_set_name(&dev->gadget.dev, "gadget");
diff --git a/drivers/usb/gadget/langwell_udc.c b/drivers/usb/gadget/langwell_udc.c
index c9fa3bf..fa0fcc1 100644
--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@ -3267,7 +3267,7 @@ static int langwell_udc_probe(struct pci_dev *pdev,
 	dev->gadget.ep0 = &dev->ep[0].ep;	/* gadget ep0 */
 	INIT_LIST_HEAD(&dev->gadget.ep_list);	/* ep_list */
 	dev->gadget.speed = USB_SPEED_UNKNOWN;	/* speed */
-	dev->gadget.is_dualspeed = 1;		/* support dual speed */
+	dev->gadget.max_speed = USB_SPEED_HIGH;	/* support dual speed */
 #ifdef	OTG_TRANSCEIVER
 	dev->gadget.is_otg = 1;			/* support otg mode */
 #endif
diff --git a/drivers/usb/gadget/m66592-udc.c b/drivers/usb/gadget/m66592-udc.c
index 9aa1cbb..a7692c2 100644
--- a/drivers/usb/gadget/m66592-udc.c
+++ b/drivers/usb/gadget/m66592-udc.c
@@ -1653,7 +1653,7 @@ static int __init m66592_probe(struct platform_device *pdev)
 	m66592->gadget.ops = &m66592_gadget_ops;
 	device_initialize(&m66592->gadget.dev);
 	dev_set_name(&m66592->gadget.dev, "gadget");
-	m66592->gadget.is_dualspeed = 1;
+	m66592->gadget.max_speed = USB_SPEED_HIGH;
 	m66592->gadget.dev.parent = &pdev->dev;
 	m66592->gadget.dev.dma_mask = pdev->dev.dma_mask;
 	m66592->gadget.dev.release = pdev->dev.release;
diff --git a/drivers/usb/gadget/mv_udc_core.c b/drivers/usb/gadget/mv_udc_core.c
index 8924121..9376a74 100644
--- a/drivers/usb/gadget/mv_udc_core.c
+++ b/drivers/usb/gadget/mv_udc_core.c
@@ -2312,7 +2312,7 @@ static int __devinit mv_udc_probe(struct platform_device *dev)
 	udc->gadget.ep0 = &udc->eps[0].ep;	/* gadget ep0 */
 	INIT_LIST_HEAD(&udc->gadget.ep_list);	/* ep_list */
 	udc->gadget.speed = USB_SPEED_UNKNOWN;	/* speed */
-	udc->gadget.is_dualspeed = 1;		/* support dual speed */
+	udc->gadget.max_speed = USB_SPEED_HIGH;	/* support dual speed */
 
 	/* the "gadget" abstracts/virtualizes the controller */
 	dev_set_name(&udc->gadget.dev, "gadget");
diff --git a/drivers/usb/gadget/net2272.c b/drivers/usb/gadget/net2272.c
index d1b7636..d5050f4 100644
--- a/drivers/usb/gadget/net2272.c
+++ b/drivers/usb/gadget/net2272.c
@@ -2235,7 +2235,7 @@ net2272_probe_init(struct device *dev, unsigned int irq)
 	ret->irq = irq;
 	ret->dev = dev;
 	ret->gadget.ops = &net2272_ops;
-	ret->gadget.is_dualspeed = 1;
+	ret->gadget.max_speed = USB_SPEED_HIGH;
 
 	/* the "gadget" abstracts/virtualizes the controller */
 	dev_set_name(&ret->gadget.dev, "gadget");
diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index da2b9d0..9ee36fd 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -2698,7 +2698,7 @@ static int net2280_probe (struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init (&dev->lock);
 	dev->pdev = pdev;
 	dev->gadget.ops = &net2280_ops;
-	dev->gadget.is_dualspeed = 1;
+	dev->gadget.max_speed = USB_SPEED_HIGH;
 
 	/* the "gadget" abstracts/virtualizes the controller */
 	dev_set_name(&dev->gadget.dev, "gadget");
diff --git a/drivers/usb/gadget/omap_udc.c b/drivers/usb/gadget/omap_udc.c
index 788989a..ed01a0f 100644
--- a/drivers/usb/gadget/omap_udc.c
+++ b/drivers/usb/gadget/omap_udc.c
@@ -2676,6 +2676,7 @@ omap_udc_setup(struct platform_device *odev, struct otg_transceiver *xceiv)
 	INIT_LIST_HEAD(&udc->gadget.ep_list);
 	INIT_LIST_HEAD(&udc->iso);
 	udc->gadget.speed = USB_SPEED_UNKNOWN;
+	udc->gadget.max_speed = USB_SPEED_FULL;
 	udc->gadget.name = driver_name;
 
 	device_initialize(&udc->gadget.dev);
diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index 5048a0c..7f97b4a 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -2941,7 +2941,7 @@ static int pch_udc_probe(struct pci_dev *pdev,
 	dev->gadget.dev.dma_mask = pdev->dev.dma_mask;
 	dev->gadget.dev.release = gadget_release;
 	dev->gadget.name = KBUILD_MODNAME;
-	dev->gadget.is_dualspeed = 1;
+	dev->gadget.max_speed = USB_SPEED_HIGH;
 
 	retval = device_register(&dev->gadget.dev);
 	if (retval)
diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
index 65a8834..b74f49ac 100644
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -1141,7 +1141,7 @@ printer_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 				break;
 #ifdef CONFIG_USB_GADGET_DUALSPEED
 			case USB_DT_DEVICE_QUALIFIER:
-				if (!gadget->is_dualspeed)
+				if (!gadget_is_dualspeed(gadget))
 					break;
 				/*
 				 * assumes ep0 uses the same value for both
@@ -1155,7 +1155,7 @@ printer_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 				break;
 
 			case USB_DT_OTHER_SPEED_CONFIG:
-				if (!gadget->is_dualspeed)
+				if (!gadget_is_dualspeed(gadget))
 					break;
 				/* FALLTHROUGH */
 #endif /* CONFIG_USB_GADGET_DUALSPEED */
diff --git a/drivers/usb/gadget/r8a66597-udc.c b/drivers/usb/gadget/r8a66597-udc.c
index fc719a3..3666d7c 100644
--- a/drivers/usb/gadget/r8a66597-udc.c
+++ b/drivers/usb/gadget/r8a66597-udc.c
@@ -1911,7 +1911,7 @@ static int __init r8a66597_probe(struct platform_device *pdev)
 
 	r8a66597->gadget.ops = &r8a66597_gadget_ops;
 	dev_set_name(&r8a66597->gadget.dev, "gadget");
-	r8a66597->gadget.is_dualspeed = 1;
+	r8a66597->gadget.max_speed = USB_SPEED_HIGH;
 	r8a66597->gadget.dev.parent = &pdev->dev;
 	r8a66597->gadget.dev.dma_mask = pdev->dev.dma_mask;
 	r8a66597->gadget.dev.release = pdev->dev.release;
diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index b314482..6bc7ad8 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -3362,7 +3362,7 @@ static int __devinit s3c_hsotg_probe(struct platform_device *pdev)
 
 	dev_set_name(&hsotg->gadget.dev, "gadget");
 
-	hsotg->gadget.is_dualspeed = 1;
+	hsotg->gadget.max_speed = USB_SPEED_HIGH;
 	hsotg->gadget.ops = &s3c_hsotg_gadget_ops;
 	hsotg->gadget.name = dev_name(dev);
 
diff --git a/drivers/usb/gadget/s3c-hsudc.c b/drivers/usb/gadget/s3c-hsudc.c
index 20a553b..09ea965 100644
--- a/drivers/usb/gadget/s3c-hsudc.c
+++ b/drivers/usb/gadget/s3c-hsudc.c
@@ -1310,7 +1310,7 @@ static int s3c_hsudc_probe(struct platform_device *pdev)
 	device_initialize(&hsudc->gadget.dev);
 	dev_set_name(&hsudc->gadget.dev, "gadget");
 
-	hsudc->gadget.is_dualspeed = 1;
+	hsudc->gadget.max_speed = USB_SPEED_HIGH;
 	hsudc->gadget.ops = &s3c_hsudc_gadget_ops;
 	hsudc->gadget.name = dev_name(dev);
 	hsudc->gadget.dev.parent = dev;
diff --git a/drivers/usb/gadget/udc-core.c b/drivers/usb/gadget/udc-core.c
index 6939e17..0b0d12c 100644
--- a/drivers/usb/gadget/udc-core.c
+++ b/drivers/usb/gadget/udc-core.c
@@ -371,14 +371,28 @@ static ssize_t usb_udc_softconn_store(struct device *dev,
 }
 static DEVICE_ATTR(soft_connect, S_IWUSR, NULL, usb_udc_softconn_store);
 
-static ssize_t usb_udc_speed_show(struct device *dev,
+#define USB_UDC_SPEED_ATTR(name, param)					\
+ssize_t usb_udc_##param##_show(struct device *dev,			\
+		struct device_attribute *attr, char *buf)		\
+{									\
+	struct usb_udc *udc = container_of(dev, struct usb_udc, dev);	\
+	return snprintf(buf, PAGE_SIZE, "%s\n",				\
+			usb_speed_string(udc->gadget->param));		\
+}									\
+static DEVICE_ATTR(name, S_IRUSR, usb_udc_##param##_show, NULL)
+
+static USB_UDC_SPEED_ATTR(current_speed, speed);
+static USB_UDC_SPEED_ATTR(maximum_speed, max_speed);
+
+/* TODO: Scheduled for removal in 3.8. */
+static ssize_t usb_udc_is_dualspeed_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct usb_udc		*udc = container_of(dev, struct usb_udc, dev);
-	return snprintf(buf, PAGE_SIZE, "%s\n",
-			usb_speed_string(udc->gadget->speed));
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+			gadget_is_dualspeed(udc->gadget));
 }
-static DEVICE_ATTR(speed, S_IRUGO, usb_udc_speed_show, NULL);
+static DEVICE_ATTR(is_dualspeed, S_IRUSR, usb_udc_is_dualspeed_show, NULL);
 
 #define USB_UDC_ATTR(name)					\
 ssize_t usb_udc_##name##_show(struct device *dev,		\
@@ -391,7 +405,6 @@ ssize_t usb_udc_##name##_show(struct device *dev,		\
 }								\
 static DEVICE_ATTR(name, S_IRUGO, usb_udc_##name##_show, NULL)
 
-static USB_UDC_ATTR(is_dualspeed);
 static USB_UDC_ATTR(is_otg);
 static USB_UDC_ATTR(is_a_peripheral);
 static USB_UDC_ATTR(b_hnp_enable);
@@ -401,7 +414,8 @@ static USB_UDC_ATTR(a_alt_hnp_support);
 static struct attribute *usb_udc_attrs[] = {
 	&dev_attr_srp.attr,
 	&dev_attr_soft_connect.attr,
-	&dev_attr_speed.attr,
+	&dev_attr_current_speed.attr,
+	&dev_attr_maximum_speed.attr,
 
 	&dev_attr_is_dualspeed.attr,
 	&dev_attr_is_otg.attr,
diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index 922148f..47a3d1e 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1844,7 +1844,7 @@ int __init musb_gadget_setup(struct musb *musb)
 	 */
 
 	musb->g.ops = &musb_gadget_operations;
-	musb->g.is_dualspeed = 1;
+	musb->g.max_speed = USB_SPEED_HIGH;
 	musb->g.speed = USB_SPEED_UNKNOWN;
 
 	/* this "gadget" abstracts/virtualizes the controller */
diff --git a/drivers/usb/renesas_usbhs/mod_gadget.c b/drivers/usb/renesas_usbhs/mod_gadget.c
index d9717e0..53b5e80 100644
--- a/drivers/usb/renesas_usbhs/mod_gadget.c
+++ b/drivers/usb/renesas_usbhs/mod_gadget.c
@@ -881,7 +881,7 @@ int usbhs_mod_gadget_probe(struct usbhs_priv *priv)
 	gpriv->gadget.dev.parent	= dev;
 	gpriv->gadget.name		= "renesas_usbhs_udc";
 	gpriv->gadget.ops		= &usbhsg_gadget_ops;
-	gpriv->gadget.is_dualspeed	= 1;
+	gpriv->gadget.max_speed		= USB_SPEED_HIGH;
 
 	INIT_LIST_HEAD(&gpriv->gadget.ep_list);
 
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index 1d3a675..98dc306 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -477,8 +477,8 @@ struct usb_gadget_ops {
  *	driver setup() requests
  * @ep_list: List of other endpoints supported by the device.
  * @speed: Speed of current connection to USB host.
- * @is_dualspeed: True if the controller supports both high and full speed
- *	operation.  If it does, the gadget driver must also support both.
+ * @max_speed: Maximal speed the UDC can handle.  UDC must support this
+ *      and all slower speeds.
  * @is_otg: True if the USB device port uses a Mini-AB jack, so that the
  *	gadget driver must provide a USB OTG descriptor.
  * @is_a_peripheral: False unless is_otg, the "A" end of a USB cable
@@ -518,7 +518,7 @@ struct usb_gadget {
 	struct usb_ep			*ep0;
 	struct list_head		ep_list;	/* of usb_ep */
 	enum usb_device_speed		speed;
-	unsigned			is_dualspeed:1;
+	enum usb_device_speed		max_speed;
 	unsigned			is_otg:1;
 	unsigned			is_a_peripheral:1;
 	unsigned			b_hnp_enable:1;
@@ -549,7 +549,7 @@ static inline struct usb_gadget *dev_to_usb_gadget(struct device *dev)
 static inline int gadget_is_dualspeed(struct usb_gadget *g)
 {
 #ifdef CONFIG_USB_GADGET_DUALSPEED
-	/* runtime test would check "g->is_dualspeed" ... that might be
+	/* runtime test would check "g->max_speed" ... that might be
 	 * useful to work around hardware bugs, but is mostly pointless
 	 */
 	return 1;
@@ -567,7 +567,7 @@ static inline int gadget_is_superspeed(struct usb_gadget *g)
 {
 #ifdef CONFIG_USB_GADGET_SUPERSPEED
 	/*
-	 * runtime test would check "g->is_superspeed" ... that might be
+	 * runtime test would check "g->max_speed" ... that might be
 	 * useful to work around hardware bugs, but is mostly pointless
 	 */
 	return 1;
-- 
1.7.3.1

