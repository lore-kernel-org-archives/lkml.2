Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab2JCFpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 01:45:45 -0400
Received: from havoc.gtf.org ([69.61.125.42]:59614 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab2JCFpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 01:45:43 -0400
Date: Wed, 3 Oct 2012 01:45:42 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-crypto@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, herbert@gondor.hengli.com.au,
        davem@davemloft.net
Subject: [PATCH v0] Add SHA-3 hash algorithm
Message-ID: <20121003054542.GA2416@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Whee -- SHA-3 is out!   I wanted to explore the new toy a bit, and
so, here is a blatantly untested rough draft of SHA-3 kernel support.

Why rough draft?  Because answers to the questions below will inform a
more polished version.

Code notes and questions:

1) tcrypt setup blatantly wrong.  What is the best setup here?  Define a
separate entry for each digest length?  Is there some special string
descriptor format that is desired, like "sha3-256" or "sha3(256)"?

2) Digest and block size are easily variable, as shown below...
do we want hand-craft individual versions for each -- sha3_256.c,
sha3_512.c, etc.?

3) Is it even feasible for struct shash_alg to have a dynamic (filled in
at context init time, not driver registration time) digestsize and
cra_blocksize?  That would permit a single shash_alg for all sha3.

4) Original implementation from readable_keccak.tgz (link below).  The
official sources have a bazillion different flavors for various
architectures and bit sizes, and the code is not pretty.  I wanted to
start small and readable, and _then_ branch out into x86[-64]-specific
versions, etc. as users and use cases appear.



Commit e52113b7b4ace50ab586b426098c6d69d75c263a
Branch sha3
Repo git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/linux.git

References:
	http://keccak.noekeon.org/
	http://www.mjos.fi/dist/readable_keccak.tgz
	http://www.nist.gov/itl/csd/sha-100212.cfm

Not-signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 crypto/Kconfig        |    6 +
 crypto/Makefile       |    1 
 crypto/sha3_generic.c |  280 ++++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/tcrypt.c       |   14 ++
 include/crypto/sha3.h |   26 ++++
 5 files changed, 326 insertions(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index a323805..97f5e75 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -457,6 +457,12 @@ config CRYPTO_SHA512
 	  This code also includes SHA-384, a 384 bit hash with 192 bits
 	  of security against collision attacks.
 
+config CRYPTO_SHA3
+	tristate "SHA3 digest algorithm"
+	select CRYPTO_HASH
+	help
+	  SHA-3 secure hash standard.
+
 config CRYPTO_TGR192
 	tristate "Tiger digest algorithms"
 	select CRYPTO_HASH
diff --git a/crypto/Makefile b/crypto/Makefile
index 30f33d6..65150d1 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -45,6 +45,7 @@ obj-$(CONFIG_CRYPTO_RMD320) += rmd320.o
 obj-$(CONFIG_CRYPTO_SHA1) += sha1_generic.o
 obj-$(CONFIG_CRYPTO_SHA256) += sha256_generic.o
 obj-$(CONFIG_CRYPTO_SHA512) += sha512_generic.o
+obj-$(CONFIG_CRYPTO_SHA3) += sha3_generic.o
 obj-$(CONFIG_CRYPTO_WP512) += wp512.o
 obj-$(CONFIG_CRYPTO_TGR192) += tgr192.o
 obj-$(CONFIG_CRYPTO_GF128MUL) += gf128mul.o
diff --git a/crypto/sha3_generic.c b/crypto/sha3_generic.c
new file mode 100644
index 0000000..9255ea1
--- /dev/null
+++ b/crypto/sha3_generic.c
@@ -0,0 +1,280 @@
+
+#include <crypto/internal/hash.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <crypto/sha3.h>
+#include <asm/byteorder.h>
+
+#define KECCAK_ROUNDS 24
+
+#define ROTL64(x, y) (((x) << (y)) | ((x) >> (64 - (y))))
+
+static const u64 keccakf_rndc[24] = 
+{
+	0x0000000000000001, 0x0000000000008082, 0x800000000000808a,
+	0x8000000080008000, 0x000000000000808b, 0x0000000080000001,
+	0x8000000080008081, 0x8000000000008009, 0x000000000000008a,
+	0x0000000000000088, 0x0000000080008009, 0x000000008000000a,
+	0x000000008000808b, 0x800000000000008b, 0x8000000000008089,
+	0x8000000000008003, 0x8000000000008002, 0x8000000000000080, 
+	0x000000000000800a, 0x800000008000000a, 0x8000000080008081,
+	0x8000000000008080, 0x0000000080000001, 0x8000000080008008
+};
+
+static const int keccakf_rotc[24] = 
+{
+	1,  3,  6,  10, 15, 21, 28, 36, 45, 55, 2,  14, 
+	27, 41, 56, 8,  25, 43, 62, 18, 39, 61, 20, 44
+};
+
+static const int keccakf_piln[24] = 
+{
+	10, 7,  11, 17, 18, 3, 5,  16, 8,  21, 24, 4, 
+	15, 23, 19, 13, 12, 2, 20, 14, 22, 9,  6,  1 
+};
+
+// update the state with given number of rounds
+
+static void keccakf(u64 st[25], int rounds)
+{
+	int i, j, round;
+	u64 t, bc[5];
+
+	for (round = 0; round < rounds; round++) {
+
+		// Theta
+		for (i = 0; i < 5; i++)	 
+			bc[i] = st[i] ^ st[i + 5] ^ st[i + 10] ^ st[i + 15] ^ st[i + 20];
+
+		for (i = 0; i < 5; i++) {
+			t = bc[(i + 4) % 5] ^ ROTL64(bc[(i + 1) % 5], 1);
+			for (j = 0; j < 25; j += 5)
+				st[j + i] ^= t;
+		}
+
+		// Rho Pi
+		t = st[1];
+		for (i = 0; i < 24; i++) {
+			j = keccakf_piln[i];
+			bc[0] = st[j];
+			st[j] = ROTL64(t, keccakf_rotc[i]);
+			t = bc[0];
+		}
+
+		//  Chi
+		for (j = 0; j < 25; j += 5) {
+			for (i = 0; i < 5; i++)
+				bc[i] = st[j + i];
+			for (i = 0; i < 5; i++)
+				st[j + i] ^= (~bc[(i + 1) % 5]) & bc[(i + 2) % 5];
+		}
+
+		//  Iota
+		st[0] ^= keccakf_rndc[round];
+	}
+}
+
+static void sha3_init(struct sha3_state *sctx, unsigned int digest_sz)
+{
+	memset(sctx, 0, sizeof(*sctx));
+	sctx->md_len = digest_sz;
+	sctx->rsiz = 200 - 2 * digest_sz;
+	sctx->rsizw = sctx->rsiz / 8;
+}
+
+static int sha3_224_init(struct shash_desc *desc)
+{
+	struct sha3_state *sctx = shash_desc_ctx(desc);
+	sha3_init(sctx, SHA3_224_DIGEST_SIZE);
+	return 0;
+}
+
+static int sha3_256_init(struct shash_desc *desc)
+{
+	struct sha3_state *sctx = shash_desc_ctx(desc);
+	sha3_init(sctx, SHA3_256_DIGEST_SIZE);
+	return 0;
+}
+
+static int sha3_384_init(struct shash_desc *desc)
+{
+	struct sha3_state *sctx = shash_desc_ctx(desc);
+	sha3_init(sctx, SHA3_384_DIGEST_SIZE);
+	return 0;
+}
+
+static int sha3_512_init(struct shash_desc *desc)
+{
+	struct sha3_state *sctx = shash_desc_ctx(desc);
+	sha3_init(sctx, SHA3_512_DIGEST_SIZE);
+	return 0;
+}
+
+static int sha3_update(struct shash_desc *desc, const u8 *data,
+		       unsigned int len)
+{
+	struct sha3_state *sctx = shash_desc_ctx(desc);
+	unsigned int done;
+	const u8 *src;
+
+	done = 0;
+	src = data;
+
+	if ((sctx->partial + len) > (sctx->rsiz - 1)) {
+		if (sctx->partial) {
+			done = -sctx->partial;
+			memcpy(sctx->buf + sctx->partial, data,
+			       done + sctx->rsiz);
+			src = sctx->buf;
+		}
+
+		do {
+			unsigned int i;
+
+			for (i = 0; i < sctx->rsizw; i++)
+				sctx->st[i] ^= ((u64 *) src)[i];
+			keccakf(sctx->st, KECCAK_ROUNDS);
+
+			done += sctx->rsiz;
+			src = data + done;
+		} while (done + (sctx->rsiz - 1) < len);
+
+		sctx->partial = 0;
+	}
+	memcpy(sctx->buf + sctx->partial, src, len - done);
+	sctx->partial += (len - done);
+
+	return 0;
+}
+
+static int sha3_final(struct shash_desc *desc, u8 *out)
+{
+	struct sha3_state *sctx = shash_desc_ctx(desc);
+	unsigned int i, inlen = sctx->partial;
+
+	sctx->buf[inlen++] = 1;
+	memset(sctx->buf + inlen, 0, sctx->rsiz - inlen);
+	sctx->buf[sctx->rsiz - 1] |= 0x80;
+
+	for (i = 0; i < sctx->rsizw; i++)
+		sctx->st[i] ^= ((u64 *) sctx->buf)[i];
+
+	keccakf(sctx->st, KECCAK_ROUNDS);
+
+	for (i = 0; i < sctx->rsizw; i++)
+		sctx->st[i] = cpu_to_le64(sctx->st[i]);
+
+	memcpy(out, sctx->st, sctx->md_len);
+
+	memset(sctx, 0, sizeof(*sctx));
+	return 0;
+}
+
+static struct shash_alg sha3_224 = {
+	.digestsize	=	SHA3_224_DIGEST_SIZE,
+	.init		=	sha3_224_init,
+	.update		=	sha3_update,
+	.final		=	sha3_final,
+	.descsize	=	sizeof(struct sha3_state),
+	.base		=	{
+		.cra_name	=	"sha3-224",
+		.cra_driver_name=	"sha3-224-generic",
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA3_224_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
+};
+
+static struct shash_alg sha3_256 = {
+	.digestsize	=	SHA3_256_DIGEST_SIZE,
+	.init		=	sha3_256_init,
+	.update		=	sha3_update,
+	.final		=	sha3_final,
+	.descsize	=	sizeof(struct sha3_state),
+	.base		=	{
+		.cra_name	=	"sha3-256",
+		.cra_driver_name=	"sha3-256-generic",
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA3_256_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
+};
+
+static struct shash_alg sha3_384 = {
+	.digestsize	=	SHA3_384_DIGEST_SIZE,
+	.init		=	sha3_384_init,
+	.update		=	sha3_update,
+	.final		=	sha3_final,
+	.descsize	=	sizeof(struct sha3_state),
+	.base		=	{
+		.cra_name	=	"sha3-384",
+		.cra_driver_name=	"sha3-384-generic",
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA3_384_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
+};
+
+static struct shash_alg sha3_512 = {
+	.digestsize	=	SHA3_512_DIGEST_SIZE,
+	.init		=	sha3_512_init,
+	.update		=	sha3_update,
+	.final		=	sha3_final,
+	.descsize	=	sizeof(struct sha3_state),
+	.base		=	{
+		.cra_name	=	"sha3-512",
+		.cra_driver_name=	"sha3-512-generic",
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA3_512_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
+};
+
+static int __init sha3_generic_mod_init(void)
+{
+	int ret;
+
+	ret = crypto_register_shash(&sha3_224);
+	if (ret < 0)
+		goto err_out;
+	ret = crypto_register_shash(&sha3_256);
+	if (ret < 0)
+		goto err_out_224;
+	ret = crypto_register_shash(&sha3_384);
+	if (ret < 0)
+		goto err_out_256;
+	ret = crypto_register_shash(&sha3_512);
+	if (ret < 0)
+		goto err_out_384;
+
+	return 0;
+
+err_out_384:
+	crypto_unregister_shash(&sha3_384);
+err_out_256:
+	crypto_unregister_shash(&sha3_256);
+err_out_224:
+	crypto_unregister_shash(&sha3_224);
+err_out:
+	return ret;
+}
+
+static void __exit sha3_generic_mod_fini(void)
+{
+	crypto_unregister_shash(&sha3_224);
+	crypto_unregister_shash(&sha3_256);
+	crypto_unregister_shash(&sha3_384);
+	crypto_unregister_shash(&sha3_512);
+}
+
+module_init(sha3_generic_mod_init);
+module_exit(sha3_generic_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("SHA-3 Secure Hash Algorithm");
+
+MODULE_ALIAS("sha3-224");
+MODULE_ALIAS("sha3-256");
+MODULE_ALIAS("sha3-384");
+MODULE_ALIAS("sha3-512");
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 5cf2ccb..4fa2a4c 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -64,7 +64,7 @@ static char *check[] = {
 	"cast6", "arc4", "michael_mic", "deflate", "crc32c", "tea", "xtea",
 	"khazad", "wp512", "wp384", "wp256", "tnepres", "xeta",  "fcrypt",
 	"camellia", "seed", "salsa20", "rmd128", "rmd160", "rmd256", "rmd320",
-	"lzo", "cts", "zlib", NULL
+	"lzo", "cts", "zlib", "sha3", NULL
 };
 
 static int test_cipher_jiffies(struct blkcipher_desc *desc, int enc,
@@ -1165,6 +1165,10 @@ static int do_test(int m)
 		ret += tcrypt_test("rfc4309(ccm(aes))");
 		break;
 
+	case 46:
+		ret += tcrypt_test("sha3");
+		break;
+
 	case 100:
 		ret += tcrypt_test("hmac(md5)");
 		break;
@@ -1434,6 +1438,10 @@ static int do_test(int m)
 		test_hash_speed("ghash-generic", sec, hash_speed_template_16);
 		if (mode > 300 && mode < 400) break;
 
+	case 319:
+		test_hash_speed("sha3", sec, generic_hash_speed_template);
+		if (mode > 300 && mode < 400) break;
+
 	case 399:
 		break;
 
@@ -1508,6 +1516,10 @@ static int do_test(int m)
 		test_ahash_speed("rmd320", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 
+	case 418:
+		test_ahash_speed("sha3", sec, generic_hash_speed_template);
+		if (mode > 400 && mode < 500) break;
+
 	case 499:
 		break;
 
diff --git a/include/crypto/sha3.h b/include/crypto/sha3.h
new file mode 100644
index 0000000..3004e94
--- /dev/null
+++ b/include/crypto/sha3.h
@@ -0,0 +1,26 @@
+#ifndef __CRYPTO_SHA3_H__
+#define __CRYPTO_SHA3_H__
+
+#define SHA3_224_DIGEST_SIZE	(224 / 8)
+#define SHA3_224_BLOCK_SIZE	(200 - 2 * SHA3_224_DIGEST_SIZE)
+
+#define SHA3_256_DIGEST_SIZE	(256 / 8)
+#define SHA3_256_BLOCK_SIZE	(200 - 2 * SHA3_256_DIGEST_SIZE)
+
+#define SHA3_384_DIGEST_SIZE	(384 / 8)
+#define SHA3_384_BLOCK_SIZE	(200 - 2 * SHA3_384_DIGEST_SIZE)
+
+#define SHA3_512_DIGEST_SIZE	(512 / 8)
+#define SHA3_512_BLOCK_SIZE	(200 - 2 * SHA3_512_DIGEST_SIZE)
+
+struct sha3_state {
+	u64		st[25];
+	unsigned int	md_len;
+	unsigned int	rsiz;
+	unsigned int	rsizw;
+
+	unsigned int	partial;
+	u8		buf[SHA3_224_BLOCK_SIZE];
+};
+
+#endif /* __CRYPTO_SHA3_H__ */
