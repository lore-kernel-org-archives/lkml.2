Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab2GBQXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 12:23:42 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47837 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689Ab2GBQXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 12:23:39 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/3] UBI: Fastmap: Simplify fastmap buffers
Date: Mon,  2 Jul 2012 18:23:19 +0200
Message-Id: <1341246199-7198-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1341246199-7198-1-git-send-email-richard@nod.at>
References: <1341246199-7198-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not call vzalloc()/vfree() every time we write a fastmap.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/build.c   |    7 +++
 drivers/mtd/ubi/fastmap.c |   92 +++++++++++++++++++++++----------------------
 drivers/mtd/ubi/ubi.h     |   11 +++--
 3 files changed, 60 insertions(+), 50 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 0ffa2c9..664c05e 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -926,6 +926,11 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num, int vid_hdr_offset)
 	if (!ubi->peb_buf)
 		goto out_free;
 
+	ubi->fm_size = ubi_calc_fm_size(ubi);
+	ubi->fm_buf = vzalloc(ubi->fm_size);
+	if (!ubi->fm_buf)
+		goto out_free;
+
 	err = ubi_debugging_init_dev(ubi);
 	if (err)
 		goto out_free;
@@ -1003,6 +1008,7 @@ out_debugging:
 	ubi_debugging_exit_dev(ubi);
 out_free:
 	vfree(ubi->peb_buf);
+	vfree(ubi->fm_buf);
 	if (ref)
 		put_device(&ubi->dev);
 	else
@@ -1077,6 +1083,7 @@ int ubi_detach_mtd_dev(int ubi_num, int anyway)
 	put_mtd_device(ubi->mtd);
 	ubi_debugging_exit_dev(ubi);
 	vfree(ubi->peb_buf);
+	vfree(ubi->fm_buf);
 	ubi_msg("mtd%d is detached from ubi%d", ubi->mtd->index, ubi->ubi_num);
 	put_device(&ubi->dev);
 	return 0;
diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index d995105..44b95ce 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -17,6 +17,25 @@
 #include "ubi.h"
 
 /**
+ * ubi_calc_fm_size - calculates the fastmap size in bytes for an UBI device.
+ * @ubi: UBI device description object
+ */
+size_t ubi_calc_fm_size(struct ubi_device *ubi)
+{
+	size_t size;
+
+	size = sizeof(struct ubi_fm_hdr) + \
+		sizeof(struct ubi_fm_scan_pool) + \
+		sizeof(struct ubi_fm_scan_pool) + \
+		(ubi->peb_count * sizeof(struct ubi_fm_ec)) + \
+		(sizeof(struct ubi_fm_eba) + \
+		(ubi->peb_count * sizeof(__be32))) + \
+		sizeof(struct ubi_fm_volhdr) * UBI_MAX_VOLUMES;
+	return roundup(size, ubi->leb_size);
+}
+
+
+/**
  * new_fm_vhdr - allocate a new volume header for fastmap usage.
  * @ubi: UBI device description object
  * @vol_id: the VID of the new header
@@ -526,9 +545,9 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 	struct ubi_fm_volhdr *fmvhdr;
 	struct ubi_fm_eba *fm_eba;
 	int ret, i, j, pool_size, wl_pool_size;
-	size_t fm_pos = 0, fm_size = fm->size;
+	size_t fm_pos = 0, fm_size = ubi->fm_size;
 	unsigned long long max_sqnum = 0;
-	void *fm_raw = fm->raw;
+	void *fm_raw = ubi->fm_buf;
 
 	INIT_LIST_HEAD(&used);
 	INIT_LIST_HEAD(&free);
@@ -836,11 +855,13 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 	struct ubi_ec_hdr *ech;
 	struct ubi_fastmap_layout *fm;
 	int i, used_blocks, pnum, ret = 0;
-	void *fm_raw = NULL;
 	size_t fm_size;
 	__be32 crc, tmp_crc;
 	unsigned long long sqnum = 0;
 
+	mutex_lock(&ubi->fm_mutex);
+	memset(ubi->fm_buf, 0, ubi->fm_size);
+
 	fmsb = kmalloc(sizeof(*fmsb), GFP_KERNEL);
 	if (!fmsb) {
 		ret = -ENOMEM;
@@ -851,7 +872,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 	if (!fm) {
 		ret = -ENOMEM;
 		kfree(fmsb);
-		goto free_raw;
+		goto out;
 	}
 
 	ret = ubi_io_read(ubi, fmsb, fm_anchor, ubi->leb_start, sizeof(*fmsb));
@@ -890,13 +911,11 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 	}
 
 	fm_size = ubi->leb_size * used_blocks;
-	/* fm_raw will contain the whole fastmap */
-	fm_raw = vzalloc(fm_size);
-	if (!fm_raw) {
-		ret = -ENOMEM;
+	if (fm_size != ubi->fm_size) {
+		ubi_err("bad fastmap size: %zi, expected: %zi", fm_size, ubi->fm_size);
+		ret = UBI_BAD_FASTMAP;
 		kfree(fmsb);
 		kfree(fm);
-		goto out;
 	}
 
 	ech = kzalloc(ubi->ec_hdr_alsize, GFP_KERNEL);
@@ -904,7 +923,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		ret = -ENOMEM;
 		kfree(fmsb);
 		kfree(fm);
-		goto free_raw;
+		goto out;
 	}
 
 	vh = ubi_zalloc_vid_hdr(ubi, GFP_KERNEL);
@@ -913,7 +932,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		kfree(fmsb);
 		kfree(fm);
 		kfree(ech);
-		goto free_raw;
+		goto out;
 	}
 
 	for (i = 0; i < used_blocks; i++) {
@@ -983,7 +1002,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		if (sqnum < be64_to_cpu(vh->sqnum))
 			sqnum = be64_to_cpu(vh->sqnum);
 
-		ret = ubi_io_read(ubi, fm_raw + (ubi->leb_size * i), pnum,
+		ret = ubi_io_read(ubi, ubi->fm_buf + (ubi->leb_size * i), pnum,
 				  ubi->leb_start, ubi->leb_size);
 		if (ret && ret != UBI_IO_BITFLIPS) {
 			ubi_err("unable to read fastmap block# %i (PEB: %i, " \
@@ -996,10 +1015,10 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 
 	kfree(fmsb);
 
-	fmsb = (struct ubi_fm_sb *)fm_raw;
+	fmsb = (struct ubi_fm_sb *)(ubi->fm_buf);
 	tmp_crc = be32_to_cpu(fmsb->data_crc);
 	fmsb->data_crc = 0;
-	crc = crc32(UBI_CRC32_INIT, fm_raw, fm_size);
+	crc = crc32(UBI_CRC32_INIT, ubi->fm_buf, fm_size);
 	if (crc != tmp_crc) {
 		ubi_err("fastmap data CRC is invalid");
 		ubi_err("CRC should be: 0x%x, calc: 0x%x", tmp_crc, crc);
@@ -1010,9 +1029,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 
 	fmsb->sqnum = sqnum;
 
-	fm->size = fm_size;
 	fm->used_blocks = used_blocks;
-	fm->raw = fm_raw;
 
 	ret = ubi_attach_fastmap(ubi, ai, fm);
 	if (ret) {
@@ -1052,9 +1069,8 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 free_hdr:
 	ubi_free_vid_hdr(ubi, vh);
 	kfree(ech);
-free_raw:
-	vfree(fm_raw);
 out:
+	mutex_unlock(&ubi->fm_mutex);
 	if (ret == UBI_BAD_FASTMAP)
 		ubi_err("Attach by fastmap failed, doing a full scan!");
 	return ret;
@@ -1086,16 +1102,13 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 	int ret, i, j, free_peb_count, used_peb_count, vol_count;
 	int scrub_peb_count, erase_peb_count;
 
-	fm_raw = vzalloc(new_fm->size);
-	if (!fm_raw) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	fm_raw = ubi->fm_buf;
+	memset(ubi->fm_buf, 0, ubi->fm_size);
 
 	avhdr = new_fm_vhdr(ubi, UBI_FM_SB_VOLUME_ID);
 	if (!avhdr) {
 		ret = -ENOMEM;
-		goto out_vfree;
+		goto out;
 	}
 
 	dvhdr = new_fm_vhdr(ubi, UBI_FM_DATA_VOLUME_ID);
@@ -1109,11 +1122,11 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 
 	fmsb = (struct ubi_fm_sb *)fm_raw;
 	fm_pos += sizeof(*fmsb);
-	ubi_assert(fm_pos <= new_fm->size);
+	ubi_assert(fm_pos <= ubi->fm_size);
 
 	fmh = (struct ubi_fm_hdr *)(fm_raw + fm_pos);
 	fm_pos += sizeof(*fmh);
-	ubi_assert(fm_pos <= new_fm->size);
+	ubi_assert(fm_pos <= ubi->fm_size);
 
 	fmsb->magic = cpu_to_be32(UBI_FM_SB_MAGIC);
 	fmsb->version = UBI_FM_FMT_VERSION;
@@ -1155,7 +1168,7 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 
 		free_peb_count++;
 		fm_pos += sizeof(*fec);
-		ubi_assert(fm_pos <= new_fm->size);
+		ubi_assert(fm_pos <= ubi->fm_size);
 	}
 	fmh->free_peb_count = cpu_to_be32(free_peb_count);
 
@@ -1168,7 +1181,7 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 
 		used_peb_count++;
 		fm_pos += sizeof(*fec);
-		ubi_assert(fm_pos <= new_fm->size);
+		ubi_assert(fm_pos <= ubi->fm_size);
 	}
 	fmh->used_peb_count = cpu_to_be32(used_peb_count);
 
@@ -1181,7 +1194,7 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 
 		scrub_peb_count++;
 		fm_pos += sizeof(*fec);
-		ubi_assert(fm_pos <= new_fm->size);
+		ubi_assert(fm_pos <= ubi->fm_size);
 	}
 	fmh->scrub_peb_count = cpu_to_be32(scrub_peb_count);
 
@@ -1198,7 +1211,7 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 
 			erase_peb_count++;
 			fm_pos += sizeof(*fec);
-			ubi_assert(fm_pos <= new_fm->size);
+			ubi_assert(fm_pos <= ubi->fm_size);
 		}
 	}
 	fmh->erase_peb_count = cpu_to_be32(erase_peb_count);
@@ -1213,7 +1226,7 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 
 		fvh = (struct ubi_fm_volhdr *)(fm_raw + fm_pos);
 		fm_pos += sizeof(*fvh);
-		ubi_assert(fm_pos <= new_fm->size);
+		ubi_assert(fm_pos <= ubi->fm_size);
 
 		fvh->magic = cpu_to_be32(UBI_FM_VHDR_MAGIC);
 		fvh->vol_id = cpu_to_be32(vol->vol_id);
@@ -1227,7 +1240,7 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 
 		feba = (struct ubi_fm_eba *)(fm_raw + fm_pos);
 		fm_pos += sizeof(*feba) + (sizeof(__be32) * vol->reserved_pebs);
-		ubi_assert(fm_pos <= new_fm->size);
+		ubi_assert(fm_pos <= ubi->fm_size);
 
 		for (j = 0; j < vol->reserved_pebs; j++)
 			feba->pnum[j] = cpu_to_be32(vol->eba_tbl[j]);
@@ -1258,7 +1271,7 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 
 	fmsb->data_crc = 0;
 	fmsb->data_crc = cpu_to_be32(crc32(UBI_CRC32_INIT, fm_raw,
-					   new_fm->size));
+					   ubi->fm_size));
 
 	for (i = 1; i < new_fm->used_blocks; i++) {
 		dvhdr->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
@@ -1291,8 +1304,6 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 out_kfree:
 	ubi_free_vid_hdr(ubi, avhdr);
 	ubi_free_vid_hdr(ubi, dvhdr);
-out_vfree:
-	vfree(fm_raw);
 out:
 	return ret;
 }
@@ -1411,16 +1422,7 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 		return -ENOMEM;
 	}
 
-	new_fm->size = sizeof(struct ubi_fm_hdr) + \
-			sizeof(struct ubi_fm_scan_pool) + \
-			sizeof(struct ubi_fm_scan_pool) + \
-			(ubi->peb_count * sizeof(struct ubi_fm_ec)) + \
-			(sizeof(struct ubi_fm_eba) + \
-			(ubi->peb_count * sizeof(__be32))) + \
-			sizeof(struct ubi_fm_volhdr) * UBI_MAX_VOLUMES;
-	new_fm->size = roundup(new_fm->size, ubi->leb_size);
-
-	new_fm->used_blocks = new_fm->size / ubi->leb_size;
+	new_fm->used_blocks = ubi->fm_size / ubi->leb_size;
 
 	for (i = 0; i < new_fm->used_blocks; i++) {
 		new_fm->e[i] = kmem_cache_alloc(ubi_wl_entry_slab, GFP_KERNEL);
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 9f766ff..56e6be0 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -216,20 +216,16 @@ struct ubi_volume_desc;
  * struct ubi_fastmap_layout - in-memory fastmap data structure.
  * @e: PEBs used by the current fastmap
  * @to_be_tortured: if non-zero tortured this PEB
- * @size: size of the fastmap in bytes
  * @used_blocks: number of used PEBs
  * @max_pool_size: maximal size of the user pool
  * @max_wl_pool_size: maximal size of the pooly used by the WL sub-system
- * @raw: the fastmap itself as byte array (only valid while attaching)
  */
 struct ubi_fastmap_layout {
 	struct ubi_wl_entry *e[UBI_FM_MAX_BLOCKS];
 	int to_be_tortured[UBI_FM_MAX_BLOCKS];
-	size_t size;
 	int used_blocks;
 	int max_pool_size;
 	int max_wl_pool_size;
-	void *raw;
 };
 
 /**
@@ -391,7 +387,9 @@ struct ubi_wl_entry;
  * @fm_pool: in-memory data structure of the fastmap pool
  * @fm_wl_pool: in-memory data structure of the fastmap pool used by the WL
  * 		sub-system
- * @fm_mutex: serializes ubi_update_fastmap()
+ * @fm_mutex: serializes ubi_update_fastmap() and protects @fm_buf
+ * @fm_buf: vmalloc()'d buffer which holds the raw fastmap
+ * @fm_size: fastmap size in bytes
  * @fm_sem: allows ubi_update_fastmap() to block EBA table changes
  * @fm_work: fastmap work queue
  *
@@ -493,6 +491,8 @@ struct ubi_device {
 	struct ubi_fm_pool fm_wl_pool;
 	struct rw_semaphore fm_sem;
 	struct mutex fm_mutex;
+	void *fm_buf;
+	size_t fm_size;
 	struct work_struct fm_work;
 
 	/* Wear-leveling sub-system's stuff */
@@ -817,6 +817,7 @@ int ubi_compare_lebs(struct ubi_device *ubi, const struct ubi_ainf_peb *aeb,
 		      int pnum, const struct ubi_vid_hdr *vid_hdr);
 
 /* fastmap.c */
+size_t ubi_calc_fm_size(struct ubi_device *ubi);
 int ubi_update_fastmap(struct ubi_device *ubi);
 int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai, int fm_anchor);
 
-- 
1.7.6.5

