Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934307Ab1JEJj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:39:57 -0400
Received: from mail09.linbit.com ([212.69.161.110]:56236 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934208Ab1JEJiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:38:10 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 11/16] drbd: Allow to change data-integrity-alg on the fly
Date: Wed,  5 Oct 2011 11:37:59 +0200
Message-Id: <1317807484-24628-12-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317807484-24628-1-git-send-email-philipp.reisner@linbit.com>
References: <1317807484-24628-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

The main purpose of this is to allow to turn data integrity checking on
and off on demand without causing interruptions.

Implemented by allocating tconn->peer_integrity_tfm only when receiving
a P_PROTOCOL message.  l accesses to tconn->peer_integrity_tf happen in
worker context, and no further synchronization is necessary.

On the sender side, tconn->integrity_tfm is modified under
tconn->data.mutex, and a P_PROTOCOL message is sent whenever.  All
accesses to tconn->integrity_tfm already happen under this mutex.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c     |    4 +-
 drivers/block/drbd/drbd_nl.c       |   22 ++++++++------
 drivers/block/drbd/drbd_receiver.c |   54 +++++++++++++++++------------------
 3 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index bcdd66d..1ea12d4 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1433,8 +1433,8 @@ static int _drbd_send_ack(struct drbd_conf *mdev, enum drbd_packet cmd,
 void drbd_send_ack_dp(struct drbd_conf *mdev, enum drbd_packet cmd,
 		      struct p_data *dp, int data_size)
 {
-	data_size -= (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->peer_integrity_tfm) ?
-		crypto_hash_digestsize(mdev->tconn->peer_integrity_tfm) : 0;
+	if (mdev->tconn->peer_integrity_tfm)
+		data_size -= crypto_hash_digestsize(mdev->tconn->peer_integrity_tfm);
 	_drbd_send_ack(mdev, cmd, dp->sector, cpu_to_be32(data_size),
 		       dp->block_id);
 }
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index fd97ffb..0bf74b1 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1824,7 +1824,6 @@ struct crypto {
 	struct crypto_hash *csums_tfm;
 	struct crypto_hash *cram_hmac_tfm;
 	struct crypto_hash *integrity_tfm;
-	struct crypto_hash *peer_integrity_tfm;
 	void *int_dig_in;
 	void *int_dig_vv;
 };
@@ -1863,10 +1862,6 @@ alloc_crypto(struct crypto *crypto, struct net_conf *new_conf)
 		       ERR_INTEGRITY_ALG);
 	if (rv != NO_ERROR)
 		return rv;
-	rv = alloc_hash(&crypto->peer_integrity_tfm, new_conf->integrity_alg,
-		       ERR_INTEGRITY_ALG);
-	if (rv != NO_ERROR)
-		return rv;
 	if (new_conf->cram_hmac_alg[0] != 0) {
 		snprintf(hmac_name, CRYPTO_MAX_ALG_NAME, "hmac(%s)",
 			 new_conf->cram_hmac_alg);
@@ -1893,7 +1888,6 @@ static void free_crypto(struct crypto *crypto)
 	kfree(crypto->int_dig_vv);
 	crypto_free_hash(crypto->cram_hmac_tfm);
 	crypto_free_hash(crypto->integrity_tfm);
-	crypto_free_hash(crypto->peer_integrity_tfm);
 	crypto_free_hash(crypto->csums_tfm);
 	crypto_free_hash(crypto->verify_tfm);
 }
@@ -1907,6 +1901,7 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 	int ovr; /* online verify running */
 	int rsr; /* re-sync running */
 	struct crypto crypto = { };
+	bool change_integrity_alg;
 
 	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_CONN);
 	if (!adm_ctx.reply_skb)
@@ -1938,6 +1933,7 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 
 	conn_reconfig_start(tconn);
 
+	mutex_lock(&tconn->data.mutex);
 	mutex_lock(&tconn->net_conf_update);
 	old_conf = tconn->net_conf;
 
@@ -1976,6 +1972,9 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
+	change_integrity_alg = strcmp(old_conf->integrity_alg,
+				      new_conf->integrity_alg);
+
 	retcode = alloc_crypto(&crypto, new_conf);
 	if (retcode != NO_ERROR)
 		goto fail;
@@ -1993,21 +1992,24 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 		crypto.verify_tfm = NULL;
 	}
 
-	/* FIXME can not assign these so bluntly while we have ongoing IO */
 	kfree(tconn->int_dig_in);
 	tconn->int_dig_in = crypto.int_dig_in;
 	kfree(tconn->int_dig_vv);
 	tconn->int_dig_vv = crypto.int_dig_vv;
 	crypto_free_hash(tconn->integrity_tfm);
 	tconn->integrity_tfm = crypto.integrity_tfm;
-	crypto_free_hash(tconn->peer_integrity_tfm);
-	tconn->peer_integrity_tfm = crypto.peer_integrity_tfm;
+	if (change_integrity_alg) {
+		/* Do this without trying to take tconn->data.mutex again.  */
+		if (__drbd_send_protocol(tconn))
+			goto fail;
+	}
 
 	/* FIXME Changing cram_hmac while the connection is established is useless */
 	crypto_free_hash(tconn->cram_hmac_tfm);
 	tconn->cram_hmac_tfm = crypto.cram_hmac_tfm;
 
 	mutex_unlock(&tconn->net_conf_update);
+	mutex_unlock(&tconn->data.mutex);
 	synchronize_rcu();
 	kfree(old_conf);
 
@@ -2018,6 +2020,7 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 
  fail:
 	mutex_unlock(&tconn->net_conf_update);
+	mutex_unlock(&tconn->data.mutex);
 	free_crypto(&crypto);
 	kfree(new_conf);
  done:
@@ -2126,7 +2129,6 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	tconn->int_dig_vv = crypto.int_dig_vv;
 	tconn->cram_hmac_tfm = crypto.cram_hmac_tfm;
 	tconn->integrity_tfm = crypto.integrity_tfm;
-	tconn->peer_integrity_tfm = crypto.peer_integrity_tfm;
 	tconn->csums_tfm = crypto.csums_tfm;
 	tconn->verify_tfm = crypto.verify_tfm;
 
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 30b6556..9c8bcce 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1384,10 +1384,9 @@ read_in_block(struct drbd_conf *mdev, u64 id, sector_t sector,
 	void *dig_vv = mdev->tconn->int_dig_vv;
 	unsigned long *data;
 
-	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->peer_integrity_tfm) ?
-		crypto_hash_digestsize(mdev->tconn->peer_integrity_tfm) : 0;
-
-	if (dgs) {
+	dgs = 0;
+	if (mdev->tconn->peer_integrity_tfm) {
+		dgs = crypto_hash_digestsize(mdev->tconn->peer_integrity_tfm);
 		/*
 		 * FIXME: Receive the incoming digest into the receive buffer
 		 *	  here, together with its struct p_data?
@@ -1395,10 +1394,9 @@ read_in_block(struct drbd_conf *mdev, u64 id, sector_t sector,
 		err = drbd_recv_all_warn(mdev->tconn, dig_in, dgs);
 		if (err)
 			return NULL;
+		data_size -= dgs;
 	}
 
-	data_size -= dgs;
-
 	if (!expect(data_size != 0))
 		return NULL;
 	if (!expect(IS_ALIGNED(data_size, 512)))
@@ -1491,17 +1489,15 @@ static int recv_dless_read(struct drbd_conf *mdev, struct drbd_request *req,
 	void *dig_in = mdev->tconn->int_dig_in;
 	void *dig_vv = mdev->tconn->int_dig_vv;
 
-	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->peer_integrity_tfm) ?
-		crypto_hash_digestsize(mdev->tconn->peer_integrity_tfm) : 0;
-
-	if (dgs) {
+	dgs = 0;
+	if (mdev->tconn->peer_integrity_tfm) {
+		dgs = crypto_hash_digestsize(mdev->tconn->peer_integrity_tfm);
 		err = drbd_recv_all_warn(mdev->tconn, dig_in, dgs);
 		if (err)
 			return err;
+		data_size -= dgs;
 	}
 
-	data_size -= dgs;
-
 	/* optimistically update recv_cnt.  if receiving fails below,
 	 * we disconnect anyways, and counters will be reset. */
 	mdev->recv_cnt += data_size>>9;
@@ -2997,7 +2993,6 @@ static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 	struct p_protocol *p = pi->data;
 	int p_proto, p_after_sb_0p, p_after_sb_1p, p_after_sb_2p;
 	int p_want_lose, p_two_primaries, cf;
-	char p_integrity_alg[SHARED_SECRET_MAX] = "";
 	struct net_conf *nc;
 
 	p_proto		= be32_to_cpu(p->protocol);
@@ -3009,15 +3004,30 @@ static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 	p_want_lose = cf & CF_WANT_LOSE;
 
 	if (tconn->agreed_pro_version >= 87) {
+		char integrity_alg[SHARED_SECRET_MAX];
+		struct crypto_hash *tfm = NULL;
 		int err;
 
-		if (pi->size > sizeof(p_integrity_alg))
+		if (pi->size > sizeof(integrity_alg))
 			return -EIO;
-		err = drbd_recv_all(tconn, p_integrity_alg, pi->size);
+		err = drbd_recv_all(tconn, integrity_alg, pi->size);
 		if (err)
 			return err;
+		integrity_alg[SHARED_SECRET_MAX-1] = 0;
 
-		p_integrity_alg[SHARED_SECRET_MAX-1] = 0;
+		if (integrity_alg[0]) {
+			tfm = crypto_alloc_hash(integrity_alg, 0, CRYPTO_ALG_ASYNC);
+			if (!tfm) {
+				conn_err(tconn, "peer data-integrity-alg %s not supported\n",
+					 integrity_alg);
+				goto disconnect;
+			}
+			conn_info(tconn, "peer data-integrity-alg: %s\n", integrity_alg);
+		}
+
+		if (tconn->peer_integrity_tfm)
+			crypto_free_hash(tconn->peer_integrity_tfm);
+		tconn->peer_integrity_tfm = tfm;
 	}
 
 	clear_bit(CONN_DRY_RUN, &tconn->flags);
@@ -3058,20 +3068,8 @@ static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 		goto disconnect_rcu_unlock;
 	}
 
-	if (tconn->agreed_pro_version >= 87) {
-		if (strcmp(p_integrity_alg, nc->integrity_alg)) {
-			conn_err(tconn, "incompatible setting of the data-integrity-alg\n");
-			goto disconnect;
-		}
-	}
-
 	rcu_read_unlock();
 
-	if (tconn->agreed_pro_version >= 87) {
-		conn_info(tconn, "data-integrity-alg: %s\n",
-			  nc->integrity_alg[0] ? nc->integrity_alg : (unsigned char *)"<not-used>");
-	}
-
 	return 0;
 
 disconnect_rcu_unlock:
-- 
1.7.4.1

