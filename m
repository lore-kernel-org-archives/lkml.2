Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568Ab3AHFok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 00:44:40 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:35616 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab3AHFoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 00:44:37 -0500
From: Harvey Yang <harvey.huawei.yang@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Mooney <mfm@muteddisk.com>, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Harvey Yang <harvey.huawei.yang@gmail.com>
Subject: [PATCH 2/2] staging: usbip: replace the interrupt safe spinlocks with common ones.
Date: Tue,  8 Jan 2013 13:49:02 +0800
Message-Id: <1357624142-7178-3-git-send-email-harvey.huawei.yang@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1357624142-7178-1-git-send-email-harvey.huawei.yang@gmail.com>
References: <1357624142-7178-1-git-send-email-harvey.huawei.yang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Harvey Yang <harvey.huawei.yang@gmail.com>
---
 drivers/staging/usbip/vhci_hcd.c |   76 ++++++++++++++++----------------------
 drivers/staging/usbip/vhci_rx.c  |   10 ++---
 drivers/staging/usbip/vhci_tx.c  |   14 +++----
 3 files changed, 42 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index c3aa219..216648d 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -121,11 +121,9 @@ static void dump_port_status_diff(u32 prev_status, u32 new_status)
 
 void rh_port_connect(int rhport, enum usb_device_speed speed)
 {
-	unsigned long	flags;
-
 	usbip_dbg_vhci_rh("rh_port_connect %d\n", rhport);
 
-	spin_lock_irqsave(&the_controller->lock, flags);
+	spin_lock(&the_controller->lock);
 
 	the_controller->port_status[rhport] |= USB_PORT_STAT_CONNECTION
 		| (1 << USB_PORT_FEAT_C_CONNECTION);
@@ -141,24 +139,22 @@ void rh_port_connect(int rhport, enum usb_device_speed speed)
 		break;
 	}
 
-	spin_unlock_irqrestore(&the_controller->lock, flags);
+	spin_unlock(&the_controller->lock);
 
 	usb_hcd_poll_rh_status(vhci_to_hcd(the_controller));
 }
 
 static void rh_port_disconnect(int rhport)
 {
-	unsigned long flags;
-
 	usbip_dbg_vhci_rh("rh_port_disconnect %d\n", rhport);
 
-	spin_lock_irqsave(&the_controller->lock, flags);
+	spin_lock(&the_controller->lock);
 
 	the_controller->port_status[rhport] &= ~USB_PORT_STAT_CONNECTION;
 	the_controller->port_status[rhport] |=
 					(1 << USB_PORT_FEAT_C_CONNECTION);
 
-	spin_unlock_irqrestore(&the_controller->lock, flags);
+	spin_unlock(&the_controller->lock);
 	usb_hcd_poll_rh_status(vhci_to_hcd(the_controller));
 }
 
@@ -183,7 +179,6 @@ static void rh_port_disconnect(int rhport)
 static int vhci_hub_status(struct usb_hcd *hcd, char *buf)
 {
 	struct vhci_hcd	*vhci;
-	unsigned long	flags;
 	int		retval;
 	int		rhport;
 	int		changed = 0;
@@ -193,7 +188,7 @@ static int vhci_hub_status(struct usb_hcd *hcd, char *buf)
 
 	vhci = hcd_to_vhci(hcd);
 
-	spin_lock_irqsave(&vhci->lock, flags);
+	spin_lock(&vhci->lock);
 	if (!HCD_HW_ACCESSIBLE(hcd)) {
 		usbip_dbg_vhci_rh("hw accessible flag not on?\n");
 		goto done;
@@ -216,7 +211,7 @@ static int vhci_hub_status(struct usb_hcd *hcd, char *buf)
 		usb_hcd_resume_root_hub(hcd);
 
 done:
-	spin_unlock_irqrestore(&vhci->lock, flags);
+	spin_unlock(&vhci->lock);
 	return changed ? retval : 0;
 }
 
@@ -237,7 +232,6 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 {
 	struct vhci_hcd	*dum;
 	int             retval = 0;
-	unsigned long   flags;
 	int		rhport;
 
 	u32 prev_port_status[VHCI_NPORTS];
@@ -257,7 +251,7 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 
 	dum = hcd_to_vhci(hcd);
 
-	spin_lock_irqsave(&dum->lock, flags);
+	spin_lock(&dum->lock);
 
 	/* store old status and compare now and old later */
 	if (usbip_dbg_flag_vhci_rh) {
@@ -410,7 +404,7 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 	}
 	usbip_dbg_vhci_rh(" bye\n");
 
-	spin_unlock_irqrestore(&dum->lock, flags);
+	spin_unlock(&dum->lock);
 
 	return retval;
 }
@@ -433,7 +427,6 @@ static void vhci_tx_urb(struct urb *urb)
 {
 	struct vhci_device *vdev = get_vdev(urb->dev);
 	struct vhci_priv *priv;
-	unsigned long flag;
 
 	if (!vdev) {
 		pr_err("could not get virtual device");
@@ -442,11 +435,11 @@ static void vhci_tx_urb(struct urb *urb)
 
 	priv = kzalloc(sizeof(struct vhci_priv), GFP_ATOMIC);
 
-	spin_lock_irqsave(&vdev->priv_lock, flag);
+	spin_lock(&vdev->priv_lock);
 
 	if (!priv) {
 		dev_err(&urb->dev->dev, "malloc vhci_priv\n");
-		spin_unlock_irqrestore(&vdev->priv_lock, flag);
+		spin_unlock(&vdev->priv_lock);
 		usbip_event_add(&vdev->ud, VDEV_EVENT_ERROR_MALLOC);
 		return;
 	}
@@ -463,7 +456,7 @@ static void vhci_tx_urb(struct urb *urb)
 	list_add_tail(&priv->list, &vdev->priv_tx);
 
 	wake_up(&vdev->waitq_tx);
-	spin_unlock_irqrestore(&vdev->priv_lock, flag);
+	spin_unlock(&vdev->priv_lock);
 }
 
 static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
@@ -471,7 +464,6 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 {
 	struct device *dev = &urb->dev->dev;
 	int ret = 0;
-	unsigned long flags;
 	struct vhci_device *vdev;
 
 	usbip_dbg_vhci_hc("enter, usb_hcd %p urb %p mem_flags %d\n",
@@ -480,11 +472,11 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 	/* patch to usb_sg_init() is in 2.5.60 */
 	BUG_ON(!urb->transfer_buffer && urb->transfer_buffer_length);
 
-	spin_lock_irqsave(&the_controller->lock, flags);
+	spin_lock(&the_controller->lock);
 
 	if (urb->status != -EINPROGRESS) {
 		dev_err(dev, "URB already unlinked!, status %d\n", urb->status);
-		spin_unlock_irqrestore(&the_controller->lock, flags);
+		spin_unlock(&the_controller->lock);
 		return urb->status;
 	}
 
@@ -496,7 +488,7 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 	    vdev->ud.status == VDEV_ST_ERROR) {
 		dev_err(dev, "enqueue for inactive port %d\n", vdev->rhport);
 		spin_unlock(&vdev->ud.lock);
-		spin_unlock_irqrestore(&the_controller->lock, flags);
+		spin_unlock(&the_controller->lock);
 		return -ENODEV;
 	}
 	spin_unlock(&vdev->ud.lock);
@@ -571,14 +563,14 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 
 out:
 	vhci_tx_urb(urb);
-	spin_unlock_irqrestore(&the_controller->lock, flags);
+	spin_unlock(&the_controller->lock);
 
 	return 0;
 
 no_need_xmit:
 	usb_hcd_unlink_urb_from_ep(hcd, urb);
 no_need_unlink:
-	spin_unlock_irqrestore(&the_controller->lock, flags);
+	spin_unlock(&the_controller->lock);
 	usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb, urb->status);
 	return ret;
 }
@@ -631,19 +623,18 @@ no_need_unlink:
  */
 static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 {
-	unsigned long flags;
 	struct vhci_priv *priv;
 	struct vhci_device *vdev;
 
 	pr_info("dequeue a urb %p\n", urb);
 
-	spin_lock_irqsave(&the_controller->lock, flags);
+	spin_lock(&the_controller->lock);
 
 	priv = urb->hcpriv;
 	if (!priv) {
 		/* URB was never linked! or will be soon given back by
 		 * vhci_rx. */
-		spin_unlock_irqrestore(&the_controller->lock, flags);
+		spin_unlock(&the_controller->lock);
 		return 0;
 	}
 
@@ -651,7 +642,7 @@ static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 		int ret = 0;
 		ret = usb_hcd_check_unlink_urb(hcd, urb, status);
 		if (ret) {
-			spin_unlock_irqrestore(&the_controller->lock, flags);
+			spin_unlock(&the_controller->lock);
 			return ret;
 		}
 	}
@@ -661,16 +652,14 @@ static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 
 	if (!vdev->ud.tcp_socket) {
 		/* tcp connection is closed */
-		unsigned long flags2;
-
-		spin_lock_irqsave(&vdev->priv_lock, flags2);
+		spin_lock(&vdev->priv_lock);
 
 		pr_info("device %p seems to be disconnected\n", vdev);
 		list_del(&priv->list);
 		kfree(priv);
 		urb->hcpriv = NULL;
 
-		spin_unlock_irqrestore(&vdev->priv_lock, flags2);
+		spin_unlock(&vdev->priv_lock);
 
 		/*
 		 * If tcp connection is alive, we have sent CMD_UNLINK.
@@ -681,24 +670,23 @@ static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 
 		usb_hcd_unlink_urb_from_ep(hcd, urb);
 
-		spin_unlock_irqrestore(&the_controller->lock, flags);
+		spin_unlock(&the_controller->lock);
 		usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb,
 				     urb->status);
-		spin_lock_irqsave(&the_controller->lock, flags);
+		spin_lock(&the_controller->lock);
 
 	} else {
 		/* tcp connection is alive */
-		unsigned long flags2;
 		struct vhci_unlink *unlink;
 
-		spin_lock_irqsave(&vdev->priv_lock, flags2);
+		spin_lock(&vdev->priv_lock);
 
 		/* setup CMD_UNLINK pdu */
 		unlink = kzalloc(sizeof(struct vhci_unlink), GFP_ATOMIC);
 		if (!unlink) {
 			pr_err("malloc vhci_unlink\n");
-			spin_unlock_irqrestore(&vdev->priv_lock, flags2);
-			spin_unlock_irqrestore(&the_controller->lock, flags);
+			spin_unlock(&vdev->priv_lock);
+			spin_unlock(&the_controller->lock);
 			usbip_event_add(&vdev->ud, VDEV_EVENT_ERROR_MALLOC);
 			return -ENOMEM;
 		}
@@ -716,10 +704,10 @@ static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 		list_add_tail(&unlink->list, &vdev->unlink_tx);
 		wake_up(&vdev->waitq_tx);
 
-		spin_unlock_irqrestore(&vdev->priv_lock, flags2);
+		spin_unlock(&vdev->priv_lock);
 	}
 
-	spin_unlock_irqrestore(&the_controller->lock, flags);
+	spin_unlock(&the_controller->lock);
 
 	usbip_dbg_vhci_hc("leave\n");
 	return 0;
@@ -957,9 +945,9 @@ static int vhci_bus_suspend(struct usb_hcd *hcd)
 
 	dev_dbg(&hcd->self.root_hub->dev, "%s\n", __func__);
 
-	spin_lock_irq(&vhci->lock);
+	spin_lock(&vhci->lock);
 	hcd->state = HC_STATE_SUSPENDED;
-	spin_unlock_irq(&vhci->lock);
+	spin_unlock(&vhci->lock);
 
 	return 0;
 }
@@ -971,13 +959,13 @@ static int vhci_bus_resume(struct usb_hcd *hcd)
 
 	dev_dbg(&hcd->self.root_hub->dev, "%s\n", __func__);
 
-	spin_lock_irq(&vhci->lock);
+	spin_lock(&vhci->lock);
 	if (!HCD_HW_ACCESSIBLE(hcd)) {
 		rc = -ESHUTDOWN;
 	} else {
 		hcd->state = HC_STATE_RUNNING;
 	}
-	spin_unlock_irq(&vhci->lock);
+	spin_unlock(&vhci->lock);
 
 	return rc;
 }
diff --git a/drivers/staging/usbip/vhci_rx.c b/drivers/staging/usbip/vhci_rx.c
index ba5f1c0..faf8e60 100644
--- a/drivers/staging/usbip/vhci_rx.c
+++ b/drivers/staging/usbip/vhci_rx.c
@@ -68,7 +68,6 @@ static void vhci_recv_ret_submit(struct vhci_device *vdev,
 {
 	struct usbip_device *ud = &vdev->ud;
 	struct urb *urb;
-	unsigned long flags;
 
 	spin_lock(&vdev->priv_lock);
 	urb = pickup_urb_and_free_priv(vdev, pdu->base.seqnum);
@@ -101,9 +100,9 @@ static void vhci_recv_ret_submit(struct vhci_device *vdev,
 
 	usbip_dbg_vhci_rx("now giveback urb %p\n", urb);
 
-	spin_lock_irqsave(&the_controller->lock, flags);
+	spin_lock(&the_controller->lock);
 	usb_hcd_unlink_urb_from_ep(vhci_to_hcd(the_controller), urb);
-	spin_unlock_irqrestore(&the_controller->lock, flags);
+	spin_unlock(&the_controller->lock);
 
 	usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb, urb->status);
 
@@ -141,7 +140,6 @@ static void vhci_recv_ret_unlink(struct vhci_device *vdev,
 {
 	struct vhci_unlink *unlink;
 	struct urb *urb;
-	unsigned long flags;
 
 	usbip_dump_header(pdu);
 
@@ -171,9 +169,9 @@ static void vhci_recv_ret_unlink(struct vhci_device *vdev,
 		urb->status = pdu->u.ret_unlink.status;
 		pr_info("urb->status %d\n", urb->status);
 
-		spin_lock_irqsave(&the_controller->lock, flags);
+		spin_lock(&the_controller->lock);
 		usb_hcd_unlink_urb_from_ep(vhci_to_hcd(the_controller), urb);
-		spin_unlock_irqrestore(&the_controller->lock, flags);
+		spin_unlock(&the_controller->lock);
 
 		usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb,
 				     urb->status);
diff --git a/drivers/staging/usbip/vhci_tx.c b/drivers/staging/usbip/vhci_tx.c
index b1f0dcd..409fd99 100644
--- a/drivers/staging/usbip/vhci_tx.c
+++ b/drivers/staging/usbip/vhci_tx.c
@@ -46,18 +46,17 @@ static void setup_cmd_submit_pdu(struct usbip_header *pdup,  struct urb *urb)
 
 static struct vhci_priv *dequeue_from_priv_tx(struct vhci_device *vdev)
 {
-	unsigned long flags;
 	struct vhci_priv *priv, *tmp;
 
-	spin_lock_irqsave(&vdev->priv_lock, flags);
+	spin_lock(&vdev->priv_lock);
 
 	list_for_each_entry_safe(priv, tmp, &vdev->priv_tx, list) {
 		list_move_tail(&priv->list, &vdev->priv_rx);
-		spin_unlock_irqrestore(&vdev->priv_lock, flags);
+		spin_unlock(&vdev->priv_lock);
 		return priv;
 	}
 
-	spin_unlock_irqrestore(&vdev->priv_lock, flags);
+	spin_unlock(&vdev->priv_lock);
 
 	return NULL;
 }
@@ -136,18 +135,17 @@ static int vhci_send_cmd_submit(struct vhci_device *vdev)
 
 static struct vhci_unlink *dequeue_from_unlink_tx(struct vhci_device *vdev)
 {
-	unsigned long flags;
 	struct vhci_unlink *unlink, *tmp;
 
-	spin_lock_irqsave(&vdev->priv_lock, flags);
+	spin_lock(&vdev->priv_lock);
 
 	list_for_each_entry_safe(unlink, tmp, &vdev->unlink_tx, list) {
 		list_move_tail(&unlink->list, &vdev->unlink_rx);
-		spin_unlock_irqrestore(&vdev->priv_lock, flags);
+		spin_unlock(&vdev->priv_lock);
 		return unlink;
 	}
 
-	spin_unlock_irqrestore(&vdev->priv_lock, flags);
+	spin_unlock(&vdev->priv_lock);
 
 	return NULL;
 }
-- 
1.7.1

