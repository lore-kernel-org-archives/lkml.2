Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab2FUVue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:50:34 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47846 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760526Ab2FUVub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:50:31 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 12/15] UBI: Fastmap: Fix ai handling
Date: Thu, 21 Jun 2012 23:50:05 +0200
Message-Id: <1340315408-27375-13-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340315408-27375-1-git-send-email-richard@nod.at>
References: <UBI fastmap updates>
 <1340315408-27375-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If attaching by fastmap fails, we have to free ai and
create a new one.
Fixes also destroy_ai to be able to destroy an unsued ai.
It's also no longer needed to export it.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/attach.c |   52 +++++++++++++++++++++++++++++++--------------
 drivers/mtd/ubi/ubi.h    |    1 -
 2 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index 7cf4711..b6f8e95 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -90,6 +90,8 @@
 #include "ubi.h"
 
 static int self_check_ai(struct ubi_device *ubi, struct ubi_attach_info *ai);
+static void destroy_ai(struct ubi_device *ubi, struct ubi_attach_info *ai);
+static struct ubi_attach_info *new_ai(void);
 
 /* Temporary variables used during scanning */
 static struct ubi_ec_hdr *ech;
@@ -1123,12 +1125,6 @@ static int scan_all(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	struct ubi_ainf_volume *av;
 	struct ubi_ainf_peb *aeb;
 
-	INIT_LIST_HEAD(&ai->corr);
-	INIT_LIST_HEAD(&ai->free);
-	INIT_LIST_HEAD(&ai->erase);
-	INIT_LIST_HEAD(&ai->alien);
-	ai->volumes = RB_ROOT;
-
 	err = -ENOMEM;
 	ai->aeb_slab_cache = kmem_cache_create("ubi_aeb_slab_cache",
 					       sizeof(struct ubi_ainf_peb),
@@ -1200,7 +1196,7 @@ out_vidh:
 out_ech:
 	kfree(ech);
 out_ai:
-	ubi_destroy_ai(ubi, ai);
+	destroy_ai(ubi, ai);
 	return err;
 }
 
@@ -1217,7 +1213,7 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 	int err;
 	struct ubi_attach_info *ai;
 
-	ai = kzalloc(sizeof(struct ubi_attach_info), GFP_KERNEL);
+	ai = new_ai();
 	if (!ai)
 		return -ENOMEM;
 
@@ -1225,12 +1221,18 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 		err = scan_all(ubi, ai);
 	else {
 		err = ubi_scan_fastmap(ubi, ai);
-		if (err > 0)
+		if (err > 0) {
+			destroy_ai(ubi, ai);
+			ai = new_ai();
+			if (!ai)
+				return -ENOMEM;
+
 			err = scan_all(ubi, ai);
+		}
 	}
 
 	if (err)
-		return err;
+		goto out_ai;
 
 	/* TODO: currently the fastmap code assumes that the fastmap data
 	 * structures are created only by the kernel when the kernel attaches
@@ -1268,7 +1270,7 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 
 	if (ubi->fm && ubi->dbg->chk_gen) {
 		struct ubi_attach_info *scan_ai;
-		scan_ai = kzalloc(sizeof(struct ubi_attach_info), GFP_KERNEL);
+		scan_ai = new_ai();
 		if (!scan_ai)
 			goto out_ai;
 
@@ -1279,10 +1281,10 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 		}
 
 		self_check_eba(ubi, ai, scan_ai);
-		ubi_destroy_ai(ubi, scan_ai);
+		destroy_ai(ubi, scan_ai);
 	}
 
-	ubi_destroy_ai(ubi, ai);
+	destroy_ai(ubi, ai);
 
 	/* TODO: UBI auto formats the flash if it is empty (see ubi->is_empty).
 	 * It is currently done so that every sub-system writes initializes its
@@ -1299,7 +1301,7 @@ out_vtbl:
 	ubi_free_internal_volumes(ubi);
 	vfree(ubi->vtbl);
 out_ai:
-	ubi_destroy_ai(ubi, ai);
+	destroy_ai(ubi, ai);
 	return err;
 }
 
@@ -1337,11 +1339,11 @@ static void destroy_av(struct ubi_attach_info *ai, struct ubi_ainf_volume *av)
 }
 
 /**
- * ubi_destroy_ai - destroy attaching information.
+ * destroy_ai - destroy attaching information.
  * @ubi: UBI device object
  * @ai: attaching information
  */
-void ubi_destroy_ai(struct ubi_device *ubi, struct ubi_attach_info *ai)
+static void destroy_ai(struct ubi_device *ubi, struct ubi_attach_info *ai)
 {
 	struct ubi_ainf_peb *aeb, *aeb_tmp;
 	struct ubi_ainf_volume *av;
@@ -1392,6 +1394,24 @@ void ubi_destroy_ai(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	kfree(ai);
 }
 
+static struct ubi_attach_info *new_ai(void)
+{
+	static struct ubi_attach_info *ai;
+
+	ai = kzalloc(sizeof(struct ubi_attach_info), GFP_KERNEL);
+	if (!ai)
+		goto out;
+
+	INIT_LIST_HEAD(&ai->corr);
+	INIT_LIST_HEAD(&ai->free);
+	INIT_LIST_HEAD(&ai->erase);
+	INIT_LIST_HEAD(&ai->alien);
+	ai->volumes = RB_ROOT;
+
+out:
+	return ai;
+}
+
 /**
  * self_check_ai - check the attaching information.
  * @ubi: UBI device description object
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 7e0dfda..534e851 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -696,7 +696,6 @@ void ubi_remove_av(struct ubi_attach_info *ai, struct ubi_ainf_volume *av);
 struct ubi_ainf_peb *ubi_early_get_peb(struct ubi_device *ubi,
 				       struct ubi_attach_info *ai);
 int ubi_attach(struct ubi_device *ubi, int force_scan);
-void ubi_destroy_ai(struct ubi_device *ubi, struct ubi_attach_info *ai);
 
 /* vtbl.c */
 int ubi_change_vtbl_record(struct ubi_device *ubi, int idx,
-- 
1.7.6.5

