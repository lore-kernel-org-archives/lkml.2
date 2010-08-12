Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933751Ab0HLMoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 08:44:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:38345 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab0HLMoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 08:44:19 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de
Cc: Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 11/11] block: use REQ_FLUSH in blkdev_issue_flush()
Date: Thu, 12 Aug 2010 14:41:31 +0200
Message-Id: <1281616891-5691-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1281616891-5691-1-git-send-email-tj@kernel.org>
References: <1281616891-5691-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 12 Aug 2010 12:43:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update blkdev_issue_flush() to use new REQ_FLUSH interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
---
 block/blk-flush.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 452c552..ab765c2 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -174,13 +174,10 @@ struct request *blk_do_flush(struct request_queue *q, struct request *rq)
 	return blk_flush_complete_seq(q, skip, 0);
 }
 
-static void bio_end_empty_barrier(struct bio *bio, int err)
+static void bio_end_flush(struct bio *bio, int err)
 {
-	if (err) {
-		if (err == -EOPNOTSUPP)
-			set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
+	if (err)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
-	}
 	if (bio->bi_private)
 		complete(bio->bi_private);
 	bio_put(bio);
@@ -218,19 +215,19 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 	 * some block devices may not have their queue correctly set up here
 	 * (e.g. loop device without a backing file) and so issuing a flush
 	 * here will panic. Ensure there is a request function before issuing
-	 * the barrier.
+	 * the flush.
 	 */
 	if (!q->make_request_fn)
 		return -ENXIO;
 
 	bio = bio_alloc(gfp_mask, 0);
-	bio->bi_end_io = bio_end_empty_barrier;
+	bio->bi_end_io = bio_end_flush;
 	bio->bi_bdev = bdev;
 	if (test_bit(BLKDEV_WAIT, &flags))
 		bio->bi_private = &wait;
 
 	bio_get(bio);
-	submit_bio(WRITE_BARRIER, bio);
+	submit_bio(WRITE_FLUSH, bio);
 	if (test_bit(BLKDEV_WAIT, &flags)) {
 		wait_for_completion(&wait);
 		/*
@@ -242,9 +239,7 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 			*error_sector = bio->bi_sector;
 	}
 
-	if (bio_flagged(bio, BIO_EOPNOTSUPP))
-		ret = -EOPNOTSUPP;
-	else if (!bio_flagged(bio, BIO_UPTODATE))
+	if (!bio_flagged(bio, BIO_UPTODATE))
 		ret = -EIO;
 
 	bio_put(bio);
-- 
1.7.1

