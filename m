Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933766Ab2GDIIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 04:08:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60915 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932767Ab2GDII1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 04:08:27 -0400
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 2/5] ubi: Limit amount of reserved eraseblocks for bad PEB handling
Date: Wed,  4 Jul 2012 11:06:01 +0300
Message-Id: <1341389164-24409-3-git-send-email-shmulik.ladkani@gmail.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1341389164-24409-1-git-send-email-shmulik.ladkani@gmail.com>
References: <1341389164-24409-1-git-send-email-shmulik.ladkani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing mechanism of reserving PEBs for bad PEB handling has two
flaws:
- It is calculated as a percentage of good PEBs instead of total PEBs.
- There's no limit on the amount of PEBs UBI reserves for future bad
  eraseblock handling.

This patch changes the mechanism to overcome these flaws.

The desired level of PEBs reserved for bad PEB handling (beb_rsvd_level)
is set to the maximum expected bad eraseblocks (bad_peb_limit) minus the
existing number of bad eraseblocks (bad_peb_count).

The actual amount of PEBs reserved for bad PEB handling is usually set
to the desired level (but in some circumstances may be lower than the
desired level, e.g. when attaching to a device that has too few
available PEBs to satisfy the desired level).

In the case where the device has too many bad PEBs (above the expected
limit), then the desired level, and the actual amount of PEBs reserved
are set to zero. No PEBs will be set aside for future bad eraseblock
handling - even if some PEBs are made available (e.g. by shrinking a
volume).
If another PEB goes bad, and there are available PEBs, then the
eraseblock will be marked bad (consuming one available PEB). But if
there are no available PEBs, ubi will go into readonly mode.

Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
---
 drivers/mtd/ubi/Kconfig |    8 ++++++++
 drivers/mtd/ubi/misc.c  |   16 ++++++++++++----
 drivers/mtd/ubi/wl.c    |   44 ++++++++++++++++++++++++++++----------------
 3 files changed, 48 insertions(+), 20 deletions(-)

diff --git a/drivers/mtd/ubi/Kconfig b/drivers/mtd/ubi/Kconfig
index 8df256f..7eb91cb 100644
--- a/drivers/mtd/ubi/Kconfig
+++ b/drivers/mtd/ubi/Kconfig
@@ -47,8 +47,16 @@ config MTD_UBI_BEB_LIMIT
 	default 2
 	range 0 25
 	help
+	  If the MTD device admits of bad eraseblocks (e.g. NAND flash), UBI
+	  reserves some amount of physical eraseblocks to handle new bad
+	  eraseblocks.
 	  This option specifies the maximum bad eraseblocks UBI expects on the
 	  ubi device (percents of total number of flash eraseblocks).
+	  This limit is used in order to derive amount of eraseblock UBI
+	  reserves for handling new bad blocks.
+	  If the device has more bad eraseblocks than this limit, UBI does not
+	  reserve any physical eraseblocks for new bad eraseblocks, but
+	  attempts to use available eraseblocks (if any).
 	  If the underlying flash does not admit of bad eraseblocks (e.g. NOR
 	  flash), this value is ignored.
 	  Leave the default value if unsure.
diff --git a/drivers/mtd/ubi/misc.c b/drivers/mtd/ubi/misc.c
index f6a7d7a..e9dcb83 100644
--- a/drivers/mtd/ubi/misc.c
+++ b/drivers/mtd/ubi/misc.c
@@ -98,10 +98,18 @@ int ubi_check_volume(struct ubi_device *ubi, int vol_id)
  */
 void ubi_calculate_reserved(struct ubi_device *ubi)
 {
-	ubi->beb_rsvd_level = ubi->good_peb_count/100;
-	ubi->beb_rsvd_level *= CONFIG_MTD_UBI_BEB_RESERVE;
-	if (ubi->beb_rsvd_level < MIN_RESEVED_PEBS)
-		ubi->beb_rsvd_level = MIN_RESEVED_PEBS;
+	/*
+	 * Calculate the actual number of PEBs currently needed to be reserved
+	 * for future bad eraseblock handling.
+	 */
+	ubi->beb_rsvd_level = ubi->bad_peb_limit - ubi->bad_peb_count;
+	if (ubi->beb_rsvd_level < 0) {
+		ubi->beb_rsvd_level = 0;
+		ubi_warn("number of bad PEBs (%d) is above the expected limit "
+			 "(%d), not reserving any PEBs for bad PEB handling, "
+			 "will use available PEBs (if any)",
+			 ubi->bad_peb_count, ubi->bad_peb_limit);
+	}
 }
 
 /**
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index b6be644..9143f35 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -978,9 +978,10 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 			int cancel)
 {
 	struct ubi_wl_entry *e = wl_wrk->e;
-	int pnum = e->pnum, err, need;
+	int pnum = e->pnum, err;
 	int vol_id = wl_wrk->vol_id;
 	int lnum = wl_wrk->lnum;
+	int available_consumed = 0;
 
 	if (cancel) {
 		dbg_wl("cancel erasure of PEB %d EC %d", pnum, e->ec);
@@ -1045,20 +1046,14 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 	}
 
 	spin_lock(&ubi->volumes_lock);
-	need = ubi->beb_rsvd_level - ubi->beb_rsvd_pebs + 1;
-	if (need > 0) {
-		need = ubi->avail_pebs >= need ? need : ubi->avail_pebs;
-		ubi->avail_pebs -= need;
-		ubi->rsvd_pebs += need;
-		ubi->beb_rsvd_pebs += need;
-		if (need > 0)
-			ubi_msg("reserve more %d PEBs", need);
-	}
-
 	if (ubi->beb_rsvd_pebs == 0) {
-		spin_unlock(&ubi->volumes_lock);
-		ubi_err("no reserved physical eraseblocks");
-		goto out_ro;
+		if (ubi->avail_pebs == 0) {
+			spin_unlock(&ubi->volumes_lock);
+			ubi_err("no reserved/available physical eraseblocks");
+			goto out_ro;
+		}
+		ubi->avail_pebs -= 1;
+		available_consumed = 1;
 	}
 	spin_unlock(&ubi->volumes_lock);
 
@@ -1068,11 +1063,23 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 		goto out_ro;
 
 	spin_lock(&ubi->volumes_lock);
-	ubi->beb_rsvd_pebs -= 1;
+	if (ubi->beb_rsvd_pebs > 0) {
+		if (available_consumed) {
+			/*
+			 * Some PEBs were added to the reserved pool since we
+			 * last checked. Use a PEB from the reserved pool.
+			 */
+			ubi->avail_pebs += 1;
+			available_consumed = 0;
+		}
+		ubi->beb_rsvd_pebs -= 1;
+	}
 	ubi->bad_peb_count += 1;
 	ubi->good_peb_count -= 1;
 	ubi_calculate_reserved(ubi);
-	if (ubi->beb_rsvd_pebs)
+	if (available_consumed)
+		ubi_warn("no PEBs in the reserved pool, used an available PEB");
+	else if (ubi->beb_rsvd_pebs)
 		ubi_msg("%d PEBs left in the reserve", ubi->beb_rsvd_pebs);
 	else
 		ubi_warn("last PEB from the reserved pool was used");
@@ -1081,6 +1088,11 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 	return err;
 
 out_ro:
+	if (available_consumed) {
+		spin_lock(&ubi->volumes_lock);
+		ubi->avail_pebs += 1;
+		spin_unlock(&ubi->volumes_lock);
+	}
 	ubi_ro_mode(ubi);
 	return err;
 }
-- 
1.7.9

