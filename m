Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab0DLNEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 09:04:39 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:43006 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab0DLNEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 09:04:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=N6GnzciwKppqb4BzUfCP4EQZL9gvmfP8yjpN11BsMnPkYTRlORuGFNoAKv91xvP6Ox
         8WE+S7pn0F18ALiVBE5Vj5rNLbGPiRhdceSUOIPe+t4qG/cySLYOH6YoLd2b/WVQqgi1
         NuS6TRFH1z9FjPpFScL43ZTh1huZwTp1ACO5I=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, hch@infradead.org,
       Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 4/4] patch blk-add-zeroout-helper.patch
Date: Mon, 12 Apr 2010 17:03:57 +0400
Message-Id: <1271077437-7921-5-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1271077437-7921-4-git-send-email-dmonakhov@openvz.org>
References: <1271077437-7921-1-git-send-email-dmonakhov@openvz.org>
 <1271077437-7921-2-git-send-email-dmonakhov@openvz.org>
 <1271077437-7921-3-git-send-email-dmonakhov@openvz.org>
 <1271077437-7921-4-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 block/blk-lib.c        |  118 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |    3 +-
 2 files changed, 120 insertions(+), 1 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index d7827e5..fa36030 100644
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
+ * __blkdev_issue_zeroout generate number of zero filed write bios
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
+int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
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
+EXPORT_SYMBOL(__blkdev_issue_zeroout);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index a222351..787edbb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1004,7 +1004,8 @@ extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *,
 			unsigned long);
 extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
-
+extern int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
+			sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
 static inline int sb_issue_discard(struct super_block *sb,
 				   sector_t block, sector_t nr_blocks)
 {
-- 
1.6.6.1

