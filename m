Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab1H3JGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 05:06:31 -0400
Received: from mail09.linbit.com ([212.69.161.110]:38215 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab1H3JF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 05:05:57 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 13/15] drbd: new on-disk activity log transaction format
Date: Tue, 30 Aug 2011 11:05:47 +0200
Message-Id: <1314695149-387-14-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314695149-387-1-git-send-email-philipp.reisner@linbit.com>
References: <1314695149-387-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Use a new on-disk transaction format for the activity log, which allows
for multiple changes to the active set per transaction.

Using 4k transaction blocks, we can now get rid of the work-around code
to deal with devices not supporting 512 byte logical block size.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c |  403 +++++++++++++++++++++++---------------
 drivers/block/drbd/drbd_int.h    |   44 +++--
 drivers/block/drbd/drbd_main.c   |    4 -
 drivers/block/drbd/drbd_nl.c     |   42 +---
 include/linux/drbd.h             |    4 +
 include/linux/drbd_limits.h      |    8 +-
 6 files changed, 294 insertions(+), 211 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 44097c8..55f5a7a 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -24,21 +24,67 @@
  */
 
 #include <linux/slab.h>
+#include <linux/crc32c.h>
 #include <linux/drbd.h>
+#include <linux/drbd_limits.h>
+#include <linux/dynamic_debug.h>
 #include "drbd_int.h"
 #include "drbd_wrappers.h"
 
-/* We maintain a trivial checksum in our on disk activity log.
- * With that we can ensure correct operation even when the storage
- * device might do a partial (last) sector write while losing power.
- */
-struct __packed al_transaction {
-	u32       magic;
-	u32       tr_number;
-	struct __packed {
-		u32 pos;
-		u32 extent; } updates[1 + AL_EXTENTS_PT];
-	u32       xor_sum;
+/* all fields on disc in big endian */
+struct __packed al_transaction_on_disk {
+	/* don't we all like magic */
+	__be32	magic;
+
+	/* to identify the most recent transaction block
+	 * in the on disk ring buffer */
+	__be32	tr_number;
+
+	/* checksum on the full 4k block, with this field set to 0. */
+	__be32	crc32c;
+
+	/* type of transaction, special transaction types like:
+	 * purge-all, set-all-idle, set-all-active, ... to-be-defined */
+	__be16	transaction_type;
+
+	/* we currently allow only a few thousand extents,
+	 * so 16bit will be enough for the slot number. */
+
+	/* how many updates in this transaction */
+	__be16	n_updates;
+
+	/* maximum slot number, "al-extents" in drbd.conf speak.
+	 * Having this in each transaction should make reconfiguration
+	 * of that parameter easier. */
+	__be16	context_size;
+
+	/* slot number the context starts with */
+	__be16	context_start_slot_nr;
+
+	/* Some reserved bytes.  Expected usage is a 64bit counter of
+	 * sectors-written since device creation, and other data generation tag
+	 * supporting usage */
+	__be32	__reserved[4];
+
+	/* --- 36 byte used --- */
+
+	/* Reserve space for up to AL_UPDATES_PER_TRANSACTION changes
+	 * in one transaction, then use the remaining byte in the 4k block for
+	 * context information.  "Flexible" number of updates per transaction
+	 * does not help, as we have to account for the case when all update
+	 * slots are used anyways, so it would only complicate code without
+	 * additional benefit.
+	 */
+	__be16	update_slot_nr[AL_UPDATES_PER_TRANSACTION];
+
+	/* but the extent number is 32bit, which at an extent size of 4 MiB
+	 * allows to cover device sizes of up to 2**54 Byte (16 PiB) */
+	__be32	update_extent_nr[AL_UPDATES_PER_TRANSACTION];
+
+	/* --- 420 bytes used (36 + 64*6) --- */
+
+	/* 4096 - 420 = 3676 = 919 * 4 */
+	__be32	context[AL_CONTEXT_PER_TRANSACTION];
 };
 
 struct update_odbm_work {
@@ -48,11 +94,8 @@ struct update_odbm_work {
 
 struct update_al_work {
 	struct drbd_work w;
-	struct lc_element *al_ext;
 	struct completion event;
-	unsigned int enr;
-	/* if old_enr != LC_FREE, write corresponding bitmap sector, too */
-	unsigned int old_enr;
+	int err;
 };
 
 struct drbd_atodb_wait {
@@ -107,67 +150,30 @@ static int _drbd_md_sync_page_io(struct drbd_conf *mdev,
 int drbd_md_sync_page_io(struct drbd_conf *mdev, struct drbd_backing_dev *bdev,
 			 sector_t sector, int rw)
 {
-	int logical_block_size, mask, ok;
-	int offset = 0;
+	int ok;
 	struct page *iop = mdev->md_io_page;
 
 	D_ASSERT(mutex_is_locked(&mdev->md_io_mutex));
 
 	BUG_ON(!bdev->md_bdev);
 
-	logical_block_size = bdev_logical_block_size(bdev->md_bdev);
-	if (logical_block_size == 0)
-		logical_block_size = MD_SECTOR_SIZE;
-
-	/* in case logical_block_size != 512 [ s390 only? ] */
-	if (logical_block_size != MD_SECTOR_SIZE) {
-		mask = (logical_block_size / MD_SECTOR_SIZE) - 1;
-		D_ASSERT(mask == 1 || mask == 3 || mask == 7);
-		D_ASSERT(logical_block_size == (mask+1) * MD_SECTOR_SIZE);
-		offset = sector & mask;
-		sector = sector & ~mask;
-		iop = mdev->md_io_tmpp;
-
-		if (rw & WRITE) {
-			/* these are GFP_KERNEL pages, pre-allocated
-			 * on device initialization */
-			void *p = page_address(mdev->md_io_page);
-			void *hp = page_address(mdev->md_io_tmpp);
-
-			ok = _drbd_md_sync_page_io(mdev, bdev, iop, sector,
-					READ, logical_block_size);
-
-			if (unlikely(!ok)) {
-				dev_err(DEV, "drbd_md_sync_page_io(,%llus,"
-				    "READ [logical_block_size!=512]) failed!\n",
-				    (unsigned long long)sector);
-				return 0;
-			}
-
-			memcpy(hp + offset*MD_SECTOR_SIZE, p, MD_SECTOR_SIZE);
-		}
-	}
+	dev_dbg(DEV, "meta_data io: %s [%d]:%s(,%llus,%s)\n",
+	     current->comm, current->pid, __func__,
+	     (unsigned long long)sector, (rw & WRITE) ? "WRITE" : "READ");
 
 	if (sector < drbd_md_first_sector(bdev) ||
-	    sector > drbd_md_last_sector(bdev))
+	    sector + 7 > drbd_md_last_sector(bdev))
 		dev_alert(DEV, "%s [%d]:%s(,%llus,%s) out of range md access!\n",
 		     current->comm, current->pid, __func__,
 		     (unsigned long long)sector, (rw & WRITE) ? "WRITE" : "READ");
 
-	ok = _drbd_md_sync_page_io(mdev, bdev, iop, sector, rw, logical_block_size);
+	ok = _drbd_md_sync_page_io(mdev, bdev, iop, sector, rw, MD_BLOCK_SIZE);
 	if (unlikely(!ok)) {
 		dev_err(DEV, "drbd_md_sync_page_io(,%llus,%s) failed!\n",
 		    (unsigned long long)sector, (rw & WRITE) ? "WRITE" : "READ");
 		return 0;
 	}
 
-	if (logical_block_size != MD_SECTOR_SIZE && !(rw & WRITE)) {
-		void *p = page_address(mdev->md_io_page);
-		void *hp = page_address(mdev->md_io_tmpp);
-
-		memcpy(p, hp + offset*MD_SECTOR_SIZE, MD_SECTOR_SIZE);
-	}
-
 	return ok;
 }
 
@@ -211,20 +217,34 @@ void drbd_al_begin_io(struct drbd_conf *mdev, sector_t sector)
 		 * current->bio_tail list now.
 		 * we have to delegate updates to the activity log
 		 * to the worker thread. */
-		init_completion(&al_work.event);
-		al_work.al_ext = al_ext;
-		al_work.enr = enr;
-		al_work.old_enr = al_ext->lc_number;
-		al_work.w.cb = w_al_write_transaction;
-		al_work.w.mdev = mdev;
-		drbd_queue_work_front(&mdev->tconn->data.work, &al_work.w);
-		wait_for_completion(&al_work.event);
 
-		mdev->al_writ_cnt++;
+		/* Serialize multiple transactions.
+		 * This uses test_and_set_bit, memory barrier is implicit.
+		 * Optimization potential:
+		 * first check for transaction number > old transaction number,
+		 * so not all waiters have to lock/unlock.  */
+		wait_event(mdev->al_wait, lc_try_lock_for_transaction(mdev->act_log));
 
-		spin_lock_irq(&mdev->al_lock);
-		lc_committed(mdev->act_log);
-		spin_unlock_irq(&mdev->al_lock);
+		/* Double check: it may have been committed by someone else,
+		 * while we have been waiting for the lock. */
+		if (al_ext->lc_number != enr) {
+			init_completion(&al_work.event);
+			al_work.w.cb = w_al_write_transaction;
+			al_work.w.mdev = mdev;
+			drbd_queue_work_front(&mdev->tconn->data.work, &al_work.w);
+			wait_for_completion(&al_work.event);
+
+			mdev->al_writ_cnt++;
+
+			spin_lock_irq(&mdev->al_lock);
+			/* FIXME
+			if (al_work.err)
+				we need an "lc_cancel" here;
+			*/
+			lc_committed(mdev->act_log);
+			spin_unlock_irq(&mdev->al_lock);
+		}
+		lc_unlock(mdev->act_log);
 		wake_up(&mdev->al_wait);
 	}
 }
@@ -283,95 +303,108 @@ w_al_write_transaction(struct drbd_work *w, int unused)
 {
 	struct update_al_work *aw = container_of(w, struct update_al_work, w);
 	struct drbd_conf *mdev = w->mdev;
-	struct lc_element *updated = aw->al_ext;
-	const unsigned int new_enr = aw->enr;
-	const unsigned int evicted = aw->old_enr;
-	struct al_transaction *buffer;
+	struct al_transaction_on_disk *buffer;
+	struct lc_element *e;
 	sector_t sector;
-	int i, n, mx;
-	unsigned int extent_nr;
-	u32 xor_sum = 0;
+	int i, mx;
+	unsigned extent_nr;
+	unsigned crc = 0;
 
 	if (!get_ldev(mdev)) {
-		dev_err(DEV,
-			"disk is %s, cannot start al transaction (-%d +%d)\n",
-			drbd_disk_str(mdev->state.disk), evicted, new_enr);
+		dev_err(DEV, "disk is %s, cannot start al transaction\n",
+			drbd_disk_str(mdev->state.disk));
+		aw->err = -EIO;
 		complete(&((struct update_al_work *)w)->event);
 		return 1;
 	}
-	/* do we have to do a bitmap write, first?
-	 * TODO reduce maximum latency:
-	 * submit both bios, then wait for both,
-	 * instead of doing two synchronous sector writes.
-	 * For now, we must not write the transaction,
-	 * if we cannot write out the bitmap of the evicted extent. */
-	if (mdev->state.conn < C_CONNECTED && evicted != LC_FREE)
-		drbd_bm_write_page(mdev, al_extent_to_bm_page(evicted));
 
 	/* The bitmap write may have failed, causing a state change. */
 	if (mdev->state.disk < D_INCONSISTENT) {
 		dev_err(DEV,
-			"disk is %s, cannot write al transaction (-%d +%d)\n",
-			drbd_disk_str(mdev->state.disk), evicted, new_enr);
+			"disk is %s, cannot write al transaction\n",
+			drbd_disk_str(mdev->state.disk));
+		aw->err = -EIO;
 		complete(&((struct update_al_work *)w)->event);
 		put_ldev(mdev);
 		return 1;
 	}
 
 	mutex_lock(&mdev->md_io_mutex); /* protects md_io_buffer, al_tr_cycle, ... */
-	buffer = (struct al_transaction *)page_address(mdev->md_io_page);
+	buffer = page_address(mdev->md_io_page);
 
-	buffer->magic = __constant_cpu_to_be32(DRBD_MAGIC);
+	memset(buffer, 0, sizeof(*buffer));
+	buffer->magic = cpu_to_be32(DRBD_AL_MAGIC);
 	buffer->tr_number = cpu_to_be32(mdev->al_tr_number);
 
-	n = lc_index_of(mdev->act_log, updated);
-
-	buffer->updates[0].pos = cpu_to_be32(n);
-	buffer->updates[0].extent = cpu_to_be32(new_enr);
+	i = 0;
+	/* no need to grab any further lock, this list cannot change
+	 * while we hold the "LC_LOCKED" bit. */
+	list_for_each_entry(e, &mdev->act_log->to_be_changed, list) {
+		BUG_ON(i >= AL_UPDATES_PER_TRANSACTION);
+		buffer->update_slot_nr[i] = cpu_to_be16(e->lc_index);
+		buffer->update_extent_nr[i] = cpu_to_be32(e->lc_new_number);
+		if (e->lc_number != LC_FREE)
+			drbd_bm_mark_for_writeout(mdev,
+					al_extent_to_bm_page(e->lc_number));
+		i++;
+	}
+	buffer->n_updates = cpu_to_be16(i);
+	for ( ; i < AL_UPDATES_PER_TRANSACTION; i++) {
+		buffer->update_slot_nr[i] = cpu_to_be16(-1);
+		buffer->update_extent_nr[i] = cpu_to_be32(LC_FREE);
+	}
 
-	xor_sum ^= new_enr;
+	buffer->context_size = cpu_to_be16(mdev->act_log->nr_elements);
+	buffer->context_start_slot_nr = cpu_to_be16(mdev->al_tr_cycle);
 
-	mx = min_t(int, AL_EXTENTS_PT,
+	mx = min_t(int, AL_CONTEXT_PER_TRANSACTION,
 		   mdev->act_log->nr_elements - mdev->al_tr_cycle);
 	for (i = 0; i < mx; i++) {
 		unsigned idx = mdev->al_tr_cycle + i;
 		extent_nr = lc_element_by_index(mdev->act_log, idx)->lc_number;
-		buffer->updates[i+1].pos = cpu_to_be32(idx);
-		buffer->updates[i+1].extent = cpu_to_be32(extent_nr);
-		xor_sum ^= extent_nr;
-	}
-	for (; i < AL_EXTENTS_PT; i++) {
-		buffer->updates[i+1].pos = __constant_cpu_to_be32(-1);
-		buffer->updates[i+1].extent = __constant_cpu_to_be32(LC_FREE);
-		xor_sum ^= LC_FREE;
+		buffer->context[i] = cpu_to_be32(extent_nr);
 	}
-	mdev->al_tr_cycle += AL_EXTENTS_PT;
+	for (; i < AL_CONTEXT_PER_TRANSACTION; i++)
+		buffer->context[i] = cpu_to_be32(LC_FREE);
+
+	mdev->al_tr_cycle += AL_CONTEXT_PER_TRANSACTION;
 	if (mdev->al_tr_cycle >= mdev->act_log->nr_elements)
 		mdev->al_tr_cycle = 0;
 
-	buffer->xor_sum = cpu_to_be32(xor_sum);
-
 	sector =  mdev->ldev->md.md_offset
-		+ mdev->ldev->md.al_offset + mdev->al_tr_pos;
-
-	if (!drbd_md_sync_page_io(mdev, mdev->ldev, sector, WRITE))
-		drbd_chk_io_error(mdev, 1, true);
+		+ mdev->ldev->md.al_offset
+		+ mdev->al_tr_pos * (MD_BLOCK_SIZE>>9);
 
-	if (++mdev->al_tr_pos >
-	    div_ceil(mdev->act_log->nr_elements, AL_EXTENTS_PT))
-		mdev->al_tr_pos = 0;
+	crc = crc32c(0, buffer, 4096);
+	buffer->crc32c = cpu_to_be32(crc);
 
-	D_ASSERT(mdev->al_tr_pos < MD_AL_MAX_SIZE);
-	mdev->al_tr_number++;
+	if (drbd_bm_write_hinted(mdev))
+		aw->err = -EIO;
+		/* drbd_chk_io_error done already */
+	else if (!drbd_md_sync_page_io(mdev, mdev->ldev, sector, WRITE)) {
+		aw->err = -EIO;
+		drbd_chk_io_error(mdev, 1, true);
+	} else {
+		/* advance ringbuffer position and transaction counter */
+		mdev->al_tr_pos = (mdev->al_tr_pos + 1) % (MD_AL_SECTORS*512/MD_BLOCK_SIZE);
+		mdev->al_tr_number++;
+	}
 
 	mutex_unlock(&mdev->md_io_mutex);
-
 	complete(&((struct update_al_work *)w)->event);
 	put_ldev(mdev);
 
 	return 1;
 }
 
+/* FIXME
+ * reading of the activity log,
+ * and potentially dirtying of the affected bitmap regions,
+ * should be done from userland only.
+ * DRBD would simply always attach with an empty activity log,
+ * and refuse to attach to something that looks like a crashed primary.
+ */
+
 /**
  * drbd_al_read_tr() - Read a single transaction from the on disk activity log
  * @mdev:	DRBD device.
@@ -383,27 +416,39 @@ w_al_write_transaction(struct drbd_work *w, int unused)
  */
 static int drbd_al_read_tr(struct drbd_conf *mdev,
 			   struct drbd_backing_dev *bdev,
-			   struct al_transaction *b,
 			   int index)
 {
+	struct al_transaction_on_disk *b = page_address(mdev->md_io_page);
 	sector_t sector;
-	int rv, i;
-	u32 xor_sum = 0;
+	u32 crc;
 
-	sector = bdev->md.md_offset + bdev->md.al_offset + index;
+	sector =  bdev->md.md_offset
+		+ bdev->md.al_offset
+		+ index * (MD_BLOCK_SIZE>>9);
 
 	/* Dont process error normally,
 	 * as this is done before disk is attached! */
 	if (!drbd_md_sync_page_io(mdev, bdev, sector, READ))
 		return -1;
 
-	rv = (b->magic == cpu_to_be32(DRBD_MAGIC));
+	if (!expect(b->magic == cpu_to_be32(DRBD_AL_MAGIC)))
+		return 0;
 
-	for (i = 0; i < AL_EXTENTS_PT + 1; i++)
-		xor_sum ^= be32_to_cpu(b->updates[i].extent);
-	rv &= (xor_sum == be32_to_cpu(b->xor_sum));
+	if (!expect(be16_to_cpu(b->n_updates) <= AL_UPDATES_PER_TRANSACTION))
+		return 0;
 
-	return rv;
+	if (!expect(be16_to_cpu(b->context_size) <= DRBD_AL_EXTENTS_MAX))
+		return 0;
+
+	if (!expect(be16_to_cpu(b->context_start_slot_nr) < DRBD_AL_EXTENTS_MAX))
+		return 0;
+
+	crc = be32_to_cpu(b->crc32c);
+	b->crc32c = 0;
+	if (!expect(crc == crc32c(0, b, 4096)))
+		return 0;
+
+	return 1;
 }
 
 /**
@@ -415,7 +460,7 @@ static int drbd_al_read_tr(struct drbd_conf *mdev,
  */
 int drbd_al_read_log(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 {
-	struct al_transaction *buffer;
+	struct al_transaction_on_disk *b;
 	int i;
 	int rv;
 	int mx;
@@ -428,25 +473,36 @@ int drbd_al_read_log(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 	u32 to_tnr = 0;
 	u32 cnr;
 
-	mx = div_ceil(mdev->act_log->nr_elements, AL_EXTENTS_PT);
+	/* Note that this is expected to be called with a newly created,
+	 * clean and all unused activity log of the "expected size".
+	 */
 
 	/* lock out all other meta data io for now,
 	 * and make sure the page is mapped.
 	 */
 	mutex_lock(&mdev->md_io_mutex);
-	buffer = page_address(mdev->md_io_page);
+	b = page_address(mdev->md_io_page);
+
+	/* Always use the full ringbuffer space for now.
+	 * possible optimization: read in all of it,
+	 * then scan the in-memory pages. */
+
+	mx = (MD_AL_SECTORS*512/MD_BLOCK_SIZE);
 
 	/* Find the valid transaction in the log */
-	for (i = 0; i <= mx; i++) {
-		rv = drbd_al_read_tr(mdev, bdev, buffer, i);
+	for (i = 0; i < mx; i++) {
+		rv = drbd_al_read_tr(mdev, bdev, i);
+		/* invalid data in that block */
 		if (rv == 0)
 			continue;
+
+		/* IO error */
 		if (rv == -1) {
 			mutex_unlock(&mdev->md_io_mutex);
 			return 0;
 		}
-		cnr = be32_to_cpu(buffer->tr_number);
 
+		cnr = be32_to_cpu(b->tr_number);
 		if (++found_valid == 1) {
 			from = i;
 			to = i;
@@ -454,8 +510,11 @@ int drbd_al_read_log(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 			to_tnr = cnr;
 			continue;
 		}
+
+		D_ASSERT(cnr != to_tnr);
+		D_ASSERT(cnr != from_tnr);
 		if ((int)cnr - (int)from_tnr < 0) {
-			D_ASSERT(from_tnr - cnr + i - from == mx+1);
+			D_ASSERT(from_tnr - cnr + i - from == mx);
 			from = i;
 			from_tnr = cnr;
 		}
@@ -476,11 +535,10 @@ int drbd_al_read_log(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 	 * dev_info(DEV, "Reading from %d to %d.\n",from,to); */
 	i = from;
 	while (1) {
-		int j, pos;
-		unsigned int extent_nr;
-		unsigned int trn;
+		struct lc_element *e;
+		unsigned j, n, slot, extent_nr;
 
-		rv = drbd_al_read_tr(mdev, bdev, buffer, i);
+		rv = drbd_al_read_tr(mdev, bdev, i);
 		if (!expect(rv != 0))
 			goto cancel;
 		if (rv == -1) {
@@ -488,23 +546,55 @@ int drbd_al_read_log(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 			return 0;
 		}
 
-		trn = be32_to_cpu(buffer->tr_number);
+		/* deal with different transaction types.
+		 * not yet implemented */
+		if (!expect(b->transaction_type == 0))
+			goto cancel;
 
-		spin_lock_irq(&mdev->al_lock);
+		/* on the fly re-create/resize activity log?
+		 * will be a special transaction type flag. */
+		if (!expect(be16_to_cpu(b->context_size) == mdev->act_log->nr_elements))
+			goto cancel;
+		if (!expect(be16_to_cpu(b->context_start_slot_nr) < mdev->act_log->nr_elements))
+			goto cancel;
 
-		/* This loop runs backwards because in the cyclic
-		   elements there might be an old version of the
-		   updated element (in slot 0). So the element in slot 0
-		   can overwrite old versions. */
-		for (j = AL_EXTENTS_PT; j >= 0; j--) {
-			pos = be32_to_cpu(buffer->updates[j].pos);
-			extent_nr = be32_to_cpu(buffer->updates[j].extent);
+		/* We are the only user of the activity log right now,
+		 * don't actually need to take that lock. */
+		spin_lock_irq(&mdev->al_lock);
 
-			if (extent_nr == LC_FREE)
-				continue;
+		/* first, apply the context, ... */
+		for (j = 0, slot = be16_to_cpu(b->context_start_slot_nr);
+		     j < AL_CONTEXT_PER_TRANSACTION &&
+		     slot < mdev->act_log->nr_elements; j++, slot++) {
+			extent_nr = be32_to_cpu(b->context[j]);
+			e = lc_element_by_index(mdev->act_log, slot);
+			if (e->lc_number != extent_nr) {
+				if (extent_nr != LC_FREE)
+					active_extents++;
+				else
+					active_extents--;
+			}
+			lc_set(mdev->act_log, extent_nr, slot);
+		}
 
-			lc_set(mdev->act_log, extent_nr, pos);
-			active_extents++;
+		/* ... then apply the updates,
+		 * which override the context information.
+		 * drbd_al_read_tr already did the rangecheck
+		 * on n <= AL_UPDATES_PER_TRANSACTION */
+		n = be16_to_cpu(b->n_updates);
+		for (j = 0; j < n; j++) {
+			slot = be16_to_cpu(b->update_slot_nr[j]);
+			extent_nr = be32_to_cpu(b->update_extent_nr[j]);
+			if (!expect(slot < mdev->act_log->nr_elements))
+				break;
+			e = lc_element_by_index(mdev->act_log, slot);
+			if (e->lc_number != extent_nr) {
+				if (extent_nr != LC_FREE)
+					active_extents++;
+				else
+					active_extents--;
+			}
+			lc_set(mdev->act_log, extent_nr, slot);
 		}
 		spin_unlock_irq(&mdev->al_lock);
 
@@ -514,15 +604,12 @@ cancel:
 		if (i == to)
 			break;
 		i++;
-		if (i > mx)
+		if (i >= mx)
 			i = 0;
 	}
 
 	mdev->al_tr_number = to_tnr+1;
-	mdev->al_tr_pos = to;
-	if (++mdev->al_tr_pos >
-	    div_ceil(mdev->act_log->nr_elements, AL_EXTENTS_PT))
-		mdev->al_tr_pos = 0;
+	mdev->al_tr_pos = (to + 1) % (MD_AL_SECTORS*512/MD_BLOCK_SIZE);
 
 	/* ok, we are done with it */
 	mutex_unlock(&mdev->md_io_mutex);
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index f125c0e..482bd7e 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1069,7 +1069,6 @@ struct drbd_conf {
 	atomic_t pp_in_use_by_net;	/* sendpage()d, still referenced by tcp */
 	wait_queue_head_t ee_wait;
 	struct page *md_io_page;	/* one page buffer for md_io */
-	struct page *md_io_tmpp;	/* for logical_block_size != 512 */
 	struct mutex md_io_mutex;	/* protects the md_io_buffer */
 	spinlock_t al_lock;
 	wait_queue_head_t al_wait;
@@ -1259,22 +1258,39 @@ extern void drbd_ldev_destroy(struct drbd_conf *mdev);
    * either at the end of the backing device
    * or on a separate meta data device. */
 
-#define MD_RESERVED_SECT (128LU << 11)  /* 128 MB, unit sectors */
 /* The following numbers are sectors */
-#define MD_AL_OFFSET 8	    /* 8 Sectors after start of meta area */
-#define MD_AL_MAX_SIZE 64   /* = 32 kb LOG  ~ 3776 extents ~ 14 GB Storage */
-/* Allows up to about 3.8TB */
-#define MD_BM_OFFSET (MD_AL_OFFSET + MD_AL_MAX_SIZE)
-
-/* Since the smalles IO unit is usually 512 byte */
-#define MD_SECTOR_SHIFT	 9
-#define MD_SECTOR_SIZE	 (1<<MD_SECTOR_SHIFT)
-
-/* activity log */
-#define AL_EXTENTS_PT ((MD_SECTOR_SIZE-12)/8-1) /* 61 ; Extents per 512B sector */
-#define AL_EXTENT_SHIFT 22		 /* One extent represents 4M Storage */
+/* Allows up to about 3.8TB, so if you want more,
+ * you need to use the "flexible" meta data format. */
+#define MD_RESERVED_SECT (128LU << 11)  /* 128 MB, unit sectors */
+#define MD_AL_OFFSET	8    /* 8 Sectors after start of meta area */
+#define MD_AL_SECTORS	64   /* = 32 kB on disk activity log ring buffer */
+#define MD_BM_OFFSET (MD_AL_OFFSET + MD_AL_SECTORS)
+
+/* we do all meta data IO in 4k blocks */
+#define MD_BLOCK_SHIFT	12
+#define MD_BLOCK_SIZE	(1<<MD_BLOCK_SHIFT)
+
+/* One activity log extent represents 4M of storage */
+#define AL_EXTENT_SHIFT 22
 #define AL_EXTENT_SIZE (1<<AL_EXTENT_SHIFT)
 
+/* We could make these currently hardcoded constants configurable
+ * variables at create-md time (or even re-configurable at runtime?).
+ * Which will require some more changes to the DRBD "super block"
+ * and attach code.
+ *
+ * updates per transaction:
+ *   This many changes to the active set can be logged with one transaction.
+ *   This number is arbitrary.
+ * context per transaction:
+ *   This many context extent numbers are logged with each transaction.
+ *   This number is resulting from the transaction block size (4k), the layout
+ *   of the transaction header, and the number of updates per transaction.
+ *   See drbd_actlog.c:struct al_transaction_on_disk
+ * */
+#define AL_UPDATES_PER_TRANSACTION	 64	// arbitrary
+#define AL_CONTEXT_PER_TRANSACTION	919	// (4096 - 36 - 6*64)/4
+
 #if BITS_PER_LONG == 32
 #define LN2_BPL 5
 #define cpu_to_lel(A) cpu_to_le32(A)
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 75b092b..47c4bae 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2842,10 +2842,6 @@ void drbd_ldev_destroy(struct drbd_conf *mdev)
 		drbd_free_bc(mdev->ldev);
 		mdev->ldev = NULL;);
 
-	if (mdev->md_io_tmpp) {
-		__free_page(mdev->md_io_tmpp);
-		mdev->md_io_tmpp = NULL;
-	}
 	clear_bit(GO_DISKLESS, &mdev->flags);
 }
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 0a92f52..90d7317 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -527,7 +527,7 @@ static void drbd_md_set_sector_offsets(struct drbd_conf *mdev,
 	case DRBD_MD_INDEX_FLEX_INT:
 		bdev->md.md_offset = drbd_md_ss__(mdev, bdev);
 		/* al size is still fixed */
-		bdev->md.al_offset = -MD_AL_MAX_SIZE;
+		bdev->md.al_offset = -MD_AL_SECTORS;
 		/* we need (slightly less than) ~ this much bitmap sectors: */
 		md_size_sect = drbd_get_capacity(bdev->backing_bdev);
 		md_size_sect = ALIGN(md_size_sect, BM_SECT_PER_EXT);
@@ -751,8 +751,8 @@ static int drbd_check_al_size(struct drbd_conf *mdev)
 	unsigned int in_use;
 	int i;
 
-	if (!expect(mdev->sync_conf.al_extents >= 7))
-		mdev->sync_conf.al_extents = 127;
+	if (!expect(mdev->sync_conf.al_extents >= DRBD_AL_EXTENTS_MIN))
+		mdev->sync_conf.al_extents = DRBD_AL_EXTENTS_MIN;
 
 	if (mdev->act_log &&
 	    mdev->act_log->nr_elements == mdev->sync_conf.al_extents)
@@ -760,7 +760,7 @@ static int drbd_check_al_size(struct drbd_conf *mdev)
 
 	in_use = 0;
 	t = mdev->act_log;
-	n = lc_create("act_log", drbd_al_ext_cache, 1,
+	n = lc_create("act_log", drbd_al_ext_cache, AL_UPDATES_PER_TRANSACTION,
 		mdev->sync_conf.al_extents, sizeof(struct lc_element), 0);
 
 	if (n == NULL) {
@@ -932,7 +932,6 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 	union drbd_state ns, os;
 	enum drbd_state_rv rv;
 	int cp_discovered = 0;
-	int logical_block_size;
 
 	drbd_reconfig_start(mdev);
 
@@ -1087,25 +1086,6 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 
 	drbd_md_set_sector_offsets(mdev, nbc);
 
-	/* allocate a second IO page if logical_block_size != 512 */
-	logical_block_size = bdev_logical_block_size(nbc->md_bdev);
-	if (logical_block_size == 0)
-		logical_block_size = MD_SECTOR_SIZE;
-
-	if (logical_block_size != MD_SECTOR_SIZE) {
-		if (!mdev->md_io_tmpp) {
-			struct page *page = alloc_page(GFP_NOIO);
-			if (!page)
-				goto force_diskless_dec;
-
-			dev_warn(DEV, "Meta data's bdev logical_block_size = %d != %d\n",
-			     logical_block_size, MD_SECTOR_SIZE);
-			dev_warn(DEV, "Workaround engaged (has performance impact).\n");
-
-			mdev->md_io_tmpp = page;
-		}
-	}
-
 	if (!mdev->bitmap) {
 		if (drbd_bm_init(mdev)) {
 			retcode = ERR_NOMEM;
@@ -1804,14 +1784,12 @@ static int drbd_nl_syncer_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *n
 
 	if (!expect(sc.rate >= 1))
 		sc.rate = 1;
-	if (!expect(sc.al_extents >= 7))
-		sc.al_extents = 127; /* arbitrary minimum */
-#define AL_MAX ((MD_AL_MAX_SIZE-1) * AL_EXTENTS_PT)
-	if (sc.al_extents > AL_MAX) {
-		dev_err(DEV, "sc.al_extents > %d\n", AL_MAX);
-		sc.al_extents = AL_MAX;
-	}
-#undef AL_MAX
+
+	/* clip to allowed range */
+	if (!expect(sc.al_extents >= DRBD_AL_EXTENTS_MIN))
+		sc.al_extents = DRBD_AL_EXTENTS_MIN;
+	if (!expect(sc.al_extents <= DRBD_AL_EXTENTS_MAX))
+		sc.al_extents = DRBD_AL_EXTENTS_MAX;
 
 	/* to avoid spurious errors when configuring minors before configuring
 	 * the minors they depend on: if necessary, first create the minor we
diff --git a/include/linux/drbd.h b/include/linux/drbd.h
index 35fc08a..70a688b 100644
--- a/include/linux/drbd.h
+++ b/include/linux/drbd.h
@@ -336,6 +336,10 @@ enum drbd_timeout_flag {
 #define DRBD_MAGIC 0x83740267
 #define DRBD_MAGIC_BIG 0x835a
 
+/* how I came up with this magic?
+ * base64 decode "actlog==" ;) */
+#define DRBD_AL_MAGIC 0x69cb65a2
+
 /* these are of type "int" */
 #define DRBD_MD_INDEX_INTERNAL -1
 #define DRBD_MD_INDEX_FLEX_EXT -2
diff --git a/include/linux/drbd_limits.h b/include/linux/drbd_limits.h
index 447c367..75f05af 100644
--- a/include/linux/drbd_limits.h
+++ b/include/linux/drbd_limits.h
@@ -102,10 +102,12 @@
 #define DRBD_RATE_DEF 250  /* kb/second */
 
   /* less than 7 would hit performance unnecessarily.
-   * 3833 is the largest prime that still does fit
-   * into 64 sectors of activity log */
+   * 919 slots context information per transaction,
+   * 32k activity log, 4k transaction size,
+   * one transaction in flight:
+   * 919 * 7 = 6433 */
 #define DRBD_AL_EXTENTS_MIN  7
-#define DRBD_AL_EXTENTS_MAX  3833
+#define DRBD_AL_EXTENTS_MAX  6433
 #define DRBD_AL_EXTENTS_DEF  127
 
 #define DRBD_AFTER_MIN  -1
-- 
1.7.4.1

