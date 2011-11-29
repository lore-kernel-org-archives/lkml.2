Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab1K2Mc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 07:32:26 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63428 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab1K2McY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 07:32:24 -0500
From: Ohad Ben-Cohen <ohad@wizery.com>
To: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [RFC] virtio: use mandatory barriers for remote processor vdevs
Date: Tue, 29 Nov 2011 14:31:26 +0200
Message-Id: <1322569886-13055-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Virtio is using memory barriers to control the ordering of
references to the vrings on SMP systems. When the guest is compiled
with SMP support, virtio is only using SMP barriers in order to
avoid incurring the overhead involved with mandatory barriers.

Lately, though, virtio is being increasingly used with inter-processor
communication scenarios too, which involve running two (separate)
instances of operating systems on two (separate) processors, each of
which might either be UP or SMP.

To control the ordering of memory references when the vrings are shared
between two external processors, we must always use mandatory barriers.

A trivial, albeit sub-optimal, solution would be to simply revert
commit d57ed95 "virtio: use smp_XX barriers on SMP". Obviously, though,
that's going to have a negative impact on performance of SMP-based
virtualization use cases.

A different approach, as demonstrated by this patch, would pick the type
of memory barriers, in run time, according to the requirements of the
virtio device. This way, both SMP virtualization scenarios and inter-
processor communication use cases would run correctly, without making
any performance compromises (except for those incurred by an additional
branch or level of indirection).

This patch introduces VIRTIO_RING_F_REMOTEPROC, a new virtio transport
feature, which should be used by virtio devices that run on remote
processors. The CONFIG_SMP variant of virtio_{mb, rmb, wmb} is then changed
to use SMP barriers only if VIRTIO_RING_F_REMOTEPROC was absent.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
Alternatively, we can also introduce some kind of virtio_mb_ops and set it
according to the nature of the vdev with handlers that just do the right
thing, instead of introducting that branch.

Though I also wonder how big really is the perforamnce gain of d57ed95 ?

 drivers/virtio/virtio_ring.c |   78 +++++++++++++++++++++++++++++-------------
 include/linux/virtio_ring.h  |    6 +++
 2 files changed, 60 insertions(+), 24 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index c7a2c20..cf66a2d 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -23,24 +23,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 
-/* virtio guest is communicating with a virtual "device" that actually runs on
- * a host processor.  Memory barriers are used to control SMP effects. */
-#ifdef CONFIG_SMP
-/* Where possible, use SMP barriers which are more lightweight than mandatory
- * barriers, because mandatory barriers control MMIO effects on accesses
- * through relaxed memory I/O windows (which virtio does not use). */
-#define virtio_mb() smp_mb()
-#define virtio_rmb() smp_rmb()
-#define virtio_wmb() smp_wmb()
-#else
-/* We must force memory ordering even if guest is UP since host could be
- * running on another CPU, but SMP barriers are defined to barrier() in that
- * configuration. So fall back to mandatory barriers instead. */
-#define virtio_mb() mb()
-#define virtio_rmb() rmb()
-#define virtio_wmb() wmb()
-#endif
-
 #ifdef DEBUG
 /* For development, we want to crash whenever the ring is screwed. */
 #define BAD_RING(_vq, fmt, args...)				\
@@ -86,6 +68,9 @@ struct vring_virtqueue
 	/* Host publishes avail event idx */
 	bool event;
 
+	/* Host runs on a remote processor */
+	bool rproc;
+
 	/* Number of free buffers */
 	unsigned int num_free;
 	/* Head of free buffer list. */
@@ -108,6 +93,48 @@ struct vring_virtqueue
 	void *data[];
 };
 
+/*
+ * virtio guest is communicating with a virtual "device" that may either run
+ * on the host processor, or on an external processor. The former requires
+ * memory barriers in order to control SMP effects, but the latter must
+ * use mandatory barriers.
+ */
+#ifdef CONFIG_SMP
+/* Where possible, use SMP barriers which are more lightweight than mandatory
+ * barriers, because mandatory barriers control MMIO effects on accesses
+ * through relaxed memory I/O windows. */
+static inline void virtio_mb(struct vring_virtqueue *vq)
+{
+	if (vq->rproc)
+		mb();
+	else
+		smp_mb();
+}
+
+static inline void virtio_rmb(struct vring_virtqueue *vq)
+{
+	if (vq->rproc)
+		rmb();
+	else
+		smp_rmb();
+}
+
+static inline void virtio_wmb(struct vring_virtqueue *vq)
+{
+	if (vq->rproc)
+		wmb();
+	else
+		smp_wmb();
+}
+#else
+/* We must force memory ordering even if guest is UP since host could be
+ * running on another CPU, but SMP barriers are defined to barrier() in that
+ * configuration. So fall back to mandatory barriers instead. */
+static inline void virtio_mb(struct vring_virtqueue *vq) { mb(); }
+static inline void virtio_rmb(struct vring_virtqueue *vq) { rmb(); }
+static inline void virtio_wmb(struct vring_virtqueue *vq) { wmb(); }
+#endif
+
 #define to_vvq(_vq) container_of(_vq, struct vring_virtqueue, vq)
 
 /* Set up an indirect table of descriptors and add it to the queue. */
@@ -245,14 +272,14 @@ void virtqueue_kick(struct virtqueue *_vq)
 	START_USE(vq);
 	/* Descriptors and available array need to be set before we expose the
 	 * new available array entries. */
-	virtio_wmb();
+	virtio_wmb(vq);
 
 	old = vq->vring.avail->idx;
 	new = vq->vring.avail->idx = old + vq->num_added;
 	vq->num_added = 0;
 
 	/* Need to update avail index before checking if we should notify */
-	virtio_mb();
+	virtio_mb(vq);
 
 	if (vq->event ?
 	    vring_need_event(vring_avail_event(&vq->vring), new, old) :
@@ -314,7 +341,7 @@ void *virtqueue_get_buf(struct virtqueue *_vq, unsigned int *len)
 	}
 
 	/* Only get used array entries after they have been exposed by host. */
-	virtio_rmb();
+	virtio_rmb(vq);
 
 	i = vq->vring.used->ring[vq->last_used_idx%vq->vring.num].id;
 	*len = vq->vring.used->ring[vq->last_used_idx%vq->vring.num].len;
@@ -337,7 +364,7 @@ void *virtqueue_get_buf(struct virtqueue *_vq, unsigned int *len)
 	 * the read in the next get_buf call. */
 	if (!(vq->vring.avail->flags & VRING_AVAIL_F_NO_INTERRUPT)) {
 		vring_used_event(&vq->vring) = vq->last_used_idx;
-		virtio_mb();
+		virtio_mb(vq);
 	}
 
 	END_USE(vq);
@@ -366,7 +393,7 @@ bool virtqueue_enable_cb(struct virtqueue *_vq)
 	 * entry. Always do both to keep code simple. */
 	vq->vring.avail->flags &= ~VRING_AVAIL_F_NO_INTERRUPT;
 	vring_used_event(&vq->vring) = vq->last_used_idx;
-	virtio_mb();
+	virtio_mb(vq);
 	if (unlikely(more_used(vq))) {
 		END_USE(vq);
 		return false;
@@ -393,7 +420,7 @@ bool virtqueue_enable_cb_delayed(struct virtqueue *_vq)
 	/* TODO: tune this threshold */
 	bufs = (u16)(vq->vring.avail->idx - vq->last_used_idx) * 3 / 4;
 	vring_used_event(&vq->vring) = vq->last_used_idx + bufs;
-	virtio_mb();
+	virtio_mb(vq);
 	if (unlikely((u16)(vq->vring.used->idx - vq->last_used_idx) > bufs)) {
 		END_USE(vq);
 		return false;
@@ -486,6 +513,7 @@ struct virtqueue *vring_new_virtqueue(unsigned int num,
 
 	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC);
 	vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
+	vq->rproc = virtio_has_feature(vdev, VIRTIO_RING_F_REMOTEPROC);
 
 	/* No callback?  Tell other side not to bother us. */
 	if (!callback)
@@ -522,6 +550,8 @@ void vring_transport_features(struct virtio_device *vdev)
 			break;
 		case VIRTIO_RING_F_EVENT_IDX:
 			break;
+		case VIRTIO_RING_F_REMOTEPROC:
+			break;
 		default:
 			/* We don't understand this bit. */
 			clear_bit(i, vdev->features);
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index 36be0f6..9839593 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -58,6 +58,12 @@
  * at the end of the used ring. Guest should ignore the used->flags field. */
 #define VIRTIO_RING_F_EVENT_IDX		29
 
+/*
+ * The device we're talking to resides on a remote processor, so we must always
+ * use mandatory memory barriers.
+ */
+#define VIRTIO_RING_F_REMOTEPROC	30
+
 /* Virtio ring descriptors: 16 bytes.  These can chain together via "next". */
 struct vring_desc {
 	/* Address (guest-physical). */
-- 
1.7.5.4

