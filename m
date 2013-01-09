Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933908Ab3AIVDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:03:35 -0500
Received: from mail.kernel.org ([198.145.19.201]:43302 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933821Ab3AIUkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:40:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 079/123] sparc64: Fix AES ctr mode block size.
Date: Wed,  9 Jan 2013 12:35:18 -0800
Message-Id: <20130109201508.746567176@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit a8d97cef2168ffe5af1aeed6bf6cdc3ce53f3d0b ]

Like the generic versions, we need to support a block size
of '1' for CTR mode AES.

This was discovered thanks to all of the new test cases added by
Jussi Kivilinna.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/crypto/aes_glue.c |   27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

--- a/arch/sparc/crypto/aes_glue.c
+++ b/arch/sparc/crypto/aes_glue.c
@@ -329,6 +329,22 @@ static int cbc_decrypt(struct blkcipher_
 	return err;
 }
 
+static void ctr_crypt_final(struct crypto_sparc64_aes_ctx *ctx,
+			    struct blkcipher_walk *walk)
+{
+	u8 *ctrblk = walk->iv;
+	u64 keystream[AES_BLOCK_SIZE / sizeof(u64)];
+	u8 *src = walk->src.virt.addr;
+	u8 *dst = walk->dst.virt.addr;
+	unsigned int nbytes = walk->nbytes;
+
+	ctx->ops->ecb_encrypt(&ctx->key[0], (const u64 *)ctrblk,
+			      keystream, AES_BLOCK_SIZE);
+	crypto_xor((u8 *) keystream, src, nbytes);
+	memcpy(dst, keystream, nbytes);
+	crypto_inc(ctrblk, AES_BLOCK_SIZE);
+}
+
 static int ctr_crypt(struct blkcipher_desc *desc,
 		     struct scatterlist *dst, struct scatterlist *src,
 		     unsigned int nbytes)
@@ -338,10 +354,11 @@ static int ctr_crypt(struct blkcipher_de
 	int err;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
+	err = blkcipher_walk_virt_block(desc, &walk, AES_BLOCK_SIZE);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	ctx->ops->load_encrypt_keys(&ctx->key[0]);
-	while ((nbytes = walk.nbytes)) {
+	while ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE) {
 		unsigned int block_len = nbytes & AES_BLOCK_MASK;
 
 		if (likely(block_len)) {
@@ -353,6 +370,10 @@ static int ctr_crypt(struct blkcipher_de
 		nbytes &= AES_BLOCK_SIZE - 1;
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
+	if (walk.nbytes) {
+		ctr_crypt_final(ctx, &walk);
+		err = blkcipher_walk_done(desc, &walk, 0);
+	}
 	fprs_write(0);
 	return err;
 }
@@ -418,7 +439,7 @@ static struct crypto_alg algs[] = { {
 	.cra_driver_name	= "ctr-aes-sparc64",
 	.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
 	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_blocksize		= 1,
 	.cra_ctxsize		= sizeof(struct crypto_sparc64_aes_ctx),
 	.cra_alignmask		= 7,
 	.cra_type		= &crypto_blkcipher_type,


