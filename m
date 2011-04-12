Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab1DLOhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:37:42 -0400
Received: from kroah.org ([198.145.64.141]:57420 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756817Ab1DLOhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:37:40 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:49 2011
Message-Id: <20110412143549.730291946@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Adrian Hoban <adrian.hoban@intel.com>,
        Aidan OMahony <aidan.o.mahony@intel.com>,
        Gabriele Paoloni <gabriele.paoloni@intel.com>,
        Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [017/105] crypto: aesni-intel - fixed problem with packets that are not multiple of 64bytes
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tadeusz Struk <tadeusz.struk@intel.com>

commit 60af520cf264ea26b2af3a6871bbd71850522aea upstream.

This patch fixes problem with packets that are not multiple of 64bytes.

Signed-off-by: Adrian Hoban <adrian.hoban@intel.com>
Signed-off-by: Aidan O'Mahony <aidan.o.mahony@intel.com>
Signed-off-by: Gabriele Paoloni <gabriele.paoloni@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/crypto/aesni-intel_asm.S  |    5 ++++-
 arch/x86/crypto/aesni-intel_glue.c |   14 ++++++++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

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
 
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -828,9 +828,15 @@ static int rfc4106_init(struct crypto_tf
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
@@ -925,6 +931,9 @@ static int rfc4106_set_key(struct crypto
 	int ret = 0;
 	struct crypto_tfm *tfm = crypto_aead_tfm(parent);
 	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(parent);
+	struct crypto_aead *cryptd_child = cryptd_aead_child(ctx->cryptd_tfm);
+	struct aesni_rfc4106_gcm_ctx *child_ctx =
+                                 aesni_rfc4106_gcm_ctx_get(cryptd_child);
 	u8 *new_key_mem = NULL;
 
 	if (key_len < 4) {
@@ -968,6 +977,7 @@ static int rfc4106_set_key(struct crypto
 		goto exit;
 	}
 	ret = rfc4106_set_hash_subkey(ctx->hash_subkey, key, key_len);
+	memcpy(child_ctx, ctx, sizeof(*ctx));
 exit:
 	kfree(new_key_mem);
 	return ret;
@@ -999,7 +1009,6 @@ static int rfc4106_encrypt(struct aead_r
 	int ret;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(tfm);
-	struct crypto_aead *cryptd_child = cryptd_aead_child(ctx->cryptd_tfm);
 
 	if (!irq_fpu_usable()) {
 		struct aead_request *cryptd_req =
@@ -1008,6 +1017,7 @@ static int rfc4106_encrypt(struct aead_r
 		aead_request_set_tfm(cryptd_req, &ctx->cryptd_tfm->base);
 		return crypto_aead_encrypt(cryptd_req);
 	} else {
+		struct crypto_aead *cryptd_child = cryptd_aead_child(ctx->cryptd_tfm);
 		kernel_fpu_begin();
 		ret = cryptd_child->base.crt_aead.encrypt(req);
 		kernel_fpu_end();
@@ -1020,7 +1030,6 @@ static int rfc4106_decrypt(struct aead_r
 	int ret;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(tfm);
-	struct crypto_aead *cryptd_child = cryptd_aead_child(ctx->cryptd_tfm);
 
 	if (!irq_fpu_usable()) {
 		struct aead_request *cryptd_req =
@@ -1029,6 +1038,7 @@ static int rfc4106_decrypt(struct aead_r
 		aead_request_set_tfm(cryptd_req, &ctx->cryptd_tfm->base);
 		return crypto_aead_decrypt(cryptd_req);
 	} else {
+		struct crypto_aead *cryptd_child = cryptd_aead_child(ctx->cryptd_tfm);
 		kernel_fpu_begin();
 		ret = cryptd_child->base.crt_aead.decrypt(req);
 		kernel_fpu_end();


