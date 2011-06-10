Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab1FJN3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:29:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756120Ab1FJN3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:29:06 -0400
From: Jerome Marchand <jmarchan@redhat.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jeff Moyer <jmoyer@redhat.com>, Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 2/4] Staging: zram: Refactor zram_read/write() functions
Date: Fri, 10 Jun 2011 15:28:47 +0200
Message-Id: <1307712529-9757-2-git-send-email-jmarchan@redhat.com>
In-Reply-To: <1307712529-9757-1-git-send-email-jmarchan@redhat.com>
References: <1307712529-9757-1-git-send-email-jmarchan@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch refactor the code of zram_read/write() functions. It does
not removes a lot of duplicate code alone, but is mostly a helper for
the third patch of this series (Staging: zram: allow partial page
operations).

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 drivers/staging/zram/zram_drv.c |  315 +++++++++++++++++++--------------------
 1 files changed, 155 insertions(+), 160 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 3305e1a..33060d1 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -203,196 +203,199 @@ static void handle_uncompressed_page(struct zram *zram,
 	flush_dcache_page(page);
 }
 
-static void zram_read(struct zram *zram, struct bio *bio)
+static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
+			  u32 index, struct bio *bio)
 {
+	int ret;
+	size_t clen;
+	struct page *page;
+	struct zobj_header *zheader;
+	unsigned char *user_mem, *cmem;
 
-	int i;
-	u32 index;
-	struct bio_vec *bvec;
-
-	zram_stat64_inc(zram, &zram->stats.num_reads);
-	index = bio->bi_sector >> SECTORS_PER_PAGE_SHIFT;
-
-	bio_for_each_segment(bvec, bio, i) {
-		int ret;
-		size_t clen;
-		struct page *page;
-		struct zobj_header *zheader;
-		unsigned char *user_mem, *cmem;
-
-		page = bvec->bv_page;
-
-		if (zram_test_flag(zram, index, ZRAM_ZERO)) {
-			handle_zero_page(page);
-			index++;
-			continue;
-		}
+	page = bvec->bv_page;
 
-		/* Requested page is not present in compressed area */
-		if (unlikely(!zram->table[index].page)) {
-			pr_debug("Read before write: sector=%lu, size=%u",
-				(ulong)(bio->bi_sector), bio->bi_size);
-			handle_zero_page(page);
-			index++;
-			continue;
-		}
+	if (zram_test_flag(zram, index, ZRAM_ZERO)) {
+		handle_zero_page(page);
+		return 0;
+	}
 
-		/* Page is stored uncompressed since it's incompressible */
-		if (unlikely(zram_test_flag(zram, index, ZRAM_UNCOMPRESSED))) {
-			handle_uncompressed_page(zram, page, index);
-			index++;
-			continue;
-		}
+	/* Requested page is not present in compressed area */
+	if (unlikely(!zram->table[index].page)) {
+		pr_debug("Read before write: sector=%lu, size=%u",
+			 (ulong)(bio->bi_sector), bio->bi_size);
+		handle_zero_page(page);
+		return 0;
+	}
 
-		user_mem = kmap_atomic(page, KM_USER0);
-		clen = PAGE_SIZE;
+	/* Page is stored uncompressed since it's incompressible */
+	if (unlikely(zram_test_flag(zram, index, ZRAM_UNCOMPRESSED))) {
+		handle_uncompressed_page(zram, page, index);
+		return 0;
+	}
 
-		cmem = kmap_atomic(zram->table[index].page, KM_USER1) +
-				zram->table[index].offset;
+	user_mem = kmap_atomic(page, KM_USER0);
+	clen = PAGE_SIZE;
 
-		ret = lzo1x_decompress_safe(
-			cmem + sizeof(*zheader),
-			xv_get_object_size(cmem) - sizeof(*zheader),
-			user_mem, &clen);
+	cmem = kmap_atomic(zram->table[index].page, KM_USER1) +
+		zram->table[index].offset;
 
-		kunmap_atomic(user_mem, KM_USER0);
-		kunmap_atomic(cmem, KM_USER1);
+	ret = lzo1x_decompress_safe(cmem + sizeof(*zheader),
+				    xv_get_object_size(cmem) - sizeof(*zheader),
+				    user_mem, &clen);
 
-		/* Should NEVER happen. Return bio error if it does. */
-		if (unlikely(ret != LZO_E_OK)) {
-			pr_err("Decompression failed! err=%d, page=%u\n",
-				ret, index);
-			zram_stat64_inc(zram, &zram->stats.failed_reads);
-			goto out;
-		}
+	kunmap_atomic(user_mem, KM_USER0);
+	kunmap_atomic(cmem, KM_USER1);
 
-		flush_dcache_page(page);
-		index++;
+	/* Should NEVER happen. Return bio error if it does. */
+	if (unlikely(ret != LZO_E_OK)) {
+		pr_err("Decompression failed! err=%d, page=%u\n", ret, index);
+		zram_stat64_inc(zram, &zram->stats.failed_reads);
+		return ret;
 	}
 
-	set_bit(BIO_UPTODATE, &bio->bi_flags);
-	bio_endio(bio, 0);
-	return;
+	flush_dcache_page(page);
 
-out:
-	bio_io_error(bio);
+	return 0;
 }
 
-static void zram_write(struct zram *zram, struct bio *bio)
+static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index)
 {
-	int i;
-	u32 index;
-	struct bio_vec *bvec;
+	int ret;
+	u32 offset;
+	size_t clen;
+	struct zobj_header *zheader;
+	struct page *page, *page_store;
+	unsigned char *user_mem, *cmem, *src;
 
-	zram_stat64_inc(zram, &zram->stats.num_writes);
-	index = bio->bi_sector >> SECTORS_PER_PAGE_SHIFT;
+	page = bvec->bv_page;
+	src = zram->compress_buffer;
 
-	bio_for_each_segment(bvec, bio, i) {
-		int ret;
-		u32 offset;
-		size_t clen;
-		struct zobj_header *zheader;
-		struct page *page, *page_store;
-		unsigned char *user_mem, *cmem, *src;
+	/*
+	 * System overwrites unused sectors. Free memory associated
+	 * with this sector now.
+	 */
+	if (zram->table[index].page ||
+	    zram_test_flag(zram, index, ZRAM_ZERO))
+		zram_free_page(zram, index);
 
-		page = bvec->bv_page;
-		src = zram->compress_buffer;
+	mutex_lock(&zram->lock);
 
-		/*
-		 * System overwrites unused sectors. Free memory associated
-		 * with this sector now.
-		 */
-		if (zram->table[index].page ||
-				zram_test_flag(zram, index, ZRAM_ZERO))
-			zram_free_page(zram, index);
+	user_mem = kmap_atomic(page, KM_USER0);
+	if (page_zero_filled(user_mem)) {
+		kunmap_atomic(user_mem, KM_USER0);
+		mutex_unlock(&zram->lock);
+		zram_stat_inc(&zram->stats.pages_zero);
+		zram_set_flag(zram, index, ZRAM_ZERO);
+		return 0;
+	}
 
-		mutex_lock(&zram->lock);
+	ret = lzo1x_1_compress(user_mem, PAGE_SIZE, src, &clen,
+			       zram->compress_workmem);
 
-		user_mem = kmap_atomic(page, KM_USER0);
-		if (page_zero_filled(user_mem)) {
-			kunmap_atomic(user_mem, KM_USER0);
-			mutex_unlock(&zram->lock);
-			zram_stat_inc(&zram->stats.pages_zero);
-			zram_set_flag(zram, index, ZRAM_ZERO);
-			index++;
-			continue;
-		}
-
-		ret = lzo1x_1_compress(user_mem, PAGE_SIZE, src, &clen,
-					zram->compress_workmem);
+	kunmap_atomic(user_mem, KM_USER0);
 
-		kunmap_atomic(user_mem, KM_USER0);
+	if (unlikely(ret != LZO_E_OK)) {
+		mutex_unlock(&zram->lock);
+		pr_err("Compression failed! err=%d\n", ret);
+		zram_stat64_inc(zram, &zram->stats.failed_writes);
+		return ret;
+	}
 
-		if (unlikely(ret != LZO_E_OK)) {
+	/*
+	 * Page is incompressible. Store it as-is (uncompressed)
+	 * since we do not want to return too many disk write
+	 * errors which has side effect of hanging the system.
+	 */
+	if (unlikely(clen > max_zpage_size)) {
+		clen = PAGE_SIZE;
+		page_store = alloc_page(GFP_NOIO | __GFP_HIGHMEM);
+		if (unlikely(!page_store)) {
 			mutex_unlock(&zram->lock);
-			pr_err("Compression failed! err=%d\n", ret);
+			pr_info("Error allocating memory for "
+				"incompressible page: %u\n", index);
 			zram_stat64_inc(zram, &zram->stats.failed_writes);
-			goto out;
-		}
-
-		/*
-		 * Page is incompressible. Store it as-is (uncompressed)
-		 * since we do not want to return too many disk write
-		 * errors which has side effect of hanging the system.
-		 */
-		if (unlikely(clen > max_zpage_size)) {
-			clen = PAGE_SIZE;
-			page_store = alloc_page(GFP_NOIO | __GFP_HIGHMEM);
-			if (unlikely(!page_store)) {
-				mutex_unlock(&zram->lock);
-				pr_info("Error allocating memory for "
-					"incompressible page: %u\n", index);
-				zram_stat64_inc(zram,
-					&zram->stats.failed_writes);
-				goto out;
+				return -ENOMEM;
 			}
 
-			offset = 0;
-			zram_set_flag(zram, index, ZRAM_UNCOMPRESSED);
-			zram_stat_inc(&zram->stats.pages_expand);
-			zram->table[index].page = page_store;
-			src = kmap_atomic(page, KM_USER0);
-			goto memstore;
-		}
+		offset = 0;
+		zram_set_flag(zram, index, ZRAM_UNCOMPRESSED);
+		zram_stat_inc(&zram->stats.pages_expand);
+		zram->table[index].page = page_store;
+		src = kmap_atomic(page, KM_USER0);
+		goto memstore;
+	}
 
-		if (xv_malloc(zram->mem_pool, clen + sizeof(*zheader),
-				&zram->table[index].page, &offset,
-				GFP_NOIO | __GFP_HIGHMEM)) {
-			mutex_unlock(&zram->lock);
-			pr_info("Error allocating memory for compressed "
-				"page: %u, size=%zu\n", index, clen);
-			zram_stat64_inc(zram, &zram->stats.failed_writes);
-			goto out;
-		}
+	if (xv_malloc(zram->mem_pool, clen + sizeof(*zheader),
+		      &zram->table[index].page, &offset,
+		      GFP_NOIO | __GFP_HIGHMEM)) {
+		mutex_unlock(&zram->lock);
+		pr_info("Error allocating memory for compressed "
+			"page: %u, size=%zu\n", index, clen);
+		zram_stat64_inc(zram, &zram->stats.failed_writes);
+		return -ENOMEM;
+	}
 
 memstore:
-		zram->table[index].offset = offset;
+	zram->table[index].offset = offset;
 
-		cmem = kmap_atomic(zram->table[index].page, KM_USER1) +
-				zram->table[index].offset;
+	cmem = kmap_atomic(zram->table[index].page, KM_USER1) +
+		zram->table[index].offset;
 
 #if 0
-		/* Back-reference needed for memory defragmentation */
-		if (!zram_test_flag(zram, index, ZRAM_UNCOMPRESSED)) {
-			zheader = (struct zobj_header *)cmem;
-			zheader->table_idx = index;
-			cmem += sizeof(*zheader);
-		}
+	/* Back-reference needed for memory defragmentation */
+	if (!zram_test_flag(zram, index, ZRAM_UNCOMPRESSED)) {
+		zheader = (struct zobj_header *)cmem;
+		zheader->table_idx = index;
+		cmem += sizeof(*zheader);
+	}
 #endif
 
-		memcpy(cmem, src, clen);
+	memcpy(cmem, src, clen);
 
-		kunmap_atomic(cmem, KM_USER1);
-		if (unlikely(zram_test_flag(zram, index, ZRAM_UNCOMPRESSED)))
-			kunmap_atomic(src, KM_USER0);
+	kunmap_atomic(cmem, KM_USER1);
+	if (unlikely(zram_test_flag(zram, index, ZRAM_UNCOMPRESSED)))
+		kunmap_atomic(src, KM_USER0);
 
-		/* Update stats */
-		zram_stat64_add(zram, &zram->stats.compr_size, clen);
-		zram_stat_inc(&zram->stats.pages_stored);
-		if (clen <= PAGE_SIZE / 2)
-			zram_stat_inc(&zram->stats.good_compress);
+	/* Update stats */
+	zram_stat64_add(zram, &zram->stats.compr_size, clen);
+	zram_stat_inc(&zram->stats.pages_stored);
+	if (clen <= PAGE_SIZE / 2)
+		zram_stat_inc(&zram->stats.good_compress);
 
-		mutex_unlock(&zram->lock);
+	mutex_unlock(&zram->lock);
+
+	return 0;
+}
+
+static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
+			struct bio *bio, int rw)
+{
+	if (rw == READ)
+		return zram_bvec_read(zram, bvec, index, bio);
+
+	return zram_bvec_write(zram, bvec, index);
+}
+
+static void __zram_make_request(struct zram *zram, struct bio *bio, int rw)
+{
+	int i;
+	u32 index;
+	struct bio_vec *bvec;
+
+	switch (rw) {
+	case READ:
+		zram_stat64_inc(zram, &zram->stats.num_reads);
+		break;
+	case WRITE:
+		zram_stat64_inc(zram, &zram->stats.num_writes);
+		break;
+	}
+
+	index = bio->bi_sector >> SECTORS_PER_PAGE_SHIFT;
+
+	bio_for_each_segment(bvec, bio, i) {
+		if (zram_bvec_rw(zram, bvec, index, bio, rw) < 0)
+			goto out;
 		index++;
 	}
 
@@ -439,15 +442,7 @@ static int zram_make_request(struct request_queue *queue, struct bio *bio)
 		return 0;
 	}
 
-	switch (bio_data_dir(bio)) {
-	case READ:
-		zram_read(zram, bio);
-		break;
-
-	case WRITE:
-		zram_write(zram, bio);
-		break;
-	}
+	__zram_make_request(zram, bio, bio_data_dir(bio));
 
 	return 0;
 }
-- 
1.6.2.5

