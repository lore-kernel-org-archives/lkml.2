Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab2I1JYo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:24:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756967Ab2I1JYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:24:42 -0400
Date: Fri, 28 Sep 2012 11:26:09 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Thomas Lendacky <tahm@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Sasha Levin <levinsasha928@gmail.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 2/3] virtio-net: correct capacity math on ring full
Message-ID: <f2f7123534aefb33a7a233d9fec56de6e9eeed73.1348824232.git.mst@redhat.com>
References: <cover.1348824232.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1348824232.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Capacity math on ring full is wrong: we are
looking at num_sg but that might be optimistic
because of indirect buffer use.

The implementation also penalizes fast path
with extra memory accesses for the benefit of
ring full condition handling which is slow path.

It's easy to query ring capacity so let's do just that.

This change also makes it easier to move vnet header
for tx around as follow-up patch does.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/virtio_net.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 83d2b0c..316f1be 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -95,7 +95,6 @@ struct skb_vnet_hdr {
 		struct virtio_net_hdr hdr;
 		struct virtio_net_hdr_mrg_rxbuf mhdr;
 	};
-	unsigned int num_sg;
 };
 
 struct padded_vnet_hdr {
@@ -557,10 +556,10 @@ again:
 	return received;
 }
 
-static unsigned int free_old_xmit_skbs(struct virtnet_info *vi)
+static void free_old_xmit_skbs(struct virtnet_info *vi)
 {
 	struct sk_buff *skb;
-	unsigned int len, tot_sgs = 0;
+	unsigned int len;
 	struct virtnet_stats *stats = this_cpu_ptr(vi->stats);
 
 	while ((skb = virtqueue_get_buf(vi->svq, &len)) != NULL) {
@@ -571,16 +570,15 @@ static unsigned int free_old_xmit_skbs(struct virtnet_info *vi)
 		stats->tx_packets++;
 		u64_stats_update_end(&stats->tx_syncp);
 
-		tot_sgs += skb_vnet_hdr(skb)->num_sg;
 		dev_kfree_skb_any(skb);
 	}
-	return tot_sgs;
 }
 
 static int xmit_skb(struct virtnet_info *vi, struct sk_buff *skb)
 {
 	struct skb_vnet_hdr *hdr = skb_vnet_hdr(skb);
 	const unsigned char *dest = ((struct ethhdr *)skb->data)->h_dest;
+	unsigned num_sg;
 
 	pr_debug("%s: xmit %p %pM\n", vi->dev->name, skb, dest);
 
@@ -619,8 +617,8 @@ static int xmit_skb(struct virtnet_info *vi, struct sk_buff *skb)
 	else
 		sg_set_buf(vi->tx_sg, &hdr->hdr, sizeof hdr->hdr);
 
-	hdr->num_sg = skb_to_sgvec(skb, vi->tx_sg + 1, 0, skb->len) + 1;
-	return virtqueue_add_buf(vi->svq, vi->tx_sg, hdr->num_sg,
+	num_sg = skb_to_sgvec(skb, vi->tx_sg + 1, 0, skb->len) + 1;
+	return virtqueue_add_buf(vi->svq, vi->tx_sg, num_sg,
 				 0, skb, GFP_ATOMIC);
 }
 
@@ -664,7 +662,8 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 		netif_stop_queue(dev);
 		if (unlikely(!virtqueue_enable_cb_delayed(vi->svq))) {
 			/* More just got used, free them then recheck. */
-			capacity += free_old_xmit_skbs(vi);
+			free_old_xmit_skbs(vi);
+			capacity = virtqueue_get_capacity(vi->svq);
 			if (capacity >= 2+MAX_SKB_FRAGS) {
 				netif_start_queue(dev);
 				virtqueue_disable_cb(vi->svq);
-- 
MST

