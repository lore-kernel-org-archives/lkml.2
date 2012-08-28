Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab2H1Rjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 13:39:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64377 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2H1Rhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 13:37:48 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, vgoyal@redhat.com,
        mpatocka@redhat.com, bharrosh@panasas.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v7 3/9] block: Add bio_reset()
Date: Tue, 28 Aug 2012 10:37:30 -0700
Message-Id: <1346175456-1572-4-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346175456-1572-1-git-send-email-koverstreet@google.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reusing bios is something that's been highly frowned upon in the past,
but driver code keeps doing it anyways. If it's going to happen anyways,
we should provide a generic method.

This'll help with getting rid of bi_destructor - drivers/block/pktcdvd.c
was open coding it, by doing a bio_init() and resetting bi_destructor.

v5: Add a define BIO_RESET_BITS, to be very explicit about what parts of
bio->bi_flags are saved.
v6: Further commenting verbosity, per Tejun

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
Acked-by: Tejun Heo <tj@kernel.org>
---
 fs/bio.c                  | 14 ++++++++++++++
 include/linux/bio.h       |  1 +
 include/linux/blk_types.h | 21 +++++++++++++++++----
 3 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index e017f7a..52da084 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -262,6 +262,20 @@ void bio_init(struct bio *bio)
 }
 EXPORT_SYMBOL(bio_init);
 
+void bio_reset(struct bio *bio)
+{
+	unsigned long flags = bio->bi_flags & (~0UL << BIO_RESET_BITS);
+
+	if (bio_integrity(bio))
+		bio_integrity_free(bio, bio->bi_pool);
+
+	bio_disassociate_task(bio);
+
+	memset(bio, 0, BIO_RESET_BYTES);
+	bio->bi_flags = flags|(1 << BIO_UPTODATE);
+}
+EXPORT_SYMBOL(bio_reset);
+
 /**
  * bio_alloc_bioset - allocate a bio for I/O
  * @gfp_mask:   the GFP_ mask given to the slab allocator
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 2643589..ba60319 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -226,6 +226,7 @@ extern void __bio_clone(struct bio *, struct bio *);
 extern struct bio *bio_clone(struct bio *, gfp_t);
 
 extern void bio_init(struct bio *);
+extern void bio_reset(struct bio *);
 
 extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index af9dd9d..691edd1 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -59,15 +59,19 @@ struct bio {
 	unsigned int		bi_seg_front_size;
 	unsigned int		bi_seg_back_size;
 
+	bio_end_io_t		*bi_end_io;
+
+	void			*bi_private;
+
+	/*
+	 * Everything starting with bi_max_vecs will be preserved by bio_reset()
+	 */
+
 	unsigned int		bi_max_vecs;	/* max bvl_vecs we can hold */
 
 	atomic_t		bi_cnt;		/* pin count */
 
 	struct bio_vec		*bi_io_vec;	/* the actual vec list */
-
-	bio_end_io_t		*bi_end_io;
-
-	void			*bi_private;
 #ifdef CONFIG_BLK_CGROUP
 	/*
 	 * Optional ioc and css associated with this bio.  Put on bio
@@ -93,6 +97,8 @@ struct bio {
 	struct bio_vec		bi_inline_vecs[0];
 };
 
+#define BIO_RESET_BYTES		offsetof(struct bio, bi_max_vecs)
+
 /*
  * bio flags
  */
@@ -108,6 +114,13 @@ struct bio {
 #define BIO_FS_INTEGRITY 9	/* fs owns integrity data, not block layer */
 #define BIO_QUIET	10	/* Make BIO Quiet */
 #define BIO_MAPPED_INTEGRITY 11/* integrity metadata has been remapped */
+
+/*
+ * Flags starting here get preserved by bio_reset() - this includes
+ * BIO_POOL_IDX()
+ */
+#define BIO_RESET_BITS	12
+
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
 /*
-- 
1.7.12

