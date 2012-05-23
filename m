Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933402Ab2EWLLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 07:11:25 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422Ab2EWLLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 07:11:11 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: tglx@linutronix.de, dedekind1@gmail.com, linux-kernel@vger.kernel.org,
        Heinz.Egger@linutronix.de, tim.bird@am.sony.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] [RFC] UBI: Implement Fastmap support
Date: Wed, 23 May 2012 13:06:31 +0200
Message-Id: <1337771191-95358-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1337771191-95358-1-git-send-email-richard@nod.at>
References: <1337771191-95358-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fastmap (aka checkpointing) allows attaching of an UBI volume in nearly
constant time. Only a fixed number of PEBs has to be scanned.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/Makefile    |    2 +-
 drivers/mtd/ubi/attach.c    |   34 +-
 drivers/mtd/ubi/build.c     |   25 +
 drivers/mtd/ubi/eba.c       |   18 +-
 drivers/mtd/ubi/fastmap.c   | 1240 +++++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/ubi/ubi-media.h |  119 +++++
 drivers/mtd/ubi/ubi.h       |   68 +++-
 drivers/mtd/ubi/wl.c        |  184 +++++++-
 8 files changed, 1667 insertions(+), 23 deletions(-)
 create mode 100644 drivers/mtd/ubi/fastmap.c

diff --git a/drivers/mtd/ubi/Makefile b/drivers/mtd/ubi/Makefile
index a0803ac..c9f0269 100644
--- a/drivers/mtd/ubi/Makefile
+++ b/drivers/mtd/ubi/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_MTD_UBI) += ubi.o
 
 ubi-y += vtbl.o vmt.o upd.o build.o cdev.o kapi.o eba.o io.o wl.o attach.o
-ubi-y += misc.o debug.o
+ubi-y += fastmap.o misc.o debug.o
 
 obj-$(CONFIG_MTD_UBI_GLUEBI) += gluebi.o
diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index f59f748..23b3d55 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -294,7 +294,7 @@ static struct ubi_ainf_volume *add_volume(struct ubi_attach_info *ai,
 }
 
 /**
- * compare_lebs - find out which logical eraseblock is newer.
+ * ubi_compare_lebs - find out which logical eraseblock is newer.
  * @ubi: UBI device description object
  * @aeb: first logical eraseblock to compare
  * @pnum: physical eraseblock number of the second logical eraseblock to
@@ -313,7 +313,7 @@ static struct ubi_ainf_volume *add_volume(struct ubi_attach_info *ai,
  *     o bit 2 is cleared: the older LEB is not corrupted;
  *     o bit 2 is set: the older LEB is corrupted.
  */
-static int compare_lebs(struct ubi_device *ubi, const struct ubi_ainf_peb *aeb,
+int ubi_compare_lebs(struct ubi_device *ubi, const struct ubi_ainf_peb *aeb,
 			int pnum, const struct ubi_vid_hdr *vid_hdr)
 {
 	void *buf;
@@ -501,7 +501,7 @@ int ubi_add_to_av(struct ubi_device *ubi, struct ubi_attach_info *ai, int pnum,
 		 * sequence numbers. We still can attach these images, unless
 		 * there is a need to distinguish between old and new
 		 * eraseblocks, in which case we'll refuse the image in
-		 * 'compare_lebs()'. In other words, we attach old clean
+		 * 'ubi_compare_lebs()'. In other words, we attach old clean
 		 * images, but refuse attaching old images with duplicated
 		 * logical eraseblocks because there was an unclean reboot.
 		 */
@@ -517,7 +517,7 @@ int ubi_add_to_av(struct ubi_device *ubi, struct ubi_attach_info *ai, int pnum,
 		 * Now we have to drop the older one and preserve the newer
 		 * one.
 		 */
-		cmp_res = compare_lebs(ubi, aeb, pnum, vid_hdr);
+		cmp_res = ubi_compare_lebs(ubi, aeb, pnum, vid_hdr);
 		if (cmp_res < 0)
 			return cmp_res;
 
@@ -977,7 +977,12 @@ static int scan_peb(struct ubi_device *ubi, struct ubi_attach_info *ai,
 	}
 
 	vol_id = be32_to_cpu(vidh->vol_id);
-	if (vol_id > UBI_MAX_VOLUMES && vol_id != UBI_LAYOUT_VOLUME_ID) {
+
+	if (vol_id > UBI_MAX_VOLUMES &&
+		vol_id != UBI_LAYOUT_VOLUME_ID &&
+		(ubi->attached_by_scanning ||
+		(vol_id != UBI_FM_SB_VOLUME_ID &&
+		vol_id != UBI_FM_DATA_VOLUME_ID))) {
 		int lnum = be32_to_cpu(vidh->lnum);
 
 		/* Unsupported internal volume */
@@ -1217,11 +1222,20 @@ out_ai:
 int ubi_attach(struct ubi_device *ubi)
 {
 	int err;
-	struct ubi_attach_info *ai;
-
-	ai = scan_all(ubi);
-	if (IS_ERR(ai))
-		return PTR_ERR(ai);
+	struct ubi_attach_info *ai = NULL;
+
+	err = ubi_scan_fastmap(ubi, &ai);
+	if (err > 0) {
+		if (err == UBI_BAD_FASTMAP)
+			ubi_err("Attach by fastmap failed! " \
+				"Falling back to attach by scanning.");
+
+		ubi->attached_by_scanning = 1;
+		ai = scan_all(ubi);
+		if (IS_ERR(ai))
+			return PTR_ERR(ai);
+	} else if (err < 0)
+		return err;
 
 	ubi->bad_peb_count = ai->bad_peb_count;
 	ubi->good_peb_count = ubi->peb_count - ubi->bad_peb_count;
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 2c5ed5c..bd3fa14 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -144,6 +144,18 @@ int ubi_volume_notify(struct ubi_device *ubi, struct ubi_volume *vol, int ntype)
 
 	ubi_do_get_device_info(ubi, &nt.di);
 	ubi_do_get_volume_info(ubi, vol, &nt.vi);
+
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
+
 	return blocking_notifier_call_chain(&ubi_notifiers, ntype, &nt);
 }
 
@@ -874,6 +886,19 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num, int vid_hdr_offset)
 	ubi->vid_hdr_offset = vid_hdr_offset;
 	ubi->autoresize_vol_id = -1;
 
+	ubi->fm_pool.used = ubi->fm_pool.size = 0;
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
+	ubi_msg("fastmap pool size: %d", ubi->fm_pool.max_size);
+
 	mutex_init(&ubi->buf_mutex);
 	mutex_init(&ubi->ckvol_mutex);
 	mutex_init(&ubi->device_mutex);
diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index 5fa726f..654f121 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -57,7 +57,7 @@
  * global sequence counter value. It also increases the global sequence
  * counter.
  */
-static unsigned long long next_sqnum(struct ubi_device *ubi)
+unsigned long long ubi_next_sqnum(struct ubi_device *ubi)
 {
 	unsigned long long sqnum;
 
@@ -522,7 +522,7 @@ retry:
 		goto out_put;
 	}
 
-	vid_hdr->sqnum = cpu_to_be64(next_sqnum(ubi));
+	vid_hdr->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
 	err = ubi_io_write_vid_hdr(ubi, new_pnum, vid_hdr);
 	if (err)
 		goto write_error;
@@ -633,7 +633,7 @@ int ubi_eba_write_leb(struct ubi_device *ubi, struct ubi_volume *vol, int lnum,
 	}
 
 	vid_hdr->vol_type = UBI_VID_DYNAMIC;
-	vid_hdr->sqnum = cpu_to_be64(next_sqnum(ubi));
+	vid_hdr->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
 	vid_hdr->vol_id = cpu_to_be32(vol_id);
 	vid_hdr->lnum = cpu_to_be32(lnum);
 	vid_hdr->compat = ubi_get_compat(ubi, vol_id);
@@ -694,7 +694,7 @@ write_error:
 		return err;
 	}
 
-	vid_hdr->sqnum = cpu_to_be64(next_sqnum(ubi));
+	vid_hdr->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
 	ubi_msg("try another PEB");
 	goto retry;
 }
@@ -747,7 +747,7 @@ int ubi_eba_write_leb_st(struct ubi_device *ubi, struct ubi_volume *vol,
 		return err;
 	}
 
-	vid_hdr->sqnum = cpu_to_be64(next_sqnum(ubi));
+	vid_hdr->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
 	vid_hdr->vol_id = cpu_to_be32(vol_id);
 	vid_hdr->lnum = cpu_to_be32(lnum);
 	vid_hdr->compat = ubi_get_compat(ubi, vol_id);
@@ -812,7 +812,7 @@ write_error:
 		return err;
 	}
 
-	vid_hdr->sqnum = cpu_to_be64(next_sqnum(ubi));
+	vid_hdr->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
 	ubi_msg("try another PEB");
 	goto retry;
 }
@@ -864,7 +864,7 @@ int ubi_eba_atomic_leb_change(struct ubi_device *ubi, struct ubi_volume *vol,
 	if (err)
 		goto out_mutex;
 
-	vid_hdr->sqnum = cpu_to_be64(next_sqnum(ubi));
+	vid_hdr->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
 	vid_hdr->vol_id = cpu_to_be32(vol_id);
 	vid_hdr->lnum = cpu_to_be32(lnum);
 	vid_hdr->compat = ubi_get_compat(ubi, vol_id);
@@ -932,7 +932,7 @@ write_error:
 		goto out_leb_unlock;
 	}
 
-	vid_hdr->sqnum = cpu_to_be64(next_sqnum(ubi));
+	vid_hdr->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
 	ubi_msg("try another PEB");
 	goto retry;
 }
@@ -1092,7 +1092,7 @@ int ubi_eba_copy_leb(struct ubi_device *ubi, int from, int to,
 		vid_hdr->data_size = cpu_to_be32(data_size);
 		vid_hdr->data_crc = cpu_to_be32(crc);
 	}
-	vid_hdr->sqnum = cpu_to_be64(next_sqnum(ubi));
+	vid_hdr->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
 
 	err = ubi_io_write_vid_hdr(ubi, to, vid_hdr);
 	if (err) {
diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
new file mode 100644
index 0000000..7757e5a
--- /dev/null
+++ b/drivers/mtd/ubi/fastmap.c
@@ -0,0 +1,1240 @@
+/*
+ * Copyright (c) 2012 Linutronix GmbH
+ * Author: Richard Weinberger <richard@nod.at>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
+ * the GNU General Public License for more details.
+ *
+ */
+
+#include <linux/crc32.h>
+#include "ubi.h"
+
+/**
+ * new_fm_vhdr - allocate a new volume header for fastmap usage.
+ * @ubi: UBI device description object
+ * @vol_id: the VID of the new header
+ */
+static struct ubi_vid_hdr *new_fm_vhdr(struct ubi_device *ubi, int vol_id)
+{
+	struct ubi_vid_hdr *new;
+
+	new = ubi_zalloc_vid_hdr(ubi, GFP_KERNEL);
+	if (!new)
+		goto out;
+
+	new->vol_type = UBI_VID_DYNAMIC;
+	new->vol_id = cpu_to_be32(vol_id);
+
+	/* UBI implementations without fastmap support have to delete the
+	 * fastmap.
+	 */
+	new->compat = UBI_COMPAT_DELETE;
+
+out:
+	return new;
+}
+
+/**
+ * add_aeb - create and add a attach erase block to a given list.
+ * @ai: UBI attach info object
+ * @list: the target list
+ * @pnum: PEB number of the new attach erase block
+ * @ec: erease counter of the new LEB
+ */
+static int add_aeb(struct ubi_attach_info *ai, struct list_head *list,
+		   int pnum, int ec)
+{
+	struct ubi_ainf_peb *aeb;
+
+	aeb = kmem_cache_alloc(ai->aeb_slab_cache, GFP_KERNEL);
+	if (!aeb)
+		return -ENOMEM;
+
+	aeb->pnum = pnum;
+	aeb->ec = ec;
+	aeb->lnum = -1;
+	aeb->scrub = aeb->copy_flag = aeb->sqnum = 0;
+
+	ai->ec_sum += aeb->ec;
+	ai->ec_count++;
+
+	if (ai->max_ec < aeb->ec)
+		ai->max_ec = aeb->ec;
+
+	if (ai->min_ec > aeb->ec)
+		ai->min_ec = aeb->ec;
+
+	list_add_tail(&aeb->u.list, list);
+
+	return 0;
+}
+
+/**
+ * add_vol - create and add a new scan volume to ubi_attach_info.
+ * @ai: ubi_attach_info object
+ * @vol_id: VID of the new volume
+ * @used_ebs: number of used EBS
+ * @data_pad: data padding value of the new volume
+ * @vol_type: volume type
+ * @last_eb_bytes: number of bytes in the last LEB
+ */
+static struct ubi_ainf_volume *add_vol(struct ubi_attach_info *ai, int vol_id,
+				       int used_ebs, int data_pad, u8 vol_type,
+				       int last_eb_bytes)
+{
+	struct ubi_ainf_volume *av;
+	struct rb_node **p = &ai->volumes.rb_node, *parent = NULL;
+
+	while (*p) {
+		parent = *p;
+		av = rb_entry(parent, struct ubi_ainf_volume, rb);
+
+		if (vol_id > av->vol_id)
+			p = &(*p)->rb_left;
+		else if (vol_id > av->vol_id)
+			p = &(*p)->rb_right;
+	}
+
+	av = kmalloc(sizeof(struct ubi_ainf_volume), GFP_KERNEL);
+	if (!av)
+		goto out;
+
+	av->highest_lnum = av->leb_count = 0;
+	av->vol_id = vol_id;
+	av->used_ebs = used_ebs;
+	av->data_pad = data_pad;
+	av->last_data_size = last_eb_bytes;
+	av->compat = 0;
+	av->vol_type = vol_type;
+	av->root = RB_ROOT;
+
+	dbg_bld("Found volume (ID %i)", vol_id);
+
+	rb_link_node(&av->rb, parent, p);
+	rb_insert_color(&av->rb, &ai->volumes);
+
+out:
+	return av;
+}
+
+/**
+ * assign_aeb_to_av - assigns a SEB to a given ainf_volume and removes it
+ * from it's original list.
+ * @ai: ubi_attach_info object
+ * @aeb: the to be assigned SEB
+ * @av: target scan volume
+ */
+static void assign_aeb_to_av(struct ubi_attach_info *ai,
+			     struct ubi_ainf_peb *aeb,
+			     struct ubi_ainf_volume *av)
+{
+	struct ubi_ainf_peb *tmp_aeb;
+	struct rb_node **p = &ai->volumes.rb_node, *parent = NULL;
+
+	p = &av->root.rb_node;
+	while (*p) {
+		parent = *p;
+
+		tmp_aeb = rb_entry(parent, struct ubi_ainf_peb, u.rb);
+		if (aeb->lnum != tmp_aeb->lnum) {
+			if (aeb->lnum < tmp_aeb->lnum)
+				p = &(*p)->rb_left;
+			else
+				p = &(*p)->rb_right;
+
+			continue;
+		} else
+			break;
+	}
+
+	list_del(&aeb->u.list);
+	av->leb_count++;
+
+	rb_link_node(&aeb->u.rb, parent, p);
+	rb_insert_color(&aeb->u.rb, &av->root);
+}
+
+/**
+ * update_vol - inserts or updates a LEB which was found a pool.
+ * @ubi: the UBI device object
+ * @ai: attach info object
+ * @av: the volume this LEB belongs to
+ * @new_vh: the volume header derived from new_aeb
+ * @new_aeb: the AEB to be examined
+ */
+static int update_vol(struct ubi_device *ubi, struct ubi_attach_info *ai,
+		      struct ubi_ainf_volume *av, struct ubi_vid_hdr *new_vh,
+		      struct ubi_ainf_peb *new_aeb)
+{
+	struct rb_node **p = &av->root.rb_node, *parent = NULL;
+	struct ubi_ainf_peb *aeb, *victim;
+	int cmp_res;
+
+	while (*p) {
+		parent = *p;
+		aeb = rb_entry(parent, struct ubi_ainf_peb, u.rb);
+
+		if (be32_to_cpu(new_vh->lnum) != aeb->lnum) {
+			if (be32_to_cpu(new_vh->lnum) < aeb->lnum)
+				p = &(*p)->rb_left;
+			else
+				p = &(*p)->rb_right;
+
+			continue;
+		}
+
+		/* This case can happen if the fastmap gets written
+		 * because of a volume change (creation, deletion, ..).
+		 * Then a PEB can be within the persistent EBA and the pool.
+		 */
+		if (aeb->pnum == new_aeb->pnum) {
+			kmem_cache_free(ai->aeb_slab_cache, new_aeb);
+
+			return 0;
+		}
+
+		cmp_res = ubi_compare_lebs(ubi, aeb, new_aeb->pnum, new_vh);
+		if (cmp_res < 0)
+			return cmp_res;
+
+		/* new_aeb is newer */
+		if (cmp_res & 1) {
+			victim = kmem_cache_alloc(ai->aeb_slab_cache,
+				GFP_KERNEL);
+			if (!victim)
+				return -ENOMEM;
+
+			victim->ec = aeb->ec;
+			victim->pnum = aeb->pnum;
+			list_add_tail(&victim->u.list, &ai->erase);
+
+			if (av->highest_lnum == be32_to_cpu(new_vh->lnum))
+				av->last_data_size = \
+					be32_to_cpu(new_vh->data_size);
+
+			dbg_bld("Vol %i: AEB %i's PEB %i is the newer\n",
+				av->vol_id, aeb->lnum, new_aeb->pnum);
+
+			aeb->ec = new_aeb->ec;
+			aeb->pnum = new_aeb->pnum;
+			aeb->copy_flag = new_vh->copy_flag;
+			kmem_cache_free(ai->aeb_slab_cache, new_aeb);
+
+		/* new_aeb is older */
+		} else {
+			dbg_bld("Vol %i: AEB %i's PEB %i is old, dropping it\n",
+				av->vol_id, aeb->lnum, new_aeb->pnum);
+			list_add_tail(&new_aeb->u.list, &ai->erase);
+		}
+
+		return 0;
+	}
+	/* This LEB is new, let's add it to the volume */
+
+	if (av->highest_lnum <= be32_to_cpu(new_vh->lnum)) {
+		av->highest_lnum = be32_to_cpu(new_vh->lnum);
+		av->last_data_size = be32_to_cpu(new_vh->data_size);
+	}
+
+	if (av->vol_type == UBI_STATIC_VOLUME)
+		av->used_ebs = be32_to_cpu(new_vh->used_ebs);
+
+	av->leb_count++;
+
+	rb_link_node(&new_aeb->u.rb, parent, p);
+	rb_insert_color(&new_aeb->u.rb, &av->root);
+
+	return 0;
+}
+
+/**
+ * process_pool_aeb - we found a non-empty PEB in a pool
+ * @ubi: UBI device object
+ * @ai: attach info object
+ * @new_vh: the volume header derived from new_aeb
+ * @new_aeb: the AEB to be examined
+ */
+static int process_pool_aeb(struct ubi_device *ubi, struct ubi_attach_info *ai,
+			    struct ubi_vid_hdr *new_vh,
+			    struct ubi_ainf_peb *new_aeb)
+{
+	struct ubi_ainf_volume *av, *tmp_av = NULL;
+	struct rb_node **p = &ai->volumes.rb_node, *parent = NULL;
+	int found = 0;
+
+	if (be32_to_cpu(new_vh->vol_id) == UBI_FM_SB_VOLUME_ID ||
+		be32_to_cpu(new_vh->vol_id) == UBI_FM_DATA_VOLUME_ID) {
+		kmem_cache_free(ai->aeb_slab_cache, new_aeb);
+
+		return 0;
+	}
+
+	/* Find the volume this SEB belongs to */
+	while (*p) {
+		parent = *p;
+		tmp_av = rb_entry(parent, struct ubi_ainf_volume, rb);
+
+		if (be32_to_cpu(new_vh->vol_id) > tmp_av->vol_id)
+			p = &(*p)->rb_left;
+		else if (be32_to_cpu(new_vh->vol_id) < tmp_av->vol_id)
+			p = &(*p)->rb_right;
+		else {
+			found = 1;
+			break;
+		}
+	}
+
+	if (found)
+		av = tmp_av;
+	else {
+		ubi_err("Orphaned volume in fastmap pool!");
+
+		return UBI_BAD_FASTMAP;
+	}
+
+	ubi_assert(be32_to_cpu(new_vh->vol_id) == av->vol_id);
+
+	return update_vol(ubi, ai, av, new_vh, new_aeb);
+}
+
+/**
+ * scan_pool - scans a pool for changed (no longer empty PEBs)
+ * @ubi: UBI device object
+ * @ai: attach info object
+ * @pebs: an array of all PEB numbers in the to be scanned pool
+ * @pool_size: size of the pool (number of entries in @pebs)
+ * @max_sqnum: pointer to the maximal sequence number
+ */
+static int scan_pool(struct ubi_device *ubi, struct ubi_attach_info *ai,
+	int *pebs, int pool_size, unsigned long long *max_sqnum)
+{
+	struct ubi_vid_hdr *vh;
+	struct ubi_ec_hdr *ech;
+	struct ubi_ainf_peb *new_aeb;
+	int i;
+	int pnum;
+	int err;
+	int ret = 0;
+
+	ech = kzalloc(ubi->ec_hdr_alsize, GFP_KERNEL);
+	if (!ech)
+		return -ENOMEM;
+
+	vh = ubi_zalloc_vid_hdr(ubi, GFP_KERNEL);
+	if (!vh) {
+		kfree(ech);
+		return -ENOMEM;
+	}
+
+	dbg_bld("Scanning fastmap pool: size = %i", pool_size);
+
+	/*
+	 * Now scan all PEBs in the pool to find changes which have been made
+	 * after the creation of the fastmap
+	 */
+	for (i = 0; i < pool_size; i++) {
+		pnum = be32_to_cpu(pebs[i]);
+
+		if (ubi_io_is_bad(ubi, pnum)) {
+			dbg_bld("Bad PEB in fastmap pool!");
+			ret = UBI_BAD_FASTMAP;
+
+			goto out;
+		}
+
+		err = ubi_io_read_vid_hdr(ubi, pnum, vh, 0);
+
+		if (err == UBI_IO_FF)
+			continue;
+		else if (err == 0) {
+			err = ubi_io_read_ec_hdr(ubi, pnum, ech, 0);
+			if (err) {
+				dbg_bld("Unable to read EC header!");
+				ret = err > 0 ? UBI_BAD_FASTMAP : err;
+
+				goto out;
+			}
+
+			if (be32_to_cpu(ech->image_seq) != ubi->image_seq) {
+				dbg_bld("Image seq mismatch!");
+				err = UBI_BAD_FASTMAP;
+
+				goto out;
+			}
+
+			new_aeb = kmem_cache_alloc(ai->aeb_slab_cache,
+				GFP_KERNEL);
+			if (!new_aeb) {
+				ret = -ENOMEM;
+
+				goto out;
+			}
+
+			new_aeb->ec = be64_to_cpu(ech->ec);
+			new_aeb->pnum = pnum;
+			new_aeb->lnum = be32_to_cpu(vh->lnum);
+			new_aeb->sqnum = be64_to_cpu(vh->sqnum);
+			new_aeb->copy_flag = vh->copy_flag;
+			new_aeb->scrub = 0;
+
+			err = process_pool_aeb(ubi, ai, vh, new_aeb);
+			if (err) {
+				ret = err > 0 ? UBI_BAD_FASTMAP : err;
+
+				goto out;
+			}
+
+			if (*max_sqnum < new_aeb->sqnum)
+				*max_sqnum = new_aeb->sqnum;
+		} else {
+			/* We are paranoid and fall back to scanning mode */
+			ubi_err("Fastmap pool PEBs contains damaged PEBs!");
+			ret = err > 0 ? UBI_BAD_FASTMAP : err;
+
+			goto out;
+		}
+
+	}
+
+out:
+	ubi_free_vid_hdr(ubi, vh);
+	kfree(ech);
+
+	return ret;
+}
+
+/**
+ * ubi_attach_fastmap - creates ubi_attach_info from a fastmap.
+ * @ubi: UBI device object
+ * @fm_raw: the fastmap it self as byte array
+ * @fm_size: size of the fastmap in bytes
+ */
+static int ubi_attach_fastmap(struct ubi_device *ubi,
+			      struct ubi_attach_info **aip,
+			      char *fm_raw, size_t fm_size)
+{
+	struct list_head used;
+	struct ubi_ainf_volume *av;
+	struct ubi_ainf_peb *aeb, *tmp_aeb, *_tmp_aeb;
+	struct ubi_attach_info *ai;
+
+	struct ubi_fm_sb *fmsb;
+	struct ubi_fm_hdr *fmhdr;
+	struct ubi_fm_scan_pool *fmpl;
+	struct ubi_fm_ec *fmec;
+	struct ubi_fm_volhdr *fmvhdr;
+	struct ubi_fm_eba *fm_eba;
+
+	int ret, i, j;
+	size_t fm_pos = 0;
+	unsigned long long max_sqnum = 0;
+
+	*aip = kzalloc(sizeof(struct ubi_attach_info), GFP_KERNEL);
+	if (!*aip)
+		return -ENOMEM;
+
+	ai = *aip;
+
+	INIT_LIST_HEAD(&used);
+	INIT_LIST_HEAD(&ai->corr);
+	INIT_LIST_HEAD(&ai->free);
+	INIT_LIST_HEAD(&ai->erase);
+	INIT_LIST_HEAD(&ai->alien);
+	ai->volumes = RB_ROOT;
+	ai->min_ec = UBI_MAX_ERASECOUNTER;
+
+	ai->aeb_slab_cache = kmem_cache_create("ubi_ainf_peb_slab",
+					      sizeof(struct ubi_ainf_peb),
+					      0, 0, NULL);
+	if (!ai->aeb_slab_cache) {
+		ret = -ENOMEM;
+
+		goto fail;
+	}
+
+	fmsb = (struct ubi_fm_sb *)(fm_raw);
+	ai->max_sqnum = fmsb->sqnum;
+	fm_pos += sizeof(struct ubi_fm_sb);
+	if (fm_pos >= fm_size)
+		goto fail_bad;
+
+	fmhdr = (struct ubi_fm_hdr *)(fm_raw + fm_pos);
+	fm_pos += sizeof(*fmhdr);
+	if (fm_pos >= fm_size)
+		goto fail_bad;
+
+	if (fmhdr->magic != UBI_FM_HDR_MAGIC)
+		goto fail_bad;
+
+	fmpl = (struct ubi_fm_scan_pool *)(fm_raw + fm_pos);
+	fm_pos += sizeof(*fmpl);
+	if (fm_pos >= fm_size)
+		goto fail_bad;
+	if (fmpl->magic != UBI_FM_POOL_MAGIC)
+		goto fail_bad;
+
+	/* read EC values from free list */
+	for (i = 0; i < be32_to_cpu(fmhdr->nfree); i++) {
+		fmec = (struct ubi_fm_ec *)(fm_raw + fm_pos);
+		fm_pos += sizeof(*fmec);
+		if (fm_pos >= fm_size)
+			goto fail_bad;
+
+		add_aeb(ai, &ai->free, be32_to_cpu(fmec->pnum),
+			be32_to_cpu(fmec->ec));
+	}
+
+	/* read EC values from used list */
+	for (i = 0; i < be32_to_cpu(fmhdr->nused); i++) {
+		fmec = (struct ubi_fm_ec *)(fm_raw + fm_pos);
+		fm_pos += sizeof(*fmec);
+		if (fm_pos >= fm_size)
+			goto fail_bad;
+
+		add_aeb(ai, &used, be32_to_cpu(fmec->pnum),
+			be32_to_cpu(fmec->ec));
+	}
+
+	ai->mean_ec = div_u64(ai->ec_sum, ai->ec_count);
+	ai->bad_peb_count = be32_to_cpu(fmhdr->nbad);
+
+	/* Iterate over all volumes and read their EBA table */
+	for (i = 0; i < be32_to_cpu(fmhdr->nvol); i++) {
+		fmvhdr = (struct ubi_fm_volhdr *)(fm_raw + fm_pos);
+		fm_pos += sizeof(*fmvhdr);
+		if (fm_pos >= fm_size)
+			goto fail_bad;
+
+		if (fmvhdr->magic != UBI_FM_VHDR_MAGIC)
+			goto fail_bad;
+
+		av = add_vol(ai, be32_to_cpu(fmvhdr->vol_id),
+			be32_to_cpu(fmvhdr->used_ebs),
+			be32_to_cpu(fmvhdr->data_pad),
+			fmvhdr->vol_type, be32_to_cpu(fmvhdr->last_eb_bytes));
+
+		if (!av)
+			goto fail_bad;
+
+		ai->vols_found++;
+		if (ai->highest_vol_id < be32_to_cpu(fmvhdr->vol_id))
+			ai->highest_vol_id = be32_to_cpu(fmvhdr->vol_id);
+
+		fm_eba = (struct ubi_fm_eba *)(fm_raw + fm_pos);
+		fm_pos += sizeof(*fm_eba);
+		fm_pos += (sizeof(__be32) * be32_to_cpu(fm_eba->nused));
+		if (fm_pos >= fm_size)
+			goto fail_bad;
+
+		if (fm_eba->magic != UBI_FM_EBA_MAGIC)
+			goto fail_bad;
+
+		for (j = 0; j < be32_to_cpu(fm_eba->nused); j++) {
+
+			if ((int)be32_to_cpu(fm_eba->pnum[j]) < 0)
+				continue;
+
+			aeb = NULL;
+			list_for_each_entry(tmp_aeb, &used, u.list) {
+				if (tmp_aeb->pnum == \
+					be32_to_cpu(fm_eba->pnum[j]))
+					aeb = tmp_aeb;
+			}
+
+			/* Corner case, this PEB must be in the pool */
+			if (!aeb)
+				continue;
+
+			aeb->lnum = j;
+
+			if (av->highest_lnum <= aeb->lnum)
+				av->highest_lnum = aeb->lnum;
+
+			assign_aeb_to_av(ai, aeb, av);
+
+			dbg_bld("Inserting PEB:%i (LEB %i) to vol %i",
+				aeb->pnum, aeb->lnum, av->vol_id);
+		}
+	}
+
+	/*
+	 * The remainning PEB in the used list are not used.
+	 * They lived in the fastmap pool but got never used.
+	 */
+	list_for_each_entry_safe(tmp_aeb, _tmp_aeb, &used, u.list) {
+		list_del(&tmp_aeb->u.list);
+		list_add_tail(&tmp_aeb->u.list, &ai->free);
+	}
+
+	ret = scan_pool(ubi, ai, fmpl->pebs, be32_to_cpu(fmpl->size),
+		&max_sqnum);
+	if (ret)
+		goto fail;
+
+
+	if (max_sqnum > ai->max_sqnum)
+		ai->max_sqnum = max_sqnum;
+
+	return 0;
+
+fail_bad:
+	ret = UBI_BAD_FASTMAP;
+fail:
+	ubi_destroy_ai(ai);
+	return ret;
+}
+
+/**
+ * ubi_find_fastmap - searches the first UBI_FM_MAX_START PEBs for the
+ * fastmap super block.
+ * @ubi: UBI device object
+ */
+static int ubi_find_fastmap(struct ubi_device *ubi, int *fm_start)
+{
+	int i, ret;
+	struct ubi_vid_hdr *vhdr;
+
+	vhdr = ubi_zalloc_vid_hdr(ubi, GFP_KERNEL);
+	if (!vhdr)
+		return -ENOMEM;
+
+	for (i = 0; i < UBI_FM_MAX_START; i++) {
+		ret = ubi_io_read_vid_hdr(ubi, i, vhdr, 0);
+		if (ret < 0)
+			break;
+		else if (ret > 0)
+			continue;
+
+		if (be32_to_cpu(vhdr->vol_id) == UBI_FM_SB_VOLUME_ID) {
+			*fm_start = i;
+			dbg_bld("Found fastmap super block at PEB %i\n", i);
+			ret = 0;
+
+			break;
+		}
+	}
+
+	ubi_free_vid_hdr(ubi, vhdr);
+
+	return ret;
+}
+
+/**
+ * ubi_scan_fastmap - scan the fastmap
+ * @ubi: UBI device object
+ * @ai: UBI attach info to be filled
+ */
+int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info **ai)
+{
+	struct ubi_fm_sb *fmsb;
+	struct ubi_vid_hdr *vh;
+	struct ubi_ec_hdr *ech;
+	int ret, i, nblocks, pnum;
+	int sb_pnum = 0;
+	char *fm_raw;
+	size_t fm_size;
+	__be32 crc, tmp_crc;
+	unsigned long long sqnum = 0;
+
+	ret = ubi_find_fastmap(ubi, &sb_pnum);
+	if (ret) {
+		if (ret > 0)
+			ret = UBI_NO_FASTMAP;
+
+		goto out;
+	}
+
+	fmsb = kmalloc(sizeof(*fmsb), GFP_KERNEL);
+	if (!fmsb) {
+		ret = -ENOMEM;
+
+		goto out;
+	}
+
+	ret = ubi_io_read(ubi, fmsb, sb_pnum, ubi->leb_start, sizeof(*fmsb));
+	if (ret) {
+		ubi_err("Unable to read fastmap super block");
+		if (ret > 0)
+			ret = UBI_BAD_FASTMAP;
+
+		kfree(fmsb);
+
+		goto out;
+	}
+
+	if (fmsb->magic != UBI_FM_SB_MAGIC) {
+		ubi_err("Super block magic does not match");
+		ret = UBI_BAD_FASTMAP;
+		kfree(fmsb);
+
+		goto out;
+	}
+
+	if (fmsb->version != UBI_FM_FMT_VERSION) {
+		ubi_err("Unknown fastmap format version!");
+		ret = UBI_BAD_FASTMAP;
+		kfree(fmsb);
+
+		goto out;
+	}
+
+	nblocks = be32_to_cpu(fmsb->nblocks);
+
+	if (nblocks > UBI_FM_MAX_BLOCKS || nblocks < 1) {
+		ubi_err("Number of fastmap blocks is invalid");
+		ret = UBI_BAD_FASTMAP;
+		kfree(fmsb);
+
+		goto out;
+	}
+
+	fm_size = ubi->leb_size * nblocks;
+	/* fm_raw will contain the whole fastmap */
+	fm_raw = vzalloc(fm_size);
+	if (!fm_raw) {
+		ret = -ENOMEM;
+		kfree(fmsb);
+
+		goto out;
+	}
+
+	ech = kzalloc(ubi->ec_hdr_alsize, GFP_KERNEL);
+	if (!ech) {
+		ret = -ENOMEM;
+		kfree(fmsb);
+
+		goto free_raw;
+	}
+
+	vh = ubi_zalloc_vid_hdr(ubi, GFP_KERNEL);
+	if (!vh) {
+		ret = -ENOMEM;
+		kfree(fmsb);
+		kfree(ech);
+
+		goto free_raw;
+	}
+
+	for (i = 0; i < nblocks; i++) {
+		pnum = be32_to_cpu(fmsb->block_loc[i]);
+
+		if (ubi_io_is_bad(ubi, pnum)) {
+			ret = UBI_BAD_FASTMAP;
+			kfree(fmsb);
+
+			goto free_hdr;
+		}
+
+		ret = ubi_io_read_ec_hdr(ubi, pnum, ech, 0);
+		if (ret) {
+			ubi_err("Unable to read fastmap block# %i EC (PEB: %i)",
+				i, pnum);
+			if (ret > 0)
+				ret = UBI_BAD_FASTMAP;
+			kfree(fmsb);
+
+			goto free_hdr;
+		}
+
+		if (!ubi->image_seq)
+			ubi->image_seq = be32_to_cpu(ech->image_seq);
+
+		if (be32_to_cpu(ech->image_seq) != ubi->image_seq) {
+			ret = UBI_BAD_FASTMAP;
+			kfree(fmsb);
+
+			goto free_hdr;
+		}
+
+		ret = ubi_io_read_vid_hdr(ubi, pnum, vh, 0);
+		if (ret) {
+			ubi_err("Unable to read fastmap block# %i (PEB: %i)",
+				i, pnum);
+			if (ret > 0)
+				ret = UBI_BAD_FASTMAP;
+			kfree(fmsb);
+
+			goto free_hdr;
+		}
+
+		if (i == 0) {
+			if (be32_to_cpu(vh->vol_id) != UBI_FM_SB_VOLUME_ID) {
+				ret = UBI_BAD_FASTMAP;
+				kfree(fmsb);
+
+				goto free_hdr;
+			}
+		} else {
+			if (be32_to_cpu(vh->vol_id) != UBI_FM_DATA_VOLUME_ID) {
+				ret = UBI_BAD_FASTMAP;
+				kfree(fmsb);
+
+				goto free_hdr;
+			}
+		}
+
+		if (sqnum < be64_to_cpu(vh->sqnum))
+			sqnum = be64_to_cpu(vh->sqnum);
+
+		ret = ubi_io_read(ubi, fm_raw + (ubi->leb_size * i), pnum,
+			ubi->leb_start, ubi->leb_size);
+
+		if (ret) {
+			ubi_err("Unable to read fastmap block# %i (PEB: %i)",
+				i, pnum);
+			if (ret > 0)
+				ret = UBI_BAD_FASTMAP;
+			kfree(fmsb);
+
+			goto free_hdr;
+		}
+	}
+
+	kfree(fmsb);
+
+	fmsb = (struct ubi_fm_sb *)fm_raw;
+	tmp_crc = fmsb->data_crc;
+	fmsb->data_crc = 0;
+	crc = crc32_be(UBI_CRC32_INIT, fm_raw, fm_size);
+	if (crc != tmp_crc) {
+		ubi_err("Fastmap data CRC is invalid");
+		ret = UBI_BAD_FASTMAP;
+
+		goto free_hdr;
+	}
+
+	fmsb->sqnum = sqnum;
+
+	ret = ubi_attach_fastmap(ubi, ai, fm_raw, fm_size);
+	if (ret) {
+		if (ret > 0)
+			ret = UBI_BAD_FASTMAP;
+		ubi_destroy_ai(*ai);
+
+		goto free_hdr;
+	}
+
+	/* Store the fastmap position into the ubi_device struct */
+	ubi->fm = kmalloc(sizeof(*ubi->fm), GFP_KERNEL);
+	if (!ubi->fm) {
+		ret = -ENOMEM;
+
+		goto free_hdr;
+	}
+
+	ubi->fm->size = fm_size;
+	ubi->fm->used_blocks = nblocks;
+
+	for (i = 0; i < nblocks; i++) {
+		ubi->fm->e[i] = kmem_cache_alloc(ubi_wl_entry_slab, GFP_KERNEL);
+		if (!ubi->fm->e[i]) {
+			while (i--)
+				kfree(ubi->fm->e[i]);
+
+			kfree(ubi->fm);
+			ret = -ENOMEM;
+			goto free_hdr;
+		}
+	}
+
+	for (i = 0; i < UBI_FM_MAX_BLOCKS; i++) {
+		if (i < nblocks) {
+			ubi->fm->e[i]->pnum = be32_to_cpu(fmsb->block_loc[i]);
+			ubi->fm->e[i]->ec = be32_to_cpu(fmsb->block_ec[i]);
+		} else
+			ubi->fm->e[i] = NULL;
+	}
+
+free_hdr:
+	ubi_free_vid_hdr(ubi, vh);
+	kfree(ech);
+free_raw:
+	vfree(fm_raw);
+out:
+	return ret;
+}
+
+/**
+ * ubi_write_fastmap - writes a fastmap
+ * @ubi: UBI device object
+ * @new_fm: the to be written fastmap
+ */
+static int ubi_write_fastmap(struct ubi_device *ubi,
+			     struct ubi_fastmap_layout *new_fm)
+{
+	int ret;
+	size_t fm_pos = 0;
+	char *fm_raw;
+	int i, j;
+
+	struct ubi_fm_sb *fmsb;
+	struct ubi_fm_hdr *fmh;
+	struct ubi_fm_scan_pool *fmpl;
+	struct ubi_fm_ec *fec;
+	struct ubi_fm_volhdr *fvh;
+	struct ubi_fm_eba *feba;
+
+	struct rb_node *node;
+	struct ubi_wl_entry *wl_e;
+	struct ubi_volume *vol;
+
+	struct ubi_vid_hdr *avhdr, *dvhdr;
+
+	int nfree, nused, nvol;
+
+	fm_raw = vzalloc(new_fm->size);
+	if (!fm_raw) {
+		ret = -ENOMEM;
+
+		goto out;
+	}
+
+	avhdr = new_fm_vhdr(ubi, UBI_FM_SB_VOLUME_ID);
+	if (!avhdr) {
+		ret = -ENOMEM;
+
+		goto out_vfree;
+	}
+
+	dvhdr = new_fm_vhdr(ubi, UBI_FM_DATA_VOLUME_ID);
+	if (!dvhdr) {
+		ret = -ENOMEM;
+
+		goto out_kfree;
+	}
+
+	spin_lock(&ubi->volumes_lock);
+	spin_lock(&ubi->wl_lock);
+
+	fmsb = (struct ubi_fm_sb *)fm_raw;
+	fm_pos += sizeof(*fmsb);
+	ubi_assert(fm_pos <= new_fm->size);
+
+	fmh = (struct ubi_fm_hdr *)(fm_raw + fm_pos);
+	fm_pos += sizeof(*fmh);
+	ubi_assert(fm_pos <= new_fm->size);
+
+	fmsb->magic = UBI_FM_SB_MAGIC;
+	fmsb->version = UBI_FM_FMT_VERSION;
+	fmsb->nblocks = cpu_to_be32(new_fm->used_blocks);
+	/* the max sqnum will be filled in while *reading* the fastmap */
+	fmsb->sqnum = 0;
+
+	fmh->magic = UBI_FM_HDR_MAGIC;
+	nfree = 0;
+	nused = 0;
+	nvol = 0;
+
+	fmpl = (struct ubi_fm_scan_pool *)(fm_raw + fm_pos);
+	fm_pos += sizeof(*fmpl);
+	fmpl->magic = UBI_FM_POOL_MAGIC;
+	fmpl->size = cpu_to_be32(ubi->fm_pool.size);
+
+	for (i = 0; i < ubi->fm_pool.size; i++)
+		fmpl->pebs[i] = cpu_to_be32(ubi->fm_pool.pebs[i]);
+
+	for (node = rb_first(&ubi->free); node; node = rb_next(node)) {
+		wl_e = rb_entry(node, struct ubi_wl_entry, u.rb);
+		fec = (struct ubi_fm_ec *)(fm_raw + fm_pos);
+
+		fec->pnum = cpu_to_be32(wl_e->pnum);
+		fec->ec = cpu_to_be32(wl_e->ec);
+
+		nfree++;
+		fm_pos += sizeof(*fec);
+		ubi_assert(fm_pos <= new_fm->size);
+	}
+	fmh->nfree = cpu_to_be32(nfree);
+
+	for (node = rb_first(&ubi->used); node; node = rb_next(node)) {
+		wl_e = rb_entry(node, struct ubi_wl_entry, u.rb);
+		fec = (struct ubi_fm_ec *)(fm_raw + fm_pos);
+
+		fec->pnum = cpu_to_be32(wl_e->pnum);
+		fec->ec = cpu_to_be32(wl_e->ec);
+
+		nused++;
+		fm_pos += sizeof(*fec);
+		ubi_assert(fm_pos <= new_fm->size);
+	}
+	fmh->nused = cpu_to_be32(nused);
+
+	for (i = 0; i < UBI_MAX_VOLUMES + UBI_INT_VOL_COUNT; i++) {
+		vol = ubi->volumes[i];
+
+		if (!vol)
+			continue;
+
+		nvol++;
+
+		fvh = (struct ubi_fm_volhdr *)(fm_raw + fm_pos);
+		fm_pos += sizeof(*fvh);
+		ubi_assert(fm_pos <= new_fm->size);
+
+		fvh->magic = UBI_FM_VHDR_MAGIC;
+		fvh->vol_id = cpu_to_be32(vol->vol_id);
+		fvh->vol_type = vol->vol_type;
+		fvh->used_ebs = cpu_to_be32(vol->used_ebs);
+		fvh->data_pad = cpu_to_be32(vol->data_pad);
+		fvh->last_eb_bytes = cpu_to_be32(vol->last_eb_bytes);
+
+		ubi_assert(vol->vol_type == UBI_DYNAMIC_VOLUME ||
+			vol->vol_type == UBI_STATIC_VOLUME);
+
+		feba = (struct ubi_fm_eba *)(fm_raw + fm_pos);
+		fm_pos += sizeof(*feba) + (sizeof(__be32) * vol->used_ebs);
+		ubi_assert(fm_pos <= new_fm->size);
+
+		for (j = 0; j < vol->used_ebs; j++)
+			feba->pnum[j] = cpu_to_be32(vol->eba_tbl[j]);
+
+		feba->nused = cpu_to_be32(j);
+		feba->magic = UBI_FM_EBA_MAGIC;
+	}
+	fmh->nvol = cpu_to_be32(nvol);
+
+	avhdr->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
+	avhdr->lnum = 0;
+
+	spin_unlock(&ubi->wl_lock);
+	spin_unlock(&ubi->volumes_lock);
+
+	dbg_bld("Writing fastmap SB to PEB %i\n", new_fm->e[0]->pnum);
+	ret = ubi_io_write_vid_hdr(ubi, new_fm->e[0]->pnum, avhdr);
+	if (ret) {
+		ubi_err("Unable to write vid_hdr to fastmap SB!\n");
+
+		goto out_kfree;
+	}
+
+	for (i = 0; i < new_fm->used_blocks; i++) {
+		fmsb->block_loc[i] = cpu_to_be32(new_fm->e[i]->pnum);
+		fmsb->block_ec[i] = cpu_to_be32(new_fm->e[i]->ec);
+	}
+
+	fmsb->data_crc = 0;
+	fmsb->data_crc = crc32_be(UBI_CRC32_INIT, fm_raw, new_fm->size);
+
+	for (i = 1; i < new_fm->used_blocks; i++) {
+		dvhdr->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
+		dvhdr->lnum = cpu_to_be32(i);
+		dbg_bld("Writing fastmap data to PEB %i sqnum %llu\n",
+			new_fm->e[i]->pnum, be64_to_cpu(dvhdr->sqnum));
+		ret = ubi_io_write_vid_hdr(ubi, new_fm->e[i]->pnum, dvhdr);
+		if (ret) {
+			ubi_err("Unable to write vid_hdr to PEB %i!\n",
+				new_fm->e[i]->pnum);
+
+			goto out_kfree;
+		}
+	}
+
+	for (i = 0; i < new_fm->used_blocks; i++) {
+		ret = ubi_io_write(ubi, fm_raw + (i * ubi->leb_size),
+			new_fm->e[i]->pnum, ubi->leb_start, ubi->leb_size);
+		if (ret) {
+			ubi_err("Unable to write fastmap to PEB %i!\n",
+				new_fm->e[i]->pnum);
+
+			goto out_kfree;
+		}
+	}
+
+	ubi_assert(new_fm);
+	ubi->fm = new_fm;
+
+	dbg_bld("Fastmap written!");
+
+out_kfree:
+	kfree(avhdr);
+out_vfree:
+	vfree(fm_raw);
+out:
+	return ret;
+}
+
+/**
+ * get_ec - returns the erase counter of a given PEB
+ * @ubi: UBI device object
+ * @pnum: PEB number
+ */
+static int get_ec(struct ubi_device *ubi, int pnum)
+{
+	struct ubi_wl_entry *e;
+
+	e = ubi->lookuptbl[pnum];
+
+	/* can this really happen? */
+	if (!e)
+		return ubi->mean_ec ?: 1;
+	else
+		return e->ec;
+}
+
+/**
+ * ubi_update_fastmap - will be called by UBI if a volume changes or
+ * a fastmap pool becomes full.
+ * @ubi: UBI device object
+ */
+int ubi_update_fastmap(struct ubi_device *ubi)
+{
+	int ret, i;
+	struct ubi_fastmap_layout *new_fm;
+
+	if (ubi->ro_mode)
+		return 0;
+
+	new_fm = kzalloc(sizeof(*new_fm), GFP_KERNEL);
+	if (!new_fm)
+		return -ENOMEM;
+
+	new_fm->size = sizeof(struct ubi_fm_hdr) + \
+			sizeof(struct ubi_fm_scan_pool) + \
+			(ubi->peb_count * sizeof(struct ubi_fm_ec)) + \
+			(sizeof(struct ubi_fm_eba) + \
+			(ubi->peb_count * sizeof(__be32))) + \
+			sizeof(struct ubi_fm_volhdr) * UBI_MAX_VOLUMES;
+	new_fm->size = roundup(new_fm->size, ubi->leb_size);
+
+	new_fm->used_blocks = new_fm->size / ubi->leb_size;
+
+	for (i = 0; i < new_fm->used_blocks; i++) {
+		new_fm->e[i] = kmem_cache_alloc(ubi_wl_entry_slab, GFP_KERNEL);
+		if (!new_fm->e[i]) {
+			while (i--)
+				kfree(new_fm->e[i]);
+
+			kfree(new_fm);
+			return -ENOMEM;
+		}
+	}
+
+	ubi->old_fm = ubi->fm;
+	ubi->fm = NULL;
+
+	spin_lock(&ubi->wl_lock);
+	new_fm->e[0]->pnum = ubi_wl_get_fm_peb(ubi, UBI_FM_MAX_START);
+	spin_unlock(&ubi->wl_lock);
+
+	if (ubi->old_fm) {
+		/* no fresh early PEB was found, reuse the old one */
+		if (new_fm->e[0]->pnum < 0) {
+			struct ubi_ec_hdr *ec_hdr;
+
+			ec_hdr = kzalloc(ubi->ec_hdr_alsize, GFP_KERNEL);
+			if (!ec_hdr) {
+				kfree(new_fm);
+
+				return -ENOMEM;
+			}
+
+			/* we have to erase the block by hand */
+
+			ret = ubi_io_read_ec_hdr(ubi, ubi->old_fm->e[0]->pnum,
+				ec_hdr, 0);
+			if (ret) {
+				ubi_err("Unable to read EC header");
+				kfree(new_fm);
+				kfree(ec_hdr);
+
+				return ret;
+			}
+
+			ret = ubi_io_sync_erase(ubi, ubi->old_fm->e[0]->pnum,
+				0);
+			if (ret < 0) {
+				ubi_err("Unable to erase old SB");
+				kfree(new_fm);
+				kfree(ec_hdr);
+
+				return ret;
+			}
+
+			ec_hdr->ec += ret;
+			if (ec_hdr->ec > UBI_MAX_ERASECOUNTER) {
+				ubi_err("Erase counter overflow!");
+				kfree(new_fm);
+				kfree(ec_hdr);
+
+				return -EINVAL;
+			}
+
+			ret = ubi_io_write_ec_hdr(ubi, ubi->old_fm->e[0]->pnum,
+				ec_hdr);
+			kfree(ec_hdr);
+			if (ret) {
+				ubi_err("Unable to write new EC header");
+				kfree(new_fm);
+
+				return ret;
+			}
+
+			new_fm->e[0]->pnum = ubi->old_fm->e[0]->pnum;
+			new_fm->e[0]->ec = ubi->old_fm->e[0]->ec;
+		} else {
+			/* we've got a new early PEB, return the old one */
+			ubi_wl_put_fm_peb(ubi, ubi->old_fm->e[0]->pnum, 0);
+			new_fm->e[0]->ec = get_ec(ubi, new_fm->e[0]->pnum);
+		}
+
+		/* return all other fastmap block to the wl system */
+		for (i = 1; i < ubi->old_fm->used_blocks; i++)
+			ubi_wl_put_fm_peb(ubi, ubi->old_fm->e[i]->pnum, 0);
+	} else {
+		if (new_fm->e[0]->pnum < 0) {
+			ubi_err("Could not find an early PEB");
+			kfree(new_fm);
+
+			return -ENOSPC;
+		}
+		new_fm->e[0]->ec = get_ec(ubi, new_fm->e[0]->pnum);
+	}
+
+	if (new_fm->used_blocks > UBI_FM_MAX_BLOCKS) {
+		ubi_err("Fastmap too large");
+		kfree(new_fm);
+
+		return -ENOSPC;
+	}
+
+	/* give the wl subsystem a chance to produce some free blocks */
+	cond_resched();
+
+	for (i = 1; i < new_fm->used_blocks; i++) {
+		spin_lock(&ubi->wl_lock);
+		new_fm->e[i]->pnum = ubi_wl_get_fm_peb(ubi, -1);
+		spin_unlock(&ubi->wl_lock);
+
+		if (new_fm->e[i]->pnum < 0) {
+			ubi_err("Could not get any free erase block");
+
+			while (i--) {
+				ubi_wl_put_fm_peb(ubi, new_fm->e[i]->pnum, 0);
+				kfree(new_fm->e[i]);
+			}
+
+			kfree(new_fm);
+
+			return -ENOSPC;
+		}
+
+		new_fm->e[i]->ec = get_ec(ubi, new_fm->e[i]->pnum);
+	}
+
+	if (ubi->old_fm) {
+		for (i = 0; i < ubi->old_fm->used_blocks; i++)
+			kfree(ubi->old_fm->e[i]);
+
+		kfree(ubi->old_fm);
+		ubi->old_fm = NULL;
+	}
+
+	return ubi_write_fastmap(ubi, new_fm);
+}
diff --git a/drivers/mtd/ubi/ubi-media.h b/drivers/mtd/ubi/ubi-media.h
index 468ffbc..0e3019a 100644
--- a/drivers/mtd/ubi/ubi-media.h
+++ b/drivers/mtd/ubi/ubi-media.h
@@ -375,4 +375,123 @@ struct ubi_vtbl_record {
 	__be32  crc;
 } __packed;
 
+/* UBI fastmap on-flash data structures */
+
+#define UBI_FM_SB_VOLUME_ID	(UBI_LAYOUT_VOLUME_ID + 1)
+#define UBI_FM_DATA_VOLUME_ID	(UBI_LAYOUT_VOLUME_ID + 2)
+
+/* fastmap on-flash data structure format version */
+#define UBI_FM_FMT_VERSION	1
+
+#define UBI_FM_SB_MAGIC		0x7B11D69F
+#define UBI_FM_HDR_MAGIC	0xD4B82EF7
+#define UBI_FM_VHDR_MAGIC	0xFA370ED1
+#define UBI_FM_POOL_MAGIC	0x67AF4D08
+#define UBI_FM_EBA_MAGIC	0xf0c040a8
+
+#define UBI_FM_MAX_START	64
+#define UBI_FM_MAX_BLOCKS	32
+#define UBI_FM_MIN_POOL_SIZE	8
+#define UBI_FM_MAX_POOL_SIZE	256
+
+/**
+ * struct ubi_fm_sb - UBI fastmap super block
+ * @magic: fastmap super block magic number (%UBI_FM_SB_MAGIC)
+ * @version: format version of this fastmap
+ * @data_crc: CRC over the fastmap data
+ * @nblocks: number of PEBs used by this fastmap
+ * @block_loc: an array containing the location of all PEBs of the fastmap
+ * @block_ec: the erase counter of each used PEB
+ * @sqnum: highest sequence number value at the time while taking the fastmap
+ *
+ */
+struct ubi_fm_sb {
+	__be32 magic;
+	__u8 version;
+	__u8 padding1[3];
+	__be32 data_crc;
+	__be32 nblocks;
+	__be32 block_loc[UBI_FM_MAX_BLOCKS];
+	__be32 block_ec[UBI_FM_MAX_BLOCKS];
+	__be64 sqnum;
+	__u8 padding2[32];
+} __packed;
+
+/**
+ * struct ubi_fm_hdr - header of the fastmap data set
+ * @magic: fastmap header magic number (%UBI_FM_HDR_MAGIC)
+ * @nfree: number of free PEBs known by this fastmap
+ * @nused: number of used PEBs known by this fastmap
+ * @nvol: number of UBI volumes known by this fastmap
+ */
+struct ubi_fm_hdr {
+	__be32 magic;
+	__be32 nfree;
+	__be32 nused;
+	__be32 nvol;
+	__be32 nbad;
+	__u8 padding[12];
+} __packed;
+
+/* struct ubi_fm_hdr is followed by struct ubi_fm_scan_pool */
+
+/**
+ * struct ubi_fm_scan_pool - Fastmap pool PEBs to be scanned while attaching
+ * @magic: pool magic numer (%UBI_FM_POOL_MAGIC)
+ * @size: current pool size
+ * @pebs: an array containing the location of all PEBs in this pool
+ */
+struct ubi_fm_scan_pool {
+	__be32 magic;
+	__be32 size;
+	__be32 pebs[UBI_FM_MAX_POOL_SIZE];
+	__be32 padding[4];
+} __packed;
+
+/* ubi_fm_scan_pool is followed by nfree+nused struct ubi_fm_ec records */
+
+/**
+ * struct ubi_fm_ec - stores the erase counter of a PEB
+ * @pnum: PEB number
+ * @ec: ec of this PEB
+ */
+struct ubi_fm_ec {
+	__be32 pnum;
+	__be32 ec;
+} __packed;
+
+/**
+ * struct ubi_fm_volhdr - Fastmap volume header
+ * it identifies the start of an eba table
+ * @magic: Fastmap volume header magic number (%UBI_FM_VHDR_MAGIC)
+ * @vol_id: volume id of the fastmapped volume
+ * @vol_type: type of the fastmapped volume
+ * @data_pad: data_pad value of the fastmapped volume
+ * @used_ebs: number of used LEBs within this volume
+ * @last_eb_bytes: number of bytes used in the last LEB
+ */
+struct ubi_fm_volhdr {
+	__be32 magic;
+	__be32 vol_id;
+	__u8 vol_type;
+	__u8 padding1[3];
+	__be32 data_pad;
+	__be32 used_ebs;
+	__be32 last_eb_bytes;
+	__u8 padding2[8];
+} __packed;
+
+/* struct ubi_fm_volhdr is followed by one struct ubi_fm_eba records */
+
+/**
+ * struct ubi_fm_eba - denotes an association beween a PEB and LEB
+ * @magic EBA table magic number
+ * @nused: number of table entries
+ * @pnum: PEB number of LEB (LEB is the index)
+ */
+struct ubi_fm_eba {
+	__be32 magic;
+	__be32 nused;
+	__be32 pnum[0];
+} __packed;
 #endif /* !__UBI_MEDIA_H__ */
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 5275632..e5fe951 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -136,6 +136,17 @@ enum {
 	MOVE_RETRY,
 };
 
+/*
+ * Return codes of the fastmap sub-system
+ *
+ * UBI_NO_FASTMAP: No fastmap super block was found
+ * UBI_BAD_FASTMAP: A fastmap was found but it's unusable
+ */
+enum {
+	UBI_NO_FASTMAP = 1,
+	UBI_BAD_FASTMAP,
+};
+
 /**
  * struct ubi_wl_entry - wear-leveling entry.
  * @u.rb: link in the corresponding (free/used) RB-tree
@@ -202,6 +213,38 @@ struct ubi_rename_entry {
 struct ubi_volume_desc;
 
 /**
+ * struct ubi_fastmap_layout - in-memory fastmap data structure.
+ * @peb: PEBs used by the current fastmap
+ * @ec: the erase counter of each used PEB
+ * @size: size of the fastmap in bytes
+ * @used_blocks: number of used PEBs
+ */
+struct ubi_fastmap_layout {
+	struct ubi_wl_entry *e[UBI_FM_MAX_BLOCKS];
+	size_t size;
+	int used_blocks;
+};
+
+/**
+ * struct ubi_fm_pool - in-memory fastmap pool
+ * @pebs: PEBs in this pool
+ * @used: number of used PEBs
+ * @size: total number of PEBs in this pool
+ * @max_size: maximal size of the pool
+ *
+ * A pool gets filled with up to max_size.
+ * If all PEBs within the pool are used a new fastmap will be written
+ * to the flash and the pool gets refilled with empty PEBs.
+ *
+ */
+struct ubi_fm_pool {
+	int pebs[UBI_FM_MAX_POOL_SIZE];
+	int used;
+	int size;
+	int max_size;
+};
+
+/**
  * struct ubi_volume - UBI volume description data structure.
  * @dev: device object to make use of the the Linux device model
  * @cdev: character device object to create character device
@@ -336,6 +379,13 @@ struct ubi_wl_entry;
  * @ltree: the lock tree
  * @alc_mutex: serializes "atomic LEB change" operations
  *
+ * @fm: in-memory data structure of the currently used fastmap
+ * @old_fm: in-memory data structure old fastmap.
+ *	    (only valid while writing a new one)
+ * @fm_pool: in-memory data structure of the fastmap pool
+ * @attached_by_scanning: this UBI device was attached by the old scanning
+ *			  methold. All fastmap volumes have to be deleted.
+ *
  * @used: RB-tree of used physical eraseblocks
  * @erroneous: RB-tree of erroneous used physical eraseblocks
  * @free: RB-tree of free physical eraseblocks
@@ -427,6 +477,12 @@ struct ubi_device {
 	struct rb_root ltree;
 	struct mutex alc_mutex;
 
+	/* Fastmap stuff */
+	struct ubi_fastmap_layout *fm;
+	struct ubi_fastmap_layout *old_fm;
+	struct ubi_fm_pool fm_pool;
+	int attached_by_scanning;
+
 	/* Wear-leveling sub-system's stuff */
 	struct rb_root used;
 	struct rb_root erroneous;
@@ -604,7 +660,7 @@ extern struct class *ubi_class;
 extern struct mutex ubi_devices_mutex;
 extern struct blocking_notifier_head ubi_notifiers;
 
-/* scan.c */
+/* attach.c */
 int ubi_add_to_av(struct ubi_device *ubi, struct ubi_attach_info *ai, int pnum,
 		  int ec, const struct ubi_vid_hdr *vid_hdr, int bitflips);
 struct ubi_ainf_volume *ubi_find_av(const struct ubi_attach_info *ai,
@@ -661,6 +717,7 @@ int ubi_eba_atomic_leb_change(struct ubi_device *ubi, struct ubi_volume *vol,
 int ubi_eba_copy_leb(struct ubi_device *ubi, int from, int to,
 		     struct ubi_vid_hdr *vid_hdr);
 int ubi_eba_init(struct ubi_device *ubi, struct ubi_attach_info *ai);
+unsigned long long ubi_next_sqnum(struct ubi_device *ubi);
 
 /* wl.c */
 int ubi_wl_get_peb(struct ubi_device *ubi);
@@ -670,6 +727,8 @@ int ubi_wl_scrub_peb(struct ubi_device *ubi, int pnum);
 int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai);
 void ubi_wl_close(struct ubi_device *ubi);
 int ubi_thread(void *u);
+int ubi_wl_get_fm_peb(struct ubi_device *ubi, int max_pnum);
+int ubi_wl_put_fm_peb(struct ubi_device *ubi, int pnum, int torture);
 
 /* io.c */
 int ubi_io_read(const struct ubi_device *ubi, void *buf, int pnum, int offset,
@@ -706,6 +765,13 @@ void ubi_free_internal_volumes(struct ubi_device *ubi);
 void ubi_do_get_device_info(struct ubi_device *ubi, struct ubi_device_info *di);
 void ubi_do_get_volume_info(struct ubi_device *ubi, struct ubi_volume *vol,
 			    struct ubi_volume_info *vi);
+/* scan.c */
+int ubi_compare_lebs(struct ubi_device *ubi, const struct ubi_ainf_peb *aeb,
+		      int pnum, const struct ubi_vid_hdr *vid_hdr);
+
+/* fastmap.c */
+int ubi_update_fastmap(struct ubi_device *ubi);
+int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info **ai);
 
 /*
  * ubi_rb_for_each_entry - walk an RB-tree.
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index c143e61..7d34495 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -162,6 +162,25 @@ static int self_check_in_pq(const struct ubi_device *ubi,
 			    struct ubi_wl_entry *e);
 
 /**
+ *  ubi_ubi_is_fm_block - returns 1 if a PEB is currently used in a fastmap.
+ *  @ubi: UBI device description object
+ *  @pnum: the to be checked PEB
+ */
+int ubi_is_fm_block(struct ubi_device *ubi, int pnum)
+{
+	int i;
+
+	if (!ubi->fm)
+		return 0;
+
+	for (i = 0; i < ubi->fm->used_blocks; i++)
+		if (ubi->fm->e[i]->pnum == pnum)
+			return 1;
+
+	return 0;
+}
+
+/**
  * wl_tree_add - add a wear-leveling entry to a WL RB-tree.
  * @e: the wear-leveling entry to add
  * @root: the root of the tree
@@ -367,13 +386,82 @@ static struct ubi_wl_entry *find_wl_entry(struct rb_root *root, int diff)
 }
 
 /**
- * ubi_wl_get_peb - get a physical eraseblock.
+ * find_early_wl_entry - find wear-leveling entry with the lowest pnum.
+ * @root: the RB-tree where to look for
+ * @max_pnum: highest possible pnum
+ */
+static struct ubi_wl_entry *find_early_wl_entry(struct rb_root *root,
+						int max_pnum)
+{
+	struct rb_node *p;
+	struct ubi_wl_entry *e, *victim = NULL;
+
+	ubi_rb_for_each_entry(p, e, root, u.rb) {
+		if (e->pnum < max_pnum) {
+			victim = e;
+			max_pnum = e->pnum;
+		}
+	}
+
+	return victim;
+}
+
+/**
+ * ubi_wl_get_fm_peb - find a physical erase block with a given maximal number.
+ * @ubi: UBI device description object
+ * @max_pnum: the highest acceptable erase block number
+ *
+ * The function returns a physical erase block with a given maximal number
+ * and removes it from the wl subsystem.
+ * If max_pnum is negative a PEB with a mean EC will be selected.
+ * Must be called with wl_lock held!
+ */
+int ubi_wl_get_fm_peb(struct ubi_device *ubi, int max_pnum)
+{
+	int ret = -ENOSPC;
+	struct ubi_wl_entry *e, *first, *last;
+
+	if (!ubi->free.rb_node) {
+		ubi_err("no free eraseblocks");
+
+		goto out;
+	}
+
+	if (max_pnum < 0) {
+		first = rb_entry(rb_first(&ubi->free),
+			struct ubi_wl_entry, u.rb);
+		last = rb_entry(rb_last(&ubi->free),
+			struct ubi_wl_entry, u.rb);
+
+		if (last->ec - first->ec < WL_FREE_MAX_DIFF)
+			e = rb_entry(ubi->free.rb_node,
+				struct ubi_wl_entry, u.rb);
+		else
+			e = find_wl_entry(&ubi->free, WL_FREE_MAX_DIFF/2);
+	} else
+		e = find_early_wl_entry(&ubi->free, max_pnum);
+
+	if (!e)
+		goto out;
+
+	self_check_in_wl_tree(ubi, e, &ubi->free);
+	ret = e->pnum;
+
+	/* remove it from the free list,
+	 * the wl subsystem does no longer know this erase block */
+	rb_erase(&e->u.rb, &ubi->free);
+out:
+	return ret;
+}
+
+/**
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
@@ -424,6 +512,40 @@ retry:
 	return e->pnum;
 }
 
+/* ubi_wl_get_peb - works exaclty like __ubi_wl_get_peb but keeps track of
+ * the fastmap pool.
+ */
+int ubi_wl_get_peb(struct ubi_device *ubi)
+{
+	struct ubi_fm_pool *pool = &ubi->fm_pool;
+	int ret;
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
+		ret = ubi_update_fastmap(ubi);
+		if (ret) {
+			ubi_ro_mode(ubi);
+
+			return ret > 0 ? -EINVAL : ret;
+		}
+	}
+
+	/* we got not a single free PEB */
+	if (!pool->size)
+		return -ENOSPC;
+
+	return pool->pebs[pool->used++];
+}
+
 /**
  * prot_queue_del - remove a physical eraseblock from the protection queue.
  * @ubi: UBI device description object
@@ -589,6 +711,9 @@ static int schedule_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
 {
 	struct ubi_work *wl_wrk;
 
+	ubi_assert(e);
+	ubi_assert(!ubi_is_fm_block(ubi, e->pnum));
+
 	dbg_wl("schedule erasure of PEB %d, EC %d, torture %d",
 	       e->pnum, e->ec, torture);
 
@@ -605,6 +730,52 @@ static int schedule_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
 }
 
 /**
+ * ubi_wl_put_fm_peb - returns a PEB used in a fastmap to the wear-leveling
+ * sub-system.
+ *
+ * see: ubi_wl_put_peb()
+ */
+int ubi_wl_put_fm_peb(struct ubi_device *ubi, int pnum, int torture)
+{
+	int i, err = 0;
+	struct ubi_wl_entry *e;
+
+	dbg_wl("PEB %d", pnum);
+	ubi_assert(pnum >= 0);
+	ubi_assert(pnum < ubi->peb_count);
+
+	spin_lock(&ubi->wl_lock);
+	e = ubi->lookuptbl[pnum];
+
+	/* This can happen if we recovered from a fastmap the very
+	 * first time and writing now a new one. In this case the wl system
+	 * has never seen any PEB used by the original fastmap.
+	 */
+	if (!e) {
+		ubi_assert(ubi->old_fm);
+
+		/* use the ec value from the fastmap */
+		for (i = 0; i < ubi->old_fm->used_blocks; i++) {
+			if (ubi->old_fm->e[i] &&
+				pnum == ubi->old_fm->e[i]->pnum) {
+				e = ubi->old_fm->e[i];
+				ubi->old_fm->e[i] = NULL;
+				break;
+			}
+		}
+		ubi_assert(e);
+		ubi_assert(e->ec);
+		ubi->lookuptbl[pnum] = e;
+	}
+
+	spin_unlock(&ubi->wl_lock);
+
+	err = schedule_erase(ubi, e, torture);
+
+	return err;
+}
+
+/**
  * wear_leveling_worker - wear-leveling worker function.
  * @ubi: UBI device description object
  * @wrk: the work object
@@ -981,6 +1152,8 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 
 	dbg_wl("erase PEB %d EC %d", pnum, e->ec);
 
+	ubi_assert(!ubi_is_fm_block(ubi, e->pnum));
+
 	err = sync_erase(ubi, e, wl_wrk->torture);
 	if (!err) {
 		/* Fine, we've erased it successfully */
@@ -1415,6 +1588,7 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 
 		e->pnum = aeb->pnum;
 		e->ec = aeb->ec;
+		ubi_assert(!ubi_is_fm_block(ubi, e->pnum));
 		ubi->lookuptbl[e->pnum] = e;
 		if (schedule_erase(ubi, e, 0)) {
 			kmem_cache_free(ubi_wl_entry_slab, e);
@@ -1432,7 +1606,10 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 		e->pnum = aeb->pnum;
 		e->ec = aeb->ec;
 		ubi_assert(e->ec >= 0);
+		ubi_assert(!ubi_is_fm_block(ubi, e->pnum));
+
 		wl_tree_add(e, &ubi->free);
+
 		ubi->lookuptbl[e->pnum] = e;
 	}
 
@@ -1447,6 +1624,9 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 			e->pnum = aeb->pnum;
 			e->ec = aeb->ec;
 			ubi->lookuptbl[e->pnum] = e;
+			if (ubi_is_fm_block(ubi, aeb->pnum))
+				continue;
+
 			if (!aeb->scrub) {
 				dbg_wl("add PEB %d EC %d to the used tree",
 				       e->pnum, e->ec);
-- 
1.7.6.5

