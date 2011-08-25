Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab1HYPJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:09:26 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32962 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab1HYPJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:11 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 033/118] drbd: moved agreed_pro_version, last_received and ko_count to tconn
Date: Thu, 25 Aug 2011 17:07:29 +0200
Message-Id: <1314284934-17999-34-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sed -i \
       -e 's/mdev->agreed_pro_version/mdev->tconn->agreed_pro_version/g' \
       -e 's/mdev->last_received/mdev->tconn->last_received/g' \
       -e 's/mdev->ko_count/mdev->tconn->ko_count/g' \
       *.[ch]

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    8 +++---
 drivers/block/drbd/drbd_main.c     |   32 ++++++++++++++--------------
 drivers/block/drbd/drbd_nl.c       |    8 +++---
 drivers/block/drbd/drbd_receiver.c |   40 ++++++++++++++++++------------------
 drivers/block/drbd/drbd_req.c      |    2 +-
 drivers/block/drbd/drbd_worker.c   |    6 ++--
 6 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 6658dcb..ffc8211 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -972,6 +972,9 @@ struct drbd_tconn {			/* is a resource from the config file */
 
 	struct drbd_socket data;	/* data/barrier/cstate/parameter packets */
 	struct drbd_socket meta;	/* ping/ack (metadata) packets */
+	int agreed_pro_version;		/* actually used protocol version */
+	unsigned long last_received;	/* in jiffies, either socket */
+	unsigned int ko_count;
 
 	struct drbd_thread receiver;
 	struct drbd_thread worker;
@@ -994,9 +997,6 @@ struct drbd_conf {
 	struct block_device *this_bdev;
 	struct gendisk	    *vdisk;
 
-	int agreed_pro_version;  /* actually used protocol version */
-	unsigned long last_received; /* in jiffies, either socket */
-	unsigned int ko_count;
 	struct drbd_work  resync_work,
 			  unplug_work,
 			  go_diskless,
@@ -2297,7 +2297,7 @@ static inline int drbd_state_is_stable(struct drbd_conf *mdev)
 
 		/* Allow IO in BM exchange states with new protocols */
 	case C_WF_BITMAP_S:
-		if (mdev->agreed_pro_version < 96)
+		if (mdev->tconn->agreed_pro_version < 96)
 			return 0;
 		break;
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 5d8a6e9..e06ca4a 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -735,7 +735,7 @@ is_valid_state(struct drbd_conf *mdev, union drbd_state ns)
 		rv = SS_NO_VERIFY_ALG;
 
 	else if ((ns.conn == C_VERIFY_S || ns.conn == C_VERIFY_T) &&
-		  mdev->agreed_pro_version < 88)
+		  mdev->tconn->agreed_pro_version < 88)
 		rv = SS_NOT_SUPPORTED;
 
 	else if (ns.conn >= C_CONNECTED && ns.pdsk == D_UNKNOWN)
@@ -993,7 +993,7 @@ static union drbd_state sanitize_state(struct drbd_conf *mdev, union drbd_state
 /* helper for __drbd_set_state */
 static void set_ov_position(struct drbd_conf *mdev, enum drbd_conns cs)
 {
-	if (mdev->agreed_pro_version < 90)
+	if (mdev->tconn->agreed_pro_version < 90)
 		mdev->ov_start_sector = 0;
 	mdev->rs_total = drbd_bm_bits(mdev);
 	mdev->ov_position = 0;
@@ -1393,7 +1393,7 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 	 * which is unexpected. */
 	if ((os.conn != C_SYNC_SOURCE && os.conn != C_PAUSED_SYNC_S) &&
 	    (ns.conn == C_SYNC_SOURCE || ns.conn == C_PAUSED_SYNC_S) &&
-	    mdev->agreed_pro_version >= 96 && get_ldev(mdev)) {
+	    mdev->tconn->agreed_pro_version >= 96 && get_ldev(mdev)) {
 		drbd_gen_and_send_sync_uuid(mdev);
 		put_ldev(mdev);
 	}
@@ -1902,7 +1902,7 @@ int drbd_send_sync_param(struct drbd_conf *mdev, struct syncer_conf *sc)
 	struct p_rs_param_95 *p;
 	struct socket *sock;
 	int size, rv;
-	const int apv = mdev->agreed_pro_version;
+	const int apv = mdev->tconn->agreed_pro_version;
 
 	size = apv <= 87 ? sizeof(struct p_rs_param)
 		: apv == 88 ? sizeof(struct p_rs_param)
@@ -1951,7 +1951,7 @@ int drbd_send_protocol(struct drbd_conf *mdev)
 
 	size = sizeof(struct p_protocol);
 
-	if (mdev->agreed_pro_version >= 87)
+	if (mdev->tconn->agreed_pro_version >= 87)
 		size += strlen(mdev->tconn->net_conf->integrity_alg) + 1;
 
 	/* we must not recurse into our own queue,
@@ -1970,7 +1970,7 @@ int drbd_send_protocol(struct drbd_conf *mdev)
 	if (mdev->tconn->net_conf->want_lose)
 		cf |= CF_WANT_LOSE;
 	if (mdev->tconn->net_conf->dry_run) {
-		if (mdev->agreed_pro_version >= 92)
+		if (mdev->tconn->agreed_pro_version >= 92)
 			cf |= CF_DRY_RUN;
 		else {
 			dev_err(DEV, "--dry-run is not supported by peer");
@@ -1980,7 +1980,7 @@ int drbd_send_protocol(struct drbd_conf *mdev)
 	}
 	p->conn_flags    = cpu_to_be32(cf);
 
-	if (mdev->agreed_pro_version >= 87)
+	if (mdev->tconn->agreed_pro_version >= 87)
 		strcpy(p->integrity_alg, mdev->tconn->net_conf->integrity_alg);
 
 	rv = drbd_send_cmd(mdev, USE_DATA_SOCKET, P_PROTOCOL,
@@ -2158,7 +2158,7 @@ int fill_bitmap_rle_bits(struct drbd_conf *mdev,
 
 	/* may we use this feature? */
 	if ((mdev->sync_conf.use_rle == 0) ||
-		(mdev->agreed_pro_version < 90))
+		(mdev->tconn->agreed_pro_version < 90))
 			return 0;
 
 	if (c->bit_offset >= c->bm_bits)
@@ -2404,7 +2404,7 @@ static int _drbd_send_ack(struct drbd_conf *mdev, enum drbd_packets cmd,
 int drbd_send_ack_dp(struct drbd_conf *mdev, enum drbd_packets cmd,
 		     struct p_data *dp, int data_size)
 {
-	data_size -= (mdev->agreed_pro_version >= 87 && mdev->integrity_r_tfm) ?
+	data_size -= (mdev->tconn->agreed_pro_version >= 87 && mdev->integrity_r_tfm) ?
 		crypto_hash_digestsize(mdev->integrity_r_tfm) : 0;
 	return _drbd_send_ack(mdev, cmd, dp->sector, cpu_to_be32(data_size),
 			      dp->block_id);
@@ -2514,10 +2514,10 @@ static int we_should_drop_the_connection(struct drbd_conf *mdev, struct socket *
 	if (drop_it)
 		return true;
 
-	drop_it = !--mdev->ko_count;
+	drop_it = !--mdev->tconn->ko_count;
 	if (!drop_it) {
 		dev_err(DEV, "[%s/%d] sock_sendmsg time expired, ko = %u\n",
-		       current->comm, current->pid, mdev->ko_count);
+		       current->comm, current->pid, mdev->tconn->ko_count);
 		request_ping(mdev);
 	}
 
@@ -2647,7 +2647,7 @@ static int _drbd_send_zc_ee(struct drbd_conf *mdev, struct drbd_epoch_entry *e)
 
 static u32 bio_flags_to_wire(struct drbd_conf *mdev, unsigned long bi_rw)
 {
-	if (mdev->agreed_pro_version >= 95)
+	if (mdev->tconn->agreed_pro_version >= 95)
 		return  (bi_rw & REQ_SYNC ? DP_RW_SYNC : 0) |
 			(bi_rw & REQ_FUA ? DP_FUA : 0) |
 			(bi_rw & REQ_FLUSH ? DP_FLUSH : 0) |
@@ -2670,7 +2670,7 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 	if (!drbd_get_data_sock(mdev))
 		return 0;
 
-	dgs = (mdev->agreed_pro_version >= 87 && mdev->integrity_w_tfm) ?
+	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->integrity_w_tfm) ?
 		crypto_hash_digestsize(mdev->integrity_w_tfm) : 0;
 
 	if (req->i.size <= DRBD_MAX_SIZE_H80_PACKET) {
@@ -2755,7 +2755,7 @@ int drbd_send_block(struct drbd_conf *mdev, enum drbd_packets cmd,
 	void *dgb;
 	int dgs;
 
-	dgs = (mdev->agreed_pro_version >= 87 && mdev->integrity_w_tfm) ?
+	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->integrity_w_tfm) ?
 		crypto_hash_digestsize(mdev->integrity_w_tfm) : 0;
 
 	if (e->i.size <= DRBD_MAX_SIZE_H80_PACKET) {
@@ -2843,7 +2843,7 @@ int drbd_send(struct drbd_conf *mdev, struct socket *sock,
 	msg.msg_flags      = msg_flags | MSG_NOSIGNAL;
 
 	if (sock == mdev->tconn->data.socket) {
-		mdev->ko_count = mdev->tconn->net_conf->ko_count;
+		mdev->tconn->ko_count = mdev->tconn->net_conf->ko_count;
 		drbd_update_congested(mdev);
 	}
 	do {
@@ -3038,7 +3038,7 @@ void drbd_init_set_defaults(struct drbd_conf *mdev)
 	drbd_thread_init(mdev, &mdev->tconn->worker, drbd_worker);
 	drbd_thread_init(mdev, &mdev->tconn->asender, drbd_asender);
 
-	mdev->agreed_pro_version = PRO_VERSION_MAX;
+	mdev->tconn->agreed_pro_version = PRO_VERSION_MAX;
 	mdev->write_ordering = WO_bdev_flush;
 	mdev->resync_wenr = LC_FREE;
 	mdev->peer_max_bio_size = DRBD_MAX_BIO_SIZE_SAFE;
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 59bb58c..a9ede8fc 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -845,9 +845,9 @@ void drbd_reconsider_max_bio_size(struct drbd_conf *mdev)
 	   Because new from 8.3.8 onwards the peer can use multiple
 	   BIOs for a single peer_request */
 	if (mdev->state.conn >= C_CONNECTED) {
-		if (mdev->agreed_pro_version < 94)
+		if (mdev->tconn->agreed_pro_version < 94)
 			peer = mdev->peer_max_bio_size;
-		else if (mdev->agreed_pro_version == 94)
+		else if (mdev->tconn->agreed_pro_version == 94)
 			peer = DRBD_MAX_SIZE_H80_PACKET;
 		else /* drbd 8.3.8 onwards */
 			peer = DRBD_MAX_BIO_SIZE;
@@ -1675,7 +1675,7 @@ static int drbd_nl_resize(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
 		goto fail;
 	}
 
-	if (rs.no_resync && mdev->agreed_pro_version < 93) {
+	if (rs.no_resync && mdev->tconn->agreed_pro_version < 93) {
 		retcode = ERR_NEED_APV_93;
 		goto fail;
 	}
@@ -2170,7 +2170,7 @@ static int drbd_nl_new_c_uuid(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nl
 	}
 
 	/* this is "skip initial sync", assume to be clean */
-	if (mdev->state.conn == C_CONNECTED && mdev->agreed_pro_version >= 90 &&
+	if (mdev->state.conn == C_CONNECTED && mdev->tconn->agreed_pro_version >= 90 &&
 	    mdev->ldev->md.uuid[UI_CURRENT] == UUID_JUST_CREATED && args.clear_bm) {
 		dev_info(DEV, "Preparing to skip initial sync\n");
 		skip_initial_sync = 1;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index e9f670c..27a8363 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -872,7 +872,7 @@ retry:
 
 	mdev->tconn->data.socket = sock;
 	mdev->tconn->meta.socket = msock;
-	mdev->last_received = jiffies;
+	mdev->tconn->last_received = jiffies;
 
 	D_ASSERT(mdev->tconn->asender.task == NULL);
 
@@ -948,7 +948,7 @@ static int drbd_recv_header(struct drbd_conf *mdev, enum drbd_packets *cmd, unsi
 		    be16_to_cpu(h->h80.length));
 		return false;
 	}
-	mdev->last_received = jiffies;
+	mdev->tconn->last_received = jiffies;
 
 	return true;
 }
@@ -1244,7 +1244,7 @@ read_in_block(struct drbd_conf *mdev, u64 id, sector_t sector, int data_size) __
 	void *dig_vv = mdev->int_dig_vv;
 	unsigned long *data;
 
-	dgs = (mdev->agreed_pro_version >= 87 && mdev->integrity_r_tfm) ?
+	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->integrity_r_tfm) ?
 		crypto_hash_digestsize(mdev->integrity_r_tfm) : 0;
 
 	if (dgs) {
@@ -1361,7 +1361,7 @@ static int recv_dless_read(struct drbd_conf *mdev, struct drbd_request *req,
 	void *dig_in = mdev->int_dig_in;
 	void *dig_vv = mdev->int_dig_vv;
 
-	dgs = (mdev->agreed_pro_version >= 87 && mdev->integrity_r_tfm) ?
+	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->integrity_r_tfm) ?
 		crypto_hash_digestsize(mdev->integrity_r_tfm) : 0;
 
 	if (dgs) {
@@ -2048,7 +2048,7 @@ static int receive_DataRequest(struct drbd_conf *mdev, enum drbd_packets cmd, un
 			goto out_free_e;
 
 		if (cmd == P_CSUM_RS_REQUEST) {
-			D_ASSERT(mdev->agreed_pro_version >= 89);
+			D_ASSERT(mdev->tconn->agreed_pro_version >= 89);
 			e->w.cb = w_e_end_csum_rs_req;
 			/* used in the sector offset progress display */
 			mdev->bm_resync_fo = BM_SECT_TO_BIT(sector);
@@ -2065,7 +2065,7 @@ static int receive_DataRequest(struct drbd_conf *mdev, enum drbd_packets cmd, un
 
 	case P_OV_REQUEST:
 		if (mdev->ov_start_sector == ~(sector_t)0 &&
-		    mdev->agreed_pro_version >= 90) {
+		    mdev->tconn->agreed_pro_version >= 90) {
 			unsigned long now = jiffies;
 			int i;
 			mdev->ov_start_sector = sector;
@@ -2360,7 +2360,7 @@ static int drbd_uuid_compare(struct drbd_conf *mdev, int *rule_nr) __must_hold(l
 
 		if (mdev->p_uuid[UI_BITMAP] == (u64)0 && mdev->ldev->md.uuid[UI_BITMAP] != (u64)0) {
 
-			if (mdev->agreed_pro_version < 91)
+			if (mdev->tconn->agreed_pro_version < 91)
 				return -1091;
 
 			if ((mdev->ldev->md.uuid[UI_BITMAP] & ~((u64)1)) == (mdev->p_uuid[UI_HISTORY_START] & ~((u64)1)) &&
@@ -2381,7 +2381,7 @@ static int drbd_uuid_compare(struct drbd_conf *mdev, int *rule_nr) __must_hold(l
 
 		if (mdev->ldev->md.uuid[UI_BITMAP] == (u64)0 && mdev->p_uuid[UI_BITMAP] != (u64)0) {
 
-			if (mdev->agreed_pro_version < 91)
+			if (mdev->tconn->agreed_pro_version < 91)
 				return -1091;
 
 			if ((mdev->ldev->md.uuid[UI_HISTORY_START] & ~((u64)1)) == (mdev->p_uuid[UI_BITMAP] & ~((u64)1)) &&
@@ -2427,14 +2427,14 @@ static int drbd_uuid_compare(struct drbd_conf *mdev, int *rule_nr) __must_hold(l
 	*rule_nr = 51;
 	peer = mdev->p_uuid[UI_HISTORY_START] & ~((u64)1);
 	if (self == peer) {
-		if (mdev->agreed_pro_version < 96 ?
+		if (mdev->tconn->agreed_pro_version < 96 ?
 		    (mdev->ldev->md.uuid[UI_HISTORY_START] & ~((u64)1)) ==
 		    (mdev->p_uuid[UI_HISTORY_START + 1] & ~((u64)1)) :
 		    peer + UUID_NEW_BM_OFFSET == (mdev->p_uuid[UI_BITMAP] & ~((u64)1))) {
 			/* The last P_SYNC_UUID did not get though. Undo the last start of
 			   resync as sync source modifications of the peer's UUIDs. */
 
-			if (mdev->agreed_pro_version < 91)
+			if (mdev->tconn->agreed_pro_version < 91)
 				return -1091;
 
 			mdev->p_uuid[UI_BITMAP] = mdev->p_uuid[UI_HISTORY_START];
@@ -2464,14 +2464,14 @@ static int drbd_uuid_compare(struct drbd_conf *mdev, int *rule_nr) __must_hold(l
 	*rule_nr = 71;
 	self = mdev->ldev->md.uuid[UI_HISTORY_START] & ~((u64)1);
 	if (self == peer) {
-		if (mdev->agreed_pro_version < 96 ?
+		if (mdev->tconn->agreed_pro_version < 96 ?
 		    (mdev->ldev->md.uuid[UI_HISTORY_START + 1] & ~((u64)1)) ==
 		    (mdev->p_uuid[UI_HISTORY_START] & ~((u64)1)) :
 		    self + UUID_NEW_BM_OFFSET == (mdev->ldev->md.uuid[UI_BITMAP] & ~((u64)1))) {
 			/* The last P_SYNC_UUID did not get though. Undo the last start of
 			   resync as sync source modifications of our UUIDs. */
 
-			if (mdev->agreed_pro_version < 91)
+			if (mdev->tconn->agreed_pro_version < 91)
 				return -1091;
 
 			_drbd_uuid_set(mdev, UI_BITMAP, mdev->ldev->md.uuid[UI_HISTORY_START]);
@@ -2731,7 +2731,7 @@ static int receive_protocol(struct drbd_conf *mdev, enum drbd_packets cmd, unsig
 		goto disconnect;
 	}
 
-	if (mdev->agreed_pro_version >= 87) {
+	if (mdev->tconn->agreed_pro_version >= 87) {
 		unsigned char *my_alg = mdev->tconn->net_conf->integrity_alg;
 
 		if (drbd_recv(mdev, p_integrity_alg, data_size) != data_size)
@@ -2787,7 +2787,7 @@ static int receive_SyncParam(struct drbd_conf *mdev, enum drbd_packets cmd, unsi
 	unsigned int header_size, data_size, exp_max_sz;
 	struct crypto_hash *verify_tfm = NULL;
 	struct crypto_hash *csums_tfm = NULL;
-	const int apv = mdev->agreed_pro_version;
+	const int apv = mdev->tconn->agreed_pro_version;
 	int *rs_plan_s = NULL;
 	int fifo_size = 0;
 
@@ -3074,7 +3074,7 @@ static int receive_uuids(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 	if (get_ldev(mdev)) {
 		int skip_initial_sync =
 			mdev->state.conn == C_CONNECTED &&
-			mdev->agreed_pro_version >= 90 &&
+			mdev->tconn->agreed_pro_version >= 90 &&
 			mdev->ldev->md.uuid[UI_CURRENT] == UUID_JUST_CREATED &&
 			(p_uuid[UI_FLAGS] & 8);
 		if (skip_initial_sync) {
@@ -3967,10 +3967,10 @@ static int drbd_do_handshake(struct drbd_conf *mdev)
 	    PRO_VERSION_MIN > p->protocol_max)
 		goto incompat;
 
-	mdev->agreed_pro_version = min_t(int, PRO_VERSION_MAX, p->protocol_max);
+	mdev->tconn->agreed_pro_version = min_t(int, PRO_VERSION_MAX, p->protocol_max);
 
 	dev_info(DEV, "Handshake successful: "
-	     "Agreed network protocol version %d\n", mdev->agreed_pro_version);
+	     "Agreed network protocol version %d\n", mdev->tconn->agreed_pro_version);
 
 	return 1;
 
@@ -4220,7 +4220,7 @@ static int got_IsInSync(struct drbd_conf *mdev, struct p_header80 *h)
 	sector_t sector = be64_to_cpu(p->sector);
 	int blksize = be32_to_cpu(p->blksize);
 
-	D_ASSERT(mdev->agreed_pro_version >= 89);
+	D_ASSERT(mdev->tconn->agreed_pro_version >= 89);
 
 	update_peer_seq(mdev, be32_to_cpu(p->seq_num));
 
@@ -4560,7 +4560,7 @@ int drbd_asender(struct drbd_thread *thi)
 		} else if (rv == -EAGAIN) {
 			/* If the data socket received something meanwhile,
 			 * that is good enough: peer is still alive. */
-			if (time_after(mdev->last_received,
+			if (time_after(mdev->tconn->last_received,
 				jiffies - mdev->tconn->meta.socket->sk->sk_rcvtimeo))
 				continue;
 			if (ping_timeout_active) {
@@ -4598,7 +4598,7 @@ int drbd_asender(struct drbd_thread *thi)
 				goto reconnect;
 		}
 		if (received == expect) {
-			mdev->last_received = jiffies;
+			mdev->tconn->last_received = jiffies;
 			D_ASSERT(cmd != NULL);
 			if (!cmd->process(mdev, h))
 				goto reconnect;
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index ac43e44..c871ef2 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -951,7 +951,7 @@ allocate_barrier:
 		_req_mod(req, QUEUE_FOR_SEND_OOS);
 
 	if (remote &&
-	    mdev->tconn->net_conf->on_congestion != OC_BLOCK && mdev->agreed_pro_version >= 96) {
+	    mdev->tconn->net_conf->on_congestion != OC_BLOCK && mdev->tconn->agreed_pro_version >= 96) {
 		int congested = 0;
 
 		if (mdev->tconn->net_conf->cong_fill &&
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 1ca7856..ec26df3 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -616,7 +616,7 @@ next_sector:
 		/* adjust very last sectors, in case we are oddly sized */
 		if (sector + (size>>9) > capacity)
 			size = (capacity-sector)<<9;
-		if (mdev->agreed_pro_version >= 89 && mdev->csums_tfm) {
+		if (mdev->tconn->agreed_pro_version >= 89 && mdev->csums_tfm) {
 			switch (read_for_csum(mdev, sector, size)) {
 			case -EIO: /* Disk failure */
 				put_ldev(mdev);
@@ -1574,10 +1574,10 @@ void drbd_start_resync(struct drbd_conf *mdev, enum drbd_conns side)
 		 * drbd_resync_finished from here in that case.
 		 * We drbd_gen_and_send_sync_uuid here for protocol < 96,
 		 * and from after_state_ch otherwise. */
-		if (side == C_SYNC_SOURCE && mdev->agreed_pro_version < 96)
+		if (side == C_SYNC_SOURCE && mdev->tconn->agreed_pro_version < 96)
 			drbd_gen_and_send_sync_uuid(mdev);
 
-		if (mdev->agreed_pro_version < 95 && mdev->rs_total == 0) {
+		if (mdev->tconn->agreed_pro_version < 95 && mdev->rs_total == 0) {
 			/* This still has a race (about when exactly the peers
 			 * detect connection loss) that can lead to a full sync
 			 * on next handshake. In 8.3.9 we fixed this with explicit
-- 
1.7.4.1

