Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934236Ab1JEJiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:38:13 -0400
Received: from mail09.linbit.com ([212.69.161.110]:56200 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933583Ab1JEJiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:38:07 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 01/16] drbd: Consider all crypto options in connect and in net-options
Date: Wed,  5 Oct 2011 11:37:49 +0200
Message-Id: <1317807484-24628-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317807484-24628-1-git-send-email-philipp.reisner@linbit.com>
References: <1317807484-24628-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So for this was simply not considered after the options have been
re-arranged.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |  230 ++++++++++++++++++++++--------------------
 1 files changed, 121 insertions(+), 109 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index caa32e2..b9e8456 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1758,6 +1758,88 @@ check_net_options(struct drbd_tconn *tconn, struct net_conf *new_conf)
 	return rv;
 }
 
+struct crypto {
+	struct crypto_hash *verify_tfm;
+	struct crypto_hash *csums_tfm;
+	struct crypto_hash *cram_hmac_tfm;
+	struct crypto_hash *integrity_w_tfm;
+	struct crypto_hash *integrity_r_tfm;
+	void *int_dig_in;
+	void *int_dig_vv;
+};
+
+static int
+alloc_tfm(struct crypto_hash **tfm, char *tfm_name, int err_alg, int err_nd)
+{
+	if (!tfm_name[0])
+		return NO_ERROR;
+
+	*tfm = crypto_alloc_hash(tfm_name, 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(*tfm)) {
+		*tfm = NULL;
+		return err_alg;
+	}
+
+	if (!drbd_crypto_is_hash(crypto_hash_tfm(*tfm)))
+		return err_nd;
+
+	return NO_ERROR;
+}
+
+static enum drbd_ret_code
+alloc_crypto(struct crypto *crypto, struct net_conf *new_conf)
+{
+	char hmac_name[CRYPTO_MAX_ALG_NAME];
+	enum drbd_ret_code rv;
+	int hash_size;
+
+	rv = alloc_tfm(&crypto->csums_tfm, new_conf->csums_alg,
+		       ERR_CSUMS_ALG, ERR_CSUMS_ALG_ND);
+	if (rv != NO_ERROR)
+		return rv;
+	rv = alloc_tfm(&crypto->verify_tfm, new_conf->verify_alg,
+		       ERR_VERIFY_ALG, ERR_VERIFY_ALG_ND);
+	if (rv != NO_ERROR)
+		return rv;
+	rv = alloc_tfm(&crypto->integrity_w_tfm, new_conf->integrity_alg,
+		       ERR_INTEGRITY_ALG, ERR_INTEGRITY_ALG_ND);
+	if (rv != NO_ERROR)
+		return rv;
+	rv = alloc_tfm(&crypto->integrity_r_tfm, new_conf->integrity_alg,
+		       ERR_INTEGRITY_ALG, ERR_INTEGRITY_ALG_ND);
+	if (rv != NO_ERROR)
+		return rv;
+	if (new_conf->cram_hmac_alg[0] != 0) {
+		snprintf(hmac_name, CRYPTO_MAX_ALG_NAME, "hmac(%s)",
+			 new_conf->cram_hmac_alg);
+
+		rv = alloc_tfm(&crypto->cram_hmac_tfm, hmac_name,
+			       ERR_AUTH_ALG, ERR_AUTH_ALG_ND);
+	}
+	if (crypto->integrity_w_tfm) {
+		hash_size = crypto_hash_digestsize(crypto->integrity_w_tfm);
+		crypto->int_dig_in = kmalloc(hash_size, GFP_KERNEL);
+		if (!crypto->int_dig_in)
+			return ERR_NOMEM;
+		crypto->int_dig_vv = kmalloc(hash_size, GFP_KERNEL);
+		if (!crypto->int_dig_vv)
+			return ERR_NOMEM;
+	}
+
+	return rv;
+}
+
+static void free_crypto(struct crypto *crypto)
+{
+	kfree(crypto->int_dig_in);
+	kfree(crypto->int_dig_vv);
+	crypto_free_hash(crypto->cram_hmac_tfm);
+	crypto_free_hash(crypto->integrity_w_tfm);
+	crypto_free_hash(crypto->integrity_r_tfm);
+	crypto_free_hash(crypto->csums_tfm);
+	crypto_free_hash(crypto->verify_tfm);
+}
+
 int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 {
 	enum drbd_ret_code retcode;
@@ -1766,9 +1848,7 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 	int err;
 	int ovr; /* online verify running */
 	int rsr; /* re-sync running */
-	struct crypto_hash *verify_tfm = NULL;
-	struct crypto_hash *csums_tfm = NULL;
-
+	struct crypto crypto = { };
 
 	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_CONN);
 	if (!adm_ctx.reply_skb)
@@ -1824,61 +1904,49 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 
 	/* re-sync running */
 	rsr = conn_resync_running(tconn);
-	if (rsr && old_conf && strcmp(new_conf->csums_alg, old_conf->csums_alg)) {
+	if (rsr && strcmp(new_conf->csums_alg, old_conf->csums_alg)) {
 		retcode = ERR_CSUMS_RESYNC_RUNNING;
 		goto fail;
 	}
 
-	if (!rsr && new_conf->csums_alg[0]) {
-		csums_tfm = crypto_alloc_hash(new_conf->csums_alg, 0, CRYPTO_ALG_ASYNC);
-		if (IS_ERR(csums_tfm)) {
-			csums_tfm = NULL;
-			retcode = ERR_CSUMS_ALG;
-			goto fail;
-		}
-
-		if (!drbd_crypto_is_hash(crypto_hash_tfm(csums_tfm))) {
-			retcode = ERR_CSUMS_ALG_ND;
-			goto fail;
-		}
-	}
-
 	/* online verify running */
 	ovr = conn_ov_running(tconn);
-	if (ovr) {
-		if (strcmp(new_conf->verify_alg, old_conf->verify_alg)) {
-			retcode = ERR_VERIFY_RUNNING;
-			goto fail;
-		}
+	if (ovr && strcmp(new_conf->verify_alg, old_conf->verify_alg)) {
+		retcode = ERR_VERIFY_RUNNING;
+		goto fail;
 	}
 
-	if (!ovr && new_conf->verify_alg[0]) {
-		verify_tfm = crypto_alloc_hash(new_conf->verify_alg, 0, CRYPTO_ALG_ASYNC);
-		if (IS_ERR(verify_tfm)) {
-			verify_tfm = NULL;
-			retcode = ERR_VERIFY_ALG;
-			goto fail;
-		}
-
-		if (!drbd_crypto_is_hash(crypto_hash_tfm(verify_tfm))) {
-			retcode = ERR_VERIFY_ALG_ND;
-			goto fail;
-		}
-	}
+	retcode = alloc_crypto(&crypto, new_conf);
+	if (retcode != NO_ERROR)
+		goto fail;
 
 	rcu_assign_pointer(tconn->net_conf, new_conf);
 
 	if (!rsr) {
 		crypto_free_hash(tconn->csums_tfm);
-		tconn->csums_tfm = csums_tfm;
-		csums_tfm = NULL;
+		tconn->csums_tfm = crypto.csums_tfm;
+		crypto.csums_tfm = NULL;
 	}
 	if (!ovr) {
 		crypto_free_hash(tconn->verify_tfm);
-		tconn->verify_tfm = verify_tfm;
-		verify_tfm = NULL;
+		tconn->verify_tfm = crypto.verify_tfm;
+		crypto.verify_tfm = NULL;
 	}
 
+	/* FIXME can not assign these so bluntly while we have ongoing IO */
+	kfree(tconn->int_dig_in);
+	tconn->int_dig_in = crypto.int_dig_in;
+	kfree(tconn->int_dig_vv);
+	tconn->int_dig_vv = crypto.int_dig_vv;
+	crypto_free_hash(tconn->integrity_w_tfm);
+	tconn->integrity_w_tfm = crypto.integrity_w_tfm;
+	crypto_free_hash(tconn->integrity_r_tfm);
+	tconn->integrity_r_tfm = crypto.integrity_r_tfm;
+
+	/* FIXME Changing cram_hmac while the connection is established is useless */
+	crypto_free_hash(tconn->cram_hmac_tfm);
+	tconn->cram_hmac_tfm = crypto.cram_hmac_tfm;
+
 	mutex_unlock(&tconn->net_conf_update);
 	synchronize_rcu();
 	kfree(old_conf);
@@ -1890,8 +1958,7 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 
  fail:
 	mutex_unlock(&tconn->net_conf_update);
-	crypto_free_hash(csums_tfm);
-	crypto_free_hash(verify_tfm);
+	free_crypto(&crypto);
 	kfree(new_conf);
  done:
 	conn_reconfig_done(tconn);
@@ -1902,14 +1969,9 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 
 int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 {
-	char hmac_name[CRYPTO_MAX_ALG_NAME];
 	struct drbd_conf *mdev;
 	struct net_conf *old_conf, *new_conf = NULL;
-	struct crypto_hash *tfm = NULL;
-	struct crypto_hash *integrity_w_tfm = NULL;
-	struct crypto_hash *integrity_r_tfm = NULL;
-	void *int_dig_in = NULL;
-	void *int_dig_vv = NULL;
+	struct crypto crypto = { };
 	struct drbd_tconn *oconn;
 	struct drbd_tconn *tconn;
 	struct sockaddr *new_my_addr, *new_peer_addr, *taken_addr;
@@ -2014,60 +2076,12 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 			goto fail;
 	}
 
-	if (new_conf->cram_hmac_alg[0] != 0) {
-		snprintf(hmac_name, CRYPTO_MAX_ALG_NAME, "hmac(%s)",
-			new_conf->cram_hmac_alg);
-		tfm = crypto_alloc_hash(hmac_name, 0, CRYPTO_ALG_ASYNC);
-		if (IS_ERR(tfm)) {
-			tfm = NULL;
-			retcode = ERR_AUTH_ALG;
-			goto fail;
-		}
-
-		if (!drbd_crypto_is_hash(crypto_hash_tfm(tfm))) {
-			retcode = ERR_AUTH_ALG_ND;
-			goto fail;
-		}
-	}
-
-	if (new_conf->integrity_alg[0]) {
-		integrity_w_tfm = crypto_alloc_hash(new_conf->integrity_alg, 0, CRYPTO_ALG_ASYNC);
-		if (IS_ERR(integrity_w_tfm)) {
-			integrity_w_tfm = NULL;
-			retcode=ERR_INTEGRITY_ALG;
-			goto fail;
-		}
-
-		if (!drbd_crypto_is_hash(crypto_hash_tfm(integrity_w_tfm))) {
-			retcode=ERR_INTEGRITY_ALG_ND;
-			goto fail;
-		}
-
-		integrity_r_tfm = crypto_alloc_hash(new_conf->integrity_alg, 0, CRYPTO_ALG_ASYNC);
-		if (IS_ERR(integrity_r_tfm)) {
-			integrity_r_tfm = NULL;
-			retcode=ERR_INTEGRITY_ALG;
-			goto fail;
-		}
-	}
+	retcode = alloc_crypto(&crypto, new_conf);
+	if (retcode != NO_ERROR)
+		goto fail;
 
 	((char *)new_conf->shared_secret)[SHARED_SECRET_MAX-1] = 0;
 
-	/* allocation not in the IO path, cqueue thread context */
-	if (integrity_w_tfm) {
-		i = crypto_hash_digestsize(integrity_w_tfm);
-		int_dig_in = kmalloc(i, GFP_KERNEL);
-		if (!int_dig_in) {
-			retcode = ERR_NOMEM;
-			goto fail;
-		}
-		int_dig_vv = kmalloc(i, GFP_KERNEL);
-		if (!int_dig_vv) {
-			retcode = ERR_NOMEM;
-			goto fail;
-		}
-	}
-
 	conn_flush_workqueue(tconn);
 
 	mutex_lock(&tconn->net_conf_update);
@@ -2080,11 +2094,13 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	rcu_assign_pointer(tconn->net_conf, new_conf);
 
 	conn_free_crypto(tconn);
-	tconn->cram_hmac_tfm = tfm;
-	tconn->integrity_w_tfm = integrity_w_tfm;
-	tconn->integrity_r_tfm = integrity_r_tfm;
-	tconn->int_dig_in = int_dig_in;
-	tconn->int_dig_vv = int_dig_vv;
+	tconn->int_dig_in = crypto.int_dig_in;
+	tconn->int_dig_vv = crypto.int_dig_vv;
+	tconn->cram_hmac_tfm = crypto.cram_hmac_tfm;
+	tconn->integrity_w_tfm = crypto.integrity_w_tfm;
+	tconn->integrity_r_tfm = crypto.integrity_r_tfm;
+	tconn->csums_tfm = crypto.csums_tfm;
+	tconn->verify_tfm = crypto.verify_tfm;
 
 	mutex_unlock(&tconn->net_conf_update);
 
@@ -2102,11 +2118,7 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 
 fail:
-	kfree(int_dig_in);
-	kfree(int_dig_vv);
-	crypto_free_hash(tfm);
-	crypto_free_hash(integrity_w_tfm);
-	crypto_free_hash(integrity_r_tfm);
+	free_crypto(&crypto);
 	kfree(new_conf);
 
 	conn_reconfig_done(tconn);
-- 
1.7.4.1

