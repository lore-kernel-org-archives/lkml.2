Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab2FWNFl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 09:05:41 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47837 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526Ab2FWNDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 09:03:40 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/7] UBI: Fastmap: Ensure that not all anchor PEBs go into a pool.
Date: Sat, 23 Jun 2012 15:03:18 +0200
Message-Id: <1340456602-46050-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340456602-46050-1-git-send-email-richard@nod.at>
References: <1340456602-46050-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we have no fastmap on flash make sure that not all anchor
PEBs go into a WL pool such that at least one can be used
by fastmap.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/wl.c |   36 +++++++++++++++++++++++++++---------
 1 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index b4d4358..8b2af8f4 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -342,16 +342,18 @@ static void prot_queue_add(struct ubi_device *ubi, struct ubi_wl_entry *e)
 
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
+static struct ubi_wl_entry *find_wl_entry(struct ubi_device *ubi, struct rb_root *root,
+					  int diff)
 {
 	struct rb_node *p;
-	struct ubi_wl_entry *e;
+	struct ubi_wl_entry *e, *prev_e = NULL;
 	int max;
 
 	e = rb_entry(rb_first(root), struct ubi_wl_entry, u.rb);
@@ -366,32 +368,48 @@ static struct ubi_wl_entry *find_wl_entry(struct rb_root *root, int diff)
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
+	if (!ubi->fm && e->pnum < UBI_FM_MAX_START)
+		return prev_e;
+
 	return e;
 }
 
 /**
  * find_mean_wl_entry - find wear-leveling entry with medium erase counter.
+ * @ubi: UBI device description object
  * @root: the RB-tree where to look for
  *
  * This function looks for a wear leveling entry with medium erase counter,
  * but not greater or equivalent than the lowest erase counter plus
  * %WL_FREE_MAX_DIFF/2.
  */
-static struct ubi_wl_entry *find_mean_wl_entry(struct rb_root *root)
+static struct ubi_wl_entry *find_mean_wl_entry(struct ubi_device *ubi,
+					       struct rb_root *root)
 {
 	struct ubi_wl_entry *e, *first, *last;
 
 	first = rb_entry(rb_first(root), struct ubi_wl_entry, u.rb);
 	last = rb_entry(rb_last(root), struct ubi_wl_entry, u.rb);
 
-	if (last->ec - first->ec < WL_FREE_MAX_DIFF)
+	if (last->ec - first->ec < WL_FREE_MAX_DIFF) {
 		e = rb_entry(root->rb_node, struct ubi_wl_entry, u.rb);
+
+		/* If no fastmap has been written and this WL entry can be used
+		 * as anchor PEB, hold it back and return the second best WL entry
+		 * such that fastmap can use the anchor PEB later. */
+		if (e && !ubi->fm && e->pnum < UBI_FM_MAX_START)
+			e = rb_entry(rb_next(root->rb_node), struct ubi_wl_entry, u.rb);
+	}
 	else
-		e = find_wl_entry(root, WL_FREE_MAX_DIFF/2);
+		e = find_wl_entry(ubi, root, WL_FREE_MAX_DIFF/2);
 
 	return e;
 }
@@ -452,7 +470,7 @@ struct ubi_wl_entry *ubi_wl_get_fm_peb(struct ubi_device *ubi, int max_pnum)
 	}
 
 	if (max_pnum < 0)
-		e = find_mean_wl_entry(&ubi->free);
+		e = find_mean_wl_entry(ubi, &ubi->free);
 	else
 		e = find_anchor_wl_entry(&ubi->free, max_pnum);
 
@@ -494,7 +512,7 @@ retry:
 		goto retry;
 	}
 
-	e = find_mean_wl_entry(&ubi->free);
+	e = find_mean_wl_entry(ubi, &ubi->free);
 
 	self_check_in_wl_tree(ubi, e, &ubi->free);
 
@@ -547,7 +565,7 @@ static void refill_wl_pool(struct ubi_device *ubi)
 		if (!ubi->free.rb_node)
 			break;
 
-		e = find_wl_entry(&ubi->free, WL_FREE_MAX_DIFF);
+		e = find_wl_entry(ubi, &ubi->free, WL_FREE_MAX_DIFF);
 		self_check_in_wl_tree(ubi, e, &ubi->free);
 		rb_erase(&e->u.rb, &ubi->free);
 
@@ -1241,7 +1259,7 @@ static int ensure_wear_leveling(struct ubi_device *ubi, int nested)
 		 * %UBI_WL_THRESHOLD.
 		 */
 		e1 = rb_entry(rb_first(&ubi->used), struct ubi_wl_entry, u.rb);
-		e2 = find_wl_entry(&ubi->free, WL_FREE_MAX_DIFF);
+		e2 = find_wl_entry(ubi, &ubi->free, WL_FREE_MAX_DIFF);
 
 		if (!(e2->ec - e1->ec >= UBI_WL_THRESHOLD))
 			goto out_unlock;
-- 
1.7.6.5

