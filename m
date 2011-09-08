Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab1IHMpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:45:44 -0400
Received: from mail09.linbit.com ([212.69.161.110]:37555 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932682Ab1IHMpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:45:42 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 07/16] drbd: Map from (connection, volume number) to device in the asender handlers
Date: Thu,  8 Sep 2011 14:45:28 +0200
Message-Id: <1315485937-18989-8-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315485937-18989-1-git-send-email-philipp.reisner@linbit.com>
References: <1315485937-18989-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |  137 +++++++++++++++++++++--------------
 1 files changed, 82 insertions(+), 55 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 5e464a7..cc236d7 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -60,11 +60,6 @@ enum finish_epoch {
 	FE_RECYCLED,
 };
 
-enum mdev_or_conn {
-	MDEV,
-	CONN,
-};
-
 static int drbd_do_handshake(struct drbd_tconn *tconn);
 static int drbd_do_auth(struct drbd_tconn *tconn);
 static int drbd_disconnected(int vnr, void *p, void *data);
@@ -4479,11 +4474,16 @@ static int got_conn_RqSReply(struct drbd_tconn *tconn, struct packet_info *pi)
 	return true;
 }
 
-static int got_RqSReply(struct drbd_conf *mdev, struct packet_info *pi)
+static int got_RqSReply(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct p_req_state_reply *p = mdev->tconn->meta.rbuf;
+	struct drbd_conf *mdev;
+	struct p_req_state_reply *p = tconn->meta.rbuf;
 	int retcode = be32_to_cpu(p->retcode);
 
+	mdev = vnr_to_mdev(tconn, pi->vnr);
+	if (!mdev)
+		return false;
+
 	if (retcode >= SS_SUCCESS) {
 		set_bit(CL_ST_CHG_SUCCESS, &mdev->flags);
 	} else {
@@ -4512,12 +4512,17 @@ static int got_PingAck(struct drbd_tconn *tconn, struct packet_info *pi)
 	return true;
 }
 
-static int got_IsInSync(struct drbd_conf *mdev, struct packet_info *pi)
+static int got_IsInSync(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct p_block_ack *p = mdev->tconn->meta.rbuf;
+	struct drbd_conf *mdev;
+	struct p_block_ack *p = tconn->meta.rbuf;
 	sector_t sector = be64_to_cpu(p->sector);
 	int blksize = be32_to_cpu(p->blksize);
 
+	mdev = vnr_to_mdev(tconn, pi->vnr);
+	if (!mdev)
+		return false;
+
 	D_ASSERT(mdev->tconn->agreed_pro_version >= 89);
 
 	update_peer_seq(mdev, be32_to_cpu(p->seq_num));
@@ -4557,13 +4562,18 @@ validate_req_change_req_state(struct drbd_conf *mdev, u64 id, sector_t sector,
 	return true;
 }
 
-static int got_BlockAck(struct drbd_conf *mdev, struct packet_info *pi)
+static int got_BlockAck(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct p_block_ack *p = mdev->tconn->meta.rbuf;
+	struct drbd_conf *mdev;
+	struct p_block_ack *p = tconn->meta.rbuf;
 	sector_t sector = be64_to_cpu(p->sector);
 	int blksize = be32_to_cpu(p->blksize);
 	enum drbd_req_event what;
 
+	mdev = vnr_to_mdev(tconn, pi->vnr);
+	if (!mdev)
+		return false;
+
 	update_peer_seq(mdev, be32_to_cpu(p->seq_num));
 
 	if (p->block_id == ID_SYNCER) {
@@ -4602,15 +4612,20 @@ static int got_BlockAck(struct drbd_conf *mdev, struct packet_info *pi)
 					     what, false);
 }
 
-static int got_NegAck(struct drbd_conf *mdev, struct packet_info *pi)
+static int got_NegAck(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct p_block_ack *p = mdev->tconn->meta.rbuf;
+	struct drbd_conf *mdev;
+	struct p_block_ack *p = tconn->meta.rbuf;
 	sector_t sector = be64_to_cpu(p->sector);
 	int size = be32_to_cpu(p->blksize);
-	bool missing_ok = mdev->tconn->net_conf->wire_protocol == DRBD_PROT_A ||
-			  mdev->tconn->net_conf->wire_protocol == DRBD_PROT_B;
+	bool missing_ok = tconn->net_conf->wire_protocol == DRBD_PROT_A ||
+			  tconn->net_conf->wire_protocol == DRBD_PROT_B;
 	bool found;
 
+	mdev = vnr_to_mdev(tconn, pi->vnr);
+	if (!mdev)
+		return false;
+
 	update_peer_seq(mdev, be32_to_cpu(p->seq_num));
 
 	if (p->block_id == ID_SYNCER) {
@@ -4635,11 +4650,16 @@ static int got_NegAck(struct drbd_conf *mdev, struct packet_info *pi)
 	return true;
 }
 
-static int got_NegDReply(struct drbd_conf *mdev, struct packet_info *pi)
+static int got_NegDReply(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct p_block_ack *p = mdev->tconn->meta.rbuf;
+	struct drbd_conf *mdev;
+	struct p_block_ack *p = tconn->meta.rbuf;
 	sector_t sector = be64_to_cpu(p->sector);
 
+	mdev = vnr_to_mdev(tconn, pi->vnr);
+	if (!mdev)
+		return false;
+
 	update_peer_seq(mdev, be32_to_cpu(p->seq_num));
 
 	dev_err(DEV, "Got NegDReply; Sector %llus, len %u; Fail original request.\n",
@@ -4650,11 +4670,16 @@ static int got_NegDReply(struct drbd_conf *mdev, struct packet_info *pi)
 					     NEG_ACKED, false);
 }
 
-static int got_NegRSDReply(struct drbd_conf *mdev, struct packet_info *pi)
+static int got_NegRSDReply(struct drbd_tconn *tconn, struct packet_info *pi)
 {
+	struct drbd_conf *mdev;
 	sector_t sector;
 	int size;
-	struct p_block_ack *p = mdev->tconn->meta.rbuf;
+	struct p_block_ack *p = tconn->meta.rbuf;
+
+	mdev = vnr_to_mdev(tconn, pi->vnr);
+	if (!mdev)
+		return false;
 
 	sector = be64_to_cpu(p->sector);
 	size = be32_to_cpu(p->blksize);
@@ -4681,9 +4706,14 @@ static int got_NegRSDReply(struct drbd_conf *mdev, struct packet_info *pi)
 	return true;
 }
 
-static int got_BarrierAck(struct drbd_conf *mdev, struct packet_info *pi)
+static int got_BarrierAck(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct p_barrier_ack *p = mdev->tconn->meta.rbuf;
+	struct drbd_conf *mdev;
+	struct p_barrier_ack *p = tconn->meta.rbuf;
+
+	mdev = vnr_to_mdev(tconn, pi->vnr);
+	if (!mdev)
+		return false;
 
 	tl_release(mdev->tconn, p->barrier, be32_to_cpu(p->set_size));
 
@@ -4697,13 +4727,18 @@ static int got_BarrierAck(struct drbd_conf *mdev, struct packet_info *pi)
 	return true;
 }
 
-static int got_OVResult(struct drbd_conf *mdev, struct packet_info *pi)
+static int got_OVResult(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct p_block_ack *p = mdev->tconn->meta.rbuf;
+	struct drbd_conf *mdev;
+	struct p_block_ack *p = tconn->meta.rbuf;
 	struct drbd_work *w;
 	sector_t sector;
 	int size;
 
+	mdev = vnr_to_mdev(tconn, pi->vnr);
+	if (!mdev)
+		return false;
+
 	sector = be64_to_cpu(p->sector);
 	size = be32_to_cpu(p->blksize);
 
@@ -4742,7 +4777,7 @@ static int got_OVResult(struct drbd_conf *mdev, struct packet_info *pi)
 	return true;
 }
 
-static int got_skip(struct drbd_conf *mdev, struct packet_info *pi)
+static int got_skip(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	return true;
 }
@@ -4775,31 +4810,27 @@ static int tconn_process_done_ee(struct drbd_tconn *tconn)
 
 struct asender_cmd {
 	size_t pkt_size;
-	enum mdev_or_conn fa_type; /* first argument's type */
-	union {
-		int (*mdev_fn)(struct drbd_conf *mdev, struct packet_info *);
-		int (*conn_fn)(struct drbd_tconn *tconn, struct packet_info *);
-	};
+	int (*fn)(struct drbd_tconn *tconn, struct packet_info *);
 };
 
 static struct asender_cmd asender_tbl[] = {
-	[P_PING]	    = { sizeof(struct p_header), CONN, { .conn_fn = got_Ping } },
-	[P_PING_ACK]	    = { sizeof(struct p_header), CONN, { .conn_fn = got_PingAck } },
-	[P_RECV_ACK]	    = { sizeof(struct p_block_ack), MDEV, { got_BlockAck } },
-	[P_WRITE_ACK]	    = { sizeof(struct p_block_ack), MDEV, { got_BlockAck } },
-	[P_RS_WRITE_ACK]    = { sizeof(struct p_block_ack), MDEV, { got_BlockAck } },
-	[P_DISCARD_WRITE]   = { sizeof(struct p_block_ack), MDEV, { got_BlockAck } },
-	[P_NEG_ACK]	    = { sizeof(struct p_block_ack), MDEV, { got_NegAck } },
-	[P_NEG_DREPLY]	    = { sizeof(struct p_block_ack), MDEV, { got_NegDReply } },
-	[P_NEG_RS_DREPLY]   = { sizeof(struct p_block_ack), MDEV, { got_NegRSDReply } },
-	[P_OV_RESULT]	    = { sizeof(struct p_block_ack), MDEV, { got_OVResult } },
-	[P_BARRIER_ACK]	    = { sizeof(struct p_barrier_ack), MDEV, { got_BarrierAck } },
-	[P_STATE_CHG_REPLY] = { sizeof(struct p_req_state_reply), MDEV, { got_RqSReply } },
-	[P_RS_IS_IN_SYNC]   = { sizeof(struct p_block_ack), MDEV, { got_IsInSync } },
-	[P_DELAY_PROBE]     = { sizeof(struct p_delay_probe93), MDEV, { got_skip } },
-	[P_RS_CANCEL]       = { sizeof(struct p_block_ack), MDEV, { got_NegRSDReply } },
-	[P_CONN_ST_CHG_REPLY]={ sizeof(struct p_req_state_reply), CONN, {.conn_fn = got_conn_RqSReply}},
-	[P_RETRY_WRITE]	    = { sizeof(struct p_block_ack), MDEV, { got_BlockAck } },
+	[P_PING]	    = { sizeof(struct p_header), got_Ping },
+	[P_PING_ACK]	    = { sizeof(struct p_header), got_PingAck },
+	[P_RECV_ACK]	    = { sizeof(struct p_block_ack), got_BlockAck },
+	[P_WRITE_ACK]	    = { sizeof(struct p_block_ack), got_BlockAck },
+	[P_RS_WRITE_ACK]    = { sizeof(struct p_block_ack), got_BlockAck },
+	[P_DISCARD_WRITE]   = { sizeof(struct p_block_ack), got_BlockAck },
+	[P_NEG_ACK]	    = { sizeof(struct p_block_ack), got_NegAck },
+	[P_NEG_DREPLY]	    = { sizeof(struct p_block_ack), got_NegDReply },
+	[P_NEG_RS_DREPLY]   = { sizeof(struct p_block_ack), got_NegRSDReply },
+	[P_OV_RESULT]	    = { sizeof(struct p_block_ack), got_OVResult },
+	[P_BARRIER_ACK]	    = { sizeof(struct p_barrier_ack), got_BarrierAck },
+	[P_STATE_CHG_REPLY] = { sizeof(struct p_req_state_reply), got_RqSReply },
+	[P_RS_IS_IN_SYNC]   = { sizeof(struct p_block_ack), got_IsInSync },
+	[P_DELAY_PROBE]     = { sizeof(struct p_delay_probe93), got_skip },
+	[P_RS_CANCEL]       = { sizeof(struct p_block_ack), got_NegRSDReply },
+	[P_CONN_ST_CHG_REPLY]={ sizeof(struct p_req_state_reply), got_conn_RqSReply },
+	[P_RETRY_WRITE]	    = { sizeof(struct p_block_ack), got_BlockAck },
 };
 
 int drbd_asender(struct drbd_thread *thi)
@@ -4889,7 +4920,7 @@ int drbd_asender(struct drbd_thread *thi)
 			if (decode_header(tconn, h, &pi))
 				goto reconnect;
 			cmd = &asender_tbl[pi.cmd];
-			if (pi.cmd >= ARRAY_SIZE(asender_tbl) || !cmd) {
+			if (pi.cmd >= ARRAY_SIZE(asender_tbl) || !cmd->fn) {
 				conn_err(tconn, "unknown command %d on meta (l: %d)\n",
 					pi.cmd, pi.size);
 				goto disconnect;
@@ -4904,15 +4935,11 @@ int drbd_asender(struct drbd_thread *thi)
 		if (received == expect) {
 			bool rv;
 
-			if (cmd->fa_type == CONN) {
-				rv = cmd->conn_fn(tconn, &pi);
-			} else {
-				struct drbd_conf *mdev = vnr_to_mdev(tconn, pi.vnr);
-				rv = cmd->mdev_fn(mdev, &pi);
-			}
-
-			if (!rv)
+			rv = cmd->fn(tconn, &pi);
+			if (!rv) {
+				conn_err(tconn, "%pf failed\n", cmd->fn);
 				goto reconnect;
+			}
 
 			tconn->last_received = jiffies;
 
-- 
1.7.4.1

