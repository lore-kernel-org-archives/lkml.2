Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560Ab2FUDmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 23:42:37 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:38298 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758505Ab2FUDmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 23:42:35 -0400
X-Greylist: delayed 464 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jun 2012 23:42:35 EDT
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-mm-cc@laptop.org, ngupta@vflare.org,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 2/2] staging: zram: Remove useless struct zobj_header
Date: Thu, 21 Jun 2012 00:32:45 -0300
Message-Id: <1340249565-29404-3-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1340249565-29404-1-git-send-email-marcos.souza.org@gmail.com>
References: <1340249565-29404-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The struct zobj_header has no members, so the sizeof(struct zobj_header *)
always returns zero. For this reason we are removing this useless struct.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/zram/zram_drv.c |    9 +++------
 drivers/staging/zram/zram_drv.h |    9 ---------
 2 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 5216ee1..a79a20d 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -209,7 +209,6 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 	int ret;
 	size_t clen;
 	struct page *page;
-	struct zobj_header *zheader;
 	unsigned char *user_mem, *cmem, *uncmem = NULL;
 
 	page = bvec->bv_page;
@@ -249,7 +248,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 
 	cmem = zs_map_object(zram->mem_pool, zram->table[index].handle);
 
-	ret = lzo1x_decompress_safe(cmem + sizeof(*zheader),
+	ret = lzo1x_decompress_safe(cmem,
 				    zram->table[index].size,
 				    uncmem, &clen);
 
@@ -278,7 +277,6 @@ static int zram_read_before_write(struct zram *zram, char *mem, u32 index)
 {
 	int ret;
 	size_t clen = PAGE_SIZE;
-	struct zobj_header *zheader;
 	unsigned char *cmem;
 
 	if (zram_test_flag(zram, index, ZRAM_ZERO) ||
@@ -296,7 +294,7 @@ static int zram_read_before_write(struct zram *zram, char *mem, u32 index)
 		return 0;
 	}
 
-	ret = lzo1x_decompress_safe(cmem + sizeof(*zheader),
+	ret = lzo1x_decompress_safe(cmem,
 				    zram->table[index].size,
 				    mem, &clen);
 	zs_unmap_object(zram->mem_pool, zram->table[index].handle);
@@ -318,7 +316,6 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	u32 store_offset;
 	size_t clen;
 	void *handle;
-	struct zobj_header *zheader;
 	struct page *page, *page_store;
 	unsigned char *user_mem, *cmem, *src, *uncmem = NULL;
 
@@ -405,7 +402,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		goto memstore;
 	}
 
-	handle = zs_malloc(zram->mem_pool, clen + sizeof(*zheader));
+	handle = zs_malloc(zram->mem_pool, clen);
 	if (!handle) {
 		pr_info("Error allocating memory for compressed "
 			"page: %u, size=%zu\n", index, clen);
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index fe3f8fe..883f313 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -26,15 +26,6 @@
  */
 static const unsigned max_num_devices = 32;
 
-/*
- * Stored at beginning of each compressed object.
- *
- * It stores back-reference to table entry which points to this
- * object. This is required to support memory defragmentation.
- */
-struct zobj_header {
-};
-
 /*-- Configurable parameters */
 
 /* Default zram disk size: 25% of total RAM */
-- 
1.7.10.2

