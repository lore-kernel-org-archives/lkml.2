Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab1HPTty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 15:49:54 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:36219 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab1HPTtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 15:49:52 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: [PATCH] virtio-blk: Add stats VQ to collect information about devices
Date: Tue, 16 Aug 2011 22:47:51 +0300
Message-Id: <1313524071-27250-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for an optional stats vq that works similary to the
stats vq provided by virtio-balloon.

The purpose of this change is to allow collection of statistics about working
virtio-blk devices to easily analyze performance without having to tap into
the guest.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org
Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 drivers/block/virtio_blk.c |  110 +++++++++++++++++++++++++++++++++++++++++---
 include/linux/virtio_blk.h |   20 ++++++++
 2 files changed, 123 insertions(+), 7 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 079c088..9c196ea 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -19,7 +19,7 @@ struct virtio_blk
 	spinlock_t lock;
 
 	struct virtio_device *vdev;
-	struct virtqueue *vq;
+	struct virtqueue *vq, *stats_vq;
 
 	/* The disk structure for the kernel. */
 	struct gendisk *disk;
@@ -35,6 +35,10 @@ struct virtio_blk
 	/* What host tells us, plus 2 for header & tailer. */
 	unsigned int sg_elems;
 
+	/* Block statistics */
+	int need_stats_update;
+	struct virtio_blk_stat stats[VIRTIO_BLK_S_NR];
+
 	/* Scatterlist: can be too big for stack. */
 	struct scatterlist sg[/*sg_elems*/];
 };
@@ -48,6 +52,75 @@ struct virtblk_req
 	u8 status;
 };
 
+static inline void update_stat(struct virtio_blk *vb, int idx,
+			       u16 tag, u64 val)
+{
+	BUG_ON(idx >= VIRTIO_BLK_S_NR);
+	vb->stats[idx].tag = tag;
+	vb->stats[idx].val = val;
+}
+
+static void update_blk_stats(struct virtio_blk *vb)
+{
+	struct hd_struct *p = disk_get_part(vb->disk, 0);
+	int cpu;
+	int idx = 0;
+
+	cpu = part_stat_lock();
+	part_round_stats(cpu, p);
+	part_stat_unlock();
+
+	update_stat(vb, idx++, VIRTIO_BLK_S_READ_IO,
+		    part_stat_read(p, ios[READ]));
+	update_stat(vb, idx++, VIRTIO_BLK_S_READ_MERGES,
+		    part_stat_read(p, merges[READ]));
+	update_stat(vb, idx++, VIRTIO_BLK_S_READ_SECTORS,
+		    part_stat_read(p, sectors[READ]));
+	update_stat(vb, idx++, VIRTIO_BLK_S_READ_TICKS,
+		    jiffies_to_msecs(part_stat_read(p, ticks[READ])));
+	update_stat(vb, idx++, VIRTIO_BLK_S_WRITE_IO,
+		    part_stat_read(p, ios[WRITE]));
+	update_stat(vb, idx++, VIRTIO_BLK_S_WRITE_MERGES,
+		    part_stat_read(p, merges[WRITE]));
+	update_stat(vb, idx++, VIRTIO_BLK_S_WRITE_SECTORS,
+		    part_stat_read(p, sectors[WRITE]));
+	update_stat(vb, idx++, VIRTIO_BLK_S_WRITE_TICKS,
+		    jiffies_to_msecs(part_stat_read(p, ticks[WRITE])));
+	update_stat(vb, idx++, VIRTIO_BLK_S_IN_FLIGHT,
+		    part_in_flight(p));
+	update_stat(vb, idx++, VIRTIO_BLK_S_IO_TICKS,
+		    jiffies_to_msecs(part_stat_read(p, io_ticks)));
+	update_stat(vb, idx++, VIRTIO_BLK_S_TIME_IN_QUEUE,
+		    jiffies_to_msecs(part_stat_read(p, time_in_queue)));
+}
+
+static void stats_request(struct virtqueue *vq)
+{
+	struct virtio_blk *vb;
+	unsigned int len;
+
+	vb = virtqueue_get_buf(vq, &len);
+	if (!vb)
+		return;
+	vb->need_stats_update = 1;
+	queue_work(virtblk_wq, &vb->config_work);
+}
+
+static void stats_handle_request(struct virtio_blk *vb)
+{
+	struct virtqueue *vq;
+	struct scatterlist sg;
+
+	vb->need_stats_update = 0;
+	update_blk_stats(vb);
+
+	vq = vb->stats_vq;
+	sg_init_one(&sg, vb->stats, sizeof(vb->stats));
+	if (virtqueue_add_buf(vq, &sg, 1, 0, vb) < 0)
+		BUG();
+	virtqueue_kick(vq);
+}
+
 static void blk_done(struct virtqueue *vq)
 {
 	struct virtio_blk *vblk = vq->vdev->priv;
@@ -306,6 +379,11 @@ static void virtblk_config_changed_work(struct work_struct *work)
 	char cap_str_2[10], cap_str_10[10];
 	u64 capacity, size;
 
+	if (vblk->need_stats_update) {
+		stats_handle_request(vblk);
+		return;
+	}
+
 	/* Host must always specify the capacity. */
 	vdev->config->get(vdev, offsetof(struct virtio_blk_config, capacity),
 			  &capacity, sizeof(capacity));
@@ -341,7 +419,10 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk;
 	struct request_queue *q;
-	int err;
+	vq_callback_t *callbacks[] = { blk_done, stats_request};
+	const char *names[] = { "requests", "stats" };
+	struct virtqueue *vqs[2];
+	int err, nvqs;
 	u64 cap;
 	u32 v, blk_size, sg_elems, opt_io_size;
 	u16 min_io_size;
@@ -375,11 +456,26 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 	sg_init_table(vblk->sg, vblk->sg_elems);
 	INIT_WORK(&vblk->config_work, virtblk_config_changed_work);
 
-	/* We expect one virtqueue, for output. */
-	vblk->vq = virtio_find_single_vq(vdev, blk_done, "requests");
-	if (IS_ERR(vblk->vq)) {
-		err = PTR_ERR(vblk->vq);
+	/* We expect one virtqueue for output, and optionally a stats vq. */
+	nvqs = virtio_has_feature(vblk->vdev, VIRTIO_BLK_F_STATS_VQ) ? 2 : 1;
+	err = vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names);
+	if (err)
 		goto out_free_vblk;
+
+	vblk->vq = vqs[0];
+
+	if (nvqs == 2) {
+		struct scatterlist sg;
+		vblk->stats_vq = vqs[1];
+
+		/*
+		 * Prime this virtqueue with one buffer so the hypervisor can
+		 * use it to signal us later.
+		 */
+		sg_init_one(&sg, vblk->stats, sizeof vblk->stats);
+		if (virtqueue_add_buf(vblk->stats_vq, &sg, 1, 0, vblk) < 0)
+			BUG();
+		virtqueue_kick(vblk->stats_vq);
 	}
 
 	vblk->pool = mempool_create_kmalloc_pool(1,sizeof(struct virtblk_req));
@@ -548,7 +644,7 @@ static const struct virtio_device_id id_table[] = {
 static unsigned int features[] = {
 	VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX, VIRTIO_BLK_F_GEOMETRY,
 	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE, VIRTIO_BLK_F_SCSI,
-	VIRTIO_BLK_F_FLUSH, VIRTIO_BLK_F_TOPOLOGY
+	VIRTIO_BLK_F_FLUSH, VIRTIO_BLK_F_TOPOLOGY, VIRTIO_BLK_F_STATS_VQ
 };
 
 /*
diff --git a/include/linux/virtio_blk.h b/include/linux/virtio_blk.h
index e0edb40..6e87c2e 100644
--- a/include/linux/virtio_blk.h
+++ b/include/linux/virtio_blk.h
@@ -39,6 +39,7 @@
 #define VIRTIO_BLK_F_SCSI	7	/* Supports scsi command passthru */
 #define VIRTIO_BLK_F_FLUSH	9	/* Cache flush command support */
 #define VIRTIO_BLK_F_TOPOLOGY	10	/* Topology information is available */
+#define VIRTIO_BLK_F_STATS_VQ	11	/* Optional stats vq is available */
 
 #define VIRTIO_BLK_ID_BYTES	20	/* ID string length */
 
@@ -119,4 +120,23 @@ struct virtio_scsi_inhdr {
 #define VIRTIO_BLK_S_OK		0
 #define VIRTIO_BLK_S_IOERR	1
 #define VIRTIO_BLK_S_UNSUPP	2
+
+#define VIRTIO_BLK_S_READ_IO		0
+#define VIRTIO_BLK_S_READ_MERGES	1
+#define VIRTIO_BLK_S_READ_SECTORS	2
+#define VIRTIO_BLK_S_READ_TICKS		3
+#define VIRTIO_BLK_S_WRITE_IO		4
+#define VIRTIO_BLK_S_WRITE_MERGES	5
+#define VIRTIO_BLK_S_WRITE_SECTORS	6
+#define VIRTIO_BLK_S_WRITE_TICKS	7
+#define VIRTIO_BLK_S_IN_FLIGHT		8
+#define VIRTIO_BLK_S_IO_TICKS		9
+#define VIRTIO_BLK_S_TIME_IN_QUEUE	10
+#define VIRTIO_BLK_S_NR			11
+
+struct virtio_blk_stat {
+	u16 tag;
+	u64 val;
+} __attribute__((packed));
+
 #endif /* _LINUX_VIRTIO_BLK_H */
-- 
1.7.6

