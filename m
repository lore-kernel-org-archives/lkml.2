Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373Ab1JFNiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 09:38:09 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34101 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab1JFNiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 09:38:05 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 02/15] drbd: Renamed the net_conf_update mutex to conf_update
Date: Thu,  6 Oct 2011 15:37:47 +0200
Message-Id: <1317908280-28951-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317908280-28951-1-git-send-email-philipp.reisner@linbit.com>
References: <1317908280-28951-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparing to use the same mutex for disk_conf updates

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    2 +-
 drivers/block/drbd/drbd_main.c     |    2 +-
 drivers/block/drbd/drbd_nl.c       |   16 ++++++++--------
 drivers/block/drbd/drbd_receiver.c |   10 +++++-----
 drivers/block/drbd/drbd_state.c    |    4 ++--
 5 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 8655fcb..0311dfd 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -832,7 +832,7 @@ struct drbd_tconn {			/* is a resource from the config file */
 
 	unsigned long flags;
 	struct net_conf *net_conf;	/* content protected by rcu */
-	struct mutex net_conf_update;	/* mutex for ready-copy-update of net_conf */
+	struct mutex conf_update;	/* mutex for ready-copy-update of net_conf and disk_conf */
 	wait_queue_head_t ping_wait;	/* Woken upon reception of a ping, and a state change */
 	struct res_opts res_opts;
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index cd08136..352c36f 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2474,7 +2474,7 @@ struct drbd_tconn *conn_create(const char *name)
 	tconn->cstate = C_STANDALONE;
 	mutex_init(&tconn->cstate_mutex);
 	spin_lock_init(&tconn->req_lock);
-	mutex_init(&tconn->net_conf_update);
+	mutex_init(&tconn->conf_update);
 	init_waitqueue_head(&tconn->ping_wait);
 	idr_init(&tconn->volumes);
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 13230d9..6317ae5 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -619,11 +619,11 @@ drbd_set_role(struct drbd_conf *mdev, enum drbd_role new_role, int force)
 			put_ldev(mdev);
 		}
 	} else {
-		mutex_lock(&mdev->tconn->net_conf_update);
+		mutex_lock(&mdev->tconn->conf_update);
 		nc = mdev->tconn->net_conf;
 		if (nc)
 			nc->want_lose = 0; /* without copy; single bit op is atomic */
-		mutex_unlock(&mdev->tconn->net_conf_update);
+		mutex_unlock(&mdev->tconn->conf_update);
 
 		set_disk_ro(mdev->vdisk, false);
 		if (get_ldev(mdev)) {
@@ -1874,7 +1874,7 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 	conn_reconfig_start(tconn);
 
 	mutex_lock(&tconn->data.mutex);
-	mutex_lock(&tconn->net_conf_update);
+	mutex_lock(&tconn->conf_update);
 	old_conf = tconn->net_conf;
 
 	if (!old_conf) {
@@ -1948,7 +1948,7 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 	crypto_free_hash(tconn->cram_hmac_tfm);
 	tconn->cram_hmac_tfm = crypto.cram_hmac_tfm;
 
-	mutex_unlock(&tconn->net_conf_update);
+	mutex_unlock(&tconn->conf_update);
 	mutex_unlock(&tconn->data.mutex);
 	synchronize_rcu();
 	kfree(old_conf);
@@ -1959,7 +1959,7 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 	goto done;
 
  fail:
-	mutex_unlock(&tconn->net_conf_update);
+	mutex_unlock(&tconn->conf_update);
 	mutex_unlock(&tconn->data.mutex);
 	free_crypto(&crypto);
 	kfree(new_conf);
@@ -2055,11 +2055,11 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 
 	conn_flush_workqueue(tconn);
 
-	mutex_lock(&tconn->net_conf_update);
+	mutex_lock(&tconn->conf_update);
 	old_conf = tconn->net_conf;
 	if (old_conf) {
 		retcode = ERR_NET_CONFIGURED;
-		mutex_unlock(&tconn->net_conf_update);
+		mutex_unlock(&tconn->conf_update);
 		goto fail;
 	}
 	rcu_assign_pointer(tconn->net_conf, new_conf);
@@ -2072,7 +2072,7 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	tconn->csums_tfm = crypto.csums_tfm;
 	tconn->verify_tfm = crypto.verify_tfm;
 
-	mutex_unlock(&tconn->net_conf_update);
+	mutex_unlock(&tconn->conf_update);
 
 	rcu_read_lock();
 	idr_for_each_entry(&tconn->volumes, mdev, i) {
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 956cdda..567d64b 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3221,7 +3221,7 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 			p->csums_alg[SHARED_SECRET_MAX-1] = 0;
 		}
 
-		mutex_lock(&mdev->tconn->net_conf_update);
+		mutex_lock(&mdev->tconn->conf_update);
 		old_conf = mdev->tconn->net_conf;
 
 		if (strcmp(old_conf->verify_alg, p->verify_alg)) {
@@ -3296,7 +3296,7 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 			}
 			rcu_assign_pointer(tconn->net_conf, new_conf);
 		}
-		mutex_unlock(&mdev->tconn->net_conf_update);
+		mutex_unlock(&mdev->tconn->conf_update);
 		if (new_conf) {
 			synchronize_rcu();
 			kfree(old_conf);
@@ -3314,7 +3314,7 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 	return 0;
 
 disconnect:
-	mutex_unlock(&mdev->tconn->net_conf_update);
+	mutex_unlock(&mdev->tconn->conf_update);
 	/* just for completeness: actually not needed,
 	 * as this is not reached if csums_tfm was ok. */
 	crypto_free_hash(csums_tfm);
@@ -3744,9 +3744,9 @@ static int receive_state(struct drbd_tconn *tconn, struct packet_info *pi)
 		}
 	}
 
-	mutex_lock(&mdev->tconn->net_conf_update);
+	mutex_lock(&mdev->tconn->conf_update);
 	mdev->tconn->net_conf->want_lose = 0; /* without copy; single bit op is atomic */
-	mutex_unlock(&mdev->tconn->net_conf_update);
+	mutex_unlock(&mdev->tconn->conf_update);
 
 	drbd_md_sync(mdev); /* update connected indicator, la_size, ... */
 
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 327a75e..befaf07 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1392,11 +1392,11 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 	if (oc == C_DISCONNECTING && ns_max.conn == C_STANDALONE) {
 		struct net_conf *old_conf;
 
-		mutex_lock(&tconn->net_conf_update);
+		mutex_lock(&tconn->conf_update);
 		old_conf = tconn->net_conf;
 		rcu_assign_pointer(tconn->net_conf, NULL);
 		conn_free_crypto(tconn);
-		mutex_unlock(&tconn->net_conf_update);
+		mutex_unlock(&tconn->conf_update);
 
 		synchronize_rcu();
 		kfree(old_conf);
-- 
1.7.4.1

