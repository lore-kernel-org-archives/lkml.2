Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab1IGQtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:49:23 -0400
Received: from mail09.linbit.com ([212.69.161.110]:48575 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab1IGQp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:45:59 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 14/14] drbd: Map from (connection, volume number) to device in the receive handlers
Date: Wed,  7 Sep 2011 16:17:41 +0200
Message-Id: <1315405061-1473-15-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315405061-1473-1-git-send-email-philipp.reisner@linbit.com>
References: <1315405061-1473-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

The receive handlers do not all handle unknown volume numbers the same
way.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |  262 ++++++++++++++++++++++--------------
 1 files changed, 164 insertions(+), 98 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 856ac23..218d97d7 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1235,13 +1235,17 @@ static void drbd_remove_epoch_entry_interval(struct drbd_conf *mdev,
 		wake_up(&mdev->misc_wait);
 }
 
-static int receive_Barrier(struct drbd_conf *mdev, enum drbd_packet cmd,
-			   unsigned int data_size)
+static int receive_Barrier(struct drbd_tconn *tconn, struct packet_info *pi)
 {
+	struct drbd_conf *mdev;
 	int rv;
-	struct p_barrier *p = mdev->tconn->data.rbuf;
+	struct p_barrier *p = tconn->data.rbuf;
 	struct drbd_epoch *epoch;
 
+	mdev = vnr_to_mdev(tconn, pi->vnr);
+	if (!mdev)
+		return -EIO;
+
 	inc_unacked(mdev);
 
 	mdev->current_epoch->barrier_nr = p->barrier;
@@ -1543,12 +1547,17 @@ find_request(struct drbd_conf *mdev, struct rb_root *root, u64 id,
 	return NULL;
 }
 
-static int receive_DataReply(struct drbd_conf *mdev, struct packet_info *pi)
+static int receive_DataReply(struct drbd_tconn *tconn, struct packet_info *pi)
 {
+	struct drbd_conf *mdev;
 	struct drbd_request *req;
 	sector_t sector;
 	int err;
-	struct p_data *p = mdev->tconn->data.rbuf;
+	struct p_data *p = tconn->data.rbuf;
+
+	mdev = vnr_to_mdev(tconn, pi->vnr);
+	if (!mdev)
+		return -EIO;
 
 	sector = be64_to_cpu(p->sector);
 
@@ -1571,11 +1580,16 @@ static int receive_DataReply(struct drbd_conf *mdev, struct packet_info *pi)
 	return err;
 }
 
-static int receive_RSDataReply(struct drbd_conf *mdev, struct packet_info *pi)
+static int receive_RSDataReply(struct drbd_tconn *tconn, struct packet_info *pi)
 {
+	struct drbd_conf *mdev;
 	sector_t sector;
 	int err;
-	struct p_data *p = mdev->tconn->data.rbuf;
+	struct p_data *p = tconn->data.rbuf;
+
+	mdev = vnr_to_mdev(tconn, pi->vnr);
+	if (!mdev)
+		return -EIO;
 
 	sector = be64_to_cpu(p->sector);
 	D_ASSERT(p->block_id == ID_SYNCER);
@@ -1959,16 +1973,21 @@ static int handle_write_conflicts(struct drbd_conf *mdev,
 }
 
 /* mirrored write */
-static int receive_Data(struct drbd_conf *mdev, struct packet_info *pi)
+static int receive_Data(struct drbd_tconn *tconn, struct packet_info *pi)
 {
+	struct drbd_conf *mdev;
 	sector_t sector;
 	struct drbd_peer_request *peer_req;
-	struct p_data *p = mdev->tconn->data.rbuf;
+	struct p_data *p = tconn->data.rbuf;
 	u32 peer_seq = be32_to_cpu(p->seq_num);
 	int rw = WRITE;
 	u32 dp_flags;
 	int err;
 
+	mdev = vnr_to_mdev(tconn, pi->vnr);
+	if (!mdev)
+		return -EIO;
+
 	if (!get_ldev(mdev)) {
 		int err2;
 
@@ -2138,15 +2157,21 @@ int drbd_rs_should_slow_down(struct drbd_conf *mdev, sector_t sector)
 }
 
 
-static int receive_DataRequest(struct drbd_conf *mdev, struct packet_info *pi)
+static int receive_DataRequest(struct drbd_tconn *tconn, struct packet_info *pi)
 {
+	struct drbd_conf *mdev;
 	sector_t sector;
-	const sector_t capacity = drbd_get_capacity(mdev->this_bdev);
+	sector_t capacity;
 	struct drbd_peer_request *peer_req;
 	struct digest_info *di = NULL;
 	int size, verb;
 	unsigned int fault_type;
-	struct p_block_req *p =	mdev->tconn->data.rbuf;
+	struct p_block_req *p =	tconn->data.rbuf;
+
+	mdev = vnr_to_mdev(tconn, pi->vnr);
+	if (!mdev)
+		return -EIO;
+	capacity = drbd_get_capacity(mdev->this_bdev);
 
 	sector = be64_to_cpu(p->sector);
 	size   = be32_to_cpu(p->blksize);
@@ -2960,17 +2985,60 @@ struct crypto_hash *drbd_crypto_alloc_digest_safe(const struct drbd_conf *mdev,
 	return tfm;
 }
 
-static int receive_SyncParam(struct drbd_conf *mdev, struct packet_info *pi)
+static int ignore_remaining_packet(struct drbd_tconn *tconn, struct packet_info *pi)
+{
+	void *buffer = tconn->data.rbuf;
+	int size = pi->size;
+
+	while (size) {
+		int s = min_t(int, size, DRBD_SOCKET_BUFFER_SIZE);
+		s = drbd_recv(tconn, buffer, s);
+		if (s <= 0) {
+			if (s < 0)
+				return s;
+			break;
+		}
+		size -= s;
+	}
+	if (size)
+		return -EIO;
+	return 0;
+}
+
+/*
+ * config_unknown_volume  -  device configuration command for unknown volume
+ *
+ * When a device is added to an existing connection, the node on which the
+ * device is added first will send configuration commands to its peer but the
+ * peer will not know about the device yet.  It will warn and ignore these
+ * commands.  Once the device is added on the second node, the second node will
+ * send the same device configuration commands, but in the other direction.
+ *
+ * (We can also end up here if drbd is misconfigured.)
+ */
+static int config_unknown_volume(struct drbd_tconn *tconn, struct packet_info *pi)
+{
+	conn_warn(tconn, "Volume %u unknown; ignoring %s packet\n",
+		  pi->vnr, cmdname(pi->cmd));
+	return ignore_remaining_packet(tconn, pi);
+}
+
+static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct p_rs_param_95 *p = mdev->tconn->data.rbuf;
+	struct drbd_conf *mdev;
+	struct p_rs_param_95 *p = tconn->data.rbuf;
 	unsigned int header_size, data_size, exp_max_sz;
 	struct crypto_hash *verify_tfm = NULL;
 	struct crypto_hash *csums_tfm = NULL;
-	const int apv = mdev->tconn->agreed_pro_version;
+	const int apv = tconn->agreed_pro_version;
 	int *rs_plan_s = NULL;
 	int fifo_size = 0;
 	int err;
 
+	mdev = vnr_to_mdev(tconn, pi->vnr);
+	if (!mdev)
+		return config_unknown_volume(tconn, pi);
+
 	exp_max_sz  = apv <= 87 ? sizeof(struct p_rs_param)
 		    : apv == 88 ? sizeof(struct p_rs_param)
 					+ SHARED_SECRET_MAX
@@ -3126,14 +3194,19 @@ static void warn_if_differ_considerably(struct drbd_conf *mdev,
 		     (unsigned long long)a, (unsigned long long)b);
 }
 
-static int receive_sizes(struct drbd_conf *mdev, struct packet_info *pi)
+static int receive_sizes(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct p_sizes *p = mdev->tconn->data.rbuf;
+	struct drbd_conf *mdev;
+	struct p_sizes *p = tconn->data.rbuf;
 	enum determine_dev_size dd = unchanged;
 	sector_t p_size, p_usize, my_usize;
 	int ldsc = 0; /* local disk size changed */
 	enum dds_flags ddsf;
 
+	mdev = vnr_to_mdev(tconn, pi->vnr);
+	if (!mdev)
+		return config_unknown_volume(tconn, pi);
+
 	p_size = be64_to_cpu(p->d_size);
 	p_usize = be64_to_cpu(p->u_size);
 
@@ -3223,12 +3296,17 @@ static int receive_sizes(struct drbd_conf *mdev, struct packet_info *pi)
 	return 0;
 }
 
-static int receive_uuids(struct drbd_conf *mdev, struct packet_info *pi)
+static int receive_uuids(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct p_uuids *p = mdev->tconn->data.rbuf;
+	struct drbd_conf *mdev;
+	struct p_uuids *p = tconn->data.rbuf;
 	u64 *p_uuid;
 	int i, updated_uuids = 0;
 
+	mdev = vnr_to_mdev(tconn, pi->vnr);
+	if (!mdev)
+		return config_unknown_volume(tconn, pi);
+
 	p_uuid = kmalloc(sizeof(u64)*UI_EXTENDED_SIZE, GFP_NOIO);
 
 	for (i = UI_CURRENT; i < UI_EXTENDED_SIZE; i++)
@@ -3318,12 +3396,17 @@ static union drbd_state convert_state(union drbd_state ps)
 	return ms;
 }
 
-static int receive_req_state(struct drbd_conf *mdev, struct packet_info *pi)
+static int receive_req_state(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct p_req_state *p = mdev->tconn->data.rbuf;
+	struct drbd_conf *mdev;
+	struct p_req_state *p = tconn->data.rbuf;
 	union drbd_state mask, val;
 	enum drbd_state_rv rv;
 
+	mdev = vnr_to_mdev(tconn, pi->vnr);
+	if (!mdev)
+		return -EIO;
+
 	mask.i = be32_to_cpu(p->mask);
 	val.i = be32_to_cpu(p->val);
 
@@ -3368,14 +3451,19 @@ static int receive_req_conn_state(struct drbd_tconn *tconn, struct packet_info *
 	return 0;
 }
 
-static int receive_state(struct drbd_conf *mdev, struct packet_info *pi)
+static int receive_state(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct p_state *p = mdev->tconn->data.rbuf;
+	struct drbd_conf *mdev;
+	struct p_state *p = tconn->data.rbuf;
 	union drbd_state os, ns, peer_state;
 	enum drbd_disk_state real_peer_disk;
 	enum chg_state_flags cs_flags;
 	int rv;
 
+	mdev = vnr_to_mdev(tconn, pi->vnr);
+	if (!mdev)
+		return config_unknown_volume(tconn, pi);
+
 	peer_state.i = be32_to_cpu(p->state);
 
 	real_peer_disk = peer_state.disk;
@@ -3520,9 +3608,14 @@ static int receive_state(struct drbd_conf *mdev, struct packet_info *pi)
 	return 0;
 }
 
-static int receive_sync_uuid(struct drbd_conf *mdev, struct packet_info *pi)
+static int receive_sync_uuid(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct p_rs_uuid *p = mdev->tconn->data.rbuf;
+	struct drbd_conf *mdev;
+	struct p_rs_uuid *p = tconn->data.rbuf;
+
+	mdev = vnr_to_mdev(tconn, pi->vnr);
+	if (!mdev)
+		return -EIO;
 
 	wait_event(mdev->misc_wait,
 		   mdev->state.conn == C_WF_SYNC_UUID ||
@@ -3729,11 +3822,16 @@ void INFO_bm_xfer_stats(struct drbd_conf *mdev,
    in order to be agnostic to the 32 vs 64 bits issue.
 
    returns 0 on failure, 1 if we successfully received it. */
-static int receive_bitmap(struct drbd_conf *mdev, struct packet_info *pi)
+static int receive_bitmap(struct drbd_tconn *tconn, struct packet_info *pi)
 {
+	struct drbd_conf *mdev;
 	struct bm_xfer_ctx c;
 	int err;
-	struct p_header *h = mdev->tconn->data.rbuf;
+	struct p_header *h = tconn->data.rbuf;
+
+	mdev = vnr_to_mdev(tconn, pi->vnr);
+	if (!mdev)
+		return -EIO;
 
 	drbd_bm_lock(mdev, "receive bitmap", BM_LOCKED_SET_ALLOWED);
 	/* you are supposed to send additional out-of-sync information
@@ -3813,51 +3911,31 @@ static int receive_bitmap(struct drbd_conf *mdev, struct packet_info *pi)
 	return err;
 }
 
-static int _tconn_receive_skip(struct drbd_tconn *tconn, unsigned int data_size)
-{
-	/* TODO zero copy sink :) */
-	static char sink[128];
-	int size, want, r;
-
-	size = data_size;
-	while (size > 0) {
-		want = min_t(int, size, sizeof(sink));
-		r = drbd_recv(tconn, sink, want);
-		if (r <= 0)
-			break;
-		size -= r;
-	}
-	return size ? -EIO : 0;
-}
-
-static int receive_skip(struct drbd_conf *mdev, struct packet_info *pi)
+static int receive_skip(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	dev_warn(DEV, "skipping unknown optional packet type %d, l: %d!\n",
+	conn_warn(tconn, "skipping unknown optional packet type %d, l: %d!\n",
 		 pi->cmd, pi->size);
 
-	return _tconn_receive_skip(mdev->tconn, pi->size);
+	return ignore_remaining_packet(tconn, pi);
 }
 
-static int tconn_receive_skip(struct drbd_tconn *tconn, struct packet_info *pi)
-{
-	conn_warn(tconn, "skipping packet for non existing volume type %d, l: %d!\n",
-		  pi->cmd, pi->size);
-
-	return _tconn_receive_skip(tconn, pi->size);
-}
-
-static int receive_UnplugRemote(struct drbd_conf *mdev, struct packet_info *pi)
+static int receive_UnplugRemote(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	/* Make sure we've acked all the TCP data associated
 	 * with the data requests being unplugged */
-	drbd_tcp_quickack(mdev->tconn->data.socket);
+	drbd_tcp_quickack(tconn->data.socket);
 
 	return 0;
 }
 
-static int receive_out_of_sync(struct drbd_conf *mdev, struct packet_info *pi)
+static int receive_out_of_sync(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct p_block_desc *p = mdev->tconn->data.rbuf;
+	struct drbd_conf *mdev;
+	struct p_block_desc *p = tconn->data.rbuf;
+
+	mdev = vnr_to_mdev(tconn, pi->vnr);
+	if (!mdev)
+		return -EIO;
 
 	switch (mdev->state.conn) {
 	case C_WF_SYNC_UUID:
@@ -3877,37 +3955,33 @@ static int receive_out_of_sync(struct drbd_conf *mdev, struct packet_info *pi)
 struct data_cmd {
 	int expect_payload;
 	size_t pkt_size;
-	enum mdev_or_conn fa_type; /* first argument's type */
-	union {
-		int (*mdev_fn)(struct drbd_conf *, struct packet_info *);
-		int (*conn_fn)(struct drbd_tconn *, struct packet_info *);
-	};
+	int (*fn)(struct drbd_tconn *, struct packet_info *);
 };
 
 static struct data_cmd drbd_cmd_handler[] = {
-	[P_DATA]	    = { 1, sizeof(struct p_data), MDEV, { receive_Data } },
-	[P_DATA_REPLY]	    = { 1, sizeof(struct p_data), MDEV, { receive_DataReply } },
-	[P_RS_DATA_REPLY]   = { 1, sizeof(struct p_data), MDEV, { receive_RSDataReply } } ,
-	[P_BARRIER]	    = { 0, sizeof(struct p_barrier), MDEV, { receive_Barrier } } ,
-	[P_BITMAP]	    = { 1, sizeof(struct p_header), MDEV, { receive_bitmap } } ,
-	[P_COMPRESSED_BITMAP] = { 1, sizeof(struct p_header), MDEV, { receive_bitmap } } ,
-	[P_UNPLUG_REMOTE]   = { 0, sizeof(struct p_header), MDEV, { receive_UnplugRemote } },
-	[P_DATA_REQUEST]    = { 0, sizeof(struct p_block_req), MDEV, { receive_DataRequest } },
-	[P_RS_DATA_REQUEST] = { 0, sizeof(struct p_block_req), MDEV, { receive_DataRequest } },
-	[P_SYNC_PARAM]	    = { 1, sizeof(struct p_header), MDEV, { receive_SyncParam } },
-	[P_SYNC_PARAM89]    = { 1, sizeof(struct p_header), MDEV, { receive_SyncParam } },
-	[P_PROTOCOL]        = { 1, sizeof(struct p_protocol), CONN, { .conn_fn = receive_protocol } },
-	[P_UUIDS]	    = { 0, sizeof(struct p_uuids), MDEV, { receive_uuids } },
-	[P_SIZES]	    = { 0, sizeof(struct p_sizes), MDEV, { receive_sizes } },
-	[P_STATE]	    = { 0, sizeof(struct p_state), MDEV, { receive_state } },
-	[P_STATE_CHG_REQ]   = { 0, sizeof(struct p_req_state), MDEV, { receive_req_state } },
-	[P_SYNC_UUID]       = { 0, sizeof(struct p_rs_uuid), MDEV, { receive_sync_uuid } },
-	[P_OV_REQUEST]      = { 0, sizeof(struct p_block_req), MDEV, { receive_DataRequest } },
-	[P_OV_REPLY]        = { 1, sizeof(struct p_block_req), MDEV, { receive_DataRequest } },
-	[P_CSUM_RS_REQUEST] = { 1, sizeof(struct p_block_req), MDEV, { receive_DataRequest } },
-	[P_DELAY_PROBE]     = { 0, sizeof(struct p_delay_probe93), MDEV, { receive_skip } },
-	[P_OUT_OF_SYNC]     = { 0, sizeof(struct p_block_desc), MDEV, { receive_out_of_sync } },
-	[P_CONN_ST_CHG_REQ] = { 0, sizeof(struct p_req_state), CONN, { .conn_fn = receive_req_conn_state } },
+	[P_DATA]	    = { 1, sizeof(struct p_data), receive_Data },
+	[P_DATA_REPLY]	    = { 1, sizeof(struct p_data), receive_DataReply },
+	[P_RS_DATA_REPLY]   = { 1, sizeof(struct p_data), receive_RSDataReply } ,
+	[P_BARRIER]	    = { 0, sizeof(struct p_barrier), receive_Barrier } ,
+	[P_BITMAP]	    = { 1, sizeof(struct p_header), receive_bitmap } ,
+	[P_COMPRESSED_BITMAP] = { 1, sizeof(struct p_header), receive_bitmap } ,
+	[P_UNPLUG_REMOTE]   = { 0, sizeof(struct p_header), receive_UnplugRemote },
+	[P_DATA_REQUEST]    = { 0, sizeof(struct p_block_req), receive_DataRequest },
+	[P_RS_DATA_REQUEST] = { 0, sizeof(struct p_block_req), receive_DataRequest },
+	[P_SYNC_PARAM]	    = { 1, sizeof(struct p_header), receive_SyncParam },
+	[P_SYNC_PARAM89]    = { 1, sizeof(struct p_header), receive_SyncParam },
+	[P_PROTOCOL]        = { 1, sizeof(struct p_protocol), receive_protocol },
+	[P_UUIDS]	    = { 0, sizeof(struct p_uuids), receive_uuids },
+	[P_SIZES]	    = { 0, sizeof(struct p_sizes), receive_sizes },
+	[P_STATE]	    = { 0, sizeof(struct p_state), receive_state },
+	[P_STATE_CHG_REQ]   = { 0, sizeof(struct p_req_state), receive_req_state },
+	[P_SYNC_UUID]       = { 0, sizeof(struct p_rs_uuid), receive_sync_uuid },
+	[P_OV_REQUEST]      = { 0, sizeof(struct p_block_req), receive_DataRequest },
+	[P_OV_REPLY]        = { 1, sizeof(struct p_block_req), receive_DataRequest },
+	[P_CSUM_RS_REQUEST] = { 1, sizeof(struct p_block_req), receive_DataRequest },
+	[P_DELAY_PROBE]     = { 0, sizeof(struct p_delay_probe93), receive_skip },
+	[P_OUT_OF_SYNC]     = { 0, sizeof(struct p_block_desc), receive_out_of_sync },
+	[P_CONN_ST_CHG_REQ] = { 0, sizeof(struct p_req_state), receive_req_conn_state },
 };
 
 static void drbdd(struct drbd_tconn *tconn)
@@ -3925,7 +3999,7 @@ static void drbdd(struct drbd_tconn *tconn)
 			goto err_out;
 
 		cmd = &drbd_cmd_handler[pi.cmd];
-		if (unlikely(pi.cmd >= ARRAY_SIZE(drbd_cmd_handler) || !cmd->mdev_fn)) {
+		if (unlikely(pi.cmd >= ARRAY_SIZE(drbd_cmd_handler) || !cmd->fn)) {
 			conn_err(tconn, "unknown packet type %d, l: %d!\n", pi.cmd, pi.size);
 			goto err_out;
 		}
@@ -3943,16 +4017,8 @@ static void drbdd(struct drbd_tconn *tconn)
 			pi.size -= shs;
 		}
 
-		if (cmd->fa_type == CONN)
-			err = cmd->conn_fn(tconn, &pi);
-		else {
-			struct drbd_conf *mdev = vnr_to_mdev(tconn, pi.vnr);
-			err = mdev ?
-				cmd->mdev_fn(mdev, &pi) :
-				tconn_receive_skip(tconn, &pi);
-		}
-
-		if (unlikely(err)) {
+		err = cmd->fn(tconn, &pi);
+		if (err) {
 			conn_err(tconn, "error receiving %s, l: %d!\n",
 			    cmdname(pi.cmd), pi.size);
 			goto err_out;
-- 
1.7.4.1

