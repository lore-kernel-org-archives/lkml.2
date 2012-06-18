Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab2FRQWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:22:44 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47843 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269Ab2FRQTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:19:37 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 12/22] UBI: Fastmap: Locking fixes
Date: Mon, 18 Jun 2012 18:18:55 +0200
Message-Id: <1340036345-96726-13-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340036345-96726-1-git-send-email-richard@nod.at>
References: <1340036345-96726-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new rw semaphore to block EBA table changes
while creating the fastmap.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/eba.c     |   12 ++++++++++++
 drivers/mtd/ubi/fastmap.c |    2 ++
 drivers/mtd/ubi/ubi.h     |    2 ++
 3 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index d112b10..2bee8be 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -340,7 +340,9 @@ int ubi_eba_unmap_leb(struct ubi_device *ubi, struct ubi_volume *vol,
 
 	dbg_eba("erase LEB %d:%d, PEB %d", vol_id, lnum, pnum);
 
+	down_read(&ubi->fm_sem);
 	vol->eba_tbl[lnum] = UBI_LEB_UNMAPPED;
+	up_read(&ubi->fm_sem);
 	err = ubi_wl_put_peb(ubi, pnum, 0);
 
 out_unlock:
@@ -549,7 +551,9 @@ retry:
 	mutex_unlock(&ubi->buf_mutex);
 	ubi_free_vid_hdr(ubi, vid_hdr);
 
+	down_read(&ubi->fm_sem);
 	vol->eba_tbl[lnum] = new_pnum;
+	up_read(&ubi->fm_sem);
 	ubi_wl_put_peb(ubi, pnum, 1);
 
 	ubi_msg("data was successfully recovered");
@@ -667,7 +671,9 @@ retry:
 		}
 	}
 
+	down_read(&ubi->fm_sem);
 	vol->eba_tbl[lnum] = pnum;
+	up_read(&ubi->fm_sem);
 
 	leb_write_unlock(ubi, vol_id, lnum);
 	ubi_free_vid_hdr(ubi, vid_hdr);
@@ -785,7 +791,9 @@ retry:
 	}
 
 	ubi_assert(vol->eba_tbl[lnum] < 0);
+	down_read(&ubi->fm_sem);
 	vol->eba_tbl[lnum] = pnum;
+	up_read(&ubi->fm_sem);
 
 	leb_write_unlock(ubi, vol_id, lnum);
 	ubi_free_vid_hdr(ubi, vid_hdr);
@@ -906,7 +914,9 @@ retry:
 			goto out_leb_unlock;
 	}
 
+	down_read(&ubi->fm_sem);
 	vol->eba_tbl[lnum] = pnum;
+	up_read(&ubi->fm_sem);
 
 out_leb_unlock:
 	leb_write_unlock(ubi, vol_id, lnum);
@@ -1154,7 +1164,9 @@ int ubi_eba_copy_leb(struct ubi_device *ubi, int from, int to,
 	}
 
 	ubi_assert(vol->eba_tbl[lnum] == from);
+	down_read(&ubi->fm_sem);
 	vol->eba_tbl[lnum] = to;
+	up_read(&ubi->fm_sem);
 
 out_unlock_buf:
 	mutex_unlock(&ubi->buf_mutex);
diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index ff09fd4..33a14cf 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1418,9 +1418,11 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 
 	kfree(old_fm);
 
+	down_write(&ubi->fm_sem);
 	down_write(&ubi->work_sem);
 	ret = ubi_write_fastmap(ubi, new_fm);
 	up_write(&ubi->work_sem);
+	up_write(&ubi->fm_sem);
 out_unlock:
 	mutex_unlock(&ubi->fm_mutex);
 
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 8588f9c..8abbcd5 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -384,6 +384,7 @@ struct ubi_wl_entry;
  * @fm_pool: in-memory data structure of the fastmap pool
  * @fm_pool_mutex: serializes ubi_wl_get_peb()
  * @fm_mutex: serializes ubi_update_fastmap()
+ * @fm_sem: allows ubi_update_fastmap() to block EBA table changes
  * @attached_by_scanning: this UBI device was attached by the old scanning
  *			  methold. All fastmap volumes have to be deleted.
  *
@@ -482,6 +483,7 @@ struct ubi_device {
 	struct ubi_fastmap_layout *fm;
 	struct ubi_fm_pool fm_pool;
 	struct ubi_fm_pool fm_wl_pool;
+	struct rw_semaphore fm_sem;
 	struct mutex fm_mutex;
 	struct mutex fm_pool_mutex;
 	int attached_by_scanning;
-- 
1.7.6.5

