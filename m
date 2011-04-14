Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806Ab1DNNVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 09:21:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3141 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757455Ab1DNNVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 09:21:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6315"; a="85566372"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: gregkh@suse.de
Cc: linux-arm-msm@vger.kernel.org, ablay@codeaurora.org, balbi@ti.com,
        Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-usb@vger.kernel.org (open list:USB GADGET/PERIPH...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH/RESEND v8 1/6] usb: Adding SuperSpeed support to dummy_hcd
Date: Thu, 14 Apr 2011 16:21:16 +0300
Message-Id: <1302787276-27232-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds SS support to the dummy hcd module. It may be used to test
SS device when no (SS) HW is available.
USB 3.0 hub includes 2 hubs - HS and SS ones.
This patch adds support for a SS hub in the dummy_hcd module. Thus, when
dummy_hcd enabled it will register 2 root hubs (SS and HS).

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index 3214ca3..4f4db96 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -62,9 +62,12 @@
 #define POWER_BUDGET	500	/* in mA; use 8 for low-power port testing */
 
 static const char	driver_name [] = "dummy_hcd";
+static const char	ss_driver_name[] = "ss_dummy_hcd";
 static const char	driver_desc [] = "USB Host+Gadget Emulator";
+static const char	ss_driver_desc[] = "SS USB Host+Gadget Emulator";
 
 static const char	gadget_name [] = "dummy_udc";
+static const char	ss_gadget_name[] = "ss_dummy_udc";
 
 MODULE_DESCRIPTION (DRIVER_DESC);
 MODULE_AUTHOR ("David Brownell");
@@ -220,6 +223,7 @@ static inline struct dummy *gadget_dev_to_dummy (struct device *dev)
 }
 
 static struct dummy			*the_controller;
+static struct dummy			*the_ss_controller;
 
 /*-------------------------------------------------------------------------*/
 
@@ -259,10 +263,94 @@ stop_activity (struct dummy *dum)
 	/* driver now does any non-usb quiescing necessary */
 }
 
-/* caller must hold lock */
+/**
+ * set_ss_link_state() - Sets the current state of the SuperSpeed link
+ * @dum: pointer to the dummy_hcd structure to update the link
+ *     state for
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
+				     USB_PORT_STAT_SPEED_5GBPS) ;
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
+	if ((dum->port_status & USB_PORT_STAT_ENABLE) == 0 || dum->active)
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
+		} else if (!dum->old_active &&  dum->driver->resume) {
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
+ * @dum: pointer to the dummy_hcd structure to update the link
+ *     state for
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
@@ -343,7 +431,13 @@ dummy_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 	dum = ep_to_dummy (ep);
 	if (!dum->driver || !is_enabled (dum))
 		return -ESHUTDOWN;
-	max = le16_to_cpu(desc->wMaxPacketSize) & 0x3ff;
+
+	/*
+	 * For HS/FS devices only bits 0..10 of the wMaxPacketSize represent the
+	 * maximum packet size.
+	 * For SS devices the wMaxPacketSize is limited by 1024.
+	 */
+	max = le16_to_cpu(desc->wMaxPacketSize) & 0x7ff;
 
 	/* drivers must not request bad settings, since lower levels
 	 * (hardware or its drivers) may not check.  some endpoints
@@ -361,6 +455,10 @@ dummy_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
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
@@ -379,6 +477,7 @@ dummy_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 			goto done;
 		/* real hardware might not handle all packet sizes */
 		switch (dum->gadget.speed) {
+		case USB_SPEED_SUPER:
 		case USB_SPEED_HIGH:
 			if (max <= 1024)
 				break;
@@ -399,6 +498,7 @@ dummy_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 			goto done;
 		/* real hardware might not handle all packet sizes */
 		switch (dum->gadget.speed) {
+		case USB_SPEED_SUPER:
 		case USB_SPEED_HIGH:
 			if (max <= 1024)
 				break;
@@ -751,9 +851,14 @@ int
 usb_gadget_probe_driver(struct usb_gadget_driver *driver,
 		int (*bind)(struct usb_gadget *))
 {
-	struct dummy	*dum = the_controller;
+	struct dummy	*dum;
 	int		retval, i;
 
+	if (driver->speed == USB_SPEED_SUPER)
+		dum = the_ss_controller;
+	else
+		dum = the_controller;
+
 	if (!dum)
 		return -EINVAL;
 	if (dum->driver)
@@ -787,7 +892,11 @@ usb_gadget_probe_driver(struct usb_gadget_driver *driver,
 	}
 
 	dum->gadget.ep0 = &dum->ep [0].ep;
-	dum->ep [0].ep.maxpacket = 64;
+	dum->gadget.speed = driver->speed;
+	if (driver->speed == USB_SPEED_SUPER)
+		dum->ep[0].ep.maxpacket = 9;
+	else
+		dum->ep[0].ep.maxpacket = 64;
 	list_del_init (&dum->ep [0].ep.ep_list);
 	INIT_LIST_HEAD(&dum->fifo_req.queue);
 
@@ -817,12 +926,20 @@ EXPORT_SYMBOL(usb_gadget_probe_driver);
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
@@ -899,6 +1016,34 @@ static int dummy_udc_probe (struct platform_device *pdev)
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
@@ -948,6 +1093,17 @@ static struct platform_driver dummy_udc_driver = {
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
@@ -1161,6 +1317,21 @@ static int periodic_bytes (struct dummy *dum, struct dummy_ep *ep)
 		tmp *= 8 /* applies to entire frame */;
 		limit += limit * tmp;
 	}
+	if (dum->gadget.speed == USB_SPEED_SUPER) {
+		switch (ep->desc->bmAttributes & 0x03) {
+		case USB_ENDPOINT_XFER_ISOC:
+			/* Sec. 4.4.8.2 USB3.0 Spec */
+			limit = 3 * 16 * 1024 * 8;
+			break;
+		case USB_ENDPOINT_XFER_INT:
+			/* Sec. 4.4.7.2 USB3.0 Spec */
+			limit = 3 * 1024 * 8;
+			break;
+		case USB_ENDPOINT_XFER_BULK:
+		default:
+			break;
+		}
+	}
 	return limit;
 }
 
@@ -1246,6 +1417,24 @@ static int handle_control_request(struct dummy *dum, struct urb *urb,
 			case USB_DEVICE_A_ALT_HNP_SUPPORT:
 				dum->gadget.a_alt_hnp_support = 1;
 				break;
+			case USB_DEVICE_U1_ENABLE:
+				if (dum->gadget.speed == USB_SPEED_SUPER)
+					w_value = USB_DEV_STAT_U1_ENABLED;
+				else
+					ret_val = -EOPNOTSUPP;
+				break;
+			case USB_DEVICE_U2_ENABLE:
+				if (dum->gadget.speed == USB_SPEED_SUPER)
+					w_value = USB_DEV_STAT_U2_ENABLED;
+				else
+					ret_val = -EOPNOTSUPP;
+				break;
+			case USB_DEVICE_LTM_ENABLE:
+				if (dum->gadget.speed == USB_SPEED_SUPER)
+					w_value = USB_DEV_STAT_LTM_ENABLED;
+				else
+					ret_val = -EOPNOTSUPP;
+				break;
 			default:
 				ret_val = -EOPNOTSUPP;
 			}
@@ -1272,6 +1461,24 @@ static int handle_control_request(struct dummy *dum, struct urb *urb,
 			case USB_DEVICE_REMOTE_WAKEUP:
 				w_value = USB_DEVICE_REMOTE_WAKEUP;
 				break;
+			case USB_DEVICE_U1_ENABLE:
+				if (dum->gadget.speed == USB_SPEED_SUPER)
+					w_value = USB_DEV_STAT_U1_ENABLED;
+				else
+					ret_val = -EOPNOTSUPP;
+				break;
+			case USB_DEVICE_U2_ENABLE:
+				if (dum->gadget.speed == USB_SPEED_SUPER)
+					w_value = USB_DEV_STAT_U2_ENABLED;
+				else
+					ret_val = -EOPNOTSUPP;
+				break;
+			case USB_DEVICE_LTM_ENABLE:
+				if (dum->gadget.speed == USB_SPEED_SUPER)
+					w_value = USB_DEV_STAT_LTM_ENABLED;
+				else
+					ret_val = -EOPNOTSUPP;
+				break;
 			default:
 				ret_val = -EOPNOTSUPP;
 				break;
@@ -1352,6 +1559,10 @@ static void dummy_timer (unsigned long _dum)
 	case USB_SPEED_HIGH:
 		total = 512/*bytes*/ * 13/*packets*/ * 8/*uframes*/;
 		break;
+	case USB_SPEED_SUPER:
+		/* Bus speed is 500000 bytes/ms, so use a little less */
+		total = 490000;
+		break;
 	default:
 		dev_err (dummy_dev(dum), "bogus device speed\n");
 		return;
@@ -1597,7 +1808,184 @@ hub_descriptor (struct usb_hub_descriptor *desc)
 	desc->u.hs.DeviceRemovable[1] = 0xff;
 }
 
-static int dummy_hub_control (
+static inline void
+ss_hub_descriptor(struct usb_hub_descriptor *desc)
+{
+	memset(desc, 0, sizeof *desc);
+	desc->bDescriptorType = 0x2a;
+	desc->bDescLength = 12;
+	desc->wHubCharacteristics = cpu_to_le16(0x0001);
+	desc->bNbrPorts = 1;
+	desc->u.ss.bHubHdrDecLat = 0x04; /* Worst case: 0.4 micro sec*/
+	desc->u.ss.DeviceRemovable = 0xffff;
+}
+
+/**
+ * dummy_ss_hub_control() - handles the control requests of the dummy (ss hub)
+ * master.
+ * @hcd: pointer to the hcd to handle
+ * @typeReq: type of the request
+ * @wValue: wValue of the request
+ * @wIndex: wIndex of the request
+ * @buf: buffer for reply in case of an IN request
+ * @wLength: wLength of the request
+ *
+ * Return int - 0 on success, error code otherwise
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
+	u16		wLength)
+{
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
+		ss_hub_descriptor((struct usb_hub_descriptor *) buf);
+		break;
+	case GetHubStatus:
+		/*
+		 * We report that no change occured in the hub status
+		 * (power and overcurent conditions)
+		 */
+		*(__le32 *) buf = cpu_to_le32 (0);
+		break;
+	case GetPortStatus:
+		/* We have only one port */
+		if (wIndex != 1)
+			retval = -EPIPE;
+
+		/*
+		 * whoever resets or resumes must GetPortStatus to
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
+			/*
+			 * Since this is dummy we don't have an actual link so
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
+			/*
+			 * We want to reset device status. All but the
+			 * Self powered feature
+			 */
+			dum->devstatus &= 0x0000 |
+				(1 << USB_DEVICE_SELF_POWERED);
+			/*
+			 * FIXME: what is the correct reset signaling interval?
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
+ * dummy_hub_control() - handles the control requests of the dummy (hs hub)
+ * master.
+ * @hcd: pointer to the hcd to handle
+ * @typeReq: type of the request
+ * @wValue: wValue of the request
+ * @wIndex: wIndex of the request
+ * @buf: buffer for reply in case of an IN request
+ * @wLength: wLength of the request
+ *
+ * Return int - 0 on success, error code otherwise
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
@@ -1711,7 +2099,11 @@ static int dummy_hub_control (
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
@@ -1788,6 +2180,9 @@ show_urb (char *buf, size_t size, struct urb *urb)
 		 case USB_SPEED_LOW:	s = "ls"; break;
 		 case USB_SPEED_FULL:	s = "fs"; break;
 		 case USB_SPEED_HIGH:	s = "hs"; break;
+		 case USB_SPEED_SUPER:
+			 s = "ss";
+			 break;
 		 default:		s = "?"; break;
 		 }; s; }),
 		ep, ep ? (usb_pipein (urb->pipe) ? "in" : "out") : "",
@@ -1894,6 +2289,27 @@ static const struct hc_driver dummy_hcd = {
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
@@ -1914,6 +2330,26 @@ static int dummy_hcd_probe(struct platform_device *pdev)
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
@@ -1925,6 +2361,17 @@ static int dummy_hcd_remove (struct platform_device *pdev)
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
@@ -1966,10 +2413,23 @@ static struct platform_driver dummy_hcd_driver = {
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
@@ -1981,34 +2441,73 @@ static int __init init (void)
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
@@ -2017,8 +2516,12 @@ module_init (init);
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
1.7.0.4

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
