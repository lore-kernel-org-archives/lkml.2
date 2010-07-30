Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048Ab0G3SWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:22:33 -0400
Received: from kroah.org ([198.145.64.141]:58679 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932440Ab0G3R4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:20 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:43 2010
Message-Id: <20100730175143.362110039@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [105/205] virtio_net: fix oom handling on tx
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

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
@@ -566,7 +566,6 @@ static netdev_tx_t start_xmit(struct sk_
 	struct virtnet_info *vi = netdev_priv(dev);
 	int capacity;
 
-again:
 	/* Free up any pending old buffers before queueing new ones. */
 	free_old_xmit_skbs(vi);
 
@@ -575,14 +574,20 @@ again:
 
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
 


