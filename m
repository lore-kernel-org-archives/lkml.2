Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591Ab0FRPAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 11:00:07 -0400
Received: from verein.lst.de ([213.95.11.210]:47653 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933531Ab0FRPAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 11:00:05 -0400
Date: Fri, 18 Jun 2010 16:59:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk, snitzer@redhat.com
Cc: martin.petersen@oracle.com, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH, RFC] block: don't allocate a payload for discard request
Message-ID: <20100618145942.GA1148@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Allocating a fixed payload for discard requests always was a horrible hack,
and it's not coming to byte us when adding support for discard in DM/MD.

So change the code to leave the allocation of a payload to the lowlevel
driver.  Unfortunately that means we'll need another hack, which allows
us to update the various block layer length fields indicating that we
have a payload.  Instead of hiding this in sd.c, which we already partially
do for UNMAP support add a documented helper in the core block layer for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/block/blk-lib.c
===================================================================
--- linux-2.6.orig/block/blk-lib.c	2010-06-18 11:33:37.313260457 +0200
+++ linux-2.6/block/blk-lib.c	2010-06-18 16:49:20.854319055 +0200
@@ -19,7 +19,6 @@ static void blkdev_discard_end_io(struct
 
 	if (bio->bi_private)
 		complete(bio->bi_private);
-	__free_page(bio_page(bio));
 
 	bio_put(bio);
 }
@@ -43,7 +42,6 @@ int blkdev_issue_discard(struct block_de
 	int type = flags & BLKDEV_IFL_BARRIER ?
 		DISCARD_BARRIER : DISCARD_NOBARRIER;
 	struct bio *bio;
-	struct page *page;
 	int ret = 0;
 
 	if (!q)
@@ -53,35 +51,21 @@ int blkdev_issue_discard(struct block_de
 		return -EOPNOTSUPP;
 
 	while (nr_sects && !ret) {
-		unsigned int sector_size = q->limits.logical_block_size;
 		unsigned int max_discard_sectors =
 			min(q->limits.max_discard_sectors, UINT_MAX >> 9);
 
 		bio = bio_alloc(gfp_mask, 1);
-		if (!bio)
-			goto out;
+		if (!bio) {
+			ret = -ENOMEM;
+			break;
+		}
+
 		bio->bi_sector = sector;
 		bio->bi_end_io = blkdev_discard_end_io;
 		bio->bi_bdev = bdev;
 		if (flags & BLKDEV_IFL_WAIT)
 			bio->bi_private = &wait;
 
-		/*
-		 * Add a zeroed one-sector payload as that's what
-		 * our current implementations need.  If we'll ever need
-		 * more the interface will need revisiting.
-		 */
-		page = alloc_page(gfp_mask | __GFP_ZERO);
-		if (!page)
-			goto out_free_bio;
-		if (bio_add_pc_page(q, bio, page, sector_size, 0) < sector_size)
-			goto out_free_page;
-
-		/*
-		 * And override the bio size - the way discard works we
-		 * touch many more blocks on disk than the actual payload
-		 * length.
-		 */
 		if (nr_sects > max_discard_sectors) {
 			bio->bi_size = max_discard_sectors << 9;
 			nr_sects -= max_discard_sectors;
@@ -103,13 +87,8 @@ int blkdev_issue_discard(struct block_de
 			ret = -EIO;
 		bio_put(bio);
 	}
+
 	return ret;
-out_free_page:
-	__free_page(page);
-out_free_bio:
-	bio_put(bio);
-out:
-	return -ENOMEM;
 }
 EXPORT_SYMBOL(blkdev_issue_discard);
 
Index: linux-2.6/drivers/scsi/sd.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sd.c	2010-06-18 11:33:37.322253892 +0200
+++ linux-2.6/drivers/scsi/sd.c	2010-06-18 16:50:04.790255778 +0200
@@ -411,22 +411,25 @@ static void sd_prot_op(struct scsi_cmnd
 }
 
 /**
- * sd_prepare_discard - unmap blocks on thinly provisioned device
+ * scsi_setup_discard_cmnd - unmap blocks on thinly provisioned device
+ * @sdp: scsi device to operate one
  * @rq: Request to prepare
  *
  * Will issue either UNMAP or WRITE SAME(16) depending on preference
  * indicated by target device.
  **/
-static int sd_prepare_discard(struct request *rq)
+static int scsi_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 {
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	struct bio *bio = rq->bio;
 	sector_t sector = bio->bi_sector;
-	unsigned int num = bio_sectors(bio);
+	unsigned int nr_sectors = bio_sectors(bio);
+	unsigned int len;
+	struct page *page;
 
 	if (sdkp->device->sector_size == 4096) {
 		sector >>= 3;
-		num >>= 3;
+		nr_sectors >>= 3;
 	}
 
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
@@ -434,31 +437,35 @@ static int sd_prepare_discard(struct req
 
 	memset(rq->cmd, 0, rq->cmd_len);
 
+	page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
+	if (!page)
+		return BLKPREP_DEFER;
+
 	if (sdkp->unmap) {
-		char *buf = kmap_atomic(bio_page(bio), KM_USER0);
+		char *buf = page_address(page);
 
+		rq->cmd_len = 10;
 		rq->cmd[0] = UNMAP;
 		rq->cmd[8] = 24;
-		rq->cmd_len = 10;
-
-		/* Ensure that data length matches payload */
-		rq->__data_len = bio->bi_size = bio->bi_io_vec->bv_len = 24;
 
 		put_unaligned_be16(6 + 16, &buf[0]);
 		put_unaligned_be16(16, &buf[2]);
 		put_unaligned_be64(sector, &buf[8]);
-		put_unaligned_be32(num, &buf[16]);
+		put_unaligned_be32(nr_sectors, &buf[16]);
 
-		kunmap_atomic(buf, KM_USER0);
+		len = 24;
 	} else {
+		rq->cmd_len = 16;
 		rq->cmd[0] = WRITE_SAME_16;
 		rq->cmd[1] = 0x8; /* UNMAP */
 		put_unaligned_be64(sector, &rq->cmd[2]);
-		put_unaligned_be32(num, &rq->cmd[10]);
-		rq->cmd_len = 16;
+		put_unaligned_be32(nr_sectors, &rq->cmd[10]);
+
+		len = sdkp->device->sector_size;
 	}
 
-	return BLKPREP_OK;
+	blk_add_request_payload(rq, page, len);
+	return scsi_setup_blk_pc_cmnd(sdp, rq);
 }
 
 /**
@@ -485,10 +492,10 @@ static int sd_prep_fn(struct request_que
 	 * Discard request come in as REQ_TYPE_FS but we turn them into
 	 * block PC requests to make life easier.
 	 */
-	if (rq->cmd_flags & REQ_DISCARD)
-		ret = sd_prepare_discard(rq);
-
-	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
+	if (rq->cmd_flags & REQ_DISCARD) {
+		ret = scsi_setup_discard_cmnd(sdp, rq);
+		goto out;
+	} else if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
 		ret = scsi_setup_blk_pc_cmnd(sdp, rq);
 		goto out;
 	} else if (rq->cmd_type != REQ_TYPE_FS) {
@@ -1163,6 +1170,15 @@ static int sd_done(struct scsi_cmnd *SCp
 	int sense_valid = 0;
 	int sense_deferred = 0;
 
+	/*
+	 * If this is a discard request that originated from the kernel
+	 * we need to free our payload here.  Note that we need to check
+	 * the request flag as the normal payload rules apply for
+	 * pass-through UNMAP / WRITE SAME requests.
+	 */
+	if (SCpnt->request->cmd_flags & REQ_DISCARD)
+		__free_page(bio_page(SCpnt->request->bio));
+
 	if (result) {
 		sense_valid = scsi_command_normalize_sense(SCpnt, &sshdr);
 		if (sense_valid)
Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c	2010-06-18 16:43:23.711273168 +0200
+++ linux-2.6/block/blk-core.c	2010-06-18 16:48:17.392256056 +0200
@@ -1135,6 +1135,38 @@ void blk_put_request(struct request *req
 }
 EXPORT_SYMBOL(blk_put_request);
 
+/**
+ * blk_add_request_payload - add a payload to a request
+ * @rq: request to update
+ * @page: page backing the payload
+ * @len: length of the payload.
+ *
+ * This allows to later add a payload to an already submitted request by
+ * a block driver.  The driver needs to take care of freeing the payload
+ * itself.
+ *
+ * Note that this is a quite horrible hack and nothing but handling of
+ * discard requests should ever use it.
+ */
+void blk_add_request_payload(struct request *rq, struct page *page,
+		unsigned int len)
+{
+	struct bio *bio = rq->bio;
+
+	bio->bi_io_vec->bv_page = page;
+	bio->bi_io_vec->bv_offset = 0;
+	bio->bi_io_vec->bv_len = len;
+
+	bio->bi_size = len;
+	bio->bi_vcnt = 1;
+	bio->bi_phys_segments = 1;
+
+	rq->__data_len = rq->resid_len = len;
+	rq->nr_phys_segments = 1;
+	rq->buffer = bio_data(bio);
+}
+EXPORT_SYMBOL_GPL(blk_add_request_payload);
+
 void init_request_from_bio(struct request *req, struct bio *bio)
 {
 	req->cpu = bio->bi_comp_cpu;
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2010-06-18 16:45:29.223003718 +0200
+++ linux-2.6/include/linux/blkdev.h	2010-06-18 16:47:25.894005813 +0200
@@ -702,6 +702,8 @@ extern struct request *blk_make_request(
 					gfp_t);
 extern void blk_insert_request(struct request_queue *, struct request *, int, void *);
 extern void blk_requeue_request(struct request_queue *, struct request *);
+extern void blk_add_request_payload(struct request *rq, struct page *page,
+		unsigned int len);
 extern int blk_rq_check_limits(struct request_queue *q, struct request *rq);
 extern int blk_lld_busy(struct request_queue *q);
 extern int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
