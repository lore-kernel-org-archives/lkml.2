Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab1K0FjF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:39:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755826Ab1K0FjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:39:01 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com
Subject: [PATCH 60/62] drbd: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:27:40 +0800
Message-Id: <1322371662-26166-61-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 drivers/block/drbd/drbd_bitmap.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 39de9ff..3030201 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -289,7 +289,7 @@ static unsigned int bm_bit_to_page_idx(struct drbd_bitmap *b, u64 bitnr)
 	return page_nr;
 }
 
-static unsigned long *__bm_map_pidx(struct drbd_bitmap *b, unsigned int idx, const enum km_type km)
+static unsigned long *__bm_map_pidx(struct drbd_bitmap *b, unsigned int idx)
 {
 	struct page *page = b->bm_pages[idx];
 	return (unsigned long *) kmap_atomic(page);
@@ -551,7 +551,7 @@ static unsigned long bm_count_bits(struct drbd_bitmap *b)
 	}
 	/* last (or only) page */
 	last_word = ((b->bm_bits - 1) & BITS_PER_PAGE_MASK) >> LN2_BPL;
-	p_addr = __bm_map_pidx(b, idx, KM_USER0);
+	p_addr = __bm_map_pidx(b, idx);
 	for (i = 0; i < last_word; i++)
 		bits += hweight_long(p_addr[i]);
 	p_addr[last_word] &= cpu_to_lel(mask);
@@ -559,7 +559,7 @@ static unsigned long bm_count_bits(struct drbd_bitmap *b)
 	/* 32bit arch, may have an unused padding long */
 	if (BITS_PER_LONG == 32 && (last_word & 1) == 0)
 		p_addr[last_word+1] = 0;
-	__bm_unmap(p_addr, KM_USER0);
+	__bm_unmap(p_addr);
 	return bits;
 }
 
@@ -970,11 +970,11 @@ static void bm_page_io_async(struct bm_aio_ctx *ctx, int page_nr, int rw) __must
 		 * to use pre-allocated page pool */
 		void *src, *dest;
 		page = alloc_page(__GFP_HIGHMEM|__GFP_WAIT);
-		dest = kmap_atomic(page, KM_USER0);
-		src = kmap_atomic(b->bm_pages[page_nr], KM_USER1);
+		dest = kmap_atomic(page);
+		src = kmap_atomic(b->bm_pages[page_nr]);
 		memcpy(dest, src, PAGE_SIZE);
-		kunmap_atomic(src, KM_USER1);
-		kunmap_atomic(dest, KM_USER0);
+		kunmap_atomic(src);
+		kunmap_atomic(dest);
 		bm_store_page_idx(page, page_nr);
 	} else
 		page = b->bm_pages[page_nr];
-- 
1.7.4.4

