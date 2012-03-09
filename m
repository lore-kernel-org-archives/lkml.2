Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031216Ab2CITuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:50:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031194Ab2CITuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:50:10 -0500
Message-Id: <20120309190208.984547820@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:25 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?An=C3=83=C2=ADbal=20Almeida=20Pinto?= 
	<anibal.pinto@efacec.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 83/95] net/usbnet: avoid recursive locking in usbnet_stop()
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Siewior <bigeasy@linutronix.de>

commit 4231d47e6fe69f061f96c98c30eaf9fb4c14b96d upstream.

|kernel BUG at kernel/rtmutex.c:724!
|[<c029599c>] (rt_spin_lock_slowlock+0x108/0x2bc) from [<c01c2330>] (defer_bh+0x1c/0xb4)
|[<c01c2330>] (defer_bh+0x1c/0xb4) from [<c01c3afc>] (rx_complete+0x14c/0x194)
|[<c01c3afc>] (rx_complete+0x14c/0x194) from [<c01cac88>] (usb_hcd_giveback_urb+0xa0/0xf0)
|[<c01cac88>] (usb_hcd_giveback_urb+0xa0/0xf0) from [<c01e1ff4>] (musb_giveback+0x34/0x40)
|[<c01e1ff4>] (musb_giveback+0x34/0x40) from [<c01e2b1c>] (musb_advance_schedule+0xb4/0x1c0)
|[<c01e2b1c>] (musb_advance_schedule+0xb4/0x1c0) from [<c01e2ca8>] (musb_cleanup_urb.isra.9+0x80/0x8c)
|[<c01e2ca8>] (musb_cleanup_urb.isra.9+0x80/0x8c) from [<c01e2ed0>] (musb_urb_dequeue+0xec/0x108)
|[<c01e2ed0>] (musb_urb_dequeue+0xec/0x108) from [<c01cbb90>] (unlink1+0xbc/0xcc)
|[<c01cbb90>] (unlink1+0xbc/0xcc) from [<c01cc2ec>] (usb_hcd_unlink_urb+0x54/0xa8)
|[<c01cc2ec>] (usb_hcd_unlink_urb+0x54/0xa8) from [<c01c2a84>] (unlink_urbs.isra.17+0x2c/0x58)
|[<c01c2a84>] (unlink_urbs.isra.17+0x2c/0x58) from [<c01c2b44>] (usbnet_terminate_urbs+0x94/0x10c)
|[<c01c2b44>] (usbnet_terminate_urbs+0x94/0x10c) from [<c01c2d68>] (usbnet_stop+0x100/0x15c)
|[<c01c2d68>] (usbnet_stop+0x100/0x15c) from [<c020f718>] (__dev_close_many+0x94/0xc8)

defer_bh() takes the lock which is hold during unlink_urbs(). The safe
walk suggest that the skb will be removed from the list and this is done
by defer_bh() so it seems to be okay to drop the lock here.

Reported-by: AnÃ­bal Almeida Pinto <anibal.pinto@efacec.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Oliver Neukum <oliver@neukum.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/usbnet.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -589,6 +589,7 @@ static int unlink_urbs (struct usbnet *d
 		entry = (struct skb_data *) skb->cb;
 		urb = entry->urb;
 
+		spin_unlock_irqrestore(&q->lock, flags);
 		// during some PM-driven resume scenarios,
 		// these (async) unlinks complete immediately
 		retval = usb_unlink_urb (urb);
@@ -596,6 +597,7 @@ static int unlink_urbs (struct usbnet *d
 			netdev_dbg(dev->net, "unlink urb err, %d\n", retval);
 		else
 			count++;
+		spin_lock_irqsave(&q->lock, flags);
 	}
 	spin_unlock_irqrestore (&q->lock, flags);
 	return count;


