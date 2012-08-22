Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964888Ab2HVRGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 13:06:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37492 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964802Ab2HVREl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 13:04:41 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, vgoyal@redhat.com,
        mpatocka@redhat.com, bharrosh@panasas.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v6 08/13] block: Add an explicit bio flag for bios that own their bvec
Date: Wed, 22 Aug 2012 10:04:05 -0700
Message-Id: <1345655050-28199-9-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1345655050-28199-1-git-send-email-koverstreet@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
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
index a82a3c7..b9c022c 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -246,7 +246,7 @@ void bio_free(struct bio *bio)
 		return;
 	}
 
-	if (bio_has_allocated_vec(bio))
+	if (bio_flagged(bio, BIO_OWNS_VEC))
 		bvec_free_bs(bs, bio->bi_io_vec, BIO_POOL_IDX(bio));
 
 	if (bio_integrity(bio))
@@ -365,6 +365,8 @@ retry:
 		bvl = bvec_alloc_bs(gfp_mask, nr_iovecs, &idx, bs);
 		if (unlikely(!bvl))
 			goto err_free;
+
+		bio->bi_flags |= 1 << BIO_OWNS_VEC;
 	} else if (nr_iovecs) {
 		bvl = bio->bi_inline_vecs;
 	}
diff --git a/include/linux/bio.h b/include/linux/bio.h
index ba5b52e..427d05a 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -84,11 +84,6 @@ static inline void *bio_data(struct bio *bio)
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
index 045ebe0..c1878bd 100644
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

