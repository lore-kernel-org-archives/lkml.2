Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab2IZPxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 11:53:36 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47839 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756887Ab2IZPwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 11:52:11 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Heinz.Egger@linutronix.de, artem.bityutskiy@linux.intel.com,
        tim.bird@am.sony.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 05/10] UBI: Add fastmap bits to build.c
Date: Wed, 26 Sep 2012 17:51:45 +0200
Message-Id: <1348674710-102885-6-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1348674710-102885-1-git-send-email-richard@nod.at>
References: <1348674710-102885-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/build.c |   68 ++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 65 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 3497703..c9b99be 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -76,7 +76,10 @@ static int __initdata mtd_devs;
 
 /* MTD devices specification parameters */
 static struct mtd_dev_param __initdata mtd_dev_param[UBI_MAX_DEVICES];
-
+#ifdef CONFIG_MTD_UBI_FASTMAP
+/* UBI module parameter to enable fastmap automatically on non-fastmap images */
+static bool fm_autoconvert;
+#endif
 /* Root UBI "class" object (corresponds to '/<sysfs>/class/ubi/') */
 struct class *ubi_class;
 
@@ -153,6 +156,19 @@ int ubi_volume_notify(struct ubi_device *ubi, struct ubi_volume *vol, int ntype)
 
 	ubi_do_get_device_info(ubi, &nt.di);
 	ubi_do_get_volume_info(ubi, vol, &nt.vi);
+
+#ifdef CONFIG_MTD_UBI_FASTMAP
+	switch (ntype) {
+	case UBI_VOLUME_ADDED:
+	case UBI_VOLUME_REMOVED:
+	case UBI_VOLUME_RESIZED:
+	case UBI_VOLUME_RENAMED:
+		if (ubi_update_fastmap(ubi)) {
+			ubi_err("Unable to update fastmap!");
+			ubi_ro_mode(ubi);
+		}
+	}
+#endif
 	return blocking_notifier_call_chain(&ubi_notifiers, ntype, &nt);
 }
 
@@ -918,10 +934,40 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 	ubi->vid_hdr_offset = vid_hdr_offset;
 	ubi->autoresize_vol_id = -1;
 
+#ifdef CONFIG_MTD_UBI_FASTMAP
+	ubi->fm_pool.used = ubi->fm_pool.size = 0;
+	ubi->fm_wl_pool.used = ubi->fm_wl_pool.size = 0;
+
+	/*
+	 * fm_pool.max_size is 5% of the total number of PEBs but it's also
+	 * between UBI_FM_MAX_POOL_SIZE and UBI_FM_MIN_POOL_SIZE.
+	 */
+	ubi->fm_pool.max_size = min(((int)mtd_div_by_eb(ubi->mtd->size,
+		ubi->mtd) / 100) * 5, UBI_FM_MAX_POOL_SIZE);
+	if (ubi->fm_pool.max_size < UBI_FM_MIN_POOL_SIZE)
+		ubi->fm_pool.max_size = UBI_FM_MIN_POOL_SIZE;
+
+	ubi->fm_wl_pool.max_size = UBI_FM_WL_POOL_SIZE;
+	ubi->fm_disabled = !fm_autoconvert;
+
+	if (!ubi->fm_disabled && (int)mtd_div_by_eb(ubi->mtd->size, ubi->mtd)
+	    <= UBI_FM_MAX_START) {
+		ubi_err("More than %i PEBs are needed for fastmap, sorry.",
+			UBI_FM_MAX_START);
+		ubi->fm_disabled = 1;
+	}
+
+	ubi_msg("default fastmap pool size: %d", ubi->fm_pool.max_size);
+	ubi_msg("default fastmap WL pool size: %d", ubi->fm_wl_pool.max_size);
+#else
+	ubi->fm_disabled = 1;
+#endif
 	mutex_init(&ubi->buf_mutex);
 	mutex_init(&ubi->ckvol_mutex);
 	mutex_init(&ubi->device_mutex);
 	spin_lock_init(&ubi->volumes_lock);
+	mutex_init(&ubi->fm_mutex);
+	init_rwsem(&ubi->fm_sem);
 
 	ubi_msg("attaching mtd%d to ubi%d", mtd->index, ubi_num);
 
@@ -934,6 +980,12 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 	if (!ubi->peb_buf)
 		goto out_free;
 
+#ifdef CONFIG_MTD_UBI_FASTMAP
+	ubi->fm_size = ubi_calc_fm_size(ubi);
+	ubi->fm_buf = vzalloc(ubi->fm_size);
+	if (!ubi->fm_buf)
+		goto out_free;
+#endif
 	err = ubi_debugging_init_dev(ubi);
 	if (err)
 		goto out_free;
@@ -1012,6 +1064,7 @@ out_debugging:
 	ubi_debugging_exit_dev(ubi);
 out_free:
 	vfree(ubi->peb_buf);
+	vfree(ubi->fm_buf);
 	if (ref)
 		put_device(&ubi->dev);
 	else
@@ -1061,7 +1114,11 @@ int ubi_detach_mtd_dev(int ubi_num, int anyway)
 	ubi_assert(ubi_num == ubi->ubi_num);
 	ubi_notify_all(ubi, UBI_VOLUME_REMOVED, NULL);
 	ubi_msg("detaching mtd%d from ubi%d", ubi->mtd->index, ubi_num);
-
+#ifdef CONFIG_MTD_UBI_FASTMAP
+	/* If we don't write a new fastmap at detach time we lose all
+	 * EC updates that have been made since the last written fastmap. */
+	ubi_update_fastmap(ubi);
+#endif
 	/*
 	 * Before freeing anything, we have to stop the background thread to
 	 * prevent it from doing anything on this device while we are freeing.
@@ -1077,12 +1134,14 @@ int ubi_detach_mtd_dev(int ubi_num, int anyway)
 
 	ubi_debugfs_exit_dev(ubi);
 	uif_close(ubi);
+
 	ubi_wl_close(ubi);
 	ubi_free_internal_volumes(ubi);
 	vfree(ubi->vtbl);
 	put_mtd_device(ubi->mtd);
 	ubi_debugging_exit_dev(ubi);
 	vfree(ubi->peb_buf);
+	vfree(ubi->fm_buf);
 	ubi_msg("mtd%d is detached from ubi%d", ubi->mtd->index, ubi->ubi_num);
 	put_device(&ubi->dev);
 	return 0;
@@ -1404,7 +1463,10 @@ MODULE_PARM_DESC(mtd, "MTD devices to attach. Parameter format: mtd=<name|num|pa
 		      "Example 2: mtd=content,1984 mtd=4 - attach MTD device with name \"content\" using VID header offset 1984, and MTD device number 4 with default VID header offset.\n"
 		      "Example 3: mtd=/dev/mtd1,0,25 - attach MTD device /dev/mtd1 using default VID header offset and reserve 25*nand_size_in_blocks/1024 erase blocks for bad block handling.\n"
 		      "\t(e.g. if the NAND *chipset* has 4096 PEB, 100 will be reserved for this UBI device).");
-
+#ifdef CONFIG_MTD_UBI_FASTMAP
+module_param(fm_autoconvert, bool, 0644);
+MODULE_PARM_DESC(fm_autoconvert, "Set this parameter to enable fastmap automatically on images without a fastmap.");
+#endif
 MODULE_VERSION(__stringify(UBI_VERSION));
 MODULE_DESCRIPTION("UBI - Unsorted Block Images");
 MODULE_AUTHOR("Artem Bityutskiy");
-- 
1.7.6.5

