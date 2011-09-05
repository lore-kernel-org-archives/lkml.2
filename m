Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab1IELti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:49:38 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60226 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab1IELp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:45:59 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 22/54] drbd: drbd_send_ack(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:45:13 +0200
Message-Id: <1315223145-20640-23-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
References: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c     |    8 ++++----
 drivers/block/drbd/drbd_receiver.c |   10 +++++-----
 drivers/block/drbd/drbd_worker.c   |   10 +++++-----
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 2718327..6d40647 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1288,10 +1288,10 @@ int drbd_send_ack_rp(struct drbd_conf *mdev, enum drbd_packet cmd,
 int drbd_send_ack(struct drbd_conf *mdev, enum drbd_packet cmd,
 		  struct drbd_peer_request *peer_req)
 {
-	return !_drbd_send_ack(mdev, cmd,
-			       cpu_to_be64(peer_req->i.sector),
-			       cpu_to_be32(peer_req->i.size),
-			       peer_req->block_id);
+	return _drbd_send_ack(mdev, cmd,
+			      cpu_to_be64(peer_req->i.sector),
+			      cpu_to_be32(peer_req->i.size),
+			      peer_req->block_id);
 }
 
 /* This function misuses the block_id field to signal if the blocks
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index b1d8f91..572d9cc 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1476,12 +1476,12 @@ static int e_end_resync_block(struct drbd_work *w, int unused)
 
 	if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
 		drbd_set_in_sync(mdev, sector, peer_req->i.size);
-		ok = drbd_send_ack(mdev, P_RS_WRITE_ACK, peer_req);
+		ok = !drbd_send_ack(mdev, P_RS_WRITE_ACK, peer_req);
 	} else {
 		/* Record failure to sync */
 		drbd_rs_failed_io(mdev, sector, peer_req->i.size);
 
-		ok  = drbd_send_ack(mdev, P_NEG_ACK, peer_req);
+		ok  = !drbd_send_ack(mdev, P_NEG_ACK, peer_req);
 	}
 	dec_unacked(mdev);
 
@@ -1662,11 +1662,11 @@ static int e_end_block(struct drbd_work *w, int cancel)
 				mdev->state.conn <= C_PAUSED_SYNC_T &&
 				peer_req->flags & EE_MAY_SET_IN_SYNC) ?
 				P_RS_WRITE_ACK : P_WRITE_ACK;
-			ok &= drbd_send_ack(mdev, pcmd, peer_req);
+			ok &= !drbd_send_ack(mdev, pcmd, peer_req);
 			if (pcmd == P_RS_WRITE_ACK)
 				drbd_set_in_sync(mdev, sector, peer_req->i.size);
 		} else {
-			ok  = drbd_send_ack(mdev, P_NEG_ACK, peer_req);
+			ok  = !drbd_send_ack(mdev, P_NEG_ACK, peer_req);
 			/* we expect it to be marked out of sync anyways...
 			 * maybe assert this?  */
 		}
@@ -1696,7 +1696,7 @@ static int e_send_ack(struct drbd_work *w, enum drbd_packet ack)
 		container_of(w, struct drbd_peer_request, w);
 	int ok;
 
-	ok = drbd_send_ack(mdev, ack, peer_req);
+	ok = !drbd_send_ack(mdev, ack, peer_req);
 	dec_unacked(mdev);
 
 	return ok;
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index d726309..69db6de 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -926,7 +926,7 @@ int w_e_end_data_req(struct drbd_work *w, int cancel)
 			dev_err(DEV, "Sending NegDReply. sector=%llus.\n",
 			    (unsigned long long)peer_req->i.sector);
 
-		ok = drbd_send_ack(mdev, P_NEG_DREPLY, peer_req);
+		ok = !drbd_send_ack(mdev, P_NEG_DREPLY, peer_req);
 	}
 
 	dec_unacked(mdev);
@@ -962,7 +962,7 @@ int w_e_end_rsdata_req(struct drbd_work *w, int cancel)
 	}
 
 	if (mdev->state.conn == C_AHEAD) {
-		ok = drbd_send_ack(mdev, P_RS_CANCEL, peer_req);
+		ok = !drbd_send_ack(mdev, P_RS_CANCEL, peer_req);
 	} else if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
 		if (likely(mdev->state.pdsk >= D_INCONSISTENT)) {
 			inc_rs_pending(mdev);
@@ -978,7 +978,7 @@ int w_e_end_rsdata_req(struct drbd_work *w, int cancel)
 			dev_err(DEV, "Sending NegRSDReply. sector %llus.\n",
 			    (unsigned long long)peer_req->i.sector);
 
-		ok = drbd_send_ack(mdev, P_NEG_RS_DREPLY, peer_req);
+		ok = !drbd_send_ack(mdev, P_NEG_RS_DREPLY, peer_req);
 
 		/* update resync data with failure */
 		drbd_rs_failed_io(mdev, peer_req->i.sector, peer_req->i.size);
@@ -1034,7 +1034,7 @@ int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 			drbd_set_in_sync(mdev, peer_req->i.sector, peer_req->i.size);
 			/* rs_same_csums unit is BM_BLOCK_SIZE */
 			mdev->rs_same_csum += peer_req->i.size >> BM_BLOCK_SHIFT;
-			ok = drbd_send_ack(mdev, P_RS_IS_IN_SYNC, peer_req);
+			ok = !drbd_send_ack(mdev, P_RS_IS_IN_SYNC, peer_req);
 		} else {
 			inc_rs_pending(mdev);
 			peer_req->block_id = ID_SYNCER; /* By setting block_id, digest pointer becomes invalid! */
@@ -1043,7 +1043,7 @@ int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 			ok = drbd_send_block(mdev, P_RS_DATA_REPLY, peer_req);
 		}
 	} else {
-		ok = drbd_send_ack(mdev, P_NEG_RS_DREPLY, peer_req);
+		ok = !drbd_send_ack(mdev, P_NEG_RS_DREPLY, peer_req);
 		if (__ratelimit(&drbd_ratelimit_state))
 			dev_err(DEV, "Sending NegDReply. I guess it gets messy.\n");
 	}
-- 
1.7.4.1

