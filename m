Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab1IGQvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:51:54 -0400
Received: from mail09.linbit.com ([212.69.161.110]:48566 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab1IGQp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:45:57 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 13/14] drbd: Pass struct packet_info down to the receive functions
Date: Wed,  7 Sep 2011 16:17:40 +0200
Message-Id: <1315405061-1473-14-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315405061-1473-1-git-send-email-philipp.reisner@linbit.com>
References: <1315405061-1473-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |  150 ++++++++++++++++--------------------
 1 files changed, 65 insertions(+), 85 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 227cddc..856ac23 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -50,8 +50,8 @@
 
 struct packet_info {
 	enum drbd_packet cmd;
-	int size;
-	int vnr;
+	unsigned int size;
+	unsigned int vnr;
 };
 
 enum finish_epoch {
@@ -1543,8 +1543,7 @@ find_request(struct drbd_conf *mdev, struct rb_root *root, u64 id,
 	return NULL;
 }
 
-static int receive_DataReply(struct drbd_conf *mdev, enum drbd_packet cmd,
-			     unsigned int data_size)
+static int receive_DataReply(struct drbd_conf *mdev, struct packet_info *pi)
 {
 	struct drbd_request *req;
 	sector_t sector;
@@ -1562,7 +1561,7 @@ static int receive_DataReply(struct drbd_conf *mdev, enum drbd_packet cmd,
 	/* hlist_del(&req->collision) is done in _req_may_be_done, to avoid
 	 * special casing it there for the various failure cases.
 	 * still no race with drbd_fail_pending_reads */
-	err = recv_dless_read(mdev, req, sector, data_size);
+	err = recv_dless_read(mdev, req, sector, pi->size);
 	if (!err)
 		req_mod(req, DATA_RECEIVED);
 	/* else: nothing. handled from drbd_disconnect...
@@ -1572,8 +1571,7 @@ static int receive_DataReply(struct drbd_conf *mdev, enum drbd_packet cmd,
 	return err;
 }
 
-static int receive_RSDataReply(struct drbd_conf *mdev, enum drbd_packet cmd,
-			       unsigned int data_size)
+static int receive_RSDataReply(struct drbd_conf *mdev, struct packet_info *pi)
 {
 	sector_t sector;
 	int err;
@@ -1586,17 +1584,17 @@ static int receive_RSDataReply(struct drbd_conf *mdev, enum drbd_packet cmd,
 		/* data is submitted to disk within recv_resync_read.
 		 * corresponding put_ldev done below on error,
 		 * or in drbd_peer_request_endio. */
-		err = recv_resync_read(mdev, sector, data_size);
+		err = recv_resync_read(mdev, sector, pi->size);
 	} else {
 		if (__ratelimit(&drbd_ratelimit_state))
 			dev_err(DEV, "Can not write resync data to local disk.\n");
 
-		err = drbd_drain_block(mdev, data_size);
+		err = drbd_drain_block(mdev, pi->size);
 
-		drbd_send_ack_dp(mdev, P_NEG_ACK, p, data_size);
+		drbd_send_ack_dp(mdev, P_NEG_ACK, p, pi->size);
 	}
 
-	atomic_add(data_size >> 9, &mdev->rs_sect_in);
+	atomic_add(pi->size >> 9, &mdev->rs_sect_in);
 
 	return err;
 }
@@ -1961,8 +1959,7 @@ static int handle_write_conflicts(struct drbd_conf *mdev,
 }
 
 /* mirrored write */
-static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
-			unsigned int data_size)
+static int receive_Data(struct drbd_conf *mdev, struct packet_info *pi)
 {
 	sector_t sector;
 	struct drbd_peer_request *peer_req;
@@ -1976,9 +1973,9 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 		int err2;
 
 		err = wait_for_and_update_peer_seq(mdev, peer_seq);
-		drbd_send_ack_dp(mdev, P_NEG_ACK, p, data_size);
+		drbd_send_ack_dp(mdev, P_NEG_ACK, p, pi->size);
 		atomic_inc(&mdev->current_epoch->epoch_size);
-		err2 = drbd_drain_block(mdev, data_size);
+		err2 = drbd_drain_block(mdev, pi->size);
 		if (!err)
 			err = err2;
 		return err;
@@ -1991,7 +1988,7 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 	 */
 
 	sector = be64_to_cpu(p->sector);
-	peer_req = read_in_block(mdev, p->block_id, sector, data_size);
+	peer_req = read_in_block(mdev, p->block_id, sector, pi->size);
 	if (!peer_req) {
 		put_ldev(mdev);
 		return -EIO;
@@ -2141,8 +2138,7 @@ int drbd_rs_should_slow_down(struct drbd_conf *mdev, sector_t sector)
 }
 
 
-static int receive_DataRequest(struct drbd_conf *mdev, enum drbd_packet cmd,
-			       unsigned int digest_size)
+static int receive_DataRequest(struct drbd_conf *mdev, struct packet_info *pi)
 {
 	sector_t sector;
 	const sector_t capacity = drbd_get_capacity(mdev->this_bdev);
@@ -2168,7 +2164,7 @@ static int receive_DataRequest(struct drbd_conf *mdev, enum drbd_packet cmd,
 
 	if (!get_ldev_if_state(mdev, D_UP_TO_DATE)) {
 		verb = 1;
-		switch (cmd) {
+		switch (pi->cmd) {
 		case P_DATA_REQUEST:
 			drbd_send_ack_rp(mdev, P_NEG_DREPLY, p);
 			break;
@@ -2190,7 +2186,7 @@ static int receive_DataRequest(struct drbd_conf *mdev, enum drbd_packet cmd,
 			    "no local data.\n");
 
 		/* drain possibly payload */
-		return drbd_drain_block(mdev, digest_size);
+		return drbd_drain_block(mdev, pi->size);
 	}
 
 	/* GFP_NOIO, because we must not cause arbitrary write-out: in a DRBD
@@ -2202,7 +2198,7 @@ static int receive_DataRequest(struct drbd_conf *mdev, enum drbd_packet cmd,
 		return -ENOMEM;
 	}
 
-	switch (cmd) {
+	switch (pi->cmd) {
 	case P_DATA_REQUEST:
 		peer_req->w.cb = w_e_end_data_req;
 		fault_type = DRBD_FAULT_DT_RD;
@@ -2219,25 +2215,25 @@ static int receive_DataRequest(struct drbd_conf *mdev, enum drbd_packet cmd,
 	case P_OV_REPLY:
 	case P_CSUM_RS_REQUEST:
 		fault_type = DRBD_FAULT_RS_RD;
-		di = kmalloc(sizeof(*di) + digest_size, GFP_NOIO);
+		di = kmalloc(sizeof(*di) + pi->size, GFP_NOIO);
 		if (!di)
 			goto out_free_e;
 
-		di->digest_size = digest_size;
+		di->digest_size = pi->size;
 		di->digest = (((char *)di)+sizeof(struct digest_info));
 
 		peer_req->digest = di;
 		peer_req->flags |= EE_HAS_DIGEST;
 
-		if (drbd_recv(mdev->tconn, di->digest, digest_size) != digest_size)
+		if (drbd_recv_all(mdev->tconn, di->digest, pi->size))
 			goto out_free_e;
 
-		if (cmd == P_CSUM_RS_REQUEST) {
+		if (pi->cmd == P_CSUM_RS_REQUEST) {
 			D_ASSERT(mdev->tconn->agreed_pro_version >= 89);
 			peer_req->w.cb = w_e_end_csum_rs_req;
 			/* used in the sector offset progress display */
 			mdev->bm_resync_fo = BM_SECT_TO_BIT(sector);
-		} else if (cmd == P_OV_REPLY) {
+		} else if (pi->cmd == P_OV_REPLY) {
 			/* track progress, we may need to throttle */
 			atomic_add(size >> 9, &mdev->rs_sect_in);
 			peer_req->w.cb = w_e_end_ov_reply;
@@ -2863,8 +2859,7 @@ static int cmp_after_sb(enum drbd_after_sb_p peer, enum drbd_after_sb_p self)
 	return 1;
 }
 
-static int receive_protocol(struct drbd_tconn *tconn, enum drbd_packet cmd,
-			    unsigned int data_size)
+static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	struct p_protocol *p = tconn->data.rbuf;
 	int p_proto, p_after_sb_0p, p_after_sb_1p, p_after_sb_2p;
@@ -2918,7 +2913,7 @@ static int receive_protocol(struct drbd_tconn *tconn, enum drbd_packet cmd,
 		unsigned char *my_alg = tconn->net_conf->integrity_alg;
 		int err;
 
-		err = drbd_recv_all(tconn, p_integrity_alg, data_size);
+		err = drbd_recv_all(tconn, p_integrity_alg, pi->size);
 		if (err)
 			return err;
 
@@ -2965,8 +2960,7 @@ struct crypto_hash *drbd_crypto_alloc_digest_safe(const struct drbd_conf *mdev,
 	return tfm;
 }
 
-static int receive_SyncParam(struct drbd_conf *mdev, enum drbd_packet cmd,
-			     unsigned int packet_size)
+static int receive_SyncParam(struct drbd_conf *mdev, struct packet_info *pi)
 {
 	struct p_rs_param_95 *p = mdev->tconn->data.rbuf;
 	unsigned int header_size, data_size, exp_max_sz;
@@ -2983,22 +2977,22 @@ static int receive_SyncParam(struct drbd_conf *mdev, enum drbd_packet cmd,
 		    : apv <= 94 ? sizeof(struct p_rs_param_89)
 		    : /* apv >= 95 */ sizeof(struct p_rs_param_95);
 
-	if (packet_size > exp_max_sz) {
+	if (pi->size > exp_max_sz) {
 		dev_err(DEV, "SyncParam packet too long: received %u, expected <= %u bytes\n",
-		    packet_size, exp_max_sz);
+		    pi->size, exp_max_sz);
 		return -EIO;
 	}
 
 	if (apv <= 88) {
 		header_size = sizeof(struct p_rs_param) - sizeof(struct p_header);
-		data_size   = packet_size  - header_size;
+		data_size = pi->size - header_size;
 	} else if (apv <= 94) {
 		header_size = sizeof(struct p_rs_param_89) - sizeof(struct p_header);
-		data_size   = packet_size  - header_size;
+		data_size = pi->size - header_size;
 		D_ASSERT(data_size == 0);
 	} else {
 		header_size = sizeof(struct p_rs_param_95) - sizeof(struct p_header);
-		data_size   = packet_size  - header_size;
+		data_size = pi->size - header_size;
 		D_ASSERT(data_size == 0);
 	}
 
@@ -3132,8 +3126,7 @@ static void warn_if_differ_considerably(struct drbd_conf *mdev,
 		     (unsigned long long)a, (unsigned long long)b);
 }
 
-static int receive_sizes(struct drbd_conf *mdev, enum drbd_packet cmd,
-			 unsigned int data_size)
+static int receive_sizes(struct drbd_conf *mdev, struct packet_info *pi)
 {
 	struct p_sizes *p = mdev->tconn->data.rbuf;
 	enum determine_dev_size dd = unchanged;
@@ -3230,8 +3223,7 @@ static int receive_sizes(struct drbd_conf *mdev, enum drbd_packet cmd,
 	return 0;
 }
 
-static int receive_uuids(struct drbd_conf *mdev, enum drbd_packet cmd,
-			 unsigned int data_size)
+static int receive_uuids(struct drbd_conf *mdev, struct packet_info *pi)
 {
 	struct p_uuids *p = mdev->tconn->data.rbuf;
 	u64 *p_uuid;
@@ -3326,8 +3318,7 @@ static union drbd_state convert_state(union drbd_state ps)
 	return ms;
 }
 
-static int receive_req_state(struct drbd_conf *mdev, enum drbd_packet cmd,
-			     unsigned int data_size)
+static int receive_req_state(struct drbd_conf *mdev, struct packet_info *pi)
 {
 	struct p_req_state *p = mdev->tconn->data.rbuf;
 	union drbd_state mask, val;
@@ -3353,8 +3344,7 @@ static int receive_req_state(struct drbd_conf *mdev, enum drbd_packet cmd,
 	return 0;
 }
 
-static int receive_req_conn_state(struct drbd_tconn *tconn, enum drbd_packet cmd,
-				  unsigned int data_size)
+static int receive_req_conn_state(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	struct p_req_state *p = tconn->data.rbuf;
 	union drbd_state mask, val;
@@ -3378,8 +3368,7 @@ static int receive_req_conn_state(struct drbd_tconn *tconn, enum drbd_packet cmd
 	return 0;
 }
 
-static int receive_state(struct drbd_conf *mdev, enum drbd_packet cmd,
-			 unsigned int data_size)
+static int receive_state(struct drbd_conf *mdev, struct packet_info *pi)
 {
 	struct p_state *p = mdev->tconn->data.rbuf;
 	union drbd_state os, ns, peer_state;
@@ -3531,8 +3520,7 @@ static int receive_state(struct drbd_conf *mdev, enum drbd_packet cmd,
 	return 0;
 }
 
-static int receive_sync_uuid(struct drbd_conf *mdev, enum drbd_packet cmd,
-			     unsigned int data_size)
+static int receive_sync_uuid(struct drbd_conf *mdev, struct packet_info *pi)
 {
 	struct p_rs_uuid *p = mdev->tconn->data.rbuf;
 
@@ -3741,13 +3729,11 @@ void INFO_bm_xfer_stats(struct drbd_conf *mdev,
    in order to be agnostic to the 32 vs 64 bits issue.
 
    returns 0 on failure, 1 if we successfully received it. */
-static int receive_bitmap(struct drbd_conf *mdev, enum drbd_packet cmd,
-			  unsigned int data_size)
+static int receive_bitmap(struct drbd_conf *mdev, struct packet_info *pi)
 {
 	struct bm_xfer_ctx c;
 	int err;
 	struct p_header *h = mdev->tconn->data.rbuf;
-	struct packet_info pi;
 
 	drbd_bm_lock(mdev, "receive bitmap", BM_LOCKED_SET_ALLOWED);
 	/* you are supposed to send additional out-of-sync information
@@ -3759,48 +3745,46 @@ static int receive_bitmap(struct drbd_conf *mdev, enum drbd_packet cmd,
 	};
 
 	for(;;) {
-		if (cmd == P_BITMAP) {
-			err = receive_bitmap_plain(mdev, data_size, h, &c);
-		} else if (cmd == P_COMPRESSED_BITMAP) {
+		if (pi->cmd == P_BITMAP) {
+			err = receive_bitmap_plain(mdev, pi->size, h, &c);
+		} else if (pi->cmd == P_COMPRESSED_BITMAP) {
 			/* MAYBE: sanity check that we speak proto >= 90,
 			 * and the feature is enabled! */
 			struct p_compressed_bm *p;
 
-			if (data_size > BM_PACKET_PAYLOAD_BYTES) {
+			if (pi->size > BM_PACKET_PAYLOAD_BYTES) {
 				dev_err(DEV, "ReportCBitmap packet too large\n");
 				err = -EIO;
 				goto out;
 			}
 
 			p = mdev->tconn->data.rbuf;
-			err = drbd_recv_all(mdev->tconn, p->head.payload, data_size);
+			err = drbd_recv_all(mdev->tconn, p->head.payload, pi->size);
 			if (err)
 			       goto out;
-			if (data_size <= (sizeof(*p) - sizeof(p->head))) {
-				dev_err(DEV, "ReportCBitmap packet too small (l:%u)\n", data_size);
+			if (pi->size <= (sizeof(*p) - sizeof(p->head))) {
+				dev_err(DEV, "ReportCBitmap packet too small (l:%u)\n", pi->size);
 				err = -EIO;
 				goto out;
 			}
-			err = decode_bitmap_c(mdev, p, &c, data_size);
+			err = decode_bitmap_c(mdev, p, &c, pi->size);
 		} else {
-			dev_warn(DEV, "receive_bitmap: cmd neither ReportBitMap nor ReportCBitMap (is 0x%x)", cmd);
+			dev_warn(DEV, "receive_bitmap: cmd neither ReportBitMap nor ReportCBitMap (is 0x%x)", pi->cmd);
 			err = -EIO;
 			goto out;
 		}
 
-		c.packets[cmd == P_BITMAP]++;
-		c.bytes[cmd == P_BITMAP] += sizeof(struct p_header) + data_size;
+		c.packets[pi->cmd == P_BITMAP]++;
+		c.bytes[pi->cmd == P_BITMAP] += sizeof(struct p_header) + pi->size;
 
 		if (err <= 0) {
 			if (err < 0)
 				goto out;
 			break;
 		}
-		err = drbd_recv_header(mdev->tconn, &pi);
+		err = drbd_recv_header(mdev->tconn, pi);
 		if (err)
 			goto out;
-		cmd = pi.cmd;
-		data_size = pi.size;
 	}
 
 	INFO_bm_xfer_stats(mdev, "receive", &c);
@@ -3846,25 +3830,23 @@ static int _tconn_receive_skip(struct drbd_tconn *tconn, unsigned int data_size)
 	return size ? -EIO : 0;
 }
 
-static int receive_skip(struct drbd_conf *mdev, enum drbd_packet cmd,
-			unsigned int data_size)
+static int receive_skip(struct drbd_conf *mdev, struct packet_info *pi)
 {
 	dev_warn(DEV, "skipping unknown optional packet type %d, l: %d!\n",
-		 cmd, data_size);
+		 pi->cmd, pi->size);
 
-	return _tconn_receive_skip(mdev->tconn, data_size);
+	return _tconn_receive_skip(mdev->tconn, pi->size);
 }
 
-static int tconn_receive_skip(struct drbd_tconn *tconn, enum drbd_packet cmd, unsigned int data_size)
+static int tconn_receive_skip(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	conn_warn(tconn, "skipping packet for non existing volume type %d, l: %d!\n",
-		  cmd, data_size);
+		  pi->cmd, pi->size);
 
-	return _tconn_receive_skip(tconn, data_size);
+	return _tconn_receive_skip(tconn, pi->size);
 }
 
-static int receive_UnplugRemote(struct drbd_conf *mdev, enum drbd_packet cmd,
-				unsigned int data_size)
+static int receive_UnplugRemote(struct drbd_conf *mdev, struct packet_info *pi)
 {
 	/* Make sure we've acked all the TCP data associated
 	 * with the data requests being unplugged */
@@ -3873,8 +3855,7 @@ static int receive_UnplugRemote(struct drbd_conf *mdev, enum drbd_packet cmd,
 	return 0;
 }
 
-static int receive_out_of_sync(struct drbd_conf *mdev, enum drbd_packet cmd,
-			       unsigned int data_size)
+static int receive_out_of_sync(struct drbd_conf *mdev, struct packet_info *pi)
 {
 	struct p_block_desc *p = mdev->tconn->data.rbuf;
 
@@ -3898,10 +3879,8 @@ struct data_cmd {
 	size_t pkt_size;
 	enum mdev_or_conn fa_type; /* first argument's type */
 	union {
-		int (*mdev_fn)(struct drbd_conf *, enum drbd_packet cmd,
-				  unsigned int to_receive);
-		int (*conn_fn)(struct drbd_tconn *, enum drbd_packet cmd,
-				  unsigned int to_receive);
+		int (*mdev_fn)(struct drbd_conf *, struct packet_info *);
+		int (*conn_fn)(struct drbd_tconn *, struct packet_info *);
 	};
 };
 
@@ -3961,15 +3940,16 @@ static void drbdd(struct drbd_tconn *tconn)
 			err = drbd_recv_all_warn(tconn, &header->payload, shs);
 			if (err)
 				goto err_out;
+			pi.size -= shs;
 		}
 
-		if (cmd->fa_type == CONN) {
-			err = cmd->conn_fn(tconn, pi.cmd, pi.size - shs);
-		} else {
+		if (cmd->fa_type == CONN)
+			err = cmd->conn_fn(tconn, &pi);
+		else {
 			struct drbd_conf *mdev = vnr_to_mdev(tconn, pi.vnr);
 			err = mdev ?
-				cmd->mdev_fn(mdev, pi.cmd, pi.size - shs) :
-				tconn_receive_skip(tconn, pi.cmd, pi.size - shs);
+				cmd->mdev_fn(mdev, &pi) :
+				tconn_receive_skip(tconn, &pi);
 		}
 
 		if (unlikely(err)) {
-- 
1.7.4.1

