Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab1HZNSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 09:18:55 -0400
Received: from smtp-out.google.com ([216.239.44.51]:41704 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab1HZNSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 09:18:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:date:message-id:x-mailer:
	in-reply-to:references:x-system-of-record;
	b=yYDBZxVyMsokkYWAkPgRea/aUAZlCdFqZTelQrjfjh5xtxGgLwihg0yMq+sWUbje+
	7zSsk/ueGOtucW5iIkBFA==
From: Michal Nazarewicz <mnazarewicz@google.com>
To: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>
Cc: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Dave Young" <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv5 2/4] usb: gadget: replace "is_dualspeed" with "max_speed"
Date: Fri, 26 Aug 2011 15:18:35 +0200
Message-Id: <befb5cae917585ee1caee515426cb11045ce1d6b.1314364323.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1314364322.git.mina86@mina86.com>
References: <cover.1314364322.git.mina86@mina86.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

This commit replaces usb_gadget's is_dualspeed field with
a max_speed field.
---

I was unable to figure out how to create a symlink in
non-race-condition way so for now I've created both speed and
current_speed attributes.  This needs to get fixed before getting
merged.

I would even consider just removing speed since udc-core got merged
only in 3.1, so maybe it won't be such a big issue?

 Documentation/feature-removal-schedule.txt |    8 ++++++++
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
 drivers/usb/gadget/udc-core.c              |   28 +++++++++++++++++++++++-----
 drivers/usb/musb/musb_gadget.c             |    2 +-
 drivers/usb/renesas_usbhs/mod_gadget.c     |    2 +-
 include/linux/usb/gadget.h                 |   10 +++++-----
 25 files changed, 65 insertions(+), 34 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index c4a6e14..95fb84f 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -592,3 +592,11 @@ Why:    In 3.0, we can now autodetect internal 3G device and already have
 	interface that was used by acer-wmi driver. It will replaced by
 	information log when acer-wmi initial.
 Who:    Lee, Chun-Yi <jlee@novell.com>
+
+---------------------------
+
+What:	udc class is_dualspeed and speed sysfs entries 
+When:	3.8
+Why:	is_dualspeed is superseded by maximum_speed, speed is just a symlink
+	to current_speed.
+Who:	Michal Nazarewicz <mina86@mina86.com>
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index cebaef7..d8c3870 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1950,8 +1950,8 @@ int __devinit dwc3_gadget_init(struct dwc3 *dwc)
 	dev_set_name(&dwc->gadget.dev, "gadget");
 
 	dwc->gadget.ops			= &dwc3_gadget_ops;
-	dwc->gadget.is_dualspeed	= true;
 	dwc->gadget.speed		= USB_SPEED_UNKNOWN;
+	dwc->gadget.max_speed		= USB_SPEED_SUPER;
 	dwc->gadget.dev.parent		= dwc->dev;
 
 	dma_set_coherent_mask(&dwc->gadget.dev, dwc->dev->coherent_dma_mask);
diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index 16eb8e2..5a6a8a2 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -3358,7 +3358,7 @@ static int udc_probe(struct udc *dev)
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
index 83428f5..72e51ce 100644
--- a/drivers/usb/gadget/ci13xxx_udc.c
+++ b/drivers/usb/gadget/ci13xxx_udc.c
@@ -751,8 +751,11 @@ static ssize_t show_device(struct device *dev, struct device_attribute *attr,
 
 	n += scnprintf(buf + n, PAGE_SIZE - n, "speed             = %d\n",
 		       gadget->speed);
+	n += scnprintf(buf + n, PAGE_SIZE - n, "max_speed         = %d\n",
+		       gadget->max_speed);
+	/* Provide "is_dualspeed" for backward compatibility. */
 	n += scnprintf(buf + n, PAGE_SIZE - n, "is_dualspeed      = %d\n",
-		       gadget->is_dualspeed);
+		       gadget_is_dualspeed(gadget));
 	n += scnprintf(buf + n, PAGE_SIZE - n, "is_otg            = %d\n",
 		       gadget->is_otg);
 	n += scnprintf(buf + n, PAGE_SIZE - n, "is_a_peripheral   = %d\n",
@@ -2866,7 +2869,7 @@ static int udc_probe(struct ci13xxx_udc_driver *driver, struct device *dev,
 
 	udc->gadget.ops          = &usb_gadget_ops;
 	udc->gadget.speed        = USB_SPEED_UNKNOWN;
-	udc->gadget.is_dualspeed = 1;
+	udc->gadget.max_speed    = USB_SPEED_HIGH;
 	udc->gadget.is_otg       = 0;
 	udc->gadget.name         = driver->name;
 
diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index 7b06d39..a1e3bba 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -986,7 +986,7 @@ static int dummy_udc_probe (struct platform_device *pdev)
 
 	dum->gadget.name = gadget_name;
 	dum->gadget.ops = &dummy_ops;
-	dum->gadget.is_dualspeed = 1;
+	dum->gadget.max_speed = USB_SPEED_SUPER;
 
 	dev_set_name(&dum->gadget.dev, "gadget");
 	dum->gadget.dev.parent = &pdev->dev;
diff --git a/drivers/usb/gadget/epautoconf.c b/drivers/usb/gadget/epautoconf.c
index cdca7eb..6536bec 100644
--- a/drivers/usb/gadget/epautoconf.c
+++ b/drivers/usb/gadget/epautoconf.c
@@ -162,7 +162,7 @@ ep_matches (
 	switch (type) {
 	case USB_ENDPOINT_XFER_INT:
 		/* INT:  limit 64 bytes full speed, 1024 high/super speed */
-		if (!gadget->is_dualspeed && max > 64)
+		if (!gadget_is_dualspeed(gadget) && max > 64)
 			return 0;
 		/* FALLTHROUGH */
 
@@ -170,12 +170,12 @@ ep_matches (
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
index b2c44e1..c629e16 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -2531,7 +2531,7 @@ static int __init fsl_udc_probe(struct platform_device *pdev)
 
 	/* Setup gadget structure */
 	udc_controller->gadget.ops = &fsl_gadget_ops;
-	udc_controller->gadget.is_dualspeed = 1;
+	udc_controller->gadget.max_speed = USB_SPEED_HIGH;
 	udc_controller->gadget.ep0 = &udc_controller->eps[0].ep;
 	INIT_LIST_HEAD(&udc_controller->gadget.ep_list);
 	udc_controller->gadget.speed = USB_SPEED_UNKNOWN;
diff --git a/drivers/usb/gadget/fusb300_udc.c b/drivers/usb/gadget/fusb300_udc.c
index d9ee6c3..02abddb 100644
--- a/drivers/usb/gadget/fusb300_udc.c
+++ b/drivers/usb/gadget/fusb300_udc.c
@@ -1472,7 +1472,7 @@ static int __init fusb300_probe(struct platform_device *pdev)
 
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
index 9c37a9e..48184b7 100644
--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@ -3304,7 +3304,7 @@ static int langwell_udc_probe(struct pci_dev *pdev,
 	dev->gadget.ep0 = &dev->ep[0].ep;	/* gadget ep0 */
 	INIT_LIST_HEAD(&dev->gadget.ep_list);	/* ep_list */
 	dev->gadget.speed = USB_SPEED_UNKNOWN;	/* speed */
-	dev->gadget.is_dualspeed = 1;		/* support dual speed */
+	dev->gadget.max_speed = USB_SPEED_HIGH;		/* support dual speed */
 #ifdef	OTG_TRANSCEIVER
 	dev->gadget.is_otg = 1;			/* support otg mode */
 #endif
diff --git a/drivers/usb/gadget/m66592-udc.c b/drivers/usb/gadget/m66592-udc.c
index 5e597c3..0ed1023 100644
--- a/drivers/usb/gadget/m66592-udc.c
+++ b/drivers/usb/gadget/m66592-udc.c
@@ -1663,7 +1663,7 @@ static int __init m66592_probe(struct platform_device *pdev)
 	m66592->gadget.ops = &m66592_gadget_ops;
 	device_initialize(&m66592->gadget.dev);
 	dev_set_name(&m66592->gadget.dev, "gadget");
-	m66592->gadget.is_dualspeed = 1;
+	m66592->gadget.max_speed = USB_SPEED_HIGH;
 	m66592->gadget.dev.parent = &pdev->dev;
 	m66592->gadget.dev.dma_mask = pdev->dev.dma_mask;
 	m66592->gadget.dev.release = pdev->dev.release;
diff --git a/drivers/usb/gadget/mv_udc_core.c b/drivers/usb/gadget/mv_udc_core.c
index 263dec4..7a3d373 100644
--- a/drivers/usb/gadget/mv_udc_core.c
+++ b/drivers/usb/gadget/mv_udc_core.c
@@ -2061,7 +2061,7 @@ int mv_udc_probe(struct platform_device *dev)
 	udc->gadget.ep0 = &udc->eps[0].ep;	/* gadget ep0 */
 	INIT_LIST_HEAD(&udc->gadget.ep_list);	/* ep_list */
 	udc->gadget.speed = USB_SPEED_UNKNOWN;	/* speed */
-	udc->gadget.is_dualspeed = 1;		/* support dual speed */
+	udc->gadget.max_speed = USB_SPEED_HIGH;		/* support dual speed */
 
 	/* the "gadget" abstracts/virtualizes the controller */
 	dev_set_name(&udc->gadget.dev, "gadget");
diff --git a/drivers/usb/gadget/net2272.c b/drivers/usb/gadget/net2272.c
index 08a4a36..005165a 100644
--- a/drivers/usb/gadget/net2272.c
+++ b/drivers/usb/gadget/net2272.c
@@ -2265,7 +2265,7 @@ net2272_probe_init(struct device *dev, unsigned int irq)
 	ret->irq = irq;
 	ret->dev = dev;
 	ret->gadget.ops = &net2272_ops;
-	ret->gadget.is_dualspeed = 1;
+	ret->gadget.max_speed = USB_SPEED_HIGH;
 
 	/* the "gadget" abstracts/virtualizes the controller */
 	dev_set_name(&ret->gadget.dev, "gadget");
diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index cbed585..f114375 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -2741,7 +2741,7 @@ static int net2280_probe (struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init (&dev->lock);
 	dev->pdev = pdev;
 	dev->gadget.ops = &net2280_ops;
-	dev->gadget.is_dualspeed = 1;
+	dev->gadget.max_speed = USB_SPEED_HIGH;
 
 	/* the "gadget" abstracts/virtualizes the controller */
 	dev_set_name(&dev->gadget.dev, "gadget");
diff --git a/drivers/usb/gadget/omap_udc.c b/drivers/usb/gadget/omap_udc.c
index b7a7799..9bcc3d7 100644
--- a/drivers/usb/gadget/omap_udc.c
+++ b/drivers/usb/gadget/omap_udc.c
@@ -2685,6 +2685,7 @@ omap_udc_setup(struct platform_device *odev, struct otg_transceiver *xceiv)
 	INIT_LIST_HEAD(&udc->gadget.ep_list);
 	INIT_LIST_HEAD(&udc->iso);
 	udc->gadget.speed = USB_SPEED_UNKNOWN;
+	udc->gadget.max_speed = USB_SPEED_FULL;
 	udc->gadget.name = driver_name;
 
 	device_initialize(&udc->gadget.dev);
diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index b69ae3e..d35ed3a 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -2949,7 +2949,7 @@ static int pch_udc_probe(struct pci_dev *pdev,
 	dev->gadget.dev.dma_mask = pdev->dev.dma_mask;
 	dev->gadget.dev.release = gadget_release;
 	dev->gadget.name = KBUILD_MODNAME;
-	dev->gadget.is_dualspeed = 1;
+	dev->gadget.max_speed = USB_SPEED_HIGH;
 
 	retval = device_register(&dev->gadget.dev);
 	if (retval)
diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
index 78fc14b..c39dd8c 100644
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -1150,7 +1150,7 @@ printer_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 				break;
 #ifdef CONFIG_USB_GADGET_DUALSPEED
 			case USB_DT_DEVICE_QUALIFIER:
-				if (!gadget->is_dualspeed)
+				if (!gadget_is_dualspeed(gadget))
 					break;
 				/*
 				 * assumes ep0 uses the same value for both
@@ -1164,7 +1164,7 @@ printer_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 				break;
 
 			case USB_DT_OTHER_SPEED_CONFIG:
-				if (!gadget->is_dualspeed)
+				if (!gadget_is_dualspeed(gadget))
 					break;
 				/* FALLTHROUGH */
 #endif /* CONFIG_USB_GADGET_DUALSPEED */
diff --git a/drivers/usb/gadget/r8a66597-udc.c b/drivers/usb/gadget/r8a66597-udc.c
index 61d0c65..8b1ad2a 100644
--- a/drivers/usb/gadget/r8a66597-udc.c
+++ b/drivers/usb/gadget/r8a66597-udc.c
@@ -1616,7 +1616,7 @@ static int __init r8a66597_probe(struct platform_device *pdev)
 	r8a66597->gadget.ops = &r8a66597_gadget_ops;
 	device_initialize(&r8a66597->gadget.dev);
 	dev_set_name(&r8a66597->gadget.dev, "gadget");
-	r8a66597->gadget.is_dualspeed = 1;
+	r8a66597->gadget.max_speed = USB_SPEED_HIGH;
 	r8a66597->gadget.dev.parent = &pdev->dev;
 	r8a66597->gadget.dev.dma_mask = pdev->dev.dma_mask;
 	r8a66597->gadget.dev.release = pdev->dev.release;
diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index a552453..bc41457 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -3364,7 +3364,7 @@ static int __devinit s3c_hsotg_probe(struct platform_device *pdev)
 
 	dev_set_name(&hsotg->gadget.dev, "gadget");
 
-	hsotg->gadget.is_dualspeed = 1;
+	hsotg->gadget.max_speed = USB_SPEED_HIGH;
 	hsotg->gadget.ops = &s3c_hsotg_gadget_ops;
 	hsotg->gadget.name = dev_name(dev);
 
diff --git a/drivers/usb/gadget/s3c-hsudc.c b/drivers/usb/gadget/s3c-hsudc.c
index 25829b4..d11ebc2 100644
--- a/drivers/usb/gadget/s3c-hsudc.c
+++ b/drivers/usb/gadget/s3c-hsudc.c
@@ -1297,7 +1297,7 @@ static int s3c_hsudc_probe(struct platform_device *pdev)
 	device_initialize(&hsudc->gadget.dev);
 	dev_set_name(&hsudc->gadget.dev, "gadget");
 
-	hsudc->gadget.is_dualspeed = 1;
+	hsudc->gadget.max_speed = USB_SPEED_HIGH;
 	hsudc->gadget.ops = &s3c_hsudc_gadget_ops;
 	hsudc->gadget.name = dev_name(dev);
 	hsudc->gadget.dev.parent = dev;
diff --git a/drivers/usb/gadget/udc-core.c b/drivers/usb/gadget/udc-core.c
index 5e77a46..72ad389 100644
--- a/drivers/usb/gadget/udc-core.c
+++ b/drivers/usb/gadget/udc-core.c
@@ -371,14 +371,31 @@ static ssize_t usb_udc_softconn_store(struct device *dev,
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
+/* XXX Change to symlink? */
+/* TODO: Scheduled for removal in 3.8. */
+static DEVICE_ATTR(speed, S_IRUSR, usb_udc_speed_show, NULL);
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
-static DEVICE_ATTR(speed, S_IRUSR, usb_udc_speed_show, NULL);
+static DEVICE_ATTR(is_dualspeed, S_IRUSR, usb_udc_is_dualspeed_show, NULL);
 
 #define USB_UDC_ATTR(name)					\
 ssize_t usb_udc_##name##_show(struct device *dev,		\
@@ -391,7 +408,6 @@ ssize_t usb_udc_##name##_show(struct device *dev,		\
 }								\
 static DEVICE_ATTR(name, S_IRUSR, usb_udc_##name##_show, NULL)
 
-static USB_UDC_ATTR(is_dualspeed);
 static USB_UDC_ATTR(is_otg);
 static USB_UDC_ATTR(is_a_peripheral);
 static USB_UDC_ATTR(b_hnp_enable);
@@ -402,6 +418,8 @@ static struct attribute *usb_udc_attrs[] = {
 	&dev_attr_srp.attr,
 	&dev_attr_soft_connect.attr,
 	&dev_attr_speed.attr,
+	&dev_attr_current_speed.attr,
+	&dev_attr_maximum_speed.attr,
 
 	&dev_attr_is_dualspeed.attr,
 	&dev_attr_is_otg.attr,
diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index 44b331a..4bd2bdd 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1827,7 +1827,7 @@ int __init musb_gadget_setup(struct musb *musb)
 	 */
 
 	musb->g.ops = &musb_gadget_operations;
-	musb->g.is_dualspeed = 1;
+	musb->g.max_speed = USB_SPEED_HIGH;
 	musb->g.speed = USB_SPEED_UNKNOWN;
 
 	/* this "gadget" abstracts/virtualizes the controller */
diff --git a/drivers/usb/renesas_usbhs/mod_gadget.c b/drivers/usb/renesas_usbhs/mod_gadget.c
index cb2d451..a8ae54f 100644
--- a/drivers/usb/renesas_usbhs/mod_gadget.c
+++ b/drivers/usb/renesas_usbhs/mod_gadget.c
@@ -917,7 +917,7 @@ int __devinit usbhs_mod_gadget_probe(struct usbhs_priv *priv)
 	gpriv->gadget.dev.parent	= dev;
 	gpriv->gadget.name		= "renesas_usbhs_udc";
 	gpriv->gadget.ops		= &usbhsg_gadget_ops;
-	gpriv->gadget.is_dualspeed	= 1;
+	gpriv->gadget.max_speed		= USB_SPEED_HIGH;
 
 	INIT_LIST_HEAD(&gpriv->gadget.ep_list);
 
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index 087f4b9..7eb2ec3 100644
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

