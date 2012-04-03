Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab2DCLf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 07:35:58 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:35712
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752507Ab2DCLfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 07:35:04 -0400
Date: Tue, 3 Apr 2012 13:35:02 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Guillaume LECERF <glecerf@gmail.com>
cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] UBIFS: Add cryptographic functionality when a key is
 passed to the compress / decompress functions
In-Reply-To: <CAJpamw7rXn_tLcFSE07AK4nrh9QXLBNzuehzLhB+rUbMv9UePA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1204031334460.4560@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net> <alpine.DEB.2.00.1202202112220.21022@eristoteles.iwoars.net> <1330531826.3545.128.camel@sauron.fi.intel.com> <alpine.DEB.2.00.1203191635030.22256@eristoteles.iwoars.net>
 <1332511796.18717.72.camel@sauron.fi.intel.com> <alpine.DEB.2.00.1203231739330.22944@eristoteles.iwoars.net> <1332521515.22278.2.camel@sauron.fi.intel.com> <alpine.DEB.2.00.1203252302310.5527@eristoteles.iwoars.net> <alpine.DEB.2.00.1203252325100.5527@eristoteles.iwoars.net>
 <1332837188.31549.14.camel@sauron.fi.intel.com> <alpine.DEB.2.00.1203291639200.912@eristoteles.iwoars.net> <1333377383.22146.14.camel@sauron.fi.intel.com> <alpine.DEB.2.00.1204021645070.29393@eristoteles.iwoars.net> <1333378674.22146.18.camel@sauron.fi.intel.com>
 <alpine.DEB.2.00.1204031228470.4560@eristoteles.iwoars.net> <CAJpamw7rXn_tLcFSE07AK4nrh9QXLBNzuehzLhB+rUbMv9UePA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without the goto:

Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
---
 fs/ubifs/compress.c |   74 ++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/ubifs/ubifs.h    |    8 +++++-
 2 files changed, 77 insertions(+), 5 deletions(-)

diff --git a/fs/ubifs/compress.c b/fs/ubifs/compress.c
index b796b8d..61fe584 100644
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
@@ -75,6 +78,53 @@ static struct ubifs_compressor zlib_compr = {
 struct ubifs_compressor *ubifs_compressors[UBIFS_COMPR_TYPES_CNT];

 /**
+ * ubifs_aes_crypt - encrypt / decrypt data.
+ * @str: data to crypt
+ * @len: length of the data
+ * @crypto_key: the cryptographic key to use to crypt the data
+ * @iv: the initialization vector to use
+ *
+ * This function applies aes encryption to the data. It is done in counter
+ * mode, which means that encryption and decryption are the same operation,
+ * i.e., it XORs the same generated bitstream, so it can be used both for
+ * encryption / decryption. The operation is done in-place, so str mutates.
+ * Both crypto_key and iv are valid pointers to a buffer of length
+ * UBIFS_CRYPTO_KEYSIZE.
+ */
+int ubifs_aes_crypt(void *str, int len, u8 *crypto_key, u8 *iv)
+{
+	struct crypto_blkcipher *tfm;
+	struct blkcipher_desc desc;
+	struct scatterlist sg;
+	int err = 0;
+
+	tfm = crypto_alloc_blkcipher(UBIFS_CRYPTO_ALGORITHM, 0, 0);
+	if (IS_ERR(tfm)) {
+		ubifs_err("failed to load transform for aes: %ld",
+			  PTR_ERR(tfm));
+		return err;
+	}
+
+	err = crypto_blkcipher_setkey(tfm, crypto_key, UBIFS_CRYPTO_KEYSIZE);
+	desc.tfm = tfm;
+	desc.flags = 0;
+	if (err) {
+		ubifs_err("crypto_blkcipher_setkey() failed  flags=%#x",
+			  crypto_blkcipher_get_flags(tfm));
+		return err;
+	}
+
+	memset(&sg, 0, sizeof(struct scatterlist));
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
@@ -126,13 +176,20 @@ void ubifs_compress(const void *in_buf, int in_len, void *out_buf, int *out_len,
 	 */
 	if (in_len - *out_len < UBIFS_MIN_COMPRESS_DIFF)
 		goto no_compr;
-
-	return;
+	goto encrypt;

 no_compr:
 	memcpy(out_buf, in_buf, in_len);
 	*out_len = in_len;
 	*compr_type = UBIFS_COMPR_NONE;
+
+encrypt:
+	if (crypto_key) {
+		u8 iv[UBIFS_CRYPTO_KEYSIZE];
+
+		memset(iv, 0, UBIFS_CRYPTO_KEYSIZE);
+		ubifs_aes_crypt(out_buf, *out_len, crypto_key, iv);
+	}
 }

 /**
@@ -148,8 +205,10 @@ no_compr:
  * This function decompresses data from buffer @in_buf into buffer @out_buf.
  * The length of the uncompressed data is returned in @out_len. This functions
  * returns %0 on success or a negative error code on failure.
+ *
+ * WARNING: this function may modify the contents of in_buf when executing.
  */
-int ubifs_decompress(const void *in_buf, int in_len, void *out_buf,
+int ubifs_decompress(void *in_buf, int in_len, void *out_buf,
 		     int *out_len, int compr_type, u8 *crypto_key)
 {
 	int err;
@@ -167,6 +226,13 @@ int ubifs_decompress(const void *in_buf, int in_len, void *out_buf,
 		return -EINVAL;
 	}

+	if (crypto_key) {
+		u8 iv[UBIFS_CRYPTO_KEYSIZE];
+
+		memset(iv, 0, UBIFS_CRYPTO_KEYSIZE);
+		ubifs_aes_crypt(in_buf, in_len, crypto_key, iv);
+	}
+
 	if (compr_type == UBIFS_COMPR_NONE) {
 		memcpy(out_buf, in_buf, in_len);
 		*out_len = in_len;
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 3ed12be..84d2c49 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -160,6 +160,11 @@
 /* Maximum number of data nodes to bulk-read */
 #define UBIFS_MAX_BULK_READ 32

+/* 128 bit key size in bytes for UBIFS */
+#define UBIFS_CRYPTO_KEYSIZE 16
+/* AES in counter mode is the encryption algorithm. */
+#define UBIFS_CRYPTO_ALGORITHM "ctr(aes)"
+
 /*
  * Lockdep classes for UBIFS inode @ui_mutex.
  */
@@ -1771,9 +1776,10 @@ long ubifs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 /* compressor.c */
 int __init ubifs_compressors_init(void);
 void ubifs_compressors_exit(void);
+int ubifs_aes_crypt(void *str, int len, u8 *crypto_key, u8 *iv);
 void ubifs_compress(const void *in_buf, int in_len, void *out_buf, int *out_len,
 		    int *compr_type, u8 *crypto_key);
-int ubifs_decompress(const void *buf, int len, void *out, int *out_len,
+int ubifs_decompress(void *buf, int len, void *out, int *out_len,
 		     int compr_type, u8 *crypto_key);

 #include "debug.h"
-- 
1.7.5.4

