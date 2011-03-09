Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195Ab1CIP5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 10:57:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:3728 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757010Ab1CIP5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 10:57:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,291,1297065600"; 
   d="scan'208";a="718234174"
Date: Wed, 09 Mar 2011 15:56:52 +0000
From: tadeusz.struk@intel.com
To: herbert@gondor.hengli.com.au
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        aidan.o.mahony@intel.com, gabriele.paoloni@intel.com,
        adrian.hoban@intel.com, tadeusz.struk@intel.com
Subject: [PATCH] RFC4106 AES-GCM Driver - fixed problem with packets that
 are not multiple of 64bytes
Message-ID: <4d77a344.ufBJ2BimO/o2UpKI%tadeusz.struk@intel.com>
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk@intel.com>
Date: Wed, 9 Mar 2011 15:01:06 +0000
Subject: [PATCH] RFC4106 AES-GCM Driver - fixed problem with packets that are not multiple of 64bytes

Hi Herbert,
This patch fixes problem with packets that are not multiple of 64bytes.
Regards,
Tadeusz


Signed-off-by: Adrian Hoban <adrian.hoban@intel.com>
Signed-off-by: Aidan O'Mahony <aidan.o.mahony@intel.com>
Signed-off-by: Gabriele Paoloni <gabriele.paoloni@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 arch/x86/crypto/aesni-intel_asm.S  |    5 ++++-
 arch/x86/crypto/aesni-intel_glue.c |   14 ++++++++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 8fe2a49..4faa3b2 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -1612,6 +1612,7 @@ _zero_cipher_left_encrypt:
         movdqa SHUF_MASK(%rip), %xmm10
 	PSHUFB_XMM %xmm10, %xmm0
 
+
 	ENCRYPT_SINGLE_BLOCK	%xmm0, %xmm1        # Encrypt(K, Yn)
 	sub $16, %r11
 	add %r13, %r11
@@ -1634,7 +1635,9 @@ _zero_cipher_left_encrypt:
 	# GHASH computation for the last <16 byte block
 	sub	%r13, %r11
 	add	$16, %r11
-	PSHUFB_XMM %xmm10, %xmm1
+
+	movdqa SHUF_MASK(%rip), %xmm10
+	PSHUFB_XMM %xmm10, %xmm0
 
 	# shuffle xmm0 back to output as ciphertext
 
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index e0e6340..2577613 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -828,9 +828,15 @@ static int rfc4106_init(struct crypto_tfm *tfm)
 	struct cryptd_aead *cryptd_tfm;
 	struct aesni_rfc4106_gcm_ctx *ctx = (struct aesni_rfc4106_gcm_ctx *)
 		PTR_ALIGN((u8 *)crypto_tfm_ctx(tfm), AESNI_ALIGN);
+	struct crypto_aead *cryptd_child;
+	struct aesni_rfc4106_gcm_ctx *child_ctx;
 	cryptd_tfm = cryptd_alloc_aead("__driver-gcm-aes-aesni", 0, 0);
 	if (IS_ERR(cryptd_tfm))
 		return PTR_ERR(cryptd_tfm);
+
+	cryptd_child = cryptd_aead_child(cryptd_tfm);
+	child_ctx = aesni_rfc4106_gcm_ctx_get(cryptd_child);
+	memcpy(child_ctx, ctx, sizeof(*ctx));
 	ctx->cryptd_tfm = cryptd_tfm;
 	tfm->crt_aead.reqsize = sizeof(struct aead_request)
 		+ crypto_aead_reqsize(&cryptd_tfm->base);
@@ -923,6 +929,9 @@ static int rfc4106_set_key(struct crypto_aead *parent, const u8 *key,
 	int ret = 0;
 	struct crypto_tfm *tfm = crypto_aead_tfm(parent);
 	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(parent);
+	struct crypto_aead *cryptd_child = cryptd_aead_child(ctx->cryptd_tfm);
+	struct aesni_rfc4106_gcm_ctx *child_ctx =
+                                 aesni_rfc4106_gcm_ctx_get(cryptd_child);
 	u8 *new_key_mem = NULL;
 
 	if (key_len < 4) {
@@ -966,6 +975,7 @@ static int rfc4106_set_key(struct crypto_aead *parent, const u8 *key,
 		goto exit;
 	}
 	ret = rfc4106_set_hash_subkey(ctx->hash_subkey, key, key_len);
+	memcpy(child_ctx, ctx, sizeof(*ctx));
 exit:
 	kfree(new_key_mem);
 	return ret;
@@ -997,7 +1007,6 @@ static int rfc4106_encrypt(struct aead_request *req)
 	int ret;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(tfm);
-	struct crypto_aead *cryptd_child = cryptd_aead_child(ctx->cryptd_tfm);
 
 	if (!irq_fpu_usable()) {
 		struct aead_request *cryptd_req =
@@ -1006,6 +1015,7 @@ static int rfc4106_encrypt(struct aead_request *req)
 		aead_request_set_tfm(cryptd_req, &ctx->cryptd_tfm->base);
 		return crypto_aead_encrypt(cryptd_req);
 	} else {
+		struct crypto_aead *cryptd_child = cryptd_aead_child(ctx->cryptd_tfm);
 		kernel_fpu_begin();
 		ret = cryptd_child->base.crt_aead.encrypt(req);
 		kernel_fpu_end();
@@ -1018,7 +1028,6 @@ static int rfc4106_decrypt(struct aead_request *req)
 	int ret;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(tfm);
-	struct crypto_aead *cryptd_child = cryptd_aead_child(ctx->cryptd_tfm);
 
 	if (!irq_fpu_usable()) {
 		struct aead_request *cryptd_req =
@@ -1027,6 +1036,7 @@ static int rfc4106_decrypt(struct aead_request *req)
 		aead_request_set_tfm(cryptd_req, &ctx->cryptd_tfm->base);
 		return crypto_aead_decrypt(cryptd_req);
 	} else {
+		struct crypto_aead *cryptd_child = cryptd_aead_child(ctx->cryptd_tfm);
 		kernel_fpu_begin();
 		ret = cryptd_child->base.crt_aead.decrypt(req);
 		kernel_fpu_end();
-- 
1.7.4

--------------------------------------------------------------
Intel Shannon Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263
Business address: Dromore House, East Park, Shannon, Co. Clare

This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). Any review or distribution by others is strictly prohibited. If you are not the intended recipient, please contact the sender and delete all copies.


