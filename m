Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab1I2IPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 04:15:36 -0400
Received: from mail09.linbit.com ([212.69.161.110]:43415 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab1I2IPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 04:15:33 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 01/12] drbd: validate_req_change_req_state(): Return 0 upon success and an error code otherwise
Date: Thu, 29 Sep 2011 10:15:20 +0200
Message-Id: <1317284131-17464-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317284131-17464-1-git-send-email-philipp.reisner@linbit.com>
References: <1317284131-17464-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 7539253..af9c2c0 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4587,14 +4587,14 @@ validate_req_change_req_state(struct drbd_conf *mdev, u64 id, sector_t sector,
 	req = find_request(mdev, root, id, sector, missing_ok, func);
 	if (unlikely(!req)) {
 		spin_unlock_irq(&mdev->tconn->req_lock);
-		return false;
+		return -EIO;
 	}
 	__req_mod(req, what, &m);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	if (m.bio)
 		complete_master_bio(mdev, &m);
-	return true;
+	return 0;
 }
 
 static int got_BlockAck(struct drbd_tconn *tconn, struct packet_info *pi)
@@ -4642,9 +4642,9 @@ static int got_BlockAck(struct drbd_tconn *tconn, struct packet_info *pi)
 		return false;
 	}
 
-	return validate_req_change_req_state(mdev, p->block_id, sector,
-					     &mdev->write_requests, __func__,
-					     what, false);
+	return !validate_req_change_req_state(mdev, p->block_id, sector,
+					      &mdev->write_requests, __func__,
+					      what, false);
 }
 
 static int got_NegAck(struct drbd_tconn *tconn, struct packet_info *pi)
@@ -4655,7 +4655,7 @@ static int got_NegAck(struct drbd_tconn *tconn, struct packet_info *pi)
 	int size = be32_to_cpu(p->blksize);
 	bool missing_ok = tconn->net_conf->wire_protocol == DRBD_PROT_A ||
 			  tconn->net_conf->wire_protocol == DRBD_PROT_B;
-	bool found;
+	int err;
 
 	mdev = vnr_to_mdev(tconn, pi->vnr);
 	if (!mdev)
@@ -4669,10 +4669,10 @@ static int got_NegAck(struct drbd_tconn *tconn, struct packet_info *pi)
 		return true;
 	}
 
-	found = validate_req_change_req_state(mdev, p->block_id, sector,
-					      &mdev->write_requests, __func__,
-					      NEG_ACKED, missing_ok);
-	if (!found) {
+	err = validate_req_change_req_state(mdev, p->block_id, sector,
+					    &mdev->write_requests, __func__,
+					    NEG_ACKED, missing_ok);
+	if (err) {
 		/* Protocol A has no P_WRITE_ACKs, but has P_NEG_ACKs.
 		   The master bio might already be completed, therefore the
 		   request is no longer in the collision hash. */
@@ -4700,9 +4700,9 @@ static int got_NegDReply(struct drbd_tconn *tconn, struct packet_info *pi)
 	dev_err(DEV, "Got NegDReply; Sector %llus, len %u; Fail original request.\n",
 	    (unsigned long long)sector, be32_to_cpu(p->blksize));
 
-	return validate_req_change_req_state(mdev, p->block_id, sector,
-					     &mdev->read_requests, __func__,
-					     NEG_ACKED, false);
+	return !validate_req_change_req_state(mdev, p->block_id, sector,
+					      &mdev->read_requests, __func__,
+					      NEG_ACKED, false);
 }
 
 static int got_NegRSDReply(struct drbd_tconn *tconn, struct packet_info *pi)
-- 
1.7.4.1

