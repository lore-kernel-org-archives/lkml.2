Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab0JKPry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 11:47:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:1956 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754239Ab0JKPrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 11:47:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,314,1283756400"; 
   d="scan'208";a="666265444"
Date: Mon, 11 Oct 2010 16:47:43 +0100
From: tadeusz.struk@intel.com
To: herbert@gondor.hengli.com.au
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        aidan.o.mahony@intel.com, gabriele.paoloni@intel.com,
        adrian.hoban@intel.com, tadeusz.struk@intel.com
Subject: [PATCH 1/3] Adding the AEAD interface type support to cryptd
Message-ID: <4CB3319F.mail9GN11AWZ7@intel.com>
User-Agent: nail 10.6 11/15/03
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Herbert,
Sorry for the mess. this is what happens when one uses wrong email client.
I'm resending the all the patches now.
Please let us know if it is ok now.
Regards
Tadeusz

>From 13929c2e92a871f92d489effadc7c6c724af0288 Mon Sep 17 00:00:00 2001
From: Adrian Hoban <ahoban@allen.ir.intel.com>
Date: Fri, 10 Sep 2010 17:59:37 +0100
Subject: [PATCH 1/3] Adding the AEAD interface type support to cryptd

This patch adds AEAD support into the cryptd framework. Having AEAD
support in cryptd enables crypto drivers that use the AEAD
interface type (such as the patch for AEAD based RFC4106 AES-GCM
implementation using Intel New Instructions) to leverage cryptd for
asynchronous processing.

Signed-off-by: Adrian Hoban <adrian.hoban@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
Signed-off-by: Gabriele Paoloni <gabriele.paoloni@intel.com>
Signed-off-by: Aidan O'Mahony <aidan.o.mahony@intel.com>
---
 crypto/cryptd.c         |  206 ++++++++++++++++++++++++++++++++++++++++++++++-
 include/crypto/cryptd.h |   24 ++++++
 2 files changed, 227 insertions(+), 3 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index ef71318..e46d21a 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -3,6 +3,13 @@
  *
  * Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
  *
+ * Added AEAD support to cryptd.
+ *    Authors: Tadeusz Struk (tadeusz.struk@intel.com)
+ *             Adrian Hoban <adrian.hoban@intel.com>
+ *             Gabriele Paoloni <gabriele.paoloni@intel.com>
+ *             Aidan O'Mahony (aidan.o.mahony@intel.com)
+ *    Copyright (c) 2010, Intel Corporation.
+ *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
  * Software Foundation; either version 2 of the License, or (at your option)
@@ -12,6 +19,7 @@
 
 #include <crypto/algapi.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/aead.h>
 #include <crypto/cryptd.h>
 #include <crypto/crypto_wq.h>
 #include <linux/err.h>
@@ -44,6 +52,11 @@ struct hashd_instance_ctx {
 	struct cryptd_queue *queue;
 };
 
+struct aead_instance_ctx {
+	struct crypto_aead_spawn aead_spawn;
+	struct cryptd_queue *queue;
+};
+
 struct cryptd_blkcipher_ctx {
 	struct crypto_blkcipher *child;
 };
@@ -61,6 +74,14 @@ struct cryptd_hash_request_ctx {
 	struct shash_desc desc;
 };
 
+struct cryptd_aead_ctx {
+	struct crypto_aead *child;
+};
+
+struct cryptd_aead_request_ctx {
+	crypto_completion_t complete;
+};
+
 static void cryptd_queue_worker(struct work_struct *work);
 
 static int cryptd_init_queue(struct cryptd_queue *queue,
@@ -601,6 +622,144 @@ out_put_alg:
 	return err;
 }
 
+static void cryptd_aead_crypt(struct aead_request *req,
+			struct crypto_aead *child,
+			int err,
+			int (*crypt)(struct aead_request *req))
+{
+	struct cryptd_aead_request_ctx *rctx;
+	rctx = aead_request_ctx(req);
+
+	if (unlikely(err == -EINPROGRESS))
+		goto out;
+	aead_request_set_tfm(req, child);
+	err = crypt( req );
+	req->base.complete = rctx->complete;
+out:
+	local_bh_disable();
+	rctx->complete(&req->base, err);
+	local_bh_enable();
+}
+
+static void cryptd_aead_encrypt(struct crypto_async_request *areq, int err)
+{
+	struct cryptd_aead_ctx *ctx = crypto_tfm_ctx(areq->tfm);
+	struct crypto_aead *child = ctx->child;
+	struct aead_request *req;
+
+	req = container_of(areq, struct aead_request, base);
+	cryptd_aead_crypt(req, child, err, crypto_aead_crt(child)->encrypt);
+}
+
+static void cryptd_aead_decrypt(struct crypto_async_request *areq, int err)
+{
+	struct cryptd_aead_ctx *ctx = crypto_tfm_ctx(areq->tfm);
+	struct crypto_aead *child = ctx->child;
+	struct aead_request *req;
+
+	req = container_of(areq, struct aead_request, base);
+	cryptd_aead_crypt(req, child, err, crypto_aead_crt(child)->decrypt);
+}
+
+static int cryptd_aead_enqueue(struct aead_request *req,
+				    crypto_completion_t complete)
+{
+	struct cryptd_aead_request_ctx *rctx = aead_request_ctx(req);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct cryptd_queue *queue = cryptd_get_queue(crypto_aead_tfm(tfm));
+
+	rctx->complete = req->base.complete;
+	req->base.complete = complete;
+	return cryptd_enqueue_request(queue, &req->base);
+}
+
+static int cryptd_aead_encrypt_enqueue(struct aead_request *req)
+{
+	return cryptd_aead_enqueue(req, cryptd_aead_encrypt );
+}
+
+static int cryptd_aead_decrypt_enqueue(struct aead_request *req)
+{
+	return cryptd_aead_enqueue(req, cryptd_aead_decrypt );
+}
+
+static int cryptd_aead_init_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
+	struct aead_instance_ctx *ictx = crypto_instance_ctx(inst);
+	struct crypto_aead_spawn *spawn = &ictx->aead_spawn;
+	struct cryptd_aead_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_aead *cipher;
+
+	cipher = crypto_spawn_aead(spawn);
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
+
+	crypto_aead_set_flags(cipher, CRYPTO_TFM_REQ_MAY_SLEEP);
+	ctx->child = cipher;
+	tfm->crt_aead.reqsize = sizeof(struct cryptd_aead_request_ctx);
+	return 0;
+}
+
+static void cryptd_aead_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct cryptd_aead_ctx *ctx = crypto_tfm_ctx(tfm);
+	crypto_free_aead(ctx->child);
+}
+
+static int cryptd_create_aead(struct crypto_template *tmpl,
+		              struct rtattr **tb,
+			      struct cryptd_queue *queue)
+{
+	struct aead_instance_ctx *ctx;
+	struct crypto_instance *inst;
+	struct crypto_alg *alg;
+	int err;
+
+	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_AEAD,
+				CRYPTO_ALG_TYPE_MASK);
+        if (IS_ERR(alg))
+		return PTR_ERR(alg);
+
+	inst = cryptd_alloc_instance(alg, 0, sizeof(*ctx));
+	err = PTR_ERR(inst);
+	if (IS_ERR(inst))
+		goto out_put_alg;
+
+	ctx = crypto_instance_ctx(inst);
+	ctx->queue = queue;
+
+	err = crypto_init_spawn(&ctx->aead_spawn.base, alg, inst,
+			CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);
+	if (err)
+		goto out_free_inst;
+
+	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC;
+	inst->alg.cra_type = alg->cra_type;
+	inst->alg.cra_ctxsize = sizeof(struct cryptd_aead_ctx);
+	inst->alg.cra_init = cryptd_aead_init_tfm;
+	inst->alg.cra_exit = cryptd_aead_exit_tfm;
+	inst->alg.cra_aead.setkey      = alg->cra_aead.setkey;
+	inst->alg.cra_aead.setauthsize = alg->cra_aead.setauthsize;
+	inst->alg.cra_aead.geniv       = alg->cra_aead.geniv;
+	inst->alg.cra_aead.ivsize      = alg->cra_aead.ivsize;
+	inst->alg.cra_aead.maxauthsize = alg->cra_aead.maxauthsize;
+	inst->alg.cra_aead.encrypt     = cryptd_aead_encrypt_enqueue;
+	inst->alg.cra_aead.decrypt     = cryptd_aead_decrypt_enqueue;
+	inst->alg.cra_aead.givencrypt  = alg->cra_aead.givencrypt;
+	inst->alg.cra_aead.givdecrypt  = alg->cra_aead.givdecrypt;
+
+	err = crypto_register_instance(tmpl, inst);
+	if (err) {
+		crypto_drop_spawn(&ctx->aead_spawn.base);
+out_free_inst:
+		kfree(inst);
+	}
+out_put_alg:
+	crypto_mod_put(alg);
+	return err;
+}
+
 static struct cryptd_queue queue;
 
 static int cryptd_create(struct crypto_template *tmpl, struct rtattr **tb)
@@ -616,6 +775,8 @@ static int cryptd_create(struct crypto_template *tmpl, struct rtattr **tb)
 		return cryptd_create_blkcipher(tmpl, tb, &queue);
 	case CRYPTO_ALG_TYPE_DIGEST:
 		return cryptd_create_hash(tmpl, tb, &queue);
+	case CRYPTO_ALG_TYPE_AEAD:
+		return cryptd_create_aead(tmpl, tb, &queue);
 	}
 
 	return -EINVAL;
@@ -625,16 +786,21 @@ static void cryptd_free(struct crypto_instance *inst)
 {
 	struct cryptd_instance_ctx *ctx = crypto_instance_ctx(inst);
 	struct hashd_instance_ctx *hctx = crypto_instance_ctx(inst);
+	struct aead_instance_ctx *aead_ctx = crypto_instance_ctx(inst);
 
 	switch (inst->alg.cra_flags & CRYPTO_ALG_TYPE_MASK) {
 	case CRYPTO_ALG_TYPE_AHASH:
 		crypto_drop_shash(&hctx->spawn);
 		kfree(ahash_instance(inst));
 		return;
+	case CRYPTO_ALG_TYPE_AEAD:
+		crypto_drop_spawn(&aead_ctx->aead_spawn.base);
+		kfree(inst);
+		return;
+	default:
+		crypto_drop_spawn(&ctx->spawn);
+		kfree(inst);
 	}
-
-	crypto_drop_spawn(&ctx->spawn);
-	kfree(inst);
 }
 
 static struct crypto_template cryptd_tmpl = {
@@ -724,6 +890,40 @@ void cryptd_free_ahash(struct cryptd_ahash *tfm)
 }
 EXPORT_SYMBOL_GPL(cryptd_free_ahash);
 
+struct cryptd_aead *cryptd_alloc_aead(const char *alg_name,
+						  u32 type, u32 mask)
+{
+	char cryptd_alg_name[CRYPTO_MAX_ALG_NAME];
+	struct crypto_aead *tfm;
+
+	if (snprintf(cryptd_alg_name, CRYPTO_MAX_ALG_NAME,
+		     "cryptd(%s)", alg_name) >= CRYPTO_MAX_ALG_NAME)
+		return ERR_PTR(-EINVAL);
+	tfm = crypto_alloc_aead(cryptd_alg_name, type, mask);
+	if (IS_ERR(tfm))
+		return ERR_CAST(tfm);
+	if (tfm->base.__crt_alg->cra_module != THIS_MODULE) {
+		crypto_free_aead(tfm);
+		return ERR_PTR(-EINVAL);
+	}
+	return __cryptd_aead_cast(tfm);
+}
+EXPORT_SYMBOL_GPL(cryptd_alloc_aead);
+
+struct crypto_aead *cryptd_aead_child(struct cryptd_aead *tfm)
+{
+	struct cryptd_aead_ctx *ctx;
+	ctx = crypto_aead_ctx(&tfm->base);
+	return ctx->child;
+}
+EXPORT_SYMBOL_GPL(cryptd_aead_child);
+
+void cryptd_free_aead(struct cryptd_aead *tfm)
+{
+	crypto_free_aead(&tfm->base);
+}
+EXPORT_SYMBOL_GPL(cryptd_free_aead);
+
 static int __init cryptd_init(void)
 {
 	int err;
diff --git a/include/crypto/cryptd.h b/include/crypto/cryptd.h
index 1c96b25..ba98918 100644
--- a/include/crypto/cryptd.h
+++ b/include/crypto/cryptd.h
@@ -1,5 +1,12 @@
 /*
  * Software async crypto daemon
+ *
+ * Added AEAD support to cryptd.
+ *    Authors: Tadeusz Struk (tadeusz.struk@intel.com)
+ *             Adrian Hoban <adrian.hoban@intel.com>
+ *             Gabriele Paoloni <gabriele.paoloni@intel.com>
+ *             Aidan O'Mahony (aidan.o.mahony@intel.com)
+ *    Copyright (c) 2010, Intel Corporation.
  */
 
 #ifndef _CRYPTO_CRYPT_H
@@ -42,4 +49,21 @@ struct crypto_shash *cryptd_ahash_child(struct cryptd_ahash *tfm);
 struct shash_desc *cryptd_shash_desc(struct ahash_request *req);
 void cryptd_free_ahash(struct cryptd_ahash *tfm);
 
+struct cryptd_aead {
+	struct crypto_aead base;
+};
+
+static inline struct cryptd_aead *__cryptd_aead_cast(
+	struct crypto_aead *tfm)
+{
+	return (struct cryptd_aead *)tfm;
+}
+
+struct cryptd_aead *cryptd_alloc_aead(const char *alg_name,
+					  u32 type, u32 mask);
+
+struct crypto_aead *cryptd_aead_child(struct cryptd_aead *tfm);
+
+void cryptd_free_aead(struct cryptd_aead *tfm);
+
 #endif
-- 
1.5.3.rc5

--------------------------------------------------------------
Intel Shannon Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263
Business address: Dromore House, East Park, Shannon, Co. Clare

This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). Any review or distribution by others is strictly prohibited. If you are not the intended recipient, please contact the sender and delete all copies.


