Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab1IHMtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:49:09 -0400
Received: from mail09.linbit.com ([212.69.161.110]:37552 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621Ab1IHMpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:45:42 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 06/16] drbd: Pass struct packet_info down to the asender receive functions
Date: Thu,  8 Sep 2011 14:45:27 +0200
Message-Id: <1315485937-18989-7-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_receiver.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index e45a417..5e464a7 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4462,7 +4462,7 @@ int drbdd_init(struct drbd_thread *thi)
 
 /* ********* acknowledge sender ******** */
 
-static int got_conn_RqSReply(struct drbd_tconn *tconn, enum drbd_packet cmd)
+static int got_conn_RqSReply(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	struct p_req_state_reply *p = tconn->meta.rbuf;
 	int retcode = be32_to_cpu(p->retcode);
@@ -4479,7 +4479,7 @@ static int got_conn_RqSReply(struct drbd_tconn *tconn, enum drbd_packet cmd)
 	return true;
 }
 
-static int got_RqSReply(struct drbd_conf *mdev, enum drbd_packet cmd)
+static int got_RqSReply(struct drbd_conf *mdev, struct packet_info *pi)
 {
 	struct p_req_state_reply *p = mdev->tconn->meta.rbuf;
 	int retcode = be32_to_cpu(p->retcode);
@@ -4496,13 +4496,13 @@ static int got_RqSReply(struct drbd_conf *mdev, enum drbd_packet cmd)
 	return true;
 }
 
-static int got_Ping(struct drbd_tconn *tconn, enum drbd_packet cmd)
+static int got_Ping(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	return drbd_send_ping_ack(tconn);
 
 }
 
-static int got_PingAck(struct drbd_tconn *tconn, enum drbd_packet cmd)
+static int got_PingAck(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	/* restore idle timeout */
 	tconn->meta.socket->sk->sk_rcvtimeo = tconn->net_conf->ping_int*HZ;
@@ -4512,7 +4512,7 @@ static int got_PingAck(struct drbd_tconn *tconn, enum drbd_packet cmd)
 	return true;
 }
 
-static int got_IsInSync(struct drbd_conf *mdev, enum drbd_packet cmd)
+static int got_IsInSync(struct drbd_conf *mdev, struct packet_info *pi)
 {
 	struct p_block_ack *p = mdev->tconn->meta.rbuf;
 	sector_t sector = be64_to_cpu(p->sector);
@@ -4557,7 +4557,7 @@ validate_req_change_req_state(struct drbd_conf *mdev, u64 id, sector_t sector,
 	return true;
 }
 
-static int got_BlockAck(struct drbd_conf *mdev, enum drbd_packet cmd)
+static int got_BlockAck(struct drbd_conf *mdev, struct packet_info *pi)
 {
 	struct p_block_ack *p = mdev->tconn->meta.rbuf;
 	sector_t sector = be64_to_cpu(p->sector);
@@ -4571,7 +4571,7 @@ static int got_BlockAck(struct drbd_conf *mdev, enum drbd_packet cmd)
 		dec_rs_pending(mdev);
 		return true;
 	}
-	switch (cmd) {
+	switch (pi->cmd) {
 	case P_RS_WRITE_ACK:
 		D_ASSERT(mdev->tconn->net_conf->wire_protocol == DRBD_PROT_C);
 		what = WRITE_ACKED_BY_PEER_AND_SIS;
@@ -4602,7 +4602,7 @@ static int got_BlockAck(struct drbd_conf *mdev, enum drbd_packet cmd)
 					     what, false);
 }
 
-static int got_NegAck(struct drbd_conf *mdev, enum drbd_packet cmd)
+static int got_NegAck(struct drbd_conf *mdev, struct packet_info *pi)
 {
 	struct p_block_ack *p = mdev->tconn->meta.rbuf;
 	sector_t sector = be64_to_cpu(p->sector);
@@ -4635,7 +4635,7 @@ static int got_NegAck(struct drbd_conf *mdev, enum drbd_packet cmd)
 	return true;
 }
 
-static int got_NegDReply(struct drbd_conf *mdev, enum drbd_packet cmd)
+static int got_NegDReply(struct drbd_conf *mdev, struct packet_info *pi)
 {
 	struct p_block_ack *p = mdev->tconn->meta.rbuf;
 	sector_t sector = be64_to_cpu(p->sector);
@@ -4650,7 +4650,7 @@ static int got_NegDReply(struct drbd_conf *mdev, enum drbd_packet cmd)
 					     NEG_ACKED, false);
 }
 
-static int got_NegRSDReply(struct drbd_conf *mdev, enum drbd_packet cmd)
+static int got_NegRSDReply(struct drbd_conf *mdev, struct packet_info *pi)
 {
 	sector_t sector;
 	int size;
@@ -4665,7 +4665,7 @@ static int got_NegRSDReply(struct drbd_conf *mdev, enum drbd_packet cmd)
 
 	if (get_ldev_if_state(mdev, D_FAILED)) {
 		drbd_rs_complete_io(mdev, sector);
-		switch (cmd) {
+		switch (pi->cmd) {
 		case P_NEG_RS_DREPLY:
 			drbd_rs_failed_io(mdev, sector, size);
 		case P_RS_CANCEL:
@@ -4681,7 +4681,7 @@ static int got_NegRSDReply(struct drbd_conf *mdev, enum drbd_packet cmd)
 	return true;
 }
 
-static int got_BarrierAck(struct drbd_conf *mdev, enum drbd_packet cmd)
+static int got_BarrierAck(struct drbd_conf *mdev, struct packet_info *pi)
 {
 	struct p_barrier_ack *p = mdev->tconn->meta.rbuf;
 
@@ -4697,7 +4697,7 @@ static int got_BarrierAck(struct drbd_conf *mdev, enum drbd_packet cmd)
 	return true;
 }
 
-static int got_OVResult(struct drbd_conf *mdev, enum drbd_packet cmd)
+static int got_OVResult(struct drbd_conf *mdev, struct packet_info *pi)
 {
 	struct p_block_ack *p = mdev->tconn->meta.rbuf;
 	struct drbd_work *w;
@@ -4742,7 +4742,7 @@ static int got_OVResult(struct drbd_conf *mdev, enum drbd_packet cmd)
 	return true;
 }
 
-static int got_skip(struct drbd_conf *mdev, enum drbd_packet cmd)
+static int got_skip(struct drbd_conf *mdev, struct packet_info *pi)
 {
 	return true;
 }
@@ -4777,8 +4777,8 @@ struct asender_cmd {
 	size_t pkt_size;
 	enum mdev_or_conn fa_type; /* first argument's type */
 	union {
-		int (*mdev_fn)(struct drbd_conf *mdev, enum drbd_packet cmd);
-		int (*conn_fn)(struct drbd_tconn *tconn, enum drbd_packet cmd);
+		int (*mdev_fn)(struct drbd_conf *mdev, struct packet_info *);
+		int (*conn_fn)(struct drbd_tconn *tconn, struct packet_info *);
 	};
 };
 
@@ -4905,10 +4905,10 @@ int drbd_asender(struct drbd_thread *thi)
 			bool rv;
 
 			if (cmd->fa_type == CONN) {
-				rv = cmd->conn_fn(tconn, pi.cmd);
+				rv = cmd->conn_fn(tconn, &pi);
 			} else {
 				struct drbd_conf *mdev = vnr_to_mdev(tconn, pi.vnr);
-				rv = cmd->mdev_fn(mdev, pi.cmd);
+				rv = cmd->mdev_fn(mdev, &pi);
 			}
 
 			if (!rv)
-- 
1.7.4.1

