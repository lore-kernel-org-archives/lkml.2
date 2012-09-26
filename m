Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221Ab2IZPxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 11:53:37 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47838 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756856Ab2IZPwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 11:52:11 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Heinz.Egger@linutronix.de, artem.bityutskiy@linux.intel.com,
        tim.bird@am.sony.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 04/10] UBI: Add self_check_eba()
Date: Wed, 26 Sep 2012 17:51:44 +0200
Message-Id: <1348674710-102885-5-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1348674710-102885-1-git-send-email-richard@nod.at>
References: <1348674710-102885-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

self_check_eba() compares two ubi_attach_info objects.
Fastmap uses this function for self checks.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/eba.c |   96 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 96 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index 0910c2c..d56ae1c 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -1202,6 +1202,102 @@ static void print_rsvd_warning(struct ubi_device *ubi,
 }
 
 /**
+ * self_check_eba - run a self check on the EBA table constructed by fastmap.
+ * @ubi: UBI device description object
+ * @ai_fastmap: UBI attach info object created by fastmap
+ * @ai_scan: UBI attach info object created by scanning
+ *
+ * Returns < 0 in case of an internal error, 0 otherwise.
+ * If a bad EBA table entry was found it will be printed out and
+ * ubi_assert() triggers.
+ */
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
+		if (!fm_eba[i]) {
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
+				if (scan_eba[i][j] == UBI_LEB_UNMAPPED ||
+					fm_eba[i][j] == UBI_LEB_UNMAPPED)
+					continue;
+
+				ubi_err("LEB:%i:%i is PEB:%i instead of %i!",
+					vol->vol_id, i, fm_eba[i][j],
+					scan_eba[i][j]);
+				ubi_assert(0);
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
+	return ret;
+}
+
+/**
  * ubi_eba_init - initialize the EBA sub-system using attaching information.
  * @ubi: UBI device description object
  * @ai: attaching information
-- 
1.7.6.5

