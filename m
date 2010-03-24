Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab0CXRaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:30:19 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:57949 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335Ab0CXRaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:30:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=GGc6XO73b/2Zpbpr0/f/44gnNDzxGuI2C+ofedA/37Ir2mYTnwWD2/5sxXIV+RwUui
         KrJQ3HjdEyjxVUUycQcpiru8uAq0qPgx4imcs/qBTdJG6pQqCw+aB/oaStWJQZ5U9HsW
         LcdjpTh1TW4HS4ohymxEuERl0wq/DHiLMf/CE=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, hch@infradead.org, mkp@mkp.net,
       Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 4/5] blkdev: add discard payload flag
Date: Wed, 24 Mar 2010 20:29:50 +0300
Message-Id: <1269451792-5205-5-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1269451792-5205-4-git-send-email-dmonakhov@openvz.org>
References: <1269451792-5205-1-git-send-email-dmonakhov@openvz.org>
 <1269451792-5205-2-git-send-email-dmonakhov@openvz.org>
 <1269451792-5205-3-git-send-email-dmonakhov@openvz.org>
 <1269451792-5205-4-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all implementations require discard bio to be filled with one-sector
sized payload. Let's allocate payload only when necessary.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 block/blk-lib.c        |   24 +++++++++++++-----------
 drivers/scsi/sd.c      |    1 +
 include/linux/blkdev.h |    5 ++++-
 3 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 67b641e..321d150 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -184,17 +184,19 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		if (flags & BLKDEV_IFL_BARRIER)
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
+		if (blk_queue_discard_mem(q)) {
+			/*
+			 * Add a zeroed one-sector payload as that's what
+			 * our current implementations need.  If we'll ever
+			 * need more the interface will need revisiting.
+			 */
+			page = alloc_page(gfp_mask | __GFP_ZERO);
+			if (!page)
+				goto out_free_bio;
+			if (bio_add_pc_page(q, bio, page, sector_size, 0) <
+				sector_size)
+				goto out_free_page;
+		}
 		/*
 		 * And override the bio size - the way discard works we
 		 * touch many more blocks on disk than the actual payload
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 1dd4d84..9994977 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1513,6 +1513,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 			q->limits.discard_zeroes_data = 1;
 
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
+		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD_MEM, q);
 	}
 
 	sdkp->capacity = lba + 1;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 78180b7..e232a0d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -461,7 +461,8 @@ struct request_queue
 #define QUEUE_FLAG_VIRT        QUEUE_FLAG_NONROT /* paravirt device */
 #define QUEUE_FLAG_IO_STAT     15	/* do IO stats */
 #define QUEUE_FLAG_DISCARD     16	/* supports DISCARD */
-#define QUEUE_FLAG_NOXMERGES   17	/* No extended merges */
+#define QUEUE_FLAG_DISCARD_MEM 17	/* require memory in DISCARD request*/
+#define QUEUE_FLAG_NOXMERGES   18	/* No extended merges */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_CLUSTER) |		\
@@ -595,6 +596,8 @@ enum {
 #define blk_queue_stackable(q)	\
 	test_bit(QUEUE_FLAG_STACKABLE, &(q)->queue_flags)
 #define blk_queue_discard(q)	test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_flags)
+#define blk_queue_discard_mem(q) \
+	test_bit(QUEUE_FLAG_DISCARD_MEM, &(q)->queue_flags)
 
 #define blk_fs_request(rq)	((rq)->cmd_type == REQ_TYPE_FS)
 #define blk_pc_request(rq)	((rq)->cmd_type == REQ_TYPE_BLOCK_PC)
-- 
1.6.6.1

