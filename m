Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab0F2PkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 11:40:05 -0400
Received: from smtp.extricom.com ([192.114.46.18]:34960 "HELO
	smtp.extricom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756441Ab0F2PkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 11:40:03 -0400
Message-ID: <4C2A145D.1000702@extricom.com>
Date: Tue, 29 Jun 2010 18:42:21 +0300
From: Eran Liberty <liberty@extricom.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: galak@kernel.crashing.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] gainfar.c : skb_over_panic (kernel-2.6.32.15)
References: <4C232B13.5000706@extricom.com>	<20100624.145225.70206491.davem@davemloft.net>	<4C2855D4.5050507@extricom.com> <20100628.113336.112593735.davem@davemloft.net>
In-Reply-To: <20100628.113336.112593735.davem@davemloft.net>
Content-Type: multipart/mixed;
 boundary="------------090900030108070501050608"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090900030108070501050608
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

David Miller wrote:
> From: Eran Liberty <liberty@extricom.com>
> Date: Mon, 28 Jun 2010 10:57:08 +0300
>
>   
>> This code has proved to be insufficient and produce
>> skb_over_panic. The proposed patch fix this.
>>     
>
> Then you have to post a patch relative to the current code, rather than
> against the code as it was several releases ago.
>
> Your patch didn't apply, so I can't use it.
>
>   
Upon cleaning up my patch for the latest kernel I realized I do not
like: the previous partial fix, the fix in ucc_geth.c, the fix in the
current latest kernel, and my own previously proposed patch. They all
tried to undo the alignment skb_reserve done in gfar_new_skb() before
queuing the skb into the rw_recycle, because upon getting a new one in
gfar_new_skb() if the skb is from the rx_recycle pool rather then newly
allocated it is reserved twice.

Instead of trying to undo the skb_reserve this proposed patch will make
sure the alignment skb_reserve is done once, upon allocating the skb and
not when taken out of the rx_recycle pool. Eliminating the need to undo
anything before queue skb back to the pool.

This patch will apply cleanly against the 2.6.32.15. Another patch will
be submitted separately for the current Linus tree.

-- Liberty

Signed-off-by: Eran Liberty <liberty@extricom.com>


--------------090900030108070501050608
Content-Type: text/x-diff;
 name="gianfar_skb_over_panic.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gianfar_skb_over_panic.patch"

---
 drivers/net/gianfar.c |   52 +++++++++++++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 25 deletions(-)

--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -1568,6 +1568,15 @@
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
 static int gfar_clean_tx_ring(struct net_device *dev)
 {
@@ -1620,9 +1629,10 @@
 		 */
 		if (skb_queue_len(&priv->rx_recycle) < priv->rx_ring_size &&
 				skb_recycle_check(skb, priv->rx_buffer_size +
-					RXBUF_ALIGNMENT))
+					RXBUF_ALIGNMENT)) {
+			gfar_align_skb(skb);
 			__skb_queue_head(&priv->rx_recycle, skb);
-		else
+		} else
 			dev_kfree_skb_any(skb);
 
 		priv->tx_skbuff[skb_dirtytx] = NULL;
@@ -1696,28 +1706,29 @@
 	bdp->lstatus = lstatus;
 }
 
+static struct sk_buff * gfar_alloc_skb(struct net_device *dev)
+{
+	struct gfar_private *priv = netdev_priv(dev);
+	struct sk_buff *skb = NULL;
+
+	skb = netdev_alloc_skb(dev, priv->rx_buffer_size + RXBUF_ALIGNMENT);
+	if (!skb)
+		return NULL;
+
+	gfar_align_skb(skb);
+
+	return skb;
+}
 
 struct sk_buff * gfar_new_skb(struct net_device *dev)
 {
-	unsigned int alignamount;
 	struct gfar_private *priv = netdev_priv(dev);
 	struct sk_buff *skb = NULL;
 
 	skb = __skb_dequeue(&priv->rx_recycle);
-	if (!skb)
-		skb = netdev_alloc_skb(dev,
-				priv->rx_buffer_size + RXBUF_ALIGNMENT);
 
 	if (!skb)
-		return NULL;
-
-	alignamount = RXBUF_ALIGNMENT -
-		(((unsigned long) skb->data) & (RXBUF_ALIGNMENT - 1));
-
-	/* We need the data buffer to be aligned properly.  We will reserve
-	 * as many bytes as needed to align the data properly
-	 */
-	skb_reserve(skb, alignamount);
+		skb = gfar_alloc_skb(dev);
 
 	return skb;
 }
@@ -1853,17 +1864,8 @@
 
 			if (unlikely(!newskb))
 				newskb = skb;
-			else if (skb) {
-				/*
-				 * We need to reset ->data to what it
-				 * was before gfar_new_skb() re-aligned
-				 * it to an RXBUF_ALIGNMENT boundary
-				 * before we put the skb back on the
-				 * recycle list.
-				 */
-				skb->data = skb->head + NET_SKB_PAD;
+			else if (skb)
 				__skb_queue_head(&priv->rx_recycle, skb);
-			}
 		} else {
 			/* Increment the number of packets */
 			dev->stats.rx_packets++;


--------------090900030108070501050608--
