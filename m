Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933526Ab1DNRvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:51:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:38567 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933419Ab1DNRrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:47:23 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jarek Poplawski <jarkao2@gmail.com>,
        Andy Fleming <afleming@freescale.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 104/209] gianfar: Fix crashes on RX path (Was Re: [Bugme-new] [Bug 19692] New: linux-2.6.36-rc5 crash with gianfar ethernet at full line rate traffic)
Date: Thu, 14 Apr 2011 13:42:14 -0400
Message-Id: <1302803039-9400-105-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit cd0ea2419544cfc4ccbf8ee0087d0d9f109852d2 upstream.

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/gianfar.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
index 5d3763f..58496d3 100644
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -2303,7 +2303,7 @@ static int gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
 		if (skb_queue_len(&priv->rx_recycle) < rx_queue->rx_ring_size &&
 				skb_recycle_check(skb, priv->rx_buffer_size +
 					RXBUF_ALIGNMENT))
-			__skb_queue_head(&priv->rx_recycle, skb);
+			skb_queue_head(&priv->rx_recycle, skb);
 		else
 			dev_kfree_skb_any(skb);
 
@@ -2374,7 +2374,7 @@ struct sk_buff * gfar_new_skb(struct net_device *dev)
 	struct gfar_private *priv = netdev_priv(dev);
 	struct sk_buff *skb = NULL;
 
-	skb = __skb_dequeue(&priv->rx_recycle);
+	skb = skb_dequeue(&priv->rx_recycle);
 	if (!skb)
 		skb = netdev_alloc_skb(dev,
 				priv->rx_buffer_size + RXBUF_ALIGNMENT);
@@ -2537,7 +2537,7 @@ int gfar_clean_rx_ring(struct gfar_priv_rx_q *rx_queue, int rx_work_limit)
 				 * recycle list.
 				 */
 				skb_reserve(skb, -GFAR_CB(skb)->alignamount);
-				__skb_queue_head(&priv->rx_recycle, skb);
+				skb_queue_head(&priv->rx_recycle, skb);
 			}
 		} else {
 			/* Increment the number of packets */
-- 
1.7.4.4

