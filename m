Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790Ab1EFAsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:48:17 -0400
Received: from kroah.org ([198.145.64.141]:37012 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024Ab1EFAZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:23 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:13 2011
Message-Id: <20110506002213.749571650@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [087/143] virtio_net: fix oom handling on tx
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Rusty Russell <rusty@rustcorp.com.au>

commit 58eba97d0774c69b1cf3e5a8ac74419409d1abbf upstream.

virtio net will never try to overflow the TX ring, so the only reason
add_buf may fail is out of memory. Thus, we can not stop the
device until some request completes - there's no guarantee anything
at all is outstanding.

Make the error message clearer as well: error here does not
indicate queue full.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/virtio_net.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -525,7 +525,6 @@ static netdev_tx_t start_xmit(struct sk_
 	struct virtnet_info *vi = netdev_priv(dev);
 	int capacity;
 
-again:
 	/* Free up any pending old buffers before queueing new ones. */
 	free_old_xmit_skbs(vi);
 
@@ -534,14 +533,20 @@ again:
 
 	/* This can happen with OOM and indirect buffers. */
 	if (unlikely(capacity < 0)) {
-		netif_stop_queue(dev);
-		dev_warn(&dev->dev, "Unexpected full queue\n");
-		if (unlikely(!vi->svq->vq_ops->enable_cb(vi->svq))) {
-			vi->svq->vq_ops->disable_cb(vi->svq);
-			netif_start_queue(dev);
-			goto again;
+		if (net_ratelimit()) {
+			if (likely(capacity == -ENOMEM)) {
+				dev_warn(&dev->dev,
+					 "TX queue failure: out of memory\n");
+			} else {
+				dev->stats.tx_fifo_errors++;
+				dev_warn(&dev->dev,
+					 "Unexpected TX queue failure: %d\n",
+					 capacity);
+			}
 		}
-		return NETDEV_TX_BUSY;
+		dev->stats.tx_dropped++;
+		kfree_skb(skb);
+		return NETDEV_TX_OK;
 	}
 	vi->svq->vq_ops->kick(vi->svq);
 


