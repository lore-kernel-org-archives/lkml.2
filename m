Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab1LGRDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:03:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39278 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755557Ab1LGRDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:03:01 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:56:01 2011
Message-Id: <20111207165601.430284072@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:54:45 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Bart Westgeest <bart@elbrys.com>
Subject: [12/27] staging: usbip: bugfix for deadlock
In-Reply-To: <20111207165611.GA19872@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
@@ -67,6 +67,7 @@ static void vhci_recv_ret_submit(struct
 {
 	struct usbip_device *ud = &vdev->ud;
 	struct urb *urb;
+	unsigned long flags;
 
 	spin_lock(&vdev->priv_lock);
 
@@ -107,9 +108,9 @@ static void vhci_recv_ret_submit(struct
 
 	usbip_dbg_vhci_rx("now giveback urb %p\n", urb);
 
-	spin_lock(&the_controller->lock);
+	spin_lock_irqsave(&the_controller->lock, flags);
 	usb_hcd_unlink_urb_from_ep(vhci_to_hcd(the_controller), urb);
-	spin_unlock(&the_controller->lock);
+	spin_unlock_irqrestore(&the_controller->lock, flags);
 
 	usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb, urb->status);
 
@@ -150,6 +151,7 @@ static void vhci_recv_ret_unlink(struct
 {
 	struct vhci_unlink *unlink;
 	struct urb *urb;
+	unsigned long flags;
 
 	usbip_dump_header(pdu);
 
@@ -181,9 +183,9 @@ static void vhci_recv_ret_unlink(struct
 		urb->status = pdu->u.ret_unlink.status;
 		usbip_uinfo("%d\n", urb->status);
 
-		spin_lock(&the_controller->lock);
+		spin_lock_irqsave(&the_controller->lock, flags);
 		usb_hcd_unlink_urb_from_ep(vhci_to_hcd(the_controller), urb);
-		spin_unlock(&the_controller->lock);
+		spin_unlock_irqrestore(&the_controller->lock, flags);
 
 		usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb,
 								urb->status);


