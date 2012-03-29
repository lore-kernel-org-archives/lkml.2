Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454Ab2C2OLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 10:11:15 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:42728
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1758840Ab2C2OLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 10:11:07 -0400
Date: Thu, 29 Mar 2012 16:11:03 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [patch] UBIFS: Add a encryption key parameter to the compress /
 decompress function.
In-Reply-To: <1332836863.31549.9.camel@sauron.fi.intel.com>
Message-ID: <alpine.DEB.2.00.1203291606450.912@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>     <alpine.DEB.2.00.1202202112220.21022@eristoteles.iwoars.net>    <1330531826.3545.128.camel@sauron.fi.intel.com>    <alpine.DEB.2.00.1203191635030.22256@eristoteles.iwoars.net>  
 <1332511796.18717.72.camel@sauron.fi.intel.com>   <alpine.DEB.2.00.1203231739330.22944@eristoteles.iwoars.net>  <1332521515.22278.2.camel@sauron.fi.intel.com>  <alpine.DEB.2.00.1203252302310.5527@eristoteles.iwoars.net>
 <1332836863.31549.9.camel@sauron.fi.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a crypto_key parameter to ubifs compress and decompress. Will be used
later if non-NULL to encrypt / decrypt data nodes.

Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
---
 fs/ubifs/compress.c |    8 ++++++--
 fs/ubifs/file.c     |    5 +++--
 fs/ubifs/journal.c  |    7 ++++---
 fs/ubifs/ubifs.h    |    4 ++--
 4 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/ubifs/compress.c b/fs/ubifs/compress.c
index 11e4132..c91974a 100644
--- a/fs/ubifs/compress.c
+++ b/fs/ubifs/compress.c
@@ -82,6 +82,8 @@ struct ubifs_compressor *ubifs_compressors[UBIFS_COMPR_TYPES_CNT];
  * @out_len: output buffer length is returned here
  * @compr_type: type of compression to use on enter, actually used compression
  *              type on exit
+ * @crypto_key: a pointer to bytes to use as the encryption key,
+ *              if NULL then no encryption is performed.
  *
  * This function compresses input buffer @in_buf of length @in_len and stores
  * the result in the output buffer @out_buf and the resulting length in
@@ -93,7 +95,7 @@ struct ubifs_compressor *ubifs_compressors[UBIFS_COMPR_TYPES_CNT];
  * buffer and %UBIFS_COMPR_NONE is returned in @compr_type.
  */
 void ubifs_compress(const void *in_buf, int in_len, void *out_buf, int *out_len,
-		    int *compr_type)
+		    int *compr_type, u8 *crypto_key)
 {
 	int err;
 	struct ubifs_compressor *compr = ubifs_compressors[*compr_type];
@@ -140,13 +142,15 @@ no_compr:
  * @out_buf: output buffer where decompressed data should
  * @out_len: output length is returned here
  * @compr_type: type of compression
+ * @crypto_key: a pointer to bytes to use as the decryption key,
+ *		if NULL then no decryption is performed.
  *
  * This function decompresses data from buffer @in_buf into buffer @out_buf.
  * The length of the uncompressed data is returned in @out_len. This functions
  * returns %0 on success or a negative error code on failure.
  */
 int ubifs_decompress(const void *in_buf, int in_len, void *out_buf,
-		     int *out_len, int compr_type)
+		     int *out_len, int compr_type, u8 *crypto_key)
 {
 	int err;
 	struct ubifs_compressor *compr;
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index f9c234b..2660c9f 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -80,7 +80,7 @@ static int read_block(struct inode *inode, void *addr, unsigned int block,
 	dlen = le32_to_cpu(dn->ch.len) - UBIFS_DATA_NODE_SZ;
 	out_len = UBIFS_BLOCK_SIZE;
 	err = ubifs_decompress(&dn->data, dlen, addr, &out_len,
-			       le16_to_cpu(dn->compr_type));
+			       le16_to_cpu(dn->compr_type), NULL);
 	if (err || len != out_len)
 		goto dump;

@@ -649,7 +649,8 @@ static int populate_page(struct ubifs_info *c, struct page *page,
 			dlen = le32_to_cpu(dn->ch.len) - UBIFS_DATA_NODE_SZ;
 			out_len = UBIFS_BLOCK_SIZE;
 			err = ubifs_decompress(&dn->data, dlen, addr, &out_len,
-					       le16_to_cpu(dn->compr_type));
+					       le16_to_cpu(dn->compr_type),
+					       NULL);
 			if (err || len != out_len)
 				goto out_err;

diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index 2f438ab..9156395 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -727,7 +727,7 @@ int ubifs_jnl_write_data(struct ubifs_info *c, const struct inode *inode,
 		compr_type = ui->compr_type;

 	out_len = dlen - UBIFS_DATA_NODE_SZ;
-	ubifs_compress(buf, len, &data->data, &out_len, &compr_type);
+	ubifs_compress(buf, len, &data->data, &out_len, &compr_type, NULL);
 	ubifs_assert(out_len <= UBIFS_BLOCK_SIZE);

 	dlen = UBIFS_DATA_NODE_SZ + out_len;
@@ -1110,11 +1110,12 @@ static int recomp_data_node(struct ubifs_data_node *dn, int *new_len)

 	len = le32_to_cpu(dn->ch.len) - UBIFS_DATA_NODE_SZ;
 	compr_type = le16_to_cpu(dn->compr_type);
-	err = ubifs_decompress(&dn->data, len, buf, &out_len, compr_type);
+	err = ubifs_decompress(
+		&dn->data, len, buf, &out_len, compr_type, NULL);
 	if (err)
 		goto out;

-	ubifs_compress(buf, *new_len, &dn->data, &out_len, &compr_type);
+	ubifs_compress(buf, *new_len, &dn->data, &out_len, &compr_type, NULL);
 	ubifs_assert(out_len <= UBIFS_BLOCK_SIZE);
 	dn->compr_type = cpu_to_le16(compr_type);
 	dn->size = cpu_to_le32(*new_len);
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 93d59ac..0cc1180 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1772,9 +1772,9 @@ long ubifs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 int __init ubifs_compressors_init(void);
 void ubifs_compressors_exit(void);
 void ubifs_compress(const void *in_buf, int in_len, void *out_buf, int *out_len,
-		    int *compr_type);
+		    int *compr_type, u8 *crypto_key);
 int ubifs_decompress(const void *buf, int len, void *out, int *out_len,
-		     int compr_type);
+		     int compr_type, u8 *crypto_key);

 #include "debug.h"
 #include "misc.h"
-- 
1.7.5.4


