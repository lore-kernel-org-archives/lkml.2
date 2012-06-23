Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab2FWNES (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 09:04:18 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47841 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482Ab2FWNDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 09:03:43 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 7/7] UBI: Fastmap: Get rid of fm_pool_mutex
Date: Sat, 23 Jun 2012 15:03:22 +0200
Message-Id: <1340456602-46050-8-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340456602-46050-1-git-send-email-richard@nod.at>
References: <1340456602-46050-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This mutex is no longer needed.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/build.c |    1 -
 drivers/mtd/ubi/ubi.h   |    2 --
 drivers/mtd/ubi/wl.c    |    4 ----
 3 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 611d0c4..d00101e 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -906,7 +906,6 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num, int vid_hdr_offset)
 	mutex_init(&ubi->buf_mutex);
 	mutex_init(&ubi->ckvol_mutex);
 	mutex_init(&ubi->device_mutex);
-	mutex_init(&ubi->fm_pool_mutex);
 	mutex_init(&ubi->fm_mutex);
 	init_rwsem(&ubi->fm_sem);
 	spin_lock_init(&ubi->volumes_lock);
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index a2c1bcc..2ff1807 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -382,7 +382,6 @@ struct ubi_wl_entry;
  *
  * @fm: in-memory data structure of the currently used fastmap
  * @fm_pool: in-memory data structure of the fastmap pool
- * @fm_pool_mutex: serializes ubi_wl_get_peb()
  * @fm_mutex: serializes ubi_update_fastmap()
  * @fm_sem: allows ubi_update_fastmap() to block EBA table changes
  * @fm_work: fastmap work queue
@@ -486,7 +485,6 @@ struct ubi_device {
 	struct ubi_fm_pool fm_wl_pool;
 	struct rw_semaphore fm_sem;
 	struct mutex fm_mutex;
-	struct mutex fm_pool_mutex;
 	struct work_struct fm_work;
 	int attached_by_scanning;
 
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 4f8b06a..dc45bd3 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -609,8 +609,6 @@ int ubi_wl_get_peb(struct ubi_device *ubi)
 	struct ubi_fm_pool *pool = &ubi->fm_pool;
 	struct ubi_fm_pool *wl_pool = &ubi->fm_wl_pool;
 
-	mutex_lock(&ubi->fm_pool_mutex);
-
 	if (!pool->size || !wl_pool->size || pool->used == pool->size ||
 	    wl_pool->used == wl_pool->size)
 		ubi_update_fastmap(ubi);
@@ -625,8 +623,6 @@ int ubi_wl_get_peb(struct ubi_device *ubi)
 		spin_unlock(&ubi->wl_lock);
 	}
 
-	mutex_unlock(&ubi->fm_pool_mutex);
-
 	return ret;
 }
 
-- 
1.7.6.5

