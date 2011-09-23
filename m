Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab1IWOdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 10:33:05 -0400
Received: from mail09.linbit.com ([212.69.161.110]:39507 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab1IWOba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 10:31:30 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 04/10] drbd: Replace and remove old primitives
Date: Fri, 23 Sep 2011 16:31:19 +0200
Message-Id: <1316788285-17433-5-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316788285-17433-1-git-send-email-philipp.reisner@linbit.com>
References: <1316788285-17433-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |   45 +----
 drivers/block/drbd/drbd_main.c     |  502 ++++++++++++++++--------------------
 drivers/block/drbd/drbd_receiver.c |   86 ++++---
 drivers/block/drbd/drbd_worker.c   |   24 +-
 4 files changed, 294 insertions(+), 363 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 29db016..e5dc772 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1060,22 +1060,6 @@ static inline struct drbd_conf *vnr_to_mdev(struct drbd_tconn *tconn, int vnr)
 	return (struct drbd_conf *)idr_find(&tconn->volumes, vnr);
 }
 
-static inline int drbd_get_data_sock(struct drbd_tconn *tconn)
-{
-	mutex_lock(&tconn->data.mutex);
-	if (!tconn->data.socket) {
-		/* Disconnected.  */
-		mutex_unlock(&tconn->data.mutex);
-		return -EIO;
-	}
-	return 0;
-}
-
-static inline void drbd_put_data_sock(struct drbd_tconn *tconn)
-{
-	mutex_unlock(&tconn->data.mutex);
-}
-
 /*
  * function declarations
  *************************/
@@ -1118,13 +1102,6 @@ extern int _conn_send_state_req(struct drbd_tconn *, int vnr, enum drbd_packet c
 				union drbd_state, union drbd_state);
 extern int _drbd_send_state(struct drbd_conf *mdev);
 extern int drbd_send_state(struct drbd_conf *mdev);
-extern int _conn_send_cmd(struct drbd_tconn *tconn, int vnr, struct drbd_socket *sock,
-			  enum drbd_packet cmd, struct p_header *h, size_t size,
-			  unsigned msg_flags);
-extern int conn_send_cmd(struct drbd_tconn *tconn, int vnr, struct drbd_socket *sock,
-			 enum drbd_packet cmd, struct p_header *h, size_t size);
-extern int conn_send_cmd2(struct drbd_tconn *tconn, enum drbd_packet cmd,
-			  char *data, size_t size);
 extern int drbd_send_sync_param(struct drbd_conf *mdev);
 extern void drbd_send_b_ack(struct drbd_conf *mdev, u32 barrier_nr,
 			    u32 set_size);
@@ -1149,7 +1126,7 @@ extern int drbd_send_ov_request(struct drbd_conf *mdev,sector_t sector,int size)
 
 extern int drbd_send_bitmap(struct drbd_conf *mdev);
 extern void drbd_send_sr_reply(struct drbd_conf *mdev, enum drbd_state_rv retcode);
-extern int conn_send_sr_reply(struct drbd_tconn *tconn, enum drbd_state_rv retcode);
+extern void conn_send_sr_reply(struct drbd_tconn *tconn, enum drbd_state_rv retcode);
 extern void drbd_free_bc(struct drbd_backing_dev *ldev);
 extern void drbd_mdev_cleanup(struct drbd_conf *mdev);
 void drbd_print_uuids(struct drbd_conf *mdev, const char *text);
@@ -1885,26 +1862,6 @@ static inline void request_ping(struct drbd_tconn *tconn)
 	wake_asender(tconn);
 }
 
-static inline int _drbd_send_cmd(struct drbd_conf *mdev, struct drbd_socket *sock,
-				  enum drbd_packet cmd, struct p_header *h, size_t size,
-				  unsigned msg_flags)
-{
-	return _conn_send_cmd(mdev->tconn, mdev->vnr, sock, cmd, h, size, msg_flags);
-}
-
-static inline int drbd_send_cmd(struct drbd_conf *mdev, struct drbd_socket *sock,
-				enum drbd_packet cmd, struct p_header *h, size_t size)
-{
-	return conn_send_cmd(mdev->tconn, mdev->vnr, sock, cmd, h, size);
-}
-
-static inline int drbd_send_short_cmd(struct drbd_conf *mdev,
-				      enum drbd_packet cmd)
-{
-	struct p_header h;
-	return drbd_send_cmd(mdev, &mdev->tconn->data, cmd, &h, sizeof(h));
-}
-
 extern void *conn_prepare_command(struct drbd_tconn *, struct drbd_socket *);
 extern void *drbd_prepare_command(struct drbd_conf *, struct drbd_socket *);
 extern int conn_send_command(struct drbd_tconn *, struct drbd_socket *,
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index b291d73..4aec4af 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -717,8 +717,8 @@ static void prepare_header95(struct p_header95 *h, enum drbd_packet cmd, int siz
 	h->vol_n_len = cpu_to_be32(vnr << 24 | size);
 }
 
-static void _prepare_header(struct drbd_tconn *tconn, int vnr, struct p_header *h,
-			    enum drbd_packet cmd, int size)
+static void prepare_header(struct drbd_tconn *tconn, int vnr, struct p_header *h,
+			   enum drbd_packet cmd, int size)
 {
 	if (tconn->agreed_pro_version >= 95)
 		prepare_header95(&h->h95, cmd, size, vnr);
@@ -726,59 +726,6 @@ static void _prepare_header(struct drbd_tconn *tconn, int vnr, struct p_header *
 		prepare_header80(&h->h80, cmd, size);
 }
 
-static void prepare_header(struct drbd_conf *mdev, struct p_header *h,
-			   enum drbd_packet cmd, int size)
-{
-	_prepare_header(mdev->tconn, mdev->vnr, h, cmd, size);
-}
-
-/* the appropriate socket mutex must be held already */
-int _conn_send_cmd(struct drbd_tconn *tconn, int vnr, struct drbd_socket *sock,
-		   enum drbd_packet cmd, struct p_header *h, size_t size,
-		   unsigned msg_flags)
-{
-	int err;
-
-	_prepare_header(tconn, vnr, h, cmd, size - sizeof(struct p_header));
-	err = drbd_send_all(tconn, sock->socket, h, size, msg_flags);
-	if (err && !signal_pending(current))
-		conn_warn(tconn, "short send %s size=%d\n",
-			  cmdname(cmd), (int)size);
-	return err;
-}
-
-/* don't pass the socket. we may only look at it
- * when we hold the appropriate socket mutex.
- */
-int conn_send_cmd(struct drbd_tconn *tconn, int vnr, struct drbd_socket *sock,
-		  enum drbd_packet cmd, struct p_header *h, size_t size)
-{
-	int err = -EIO;
-
-	mutex_lock(&sock->mutex);
-	if (sock->socket)
-		err = _conn_send_cmd(tconn, vnr, sock, cmd, h, size, 0);
-	mutex_unlock(&sock->mutex);
-	return err;
-}
-
-int conn_send_cmd2(struct drbd_tconn *tconn, enum drbd_packet cmd, char *data,
-		   size_t size)
-{
-	struct p_header80 h;
-	int err;
-
-	prepare_header80(&h, cmd, size);
-	err = drbd_get_data_sock(tconn);
-	if (!err) {
-		err = drbd_send_all(tconn, tconn->data.socket, &h, sizeof(h), 0);
-		if (!err)
-			err = drbd_send_all(tconn, tconn->data.socket, data, size, 0);
-		drbd_put_data_sock(tconn);
-	}
-	return err;
-}
-
 void *conn_prepare_command(struct drbd_tconn *tconn, struct drbd_socket *sock)
 {
 	mutex_lock(&sock->mutex);
@@ -811,8 +758,8 @@ static int __send_command(struct drbd_tconn *tconn, int vnr,
 	 */
 	msg_flags = data ? MSG_MORE : 0;
 
-	_prepare_header(tconn, vnr, sock->sbuf, cmd,
-			header_size - sizeof(struct p_header) + size);
+	prepare_header(tconn, vnr, sock->sbuf, cmd,
+		       header_size - sizeof(struct p_header) + size);
 	err = drbd_send_all(tconn, sock->socket, sock->sbuf, header_size,
 			    msg_flags);
 	if (data && !err)
@@ -845,22 +792,36 @@ int drbd_send_command(struct drbd_conf *mdev, struct drbd_socket *sock,
 
 int drbd_send_ping(struct drbd_tconn *tconn)
 {
-	struct p_header h;
-	return conn_send_cmd(tconn, 0, &tconn->meta, P_PING, &h, sizeof(h));
+	struct drbd_socket *sock;
+
+	sock = &tconn->meta;
+	if (!conn_prepare_command(tconn, sock))
+		return -EIO;
+	return conn_send_command(tconn, sock, P_PING, sizeof(struct p_header), NULL, 0);
 }
 
 int drbd_send_ping_ack(struct drbd_tconn *tconn)
 {
-	struct p_header h;
-	return conn_send_cmd(tconn, 0, &tconn->meta, P_PING_ACK, &h, sizeof(h));
+	struct drbd_socket *sock;
+
+	sock = &tconn->meta;
+	if (!conn_prepare_command(tconn, sock))
+		return -EIO;
+	return conn_send_command(tconn, sock, P_PING_ACK, sizeof(struct p_header), NULL, 0);
 }
 
 int drbd_send_sync_param(struct drbd_conf *mdev)
 {
-	struct p_rs_param_95 *p;
 	struct drbd_socket *sock;
-	int size, err;
+	struct p_rs_param_95 *p;
+	int size;
 	const int apv = mdev->tconn->agreed_pro_version;
+	enum drbd_packet cmd;
+
+	sock = &mdev->tconn->data;
+	p = drbd_prepare_command(mdev, sock);
+	if (!p)
+		return -EIO;
 
 	size = apv <= 87 ? sizeof(struct p_rs_param)
 		: apv == 88 ? sizeof(struct p_rs_param)
@@ -868,112 +829,96 @@ int drbd_send_sync_param(struct drbd_conf *mdev)
 		: apv <= 94 ? sizeof(struct p_rs_param_89)
 		: /* apv >= 95 */ sizeof(struct p_rs_param_95);
 
-	mutex_lock(&mdev->tconn->data.mutex);
-	sock = &mdev->tconn->data;
-
-	if (likely(sock->socket != NULL)) {
-		enum drbd_packet cmd =
-			apv >= 89 ? P_SYNC_PARAM89 : P_SYNC_PARAM;
-
-		p = mdev->tconn->data.sbuf;
-
-		/* initialize verify_alg and csums_alg */
-		memset(p->verify_alg, 0, 2 * SHARED_SECRET_MAX);
-
-		if (get_ldev(mdev)) {
-			p->rate = cpu_to_be32(mdev->ldev->dc.resync_rate);
-			p->c_plan_ahead = cpu_to_be32(mdev->ldev->dc.c_plan_ahead);
-			p->c_delay_target = cpu_to_be32(mdev->ldev->dc.c_delay_target);
-			p->c_fill_target = cpu_to_be32(mdev->ldev->dc.c_fill_target);
-			p->c_max_rate = cpu_to_be32(mdev->ldev->dc.c_max_rate);
-			put_ldev(mdev);
-		} else {
-			p->rate = cpu_to_be32(DRBD_RATE_DEF);
-			p->c_plan_ahead = cpu_to_be32(DRBD_C_PLAN_AHEAD_DEF);
-			p->c_delay_target = cpu_to_be32(DRBD_C_DELAY_TARGET_DEF);
-			p->c_fill_target = cpu_to_be32(DRBD_C_FILL_TARGET_DEF);
-			p->c_max_rate = cpu_to_be32(DRBD_C_MAX_RATE_DEF);
-		}
+	cmd = apv >= 89 ? P_SYNC_PARAM89 : P_SYNC_PARAM;
 
-		if (apv >= 88)
-			strcpy(p->verify_alg, mdev->tconn->net_conf->verify_alg);
-		if (apv >= 89)
-			strcpy(p->csums_alg, mdev->tconn->net_conf->csums_alg);
+	/* initialize verify_alg and csums_alg */
+	memset(p->verify_alg, 0, 2 * SHARED_SECRET_MAX);
 
-		err = _drbd_send_cmd(mdev, sock, cmd, &p->head, size, 0);
-	} else
-		err = -EIO;
+	if (get_ldev(mdev)) {
+		p->rate = cpu_to_be32(mdev->ldev->dc.resync_rate);
+		p->c_plan_ahead = cpu_to_be32(mdev->ldev->dc.c_plan_ahead);
+		p->c_delay_target = cpu_to_be32(mdev->ldev->dc.c_delay_target);
+		p->c_fill_target = cpu_to_be32(mdev->ldev->dc.c_fill_target);
+		p->c_max_rate = cpu_to_be32(mdev->ldev->dc.c_max_rate);
+		put_ldev(mdev);
+	} else {
+		p->rate = cpu_to_be32(DRBD_RATE_DEF);
+		p->c_plan_ahead = cpu_to_be32(DRBD_C_PLAN_AHEAD_DEF);
+		p->c_delay_target = cpu_to_be32(DRBD_C_DELAY_TARGET_DEF);
+		p->c_fill_target = cpu_to_be32(DRBD_C_FILL_TARGET_DEF);
+		p->c_max_rate = cpu_to_be32(DRBD_C_MAX_RATE_DEF);
+	}
 
-	mutex_unlock(&mdev->tconn->data.mutex);
+	if (apv >= 88)
+		strcpy(p->verify_alg, mdev->tconn->net_conf->verify_alg);
+	if (apv >= 89)
+		strcpy(p->csums_alg, mdev->tconn->net_conf->csums_alg);
 
-	return err;
+	return drbd_send_command(mdev, sock, cmd, size, NULL, 0);
 }
 
 int drbd_send_protocol(struct drbd_tconn *tconn)
 {
+	struct drbd_socket *sock;
 	struct p_protocol *p;
-	int size, cf, err;
+	int size, cf;
+
+	if (tconn->net_conf->dry_run && tconn->agreed_pro_version < 92) {
+		conn_err(tconn, "--dry-run is not supported by peer");
+		return -EOPNOTSUPP;
+	}
 
-	size = sizeof(struct p_protocol);
+	sock = &tconn->data;
+	p = conn_prepare_command(tconn, sock);
+	if (!p)
+		return -EIO;
 
+	size = sizeof(*p);
 	if (tconn->agreed_pro_version >= 87)
 		size += strlen(tconn->net_conf->integrity_alg) + 1;
 
-	/* we must not recurse into our own queue,
-	 * as that is blocked during handshake */
-	p = kmalloc(size, GFP_NOIO);
-	if (p == NULL)
-		return -ENOMEM;
-
 	p->protocol      = cpu_to_be32(tconn->net_conf->wire_protocol);
 	p->after_sb_0p   = cpu_to_be32(tconn->net_conf->after_sb_0p);
 	p->after_sb_1p   = cpu_to_be32(tconn->net_conf->after_sb_1p);
 	p->after_sb_2p   = cpu_to_be32(tconn->net_conf->after_sb_2p);
 	p->two_primaries = cpu_to_be32(tconn->net_conf->two_primaries);
-
 	cf = 0;
 	if (tconn->net_conf->want_lose)
 		cf |= CF_WANT_LOSE;
-	if (tconn->net_conf->dry_run) {
-		if (tconn->agreed_pro_version >= 92)
-			cf |= CF_DRY_RUN;
-		else {
-			conn_err(tconn, "--dry-run is not supported by peer");
-			kfree(p);
-			return -EOPNOTSUPP;
-		}
-	}
+	if (tconn->net_conf->dry_run)
+		cf |= CF_DRY_RUN;
 	p->conn_flags    = cpu_to_be32(cf);
 
 	if (tconn->agreed_pro_version >= 87)
 		strcpy(p->integrity_alg, tconn->net_conf->integrity_alg);
-
-	err = conn_send_cmd2(tconn, P_PROTOCOL, p->head.payload, size - sizeof(struct p_header));
-	kfree(p);
-	return err;
+	return conn_send_command(tconn, sock, P_PROTOCOL, size, NULL, 0);
 }
 
 int _drbd_send_uuids(struct drbd_conf *mdev, u64 uuid_flags)
 {
-	struct p_uuids p;
+	struct drbd_socket *sock;
+	struct p_uuids *p;
 	int i;
 
 	if (!get_ldev_if_state(mdev, D_NEGOTIATING))
 		return 0;
 
+	sock = &mdev->tconn->data;
+	p = drbd_prepare_command(mdev, sock);
+	if (!p)
+		return -EIO;
 	for (i = UI_CURRENT; i < UI_SIZE; i++)
-		p.uuid[i] = mdev->ldev ? cpu_to_be64(mdev->ldev->md.uuid[i]) : 0;
+		p->uuid[i] = mdev->ldev ? cpu_to_be64(mdev->ldev->md.uuid[i]) : 0;
 
 	mdev->comm_bm_set = drbd_bm_total_weight(mdev);
-	p.uuid[UI_SIZE] = cpu_to_be64(mdev->comm_bm_set);
+	p->uuid[UI_SIZE] = cpu_to_be64(mdev->comm_bm_set);
 	uuid_flags |= mdev->tconn->net_conf->want_lose ? 1 : 0;
 	uuid_flags |= test_bit(CRASHED_PRIMARY, &mdev->flags) ? 2 : 0;
 	uuid_flags |= mdev->new_state_tmp.disk == D_INCONSISTENT ? 4 : 0;
-	p.uuid[UI_FLAGS] = cpu_to_be64(uuid_flags);
+	p->uuid[UI_FLAGS] = cpu_to_be64(uuid_flags);
 
 	put_ldev(mdev);
-
-	return drbd_send_cmd(mdev, &mdev->tconn->data, P_UUIDS, &p.head, sizeof(p));
+	return drbd_send_command(mdev, sock, P_UUIDS, sizeof(*p), NULL, 0);
 }
 
 int drbd_send_uuids(struct drbd_conf *mdev)
@@ -1006,7 +951,8 @@ void drbd_print_uuids(struct drbd_conf *mdev, const char *text)
 
 void drbd_gen_and_send_sync_uuid(struct drbd_conf *mdev)
 {
-	struct p_rs_uuid p;
+	struct drbd_socket *sock;
+	struct p_rs_uuid *p;
 	u64 uuid;
 
 	D_ASSERT(mdev->state.disk == D_UP_TO_DATE);
@@ -1015,14 +961,19 @@ void drbd_gen_and_send_sync_uuid(struct drbd_conf *mdev)
 	drbd_uuid_set(mdev, UI_BITMAP, uuid);
 	drbd_print_uuids(mdev, "updated sync UUID");
 	drbd_md_sync(mdev);
-	p.uuid = cpu_to_be64(uuid);
 
-	drbd_send_cmd(mdev, &mdev->tconn->data, P_SYNC_UUID, &p.head, sizeof(p));
+	sock = &mdev->tconn->data;
+	p = drbd_prepare_command(mdev, sock);
+	if (p) {
+		p->uuid = cpu_to_be64(uuid);
+		drbd_send_command(mdev, sock, P_SYNC_UUID, sizeof(*p), NULL, 0);
+	}
 }
 
 int drbd_send_sizes(struct drbd_conf *mdev, int trigger_reply, enum dds_flags flags)
 {
-	struct p_sizes p;
+	struct drbd_socket *sock;
+	struct p_sizes *p;
 	sector_t d_size, u_size;
 	int q_order_type, max_bio_size;
 
@@ -1041,14 +992,17 @@ int drbd_send_sizes(struct drbd_conf *mdev, int trigger_reply, enum dds_flags fl
 		max_bio_size = DRBD_MAX_BIO_SIZE; /* ... multiple BIOs per peer_request */
 	}
 
-	p.d_size = cpu_to_be64(d_size);
-	p.u_size = cpu_to_be64(u_size);
-	p.c_size = cpu_to_be64(trigger_reply ? 0 : drbd_get_capacity(mdev->this_bdev));
-	p.max_bio_size = cpu_to_be32(max_bio_size);
-	p.queue_order_type = cpu_to_be16(q_order_type);
-	p.dds_flags = cpu_to_be16(flags);
-
-	return drbd_send_cmd(mdev, &mdev->tconn->data, P_SIZES, &p.head, sizeof(p));
+	sock = &mdev->tconn->data;
+	p = drbd_prepare_command(mdev, sock);
+	if (!p)
+		return -EIO;
+	p->d_size = cpu_to_be64(d_size);
+	p->u_size = cpu_to_be64(u_size);
+	p->c_size = cpu_to_be64(trigger_reply ? 0 : drbd_get_capacity(mdev->this_bdev));
+	p->max_bio_size = cpu_to_be32(max_bio_size);
+	p->queue_order_type = cpu_to_be16(q_order_type);
+	p->dds_flags = cpu_to_be16(flags);
+	return drbd_send_command(mdev, sock, P_SIZES, sizeof(*p), NULL, 0);
 }
 
 /**
@@ -1058,50 +1012,56 @@ int drbd_send_sizes(struct drbd_conf *mdev, int trigger_reply, enum dds_flags fl
 int drbd_send_state(struct drbd_conf *mdev)
 {
 	struct drbd_socket *sock;
-	struct p_state p;
-	int err = -EIO;
+	struct p_state *p;
 
-	mutex_lock(&mdev->tconn->data.mutex);
-
-	p.state = cpu_to_be32(mdev->state.i); /* Within the send mutex */
 	sock = &mdev->tconn->data;
-
-	if (likely(sock->socket != NULL))
-		err = _drbd_send_cmd(mdev, sock, P_STATE, &p.head, sizeof(p), 0);
-
-	mutex_unlock(&mdev->tconn->data.mutex);
-
-	return err;
+	p = drbd_prepare_command(mdev, sock);
+	if (!p)
+		return -EIO;
+	p->state = cpu_to_be32(mdev->state.i); /* Within the send mutex */
+	return drbd_send_command(mdev, sock, P_STATE, sizeof(*p), NULL, 0);
 }
 
 int _conn_send_state_req(struct drbd_tconn *tconn, int vnr, enum drbd_packet cmd,
 			 union drbd_state mask, union drbd_state val)
 {
-	struct p_req_state p;
-
-	p.mask    = cpu_to_be32(mask.i);
-	p.val     = cpu_to_be32(val.i);
+	struct drbd_socket *sock;
+	struct p_req_state *p;
 
-	return conn_send_cmd(tconn, vnr, &tconn->data, cmd, &p.head, sizeof(p));
+	sock = &tconn->data;
+	p = conn_prepare_command(tconn, sock);
+	if (!p)
+		return -EIO;
+	p->mask = cpu_to_be32(mask.i);
+	p->val = cpu_to_be32(val.i);
+	return conn_send_command(tconn, sock, cmd, sizeof(*p), NULL, 0);
 }
 
 void drbd_send_sr_reply(struct drbd_conf *mdev, enum drbd_state_rv retcode)
 {
-	struct p_req_state_reply p;
-
-	p.retcode    = cpu_to_be32(retcode);
+	struct drbd_socket *sock;
+	struct p_req_state_reply *p;
 
-	drbd_send_cmd(mdev, &mdev->tconn->meta, P_STATE_CHG_REPLY, &p.head, sizeof(p));
+	sock = &mdev->tconn->data;
+	p = drbd_prepare_command(mdev, sock);
+	if (p) {
+		p->retcode = cpu_to_be32(retcode);
+		drbd_send_command(mdev, sock, P_STATE_CHG_REPLY, sizeof(*p), NULL, 0);
+	}
 }
 
-int conn_send_sr_reply(struct drbd_tconn *tconn, enum drbd_state_rv retcode)
+void conn_send_sr_reply(struct drbd_tconn *tconn, enum drbd_state_rv retcode)
 {
-	struct p_req_state_reply p;
+	struct drbd_socket *sock;
+	struct p_req_state_reply *p;
 	enum drbd_packet cmd = tconn->agreed_pro_version < 100 ? P_STATE_CHG_REPLY : P_CONN_ST_CHG_REPLY;
 
-	p.retcode    = cpu_to_be32(retcode);
-
-	return !conn_send_cmd(tconn, 0, &tconn->meta, cmd, &p.head, sizeof(p));
+	sock = &tconn->data;
+	p = conn_prepare_command(tconn, sock);
+	if (p) {
+		p->retcode = cpu_to_be32(retcode);
+		conn_send_command(tconn, sock, cmd, sizeof(*p), NULL, 0);
+	}
 }
 
 static void dcbp_set_code(struct p_compressed_bm *p, enum drbd_bitmap_code code)
@@ -1224,21 +1184,20 @@ int fill_bitmap_rle_bits(struct drbd_conf *mdev,
 static int
 send_bitmap_rle_or_plain(struct drbd_conf *mdev, struct bm_xfer_ctx *c)
 {
-	struct p_compressed_bm *p = mdev->tconn->data.sbuf;
+	struct drbd_socket *sock = &mdev->tconn->data;
+	struct p_compressed_bm *p = sock->sbuf;
 	unsigned long num_words;
 	int len, err;
 
 	len = fill_bitmap_rle_bits(mdev, p, c);
-
 	if (len < 0)
 		return -EIO;
 
 	if (len) {
 		dcbp_set_code(p, RLE_VLI_Bits);
-		err = _drbd_send_cmd(mdev, &mdev->tconn->data,
-				     P_COMPRESSED_BITMAP, &p->head,
-				     sizeof(*p) + len, 0);
-
+		err = __send_command(mdev->tconn, mdev->vnr, sock,
+				     P_COMPRESSED_BITMAP, sizeof(*p) + len,
+				     NULL, 0);
 		c->packets[0]++;
 		c->bytes[0] += sizeof(*p) + len;
 
@@ -1247,14 +1206,14 @@ send_bitmap_rle_or_plain(struct drbd_conf *mdev, struct bm_xfer_ctx *c)
 	} else {
 		/* was not compressible.
 		 * send a buffer full of plain text bits instead. */
-		struct p_header *h = mdev->tconn->data.sbuf;
+		struct p_header *h = sock->sbuf;
 		num_words = min_t(size_t, BM_PACKET_WORDS, c->bm_words - c->word_offset);
 		len = num_words * sizeof(long);
 		if (len)
 			drbd_bm_get_lel(mdev, c->word_offset, num_words,
 					(unsigned long *)h->payload);
-		err = _drbd_send_cmd(mdev, &mdev->tconn->data, P_BITMAP,
-				     h, sizeof(struct p_header80) + len, 0);
+		err = __send_command(mdev->tconn, mdev->vnr, sock, P_BITMAP,
+				     sizeof(*h) + len, NULL, 0);
 		c->word_offset += num_words;
 		c->bit_offset = c->word_offset * BITS_PER_LONG;
 
@@ -1314,23 +1273,28 @@ static int _drbd_send_bitmap(struct drbd_conf *mdev)
 
 int drbd_send_bitmap(struct drbd_conf *mdev)
 {
-	int err;
+	struct drbd_socket *sock = &mdev->tconn->data;
+	int err = -1;
 
-	if (drbd_get_data_sock(mdev->tconn))
-		return -1;
-	err = !_drbd_send_bitmap(mdev);
-	drbd_put_data_sock(mdev->tconn);
+	mutex_lock(&sock->mutex);
+	if (sock->socket)
+		err = !_drbd_send_bitmap(mdev);
+	mutex_unlock(&sock->mutex);
 	return err;
 }
+
 void drbd_send_b_ack(struct drbd_conf *mdev, u32 barrier_nr, u32 set_size)
 {
-	struct p_barrier_ack p;
-
-	p.barrier  = barrier_nr;
-	p.set_size = cpu_to_be32(set_size);
+	struct drbd_socket *sock;
+	struct p_barrier_ack *p;
 
-	if (mdev->state.conn >= C_CONNECTED)
-		drbd_send_cmd(mdev, &mdev->tconn->meta, P_BARRIER_ACK, &p.head, sizeof(p));
+	sock = &mdev->tconn->meta;
+	p = drbd_prepare_command(mdev, sock);
+	if (!p || mdev->state.conn < C_CONNECTED)
+		return;
+	p->barrier = barrier_nr;
+	p->set_size = cpu_to_be32(set_size);
+	drbd_send_command(mdev, sock, P_BARRIER_ACK, sizeof(*p), NULL, 0);
 }
 
 /**
@@ -1344,16 +1308,18 @@ void drbd_send_b_ack(struct drbd_conf *mdev, u32 barrier_nr, u32 set_size)
 static int _drbd_send_ack(struct drbd_conf *mdev, enum drbd_packet cmd,
 			  u64 sector, u32 blksize, u64 block_id)
 {
-	struct p_block_ack p;
-
-	p.sector   = sector;
-	p.block_id = block_id;
-	p.blksize  = blksize;
-	p.seq_num  = cpu_to_be32(atomic_inc_return(&mdev->packet_seq));
+	struct drbd_socket *sock;
+	struct p_block_ack *p;
 
-	if (!mdev->tconn->meta.socket || mdev->state.conn < C_CONNECTED)
+	sock = &mdev->tconn->meta;
+	p = drbd_prepare_command(mdev, sock);
+	if (!p || mdev->state.conn < C_CONNECTED)
 		return -EIO;
-	return drbd_send_cmd(mdev, &mdev->tconn->meta, cmd, &p.head, sizeof(p));
+	p->sector = sector;
+	p->block_id = block_id;
+	p->blksize = blksize;
+	p->seq_num = cpu_to_be32(atomic_inc_return(&mdev->packet_seq));
+	return drbd_send_command(mdev, sock, cmd, sizeof(*p), NULL, 0);
 }
 
 /* dp->sector and dp->block_id already/still in network byte order,
@@ -1403,45 +1369,51 @@ int drbd_send_ack_ex(struct drbd_conf *mdev, enum drbd_packet cmd,
 int drbd_send_drequest(struct drbd_conf *mdev, int cmd,
 		       sector_t sector, int size, u64 block_id)
 {
-	struct p_block_req p;
-
-	p.sector   = cpu_to_be64(sector);
-	p.block_id = block_id;
-	p.blksize  = cpu_to_be32(size);
+	struct drbd_socket *sock;
+	struct p_block_req *p;
 
-	return drbd_send_cmd(mdev, &mdev->tconn->data, cmd, &p.head, sizeof(p));
+	sock = &mdev->tconn->data;
+	p = drbd_prepare_command(mdev, sock);
+	if (!p)
+		return -EIO;
+	p->sector = cpu_to_be64(sector);
+	p->block_id = block_id;
+	p->blksize = cpu_to_be32(size);
+	return drbd_send_command(mdev, sock, cmd, sizeof(*p), NULL, 0);
 }
 
 int drbd_send_drequest_csum(struct drbd_conf *mdev, sector_t sector, int size,
 			    void *digest, int digest_size, enum drbd_packet cmd)
 {
-	int err;
-	struct p_block_req p;
+	struct drbd_socket *sock;
+	struct p_block_req *p;
 
-	prepare_header(mdev, &p.head, cmd, sizeof(p) - sizeof(struct p_header) + digest_size);
-	p.sector   = cpu_to_be64(sector);
-	p.block_id = ID_SYNCER /* unused */;
-	p.blksize  = cpu_to_be32(size);
+	/* FIXME: Put the digest into the preallocated socket buffer.  */
 
-	mutex_lock(&mdev->tconn->data.mutex);
-	err = drbd_send_all(mdev->tconn, mdev->tconn->data.socket, &p, sizeof(p), 0);
-	if (!err)
-		err = drbd_send_all(mdev->tconn, mdev->tconn->data.socket, digest, digest_size, 0);
-	mutex_unlock(&mdev->tconn->data.mutex);
-	return err;
+	sock = &mdev->tconn->data;
+	p = drbd_prepare_command(mdev, sock);
+	if (!p)
+		return -EIO;
+	p->sector = cpu_to_be64(sector);
+	p->block_id = ID_SYNCER /* unused */;
+	p->blksize = cpu_to_be32(size);
+	return drbd_send_command(mdev, sock, P_STATE_CHG_REPLY, sizeof(*p),
+				 digest, digest_size);
 }
 
 int drbd_send_ov_request(struct drbd_conf *mdev, sector_t sector, int size)
 {
-	int ok;
-	struct p_block_req p;
-
-	p.sector   = cpu_to_be64(sector);
-	p.block_id = ID_SYNCER /* unused */;
-	p.blksize  = cpu_to_be32(size);
+	struct drbd_socket *sock;
+	struct p_block_req *p;
 
-	ok = !drbd_send_cmd(mdev, &mdev->tconn->data, P_OV_REQUEST, &p.head, sizeof(p));
-	return ok;
+	sock = &mdev->tconn->data;
+	p = drbd_prepare_command(mdev, sock);
+	if (!p)
+		return -EIO;
+	p->sector = cpu_to_be64(sector);
+	p->block_id = ID_SYNCER /* unused */;
+	p->blksize = cpu_to_be32(size);
+	return drbd_send_command(mdev, sock, P_OV_REQUEST, sizeof(*p), NULL, 0);
 }
 
 /* called on sndtimeo
@@ -1634,39 +1606,30 @@ static u32 bio_flags_to_wire(struct drbd_conf *mdev, unsigned long bi_rw)
  */
 int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 {
-	int err;
-	struct p_data p;
+	struct drbd_socket *sock;
+	struct p_data *p;
 	unsigned int dp_flags = 0;
-	void *dgb;
 	int dgs;
-
-	err = drbd_get_data_sock(mdev->tconn);
-	if (err)
-		return err;
+	int err;
 
 	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->integrity_w_tfm) ?
 		crypto_hash_digestsize(mdev->tconn->integrity_w_tfm) : 0;
 
-	prepare_header(mdev, &p.head, P_DATA, sizeof(p) - sizeof(struct p_header) + dgs + req->i.size);
-	p.sector   = cpu_to_be64(req->i.sector);
-	p.block_id = (unsigned long)req;
-	p.seq_num  = cpu_to_be32(req->seq_num = atomic_inc_return(&mdev->packet_seq));
-
+	sock = &mdev->tconn->data;
+	p = drbd_prepare_command(mdev, sock);
+	if (!p)
+		return -EIO;
+	p->sector = cpu_to_be64(req->i.sector);
+	p->block_id = (unsigned long)req;
+	p->seq_num = cpu_to_be32(req->seq_num = atomic_inc_return(&mdev->packet_seq));
 	dp_flags = bio_flags_to_wire(mdev, req->master_bio->bi_rw);
-
 	if (mdev->state.conn >= C_SYNC_SOURCE &&
 	    mdev->state.conn <= C_PAUSED_SYNC_T)
 		dp_flags |= DP_MAY_SET_IN_SYNC;
-
-	p.dp_flags = cpu_to_be32(dp_flags);
-	set_bit(UNPLUG_REMOTE, &mdev->flags);
-	err = drbd_send_all(mdev->tconn, mdev->tconn->data.socket, &p,
-			    sizeof(p), dgs ? MSG_MORE : 0);
-	if (!err && dgs) {
-		dgb = mdev->tconn->int_dig_out;
-		drbd_csum_bio(mdev, mdev->tconn->integrity_w_tfm, req->master_bio, dgb);
-		err = drbd_send_all(mdev->tconn, mdev->tconn->data.socket, dgb, dgs, 0);
-	}
+	p->dp_flags = cpu_to_be32(dp_flags);
+	if (dgs)
+		drbd_csum_bio(mdev, mdev->tconn->integrity_w_tfm, req->master_bio, p + 1);
+	err = __send_command(mdev->tconn, mdev->vnr, sock, P_DATA, sizeof(*p) + dgs, NULL, req->i.size);
 	if (!err) {
 		/* For protocol A, we have to memcpy the payload into
 		 * socket buffers, as we may complete right away
@@ -1690,7 +1653,7 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 			 * currently supported in kernel crypto. */
 			unsigned char digest[64];
 			drbd_csum_bio(mdev, mdev->tconn->integrity_w_tfm, req->master_bio, digest);
-			if (memcmp(mdev->tconn->int_dig_out, digest, dgs)) {
+			if (memcmp(p + 1, digest, dgs)) {
 				dev_warn(DEV,
 					"Digest mismatch, buffer modified by upper layers during write: %llus +%u\n",
 					(unsigned long long)req->i.sector, req->i.size);
@@ -1699,8 +1662,7 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 		     ... Be noisy about digest too large ...
 		} */
 	}
-
-	drbd_put_data_sock(mdev->tconn);
+	mutex_unlock(&sock->mutex);  /* locked by drbd_prepare_command() */
 
 	return err;
 }
@@ -1712,51 +1674,43 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 int drbd_send_block(struct drbd_conf *mdev, enum drbd_packet cmd,
 		    struct drbd_peer_request *peer_req)
 {
+	struct drbd_socket *sock;
+	struct p_data *p;
 	int err;
-	struct p_data p;
-	void *dgb;
 	int dgs;
 
 	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->integrity_w_tfm) ?
 		crypto_hash_digestsize(mdev->tconn->integrity_w_tfm) : 0;
 
-	prepare_header(mdev, &p.head, cmd, sizeof(p) -
-					   sizeof(struct p_header80) +
-					   dgs + peer_req->i.size);
-	p.sector   = cpu_to_be64(peer_req->i.sector);
-	p.block_id = peer_req->block_id;
-	p.seq_num = 0;  /* unused */
-
-	/* Only called by our kernel thread.
-	 * This one may be interrupted by DRBD_SIG and/or DRBD_SIGKILL
-	 * in response to admin command or module unload.
-	 */
-	err = drbd_get_data_sock(mdev->tconn);
-	if (err)
-		return err;
-	err = drbd_send_all(mdev->tconn, mdev->tconn->data.socket, &p,
-			    sizeof(p), dgs ? MSG_MORE : 0);
-	if (!err && dgs) {
-		dgb = mdev->tconn->int_dig_out;
-		drbd_csum_ee(mdev, mdev->tconn->integrity_w_tfm, peer_req, dgb);
-		err = drbd_send_all(mdev->tconn, mdev->tconn->data.socket, dgb,
-				    dgs, 0);
-	}
+	sock = &mdev->tconn->data;
+	p = drbd_prepare_command(mdev, sock);
+	if (!p)
+		return -EIO;
+	p->sector = cpu_to_be64(peer_req->i.sector);
+	p->block_id = peer_req->block_id;
+	p->seq_num = 0;  /* unused */
+	if (dgs)
+		drbd_csum_ee(mdev, mdev->tconn->integrity_w_tfm, peer_req, p + 1);
+	err = __send_command(mdev->tconn, mdev->vnr, sock, cmd, sizeof(*p) + dgs, NULL, peer_req->i.size);
 	if (!err)
 		err = _drbd_send_zc_ee(mdev, peer_req);
-	drbd_put_data_sock(mdev->tconn);
+	mutex_unlock(&sock->mutex);  /* locked by drbd_prepare_command() */
 
 	return err;
 }
 
 int drbd_send_out_of_sync(struct drbd_conf *mdev, struct drbd_request *req)
 {
-	struct p_block_desc p;
-
-	p.sector  = cpu_to_be64(req->i.sector);
-	p.blksize = cpu_to_be32(req->i.size);
+	struct drbd_socket *sock;
+	struct p_block_desc *p;
 
-	return drbd_send_cmd(mdev, &mdev->tconn->data, P_OUT_OF_SYNC, &p.head, sizeof(p));
+	sock = &mdev->tconn->data;
+	p = drbd_prepare_command(mdev, sock);
+	if (!p)
+		return -EIO;
+	p->sector = cpu_to_be64(req->i.sector);
+	p->blksize = cpu_to_be32(req->i.size);
+	return drbd_send_command(mdev, sock, P_OUT_OF_SYNC, sizeof(*p), NULL, 0);
 }
 
 /*
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index ceca24f..1270af3 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -729,24 +729,32 @@ out:
 	return s_estab;
 }
 
-static int drbd_send_fp(struct drbd_tconn *tconn, struct drbd_socket *sock, enum drbd_packet cmd)
-{
-	struct p_header *h = tconn->data.sbuf;
+static int decode_header(struct drbd_tconn *, struct p_header *, struct packet_info *);
 
-	return !_conn_send_cmd(tconn, 0, sock, cmd, h, sizeof(*h), 0);
+static int send_first_packet(struct drbd_tconn *tconn, struct drbd_socket *sock,
+			     enum drbd_packet cmd)
+{
+	if (!conn_prepare_command(tconn, sock))
+		return -EIO;
+	return conn_send_command(tconn, sock, cmd, sizeof(struct p_header), NULL, 0);
 }
 
-static enum drbd_packet drbd_recv_fp(struct drbd_tconn *tconn, struct socket *sock)
+static int receive_first_packet(struct drbd_tconn *tconn, struct socket *sock)
 {
-	struct p_header80 h;
-	int rr;
-
-	rr = drbd_recv_short(sock, &h, sizeof(h), 0);
-
-	if (rr == sizeof(h) && h.magic == cpu_to_be32(DRBD_MAGIC))
-		return be16_to_cpu(h.command);
+	unsigned int header_size = drbd_header_size(tconn);
+	struct packet_info pi;
+	int err;
 
-	return 0xffff;
+	err = drbd_recv_short(sock, tconn->data.rbuf, header_size, 0);
+	if (err != header_size) {
+		if (err >= 0)
+			err = -EIO;
+		return err;
+	}
+	err = decode_header(tconn, tconn->data.rbuf, &pi);
+	if (err)
+		return err;
+	return pi.cmd;
 }
 
 /**
@@ -834,10 +842,10 @@ static int drbd_connect(struct drbd_tconn *tconn)
 		if (s) {
 			if (!tconn->data.socket) {
 				tconn->data.socket = s;
-				drbd_send_fp(tconn, &tconn->data, P_INITIAL_DATA);
+				send_first_packet(tconn, &tconn->data, P_INITIAL_DATA);
 			} else if (!tconn->meta.socket) {
 				tconn->meta.socket = s;
-				drbd_send_fp(tconn, &tconn->meta, P_INITIAL_META);
+				send_first_packet(tconn, &tconn->meta, P_INITIAL_META);
 			} else {
 				conn_err(tconn, "Logic error in drbd_connect()\n");
 				goto out_release_sockets;
@@ -855,7 +863,7 @@ static int drbd_connect(struct drbd_tconn *tconn)
 retry:
 		s = drbd_wait_for_connect(tconn);
 		if (s) {
-			try = drbd_recv_fp(tconn, s);
+			try = receive_first_packet(tconn, s);
 			drbd_socket_okay(&tconn->data.socket);
 			drbd_socket_okay(&tconn->meta.socket);
 			switch (try) {
@@ -1327,6 +1335,10 @@ read_in_block(struct drbd_conf *mdev, u64 id, sector_t sector,
 		crypto_hash_digestsize(mdev->tconn->integrity_r_tfm) : 0;
 
 	if (dgs) {
+		/*
+		 * FIXME: Receive the incoming digest into the receive buffer
+		 *	  here, together with its struct p_data?
+		 */
 		err = drbd_recv_all_warn(mdev->tconn, dig_in, dgs);
 		if (err)
 			return NULL;
@@ -4182,27 +4194,17 @@ static int drbd_disconnected(int vnr, void *p, void *data)
  */
 static int drbd_send_features(struct drbd_tconn *tconn)
 {
-	/* ASSERT current == mdev->tconn->receiver ... */
-	struct p_connection_features *p = tconn->data.sbuf;
-	int err;
-
-	if (mutex_lock_interruptible(&tconn->data.mutex)) {
-		conn_err(tconn, "interrupted during initial handshake\n");
-		return -EINTR;
-	}
+	struct drbd_socket *sock;
+	struct p_connection_features *p;
 
-	if (tconn->data.socket == NULL) {
-		mutex_unlock(&tconn->data.mutex);
+	sock = &tconn->data;
+	p = conn_prepare_command(tconn, sock);
+	if (!p)
 		return -EIO;
-	}
-
 	memset(p, 0, sizeof(*p));
 	p->protocol_min = cpu_to_be32(PRO_VERSION_MIN);
 	p->protocol_max = cpu_to_be32(PRO_VERSION_MAX);
-	err = _conn_send_cmd(tconn, 0, &tconn->data, P_CONNECTION_FEATURES,
-			     &p->head, sizeof(*p), 0);
-	mutex_unlock(&tconn->data.mutex);
-	return err;
+	return conn_send_command(tconn, sock, P_CONNECTION_FEATURES, sizeof(*p), NULL, 0);
 }
 
 /*
@@ -4286,6 +4288,7 @@ static int drbd_do_auth(struct drbd_tconn *tconn)
 
 static int drbd_do_auth(struct drbd_tconn *tconn)
 {
+	struct drbd_socket *sock;
 	char my_challenge[CHALLENGE_LEN];  /* 64 Bytes... */
 	struct scatterlist sg;
 	char *response = NULL;
@@ -4297,6 +4300,8 @@ static int drbd_do_auth(struct drbd_tconn *tconn)
 	struct packet_info pi;
 	int err, rv;
 
+	/* FIXME: Put the challenge/response into the preallocated socket buffer.  */
+
 	desc.tfm = tconn->cram_hmac_tfm;
 	desc.flags = 0;
 
@@ -4310,7 +4315,14 @@ static int drbd_do_auth(struct drbd_tconn *tconn)
 
 	get_random_bytes(my_challenge, CHALLENGE_LEN);
 
-	rv = !conn_send_cmd2(tconn, P_AUTH_CHALLENGE, my_challenge, CHALLENGE_LEN);
+	sock = &tconn->data;
+	if (!conn_prepare_command(tconn, sock)) {
+		rv = 0;
+		goto fail;
+	}
+	rv = !conn_send_command(tconn, sock, P_AUTH_CHALLENGE,
+				sizeof(struct p_header),
+				my_challenge, CHALLENGE_LEN);
 	if (!rv)
 		goto fail;
 
@@ -4364,7 +4376,13 @@ static int drbd_do_auth(struct drbd_tconn *tconn)
 		goto fail;
 	}
 
-	rv = !conn_send_cmd2(tconn, P_AUTH_RESPONSE, response, resp_size);
+	if (!conn_prepare_command(tconn, sock)) {
+		rv = 0;
+		goto fail;
+	}
+	rv = !conn_send_command(tconn, sock, P_AUTH_RESPONSE,
+				sizeof(struct p_header),
+				response, resp_size);
 	if (!rv)
 		goto fail;
 
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 8059ea3..6feaa4a 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1193,10 +1193,10 @@ int w_prev_work_done(struct drbd_work *w, int cancel)
 
 int w_send_barrier(struct drbd_work *w, int cancel)
 {
+	struct drbd_socket *sock;
 	struct drbd_tl_epoch *b = container_of(w, struct drbd_tl_epoch, w);
 	struct drbd_conf *mdev = w->mdev;
-	struct p_barrier *p = mdev->tconn->data.sbuf;
-	int err = 0;
+	struct p_barrier *p;
 
 	/* really avoid racing with tl_clear.  w.cb may have been referenced
 	 * just before it was reassigned and re-queued, so double check that.
@@ -1210,26 +1210,28 @@ int w_send_barrier(struct drbd_work *w, int cancel)
 	if (cancel)
 		return 0;
 
-	err = drbd_get_data_sock(mdev->tconn);
-	if (err)
-		return err;
+	sock = &mdev->tconn->data;
+	p = drbd_prepare_command(mdev, sock);
+	if (!p)
+		return -EIO;
 	p->barrier = b->br_number;
 	/* inc_ap_pending was done where this was queued.
 	 * dec_ap_pending will be done in got_BarrierAck
 	 * or (on connection loss) in w_clear_epoch.  */
-	err = _drbd_send_cmd(mdev, &mdev->tconn->data, P_BARRIER,
-			     &p->head, sizeof(*p), 0);
-	drbd_put_data_sock(mdev->tconn);
-
-	return err;
+	return drbd_send_command(mdev, sock, P_BARRIER, sizeof(*p), NULL, 0);
 }
 
 int w_send_write_hint(struct drbd_work *w, int cancel)
 {
 	struct drbd_conf *mdev = w->mdev;
+	struct drbd_socket *sock;
+
 	if (cancel)
 		return 0;
-	return drbd_send_short_cmd(mdev, P_UNPLUG_REMOTE);
+	sock = &mdev->tconn->data;
+	if (!drbd_prepare_command(mdev, sock))
+		return -EIO;
+	return drbd_send_command(mdev, sock, P_UNPLUG_REMOTE, sizeof(struct p_header), NULL, 0);
 }
 
 int w_send_out_of_sync(struct drbd_work *w, int cancel)
-- 
1.7.4.1

