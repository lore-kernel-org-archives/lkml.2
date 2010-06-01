Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab0FAOvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 10:51:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756684Ab0FAOvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 10:51:31 -0400
Date: Tue, 1 Jun 2010 17:47:12 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       qemu-devel@nongnu.org
Subject: [PATCHv3 1/2] virtio: support layout with avail ring before idx
Message-ID: <10a74b58c908bad64ff890c881e2b2de88687f0e.1275403477.git.mst@redhat.com>
References: <cover.1275403477.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1275403477.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds an (unused) option to put available ring before control (avail
index, flags), and adds padding between index and flags. This avoids
cache line sharing between control and ring, and also makes it possible
to extend avail control without incurring extra cache misses.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_ring.c |   12 ++++++------
 include/linux/virtio_ring.h  |   40 ++++++++++++++++++++++++++++++++++------
 2 files changed, 40 insertions(+), 12 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 1ca8890..0f684b4 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -223,8 +223,8 @@ add_head:
 
 	/* Put entry in available array (but don't update avail->idx until they
 	 * do sync).  FIXME: avoid modulus here? */
-	avail = (vq->vring.avail->idx + vq->num_added++) % vq->vring.num;
-	vq->vring.avail->ring[avail] = head;
+	avail = (*vq->vring.avail_idx + vq->num_added++) % vq->vring.num;
+	vq->vring.avail_ring[avail] = head;
 
 	pr_debug("Added buffer head %i to %p\n", head, vq);
 	END_USE(vq);
@@ -244,7 +244,7 @@ void virtqueue_kick(struct virtqueue *_vq)
 	 * new available array entries. */
 	virtio_wmb();
 
-	vq->vring.avail->idx += vq->num_added;
+	*vq->vring.avail_idx += vq->num_added;
 	vq->num_added = 0;
 
 	/* Need to update avail index before checking if we should notify */
@@ -335,7 +335,7 @@ void virtqueue_disable_cb(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
-	vq->vring.avail->flags |= VRING_AVAIL_F_NO_INTERRUPT;
+	*vq->vring.avail_flags |= VRING_AVAIL_F_NO_INTERRUPT;
 }
 EXPORT_SYMBOL_GPL(virtqueue_disable_cb);
 
@@ -347,7 +347,7 @@ bool virtqueue_enable_cb(struct virtqueue *_vq)
 
 	/* We optimistically turn back on interrupts, then check if there was
 	 * more to do. */
-	vq->vring.avail->flags &= ~VRING_AVAIL_F_NO_INTERRUPT;
+	vq->vring.avail_flags &= ~VRING_AVAIL_F_NO_INTERRUPT;
 	virtio_mb();
 	if (unlikely(more_used(vq))) {
 		END_USE(vq);
@@ -425,7 +425,7 @@ struct virtqueue *vring_new_virtqueue(unsigned int num,
 	if (!vq)
 		return NULL;
 
-	vring_init(&vq->vring, num, pages, vring_align);
+	vring_init(&vq->vring, num, pages, vring_align, false);
 	vq->vq.callback = callback;
 	vq->vq.vdev = vdev;
 	vq->vq.name = name;
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index e4d144b..458ce41 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -47,6 +47,12 @@ struct vring_avail {
 	__u16 ring[];
 };
 
+struct vring_avail_ctrl {
+	__u16 idx;
+	__u8 pad[254];
+	__u16 flags;
+};
+
 /* u32 is used here for ids for padding reasons. */
 struct vring_used_elem {
 	/* Index of start of used descriptor chain. */
@@ -66,7 +72,9 @@ struct vring {
 
 	struct vring_desc *desc;
 
-	struct vring_avail *avail;
+	__u16 *avail_idx;
+	__u16 *avail_flags;
+	__u16 *avail_ring;
 
 	struct vring_used *used;
 };
@@ -79,11 +87,19 @@ struct vring {
  *	// The actual descriptors (16 bytes each)
  *	struct vring_desc desc[num];
  *
- *	// A ring of available descriptor heads with free-running index.
+ *	// A ring of available descriptor heads with a control structure
+ *      // including a free-running index.
+ *      // The ring can come either after  (legacy) or before the control.
  *	__u16 avail_flags;
  *	__u16 avail_idx;
  *	__u16 available[num];
  *
+ * or
+ *
+ *	__u16 available[num];
+ *	__u16 avail_idx;
+ *	__u8 pad[254]; // Padding to align flags at cache line boundary.
+ *	__u16 avail_flags;
  *	// Padding to the next align boundary.
  *	char pad[];
  *
@@ -94,13 +110,25 @@ struct vring {
  * };
  */
 static inline void vring_init(struct vring *vr, unsigned int num, void *p,
-			      unsigned long align)
+			      unsigned long align, bool avail_ring_first)
 {
+	struct vring_avail *avail = p + num * sizeof(struct vring_desc);
 	vr->num = num;
 	vr->desc = p;
-	vr->avail = p + num*sizeof(struct vring_desc);
-	vr->used = (void *)(((unsigned long)&vr->avail->ring[num] + align-1)
-			    & ~(align - 1));
+	if (avail_ring_first) {
+		struct vring_avail_ctrl *ctrl = (void *)&vr->avail_ring[num];
+		vr->avail_ring = (void*)avail;
+		vr->avail_idx = &ctrl->idx;
+		vr->avail_flags = &ctrl->flags;
+	} else {
+		vr->avail_idx = &avail->idx;
+		vr->avail_flags = &avail->flags;
+	}
+	vr->used = (void *)ALIGN((unsigned long)&avail->ring[num], align);
+	/* Verify that avail fits before used. */
+	BUG_ON((unsigned long)(vr->avail_flags + 1) > (unsigned long)vr->used);
+	BUG_ON((unsigned long)(vr->avail_idx + 1) > (unsigned long)vr->used);
+	BUG_ON((unsigned long)(&vr->avail_ring[num]) > (unsigned long)vr->used);
 }
 
 static inline unsigned vring_size(unsigned int num, unsigned long align)
-- 
1.7.1.12.g42b7f

