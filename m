Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965298Ab1C3Vjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:39:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:61811 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933600Ab1C3VIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133467"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: max@vozeler.com, MWehby@luxotticaRetail.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [148/275] staging: usbip: vhci: refuse to enqueue for dead connections
Message-Id: <20110330210629.826613E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Max Vozeler <max@vozeler.com>

commit 6d212153a838354078cc7d96f9bb23b7d1fd3d1b upstream.

There can be requests to enqueue URBs while we are shutting
down a connection.

Signed-off-by: Max Vozeler <max@vozeler.com>
Tested-by: Mark Wehby <MWehby@luxotticaRetail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/staging/usbip/vhci_hcd.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/staging/usbip/vhci_hcd.c
===================================================================
--- linux-2.6.35.y.orig/drivers/staging/usbip/vhci_hcd.c	2011-03-29 23:03:01.320266388 -0700
+++ linux-2.6.35.y/drivers/staging/usbip/vhci_hcd.c	2011-03-29 23:54:38.179025521 -0700
@@ -559,6 +559,7 @@
 	struct device *dev = &urb->dev->dev;
 	int ret = 0;
 	unsigned long flags;
+	struct vhci_device *vdev;
 
 	usbip_dbg_vhci_hc("enter, usb_hcd %p urb %p mem_flags %d\n",
 		    hcd, urb, mem_flags);
@@ -574,6 +575,18 @@
 		return urb->status;
 	}
 
+	vdev = port_to_vdev(the_controller->pending_port);
+
+	/* refuse enqueue for dead connection */
+	spin_lock(&vdev->ud.lock);
+	if (vdev->ud.status == VDEV_ST_NULL || vdev->ud.status == VDEV_ST_ERROR) {
+		usbip_uerr("enqueue for inactive port %d\n", vdev->rhport);
+		spin_unlock(&vdev->ud.lock);
+		spin_unlock_irqrestore(&the_controller->lock, flags);
+		return -ENODEV;
+	}
+	spin_unlock(&vdev->ud.lock);
+
 	ret = usb_hcd_link_urb_to_ep(hcd, urb);
 	if (ret)
 		goto no_need_unlink;
@@ -592,8 +605,6 @@
 		__u8 type = usb_pipetype(urb->pipe);
 		struct usb_ctrlrequest *ctrlreq =
 				(struct usb_ctrlrequest *) urb->setup_packet;
-		struct vhci_device *vdev =
-				port_to_vdev(the_controller->pending_port);
 
 		if (type != PIPE_CONTROL || !ctrlreq) {
 			dev_err(dev, "invalid request to devnum 0\n");
