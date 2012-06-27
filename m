Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab2F0P6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:58:23 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47843 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab2F0P6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:58:17 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 09/16] UBI: Fastmap: Be more verbose on fastmap failure
Date: Wed, 27 Jun 2012 17:57:49 +0200
Message-Id: <1340812676-14460-10-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340812676-14460-1-git-send-email-richard@nod.at>
References: <1340812676-14460-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c |   67 ++++++++++++++++++++++++++++++---------------
 1 files changed, 45 insertions(+), 22 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 4d8ef9e..07ac06e 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -299,7 +299,6 @@ static int process_pool_aeb(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		av = tmp_av;
 	else {
 		ubi_err("orphaned volume in fastmap pool!");
-
 		return UBI_BAD_FASTMAP;
 	}
 
@@ -378,21 +377,23 @@ static int scan_pool(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		pnum = be32_to_cpu(pebs[i]);
 
 		if (ubi_io_is_bad(ubi, pnum)) {
-			dbg_bld("bad PEB in fastmap pool!");
+			ubi_err("bad PEB in fastmap pool!");
 			ret = UBI_BAD_FASTMAP;
 			goto out;
 		}
 
 		err = ubi_io_read_ec_hdr(ubi, pnum, ech, 0);
 		if (err && err != UBI_IO_BITFLIPS) {
-			dbg_bld("unable to read EC header!");
+			ubi_err("unable to read EC header! PEB:%i err:%i",
+				pnum, err);
 			ret = err > 0 ? UBI_BAD_FASTMAP : err;
 			goto out;
 		} else if (ret == UBI_IO_BITFLIPS)
 			scrub = 1;
 
 		if (be32_to_cpu(ech->image_seq) != ubi->image_seq) {
-			dbg_bld("image seq mismatch!");
+			ubi_err("bad image seq: 0x%x, expected: 0x%x",
+				be32_to_cpu(ech->image_seq), ubi->image_seq);
 			err = UBI_BAD_FASTMAP;
 			goto out;
 		}
@@ -540,22 +541,31 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 	if (fm_pos >= fm_size)
 		goto fail_bad;
 
-	if (be32_to_cpu(fmhdr->magic) != UBI_FM_HDR_MAGIC)
+	if (be32_to_cpu(fmhdr->magic) != UBI_FM_HDR_MAGIC) {
+		ubi_err("bad fastmap header magic: 0x%x, expected: 0x%x",
+			be32_to_cpu(fmhdr->magic), UBI_FM_HDR_MAGIC);
 		goto fail_bad;
+	}
 
 	fmpl1 = (struct ubi_fm_scan_pool *)(fm_raw + fm_pos);
 	fm_pos += sizeof(*fmpl1);
 	if (fm_pos >= fm_size)
 		goto fail_bad;
-	if (be32_to_cpu(fmpl1->magic) != UBI_FM_POOL_MAGIC)
+	if (be32_to_cpu(fmpl1->magic) != UBI_FM_POOL_MAGIC) {
+		ubi_err("bad fastmap pool magic: 0x%x, expected: 0x%x",
+			be32_to_cpu(fmpl1->magic), UBI_FM_POOL_MAGIC);
 		goto fail_bad;
+	}
 
 	fmpl2 = (struct ubi_fm_scan_pool *)(fm_raw + fm_pos);
 	fm_pos += sizeof(*fmpl2);
 	if (fm_pos >= fm_size)
 		goto fail_bad;
-	if (be32_to_cpu(fmpl2->magic) != UBI_FM_POOL_MAGIC)
+	if (be32_to_cpu(fmpl2->magic) != UBI_FM_POOL_MAGIC) {
+		ubi_err("bad fastmap pool magic: 0x%x, expected: 0x%x",
+			be32_to_cpu(fmpl2->magic), UBI_FM_POOL_MAGIC);
 		goto fail_bad;
+	}
 
 	/* read EC values from free list */
 	for (i = 0; i < be32_to_cpu(fmhdr->free_peb_count); i++) {
@@ -611,8 +621,12 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 		if (fm_pos >= fm_size)
 			goto fail_bad;
 
-		if (be32_to_cpu(fmvhdr->magic) != UBI_FM_VHDR_MAGIC)
+		if (be32_to_cpu(fmvhdr->magic) != UBI_FM_VHDR_MAGIC) {
+			ubi_err("bad fastmap vol header magic: 0x%x, "
+				"expected: 0x%x",
+				be32_to_cpu(fmvhdr->magic), UBI_FM_VHDR_MAGIC);
 			goto fail_bad;
+		}
 
 		av = add_vol(ai, be32_to_cpu(fmvhdr->vol_id),
 			     be32_to_cpu(fmvhdr->used_ebs),
@@ -633,8 +647,12 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 		if (fm_pos >= fm_size)
 			goto fail_bad;
 
-		if (be32_to_cpu(fm_eba->magic) != UBI_FM_EBA_MAGIC)
+		if (be32_to_cpu(fm_eba->magic) != UBI_FM_EBA_MAGIC) {
+			ubi_err("bad fastmap EBA header magic: 0x%x, "
+				"expected: 0x%x",
+				be32_to_cpu(fm_eba->magic), UBI_FM_EBA_MAGIC);
 			goto fail_bad;
+		}
 
 		for (j = 0; j < be32_to_cpu(fm_eba->reserved_pebs); j++) {
 			int pnum = be32_to_cpu(fm_eba->pnum[j]);
@@ -694,6 +712,7 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 			int err;
 
 			if (ubi_io_is_bad(ubi, tmp_aeb->pnum)) {
+				ubi_err("bad PEB in fastmap EBA orphan list");
 				ret = UBI_BAD_FASTMAP;
 				kfree(ech);
 				goto fail;
@@ -701,7 +720,8 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 
 			err = ubi_io_read_ec_hdr(ubi, tmp_aeb->pnum, ech, 0);
 			if (err && err != UBI_IO_BITFLIPS) {
-				dbg_bld("unable to read EC header!");
+				ubi_err("unable to read EC header! PEB:%i "
+					"err:%i", tmp_aeb->pnum, err);
 				ret = err > 0 ? UBI_BAD_FASTMAP : err;
 				kfree(ech);
 
@@ -841,14 +861,8 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 		fm->to_be_tortured[0] = 1;
 
 	if (be32_to_cpu(fmsb->magic) != UBI_FM_SB_MAGIC) {
-		/* TODO: not urgent, but examine all the error messages and
-		 * print more information there. Here you should print what was
-		 * read and what was expected. See io.c and do similarly or
-		 * better.
-		 * Please, change globally. E.g., when you print about bad
-		 * version - print what was expected and what was actually
-		 * found. */
-		ubi_err("super block magic does not match");
+		ubi_err("bad super block magic: 0x%x, expected: 0x%x",
+			be32_to_cpu(fmsb->magic), UBI_FM_SB_MAGIC);
 		ret = UBI_BAD_FASTMAP;
 		kfree(fmsb);
 		kfree(fm);
@@ -856,7 +870,8 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	}
 
 	if (fmsb->version != UBI_FM_FMT_VERSION) {
-		ubi_err("unknown fastmap format version!");
+		ubi_err("bad fastmap version: %i, expected: %i",
+			fmsb->version, UBI_FM_FMT_VERSION);
 		ret = UBI_BAD_FASTMAP;
 		kfree(fmsb);
 		kfree(fm);
@@ -865,7 +880,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 
 	used_blocks = be32_to_cpu(fmsb->used_blocks);
 	if (used_blocks > UBI_FM_MAX_BLOCKS || used_blocks < 1) {
-		ubi_err("number of fastmap blocks is invalid");
+		ubi_err("number of fastmap blocks is invalid: %i", used_blocks);
 		ret = UBI_BAD_FASTMAP;
 		kfree(fmsb);
 		kfree(fm);
@@ -942,6 +957,10 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 
 		if (i == 0) {
 			if (be32_to_cpu(vh->vol_id) != UBI_FM_SB_VOLUME_ID) {
+				ubi_err("bad fastmap anchor vol_id: 0x%x,"
+					" expected: 0x%x",
+					be32_to_cpu(vh->vol_id),
+					UBI_FM_SB_VOLUME_ID);
 				ret = UBI_BAD_FASTMAP;
 				kfree(fmsb);
 				kfree(fm);
@@ -949,6 +968,10 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 			}
 		} else {
 			if (be32_to_cpu(vh->vol_id) != UBI_FM_DATA_VOLUME_ID) {
+				ubi_err("bad fastmap data vol_id: 0x%x,"
+					" expected: 0x%x",
+					be32_to_cpu(vh->vol_id),
+					UBI_FM_DATA_VOLUME_ID);
 				ret = UBI_BAD_FASTMAP;
 				kfree(fmsb);
 				goto free_hdr;
@@ -961,8 +984,8 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 		ret = ubi_io_read(ubi, fm_raw + (ubi->leb_size * i), pnum,
 				  ubi->leb_start, ubi->leb_size);
 		if (ret && ret != UBI_IO_BITFLIPS) {
-			ubi_err("unable to read fastmap block# %i (PEB: %i)",
-				i, pnum);
+			ubi_err("unable to read fastmap block# %i (PEB: %i, "
+				"err: %i)", i, pnum, ret);
 			kfree(fmsb);
 			kfree(fm);
 			goto free_hdr;
-- 
1.7.6.5

