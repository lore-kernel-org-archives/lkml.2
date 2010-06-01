Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab0FAOvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 10:51:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756741Ab0FAOvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 10:51:33 -0400
Date: Tue, 1 Jun 2010 17:47:16 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       qemu-devel@nongnu.org
Subject: [PATCHv3 2/2] virtio: publish used idx
Message-ID: <4e79f8b2536f736f8104804eed23a0a95d0839e4.1275403477.git.mst@redhat.com>
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

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/virtio_net.c     |    2 ++
 drivers/virtio/virtio_ring.c |   15 +++++++++++++--
 include/linux/virtio_ring.h  |   10 ++++++++++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 78eb319..30e7483 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/virtio.h>
 #include <linux/virtio_net.h>
+#include <linux/virtio_ring.h>
 #include <linux/scatterlist.h>
 #include <linux/if_vlan.h>
 #include <linux/slab.h>
@@ -1056,6 +1057,7 @@ static unsigned int features[] = {
 	VIRTIO_NET_F_GUEST_ECN, VIRTIO_NET_F_GUEST_UFO,
 	VIRTIO_NET_F_MRG_RXBUF, VIRTIO_NET_F_STATUS, VIRTIO_NET_F_CTRL_VQ,
 	VIRTIO_NET_F_CTRL_RX, VIRTIO_NET_F_CTRL_VLAN,
+	VIRTIO_RING_F_PUBLISH_USED,
 };
 
 static struct virtio_driver virtio_net_driver = {
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 0f684b4..5a8c711 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -92,6 +92,9 @@ struct vring_virtqueue
 	/* Last used index we've seen. */
 	u16 last_used_idx;
 
+	/* Publish last used index we've seen at this location. */
+	u16 *publish_last_used_idx;
+
 	/* How to notify other side. FIXME: commonalize hcalls! */
 	void (*notify)(struct virtqueue *vq);
 
@@ -325,7 +328,7 @@ void *virtqueue_get_buf(struct virtqueue *_vq, unsigned int *len)
 	/* detach_buf clears data, so grab it now. */
 	ret = vq->data[i];
 	detach_buf(vq, i);
-	vq->last_used_idx++;
+	*vq->publish_last_used_idx = ++vq->last_used_idx;
 	END_USE(vq);
 	return ret;
 }
@@ -425,13 +428,19 @@ struct virtqueue *vring_new_virtqueue(unsigned int num,
 	if (!vq)
 		return NULL;
 
-	vring_init(&vq->vring, num, pages, vring_align, false);
+	vring_init(&vq->vring, num, pages, vring_align,
+		   virtio_has_feature(vdev, VIRTIO_RING_F_PUBLISH_USED));
+	if (virtio_has_feature(vdev, VIRTIO_RING_F_PUBLISH_USED))
+	    vq->publish_last_used_idx = &vq->vring.avail->last_used_idx;
+	else
+	    vq->publish_last_used_idx = &vq->last_used_idx;
 	vq->vq.callback = callback;
 	vq->vq.vdev = vdev;
 	vq->vq.name = name;
 	vq->notify = notify;
 	vq->broken = false;
 	vq->last_used_idx = 0;
+	*vq->publish_last_used_idx = 0;
 	vq->num_added = 0;
 	list_add_tail(&vq->vq.list, &vdev->vqs);
 #ifdef DEBUG
@@ -473,6 +482,8 @@ void vring_transport_features(struct virtio_device *vdev)
 		switch (i) {
 		case VIRTIO_RING_F_INDIRECT_DESC:
 			break;
+		case VIRTIO_RING_F_PUBLISH_USED:
+			break;
 		default:
 			/* We don't understand this bit. */
 			clear_bit(i, vdev->features);
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index 458ce41..87f8fd3 100644
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
@@ -51,6 +54,7 @@ struct vring_avail_ctrl {
 	__u16 idx;
 	__u8 pad[254];
 	__u16 flags;
+	__u16 last_used_idx;
 };
 
 /* u32 is used here for ids for padding reasons. */
@@ -75,6 +79,7 @@ struct vring {
 	__u16 *avail_idx;
 	__u16 *avail_flags;
 	__u16 *avail_ring;
+	__u16 *last_used_idx;
 
 	struct vring_used *used;
 };
@@ -100,6 +105,7 @@ struct vring {
  *	__u16 avail_idx;
  *	__u8 pad[254]; // Padding to align flags at cache line boundary.
  *	__u16 avail_flags;
+ *	__u16 last_used_idx;
  *	// Padding to the next align boundary.
  *	char pad[];
  *
@@ -120,14 +126,18 @@ static inline void vring_init(struct vring *vr, unsigned int num, void *p,
 		vr->avail_ring = (void*)avail;
 		vr->avail_idx = &ctrl->idx;
 		vr->avail_flags = &ctrl->flags;
+		vr->last_used_idx = &ctrl->last_used_idx;
 	} else {
 		vr->avail_idx = &avail->idx;
 		vr->avail_flags = &avail->flags;
+		vr->last_used_idx = NULL;
 	}
 	vr->used = (void *)ALIGN((unsigned long)&avail->ring[num], align);
 	/* Verify that avail fits before used. */
 	BUG_ON((unsigned long)(vr->avail_flags + 1) > (unsigned long)vr->used);
 	BUG_ON((unsigned long)(vr->avail_idx + 1) > (unsigned long)vr->used);
+	BUG_ON(vr->last_used_idx && (unsigned long)(vr->last_used_idx + 1) >
+	       (unsigned long)vr->used);
 	BUG_ON((unsigned long)(&vr->avail_ring[num]) > (unsigned long)vr->used);
 }
 
-- 
1.7.1.12.g42b7f
