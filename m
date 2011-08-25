Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab1HYPiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:38:21 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32953 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab1HYPJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:01 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 006/118] drbd: Magic reserved block_id value cleanup
Date: Thu, 25 Aug 2011 17:07:02 +0200
Message-Id: <1314284934-17999-7-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

The ID_VACANT definition has become entirely irrelevant by now.

The is_syncer_block_id() macro does not improve the code, so eliminated
it.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    9 +--------
 drivers/block/drbd/drbd_receiver.c |    4 ++--
 drivers/block/drbd/drbd_worker.c   |   14 ++++----------
 3 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 88b247e..c1d1755 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -87,17 +87,10 @@ extern char usermode_helper[];
  */
 #define DRBD_SIGKILL SIGHUP
 
-/* All EEs on the free list should have ID_VACANT (== 0)
- * freshly allocated EEs get !ID_VACANT (== 1)
- * so if it says "cannot dereference null pointer at address 0x00000001",
- * it is most likely one of these :( */
-
 #define ID_IN_SYNC      (4711ULL)
 #define ID_OUT_OF_SYNC  (4712ULL)
-
 #define ID_SYNCER (-1ULL)
-#define ID_VACANT 0
-#define is_syncer_block_id(id) ((id) == ID_SYNCER)
+
 #define UUID_NEW_BM_OFFSET ((u64)0x0001000000000000ULL)
 
 struct drbd_conf;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 69eec69..efe141e 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4308,7 +4308,7 @@ static int got_BlockAck(struct drbd_conf *mdev, struct p_header80 *h)
 
 	update_peer_seq(mdev, be32_to_cpu(p->seq_num));
 
-	if (is_syncer_block_id(p->block_id)) {
+	if (p->block_id == ID_SYNCER) {
 		drbd_set_in_sync(mdev, sector, blksize);
 		dec_rs_pending(mdev);
 		return true;
@@ -4349,7 +4349,7 @@ static int got_NegAck(struct drbd_conf *mdev, struct p_header80 *h)
 
 	update_peer_seq(mdev, be32_to_cpu(p->seq_num));
 
-	if (is_syncer_block_id(p->block_id)) {
+	if (p->block_id == ID_SYNCER) {
 		dec_rs_pending(mdev);
 		drbd_rs_failed_io(mdev, sector, size);
 		return true;
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 10438c4..43a9fef 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -85,8 +85,6 @@ void drbd_endio_read_sec_final(struct drbd_epoch_entry *e) __releases(local)
 	unsigned long flags = 0;
 	struct drbd_conf *mdev = e->mdev;
 
-	D_ASSERT(e->block_id != ID_VACANT);
-
 	spin_lock_irqsave(&mdev->req_lock, flags);
 	mdev->read_cnt += e->size >> 9;
 	list_del(&e->w.list);
@@ -108,18 +106,16 @@ static void drbd_endio_write_sec_final(struct drbd_epoch_entry *e) __releases(lo
 	struct drbd_conf *mdev = e->mdev;
 	sector_t e_sector;
 	int do_wake;
-	int is_syncer_req;
+	u64 block_id;
 	int do_al_complete_io;
 
-	D_ASSERT(e->block_id != ID_VACANT);
-
 	/* after we moved e to done_ee,
 	 * we may no longer access it,
 	 * it may be freed/reused already!
 	 * (as soon as we release the req_lock) */
 	e_sector = e->sector;
 	do_al_complete_io = e->flags & EE_CALL_AL_COMPLETE_IO;
-	is_syncer_req = is_syncer_block_id(e->block_id);
+	block_id = e->block_id;
 
 	spin_lock_irqsave(&mdev->req_lock, flags);
 	mdev->writ_cnt += e->size >> 9;
@@ -131,15 +127,13 @@ static void drbd_endio_write_sec_final(struct drbd_epoch_entry *e) __releases(lo
 	 * done from "drbd_process_done_ee" within the appropriate w.cb
 	 * (e_end_block/e_end_resync_block) or from _drbd_clear_done_ee */
 
-	do_wake = is_syncer_req
-		? list_empty(&mdev->sync_ee)
-		: list_empty(&mdev->active_ee);
+	do_wake = list_empty(block_id == ID_SYNCER ? &mdev->sync_ee : &mdev->active_ee);
 
 	if (test_bit(__EE_WAS_ERROR, &e->flags))
 		__drbd_chk_io_error(mdev, false);
 	spin_unlock_irqrestore(&mdev->req_lock, flags);
 
-	if (is_syncer_req)
+	if (block_id == ID_SYNCER)
 		drbd_rs_complete_io(mdev, e_sector);
 
 	if (do_wake)
-- 
1.7.4.1

