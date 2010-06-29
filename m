Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab0F2QRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 12:17:43 -0400
Received: from smtp.extricom.com ([192.114.46.18]:53024 "HELO
	smtp.extricom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755849Ab0F2QRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 12:17:42 -0400
Message-ID: <4C2A1D32.1040501@extricom.com>
Date: Tue, 29 Jun 2010 19:20:02 +0300
From: Eran Liberty <liberty@extricom.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: galak@kernel.crashing.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] gainfar.c : code cleanup
References: <4C232B13.5000706@extricom.com>	<20100624.145225.70206491.davem@davemloft.net>	<4C2855D4.5050507@extricom.com> <20100628.113336.112593735.davem@davemloft.net> <4C2A145D.1000702@extricom.com>
In-Reply-To: <4C2A145D.1000702@extricom.com>
Content-Type: multipart/mixed;
 boundary="------------000005090403020402090609"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000005090403020402090609
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch relates to "[PATCH] gainfar.c : skb_over_panic 
(kernel-2.6.32.15)"

While in 2.6.32.15 it actually fixed a bug here it merely cleans up the 
previous attempts to fix the bug with a more coherent code.

Currently before queuing skb into the rx_recycle it is 
"un-skb_reserve"-ed so when taken out in gfar_new_skb() it wont be 
reserved twice.

This patch makes sure the alignment skb_reserve is done once, upon 
allocating the skb and
not when taken out of the rx_recycle pool. Eliminating the need to undo 
anything before queue skb back to the pool.

NOTE: This patch will compile and is fairly straight forward  but I do 
not have environment to test it as I did with the 2.6.32.15 fix.

-- Liberty

Signed-off-by: Eran Liberty <liberty@extricom.com>


--------------000005090403020402090609
Content-Type: text/x-diff;
 name="gianfar_skb_over_panic-linus.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gianfar_skb_over_panic-linus.patch"

---
 drivers/net/gianfar.c |   54 ++++++++++++++++++++++++------------------------
 1 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
index 28b53d1..334c8b5 100644
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -2342,6 +2342,15 @@ static void gfar_timeout(struct net_device *dev)
 	schedule_work(&priv->reset_task);
 }
 
+static void gfar_align_skb(struct sk_buff *skb)
+{
+	/* We need the data buffer to be aligned properly.  We will reserve
+	 * as many bytes as needed to align the data properly
+	 */
+	skb_reserve(skb, RXBUF_ALIGNMENT -
+		(((unsigned long) skb->data) & (RXBUF_ALIGNMENT - 1)));
+}
+
 /* Interrupt Handler for Transmit complete */
 static int gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
 {
@@ -2426,9 +2435,10 @@ static int gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
 		 */
 		if (skb_queue_len(&priv->rx_recycle) < rx_queue->rx_ring_size &&
 				skb_recycle_check(skb, priv->rx_buffer_size +
-					RXBUF_ALIGNMENT))
+					RXBUF_ALIGNMENT)) {
+			gfar_align_skb(skb);
 			__skb_queue_head(&priv->rx_recycle, skb);
-		else
+		} else
 			dev_kfree_skb_any(skb);
 
 		tx_queue->tx_skbuff[skb_dirtytx] = NULL;
@@ -2491,29 +2501,28 @@ static void gfar_new_rxbdp(struct gfar_priv_rx_q *rx_queue, struct rxbd8 *bdp,
 	gfar_init_rxbdp(rx_queue, bdp, buf);
 }
 
-
-struct sk_buff * gfar_new_skb(struct net_device *dev)
+static struct sk_buff * gfar_alloc_skb(struct net_device *dev)
 {
-	unsigned int alignamount;
 	struct gfar_private *priv = netdev_priv(dev);
 	struct sk_buff *skb = NULL;
 
-	skb = __skb_dequeue(&priv->rx_recycle);
-	if (!skb)
-		skb = netdev_alloc_skb(dev,
-				priv->rx_buffer_size + RXBUF_ALIGNMENT);
-
+	skb = netdev_alloc_skb(dev, priv->rx_buffer_size + RXBUF_ALIGNMENT);
 	if (!skb)
 		return NULL;
 
-	alignamount = RXBUF_ALIGNMENT -
-		(((unsigned long) skb->data) & (RXBUF_ALIGNMENT - 1));
+	gfar_align_skb(skb);
 
-	/* We need the data buffer to be aligned properly.  We will reserve
-	 * as many bytes as needed to align the data properly
-	 */
-	skb_reserve(skb, alignamount);
-	GFAR_CB(skb)->alignamount = alignamount;
+	return skb;
+}
+
+struct sk_buff * gfar_new_skb(struct net_device *dev)
+{
+	struct gfar_private *priv = netdev_priv(dev);
+	struct sk_buff *skb = NULL;
+
+	skb = __skb_dequeue(&priv->rx_recycle);
+	if (!skb)
+		skb = gfar_alloc_skb(dev);
 
 	return skb;
 }
@@ -2666,17 +2675,8 @@ int gfar_clean_rx_ring(struct gfar_priv_rx_q *rx_queue, int rx_work_limit)
 
 			if (unlikely(!newskb))
 				newskb = skb;
-			else if (skb) {
-				/*
-				 * We need to un-reserve() the skb to what it
-				 * was before gfar_new_skb() re-aligned
-				 * it to an RXBUF_ALIGNMENT boundary
-				 * before we put the skb back on the
-				 * recycle list.
-				 */
-				skb_reserve(skb, -GFAR_CB(skb)->alignamount);
+			else if (skb) 
 				__skb_queue_head(&priv->rx_recycle, skb);
-			}
 		} else {
 			/* Increment the number of packets */
 			rx_queue->stats.rx_packets++;
-- 
1.5.6.5


--------------000005090403020402090609--
