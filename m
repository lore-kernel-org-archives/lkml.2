Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab2IZPwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 11:52:20 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47841 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756899Ab2IZPwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 11:52:12 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Heinz.Egger@linutronix.de, artem.bityutskiy@linux.intel.com,
        tim.bird@am.sony.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 07/10] UBI: Add fastmap stuff to attach.c
Date: Wed, 26 Sep 2012 17:51:47 +0200
Message-Id: <1348674710-102885-8-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1348674710-102885-1-git-send-email-richard@nod.at>
References: <1348674710-102885-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Export compare_lebs() as fastmap needs this function.
- Implement fastmap scan logic.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/attach.c |  386 +++++++++++++++++++++++++++++++---------------
 drivers/mtd/ubi/build.c  |    2 +-
 drivers/mtd/ubi/ubi.h    |    2 +-
 3 files changed, 260 insertions(+), 130 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index da13215..e106e59 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -300,7 +300,7 @@ static struct ubi_ainf_volume *add_volume(struct ubi_attach_info *ai,
 }
 
 /**
- * compare_lebs - find out which logical eraseblock is newer.
+ * ubi_compare_lebs - find out which logical eraseblock is newer.
  * @ubi: UBI device description object
  * @aeb: first logical eraseblock to compare
  * @pnum: physical eraseblock number of the second logical eraseblock to
@@ -319,7 +319,7 @@ static struct ubi_ainf_volume *add_volume(struct ubi_attach_info *ai,
  *     o bit 2 is cleared: the older LEB is not corrupted;
  *     o bit 2 is set: the older LEB is corrupted.
  */
-static int compare_lebs(struct ubi_device *ubi, const struct ubi_ainf_peb *aeb,
+int ubi_compare_lebs(struct ubi_device *ubi, const struct ubi_ainf_peb *aeb,
 			int pnum, const struct ubi_vid_hdr *vid_hdr)
 {
 	void *buf;
@@ -337,7 +337,7 @@ static int compare_lebs(struct ubi_device *ubi, const struct ubi_ainf_peb *aeb,
 		 * support these images anymore. Well, those images still work,
 		 * but only if no unclean reboots happened.
 		 */
-		ubi_err("unsupported on-flash UBI format\n");
+		ubi_err("unsupported on-flash UBI format");
 		return -EINVAL;
 	}
 
@@ -507,7 +507,7 @@ int ubi_add_to_av(struct ubi_device *ubi, struct ubi_attach_info *ai, int pnum,
 		 * sequence numbers. We still can attach these images, unless
 		 * there is a need to distinguish between old and new
 		 * eraseblocks, in which case we'll refuse the image in
-		 * 'compare_lebs()'. In other words, we attach old clean
+		 * 'ubi_compare_lebs()'. In other words, we attach old clean
 		 * images, but refuse attaching old images with duplicated
 		 * logical eraseblocks because there was an unclean reboot.
 		 */
@@ -523,7 +523,7 @@ int ubi_add_to_av(struct ubi_device *ubi, struct ubi_attach_info *ai, int pnum,
 		 * Now we have to drop the older one and preserve the newer
 		 * one.
 		 */
-		cmp_res = compare_lebs(ubi, aeb, pnum, vid_hdr);
+		cmp_res = ubi_compare_lebs(ubi, aeb, pnum, vid_hdr);
 		if (cmp_res < 0)
 			return cmp_res;
 
@@ -748,7 +748,7 @@ struct ubi_ainf_peb *ubi_early_get_peb(struct ubi_device *ubi,
 /**
  * check_corruption - check the data area of PEB.
  * @ubi: UBI device description object
- * @vid_hrd: the (corrupted) VID header of this PEB
+ * @vid_hdr: the (corrupted) VID header of this PEB
  * @pnum: the physical eraseblock number to check
  *
  * This is a helper function which is used to distinguish between VID header
@@ -810,6 +810,8 @@ out_unlock:
  * @ubi: UBI device description object
  * @ai: attaching information
  * @pnum: the physical eraseblock number
+ * @vid: The volume ID of the found volume will be stored in this pointer
+ * @sqnum: The sqnum of the found volume will be stored in this pointer
  *
  * This function reads UBI headers of PEB @pnum, checks them, and adds
  * information about this PEB to the corresponding list or RB-tree in the
@@ -817,10 +819,10 @@ out_unlock:
  * successfully handled and a negative error code in case of failure.
  */
 static int scan_peb(struct ubi_device *ubi, struct ubi_attach_info *ai,
-		    int pnum)
+		    int pnum, int *vid, unsigned long long *sqnum)
 {
 	long long uninitialized_var(ec);
-	int err, bitflips = 0, vol_id, ec_err = 0;
+	int err, bitflips = 0, vol_id = -1, ec_err = 0;
 
 	dbg_bld("scan PEB %d", pnum);
 
@@ -991,14 +993,21 @@ static int scan_peb(struct ubi_device *ubi, struct ubi_attach_info *ai,
 	}
 
 	vol_id = be32_to_cpu(vidh->vol_id);
+	if (vid)
+		*vid = vol_id;
+	if (sqnum)
+		*sqnum = be64_to_cpu(vidh->sqnum);
 	if (vol_id > UBI_MAX_VOLUMES && vol_id != UBI_LAYOUT_VOLUME_ID) {
 		int lnum = be32_to_cpu(vidh->lnum);
 
 		/* Unsupported internal volume */
 		switch (vidh->compat) {
 		case UBI_COMPAT_DELETE:
-			ubi_msg("\"delete\" compatible internal volume %d:%d found, will remove it",
-				vol_id, lnum);
+			if (vol_id != UBI_FM_SB_VOLUME_ID
+			    && vol_id != UBI_FM_DATA_VOLUME_ID) {
+				ubi_msg("\"delete\" compatible internal volume %d:%d found, will remove it",
+					vol_id, lnum);
+			}
 			err = add_to_list(ai, pnum, vol_id, lnum,
 					  ec, 1, &ai->erase);
 			if (err)
@@ -1121,51 +1130,126 @@ static int late_analysis(struct ubi_device *ubi, struct ubi_attach_info *ai)
 }
 
 /**
+ * destroy_av - free volume attaching information.
+ * @av: volume attaching information
+ * @ai: attaching information
+ *
+ * This function destroys the volume attaching information.
+ */
+static void destroy_av(struct ubi_attach_info *ai, struct ubi_ainf_volume *av)
+{
+	struct ubi_ainf_peb *aeb;
+	struct rb_node *this = av->root.rb_node;
+
+	while (this) {
+		if (this->rb_left)
+			this = this->rb_left;
+		else if (this->rb_right)
+			this = this->rb_right;
+		else {
+			aeb = rb_entry(this, struct ubi_ainf_peb, u.rb);
+			this = rb_parent(this);
+			if (this) {
+				if (this->rb_left == &aeb->u.rb)
+					this->rb_left = NULL;
+				else
+					this->rb_right = NULL;
+			}
+
+			kmem_cache_free(ai->aeb_slab_cache, aeb);
+		}
+	}
+	kfree(av);
+}
+
+/**
+ * destroy_ai - destroy attaching information.
+ * @ai: attaching information
+ */
+static void destroy_ai(struct ubi_attach_info *ai)
+{
+	struct ubi_ainf_peb *aeb, *aeb_tmp;
+	struct ubi_ainf_volume *av;
+	struct rb_node *rb;
+
+	list_for_each_entry_safe(aeb, aeb_tmp, &ai->alien, u.list) {
+		list_del(&aeb->u.list);
+		kmem_cache_free(ai->aeb_slab_cache, aeb);
+	}
+	list_for_each_entry_safe(aeb, aeb_tmp, &ai->erase, u.list) {
+		list_del(&aeb->u.list);
+		kmem_cache_free(ai->aeb_slab_cache, aeb);
+	}
+	list_for_each_entry_safe(aeb, aeb_tmp, &ai->corr, u.list) {
+		list_del(&aeb->u.list);
+		kmem_cache_free(ai->aeb_slab_cache, aeb);
+	}
+	list_for_each_entry_safe(aeb, aeb_tmp, &ai->free, u.list) {
+		list_del(&aeb->u.list);
+		kmem_cache_free(ai->aeb_slab_cache, aeb);
+	}
+
+	/* Destroy the volume RB-tree */
+	rb = ai->volumes.rb_node;
+	while (rb) {
+		if (rb->rb_left)
+			rb = rb->rb_left;
+		else if (rb->rb_right)
+			rb = rb->rb_right;
+		else {
+			av = rb_entry(rb, struct ubi_ainf_volume, rb);
+
+			rb = rb_parent(rb);
+			if (rb) {
+				if (rb->rb_left == &av->rb)
+					rb->rb_left = NULL;
+				else
+					rb->rb_right = NULL;
+			}
+
+			destroy_av(ai, av);
+		}
+	}
+
+	if (ai->aeb_slab_cache)
+		kmem_cache_destroy(ai->aeb_slab_cache);
+
+	kfree(ai);
+}
+
+/**
  * scan_all - scan entire MTD device.
  * @ubi: UBI device description object
+ * @ai: attach info object
+ * @start: start scanning at this PEB
  *
  * This function does full scanning of an MTD device and returns complete
  * information about it in form of a "struct ubi_attach_info" object. In case
  * of failure, an error code is returned.
  */
-static struct ubi_attach_info *scan_all(struct ubi_device *ubi)
+static int scan_all(struct ubi_device *ubi, struct ubi_attach_info *ai,
+		    int start)
 {
 	int err, pnum;
 	struct rb_node *rb1, *rb2;
 	struct ubi_ainf_volume *av;
 	struct ubi_ainf_peb *aeb;
-	struct ubi_attach_info *ai;
-
-	ai = kzalloc(sizeof(struct ubi_attach_info), GFP_KERNEL);
-	if (!ai)
-		return ERR_PTR(-ENOMEM);
-
-	INIT_LIST_HEAD(&ai->corr);
-	INIT_LIST_HEAD(&ai->free);
-	INIT_LIST_HEAD(&ai->erase);
-	INIT_LIST_HEAD(&ai->alien);
-	ai->volumes = RB_ROOT;
 
 	err = -ENOMEM;
-	ai->aeb_slab_cache = kmem_cache_create("ubi_aeb_slab_cache",
-					       sizeof(struct ubi_ainf_peb),
-					       0, 0, NULL);
-	if (!ai->aeb_slab_cache)
-		goto out_ai;
 
 	ech = kzalloc(ubi->ec_hdr_alsize, GFP_KERNEL);
 	if (!ech)
-		goto out_ai;
+		return err;
 
 	vidh = ubi_zalloc_vid_hdr(ubi, GFP_KERNEL);
 	if (!vidh)
 		goto out_ech;
 
-	for (pnum = 0; pnum < ubi->peb_count; pnum++) {
+	for (pnum = start; pnum < ubi->peb_count; pnum++) {
 		cond_resched();
 
 		dbg_gen("process PEB %d", pnum);
-		err = scan_peb(ubi, ai, pnum);
+		err = scan_peb(ubi, ai, pnum, NULL, NULL);
 		if (err < 0)
 			goto out_vidh;
 	}
@@ -1210,32 +1294,144 @@ static struct ubi_attach_info *scan_all(struct ubi_device *ubi)
 	ubi_free_vid_hdr(ubi, vidh);
 	kfree(ech);
 
-	return ai;
+	return 0;
 
 out_vidh:
 	ubi_free_vid_hdr(ubi, vidh);
 out_ech:
 	kfree(ech);
-out_ai:
-	ubi_destroy_ai(ai);
-	return ERR_PTR(err);
+	return err;
+}
+
+#ifdef CONFIG_MTD_UBI_FASTMAP
+
+/**
+ * scan_fastmap - try to find a fastmap and attach from it.
+ * @ubi: UBI device description object
+ * @ai: attach info object
+ *
+ * Returns 0 on success, negative return values indicate an internal
+ * error.
+ * UBI_NO_FASTMAP denotes that no fastmap was found.
+ * UBI_BAD_FASTMAP denotes that the found fastmap was invalid.
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
+		goto out;
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
+		err = scan_peb(ubi, ai, pnum, &vol_id, &sqnum);
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
+out:
+	return err;
+}
+
+#endif
+
+static struct ubi_attach_info *alloc_ai(const char *slab_name)
+{
+	struct ubi_attach_info *ai;
+
+	ai = kzalloc(sizeof(struct ubi_attach_info), GFP_KERNEL);
+	if (!ai)
+		return ai;
+
+	INIT_LIST_HEAD(&ai->corr);
+	INIT_LIST_HEAD(&ai->free);
+	INIT_LIST_HEAD(&ai->erase);
+	INIT_LIST_HEAD(&ai->alien);
+	ai->volumes = RB_ROOT;
+	ai->aeb_slab_cache = kmem_cache_create(slab_name,
+					       sizeof(struct ubi_ainf_peb),
+					       0, 0, NULL);
+	if (!ai->aeb_slab_cache) {
+		kfree(ai);
+		ai = NULL;
+	}
+
+	return ai;
 }
 
 /**
  * ubi_attach - attach an MTD device.
  * @ubi: UBI device descriptor
+ * @force_scan: if set to non-zero attach by scanning
  *
  * This function returns zero in case of success and a negative error code in
  * case of failure.
  */
-int ubi_attach(struct ubi_device *ubi)
+int ubi_attach(struct ubi_device *ubi, int force_scan)
 {
 	int err;
 	struct ubi_attach_info *ai;
 
-	ai = scan_all(ubi);
-	if (IS_ERR(ai))
-		return PTR_ERR(ai);
+	ai = alloc_ai("ubi_aeb_slab_cache");
+	if (!ai)
+		return -ENOMEM;
+
+#ifdef CONFIG_MTD_UBI_FASTMAP
+	/* On small flash devices we disable fastmap in any case. */
+	if ((int)mtd_div_by_eb(ubi->mtd->size, ubi->mtd) <= UBI_FM_MAX_START) {
+		ubi->fm_disabled = 1;
+		force_scan = 1;
+	}
+
+	if (force_scan)
+		err = scan_all(ubi, ai, 0);
+	else {
+		err = scan_fast(ubi, ai);
+		if (err > 0) {
+			if (err != UBI_NO_FASTMAP) {
+				destroy_ai(ai);
+				ai = alloc_ai("ubi_aeb_slab_cache2");
+				if (!ai)
+					return -ENOMEM;
+			}
+
+			err = scan_all(ubi, ai, UBI_FM_MAX_START);
+		}
+	}
+#else
+	err = scan_all(ubi, ai, 0);
+#endif
+	if (err)
+		goto out_ai;
 
 	ubi->bad_peb_count = ai->bad_peb_count;
 	ubi->good_peb_count = ubi->peb_count - ubi->bad_peb_count;
@@ -1256,7 +1452,29 @@ int ubi_attach(struct ubi_device *ubi)
 	if (err)
 		goto out_wl;
 
-	ubi_destroy_ai(ai);
+#ifdef CONFIG_MTD_UBI_FASTMAP
+	if (ubi->fm && ubi->dbg->chk_gen) {
+		struct ubi_attach_info *scan_ai;
+
+		scan_ai = alloc_ai("ubi_ckh_aeb_slab_cache");
+		if (!scan_ai)
+			goto out_wl;
+
+		err = scan_all(ubi, scan_ai, 0);
+		if (err) {
+			destroy_ai(scan_ai);
+			goto out_wl;
+		}
+
+		err = self_check_eba(ubi, ai, scan_ai);
+		destroy_ai(scan_ai);
+
+		if (err)
+			goto out_wl;
+	}
+#endif
+
+	destroy_ai(ai);
 	return 0;
 
 out_wl:
@@ -1265,99 +1483,11 @@ out_vtbl:
 	ubi_free_internal_volumes(ubi);
 	vfree(ubi->vtbl);
 out_ai:
-	ubi_destroy_ai(ai);
+	destroy_ai(ai);
 	return err;
 }
 
 /**
- * destroy_av - free volume attaching information.
- * @av: volume attaching information
- * @ai: attaching information
- *
- * This function destroys the volume attaching information.
- */
-static void destroy_av(struct ubi_attach_info *ai, struct ubi_ainf_volume *av)
-{
-	struct ubi_ainf_peb *aeb;
-	struct rb_node *this = av->root.rb_node;
-
-	while (this) {
-		if (this->rb_left)
-			this = this->rb_left;
-		else if (this->rb_right)
-			this = this->rb_right;
-		else {
-			aeb = rb_entry(this, struct ubi_ainf_peb, u.rb);
-			this = rb_parent(this);
-			if (this) {
-				if (this->rb_left == &aeb->u.rb)
-					this->rb_left = NULL;
-				else
-					this->rb_right = NULL;
-			}
-
-			kmem_cache_free(ai->aeb_slab_cache, aeb);
-		}
-	}
-	kfree(av);
-}
-
-/**
- * ubi_destroy_ai - destroy attaching information.
- * @ai: attaching information
- */
-void ubi_destroy_ai(struct ubi_attach_info *ai)
-{
-	struct ubi_ainf_peb *aeb, *aeb_tmp;
-	struct ubi_ainf_volume *av;
-	struct rb_node *rb;
-
-	list_for_each_entry_safe(aeb, aeb_tmp, &ai->alien, u.list) {
-		list_del(&aeb->u.list);
-		kmem_cache_free(ai->aeb_slab_cache, aeb);
-	}
-	list_for_each_entry_safe(aeb, aeb_tmp, &ai->erase, u.list) {
-		list_del(&aeb->u.list);
-		kmem_cache_free(ai->aeb_slab_cache, aeb);
-	}
-	list_for_each_entry_safe(aeb, aeb_tmp, &ai->corr, u.list) {
-		list_del(&aeb->u.list);
-		kmem_cache_free(ai->aeb_slab_cache, aeb);
-	}
-	list_for_each_entry_safe(aeb, aeb_tmp, &ai->free, u.list) {
-		list_del(&aeb->u.list);
-		kmem_cache_free(ai->aeb_slab_cache, aeb);
-	}
-
-	/* Destroy the volume RB-tree */
-	rb = ai->volumes.rb_node;
-	while (rb) {
-		if (rb->rb_left)
-			rb = rb->rb_left;
-		else if (rb->rb_right)
-			rb = rb->rb_right;
-		else {
-			av = rb_entry(rb, struct ubi_ainf_volume, rb);
-
-			rb = rb_parent(rb);
-			if (rb) {
-				if (rb->rb_left == &av->rb)
-					rb->rb_left = NULL;
-				else
-					rb->rb_right = NULL;
-			}
-
-			destroy_av(ai, av);
-		}
-	}
-
-	if (ai->aeb_slab_cache)
-		kmem_cache_destroy(ai->aeb_slab_cache);
-
-	kfree(ai);
-}
-
-/**
  * self_check_ai - check the attaching information.
  * @ubi: UBI device description object
  * @ai: attaching information
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index c9b99be..344b4cb 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -990,7 +990,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 	if (err)
 		goto out_free;
 
-	err = ubi_attach(ubi);
+	err = ubi_attach(ubi, 0);
 	if (err) {
 		ubi_err("failed to attach mtd%d, error %d", mtd->index, err);
 		goto out_debugging;
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index b0d3ba2..7d57469 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -710,7 +710,7 @@ struct ubi_ainf_volume *ubi_find_av(const struct ubi_attach_info *ai,
 void ubi_remove_av(struct ubi_attach_info *ai, struct ubi_ainf_volume *av);
 struct ubi_ainf_peb *ubi_early_get_peb(struct ubi_device *ubi,
 				       struct ubi_attach_info *ai);
-int ubi_attach(struct ubi_device *ubi);
+int ubi_attach(struct ubi_device *ubi, int force_scan);
 void ubi_destroy_ai(struct ubi_attach_info *ai);
 
 /* vtbl.c */
-- 
1.7.6.5

