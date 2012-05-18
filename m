Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968029Ab2ERNk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:40:29 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:57318
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S967241Ab2ERNk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:40:27 -0400
Date: Fri, 18 May 2012 15:40:24 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] UBI: add lnum and vol_id to struct ubi_work 
Message-ID: <alpine.DEB.2.00.1205181538150.13472@eristoteles.iwoars.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is part of a multipart patch to allow UBI to force the erasure of
particular logical eraseblock numbers. In this patch, the volume id and LEB
number are added to ubi_work data structure, and both are also passed as a
parameter to schedule erase to set it appropriately. Whenever ubi_wl_put_peb
is called, the lnum is also passed to be forwarded to schedule erase. Later,
a new ubi_sync_lnum will be added to execute immediately all work related to
that lnum.

This was tested by outputting the vol_id and lnum during the schedule of
erasure. The ubi thread was disabled and two ubifs drives on separate
partitions repeated changed a small number of LEBs. The ubi module was readded, and all
the erased LEBs, corresponding to the volumes, were added to the schedule
erase queue.

Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
---
 drivers/mtd/ubi/eba.c |   16 ++++++++--------
 drivers/mtd/ubi/ubi.h |    3 ++-
 drivers/mtd/ubi/wl.c  |   32 +++++++++++++++++++++++---------
 3 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index bd5fdbf..4421540 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -341,7 +341,7 @@ int ubi_eba_unmap_leb(struct ubi_device *ubi, struct ubi_volume *vol,
 	dbg_eba("erase LEB %d:%d, PEB %d", vol_id, lnum, pnum);

 	vol->eba_tbl[lnum] = UBI_LEB_UNMAPPED;
-	err = ubi_wl_put_peb(ubi, pnum, 0);
+	err = ubi_wl_put_peb(ubi, vol_id, lnum, pnum, 0);

 out_unlock:
 	leb_write_unlock(ubi, vol_id, lnum);
@@ -550,7 +550,7 @@ retry:
 	ubi_free_vid_hdr(ubi, vid_hdr);

 	vol->eba_tbl[lnum] = new_pnum;
-	ubi_wl_put_peb(ubi, pnum, 1);
+	ubi_wl_put_peb(ubi, vol_id, lnum, pnum, 1);

 	ubi_msg("data was successfully recovered");
 	return 0;
@@ -558,7 +558,7 @@ retry:
 out_unlock:
 	mutex_unlock(&ubi->buf_mutex);
 out_put:
-	ubi_wl_put_peb(ubi, new_pnum, 1);
+	ubi_wl_put_peb(ubi, vol_id, lnum, new_pnum, 1);
 	ubi_free_vid_hdr(ubi, vid_hdr);
 	return err;

@@ -568,7 +568,7 @@ write_error:
 	 * get another one.
 	 */
 	ubi_warn("failed to write to PEB %d", new_pnum);
-	ubi_wl_put_peb(ubi, new_pnum, 1);
+	ubi_wl_put_peb(ubi, vol_id, lnum, new_pnum, 1);
 	if (++tries > UBI_IO_RETRIES) {
 		ubi_free_vid_hdr(ubi, vid_hdr);
 		return err;
@@ -686,7 +686,7 @@ write_error:
 	 * eraseblock, so just put it and request a new one. We assume that if
 	 * this physical eraseblock went bad, the erase code will handle that.
 	 */
-	err = ubi_wl_put_peb(ubi, pnum, 1);
+	err = ubi_wl_put_peb(ubi, vol_id, lnum, pnum, 1);
 	if (err || ++tries > UBI_IO_RETRIES) {
 		ubi_ro_mode(ubi);
 		leb_write_unlock(ubi, vol_id, lnum);
@@ -804,7 +804,7 @@ write_error:
 		return err;
 	}

-	err = ubi_wl_put_peb(ubi, pnum, 1);
+	err = ubi_wl_put_peb(ubi, vol_id, lnum, pnum, 1);
 	if (err || ++tries > UBI_IO_RETRIES) {
 		ubi_ro_mode(ubi);
 		leb_write_unlock(ubi, vol_id, lnum);
@@ -901,7 +901,7 @@ retry:
 	}

 	if (vol->eba_tbl[lnum] >= 0) {
-		err = ubi_wl_put_peb(ubi, vol->eba_tbl[lnum], 0);
+		err = ubi_wl_put_peb(ubi, vol_id, lnum, vol->eba_tbl[lnum], 0);
 		if (err)
 			goto out_leb_unlock;
 	}
@@ -926,7 +926,7 @@ write_error:
 		goto out_leb_unlock;
 	}

-	err = ubi_wl_put_peb(ubi, pnum, 1);
+	err = ubi_wl_put_peb(ubi, vol_id, lnum, pnum, 1);
 	if (err || ++tries > UBI_IO_RETRIES) {
 		ubi_ro_mode(ubi);
 		goto out_leb_unlock;
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 75b9f1c..05aa452 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -533,7 +533,8 @@ int ubi_eba_init_scan(struct ubi_device *ubi, struct ubi_scan_info *si);

 /* wl.c */
 int ubi_wl_get_peb(struct ubi_device *ubi);
-int ubi_wl_put_peb(struct ubi_device *ubi, int pnum, int torture);
+int ubi_wl_put_peb(struct ubi_device *ubi, int vol_id, int lnum,
+		   int pnum, int torture);
 int ubi_wl_flush(struct ubi_device *ubi);
 int ubi_wl_scrub_peb(struct ubi_device *ubi, int pnum);
 int ubi_wl_init_scan(struct ubi_device *ubi, struct ubi_scan_info *si);
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 64ce993..39bdc3b 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -140,6 +140,8 @@
  * @list: a link in the list of pending works
  * @func: worker function
  * @e: physical eraseblock to erase
+ * @vol_id: the volume ID on which this erasure is being performed
+ * @lnum: the logical number of the erase block
  * @torture: if the physical eraseblock has to be tortured
  *
  * The @func pointer points to the worker function. If the @cancel argument is
@@ -152,6 +154,8 @@ struct ubi_work {
 	int (*func)(struct ubi_device *ubi, struct ubi_work *wrk, int cancel);
 	/* The below fields are only relevant to erasure works */
 	struct ubi_wl_entry *e;
+	int vol_id;
+	int lnum;
 	int torture;
 };

@@ -586,13 +590,15 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
  * schedule_erase - schedule an erase work.
  * @ubi: UBI device description object
  * @e: the WL entry of the physical eraseblock to erase
+ * @vol_id: the volume ID that last used the eraseblock
+ * @lnum: the last used logical block number for the eraseblock
  * @torture: if the physical eraseblock has to be tortured
  *
  * This function returns zero in case of success and a %-ENOMEM in case of
  * failure.
  */
 static int schedule_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
-			  int torture)
+			  int vol_id, int lnum, int torture)
 {
 	struct ubi_work *wl_wrk;

@@ -605,6 +611,8 @@ static int schedule_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,

 	wl_wrk->func = &erase_worker;
 	wl_wrk->e = e;
+	wl_wrk->vol_id = vol_id;
+	wl_wrk->lnum = lnum;
 	wl_wrk->torture = torture;

 	schedule_ubi_work(ubi, wl_wrk);
@@ -805,7 +813,7 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 	ubi->move_to_put = ubi->wl_scheduled = 0;
 	spin_unlock(&ubi->wl_lock);

-	err = schedule_erase(ubi, e1, 0);
+	err = schedule_erase(ubi, e1, vol_id, lnum, 0);
 	if (err) {
 		kmem_cache_free(ubi_wl_entry_slab, e1);
 		if (e2)
@@ -820,7 +828,7 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 		 */
 		dbg_wl("PEB %d (LEB %d:%d) was put meanwhile, erase",
 		       e2->pnum, vol_id, lnum);
-		err = schedule_erase(ubi, e2, 0);
+		err = schedule_erase(ubi, e2, vol_id, lnum, 0);
 		if (err) {
 			kmem_cache_free(ubi_wl_entry_slab, e2);
 			goto out_ro;
@@ -859,7 +867,7 @@ out_not_moved:
 	spin_unlock(&ubi->wl_lock);

 	ubi_free_vid_hdr(ubi, vid_hdr);
-	err = schedule_erase(ubi, e2, torture);
+	err = schedule_erase(ubi, e2, vol_id, lnum, torture);
 	if (err) {
 		kmem_cache_free(ubi_wl_entry_slab, e2);
 		goto out_ro;
@@ -978,6 +986,8 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 {
 	struct ubi_wl_entry *e = wl_wrk->e;
 	int pnum = e->pnum, err, need;
+	int vol_id = wl_wrk->vol_id;
+	int lnum = wl_wrk->lnum;

 	if (cancel) {
 		dbg_wl("cancel erasure of PEB %d EC %d", pnum, e->ec);
@@ -986,7 +996,8 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 		return 0;
 	}

-	dbg_wl("erase PEB %d EC %d", pnum, e->ec);
+	dbg_wl("erase PEB %d EC %d volume %d LEB %d",
+	       pnum, e->ec, wl_wrk->vol_id, wl_wrk->lnum);

 	err = sync_erase(ubi, e, wl_wrk->torture);
 	if (!err) {
@@ -1016,7 +1027,7 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 		int err1;

 		/* Re-schedule the LEB for erasure */
-		err1 = schedule_erase(ubi, e, 0);
+		err1 = schedule_erase(ubi, e, vol_id, lnum, 0);
 		if (err1) {
 			err = err1;
 			goto out_ro;
@@ -1084,6 +1095,8 @@ out_ro:
 /**
  * ubi_wl_put_peb - return a PEB to the wear-leveling sub-system.
  * @ubi: UBI device description object
+ * @vol_id: the volume ID that last used the eraseblock
+ * @lnum: the last used logical eraseblock number for the PEB
  * @pnum: physical eraseblock to return
  * @torture: if this physical eraseblock has to be tortured
  *
@@ -1092,7 +1105,8 @@ out_ro:
  * occurred to this @pnum and it has to be tested. This function returns zero
  * in case of success, and a negative error code in case of failure.
  */
-int ubi_wl_put_peb(struct ubi_device *ubi, int pnum, int torture)
+int ubi_wl_put_peb(struct ubi_device *ubi, int vol_id, int lnum,
+		   int pnum, int torture)
 {
 	int err;
 	struct ubi_wl_entry *e;
@@ -1158,7 +1172,7 @@ retry:
 	}
 	spin_unlock(&ubi->wl_lock);

-	err = schedule_erase(ubi, e, torture);
+	err = schedule_erase(ubi, e, vol_id, lnum, torture);
 	if (err) {
 		spin_lock(&ubi->wl_lock);
 		wl_tree_add(e, &ubi->used);
@@ -1423,7 +1437,7 @@ int ubi_wl_init_scan(struct ubi_device *ubi, struct ubi_scan_info *si)
 		e->pnum = seb->pnum;
 		e->ec = seb->ec;
 		ubi->lookuptbl[e->pnum] = e;
-		if (schedule_erase(ubi, e, 0)) {
+		if (schedule_erase(ubi, e, seb->vol_id, seb->lnum, 0)) {
 			kmem_cache_free(ubi_wl_entry_slab, e);
 			goto out_free;
 		}
-- 
1.7.5.4

