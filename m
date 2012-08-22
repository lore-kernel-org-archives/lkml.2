Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964883Ab2HVRHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 13:07:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44744 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964839Ab2HVREg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 13:04:36 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, vgoyal@redhat.com,
        mpatocka@redhat.com, bharrosh@panasas.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v6 05/13] block: Kill bi_destructor
Date: Wed, 22 Aug 2012 10:04:02 -0700
Message-Id: <1345655050-28199-6-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1345655050-28199-1-git-send-email-koverstreet@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we've got generic code for freeing bios allocated from bio
pools, this isn't needed anymore.

This also changes the semantics of bio_free() a bit - it now also frees
bios allocated by bio_kmalloc(). It's also no longer exported, as
without bi_destructor there should be no need for it to be called
anywhere else.

v5: Switch to BIO_KMALLOC_POOL ((void *)~0), per Boaz
v6: BIO_KMALLOC_POOL now NULL, drop bio_free's EXPORT_SYMBOL

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
---
 Documentation/block/biodoc.txt |  5 -----
 block/blk-core.c               |  2 +-
 fs/bio.c                       | 35 ++++++++++++++---------------------
 include/linux/bio.h            |  2 +-
 include/linux/blk_types.h      |  3 ---
 5 files changed, 16 insertions(+), 31 deletions(-)

diff --git a/Documentation/block/biodoc.txt b/Documentation/block/biodoc.txt
index e418dc0..8df5e8e 100644
--- a/Documentation/block/biodoc.txt
+++ b/Documentation/block/biodoc.txt
@@ -465,7 +465,6 @@ struct bio {
        bio_end_io_t	*bi_end_io;  /* bi_end_io (bio) */
        atomic_t		bi_cnt;	     /* pin count: free when it hits zero */
        void             *bi_private;
-       bio_destructor_t *bi_destructor; /* bi_destructor (bio) */
 };
 
 With this multipage bio design:
@@ -647,10 +646,6 @@ for a non-clone bio. There are the 6 pools setup for different size biovecs,
 so bio_alloc(gfp_mask, nr_iovecs) will allocate a vec_list of the
 given size from these slabs.
 
-The bi_destructor() routine takes into account the possibility of the bio
-having originated from a different source (see later discussions on
-n/w to block transfers and kvec_cb)
-
 The bio_get() routine may be used to hold an extra reference on a bio prior
 to i/o submission, if the bio fields are likely to be accessed after the
 i/o is issued (since the bio may otherwise get freed in case i/o completion
diff --git a/block/blk-core.c b/block/blk-core.c
index 4b4dbdf..f3780f5 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2807,7 +2807,7 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 
 free_and_out:
 	if (bio)
-		bio_free(bio, bs);
+		bio_free(bio);
 	blk_rq_unprep_clone(rq);
 
 	return -ENOMEM;
diff --git a/fs/bio.c b/fs/bio.c
index 81bdf4f..fac171f 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -56,6 +56,8 @@ static struct biovec_slab bvec_slabs[BIOVEC_NR_POOLS] __read_mostly = {
  */
 struct bio_set *fs_bio_set;
 
+#define BIO_KMALLOC_POOL NULL
+
 /*
  * Our slab pool management
  */
@@ -232,10 +234,19 @@ fallback:
 	return bvl;
 }
 
-void bio_free(struct bio *bio, struct bio_set *bs)
+void bio_free(struct bio *bio)
 {
+	struct bio_set *bs = bio->bi_pool;
 	void *p;
 
+	if (bs == BIO_KMALLOC_POOL) {
+		/* Bio was allocated by bio_kmalloc() */
+		if (bio_integrity(bio))
+			bio_integrity_free(bio, fs_bio_set);
+		kfree(bio);
+		return;
+	}
+
 	if (bio_has_allocated_vec(bio))
 		bvec_free_bs(bs, bio->bi_io_vec, BIO_POOL_IDX(bio));
 
@@ -251,7 +262,6 @@ void bio_free(struct bio *bio, struct bio_set *bs)
 
 	mempool_free(p, bs->bio_pool);
 }
-EXPORT_SYMBOL(bio_free);
 
 void bio_init(struct bio *bio)
 {
@@ -346,13 +356,6 @@ struct bio *bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 }
 EXPORT_SYMBOL(bio_alloc);
 
-static void bio_kmalloc_destructor(struct bio *bio)
-{
-	if (bio_integrity(bio))
-		bio_integrity_free(bio, fs_bio_set);
-	kfree(bio);
-}
-
 /**
  * bio_kmalloc - allocate a bio for I/O using kmalloc()
  * @gfp_mask:   the GFP_ mask given to the slab allocator
@@ -379,7 +382,7 @@ struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 	bio->bi_flags |= BIO_POOL_NONE << BIO_POOL_OFFSET;
 	bio->bi_max_vecs = nr_iovecs;
 	bio->bi_io_vec = bio->bi_inline_vecs;
-	bio->bi_destructor = bio_kmalloc_destructor;
+	bio->bi_pool = BIO_KMALLOC_POOL;
 
 	return bio;
 }
@@ -417,17 +420,7 @@ void bio_put(struct bio *bio)
 	 */
 	if (atomic_dec_and_test(&bio->bi_cnt)) {
 		bio_disassociate_task(bio);
-		bio->bi_next = NULL;
-
-		/*
-		 * This if statement is temporary - bi_pool is replacing
-		 * bi_destructor, but bi_destructor will be taken out in another
-		 * patch.
-		 */
-		if (bio->bi_pool)
-			bio_free(bio, bio->bi_pool);
-		else
-			bio->bi_destructor(bio);
+		bio_free(bio);
 	}
 }
 EXPORT_SYMBOL(bio_put);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index ba60319..393c87e 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -216,7 +216,7 @@ extern struct bio *bio_alloc(gfp_t, unsigned int);
 extern struct bio *bio_kmalloc(gfp_t, unsigned int);
 extern struct bio *bio_alloc_bioset(gfp_t, int, struct bio_set *);
 extern void bio_put(struct bio *);
-extern void bio_free(struct bio *, struct bio_set *);
+extern void bio_free(struct bio *);
 
 extern void bio_endio(struct bio *, int);
 struct request_queue;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 4fe4984..045ebe0 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -84,11 +84,8 @@ struct bio {
 	struct bio_integrity_payload *bi_integrity;  /* data integrity */
 #endif
 
-	/* If bi_pool is non NULL, bi_destructor is not called */
 	struct bio_set		*bi_pool;
 
-	bio_destructor_t	*bi_destructor;	/* destructor */
-
 	/*
 	 * We can inline a number of vecs at the end of the bio, to avoid
 	 * double allocations for a small number of bio_vecs. This member
-- 
1.7.12

