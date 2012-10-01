Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738Ab2JAXD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:03:26 -0400
Received: from 1wt.eu ([62.212.114.60]:35653 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757724Ab2JAXDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:03:19 -0400
Message-Id: <20121001225158.971534941@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:29 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable@kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Ming Lei <tom.leiming@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 032/180] usbnet: dont clear urb->dev in tx_complete
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: tom.leiming@gmail.com <tom.leiming@gmail.com>

commit 5d5440a835710d09f0ef18da5000541ec98b537a upstream.

URB unlinking is always racing with its completion and tx_complete
may be called before or during running usb_unlink_urb, so tx_complete
must not clear urb->dev since it will be used in unlink path,
otherwise invalid memory accesses or usb device leak may be caused
inside usb_unlink_urb.

Cc: stable@kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/usb/usbnet.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index a92a415..07f69ee 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -998,7 +998,6 @@ static void tx_complete (struct urb *urb)
 		}
 	}
 
-	urb->dev = NULL;
 	entry->state = tx_done;
 	defer_bh(dev, skb, &dev->txq);
 }
-- 
1.7.2.1.45.g54fbc



