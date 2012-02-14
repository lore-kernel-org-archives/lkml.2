Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761182Ab2BNUzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 15:55:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:51587 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761053Ab2BNUzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 15:55:01 -0500
From: Richard Weinberger <rw@linutronix.de>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, tim.bird@am.sony.com,
        dedekind1@gmail.com, Richard Weinberger <rw@linutronix.de>
Subject: [RFC][PATCH 6/7] MTD: UBI: Implement checkpointing support
Date: Tue, 14 Feb 2012 21:06:45 +0100
Message-Id: <1329250006-22944-7-git-send-email-rw@linutronix.de>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1329250006-22944-1-git-send-email-rw@linutronix.de>
References: <1329250006-22944-1-git-send-email-rw@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implements UBI checkpointing support.
It reduces the attaching time from O(N) to O(1).
Checkpoints are written on demand and upon changes of the volume layout.
If the recovery from a checkpoint fails we fall back to scanning mode.

Signed-off-by: Richard Weinberger <rw@linutronix.de>
---
 drivers/mtd/ubi/Kconfig      |    7 +
 drivers/mtd/ubi/Makefile     |    1 +
 drivers/mtd/ubi/checkpoint.c |  975 ++++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/ubi/ubi.h        |    6 +
 4 files changed, 989 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mtd/ubi/checkpoint.c

diff --git a/drivers/mtd/ubi/Kconfig b/drivers/mtd/ubi/Kconfig
index 4dcc752..cae1419 100644
--- a/drivers/mtd/ubi/Kconfig
+++ b/drivers/mtd/ubi/Kconfig
@@ -51,6 +51,13 @@ config MTD_UBI_GLUEBI
 	   volume. This is handy to make MTD-oriented software (like JFFS2)
 	   work on top of UBI. Do not enable this unless you use legacy
 	   software.
+config MTD_UBI_CHECKPOINT
+	bool "UBI checkpointing (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	default n
+	help
+	   This option enables UBI checkpointing - it allows attaching UBI
+	   devices without scanning the whole MTD device.
 
 config MTD_UBI_DEBUG
 	bool "UBI debugging"
diff --git a/drivers/mtd/ubi/Makefile b/drivers/mtd/ubi/Makefile
index c9302a5..845312a 100644
--- a/drivers/mtd/ubi/Makefile
+++ b/drivers/mtd/ubi/Makefile
@@ -3,5 +3,6 @@ obj-$(CONFIG_MTD_UBI) += ubi.o
 ubi-y += vtbl.o vmt.o upd.o build.o cdev.o kapi.o eba.o io.o wl.o scan.o
 ubi-y += misc.o
 
+ubi-$(CONFIG_MTD_UBI_CHECKPOINT) += checkpoint.o
 ubi-$(CONFIG_MTD_UBI_DEBUG) += debug.o
 obj-$(CONFIG_MTD_UBI_GLUEBI) += gluebi.o
diff --git a/drivers/mtd/ubi/checkpoint.c b/drivers/mtd/ubi/checkpoint.c
new file mode 100644
index 0000000..a0aa398
--- /dev/null
+++ b/drivers/mtd/ubi/checkpoint.c
@@ -0,0 +1,975 @@
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
+/* Allocates a new VID header for the checkpoint itself */
+static struct ubi_vid_hdr *new_cp_vhdr(struct ubi_device *ubi, int vol_id)
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
+	/* the checkpoint has be deleted on older kernels */
+	new->compat = UBI_COMPAT_DELETE;
+
+out:
+	return new;
+}
+
+/* Creates and adds a SEB to a given list */
+static int add_seb(struct ubi_scan_info *si, struct list_head *list,
+		   int pnum, int ec)
+{
+	struct ubi_scan_leb *seb;
+
+	seb = kmem_cache_alloc(si->scan_leb_slab, GFP_KERNEL);
+	if (!seb)
+		return -ENOMEM;
+
+	seb->pnum = pnum;
+	seb->ec = ec;
+	seb->lnum = -1;
+	seb->scrub = seb->copy_flag = seb->sqnum = 0;
+
+	si->ec_sum += seb->ec;
+	si->ec_count++;
+
+	if (si->max_ec < seb->ec)
+		si->max_ec = seb->ec;
+
+	if (si->min_ec > seb->ec)
+		si->min_ec = seb->ec;
+
+	list_add_tail(&seb->u.list, list);
+
+	return 0;
+}
+
+/* Creates and adds a scan volume into ubi_scan_info */
+static struct ubi_scan_volume *add_vol(struct ubi_scan_info *si, int vol_id,
+				       int used_ebs, int data_pad, u8 vol_type,
+				       int last_eb_bytes)
+{
+	struct ubi_scan_volume *sv;
+	struct rb_node **p = &si->volumes.rb_node, *parent = NULL;
+
+	while (*p) {
+		parent = *p;
+		sv = rb_entry(parent, struct ubi_scan_volume, rb);
+
+		if (vol_id > sv->vol_id)
+			p = &(*p)->rb_left;
+		else if (vol_id > sv->vol_id)
+			p = &(*p)->rb_right;
+	}
+
+	sv = kmalloc(sizeof(struct ubi_scan_volume), GFP_KERNEL);
+	if (!sv)
+		goto out;
+
+	sv->highest_lnum = sv->leb_count = 0;
+	sv->vol_id = vol_id;
+	sv->used_ebs = used_ebs;
+	sv->data_pad = data_pad;
+	sv->last_data_size = last_eb_bytes;
+	sv->compat = 0;
+	sv->vol_type = vol_type;
+	sv->root = RB_ROOT;
+
+	rb_link_node(&sv->rb, parent, p);
+	rb_insert_color(&sv->rb, &si->volumes);
+	
+out:
+	return sv;
+}
+
+/* Assigns a SEB to a given scan_volume and removes it from it's original list */
+static void assign_seb_to_sv(struct ubi_scan_info *si, struct ubi_scan_leb *seb,
+		      struct ubi_scan_volume *sv)
+{
+	struct ubi_scan_leb *tmp_seb;
+	struct rb_node **p = &si->volumes.rb_node, *parent = NULL;
+
+	p = &sv->root.rb_node;
+	while (*p) {
+		parent = *p;
+
+		tmp_seb = rb_entry(parent, struct ubi_scan_leb, u.rb);
+		if (seb->lnum != tmp_seb->lnum) {
+			if (seb->lnum < tmp_seb->lnum)
+				p = &(*p)->rb_left;
+			else
+				p = &(*p)->rb_right;
+
+			continue;
+		} else
+			break;
+	}
+
+	list_del(&seb->u.list);
+	sv->leb_count++;
+	
+	rb_link_node(&seb->u.rb, parent, p);
+	rb_insert_color(&seb->u.rb, &sv->root);
+}
+
+/* Inserts or updates a LEB which was found in the pool */
+static int update_vol(struct ubi_scan_info *si, struct ubi_scan_volume *sv,
+		      struct ubi_vid_hdr *new_vh, struct ubi_scan_leb *new_seb)
+{
+	struct rb_node **p = &sv->root.rb_node, *parent = NULL;
+	struct ubi_scan_leb *seb, *victim;
+
+	while (*p) {
+		parent = *p;
+		seb = rb_entry(parent, struct ubi_scan_leb, u.rb);
+
+		if (be32_to_cpu(new_vh->lnum) != seb->lnum) {
+			if (be32_to_cpu(new_vh->lnum) < seb->lnum)
+				p = &(*p)->rb_left;
+			else
+				p = &(*p)->rb_right;
+
+			continue;
+		}
+
+		if (be32_to_cpu(new_vh->sqnum) && seb->sqnum == be32_to_cpu(new_vh->sqnum)) {
+			ubi_err("two LEBs with same sequence number %llu", seb->sqnum);
+			goto fail;
+		}
+
+		if (seb->sqnum > be32_to_cpu(new_vh->sqnum)) {
+			ubi_err("LEB on PEB %i is older than checkpoint?!", seb->pnum);
+
+			goto fail;
+		}
+
+		dbg_bld("Vol %i: Replacing LEB %i's PEB %i with PEB %i\n", sv->vol_id, seb->lnum, seb->pnum, new_seb->pnum);
+
+		victim = kmem_cache_alloc(si->scan_leb_slab, GFP_KERNEL);
+		if (!victim)
+			return -ENOMEM;
+
+		victim->copy_flag = 0;
+		victim->scrub = 0;
+		victim->ec = seb->ec;
+		victim->pnum = seb->pnum;
+		victim->lnum = seb->lnum;
+		list_add_tail(&victim->u.list, &si->erase);
+
+		seb->ec = new_seb->ec;
+		seb->pnum = new_seb->pnum;
+		kmem_cache_free(si->scan_leb_slab, new_seb);
+
+		return 0;
+	}
+
+	/* This LEB is new, let's add it to the volume */
+	dbg_bld("Vol %i (type = %i): SEB %i is new, adding it!\n", sv->vol_type, sv->vol_id, new_seb->lnum);
+
+	if (sv->vol_type == UBI_STATIC_VOLUME) {
+		sv->used_ebs++;
+		sv->leb_count++;
+	}
+
+	rb_link_node(&new_seb->u.rb, parent, p);
+	rb_insert_color(&new_seb->u.rb, &sv->root);
+
+	return 0;
+fail:
+	return -EINVAL;
+}
+
+/* Processes a SEB which was found in the pool */
+static int process_pool_seb(struct ubi_scan_info *si, struct ubi_vid_hdr *new_vh,
+			    struct ubi_scan_leb *new_seb)
+{
+	struct ubi_scan_volume *sv, *tmp_sv = NULL;
+	struct rb_node **p = &si->volumes.rb_node, *parent = NULL;
+	int found = 0;
+
+	if (be32_to_cpu(new_vh->vol_id) == UBI_CP_SB_VOLUME_ID ||
+		be32_to_cpu(new_vh->vol_id) == UBI_CP_DATA_VOLUME_ID) {
+		kmem_cache_free(si->scan_leb_slab, new_seb);
+
+		return 0;
+	}
+
+	while (*p) {
+		parent = *p;
+		tmp_sv = rb_entry(parent, struct ubi_scan_volume, rb);
+
+		if (be32_to_cpu(new_vh->vol_id) > tmp_sv->vol_id)
+			p = &(*p)->rb_left;
+		else if (be32_to_cpu(new_vh->vol_id) < tmp_sv->vol_id)
+			p = &(*p)->rb_right;
+		else {
+			found = 1;
+			break;
+		}
+	}
+
+	if (found)
+		sv = tmp_sv;
+	else {
+		ubi_err("Orphaned volume in checkpoint pool!");
+		return -EINVAL;
+	}
+
+	ubi_assert(be32_to_cpu(new_vh->vol_id) == sv->vol_id);
+
+	return update_vol(si, sv, new_vh, new_seb);
+}
+
+static int scan_pool(struct ubi_device *ubi, struct ubi_scan_info *si,
+	int *pebs, int pool_size, unsigned long long *max_sqnum2)
+{
+	struct ubi_vid_hdr *vh;
+	struct ubi_scan_leb *new_seb;
+	int i;
+	int pnum;
+	int err;
+
+	vh = ubi_zalloc_vid_hdr(ubi, GFP_KERNEL);
+	if (!vh)
+		return -ENOMEM;
+
+	/* 
+	 * Now scan all PEB in the pool to find changes which have been made 
+	 * after the creation of the checkpoint
+	 */
+	for (i = 0; i < pool_size; i++) {
+		pnum = be32_to_cpu(pebs[i]);
+		err = ubi_io_read_vid_hdr(ubi, pnum, vh, 0);
+
+		if (err == UBI_IO_FF)
+			continue;
+		else if (err == 0) {
+			dbg_bld("PEB %i in pool is no longer free, scanning it! Vid %i", pnum, be32_to_cpu(vh->vol_id));
+
+			new_seb = kmem_cache_alloc(si->scan_leb_slab, GFP_KERNEL);
+			if (!new_seb) {
+				ubi_free_vid_hdr(ubi, vh);
+				return -ENOMEM;
+			}
+
+			new_seb->ec = -1;
+			new_seb->pnum = pnum;
+			new_seb->lnum = be32_to_cpu(vh->lnum);
+			new_seb->sqnum = be64_to_cpu(vh->sqnum);
+			new_seb->copy_flag = 0;
+			new_seb->scrub = 0;
+
+			err = process_pool_seb(si, vh, new_seb);
+			if (err) {
+				ubi_free_vid_hdr(ubi, vh);
+				return err;
+			}
+
+			if (*max_sqnum2 < new_seb->sqnum)
+				*max_sqnum2 = new_seb->sqnum;
+		} else {
+			/* We are paranoid and fall back to scanning mode */
+			ubi_err("Checkpoint pool PEBs contains damaged PEBs!");
+			ubi_free_vid_hdr(ubi, vh);
+			return err;
+		}
+		
+	}
+	ubi_free_vid_hdr(ubi, vh);
+
+	return 0;
+}
+
+/* Creates ubi_scan_info from the checkpoint */
+struct ubi_scan_info *ubi_scan_checkpoint(struct ubi_device *ubi,
+					  char *cp_raw,
+					  size_t cp_size)
+{
+	struct list_head used;
+	struct ubi_scan_volume *sv;
+	struct ubi_scan_leb *seb, *tmp_seb, *_tmp_seb;
+	struct ubi_scan_info *si;
+	int i, j;
+
+	size_t cp_pos = 0;
+	struct ubi_cp_sb *cpsb;
+	struct ubi_cp_hdr *cphdr;
+	struct ubi_cp_long_pool *cplpl;
+	struct ubi_cp_short_pool *cpspl;
+	struct ubi_cp_unk_pool *cpupl;
+	struct ubi_cp_ec *cpec;
+	struct ubi_cp_volhdr *cpvhdr;
+	struct ubi_cp_eba *cp_eba;
+
+	unsigned long long max_sqnum2 = 0;
+
+	si = kzalloc(sizeof(struct ubi_scan_info), GFP_KERNEL);
+	if (!si)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&used);
+	INIT_LIST_HEAD(&si->corr);
+	INIT_LIST_HEAD(&si->free);
+	INIT_LIST_HEAD(&si->erase);
+	INIT_LIST_HEAD(&si->alien);
+	si->volumes = RB_ROOT;
+
+	si->scan_leb_slab = kmem_cache_create("ubi_scan_leb_slab",
+					      sizeof(struct ubi_scan_leb),
+					      0, 0, NULL);
+	if (!si->scan_leb_slab)
+		goto out_si;
+
+	si->min_ec = UBI_MAX_ERASECOUNTER;
+
+	cpsb = (struct ubi_cp_sb *)(cp_raw);
+	si->max_sqnum = cpsb->sqnum;
+	cp_pos += sizeof(struct ubi_cp_sb);
+	if (cp_pos >= cp_size)
+		goto out_si;
+
+	cphdr = (struct ubi_cp_hdr *)(cp_raw + cp_pos);
+	cp_pos += sizeof(*cphdr);
+
+	if (cphdr->magic != UBI_CP_HDR_MAGIC)
+		goto out_si;
+
+	cplpl = (struct ubi_cp_long_pool *)(cp_raw + cp_pos);
+	cp_pos += sizeof(*cplpl);
+	if (cplpl->magic != UBI_CP_LPOOL_MAGIC)
+		goto out_si;
+
+	cpspl = (struct ubi_cp_short_pool *)(cp_raw + cp_pos);
+	cp_pos += sizeof(*cpspl);
+	if (cpspl->magic != UBI_CP_SPOOL_MAGIC)
+		goto out_si;
+
+	cpupl = (struct ubi_cp_unk_pool *)(cp_raw + cp_pos);
+	cp_pos += sizeof(*cpupl);
+	if (cpupl->magic != UBI_CP_UPOOL_MAGIC)
+		goto out_si;
+
+	/* read EC values from free list */
+	for (i = 0; i < be32_to_cpu(cphdr->nfree); i++) {
+		cpec = (struct ubi_cp_ec *)(cp_raw + cp_pos);
+		cp_pos += sizeof(*cpec);
+		if (cp_pos >= cp_size)
+			goto out_si;
+
+		add_seb(si, &si->free, be32_to_cpu(cpec->pnum),
+			be32_to_cpu(cpec->ec));
+	}
+
+	/* read EC values from used list */
+	for (i = 0; i < be32_to_cpu(cphdr->nused); i++) {
+		cpec = (struct ubi_cp_ec *)(cp_raw + cp_pos);
+		cp_pos += sizeof(*cpec);
+		if (cp_pos >= cp_size) goto out_si;
+	
+		add_seb(si, &used, be32_to_cpu(cpec->pnum),
+			be32_to_cpu(cpec->ec));
+	}
+
+	si->mean_ec = div_u64(si->ec_sum, si->ec_count);
+
+	/* Iterate over all volumes and read their EBA table */
+	for (i = 0; i < be32_to_cpu(cphdr->nvol); i++) {
+		cpvhdr = (struct ubi_cp_volhdr *)(cp_raw + cp_pos);
+		cp_pos += sizeof(*cpvhdr);
+
+		dbg_bld("Found Volume %i! nused: %i\n", be32_to_cpu(cpvhdr->vol_id), be32_to_cpu(cpvhdr->used_ebs));
+
+		if (cpvhdr->magic != UBI_CP_VHDR_MAGIC)
+			goto out_si;
+
+		sv = add_vol(si, be32_to_cpu(cpvhdr->vol_id),
+			be32_to_cpu(cpvhdr->used_ebs),
+			be32_to_cpu(cpvhdr->data_pad),
+			cpvhdr->vol_type, be32_to_cpu(cpvhdr->last_eb_bytes));
+
+		if (!sv)
+			goto out_si;
+
+		si->vols_found++;
+		if (si->highest_vol_id < be32_to_cpu(cpvhdr->vol_id))
+			si->highest_vol_id = be32_to_cpu(cpvhdr->vol_id);
+
+		for (j = 0; j < be32_to_cpu(cpvhdr->used_ebs); j++) {
+			cp_eba = (struct ubi_cp_eba *)(cp_raw + cp_pos);
+			cp_pos += sizeof(*cp_eba);
+			if (cp_pos >= cp_size)
+				goto out_si;
+
+			if ((int)be32_to_cpu(cp_eba->pnum) < 0)
+				continue;
+
+			seb = NULL;
+			list_for_each_entry(tmp_seb, &used, u.list) {
+				if (tmp_seb->pnum == be32_to_cpu(cp_eba->pnum))
+					seb = tmp_seb;
+			}
+			
+			/* Not good, a EBA entry points to a PEB which is not in our used list */
+			if (!seb)
+				goto out_si;
+
+			seb->lnum = be32_to_cpu(cp_eba->lnum);
+			assign_seb_to_sv(si, seb, sv);
+
+			dbg_bld("Inserting pnum %i (leb %i) to vol %i", seb->pnum, seb->lnum, sv->vol_id);
+		}
+	}
+
+	/*
+	 * The remainning PEB in the used list are not used.
+	 * They lived in the checkpoint pool but got never used.
+	 */  
+	list_for_each_entry_safe(tmp_seb, _tmp_seb, &used, u.list) {
+		list_del(&tmp_seb->u.list);
+		list_add_tail(&tmp_seb->u.list, &si->free);
+	}
+
+	if (scan_pool(ubi, si, cplpl->pebs, be32_to_cpu(cplpl->size), &max_sqnum2) < 0)
+		goto out_si;
+	if (scan_pool(ubi, si, cpspl->pebs, be32_to_cpu(cpspl->size), &max_sqnum2) < 0)
+		goto out_si;
+	if (scan_pool(ubi, si, cpupl->pebs, be32_to_cpu(cpupl->size), &max_sqnum2) < 0)
+		goto out_si;
+
+	if (max_sqnum2 > si->max_sqnum)
+		si->max_sqnum = max_sqnum2;
+
+	return si;
+
+out_si:
+	ubi_scan_destroy_si(si);
+	return NULL;
+}
+
+/* Reads the checkpoint data from it's PEBs */
+struct ubi_scan_info *ubi_read_checkpoint(struct ubi_device *ubi, int cb_sb_pnum)
+{
+	struct ubi_cp_sb *cpsb;
+	struct ubi_vid_hdr *vh;
+	int ret, i, nblocks;
+	char *cp_raw;
+	size_t cp_size;
+	__be32 data_crc;
+	unsigned long long sqnum = 0;
+	struct ubi_scan_info *si = NULL;
+
+	cpsb = kmalloc(sizeof(*cpsb), GFP_KERNEL);
+	if (!cpsb) {
+		si = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+
+	ret = ubi_io_read(ubi, cpsb, cb_sb_pnum, ubi->leb_start, sizeof(*cpsb));
+	if (ret) {
+		ubi_err("Unable to read checkpoint super block");
+		si = ERR_PTR(ret);
+		goto out;
+	}
+
+	if (cpsb->magic != UBI_CP_SB_MAGIC) {
+		ubi_err("Super block magic does not match");
+		si = ERR_PTR(-EINVAL);
+		goto free_sb;
+	}
+
+	if (cpsb->version != UBI_CP_FMT_VERSION) {
+		ubi_err("Unknown checkpoint format version!");
+		si = ERR_PTR(-EINVAL);
+		goto free_sb;
+	}
+
+	nblocks = be32_to_cpu(cpsb->nblocks);
+
+	if (nblocks > UBI_CP_MAX_BLOCKS || nblocks < 1) {
+		ubi_err("Number of checkpoint blocks is invalid");
+		si = ERR_PTR(-EINVAL);
+		goto free_sb;
+	}
+
+	cp_size = ubi->leb_size * nblocks;
+	/* cp_raw will contain the whole checkpoint */
+	cp_raw = vzalloc(cp_size);
+	if (!cp_raw) {
+		si = ERR_PTR(-ENOMEM);
+		goto free_sb;
+	}
+
+	vh = ubi_zalloc_vid_hdr(ubi, GFP_KERNEL);
+	if (!vh) {
+		si = ERR_PTR(-ENOMEM);
+		goto free_raw;
+	}	
+
+	for (i = 0; i < nblocks; i++) {
+		ret = ubi_io_read_vid_hdr(ubi, be32_to_cpu(cpsb->block_loc[i]), vh, 0);
+		if (ret) {
+			ubi_err("Unable to read checkpoint block# %i (PEB: %i)", i, be32_to_cpu(cpsb->block_loc[i]));
+			si = ERR_PTR(ret);
+			goto free_vhdr;
+		}
+
+		if (i == 0) {
+			if (be32_to_cpu(vh->vol_id) != UBI_CP_SB_VOLUME_ID) {
+				si = ERR_PTR(-EINVAL);
+				goto free_vhdr;
+			}
+		} else {
+			if (be32_to_cpu(vh->vol_id) != UBI_CP_DATA_VOLUME_ID) {
+				goto free_vhdr;
+				si = ERR_PTR(-EINVAL);
+			}
+		}
+
+		if (sqnum < be64_to_cpu(vh->sqnum))
+			sqnum = be64_to_cpu(vh->sqnum);
+
+		ret = ubi_io_read(ubi, cp_raw + (ubi->leb_size * i),
+				  be32_to_cpu(cpsb->block_loc[i]), ubi->leb_start,
+				  ubi->leb_size);
+		
+		if (ret) {
+			ubi_err("Unable to read checkpoint block# %i (PEB: %i)", i, be32_to_cpu(cpsb->block_loc[i]));
+			si = ERR_PTR(ret);
+			goto free_vhdr;
+		}
+	}
+
+
+	cpsb = (struct ubi_cp_sb *)cp_raw;
+	data_crc = crc32_be(UBI_CRC32_INIT, cp_raw + sizeof(*cpsb), cp_size - sizeof(*cpsb));
+	if (data_crc != cpsb->data_crc){
+		ubi_err("Checkpoint data CRC is invalid");
+		si = ERR_PTR(-EINVAL);
+		goto free_vhdr;
+	}
+
+	cpsb->sqnum = sqnum;
+
+	si = ubi_scan_checkpoint(ubi, cp_raw, cp_size);
+	if (!si) {
+		si = ERR_PTR(-EINVAL);
+		goto free_vhdr;
+	}
+
+	/* Store the checkpoint position into the ubi_device struct */
+	ubi->cp = kmalloc(sizeof(struct ubi_checkpoint), GFP_KERNEL);
+	if (!ubi->cp) {
+		si = ERR_PTR(-ENOMEM);
+		ubi_scan_destroy_si(si);
+		goto free_vhdr;
+	}
+
+	ubi->cp->size = cp_size;
+	ubi->cp->used_blocks = nblocks;
+
+	for (i = 0; i < UBI_CP_MAX_BLOCKS; i++) {
+		if (i < nblocks) {
+			ubi->cp->peb[i] = be32_to_cpu(cpsb->block_loc[i]);
+			ubi->cp->ec[i] = be32_to_cpu(cpsb->block_ec[i]);
+		}
+		else {
+			ubi->cp->peb[i] = -1;
+			ubi->cp->ec[i] = 0;
+		}
+	}
+
+free_vhdr:
+	ubi_free_vid_hdr(ubi, vh);
+free_raw:
+	vfree(cp_raw);
+free_sb:
+	kfree(cpsb);
+out:
+	return si;
+}
+
+/* Searches the first UBI_CP_MAX_START PEBs for the checkpoint super block */
+int ubi_find_checkpoint(struct ubi_device *ubi)
+{
+	int i, ret;
+	int cp_sb = -ENOENT;
+	struct ubi_vid_hdr *vhdr;
+
+	vhdr = ubi_zalloc_vid_hdr(ubi, GFP_KERNEL);
+	if (!vhdr)
+		return -ENOMEM;
+
+	for (i = 0; i < UBI_CP_MAX_START; i++) {
+		ret = ubi_io_read_vid_hdr(ubi, i, vhdr, 0);
+		/* ignore read errors */
+		if (ret)
+			continue;
+
+		if (be32_to_cpu(vhdr->vol_id) == UBI_CP_SB_VOLUME_ID) {
+			cp_sb = i;
+			break;
+		}
+	}
+	
+	ubi_free_vid_hdr(ubi, vhdr);
+	return cp_sb;
+}
+
+static int ubi_create_checkpoint(struct ubi_device *ubi,
+				 struct ubi_checkpoint *new_cp)
+{
+	int ret;
+	size_t cp_pos = 0;
+	char *cp_raw;
+	int i, j;
+
+	struct ubi_cp_sb *cpsb;
+	struct ubi_cp_hdr *cph;
+	struct ubi_cp_long_pool *cplpl;
+	struct ubi_cp_short_pool *cpspl;
+	struct ubi_cp_unk_pool *cpupl;
+	struct ubi_cp_ec *cec;
+	struct ubi_cp_volhdr *cvh;
+	struct ubi_cp_eba *ceba;
+
+	struct rb_node *node;
+	struct ubi_wl_entry *wl_e;
+	struct ubi_volume *vol;
+
+	struct ubi_vid_hdr *svhdr, *dvhdr;
+
+	int nfree, nused, nvol;
+
+	cp_raw = vzalloc(new_cp->size);
+	if (!cp_raw) {
+		ret = -ENOMEM;
+
+		goto out;
+	}
+
+	svhdr = new_cp_vhdr(ubi, UBI_CP_SB_VOLUME_ID);
+	if (!svhdr) {
+		ret = -ENOMEM;
+
+		goto out_vfree;
+	}
+	
+	dvhdr = new_cp_vhdr(ubi, UBI_CP_DATA_VOLUME_ID);
+	if (!dvhdr) {
+		ret = -ENOMEM;
+
+		goto out_kfree;
+	}
+
+	ubi_flush_prot_queue(ubi);
+
+	spin_lock(&ubi->volumes_lock);
+	spin_lock(&ubi->wl_lock);
+
+	cpsb = (struct ubi_cp_sb *)cp_raw;
+	cp_pos += sizeof(*cpsb);
+	ubi_assert(cp_pos <= new_cp->size);
+
+	cph = (struct ubi_cp_hdr *)(cp_raw + cp_pos);
+	cp_pos += sizeof(*cph);
+	ubi_assert(cp_pos <= new_cp->size);
+
+	cpsb->magic = UBI_CP_SB_MAGIC;
+	cpsb->version = UBI_CP_FMT_VERSION;
+	cpsb->nblocks = cpu_to_be32(new_cp->used_blocks);
+	/* the max sqnum will be filled in while *reading* the checkpoint */
+	cpsb->sqnum = 0;
+
+	cph->magic = UBI_CP_HDR_MAGIC;
+	nfree = 0;
+	nused = 0;
+	nvol = 0;
+
+	cplpl = (struct ubi_cp_long_pool *)(cp_raw + cp_pos);
+	cp_pos += sizeof(*cplpl);
+	cplpl->magic = UBI_CP_LPOOL_MAGIC;
+	cplpl->size = cpu_to_be32(ubi->long_pool.size);
+
+	cpspl = (struct ubi_cp_short_pool *)(cp_raw + cp_pos);
+	cp_pos += sizeof(*cpspl);
+	cpspl->magic = UBI_CP_SPOOL_MAGIC;
+	cpspl->size = cpu_to_be32(ubi->short_pool.size);
+
+	cpupl = (struct ubi_cp_unk_pool *)(cp_raw + cp_pos);
+	cp_pos += sizeof(*cpupl);
+	cpupl->magic = UBI_CP_UPOOL_MAGIC;
+	cpupl->size = cpu_to_be32(ubi->unk_pool.size);
+
+	for (i = 0; i < ubi->long_pool.size; i++)
+		cplpl->pebs[i] = cpu_to_be32(ubi->long_pool.pebs[i]);
+
+	for (i = 0; i < ubi->short_pool.size; i++)
+		cpspl->pebs[i] = cpu_to_be32(ubi->short_pool.pebs[i]);
+
+	for (i = 0; i < ubi->unk_pool.size; i++)
+		cpupl->pebs[i] = cpu_to_be32(ubi->unk_pool.pebs[i]);
+
+	for (node = rb_first(&ubi->free); node; node = rb_next(node)) {
+		wl_e = rb_entry(node, struct ubi_wl_entry, u.rb);
+		cec = (struct ubi_cp_ec *)(cp_raw + cp_pos);
+
+		cec->pnum = cpu_to_be32(wl_e->pnum);
+		cec->ec = cpu_to_be32(wl_e->ec);
+
+		nfree++;
+		cp_pos += sizeof(*cec);
+		ubi_assert(cp_pos <= new_cp->size);
+	}
+	cph->nfree = cpu_to_be32(nfree);
+
+	for (node = rb_first(&ubi->used); node; node = rb_next(node)) {
+		wl_e = rb_entry(node, struct ubi_wl_entry, u.rb);
+		cec = (struct ubi_cp_ec *)(cp_raw + cp_pos);
+
+		cec->pnum = cpu_to_be32(wl_e->pnum);
+		cec->ec = cpu_to_be32(wl_e->ec);
+
+		nused++;
+		cp_pos += sizeof(*cec);
+		ubi_assert(cp_pos <= new_cp->size);
+	}
+	cph->nused = cpu_to_be32(nused);
+
+	for (i = 0; i < UBI_MAX_VOLUMES + UBI_INT_VOL_COUNT; i++) {
+		vol = ubi->volumes[i];
+
+		if (!vol)
+			continue;
+
+		nvol++;
+
+		cvh = (struct ubi_cp_volhdr *)(cp_raw + cp_pos);
+		cp_pos += sizeof(*cvh);
+		ubi_assert(cp_pos <= new_cp->size);
+
+		cvh->magic = UBI_CP_VHDR_MAGIC;
+		cvh->vol_id = cpu_to_be32(vol->vol_id);
+		cvh->vol_type = vol->vol_type;
+		cvh->used_ebs = cpu_to_be32(vol->used_ebs);
+		cvh->data_pad = cpu_to_be32(vol->data_pad);
+		cvh->last_eb_bytes = cpu_to_be32(vol->last_eb_bytes);
+
+		ubi_assert(vol->vol_type == UBI_DYNAMIC_VOLUME || vol->vol_type == UBI_STATIC_VOLUME);
+
+		for (j = 0; j < vol->used_ebs; j++) {
+			ceba = (struct ubi_cp_eba *)(cp_raw + cp_pos);
+
+			ceba->lnum = cpu_to_be32(j);
+			ceba->pnum = cpu_to_be32(vol->eba_tbl[j]);
+
+			cp_pos += sizeof(*ceba);
+			ubi_assert(cp_pos <= new_cp->size);
+		}		
+	}
+	cph->nvol = cpu_to_be32(nvol);
+
+	svhdr->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
+	svhdr->lnum = 0;
+
+	spin_unlock(&ubi->wl_lock);
+	spin_unlock(&ubi->volumes_lock);
+
+	dbg_bld("Writing checkpoint SB to PEB %i\n", new_cp->peb[0]);
+	ret = ubi_io_write_vid_hdr(ubi, new_cp->peb[0], svhdr);	
+	if (ret) {
+		ubi_err("Unable to write vid_hdr to checkpoint SB!\n");
+		goto out_kfree;
+	}
+
+	for (i = 0; i < UBI_CP_MAX_BLOCKS; i++) {
+		cpsb->block_loc[i] = cpu_to_be32(new_cp->peb[i]);
+		cpsb->block_ec[i] = cpu_to_be32(new_cp->ec[i]);
+	}
+
+	cpsb->data_crc = 0;
+	cpsb->data_crc = crc32_be(UBI_CRC32_INIT, cp_raw + sizeof(*cpsb), new_cp->size - sizeof(*cpsb));
+
+	for (i = 1; i < new_cp->used_blocks; i++) {
+		dvhdr->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
+		dvhdr->lnum = cpu_to_be32(i);
+		dbg_bld("Writing checkpoint data to PEB %i sqnum %llu\n", new_cp->peb[i], be64_to_cpu(dvhdr->sqnum));
+		ret = ubi_io_write_vid_hdr(ubi, new_cp->peb[i], dvhdr);
+		if (ret) {
+			ubi_err("Unable to write vid_hdr to PEB %i!\n", new_cp->peb[i]);
+			goto out_kfree;
+		}
+	}
+
+	for (i = 0; i < new_cp->used_blocks; i++) {
+		ret = ubi_io_write(ubi, cp_raw + (i * ubi->leb_size), new_cp->peb[i], ubi->leb_start, ubi->leb_size);
+		if (ret) {
+			ubi_err("Unable to write checkpoint to PEB %i!\n", new_cp->peb[i]);
+			goto out_kfree;
+		}
+	}
+
+	ubi->cp = new_cp;
+
+	ubi_msg("Checkpoint written!");
+
+out_kfree:
+	kfree(svhdr);
+out_vfree:
+	vfree(cp_raw);
+out:
+	return ret;
+}
+
+/* Will be called by UBI upon volume creation/deletion/etc.. */
+int ubi_update_checkpoint(struct ubi_device *ubi)
+{
+	int ret, i;
+	struct ubi_checkpoint *new_cp, *old_cp;
+	struct ubi_wl_entry *e;
+
+	if (ubi->ro_mode)
+		return 0;
+
+	new_cp = kmalloc(sizeof(*new_cp), GFP_KERNEL);
+	if (!new_cp)
+		return -ENOMEM;
+
+	old_cp = ubi->cp;
+	ubi->cp = NULL;
+
+	if (old_cp) {
+		new_cp->peb[0] = ubi_wl_get_cp_peb(ubi, UBI_CP_MAX_START);
+		/* no fresh early PEB was found, reuse the old one */
+		if (new_cp->peb[0] < 0) {
+			struct ubi_ec_hdr *ec_hdr;
+
+			ec_hdr = kmalloc(sizeof(*ec_hdr), GFP_KERNEL);
+			if (!ec_hdr) {
+				kfree(new_cp);
+				return -ENOMEM;
+			}
+
+			/* we have to erase the block by hand */
+			ret = ubi_io_read_ec_hdr(ubi, old_cp->peb[0], ec_hdr, 0);
+			if (!ret) {
+				ubi_err("Unable to read EC header");
+
+				kfree(new_cp);
+				kfree(ec_hdr);
+				return -EINVAL;
+			}
+
+			ret = ubi_io_sync_erase(ubi, new_cp->peb[0], 0);
+			if (ret < 0) {
+				ubi_err("Unable to erase old SB");
+
+				kfree(new_cp);
+				kfree(ec_hdr);
+				return -EINVAL;
+			}
+
+			ec_hdr->ec += ret;
+			if (ret > UBI_MAX_ERASECOUNTER) {
+				ubi_err("Erase counter overflow!");
+				kfree(new_cp);
+				kfree(ec_hdr);
+				return -EINVAL;
+			}
+
+			ret = ubi_io_write_ec_hdr(ubi, old_cp->peb[0], ec_hdr);
+			kfree(ec_hdr);
+			if (ret) {
+				ubi_err("Unable to write new EC header");
+				kfree(new_cp);			
+				return -EINVAL;
+			}
+
+			new_cp->peb[0] = old_cp->peb[0];
+		}
+		else
+			/* we've got a new early PEB, return the old one */
+			ubi_wl_put_cp_peb(ubi, old_cp->peb[0], 0);
+
+		/* return all other checkpoint block to the wl system */
+		for (i = 1; i < UBI_CP_MAX_BLOCKS; i++) {
+			if (old_cp->peb[i] >= 0)
+				ubi_wl_put_cp_peb(ubi, old_cp->peb[i], 0);
+			else
+				break;
+		}
+	} else {
+		new_cp->peb[0] = ubi_wl_get_cp_peb(ubi, UBI_CP_MAX_START);
+		if (new_cp->peb[0] < 0) {
+			ubi_err("Could not find an early PEB");
+			kfree(new_cp);
+			return -ENOSPC;
+		}
+	}
+
+	new_cp->size = sizeof(struct ubi_cp_hdr) + \
+			sizeof(struct ubi_cp_long_pool) + \
+			sizeof(struct ubi_cp_short_pool) + \
+			sizeof(struct ubi_cp_unk_pool) + \
+			ubi->peb_count * (sizeof(struct ubi_cp_ec) + \
+			sizeof(struct ubi_cp_eba)) + \
+			sizeof(struct ubi_cp_volhdr) * UBI_MAX_VOLUMES;
+	new_cp->size = roundup(new_cp->size, ubi->leb_size);
+
+       	new_cp->used_blocks = new_cp->size / ubi->leb_size;
+
+	if (new_cp->used_blocks > UBI_CP_MAX_BLOCKS) {
+		ubi_err("Checkpoint too large");
+		kfree(new_cp);
+
+		return -ENOSPC;
+	}
+
+	/* give the wl subsystem a chance to produce some free blocks */
+	cond_resched();
+
+	for (i = 1; i < UBI_CP_MAX_BLOCKS; i++) {
+		if (i < new_cp->used_blocks) {
+			new_cp->peb[i] = ubi_wl_get_cp_peb(ubi, INT_MAX);
+			if (new_cp->peb[i] < 0) {
+				ubi_err("Could not get any free erase block");
+
+				while (i--)
+					ubi_wl_put_cp_peb(ubi, new_cp->peb[i], 0);
+
+				kfree(new_cp);
+
+				return -ENOSPC;
+			}
+			e = ubi->lookuptbl[new_cp->peb[i]];
+			ubi_assert(e);
+			new_cp->ec[i] = e->ec;
+		} else {
+			new_cp->peb[i] = -1;
+			new_cp->ec[i] = 0;
+		}
+	}
+	
+	kfree(old_cp);
+
+	return ubi_create_checkpoint(ubi, new_cp);
+}
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 4e8e8d2..a5aa2b1 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -608,6 +608,12 @@ void ubi_do_get_device_info(struct ubi_device *ubi, struct ubi_device_info *di);
 void ubi_do_get_volume_info(struct ubi_device *ubi, struct ubi_volume *vol,
 			    struct ubi_volume_info *vi);
 
+/* checkpoint.c */
+int ubi_update_checkpoint(struct ubi_device *ubi);
+struct ubi_scan_info *ubi_read_checkpoint(struct ubi_device *ubi, int cb_sb_pnum);
+int ubi_update_checkpoint(struct ubi_device *ubi);
+int ubi_find_checkpoint(struct ubi_device *ubi);
+
 /*
  * ubi_rb_for_each_entry - walk an RB-tree.
  * @rb: a pointer to type 'struct rb_node' to use as a loop counter
-- 
1.7.7

