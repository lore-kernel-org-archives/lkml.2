Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab2GXUOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 16:14:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54756 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab2GXUMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 16:12:09 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com,
        bharrosh@panasas.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: [PATCH v4 12/12] block: Only clone bio vecs that are in use
Date: Tue, 24 Jul 2012 13:11:29 -0700
Message-Id: <1343160689-12378-13-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1343160689-12378-1-git-send-email-koverstreet@google.com>
References: <1343160689-12378-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcache creates large bios internally, and then splits them according to
the device requirements before it sends them down. If a lower level
device tries to clone the bio, and the original bio had more than
BIO_MAX_PAGES, the clone will fail unecessarily.

We can fix this by only cloning the bio vecs that are actually in use.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 drivers/block/rbd.c |    2 +-
 drivers/md/dm.c     |    5 ++---
 fs/bio.c            |   13 +++++++------
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 692cf05..21edfe5 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -714,7 +714,7 @@ static struct bio *bio_chain_clone(struct bio **old, struct bio **next,
 	}
 
 	while (old_chain && (total < len)) {
-		tmp = bio_kmalloc(gfpmask, old_chain->bi_max_vecs);
+		tmp = bio_kmalloc(gfpmask, bio_segments(old_chain));
 		if (!tmp)
 			goto err_out;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3f3c26e..193fb19 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1057,11 +1057,10 @@ static struct bio *clone_bio(struct bio *bio, sector_t sector,
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
index 7a0801d..ec6a357 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -451,8 +451,9 @@ EXPORT_SYMBOL(bio_phys_segments);
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
@@ -461,10 +462,10 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
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
 
@@ -479,7 +480,7 @@ EXPORT_SYMBOL(__bio_clone);
 struct bio *bio_clone_bioset(struct bio *bio, gfp_t gfp_mask,
 			     struct bio_set *bs)
 {
-	struct bio *b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, bs);
+	struct bio *b = bio_alloc_bioset(gfp_mask, bio_segments(bio), bs);
 
 	if (!b)
 		return NULL;
@@ -509,7 +510,7 @@ EXPORT_SYMBOL(bio_clone);
 
 struct bio *bio_clone_kmalloc(struct bio *bio, gfp_t gfp_mask)
 {
-	struct bio *b = bio_kmalloc(gfp_mask, bio->bi_max_vecs);
+	struct bio *b = bio_kmalloc(gfp_mask, bio_segments(bio));
 
 	if (!b)
 		return NULL;
-- 
1.7.7.3

