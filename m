Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770Ab2EYUcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 16:32:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41123 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508Ab2EYU0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 16:26:16 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com,
        bharrosh@panasas.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: [PATCH v3 05/16] block: Kill bi_destructor
Date: Fri, 25 May 2012 13:25:28 -0700
Message-Id: <1337977539-16977-6-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.9.3.327.g2980b
In-Reply-To: <1337977539-16977-1-git-send-email-koverstreet@google.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we've got generic code for freeing bios allocated from bio
pools, this isn't needed anymore.

This also changes the semantics of bio_free() a bit - it now also frees
bios allocated by bio_kmalloc(). It's also no longer exported, as
without bi_destructor there should be no need for it to be called
anywhere else.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Change-Id: Iade939e76ff329cb03eef9125e4377ba1e4265c5
---
 Documentation/block/biodoc.txt |    5 -----
 fs/bio.c                       |   33 +++++++++++++++------------------
 include/linux/bio.h            |    1 -
 include/linux/blk_types.h      |    3 ---
 4 files changed, 15 insertions(+), 27 deletions(-)

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
diff --git a/fs/bio.c b/fs/bio.c
index 240da21..4075171 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -230,10 +230,19 @@ fallback:
 	return bvl;
 }
 
-void bio_free(struct bio *bio, struct bio_set *bs)
+static void bio_free(struct bio *bio)
 {
+	struct bio_set *bs = bio->bi_pool;
 	void *p;
 
+	if (!bs) {
+		/* Bio was allocated by bio_kmalloc() */
+		if (bio_integrity(bio))
+			bio_integrity_free(bio, fs_bio_set);
+		kfree(bio);
+		return;
+	}
+
 	if (bio_has_allocated_vec(bio))
 		bvec_free_bs(bs, bio->bi_io_vec, BIO_POOL_IDX(bio));
 
@@ -249,7 +258,6 @@ void bio_free(struct bio *bio, struct bio_set *bs)
 
 	mempool_free(p, bs->bio_pool);
 }
-EXPORT_SYMBOL(bio_free);
 
 void bio_init(struct bio *bio)
 {
@@ -343,13 +351,6 @@ struct bio *bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
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
@@ -376,7 +377,6 @@ struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 	bio->bi_flags |= BIO_POOL_NONE << BIO_POOL_OFFSET;
 	bio->bi_max_vecs = nr_iovecs;
 	bio->bi_io_vec = bio->bi_inline_vecs;
-	bio->bi_destructor = bio_kmalloc_destructor;
 
 	return bio;
 }
@@ -411,15 +411,12 @@ void bio_put(struct bio *bio)
 
 	/*
 	 * last put frees it
+	 *
+	 * bio->bi_pool will be NULL if the bio was allocated by bio_kmalloc() -
+	 * bio_free() handles that case too.
 	 */
-	if (atomic_dec_and_test(&bio->bi_cnt)) {
-		bio->bi_next = NULL;
-
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
index e5c2504..242447c 100644
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
index 6b7daf3..b6ddbf1 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -74,11 +74,8 @@ struct bio {
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
1.7.9.3.327.g2980b

