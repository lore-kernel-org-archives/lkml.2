Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab2JIBcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 21:32:54 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:47295 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab2JIBcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 21:32:52 -0400
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Sam Hansen <solid.se7en@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] [staging][zram] Fix handling of incompressible pages
Date: Mon,  8 Oct 2012 18:32:44 -0700
Message-Id: <1349746364-8051-1-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change 130f315a introduced a bug in the handling of incompressible
pages which resulted in memory allocation failure for such pages.
The fix is to store the page as-is i.e. without compression if the
compressed size exceeds a threshold (max_zpage_size) and request
exactly PAGE_SIZE sized buffer from zsmalloc.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
Reported-by: viechweg@gmail.com
Reported-by: paerley@gmail.com
Reported-by: wu.tommy@gmail.com
Tested-by: wu.tommy@gmail.com
Tested-by: michael@zugelder.org
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

