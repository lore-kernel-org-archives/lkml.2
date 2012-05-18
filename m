Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031046Ab2ERDEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:04:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51875 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030746Ab2ERDAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 23:00:10 -0400
From: koverstreet@google.com
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de
Subject: [PATCH 03/13] block: Add bio_clone_bioset()
Date: Thu, 17 May 2012 22:59:50 -0400
Message-Id: <eb6a7d3fe7ae203202bc365d7274ee531631a9ca.1337308722.git.koverstreet@google.com>
X-Mailer: git-send-email 1.7.9.rc2
In-Reply-To: <cover.1337308722.git.koverstreet@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
In-Reply-To: <cover.1337308722.git.koverstreet@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <koverstreet@google.com>

This consolidates some code, and will help in a later patch changing how
bio cloning works.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 block/blk-core.c    |    8 +-------
 drivers/md/dm.c     |   27 ++++++++++-----------------
 drivers/md/md.c     |   18 +-----------------
 fs/bio.c            |   16 ++++++++++++----
 include/linux/bio.h |    1 +
 5 files changed, 25 insertions(+), 45 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1f61b74..91617eb 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2660,16 +2660,10 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 	blk_rq_init(NULL, rq);
 
 	__rq_for_each_bio(bio_src, rq_src) {
-		bio = bio_alloc_bioset(gfp_mask, bio_src->bi_max_vecs, bs);
+		bio = bio_clone_bioset(bio_src, gfp_mask, bs);
 		if (!bio)
 			goto free_and_out;
 
-		__bio_clone(bio, bio_src);
-
-		if (bio_integrity(bio_src) &&
-		    bio_integrity_clone(bio, bio_src, gfp_mask, bs))
-			goto free_and_out;
-
 		if (bio_ctr && bio_ctr(bio, bio_src, data))
 			goto free_and_out;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3cc2169..3e33039 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1072,26 +1072,19 @@ static struct bio *split_bvec(struct bio *bio, sector_t sector,
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
+	clone = bio_clone_bioset(bio, GFP_NOIO, bs);
 	clone->bi_sector = sector;
-	clone->bi_idx = idx;
-	clone->bi_vcnt = idx + bv_count;
+	clone->bi_vcnt = bv_count;
 	clone->bi_size = to_bytes(len);
-	clone->bi_flags &= ~(1 << BIO_SEG_VALID);
 
-	if (bio_integrity(bio)) {
-		bio_integrity_clone(clone, bio, GFP_NOIO, bs);
-
-		if (idx != bio->bi_idx || clone->bi_size < bio->bi_size)
-			bio_integrity_trim(clone,
-					   bio_sector_offset(bio, idx, 0), len);
-	}
+	if (bio_integrity(bio) &&
+	    clone->bi_size < bio->bi_size)
+		bio_integrity_trim(clone, 0, len);
 
 	return clone;
 }
@@ -1121,8 +1114,8 @@ static void __issue_target_request(struct clone_info *ci, struct dm_target *ti,
 	 * ci->bio->bi_max_vecs is BIO_INLINE_VECS anyway, for both flush
 	 * and discard, so no need for concern about wasted bvec allocations.
 	 */
-	clone = bio_alloc_bioset(GFP_NOIO, ci->bio->bi_max_vecs, ci->md->bs);
-	__bio_clone(clone, ci->bio);
+	clone = bio_clone_bioset(ci->bio, GFP_NOIO, ci->md->bs);
+
 	if (len) {
 		clone->bi_sector = ci->sector;
 		clone->bi_size = to_bytes(len);
@@ -1161,7 +1154,7 @@ static void __clone_and_map_simple(struct clone_info *ci, struct dm_target *ti)
 	struct dm_target_io *tio;
 
 	tio = alloc_tio(ci, ti);
-	clone = clone_bio(bio, ci->sector, ci->idx,
+	clone = clone_bio(bio, ci->sector,
 			  bio->bi_vcnt - ci->idx, ci->sector_count,
 			  ci->md->bs);
 	__map_bio(ti, clone, tio);
@@ -1240,7 +1233,7 @@ static int __clone_and_map(struct clone_info *ci)
 		}
 
 		tio = alloc_tio(ci, ti);
-		clone = clone_bio(bio, ci->sector, ci->idx, i - ci->idx, len,
+		clone = clone_bio(bio, ci->sector, i - ci->idx, len,
 				  ci->md->bs);
 		__map_bio(ti, clone, tio);
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index a5a524e..47605e7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -178,23 +178,7 @@ struct bio *bio_clone_mddev(struct bio *bio, gfp_t gfp_mask,
 	if (!mddev || !mddev->bio_set)
 		return bio_clone(bio, gfp_mask);
 
-	b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, mddev->bio_set);
-	if (!b)
-		return NULL;
-
-	__bio_clone(b, bio);
-	if (bio_integrity(bio)) {
-		int ret;
-
-		ret = bio_integrity_clone(b, bio, gfp_mask, mddev->bio_set);
-
-		if (ret < 0) {
-			bio_put(b);
-			return NULL;
-		}
-	}
-
-	return b;
+	return bio_clone_bioset(gfp_mask, bio_segments(bio), mddev->bio_set);
 }
 EXPORT_SYMBOL_GPL(bio_clone_mddev);
 
diff --git a/fs/bio.c b/fs/bio.c
index 3667cef..4cb621f 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -453,15 +453,17 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
 EXPORT_SYMBOL(__bio_clone);
 
 /**
- *	bio_clone	-	clone a bio
+ *	bio_clone_bioset -	clone a bio
  *	@bio: bio to clone
  *	@gfp_mask: allocation priority
+ *	@bs: bio_set to allocate from
  *
  * 	Like __bio_clone, only also allocates the returned bio
  */
-struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
+struct bio *bio_clone_bioset(struct bio *bio, gfp_t gfp_mask,
+			     struct bio_set *bs)
 {
-	struct bio *b = bio_alloc(gfp_mask, bio->bi_max_vecs);
+	struct bio *b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, bs);
 
 	if (!b)
 		return NULL;
@@ -471,7 +473,7 @@ struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
 	if (bio_integrity(bio)) {
 		int ret;
 
-		ret = bio_integrity_clone(b, bio, gfp_mask, fs_bio_set);
+		ret = bio_integrity_clone(b, bio, gfp_mask, bs);
 
 		if (ret < 0) {
 			bio_put(b);
@@ -481,6 +483,12 @@ struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
 
 	return b;
 }
+EXPORT_SYMBOL(bio_clone_bioset);
+
+struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
+{
+	return bio_clone_bioset(bio, gfp_mask, fs_bio_set);
+}
 EXPORT_SYMBOL(bio_clone);
 
 /**
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 4d94eb8..e068a68 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -223,6 +223,7 @@ struct request_queue;
 extern int bio_phys_segments(struct request_queue *, struct bio *);
 
 extern void __bio_clone(struct bio *, struct bio *);
+extern struct bio *bio_clone_bioset(struct bio *, gfp_t, struct bio_set *bs);
 extern struct bio *bio_clone(struct bio *, gfp_t);
 
 extern void bio_init(struct bio *);
-- 
1.7.9.rc2

