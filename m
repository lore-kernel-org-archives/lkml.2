Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab1HYPhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:37:34 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32976 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab1HYPJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:02 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 012/118] drbd: Request lookup code cleanup (4)
Date: Thu, 25 Aug 2011 17:07:08 +0200
Message-Id: <1314284934-17999-13-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Factor out duplicate code in got_NegAck().

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   66 +++++++++++++++--------------------
 1 files changed, 28 insertions(+), 38 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 84c8d94..8e7875e 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1472,7 +1472,7 @@ fail:
 static struct drbd_request *
 find_request(struct drbd_conf *mdev,
 	     struct hlist_head *(*hash_slot)(struct drbd_conf *, sector_t),
-	     u64 id, sector_t sector, const char *func)
+	     u64 id, sector_t sector, bool missing_ok, const char *func)
 {
 	struct hlist_head *slot = hash_slot(mdev, sector);
 	struct hlist_node *n;
@@ -1487,10 +1487,14 @@ find_request(struct drbd_conf *mdev,
 				func, (unsigned long)req,
 				(unsigned long long)req->sector,
 				(unsigned long long)sector);
-			break;
+			return NULL;
 		}
 		return req;
 	}
+	if (!missing_ok) {
+		dev_err(DEV, "%s: failed to find request %lu, sector %llus\n", func,
+			(unsigned long)id, (unsigned long long)sector);
+	}
 	return NULL;
 }
 
@@ -1504,12 +1508,10 @@ static int receive_DataReply(struct drbd_conf *mdev, enum drbd_packets cmd, unsi
 	sector = be64_to_cpu(p->sector);
 
 	spin_lock_irq(&mdev->req_lock);
-	req = find_request(mdev, ar_hash_slot, p->block_id, sector, __func__);
+	req = find_request(mdev, ar_hash_slot, p->block_id, sector, false, __func__);
 	spin_unlock_irq(&mdev->req_lock);
-	if (unlikely(!req)) {
-		dev_err(DEV, "Got a corrupt block_id/sector pair(1).\n");
+	if (unlikely(!req))
 		return false;
-	}
 
 	/* hlist_del(&req->collision) is done in _req_may_be_done, to avoid
 	 * special casing it there for the various failure cases.
@@ -4248,18 +4250,15 @@ static int got_IsInSync(struct drbd_conf *mdev, struct p_header80 *h)
 static int validate_req_change_req_state(struct drbd_conf *mdev,
 	u64 id, sector_t sector,
 	struct hlist_head *(*hash_slot)(struct drbd_conf *, sector_t),
-	const char *func, enum drbd_req_event what)
+	const char *func, enum drbd_req_event what, bool missing_ok)
 {
 	struct drbd_request *req;
 	struct bio_and_error m;
 
 	spin_lock_irq(&mdev->req_lock);
-	req = find_request(mdev, hash_slot, id, sector, func);
+	req = find_request(mdev, hash_slot, id, sector, missing_ok, func);
 	if (unlikely(!req)) {
 		spin_unlock_irq(&mdev->req_lock);
-
-		dev_err(DEV, "%s: failed to find req %p, sector %llus\n", func,
-			(void *)(unsigned long)id, (unsigned long long)sector);
 		return false;
 	}
 	__req_mod(req, what, &m);
@@ -4307,7 +4306,8 @@ static int got_BlockAck(struct drbd_conf *mdev, struct p_header80 *h)
 	}
 
 	return validate_req_change_req_state(mdev, p->block_id, sector,
-					     tl_hash_slot, __func__, what);
+					     tl_hash_slot, __func__, what,
+					     false);
 }
 
 static int got_NegAck(struct drbd_conf *mdev, struct p_header80 *h)
@@ -4315,8 +4315,9 @@ static int got_NegAck(struct drbd_conf *mdev, struct p_header80 *h)
 	struct p_block_ack *p = (struct p_block_ack *)h;
 	sector_t sector = be64_to_cpu(p->sector);
 	int size = be32_to_cpu(p->blksize);
-	struct drbd_request *req;
-	struct bio_and_error m;
+	bool missing_ok = mdev->net_conf->wire_protocol == DRBD_PROT_A ||
+			  mdev->net_conf->wire_protocol == DRBD_PROT_B;
+	bool found;
 
 	update_peer_seq(mdev, be32_to_cpu(p->seq_num));
 
@@ -4326,31 +4327,19 @@ static int got_NegAck(struct drbd_conf *mdev, struct p_header80 *h)
 		return true;
 	}
 
-	spin_lock_irq(&mdev->req_lock);
-	req = find_request(mdev, tl_hash_slot, p->block_id, sector, __func__);
-	if (!req) {
-		spin_unlock_irq(&mdev->req_lock);
-		if (mdev->net_conf->wire_protocol == DRBD_PROT_A ||
-		    mdev->net_conf->wire_protocol == DRBD_PROT_B) {
-			/* Protocol A has no P_WRITE_ACKs, but has P_NEG_ACKs.
-			   The master bio might already be completed, therefore the
-			   request is no longer in the collision hash.
-			   => Do not try to validate block_id as request. */
-			/* In Protocol B we might already have got a P_RECV_ACK
-			   but then get a P_NEG_ACK after wards. */
-			drbd_set_out_of_sync(mdev, sector, size);
-			return true;
-		} else {
-			dev_err(DEV, "%s: failed to find req %p, sector %llus\n", __func__,
-				(void *)(unsigned long)p->block_id, (unsigned long long)sector);
+	found = validate_req_change_req_state(mdev, p->block_id, sector,
+					      tl_hash_slot, __func__,
+					      neg_acked, missing_ok);
+	if (!found) {
+		/* Protocol A has no P_WRITE_ACKs, but has P_NEG_ACKs.
+		   The master bio might already be completed, therefore the
+		   request is no longer in the collision hash. */
+		/* In Protocol B we might already have got a P_RECV_ACK
+		   but then get a P_NEG_ACK afterwards. */
+		if (!missing_ok)
 			return false;
-		}
+		drbd_set_out_of_sync(mdev, sector, size);
 	}
-	__req_mod(req, neg_acked, &m);
-	spin_unlock_irq(&mdev->req_lock);
-
-	if (m.bio)
-		complete_master_bio(mdev, &m);
 	return true;
 }
 
@@ -4364,7 +4353,8 @@ static int got_NegDReply(struct drbd_conf *mdev, struct p_header80 *h)
 	    (unsigned long long)sector, be32_to_cpu(p->blksize));
 
 	return validate_req_change_req_state(mdev, p->block_id, sector,
-					     ar_hash_slot, __func__, neg_acked);
+					     ar_hash_slot, __func__, neg_acked,
+					     false);
 }
 
 static int got_NegRSDReply(struct drbd_conf *mdev, struct p_header80 *h)
-- 
1.7.4.1

