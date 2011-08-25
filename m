Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab1HYPhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:37:36 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32967 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab1HYPJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:02 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 011/118] drbd: Request lookup code cleanup (3)
Date: Thu, 25 Aug 2011 17:07:07 +0200
Message-Id: <1314284934-17999-12-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Get rid of the ar_id_to_req() and ack_id_to_req() wrappers.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   28 ++++++----------------------
 1 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index ae32aed..84c8d94 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1494,14 +1494,6 @@ find_request(struct drbd_conf *mdev,
 	return NULL;
 }
 
-/* when we receive the answer for a read request,
- * verify that we actually know about it */
-static struct drbd_request *ar_id_to_req(struct drbd_conf *mdev, u64 id,
-					 sector_t sector)
-{
-	return find_request(mdev, ar_hash_slot, id, sector, __func__);
-}
-
 static int receive_DataReply(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned int data_size)
 {
 	struct drbd_request *req;
@@ -1512,7 +1504,7 @@ static int receive_DataReply(struct drbd_conf *mdev, enum drbd_packets cmd, unsi
 	sector = be64_to_cpu(p->sector);
 
 	spin_lock_irq(&mdev->req_lock);
-	req = ar_id_to_req(mdev, p->block_id, sector);
+	req = find_request(mdev, ar_hash_slot, p->block_id, sector, __func__);
 	spin_unlock_irq(&mdev->req_lock);
 	if (unlikely(!req)) {
 		dev_err(DEV, "Got a corrupt block_id/sector pair(1).\n");
@@ -4253,24 +4245,16 @@ static int got_IsInSync(struct drbd_conf *mdev, struct p_header80 *h)
 	return true;
 }
 
-/* when we receive the ACK for a write request,
- * verify that we actually know about it */
-static struct drbd_request *ack_id_to_req(struct drbd_conf *mdev, u64 id,
-					  sector_t sector)
-{
-	return find_request(mdev, tl_hash_slot, id, sector, __func__);
-}
-
 static int validate_req_change_req_state(struct drbd_conf *mdev,
 	u64 id, sector_t sector,
-	struct drbd_request *(*validator)(struct drbd_conf *, u64, sector_t),
+	struct hlist_head *(*hash_slot)(struct drbd_conf *, sector_t),
 	const char *func, enum drbd_req_event what)
 {
 	struct drbd_request *req;
 	struct bio_and_error m;
 
 	spin_lock_irq(&mdev->req_lock);
-	req = validator(mdev, id, sector);
+	req = find_request(mdev, hash_slot, id, sector, func);
 	if (unlikely(!req)) {
 		spin_unlock_irq(&mdev->req_lock);
 
@@ -4323,7 +4307,7 @@ static int got_BlockAck(struct drbd_conf *mdev, struct p_header80 *h)
 	}
 
 	return validate_req_change_req_state(mdev, p->block_id, sector,
-					     ack_id_to_req, __func__, what);
+					     tl_hash_slot, __func__, what);
 }
 
 static int got_NegAck(struct drbd_conf *mdev, struct p_header80 *h)
@@ -4343,7 +4327,7 @@ static int got_NegAck(struct drbd_conf *mdev, struct p_header80 *h)
 	}
 
 	spin_lock_irq(&mdev->req_lock);
-	req = ack_id_to_req(mdev, p->block_id, sector);
+	req = find_request(mdev, tl_hash_slot, p->block_id, sector, __func__);
 	if (!req) {
 		spin_unlock_irq(&mdev->req_lock);
 		if (mdev->net_conf->wire_protocol == DRBD_PROT_A ||
@@ -4380,7 +4364,7 @@ static int got_NegDReply(struct drbd_conf *mdev, struct p_header80 *h)
 	    (unsigned long long)sector, be32_to_cpu(p->blksize));
 
 	return validate_req_change_req_state(mdev, p->block_id, sector,
-					     ar_id_to_req, __func__ , neg_acked);
+					     ar_hash_slot, __func__, neg_acked);
 }
 
 static int got_NegRSDReply(struct drbd_conf *mdev, struct p_header80 *h)
-- 
1.7.4.1

