Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab1H3JGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 05:06:00 -0400
Received: from mail09.linbit.com ([212.69.161.110]:38223 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab1H3JF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 05:05:56 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 10/15] lru_cache: consolidate lc_get and lc_try_get
Date: Tue, 30 Aug 2011 11:05:44 +0200
Message-Id: <1314695149-387-11-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314695149-387-1-git-send-email-philipp.reisner@linbit.com>
References: <1314695149-387-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 lib/lru_cache.c |  120 ++++++++++++++++++++++++++++---------------------------
 1 files changed, 61 insertions(+), 59 deletions(-)

diff --git a/lib/lru_cache.c b/lib/lru_cache.c
index 4f638b8..1762168 100644
--- a/lib/lru_cache.c
+++ b/lib/lru_cache.c
@@ -308,45 +308,7 @@ static int lc_unused_element_available(struct lru_cache *lc)
 	return 0;
 }
 
-
-/**
- * lc_get - get element by label, maybe change the active set
- * @lc: the lru cache to operate on
- * @enr: the label to look up
- *
- * Finds an element in the cache, increases its usage count,
- * "touches" and returns it.
- *
- * In case the requested number is not present, it needs to be added to the
- * cache. Therefore it is possible that an other element becomes evicted from
- * the cache. In either case, the user is notified so he is able to e.g. keep
- * a persistent log of the cache changes, and therefore the objects in use.
- *
- * Return values:
- *  NULL
- *     The cache was marked %LC_STARVING,
- *     or the requested label was not in the active set
- *     and a changing transaction is still pending (@lc was marked %LC_DIRTY).
- *     Or no unused or free element could be recycled (@lc will be marked as
- *     %LC_STARVING, blocking further lc_get() operations).
- *
- *  pointer to the element with the REQUESTED element number.
- *     In this case, it can be used right away
- *
- *  pointer to an UNUSED element with some different element number,
- *          where that different number may also be %LC_FREE.
- *
- *          In this case, the cache is marked %LC_DIRTY (blocking further changes),
- *          and the returned element pointer is removed from the lru list and
- *          hash collision chains.  The user now should do whatever housekeeping
- *          is necessary.
- *          Then he must call lc_changed(lc,element_pointer), to finish
- *          the change.
- *
- * NOTE: The user needs to check the lc_number on EACH use, so he recognizes
- *       any cache set change.
- */
-struct lc_element *lc_get(struct lru_cache *lc, unsigned int enr)
+static struct lc_element *__lc_get(struct lru_cache *lc, unsigned int enr, bool may_change)
 {
 	struct lc_element *e;
 
@@ -366,6 +328,8 @@ struct lc_element *lc_get(struct lru_cache *lc, unsigned int enr)
 	}
 
 	++lc->misses;
+	if (!may_change)
+		RETURN(NULL);
 
 	/* In case there is nothing available and we can not kick out
 	 * the LRU element, we have to wait ...
@@ -397,29 +361,67 @@ struct lc_element *lc_get(struct lru_cache *lc, unsigned int enr)
 	RETURN(e);
 }
 
-/* similar to lc_get,
- * but only gets a new reference on an existing element.
- * you either get the requested element, or NULL.
- * will be consolidated into one function.
+/**
+ * lc_get - get element by label, maybe change the active set
+ * @lc: the lru cache to operate on
+ * @enr: the label to look up
+ *
+ * Finds an element in the cache, increases its usage count,
+ * "touches" and returns it.
+ *
+ * In case the requested number is not present, it needs to be added to the
+ * cache. Therefore it is possible that an other element becomes evicted from
+ * the cache. In either case, the user is notified so he is able to e.g. keep
+ * a persistent log of the cache changes, and therefore the objects in use.
+ *
+ * Return values:
+ *  NULL
+ *     The cache was marked %LC_STARVING,
+ *     or the requested label was not in the active set
+ *     and a changing transaction is still pending (@lc was marked %LC_DIRTY).
+ *     Or no unused or free element could be recycled (@lc will be marked as
+ *     %LC_STARVING, blocking further lc_get() operations).
+ *
+ *  pointer to the element with the REQUESTED element number.
+ *     In this case, it can be used right away
+ *
+ *  pointer to an UNUSED element with some different element number,
+ *          where that different number may also be %LC_FREE.
+ *
+ *          In this case, the cache is marked %LC_DIRTY (blocking further changes),
+ *          and the returned element pointer is removed from the lru list and
+ *          hash collision chains.  The user now should do whatever housekeeping
+ *          is necessary.
+ *          Then he must call lc_changed(lc,element_pointer), to finish
+ *          the change.
+ *
+ * NOTE: The user needs to check the lc_number on EACH use, so he recognizes
+ *       any cache set change.
  */
-struct lc_element *lc_try_get(struct lru_cache *lc, unsigned int enr)
+struct lc_element *lc_get(struct lru_cache *lc, unsigned int enr)
 {
-	struct lc_element *e;
-
-	PARANOIA_ENTRY();
-	if (lc->flags & LC_STARVING) {
-		++lc->starving;
-		RETURN(NULL);
-	}
+	return __lc_get(lc, enr, 1);
+}
 
-	e = lc_find(lc, enr);
-	if (e) {
-		++lc->hits;
-		if (e->refcnt++ == 0)
-			lc->used++;
-		list_move(&e->list, &lc->in_use); /* Not evictable... */
-	}
-	RETURN(e);
+/**
+ * lc_try_get - get element by label, if present; do not change the active set
+ * @lc: the lru cache to operate on
+ * @enr: the label to look up
+ *
+ * Finds an element in the cache, increases its usage count,
+ * "touches" and returns it.
+ *
+ * Return values:
+ *  NULL
+ *     The cache was marked %LC_STARVING,
+ *     or the requested label was not in the active set
+ *
+ *  pointer to the element with the REQUESTED element number.
+ *     In this case, it can be used right away
+ */
+struct lc_element *lc_try_get(struct lru_cache *lc, unsigned int enr)
+{
+	return __lc_get(lc, enr, 0);
 }
 
 /**
-- 
1.7.4.1

