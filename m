Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab2BWP3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 10:29:21 -0500
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:38791
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1751342Ab2BWP3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 10:29:20 -0500
Date: Thu, 23 Feb 2012 16:29:18 +0100 (CET)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch] Add encryption key parameter to compress/decompress
 functions
In-Reply-To: <alpine.DEB.2.00.1202231558400.13720@eristoteles.iwoars.net>
Message-ID: <alpine.DEB.2.00.1202231628360.13720@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net> <1329152067.22240.214.camel@sauron.fi.intel.com> <alpine.DEB.2.00.1202231558400.13720@eristoteles.iwoars.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends to interface for compression and decompression of data 
nodes to take a cryptographic key
as a parameter. If it is set to NULL, then the current behaviour persists. 
If it is non-null, then it is taken
as a pointer to an array of length UBIFSEC_KEYSIZE (=16 bytes) which 
contains the key to use to encrypt
the data node. Each data node should be encrypted with a separate key as 
it uses the same initialization vector  (of 0).

In all places where the compress/decompress are called, a NULL parameter 
is used, so it will have no effect on
deployed systems. It will be needed when adding secure deletion to UBIFS 
using individually encrypted data nodes.

It was tested by with hundred runs of integck along with power cut tests.

------

Signed-off-by: Joel Reardon<reardonj@inf.ethz.ch>
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/compress.c 
linux-3.2.1-ubifsec/fs/ubifs/compress.c
--- linux-3.2.1-vanilla/fs/ubifs/compress.c	2012-01-12 
20:42:45.000000000 +0100
+++ linux-3.2.1-ubifsec/fs/ubifs/compress.c	2012-02-23 
16:07:44.287023169 +0100
@@ -27,9 +27,11 @@
   * decompression.
   */

-#include <linux/crypto.h>
  #include "ubifs.h"

+#include <linux/crypto.h>
+#include <linux/scatterlist.h>
+
  /* Fake description object for the "none" compressor */
  static struct ubifs_compressor none_compr = {
  	.compr_type = UBIFS_COMPR_NONE,
@@ -74,6 +76,40 @@ static struct ubifs_compressor zlib_comp
  /* All UBIFS compressors */
  struct ubifs_compressor *ubifs_compressors[UBIFS_COMPR_TYPES_CNT];

+int ubifs_aes_crypt(u8 *str, int len, u8 *key, int keylen, u8 *iv, int 
ivlen)
+{
+	struct crypto_blkcipher *tfm;
+	struct blkcipher_desc desc;
+	struct scatterlist sg;
+	int err = 0;
+	tfm = crypto_alloc_blkcipher(UBIFSEC_CRYPTO_ALGORITHM, 0, 0);
+
+	if (IS_ERR(tfm)) {
+		ubifs_err("failed to load transform for aes: %ld",
+			  PTR_ERR(tfm));
+		return err;
+	}
+
+	err = crypto_blkcipher_setkey(tfm, key, keylen);
+	desc.tfm = tfm;
+	desc.flags = 0;
+	if (err) {
+		ubifs_err("setkey() failed  flags=%x",
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
+
  /**
   * ubifs_compress - compress data.
   * @in_buf: data to compress
@@ -93,7 +129,7 @@ struct ubifs_compressor *ubifs_compresso
   * buffer and %UBIFS_COMPR_NONE is returned in @compr_type.
   */
  void ubifs_compress(const void *in_buf, int in_len, void *out_buf, int 
*out_len,
-		    int *compr_type)
+		    int *compr_type, u8* key)
  {
  	int err;
  	struct ubifs_compressor *compr = ubifs_compressors[*compr_type];
@@ -115,7 +151,7 @@ void ubifs_compress(const void *in_buf,
  		ubifs_warn("cannot compress %d bytes, compressor %s, "
  			   "error %d, leave data uncompressed",
  			   in_len, compr->name, err);
-		 goto no_compr;
+		goto no_compr;
  	}

  	/*
@@ -124,13 +160,20 @@ void ubifs_compress(const void *in_buf,
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
+	goto encrypt;
+encrypt:
+	if (key) {
+		u8 iv[AES_KEYSIZE_128];
+		memset(iv, 0, AES_KEYSIZE_128);
+		ubifs_aes_crypt(out_buf, *out_len, key, AES_KEYSIZE_128,
+				iv, AES_KEYSIZE_128);
+	}
  }

  /**
@@ -145,8 +188,9 @@ no_compr:
   * The length of the uncompressed data is returned in @out_len. This 
functions
   * returns %0 on success or a negative error code on failure.
   */
-int ubifs_decompress(const void *in_buf, int in_len, void *out_buf,
-		     int *out_len, int compr_type)
+int ubifs_decompress(void *in_buf, int in_len, void *out_buf,
+		     int *out_len, int compr_type, u8* key)
+
  {
  	int err;
  	struct ubifs_compressor *compr;
@@ -163,6 +207,12 @@ int ubifs_decompress(const void *in_buf,
  		return -EINVAL;
  	}

+	if (key) {
+		u8 iv[AES_KEYSIZE_128];
+		memset(iv, 0, AES_KEYSIZE_128);
+		ubifs_aes_crypt(in_buf, in_len, key, AES_KEYSIZE_128,
+				iv, AES_KEYSIZE_128);
+	}
  	if (compr_type == UBIFS_COMPR_NONE) {
  		memcpy(out_buf, in_buf, in_len);
  		*out_len = in_len;
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/file.c linux-3.2.1-ubifsec/fs/ubifs/file.c
--- linux-3.2.1-vanilla/fs/ubifs/file.c	2012-01-12 20:42:45.000000000 
+0100
+++ linux-3.2.1-ubifsec/fs/ubifs/file.c	2012-02-23 16:15:48.607046613 
+0100
@@ -80,7 +80,7 @@ static int read_block(struct inode *inod
  	dlen = le32_to_cpu(dn->ch.len) - UBIFS_DATA_NODE_SZ;
  	out_len = UBIFS_BLOCK_SIZE;
  	err = ubifs_decompress(&dn->data, dlen, addr, &out_len,
-			       le16_to_cpu(dn->compr_type));
+			       le16_to_cpu(dn->compr_type), NULL);
  	if (err || len != out_len)
  		goto dump;

@@ -649,7 +649,8 @@ static int populate_page(struct ubifs_in
  			dlen = le32_to_cpu(dn->ch.len) - 
UBIFS_DATA_NODE_SZ;
  			out_len = UBIFS_BLOCK_SIZE;
  			err = ubifs_decompress(&dn->data, dlen, addr, 
&out_len,
- 
le16_to_cpu(dn->compr_type));
+ 
le16_to_cpu(dn->compr_type),
+					       NULL);
  			if (err || len != out_len)
  				goto out_err;

diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/journal.c 
linux-3.2.1-ubifsec/fs/ubifs/journal.c
--- linux-3.2.1-vanilla/fs/ubifs/journal.c	2012-01-12 
20:42:45.000000000 +0100
+++ linux-3.2.1-ubifsec/fs/ubifs/journal.c	2012-02-23 
16:15:05.415044519 +0100
@@ -728,7 +728,7 @@ int ubifs_jnl_write_data(struct ubifs_in
  		compr_type = ui->compr_type;

  	out_len = dlen - UBIFS_DATA_NODE_SZ;
-	ubifs_compress(buf, len, &data->data, &out_len, &compr_type);
+	ubifs_compress(buf, len, &data->data, &out_len, &compr_type, 
NULL);
  	ubifs_assert(out_len <= UBIFS_BLOCK_SIZE);

  	dlen = UBIFS_DATA_NODE_SZ + out_len;
@@ -1111,11 +1111,12 @@ static int recomp_data_node(struct ubifs

  	len = le32_to_cpu(dn->ch.len) - UBIFS_DATA_NODE_SZ;
  	compr_type = le16_to_cpu(dn->compr_type);
-	err = ubifs_decompress(&dn->data, len, buf, &out_len, compr_type);
+	err = ubifs_decompress(
+		&dn->data, len, buf, &out_len, compr_type, NULL);
  	if (err)
  		goto out;

-	ubifs_compress(buf, *new_len, &dn->data, &out_len, &compr_type);
+	ubifs_compress(buf, *new_len, &dn->data, &out_len, &compr_type, 
NULL);
  	ubifs_assert(out_len <= UBIFS_BLOCK_SIZE);
  	dn->compr_type = cpu_to_le16(compr_type);
  	dn->size = cpu_to_le32(*new_len);
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/ubifs.h linux-3.2.1-ubifsec/fs/ubifs/ubifs.h
--- linux-3.2.1-vanilla/fs/ubifs/ubifs.h	2012-01-12 
20:42:45.000000000 +0100
+++ linux-3.2.1-ubifsec/fs/ubifs/ubifs.h	2012-02-23 
16:09:03.071026982 +0100
@@ -163,6 +163,14 @@
  /* Maximum number of data nodes to bulk-read */
  #define UBIFS_MAX_BULK_READ 32

+/* Size of 128 bits in bytes */
+#define AES_KEYSIZE_128 16
+
+/* Key size in bytes for UBIFSEC */
+#define UBIFSEC_KEYSIZE AES_KEYSIZE_128
+#define UBIFSEC_CRYPTO_ALGORITHM "ctr(aes)"
+#define POISON_KEY(p) memset(p, 0xff, UBIFSEC_KEYSIZE)
+
  /*
   * Lockdep classes for UBIFS inode @ui_mutex.
   */
@@ -1775,9 +1783,10 @@ long ubifs_compat_ioctl(struct file *fil
  int __init ubifs_compressors_init(void);
  void ubifs_compressors_exit(void);
  void ubifs_compress(const void *in_buf, int in_len, void *out_buf, int 
*out_len,
-		    int *compr_type);
-int ubifs_decompress(const void *buf, int len, void *out, int *out_len,
-		     int compr_type);
+		    int *compr_type, u8* key);
+int ubifs_decompress(void *buf, int len, void *out, int *out_len,
+		     int compr_type, u8 *key);
+int ubifs_aes_crypt(u8 *str, int len, u8 *key, int keylen, u8 *iv, int 
ivlen);

  #include "debug.h"
  #include "misc.h"


