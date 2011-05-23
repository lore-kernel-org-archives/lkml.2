Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab1EWGnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 02:43:11 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39025 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab1EWGnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 02:43:06 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6354"; a="92929384"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v12 6/8] usb:dummy_hcd: use the shared_hcd infrastructure
Date: Mon, 23 May 2011 09:41:15 +0300
Message-Id: <1306132882-9668-7-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1306132882-9668-1-git-send-email-tlinder@codeaurora.org>
References: <1306132882-9668-1-git-send-email-tlinder@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a preparation for adding SuperSpeed support to dummy hcd.
It takes the master side fields out of the struct dummy to a separate
structure. The init process was also modified to resemble the way it is
done by xHCI.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

---
 drivers/usb/gadget/dummy_hcd.c |  501 +++++++++++++++++++++-------------------
 1 files changed, 266 insertions(+), 235 deletions(-)

diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index 61ff9279..bf7981d 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -152,6 +152,22 @@ enum dummy_rh_state {
 	DUMMY_RH_RUNNING
 };
 
+struct dummy_hcd {
+	struct dummy			*dum;
+	enum dummy_rh_state		rh_state;
+	struct timer_list		timer;
+	u32				port_status;
+	u32				old_status;
+	unsigned long			re_timeout;
+
+	struct usb_device		*udev;
+	struct list_head		urbp_list;
+
+	unsigned			active:1;
+	unsigned			old_active:1;
+	unsigned			resuming:1;
+};
+
 struct dummy {
 	spinlock_t			lock;
 
@@ -167,36 +183,26 @@ struct dummy {
 	u16				devstatus;
 	unsigned			udc_suspended:1;
 	unsigned			pullup:1;
-	unsigned			active:1;
-	unsigned			old_active:1;
 
 	/*
 	 * MASTER/HOST side support
 	 */
-	enum dummy_rh_state		rh_state;
-	struct timer_list		timer;
-	u32				port_status;
-	u32				old_status;
-	unsigned			resuming:1;
-	unsigned long			re_timeout;
-
-	struct usb_device		*udev;
-	struct list_head		urbp_list;
+	struct dummy_hcd		*hs_hcd;
 };
 
-static inline struct dummy *hcd_to_dummy (struct usb_hcd *hcd)
+static inline struct dummy_hcd *hcd_to_dummy_hcd(struct usb_hcd *hcd)
 {
-	return (struct dummy *) (hcd->hcd_priv);
+	return (struct dummy_hcd *) (hcd->hcd_priv);
 }
 
-static inline struct usb_hcd *dummy_to_hcd (struct dummy *dum)
+static inline struct usb_hcd *dummy_hcd_to_hcd(struct dummy_hcd *dum)
 {
 	return container_of((void *) dum, struct usb_hcd, hcd_priv);
 }
 
-static inline struct device *dummy_dev (struct dummy *dum)
+static inline struct device *dummy_dev(struct dummy_hcd *dum)
 {
-	return dummy_to_hcd(dum)->self.controller;
+	return dummy_hcd_to_hcd(dum)->self.controller;
 }
 
 static inline struct device *udc_dev (struct dummy *dum)
@@ -209,9 +215,10 @@ static inline struct dummy *ep_to_dummy (struct dummy_ep *ep)
 	return container_of (ep->gadget, struct dummy, gadget);
 }
 
-static inline struct dummy *gadget_to_dummy (struct usb_gadget *gadget)
+static inline struct dummy_hcd *gadget_to_dummy_hcd(struct usb_gadget *gadget)
 {
-	return container_of (gadget, struct dummy, gadget);
+	struct dummy *dum = container_of(gadget, struct dummy, gadget);
+	return dum->hs_hcd;
 }
 
 static inline struct dummy *gadget_dev_to_dummy (struct device *dev)
@@ -219,7 +226,7 @@ static inline struct dummy *gadget_dev_to_dummy (struct device *dev)
 	return container_of (dev, struct dummy, gadget.dev);
 }
 
-static struct dummy			*the_controller;
+static struct dummy			the_controller;
 
 /*-------------------------------------------------------------------------*/
 
@@ -260,60 +267,64 @@ stop_activity (struct dummy *dum)
 }
 
 /* caller must hold lock */
-static void
-set_link_state (struct dummy *dum)
+static void set_link_state(struct dummy_hcd *dum_hcd)
 {
-	dum->active = 0;
-	if ((dum->port_status & USB_PORT_STAT_POWER) == 0)
-		dum->port_status = 0;
+	struct dummy *dum = dum_hcd->dum;
+
+	dum_hcd->active = 0;
+	if ((dum_hcd->port_status & USB_PORT_STAT_POWER) == 0)
+		dum_hcd->port_status = 0;
 
 	/* UDC suspend must cause a disconnect */
 	else if (!dum->pullup || dum->udc_suspended) {
-		dum->port_status &= ~(USB_PORT_STAT_CONNECTION |
+		dum_hcd->port_status &= ~(USB_PORT_STAT_CONNECTION |
 					USB_PORT_STAT_ENABLE |
 					USB_PORT_STAT_LOW_SPEED |
 					USB_PORT_STAT_HIGH_SPEED |
 					USB_PORT_STAT_SUSPEND);
-		if ((dum->old_status & USB_PORT_STAT_CONNECTION) != 0)
-			dum->port_status |= (USB_PORT_STAT_C_CONNECTION << 16);
+		if ((dum_hcd->old_status & USB_PORT_STAT_CONNECTION) != 0)
+			dum_hcd->port_status |=
+				(USB_PORT_STAT_C_CONNECTION << 16);
 	} else {
-		dum->port_status |= USB_PORT_STAT_CONNECTION;
-		if ((dum->old_status & USB_PORT_STAT_CONNECTION) == 0)
-			dum->port_status |= (USB_PORT_STAT_C_CONNECTION << 16);
-		if ((dum->port_status & USB_PORT_STAT_ENABLE) == 0)
-			dum->port_status &= ~USB_PORT_STAT_SUSPEND;
-		else if ((dum->port_status & USB_PORT_STAT_SUSPEND) == 0 &&
-				dum->rh_state != DUMMY_RH_SUSPENDED)
-			dum->active = 1;
+		dum_hcd->port_status |= USB_PORT_STAT_CONNECTION;
+		if ((dum_hcd->old_status & USB_PORT_STAT_CONNECTION) == 0)
+			dum_hcd->port_status |=
+				(USB_PORT_STAT_C_CONNECTION << 16);
+		if ((dum_hcd->port_status & USB_PORT_STAT_ENABLE) == 0)
+			dum_hcd->port_status &= ~USB_PORT_STAT_SUSPEND;
+		else if ((dum_hcd->port_status & USB_PORT_STAT_SUSPEND) == 0 &&
+				dum_hcd->rh_state != DUMMY_RH_SUSPENDED)
+			dum_hcd->active = 1;
 	}
 
-	if ((dum->port_status & USB_PORT_STAT_ENABLE) == 0 || dum->active)
-		dum->resuming = 0;
+	if ((dum_hcd->port_status & USB_PORT_STAT_ENABLE) == 0 ||
+	     dum_hcd->active)
+		dum_hcd->resuming = 0;
 
-	if ((dum->port_status & USB_PORT_STAT_CONNECTION) == 0 ||
-			(dum->port_status & USB_PORT_STAT_RESET) != 0) {
-		if ((dum->old_status & USB_PORT_STAT_CONNECTION) != 0 &&
-				(dum->old_status & USB_PORT_STAT_RESET) == 0 &&
+	if ((dum_hcd->port_status & USB_PORT_STAT_CONNECTION) == 0 ||
+			(dum_hcd->port_status & USB_PORT_STAT_RESET) != 0) {
+		if ((dum_hcd->old_status & USB_PORT_STAT_CONNECTION) != 0 &&
+			(dum_hcd->old_status & USB_PORT_STAT_RESET) == 0 &&
 				dum->driver) {
 			stop_activity (dum);
 			spin_unlock (&dum->lock);
 			dum->driver->disconnect (&dum->gadget);
 			spin_lock (&dum->lock);
 		}
-	} else if (dum->active != dum->old_active) {
-		if (dum->old_active && dum->driver->suspend) {
+	} else if (dum_hcd->active != dum_hcd->old_active) {
+		if (dum_hcd->old_active && dum->driver->suspend) {
 			spin_unlock (&dum->lock);
 			dum->driver->suspend (&dum->gadget);
 			spin_lock (&dum->lock);
-		} else if (!dum->old_active && dum->driver->resume) {
+		} else if (!dum_hcd->old_active && dum->driver->resume) {
 			spin_unlock (&dum->lock);
 			dum->driver->resume (&dum->gadget);
 			spin_lock (&dum->lock);
 		}
 	}
 
-	dum->old_status = dum->port_status;
-	dum->old_active = dum->active;
+	dum_hcd->old_status = dum_hcd->port_status;
+	dum_hcd->old_active = dum_hcd->active;
 }
 
 /*-------------------------------------------------------------------------*/
@@ -332,6 +343,7 @@ static int
 dummy_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 {
 	struct dummy		*dum;
+	struct dummy_hcd	*dum_hcd;
 	struct dummy_ep		*ep;
 	unsigned		max;
 	int			retval;
@@ -341,9 +353,17 @@ dummy_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 			|| desc->bDescriptorType != USB_DT_ENDPOINT)
 		return -EINVAL;
 	dum = ep_to_dummy (ep);
-	if (!dum->driver || !is_enabled (dum))
+	if (!dum->driver)
+		return -ESHUTDOWN;
+	dum_hcd = dum->hs_hcd;
+	if (!is_enabled(dum_hcd))
 		return -ESHUTDOWN;
-	max = le16_to_cpu(desc->wMaxPacketSize) & 0x3ff;
+
+	/*
+	 * For HS/FS devices only bits 0..10 of the wMaxPacketSize represent the
+	 * maximum packet size.
+	 */
+	max = le16_to_cpu(desc->wMaxPacketSize) & 0x7ff;
 
 	/* drivers must not request bad settings, since lower levels
 	 * (hardware or its drivers) may not check.  some endpoints
@@ -507,6 +527,7 @@ dummy_queue (struct usb_ep *_ep, struct usb_request *_req,
 	struct dummy_ep		*ep;
 	struct dummy_request	*req;
 	struct dummy		*dum;
+	struct dummy_hcd	*dum_hcd;
 	unsigned long		flags;
 
 	req = usb_request_to_dummy_request (_req);
@@ -518,7 +539,8 @@ dummy_queue (struct usb_ep *_ep, struct usb_request *_req,
 		return -EINVAL;
 
 	dum = ep_to_dummy (ep);
-	if (!dum->driver || !is_enabled (dum))
+	dum_hcd = dum->hs_hcd;
+	if (!dum->driver || !is_enabled(dum_hcd))
 		return -ESHUTDOWN;
 
 #if 0
@@ -662,24 +684,24 @@ static int dummy_g_get_frame (struct usb_gadget *_gadget)
 
 static int dummy_wakeup (struct usb_gadget *_gadget)
 {
-	struct dummy	*dum;
+	struct dummy_hcd *dum_hcd;
 
-	dum = gadget_to_dummy (_gadget);
-	if (!(dum->devstatus &	( (1 << USB_DEVICE_B_HNP_ENABLE)
+	dum_hcd = gadget_to_dummy_hcd(_gadget);
+	if (!(dum_hcd->dum->devstatus & ((1 << USB_DEVICE_B_HNP_ENABLE)
 				| (1 << USB_DEVICE_REMOTE_WAKEUP))))
 		return -EINVAL;
-	if ((dum->port_status & USB_PORT_STAT_CONNECTION) == 0)
+	if ((dum_hcd->port_status & USB_PORT_STAT_CONNECTION) == 0)
 		return -ENOLINK;
-	if ((dum->port_status & USB_PORT_STAT_SUSPEND) == 0 &&
-			 dum->rh_state != DUMMY_RH_SUSPENDED)
+	if ((dum_hcd->port_status & USB_PORT_STAT_SUSPEND) == 0 &&
+			 dum_hcd->rh_state != DUMMY_RH_SUSPENDED)
 		return -EIO;
 
 	/* FIXME: What if the root hub is suspended but the port isn't? */
 
 	/* hub notices our request, issues downstream resume, etc */
-	dum->resuming = 1;
-	dum->re_timeout = jiffies + msecs_to_jiffies(20);
-	mod_timer (&dummy_to_hcd (dum)->rh_timer, dum->re_timeout);
+	dum_hcd->resuming = 1;
+	dum_hcd->re_timeout = jiffies + msecs_to_jiffies(20);
+	mod_timer(&dummy_hcd_to_hcd(dum_hcd)->rh_timer, dum_hcd->re_timeout);
 	return 0;
 }
 
@@ -687,7 +709,7 @@ static int dummy_set_selfpowered (struct usb_gadget *_gadget, int value)
 {
 	struct dummy	*dum;
 
-	dum = gadget_to_dummy (_gadget);
+	dum = (gadget_to_dummy_hcd(_gadget))->dum;
 	if (value)
 		dum->devstatus |= (1 << USB_DEVICE_SELF_POWERED);
 	else
@@ -700,13 +722,12 @@ static int dummy_pullup (struct usb_gadget *_gadget, int value)
 	struct dummy	*dum;
 	unsigned long	flags;
 
-	dum = gadget_to_dummy (_gadget);
+	dum = gadget_to_dummy_hcd(_gadget)->dum;
 	spin_lock_irqsave (&dum->lock, flags);
 	dum->pullup = (value != 0);
-	set_link_state (dum);
+	set_link_state(dum->hs_hcd);
 	spin_unlock_irqrestore (&dum->lock, flags);
-
-	usb_hcd_poll_rh_status (dummy_to_hcd (dum));
+	usb_hcd_poll_rh_status(dummy_hcd_to_hcd(dum->hs_hcd));
 	return 0;
 }
 
@@ -751,7 +772,7 @@ int
 usb_gadget_probe_driver(struct usb_gadget_driver *driver,
 		int (*bind)(struct usb_gadget *))
 {
-	struct dummy	*dum = the_controller;
+	struct dummy	*dum = &the_controller;
 	int		retval, i;
 
 	if (!dum)
@@ -787,7 +808,8 @@ usb_gadget_probe_driver(struct usb_gadget_driver *driver,
 	}
 
 	dum->gadget.ep0 = &dum->ep [0].ep;
-	dum->ep [0].ep.maxpacket = 64;
+	dum->gadget.speed = min((u8)driver->speed, (u8)USB_SPEED_HIGH) ;
+	dum->ep[0].ep.maxpacket = 64;
 	list_del_init (&dum->ep [0].ep.ep_list);
 	INIT_LIST_HEAD(&dum->fifo_req.queue);
 
@@ -806,10 +828,12 @@ usb_gadget_probe_driver(struct usb_gadget_driver *driver,
 	/* khubd will enumerate this in a while */
 	spin_lock_irq (&dum->lock);
 	dum->pullup = 1;
-	set_link_state (dum);
+	dum->gadget.is_otg =
+		(dummy_hcd_to_hcd(dum->hs_hcd)->self.otg_port != 0);
+	set_link_state(dum->hs_hcd);
 	spin_unlock_irq (&dum->lock);
 
-	usb_hcd_poll_rh_status (dummy_to_hcd (dum));
+	usb_hcd_poll_rh_status(dummy_hcd_to_hcd(dum->hs_hcd));
 	return 0;
 }
 EXPORT_SYMBOL(usb_gadget_probe_driver);
@@ -817,7 +841,7 @@ EXPORT_SYMBOL(usb_gadget_probe_driver);
 int
 usb_gadget_unregister_driver (struct usb_gadget_driver *driver)
 {
-	struct dummy	*dum = the_controller;
+	struct dummy	*dum = &the_controller;
 	unsigned long	flags;
 
 	if (!dum)
@@ -830,7 +854,7 @@ usb_gadget_unregister_driver (struct usb_gadget_driver *driver)
 
 	spin_lock_irqsave (&dum->lock, flags);
 	dum->pullup = 0;
-	set_link_state (dum);
+	set_link_state(dum->hs_hcd);
 	spin_unlock_irqrestore (&dum->lock, flags);
 
 	driver->unbind (&dum->gadget);
@@ -839,10 +863,9 @@ usb_gadget_unregister_driver (struct usb_gadget_driver *driver)
 
 	spin_lock_irqsave (&dum->lock, flags);
 	dum->pullup = 0;
-	set_link_state (dum);
+	set_link_state(dum->hs_hcd);
 	spin_unlock_irqrestore (&dum->lock, flags);
-
-	usb_hcd_poll_rh_status (dummy_to_hcd (dum));
+	usb_hcd_poll_rh_status(dummy_hcd_to_hcd(dum->hs_hcd));
 	return 0;
 }
 EXPORT_SYMBOL (usb_gadget_unregister_driver);
@@ -864,25 +887,18 @@ EXPORT_SYMBOL (net2280_set_fifo_mode);
 static void
 dummy_gadget_release (struct device *dev)
 {
-	struct dummy	*dum = gadget_dev_to_dummy (dev);
-
-	usb_put_hcd (dummy_to_hcd (dum));
+	return;
 }
 
 static int dummy_udc_probe (struct platform_device *pdev)
 {
-	struct dummy	*dum = the_controller;
+	struct dummy	*dum = &the_controller;
 	int		rc;
 
-	usb_get_hcd(dummy_to_hcd(dum));
-
 	dum->gadget.name = gadget_name;
 	dum->gadget.ops = &dummy_ops;
 	dum->gadget.is_dualspeed = 1;
 
-	/* maybe claim OTG support, though we won't complete HNP */
-	dum->gadget.is_otg = (dummy_to_hcd(dum)->self.otg_port != 0);
-
 	dev_set_name(&dum->gadget.dev, "gadget");
 	dum->gadget.dev.parent = &pdev->dev;
 	dum->gadget.dev.release = dummy_gadget_release;
@@ -917,10 +933,10 @@ static int dummy_udc_suspend (struct platform_device *pdev, pm_message_t state)
 	dev_dbg (&pdev->dev, "%s\n", __func__);
 	spin_lock_irq (&dum->lock);
 	dum->udc_suspended = 1;
-	set_link_state (dum);
+	set_link_state(dum->hs_hcd);
 	spin_unlock_irq (&dum->lock);
 
-	usb_hcd_poll_rh_status (dummy_to_hcd (dum));
+	usb_hcd_poll_rh_status(dummy_hcd_to_hcd(dum->hs_hcd));
 	return 0;
 }
 
@@ -931,10 +947,10 @@ static int dummy_udc_resume (struct platform_device *pdev)
 	dev_dbg (&pdev->dev, "%s\n", __func__);
 	spin_lock_irq (&dum->lock);
 	dum->udc_suspended = 0;
-	set_link_state (dum);
+	set_link_state(dum->hs_hcd);
 	spin_unlock_irq (&dum->lock);
 
-	usb_hcd_poll_rh_status (dummy_to_hcd (dum));
+	usb_hcd_poll_rh_status(dummy_hcd_to_hcd(dum->hs_hcd));
 	return 0;
 }
 
@@ -968,7 +984,7 @@ static int dummy_urb_enqueue (
 	struct urb			*urb,
 	gfp_t				mem_flags
 ) {
-	struct dummy	*dum;
+	struct dummy_hcd *dum_hcd;
 	struct urbp	*urbp;
 	unsigned long	flags;
 	int		rc;
@@ -981,51 +997,51 @@ static int dummy_urb_enqueue (
 		return -ENOMEM;
 	urbp->urb = urb;
 
-	dum = hcd_to_dummy (hcd);
-	spin_lock_irqsave (&dum->lock, flags);
+	dum_hcd = hcd_to_dummy_hcd(hcd);
+	spin_lock_irqsave(&dum_hcd->dum->lock, flags);
 	rc = usb_hcd_link_urb_to_ep(hcd, urb);
 	if (rc) {
 		kfree(urbp);
 		goto done;
 	}
 
-	if (!dum->udev) {
-		dum->udev = urb->dev;
-		usb_get_dev (dum->udev);
-	} else if (unlikely (dum->udev != urb->dev))
-		dev_err (dummy_dev(dum), "usb_device address has changed!\n");
+	if (!dum_hcd->udev) {
+		dum_hcd->udev = urb->dev;
+		usb_get_dev(dum_hcd->udev);
+	} else if (unlikely(dum_hcd->udev != urb->dev))
+		dev_err(dummy_dev(dum_hcd), "usb_device address has changed!\n");
 
-	list_add_tail (&urbp->urbp_list, &dum->urbp_list);
+	list_add_tail(&urbp->urbp_list, &dum_hcd->urbp_list);
 	urb->hcpriv = urbp;
 	if (usb_pipetype (urb->pipe) == PIPE_CONTROL)
 		urb->error_count = 1;		/* mark as a new urb */
 
 	/* kick the scheduler, it'll do the rest */
-	if (!timer_pending (&dum->timer))
-		mod_timer (&dum->timer, jiffies + 1);
+	if (!timer_pending(&dum_hcd->timer))
+		mod_timer(&dum_hcd->timer, jiffies + 1);
 
  done:
-	spin_unlock_irqrestore(&dum->lock, flags);
+	spin_unlock_irqrestore(&dum_hcd->dum->lock, flags);
 	return rc;
 }
 
 static int dummy_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 {
-	struct dummy	*dum;
+	struct dummy_hcd *dum_hcd;
 	unsigned long	flags;
 	int		rc;
 
 	/* giveback happens automatically in timer callback,
 	 * so make sure the callback happens */
-	dum = hcd_to_dummy (hcd);
-	spin_lock_irqsave (&dum->lock, flags);
+	dum_hcd = hcd_to_dummy_hcd(hcd);
+	spin_lock_irqsave(&dum_hcd->dum->lock, flags);
 
 	rc = usb_hcd_check_unlink_urb(hcd, urb, status);
-	if (!rc && dum->rh_state != DUMMY_RH_RUNNING &&
-			!list_empty(&dum->urbp_list))
-		mod_timer (&dum->timer, jiffies);
+	if (!rc && dum_hcd->rh_state != DUMMY_RH_RUNNING &&
+			!list_empty(&dum_hcd->urbp_list))
+		mod_timer(&dum_hcd->timer, jiffies);
 
-	spin_unlock_irqrestore (&dum->lock, flags);
+	spin_unlock_irqrestore(&dum_hcd->dum->lock, flags);
 	return rc;
 }
 
@@ -1165,7 +1181,7 @@ static int periodic_bytes (struct dummy *dum, struct dummy_ep *ep)
 	return limit;
 }
 
-#define is_active(dum)	((dum->port_status & \
+#define is_active(dum_hcd)	((dum_hcd->port_status & \
 		(USB_PORT_STAT_CONNECTION | USB_PORT_STAT_ENABLE | \
 			USB_PORT_STAT_SUSPEND)) \
 		== (USB_PORT_STAT_CONNECTION | USB_PORT_STAT_ENABLE))
@@ -1174,7 +1190,7 @@ static struct dummy_ep *find_endpoint (struct dummy *dum, u8 address)
 {
 	int		i;
 
-	if (!is_active (dum))
+	if (!is_active(dum->hs_hcd))
 		return NULL;
 	if ((address & ~USB_DIR_IN) == 0)
 		return &dum->ep [0];
@@ -1211,11 +1227,12 @@ static struct dummy_ep *find_endpoint (struct dummy *dum, u8 address)
  *	  1 - if the request wasn't handles
  *	  error code on error
  */
-static int handle_control_request(struct dummy *dum, struct urb *urb,
+static int handle_control_request(struct dummy_hcd *dum_hcd, struct urb *urb,
 				  struct usb_ctrlrequest *setup,
 				  int *status)
 {
 	struct dummy_ep		*ep2;
+	struct dummy		*dum = dum_hcd->dum;
 	int			ret_val = 1;
 	unsigned	w_index;
 	unsigned	w_value;
@@ -1334,9 +1351,10 @@ static int handle_control_request(struct dummy *dum, struct urb *urb,
 /* drive both sides of the transfers; looks like irq handlers to
  * both drivers except the callbacks aren't in_irq().
  */
-static void dummy_timer (unsigned long _dum)
+static void dummy_timer(unsigned long _dum_hcd)
 {
-	struct dummy		*dum = (struct dummy *) _dum;
+	struct dummy_hcd	*dum_hcd = (struct dummy_hcd *) _dum_hcd;
+	struct dummy		*dum = dum_hcd->dum;
 	struct urbp		*urbp, *tmp;
 	unsigned long		flags;
 	int			limit, total;
@@ -1354,7 +1372,7 @@ static void dummy_timer (unsigned long _dum)
 		total = 512/*bytes*/ * 13/*packets*/ * 8/*uframes*/;
 		break;
 	default:
-		dev_err (dummy_dev(dum), "bogus device speed\n");
+		dev_err(dummy_dev(dum_hcd), "bogus device speed\n");
 		return;
 	}
 
@@ -1363,8 +1381,8 @@ static void dummy_timer (unsigned long _dum)
 	/* look at each urb queued by the host side driver */
 	spin_lock_irqsave (&dum->lock, flags);
 
-	if (!dum->udev) {
-		dev_err (dummy_dev(dum),
+	if (!dum_hcd->udev) {
+		dev_err(dummy_dev(dum_hcd),
 				"timer fired with no URBs pending?\n");
 		spin_unlock_irqrestore (&dum->lock, flags);
 		return;
@@ -1377,7 +1395,7 @@ static void dummy_timer (unsigned long _dum)
 	}
 
 restart:
-	list_for_each_entry_safe (urbp, tmp, &dum->urbp_list, urbp_list) {
+	list_for_each_entry_safe(urbp, tmp, &dum_hcd->urbp_list, urbp_list) {
 		struct urb		*urb;
 		struct dummy_request	*req;
 		u8			address;
@@ -1388,7 +1406,7 @@ restart:
 		urb = urbp->urb;
 		if (urb->unlinked)
 			goto return_urb;
-		else if (dum->rh_state != DUMMY_RH_RUNNING)
+		else if (dum_hcd->rh_state != DUMMY_RH_RUNNING)
 			continue;
 		type = usb_pipetype (urb->pipe);
 
@@ -1406,7 +1424,7 @@ restart:
 		ep = find_endpoint(dum, address);
 		if (!ep) {
 			/* set_configuration() disagreement */
-			dev_dbg (dummy_dev(dum),
+			dev_dbg(dummy_dev(dum_hcd),
 				"no ep configured for urb %p\n",
 				urb);
 			status = -EPROTO;
@@ -1422,7 +1440,7 @@ restart:
 		}
 		if (ep->halted && !ep->setup_stage) {
 			/* NOTE: must not be iso! */
-			dev_dbg (dummy_dev(dum), "ep %s halted, urb %p\n",
+			dev_dbg(dummy_dev(dum_hcd), "ep %s halted, urb %p\n",
 					ep->ep.name, urb);
 			status = -EPIPE;
 			goto return_urb;
@@ -1457,7 +1475,7 @@ restart:
 			ep->setup_stage = 0;
 			ep->halted = 0;
 
-			value = handle_control_request(dum, urb, &setup,
+			value = handle_control_request(dum_hcd, urb, &setup,
 						       &status);
 
 			/* gadget driver handles all other requests.  block
@@ -1527,20 +1545,20 @@ return_urb:
 		if (ep)
 			ep->already_seen = ep->setup_stage = 0;
 
-		usb_hcd_unlink_urb_from_ep(dummy_to_hcd(dum), urb);
+		usb_hcd_unlink_urb_from_ep(dummy_hcd_to_hcd(dum_hcd), urb);
 		spin_unlock (&dum->lock);
-		usb_hcd_giveback_urb(dummy_to_hcd(dum), urb, status);
+		usb_hcd_giveback_urb(dummy_hcd_to_hcd(dum_hcd), urb, status);
 		spin_lock (&dum->lock);
 
 		goto restart;
 	}
 
-	if (list_empty (&dum->urbp_list)) {
-		usb_put_dev (dum->udev);
-		dum->udev = NULL;
-	} else if (dum->rh_state == DUMMY_RH_RUNNING) {
+	if (list_empty(&dum_hcd->urbp_list)) {
+		usb_put_dev(dum_hcd->udev);
+		dum_hcd->udev = NULL;
+	} else if (dum_hcd->rh_state == DUMMY_RH_RUNNING) {
 		/* want a 1 msec delay here */
-		mod_timer (&dum->timer, jiffies + msecs_to_jiffies(1));
+		mod_timer(&dum_hcd->timer, jiffies + msecs_to_jiffies(1));
 	}
 
 	spin_unlock_irqrestore (&dum->lock, flags);
@@ -1557,32 +1575,32 @@ return_urb:
 
 static int dummy_hub_status (struct usb_hcd *hcd, char *buf)
 {
-	struct dummy		*dum;
+	struct dummy_hcd	*dum_hcd;
 	unsigned long		flags;
 	int			retval = 0;
 
-	dum = hcd_to_dummy (hcd);
+	dum_hcd = hcd_to_dummy_hcd(hcd);
 
-	spin_lock_irqsave (&dum->lock, flags);
+	spin_lock_irqsave(&dum_hcd->dum->lock, flags);
 	if (!HCD_HW_ACCESSIBLE(hcd))
 		goto done;
 
-	if (dum->resuming && time_after_eq (jiffies, dum->re_timeout)) {
-		dum->port_status |= (USB_PORT_STAT_C_SUSPEND << 16);
-		dum->port_status &= ~USB_PORT_STAT_SUSPEND;
-		set_link_state (dum);
+	if (dum_hcd->resuming && time_after_eq(jiffies, dum_hcd->re_timeout)) {
+		dum_hcd->port_status |= (USB_PORT_STAT_C_SUSPEND << 16);
+		dum_hcd->port_status &= ~USB_PORT_STAT_SUSPEND;
+		set_link_state(dum_hcd);
 	}
 
-	if ((dum->port_status & PORT_C_MASK) != 0) {
+	if ((dum_hcd->port_status & PORT_C_MASK) != 0) {
 		*buf = (1 << 1);
-		dev_dbg (dummy_dev(dum), "port status 0x%08x has changes\n",
-				dum->port_status);
+		dev_dbg(dummy_dev(dum_hcd), "port status 0x%08x has changes\n",
+				dum_hcd->port_status);
 		retval = 1;
-		if (dum->rh_state == DUMMY_RH_SUSPENDED)
+		if (dum_hcd->rh_state == DUMMY_RH_SUSPENDED)
 			usb_hcd_resume_root_hub (hcd);
 	}
 done:
-	spin_unlock_irqrestore (&dum->lock, flags);
+	spin_unlock_irqrestore(&dum_hcd->dum->lock, flags);
 	return retval;
 }
 
@@ -1606,39 +1624,40 @@ static int dummy_hub_control (
 	char		*buf,
 	u16		wLength
 ) {
-	struct dummy	*dum;
+	struct dummy_hcd *dum_hcd;
 	int		retval = 0;
 	unsigned long	flags;
 
 	if (!HCD_HW_ACCESSIBLE(hcd))
 		return -ETIMEDOUT;
 
-	dum = hcd_to_dummy (hcd);
-	spin_lock_irqsave (&dum->lock, flags);
+	dum_hcd = hcd_to_dummy_hcd(hcd);
+
+	spin_lock_irqsave(&dum_hcd->dum->lock, flags);
 	switch (typeReq) {
 	case ClearHubFeature:
 		break;
 	case ClearPortFeature:
 		switch (wValue) {
 		case USB_PORT_FEAT_SUSPEND:
-			if (dum->port_status & USB_PORT_STAT_SUSPEND) {
+			if (dum_hcd->port_status & USB_PORT_STAT_SUSPEND) {
 				/* 20msec resume signaling */
-				dum->resuming = 1;
-				dum->re_timeout = jiffies +
+				dum_hcd->resuming = 1;
+				dum_hcd->re_timeout = jiffies +
 						msecs_to_jiffies(20);
 			}
 			break;
 		case USB_PORT_FEAT_POWER:
-			if (dum->port_status & USB_PORT_STAT_POWER)
-				dev_dbg (dummy_dev(dum), "power-off\n");
+			if (dum_hcd->port_status & USB_PORT_STAT_POWER)
+				dev_dbg(dummy_dev(dum_hcd), "power-off\n");
 			/* FALLS THROUGH */
 		default:
-			dum->port_status &= ~(1 << wValue);
-			set_link_state (dum);
+			dum_hcd->port_status &= ~(1 << wValue);
+			set_link_state(dum_hcd);
 		}
 		break;
 	case GetHubDescriptor:
-		hub_descriptor ((struct usb_hub_descriptor *) buf);
+		hub_descriptor((struct usb_hub_descriptor *) buf);
 		break;
 	case GetHubStatus:
 		*(__le32 *) buf = cpu_to_le32 (0);
@@ -1650,39 +1669,38 @@ static int dummy_hub_control (
 		/* whoever resets or resumes must GetPortStatus to
 		 * complete it!!
 		 */
-		if (dum->resuming &&
-				time_after_eq (jiffies, dum->re_timeout)) {
-			dum->port_status |= (USB_PORT_STAT_C_SUSPEND << 16);
-			dum->port_status &= ~USB_PORT_STAT_SUSPEND;
+		if (dum_hcd->resuming &&
+				time_after_eq(jiffies, dum_hcd->re_timeout)) {
+			dum_hcd->port_status |= (USB_PORT_STAT_C_SUSPEND << 16);
+			dum_hcd->port_status &= ~USB_PORT_STAT_SUSPEND;
 		}
-		if ((dum->port_status & USB_PORT_STAT_RESET) != 0 &&
-				time_after_eq (jiffies, dum->re_timeout)) {
-			dum->port_status |= (USB_PORT_STAT_C_RESET << 16);
-			dum->port_status &= ~USB_PORT_STAT_RESET;
-			if (dum->pullup) {
-				dum->port_status |= USB_PORT_STAT_ENABLE;
-				/* give it the best speed we agree on */
-				dum->gadget.speed = dum->driver->speed;
-				dum->gadget.ep0->maxpacket = 64;
-				switch (dum->gadget.speed) {
+		if ((dum_hcd->port_status & USB_PORT_STAT_RESET) != 0 &&
+				time_after_eq(jiffies, dum_hcd->re_timeout)) {
+			dum_hcd->port_status |= (USB_PORT_STAT_C_RESET << 16);
+			dum_hcd->port_status &= ~USB_PORT_STAT_RESET;
+			if (dum_hcd->dum->pullup) {
+				dum_hcd->port_status |= USB_PORT_STAT_ENABLE;
+				switch (dum_hcd->dum->gadget.speed) {
 				case USB_SPEED_HIGH:
-					dum->port_status |=
-						USB_PORT_STAT_HIGH_SPEED;
+					dum_hcd->port_status |=
+					      USB_PORT_STAT_HIGH_SPEED;
 					break;
 				case USB_SPEED_LOW:
-					dum->gadget.ep0->maxpacket = 8;
-					dum->port_status |=
+					dum_hcd->dum->gadget.ep0->
+						maxpacket = 8;
+					dum_hcd->port_status |=
 						USB_PORT_STAT_LOW_SPEED;
 					break;
 				default:
-					dum->gadget.speed = USB_SPEED_FULL;
+					dum_hcd->dum->gadget.speed =
+						USB_SPEED_FULL;
 					break;
 				}
 			}
 		}
-		set_link_state (dum);
-		((__le16 *) buf)[0] = cpu_to_le16 (dum->port_status);
-		((__le16 *) buf)[1] = cpu_to_le16 (dum->port_status >> 16);
+		set_link_state(dum_hcd);
+		((__le16 *) buf)[0] = cpu_to_le16 (dum_hcd->port_status);
+		((__le16 *) buf)[1] = cpu_to_le16 (dum_hcd->port_status >> 16);
 		break;
 	case SetHubFeature:
 		retval = -EPIPE;
@@ -1690,87 +1708,91 @@ static int dummy_hub_control (
 	case SetPortFeature:
 		switch (wValue) {
 		case USB_PORT_FEAT_SUSPEND:
-			if (dum->active) {
-				dum->port_status |= USB_PORT_STAT_SUSPEND;
+			if (dum_hcd->active) {
+				dum_hcd->port_status |= USB_PORT_STAT_SUSPEND;
 
 				/* HNP would happen here; for now we
 				 * assume b_bus_req is always true.
 				 */
-				set_link_state (dum);
+				set_link_state(dum_hcd);
 				if (((1 << USB_DEVICE_B_HNP_ENABLE)
-						& dum->devstatus) != 0)
-					dev_dbg (dummy_dev(dum),
+						& dum_hcd->dum->devstatus) != 0)
+					dev_dbg(dummy_dev(dum_hcd),
 							"no HNP yet!\n");
 			}
 			break;
 		case USB_PORT_FEAT_POWER:
-			dum->port_status |= USB_PORT_STAT_POWER;
-			set_link_state (dum);
+			dum_hcd->port_status |= USB_PORT_STAT_POWER;
+			set_link_state(dum_hcd);
 			break;
 		case USB_PORT_FEAT_RESET:
 			/* if it's already enabled, disable */
-			dum->port_status &= ~(USB_PORT_STAT_ENABLE
+			dum_hcd->port_status &= ~(USB_PORT_STAT_ENABLE
 					| USB_PORT_STAT_LOW_SPEED
 					| USB_PORT_STAT_HIGH_SPEED);
-			dum->devstatus = 0;
-			/* 50msec reset signaling */
-			dum->re_timeout = jiffies + msecs_to_jiffies(50);
+			/*
+			 * We want to reset device status. All but the
+			 * Self powered feature
+			 */
+			dum_hcd->dum->devstatus &=
+				(1 << USB_DEVICE_SELF_POWERED);
+			dum_hcd->re_timeout = jiffies + msecs_to_jiffies(50);
 			/* FALLS THROUGH */
 		default:
-			if ((dum->port_status & USB_PORT_STAT_POWER) != 0) {
-				dum->port_status |= (1 << wValue);
-				set_link_state (dum);
+			if ((dum_hcd->port_status &
+			     USB_PORT_STAT_POWER) != 0) {
+				dum_hcd->port_status |= (1 << wValue);
+				set_link_state(dum_hcd);
 			}
 		}
 		break;
 
 	default:
-		dev_dbg (dummy_dev(dum),
+		dev_dbg(dummy_dev(dum_hcd),
 			"hub control req%04x v%04x i%04x l%d\n",
 			typeReq, wValue, wIndex, wLength);
-
 		/* "protocol stall" on error */
 		retval = -EPIPE;
 	}
-	spin_unlock_irqrestore (&dum->lock, flags);
+	spin_unlock_irqrestore(&dum_hcd->dum->lock, flags);
 
-	if ((dum->port_status & PORT_C_MASK) != 0)
+	if ((dum_hcd->port_status & PORT_C_MASK) != 0)
 		usb_hcd_poll_rh_status (hcd);
 	return retval;
 }
 
 static int dummy_bus_suspend (struct usb_hcd *hcd)
 {
-	struct dummy *dum = hcd_to_dummy (hcd);
+	struct dummy_hcd *dum_hcd = hcd_to_dummy_hcd(hcd);
 
 	dev_dbg (&hcd->self.root_hub->dev, "%s\n", __func__);
 
-	spin_lock_irq (&dum->lock);
-	dum->rh_state = DUMMY_RH_SUSPENDED;
-	set_link_state (dum);
+	spin_lock_irq(&dum_hcd->dum->lock);
+	dum_hcd->rh_state = DUMMY_RH_SUSPENDED;
+	set_link_state(dum_hcd);
 	hcd->state = HC_STATE_SUSPENDED;
-	spin_unlock_irq (&dum->lock);
+	spin_unlock_irq(&dum_hcd->dum->lock);
 	return 0;
 }
 
 static int dummy_bus_resume (struct usb_hcd *hcd)
 {
-	struct dummy *dum = hcd_to_dummy (hcd);
+	struct dummy_hcd *dum_hcd = hcd_to_dummy_hcd(hcd);
 	int rc = 0;
 
 	dev_dbg (&hcd->self.root_hub->dev, "%s\n", __func__);
 
-	spin_lock_irq (&dum->lock);
+	spin_lock_irq(&dum_hcd->dum->lock);
 	if (!HCD_HW_ACCESSIBLE(hcd)) {
 		rc = -ESHUTDOWN;
 	} else {
-		dum->rh_state = DUMMY_RH_RUNNING;
-		set_link_state (dum);
-		if (!list_empty(&dum->urbp_list))
-			mod_timer (&dum->timer, jiffies);
+		dum_hcd->rh_state = DUMMY_RH_RUNNING;
+		set_link_state(dum_hcd);
+		if (!list_empty(&dum_hcd->urbp_list))
+			mod_timer(&dum_hcd->timer, jiffies);
 		hcd->state = HC_STATE_RUNNING;
 	}
-	spin_unlock_irq (&dum->lock);
+	spin_unlock_irq(&dum_hcd->dum->lock);
 	return rc;
 }
 
@@ -1806,43 +1828,41 @@ static ssize_t
 show_urbs (struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct usb_hcd		*hcd = dev_get_drvdata (dev);
-	struct dummy		*dum = hcd_to_dummy (hcd);
+	struct dummy_hcd	*dum_hcd = hcd_to_dummy_hcd(hcd);
 	struct urbp		*urbp;
 	size_t			size = 0;
 	unsigned long		flags;
 
-	spin_lock_irqsave (&dum->lock, flags);
-	list_for_each_entry (urbp, &dum->urbp_list, urbp_list) {
+	spin_lock_irqsave(&dum_hcd->dum->lock, flags);
+	list_for_each_entry(urbp, &dum_hcd->urbp_list, urbp_list) {
 		size_t		temp;
 
 		temp = show_urb (buf, PAGE_SIZE - size, urbp->urb);
 		buf += temp;
 		size += temp;
 	}
-	spin_unlock_irqrestore (&dum->lock, flags);
+	spin_unlock_irqrestore(&dum_hcd->dum->lock, flags);
 
 	return size;
 }
 static DEVICE_ATTR (urbs, S_IRUGO, show_urbs, NULL);
 
-static int dummy_start (struct usb_hcd *hcd)
+static int dummy_start(struct usb_hcd *hcd)
 {
-	struct dummy		*dum;
-
-	dum = hcd_to_dummy (hcd);
+	struct dummy_hcd	*dum_hcd = hcd_to_dummy_hcd(hcd);
 
 	/*
 	 * MASTER side init ... we emulate a root hub that'll only ever
 	 * talk to one device (the slave side).  Also appears in sysfs,
 	 * just like more familiar pci-based HCDs.
 	 */
-	spin_lock_init (&dum->lock);
-	init_timer (&dum->timer);
-	dum->timer.function = dummy_timer;
-	dum->timer.data = (unsigned long) dum;
-	dum->rh_state = DUMMY_RH_RUNNING;
+	spin_lock_init(&dum_hcd->dum->lock);
+	init_timer(&dum_hcd->timer);
+	dum_hcd->timer.function = dummy_timer;
+	dum_hcd->timer.data = (unsigned long)dum_hcd;
+	dum_hcd->rh_state = DUMMY_RH_RUNNING;
 
-	INIT_LIST_HEAD (&dum->urbp_list);
+	INIT_LIST_HEAD(&dum_hcd->urbp_list);
 
 	hcd->power_budget = POWER_BUDGET;
 	hcd->state = HC_STATE_RUNNING;
@@ -1853,18 +1873,17 @@ static int dummy_start (struct usb_hcd *hcd)
 #endif
 
 	/* FIXME 'urbs' should be a per-device thing, maybe in usbcore */
-	return device_create_file (dummy_dev(dum), &dev_attr_urbs);
+	return device_create_file(dummy_dev(dum_hcd), &dev_attr_urbs);
 }
 
 static void dummy_stop (struct usb_hcd *hcd)
 {
 	struct dummy		*dum;
 
-	dum = hcd_to_dummy (hcd);
-
-	device_remove_file (dummy_dev(dum), &dev_attr_urbs);
+	dum = (hcd_to_dummy_hcd(hcd))->dum;
+	device_remove_file(dummy_dev(hcd_to_dummy_hcd(hcd)), &dev_attr_urbs);
 	usb_gadget_unregister_driver (dum->driver);
-	dev_info (dummy_dev(dum), "stopped\n");
+	dev_info(dummy_dev(hcd_to_dummy_hcd(hcd)), "stopped\n");
 }
 
 /*-------------------------------------------------------------------------*/
@@ -1874,13 +1893,26 @@ static int dummy_h_get_frame (struct usb_hcd *hcd)
 	return dummy_g_get_frame (NULL);
 }
 
+static int dummy_setup(struct usb_hcd *hcd)
+{
+	if (usb_hcd_is_primary_hcd(hcd)) {
+		the_controller.hs_hcd = hcd_to_dummy_hcd(hcd);
+		the_controller.hs_hcd->dum = &the_controller;
+		/* Mark the first roothub as being USB 2.0. */
+		hcd->speed = HCD_USB2;
+		hcd->self.root_hub->speed = USB_SPEED_HIGH;
+	}
+	return 0;
+}
+
 static const struct hc_driver dummy_hcd = {
 	.description =		(char *) driver_name,
 	.product_desc =		"Dummy host controller",
-	.hcd_priv_size =	sizeof(struct dummy),
+	.hcd_priv_size =	sizeof(struct dummy_hcd),
 
 	.flags =		HCD_USB2,
 
+	.reset =		dummy_setup,
 	.start =		dummy_start,
 	.stop =			dummy_stop,
 
@@ -1897,46 +1929,45 @@ static const struct hc_driver dummy_hcd = {
 
 static int dummy_hcd_probe(struct platform_device *pdev)
 {
-	struct usb_hcd		*hcd;
+	struct usb_hcd		*hs_hcd;
 	int			retval;
 
 	dev_info(&pdev->dev, "%s, driver " DRIVER_VERSION "\n", driver_desc);
 
-	hcd = usb_create_hcd(&dummy_hcd, &pdev->dev, dev_name(&pdev->dev));
-	if (!hcd)
+	hs_hcd = usb_create_hcd(&dummy_hcd, &pdev->dev, dev_name(&pdev->dev));
+	if (!hs_hcd)
 		return -ENOMEM;
-	the_controller = hcd_to_dummy (hcd);
 
-	retval = usb_add_hcd(hcd, 0, 0);
+	retval = usb_add_hcd(hs_hcd, 0, 0);
 	if (retval != 0) {
-		usb_put_hcd (hcd);
-		the_controller = NULL;
+		usb_put_hcd(hs_hcd);
+		the_controller.hs_hcd = NULL;
 	}
 	return retval;
 }
 
 static int dummy_hcd_remove (struct platform_device *pdev)
 {
-	struct usb_hcd		*hcd;
+	struct dummy		*dum;
 
-	hcd = platform_get_drvdata (pdev);
-	usb_remove_hcd (hcd);
-	usb_put_hcd (hcd);
-	the_controller = NULL;
+	dum = (hcd_to_dummy_hcd(platform_get_drvdata(pdev)))->dum;
+	usb_remove_hcd(dummy_hcd_to_hcd(dum->hs_hcd));
+	usb_put_hcd(dummy_hcd_to_hcd(dum->hs_hcd));
+	the_controller.hs_hcd = NULL;
 	return 0;
 }
 
 static int dummy_hcd_suspend (struct platform_device *pdev, pm_message_t state)
 {
 	struct usb_hcd		*hcd;
-	struct dummy		*dum;
+	struct dummy_hcd	*dum_hcd;
 	int			rc = 0;
 
 	dev_dbg (&pdev->dev, "%s\n", __func__);
 
 	hcd = platform_get_drvdata (pdev);
-	dum = hcd_to_dummy (hcd);
-	if (dum->rh_state == DUMMY_RH_RUNNING) {
+	dum_hcd = hcd_to_dummy_hcd(hcd);
+	if (dum_hcd->rh_state == DUMMY_RH_RUNNING) {
 		dev_warn(&pdev->dev, "Root hub isn't suspended!\n");
 		rc = -EBUSY;
 	} else
@@ -1996,7 +2027,7 @@ static int __init init (void)
 	retval = platform_device_add(the_hcd_pdev);
 	if (retval < 0)
 		goto err_add_hcd;
-	if (!the_controller) {
+	if (!the_controller.hs_hcd) {
 		/*
 		 * The hcd was added successfully but its probe function failed
 		 * for some reason.
-- 
1.7.3.3

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
