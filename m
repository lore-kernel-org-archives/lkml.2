Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318Ab2IFVet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 17:34:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35183 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236Ab2IFVdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 17:33:19 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v8 6/8] block: Kill bi_destructor
Date: Thu,  6 Sep 2012 14:32:54 -0700
Message-Id: <1346967179-28596-8-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346967179-28596-1-git-send-email-koverstreet@google.com>
References: <1346967179-28596-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we've got generic code for freeing bios allocated from bio
pools, this isn't needed anymore.

This patch also makes bio_free() static, since without bi_destructor
there should be no need for it to be called anywhere else.

While we're at it, since bio_free() is now only called from one place,
refactor it a bit and pull out __bio_free() for bio_reset() to use.

v5: Switch to BIO_KMALLOC_POOL ((void *)~0), per Boaz
v6: BIO_KMALLOC_POOL now NULL, drop bio_free's EXPORT_SYMBOL
v7: No #define BIO_KMALLOC_POOL anymore

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
---
 Documentation/block/biodoc.txt |  5 ----
 block/blk-core.c               |  2 +-
 fs/bio.c                       | 64 +++++++++++++++++-------------------------
 include/linux/bio.h            |  1 -
 include/linux/blk_types.h      |  3 --
 5 files changed, 27 insertions(+), 48 deletions(-)

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
index 95c4935..b776cc9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2807,7 +2807,7 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 
 free_and_out:
 	if (bio)
-		bio_free(bio, bs);
+		bio_put(bio);
 	blk_rq_unprep_clone(rq);
 
 	return -ENOMEM;
diff --git a/fs/bio.c b/fs/bio.c
index 208141f..d807fe2 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -233,26 +233,37 @@ fallback:
 	return bvl;
 }
 
-void bio_free(struct bio *bio, struct bio_set *bs)
+static void __bio_free(struct bio *bio)
 {
-	void *p;
-
-	if (bio_has_allocated_vec(bio))
-		bvec_free_bs(bs, bio->bi_io_vec, BIO_POOL_IDX(bio));
+	bio_disassociate_task(bio);
 
 	if (bio_integrity(bio))
 		bio_integrity_free(bio);
+}
 
-	/*
-	 * If we have front padding, adjust the bio pointer before freeing
-	 */
-	p = bio;
-	if (bs->front_pad)
+static void bio_free(struct bio *bio)
+{
+	struct bio_set *bs = bio->bi_pool;
+	void *p;
+
+	__bio_free(bio);
+
+	if (bs) {
+		if (bio_has_allocated_vec(bio))
+			bvec_free_bs(bs, bio->bi_io_vec, BIO_POOL_IDX(bio));
+
+		/*
+		 * If we have front padding, adjust the bio pointer before freeing
+		 */
+		p = bio;
 		p -= bs->front_pad;
 
-	mempool_free(p, bs->bio_pool);
+		mempool_free(p, bs->bio_pool);
+	} else {
+		/* Bio was allocated by bio_kmalloc() */
+		kfree(bio);
+	}
 }
-EXPORT_SYMBOL(bio_free);
 
 void bio_init(struct bio *bio)
 {
@@ -266,10 +277,7 @@ void bio_reset(struct bio *bio)
 {
 	unsigned long flags = bio->bi_flags & (~0UL << BIO_RESET_BITS);
 
-	if (bio_integrity(bio))
-		bio_integrity_free(bio, bio->bi_pool);
-
-	bio_disassociate_task(bio);
+	__bio_free(bio);
 
 	memset(bio, 0, BIO_RESET_BYTES);
 	bio->bi_flags = flags|(1 << BIO_UPTODATE);
@@ -352,13 +360,6 @@ struct bio *bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 }
 EXPORT_SYMBOL(bio_alloc);
 
-static void bio_kmalloc_destructor(struct bio *bio)
-{
-	if (bio_integrity(bio))
-		bio_integrity_free(bio);
-	kfree(bio);
-}
-
 /**
  * bio_kmalloc - allocate a bio for I/O using kmalloc()
  * @gfp_mask:   the GFP_ mask given to the slab allocator
@@ -385,7 +386,6 @@ struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 	bio->bi_flags |= BIO_POOL_NONE << BIO_POOL_OFFSET;
 	bio->bi_max_vecs = nr_iovecs;
 	bio->bi_io_vec = bio->bi_inline_vecs;
-	bio->bi_destructor = bio_kmalloc_destructor;
 
 	return bio;
 }
@@ -421,20 +421,8 @@ void bio_put(struct bio *bio)
 	/*
 	 * last put frees it
 	 */
-	if (atomic_dec_and_test(&bio->bi_cnt)) {
-		bio_disassociate_task(bio);
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
-	}
+	if (atomic_dec_and_test(&bio->bi_cnt))
+		bio_free(bio);
 }
 EXPORT_SYMBOL(bio_put);
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 76f6c25..04944c9 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -216,7 +216,6 @@ extern struct bio *bio_alloc(gfp_t, unsigned int);
 extern struct bio *bio_kmalloc(gfp_t, unsigned int);
 extern struct bio *bio_alloc_bioset(gfp_t, int, struct bio_set *);
 extern void bio_put(struct bio *);
-extern void bio_free(struct bio *, struct bio_set *);
 
 extern void bio_endio(struct bio *, int);
 struct request_queue;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 1b607c2..3eefbb2 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -84,11 +84,8 @@ struct bio {
 
 	struct bio_vec		*bi_io_vec;	/* the actual vec list */
 
-	/* If bi_pool is non NULL, bi_destructor is not called */
 	struct bio_set		*bi_pool;
 
-	bio_destructor_t	*bi_destructor;	/* destructor */
-
 	/*
 	 * We can inline a number of vecs at the end of the bio, to avoid
 	 * double allocations for a small number of bio_vecs. This member
-- 
1.7.12

