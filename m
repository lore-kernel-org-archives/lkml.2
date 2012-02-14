Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761165Ab2BNUzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 15:55:35 -0500
Received: from www.linutronix.de ([62.245.132.108]:51589 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250Ab2BNUzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 15:55:01 -0500
From: Richard Weinberger <rw@linutronix.de>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, tim.bird@am.sony.com,
        dedekind1@gmail.com, Richard Weinberger <rw@linutronix.de>
Subject: [RFC][PATCH 7/7] MTD: UBI: wire up checkpointing
Date: Tue, 14 Feb 2012 21:06:46 +0100
Message-Id: <1329250006-22944-8-git-send-email-rw@linutronix.de>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1329250006-22944-1-git-send-email-rw@linutronix.de>
References: <1329250006-22944-1-git-send-email-rw@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <rw@linutronix.de>
---
 drivers/mtd/ubi/build.c |   83 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 83 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 115749f..06c5c77 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -148,6 +148,17 @@ int ubi_volume_notify(struct ubi_device *ubi, struct ubi_volume *vol, int ntype)
 
 	ubi_do_get_device_info(ubi, &nt.di);
 	ubi_do_get_volume_info(ubi, vol, &nt.vi);
+
+#ifdef CONFIG_MTD_UBI_CHECKPOINT
+	switch (ntype) {
+		case UBI_VOLUME_ADDED:
+		case UBI_VOLUME_REMOVED:
+		case UBI_VOLUME_RESIZED:
+		case UBI_VOLUME_RENAMED:
+			if (ubi_update_checkpoint(ubi))
+				ubi_err("Unable to update checkpoint!");
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
@@ -931,6 +997,12 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num, int vid_hdr_offset)
 	ubi->vid_hdr_offset = vid_hdr_offset;
 	ubi->autoresize_vol_id = -1;
 
+#ifdef CONFIG_MTD_UBI_CHECKPOINT
+	ubi->long_pool.used = ubi->long_pool.size = ubi->long_pool.max_size = ARRAY_SIZE(ubi->long_pool.pebs);
+	ubi->short_pool.used = ubi->short_pool.size = ubi->short_pool.max_size = ARRAY_SIZE(ubi->short_pool.pebs);
+	ubi->unk_pool.used = ubi->unk_pool.size = ubi->unk_pool.max_size = ARRAY_SIZE(ubi->unk_pool.pebs);
+#endif
+
 	mutex_init(&ubi->buf_mutex);
 	mutex_init(&ubi->ckvol_mutex);
 	mutex_init(&ubi->device_mutex);
@@ -957,7 +1029,18 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num, int vid_hdr_offset)
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
-- 
1.7.7

