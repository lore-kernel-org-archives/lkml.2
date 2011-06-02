Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab1FBPoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 11:44:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322Ab1FBPn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 11:43:57 -0400
Date: Thu, 2 Jun 2011 18:43:17 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Shirley Ma <xma@us.ibm.com>, lguest@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Krishna Kumar <krkumar2@in.ibm.com>,
        Tom Lendacky <tahm@linux.vnet.ibm.com>, steved@us.ibm.com,
        habanero@linux.vnet.ibm.com
Subject: [PATCHv2 RFC 3/4] virtio_net: limit xmit polling
Message-ID: <a80199422de16ae355e56ee1b2abc9b2bf91a7f6.1307029009.git.mst@redhat.com>
References: <cover.1307029008.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1307029008.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code might introduce a lot of latency variation
if there are many pending bufs at the time we
attempt to transmit a new one. This is bad for
real-time applications and can't be good for TCP either.

Free up just enough to both clean up all buffers
eventually and to be able to xmit the next packet.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/virtio_net.c |  106 +++++++++++++++++++++++++++++-----------------
 1 files changed, 67 insertions(+), 39 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index a0ee78d..b25db1c 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -509,17 +509,33 @@ again:
 	return received;
 }
 
-static void free_old_xmit_skbs(struct virtnet_info *vi)
+static bool free_old_xmit_skb(struct virtnet_info *vi)
 {
 	struct sk_buff *skb;
 	unsigned int len;
 
-	while ((skb = virtqueue_get_buf(vi->svq, &len)) != NULL) {
-		pr_debug("Sent skb %p\n", skb);
-		vi->dev->stats.tx_bytes += skb->len;
-		vi->dev->stats.tx_packets++;
-		dev_kfree_skb_any(skb);
-	}
+	skb = virtqueue_get_buf(vi->svq, &len);
+	if (unlikely(!skb))
+		return false;
+	pr_debug("Sent skb %p\n", skb);
+	vi->dev->stats.tx_bytes += skb->len;
+	vi->dev->stats.tx_packets++;
+	dev_kfree_skb_any(skb);
+	return true;
+}
+
+/* Check capacity and try to free enough pending old buffers to enable queueing
+ * new ones. Return true if we can guarantee that a following
+ * virtqueue_add_buf will succeed. */
+static bool free_xmit_capacity(struct virtnet_info *vi)
+{
+	struct sk_buff *skb;
+	unsigned int len;
+
+	while (virtqueue_min_capacity(vi->svq) < MAX_SKB_FRAGS + 2)
+		if (unlikely(!free_old_xmit_skb))
+			return false;
+	return true;
 }
 
 static int xmit_skb(struct virtnet_info *vi, struct sk_buff *skb)
@@ -572,30 +588,34 @@ static int xmit_skb(struct virtnet_info *vi, struct sk_buff *skb)
 static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
-	int capacity;
-
-	/* Free up any pending old buffers before queueing new ones. */
-	free_old_xmit_skbs(vi);
-
-	/* Try to transmit */
-	capacity = xmit_skb(vi, skb);
-
-	/* This can happen with OOM and indirect buffers. */
-	if (unlikely(capacity < 0)) {
-		if (net_ratelimit()) {
-			if (likely(capacity == -ENOMEM)) {
-				dev_warn(&dev->dev,
-					 "TX queue failure: out of memory\n");
-			} else {
-				dev->stats.tx_fifo_errors++;
+	int ret, i;
+
+	/* We normally do have space in the ring, so try to queue the skb as
+	 * fast as possible. */
+	ret = xmit_skb(vi, skb);
+	if (unlikely(ret < 0)) {
+		/* This triggers on the first xmit after ring full condition.
+		 * We need to free up some skbs first. */
+		if (likely(free_xmit_capacity(vi))) {
+			ret = xmit_skb(vi, skb);
+			/* This should never fail. Check, just in case. */
+			if (unlikely(ret < 0)) {
 				dev_warn(&dev->dev,
 					 "Unexpected TX queue failure: %d\n",
-					 capacity);
+					 ret);
+				dev->stats.tx_fifo_errors++;
+				dev->stats.tx_dropped++;
+				kfree_skb(skb);
+				return NETDEV_TX_OK;
 			}
+		} else {
+			/* Ring full: it might happen if we get a callback while
+			 * the queue is still mostly full. This should be
+			 * extremely rare. */
+			dev->stats.tx_dropped++;
+			kfree_skb(skb);
+			goto stop;
 		}
-		dev->stats.tx_dropped++;
-		kfree_skb(skb);
-		return NETDEV_TX_OK;
 	}
 	virtqueue_kick(vi->svq);
 
@@ -603,18 +623,26 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 	skb_orphan(skb);
 	nf_reset(skb);
 
-	/* Apparently nice girls don't return TX_BUSY; stop the queue
-	 * before it gets out of hand.  Naturally, this wastes entries. */
-	if (capacity < 2+MAX_SKB_FRAGS) {
-		netif_stop_queue(dev);
-		if (unlikely(!virtqueue_enable_cb_delayed(vi->svq))) {
-			/* More just got used, free them then recheck. */
-			free_old_xmit_skbs(vi);
-			capacity = virtqueue_min_capacity(vi->svq);
-			if (capacity >= 2+MAX_SKB_FRAGS) {
-				netif_start_queue(dev);
-				virtqueue_disable_cb(vi->svq);
-			}
+	/* We transmit one skb, so try to free at least two pending skbs.
+	 * This is so that we don't hog the skb memory unnecessarily. *
+	 * Doing this after kick means there's a chance we'll free
+	 * the skb we have just sent, which is hot in cache. */
+	for (i = 0; i < 2; i++)
+		free_old_xmit_skb(v);
+
+	if (likely(free_xmit_capacity(vi)))
+		return NETDEV_TX_OK;
+
+stop:
+	/* Apparently nice girls don't return TX_BUSY; check capacity and stop
+	 * the queue before it gets out of hand.
+	 * Naturally, this wastes entries. */
+	netif_stop_queue(dev);
+	if (unlikely(!virtqueue_enable_cb_delayed(vi->svq))) {
+		/* More just got used, free them and recheck. */
+		if (free_xmit_capacity(vi)) {
+			netif_start_queue(dev);
+			virtqueue_disable_cb(vi->svq);
 		}
 	}
 
-- 
1.7.5.53.gc233e

