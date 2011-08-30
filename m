Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab1H3JGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 05:06:34 -0400
Received: from mail09.linbit.com ([212.69.161.110]:38292 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab1H3JF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 05:05:57 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 12/15] lru_cache: allow multiple changes per transaction
Date: Tue, 30 Aug 2011 11:05:46 +0200
Message-Id: <1314695149-387-13-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314695149-387-1-git-send-email-philipp.reisner@linbit.com>
References: <1314695149-387-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Allow multiple changes to the active set of elements in lru_cache.
The only current user of lru_cache, drbd, is driving this generalisation.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c |   50 ++------
 drivers/block/drbd/drbd_nl.c     |    4 +-
 include/linux/lru_cache.h        |   68 +++++++----
 lib/lru_cache.c                  |  243 ++++++++++++++++++++++++++------------
 4 files changed, 225 insertions(+), 140 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 1ce3de6..44097c8 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -175,7 +175,6 @@ static struct lc_element *_al_get(struct drbd_conf *mdev, unsigned int enr)
 {
 	struct lc_element *al_ext;
 	struct lc_element *tmp;
-	unsigned long     al_flags = 0;
 	int wake;
 
 	spin_lock_irq(&mdev->al_lock);
@@ -190,19 +189,8 @@ static struct lc_element *_al_get(struct drbd_conf *mdev, unsigned int enr)
 			return NULL;
 		}
 	}
-	al_ext   = lc_get(mdev->act_log, enr);
-	al_flags = mdev->act_log->flags;
+	al_ext = lc_get(mdev->act_log, enr);
 	spin_unlock_irq(&mdev->al_lock);
-
-	/*
-	if (!al_ext) {
-		if (al_flags & LC_STARVING)
-			dev_warn(DEV, "Have to wait for LRU element (AL too small?)\n");
-		if (al_flags & LC_DIRTY)
-			dev_warn(DEV, "Ongoing AL update (AL device too slow?)\n");
-	}
-	*/
-
 	return al_ext;
 }
 
@@ -235,7 +223,7 @@ void drbd_al_begin_io(struct drbd_conf *mdev, sector_t sector)
 		mdev->al_writ_cnt++;
 
 		spin_lock_irq(&mdev->al_lock);
-		lc_changed(mdev->act_log, al_ext);
+		lc_committed(mdev->act_log);
 		spin_unlock_irq(&mdev->al_lock);
 		wake_up(&mdev->al_wait);
 	}
@@ -601,7 +589,7 @@ void drbd_al_shrink(struct drbd_conf *mdev)
 	struct lc_element *al_ext;
 	int i;
 
-	D_ASSERT(test_bit(__LC_DIRTY, &mdev->act_log->flags));
+	D_ASSERT(test_bit(__LC_LOCKED, &mdev->act_log->flags));
 
 	for (i = 0; i < mdev->act_log->nr_elements; i++) {
 		al_ext = lc_element_by_index(mdev->act_log, i);
@@ -708,7 +696,9 @@ static void drbd_try_clear_on_disk_bm(struct drbd_conf *mdev, sector_t sector,
 			}
 			ext->rs_left = rs_left;
 			ext->rs_failed = success ? 0 : count;
-			lc_changed(mdev->resync, &ext->lce);
+			/* we don't keep a persistent log of the resync lru,
+			 * we can commit any change right away. */
+			lc_committed(mdev->resync);
 		}
 		lc_put(mdev->resync, &ext->lce);
 		/* no race, we are within the al_lock! */
@@ -892,7 +882,7 @@ struct bm_extent *_bme_get(struct drbd_conf *mdev, unsigned int enr)
 		if (bm_ext->lce.lc_number != enr) {
 			bm_ext->rs_left = drbd_bm_e_weight(mdev, enr);
 			bm_ext->rs_failed = 0;
-			lc_changed(mdev->resync, &bm_ext->lce);
+			lc_committed(mdev->resync);
 			wakeup = 1;
 		}
 		if (bm_ext->lce.refcnt == 1)
@@ -908,7 +898,7 @@ struct bm_extent *_bme_get(struct drbd_conf *mdev, unsigned int enr)
 		if (rs_flags & LC_STARVING)
 			dev_warn(DEV, "Have to wait for element"
 			     " (resync LRU too small?)\n");
-		BUG_ON(rs_flags & LC_DIRTY);
+		BUG_ON(rs_flags & LC_LOCKED);
 	}
 
 	return bm_ext;
@@ -916,26 +906,12 @@ struct bm_extent *_bme_get(struct drbd_conf *mdev, unsigned int enr)
 
 static int _is_in_al(struct drbd_conf *mdev, unsigned int enr)
 {
-	struct lc_element *al_ext;
-	int rv = 0;
+	int rv;
 
 	spin_lock_irq(&mdev->al_lock);
-	if (unlikely(enr == mdev->act_log->new_number))
-		rv = 1;
-	else {
-		al_ext = lc_find(mdev->act_log, enr);
-		if (al_ext) {
-			if (al_ext->refcnt)
-				rv = 1;
-		}
-	}
+	rv = lc_is_used(mdev->act_log, enr);
 	spin_unlock_irq(&mdev->al_lock);
 
-	/*
-	if (unlikely(rv)) {
-		dev_info(DEV, "Delaying sync read until app's write is done\n");
-	}
-	*/
 	return rv;
 }
 
@@ -1065,13 +1041,13 @@ int drbd_try_rs_begin_io(struct drbd_conf *mdev, sector_t sector)
 			if (rs_flags & LC_STARVING)
 				dev_warn(DEV, "Have to wait for element"
 				     " (resync LRU too small?)\n");
-			BUG_ON(rs_flags & LC_DIRTY);
+			BUG_ON(rs_flags & LC_LOCKED);
 			goto try_again;
 		}
 		if (bm_ext->lce.lc_number != enr) {
 			bm_ext->rs_left = drbd_bm_e_weight(mdev, enr);
 			bm_ext->rs_failed = 0;
-			lc_changed(mdev->resync, &bm_ext->lce);
+			lc_committed(mdev->resync);
 			wake_up(&mdev->al_wait);
 			D_ASSERT(test_bit(BME_LOCKED, &bm_ext->flags) == 0);
 		}
@@ -1082,8 +1058,6 @@ int drbd_try_rs_begin_io(struct drbd_conf *mdev, sector_t sector)
 	}
 check_al:
 	for (i = 0; i < AL_EXT_PER_BM_SECT; i++) {
-		if (unlikely(al_enr+i == mdev->act_log->new_number))
-			goto try_again;
 		if (lc_is_used(mdev->act_log, al_enr+i))
 			goto try_again;
 	}
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index ae8f42e..0a92f52 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -760,7 +760,7 @@ static int drbd_check_al_size(struct drbd_conf *mdev)
 
 	in_use = 0;
 	t = mdev->act_log;
-	n = lc_create("act_log", drbd_al_ext_cache,
+	n = lc_create("act_log", drbd_al_ext_cache, 1,
 		mdev->sync_conf.al_extents, sizeof(struct lc_element), 0);
 
 	if (n == NULL) {
@@ -1016,7 +1016,7 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 	}
 
 	resync_lru = lc_create("resync", drbd_bm_ext_cache,
-			61, sizeof(struct bm_extent),
+			1, 61, sizeof(struct bm_extent),
 			offsetof(struct bm_extent, lce));
 	if (!resync_lru) {
 		retcode = ERR_NOMEM;
diff --git a/include/linux/lru_cache.h b/include/linux/lru_cache.h
index 4cceafb..cbafae4 100644
--- a/include/linux/lru_cache.h
+++ b/include/linux/lru_cache.h
@@ -166,9 +166,11 @@ struct lc_element {
 	/* if we want to track a larger set of objects,
 	 * it needs to become arch independend u64 */
 	unsigned lc_number;
-
 	/* special label when on free list */
 #define LC_FREE (~0U)
+
+	/* for pending changes */
+	unsigned lc_new_number;
 };
 
 struct lru_cache {
@@ -176,6 +178,7 @@ struct lru_cache {
 	struct list_head lru;
 	struct list_head free;
 	struct list_head in_use;
+	struct list_head to_be_changed;
 
 	/* the pre-created kmem cache to allocate the objects from */
 	struct kmem_cache *lc_cache;
@@ -186,7 +189,7 @@ struct lru_cache {
 	size_t element_off;
 
 	/* number of elements (indices) */
-	unsigned int  nr_elements;
+	unsigned int nr_elements;
 	/* Arbitrary limit on maximum tracked objects. Practical limit is much
 	 * lower due to allocation failures, probably. For typical use cases,
 	 * nr_elements should be a few thousand at most.
@@ -194,18 +197,19 @@ struct lru_cache {
 	 * 8 high bits of .lc_index to be overloaded with flags in the future. */
 #define LC_MAX_ACTIVE	(1<<24)
 
+	/* allow to accumulate a few (index:label) changes,
+	 * but no more than max_pending_changes */
+	unsigned int max_pending_changes;
+	/* number of elements currently on to_be_changed list */
+	unsigned int pending_changes;
+
 	/* statistics */
-	unsigned used; /* number of lelements currently on in_use list */
-	unsigned long hits, misses, starving, dirty, changed;
+	unsigned used; /* number of elements currently on in_use list */
+	unsigned long hits, misses, starving, locked, changed;
 
 	/* see below: flag-bits for lru_cache */
 	unsigned long flags;
 
-	/* when changing the label of an index element */
-	unsigned int  new_number;
-
-	/* for paranoia when changing the label of an index element */
-	struct lc_element *changing_element;
 
 	void  *lc_private;
 	const char *name;
@@ -221,10 +225,15 @@ enum {
 	/* debugging aid, to catch concurrent access early.
 	 * user needs to guarantee exclusive access by proper locking! */
 	__LC_PARANOIA,
-	/* if we need to change the set, but currently there is a changing
-	 * transaction pending, we are "dirty", and must deferr further
-	 * changing requests */
+
+	/* annotate that the set is "dirty", possibly accumulating further
+	 * changes, until a transaction is finally triggered */
 	__LC_DIRTY,
+
+	/* Locked, no further changes allowed.
+	 * Also used to serialize changing transactions. */
+	__LC_LOCKED,
+
 	/* if we need to change the set, but currently there is no free nor
 	 * unused element available, we are "starving", and must not give out
 	 * further references, to guarantee that eventually some refcnt will
@@ -236,9 +245,11 @@ enum {
 };
 #define LC_PARANOIA (1<<__LC_PARANOIA)
 #define LC_DIRTY    (1<<__LC_DIRTY)
+#define LC_LOCKED   (1<<__LC_LOCKED)
 #define LC_STARVING (1<<__LC_STARVING)
 
 extern struct lru_cache *lc_create(const char *name, struct kmem_cache *cache,
+		unsigned max_pending_changes,
 		unsigned e_count, size_t e_size, size_t e_off);
 extern void lc_reset(struct lru_cache *lc);
 extern void lc_destroy(struct lru_cache *lc);
@@ -249,7 +260,7 @@ extern struct lc_element *lc_try_get(struct lru_cache *lc, unsigned int enr);
 extern struct lc_element *lc_find(struct lru_cache *lc, unsigned int enr);
 extern struct lc_element *lc_get(struct lru_cache *lc, unsigned int enr);
 extern unsigned int lc_put(struct lru_cache *lc, struct lc_element *e);
-extern void lc_changed(struct lru_cache *lc, struct lc_element *e);
+extern void lc_committed(struct lru_cache *lc);
 
 struct seq_file;
 extern size_t lc_seq_printf_stats(struct seq_file *seq, struct lru_cache *lc);
@@ -258,31 +269,40 @@ extern void lc_seq_dump_details(struct seq_file *seq, struct lru_cache *lc, char
 				void (*detail) (struct seq_file *, struct lc_element *));
 
 /**
- * lc_try_lock - can be used to stop lc_get() from changing the tracked set
+ * lc_try_lock_for_transaction - can be used to stop lc_get() from changing the tracked set
  * @lc: the lru cache to operate on
  *
- * Note that the reference counts and order on the active and lru lists may
- * still change.  Returns true if we acquired the lock.
+ * Allows (expects) the set to be "dirty".  Note that the reference counts and
+ * order on the active and lru lists may still change.  Used to serialize
+ * changing transactions.  Returns true if we aquired the lock.
  */
-static inline int lc_try_lock(struct lru_cache *lc)
+static inline int lc_try_lock_for_transaction(struct lru_cache *lc)
 {
-	return !test_and_set_bit(__LC_DIRTY, &lc->flags);
+	return !test_and_set_bit(__LC_LOCKED, &lc->flags);
 }
 
 /**
+ * lc_try_lock - variant to stop lc_get() from changing the tracked set
+ * @lc: the lru cache to operate on
+ *
+ * Note that the reference counts and order on the active and lru lists may
+ * still change.  Only works on a "clean" set.  Returns true if we aquired the
+ * lock, which means there are no pending changes, and any further attempt to
+ * change the set will not succeed until the next lc_unlock().
+ */
+extern int lc_try_lock(struct lru_cache *lc);
+
+/**
  * lc_unlock - unlock @lc, allow lc_get() to change the set again
  * @lc: the lru cache to operate on
  */
 static inline void lc_unlock(struct lru_cache *lc)
 {
-	clear_bit_unlock(__LC_DIRTY, &lc->flags);
+	clear_bit(__LC_DIRTY, &lc->flags);
+	clear_bit_unlock(__LC_LOCKED, &lc->flags);
 }
 
-static inline int lc_is_used(struct lru_cache *lc, unsigned int enr)
-{
-	struct lc_element *e = lc_find(lc, enr);
-	return e && e->refcnt;
-}
+extern bool lc_is_used(struct lru_cache *lc, unsigned int enr);
 
 #define lc_entry(ptr, type, member) \
 	container_of(ptr, type, member)
diff --git a/lib/lru_cache.c b/lib/lru_cache.c
index 1762168..d71d894 100644
--- a/lib/lru_cache.c
+++ b/lib/lru_cache.c
@@ -55,9 +55,40 @@ MODULE_LICENSE("GPL");
 	BUG_ON(i >= lc_->nr_elements);	\
 	BUG_ON(lc_->lc_element[i] != e_); } while (0)
 
+
+/* We need to atomically
+ *  - try to grab the lock (set LC_LOCKED)
+ *  - only if there is no pending transaction
+ *    (neither LC_DIRTY nor LC_STARVING is set)
+ * Because of PARANOIA_ENTRY() above abusing lc->flags as well,
+ * it is not sufficient to just say
+ *	return 0 == cmpxchg(&lc->flags, 0, LC_LOCKED);
+ */
+int lc_try_lock(struct lru_cache *lc)
+{
+	unsigned long val;
+	do {
+		val = cmpxchg(&lc->flags, 0, LC_LOCKED);
+	} while (unlikely (val == LC_PARANOIA));
+	/* Spin until no-one is inside a PARANOIA_ENTRY()/RETURN() section. */
+	return 0 == val;
+#if 0
+	/* Alternative approach, spin in case someone enters or leaves a
+	 * PARANOIA_ENTRY()/RETURN() section. */
+	unsigned long old, new, val;
+	do {
+		old = lc->flags & LC_PARANOIA;
+		new = old | LC_LOCKED;
+		val = cmpxchg(&lc->flags, old, new);
+	} while (unlikely (val == (old ^ LC_PARANOIA)));
+	return old == val;
+#endif
+}
+
 /**
  * lc_create - prepares to track objects in an active set
  * @name: descriptive name only used in lc_seq_printf_stats and lc_seq_dump_details
+ * @max_pending_changes: maximum changes to accumulate until a transaction is required
  * @e_count: number of elements allowed to be active simultaneously
  * @e_size: size of the tracked objects
  * @e_off: offset to the &struct lc_element member in a tracked object
@@ -66,6 +97,7 @@ MODULE_LICENSE("GPL");
  * or NULL on (allocation) failure.
  */
 struct lru_cache *lc_create(const char *name, struct kmem_cache *cache,
+		unsigned max_pending_changes,
 		unsigned e_count, size_t e_size, size_t e_off)
 {
 	struct hlist_head *slot = NULL;
@@ -98,12 +130,13 @@ struct lru_cache *lc_create(const char *name, struct kmem_cache *cache,
 	INIT_LIST_HEAD(&lc->in_use);
 	INIT_LIST_HEAD(&lc->lru);
 	INIT_LIST_HEAD(&lc->free);
+	INIT_LIST_HEAD(&lc->to_be_changed);
 
 	lc->name = name;
 	lc->element_size = e_size;
 	lc->element_off = e_off;
 	lc->nr_elements = e_count;
-	lc->new_number = LC_FREE;
+	lc->max_pending_changes = max_pending_changes;
 	lc->lc_cache = cache;
 	lc->lc_element = element;
 	lc->lc_slot = slot;
@@ -117,6 +150,7 @@ struct lru_cache *lc_create(const char *name, struct kmem_cache *cache,
 		e = p + e_off;
 		e->lc_index = i;
 		e->lc_number = LC_FREE;
+		e->lc_new_number = LC_FREE;
 		list_add(&e->list, &lc->free);
 		element[i] = e;
 	}
@@ -175,15 +209,15 @@ void lc_reset(struct lru_cache *lc)
 	INIT_LIST_HEAD(&lc->in_use);
 	INIT_LIST_HEAD(&lc->lru);
 	INIT_LIST_HEAD(&lc->free);
+	INIT_LIST_HEAD(&lc->to_be_changed);
 	lc->used = 0;
 	lc->hits = 0;
 	lc->misses = 0;
 	lc->starving = 0;
-	lc->dirty = 0;
+	lc->locked = 0;
 	lc->changed = 0;
+	lc->pending_changes = 0;
 	lc->flags = 0;
-	lc->changing_element = NULL;
-	lc->new_number = LC_FREE;
 	memset(lc->lc_slot, 0, sizeof(struct hlist_head) * lc->nr_elements);
 
 	for (i = 0; i < lc->nr_elements; i++) {
@@ -194,6 +228,7 @@ void lc_reset(struct lru_cache *lc)
 		/* re-init it */
 		e->lc_index = i;
 		e->lc_number = LC_FREE;
+		e->lc_new_number = LC_FREE;
 		list_add(&e->list, &lc->free);
 	}
 }
@@ -208,14 +243,14 @@ size_t lc_seq_printf_stats(struct seq_file *seq, struct lru_cache *lc)
 	/* NOTE:
 	 * total calls to lc_get are
 	 * (starving + hits + misses)
-	 * misses include "dirty" count (update from an other thread in
+	 * misses include "locked" count (update from an other thread in
 	 * progress) and "changed", when this in fact lead to an successful
 	 * update of the cache.
 	 */
 	return seq_printf(seq, "\t%s: used:%u/%u "
-		"hits:%lu misses:%lu starving:%lu dirty:%lu changed:%lu\n",
+		"hits:%lu misses:%lu starving:%lu locked:%lu changed:%lu\n",
 		lc->name, lc->used, lc->nr_elements,
-		lc->hits, lc->misses, lc->starving, lc->dirty, lc->changed);
+		lc->hits, lc->misses, lc->starving, lc->locked, lc->changed);
 }
 
 static struct hlist_head *lc_hash_slot(struct lru_cache *lc, unsigned int enr)
@@ -224,16 +259,8 @@ static struct hlist_head *lc_hash_slot(struct lru_cache *lc, unsigned int enr)
 }
 
 
-/**
- * lc_find - find element by label, if present in the hash table
- * @lc: The lru_cache object
- * @enr: element number
- *
- * Returns the pointer to an element, if the element with the requested
- * "label" or element number is present in the hash table,
- * or NULL if not found. Does not change the refcnt.
- */
-struct lc_element *lc_find(struct lru_cache *lc, unsigned int enr)
+static struct lc_element *__lc_find(struct lru_cache *lc, unsigned int enr,
+		bool include_changing)
 {
 	struct hlist_node *n;
 	struct lc_element *e;
@@ -241,29 +268,48 @@ struct lc_element *lc_find(struct lru_cache *lc, unsigned int enr)
 	BUG_ON(!lc);
 	BUG_ON(!lc->nr_elements);
 	hlist_for_each_entry(e, n, lc_hash_slot(lc, enr), colision) {
-		if (e->lc_number == enr)
+		/* "about to be changed" elements, pending transaction commit,
+		 * are hashed by their "new number". "Normal" elements have
+		 * lc_number == lc_new_number. */
+		if (e->lc_new_number != enr)
+			continue;
+		if (e->lc_new_number == e->lc_number || include_changing)
 			return e;
+		break;
 	}
 	return NULL;
 }
 
-/* returned element will be "recycled" immediately */
-static struct lc_element *lc_evict(struct lru_cache *lc)
+/**
+ * lc_find - find element by label, if present in the hash table
+ * @lc: The lru_cache object
+ * @enr: element number
+ *
+ * Returns the pointer to an element, if the element with the requested
+ * "label" or element number is present in the hash table,
+ * or NULL if not found. Does not change the refcnt.
+ * Ignores elements that are "about to be used", i.e. not yet in the active
+ * set, but still pending transaction commit.
+ */
+struct lc_element *lc_find(struct lru_cache *lc, unsigned int enr)
 {
-	struct list_head  *n;
-	struct lc_element *e;
-
-	if (list_empty(&lc->lru))
-		return NULL;
-
-	n = lc->lru.prev;
-	e = list_entry(n, struct lc_element, list);
-
-	PARANOIA_LC_ELEMENT(lc, e);
+	return __lc_find(lc, enr, 0);
+}
 
-	list_del(&e->list);
-	hlist_del(&e->colision);
-	return e;
+/**
+ * lc_is_used - find element by label
+ * @lc: The lru_cache object
+ * @enr: element number
+ *
+ * Returns true, if the element with the requested "label" or element number is
+ * present in the hash table, and is used (refcnt > 0).
+ * Also finds elements that are not _currently_ used but only "about to be
+ * used", i.e. on the "to_be_changed" list, pending transaction commit.
+ */
+bool lc_is_used(struct lru_cache *lc, unsigned int enr)
+{
+	struct lc_element *e = __lc_find(lc, enr, 1);
+	return e && e->refcnt;
 }
 
 /**
@@ -280,22 +326,34 @@ void lc_del(struct lru_cache *lc, struct lc_element *e)
 	PARANOIA_LC_ELEMENT(lc, e);
 	BUG_ON(e->refcnt);
 
-	e->lc_number = LC_FREE;
+	e->lc_number = e->lc_new_number = LC_FREE;
 	hlist_del_init(&e->colision);
 	list_move(&e->list, &lc->free);
 	RETURN();
 }
 
-static struct lc_element *lc_get_unused_element(struct lru_cache *lc)
+static struct lc_element *lc_prepare_for_change(struct lru_cache *lc, unsigned new_number)
 {
 	struct list_head *n;
+	struct lc_element *e;
+
+	if (!list_empty(&lc->free))
+		n = lc->free.next;
+	else if (!list_empty(&lc->lru))
+		n = lc->lru.prev;
+	else
+		return NULL;
+
+	e = list_entry(n, struct lc_element, list);
+	PARANOIA_LC_ELEMENT(lc, e);
 
-	if (list_empty(&lc->free))
-		return lc_evict(lc);
+	e->lc_new_number = new_number;
+	if (!hlist_unhashed(&e->colision))
+		__hlist_del(&e->colision);
+	hlist_add_head(&e->colision, lc_hash_slot(lc, new_number));
+	list_move(&e->list, &lc->to_be_changed);
 
-	n = lc->free.next;
-	list_del(n);
-	return list_entry(n, struct lc_element, list);
+	return e;
 }
 
 static int lc_unused_element_available(struct lru_cache *lc)
@@ -318,8 +376,12 @@ static struct lc_element *__lc_get(struct lru_cache *lc, unsigned int enr, bool
 		RETURN(NULL);
 	}
 
-	e = lc_find(lc, enr);
-	if (e) {
+	e = __lc_find(lc, enr, 1);
+	/* if lc_new_number != lc_number,
+	 * this enr is currently being pulled in already,
+	 * and will be available once the pending transaction
+	 * has been committed. */
+	if (e && e->lc_new_number == e->lc_number) {
 		++lc->hits;
 		if (e->refcnt++ == 0)
 			lc->used++;
@@ -331,6 +393,24 @@ static struct lc_element *__lc_get(struct lru_cache *lc, unsigned int enr, bool
 	if (!may_change)
 		RETURN(NULL);
 
+	/* It has been found above, but on the "to_be_changed" list, not yet
+	 * committed.  Don't pull it in twice, wait for the transaction, then
+	 * try again */
+	if (e)
+		RETURN(NULL);
+
+	/* To avoid races with lc_try_lock(), first, mark us dirty
+	 * (using test_and_set_bit, as it implies memory barriers), ... */
+	test_and_set_bit(__LC_DIRTY, &lc->flags);
+
+	/* ... only then check if it is locked anyways. If lc_unlock clears
+	 * the dirty bit again, that's not a problem, we will come here again.
+	 */
+	if (test_bit(__LC_LOCKED, &lc->flags)) {
+		++lc->locked;
+		RETURN(NULL);
+	}
+
 	/* In case there is nothing available and we can not kick out
 	 * the LRU element, we have to wait ...
 	 */
@@ -339,24 +419,19 @@ static struct lc_element *__lc_get(struct lru_cache *lc, unsigned int enr, bool
 		RETURN(NULL);
 	}
 
-	/* it was not present in the active set.
-	 * we are going to recycle an unused (or even "free") element.
-	 * user may need to commit a transaction to record that change.
-	 * we serialize on flags & LC_DIRTY */
-	if (test_and_set_bit(__LC_DIRTY, &lc->flags)) {
-		++lc->dirty;
+	/* It was not present in the active set.  We are going to recycle an
+	 * unused (or even "free") element, but we won't accumulate more than
+	 * max_pending_changes changes.  */
+	if (lc->pending_changes >= lc->max_pending_changes)
 		RETURN(NULL);
-	}
 
-	e = lc_get_unused_element(lc);
+	e = lc_prepare_for_change(lc, enr);
 	BUG_ON(!e);
 
 	clear_bit(__LC_STARVING, &lc->flags);
 	BUG_ON(++e->refcnt != 1);
 	lc->used++;
-
-	lc->changing_element = e;
-	lc->new_number = enr;
+	lc->pending_changes++;
 
 	RETURN(e);
 }
@@ -388,12 +463,15 @@ static struct lc_element *__lc_get(struct lru_cache *lc, unsigned int enr, bool
  *  pointer to an UNUSED element with some different element number,
  *          where that different number may also be %LC_FREE.
  *
- *          In this case, the cache is marked %LC_DIRTY (blocking further changes),
- *          and the returned element pointer is removed from the lru list and
- *          hash collision chains.  The user now should do whatever housekeeping
- *          is necessary.
- *          Then he must call lc_changed(lc,element_pointer), to finish
- *          the change.
+ *          In this case, the cache is marked %LC_DIRTY,
+ *          so lc_try_lock() will no longer succeed.
+ *          The returned element pointer is moved to the "to_be_changed" list,
+ *          and registered with the new element number on the hash collision chains,
+ *          so it is possible to pick it up from lc_is_used().
+ *          Up to "max_pending_changes" (see lc_create()) can be accumulated.
+ *          The user now should do whatever housekeeping is necessary,
+ *          typically serialize on lc_try_lock_for_transaction(), then call
+ *          lc_committed(lc) and lc_unlock(), to finish the change.
  *
  * NOTE: The user needs to check the lc_number on EACH use, so he recognizes
  *       any cache set change.
@@ -425,22 +503,25 @@ struct lc_element *lc_try_get(struct lru_cache *lc, unsigned int enr)
 }
 
 /**
- * lc_changed - tell @lc that the change has been recorded
+ * lc_committed - tell @lc that pending changes have been recorded
  * @lc: the lru cache to operate on
- * @e: the element pending label change
+ *
+ * User is expected to serialize on explicit lc_try_lock_for_transaction()
+ * before the transaction is started, and later needs to lc_unlock() explicitly
+ * as well.
  */
-void lc_changed(struct lru_cache *lc, struct lc_element *e)
+void lc_committed(struct lru_cache *lc)
 {
+	struct lc_element *e, *tmp;
+
 	PARANOIA_ENTRY();
-	BUG_ON(e != lc->changing_element);
-	PARANOIA_LC_ELEMENT(lc, e);
-	++lc->changed;
-	e->lc_number = lc->new_number;
-	list_add(&e->list, &lc->in_use);
-	hlist_add_head(&e->colision, lc_hash_slot(lc, lc->new_number));
-	lc->changing_element = NULL;
-	lc->new_number = LC_FREE;
-	clear_bit_unlock(__LC_DIRTY, &lc->flags);
+	list_for_each_entry_safe(e, tmp, &lc->to_be_changed, list) {
+		/* count number of changes, not number of transactions */
+		++lc->changed;
+		e->lc_number = e->lc_new_number;
+		list_move(&e->list, &lc->in_use);
+	}
+	lc->pending_changes = 0;
 	RETURN();
 }
 
@@ -459,7 +540,7 @@ unsigned int lc_put(struct lru_cache *lc, struct lc_element *e)
 	PARANOIA_ENTRY();
 	PARANOIA_LC_ELEMENT(lc, e);
 	BUG_ON(e->refcnt == 0);
-	BUG_ON(e == lc->changing_element);
+	BUG_ON(e->lc_number != e->lc_new_number);
 	if (--e->refcnt == 0) {
 		/* move it to the front of LRU. */
 		list_move(&e->list, &lc->lru);
@@ -504,16 +585,24 @@ unsigned int lc_index_of(struct lru_cache *lc, struct lc_element *e)
 void lc_set(struct lru_cache *lc, unsigned int enr, int index)
 {
 	struct lc_element *e;
+	struct list_head *lh;
 
 	if (index < 0 || index >= lc->nr_elements)
 		return;
 
 	e = lc_element_by_index(lc, index);
-	e->lc_number = enr;
+	BUG_ON(e->lc_number != e->lc_new_number);
+	BUG_ON(e->refcnt != 0);
 
+	e->lc_number = e->lc_new_number = enr;
 	hlist_del_init(&e->colision);
-	hlist_add_head(&e->colision, lc_hash_slot(lc, enr));
-	list_move(&e->list, e->refcnt ? &lc->in_use : &lc->lru);
+	if (enr == LC_FREE)
+		lh = &lc->free;
+	else {
+		hlist_add_head(&e->colision, lc_hash_slot(lc, enr));
+		lh = &lc->lru;
+	}
+	list_move(&e->list, lh);
 }
 
 /**
@@ -553,8 +642,10 @@ EXPORT_SYMBOL(lc_try_get);
 EXPORT_SYMBOL(lc_find);
 EXPORT_SYMBOL(lc_get);
 EXPORT_SYMBOL(lc_put);
-EXPORT_SYMBOL(lc_changed);
+EXPORT_SYMBOL(lc_committed);
 EXPORT_SYMBOL(lc_element_by_index);
 EXPORT_SYMBOL(lc_index_of);
 EXPORT_SYMBOL(lc_seq_printf_stats);
 EXPORT_SYMBOL(lc_seq_dump_details);
+EXPORT_SYMBOL(lc_try_lock);
+EXPORT_SYMBOL(lc_is_used);
-- 
1.7.4.1

