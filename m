Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552Ab2EPUwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 16:52:41 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47841 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757560Ab2EPUwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 16:52:16 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: tglx@linutronix.de, dedekind1@gmail.com, linux-kernel@vger.kernel.org,
        Heinz.Egger@linutronix.de, tim.bird@am.sony.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 7/7] [RFC] UBI: Wire up fastmap support
Date: Wed, 16 May 2012 22:52:02 +0200
Message-Id: <1337201522-86521-8-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1337201522-86521-1-git-send-email-richard@nod.at>
References: <1337201522-86521-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit enables fastmap per default.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/Kconfig     |   26 +++++++++++++++
 drivers/mtd/ubi/build.c     |   76 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/mtd/ubi/scan.c      |    5 ++-
 drivers/mtd/ubi/ubi-media.h |   13 ++------
 drivers/mtd/ubi/wl.c        |   32 +++++++++++++++++-
 5 files changed, 137 insertions(+), 15 deletions(-)

diff --git a/drivers/mtd/ubi/Kconfig b/drivers/mtd/ubi/Kconfig
index 4dcc752..fd09f10 100644
--- a/drivers/mtd/ubi/Kconfig
+++ b/drivers/mtd/ubi/Kconfig
@@ -42,6 +42,32 @@ config MTD_UBI_BEB_RESERVE
 	  eraseblocks (e.g. NOR flash), this value is ignored and nothing is
 	  reserved. Leave the default value if unsure.
 
+config MTD_UBI_FM_POOL_SIZE
+	int "Max number of PEBs in a fastmap pool"
+	range 10 1024
+	default 128
+	help
+	   This is the number PEBs which have to be scanned while attaching.
+	   A low value means that attaching will be faster but if the value
+	   is too small the fastmap has to be written too often.
+	   Every time the pool is full a new fastmap is written to the MTD.
+	   Choose wisely!
+
+config MTD_UBI_FM_MAX_SIZE
+	int "Maximal size of a fastmap in PEBs"
+	range 10 128
+	default 32
+	help
+	   Maximale size of a checkpoint in PEBs.
+
+config MTD_UBI_FM_SB_POS
+	int "Fastmap super block position"
+	range 4 128
+	default 64
+	help
+	   The fastmap super block will be placed within the first N PEBs.
+	   Is this value too large it takes longer to find the checkpoint.
+
 config MTD_UBI_GLUEBI
 	tristate "MTD devices emulation driver (gluebi)"
 	help
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 0fde9fc..2399511 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -148,6 +148,16 @@ int ubi_volume_notify(struct ubi_device *ubi, struct ubi_volume *vol, int ntype)
 
 	ubi_do_get_device_info(ubi, &nt.di);
 	ubi_do_get_volume_info(ubi, vol, &nt.vi);
+
+	switch (ntype) {
+	case UBI_VOLUME_ADDED:
+	case UBI_VOLUME_REMOVED:
+	case UBI_VOLUME_RESIZED:
+	case UBI_VOLUME_RENAMED:
+		if (ubi_update_fastmap(ubi))
+			ubi_err("Unable to update fastmap!");
+	}
+
 	return blocking_notifier_call_chain(&ubi_notifiers, ntype, &nt);
 }
 
@@ -852,6 +862,59 @@ static int autoresize(struct ubi_device *ubi, int vol_id)
 	return 0;
 }
 
+static int attach_by_fastmap(struct ubi_device *ubi)
+{
+	int fm_start, err;
+	struct ubi_scan_info *si;
+
+	fm_start = ubi_find_fastmap(ubi);
+	if (fm_start < 0)
+		return -ENOENT;
+
+	si = ubi_read_fastmap(ubi, fm_start);
+	if (IS_ERR(si))
+		return PTR_ERR(si);
+
+	ubi->bad_peb_count = 0;
+	ubi->good_peb_count = ubi->peb_count;
+	ubi->corr_peb_count = 0;
+	ubi->max_ec = si->max_ec;
+	ubi->mean_ec = si->mean_ec;
+	ubi_msg("max. sequence number:       %llu", si->max_sqnum);
+
+	err = ubi_read_volume_table(ubi, si);
+	if (err) {
+		ubi_err("ubi_read_volume_table failed");
+		goto out_si;
+	}
+
+	err = ubi_wl_init_scan(ubi, si);
+	if (err) {
+		ubi_err("ubi_wl_init_scan failed!");
+		goto out_vtbl;
+	}
+
+	err = ubi_eba_init_scan(ubi, si);
+	if (err) {
+		ubi_err("ubi_eba_init_scan failed!");
+		goto out_wl;
+	}
+
+	ubi_msg("successfully attached via fastmapping!");
+	ubi_scan_destroy_si(si);
+	return 0;
+
+out_wl:
+	ubi_wl_close(ubi);
+out_vtbl:
+	free_internal_volumes(ubi);
+	vfree(ubi->vtbl);
+out_si:
+	ubi_scan_destroy_si(si);
+
+	return err;
+}
+
 /**
  * ubi_attach_mtd_dev - attach an MTD device.
  * @mtd: MTD device description object
@@ -931,6 +994,9 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num, int vid_hdr_offset)
 	ubi->vid_hdr_offset = vid_hdr_offset;
 	ubi->autoresize_vol_id = -1;
 
+	ubi->fm_pool.used = ubi->fm_pool.size = 0;
+	ubi->fm_pool.max_size = ARRAY_SIZE(ubi->fm_pool.pebs);
+
 	mutex_init(&ubi->buf_mutex);
 	mutex_init(&ubi->ckvol_mutex);
 	mutex_init(&ubi->device_mutex);
@@ -953,7 +1019,15 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num, int vid_hdr_offset)
 	if (err)
 		goto out_free;
 
-	err = attach_by_scanning(ubi);
+	err = attach_by_fastmap(ubi);
+	if (err) {
+		if (err != -ENOENT)
+			ubi_msg("falling back to attach by scanning mode!");
+
+		ubi->attached_by_scanning = true;
+		err = attach_by_scanning(ubi);
+	}
+
 	if (err) {
 		dbg_err("failed to attach by scanning, error %d", err);
 		goto out_debugging;
diff --git a/drivers/mtd/ubi/scan.c b/drivers/mtd/ubi/scan.c
index b4ab79f..2408a0d 100644
--- a/drivers/mtd/ubi/scan.c
+++ b/drivers/mtd/ubi/scan.c
@@ -1014,8 +1014,9 @@ static int process_eb(struct ubi_device *ubi, struct ubi_scan_info *si,
 
 	if (vol_id > UBI_MAX_VOLUMES &&
 		vol_id != UBI_LAYOUT_VOLUME_ID &&
-		vol_id != UBI_FM_SB_VOLUME_ID &&
-		vol_id != UBI_FM_DATA_VOLUME_ID) {
+		((vol_id != UBI_FM_SB_VOLUME_ID &&
+		vol_id != UBI_FM_DATA_VOLUME_ID) ||
+		ubi->attached_by_scanning == true)) {
 		int lnum = be32_to_cpu(vidh->lnum);
 
 		/* Unsupported internal volume */
diff --git a/drivers/mtd/ubi/ubi-media.h b/drivers/mtd/ubi/ubi-media.h
index a23196f..19ddbba 100644
--- a/drivers/mtd/ubi/ubi-media.h
+++ b/drivers/mtd/ubi/ubi-media.h
@@ -389,16 +389,9 @@ struct ubi_vtbl_record {
 #define UBI_FM_POOL_MAGIC	0x67AF4D08
 #define UBI_FM_EBA_MAGIC	0xf0c040a8
 
-/* Semi-sane default values - TBR */
-#ifndef UBI_FM_MAX_POOL_SIZE
-#define UBI_FM_MAX_POOL_SIZE	128
-#endif
-#ifndef UBI_FM_MAX_BLOCKS
-#define UBI_FM_MAX_BLOCKS	32
-#endif
-#ifndef UBI_FM_MAX_START
-#define UBI_FM_MAX_START	64
-#endif
+#define UBI_FM_MAX_START	CONFIG_MTD_UBI_FM_SB_POS
+#define UBI_FM_MAX_BLOCKS	CONFIG_MTD_UBI_FM_MAX_SIZE
+#define UBI_FM_MAX_POOL_SIZE	CONFIG_MTD_UBI_FM_POOL_SIZE
 
 /**
  * struct ubi_fm_sb - UBI fastmap super block
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index a329358..c94a84a 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -393,7 +393,6 @@ static struct ubi_wl_entry *find_wl_entry(struct rb_root *root, int diff)
 }
 
 /**
- * ubi_wl_get_peb - get a physical eraseblock.
  * find_early_wl_entry - find wear-leveling entry with a low pnum.
  * @root: the RB-tree where to look for
  * @max_pnum: highest possible pnum
@@ -451,12 +450,13 @@ out:
 }
 
 /**
+ * __ubi_wl_get_peb - get a physical eraseblock.
  * @ubi: UBI device description object
  *
  * This function returns a physical eraseblock in case of success and a
  * negative error code in case of failure. Might sleep.
  */
-int ubi_wl_get_peb(struct ubi_device *ubi)
+static int __ubi_wl_get_peb(struct ubi_device *ubi)
 {
 	int err;
 	struct ubi_wl_entry *e, *first, *last;
@@ -507,6 +507,34 @@ retry:
 	return e->pnum;
 }
 
+/* ubi_wl_get_peb - works exaclty like __ubi_wl_get_peb but keeps track of
+ * the fastmap pool.
+ */
+int ubi_wl_get_peb(struct ubi_device *ubi)
+{
+	struct ubi_fm_pool *pool = &ubi->fm_pool;
+
+	/* pool contains no free blocks, create a new one
+	 * and write a fastmap */
+	if (pool->used == pool->size || !pool->size) {
+		for (pool->size = 0; pool->size < pool->max_size;
+				pool->size++) {
+			pool->pebs[pool->size] = __ubi_wl_get_peb(ubi);
+			if (pool->pebs[pool->size] < 0)
+				break;
+		}
+
+		pool->used = 0;
+		ubi_update_fastmap(ubi);
+	}
+
+	/* we got not a single free PEB */
+	if (!pool->size)
+		return -1;
+
+	return pool->pebs[pool->used++];
+}
+
 /**
  * prot_queue_del - remove a physical eraseblock from the protection queue.
  * @ubi: UBI device description object
-- 
1.7.6.5

