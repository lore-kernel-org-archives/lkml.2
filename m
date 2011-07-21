Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab1GUNVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 09:21:25 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:64319 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab1GUNVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 09:21:22 -0400
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Paul Turner <pjt@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH RFC 1/3] list, treewide: Rename __list_del() to __list_link()
Date: Thu, 21 Jul 2011 15:20:21 +0200
Message-Id: <1311254423-25484-2-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311254423-25484-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <CAPM31RLqq0hgdhoh3GA-38petKeE1zxcL=uJYba9o3yd+_7jjw@mail.gmail.com>
 <1311254423-25484-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>

The purpose of __list_del() is to let two list entries point to each other.
It does not actually remove anything. It can be used to delete something
as it is done from within __list_del_entry().

This commit renames __list_del() to __list_link() as this new name better
reflects what the function is actually doing.

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>

---
We could now rephrase some of the existing list-functions with
__list_link(). Might be more readable. Also, there are quite a few
other follow-up patches when looking longer at this.
---
 drivers/firewire/core-topology.c     |    2 +-
 drivers/gpu/drm/ttm/ttm_page_alloc.c |    4 ++--
 include/linux/list.h                 |    6 +++---
 include/linux/rculist.h              |    2 +-
 lib/list_debug.c                     |    2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/firewire/core-topology.c b/drivers/firewire/core-topology.c
index 193ed92..b7cd1db 100644
--- a/drivers/firewire/core-topology.c
+++ b/drivers/firewire/core-topology.c
@@ -290,7 +290,7 @@ static struct fw_node *build_tree(struct fw_card *card,
 		}
 
 		/* Pop the child nodes off the stack and push the new node. */
-		__list_del(h->prev, &stack);
+		__list_link(h->prev, &stack);
 		list_add_tail(&node->link, &stack);
 		stack_depth += 1 - child_port_count;
 
diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
index d948575..fd4443a 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -331,7 +331,7 @@ restart:
 		/* We can only remove NUM_PAGES_TO_ALLOC at a time. */
 		if (freed_pages >= NUM_PAGES_TO_ALLOC) {
 			/* remove range of pages from the pool */
-			__list_del(p->lru.prev, &pool->list);
+			__list_link(p->lru.prev, &pool->list);
 
 			ttm_pool_update_free_locked(pool, freed_pages);
 			/**
@@ -366,7 +366,7 @@ restart:
 
 	/* remove range of pages from the pool */
 	if (freed_pages) {
-		__list_del(&p->lru, &pool->list);
+		__list_link(&p->lru, &pool->list);
 
 		ttm_pool_update_free_locked(pool, freed_pages);
 		nr_free -= freed_pages;
diff --git a/include/linux/list.h b/include/linux/list.h
index cc6d2aa..025b883 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -77,13 +77,13 @@ static inline void list_add_tail(struct list_head *new, struct list_head *head)
 }
 
 /*
- * Delete a list entry by making the prev/next entries
+ * Link two list entries by making the prev/next entries
  * point to each other.
  *
  * This is only for internal list manipulation where we know
  * the prev/next entries already!
  */
-static inline void __list_del(struct list_head * prev, struct list_head * next)
+static inline void __list_link(struct list_head *prev, struct list_head *next)
 {
 	next->prev = prev;
 	prev->next = next;
@@ -98,7 +98,7 @@ static inline void __list_del(struct list_head * prev, struct list_head * next)
 #ifndef CONFIG_DEBUG_LIST
 static inline void __list_del_entry(struct list_head *entry)
 {
-	__list_del(entry->prev, entry->next);
+	__list_link(entry->prev, entry->next);
 }
 
 static inline void list_del(struct list_head *entry)
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index e3beb31..748401b 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -108,7 +108,7 @@ static inline void list_add_tail_rcu(struct list_head *new,
  */
 static inline void list_del_rcu(struct list_head *entry)
 {
-	__list_del(entry->prev, entry->next);
+	__list_link(entry->prev, entry->next);
 	entry->prev = LIST_POISON2;
 }
 
diff --git a/lib/list_debug.c b/lib/list_debug.c
index b8029a5..7e37695 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -56,7 +56,7 @@ void __list_del_entry(struct list_head *entry)
 		"but was %p\n", entry, next->prev))
 		return;
 
-	__list_del(prev, next);
+	__list_link(prev, next);
 }
 EXPORT_SYMBOL(__list_del_entry);
 
-- 
1.7.6

