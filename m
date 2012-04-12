Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762246Ab2DLOCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 10:02:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:29121 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490Ab2DLOCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 10:02:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="130092687"
Message-ID: <1334239543.2544.46.camel@sauron.fi.intel.com>
Subject: Re: [patch] UBIFS: Add cryptographic functionality when a key is
 passed to the compress / decompress functions
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: Guillaume LECERF <glecerf@gmail.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Thu, 12 Apr 2012 17:05:43 +0300
In-Reply-To: <alpine.DEB.2.00.1204031334460.4560@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>
	 <alpine.DEB.2.00.1202202112220.21022@eristoteles.iwoars.net>
	 <1330531826.3545.128.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1203191635030.22256@eristoteles.iwoars.net>
	 <1332511796.18717.72.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1203231739330.22944@eristoteles.iwoars.net>
	 <1332521515.22278.2.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1203252302310.5527@eristoteles.iwoars.net>
	 <alpine.DEB.2.00.1203252325100.5527@eristoteles.iwoars.net>
	 <1332837188.31549.14.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1203291639200.912@eristoteles.iwoars.net>
	 <1333377383.22146.14.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1204021645070.29393@eristoteles.iwoars.net>
	 <1333378674.22146.18.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1204031228470.4560@eristoteles.iwoars.net>
	 <CAJpamw7rXn_tLcFSE07AK4nrh9QXLBNzuehzLhB+rUbMv9UePA@mail.gmail.com>
	 <alpine.DEB.2.00.1204031334460.4560@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-7k6BuFd62Aw5ZIJpPz2c"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7k6BuFd62Aw5ZIJpPz2c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I've pushed this patch (actually folded into the previous one), but
massaged it a bit.

Please, verify.

 Please, see below and
take into account for the future submissions.

1. Keep the subject line short - it should give only rough idea what
patch does.

2. When you re-send, add [PATCH v2] prefix.

3. When you re-send, send full patch with the commit message, not just
a reply with new diff. E.g., if I apply this patch using git am I will
get the following:

----
UBIFS: Add cryptographic functionality when a key is passed to the compress=
 / decompress functions

Without the goto:

Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
----

Does the commit message make sense? No. I have to manually copy-paste
you commit message from the previous patch...


On Tue, 2012-04-03 at 13:35 +0200, Joel Reardon wrote:
> Without the goto:
>=20
> Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
> ---
>  fs/ubifs/compress.c |   74 +++++++++++++++++++++++++++++++++++++++++++++=
+++---
>  fs/ubifs/ubifs.h    |    8 +++++-
>  2 files changed, 77 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/ubifs/compress.c b/fs/ubifs/compress.c
> index b796b8d..61fe584 100644
> --- a/fs/ubifs/compress.c
> +++ b/fs/ubifs/compress.c
> @@ -27,9 +27,12 @@
>   * decompression.
>   */
>=20
> -#include <linux/crypto.h>
>  #include "ubifs.h"
>=20
> +#include <linux/crypto.h>
> +#include <linux/scatterlist.h>

No need to re-arrange includes unnecessarily. All .c files in UBIFS
first include linux headers and then UBIFS headers. I do not know if
this is good or bad, but at least consistent. If you want to change
this, change globally.

> +
> +

No need to add extra new lines without a need. In general, do not
make unneeded changes, and look at the style of the current code
and try to follow it. If you want to change it - fine, but change for
entire UBIFS.

>  /* Fake description object for the "none" compressor */
>  static struct ubifs_compressor none_compr =3D {
>  	.compr_type =3D UBIFS_COMPR_NONE,
> @@ -75,6 +78,53 @@ static struct ubifs_compressor zlib_compr =3D {
>  struct ubifs_compressor *ubifs_compressors[UBIFS_COMPR_TYPES_CNT];
>=20
>  /**
> + * ubifs_aes_crypt - encrypt / decrypt data.
> + * @str: data to crypt
> + * @len: length of the data
> + * @crypto_key: the cryptographic key to use to crypt the data
> + * @iv: the initialization vector to use
> + *
> + * This function applies aes encryption to the data. It is done in count=
er
> + * mode, which means that encryption and decryption are the same operati=
on,
> + * i.e., it XORs the same generated bitstream, so it can be used both fo=
r
> + * encryption / decryption. The operation is done in-place, so str mutat=
es.
> + * Both crypto_key and iv are valid pointers to a buffer of length
> + * UBIFS_CRYPTO_KEYSIZE.
> + */

I believe this was stupid, but I used kernel-doc @ and % prefixes for
argument and costants even in the comments. So to be consistent, use
@str and %UBIFS_CRYPTO_KEYSIZE.

> +int ubifs_aes_crypt(void *str, int len, u8 *crypto_key, u8 *iv)

Surely you can add 'const' qualifier to 'crypto_key' ?
And it can be static - no users outside compress.c.

> +{
> +	struct crypto_blkcipher *tfm;
> +	struct blkcipher_desc desc;
> +	struct scatterlist sg;
> +	int err =3D 0;

Unneeded initialization.

> +
> +	tfm =3D crypto_alloc_blkcipher(UBIFS_CRYPTO_ALGORITHM, 0, 0);
> +	if (IS_ERR(tfm)) {
> +		ubifs_err("failed to load transform for aes: %ld",
> +			  PTR_ERR(tfm));
> +		return err;

You return 0 here, which is wrong. Should be "return PTR_ERR(tfm)".

> +	}
> +
> +	err =3D crypto_blkcipher_setkey(tfm, crypto_key, UBIFS_CRYPTO_KEYSIZE);
> +	desc.tfm =3D tfm;
> +	desc.flags =3D 0;
Why you ingected the above 2 lines here? Initialize 'desc' in one place,
do not spread it all over the function.
> +	if (err) {
> +		ubifs_err("crypto_blkcipher_setkey() failed  flags=3D%#x",
> +			  crypto_blkcipher_get_flags(tfm));

I tried to not include function names in error messages.

> +		return err;
> +	}
> +
> +	memset(&sg, 0, sizeof(struct scatterlist));
> +	sg_set_buf(&sg, str, len);
> +	desc.info =3D iv;
> +	err =3D crypto_blkcipher_encrypt(&desc, &sg, &sg, len);
> +	crypto_free_blkcipher(tfm);
> +	if (err)
> +		return err;
> +	return 0;

Can be just 'return err' instead of the 3 above lines.

>  /**
> @@ -148,8 +205,10 @@ no_compr:
>   * This function decompresses data from buffer @in_buf into buffer @out_=
buf.
>   * The length of the uncompressed data is returned in @out_len. This fun=
ctions
>   * returns %0 on success or a negative error code on failure.
> + *
> + * WARNING: this function may modify the contents of in_buf when executi=
ng.
>   */
> -int ubifs_decompress(const void *in_buf, int in_len, void *out_buf,
> +int ubifs_decompress(void *in_buf, int in_len, void *out_buf,
>  		     int *out_len, int compr_type, u8 *crypto_key)
>  {
>  	int err;
> @@ -167,6 +226,13 @@ int ubifs_decompress(const void *in_buf, int in_len,=
 void *out_buf,
>  		return -EINVAL;
>  	}
>=20
> +	if (crypto_key) {
> +		u8 iv[UBIFS_CRYPTO_KEYSIZE];
> +
> +		memset(iv, 0, UBIFS_CRYPTO_KEYSIZE);
> +		ubifs_aes_crypt(in_buf, in_len, crypto_key, iv);
> +	}

So what's the point of defining and initializing 'iv' outside of
'ubifs_aes_crypt()', 2 times? Why not to move it inside?


> +/* 128 bit key size in bytes for UBIFS */
> +#define UBIFS_CRYPTO_KEYSIZE 16
> +/* AES in counter mode is the encryption algorithm. */

Nit-pick: no dot at the end of one-line comment. I've removed it myself,
just keep in mind.

Anyway, too many things. I've modified your patch and pushed, here is
the diff against this patch - please, take a look and take into account.
There are few changes in the comments which I made to make the shorter
as well, not so important.

I've done the following 2 things as well:

1. Move iv to ubifs_aes_crypt()
2. make crypto_key void. In general, if we do not look inside the
pointer, we make it void, because we do not really care about the type,
since we do not look inside.

Please, verify. Below is the resulting patch. Also in the 'joel' branch.

=46rom 8bd3e978c5034f2e4a4017f2453eaa8271487cfa Mon Sep 17 00:00:00 2001
From: Joel Reardon <joel@clambassador.com>
Date: Thu, 12 Apr 2012 16:29:59 +0300
Subject: [PATCH] UBIFS: impliment encryption in the (de)compress functions

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

This was tested by using a static key as the key parameter where both compr=
ess
and decompress were called. Data was written and the file system was unmoun=
ted
and the mtd dev was scanned with hexdump to make sure that no plaintext dat=
a
was available. The drive was remounted and the data successful read back. T=
he
static key was then removed and replaced with NULL, and the same test was d=
one
except that now the data appeared in plaintext on the raw device.

Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/ubifs/compress.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++=
+--
 fs/ubifs/file.c     |    5 ++-
 fs/ubifs/journal.c  |    6 ++--
 fs/ubifs/ubifs.h    |   11 ++++++--
 4 files changed, 78 insertions(+), 11 deletions(-)

diff --git a/fs/ubifs/compress.c b/fs/ubifs/compress.c
index 11e4132..7b57457 100644
--- a/fs/ubifs/compress.c
+++ b/fs/ubifs/compress.c
@@ -28,6 +28,7 @@
  */
=20
 #include <linux/crypto.h>
+#include <linux/scatterlist.h>
 #include "ubifs.h"
=20
 /* Fake description object for the "none" compressor */
@@ -75,6 +76,53 @@ static struct ubifs_compressor zlib_compr =3D {
 struct ubifs_compressor *ubifs_compressors[UBIFS_COMPR_TYPES_CNT];
=20
 /**
+ * aes_crypt - encrypt / decrypt data.
+ * @str: the data to crypt
+ * @len: length of the data
+ * @crypto_key: the cryptographic key to use to crypt the data
+ *
+ * This function applies AES encryption to the data. It is done in counter
+ * mode, which means that encryption and decryption are the same operation=
,
+ * i.e., it XORs the same generated bitstream, so it can be used both for
+ * encryption / decryption. Returns zero in case of success and a negative
+ * error code in case of failure.
+ *
+ * WARNING: The operation is done in-place, so @str mutates!
+ */
+static int aes_crypt(void *str, int len, const void *crypto_key)
+{
+	struct crypto_blkcipher *tfm;
+	struct blkcipher_desc desc;
+	struct scatterlist sg;
+	uint8_t iv[UBIFS_CRYPTO_KEYSIZE];
+	int err;
+
+	tfm =3D crypto_alloc_blkcipher(UBIFS_CRYPTO_ALGORITHM, 0, 0);
+	if (IS_ERR(tfm)) {
+		err =3D PTR_ERR(tfm);
+		ubifs_err("failed to load transform for aes, error %d", err);
+		return err;
+	}
+
+	err =3D crypto_blkcipher_setkey(tfm, crypto_key, UBIFS_CRYPTO_KEYSIZE);
+	if (err) {
+		ubifs_err("cannot set the AES key, flags %#x, error %d",
+			  crypto_blkcipher_get_flags(tfm), err);
+		return err;
+	}
+
+	memset(&sg, 0, sizeof(struct scatterlist));
+	sg_set_buf(&sg, str, len);
+	memset(iv, 0, UBIFS_CRYPTO_KEYSIZE);
+	desc.info =3D iv;
+	desc.tfm =3D tfm;
+	desc.flags =3D 0;
+	err =3D crypto_blkcipher_encrypt(&desc, &sg, &sg, len);
+	crypto_free_blkcipher(tfm);
+	return err;
+}
+
+/**
  * ubifs_compress - compress data.
  * @in_buf: data to compress
  * @in_len: length of the data to compress
@@ -82,6 +130,7 @@ struct ubifs_compressor *ubifs_compressors[UBIFS_COMPR_T=
YPES_CNT];
  * @out_len: output buffer length is returned here
  * @compr_type: type of compression to use on enter, actually used compres=
sion
  *              type on exit
+ * @crypto_key: the encryption key or NULL if no encryption needed
  *
  * This function compresses input buffer @in_buf of length @in_len and sto=
res
  * the result in the output buffer @out_buf and the resulting length in
@@ -93,7 +142,7 @@ struct ubifs_compressor *ubifs_compressors[UBIFS_COMPR_T=
YPES_CNT];
  * buffer and %UBIFS_COMPR_NONE is returned in @compr_type.
  */
 void ubifs_compress(const void *in_buf, int in_len, void *out_buf, int *ou=
t_len,
-		    int *compr_type)
+		    int *compr_type, void *crypto_key)
 {
 	int err;
 	struct ubifs_compressor *compr =3D ubifs_compressors[*compr_type];
@@ -125,12 +174,18 @@ void ubifs_compress(const void *in_buf, int in_len, v=
oid *out_buf, int *out_len,
 	if (in_len - *out_len < UBIFS_MIN_COMPRESS_DIFF)
 		goto no_compr;
=20
+	if (crypto_key)
+		aes_crypt(out_buf, *out_len, crypto_key);
+
 	return;
=20
 no_compr:
 	memcpy(out_buf, in_buf, in_len);
 	*out_len =3D in_len;
 	*compr_type =3D UBIFS_COMPR_NONE;
+
+	if (crypto_key)
+		aes_crypt(out_buf, *out_len, crypto_key);
 }
=20
 /**
@@ -140,13 +195,16 @@ no_compr:
  * @out_buf: output buffer where decompressed data should
  * @out_len: output length is returned here
  * @compr_type: type of compression
+ * @crypto_key: the encryption key or %NULL if no encryption needed
  *
  * This function decompresses data from buffer @in_buf into buffer @out_bu=
f.
  * The length of the uncompressed data is returned in @out_len. This funct=
ions
  * returns %0 on success or a negative error code on failure.
+ *
+ * WARNING: this function may modify the contents of @in_buf!
  */
-int ubifs_decompress(const void *in_buf, int in_len, void *out_buf,
-		     int *out_len, int compr_type)
+int ubifs_decompress(void *in_buf, int in_len, void *out_buf,
+		     int *out_len, int compr_type, void *crypto_key)
 {
 	int err;
 	struct ubifs_compressor *compr;
@@ -163,6 +221,9 @@ int ubifs_decompress(const void *in_buf, int in_len, vo=
id *out_buf,
 		return -EINVAL;
 	}
=20
+	if (crypto_key)
+		aes_crypt(in_buf, in_len, crypto_key);
+
 	if (compr_type =3D=3D UBIFS_COMPR_NONE) {
 		memcpy(out_buf, in_buf, in_len);
 		*out_len =3D in_len;
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 5c8f6dc..e8fa837 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -80,7 +80,7 @@ static int read_block(struct inode *inode, void *addr, un=
signed int block,
 	dlen =3D le32_to_cpu(dn->ch.len) - UBIFS_DATA_NODE_SZ;
 	out_len =3D UBIFS_BLOCK_SIZE;
 	err =3D ubifs_decompress(&dn->data, dlen, addr, &out_len,
-			       le16_to_cpu(dn->compr_type));
+			       le16_to_cpu(dn->compr_type), NULL);
 	if (err || len !=3D out_len)
 		goto dump;
=20
@@ -649,7 +649,8 @@ static int populate_page(struct ubifs_info *c, struct p=
age *page,
 			dlen =3D le32_to_cpu(dn->ch.len) - UBIFS_DATA_NODE_SZ;
 			out_len =3D UBIFS_BLOCK_SIZE;
 			err =3D ubifs_decompress(&dn->data, dlen, addr, &out_len,
-					       le16_to_cpu(dn->compr_type));
+					       le16_to_cpu(dn->compr_type),
+					       NULL);
 			if (err || len !=3D out_len)
 				goto out_err;
=20
diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index 137415e..57c4d2f 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -730,7 +730,7 @@ int ubifs_jnl_write_data(struct ubifs_info *c, const st=
ruct inode *inode,
 		compr_type =3D ui->compr_type;
=20
 	out_len =3D dlen - UBIFS_DATA_NODE_SZ;
-	ubifs_compress(buf, len, &data->data, &out_len, &compr_type);
+	ubifs_compress(buf, len, &data->data, &out_len, &compr_type, NULL);
 	ubifs_assert(out_len <=3D UBIFS_BLOCK_SIZE);
=20
 	dlen =3D UBIFS_DATA_NODE_SZ + out_len;
@@ -1113,11 +1113,11 @@ static int recomp_data_node(struct ubifs_data_node =
*dn, int *new_len)
=20
 	len =3D le32_to_cpu(dn->ch.len) - UBIFS_DATA_NODE_SZ;
 	compr_type =3D le16_to_cpu(dn->compr_type);
-	err =3D ubifs_decompress(&dn->data, len, buf, &out_len, compr_type);
+	err =3D ubifs_decompress(&dn->data, len, buf, &out_len, compr_type, NULL)=
;
 	if (err)
 		goto out;
=20
-	ubifs_compress(buf, *new_len, &dn->data, &out_len, &compr_type);
+	ubifs_compress(buf, *new_len, &dn->data, &out_len, &compr_type, NULL);
 	ubifs_assert(out_len <=3D UBIFS_BLOCK_SIZE);
 	dn->compr_type =3D cpu_to_le16(compr_type);
 	dn->size =3D cpu_to_le32(*new_len);
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 7c343e1..ce6d8c2 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -160,6 +160,11 @@
 /* Maximum number of data nodes to bulk-read */
 #define UBIFS_MAX_BULK_READ 32
=20
+/* 128 bit key size in bytes for UBIFS */
+#define UBIFS_CRYPTO_KEYSIZE 16
+/* AES in counter mode is the encryption algorithm */
+#define UBIFS_CRYPTO_ALGORITHM "ctr(aes)"
+
 /*
  * Lockdep classes for UBIFS inode @ui_mutex.
  */
@@ -1772,9 +1777,9 @@ long ubifs_compat_ioctl(struct file *file, unsigned i=
nt cmd, unsigned long arg);
 int __init ubifs_compressors_init(void);
 void ubifs_compressors_exit(void);
 void ubifs_compress(const void *in_buf, int in_len, void *out_buf, int *ou=
t_len,
-		    int *compr_type);
-int ubifs_decompress(const void *buf, int len, void *out, int *out_len,
-		     int compr_type);
+		    int *compr_type, void *crypto_key);
+int ubifs_decompress(void *buf, int len, void *out, int *out_len,
+		     int compr_type, void *crypto_key);
=20
 #include "debug.h"
 #include "misc.h"
--=20
1.7.9.1

--=20
Best Regards,
Artem Bityutskiy

--=-7k6BuFd62Aw5ZIJpPz2c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPhuE3AAoJECmIfjd9wqK05C4QALwESJ7V3u27ME3CEl5uTSN4
djeUHrXESCXXYbIx5WgTQuKbyCjoCLLwdJWTUWhfOe2LDXoJSL0HVzS/eS7ghtfX
aypJmR4ch/fnSYF3bVZ2NeAPJ1j3f0/UENDyHniOqu1AKJudCsQYO+6L7lEIJeBM
SX0ncIgwpJn4j2p6HH2bXQjLbqqtm+gz6XVo6dpnaYQ8ZDFdMG2RUyPPUWvmXT4V
YkoI29tnrrwz1p1dRBt4Zvg+uySAne9jVIW14DJ0fy5rKYvR2FphRlOo8ZNCr5ix
zf2ww4DWREkbcg2scxszT9/n/7xBohfLX0KJMmHCz+g2uuPXfAiy0CzI7LpQTpw8
7ABJC2zl6IPrPrSMPzmyJx/Ag02inPQ7R5AQaNmr+U4jNZV1Fm9xRz6DUTRCTA/S
Z7cmbNeya30y6oAhcSakdCGTTEBgLwzdeZ8GjuqBmt4JXddID1XdGEa7ClFAQqZC
K1JD/nb7nDvDdVJlQlme9UwIBa/h+2QG1KorMwOdw4EYVOf4W6/zZIzLKlqLBWVH
mnhUehxXpsBf5ZvIsILlYWde2NBqcNJucPA/k0hKdhWUBU7KgrdBE5sksEnDKFTx
y23yCr30J4qHzsrQMyaPpBIrVvCGkY5eW5JUc7HXvIKefD4t1p8M6pbl9N9sknYv
sMxCYNR2WXK0WULvp5PC
=kohr
-----END PGP SIGNATURE-----

--=-7k6BuFd62Aw5ZIJpPz2c--

