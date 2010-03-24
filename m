Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab0CXRaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:30:21 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:51795 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346Ab0CXRaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:30:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=nl+vzQDGv2ag0Ht6i1kh7m8N3juWo+NcQdCoLXY+Hx1G5Xl4+5AFt9w6EOU4hrzw/S
         uggzZme/nbe9kAzcUA4p4bQesJvLWOheGZ1gbCS7QLdsvjQ3DVxMyrSujZCSp9ba86x2
         uJSih60W9X8hs1TKqZ8Zt4Wyzr28ewxrW72YE=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, hch@infradead.org, mkp@mkp.net,
       Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 5/5] blkdev: optimize discard request logic
Date: Wed, 24 Mar 2010 20:29:51 +0300
Message-Id: <1269451792-5205-6-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1269451792-5205-5-git-send-email-dmonakhov@openvz.org>
References: <1269451792-5205-1-git-send-email-dmonakhov@openvz.org>
 <1269451792-5205-2-git-send-email-dmonakhov@openvz.org>
 <1269451792-5205-3-git-send-email-dmonakhov@openvz.org>
 <1269451792-5205-4-git-send-email-dmonakhov@openvz.org>
 <1269451792-5205-5-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow several discard request to share payload page because each
discard bio require only one sector.

Current submit procedure is suboptimal. Each bio is flagged with
barrier flag, so we will end up with following trace:
for_each_bio(discar_bios) {
  q->pre_flush
  handle(bio);
  disk->flush_cache
  q->post_flush
}
But in fact user want following semantics:
q->pre_flush()
for_each_bio(discar_bios)
  handle(bio)
q->pre_flush()

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 block/blk-lib.c |  174 ++++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 115 insertions(+), 59 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 321d150..be04a4c 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -9,6 +9,8 @@
 
 #include "blk.h"
 
+static DEFINE_SPINLOCK(alloc_lock);
+
 struct bio_batch
 {
 	atomic_t 		done;
@@ -129,17 +131,55 @@ EXPORT_SYMBOL(__blkdev_issue_zeroout);
 
 static void blkdev_discard_end_io(struct bio *bio, int err)
 {
-	if (err) {
-		if (err == -EOPNOTSUPP)
-			set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
-		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+	if (bio_page(bio))
+		put_page(bio_page(bio));
+}
+
+static int add_discard_payload(struct bio *bio, gfp_t gfp_mask, int len)
+{
+	static struct page *cur_page = NULL;
+	static int cur_offset = 0;
+	struct page *page;
+	int offset;
+	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
+again:
+	spin_lock(&alloc_lock);
+	if (cur_offset + len > PAGE_SIZE)
+		/* There is no more space in the page */
+		if (cur_page) {
+			put_page(cur_page);
+			cur_page = NULL;
+			cur_offset = 0;
+		}
+	if (!cur_page) {
+		spin_unlock(&alloc_lock);
+		page = alloc_page(gfp_mask | __GFP_ZERO);
+		if (!page)
+			return -ENOMEM;
+
+		spin_lock(&alloc_lock);
+		/*
+		 * Check cur_page one more time after we reacquired the lock.
+		 * Because it may be changed by other task.
+		 */
+		if (cur_page) {
+			spin_unlock(&alloc_lock);
+			put_page(page);
+			goto again;
+		} else
+			cur_page = page;
 	}
+	page = cur_page;
+	get_page(page);
+	offset = cur_offset;
+	cur_offset += len;
 
-	if (bio->bi_private)
-		complete(bio->bi_private);
-	__free_page(bio_page(bio));
+	spin_unlock(&alloc_lock);
 
-	bio_put(bio);
+	if (bio_add_pc_page(q, bio, page, len, offset) < len)
+		BUG();
+
+	return 0;
 }
 
 /**
@@ -153,16 +193,18 @@ static void blkdev_discard_end_io(struct bio *bio, int err)
  * Description:
  *    Issue a discard request for the sectors in question.
  */
+
 int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
-		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags)
+			sector_t nr_sects, gfp_t gfp_mask, unsigned long flags)
 {
+	int ret = 0;
+	struct bio *bio;
+	struct bio_batch bb;
+	unsigned int sz, issued = 0;
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request_queue *q = bdev_get_queue(bdev);
-	int type = flags & BLKDEV_IFL_BARRIER ?
-		DISCARD_BARRIER : DISCARD_NOBARRIER;
-	struct bio *bio;
-	struct page *page;
-	int ret = 0;
+	unsigned int sect_sz;
+	sector_t max_discard_sectors;
 
 	if (!q)
 		return -ENXIO;
@@ -170,66 +212,80 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	if (!blk_queue_discard(q))
 		return -EOPNOTSUPP;
 
-	while (nr_sects && !ret) {
-		unsigned int sector_size = q->limits.logical_block_size;
-		unsigned int max_discard_sectors =
-			min(q->limits.max_discard_sectors, UINT_MAX >> 9);
+	sect_sz = q->limits.logical_block_size;
+	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
+	atomic_set(&bb.done, 0);
+	bb.flags = 1 << BIO_UPTODATE;
+	bb.wait = &wait;
+	bb.end_io = blkdev_discard_end_io;
 
-		bio = bio_alloc(gfp_mask, 1);
+	if (flags & BLKDEV_IFL_BARRIER) {
+		/* issue async barrier before the data */
+		ret = blkdev_issue_flush(bdev, gfp_mask, NULL, 0);
+		if (ret)
+			return ret;
+	}
+submit:
+	while (nr_sects != 0) {
+		bio = bio_alloc(gfp_mask,
+				min(nr_sects, (sector_t)BIO_MAX_PAGES));
 		if (!bio)
-			goto out;
+			break;
+
 		bio->bi_sector = sector;
-		bio->bi_end_io = blkdev_discard_end_io;
-		bio->bi_bdev = bdev;
-		if (flags & BLKDEV_IFL_BARRIER)
-			bio->bi_private = &wait;
+		bio->bi_bdev   = bdev;
+		bio->bi_end_io = bio_batch_end_io;
+
+		if (flags && BLKDEV_IFL_WAIT)
+			bio->bi_private = &bb;
 
 		if (blk_queue_discard_mem(q)) {
 			/*
 			 * Add a zeroed one-sector payload as that's what
-			 * our current implementations need.  If we'll ever
+			 * our current implementations need. If we'll ever
 			 * need more the interface will need revisiting.
 			 */
-			page = alloc_page(gfp_mask | __GFP_ZERO);
-			if (!page)
-				goto out_free_bio;
-			if (bio_add_pc_page(q, bio, page, sector_size, 0) <
-				sector_size)
-				goto out_free_page;
-		}
-		/*
-		 * And override the bio size - the way discard works we
-		 * touch many more blocks on disk than the actual payload
-		 * length.
-		 */
-		if (nr_sects > max_discard_sectors) {
-			bio->bi_size = max_discard_sectors << 9;
-			nr_sects -= max_discard_sectors;
-			sector += max_discard_sectors;
-		} else {
-			bio->bi_size = nr_sects << 9;
-			nr_sects = 0;
+			ret = add_discard_payload(bio, gfp_mask, sect_sz);
+			if (ret) {
+				bio_put(bio);
+				break;
+			}
 		}
+		sz = min(max_discard_sectors , nr_sects);
+		bio->bi_size = sz << 9;
+		nr_sects -= sz;
+		sector += sz;
 
-		bio_get(bio);
-		submit_bio(type, bio);
+		issued++;
+		submit_bio(DISCARD_NOBARRIER, bio);
+	}
+	/*
+	 * When all data bios are in flight. Send final barrier if requeted.
+	 */
+	if (nr_sects == 0 && flags & BLKDEV_IFL_BARRIER)
+		ret = blkdev_issue_flush(bdev, gfp_mask, NULL,
+					flags & BLKDEV_IFL_WAIT);
 
-		if (flags & BLKDEV_IFL_BARRIER)
+	if (flags & BLKDEV_IFL_WAIT)
+		/* Wait for submitted bios and then continue */
+		while ( issued != atomic_read(&bb.done))
 			wait_for_completion(&wait);
 
-		if (bio_flagged(bio, BIO_EOPNOTSUPP))
-			ret = -EOPNOTSUPP;
-		else if (!bio_flagged(bio, BIO_UPTODATE))
-			ret = -EIO;
-		bio_put(bio);
+	if (!test_bit(BIO_UPTODATE, &bb.flags))
+		/* One of bios in the batch was completed with error.*/
+		ret = -EIO;
+
+	if (ret)
+		goto out;
+
+	if (test_bit(BIO_EOPNOTSUPP, &bb.flags)) {
+		ret = -EOPNOTSUPP;
+		goto out;
 	}
-	return ret;
-out_free_page:
-	__free_page(page);
-out_free_bio:
-	bio_put(bio);
+	if (nr_sects != 0)
+		goto submit;
 out:
-	return -ENOMEM;
+	return ret;
 }
 EXPORT_SYMBOL(blkdev_issue_discard);
 
@@ -246,7 +302,7 @@ int blkdev_issue_clear(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp, unsigned long fl)
 {
 	int ret = 0;
-	struct request_queue *q = bdev_get_queue(bdev)
+	struct request_queue *q = bdev_get_queue(bdev);
 	if (blk_queue_discard(q) && q->limits.discard_zeroes_data)
 		ret = blkdev_issue_discard(bdev, sector, nr_sects, gfp, fl);
 	else
-- 
1.6.6.1

