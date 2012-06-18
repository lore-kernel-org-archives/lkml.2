Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab2FRQT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:19:28 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47837 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124Ab2FRQT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:19:26 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 03/22] UBI: Fastmap: Keep fastmap after attaching
Date: Mon, 18 Jun 2012 18:18:46 +0200
Message-Id: <1340036345-96726-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340036345-96726-1-git-send-email-richard@nod.at>
References: <1340036345-96726-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/attach.c  |   14 +---------
 drivers/mtd/ubi/fastmap.c |   67 ++++++++++++++++++++++-----------------------
 drivers/mtd/ubi/ubi.h     |    2 -
 3 files changed, 34 insertions(+), 49 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index 1573d94..9ae66e4 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -1262,7 +1262,7 @@ int ubi_attach(struct ubi_device *ubi)
 	if (err)
 		goto out_wl;
 
-	if (ai->fm) {
+	if (ubi->fm) {
 		struct ubi_attach_info *scan_ai;
 		scan_ai = kzalloc(sizeof(struct ubi_attach_info), GFP_KERNEL);
 		if (!scan_ai)
@@ -1385,18 +1385,6 @@ void ubi_destroy_ai(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	if (ai->aeb_slab_cache)
 		kmem_cache_destroy(ai->aeb_slab_cache);
 
-	/* Return all PEBs back to the WL sub-system */
-	if (ai->fm) {
-		int i, torture;
-
-		for (i = 0; i < ai->fm->used_blocks; i++) {
-			torture = ai->fm->to_be_tortured[i];
-			ubi_wl_put_fm_peb(ubi, ai->fm->e[i], torture);
-		}
-
-		kfree(ai->fm);
-	}
-
 	kfree(ai);
 }
 
diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 5bbf1e3..9ed4723 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -774,6 +774,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	struct ubi_fm_sb *fmsb;
 	struct ubi_vid_hdr *vh;
 	struct ubi_ec_hdr *ech;
+	struct ubi_fastmap_layout *fm;
 	int i, used_blocks, pnum, sb_pnum = 0, ret = 0;
 	void *fm_raw = NULL;
 	size_t fm_size;
@@ -792,8 +793,8 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 		goto out;
 	}
 
-	ai->fm = kzalloc(sizeof(*ai->fm), GFP_KERNEL);
-	if (!ai->fm) {
+	fm = kzalloc(sizeof(*fm), GFP_KERNEL);
+	if (!fm) {
 		ret = -ENOMEM;
 		kfree(fmsb);
 		goto free_raw;
@@ -802,10 +803,10 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	ret = ubi_io_read(ubi, fmsb, sb_pnum, ubi->leb_start, sizeof(*fmsb));
 	if (ret && ret != UBI_IO_BITFLIPS) {
 		kfree(fmsb);
-		kfree(ai->fm);
+		kfree(fm);
 		goto out;
 	} else if (ret == UBI_IO_BITFLIPS)
-		ai->fm->to_be_tortured[0] = 1;
+		fm->to_be_tortured[0] = 1;
 
 	if (be32_to_cpu(fmsb->magic) != UBI_FM_SB_MAGIC) {
 		/* TODO: not urgent, but examine all the error messages and
@@ -818,7 +819,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 		ubi_err("super block magic does not match");
 		ret = UBI_BAD_FASTMAP;
 		kfree(fmsb);
-		kfree(ai->fm);
+		kfree(fm);
 		goto out;
 	}
 
@@ -826,7 +827,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 		ubi_err("unknown fastmap format version!");
 		ret = UBI_BAD_FASTMAP;
 		kfree(fmsb);
-		kfree(ai->fm);
+		kfree(fm);
 		goto out;
 	}
 
@@ -835,7 +836,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 		ubi_err("number of fastmap blocks is invalid");
 		ret = UBI_BAD_FASTMAP;
 		kfree(fmsb);
-		kfree(ai->fm);
+		kfree(fm);
 		goto out;
 	}
 
@@ -845,7 +846,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	if (!fm_raw) {
 		ret = -ENOMEM;
 		kfree(fmsb);
-		kfree(ai->fm);
+		kfree(fm);
 		goto out;
 	}
 
@@ -853,7 +854,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	if (!ech) {
 		ret = -ENOMEM;
 		kfree(fmsb);
-		kfree(ai->fm);
+		kfree(fm);
 		goto free_raw;
 	}
 
@@ -861,7 +862,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	if (!vh) {
 		ret = -ENOMEM;
 		kfree(fmsb);
-		kfree(ai->fm);
+		kfree(fm);
 		kfree(ech);
 		goto free_raw;
 	}
@@ -871,7 +872,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 
 		if (ubi_io_is_bad(ubi, pnum)) {
 			ret = UBI_BAD_FASTMAP;
-			kfree(ai->fm);
+			kfree(fm);
 			kfree(fmsb);
 			goto free_hdr;
 		}
@@ -883,10 +884,10 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 			if (ret > 0)
 				ret = UBI_BAD_FASTMAP;
 			kfree(fmsb);
-			kfree(ai->fm);
+			kfree(fm);
 			goto free_hdr;
 		} else if (ret == UBI_IO_BITFLIPS)
-			ai->fm->to_be_tortured[i] = 1;
+			fm->to_be_tortured[i] = 1;
 
 		if (!ubi->image_seq)
 			ubi->image_seq = be32_to_cpu(ech->image_seq);
@@ -894,7 +895,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 		if (be32_to_cpu(ech->image_seq) != ubi->image_seq) {
 			ret = UBI_BAD_FASTMAP;
 			kfree(fmsb);
-			kfree(ai->fm);
+			kfree(fm);
 			goto free_hdr;
 		}
 
@@ -903,7 +904,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 			ubi_err("unable to read fastmap block# %i (PEB: %i)",
 				i, pnum);
 			kfree(fmsb);
-			kfree(ai->fm);
+			kfree(fm);
 			goto free_hdr;
 		}
 
@@ -911,7 +912,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 			if (be32_to_cpu(vh->vol_id) != UBI_FM_SB_VOLUME_ID) {
 				ret = UBI_BAD_FASTMAP;
 				kfree(fmsb);
-				kfree(ai->fm);
+				kfree(fm);
 				goto free_hdr;
 			}
 		} else {
@@ -931,7 +932,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 			ubi_err("unable to read fastmap block# %i (PEB: %i)",
 				i, pnum);
 			kfree(fmsb);
-			kfree(ai->fm);
+			kfree(fm);
 			goto free_hdr;
 		}
 	}
@@ -945,7 +946,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	if (crc != tmp_crc) {
 		ubi_err("fastmap data CRC is invalid");
 		ret = UBI_BAD_FASTMAP;
-		kfree(ai->fm);
+		kfree(fm);
 		goto free_hdr;
 	}
 
@@ -955,12 +956,12 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	if (ret) {
 		if (ret > 0)
 			ret = UBI_BAD_FASTMAP;
-		kfree(ai->fm);
+		kfree(fm);
 		goto free_hdr;
 	}
 
-	ai->fm->size = fm_size;
-	ai->fm->used_blocks = used_blocks;
+	fm->size = fm_size;
+	fm->used_blocks = used_blocks;
 
 	for (i = 0; i < used_blocks; i++) {
 		struct ubi_wl_entry *e;
@@ -968,19 +969,21 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 		e = kmem_cache_alloc(ubi_wl_entry_slab, GFP_KERNEL);
 		if (!e) {
 			while (i--)
-				kfree(ai->fm->e[i]);
+				kfree(fm->e[i]);
 
-			kfree(ai->fm);
-			ai->fm = NULL;
+			kfree(fm);
+			fm = NULL;
 			ret = -ENOMEM;
 			goto free_hdr;
 		}
 
 		e->pnum = be32_to_cpu(fmsb->block_loc[i]);
 		e->ec = be32_to_cpu(fmsb->block_ec[i]);
-		ai->fm->e[i] = e;
+		fm->e[i] = e;
 	}
 
+	ubi->fm = fm;
+
 free_hdr:
 	ubi_free_vid_hdr(ubi, vh);
 	kfree(ech);
@@ -1294,7 +1297,8 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 			new_fm->e[0]->ec = old_fm->e[0]->ec;
 		} else {
 			/* we've got a new early PEB, return the old one */
-			ubi_wl_put_fm_peb(ubi, old_fm->e[0], 0);
+			ubi_wl_put_fm_peb(ubi, old_fm->e[0],
+					  old_fm->to_be_tortured[0]);
 
 			new_fm->e[0]->pnum = tmp_e->pnum;
 			new_fm->e[0]->ec = tmp_e->ec;
@@ -1302,7 +1306,8 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 
 		/* return all other fastmap block to the wl system */
 		for (i = 1; i < old_fm->used_blocks; i++)
-			ubi_wl_put_fm_peb(ubi, old_fm->e[i], 0);
+			ubi_wl_put_fm_peb(ubi, old_fm->e[i],
+					  old_fm->to_be_tortured[i]);
 	} else {
 		if (!tmp_e) {
 			ubi_err("could not find an early PEB");
@@ -1346,13 +1351,7 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 		new_fm->e[i]->ec = tmp_e->ec;
 	}
 
-	if (old_fm) {
-		for (i = 0; i < old_fm->used_blocks; i++)
-			kfree(old_fm->e[i]);
-
-		kfree(old_fm);
-	}
-
+	kfree(old_fm);
 	/* Ensure that the PEBs of the old fastmap got erased and added to the
 	 * free list before we write the fastmap. Otherwise fastmp does not
 	 * see these PEBs and we leak them.
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index f4bd3c9..dcbc420 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -625,7 +625,6 @@ struct ubi_ainf_volume {
  * @ec_sum: a temporary variable used when calculating @mean_ec
  * @ec_count: a temporary variable used when calculating @mean_ec
  * @aeb_slab_cache: slab cache for &struct ubi_ainf_peb objects
- * @fm: the fastmap used for attaching
  *
  * This data structure contains the result of attaching an MTD device and may
  * be used by other UBI sub-systems to build final UBI data structures, further
@@ -652,7 +651,6 @@ struct ubi_attach_info {
 	uint64_t ec_sum;
 	int ec_count;
 	struct kmem_cache *aeb_slab_cache;
-	struct ubi_fastmap_layout *fm;
 };
 
 #include "debug.h"
-- 
1.7.6.5

