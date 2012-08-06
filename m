Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039Ab2HFWLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 18:11:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46299 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714Ab2HFWJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 18:09:15 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com,
        vgoyal@redhat.com, mpatocka@redhat.com, sage@newdream.net,
        yehuda@hq.newdream.net
Subject: [PATCH v5 06/12] block: Add an explicit bio flag for bios that own their bvec
Date: Mon,  6 Aug 2012 15:08:35 -0700
Message-Id: <1344290921-25154-7-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1344290921-25154-1-git-send-email-koverstreet@google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is for the new bio splitting code. When we split a bio, if the
split occured on a bvec boundry we reuse the bvec for the new bio. But
that means bio_free() can't free it, hence the explicit flag.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/bio.c                  |    3 ++-
 include/linux/bio.h       |    5 -----
 include/linux/blk_types.h |    1 +
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index ebc7309..ff34311 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -249,7 +249,7 @@ void bio_free(struct bio *bio)
 		return;
 	}
 
-	if (bio_has_allocated_vec(bio))
+	if (bio_flagged(bio, BIO_OWNS_VEC))
 		bvec_free_bs(bs, bio->bi_io_vec, BIO_POOL_IDX(bio));
 
 	if (bio_integrity(bio))
@@ -321,6 +321,7 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 			goto err_free;
 
 		nr_iovecs = bvec_nr_vecs(idx);
+		bio->bi_flags |= 1 << BIO_OWNS_VEC;
 	}
 out_set:
 	bio->bi_flags |= idx << BIO_POOL_OFFSET;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 393c87e..484b96e 100644
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
index d10c2e49..416aae4 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -113,6 +113,7 @@ struct bio {
 #define BIO_MAPPED_INTEGRITY 11/* integrity metadata has been remapped */
 
 #define BIO_RESET_BITS	12	/* Flags starting here get preserved by bio_reset() */
+#define BIO_OWNS_VEC	12	/* bio_free() should free bvec */
 
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
-- 
1.7.7.3

