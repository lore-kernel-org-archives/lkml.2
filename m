Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760392Ab1CEBRG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:17:06 -0500
Received: from kroah.org ([198.145.64.141]:50176 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760044Ab1CEBAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:03 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:36 2011
Message-Id: <20110305005636.271432400@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Max Vozeler <max@vozeler.com>
Subject: [17/73] staging: usbip: vhci: use urb->dev->portnum to find port
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Max Vozeler <max@vozeler.com>

commit 01446ef5af4e8802369bf4d257806e24345a9371 upstream.

The access to pending_port was racy when two devices
were being attached at the same time.

Signed-off-by: Max Vozeler <max@vozeler.com>
Tested-by: Mark Wehby <MWehby@luxotticaRetail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/usbip/vhci.h     |    3 ---
 drivers/staging/usbip/vhci_hcd.c |    4 +---
 2 files changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/staging/usbip/vhci.h
+++ b/drivers/staging/usbip/vhci.h
@@ -100,9 +100,6 @@ struct vhci_hcd {
 	 * But, the index of this array begins from 0.
 	 */
 	struct vhci_device vdev[VHCI_NPORTS];
-
-	/* vhci_device which has not been assiged its address yet */
-	int pending_port;
 };
 
 
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -138,8 +138,6 @@ void rh_port_connect(int rhport, enum us
 	 * the_controller->vdev[rhport].ud.status = VDEV_CONNECT;
 	 * spin_unlock(&the_controller->vdev[rhport].ud.lock); */
 
-	the_controller->pending_port = rhport;
-
 	spin_unlock_irqrestore(&the_controller->lock, flags);
 
 	usb_hcd_poll_rh_status(vhci_to_hcd(the_controller));
@@ -575,7 +573,7 @@ static int vhci_urb_enqueue(struct usb_h
 		return urb->status;
 	}
 
-	vdev = port_to_vdev(the_controller->pending_port);
+	vdev = port_to_vdev(urb->dev->portnum-1);
 
 	/* refuse enqueue for dead connection */
 	spin_lock(&vdev->ud.lock);


