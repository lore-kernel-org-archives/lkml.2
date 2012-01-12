Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab2ALEIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 23:08:09 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:48053 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab2ALEIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 23:08:05 -0500
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH] blockdev: convert some macros to static inlines
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20120112144215.595112f06f35d0072d5a334e@canb.auug.org.au>
Date: Wed, 11 Jan 2012 23:07:49 -0500
In-Reply-To: <20120112144215.595112f06f35d0072d5a334e@canb.auug.org.au>
	(Stephen Rothwell's message of "Thu, 12 Jan 2012 14:42:15 +1100")
Message-ID: <yq1y5tdh8bu.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090205.4F0E5C9A.0046,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "sfr" == Stephen Rothwell <sfr@canb.auug.org.au> writes:

sfr> We prefer to program in C rather than preprocessor and it fixes
sfr> this warning when CONFIG_BLK_DEV_INTEGRITY is not set:

I have the patch below in my for-block queue but don't care much either
way. Jens, which one do you prefer?


block: Stop using macro stubs for the data integrity code

Replace preprocessor macro stubs with real function declarations. Also
consolidate the function prototypes and make them independent of whether
CONFIG_BLK_DEV_INTEGRITY is enabled or not.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 847994a..f18979b 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -496,45 +496,48 @@ static inline struct bio *bio_list_get(struct bio_list *bl)
 
 #define bio_integrity(bio) (bio->bi_integrity != NULL)
 
-extern struct bio_integrity_payload *bio_integrity_alloc_bioset(struct bio *, gfp_t, unsigned int, struct bio_set *);
-extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, gfp_t, unsigned int);
-extern void bio_integrity_free(struct bio *, struct bio_set *);
-extern int bio_integrity_add_page(struct bio *, struct page *, unsigned int, unsigned int);
-extern int bio_integrity_enabled(struct bio *bio);
-extern int bio_integrity_set_tag(struct bio *, void *, unsigned int);
-extern int bio_integrity_get_tag(struct bio *, void *, unsigned int);
-extern int bio_integrity_prep(struct bio *);
-extern void bio_integrity_endio(struct bio *, int);
-extern void bio_integrity_advance(struct bio *, unsigned int);
-extern void bio_integrity_trim(struct bio *, unsigned int, unsigned int);
-extern void bio_integrity_split(struct bio *, struct bio_pair *, int);
-extern int bio_integrity_clone(struct bio *, struct bio *, gfp_t, struct bio_set *);
-extern int bioset_integrity_create(struct bio_set *, int);
-extern void bioset_integrity_free(struct bio_set *);
-extern void bio_integrity_init(void);
+#define BI_BIP_DECL(fn, ...) extern struct bio_integrity_payload * fn(__VA_ARGS__);
+#define BI_INT_DECL(fn, ...) extern int fn(__VA_ARGS__);
+#define BI_VOID_DECL(fn, ...) extern void fn(__VA_ARGS__);
 
 #else /* CONFIG_BLK_DEV_INTEGRITY */
 
-#define bio_integrity(a)		(0)
-#define bioset_integrity_create(a, b)	(0)
-#define bio_integrity_prep(a)		(0)
-#define bio_integrity_enabled(a)	(0)
-static inline int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
-				      gfp_t gfp_mask, struct bio_set *bs)
-{
-	return 0;
-}
-#define bioset_integrity_free(a)	do { } while (0)
-#define bio_integrity_free(a, b)	do { } while (0)
-#define bio_integrity_endio(a, b)	do { } while (0)
-#define bio_integrity_advance(a, b)	do { } while (0)
-#define bio_integrity_trim(a, b, c)	do { } while (0)
-#define bio_integrity_split(a, b, c)	do { } while (0)
-#define bio_integrity_set_tag(a, b, c)	do { } while (0)
-#define bio_integrity_get_tag(a, b, c)	do { } while (0)
-#define bio_integrity_init(a)		do { } while (0)
+#define BI_BIP_DECL(fn, ...) static inline void * fn(__VA_ARGS__) { return NULL; }
+#define BI_INT_DECL(fn, ...) static inline int fn(__VA_ARGS__) { return 0; }
+#define BI_VOID_DECL(fn, ...) static inline void fn(__VA_ARGS__) { return; }
+
+BI_INT_DECL(bio_integrity, struct bio *bio);
 
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
+BI_BIP_DECL(bio_integrity_alloc_bioset, struct bio *bio, gfp_t gfp_mask,
+	    unsigned int nr_vecs, struct bio_set *bs);
+BI_BIP_DECL(bio_integrity_alloc, struct bio *bio, gfp_t gfp_mask,
+	    unsigned int nr_vecs);
+BI_VOID_DECL(bio_integrity_free, struct bio *bio, struct bio_set *bio_set);
+BI_INT_DECL(bio_integrity_add_page, struct bio *bio, struct page *page,
+	    unsigned int len, unsigned int offset);
+BI_INT_DECL(bio_integrity_enabled, struct bio *bio);
+BI_INT_DECL(bio_integrity_set_tag, struct bio *bio, void *tag_buf,
+	    unsigned int len);
+BI_INT_DECL(bio_integrity_get_tag, struct bio *bio, void *tag_buf,
+	    unsigned int len);
+BI_INT_DECL(bio_integrity_prep, struct bio *bio);
+BI_VOID_DECL(bio_integrity_endio, struct bio *bio, int error);
+BI_VOID_DECL(bio_integrity_advance, struct bio *bio, unsigned int bytes_done);
+BI_VOID_DECL(bio_integrity_trim, struct bio *bio, unsigned int offset,
+	     unsigned int sectors);
+BI_VOID_DECL(bio_integrity_split, struct bio *bio, struct bio_pair *bp,
+	     int sectors);
+BI_INT_DECL(bio_integrity_clone, struct bio *bio, struct bio *bio_src,
+	    gfp_t gfp_mask, struct bio_set *bs);
+BI_INT_DECL(bioset_integrity_create, struct bio_set *bio, int pool_size);
+BI_VOID_DECL(bioset_integrity_free, struct bio_set *bio_set);
+BI_VOID_DECL(bio_integrity_init, void);
+
+#undef BI_BIP_DECL
+#undef BI_INT_DECL
+#undef BI_VOID_DECL
+
 #endif /* CONFIG_BLOCK */
 #endif /* __LINUX_BIO_H */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e6b1491..b93a424 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1200,8 +1200,6 @@ static inline uint64_t rq_io_start_time_ns(struct request *req)
 #define MODULE_ALIAS_BLOCKDEV_MAJOR(major) \
 	MODULE_ALIAS("block-major-" __stringify(major) "-*")
 
-#if defined(CONFIG_BLK_DEV_INTEGRITY)
-
 #define INTEGRITY_FLAG_READ	2	/* verify data integrity on read */
 #define INTEGRITY_FLAG_WRITE	4	/* generate data integrity on write */
 
@@ -1235,17 +1233,7 @@ struct blk_integrity {
 	struct kobject		kobj;
 };
 
-extern bool blk_integrity_is_initialized(struct gendisk *);
-extern int blk_integrity_register(struct gendisk *, struct blk_integrity *);
-extern void blk_integrity_unregister(struct gendisk *);
-extern int blk_integrity_compare(struct gendisk *, struct gendisk *);
-extern int blk_rq_map_integrity_sg(struct request_queue *, struct bio *,
-				   struct scatterlist *);
-extern int blk_rq_count_integrity_sg(struct request_queue *, struct bio *);
-extern int blk_integrity_merge_rq(struct request_queue *, struct request *,
-				  struct request *);
-extern int blk_integrity_merge_bio(struct request_queue *, struct request *,
-				   struct bio *);
+#if defined(CONFIG_BLK_DEV_INTEGRITY)
 
 static inline
 struct blk_integrity *bdev_get_integrity(struct block_device *bdev)
@@ -1266,11 +1254,41 @@ static inline int blk_integrity_rq(struct request *rq)
 	return bio_integrity(rq->bio);
 }
 
-static inline void blk_queue_max_integrity_segments(struct request_queue *q,
-						    unsigned int segs)
-{
-	q->limits.max_integrity_segments = segs;
-}
+#define BI_INT_DECL(fn, ...)  extern int fn(__VA_ARGS__);
+#define BI_BOOL_DECL(fn, ...) extern bool fn(__VA_ARGS__);
+#define BI_VOID_DECL(fn, ...) extern void fn(__VA_ARGS__);
+
+#else /* CONFIG_BLK_DEV_INTEGRITY */
+
+#define BI_INT_DECL(fn, ...)  static inline int fn(__VA_ARGS__) { return 0; }
+#define BI_BOOL_DECL(fn, ...) static inline bool fn(__VA_ARGS__) { return 0; }
+#define BI_VOID_DECL(fn, ...) static inline void fn(__VA_ARGS__) { return; }
+#define BI_BI_DECL(fn, ...)   static inline void * fn(__VA_ARGS__) { return NULL; }
+
+BI_BI_DECL(bdev_get_integrity, struct block_device *bdev);
+BI_BI_DECL(blk_get_integrity, struct gendisk *disk);
+BI_INT_DECL(blk_integrity_rq, struct request *rq);
+
+#endif /* CONFIG_BLK_DEV_INTEGRITY */
+
+BI_INT_DECL(blk_integrity_register, struct gendisk *disk,
+	    struct blk_integrity *template);
+BI_VOID_DECL(blk_integrity_unregister, struct gendisk *gd);
+BI_INT_DECL(blk_integrity_compare, struct gendisk *gd1, struct gendisk *gd2);
+BI_INT_DECL(blk_integrity_merge_rq, struct request_queue *q,
+	    struct request *req, struct request *next);
+BI_INT_DECL(blk_integrity_merge_bio, struct request_queue *q,
+	    struct request *req, struct bio *bio);
+BI_INT_DECL(blk_rq_count_integrity_sg, struct request_queue *q,
+	    struct bio *bio);
+BI_INT_DECL(blk_rq_map_integrity_sg, struct request_queue *rq, struct bio *bio,
+	    struct scatterlist *sglist);
+BI_BOOL_DECL(blk_integrity_is_initialized, struct gendisk *gd);
+
+#undef BI_INT_DECL
+#undef BI_BOOL_DECL
+#undef BI_VOID_DECL
+#undef BI_BI_DECL
 
 static inline unsigned short
 queue_max_integrity_segments(struct request_queue *q)
@@ -1278,23 +1296,11 @@ queue_max_integrity_segments(struct request_queue *q)
 	return q->limits.max_integrity_segments;
 }
 
-#else /* CONFIG_BLK_DEV_INTEGRITY */
-
-#define blk_integrity_rq(rq)			(0)
-#define blk_rq_count_integrity_sg(a, b)		(0)
-#define blk_rq_map_integrity_sg(a, b, c)	(0)
-#define bdev_get_integrity(a)			(0)
-#define blk_get_integrity(a)			(0)
-#define blk_integrity_compare(a, b)		(0)
-#define blk_integrity_register(a, b)		(0)
-#define blk_integrity_unregister(a)		do { } while (0)
-#define blk_queue_max_integrity_segments(a, b)	do { } while (0)
-#define queue_max_integrity_segments(a)		(0)
-#define blk_integrity_merge_rq(a, b, c)		(0)
-#define blk_integrity_merge_bio(a, b, c)	(0)
-#define blk_integrity_is_initialized(a)		(0)
-
-#endif /* CONFIG_BLK_DEV_INTEGRITY */
+static inline void blk_queue_max_integrity_segments(struct request_queue *q,
+						    unsigned int segs)
+{
+	q->limits.max_integrity_segments = segs;
+}
 
 struct block_device_operations {
 	int (*open) (struct block_device *, fmode_t);
