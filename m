Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab2KVTVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:21:50 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:46784 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183Ab2KVTVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:21:46 -0500
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>, Tomas M <tomas@slax.org>,
        Mihail Kasadjikov <hamer.mk@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: zram: Prevent use of unmapped buffer
Date: Thu, 22 Nov 2012 02:41:13 -0800
Message-Id: <1353580873-5227-1-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit c8f2f0db1 ("zram: Fix handling of incompressible pages")
introduced a bug which caused a kunmap()'ed buffer to be used in case
of partial writes where the data was found to be incompressible.

This fixes bug 50081:
https://bugzilla.kernel.org/show_bug.cgi?id=50081

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
Reported-by: Mihail Kasadjikov <hamer.mk@gmail.com>
Reported-by: Tomas M <tomas@slax.org>
---
 drivers/staging/zram/zram_drv.c |   46 +++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 6edefde..8d9133f 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -265,8 +265,13 @@ static int zram_read_before_write(struct zram *zram, char *mem, u32 index)
 	}
 
 	cmem = zs_map_object(zram->mem_pool, handle, ZS_MM_RO);
-	ret = lzo1x_decompress_safe(cmem, zram->table[index].size,
+	if (zram->table[index].size == PAGE_SIZE) {
+		memcpy(mem, cmem, PAGE_SIZE);
+		ret = LZO_E_OK;
+	} else {
+		ret = lzo1x_decompress_safe(cmem, zram->table[index].size,
 				    mem, &clen);
+	}
 	zs_unmap_object(zram->mem_pool, handle);
 
 	/* Should NEVER happen. Return bio error if it does. */
@@ -282,7 +287,7 @@ static int zram_read_before_write(struct zram *zram, char *mem, u32 index)
 static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 			   int offset)
 {
-	int ret;
+	int ret = 0;
 	size_t clen;
 	unsigned long handle;
 	struct page *page;
@@ -303,10 +308,8 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 			goto out;
 		}
 		ret = zram_read_before_write(zram, uncmem, index);
-		if (ret) {
-			kfree(uncmem);
+		if (ret)
 			goto out;
-		}
 	}
 
 	/*
@@ -319,16 +322,18 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 
 	user_mem = kmap_atomic(page);
 
-	if (is_partial_io(bvec))
+	if (is_partial_io(bvec)) {
 		memcpy(uncmem + offset, user_mem + bvec->bv_offset,
 		       bvec->bv_len);
-	else
+		kunmap_atomic(user_mem);
+		user_mem = NULL;
+	} else {
 		uncmem = user_mem;
+	}
 
 	if (page_zero_filled(uncmem)) {
-		kunmap_atomic(user_mem);
-		if (is_partial_io(bvec))
-			kfree(uncmem);
+		if (!is_partial_io(bvec))
+			kunmap_atomic(user_mem);
 		zram_stat_inc(&zram->stats.pages_zero);
 		zram_set_flag(zram, index, ZRAM_ZERO);
 		ret = 0;
@@ -338,9 +343,11 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	ret = lzo1x_1_compress(uncmem, PAGE_SIZE, src, &clen,
 			       zram->compress_workmem);
 
-	kunmap_atomic(user_mem);
-	if (is_partial_io(bvec))
-			kfree(uncmem);
+	if (!is_partial_io(bvec)) {
+		kunmap_atomic(user_mem);
+		user_mem = NULL;
+		uncmem = NULL;
+	}
 
 	if (unlikely(ret != LZO_E_OK)) {
 		pr_err("Compression failed! err=%d\n", ret);
@@ -349,8 +356,10 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 
 	if (unlikely(clen > max_zpage_size)) {
 		zram_stat_inc(&zram->stats.bad_compress);
-		src = uncmem;
 		clen = PAGE_SIZE;
+		src = NULL;
+		if (is_partial_io(bvec))
+			src = uncmem;
 	}
 
 	handle = zs_malloc(zram->mem_pool, clen);
@@ -362,7 +371,11 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	}
 	cmem = zs_map_object(zram->mem_pool, handle, ZS_MM_WO);
 
+	if ((clen == PAGE_SIZE) && !(is_partial_io(bvec)))
+		src = kmap_atomic(page);
 	memcpy(cmem, src, clen);
+	if ((clen == PAGE_SIZE) && !(is_partial_io(bvec)))
+		kunmap_atomic(src);
 
 	zs_unmap_object(zram->mem_pool, handle);
 
@@ -375,9 +388,10 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	if (clen <= PAGE_SIZE / 2)
 		zram_stat_inc(&zram->stats.good_compress);
 
-	return 0;
-
 out:
+	if (is_partial_io(bvec))
+		kfree(uncmem);
+
 	if (ret)
 		zram_stat64_inc(zram, &zram->stats.failed_writes);
 	return ret;
-- 
1.7.10.4

