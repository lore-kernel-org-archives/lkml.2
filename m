Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964904Ab2HVRFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 13:05:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62973 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964883Ab2HVREt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 13:04:49 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, vgoyal@redhat.com,
        mpatocka@redhat.com, bharrosh@panasas.com,
        Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>,
        Sage Weil <sage@inktank.com>
Subject: [PATCH v6 13/13] block: Only clone bio vecs that are in use
Date: Wed, 22 Aug 2012 10:04:10 -0700
Message-Id: <1345655050-28199-14-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1345655050-28199-1-git-send-email-koverstreet@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcache creates large bios internally, and then splits them according to
the device requirements before it sends them down. If a lower level
device tries to clone the bio, and the original bio had more than
BIO_MAX_PAGES, the clone will fail unecessarily.

We can fix this by only cloning the bio vecs that are actually in use.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: Alasdair Kergon <agk@redhat.com>
CC: Sage Weil <sage@inktank.com>
---
 drivers/block/rbd.c |  2 +-
 drivers/md/dm.c     |  5 ++---
 fs/bio.c            | 15 ++++++++++-----
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 63e5852..5c3457f 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -734,7 +734,7 @@ static struct bio *bio_chain_clone(struct bio **old, struct bio **next,
 	}
 
 	while (old_chain && (total < len)) {
-		tmp = bio_kmalloc(gfpmask, old_chain->bi_max_vecs);
+		tmp = bio_kmalloc(gfpmask, bio_segments(old_chain));
 		if (!tmp)
 			goto err_out;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a3c38b9..3aeb108 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1080,11 +1080,10 @@ static struct bio *clone_bio(struct bio *bio, sector_t sector,
 {
 	struct bio *clone;
 
-	clone = bio_alloc_bioset(GFP_NOIO, bio->bi_max_vecs, bs);
+	clone = bio_alloc_bioset(GFP_NOIO, bv_count, bs);
 	__bio_clone(clone, bio);
 	clone->bi_sector = sector;
-	clone->bi_idx = idx;
-	clone->bi_vcnt = idx + bv_count;
+	clone->bi_vcnt = bv_count;
 	clone->bi_size = to_bytes(len);
 	clone->bi_flags &= ~(1 << BIO_SEG_VALID);
 
diff --git a/fs/bio.c b/fs/bio.c
index a58c3c6..3f43e50 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -450,11 +450,16 @@ EXPORT_SYMBOL(bio_phys_segments);
  *	Clone a &bio. Caller will own the returned bio, but not
  *	the actual data it points to. Reference count of returned
  * 	bio will be one.
+ *
+ *	We don't clone the entire bvec, just the part from bi_idx to b_vcnt
+ *	(i.e. what the bio currently points to, so the new bio is still
+ *	equivalent to the old bio).
  */
 void __bio_clone(struct bio *bio, struct bio *bio_src)
 {
-	memcpy(bio->bi_io_vec, bio_src->bi_io_vec,
-		bio_src->bi_max_vecs * sizeof(struct bio_vec));
+	memcpy(bio->bi_io_vec,
+	       bio_iovec(bio_src),
+	       bio_segments(bio_src) * sizeof(struct bio_vec));
 
 	/*
 	 * most users will be overriding ->bi_bdev with a new target,
@@ -463,10 +468,10 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
 	bio->bi_sector = bio_src->bi_sector;
 	bio->bi_bdev = bio_src->bi_bdev;
 	bio->bi_flags |= 1 << BIO_CLONED;
+	bio->bi_flags &= ~(1 << BIO_SEG_VALID);
 	bio->bi_rw = bio_src->bi_rw;
-	bio->bi_vcnt = bio_src->bi_vcnt;
+	bio->bi_vcnt = bio_segments(bio_src);
 	bio->bi_size = bio_src->bi_size;
-	bio->bi_idx = bio_src->bi_idx;
 }
 EXPORT_SYMBOL(__bio_clone);
 
@@ -483,7 +488,7 @@ struct bio *bio_clone_bioset(struct bio *bio, gfp_t gfp_mask,
 {
 	struct bio *b;
 
-	b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, bs);
+	b = bio_alloc_bioset(gfp_mask, bio_segments(bio), bs);
 	if (!b)
 		return NULL;
 
-- 
1.7.12

