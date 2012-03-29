Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933228Ab2C2Ojz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 10:39:55 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:43744
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752705Ab2C2Oju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 10:39:50 -0400
Date: Thu, 29 Mar 2012 16:39:48 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [patch] UBIFS: Add cryptographic functionality when a key is passed
 to the compress / decompress functions
In-Reply-To: <1332837188.31549.14.camel@sauron.fi.intel.com>
Message-ID: <alpine.DEB.2.00.1203291639200.912@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>     <alpine.DEB.2.00.1202202112220.21022@eristoteles.iwoars.net>    <1330531826.3545.128.camel@sauron.fi.intel.com>    <alpine.DEB.2.00.1203191635030.22256@eristoteles.iwoars.net>  
 <1332511796.18717.72.camel@sauron.fi.intel.com>   <alpine.DEB.2.00.1203231739330.22944@eristoteles.iwoars.net>  <1332521515.22278.2.camel@sauron.fi.intel.com>  <alpine.DEB.2.00.1203252302310.5527@eristoteles.iwoars.net>  <alpine.DEB.2.00.1203252325100.5527@eristoteles.iwoars.net>
 <1332837188.31549.14.camel@sauron.fi.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a function to perform AES encryption. The compress and
decompress routines use this function if they are called with a non-NULL
key parameter. It uses AES counter mode (where encryption and decryption
are the same function) and performs the operation in place on the data. It
uses a default IV of 0, since each key is only evey used to encrypt one
data item the IV does not matter.

The const qualifier was removed from the decompress routine for the
following reason. Encrypted data is not compressable, so compression is
first applied then the result is encrypted. In the reverse, decryption is
first applied and the result decompressed. This means that either the
input buffer for decompression is used to perform an in-place decryption
before decompression, or a third buffer is added and data is copied around.


Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
---
 fs/ubifs/compress.c |   77 +++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/ubifs/ubifs.h    |   12 +++++++-
 2 files changed, 85 insertions(+), 4 deletions(-)

diff --git a/fs/ubifs/compress.c b/fs/ubifs/compress.c
index c91974a..f94cf21 100644
--- a/fs/ubifs/compress.c
+++ b/fs/ubifs/compress.c
@@ -27,9 +27,12 @@
  * decompression.
  */

-#include <linux/crypto.h>
 #include "ubifs.h"

+#include <linux/crypto.h>
+#include <linux/scatterlist.h>
+
+
 /* Fake description object for the "none" compressor */
 static struct ubifs_compressor none_compr = {
 	.compr_type = UBIFS_COMPR_NONE,
@@ -75,6 +78,55 @@ static struct ubifs_compressor zlib_compr = {
 struct ubifs_compressor *ubifs_compressors[UBIFS_COMPR_TYPES_CNT];

 /**
+ * ubifs_aes_crypt - encrypt / decrypt data.
+ * @str: data to crypt
+ * @len: length of the data
+ * @crypto_key: the cryptographic key to use to crypt the data
+ * @crypto_key_len: the length of the crypto_key
+ * @iv: the initialization vector to use
+ * @ivlen: the length of the initialization vector
+ *
+ * This function applies aes encryption to the data. It is done in counter
+ * mode, which means that encryption and decryption are the same operation,
+ * i.e., it XORs the same generated bitstream, so it can be used both for
+ * encryption / decryption. The operation is done in-place, so str mutates.
+ */
+int ubifs_aes_crypt(void *str, int len, u8 *crypto_key,
+		    int crypto_key_len, u8 *iv, int ivlen)
+{
+	struct crypto_blkcipher *tfm;
+	struct blkcipher_desc desc;
+	struct scatterlist sg;
+	int err = 0;
+
+	tfm = crypto_alloc_blkcipher(UBIFS_CRYPTO_ALGORITHM, 0, 0);
+
+	if (IS_ERR(tfm)) {
+		ubifs_err("failed to load transform for aes: %ld",
+			  PTR_ERR(tfm));
+		return err;
+	}
+
+	err = crypto_blkcipher_setkey(tfm, crypto_key, crypto_key_len);
+	desc.tfm = tfm;
+	desc.flags = 0;
+	if (err) {
+		ubifs_err("crypto_blkcipher_setkey() failed  flags=%#x",
+			  crypto_blkcipher_get_flags(tfm));
+		return err;
+	}
+	memset(&sg, 0, sizeof(struct scatterlist));
+
+	sg_set_buf(&sg, str, len);
+	desc.info = iv;
+	err = crypto_blkcipher_encrypt(&desc, &sg, &sg, len);
+	crypto_free_blkcipher(tfm);
+	if (err)
+		return err;
+	return 0;
+}
+
+/**
  * ubifs_compress - compress data.
  * @in_buf: data to compress
  * @in_len: length of the data to compress
@@ -127,12 +179,22 @@ void ubifs_compress(const void *in_buf, int in_len, void *out_buf, int *out_len,
 	if (in_len - *out_len < UBIFS_MIN_COMPRESS_DIFF)
 		goto no_compr;

-	return;
+	goto encrypt;

 no_compr:
 	memcpy(out_buf, in_buf, in_len);
 	*out_len = in_len;
 	*compr_type = UBIFS_COMPR_NONE;
+	goto encrypt;
+
+encrypt:
+	if (crypto_key) {
+		u8 iv[UBIFS_CRYPTO_KEYSIZE];
+
+		memset(iv, 0, UBIFS_CRYPTO_KEYSIZE);
+		ubifs_aes_crypt(out_buf, *out_len, crypto_key,
+				UBIFS_CRYPTO_KEYSIZE, iv, UBIFS_CRYPTO_KEYSIZE);
+	}
 }

 /**
@@ -149,7 +211,7 @@ no_compr:
  * The length of the uncompressed data is returned in @out_len. This functions
  * returns %0 on success or a negative error code on failure.
  */
-int ubifs_decompress(const void *in_buf, int in_len, void *out_buf,
+int ubifs_decompress(void *in_buf, int in_len, void *out_buf,
 		     int *out_len, int compr_type, u8 *crypto_key)
 {
 	int err;
@@ -167,6 +229,15 @@ int ubifs_decompress(const void *in_buf, int in_len, void *out_buf,
 		return -EINVAL;
 	}

+	if (crypto_key) {
+		u8 iv[UBIFS_CRYPTO_KEYSIZE];
+
+		memset(iv, 0, UBIFS_CRYPTO_KEYSIZE);
+		ubifs_aes_crypt(in_buf, in_len, crypto_key,
+				UBIFS_CRYPTO_KEYSIZE, iv,
+				UBIFS_CRYPTO_KEYSIZE);
+	}
+
 	if (compr_type == UBIFS_COMPR_NONE) {
 		memcpy(out_buf, in_buf, in_len);
 		*out_len = in_len;
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index b425264..dbfa508 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -160,6 +160,14 @@
 /* Maximum number of data nodes to bulk-read */
 #define UBIFS_MAX_BULK_READ 32

+/* Size of 128 bits in bytes */
+#define AES_KEYSIZE_128 16
+
+/* Key size in bytes for UBIFS */
+#define UBIFS_CRYPTO_KEYSIZE AES_KEYSIZE_128
+/* AES in counter mode is the encryption algorithm. */
+#define UBIFS_CRYPTO_ALGORITHM "ctr(aes)"
+
 /*
  * Lockdep classes for UBIFS inode @ui_mutex.
  */
@@ -1771,9 +1779,11 @@ long ubifs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 /* compressor.c */
 int __init ubifs_compressors_init(void);
 void ubifs_compressors_exit(void);
+int ubifs_aes_crypt(void *str, int len, u8 *crypto_key, int crypto_key_len,
+		    u8 *iv, int ivlen);
 void ubifs_compress(const void *in_buf, int in_len, void *out_buf, int *out_len,
 		    int *compr_type, u8 *crypto_key);
-int ubifs_decompress(const void *buf, int len, void *out, int *out_len,
+int ubifs_decompress(void *buf, int len, void *out, int *out_len,
 		     int compr_type, u8 *crypto_key);

 #include "debug.h"
-- 
1.7.5.4


