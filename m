Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933Ab0LTRDP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 12:03:15 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:32883 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932881Ab0LTRDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 12:03:14 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Take lock only once in dma_pool_free()
Date: Mon, 20 Dec 2010 18:03:06 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.31.14-0.2-desktop; KDE/4.5.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201012201803.06873.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0db01c2ea9476609c399de3e9fdf7861df07d2f1 Mon Sep 17 00:00:00 2001
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Date: Mon, 20 Dec 2010 17:29:33 +0100
Subject: [PATCH] Speed up dma_pool_free()

dma_pool_free() scans for the page to free in the pool list holding the pool
lock. Then it releases the lock basically to acquire it immediately again.
Modify the code to only take the lock once.

This will do some additional loops and computations with the lock held in if 
memory debugging is activated. If it is not activated the only new operations 
with this lock is one if and one substraction.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
---
 mm/dmapool.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/mm/dmapool.c b/mm/dmapool.c
index 4df2de7..a2f6295 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -355,20 +355,15 @@ EXPORT_SYMBOL(dma_pool_alloc);
 
 static struct dma_page *pool_find_page(struct dma_pool *pool, dma_addr_t dma)
 {
-	unsigned long flags;
 	struct dma_page *page;
 
-	spin_lock_irqsave(&pool->lock, flags);
 	list_for_each_entry(page, &pool->page_list, page_list) {
 		if (dma < page->dma)
 			continue;
 		if (dma < (page->dma + pool->allocation))
-			goto done;
+			return page;
 	}
-	page = NULL;
- done:
-	spin_unlock_irqrestore(&pool->lock, flags);
-	return page;
+	return NULL;
 }
 
 /**
@@ -386,8 +381,10 @@ void dma_pool_free(struct dma_pool *pool, void *vaddr, 
dma_addr_t dma)
 	unsigned long flags;
 	unsigned int offset;
 
+	spin_lock_irqsave(&pool->lock, flags);
 	page = pool_find_page(pool, dma);
 	if (!page) {
+		spin_unlock_irqrestore(&pool->lock, flags);
 		if (pool->dev)
 			dev_err(pool->dev,
 				"dma_pool_free %s, %p/%lx (bad dma)\n",
@@ -401,6 +398,7 @@ void dma_pool_free(struct dma_pool *pool, void *vaddr, 
dma_addr_t dma)
 	offset = vaddr - page->vaddr;
 #ifdef	DMAPOOL_DEBUG
 	if ((dma - page->dma) != offset) {
+		spin_unlock_irqrestore(&pool->lock, flags);
 		if (pool->dev)
 			dev_err(pool->dev,
 				"dma_pool_free %s, %p (bad vaddr)/%Lx\n",
@@ -418,6 +416,7 @@ void dma_pool_free(struct dma_pool *pool, void *vaddr, 
dma_addr_t dma)
 				chain = *(int *)(page->vaddr + chain);
 				continue;
 			}
+			spin_unlock_irqrestore(&pool->lock, flags);
 			if (pool->dev)
 				dev_err(pool->dev, "dma_pool_free %s, dma %Lx "
 					"already free\n", pool->name,
@@ -432,7 +431,6 @@ void dma_pool_free(struct dma_pool *pool, void *vaddr, 
dma_addr_t dma)
 	memset(vaddr, POOL_POISON_FREED, pool->size);
 #endif
 
-	spin_lock_irqsave(&pool->lock, flags);
 	page->in_use--;
 	*(int *)vaddr = page->offset;
 	page->offset = offset;
-- 
1.6.4.2

