Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab0HYP7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 11:59:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:52905 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526Ab0HYPyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 11:54:09 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        jeremy@goop.org, snitzer@redhat.com, k-ueda@ct.jp.nec.com
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 29/30] block: remove the BLKDEV_IFL_BARRIER flag
Date: Wed, 25 Aug 2010 17:47:46 +0200
Message-Id: <1282751267-3530-30-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1282751267-3530-1-git-send-email-tj@kernel.org>
References: <1282751267-3530-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 25 Aug 2010 15:53:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

Remove support for barriers on discards, which is unused now.  Also
remove the DISCARD_NOBARRIER I/O type in favour of just setting the
rw flags up locally in blkdev_issue_discard.

tj: Also remove DISCARD_SECURE and use REQ_SECURE directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-lib.c        |   18 ++----------------
 include/linux/blkdev.h |    2 --
 include/linux/fs.h     |    8 --------
 3 files changed, 2 insertions(+), 26 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index c392029..fe2e6ed 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -39,8 +39,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request_queue *q = bdev_get_queue(bdev);
-	int type = flags & BLKDEV_IFL_BARRIER ?
-		DISCARD_BARRIER : DISCARD_NOBARRIER;
+	int type = REQ_WRITE | REQ_DISCARD;
 	unsigned int max_discard_sectors;
 	struct bio *bio;
 	int ret = 0;
@@ -65,7 +64,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	if (flags & BLKDEV_IFL_SECURE) {
 		if (!blk_queue_secdiscard(q))
 			return -EOPNOTSUPP;
-		type |= DISCARD_SECURE;
+		type |= REQ_SECURE;
 	}
 
 	while (nr_sects && !ret) {
@@ -162,12 +161,6 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 	bb.wait = &wait;
 	bb.end_io = NULL;
 
-	if (flags & BLKDEV_IFL_BARRIER) {
-		/* issue async barrier before the data */
-		ret = blkdev_issue_flush(bdev, gfp_mask, NULL, 0);
-		if (ret)
-			return ret;
-	}
 submit:
 	ret = 0;
 	while (nr_sects != 0) {
@@ -199,13 +192,6 @@ submit:
 		issued++;
 		submit_bio(WRITE, bio);
 	}
-	/*
-	 * When all data bios are in flight. Send final barrier if requeted.
-	 */
-	if (nr_sects == 0 && flags & BLKDEV_IFL_BARRIER)
-		ret = blkdev_issue_flush(bdev, gfp_mask, NULL,
-					flags & BLKDEV_IFL_WAIT);
-
 
 	if (flags & BLKDEV_IFL_WAIT)
 		/* Wait for bios in-flight */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6b305eb..cfcb3a6 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -869,11 +869,9 @@ static inline struct request *blk_map_queue_find_tag(struct blk_queue_tag *bqt,
 }
 enum{
 	BLKDEV_WAIT,	/* wait for completion */
-	BLKDEV_BARRIER,	/* issue request with barrier */
 	BLKDEV_SECURE,	/* secure discard */
 };
 #define BLKDEV_IFL_WAIT		(1 << BLKDEV_WAIT)
-#define BLKDEV_IFL_BARRIER	(1 << BLKDEV_BARRIER)
 #define BLKDEV_IFL_SECURE	(1 << BLKDEV_SECURE)
 extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *,
 			unsigned long);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 352c486..32703a9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -166,14 +166,6 @@ struct inodes_stat_t {
 #define WRITE_FLUSH_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG | \
 				 REQ_FLUSH | REQ_FUA)
 
-/*
- * These aren't really reads or writes, they pass down information about
- * parts of device that are now unused by the file system.
- */
-#define DISCARD_NOBARRIER	(WRITE | REQ_DISCARD)
-#define DISCARD_BARRIER		(WRITE | REQ_DISCARD | REQ_HARDBARRIER)
-#define DISCARD_SECURE		(DISCARD_NOBARRIER | REQ_SECURE)
-
 #define SEL_IN		1
 #define SEL_OUT		2
 #define SEL_EX		4
-- 
1.7.1

