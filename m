Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab1I2ITQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 04:19:16 -0400
Received: from mail09.linbit.com ([212.69.161.110]:43416 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab1I2IPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 04:15:34 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 02/12] drbd: Make all asynchronous command handlers return 0 upon success and an error code otherwise
Date: Thu, 29 Sep 2011 10:15:21 +0200
Message-Id: <1317284131-17464-3-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_receiver.c |   69 +++++++++++++++++-------------------
 1 files changed, 33 insertions(+), 36 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index af9c2c0..cd2586b 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4506,7 +4506,7 @@ static int got_conn_RqSReply(struct drbd_tconn *tconn, struct packet_info *pi)
 	}
 	wake_up(&tconn->ping_wait);
 
-	return true;
+	return 0;
 }
 
 static int got_RqSReply(struct drbd_tconn *tconn, struct packet_info *pi)
@@ -4517,7 +4517,7 @@ static int got_RqSReply(struct drbd_tconn *tconn, struct packet_info *pi)
 
 	mdev = vnr_to_mdev(tconn, pi->vnr);
 	if (!mdev)
-		return false;
+		return -EIO;
 
 	if (retcode >= SS_SUCCESS) {
 		set_bit(CL_ST_CHG_SUCCESS, &mdev->flags);
@@ -4528,12 +4528,12 @@ static int got_RqSReply(struct drbd_tconn *tconn, struct packet_info *pi)
 	}
 	wake_up(&mdev->state_wait);
 
-	return true;
+	return 0;
 }
 
 static int got_Ping(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	return !drbd_send_ping_ack(tconn);
+	return drbd_send_ping_ack(tconn);
 
 }
 
@@ -4544,7 +4544,7 @@ static int got_PingAck(struct drbd_tconn *tconn, struct packet_info *pi)
 	if (!test_and_set_bit(GOT_PING_ACK, &tconn->flags))
 		wake_up(&tconn->ping_wait);
 
-	return true;
+	return 0;
 }
 
 static int got_IsInSync(struct drbd_tconn *tconn, struct packet_info *pi)
@@ -4556,7 +4556,7 @@ static int got_IsInSync(struct drbd_tconn *tconn, struct packet_info *pi)
 
 	mdev = vnr_to_mdev(tconn, pi->vnr);
 	if (!mdev)
-		return false;
+		return -EIO;
 
 	D_ASSERT(mdev->tconn->agreed_pro_version >= 89);
 
@@ -4572,7 +4572,7 @@ static int got_IsInSync(struct drbd_tconn *tconn, struct packet_info *pi)
 	dec_rs_pending(mdev);
 	atomic_add(blksize >> 9, &mdev->rs_sect_in);
 
-	return true;
+	return 0;
 }
 
 static int
@@ -4607,14 +4607,14 @@ static int got_BlockAck(struct drbd_tconn *tconn, struct packet_info *pi)
 
 	mdev = vnr_to_mdev(tconn, pi->vnr);
 	if (!mdev)
-		return false;
+		return -EIO;
 
 	update_peer_seq(mdev, be32_to_cpu(p->seq_num));
 
 	if (p->block_id == ID_SYNCER) {
 		drbd_set_in_sync(mdev, sector, blksize);
 		dec_rs_pending(mdev);
-		return true;
+		return 0;
 	}
 	switch (pi->cmd) {
 	case P_RS_WRITE_ACK:
@@ -4638,13 +4638,12 @@ static int got_BlockAck(struct drbd_tconn *tconn, struct packet_info *pi)
 		what = POSTPONE_WRITE;
 		break;
 	default:
-		D_ASSERT(0);
-		return false;
+		BUG();
 	}
 
-	return !validate_req_change_req_state(mdev, p->block_id, sector,
-					      &mdev->write_requests, __func__,
-					      what, false);
+	return validate_req_change_req_state(mdev, p->block_id, sector,
+					     &mdev->write_requests, __func__,
+					     what, false);
 }
 
 static int got_NegAck(struct drbd_tconn *tconn, struct packet_info *pi)
@@ -4659,14 +4658,14 @@ static int got_NegAck(struct drbd_tconn *tconn, struct packet_info *pi)
 
 	mdev = vnr_to_mdev(tconn, pi->vnr);
 	if (!mdev)
-		return false;
+		return -EIO;
 
 	update_peer_seq(mdev, be32_to_cpu(p->seq_num));
 
 	if (p->block_id == ID_SYNCER) {
 		dec_rs_pending(mdev);
 		drbd_rs_failed_io(mdev, sector, size);
-		return true;
+		return 0;
 	}
 
 	err = validate_req_change_req_state(mdev, p->block_id, sector,
@@ -4679,10 +4678,10 @@ static int got_NegAck(struct drbd_tconn *tconn, struct packet_info *pi)
 		/* In Protocol B we might already have got a P_RECV_ACK
 		   but then get a P_NEG_ACK afterwards. */
 		if (!missing_ok)
-			return false;
+			return err;
 		drbd_set_out_of_sync(mdev, sector, size);
 	}
-	return true;
+	return 0;
 }
 
 static int got_NegDReply(struct drbd_tconn *tconn, struct packet_info *pi)
@@ -4693,16 +4692,16 @@ static int got_NegDReply(struct drbd_tconn *tconn, struct packet_info *pi)
 
 	mdev = vnr_to_mdev(tconn, pi->vnr);
 	if (!mdev)
-		return false;
+		return -EIO;
 
 	update_peer_seq(mdev, be32_to_cpu(p->seq_num));
 
 	dev_err(DEV, "Got NegDReply; Sector %llus, len %u; Fail original request.\n",
 	    (unsigned long long)sector, be32_to_cpu(p->blksize));
 
-	return !validate_req_change_req_state(mdev, p->block_id, sector,
-					      &mdev->read_requests, __func__,
-					      NEG_ACKED, false);
+	return validate_req_change_req_state(mdev, p->block_id, sector,
+					     &mdev->read_requests, __func__,
+					     NEG_ACKED, false);
 }
 
 static int got_NegRSDReply(struct drbd_tconn *tconn, struct packet_info *pi)
@@ -4714,7 +4713,7 @@ static int got_NegRSDReply(struct drbd_tconn *tconn, struct packet_info *pi)
 
 	mdev = vnr_to_mdev(tconn, pi->vnr);
 	if (!mdev)
-		return false;
+		return -EIO;
 
 	sector = be64_to_cpu(p->sector);
 	size = be32_to_cpu(p->blksize);
@@ -4731,14 +4730,12 @@ static int got_NegRSDReply(struct drbd_tconn *tconn, struct packet_info *pi)
 		case P_RS_CANCEL:
 			break;
 		default:
-			D_ASSERT(0);
-			put_ldev(mdev);
-			return false;
+			BUG();
 		}
 		put_ldev(mdev);
 	}
 
-	return true;
+	return 0;
 }
 
 static int got_BarrierAck(struct drbd_tconn *tconn, struct packet_info *pi)
@@ -4748,7 +4745,7 @@ static int got_BarrierAck(struct drbd_tconn *tconn, struct packet_info *pi)
 
 	mdev = vnr_to_mdev(tconn, pi->vnr);
 	if (!mdev)
-		return false;
+		return -EIO;
 
 	tl_release(mdev->tconn, p->barrier, be32_to_cpu(p->set_size));
 
@@ -4759,7 +4756,7 @@ static int got_BarrierAck(struct drbd_tconn *tconn, struct packet_info *pi)
 		add_timer(&mdev->start_resync_timer);
 	}
 
-	return true;
+	return 0;
 }
 
 static int got_OVResult(struct drbd_tconn *tconn, struct packet_info *pi)
@@ -4772,7 +4769,7 @@ static int got_OVResult(struct drbd_tconn *tconn, struct packet_info *pi)
 
 	mdev = vnr_to_mdev(tconn, pi->vnr);
 	if (!mdev)
-		return false;
+		return -EIO;
 
 	sector = be64_to_cpu(p->sector);
 	size = be32_to_cpu(p->blksize);
@@ -4785,7 +4782,7 @@ static int got_OVResult(struct drbd_tconn *tconn, struct packet_info *pi)
 		ov_out_of_sync_print(mdev);
 
 	if (!get_ldev(mdev))
-		return true;
+		return 0;
 
 	drbd_rs_complete_io(mdev, sector);
 	dec_rs_pending(mdev);
@@ -4809,12 +4806,12 @@ static int got_OVResult(struct drbd_tconn *tconn, struct packet_info *pi)
 		}
 	}
 	put_ldev(mdev);
-	return true;
+	return 0;
 }
 
 static int got_skip(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	return true;
+	return 0;
 }
 
 static int tconn_process_done_ee(struct drbd_tconn *tconn)
@@ -4968,10 +4965,10 @@ int drbd_asender(struct drbd_thread *thi)
 			}
 		}
 		if (received == expect) {
-			bool rv;
+			bool err;
 
-			rv = cmd->fn(tconn, &pi);
-			if (!rv) {
+			err = cmd->fn(tconn, &pi);
+			if (err) {
 				conn_err(tconn, "%pf failed\n", cmd->fn);
 				goto reconnect;
 			}
-- 
1.7.4.1

