Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935212Ab2C3WqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:46:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935122Ab2C3VGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:06:54 -0400
Message-Id: <20120330195732.666452340@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:58:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Ming Lei <tom.leiming@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 073/108] usbnet: dont clear urb->dev in tx_complete
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "tom.leiming@gmail.com" <tom.leiming@gmail.com>

commit 5d5440a835710d09f0ef18da5000541ec98b537a upstream.

URB unlinking is always racing with its completion and tx_complete
may be called before or during running usb_unlink_urb, so tx_complete
must not clear urb->dev since it will be used in unlink path,
otherwise invalid memory accesses or usb device leak may be caused
inside usb_unlink_urb.

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/usbnet.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1033,7 +1033,6 @@ static void tx_complete (struct urb *urb
 	}
 
 	usb_autopm_put_interface_async(dev->intf);
-	urb->dev = NULL;
 	entry->state = tx_done;
 	defer_bh(dev, skb, &dev->txq);
 }


