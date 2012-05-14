Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab2ENSry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 14:47:54 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:36706
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S932073Ab2ENSrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 14:47:52 -0400
Date: Mon, 14 May 2012 20:47:51 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] UBI: add lnum to struct ubi_work
Message-ID: <alpine.DEB.2.00.1205142046080.12448@eristoteles.iwoars.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is part of a multipart patch to allow UBI to force the erasure of
particular logical eraseblock numbers. In this patch, the logical erase block
number is added to ubi_work data structure, and it is also passed as a
parameter to schedule erase to set it appropriately. Whenever ubi_wl_put_peb
is called, the lnum is also passed to be forwarded to schedule erase. Later,
a new ubi_sync_lnum will be added to execute immediately all work related to
that lnum.

This was tested by observing the recorded lnum value whenever an eraseblock
was erased (i.e., the work done). UBIFS was changed to repeat leb_change
calls 10 times, integck was executed, and the sequence of 10 equal lnums
with varying pnums was observed.

This is reposted after rebasing.

Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
---
 drivers/mtd/ubi/eba.c |   16 ++++++++--------
 drivers/mtd/ubi/ubi.h |    2 +-
 drivers/mtd/ubi/wl.c  |   23 ++++++++++++++---------
 3 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index bd5fdbf..5aa4fbc 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -341,7 +341,7 @@ int ubi_eba_unmap_leb(struct ubi_device *ubi, struct ubi_volume *vol,
 	dbg_eba("erase LEB %d:%d, PEB %d", vol_id, lnum, pnum);

 	vol->eba_tbl[lnum] = UBI_LEB_UNMAPPED;
-	err = ubi_wl_put_peb(ubi, pnum, 0);
+	err = ubi_wl_put_peb(ubi, pnum, 0, lnum);

 out_unlock:
 	leb_write_unlock(ubi, vol_id, lnum);
@@ -550,7 +550,7 @@ retry:
 	ubi_free_vid_hdr(ubi, vid_hdr);

 	vol->eba_tbl[lnum] = new_pnum;
-	ubi_wl_put_peb(ubi, pnum, 1);
+	ubi_wl_put_peb(ubi, pnum, 1, lnum);

 	ubi_msg("data was successfully recovered");
 	return 0;
@@ -558,7 +558,7 @@ retry:
 out_unlock:
 	mutex_unlock(&ubi->buf_mutex);
 out_put:
-	ubi_wl_put_peb(ubi, new_pnum, 1);
+	ubi_wl_put_peb(ubi, new_pnum, 1, lnum);
 	ubi_free_vid_hdr(ubi, vid_hdr);
 	return err;

@@ -568,7 +568,7 @@ write_error:
 	 * get another one.
 	 */
 	ubi_warn("failed to write to PEB %d", new_pnum);
-	ubi_wl_put_peb(ubi, new_pnum, 1);
+	ubi_wl_put_peb(ubi, new_pnum, 1, lnum);
 	if (++tries > UBI_IO_RETRIES) {
 		ubi_free_vid_hdr(ubi, vid_hdr);
 		return err;
@@ -686,7 +686,7 @@ write_error:
 	 * eraseblock, so just put it and request a new one. We assume that if
 	 * this physical eraseblock went bad, the erase code will handle that.
 	 */
-	err = ubi_wl_put_peb(ubi, pnum, 1);
+	err = ubi_wl_put_peb(ubi, pnum, 1, lnum);
 	if (err || ++tries > UBI_IO_RETRIES) {
 		ubi_ro_mode(ubi);
 		leb_write_unlock(ubi, vol_id, lnum);
@@ -804,7 +804,7 @@ write_error:
 		return err;
 	}

-	err = ubi_wl_put_peb(ubi, pnum, 1);
+	err = ubi_wl_put_peb(ubi, pnum, 1, lnum);
 	if (err || ++tries > UBI_IO_RETRIES) {
 		ubi_ro_mode(ubi);
 		leb_write_unlock(ubi, vol_id, lnum);
@@ -901,7 +901,7 @@ retry:
 	}

 	if (vol->eba_tbl[lnum] >= 0) {
-		err = ubi_wl_put_peb(ubi, vol->eba_tbl[lnum], 0);
+		err = ubi_wl_put_peb(ubi, vol->eba_tbl[lnum], 0, lnum);
 		if (err)
 			goto out_leb_unlock;
 	}
@@ -926,7 +926,7 @@ write_error:
 		goto out_leb_unlock;
 	}

-	err = ubi_wl_put_peb(ubi, pnum, 1);
+	err = ubi_wl_put_peb(ubi, pnum, 1, lnum);
 	if (err || ++tries > UBI_IO_RETRIES) {
 		ubi_ro_mode(ubi);
 		goto out_leb_unlock;
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 75b9f1c..b3e5815 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -533,7 +533,7 @@ int ubi_eba_init_scan(struct ubi_device *ubi, struct ubi_scan_info *si);

 /* wl.c */
 int ubi_wl_get_peb(struct ubi_device *ubi);
-int ubi_wl_put_peb(struct ubi_device *ubi, int pnum, int torture);
+int ubi_wl_put_peb(struct ubi_device *ubi, int pnum, int torture, int lnum);
 int ubi_wl_flush(struct ubi_device *ubi);
 int ubi_wl_scrub_peb(struct ubi_device *ubi, int pnum);
 int ubi_wl_init_scan(struct ubi_device *ubi, struct ubi_scan_info *si);
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 64ce993..4e51735 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -141,6 +141,7 @@
  * @func: worker function
  * @e: physical eraseblock to erase
  * @torture: if the physical eraseblock has to be tortured
+ * @lnum: the logical number of the erase block
  *
  * The @func pointer points to the worker function. If the @cancel argument is
  * not zero, the worker has to free the resources and exit immediately. The
@@ -153,6 +154,7 @@ struct ubi_work {
 	/* The below fields are only relevant to erasure works */
 	struct ubi_wl_entry *e;
 	int torture;
+	int lnum;
 };

 #ifdef CONFIG_MTD_UBI_DEBUG
@@ -587,12 +589,13 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
  * @ubi: UBI device description object
  * @e: the WL entry of the physical eraseblock to erase
  * @torture: if the physical eraseblock has to be tortured
+ * @lnum: the last used logical block number for the eraseblock
  *
  * This function returns zero in case of success and a %-ENOMEM in case of
  * failure.
  */
 static int schedule_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
-			  int torture)
+			  int torture, int lnum)
 {
 	struct ubi_work *wl_wrk;

@@ -606,6 +609,7 @@ static int schedule_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
 	wl_wrk->func = &erase_worker;
 	wl_wrk->e = e;
 	wl_wrk->torture = torture;
+	wl_wrk->lnum = lnum;

 	schedule_ubi_work(ubi, wl_wrk);
 	return 0;
@@ -805,7 +809,7 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 	ubi->move_to_put = ubi->wl_scheduled = 0;
 	spin_unlock(&ubi->wl_lock);

-	err = schedule_erase(ubi, e1, 0);
+	err = schedule_erase(ubi, e1, 0, lnum);
 	if (err) {
 		kmem_cache_free(ubi_wl_entry_slab, e1);
 		if (e2)
@@ -820,7 +824,7 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 		 */
 		dbg_wl("PEB %d (LEB %d:%d) was put meanwhile, erase",
 		       e2->pnum, vol_id, lnum);
-		err = schedule_erase(ubi, e2, 0);
+		err = schedule_erase(ubi, e2, 0, lnum);
 		if (err) {
 			kmem_cache_free(ubi_wl_entry_slab, e2);
 			goto out_ro;
@@ -859,7 +863,7 @@ out_not_moved:
 	spin_unlock(&ubi->wl_lock);

 	ubi_free_vid_hdr(ubi, vid_hdr);
-	err = schedule_erase(ubi, e2, torture);
+	err = schedule_erase(ubi, e2, torture, lnum);
 	if (err) {
 		kmem_cache_free(ubi_wl_entry_slab, e2);
 		goto out_ro;
@@ -986,7 +990,7 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 		return 0;
 	}

-	dbg_wl("erase PEB %d EC %d", pnum, e->ec);
+	dbg_wl("erase PEB %d EC %d LEB %d", pnum, e->ec, wl_wrk->lnum);

 	err = sync_erase(ubi, e, wl_wrk->torture);
 	if (!err) {
@@ -1016,7 +1020,7 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 		int err1;

 		/* Re-schedule the LEB for erasure */
-		err1 = schedule_erase(ubi, e, 0);
+		err1 = schedule_erase(ubi, e, 0, wl_wrk->lnum);
 		if (err1) {
 			err = err1;
 			goto out_ro;
@@ -1086,13 +1090,14 @@ out_ro:
  * @ubi: UBI device description object
  * @pnum: physical eraseblock to return
  * @torture: if this physical eraseblock has to be tortured
+ * @lnum: the last used logical eraseblock number for the PEB
  *
  * This function is called to return physical eraseblock @pnum to the pool of
  * free physical eraseblocks. The @torture flag has to be set if an I/O error
  * occurred to this @pnum and it has to be tested. This function returns zero
  * in case of success, and a negative error code in case of failure.
  */
-int ubi_wl_put_peb(struct ubi_device *ubi, int pnum, int torture)
+int ubi_wl_put_peb(struct ubi_device *ubi, int pnum, int torture, int lnum)
 {
 	int err;
 	struct ubi_wl_entry *e;
@@ -1158,7 +1163,7 @@ retry:
 	}
 	spin_unlock(&ubi->wl_lock);

-	err = schedule_erase(ubi, e, torture);
+	err = schedule_erase(ubi, e, torture, lnum);
 	if (err) {
 		spin_lock(&ubi->wl_lock);
 		wl_tree_add(e, &ubi->used);
@@ -1423,7 +1428,7 @@ int ubi_wl_init_scan(struct ubi_device *ubi, struct ubi_scan_info *si)
 		e->pnum = seb->pnum;
 		e->ec = seb->ec;
 		ubi->lookuptbl[e->pnum] = e;
-		if (schedule_erase(ubi, e, 0)) {
+		if (schedule_erase(ubi, e, 0, seb->lnum)) {
 			kmem_cache_free(ubi_wl_entry_slab, e);
 			goto out_free;
 		}
-- 
1.7.5.4

