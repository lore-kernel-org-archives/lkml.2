Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964894Ab2HVREx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 13:04:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34722 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964877Ab2HVREo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 13:04:44 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, vgoyal@redhat.com,
        mpatocka@redhat.com, bharrosh@panasas.com,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v6 10/13] block: Introduce new bio_split()
Date: Wed, 22 Aug 2012 10:04:07 -0700
Message-Id: <1345655050-28199-11-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1345655050-28199-1-git-send-email-koverstreet@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new bio_split() can split arbitrary bios - it's not restricted to
single page bios, like the old bio_split() (previously renamed to
bio_pair_split()). It also has different semantics - it doesn't allocate
a struct bio_pair, leaving it up to the caller to handle completions.

We have to take that BUG_ON() out of bio_integrity_trim() because this
bio_split() needs to use it, and there's no reason it has to be used on
bios marked as cloned; BIO_CLONED doesn't seem to have clearly
documented semantics anyways.

v5: Take out current->bio_list check and make it the caller's
responsibility, per Boaz
v6: Rename @ret to @split, change to not return original bio or copy
bi_private/bi_end_io, per Tejun

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: Martin K. Petersen <martin.petersen@oracle.com>
---
 fs/bio-integrity.c  |  1 -
 fs/bio.c            | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/bio.h | 13 ++++++++
 3 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index e85c04b..35ee3d4 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -672,7 +672,6 @@ void bio_integrity_trim(struct bio *bio, unsigned int offset,
 
 	BUG_ON(bip == NULL);
 	BUG_ON(bi == NULL);
-	BUG_ON(!bio_flagged(bio, BIO_CLONED));
 
 	nr_sectors = bio_integrity_hw_sectors(bi, sectors);
 	bip->bip_sector = bip->bip_sector + offset;
diff --git a/fs/bio.c b/fs/bio.c
index 2f2cf19..c079006 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1541,6 +1541,101 @@ struct bio_pair *bio_pair_split(struct bio *bi, int first_sectors)
 EXPORT_SYMBOL(bio_pair_split);
 
 /**
+ * bio_split - split a bio
+ * @bio:	bio to split
+ * @sectors:	number of sectors to split from the front of @bio
+ * @gfp:	gfp mask
+ * @bs:		bio set to allocate from
+ *
+ * Allocates and returns a new bio which represents @sectors from the start of
+ * @bio, and updates @bio to represent the remaining sectors.
+ *
+ * If bio_sectors(@bio) was less than or equal to @sectors, returns @bio
+ * unchanged.
+ *
+ * The newly allocated bio will point to @bio's bi_io_vec, if the split was on a
+ * bvec boundry; it is the caller's responsibility to ensure that @bio is not
+ * freed before the split.
+ */
+struct bio *bio_split(struct bio *bio, int sectors,
+		      gfp_t gfp, struct bio_set *bs)
+{
+	unsigned idx, vcnt = 0, nbytes = sectors << 9;
+	struct bio_vec *bv;
+	struct bio *split = NULL;
+
+	BUG_ON(sectors <= 0);
+	BUG_ON(sectors >= bio_sectors(bio));
+
+	trace_block_split(bdev_get_queue(bio->bi_bdev), bio,
+			  bio->bi_sector + sectors);
+
+	if (bio->bi_rw & REQ_DISCARD) {
+		split = bio_alloc_bioset(gfp, 1, bs);
+
+		split->bi_io_vec = bio_iovec(bio);
+		idx = 0;
+		goto out;
+	}
+
+	bio_for_each_segment(bv, bio, idx) {
+		vcnt = idx - bio->bi_idx;
+
+		/*
+		 * The split might occur on a bvec boundry (nbytes == 0) - in
+		 * that case we can reuse the bvec from the old bio.
+		 *
+		 * Or, if the split isn't aligned, we'll have to allocate a new
+		 * bvec and patch up the two copies of the bvec we split in.
+		 */
+
+		if (!nbytes) {
+			split = bio_alloc_bioset(gfp, 0, bs);
+			if (!split)
+				return NULL;
+
+			split->bi_io_vec = bio_iovec(bio);
+			split->bi_flags |= 1 << BIO_CLONED;
+			break;
+		} else if (nbytes < bv->bv_len) {
+			split = bio_alloc_bioset(gfp, ++vcnt, bs);
+			if (!split)
+				return NULL;
+
+			memcpy(split->bi_io_vec, bio_iovec(bio),
+			       sizeof(struct bio_vec) * vcnt);
+
+			split->bi_io_vec[vcnt - 1].bv_len = nbytes;
+			bv->bv_offset += nbytes;
+			bv->bv_len -= nbytes;
+			break;
+		}
+
+		nbytes -= bv->bv_len;
+	}
+out:
+	split->bi_bdev		= bio->bi_bdev;
+	split->bi_sector	= bio->bi_sector;
+	split->bi_size		= sectors << 9;
+	split->bi_rw		= bio->bi_rw;
+	split->bi_vcnt		= vcnt;
+	split->bi_max_vecs	= vcnt;
+
+	bio->bi_sector	       += sectors;
+	bio->bi_size	       -= sectors << 9;
+	bio->bi_idx		= idx;
+
+	if (bio_integrity(bio)) {
+		bio_integrity_clone(split, bio, gfp, bs);
+		bio_integrity_trim(split, 0, bio_sectors(split));
+		bio_integrity_trim(bio, bio_sectors(split), bio_sectors(bio));
+	}
+
+	return split;
+}
+EXPORT_SYMBOL_GPL(bio_split);
+
+/**
  *      bio_sector_offset - Find hardware sector offset in bio
  *      @bio:           bio to inspect
  *      @index:         bio_vec index
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 13f4188..1c3bb47 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -201,6 +201,19 @@ struct bio_pair {
 	atomic_t			cnt;
 	int				error;
 };
+
+extern struct bio *bio_split(struct bio *bio, int sectors,
+			     gfp_t gfp, struct bio_set *bs);
+
+static inline struct bio *bio_next_split(struct bio *bio, int sectors,
+					 gfp_t gfp, struct bio_set *bs)
+{
+	if (sectors >= bio_sectors(bio))
+		return bio;
+
+	return bio_split(bio, sectors, gfp, bs);
+}
+
 extern struct bio_pair *bio_pair_split(struct bio *bi, int first_sectors);
 extern void bio_pair_release(struct bio_pair *dbio);
 
-- 
1.7.12

