Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab2F2POu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:14:50 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47841 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932136Ab2F2POp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:14:45 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 07/11] UBI: Fastmap: Fix scan regression
Date: Fri, 29 Jun 2012 17:14:25 +0200
Message-Id: <1340982869-77042-8-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340982869-77042-1-git-send-email-richard@nod.at>
References: <1340982869-77042-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... resuse scan_peb(), don't rescan the first 64 PEBs.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/attach.c  |  134 ++++++++++++++++++++++++++++++---------------
 drivers/mtd/ubi/fastmap.c |   64 ++--------------------
 drivers/mtd/ubi/ubi.h     |    2 +-
 3 files changed, 95 insertions(+), 105 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index 9878cc2..bc1e4bf 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -817,10 +817,11 @@ out_unlock:
  * successfully handled and a negative error code in case of failure.
  */
 static int scan_peb(struct ubi_device *ubi, struct ubi_attach_info *ai,
-		    int pnum)
+		    int pnum, int *vid, unsigned long long *sqnum,
+		    int find_fastmap)
 {
 	long long uninitialized_var(ec);
-	int err, bitflips = 0, vol_id, ec_err = 0;
+	int err, bitflips = 0, vol_id = -1, ec_err = 0;
 
 	dbg_bld("scan PEB %d", pnum);
 
@@ -991,8 +992,13 @@ static int scan_peb(struct ubi_device *ubi, struct ubi_attach_info *ai,
 	}
 
 	vol_id = be32_to_cpu(vidh->vol_id);
+	if (vid)
+		*vid = vol_id;
+	if (sqnum)
+		*sqnum = be64_to_cpu(vidh->sqnum);
 
-	if (vol_id > UBI_MAX_VOLUMES && vol_id != UBI_LAYOUT_VOLUME_ID) {
+	if (!find_fastmap &&
+	   (vol_id > UBI_MAX_VOLUMES && vol_id != UBI_LAYOUT_VOLUME_ID)) {
 		int lnum = be32_to_cpu(vidh->lnum);
 
 		/* Unsupported internal volume */
@@ -1221,7 +1227,7 @@ static void destroy_ai(struct ubi_device *ubi, struct ubi_attach_info *ai)
  * information about it in form of a "struct ubi_attach_info" object. In case
  * of failure, an error code is returned.
  */
-static int scan_all(struct ubi_device *ubi, struct ubi_attach_info *ai)
+static int scan_all(struct ubi_device *ubi, struct ubi_attach_info *ai, int start)
 {
 	int err, pnum;
 	struct rb_node *rb1, *rb2;
@@ -1229,11 +1235,6 @@ static int scan_all(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	struct ubi_ainf_peb *aeb;
 
 	err = -ENOMEM;
-	ai->aeb_slab_cache = kmem_cache_create("ubi_aeb_slab_cache",
-					       sizeof(struct ubi_ainf_peb),
-					       0, 0, NULL);
-	if (!ai->aeb_slab_cache)
-		goto out_ai;
 
 	ech = kzalloc(ubi->ec_hdr_alsize, GFP_KERNEL);
 	if (!ech)
@@ -1243,11 +1244,11 @@ static int scan_all(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	if (!vidh)
 		goto out_ech;
 
-	for (pnum = 0; pnum < ubi->peb_count; pnum++) {
+	for (pnum = start; pnum < ubi->peb_count; pnum++) {
 		cond_resched();
 
 		dbg_gen("process PEB %d", pnum);
-		err = scan_peb(ubi, ai, pnum);
+		err = scan_peb(ubi, ai, pnum, NULL, NULL, 0);
 		if (err < 0)
 			goto out_vidh;
 	}
@@ -1303,17 +1304,77 @@ out_ai:
 	return err;
 }
 
+/**
+ * scan_fastmap - try to find a fastmap and attach from it.
+ * @ubi: UBI device description object
+ * @ai: attach info object
+ */
+static int scan_fast(struct ubi_device *ubi, struct ubi_attach_info *ai)
+{
+	int err, pnum, fm_anchor = -1;
+	unsigned long long max_sqnum = 0;
+
+	err = -ENOMEM;
+
+	ech = kzalloc(ubi->ec_hdr_alsize, GFP_KERNEL);
+	if (!ech)
+		goto out_ai;
+
+	vidh = ubi_zalloc_vid_hdr(ubi, GFP_KERNEL);
+	if (!vidh)
+		goto out_ech;
+
+	for (pnum = 0; pnum < UBI_FM_MAX_START; pnum++) {
+		int vol_id = -1;
+		unsigned long long sqnum = -1;
+		cond_resched();
+
+		dbg_gen("process PEB %d", pnum);
+		err = scan_peb(ubi, ai, pnum, &vol_id, &sqnum, 1);
+		if (err < 0)
+			goto out_vidh;
+
+		if (vol_id == UBI_FM_SB_VOLUME_ID && sqnum > max_sqnum) {
+			max_sqnum = sqnum;
+			fm_anchor = pnum;
+		}
+	}
+
+	ubi_free_vid_hdr(ubi, vidh);
+	kfree(ech);
+
+	if (fm_anchor < 0)
+		return UBI_NO_FASTMAP;
+
+	return ubi_scan_fastmap(ubi, ai, fm_anchor);
+
+out_vidh:
+	ubi_free_vid_hdr(ubi, vidh);
+out_ech:
+	kfree(ech);
+out_ai:
+	destroy_ai(ubi, ai);
+	return err;
+}
 static struct ubi_attach_info *alloc_ai(void)
 {
-	static struct ubi_attach_info *ai;
+	struct ubi_attach_info *ai;
 
 	ai = kzalloc(sizeof(struct ubi_attach_info), GFP_KERNEL);
-	if (ai) {
-		INIT_LIST_HEAD(&ai->corr);
-		INIT_LIST_HEAD(&ai->free);
-		INIT_LIST_HEAD(&ai->erase);
-		INIT_LIST_HEAD(&ai->alien);
-		ai->volumes = RB_ROOT;
+	if (!ai)
+		return ai;
+
+	INIT_LIST_HEAD(&ai->corr);
+	INIT_LIST_HEAD(&ai->free);
+	INIT_LIST_HEAD(&ai->erase);
+	INIT_LIST_HEAD(&ai->alien);
+	ai->volumes = RB_ROOT;
+	ai->aeb_slab_cache = kmem_cache_create("ubi_aeb_slab_cache",
+					       sizeof(struct ubi_ainf_peb),
+					       0, 0, NULL);
+	if (!ai->aeb_slab_cache) {
+		kfree(ai);
+		ai = NULL;
 	}
 
 	return ai;
@@ -1337,35 +1398,18 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 		return -ENOMEM;
 
 	if (force_scan)
-		err = scan_all(ubi, ai);
+		err = scan_all(ubi, ai, 0);
 	else {
-		/* TODO: this is a regression. If I have an old image, and I do
-		 * not want to use fastmap, I will be forced to waste time for
-		 * useless scan of 64 first eraseblocks. Not good.
-		 *
-		 * Can you teach ubi_scan_fastmap() to use 'scan_peb()'
-		 * function for scanning and build normal ai information? If it
-		 * finds fastmap - it can destroy the collected ai. If it does
-		 * not find, it returns ai. Then you just confinue scanning.
-		 *
-		 * I buess what we'll need is:
-		 * 1. scan_all() -> scan_range(..., int pnum1, int pnum2);
-		 * 2. ubi_scan_fastmap() returns the pnum of the last scanned
-		 *    eraseblock if fastmap was not found;
-		 *    Also 'ubi_scan_fastmap()' uses scan_peb() for scanning.
-		 * 3. You call 'scan_range(..., pnum, c->peb_cnt - 1)' and
-		 *    it continues.
-		 *
-		 * And no regressions.
-		 */
-		err = ubi_scan_fastmap(ubi, ai);
+		err = scan_fast(ubi, ai);
 		if (err > 0) {
-			destroy_ai(ubi, ai);
-			ai = alloc_ai();
-			if (!ai)
-				return -ENOMEM;
+			if (err != UBI_NO_FASTMAP) {
+				destroy_ai(ubi, ai);
+				ai = alloc_ai();
+				if (!ai)
+					return -ENOMEM;
+			}
 
-			err = scan_all(ubi, ai);
+			err = scan_all(ubi, ai, UBI_FM_MAX_START);
 		}
 	}
 
@@ -1398,7 +1442,7 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 		if (!scan_ai)
 			goto out_wl;
 
-		err = scan_all(ubi, scan_ai);
+		err = scan_all(ubi, scan_ai, 0);
 		if (err) {
 			kfree(scan_ai);
 			goto out_wl;
diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 9b4fd34..6276039 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -819,82 +819,28 @@ fail:
 }
 
 /**
- * ubi_find_fastmap - searches the first UBI_FM_MAX_START PEBs for the
- * fastmap super block.
- * @ubi: UBI device object
- * @fm_start: Pointer where the fastmap suber block PEB number will be stored.
- *
- * Returns:
- *  - 0 on success: (fm_start contains suber block PEB number)
- *  - < 0 on failure (fm_start is -1)
- */
-static int ubi_find_fastmap(struct ubi_device *ubi, int *fm_start)
-{
-	int i, ret = -ENOENT;
-	struct ubi_vid_hdr *vhdr;
-	unsigned long long max_sqnum = 0, sqnum;
-
-	vhdr = ubi_zalloc_vid_hdr(ubi, GFP_KERNEL);
-	if (!vhdr)
-		return -ENOMEM;
-
-	*fm_start = -1;
-	for (i = 0; i < UBI_FM_MAX_START; i++) {
-		if (ubi_io_is_bad(ubi, i))
-			continue;
-
-		ret = ubi_io_read_vid_hdr(ubi, i, vhdr, 0);
-		if (ret < 0)
-			goto out;
-		else if (ret > 0 && ret != UBI_IO_BITFLIPS)
-			continue;
-
-		if (be32_to_cpu(vhdr->vol_id) == UBI_FM_SB_VOLUME_ID) {
-			sqnum = be64_to_cpu(vhdr->sqnum);
-			dbg_bld("found a fastmap super block at PEB %i " \
-				"sqnum: %llu", i, sqnum);
-
-			if (sqnum > max_sqnum) {
-				max_sqnum = sqnum;
-				*fm_start = i;
-			}
-		}
-	}
-
-	if (*fm_start > -1)
-		ret = 0;
-out:
-	ubi_free_vid_hdr(ubi, vhdr);
-	return ret;
-}
-
-/**
  * ubi_scan_fastmap - scan the fastmap.
  * @ubi: UBI device object
  * @ai: UBI attach info to be filled
+ * @fm_anchor: The fastmap starts at this PEB
  *
  * Returns 0 on success, UBI_NO_FASTMAP if no fastmap was found,
  * UBI_BAD_FASTMAP if one was found but is not usable.
  * < 0 indicates an internal error.
  */
-int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
+int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
+		     int fm_anchor)
 {
 	struct ubi_fm_sb *fmsb;
 	struct ubi_vid_hdr *vh;
 	struct ubi_ec_hdr *ech;
 	struct ubi_fastmap_layout *fm;
-	int i, used_blocks, pnum, sb_pnum = 0, ret = 0;
+	int i, used_blocks, pnum, ret = 0;
 	void *fm_raw = NULL;
 	size_t fm_size;
 	__be32 crc, tmp_crc;
 	unsigned long long sqnum = 0;
 
-	ret = ubi_find_fastmap(ubi, &sb_pnum);
-	if (ret)
-		return ret;
-	if (sb_pnum == -1)
-		return UBI_NO_FASTMAP;
-
 	fmsb = kmalloc(sizeof(*fmsb), GFP_KERNEL);
 	if (!fmsb) {
 		ret = -ENOMEM;
@@ -908,7 +854,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 		goto free_raw;
 	}
 
-	ret = ubi_io_read(ubi, fmsb, sb_pnum, ubi->leb_start, sizeof(*fmsb));
+	ret = ubi_io_read(ubi, fmsb, fm_anchor, ubi->leb_start, sizeof(*fmsb));
 	if (ret && ret != UBI_IO_BITFLIPS) {
 		kfree(fmsb);
 		kfree(fm);
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 8e2592d..fef9e92 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -816,7 +816,7 @@ int ubi_compare_lebs(struct ubi_device *ubi, const struct ubi_ainf_peb *aeb,
 
 /* fastmap.c */
 int ubi_update_fastmap(struct ubi_device *ubi);
-int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai);
+int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai, int fm_anchor);
 
 /*
  * ubi_rb_for_each_entry - walk an RB-tree.
-- 
1.7.6.5

