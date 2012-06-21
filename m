Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760567Ab2FUVyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:54:10 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47837 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760381Ab2FUVuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:50:23 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 03/15] UBI: Fastmap: Modify ubi_attach() to force scanning if requested
Date: Thu, 21 Jun 2012 23:49:56 +0200
Message-Id: <1340315408-27375-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340315408-27375-1-git-send-email-richard@nod.at>
References: <UBI fastmap updates>
 <1340315408-27375-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/attach.c |   18 +++++++++++-------
 drivers/mtd/ubi/build.c  |    2 +-
 drivers/mtd/ubi/ubi.h    |    2 +-
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index 5cba456..7f65166 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -1207,25 +1207,29 @@ out_ai:
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
-	int err;
+	int err, i;
 	struct ubi_attach_info *ai;
 
 	ai = kzalloc(sizeof(struct ubi_attach_info), GFP_KERNEL);
 	if (!ai)
 		return -ENOMEM;
 
-	err = ubi_scan_fastmap(ubi, ai);
-	if (err > 0) {
+	if (force_scan)
 		err = scan_all(ubi, ai);
-		if (err)
-			return err;
-	} else if (err < 0)
+	else {
+		err = ubi_scan_fastmap(ubi, ai);
+		if (err > 0)
+			err = scan_all(ubi, ai);
+	}
+
+	if (err)
 		return err;
 
 	/* TODO: currently the fastmap code assumes that the fastmap data
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 1ad128d..186bc19 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -928,7 +928,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num, int vid_hdr_offset)
 	if (err)
 		goto out_free;
 
-	err = ubi_attach(ubi);
+	err = ubi_attach(ubi, 0);
 	if (err) {
 		ubi_err("failed to attach mtd%d, error %d", mtd->index, err);
 		goto out_debugging;
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 8abbcd5..a568a3b 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -693,7 +693,7 @@ struct ubi_ainf_volume *ubi_find_av(const struct ubi_attach_info *ai,
 void ubi_remove_av(struct ubi_attach_info *ai, struct ubi_ainf_volume *av);
 struct ubi_ainf_peb *ubi_early_get_peb(struct ubi_device *ubi,
 				       struct ubi_attach_info *ai);
-int ubi_attach(struct ubi_device *ubi);
+int ubi_attach(struct ubi_device *ubi, int force_scan);
 void ubi_destroy_ai(struct ubi_device *ubi, struct ubi_attach_info *ai);
 
 /* vtbl.c */
-- 
1.7.6.5

