Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab2HFWJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 18:09:23 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:44617 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab2HFWJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 18:09:19 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com,
        vgoyal@redhat.com, mpatocka@redhat.com, sage@newdream.net,
        yehuda@hq.newdream.net
Subject: [PATCH v5 08/12] block: Introduce new bio_split()
Date: Mon,  6 Aug 2012 15:08:37 -0700
Message-Id: <1344290921-25154-9-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1344290921-25154-1-git-send-email-koverstreet@google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new bio_split() can split arbitrary bios - it's not restricted to
single page bios, like the old bio_split() (previously renamed to
bio_pair_split()). It also has different semantics - it doesn't allocate
a struct bio_pair, leaving it up to the caller to handle completions.

v5: Take out current->bio_list check and make it the caller's
responsibility, per Boaz

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/bio.c            |   96 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/bio.h |    3 ++
 2 files changed, 99 insertions(+), 0 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 0470376..312e5de 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1537,6 +1537,102 @@ struct bio_pair *bio_pair_split(struct bio *bi, int first_sectors)
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
+ *
+ * BIG FAT WARNING:
+ *
+ * If you're calling this from under generic_make_request() (i.e.
+ * current->bio_list != NULL), you should mask out __GFP_WAIT and punt to
+ * workqueue if the allocation fails. Otherwise, your code will probably
+ * deadlock.
+ *
+ * You can't allocate more than once from the same bio pool without submitting
+ * the previous allocations (so they'll eventually complete and deallocate
+ * themselves), but if you're under generic_make_request() those previous
+ * allocations won't submit until you return . And if you have to split bios,
+ * you should expect that some bios will require multiple splits.
+ */
+struct bio *bio_split(struct bio *bio, int sectors,
+		      gfp_t gfp, struct bio_set *bs)
+{
+	unsigned idx, vcnt = 0, nbytes = sectors << 9;
+	struct bio_vec *bv;
+	struct bio *ret = NULL;
+
+	BUG_ON(sectors <= 0);
+
+	if (sectors >= bio_sectors(bio))
+		return bio;
+
+	trace_block_split(bdev_get_queue(bio->bi_bdev), bio,
+			  bio->bi_sector + sectors);
+
+	bio_for_each_segment(bv, bio, idx) {
+		vcnt = idx - bio->bi_idx;
+
+		if (!nbytes) {
+			ret = bio_alloc_bioset(gfp, 0, bs);
+			if (!ret)
+				return NULL;
+
+			ret->bi_io_vec = bio_iovec(bio);
+			ret->bi_flags |= 1 << BIO_CLONED;
+			break;
+		} else if (nbytes < bv->bv_len) {
+			ret = bio_alloc_bioset(gfp, ++vcnt, bs);
+			if (!ret)
+				return NULL;
+
+			memcpy(ret->bi_io_vec, bio_iovec(bio),
+			       sizeof(struct bio_vec) * vcnt);
+
+			ret->bi_io_vec[vcnt - 1].bv_len = nbytes;
+			bv->bv_offset	+= nbytes;
+			bv->bv_len	-= nbytes;
+			break;
+		}
+
+		nbytes -= bv->bv_len;
+	}
+
+	ret->bi_bdev	= bio->bi_bdev;
+	ret->bi_sector	= bio->bi_sector;
+	ret->bi_size	= sectors << 9;
+	ret->bi_rw	= bio->bi_rw;
+	ret->bi_vcnt	= vcnt;
+	ret->bi_max_vecs = vcnt;
+	ret->bi_end_io	= bio->bi_end_io;
+	ret->bi_private	= bio->bi_private;
+
+	bio->bi_sector	+= sectors;
+	bio->bi_size	-= sectors << 9;
+	bio->bi_idx	 = idx;
+
+	if (bio_integrity(bio)) {
+		bio_integrity_clone(ret, bio, gfp, bs);
+		bio_integrity_trim(ret, 0, bio_sectors(ret));
+		bio_integrity_trim(bio, bio_sectors(ret), bio_sectors(bio));
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(bio_split);
+
+/**
  *      bio_sector_offset - Find hardware sector offset in bio
  *      @bio:           bio to inspect
  *      @index:         bio_vec index
diff --git a/include/linux/bio.h b/include/linux/bio.h
index fdcc8dc..2d06262 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -201,6 +201,9 @@ struct bio_pair {
 	atomic_t			cnt;
 	int				error;
 };
+
+extern struct bio *bio_split(struct bio *bio, int sectors,
+			     gfp_t gfp, struct bio_set *bs);
 extern struct bio_pair *bio_pair_split(struct bio *bi, int first_sectors);
 extern void bio_pair_release(struct bio_pair *dbio);
 
-- 
1.7.7.3

