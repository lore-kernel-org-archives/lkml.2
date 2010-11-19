Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab0KSWUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:20:18 -0500
Received: from kroah.org ([198.145.64.141]:45276 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757575Ab0KSV6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:55 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:43 2010
Message-Id: <20101119215643.671111801@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:56:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jarek Poplawski <jarkao2@gmail.com>,
        Andy Fleming <afleming@freescale.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [60/82] gianfar: Fix crashes on RX path (Was Re: [Bugme-new] [Bug 19692] New: linux-2.6.36-rc5 crash with gianfar ethernet at full line rate traffic)
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Jarek Poplawski <jarkao2@gmail.com>

[ Upstream commit 0d1fe1111c667e9c713d7efc7ae468a605f236a4 ]

The rx_recycle queue is global per device but can be accesed by many
napi handlers at the same time, so it needs full skb_queue primitives
(with locking). Otherwise, various crashes caused by broken skbs are
possible.

This patch resolves, at least partly, bugzilla bug 19692. (Because of
some doubts that there could be still something around which is hard
to reproduce my proposal is to leave this bug opened for a month.)

Fixes commit: 0fd56bb5be6455d0d42241e65aed057244665e5e ("gianfar: Add
support for skb recycling")

Reported-by: emin ak <eminak71@gmail.com>
Tested-by: emin ak <eminak71@gmail.com>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
CC: Andy Fleming <afleming@freescale.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/gianfar.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -2427,7 +2427,7 @@ static int gfar_clean_tx_ring(struct gfa
 		if (skb_queue_len(&priv->rx_recycle) < rx_queue->rx_ring_size &&
 				skb_recycle_check(skb, priv->rx_buffer_size +
 					RXBUF_ALIGNMENT))
-			__skb_queue_head(&priv->rx_recycle, skb);
+			skb_queue_head(&priv->rx_recycle, skb);
 		else
 			dev_kfree_skb_any(skb);
 
@@ -2498,7 +2498,7 @@ struct sk_buff * gfar_new_skb(struct net
 	struct gfar_private *priv = netdev_priv(dev);
 	struct sk_buff *skb = NULL;
 
-	skb = __skb_dequeue(&priv->rx_recycle);
+	skb = skb_dequeue(&priv->rx_recycle);
 	if (!skb)
 		skb = netdev_alloc_skb(dev,
 				priv->rx_buffer_size + RXBUF_ALIGNMENT);
@@ -2675,7 +2675,7 @@ int gfar_clean_rx_ring(struct gfar_priv_
 				 * recycle list.
 				 */
 				skb_reserve(skb, -GFAR_CB(skb)->alignamount);
-				__skb_queue_head(&priv->rx_recycle, skb);
+				skb_queue_head(&priv->rx_recycle, skb);
 			}
 		} else {
 			/* Increment the number of packets */


