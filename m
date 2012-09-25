Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab2IYL5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:57:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37831 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab2IYL5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:57:45 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, drbd-dev@lists.linbit.com
Subject: [PATCH] drbd: use copy_highpage
Date: Tue, 25 Sep 2012 20:57:01 +0900
Message-Id: <1348574222-3512-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use copy_highpage() to copy from one page to another.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: drbd-dev@lists.linbit.com
---
 drivers/block/drbd/drbd_bitmap.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index d4d3c81..ec7f76c 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -975,13 +975,8 @@ static void bm_page_io_async(struct bm_aio_ctx *ctx, int page_nr, int rw) __must
 	bm_set_page_unchanged(b->bm_pages[page_nr]);
 
 	if (ctx->flags & BM_AIO_COPY_PAGES) {
-		void *src, *dest;
 		page = mempool_alloc(drbd_md_io_page_pool, __GFP_HIGHMEM|__GFP_WAIT);
-		dest = kmap_atomic(page);
-		src = kmap_atomic(b->bm_pages[page_nr]);
-		memcpy(dest, src, PAGE_SIZE);
-		kunmap_atomic(src);
-		kunmap_atomic(dest);
+		copy_highpage(page, b->bm_pages[page_nr]);
 		bm_store_page_idx(page, page_nr);
 	} else
 		page = b->bm_pages[page_nr];
-- 
1.7.11.4

