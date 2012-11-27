Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262Ab2K0H06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 02:26:58 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54332 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758204Ab2K0H0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 02:26:49 -0500
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>, Tomas M <tomas@slax.org>,
        Mihail Kasadjikov <hamer.mk@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] zram: reduce metadata overhead
Date: Mon, 26 Nov 2012 23:26:41 -0800
Message-Id: <1354001201-25537-2-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354001201-25537-1-git-send-email-ngupta@vflare.org>
References: <1354001201-25537-1-git-send-email-ngupta@vflare.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For every allocated object, zram maintains the the handle, size,
flags and count fields. Of these, only the handle is required
since zsmalloc now provides the object size given the handle.
The flags field was needed only to mark a given page as zero-filled.
Instead of this field, we now use an invalid value (-1) to mark such
pages. Lastly, the count field was unused, so was simply removed.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/zram/zram_drv.c |   80 ++++++++++++++-------------------------
 drivers/staging/zram/zram_drv.h |   18 +--------
 2 files changed, 31 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index f2a73bd..8ff7b67 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -71,24 +71,6 @@ static void zram_stat64_inc(struct zram *zram, u64 *v)
 	zram_stat64_add(zram, v, 1);
 }
 
-static int zram_test_flag(struct zram *zram, u32 index,
-			enum zram_pageflags flag)
-{
-	return zram->table[index].flags & BIT(flag);
-}
-
-static void zram_set_flag(struct zram *zram, u32 index,
-			enum zram_pageflags flag)
-{
-	zram->table[index].flags |= BIT(flag);
-}
-
-static void zram_clear_flag(struct zram *zram, u32 index,
-			enum zram_pageflags flag)
-{
-	zram->table[index].flags &= ~BIT(flag);
-}
-
 static int page_zero_filled(void *ptr)
 {
 	unsigned int pos;
@@ -135,21 +117,20 @@ static void zram_set_disksize(struct zram *zram, size_t totalram_bytes)
 
 static void zram_free_page(struct zram *zram, size_t index)
 {
-	unsigned long handle = zram->table[index].handle;
-	u16 size = zram->table[index].size;
+	unsigned long handle = zram->handle[index];
+	size_t size;
 
-	if (unlikely(!handle)) {
-		/*
-		 * No memory is allocated for zero filled pages.
-		 * Simply clear zero page flag.
-		 */
-		if (zram_test_flag(zram, index, ZRAM_ZERO)) {
-			zram_clear_flag(zram, index, ZRAM_ZERO);
-			zram_stat_dec(&zram->stats.pages_zero);
-		}
+	if (unlikely(!handle))
+		return;
+
+	if (handle == zero_page_handle) {
+		/* No memory is allocated for zero filled pages */
+		zram->handle[index] = 0;
+		zram_stat_dec(&zram->stats.pages_zero);
 		return;
 	}
 
+	size = zs_get_object_size(zram->mem_pool, handle);
 	if (unlikely(size > max_zpage_size))
 		zram_stat_dec(&zram->stats.bad_compress);
 
@@ -158,12 +139,10 @@ static void zram_free_page(struct zram *zram, size_t index)
 	if (size <= PAGE_SIZE / 2)
 		zram_stat_dec(&zram->stats.good_compress);
 
-	zram_stat64_sub(zram, &zram->stats.compr_size,
-			zram->table[index].size);
+	zram_stat64_sub(zram, &zram->stats.compr_size, size);
 	zram_stat_dec(&zram->stats.pages_stored);
 
-	zram->table[index].handle = 0;
-	zram->table[index].size = 0;
+	zram->handle[index] = 0;
 }
 
 static void handle_zero_page(struct bio_vec *bvec)
@@ -188,19 +167,20 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 	int ret = LZO_E_OK;
 	size_t clen = PAGE_SIZE;
 	unsigned char *cmem;
-	unsigned long handle = zram->table[index].handle;
+	unsigned long handle = zram->handle[index];
+	size_t objsize;
 
-	if (!handle || zram_test_flag(zram, index, ZRAM_ZERO)) {
+	if (!handle || (handle == zero_page_handle)) {
 		memset(mem, 0, PAGE_SIZE);
 		return 0;
 	}
 
+	objsize = zs_get_object_size(zram->mem_pool, handle);
 	cmem = zs_map_object(zram->mem_pool, handle, ZS_MM_RO);
-	if (zram->table[index].size == PAGE_SIZE)
+	if (objsize == PAGE_SIZE)
 		memcpy(mem, cmem, PAGE_SIZE);
 	else
-		ret = lzo1x_decompress_safe(cmem, zram->table[index].size,
-						mem, &clen);
+		ret = lzo1x_decompress_safe(cmem, objsize, mem, &clen);
 	zs_unmap_object(zram->mem_pool, handle);
 
 	/* Should NEVER happen. Return bio error if it does. */
@@ -222,8 +202,8 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 
 	page = bvec->bv_page;
 
-	if (unlikely(!zram->table[index].handle) ||
-			zram_test_flag(zram, index, ZRAM_ZERO)) {
+	if (unlikely(!zram->handle[index]) ||
+			(zram->handle[index] == zero_page_handle)) {
 		handle_zero_page(bvec);
 		return 0;
 	}
@@ -294,8 +274,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	 * System overwrites unused sectors. Free memory associated
 	 * with this sector now.
 	 */
-	if (zram->table[index].handle ||
-	    zram_test_flag(zram, index, ZRAM_ZERO))
+	if (zram->handle[index])
 		zram_free_page(zram, index);
 
 	user_mem = kmap_atomic(page);
@@ -313,7 +292,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		if (!is_partial_io(bvec))
 			kunmap_atomic(user_mem);
 		zram_stat_inc(&zram->stats.pages_zero);
-		zram_set_flag(zram, index, ZRAM_ZERO);
+		zram->handle[index] = zero_page_handle;
 		ret = 0;
 		goto out;
 	}
@@ -357,8 +336,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 
 	zs_unmap_object(zram->mem_pool, handle);
 
-	zram->table[index].handle = handle;
-	zram->table[index].size = clen;
+	zram->handle[index] = handle;
 
 	/* Update stats */
 	zram_stat64_add(zram, &zram->stats.compr_size, clen);
@@ -517,15 +495,15 @@ void __zram_reset_device(struct zram *zram)
 
 	/* Free all pages that are still in this zram device */
 	for (index = 0; index < zram->disksize >> PAGE_SHIFT; index++) {
-		unsigned long handle = zram->table[index].handle;
-		if (!handle)
+		unsigned long handle = zram->handle[index];
+		if (!handle || (handle == zero_page_handle))
 			continue;
 
 		zs_free(zram->mem_pool, handle);
 	}
 
-	vfree(zram->table);
-	zram->table = NULL;
+	vfree(zram->handle);
+	zram->handle = NULL;
 
 	zs_destroy_pool(zram->mem_pool);
 	zram->mem_pool = NULL;
@@ -573,8 +551,8 @@ int zram_init_device(struct zram *zram)
 	}
 
 	num_pages = zram->disksize >> PAGE_SHIFT;
-	zram->table = vzalloc(num_pages * sizeof(*zram->table));
-	if (!zram->table) {
+	zram->handle = vzalloc(num_pages * sizeof(*zram->handle));
+	if (!zram->handle) {
 		pr_err("Error allocating zram address table\n");
 		ret = -ENOMEM;
 		goto fail_no_table;
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index df2eec4..8aa733c 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -54,24 +54,10 @@ static const size_t max_zpage_size = PAGE_SIZE / 4 * 3;
 #define ZRAM_SECTOR_PER_LOGICAL_BLOCK	\
 	(1 << (ZRAM_LOGICAL_BLOCK_SHIFT - SECTOR_SHIFT))
 
-/* Flags for zram pages (table[page_no].flags) */
-enum zram_pageflags {
-	/* Page consists entirely of zeros */
-	ZRAM_ZERO,
-
-	__NR_ZRAM_PAGEFLAGS,
-};
+static const unsigned long zero_page_handle = (unsigned long)(-1);
 
 /*-- Data structures */
 
-/* Allocated for each disk page */
-struct table {
-	unsigned long handle;
-	u16 size;	/* object size (excluding header) */
-	u8 count;	/* object ref count (not yet used) */
-	u8 flags;
-} __aligned(4);
-
 struct zram_stats {
 	u64 compr_size;		/* compressed size of pages stored */
 	u64 num_reads;		/* failed + successful */
@@ -90,7 +76,7 @@ struct zram {
 	struct zs_pool *mem_pool;
 	void *compress_workmem;
 	void *compress_buffer;
-	struct table *table;
+	unsigned long *handle;	/* memory handle for each disk page */
 	spinlock_t stat64_lock;	/* protect 64-bit stats */
 	struct rw_semaphore lock; /* protect compression buffers and table
 				   * against concurrent read and writes */
-- 
1.7.10.4

