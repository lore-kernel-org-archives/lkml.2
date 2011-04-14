Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab1DNLqN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 07:46:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:49939 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab1DNLqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 07:46:11 -0400
Date: Thu, 14 Apr 2011 13:46:05 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Felipe Balbi <balbi@ti.com>
Cc: Tanya Brokhman <tlinder@codeaurora.org>, gregkh@suse.de,
        linux-arm-msm@vger.kernel.org, ablay@codeaurora.org,
        "'open list:USB GADGET/PERIPH...'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: [PATCH] usb: merge the two dummy_hcds into one
Message-ID: <20110414114605.GA17871@linutronix.de>
References: <1300867372-20811-1-git-send-email-tlinder@codeaurora.org>
 <20110325134730.GO2609@legolas.emea.dhcp.ti.com>
 <000201cbec79$3a7dc4f0$af794ed0$@org>
 <20110328084157.GH2251@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110328084157.GH2251@legolas.emea.dhcp.ti.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch merges the two HCDs so there is one for both.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/gadget/dummy_hcd.c |  353 ++++++++++++----------------------------
 1 files changed, 102 insertions(+), 251 deletions(-)

diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index 634c4ec..db44183 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -62,12 +62,9 @@
 #define POWER_BUDGET	500	/* in mA; use 8 for low-power port testing */
 
 static const char	driver_name [] = "dummy_hcd";
-static const char	ss_driver_name[] = "ss_dummy_hcd";
 static const char	driver_desc [] = "USB Host+Gadget Emulator";
-static const char	ss_driver_desc[] = "SS USB Host+Gadget Emulator";
 
 static const char	gadget_name [] = "dummy_udc";
-static const char	ss_gadget_name[] = "ss_dummy_udc";
 
 MODULE_DESCRIPTION (DRIVER_DESC);
 MODULE_AUTHOR ("David Brownell");
@@ -223,7 +220,6 @@ static inline struct dummy *gadget_dev_to_dummy (struct device *dev)
 }
 
 static struct dummy			*the_controller;
-static struct dummy			*the_ss_controller;
 
 /*-------------------------------------------------------------------------*/
 
@@ -263,8 +259,73 @@ stop_activity (struct dummy *dum)
 	/* driver now does any non-usb quiescing necessary */
 }
 
+
 /**
- * set_ss_link_state() - Sets the current state of the SuperSpeed link
+ * set_link_state_usb2() - Sets the current state of the link
+ * @dum: pointer to the dummy_hcd structure to update the link
+ *     state for
+ *
+ * This function updates the port_status according to the link
+ * state. The old status is saved befor updating.
+ * Note: caller must hold the lock.
+ */
+static void set_link_state_usb2(struct dummy *dum)
+{
+	dum->active = 0;
+	if ((dum->port_status & USB_PORT_STAT_POWER) == 0)
+		dum->port_status = 0;
+
+	/* UDC suspend must cause a disconnect */
+	else if (!dum->pullup || dum->udc_suspended) {
+		dum->port_status &= ~(USB_PORT_STAT_CONNECTION |
+					USB_PORT_STAT_ENABLE |
+					USB_PORT_STAT_LOW_SPEED |
+					USB_PORT_STAT_HIGH_SPEED |
+					USB_PORT_STAT_SUSPEND);
+		if ((dum->old_status & USB_PORT_STAT_CONNECTION) != 0)
+			dum->port_status |= (USB_PORT_STAT_C_CONNECTION << 16);
+	} else {
+		dum->port_status |= USB_PORT_STAT_CONNECTION;
+		if ((dum->old_status & USB_PORT_STAT_CONNECTION) == 0)
+			dum->port_status |= (USB_PORT_STAT_C_CONNECTION << 16);
+		if ((dum->port_status & USB_PORT_STAT_ENABLE) == 0)
+			dum->port_status &= ~USB_PORT_STAT_SUSPEND;
+		else if ((dum->port_status & USB_PORT_STAT_SUSPEND) == 0 &&
+				dum->rh_state != DUMMY_RH_SUSPENDED)
+			dum->active = 1;
+	}
+
+	if ((dum->port_status & USB_PORT_STAT_ENABLE) == 0 || dum->active)
+		dum->resuming = 0;
+
+	if ((dum->port_status & USB_PORT_STAT_CONNECTION) == 0 ||
+			(dum->port_status & USB_PORT_STAT_RESET) != 0) {
+		if ((dum->old_status & USB_PORT_STAT_CONNECTION) != 0 &&
+				(dum->old_status & USB_PORT_STAT_RESET) == 0 &&
+				dum->driver) {
+			stop_activity (dum);
+			spin_unlock (&dum->lock);
+			dum->driver->disconnect (&dum->gadget);
+			spin_lock (&dum->lock);
+		}
+	} else if (dum->active != dum->old_active) {
+		if (dum->old_active && dum->driver->suspend) {
+			spin_unlock (&dum->lock);
+			dum->driver->suspend (&dum->gadget);
+			spin_lock (&dum->lock);
+		} else if (!dum->old_active && dum->driver->resume) {
+			spin_unlock (&dum->lock);
+			dum->driver->resume (&dum->gadget);
+			spin_lock (&dum->lock);
+		}
+	}
+
+	dum->old_status = dum->port_status;
+	dum->old_active = dum->active;
+}
+
+/**
+ * set_link_state_usb3() - Sets the current state of the SuperSpeed link
  * @dum: pointer to the dummy_hcd structure to update the link
  *     state for
  *
@@ -273,8 +334,7 @@ stop_activity (struct dummy *dum)
  * Note: this function should be called only for SuperSpeed
  * master and the caller must hold the lock.
  */
-static void
-set_ss_link_state(struct dummy *dum)
+static void set_link_state_usb3(struct dummy *dum)
 {
 	dum->active = 0;
 	if ((dum->port_status & USB_SS_PORT_STAT_POWER) == 0)
@@ -335,73 +395,14 @@ set_ss_link_state(struct dummy *dum)
 	dum->old_active = dum->active;
 }
 
-/**
- * set_link_state() - Sets the current state of the link
- * @dum: pointer to the dummy_hcd structure to update the link
- *     state for
- *
- * This function updates the port_status according to the link
- * state. The old status is saved befor updating.
- * Note: caller must hold the lock.
- */
-static void
-set_link_state (struct dummy *dum)
+static void set_link_state(struct dummy *dum)
 {
-	if (dum == the_ss_controller) {
-		set_ss_link_state(dum);
-		return;
-	}
-	dum->active = 0;
-	if ((dum->port_status & USB_PORT_STAT_POWER) == 0)
-		dum->port_status = 0;
-
-	/* UDC suspend must cause a disconnect */
-	else if (!dum->pullup || dum->udc_suspended) {
-		dum->port_status &= ~(USB_PORT_STAT_CONNECTION |
-					USB_PORT_STAT_ENABLE |
-					USB_PORT_STAT_LOW_SPEED |
-					USB_PORT_STAT_HIGH_SPEED |
-					USB_PORT_STAT_SUSPEND);
-		if ((dum->old_status & USB_PORT_STAT_CONNECTION) != 0)
-			dum->port_status |= (USB_PORT_STAT_C_CONNECTION << 16);
-	} else {
-		dum->port_status |= USB_PORT_STAT_CONNECTION;
-		if ((dum->old_status & USB_PORT_STAT_CONNECTION) == 0)
-			dum->port_status |= (USB_PORT_STAT_C_CONNECTION << 16);
-		if ((dum->port_status & USB_PORT_STAT_ENABLE) == 0)
-			dum->port_status &= ~USB_PORT_STAT_SUSPEND;
-		else if ((dum->port_status & USB_PORT_STAT_SUSPEND) == 0 &&
-				dum->rh_state != DUMMY_RH_SUSPENDED)
-			dum->active = 1;
-	}
-
-	if ((dum->port_status & USB_PORT_STAT_ENABLE) == 0 || dum->active)
-		dum->resuming = 0;
-
-	if ((dum->port_status & USB_PORT_STAT_CONNECTION) == 0 ||
-			(dum->port_status & USB_PORT_STAT_RESET) != 0) {
-		if ((dum->old_status & USB_PORT_STAT_CONNECTION) != 0 &&
-				(dum->old_status & USB_PORT_STAT_RESET) == 0 &&
-				dum->driver) {
-			stop_activity (dum);
-			spin_unlock (&dum->lock);
-			dum->driver->disconnect (&dum->gadget);
-			spin_lock (&dum->lock);
-		}
-	} else if (dum->active != dum->old_active) {
-		if (dum->old_active && dum->driver->suspend) {
-			spin_unlock (&dum->lock);
-			dum->driver->suspend (&dum->gadget);
-			spin_lock (&dum->lock);
-		} else if (!dum->old_active && dum->driver->resume) {
-			spin_unlock (&dum->lock);
-			dum->driver->resume (&dum->gadget);
-			spin_lock (&dum->lock);
-		}
-	}
+	struct usb_hcd	*hcd = dummy_to_hcd(dum);
 
-	dum->old_status = dum->port_status;
-	dum->old_active = dum->active;
+	if (hcd->speed == HCD_USB3)
+		set_link_state_usb3(dum);
+	else
+		set_link_state_usb2(dum);
 }
 
 /*-------------------------------------------------------------------------*/
@@ -851,14 +852,9 @@ int
 usb_gadget_probe_driver(struct usb_gadget_driver *driver,
 		int (*bind)(struct usb_gadget *))
 {
-	struct dummy	*dum;
+	struct dummy	*dum = the_controller;
 	int		retval, i;
 
-	if (driver->speed == USB_SPEED_SUPER)
-		dum = the_ss_controller;
-	else
-		dum = the_controller;
-
 	if (!dum)
 		return -EINVAL;
 	if (dum->driver)
@@ -926,17 +922,12 @@ EXPORT_SYMBOL(usb_gadget_probe_driver);
 int
 usb_gadget_unregister_driver (struct usb_gadget_driver *driver)
 {
-	struct dummy	*dum ;
+	struct dummy	*dum = the_controller;
 	unsigned long	flags;
 
 	if (!driver || !driver->unbind)
 		return -EINVAL;
 
-	if (driver->speed == USB_SPEED_SUPER)
-		dum = the_ss_controller;
-	else
-		dum = the_controller;
-
 	if (!dum)
 		return -ENODEV;
 	if (driver != dum->driver)
@@ -1018,34 +1009,6 @@ static int dummy_udc_probe (struct platform_device *pdev)
 	return rc;
 }
 
-static int dummy_ss_udc_probe(struct platform_device *pdev)
-{
-	struct dummy	*dum = the_ss_controller;
-	int		rc;
-
-	dum->gadget.name = gadget_name;
-	dum->gadget.ops = &dummy_ops;
-	dum->gadget.is_dualspeed = 1;
-
-	/* maybe claim OTG support, though we won't complete HNP */
-	dum->gadget.is_otg = (dummy_to_hcd(dum)->self.otg_port != 0);
-
-	dev_set_name(&dum->gadget.dev, "ss_gadget");
-	dum->gadget.dev.parent = &pdev->dev;
-	dum->gadget.dev.release = dummy_gadget_release;
-	rc = device_register(&dum->gadget.dev);
-	if (rc < 0)
-		return rc;
-
-	usb_get_hcd(dummy_to_hcd(dum));
-
-	platform_set_drvdata(pdev, dum);
-	rc = device_create_file(&dum->gadget.dev, &dev_attr_function);
-	if (rc < 0)
-		device_unregister(&dum->gadget.dev);
-	return rc;
-}
-
 static int dummy_udc_remove (struct platform_device *pdev)
 {
 	struct dummy	*dum = platform_get_drvdata (pdev);
@@ -1095,17 +1058,6 @@ static struct platform_driver dummy_udc_driver = {
 	},
 };
 
-static struct platform_driver dummy_ss_udc_driver = {
-	.probe		= dummy_ss_udc_probe,
-	.remove		= dummy_udc_remove,
-	.suspend	= dummy_udc_suspend,
-	.resume		= dummy_udc_resume,
-	.driver		= {
-		.name	= (char *) ss_gadget_name,
-		.owner	= THIS_MODULE,
-	},
-};
-
 /*-------------------------------------------------------------------------*/
 
 /* MASTER/HOST SIDE DRIVER
@@ -1823,7 +1775,7 @@ ss_hub_descriptor(struct usb_hub_descriptor *desc)
 }
 
 /**
- * dummy_ss_hub_control() - handles the control requests of the dummy (ss hub)
+ * dummy_hub_control_usb3() - handles the control requests of the dummy (ss hub)
  * master.
  * @hcd: pointer to the hcd to handle
  * @typeReq: type of the request
@@ -1839,7 +1791,7 @@ ss_hub_descriptor(struct usb_hub_descriptor *desc)
  * enumeration are handled by the dummy_timer
  * Note: this function is used only for the SS root hub
  */
-static int dummy_ss_hub_control(
+static int dummy_hub_control_usb3(
 	struct usb_hcd	*hcd,
 	u16		typeReq,
 	u16		wValue,
@@ -1867,7 +1819,7 @@ static int dummy_ss_hub_control(
 			/* FALLS THROUGH */
 		default:
 			dum->port_status &= ~(1 << wValue);
-			set_link_state(dum);
+			set_link_state_usb3(dum);
 		}
 		break;
 	case GetHubDescriptor:
@@ -1898,7 +1850,7 @@ static int dummy_ss_hub_control(
 		if (dum->pullup)
 			dum->port_status |= USB_PORT_STAT_ENABLE;
 
-		set_link_state(dum);
+		set_link_state_usb3(dum);
 
 		((__le16 *) buf)[0] = cpu_to_le16 (dum->port_status);
 		((__le16 *) buf)[1] = cpu_to_le16 (dum->port_status >> 16);
@@ -1920,7 +1872,7 @@ static int dummy_ss_hub_control(
 			break;
 		case USB_PORT_FEAT_POWER:
 			dum->port_status |= USB_SS_PORT_STAT_POWER;
-			set_link_state(dum);
+			set_link_state_usb3(dum);
 			break;
 		case USB_PORT_FEAT_BH_PORT_RESET:
 		case USB_PORT_FEAT_RESET:
@@ -1933,8 +1885,7 @@ static int dummy_ss_hub_control(
 			 * We want to reset device status. All but the
 			 * Self powered feature
 			 */
-			dum->devstatus &= 0x0000 |
-				(1 << USB_DEVICE_SELF_POWERED);
+			dum->devstatus &= (1 << USB_DEVICE_SELF_POWERED);
 			/*
 			 * FIXME: what is the correct reset signaling interval?
 			 * Is it still 50msec as for HS?
@@ -1945,7 +1896,7 @@ static int dummy_ss_hub_control(
 			if ((dum->port_status &
 			     USB_SS_PORT_STAT_POWER) != 0) {
 				dum->port_status |= (1 << wValue);
-				set_link_state(dum);
+				set_link_state_usb3(dum);
 			}
 		}
 		break;
@@ -1969,9 +1920,8 @@ static int dummy_ss_hub_control(
 	return retval;
 }
 
-
 /**
- * dummy_hub_control() - handles the control requests of the dummy (hs hub)
+ * dummy_hub_control_usb2() - handles the control requests of the dummy (hs hub)
  * master.
  * @hcd: pointer to the hcd to handle
  * @typeReq: type of the request
@@ -1987,7 +1937,7 @@ static int dummy_ss_hub_control(
  * enumeration are handled by the dummy_timer
  * Note: this function is used only for the HS root hub
  */
-static int dummy_hub_control(
+static int dummy_hub_control_usb2(
 	struct usb_hcd	*hcd,
 	u16		typeReq,
 	u16		wValue,
@@ -2023,7 +1973,7 @@ static int dummy_hub_control(
 			/* FALLS THROUGH */
 		default:
 			dum->port_status &= ~(1 << wValue);
-			set_link_state (dum);
+			set_link_state_usb2(dum);
 		}
 		break;
 	case GetHubDescriptor:
@@ -2069,7 +2019,7 @@ static int dummy_hub_control(
 				}
 			}
 		}
-		set_link_state (dum);
+		set_link_state_usb2(dum);
 		((__le16 *) buf)[0] = cpu_to_le16 (dum->port_status);
 		((__le16 *) buf)[1] = cpu_to_le16 (dum->port_status >> 16);
 		break;
@@ -2085,7 +2035,7 @@ static int dummy_hub_control(
 				/* HNP would happen here; for now we
 				 * assume b_bus_req is always true.
 				 */
-				set_link_state (dum);
+				set_link_state_usb2(dum);
 				if (((1 << USB_DEVICE_B_HNP_ENABLE)
 						& dum->devstatus) != 0)
 					dev_dbg (dummy_dev(dum),
@@ -2094,7 +2044,7 @@ static int dummy_hub_control(
 			break;
 		case USB_PORT_FEAT_POWER:
 			dum->port_status |= USB_PORT_STAT_POWER;
-			set_link_state (dum);
+			set_link_state_usb2(dum);
 			break;
 		case USB_PORT_FEAT_RESET:
 			/* if it's already enabled, disable */
@@ -2112,7 +2062,7 @@ static int dummy_hub_control(
 		default:
 			if ((dum->port_status & USB_PORT_STAT_POWER) != 0) {
 				dum->port_status |= (1 << wValue);
-				set_link_state (dum);
+				set_link_state_usb2(dum);
 			}
 		}
 		break;
@@ -2132,6 +2082,17 @@ static int dummy_hub_control(
 	return retval;
 }
 
+static int dummy_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
+		u16 wIndex, char *buf, u16 wLength)
+{
+	if (hcd->speed == HCD_USB3)
+		return dummy_hub_control_usb3(hcd, typeReq, wValue, wIndex, buf,
+			wLength);
+
+	return dummy_hub_control_usb2(hcd, typeReq, wValue, wIndex, buf,
+			wLength);
+}
+
 static int dummy_bus_suspend (struct usb_hcd *hcd)
 {
 	struct dummy *dum = hcd_to_dummy (hcd);
@@ -2182,9 +2143,7 @@ show_urb (char *buf, size_t size, struct urb *urb)
 		 case USB_SPEED_LOW:	s = "ls"; break;
 		 case USB_SPEED_FULL:	s = "fs"; break;
 		 case USB_SPEED_HIGH:	s = "hs"; break;
-		 case USB_SPEED_SUPER:
-			 s = "ss";
-			 break;
+		 case USB_SPEED_SUPER:	s = "ss"; break;
 		 default:		s = "?"; break;
 		 }; s; }),
 		ep, ep ? (usb_pipein (urb->pipe) ? "in" : "out") : "",
@@ -2275,7 +2234,7 @@ static const struct hc_driver dummy_hcd = {
 	.product_desc =		"Dummy host controller",
 	.hcd_priv_size =	sizeof(struct dummy),
 
-	.flags =		HCD_USB2,
+	.flags =		HCD_USB3,
 
 	.start =		dummy_start,
 	.stop =			dummy_stop,
@@ -2291,27 +2250,6 @@ static const struct hc_driver dummy_hcd = {
 	.bus_resume =		dummy_bus_resume,
 };
 
-static const struct hc_driver dummy_ss_hcd = {
-	.description =		(char *) ss_driver_name,
-	.product_desc =		"Dummy SS host controller",
-	.hcd_priv_size =	sizeof(struct dummy),
-
-	.flags =		HCD_USB3,
-
-	.start =		dummy_start,
-	.stop =			dummy_stop,
-
-	.urb_enqueue =		dummy_urb_enqueue,
-	.urb_dequeue =		dummy_urb_dequeue,
-
-	.get_frame_number =	dummy_h_get_frame,
-
-	.hub_status_data =	dummy_hub_status,
-	.hub_control =		dummy_ss_hub_control,
-	.bus_suspend =		dummy_bus_suspend,
-	.bus_resume =		dummy_bus_resume,
-};
-
 static int dummy_hcd_probe(struct platform_device *pdev)
 {
 	struct usb_hcd		*hcd;
@@ -2332,26 +2270,6 @@ static int dummy_hcd_probe(struct platform_device *pdev)
 	return retval;
 }
 
-static int dummy_hcd_probe_ss(struct platform_device *pdev)
-{
-	struct usb_hcd		*hcd;
-	int			retval;
-
-	dev_info(&pdev->dev, "%s, driver " DRIVER_VERSION "\n", ss_driver_desc);
-
-	hcd = usb_create_hcd(&dummy_ss_hcd, &pdev->dev, dev_name(&pdev->dev));
-	if (!hcd)
-		return -ENOMEM;
-	the_ss_controller = hcd_to_dummy(hcd);
-
-	retval = usb_add_hcd(hcd, 0, 0);
-	if (retval != 0) {
-		usb_put_hcd(hcd);
-		the_ss_controller = NULL;
-	}
-	return retval;
-}
-
 static int dummy_hcd_remove (struct platform_device *pdev)
 {
 	struct usb_hcd		*hcd;
@@ -2363,17 +2281,6 @@ static int dummy_hcd_remove (struct platform_device *pdev)
 	return 0;
 }
 
-static int dummy_ss_hcd_remove(struct platform_device *pdev)
-{
-	struct usb_hcd		*hcd;
-
-	hcd = platform_get_drvdata(pdev);
-	usb_remove_hcd(hcd);
-	usb_put_hcd(hcd);
-	the_ss_controller = NULL;
-	return 0;
-}
-
 static int dummy_hcd_suspend (struct platform_device *pdev, pm_message_t state)
 {
 	struct usb_hcd		*hcd;
@@ -2415,23 +2322,10 @@ static struct platform_driver dummy_hcd_driver = {
 	},
 };
 
-static struct platform_driver dummy_ss_hcd_driver = {
-	.probe		= dummy_hcd_probe_ss,
-	.remove		= dummy_ss_hcd_remove,
-	.suspend	= dummy_hcd_suspend,
-	.resume		= dummy_hcd_resume,
-	.driver		= {
-		.name	= (char *) ss_driver_name,
-		.owner	= THIS_MODULE,
-	},
-};
-
 /*-------------------------------------------------------------------------*/
 
 static struct platform_device *the_udc_pdev;
-static struct platform_device *the_ss_udc_pdev;
 static struct platform_device *the_hcd_pdev;
-static struct platform_device *the_ss_hcd_pdev;
 
 static int __init init (void)
 {
@@ -2443,73 +2337,34 @@ static int __init init (void)
 	the_hcd_pdev = platform_device_alloc(driver_name, -1);
 	if (!the_hcd_pdev)
 		return retval;
-
-	the_ss_hcd_pdev = platform_device_alloc(ss_driver_name, -1);
-	if (!the_ss_hcd_pdev)
-		goto err_alloc_ss_hcd;
-
 	the_udc_pdev = platform_device_alloc(gadget_name, -1);
 	if (!the_udc_pdev)
 		goto err_alloc_udc;
 
-	the_ss_udc_pdev = platform_device_alloc(ss_gadget_name, -1);
-	if (!the_ss_udc_pdev)
-		goto err_alloc_ss_udc;
-
 	retval = platform_driver_register(&dummy_hcd_driver);
 	if (retval < 0)
 		goto err_register_hcd_driver;
-
-	retval = platform_driver_register(&dummy_ss_hcd_driver);
-	if (retval < 0)
-		goto err_register_ss_hcd_driver;
-
 	retval = platform_driver_register(&dummy_udc_driver);
 	if (retval < 0)
 		goto err_register_udc_driver;
 
-	retval = platform_driver_register(&dummy_ss_udc_driver);
-	if (retval < 0)
-		goto err_register_ss_udc_driver;
-
 	retval = platform_device_add(the_hcd_pdev);
 	if (retval < 0)
 		goto err_add_hcd;
-
-	retval = platform_device_add(the_ss_hcd_pdev);
-	if (retval < 0)
-		goto err_add_ss_hcd;
-
 	retval = platform_device_add(the_udc_pdev);
 	if (retval < 0)
 		goto err_add_udc;
-
-	retval = platform_device_add(the_ss_udc_pdev);
-	if (retval < 0)
-		goto err_add_ss_udc;
 	return retval;
 
-err_add_ss_udc:
-	platform_device_unregister(the_udc_pdev);
 err_add_udc:
-	platform_device_del(the_ss_hcd_pdev);
-err_add_ss_hcd:
 	platform_device_del(the_hcd_pdev);
 err_add_hcd:
-	platform_driver_unregister(&dummy_ss_udc_driver);
-err_register_ss_udc_driver:
 	platform_driver_unregister(&dummy_udc_driver);
 err_register_udc_driver:
-	platform_driver_unregister(&dummy_ss_hcd_driver);
-err_register_ss_hcd_driver:
 	platform_driver_unregister(&dummy_hcd_driver);
 err_register_hcd_driver:
-	platform_device_put(the_ss_udc_pdev);
-err_alloc_ss_udc:
 	platform_device_put(the_udc_pdev);
 err_alloc_udc:
-	platform_device_put(the_ss_hcd_pdev);
-err_alloc_ss_hcd:
 	platform_device_put(the_hcd_pdev);
 	return retval;
 }
@@ -2518,12 +2373,8 @@ module_init (init);
 static void __exit cleanup (void)
 {
 	platform_device_unregister(the_udc_pdev);
-	platform_device_unregister(the_ss_udc_pdev);
 	platform_device_unregister(the_hcd_pdev);
-	platform_device_unregister(the_ss_hcd_pdev);
 	platform_driver_unregister(&dummy_udc_driver);
-	platform_driver_unregister(&dummy_ss_udc_driver);
 	platform_driver_unregister(&dummy_hcd_driver);
-	platform_driver_unregister(&dummy_ss_hcd_driver);
 }
 module_exit (cleanup);
-- 
1.7.4

