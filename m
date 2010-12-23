Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab0LWRfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 12:35:08 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:34322 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753559Ab0LWRfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 12:35:05 -0500
X-Sasl-enc: QpNgDFVZQH11zdTTrl2/Rd5J637ko2bqzxbRLtv5xoDJ 1293125704
To: linux-security-module@vger.kernel.org
Subject: [RFC][PATCH 3/6] encrypted-keys: add key format support
From: Roberto Sassu <roberto.sassu@polito.it>
Date: Thu, 23 Dec 2010 18:35:00 +0100
Cc: keyrings@linux-nfs.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Gianluca Ramunno <ramunno@polito.it>,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>, kirkland@canonical.com
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5749342.I5aPMAWj3C";
  protocol="application/pkcs7-signature";
  micalg=sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201012231835.01075.roberto.sassu@polito.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5749342.I5aPMAWj3C
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

This patch introduces a new parameter, called 'format', that defines the
format of data stored by encrypted keys. The 'default' format identifies
encrypted keys containing only the symmetric key, while other formats can
be defined to support additional information. The 'format' parameter is
written in the datablob produced by commands 'keyctl print' or
'keyctl pipe' and is integrity protected by the HMAC.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
=2D--
 Documentation/keys-trusted-encrypted.txt |   48 +++++++----
 include/keys/encrypted-type.h            |   13 +++-
 security/keys/encrypted_defined.c        |  139 +++++++++++++++++++++-----=
=2D--
 3 files changed, 141 insertions(+), 59 deletions(-)

diff --git a/Documentation/keys-trusted-encrypted.txt b/Documentation/keys-=
trusted-encrypted.txt
index 8fb79bc..0afcb50 100644
=2D-- a/Documentation/keys-trusted-encrypted.txt
+++ b/Documentation/keys-trusted-encrypted.txt
@@ -53,12 +53,19 @@ they are only as secure as the user key encrypting them=
=2E  The master user key
 should therefore be loaded in as secure a way as possible, preferably earl=
y in
 boot.
=20
+The decrypted portion of encrypted keys can contain either a simple symmet=
ric
+key or a more complex structure. The format of the more complex structure =
is
+application specific, which is identified by 'format'.
+
 Usage:
=2D  keyctl add encrypted name "new key-type:master-key-name keylen" ring
=2D  keyctl add encrypted name "load hex_blob" ring
=2D  keyctl update keyid "update key-type:master-key-name"
+    keyctl add encrypted name "new [format] key-type:master-key-name keyle=
n"
+        ring
+    keyctl add encrypted name "load hex_blob" ring
+    keyctl update keyid "update key-type:master-key-name"
+
+format:=3D 'default'
+key-type:=3D 'trusted' | 'user'
=20
=2Dwhere 'key-type' is either 'trusted' or 'user'.
=20
 Examples of trusted and encrypted key usage:
=20
@@ -114,15 +121,25 @@ Reseal a trusted key under new pcr values:
     7ef6a24defe4846104209bf0c3eced7fa1a672ed5b125fc9d8cd88b476a658a4434644=
ef
     df8ae9a178e9f83ba9f08d10fa47e4226b98b0702f06b3b8
=20
=2DCreate and save an encrypted key "evm" using the above trusted key "kmk":
+The initial consumer of trusted keys is EVM, which at boot time needs a hi=
gh
+quality symmetric key for HMAC protection of file metadata.  The use of a
+trusted key provides strong guarantees that the EVM key has not been
+compromised by a user level problem, and when sealed to specific boot PCR
+values, protects against boot and offline attacks.  Create and save an
+encrypted key "evm" using the above trusted key "kmk":
=20
+option 1: omitting 'format'
     $ keyctl add encrypted evm "new trusted:kmk 32" @u
     159771175
=20
+option 2: explicitly defining 'format' as 'default'
+    $ keyctl add encrypted evm "new default trusted:kmk 32" @u
+    159771175
+
     $ keyctl print 159771175
=2D    trusted:kmk 32 2375725ad57798846a9bbd240de8906f006e66c03af53b1b382db=
bc55
=2D    be2a44616e4959430436dc4f2a7a9659aa60bb4652aeb2120f149ed197c564e02471=
7c64
=2D    5972dcb82ab2dde83376d82b2e3c09ffc
+    default trusted:kmk 32 2375725ad57798846a9bbd240de8906f006e66c03af53b1=
b3
+    82dbbc55be2a44616e4959430436dc4f2a7a9659aa60bb4652aeb2120f149ed197c564=
e0
+    24717c64 5972dcb82ab2dde83376d82b2e3c09ffc
=20
     $ keyctl pipe 159771175 > evm.blob
=20
@@ -132,14 +149,9 @@ Load an encrypted key "evm" from saved blob:
     831684262
=20
     $ keyctl print 831684262
=2D    trusted:kmk 32 2375725ad57798846a9bbd240de8906f006e66c03af53b1b382db=
bc55
=2D    be2a44616e4959430436dc4f2a7a9659aa60bb4652aeb2120f149ed197c564e02471=
7c64
=2D    5972dcb82ab2dde83376d82b2e3c09ffc
=2D
+    default trusted:kmk 32 2375725ad57798846a9bbd240de8906f006e66c03af53b1=
b3
+    82dbbc55be2a44616e4959430436dc4f2a7a9659aa60bb4652aeb2120f149ed197c564=
e0
+    24717c64 5972dcb82ab2dde83376d82b2e3c09ffc
=20
=2DThe initial consumer of trusted keys is EVM, which at boot time needs a =
high
=2Dquality symmetric key for HMAC protection of file metadata.  The use of a
=2Dtrusted key provides strong guarantees that the EVM key has not been
=2Dcompromised by a user level problem, and when sealed to specific boot PCR
=2Dvalues, protects against boot and offline attacks.  Other uses for trust=
ed and
=2Dencrypted keys, such as for disk and file encryption are anticipated.
+Other uses for trusted and encrypted keys, such as for disk and file encry=
ption
+are anticipated.
diff --git a/include/keys/encrypted-type.h b/include/keys/encrypted-type.h
index 9585501..1d45413 100644
=2D-- a/include/keys/encrypted-type.h
+++ b/include/keys/encrypted-type.h
@@ -1,6 +1,11 @@
 /*
  * Copyright (C) 2010 IBM Corporation
=2D * Author: Mimi Zohar <zohar@us.ibm.com>
+ * Copyright (C) 2010 Politecnico di Torino, Italy
+ *                    TORSEC group -- http://security.polito.it
+ *
+ * Authors:
+ * Mimi Zohar <zohar@us.ibm.com>
+ * Roberto Sassu <roberto.sassu@polito.it>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -15,13 +20,17 @@
=20
 struct encrypted_key_payload {
 	struct rcu_head rcu;
+	char *format;		/* datablob: format */
 	char *master_desc;	/* datablob: master key name */
 	char *datalen;		/* datablob: decrypted key length */
 	u8 *iv;			/* datablob: iv */
 	u8 *encrypted_data;	/* datablob: encrypted data */
 	unsigned short datablob_len;	/* length of datablob */
 	unsigned short decrypted_datalen;	/* decrypted data length */
=2D	u8 decrypted_data[0];	/* decrypted data +  datablob + hmac */
+	unsigned short payload_datalen;		/* payload data length */
+	unsigned short encrypted_key_format;	/* encrypted key format */
+	u8 *decrypted_data;	/* decrypted data */
+	u8 payload_data[0];	/* payload data + datablob + hmac */
 };
=20
 extern struct key_type key_type_encrypted;
diff --git a/security/keys/encrypted_defined.c b/security/keys/encrypted_de=
fined.c
index 2bb2c47..7a914ab 100644
=2D-- a/security/keys/encrypted_defined.c
+++ b/security/keys/encrypted_defined.c
@@ -1,8 +1,11 @@
 /*
  * Copyright (C) 2010 IBM Corporation
+ * Copyright (C) 2010 Politecnico di Torino, Italy
+ *                    TORSEC group -- http://security.polito.it
  *
=2D * Author:
+ * Authors:
  * Mimi Zohar <zohar@us.ibm.com>
+ * Roberto Sassu <roberto.sassu@polito.it>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -37,6 +40,7 @@ static const char KEY_USER_PREFIX[] =3D "user:";
 static const char hash_alg[] =3D "sha256";
 static const char hmac_alg[] =3D "hmac(sha256)";
 static const char blkcipher_alg[] =3D "cbc(aes)";
+static const char key_format_default[] =3D "default";
 static unsigned int ivsize;
 static int blksize;
=20
@@ -58,6 +62,15 @@ enum {
 	Opt_err =3D -1, Opt_new, Opt_load, Opt_update
 };
=20
+enum {
+	Opt_error =3D -1, Opt_default
+};
+
+static const match_table_t key_format_tokens =3D {
+	{Opt_default, "default"},
+	{Opt_error, NULL}
+};
+
 static const match_table_t key_tokens =3D {
 	{Opt_new, "new"},
 	{Opt_load, "load"},
@@ -118,8 +131,9 @@ out:
  * datablob_parse - parse the keyctl data
  *
  * datablob format:
=2D * new <master-key name> <decrypted data length>
=2D * load <master-key name> <decrypted data length> <encrypted iv + data>
+ * new [<format>] <master-key name> <decrypted data length>
+ * load [<format>] <master-key name> <decrypted data length>
+ *     <encrypted iv + data>
  * update <new-master-key name>
  *
  * Tokenizes a copy of the keyctl data, returning a pointer to each token,
@@ -127,12 +141,14 @@ out:
  *
  * On success returns 0, otherwise -EINVAL.
  */
=2Dstatic int datablob_parse(char *datablob, char **master_desc,
=2D			  char **decrypted_datalen, char **hex_encoded_iv)
+static int datablob_parse(char *datablob, const char **format,
+			  char **master_desc, char **decrypted_datalen,
+			  char **hex_encoded_iv)
 {
 	substring_t args[MAX_OPT_ARGS];
 	int ret =3D -EINVAL;
 	int key_cmd;
+	int key_format;
 	char *p, *keyword;
=20
 	keyword =3D strsep(&datablob, " \t");
@@ -142,7 +158,24 @@ static int datablob_parse(char *datablob, char **maste=
r_desc,
 	}
 	key_cmd =3D match_token(keyword, key_tokens, args);
=20
=2D	*master_desc =3D strsep(&datablob, " \t");
+	/* Get optional format: default */
+	p =3D strsep(&datablob, " \t");
+	if (!p) {
+		pr_err("encrypted_key: insufficient parameters specified\n");
+		return ret;
+	}
+
+	key_format =3D match_token(p, key_format_tokens, args);
+	switch (key_format) {
+	case Opt_default:
+		*format =3D p;
+		*master_desc =3D strsep(&datablob, " \t");
+		break;
+	case Opt_error:
+		*master_desc =3D p;
+		break;
+	}
+
 	if (!*master_desc) {
 		pr_err("encrypted_key: master key parameter is missing\n");
 		goto out;
@@ -219,8 +252,8 @@ static char *datablob_format(struct encrypted_key_paylo=
ad *epayload,
 	ascii_buf[asciiblob_len] =3D '\0';
=20
 	/* copy datablob master_desc and datalen strings */
=2D	len =3D sprintf(ascii_buf, "%s %s ", epayload->master_desc,
=2D		      epayload->datalen);
+	len =3D sprintf(ascii_buf, "%s %s %s ", epayload->format,
+		      epayload->master_desc, epayload->datalen);
=20
 	/* convert the hex encoded iv, encrypted-data and HMAC to ascii */
 	bufp =3D &ascii_buf[len];
@@ -461,9 +494,9 @@ static int datablob_hmac_append(struct encrypted_key_pa=
yload *epayload,
 	if (ret < 0)
 		goto out;
=20
=2D	digest =3D epayload->master_desc + epayload->datablob_len;
+	digest =3D epayload->format + epayload->datablob_len;
 	ret =3D calc_hmac(digest, derived_key, sizeof derived_key,
=2D			epayload->master_desc, epayload->datablob_len);
+			epayload->format, epayload->datablob_len);
 	if (!ret)
 		dump_hmac(NULL, digest, HASH_SIZE);
 out:
@@ -472,26 +505,35 @@ out:
=20
 /* verify HMAC before decrypting encrypted key */
 static int datablob_hmac_verify(struct encrypted_key_payload *epayload,
=2D				const u8 *master_key, size_t master_keylen)
+				const u8 *format, const u8 *master_key,
+				size_t master_keylen)
 {
 	u8 derived_key[HASH_SIZE];
 	u8 digest[HASH_SIZE];
 	int ret;
+	char *p;
+	unsigned short len;
=20
 	ret =3D get_derived_key(derived_key, AUTH_KEY, master_key, master_keylen);
 	if (ret < 0)
 		goto out;
=20
=2D	ret =3D calc_hmac(digest, derived_key, sizeof derived_key,
=2D			epayload->master_desc, epayload->datablob_len);
+	len =3D epayload->datablob_len;
+	if (!format) {
+		p =3D epayload->master_desc;
+		len -=3D strlen(epayload->format) + 1;
+	} else
+		p =3D epayload->format;
+
+	ret =3D calc_hmac(digest, derived_key, sizeof derived_key, p, len);
 	if (ret < 0)
 		goto out;
=2D	ret =3D memcmp(digest, epayload->master_desc + epayload->datablob_len,
+	ret =3D memcmp(digest, epayload->format + epayload->datablob_len,
 		     sizeof digest);
 	if (ret) {
 		ret =3D -EINVAL;
 		dump_hmac("datablob",
=2D			  epayload->master_desc + epayload->datablob_len,
+			  epayload->format + epayload->datablob_len,
 			  HASH_SIZE);
 		dump_hmac("calc", digest, HASH_SIZE);
 	}
@@ -536,13 +578,16 @@ out:
=20
 /* Allocate memory for decrypted key and datablob. */
 static struct encrypted_key_payload *encrypted_key_alloc(struct key *key,
+							 const char *format,
 							 const char *master_desc,
 							 const char *datalen)
 {
 	struct encrypted_key_payload *epayload =3D NULL;
 	unsigned short datablob_len;
 	unsigned short decrypted_datalen;
+	unsigned short payload_datalen;
 	unsigned int encrypted_datalen;
+	unsigned int format_len;
 	long dlen;
 	int ret;
=20
@@ -550,29 +595,32 @@ static struct encrypted_key_payload *encrypted_key_al=
loc(struct key *key,
 	if (ret < 0 || dlen < MIN_DATA_SIZE || dlen > MAX_DATA_SIZE)
 		return ERR_PTR(-EINVAL);
=20
+	format_len =3D (!format) ? strlen(key_format_default) : strlen(format);
 	decrypted_datalen =3D dlen;
+	payload_datalen =3D decrypted_datalen;
 	encrypted_datalen =3D roundup(decrypted_datalen, blksize);
=20
=2D	datablob_len =3D strlen(master_desc) + 1 + strlen(datalen) + 1
=2D	    + ivsize + 1 + encrypted_datalen;
+	datablob_len =3D format_len + 1 + strlen(master_desc) + 1
+	    + strlen(datalen) + 1 + ivsize + 1 + encrypted_datalen;
=20
=2D	ret =3D key_payload_reserve(key, decrypted_datalen + datablob_len
+	ret =3D key_payload_reserve(key, payload_datalen + datablob_len
 				  + HASH_SIZE + 1);
 	if (ret < 0)
 		return ERR_PTR(ret);
=20
=2D	epayload =3D kzalloc(sizeof(*epayload) + decrypted_datalen +
+	epayload =3D kzalloc(sizeof(*epayload) + payload_datalen +
 			   datablob_len + HASH_SIZE + 1, GFP_KERNEL);
 	if (!epayload)
 		return ERR_PTR(-ENOMEM);
=20
+	epayload->payload_datalen =3D payload_datalen;
 	epayload->decrypted_datalen =3D decrypted_datalen;
 	epayload->datablob_len =3D datablob_len;
 	return epayload;
 }
=20
 static int encrypted_key_decrypt(struct encrypted_key_payload *epayload,
=2D				 const char *hex_encoded_iv)
+				 const char *format, const char *hex_encoded_iv)
 {
 	struct key *mkey;
 	u8 derived_key[HASH_SIZE];
@@ -593,14 +641,14 @@ static int encrypted_key_decrypt(struct encrypted_key=
_payload *epayload,
 	hex2bin(epayload->iv, hex_encoded_iv, ivsize);
 	hex2bin(epayload->encrypted_data, hex_encoded_data, encrypted_datalen);
=20
=2D	hmac =3D epayload->master_desc + epayload->datablob_len;
+	hmac =3D epayload->format + epayload->datablob_len;
 	hex2bin(hmac, hex_encoded_data + (encrypted_datalen * 2), HASH_SIZE);
=20
 	mkey =3D request_master_key(epayload, &master_key, &master_keylen);
 	if (IS_ERR(mkey))
 		return PTR_ERR(mkey);
=20
=2D	ret =3D datablob_hmac_verify(epayload, master_key, master_keylen);
+	ret =3D datablob_hmac_verify(epayload, format, master_key, master_keylen);
 	if (ret < 0) {
 		pr_err("encrypted_key: bad hmac (%d)\n", ret);
 		goto out;
@@ -620,14 +668,23 @@ out:
 }
=20
 static void __ekey_init(struct encrypted_key_payload *epayload,
=2D			const char *master_desc, const char *datalen)
+			const char *format, const char *master_desc,
+			const char *datalen)
 {
=2D	epayload->master_desc =3D epayload->decrypted_data
=2D	    + epayload->decrypted_datalen;
+	unsigned int format_len;
+
+	format_len =3D (!format) ? strlen(key_format_default) : strlen(format);
+	epayload->format =3D epayload->payload_data + epayload->payload_datalen;
+	epayload->master_desc =3D epayload->format + format_len + 1;
 	epayload->datalen =3D epayload->master_desc + strlen(master_desc) + 1;
 	epayload->iv =3D epayload->datalen + strlen(datalen) + 1;
 	epayload->encrypted_data =3D epayload->iv + ivsize + 1;
+	epayload->decrypted_data =3D epayload->payload_data;
=20
+	if (!format)
+		memcpy(epayload->format, key_format_default, format_len);
+	else
+		memcpy(epayload->format, format, format_len);
 	memcpy(epayload->master_desc, master_desc, strlen(master_desc));
 	memcpy(epayload->datalen, datalen, strlen(datalen));
 }
@@ -639,19 +696,19 @@ static void __ekey_init(struct encrypted_key_payload =
*epayload,
  * itself.  For an old key, decrypt the hex encoded data.
  */
 static int encrypted_init(struct encrypted_key_payload *epayload,
=2D			  const char *master_desc, const char *datalen,
=2D			  const char *hex_encoded_iv)
+			  const char *format, const char *master_desc,
+			  const char *datalen, const char *hex_encoded_iv)
 {
 	int ret =3D 0;
=20
=2D	__ekey_init(epayload, master_desc, datalen);
+	__ekey_init(epayload, format, master_desc, datalen);
 	if (!hex_encoded_iv) {
 		get_random_bytes(epayload->iv, ivsize);
=20
 		get_random_bytes(epayload->decrypted_data,
 				 epayload->decrypted_datalen);
 	} else
=2D		ret =3D encrypted_key_decrypt(epayload, hex_encoded_iv);
+		ret =3D encrypted_key_decrypt(epayload, format, hex_encoded_iv);
 	return ret;
 }
=20
@@ -668,6 +725,7 @@ static int encrypted_instantiate(struct key *key, const=
 void *data,
 {
 	struct encrypted_key_payload *epayload =3D NULL;
 	char *datablob =3D NULL;
+	const char *format =3D NULL;
 	char *master_desc =3D NULL;
 	char *decrypted_datalen =3D NULL;
 	char *hex_encoded_iv =3D NULL;
@@ -681,17 +739,18 @@ static int encrypted_instantiate(struct key *key, con=
st void *data,
 		return -ENOMEM;
 	datablob[datalen] =3D 0;
 	memcpy(datablob, data, datalen);
=2D	ret =3D datablob_parse(datablob, &master_desc, &decrypted_datalen,
=2D			     &hex_encoded_iv);
+	ret =3D datablob_parse(datablob, &format, &master_desc,
+			     &decrypted_datalen, &hex_encoded_iv);
 	if (ret < 0)
 		goto out;
=20
=2D	epayload =3D encrypted_key_alloc(key, master_desc, decrypted_datalen);
+	epayload =3D encrypted_key_alloc(key, format, master_desc,
+				       decrypted_datalen);
 	if (IS_ERR(epayload)) {
 		ret =3D PTR_ERR(epayload);
 		goto out;
 	}
=2D	ret =3D encrypted_init(epayload, master_desc, decrypted_datalen,
+	ret =3D encrypted_init(epayload, format, master_desc, decrypted_datalen,
 			     hex_encoded_iv);
 	if (ret < 0) {
 		kfree(epayload);
@@ -728,6 +787,7 @@ static int encrypted_update(struct key *key, const void=
 *data, size_t datalen)
 	struct encrypted_key_payload *new_epayload;
 	char *buf;
 	char *new_master_desc =3D NULL;
+	const char *format =3D NULL;
 	int ret =3D 0;
=20
 	if (datalen <=3D 0 || datalen > 32767 || !data)
@@ -739,7 +799,7 @@ static int encrypted_update(struct key *key, const void=
 *data, size_t datalen)
=20
 	buf[datalen] =3D 0;
 	memcpy(buf, data, datalen);
=2D	ret =3D datablob_parse(buf, &new_master_desc, NULL, NULL);
+	ret =3D datablob_parse(buf, &format, &new_master_desc, NULL, NULL);
 	if (ret < 0)
 		goto out;
=20
@@ -747,18 +807,19 @@ static int encrypted_update(struct key *key, const vo=
id *data, size_t datalen)
 	if (ret < 0)
 		goto out;
=20
=2D	new_epayload =3D encrypted_key_alloc(key, new_master_desc,
=2D					   epayload->datalen);
+	new_epayload =3D encrypted_key_alloc(key, epayload->format,
+					   new_master_desc, epayload->datalen);
 	if (IS_ERR(new_epayload)) {
 		ret =3D PTR_ERR(new_epayload);
 		goto out;
 	}
=20
=2D	__ekey_init(new_epayload, new_master_desc, epayload->datalen);
+	__ekey_init(new_epayload, epayload->format, new_master_desc,
+		    epayload->datalen);
=20
 	memcpy(new_epayload->iv, epayload->iv, ivsize);
=2D	memcpy(new_epayload->decrypted_data, epayload->decrypted_data,
=2D	       epayload->decrypted_datalen);
+	memcpy(new_epayload->payload_data, epayload->payload_data,
+	       epayload->payload_datalen);
=20
 	rcu_assign_pointer(key->payload.data, new_epayload);
 	call_rcu(&epayload->rcu, encrypted_rcu_free);
=2D-=20
1.7.2.3


--nextPart5749342.I5aPMAWj3C
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

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
IwQYMBaAFNB15T/ryrprllF8IKWYvfNn07RKMIGRBgNVHSAEgYkwgYYwPgYKKwYBBAGpBwEBAjAw
MC4GCCsGAQUFBwIBFiJodHRwOi8vd3d3LmV1cm9wa2kub3JnL2NhL2Nwcy8xLjIvMEQGCisGAQQB
qQcCAQIwNjA0BggrBgEFBQcCARYoaHR0cDovL3d3dy5pdGFseS5ldXJvcGtpLm9yZy9jYS9jcHMv
MS4yLzB+BggrBgEFBQcBAQRyMHAwKQYIKwYBBQUHMAGGHWh0dHA6Ly9vY3NwLml0YWx5LmV1cm9w
a2kub3JnMEMGCCsGAQUFBzAChjdodHRwOi8vd3d3Lml0YWx5LmV1cm9wa2kub3JnL2NhL2NlcnRz
L2V1cm9wa2lfaXRhbHkuY2VyMEIGA1UdHwQ7MDkwN6A1oDOGMWh0dHA6Ly93d3cuaXRhbHkuZXVy
b3BraS5vcmcvY2EvY3JsL2l0YWx5X2NybC5jcmwwDQYJKoZIhvcNAQEFBQADggEBAFNUlYhQGVuP
EVBOSNEuC80+3TebY0iGAK35IggW4LiuEHXRWoeKwBbryFfEcR8VnTovF4wufegac+uJZB2k+QLs
wC3zuJLIgbo593W83ShSG5aCJioMoQ5X9Zfd+j1BfIV/zARyhorEvgC7doGfBVxG3qAmQEYbonot
hz4UJWld3Gd3zmwpqpNMLG2JO3BJWOrAun9SWPVRLOE/92Pq/jTMB6Lkse0KNJTBbNHPUzydOzPU
tPA7JvMDnzb6L98hVVqKoxmJw3C2sV/NOl/tuTfS6dnZypZstRaOV0JSWgP4PAqcPte0N40h8q4D
/Rdg5P7EcUklgZqL57cyUCCQro8wggVgMIIESKADAgECAgICuzANBgkqhkiG9w0BAQUFADBlMQsw
CQYDVQQGEwJJVDEeMBwGA1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMTYwNAYDVQQDEy1Qb2xp
dGVjbmljbyBkaSBUb3Jpbm8gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTAxMjIwMTExOTU0
WhcNMTUxMjMxMjM1OTU5WjBfMQswCQYDVQQGEwJJVDEeMBwGA1UEChMVUG9saXRlY25pY28gZGkg
VG9yaW5vMRcwFQYDVQQDEw5Sb2JlcnRvICBTYXNzdTEXMBUGCgmSJomT8ixkAQETB2QwMjEzMDUw
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDS6p4SaJdmmJHJu9On9ZohhBFE2GgYiY7Y
tRnhhQJANfOtHEhSbpUMaSOfq/Pna6ipR5nAFrlM8cOGcSHZdxrPcgzeJU7F2v1fl2ThvFOcTIkc
C1aAJGQUuCaCXDlQt+KFecJWTrRZnalMHZueO+J6cgHcvR1CQz5e88dSzo3QXZy0w/hxGL9Ht9ve
lqsl48ohBk2rs/svAOCp6GfqT1Yxwx1p87d3ViTrmuZB4/X+da39nJqmo6AZ/y3Zg+r91BgNcfsH
VqFT0JTcG6qRIaeqTtqVYpYl+rH1rZzYCakDyQyys66sBvaXyaiMr0M+SpyH+LaGz5bDn5Odq16F
YEq7AgMBAAGjggIeMIICGjAOBgNVHQ8BAf8EBAMCA/gwJwYDVR0lBCAwHgYIKwYBBQUHAwIGCCsG
AQUFBwMDBggrBgEFBQcDBDAiBgNVHREEGzAZgRdyb2JlcnRvLnNhc3N1QHBvbGl0by5pdDAMBgNV
HRMBAf8EAjAAMB0GA1UdDgQWBBQgKbXSXn+j769x0tsZQ9pSOzIIdDAfBgNVHSMEGDAWgBTNm1tb
nup2IcQQaOjSLTfbHy/I5DCBywYDVR0gBIHDMIHAMD4GCisGAQQBqQcBAQIwMDAuBggrBgEFBQcC
ARYiaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9jcHMvMS4yLzBEBgorBgEEAakHAgECMDYwNAYI
KwYBBQUHAgEWKGh0dHA6Ly93d3cuaXRhbHkuZXVyb3BraS5vcmcvY2EvY3BzLzEuMi8wOAYKKwYB
BAGVYgECAjAqMCgGCCsGAQUFBwIBFhxodHRwOi8vY2EucG9saXRvLml0L2Nwcy8yLjIvMGYGCCsG
AQUFBwEBBFowWDAhBggrBgEFBQcwAYYVaHR0cDovL29jc3AucG9saXRvLml0MDMGCCsGAQUFBzAC
hidodHRwOi8vY2EucG9saXRvLml0L2NlcnRzL3BvbGl0b19jYS5jZXIwNwYDVR0fBDAwLjAsoCqg
KIYmaHR0cDovL2NhLnBvbGl0by5pdC9jcmwvcG9saXRvX2NybC5jcmwwDQYJKoZIhvcNAQEFBQAD
ggEBADMe0aHcBJXV6pMJPVVSt1Vazd8YLuTLO45Igs9Sb2LuaO6pvcDGvq9dEJnBhP1B+zBAK6WE
A1PWb66xC4QXaJnlGZTXS3XeBivHWm6BNOH2kNeU0HBeGZCV/n5r70TPxkEAcc7u8YY2i6CiMM42
8YhZK8ZjoN9D3QNIRf4HZgh0FTbf8eL/XvBbK/oPC+Rew+Qql6M3DHnaS1q2SKUwwO/4VXA4JsOd
atFI68AMXH0Xx9UIcjRi+kvsyvwHlc0Z8AoAtfRMoIl4zFF4Qaowec2UunBKYlqPpFTtU9czuoEP
12A86nqSVsoNok2mZOeYa9IdIjeE2rfdKx6k3YNRg08xggIcMIICGAIBATBrMGUxCzAJBgNVBAYT
AklUMR4wHAYDVQQKExVQb2xpdGVjbmljbyBkaSBUb3Jpbm8xNjA0BgNVBAMTLVBvbGl0ZWNuaWNv
IGRpIFRvcmlubyBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eQICArswCQYFKw4DAhoFAKCBhzAYBgkq
hkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMDEyMjMxNzM1MDBaMCMGCSqG
SIb3DQEJBDEWBBSDSgEdNhf9K1fX32wSfilrP/URWjAoBgkqhkiG9w0BCQ8xGzAZMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzANBgkqhkiG9w0BAQEFAASCAQCoDgwKSSyqEaT4BjEtkdmLaEWKgyKN
veCo5XOJmGwLbgAPMy7g5SWkamH+IuX42BRhjG4CQ1K5BKQ/kL5Oq0tmI1lMNuRXE1DqW80YcN7P
4MVx9INDlAP6+q0qd2E5S8KV27xLiNVDEXchluj6sNYRw8QqxnaeXE7ihsU2/kFQBDiHz03izbaF
0/ms+mSQR99bwCJ2jl3sZyXfKWtKQxy9mQuy9ipgSKeEBcBV3bip8R3P6g3y0Y268/0Afl+FS1kj
svCQboElzrWYQKuZRz4VuegedSBDBL+gqKh9Tc4V+lIO7m5B02YwdqhCfG+eOBx2YDiZ/xPLSug7
X9jq/BOsAAAAAAAA

--nextPart5749342.I5aPMAWj3C--
