Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552Ab2EIRkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:40:21 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47841 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757853Ab2EIRjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:39:09 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: tim.bird@am.sony.com, tglx@linutronix.de, dedekind1@gmail.com,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 7/7] [RFC] UBI: wire up checkpointing
Date: Wed,  9 May 2012 19:38:45 +0200
Message-Id: <1336585125-127220-8-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1336585125-127220-1-git-send-email-richard@nod.at>
References: <1336585125-127220-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/Kconfig      |   29 ++++++++++++++-
 drivers/mtd/ubi/build.c      |   86 ++++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/ubi/checkpoint.c |    4 ++
 drivers/mtd/ubi/ubi-media.h  |    6 +-
 4 files changed, 121 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/ubi/Kconfig b/drivers/mtd/ubi/Kconfig
index 3ba9978..12888a4 100644
--- a/drivers/mtd/ubi/Kconfig
+++ b/drivers/mtd/ubi/Kconfig
@@ -56,10 +56,37 @@ config MTD_UBI_CHECKPOINT
 	depends on EXPERIMENTAL
 	default n
 	help
-	   This option enables UBIVIS (AKA checkpointing).
+	   This option enables UBIVIS (aka checkpointing).
 	   It allows attaching UBI devices without scanning the whole MTD
 	   device. Instead it extracts all needed information from a checkpoint.
 
+config MTD_UBI_CHECKPOINT_POOL_SIZE
+	int "Max number of PEBs in a UBIVIS pool"
+	range 10 1024
+	default 128
+	help
+	   This is the number PEBs which have to be scanned while attaching.
+	   A low value means that attaching will be faster but if the value
+	   is too small the checkpoint has to be written too often.
+	   Every time the pool is full a new checkpoint is written to the MTD.
+	   Note that we have currently three pools.
+	   Choose wisely!
+
+config MTD_UBI_CHECKPOINT_MAX_SIZE
+	int "Maximal size of a checkpoint in PEBs"
+	range 10 128
+	default 32
+	help
+	   Maximale size of a checkpoint in PEBs.
+
+config MTD_UBI_CHECKPOINT_SB_POS
+	int "Checkpoint super block position"
+	range 4 128
+	default 64
+	help
+	   The checkpoint super block will be placed within the first N PEBs.
+	   Is this value too large it takes longer to find the checkpoint.
+
 config MTD_UBI_DEBUG
 	bool "UBI debugging"
 	depends on SYSFS
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 0fde9fc..316f27a 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -148,6 +148,17 @@ int ubi_volume_notify(struct ubi_device *ubi, struct ubi_volume *vol, int ntype)
 
 	ubi_do_get_device_info(ubi, &nt.di);
 	ubi_do_get_volume_info(ubi, vol, &nt.vi);
+
+#ifdef CONFIG_MTD_UBI_CHECKPOINT
+	switch (ntype) {
+	case UBI_VOLUME_ADDED:
+	case UBI_VOLUME_REMOVED:
+	case UBI_VOLUME_RESIZED:
+	case UBI_VOLUME_RENAMED:
+		if (ubi_update_checkpoint(ubi))
+			ubi_err("Unable to update checkpoint!");
+	}
+#endif
 	return blocking_notifier_call_chain(&ubi_notifiers, ntype, &nt);
 }
 
@@ -852,6 +863,61 @@ static int autoresize(struct ubi_device *ubi, int vol_id)
 	return 0;
 }
 
+#ifdef CONFIG_MTD_UBI_CHECKPOINT
+static int attach_by_checkpointing(struct ubi_device *ubi)
+{
+	int cp_start, err;
+	struct ubi_scan_info *si;
+
+	cp_start = ubi_find_checkpoint(ubi);
+	if (cp_start < 0)
+		return -ENOENT;
+
+	si = ubi_read_checkpoint(ubi, cp_start);
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
+	ubi_msg("successfully recovered from checkpoint!");
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
+#endif
+
 /**
  * ubi_attach_mtd_dev - attach an MTD device.
  * @mtd: MTD device description object
@@ -931,6 +997,15 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num, int vid_hdr_offset)
 	ubi->vid_hdr_offset = vid_hdr_offset;
 	ubi->autoresize_vol_id = -1;
 
+#ifdef CONFIG_MTD_UBI_CHECKPOINT
+	ubi->long_pool.used = ubi->long_pool.size = \
+		ubi->long_pool.max_size = ARRAY_SIZE(ubi->long_pool.pebs);
+	ubi->short_pool.used = ubi->short_pool.size = \
+		ubi->short_pool.max_size = ARRAY_SIZE(ubi->short_pool.pebs);
+	ubi->unk_pool.used = ubi->unk_pool.size = \
+		ubi->unk_pool.max_size = ARRAY_SIZE(ubi->unk_pool.pebs);
+#endif
+
 	mutex_init(&ubi->buf_mutex);
 	mutex_init(&ubi->ckvol_mutex);
 	mutex_init(&ubi->device_mutex);
@@ -953,7 +1028,18 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num, int vid_hdr_offset)
 	if (err)
 		goto out_free;
 
+#ifdef CONFIG_MTD_UBI_CHECKPOINT
+	err = attach_by_checkpointing(ubi);
+
+	if (err) {
+		if (err != -ENOENT)
+			ubi_msg("falling back to attach by scanning mode!\n");
+
+		err = attach_by_scanning(ubi);
+	}
+#else
 	err = attach_by_scanning(ubi);
+#endif
 	if (err) {
 		dbg_err("failed to attach by scanning, error %d", err);
 		goto out_debugging;
diff --git a/drivers/mtd/ubi/checkpoint.c b/drivers/mtd/ubi/checkpoint.c
index f43441c..867f32d 100644
--- a/drivers/mtd/ubi/checkpoint.c
+++ b/drivers/mtd/ubi/checkpoint.c
@@ -993,6 +993,10 @@ int ubi_update_checkpoint(struct ubi_device *ubi)
 	int ret, i;
 	struct ubi_checkpoint *new_cp;
 
+	BUILD_BUG_ON(UBI_CP_MAX_START < 3);
+	BUILD_BUG_ON(UBI_CP_MAX_BLOCKS < 10);
+	BUILD_BUG_ON(UBI_CP_MAX_POOL_SIZE < 10);
+
 	if (ubi->ro_mode)
 		return 0;
 
diff --git a/drivers/mtd/ubi/ubi-media.h b/drivers/mtd/ubi/ubi-media.h
index 7223b02..4d14b9e 100644
--- a/drivers/mtd/ubi/ubi-media.h
+++ b/drivers/mtd/ubi/ubi-media.h
@@ -382,9 +382,9 @@ struct ubi_vtbl_record {
 /* Checkoint format version */
 #define UBI_CP_FMT_VERSION	1
 
-#define UBI_CP_MAX_START	64
-#define UBI_CP_MAX_BLOCKS	32
-#define UBI_CP_MAX_POOL_SIZE	128
+#define UBI_CP_MAX_START	CONFIG_MTD_UBI_CHECKPOINT_SB_POS
+#define UBI_CP_MAX_BLOCKS	CONFIG_MTD_UBI_CHECKPOINT_MAX_SIZE
+#define UBI_CP_MAX_POOL_SIZE	CONFIG_MTD_UBI_CHECKPOINT_POOL_SIZE
 #define UBI_CP_SB_MAGIC		0x7B11D69F
 #define UBI_CP_HDR_MAGIC	0xD4B82EF7
 #define UBI_CP_VHDR_MAGIC	0xFA370ED1
-- 
1.7.6.5

