Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab0LMU7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 15:59:16 -0500
Received: from relay01.digicable.hu ([92.249.128.189]:44626 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab0LMU7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 15:59:15 -0500
Message-ID: <4D06891D.3060605@freemail.hu>
Date: Mon, 13 Dec 2010 21:59:09 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] usbip: remove double giveback of URB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 78.131.104.28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

In the vhci_urb_dequeue() function the TCP connection is checked twice.
Each time when the TCP connection is closed the URB is unlinked and given
back. Remove the second attempt of unlinking and giving back of the URB completely.

This patch fixes the bug described at https://bugzilla.kernel.org/show_bug.cgi?id=24872 .

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-2.6.37-rc5/drivers/staging/usbip/vhci_hcd.c.orig	2010-12-13 08:21:51.000000000 +0100
+++ linux-2.6.37-rc5/drivers/staging/usbip/vhci_hcd.c	2010-12-13 21:17:30.000000000 +0100
@@ -799,20 +799,6 @@ static int vhci_urb_dequeue(struct usb_h
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
