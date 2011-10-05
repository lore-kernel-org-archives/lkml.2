Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934320Ab1JEJj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:39:59 -0400
Received: from mail09.linbit.com ([212.69.161.110]:56229 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934205Ab1JEJiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:38:10 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 09/16] drbd: Remove obsolete drbd_crypto_is_hash()
Date: Wed,  5 Oct 2011 11:37:57 +0200
Message-Id: <1317807484-24628-10-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317807484-24628-1-git-send-email-philipp.reisner@linbit.com>
References: <1317807484-24628-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

We allocate hash transformations with crypto_alloc_hash() which will
only return hash algorithms.  It is not necessary to reconfirm that we
actually got a hash algorithm.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c       |   25 +++++++++++--------------
 drivers/block/drbd/drbd_receiver.c |    5 -----
 drivers/block/drbd/drbd_wrappers.h |    6 ------
 3 files changed, 11 insertions(+), 25 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index efae733..fd97ffb 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1830,7 +1830,7 @@ struct crypto {
 };
 
 static int
-alloc_tfm(struct crypto_hash **tfm, char *tfm_name, int err_alg, int err_nd)
+alloc_hash(struct crypto_hash **tfm, char *tfm_name, int err_alg)
 {
 	if (!tfm_name[0])
 		return NO_ERROR;
@@ -1841,9 +1841,6 @@ alloc_tfm(struct crypto_hash **tfm, char *tfm_name, int err_alg, int err_nd)
 		return err_alg;
 	}
 
-	if (!drbd_crypto_is_hash(crypto_hash_tfm(*tfm)))
-		return err_nd;
-
 	return NO_ERROR;
 }
 
@@ -1854,28 +1851,28 @@ alloc_crypto(struct crypto *crypto, struct net_conf *new_conf)
 	enum drbd_ret_code rv;
 	int hash_size;
 
-	rv = alloc_tfm(&crypto->csums_tfm, new_conf->csums_alg,
-		       ERR_CSUMS_ALG, ERR_CSUMS_ALG_ND);
+	rv = alloc_hash(&crypto->csums_tfm, new_conf->csums_alg,
+		       ERR_CSUMS_ALG);
 	if (rv != NO_ERROR)
 		return rv;
-	rv = alloc_tfm(&crypto->verify_tfm, new_conf->verify_alg,
-		       ERR_VERIFY_ALG, ERR_VERIFY_ALG_ND);
+	rv = alloc_hash(&crypto->verify_tfm, new_conf->verify_alg,
+		       ERR_VERIFY_ALG);
 	if (rv != NO_ERROR)
 		return rv;
-	rv = alloc_tfm(&crypto->integrity_tfm, new_conf->integrity_alg,
-		       ERR_INTEGRITY_ALG, ERR_INTEGRITY_ALG_ND);
+	rv = alloc_hash(&crypto->integrity_tfm, new_conf->integrity_alg,
+		       ERR_INTEGRITY_ALG);
 	if (rv != NO_ERROR)
 		return rv;
-	rv = alloc_tfm(&crypto->peer_integrity_tfm, new_conf->integrity_alg,
-		       ERR_INTEGRITY_ALG, ERR_INTEGRITY_ALG_ND);
+	rv = alloc_hash(&crypto->peer_integrity_tfm, new_conf->integrity_alg,
+		       ERR_INTEGRITY_ALG);
 	if (rv != NO_ERROR)
 		return rv;
 	if (new_conf->cram_hmac_alg[0] != 0) {
 		snprintf(hmac_name, CRYPTO_MAX_ALG_NAME, "hmac(%s)",
 			 new_conf->cram_hmac_alg);
 
-		rv = alloc_tfm(&crypto->cram_hmac_tfm, hmac_name,
-			       ERR_AUTH_ALG, ERR_AUTH_ALG_ND);
+		rv = alloc_hash(&crypto->cram_hmac_tfm, hmac_name,
+			       ERR_AUTH_ALG);
 	}
 	if (crypto->integrity_tfm) {
 		hash_size = crypto_hash_digestsize(crypto->integrity_tfm);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 36b846b..30b6556 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3100,11 +3100,6 @@ struct crypto_hash *drbd_crypto_alloc_digest_safe(const struct drbd_conf *mdev,
 			alg, name, PTR_ERR(tfm));
 		return tfm;
 	}
-	if (!drbd_crypto_is_hash(crypto_hash_tfm(tfm))) {
-		crypto_free_hash(tfm);
-		dev_err(DEV, "\"%s\" is not a digest (%s)\n", alg, name);
-		return ERR_PTR(-EINVAL);
-	}
 	return tfm;
 }
 
diff --git a/drivers/block/drbd/drbd_wrappers.h b/drivers/block/drbd/drbd_wrappers.h
index decf9b2..46a6d99 100644
--- a/drivers/block/drbd/drbd_wrappers.h
+++ b/drivers/block/drbd/drbd_wrappers.h
@@ -45,12 +45,6 @@ static inline void drbd_generic_make_request(struct drbd_conf *mdev,
 		generic_make_request(bio);
 }
 
-static inline int drbd_crypto_is_hash(struct crypto_tfm *tfm)
-{
-        return (crypto_tfm_alg_type(tfm) & CRYPTO_ALG_TYPE_HASH_MASK)
-                == CRYPTO_ALG_TYPE_HASH;
-}
-
 #ifndef __CHECKER__
 # undef __cond_lock
 # define __cond_lock(x,c) (c)
-- 
1.7.4.1

