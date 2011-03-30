Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965343Ab1C3Vj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:39:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:61800 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933594Ab1C3VIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133460"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: max@vozeler.com, MWehby@luxotticaRetail.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [147/275] staging: usbip: vhci: give back URBs from in-flight unlink requests
Message-Id: <20110330210628.75D933E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/staging/usbip/vhci.h     |    3 +++
 drivers/staging/usbip/vhci_hcd.c |   24 +++++++++++++++++++++++-
 drivers/staging/usbip/vhci_rx.c  |   15 +++++++++------
 3 files changed, 35 insertions(+), 7 deletions(-)

Index: linux-2.6.35.y/drivers/staging/usbip/vhci.h
===================================================================
--- linux-2.6.35.y.orig/drivers/staging/usbip/vhci.h	2011-03-29 22:51:07.834522704 -0700
+++ linux-2.6.35.y/drivers/staging/usbip/vhci.h	2011-03-29 23:54:38.178025546 -0700
@@ -119,6 +119,9 @@
 void vhci_rx_loop(struct usbip_task *ut);
 void vhci_tx_loop(struct usbip_task *ut);
 
+struct urb *pickup_urb_and_free_priv(struct vhci_device *vdev,
+					    __u32 seqnum);
+
 #define hardware		(&the_controller->pdev.dev)
 
 static inline struct vhci_device *port_to_vdev(__u32 port)
Index: linux-2.6.35.y/drivers/staging/usbip/vhci_hcd.c
===================================================================
--- linux-2.6.35.y.orig/drivers/staging/usbip/vhci_hcd.c	2011-03-29 23:03:01.301266875 -0700
+++ linux-2.6.35.y/drivers/staging/usbip/vhci_hcd.c	2011-03-29 23:54:38.681012675 -0700
@@ -808,7 +808,6 @@
 	return 0;
 }
 
-
 static void vhci_device_unlink_cleanup(struct vhci_device *vdev)
 {
 	struct vhci_unlink *unlink, *tmp;
@@ -816,11 +815,34 @@
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
Index: linux-2.6.35.y/drivers/staging/usbip/vhci_rx.c
===================================================================
--- linux-2.6.35.y.orig/drivers/staging/usbip/vhci_rx.c	2011-03-29 22:51:07.834522704 -0700
+++ linux-2.6.35.y/drivers/staging/usbip/vhci_rx.c	2011-03-29 23:03:01.322266336 -0700
@@ -23,16 +23,14 @@
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
@@ -63,8 +61,6 @@
 		}
 	}
 
-	spin_unlock(&vdev->priv_lock);
-
 	return urb;
 }
 
@@ -74,9 +70,11 @@
 	struct usbip_device *ud = &vdev->ud;
 	struct urb *urb;
 
+	spin_lock(&vdev->priv_lock);
 
 	urb = pickup_urb_and_free_priv(vdev, pdu->base.seqnum);
 
+	spin_unlock(&vdev->priv_lock);
 
 	if (!urb) {
 		usbip_uerr("cannot find a urb of seqnum %u\n",
@@ -161,7 +159,12 @@
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
