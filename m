Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab2IZPwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 11:52:18 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47842 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756939Ab2IZPwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 11:52:13 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Heinz.Egger@linutronix.de, artem.bityutskiy@linux.intel.com,
        tim.bird@am.sony.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 08/10] UBI: Add fastmap support to the WL sub-system
Date: Wed, 26 Sep 2012 17:51:48 +0200
Message-Id: <1348674710-102885-9-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1348674710-102885-1-git-send-email-richard@nod.at>
References: <1348674710-102885-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make fastmap possible the WL sub-system needs some
changes.
Mostly to support fastmaps pools.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/wl.c |  575 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 531 insertions(+), 44 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index f4d06db..da7b449 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -141,6 +141,42 @@ static int self_check_in_wl_tree(const struct ubi_device *ubi,
 static int self_check_in_pq(const struct ubi_device *ubi,
 			    struct ubi_wl_entry *e);
 
+#ifdef CONFIG_MTD_UBI_FASTMAP
+/**
+ * update_fastmap_work_fn - calls ubi_update_fastmap from a work queue
+ * @wrk: the work description object
+ */
+static void update_fastmap_work_fn(struct work_struct *wrk)
+{
+	struct ubi_device *ubi = container_of(wrk, struct ubi_device, fm_work);
+	ubi_update_fastmap(ubi);
+}
+
+/**
+ *  ubi_ubi_is_fm_block - returns 1 if a PEB is currently used in a fastmap.
+ *  @ubi: UBI device description object
+ *  @pnum: the to be checked PEB
+ */
+static int ubi_is_fm_block(struct ubi_device *ubi, int pnum)
+{
+	int i;
+
+	if (!ubi->fm)
+		return 0;
+
+	for (i = 0; i < ubi->fm->used_blocks; i++)
+		if (ubi->fm->e[i]->pnum == pnum)
+			return 1;
+
+	return 0;
+}
+#else
+static int ubi_is_fm_block(struct ubi_device *ubi, int pnum)
+{
+	return 0;
+}
+#endif
+
 /**
  * wl_tree_add - add a wear-leveling entry to a WL RB-tree.
  * @e: the wear-leveling entry to add
@@ -237,18 +273,16 @@ static int produce_free_peb(struct ubi_device *ubi)
 {
 	int err;
 
-	spin_lock(&ubi->wl_lock);
 	while (!ubi->free.rb_node) {
 		spin_unlock(&ubi->wl_lock);
 
 		dbg_wl("do one work synchronously");
 		err = do_work(ubi);
-		if (err)
-			return err;
 
 		spin_lock(&ubi->wl_lock);
+		if (err)
+			return err;
 	}
-	spin_unlock(&ubi->wl_lock);
 
 	return 0;
 }
@@ -315,16 +349,18 @@ static void prot_queue_add(struct ubi_device *ubi, struct ubi_wl_entry *e)
 
 /**
  * find_wl_entry - find wear-leveling entry closest to certain erase counter.
+ * @ubi: UBI device description object
  * @root: the RB-tree where to look for
  * @diff: maximum possible difference from the smallest erase counter
  *
  * This function looks for a wear leveling entry with erase counter closest to
  * min + @diff, where min is the smallest erase counter.
  */
-static struct ubi_wl_entry *find_wl_entry(struct rb_root *root, int diff)
+static struct ubi_wl_entry *find_wl_entry(struct ubi_device *ubi,
+					  struct rb_root *root, int diff)
 {
 	struct rb_node *p;
-	struct ubi_wl_entry *e;
+	struct ubi_wl_entry *e, *prev_e = NULL;
 	int max;
 
 	e = rb_entry(rb_first(root), struct ubi_wl_entry, u.rb);
@@ -339,35 +375,143 @@ static struct ubi_wl_entry *find_wl_entry(struct rb_root *root, int diff)
 			p = p->rb_left;
 		else {
 			p = p->rb_right;
+			prev_e = e;
 			e = e1;
 		}
 	}
 
+	/* If no fastmap has been written and this WL entry can be used
+	 * as anchor PEB, hold it back and return the second best WL entry
+	 * such that fastmap can use the anchor PEB later. */
+	if (prev_e && !ubi->fm_disabled &&
+	    !ubi->fm && e->pnum < UBI_FM_MAX_START)
+		return prev_e;
+
 	return e;
 }
 
 /**
- * ubi_wl_get_peb - get a physical eraseblock.
+ * find_mean_wl_entry - find wear-leveling entry with medium erase counter.
+ * @ubi: UBI device description object
+ * @root: the RB-tree where to look for
+ *
+ * This function looks for a wear leveling entry with medium erase counter,
+ * but not greater or equivalent than the lowest erase counter plus
+ * %WL_FREE_MAX_DIFF/2.
+ */
+static struct ubi_wl_entry *find_mean_wl_entry(struct ubi_device *ubi,
+					       struct rb_root *root)
+{
+	struct ubi_wl_entry *e, *first, *last;
+
+	first = rb_entry(rb_first(root), struct ubi_wl_entry, u.rb);
+	last = rb_entry(rb_last(root), struct ubi_wl_entry, u.rb);
+
+	if (last->ec - first->ec < WL_FREE_MAX_DIFF) {
+		e = rb_entry(root->rb_node, struct ubi_wl_entry, u.rb);
+
+#ifdef CONFIG_MTD_UBI_FASTMAP
+		/* If no fastmap has been written and this WL entry can be used
+		 * as anchor PEB, hold it back and return the second best
+		 * WL entry such that fastmap can use the anchor PEB later. */
+		if (e && !ubi->fm_disabled && !ubi->fm &&
+		    e->pnum < UBI_FM_MAX_START)
+			e = rb_entry(rb_next(root->rb_node),
+				     struct ubi_wl_entry, u.rb);
+#endif
+	} else
+		e = find_wl_entry(ubi, root, WL_FREE_MAX_DIFF/2);
+
+	return e;
+}
+
+#ifdef CONFIG_MTD_UBI_FASTMAP
+/**
+ * find_anchor_wl_entry - find wear-leveling entry to used as anchor PEB.
+ * @root: the RB-tree where to look for
+ */
+static struct ubi_wl_entry *find_anchor_wl_entry(struct rb_root *root)
+{
+	struct rb_node *p;
+	struct ubi_wl_entry *e, *victim = NULL;
+	int max_ec = UBI_MAX_ERASECOUNTER;
+
+	ubi_rb_for_each_entry(p, e, root, u.rb) {
+		if (e->pnum < UBI_FM_MAX_START && e->ec < max_ec) {
+			victim = e;
+			max_ec = e->ec;
+		}
+	}
+
+	return victim;
+}
+
+static int anchor_pebs_avalible(struct rb_root *root)
+{
+	struct rb_node *p;
+	struct ubi_wl_entry *e;
+
+	ubi_rb_for_each_entry(p, e, root, u.rb)
+		if (e->pnum < UBI_FM_MAX_START)
+			return 1;
+
+	return 0;
+}
+
+/**
+ * ubi_wl_get_fm_peb - find a physical erase block with a given maximal number.
+ * @ubi: UBI device description object
+ * @anchor: This PEB will be used as anchor PEB by fastmap
+ *
+ * The function returns a physical erase block with a given maximal number
+ * and removes it from the wl subsystem.
+ * Must be called with wl_lock held!
+ */
+struct ubi_wl_entry *ubi_wl_get_fm_peb(struct ubi_device *ubi, int anchor)
+{
+	struct ubi_wl_entry *e = NULL;
+
+	if (!ubi->free.rb_node || (ubi->free_count - ubi->beb_rsvd_pebs < 1))
+		goto out;
+
+	if (anchor)
+		e = find_anchor_wl_entry(&ubi->free);
+	else
+		e = find_mean_wl_entry(ubi, &ubi->free);
+
+	if (!e)
+		goto out;
+
+	self_check_in_wl_tree(ubi, e, &ubi->free);
+
+	/* remove it from the free list,
+	 * the wl subsystem does no longer know this erase block */
+	rb_erase(&e->u.rb, &ubi->free);
+	ubi->free_count--;
+out:
+	return e;
+}
+#endif
+
+/**
+ * __wl_get_peb - get a physical eraseblock.
  * @ubi: UBI device description object
  *
  * This function returns a physical eraseblock in case of success and a
  * negative error code in case of failure. Might sleep.
  */
-int ubi_wl_get_peb(struct ubi_device *ubi)
+static int __wl_get_peb(struct ubi_device *ubi)
 {
 	int err;
-	struct ubi_wl_entry *e, *first, *last;
+	struct ubi_wl_entry *e;
 
 retry:
-	spin_lock(&ubi->wl_lock);
 	if (!ubi->free.rb_node) {
 		if (ubi->works_count == 0) {
-			ubi_assert(list_empty(&ubi->works));
 			ubi_err("no free eraseblocks");
-			spin_unlock(&ubi->wl_lock);
+			ubi_assert(list_empty(&ubi->works));
 			return -ENOSPC;
 		}
-		spin_unlock(&ubi->wl_lock);
 
 		err = produce_free_peb(ubi);
 		if (err < 0)
@@ -375,13 +519,11 @@ retry:
 		goto retry;
 	}
 
-	first = rb_entry(rb_first(&ubi->free), struct ubi_wl_entry, u.rb);
-	last = rb_entry(rb_last(&ubi->free), struct ubi_wl_entry, u.rb);
-
-	if (last->ec - first->ec < WL_FREE_MAX_DIFF)
-		e = rb_entry(ubi->free.rb_node, struct ubi_wl_entry, u.rb);
-	else
-		e = find_wl_entry(&ubi->free, WL_FREE_MAX_DIFF/2);
+	e = find_mean_wl_entry(ubi, &ubi->free);
+	if (!e) {
+		ubi_err("no free eraseblocks");
+		return -ENOSPC;
+	}
 
 	self_check_in_wl_tree(ubi, e, &ubi->free);
 
@@ -390,10 +532,14 @@ retry:
 	 * be protected from being moved for some time.
 	 */
 	rb_erase(&e->u.rb, &ubi->free);
+	ubi->free_count--;
 	dbg_wl("PEB %d EC %d", e->pnum, e->ec);
+#ifndef CONFIG_MTD_UBI_FASTMAP
+	/* We have to enqueue e only if fastmap is disabled,
+	 * is fastmap enabled prot_queue_add() will be called by
+	 * ubi_wl_get_peb() after removing e from the pool. */
 	prot_queue_add(ubi, e);
-	spin_unlock(&ubi->wl_lock);
-
+#endif
 	err = ubi_self_check_all_ff(ubi, e->pnum, ubi->vid_hdr_aloffset,
 				    ubi->peb_size - ubi->vid_hdr_aloffset);
 	if (err) {
@@ -404,6 +550,150 @@ retry:
 	return e->pnum;
 }
 
+#ifdef CONFIG_MTD_UBI_FASTMAP
+/**
+ * return_unused_pool_pebs - returns unused PEB to the free tree.
+ * @ubi: UBI device description object
+ * @pool: fastmap pool description object
+ */
+static void return_unused_pool_pebs(struct ubi_device *ubi,
+				    struct ubi_fm_pool *pool)
+{
+	int i;
+	struct ubi_wl_entry *e;
+
+	for (i = pool->used; i < pool->size; i++) {
+		e = ubi->lookuptbl[pool->pebs[i]];
+		wl_tree_add(e, &ubi->free);
+		ubi->free_count++;
+	}
+}
+
+/**
+ * refill_wl_pool - refills all the fastmap pool used by the
+ * WL sub-system.
+ * @ubi: UBI device description object
+ */
+static void refill_wl_pool(struct ubi_device *ubi)
+{
+	struct ubi_wl_entry *e;
+	struct ubi_fm_pool *pool = &ubi->fm_wl_pool;
+
+	return_unused_pool_pebs(ubi, pool);
+
+	for (pool->size = 0; pool->size < pool->max_size; pool->size++) {
+		if (!ubi->free.rb_node ||
+		   (ubi->free_count - ubi->beb_rsvd_pebs < 5))
+			break;
+
+		e = find_wl_entry(ubi, &ubi->free, WL_FREE_MAX_DIFF);
+		self_check_in_wl_tree(ubi, e, &ubi->free);
+		rb_erase(&e->u.rb, &ubi->free);
+		ubi->free_count--;
+
+		pool->pebs[pool->size] = e->pnum;
+	}
+	pool->used = 0;
+}
+
+/**
+ * refill_wl_user_pool - refills all the fastmap pool used by ubi_wl_get_peb.
+ * @ubi: UBI device description object
+ */
+static void refill_wl_user_pool(struct ubi_device *ubi)
+{
+	struct ubi_fm_pool *pool = &ubi->fm_pool;
+
+	return_unused_pool_pebs(ubi, pool);
+
+	for (pool->size = 0; pool->size < pool->max_size; pool->size++) {
+		if (!ubi->free.rb_node ||
+		   (ubi->free_count - ubi->beb_rsvd_pebs < 1))
+			break;
+
+		pool->pebs[pool->size] = __wl_get_peb(ubi);
+		if (pool->pebs[pool->size] < 0)
+			break;
+	}
+	pool->used = 0;
+}
+
+/**
+ * ubi_refill_pools - refills all fastmap PEB pools.
+ * @ubi: UBI device description object
+ */
+void ubi_refill_pools(struct ubi_device *ubi)
+{
+	spin_lock(&ubi->wl_lock);
+	refill_wl_pool(ubi);
+	refill_wl_user_pool(ubi);
+	spin_unlock(&ubi->wl_lock);
+}
+
+/* ubi_wl_get_peb - works exaclty like __wl_get_peb but keeps track of
+ * the fastmap pool.
+ */
+int ubi_wl_get_peb(struct ubi_device *ubi)
+{
+	int ret;
+	struct ubi_fm_pool *pool = &ubi->fm_pool;
+	struct ubi_fm_pool *wl_pool = &ubi->fm_wl_pool;
+
+	if (!pool->size || !wl_pool->size || pool->used == pool->size ||
+	    wl_pool->used == wl_pool->size)
+		ubi_update_fastmap(ubi);
+
+	/* we got not a single free PEB */
+	if (!pool->size)
+		ret = -ENOSPC;
+	else {
+		spin_lock(&ubi->wl_lock);
+		ret = pool->pebs[pool->used++];
+		prot_queue_add(ubi, ubi->lookuptbl[ret]);
+		spin_unlock(&ubi->wl_lock);
+	}
+
+	return ret;
+}
+
+/* get_peb_for_wl - returns a PEB to be used internally by the WL sub-system.
+ *
+ * @ubi: UBI device description object
+ */
+static struct ubi_wl_entry *get_peb_for_wl(struct ubi_device *ubi)
+{
+	struct ubi_fm_pool *pool = &ubi->fm_wl_pool;
+	int pnum;
+
+	if (pool->used == pool->size || !pool->size) {
+		/* We cannot update the fastmap here because this
+		 * function is called in atomic context.
+		 * Let's fail here and refill/update it as soon as possible. */
+		schedule_work(&ubi->fm_work);
+		return NULL;
+	} else {
+		pnum = pool->pebs[pool->used++];
+		return ubi->lookuptbl[pnum];
+	}
+}
+#else
+static struct ubi_wl_entry *get_peb_for_wl(struct ubi_device *ubi)
+{
+	return find_wl_entry(ubi, &ubi->free, WL_FREE_MAX_DIFF);
+}
+
+int ubi_wl_get_peb(struct ubi_device *ubi)
+{
+	int peb;
+
+	spin_lock(&ubi->wl_lock);
+	peb = __wl_get_peb(ubi);
+	spin_unlock(&ubi->wl_lock);
+
+	return peb;
+}
+#endif
+
 /**
  * prot_queue_del - remove a physical eraseblock from the protection queue.
  * @ubi: UBI device description object
@@ -534,14 +824,14 @@ repeat:
 }
 
 /**
- * schedule_ubi_work - schedule a work.
+ * __schedule_ubi_work - schedule a work.
  * @ubi: UBI device description object
  * @wrk: the work to schedule
  *
  * This function adds a work defined by @wrk to the tail of the pending works
- * list.
+ * list. Can only be used of ubi->work_sem is already held in read mode!
  */
-static void schedule_ubi_work(struct ubi_device *ubi, struct ubi_work *wrk)
+static void __schedule_ubi_work(struct ubi_device *ubi, struct ubi_work *wrk)
 {
 	spin_lock(&ubi->wl_lock);
 	list_add_tail(&wrk->list, &ubi->works);
@@ -552,9 +842,35 @@ static void schedule_ubi_work(struct ubi_device *ubi, struct ubi_work *wrk)
 	spin_unlock(&ubi->wl_lock);
 }
 
+/**
+ * schedule_ubi_work - schedule a work.
+ * @ubi: UBI device description object
+ * @wrk: the work to schedule
+ *
+ * This function adds a work defined by @wrk to the tail of the pending works
+ * list.
+ */
+static void schedule_ubi_work(struct ubi_device *ubi, struct ubi_work *wrk)
+{
+	down_read(&ubi->work_sem);
+	__schedule_ubi_work(ubi, wrk);
+	up_read(&ubi->work_sem);
+}
+
 static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 			int cancel);
 
+#ifdef CONFIG_MTD_UBI_FASTMAP
+/**
+ * ubi_is_erase_work - checks whether a work is erase work.
+ * @wrk: The work object to be checked
+ */
+int ubi_is_erase_work(struct ubi_work *wrk)
+{
+	return wrk->func == erase_worker;
+}
+#endif
+
 /**
  * schedule_erase - schedule an erase work.
  * @ubi: UBI device description object
@@ -571,6 +887,9 @@ static int schedule_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
 {
 	struct ubi_work *wl_wrk;
 
+	ubi_assert(e);
+	ubi_assert(!ubi_is_fm_block(ubi, e->pnum));
+
 	dbg_wl("schedule erasure of PEB %d, EC %d, torture %d",
 	       e->pnum, e->ec, torture);
 
@@ -589,6 +908,79 @@ static int schedule_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
 }
 
 /**
+ * do_sync_erase - run the erase worker synchronously.
+ * @ubi: UBI device description object
+ * @e: the WL entry of the physical eraseblock to erase
+ * @vol_id: the volume ID that last used this PEB
+ * @lnum: the last used logical eraseblock number for the PEB
+ * @torture: if the physical eraseblock has to be tortured
+ *
+ */
+static int do_sync_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
+			 int vol_id, int lnum, int torture)
+{
+	struct ubi_work *wl_wrk;
+
+	dbg_wl("sync erase of PEB %i", e->pnum);
+
+	wl_wrk = kmalloc(sizeof(struct ubi_work), GFP_NOFS);
+	if (!wl_wrk)
+		return -ENOMEM;
+
+	wl_wrk->e = e;
+	wl_wrk->vol_id = vol_id;
+	wl_wrk->lnum = lnum;
+	wl_wrk->torture = torture;
+
+	return erase_worker(ubi, wl_wrk, 0);
+}
+
+#ifdef CONFIG_MTD_UBI_FASTMAP
+/**
+ * ubi_wl_put_fm_peb - returns a PEB used in a fastmap to the wear-leveling
+ * sub-system.
+ * see: ubi_wl_put_peb()
+ *
+ * @ubi: UBI device description object
+ * @fm_e: physical eraseblock to return
+ * @lnum: the last used logical eraseblock number for the PEB
+ * @torture: if this physical eraseblock has to be tortured
+ */
+int ubi_wl_put_fm_peb(struct ubi_device *ubi, struct ubi_wl_entry *fm_e,
+		      int lnum, int torture)
+{
+	struct ubi_wl_entry *e;
+	int vol_id, pnum = fm_e->pnum;
+
+	dbg_wl("PEB %d", pnum);
+
+	ubi_assert(pnum >= 0);
+	ubi_assert(pnum < ubi->peb_count);
+
+	spin_lock(&ubi->wl_lock);
+	e = ubi->lookuptbl[pnum];
+
+	/* This can happen if we recovered from a fastmap the very
+	 * first time and writing now a new one. In this case the wl system
+	 * has never seen any PEB used by the original fastmap.
+	 */
+	if (!e) {
+		e = fm_e;
+		ubi_assert(e->ec >= 0);
+		ubi->lookuptbl[pnum] = e;
+	} else {
+		e->ec = fm_e->ec;
+		kfree(fm_e);
+	}
+
+	spin_unlock(&ubi->wl_lock);
+
+	vol_id = lnum ? UBI_FM_DATA_VOLUME_ID : UBI_FM_SB_VOLUME_ID;
+	return schedule_erase(ubi, e, vol_id, lnum, torture);
+}
+#endif
+
+/**
  * wear_leveling_worker - wear-leveling worker function.
  * @ubi: UBI device description object
  * @wrk: the work object
@@ -603,6 +995,9 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 {
 	int err, scrubbing = 0, torture = 0, protect = 0, erroneous = 0;
 	int vol_id = -1, uninitialized_var(lnum);
+#ifdef CONFIG_MTD_UBI_FASTMAP
+	int anchor = wrk->anchor;
+#endif
 	struct ubi_wl_entry *e1, *e2;
 	struct ubi_vid_hdr *vid_hdr;
 
@@ -636,14 +1031,35 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 		goto out_cancel;
 	}
 
+#ifdef CONFIG_MTD_UBI_FASTMAP
+	/* Check whether we need to produce an anchor PEB */
+	if (!anchor)
+		anchor = !anchor_pebs_avalible(&ubi->free);
+
+	if (anchor) {
+		e1 = find_anchor_wl_entry(&ubi->used);
+		if (!e1)
+			goto out_cancel;
+		e2 = get_peb_for_wl(ubi);
+		if (!e2)
+			goto out_cancel;
+
+		self_check_in_wl_tree(ubi, e1, &ubi->used);
+		rb_erase(&e1->u.rb, &ubi->used);
+		dbg_wl("anchor-move PEB %d to PEB %d", e1->pnum, e2->pnum);
+	} else if (!ubi->scrub.rb_node) {
+#else
 	if (!ubi->scrub.rb_node) {
+#endif
 		/*
 		 * Now pick the least worn-out used physical eraseblock and a
 		 * highly worn-out free physical eraseblock. If the erase
 		 * counters differ much enough, start wear-leveling.
 		 */
 		e1 = rb_entry(rb_first(&ubi->used), struct ubi_wl_entry, u.rb);
-		e2 = find_wl_entry(&ubi->free, WL_FREE_MAX_DIFF);
+		e2 = get_peb_for_wl(ubi);
+		if (!e2)
+			goto out_cancel;
 
 		if (!(e2->ec - e1->ec >= UBI_WL_THRESHOLD)) {
 			dbg_wl("no WL needed: min used EC %d, max free EC %d",
@@ -658,14 +1074,15 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 		/* Perform scrubbing */
 		scrubbing = 1;
 		e1 = rb_entry(rb_first(&ubi->scrub), struct ubi_wl_entry, u.rb);
-		e2 = find_wl_entry(&ubi->free, WL_FREE_MAX_DIFF);
+		e2 = get_peb_for_wl(ubi);
+		if (!e2)
+			goto out_cancel;
+
 		self_check_in_wl_tree(ubi, e1, &ubi->scrub);
 		rb_erase(&e1->u.rb, &ubi->scrub);
 		dbg_wl("scrub PEB %d to PEB %d", e1->pnum, e2->pnum);
 	}
 
-	self_check_in_wl_tree(ubi, e2, &ubi->free);
-	rb_erase(&e2->u.rb, &ubi->free);
 	ubi->move_from = e1;
 	ubi->move_to = e2;
 	spin_unlock(&ubi->wl_lock);
@@ -782,7 +1199,7 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 	ubi->move_to_put = ubi->wl_scheduled = 0;
 	spin_unlock(&ubi->wl_lock);
 
-	err = schedule_erase(ubi, e1, vol_id, lnum, 0);
+	err = do_sync_erase(ubi, e1, vol_id, lnum, 0);
 	if (err) {
 		kmem_cache_free(ubi_wl_entry_slab, e1);
 		if (e2)
@@ -797,7 +1214,7 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 		 */
 		dbg_wl("PEB %d (LEB %d:%d) was put meanwhile, erase",
 		       e2->pnum, vol_id, lnum);
-		err = schedule_erase(ubi, e2, vol_id, lnum, 0);
+		err = do_sync_erase(ubi, e2, vol_id, lnum, 0);
 		if (err) {
 			kmem_cache_free(ubi_wl_entry_slab, e2);
 			goto out_ro;
@@ -836,7 +1253,7 @@ out_not_moved:
 	spin_unlock(&ubi->wl_lock);
 
 	ubi_free_vid_hdr(ubi, vid_hdr);
-	err = schedule_erase(ubi, e2, vol_id, lnum, torture);
+	err = do_sync_erase(ubi, e2, vol_id, lnum, torture);
 	if (err) {
 		kmem_cache_free(ubi_wl_entry_slab, e2);
 		goto out_ro;
@@ -877,12 +1294,13 @@ out_cancel:
 /**
  * ensure_wear_leveling - schedule wear-leveling if it is needed.
  * @ubi: UBI device description object
+ * @nested: set to non-zero if this function is called from UBI worker
  *
  * This function checks if it is time to start wear-leveling and schedules it
  * if yes. This function returns zero in case of success and a negative error
  * code in case of failure.
  */
-static int ensure_wear_leveling(struct ubi_device *ubi)
+static int ensure_wear_leveling(struct ubi_device *ubi, int nested)
 {
 	int err = 0;
 	struct ubi_wl_entry *e1;
@@ -910,7 +1328,7 @@ static int ensure_wear_leveling(struct ubi_device *ubi)
 		 * %UBI_WL_THRESHOLD.
 		 */
 		e1 = rb_entry(rb_first(&ubi->used), struct ubi_wl_entry, u.rb);
-		e2 = find_wl_entry(&ubi->free, WL_FREE_MAX_DIFF);
+		e2 = find_wl_entry(ubi, &ubi->free, WL_FREE_MAX_DIFF);
 
 		if (!(e2->ec - e1->ec >= UBI_WL_THRESHOLD))
 			goto out_unlock;
@@ -927,8 +1345,12 @@ static int ensure_wear_leveling(struct ubi_device *ubi)
 		goto out_cancel;
 	}
 
+	wrk->anchor = 0;
 	wrk->func = &wear_leveling_worker;
-	schedule_ubi_work(ubi, wrk);
+	if (nested)
+		__schedule_ubi_work(ubi, wrk);
+	else
+		schedule_ubi_work(ubi, wrk);
 	return err;
 
 out_cancel:
@@ -939,6 +1361,38 @@ out_unlock:
 	return err;
 }
 
+#ifdef CONFIG_MTD_UBI_FASTMAP
+/**
+ * ubi_ensure_anchor_pebs - schedule wear-leveling to produce an anchor PEB.
+ * @ubi: UBI device description object
+ */
+int ubi_ensure_anchor_pebs(struct ubi_device *ubi)
+{
+	struct ubi_work *wrk;
+
+	spin_lock(&ubi->wl_lock);
+	if (ubi->wl_scheduled) {
+		spin_unlock(&ubi->wl_lock);
+		return 0;
+	}
+	ubi->wl_scheduled = 1;
+	spin_unlock(&ubi->wl_lock);
+
+	wrk = kmalloc(sizeof(struct ubi_work), GFP_NOFS);
+	if (!wrk) {
+		spin_lock(&ubi->wl_lock);
+		ubi->wl_scheduled = 0;
+		spin_unlock(&ubi->wl_lock);
+		return -ENOMEM;
+	}
+
+	wrk->anchor = 1;
+	wrk->func = &wear_leveling_worker;
+	schedule_ubi_work(ubi, wrk);
+	return 0;
+}
+#endif
+
 /**
  * erase_worker - physical eraseblock erase worker function.
  * @ubi: UBI device description object
@@ -969,6 +1423,8 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 	dbg_wl("erase PEB %d EC %d LEB %d:%d",
 	       pnum, e->ec, wl_wrk->vol_id, wl_wrk->lnum);
 
+	ubi_assert(!ubi_is_fm_block(ubi, e->pnum));
+
 	err = sync_erase(ubi, e, wl_wrk->torture);
 	if (!err) {
 		/* Fine, we've erased it successfully */
@@ -976,6 +1432,7 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 
 		spin_lock(&ubi->wl_lock);
 		wl_tree_add(e, &ubi->free);
+		ubi->free_count++;
 		spin_unlock(&ubi->wl_lock);
 
 		/*
@@ -985,7 +1442,7 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 		serve_prot_queue(ubi);
 
 		/* And take care about wear-leveling */
-		err = ensure_wear_leveling(ubi);
+		err = ensure_wear_leveling(ubi, 1);
 		return err;
 	}
 
@@ -1223,7 +1680,7 @@ retry:
 	 * Technically scrubbing is the same as wear-leveling, so it is done
 	 * by the WL worker.
 	 */
-	return ensure_wear_leveling(ubi);
+	return ensure_wear_leveling(ubi, 0);
 }
 
 /**
@@ -1404,7 +1861,7 @@ static void cancel_pending(struct ubi_device *ubi)
  */
 int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 {
-	int err, i;
+	int err, i, reserved_pebs, found_pebs = 0;
 	struct rb_node *rb1, *rb2;
 	struct ubi_ainf_volume *av;
 	struct ubi_ainf_peb *aeb, *tmp;
@@ -1416,6 +1873,9 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	init_rwsem(&ubi->work_sem);
 	ubi->max_ec = ai->max_ec;
 	INIT_LIST_HEAD(&ubi->works);
+#ifdef CONFIG_MTD_UBI_FASTMAP
+	INIT_WORK(&ubi->fm_work, update_fastmap_work_fn);
+#endif
 
 	sprintf(ubi->bgt_name, UBI_BGT_NAME_PATTERN, ubi->ubi_num);
 
@@ -1437,13 +1897,17 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 
 		e->pnum = aeb->pnum;
 		e->ec = aeb->ec;
+		ubi_assert(!ubi_is_fm_block(ubi, e->pnum));
 		ubi->lookuptbl[e->pnum] = e;
 		if (schedule_erase(ubi, e, aeb->vol_id, aeb->lnum, 0)) {
 			kmem_cache_free(ubi_wl_entry_slab, e);
 			goto out_free;
 		}
+
+		found_pebs++;
 	}
 
+	ubi->free_count = 0;
 	list_for_each_entry(aeb, &ai->free, u.list) {
 		cond_resched();
 
@@ -1454,8 +1918,14 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 		e->pnum = aeb->pnum;
 		e->ec = aeb->ec;
 		ubi_assert(e->ec >= 0);
+		ubi_assert(!ubi_is_fm_block(ubi, e->pnum));
+
 		wl_tree_add(e, &ubi->free);
+		ubi->free_count++;
+
 		ubi->lookuptbl[e->pnum] = e;
+
+		found_pebs++;
 	}
 
 	ubi_rb_for_each_entry(rb1, av, &ai->volumes, rb) {
@@ -1469,6 +1939,7 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 			e->pnum = aeb->pnum;
 			e->ec = aeb->ec;
 			ubi->lookuptbl[e->pnum] = e;
+
 			if (!aeb->scrub) {
 				dbg_wl("add PEB %d EC %d to the used tree",
 				       e->pnum, e->ec);
@@ -1478,22 +1949,38 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 				       e->pnum, e->ec);
 				wl_tree_add(e, &ubi->scrub);
 			}
+
+			found_pebs++;
 		}
 	}
 
-	if (ubi->avail_pebs < WL_RESERVED_PEBS) {
+	dbg_wl("found %i PEBs", found_pebs);
+
+	if (ubi->fm)
+		ubi_assert(ubi->good_peb_count == \
+			   found_pebs + ubi->fm->used_blocks);
+	else
+		ubi_assert(ubi->good_peb_count == found_pebs);
+
+	reserved_pebs = WL_RESERVED_PEBS;
+#ifdef CONFIG_MTD_UBI_FASTMAP
+	/* Reserve enough LEBs to store two fastmaps. */
+	reserved_pebs += (ubi->fm_size / ubi->leb_size) * 2;
+#endif
+
+	if (ubi->avail_pebs < reserved_pebs) {
 		ubi_err("no enough physical eraseblocks (%d, need %d)",
-			ubi->avail_pebs, WL_RESERVED_PEBS);
+			ubi->avail_pebs, reserved_pebs);
 		if (ubi->corr_peb_count)
 			ubi_err("%d PEBs are corrupted and not used",
 				ubi->corr_peb_count);
 		goto out_free;
 	}
-	ubi->avail_pebs -= WL_RESERVED_PEBS;
-	ubi->rsvd_pebs += WL_RESERVED_PEBS;
+	ubi->avail_pebs -= reserved_pebs;
+	ubi->rsvd_pebs += reserved_pebs;
 
 	/* Schedule wear-leveling if needed */
-	err = ensure_wear_leveling(ubi);
+	err = ensure_wear_leveling(ubi, 0);
 	if (err)
 		goto out_free;
 
@@ -1572,7 +2059,7 @@ static int self_check_ec(struct ubi_device *ubi, int pnum, int ec)
 	}
 
 	read_ec = be64_to_cpu(ec_hdr->ec);
-	if (ec != read_ec) {
+	if (ec != read_ec && read_ec - ec > 1) {
 		ubi_err("self-check failed for PEB %d", pnum);
 		ubi_err("read EC is %lld, should be %d", read_ec, ec);
 		dump_stack();
-- 
1.7.6.5

