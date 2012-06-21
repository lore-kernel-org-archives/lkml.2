Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760521Ab2FUVu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:50:27 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47840 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760479Ab2FUVuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:50:25 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 06/15] UBI: Fastmap: Call ensure_wear_leveling() again in erase_worker()
Date: Thu, 21 Jun 2012 23:49:59 +0200
Message-Id: <1340315408-27375-7-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340315408-27375-1-git-send-email-richard@nod.at>
References: <UBI fastmap updates>
 <1340315408-27375-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This call to ensure_wear_leveling() has been removed because of a restriction
in fastmap.
It's no loner valid, now we can call it again.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/wl.c |   35 +++++++++++++++++++++++++++--------
 1 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index e014f7e..7520319 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -741,16 +741,15 @@ repeat:
 }
 
 /**
- * schedule_ubi_work - schedule a work.
+ * __schedule_ubi_work - schedule a work.
  * @ubi: UBI device description object
  * @wrk: the work to schedule
  *
  * This function adds a work defined by @wrk to the tail of the pending works
- * list.
+ * list. Can only be used of ubi->work_sem is already held in read mode!
  */
-static void schedule_ubi_work(struct ubi_device *ubi, struct ubi_work *wrk)
+static void __schedule_ubi_work(struct ubi_device *ubi, struct ubi_work *wrk)
 {
-	down_read(&ubi->work_sem);
 	spin_lock(&ubi->wl_lock);
 	list_add_tail(&wrk->list, &ubi->works);
 	ubi_assert(ubi->works_count >= 0);
@@ -758,6 +757,20 @@ static void schedule_ubi_work(struct ubi_device *ubi, struct ubi_work *wrk)
 	if (ubi->thread_enabled && !ubi_dbg_is_bgt_disabled(ubi))
 		wake_up_process(ubi->bgt_thread);
 	spin_unlock(&ubi->wl_lock);
+}
+
+/**
+ * schedule_ubi_work - schedule a work.
+ * @ubi: UBI device description object
+ * @wrk: the work to schedule
+ *
+ * This function adds a work defined by @wrk to the tail of the pending works
+ * list.
+ */
+static void schedule_ubi_work(struct ubi_device *ubi, struct ubi_work *wrk)
+{
+	down_read(&ubi->work_sem);
+	__schedule_ubi_work(ubi, wrk);
 	up_read(&ubi->work_sem);
 }
 
@@ -1157,7 +1170,7 @@ out_cancel:
  * if yes. This function returns zero in case of success and a negative error
  * code in case of failure.
  */
-static int ensure_wear_leveling(struct ubi_device *ubi)
+static int ensure_wear_leveling(struct ubi_device *ubi, int nested)
 {
 	int err = 0;
 	struct ubi_wl_entry *e1;
@@ -1203,7 +1216,10 @@ static int ensure_wear_leveling(struct ubi_device *ubi)
 	}
 
 	wrk->func = &wear_leveling_worker;
-	schedule_ubi_work(ubi, wrk);
+	if (nested)
+		__schedule_ubi_work(ubi, wrk);
+	else
+		schedule_ubi_work(ubi, wrk);
 	return err;
 
 out_cancel:
@@ -1256,6 +1272,9 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 		 * protected physical eraseblocks.
 		 */
 		serve_prot_queue(ubi);
+
+		/* And take care about wear-leveling */
+		ensure_wear_leveling(ubi, 1);
 		return err;
 	}
 
@@ -1479,7 +1498,7 @@ retry:
 	 * Technically scrubbing is the same as wear-leveling, so it is done
 	 * by the WL worker.
 	 */
-	return ensure_wear_leveling(ubi);
+	return ensure_wear_leveling(ubi, 0);
 }
 
 /**
@@ -1748,7 +1767,7 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	ubi->rsvd_pebs += WL_RESERVED_PEBS;
 
 	/* Schedule wear-leveling if needed */
-	err = ensure_wear_leveling(ubi);
+	err = ensure_wear_leveling(ubi, 0);
 	if (err)
 		goto out_free;
 
-- 
1.7.6.5

