Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab1HaPLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 11:11:52 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60080 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234Ab1HaPLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 11:11:18 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 14/16] drbd: Converted drbd_nl_(net_conf|disconnect)() from mdev to tconn
Date: Wed, 31 Aug 2011 17:11:06 +0200
Message-Id: <1314803468-1201-15-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
References: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    2 +
 drivers/block/drbd/drbd_main.c |    2 +-
 drivers/block/drbd/drbd_nl.c   |  120 ++++++++++++++++++++--------------------
 3 files changed, 63 insertions(+), 61 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 8ef5b82..2ef168c 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -170,6 +170,7 @@ drbd_insert_fault(struct drbd_conf *mdev, unsigned int type) {
 
 extern struct drbd_conf **minor_table;
 extern struct ratelimit_state drbd_ratelimit_state;
+extern struct list_head drbd_tconns;
 
 /* on the wire */
 enum drbd_packet {
@@ -1474,6 +1475,7 @@ extern wait_queue_head_t drbd_pp_wait;
 
 extern rwlock_t global_state_lock;
 
+extern int conn_lowest_minor(struct drbd_tconn *tconn);
 extern struct drbd_conf *drbd_new_device(unsigned int minor);
 extern void drbd_free_mdev(struct drbd_conf *mdev);
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 689f23f..004118e 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -615,7 +615,7 @@ char *drbd_task_to_thread_name(struct drbd_tconn *tconn, struct task_struct *tas
 }
 
 #ifdef CONFIG_SMP
-static int conn_lowest_minor(struct drbd_tconn *tconn)
+int conn_lowest_minor(struct drbd_tconn *tconn)
 {
 	int minor = 0;
 	idr_get_next(&tconn->volumes, &minor);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 27a43d1..455a51d 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1326,7 +1326,7 @@ static int drbd_nl_detach(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
 	return 0;
 }
 
-static int drbd_nl_net_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
+static int drbd_nl_net_conf(struct drbd_tconn *tconn, struct drbd_nl_cfg_req *nlp,
 			    struct drbd_nl_cfg_reply *reply)
 {
 	int i;
@@ -1335,16 +1335,17 @@ static int drbd_nl_net_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
 	struct crypto_hash *tfm = NULL;
 	struct crypto_hash *integrity_w_tfm = NULL;
 	struct crypto_hash *integrity_r_tfm = NULL;
-	struct drbd_conf *odev;
+	struct drbd_conf *mdev;
 	char hmac_name[CRYPTO_MAX_ALG_NAME];
 	void *int_dig_out = NULL;
 	void *int_dig_in = NULL;
 	void *int_dig_vv = NULL;
+	struct drbd_tconn *oconn;
 	struct sockaddr *new_my_addr, *new_peer_addr, *taken_addr;
 
-	conn_reconfig_start(mdev->tconn);
+	conn_reconfig_start(tconn);
 
-	if (mdev->state.conn > C_STANDALONE) {
+	if (tconn->cstate > C_STANDALONE) {
 		retcode = ERR_NET_CONFIGURED;
 		goto fail;
 	}
@@ -1387,13 +1388,25 @@ static int drbd_nl_net_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
 		goto fail;
 	}
 
-	if (get_ldev(mdev)) {
-		enum drbd_fencing_p fp = mdev->ldev->dc.fencing;
-		put_ldev(mdev);
-		if (new_conf->wire_protocol == DRBD_PROT_A && fp == FP_STONITH) {
-			retcode = ERR_STONITH_AND_PROT_A;
+	idr_for_each_entry(&tconn->volumes, mdev, i) {
+		if (get_ldev(mdev)) {
+			enum drbd_fencing_p fp = mdev->ldev->dc.fencing;
+			put_ldev(mdev);
+			if (new_conf->wire_protocol == DRBD_PROT_A && fp == FP_STONITH) {
+				retcode = ERR_STONITH_AND_PROT_A;
+				goto fail;
+			}
+		}
+		if (mdev->state.role == R_PRIMARY && new_conf->want_lose) {
+			retcode = ERR_DISCARD;
 			goto fail;
 		}
+		if (!mdev->bitmap) {
+			if(drbd_bm_init(mdev)) {
+				retcode = ERR_NOMEM;
+				goto fail;
+			}
+		}
 	}
 
 	if (new_conf->on_congestion != OC_BLOCK && new_conf->wire_protocol != DRBD_PROT_A) {
@@ -1401,31 +1414,25 @@ static int drbd_nl_net_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
 		goto fail;
 	}
 
-	if (mdev->state.role == R_PRIMARY && new_conf->want_lose) {
-		retcode = ERR_DISCARD;
-		goto fail;
-	}
-
 	retcode = NO_ERROR;
 
 	new_my_addr = (struct sockaddr *)&new_conf->my_addr;
 	new_peer_addr = (struct sockaddr *)&new_conf->peer_addr;
-	for (i = 0; i < minor_count; i++) {
-		odev = minor_to_mdev(i);
-		if (!odev || odev == mdev)
+	list_for_each_entry(oconn, &drbd_tconns, all_tconn) {
+		if (oconn == tconn)
 			continue;
-		if (get_net_conf(odev->tconn)) {
-			taken_addr = (struct sockaddr *)&odev->tconn->net_conf->my_addr;
-			if (new_conf->my_addr_len == odev->tconn->net_conf->my_addr_len &&
+		if (get_net_conf(oconn)) {
+			taken_addr = (struct sockaddr *)&oconn->net_conf->my_addr;
+			if (new_conf->my_addr_len == oconn->net_conf->my_addr_len &&
 			    !memcmp(new_my_addr, taken_addr, new_conf->my_addr_len))
 				retcode = ERR_LOCAL_ADDR;
 
-			taken_addr = (struct sockaddr *)&odev->tconn->net_conf->peer_addr;
-			if (new_conf->peer_addr_len == odev->tconn->net_conf->peer_addr_len &&
+			taken_addr = (struct sockaddr *)&oconn->net_conf->peer_addr;
+			if (new_conf->peer_addr_len == oconn->net_conf->peer_addr_len &&
 			    !memcmp(new_peer_addr, taken_addr, new_conf->peer_addr_len))
 				retcode = ERR_PEER_ADDR;
 
-			put_net_conf(odev->tconn);
+			put_net_conf(oconn);
 			if (retcode != NO_ERROR)
 				goto fail;
 		}
@@ -1470,6 +1477,7 @@ static int drbd_nl_net_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
 
 	((char *)new_conf->shared_secret)[SHARED_SECRET_MAX-1] = 0;
 
+	/* allocation not in the IO path, cqueue thread context */
 	if (integrity_w_tfm) {
 		i = crypto_hash_digestsize(integrity_w_tfm);
 		int_dig_out = kmalloc(i, GFP_KERNEL);
@@ -1489,46 +1497,40 @@ static int drbd_nl_net_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
 		}
 	}
 
-	if (!mdev->bitmap) {
-		if(drbd_bm_init(mdev)) {
-			retcode = ERR_NOMEM;
-			goto fail;
-		}
-	}
-
-	drbd_flush_workqueue(mdev);
-	spin_lock_irq(&mdev->tconn->req_lock);
-	if (mdev->tconn->net_conf != NULL) {
+	conn_flush_workqueue(tconn);
+	spin_lock_irq(&tconn->req_lock);
+	if (tconn->net_conf != NULL) {
 		retcode = ERR_NET_CONFIGURED;
-		spin_unlock_irq(&mdev->tconn->req_lock);
+		spin_unlock_irq(&tconn->req_lock);
 		goto fail;
 	}
-	mdev->tconn->net_conf = new_conf;
+	tconn->net_conf = new_conf;
 
-	mdev->send_cnt = 0;
-	mdev->recv_cnt = 0;
-
-	crypto_free_hash(mdev->tconn->cram_hmac_tfm);
-	mdev->tconn->cram_hmac_tfm = tfm;
+	crypto_free_hash(tconn->cram_hmac_tfm);
+	tconn->cram_hmac_tfm = tfm;
 
-	crypto_free_hash(mdev->tconn->integrity_w_tfm);
-	mdev->tconn->integrity_w_tfm = integrity_w_tfm;
+	crypto_free_hash(tconn->integrity_w_tfm);
+	tconn->integrity_w_tfm = integrity_w_tfm;
 
-	crypto_free_hash(mdev->tconn->integrity_r_tfm);
-	mdev->tconn->integrity_r_tfm = integrity_r_tfm;
+	crypto_free_hash(tconn->integrity_r_tfm);
+	tconn->integrity_r_tfm = integrity_r_tfm;
 
-	kfree(mdev->tconn->int_dig_out);
-	kfree(mdev->tconn->int_dig_in);
-	kfree(mdev->tconn->int_dig_vv);
-	mdev->tconn->int_dig_out=int_dig_out;
-	mdev->tconn->int_dig_in=int_dig_in;
-	mdev->tconn->int_dig_vv=int_dig_vv;
-	retcode = _conn_request_state(mdev->tconn, NS(conn, C_UNCONNECTED), CS_VERBOSE);
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	kfree(tconn->int_dig_out);
+	kfree(tconn->int_dig_in);
+	kfree(tconn->int_dig_vv);
+	tconn->int_dig_out=int_dig_out;
+	tconn->int_dig_in=int_dig_in;
+	tconn->int_dig_vv=int_dig_vv;
+	retcode = _conn_request_state(tconn, NS(conn, C_UNCONNECTED), CS_VERBOSE);
+	spin_unlock_irq(&tconn->req_lock);
 
-	kobject_uevent(&disk_to_dev(mdev->vdisk)->kobj, KOBJ_CHANGE);
+	idr_for_each_entry(&tconn->volumes, mdev, i) {
+		mdev->send_cnt = 0;
+		mdev->recv_cnt = 0;
+		kobject_uevent(&disk_to_dev(mdev->vdisk)->kobj, KOBJ_CHANGE);
+	}
 	reply->ret_code = retcode;
-	conn_reconfig_done(mdev->tconn);
+	conn_reconfig_done(tconn);
 	return 0;
 
 fail:
@@ -1541,14 +1543,13 @@ fail:
 	kfree(new_conf);
 
 	reply->ret_code = retcode;
-	conn_reconfig_done(mdev->tconn);
+	conn_reconfig_done(tconn);
 	return 0;
 }
 
-static int drbd_nl_disconnect(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
+static int drbd_nl_disconnect(struct drbd_tconn *tconn, struct drbd_nl_cfg_req *nlp,
 			      struct drbd_nl_cfg_reply *reply)
 {
-	struct drbd_tconn *tconn = mdev->tconn;
 	int retcode;
 	struct disconnect dc;
 
@@ -1600,7 +1601,6 @@ static int drbd_nl_disconnect(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nl
  done:
 	retcode = NO_ERROR;
  fail:
-	drbd_md_sync(mdev);
 	reply->ret_code = retcode;
 	return 0;
 }
@@ -2211,8 +2211,8 @@ static struct cn_handler_struct cnd_table[] = {
 	[ P_secondary ]		= { CHT_MINOR, { &drbd_nl_secondary },	0 },
 	[ P_disk_conf ]		= { CHT_MINOR, { &drbd_nl_disk_conf },	0 },
 	[ P_detach ]		= { CHT_MINOR, { &drbd_nl_detach },	0 },
-	[ P_net_conf ]		= { CHT_MINOR, { &drbd_nl_net_conf },	0 },
-	[ P_disconnect ]	= { CHT_MINOR, { &drbd_nl_disconnect },	0 },
+	[ P_net_conf ]		= { CHT_CONN,  { .conn_based = &drbd_nl_net_conf },	0 },
+	[ P_disconnect ]	= { CHT_CONN,  { .conn_based = &drbd_nl_disconnect },	0 },
 	[ P_resize ]		= { CHT_MINOR, { &drbd_nl_resize },	0 },
 	[ P_syncer_conf ]	= { CHT_MINOR, { &drbd_nl_syncer_conf },0 },
 	[ P_invalidate ]	= { CHT_MINOR, { &drbd_nl_invalidate },	0 },
-- 
1.7.4.1

