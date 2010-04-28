Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab0D1NzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 09:55:23 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:48730 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab0D1NzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 09:55:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=kI3hQp58UmK1bDtnZ8aiqmoMxieWy28Q+pmCWRgXde4zMw9HYcQ8YSVq8F66EztCKF
         +Inyx8PCnxhLK6Ku/EixyxpK17GL8HAWaTprMky2nWKkrzttV/0LjFmBXuLfPtzAeKRC
         CE52u6z7VFXCrSUVt9+ADGedyhRZs0y3AjBlo=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, hch@infradead.org,
       Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 4/4] blkdev: add blkdev_issue_zeroout helper function
Date: Wed, 28 Apr 2010 17:55:09 +0400
Message-Id: <1272462909-12942-5-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272462909-12942-4-git-send-email-dmonakhov@openvz.org>
References: <20100426172651.GT27497@kernel.dk>
 <1272462909-12942-1-git-send-email-dmonakhov@openvz.org>
 <1272462909-12942-2-git-send-email-dmonakhov@openvz.org>
 <1272462909-12942-3-git-send-email-dmonakhov@openvz.org>
 <1272462909-12942-4-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Add bio_batch helper primitive. This is rather generic primitive
  for submitting/waiting a complex request which consists of several
  bios.
- blkdev_issue_zeroout() generate number of zero filed write bios.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 block/blk-lib.c        |  118 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |    3 +-
 2 files changed, 120 insertions(+), 1 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 0dc4388..886c3f9 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -112,3 +112,121 @@ out:
 	return -ENOMEM;
 }
 EXPORT_SYMBOL(blkdev_issue_discard);
+
+struct bio_batch
+{
+	atomic_t 		done;
+	unsigned long 		flags;
+	struct completion 	*wait;
+	bio_end_io_t		*end_io;
+};
+
+static void bio_batch_end_io(struct bio *bio, int err)
+{
+	struct bio_batch *bb = bio->bi_private;
+	if (err) {
+		if (err == -EOPNOTSUPP)
+			set_bit(BIO_EOPNOTSUPP, &bb->flags);
+		else
+			clear_bit(BIO_UPTODATE, &bb->flags);
+	}
+	if (bb) {
+		if (bb->end_io)
+			bb->end_io(bio, err);
+		atomic_inc(&bb->done);
+		complete(bb->wait);
+	}
+	bio_put(bio);
+}
+
+/**
+ * blkdev_issue_zeroout generate number of zero filed write bios
+ * @bdev:	blockdev to issue
+ * @sector:	start sector
+ * @nr_sects:	number of sectors to write
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ * @flags:	BLKDEV_IFL_* flags to control behaviour
+ *
+ * Description:
+ *  Generate and issue number of bios with zerofiled pages.
+ *  Send barrier at the beginning and at the end if requested. This guarantie
+ *  correct request ordering. Empty barrier allow us to avoid post queue flush.
+ */
+
+int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
+			sector_t nr_sects, gfp_t gfp_mask, unsigned long flags)
+{
+	int ret = 0;
+	struct bio *bio;
+	struct bio_batch bb;
+	unsigned int sz, issued = 0;
+	DECLARE_COMPLETION_ONSTACK(wait);
+
+	atomic_set(&bb.done, 0);
+	bb.flags = 1 << BIO_UPTODATE;
+	bb.wait = &wait;
+	bb.end_io = NULL;
+
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
+		if (!bio)
+			break;
+
+		bio->bi_sector = sector;
+		bio->bi_bdev   = bdev;
+		bio->bi_end_io = bio_batch_end_io;
+		if (flags & BLKDEV_IFL_WAIT)
+			bio->bi_private = &bb;
+
+		while(nr_sects != 0) {
+			sz = min(PAGE_SIZE >> 9 , nr_sects);
+			if (sz == 0)
+				/* bio has maximum size possible */
+				break;
+			ret = bio_add_page(bio, ZERO_PAGE(0), sz << 9, 0);
+			nr_sects -= ret >> 9;
+			sector += ret >> 9;
+			if (ret < (sz << 9))
+				break;
+		}
+		issued++;
+		submit_bio(WRITE, bio);
+	}
+	/*
+	 * When all data bios are in flight. Send final barrier if requeted.
+	 */
+	if (nr_sects == 0 && flags & BLKDEV_IFL_BARRIER)
+		ret = blkdev_issue_flush(bdev, gfp_mask, NULL,
+					flags & BLKDEV_IFL_WAIT);
+
+
+	if (flags & BLKDEV_IFL_WAIT)
+		/* Wait for bios in-flight */
+		while ( issued != atomic_read(&bb.done))
+			wait_for_completion(&wait);
+
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
+	}
+	if (nr_sects != 0)
+		goto submit;
+out:
+	return ret;
+}
+EXPORT_SYMBOL(blkdev_issue_zeroout);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 59b9aed..3ac2bd2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1008,7 +1008,8 @@ extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *,
 			unsigned long);
 extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
-
+extern int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
+			sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
 static inline int sb_issue_discard(struct super_block *sb,
 				   sector_t block, sector_t nr_blocks)
 {
-- 
1.6.6.1

