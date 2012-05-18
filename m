Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030997Ab2ERDAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:00:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43831 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030975Ab2ERDAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 23:00:23 -0400
From: koverstreet@google.com
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de
Subject: [PATCH 12/13] Make generic_make_request handle arbitrarily large bios
Date: Thu, 17 May 2012 22:59:59 -0400
Message-Id: <1114e7019b0055fc09a54b59b36398d5c54f5e32.1337308722.git.koverstreet@google.com>
X-Mailer: git-send-email 1.7.9.rc2
In-Reply-To: <cover.1337308722.git.koverstreet@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
In-Reply-To: <cover.1337308722.git.koverstreet@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <koverstreet@google.com>

The way the block layer is currently written, it goes to great lengths
to avoid having to split bios; upper layer code (such as bio_add_page())
checks what the underlying device can handle and tries to always create
bios that don't need to be split.

But this approach becomes unwieldy and eventually breaks down with
stacked devices and devices with dynamic limits, and it adds a lot of
complexity. If the block layer could split bios as needed, we could
eliminate a lot of complexity elsewhere - particularly in stacked
drivers. Code that creates bios can then create whatever size bios are
convenient, and more importantly stacked drivers don't have to deal with
both their own bio size limitations and the limitations of the
(potentially multiple) devices underneath them.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 block/blk-core.c       |  111 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/bio.c               |   41 ++++++++++++++++++
 include/linux/bio.h    |    7 +++
 include/linux/blkdev.h |    3 +
 4 files changed, 162 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 91617eb..1d7a482 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -29,6 +29,7 @@
 #include <linux/fault-inject.h>
 #include <linux/list_sort.h>
 #include <linux/delay.h>
+#include <linux/closure.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/block.h>
@@ -52,6 +53,12 @@ static struct kmem_cache *request_cachep;
 struct kmem_cache *blk_requestq_cachep;
 
 /*
+ * For bio_split_hook
+ */
+static struct kmem_cache *bio_split_cache;
+static struct workqueue_struct *bio_split_wq;
+
+/*
  * Controlling structure to kblockd
  */
 static struct workqueue_struct *kblockd_workqueue;
@@ -487,6 +494,14 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	if (q->id < 0)
 		goto fail_q;
 
+	q->bio_split_hook = mempool_create_slab_pool(4, bio_split_cache);
+	if (!q->bio_split_hook)
+		goto fail_split_hook;
+
+	q->bio_split = bioset_create(4, 0);
+	if (!q->bio_split)
+		goto fail_split;
+
 	q->backing_dev_info.ra_pages =
 			(VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 	q->backing_dev_info.state = 0;
@@ -526,6 +541,10 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 
 fail_id:
 	ida_simple_remove(&blk_queue_ida, q->id);
+fail_split:
+	bioset_free(q->bio_split);
+fail_split_hook:
+	mempool_destroy(q->bio_split_hook);
 fail_q:
 	kmem_cache_free(blk_requestq_cachep, q);
 	return NULL;
@@ -1493,6 +1512,83 @@ static inline bool should_fail_request(struct hd_struct *part,
 
 #endif /* CONFIG_FAIL_MAKE_REQUEST */
 
+struct bio_split_hook {
+	struct closure		cl;
+	struct request_queue	*q;
+	struct bio		*bio;
+	bio_end_io_t		*bi_end_io;
+	void			*bi_private;
+};
+
+static void bio_submit_split_done(struct closure *cl)
+{
+	struct bio_split_hook *s = container_of(cl, struct bio_split_hook, cl);
+
+	s->bio->bi_end_io	= s->bi_end_io;
+	s->bio->bi_private	= s->bi_private;
+	bio_endio(s->bio, 0);
+
+	closure_debug_destroy(&s->cl);
+	mempool_free(s, s->q->bio_split_hook);
+}
+
+static void bio_submit_split_endio(struct bio *bio, int error)
+{
+	struct closure *cl = bio->bi_private;
+	struct bio_split_hook *s = container_of(cl, struct bio_split_hook, cl);
+
+	if (error)
+		clear_bit(BIO_UPTODATE, &s->bio->bi_flags);
+
+	bio_put(bio);
+	closure_put(cl);
+}
+
+static void __bio_submit_split(struct closure *cl)
+{
+	struct bio_split_hook *s = container_of(cl, struct bio_split_hook, cl);
+	struct bio *bio = s->bio, *n;
+
+	do {
+		n = bio_split(bio, bio_max_sectors(bio),
+			      GFP_NOIO, s->q->bio_split);
+		if (!n)
+			continue_at(cl, __bio_submit_split, bio_split_wq);
+
+		closure_get(cl);
+		generic_make_request(n);
+	} while (n != bio);
+
+	continue_at(cl, bio_submit_split_done, NULL);
+}
+
+static int bio_submit_split(struct bio *bio)
+{
+	struct bio_split_hook *s;
+	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
+
+	if (!bio_has_data(bio) ||
+	    !q ||
+	    !q->bio_split_hook ||
+	    bio_sectors(bio) <= bio_max_sectors(bio))
+		return 0;
+
+	s = mempool_alloc(q->bio_split_hook, GFP_NOIO);
+
+	closure_init(&s->cl, NULL);
+	s->bio		= bio;
+	s->q		= q;
+	s->bi_end_io	= bio->bi_end_io;
+	s->bi_private	= bio->bi_private;
+
+	bio_get(bio);
+	bio->bi_end_io	= bio_submit_split_endio;
+	bio->bi_private	= &s->cl;
+
+	__bio_submit_split(&s->cl);
+	return 1;
+}
+
 /*
  * Check whether this bio extends beyond the end of the device.
  */
@@ -1646,6 +1742,14 @@ void generic_make_request(struct bio *bio)
 	 * it is non-NULL, then a make_request is active, and new requests
 	 * should be added at the tail
 	 */
+
+	/*
+	 * If the device can't accept arbitrary sized bios, check if we
+	 * need to split:
+	 */
+	if (bio_submit_split(bio))
+		return;
+
 	if (current->bio_list) {
 		bio_list_add(current->bio_list, bio);
 		return;
@@ -2892,11 +2996,18 @@ int __init blk_dev_init(void)
 	if (!kblockd_workqueue)
 		panic("Failed to create kblockd\n");
 
+	bio_split_wq = alloc_workqueue("bio_split", WQ_MEM_RECLAIM, 0);
+	if (!bio_split_wq)
+		panic("Failed to create bio_split wq\n");
+
 	request_cachep = kmem_cache_create("blkdev_requests",
 			sizeof(struct request), 0, SLAB_PANIC, NULL);
 
 	blk_requestq_cachep = kmem_cache_create("blkdev_queue",
 			sizeof(struct request_queue), 0, SLAB_PANIC, NULL);
 
+	bio_split_cache = kmem_cache_create("bio_split_hook",
+			sizeof(struct bio_split_hook), 0, SLAB_PANIC, NULL);
+
 	return 0;
 }
diff --git a/fs/bio.c b/fs/bio.c
index 781a8cf..360ac93 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -428,6 +428,47 @@ inline int bio_phys_segments(struct request_queue *q, struct bio *bio)
 }
 EXPORT_SYMBOL(bio_phys_segments);
 
+unsigned __bio_max_sectors(struct bio *bio, struct block_device *bdev,
+			   sector_t sector)
+{
+	unsigned ret = bio_sectors(bio);
+	struct request_queue *q = bdev_get_queue(bdev);
+	struct bio_vec *bv, *end = bio_iovec(bio) +
+		min_t(int, bio_segments(bio), queue_max_segments(q));
+
+	struct bvec_merge_data bvm = {
+		.bi_bdev	= bdev,
+		.bi_sector	= sector,
+		.bi_size	= 0,
+		.bi_rw		= bio->bi_rw,
+	};
+
+	if (bio_segments(bio) > queue_max_segments(q) ||
+	    q->merge_bvec_fn) {
+		ret = 0;
+
+		for (bv = bio_iovec(bio); bv < end; bv++) {
+			if (q->merge_bvec_fn &&
+			    q->merge_bvec_fn(q, &bvm, bv) < (int) bv->bv_len)
+				break;
+
+			ret		+= bv->bv_len >> 9;
+			bvm.bi_size	+= bv->bv_len;
+		}
+
+		if (ret >= (BIO_MAX_PAGES * PAGE_SIZE) >> 9)
+			return (BIO_MAX_PAGES * PAGE_SIZE) >> 9;
+	}
+
+	ret = min(ret, queue_max_sectors(q));
+
+	WARN_ON(!ret);
+	ret = max_t(int, ret, bio_iovec(bio)->bv_len >> 9);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__bio_max_sectors);
+
 /**
  * 	__bio_clone	-	clone a bio
  * 	@bio: destination bio
diff --git a/include/linux/bio.h b/include/linux/bio.h
index db38175..79f8173 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -224,6 +224,13 @@ extern void bio_endio(struct bio *, int);
 struct request_queue;
 extern int bio_phys_segments(struct request_queue *, struct bio *);
 
+unsigned __bio_max_sectors(struct bio *, struct block_device *, sector_t);
+
+static inline unsigned bio_max_sectors(struct bio *bio)
+{
+	return __bio_max_sectors(bio, bio->bi_bdev, bio->bi_sector);
+}
+
 extern void __bio_clone(struct bio *, struct bio *);
 extern struct bio *bio_clone_bioset(struct bio *, gfp_t, struct bio_set *bs);
 extern struct bio *bio_clone(struct bio *, gfp_t);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2aa2466..464adb7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -399,6 +399,9 @@ struct request_queue {
 	/* Throttle data */
 	struct throtl_data *td;
 #endif
+
+	mempool_t		*bio_split_hook;
+	struct bio_set		*bio_split;
 };
 
 #define QUEUE_FLAG_QUEUED	1	/* uses generic tag queueing */
-- 
1.7.9.rc2

