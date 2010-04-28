Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab0D1Nzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 09:55:47 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:64002 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab0D1NzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 09:55:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=NNx/s/lfYH7BKgWIHQiRonj0foK7ITQbo8DzU0A8PuIfwL3V8/YgfNFE04qIzfYxF3
         Rj/UnaKFMzLtRRS6xwUP374B0utQ21o6pn4f6LgQ3pVCEf0TN/iXvrKjvC02fI4L6n1x
         k0fYk3JuYYmLCAL6sYmpjjkyu/KDVTXQpkgsE=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, hch@infradead.org,
       Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/4] blkdev: allow async blkdev_issue_flush requests
Date: Wed, 28 Apr 2010 17:55:07 +0400
Message-Id: <1272462909-12942-3-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272462909-12942-2-git-send-email-dmonakhov@openvz.org>
References: <20100426172651.GT27497@kernel.dk>
 <1272462909-12942-1-git-send-email-dmonakhov@openvz.org>
 <1272462909-12942-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some places caller don't want to wait a request to complete.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 block/blk-barrier.c |   33 +++++++++++++++++++--------------
 1 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index cf14311..f11eec9 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -286,8 +286,9 @@ static void bio_end_empty_barrier(struct bio *bio, int err)
 			set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 	}
-
-	complete(bio->bi_private);
+	if (bio->bi_private)
+		complete(bio->bi_private);
+	bio_put(bio);
 }
 
 /**
@@ -300,7 +301,8 @@ static void bio_end_empty_barrier(struct bio *bio, int err)
  * Description:
  *    Issue a flush for the block device in question. Caller can supply
  *    room for storing the error offset in case of a flush error, if they
- *    wish to.
+ *    wish to. If WAIT flag is not passed then caller may check only what
+ *    request was pushed in some internal queue for later handling.
  */
 int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 		sector_t *error_sector, unsigned long flags)
@@ -319,19 +321,22 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 
 	bio = bio_alloc(gfp_mask, 0);
 	bio->bi_end_io = bio_end_empty_barrier;
-	bio->bi_private = &wait;
 	bio->bi_bdev = bdev;
-	submit_bio(WRITE_BARRIER, bio);
-
-	wait_for_completion(&wait);
+	if (test_bit(BLKDEV_WAIT, &flags))
+		bio->bi_private = &wait;
 
-	/*
-	 * The driver must store the error location in ->bi_sector, if
-	 * it supports it. For non-stacked drivers, this should be copied
-	 * from blk_rq_pos(rq).
-	 */
-	if (error_sector)
-		*error_sector = bio->bi_sector;
+	bio_get(bio);
+	submit_bio(WRITE_BARRIER, bio);
+	if (test_bit(BLKDEV_WAIT, &flags)) {
+		wait_for_completion(&wait);
+		/*
+		 * The driver must store the error location in ->bi_sector, if
+		 * it supports it. For non-stacked drivers, this should be
+		 * copied from blk_rq_pos(rq).
+		 */
+		if (error_sector)
+			*error_sector = bio->bi_sector;
+	}
 
 	if (bio_flagged(bio, BIO_EOPNOTSUPP))
 		ret = -EOPNOTSUPP;
-- 
1.6.6.1

