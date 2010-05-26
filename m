Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab0EZTze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 15:55:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757028Ab0EZTzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 15:55:32 -0400
Date: Wed, 26 May 2010 22:50:42 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       qemu-devel@nongnu.org
Subject: [PATCHv2-RFC 2/2] virtio: publish used idx
Message-ID: <0a3c79049e834e6550c880dea83becb401f25bdd.1274903330.git.mst@redhat.com>
References: <cover.1274903328.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1274903328.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/virtio_net.c     |    2 ++
 drivers/virtio/virtio_ring.c |   17 +++++++++++++++--
 include/linux/virtio_ring.h  |    4 ++++
 3 files changed, 21 insertions(+), 2 deletions(-)

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
index 2241342..4a5458e 100644
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
@@ -348,6 +351,8 @@ bool virtqueue_enable_cb(struct virtqueue *_vq)
 	/* We optimistically turn back on interrupts, then check if there was
 	 * more to do. */
 	vq->vring.avail->flags &= ~VRING_AVAIL_F_NO_INTERRUPT;
+	/* Besides flags write, this barrier also flushes out
+	 * last available index write. */
 	virtio_mb();
 	if (unlikely(more_used(vq))) {
 		END_USE(vq);
@@ -425,13 +430,19 @@ struct virtqueue *vring_new_virtqueue(unsigned int num,
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
@@ -473,6 +484,8 @@ void vring_transport_features(struct virtio_device *vdev)
 		switch (i) {
 		case VIRTIO_RING_F_INDIRECT_DESC:
 			break;
+		case VIRTIO_RING_F_PUBLISH_USED:
+			break;
 		default:
 			/* We don't understand this bit. */
 			clear_bit(i, vdev->features);
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index c5f3ee7..0de35c5 100644
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
@@ -50,6 +53,7 @@ struct vring_avail {
 struct vring_avail_ctrl {
 	__u16 flags;
 	__u16 idx;
+	__u16 last_used_idx;
 };
 
 /* u32 is used here for ids for padding reasons. */
-- 
1.7.1.12.g42b7f
