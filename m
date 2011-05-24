Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab1EXKDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 06:03:33 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57162 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab1EXKD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 06:03:27 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6355"; a="93228549"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v13 8/8] usb: Adding SuperSpeed support to dummy_hcd
Date: Tue, 24 May 2011 13:02:05 +0300
Message-Id: <1306231330-11158-9-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1306231330-11158-1-git-send-email-tlinder@codeaurora.org>
References: <1306231330-11158-1-git-send-email-tlinder@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds SS support to the dummy hcd module. It may be used to test
SS device when no (SS) HW is available.
USB 3.0 hub includes 2 hubs - HS and SS ones.
This patch adds support for a SS hub in the dummy_hcd module. Thus, when
dummy_hcd enabled it will register 2 root hubs (SS and HS).
A new module parameter was added to simulate a SuperSpeed connection.
When a new device is connected it will enumerate via the HS root hub by
default. In order to simulate SuperSpeed connection set the is_super_speed module
parameter to true.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

---
 drivers/usb/gadget/dummy_hcd.c |  556 +++++++++++++++++++++++++++++++++-------
 1 files changed, 468 insertions(+), 88 deletions(-)

diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index 6ecda10..3f41ef6 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -70,6 +70,15 @@ MODULE_DESCRIPTION (DRIVER_DESC);
 MODULE_AUTHOR ("David Brownell");
 MODULE_LICENSE ("GPL");
 
+struct dummy_hcd_module_parameters {
+	bool is_super_speed;
+};
+
+static struct dummy_hcd_module_parameters mod_data = {
+	.is_super_speed = false
+};
+module_param_named(is_super_speed, mod_data.is_super_speed, bool, S_IRUGO);
+MODULE_PARM_DESC(is_super_speed, "true to simulate SuperSpeed connection");
 /*-------------------------------------------------------------------------*/
 
 /* gadget side driver data structres */
@@ -188,6 +197,7 @@ struct dummy {
 	 * MASTER/HOST side support
 	 */
 	struct dummy_hcd		*hs_hcd;
+	struct dummy_hcd		*ss_hcd;
 };
 
 static inline struct dummy_hcd *hcd_to_dummy_hcd(struct usb_hcd *hcd)
@@ -218,7 +228,10 @@ static inline struct dummy *ep_to_dummy (struct dummy_ep *ep)
 static inline struct dummy_hcd *gadget_to_dummy_hcd(struct usb_gadget *gadget)
 {
 	struct dummy *dum = container_of(gadget, struct dummy, gadget);
-	return dum->hs_hcd;
+	if (dum->gadget.speed == USB_SPEED_SUPER)
+		return dum->ss_hcd;
+	else
+		return dum->hs_hcd;
 }
 
 static inline struct dummy *gadget_dev_to_dummy (struct device *dev)
@@ -266,60 +279,117 @@ stop_activity (struct dummy *dum)
 	/* driver now does any non-usb quiescing necessary */
 }
 
+/**
+ * set_link_state_by_speed() - Sets the current state of the link according to
+ *	the hcd speed
+ * @dum_hcd: pointer to the dummy_hcd structure to update the link state for
+ *
+ * This function updates the port_status according to the link state and the
+ * speed of the hcd.
+ */
+static void set_link_state_by_speed(struct dummy_hcd *dum_hcd)
+{
+	struct dummy *dum = dum_hcd->dum;
+
+	if (dummy_hcd_to_hcd(dum_hcd)->speed == HCD_USB3) {
+		if ((dum_hcd->port_status & USB_SS_PORT_STAT_POWER) == 0) {
+			dum_hcd->port_status = 0;
+		} else if (!dum->pullup || dum->udc_suspended) {
+			/* UDC suspend must cause a disconnect */
+			dum_hcd->port_status &= ~(USB_PORT_STAT_CONNECTION |
+						USB_PORT_STAT_ENABLE);
+			if ((dum_hcd->old_status &
+			     USB_PORT_STAT_CONNECTION) != 0)
+				dum_hcd->port_status |=
+					(USB_PORT_STAT_C_CONNECTION << 16);
+		} else {
+			/* device is connected and not suspended */
+			dum_hcd->port_status |= (USB_PORT_STAT_CONNECTION |
+						 USB_PORT_STAT_SPEED_5GBPS) ;
+			if ((dum_hcd->old_status &
+			     USB_PORT_STAT_CONNECTION) == 0)
+				dum_hcd->port_status |=
+					(USB_PORT_STAT_C_CONNECTION << 16);
+			if ((dum_hcd->port_status &
+			     USB_PORT_STAT_ENABLE) == 1 &&
+				(dum_hcd->port_status &
+				 USB_SS_PORT_LS_U0) == 1 &&
+				dum_hcd->rh_state != DUMMY_RH_SUSPENDED)
+				dum_hcd->active = 1;
+		}
+	} else {
+		if ((dum_hcd->port_status & USB_PORT_STAT_POWER) == 0) {
+			dum_hcd->port_status = 0;
+		} else if (!dum->pullup || dum->udc_suspended) {
+			/* UDC suspend must cause a disconnect */
+			dum_hcd->port_status &= ~(USB_PORT_STAT_CONNECTION |
+						USB_PORT_STAT_ENABLE |
+						USB_PORT_STAT_LOW_SPEED |
+						USB_PORT_STAT_HIGH_SPEED |
+						USB_PORT_STAT_SUSPEND);
+			if ((dum_hcd->old_status &
+			     USB_PORT_STAT_CONNECTION) != 0)
+				dum_hcd->port_status |=
+					(USB_PORT_STAT_C_CONNECTION << 16);
+		} else {
+			dum_hcd->port_status |= USB_PORT_STAT_CONNECTION;
+			if ((dum_hcd->old_status &
+			     USB_PORT_STAT_CONNECTION) == 0)
+				dum_hcd->port_status |=
+					(USB_PORT_STAT_C_CONNECTION << 16);
+			if ((dum_hcd->port_status & USB_PORT_STAT_ENABLE) == 0)
+				dum_hcd->port_status &= ~USB_PORT_STAT_SUSPEND;
+			else if ((dum_hcd->port_status &
+				  USB_PORT_STAT_SUSPEND) == 0 &&
+					dum_hcd->rh_state != DUMMY_RH_SUSPENDED)
+				dum_hcd->active = 1;
+		}
+	}
+}
+
 /* caller must hold lock */
 static void set_link_state(struct dummy_hcd *dum_hcd)
 {
 	struct dummy *dum = dum_hcd->dum;
 
 	dum_hcd->active = 0;
-	if ((dum_hcd->port_status & USB_PORT_STAT_POWER) == 0)
-		dum_hcd->port_status = 0;
-
-	/* UDC suspend must cause a disconnect */
-	else if (!dum->pullup || dum->udc_suspended) {
-		dum_hcd->port_status &= ~(USB_PORT_STAT_CONNECTION |
-					USB_PORT_STAT_ENABLE |
-					USB_PORT_STAT_LOW_SPEED |
-					USB_PORT_STAT_HIGH_SPEED |
-					USB_PORT_STAT_SUSPEND);
-		if ((dum_hcd->old_status & USB_PORT_STAT_CONNECTION) != 0)
-			dum_hcd->port_status |=
-				(USB_PORT_STAT_C_CONNECTION << 16);
-	} else {
-		dum_hcd->port_status |= USB_PORT_STAT_CONNECTION;
-		if ((dum_hcd->old_status & USB_PORT_STAT_CONNECTION) == 0)
-			dum_hcd->port_status |=
-				(USB_PORT_STAT_C_CONNECTION << 16);
-		if ((dum_hcd->port_status & USB_PORT_STAT_ENABLE) == 0)
-			dum_hcd->port_status &= ~USB_PORT_STAT_SUSPEND;
-		else if ((dum_hcd->port_status & USB_PORT_STAT_SUSPEND) == 0 &&
-				dum_hcd->rh_state != DUMMY_RH_SUSPENDED)
-			dum_hcd->active = 1;
-	}
+	if (dum->pullup)
+		if ((dummy_hcd_to_hcd(dum_hcd)->speed == HCD_USB3 &&
+		     dum->gadget.speed != USB_SPEED_SUPER) ||
+		    (dummy_hcd_to_hcd(dum_hcd)->speed != HCD_USB3 &&
+		     dum->gadget.speed == USB_SPEED_SUPER))
+			return;
+
+	set_link_state_by_speed(dum_hcd);
 
 	if ((dum_hcd->port_status & USB_PORT_STAT_ENABLE) == 0 ||
 	     dum_hcd->active)
 		dum_hcd->resuming = 0;
 
+	/* if !connected or reset */
 	if ((dum_hcd->port_status & USB_PORT_STAT_CONNECTION) == 0 ||
 			(dum_hcd->port_status & USB_PORT_STAT_RESET) != 0) {
+		/*
+		 * We're connected and not reset (reset occurred now),
+		 * and driver attached - disconnect!
+		 */
 		if ((dum_hcd->old_status & USB_PORT_STAT_CONNECTION) != 0 &&
-			(dum_hcd->old_status & USB_PORT_STAT_RESET) == 0 &&
-				dum->driver) {
-			stop_activity (dum);
-			spin_unlock (&dum->lock);
-			dum->driver->disconnect (&dum->gadget);
-			spin_lock (&dum->lock);
+		    (dum_hcd->old_status & USB_PORT_STAT_RESET) == 0 &&
+		    dum->driver) {
+			stop_activity(dum);
+			spin_unlock(&dum->lock);
+			dum->driver->disconnect(&dum->gadget);
+			spin_lock(&dum->lock);
 		}
 	} else if (dum_hcd->active != dum_hcd->old_active) {
 		if (dum_hcd->old_active && dum->driver->suspend) {
-			spin_unlock (&dum->lock);
-			dum->driver->suspend (&dum->gadget);
-			spin_lock (&dum->lock);
-		} else if (!dum_hcd->old_active && dum->driver->resume) {
-			spin_unlock (&dum->lock);
-			dum->driver->resume (&dum->gadget);
-			spin_lock (&dum->lock);
+			spin_unlock(&dum->lock);
+			dum->driver->suspend(&dum->gadget);
+			spin_lock(&dum->lock);
+		} else if (!dum_hcd->old_active &&  dum->driver->resume) {
+			spin_unlock(&dum->lock);
+			dum->driver->resume(&dum->gadget);
+			spin_lock(&dum->lock);
 		}
 	}
 
@@ -355,13 +425,17 @@ dummy_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 	dum = ep_to_dummy (ep);
 	if (!dum->driver)
 		return -ESHUTDOWN;
-	dum_hcd = dum->hs_hcd;
+	if (dum->gadget.speed == USB_SPEED_SUPER)
+		dum_hcd = dum->ss_hcd;
+	else
+		dum_hcd = dum->hs_hcd;
 	if (!is_enabled(dum_hcd))
 		return -ESHUTDOWN;
 
 	/*
 	 * For HS/FS devices only bits 0..10 of the wMaxPacketSize represent the
 	 * maximum packet size.
+	 * For SS devices the wMaxPacketSize is limited by 1024.
 	 */
 	max = le16_to_cpu(desc->wMaxPacketSize) & 0x7ff;
 
@@ -381,6 +455,10 @@ dummy_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
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
@@ -399,6 +477,7 @@ dummy_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 			goto done;
 		/* real hardware might not handle all packet sizes */
 		switch (dum->gadget.speed) {
+		case USB_SPEED_SUPER:
 		case USB_SPEED_HIGH:
 			if (max <= 1024)
 				break;
@@ -419,6 +498,7 @@ dummy_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 			goto done;
 		/* real hardware might not handle all packet sizes */
 		switch (dum->gadget.speed) {
+		case USB_SPEED_SUPER:
 		case USB_SPEED_HIGH:
 			if (max <= 1024)
 				break;
@@ -547,7 +627,10 @@ dummy_queue (struct usb_ep *_ep, struct usb_request *_req,
 		return -EINVAL;
 
 	dum = ep_to_dummy (ep);
-	dum_hcd = dum->hs_hcd;
+	if (dum->gadget.speed == USB_SPEED_SUPER)
+		dum_hcd = dum->ss_hcd;
+	else
+		dum_hcd = dum->hs_hcd;
 	if (!dum->driver || !is_enabled(dum_hcd))
 		return -ESHUTDOWN;
 
@@ -733,9 +816,12 @@ static int dummy_pullup (struct usb_gadget *_gadget, int value)
 	dum = gadget_to_dummy_hcd(_gadget)->dum;
 	spin_lock_irqsave (&dum->lock, flags);
 	dum->pullup = (value != 0);
-	set_link_state(dum->hs_hcd);
+	set_link_state((dum->gadget.speed == USB_SPEED_SUPER ?
+			dum->ss_hcd : dum->hs_hcd));
 	spin_unlock_irqrestore (&dum->lock, flags);
-	usb_hcd_poll_rh_status(dummy_hcd_to_hcd(dum->hs_hcd));
+	usb_hcd_poll_rh_status((dum->gadget.speed == USB_SPEED_SUPER ?
+				dummy_hcd_to_hcd(dum->ss_hcd) :
+				dummy_hcd_to_hcd(dum->hs_hcd)));
 	return 0;
 }
 
@@ -816,8 +902,21 @@ usb_gadget_probe_driver(struct usb_gadget_driver *driver,
 	}
 
 	dum->gadget.ep0 = &dum->ep [0].ep;
-	dum->gadget.speed = min((u8)driver->speed, (u8)USB_SPEED_HIGH) ;
-	dum->ep[0].ep.maxpacket = 64;
+	if (mod_data.is_super_speed)
+		dum->gadget.speed = driver->speed;
+	else
+		dum->gadget.speed = min((u8)USB_SPEED_HIGH, (u8)driver->speed);
+	if (dum->gadget.speed < driver->speed)
+		dev_dbg(udc_dev(dum), "This device can perform faster if"
+				      " you connect it to a "
+				      "SupeSpeed port...\n");
+
+	if (dum->gadget.speed == USB_SPEED_SUPER) {
+		for (i = 0; i < DUMMY_ENDPOINTS; i++)
+			dum->ep[i].ep.max_streams = 0x10;
+		dum->ep[0].ep.maxpacket = 9;
+	} else
+		dum->ep[0].ep.maxpacket = 64;
 	list_del_init (&dum->ep [0].ep.ep_list);
 	INIT_LIST_HEAD(&dum->fifo_req.queue);
 
@@ -836,12 +935,21 @@ usb_gadget_probe_driver(struct usb_gadget_driver *driver,
 	/* khubd will enumerate this in a while */
 	spin_lock_irq (&dum->lock);
 	dum->pullup = 1;
-	dum->gadget.is_otg =
-		(dummy_hcd_to_hcd(dum->hs_hcd)->self.otg_port != 0);
-	set_link_state(dum->hs_hcd);
+	if (dum->gadget.speed == USB_SPEED_SUPER) {
+		dum->gadget.is_otg =
+			(dummy_hcd_to_hcd(dum->ss_hcd)->self.otg_port != 0);
+		set_link_state(dum->ss_hcd);
+	} else {
+		dum->gadget.is_otg =
+			(dummy_hcd_to_hcd(dum->hs_hcd)->self.otg_port != 0);
+		set_link_state(dum->hs_hcd);
+	}
+
 	spin_unlock_irq (&dum->lock);
 
-	usb_hcd_poll_rh_status(dummy_hcd_to_hcd(dum->hs_hcd));
+	usb_hcd_poll_rh_status((dum->gadget.speed == USB_SPEED_SUPER ?
+				dummy_hcd_to_hcd(dum->ss_hcd) :
+				dummy_hcd_to_hcd(dum->hs_hcd)));
 	return 0;
 }
 EXPORT_SYMBOL(usb_gadget_probe_driver);
@@ -862,18 +970,21 @@ usb_gadget_unregister_driver (struct usb_gadget_driver *driver)
 
 	spin_lock_irqsave (&dum->lock, flags);
 	dum->pullup = 0;
-	set_link_state(dum->hs_hcd);
+	set_link_state((dum->gadget.speed == USB_SPEED_SUPER ?
+			dum->ss_hcd : dum->hs_hcd));
 	spin_unlock_irqrestore (&dum->lock, flags);
 
 	driver->unbind (&dum->gadget);
 	dum->gadget.dev.driver = NULL;
 	dum->driver = NULL;
-
 	spin_lock_irqsave (&dum->lock, flags);
 	dum->pullup = 0;
-	set_link_state(dum->hs_hcd);
+	set_link_state((dum->gadget.speed == USB_SPEED_SUPER ?
+			dum->ss_hcd : dum->hs_hcd));
 	spin_unlock_irqrestore (&dum->lock, flags);
-	usb_hcd_poll_rh_status(dummy_hcd_to_hcd(dum->hs_hcd));
+	usb_hcd_poll_rh_status((dum->gadget.speed == USB_SPEED_SUPER ?
+				dummy_hcd_to_hcd(dum->ss_hcd) :
+				dummy_hcd_to_hcd(dum->hs_hcd)));
 	return 0;
 }
 EXPORT_SYMBOL (usb_gadget_unregister_driver);
@@ -941,10 +1052,13 @@ static int dummy_udc_suspend (struct platform_device *pdev, pm_message_t state)
 	dev_dbg (&pdev->dev, "%s\n", __func__);
 	spin_lock_irq (&dum->lock);
 	dum->udc_suspended = 1;
-	set_link_state(dum->hs_hcd);
+	set_link_state((dum->gadget.speed == USB_SPEED_SUPER ?
+			dum->ss_hcd : dum->hs_hcd));
 	spin_unlock_irq (&dum->lock);
 
-	usb_hcd_poll_rh_status(dummy_hcd_to_hcd(dum->hs_hcd));
+	usb_hcd_poll_rh_status((dum->gadget.speed == USB_SPEED_SUPER ?
+				dummy_hcd_to_hcd(dum->ss_hcd) :
+				dummy_hcd_to_hcd(dum->hs_hcd)));
 	return 0;
 }
 
@@ -955,10 +1069,13 @@ static int dummy_udc_resume (struct platform_device *pdev)
 	dev_dbg (&pdev->dev, "%s\n", __func__);
 	spin_lock_irq (&dum->lock);
 	dum->udc_suspended = 0;
-	set_link_state(dum->hs_hcd);
+	set_link_state((dum->gadget.speed == USB_SPEED_SUPER ?
+			dum->ss_hcd : dum->hs_hcd));
 	spin_unlock_irq (&dum->lock);
 
-	usb_hcd_poll_rh_status(dummy_hcd_to_hcd(dum->hs_hcd));
+	usb_hcd_poll_rh_status((dum->gadget.speed == USB_SPEED_SUPER ?
+				dummy_hcd_to_hcd(dum->ss_hcd) :
+				dummy_hcd_to_hcd(dum->hs_hcd)));
 	return 0;
 }
 
@@ -1186,6 +1303,21 @@ static int periodic_bytes (struct dummy *dum, struct dummy_ep *ep)
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
 
@@ -1198,7 +1330,8 @@ static struct dummy_ep *find_endpoint (struct dummy *dum, u8 address)
 {
 	int		i;
 
-	if (!is_active(dum->hs_hcd))
+	if (!is_active((dum->gadget.speed == USB_SPEED_SUPER ?
+			dum->ss_hcd : dum->hs_hcd)))
 		return NULL;
 	if ((address & ~USB_DIR_IN) == 0)
 		return &dum->ep [0];
@@ -1272,6 +1405,27 @@ static int handle_control_request(struct dummy_hcd *dum_hcd, struct urb *urb,
 			case USB_DEVICE_A_ALT_HNP_SUPPORT:
 				dum->gadget.a_alt_hnp_support = 1;
 				break;
+			case USB_DEVICE_U1_ENABLE:
+				if (dummy_hcd_to_hcd(dum_hcd)->speed ==
+				    HCD_USB3)
+					w_value = USB_DEV_STAT_U1_ENABLED;
+				else
+					ret_val = -EOPNOTSUPP;
+				break;
+			case USB_DEVICE_U2_ENABLE:
+				if (dummy_hcd_to_hcd(dum_hcd)->speed ==
+				    HCD_USB3)
+					w_value = USB_DEV_STAT_U2_ENABLED;
+				else
+					ret_val = -EOPNOTSUPP;
+				break;
+			case USB_DEVICE_LTM_ENABLE:
+				if (dummy_hcd_to_hcd(dum_hcd)->speed ==
+				    HCD_USB3)
+					w_value = USB_DEV_STAT_LTM_ENABLED;
+				else
+					ret_val = -EOPNOTSUPP;
+				break;
 			default:
 				ret_val = -EOPNOTSUPP;
 			}
@@ -1298,6 +1452,27 @@ static int handle_control_request(struct dummy_hcd *dum_hcd, struct urb *urb,
 			case USB_DEVICE_REMOTE_WAKEUP:
 				w_value = USB_DEVICE_REMOTE_WAKEUP;
 				break;
+			case USB_DEVICE_U1_ENABLE:
+				if (dummy_hcd_to_hcd(dum_hcd)->speed ==
+				    HCD_USB3)
+					w_value = USB_DEV_STAT_U1_ENABLED;
+				else
+					ret_val = -EOPNOTSUPP;
+				break;
+			case USB_DEVICE_U2_ENABLE:
+				if (dummy_hcd_to_hcd(dum_hcd)->speed ==
+				    HCD_USB3)
+					w_value = USB_DEV_STAT_U2_ENABLED;
+				else
+					ret_val = -EOPNOTSUPP;
+				break;
+			case USB_DEVICE_LTM_ENABLE:
+				if (dummy_hcd_to_hcd(dum_hcd)->speed ==
+				    HCD_USB3)
+					w_value = USB_DEV_STAT_LTM_ENABLED;
+				else
+					ret_val = -EOPNOTSUPP;
+				break;
 			default:
 				ret_val = -EOPNOTSUPP;
 				break;
@@ -1379,6 +1554,10 @@ static void dummy_timer(unsigned long _dum_hcd)
 	case USB_SPEED_HIGH:
 		total = 512/*bytes*/ * 13/*packets*/ * 8/*uframes*/;
 		break;
+	case USB_SPEED_SUPER:
+		/* Bus speed is 500000 bytes/ms, so use a little less */
+		total = 490000;
+		break;
 	default:
 		dev_err(dummy_dev(dum_hcd), "bogus device speed\n");
 		return;
@@ -1613,6 +1792,18 @@ done:
 }
 
 static inline void
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
+static inline void
 hub_descriptor (struct usb_hub_descriptor *desc)
 {
 	memset (desc, 0, sizeof *desc);
@@ -1648,6 +1839,12 @@ static int dummy_hub_control (
 	case ClearPortFeature:
 		switch (wValue) {
 		case USB_PORT_FEAT_SUSPEND:
+			if (hcd->speed == HCD_USB3) {
+				dev_dbg(dummy_dev(dum_hcd),
+					 "USB_PORT_FEAT_SUSPEND req not "
+					 "supported for USB 3.0 roothub\n");
+				goto error;
+			}
 			if (dum_hcd->port_status & USB_PORT_STAT_SUSPEND) {
 				/* 20msec resume signaling */
 				dum_hcd->resuming = 1;
@@ -1656,8 +1853,15 @@ static int dummy_hub_control (
 			}
 			break;
 		case USB_PORT_FEAT_POWER:
-			if (dum_hcd->port_status & USB_PORT_STAT_POWER)
-				dev_dbg(dummy_dev(dum_hcd), "power-off\n");
+			if (hcd->speed == HCD_USB3) {
+				if (dum_hcd->port_status & USB_PORT_STAT_POWER)
+					dev_dbg(dummy_dev(dum_hcd),
+						"power-off\n");
+			} else
+				if (dum_hcd->port_status &
+							USB_SS_PORT_STAT_POWER)
+					dev_dbg(dummy_dev(dum_hcd),
+						"power-off\n");
 			/* FALLS THROUGH */
 		default:
 			dum_hcd->port_status &= ~(1 << wValue);
@@ -1665,7 +1869,18 @@ static int dummy_hub_control (
 		}
 		break;
 	case GetHubDescriptor:
-		hub_descriptor((struct usb_hub_descriptor *) buf);
+		if (hcd->speed == HCD_USB3 &&
+				(wLength < USB_DT_SS_HUB_SIZE ||
+				 wValue != (USB_DT_SS_HUB << 8))) {
+			dev_dbg(dummy_dev(dum_hcd),
+				"Wrong hub descriptor type for "
+				"USB 3.0 roothub.\n");
+			goto error;
+		}
+		if (hcd->speed == HCD_USB3)
+			ss_hub_descriptor((struct usb_hub_descriptor *) buf);
+		else
+			hub_descriptor((struct usb_hub_descriptor *) buf);
 		break;
 	case GetHubStatus:
 		*(__le32 *) buf = cpu_to_le32 (0);
@@ -1688,21 +1903,24 @@ static int dummy_hub_control (
 			dum_hcd->port_status &= ~USB_PORT_STAT_RESET;
 			if (dum_hcd->dum->pullup) {
 				dum_hcd->port_status |= USB_PORT_STAT_ENABLE;
-				switch (dum_hcd->dum->gadget.speed) {
-				case USB_SPEED_HIGH:
-					dum_hcd->port_status |=
-					      USB_PORT_STAT_HIGH_SPEED;
-					break;
-				case USB_SPEED_LOW:
-					dum_hcd->dum->gadget.ep0->
-						maxpacket = 8;
-					dum_hcd->port_status |=
-						USB_PORT_STAT_LOW_SPEED;
-					break;
-				default:
-					dum_hcd->dum->gadget.speed =
-						USB_SPEED_FULL;
-					break;
+
+				if (hcd->speed < HCD_USB3) {
+					switch (dum_hcd->dum->gadget.speed) {
+					case USB_SPEED_HIGH:
+						dum_hcd->port_status |=
+						      USB_PORT_STAT_HIGH_SPEED;
+						break;
+					case USB_SPEED_LOW:
+						dum_hcd->dum->gadget.ep0->
+							maxpacket = 8;
+						dum_hcd->port_status |=
+							USB_PORT_STAT_LOW_SPEED;
+						break;
+					default:
+						dum_hcd->dum->gadget.speed =
+							USB_SPEED_FULL;
+						break;
+					}
 				}
 			}
 		}
@@ -1715,7 +1933,36 @@ static int dummy_hub_control (
 		break;
 	case SetPortFeature:
 		switch (wValue) {
+		case USB_PORT_FEAT_LINK_STATE:
+			if (hcd->speed != HCD_USB3) {
+				dev_dbg(dummy_dev(dum_hcd),
+					 "USB_PORT_FEAT_LINK_STATE req not "
+					 "supported for USB 2.0 roothub\n");
+				goto error;
+			}
+			/*
+			 * Since this is dummy we don't have an actual link so
+			 * there is nothing to do for the SET_LINK_STATE cmd
+			 */
+			break;
+		case USB_PORT_FEAT_U1_TIMEOUT:
+		case USB_PORT_FEAT_U2_TIMEOUT:
+			/* TODO: add suspend/resume support! */
+			if (hcd->speed != HCD_USB3) {
+				dev_dbg(dummy_dev(dum_hcd),
+					 "USB_PORT_FEAT_U1/2_TIMEOUT req not "
+					 "supported for USB 2.0 roothub\n");
+				goto error;
+			}
+			break;
 		case USB_PORT_FEAT_SUSPEND:
+			/* Applicable only for USB2.0 hub */
+			if (hcd->speed == HCD_USB3) {
+				dev_dbg(dummy_dev(dum_hcd),
+					 "USB_PORT_FEAT_SUSPEND req not "
+					 "supported for USB 3.0 roothub\n");
+				goto error;
+			}
 			if (dum_hcd->active) {
 				dum_hcd->port_status |= USB_PORT_STAT_SUSPEND;
 
@@ -1730,12 +1977,31 @@ static int dummy_hub_control (
 			}
 			break;
 		case USB_PORT_FEAT_POWER:
-			dum_hcd->port_status |= USB_PORT_STAT_POWER;
+			if (hcd->speed == HCD_USB3)
+				dum_hcd->port_status |= USB_SS_PORT_STAT_POWER;
+			else
+				dum_hcd->port_status |= USB_PORT_STAT_POWER;
 			set_link_state(dum_hcd);
 			break;
+		case USB_PORT_FEAT_BH_PORT_RESET:
+			/* Applicable only for USB3.0 hub */
+			if (hcd->speed != HCD_USB3) {
+				dev_dbg(dummy_dev(dum_hcd),
+					 "USB_PORT_FEAT_BH_PORT_RESET req not "
+					 "supported for USB 2.0 roothub\n");
+				goto error;
+			}
+			/* FALLS THROUGH */
 		case USB_PORT_FEAT_RESET:
 			/* if it's already enabled, disable */
-			dum_hcd->port_status &= ~(USB_PORT_STAT_ENABLE
+			if (hcd->speed == HCD_USB3) {
+				dum_hcd->port_status = 0;
+				dum_hcd->port_status =
+					(USB_SS_PORT_STAT_POWER |
+					 USB_PORT_STAT_CONNECTION |
+					 USB_PORT_STAT_RESET);
+			} else
+				dum_hcd->port_status &= ~(USB_PORT_STAT_ENABLE
 					| USB_PORT_STAT_LOW_SPEED
 					| USB_PORT_STAT_HIGH_SPEED);
 			/*
@@ -1744,21 +2010,50 @@ static int dummy_hub_control (
 			 */
 			dum_hcd->dum->devstatus &=
 				(1 << USB_DEVICE_SELF_POWERED);
+			/*
+			 * FIXME USB3.0: what is the correct reset signaling
+			 * interval? Is it still 50msec as for HS?
+			 */
 			dum_hcd->re_timeout = jiffies + msecs_to_jiffies(50);
 			/* FALLS THROUGH */
 		default:
-			if ((dum_hcd->port_status &
-			     USB_PORT_STAT_POWER) != 0) {
-				dum_hcd->port_status |= (1 << wValue);
-				set_link_state(dum_hcd);
-			}
+			if (hcd->speed == HCD_USB3) {
+				if ((dum_hcd->port_status &
+				     USB_SS_PORT_STAT_POWER) != 0) {
+					dum_hcd->port_status |= (1 << wValue);
+					set_link_state(dum_hcd);
+				}
+			} else
+				if ((dum_hcd->port_status &
+				     USB_PORT_STAT_POWER) != 0) {
+					dum_hcd->port_status |= (1 << wValue);
+					set_link_state(dum_hcd);
+				}
+		}
+		break;
+	case GetPortErrorCount:
+		if (hcd->speed != HCD_USB3) {
+			dev_dbg(dummy_dev(dum_hcd),
+				 "GetPortErrorCount req not "
+				 "supported for USB 2.0 roothub\n");
+			goto error;
+		}
+		/* We'll always return 0 since this is a dummy hub */
+		*(__le32 *) buf = cpu_to_le32(0);
+		break;
+	case SetHubDepth:
+		if (hcd->speed != HCD_USB3) {
+			dev_dbg(dummy_dev(dum_hcd),
+				 "SetHubDepth req not supported for "
+				 "USB 2.0 roothub\n");
+			goto error;
 		}
 		break;
-
 	default:
 		dev_dbg(dummy_dev(dum_hcd),
 			"hub control req%04x v%04x i%04x l%d\n",
 			typeReq, wValue, wIndex, wLength);
+error:
 		/* "protocol stall" on error */
 		retval = -EPIPE;
 	}
@@ -1825,6 +2120,9 @@ show_urb (char *buf, size_t size, struct urb *urb)
 		 case USB_SPEED_HIGH:
 			s = "hs";
 			break;
+		 case USB_SPEED_SUPER:
+			s = "ss";
+			break;
 		 default:
 			s = "?";
 			break;
@@ -1871,6 +2169,25 @@ show_urbs (struct device *dev, struct device_attribute *attr, char *buf)
 }
 static DEVICE_ATTR (urbs, S_IRUGO, show_urbs, NULL);
 
+static int dummy_start_ss(struct dummy_hcd *dum_hcd)
+{
+	init_timer(&dum_hcd->timer);
+	dum_hcd->timer.function = dummy_timer;
+	dum_hcd->timer.data = (unsigned long)dum_hcd;
+	dum_hcd->rh_state = DUMMY_RH_RUNNING;
+	INIT_LIST_HEAD(&dum_hcd->urbp_list);
+	dummy_hcd_to_hcd(dum_hcd)->power_budget = POWER_BUDGET;
+	dummy_hcd_to_hcd(dum_hcd)->state = HC_STATE_RUNNING;
+	dummy_hcd_to_hcd(dum_hcd)->uses_new_polling = 1;
+#ifdef CONFIG_USB_OTG
+	dummy_hcd_to_hcd(dum_hcd)->self.otg_port = 1;
+#endif
+	return 0;
+
+	/* FIXME 'urbs' should be a per-device thing, maybe in usbcore */
+	return device_create_file(dummy_dev(dum_hcd), &dev_attr_urbs);
+}
+
 static int dummy_start(struct usb_hcd *hcd)
 {
 	struct dummy_hcd	*dum_hcd = hcd_to_dummy_hcd(hcd);
@@ -1880,6 +2197,9 @@ static int dummy_start(struct usb_hcd *hcd)
 	 * talk to one device (the slave side).  Also appears in sysfs,
 	 * just like more familiar pci-based HCDs.
 	 */
+	if (!usb_hcd_is_primary_hcd(hcd))
+		return dummy_start_ss(dum_hcd);
+
 	spin_lock_init(&dum_hcd->dum->lock);
 	init_timer(&dum_hcd->timer);
 	dum_hcd->timer.function = dummy_timer;
@@ -1922,19 +2242,52 @@ static int dummy_setup(struct usb_hcd *hcd)
 	if (usb_hcd_is_primary_hcd(hcd)) {
 		the_controller.hs_hcd = hcd_to_dummy_hcd(hcd);
 		the_controller.hs_hcd->dum = &the_controller;
-		/* Mark the first roothub as being USB 2.0. */
+		/*
+		 * Mark the first roothub as being USB 2.0.
+		 * The USB 3.0 roothub will be registered later by
+		 * dummy_hcd_probe()
+		 */
 		hcd->speed = HCD_USB2;
 		hcd->self.root_hub->speed = USB_SPEED_HIGH;
+	} else {
+		the_controller.ss_hcd = hcd_to_dummy_hcd(hcd);
+		the_controller.ss_hcd->dum = &the_controller;
+		hcd->speed = HCD_USB3;
+		hcd->self.root_hub->speed = USB_SPEED_SUPER;
 	}
 	return 0;
 }
 
+/* Change a group of bulk endpoints to support multiple stream IDs */
+int dummy_alloc_streams(struct usb_hcd *hcd, struct usb_device *udev,
+	struct usb_host_endpoint **eps, unsigned int num_eps,
+	unsigned int num_streams, gfp_t mem_flags)
+{
+	if (hcd->speed != HCD_USB3)
+		dev_dbg(dummy_dev(hcd_to_dummy_hcd(hcd)),
+			"%s() - ERROR! Not supported for USB2.0 roothub\n",
+			__func__);
+	return 0;
+}
+
+/* Reverts a group of bulk endpoints back to not using stream IDs. */
+int dummy_free_streams(struct usb_hcd *hcd, struct usb_device *udev,
+	struct usb_host_endpoint **eps, unsigned int num_eps,
+	gfp_t mem_flags)
+{
+	if (hcd->speed != HCD_USB3)
+		dev_dbg(dummy_dev(hcd_to_dummy_hcd(hcd)),
+			"%s() - ERROR! Not supported for USB2.0 roothub\n",
+			__func__);
+	return 0;
+}
+
 static const struct hc_driver dummy_hcd = {
 	.description =		(char *) driver_name,
 	.product_desc =		"Dummy host controller",
 	.hcd_priv_size =	sizeof(struct dummy_hcd),
 
-	.flags =		HCD_USB2,
+	.flags =		HCD_USB3 | HCD_SHARED,
 
 	.reset =		dummy_setup,
 	.start =		dummy_start,
@@ -1949,11 +2302,15 @@ static const struct hc_driver dummy_hcd = {
 	.hub_control = 		dummy_hub_control,
 	.bus_suspend =		dummy_bus_suspend,
 	.bus_resume =		dummy_bus_resume,
+
+	.alloc_streams =	dummy_alloc_streams,
+	.free_streams =		dummy_free_streams,
 };
 
 static int dummy_hcd_probe(struct platform_device *pdev)
 {
 	struct usb_hcd		*hs_hcd;
+	struct usb_hcd		*ss_hcd;
 	int			retval;
 
 	dev_info(&pdev->dev, "%s, driver " DRIVER_VERSION "\n", driver_desc);
@@ -1965,8 +2322,27 @@ static int dummy_hcd_probe(struct platform_device *pdev)
 	retval = usb_add_hcd(hs_hcd, 0, 0);
 	if (retval != 0) {
 		usb_put_hcd(hs_hcd);
-		the_controller.hs_hcd = NULL;
+		return retval;
+	}
+
+	ss_hcd = usb_create_shared_hcd(&dummy_hcd, &pdev->dev,
+				dev_name(&pdev->dev), hs_hcd);
+	if (!ss_hcd) {
+		retval = -ENOMEM;
+		goto dealloc_usb2_hcd;
 	}
+
+	retval = usb_add_hcd(ss_hcd, 0, 0);
+	if (retval)
+		goto put_usb3_hcd;
+
+	return 0;
+
+put_usb3_hcd:
+	usb_put_hcd(ss_hcd);
+dealloc_usb2_hcd:
+	usb_put_hcd(hs_hcd);
+	the_controller.hs_hcd = the_controller.ss_hcd = NULL;
 	return retval;
 }
 
@@ -1975,9 +2351,13 @@ static int dummy_hcd_remove (struct platform_device *pdev)
 	struct dummy		*dum;
 
 	dum = (hcd_to_dummy_hcd(platform_get_drvdata(pdev)))->dum;
+	if (dum->ss_hcd) {
+		usb_remove_hcd(dummy_hcd_to_hcd(dum->ss_hcd));
+		usb_put_hcd(dummy_hcd_to_hcd(dum->ss_hcd));
+	}
 	usb_remove_hcd(dummy_hcd_to_hcd(dum->hs_hcd));
 	usb_put_hcd(dummy_hcd_to_hcd(dum->hs_hcd));
-	the_controller.hs_hcd = NULL;
+	the_controller.ss_hcd = the_controller.hs_hcd = NULL;
 	return 0;
 }
 
@@ -2051,7 +2431,7 @@ static int __init init (void)
 	retval = platform_device_add(the_hcd_pdev);
 	if (retval < 0)
 		goto err_add_hcd;
-	if (!the_controller.hs_hcd) {
+	if (!the_controller.hs_hcd || !the_controller.ss_hcd) {
 		/*
 		 * The hcd was added successfully but its probe function failed
 		 * for some reason.
-- 
1.7.3.3

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
