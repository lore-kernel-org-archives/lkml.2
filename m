Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483Ab2EPUwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 16:52:19 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47839 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757058Ab2EPUwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 16:52:15 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: tglx@linutronix.de, dedekind1@gmail.com, linux-kernel@vger.kernel.org,
        Heinz.Egger@linutronix.de, tim.bird@am.sony.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5/7] [RFC] UBI: Make wl subsystem fastmap aware
Date: Wed, 16 May 2012 22:52:00 +0200
Message-Id: <1337201522-86521-6-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1337201522-86521-1-git-send-email-richard@nod.at>
References: <1337201522-86521-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integrates fastmapping into the wl subsystem.
Fastmapping deals with PEBs, it has to tell the wl subsystem
which PEBs are currently used and must not touched by the wl thread.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/ubi.h |    3 +
 drivers/mtd/ubi/wl.c  |  141 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 144 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 6c89971..cf5cfaf 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -586,6 +586,9 @@ int ubi_wl_scrub_peb(struct ubi_device *ubi, int pnum);
 int ubi_wl_init_scan(struct ubi_device *ubi, struct ubi_scan_info *si);
 void ubi_wl_close(struct ubi_device *ubi);
 int ubi_thread(void *u);
+int ubi_wl_get_fm_peb(struct ubi_device *ubi, int max_pnum);
+int ubi_wl_put_fm_peb(struct ubi_device *ubi, int pnum, int torture);
+int ubi_is_fm_block(struct ubi_device *ubi, int pnum);
 
 /* io.c */
 int ubi_io_read(const struct ubi_device *ubi, void *buf, int pnum, int offset,
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 64ce993..a329358 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -169,6 +169,25 @@ static int paranoid_check_in_pq(const struct ubi_device *ubi,
 #endif
 
 /**
+ *  ubi_ubi_is_fm_block - returns 1 if a PEB is currently used in a fastmap.
+ *  @ubi: UBI device description object
+ *  @pnum: the to be checked PEB
+ */
+int ubi_is_fm_block(struct ubi_device *ubi, int pnum)
+{
+	int i;
+
+	if (!ubi->fm)
+		return 0;
+
+	for (i = 0; i < ubi->fm->used_blocks; i++)
+		if (ubi->fm->peb[i] == pnum)
+			return 1;
+
+	return 0;
+}
+
+/**
  * wl_tree_add - add a wear-leveling entry to a WL RB-tree.
  * @e: the wear-leveling entry to add
  * @root: the root of the tree
@@ -375,6 +394,63 @@ static struct ubi_wl_entry *find_wl_entry(struct rb_root *root, int diff)
 
 /**
  * ubi_wl_get_peb - get a physical eraseblock.
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
+/**
+ * ubi_wl_get_fm_peb - find a physical erase block with a given maximal number.
+ * @ubi: UBI device description object
+ * @max_pnum: the highest acceptable erase block number
+ *
+ * The function returns a physical erase block with a given maximal number
+ * and removes it from the wl subsystem.
+ * Must be called with wl_lock held!
+ */
+int ubi_wl_get_fm_peb(struct ubi_device *ubi, int max_pnum)
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
+
+/**
  * @ubi: UBI device description object
  *
  * This function returns a physical eraseblock in case of success and a
@@ -596,6 +672,9 @@ static int schedule_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
 {
 	struct ubi_work *wl_wrk;
 
+	ubi_assert(e);
+	ubi_assert(!ubi_is_fm_block(ubi, e->pnum));
+
 	dbg_wl("schedule erasure of PEB %d, EC %d, torture %d",
 	       e->pnum, e->ec, torture);
 
@@ -612,6 +691,56 @@ static int schedule_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
 }
 
 /**
+ * ubi_wl_put_fm_peb - returns a PEB used in a fastmap to the wear-leveling 
+ * sub-system.
+ *
+ * see: ubi_wl_put_peb()
+ */
+int ubi_wl_put_fm_peb(struct ubi_device *ubi, int pnum, int torture)
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
+	/* This can happen if we recovered from a fastmap the very
+	 * frist time and writing now a new one. In this case the wl system
+	 * has never seen any PEB used by the original fastmap.
+	 */
+	if (!e) {
+		ubi_assert(ubi->old_fm);
+		e = kmem_cache_alloc(ubi_wl_entry_slab, GFP_ATOMIC);
+		if (!e) {
+			spin_unlock(&ubi->wl_lock);
+			return -ENOMEM;
+		}
+
+		e->pnum = pnum;
+		e->ec = 0;
+		/* use the ec value from the fastmap */
+		for (i = 0; i < UBI_FM_MAX_BLOCKS; i++) {
+			if (pnum == ubi->old_fm->peb[i]) {
+				e->ec = ubi->old_fm->ec[i];
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
+
+/**
  * wear_leveling_worker - wear-leveling worker function.
  * @ubi: UBI device description object
  * @wrk: the work object
@@ -988,6 +1117,8 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 
 	dbg_wl("erase PEB %d EC %d", pnum, e->ec);
 
+	ubi_assert(!ubi_is_fm_block(ubi, e->pnum));
+
 	err = sync_erase(ubi, e, wl_wrk->torture);
 	if (!err) {
 		/* Fine, we've erased it successfully */
@@ -1422,6 +1553,9 @@ int ubi_wl_init_scan(struct ubi_device *ubi, struct ubi_scan_info *si)
 
 		e->pnum = seb->pnum;
 		e->ec = seb->ec;
+
+		ubi_assert(!ubi_is_fm_block(ubi, e->pnum));
+
 		ubi->lookuptbl[e->pnum] = e;
 		if (schedule_erase(ubi, e, 0)) {
 			kmem_cache_free(ubi_wl_entry_slab, e);
@@ -1439,7 +1573,10 @@ int ubi_wl_init_scan(struct ubi_device *ubi, struct ubi_scan_info *si)
 		e->pnum = seb->pnum;
 		e->ec = seb->ec;
 		ubi_assert(e->ec >= 0);
+		ubi_assert(!ubi_is_fm_block(ubi, e->pnum));
+
 		wl_tree_add(e, &ubi->free);
+
 		ubi->lookuptbl[e->pnum] = e;
 	}
 
@@ -1454,6 +1591,10 @@ int ubi_wl_init_scan(struct ubi_device *ubi, struct ubi_scan_info *si)
 			e->pnum = seb->pnum;
 			e->ec = seb->ec;
 			ubi->lookuptbl[e->pnum] = e;
+
+			if (ubi_is_fm_block(ubi, seb->pnum))
+				continue;
+
 			if (!seb->scrub) {
 				dbg_wl("add PEB %d EC %d to the used tree",
 				       e->pnum, e->ec);
-- 
1.7.6.5

