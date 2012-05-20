Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab2ETLKX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 07:10:23 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:56499
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753356Ab2ETLKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 07:10:21 -0400
Date: Sun, 20 May 2012 13:10:18 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] UBI: modify ubi_wl_flush function to clear work queue
 for a lnum
In-Reply-To: <alpine.DEB.2.00.1205150943470.17750@eristoteles.iwoars.net>
Message-ID: <alpine.DEB.2.00.1205201309390.26953@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205150943470.17750@eristoteles.iwoars.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch modifies ubi_wl_flush to force the erasure of
particular volume id / logical eraseblock number pairs. Previous functionality
is preserved when passing -1 for both values. The locations where ubi_wl_flush
were called are appropriately changed: ubi_leb_erase only flushes for the
erased LEB, and ubi_create_volume forces only flushing for its volume id.
External code can call this new feature via the new function ubi_flush() added
to kapi.c, which simply passes through to ubi_wl_flush().

This was tested by disabling the call to do_work in ubi thread, which results
in the work queue remaining unless explicitly called to remove. UBIFS was
changed to call ubifs_leb_change 50 times for three different LEBs. Then the
new function was called to clear the queue for the three differnt LEB numbers
one at a time. The work queue was dumped each time and the selective removal
of the particular LEB numbers was observed. Extra checks were enabled and
ubifs's integck was also run.

Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
---
 drivers/mtd/ubi/cdev.c  |    2 +-
 drivers/mtd/ubi/kapi.c  |   29 +++++++++++++++++++++-
 drivers/mtd/ubi/ubi.h   |    2 +-
 drivers/mtd/ubi/upd.c   |    4 +-
 drivers/mtd/ubi/vmt.c   |    2 +-
 drivers/mtd/ubi/wl.c    |   61 +++++++++++++++++++++++++++-------------------
 include/linux/mtd/ubi.h |    1 +
 7 files changed, 70 insertions(+), 31 deletions(-)

diff --git a/drivers/mtd/ubi/cdev.c b/drivers/mtd/ubi/cdev.c
index f406112..b60e6f4 100644
--- a/drivers/mtd/ubi/cdev.c
+++ b/drivers/mtd/ubi/cdev.c
@@ -514,7 +514,7 @@ static long vol_cdev_ioctl(struct file *file, unsigned int cmd,
 		if (err)
 			break;

-		err = ubi_wl_flush(ubi);
+		err = ubi_wl_flush(ubi, -1, -1);
 		break;
 	}

diff --git a/drivers/mtd/ubi/kapi.c b/drivers/mtd/ubi/kapi.c
index 33ede23..1666541 100644
--- a/drivers/mtd/ubi/kapi.c
+++ b/drivers/mtd/ubi/kapi.c
@@ -551,7 +551,7 @@ int ubi_leb_erase(struct ubi_volume_desc *desc, int lnum)
 	if (err)
 		return err;

-	return ubi_wl_flush(ubi);
+	return ubi_wl_flush(ubi, vol->vol_id, lnum);
 }
 EXPORT_SYMBOL_GPL(ubi_leb_erase);

@@ -704,6 +704,33 @@ int ubi_sync(int ubi_num)
 }
 EXPORT_SYMBOL_GPL(ubi_sync);

+/**
+ * ubi_flush - flush UBI work queue
+ * @ubi_num: UBI device to flush work queue
+ * @vol_id: volume id to flush for
+ * @lnum: logical eraseblock number to flush for
+ *
+ * This function executes all pending works for a particular volume id /
+ * logical eraseblock number pair. If either value is set to -1, then it acts
+ * as a wildcard for all of the corresponding volume numbers or logical
+ * eraseblock numbers. It returns zero in case of success and a negative error
+ * code in case of failure.
+ */
+int ubi_flush(int ubi_num, int vol_id, int lnum)
+{
+	struct ubi_device *ubi;
+	int err = 0;
+
+	ubi = ubi_get_device(ubi_num);
+	if (!ubi)
+		return -ENODEV;
+
+	err = ubi_wl_flush(ubi, vol_id, lnum);
+	ubi_put_device(ubi);
+	return err;
+}
+EXPORT_SYMBOL_GPL(ubi_flush);
+
 BLOCKING_NOTIFIER_HEAD(ubi_notifiers);

 /**
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 05aa452..0664ddc 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -535,7 +535,7 @@ int ubi_eba_init_scan(struct ubi_device *ubi, struct ubi_scan_info *si);
 int ubi_wl_get_peb(struct ubi_device *ubi);
 int ubi_wl_put_peb(struct ubi_device *ubi, int vol_id, int lnum,
 		   int pnum, int torture);
-int ubi_wl_flush(struct ubi_device *ubi);
+int ubi_wl_flush(struct ubi_device *ubi, int vol_id, int lnum);
 int ubi_wl_scrub_peb(struct ubi_device *ubi, int pnum);
 int ubi_wl_init_scan(struct ubi_device *ubi, struct ubi_scan_info *si);
 void ubi_wl_close(struct ubi_device *ubi);
diff --git a/drivers/mtd/ubi/upd.c b/drivers/mtd/ubi/upd.c
index 11a28f9..8025124 100644
--- a/drivers/mtd/ubi/upd.c
+++ b/drivers/mtd/ubi/upd.c
@@ -147,7 +147,7 @@ int ubi_start_update(struct ubi_device *ubi, struct ubi_volume *vol,
 	}

 	if (bytes == 0) {
-		err = ubi_wl_flush(ubi);
+		err = ubi_wl_flush(ubi, -1, -1);
 		if (err)
 			return err;

@@ -361,7 +361,7 @@ int ubi_more_update_data(struct ubi_device *ubi, struct ubi_volume *vol,

 	ubi_assert(vol->upd_received <= vol->upd_bytes);
 	if (vol->upd_received == vol->upd_bytes) {
-		err = ubi_wl_flush(ubi);
+		err = ubi_wl_flush(ubi, -1, -1);
 		if (err)
 			return err;
 		/* The update is finished, clear the update marker */
diff --git a/drivers/mtd/ubi/vmt.c b/drivers/mtd/ubi/vmt.c
index 863835f..01cf61a 100644
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -284,7 +284,7 @@ int ubi_create_volume(struct ubi_device *ubi, struct ubi_mkvol_req *req)
 	 * Finish all pending erases because there may be some LEBs belonging
 	 * to the same volume ID.
 	 */
-	err = ubi_wl_flush(ubi);
+	err = ubi_wl_flush(ubi, vol_id, -1);
 	if (err)
 		goto out_acc;

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 3df1d48..83d09a6 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -1248,44 +1248,55 @@ retry:
 /**
  * ubi_wl_flush - flush all pending works.
  * @ubi: UBI device description object
+ * @vol_id: the volume id to flush for
+ * @lnum: the logical eraseblock number to flush for
  *
- * This function returns zero in case of success and a negative error code in
- * case of failure.
+ * This function executes all pending works for a particular volume id /
+ * logical eraseblock number pair. If either value is set to -1, then it acts
+ * as a wildcard for all of the corresponding volume numbers or logical
+ * eraseblock numbers. It returns zero in case of success and a negative error
+ * code in case of failure.
  */
-int ubi_wl_flush(struct ubi_device *ubi)
+int ubi_wl_flush(struct ubi_device *ubi, int vol_id, int lnum)
 {
-	int err;
+	int err = 0;
+	int found = 1;

 	/*
 	 * Erase while the pending works queue is not empty, but not more than
 	 * the number of currently pending works.
 	 */
-	dbg_wl("flush (%d pending works)", ubi->works_count);
-	while (ubi->works_count) {
-		err = do_work(ubi);
-		if (err)
-			return err;
-	}
+	dbg_wl("flush pending work for LEB %d:%d (%d pending works)",
+	       vol_id, lnum, ubi->works_count);

-	/*
-	 * Make sure all the works which have been done in parallel are
-	 * finished.
-	 */
 	down_write(&ubi->work_sem);
-	up_write(&ubi->work_sem);
+	while (found) {
+		struct ubi_work *wrk;
+		found = 0;

-	/*
-	 * And in case last was the WL worker and it canceled the LEB
-	 * movement, flush again.
-	 */
-	while (ubi->works_count) {
-		dbg_wl("flush more (%d pending works)", ubi->works_count);
-		err = do_work(ubi);
-		if (err)
-			return err;
+		spin_lock(&ubi->wl_lock);
+		list_for_each_entry(wrk, &ubi->works, list) {
+			if ((vol_id == -1 || wrk->vol_id == vol_id) &&
+			    (lnum == -1 || wrk->lnum == lnum)) {
+				list_del(&wrk->list);
+				ubi->works_count -= 1;
+				ubi_assert(ubi->works_count >= 0);
+				spin_unlock(&ubi->wl_lock);
+
+				err = wrk->func(ubi, wrk, 0);
+				if (err)
+					goto out;
+				spin_lock(&ubi->wl_lock);
+				found = 1;
+				break;
+			}
+		}
+		spin_unlock(&ubi->wl_lock);
 	}

-	return 0;
+out:
+	up_write(&ubi->work_sem);
+	return err;
 }

 /**
diff --git a/include/linux/mtd/ubi.h b/include/linux/mtd/ubi.h
index 9838dce..e9f8088 100644
--- a/include/linux/mtd/ubi.h
+++ b/include/linux/mtd/ubi.h
@@ -216,6 +216,7 @@ int ubi_leb_unmap(struct ubi_volume_desc *desc, int lnum);
 int ubi_leb_map(struct ubi_volume_desc *desc, int lnum);
 int ubi_is_mapped(struct ubi_volume_desc *desc, int lnum);
 int ubi_sync(int ubi_num);
+int ubi_flush(int ubi_num, int vol_id, int lnum);

 /*
  * This function is the same as the 'ubi_leb_read()' function, but it does not
-- 
1.7.5.4


