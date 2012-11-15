Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426Ab2KOEpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:45:04 -0500
Received: from mail.kernel.org ([198.145.19.201]:48553 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992743Ab2KOEKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:10:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Hemant Kumar <hemantk@codeaurora.org>, Oliver Neukum <oneukum@suse.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 28/38] net: usb: Fix memory leak on Tx data path
Date: Wed, 14 Nov 2012 20:10:25 -0800
Message-Id: <20121115040934.636589333@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040932.918082372@linuxfoundation.org>
References: <20121115040932.918082372@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Hemant Kumar <hemantk@codeaurora.org>

[ Upstream commit 39707c2a3ba5011038b363f84d37c8a98d2d9db1 ]

Driver anchors the tx urbs and defers the urb submission if
a transmit request comes when the interface is suspended.
Anchoring urb increments the urb reference count. These
deferred urbs are later accessed by calling usb_get_from_anchor()
for submission during interface resume. usb_get_from_anchor()
unanchors the urb but urb reference count remains same.
This causes the urb reference count to remain non-zero
after usb_free_urb() gets called and urb never gets freed.
Hence call usb_put_urb() after anchoring the urb to properly
balance the reference count for these deferred urbs. Also,
unanchor these deferred urbs during disconnect, to free them
up.

Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
Acked-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/usbnet.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1149,6 +1149,7 @@ netdev_tx_t usbnet_start_xmit (struct sk
 		usb_anchor_urb(urb, &dev->deferred);
 		/* no use to process more packets */
 		netif_stop_queue(net);
+		usb_put_urb(urb);
 		spin_unlock_irqrestore(&dev->txq.lock, flags);
 		netdev_dbg(dev->net, "Delaying transmission for resumption\n");
 		goto deferred;
@@ -1290,6 +1291,8 @@ void usbnet_disconnect (struct usb_inter
 
 	cancel_work_sync(&dev->kevent);
 
+	usb_scuttle_anchored_urbs(&dev->deferred);
+
 	if (dev->driver_info->unbind)
 		dev->driver_info->unbind (dev, intf);
 


