Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab2H1NDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 09:03:51 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42049 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab2H1NDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 09:03:49 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: rusty@rustcorp.com.au, mst@redhat.com
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        avi@redhat.com, kvm@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH v2 1/2] virtio-ring: Use threshold for switching to indirect descriptors
Date: Tue, 28 Aug 2012 15:04:02 +0200
Message-Id: <1346159043-16446-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently if VIRTIO_RING_F_INDIRECT_DESC is enabled we will use indirect
descriptors even if we have plenty of space in the ring. This means that
we take a performance hit at all times due to the overhead of creating
indirect descriptors.

Instead, use it only after we're below a configurable offset.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 drivers/block/virtio_blk.c          |  4 ++++
 drivers/char/hw_random/virtio-rng.c |  4 ++++
 drivers/char/virtio_console.c       |  4 ++++
 drivers/net/virtio_net.c            |  4 ++++
 drivers/virtio/virtio_balloon.c     |  4 ++++
 drivers/virtio/virtio_ring.c        | 21 +++++++++++++++------
 include/linux/virtio.h              |  1 +
 net/9p/trans_virtio.c               |  4 ++++
 8 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 2edfb5c..13b8ae9 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -22,6 +22,9 @@ static DEFINE_IDA(vd_index_ida);
 
 struct workqueue_struct *virtblk_wq;
 
+static unsigned int indirect_thresh;
+module_param(indirect_thresh, uint, S_IRUGO);
+
 struct virtio_blk
 {
 	struct virtio_device *vdev;
@@ -735,6 +738,7 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 
 	INIT_WORK(&vblk->config_work, virtblk_config_changed_work);
 	vblk->config_enable = true;
+	vdev->indirect_thresh = indirect_thresh;
 
 	err = init_vq(vblk);
 	if (err)
diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 5708299..02d8421 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -25,6 +25,9 @@
 #include <linux/virtio_rng.h>
 #include <linux/module.h>
 
+static unsigned int indirect_thresh;
+module_param(indirect_thresh, uint, S_IRUGO);
+
 static struct virtqueue *vq;
 static unsigned int data_avail;
 static DECLARE_COMPLETION(have_data);
@@ -93,6 +96,7 @@ static int probe_common(struct virtio_device *vdev)
 	int err;
 
 	/* We expect a single virtqueue. */
+	vdev->indirect_thresh = indirect_thresh;
 	vq = virtio_find_single_vq(vdev, random_recv_done, "input");
 	if (IS_ERR(vq))
 		return PTR_ERR(vq);
diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index e88f843..fc14e7f 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -39,6 +39,9 @@
 #include <linux/module.h>
 #include "../tty/hvc/hvc_console.h"
 
+static unsigned int indirect_thresh;
+module_param(indirect_thresh, uint, S_IRUGO);
+
 /*
  * This is a global struct for storing common data for all the devices
  * this driver handles.
@@ -1887,6 +1890,7 @@ static int __devinit virtcons_probe(struct virtio_device *vdev)
 				       max_nr_ports),
 			      &portdev->config.max_nr_ports) == 0)
 		multiport = true;
+	vdev->indirect_thresh = indirect_thresh;
 
 	err = init_vqs(portdev);
 	if (err < 0) {
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index cbf8b06..64a8321 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -34,6 +34,9 @@ static bool csum = true, gso = true;
 module_param(csum, bool, 0444);
 module_param(gso, bool, 0444);
 
+static unsigned int indirect_thresh;
+module_param(indirect_thresh, uint, S_IRUGO);
+
 /* FIXME: MTU in config. */
 #define MAX_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
 #define GOOD_COPY_LEN	128
@@ -1128,6 +1131,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
 		vi->mergeable_rx_bufs = true;
+	vdev->indirect_thresh = indirect_thresh;
 
 	err = init_vqs(vi);
 	if (err)
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 0908e60..fce7347 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -35,6 +35,9 @@
  */
 #define VIRTIO_BALLOON_PAGES_PER_PAGE (PAGE_SIZE >> VIRTIO_BALLOON_PFN_SHIFT)
 
+static unsigned int indirect_thresh;
+module_param(indirect_thresh, uint, S_IRUGO);
+
 struct virtio_balloon
 {
 	struct virtio_device *vdev;
@@ -356,6 +359,7 @@ static int virtballoon_probe(struct virtio_device *vdev)
 	init_waitqueue_head(&vb->acked);
 	vb->vdev = vdev;
 	vb->need_stats_update = 0;
+	vdev->indirect_thresh = indirect_thresh;
 
 	err = init_vqs(vb);
 	if (err)
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 5aa43c3..99a64a7 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -87,8 +87,11 @@ struct vring_virtqueue
 	/* Other side has made a mess, don't try any more. */
 	bool broken;
 
-	/* Host supports indirect buffers */
-	bool indirect;
+	/*
+	 * Min. number of free space in the ring to trigger direct
+	 * descriptor use
+	 */
+	unsigned int indirect_thresh;
 
 	/* Host publishes avail event idx */
 	bool event;
@@ -216,9 +219,12 @@ int virtqueue_add_buf(struct virtqueue *_vq,
 	}
 #endif
 
-	/* If the host supports indirect descriptor tables, and we have multiple
-	 * buffers, then go indirect. FIXME: tune this threshold */
-	if (vq->indirect && (out + in) > 1 && vq->num_free) {
+	/*
+	 * If the host supports indirect descriptor tables, and we have multiple
+	 * buffers, then go indirect.
+	 */
+	if ((out + in) > 1 && vq->num_free &&
+		(vq->num_free < vq->indirect_thresh)) {
 		head = vring_add_indirect(vq, sg, out, in, gfp);
 		if (likely(head >= 0))
 			goto add_head;
@@ -647,13 +653,16 @@ struct virtqueue *vring_new_virtqueue(unsigned int num,
 	vq->broken = false;
 	vq->last_used_idx = 0;
 	vq->num_added = 0;
+	vq->indirect_thresh = 0;
 	list_add_tail(&vq->vq.list, &vdev->vqs);
 #ifdef DEBUG
 	vq->in_use = false;
 	vq->last_add_time_valid = false;
 #endif
 
-	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC);
+	if (virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC))
+		vq->indirect_thresh = vdev->indirect_thresh;
+
 	vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
 
 	/* No callback?  Tell other side not to bother us. */
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index a1ba8bb..48bc457 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -69,6 +69,7 @@ struct virtio_device {
 	/* Note that this is a Linux set_bit-style bitmap. */
 	unsigned long features[1];
 	void *priv;
+	unsigned int indirect_thresh;
 };
 
 #define dev_to_virtio(dev) container_of(dev, struct virtio_device, dev)
diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 35b8911..fc93962 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -52,6 +52,9 @@
 
 #define VIRTQUEUE_NUM	128
 
+static unsigned int indirect_thresh;
+module_param(indirect_thresh, uint, S_IRUGO);
+
 /* a single mutex to manage channel initialization and attachment */
 static DEFINE_MUTEX(virtio_9p_lock);
 static DECLARE_WAIT_QUEUE_HEAD(vp_wq);
@@ -501,6 +504,7 @@ static int p9_virtio_probe(struct virtio_device *vdev)
 	chan->vdev = vdev;
 
 	/* We expect one virtqueue, for requests. */
+	vdev->indirect_thresh = indirect_thresh;
 	chan->vq = virtio_find_single_vq(vdev, req_done, "requests");
 	if (IS_ERR(chan->vq)) {
 		err = PTR_ERR(chan->vq);
-- 
1.7.12

