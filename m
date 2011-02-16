Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab1BPBs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:48:57 -0500
Received: from kroah.org ([198.145.64.141]:48672 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756819Ab1BPBsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:48:54 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:46:54 2011
Message-Id: <20110216014654.395831600@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:44:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?M=C3=A1rton=20N=C3=A9meth?= <nm127@freemail.hu>
Subject: [001/115] staging: usbip: remove double giveback of URB
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: =?UTF-8?q?M=C3=A1rton=20N=C3=A9meth?= <nm127@freemail.hu>

commit 7571f089d7522a95c103558faf313c7af8856ceb upstream.

In the vhci_urb_dequeue() function the TCP connection is checked twice.
Each time when the TCP connection is closed the URB is unlinked and given
back. Remove the second attempt of unlinking and giving back of the URB completely.

This patch fixes the bug described at https://bugzilla.kernel.org/show_bug.cgi?id=24872 .

Signed-off-by: Márton Németh <nm127@freemail.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/usbip/vhci_hcd.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -798,20 +798,6 @@ static int vhci_urb_dequeue(struct usb_h
 		spin_unlock_irqrestore(&vdev->priv_lock, flags2);
 	}
 
-
-	if (!vdev->ud.tcp_socket) {
-		/* tcp connection is closed */
-		usbip_uinfo("vhci_hcd: vhci_urb_dequeue() gives back urb %p\n",
-									urb);
-
-		usb_hcd_unlink_urb_from_ep(hcd, urb);
-
-		spin_unlock_irqrestore(&the_controller->lock, flags);
-		usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb,
-								urb->status);
-		spin_lock_irqsave(&the_controller->lock, flags);
-	}
-
 	spin_unlock_irqrestore(&the_controller->lock, flags);
 
 	usbip_dbg_vhci_hc("leave\n");


