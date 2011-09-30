Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645Ab1I3Msl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 08:48:41 -0400
Received: from mail09.linbit.com ([212.69.161.110]:42770 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758610Ab1I3Msd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 08:48:33 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 09/11] drbd: rcu_read_lock() and rcu_dereference() for tconn->net_conf
Date: Fri, 30 Sep 2011 14:48:24 +0200
Message-Id: <1317386906-19260-10-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317386906-19260-1-git-send-email-philipp.reisner@linbit.com>
References: <1317386906-19260-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing the get_net_conf()/put_net_conf() calls

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |   15 ++-
 drivers/block/drbd/drbd_main.c     |   78 ++++++++----
 drivers/block/drbd/drbd_nl.c       |  171 +++++++++++++++-----------
 drivers/block/drbd/drbd_proc.c     |    9 +-
 drivers/block/drbd/drbd_receiver.c |  245 ++++++++++++++++++++++++------------
 drivers/block/drbd/drbd_req.c      |   40 ++++--
 drivers/block/drbd/drbd_state.c    |   14 ++-
 drivers/block/drbd/drbd_worker.c   |   26 +++-
 8 files changed, 389 insertions(+), 209 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index c57cedb..99da54c 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -832,7 +832,7 @@ struct drbd_tconn {			/* is a resource from the config file */
 	struct mutex cstate_mutex;	/* Protects graceful disconnects */
 
 	unsigned long flags;
-	struct net_conf *net_conf;	/* protected by get_net_conf() and put_net_conf() */
+	struct net_conf *net_conf;	/* content protected by rcu */
 	atomic_t net_cnt;		/* Users of net_conf */
 	wait_queue_head_t net_cnt_wait;
 	wait_queue_head_t ping_wait;		/* Woken upon reception of a ping, and a state change */
@@ -2059,11 +2059,14 @@ static inline void drbd_get_syncer_progress(struct drbd_conf *mdev,
  * maybe re-implement using semaphores? */
 static inline int drbd_get_max_buffers(struct drbd_conf *mdev)
 {
-	int mxb = 1000000; /* arbitrary limit on open requests */
-	if (get_net_conf(mdev->tconn)) {
-		mxb = mdev->tconn->net_conf->max_buffers;
-		put_net_conf(mdev->tconn);
-	}
+	struct net_conf *nc;
+	int mxb;
+
+	rcu_read_lock();
+	nc = rcu_dereference(mdev->tconn->net_conf);
+	mxb = nc ? nc->max_buffers : 1000000;  /* arbitrary limit on open requests */
+	rcu_read_unlock();
+
 	return mxb;
 }
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 6a11e9d..d335ecc 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -843,15 +843,19 @@ int drbd_send_sync_param(struct drbd_conf *mdev)
 	int size;
 	const int apv = mdev->tconn->agreed_pro_version;
 	enum drbd_packet cmd;
+	struct net_conf *nc;
 
 	sock = &mdev->tconn->data;
 	p = drbd_prepare_command(mdev, sock);
 	if (!p)
 		return -EIO;
 
+	rcu_read_lock();
+	nc = rcu_dereference(mdev->tconn->net_conf);
+
 	size = apv <= 87 ? sizeof(struct p_rs_param)
 		: apv == 88 ? sizeof(struct p_rs_param)
-			+ strlen(mdev->tconn->net_conf->verify_alg) + 1
+			+ strlen(nc->verify_alg) + 1
 		: apv <= 94 ? sizeof(struct p_rs_param_89)
 		: /* apv >= 95 */ sizeof(struct p_rs_param_95);
 
@@ -876,9 +880,10 @@ int drbd_send_sync_param(struct drbd_conf *mdev)
 	}
 
 	if (apv >= 88)
-		strcpy(p->verify_alg, mdev->tconn->net_conf->verify_alg);
+		strcpy(p->verify_alg, nc->verify_alg);
 	if (apv >= 89)
-		strcpy(p->csums_alg, mdev->tconn->net_conf->csums_alg);
+		strcpy(p->csums_alg, nc->csums_alg);
+	rcu_read_unlock();
 
 	return drbd_send_command(mdev, sock, cmd, size, NULL, 0);
 }
@@ -887,36 +892,44 @@ int drbd_send_protocol(struct drbd_tconn *tconn)
 {
 	struct drbd_socket *sock;
 	struct p_protocol *p;
+	struct net_conf *nc;
 	int size, cf;
 
-	if (tconn->net_conf->dry_run && tconn->agreed_pro_version < 92) {
-		conn_err(tconn, "--dry-run is not supported by peer");
-		return -EOPNOTSUPP;
-	}
-
 	sock = &tconn->data;
 	p = conn_prepare_command(tconn, sock);
 	if (!p)
 		return -EIO;
 
+	rcu_read_lock();
+	nc = rcu_dereference(tconn->net_conf);
+
+	if (nc->dry_run && tconn->agreed_pro_version < 92) {
+		rcu_read_unlock();
+		mutex_unlock(&sock->mutex);
+		conn_err(tconn, "--dry-run is not supported by peer");
+		return -EOPNOTSUPP;
+	}
+
 	size = sizeof(*p);
 	if (tconn->agreed_pro_version >= 87)
-		size += strlen(tconn->net_conf->integrity_alg) + 1;
+		size += strlen(nc->integrity_alg) + 1;
 
-	p->protocol      = cpu_to_be32(tconn->net_conf->wire_protocol);
-	p->after_sb_0p   = cpu_to_be32(tconn->net_conf->after_sb_0p);
-	p->after_sb_1p   = cpu_to_be32(tconn->net_conf->after_sb_1p);
-	p->after_sb_2p   = cpu_to_be32(tconn->net_conf->after_sb_2p);
-	p->two_primaries = cpu_to_be32(tconn->net_conf->two_primaries);
+	p->protocol      = cpu_to_be32(nc->wire_protocol);
+	p->after_sb_0p   = cpu_to_be32(nc->after_sb_0p);
+	p->after_sb_1p   = cpu_to_be32(nc->after_sb_1p);
+	p->after_sb_2p   = cpu_to_be32(nc->after_sb_2p);
+	p->two_primaries = cpu_to_be32(nc->two_primaries);
 	cf = 0;
-	if (tconn->net_conf->want_lose)
+	if (nc->want_lose)
 		cf |= CF_WANT_LOSE;
-	if (tconn->net_conf->dry_run)
+	if (nc->dry_run)
 		cf |= CF_DRY_RUN;
 	p->conn_flags    = cpu_to_be32(cf);
 
 	if (tconn->agreed_pro_version >= 87)
-		strcpy(p->integrity_alg, tconn->net_conf->integrity_alg);
+		strcpy(p->integrity_alg, nc->integrity_alg);
+	rcu_read_unlock();
+
 	return conn_send_command(tconn, sock, P_PROTOCOL, size, NULL, 0);
 }
 
@@ -938,7 +951,9 @@ int _drbd_send_uuids(struct drbd_conf *mdev, u64 uuid_flags)
 
 	mdev->comm_bm_set = drbd_bm_total_weight(mdev);
 	p->uuid[UI_SIZE] = cpu_to_be64(mdev->comm_bm_set);
-	uuid_flags |= mdev->tconn->net_conf->want_lose ? 1 : 0;
+	rcu_read_lock();
+	uuid_flags |= rcu_dereference(mdev->tconn->net_conf)->want_lose ? 1 : 0;
+	rcu_read_unlock();
 	uuid_flags |= test_bit(CRASHED_PRIMARY, &mdev->flags) ? 2 : 0;
 	uuid_flags |= mdev->new_state_tmp.disk == D_INCONSISTENT ? 4 : 0;
 	p->uuid[UI_FLAGS] = cpu_to_be64(uuid_flags);
@@ -1134,12 +1149,14 @@ int fill_bitmap_rle_bits(struct drbd_conf *mdev,
 	unsigned long rl;
 	unsigned len;
 	unsigned toggle;
-	int bits;
+	int bits, use_rle;
 
 	/* may we use this feature? */
-	if ((mdev->tconn->net_conf->use_rle == 0) ||
-		(mdev->tconn->agreed_pro_version < 90))
-			return 0;
+	rcu_read_lock();
+	use_rle = rcu_dereference(mdev->tconn->net_conf)->use_rle;
+	rcu_read_unlock();
+	if (!use_rle || mdev->tconn->agreed_pro_version < 90)
+		return 0;
 
 	if (c->bit_offset >= c->bm_bits)
 		return 0; /* nothing to do. */
@@ -1803,7 +1820,9 @@ int drbd_send(struct drbd_tconn *tconn, struct socket *sock,
 	msg.msg_flags      = msg_flags | MSG_NOSIGNAL;
 
 	if (sock == tconn->data.socket) {
-		tconn->ko_count = tconn->net_conf->ko_count;
+		rcu_read_lock();
+		tconn->ko_count = rcu_dereference(tconn->net_conf)->ko_count;
+		rcu_read_unlock();
 		drbd_update_congested(tconn);
 	}
 	do {
@@ -3226,15 +3245,18 @@ const char *cmdname(enum drbd_packet cmd)
  */
 int drbd_wait_misc(struct drbd_conf *mdev, struct drbd_interval *i)
 {
-	struct net_conf *net_conf = mdev->tconn->net_conf;
+	struct net_conf *nc;
 	DEFINE_WAIT(wait);
 	long timeout;
 
-	if (!net_conf)
+	rcu_read_lock();
+	nc = rcu_dereference(mdev->tconn->net_conf);
+	if (!nc) {
+		rcu_read_unlock();
 		return -ETIMEDOUT;
-	timeout = MAX_SCHEDULE_TIMEOUT;
-	if (net_conf->ko_count)
-		timeout = net_conf->timeout * HZ / 10 * net_conf->ko_count;
+	}
+	timeout = nc->ko_count ? nc->timeout * HZ / 10 * nc->ko_count : MAX_SCHEDULE_TIMEOUT;
+	rcu_read_unlock();
 
 	/* Indicate to wake up mdev->misc_wait on progress.  */
 	i->waiting = true;
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index bb41af1..6d28e7c 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -290,29 +290,32 @@ static int drbd_adm_finish(struct genl_info *info, int retcode)
 static void setup_khelper_env(struct drbd_tconn *tconn, char **envp)
 {
 	char af[20], ad[60], *afs;
+	struct net_conf *nc;
 
-	if (get_net_conf(tconn)) {
-		switch (((struct sockaddr *)tconn->net_conf->peer_addr)->sa_family) {
+	rcu_read_lock();
+	nc = rcu_dereference(tconn->net_conf);
+	if (nc) {
+		switch (((struct sockaddr *)nc->peer_addr)->sa_family) {
 		case AF_INET6:
 			afs = "ipv6";
 			snprintf(ad, 60, "DRBD_PEER_ADDRESS=%pI6",
-				 &((struct sockaddr_in6 *)tconn->net_conf->peer_addr)->sin6_addr);
+				 &((struct sockaddr_in6 *)nc->peer_addr)->sin6_addr);
 			break;
 		case AF_INET:
 			afs = "ipv4";
 			snprintf(ad, 60, "DRBD_PEER_ADDRESS=%pI4",
-				 &((struct sockaddr_in *)tconn->net_conf->peer_addr)->sin_addr);
+				 &((struct sockaddr_in *)nc->peer_addr)->sin_addr);
 			break;
 		default:
 			afs = "ssocks";
 			snprintf(ad, 60, "DRBD_PEER_ADDRESS=%pI4",
-				 &((struct sockaddr_in *)tconn->net_conf->peer_addr)->sin_addr);
+				 &((struct sockaddr_in *)nc->peer_addr)->sin_addr);
 		}
 		snprintf(af, 20, "DRBD_PEER_AF=%s", afs);
 		envp[3]=af;
 		envp[4]=ad;
-		put_net_conf(tconn);
 	}
+	rcu_read_unlock();
 }
 
 int drbd_khelper(struct drbd_conf *mdev, char *cmd)
@@ -519,6 +522,7 @@ drbd_set_role(struct drbd_conf *mdev, enum drbd_role new_role, int force)
 {
 	const int max_tries = 4;
 	enum drbd_state_rv rv = SS_UNKNOWN_ERROR;
+	struct net_conf *nc;
 	int try = 0;
 	int forced = 0;
 	union drbd_state mask, val;
@@ -576,7 +580,12 @@ drbd_set_role(struct drbd_conf *mdev, enum drbd_role new_role, int force)
 		if (rv == SS_TWO_PRIMARIES) {
 			/* Maybe the peer is detected as dead very soon...
 			   retry at most once more in this case. */
-			schedule_timeout_interruptible((mdev->tconn->net_conf->ping_timeo+1)*HZ/10);
+			int timeo;
+			rcu_read_lock();
+			nc = rcu_dereference(mdev->tconn->net_conf);
+			timeo = nc ? (nc->ping_timeo + 1) * HZ / 10 : 1;
+			rcu_read_unlock();
+			schedule_timeout_interruptible(timeo);
 			if (try < max_tries)
 				try = max_tries - 1;
 			continue;
@@ -606,10 +615,11 @@ drbd_set_role(struct drbd_conf *mdev, enum drbd_role new_role, int force)
 			put_ldev(mdev);
 		}
 	} else {
-		if (get_net_conf(mdev->tconn)) {
-			mdev->tconn->net_conf->want_lose = 0;
-			put_net_conf(mdev->tconn);
-		}
+		rcu_read_lock();
+		nc = rcu_dereference(mdev->tconn->net_conf);
+		if (nc)
+			nc->want_lose = 0;
+		rcu_read_unlock();
 		set_disk_ro(mdev->vdisk, false);
 		if (get_ldev(mdev)) {
 			if (((mdev->state.conn < C_CONNECTED ||
@@ -1233,6 +1243,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	struct lru_cache *resync_lru = NULL;
 	union drbd_state ns, os;
 	enum drbd_state_rv rv;
+	struct net_conf *nc;
 	int cp_discovered = 0;
 
 	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
@@ -1296,14 +1307,16 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
-	if (get_net_conf(mdev->tconn)) {
-		int prot = mdev->tconn->net_conf->wire_protocol;
-		put_net_conf(mdev->tconn);
-		if (nbc->dc.fencing == FP_STONITH && prot == DRBD_PROT_A) {
+	rcu_read_lock();
+	nc = rcu_dereference(mdev->tconn->net_conf);
+	if (nc) {
+		if (nbc->dc.fencing == FP_STONITH && nc->wire_protocol == DRBD_PROT_A) {
+			rcu_read_unlock();
 			retcode = ERR_STONITH_AND_PROT_A;
 			goto fail;
 		}
 	}
+	rcu_read_unlock();
 
 	bdev = blkdev_get_by_path(nbc->dc.backing_dev,
 				  FMODE_READ | FMODE_WRITE | FMODE_EXCL, mdev);
@@ -1706,42 +1719,35 @@ static bool conn_ov_running(struct drbd_tconn *tconn)
 }
 
 static enum drbd_ret_code
-check_net_options(struct drbd_tconn *tconn, struct net_conf *new_conf)
+_check_net_options(struct drbd_tconn *tconn, struct net_conf *old_conf, struct net_conf *new_conf)
 {
 	struct drbd_conf *mdev;
 	int i;
 
-	if (tconn->net_conf && tconn->agreed_pro_version < 100 &&
+	if (old_conf && tconn->agreed_pro_version < 100 &&
 	    tconn->cstate == C_WF_REPORT_PARAMS &&
-	    new_conf->wire_protocol != tconn->net_conf->wire_protocol)
+	    new_conf->wire_protocol != old_conf->wire_protocol)
 		return ERR_NEED_APV_100;
 
 	if (new_conf->two_primaries &&
 	    (new_conf->wire_protocol != DRBD_PROT_C))
 		return ERR_NOT_PROTO_C;
 
-	rcu_read_lock();
 	idr_for_each_entry(&tconn->volumes, mdev, i) {
 		if (get_ldev(mdev)) {
 			enum drbd_fencing_p fp = mdev->ldev->dc.fencing;
 			put_ldev(mdev);
-			if (new_conf->wire_protocol == DRBD_PROT_A && fp == FP_STONITH) {
-				rcu_read_unlock();
+			if (new_conf->wire_protocol == DRBD_PROT_A && fp == FP_STONITH)
 				return ERR_STONITH_AND_PROT_A;
-			}
 		}
-		if (mdev->state.role == R_PRIMARY && new_conf->want_lose) {
-			rcu_read_unlock();
+		if (mdev->state.role == R_PRIMARY && new_conf->want_lose)
 			return ERR_DISCARD;
-		}
+
 		if (!mdev->bitmap) {
-			if(drbd_bm_init(mdev)) {
-				rcu_read_unlock();
+			if(drbd_bm_init(mdev))
 				return ERR_NOMEM;
-			}
 		}
 	}
-	rcu_read_unlock();
 
 	if (new_conf->on_congestion != OC_BLOCK && new_conf->wire_protocol != DRBD_PROT_A)
 		return ERR_CONG_NOT_PROTO_A;
@@ -1749,11 +1755,23 @@ check_net_options(struct drbd_tconn *tconn, struct net_conf *new_conf)
 	return NO_ERROR;
 }
 
+static enum drbd_ret_code
+check_net_options(struct drbd_tconn *tconn, struct net_conf *new_conf)
+{
+	static enum drbd_ret_code rv;
+
+	rcu_read_lock();
+	rv = _check_net_options(tconn, rcu_dereference(tconn->net_conf), new_conf);
+	rcu_read_unlock();
+
+	return rv;
+}
+
 int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 {
 	enum drbd_ret_code retcode;
 	struct drbd_tconn *tconn;
-	struct net_conf *new_conf = NULL;
+	struct net_conf *old_conf, *new_conf = NULL;
 	int err;
 	int ovr; /* online verify running */
 	int rsr; /* re-sync running */
@@ -1789,17 +1807,20 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 		goto out;
 	}
 
-	/* we also need a net config
-	 * to change the options on */
-	if (!get_net_conf(tconn)) {
+	conn_reconfig_start(tconn);
+
+	rcu_read_lock();
+	old_conf = rcu_dereference(tconn->net_conf);
+
+	if (!old_conf) {
 		drbd_msg_put_info("net conf missing, try connect");
 		retcode = ERR_INVALID_REQUEST;
-		goto out;
+		goto fail_rcu_unlock;
 	}
 
-	conn_reconfig_start(tconn);
+	*new_conf = *old_conf;
+	rcu_read_unlock();
 
-	memcpy(new_conf, tconn->net_conf, sizeof(*new_conf));
 	err = net_conf_from_attrs(new_conf, info);
 	if (err) {
 		retcode = ERR_MANDATORY_TAG;
@@ -1813,10 +1834,13 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 
 	/* re-sync running */
 	rsr = conn_resync_running(tconn);
-	if (rsr && strcmp(new_conf->csums_alg, tconn->net_conf->csums_alg)) {
+	rcu_read_lock();
+	old_conf = rcu_dereference(tconn->net_conf);
+	if (rsr && old_conf && strcmp(new_conf->csums_alg, old_conf->csums_alg)) {
 		retcode = ERR_CSUMS_RESYNC_RUNNING;
-		goto fail;
+		goto fail_rcu_unlock;
 	}
+	rcu_read_unlock();
 
 	if (!rsr && new_conf->csums_alg[0]) {
 		csums_tfm = crypto_alloc_hash(new_conf->csums_alg, 0, CRYPTO_ALG_ASYNC);
@@ -1834,12 +1858,15 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 
 	/* online verify running */
 	ovr = conn_ov_running(tconn);
-	if (ovr) {
-		if (strcmp(new_conf->verify_alg, tconn->net_conf->verify_alg)) {
+	rcu_read_lock();
+	old_conf = rcu_dereference(tconn->net_conf);
+	if (ovr && old_conf) {
+		if (strcmp(new_conf->verify_alg, old_conf->verify_alg)) {
 			retcode = ERR_VERIFY_RUNNING;
-			goto fail;
+			goto fail_rcu_unlock;
 		}
 	}
+	rcu_read_unlock();
 
 	if (!ovr && new_conf->verify_alg[0]) {
 		verify_tfm = crypto_alloc_hash(new_conf->verify_alg, 0, CRYPTO_ALG_ASYNC);
@@ -1855,16 +1882,9 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-
-	/* For now, use struct assignment, not pointer assignment.
-	 * We don't have any means to determine who might still
-	 * keep a local alias into the struct,
-	 * so we cannot just free it and hope for the best :(
-	 * FIXME
-	 * To avoid someone looking at a half-updated struct, we probably
-	 * should have a rw-semaphor on net_conf and disk_conf.
-	 */
-	*tconn->net_conf = *new_conf;
+	rcu_assign_pointer(tconn->net_conf, new_conf);
+	synchronize_rcu();
+	kfree(old_conf);
 
 	if (!rsr) {
 		crypto_free_hash(tconn->csums_tfm);
@@ -1880,11 +1900,12 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 	if (tconn->cstate >= C_WF_REPORT_PARAMS)
 		drbd_send_sync_param(minor_to_mdev(conn_lowest_minor(tconn)));
 
+ fail_rcu_unlock:
+	rcu_read_unlock();
  fail:
 	crypto_free_hash(csums_tfm);
 	crypto_free_hash(verify_tfm);
 	kfree(new_conf);
-	put_net_conf(tconn);
 	conn_reconfig_done(tconn);
  out:
 	drbd_adm_finish(info, retcode);
@@ -1895,7 +1916,7 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 {
 	char hmac_name[CRYPTO_MAX_ALG_NAME];
 	struct drbd_conf *mdev;
-	struct net_conf *new_conf = NULL;
+	struct net_conf *old_conf, *new_conf = NULL;
 	struct crypto_hash *tfm = NULL;
 	struct crypto_hash *integrity_w_tfm = NULL;
 	struct crypto_hash *integrity_r_tfm = NULL;
@@ -1983,23 +2004,26 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	 * strictly serialized on genl_lock(). We are protected against
 	 * concurrent reconfiguration/addition/deletion */
 	list_for_each_entry(oconn, &drbd_tconns, all_tconn) {
+		struct net_conf *nc;
 		if (oconn == tconn)
 			continue;
-		if (get_net_conf(oconn)) {
-			taken_addr = (struct sockaddr *)&oconn->net_conf->my_addr;
-			if (new_conf->my_addr_len == oconn->net_conf->my_addr_len &&
+
+		rcu_read_lock();
+		nc = rcu_dereference(oconn->net_conf);
+		if (nc) {
+			taken_addr = (struct sockaddr *)&nc->my_addr;
+			if (new_conf->my_addr_len == nc->my_addr_len &&
 			    !memcmp(new_my_addr, taken_addr, new_conf->my_addr_len))
 				retcode = ERR_LOCAL_ADDR;
 
-			taken_addr = (struct sockaddr *)&oconn->net_conf->peer_addr;
-			if (new_conf->peer_addr_len == oconn->net_conf->peer_addr_len &&
+			taken_addr = (struct sockaddr *)&nc->peer_addr;
+			if (new_conf->peer_addr_len == nc->peer_addr_len &&
 			    !memcmp(new_peer_addr, taken_addr, new_conf->peer_addr_len))
 				retcode = ERR_PEER_ADDR;
-
-			put_net_conf(oconn);
-			if (retcode != NO_ERROR)
-				goto fail;
 		}
+		rcu_read_unlock();
+		if (retcode != NO_ERROR)
+			goto fail;
 	}
 
 	if (new_conf->cram_hmac_alg[0] != 0) {
@@ -2058,12 +2082,15 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 
 	conn_flush_workqueue(tconn);
 	spin_lock_irq(&tconn->req_lock);
-	if (tconn->net_conf != NULL) {
+	rcu_read_lock();
+	old_conf = rcu_dereference(tconn->net_conf);
+	if (old_conf != NULL) {
 		retcode = ERR_NET_CONFIGURED;
+		rcu_read_unlock();
 		spin_unlock_irq(&tconn->req_lock);
 		goto fail;
 	}
-	tconn->net_conf = new_conf;
+	rcu_assign_pointer(tconn->net_conf, new_conf);
 
 	crypto_free_hash(tconn->cram_hmac_tfm);
 	tconn->cram_hmac_tfm = tfm;
@@ -2518,9 +2545,9 @@ int nla_put_status_info(struct sk_buff *skb, struct drbd_conf *mdev,
 		const struct sib_info *sib)
 {
 	struct state_info *si = NULL; /* for sizeof(si->member); */
+	struct net_conf *nc;
 	struct nlattr *nla;
 	int got_ldev;
-	int got_net;
 	int err = 0;
 	int exclude_sensitive;
 
@@ -2538,7 +2565,6 @@ int nla_put_status_info(struct sk_buff *skb, struct drbd_conf *mdev,
 	exclude_sensitive = sib || !capable(CAP_SYS_ADMIN);
 
 	got_ldev = get_ldev(mdev);
-	got_net = get_net_conf(mdev->tconn);
 
 	/* We need to add connection name and volume number information still.
 	 * Minor number is in drbd_genlmsghdr. */
@@ -2551,9 +2577,14 @@ int nla_put_status_info(struct sk_buff *skb, struct drbd_conf *mdev,
 	if (got_ldev)
 		if (disk_conf_to_skb(skb, &mdev->ldev->dc, exclude_sensitive))
 			goto nla_put_failure;
-	if (got_net)
-		if (net_conf_to_skb(skb, mdev->tconn->net_conf, exclude_sensitive))
-			goto nla_put_failure;
+
+	rcu_read_lock();
+	nc = rcu_dereference(mdev->tconn->net_conf);
+	if (nc)
+		err = net_conf_to_skb(skb, nc, exclude_sensitive);
+	rcu_read_unlock();
+	if (err)
+		goto nla_put_failure;
 
 	nla = nla_nest_start(skb, DRBD_NLA_STATE_INFO);
 	if (!nla)
@@ -2600,8 +2631,6 @@ nla_put_failure:
 		err = -EMSGSIZE;
 	if (got_ldev)
 		put_ldev(mdev);
-	if (got_net)
-		put_net_conf(mdev->tconn);
 	return err;
 }
 
diff --git a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
index 4025d08..792a71e 100644
--- a/drivers/block/drbd/drbd_proc.c
+++ b/drivers/block/drbd/drbd_proc.c
@@ -197,6 +197,8 @@ static int drbd_seq_show(struct seq_file *seq, void *v)
 	int i, prev_i = -1;
 	const char *sn;
 	struct drbd_conf *mdev;
+	struct net_conf *nc;
+	char wp;
 
 	static char write_ordering_chars[] = {
 		[WO_none] = 'n',
@@ -240,6 +242,10 @@ static int drbd_seq_show(struct seq_file *seq, void *v)
 		    mdev->state.role == R_SECONDARY) {
 			seq_printf(seq, "%2d: cs:Unconfigured\n", i);
 		} else {
+			rcu_read_lock();
+			nc = rcu_dereference(mdev->tconn->net_conf);
+			wp = nc ? nc->wire_protocol - DRBD_PROT_A + 'A' : ' ';
+			rcu_read_unlock();
 			seq_printf(seq,
 			   "%2d: cs:%s ro:%s/%s ds:%s/%s %c %c%c%c%c%c%c\n"
 			   "    ns:%u nr:%u dw:%u dr:%u al:%u bm:%u "
@@ -249,8 +255,7 @@ static int drbd_seq_show(struct seq_file *seq, void *v)
 			   drbd_role_str(mdev->state.peer),
 			   drbd_disk_str(mdev->state.disk),
 			   drbd_disk_str(mdev->state.pdsk),
-			   (mdev->tconn->net_conf == NULL ? ' ' :
-			    (mdev->tconn->net_conf->wire_protocol - DRBD_PROT_A+'A')),
+			   wp,
 			   drbd_suspended(mdev) ? 's' : 'r',
 			   mdev->state.aftr_isp ? 'a' : '-',
 			   mdev->state.peer_isp ? 'p' : '-',
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 0b648dc..a37f2ee 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -244,11 +244,18 @@ struct page *drbd_alloc_pages(struct drbd_conf *mdev, unsigned int number,
 			      bool retry)
 {
 	struct page *page = NULL;
+	struct net_conf *nc;
 	DEFINE_WAIT(wait);
+	int mxb;
 
 	/* Yes, we may run up to @number over max_buffers. If we
 	 * follow it strictly, the admin will get it wrong anyways. */
-	if (atomic_read(&mdev->pp_in_use) < mdev->tconn->net_conf->max_buffers)
+	rcu_read_lock();
+	nc = rcu_dereference(mdev->tconn->net_conf);
+	mxb = nc ? nc->max_buffers : 1000000;
+	rcu_read_unlock();
+
+	if (atomic_read(&mdev->pp_in_use) < mxb)
 		page = __drbd_alloc_pages(mdev, number);
 
 	while (page == NULL) {
@@ -256,7 +263,7 @@ struct page *drbd_alloc_pages(struct drbd_conf *mdev, unsigned int number,
 
 		drbd_kick_lo_and_reclaim_net(mdev);
 
-		if (atomic_read(&mdev->pp_in_use) < mdev->tconn->net_conf->max_buffers) {
+		if (atomic_read(&mdev->pp_in_use) < mxb) {
 			page = __drbd_alloc_pages(mdev, number);
 			if (page)
 				break;
@@ -607,24 +614,47 @@ static struct socket *drbd_try_connect(struct drbd_tconn *tconn)
 	const char *what;
 	struct socket *sock;
 	struct sockaddr_in6 src_in6;
-	int err;
+	struct sockaddr_in6 peer_in6;
+	struct net_conf *nc;
+	int err, peer_addr_len, my_addr_len;
+	int sndbuf_size, rcvbuf_size, try_connect_int;
 	int disconnect_on_error = 1;
 
-	if (!get_net_conf(tconn))
+	rcu_read_lock();
+	nc = rcu_dereference(tconn->net_conf);
+	if (!nc) {
+		rcu_read_unlock();
 		return NULL;
+	}
+
+	sndbuf_size = nc->sndbuf_size;
+	rcvbuf_size = nc->rcvbuf_size;
+	try_connect_int = nc->try_connect_int;
+
+	my_addr_len = min_t(int, nc->my_addr_len, sizeof(src_in6));
+	memcpy(&src_in6, nc->my_addr, my_addr_len);
+
+	if (((struct sockaddr *)nc->my_addr)->sa_family == AF_INET6)
+		src_in6.sin6_port = 0;
+	else
+		((struct sockaddr_in *)&src_in6)->sin_port = 0; /* AF_INET & AF_SCI */
+
+	peer_addr_len = min_t(int, nc->peer_addr_len, sizeof(src_in6));
+	memcpy(&peer_in6, nc->peer_addr, peer_addr_len);
+
+	rcu_read_unlock();
 
 	what = "sock_create_kern";
-	err = sock_create_kern(((struct sockaddr *)tconn->net_conf->my_addr)->sa_family,
-		SOCK_STREAM, IPPROTO_TCP, &sock);
+	err = sock_create_kern(((struct sockaddr *)&src_in6)->sa_family,
+			       SOCK_STREAM, IPPROTO_TCP, &sock);
 	if (err < 0) {
 		sock = NULL;
 		goto out;
 	}
 
 	sock->sk->sk_rcvtimeo =
-	sock->sk->sk_sndtimeo =  tconn->net_conf->try_connect_int*HZ;
-	drbd_setbufsize(sock, tconn->net_conf->sndbuf_size,
-			tconn->net_conf->rcvbuf_size);
+	sock->sk->sk_sndtimeo = try_connect_int * HZ;
+	drbd_setbufsize(sock, sndbuf_size, rcvbuf_size);
 
        /* explicitly bind to the configured IP as source IP
 	*  for the outgoing connections.
@@ -633,17 +663,8 @@ static struct socket *drbd_try_connect(struct drbd_tconn *tconn)
 	* Make sure to use 0 as port number, so linux selects
 	*  a free one dynamically.
 	*/
-	memcpy(&src_in6, tconn->net_conf->my_addr,
-	       min_t(int, tconn->net_conf->my_addr_len, sizeof(src_in6)));
-	if (((struct sockaddr *)tconn->net_conf->my_addr)->sa_family == AF_INET6)
-		src_in6.sin6_port = 0;
-	else
-		((struct sockaddr_in *)&src_in6)->sin_port = 0; /* AF_INET & AF_SCI */
-
 	what = "bind before connect";
-	err = sock->ops->bind(sock,
-			      (struct sockaddr *) &src_in6,
-			      tconn->net_conf->my_addr_len);
+	err = sock->ops->bind(sock, (struct sockaddr *) &src_in6, my_addr_len);
 	if (err < 0)
 		goto out;
 
@@ -651,9 +672,7 @@ static struct socket *drbd_try_connect(struct drbd_tconn *tconn)
 	 * stay C_WF_CONNECTION, don't go Disconnecting! */
 	disconnect_on_error = 0;
 	what = "connect";
-	err = sock->ops->connect(sock,
-				 (struct sockaddr *)tconn->net_conf->peer_addr,
-				 tconn->net_conf->peer_addr_len, 0);
+	err = sock->ops->connect(sock, (struct sockaddr *) &peer_in6, peer_addr_len, 0);
 
 out:
 	if (err < 0) {
@@ -676,40 +695,52 @@ out:
 		if (disconnect_on_error)
 			conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_HARD);
 	}
-	put_net_conf(tconn);
+
 	return sock;
 }
 
 static struct socket *drbd_wait_for_connect(struct drbd_tconn *tconn)
 {
-	int timeo, err;
+	int timeo, err, my_addr_len;
+	int sndbuf_size, rcvbuf_size, try_connect_int;
 	struct socket *s_estab = NULL, *s_listen;
+	struct sockaddr_in6 my_addr;
+	struct net_conf *nc;
 	const char *what;
 
-	if (!get_net_conf(tconn))
+	rcu_read_lock();
+	nc = rcu_dereference(tconn->net_conf);
+	if (!nc) {
+		rcu_read_unlock();
 		return NULL;
+	}
+
+	sndbuf_size = nc->sndbuf_size;
+	rcvbuf_size = nc->rcvbuf_size;
+	try_connect_int = nc->try_connect_int;
+
+	my_addr_len = min_t(int, nc->my_addr_len, sizeof(struct sockaddr_in6));
+	memcpy(&my_addr, nc->my_addr, my_addr_len);
+	rcu_read_unlock();
 
 	what = "sock_create_kern";
-	err = sock_create_kern(((struct sockaddr *)tconn->net_conf->my_addr)->sa_family,
+	err = sock_create_kern(((struct sockaddr *)&my_addr)->sa_family,
 		SOCK_STREAM, IPPROTO_TCP, &s_listen);
 	if (err) {
 		s_listen = NULL;
 		goto out;
 	}
 
-	timeo = tconn->net_conf->try_connect_int * HZ;
+	timeo = try_connect_int * HZ;
 	timeo += (random32() & 1) ? timeo / 7 : -timeo / 7; /* 28.5% random jitter */
 
 	s_listen->sk->sk_reuse    = 1; /* SO_REUSEADDR */
 	s_listen->sk->sk_rcvtimeo = timeo;
 	s_listen->sk->sk_sndtimeo = timeo;
-	drbd_setbufsize(s_listen, tconn->net_conf->sndbuf_size,
-			tconn->net_conf->rcvbuf_size);
+	drbd_setbufsize(s_listen, sndbuf_size, rcvbuf_size);
 
 	what = "bind before listen";
-	err = s_listen->ops->bind(s_listen,
-			      (struct sockaddr *) tconn->net_conf->my_addr,
-			      tconn->net_conf->my_addr_len);
+	err = s_listen->ops->bind(s_listen, (struct sockaddr *)&my_addr, my_addr_len);
 	if (err < 0)
 		goto out;
 
@@ -724,7 +755,6 @@ out:
 			conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_HARD);
 		}
 	}
-	put_net_conf(tconn);
 
 	return s_estab;
 }
@@ -817,7 +847,8 @@ int drbd_connected(int vnr, void *p, void *data)
 static int drbd_connect(struct drbd_tconn *tconn)
 {
 	struct socket *sock, *msock;
-	int try, h, ok;
+	struct net_conf *nc;
+	int timeout, try, h, ok;
 
 	if (conn_request_state(tconn, NS(conn, C_WF_CONNECTION), CS_VERBOSE) < SS_SUCCESS)
 		return -2;
@@ -924,11 +955,17 @@ retry:
 	 * sock->sk->sk_rcvtimeo = MAX_SCHEDULE_TIMEOUT;
 	 * first set it to the P_CONNECTION_FEATURES timeout,
 	 * which we set to 4x the configured ping_timeout. */
+	rcu_read_lock();
+	nc = rcu_dereference(tconn->net_conf);
+
 	sock->sk->sk_sndtimeo =
-	sock->sk->sk_rcvtimeo = tconn->net_conf->ping_timeo*4*HZ/10;
+	sock->sk->sk_rcvtimeo = nc->ping_timeo*4*HZ/10;
+
+	msock->sk->sk_rcvtimeo = nc->ping_int*HZ;
+	timeout = nc->timeout * HZ / 10;
+	rcu_read_unlock();
 
-	msock->sk->sk_sndtimeo = tconn->net_conf->timeout*HZ/10;
-	msock->sk->sk_rcvtimeo = tconn->net_conf->ping_int*HZ;
+	msock->sk->sk_sndtimeo = timeout;
 
 	/* we don't want delays.
 	 * we use TCP_CORK where appropriate, though */
@@ -956,7 +993,7 @@ retry:
 	if (conn_request_state(tconn, NS(conn, C_WF_REPORT_PARAMS), CS_VERBOSE) < SS_SUCCESS)
 		return 0;
 
-	sock->sk->sk_sndtimeo = tconn->net_conf->timeout*HZ/10;
+	sock->sk->sk_sndtimeo = timeout;
 	sock->sk->sk_rcvtimeo = MAX_SCHEDULE_TIMEOUT;
 
 	drbd_thread_start(&tconn->asender);
@@ -1842,7 +1879,9 @@ static int wait_for_and_update_peer_seq(struct drbd_conf *mdev, const u32 peer_s
 		}
 		prepare_to_wait(&mdev->seq_wait, &wait, TASK_INTERRUPTIBLE);
 		spin_unlock(&mdev->peer_seq_lock);
-		timeout = mdev->tconn->net_conf->ping_timeo*HZ/10;
+		rcu_read_lock();
+		timeout = rcu_dereference(mdev->tconn->net_conf)->ping_timeo*HZ/10;
+		rcu_read_unlock();
 		timeout = schedule_timeout(timeout);
 		spin_lock(&mdev->peer_seq_lock);
 		if (!timeout) {
@@ -2075,7 +2114,8 @@ static int receive_Data(struct drbd_tconn *tconn, struct packet_info *pi)
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	if (mdev->tconn->agreed_pro_version < 100) {
-		switch (mdev->tconn->net_conf->wire_protocol) {
+		rcu_read_lock();
+		switch (rcu_dereference(mdev->tconn->net_conf)->wire_protocol) {
 		case DRBD_PROT_C:
 			dp_flags |= DP_SEND_WRITE_ACK;
 			break;
@@ -2083,6 +2123,7 @@ static int receive_Data(struct drbd_tconn *tconn, struct packet_info *pi)
 			dp_flags |= DP_SEND_RECEIVE_ACK;
 			break;
 		}
+		rcu_read_unlock();
 	}
 
 	if (dp_flags & DP_SEND_WRITE_ACK) {
@@ -2385,6 +2426,7 @@ static int drbd_asb_recover_0p(struct drbd_conf *mdev) __must_hold(local)
 {
 	int self, peer, rv = -100;
 	unsigned long ch_self, ch_peer;
+	enum drbd_after_sb_p after_sb_0p;
 
 	self = mdev->ldev->md.uuid[UI_BITMAP] & 1;
 	peer = mdev->p_uuid[UI_BITMAP] & 1;
@@ -2392,10 +2434,14 @@ static int drbd_asb_recover_0p(struct drbd_conf *mdev) __must_hold(local)
 	ch_peer = mdev->p_uuid[UI_SIZE];
 	ch_self = mdev->comm_bm_set;
 
-	switch (mdev->tconn->net_conf->after_sb_0p) {
+	rcu_read_lock();
+	after_sb_0p = rcu_dereference(mdev->tconn->net_conf)->after_sb_0p;
+	rcu_read_unlock();
+	switch (after_sb_0p) {
 	case ASB_CONSENSUS:
 	case ASB_DISCARD_SECONDARY:
 	case ASB_CALL_HELPER:
+	case ASB_VIOLENTLY:
 		dev_err(DEV, "Configuration error.\n");
 		break;
 	case ASB_DISCONNECT:
@@ -2431,7 +2477,7 @@ static int drbd_asb_recover_0p(struct drbd_conf *mdev) __must_hold(local)
 			if (ch_peer == 0) { rv =  1; break; }
 			if (ch_self == 0) { rv = -1; break; }
 		}
-		if (mdev->tconn->net_conf->after_sb_0p == ASB_DISCARD_ZERO_CHG)
+		if (after_sb_0p == ASB_DISCARD_ZERO_CHG)
 			break;
 	case ASB_DISCARD_LEAST_CHG:
 		if	(ch_self < ch_peer)
@@ -2456,13 +2502,18 @@ static int drbd_asb_recover_0p(struct drbd_conf *mdev) __must_hold(local)
 static int drbd_asb_recover_1p(struct drbd_conf *mdev) __must_hold(local)
 {
 	int hg, rv = -100;
+	enum drbd_after_sb_p after_sb_1p;
 
-	switch (mdev->tconn->net_conf->after_sb_1p) {
+	rcu_read_lock();
+	after_sb_1p = rcu_dereference(mdev->tconn->net_conf)->after_sb_1p;
+	rcu_read_unlock();
+	switch (after_sb_1p) {
 	case ASB_DISCARD_YOUNGER_PRI:
 	case ASB_DISCARD_OLDER_PRI:
 	case ASB_DISCARD_LEAST_CHG:
 	case ASB_DISCARD_LOCAL:
 	case ASB_DISCARD_REMOTE:
+	case ASB_DISCARD_ZERO_CHG:
 		dev_err(DEV, "Configuration error.\n");
 		break;
 	case ASB_DISCONNECT:
@@ -2505,8 +2556,12 @@ static int drbd_asb_recover_1p(struct drbd_conf *mdev) __must_hold(local)
 static int drbd_asb_recover_2p(struct drbd_conf *mdev) __must_hold(local)
 {
 	int hg, rv = -100;
+	enum drbd_after_sb_p after_sb_2p;
 
-	switch (mdev->tconn->net_conf->after_sb_2p) {
+	rcu_read_lock();
+	after_sb_2p = rcu_dereference(mdev->tconn->net_conf)->after_sb_2p;
+	rcu_read_unlock();
+	switch (after_sb_2p) {
 	case ASB_DISCARD_YOUNGER_PRI:
 	case ASB_DISCARD_OLDER_PRI:
 	case ASB_DISCARD_LEAST_CHG:
@@ -2514,6 +2569,7 @@ static int drbd_asb_recover_2p(struct drbd_conf *mdev) __must_hold(local)
 	case ASB_DISCARD_REMOTE:
 	case ASB_CONSENSUS:
 	case ASB_DISCARD_SECONDARY:
+	case ASB_DISCARD_ZERO_CHG:
 		dev_err(DEV, "Configuration error.\n");
 		break;
 	case ASB_VIOLENTLY:
@@ -2758,9 +2814,10 @@ static int drbd_uuid_compare(struct drbd_conf *mdev, int *rule_nr) __must_hold(l
 static enum drbd_conns drbd_sync_handshake(struct drbd_conf *mdev, enum drbd_role peer_role,
 					   enum drbd_disk_state peer_disk) __must_hold(local)
 {
-	int hg, rule_nr;
 	enum drbd_conns rv = C_MASK;
 	enum drbd_disk_state mydisk;
+	struct net_conf *nc;
+	int hg, rule_nr, rr_conflict, dry_run;
 
 	mydisk = mdev->state.disk;
 	if (mydisk == D_NEGOTIATING)
@@ -2797,7 +2854,10 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_conf *mdev, enum drbd_rol
 	if (abs(hg) == 100)
 		drbd_khelper(mdev, "initial-split-brain");
 
-	if (hg == 100 || (hg == -100 && mdev->tconn->net_conf->always_asbp)) {
+	rcu_read_lock();
+	nc = rcu_dereference(mdev->tconn->net_conf);
+
+	if (hg == 100 || (hg == -100 && nc->always_asbp)) {
 		int pcount = (mdev->state.role == R_PRIMARY)
 			   + (peer_role == R_PRIMARY);
 		int forced = (hg == -100);
@@ -2826,9 +2886,9 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_conf *mdev, enum drbd_rol
 	}
 
 	if (hg == -100) {
-		if (mdev->tconn->net_conf->want_lose && !(mdev->p_uuid[UI_FLAGS]&1))
+		if (nc->want_lose && !(mdev->p_uuid[UI_FLAGS]&1))
 			hg = -1;
-		if (!mdev->tconn->net_conf->want_lose && (mdev->p_uuid[UI_FLAGS]&1))
+		if (!nc->want_lose && (mdev->p_uuid[UI_FLAGS]&1))
 			hg = 1;
 
 		if (abs(hg) < 100)
@@ -2836,6 +2896,9 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_conf *mdev, enum drbd_rol
 			     "Sync from %s node\n",
 			     (hg < 0) ? "peer" : "this");
 	}
+	rr_conflict = nc->rr_conflict;
+	dry_run = nc->dry_run;
+	rcu_read_unlock();
 
 	if (hg == -100) {
 		/* FIXME this log message is not correct if we end up here
@@ -2854,7 +2917,7 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_conf *mdev, enum drbd_rol
 
 	if (hg < 0 && /* by intention we do not use mydisk here. */
 	    mdev->state.role == R_PRIMARY && mdev->state.disk >= D_CONSISTENT) {
-		switch (mdev->tconn->net_conf->rr_conflict) {
+		switch (rr_conflict) {
 		case ASB_CALL_HELPER:
 			drbd_khelper(mdev, "pri-lost");
 			/* fall through */
@@ -2867,7 +2930,7 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_conf *mdev, enum drbd_rol
 		}
 	}
 
-	if (mdev->tconn->net_conf->dry_run || test_bit(CONN_DRY_RUN, &mdev->tconn->flags)) {
+	if (dry_run || test_bit(CONN_DRY_RUN, &mdev->tconn->flags)) {
 		if (hg == 0)
 			dev_info(DEV, "dry-run connect: No resync, would become Connected immediately.\n");
 		else
@@ -2926,6 +2989,8 @@ static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 	int p_proto, p_after_sb_0p, p_after_sb_1p, p_after_sb_2p;
 	int p_want_lose, p_two_primaries, cf;
 	char p_integrity_alg[SHARED_SECRET_MAX] = "";
+	unsigned char *my_alg;
+	struct net_conf *nc;
 
 	p_proto		= be32_to_cpu(p->protocol);
 	p_after_sb_0p	= be32_to_cpu(p->after_sb_0p);
@@ -2940,38 +3005,43 @@ static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 	if (cf & CF_DRY_RUN)
 		set_bit(CONN_DRY_RUN, &tconn->flags);
 
-	if (p_proto != tconn->net_conf->wire_protocol && tconn->agreed_pro_version < 100) {
+	rcu_read_lock();
+	nc = rcu_dereference(tconn->net_conf);
+
+	if (p_proto != nc->wire_protocol && tconn->agreed_pro_version < 100) {
 		conn_err(tconn, "incompatible communication protocols\n");
-		goto disconnect;
+		goto disconnect_rcu_unlock;
 	}
 
-	if (cmp_after_sb(p_after_sb_0p, tconn->net_conf->after_sb_0p)) {
+	if (cmp_after_sb(p_after_sb_0p, nc->after_sb_0p)) {
 		conn_err(tconn, "incompatible after-sb-0pri settings\n");
-		goto disconnect;
+		goto disconnect_rcu_unlock;
 	}
 
-	if (cmp_after_sb(p_after_sb_1p, tconn->net_conf->after_sb_1p)) {
+	if (cmp_after_sb(p_after_sb_1p, nc->after_sb_1p)) {
 		conn_err(tconn, "incompatible after-sb-1pri settings\n");
-		goto disconnect;
+		goto disconnect_rcu_unlock;
 	}
 
-	if (cmp_after_sb(p_after_sb_2p, tconn->net_conf->after_sb_2p)) {
+	if (cmp_after_sb(p_after_sb_2p, nc->after_sb_2p)) {
 		conn_err(tconn, "incompatible after-sb-2pri settings\n");
-		goto disconnect;
+		goto disconnect_rcu_unlock;
 	}
 
-	if (p_want_lose && tconn->net_conf->want_lose) {
+	if (p_want_lose && nc->want_lose) {
 		conn_err(tconn, "both sides have the 'want_lose' flag set\n");
-		goto disconnect;
+		goto disconnect_rcu_unlock;
 	}
 
-	if (p_two_primaries != tconn->net_conf->two_primaries) {
+	if (p_two_primaries != nc->two_primaries) {
 		conn_err(tconn, "incompatible setting of the two-primaries options\n");
-		goto disconnect;
+		goto disconnect_rcu_unlock;
 	}
 
+	my_alg = nc->integrity_alg;
+	rcu_read_unlock();
+
 	if (tconn->agreed_pro_version >= 87) {
-		unsigned char *my_alg = tconn->net_conf->integrity_alg;
 		int err;
 
 		err = drbd_recv_all(tconn, p_integrity_alg, pi->size);
@@ -2989,6 +3059,8 @@ static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 
 	return 0;
 
+disconnect_rcu_unlock:
+	rcu_read_unlock();
 disconnect:
 	conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_HARD);
 	return -EIO;
@@ -4322,19 +4394,26 @@ static int drbd_do_auth(struct drbd_tconn *tconn)
 	char *response = NULL;
 	char *right_response = NULL;
 	char *peers_ch = NULL;
-	unsigned int key_len = strlen(tconn->net_conf->shared_secret);
+	unsigned int key_len;
+	char secret[SHARED_SECRET_MAX]; /* 64 byte */
 	unsigned int resp_size;
 	struct hash_desc desc;
 	struct packet_info pi;
+	struct net_conf *nc;
 	int err, rv;
 
 	/* FIXME: Put the challenge/response into the preallocated socket buffer.  */
 
+	rcu_read_lock();
+	nc = rcu_dereference(tconn->net_conf);
+	key_len = strlen(nc->shared_secret);
+	memcpy(secret, nc->shared_secret, key_len);
+	rcu_read_unlock();
+
 	desc.tfm = tconn->cram_hmac_tfm;
 	desc.flags = 0;
 
-	rv = crypto_hash_setkey(tconn->cram_hmac_tfm,
-				(u8 *)tconn->net_conf->shared_secret, key_len);
+	rv = crypto_hash_setkey(tconn->cram_hmac_tfm, (u8 *)secret, key_len);
 	if (rv) {
 		conn_err(tconn, "crypto_hash_setkey() failed with %d\n", rv);
 		rv = -1;
@@ -4456,8 +4535,8 @@ static int drbd_do_auth(struct drbd_tconn *tconn)
 	rv = !memcmp(response, right_response, resp_size);
 
 	if (rv)
-		conn_info(tconn, "Peer authenticated using %d bytes of '%s' HMAC\n",
-		     resp_size, tconn->net_conf->cram_hmac_alg);
+		conn_info(tconn, "Peer authenticated using %d bytes HMAC\n",
+		     resp_size);
 	else
 		rv = -1;
 
@@ -4884,33 +4963,42 @@ int drbd_asender(struct drbd_thread *thi)
 	int received = 0;
 	unsigned int header_size = drbd_header_size(tconn);
 	int expect   = header_size;
-	int ping_timeout_active = 0;
+	bool ping_timeout_active = false;
+	struct net_conf *nc;
+	int ping_timeo, no_cork, ping_int;
 
 	current->policy = SCHED_RR;  /* Make this a realtime task! */
 	current->rt_priority = 2;    /* more important than all other tasks */
 
 	while (get_t_state(thi) == RUNNING) {
 		drbd_thread_current_set_cpu(thi);
+
+		rcu_read_lock();
+		nc = rcu_dereference(tconn->net_conf);
+		ping_timeo = nc->ping_timeo;
+		no_cork = nc->no_cork;
+		ping_int = nc->ping_int;
+		rcu_read_unlock();
+
 		if (test_and_clear_bit(SEND_PING, &tconn->flags)) {
 			if (drbd_send_ping(tconn)) {
 				conn_err(tconn, "drbd_send_ping has failed\n");
 				goto reconnect;
 			}
-			tconn->meta.socket->sk->sk_rcvtimeo =
-				tconn->net_conf->ping_timeo*HZ/10;
-			ping_timeout_active = 1;
+			tconn->meta.socket->sk->sk_rcvtimeo = ping_timeo * HZ / 10;
+			ping_timeout_active = true;
 		}
 
 		/* TODO: conditionally cork; it may hurt latency if we cork without
 		   much to send */
-		if (!tconn->net_conf->no_cork)
+		if (!no_cork)
 			drbd_tcp_cork(tconn->meta.socket);
 		if (tconn_finish_peer_reqs(tconn)) {
 			conn_err(tconn, "tconn_finish_peer_reqs() failed\n");
 			goto reconnect;
 		}
 		/* but unconditionally uncork unless disabled */
-		if (!tconn->net_conf->no_cork)
+		if (!no_cork)
 			drbd_tcp_uncork(tconn->meta.socket);
 
 		/* short circuit, recv_msg would return EINTR anyways. */
@@ -4984,10 +5072,11 @@ int drbd_asender(struct drbd_thread *thi)
 
 			tconn->last_received = jiffies;
 
-			/* the idle_timeout (ping-int)
-			 * has been restored in got_PingAck() */
-			if (cmd == &asender_tbl[P_PING_ACK])
-				ping_timeout_active = 0;
+			if (cmd == &asender_tbl[P_PING_ACK]) {
+				/* restore idle timeout */
+				tconn->meta.socket->sk->sk_rcvtimeo = ping_int * HZ;
+				ping_timeout_active = false;
+			}
 
 			buf	 = tconn->meta.rbuf;
 			received = 0;
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 0f1a29f..c4e4553 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -323,6 +323,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		struct bio_and_error *m)
 {
 	struct drbd_conf *mdev = req->w.mdev;
+	struct net_conf *nc;
 	int p, rv = 0;
 
 	if (m)
@@ -344,7 +345,10 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		 * and from w_read_retry_remote */
 		D_ASSERT(!(req->rq_state & RQ_NET_MASK));
 		req->rq_state |= RQ_NET_PENDING;
-		p = mdev->tconn->net_conf->wire_protocol;
+		rcu_read_lock();
+		nc = rcu_dereference(mdev->tconn->net_conf);
+		p = nc->wire_protocol;
+		rcu_read_unlock();
 		req->rq_state |=
 			p == DRBD_PROT_C ? RQ_EXP_WRITE_ACK :
 			p == DRBD_PROT_B ? RQ_EXP_RECEIVE_ACK : 0;
@@ -474,7 +478,11 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		drbd_queue_work(&mdev->tconn->data.work, &req->w);
 
 		/* close the epoch, in case it outgrew the limit */
-		if (mdev->tconn->newest_tle->n_writes >= mdev->tconn->net_conf->max_epoch_size)
+		rcu_read_lock();
+		nc = rcu_dereference(mdev->tconn->net_conf);
+		p = nc->max_epoch_size;
+		rcu_read_unlock();
+		if (mdev->tconn->newest_tle->n_writes >= p)
 			queue_barrier(mdev);
 
 		break;
@@ -729,6 +737,7 @@ int __drbd_make_request(struct drbd_conf *mdev, struct bio *bio, unsigned long s
 	const sector_t sector = bio->bi_sector;
 	struct drbd_tl_epoch *b = NULL;
 	struct drbd_request *req;
+	struct net_conf *nc;
 	int local, remote, send_oos = 0;
 	int err;
 	int ret = 0;
@@ -935,17 +944,19 @@ allocate_barrier:
 	if (send_oos && drbd_set_out_of_sync(mdev, sector, size))
 		_req_mod(req, QUEUE_FOR_SEND_OOS);
 
+	rcu_read_lock();
+	nc = rcu_dereference(mdev->tconn->net_conf);
 	if (remote &&
-	    mdev->tconn->net_conf->on_congestion != OC_BLOCK && mdev->tconn->agreed_pro_version >= 96) {
+	    nc->on_congestion != OC_BLOCK && mdev->tconn->agreed_pro_version >= 96) {
 		int congested = 0;
 
-		if (mdev->tconn->net_conf->cong_fill &&
-		    atomic_read(&mdev->ap_in_flight) >= mdev->tconn->net_conf->cong_fill) {
+		if (nc->cong_fill &&
+		    atomic_read(&mdev->ap_in_flight) >= nc->cong_fill) {
 			dev_info(DEV, "Congestion-fill threshold reached\n");
 			congested = 1;
 		}
 
-		if (mdev->act_log->used >= mdev->tconn->net_conf->cong_extents) {
+		if (mdev->act_log->used >= nc->cong_extents) {
 			dev_info(DEV, "Congestion-extents threshold reached\n");
 			congested = 1;
 		}
@@ -953,12 +964,13 @@ allocate_barrier:
 		if (congested) {
 			queue_barrier(mdev); /* last barrier, after mirrored writes */
 
-			if (mdev->tconn->net_conf->on_congestion == OC_PULL_AHEAD)
+			if (nc->on_congestion == OC_PULL_AHEAD)
 				_drbd_set_state(_NS(mdev, conn, C_AHEAD), 0, NULL);
-			else  /*mdev->tconn->net_conf->on_congestion == OC_DISCONNECT */
+			else  /*nc->on_congestion == OC_DISCONNECT */
 				_drbd_set_state(_NS(mdev, conn, C_DISCONNECTING), 0, NULL);
 		}
 	}
+	rcu_read_unlock();
 
 	spin_unlock_irq(&mdev->tconn->req_lock);
 	kfree(b); /* if someone else has beaten us to it... */
@@ -1058,12 +1070,14 @@ void request_timer_fn(unsigned long data)
 	struct drbd_tconn *tconn = mdev->tconn;
 	struct drbd_request *req; /* oldest request */
 	struct list_head *le;
-	unsigned long et = 0; /* effective timeout = ko_count * timeout */
+	struct net_conf *nc;
+	unsigned long et; /* effective timeout = ko_count * timeout */
+
+	rcu_read_lock();
+	nc = rcu_dereference(tconn->net_conf);
+	et = nc ? nc->timeout * HZ/10 * nc->ko_count : 0;
+	rcu_read_unlock();
 
-	if (get_net_conf(tconn)) {
-		et = tconn->net_conf->timeout*HZ/10 * tconn->net_conf->ko_count;
-		put_net_conf(tconn);
-	}
 	if (!et || mdev->state.conn < C_WF_REPORT_PARAMS)
 		return; /* Recurring timer stopped */
 
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 0aed33b..2423283 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -464,6 +464,7 @@ is_valid_state(struct drbd_conf *mdev, union drbd_state ns)
 
 	enum drbd_fencing_p fp;
 	enum drbd_state_rv rv = SS_SUCCESS;
+	struct net_conf *nc;
 
 	fp = FP_DONT_CARE;
 	if (get_ldev(mdev)) {
@@ -471,14 +472,15 @@ is_valid_state(struct drbd_conf *mdev, union drbd_state ns)
 		put_ldev(mdev);
 	}
 
-	if (get_net_conf(mdev->tconn)) {
-		if (!mdev->tconn->net_conf->two_primaries && ns.role == R_PRIMARY) {
+	rcu_read_lock();
+	nc = rcu_dereference(mdev->tconn->net_conf);
+	if (nc) {
+		if (!nc->two_primaries && ns.role == R_PRIMARY) {
 			if (ns.peer == R_PRIMARY)
 				rv = SS_TWO_PRIMARIES;
 			else if (conn_highest_peer(mdev->tconn) == R_PRIMARY)
 				rv = SS_O_VOL_PEER_PRI;
-			}
-		put_net_conf(mdev->tconn);
+		}
 	}
 
 	if (rv <= 0)
@@ -513,7 +515,7 @@ is_valid_state(struct drbd_conf *mdev, union drbd_state ns)
 		rv = SS_CONNECTED_OUTDATES;
 
 	else if ((ns.conn == C_VERIFY_S || ns.conn == C_VERIFY_T) &&
-		 (mdev->tconn->net_conf->verify_alg[0] == 0))
+		 (nc->verify_alg[0] == 0))
 		rv = SS_NO_VERIFY_ALG;
 
 	else if ((ns.conn == C_VERIFY_S || ns.conn == C_VERIFY_T) &&
@@ -523,6 +525,8 @@ is_valid_state(struct drbd_conf *mdev, union drbd_state ns)
 	else if (ns.conn >= C_CONNECTED && ns.pdsk == D_UNKNOWN)
 		rv = SS_CONNECTED_OUTDATES;
 
+	rcu_read_unlock();
+
 	return rv;
 }
 
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index b63c08e..c54c191 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1621,10 +1621,16 @@ void drbd_start_resync(struct drbd_conf *mdev, enum drbd_conns side)
 			 * detect connection loss, then waiting for a ping
 			 * response (implicit in drbd_resync_finished) reduces
 			 * the race considerably, but does not solve it. */
-			if (side == C_SYNC_SOURCE)
-				schedule_timeout_interruptible(
-					mdev->tconn->net_conf->ping_int * HZ +
-					mdev->tconn->net_conf->ping_timeo*HZ/9);
+			if (side == C_SYNC_SOURCE) {
+				struct net_conf *nc;
+				int timeo;
+
+				rcu_read_lock();
+				nc = rcu_dereference(mdev->tconn->net_conf);
+				timeo = nc->ping_int * HZ + nc->ping_timeo * HZ / 9;
+				rcu_read_unlock();
+				schedule_timeout_interruptible(timeo);
+			}
 			drbd_resync_finished(mdev);
 		}
 
@@ -1647,22 +1653,30 @@ int drbd_worker(struct drbd_thread *thi)
 	struct drbd_tconn *tconn = thi->tconn;
 	struct drbd_work *w = NULL;
 	struct drbd_conf *mdev;
+	struct net_conf *nc;
 	LIST_HEAD(work_list);
 	int vnr, intr = 0;
+	int cork;
 
 	while (get_t_state(thi) == RUNNING) {
 		drbd_thread_current_set_cpu(thi);
 
 		if (down_trylock(&tconn->data.work.s)) {
 			mutex_lock(&tconn->data.mutex);
-			if (tconn->data.socket && !tconn->net_conf->no_cork)
+
+			rcu_read_lock();
+			nc = rcu_dereference(tconn->net_conf);
+			cork = nc ? !nc->no_cork : 0;
+			rcu_read_unlock();
+
+			if (tconn->data.socket && cork)
 				drbd_tcp_uncork(tconn->data.socket);
 			mutex_unlock(&tconn->data.mutex);
 
 			intr = down_interruptible(&tconn->data.work.s);
 
 			mutex_lock(&tconn->data.mutex);
-			if (tconn->data.socket  && !tconn->net_conf->no_cork)
+			if (tconn->data.socket  && cork)
 				drbd_tcp_cork(tconn->data.socket);
 			mutex_unlock(&tconn->data.mutex);
 		}
-- 
1.7.4.1

