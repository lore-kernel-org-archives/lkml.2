Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab2EJDIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 23:08:41 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38393 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab2EJDIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 23:08:39 -0400
Date: Wed, 9 May 2012 23:08:34 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: tejun@google.com, agk@redhat.com
Subject: [Bcache v13 02/16] Bio pool freeing
Message-ID: <ba8ce9fcca87f192ff5f5d3a436eb8f4d0bcb006.1336619038.git.koverstreet@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1336619038.git.koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When you allocate a bio from a bio pool, to free it you have to know
where it came from; this adds a flag which, if set, means bi_destructor
is the pointer to the pool and bio_put() can do the right thing.

This is used in bcache, so we can cleanly use per device bio pools.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/bio.c                  |    9 +++++++--
 include/linux/blk_types.h |    2 ++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index a965b89..6a967fc 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -235,7 +235,7 @@ void bio_free(struct bio *bio, struct bio_set *bs)
 {
 	void *p;
 
-	if (bio_has_allocated_vec(bio))
+	if (bio_flagged(bio, BIO_HAS_VEC))
 		bvec_free_bs(bs, bio->bi_io_vec, BIO_POOL_IDX(bio));
 
 	if (bio_integrity(bio))
@@ -301,6 +301,7 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 			goto err_free;
 
 		nr_iovecs = bvec_nr_vecs(idx);
+		bio->bi_flags |= 1 << BIO_HAS_VEC;
 	}
 out_set:
 	bio->bi_flags |= idx << BIO_POOL_OFFSET;
@@ -417,7 +418,11 @@ void bio_put(struct bio *bio)
 	 */
 	if (atomic_dec_and_test(&bio->bi_cnt)) {
 		bio->bi_next = NULL;
-		bio->bi_destructor(bio);
+
+		if (bio_flagged(bio, BIO_HAS_POOL))
+			bio_free(bio, (void *) bio->bi_destructor);
+		else
+			bio->bi_destructor(bio);
 	}
 }
 EXPORT_SYMBOL(bio_put);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 4053cbd..a0be8b3 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -95,6 +95,8 @@ struct bio {
 #define BIO_FS_INTEGRITY 9	/* fs owns integrity data, not block layer */
 #define BIO_QUIET	10	/* Make BIO Quiet */
 #define BIO_MAPPED_INTEGRITY 11/* integrity metadata has been remapped */
+#define BIO_HAS_POOL	12	/* bi_destructor points to bio_pool */
+#define BIO_HAS_VEC	13	/* bio_free() should free bvec */
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
 /*
-- 
1.7.9.rc2

