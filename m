Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598Ab2EIRk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:40:26 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47839 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629Ab2EIRjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:39:08 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: tim.bird@am.sony.com, tglx@linutronix.de, dedekind1@gmail.com,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5/7] [RFC] UBI: Make wl subsystem checkpoint aware
Date: Wed,  9 May 2012 19:38:43 +0200
Message-Id: <1336585125-127220-6-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1336585125-127220-1-git-send-email-richard@nod.at>
References: <1336585125-127220-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integrates checkpointing into the wl subsystem.
Checkpointing deals with PEBs, it has to tell the wl subsystem
which PEBs are currently used and must not touched by the wl thread.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/ubi.h |    5 +
 drivers/mtd/ubi/wl.c  |  214 ++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 217 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index c3d8e75..df267bb 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -585,6 +585,11 @@ int ubi_wl_scrub_peb(struct ubi_device *ubi, int pnum);
 int ubi_wl_init_scan(struct ubi_device *ubi, struct ubi_scan_info *si);
 void ubi_wl_close(struct ubi_device *ubi);
 int ubi_thread(void *u);
+int ubi_wl_get_cp_peb(struct ubi_device *ubi, int max_pnum);
+int ubi_wl_put_cp_peb(struct ubi_device *ubi, int pnum, int torture);
+#define is_cp_block(__ubi__, __e__) __is_cp_block(__ubi__, __e__->pnum)
+int __is_cp_block(struct ubi_device *ubi, int pnum);
+void ubi_flush_prot_queue(struct ubi_device *ubi);
 
 /* io.c */
 int ubi_io_read(const struct ubi_device *ubi, void *buf, int pnum, int offset,
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 7c1a9bf..b2e563e 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -175,6 +175,32 @@ static int paranoid_check_in_pq(const struct ubi_device *ubi,
 #define paranoid_check_in_pq(ubi, e) 0
 #endif
 
+#ifdef CONFIG_MTD_UBI_CHECKPOINT
+/**
+ *  __is_cp_block - returns 1 if a PEB is currently used for checkpointing.
+ *  @ubi: UBI device description object
+ *  @pnum: the to be checked PEB
+ */
+int __is_cp_block(struct ubi_device *ubi, int pnum)
+{
+	int i;
+
+	if (!ubi->cp)
+		return 0;
+
+	for (i = 0; i < ubi->cp->used_blocks; i++)
+		if (ubi->cp->peb[i] == pnum)
+			return 1;
+
+	return 0;
+}
+#else
+int __is_cp_block(struct ubi_device *ubi, int pnum)
+{
+	return 0;
+}
+#endif
+
 /**
  * wl_tree_add - add a wear-leveling entry to a WL RB-tree.
  * @e: the wear-leveling entry to add
@@ -380,15 +406,74 @@ static struct ubi_wl_entry *find_wl_entry(struct rb_root *root, int diff)
 	return e;
 }
 
+#ifdef CONFIG_MTD_UBI_CHECKPOINT
+/**
+ * find_early_wl_entry - find wear-leveling entry with a low pnum.
+ * @root: the RB-tree where to look for
+ * @max_pnum: highest possible pnum
+ *
+ * This function looks for a wear leveling entry containing a eb which
+ * is in front of the memory.
+ */
+static struct ubi_wl_entry *find_early_wl_entry(struct rb_root *root,
+						int max_pnum)
+{
+	struct rb_node *p;
+	struct ubi_wl_entry *e, *victim = NULL;
+
+	ubi_rb_for_each_entry(p, e, root, u.rb) {
+		if (e->pnum < max_pnum) {
+			victim = e;
+			max_pnum = e->pnum;
+		}
+	}
+
+	return victim;
+}
+
 /**
- * ubi_wl_get_peb - get a physical eraseblock.
+ * ubi_wl_get_cp_peb - find a physical erase block with a given maximal number.
+ * @ubi: UBI device description object
+ * @max_pnum: the highest acceptable erase block number
+ *
+ * The function returns a physical erase block with a given maximal number
+ * and removes it from the wl subsystem.
+ * Must be called with wl_lock held!
+ */
+int ubi_wl_get_cp_peb(struct ubi_device *ubi, int max_pnum)
+{
+	int ret = -ENOSPC;
+	struct ubi_wl_entry *e;
+
+	if (!ubi->free.rb_node) {
+		ubi_err("no free eraseblocks");
+
+		goto out;
+	}
+
+	e = find_early_wl_entry(&ubi->free, max_pnum);
+	if (!e)
+		goto out;
+
+	ret = e->pnum;
+
+	/* remove it from the free list,
+	 * the wl subsystem does no longer know this erase block */
+	rb_erase(&e->u.rb, &ubi->free);
+out:
+	return ret;
+}
+#endif
+
+/**
+ * __ubi_wl_get_peb - get a physical eraseblock.
  * @ubi: UBI device description object
  * @dtype: type of data which will be stored in this physical eraseblock
  *
  * This function returns a physical eraseblock in case of success and a
  * negative error code in case of failure. Might sleep.
  */
-int ubi_wl_get_peb(struct ubi_device *ubi, int dtype)
+static int __ubi_wl_get_peb(struct ubi_device *ubi, int dtype)
 {
 	int err;
 	struct ubi_wl_entry *e, *first, *last;
@@ -472,6 +557,50 @@ retry:
 	return e->pnum;
 }
 
+#ifdef CONFIG_MTD_UBI_CHECKPOINT
+/* ubi_wl_get_peb - works exaclty like __ubi_wl_get_peb but keeps track of
+ * all checkpointing pools.
+ */
+int ubi_wl_get_peb(struct ubi_device *ubi, int dtype)
+{
+	struct ubi_cp_pool *pool;
+
+	if (dtype == UBI_LONGTERM)
+		pool = &ubi->long_pool;
+	else if (dtype == UBI_SHORTTERM)
+		pool = &ubi->short_pool;
+	else if (dtype == UBI_UNKNOWN)
+		pool = &ubi->unk_pool;
+	else
+		BUG();
+
+	/* pool contains no free blocks, create a new one
+	 * and write a checkpoint */
+	if (pool->used == pool->size) {
+		for (pool->size = 0; pool->size < pool->max_size;
+				pool->size++) {
+			pool->pebs[pool->size] = __ubi_wl_get_peb(ubi, dtype);
+			if (pool->pebs[pool->size] < 0)
+				break;
+		}
+
+		pool->used = 0;
+		ubi_update_checkpoint(ubi);
+	}
+
+	/* we got not a single free PEB */
+	if (!pool->size)
+		return -1;
+
+	return pool->pebs[pool->used++];
+}
+#else
+int ubi_wl_get_peb(struct ubi_device *ubi, int dtype)
+{
+	return __ubi_wl_get_peb(ubi, dtype);
+}
+#endif
+
 /**
  * prot_queue_del - remove a physical eraseblock from the protection queue.
  * @ubi: UBI device description object
@@ -602,6 +731,21 @@ repeat:
 }
 
 /**
+ * ubi_flush_prot_queue - flushes the protection queue
+ * @ubi: UBI device description object
+ *
+ * This function flushes the protection queue such that checkpointing
+ * gets aware of them.
+ */
+void ubi_flush_prot_queue(struct ubi_device *ubi)
+{
+	int i;
+
+	for (i = 0; i < UBI_PROT_QUEUE_LEN; i++)
+		serve_prot_queue(ubi);
+}
+
+/**
  * schedule_ubi_work - schedule a work.
  * @ubi: UBI device description object
  * @wrk: the work to schedule
@@ -637,6 +781,9 @@ static int schedule_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
 {
 	struct ubi_work *wl_wrk;
 
+	ubi_assert(e);
+	ubi_assert(!is_cp_block(ubi, e));
+
 	dbg_wl("schedule erasure of PEB %d, EC %d, torture %d",
 	       e->pnum, e->ec, torture);
 
@@ -652,6 +799,57 @@ static int schedule_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
 	return 0;
 }
 
+#ifdef CONFIG_MTD_UBI_CHECKPOINT
+/**
+ * ubi_wl_put_cp_peb - return a CP PEB to the wear-leveling sub-system
+ *
+ * see: ubi_wl_put_peb()
+ */
+int ubi_wl_put_cp_peb(struct ubi_device *ubi, int pnum, int torture)
+{
+	int i, err = 0;
+	struct ubi_wl_entry *e;
+
+	dbg_wl("PEB %d", pnum);
+	ubi_assert(pnum >= 0);
+	ubi_assert(pnum < ubi->peb_count);
+
+	spin_lock(&ubi->wl_lock);
+	e = ubi->lookuptbl[pnum];
+
+	/* This can happen if we recovered from a checkpoint the very
+	 * frist time and writing now a new one. In this case the wl system
+	 * has never seen any PEB used by the original checkpoint.
+	 */
+	if (!e) {
+		ubi_assert(ubi->old_cp);
+		e = kmem_cache_alloc(ubi_wl_entry_slab, GFP_ATOMIC);
+		if (!e) {
+			spin_unlock(&ubi->wl_lock);
+			return -ENOMEM;
+		}
+
+		e->pnum = pnum;
+		e->ec = 0;
+		/* use the ec value from the checkpoint */
+		for (i = 0; i < UBI_CP_MAX_BLOCKS; i++) {
+			if (pnum == ubi->old_cp->peb[i]) {
+				e->ec = ubi->old_cp->ec[i];
+				break;
+			}
+		}
+		ubi_assert(e->ec);
+		ubi->lookuptbl[pnum] = e;
+	}
+
+	spin_unlock(&ubi->wl_lock);
+
+	err = schedule_erase(ubi, e, torture);
+
+	return err;
+}
+#endif
+
 /**
  * wear_leveling_worker - wear-leveling worker function.
  * @ubi: UBI device description object
@@ -1029,6 +1227,8 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 
 	dbg_wl("erase PEB %d EC %d", pnum, e->ec);
 
+	ubi_assert(!is_cp_block(ubi, e));
+
 	err = sync_erase(ubi, e, wl_wrk->torture);
 	if (!err) {
 		/* Fine, we've erased it successfully */
@@ -1463,6 +1663,9 @@ int ubi_wl_init_scan(struct ubi_device *ubi, struct ubi_scan_info *si)
 
 		e->pnum = seb->pnum;
 		e->ec = seb->ec;
+
+		ubi_assert(!is_cp_block(ubi, e));
+
 		ubi->lookuptbl[e->pnum] = e;
 		if (schedule_erase(ubi, e, 0)) {
 			kmem_cache_free(ubi_wl_entry_slab, e);
@@ -1480,7 +1683,10 @@ int ubi_wl_init_scan(struct ubi_device *ubi, struct ubi_scan_info *si)
 		e->pnum = seb->pnum;
 		e->ec = seb->ec;
 		ubi_assert(e->ec >= 0);
+		ubi_assert(!is_cp_block(ubi, e));
+
 		wl_tree_add(e, &ubi->free);
+
 		ubi->lookuptbl[e->pnum] = e;
 	}
 
@@ -1495,6 +1701,10 @@ int ubi_wl_init_scan(struct ubi_device *ubi, struct ubi_scan_info *si)
 			e->pnum = seb->pnum;
 			e->ec = seb->ec;
 			ubi->lookuptbl[e->pnum] = e;
+
+			if (__is_cp_block(ubi, seb->pnum))
+				continue;
+
 			if (!seb->scrub) {
 				dbg_wl("add PEB %d EC %d to the used tree",
 				       e->pnum, e->ec);
-- 
1.7.6.5

