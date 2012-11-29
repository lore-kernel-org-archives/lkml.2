Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab2K2HpP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 02:45:15 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47494 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2K2HpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 02:45:13 -0500
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>, Tomas M <tomas@slax.org>,
        Mihail Kasadjikov <hamer.mk@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] zram: Fix use-after-free bug in disk write case
Date: Wed, 28 Nov 2012 23:45:06 -0800
Message-Id: <1354175106-30679-1-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog v2 vs v1:
 - Changelog message now correctly explains the problem

Fixes a bug introduced by commit c8f2f0db1 ("zram: Fix handling
of incompressible pages") which caused a freed buffer to be used
in case a partial write (non PAGE_SIZED) request is received and
the data is found to be incompressible.

Fixes bug 50081:
https://bugzilla.kernel.org/show_bug.cgi?id=50081

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
Reported-by: Mihail Kasadjikov <hamer.mk@gmail.com>
Reported-by: Tomas M <tomas@slax.org>
Reviewed-by: Minchan Kim <minchan@kernel.org>
---
 drivers/staging/zram/zram_drv.c |   39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index fb4a7c9..f2a73bd 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -265,7 +265,7 @@ out_cleanup:
 static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 			   int offset)
 {
-	int ret;
+	int ret = 0;
 	size_t clen;
 	unsigned long handle;
 	struct page *page;
@@ -286,10 +286,8 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 			goto out;
 		}
 		ret = zram_decompress_page(zram, uncmem, index);
-		if (ret) {
-			kfree(uncmem);
+		if (ret)
 			goto out;
-		}
 	}
 
 	/*
@@ -302,16 +300,18 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 
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
@@ -321,9 +321,11 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
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
@@ -332,8 +334,10 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 
 	if (unlikely(clen > max_zpage_size)) {
 		zram_stat_inc(&zram->stats.bad_compress);
-		src = uncmem;
 		clen = PAGE_SIZE;
+		src = NULL;
+		if (is_partial_io(bvec))
+			src = uncmem;
 	}
 
 	handle = zs_malloc(zram->mem_pool, clen);
@@ -345,7 +349,11 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	}
 	cmem = zs_map_object(zram->mem_pool, handle, ZS_MM_WO);
 
+	if ((clen == PAGE_SIZE) && !is_partial_io(bvec))
+		src = kmap_atomic(page);
 	memcpy(cmem, src, clen);
+	if ((clen == PAGE_SIZE) && !is_partial_io(bvec))
+		kunmap_atomic(src);
 
 	zs_unmap_object(zram->mem_pool, handle);
 
@@ -358,9 +366,10 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
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

