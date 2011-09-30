Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab1I3Mtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 08:49:43 -0400
Received: from mail09.linbit.com ([212.69.161.110]:42757 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758597Ab1I3Msb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 08:48:31 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 06/11] drbd: Runtime changeable wire protocol
Date: Fri, 30 Sep 2011 14:48:21 +0200
Message-Id: <1317386906-19260-7-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317386906-19260-1-git-send-email-philipp.reisner@linbit.com>
References: <1317386906-19260-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wire protocol is no longer a property that is negotiated
between the two peers. It is now expressed with two bits
(DP_SEND_WRITE_ACK and DP_SEND_RECEIVE_ACK) in each data
packet. Therefore the primary node is free to change the
wire protocol at any time without disconnect/reconnect.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    6 +++++
 drivers/block/drbd/drbd_main.c     |    8 ++++++-
 drivers/block/drbd/drbd_receiver.c |   39 +++++++++++++++++------------------
 drivers/block/drbd/drbd_req.c      |   18 ++++++++++++----
 drivers/block/drbd/drbd_req.h      |    8 +++++++
 5 files changed, 53 insertions(+), 26 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 2119d9b..c57cedb 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -327,6 +327,8 @@ extern unsigned int drbd_header_size(struct drbd_tconn *tconn);
 #define DP_FUA               16 /* equals REQ_FUA     */
 #define DP_FLUSH             32 /* equals REQ_FLUSH   */
 #define DP_DISCARD           64 /* equals REQ_DISCARD */
+#define DP_SEND_RECEIVE_ACK 128 /* This is a proto B write request */
+#define DP_SEND_WRITE_ACK   256 /* This is a proto C write request */
 
 struct p_data {
 	u64	    sector;    /* 64 bits sector number */
@@ -656,6 +658,9 @@ enum {
 
 	/* Conflicting local requests need to be restarted after this request */
 	__EE_RESTART_REQUESTS,
+
+	/* The peer wants a write ACK for this (wire proto C) */
+	__EE_SEND_WRITE_ACK,
 };
 #define EE_CALL_AL_COMPLETE_IO (1<<__EE_CALL_AL_COMPLETE_IO)
 #define EE_MAY_SET_IN_SYNC     (1<<__EE_MAY_SET_IN_SYNC)
@@ -663,6 +668,7 @@ enum {
 #define EE_WAS_ERROR           (1<<__EE_WAS_ERROR)
 #define EE_HAS_DIGEST          (1<<__EE_HAS_DIGEST)
 #define EE_RESTART_REQUESTS	(1<<__EE_RESTART_REQUESTS)
+#define EE_SEND_WRITE_ACK	(1<<__EE_SEND_WRITE_ACK)
 
 /* flag bits per mdev */
 enum {
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index a2cac15..6a11e9d 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1672,6 +1672,12 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 	if (mdev->state.conn >= C_SYNC_SOURCE &&
 	    mdev->state.conn <= C_PAUSED_SYNC_T)
 		dp_flags |= DP_MAY_SET_IN_SYNC;
+	if (mdev->tconn->agreed_pro_version >= 100) {
+		if (req->rq_state & RQ_EXP_RECEIVE_ACK)
+			dp_flags |= DP_SEND_RECEIVE_ACK;
+		if (req->rq_state & RQ_EXP_WRITE_ACK)
+			dp_flags |= DP_SEND_WRITE_ACK;
+	}
 	p->dp_flags = cpu_to_be32(dp_flags);
 	if (dgs)
 		drbd_csum_bio(mdev, mdev->tconn->integrity_w_tfm, req->master_bio, p + 1);
@@ -1688,7 +1694,7 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 		 * out ok after sending on this side, but does not fit on the
 		 * receiving side, we sure have detected corruption elsewhere.
 		 */
-		if (mdev->tconn->net_conf->wire_protocol == DRBD_PROT_A || dgs)
+		if (!(req->rq_state & (RQ_EXP_RECEIVE_ACK | RQ_EXP_WRITE_ACK)) || dgs)
 			err = _drbd_send_bio(mdev, req->master_bio);
 		else
 			err = _drbd_send_zc_bio(mdev, req->master_bio);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 4d9d71a..0b648dc 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1697,7 +1697,7 @@ static int e_end_block(struct drbd_work *w, int cancel)
 	sector_t sector = peer_req->i.sector;
 	int err = 0, pcmd;
 
-	if (mdev->tconn->net_conf->wire_protocol == DRBD_PROT_C) {
+	if (peer_req->flags & EE_SEND_WRITE_ACK) {
 		if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
 			pcmd = (mdev->state.conn >= C_SYNC_SOURCE &&
 				mdev->state.conn <= C_PAUSED_SYNC_T &&
@@ -2074,20 +2074,28 @@ static int receive_Data(struct drbd_tconn *tconn, struct packet_info *pi)
 	list_add(&peer_req->w.list, &mdev->active_ee);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
-	switch (mdev->tconn->net_conf->wire_protocol) {
-	case DRBD_PROT_C:
+	if (mdev->tconn->agreed_pro_version < 100) {
+		switch (mdev->tconn->net_conf->wire_protocol) {
+		case DRBD_PROT_C:
+			dp_flags |= DP_SEND_WRITE_ACK;
+			break;
+		case DRBD_PROT_B:
+			dp_flags |= DP_SEND_RECEIVE_ACK;
+			break;
+		}
+	}
+
+	if (dp_flags & DP_SEND_WRITE_ACK) {
+		peer_req->flags |= EE_SEND_WRITE_ACK;
 		inc_unacked(mdev);
 		/* corresponding dec_unacked() in e_end_block()
 		 * respective _drbd_clear_done_ee */
-		break;
-	case DRBD_PROT_B:
+	}
+
+	if (dp_flags & DP_SEND_RECEIVE_ACK) {
 		/* I really don't like it that the receiver thread
 		 * sends on the msock, but anyways */
 		drbd_send_ack(mdev, P_RECV_ACK, peer_req);
-		break;
-	case DRBD_PROT_A:
-		/* nothing to do */
-		break;
 	}
 
 	if (mdev->state.pdsk < D_INCONSISTENT) {
@@ -2932,7 +2940,7 @@ static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 	if (cf & CF_DRY_RUN)
 		set_bit(CONN_DRY_RUN, &tconn->flags);
 
-	if (p_proto != tconn->net_conf->wire_protocol) {
+	if (p_proto != tconn->net_conf->wire_protocol && tconn->agreed_pro_version < 100) {
 		conn_err(tconn, "incompatible communication protocols\n");
 		goto disconnect;
 	}
@@ -4622,23 +4630,18 @@ static int got_BlockAck(struct drbd_tconn *tconn, struct packet_info *pi)
 	}
 	switch (pi->cmd) {
 	case P_RS_WRITE_ACK:
-		D_ASSERT(mdev->tconn->net_conf->wire_protocol == DRBD_PROT_C);
 		what = WRITE_ACKED_BY_PEER_AND_SIS;
 		break;
 	case P_WRITE_ACK:
-		D_ASSERT(mdev->tconn->net_conf->wire_protocol == DRBD_PROT_C);
 		what = WRITE_ACKED_BY_PEER;
 		break;
 	case P_RECV_ACK:
-		D_ASSERT(mdev->tconn->net_conf->wire_protocol == DRBD_PROT_B);
 		what = RECV_ACKED_BY_PEER;
 		break;
 	case P_DISCARD_WRITE:
-		D_ASSERT(mdev->tconn->net_conf->wire_protocol == DRBD_PROT_C);
 		what = DISCARD_WRITE;
 		break;
 	case P_RETRY_WRITE:
-		D_ASSERT(mdev->tconn->net_conf->wire_protocol == DRBD_PROT_C);
 		what = POSTPONE_WRITE;
 		break;
 	default:
@@ -4656,8 +4659,6 @@ static int got_NegAck(struct drbd_tconn *tconn, struct packet_info *pi)
 	struct p_block_ack *p = pi->data;
 	sector_t sector = be64_to_cpu(p->sector);
 	int size = be32_to_cpu(p->blksize);
-	bool missing_ok = tconn->net_conf->wire_protocol == DRBD_PROT_A ||
-			  tconn->net_conf->wire_protocol == DRBD_PROT_B;
 	int err;
 
 	mdev = vnr_to_mdev(tconn, pi->vnr);
@@ -4674,15 +4675,13 @@ static int got_NegAck(struct drbd_tconn *tconn, struct packet_info *pi)
 
 	err = validate_req_change_req_state(mdev, p->block_id, sector,
 					    &mdev->write_requests, __func__,
-					    NEG_ACKED, missing_ok);
+					    NEG_ACKED, true);
 	if (err) {
 		/* Protocol A has no P_WRITE_ACKs, but has P_NEG_ACKs.
 		   The master bio might already be completed, therefore the
 		   request is no longer in the collision hash. */
 		/* In Protocol B we might already have got a P_RECV_ACK
 		   but then get a P_NEG_ACK afterwards. */
-		if (!missing_ok)
-			return err;
 		drbd_set_out_of_sync(mdev, sector, size);
 	}
 	return 0;
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index fd0b452..0f1a29f 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -323,7 +323,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		struct bio_and_error *m)
 {
 	struct drbd_conf *mdev = req->w.mdev;
-	int rv = 0;
+	int p, rv = 0;
 
 	if (m)
 		m->bio = NULL;
@@ -344,6 +344,10 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		 * and from w_read_retry_remote */
 		D_ASSERT(!(req->rq_state & RQ_NET_MASK));
 		req->rq_state |= RQ_NET_PENDING;
+		p = mdev->tconn->net_conf->wire_protocol;
+		req->rq_state |=
+			p == DRBD_PROT_C ? RQ_EXP_WRITE_ACK :
+			p == DRBD_PROT_B ? RQ_EXP_RECEIVE_ACK : 0;
 		inc_ap_pending(mdev);
 		break;
 
@@ -500,7 +504,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 			atomic_add(req->i.size >> 9, &mdev->ap_in_flight);
 
 		if (bio_data_dir(req->master_bio) == WRITE &&
-		    mdev->tconn->net_conf->wire_protocol == DRBD_PROT_A) {
+		    !(req->rq_state & (RQ_EXP_RECEIVE_ACK | RQ_EXP_WRITE_ACK))) {
 			/* this is what is dangerous about protocol A:
 			 * pretend it was successfully written on the peer. */
 			if (req->rq_state & RQ_NET_PENDING) {
@@ -550,6 +554,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		req->rq_state |= RQ_NET_DONE;
 		/* fall through */
 	case WRITE_ACKED_BY_PEER:
+		D_ASSERT(req->rq_state & RQ_EXP_WRITE_ACK);
 		/* protocol C; successfully written on peer.
 		 * Nothing to do here.
 		 * We want to keep the tl in place for all protocols, to cater
@@ -560,11 +565,14 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		 * request could set NET_DONE right here, and not wait for the
 		 * P_BARRIER_ACK, but that is an unnecessary optimization. */
 
+		goto ack_common;
 		/* this makes it effectively the same as for: */
 	case RECV_ACKED_BY_PEER:
+		D_ASSERT(req->rq_state & RQ_EXP_RECEIVE_ACK);
 		/* protocol B; pretends to be successfully written on peer.
 		 * see also notes above in HANDED_OVER_TO_NETWORK about
 		 * protocol != C */
+	ack_common:
 		req->rq_state |= RQ_NET_OK;
 		D_ASSERT(req->rq_state & RQ_NET_PENDING);
 		dec_ap_pending(mdev);
@@ -574,8 +582,8 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		break;
 
 	case POSTPONE_WRITE:
-		/*
-		 * If this node has already detected the write conflict, the
+		D_ASSERT(req->rq_state & RQ_EXP_WRITE_ACK);
+		/* If this node has already detected the write conflict, the
 		 * worker will be waiting on misc_wait.  Wake it up once this
 		 * request has completed locally.
 		 */
@@ -646,7 +654,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		}
 		if ((req->rq_state & RQ_NET_MASK) != 0) {
 			req->rq_state |= RQ_NET_DONE;
-			if (mdev->tconn->net_conf->wire_protocol == DRBD_PROT_A)
+			if (!(req->rq_state & (RQ_EXP_RECEIVE_ACK | RQ_EXP_WRITE_ACK)))
 				atomic_sub(req->i.size>>9, &mdev->ap_in_flight);
 		}
 		_req_may_be_done(req, m); /* Allowed while state.susp */
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index b9f474a..dfd2cef 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -198,6 +198,12 @@ enum drbd_req_state_bits {
 
 	/* The peer has sent a retry ACK */
 	__RQ_POSTPONED,
+
+	/* We expect a receive ACK (wire proto B) */
+	__RQ_EXP_RECEIVE_ACK,
+
+	/* We expect a write ACK (wite proto C) */
+	__RQ_EXP_WRITE_ACK,
 };
 
 #define RQ_LOCAL_PENDING   (1UL << __RQ_LOCAL_PENDING)
@@ -219,6 +225,8 @@ enum drbd_req_state_bits {
 #define RQ_WRITE           (1UL << __RQ_WRITE)
 #define RQ_IN_ACT_LOG      (1UL << __RQ_IN_ACT_LOG)
 #define RQ_POSTPONED	   (1UL << __RQ_POSTPONED)
+#define RQ_EXP_RECEIVE_ACK (1UL << __RQ_EXP_RECEIVE_ACK)
+#define RQ_EXP_WRITE_ACK   (1UL << __RQ_EXP_WRITE_ACK)
 
 /* For waking up the frozen transfer log mod_req() has to return if the request
    should be counted in the epoch object*/
-- 
1.7.4.1

