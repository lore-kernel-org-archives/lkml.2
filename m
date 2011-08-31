Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475Ab1HaPOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 11:14:21 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59853 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab1HaPLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 11:11:13 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 04/16] drbd: Improve how conflicting writes are handled
Date: Wed, 31 Aug 2011 17:10:56 +0200
Message-Id: <1314803468-1201-5-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
References: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

The previous algorithm for dealing with overlapping concurrent writes
was generating unnecessary warnings for scenarios which could be
legitimate, and did not always handle partially overlapping requests
correctly.  Improve it algorithm as follows:

* While local or remote write requests are in progress, conflicting new
  local write requests will be delayed (commit 82172f7).

* When a conflict between a local and remote write request is detected,
  the node with the discard flag decides how to resolve the conflict: It
  will ask its peer to discard conflicting requests which are fully
  contained in the local request and retry requests which overlap only
  partially.  This involves a protocol change.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |   15 +-
 drivers/block/drbd/drbd_main.c     |   35 +++-
 drivers/block/drbd/drbd_receiver.c |  410 ++++++++++++++++++++++--------------
 drivers/block/drbd/drbd_req.c      |   75 ++++---
 drivers/block/drbd/drbd_req.h      |    7 +-
 5 files changed, 351 insertions(+), 191 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 482bd7e..cda1039 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -200,7 +200,7 @@ enum drbd_packet {
 	P_RECV_ACK	      = 0x15, /* Used in protocol B */
 	P_WRITE_ACK	      = 0x16, /* Used in protocol C */
 	P_RS_WRITE_ACK	      = 0x17, /* Is a P_WRITE_ACK, additionally call set_in_sync(). */
-	P_DISCARD_ACK	      = 0x18, /* Used in proto C, two-primaries conflict detection */
+	P_DISCARD_WRITE	      = 0x18, /* Used in proto C, two-primaries conflict detection */
 	P_NEG_ACK	      = 0x19, /* Sent if local disk is unusable */
 	P_NEG_DREPLY	      = 0x1a, /* Local disk is broken... */
 	P_NEG_RS_DREPLY	      = 0x1b, /* Local disk is broken... */
@@ -223,8 +223,9 @@ enum drbd_packet {
 	P_RS_CANCEL           = 0x29, /* meta: Used to cancel RS_DATA_REQUEST packet by SyncSource */
 	P_CONN_ST_CHG_REQ     = 0x2a, /* data sock: Connection wide state request */
 	P_CONN_ST_CHG_REPLY   = 0x2b, /* meta sock: Connection side state req reply */
+	P_RETRY_WRITE	      = 0x2c, /* Protocol C: retry conflicting write request */
 
-	P_MAX_CMD	      = 0x2c,
+	P_MAX_CMD	      = 0x2d,
 	P_MAY_IGNORE	      = 0x100, /* Flag to test if (cmd > P_MAY_IGNORE) ... */
 	P_MAX_OPT_CMD	      = 0x101,
 
@@ -350,7 +351,7 @@ struct p_data {
  * commands which share a struct:
  *  p_block_ack:
  *   P_RECV_ACK (proto B), P_WRITE_ACK (proto C),
- *   P_DISCARD_ACK (proto C, two-primaries conflict detection)
+ *   P_DISCARD_WRITE (proto C, two-primaries conflict detection)
  *  p_block_req:
  *   P_DATA_REQUEST, P_RS_DATA_REQUEST
  */
@@ -362,7 +363,6 @@ struct p_block_ack {
 	u32	    seq_num;
 } __packed;
 
-
 struct p_block_req {
 	struct p_header head;
 	u64 sector;
@@ -655,6 +655,8 @@ struct drbd_work {
 
 #include "drbd_interval.h"
 
+extern int drbd_wait_misc(struct drbd_conf *, struct drbd_interval *);
+
 struct drbd_request {
 	struct drbd_work w;
 
@@ -752,12 +754,16 @@ enum {
 
 	/* This ee has a pointer to a digest instead of a block id */
 	__EE_HAS_DIGEST,
+
+	/* Conflicting local requests need to be restarted after this request */
+	__EE_RESTART_REQUESTS,
 };
 #define EE_CALL_AL_COMPLETE_IO (1<<__EE_CALL_AL_COMPLETE_IO)
 #define EE_MAY_SET_IN_SYNC     (1<<__EE_MAY_SET_IN_SYNC)
 #define	EE_RESUBMITTED         (1<<__EE_RESUBMITTED)
 #define EE_WAS_ERROR           (1<<__EE_WAS_ERROR)
 #define EE_HAS_DIGEST          (1<<__EE_HAS_DIGEST)
+#define EE_RESTART_REQUESTS	(1<<__EE_RESTART_REQUESTS)
 
 /* flag bits per mdev */
 enum {
@@ -1478,6 +1484,7 @@ extern void drbd_free_tconn(struct drbd_tconn *tconn);
 extern int proc_details;
 
 /* drbd_req */
+extern int __drbd_make_request(struct drbd_conf *, struct bio *, unsigned long);
 extern int drbd_make_request(struct request_queue *q, struct bio *bio);
 extern int drbd_read_remote(struct drbd_conf *mdev, struct drbd_request *req);
 extern int drbd_merge_bvec(struct request_queue *q, struct bvec_merge_data *bvm, struct bio_vec *bvec);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index e9e60d8..e71b6bf 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -3004,7 +3004,7 @@ const char *cmdname(enum drbd_packet cmd)
 		[P_RECV_ACK]	        = "RecvAck",
 		[P_WRITE_ACK]	        = "WriteAck",
 		[P_RS_WRITE_ACK]	= "RSWriteAck",
-		[P_DISCARD_ACK]	        = "DiscardAck",
+		[P_DISCARD_WRITE]        = "DiscardWrite",
 		[P_NEG_ACK]	        = "NegAck",
 		[P_NEG_DREPLY]	        = "NegDReply",
 		[P_NEG_RS_DREPLY]	= "NegRSDReply",
@@ -3019,6 +3019,7 @@ const char *cmdname(enum drbd_packet cmd)
 		[P_COMPRESSED_BITMAP]   = "CBitmap",
 		[P_DELAY_PROBE]         = "DelayProbe",
 		[P_OUT_OF_SYNC]		= "OutOfSync",
+		[P_RETRY_WRITE]		= "RetryWrite",
 		[P_MAX_CMD]	        = NULL,
 	};
 
@@ -3033,6 +3034,38 @@ const char *cmdname(enum drbd_packet cmd)
 	return cmdnames[cmd];
 }
 
+/**
+ * drbd_wait_misc  -  wait for a request to make progress
+ * @mdev:	device associated with the request
+ * @i:		the struct drbd_interval embedded in struct drbd_request or
+ *		struct drbd_peer_request
+ */
+int drbd_wait_misc(struct drbd_conf *mdev, struct drbd_interval *i)
+{
+	struct net_conf *net_conf = mdev->tconn->net_conf;
+	DEFINE_WAIT(wait);
+	long timeout;
+
+	if (!net_conf)
+		return -ETIMEDOUT;
+	timeout = MAX_SCHEDULE_TIMEOUT;
+	if (net_conf->ko_count)
+		timeout = net_conf->timeout * HZ / 10 * net_conf->ko_count;
+
+	/* Indicate to wake up mdev->misc_wait on progress.  */
+	i->waiting = true;
+	prepare_to_wait(&mdev->misc_wait, &wait, TASK_INTERRUPTIBLE);
+	spin_unlock_irq(&mdev->tconn->req_lock);
+	timeout = schedule_timeout(timeout);
+	finish_wait(&mdev->misc_wait, &wait);
+	spin_lock_irq(&mdev->tconn->req_lock);
+	if (!timeout || mdev->state.conn < C_CONNECTED)
+		return -ETIMEDOUT;
+	if (signal_pending(current))
+		return -ERESTARTSYS;
+	return 0;
+}
+
 #ifdef CONFIG_DRBD_FAULT_INJECTION
 /* Fault insertion support including random number generator shamelessly
  * stolen from kernel/rcutorture.c */
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 07fc7c1..6d19b57 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -415,7 +415,7 @@ static int drbd_process_done_ee(struct drbd_conf *mdev)
 		drbd_free_net_ee(mdev, peer_req);
 
 	/* possible callbacks here:
-	 * e_end_block, and e_end_resync_block, e_send_discard_ack.
+	 * e_end_block, and e_end_resync_block, e_send_discard_write.
 	 * all ignore the last argument.
 	 */
 	list_for_each_entry_safe(peer_req, t, &work_list, w.list) {
@@ -1592,6 +1592,51 @@ static int receive_RSDataReply(struct drbd_conf *mdev, enum drbd_packet cmd,
 	return ok;
 }
 
+static int w_restart_write(struct drbd_work *w, int cancel)
+{
+	struct drbd_request *req = container_of(w, struct drbd_request, w);
+	struct drbd_conf *mdev = w->mdev;
+	struct bio *bio;
+	unsigned long start_time;
+	unsigned long flags;
+
+	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
+	if (!expect(req->rq_state & RQ_POSTPONED)) {
+		spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
+		return 0;
+	}
+	bio = req->master_bio;
+	start_time = req->start_time;
+	/* Postponed requests will not have their master_bio completed!  */
+	__req_mod(req, DISCARD_WRITE, NULL);
+	spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
+
+	while (__drbd_make_request(mdev, bio, start_time))
+		/* retry */ ;
+	return 1;
+}
+
+static void restart_conflicting_writes(struct drbd_conf *mdev,
+				       sector_t sector, int size)
+{
+	struct drbd_interval *i;
+	struct drbd_request *req;
+
+	drbd_for_each_overlap(i, &mdev->write_requests, sector, size) {
+		if (!i->local)
+			continue;
+		req = container_of(i, struct drbd_request, i);
+		if (req->rq_state & RQ_LOCAL_PENDING ||
+		    !(req->rq_state & RQ_POSTPONED))
+			continue;
+		if (expect(list_empty(&req->w.list))) {
+			req->w.mdev = mdev;
+			req->w.cb = w_restart_write;
+			drbd_queue_work(&mdev->tconn->data.work, &req->w);
+		}
+	}
+}
+
 /* e_end_block() is called via drbd_process_done_ee().
  * this means this function only runs in the asender thread
  */
@@ -1625,6 +1670,8 @@ static int e_end_block(struct drbd_work *w, int cancel)
 		spin_lock_irq(&mdev->tconn->req_lock);
 		D_ASSERT(!drbd_interval_empty(&peer_req->i));
 		drbd_remove_epoch_entry_interval(mdev, peer_req);
+		if (peer_req->flags & EE_RESTART_REQUESTS)
+			restart_conflicting_writes(mdev, sector, peer_req->i.size);
 		spin_unlock_irq(&mdev->tconn->req_lock);
 	} else
 		D_ASSERT(drbd_interval_empty(&peer_req->i));
@@ -1634,20 +1681,32 @@ static int e_end_block(struct drbd_work *w, int cancel)
 	return ok;
 }
 
-static int e_send_discard_ack(struct drbd_work *w, int unused)
+static int e_send_ack(struct drbd_work *w, enum drbd_packet ack)
 {
+	struct drbd_conf *mdev = w->mdev;
 	struct drbd_peer_request *peer_req =
 		container_of(w, struct drbd_peer_request, w);
-	struct drbd_conf *mdev = w->mdev;
 	int ok;
 
-	D_ASSERT(mdev->tconn->net_conf->wire_protocol == DRBD_PROT_C);
-	ok = drbd_send_ack(mdev, P_DISCARD_ACK, peer_req);
+	ok = drbd_send_ack(mdev, ack, peer_req);
 	dec_unacked(mdev);
 
 	return ok;
 }
 
+static int e_send_discard_write(struct drbd_work *w, int unused)
+{
+	return e_send_ack(w, P_DISCARD_WRITE);
+}
+
+static int e_send_retry_write(struct drbd_work *w, int unused)
+{
+	struct drbd_tconn *tconn = w->mdev->tconn;
+
+	return e_send_ack(w, tconn->agreed_pro_version >= 100 ?
+			     P_RETRY_WRITE : P_DISCARD_WRITE);
+}
+
 static bool seq_greater(u32 a, u32 b)
 {
 	/*
@@ -1663,16 +1722,31 @@ static u32 seq_max(u32 a, u32 b)
 	return seq_greater(a, b) ? a : b;
 }
 
+static bool need_peer_seq(struct drbd_conf *mdev)
+{
+	struct drbd_tconn *tconn = mdev->tconn;
+
+	/*
+	 * We only need to keep track of the last packet_seq number of our peer
+	 * if we are in dual-primary mode and we have the discard flag set; see
+	 * handle_write_conflicts().
+	 */
+	return tconn->net_conf->two_primaries &&
+	       test_bit(DISCARD_CONCURRENT, &tconn->flags);
+}
+
 static void update_peer_seq(struct drbd_conf *mdev, unsigned int peer_seq)
 {
 	unsigned int old_peer_seq;
 
-	spin_lock(&mdev->peer_seq_lock);
-	old_peer_seq = mdev->peer_seq;
-	mdev->peer_seq = seq_max(mdev->peer_seq, peer_seq);
-	spin_unlock(&mdev->peer_seq_lock);
-	if (old_peer_seq != peer_seq)
-		wake_up(&mdev->seq_wait);
+	if (need_peer_seq(mdev)) {
+		spin_lock(&mdev->peer_seq_lock);
+		old_peer_seq = mdev->peer_seq;
+		mdev->peer_seq = seq_max(mdev->peer_seq, peer_seq);
+		spin_unlock(&mdev->peer_seq_lock);
+		if (old_peer_seq != peer_seq)
+			wake_up(&mdev->seq_wait);
+	}
 }
 
 /* Called from receive_Data.
@@ -1696,36 +1770,39 @@ static void update_peer_seq(struct drbd_conf *mdev, unsigned int peer_seq)
  *
  * returns 0 if we may process the packet,
  * -ERESTARTSYS if we were interrupted (by disconnect signal). */
-static int drbd_wait_peer_seq(struct drbd_conf *mdev, const u32 packet_seq)
+static int wait_for_and_update_peer_seq(struct drbd_conf *mdev, const u32 peer_seq)
 {
 	DEFINE_WAIT(wait);
-	unsigned int p_seq;
 	long timeout;
-	int ret = 0;
+	int ret;
+
+	if (!need_peer_seq(mdev))
+		return 0;
+
 	spin_lock(&mdev->peer_seq_lock);
 	for (;;) {
-		prepare_to_wait(&mdev->seq_wait, &wait, TASK_INTERRUPTIBLE);
-		if (!seq_greater(packet_seq, mdev->peer_seq + 1))
+		if (!seq_greater(peer_seq - 1, mdev->peer_seq)) {
+			mdev->peer_seq = seq_max(mdev->peer_seq, peer_seq);
+			ret = 0;
 			break;
+		}
 		if (signal_pending(current)) {
 			ret = -ERESTARTSYS;
 			break;
 		}
-		p_seq = mdev->peer_seq;
+		prepare_to_wait(&mdev->seq_wait, &wait, TASK_INTERRUPTIBLE);
 		spin_unlock(&mdev->peer_seq_lock);
 		timeout = mdev->tconn->net_conf->ping_timeo*HZ/10;
 		timeout = schedule_timeout(timeout);
 		spin_lock(&mdev->peer_seq_lock);
-		if (timeout == 0 && p_seq == mdev->peer_seq) {
+		if (!timeout) {
 			ret = -ETIMEDOUT;
 			dev_err(DEV, "Timed out waiting for missing ack packets; disconnecting\n");
 			break;
 		}
 	}
-	finish_wait(&mdev->seq_wait, &wait);
-	if (mdev->peer_seq+1 == packet_seq)
-		mdev->peer_seq++;
 	spin_unlock(&mdev->peer_seq_lock);
+	finish_wait(&mdev->seq_wait, &wait);
 	return ret;
 }
 
@@ -1740,6 +1817,139 @@ static unsigned long wire_flags_to_bio(struct drbd_conf *mdev, u32 dpf)
 		(dpf & DP_DISCARD ? REQ_DISCARD : 0);
 }
 
+static void fail_postponed_requests(struct drbd_conf *mdev, sector_t sector,
+				    unsigned int size)
+{
+	struct drbd_interval *i;
+
+    repeat:
+	drbd_for_each_overlap(i, &mdev->write_requests, sector, size) {
+		struct drbd_request *req;
+		struct bio_and_error m;
+
+		if (!i->local)
+			continue;
+		req = container_of(i, struct drbd_request, i);
+		if (!(req->rq_state & RQ_POSTPONED))
+			continue;
+		req->rq_state &= ~RQ_POSTPONED;
+		__req_mod(req, NEG_ACKED, &m);
+		spin_unlock_irq(&mdev->tconn->req_lock);
+		if (m.bio)
+			complete_master_bio(mdev, &m);
+		spin_lock_irq(&mdev->tconn->req_lock);
+		goto repeat;
+	}
+}
+
+static int handle_write_conflicts(struct drbd_conf *mdev,
+				  struct drbd_peer_request *peer_req)
+{
+	struct drbd_tconn *tconn = mdev->tconn;
+	bool resolve_conflicts = test_bit(DISCARD_CONCURRENT, &tconn->flags);
+	sector_t sector = peer_req->i.sector;
+	const unsigned int size = peer_req->i.size;
+	struct drbd_interval *i;
+	bool equal;
+	int err;
+
+	/*
+	 * Inserting the peer request into the write_requests tree will prevent
+	 * new conflicting local requests from being added.
+	 */
+	drbd_insert_interval(&mdev->write_requests, &peer_req->i);
+
+    repeat:
+	drbd_for_each_overlap(i, &mdev->write_requests, sector, size) {
+		if (i == &peer_req->i)
+			continue;
+
+		if (!i->local) {
+			/*
+			 * Our peer has sent a conflicting remote request; this
+			 * should not happen in a two-node setup.  Wait for the
+			 * earlier peer request to complete.
+			 */
+			err = drbd_wait_misc(mdev, i);
+			if (err)
+				goto out;
+			goto repeat;
+		}
+
+		equal = i->sector == sector && i->size == size;
+		if (resolve_conflicts) {
+			/*
+			 * If the peer request is fully contained within the
+			 * overlapping request, it can be discarded; otherwise,
+			 * it will be retried once all overlapping requests
+			 * have completed.
+			 */
+			bool discard = i->sector <= sector && i->sector +
+				       (i->size >> 9) >= sector + (size >> 9);
+
+			if (!equal)
+				dev_alert(DEV, "Concurrent writes detected: "
+					       "local=%llus +%u, remote=%llus +%u, "
+					       "assuming %s came first\n",
+					  (unsigned long long)i->sector, i->size,
+					  (unsigned long long)sector, size,
+					  discard ? "local" : "remote");
+
+			inc_unacked(mdev);
+			peer_req->w.cb = discard ? e_send_discard_write :
+						   e_send_retry_write;
+			list_add_tail(&peer_req->w.list, &mdev->done_ee);
+			wake_asender(mdev->tconn);
+
+			err = -ENOENT;
+			goto out;
+		} else {
+			struct drbd_request *req =
+				container_of(i, struct drbd_request, i);
+
+			if (!equal)
+				dev_alert(DEV, "Concurrent writes detected: "
+					       "local=%llus +%u, remote=%llus +%u\n",
+					  (unsigned long long)i->sector, i->size,
+					  (unsigned long long)sector, size);
+
+			if (req->rq_state & RQ_LOCAL_PENDING ||
+			    !(req->rq_state & RQ_POSTPONED)) {
+				/*
+				 * Wait for the node with the discard flag to
+				 * decide if this request will be discarded or
+				 * retried.  Requests that are discarded will
+				 * disappear from the write_requests tree.
+				 *
+				 * In addition, wait for the conflicting
+				 * request to finish locally before submitting
+				 * the conflicting peer request.
+				 */
+				err = drbd_wait_misc(mdev, &req->i);
+				if (err) {
+					_conn_request_state(mdev->tconn,
+							    NS(conn, C_TIMEOUT),
+							    CS_HARD);
+					fail_postponed_requests(mdev, sector, size);
+					goto out;
+				}
+				goto repeat;
+			}
+			/*
+			 * Remember to restart the conflicting requests after
+			 * the new peer request has completed.
+			 */
+			peer_req->flags |= EE_RESTART_REQUESTS;
+		}
+	}
+	err = 0;
+
+    out:
+	if (err)
+		drbd_remove_epoch_entry_interval(mdev, peer_req);
+	return err;
+}
+
 /* mirrored write */
 static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 			unsigned int data_size)
@@ -1747,18 +1957,17 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 	sector_t sector;
 	struct drbd_peer_request *peer_req;
 	struct p_data *p = &mdev->tconn->data.rbuf.data;
+	u32 peer_seq = be32_to_cpu(p->seq_num);
 	int rw = WRITE;
 	u32 dp_flags;
+	int err;
 
-	if (!get_ldev(mdev)) {
-		spin_lock(&mdev->peer_seq_lock);
-		if (mdev->peer_seq+1 == be32_to_cpu(p->seq_num))
-			mdev->peer_seq++;
-		spin_unlock(&mdev->peer_seq_lock);
 
+	if (!get_ldev(mdev)) {
+		err = wait_for_and_update_peer_seq(mdev, peer_seq);
 		drbd_send_ack_dp(mdev, P_NEG_ACK, p, data_size);
 		atomic_inc(&mdev->current_epoch->epoch_size);
-		return drbd_drain_block(mdev, data_size);
+		return drbd_drain_block(mdev, data_size) && err == 0;
 	}
 
 	/*
@@ -1788,137 +1997,22 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 	atomic_inc(&peer_req->epoch->active);
 	spin_unlock(&mdev->epoch_lock);
 
-	/* I'm the receiver, I do hold a net_cnt reference. */
-	if (!mdev->tconn->net_conf->two_primaries) {
-		spin_lock_irq(&mdev->tconn->req_lock);
-	} else {
-		/* don't get the req_lock yet,
-		 * we may sleep in drbd_wait_peer_seq */
-		const int size = peer_req->i.size;
-		const int discard = test_bit(DISCARD_CONCURRENT, &mdev->tconn->flags);
-		DEFINE_WAIT(wait);
-		int first;
-
-		D_ASSERT(mdev->tconn->net_conf->wire_protocol == DRBD_PROT_C);
-
-		/* conflict detection and handling:
-		 * 1. wait on the sequence number,
-		 *    in case this data packet overtook ACK packets.
-		 * 2. check for conflicting write requests.
-		 *
-		 * Note: for two_primaries, we are protocol C,
-		 * so there cannot be any request that is DONE
-		 * but still on the transfer log.
-		 *
-		 * if no conflicting request is found:
-		 *    submit.
-		 *
-		 * if any conflicting request is found
-		 * that has not yet been acked,
-		 * AND I have the "discard concurrent writes" flag:
-		 *	 queue (via done_ee) the P_DISCARD_ACK; OUT.
-		 *
-		 * if any conflicting request is found:
-		 *	 block the receiver, waiting on misc_wait
-		 *	 until no more conflicting requests are there,
-		 *	 or we get interrupted (disconnect).
-		 *
-		 *	 we do not just write after local io completion of those
-		 *	 requests, but only after req is done completely, i.e.
-		 *	 we wait for the P_DISCARD_ACK to arrive!
-		 *
-		 *	 then proceed normally, i.e. submit.
-		 */
-		if (drbd_wait_peer_seq(mdev, be32_to_cpu(p->seq_num)))
+	if (mdev->tconn->net_conf->two_primaries) {
+		err = wait_for_and_update_peer_seq(mdev, peer_seq);
+		if (err)
 			goto out_interrupted;
-
 		spin_lock_irq(&mdev->tconn->req_lock);
-
-		/*
-		 * Inserting the peer request into the write_requests tree will
-		 * prevent new conflicting local requests from being added.
-		 */
-		drbd_insert_interval(&mdev->write_requests, &peer_req->i);
-
-		first = 1;
-		for (;;) {
-			struct drbd_interval *i;
-			int have_unacked = 0;
-			int have_conflict = 0;
-			prepare_to_wait(&mdev->misc_wait, &wait,
-				TASK_INTERRUPTIBLE);
-
-			drbd_for_each_overlap(i, &mdev->write_requests, sector, size) {
-				struct drbd_request *req2;
-
-				if (i == &peer_req->i || !i->local)
-					continue;
-
-				/* only ALERT on first iteration,
-				 * we may be woken up early... */
-				if (first)
-					dev_alert(DEV, "%s[%u] Concurrent local write detected!"
-					      "	new: %llus +%u; pending: %llus +%u\n",
-					      current->comm, current->pid,
-					      (unsigned long long)sector, size,
-					      (unsigned long long)i->sector, i->size);
-
-				req2 = container_of(i, struct drbd_request, i);
-				if (req2->rq_state & RQ_NET_PENDING)
-					++have_unacked;
-				++have_conflict;
-				break;
-			}
-			if (!have_conflict)
-				break;
-
-			/* Discard Ack only for the _first_ iteration */
-			if (first && discard && have_unacked) {
-				dev_alert(DEV, "Concurrent write! [DISCARD BY FLAG] sec=%llus\n",
-				     (unsigned long long)sector);
-				drbd_remove_epoch_entry_interval(mdev, peer_req);
-				inc_unacked(mdev);
-				peer_req->w.cb = e_send_discard_ack;
-				list_add_tail(&peer_req->w.list, &mdev->done_ee);
-
-				spin_unlock_irq(&mdev->tconn->req_lock);
-
-				/* we could probably send that P_DISCARD_ACK ourselves,
-				 * but I don't like the receiver using the msock */
-
+		err = handle_write_conflicts(mdev, peer_req);
+		if (err) {
+			spin_unlock_irq(&mdev->tconn->req_lock);
+			if (err == -ENOENT) {
 				put_ldev(mdev);
-				wake_asender(mdev->tconn);
-				finish_wait(&mdev->misc_wait, &wait);
 				return true;
 			}
-
-			if (signal_pending(current)) {
-				drbd_remove_epoch_entry_interval(mdev, peer_req);
-				spin_unlock_irq(&mdev->tconn->req_lock);
-				finish_wait(&mdev->misc_wait, &wait);
-				goto out_interrupted;
-			}
-
-			/* Indicate to wake up mdev->misc_wait upon completion.  */
-			i->waiting = true;
-
-			spin_unlock_irq(&mdev->tconn->req_lock);
-			if (first) {
-				first = 0;
-				dev_alert(DEV, "Concurrent write! [W AFTERWARDS] "
-				     "sec=%llus\n", (unsigned long long)sector);
-			} else if (discard) {
-				/* we had none on the first iteration.
-				 * there must be none now. */
-				D_ASSERT(have_unacked == 0);
-			}
-			/* FIXME: Introduce a timeout here after which we disconnect.  */
-			schedule();
-			spin_lock_irq(&mdev->tconn->req_lock);
+			goto out_interrupted;
 		}
-		finish_wait(&mdev->misc_wait, &wait);
-	}
-
+	} else
+		spin_lock_irq(&mdev->tconn->req_lock);
 	list_add(&peer_req->w.list, &mdev->active_ee);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
@@ -4396,9 +4490,13 @@ static int got_BlockAck(struct drbd_conf *mdev, enum drbd_packet cmd)
 		D_ASSERT(mdev->tconn->net_conf->wire_protocol == DRBD_PROT_B);
 		what = RECV_ACKED_BY_PEER;
 		break;
-	case P_DISCARD_ACK:
+	case P_DISCARD_WRITE:
 		D_ASSERT(mdev->tconn->net_conf->wire_protocol == DRBD_PROT_C);
-		what = CONFLICT_DISCARDED_BY_PEER;
+		what = DISCARD_WRITE;
+		break;
+	case P_RETRY_WRITE:
+		D_ASSERT(mdev->tconn->net_conf->wire_protocol == DRBD_PROT_C);
+		what = POSTPONE_WRITE;
 		break;
 	default:
 		D_ASSERT(0);
@@ -4449,6 +4547,7 @@ static int got_NegDReply(struct drbd_conf *mdev, enum drbd_packet cmd)
 	sector_t sector = be64_to_cpu(p->sector);
 
 	update_peer_seq(mdev, be32_to_cpu(p->seq_num));
+
 	dev_err(DEV, "Got NegDReply; Sector %llus, len %u; Fail original request.\n",
 	    (unsigned long long)sector, be32_to_cpu(p->blksize));
 
@@ -4570,7 +4669,7 @@ static struct asender_cmd *get_asender_cmd(int cmd)
 	[P_RECV_ACK]	    = { sizeof(struct p_block_ack), got_BlockAck },
 	[P_WRITE_ACK]	    = { sizeof(struct p_block_ack), got_BlockAck },
 	[P_RS_WRITE_ACK]    = { sizeof(struct p_block_ack), got_BlockAck },
-	[P_DISCARD_ACK]	    = { sizeof(struct p_block_ack), got_BlockAck },
+	[P_DISCARD_WRITE]   = { sizeof(struct p_block_ack), got_BlockAck },
 	[P_NEG_ACK]	    = { sizeof(struct p_block_ack), got_NegAck },
 	[P_NEG_DREPLY]	    = { sizeof(struct p_block_ack), got_NegDReply },
 	[P_NEG_RS_DREPLY]   = { sizeof(struct p_block_ack), got_NegRSDReply},
@@ -4581,6 +4680,7 @@ static struct asender_cmd *get_asender_cmd(int cmd)
 	[P_DELAY_PROBE]     = { sizeof(struct p_delay_probe93), got_skip },
 	[P_RS_CANCEL]       = { sizeof(struct p_block_ack), got_NegRSDReply},
 	[P_CONN_ST_CHG_REPLY]={ sizeof(struct p_req_state_reply), got_RqSReply },
+	[P_RETRY_WRITE]	    = { sizeof(struct p_block_ack), got_BlockAck },
 	[P_MAX_CMD]	    = { 0, NULL },
 	};
 	if (cmd > P_MAX_CMD || asender_tbl[cmd].process == NULL)
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 7332198..aab1acd 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -225,12 +225,16 @@ void _req_may_be_done(struct drbd_request *req, struct bio_and_error *m)
 	 *	the receiver,
 	 *	the bio_endio completion callbacks.
 	 */
+	if (s & RQ_LOCAL_PENDING)
+		return;
+	if (req->i.waiting) {
+		/* Retry all conflicting peer requests.  */
+		wake_up(&mdev->misc_wait);
+	}
 	if (s & RQ_NET_QUEUED)
 		return;
 	if (s & RQ_NET_PENDING)
 		return;
-	if (s & RQ_LOCAL_PENDING)
-		return;
 
 	if (req->master_bio) {
 		/* this is DATA_RECEIVED (remote read)
@@ -267,7 +271,7 @@ void _req_may_be_done(struct drbd_request *req, struct bio_and_error *m)
 			else
 				root = &mdev->read_requests;
 			drbd_remove_request_interval(root, req);
-		} else
+		} else if (!(s & RQ_POSTPONED))
 			D_ASSERT((s & (RQ_NET_MASK & ~RQ_NET_DONE)) == 0);
 
 		/* for writes we need to do some extra housekeeping */
@@ -277,8 +281,10 @@ void _req_may_be_done(struct drbd_request *req, struct bio_and_error *m)
 		/* Update disk stats */
 		_drbd_end_io_acct(mdev, req);
 
-		m->error = ok ? 0 : (error ?: -EIO);
-		m->bio = req->master_bio;
+		if (!(s & RQ_POSTPONED)) {
+			m->error = ok ? 0 : (error ?: -EIO);
+			m->bio = req->master_bio;
+		}
 		req->master_bio = NULL;
 	}
 
@@ -318,7 +324,9 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 {
 	struct drbd_conf *mdev = req->w.mdev;
 	int rv = 0;
-	m->bio = NULL;
+
+	if (m)
+		m->bio = NULL;
 
 	switch (what) {
 	default:
@@ -332,7 +340,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		*/
 
 	case TO_BE_SENT: /* via network */
-		/* reached via drbd_make_request_common
+		/* reached via __drbd_make_request
 		 * and from w_read_retry_remote */
 		D_ASSERT(!(req->rq_state & RQ_NET_MASK));
 		req->rq_state |= RQ_NET_PENDING;
@@ -340,7 +348,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		break;
 
 	case TO_BE_SUBMITTED: /* locally */
-		/* reached via drbd_make_request_common */
+		/* reached via __drbd_make_request */
 		D_ASSERT(!(req->rq_state & RQ_LOCAL_MASK));
 		req->rq_state |= RQ_LOCAL_PENDING;
 		break;
@@ -403,7 +411,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		 * no local disk,
 		 * or target area marked as invalid,
 		 * or just got an io-error. */
-		/* from drbd_make_request_common
+		/* from __drbd_make_request
 		 * or from bio_endio during read io-error recovery */
 
 		/* so we can verify the handle in the answer packet
@@ -422,7 +430,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 
 	case QUEUE_FOR_NET_WRITE:
 		/* assert something? */
-		/* from drbd_make_request_common only */
+		/* from __drbd_make_request only */
 
 		/* corresponding hlist_del is in _req_may_be_done() */
 		drbd_insert_interval(&mdev->write_requests, &req->i);
@@ -436,7 +444,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		 *
 		 * _req_add_to_epoch(req); this has to be after the
 		 * _maybe_start_new_epoch(req); which happened in
-		 * drbd_make_request_common, because we now may set the bit
+		 * __drbd_make_request, because we now may set the bit
 		 * again ourselves to close the current epoch.
 		 *
 		 * Add req to the (now) current epoch (barrier). */
@@ -446,7 +454,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		 * hurting performance. */
 		set_bit(UNPLUG_REMOTE, &mdev->flags);
 
-		/* see drbd_make_request_common,
+		/* see __drbd_make_request,
 		 * just after it grabs the req_lock */
 		D_ASSERT(test_bit(CREATE_BARRIER, &mdev->flags) == 0);
 
@@ -535,14 +543,10 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 
 	case WRITE_ACKED_BY_PEER_AND_SIS:
 		req->rq_state |= RQ_NET_SIS;
-	case CONFLICT_DISCARDED_BY_PEER:
+	case DISCARD_WRITE:
 		/* for discarded conflicting writes of multiple primaries,
 		 * there is no need to keep anything in the tl, potential
 		 * node crashes are covered by the activity log. */
-		if (what == CONFLICT_DISCARDED_BY_PEER)
-			dev_alert(DEV, "Got DiscardAck packet %llus +%u!"
-			      " DRBD is not a random data generator!\n",
-			      (unsigned long long)req->i.sector, req->i.size);
 		req->rq_state |= RQ_NET_DONE;
 		/* fall through */
 	case WRITE_ACKED_BY_PEER:
@@ -569,6 +573,17 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		_req_may_be_done_not_susp(req, m);
 		break;
 
+	case POSTPONE_WRITE:
+		/*
+		 * If this node has already detected the write conflict, the
+		 * worker will be waiting on misc_wait.  Wake it up once this
+		 * request has completed locally.
+		 */
+		D_ASSERT(req->rq_state & RQ_NET_PENDING);
+		req->rq_state |= RQ_POSTPONED;
+		_req_may_be_done_not_susp(req, m);
+		break;
+
 	case NEG_ACKED:
 		/* assert something? */
 		if (req->rq_state & RQ_NET_PENDING) {
@@ -688,24 +703,19 @@ static int complete_conflicting_writes(struct drbd_conf *mdev,
 				       sector_t sector, int size)
 {
 	for(;;) {
-		DEFINE_WAIT(wait);
 		struct drbd_interval *i;
+		int err;
 
 		i = drbd_find_overlap(&mdev->write_requests, sector, size);
 		if (!i)
 			return 0;
-		i->waiting = true;
-		prepare_to_wait(&mdev->misc_wait, &wait, TASK_INTERRUPTIBLE);
-		spin_unlock_irq(&mdev->tconn->req_lock);
-		schedule();
-		finish_wait(&mdev->misc_wait, &wait);
-		spin_lock_irq(&mdev->tconn->req_lock);
-		if (signal_pending(current))
-			return -ERESTARTSYS;
+		err = drbd_wait_misc(mdev, i);
+		if (err)
+			return err;
 	}
 }
 
-static int drbd_make_request_common(struct drbd_conf *mdev, struct bio *bio, unsigned long start_time)
+int __drbd_make_request(struct drbd_conf *mdev, struct bio *bio, unsigned long start_time)
 {
 	const int rw = bio_rw(bio);
 	const int size = bio->bi_size;
@@ -811,7 +821,12 @@ allocate_barrier:
 	if (rw == WRITE) {
 		err = complete_conflicting_writes(mdev, sector, size);
 		if (err) {
+			if (err != -ERESTARTSYS)
+				_conn_request_state(mdev->tconn,
+						    NS(conn, C_TIMEOUT),
+						    CS_HARD);
 			spin_unlock_irq(&mdev->tconn->req_lock);
+			err = -EIO;
 			goto fail_free_complete;
 		}
 	}
@@ -1031,7 +1046,7 @@ int drbd_make_request(struct request_queue *q, struct bio *bio)
 
 	if (likely(s_enr == e_enr)) {
 		inc_ap_bio(mdev, 1);
-		return drbd_make_request_common(mdev, bio, start_time);
+		return __drbd_make_request(mdev, bio, start_time);
 	}
 
 	/* can this bio be split generically?
@@ -1069,10 +1084,10 @@ int drbd_make_request(struct request_queue *q, struct bio *bio)
 
 		D_ASSERT(e_enr == s_enr + 1);
 
-		while (drbd_make_request_common(mdev, &bp->bio1, start_time))
+		while (__drbd_make_request(mdev, &bp->bio1, start_time))
 			inc_ap_bio(mdev, 1);
 
-		while (drbd_make_request_common(mdev, &bp->bio2, start_time))
+		while (__drbd_make_request(mdev, &bp->bio2, start_time))
 			inc_ap_bio(mdev, 1);
 
 		dec_ap_bio(mdev);
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index e6f2361..0b3cd41 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -97,7 +97,8 @@ enum drbd_req_event {
 	RECV_ACKED_BY_PEER,
 	WRITE_ACKED_BY_PEER,
 	WRITE_ACKED_BY_PEER_AND_SIS, /* and set_in_sync */
-	CONFLICT_DISCARDED_BY_PEER,
+	DISCARD_WRITE,
+	POSTPONE_WRITE,
 	NEG_ACKED,
 	BARRIER_ACKED, /* in protocol A and B */
 	DATA_RECEIVED, /* (remote read) */
@@ -194,6 +195,9 @@ enum drbd_req_state_bits {
 
 	/* Should call drbd_al_complete_io() for this request... */
 	__RQ_IN_ACT_LOG,
+
+	/* The peer has sent a retry ACK */
+	__RQ_POSTPONED,
 };
 
 #define RQ_LOCAL_PENDING   (1UL << __RQ_LOCAL_PENDING)
@@ -214,6 +218,7 @@ enum drbd_req_state_bits {
 
 #define RQ_WRITE           (1UL << __RQ_WRITE)
 #define RQ_IN_ACT_LOG      (1UL << __RQ_IN_ACT_LOG)
+#define RQ_POSTPONED	   (1UL << __RQ_POSTPONED)
 
 /* For waking up the frozen transfer log mod_req() has to return if the request
    should be counted in the epoch object*/
-- 
1.7.4.1

