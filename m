Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab2FUVu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:50:29 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47841 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760359Ab2FUVu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:50:26 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 07/15] UBI: Fastmap: Add a workqueue to allow delayed fastmap update
Date: Thu, 21 Jun 2012 23:50:00 +0200
Message-Id: <1340315408-27375-8-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340315408-27375-1-git-send-email-richard@nod.at>
References: <UBI fastmap updates>
 <1340315408-27375-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/ubi.h |    2 ++
 drivers/mtd/ubi/wl.c  |   16 ++++++++++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index a0c2103..7e0dfda 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -385,6 +385,7 @@ struct ubi_wl_entry;
  * @fm_pool_mutex: serializes ubi_wl_get_peb()
  * @fm_mutex: serializes ubi_update_fastmap()
  * @fm_sem: allows ubi_update_fastmap() to block EBA table changes
+ * @fm_work: fastmap work queue
  * @attached_by_scanning: this UBI device was attached by the old scanning
  *			  methold. All fastmap volumes have to be deleted.
  *
@@ -486,6 +487,7 @@ struct ubi_device {
 	struct rw_semaphore fm_sem;
 	struct mutex fm_mutex;
 	struct mutex fm_pool_mutex;
+	struct work_struct fm_work;
 	int attached_by_scanning;
 
 	/* Wear-leveling sub-system's stuff */
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 7520319..6f346f5 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -140,6 +140,17 @@ static int self_check_in_wl_tree(const struct ubi_device *ubi,
 				 struct ubi_wl_entry *e, struct rb_root *root);
 static int self_check_in_pq(const struct ubi_device *ubi,
 			    struct ubi_wl_entry *e);
+
+/**
+ * update_fastmap_work_fn - calls ubi_update_fastmap from a work queue
+ * @wrk: the work description object
+ */
+static void update_fastmap_work_fn(struct work_struct *wrk)
+{
+	struct ubi_device *ubi = container_of(wrk, struct ubi_device, fm_work);
+	ubi_update_fastmap(ubi);
+}
+
 /**
  *  ubi_ubi_is_fm_block - returns 1 if a PEB is currently used in a fastmap.
  *  @ubi: UBI device description object
@@ -604,6 +615,10 @@ static struct ubi_wl_entry *get_peb_for_wl(struct ubi_device *ubi)
 	int pnum;
 
 	if (pool->used == pool->size || !pool->size) {
+		/* We cannot update the fastmap here because this
+		 * function is called in atomic context.
+		 * Let's fail an refill/update it as soon as possible. */
+		schedule_work(&ubi->fm_work);
 		return NULL;
 	} else {
 		pnum = pool->pebs[pool->used++];
@@ -1671,6 +1686,7 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	init_rwsem(&ubi->work_sem);
 	ubi->max_ec = ai->max_ec;
 	INIT_LIST_HEAD(&ubi->works);
+	INIT_WORK(&ubi->fm_work, update_fastmap_work_fn);
 
 	sprintf(ubi->bgt_name, UBI_BGT_NAME_PATTERN, ubi->ubi_num);
 
-- 
1.7.6.5

