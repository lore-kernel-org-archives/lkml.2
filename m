Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab1KCHox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 03:44:53 -0400
Received: from ozlabs.org ([203.10.76.45]:43927 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215Ab1KCHnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 03:43:49 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 5] virtio: rename virtqueue_add_buf_gfp to
 virtqueue_add_buf
X-Mercurial-Node: 07aa6e8fcfc2bcba854e1f130546c23f7d0f072c
Message-Id: <07aa6e8fcfc2bcba854e.1320306170@localhost6.localdomain6>
In-Reply-To: <patchbomb.1320306168@localhost6.localdomain6>
References: <patchbomb.1320306168@localhost6.localdomain6>
User-Agent: Mercurial-patchbomb/1.9.1
Date: Thu, 03 Nov 2011 18:12:50 +1030
From: Rusty Russell <rusty@rustcorp.com.au>
To: MichaelS.Tsirkist@redhat.com, Christoph Hellwig <hch@infradead.org>
Cc: virtualization <virtualization@lists.linux-foundation.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove wrapper functions. This makes the allocation type explicit in
all callers; I used GPF_KERNEL where it seemed obvious, left it at
GFP_ATOMIC otherwise.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -171,7 +171,7 @@ static bool do_req(struct request_queue 
 		}
 	}
 
-	if (virtqueue_add_buf(vblk->vq, vblk->sg, out, in, vbr) < 0) {
+	if (virtqueue_add_buf(vblk->vq, vblk->sg, out, in, vbr, GFP_ATOMIC)<0) {
 		mempool_free(vbr, vblk->pool);
 		return false;
 	}
diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -46,7 +46,7 @@ static void register_buffer(u8 *buf, siz
 	sg_init_one(&sg, buf, size);
 
 	/* There should always be room for one buffer. */
-	if (virtqueue_add_buf(vq, &sg, 0, 1, buf) < 0)
+	if (virtqueue_add_buf(vq, &sg, 0, 1, buf, GFP_KERNEL) < 0)
 		BUG();
 
 	virtqueue_kick(vq);
diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -391,7 +391,7 @@ static int add_inbuf(struct virtqueue *v
 
 	sg_init_one(sg, buf->buf, buf->size);
 
-	ret = virtqueue_add_buf(vq, sg, 0, 1, buf);
+	ret = virtqueue_add_buf(vq, sg, 0, 1, buf, GFP_ATOMIC);
 	virtqueue_kick(vq);
 	return ret;
 }
@@ -456,7 +456,7 @@ static ssize_t __send_control_msg(struct
 	vq = portdev->c_ovq;
 
 	sg_init_one(sg, &cpkt, sizeof(cpkt));
-	if (virtqueue_add_buf(vq, sg, 1, 0, &cpkt) >= 0) {
+	if (virtqueue_add_buf(vq, sg, 1, 0, &cpkt, GFP_ATOMIC) >= 0) {
 		virtqueue_kick(vq);
 		while (!virtqueue_get_buf(vq, &len))
 			cpu_relax();
@@ -505,7 +505,7 @@ static ssize_t send_buf(struct port *por
 	reclaim_consumed_buffers(port);
 
 	sg_init_one(sg, in_buf, in_count);
-	ret = virtqueue_add_buf(out_vq, sg, 1, 0, in_buf);
+	ret = virtqueue_add_buf(out_vq, sg, 1, 0, in_buf, GFP_ATOMIC);
 
 	/* Tell Host to go! */
 	virtqueue_kick(out_vq);
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -368,7 +368,7 @@ static int add_recvbuf_small(struct virt
 
 	skb_to_sgvec(skb, vi->rx_sg + 1, 0, skb->len);
 
-	err = virtqueue_add_buf_gfp(vi->rvq, vi->rx_sg, 0, 2, skb, gfp);
+	err = virtqueue_add_buf(vi->rvq, vi->rx_sg, 0, 2, skb, gfp);
 	if (err < 0)
 		dev_kfree_skb(skb);
 
@@ -413,8 +413,8 @@ static int add_recvbuf_big(struct virtne
 
 	/* chain first in list head */
 	first->private = (unsigned long)list;
-	err = virtqueue_add_buf_gfp(vi->rvq, vi->rx_sg, 0, MAX_SKB_FRAGS + 2,
-				    first, gfp);
+	err = virtqueue_add_buf(vi->rvq, vi->rx_sg, 0, MAX_SKB_FRAGS + 2,
+				first, gfp);
 	if (err < 0)
 		give_pages(vi, first);
 
@@ -432,7 +432,7 @@ static int add_recvbuf_mergeable(struct 
 
 	sg_init_one(vi->rx_sg, page_address(page), PAGE_SIZE);
 
-	err = virtqueue_add_buf_gfp(vi->rvq, vi->rx_sg, 0, 1, page, gfp);
+	err = virtqueue_add_buf(vi->rvq, vi->rx_sg, 0, 1, page, gfp);
 	if (err < 0)
 		give_pages(vi, page);
 
@@ -601,7 +601,7 @@ static int xmit_skb(struct virtnet_info 
 
 	hdr->num_sg = skb_to_sgvec(skb, vi->tx_sg + 1, 0, skb->len) + 1;
 	return virtqueue_add_buf(vi->svq, vi->tx_sg, hdr->num_sg,
-					0, skb);
+				 0, skb, GFP_ATOMIC);
 }
 
 static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
@@ -754,7 +754,7 @@ static bool virtnet_send_command(struct 
 		sg_set_buf(&sg[i + 1], sg_virt(s), s->length);
 	sg_set_buf(&sg[out + in - 1], &status, sizeof(status));
 
-	BUG_ON(virtqueue_add_buf(vi->cvq, sg, out, in, vi) < 0);
+	BUG_ON(virtqueue_add_buf(vi->cvq, sg, out, in, vi, GFP_ATOMIC) < 0);
 
 	virtqueue_kick(vi->cvq);
 
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -86,7 +86,7 @@ static void tell_host(struct virtio_ball
 	init_completion(&vb->acked);
 
 	/* We should always be able to add one buffer to an empty queue. */
-	if (virtqueue_add_buf(vq, &sg, 1, 0, vb) < 0)
+	if (virtqueue_add_buf(vq, &sg, 1, 0, vb, GFP_KERNEL) < 0)
 		BUG();
 	virtqueue_kick(vq);
 
@@ -219,7 +219,7 @@ static void stats_handle_request(struct 
 
 	vq = vb->stats_vq;
 	sg_init_one(&sg, vb->stats, sizeof(vb->stats));
-	if (virtqueue_add_buf(vq, &sg, 1, 0, vb) < 0)
+	if (virtqueue_add_buf(vq, &sg, 1, 0, vb, GFP_KERNEL) < 0)
 		BUG();
 	virtqueue_kick(vq);
 }
@@ -312,7 +312,8 @@ static int virtballoon_probe(struct virt
 		 * use it to signal us later.
 		 */
 		sg_init_one(&sg, vb->stats, sizeof vb->stats);
-		if (virtqueue_add_buf(vb->stats_vq, &sg, 1, 0, vb) < 0)
+		if (virtqueue_add_buf(vb->stats_vq, &sg, 1, 0, vb, GFP_KERNEL)
+		    < 0)
 			BUG();
 		virtqueue_kick(vb->stats_vq);
 	}
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -159,12 +159,12 @@ static int vring_add_indirect(struct vri
 	return head;
 }
 
-int virtqueue_add_buf_gfp(struct virtqueue *_vq,
-			  struct scatterlist sg[],
-			  unsigned int out,
-			  unsigned int in,
-			  void *data,
-			  gfp_t gfp)
+int virtqueue_add_buf(struct virtqueue *_vq,
+		      struct scatterlist sg[],
+		      unsigned int out,
+		      unsigned int in,
+		      void *data,
+		      gfp_t gfp)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 	unsigned int i, avail, uninitialized_var(prev);
@@ -235,7 +235,7 @@ add_head:
 
 	return vq->num_free;
 }
-EXPORT_SYMBOL_GPL(virtqueue_add_buf_gfp);
+EXPORT_SYMBOL_GPL(virtqueue_add_buf);
 
 void virtqueue_kick(struct virtqueue *_vq)
 {
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -26,7 +26,7 @@ struct virtqueue {
 };
 
 /**
- * virtqueue_add_buf_gfp - expose buffer to other end
+ * virtqueue_add_buf - expose buffer to other end
  * @vq: the struct virtqueue we're talking about.
  * @sg: the description of the buffer(s).
  * @out_num: the number of sg readable by other side
@@ -42,27 +42,18 @@ struct virtqueue {
  * positive return values as "available": indirect buffers mean that
  * we can put an entire sg[] array inside a single queue entry.
  */
-int virtqueue_add_buf_gfp(struct virtqueue *vq,
-			  struct scatterlist sg[],
-			  unsigned int out_num,
-			  unsigned int in_num,
-			  void *data,
-			  gfp_t gfp);
-
-static inline int virtqueue_add_buf(struct virtqueue *vq,
-				    struct scatterlist sg[],
-				    unsigned int out_num,
-				    unsigned int in_num,
-				    void *data)
-{
-	return virtqueue_add_buf_gfp(vq, sg, out_num, in_num, data, GFP_ATOMIC);
-}
+int virtqueue_add_buf(struct virtqueue *vq,
+		      struct scatterlist sg[],
+		      unsigned int out_num,
+		      unsigned int in_num,
+		      void *data,
+		      gfp_t gfp);
 
 /**
  * virtqueue_kick - update after add_buf
  * @vq: the struct virtqueue
  *
- * After one or more virtqueue_add_buf_gfp calls, invoke this to kick
+ * After one or more virtqueue_add_buf calls, invoke this to kick
  * the other side.
  *
  * Caller must ensure we don't call this with other virtqueue
@@ -84,7 +75,7 @@ void virtqueue_kick(struct virtqueue *vq
  * operations at the same time (except where noted).
  *
  * Returns NULL if there are no used buffers, or the "data" token
- * handed to virtqueue_add_buf_gfp().
+ * handed to virtqueue_add_buf().
  */
 void *virtqueue_get_buf(struct virtqueue *vq, unsigned int *len);
 
@@ -131,7 +122,7 @@ bool virtqueue_enable_cb_delayed(struct 
  * virtqueue_detach_unused_buf - detach first unused buffer
  * @vq: the struct virtqueue we're talking about.
  *
- * Returns NULL or the "data" token handed to virtqueue_add_buf_gfp().
+ * Returns NULL or the "data" token handed to virtqueue_add_buf().
  * This is not valid on an active queue; it is useful only for device
  * shutdown.
  */
diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -270,7 +270,8 @@ req_retry:
 	in = pack_sg_list(chan->sg, out,
 			  VIRTQUEUE_NUM, req->rc->sdata, req->rc->capacity);
 
-	err = virtqueue_add_buf(chan->vq, chan->sg, out, in, req->tc);
+	err = virtqueue_add_buf(chan->vq, chan->sg, out, in, req->tc,
+				GFP_ATOMIC);
 	if (err < 0) {
 		if (err == -ENOSPC) {
 			chan->ring_bufs_avail = 0;
@@ -413,7 +414,8 @@ req_retry_pinned:
 		in += pack_sg_list_p(chan->sg, out + in, VIRTQUEUE_NUM,
 				     in_pages, in_nr_pages, uidata, inlen);
 
-	err = virtqueue_add_buf(chan->vq, chan->sg, out, in, req->tc);
+	err = virtqueue_add_buf(chan->vq, chan->sg, out, in, req->tc,
+				GFP_ATOMIC);
 	if (err < 0) {
 		if (err == -ENOSPC) {
 			chan->ring_bufs_avail = 0;
diff --git a/tools/virtio/linux/virtio.h b/tools/virtio/linux/virtio.h
--- a/tools/virtio/linux/virtio.h
+++ b/tools/virtio/linux/virtio.h
@@ -186,21 +186,12 @@ struct virtqueue {
 #endif
 
 /* Interfaces exported by virtio_ring. */
-int virtqueue_add_buf_gfp(struct virtqueue *vq,
-			  struct scatterlist sg[],
-			  unsigned int out_num,
-			  unsigned int in_num,
-			  void *data,
-			  gfp_t gfp);
-
-static inline int virtqueue_add_buf(struct virtqueue *vq,
-				    struct scatterlist sg[],
-				    unsigned int out_num,
-				    unsigned int in_num,
-				    void *data)
-{
-	return virtqueue_add_buf_gfp(vq, sg, out_num, in_num, data, GFP_ATOMIC);
-}
+int virtqueue_add_buf(struct virtqueue *vq,
+		      struct scatterlist sg[],
+		      unsigned int out_num,
+		      unsigned int in_num,
+		      void *data,
+		      gfp_t gfp);
 
 void virtqueue_kick(struct virtqueue *vq);
 
diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -160,7 +160,8 @@ static void run_test(struct vdev_info *d
 			if (started < bufs) {
 				sg_init_one(&sl, dev->buf, dev->buf_size);
 				r = virtqueue_add_buf(vq->vq, &sl, 1, 0,
-						      dev->buf + started);
+						      dev->buf + started,
+						      GFP_ATOMIC);
 				if (likely(r >= 0)) {
 					++started;
 					virtqueue_kick(vq->vq);


