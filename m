Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760560Ab2FUVxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:53:43 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47838 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760357Ab2FUVuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:50:24 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 04/15] UBI: Fastmap: Always refill pools upon writing a new fastmap.
Date: Thu, 21 Jun 2012 23:49:57 +0200
Message-Id: <1340315408-27375-5-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340315408-27375-1-git-send-email-richard@nod.at>
References: <UBI fastmap updates>
 <1340315408-27375-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we allow writing a new fastmap without refilling the current
pool at attach time we have to think about strange corner cases.
E.g. A PEB can be within a pool and in the free or used list.
To simplify the code for attaching this change has been made.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c |   14 +++++-
 drivers/mtd/ubi/ubi.h     |    1 +
 drivers/mtd/ubi/wl.c      |  100 ++++++++++++++++++++++++++-------------------
 3 files changed, 70 insertions(+), 45 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index cccb0c9..ba69267 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1362,12 +1362,20 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 	struct ubi_fastmap_layout *new_fm, *old_fm;
 	struct ubi_wl_entry *tmp_e;
 
-	if (ubi->ro_mode)
+	mutex_lock(&ubi->fm_mutex);
+
+	ubi_refill_pools(ubi);
+
+	if (ubi->ro_mode) {
+		mutex_unlock(&ubi->fm_mutex);
 		return 0;
+	}
 
 	new_fm = kzalloc(sizeof(*new_fm), GFP_KERNEL);
-	if (!new_fm)
+	if (!new_fm) {
+		mutex_unlock(&ubi->fm_mutex);
 		return -ENOMEM;
+	}
 
 	new_fm->size = sizeof(struct ubi_fm_hdr) + \
 			sizeof(struct ubi_fm_scan_pool) + \
@@ -1387,11 +1395,11 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 				kfree(new_fm->e[i]);
 
 			kfree(new_fm);
+			mutex_unlock(&ubi->fm_mutex);
 			return -ENOMEM;
 		}
 	}
 
-	mutex_lock(&ubi->fm_mutex);
 	old_fm = ubi->fm;
 	ubi->fm = NULL;
 
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index a568a3b..a0c2103 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -757,6 +757,7 @@ int ubi_thread(void *u);
 struct ubi_wl_entry *ubi_wl_get_fm_peb(struct ubi_device *ubi, int max_pnum);
 int ubi_wl_put_fm_peb(struct ubi_device *ubi, struct ubi_wl_entry *used_e, int torture);
 int ubi_is_erase_work(struct ubi_work *wrk);
+void ubi_refill_pools(struct ubi_device *ubi);
 
 /* io.c */
 int ubi_io_read(const struct ubi_device *ubi, void *buf, int pnum, int offset,
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index f4d2c79..ec0a954 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -497,43 +497,76 @@ retry:
 
 	return e->pnum;
 }
-
-static int refill_wl_pool(struct ubi_device *ubi)
+/**
+ * return_unused_pool_pebs - returns unused PEB to the free tree.
+ * @ubi: UBI device description object
+ * @pool: fastmap pool description object
+ */
+static void return_unused_pool_pebs(struct ubi_device *ubi,
+				    struct ubi_fm_pool *pool)
 {
-	int ret, i;
-	struct ubi_fm_pool *pool = &ubi->fm_wl_pool;
+	int i;
 	struct ubi_wl_entry *e;
 
-	spin_lock(&ubi->wl_lock);
-	if (pool->used != pool->size && pool->size) {
-		spin_unlock(&ubi->wl_lock);
-		return 0;
+	for (i = pool->used; i < pool->size; i++) {
+		e = ubi->lookuptbl[pool->pebs[i]];
+		wl_tree_add(e, &ubi->free);
 	}
+}
 
-	for (i = 0; i < pool->max_size; i++) {
-		if (!ubi->free.rb_node) {
-			spin_unlock(&ubi->wl_lock);
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
+		if (!ubi->free.rb_node)
 			break;
-		}
 
 		e = find_wl_entry(&ubi->free, WL_FREE_MAX_DIFF);
 		self_check_in_wl_tree(ubi, e, &ubi->free);
 		rb_erase(&e->u.rb, &ubi->free);
 
-		pool->pebs[i] = e->pnum;
+		pool->pebs[pool->size] = e->pnum;
 	}
-	pool->size = i;
-	spin_unlock(&ubi->wl_lock);
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
 
-	ret = ubi_update_fastmap(ubi);
-	if (ret) {
-		ubi_ro_mode(ubi);
+	return_unused_pool_pebs(ubi, pool);
 
-		return ret > 0 ? -EINVAL : ret;
+	for (pool->size = 0; pool->size < pool->max_size; pool->size++) {
+		pool->pebs[pool->size] = __ubi_wl_get_peb(ubi);
+		if (pool->pebs[pool->size] < 0)
+			break;
 	}
 	pool->used = 0;
+}
 
-	return pool->size ? 0 : -ENOSPC;
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
 }
 
 /* ubi_wl_get_peb - works exaclty like __ubi_wl_get_peb but keeps track of
@@ -541,32 +574,15 @@ static int refill_wl_pool(struct ubi_device *ubi)
  */
 int ubi_wl_get_peb(struct ubi_device *ubi)
 {
-	struct ubi_fm_pool *pool = &ubi->fm_pool;
 	int ret;
+	struct ubi_fm_pool *pool = &ubi->fm_pool;
+	struct ubi_fm_pool *wl_pool = &ubi->fm_wl_pool;
 
 	mutex_lock(&ubi->fm_pool_mutex);
 
-	refill_wl_pool(ubi);
-
-	/* pool contains no free blocks, create a new one
-	 * and write a fastmap */
-	if (pool->used == pool->size || !pool->size) {
-		for (pool->size = 0; pool->size < pool->max_size;
-				pool->size++) {
-			pool->pebs[pool->size] = __ubi_wl_get_peb(ubi);
-			if (pool->pebs[pool->size] < 0)
-				break;
-		}
-
-		pool->used = 0;
-		ret = ubi_update_fastmap(ubi);
-		if (ret) {
-			ubi_ro_mode(ubi);
-			mutex_unlock(&ubi->fm_pool_mutex);
-
-			return ret > 0 ? -EINVAL : ret;
-		}
-	}
+	if (!pool->size || !wl_pool->size || pool->used == pool->size ||
+	    wl_pool->used == wl_pool->size)
+		ubi_update_fastmap(ubi);
 
 	/* we got not a single free PEB */
 	if (!pool->size)
-- 
1.7.6.5

