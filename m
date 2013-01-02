Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab3ABFYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 00:24:36 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:37704 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab3ABFYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 00:24:32 -0500
Message-ID: <1357104269.2182.6.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH 3/3] staging: zram: drop zram_stat_dec/inc functions
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>
Date: Tue, 01 Jan 2013 21:24:29 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems like an overkill to have adding and subtracting
1 functions from the 32bit counters. Just do it directly.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 drivers/staging/zram/zram_drv.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 10d7592..6762b99 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -42,16 +42,6 @@ struct zram *zram_devices;
 /* Module params (documentation at end) */
 static unsigned int num_devices = 1;
 
-static void zram_stat_inc(u32 *v)
-{
-	*v = *v + 1;
-}
-
-static void zram_stat_dec(u32 *v)
-{
-	*v = *v - 1;
-}
-
 static void zram_stat64_add(struct zram *zram, u64 *v, u64 inc)
 {
 	spin_lock(&zram->stat64_lock);
@@ -144,22 +134,22 @@ static void zram_free_page(struct zram *zram, size_t index)
 		 */
 		if (zram_test_flag(zram, index, ZRAM_ZERO)) {
 			zram_clear_flag(zram, index, ZRAM_ZERO);
-			zram_stat_dec(&zram->stats.pages_zero);
+			zram->stats.pages_zero--;
 		}
 		return;
 	}
 
 	if (unlikely(size > max_zpage_size))
-		zram_stat_dec(&zram->stats.bad_compress);
+		zram->stats.bad_compress--;
 
 	zs_free(zram->mem_pool, handle);
 
 	if (size <= PAGE_SIZE / 2)
-		zram_stat_dec(&zram->stats.good_compress);
+		zram->stats.good_compress--;
 
 	zram_stat64_sub(zram, &zram->stats.compr_size,
 			zram->table[index].size);
-	zram_stat_dec(&zram->stats.pages_stored);
+	zram->stats.pages_stored--;
 
 	zram->table[index].handle = 0;
 	zram->table[index].size = 0;
@@ -311,7 +301,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		kunmap_atomic(user_mem);
 		if (is_partial_io(bvec))
 			kfree(uncmem);
-		zram_stat_inc(&zram->stats.pages_zero);
+		zram->stats.pages_zero++;
 		zram_set_flag(zram, index, ZRAM_ZERO);
 		ret = 0;
 		goto out;
@@ -330,7 +320,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	}
 
 	if (unlikely(clen > max_zpage_size)) {
-		zram_stat_inc(&zram->stats.bad_compress);
+		zram->stats.bad_compress++;
 		src = uncmem;
 		clen = PAGE_SIZE;
 	}
@@ -353,9 +343,9 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 
 	/* Update stats */
 	zram_stat64_add(zram, &zram->stats.compr_size, clen);
-	zram_stat_inc(&zram->stats.pages_stored);
+	zram->stats.pages_stored++;
 	if (clen <= PAGE_SIZE / 2)
-		zram_stat_inc(&zram->stats.good_compress);
+		zram->stats.good_compress++;
 
 	return 0;
 
-- 
1.7.11.7




