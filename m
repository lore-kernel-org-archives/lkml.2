Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab2IFWhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 18:37:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51551 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab2IFWfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 18:35:15 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, Jens Axboe <axboe@kernel.dk>,
        NeilBrown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: [PATCH v10 1/8] block: Generalized bio pool freeing
Date: Thu,  6 Sep 2012 15:34:55 -0700
Message-Id: <1346970902-10931-2-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346970902-10931-1-git-send-email-koverstreet@google.com>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the old code, when you allocate a bio from a bio pool you have to
implement your own destructor that knows how to find the bio pool the
bio was originally allocated from.

This adds a new field to struct bio (bi_pool) and changes
bio_alloc_bioset() to use it. This makes various bio destructors
unnecessary, so they're then deleted.

v6: Explain the temporary if statement in bio_put

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: NeilBrown <neilb@suse.de>
CC: Alasdair Kergon <agk@redhat.com>
CC: Nicholas Bellinger <nab@linux-iscsi.org>
CC: Lars Ellenberg <lars.ellenberg@linbit.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/block/drbd/drbd_main.c      | 13 +------------
 drivers/md/dm-crypt.c               |  9 ---------
 drivers/md/dm-io.c                  | 11 -----------
 drivers/md/dm.c                     | 20 --------------------
 drivers/md/md.c                     | 28 ++++------------------------
 drivers/target/target_core_iblock.c |  9 ---------
 fs/bio.c                            | 31 +++++++++++++------------------
 include/linux/blk_types.h           |  3 +++
 8 files changed, 21 insertions(+), 103 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index f93a032..f55683a 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -162,23 +162,12 @@ static const struct block_device_operations drbd_ops = {
 	.release = drbd_release,
 };
 
-static void bio_destructor_drbd(struct bio *bio)
-{
-	bio_free(bio, drbd_md_io_bio_set);
-}
-
 struct bio *bio_alloc_drbd(gfp_t gfp_mask)
 {
-	struct bio *bio;
-
 	if (!drbd_md_io_bio_set)
 		return bio_alloc(gfp_mask, 1);
 
-	bio = bio_alloc_bioset(gfp_mask, 1, drbd_md_io_bio_set);
-	if (!bio)
-		return NULL;
-	bio->bi_destructor = bio_destructor_drbd;
-	return bio;
+	return bio_alloc_bioset(gfp_mask, 1, drbd_md_io_bio_set);
 }
 
 #ifdef __CHECKER__
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 664743d..3c0acba 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -798,14 +798,6 @@ static int crypt_convert(struct crypt_config *cc,
 	return 0;
 }
 
-static void dm_crypt_bio_destructor(struct bio *bio)
-{
-	struct dm_crypt_io *io = bio->bi_private;
-	struct crypt_config *cc = io->cc;
-
-	bio_free(bio, cc->bs);
-}
-
 /*
  * Generate a new unfragmented bio with the given size
  * This should never violate the device limitations
@@ -974,7 +966,6 @@ static void clone_init(struct dm_crypt_io *io, struct bio *clone)
 	clone->bi_end_io  = crypt_endio;
 	clone->bi_bdev    = cc->dev->bdev;
 	clone->bi_rw      = io->base_bio->bi_rw;
-	clone->bi_destructor = dm_crypt_bio_destructor;
 }
 
 static int kcryptd_io_read(struct dm_crypt_io *io, gfp_t gfp)
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index ea5dd28..1c46f97 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -249,16 +249,6 @@ static void vm_dp_init(struct dpages *dp, void *data)
 	dp->context_ptr = data;
 }
 
-static void dm_bio_destructor(struct bio *bio)
-{
-	unsigned region;
-	struct io *io;
-
-	retrieve_io_and_region_from_bio(bio, &io, &region);
-
-	bio_free(bio, io->client->bios);
-}
-
 /*
  * Functions for getting the pages from kernel memory.
  */
@@ -317,7 +307,6 @@ static void do_region(int rw, unsigned region, struct dm_io_region *where,
 		bio->bi_sector = where->sector + (where->count - remaining);
 		bio->bi_bdev = where->bdev;
 		bio->bi_end_io = endio;
-		bio->bi_destructor = dm_bio_destructor;
 		store_io_and_region_in_bio(bio, io, region);
 
 		if (rw & REQ_DISCARD) {
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 4e09b6f..0c3d6dd 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -681,11 +681,6 @@ static void clone_endio(struct bio *bio, int error)
 		}
 	}
 
-	/*
-	 * Store md for cleanup instead of tio which is about to get freed.
-	 */
-	bio->bi_private = md->bs;
-
 	free_tio(md, tio);
 	bio_put(bio);
 	dec_pending(io, error);
@@ -1032,11 +1027,6 @@ static void __map_bio(struct dm_target *ti, struct bio *clone,
 		/* error the io and bail out, or requeue it if needed */
 		md = tio->io->md;
 		dec_pending(tio->io, r);
-		/*
-		 * Store bio_set for cleanup.
-		 */
-		clone->bi_end_io = NULL;
-		clone->bi_private = md->bs;
 		bio_put(clone);
 		free_tio(md, tio);
 	} else if (r) {
@@ -1055,13 +1045,6 @@ struct clone_info {
 	unsigned short idx;
 };
 
-static void dm_bio_destructor(struct bio *bio)
-{
-	struct bio_set *bs = bio->bi_private;
-
-	bio_free(bio, bs);
-}
-
 /*
  * Creates a little bio that just does part of a bvec.
  */
@@ -1073,7 +1056,6 @@ static struct bio *split_bvec(struct bio *bio, sector_t sector,
 	struct bio_vec *bv = bio->bi_io_vec + idx;
 
 	clone = bio_alloc_bioset(GFP_NOIO, 1, bs);
-	clone->bi_destructor = dm_bio_destructor;
 	*clone->bi_io_vec = *bv;
 
 	clone->bi_sector = sector;
@@ -1105,7 +1087,6 @@ static struct bio *clone_bio(struct bio *bio, sector_t sector,
 
 	clone = bio_alloc_bioset(GFP_NOIO, bio->bi_max_vecs, bs);
 	__bio_clone(clone, bio);
-	clone->bi_destructor = dm_bio_destructor;
 	clone->bi_sector = sector;
 	clone->bi_idx = idx;
 	clone->bi_vcnt = idx + bv_count;
@@ -1150,7 +1131,6 @@ static void __issue_target_request(struct clone_info *ci, struct dm_target *ti,
 	 */
 	clone = bio_alloc_bioset(GFP_NOIO, ci->bio->bi_max_vecs, ci->md->bs);
 	__bio_clone(clone, ci->bio);
-	clone->bi_destructor = dm_bio_destructor;
 	if (len) {
 		clone->bi_sector = ci->sector;
 		clone->bi_size = to_bytes(len);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3f6203a..b8eebe3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -155,32 +155,17 @@ static int start_readonly;
  * like bio_clone, but with a local bio set
  */
 
-static void mddev_bio_destructor(struct bio *bio)
-{
-	struct mddev *mddev, **mddevp;
-
-	mddevp = (void*)bio;
-	mddev = mddevp[-1];
-
-	bio_free(bio, mddev->bio_set);
-}
-
 struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
 			    struct mddev *mddev)
 {
 	struct bio *b;
-	struct mddev **mddevp;
 
 	if (!mddev || !mddev->bio_set)
 		return bio_alloc(gfp_mask, nr_iovecs);
 
-	b = bio_alloc_bioset(gfp_mask, nr_iovecs,
-			     mddev->bio_set);
+	b = bio_alloc_bioset(gfp_mask, nr_iovecs, mddev->bio_set);
 	if (!b)
 		return NULL;
-	mddevp = (void*)b;
-	mddevp[-1] = mddev;
-	b->bi_destructor = mddev_bio_destructor;
 	return b;
 }
 EXPORT_SYMBOL_GPL(bio_alloc_mddev);
@@ -189,18 +174,14 @@ struct bio *bio_clone_mddev(struct bio *bio, gfp_t gfp_mask,
 			    struct mddev *mddev)
 {
 	struct bio *b;
-	struct mddev **mddevp;
 
 	if (!mddev || !mddev->bio_set)
 		return bio_clone(bio, gfp_mask);
 
-	b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs,
-			     mddev->bio_set);
+	b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, mddev->bio_set);
 	if (!b)
 		return NULL;
-	mddevp = (void*)b;
-	mddevp[-1] = mddev;
-	b->bi_destructor = mddev_bio_destructor;
+
 	__bio_clone(b, bio);
 	if (bio_integrity(bio)) {
 		int ret;
@@ -5006,8 +4987,7 @@ int md_run(struct mddev *mddev)
 	}
 
 	if (mddev->bio_set == NULL)
-		mddev->bio_set = bioset_create(BIO_POOL_SIZE,
-					       sizeof(struct mddev *));
+		mddev->bio_set = bioset_create(BIO_POOL_SIZE, 0);
 
 	spin_lock(&pers_lock);
 	pers = find_pers(mddev->level, mddev->clevel);
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 76db75e..e58cd7d 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -543,14 +543,6 @@ static void iblock_complete_cmd(struct se_cmd *cmd)
 	kfree(ibr);
 }
 
-static void iblock_bio_destructor(struct bio *bio)
-{
-	struct se_cmd *cmd = bio->bi_private;
-	struct iblock_dev *ib_dev = cmd->se_dev->dev_ptr;
-
-	bio_free(bio, ib_dev->ibd_bio_set);
-}
-
 static struct bio *
 iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num)
 {
@@ -572,7 +564,6 @@ iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num)
 
 	bio->bi_bdev = ib_dev->ibd_bd;
 	bio->bi_private = cmd;
-	bio->bi_destructor = iblock_bio_destructor;
 	bio->bi_end_io = &iblock_bio_done;
 	bio->bi_sector = lba;
 	return bio;
diff --git a/fs/bio.c b/fs/bio.c
index 71072ab..e017f7a 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -272,10 +272,6 @@ EXPORT_SYMBOL(bio_init);
  *   bio_alloc_bioset will try its own mempool to satisfy the allocation.
  *   If %__GFP_WAIT is set then we will block on the internal pool waiting
  *   for a &struct bio to become free.
- *
- *   Note that the caller must set ->bi_destructor on successful return
- *   of a bio, to do the appropriate freeing of the bio once the reference
- *   count drops to zero.
  **/
 struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 {
@@ -290,6 +286,7 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 	bio = p + bs->front_pad;
 
 	bio_init(bio);
+	bio->bi_pool = bs;
 
 	if (unlikely(!nr_iovecs))
 		goto out_set;
@@ -316,11 +313,6 @@ err_free:
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
@@ -342,12 +334,7 @@ static void bio_fs_destructor(struct bio *bio)
  */
 struct bio *bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 {
-	struct bio *bio = bio_alloc_bioset(gfp_mask, nr_iovecs, fs_bio_set);
-
-	if (bio)
-		bio->bi_destructor = bio_fs_destructor;
-
-	return bio;
+	return bio_alloc_bioset(gfp_mask, nr_iovecs, fs_bio_set);
 }
 EXPORT_SYMBOL(bio_alloc);
 
@@ -423,7 +410,16 @@ void bio_put(struct bio *bio)
 	if (atomic_dec_and_test(&bio->bi_cnt)) {
 		bio_disassociate_task(bio);
 		bio->bi_next = NULL;
-		bio->bi_destructor(bio);
+
+		/*
+		 * This if statement is temporary - bi_pool is replacing
+		 * bi_destructor, but bi_destructor will be taken out in another
+		 * patch.
+		 */
+		if (bio->bi_pool)
+			bio_free(bio, bio->bi_pool);
+		else
+			bio->bi_destructor(bio);
 	}
 }
 EXPORT_SYMBOL(bio_put);
@@ -474,12 +470,11 @@ EXPORT_SYMBOL(__bio_clone);
  */
 struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
 {
-	struct bio *b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, fs_bio_set);
+	struct bio *b = bio_alloc(gfp_mask, bio->bi_max_vecs);
 
 	if (!b)
 		return NULL;
 
-	b->bi_destructor = bio_fs_destructor;
 	__bio_clone(b, bio);
 
 	if (bio_integrity(bio)) {
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 7b7ac9c..af9dd9d 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -80,6 +80,9 @@ struct bio {
 	struct bio_integrity_payload *bi_integrity;  /* data integrity */
 #endif
 
+	/* If bi_pool is non NULL, bi_destructor is not called */
+	struct bio_set		*bi_pool;
+
 	bio_destructor_t	*bi_destructor;	/* destructor */
 
 	/*
-- 
1.7.12

