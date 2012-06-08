Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590Ab2FHGkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 02:40:22 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55823 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab2FHGjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 02:39:40 -0400
X-AuditID: 9c930179-b7bb9ae000000ea5-1c-4fd19e2462a0
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH] zram: fix random data read
Date: Fri,  8 Jun 2012 15:39:26 +0900
Message-Id: <1339137567-29656-2-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339137567-29656-1-git-send-email-minchan@kernel.org>
References: <1339137567-29656-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fd1a30de makes a bug that it uses (struct page *) as zsmalloc's handle
although it's a uncompressed page so that it can access random page,
return random data or even crashed by get_first_page in zs_map_object.

Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/staging/zram/zram_drv.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index abd69d1..0cdc303 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -280,26 +280,27 @@ static int zram_read_before_write(struct zram *zram, char *mem, u32 index)
 	size_t clen = PAGE_SIZE;
 	struct zobj_header *zheader;
 	unsigned char *cmem;
+	unsigned long handle = zram->table[index].handle;
 
-	if (zram_test_flag(zram, index, ZRAM_ZERO) ||
-	    !zram->table[index].handle) {
+	if (zram_test_flag(zram, index, ZRAM_ZERO) || !handle) {
 		memset(mem, 0, PAGE_SIZE);
 		return 0;
 	}
 
-	cmem = zs_map_object(zram->mem_pool, zram->table[index].handle);
-
 	/* Page is stored uncompressed since it's incompressible */
 	if (unlikely(zram_test_flag(zram, index, ZRAM_UNCOMPRESSED))) {
-		memcpy(mem, cmem, PAGE_SIZE);
-		kunmap_atomic(cmem);
+		char *src = kmap_atomic((struct page *)handle);
+		memcpy(mem, src, PAGE_SIZE);
+		kunmap_atomic(src);
 		return 0;
 	}
 
+	cmem = zs_map_object(zram->mem_pool, handle);
+
 	ret = lzo1x_decompress_safe(cmem + sizeof(*zheader),
 				    zram->table[index].size,
 				    mem, &clen);
-	zs_unmap_object(zram->mem_pool, zram->table[index].handle);
+	zs_unmap_object(zram->mem_pool, handle);
 
 	/* Should NEVER happen. Return bio error if it does. */
 	if (unlikely(ret != LZO_E_OK)) {
-- 
1.7.9.5

