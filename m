Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab1FJN3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:29:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135Ab1FJN3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:29:06 -0400
From: Jerome Marchand <jmarchan@redhat.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jeff Moyer <jmoyer@redhat.com>, Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 3/4] Staging: zram: allow partial page operations
Date: Fri, 10 Jun 2011 15:28:48 +0200
Message-Id: <1307712529-9757-3-git-send-email-jmarchan@redhat.com>
In-Reply-To: <1307712529-9757-2-git-send-email-jmarchan@redhat.com>
References: <1307712529-9757-1-git-send-email-jmarchan@redhat.com>
 <1307712529-9757-2-git-send-email-jmarchan@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7b19b8d45b216ff3186f066b31937bdbde066f08 (zram: Prevent overflow
in logical block size) introduced ZRAM_LOGICAL_BLOCK_SIZE constant to
prevent overflow of logical block size on 64k page kernel.
However, the current implementation of zram only allow operation on block
of the same size as a page. That makes theorically legit 4k requests fail
on 64k page kernel.

This patch makes zram allow operation on partial pages. Basically, it
means we still do operations on full pages internally, but only copy the
relevent segments from/to the user memory.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 drivers/staging/zram/zram_drv.c |  202 ++++++++++++++++++++++++++++++++-------
 drivers/staging/zram/zram_drv.h |    5 +-
 2 files changed, 169 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 33060d1..54ad29d 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -177,45 +177,52 @@ out:
 	zram->table[index].offset = 0;
 }
 
-static void handle_zero_page(struct page *page)
+static void handle_zero_page(struct bio_vec *bvec)
 {
+	struct page *page = bvec->bv_page;
 	void *user_mem;
 
 	user_mem = kmap_atomic(page, KM_USER0);
-	memset(user_mem, 0, PAGE_SIZE);
+	memset(user_mem + bvec->bv_offset, 0, bvec->bv_len);
 	kunmap_atomic(user_mem, KM_USER0);
 
 	flush_dcache_page(page);
 }
 
-static void handle_uncompressed_page(struct zram *zram,
-				struct page *page, u32 index)
+static void handle_uncompressed_page(struct zram *zram, struct bio_vec *bvec,
+				     u32 index, int offset)
 {
+	struct page *page = bvec->bv_page;
 	unsigned char *user_mem, *cmem;
 
 	user_mem = kmap_atomic(page, KM_USER0);
 	cmem = kmap_atomic(zram->table[index].page, KM_USER1);
 
-	memcpy(user_mem, cmem, PAGE_SIZE);
+	memcpy(user_mem + bvec->bv_offset, cmem + offset, bvec->bv_len);
 	kunmap_atomic(user_mem, KM_USER0);
 	kunmap_atomic(cmem, KM_USER1);
 
 	flush_dcache_page(page);
 }
 
+static inline int is_partial_io(struct bio_vec *bvec)
+{
+	return bvec->bv_len != PAGE_SIZE;
+}
+
 static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
-			  u32 index, struct bio *bio)
+			  u32 index, int offset, struct bio *bio)
 {
 	int ret;
 	size_t clen;
 	struct page *page;
 	struct zobj_header *zheader;
-	unsigned char *user_mem, *cmem;
+	unsigned char *user_mem, *cmem, *uncmem = NULL;
 
 	page = bvec->bv_page;
 
 	if (zram_test_flag(zram, index, ZRAM_ZERO)) {
-		handle_zero_page(page);
+		handle_zero_page(bvec);
 		return 0;
 	}
 
@@ -223,17 +230,28 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 	if (unlikely(!zram->table[index].page)) {
 		pr_debug("Read before write: sector=%lu, size=%u",
 			 (ulong)(bio->bi_sector), bio->bi_size);
-		handle_zero_page(page);
+		handle_zero_page(bvec);
 		return 0;
 	}
 
 	/* Page is stored uncompressed since it's incompressible */
 	if (unlikely(zram_test_flag(zram, index, ZRAM_UNCOMPRESSED))) {
-		handle_uncompressed_page(zram, page, index);
+		handle_uncompressed_page(zram, bvec, index, offset);
 		return 0;
 	}
 
+	if (is_partial_io(bvec)) {
+		/* Use  a temporary buffer to decompress the page */
+		uncmem = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		if (!uncmem) {
+			pr_info("Error allocating temp memory!\n");
+			return -ENOMEM;
+		}
+	}
+
 	user_mem = kmap_atomic(page, KM_USER0);
+	if (!is_partial_io(bvec))
+		uncmem = user_mem;
 	clen = PAGE_SIZE;
 
 	cmem = kmap_atomic(zram->table[index].page, KM_USER1) +
@@ -241,7 +259,13 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 
 	ret = lzo1x_decompress_safe(cmem + sizeof(*zheader),
 				    xv_get_object_size(cmem) - sizeof(*zheader),
-				    user_mem, &clen);
+				    uncmem, &clen);
+
+	if (is_partial_io(bvec)) {
+		memcpy(user_mem + bvec->bv_offset, uncmem + offset,
+		       bvec->bv_len);
+		kfree(uncmem);
+	}
 
 	kunmap_atomic(user_mem, KM_USER0);
 	kunmap_atomic(cmem, KM_USER1);
@@ -258,18 +282,75 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 	return 0;
 }
 
-static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index)
+static int zram_read_before_write(struct zram *zram, char *mem, u32 index)
+{
+	int ret;
+	size_t clen = PAGE_SIZE;
+	struct zobj_header *zheader;
+	unsigned char *cmem;
+
+	if (zram_test_flag(zram, index, ZRAM_ZERO) ||
+	    !zram->table[index].page) {
+		memset(mem, 0, PAGE_SIZE);
+		return 0;
+	}
+
+	cmem = kmap_atomic(zram->table[index].page, KM_USER0) +
+		zram->table[index].offset;
+
+	/* Page is stored uncompressed since it's incompressible */
+	if (unlikely(zram_test_flag(zram, index, ZRAM_UNCOMPRESSED))) {
+		memcpy(mem, cmem, PAGE_SIZE);
+		kunmap_atomic(cmem, KM_USER0);
+		return 0;
+	}
+
+	ret = lzo1x_decompress_safe(cmem + sizeof(*zheader),
+				    xv_get_object_size(cmem) - sizeof(*zheader),
+				    mem, &clen);
+	kunmap_atomic(cmem, KM_USER0);
+
+	/* Should NEVER happen. Return bio error if it does. */
+	if (unlikely(ret != LZO_E_OK)) {
+		pr_err("Decompression failed! err=%d, page=%u\n", ret, index);
+		zram_stat64_inc(zram, &zram->stats.failed_reads);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
+			   int offset)
 {
 	int ret;
-	u32 offset;
+	u32 store_offset;
 	size_t clen;
 	struct zobj_header *zheader;
 	struct page *page, *page_store;
-	unsigned char *user_mem, *cmem, *src;
+	unsigned char *user_mem, *cmem, *src, *uncmem = NULL;
 
 	page = bvec->bv_page;
 	src = zram->compress_buffer;
 
+	if (is_partial_io(bvec)) {
+		/*
+		 * This is a partial IO. We need to read the full page
+		 * before to write the changes.
+		 */
+		uncmem = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		if (!uncmem) {
+			pr_info("Error allocating temp memory!\n");
+			ret = -ENOMEM;
+			goto out;
+		}
+		ret = zram_read_before_write(zram, uncmem, index);
+		if (ret) {
+			kfree(uncmem);
+			goto out;
+		}
+	}
+
 	/*
 	 * System overwrites unused sectors. Free memory associated
 	 * with this sector now.
@@ -281,24 +362,35 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index)
 	mutex_lock(&zram->lock);
 
 	user_mem = kmap_atomic(page, KM_USER0);
-	if (page_zero_filled(user_mem)) {
+
+	if (is_partial_io(bvec))
+		memcpy(uncmem + offset, user_mem + bvec->bv_offset,
+		       bvec->bv_len);
+	else
+		uncmem = user_mem;
+
+	if (page_zero_filled(uncmem)) {
 		kunmap_atomic(user_mem, KM_USER0);
 		mutex_unlock(&zram->lock);
+		if (is_partial_io(bvec))
+			kfree(uncmem);
 		zram_stat_inc(&zram->stats.pages_zero);
 		zram_set_flag(zram, index, ZRAM_ZERO);
-		return 0;
+		ret = 0;
+		goto out;
 	}
 
-	ret = lzo1x_1_compress(user_mem, PAGE_SIZE, src, &clen,
+	ret = lzo1x_1_compress(uncmem, PAGE_SIZE, src, &clen,
 			       zram->compress_workmem);
 
 	kunmap_atomic(user_mem, KM_USER0);
+	if (is_partial_io(bvec))
+			kfree(uncmem);
 
 	if (unlikely(ret != LZO_E_OK)) {
 		mutex_unlock(&zram->lock);
 		pr_err("Compression failed! err=%d\n", ret);
-		zram_stat64_inc(zram, &zram->stats.failed_writes);
-		return ret;
+		goto out;
 	}
 
 	/*
@@ -313,11 +405,11 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index)
 			mutex_unlock(&zram->lock);
 			pr_info("Error allocating memory for "
 				"incompressible page: %u\n", index);
-			zram_stat64_inc(zram, &zram->stats.failed_writes);
-				return -ENOMEM;
-			}
+			ret = -ENOMEM;
+			goto out;
+		}
 
-		offset = 0;
+		store_offset = 0;
 		zram_set_flag(zram, index, ZRAM_UNCOMPRESSED);
 		zram_stat_inc(&zram->stats.pages_expand);
 		zram->table[index].page = page_store;
@@ -326,17 +418,17 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index)
 	}
 
 	if (xv_malloc(zram->mem_pool, clen + sizeof(*zheader),
-		      &zram->table[index].page, &offset,
+		      &zram->table[index].page, &store_offset,
 		      GFP_NOIO | __GFP_HIGHMEM)) {
 		mutex_unlock(&zram->lock);
 		pr_info("Error allocating memory for compressed "
 			"page: %u, size=%zu\n", index, clen);
-		zram_stat64_inc(zram, &zram->stats.failed_writes);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out;
 	}
 
 memstore:
-	zram->table[index].offset = offset;
+	zram->table[index].offset = store_offset;
 
 	cmem = kmap_atomic(zram->table[index].page, KM_USER1) +
 		zram->table[index].offset;
@@ -365,20 +457,32 @@ memstore:
 	mutex_unlock(&zram->lock);
 
 	return 0;
+
+out:
+	if (ret)
+		zram_stat64_inc(zram, &zram->stats.failed_writes);
+	return ret;
 }
 
 static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
-			struct bio *bio, int rw)
+			int offset, struct bio *bio, int rw)
 {
 	if (rw == READ)
-		return zram_bvec_read(zram, bvec, index, bio);
+		return zram_bvec_read(zram, bvec, index, offset, bio);
 
-	return zram_bvec_write(zram, bvec, index);
+	return zram_bvec_write(zram, bvec, index, offset);
+}
+
+static void update_position(u32 *index, int *offset, struct bio_vec *bvec)
+{
+	if (*offset + bvec->bv_len >= PAGE_SIZE)
+		(*index)++;
+	*offset = (*offset + bvec->bv_len) % PAGE_SIZE;
 }
 
 static void __zram_make_request(struct zram *zram, struct bio *bio, int rw)
 {
-	int i;
+	int i, offset;
 	u32 index;
 	struct bio_vec *bvec;
 
@@ -392,11 +496,35 @@ static void __zram_make_request(struct zram *zram, struct bio *bio, int rw)
 	}
 
 	index = bio->bi_sector >> SECTORS_PER_PAGE_SHIFT;
+	offset = (bio->bi_sector & (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
 
 	bio_for_each_segment(bvec, bio, i) {
-		if (zram_bvec_rw(zram, bvec, index, bio, rw) < 0)
-			goto out;
-		index++;
+		int max_transfer_size = PAGE_SIZE - offset;
+
+		if (bvec->bv_len > max_transfer_size) {
+			/*
+			 * zram_bvec_rw() can only make operation on a single
+			 * zram page. Split the bio vector.
+			 */
+			struct bio_vec bv;
+
+			bv.bv_page = bvec->bv_page;
+			bv.bv_len = max_transfer_size;
+			bv.bv_offset = bvec->bv_offset;
+
+			if (zram_bvec_rw(zram, &bv, index, offset, bio, rw) < 0)
+				goto out;
+
+			bv.bv_len = bvec->bv_len - max_transfer_size;
+			bv.bv_offset += max_transfer_size;
+			if (zram_bvec_rw(zram, &bv, index+1, 0, bio, rw) < 0)
+				goto out;
+		} else
+			if (zram_bvec_rw(zram, bvec, index, offset, bio, rw)
+			    < 0)
+				goto out;
+
+		update_position(&index, &offset, bvec);
 	}
 
 	set_bit(BIO_UPTODATE, &bio->bi_flags);
@@ -408,14 +536,14 @@ out:
 }
 
 /*
- * Check if request is within bounds and page aligned.
+ * Check if request is within bounds and aligned on zram logical blocks.
  */
 static inline int valid_io_request(struct zram *zram, struct bio *bio)
 {
 	if (unlikely(
 		(bio->bi_sector >= (zram->disksize >> SECTOR_SHIFT)) ||
-		(bio->bi_sector & (SECTORS_PER_PAGE - 1)) ||
-		(bio->bi_size & (PAGE_SIZE - 1)))) {
+		(bio->bi_sector & (ZRAM_SECTOR_PER_LOGICAL_BLOCK - 1)) ||
+		(bio->bi_size & (ZRAM_LOGICAL_BLOCK_SIZE - 1)))) {
 
 		return 0;
 	}
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index 408b2c0..8acf9eb 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -61,7 +61,10 @@ static const unsigned max_zpage_size = PAGE_SIZE / 4 * 3;
 #define SECTOR_SIZE		(1 << SECTOR_SHIFT)
 #define SECTORS_PER_PAGE_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
 #define SECTORS_PER_PAGE	(1 << SECTORS_PER_PAGE_SHIFT)
-#define ZRAM_LOGICAL_BLOCK_SIZE	4096
+#define ZRAM_LOGICAL_BLOCK_SHIFT 12
+#define ZRAM_LOGICAL_BLOCK_SIZE	(1 << ZRAM_LOGICAL_BLOCK_SHIFT)
+#define ZRAM_SECTOR_PER_LOGICAL_BLOCK	\
+	(1 << (ZRAM_LOGICAL_BLOCK_SHIFT - SECTOR_SHIFT))
 
 /* Flags for zram pages (table[page_no].flags) */
 enum zram_pageflags {
-- 
1.6.2.5

