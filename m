Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab1K0Fhq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:37:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755627Ab1K0Fhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:37:43 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 51/62] lib: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:27:31 +0800
Message-Id: <1322371662-26166-52-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 lib/scatterlist.c |    4 ++--
 lib/swiotlb.c     |    5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 4ceb05d..33b2cbb 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -390,7 +390,7 @@ bool sg_miter_next(struct sg_mapping_iter *miter)
 	miter->consumed = miter->length;
 
 	if (miter->__flags & SG_MITER_ATOMIC)
-		miter->addr = kmap_atomic(miter->page, KM_BIO_SRC_IRQ) + off;
+		miter->addr = kmap_atomic(miter->page) + off;
 	else
 		miter->addr = kmap(miter->page) + off;
 
@@ -424,7 +424,7 @@ void sg_miter_stop(struct sg_mapping_iter *miter)
 
 		if (miter->__flags & SG_MITER_ATOMIC) {
 			WARN_ON(!irqs_disabled());
-			kunmap_atomic(miter->addr, KM_BIO_SRC_IRQ);
+			kunmap_atomic(miter->addr);
 		} else
 			kunmap(miter->page);
 
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 99093b3..78361bc 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -348,13 +348,12 @@ void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
 			sz = min_t(size_t, PAGE_SIZE - offset, size);
 
 			local_irq_save(flags);
-			buffer = kmap_atomic(pfn_to_page(pfn),
-					     KM_BOUNCE_READ);
+			buffer = kmap_atomic(pfn_to_page(pfn));
 			if (dir == DMA_TO_DEVICE)
 				memcpy(dma_addr, buffer + offset, sz);
 			else
 				memcpy(buffer + offset, dma_addr, sz);
-			kunmap_atomic(buffer, KM_BOUNCE_READ);
+			kunmap_atomic(buffer);
 			local_irq_restore(flags);
 
 			size -= sz;
-- 
1.7.4.4

