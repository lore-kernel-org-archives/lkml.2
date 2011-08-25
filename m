Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab1HYPdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:33:46 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32967 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab1HYPJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:06 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 021/118] drbd: Convert all constants in enum drbd_req_event to upper case
Date: Thu, 25 Aug 2011 17:07:17 +0200
Message-Id: <1314284934-17999-22-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |   10 ++--
 drivers/block/drbd/drbd_main.c     |   28 ++++++------
 drivers/block/drbd/drbd_nl.c       |    2 +-
 drivers/block/drbd/drbd_receiver.c |   18 ++++----
 drivers/block/drbd/drbd_req.c      |   84 ++++++++++++++++++------------------
 drivers/block/drbd/drbd_req.h      |   62 +++++++++++++-------------
 drivers/block/drbd/drbd_worker.c   |   22 +++++-----
 7 files changed, 113 insertions(+), 113 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 0ed97ac..0d5c727 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -2031,21 +2031,21 @@ static inline void drbd_thread_restart_nowait(struct drbd_thread *thi)
  * or implicit barrier packets as necessary.
  * increased:
  *  w_send_barrier
- *  _req_mod(req, queue_for_net_write or queue_for_net_read);
+ *  _req_mod(req, QUEUE_FOR_NET_WRITE or QUEUE_FOR_NET_READ);
  *    it is much easier and equally valid to count what we queue for the
  *    worker, even before it actually was queued or send.
  *    (drbd_make_request_common; recovery path on read io-error)
  * decreased:
  *  got_BarrierAck (respective tl_clear, tl_clear_barrier)
- *  _req_mod(req, data_received)
+ *  _req_mod(req, DATA_RECEIVED)
  *     [from receive_DataReply]
- *  _req_mod(req, write_acked_by_peer or recv_acked_by_peer or neg_acked)
+ *  _req_mod(req, WRITE_ACKED_BY_PEER or RECV_ACKED_BY_PEER or NEG_ACKED)
  *     [from got_BlockAck (P_WRITE_ACK, P_RECV_ACK)]
  *     for some reason it is NOT decreased in got_NegAck,
  *     but in the resulting cleanup code from report_params.
  *     we should try to remember the reason for that...
- *  _req_mod(req, send_failed or send_canceled)
- *  _req_mod(req, connection_lost_while_pending)
+ *  _req_mod(req, SEND_FAILED or SEND_CANCELED)
+ *  _req_mod(req, CONNECTION_LOST_WHILE_PENDING)
  *     [from tl_clear_barrier]
  */
 static inline void inc_ap_pending(struct drbd_conf *mdev)
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 878f7d4..c5bb871 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -290,7 +290,7 @@ void tl_release(struct drbd_conf *mdev, unsigned int barrier_nr,
 	/* Clean up list of requests processed during current epoch */
 	list_for_each_safe(le, tle, &b->requests) {
 		r = list_entry(le, struct drbd_request, tl_requests);
-		_req_mod(r, barrier_acked);
+		_req_mod(r, BARRIER_ACKED);
 	}
 	/* There could be requests on the list waiting for completion
 	   of the write to the local disk. To avoid corruptions of
@@ -300,10 +300,10 @@ void tl_release(struct drbd_conf *mdev, unsigned int barrier_nr,
 	   the write acks - which would be a bug and violating write ordering.
 	   To not deadlock in case we lose connection while such requests are
 	   still pending, we need some way to find them for the
-	   _req_mode(connection_lost_while_pending).
+	   _req_mode(CONNECTION_LOST_WHILE_PENDING).
 
 	   These have been list_move'd to the out_of_sequence_requests list in
-	   _req_mod(, barrier_acked) above.
+	   _req_mod(, BARRIER_ACKED) above.
 	   */
 	list_del_init(&b->requests);
 
@@ -336,8 +336,8 @@ bail:
  * @mdev:	DRBD device.
  * @what:       The action/event to perform with all request objects
  *
- * @what might be one of connection_lost_while_pending, resend, fail_frozen_disk_io,
- * restart_frozen_disk_io.
+ * @what might be one of CONNECTION_LOST_WHILE_PENDING, RESEND, FAIL_FROZEN_DISK_IO,
+ * RESTART_FROZEN_DISK_IO.
  */
 static void _tl_restart(struct drbd_conf *mdev, enum drbd_req_event what)
 {
@@ -362,7 +362,7 @@ static void _tl_restart(struct drbd_conf *mdev, enum drbd_req_event what)
 		tmp = b->next;
 
 		if (n_writes) {
-			if (what == resend) {
+			if (what == RESEND) {
 				b->n_writes = n_writes;
 				if (b->w.cb == NULL) {
 					b->w.cb = w_send_barrier;
@@ -423,7 +423,7 @@ void tl_clear(struct drbd_conf *mdev)
 
 	spin_lock_irq(&mdev->req_lock);
 
-	_tl_restart(mdev, connection_lost_while_pending);
+	_tl_restart(mdev, CONNECTION_LOST_WHILE_PENDING);
 
 	/* we expect this list to be empty. */
 	D_ASSERT(list_empty(&mdev->out_of_sequence_requests));
@@ -433,7 +433,7 @@ void tl_clear(struct drbd_conf *mdev)
 		r = list_entry(le, struct drbd_request, tl_requests);
 		/* It would be nice to complete outside of spinlock.
 		 * But this is easier for now. */
-		_req_mod(r, connection_lost_while_pending);
+		_req_mod(r, CONNECTION_LOST_WHILE_PENDING);
 	}
 
 	/* ensure bit indicating barrier is required is clear */
@@ -1321,7 +1321,7 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 			   union drbd_state ns, enum chg_state_flags flags)
 {
 	enum drbd_fencing_p fp;
-	enum drbd_req_event what = nothing;
+	enum drbd_req_event what = NOTHING;
 	union drbd_state nsm = (union drbd_state){ .i = -1 };
 
 	if (os.conn != C_CONNECTED && ns.conn == C_CONNECTED) {
@@ -1349,12 +1349,12 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 	nsm.i = -1;
 	if (ns.susp_nod) {
 		if (os.conn < C_CONNECTED && ns.conn >= C_CONNECTED)
-			what = resend;
+			what = RESEND;
 
 		if (os.disk == D_ATTACHING && ns.disk > D_ATTACHING)
-			what = restart_frozen_disk_io;
+			what = RESTART_FROZEN_DISK_IO;
 
-		if (what != nothing)
+		if (what != NOTHING)
 			nsm.susp_nod = 0;
 	}
 
@@ -1373,12 +1373,12 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 		/* case2: The connection was established again: */
 		if (os.conn < C_CONNECTED && ns.conn >= C_CONNECTED) {
 			clear_bit(NEW_CUR_UUID, &mdev->flags);
-			what = resend;
+			what = RESEND;
 			nsm.susp_fen = 0;
 		}
 	}
 
-	if (what != nothing) {
+	if (what != NOTHING) {
 		spin_lock_irq(&mdev->req_lock);
 		_tl_restart(mdev, what);
 		nsm.i &= mdev->state.i;
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 5b8ebbe..1840cbb8 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2022,7 +2022,7 @@ static int drbd_nl_resume_io(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 		if (mdev->state.conn < C_CONNECTED)
 			tl_clear(mdev);
 		if (mdev->state.disk == D_DISKLESS || mdev->state.disk == D_FAILED)
-			tl_restart(mdev, fail_frozen_disk_io);
+			tl_restart(mdev, FAIL_FROZEN_DISK_IO);
 	}
 	drbd_resume_io(mdev);
 
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 566317b..1762ef0 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -385,7 +385,7 @@ int drbd_release_ee(struct drbd_conf *mdev, struct list_head *list)
 
 /*
  * This function is called from _asender only_
- * but see also comments in _req_mod(,barrier_acked)
+ * but see also comments in _req_mod(,BARRIER_ACKED)
  * and receive_Barrier.
  *
  * Move entries from net_ee to done_ee, if ready.
@@ -1507,7 +1507,7 @@ static int receive_DataReply(struct drbd_conf *mdev, enum drbd_packets cmd, unsi
 	ok = recv_dless_read(mdev, req, sector, data_size);
 
 	if (ok)
-		req_mod(req, data_received);
+		req_mod(req, DATA_RECEIVED);
 	/* else: nothing. handled from drbd_disconnect...
 	 * I don't think we may complete this just yet
 	 * in case we are "on-disconnect: freeze" */
@@ -3279,7 +3279,7 @@ static int receive_state(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 	cs_flags = CS_VERBOSE + (os.conn < C_CONNECTED && ns.conn >= C_CONNECTED ? 0 : CS_HARD);
 	if (ns.pdsk == D_CONSISTENT && is_susp(ns) && ns.conn == C_CONNECTED && os.conn < C_CONNECTED &&
 	    test_bit(NEW_CUR_UUID, &mdev->flags)) {
-		/* Do not allow tl_restart(resend) for a rebooted peer. We can only allow this
+		/* Do not allow tl_restart(RESEND) for a rebooted peer. We can only allow this
 		   for temporal network outages! */
 		spin_unlock_irq(&mdev->req_lock);
 		dev_err(DEV, "Aborting Connect, can not thaw IO with an only Consistent peer\n");
@@ -4272,19 +4272,19 @@ static int got_BlockAck(struct drbd_conf *mdev, struct p_header80 *h)
 	switch (be16_to_cpu(h->command)) {
 	case P_RS_WRITE_ACK:
 		D_ASSERT(mdev->net_conf->wire_protocol == DRBD_PROT_C);
-		what = write_acked_by_peer_and_sis;
+		what = WRITE_ACKED_BY_PEER_AND_SIS;
 		break;
 	case P_WRITE_ACK:
 		D_ASSERT(mdev->net_conf->wire_protocol == DRBD_PROT_C);
-		what = write_acked_by_peer;
+		what = WRITE_ACKED_BY_PEER;
 		break;
 	case P_RECV_ACK:
 		D_ASSERT(mdev->net_conf->wire_protocol == DRBD_PROT_B);
-		what = recv_acked_by_peer;
+		what = RECV_ACKED_BY_PEER;
 		break;
 	case P_DISCARD_ACK:
 		D_ASSERT(mdev->net_conf->wire_protocol == DRBD_PROT_C);
-		what = conflict_discarded_by_peer;
+		what = CONFLICT_DISCARDED_BY_PEER;
 		break;
 	default:
 		D_ASSERT(0);
@@ -4315,7 +4315,7 @@ static int got_NegAck(struct drbd_conf *mdev, struct p_header80 *h)
 
 	found = validate_req_change_req_state(mdev, p->block_id, sector,
 					      &mdev->write_requests, __func__,
-					      neg_acked, missing_ok);
+					      NEG_ACKED, missing_ok);
 	if (!found) {
 		/* Protocol A has no P_WRITE_ACKs, but has P_NEG_ACKs.
 		   The master bio might already be completed, therefore the
@@ -4340,7 +4340,7 @@ static int got_NegDReply(struct drbd_conf *mdev, struct p_header80 *h)
 
 	return validate_req_change_req_state(mdev, p->block_id, sector,
 					     &mdev->read_requests, __func__,
-					     neg_acked, false);
+					     NEG_ACKED, false);
 }
 
 static int got_NegRSDReply(struct drbd_conf *mdev, struct p_header80 *h)
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 8541b16..b3b1d4e 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -225,10 +225,10 @@ void _req_may_be_done(struct drbd_request *req, struct bio_and_error *m)
 		return;
 
 	if (req->master_bio) {
-		/* this is data_received (remote read)
+		/* this is DATA_RECEIVED (remote read)
 		 * or protocol C P_WRITE_ACK
 		 * or protocol B P_RECV_ACK
-		 * or protocol A "handed_over_to_network" (SendAck)
+		 * or protocol A "HANDED_OVER_TO_NETWORK" (SendAck)
 		 * or canceled or failed,
 		 * or killed from the transfer log due to connection loss.
 		 */
@@ -393,11 +393,11 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 
 	/* does not happen...
 	 * initialization done in drbd_req_new
-	case created:
+	case CREATED:
 		break;
 		*/
 
-	case to_be_send: /* via network */
+	case TO_BE_SENT: /* via network */
 		/* reached via drbd_make_request_common
 		 * and from w_read_retry_remote */
 		D_ASSERT(!(req->rq_state & RQ_NET_MASK));
@@ -405,13 +405,13 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		inc_ap_pending(mdev);
 		break;
 
-	case to_be_submitted: /* locally */
+	case TO_BE_SUBMITTED: /* locally */
 		/* reached via drbd_make_request_common */
 		D_ASSERT(!(req->rq_state & RQ_LOCAL_MASK));
 		req->rq_state |= RQ_LOCAL_PENDING;
 		break;
 
-	case completed_ok:
+	case COMPLETED_OK:
 		if (bio_data_dir(req->master_bio) == WRITE)
 			mdev->writ_cnt += req->i.size >> 9;
 		else
@@ -424,7 +424,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		put_ldev(mdev);
 		break;
 
-	case write_completed_with_error:
+	case WRITE_COMPLETED_WITH_ERROR:
 		req->rq_state |= RQ_LOCAL_COMPLETED;
 		req->rq_state &= ~RQ_LOCAL_PENDING;
 
@@ -433,7 +433,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		put_ldev(mdev);
 		break;
 
-	case read_ahead_completed_with_error:
+	case READ_AHEAD_COMPLETED_WITH_ERROR:
 		/* it is legal to fail READA */
 		req->rq_state |= RQ_LOCAL_COMPLETED;
 		req->rq_state &= ~RQ_LOCAL_PENDING;
@@ -441,7 +441,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		put_ldev(mdev);
 		break;
 
-	case read_completed_with_error:
+	case READ_COMPLETED_WITH_ERROR:
 		drbd_set_out_of_sync(mdev, req->i.sector, req->i.size);
 
 		req->rq_state |= RQ_LOCAL_COMPLETED;
@@ -459,12 +459,12 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 			break;
 		}
 
-		/* _req_mod(req,to_be_send); oops, recursion... */
+		/* _req_mod(req,TO_BE_SENT); oops, recursion... */
 		req->rq_state |= RQ_NET_PENDING;
 		inc_ap_pending(mdev);
-		/* fall through: _req_mod(req,queue_for_net_read); */
+		/* fall through: _req_mod(req,QUEUE_FOR_NET_READ); */
 
-	case queue_for_net_read:
+	case QUEUE_FOR_NET_READ:
 		/* READ or READA, and
 		 * no local disk,
 		 * or target area marked as invalid,
@@ -486,7 +486,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		drbd_queue_work(&mdev->data.work, &req->w);
 		break;
 
-	case queue_for_net_write:
+	case QUEUE_FOR_NET_WRITE:
 		/* assert something? */
 		/* from drbd_make_request_common only */
 
@@ -533,17 +533,17 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 
 		break;
 
-	case queue_for_send_oos:
+	case QUEUE_FOR_SEND_OOS:
 		req->rq_state |= RQ_NET_QUEUED;
 		req->w.cb =  w_send_oos;
 		drbd_queue_work(&mdev->data.work, &req->w);
 		break;
 
-	case oos_handed_to_network:
+	case OOS_HANDED_TO_NETWORK:
 		/* actually the same */
-	case send_canceled:
+	case SEND_CANCELED:
 		/* treat it the same */
-	case send_failed:
+	case SEND_FAILED:
 		/* real cleanup will be done from tl_clear.  just update flags
 		 * so it is no longer marked as on the worker queue */
 		req->rq_state &= ~RQ_NET_QUEUED;
@@ -552,7 +552,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		_req_may_be_done_not_susp(req, m);
 		break;
 
-	case handed_over_to_network:
+	case HANDED_OVER_TO_NETWORK:
 		/* assert something? */
 		if (bio_data_dir(req->master_bio) == WRITE)
 			atomic_add(req->i.size >> 9, &mdev->ap_in_flight);
@@ -573,17 +573,17 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		req->rq_state &= ~RQ_NET_QUEUED;
 		req->rq_state |= RQ_NET_SENT;
 		/* because _drbd_send_zc_bio could sleep, and may want to
-		 * dereference the bio even after the "write_acked_by_peer" and
-		 * "completed_ok" events came in, once we return from
+		 * dereference the bio even after the "WRITE_ACKED_BY_PEER" and
+		 * "COMPLETED_OK" events came in, once we return from
 		 * _drbd_send_zc_bio (drbd_send_dblock), we have to check
 		 * whether it is done already, and end it.  */
 		_req_may_be_done_not_susp(req, m);
 		break;
 
-	case read_retry_remote_canceled:
+	case READ_RETRY_REMOTE_CANCELED:
 		req->rq_state &= ~RQ_NET_QUEUED;
 		/* fall through, in case we raced with drbd_disconnect */
-	case connection_lost_while_pending:
+	case CONNECTION_LOST_WHILE_PENDING:
 		/* transfer log cleanup after connection loss */
 		/* assert something? */
 		if (req->rq_state & RQ_NET_PENDING)
@@ -599,19 +599,19 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 			_req_may_be_done(req, m); /* Allowed while state.susp */
 		break;
 
-	case write_acked_by_peer_and_sis:
+	case WRITE_ACKED_BY_PEER_AND_SIS:
 		req->rq_state |= RQ_NET_SIS;
-	case conflict_discarded_by_peer:
+	case CONFLICT_DISCARDED_BY_PEER:
 		/* for discarded conflicting writes of multiple primaries,
 		 * there is no need to keep anything in the tl, potential
 		 * node crashes are covered by the activity log. */
-		if (what == conflict_discarded_by_peer)
+		if (what == CONFLICT_DISCARDED_BY_PEER)
 			dev_alert(DEV, "Got DiscardAck packet %llus +%u!"
 			      " DRBD is not a random data generator!\n",
 			      (unsigned long long)req->i.sector, req->i.size);
 		req->rq_state |= RQ_NET_DONE;
 		/* fall through */
-	case write_acked_by_peer:
+	case WRITE_ACKED_BY_PEER:
 		/* protocol C; successfully written on peer.
 		 * Nothing to do here.
 		 * We want to keep the tl in place for all protocols, to cater
@@ -623,9 +623,9 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		 * P_BARRIER_ACK, but that is an unnecessary optimization. */
 
 		/* this makes it effectively the same as for: */
-	case recv_acked_by_peer:
+	case RECV_ACKED_BY_PEER:
 		/* protocol B; pretends to be successfully written on peer.
-		 * see also notes above in handed_over_to_network about
+		 * see also notes above in HANDED_OVER_TO_NETWORK about
 		 * protocol != C */
 		req->rq_state |= RQ_NET_OK;
 		D_ASSERT(req->rq_state & RQ_NET_PENDING);
@@ -635,7 +635,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		_req_may_be_done_not_susp(req, m);
 		break;
 
-	case neg_acked:
+	case NEG_ACKED:
 		/* assert something? */
 		if (req->rq_state & RQ_NET_PENDING) {
 			dec_ap_pending(mdev);
@@ -645,17 +645,17 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 
 		req->rq_state |= RQ_NET_DONE;
 		_req_may_be_done_not_susp(req, m);
-		/* else: done by handed_over_to_network */
+		/* else: done by HANDED_OVER_TO_NETWORK */
 		break;
 
-	case fail_frozen_disk_io:
+	case FAIL_FROZEN_DISK_IO:
 		if (!(req->rq_state & RQ_LOCAL_COMPLETED))
 			break;
 
 		_req_may_be_done(req, m); /* Allowed while state.susp */
 		break;
 
-	case restart_frozen_disk_io:
+	case RESTART_FROZEN_DISK_IO:
 		if (!(req->rq_state & RQ_LOCAL_COMPLETED))
 			break;
 
@@ -670,7 +670,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		drbd_queue_work(&mdev->data.work, &req->w);
 		break;
 
-	case resend:
+	case RESEND:
 		/* If RQ_NET_OK is already set, we got a P_WRITE_ACK or P_RECV_ACK
 		   before the connection loss (B&C only); only P_BARRIER_ACK was missing.
 		   Trowing them out of the TL here by pretending we got a BARRIER_ACK
@@ -682,9 +682,9 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 			}
 			break;
 		}
-		/* else, fall through to barrier_acked */
+		/* else, fall through to BARRIER_ACKED */
 
-	case barrier_acked:
+	case BARRIER_ACKED:
 		if (!(req->rq_state & RQ_WRITE))
 			break;
 
@@ -692,7 +692,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 			/* barrier came in before all requests have been acked.
 			 * this is bad, because if the connection is lost now,
 			 * we won't be able to clean them up... */
-			dev_err(DEV, "FIXME (barrier_acked but pending)\n");
+			dev_err(DEV, "FIXME (BARRIER_ACKED but pending)\n");
 			list_move(&req->tl_requests, &mdev->out_of_sequence_requests);
 		}
 		if ((req->rq_state & RQ_NET_MASK) != 0) {
@@ -703,7 +703,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		_req_may_be_done(req, m); /* Allowed while state.susp */
 		break;
 
-	case data_received:
+	case DATA_RECEIVED:
 		D_ASSERT(req->rq_state & RQ_NET_PENDING);
 		dec_ap_pending(mdev);
 		req->rq_state &= ~RQ_NET_PENDING;
@@ -924,9 +924,9 @@ allocate_barrier:
 	/* mark them early for readability.
 	 * this just sets some state flags. */
 	if (remote)
-		_req_mod(req, to_be_send);
+		_req_mod(req, TO_BE_SENT);
 	if (local)
-		_req_mod(req, to_be_submitted);
+		_req_mod(req, TO_BE_SUBMITTED);
 
 	/* check this request on the collision detection hash tables.
 	 * if we have a conflict, just complete it here.
@@ -944,11 +944,11 @@ allocate_barrier:
 		 * or READ, but not in sync.
 		 */
 		_req_mod(req, (rw == WRITE)
-				? queue_for_net_write
-				: queue_for_net_read);
+				? QUEUE_FOR_NET_WRITE
+				: QUEUE_FOR_NET_READ);
 	}
 	if (send_oos && drbd_set_out_of_sync(mdev, sector, size))
-		_req_mod(req, queue_for_send_oos);
+		_req_mod(req, QUEUE_FOR_SEND_OOS);
 
 	if (remote &&
 	    mdev->net_conf->on_congestion != OC_BLOCK && mdev->agreed_pro_version >= 96) {
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index ee59174..6dbbe89 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -77,39 +77,39 @@
  */
 
 enum drbd_req_event {
-	created,
-	to_be_send,
-	to_be_submitted,
+	CREATED,
+	TO_BE_SENT,
+	TO_BE_SUBMITTED,
 
 	/* XXX yes, now I am inconsistent...
 	 * these are not "events" but "actions"
 	 * oh, well... */
-	queue_for_net_write,
-	queue_for_net_read,
-	queue_for_send_oos,
-
-	send_canceled,
-	send_failed,
-	handed_over_to_network,
-	oos_handed_to_network,
-	connection_lost_while_pending,
-	read_retry_remote_canceled,
-	recv_acked_by_peer,
-	write_acked_by_peer,
-	write_acked_by_peer_and_sis, /* and set_in_sync */
-	conflict_discarded_by_peer,
-	neg_acked,
-	barrier_acked, /* in protocol A and B */
-	data_received, /* (remote read) */
-
-	read_completed_with_error,
-	read_ahead_completed_with_error,
-	write_completed_with_error,
-	completed_ok,
-	resend,
-	fail_frozen_disk_io,
-	restart_frozen_disk_io,
-	nothing, /* for tracing only */
+	QUEUE_FOR_NET_WRITE,
+	QUEUE_FOR_NET_READ,
+	QUEUE_FOR_SEND_OOS,
+
+	SEND_CANCELED,
+	SEND_FAILED,
+	HANDED_OVER_TO_NETWORK,
+	OOS_HANDED_TO_NETWORK,
+	CONNECTION_LOST_WHILE_PENDING,
+	READ_RETRY_REMOTE_CANCELED,
+	RECV_ACKED_BY_PEER,
+	WRITE_ACKED_BY_PEER,
+	WRITE_ACKED_BY_PEER_AND_SIS, /* and set_in_sync */
+	CONFLICT_DISCARDED_BY_PEER,
+	NEG_ACKED,
+	BARRIER_ACKED, /* in protocol A and B */
+	DATA_RECEIVED, /* (remote read) */
+
+	READ_COMPLETED_WITH_ERROR,
+	READ_AHEAD_COMPLETED_WITH_ERROR,
+	WRITE_COMPLETED_WITH_ERROR,
+	COMPLETED_OK,
+	RESEND,
+	FAIL_FROZEN_DISK_IO,
+	RESTART_FROZEN_DISK_IO,
+	NOTHING,
 };
 
 /* encoding of request states for now.  we don't actually need that many bits.
@@ -138,8 +138,8 @@ enum drbd_req_state_bits {
 	 *        recv_ack (B) or implicit "ack" (A),
 	 *        still waiting for the barrier ack.
 	 *        master_bio may already be completed and invalidated.
-	 * 11100: write_acked (C),
-	 *        data_received (for remote read, any protocol)
+	 * 11100: write acked (C),
+	 *        data received (for remote read, any protocol)
 	 *        or finally the barrier ack has arrived (B,A)...
 	 *        request can be freed
 	 * 01100: neg-acked (write, protocol C)
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 1ddf6b6..550617b 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -209,12 +209,12 @@ void drbd_endio_pri(struct bio *bio, int error)
 	/* to avoid recursion in __req_mod */
 	if (unlikely(error)) {
 		what = (bio_data_dir(bio) == WRITE)
-			? write_completed_with_error
+			? WRITE_COMPLETED_WITH_ERROR
 			: (bio_rw(bio) == READ)
-			  ? read_completed_with_error
-			  : read_ahead_completed_with_error;
+			  ? READ_COMPLETED_WITH_ERROR
+			  : READ_AHEAD_COMPLETED_WITH_ERROR;
 	} else
-		what = completed_ok;
+		what = COMPLETED_OK;
 
 	bio_put(req->private_bio);
 	req->private_bio = ERR_PTR(error);
@@ -238,7 +238,7 @@ int w_read_retry_remote(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 
 	spin_lock_irq(&mdev->req_lock);
 	if (cancel || mdev->state.pdsk != D_UP_TO_DATE) {
-		_req_mod(req, read_retry_remote_canceled);
+		_req_mod(req, READ_RETRY_REMOTE_CANCELED);
 		spin_unlock_irq(&mdev->req_lock);
 		return 1;
 	}
@@ -1243,12 +1243,12 @@ int w_send_oos(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	int ok;
 
 	if (unlikely(cancel)) {
-		req_mod(req, send_canceled);
+		req_mod(req, SEND_CANCELED);
 		return 1;
 	}
 
 	ok = drbd_send_oos(mdev, req);
-	req_mod(req, oos_handed_to_network);
+	req_mod(req, OOS_HANDED_TO_NETWORK);
 
 	return ok;
 }
@@ -1265,12 +1265,12 @@ int w_send_dblock(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	int ok;
 
 	if (unlikely(cancel)) {
-		req_mod(req, send_canceled);
+		req_mod(req, SEND_CANCELED);
 		return 1;
 	}
 
 	ok = drbd_send_dblock(mdev, req);
-	req_mod(req, ok ? handed_over_to_network : send_failed);
+	req_mod(req, ok ? HANDED_OVER_TO_NETWORK : SEND_FAILED);
 
 	return ok;
 }
@@ -1287,7 +1287,7 @@ int w_send_read_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	int ok;
 
 	if (unlikely(cancel)) {
-		req_mod(req, send_canceled);
+		req_mod(req, SEND_CANCELED);
 		return 1;
 	}
 
@@ -1300,7 +1300,7 @@ int w_send_read_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 		if (mdev->state.conn >= C_CONNECTED)
 			drbd_force_state(mdev, NS(conn, C_NETWORK_FAILURE));
 	}
-	req_mod(req, ok ? handed_over_to_network : send_failed);
+	req_mod(req, ok ? HANDED_OVER_TO_NETWORK : SEND_FAILED);
 
 	return ok;
 }
-- 
1.7.4.1

