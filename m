Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab2FRQTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:19:25 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab2FRQTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:19:23 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 01/22] UBI: Fastmap: Add EBA selfcheck
Date: Mon, 18 Jun 2012 18:18:44 +0200
Message-Id: <1340036345-96726-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340036345-96726-1-git-send-email-richard@nod.at>
References: <1340036345-96726-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using this self-check it's possible to proof Fastmap's
correctness.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/attach.c |   16 +++++++++
 drivers/mtd/ubi/eba.c    |   84 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/ubi/ubi.h    |    2 +
 3 files changed, 102 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index 4c6b97b..1573d94 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -1262,6 +1262,22 @@ int ubi_attach(struct ubi_device *ubi)
 	if (err)
 		goto out_wl;
 
+	if (ai->fm) {
+		struct ubi_attach_info *scan_ai;
+		scan_ai = kzalloc(sizeof(struct ubi_attach_info), GFP_KERNEL);
+		if (!scan_ai)
+			goto out_ai;
+
+		err = scan_all(ubi, scan_ai);
+		if (err) {
+			kfree(scan_ai);
+			goto out_ai;
+		}
+
+		self_check_eba(ubi, ai, scan_ai);
+		ubi_destroy_ai(ubi, scan_ai);
+	}
+
 	ubi_destroy_ai(ubi, ai);
 
 	/* TODO: UBI auto formats the flash if it is empty (see ubi->is_empty).
diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index 654f121..d112b10 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -1204,6 +1204,90 @@ static void print_rsvd_warning(struct ubi_device *ubi,
 			ubi->corr_peb_count);
 }
 
+int self_check_eba(struct ubi_device *ubi, struct ubi_attach_info *ai_fastmap,
+		   struct ubi_attach_info *ai_scan)
+{
+	int i, j, num_volumes, ret = 0;
+	int **scan_eba, **fm_eba;
+	struct ubi_ainf_volume *av;
+	struct ubi_volume *vol;
+	struct ubi_ainf_peb *aeb;
+	struct rb_node *rb;
+
+	num_volumes = ubi->vtbl_slots + UBI_INT_VOL_COUNT;
+
+	scan_eba = kmalloc(sizeof(*scan_eba) * num_volumes, GFP_KERNEL);
+	if (!scan_eba)
+		return -ENOMEM;
+
+	fm_eba = kmalloc(sizeof(*fm_eba) * num_volumes, GFP_KERNEL);
+	if (!fm_eba) {
+		kfree(scan_eba);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < num_volumes; i++) {
+		vol = ubi->volumes[i];
+		if (!vol)
+			continue;
+
+		scan_eba[i] = kmalloc(vol->reserved_pebs * sizeof(**scan_eba),
+				      GFP_KERNEL);
+		if (!scan_eba[i]) {
+			ret = -ENOMEM;
+			goto out_free;
+		}
+
+		fm_eba[i] = kmalloc(vol->reserved_pebs * sizeof(**fm_eba),
+				    GFP_KERNEL);
+		if (!scan_eba[i]) {
+			ret = -ENOMEM;
+			goto out_free;
+		}
+
+		for (j = 0; j < vol->reserved_pebs; j++)
+			scan_eba[i][j] = fm_eba[i][j] = UBI_LEB_UNMAPPED;
+
+		av = ubi_find_av(ai_scan, idx2vol_id(ubi, i));
+		if (!av)
+			continue;
+
+		ubi_rb_for_each_entry(rb, aeb, &av->root, u.rb)
+			scan_eba[i][aeb->lnum] = aeb->pnum;
+
+		av = ubi_find_av(ai_fastmap, idx2vol_id(ubi, i));
+		if (!av)
+			continue;
+
+		ubi_rb_for_each_entry(rb, aeb, &av->root, u.rb)
+			fm_eba[i][aeb->lnum] = aeb->pnum;
+
+		for (j = 0; j < vol->reserved_pebs; j++) {
+			if (scan_eba[i][j] != fm_eba[i][j]) {
+				if (scan_eba[i][j] == UBI_LEB_UNMAPPED)
+					continue;
+
+				ubi_err("LEB:%i is mapped to PEB:%i instead of PEB:%i!", i, fm_eba[i][j], scan_eba[i][j]);
+				BUG();
+			}
+		}
+	}
+
+out_free:
+	for (i = 0; i < num_volumes; i++) {
+		if (!ubi->volumes[i])
+			continue;
+
+		kfree(scan_eba[i]);
+		kfree(fm_eba[i]);
+	}
+
+	kfree(scan_eba);
+	kfree(fm_eba);
+
+	return ret;
+}
+
 /**
  * ubi_eba_init - initialize the EBA sub-system using attaching information.
  * @ubi: UBI device description object
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index ba6bfd1..f4bd3c9 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -723,6 +723,8 @@ int ubi_eba_copy_leb(struct ubi_device *ubi, int from, int to,
 		     struct ubi_vid_hdr *vid_hdr);
 int ubi_eba_init(struct ubi_device *ubi, struct ubi_attach_info *ai);
 unsigned long long ubi_next_sqnum(struct ubi_device *ubi);
+int self_check_eba(struct ubi_device *ubi, struct ubi_attach_info *ai_fastmap,
+		   struct ubi_attach_info *ai_scan);
 
 /* wl.c */
 int ubi_wl_get_peb(struct ubi_device *ubi);
-- 
1.7.6.5

