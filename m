Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310Ab2IFVda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 17:33:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33794 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933274Ab2IFVd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 17:33:26 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, Jens Axboe <axboe@kernel.dk>,
        NeilBrown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>,
        Boaz Harrosh <bharrosh@panasas.com>, Jeff Garzik <jeff@garzik.org>
Subject: [PATCH v9 9/9] block: Add bio_clone_bioset(), bio_clone_kmalloc()
Date: Thu,  6 Sep 2012 14:32:59 -0700
Message-Id: <1346967179-28596-13-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346967179-28596-1-git-send-email-koverstreet@google.com>
References: <1346967179-28596-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, there was bio_clone() but it only allocated from the fs bio
set; as a result various users were open coding it and using
__bio_clone().

This changes bio_clone() to become bio_clone_bioset(), and then we add
bio_clone() and bio_clone_kmalloc() as wrappers around it, making use of
the functionality the last patch adedd.

This will also help in a later patch changing how bio cloning works.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: NeilBrown <neilb@suse.de>
CC: Alasdair Kergon <agk@redhat.com>
CC: Boaz Harrosh <bharrosh@panasas.com>
CC: Jeff Garzik <jeff@garzik.org>
Acked-by: Jeff Garzik <jgarzik@redhat.com>
---
 block/blk-core.c       |  8 +-------
 drivers/block/osdblk.c |  3 +--
 drivers/md/dm-crypt.c  |  7 +------
 drivers/md/dm.c        |  4 ++--
 drivers/md/md.c        | 20 +-------------------
 fs/bio.c               | 11 +++++++----
 fs/exofs/ore.c         |  5 ++---
 include/linux/bio.h    | 17 ++++++++++++++---
 8 files changed, 29 insertions(+), 46 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index b776cc9..82aab28 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2781,16 +2781,10 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 	blk_rq_init(NULL, rq);
 
 	__rq_for_each_bio(bio_src, rq_src) {
-		bio = bio_alloc_bioset(gfp_mask, bio_src->bi_max_vecs, bs);
+		bio = bio_clone_bioset(bio_src, gfp_mask, bs);
 		if (!bio)
 			goto free_and_out;
 
-		__bio_clone(bio, bio_src);
-
-		if (bio_integrity(bio_src) &&
-		    bio_integrity_clone(bio, bio_src, gfp_mask))
-			goto free_and_out;
-
 		if (bio_ctr && bio_ctr(bio, bio_src, data))
 			goto free_and_out;
 
diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
index 87311eb..1bbc681 100644
--- a/drivers/block/osdblk.c
+++ b/drivers/block/osdblk.c
@@ -266,11 +266,10 @@ static struct bio *bio_chain_clone(struct bio *old_chain, gfp_t gfpmask)
 	struct bio *tmp, *new_chain = NULL, *tail = NULL;
 
 	while (old_chain) {
-		tmp = bio_kmalloc(gfpmask, old_chain->bi_max_vecs);
+		tmp = bio_clone_kmalloc(old_chain, gfpmask);
 		if (!tmp)
 			goto err_out;
 
-		__bio_clone(tmp, old_chain);
 		tmp->bi_bdev = NULL;
 		gfpmask &= ~__GFP_WAIT;
 		tmp->bi_next = NULL;
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 3c0acba..bbf459b 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -979,19 +979,14 @@ static int kcryptd_io_read(struct dm_crypt_io *io, gfp_t gfp)
 	 * copy the required bvecs because we need the original
 	 * one in order to decrypt the whole bio data *afterwards*.
 	 */
-	clone = bio_alloc_bioset(gfp, bio_segments(base_bio), cc->bs);
+	clone = bio_clone_bioset(base_bio, gfp, cc->bs);
 	if (!clone)
 		return 1;
 
 	crypt_inc_pending(io);
 
 	clone_init(io, clone);
-	clone->bi_idx = 0;
-	clone->bi_vcnt = bio_segments(base_bio);
-	clone->bi_size = base_bio->bi_size;
 	clone->bi_sector = cc->start + io->sector;
-	memcpy(clone->bi_io_vec, bio_iovec(base_bio),
-	       sizeof(struct bio_vec) * clone->bi_vcnt);
 
 	generic_make_request(clone);
 	return 0;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f2eb730..41afc66 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1129,8 +1129,8 @@ static void __issue_target_request(struct clone_info *ci, struct dm_target *ti,
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
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 457ca84..7a2b079 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -173,28 +173,10 @@ EXPORT_SYMBOL_GPL(bio_alloc_mddev);
 struct bio *bio_clone_mddev(struct bio *bio, gfp_t gfp_mask,
 			    struct mddev *mddev)
 {
-	struct bio *b;
-
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
-		ret = bio_integrity_clone(b, bio, gfp_mask);
-
-		if (ret < 0) {
-			bio_put(b);
-			return NULL;
-		}
-	}
-
-	return b;
+	return bio_clone_bioset(bio, gfp_mask, mddev->bio_set);
 }
 EXPORT_SYMBOL_GPL(bio_clone_mddev);
 
diff --git a/fs/bio.c b/fs/bio.c
index 3a9e578..4f4156d 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -452,16 +452,19 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
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
+	struct bio *b;
 
+	b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, bs);
 	if (!b)
 		return NULL;
 
@@ -480,7 +483,7 @@ struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
 
 	return b;
 }
-EXPORT_SYMBOL(bio_clone);
+EXPORT_SYMBOL(bio_clone_bioset);
 
 /**
  *	bio_get_nr_vecs		- return approx number of vecs
diff --git a/fs/exofs/ore.c b/fs/exofs/ore.c
index 1585db1..f936cb5 100644
--- a/fs/exofs/ore.c
+++ b/fs/exofs/ore.c
@@ -814,8 +814,8 @@ static int _write_mirror(struct ore_io_state *ios, int cur_comp)
 			struct bio *bio;
 
 			if (per_dev != master_dev) {
-				bio = bio_kmalloc(GFP_KERNEL,
-						  master_dev->bio->bi_max_vecs);
+				bio = bio_clone_kmalloc(master_dev->bio,
+							GFP_KERNEL);
 				if (unlikely(!bio)) {
 					ORE_DBGMSG(
 					      "Failed to allocate BIO size=%u\n",
@@ -824,7 +824,6 @@ static int _write_mirror(struct ore_io_state *ios, int cur_comp)
 					goto out;
 				}
 
-				__bio_clone(bio, master_dev->bio);
 				bio->bi_bdev = NULL;
 				bio->bi_next = NULL;
 				per_dev->offset = master_dev->offset;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index fbe35b1..52b9cbc 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -215,6 +215,9 @@ extern void bioset_free(struct bio_set *);
 extern struct bio *bio_alloc_bioset(gfp_t, int, struct bio_set *);
 extern void bio_put(struct bio *);
 
+extern void __bio_clone(struct bio *, struct bio *);
+extern struct bio *bio_clone_bioset(struct bio *, gfp_t, struct bio_set *bs);
+
 extern struct bio_set *fs_bio_set;
 
 static inline struct bio *bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
@@ -222,18 +225,26 @@ static inline struct bio *bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 	return bio_alloc_bioset(gfp_mask, nr_iovecs, fs_bio_set);
 }
 
+static inline struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
+{
+	return bio_clone_bioset(bio, gfp_mask, fs_bio_set);
+}
+
 static inline struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 {
 	return bio_alloc_bioset(gfp_mask, nr_iovecs, NULL);
 }
 
+static inline struct bio *bio_clone_kmalloc(struct bio *bio, gfp_t gfp_mask)
+{
+	return bio_clone_bioset(bio, gfp_mask, NULL);
+
+}
+
 extern void bio_endio(struct bio *, int);
 struct request_queue;
 extern int bio_phys_segments(struct request_queue *, struct bio *);
 
-extern void __bio_clone(struct bio *, struct bio *);
-extern struct bio *bio_clone(struct bio *, gfp_t);
-
 extern void bio_init(struct bio *);
 extern void bio_reset(struct bio *);
 
-- 
1.7.12

