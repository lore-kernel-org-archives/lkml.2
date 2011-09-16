Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab1IPJmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 05:42:08 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:57065 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753130Ab1IPJmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 05:42:06 -0400
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Shaohua Li <shaohua.li@intel.com>, Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [PATCH] block: Remove the control of complete cpu from bio.
Date: Fri, 16 Sep 2011 17:41:48 +0800
Message-Id: <1316166108-6465-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.4.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

bio originally has the functionality to set the complete cpu, but
it is broken.

Chirstoph said that "This code is unused, and from the all the
discussions lately pretty obviously broken.  The only thing keeping
it serves is creating more confusion and possibly more bugs."

And Jens replied with "We can kill bio_set_completion_cpu(). I'm fine
with leaving cpu control to the request based drivers, they are the
only ones that can toggle the setting anyway".

So this patch tries to remove all the work of controling complete cpu
from a bio.

Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 block/blk-core.c          |    4 +---
 drivers/md/raid1.c        |    1 -
 fs/bio.c                  |    1 -
 include/linux/bio.h       |    8 --------
 include/linux/blk_types.h |   11 ++++-------
 5 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 90e1ffd..8a57916 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1200,7 +1200,6 @@ out:
 
 void init_request_from_bio(struct request *req, struct bio *bio)
 {
-	req->cpu = bio->bi_comp_cpu;
 	req->cmd_type = REQ_TYPE_FS;
 
 	req->cmd_flags |= bio->bi_rw & REQ_COMMON_MASK;
@@ -1281,8 +1280,7 @@ get_rq:
 	 */
 	init_request_from_bio(req, bio);
 
-	if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags) ||
-	    bio_flagged(bio, BIO_CPU_AFFINE))
+	if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags))
 		req->cpu = raw_smp_processor_id();
 
 	plug = current->plug;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 32323f0..3107bcc 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2170,7 +2170,6 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 		bio->bi_next = NULL;
 		bio->bi_flags &= ~(BIO_POOL_MASK-1);
 		bio->bi_flags |= 1 << BIO_UPTODATE;
-		bio->bi_comp_cpu = -1;
 		bio->bi_rw = READ;
 		bio->bi_vcnt = 0;
 		bio->bi_idx = 0;
diff --git a/fs/bio.c b/fs/bio.c
index 9bfade8..41c93c7 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -255,7 +255,6 @@ void bio_init(struct bio *bio)
 {
 	memset(bio, 0, sizeof(*bio));
 	bio->bi_flags = 1 << BIO_UPTODATE;
-	bio->bi_comp_cpu = -1;
 	atomic_set(&bio->bi_cnt, 1);
 }
 EXPORT_SYMBOL(bio_init);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index ce33e68..a3c071c 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -269,14 +269,6 @@ extern void bvec_free_bs(struct bio_set *, struct bio_vec *, unsigned int);
 extern unsigned int bvec_nr_vecs(unsigned short idx);
 
 /*
- * Allow queuer to specify a completion CPU for this bio
- */
-static inline void bio_set_completion_cpu(struct bio *bio, unsigned int cpu)
-{
-	bio->bi_comp_cpu = cpu;
-}
-
-/*
  * bio_set is used to allow other portions of the IO system to
  * allocate their own private memory pools for bio and iovec structures.
  * These memory pools in turn all allocate from the bio_slab
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 32f0076..174bc3a 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -59,8 +59,6 @@ struct bio {
 
 	unsigned int		bi_max_vecs;	/* max bvl_vecs we can hold */
 
-	unsigned int		bi_comp_cpu;	/* completion CPU */
-
 	atomic_t		bi_cnt;		/* pin count */
 
 	struct bio_vec		*bi_io_vec;	/* the actual vec list */
@@ -93,11 +91,10 @@ struct bio {
 #define BIO_BOUNCED	5	/* bio is a bounce bio */
 #define BIO_USER_MAPPED 6	/* contains user pages */
 #define BIO_EOPNOTSUPP	7	/* not supported */
-#define BIO_CPU_AFFINE	8	/* complete bio on same CPU as submitted */
-#define BIO_NULL_MAPPED 9	/* contains invalid user pages */
-#define BIO_FS_INTEGRITY 10	/* fs owns integrity data, not block layer */
-#define BIO_QUIET	11	/* Make BIO Quiet */
-#define BIO_MAPPED_INTEGRITY 12/* integrity metadata has been remapped */
+#define BIO_NULL_MAPPED 8	/* contains invalid user pages */
+#define BIO_FS_INTEGRITY 9	/* fs owns integrity data, not block layer */
+#define BIO_QUIET	10	/* Make BIO Quiet */
+#define BIO_MAPPED_INTEGRITY 11/* integrity metadata has been remapped */
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
 /*
-- 
1.7.1

