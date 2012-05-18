Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031002Ab2ERDCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:02:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38968 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030948Ab2ERDAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 23:00:17 -0400
From: koverstreet@google.com
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de
Subject: [PATCH 08/13] block: Kill bi_destructor
Date: Thu, 17 May 2012 22:59:55 -0400
Message-Id: <de05855cf0fa4800cfab7e8340f106dccc7a75a1.1337308722.git.koverstreet@google.com>
X-Mailer: git-send-email 1.7.9.rc2
In-Reply-To: <cover.1337308722.git.koverstreet@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
In-Reply-To: <cover.1337308722.git.koverstreet@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <koverstreet@google.com>

Now that we've got generic code for freeing bios allocated from bio
pools, this isn't needed anymore.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 Documentation/block/biodoc.txt |    5 -----
 fs/bio.c                       |   15 +++++----------
 include/linux/blk_types.h      |    3 ---
 3 files changed, 5 insertions(+), 18 deletions(-)

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
index 90e4c3a..ecc9088 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -343,13 +343,6 @@ struct bio *bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
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
@@ -376,7 +369,6 @@ struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 	bio->bi_flags |= BIO_POOL_NONE << BIO_POOL_OFFSET;
 	bio->bi_max_vecs = nr_iovecs;
 	bio->bi_io_vec = bio->bi_inline_vecs;
-	bio->bi_destructor = bio_kmalloc_destructor;
 
 	return bio;
 }
@@ -417,8 +409,11 @@ void bio_put(struct bio *bio)
 
 		if (bio->bi_pool)
 			bio_free(bio, bio->bi_pool);
-		else
-			bio->bi_destructor(bio);
+		else {
+			if (bio_integrity(bio))
+				bio_integrity_free(bio, fs_bio_set);
+			kfree(bio);
+		}
 	}
 }
 EXPORT_SYMBOL(bio_put);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 4a47783..bd9a610 100644
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
1.7.9.rc2

