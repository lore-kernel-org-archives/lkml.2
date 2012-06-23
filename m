Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab2FWNDl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 09:03:41 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613Ab2FWNDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 09:03:39 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/7] UBI: Fastmap: Modify the WL sub-system to prodcue a free anchor PEB
Date: Sat, 23 Jun 2012 15:03:16 +0200
Message-Id: <1340456602-46050-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340456602-46050-1-git-send-email-richard@nod.at>
References: <1340456602-46050-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c |    6 ++++
 drivers/mtd/ubi/ubi.h     |    3 ++
 drivers/mtd/ubi/wl.c      |   60 +++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 582f5ee..4793ba8 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1374,6 +1374,12 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 		return 0;
 	}
 
+	ret = ubi_ensure_anchor_pebs(ubi);
+	if (ret) {
+		mutex_unlock(&ubi->fm_mutex);
+		return ret;
+	}
+
 	new_fm = kzalloc(sizeof(*new_fm), GFP_KERNEL);
 	if (!new_fm) {
 		mutex_unlock(&ubi->fm_mutex);
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 534e851..56b1c5c 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -663,6 +663,7 @@ struct ubi_attach_info {
  * @func: worker function
  * @e: physical eraseblock to erase
  * @torture: if the physical eraseblock has to be tortured
+ * @anchor: produce a anchor PEB to by used by fastmap
  *
  * The @func pointer points to the worker function. If the @cancel argument is
  * not zero, the worker has to free the resources and exit immediately. The
@@ -675,6 +676,7 @@ struct ubi_work {
 	/* The below fields are only relevant to erasure works */
 	struct ubi_wl_entry *e;
 	int torture;
+	int anchor;
 };
 
 #include "debug.h"
@@ -759,6 +761,7 @@ struct ubi_wl_entry *ubi_wl_get_fm_peb(struct ubi_device *ubi, int max_pnum);
 int ubi_wl_put_fm_peb(struct ubi_device *ubi, struct ubi_wl_entry *used_e, int torture);
 int ubi_is_erase_work(struct ubi_work *wrk);
 void ubi_refill_pools(struct ubi_device *ubi);
+int ubi_ensure_anchor_pebs(struct ubi_device *ubi);
 
 /* io.c */
 int ubi_io_read(const struct ubi_device *ubi, void *buf, int pnum, int offset,
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 6771f30..b4d4358 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -419,6 +419,18 @@ static struct ubi_wl_entry *find_anchor_wl_entry(struct rb_root *root,
 	return victim;
 }
 
+static int anchor_pebs_avalible(struct rb_root *root, int max_pnum)
+{
+	struct rb_node *p;
+	struct ubi_wl_entry *e;
+
+	ubi_rb_for_each_entry(p, e, root, u.rb)
+		if (e->pnum < max_pnum)
+			return 1;
+
+	return 0;
+}
+
 /**
  * ubi_wl_get_fm_peb - find a physical erase block with a given maximal number.
  * @ubi: UBI device description object
@@ -901,10 +913,11 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 				int cancel)
 {
 	int err, scrubbing = 0, torture = 0, protect = 0, erroneous = 0;
-	int vol_id = -1, uninitialized_var(lnum);
+	int anchor, vol_id = -1, uninitialized_var(lnum);
 	struct ubi_wl_entry *e1, *e2;
 	struct ubi_vid_hdr *vid_hdr;
 
+	anchor = wrk->anchor;
 	kfree(wrk);
 	if (cancel)
 		return 0;
@@ -935,7 +948,23 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 		goto out_cancel;
 	}
 
-	if (!ubi->scrub.rb_node) {
+	/* Check whether we need to produce an anchor PEB */
+	if (!anchor)
+		anchor = !anchor_pebs_avalible(&ubi->free, UBI_FM_MAX_START);
+
+	if (anchor) {
+		e1 = find_anchor_wl_entry(&ubi->used, UBI_FM_MAX_START);
+		if (!e1)
+			goto out_cancel;
+		e2 = get_peb_for_wl(ubi);
+		if (!e2)
+			goto out_cancel;
+
+		self_check_in_wl_tree(ubi, e1, &ubi->used);
+		rb_erase(&e1->u.rb, &ubi->used);
+		dbg_wl("anchor-move PEB %d to PEB %d", e1->pnum, e2->pnum);
+	}
+	else if (!ubi->scrub.rb_node) {
 		/*
 		 * Now pick the least worn-out used physical eraseblock and a
 		 * highly worn-out free physical eraseblock. If the erase
@@ -1229,6 +1258,7 @@ static int ensure_wear_leveling(struct ubi_device *ubi, int nested)
 		goto out_cancel;
 	}
 
+	wrk->anchor = 0;
 	wrk->func = &wear_leveling_worker;
 	if (nested)
 		__schedule_ubi_work(ubi, wrk);
@@ -1244,6 +1274,32 @@ out_unlock:
 	return err;
 }
 
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
+
 /**
  * erase_worker - physical eraseblock erase worker function.
  * @ubi: UBI device description object
-- 
1.7.6.5

