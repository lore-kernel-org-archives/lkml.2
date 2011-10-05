Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934239Ab1JEJkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:40:51 -0400
Received: from mail09.linbit.com ([212.69.161.110]:56222 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934192Ab1JEJiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:38:09 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 08/16] drbd: Rename integrity_r_tfm -> peer_integrity_tfm
Date: Wed,  5 Oct 2011 11:37:56 +0200
Message-Id: <1317807484-24628-9-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h      |    2 +-
 drivers/block/drbd/drbd_main.c     |    8 ++++----
 drivers/block/drbd/drbd_nl.c       |   12 ++++++------
 drivers/block/drbd/drbd_receiver.c |   12 ++++++------
 4 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 4787c790..e6e4f4e 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -850,7 +850,7 @@ struct drbd_tconn {			/* is a resource from the config file */
 
 	struct crypto_hash *cram_hmac_tfm;
 	struct crypto_hash *integrity_tfm;  /* checksums we compute */
-	struct crypto_hash *integrity_r_tfm; /* to be used by the receiver thread */
+	struct crypto_hash *peer_integrity_tfm;  /* checksums we verify */
 	struct crypto_hash *csums_tfm;
 	struct crypto_hash *verify_tfm;
 	void *int_dig_in;
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 30dd8a9..417c437 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1405,8 +1405,8 @@ static int _drbd_send_ack(struct drbd_conf *mdev, enum drbd_packet cmd,
 void drbd_send_ack_dp(struct drbd_conf *mdev, enum drbd_packet cmd,
 		      struct p_data *dp, int data_size)
 {
-	data_size -= (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->integrity_r_tfm) ?
-		crypto_hash_digestsize(mdev->tconn->integrity_r_tfm) : 0;
+	data_size -= (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->peer_integrity_tfm) ?
+		crypto_hash_digestsize(mdev->tconn->peer_integrity_tfm) : 0;
 	_drbd_send_ack(mdev, cmd, dp->sector, cpu_to_be32(data_size),
 		       dp->block_id);
 }
@@ -2407,7 +2407,7 @@ void conn_free_crypto(struct drbd_tconn *tconn)
 	crypto_free_hash(tconn->verify_tfm);
 	crypto_free_hash(tconn->cram_hmac_tfm);
 	crypto_free_hash(tconn->integrity_tfm);
-	crypto_free_hash(tconn->integrity_r_tfm);
+	crypto_free_hash(tconn->peer_integrity_tfm);
 	kfree(tconn->int_dig_in);
 	kfree(tconn->int_dig_vv);
 
@@ -2415,7 +2415,7 @@ void conn_free_crypto(struct drbd_tconn *tconn)
 	tconn->verify_tfm = NULL;
 	tconn->cram_hmac_tfm = NULL;
 	tconn->integrity_tfm = NULL;
-	tconn->integrity_r_tfm = NULL;
+	tconn->peer_integrity_tfm = NULL;
 	tconn->int_dig_in = NULL;
 	tconn->int_dig_vv = NULL;
 }
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index d24d96d..efae733 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1824,7 +1824,7 @@ struct crypto {
 	struct crypto_hash *csums_tfm;
 	struct crypto_hash *cram_hmac_tfm;
 	struct crypto_hash *integrity_tfm;
-	struct crypto_hash *integrity_r_tfm;
+	struct crypto_hash *peer_integrity_tfm;
 	void *int_dig_in;
 	void *int_dig_vv;
 };
@@ -1866,7 +1866,7 @@ alloc_crypto(struct crypto *crypto, struct net_conf *new_conf)
 		       ERR_INTEGRITY_ALG, ERR_INTEGRITY_ALG_ND);
 	if (rv != NO_ERROR)
 		return rv;
-	rv = alloc_tfm(&crypto->integrity_r_tfm, new_conf->integrity_alg,
+	rv = alloc_tfm(&crypto->peer_integrity_tfm, new_conf->integrity_alg,
 		       ERR_INTEGRITY_ALG, ERR_INTEGRITY_ALG_ND);
 	if (rv != NO_ERROR)
 		return rv;
@@ -1896,7 +1896,7 @@ static void free_crypto(struct crypto *crypto)
 	kfree(crypto->int_dig_vv);
 	crypto_free_hash(crypto->cram_hmac_tfm);
 	crypto_free_hash(crypto->integrity_tfm);
-	crypto_free_hash(crypto->integrity_r_tfm);
+	crypto_free_hash(crypto->peer_integrity_tfm);
 	crypto_free_hash(crypto->csums_tfm);
 	crypto_free_hash(crypto->verify_tfm);
 }
@@ -2003,8 +2003,8 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 	tconn->int_dig_vv = crypto.int_dig_vv;
 	crypto_free_hash(tconn->integrity_tfm);
 	tconn->integrity_tfm = crypto.integrity_tfm;
-	crypto_free_hash(tconn->integrity_r_tfm);
-	tconn->integrity_r_tfm = crypto.integrity_r_tfm;
+	crypto_free_hash(tconn->peer_integrity_tfm);
+	tconn->peer_integrity_tfm = crypto.peer_integrity_tfm;
 
 	/* FIXME Changing cram_hmac while the connection is established is useless */
 	crypto_free_hash(tconn->cram_hmac_tfm);
@@ -2129,7 +2129,7 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	tconn->int_dig_vv = crypto.int_dig_vv;
 	tconn->cram_hmac_tfm = crypto.cram_hmac_tfm;
 	tconn->integrity_tfm = crypto.integrity_tfm;
-	tconn->integrity_r_tfm = crypto.integrity_r_tfm;
+	tconn->peer_integrity_tfm = crypto.peer_integrity_tfm;
 	tconn->csums_tfm = crypto.csums_tfm;
 	tconn->verify_tfm = crypto.verify_tfm;
 
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 98f03b1..36b846b 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1384,8 +1384,8 @@ read_in_block(struct drbd_conf *mdev, u64 id, sector_t sector,
 	void *dig_vv = mdev->tconn->int_dig_vv;
 	unsigned long *data;
 
-	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->integrity_r_tfm) ?
-		crypto_hash_digestsize(mdev->tconn->integrity_r_tfm) : 0;
+	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->peer_integrity_tfm) ?
+		crypto_hash_digestsize(mdev->tconn->peer_integrity_tfm) : 0;
 
 	if (dgs) {
 		/*
@@ -1442,7 +1442,7 @@ read_in_block(struct drbd_conf *mdev, u64 id, sector_t sector,
 	}
 
 	if (dgs) {
-		drbd_csum_ee(mdev, mdev->tconn->integrity_r_tfm, peer_req, dig_vv);
+		drbd_csum_ee(mdev, mdev->tconn->peer_integrity_tfm, peer_req, dig_vv);
 		if (memcmp(dig_in, dig_vv, dgs)) {
 			dev_err(DEV, "Digest integrity check FAILED: %llus +%u\n",
 				(unsigned long long)sector, data_size);
@@ -1491,8 +1491,8 @@ static int recv_dless_read(struct drbd_conf *mdev, struct drbd_request *req,
 	void *dig_in = mdev->tconn->int_dig_in;
 	void *dig_vv = mdev->tconn->int_dig_vv;
 
-	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->integrity_r_tfm) ?
-		crypto_hash_digestsize(mdev->tconn->integrity_r_tfm) : 0;
+	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->peer_integrity_tfm) ?
+		crypto_hash_digestsize(mdev->tconn->peer_integrity_tfm) : 0;
 
 	if (dgs) {
 		err = drbd_recv_all_warn(mdev->tconn, dig_in, dgs);
@@ -1520,7 +1520,7 @@ static int recv_dless_read(struct drbd_conf *mdev, struct drbd_request *req,
 	}
 
 	if (dgs) {
-		drbd_csum_bio(mdev, mdev->tconn->integrity_r_tfm, bio, dig_vv);
+		drbd_csum_bio(mdev, mdev->tconn->peer_integrity_tfm, bio, dig_vv);
 		if (memcmp(dig_in, dig_vv, dgs)) {
 			dev_err(DEV, "Digest integrity check FAILED. Broken NICs?\n");
 			return -EINVAL;
-- 
1.7.4.1

