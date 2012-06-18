Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab2FRQW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:22:56 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47836 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab2FRQTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:19:37 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 11/22] UBI: Fastmap: Get rid of ubi_wl_flush() in ubi_update_fastmap()
Date: Mon, 18 Jun 2012 18:18:54 +0200
Message-Id: <1340036345-96726-12-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340036345-96726-1-git-send-email-richard@nod.at>
References: <1340036345-96726-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c   |   76 ++++++++++++++++++++++++++++++++++--------
 drivers/mtd/ubi/ubi-media.h |    8 +++--
 drivers/mtd/ubi/ubi.h       |   21 ++++++++++++
 drivers/mtd/ubi/wl.c        |   32 ++++++------------
 4 files changed, 98 insertions(+), 39 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 8aa43e8..ff09fd4 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -348,7 +348,7 @@ static void unmap_peb(struct ubi_attach_info *ai, int pnum)
  */
 static int scan_pool(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		     int *pebs, int pool_size, unsigned long long *max_sqnum,
-		     struct list_head *eba_orphans)
+		     struct list_head *eba_orphans, struct list_head *free)
 {
 	struct ubi_vid_hdr *vh;
 	struct ubi_ec_hdr *ech;
@@ -402,9 +402,9 @@ static int scan_pool(struct ubi_device *ubi, struct ubi_attach_info *ai,
 			unmap_peb(ai, pnum);
 			dbg_bld("Adding PEB to free: %i", pnum);
 			if (err == UBI_IO_FF_BITFLIPS)
-				add_aeb(ai, &ai->free, pnum, ec, 1);
+				add_aeb(ai, free, pnum, ec, 1);
 			else
-				add_aeb(ai, &ai->free, pnum, ec, 0);
+				add_aeb(ai, free, pnum, ec, 0);
 			continue;
 		} else if (err == 0 || err == UBI_IO_BITFLIPS) {
 			dbg_bld("Found non empty PEB:%i in pool", pnum);
@@ -471,7 +471,7 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 			      struct ubi_attach_info *ai,
 			      void *fm_raw, size_t fm_size)
 {
-	struct list_head used, eba_orphans;
+	struct list_head used, eba_orphans, free;
 	struct ubi_ainf_volume *av;
 	struct ubi_ainf_peb *aeb, *tmp_aeb, *_tmp_aeb;
 	struct ubi_ec_hdr *ech;
@@ -486,6 +486,7 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 	unsigned long long max_sqnum = 0;
 
 	INIT_LIST_HEAD(&used);
+	INIT_LIST_HEAD(&free);
 	INIT_LIST_HEAD(&eba_orphans);
 	INIT_LIST_HEAD(&ai->corr);
 	INIT_LIST_HEAD(&ai->free);
@@ -567,6 +568,17 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 			be32_to_cpu(fmec->ec), 1);
 	}
 
+	/* read EC values from erase list */
+	for (i = 0; i < be32_to_cpu(fmhdr->erase_peb_count); i++) {
+		fmec = (struct ubi_fm_ec *)(fm_raw + fm_pos);
+		fm_pos += sizeof(*fmec);
+		if (fm_pos >= fm_size)
+			goto fail_bad;
+
+		add_aeb(ai, &ai->erase, be32_to_cpu(fmec->pnum),
+			be32_to_cpu(fmec->ec), 1);
+	}
+
 	ai->mean_ec = div_u64(ai->ec_sum, ai->ec_count);
 	ai->bad_peb_count = be32_to_cpu(fmhdr->bad_peb_count);
 
@@ -683,12 +695,12 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 	}
 
 	ret = scan_pool(ubi, ai, fmpl1->pebs, be32_to_cpu(fmpl1->size),
-			&max_sqnum, &eba_orphans);
+			&max_sqnum, &eba_orphans, &free);
 	if (ret)
 		goto fail;
 
 	ret = scan_pool(ubi, ai, fmpl2->pebs, be32_to_cpu(fmpl2->size),
-			&max_sqnum, &eba_orphans);
+			&max_sqnum, &eba_orphans, &free);
 	if (ret)
 		goto fail;
 
@@ -697,11 +709,30 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 
 	list_for_each_entry_safe(tmp_aeb, _tmp_aeb, &used, u.list) {
 		list_del(&tmp_aeb->u.list);
-		dbg_bld("moving PEB from used to erase: %i", tmp_aeb->pnum);
+		ubi_msg("moving PEB from used to erase: %i", tmp_aeb->pnum);
 		add_aeb(ai, &ai->erase, tmp_aeb->pnum, tmp_aeb->ec, 0);
 		kmem_cache_free(ai->aeb_slab_cache, tmp_aeb);
 	}
 
+	if (list_empty(&free))
+		goto out;
+
+	list_for_each_entry(aeb, &ai->free, u.list) {
+		list_for_each_entry_safe(tmp_aeb, _tmp_aeb, &free, u.list) {
+			if (aeb->pnum == tmp_aeb->pnum) {
+				aeb->scrub = tmp_aeb->scrub;
+				list_del(&tmp_aeb->u.list);
+				kfree(tmp_aeb);
+				continue;
+			}
+		}
+	}
+
+	list_for_each_entry_safe(tmp_aeb, _tmp_aeb, &free, u.list) {
+		list_del(&tmp_aeb->u.list);
+		list_add_tail(&tmp_aeb->u.list, &ai->free);
+	}
+out:
 	return 0;
 
 fail_bad:
@@ -1022,8 +1053,9 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 	struct ubi_wl_entry *wl_e;
 	struct ubi_volume *vol;
 	struct ubi_vid_hdr *avhdr, *dvhdr;
+	struct ubi_work *ubi_wrk;
 	int ret, i, j, free_peb_count, used_peb_count, vol_count;
-	int scrub_peb_count;
+	int scrub_peb_count, erase_peb_count;
 
 	fm_raw = vzalloc(new_fm->size);
 	if (!fm_raw) {
@@ -1064,6 +1096,7 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 	free_peb_count = 0;
 	used_peb_count = 0;
 	scrub_peb_count = 0;
+	erase_peb_count = 0;
 	vol_count = 0;
 
 	fmpl1 = (struct ubi_fm_scan_pool *)(fm_raw + fm_pos);
@@ -1121,6 +1154,24 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 	}
 	fmh->scrub_peb_count = cpu_to_be32(scrub_peb_count);
 
+
+	list_for_each_entry(ubi_wrk, &ubi->works, list) {
+		if (ubi_is_erase_work(ubi_wrk)) {
+			wl_e = ubi_wrk->e;
+			ubi_assert(wl_e);
+
+			fec = (struct ubi_fm_ec *)(fm_raw + fm_pos);
+
+			fec->pnum = cpu_to_be32(wl_e->pnum);
+			fec->ec = cpu_to_be32(wl_e->ec);
+
+			erase_peb_count++;
+			fm_pos += sizeof(*fec);
+			ubi_assert(fm_pos <= new_fm->size);
+		}
+	}
+	fmh->erase_peb_count = cpu_to_be32(erase_peb_count);
+
 	for (i = 0; i < UBI_MAX_VOLUMES + UBI_INT_VOL_COUNT; i++) {
 		vol = ubi->volumes[i];
 
@@ -1366,15 +1417,10 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 	}
 
 	kfree(old_fm);
-	/* Ensure that the PEBs of the old fastmap got erased and added to the
-	 * free list before we write the fastmap. Otherwise fastmp does not
-	 * see these PEBs and we leak them.
-	 * We need the flush also to ensure that no to be scrubbed PEBs are in
-	 * flight.
-	 */
-	ubi_wl_flush(ubi);
 
+	down_write(&ubi->work_sem);
 	ret = ubi_write_fastmap(ubi, new_fm);
+	up_write(&ubi->work_sem);
 out_unlock:
 	mutex_unlock(&ubi->fm_mutex);
 
diff --git a/drivers/mtd/ubi/ubi-media.h b/drivers/mtd/ubi/ubi-media.h
index bea8c95..a0648c1 100644
--- a/drivers/mtd/ubi/ubi-media.h
+++ b/drivers/mtd/ubi/ubi-media.h
@@ -433,17 +433,19 @@ struct ubi_fm_sb {
  * @magic: fastmap header magic number (%UBI_FM_HDR_MAGIC)
  * @free_peb_count: number of free PEBs known by this fastmap
  * @free_peb_count: number of used PEBs known by this fastmap
- * @vol_count: number of UBI volumes known by this fastmap
  * @bad_peb_count: number of bad PEBs known by this fastmap
+ * @erase_peb_count: number of bad PEBs which have to be erased
+ * @vol_count: number of UBI volumes known by this fastmap
  */
 struct ubi_fm_hdr {
 	__be32 magic;
 	__be32 free_peb_count;
 	__be32 used_peb_count;
 	__be32 scrub_peb_count;
-	__be32 vol_count;
 	__be32 bad_peb_count;
-	__u8 padding[8];
+	__be32 erase_peb_count;
+	__be32 vol_count;
+	__u8 padding[4];
 } __packed;
 
 /* struct ubi_fm_hdr is followed by struct ubi_fm_scan_pool */
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index dcbc420..8588f9c 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -653,6 +653,26 @@ struct ubi_attach_info {
 	struct kmem_cache *aeb_slab_cache;
 };
 
+/**
+ * struct ubi_work - UBI work description data structure.
+ * @list: a link in the list of pending works
+ * @func: worker function
+ * @e: physical eraseblock to erase
+ * @torture: if the physical eraseblock has to be tortured
+ *
+ * The @func pointer points to the worker function. If the @cancel argument is
+ * not zero, the worker has to free the resources and exit immediately. The
+ * worker has to return zero in case of success and a negative error code in
+ * case of failure.
+ */
+struct ubi_work {
+	struct list_head list;
+	int (*func)(struct ubi_device *ubi, struct ubi_work *wrk, int cancel);
+	/* The below fields are only relevant to erasure works */
+	struct ubi_wl_entry *e;
+	int torture;
+};
+
 #include "debug.h"
 
 extern struct kmem_cache *ubi_wl_entry_slab;
@@ -734,6 +754,7 @@ void ubi_wl_close(struct ubi_device *ubi);
 int ubi_thread(void *u);
 struct ubi_wl_entry *ubi_wl_get_fm_peb(struct ubi_device *ubi, int max_pnum);
 int ubi_wl_put_fm_peb(struct ubi_device *ubi, struct ubi_wl_entry *used_e, int torture);
+int ubi_is_erase_work(struct ubi_work *wrk);
 
 /* io.c */
 int ubi_io_read(const struct ubi_device *ubi, void *buf, int pnum, int offset,
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 58d74e4..25d2e0b 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -135,32 +135,11 @@
  */
 #define WL_MAX_FAILURES 32
 
-/**
- * struct ubi_work - UBI work description data structure.
- * @list: a link in the list of pending works
- * @func: worker function
- * @e: physical eraseblock to erase
- * @torture: if the physical eraseblock has to be tortured
- *
- * The @func pointer points to the worker function. If the @cancel argument is
- * not zero, the worker has to free the resources and exit immediately. The
- * worker has to return zero in case of success and a negative error code in
- * case of failure.
- */
-struct ubi_work {
-	struct list_head list;
-	int (*func)(struct ubi_device *ubi, struct ubi_work *wrk, int cancel);
-	/* The below fields are only relevant to erasure works */
-	struct ubi_wl_entry *e;
-	int torture;
-};
-
 static int self_check_ec(struct ubi_device *ubi, int pnum, int ec);
 static int self_check_in_wl_tree(const struct ubi_device *ubi,
 				 struct ubi_wl_entry *e, struct rb_root *root);
 static int self_check_in_pq(const struct ubi_device *ubi,
 			    struct ubi_wl_entry *e);
-
 /**
  *  ubi_ubi_is_fm_block - returns 1 if a PEB is currently used in a fastmap.
  *  @ubi: UBI device description object
@@ -760,6 +739,7 @@ repeat:
  */
 static void schedule_ubi_work(struct ubi_device *ubi, struct ubi_work *wrk)
 {
+	down_read(&ubi->work_sem);
 	spin_lock(&ubi->wl_lock);
 	list_add_tail(&wrk->list, &ubi->works);
 	ubi_assert(ubi->works_count >= 0);
@@ -767,12 +747,22 @@ static void schedule_ubi_work(struct ubi_device *ubi, struct ubi_work *wrk)
 	if (ubi->thread_enabled && !ubi_dbg_is_bgt_disabled(ubi))
 		wake_up_process(ubi->bgt_thread);
 	spin_unlock(&ubi->wl_lock);
+	up_read(&ubi->work_sem);
 }
 
 static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 			int cancel);
 
 /**
+ * ubi_is_erase_work - checks whether a work is erase work
+ * @wrk: The work object to be checked
+ */
+int ubi_is_erase_work(struct ubi_work *wrk)
+{
+	return wrk->func == erase_worker;
+}
+
+/**
  * schedule_erase - schedule an erase work.
  * @ubi: UBI device description object
  * @e: the WL entry of the physical eraseblock to erase
-- 
1.7.6.5

