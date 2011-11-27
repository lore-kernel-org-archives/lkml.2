Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab1K0Fdz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:33:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223Ab1K0Fdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:33:53 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Peter Huewe <peterhuewe@gmx.de>, Jerome Marchand <jmarchan@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, devel@driverdev.osuosl.org
Subject: [PATCH 26/62] zram: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:27:06 +0800
Message-Id: <1322371662-26166-27-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 drivers/staging/zram/xvmalloc.c |   39 ++++++++++++++++-----------------
 drivers/staging/zram/zram_drv.c |   44 +++++++++++++++++++-------------------
 2 files changed, 41 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/zram/xvmalloc.c b/drivers/staging/zram/xvmalloc.c
index 1f9c508..93ba8e9 100644
--- a/drivers/staging/zram/xvmalloc.c
+++ b/drivers/staging/zram/xvmalloc.c
@@ -56,17 +56,17 @@ static void clear_flag(struct block_header *block, enum blockflags flag)
  * This is called from xv_malloc/xv_free path, so it
  * needs to be fast.
  */
-static void *get_ptr_atomic(struct page *page, u16 offset, enum km_type type)
+static void *get_ptr_atomic(struct page *page, u16 offset)
 {
 	unsigned char *base;
 
-	base = kmap_atomic(page, type);
+	base = kmap_atomic(page);
 	return base + offset;
 }
 
-static void put_ptr_atomic(void *ptr, enum km_type type)
+static void put_ptr_atomic(void *ptr)
 {
-	kunmap_atomic(ptr, type);
+	kunmap_atomic(ptr);
 }
 
 static u32 get_blockprev(struct block_header *block)
@@ -202,10 +202,10 @@ static void insert_block(struct xv_pool *pool, struct page *page, u32 offset,
 
 	if (block->link.next_page) {
 		nextblock = get_ptr_atomic(block->link.next_page,
-					block->link.next_offset, KM_USER1);
+					block->link.next_offset);
 		nextblock->link.prev_page = page;
 		nextblock->link.prev_offset = offset;
-		put_ptr_atomic(nextblock, KM_USER1);
+		put_ptr_atomic(nextblock);
 		/* If there was a next page then the free bits are set. */
 		return;
 	}
@@ -225,18 +225,18 @@ static void remove_block(struct xv_pool *pool, struct page *page, u32 offset,
 
 	if (block->link.prev_page) {
 		tmpblock = get_ptr_atomic(block->link.prev_page,
-				block->link.prev_offset, KM_USER1);
+				block->link.prev_offset);
 		tmpblock->link.next_page = block->link.next_page;
 		tmpblock->link.next_offset = block->link.next_offset;
-		put_ptr_atomic(tmpblock, KM_USER1);
+		put_ptr_atomic(tmpblock);
 	}
 
 	if (block->link.next_page) {
 		tmpblock = get_ptr_atomic(block->link.next_page,
-				block->link.next_offset, KM_USER1);
+				block->link.next_offset);
 		tmpblock->link.prev_page = block->link.prev_page;
 		tmpblock->link.prev_offset = block->link.prev_offset;
-		put_ptr_atomic(tmpblock, KM_USER1);
+		put_ptr_atomic(tmpblock);
 	}
 
 	/* Is this block is at the head of the freelist? */
@@ -249,11 +249,10 @@ static void remove_block(struct xv_pool *pool, struct page *page, u32 offset,
 		if (pool->freelist[slindex].page) {
 			struct block_header *tmpblock;
 			tmpblock = get_ptr_atomic(pool->freelist[slindex].page,
-					pool->freelist[slindex].offset,
-					KM_USER1);
+					pool->freelist[slindex].offset);
 			tmpblock->link.prev_page = NULL;
 			tmpblock->link.prev_offset = 0;
-			put_ptr_atomic(tmpblock, KM_USER1);
+			put_ptr_atomic(tmpblock);
 		} else {
 			/* This freelist bucket is empty */
 			__clear_bit(slindex % BITS_PER_LONG,
@@ -284,7 +283,7 @@ static int grow_pool(struct xv_pool *pool, gfp_t flags)
 	stat_inc(&pool->total_pages);
 
 	spin_lock(&pool->lock);
-	block = get_ptr_atomic(page, 0, KM_USER0);
+	block = get_ptr_atomic(page, 0);
 
 	block->size = PAGE_SIZE - XV_ALIGN;
 	set_flag(block, BLOCK_FREE);
@@ -293,7 +292,7 @@ static int grow_pool(struct xv_pool *pool, gfp_t flags)
 
 	insert_block(pool, page, 0, block);
 
-	put_ptr_atomic(block, KM_USER0);
+	put_ptr_atomic(block);
 	spin_unlock(&pool->lock);
 
 	return 0;
@@ -375,7 +374,7 @@ int xv_malloc(struct xv_pool *pool, u32 size, struct page **page,
 		return -ENOMEM;
 	}
 
-	block = get_ptr_atomic(*page, *offset, KM_USER0);
+	block = get_ptr_atomic(*page, *offset);
 
 	remove_block(pool, *page, *offset, block, index);
 
@@ -405,7 +404,7 @@ int xv_malloc(struct xv_pool *pool, u32 size, struct page **page,
 	block->size = origsize;
 	clear_flag(block, BLOCK_FREE);
 
-	put_ptr_atomic(block, KM_USER0);
+	put_ptr_atomic(block);
 	spin_unlock(&pool->lock);
 
 	*offset += XV_ALIGN;
@@ -426,7 +425,7 @@ void xv_free(struct xv_pool *pool, struct page *page, u32 offset)
 
 	spin_lock(&pool->lock);
 
-	page_start = get_ptr_atomic(page, 0, KM_USER0);
+	page_start = get_ptr_atomic(page, 0);
 	block = (struct block_header *)((char *)page_start + offset);
 
 	/* Catch double free bugs */
@@ -468,7 +467,7 @@ void xv_free(struct xv_pool *pool, struct page *page, u32 offset)
 
 	/* No used objects in this page. Free it. */
 	if (block->size == PAGE_SIZE - XV_ALIGN) {
-		put_ptr_atomic(page_start, KM_USER0);
+		put_ptr_atomic(page_start);
 		spin_unlock(&pool->lock);
 
 		__free_page(page);
@@ -486,7 +485,7 @@ void xv_free(struct xv_pool *pool, struct page *page, u32 offset)
 		set_blockprev(tmpblock, offset);
 	}
 
-	put_ptr_atomic(page_start, KM_USER0);
+	put_ptr_atomic(page_start);
 	spin_unlock(&pool->lock);
 }
 EXPORT_SYMBOL_GPL(xv_free);
diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 09de99f..fa276c0 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -161,9 +161,9 @@ static void zram_free_page(struct zram *zram, size_t index)
 		goto out;
 	}
 
-	obj = kmap_atomic(page, KM_USER0) + offset;
+	obj = kmap_atomic(page) + offset;
 	clen = xv_get_object_size(obj) - sizeof(struct zobj_header);
-	kunmap_atomic(obj, KM_USER0);
+	kunmap_atomic(obj);
 
 	xv_free(zram->mem_pool, page, offset);
 	if (clen <= PAGE_SIZE / 2)
@@ -182,9 +182,9 @@ static void handle_zero_page(struct bio_vec *bvec)
 	struct page *page = bvec->bv_page;
 	void *user_mem;
 
-	user_mem = kmap_atomic(page, KM_USER0);
+	user_mem = kmap_atomic(page);
 	memset(user_mem + bvec->bv_offset, 0, bvec->bv_len);
-	kunmap_atomic(user_mem, KM_USER0);
+	kunmap_atomic(user_mem);
 
 	flush_dcache_page(page);
 }
@@ -195,12 +195,12 @@ static void handle_uncompressed_page(struct zram *zram, struct bio_vec *bvec,
 	struct page *page = bvec->bv_page;
 	unsigned char *user_mem, *cmem;
 
-	user_mem = kmap_atomic(page, KM_USER0);
-	cmem = kmap_atomic(zram->table[index].page, KM_USER1);
+	user_mem = kmap_atomic(page);
+	cmem = kmap_atomic(zram->table[index].page);
 
 	memcpy(user_mem + bvec->bv_offset, cmem + offset, bvec->bv_len);
-	kunmap_atomic(cmem, KM_USER1);
-	kunmap_atomic(user_mem, KM_USER0);
+	kunmap_atomic(cmem);
+	kunmap_atomic(user_mem);
 
 	flush_dcache_page(page);
 }
@@ -249,12 +249,12 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 		}
 	}
 
-	user_mem = kmap_atomic(page, KM_USER0);
+	user_mem = kmap_atomic(page);
 	if (!is_partial_io(bvec))
 		uncmem = user_mem;
 	clen = PAGE_SIZE;
 
-	cmem = kmap_atomic(zram->table[index].page, KM_USER1) +
+	cmem = kmap_atomic(zram->table[index].page) +
 		zram->table[index].offset;
 
 	ret = lzo1x_decompress_safe(cmem + sizeof(*zheader),
@@ -267,8 +267,8 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 		kfree(uncmem);
 	}
 
-	kunmap_atomic(cmem, KM_USER1);
-	kunmap_atomic(user_mem, KM_USER0);
+	kunmap_atomic(cmem);
+	kunmap_atomic(user_mem);
 
 	/* Should NEVER happen. Return bio error if it does. */
 	if (unlikely(ret != LZO_E_OK)) {
@@ -295,20 +295,20 @@ static int zram_read_before_write(struct zram *zram, char *mem, u32 index)
 		return 0;
 	}
 
-	cmem = kmap_atomic(zram->table[index].page, KM_USER0) +
+	cmem = kmap_atomic(zram->table[index].page) +
 		zram->table[index].offset;
 
 	/* Page is stored uncompressed since it's incompressible */
 	if (unlikely(zram_test_flag(zram, index, ZRAM_UNCOMPRESSED))) {
 		memcpy(mem, cmem, PAGE_SIZE);
-		kunmap_atomic(cmem, KM_USER0);
+		kunmap_atomic(cmem);
 		return 0;
 	}
 
 	ret = lzo1x_decompress_safe(cmem + sizeof(*zheader),
 				    xv_get_object_size(cmem) - sizeof(*zheader),
 				    mem, &clen);
-	kunmap_atomic(cmem, KM_USER0);
+	kunmap_atomic(cmem);
 
 	/* Should NEVER happen. Return bio error if it does. */
 	if (unlikely(ret != LZO_E_OK)) {
@@ -359,7 +359,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	    zram_test_flag(zram, index, ZRAM_ZERO))
 		zram_free_page(zram, index);
 
-	user_mem = kmap_atomic(page, KM_USER0);
+	user_mem = kmap_atomic(page);
 
 	if (is_partial_io(bvec))
 		memcpy(uncmem + offset, user_mem + bvec->bv_offset,
@@ -368,7 +368,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		uncmem = user_mem;
 
 	if (page_zero_filled(uncmem)) {
-		kunmap_atomic(user_mem, KM_USER0);
+		kunmap_atomic(user_mem);
 		if (is_partial_io(bvec))
 			kfree(uncmem);
 		zram_stat_inc(&zram->stats.pages_zero);
@@ -380,7 +380,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	ret = lzo1x_1_compress(uncmem, PAGE_SIZE, src, &clen,
 			       zram->compress_workmem);
 
-	kunmap_atomic(user_mem, KM_USER0);
+	kunmap_atomic(user_mem);
 	if (is_partial_io(bvec))
 			kfree(uncmem);
 
@@ -408,7 +408,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		zram_set_flag(zram, index, ZRAM_UNCOMPRESSED);
 		zram_stat_inc(&zram->stats.pages_expand);
 		zram->table[index].page = page_store;
-		src = kmap_atomic(page, KM_USER0);
+		src = kmap_atomic(page);
 		goto memstore;
 	}
 
@@ -424,7 +424,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 memstore:
 	zram->table[index].offset = store_offset;
 
-	cmem = kmap_atomic(zram->table[index].page, KM_USER1) +
+	cmem = kmap_atomic(zram->table[index].page) +
 		zram->table[index].offset;
 
 #if 0
@@ -438,9 +438,9 @@ memstore:
 
 	memcpy(cmem, src, clen);
 
-	kunmap_atomic(cmem, KM_USER1);
+	kunmap_atomic(cmem);
 	if (unlikely(zram_test_flag(zram, index, ZRAM_UNCOMPRESSED)))
-		kunmap_atomic(src, KM_USER0);
+		kunmap_atomic(src);
 
 	/* Update stats */
 	zram_stat64_add(zram, &zram->stats.compr_size, clen);
-- 
1.7.4.4

