Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab1I3Ms6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 08:48:58 -0400
Received: from mail09.linbit.com ([212.69.161.110]:42781 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758615Ab1I3Msc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 08:48:32 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 10/11] drbd: Proper locking for updates to net_conf under RCU
Date: Fri, 30 Sep 2011 14:48:25 +0200
Message-Id: <1317386906-19260-11-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317386906-19260-1-git-send-email-philipp.reisner@linbit.com>
References: <1317386906-19260-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing the get_net_conf()/put_net_conf() functions

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |   29 +-----------
 drivers/block/drbd/drbd_main.c     |   17 ++++++-
 drivers/block/drbd/drbd_nl.c       |   67 ++++++++++++----------------
 drivers/block/drbd/drbd_receiver.c |   83 +++++++++++++++++++++++-------------
 4 files changed, 100 insertions(+), 96 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 99da54c..83e6cad 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -833,9 +833,8 @@ struct drbd_tconn {			/* is a resource from the config file */
 
 	unsigned long flags;
 	struct net_conf *net_conf;	/* content protected by rcu */
-	atomic_t net_cnt;		/* Users of net_conf */
-	wait_queue_head_t net_cnt_wait;
-	wait_queue_head_t ping_wait;		/* Woken upon reception of a ping, and a state change */
+	struct mutex net_conf_update;	/* mutex for ready-copy-update of net_conf */
+	wait_queue_head_t ping_wait;	/* Woken upon reception of a ping, and a state change */
 	struct res_opts res_opts;
 
 	struct drbd_socket data;	/* data/barrier/cstate/parameter packets */
@@ -1379,6 +1378,7 @@ extern void drbd_delete_device(struct drbd_conf *mdev);
 struct drbd_tconn *drbd_new_tconn(const char *name);
 extern void drbd_free_tconn(struct drbd_tconn *tconn);
 struct drbd_tconn *conn_by_name(const char *name);
+extern void conn_free_crypto(struct drbd_tconn *tconn);
 
 extern int proc_details;
 
@@ -1935,29 +1935,6 @@ static inline void _sub_unacked(struct drbd_conf *mdev, int n, const char *func,
 	ERR_IF_CNT_IS_NEGATIVE(unacked_cnt, func, line);
 }
 
-static inline void put_net_conf(struct drbd_tconn *tconn)
-{
-	if (atomic_dec_and_test(&tconn->net_cnt))
-		wake_up(&tconn->net_cnt_wait);
-}
-
-/**
- * get_net_conf() - Increase ref count on mdev->tconn->net_conf; Returns 0 if nothing there
- * @mdev:	DRBD device.
- *
- * You have to call put_net_conf() when finished working with mdev->tconn->net_conf.
- */
-static inline int get_net_conf(struct drbd_tconn *tconn)
-{
-	int have_net_conf;
-
-	atomic_inc(&tconn->net_cnt);
-	have_net_conf = tconn->cstate >= C_UNCONNECTED;
-	if (!have_net_conf)
-		put_net_conf(tconn);
-	return have_net_conf;
-}
-
 /**
  * get_ldev() - Increase the ref count on mdev->ldev. Returns 0 if there is no ldev
  * @M:		DRBD device.
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index d335ecc..5eb60e8 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2376,6 +2376,20 @@ static void drbd_free_socket(struct drbd_socket *socket)
 	free_page((unsigned long) socket->rbuf);
 }
 
+void conn_free_crypto(struct drbd_tconn *tconn)
+{
+	crypto_free_hash(tconn->cram_hmac_tfm);
+	crypto_free_hash(tconn->integrity_w_tfm);
+	crypto_free_hash(tconn->integrity_r_tfm);
+	kfree(tconn->int_dig_in);
+	kfree(tconn->int_dig_vv);
+	tconn->cram_hmac_tfm = NULL;
+	tconn->integrity_w_tfm = NULL;
+	tconn->integrity_r_tfm = NULL;
+	tconn->int_dig_in = NULL;
+	tconn->int_dig_vv = NULL;
+}
+
 struct drbd_tconn *drbd_new_tconn(const char *name)
 {
 	struct drbd_tconn *tconn;
@@ -2402,8 +2416,7 @@ struct drbd_tconn *drbd_new_tconn(const char *name)
 	tconn->cstate = C_STANDALONE;
 	mutex_init(&tconn->cstate_mutex);
 	spin_lock_init(&tconn->req_lock);
-	atomic_set(&tconn->net_cnt, 0);
-	init_waitqueue_head(&tconn->net_cnt_wait);
+	mutex_init(&tconn->net_conf_update);
 	init_waitqueue_head(&tconn->ping_wait);
 	idr_init(&tconn->volumes);
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 6d28e7c..bafa457 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -615,11 +615,12 @@ drbd_set_role(struct drbd_conf *mdev, enum drbd_role new_role, int force)
 			put_ldev(mdev);
 		}
 	} else {
-		rcu_read_lock();
-		nc = rcu_dereference(mdev->tconn->net_conf);
+		mutex_lock(&mdev->tconn->net_conf_update);
+		nc = mdev->tconn->net_conf;
 		if (nc)
-			nc->want_lose = 0;
-		rcu_read_unlock();
+			nc->want_lose = 0; /* without copy; single bit op is atomic */
+		mutex_unlock(&mdev->tconn->net_conf_update);
+
 		set_disk_ro(mdev->vdisk, false);
 		if (get_ldev(mdev)) {
 			if (((mdev->state.conn < C_CONNECTED ||
@@ -1809,17 +1810,16 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 
 	conn_reconfig_start(tconn);
 
-	rcu_read_lock();
-	old_conf = rcu_dereference(tconn->net_conf);
+	mutex_lock(&tconn->net_conf_update);
+	old_conf = tconn->net_conf;
 
 	if (!old_conf) {
 		drbd_msg_put_info("net conf missing, try connect");
 		retcode = ERR_INVALID_REQUEST;
-		goto fail_rcu_unlock;
+		goto fail;
 	}
 
 	*new_conf = *old_conf;
-	rcu_read_unlock();
 
 	err = net_conf_from_attrs(new_conf, info);
 	if (err) {
@@ -1834,13 +1834,10 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 
 	/* re-sync running */
 	rsr = conn_resync_running(tconn);
-	rcu_read_lock();
-	old_conf = rcu_dereference(tconn->net_conf);
 	if (rsr && old_conf && strcmp(new_conf->csums_alg, old_conf->csums_alg)) {
 		retcode = ERR_CSUMS_RESYNC_RUNNING;
-		goto fail_rcu_unlock;
+		goto fail;
 	}
-	rcu_read_unlock();
 
 	if (!rsr && new_conf->csums_alg[0]) {
 		csums_tfm = crypto_alloc_hash(new_conf->csums_alg, 0, CRYPTO_ALG_ASYNC);
@@ -1858,15 +1855,12 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 
 	/* online verify running */
 	ovr = conn_ov_running(tconn);
-	rcu_read_lock();
-	old_conf = rcu_dereference(tconn->net_conf);
-	if (ovr && old_conf) {
+	if (ovr) {
 		if (strcmp(new_conf->verify_alg, old_conf->verify_alg)) {
 			retcode = ERR_VERIFY_RUNNING;
-			goto fail_rcu_unlock;
+			goto fail;
 		}
 	}
-	rcu_read_unlock();
 
 	if (!ovr && new_conf->verify_alg[0]) {
 		verify_tfm = crypto_alloc_hash(new_conf->verify_alg, 0, CRYPTO_ALG_ASYNC);
@@ -1883,8 +1877,6 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	rcu_assign_pointer(tconn->net_conf, new_conf);
-	synchronize_rcu();
-	kfree(old_conf);
 
 	if (!rsr) {
 		crypto_free_hash(tconn->csums_tfm);
@@ -1897,12 +1889,17 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 		verify_tfm = NULL;
 	}
 
+	mutex_unlock(&tconn->net_conf_update);
+	synchronize_rcu();
+	kfree(old_conf);
+
 	if (tconn->cstate >= C_WF_REPORT_PARAMS)
 		drbd_send_sync_param(minor_to_mdev(conn_lowest_minor(tconn)));
 
- fail_rcu_unlock:
-	rcu_read_unlock();
+	goto out;
+
  fail:
+	mutex_unlock(&tconn->net_conf_update);
 	crypto_free_hash(csums_tfm);
 	crypto_free_hash(verify_tfm);
 	kfree(new_conf);
@@ -2081,32 +2078,26 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	conn_flush_workqueue(tconn);
-	spin_lock_irq(&tconn->req_lock);
-	rcu_read_lock();
-	old_conf = rcu_dereference(tconn->net_conf);
-	if (old_conf != NULL) {
+
+	mutex_lock(&tconn->net_conf_update);
+	old_conf = tconn->net_conf;
+	if (old_conf) {
 		retcode = ERR_NET_CONFIGURED;
-		rcu_read_unlock();
-		spin_unlock_irq(&tconn->req_lock);
+		mutex_unlock(&tconn->net_conf_update);
 		goto fail;
 	}
 	rcu_assign_pointer(tconn->net_conf, new_conf);
 
-	crypto_free_hash(tconn->cram_hmac_tfm);
+	conn_free_crypto(tconn);
 	tconn->cram_hmac_tfm = tfm;
-
-	crypto_free_hash(tconn->integrity_w_tfm);
 	tconn->integrity_w_tfm = integrity_w_tfm;
-
-	crypto_free_hash(tconn->integrity_r_tfm);
 	tconn->integrity_r_tfm = integrity_r_tfm;
+	tconn->int_dig_in = int_dig_in;
+	tconn->int_dig_vv = int_dig_vv;
 
-	kfree(tconn->int_dig_in);
-	kfree(tconn->int_dig_vv);
-	tconn->int_dig_in=int_dig_in;
-	tconn->int_dig_vv=int_dig_vv;
-	retcode = _conn_request_state(tconn, NS(conn, C_UNCONNECTED), CS_VERBOSE);
-	spin_unlock_irq(&tconn->req_lock);
+	mutex_unlock(&tconn->net_conf_update);
+
+	retcode = conn_request_state(tconn, NS(conn, C_UNCONNECTED), CS_VERBOSE);
 
 	rcu_read_lock();
 	idr_for_each_entry(&tconn->volumes, mdev, i) {
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index a37f2ee..05b214c 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3138,6 +3138,7 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 	unsigned int header_size, data_size, exp_max_sz;
 	struct crypto_hash *verify_tfm = NULL;
 	struct crypto_hash *csums_tfm = NULL;
+	struct net_conf *old_conf, *new_conf = NULL;
 	const int apv = tconn->agreed_pro_version;
 	int *rs_plan_s = NULL;
 	int fifo_size = 0;
@@ -3212,10 +3213,13 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 			p->csums_alg[SHARED_SECRET_MAX-1] = 0;
 		}
 
-		if (strcmp(mdev->tconn->net_conf->verify_alg, p->verify_alg)) {
+		mutex_lock(&mdev->tconn->net_conf_update);
+		old_conf = mdev->tconn->net_conf;
+
+		if (strcmp(old_conf->verify_alg, p->verify_alg)) {
 			if (mdev->state.conn == C_WF_REPORT_PARAMS) {
 				dev_err(DEV, "Different verify-alg settings. me=\"%s\" peer=\"%s\"\n",
-				    mdev->tconn->net_conf->verify_alg, p->verify_alg);
+				    old_conf->verify_alg, p->verify_alg);
 				goto disconnect;
 			}
 			verify_tfm = drbd_crypto_alloc_digest_safe(mdev,
@@ -3226,10 +3230,10 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 			}
 		}
 
-		if (apv >= 89 && strcmp(mdev->tconn->net_conf->csums_alg, p->csums_alg)) {
+		if (apv >= 89 && strcmp(old_conf->csums_alg, p->csums_alg)) {
 			if (mdev->state.conn == C_WF_REPORT_PARAMS) {
 				dev_err(DEV, "Different csums-alg settings. me=\"%s\" peer=\"%s\"\n",
-				    mdev->tconn->net_conf->csums_alg, p->csums_alg);
+				    old_conf->csums_alg, p->csums_alg);
 				goto disconnect;
 			}
 			csums_tfm = drbd_crypto_alloc_digest_safe(mdev,
@@ -3259,22 +3263,38 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 			put_ldev(mdev);
 		}
 
-		spin_lock(&mdev->peer_seq_lock);
-		/* lock against drbd_nl_syncer_conf() */
-		if (verify_tfm) {
-			strcpy(mdev->tconn->net_conf->verify_alg, p->verify_alg);
-			mdev->tconn->net_conf->verify_alg_len = strlen(p->verify_alg) + 1;
-			crypto_free_hash(mdev->tconn->verify_tfm);
-			mdev->tconn->verify_tfm = verify_tfm;
-			dev_info(DEV, "using verify-alg: \"%s\"\n", p->verify_alg);
+		if (verify_tfm || csums_tfm) {
+			new_conf = kzalloc(sizeof(struct net_conf), GFP_KERNEL);
+			if (!new_conf) {
+				dev_err(DEV, "Allocation of new net_conf failed\n");
+				goto disconnect;
+			}
+
+			*new_conf = *old_conf;
+
+			if (verify_tfm) {
+				strcpy(new_conf->verify_alg, p->verify_alg);
+				new_conf->verify_alg_len = strlen(p->verify_alg) + 1;
+				crypto_free_hash(mdev->tconn->verify_tfm);
+				mdev->tconn->verify_tfm = verify_tfm;
+				dev_info(DEV, "using verify-alg: \"%s\"\n", p->verify_alg);
+			}
+			if (csums_tfm) {
+				strcpy(new_conf->csums_alg, p->csums_alg);
+				new_conf->csums_alg_len = strlen(p->csums_alg) + 1;
+				crypto_free_hash(mdev->tconn->csums_tfm);
+				mdev->tconn->csums_tfm = csums_tfm;
+				dev_info(DEV, "using csums-alg: \"%s\"\n", p->csums_alg);
+			}
+			rcu_assign_pointer(tconn->net_conf, new_conf);
 		}
-		if (csums_tfm) {
-			strcpy(mdev->tconn->net_conf->csums_alg, p->csums_alg);
-			mdev->tconn->net_conf->csums_alg_len = strlen(p->csums_alg) + 1;
-			crypto_free_hash(mdev->tconn->csums_tfm);
-			mdev->tconn->csums_tfm = csums_tfm;
-			dev_info(DEV, "using csums-alg: \"%s\"\n", p->csums_alg);
+		mutex_unlock(&mdev->tconn->net_conf_update);
+		if (new_conf) {
+			synchronize_rcu();
+			kfree(old_conf);
 		}
+
+		spin_lock(&mdev->peer_seq_lock);
 		if (fifo_size != mdev->rs_plan_s.size) {
 			kfree(mdev->rs_plan_s.values);
 			mdev->rs_plan_s.values = rs_plan_s;
@@ -3286,6 +3306,7 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 	return 0;
 
 disconnect:
+	mutex_lock(&mdev->tconn->net_conf_update);
 	/* just for completeness: actually not needed,
 	 * as this is not reached if csums_tfm was ok. */
 	crypto_free_hash(csums_tfm);
@@ -3715,7 +3736,9 @@ static int receive_state(struct drbd_tconn *tconn, struct packet_info *pi)
 		}
 	}
 
-	mdev->tconn->net_conf->want_lose = 0;
+	mutex_lock(&mdev->tconn->net_conf_update);
+	mdev->tconn->net_conf->want_lose = 0; /* without copy; single bit op is atomic */
+	mutex_unlock(&mdev->tconn->net_conf_update);
 
 	drbd_md_sync(mdev); /* update connected indicator, la_size, ... */
 
@@ -4183,13 +4206,17 @@ static void drbd_disconnect(struct drbd_tconn *tconn)
 	spin_unlock_irq(&tconn->req_lock);
 
 	if (oc == C_DISCONNECTING) {
-		wait_event(tconn->net_cnt_wait, atomic_read(&tconn->net_cnt) == 0);
+		struct net_conf *old_conf;
 
-		crypto_free_hash(tconn->cram_hmac_tfm);
-		tconn->cram_hmac_tfm = NULL;
+		mutex_lock(&tconn->net_conf_update);
+		old_conf = tconn->net_conf;
+		rcu_assign_pointer(tconn->net_conf, NULL);
+		conn_free_crypto(tconn);
+		mutex_unlock(&tconn->net_conf_update);
+
+		synchronize_rcu();
+		kfree(old_conf);
 
-		kfree(tconn->net_conf);
-		tconn->net_conf = NULL;
 		conn_request_state(tconn, NS(conn, C_STANDALONE), CS_VERBOSE);
 	}
 }
@@ -4568,12 +4595,8 @@ int drbdd_init(struct drbd_thread *thi)
 		}
 	} while (h == 0);
 
-	if (h > 0) {
-		if (get_net_conf(tconn)) {
-			drbdd(tconn);
-			put_net_conf(tconn);
-		}
-	}
+	if (h > 0)
+		drbdd(tconn);
 
 	drbd_disconnect(tconn);
 
-- 
1.7.4.1

