Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672Ab2EYUaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 16:30:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48805 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757232Ab2EYU0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 16:26:22 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com,
        bharrosh@panasas.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: [PATCH v3 10/16] block: Add bio_clone_bioset()
Date: Fri, 25 May 2012 13:25:33 -0700
Message-Id: <1337977539-16977-11-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.9.3.327.g2980b
In-Reply-To: <1337977539-16977-1-git-send-email-koverstreet@google.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This consolidates some code, and will help in a later patch changing how
bio cloning works.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Change-Id: If6cfd840db9cf90a798c6a5862e3314465c83000
---
 block/blk-core.c    |    8 +-------
 drivers/md/dm.c     |    4 ++--
 drivers/md/md.c     |   20 +-------------------
 fs/bio.c            |   16 ++++++++++++----
 include/linux/bio.h |    1 +
 5 files changed, 17 insertions(+), 32 deletions(-)

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
index 4014696..3f3c26e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1101,8 +1101,8 @@ static void __issue_target_request(struct clone_info *ci, struct dm_target *ti,
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
index a5a524e..508ae81 100644
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
-		ret = bio_integrity_clone(b, bio, gfp_mask, mddev->bio_set);
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
index d212ee2..a62b5b6 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -459,15 +459,17 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
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
@@ -477,7 +479,7 @@ struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
 	if (bio_integrity(bio)) {
 		int ret;
 
-		ret = bio_integrity_clone(b, bio, gfp_mask, fs_bio_set);
+		ret = bio_integrity_clone(b, bio, gfp_mask, bs);
 
 		if (ret < 0) {
 			bio_put(b);
@@ -487,6 +489,12 @@ struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
 
 	return b;
 }
+EXPORT_SYMBOL(bio_clone_bioset);
+
+struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
+{
+	return bio_clone_bioset(bio, gfp_mask, fs_bio_set);
+}
 EXPORT_SYMBOL(bio_clone);
 
 struct bio *bio_clone_kmalloc(struct bio *bio, gfp_t gfp_mask)
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 8f280f7..0880a71 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -219,6 +219,7 @@ struct request_queue;
 extern int bio_phys_segments(struct request_queue *, struct bio *);
 
 extern void __bio_clone(struct bio *, struct bio *);
+extern struct bio *bio_clone_bioset(struct bio *, gfp_t, struct bio_set *bs);
 extern struct bio *bio_clone(struct bio *, gfp_t);
 struct bio *bio_clone_kmalloc(struct bio *, gfp_t);
 
-- 
1.7.9.3.327.g2980b

