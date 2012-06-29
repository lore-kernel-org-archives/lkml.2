Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab2F2PPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:15:43 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47844 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932179Ab2F2POs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:14:48 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 10/11] UBI: Fastmap: Disable fastmap per default
Date: Fri, 29 Jun 2012 17:14:28 +0200
Message-Id: <1340982869-77042-11-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340982869-77042-1-git-send-email-richard@nod.at>
References: <1340982869-77042-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/attach.c  |    2 +-
 drivers/mtd/ubi/build.c   |    1 +
 drivers/mtd/ubi/fastmap.c |    2 +-
 drivers/mtd/ubi/ubi.h     |    2 ++
 drivers/mtd/ubi/wl.c      |    5 +++--
 5 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index a343a41..c55ad0f 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -1394,7 +1394,7 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 	if (!ai)
 		return -ENOMEM;
 
-	if (force_scan)
+	if (force_scan || ubi->fm_disabled)
 		err = scan_all(ubi, ai, 0);
 	else {
 		err = scan_fast(ubi, ai);
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 7094550..7b5dc5d 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -899,6 +899,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num, int vid_hdr_offset)
 		ubi->fm_pool.max_size = UBI_FM_MIN_POOL_SIZE;
 
 	ubi->fm_wl_pool.max_size = UBI_FM_WL_POOL_SIZE;
+	ubi->fm_disabled = 1;
 
 	ubi_msg("default fastmap pool size: %d", ubi->fm_pool.max_size);
 	ubi_msg("default fastmap WL pool size: %d", ubi->fm_wl_pool.max_size);
diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 6276039..0c9466d 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1392,7 +1392,7 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 
 	ubi_refill_pools(ubi);
 
-	if (ubi->ro_mode) {
+	if (ubi->ro_mode || ubi->fm_disabled) {
 		mutex_unlock(&ubi->fm_mutex);
 		return 0;
 	}
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index fef9e92..9f766ff 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -386,6 +386,7 @@ struct ubi_wl_entry;
  * @ltree: the lock tree
  * @alc_mutex: serializes "atomic LEB change" operations
  *
+ * @fm_disabled: non-zero if fastmap is disabled (default)
  * @fm: in-memory data structure of the currently used fastmap
  * @fm_pool: in-memory data structure of the fastmap pool
  * @fm_wl_pool: in-memory data structure of the fastmap pool used by the WL
@@ -486,6 +487,7 @@ struct ubi_device {
 	struct mutex alc_mutex;
 
 	/* Fastmap stuff */
+	int fm_disabled;
 	struct ubi_fastmap_layout *fm;
 	struct ubi_fm_pool fm_pool;
 	struct ubi_fm_pool fm_wl_pool;
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 28385d2..6c69017 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -376,7 +376,7 @@ static struct ubi_wl_entry *find_wl_entry(struct ubi_device *ubi,
 	/* If no fastmap has been written and this WL entry can be used
 	 * as anchor PEB, hold it back and return the second best WL entry
 	 * such that fastmap can use the anchor PEB later. */
-	if (!ubi->fm && e->pnum < UBI_FM_MAX_START)
+	if (!ubi->fm_disabled && !ubi->fm && e->pnum < UBI_FM_MAX_START)
 		return prev_e;
 
 	return e;
@@ -405,7 +405,8 @@ static struct ubi_wl_entry *find_mean_wl_entry(struct ubi_device *ubi,
 		/* If no fastmap has been written and this WL entry can be used
 		 * as anchor PEB, hold it back and return the second best
 		 * WL entry such that fastmap can use the anchor PEB later. */
-		if (e && !ubi->fm && e->pnum < UBI_FM_MAX_START)
+		if (e && !ubi->fm_disabled && !ubi->fm &&
+		    e->pnum < UBI_FM_MAX_START)
 			e = rb_entry(rb_next(root->rb_node),
 				     struct ubi_wl_entry, u.rb);
 	} else
-- 
1.7.6.5

