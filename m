Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab2JKAmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:42:31 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:40865 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769Ab2JKAm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:42:26 -0400
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] [staging][zram] Fix handling of incompressible pages
Date: Wed, 10 Oct 2012 17:42:18 -0700
Message-Id: <1349916138-9011-1-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change 130f315a (staging: zram: remove special handle of uncompressed page)
introduced a bug in the handling of incompressible pages which resulted in
memory allocation failure for such pages.

When a page expands on compression, say from 4K to 4K+30, we were trying to
do zsmalloc(pool, 4K+30). However, the maximum size which zsmalloc can
allocate is PAGE_SIZE (for obvious reasons), so such allocation requests
always return failure (0).

For a page that has compressed size larger than the original size (this may
happen with already compressed or random data), there is no point storing
the compressed version as that would take more space and would also require
time for decompression when needed again. So, the fix is to store any page,
whose compressed size exceeds a threshold (max_zpage_size), as-it-is i.e.
without compression.  Memory required for storing this uncompressed page can
then be requested from zsmalloc which supports PAGE_SIZE sized allocations.

Lastly, the fix checks that we do not attempt to "decompress" the page which
we stored in the uncompressed form -- we just memcpy() out such pages.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
Reported-by: viechweg@gmail.com
Reported-by: paerley@gmail.com
Reported-by: wu.tommy@gmail.com
Acked-by: Minchan Kim <minchan@kernel.org>
---
 drivers/staging/zram/zram_drv.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 653b074..6edefde 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -223,8 +223,13 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 	cmem = zs_map_object(zram->mem_pool, zram->table[index].handle,
 				ZS_MM_RO);
 
-	ret = lzo1x_decompress_safe(cmem, zram->table[index].size,
+	if (zram->table[index].size == PAGE_SIZE) {
+		memcpy(uncmem, cmem, PAGE_SIZE);
+		ret = LZO_E_OK;
+	} else {
+		ret = lzo1x_decompress_safe(cmem, zram->table[index].size,
 				    uncmem, &clen);
+	}
 
 	if (is_partial_io(bvec)) {
 		memcpy(user_mem + bvec->bv_offset, uncmem + offset,
@@ -342,8 +347,11 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		goto out;
 	}
 
-	if (unlikely(clen > max_zpage_size))
+	if (unlikely(clen > max_zpage_size)) {
 		zram_stat_inc(&zram->stats.bad_compress);
+		src = uncmem;
+		clen = PAGE_SIZE;
+	}
 
 	handle = zs_malloc(zram->mem_pool, clen);
 	if (!handle) {
-- 
1.7.9.5

