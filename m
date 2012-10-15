Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab2JOUUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:20:09 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38591 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab2JOUKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:10:19 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        neilb@suse.de, vgoyal@redhat.com
Subject: [PATCH v4 22/24] block: Add an explicit bio flag for bios that own their bvec
Date: Mon, 15 Oct 2012 13:08:56 -0700
Message-Id: <1350331769-14856-23-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is for the new bio splitting code. When we split a bio, if the
split occured on a bvec boundry we reuse the bvec for the new bio. But
that means bio_free() can't free it, hence the explicit flag.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
Acked-by: Tejun Heo <tj@kernel.org>
---
 fs/bio.c                  | 4 +++-
 include/linux/bio.h       | 5 -----
 include/linux/blk_types.h | 1 +
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index b3dceff..5dc8441 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -250,7 +250,7 @@ static void bio_free(struct bio *bio)
 	__bio_free(bio);
 
 	if (bs) {
-		if (bio_has_allocated_vec(bio))
+		if (bio_flagged(bio, BIO_OWNS_VEC))
 			bvec_free(bs->bvec_pool, bio->bi_io_vec, BIO_POOL_IDX(bio));
 
 		/*
@@ -449,6 +449,8 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 
 		if (unlikely(!bvl))
 			goto err_free;
+
+		bio->bi_flags |= 1 << BIO_OWNS_VEC;
 	} else if (nr_iovecs) {
 		bvl = bio->bi_inline_vecs;
 	}
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 8c02317..79f16a6 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -85,11 +85,6 @@ static inline void *bio_data(struct bio *bio)
 	return NULL;
 }
 
-static inline int bio_has_allocated_vec(struct bio *bio)
-{
-	return bio->bi_io_vec && bio->bi_io_vec != bio->bi_inline_vecs;
-}
-
 /*
  * will die
  */
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index c178d25..538289f 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -117,6 +117,7 @@ struct bio {
  * BIO_POOL_IDX()
  */
 #define BIO_RESET_BITS	12
+#define BIO_OWNS_VEC	12	/* bio_free() should free bvec */
 
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
-- 
1.7.12

