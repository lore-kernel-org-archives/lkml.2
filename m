Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab1B1QiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:38:14 -0500
Received: from kroah.org ([198.145.64.141]:48240 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555Ab1B1QiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:38:13 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:11 2011
Message-Id: <20110228162411.522623001@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:23:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Max Vozeler <max@vozeler.com>
Subject: [58/68] staging: usbip: vhci: give back URBs from in-flight unlink requests
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Max Vozeler <max@vozeler.com>

commit b92a5e23737172c52656a090977408a80d7f06d1 upstream.

If we never received a RET_UNLINK because the TCP
connection broke the pending URBs still need to be
unlinked and given back.

Previously processes would be stuck trying to kill
the URB even after the device was detached.

Signed-off-by: Max Vozeler <max@vozeler.com>
Tested-by: Mark Wehby <MWehby@luxotticaRetail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/usbip/vhci.h     |    3 +++
 drivers/staging/usbip/vhci_hcd.c |   24 +++++++++++++++++++++++-
 drivers/staging/usbip/vhci_rx.c  |   15 +++++++++------
 3 files changed, 35 insertions(+), 7 deletions(-)

--- a/drivers/staging/usbip/vhci.h
+++ b/drivers/staging/usbip/vhci.h
@@ -119,6 +119,9 @@ void rh_port_disconnect(int rhport);
 void vhci_rx_loop(struct usbip_task *ut);
 void vhci_tx_loop(struct usbip_task *ut);
 
+struct urb *pickup_urb_and_free_priv(struct vhci_device *vdev,
+					    __u32 seqnum);
+
 #define hardware		(&the_controller->pdev.dev)
 
 static inline struct vhci_device *port_to_vdev(__u32 port)
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -807,7 +807,6 @@ static int vhci_urb_dequeue(struct usb_h
 	return 0;
 }
 
-
 static void vhci_device_unlink_cleanup(struct vhci_device *vdev)
 {
 	struct vhci_unlink *unlink, *tmp;
@@ -815,11 +814,34 @@ static void vhci_device_unlink_cleanup(s
 	spin_lock(&vdev->priv_lock);
 
 	list_for_each_entry_safe(unlink, tmp, &vdev->unlink_tx, list) {
+		usbip_uinfo("unlink cleanup tx %lu\n", unlink->unlink_seqnum);
 		list_del(&unlink->list);
 		kfree(unlink);
 	}
 
 	list_for_each_entry_safe(unlink, tmp, &vdev->unlink_rx, list) {
+		struct urb *urb;
+
+		/* give back URB of unanswered unlink request */
+		usbip_uinfo("unlink cleanup rx %lu\n", unlink->unlink_seqnum);
+
+		urb = pickup_urb_and_free_priv(vdev, unlink->unlink_seqnum);
+		if (!urb) {
+			usbip_uinfo("the urb (seqnum %lu) was already given back\n",
+							unlink->unlink_seqnum);
+			list_del(&unlink->list);
+			kfree(unlink);
+			continue;
+		}
+
+		urb->status = -ENODEV;
+
+		spin_lock(&the_controller->lock);
+		usb_hcd_unlink_urb_from_ep(vhci_to_hcd(the_controller), urb);
+		spin_unlock(&the_controller->lock);
+
+		usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb, urb->status);
+
 		list_del(&unlink->list);
 		kfree(unlink);
 	}
--- a/drivers/staging/usbip/vhci_rx.c
+++ b/drivers/staging/usbip/vhci_rx.c
@@ -21,16 +21,14 @@
 #include "vhci.h"
 
 
-/* get URB from transmitted urb queue */
-static struct urb *pickup_urb_and_free_priv(struct vhci_device *vdev,
+/* get URB from transmitted urb queue. caller must hold vdev->priv_lock */
+struct urb *pickup_urb_and_free_priv(struct vhci_device *vdev,
 					    __u32 seqnum)
 {
 	struct vhci_priv *priv, *tmp;
 	struct urb *urb = NULL;
 	int status;
 
-	spin_lock(&vdev->priv_lock);
-
 	list_for_each_entry_safe(priv, tmp, &vdev->priv_rx, list) {
 		if (priv->seqnum == seqnum) {
 			urb = priv->urb;
@@ -61,8 +59,6 @@ static struct urb *pickup_urb_and_free_p
 		}
 	}
 
-	spin_unlock(&vdev->priv_lock);
-
 	return urb;
 }
 
@@ -72,9 +68,11 @@ static void vhci_recv_ret_submit(struct
 	struct usbip_device *ud = &vdev->ud;
 	struct urb *urb;
 
+	spin_lock(&vdev->priv_lock);
 
 	urb = pickup_urb_and_free_priv(vdev, pdu->base.seqnum);
 
+	spin_unlock(&vdev->priv_lock);
 
 	if (!urb) {
 		usbip_uerr("cannot find a urb of seqnum %u\n",
@@ -159,7 +157,12 @@ static void vhci_recv_ret_unlink(struct
 		return;
 	}
 
+	spin_lock(&vdev->priv_lock);
+
 	urb = pickup_urb_and_free_priv(vdev, unlink->unlink_seqnum);
+
+	spin_unlock(&vdev->priv_lock);
+
 	if (!urb) {
 		/*
 		 * I get the result of a unlink request. But, it seems that I


