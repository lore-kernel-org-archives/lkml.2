Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996Ab1LGQb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:31:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34613 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757769Ab1LGQZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:25:07 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:20 2011
Message-Id: <20111207161220.040313386@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:12:06 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Bart Westgeest <bart@elbrys.com>
Subject: [064/104] staging: usbip: bugfix for deadlock
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Westgeest <bart@elbrys.com>

commit 438957f8d4a84daa7fa5be6978ad5897a2e9e5e5 upstream.

Interrupts must be disabled prior to calling usb_hcd_unlink_urb_from_ep.
If interrupts are not disabled, it can potentially lead to a deadlock.
The deadlock is readily reproduceable on a slower (ARM based) device
such as the TI Pandaboard.

Signed-off-by: Bart Westgeest <bart@elbrys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/usbip/vhci_rx.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/staging/usbip/vhci_rx.c
+++ b/drivers/staging/usbip/vhci_rx.c
@@ -68,6 +68,7 @@ static void vhci_recv_ret_submit(struct
 {
 	struct usbip_device *ud = &vdev->ud;
 	struct urb *urb;
+	unsigned long flags;
 
 	spin_lock(&vdev->priv_lock);
 	urb = pickup_urb_and_free_priv(vdev, pdu->base.seqnum);
@@ -101,9 +102,9 @@ static void vhci_recv_ret_submit(struct
 
 	usbip_dbg_vhci_rx("now giveback urb %p\n", urb);
 
-	spin_lock(&the_controller->lock);
+	spin_lock_irqsave(&the_controller->lock, flags);
 	usb_hcd_unlink_urb_from_ep(vhci_to_hcd(the_controller), urb);
-	spin_unlock(&the_controller->lock);
+	spin_unlock_irqrestore(&the_controller->lock, flags);
 
 	usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb, urb->status);
 
@@ -141,6 +142,7 @@ static void vhci_recv_ret_unlink(struct
 {
 	struct vhci_unlink *unlink;
 	struct urb *urb;
+	unsigned long flags;
 
 	usbip_dump_header(pdu);
 
@@ -170,9 +172,9 @@ static void vhci_recv_ret_unlink(struct
 		urb->status = pdu->u.ret_unlink.status;
 		pr_info("urb->status %d\n", urb->status);
 
-		spin_lock(&the_controller->lock);
+		spin_lock_irqsave(&the_controller->lock, flags);
 		usb_hcd_unlink_urb_from_ep(vhci_to_hcd(the_controller), urb);
-		spin_unlock(&the_controller->lock);
+		spin_unlock_irqrestore(&the_controller->lock, flags);
 
 		usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb,
 				     urb->status);


