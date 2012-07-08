Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab2GHLr4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 07:47:56 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55643 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab2GHLrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 07:47:55 -0400
Date: Sun, 8 Jul 2012 14:47:45 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, Heinz.Egger@linutronix.de,
        thomas.wucher@linutronix.de, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com
Subject: Re: UBI fastmap updates
Message-ID: <20120708144745.36109029@pixies.home.jungo.com>
In-Reply-To: <1340982869-77042-1-git-send-email-richard@nod.at>
References: <1340982869-77042-1-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Fri, 29 Jun 2012 17:14:18 +0200 Richard Weinberger <richard@nod.at> wrote:
> This is the next round of UBI fastmap updates.

Please examine some TODOs (and questions) I've spotted while diffing
against "vanilla" ubi.

This patch should apply to linux-ubi at d41a140

Sorry I couldn't review entirely, diff has gotten really enormous...
I'll try to pick it up again when you'll get to the final merge
submitting incremental patches.

Regards,
Shmulik

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index a343a41..dae9674 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -999,6 +999,13 @@ static int scan_peb(struct ubi_device *ubi, struct ubi_attach_info *ai,
 
 	if (!find_fastmap &&
 	   (vol_id > UBI_MAX_VOLUMES && vol_id != UBI_LAYOUT_VOLUME_ID)) {
+
+		/* TODO: if find_fastmap==1, we do not enter this block at all.
+		 * shouldn't we? shouldn't we care of compatability of unknown
+		 * internal volumes OTHER than the fastmap ones, even if
+		 * find_fastmap==1?
+		 */
+
 		int lnum = be32_to_cpu(vidh->lnum);
 
 		/* Unsupported internal volume */
@@ -1221,6 +1228,7 @@ static void destroy_ai(struct ubi_attach_info *ai)
  * scan_all - scan entire MTD device.
  * @ubi: UBI device description object
  * @ai: attach info object
+ * TODO: document @start
  *
  * This function does full scanning of an MTD device and returns complete
  * information about it in form of a "struct ubi_attach_info" object. In case
@@ -1350,6 +1358,11 @@ out_vidh:
 out_ech:
 	kfree(ech);
 out_ai:
+	/* TODO: doesn't seem clean to destroy 'ai' as it was allocated by the
+	 * caller, its his responsibility.
+	 * also looks like it leads to double freee in case 'err' returned is
+	 * negative
+	 */
 	destroy_ai(ai);
 	return err;
 }
@@ -1441,6 +1454,7 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 
 		err = scan_all(ubi, scan_ai, 0);
 		if (err) {
+			/* TODO: hmm... kfree or destroy_ai ? */
 			kfree(scan_ai);
 			goto out_wl;
 		}
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 50b7590..f769c22 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -1053,6 +1053,7 @@ int ubi_detach_mtd_dev(int ubi_num, int anyway)
 	ubi_notify_all(ubi, UBI_VOLUME_REMOVED, NULL);
 	dbg_msg("detaching mtd%d from ubi%d", ubi->mtd->index, ubi_num);
 
+	/* TODO: any action on failure? */
 	ubi_update_fastmap(ubi);
 
 	/*
@@ -1070,7 +1071,6 @@ int ubi_detach_mtd_dev(int ubi_num, int anyway)
 
 	ubi_debugfs_exit_dev(ubi);
 	uif_close(ubi);
-
 	ubi_wl_close(ubi);
 	ubi_free_internal_volumes(ubi);
 	vfree(ubi->vtbl);
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 9f766ff..0b2d0cf 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -219,7 +219,7 @@ struct ubi_volume_desc;
  * @size: size of the fastmap in bytes
  * @used_blocks: number of used PEBs
  * @max_pool_size: maximal size of the user pool
- * @max_wl_pool_size: maximal size of the pooly used by the WL sub-system
+ * @max_wl_pool_size: maximal size of the pool used by the WL sub-system
  * @raw: the fastmap itself as byte array (only valid while attaching)
  */
 struct ubi_fastmap_layout {
@@ -242,7 +242,6 @@ struct ubi_fastmap_layout {
  * A pool gets filled with up to max_size.
  * If all PEBs within the pool are used a new fastmap will be written
  * to the flash and the pool gets refilled with empty PEBs.
- *
  */
 struct ubi_fm_pool {
 	int pebs[UBI_FM_MAX_POOL_SIZE];
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 6c69017..688881b 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -272,6 +272,10 @@ static int produce_free_peb(struct ubi_device *ubi)
 		dbg_wl("do one work synchronously");
 		err = do_work(ubi);
 		if (err)
+			/* TODO: in the new locking scheme, produce_free_peb is
+			 * called under wl_lock taken.
+			 * so when returning, should reacquire the lock
+			 */
 			return err;
 
 		spin_lock(&ubi->wl_lock);
@@ -377,6 +381,7 @@ static struct ubi_wl_entry *find_wl_entry(struct ubi_device *ubi,
 	 * as anchor PEB, hold it back and return the second best WL entry
 	 * such that fastmap can use the anchor PEB later. */
 	if (!ubi->fm_disabled && !ubi->fm && e->pnum < UBI_FM_MAX_START)
+		/* TODO: do we have a risk returning NULL here? */
 		return prev_e;
 
 	return e;
@@ -405,6 +410,7 @@ static struct ubi_wl_entry *find_mean_wl_entry(struct ubi_device *ubi,
 		/* If no fastmap has been written and this WL entry can be used
 		 * as anchor PEB, hold it back and return the second best
 		 * WL entry such that fastmap can use the anchor PEB later. */
+		/* TODO: why this is specific just to < WL_FREE_MAX_DIFF case? */
 		if (e && !ubi->fm_disabled && !ubi->fm &&
 		    e->pnum < UBI_FM_MAX_START)
 			e = rb_entry(rb_next(root->rb_node),
