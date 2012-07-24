Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab2GXUMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 16:12:15 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41035 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792Ab2GXUMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 16:12:05 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com,
        bharrosh@panasas.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: [PATCH v4 09/12] block: Rework bio_pair_split()
Date: Tue, 24 Jul 2012 13:11:26 -0700
Message-Id: <1343160689-12378-10-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1343160689-12378-1-git-send-email-koverstreet@google.com>
References: <1343160689-12378-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes bio_pair_split() to use the new bio_split() underneath,
which gets rid of the single page bio limitation. The various callers
are fixed up for the slightly different struct bio_pair, and to remove
the unnecessary checks.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 drivers/block/drbd/drbd_req.c |   16 +-------
 drivers/block/pktcdvd.c       |    4 +-
 drivers/block/rbd.c           |    7 ++--
 drivers/md/linear.c           |    4 +-
 drivers/md/raid0.c            |    6 ++--
 drivers/md/raid10.c           |   21 ++---------
 fs/bio-integrity.c            |   44 -----------------------
 fs/bio.c                      |   78 ++++++++++++----------------------------
 include/linux/bio.h           |   25 +++++--------
 9 files changed, 50 insertions(+), 155 deletions(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index b5cfa3b..fea4a40 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1123,18 +1123,6 @@ void drbd_make_request(struct request_queue *q, struct bio *bio)
 		do {
 			inc_ap_bio(mdev, 1);
 		} while (drbd_make_request_common(mdev, bio, start_time));
-		return;
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
 	} else {
 		/* This bio crosses some boundary, so we have to split it. */
 		struct bio_pair *bp;
@@ -1161,10 +1149,10 @@ void drbd_make_request(struct request_queue *q, struct bio *bio)
 
 		D_ASSERT(e_enr == s_enr + 1);
 
-		while (drbd_make_request_common(mdev, &bp->bio1, start_time))
+		while (drbd_make_request_common(mdev, &bp->split, start_time))
 			inc_ap_bio(mdev, 1);
 
-		while (drbd_make_request_common(mdev, &bp->bio2, start_time))
+		while (drbd_make_request_common(mdev, bio, start_time))
 			inc_ap_bio(mdev, 1);
 
 		dec_ap_bio(mdev);
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 12a14c0..1465155 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2469,8 +2469,8 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 			first_sectors = last_zone - bio->bi_sector;
 			bp = bio_pair_split(bio, first_sectors);
 			BUG_ON(!bp);
-			pkt_make_request(q, &bp->bio1);
-			pkt_make_request(q, &bp->bio2);
+			pkt_make_request(q, &bp->split);
+			pkt_make_request(q, bio);
 			bio_pair_release(bp);
 			return;
 		}
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index e33c224..692cf05 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -732,14 +732,13 @@ static struct bio *bio_chain_clone(struct bio **old, struct bio **next,
 
 			/* split the bio. We'll release it either in the next
 			   call, or it will have to be released outside */
-			bp = bio_pair_split(old_chain,
-					    (len - total) / SECTOR_SIZE);
+			bp = bio_pair_split(old_chain, (len - total) / SECTOR_SIZE);
 			if (!bp)
 				goto err_out;
 
-			__bio_clone(tmp, &bp->bio1);
+			__bio_clone(tmp, &bp->split);
 
-			*next = &bp->bio2;
+			*next = bp->orig;
 		} else {
 			__bio_clone(tmp, old_chain);
 			*next = old_chain->bi_next;
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index e860cb9..7c6cafd 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -316,8 +316,8 @@ static void linear_make_request(struct mddev *mddev, struct bio *bio)
 
 		bp = bio_pair_split(bio, end_sector - bio->bi_sector);
 
-		linear_make_request(mddev, &bp->bio1);
-		linear_make_request(mddev, &bp->bio2);
+		linear_make_request(mddev, &bp->split);
+		linear_make_request(mddev, bio);
 		bio_pair_release(bp);
 		return;
 	}
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index c89c8aa..3469adf 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -520,9 +520,9 @@ static void raid0_make_request(struct mddev *mddev, struct bio *bio)
 							   (chunk_sects-1)));
 		else
 			bp = bio_pair_split(bio, chunk_sects -
-					    sector_div(sector, chunk_sects));
-		raid0_make_request(mddev, &bp->bio1);
-		raid0_make_request(mddev, &bp->bio2);
+				       sector_div(sector, chunk_sects));
+		raid0_make_request(mddev, &bp->split);
+		raid0_make_request(mddev, bio);
 		bio_pair_release(bp);
 		return;
 	}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index be75924..1a67a78 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1056,15 +1056,9 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 		     && (conf->geo.near_copies < conf->geo.raid_disks
 			 || conf->prev.near_copies < conf->prev.raid_disks))) {
 		struct bio_pair *bp;
-		/* Sanity check -- queue functions should prevent this happening */
-		if (bio->bi_vcnt != 1 ||
-		    bio->bi_idx != 0)
-			goto bad_map;
-		/* This is a one page bio that upper layers
-		 * refuse to split for us, so we need to split it.
-		 */
+
 		bp = bio_pair_split(bio,
-				    chunk_sects - (bio->bi_sector & (chunk_sects - 1)) );
+				    chunk_sects - (bio->bi_sector & (chunk_sects - 1)));
 
 		/* Each of these 'make_request' calls will call 'wait_barrier'.
 		 * If the first succeeds but the second blocks due to the resync
@@ -1078,8 +1072,8 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 		conf->nr_waiting++;
 		spin_unlock_irq(&conf->resync_lock);
 
-		make_request(mddev, &bp->bio1);
-		make_request(mddev, &bp->bio2);
+		make_request(mddev, &bp->split);
+		make_request(mddev, bio);
 
 		spin_lock_irq(&conf->resync_lock);
 		conf->nr_waiting--;
@@ -1088,13 +1082,6 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 
 		bio_pair_release(bp);
 		return;
-	bad_map:
-		printk("md/raid10:%s: make_request bug: can't convert block across chunks"
-		       " or bigger than %dk %llu %d\n", mdname(mddev), chunk_sects/2,
-		       (unsigned long long)bio->bi_sector, bio->bi_size >> 10);
-
-		bio_io_error(bio);
-		return;
 	}
 
 	md_write_start(mddev, bio);
diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index e85c04b..9ed2c44 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -682,50 +682,6 @@ void bio_integrity_trim(struct bio *bio, unsigned int offset,
 EXPORT_SYMBOL(bio_integrity_trim);
 
 /**
- * bio_integrity_split - Split integrity metadata
- * @bio:	Protected bio
- * @bp:		Resulting bio_pair
- * @sectors:	Offset
- *
- * Description: Splits an integrity page into a bio_pair.
- */
-void bio_integrity_split(struct bio *bio, struct bio_pair *bp, int sectors)
-{
-	struct blk_integrity *bi;
-	struct bio_integrity_payload *bip = bio->bi_integrity;
-	unsigned int nr_sectors;
-
-	if (bio_integrity(bio) == 0)
-		return;
-
-	bi = bdev_get_integrity(bio->bi_bdev);
-	BUG_ON(bi == NULL);
-	BUG_ON(bip->bip_vcnt != 1);
-
-	nr_sectors = bio_integrity_hw_sectors(bi, sectors);
-
-	bp->bio1.bi_integrity = &bp->bip1;
-	bp->bio2.bi_integrity = &bp->bip2;
-
-	bp->iv1 = bip->bip_vec[0];
-	bp->iv2 = bip->bip_vec[0];
-
-	bp->bip1.bip_vec[0] = bp->iv1;
-	bp->bip2.bip_vec[0] = bp->iv2;
-
-	bp->iv1.bv_len = sectors * bi->tuple_size;
-	bp->iv2.bv_offset += sectors * bi->tuple_size;
-	bp->iv2.bv_len -= sectors * bi->tuple_size;
-
-	bp->bip1.bip_sector = bio->bi_integrity->bip_sector;
-	bp->bip2.bip_sector = bio->bi_integrity->bip_sector + nr_sectors;
-
-	bp->bip1.bip_vcnt = bp->bip2.bip_vcnt = 1;
-	bp->bip1.bip_idx = bp->bip2.bip_idx = 0;
-}
-EXPORT_SYMBOL(bio_integrity_split);
-
-/**
  * bio_integrity_clone - Callback for cloning bios with integrity metadata
  * @bio:	New bio
  * @bio_src:	Original bio
diff --git a/fs/bio.c b/fs/bio.c
index a15e121..fa6dee4 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -37,7 +37,7 @@
  */
 #define BIO_INLINE_VECS		4
 
-static mempool_t *bio_split_pool __read_mostly;
+static struct bio_set *bio_split_pool __read_mostly;
 
 /*
  * if you change this list, also change bvec_alloc or things will
@@ -1462,77 +1462,48 @@ EXPORT_SYMBOL(bio_endio);
 void bio_pair_release(struct bio_pair *bp)
 {
 	if (atomic_dec_and_test(&bp->cnt)) {
-		struct bio *master = bp->bio1.bi_private;
+		bp->orig->bi_end_io = bp->bi_end_io;
+		bp->orig->bi_private = bp->bi_private;
 
-		bio_endio(master, bp->error);
-		mempool_free(bp, bp->bio2.bi_private);
+		bio_endio(bp->orig, 0);
+		bio_put(&bp->split);
 	}
 }
 EXPORT_SYMBOL(bio_pair_release);
 
-static void bio_pair_end_1(struct bio *bi, int err)
+static void bio_pair_end(struct bio *bio, int error)
 {
-	struct bio_pair *bp = container_of(bi, struct bio_pair, bio1);
+	struct bio_pair *bp = bio->bi_private;
 
-	if (err)
-		bp->error = err;
+	if (error)
+		clear_bit(BIO_UPTODATE, &bp->orig->bi_flags);
 
 	bio_pair_release(bp);
 }
 
-static void bio_pair_end_2(struct bio *bi, int err)
+struct bio_pair *bio_pair_split(struct bio *bio, int first_sectors)
 {
-	struct bio_pair *bp = container_of(bi, struct bio_pair, bio2);
-
-	if (err)
-		bp->error = err;
-
-	bio_pair_release(bp);
-}
+	struct bio_pair *bp;
+	struct bio *split = bio_split(bio, first_sectors,
+				      GFP_NOIO, bio_split_pool);
 
-/*
- * split a bio - only worry about a bio with a single page in its iovec
- */
-struct bio_pair *bio_pair_split(struct bio *bi, int first_sectors)
-{
-	struct bio_pair *bp = mempool_alloc(bio_split_pool, GFP_NOIO);
+	if (!split)
+		return NULL;
 
-	if (!bp)
-		return bp;
+	BUG_ON(split == bio);
 
-	trace_block_split(bdev_get_queue(bi->bi_bdev), bi,
-				bi->bi_sector + first_sectors);
+	bp = container_of(split, struct bio_pair, split);
 
-	BUG_ON(bi->bi_vcnt != 1);
-	BUG_ON(bi->bi_idx != 0);
 	atomic_set(&bp->cnt, 3);
-	bp->error = 0;
-	bp->bio1 = *bi;
-	bp->bio2 = *bi;
-	bp->bio2.bi_sector += first_sectors;
-	bp->bio2.bi_size -= first_sectors << 9;
-	bp->bio1.bi_size = first_sectors << 9;
-
-	bp->bv1 = bi->bi_io_vec[0];
-	bp->bv2 = bi->bi_io_vec[0];
-	bp->bv2.bv_offset += first_sectors << 9;
-	bp->bv2.bv_len -= first_sectors << 9;
-	bp->bv1.bv_len = first_sectors << 9;
-
-	bp->bio1.bi_io_vec = &bp->bv1;
-	bp->bio2.bi_io_vec = &bp->bv2;
-
-	bp->bio1.bi_max_vecs = 1;
-	bp->bio2.bi_max_vecs = 1;
 
-	bp->bio1.bi_end_io = bio_pair_end_1;
-	bp->bio2.bi_end_io = bio_pair_end_2;
+	bp->bi_end_io = bio->bi_end_io;
+	bp->bi_private = bio->bi_private;
 
-	bp->bio1.bi_private = bi;
-	bp->bio2.bi_private = bio_split_pool;
+	bio->bi_private = bp;
+	bio->bi_end_io = bio_pair_end;
 
-	if (bio_integrity(bi))
-		bio_integrity_split(bi, bp, first_sectors);
+	split->bi_private = bp;
+	split->bi_end_io = bio_pair_end;
 
 	return bp;
 }
@@ -1846,8 +1817,7 @@ static int __init init_bio(void)
 	if (bioset_integrity_create(fs_bio_set, BIO_POOL_SIZE))
 		panic("bio: can't create integrity pool\n");
 
-	bio_split_pool = mempool_create_kmalloc_pool(BIO_SPLIT_ENTRIES,
-						     sizeof(struct bio_pair));
+	bio_split_pool = bioset_create(BIO_POOL_SIZE, offsetof(struct bio_pair, split));
 	if (!bio_split_pool)
 		panic("bio: can't create split pool\n");
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index fdcc8dc..9720544 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -192,15 +192,17 @@ struct bio_integrity_payload {
  *   in bio2.bi_private
  */
 struct bio_pair {
-	struct bio			bio1, bio2;
-	struct bio_vec			bv1, bv2;
-#if defined(CONFIG_BLK_DEV_INTEGRITY)
-	struct bio_integrity_payload	bip1, bip2;
-	struct bio_vec			iv1, iv2;
-#endif
-	atomic_t			cnt;
-	int				error;
+	atomic_t		cnt;
+
+	bio_end_io_t		*bi_end_io;
+	void			*bi_private;
+
+	struct bio		*orig;
+	struct bio		split;
 };
+
+extern struct bio *bio_split(struct bio *bio, int sectors,
+			     gfp_t gfp, struct bio_set *bs);
 extern struct bio_pair *bio_pair_split(struct bio *bi, int first_sectors);
 extern void bio_pair_release(struct bio_pair *dbio);
 
@@ -512,7 +514,6 @@ extern int bio_integrity_prep(struct bio *);
 extern void bio_integrity_endio(struct bio *, int);
 extern void bio_integrity_advance(struct bio *, unsigned int);
 extern void bio_integrity_trim(struct bio *, unsigned int, unsigned int);
-extern void bio_integrity_split(struct bio *, struct bio_pair *, int);
 extern int bio_integrity_clone(struct bio *, struct bio *, gfp_t, struct bio_set *);
 extern int bioset_integrity_create(struct bio_set *, int);
 extern void bioset_integrity_free(struct bio_set *);
@@ -556,12 +557,6 @@ static inline int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 	return 0;
 }
 
-static inline void bio_integrity_split(struct bio *bio, struct bio_pair *bp,
-				       int sectors)
-{
-	return;
-}
-
 static inline void bio_integrity_advance(struct bio *bio,
 					 unsigned int bytes_done)
 {
-- 
1.7.7.3

