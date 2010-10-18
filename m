Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab0JRPFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 11:05:10 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14402 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab0JRPFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 11:05:08 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6139"; a="58341955"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: linux-usb@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Subject: [RFC/PATCH v2 3/3] usb: Adding SuperSpeed support to dummy_hcd
Date: Mon, 18 Oct 2010 17:04:55 +0200
Message-Id: <1287414296-25331-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB 3.0 hub includes 2 hubs - HS and SS ones.
Thus, when dummy_hcd enabled it will register 2 root hubs (SS and HS).

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
---
 drivers/usb/gadget/dummy_hcd.c |  506 ++++++++++++++++++++++++++++++++++++++--
 1 files changed, 492 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index 7640e06..39571de 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -5,6 +5,7 @@
  *
  * Copyright (C) 2003 David Brownell
  * Copyright (C) 2003-2005 Alan Stern
+ * Copyright (C) 2010 Code Aurora Forum. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -61,10 +62,13 @@
 
 #define POWER_BUDGET	500	/* in mA; use 8 for low-power port testing */
 
-static const char	driver_name [] = "dummy_hcd";
-static const char	driver_desc [] = "USB Host+Gadget Emulator";
+static const char	driver_name[] = "dummy_hcd";
+static const char	ss_driver_name[] = "ss_dummy_hcd";
+static const char	driver_desc[] = "USB Host+Gadget Emulator";
+static const char	ss_driver_desc[] = "SS USB Host+Gadget Emulator";
 
-static const char	gadget_name [] = "dummy_udc";
+static const char	gadget_name[] = "dummy_udc";
+static const char	ss_gadget_name[] = "ss_dummy_udc";
 
 MODULE_DESCRIPTION (DRIVER_DESC);
 MODULE_AUTHOR ("David Brownell");
@@ -220,6 +224,7 @@ static inline struct dummy *gadget_dev_to_dummy (struct device *dev)
 }
 
 static struct dummy			*the_controller;
+static struct dummy			*the_ss_controller;
 
 /*-------------------------------------------------------------------------*/
 
@@ -259,10 +264,100 @@ stop_activity (struct dummy *dum)
 	/* driver now does any non-usb quiescing necessary */
 }
 
+
 /* caller must hold lock */
+
+/**
+ * set_ss_link_state() - Sets the current state of the
+ * SuperSpeed link
+ * @param dum - pointer to the dummy_hcd structure to update the
+ *	      link state for
+ *
+ * This function updates the port_status according to the link
+ * state. The old status is saved befor updating.
+ * Note: this function should be called only for SuperSpeed
+ * master and the caller must hold the lock.
+ */
+static void
+set_ss_link_state(struct dummy *dum)
+{
+	dum->active = 0;
+	if ((dum->port_status & USB_SS_PORT_STAT_POWER) == 0)
+		dum->port_status = 0;
+
+	/* UDC suspend must cause a disconnect */
+	else if (!dum->pullup || dum->udc_suspended) {
+		dum->port_status &= ~(USB_PORT_STAT_CONNECTION |
+					USB_PORT_STAT_ENABLE);
+		if ((dum->old_status & USB_PORT_STAT_CONNECTION) != 0)
+			dum->port_status |=
+					(USB_PORT_STAT_C_CONNECTION << 16);
+	} else {
+		/* device is connected and not suspended */
+		dum->port_status |= (USB_PORT_STAT_CONNECTION |
+				     USB_PORT_STAT_SUPER_SPEED);
+		if ((dum->old_status & USB_PORT_STAT_CONNECTION) == 0)
+			dum->port_status |=
+				(USB_PORT_STAT_C_CONNECTION << 16);
+		if ((dum->port_status & USB_PORT_STAT_ENABLE) == 1 &&
+		    (dum->port_status & USB_SS_PORT_LS_U0) == 1 &&
+		    dum->rh_state != DUMMY_RH_SUSPENDED)
+			dum->active = 1;
+	}
+
+
+	if ((dum->port_status & USB_PORT_STAT_ENABLE) == 0 ||
+	    dum->active)
+		dum->resuming = 0;
+
+	/* if !connected or reset */
+	if ((dum->port_status & USB_PORT_STAT_CONNECTION) == 0 ||
+			(dum->port_status & USB_PORT_STAT_RESET) != 0) {
+		/*
+		 * We're connected and not reseted (reset occured now),
+		 * and driver attached - disconnect!
+		 */
+		if ((dum->old_status & USB_PORT_STAT_CONNECTION) != 0 &&
+		    (dum->old_status & USB_PORT_STAT_RESET) == 0 &&
+		    dum->driver) {
+			stop_activity(dum);
+			spin_unlock(&dum->lock);
+			dum->driver->disconnect(&dum->gadget);
+			spin_lock(&dum->lock);
+		}
+	} else if (dum->active != dum->old_active) {
+		if (dum->old_active && dum->driver->suspend) {
+			spin_unlock(&dum->lock);
+			dum->driver->suspend(&dum->gadget);
+			spin_lock(&dum->lock);
+		} else if (!dum->old_active &&
+			   dum->driver->resume) {
+			spin_unlock(&dum->lock);
+			dum->driver->resume(&dum->gadget);
+			spin_lock(&dum->lock);
+		}
+	}
+
+	dum->old_status = dum->port_status;
+	dum->old_active = dum->active;
+}
+
+/**
+ * set_link_state() - Sets the current state of the link
+ * @param dum - pointer to the dummy_hcd structure to update the
+ *	      link state for
+ *
+ * This function updates the port_status according to the link
+ * state. The old status is saved befor updating.
+ * Note: caller must hold the lock.
+ */
 static void
 set_link_state (struct dummy *dum)
 {
+	if (dum == the_ss_controller) {
+		set_ss_link_state(dum);
+		return;
+	}
 	dum->active = 0;
 	if ((dum->port_status & USB_PORT_STAT_POWER) == 0)
 		dum->port_status = 0;
@@ -343,7 +438,13 @@ dummy_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 	dum = ep_to_dummy (ep);
 	if (!dum->driver || !is_enabled (dum))
 		return -ESHUTDOWN;
-	max = le16_to_cpu(desc->wMaxPacketSize) & 0x3ff;
+	max = le16_to_cpu(desc->wMaxPacketSize) ;
+	/*
+	 * For HS/FS devices only bits 0..9 of the wMaxPacketSize represent the
+	 * maximum packet size
+	 */
+	if (dum->gadget.speed < USB_SPEED_SUPER)
+		max &= 0x3ff;
 
 	/* drivers must not request bad settings, since lower levels
 	 * (hardware or its drivers) may not check.  some endpoints
@@ -361,6 +462,10 @@ dummy_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 			goto done;
 		}
 		switch (dum->gadget.speed) {
+		case USB_SPEED_SUPER:
+			if (max == 1024)
+				break;
+			goto done;
 		case USB_SPEED_HIGH:
 			if (max == 512)
 				break;
@@ -379,6 +484,7 @@ dummy_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 			goto done;
 		/* real hardware might not handle all packet sizes */
 		switch (dum->gadget.speed) {
+		case USB_SPEED_SUPER:
 		case USB_SPEED_HIGH:
 			if (max <= 1024)
 				break;
@@ -399,6 +505,7 @@ dummy_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 			goto done;
 		/* real hardware might not handle all packet sizes */
 		switch (dum->gadget.speed) {
+		case USB_SPEED_SUPER:
 		case USB_SPEED_HIGH:
 			if (max <= 1024)
 				break;
@@ -710,11 +817,19 @@ static int dummy_pullup (struct usb_gadget *_gadget, int value)
 	return 0;
 }
 
+static void dummy_get_config_params(struct usb_dcd_config_params *params)
+{
+	/* Just for testing so return maximum values */
+	params->bU1devExitLat = 0x0a;
+	params->bU2DevExitLat = 0x7ff;
+}
+
 static const struct usb_gadget_ops dummy_ops = {
 	.get_frame	= dummy_g_get_frame,
 	.wakeup		= dummy_wakeup,
 	.set_selfpowered = dummy_set_selfpowered,
 	.pullup		= dummy_pullup,
+	.get_config_params = dummy_get_config_params
 };
 
 /*-------------------------------------------------------------------------*/
@@ -750,16 +865,24 @@ static DEVICE_ATTR (function, S_IRUGO, show_function, NULL);
 int
 usb_gadget_register_driver (struct usb_gadget_driver *driver)
 {
-	struct dummy	*dum = the_controller;
+	struct dummy	*dum;
 	int		retval, i;
+	enum usb_device_speed	speed = USB_SPEED_UNKNOWN;
+
+	if (!driver->bind || !driver->setup
+			|| driver->speed == USB_SPEED_UNKNOWN)
+		return -EINVAL;
+
+	speed = driver->speed;
+	if (driver->speed == USB_SPEED_SUPER)
+		dum = the_ss_controller;
+	else
+		dum = the_controller;
 
 	if (!dum)
 		return -EINVAL;
 	if (dum->driver)
 		return -EBUSY;
-	if (!driver->bind || !driver->setup
-			|| driver->speed == USB_SPEED_UNKNOWN)
-		return -EINVAL;
 
 	/*
 	 * SLAVE side init ... the layer above hardware, which
@@ -787,7 +910,6 @@ usb_gadget_register_driver (struct usb_gadget_driver *driver)
 	}
 
 	dum->gadget.ep0 = &dum->ep [0].ep;
-	dum->ep [0].ep.maxpacket = 64;
 	list_del_init (&dum->ep [0].ep.ep_list);
 	INIT_LIST_HEAD(&dum->fifo_req.queue);
 
@@ -806,6 +928,11 @@ usb_gadget_register_driver (struct usb_gadget_driver *driver)
 	/* khubd will enumerate this in a while */
 	spin_lock_irq (&dum->lock);
 	dum->pullup = 1;
+	dum->gadget.speed = speed;
+	if (speed == USB_SPEED_SUPER)
+		dum->ep[0].ep.maxpacket = 9;
+	else
+		dum->ep[0].ep.maxpacket = 64;
 	set_link_state (dum);
 	spin_unlock_irq (&dum->lock);
 
@@ -817,12 +944,20 @@ EXPORT_SYMBOL (usb_gadget_register_driver);
 int
 usb_gadget_unregister_driver (struct usb_gadget_driver *driver)
 {
-	struct dummy	*dum = the_controller;
+	struct dummy	*dum ;
 	unsigned long	flags;
 
+	if (!driver || !driver->unbind)
+		return -EINVAL;
+
+	if (driver->speed == USB_SPEED_SUPER)
+		dum = the_ss_controller;
+	else
+		dum = the_controller;
+
 	if (!dum)
 		return -ENODEV;
-	if (!driver || driver != dum->driver || !driver->unbind)
+	if (driver != dum->driver)
 		return -EINVAL;
 
 	dev_dbg (udc_dev(dum), "unregister gadget driver '%s'\n",
@@ -897,6 +1032,34 @@ static int dummy_udc_probe (struct platform_device *pdev)
 	return rc;
 }
 
+static int dummy_ss_udc_probe(struct platform_device *pdev)
+{
+	struct dummy	*dum = the_ss_controller;
+	int		rc;
+
+	dum->gadget.name = gadget_name;
+	dum->gadget.ops = &dummy_ops;
+	dum->gadget.is_dualspeed = 1;
+
+	/* maybe claim OTG support, though we won't complete HNP */
+	dum->gadget.is_otg = (dummy_to_hcd(dum)->self.otg_port != 0);
+
+	dev_set_name(&dum->gadget.dev, "ss_gadget");
+	dum->gadget.dev.parent = &pdev->dev;
+	dum->gadget.dev.release = dummy_gadget_release;
+	rc = device_register(&dum->gadget.dev);
+	if (rc < 0)
+		return rc;
+
+	usb_get_hcd(dummy_to_hcd(dum));
+
+	platform_set_drvdata(pdev, dum);
+	rc = device_create_file(&dum->gadget.dev, &dev_attr_function);
+	if (rc < 0)
+		device_unregister(&dum->gadget.dev);
+	return rc;
+}
+
 static int dummy_udc_remove (struct platform_device *pdev)
 {
 	struct dummy	*dum = platform_get_drvdata (pdev);
@@ -946,6 +1109,17 @@ static struct platform_driver dummy_udc_driver = {
 	},
 };
 
+static struct platform_driver dummy_ss_udc_driver = {
+	.probe		= dummy_ss_udc_probe,
+	.remove		= dummy_udc_remove,
+	.suspend	= dummy_udc_suspend,
+	.resume		= dummy_udc_resume,
+	.driver		= {
+		.name	= (char *) ss_gadget_name,
+		.owner	= THIS_MODULE,
+	},
+};
+
 /*-------------------------------------------------------------------------*/
 
 /* MASTER/HOST SIDE DRIVER
@@ -1197,7 +1371,8 @@ static struct dummy_ep *find_endpoint (struct dummy *dum, u8 address)
 
 
 /**
- * This function handles all control transferes
+ * handle_control_request() - This function handles all control
+ * transfers
  *
  * @param dum - pointer to dummy (the_controller)
  * @param urb - the urb request to handle
@@ -1384,6 +1559,9 @@ static void dummy_timer (unsigned long _dum)
 	case USB_SPEED_HIGH:
 		total = 512/*bytes*/ * 13/*packets*/ * 8/*uframes*/;
 		break;
+	case USB_SPEED_SUPER:
+		total = 1024/*bytes*/ * 13/*packets*/ * 8/*uframes*/;
+		break;
 	default:
 		dev_err (dummy_dev(dum), "bogus device speed\n");
 		return;
@@ -1628,7 +1806,170 @@ hub_descriptor (struct usb_hub_descriptor *desc)
 	desc->bitmap [1] = 0xff;
 }
 
-static int dummy_hub_control (
+/**
+ * dummy_ss_hub_control() - handles the control requests of the
+ * dummy (ss hub) master.
+ *
+ * @param hcd - pointer to the hcd to handle
+ * @param typeReq - type of the request
+ * @param wValue - wValue of the request
+ * @param wIndex - wIndex of the request
+ * @param buf - buffer for reply in case of an IN request
+ * @param wLength - wLength of the request
+ *
+ * @return int - 0 on success, error code otherwise
+ *
+ * This function handles the control requests of the dummy (ss
+ * hub) master. All control requests that are part of the
+ * enumeration are handled by the dummy_timer
+ * Note: this function is used only for the SS root hub
+ */
+static int dummy_ss_hub_control(
+	struct usb_hcd	*hcd,
+	u16		typeReq,
+	u16		wValue,
+	u16		wIndex,
+	char		*buf,
+	u16		wLength
+) {
+	struct dummy		*dum;
+	int		retval = 0;
+	unsigned long	flags;
+
+	if (!HCD_HW_ACCESSIBLE(hcd))
+		return -ETIMEDOUT;
+
+	dum = hcd_to_dummy(hcd);
+	spin_lock_irqsave(&dum->lock, flags);
+	switch (typeReq) {
+	case ClearHubFeature:
+		break;
+	case ClearPortFeature:
+		switch (wValue) {
+		case USB_PORT_FEAT_POWER:
+			if (dum->port_status & USB_SS_PORT_STAT_POWER)
+				dev_dbg(dummy_dev(dum), "power-off\n");
+			/* FALLS THROUGH */
+		default:
+			dum->port_status &= ~(1 << wValue);
+			set_link_state(dum);
+		}
+		break;
+	case GetHubDescriptor:
+		hub_descriptor((struct usb_hub_descriptor *) buf);
+		break;
+	case GetHubStatus:
+		/* We report that no change occured in the hub status
+		 * (power and overcurent conditions)
+		 */
+		*(__le32 *) buf = cpu_to_le32 (0);
+		break;
+	case GetPortStatus:
+		/* We have only one port */
+		if (wIndex != 1)
+			retval = -EPIPE;
+
+		/* whoever resets or resumes must GetPortStatus to
+		 * complete it!!
+		 */
+		/* TODO: add support for suspend/resume */
+		if ((dum->port_status & USB_PORT_STAT_RESET) != 0 &&
+			time_after_eq(jiffies, dum->re_timeout)) {
+			dum->port_status |= (USB_PORT_STAT_C_RESET << 16);
+			dum->port_status &= ~USB_PORT_STAT_RESET;
+		}
+		if (dum->pullup)
+			dum->port_status |= USB_PORT_STAT_ENABLE;
+
+		set_link_state(dum);
+
+		((__le16 *) buf)[0] = cpu_to_le16 (dum->port_status);
+		((__le16 *) buf)[1] = cpu_to_le16 (dum->port_status >> 16);
+		break;
+	case SetHubFeature:
+		retval = -EPIPE;
+		break;
+	case SetPortFeature:
+		switch (wValue) {
+		case USB_PORT_FEAT_LINK_STATE:
+			/* Since this is dummy we don't have an actual link so
+			 * there is nothing to do for the SET_LINK_STATE cmd
+			 */
+			break;
+		case USB_PORT_FEAT_U1_TIMEOUT:
+		case USB_PORT_FEAT_U2_TIMEOUT:
+			/* TODO: add suspend/resume support! */
+			break;
+		case USB_PORT_FEAT_POWER:
+			dum->port_status |= USB_SS_PORT_STAT_POWER;
+			set_link_state(dum);
+			break;
+		case USB_PORT_FEAT_BH_PORT_RESET:
+		case USB_PORT_FEAT_RESET:
+			/* if it's already enabled, disable */
+			dum->port_status = 0;
+			dum->port_status = (USB_SS_PORT_STAT_POWER |
+					       USB_PORT_STAT_CONNECTION |
+					       USB_PORT_STAT_RESET);
+			/* We want to reset device status. All but the
+			 * Self powered feature
+			 */
+			dum->devstatus &= 0x0000 |
+				(1 << USB_DEVICE_SELF_POWERED);
+			/* FIXME: what is the correct reset signaling interval?
+			 * Is it still 50msec as for HS?
+			 */
+			dum->re_timeout = jiffies + msecs_to_jiffies(50);
+			/* FALLS THROUGH */
+		default:
+			if ((dum->port_status &
+			     USB_SS_PORT_STAT_POWER) != 0) {
+				dum->port_status |= (1 << wValue);
+				set_link_state(dum);
+			}
+		}
+		break;
+	case GetPortErrorCount:
+		/* We'll always return 0 since this is a dummy hub */
+		*(__le32 *) buf = cpu_to_le32 (0);
+		break;
+	case SetHubDepth:
+		break;
+	default:
+		dev_dbg(dummy_dev(dum),
+			"hub control req%04x v%04x i%04x l%d\n",
+			typeReq, wValue, wIndex, wLength);
+
+		/* "protocol stall" on error */
+		retval = -EPIPE;
+	}
+	spin_unlock_irqrestore(&dum->lock, flags);
+
+	if ((dum->port_status & PORT_C_MASK) != 0)
+		usb_hcd_poll_rh_status(hcd);
+	return retval;
+}
+
+
+/**
+ * dummy_hub_control() - handles the control requests of the
+ * dummy (hs hub) master.
+ *
+ * @param hcd - pointer to the hcd to handle
+ * @param typeReq - type of the request
+ * @param wValue - wValue of the request
+ * @param wIndex - wIndex of the request
+ * @param buf - buffer for reply in case of an IN request
+ * @param wLength - wLength of the request
+ *
+ * @return int - 0 on success, error code otherwise
+ *
+ * This function handles the control requests of the dummy (hs
+ * hub) master. All control requests that are part of the
+ * enumeration are handled by the dummy_timer
+ * Note: this function is used only for the HS root hub
+ */
+static int dummy_hub_control(
 	struct usb_hcd	*hcd,
 	u16		typeReq,
 	u16		wValue,
@@ -1742,7 +2083,11 @@ static int dummy_hub_control (
 			dum->port_status &= ~(USB_PORT_STAT_ENABLE
 					| USB_PORT_STAT_LOW_SPEED
 					| USB_PORT_STAT_HIGH_SPEED);
-			dum->devstatus = 0;
+			/*
+			 * We want to reset device status. All but the
+			 * Self powered feature
+			 */
+			dum->devstatus &= (1 << USB_DEVICE_SELF_POWERED);
 			/* 50msec reset signaling */
 			dum->re_timeout = jiffies + msecs_to_jiffies(50);
 			/* FALLS THROUGH */
@@ -1904,6 +2249,30 @@ static int dummy_h_get_frame (struct usb_hcd *hcd)
 	return dummy_g_get_frame (NULL);
 }
 
+/**
+ * dummy_address_device() - Assign an address for the connected
+ * device
+ * @param hcd - host controller of the device
+ * @param udev - device to address
+ *
+ * @return int - 0 on success, or an error code (refer to
+ *	   errno-base.h for details)
+ *
+ * Issue an Address Device command (which will issue a
+ * SetAddress request to the device). We should be protected by
+ * the usb_address0_mutex in khubd's hub_port_init, so we should
+ * only issue and wait on one address command at the same time.
+ *
+ * This function is used only for SS hcd drivers.
+ */
+static int dummy_address_device(struct usb_hcd *hcd, struct usb_device *udev)
+{
+	udev->devnum = 3;
+	return usb_control_msg(udev, (PIPE_CONTROL << 30),
+		USB_REQ_SET_ADDRESS, 0, udev->devnum, 0,
+		NULL, 0, USB_CTRL_SET_TIMEOUT);
+}
+
 static const struct hc_driver dummy_hcd = {
 	.description =		(char *) driver_name,
 	.product_desc =		"Dummy host controller",
@@ -1925,6 +2294,28 @@ static const struct hc_driver dummy_hcd = {
 	.bus_resume =		dummy_bus_resume,
 };
 
+static const struct hc_driver dummy_ss_hcd = {
+	.description =		(char *) ss_driver_name,
+	.product_desc =		"Dummy SS host controller",
+	.hcd_priv_size =	sizeof(struct dummy),
+
+	.flags =		HCD_USB3,
+
+	.start =		dummy_start,
+	.stop =			dummy_stop,
+
+	.urb_enqueue =		dummy_urb_enqueue,
+	.urb_dequeue =		dummy_urb_dequeue,
+	.address_device =	dummy_address_device,
+
+	.get_frame_number =	dummy_h_get_frame,
+
+	.hub_status_data =	dummy_hub_status,
+	.hub_control =		dummy_ss_hub_control,
+	.bus_suspend =		dummy_bus_suspend,
+	.bus_resume =		dummy_bus_resume,
+};
+
 static int dummy_hcd_probe(struct platform_device *pdev)
 {
 	struct usb_hcd		*hcd;
@@ -1945,6 +2336,26 @@ static int dummy_hcd_probe(struct platform_device *pdev)
 	return retval;
 }
 
+static int dummy_hcd_probe_ss(struct platform_device *pdev)
+{
+	struct usb_hcd		*hcd;
+	int			retval;
+
+	dev_info(&pdev->dev, "%s, driver " DRIVER_VERSION "\n", ss_driver_desc);
+
+	hcd = usb_create_hcd(&dummy_ss_hcd, &pdev->dev, dev_name(&pdev->dev));
+	if (!hcd)
+		return -ENOMEM;
+	the_ss_controller = hcd_to_dummy(hcd);
+
+	retval = usb_add_hcd(hcd, 0, 0);
+	if (retval != 0) {
+		usb_put_hcd(hcd);
+		the_ss_controller = NULL;
+	}
+	return retval;
+}
+
 static int dummy_hcd_remove (struct platform_device *pdev)
 {
 	struct usb_hcd		*hcd;
@@ -1956,6 +2367,17 @@ static int dummy_hcd_remove (struct platform_device *pdev)
 	return 0;
 }
 
+static int dummy_ss_hcd_remove(struct platform_device *pdev)
+{
+	struct usb_hcd		*hcd;
+
+	hcd = platform_get_drvdata(pdev);
+	usb_remove_hcd(hcd);
+	usb_put_hcd(hcd);
+	the_ss_controller = NULL;
+	return 0;
+}
+
 static int dummy_hcd_suspend (struct platform_device *pdev, pm_message_t state)
 {
 	struct usb_hcd		*hcd;
@@ -1997,10 +2419,23 @@ static struct platform_driver dummy_hcd_driver = {
 	},
 };
 
+static struct platform_driver dummy_ss_hcd_driver = {
+	.probe		= dummy_hcd_probe_ss,
+	.remove		= dummy_ss_hcd_remove,
+	.suspend	= dummy_hcd_suspend,
+	.resume		= dummy_hcd_resume,
+	.driver		= {
+		.name	= (char *) ss_driver_name,
+		.owner	= THIS_MODULE,
+	},
+};
+
 /*-------------------------------------------------------------------------*/
 
 static struct platform_device *the_udc_pdev;
+static struct platform_device *the_ss_udc_pdev;
 static struct platform_device *the_hcd_pdev;
+static struct platform_device *the_ss_hcd_pdev;
 
 static int __init init (void)
 {
@@ -2012,34 +2447,73 @@ static int __init init (void)
 	the_hcd_pdev = platform_device_alloc(driver_name, -1);
 	if (!the_hcd_pdev)
 		return retval;
+
+	the_ss_hcd_pdev = platform_device_alloc(ss_driver_name, -1);
+	if (!the_ss_hcd_pdev)
+		goto err_alloc_ss_hcd;
+
 	the_udc_pdev = platform_device_alloc(gadget_name, -1);
 	if (!the_udc_pdev)
 		goto err_alloc_udc;
 
+	the_ss_udc_pdev = platform_device_alloc(ss_gadget_name, -1);
+	if (!the_ss_udc_pdev)
+		goto err_alloc_ss_udc;
+
 	retval = platform_driver_register(&dummy_hcd_driver);
 	if (retval < 0)
 		goto err_register_hcd_driver;
+
+	retval = platform_driver_register(&dummy_ss_hcd_driver);
+	if (retval < 0)
+		goto err_register_ss_hcd_driver;
+
 	retval = platform_driver_register(&dummy_udc_driver);
 	if (retval < 0)
 		goto err_register_udc_driver;
 
+	retval = platform_driver_register(&dummy_ss_udc_driver);
+	if (retval < 0)
+		goto err_register_ss_udc_driver;
+
 	retval = platform_device_add(the_hcd_pdev);
 	if (retval < 0)
 		goto err_add_hcd;
+
+	retval = platform_device_add(the_ss_hcd_pdev);
+	if (retval < 0)
+		goto err_add_ss_hcd;
+
 	retval = platform_device_add(the_udc_pdev);
 	if (retval < 0)
 		goto err_add_udc;
+
+	retval = platform_device_add(the_ss_udc_pdev);
+	if (retval < 0)
+		goto err_add_ss_udc;
 	return retval;
 
+err_add_ss_udc:
+	platform_device_unregister(the_udc_pdev);
 err_add_udc:
+	platform_device_del(the_ss_hcd_pdev);
+err_add_ss_hcd:
 	platform_device_del(the_hcd_pdev);
 err_add_hcd:
+	platform_driver_unregister(&dummy_ss_udc_driver);
+err_register_ss_udc_driver:
 	platform_driver_unregister(&dummy_udc_driver);
 err_register_udc_driver:
+	platform_driver_unregister(&dummy_ss_hcd_driver);
+err_register_ss_hcd_driver:
 	platform_driver_unregister(&dummy_hcd_driver);
 err_register_hcd_driver:
+	platform_device_put(the_ss_udc_pdev);
+err_alloc_ss_udc:
 	platform_device_put(the_udc_pdev);
 err_alloc_udc:
+	platform_device_put(the_ss_hcd_pdev);
+err_alloc_ss_hcd:
 	platform_device_put(the_hcd_pdev);
 	return retval;
 }
@@ -2048,8 +2522,12 @@ module_init (init);
 static void __exit cleanup (void)
 {
 	platform_device_unregister(the_udc_pdev);
+	platform_device_unregister(the_ss_udc_pdev);
 	platform_device_unregister(the_hcd_pdev);
+	platform_device_unregister(the_ss_hcd_pdev);
 	platform_driver_unregister(&dummy_udc_driver);
+	platform_driver_unregister(&dummy_ss_udc_driver);
 	platform_driver_unregister(&dummy_hcd_driver);
+	platform_driver_unregister(&dummy_ss_hcd_driver);
 }
 module_exit (cleanup);
-- 
1.6.3.3

--
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
