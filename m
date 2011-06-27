Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab1F0Lw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 07:52:56 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:36754 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756132Ab1F0Luz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 07:50:55 -0400
X-Sasl-enc: lZn/LSMllVexz6nkJsi0+HWWp4xCb7DDelM7V0oqFIPV 1309175454
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: keyrings@linux-nfs.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com, jmorris@namei.org,
        zohar@linux.vnet.ibm.com, safford@watson.ibm.com, ramunno@polito.it,
        tyhicks@linux.vnet.ibm.com, kirkland@canonical.com,
        ecryptfs-devel@lists.launchpad.net,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH v5 4/7] encrypted-keys: add key format support
Date: Mon, 27 Jun 2011 13:45:42 +0200
Message-Id: <1309175148-6651-5-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1309175148-6651-1-git-send-email-roberto.sassu@polito.it>
References: <1309175148-6651-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----A6B40B42FB3353543E0841EC1819D756"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------A6B40B42FB3353543E0841EC1819D756

This patch introduces a new parameter, called 'format', that defines the
format of data stored by encrypted keys. The 'default' format identifies
encrypted keys containing only the symmetric key, while other formats can
be defined to support additional information. The 'format' parameter is
written in the datablob produced by commands 'keyctl print' or
'keyctl pipe' and is integrity protected by the HMAC.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Acked-by: Gianluca Ramunno <ramunno@polito.it>
Acked-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: David Howells <dhowells@redhat.com>
---
 Documentation/security/keys-trusted-encrypted.txt |   48 +++++---
 include/keys/encrypted-type.h                     |   13 ++-
 security/keys/encrypted.c                         |  141 +++++++++++++++------
 3 files changed, 142 insertions(+), 60 deletions(-)

diff --git a/Documentation/security/keys-trusted-encrypted.txt b/Documentation/security/keys-trusted-encrypted.txt
index 8fb79bc..0afcb50 100644
--- a/Documentation/security/keys-trusted-encrypted.txt
+++ b/Documentation/security/keys-trusted-encrypted.txt
@@ -53,12 +53,19 @@ they are only as secure as the user key encrypting them.  The master user key
 should therefore be loaded in as secure a way as possible, preferably early in
 boot.
 
+The decrypted portion of encrypted keys can contain either a simple symmetric
+key or a more complex structure. The format of the more complex structure is
+application specific, which is identified by 'format'.
+
 Usage:
-  keyctl add encrypted name "new key-type:master-key-name keylen" ring
-  keyctl add encrypted name "load hex_blob" ring
-  keyctl update keyid "update key-type:master-key-name"
+    keyctl add encrypted name "new [format] key-type:master-key-name keylen"
+        ring
+    keyctl add encrypted name "load hex_blob" ring
+    keyctl update keyid "update key-type:master-key-name"
+
+format:= 'default'
+key-type:= 'trusted' | 'user'
 
-where 'key-type' is either 'trusted' or 'user'.
 
 Examples of trusted and encrypted key usage:
 
@@ -114,15 +121,25 @@ Reseal a trusted key under new pcr values:
     7ef6a24defe4846104209bf0c3eced7fa1a672ed5b125fc9d8cd88b476a658a4434644ef
     df8ae9a178e9f83ba9f08d10fa47e4226b98b0702f06b3b8
 
-Create and save an encrypted key "evm" using the above trusted key "kmk":
+The initial consumer of trusted keys is EVM, which at boot time needs a high
+quality symmetric key for HMAC protection of file metadata.  The use of a
+trusted key provides strong guarantees that the EVM key has not been
+compromised by a user level problem, and when sealed to specific boot PCR
+values, protects against boot and offline attacks.  Create and save an
+encrypted key "evm" using the above trusted key "kmk":
 
+option 1: omitting 'format'
     $ keyctl add encrypted evm "new trusted:kmk 32" @u
     159771175
 
+option 2: explicitly defining 'format' as 'default'
+    $ keyctl add encrypted evm "new default trusted:kmk 32" @u
+    159771175
+
     $ keyctl print 159771175
-    trusted:kmk 32 2375725ad57798846a9bbd240de8906f006e66c03af53b1b382dbbc55
-    be2a44616e4959430436dc4f2a7a9659aa60bb4652aeb2120f149ed197c564e024717c64
-    5972dcb82ab2dde83376d82b2e3c09ffc
+    default trusted:kmk 32 2375725ad57798846a9bbd240de8906f006e66c03af53b1b3
+    82dbbc55be2a44616e4959430436dc4f2a7a9659aa60bb4652aeb2120f149ed197c564e0
+    24717c64 5972dcb82ab2dde83376d82b2e3c09ffc
 
     $ keyctl pipe 159771175 > evm.blob
 
@@ -132,14 +149,9 @@ Load an encrypted key "evm" from saved blob:
     831684262
 
     $ keyctl print 831684262
-    trusted:kmk 32 2375725ad57798846a9bbd240de8906f006e66c03af53b1b382dbbc55
-    be2a44616e4959430436dc4f2a7a9659aa60bb4652aeb2120f149ed197c564e024717c64
-    5972dcb82ab2dde83376d82b2e3c09ffc
-
+    default trusted:kmk 32 2375725ad57798846a9bbd240de8906f006e66c03af53b1b3
+    82dbbc55be2a44616e4959430436dc4f2a7a9659aa60bb4652aeb2120f149ed197c564e0
+    24717c64 5972dcb82ab2dde83376d82b2e3c09ffc
 
-The initial consumer of trusted keys is EVM, which at boot time needs a high
-quality symmetric key for HMAC protection of file metadata.  The use of a
-trusted key provides strong guarantees that the EVM key has not been
-compromised by a user level problem, and when sealed to specific boot PCR
-values, protects against boot and offline attacks.  Other uses for trusted and
-encrypted keys, such as for disk and file encryption are anticipated.
+Other uses for trusted and encrypted keys, such as for disk and file encryption
+are anticipated.
diff --git a/include/keys/encrypted-type.h b/include/keys/encrypted-type.h
index 9585501..1d45413 100644
--- a/include/keys/encrypted-type.h
+++ b/include/keys/encrypted-type.h
@@ -1,6 +1,11 @@
 /*
  * Copyright (C) 2010 IBM Corporation
- * Author: Mimi Zohar <zohar@us.ibm.com>
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
 
 struct encrypted_key_payload {
 	struct rcu_head rcu;
+	char *format;		/* datablob: format */
 	char *master_desc;	/* datablob: master key name */
 	char *datalen;		/* datablob: decrypted key length */
 	u8 *iv;			/* datablob: iv */
 	u8 *encrypted_data;	/* datablob: encrypted data */
 	unsigned short datablob_len;	/* length of datablob */
 	unsigned short decrypted_datalen;	/* decrypted data length */
-	u8 decrypted_data[0];	/* decrypted data +  datablob + hmac */
+	unsigned short payload_datalen;		/* payload data length */
+	unsigned short encrypted_key_format;	/* encrypted key format */
+	u8 *decrypted_data;	/* decrypted data */
+	u8 payload_data[0];	/* payload data + datablob + hmac */
 };
 
 extern struct key_type key_type_encrypted;
diff --git a/security/keys/encrypted.c b/security/keys/encrypted.c
index f36a105..89981c9 100644
--- a/security/keys/encrypted.c
+++ b/security/keys/encrypted.c
@@ -1,8 +1,11 @@
 /*
  * Copyright (C) 2010 IBM Corporation
+ * Copyright (C) 2010 Politecnico di Torino, Italy
+ *                    TORSEC group -- http://security.polito.it
  *
- * Author:
+ * Authors:
  * Mimi Zohar <zohar@us.ibm.com>
+ * Roberto Sassu <roberto.sassu@polito.it>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -37,6 +40,7 @@ static const char KEY_USER_PREFIX[] = "user:";
 static const char hash_alg[] = "sha256";
 static const char hmac_alg[] = "hmac(sha256)";
 static const char blkcipher_alg[] = "cbc(aes)";
+static const char key_format_default[] = "default";
 static unsigned int ivsize;
 static int blksize;
 
@@ -58,6 +62,15 @@ enum {
 	Opt_err = -1, Opt_new, Opt_load, Opt_update
 };
 
+enum {
+	Opt_error = -1, Opt_default
+};
+
+static const match_table_t key_format_tokens = {
+	{Opt_default, "default"},
+	{Opt_error, NULL}
+};
+
 static const match_table_t key_tokens = {
 	{Opt_new, "new"},
 	{Opt_load, "load"},
@@ -118,8 +131,9 @@ out:
  * datablob_parse - parse the keyctl data
  *
  * datablob format:
- * new <master-key name> <decrypted data length>
- * load <master-key name> <decrypted data length> <encrypted iv + data>
+ * new [<format>] <master-key name> <decrypted data length>
+ * load [<format>] <master-key name> <decrypted data length>
+ *     <encrypted iv + data>
  * update <new-master-key name>
  *
  * Tokenizes a copy of the keyctl data, returning a pointer to each token,
@@ -127,13 +141,15 @@ out:
  *
  * On success returns 0, otherwise -EINVAL.
  */
-static int datablob_parse(char *datablob, char **master_desc,
-			  char **decrypted_datalen, char **hex_encoded_iv)
+static int datablob_parse(char *datablob, const char **format,
+			  char **master_desc, char **decrypted_datalen,
+			  char **hex_encoded_iv)
 {
 	substring_t args[MAX_OPT_ARGS];
 	int ret = -EINVAL;
 	int key_cmd;
-	char *keyword;
+	int key_format;
+	char *p, *keyword;
 
 	keyword = strsep(&datablob, " \t");
 	if (!keyword) {
@@ -142,7 +158,24 @@ static int datablob_parse(char *datablob, char **master_desc,
 	}
 	key_cmd = match_token(keyword, key_tokens, args);
 
-	*master_desc = strsep(&datablob, " \t");
+	/* Get optional format: default */
+	p = strsep(&datablob, " \t");
+	if (!p) {
+		pr_err("encrypted_key: insufficient parameters specified\n");
+		return ret;
+	}
+
+	key_format = match_token(p, key_format_tokens, args);
+	switch (key_format) {
+	case Opt_default:
+		*format = p;
+		*master_desc = strsep(&datablob, " \t");
+		break;
+	case Opt_error:
+		*master_desc = p;
+		break;
+	}
+
 	if (!*master_desc) {
 		pr_info("encrypted_key: master key parameter is missing\n");
 		goto out;
@@ -220,8 +253,8 @@ static char *datablob_format(struct encrypted_key_payload *epayload,
 	ascii_buf[asciiblob_len] = '\0';
 
 	/* copy datablob master_desc and datalen strings */
-	len = sprintf(ascii_buf, "%s %s ", epayload->master_desc,
-		      epayload->datalen);
+	len = sprintf(ascii_buf, "%s %s %s ", epayload->format,
+		      epayload->master_desc, epayload->datalen);
 
 	/* convert the hex encoded iv, encrypted-data and HMAC to ascii */
 	bufp = &ascii_buf[len];
@@ -464,9 +497,9 @@ static int datablob_hmac_append(struct encrypted_key_payload *epayload,
 	if (ret < 0)
 		goto out;
 
-	digest = epayload->master_desc + epayload->datablob_len;
+	digest = epayload->format + epayload->datablob_len;
 	ret = calc_hmac(digest, derived_key, sizeof derived_key,
-			epayload->master_desc, epayload->datablob_len);
+			epayload->format, epayload->datablob_len);
 	if (!ret)
 		dump_hmac(NULL, digest, HASH_SIZE);
 out:
@@ -475,26 +508,35 @@ out:
 
 /* verify HMAC before decrypting encrypted key */
 static int datablob_hmac_verify(struct encrypted_key_payload *epayload,
-				const u8 *master_key, size_t master_keylen)
+				const u8 *format, const u8 *master_key,
+				size_t master_keylen)
 {
 	u8 derived_key[HASH_SIZE];
 	u8 digest[HASH_SIZE];
 	int ret;
+	char *p;
+	unsigned short len;
 
 	ret = get_derived_key(derived_key, AUTH_KEY, master_key, master_keylen);
 	if (ret < 0)
 		goto out;
 
-	ret = calc_hmac(digest, derived_key, sizeof derived_key,
-			epayload->master_desc, epayload->datablob_len);
+	len = epayload->datablob_len;
+	if (!format) {
+		p = epayload->master_desc;
+		len -= strlen(epayload->format) + 1;
+	} else
+		p = epayload->format;
+
+	ret = calc_hmac(digest, derived_key, sizeof derived_key, p, len);
 	if (ret < 0)
 		goto out;
-	ret = memcmp(digest, epayload->master_desc + epayload->datablob_len,
+	ret = memcmp(digest, epayload->format + epayload->datablob_len,
 		     sizeof digest);
 	if (ret) {
 		ret = -EINVAL;
 		dump_hmac("datablob",
-			  epayload->master_desc + epayload->datablob_len,
+			  epayload->format + epayload->datablob_len,
 			  HASH_SIZE);
 		dump_hmac("calc", digest, HASH_SIZE);
 	}
@@ -539,13 +581,16 @@ out:
 
 /* Allocate memory for decrypted key and datablob. */
 static struct encrypted_key_payload *encrypted_key_alloc(struct key *key,
+							 const char *format,
 							 const char *master_desc,
 							 const char *datalen)
 {
 	struct encrypted_key_payload *epayload = NULL;
 	unsigned short datablob_len;
 	unsigned short decrypted_datalen;
+	unsigned short payload_datalen;
 	unsigned int encrypted_datalen;
+	unsigned int format_len;
 	long dlen;
 	int ret;
 
@@ -553,29 +598,32 @@ static struct encrypted_key_payload *encrypted_key_alloc(struct key *key,
 	if (ret < 0 || dlen < MIN_DATA_SIZE || dlen > MAX_DATA_SIZE)
 		return ERR_PTR(-EINVAL);
 
+	format_len = (!format) ? strlen(key_format_default) : strlen(format);
 	decrypted_datalen = dlen;
+	payload_datalen = decrypted_datalen;
 	encrypted_datalen = roundup(decrypted_datalen, blksize);
 
-	datablob_len = strlen(master_desc) + 1 + strlen(datalen) + 1
-	    + ivsize + 1 + encrypted_datalen;
+	datablob_len = format_len + 1 + strlen(master_desc) + 1
+	    + strlen(datalen) + 1 + ivsize + 1 + encrypted_datalen;
 
-	ret = key_payload_reserve(key, decrypted_datalen + datablob_len
+	ret = key_payload_reserve(key, payload_datalen + datablob_len
 				  + HASH_SIZE + 1);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	epayload = kzalloc(sizeof(*epayload) + decrypted_datalen +
+	epayload = kzalloc(sizeof(*epayload) + payload_datalen +
 			   datablob_len + HASH_SIZE + 1, GFP_KERNEL);
 	if (!epayload)
 		return ERR_PTR(-ENOMEM);
 
+	epayload->payload_datalen = payload_datalen;
 	epayload->decrypted_datalen = decrypted_datalen;
 	epayload->datablob_len = datablob_len;
 	return epayload;
 }
 
 static int encrypted_key_decrypt(struct encrypted_key_payload *epayload,
-				 const char *hex_encoded_iv)
+				 const char *format, const char *hex_encoded_iv)
 {
 	struct key *mkey;
 	u8 derived_key[HASH_SIZE];
@@ -596,14 +644,14 @@ static int encrypted_key_decrypt(struct encrypted_key_payload *epayload,
 	hex2bin(epayload->iv, hex_encoded_iv, ivsize);
 	hex2bin(epayload->encrypted_data, hex_encoded_data, encrypted_datalen);
 
-	hmac = epayload->master_desc + epayload->datablob_len;
+	hmac = epayload->format + epayload->datablob_len;
 	hex2bin(hmac, hex_encoded_data + (encrypted_datalen * 2), HASH_SIZE);
 
 	mkey = request_master_key(epayload, &master_key, &master_keylen);
 	if (IS_ERR(mkey))
 		return PTR_ERR(mkey);
 
-	ret = datablob_hmac_verify(epayload, master_key, master_keylen);
+	ret = datablob_hmac_verify(epayload, format, master_key, master_keylen);
 	if (ret < 0) {
 		pr_err("encrypted_key: bad hmac (%d)\n", ret);
 		goto out;
@@ -623,14 +671,23 @@ out:
 }
 
 static void __ekey_init(struct encrypted_key_payload *epayload,
-			const char *master_desc, const char *datalen)
+			const char *format, const char *master_desc,
+			const char *datalen)
 {
-	epayload->master_desc = epayload->decrypted_data
-	    + epayload->decrypted_datalen;
+	unsigned int format_len;
+
+	format_len = (!format) ? strlen(key_format_default) : strlen(format);
+	epayload->format = epayload->payload_data + epayload->payload_datalen;
+	epayload->master_desc = epayload->format + format_len + 1;
 	epayload->datalen = epayload->master_desc + strlen(master_desc) + 1;
 	epayload->iv = epayload->datalen + strlen(datalen) + 1;
 	epayload->encrypted_data = epayload->iv + ivsize + 1;
+	epayload->decrypted_data = epayload->payload_data;
 
+	if (!format)
+		memcpy(epayload->format, key_format_default, format_len);
+	else
+		memcpy(epayload->format, format, format_len);
 	memcpy(epayload->master_desc, master_desc, strlen(master_desc));
 	memcpy(epayload->datalen, datalen, strlen(datalen));
 }
@@ -642,19 +699,19 @@ static void __ekey_init(struct encrypted_key_payload *epayload,
  * itself.  For an old key, decrypt the hex encoded data.
  */
 static int encrypted_init(struct encrypted_key_payload *epayload,
-			  const char *master_desc, const char *datalen,
-			  const char *hex_encoded_iv)
+			  const char *format, const char *master_desc,
+			  const char *datalen, const char *hex_encoded_iv)
 {
 	int ret = 0;
 
-	__ekey_init(epayload, master_desc, datalen);
+	__ekey_init(epayload, format, master_desc, datalen);
 	if (!hex_encoded_iv) {
 		get_random_bytes(epayload->iv, ivsize);
 
 		get_random_bytes(epayload->decrypted_data,
 				 epayload->decrypted_datalen);
 	} else
-		ret = encrypted_key_decrypt(epayload, hex_encoded_iv);
+		ret = encrypted_key_decrypt(epayload, format, hex_encoded_iv);
 	return ret;
 }
 
@@ -671,6 +728,7 @@ static int encrypted_instantiate(struct key *key, const void *data,
 {
 	struct encrypted_key_payload *epayload = NULL;
 	char *datablob = NULL;
+	const char *format = NULL;
 	char *master_desc = NULL;
 	char *decrypted_datalen = NULL;
 	char *hex_encoded_iv = NULL;
@@ -684,17 +742,18 @@ static int encrypted_instantiate(struct key *key, const void *data,
 		return -ENOMEM;
 	datablob[datalen] = 0;
 	memcpy(datablob, data, datalen);
-	ret = datablob_parse(datablob, &master_desc, &decrypted_datalen,
-			     &hex_encoded_iv);
+	ret = datablob_parse(datablob, &format, &master_desc,
+			     &decrypted_datalen, &hex_encoded_iv);
 	if (ret < 0)
 		goto out;
 
-	epayload = encrypted_key_alloc(key, master_desc, decrypted_datalen);
+	epayload = encrypted_key_alloc(key, format, master_desc,
+				       decrypted_datalen);
 	if (IS_ERR(epayload)) {
 		ret = PTR_ERR(epayload);
 		goto out;
 	}
-	ret = encrypted_init(epayload, master_desc, decrypted_datalen,
+	ret = encrypted_init(epayload, format, master_desc, decrypted_datalen,
 			     hex_encoded_iv);
 	if (ret < 0) {
 		kfree(epayload);
@@ -731,6 +790,7 @@ static int encrypted_update(struct key *key, const void *data, size_t datalen)
 	struct encrypted_key_payload *new_epayload;
 	char *buf;
 	char *new_master_desc = NULL;
+	const char *format = NULL;
 	int ret = 0;
 
 	if (datalen <= 0 || datalen > 32767 || !data)
@@ -742,7 +802,7 @@ static int encrypted_update(struct key *key, const void *data, size_t datalen)
 
 	buf[datalen] = 0;
 	memcpy(buf, data, datalen);
-	ret = datablob_parse(buf, &new_master_desc, NULL, NULL);
+	ret = datablob_parse(buf, &format, &new_master_desc, NULL, NULL);
 	if (ret < 0)
 		goto out;
 
@@ -750,18 +810,19 @@ static int encrypted_update(struct key *key, const void *data, size_t datalen)
 	if (ret < 0)
 		goto out;
 
-	new_epayload = encrypted_key_alloc(key, new_master_desc,
-					   epayload->datalen);
+	new_epayload = encrypted_key_alloc(key, epayload->format,
+					   new_master_desc, epayload->datalen);
 	if (IS_ERR(new_epayload)) {
 		ret = PTR_ERR(new_epayload);
 		goto out;
 	}
 
-	__ekey_init(new_epayload, new_master_desc, epayload->datalen);
+	__ekey_init(new_epayload, epayload->format, new_master_desc,
+		    epayload->datalen);
 
 	memcpy(new_epayload->iv, epayload->iv, ivsize);
-	memcpy(new_epayload->decrypted_data, epayload->decrypted_data,
-	       epayload->decrypted_datalen);
+	memcpy(new_epayload->payload_data, epayload->payload_data,
+	       epayload->payload_datalen);
 
 	rcu_assign_pointer(key->payload.data, new_epayload);
 	call_rcu(&epayload->rcu, encrypted_rcu_free);
-- 
1.7.4.4


------A6B40B42FB3353543E0841EC1819D756
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

MIIICQYJKoZIhvcNAQcCoIIH+jCCB/YCAQExCzAJBgUrDgMCGgUAMAsGCSqGSIb3
DQEHAaCCBWQwggVgMIIESKADAgECAgICuzANBgkqhkiG9w0BAQUFADBlMQswCQYD
VQQGEwJJVDEeMBwGA1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMTYwNAYDVQQD
Ey1Qb2xpdGVjbmljbyBkaSBUb3Jpbm8gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkw
HhcNMTAxMjIwMTExOTU0WhcNMTUxMjMxMjM1OTU5WjBfMQswCQYDVQQGEwJJVDEe
MBwGA1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMRcwFQYDVQQDEw5Sb2JlcnRv
ICBTYXNzdTEXMBUGCgmSJomT8ixkAQETB2QwMjEzMDUwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQDS6p4SaJdmmJHJu9On9ZohhBFE2GgYiY7YtRnhhQJA
NfOtHEhSbpUMaSOfq/Pna6ipR5nAFrlM8cOGcSHZdxrPcgzeJU7F2v1fl2ThvFOc
TIkcC1aAJGQUuCaCXDlQt+KFecJWTrRZnalMHZueO+J6cgHcvR1CQz5e88dSzo3Q
XZy0w/hxGL9Ht9velqsl48ohBk2rs/svAOCp6GfqT1Yxwx1p87d3ViTrmuZB4/X+
da39nJqmo6AZ/y3Zg+r91BgNcfsHVqFT0JTcG6qRIaeqTtqVYpYl+rH1rZzYCakD
yQyys66sBvaXyaiMr0M+SpyH+LaGz5bDn5Odq16FYEq7AgMBAAGjggIeMIICGjAO
BgNVHQ8BAf8EBAMCA/gwJwYDVR0lBCAwHgYIKwYBBQUHAwIGCCsGAQUFBwMDBggr
BgEFBQcDBDAiBgNVHREEGzAZgRdyb2JlcnRvLnNhc3N1QHBvbGl0by5pdDAMBgNV
HRMBAf8EAjAAMB0GA1UdDgQWBBQgKbXSXn+j769x0tsZQ9pSOzIIdDAfBgNVHSME
GDAWgBTNm1tbnup2IcQQaOjSLTfbHy/I5DCBywYDVR0gBIHDMIHAMD4GCisGAQQB
qQcBAQIwMDAuBggrBgEFBQcCARYiaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9j
cHMvMS4yLzBEBgorBgEEAakHAgECMDYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93d3cu
aXRhbHkuZXVyb3BraS5vcmcvY2EvY3BzLzEuMi8wOAYKKwYBBAGVYgECAjAqMCgG
CCsGAQUFBwIBFhxodHRwOi8vY2EucG9saXRvLml0L2Nwcy8yLjIvMGYGCCsGAQUF
BwEBBFowWDAhBggrBgEFBQcwAYYVaHR0cDovL29jc3AucG9saXRvLml0MDMGCCsG
AQUFBzAChidodHRwOi8vY2EucG9saXRvLml0L2NlcnRzL3BvbGl0b19jYS5jZXIw
NwYDVR0fBDAwLjAsoCqgKIYmaHR0cDovL2NhLnBvbGl0by5pdC9jcmwvcG9saXRv
X2NybC5jcmwwDQYJKoZIhvcNAQEFBQADggEBADMe0aHcBJXV6pMJPVVSt1Vazd8Y
LuTLO45Igs9Sb2LuaO6pvcDGvq9dEJnBhP1B+zBAK6WEA1PWb66xC4QXaJnlGZTX
S3XeBivHWm6BNOH2kNeU0HBeGZCV/n5r70TPxkEAcc7u8YY2i6CiMM428YhZK8Zj
oN9D3QNIRf4HZgh0FTbf8eL/XvBbK/oPC+Rew+Qql6M3DHnaS1q2SKUwwO/4VXA4
JsOdatFI68AMXH0Xx9UIcjRi+kvsyvwHlc0Z8AoAtfRMoIl4zFF4Qaowec2UunBK
YlqPpFTtU9czuoEP12A86nqSVsoNok2mZOeYa9IdIjeE2rfdKx6k3YNRg08xggJt
MIICaQIBATBrMGUxCzAJBgNVBAYTAklUMR4wHAYDVQQKExVQb2xpdGVjbmljbyBk
aSBUb3Jpbm8xNjA0BgNVBAMTLVBvbGl0ZWNuaWNvIGRpIFRvcmlubyBDZXJ0aWZp
Y2F0aW9uIEF1dGhvcml0eQICArswCQYFKw4DAhoFAKCB2DAYBgkqhkiG9w0BCQMx
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTA2MjcxMTQ2MTVaMCMGCSqG
SIb3DQEJBDEWBBTgeiHB2TccFR6qqxpr/sh+XK8HPzB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQANuwKHTXsBgvvARF4h+0z/qOXM
9K1WMkUkE2QETacjfQ2uwZ/10eGkfRges0GLt6i87DYJaZPaOELsNr7kwS90aSmx
JKc2fKEeGBVgpQNANmhaMEkYWxuuS71JnxKpHF1loH0upaVjCnwnoJUexOqtIZud
/NXgtXWCV6TAKyLqHrb1IqVKgu4ImiFY3/mPvgaNf+QFmVTvpcvGIEVFQlAwbkk4
aT/YEzw6dHO5tdR7oFRFz4K/gnB7QDqN9JmQia8SBuZIv00Eryg/3D1aQ8sHTlZI
o3Ge6dLKKXzAXWjHK7XHyOigG8OZLpuAPzAjy7h5DjPVi0eNHwPcvz5e6s6H

------A6B40B42FB3353543E0841EC1819D756--


