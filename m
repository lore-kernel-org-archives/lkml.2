Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263Ab1L1Fuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 00:50:55 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35044 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1L1Fuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 00:50:52 -0500
MIME-Version: 1.0
Date: Wed, 28 Dec 2011 11:20:51 +0530
Message-ID: <CAB4K4y4UWXXb8Tm_arYG7=_MOyMxJnk3jRLGbaXTyFiNKM-TOw@mail.gmail.com>
Subject: [PATCH] xvmalloc: total_pages can be ulong
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4763266cb0077d1082d4a1ef941448e9b4eb55ca Mon Sep 17 00:00:00 2001
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Date: Wed, 28 Dec 2011 11:08:34 +0530
Subject: [PATCH] xvmalloc: total_pages can be ulong

total_pages is u64, its too large value considering
that its in page unit on both 32-bit and 64-bit system
, therefore make it ulong.

Having done that we can use normal ++ and -- operators
instead of stat_inc() and stat_dec(), therefore
remove these functions as well.

Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
---
 drivers/staging/zram/xvmalloc.c     |   16 +++-------------
 drivers/staging/zram/xvmalloc_int.h |    2 +-
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/zram/xvmalloc.c b/drivers/staging/zram/xvmalloc.c
index 1f9c508..2f989cf 100644
--- a/drivers/staging/zram/xvmalloc.c
+++ b/drivers/staging/zram/xvmalloc.c
@@ -26,16 +26,6 @@
 #include "xvmalloc.h"
 #include "xvmalloc_int.h"

-static void stat_inc(u64 *value)
-{
-	*value = *value + 1;
-}
-
-static void stat_dec(u64 *value)
-{
-	*value = *value - 1;
-}
-
 static int test_flag(struct block_header *block, enum blockflags flag)
 {
 	return block->prev & BIT(flag);
@@ -281,7 +271,7 @@ static int grow_pool(struct xv_pool *pool, gfp_t flags)
 	if (unlikely(!page))
 		return -ENOMEM;

-	stat_inc(&pool->total_pages);
+	pool->total_pages++;

 	spin_lock(&pool->lock);
 	block = get_ptr_atomic(page, 0, KM_USER0);
@@ -472,7 +462,7 @@ void xv_free(struct xv_pool *pool, struct page
*page, u32 offset)
 		spin_unlock(&pool->lock);

 		__free_page(page);
-		stat_dec(&pool->total_pages);
+		pool->total_pages--;
 		return;
 	}

@@ -505,6 +495,6 @@ EXPORT_SYMBOL_GPL(xv_get_object_size);
  */
 u64 xv_get_total_size_bytes(struct xv_pool *pool)
 {
-	return pool->total_pages << PAGE_SHIFT;
+	return (u64)pool->total_pages << PAGE_SHIFT;
 }
 EXPORT_SYMBOL_GPL(xv_get_total_size_bytes);
diff --git a/drivers/staging/zram/xvmalloc_int.h
b/drivers/staging/zram/xvmalloc_int.h
index b5f1f7f..fcb0868 100644
--- a/drivers/staging/zram/xvmalloc_int.h
+++ b/drivers/staging/zram/xvmalloc_int.h
@@ -87,7 +87,7 @@ struct block_header {
 struct xv_pool {
 	ulong flbitmap;
 	ulong slbitmap[MAX_FLI];
-	u64 total_pages;	/* stats */
+	ulong total_pages;	/* stats */
 	struct freelist_entry freelist[NUM_FREE_LISTS];
 	spinlock_t lock;
 };
-- 
1.6.0.3
