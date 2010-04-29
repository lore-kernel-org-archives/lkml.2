Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399Ab0D3TQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:16:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758049Ab0D3QzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:55:18 -0400
Date: Thu, 29 Apr 2010 17:26:37 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
       "Michael S. Tsirkin" <mst@redhat.com>, Amit Shah <amit.shah@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, Tejun Heo <tj@kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>, Shirley Ma <xma@us.ibm.com>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] virtio: add_buf_gfp
Message-ID: <a64fe25ad86b0850dba9485241e39c3c2b8d175f.1272549642.git.mst@redhat.com>
References: <cover.1272549641.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1272549641.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an add_buf variant that gets gfp parameter. Use that
to allocate indirect buffers.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_ring.c |   20 +++++++++++---------
 include/linux/virtio.h       |   22 +++++++++++++++++-----
 2 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 0717b5b..1ca8890 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -110,13 +110,14 @@ struct vring_virtqueue
 static int vring_add_indirect(struct vring_virtqueue *vq,
 			      struct scatterlist sg[],
 			      unsigned int out,
-			      unsigned int in)
+			      unsigned int in,
+			      gfp_t gfp)
 {
 	struct vring_desc *desc;
 	unsigned head;
 	int i;
 
-	desc = kmalloc((out + in) * sizeof(struct vring_desc), GFP_ATOMIC);
+	desc = kmalloc((out + in) * sizeof(struct vring_desc), gfp);
 	if (!desc)
 		return vq->vring.num;
 
@@ -155,11 +156,12 @@ static int vring_add_indirect(struct vring_virtqueue *vq,
 	return head;
 }
 
-int virtqueue_add_buf(struct virtqueue *_vq,
-		  struct scatterlist sg[],
-		  unsigned int out,
-		  unsigned int in,
-		  void *data)
+int virtqueue_add_buf_gfp(struct virtqueue *_vq,
+			  struct scatterlist sg[],
+			  unsigned int out,
+			  unsigned int in,
+			  void *data,
+			  gfp_t gfp)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 	unsigned int i, avail, head, uninitialized_var(prev);
@@ -171,7 +173,7 @@ int virtqueue_add_buf(struct virtqueue *_vq,
 	/* If the host supports indirect descriptor tables, and we have multiple
 	 * buffers, then go indirect. FIXME: tune this threshold */
 	if (vq->indirect && (out + in) > 1 && vq->num_free) {
-		head = vring_add_indirect(vq, sg, out, in);
+		head = vring_add_indirect(vq, sg, out, in, gfp);
 		if (head != vq->vring.num)
 			goto add_head;
 	}
@@ -232,7 +234,7 @@ add_head:
 		return vq->num_free ? vq->vring.num : 0;
 	return vq->num_free;
 }
-EXPORT_SYMBOL_GPL(virtqueue_add_buf);
+EXPORT_SYMBOL_GPL(virtqueue_add_buf_gfp);
 
 void virtqueue_kick(struct virtqueue *_vq)
 {
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 5b0fce0..aff5b4f 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -7,6 +7,7 @@
 #include <linux/spinlock.h>
 #include <linux/device.h>
 #include <linux/mod_devicetable.h>
+#include <linux/gfp.h>
 
 /**
  * virtqueue - a queue to register buffers for sending or receiving.
@@ -32,6 +33,7 @@ struct virtqueue {
  *	out_num: the number of sg readable by other side
  *	in_num: the number of sg which are writable (after readable ones)
  *	data: the token identifying the buffer.
+ *	gfp: how to do memory allocations (if necessary).
  *      Returns remaining capacity of queue (sg segments) or a negative error.
  * virtqueue_kick: update after add_buf
  *	vq: the struct virtqueue
@@ -60,11 +62,21 @@ struct virtqueue {
  * All operations can be called in any context.
  */
 
-int virtqueue_add_buf(struct virtqueue *vq,
-		      struct scatterlist sg[],
-		      unsigned int out_num,
-		      unsigned int in_num,
-		      void *data);
+int virtqueue_add_buf_gfp(struct virtqueue *vq,
+			  struct scatterlist sg[],
+			  unsigned int out_num,
+			  unsigned int in_num,
+			  void *data,
+			  gfp_t gfp);
+
+static inline int virtqueue_add_buf(struct virtqueue *vq,
+				    struct scatterlist sg[],
+				    unsigned int out_num,
+				    unsigned int in_num,
+				    void *data)
+{
+	return virtqueue_add_buf_gfp(vq, sg, out_num, in_num, data, GFP_ATOMIC);
+}
 
 void virtqueue_kick(struct virtqueue *vq);
 
-- 
1.7.1.rc1.22.g3163

