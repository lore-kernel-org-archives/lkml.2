Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab0FZT5U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 15:57:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977Ab0FZT5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 15:57:18 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, dm-devel@redhat.com, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
       akpm@linux-foundation.org
Subject: [PATCH 1/2] block: fix leaks associated with discard request payload
Date: Sat, 26 Jun 2010 15:56:50 -0400
Message-Id: <1277582211-10725-1-git-send-email-snitzer@redhat.com>
In-Reply-To: <20100622180029.GA15950@redhat.com>
References: <20100622180029.GA15950@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix leaks introduced via "block: don't allocate a payload for discard
request" commit a1d949f5f44.

sd_done() is not called for REQ_TYPE_BLOCK_PC commands so cleanup
discard request's payload directly in scsi_finish_command().

Also cleanup page allocated for discard payload in
scsi_setup_discard_cmnd's scsi_setup_blk_pc_cmnd error path.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c       |   23 +++++++++++++++++++++++
 drivers/scsi/scsi.c    |    8 ++++++++
 drivers/scsi/sd.c      |   18 ++++++++----------
 include/linux/blkdev.h |    1 +
 4 files changed, 40 insertions(+), 10 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 98b4cee..07925aa 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1167,6 +1167,29 @@ void blk_add_request_payload(struct request *rq, struct page *page,
 }
 EXPORT_SYMBOL_GPL(blk_add_request_payload);
 
+/**
+ * blk_clear_request_payload - clear a request's payload
+ * @rq: request to update
+ *
+ * The driver needs to take care of freeing the payload itself.
+ */
+void blk_clear_request_payload(struct request *rq)
+{
+	struct bio *bio = rq->bio;
+
+	rq->__data_len = rq->resid_len = 0;
+	rq->nr_phys_segments = 0;
+	rq->buffer = NULL;
+
+	bio->bi_size = 0;
+	bio->bi_vcnt = 0;
+	bio->bi_phys_segments = 0;
+
+	bio->bi_io_vec->bv_page = NULL;
+	bio->bi_io_vec->bv_len = 0;
+}
+EXPORT_SYMBOL_GPL(blk_clear_request_payload);
+
 void init_request_from_bio(struct request *req, struct bio *bio)
 {
 	req->cpu = bio->bi_comp_cpu;
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index ad0ed21..69c7ea4 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -851,6 +851,14 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 		 */
 		if (good_bytes == old_good_bytes)
 			good_bytes -= scsi_get_resid(cmd);
+	} else if (cmd->request->cmd_flags & REQ_DISCARD) {
+		/*
+		 * If this is a discard request that originated from the kernel
+		 * we need to free our payload here.  Note that we need to check
+		 * the request flag as the normal payload rules apply for
+		 * pass-through UNMAP / WRITE SAME requests.
+		 */
+		__free_page(bio_page(cmd->request->bio));
 	}
 	scsi_io_completion(cmd, good_bytes);
 }
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 86da819..9b81dda 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -425,6 +425,7 @@ static int scsi_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 	sector_t sector = bio->bi_sector;
 	unsigned int nr_sectors = bio_sectors(bio);
 	unsigned int len;
+	int ret;
 	struct page *page;
 
 	if (sdkp->device->sector_size == 4096) {
@@ -465,7 +466,13 @@ static int scsi_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 	}
 
 	blk_add_request_payload(rq, page, len);
-	return scsi_setup_blk_pc_cmnd(sdp, rq);
+	ret = scsi_setup_blk_pc_cmnd(sdp, rq);
+	if (ret != BLKPREP_OK) {
+		blk_clear_request_payload(rq);
+		__free_page(page);
+	}
+
+	return ret;
 }
 
 /**
@@ -1170,15 +1177,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	int sense_valid = 0;
 	int sense_deferred = 0;
 
-	/*
-	 * If this is a discard request that originated from the kernel
-	 * we need to free our payload here.  Note that we need to check
-	 * the request flag as the normal payload rules apply for
-	 * pass-through UNMAP / WRITE SAME requests.
-	 */
-	if (SCpnt->request->cmd_flags & REQ_DISCARD)
-		__free_page(bio_page(SCpnt->request->bio));
-
 	if (result) {
 		sense_valid = scsi_command_normalize_sense(SCpnt, &sshdr);
 		if (sense_valid)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 204fbe2..fdeef47 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -707,6 +707,7 @@ extern void blk_insert_request(struct request_queue *, struct request *, int, vo
 extern void blk_requeue_request(struct request_queue *, struct request *);
 extern void blk_add_request_payload(struct request *rq, struct page *page,
 		unsigned int len);
+extern void blk_clear_request_payload(struct request *rq);
 extern int blk_rq_check_limits(struct request_queue *q, struct request *rq);
 extern int blk_lld_busy(struct request_queue *q);
 extern int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
-- 
1.6.5.rc2

