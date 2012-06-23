Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab2FWNEX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 09:04:23 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47839 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353Ab2FWNDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 09:03:41 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 5/7] UBI: Fastmap: Kill max_pnum logic
Date: Sat, 23 Jun 2012 15:03:20 +0200
Message-Id: <1340456602-46050-6-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340456602-46050-1-git-send-email-richard@nod.at>
References: <1340456602-46050-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UBI_FM_MAX_START is constant, no need to mess around with max_pnum.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c |    4 ++--
 drivers/mtd/ubi/ubi.h     |    2 +-
 drivers/mtd/ubi/wl.c      |   26 +++++++++++---------------
 3 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 2ff0681..acd0561 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1420,7 +1420,7 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 
 	for (i = 1; i < new_fm->used_blocks; i++) {
 		spin_lock(&ubi->wl_lock);
-		tmp_e = ubi_wl_get_fm_peb(ubi, -1);
+		tmp_e = ubi_wl_get_fm_peb(ubi, 0);
 		spin_unlock(&ubi->wl_lock);
 
 		if (!tmp_e) {
@@ -1439,7 +1439,7 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 	}
 
 	spin_lock(&ubi->wl_lock);
-	tmp_e = ubi_wl_get_fm_peb(ubi, UBI_FM_MAX_START);
+	tmp_e = ubi_wl_get_fm_peb(ubi, 1);
 	spin_unlock(&ubi->wl_lock);
 
 	if (old_fm) {
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 56b1c5c..a2c1bcc 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -757,7 +757,7 @@ int ubi_wl_scrub_peb(struct ubi_device *ubi, int pnum);
 int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai);
 void ubi_wl_close(struct ubi_device *ubi);
 int ubi_thread(void *u);
-struct ubi_wl_entry *ubi_wl_get_fm_peb(struct ubi_device *ubi, int max_pnum);
+struct ubi_wl_entry *ubi_wl_get_fm_peb(struct ubi_device *ubi, int anchor);
 int ubi_wl_put_fm_peb(struct ubi_device *ubi, struct ubi_wl_entry *used_e, int torture);
 int ubi_is_erase_work(struct ubi_work *wrk);
 void ubi_refill_pools(struct ubi_device *ubi);
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 5f6e81e..4f8b06a 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -417,19 +417,16 @@ static struct ubi_wl_entry *find_mean_wl_entry(struct ubi_device *ubi,
 /**
  * find_anchor_wl_entry - find wear-leveling entry to used as anchor PEB.
  * @root: the RB-tree where to look for
- * @max_pnum: highest possible pnum
  */
-static struct ubi_wl_entry *find_anchor_wl_entry(struct rb_root *root,
-						 int max_pnum)
+static struct ubi_wl_entry *find_anchor_wl_entry(struct rb_root *root)
 {
 	struct rb_node *p;
 	struct ubi_wl_entry *e, *victim = NULL;
 	int max_ec = UBI_MAX_ERASECOUNTER;
 
 	ubi_rb_for_each_entry(p, e, root, u.rb) {
-		if (e->pnum < max_pnum && e->ec < max_ec) {
+		if (e->pnum < UBI_FM_MAX_START && e->ec < max_ec) {
 			victim = e;
-			max_pnum = e->pnum;
 			max_ec = e->ec;
 		}
 	}
@@ -437,13 +434,13 @@ static struct ubi_wl_entry *find_anchor_wl_entry(struct rb_root *root,
 	return victim;
 }
 
-static int anchor_pebs_avalible(struct rb_root *root, int max_pnum)
+static int anchor_pebs_avalible(struct rb_root *root)
 {
 	struct rb_node *p;
 	struct ubi_wl_entry *e;
 
 	ubi_rb_for_each_entry(p, e, root, u.rb)
-		if (e->pnum < max_pnum)
+		if (e->pnum < UBI_FM_MAX_START)
 			return 1;
 
 	return 0;
@@ -452,14 +449,13 @@ static int anchor_pebs_avalible(struct rb_root *root, int max_pnum)
 /**
  * ubi_wl_get_fm_peb - find a physical erase block with a given maximal number.
  * @ubi: UBI device description object
- * @max_pnum: the highest acceptable erase block number
+ * @anchor: This PEB will be used as anchor PEB by fastmap
  *
  * The function returns a physical erase block with a given maximal number
  * and removes it from the wl subsystem.
- * If max_pnum is negative a PEB with a mean EC will be selected.
  * Must be called with wl_lock held!
  */
-struct ubi_wl_entry *ubi_wl_get_fm_peb(struct ubi_device *ubi, int max_pnum)
+struct ubi_wl_entry *ubi_wl_get_fm_peb(struct ubi_device *ubi, int anchor)
 {
 	struct ubi_wl_entry *e = NULL;
 
@@ -469,10 +465,10 @@ struct ubi_wl_entry *ubi_wl_get_fm_peb(struct ubi_device *ubi, int max_pnum)
 		goto out;
 	}
 
-	if (max_pnum < 0)
-		e = find_mean_wl_entry(ubi, &ubi->free);
+	if (anchor)
+		e = find_anchor_wl_entry(&ubi->free);
 	else
-		e = find_anchor_wl_entry(&ubi->free, max_pnum);
+		e = find_mean_wl_entry(ubi, &ubi->free);
 
 	if (!e)
 		goto out;
@@ -968,10 +964,10 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 
 	/* Check whether we need to produce an anchor PEB */
 	if (!anchor)
-		anchor = !anchor_pebs_avalible(&ubi->free, UBI_FM_MAX_START);
+		anchor = !anchor_pebs_avalible(&ubi->free);
 
 	if (anchor) {
-		e1 = find_anchor_wl_entry(&ubi->used, UBI_FM_MAX_START);
+		e1 = find_anchor_wl_entry(&ubi->used);
 		if (!e1)
 			goto out_cancel;
 		e2 = get_peb_for_wl(ubi);
-- 
1.7.6.5

