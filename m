Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab0HPQzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 12:55:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:38165 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab0HPQzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 12:55:31 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com
Cc: Tejun Heo <tj@kernle.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/5] virtio_blk: implement REQ_FLUSH/FUA support
Date: Mon, 16 Aug 2010 18:52:00 +0200
Message-Id: <1281977523-19335-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1281977523-19335-1-git-send-email-tj@kernel.org>
References: <1281977523-19335-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 16 Aug 2010 16:55:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernle.org>

Remove now unused REQ_HARDBARRIER support and implement REQ_FLUSH/FUA
support instead.  A new feature flag VIRTIO_BLK_F_FUA is added to
indicate the support for FUA.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/block/virtio_blk.c |   26 ++++++++++++--------------
 include/linux/virtio_blk.h |    6 +++++-
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index d10b635..ed0fb7d 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -128,9 +128,6 @@ static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 		}
 	}
 
-	if (vbr->req->cmd_flags & REQ_HARDBARRIER)
-		vbr->out_hdr.type |= VIRTIO_BLK_T_BARRIER;
-
 	sg_set_buf(&vblk->sg[out++], &vbr->out_hdr, sizeof(vbr->out_hdr));
 
 	/*
@@ -157,6 +154,8 @@ static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 		if (rq_data_dir(vbr->req) == WRITE) {
 			vbr->out_hdr.type |= VIRTIO_BLK_T_OUT;
 			out += num;
+			if (req->cmd_flags & REQ_FUA)
+				vbr->out_hdr.type |= VIRTIO_BLK_T_FUA;
 		} else {
 			vbr->out_hdr.type |= VIRTIO_BLK_T_IN;
 			in += num;
@@ -307,6 +306,7 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk;
 	struct request_queue *q;
+	unsigned int flush;
 	int err;
 	u64 cap;
 	u32 v, blk_size, sg_elems, opt_io_size;
@@ -388,15 +388,13 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 	vblk->disk->driverfs_dev = &vdev->dev;
 	index++;
 
-	/*
-	 * If the FLUSH feature is supported we do have support for
-	 * flushing a volatile write cache on the host.  Use that to
-	 * implement write barrier support; otherwise, we must assume
-	 * that the host does not perform any kind of volatile write
-	 * caching.
-	 */
+	/* configure queue flush support */
+	flush = 0;
 	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH))
-		blk_queue_flush(q, REQ_FLUSH);
+		flush |= REQ_FLUSH;
+	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FUA))
+		flush |= REQ_FUA;
+	blk_queue_flush(q, flush);
 
 	/* If disk is read-only in the host, the guest should obey */
 	if (virtio_has_feature(vdev, VIRTIO_BLK_F_RO))
@@ -515,9 +513,9 @@ static const struct virtio_device_id id_table[] = {
 };
 
 static unsigned int features[] = {
-	VIRTIO_BLK_F_BARRIER, VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX,
-	VIRTIO_BLK_F_GEOMETRY, VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE,
-	VIRTIO_BLK_F_SCSI, VIRTIO_BLK_F_FLUSH, VIRTIO_BLK_F_TOPOLOGY
+	VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX, VIRTIO_BLK_F_GEOMETRY,
+	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE, VIRTIO_BLK_F_SCSI,
+	VIRTIO_BLK_F_FLUSH, VIRTIO_BLK_F_TOPOLOGY, VIRTIO_BLK_F_FUA,
 };
 
 /*
diff --git a/include/linux/virtio_blk.h b/include/linux/virtio_blk.h
index 167720d..f453f3c 100644
--- a/include/linux/virtio_blk.h
+++ b/include/linux/virtio_blk.h
@@ -16,6 +16,7 @@
 #define VIRTIO_BLK_F_SCSI	7	/* Supports scsi command passthru */
 #define VIRTIO_BLK_F_FLUSH	9	/* Cache flush command support */
 #define VIRTIO_BLK_F_TOPOLOGY	10	/* Topology information is available */
+#define VIRTIO_BLK_F_FUA	11	/* Forced Unit Access write support */
 
 #define VIRTIO_BLK_ID_BYTES	20	/* ID string length */
 
@@ -70,7 +71,10 @@ struct virtio_blk_config {
 #define VIRTIO_BLK_T_FLUSH	4
 
 /* Get device ID command */
-#define VIRTIO_BLK_T_GET_ID    8
+#define VIRTIO_BLK_T_GET_ID	8
+
+/* FUA command */
+#define VIRTIO_BLK_T_FUA	16
 
 /* Barrier before this op. */
 #define VIRTIO_BLK_T_BARRIER	0x80000000
-- 
1.7.1

