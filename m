Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab1IHMqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:46:22 -0400
Received: from mail09.linbit.com ([212.69.161.110]:37569 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718Ab1IHMpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:45:45 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 15/16] drbd: get rid of bio_split, allow bios of "arbitrary" size
Date: Thu,  8 Sep 2011 14:45:36 +0200
Message-Id: <1315485937-18989-16-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315485937-18989-1-git-send-email-philipp.reisner@linbit.com>
References: <1315485937-18989-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Where "arbitrary" size is currently 1 MiB, which is the BIO_MAX_SIZE
for architectures with 4k PAGE_CACHE_SIZE (most).

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h |   20 ++++++---
 drivers/block/drbd/drbd_req.c |   92 ++++++----------------------------------
 2 files changed, 28 insertions(+), 84 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 218e2c3..54eb96a 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1326,8 +1326,16 @@ struct bm_extent {
 #endif
 #endif
 
-#define HT_SHIFT 8
-#define DRBD_MAX_BIO_SIZE (1U<<(9+HT_SHIFT))
+/* BIO_MAX_SIZE is 256 * PAGE_CACHE_SIZE,
+ * so for typical PAGE_CACHE_SIZE of 4k, that is (1<<20) Byte.
+ * Since we may live in a mixed-platform cluster,
+ * we limit us to a platform agnostic constant here for now.
+ * A followup commit may allow even bigger BIO sizes,
+ * once we thought that through. */
+#define DRBD_MAX_BIO_SIZE (1 << 20)
+#if DRBD_MAX_BIO_SIZE > BIO_MAX_SIZE
+#error Architecture not supported: DRBD_MAX_BIO_SIZE > BIO_MAX_SIZE
+#endif
 #define DRBD_MAX_BIO_SIZE_SAFE (1 << 12)       /* Works always = 4k */
 
 #define DRBD_MAX_SIZE_H80_PACKET (1 << 15) /* The old header only allows packets up to 32Kib data */
@@ -2231,20 +2239,20 @@ static inline bool may_inc_ap_bio(struct drbd_conf *mdev)
 	return true;
 }
 
-static inline bool inc_ap_bio_cond(struct drbd_conf *mdev, int count)
+static inline bool inc_ap_bio_cond(struct drbd_conf *mdev)
 {
 	bool rv = false;
 
 	spin_lock_irq(&mdev->tconn->req_lock);
 	rv = may_inc_ap_bio(mdev);
 	if (rv)
-		atomic_add(count, &mdev->ap_bio_cnt);
+		atomic_inc(&mdev->ap_bio_cnt);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	return rv;
 }
 
-static inline void inc_ap_bio(struct drbd_conf *mdev, int count)
+static inline void inc_ap_bio(struct drbd_conf *mdev)
 {
 	/* we wait here
 	 *    as long as the device is suspended
@@ -2254,7 +2262,7 @@ static inline void inc_ap_bio(struct drbd_conf *mdev, int count)
 	 * to avoid races with the reconnect code,
 	 * we need to atomic_inc within the spinlock. */
 
-	wait_event(mdev->misc_wait, inc_ap_bio_cond(mdev, count));
+	wait_event(mdev->misc_wait, inc_ap_bio_cond(mdev));
 }
 
 static inline void dec_ap_bio(struct drbd_conf *mdev)
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 4406d82..6e0e3bb 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -998,7 +998,6 @@ fail_and_free_req:
 
 int drbd_make_request(struct request_queue *q, struct bio *bio)
 {
-	unsigned int s_enr, e_enr;
 	struct drbd_conf *mdev = (struct drbd_conf *) q->queuedata;
 	unsigned long start_time;
 
@@ -1010,93 +1009,30 @@ int drbd_make_request(struct request_queue *q, struct bio *bio)
 	D_ASSERT(bio->bi_size > 0);
 	D_ASSERT(IS_ALIGNED(bio->bi_size, 512));
 
-	/* to make some things easier, force alignment of requests within the
-	 * granularity of our hash tables */
-	s_enr = bio->bi_sector >> HT_SHIFT;
-	e_enr = (bio->bi_sector+(bio->bi_size>>9)-1) >> HT_SHIFT;
-
-	if (likely(s_enr == e_enr)) {
-		inc_ap_bio(mdev, 1);
-		return __drbd_make_request(mdev, bio, start_time);
-	}
-
-	/* can this bio be split generically?
-	 * Maybe add our own split-arbitrary-bios function. */
-	if (bio->bi_vcnt != 1 || bio->bi_idx != 0 || bio->bi_size > DRBD_MAX_BIO_SIZE) {
-		/* rather error out here than BUG in bio_split */
-		dev_err(DEV, "bio would need to, but cannot, be split: "
-		    "(vcnt=%u,idx=%u,size=%u,sector=%llu)\n",
-		    bio->bi_vcnt, bio->bi_idx, bio->bi_size,
-		    (unsigned long long)bio->bi_sector);
-		bio_endio(bio, -EINVAL);
-	} else {
-		/* This bio crosses some boundary, so we have to split it. */
-		struct bio_pair *bp;
-		/* works for the "do not cross hash slot boundaries" case
-		 * e.g. sector 262269, size 4096
-		 * s_enr = 262269 >> 6 = 4097
-		 * e_enr = (262269+8-1) >> 6 = 4098
-		 * HT_SHIFT = 6
-		 * sps = 64, mask = 63
-		 * first_sectors = 64 - (262269 & 63) = 3
-		 */
-		const sector_t sect = bio->bi_sector;
-		const int sps = 1 << HT_SHIFT; /* sectors per slot */
-		const int mask = sps - 1;
-		const sector_t first_sectors = sps - (sect & mask);
-		bp = bio_split(bio, first_sectors);
-
-		/* we need to get a "reference count" (ap_bio_cnt)
-		 * to avoid races with the disconnect/reconnect/suspend code.
-		 * In case we need to split the bio here, we need to get three references
-		 * atomically, otherwise we might deadlock when trying to submit the
-		 * second one! */
-		inc_ap_bio(mdev, 3);
-
-		D_ASSERT(e_enr == s_enr + 1);
-
-		while (__drbd_make_request(mdev, &bp->bio1, start_time))
-			inc_ap_bio(mdev, 1);
-
-		while (__drbd_make_request(mdev, &bp->bio2, start_time))
-			inc_ap_bio(mdev, 1);
-
-		dec_ap_bio(mdev);
-
-		bio_pair_release(bp);
-	}
-	return 0;
+	inc_ap_bio(mdev);
+	return __drbd_make_request(mdev, bio, start_time);
 }
 
-/* This is called by bio_add_page().  With this function we reduce
- * the number of BIOs that span over multiple DRBD_MAX_BIO_SIZEs
- * units (was AL_EXTENTs).
+/* This is called by bio_add_page().
+ *
+ * q->max_hw_sectors and other global limits are already enforced there.
  *
- * we do the calculation within the lower 32bit of the byte offsets,
- * since we don't care for actual offset, but only check whether it
- * would cross "activity log extent" boundaries.
+ * We need to call down to our lower level device,
+ * in case it has special restrictions.
+ *
+ * We also may need to enforce configured max-bio-bvecs limits.
  *
  * As long as the BIO is empty we have to allow at least one bvec,
- * regardless of size and offset.  so the resulting bio may still
- * cross extent boundaries.  those are dealt with (bio_split) in
- * drbd_make_request.
+ * regardless of size and offset, so no need to ask lower levels.
  */
 int drbd_merge_bvec(struct request_queue *q, struct bvec_merge_data *bvm, struct bio_vec *bvec)
 {
 	struct drbd_conf *mdev = (struct drbd_conf *) q->queuedata;
-	unsigned int bio_offset =
-		(unsigned int)bvm->bi_sector << 9; /* 32 bit */
 	unsigned int bio_size = bvm->bi_size;
-	int limit, backing_limit;
-
-	limit = DRBD_MAX_BIO_SIZE
-	      - ((bio_offset & (DRBD_MAX_BIO_SIZE-1)) + bio_size);
-	if (limit < 0)
-		limit = 0;
-	if (bio_size == 0) {
-		if (limit <= bvec->bv_len)
-			limit = bvec->bv_len;
-	} else if (limit && get_ldev(mdev)) {
+	int limit = DRBD_MAX_BIO_SIZE;
+	int backing_limit;
+
+	if (bio_size && get_ldev(mdev)) {
 		struct request_queue * const b =
 			mdev->ldev->backing_bdev->bd_disk->queue;
 		if (b->merge_bvec_fn) {
-- 
1.7.4.1

