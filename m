Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760297Ab2J2SI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 14:08:29 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:52073 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab2J2SI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 14:08:26 -0400
Date: Mon, 29 Oct 2012 21:05:58 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] zram: factor-out zram_decompress_page() function (v2)
Message-ID: <20121029180558.GE3706@swordfish.minsk.epam.com>
References: <20121027160052.GA4771@swordfish>
 <508EB96C.4040505@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508EB96C.4040505@vflare.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  zram: factor-out zram_decompress_page() function

  zram_bvec_read() shared decompress functionality with zram_read_before_write() function.
  Factor-out and make commonly used zram_decompress_page() function, which also simplified
  error handling in zram_bvec_read().

  V2: changed debug message for handle_zero_page() case to a more general one

  Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 drivers/staging/zram/zram_drv.c | 115 +++++++++++++++++-----------------------
 1 file changed, 50 insertions(+), 65 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 6edefde..bd5efdf 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -183,62 +183,25 @@ static inline int is_partial_io(struct bio_vec *bvec)
 	return bvec->bv_len != PAGE_SIZE;
 }
 
-static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
-			  u32 index, int offset, struct bio *bio)
+static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 {
-	int ret;
-	size_t clen;
-	struct page *page;
-	unsigned char *user_mem, *cmem, *uncmem = NULL;
-
-	page = bvec->bv_page;
-
-	if (zram_test_flag(zram, index, ZRAM_ZERO)) {
-		handle_zero_page(bvec);
-		return 0;
-	}
+	int ret = LZO_E_OK;
+	size_t clen = PAGE_SIZE;
+	unsigned char *cmem;
+	unsigned long handle = zram->table[index].handle;
 
-	/* Requested page is not present in compressed area */
-	if (unlikely(!zram->table[index].handle)) {
-		pr_debug("Read before write: sector=%lu, size=%u",
-			 (ulong)(bio->bi_sector), bio->bi_size);
-		handle_zero_page(bvec);
+	if (!handle || zram_test_flag(zram, index, ZRAM_ZERO)) {
+		memset(mem, 0, PAGE_SIZE);
 		return 0;
 	}
 
-	if (is_partial_io(bvec)) {
-		/* Use  a temporary buffer to decompress the page */
-		uncmem = kmalloc(PAGE_SIZE, GFP_KERNEL);
-		if (!uncmem) {
-			pr_info("Error allocating temp memory!\n");
-			return -ENOMEM;
-		}
-	}
-
-	user_mem = kmap_atomic(page);
-	if (!is_partial_io(bvec))
-		uncmem = user_mem;
-	clen = PAGE_SIZE;
-
-	cmem = zs_map_object(zram->mem_pool, zram->table[index].handle,
-				ZS_MM_RO);
-
-	if (zram->table[index].size == PAGE_SIZE) {
-		memcpy(uncmem, cmem, PAGE_SIZE);
-		ret = LZO_E_OK;
-	} else {
+	cmem = zs_map_object(zram->mem_pool, handle, ZS_MM_RO);
+	if (zram->table[index].size == PAGE_SIZE)
+		memcpy(mem, cmem, PAGE_SIZE);
+	else
 		ret = lzo1x_decompress_safe(cmem, zram->table[index].size,
-				    uncmem, &clen);
-	}
-
-	if (is_partial_io(bvec)) {
-		memcpy(user_mem + bvec->bv_offset, uncmem + offset,
-		       bvec->bv_len);
-		kfree(uncmem);
-	}
-
-	zs_unmap_object(zram->mem_pool, zram->table[index].handle);
-	kunmap_atomic(user_mem);
+						mem, &clen);
+	zs_unmap_object(zram->mem_pool, handle);
 
 	/* Should NEVER happen. Return bio error if it does. */
 	if (unlikely(ret != LZO_E_OK)) {
@@ -247,36 +210,58 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 		return ret;
 	}
 
-	flush_dcache_page(page);
-
 	return 0;
 }
 
-static int zram_read_before_write(struct zram *zram, char *mem, u32 index)
+static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
+			  u32 index, int offset, struct bio *bio)
 {
 	int ret;
-	size_t clen = PAGE_SIZE;
-	unsigned char *cmem;
-	unsigned long handle = zram->table[index].handle;
+	struct page *page;
+	unsigned char *user_mem, *uncmem = NULL;
 
-	if (zram_test_flag(zram, index, ZRAM_ZERO) || !handle) {
-		memset(mem, 0, PAGE_SIZE);
+	page = bvec->bv_page;
+
+	if (unlikely(!zram->table[index].handle) ||
+			zram_test_flag(zram, index, ZRAM_ZERO)) {
+		pr_debug("Handle zero page: sector=%lu, size=%u",
+			 (ulong)(bio->bi_sector), bio->bi_size);
+		handle_zero_page(bvec);
 		return 0;
 	}
 
-	cmem = zs_map_object(zram->mem_pool, handle, ZS_MM_RO);
-	ret = lzo1x_decompress_safe(cmem, zram->table[index].size,
-				    mem, &clen);
-	zs_unmap_object(zram->mem_pool, handle);
+	user_mem = kmap_atomic(page);
+	if (is_partial_io(bvec))
+		/* Use  a temporary buffer to decompress the page */
+		uncmem = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	else
+		uncmem = user_mem;
 
+	if (!uncmem) {
+		pr_info("Unable to allocate temp memory\n");
+		ret = -ENOMEM;
+		goto out_cleanup;
+	}
+
+	ret = zram_decompress_page(zram, uncmem, index);
 	/* Should NEVER happen. Return bio error if it does. */
 	if (unlikely(ret != LZO_E_OK)) {
 		pr_err("Decompression failed! err=%d, page=%u\n", ret, index);
 		zram_stat64_inc(zram, &zram->stats.failed_reads);
-		return ret;
+		goto out_cleanup;
 	}
 
-	return 0;
+	if (is_partial_io(bvec))
+		memcpy(user_mem + bvec->bv_offset, uncmem + offset,
+				bvec->bv_len);
+
+	flush_dcache_page(page);
+	ret = 0;
+out_cleanup:
+	kunmap_atomic(user_mem);
+	if (is_partial_io(bvec))
+		kfree(uncmem);
+	return ret;
 }
 
 static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
@@ -302,7 +287,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 			ret = -ENOMEM;
 			goto out;
 		}
-		ret = zram_read_before_write(zram, uncmem, index);
+		ret = zram_decompress_page(zram, uncmem, index);
 		if (ret) {
 			kfree(uncmem);
 			goto out;

