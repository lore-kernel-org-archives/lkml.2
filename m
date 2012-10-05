Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab2JEVYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 17:24:18 -0400
Received: from mail-vb0-f74.google.com ([209.85.212.74]:51809 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab2JEVYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 17:24:16 -0400
Subject: [PATCH] crypto: Make VMAC work when blocks aren't aligned
To: Shane Wang <shane.wang@intel.com>, Joseph Cihula <joseph.cihula@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        LKML <linux-kernel@vger.kernel.org>
From: Salman Qazi <sqazi@google.com>
Date: Fri, 05 Oct 2012 14:24:14 -0700
Message-ID: <20121005212414.31689.25033.stgit@dungbeetle.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VMAC implementation, as it is, does not work with blocks that
are not multiples of 128-bytes.  Furthermore, this is a problem
when using the implementation on scatterlists, even
when the complete plain text is 128-byte multiple, as the pieces
that get passed to vmac_update can be pretty much any size.

I also added test cases for unaligned blocks.

Signed-off-by: Salman Qazi <sqazi@google.com>
---
 crypto/testmgr.h      |   33 ++++++++++++++++++++++++++++++++-
 crypto/vmac.c         |   47 +++++++++++++++++++++++++++++++++++++++++++----
 include/crypto/vmac.h |    2 ++
 3 files changed, 77 insertions(+), 5 deletions(-)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 76d7f6c..f8365e9 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -1707,7 +1707,7 @@ static struct hash_testvec aes_xcbc128_tv_template[] = {
 	}
 };
 
-#define VMAC_AES_TEST_VECTORS	8
+#define VMAC_AES_TEST_VECTORS	11
 static char vmac_string1[128] = {'\x01', '\x01', '\x01', '\x01',
 				'\x02', '\x03', '\x02', '\x02',
 				'\x02', '\x04', '\x01', '\x07',
@@ -1723,6 +1723,19 @@ static char vmac_string3[128] = {'a', 'b', 'c', 'a', 'b', 'c',
 				'a', 'b', 'c', 'a', 'b', 'c',
 				};
 
+static char vmac_string4[17] = {'b', 'c', 'e', 'f',
+				'i', 'j', 'l', 'm',
+				'o', 'p', 'r', 's',
+				't', 'u', 'w', 'x', 'z'};
+
+static char vmac_string5[127] = {'r', 'm', 'b', 't', 'c',
+				 'o', 'l', 'k', ']', '%',
+				 '9', '2', '7', '!', 'A'};
+
+static char vmac_string6[129] = {'p', 't', '*', '7', 'l',
+				 'i', '!', '#', 'w', '0',
+				 'z', '/', '4', 'A', 'n'};
+
 static struct hash_testvec aes_vmac128_tv_template[] = {
 	{
 		.key	= "\x00\x01\x02\x03\x04\x05\x06\x07"
@@ -1776,6 +1789,24 @@ static struct hash_testvec aes_vmac128_tv_template[] = {
 		.digest = "\x8b\x32\x8f\xe1\xed\x8f\xfa\xd4",
 		.psize  = 128,
 		.ksize  = 16,
+	}, {
+		.key = "a09b5cd!f#07K\x00\x00\x00",
+		.plaintext = vmac_string4,
+		.digest = "\xab\xa5\x0f\xea\x42\x4e\xa1\x5f",
+		.psize = sizeof(vmac_string4),
+		.ksize = 16,
+	}, {
+		.key = "a09b5cd!f#07K\x00\x00\x00",
+		.plaintext = vmac_string5,
+		.digest = "\x25\x31\x98\xbc\x1d\xe8\x67\x60",
+		.psize = sizeof(vmac_string5),
+		.ksize = 16,
+	}, {
+		.key = "a09b5cd!f#07K\x00\x00\x00",
+		.plaintext = vmac_string6,
+		.digest = "\xc4\xae\x9b\x47\x95\x65\xeb\x41",
+		.psize = sizeof(vmac_string6),
+		.ksize = 16,
 	},
 };
 
diff --git a/crypto/vmac.c b/crypto/vmac.c
index f2338ca..2eb11a3 100644
--- a/crypto/vmac.c
+++ b/crypto/vmac.c
@@ -375,6 +375,11 @@ static void vhash_update(const unsigned char *m,
 	u64 pkh = ctx->polykey[0];
 	u64 pkl = ctx->polykey[1];
 
+	if (!mbytes)
+		return;
+
+	BUG_ON(mbytes % VMAC_NHBYTES);
+
 	mptr = (u64 *)m;
 	i = mbytes / VMAC_NHBYTES;  /* Must be non-zero */
 
@@ -454,7 +459,7 @@ do_l3:
 }
 
 static u64 vmac(unsigned char m[], unsigned int mbytes,
-			unsigned char n[16], u64 *tagl,
+			const unsigned char n[16], u64 *tagl,
 			struct vmac_ctx_t *ctx)
 {
 	u64 *in_n, *out_p;
@@ -559,8 +564,33 @@ static int vmac_update(struct shash_desc *pdesc, const u8 *p,
 {
 	struct crypto_shash *parent = pdesc->tfm;
 	struct vmac_ctx_t *ctx = crypto_shash_ctx(parent);
+	int expand;
+	int min;
+
+	expand = VMAC_NHBYTES - ctx->partial_size > 0 ?
+			VMAC_NHBYTES - ctx->partial_size : 0;
+
+	min = len < expand ? len : expand;
+
+	memcpy(ctx->partial + ctx->partial_size, p, min);
+	ctx->partial_size += min;
+
+	if (len < expand)
+		return 0;
 
-	vhash_update(p, len, &ctx->__vmac_ctx);
+	vhash_update(ctx->partial, VMAC_NHBYTES, &ctx->__vmac_ctx);
+	ctx->partial_size = 0;
+
+	len -= expand;
+	p += expand;
+
+	if (len % VMAC_NHBYTES) {
+		memcpy(ctx->partial, p + len - (len % VMAC_NHBYTES),
+			len % VMAC_NHBYTES);
+		ctx->partial_size = len % VMAC_NHBYTES;
+	}
+
+	vhash_update(p, len - len % VMAC_NHBYTES, &ctx->__vmac_ctx);
 
 	return 0;
 }
@@ -572,10 +602,20 @@ static int vmac_final(struct shash_desc *pdesc, u8 *out)
 	vmac_t mac;
 	u8 nonce[16] = {};
 
-	mac = vmac(NULL, 0, nonce, NULL, ctx);
+	/* vmac() ends up accessing outside the array bounds that
+	 * we specify.  In appears to access up to the next 2-word
+	 * boundary.  We'll just be uber cautious and zero the
+	 * unwritten bytes in the buffer.
+	 */
+	if (ctx->partial_size) {
+		memset(ctx->partial + ctx->partial_size, 0,
+			VMAC_NHBYTES - ctx->partial_size);
+	}
+	mac = vmac(ctx->partial, ctx->partial_size, nonce, NULL, ctx);
 	memcpy(out, &mac, sizeof(vmac_t));
 	memset(&mac, 0, sizeof(vmac_t));
 	memset(&ctx->__vmac_ctx, 0, sizeof(struct vmac_ctx));
+	ctx->partial_size = 0;
 	return 0;
 }
 
@@ -673,4 +713,3 @@ module_exit(vmac_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("VMAC hash algorithm");
-
diff --git a/include/crypto/vmac.h b/include/crypto/vmac.h
index c4467c5..6b700c7 100644
--- a/include/crypto/vmac.h
+++ b/include/crypto/vmac.h
@@ -56,6 +56,8 @@ typedef u64 vmac_t;
 struct vmac_ctx_t {
 	struct crypto_cipher *child;
 	struct vmac_ctx __vmac_ctx;
+	u8 partial[VMAC_NHBYTES];	/* partial block */
+	int partial_size;		/* size of the partial block */
 };
 
 #endif /* __CRYPTO_VMAC_H */

