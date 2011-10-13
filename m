Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab1JMKcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 06:32:48 -0400
Received: from mail09.linbit.com ([212.69.161.110]:58138 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab1JMKcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 06:32:21 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 08/10] drbd: on attach, enforce clean meta data
Date: Thu, 13 Oct 2011 12:32:14 +0200
Message-Id: <1318501936-11689-9-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318501936-11689-1-git-send-email-philipp.reisner@linbit.com>
References: <1318501936-11689-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Detection of unclean shutdown has moved into user space.

The kernel code will, whenever it updates the meta data, mark it as
"unclean", and will refuse to attach to such unclean meta data.

"drbdadm up" now schedules "drbdmeta apply-al", which will apply
the activity log to the bitmap, and/or reinitialize it, if necessary,
as well as set a "clean" indicator flag.

This moves a bit code out of kernel space.
As a side effect, it also prevents some 8.3 module from accidentally
ignoring the 8.4 style activity log, if someone should downgrade,
whether on purpose, or accidentally because he changed kernel versions
without providing an 8.4 for the new kernel, and the new kernel comes
with in-tree 8.3.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c |  259 --------------------------------------
 drivers/block/drbd/drbd_int.h    |    6 -
 drivers/block/drbd/drbd_main.c   |   21 +++-
 drivers/block/drbd/drbd_nl.c     |   19 +---
 drivers/block/drbd/drbd_state.c  |    1 +
 include/linux/drbd.h             |   10 ++-
 6 files changed, 28 insertions(+), 288 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 58b5b61..da8ffd5 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -462,265 +462,6 @@ w_al_write_transaction(struct drbd_work *w, int unused)
 	return 0;
 }
 
-/* FIXME
- * reading of the activity log,
- * and potentially dirtying of the affected bitmap regions,
- * should be done from userland only.
- * DRBD would simply always attach with an empty activity log,
- * and refuse to attach to something that looks like a crashed primary.
- */
-
-/**
- * drbd_al_read_tr() - Read a single transaction from the on disk activity log
- * @mdev:	DRBD device.
- * @bdev:	Block device to read form.
- * @b:		pointer to an al_transaction.
- * @index:	On disk slot of the transaction to read.
- *
- * Returns -1 on IO error, 0 on checksum error and 1 upon success.
- */
-static int drbd_al_read_tr(struct drbd_conf *mdev,
-			   struct drbd_backing_dev *bdev,
-			   int index)
-{
-	struct al_transaction_on_disk *b = page_address(mdev->md_io_page);
-	sector_t sector;
-	u32 crc;
-
-	sector =  bdev->md.md_offset
-		+ bdev->md.al_offset
-		+ index * (MD_BLOCK_SIZE>>9);
-
-	/* Dont process error normally,
-	 * as this is done before disk is attached! */
-	if (drbd_md_sync_page_io(mdev, bdev, sector, READ))
-		return -1;
-
-	if (!expect(b->magic == cpu_to_be32(DRBD_AL_MAGIC)))
-		return 0;
-
-	if (!expect(be16_to_cpu(b->n_updates) <= AL_UPDATES_PER_TRANSACTION))
-		return 0;
-
-	if (!expect(be16_to_cpu(b->context_size) <= DRBD_AL_EXTENTS_MAX))
-		return 0;
-
-	if (!expect(be16_to_cpu(b->context_start_slot_nr) < DRBD_AL_EXTENTS_MAX))
-		return 0;
-
-	crc = be32_to_cpu(b->crc32c);
-	b->crc32c = 0;
-	if (!expect(crc == crc32c(0, b, 4096)))
-		return 0;
-
-	return 1;
-}
-
-/**
- * drbd_al_read_log() - Restores the activity log from its on disk representation.
- * @mdev:	DRBD device.
- * @bdev:	Block device to read form.
- *
- * Returns 1 on success, returns 0 when reading the log failed due to IO errors.
- */
-int drbd_al_read_log(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
-{
-	struct al_transaction_on_disk *b;
-	int i;
-	int rv;
-	int mx;
-	int active_extents = 0;
-	int transactions = 0;
-	int found_valid = 0;
-	int found_initialized = 0;
-	int from = 0;
-	int to = 0;
-	u32 from_tnr = 0;
-	u32 to_tnr = 0;
-	u32 cnr;
-
-	/* Note that this is expected to be called with a newly created,
-	 * clean and all unused activity log of the "expected size".
-	 */
-
-	/* lock out all other meta data io for now,
-	 * and make sure the page is mapped.
-	 */
-	b = drbd_md_get_buffer(mdev);
-	if (!b)
-		return 0;
-
-	/* Always use the full ringbuffer space for now.
-	 * possible optimization: read in all of it,
-	 * then scan the in-memory pages. */
-
-	mx = (MD_AL_SECTORS*512/MD_BLOCK_SIZE);
-
-	/* Find the valid transaction in the log */
-	for (i = 0; i < mx; i++) {
-		rv = drbd_al_read_tr(mdev, bdev, i);
-		/* invalid data in that block */
-		if (rv == 0)
-			continue;
-		if (be16_to_cpu(b->transaction_type) == AL_TR_INITIALIZED) {
-			++found_initialized;
-			continue;
-		}
-
-		/* IO error */
-		if (rv == -1) {
-			drbd_md_put_buffer(mdev);
-			return 0;
-		}
-
-		cnr = be32_to_cpu(b->tr_number);
-		if (++found_valid == 1) {
-			from = i;
-			to = i;
-			from_tnr = cnr;
-			to_tnr = cnr;
-			continue;
-		}
-
-		D_ASSERT(cnr != to_tnr);
-		D_ASSERT(cnr != from_tnr);
-		if ((int)cnr - (int)from_tnr < 0) {
-			D_ASSERT(from_tnr - cnr + i - from == mx);
-			from = i;
-			from_tnr = cnr;
-		}
-		if ((int)cnr - (int)to_tnr > 0) {
-			D_ASSERT(cnr - to_tnr == i - to);
-			to = i;
-			to_tnr = cnr;
-		}
-	}
-
-	if (!found_valid) {
-		if (found_initialized != mx)
-			dev_warn(DEV, "No usable activity log found.\n");
-		drbd_md_put_buffer(mdev);
-		return 1;
-	}
-
-	/* Read the valid transactions.
-	 * dev_info(DEV, "Reading from %d to %d.\n",from,to); */
-	i = from;
-	while (1) {
-		struct lc_element *e;
-		unsigned j, n, slot, extent_nr;
-
-		rv = drbd_al_read_tr(mdev, bdev, i);
-		if (!expect(rv != 0))
-			goto cancel;
-		if (rv == -1) {
-			drbd_md_put_buffer(mdev);
-			return 0;
-		}
-
-		/* deal with different transaction types.
-		 * not yet implemented */
-		if (!expect(b->transaction_type == 0))
-			goto cancel;
-
-		/* on the fly re-create/resize activity log?
-		 * will be a special transaction type flag. */
-		if (!expect(be16_to_cpu(b->context_size) == mdev->act_log->nr_elements))
-			goto cancel;
-		if (!expect(be16_to_cpu(b->context_start_slot_nr) < mdev->act_log->nr_elements))
-			goto cancel;
-
-		/* We are the only user of the activity log right now,
-		 * don't actually need to take that lock. */
-		spin_lock_irq(&mdev->al_lock);
-
-		/* first, apply the context, ... */
-		for (j = 0, slot = be16_to_cpu(b->context_start_slot_nr);
-		     j < AL_CONTEXT_PER_TRANSACTION &&
-		     slot < mdev->act_log->nr_elements; j++, slot++) {
-			extent_nr = be32_to_cpu(b->context[j]);
-			e = lc_element_by_index(mdev->act_log, slot);
-			if (e->lc_number != extent_nr) {
-				if (extent_nr != LC_FREE)
-					active_extents++;
-				else
-					active_extents--;
-			}
-			lc_set(mdev->act_log, extent_nr, slot);
-		}
-
-		/* ... then apply the updates,
-		 * which override the context information.
-		 * drbd_al_read_tr already did the rangecheck
-		 * on n <= AL_UPDATES_PER_TRANSACTION */
-		n = be16_to_cpu(b->n_updates);
-		for (j = 0; j < n; j++) {
-			slot = be16_to_cpu(b->update_slot_nr[j]);
-			extent_nr = be32_to_cpu(b->update_extent_nr[j]);
-			if (!expect(slot < mdev->act_log->nr_elements))
-				break;
-			e = lc_element_by_index(mdev->act_log, slot);
-			if (e->lc_number != extent_nr) {
-				if (extent_nr != LC_FREE)
-					active_extents++;
-				else
-					active_extents--;
-			}
-			lc_set(mdev->act_log, extent_nr, slot);
-		}
-		spin_unlock_irq(&mdev->al_lock);
-
-		transactions++;
-
-cancel:
-		if (i == to)
-			break;
-		i++;
-		if (i >= mx)
-			i = 0;
-	}
-
-	mdev->al_tr_number = to_tnr+1;
-	mdev->al_tr_pos = (to + 1) % (MD_AL_SECTORS*512/MD_BLOCK_SIZE);
-
-	/* ok, we are done with it */
-	drbd_md_put_buffer(mdev);
-
-	dev_info(DEV, "Found %d transactions (%d active extents) in activity log.\n",
-	     transactions, active_extents);
-
-	return 1;
-}
-
-/**
- * drbd_al_apply_to_bm() - Sets the bitmap to dirty(1) where covered by active AL extents
- * @mdev:	DRBD device.
- */
-void drbd_al_apply_to_bm(struct drbd_conf *mdev)
-{
-	unsigned int enr;
-	unsigned long add = 0;
-	char ppb[10];
-	int i, tmp;
-
-	wait_event(mdev->al_wait, lc_try_lock(mdev->act_log));
-
-	for (i = 0; i < mdev->act_log->nr_elements; i++) {
-		enr = lc_element_by_index(mdev->act_log, i)->lc_number;
-		if (enr == LC_FREE)
-			continue;
-		tmp = drbd_bm_ALe_set_all(mdev, enr);
-		dynamic_dev_dbg(DEV, "AL: set %d bits in extent %u\n", tmp, enr);
-		add += tmp;
-	}
-
-	lc_unlock(mdev->act_log);
-	wake_up(&mdev->al_wait);
-
-	dev_info(DEV, "Marked additional %s as out-of-sync based on AL.\n",
-	     ppsize(ppb, Bit2KB(add)));
-}
-
 static int _try_lc_del(struct drbd_conf *mdev, struct lc_element *al_ext)
 {
 	int rv;
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 4e58205..9d0d6d0 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -164,10 +164,6 @@ drbd_insert_fault(struct drbd_conf *mdev, unsigned int type) {
 /* usual integer division */
 #define div_floor(A, B) ((A)/(B))
 
-/* drbd_meta-data.c (still in drbd_main.c) */
-/* 4th incarnation of the disk layout. */
-#define DRBD_MD_MAGIC (DRBD_MAGIC+4)
-
 extern struct ratelimit_state drbd_ratelimit_state;
 extern struct idr minors; /* RCU, updates: genl_lock() */
 extern struct list_head drbd_tconns; /* RCU, updates: genl_lock() */
@@ -1560,7 +1556,6 @@ extern void drbd_rs_cancel_all(struct drbd_conf *mdev);
 extern int drbd_rs_del_all(struct drbd_conf *mdev);
 extern void drbd_rs_failed_io(struct drbd_conf *mdev,
 		sector_t sector, int size);
-extern int drbd_al_read_log(struct drbd_conf *mdev, struct drbd_backing_dev *);
 extern void drbd_advance_rs_marks(struct drbd_conf *mdev, unsigned long still_to_go);
 extern void __drbd_set_in_sync(struct drbd_conf *mdev, sector_t sector,
 		int size, const char *file, const unsigned int line);
@@ -1570,7 +1565,6 @@ extern int __drbd_set_out_of_sync(struct drbd_conf *mdev, sector_t sector,
 		int size, const char *file, const unsigned int line);
 #define drbd_set_out_of_sync(mdev, sector, size) \
 	__drbd_set_out_of_sync(mdev, sector, size, __FILE__, __LINE__)
-extern void drbd_al_apply_to_bm(struct drbd_conf *mdev);
 extern void drbd_al_shrink(struct drbd_conf *mdev);
 
 /* drbd_nl.c */
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 1538498..0e49dea 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2932,7 +2932,7 @@ void drbd_md_sync(struct drbd_conf *mdev)
 	for (i = UI_CURRENT; i < UI_SIZE; i++)
 		buffer->uuid[i] = cpu_to_be64(mdev->ldev->md.uuid[i]);
 	buffer->flags = cpu_to_be32(mdev->ldev->md.flags);
-	buffer->magic = cpu_to_be32(DRBD_MD_MAGIC);
+	buffer->magic = cpu_to_be32(DRBD_MD_MAGIC_84_UNCLEAN);
 
 	buffer->md_size_sect  = cpu_to_be32(mdev->ldev->md.md_size_sect);
 	buffer->al_offset     = cpu_to_be32(mdev->ldev->md.al_offset);
@@ -2967,11 +2967,12 @@ out:
  * @bdev:	Device from which the meta data should be read in.
  *
  * Return 0 (NO_ERROR) on success, and an enum drbd_ret_code in case
- * something goes wrong.  Currently only: ERR_IO_MD_DISK, ERR_MD_INVALID.
+ * something goes wrong.
  */
 int drbd_md_read(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 {
 	struct meta_data_on_disk *buffer;
+	u32 magic, flags;
 	int i, rv = NO_ERROR;
 
 	if (!get_ldev_if_state(mdev, D_ATTACHING))
@@ -2989,8 +2990,20 @@ int drbd_md_read(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 		goto err;
 	}
 
-	if (buffer->magic != cpu_to_be32(DRBD_MD_MAGIC)) {
-		dev_err(DEV, "Error while reading metadata, magic not found.\n");
+	magic = be32_to_cpu(buffer->magic);
+	flags = be32_to_cpu(buffer->flags);
+	if (magic == DRBD_MD_MAGIC_84_UNCLEAN ||
+	    (magic == DRBD_MD_MAGIC_08 && !(flags & MDF_AL_CLEAN))) {
+			/* btw: that's Activity Log clean, not "all" clean. */
+		dev_err(DEV, "Found unclean meta data. Did you \"drbdadm apply-al\"?\n");
+		rv = ERR_MD_UNCLEAN;
+		goto err;
+	}
+	if (magic != DRBD_MD_MAGIC_08) {
+		if (magic == DRBD_MD_MAGIC_07) 
+			dev_err(DEV, "Found old (0.7) meta data magic. Did you \"drbdadm create-md\"?\n");
+		else
+			dev_err(DEV, "Meta data magic not found. Did you \"drbdadm create-md\"?\n");
 		rv = ERR_MD_INVALID;
 		goto err;
 	}
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index d6bdb59..463029a 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1307,7 +1307,6 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	union drbd_state ns, os;
 	enum drbd_state_rv rv;
 	struct net_conf *nc;
-	int cp_discovered = 0;
 
 	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
 	if (!adm_ctx.reply_skb)
@@ -1517,11 +1516,6 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		goto force_diskless_dec;
 	}
 
-	if (!drbd_al_read_log(mdev, nbc)) {
-		retcode = ERR_IO_MD_DISK;
-		goto force_diskless_dec;
-	}
-
 	/* Reset the "barriers don't work" bits here, then force meta data to
 	 * be written, to ensure we determine if barriers are supported. */
 	if (new_disk_conf->md_flushes)
@@ -1551,10 +1545,8 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		clear_bit(CRASHED_PRIMARY, &mdev->flags);
 
 	if (drbd_md_test_flag(mdev->ldev, MDF_PRIMARY_IND) &&
-	    !(mdev->state.role == R_PRIMARY && mdev->tconn->susp_nod)) {
+	    !(mdev->state.role == R_PRIMARY && mdev->tconn->susp_nod))
 		set_bit(CRASHED_PRIMARY, &mdev->flags);
-		cp_discovered = 1;
-	}
 
 	mdev->send_cnt = 0;
 	mdev->recv_cnt = 0;
@@ -1606,15 +1598,6 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	if (cp_discovered) {
-		drbd_al_apply_to_bm(mdev);
-		if (drbd_bitmap_io(mdev, &drbd_bm_write,
-			"crashed primary apply AL", BM_LOCKED_MASK)) {
-			retcode = ERR_IO_MD_DISK;
-			goto force_diskless_dec;
-		}
-	}
-
 	if (_drbd_bm_total_weight(mdev) == drbd_bm_bits(mdev))
 		drbd_suspend_al(mdev); /* IO is still suspended here... */
 
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 0f538a6..65d22f3 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1017,6 +1017,7 @@ __drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
 						 MDF_CONNECTED_IND|MDF_WAS_UP_TO_DATE|
 						 MDF_PEER_OUT_DATED|MDF_CRASHED_PRIMARY);
 
+		mdf &= ~MDF_AL_CLEAN;
 		if (test_bit(CRASHED_PRIMARY, &mdev->flags))
 			mdf |= MDF_CRASHED_PRIMARY;
 		if (mdev->state.role == R_PRIMARY ||
diff --git a/include/linux/drbd.h b/include/linux/drbd.h
index 161cd41..1e9f754 100644
--- a/include/linux/drbd.h
+++ b/include/linux/drbd.h
@@ -162,6 +162,7 @@ enum drbd_ret_code {
 	ERR_INVALID_REQUEST	= 162,
 	ERR_NEED_APV_100	= 163,
 	ERR_NEED_ALLOW_TWO_PRI  = 164,
+	ERR_MD_UNCLEAN          = 165,
 
 	/* insert new ones above this line */
 	AFTER_LAST_ERR_CODE
@@ -321,7 +322,8 @@ extern const char *drbd_set_st_err_str(enum drbd_state_rv);
 #define MDF_FULL_SYNC		(1 << 3)
 #define MDF_WAS_UP_TO_DATE	(1 << 4)
 #define MDF_PEER_OUT_DATED	(1 << 5)
-#define MDF_CRASHED_PRIMARY     (1 << 6)
+#define MDF_CRASHED_PRIMARY	(1 << 6)
+#define MDF_AL_CLEAN		(1 << 7)
 
 enum drbd_uuid_index {
 	UI_CURRENT,
@@ -341,10 +343,16 @@ enum drbd_timeout_flag {
 
 #define UUID_JUST_CREATED ((__u64)4)
 
+/* magic numbers used in meta data and network packets */
 #define DRBD_MAGIC 0x83740267
 #define DRBD_MAGIC_BIG 0x835a
 #define DRBD_MAGIC_100 0x8620ec20
 
+#define DRBD_MD_MAGIC_07   (DRBD_MAGIC+3)
+#define DRBD_MD_MAGIC_08   (DRBD_MAGIC+4)
+#define DRBD_MD_MAGIC_84_UNCLEAN	(DRBD_MAGIC+5)
+
+
 /* how I came up with this magic?
  * base64 decode "actlog==" ;) */
 #define DRBD_AL_MAGIC 0x69cb65a2
-- 
1.7.4.1

