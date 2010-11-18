Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760832Ab0KRWna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 17:43:30 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:35586 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760266Ab0KRWnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 17:43:25 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v1.4 5/5] keys: add new key-type encrypted
Date: Thu, 18 Nov 2010 17:42:46 -0500
Message-Id: <1290120166-3132-6-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1290120166-3132-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1290120166-3132-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define a new kernel key-type called 'encrypted'. Encrypted keys are kernel
generated random numbers, which are encrypted/decrypted with a 'trusted'
symmetric key. Encrypted keys are created/encrypted/decrypted in the kernel.
Userspace only ever sees/stores encrypted blobs.

Changelog:
- Moved documentation to Documentation/keys-trusted-encrypted.txt
- Replace hash with shash (based on comments by David Howells)
- Make lengths/counts size_t where possible (based on comments by David Howells)
  Could not convert most lengths, as crypto expects 'unsigned int'
  (size_t: on 32 bit is defined as unsigned int, but on 64 bit is unsigned long)
- Add 'const' where possible (based on comments by David Howells)
- allocate derived_buf dynamically to support arbitrary length master key
  (fixed by Roberto Sassu)
- wait until late_initcall for crypto libraries to be registered
- cleanup security/Kconfig
- Add missing 'update' keyword (reported/fixed by Roberto Sassu)
- Free epayload on failure to create key (reported/fixed by Roberto Sassu)
- Increase the data size limit (requested by Roberto Sassu)
- Crypto return codes are always 0 on success and negative on failure,
  remove unnecessary tests.
- Replaced kzalloc() with kmalloc()

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: David Safford <safford@watson.ibm.com>
Reviewed-by: Roberto Sassu <roberto.sassu@polito.it>
---
 include/keys/encrypted-type.h     |   29 ++
 security/Kconfig                  |   16 +
 security/keys/Makefile            |    1 +
 security/keys/encrypted_defined.c |  876 +++++++++++++++++++++++++++++++++++++
 security/keys/encrypted_defined.h |   56 +++
 5 files changed, 978 insertions(+), 0 deletions(-)
 create mode 100644 include/keys/encrypted-type.h
 create mode 100644 security/keys/encrypted_defined.c
 create mode 100644 security/keys/encrypted_defined.h

diff --git a/include/keys/encrypted-type.h b/include/keys/encrypted-type.h
new file mode 100644
index 0000000..9585501
--- /dev/null
+++ b/include/keys/encrypted-type.h
@@ -0,0 +1,29 @@
+/*
+ * Copyright (C) 2010 IBM Corporation
+ * Author: Mimi Zohar <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ */
+
+#ifndef _KEYS_ENCRYPTED_TYPE_H
+#define _KEYS_ENCRYPTED_TYPE_H
+
+#include <linux/key.h>
+#include <linux/rcupdate.h>
+
+struct encrypted_key_payload {
+	struct rcu_head rcu;
+	char *master_desc;	/* datablob: master key name */
+	char *datalen;		/* datablob: decrypted key length */
+	u8 *iv;			/* datablob: iv */
+	u8 *encrypted_data;	/* datablob: encrypted data */
+	unsigned short datablob_len;	/* length of datablob */
+	unsigned short decrypted_datalen;	/* decrypted data length */
+	u8 decrypted_data[0];	/* decrypted data +  datablob + hmac */
+};
+
+extern struct key_type key_type_encrypted;
+
+#endif /* _KEYS_ENCRYPTED_TYPE_H */
diff --git a/security/Kconfig b/security/Kconfig
index be2d1c6..de2a170 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -36,6 +36,22 @@ config TRUSTED_KEYS
 
 	  If you are unsure as to whether this is required, answer N.
 
+config ENCRYPTED_KEYS
+	tristate "ENCRYPTED KEYS"
+	depends on KEYS && TRUSTED_KEYS
+	select CRYPTO_AES
+	select CRYPTO_CBC
+	select CRYPTO_SHA256
+	select CRYPTO_RNG
+	help
+	  This option provides support for create/encrypting/decrypting keys
+	  in the kernel.  Encrypted keys are kernel generated random numbers,
+	  which are encrypted/decrypted with a 'master' symmetric key. The
+	  'master' key can be either a trusted-key or user-key type.
+	  Userspace only ever sees/stores encrypted blobs.
+
+	  If you are unsure as to whether this is required, answer N.
+
 config KEYS_DEBUG_PROC_KEYS
 	bool "Enable the /proc/keys file by which keys may be viewed"
 	depends on KEYS
diff --git a/security/keys/Makefile b/security/keys/Makefile
index fcb1070..6c94105 100644
--- a/security/keys/Makefile
+++ b/security/keys/Makefile
@@ -14,6 +14,7 @@ obj-y := \
 	user_defined.o
 
 obj-$(CONFIG_TRUSTED_KEYS) += trusted_defined.o
+obj-$(CONFIG_ENCRYPTED_KEYS) += encrypted_defined.o
 obj-$(CONFIG_KEYS_COMPAT) += compat.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_SYSCTL) += sysctl.o
diff --git a/security/keys/encrypted_defined.c b/security/keys/encrypted_defined.c
new file mode 100644
index 0000000..f2105a7
--- /dev/null
+++ b/security/keys/encrypted_defined.c
@@ -0,0 +1,876 @@
+/*
+ * Copyright (C) 2010 IBM Corporation
+ *
+ * Author:
+ * Mimi Zohar <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ *
+ * See Documentation/keys-trusted-encrypted.txt
+ */
+
+#include <linux/uaccess.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/parser.h>
+#include <linux/string.h>
+#include <keys/user-type.h>
+#include <keys/trusted-type.h>
+#include <keys/encrypted-type.h>
+#include <linux/key-type.h>
+#include <linux/random.h>
+#include <linux/rcupdate.h>
+#include <linux/scatterlist.h>
+#include <linux/crypto.h>
+#include <crypto/hash.h>
+#include <crypto/sha.h>
+#include <crypto/aes.h>
+
+#include "encrypted_defined.h"
+
+#define HASH_SIZE SHA256_DIGEST_SIZE
+#define MAX_DATA_SIZE 4096
+#define MIN_DATA_SIZE  20
+
+static const char hash_alg[] = "sha256";
+static const char hmac_alg[] = "hmac(sha256)";
+static const char blkcipher_alg[] = "cbc(aes)";
+static unsigned int ivsize;
+static int blksize;
+
+struct sdesc {
+	struct shash_desc shash;
+	char ctx[];
+};
+
+static struct crypto_shash *hashalg;
+static struct crypto_shash *hmacalg;
+
+static int aes_get_sizes(void)
+{
+	struct crypto_blkcipher *tfm;
+
+	tfm = crypto_alloc_blkcipher(blkcipher_alg, 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(tfm)) {
+		pr_err("encrypted_key: failed to alloc_cipher (%ld)\n",
+		       PTR_ERR(tfm));
+		return PTR_ERR(tfm);
+	}
+	ivsize = crypto_blkcipher_ivsize(tfm);
+	blksize = crypto_blkcipher_blocksize(tfm);
+	crypto_free_blkcipher(tfm);
+	return 0;
+}
+
+enum {
+	Opt_err = -1, Opt_new, Opt_load, Opt_update
+};
+
+static const match_table_t key_tokens = {
+	{Opt_new, "new"},
+	{Opt_load, "load"},
+	{Opt_update, "update"},
+	{Opt_err, NULL}
+};
+
+/*
+ * datablob_parse - parse the keyctl data
+ *
+ * datablob format:
+ * new <master-key name> <decrypted data length>
+ * load <master-key name> <decrypted data length> <encrypted iv + data>
+ * update <new-master-key name>
+ *
+ * Tokenizes a copy of the keyctl data, returning a pointer to each token,
+ * which is null terminated.
+ *
+ * On success returns 0, otherwise -EINVAL.
+ */
+static int datablob_parse(char *datablob, char **master_desc,
+			  char **decrypted_datalen, char **hex_encoded_iv,
+			  char **hex_encoded_data)
+{
+	substring_t args[MAX_OPT_ARGS];
+	int ret = -EINVAL;
+	int key_cmd;
+	size_t index;
+	char *p;
+
+	p = strsep(&datablob, " \t");
+	if (!p)
+		return ret;
+	key_cmd = match_token(p, key_tokens, args);
+
+	*master_desc = strsep(&datablob, " \t");
+	if (!*master_desc)
+		goto out;
+
+	/* desc must be prefixed with key-type ('trusted:' or 'user:') */
+	index = strcspn(*master_desc, ":");
+	if (index == strlen(*master_desc))
+		goto out;
+
+	if (decrypted_datalen) {
+		*decrypted_datalen = strsep(&datablob, " \t");
+		if (!*decrypted_datalen)
+			goto out;
+	}
+
+	switch (key_cmd) {
+	case Opt_new:
+		if (!decrypted_datalen)
+			break;
+		ret = 0;
+		break;
+	case Opt_load:
+		if (!decrypted_datalen)
+			break;
+		*hex_encoded_iv = strsep(&datablob, " \t");
+		if (!*hex_encoded_iv)
+			break;
+		*hex_encoded_data = *hex_encoded_iv + (2 * ivsize) + 2;
+		ret = 0;
+		break;
+	case Opt_update:
+		if (decrypted_datalen)
+			break;
+		ret = 0;
+		break;
+	case Opt_err:
+		break;
+	}
+out:
+	return ret;
+}
+
+/*
+ * datablob_format - format as an ascii string, before copying to userspace
+ */
+static int datablob_format(char __user *buffer,
+			   struct encrypted_key_payload *epayload,
+			   int asciiblob_len)
+{
+	char *ascii_buf, *bufp;
+	u8 *iv = epayload->iv;
+	int ret = 0;
+	int len;
+	int i;
+
+	ascii_buf = kmalloc(asciiblob_len + 1, GFP_KERNEL);
+	if (!ascii_buf)
+		return -ENOMEM;
+
+	ascii_buf[asciiblob_len] = '\0';
+
+	/* copy datablob master_desc and datalen strings */
+	len = sprintf(ascii_buf, "%s %s ", epayload->master_desc,
+		      epayload->datalen);
+
+	/* convert the hex encoded iv, encrypted-data and HMAC to ascii */
+	bufp = &ascii_buf[len];
+	for (i = 0; i < (asciiblob_len - len) / 2; i++)
+		bufp = pack_hex_byte(bufp, iv[i]);
+
+	if (copy_to_user(buffer, ascii_buf, asciiblob_len) != 0)
+		ret = -EFAULT;
+	kfree(ascii_buf);
+	return ret;
+}
+
+/*
+ * request_trusted_key - request the trusted key
+ *
+ * Trusted keys are sealed to PCRs and other metadata. Although userspace
+ * manages both trusted/encrypted key-types, like the encrypted key type
+ * data, trusted key type data is not visible decrypted from userspace.
+ */
+static struct key *request_trusted_key(const char *trusted_desc,
+				       u8 **master_key,
+				       unsigned int *master_keylen)
+{
+	struct trusted_key_payload *tpayload;
+	struct key *tkey;
+
+	tkey = request_key(&key_type_trusted, trusted_desc, NULL);
+	if (IS_ERR(tkey))
+		goto error;
+
+	rcu_read_lock();
+	tpayload = rcu_dereference(tkey->payload.data);
+	*master_key = tpayload->key;
+	*master_keylen = tpayload->key_len;
+error:
+	return tkey;
+}
+
+/*
+ * request_user_key - request the user key
+ *
+ * Use a user provided key to encrypt/decrypt an encrypted-key.
+ */
+static struct key *request_user_key(const char *master_desc, u8 **master_key,
+				    unsigned int *master_keylen)
+{
+	struct user_key_payload *upayload;
+	struct key *ukey;
+
+	ukey = request_key(&key_type_user, master_desc, NULL);
+	if (IS_ERR(ukey))
+		goto error;
+
+	rcu_read_lock();
+	upayload = rcu_dereference(ukey->payload.data);
+	*master_key = upayload->data;
+	*master_keylen = (unsigned int)upayload->datalen;
+error:
+	return ukey;
+}
+
+static struct sdesc *init_sdesc(struct crypto_shash *alg)
+{
+	struct sdesc *sdesc;
+	int size;
+
+	size = sizeof(struct shash_desc) + crypto_shash_descsize(alg);
+	sdesc = kmalloc(size, GFP_KERNEL);
+	if (!sdesc)
+		return ERR_PTR(-ENOMEM);
+	sdesc->shash.tfm = alg;
+	sdesc->shash.flags = 0x0;
+	return sdesc;
+}
+
+static int calc_hmac(u8 *digest, const u8 *key, unsigned int keylen,
+		     const u8 *buf, unsigned int buflen)
+{
+	struct sdesc *sdesc;
+	int ret;
+
+	sdesc = init_sdesc(hmacalg);
+	if (IS_ERR(sdesc)) {
+		pr_info("encrypted_key: can't alloc %s\n", hmac_alg);
+		return PTR_ERR(sdesc);
+	}
+
+	ret = crypto_shash_setkey(hmacalg, key, keylen);
+	if (!ret)
+		ret = crypto_shash_digest(&sdesc->shash, buf, buflen, digest);
+	kfree(sdesc);
+	return ret;
+}
+
+static int calc_hash(u8 *digest, const u8 *buf, unsigned int buflen)
+{
+	struct sdesc *sdesc;
+	int ret;
+
+	sdesc = init_sdesc(hashalg);
+	if (IS_ERR(sdesc)) {
+		pr_info("encrypted_key: can't alloc %s\n", hash_alg);
+		return PTR_ERR(sdesc);
+	}
+
+	ret = crypto_shash_digest(&sdesc->shash, buf, buflen, digest);
+	kfree(sdesc);
+	return ret;
+}
+
+enum derived_key_type { ENC_KEY, AUTH_KEY };
+
+/* Derive authentication/encryption key from trusted key */
+static int get_derived_key(u8 *derived_key, enum derived_key_type key_type,
+			   const u8 *master_key, unsigned int master_keylen)
+{
+	u8 *derived_buf;
+	unsigned int derived_buf_len;
+	int ret;
+
+	derived_buf_len = strlen("AUTH_KEY") + 1 + master_keylen;
+	if (derived_buf_len < HASH_SIZE)
+		derived_buf_len = HASH_SIZE;
+
+	derived_buf = kzalloc(derived_buf_len, GFP_KERNEL);
+	if (!derived_buf) {
+		pr_err("encrypted_key: out of memory\n");
+		return -ENOMEM;
+	}
+	if (key_type)
+		strcpy(derived_buf, "AUTH_KEY");
+	else
+		strcpy(derived_buf, "ENC_KEY");
+
+	memcpy(derived_buf + strlen(derived_buf) + 1, master_key,
+	       master_keylen);
+	ret = calc_hash(derived_key, derived_buf, derived_buf_len);
+	kfree(derived_buf);
+	return ret;
+}
+
+static int init_blkcipher_desc(struct blkcipher_desc *desc, const u8 *key,
+			       unsigned int key_len, const u8 *iv,
+			       unsigned int ivsize)
+{
+	int ret;
+
+	desc->tfm = crypto_alloc_blkcipher(blkcipher_alg, 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(desc->tfm)) {
+		pr_err("encrypted_key: failed to load %s transform (%ld)\n",
+		       blkcipher_alg, PTR_ERR(desc->tfm));
+		return PTR_ERR(desc->tfm);
+	}
+	desc->flags = 0;
+
+	ret = crypto_blkcipher_setkey(desc->tfm, key, key_len);
+	if (ret < 0) {
+		pr_err("encrypted_key: failed to setkey (%d)\n", ret);
+		crypto_free_blkcipher(desc->tfm);
+		return ret;
+	}
+	crypto_blkcipher_set_iv(desc->tfm, iv, ivsize);
+	return 0;
+}
+
+static struct key *request_master_key(struct encrypted_key_payload *epayload,
+				      u8 **master_key,
+				      unsigned int *master_keylen)
+{
+	struct key *mkey = NULL;
+	size_t index;
+
+	/* desc must be prefixed with key-type ('trusted:' or 'user:') */
+	index = strcspn(epayload->master_desc, ":");
+	if (index == strlen(epayload->master_desc))
+		goto out;
+
+	if (strncmp(epayload->master_desc, "trusted", index) == 0)
+		mkey = request_trusted_key(epayload->master_desc + index + 1,
+					   master_key, master_keylen);
+	else if (strncmp(epayload->master_desc, "user", index) == 0)
+		mkey = request_user_key(epayload->master_desc + index + 1,
+					master_key, master_keylen);
+	if (IS_ERR(mkey))
+		pr_info("encrypted_key: key %s not found",
+			epayload->master_desc);
+	if (mkey)
+		dump_master_key(*master_key, *master_keylen);
+out:
+	return mkey;
+}
+
+/* Before returning data to userspace, encrypt decrypted data. */
+static int derived_key_encrypt(struct encrypted_key_payload *epayload,
+			       u8 *derived_key, unsigned int derived_keylen)
+{
+	struct scatterlist sg_in[2];
+	struct scatterlist sg_out[1];
+	struct blkcipher_desc desc;
+	unsigned int encrypted_datalen;
+	unsigned int padlen;
+	char pad[16];
+	int ret;
+
+	encrypted_datalen = roundup(epayload->decrypted_datalen, blksize);
+	padlen = encrypted_datalen - epayload->decrypted_datalen;
+
+	ret = init_blkcipher_desc(&desc, derived_key, derived_keylen,
+				  epayload->iv, ivsize);
+	if (ret < 0)
+		goto out;
+	dump_decrypted_data(epayload);
+
+	memset(pad, 0, sizeof pad);
+	sg_init_table(sg_in, 2);
+	sg_set_buf(&sg_in[0], epayload->decrypted_data,
+		   epayload->decrypted_datalen);
+	sg_set_buf(&sg_in[1], pad, padlen);
+
+	sg_init_table(sg_out, 1);
+	sg_set_buf(sg_out, epayload->encrypted_data, encrypted_datalen);
+
+	ret = crypto_blkcipher_encrypt(&desc, sg_out, sg_in, encrypted_datalen);
+	crypto_free_blkcipher(desc.tfm);
+	if (ret < 0)
+		pr_err("encrypted_key: failed to encrypt (%d)\n", ret);
+	else
+		dump_encrypted_data(epayload, encrypted_datalen);
+out:
+	return ret;
+}
+
+static int datablob_hmac_append(struct encrypted_key_payload *epayload,
+				const u8 *master_key,
+				unsigned int master_keylen)
+{
+	u8 derived_key[HASH_SIZE];
+	u8 *digest;
+	int ret;
+
+	memset(derived_key, 0, sizeof derived_key);
+	ret = get_derived_key(derived_key, AUTH_KEY, master_key, master_keylen);
+	if (ret < 0)
+		goto out;
+
+	digest = epayload->master_desc + epayload->datablob_len;
+	ret = calc_hmac(digest, derived_key, sizeof derived_key,
+			epayload->master_desc, epayload->datablob_len);
+	if (!ret)
+		dump_hmac(NULL, digest, HASH_SIZE);
+out:
+	return ret;
+}
+
+/* verify HMAC before decrypting encrypted key */
+static int datablob_hmac_verify(struct encrypted_key_payload *epayload,
+				const u8 *master_key,
+				unsigned int master_keylen)
+{
+	u8 derived_key[HASH_SIZE];
+	u8 digest[HASH_SIZE];
+	int ret;
+
+	memset(derived_key, 0, sizeof derived_key);
+	ret = get_derived_key(derived_key, AUTH_KEY, master_key, master_keylen);
+	if (ret < 0)
+		goto out;
+
+	memset(digest, 0, sizeof digest);
+	ret = calc_hmac(digest, derived_key, sizeof derived_key,
+			epayload->master_desc, epayload->datablob_len);
+	if (ret < 0)
+		goto out;
+	ret = memcmp(digest, epayload->master_desc + epayload->datablob_len,
+		     sizeof digest);
+	if (ret) {
+		ret = -EINVAL;
+		dump_hmac("datablob",
+			  epayload->master_desc + epayload->datablob_len,
+			  HASH_SIZE);
+		dump_hmac("calc", digest, HASH_SIZE);
+	}
+out:
+	return ret;
+}
+
+static int derived_key_decrypt(struct encrypted_key_payload *epayload,
+			       const u8 *derived_key,
+			       unsigned int derived_keylen)
+{
+	struct scatterlist sg_in[1];
+	struct scatterlist sg_out[2];
+	struct blkcipher_desc desc;
+	unsigned int encrypted_datalen;
+	char pad[16];
+	int ret;
+
+	encrypted_datalen = roundup(epayload->decrypted_datalen, blksize);
+	ret = init_blkcipher_desc(&desc, derived_key, derived_keylen,
+				  epayload->iv, ivsize);
+	if (ret < 0)
+		goto out;
+	dump_encrypted_data(epayload, encrypted_datalen);
+
+	memset(pad, 0, sizeof pad);
+	sg_init_table(sg_in, 1);
+	sg_init_table(sg_out, 2);
+	sg_set_buf(sg_in, epayload->encrypted_data, encrypted_datalen);
+	sg_set_buf(&sg_out[0], epayload->decrypted_data,
+		   (unsigned int)epayload->decrypted_datalen);
+	sg_set_buf(&sg_out[1], pad, sizeof pad);
+
+	ret = crypto_blkcipher_decrypt(&desc, sg_out, sg_in, encrypted_datalen);
+	crypto_free_blkcipher(desc.tfm);
+	if (ret < 0)
+		goto out;
+	dump_decrypted_data(epayload);
+out:
+	return ret;
+}
+
+/* Allocate memory for decrypted key and datablob. */
+static struct encrypted_key_payload *encrypted_key_alloc(struct key *key,
+							 const char *master_desc,
+							 char *datalen)
+{
+	struct encrypted_key_payload *epayload = NULL;
+	unsigned short datablob_len;
+	unsigned short decrypted_datalen;
+	unsigned int encrypted_datalen;
+	long dlen;
+	int ret;
+
+	ret = strict_strtol(datalen, 10, &dlen);
+	if (ret < 0 || dlen < MIN_DATA_SIZE || dlen > MAX_DATA_SIZE)
+		return ERR_PTR(-EINVAL);
+
+	decrypted_datalen = (unsigned short)dlen;
+	encrypted_datalen = roundup(decrypted_datalen, blksize);
+
+	datablob_len = strlen(master_desc) + 1 + strlen(datalen) + 1
+	    + ivsize + 1 + encrypted_datalen;
+
+	ret = key_payload_reserve(key, decrypted_datalen + datablob_len
+				  + HASH_SIZE + 1);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	epayload = kzalloc(sizeof(*epayload) + decrypted_datalen +
+			   datablob_len + HASH_SIZE + 1, GFP_KERNEL);
+	if (!epayload)
+		return ERR_PTR(-ENOMEM);
+
+	epayload->decrypted_datalen = decrypted_datalen;
+	epayload->datablob_len = datablob_len;
+	return epayload;
+}
+
+static int encrypted_key_decrypt(struct encrypted_key_payload *epayload,
+				 const char *hex_encoded_iv,
+				 const char *hex_encoded_data)
+{
+	struct key *mkey;
+	u8 derived_key[HASH_SIZE];
+	u8 *master_key;
+	u8 *hmac;
+	unsigned int master_keylen;
+	unsigned int encrypted_datalen;
+	int ret;
+
+	encrypted_datalen = roundup(epayload->decrypted_datalen, blksize);
+	hex2bin(epayload->iv, hex_encoded_iv, ivsize);
+	hex2bin(epayload->encrypted_data, hex_encoded_data, encrypted_datalen);
+
+	hmac = epayload->master_desc + epayload->datablob_len;
+	hex2bin(hmac, hex_encoded_data + (encrypted_datalen * 2), HASH_SIZE);
+
+	mkey = request_master_key(epayload, &master_key, &master_keylen);
+	if (IS_ERR(mkey))
+		return PTR_ERR(mkey);
+
+	ret = datablob_hmac_verify(epayload, master_key, master_keylen);
+	if (ret < 0) {
+		pr_err("encrypted_key: bad hmac (%d)\n", ret);
+		goto out;
+	}
+
+	memset(derived_key, 0, sizeof derived_key);
+	ret = get_derived_key(derived_key, ENC_KEY, master_key, master_keylen);
+	if (ret < 0)
+		goto out;
+
+	ret = derived_key_decrypt(epayload, derived_key, sizeof derived_key);
+	if (ret < 0)
+		pr_err("encrypted_key: failed to decrypt key (%d)\n", ret);
+out:
+	rcu_read_unlock();
+	key_put(mkey);
+	return ret;
+}
+
+static void __ekey_init(struct encrypted_key_payload *epayload,
+			const char *master_desc, const char *datalen)
+{
+	epayload->master_desc = epayload->decrypted_data
+	    + epayload->decrypted_datalen;
+	epayload->datalen = epayload->master_desc + strlen(master_desc) + 1;
+	epayload->iv = epayload->datalen + strlen(datalen) + 1;
+	epayload->encrypted_data = epayload->iv + ivsize + 1;
+
+	memcpy(epayload->master_desc, master_desc, strlen(master_desc));
+	memcpy(epayload->datalen, datalen, strlen(datalen));
+}
+
+/*
+ * encrypted_init - initialize an encrypted key
+ *
+ * For a new key, use a random number for both the iv and data
+ * itself.  For an old key, decrypt the hex encoded data.
+ */
+static int encrypted_init(struct encrypted_key_payload *epayload,
+			  const char *master_desc, const char *datalen,
+			  const char *hex_encoded_iv,
+			  const char *hex_encoded_data)
+{
+	int ret = 0;
+
+	__ekey_init(epayload, master_desc, datalen);
+	if (!hex_encoded_data) {
+		get_random_bytes(epayload->iv, ivsize);
+
+		get_random_bytes(epayload->decrypted_data,
+				 epayload->decrypted_datalen);
+	} else
+		ret = encrypted_key_decrypt(epayload, hex_encoded_iv,
+					    hex_encoded_data);
+	return ret;
+}
+
+/*
+ * encrypted_instantiate - instantiate an encrypted key
+ *
+ * Decrypt an existing encrypted datablob or create a new encrypted key
+ * based on a kernel random number.
+ *
+ * On success, return 0. Otherwise return errno.
+ */
+static int encrypted_instantiate(struct key *key, const void *data,
+				 size_t datalen)
+{
+	struct encrypted_key_payload *epayload = NULL;
+	char *datablob = NULL;
+	char *master_desc = NULL;
+	char *decrypted_datalen = NULL;
+	char *hex_encoded_iv = NULL;
+	char *hex_encoded_data = NULL;
+	int ret;
+
+	if (datalen <= 0 || datalen > 32767 || !data)
+		return -EINVAL;
+
+	datablob = kmalloc(datalen + 1, GFP_KERNEL);
+	if (!datablob)
+		return -ENOMEM;
+	*(datablob + datalen) = 0;
+	memcpy(datablob, data, datalen);
+	ret = datablob_parse(datablob, &master_desc, &decrypted_datalen,
+			     &hex_encoded_iv, &hex_encoded_data);
+	if (ret < 0)
+		goto out;
+
+	epayload = encrypted_key_alloc(key, master_desc, decrypted_datalen);
+	if (IS_ERR(epayload)) {
+		ret = PTR_ERR(epayload);
+		goto out;
+	}
+	ret = encrypted_init(epayload, master_desc, decrypted_datalen,
+			     hex_encoded_iv, hex_encoded_data);
+	if (ret < 0) {
+		kfree(epayload);
+		goto out;
+	}
+
+	rcu_assign_pointer(key->payload.data, epayload);
+out:
+	kfree(datablob);
+	return ret;
+}
+
+static void encrypted_rcu_free(struct rcu_head *rcu)
+{
+	struct encrypted_key_payload *epayload;
+
+	epayload = container_of(rcu, struct encrypted_key_payload, rcu);
+	memset(epayload->decrypted_data, 0, epayload->decrypted_datalen);
+	kfree(epayload);
+}
+
+/*
+ * encrypted_update - update the master key description
+ *
+ * Change the master key description for an existing encrypted key.
+ * The next read will return an encrypted datablob using the new
+ * master key description.
+ *
+ * On success, return 0. Otherwise return errno.
+ */
+static int encrypted_update(struct key *key, const void *data, size_t datalen)
+{
+	struct encrypted_key_payload *epayload = key->payload.data;
+	struct encrypted_key_payload *new_epayload;
+	char *buf;
+	char *new_master_desc = NULL;
+	size_t index;
+	int ret = 0;
+
+	if (datalen <= 0 || datalen > 32767 || !data)
+		return -EINVAL;
+
+	buf = kmalloc(datalen + 1, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	*(buf + datalen) = 0;
+	memcpy(buf, data, datalen);
+	ret = datablob_parse(buf, &new_master_desc, NULL, NULL, NULL);
+	if (ret < 0)
+		goto out;
+
+	index = strcspn(epayload->master_desc, ":");
+	if (index == strlen(new_master_desc)
+	    || (strncmp(new_master_desc, epayload->master_desc, index) != 0)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	new_epayload = encrypted_key_alloc(key, new_master_desc,
+					   epayload->datalen);
+	if (IS_ERR(new_epayload)) {
+		ret = PTR_ERR(new_epayload);
+		goto out;
+	}
+
+	__ekey_init(new_epayload, new_master_desc, epayload->datalen);
+
+	memcpy(new_epayload->iv, epayload->iv, ivsize);
+	memcpy(new_epayload->decrypted_data, epayload->decrypted_data,
+	       epayload->decrypted_datalen);
+
+	rcu_assign_pointer(key->payload.data, new_epayload);
+	call_rcu(&epayload->rcu, encrypted_rcu_free);
+out:
+	kfree(buf);
+	return ret;
+}
+
+/*
+ * encrypted_read - format and copy the encrypted data to userspace
+ *
+ * The resulting datablob format is:
+ * <master-key name> <decrypted data length> <encrypted iv> <encrypted data>
+ *
+ * On success, return to userspace the encrypted key datablob size.
+ */
+static long encrypted_read(const struct key *key, char __user *buffer,
+			   size_t buflen)
+{
+	struct encrypted_key_payload *epayload;
+	struct key *mkey;
+	u8 *master_key;
+	unsigned int master_keylen;
+	char derived_key[HASH_SIZE];
+	int asciiblob_len;
+	int ret;
+
+	epayload = rcu_dereference_protected(key->payload.data,
+				  rwsem_is_locked(&((struct key *)key)->sem));
+
+	/* returns the hex encoded iv, encrypted-data, and hmac as ascii */
+	asciiblob_len = epayload->datablob_len + ivsize + 1
+	    + roundup(epayload->decrypted_datalen, blksize)
+	    + (HASH_SIZE * 2);
+
+	if (!buffer || buflen <= 0)
+		return asciiblob_len;
+
+	mkey = request_master_key(epayload, &master_key, &master_keylen);
+	if (IS_ERR(mkey))
+		return PTR_ERR(mkey);
+
+	memset(derived_key, 0, sizeof derived_key);
+	ret = get_derived_key(derived_key, ENC_KEY, master_key, master_keylen);
+	if (ret < 0)
+		goto out;
+
+	ret = derived_key_encrypt(epayload, derived_key, sizeof derived_key);
+	if (ret < 0)
+		goto out;
+
+	ret = datablob_hmac_append(epayload, master_key, master_keylen);
+	if (ret < 0)
+		goto out;
+
+	ret = datablob_format(buffer, epayload, asciiblob_len);
+	if (ret < 0)
+		goto out;
+
+	rcu_read_unlock();
+	key_put(mkey);
+	return asciiblob_len;
+out:
+	rcu_read_unlock();
+	key_put(mkey);
+	return ret;
+}
+
+/*
+ * encrypted_destroy - before freeing the key, clear the decrypted data
+ *
+ * Before freeing the key, clear the memory containing the descrypted
+ * key data.
+ */
+static void encrypted_destroy(struct key *key)
+{
+	struct encrypted_key_payload *epayload = key->payload.data;
+
+	if (!epayload)
+		return;
+
+	memset(epayload->decrypted_data, 0, epayload->decrypted_datalen);
+	kfree(key->payload.data);
+}
+
+struct key_type key_type_encrypted = {
+	.name = "encrypted",
+	.instantiate = encrypted_instantiate,
+	.update = encrypted_update,
+	.match = user_match,
+	.destroy = encrypted_destroy,
+	.describe = user_describe,
+	.read = encrypted_read,
+};
+EXPORT_SYMBOL_GPL(key_type_encrypted);
+
+static void encrypted_shash_release(void)
+{
+	if (hashalg)
+		crypto_free_shash(hashalg);
+	if (hmacalg)
+		crypto_free_shash(hmacalg);
+}
+
+static int __init encrypted_shash_alloc(void)
+{
+	int ret;
+
+	hmacalg = crypto_alloc_shash(hmac_alg, 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(hmacalg)) {
+		pr_info("encrypted_key: could not allocate crypto %s\n",
+			hmac_alg);
+		return PTR_ERR(hmacalg);
+	}
+
+	hashalg = crypto_alloc_shash(hash_alg, 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(hashalg)) {
+		pr_info("encrypted_key: could not allocate crypto %s\n",
+			hash_alg);
+		ret = PTR_ERR(hashalg);
+		goto hashalg_fail;
+	}
+
+	return 0;
+
+hashalg_fail:
+	crypto_free_shash(hmacalg);
+	return ret;
+}
+
+static int __init init_encrypted(void)
+{
+	int ret;
+
+	ret = encrypted_shash_alloc();
+	if (ret < 0)
+		return ret;
+	ret = register_key_type(&key_type_encrypted);
+	if (ret < 0)
+		goto out;
+	ret = aes_get_sizes();
+	return ret;
+out:
+	encrypted_shash_release();
+	return ret;
+
+}
+
+static void __exit cleanup_encrypted(void)
+{
+	encrypted_shash_release();
+	unregister_key_type(&key_type_encrypted);
+}
+
+late_initcall(init_encrypted);
+module_exit(cleanup_encrypted);
+
+MODULE_LICENSE("GPL");
diff --git a/security/keys/encrypted_defined.h b/security/keys/encrypted_defined.h
new file mode 100644
index 0000000..c298a3f
--- /dev/null
+++ b/security/keys/encrypted_defined.h
@@ -0,0 +1,56 @@
+#ifndef __ENCRYPTED_KEY_H
+#define __ENCRYPTED_KEY_H
+
+#define ENCRYPTED_DEBUG 0
+
+#if ENCRYPTED_DEBUG
+static inline void dump_master_key(const u8 *master_key,
+				   unsigned int master_keylen)
+{
+	print_hex_dump(KERN_ERR, "master key: ", DUMP_PREFIX_NONE, 32, 1,
+		       master_key, master_keylen, 0);
+}
+
+static inline void dump_decrypted_data(struct encrypted_key_payload *epayload)
+{
+	print_hex_dump(KERN_ERR, "decrypted data: ", DUMP_PREFIX_NONE, 32, 1,
+		       epayload->decrypted_data,
+		       epayload->decrypted_datalen, 0);
+}
+
+static inline void dump_encrypted_data(struct encrypted_key_payload *epayload,
+				       unsigned int encrypted_datalen)
+{
+	print_hex_dump(KERN_ERR, "encrypted data: ", DUMP_PREFIX_NONE, 32, 1,
+		       epayload->encrypted_data, encrypted_datalen, 0);
+}
+
+static inline void dump_hmac(const char *str, const u8 *digest,
+			     unsigned int hmac_size)
+{
+	if (str)
+		pr_info("encrypted_key: %s", str);
+	print_hex_dump(KERN_ERR, "hmac: ", DUMP_PREFIX_NONE, 32, 1, digest,
+		       hmac_size, 0);
+}
+#else
+static inline void dump_master_key(const u8 *master_key,
+				   unsigned int master_keylen)
+{
+}
+
+static inline void dump_decrypted_data(struct encrypted_key_payload *epayload)
+{
+}
+
+static inline void dump_encrypted_data(struct encrypted_key_payload *epayload,
+				       unsigned int encrypted_datalen)
+{
+}
+
+static inline void dump_hmac(const char *str, const u8 *digest,
+			     unsigned int hmac_size)
+{
+}
+#endif
+#endif
-- 
1.7.2.2

