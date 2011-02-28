Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab1B1Qlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:41:35 -0500
Received: from kroah.org ([198.145.64.141]:48246 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755749Ab1B1QiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:38:14 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:11 2011
Message-Id: <20110228162411.624757354@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:23:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Max Vozeler <max@vozeler.com>
Subject: [59/68] staging: usbip: vhci: refuse to enqueue for dead connections
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Max Vozeler <max@vozeler.com>

commit 6d212153a838354078cc7d96f9bb23b7d1fd3d1b upstream.

There can be requests to enqueue URBs while we are shutting
down a connection.

Signed-off-by: Max Vozeler <max@vozeler.com>
Tested-by: Mark Wehby <MWehby@luxotticaRetail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/usbip/vhci_hcd.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -558,6 +558,7 @@ static int vhci_urb_enqueue(struct usb_h
 	struct device *dev = &urb->dev->dev;
 	int ret = 0;
 	unsigned long flags;
+	struct vhci_device *vdev;
 
 	usbip_dbg_vhci_hc("enter, usb_hcd %p urb %p mem_flags %d\n",
 		    hcd, urb, mem_flags);
@@ -573,6 +574,18 @@ static int vhci_urb_enqueue(struct usb_h
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
@@ -591,8 +604,6 @@ static int vhci_urb_enqueue(struct usb_h
 		__u8 type = usb_pipetype(urb->pipe);
 		struct usb_ctrlrequest *ctrlreq =
 				(struct usb_ctrlrequest *) urb->setup_packet;
-		struct vhci_device *vdev =
-				port_to_vdev(the_controller->pending_port);
 
 		if (type != PIPE_CONTROL || !ctrlreq) {
 			dev_err(dev, "invalid request to devnum 0\n");


