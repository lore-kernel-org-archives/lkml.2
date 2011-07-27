Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1G0TLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 15:11:39 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:54710 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab1G0TLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 15:11:35 -0400
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH RFCv2 1/8] list, treewide: Rename __list_del() to __list_link()
Date: Wed, 27 Jul 2011 21:10:18 +0200
Message-Id: <1311793825-31933-2-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311793825-31933-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1311793825-31933-1-git-send-email-schnhrr@cs.tu-berlin.de>
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
 drivers/firewire/core-topology.c     |    2 +-
 drivers/gpu/drm/ttm/ttm_page_alloc.c |    4 ++--
 include/linux/list.h                 |   11 +++++------
 include/linux/rculist.h              |    2 +-
 kernel/mutex.h                       |    2 +-
 kernel/timer.c                       |    2 +-
 lib/list_debug.c                     |    2 +-
 net/ipv4/cipso_ipv4.c                |    2 +-
 8 files changed, 13 insertions(+), 14 deletions(-)

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
index cc6d2aa..9d093cc 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -77,13 +77,12 @@ static inline void list_add_tail(struct list_head *new, struct list_head *head)
 }
 
 /*
- * Delete a list entry by making the prev/next entries
+ * Link two list entries by making the prev/next entries
  * point to each other.
  *
- * This is only for internal list manipulation where we know
- * the prev/next entries already!
+ * This is only for internal list manipulation.
  */
-static inline void __list_del(struct list_head * prev, struct list_head * next)
+static inline void __list_link(struct list_head *prev, struct list_head *next)
 {
 	next->prev = prev;
 	prev->next = next;
@@ -98,12 +97,12 @@ static inline void __list_del(struct list_head * prev, struct list_head * next)
 #ifndef CONFIG_DEBUG_LIST
 static inline void __list_del_entry(struct list_head *entry)
 {
-	__list_del(entry->prev, entry->next);
+	__list_link(entry->prev, entry->next);
 }
 
 static inline void list_del(struct list_head *entry)
 {
-	__list_del(entry->prev, entry->next);
+	__list_link(entry->prev, entry->next);
 	entry->next = LIST_POISON1;
 	entry->prev = LIST_POISON2;
 }
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
 
diff --git a/kernel/mutex.h b/kernel/mutex.h
index 4115fbf..bcac8d1 100644
--- a/kernel/mutex.h
+++ b/kernel/mutex.h
@@ -14,7 +14,7 @@
 #define spin_unlock_mutex(lock, flags) \
 		do { spin_unlock(lock); (void)(flags); } while (0)
 #define mutex_remove_waiter(lock, waiter, ti) \
-		__list_del((waiter)->list.prev, (waiter)->list.next)
+		__list_link((waiter)->list.prev, (waiter)->list.next)
 
 #ifdef CONFIG_SMP
 static inline void mutex_set_owner(struct mutex *lock)
diff --git a/kernel/timer.c b/kernel/timer.c
index 8cff361..7ecae26 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -615,7 +615,7 @@ static inline void detach_timer(struct timer_list *timer,
 
 	debug_deactivate(timer);
 
-	__list_del(entry->prev, entry->next);
+	__list_link(entry->prev, entry->next);
 	if (clear_pending)
 		entry->next = NULL;
 	entry->prev = LIST_POISON2;
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
 
diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 2b3c23c..5803807 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -348,7 +348,7 @@ static int cipso_v4_cache_check(const unsigned char *key,
 			if (entry->activity > prev_entry->activity &&
 			    entry->activity - prev_entry->activity >
 			    CIPSO_V4_CACHE_REORDERLIMIT) {
-				__list_del(entry->list.prev, entry->list.next);
+				__list_link(entry->list.prev, entry->list.next);
 				__list_add(&entry->list,
 					   prev_entry->list.prev,
 					   &prev_entry->list);
-- 
1.7.6

