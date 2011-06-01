Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933297Ab1FAJuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:50:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933277Ab1FAJua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 05:50:30 -0400
Date: Wed, 1 Jun 2011 12:49:54 +0300
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
Subject: [PATCH RFC 2/3] virtio_net: fix tx capacity checks using new API
Message-ID: <110045d5bf250e6ed9c739f8cc6adbbf54e3cc9c.1306921434.git.mst@redhat.com>
References: <cover.1306921434.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1306921434.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the (rare) case where new descriptors are used
while virtio_net enables vq callback for the TX vq,
virtio_net uses the number of sg entries in the skb it frees to
calculate how many descriptors in the ring have just been made
available.  But this value is an overestimate: with indirect buffers
each skb only uses one descriptor entry, meaning we may wake the queue
only to find we still can't transmit anything.

Using the new virtqueue_min_capacity() call, we can determine
the remaining capacity, so we should use that instead.
This estimation is worst-case which is consistent with
the value returned by virtqueue_add_buf.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/virtio_net.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index f685324..a0ee78d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -509,19 +509,17 @@ again:
 	return received;
 }
 
-static unsigned int free_old_xmit_skbs(struct virtnet_info *vi)
+static void free_old_xmit_skbs(struct virtnet_info *vi)
 {
 	struct sk_buff *skb;
-	unsigned int len, tot_sgs = 0;
+	unsigned int len;
 
 	while ((skb = virtqueue_get_buf(vi->svq, &len)) != NULL) {
 		pr_debug("Sent skb %p\n", skb);
 		vi->dev->stats.tx_bytes += skb->len;
 		vi->dev->stats.tx_packets++;
-		tot_sgs += skb_vnet_hdr(skb)->num_sg;
 		dev_kfree_skb_any(skb);
 	}
-	return tot_sgs;
 }
 
 static int xmit_skb(struct virtnet_info *vi, struct sk_buff *skb)
@@ -611,7 +609,8 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 		netif_stop_queue(dev);
 		if (unlikely(!virtqueue_enable_cb_delayed(vi->svq))) {
 			/* More just got used, free them then recheck. */
-			capacity += free_old_xmit_skbs(vi);
+			free_old_xmit_skbs(vi);
+			capacity = virtqueue_min_capacity(vi->svq);
 			if (capacity >= 2+MAX_SKB_FRAGS) {
 				netif_start_queue(dev);
 				virtqueue_disable_cb(vi->svq);
-- 
1.7.5.53.gc233e

