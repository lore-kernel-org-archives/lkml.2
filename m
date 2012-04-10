Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272Ab2DJPLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:11:46 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:34740 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759069Ab2DJPLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:11:44 -0400
Message-ID: <1334070611.16827.19.camel@key-ThinkPad-W510>
Subject: [PATCH v2 09/17] powerpc: crypto: AES-ECB mode routines for nx
 encryption
From: Kent Yoder <key@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, rcj@linux.vnet.ibm.com,
        key@linux.vnet.ibm.com, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org
Date: Tue, 10 Apr 2012 10:10:11 -0500
In-Reply-To: <1334070249.16827.1.camel@key-ThinkPad-W510>
References: <1334070249.16827.1.camel@key-ThinkPad-W510>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041015-2398-0000-0000-000005B5BE68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These routines add support for AES in ECB mode on the Power7+ CPU's
in-Nest accelerator driver.

Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx-aes-ecb.c |  138 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 138 insertions(+), 0 deletions(-)
 create mode 100644 drivers/crypto/nx/nx-aes-ecb.c

diff --git a/drivers/crypto/nx/nx-aes-ecb.c b/drivers/crypto/nx/nx-aes-ecb.c
new file mode 100644
index 0000000..6db5a71
--- /dev/null
+++ b/drivers/crypto/nx/nx-aes-ecb.c
@@ -0,0 +1,138 @@
+/**
+ * AES ECB routines supporting the Power 7+ Nest Accelerators driver
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
+static int ecb_aes_nx_set_key(struct crypto_tfm *tfm,
+			      const u8          *in_key,
+			      unsigned int       key_len)
+{
+	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(tfm);
+	struct nx_csbcpb *csbcpb = (struct nx_csbcpb *)nx_ctx->csbcpb;
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
+	csbcpb->cpb.hdr.mode = NX_MODE_AES_ECB;
+	memcpy(csbcpb->cpb.aes_ecb.key, in_key, key_len);
+
+	return 0;
+}
+
+static int ecb_aes_nx_crypt(struct blkcipher_desc *desc,
+			    struct scatterlist    *dst,
+			    struct scatterlist    *src,
+			    unsigned int           nbytes,
+			    int                    enc)
+{
+	struct nx_crypto_ctx *nx_ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
+	int rc;
+
+	if (nbytes > nx_ctx->ap->databytelen)
+		return -EINVAL;
+
+	if (enc)
+		NX_CPB_FDM(csbcpb) |= NX_FDM_ENDE_ENCRYPT;
+	else
+		NX_CPB_FDM(csbcpb) &= ~NX_FDM_ENDE_ENCRYPT;
+
+	rc = nx_build_sg_lists(nx_ctx, desc, dst, src, nbytes, NULL);
+	if (rc)
+		goto out;
+
+	if (!nx_ctx->op.inlen || !nx_ctx->op.outlen) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	rc = nx_hcall_sync(nx_ctx, &nx_ctx->op);
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
+static int ecb_aes_nx_encrypt(struct blkcipher_desc *desc,
+			      struct scatterlist    *dst,
+			      struct scatterlist    *src,
+			      unsigned int           nbytes)
+{
+	return ecb_aes_nx_crypt(desc, dst, src, nbytes, 1);
+}
+
+static int ecb_aes_nx_decrypt(struct blkcipher_desc *desc,
+			      struct scatterlist    *dst,
+			      struct scatterlist    *src,
+			      unsigned int           nbytes)
+{
+	return ecb_aes_nx_crypt(desc, dst, src, nbytes, 0);
+}
+
+struct crypto_alg nx_ecb_aes_alg = {
+	.cra_name        = "ecb(aes)",
+	.cra_driver_name = "ecb-aes-nx",
+	.cra_priority    = 300,
+	.cra_flags       = CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize   = AES_BLOCK_SIZE,
+	.cra_ctxsize     = sizeof(struct nx_crypto_ctx),
+	.cra_type        = &crypto_blkcipher_type,
+	.cra_module      = THIS_MODULE,
+	.cra_list        = LIST_HEAD_INIT(nx_ecb_aes_alg.cra_list),
+	.cra_init        = nx_crypto_ctx_aes_ecb_init,
+	.cra_exit        = nx_crypto_ctx_exit,
+	.cra_blkcipher = {
+		.min_keysize = AES_MIN_KEY_SIZE,
+		.max_keysize = AES_MAX_KEY_SIZE,
+		.setkey      = ecb_aes_nx_set_key,
+		.encrypt     = ecb_aes_nx_encrypt,
+		.decrypt     = ecb_aes_nx_decrypt,
+	}
+};
-- 
1.7.1


