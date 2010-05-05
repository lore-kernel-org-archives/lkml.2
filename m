Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab0EEVCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 17:02:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116Ab0EEVCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 17:02:40 -0400
Date: Wed, 5 May 2010 23:58:14 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       qemu-devel@nongnu.org
Subject: [PATCH RFC] virtio: put last seen used index into ring itself
Message-ID: <20100505205814.GA7090@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generally, the Host end of the virtio ring doesn't need to see where
Guest is up to in consuming the ring.  However, to completely understand
what's going on from the outside, this information must be exposed.
For example, host can reduce the number of interrupts by detecting
that the guest is currently handling previous buffers.

Fortunately, we have room to expand: the ring is always a whole number
of pages and there's hundreds of bytes of padding after the avail ring
and the used ring, whatever the number of descriptors (which must be a
power of 2).

We add a feature bit so the guest can tell the host that it's writing
out the current value there, if it wants to use that.

This is based on a patch by Rusty Russell, with the main difference
being that we dedicate a feature bit to guest to tell the host it is
writing the used index.  This way we don't need to force host to publish
the last available index until we have a use for it.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Rusty,
this is a simplified form of a patch you posted in the past.
I have a vhost patch that, using this feature, shows external
to host bandwidth grow from 5 to 7 GB/s, by avoiding
an interrupt in the window after previous interrupt
was sent and before interrupts were disabled for the vq.
With vhost under some external to host loads I see
this window being hit about 30% sometimes.

I'm finalizing the host bits and plan to send
the final version for inclusion when all's ready,
but I'd like to hear comments meanwhile.

 drivers/virtio/virtio_ring.c |   28 +++++++++++++++++-----------
 include/linux/virtio_ring.h  |   14 +++++++++++++-
 2 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 1ca8890..7729aba 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -89,9 +89,6 @@ struct vring_virtqueue
 	/* Number we've added since last sync. */
 	unsigned int num_added;
 
-	/* Last used index we've seen. */
-	u16 last_used_idx;
-
 	/* How to notify other side. FIXME: commonalize hcalls! */
 	void (*notify)(struct virtqueue *vq);
 
@@ -285,12 +282,13 @@ static void detach_buf(struct vring_virtqueue *vq, unsigned int head)
 
 static inline bool more_used(const struct vring_virtqueue *vq)
 {
-	return vq->last_used_idx != vq->vring.used->idx;
+	return *vq->vring.last_used_idx != vq->vring.used->idx;
 }
 
 void *virtqueue_get_buf(struct virtqueue *_vq, unsigned int *len)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
+	struct vring_used_elem *u;
 	void *ret;
 	unsigned int i;
 
@@ -307,12 +305,13 @@ void *virtqueue_get_buf(struct virtqueue *_vq, unsigned int *len)
 		return NULL;
 	}
 
-	/* Only get used array entries after they have been exposed by host. */
-	virtio_rmb();
-
-	i = vq->vring.used->ring[vq->last_used_idx%vq->vring.num].id;
-	*len = vq->vring.used->ring[vq->last_used_idx%vq->vring.num].len;
+	/* Only get used array entries after they have been exposed by host.
+	 * Need mb(), not just rmb() because we write last_used_idx below. */
+	virtio_mb();
 
+	u = &vq->vring.used->ring[*vq->vring.last_used_idx % vq->vring.num];
+	i = u->id;
+	*len = u->len;
 	if (unlikely(i >= vq->vring.num)) {
 		BAD_RING(vq, "id %u out of range\n", i);
 		return NULL;
@@ -325,7 +324,8 @@ void *virtqueue_get_buf(struct virtqueue *_vq, unsigned int *len)
 	/* detach_buf clears data, so grab it now. */
 	ret = vq->data[i];
 	detach_buf(vq, i);
-	vq->last_used_idx++;
+	(*vq->vring.last_used_idx)++;
+
 	END_USE(vq);
 	return ret;
 }
@@ -431,7 +431,7 @@ struct virtqueue *vring_new_virtqueue(unsigned int num,
 	vq->vq.name = name;
 	vq->notify = notify;
 	vq->broken = false;
-	vq->last_used_idx = 0;
+	*vq->vring.last_used_idx = 0;
 	vq->num_added = 0;
 	list_add_tail(&vq->vq.list, &vdev->vqs);
 #ifdef DEBUG
@@ -440,6 +440,10 @@ struct virtqueue *vring_new_virtqueue(unsigned int num,
 
 	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC);
 
+	/* We publish used index whether Host offers it or not: if not, it's
+	 * junk space anyway.  But calling this acknowledges the feature. */
+	virtio_has_feature(vdev, VIRTIO_RING_F_PUBLISH_USED);
+
 	/* No callback?  Tell other side not to bother us. */
 	if (!callback)
 		vq->vring.avail->flags |= VRING_AVAIL_F_NO_INTERRUPT;
@@ -473,6 +477,8 @@ void vring_transport_features(struct virtio_device *vdev)
 		switch (i) {
 		case VIRTIO_RING_F_INDIRECT_DESC:
 			break;
+		case VIRTIO_RING_F_PUBLISH_INDICES:
+			break;
 		default:
 			/* We don't understand this bit. */
 			clear_bit(i, vdev->features);
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index e4d144b..9d01de9 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -29,6 +29,9 @@
 /* We support indirect buffer descriptors */
 #define VIRTIO_RING_F_INDIRECT_DESC	28
 
+/* The Guest publishes last-seen used index at the end of the avail ring. */
+#define VIRTIO_RING_F_PUBLISH_USED	29
+
 /* Virtio ring descriptors: 16 bytes.  These can chain together via "next". */
 struct vring_desc {
 	/* Address (guest-physical). */
@@ -69,6 +72,8 @@ struct vring {
 	struct vring_avail *avail;
 
 	struct vring_used *used;
+	/* Last used index seen by the Guest. */
+	__u16 *last_used_idx;
 };
 
 /* The standard layout for the ring is a continuous chunk of memory which looks
@@ -83,6 +88,7 @@ struct vring {
  *	__u16 avail_flags;
  *	__u16 avail_idx;
  *	__u16 available[num];
+ *	__u16 last_used_idx;
  *
  *	// Padding to the next align boundary.
  *	char pad[];
@@ -101,11 +107,17 @@ static inline void vring_init(struct vring *vr, unsigned int num, void *p,
 	vr->avail = p + num*sizeof(struct vring_desc);
 	vr->used = (void *)(((unsigned long)&vr->avail->ring[num] + align-1)
 			    & ~(align - 1));
+	/* We publish the last-seen used index at the end of the available ring.
+	 * It is at the end for backwards compatibility. */
+	vr->last_used_idx = &(vr)->avail->ring[num];
+	/* Verify that last used index does not spill over the used ring. */
+	BUG_ON((void *)vr->last_used_idx +
+	       sizeof *vr->last_used_idx > (void *)vr->used);
 }
 
 static inline unsigned vring_size(unsigned int num, unsigned long align)
 {
-	return ((sizeof(struct vring_desc) * num + sizeof(__u16) * (2 + num)
+	return ((sizeof(struct vring_desc) * num + sizeof(__u16) * (3 + num)
 		 + align - 1) & ~(align - 1))
 		+ sizeof(__u16) * 2 + sizeof(struct vring_used_elem) * num;
 }
-- 
1.7.1.12.g42b7f
