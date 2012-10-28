Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab2J1TPX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 15:15:23 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:41783 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab2J1TPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 15:15:12 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 2/5] mm, highmem: remove useless pool_lock
Date: Mon, 29 Oct 2012 04:12:53 +0900
Message-Id: <1351451576-2611-3-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351451576-2611-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1351451576-2611-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pool_lock protects the page_address_pool from concurrent access.
But, access to the page_address_pool is already protected by kmap_lock.
So remove it.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/mm/highmem.c b/mm/highmem.c
index b3b3d68..017bad1 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -328,7 +328,6 @@ struct page_address_map {
  * page_address_map freelist, allocated from page_address_maps.
  */
 static struct list_head page_address_pool;	/* freelist */
-static spinlock_t pool_lock;			/* protects page_address_pool */
 
 /*
  * Hash table bucket
@@ -395,11 +394,9 @@ void set_page_address(struct page *page, void *virtual)
 	if (virtual) {		/* Add */
 		BUG_ON(list_empty(&page_address_pool));
 
-		spin_lock_irqsave(&pool_lock, flags);
 		pam = list_entry(page_address_pool.next,
 				struct page_address_map, list);
 		list_del(&pam->list);
-		spin_unlock_irqrestore(&pool_lock, flags);
 
 		pam->page = page;
 		pam->virtual = virtual;
@@ -413,9 +410,7 @@ void set_page_address(struct page *page, void *virtual)
 			if (pam->page == page) {
 				list_del(&pam->list);
 				spin_unlock_irqrestore(&pas->lock, flags);
-				spin_lock_irqsave(&pool_lock, flags);
 				list_add_tail(&pam->list, &page_address_pool);
-				spin_unlock_irqrestore(&pool_lock, flags);
 				goto done;
 			}
 		}
@@ -438,7 +433,6 @@ void __init page_address_init(void)
 		INIT_LIST_HEAD(&page_address_htable[i].lh);
 		spin_lock_init(&page_address_htable[i].lock);
 	}
-	spin_lock_init(&pool_lock);
 }
 
 #endif	/* defined(CONFIG_HIGHMEM) && !defined(WANT_PAGE_VIRTUAL) */
-- 
1.7.9.5

