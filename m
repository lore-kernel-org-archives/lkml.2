Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab3AHXhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:37:46 -0500
Received: from mail.windriver.com ([147.11.1.11]:63541 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984Ab3AHXhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:37:40 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Bart Westgeest <bart@elbrys.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 30/77] staging: usbip: bugfix for deadlock
Date: Tue, 8 Jan 2013 18:35:09 -0500
Message-ID: <1357688156-25387-31-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bart Westgeest <bart@elbrys.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 438957f8d4a84daa7fa5be6978ad5897a2e9e5e5 upstream.

Interrupts must be disabled prior to calling usb_hcd_unlink_urb_from_ep.
If interrupts are not disabled, it can potentially lead to a deadlock.
The deadlock is readily reproduceable on a slower (ARM based) device
such as the TI Pandaboard.

Signed-off-by: Bart Westgeest <bart@elbrys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/usbip/vhci_rx.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/usbip/vhci_rx.c b/drivers/staging/usbip/vhci_rx.c
index a1ac1b8..b09c67a 100644
--- a/drivers/staging/usbip/vhci_rx.c
+++ b/drivers/staging/usbip/vhci_rx.c
@@ -69,6 +69,7 @@ static void vhci_recv_ret_submit(struct vhci_device *vdev,
 {
 	struct usbip_device *ud = &vdev->ud;
 	struct urb *urb;
+	unsigned long flags;
 
 	spin_lock(&vdev->priv_lock);
 
@@ -109,9 +110,9 @@ static void vhci_recv_ret_submit(struct vhci_device *vdev,
 
 	usbip_dbg_vhci_rx("now giveback urb %p\n", urb);
 
-	spin_lock(&the_controller->lock);
+	spin_lock_irqsave(&the_controller->lock, flags);
 	usb_hcd_unlink_urb_from_ep(vhci_to_hcd(the_controller), urb);
-	spin_unlock(&the_controller->lock);
+	spin_unlock_irqrestore(&the_controller->lock, flags);
 
 	usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb, urb->status);
 
@@ -152,6 +153,7 @@ static void vhci_recv_ret_unlink(struct vhci_device *vdev,
 {
 	struct vhci_unlink *unlink;
 	struct urb *urb;
+	unsigned long flags;
 
 	usbip_dump_header(pdu);
 
@@ -183,9 +185,9 @@ static void vhci_recv_ret_unlink(struct vhci_device *vdev,
 		urb->status = pdu->u.ret_unlink.status;
 		usbip_uinfo("%d\n", urb->status);
 
-		spin_lock(&the_controller->lock);
+		spin_lock_irqsave(&the_controller->lock, flags);
 		usb_hcd_unlink_urb_from_ep(vhci_to_hcd(the_controller), urb);
-		spin_unlock(&the_controller->lock);
+		spin_unlock_irqrestore(&the_controller->lock, flags);
 
 		usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb,
 								urb->status);
-- 
1.7.12.1

