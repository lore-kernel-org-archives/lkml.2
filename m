Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab2EJDIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 23:08:23 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:58574 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab2EJDIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 23:08:20 -0400
Date: Wed, 9 May 2012 23:08:13 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: tejun@google.com, agk@redhat.com
Subject: [Bcache v13 01/16] Only clone bio vecs that are in use
Message-ID: <cb817596299fecd01ea36e4a80203f23165bda75.1336619038.git.koverstreet@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1336619038.git.koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bcache creates large bios internally, and then splits them according to
the requirements of the underlying device. If the underlying device then
needs to clone the bio, the clone will fail if the original bio had more
than 256 segments - even if bi_vcnt - bi_idx was smaller.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 block/blk-core.c    |    2 +-
 drivers/block/rbd.c |    2 +-
 drivers/md/dm.c     |   27 ++++++++++-----------------
 drivers/md/md.c     |    3 ++-
 fs/bio.c            |   46 +++++++++++++++++++++++-----------------------
 include/linux/bio.h |    7 ++++++-
 6 files changed, 43 insertions(+), 44 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3a78b00..87fd3f1 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2659,7 +2659,7 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 	blk_rq_init(NULL, rq);
 
 	__rq_for_each_bio(bio_src, rq_src) {
-		bio = bio_alloc_bioset(gfp_mask, bio_src->bi_max_vecs, bs);
+		bio = bio_alloc_bioset(gfp_mask, bio_segments(bio_src), bs);
 		if (!bio)
 			goto free_and_out;
 
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index a6278e7..d34e859 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -699,7 +699,7 @@ static struct bio *bio_chain_clone(struct bio **old, struct bio **next,
 	}
 
 	while (old_chain && (total < len)) {
-		tmp = bio_kmalloc(gfpmask, old_chain->bi_max_vecs);
+		tmp = bio_kmalloc(gfpmask, bio_segments(old_chain));
 		if (!tmp)
 			goto err_out;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b89c548..0785fab 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1078,28 +1078,22 @@ static struct bio *split_bvec(struct bio *bio, sector_t sector,
  * Creates a bio that consists of range of complete bvecs.
  */
 static struct bio *clone_bio(struct bio *bio, sector_t sector,
-			     unsigned short idx, unsigned short bv_count,
+			     unsigned short bv_count,
 			     unsigned int len, struct bio_set *bs)
 {
 	struct bio *clone;
 
-	clone = bio_alloc_bioset(GFP_NOIO, bio->bi_max_vecs, bs);
-	__bio_clone(clone, bio);
-	clone->bi_destructor = dm_bio_destructor;
+	clone = bio_clone_bioset(bio, GFP_NOIO, bs);
 	clone->bi_sector = sector;
-	clone->bi_idx = idx;
-	clone->bi_vcnt = idx + bv_count;
+	clone->bi_vcnt = bv_count;
 	clone->bi_size = to_bytes(len);
 	clone->bi_flags &= ~(1 << BIO_SEG_VALID);
-
-	if (bio_integrity(bio)) {
-		bio_integrity_clone(clone, bio, GFP_NOIO, bs);
-
+#if 0
+	if (bio_integrity(bio))
 		if (idx != bio->bi_idx || clone->bi_size < bio->bi_size)
 			bio_integrity_trim(clone,
 					   bio_sector_offset(bio, idx, 0), len);
-	}
-
+#endif
 	return clone;
 }
 
@@ -1128,9 +1122,8 @@ static void __issue_target_request(struct clone_info *ci, struct dm_target *ti,
 	 * ci->bio->bi_max_vecs is BIO_INLINE_VECS anyway, for both flush
 	 * and discard, so no need for concern about wasted bvec allocations.
 	 */
-	clone = bio_alloc_bioset(GFP_NOIO, ci->bio->bi_max_vecs, ci->md->bs);
-	__bio_clone(clone, ci->bio);
-	clone->bi_destructor = dm_bio_destructor;
+	clone = bio_clone_bioset(ci->bio, GFP_NOIO, ci->md->bs);
+
 	if (len) {
 		clone->bi_sector = ci->sector;
 		clone->bi_size = to_bytes(len);
@@ -1169,7 +1162,7 @@ static void __clone_and_map_simple(struct clone_info *ci, struct dm_target *ti)
 	struct dm_target_io *tio;
 
 	tio = alloc_tio(ci, ti);
-	clone = clone_bio(bio, ci->sector, ci->idx,
+	clone = clone_bio(bio, ci->sector,
 			  bio->bi_vcnt - ci->idx, ci->sector_count,
 			  ci->md->bs);
 	__map_bio(ti, clone, tio);
@@ -1248,7 +1241,7 @@ static int __clone_and_map(struct clone_info *ci)
 		}
 
 		tio = alloc_tio(ci, ti);
-		clone = clone_bio(bio, ci->sector, ci->idx, i - ci->idx, len,
+		clone = clone_bio(bio, ci->sector, i - ci->idx, len,
 				  ci->md->bs);
 		__map_bio(ti, clone, tio);
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index ce88755..961c995 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -194,7 +194,8 @@ struct bio *bio_clone_mddev(struct bio *bio, gfp_t gfp_mask,
 	if (!mddev || !mddev->bio_set)
 		return bio_clone(bio, gfp_mask);
 
-	b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs,
+	b = bio_alloc_bioset(gfp_mask,
+			     bio_segments(bio),
 			     mddev->bio_set);
 	if (!b)
 		return NULL;
diff --git a/fs/bio.c b/fs/bio.c
index b980ecd..a965b89 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -53,6 +53,7 @@ static struct biovec_slab bvec_slabs[BIOVEC_NR_POOLS] __read_mostly = {
  * IO code that does not need private memory pools.
  */
 struct bio_set *fs_bio_set;
+EXPORT_SYMBOL(fs_bio_set);
 
 /*
  * Our slab pool management
@@ -313,11 +314,6 @@ err_free:
 }
 EXPORT_SYMBOL(bio_alloc_bioset);
 
-static void bio_fs_destructor(struct bio *bio)
-{
-	bio_free(bio, fs_bio_set);
-}
-
 /**
  *	bio_alloc - allocate a new bio, memory pool backed
  *	@gfp_mask: allocation mask to use
@@ -341,8 +337,10 @@ struct bio *bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 {
 	struct bio *bio = bio_alloc_bioset(gfp_mask, nr_iovecs, fs_bio_set);
 
-	if (bio)
-		bio->bi_destructor = bio_fs_destructor;
+	if (bio) {
+		bio->bi_flags |= 1 << BIO_HAS_POOL;
+		bio->bi_destructor = (void *) fs_bio_set;
+	}
 
 	return bio;
 }
@@ -434,18 +432,19 @@ inline int bio_phys_segments(struct request_queue *q, struct bio *bio)
 EXPORT_SYMBOL(bio_phys_segments);
 
 /**
- * 	__bio_clone	-	clone a bio
- * 	@bio: destination bio
- * 	@bio_src: bio to clone
+ *	__bio_clone	-	clone a bio
+ *	@bio: destination bio
+ *	@bio_src: bio to clone
  *
  *	Clone a &bio. Caller will own the returned bio, but not
  *	the actual data it points to. Reference count of returned
- * 	bio will be one.
+ *	bio will be one.
  */
 void __bio_clone(struct bio *bio, struct bio *bio_src)
 {
-	memcpy(bio->bi_io_vec, bio_src->bi_io_vec,
-		bio_src->bi_max_vecs * sizeof(struct bio_vec));
+	memcpy(bio->bi_io_vec,
+	       bio_iovec(bio_src),
+	       bio_segments(bio_src) * sizeof(struct bio_vec));
 
 	/*
 	 * most users will be overriding ->bi_bdev with a new target,
@@ -455,33 +454,34 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
 	bio->bi_bdev = bio_src->bi_bdev;
 	bio->bi_flags |= 1 << BIO_CLONED;
 	bio->bi_rw = bio_src->bi_rw;
-	bio->bi_vcnt = bio_src->bi_vcnt;
+	bio->bi_vcnt = bio_segments(bio_src);
 	bio->bi_size = bio_src->bi_size;
-	bio->bi_idx = bio_src->bi_idx;
 }
 EXPORT_SYMBOL(__bio_clone);
 
 /**
- *	bio_clone	-	clone a bio
+ *	bio_clone_bioset -	clone a bio
  *	@bio: bio to clone
  *	@gfp_mask: allocation priority
+ *	@bs: bio_set to allocate from
  *
- * 	Like __bio_clone, only also allocates the returned bio
+ *	Like __bio_clone, only also allocates the returned bio
  */
-struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
+struct bio *bio_clone_bioset(struct bio *bio, gfp_t gfp_mask,
+			     struct bio_set *bs)
 {
-	struct bio *b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, fs_bio_set);
-
+	struct bio *b = bio_alloc_bioset(gfp_mask, bio_segments(bio), bs);
 	if (!b)
 		return NULL;
 
-	b->bi_destructor = bio_fs_destructor;
 	__bio_clone(b, bio);
+	b->bi_flags	|= 1 << BIO_HAS_POOL;
+	b->bi_destructor = (void *) bs;
 
 	if (bio_integrity(bio)) {
 		int ret;
 
-		ret = bio_integrity_clone(b, bio, gfp_mask, fs_bio_set);
+		ret = bio_integrity_clone(b, bio, gfp_mask, bs);
 
 		if (ret < 0) {
 			bio_put(b);
@@ -491,7 +491,7 @@ struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
 
 	return b;
 }
-EXPORT_SYMBOL(bio_clone);
+EXPORT_SYMBOL(bio_clone_bioset);
 
 /**
  *	bio_get_nr_vecs		- return approx number of vecs
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 129a9c0..f549b54 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -222,7 +222,7 @@ struct request_queue;
 extern int bio_phys_segments(struct request_queue *, struct bio *);
 
 extern void __bio_clone(struct bio *, struct bio *);
-extern struct bio *bio_clone(struct bio *, gfp_t);
+extern struct bio *bio_clone_bioset(struct bio *, gfp_t, struct bio_set *bs);
 
 extern void bio_init(struct bio *);
 
@@ -297,6 +297,11 @@ struct biovec_slab {
 
 extern struct bio_set *fs_bio_set;
 
+static inline struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
+{
+	return bio_clone_bioset(bio, gfp_mask, fs_bio_set);
+}
+
 /*
  * a small number of entries is fine, not going to be performance critical.
  * basically we just need to survive
-- 
1.7.9.rc2

