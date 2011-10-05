Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934274Ab1JEJkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:40:52 -0400
Received: from mail09.linbit.com ([212.69.161.110]:56221 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934190Ab1JEJiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:38:09 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 07/16] drbd: Rename integrity_w_tfm -> integrity_tfm
Date: Wed,  5 Oct 2011 11:37:55 +0200
Message-Id: <1317807484-24628-8-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317807484-24628-1-git-send-email-philipp.reisner@linbit.com>
References: <1317807484-24628-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    2 +-
 drivers/block/drbd/drbd_main.c |   18 +++++++++---------
 drivers/block/drbd/drbd_nl.c   |   16 ++++++++--------
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index e90bc9f..4787c790 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -849,7 +849,7 @@ struct drbd_tconn {			/* is a resource from the config file */
 	struct list_head out_of_sequence_requests;
 
 	struct crypto_hash *cram_hmac_tfm;
-	struct crypto_hash *integrity_w_tfm; /* to be used by the worker thread */
+	struct crypto_hash *integrity_tfm;  /* checksums we compute */
 	struct crypto_hash *integrity_r_tfm; /* to be used by the receiver thread */
 	struct crypto_hash *csums_tfm;
 	struct crypto_hash *verify_tfm;
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index c5134c8..30dd8a9 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1689,8 +1689,8 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 	int dgs;
 	int err;
 
-	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->integrity_w_tfm) ?
-		crypto_hash_digestsize(mdev->tconn->integrity_w_tfm) : 0;
+	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->integrity_tfm) ?
+		crypto_hash_digestsize(mdev->tconn->integrity_tfm) : 0;
 
 	sock = &mdev->tconn->data;
 	p = drbd_prepare_command(mdev, sock);
@@ -1711,7 +1711,7 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 	}
 	p->dp_flags = cpu_to_be32(dp_flags);
 	if (dgs)
-		drbd_csum_bio(mdev, mdev->tconn->integrity_w_tfm, req->master_bio, p + 1);
+		drbd_csum_bio(mdev, mdev->tconn->integrity_tfm, req->master_bio, p + 1);
 	err = __send_command(mdev->tconn, mdev->vnr, sock, P_DATA, sizeof(*p) + dgs, NULL, req->i.size);
 	if (!err) {
 		/* For protocol A, we have to memcpy the payload into
@@ -1735,7 +1735,7 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 			/* 64 byte, 512 bit, is the largest digest size
 			 * currently supported in kernel crypto. */
 			unsigned char digest[64];
-			drbd_csum_bio(mdev, mdev->tconn->integrity_w_tfm, req->master_bio, digest);
+			drbd_csum_bio(mdev, mdev->tconn->integrity_tfm, req->master_bio, digest);
 			if (memcmp(p + 1, digest, dgs)) {
 				dev_warn(DEV,
 					"Digest mismatch, buffer modified by upper layers during write: %llus +%u\n",
@@ -1762,8 +1762,8 @@ int drbd_send_block(struct drbd_conf *mdev, enum drbd_packet cmd,
 	int err;
 	int dgs;
 
-	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->integrity_w_tfm) ?
-		crypto_hash_digestsize(mdev->tconn->integrity_w_tfm) : 0;
+	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->integrity_tfm) ?
+		crypto_hash_digestsize(mdev->tconn->integrity_tfm) : 0;
 
 	sock = &mdev->tconn->data;
 	p = drbd_prepare_command(mdev, sock);
@@ -1773,7 +1773,7 @@ int drbd_send_block(struct drbd_conf *mdev, enum drbd_packet cmd,
 	p->block_id = peer_req->block_id;
 	p->seq_num = 0;  /* unused */
 	if (dgs)
-		drbd_csum_ee(mdev, mdev->tconn->integrity_w_tfm, peer_req, p + 1);
+		drbd_csum_ee(mdev, mdev->tconn->integrity_tfm, peer_req, p + 1);
 	err = __send_command(mdev->tconn, mdev->vnr, sock, cmd, sizeof(*p) + dgs, NULL, peer_req->i.size);
 	if (!err)
 		err = _drbd_send_zc_ee(mdev, peer_req);
@@ -2406,7 +2406,7 @@ void conn_free_crypto(struct drbd_tconn *tconn)
 	crypto_free_hash(tconn->csums_tfm);
 	crypto_free_hash(tconn->verify_tfm);
 	crypto_free_hash(tconn->cram_hmac_tfm);
-	crypto_free_hash(tconn->integrity_w_tfm);
+	crypto_free_hash(tconn->integrity_tfm);
 	crypto_free_hash(tconn->integrity_r_tfm);
 	kfree(tconn->int_dig_in);
 	kfree(tconn->int_dig_vv);
@@ -2414,7 +2414,7 @@ void conn_free_crypto(struct drbd_tconn *tconn)
 	tconn->csums_tfm = NULL;
 	tconn->verify_tfm = NULL;
 	tconn->cram_hmac_tfm = NULL;
-	tconn->integrity_w_tfm = NULL;
+	tconn->integrity_tfm = NULL;
 	tconn->integrity_r_tfm = NULL;
 	tconn->int_dig_in = NULL;
 	tconn->int_dig_vv = NULL;
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index addd175..d24d96d 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1823,7 +1823,7 @@ struct crypto {
 	struct crypto_hash *verify_tfm;
 	struct crypto_hash *csums_tfm;
 	struct crypto_hash *cram_hmac_tfm;
-	struct crypto_hash *integrity_w_tfm;
+	struct crypto_hash *integrity_tfm;
 	struct crypto_hash *integrity_r_tfm;
 	void *int_dig_in;
 	void *int_dig_vv;
@@ -1862,7 +1862,7 @@ alloc_crypto(struct crypto *crypto, struct net_conf *new_conf)
 		       ERR_VERIFY_ALG, ERR_VERIFY_ALG_ND);
 	if (rv != NO_ERROR)
 		return rv;
-	rv = alloc_tfm(&crypto->integrity_w_tfm, new_conf->integrity_alg,
+	rv = alloc_tfm(&crypto->integrity_tfm, new_conf->integrity_alg,
 		       ERR_INTEGRITY_ALG, ERR_INTEGRITY_ALG_ND);
 	if (rv != NO_ERROR)
 		return rv;
@@ -1877,8 +1877,8 @@ alloc_crypto(struct crypto *crypto, struct net_conf *new_conf)
 		rv = alloc_tfm(&crypto->cram_hmac_tfm, hmac_name,
 			       ERR_AUTH_ALG, ERR_AUTH_ALG_ND);
 	}
-	if (crypto->integrity_w_tfm) {
-		hash_size = crypto_hash_digestsize(crypto->integrity_w_tfm);
+	if (crypto->integrity_tfm) {
+		hash_size = crypto_hash_digestsize(crypto->integrity_tfm);
 		crypto->int_dig_in = kmalloc(hash_size, GFP_KERNEL);
 		if (!crypto->int_dig_in)
 			return ERR_NOMEM;
@@ -1895,7 +1895,7 @@ static void free_crypto(struct crypto *crypto)
 	kfree(crypto->int_dig_in);
 	kfree(crypto->int_dig_vv);
 	crypto_free_hash(crypto->cram_hmac_tfm);
-	crypto_free_hash(crypto->integrity_w_tfm);
+	crypto_free_hash(crypto->integrity_tfm);
 	crypto_free_hash(crypto->integrity_r_tfm);
 	crypto_free_hash(crypto->csums_tfm);
 	crypto_free_hash(crypto->verify_tfm);
@@ -2001,8 +2001,8 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 	tconn->int_dig_in = crypto.int_dig_in;
 	kfree(tconn->int_dig_vv);
 	tconn->int_dig_vv = crypto.int_dig_vv;
-	crypto_free_hash(tconn->integrity_w_tfm);
-	tconn->integrity_w_tfm = crypto.integrity_w_tfm;
+	crypto_free_hash(tconn->integrity_tfm);
+	tconn->integrity_tfm = crypto.integrity_tfm;
 	crypto_free_hash(tconn->integrity_r_tfm);
 	tconn->integrity_r_tfm = crypto.integrity_r_tfm;
 
@@ -2128,7 +2128,7 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	tconn->int_dig_in = crypto.int_dig_in;
 	tconn->int_dig_vv = crypto.int_dig_vv;
 	tconn->cram_hmac_tfm = crypto.cram_hmac_tfm;
-	tconn->integrity_w_tfm = crypto.integrity_w_tfm;
+	tconn->integrity_tfm = crypto.integrity_tfm;
 	tconn->integrity_r_tfm = crypto.integrity_r_tfm;
 	tconn->csums_tfm = crypto.csums_tfm;
 	tconn->verify_tfm = crypto.verify_tfm;
-- 
1.7.4.1

