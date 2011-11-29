Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab1K2Jeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 04:34:36 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47973 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab1K2Jee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 04:34:34 -0500
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: [PATCH] virtio-ring: Use threshold for switching to indirect descriptors
Date: Tue, 29 Nov 2011 11:33:16 +0200
Message-Id: <1322559196-11139-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently if VIRTIO_RING_F_INDIRECT_DESC is enabled we will use indirect
descriptors even if we have plenty of space in the ring. This means that
we take a performance hit at all times due to the overhead of creating
indirect descriptors.

With this patch, we will use indirect descriptors only if we have less than
either 16, or 12% of the total amount of descriptors available.

I did basic performance benchmark on virtio-net with vhost enabled.

Before:
	Recv   Send    Send
	Socket Socket  Message  Elapsed
	Size   Size    Size     Time     Throughput
	bytes  bytes   bytes    secs.    10^6bits/sec

	 87380  16384  16384    10.00    4563.92

After:
	Recv   Send    Send
	Socket Socket  Message  Elapsed
	Size   Size    Size     Time     Throughput
	bytes  bytes   bytes    secs.    10^6bits/sec

	 87380  16384  16384    10.00    5353.28

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org
Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 drivers/virtio/virtio_ring.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index c7a2c20..5e0ce15 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -82,6 +82,7 @@ struct vring_virtqueue
 
 	/* Host supports indirect buffers */
 	bool indirect;
+	unsigned int indirect_threshold;
 
 	/* Host publishes avail event idx */
 	bool event;
@@ -176,8 +177,9 @@ int virtqueue_add_buf_gfp(struct virtqueue *_vq,
 	BUG_ON(data == NULL);
 
 	/* If the host supports indirect descriptor tables, and we have multiple
-	 * buffers, then go indirect. FIXME: tune this threshold */
-	if (vq->indirect && (out + in) > 1 && vq->num_free) {
+	 * buffers, then go indirect. */
+	if (vq->indirect && (out + in) > 1 &&
+	   (vq->num_free < vq->indirect_threshold)) {
 		head = vring_add_indirect(vq, sg, out, in, gfp);
 		if (likely(head >= 0))
 			goto add_head;
@@ -485,6 +487,12 @@ struct virtqueue *vring_new_virtqueue(unsigned int num,
 #endif
 
 	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC);
+	/*
+	 * Use indirect descriptors only when we have less than either 12%
+	 * or 16 of the descriptors in the ring available.
+	 */
+	if (vq->indirect)
+		vq->indirect_threshold = max(16U, num >> 3);
 	vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
 
 	/* No callback?  Tell other side not to bother us. */
-- 
1.7.8.rc3

