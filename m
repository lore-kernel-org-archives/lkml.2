Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab2F0P7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:59:49 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47845 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756876Ab2F0P6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:58:20 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 11/16] UBI: Fastmap: Store pool sizes in fastmap
Date: Wed, 27 Jun 2012 17:57:51 +0200
Message-Id: <1340812676-14460-12-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340812676-14460-1-git-send-email-richard@nod.at>
References: <1340812676-14460-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Later this can be used by ubinize to allow custom
pool sizes.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/attach.c    |    8 ++++
 drivers/mtd/ubi/build.c     |    4 +-
 drivers/mtd/ubi/fastmap.c   |   84 ++++++++++++++++++++++++++++--------------
 drivers/mtd/ubi/ubi-media.h |    4 ++-
 drivers/mtd/ubi/ubi.h       |    6 +++
 5 files changed, 75 insertions(+), 31 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index 1ac58ec..7552d25 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -1261,6 +1261,14 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 	if (err)
 		goto out_ai;
 
+	if (ubi->fm) {
+		ubi->fm_pool.max_size = ubi->fm->max_pool_size;
+		ubi->fm_wl_pool.max_size = ubi->fm->max_wl_pool_size;
+
+		ubi_msg("fastmap pool size: %d", ubi->fm_pool.max_size);
+		ubi_msg("fastmap WL pool size: %d", ubi->fm_wl_pool.max_size);
+	}
+
 	err = ubi_wl_init(ubi, ai);
 	if (err)
 		goto out_vtbl;
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index d00101e..7094550 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -900,8 +900,8 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num, int vid_hdr_offset)
 
 	ubi->fm_wl_pool.max_size = UBI_FM_WL_POOL_SIZE;
 
-	ubi_msg("fastmap pool size: %d", ubi->fm_pool.max_size);
-	ubi_msg("fastmap WL pool size: %d", ubi->fm_wl_pool.max_size);
+	ubi_msg("default fastmap pool size: %d", ubi->fm_pool.max_size);
+	ubi_msg("default fastmap WL pool size: %d", ubi->fm_wl_pool.max_size);
 
 	mutex_init(&ubi->buf_mutex);
 	mutex_init(&ubi->ckvol_mutex);
diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index c234d94..e285e3b 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -506,15 +506,14 @@ static int count_fastmap_pebs(struct ubi_attach_info *ai)
  * ubi_attach_fastmap - creates ubi_attach_info from a fastmap.
  * @ubi: UBI device object
  * @ai: UBI attach info object
- * @fm_raw: the fastmap it self as byte array
- * @fm_size: size of the fastmap in bytes
+ * @fm: the fastmap to be attached
  *
  * Returns 0 on success, UBI_BAD_FASTMAP if the found fastmap was unusable.
  * < 0 indicates an internal error.
  */
 static int ubi_attach_fastmap(struct ubi_device *ubi,
 			      struct ubi_attach_info *ai,
-			      void *fm_raw, size_t fm_size)
+			      struct ubi_fastmap_layout *fm)
 {
 	struct list_head used, eba_orphans, free;
 	struct ubi_ainf_volume *av;
@@ -526,9 +525,10 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 	struct ubi_fm_ec *fmec;
 	struct ubi_fm_volhdr *fmvhdr;
 	struct ubi_fm_eba *fm_eba;
-	int ret, i, j;
-	size_t fm_pos = 0;
+	int ret, i, j, pool_size, wl_pool_size;
+	size_t fm_pos = 0, fm_size = fm->size;
 	unsigned long long max_sqnum = 0;
+	void *fm_raw = fm->raw;
 
 	INIT_LIST_HEAD(&used);
 	INIT_LIST_HEAD(&free);
@@ -585,6 +585,34 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 		goto fail_bad;
 	}
 
+	pool_size = be16_to_cpu(fmpl1->size);
+	wl_pool_size = be16_to_cpu(fmpl2->size);
+	fm->max_pool_size = be16_to_cpu(fmpl1->max_size);
+	fm->max_wl_pool_size = be16_to_cpu(fmpl2->max_size);
+
+	if (pool_size > UBI_FM_MAX_POOL_SIZE || pool_size < 0) {
+		ubi_err("bad pool size: %i", pool_size);
+		goto fail_bad;
+	}
+
+	if (wl_pool_size > UBI_FM_MAX_POOL_SIZE || wl_pool_size < 0) {
+		ubi_err("bad WL pool size: %i", wl_pool_size);
+		goto fail_bad;
+	}
+
+
+	if (fm->max_pool_size > UBI_FM_MAX_POOL_SIZE ||
+	    fm->max_pool_size < 0) {
+		ubi_err("bad maximal pool size: %i", fm->max_pool_size);
+		goto fail_bad;
+	}
+
+	if (fm->max_wl_pool_size > UBI_FM_MAX_POOL_SIZE ||
+	    fm->max_wl_pool_size < 0) {
+		ubi_err("bad maximal WL pool size: %i", fm->max_wl_pool_size);
+		goto fail_bad;
+	}
+
 	/* read EC values from free list */
 	for (i = 0; i < be32_to_cpu(fmhdr->free_peb_count); i++) {
 		fmec = (struct ubi_fm_ec *)(fm_raw + fm_pos);
@@ -754,13 +782,13 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 		kfree(ech);
 	}
 
-	ret = scan_pool(ubi, ai, fmpl1->pebs, be32_to_cpu(fmpl1->size),
-			&max_sqnum, &eba_orphans, &free);
+	ret = scan_pool(ubi, ai, fmpl1->pebs, pool_size, &max_sqnum,
+			&eba_orphans, &free);
 	if (ret)
 		goto fail;
 
-	ret = scan_pool(ubi, ai, fmpl2->pebs, be32_to_cpu(fmpl2->size),
-			&max_sqnum, &eba_orphans, &free);
+	ret = scan_pool(ubi, ai, fmpl2->pebs, wl_pool_size, &max_sqnum,
+			&eba_orphans, &free);
 	if (ret)
 		goto fail;
 
@@ -772,6 +800,16 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 		list_add_tail(&tmp_aeb->u.list, &ai->free);
 	}
 
+	/*
+	 * If fastmap is leaking PEBs (must not happen), raise a
+	 * fat warning and fall back to scanning mode.
+	 * We do this here because in ubi_wl_init() it's too late
+	 * and we cannot fall back to scanning.
+	 */
+	if (WARN_ON(count_fastmap_pebs(ai) != ubi->peb_count -
+		    ai->bad_peb_count - fm->used_blocks))
+		goto fail_bad;
+
 	return 0;
 
 fail_bad:
@@ -1026,7 +1064,11 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 
 	fmsb->sqnum = sqnum;
 
-	ret = ubi_attach_fastmap(ubi, ai, fm_raw, fm_size);
+	fm->size = fm_size;
+	fm->used_blocks = used_blocks;
+	fm->raw = fm_raw;
+
+	ret = ubi_attach_fastmap(ubi, ai, fm);
 	if (ret) {
 		if (ret > 0)
 			ret = UBI_BAD_FASTMAP;
@@ -1034,22 +1076,6 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 		goto free_hdr;
 	}
 
-	/*
-	 * If fastmap is leaking PEBs (must not happen), raise a
-	 * fat warning and fall back to scanning mode.
-	 * We do this here because in ubi_wl_init() it's too late
-	 * and we cannot fall back to scanning.
-	 */
-	if (WARN_ON(count_fastmap_pebs(ai) != ubi->peb_count -
-		    ai->bad_peb_count - used_blocks)) {
-		ret = UBI_BAD_FASTMAP;
-		kfree(fm);
-		goto free_hdr;
-	}
-
-	fm->size = fm_size;
-	fm->used_blocks = used_blocks;
-
 	for (i = 0; i < used_blocks; i++) {
 		struct ubi_wl_entry *e;
 
@@ -1153,7 +1179,8 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 	fmpl1 = (struct ubi_fm_scan_pool *)(fm_raw + fm_pos);
 	fm_pos += sizeof(*fmpl1);
 	fmpl1->magic = cpu_to_be32(UBI_FM_POOL_MAGIC);
-	fmpl1->size = cpu_to_be32(ubi->fm_pool.size);
+	fmpl1->size = cpu_to_be16(ubi->fm_pool.size);
+	fmpl1->max_size = cpu_to_be16(ubi->fm_pool.max_size);
 
 	for (i = 0; i < ubi->fm_pool.size; i++)
 		fmpl1->pebs[i] = cpu_to_be32(ubi->fm_pool.pebs[i]);
@@ -1161,7 +1188,8 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 	fmpl2 = (struct ubi_fm_scan_pool *)(fm_raw + fm_pos);
 	fm_pos += sizeof(*fmpl2);
 	fmpl2->magic = cpu_to_be32(UBI_FM_POOL_MAGIC);
-	fmpl2->size = cpu_to_be32(ubi->fm_wl_pool.size);
+	fmpl2->size = cpu_to_be16(ubi->fm_wl_pool.size);
+	fmpl2->max_size = cpu_to_be16(ubi->fm_wl_pool.max_size);
 
 	for (i = 0; i < ubi->fm_wl_pool.size; i++)
 		fmpl2->pebs[i] = cpu_to_be32(ubi->fm_wl_pool.pebs[i]);
diff --git a/drivers/mtd/ubi/ubi-media.h b/drivers/mtd/ubi/ubi-media.h
index eaf81a2..f1b85a4f 100644
--- a/drivers/mtd/ubi/ubi-media.h
+++ b/drivers/mtd/ubi/ubi-media.h
@@ -455,11 +455,13 @@ struct ubi_fm_hdr {
  * struct ubi_fm_scan_pool - Fastmap pool PEBs to be scanned while attaching
  * @magic: pool magic numer (%UBI_FM_POOL_MAGIC)
  * @size: current pool size
+ * @max_size: maximal pool size
  * @pebs: an array containing the location of all PEBs in this pool
  */
 struct ubi_fm_scan_pool {
 	__be32 magic;
-	__be32 size;
+	__be16 size;
+	__be16 max_size;
 	__be32 pebs[UBI_FM_MAX_POOL_SIZE];
 	__be32 padding[4];
 } __packed;
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index b60818d..8e2592d 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -218,12 +218,18 @@ struct ubi_volume_desc;
  * @to_be_tortured: if non-zero tortured this PEB
  * @size: size of the fastmap in bytes
  * @used_blocks: number of used PEBs
+ * @max_pool_size: maximal size of the user pool
+ * @max_wl_pool_size: maximal size of the pooly used by the WL sub-system
+ * @raw: the fastmap itself as byte array (only valid while attaching)
  */
 struct ubi_fastmap_layout {
 	struct ubi_wl_entry *e[UBI_FM_MAX_BLOCKS];
 	int to_be_tortured[UBI_FM_MAX_BLOCKS];
 	size_t size;
 	int used_blocks;
+	int max_pool_size;
+	int max_wl_pool_size;
+	void *raw;
 };
 
 /**
-- 
1.7.6.5

