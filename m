Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab2ENVEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:04:53 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:48490 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758014Ab2ENVEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:04:40 -0400
Message-ID: <1337029530.5614.10.camel@key-ThinkPad-W510>
Subject: [PATCH v4 09/17] powerpc: crypto: AES-CTR mode routines for nx
 encryption
From: Kent Yoder <key@linux.vnet.ibm.com>
To: benh@kernel.crashing.org
Cc: rcj@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date: Mon, 14 May 2012 16:05:30 -0500
In-Reply-To: <1336955527.6727.2.camel@pasglop>
References: <1336955527.6727.2.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051421-5518-0000-0000-0000046561F1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These routines add support for AES in CTR mode on the Power7+ CPU's
in-Nest accelerator driver.

Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx-aes-ctr.c |  178 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 178 insertions(+), 0 deletions(-)
 create mode 100644 drivers/crypto/nx/nx-aes-ctr.c

diff --git a/drivers/crypto/nx/nx-aes-ctr.c b/drivers/crypto/nx/nx-aes-ctr.c
new file mode 100644
index 0000000..52d4eb0
--- /dev/null
+++ b/drivers/crypto/nx/nx-aes-ctr.c
@@ -0,0 +1,178 @@
+/**
+ * AES CTR routines supporting the Power 7+ Nest Accelerators driver
+ *
+ * Copyright (C) 2011-2012 International Business Machines Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 only.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ * Author: Kent Yoder <yoder1@us.ibm.com>
+ */
+
+#include <crypto/aes.h>
+#include <crypto/ctr.h>
+#include <crypto/algapi.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/crypto.h>
+#include <asm/vio.h>
+
+#include "nx_csbcpb.h"
+#include "nx.h"
+
+
+static int ctr_aes_nx_set_key(struct crypto_tfm *tfm,
+			      const u8          *in_key,
+			      unsigned int       key_len)
+{
+	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(tfm);
+	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
+
+	nx_ctx_init(nx_ctx, HCOP_FC_AES);
+
+	switch (key_len) {
+	case AES_KEYSIZE_128:
+		NX_CPB_SET_KEY_SIZE(csbcpb, NX_KS_AES_128);
+		nx_ctx->ap = &nx_ctx->props[NX_PROPS_AES_128];
+		break;
+	case AES_KEYSIZE_192:
+		NX_CPB_SET_KEY_SIZE(csbcpb, NX_KS_AES_192);
+		nx_ctx->ap = &nx_ctx->props[NX_PROPS_AES_192];
+		break;
+	case AES_KEYSIZE_256:
+		NX_CPB_SET_KEY_SIZE(csbcpb, NX_KS_AES_256);
+		nx_ctx->ap = &nx_ctx->props[NX_PROPS_AES_256];
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	csbcpb->cpb.hdr.mode = NX_MODE_AES_CTR;
+	memcpy(csbcpb->cpb.aes_ctr.key, in_key, key_len);
+
+	return 0;
+}
+
+static int ctr3686_aes_nx_set_key(struct crypto_tfm *tfm,
+				  const u8          *in_key,
+				  unsigned int       key_len)
+{
+	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(tfm);
+
+	if (key_len < CTR_RFC3686_NONCE_SIZE)
+		return -EINVAL;
+
+	memcpy(nx_ctx->priv.ctr.iv,
+	       in_key + key_len - CTR_RFC3686_NONCE_SIZE,
+	       CTR_RFC3686_NONCE_SIZE);
+
+	key_len -= CTR_RFC3686_NONCE_SIZE;
+
+	return ctr_aes_nx_set_key(tfm, in_key, key_len);
+}
+
+static int ctr_aes_nx_crypt(struct blkcipher_desc *desc,
+			    struct scatterlist    *dst,
+			    struct scatterlist    *src,
+			    unsigned int           nbytes)
+{
+	struct nx_crypto_ctx *nx_ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
+	int rc;
+
+	if (nbytes > nx_ctx->ap->databytelen)
+		return -EINVAL;
+
+	rc = nx_build_sg_lists(nx_ctx, desc, dst, src, nbytes,
+			       csbcpb->cpb.aes_ctr.iv);
+	if (rc)
+		goto out;
+
+	if (!nx_ctx->op.inlen || !nx_ctx->op.outlen) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
+			   desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP);
+	if (rc)
+		goto out;
+
+	atomic_inc(&(nx_ctx->stats->aes_ops));
+	atomic64_add(csbcpb->csb.processed_byte_count,
+		     &(nx_ctx->stats->aes_bytes));
+out:
+	return rc;
+}
+
+static int ctr3686_aes_nx_crypt(struct blkcipher_desc *desc,
+				struct scatterlist    *dst,
+				struct scatterlist    *src,
+				unsigned int           nbytes)
+{
+	struct nx_crypto_ctx *nx_ctx = crypto_blkcipher_ctx(desc->tfm);
+	u8 *iv = nx_ctx->priv.ctr.iv;
+
+	memcpy(iv + CTR_RFC3686_NONCE_SIZE,
+	       desc->info, CTR_RFC3686_IV_SIZE);
+	iv[15] = 1;
+
+	desc->info = nx_ctx->priv.ctr.iv;
+
+	return ctr_aes_nx_crypt(desc, dst, src, nbytes);
+}
+
+struct crypto_alg nx_ctr_aes_alg = {
+	.cra_name        = "ctr(aes)",
+	.cra_driver_name = "ctr-aes-nx",
+	.cra_priority    = 300,
+	.cra_flags       = CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize   = 1,
+	.cra_ctxsize     = sizeof(struct nx_crypto_ctx),
+	.cra_type        = &crypto_blkcipher_type,
+	.cra_module      = THIS_MODULE,
+	.cra_list        = LIST_HEAD_INIT(nx_ctr_aes_alg.cra_list),
+	.cra_init        = nx_crypto_ctx_aes_ctr_init,
+	.cra_exit        = nx_crypto_ctx_exit,
+	.cra_blkcipher = {
+		.min_keysize = AES_MIN_KEY_SIZE,
+		.max_keysize = AES_MAX_KEY_SIZE,
+		.ivsize      = AES_BLOCK_SIZE,
+		.setkey      = ctr_aes_nx_set_key,
+		.encrypt     = ctr_aes_nx_crypt,
+		.decrypt     = ctr_aes_nx_crypt,
+	}
+};
+
+struct crypto_alg nx_ctr3686_aes_alg = {
+	.cra_name        = "rfc3686(ctr(aes))",
+	.cra_driver_name = "rfc3686-ctr-aes-nx",
+	.cra_priority    = 300,
+	.cra_flags       = CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize   = 1,
+	.cra_ctxsize     = sizeof(struct nx_crypto_ctx),
+	.cra_type        = &crypto_blkcipher_type,
+	.cra_module      = THIS_MODULE,
+	.cra_list        = LIST_HEAD_INIT(nx_ctr3686_aes_alg.cra_list),
+	.cra_init        = nx_crypto_ctx_aes_ctr_init,
+	.cra_exit        = nx_crypto_ctx_exit,
+	.cra_blkcipher = {
+		.min_keysize = AES_MIN_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
+		.max_keysize = AES_MAX_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
+		.ivsize      = CTR_RFC3686_IV_SIZE,
+		.geniv       = "seqiv",
+		.setkey      = ctr3686_aes_nx_set_key,
+		.encrypt     = ctr3686_aes_nx_crypt,
+		.decrypt     = ctr3686_aes_nx_crypt,
+	}
+};
-- 
1.7.5.4


