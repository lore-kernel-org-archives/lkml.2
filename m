Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab0JKUME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 16:12:04 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36499 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756206Ab0JKUMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 16:12:01 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v1.1 3/4] keys: add new trusted key-type
Date: Mon, 11 Oct 2010 16:11:42 -0400
Message-Id: <1286827903-3066-4-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1286827903-3066-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1286827903-3066-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Defines a new kernel key-type called 'trusted'. Trusted keys are TPM
generated random numbers, RSA sealed by the TPM, and only unsealed by
the TPM, if boot PCRs and other criteria match. Trusted keys are
created/encrypted/decrypted in the kernel.  Userspace ever only
sees/stores encrypted blobs.

Changelog:
- Free payload on failure to create key(reported/fixed by Roberto Sassu)

Signed-off-by: David Safford <safford@watson.ibm.com>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 include/keys/trusted-type.h     |   33 ++
 security/Kconfig                |   15 +
 security/keys/Makefile          |    1 +
 security/keys/trusted_defined.c |  999 +++++++++++++++++++++++++++++++++++++++
 security/keys/trusted_defined.h |  125 +++++
 5 files changed, 1173 insertions(+), 0 deletions(-)
 create mode 100644 include/keys/trusted-type.h
 create mode 100644 security/keys/trusted_defined.c
 create mode 100644 security/keys/trusted_defined.h

diff --git a/include/keys/trusted-type.h b/include/keys/trusted-type.h
new file mode 100644
index 0000000..be7d44e
--- /dev/null
+++ b/include/keys/trusted-type.h
@@ -0,0 +1,33 @@
+/* trusted-type.h: trusted-defined key type
+ *
+ * Copyright (C) 2010 IBM Corporation
+ * Author: David Safford <safford@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ */
+
+#ifndef _KEYS_TRUSTED_TYPE_H
+#define _KEYS_TRUSTED_TYPE_H
+
+#include <linux/key.h>
+#include <linux/rcupdate.h>
+
+#define MAX_KEY_SIZE			128
+#define MAX_BLOB_SIZE			320
+#define MAX_PCRINFO_SIZE		64
+
+struct trusted_key_payload {
+	struct rcu_head rcu;	/* RCU destructor */
+	unsigned int key_len;
+	unsigned int blob_len;
+	unsigned int pcrinfo_len;
+	unsigned char key[MAX_KEY_SIZE];
+	unsigned char blob[MAX_BLOB_SIZE];
+	unsigned char pcrinfo[MAX_PCRINFO_SIZE];
+};
+
+extern struct key_type key_type_trusted;
+
+#endif /* _KEYS_TRUSTED_TYPE_H */
diff --git a/security/Kconfig b/security/Kconfig
index bd72ae6..38fdaf6 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -21,6 +21,21 @@ config KEYS
 
 	  If you are unsure as to whether this is required, answer N.
 
+config TRUSTED_KEYS
+	tristate "TRUSTED KEYS"
+	depends on KEYS && TCG_TPM
+	select CRYPTO
+	select CRYPTO_HMAC
+	select CRYPTO_SHA1
+	help
+	  This option provides support for creating/sealing/unsealing keys
+	  in the kernel. Trusted keys are TPM generated random numbers
+	  symmetric keys, RSA sealed by the TPM, and only unsealed by the
+	  TPM, if boot PCRs and other criteria match.  Userspace ever only
+	  sees/stores encrypted blobs.
+
+	  If you are unsure as to whether this is required, answer N.
+
 config KEYS_DEBUG_PROC_KEYS
 	bool "Enable the /proc/keys file by which keys may be viewed"
 	depends on KEYS
diff --git a/security/keys/Makefile b/security/keys/Makefile
index 74d5447..fcb1070 100644
--- a/security/keys/Makefile
+++ b/security/keys/Makefile
@@ -13,6 +13,7 @@ obj-y := \
 	request_key_auth.o \
 	user_defined.o
 
+obj-$(CONFIG_TRUSTED_KEYS) += trusted_defined.o
 obj-$(CONFIG_KEYS_COMPAT) += compat.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_SYSCTL) += sysctl.o
diff --git a/security/keys/trusted_defined.c b/security/keys/trusted_defined.c
new file mode 100644
index 0000000..0bd935f
--- /dev/null
+++ b/security/keys/trusted_defined.c
@@ -0,0 +1,999 @@
+/*
+ * Copyright (C) 2010 IBM Corporation
+ *
+ * Author:
+ * David Safford <safford@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ *
+ * File: trusted_defined.c
+ *
+ * Defines a new kernel key-type called 'trusted'. Trusted keys are
+ * TPM generated random numbers, RSA sealed by the TPM, and only unsealed
+ * by the TPM, if boot PCRs and other criteria match. Trusted keys are
+ * created/sealed/unsealed in the kernel. Userspace ever only sees/stores
+ * encrypted blobs.
+ *
+ * Keys are sealed under the SRK, which must have the default
+ * authorization value (20 zeros). This can be set at takeownership
+ * time with the trouser's utility "tpm_takeownership -u -z".
+ *
+ * Usage:
+ *   keyctl add trusted name "NEW keylen [hex_pcrinfo]" ring
+ *   keyctl add trusted name "LOAD hex_blob" ring
+ *   keyctl update key "UPDATE hex_pcrinfo"
+ *   keyctl print keyid
+ * keys can be 32 - 128 bytes, blob max is 1024 hex ascii characters
+ * binary pcrinfo max is 512 hex ascii characters
+ */
+
+#include <linux/uaccess.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/parser.h>
+#include <linux/string.h>
+#include <keys/user-type.h>
+#include <keys/trusted-type.h>
+#include <linux/key-type.h>
+#include <linux/random.h>
+#include <linux/rcupdate.h>
+#include <linux/scatterlist.h>
+#include <linux/crypto.h>
+#include <linux/tpm.h>
+
+#include "trusted_defined.h"
+
+static char hmac_alg[] = "hmac(sha1)";
+static char hash_alg[] = "sha1";
+
+static int init_sha1_desc(struct hash_desc *desc)
+{
+	int rc;
+
+	desc->tfm = crypto_alloc_hash(hash_alg, 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(desc->tfm)) {
+		rc = PTR_ERR(desc->tfm);
+		return rc;
+	}
+	desc->flags = 0;
+	rc = crypto_hash_init(desc);
+	if (rc)
+		crypto_free_hash(desc->tfm);
+	return rc;
+}
+
+static int init_hmac_desc(struct hash_desc *desc, unsigned char *key,
+			  int keylen)
+{
+	int rc;
+
+	desc->tfm = crypto_alloc_hash(hmac_alg, 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(desc->tfm)) {
+		rc = PTR_ERR(desc->tfm);
+		return rc;
+	}
+	desc->flags = 0;
+	crypto_hash_setkey(desc->tfm, key, keylen);
+	rc = crypto_hash_init(desc);
+	if (rc)
+		crypto_free_hash(desc->tfm);
+	return rc;
+}
+
+static int TSS_sha1(unsigned char *data, int datalen, unsigned char *digest)
+{
+	struct hash_desc desc;
+	struct scatterlist sg[1];
+	int rc;
+
+	rc = init_sha1_desc(&desc);
+	if (rc != 0)
+		return rc;
+
+	sg_init_one(sg, data, datalen);
+	crypto_hash_update(&desc, sg, datalen);
+	crypto_hash_final(&desc, digest);
+	crypto_free_hash(desc.tfm);
+	return rc;
+}
+
+static int TSS_rawhmac(unsigned char *digest, unsigned char *key,
+		       unsigned int keylen, ...)
+{
+	struct hash_desc desc;
+	struct scatterlist sg[1];
+	unsigned int dlen;
+	unsigned char *data;
+	va_list argp;
+	int error;
+
+	error = init_hmac_desc(&desc, key, keylen);
+	if (error)
+		return error;
+
+	va_start(argp, keylen);
+	for (;;) {
+		dlen = (unsigned int)va_arg(argp, unsigned int);
+		if (dlen == 0)
+			break;
+		data = (unsigned char *)va_arg(argp, unsigned char *);
+		if (data == NULL)
+			return -1;
+		sg_init_one(sg, data, dlen);
+		crypto_hash_update(&desc, sg, dlen);
+	}
+	crypto_hash_final(&desc, digest);
+	crypto_free_hash(desc.tfm);
+
+	va_end(argp);
+	return 0;
+}
+
+/*
+ * calculate authorization info fields to send to TPM
+ */
+static uint32_t TSS_authhmac(unsigned char *digest, unsigned char *key,
+			     unsigned int keylen, unsigned char *h1,
+			     unsigned char *h2, unsigned char h3, ...)
+{
+	unsigned char paramdigest[TPM_HASH_SIZE];
+	struct hash_desc desc;
+	struct scatterlist sg[1];
+	unsigned int dlen;
+	unsigned char *data;
+	unsigned char c;
+	int rc;
+
+	va_list argp;
+
+	rc = init_sha1_desc(&desc);
+	if (rc != 0)
+		return rc;
+	c = h3;
+	va_start(argp, h3);
+	for (;;) {
+		dlen = (unsigned int)va_arg(argp, unsigned int);
+		if (dlen == 0)
+			break;
+		data = (unsigned char *)va_arg(argp, unsigned char *);
+		sg_init_one(sg, data, dlen);
+		rc = crypto_hash_update(&desc, sg, dlen);
+	}
+	va_end(argp);
+	rc = crypto_hash_final(&desc, paramdigest);
+	crypto_free_hash(desc.tfm);
+	TSS_rawhmac(digest, key, keylen, TPM_HASH_SIZE, paramdigest,
+		    TPM_NONCE_SIZE, h1, TPM_NONCE_SIZE, h2, 1, &c, 0, 0);
+	return 0;
+}
+
+/*
+ * verify the AUTH1_COMMAND (Seal) result from TPM
+ */
+static uint32_t TSS_checkhmac1(unsigned char *buffer, uint32_t command,
+			       unsigned char *ononce, unsigned char *key,
+			       unsigned int keylen, ...)
+{
+	uint32_t bufsize;
+	uint16_t tag;
+	uint32_t ordinal;
+	uint32_t result;
+	unsigned char *enonce;
+	unsigned char *continueflag;
+	unsigned char *authdata;
+	unsigned char testhmac[TPM_HASH_SIZE];
+	unsigned char paramdigest[TPM_HASH_SIZE];
+	struct hash_desc desc;
+	struct scatterlist sg[1];
+	unsigned int dlen;
+	unsigned int dpos;
+	va_list argp;
+	int rc;
+
+	bufsize = LOAD32(buffer, TPM_SIZE_OFFSET);
+	tag = LOAD16(buffer, 0);
+	ordinal = command;
+	result = LOAD32N(buffer, TPM_RETURN_OFFSET);
+
+	if (tag == TPM_TAG_RSP_COMMAND)
+		return 0;
+	if (tag != TPM_TAG_RSP_AUTH1_COMMAND)
+		return -1;
+	authdata = buffer + bufsize - TPM_HASH_SIZE;
+	continueflag = authdata - 1;
+	enonce = continueflag - TPM_NONCE_SIZE;
+	rc = init_sha1_desc(&desc);
+	if (rc != 0)
+		return rc;
+	sg_init_one(sg, &result, TPM_U32_SIZE);
+	crypto_hash_update(&desc, sg, TPM_U32_SIZE);
+	sg_init_one(sg, &ordinal, TPM_U32_SIZE);
+	crypto_hash_update(&desc, sg, TPM_U32_SIZE);
+	va_start(argp, keylen);
+	for (;;) {
+		dlen = (unsigned int)va_arg(argp, unsigned int);
+		if (dlen == 0)
+			break;
+		dpos = (unsigned int)va_arg(argp, unsigned int);
+		sg_init_one(sg, buffer + dpos, dlen);
+		crypto_hash_update(&desc, sg, dlen);
+	}
+	va_end(argp);
+	crypto_hash_final(&desc, paramdigest);
+	crypto_free_hash(desc.tfm);
+
+	TSS_rawhmac(testhmac, key, keylen, TPM_HASH_SIZE, paramdigest,
+		    TPM_NONCE_SIZE, enonce,
+		    TPM_NONCE_SIZE, ononce, 1, continueflag, 0, 0);
+	if (memcmp(testhmac, authdata, TPM_HASH_SIZE) != 0)
+		return -1;
+	return 0;
+}
+
+/*
+ * verify the AUTH2_COMMAND (unseal) result from TPM
+ */
+static uint32_t TSS_checkhmac2(unsigned char *buffer, uint32_t command,
+			       unsigned char *ononce, unsigned char *key1,
+			       unsigned int keylen1, unsigned char *key2,
+			       unsigned int keylen2, ...)
+{
+	uint32_t bufsize;
+	uint16_t tag;
+	uint32_t ordinal;
+	uint32_t result;
+	unsigned char *enonce1;
+	unsigned char *continueflag1;
+	unsigned char *authdata1;
+	unsigned char *enonce2;
+	unsigned char *continueflag2;
+	unsigned char *authdata2;
+	unsigned char testhmac1[TPM_HASH_SIZE];
+	unsigned char testhmac2[TPM_HASH_SIZE];
+	unsigned char paramdigest[TPM_HASH_SIZE];
+	struct hash_desc desc;
+	struct scatterlist sg[1];
+	unsigned int dlen;
+	unsigned int dpos;
+	va_list argp;
+	int rc;
+
+	bufsize = LOAD32(buffer, TPM_SIZE_OFFSET);
+	tag = LOAD16(buffer, 0);
+	ordinal = command;
+	result = LOAD32N(buffer, TPM_RETURN_OFFSET);
+
+	if (tag == TPM_TAG_RSP_COMMAND)
+		return 0;
+	if (tag != TPM_TAG_RSP_AUTH2_COMMAND)
+		return -1;
+	authdata1 = buffer + bufsize - (TPM_HASH_SIZE + 1
+					+ TPM_HASH_SIZE + TPM_HASH_SIZE);
+	authdata2 = buffer + bufsize - (TPM_HASH_SIZE);
+	continueflag1 = authdata1 - 1;
+	continueflag2 = authdata2 - 1;
+	enonce1 = continueflag1 - TPM_NONCE_SIZE;
+	enonce2 = continueflag2 - TPM_NONCE_SIZE;
+
+	rc = init_sha1_desc(&desc);
+	if (rc != 0)
+		return rc;
+	sg_init_one(sg, &result, TPM_U32_SIZE);
+	crypto_hash_update(&desc, sg, TPM_U32_SIZE);
+	sg_init_one(sg, &ordinal, TPM_U32_SIZE);
+	crypto_hash_update(&desc, sg, TPM_U32_SIZE);
+
+	va_start(argp, keylen2);
+	for (;;) {
+		dlen = (unsigned int)va_arg(argp, unsigned int);
+		if (dlen == 0)
+			break;
+		dpos = (unsigned int)va_arg(argp, unsigned int);
+		sg_init_one(sg, buffer + dpos, dlen);
+		crypto_hash_update(&desc, sg, dlen);
+	}
+	crypto_hash_final(&desc, paramdigest);
+	crypto_free_hash(desc.tfm);
+
+	TSS_rawhmac(testhmac1, key1, keylen1, TPM_HASH_SIZE, paramdigest,
+		    TPM_NONCE_SIZE, enonce1,
+		    TPM_NONCE_SIZE, ononce, 1, continueflag1, 0, 0);
+	TSS_rawhmac(testhmac2, key2, keylen2, TPM_HASH_SIZE, paramdigest,
+		    TPM_NONCE_SIZE, enonce2,
+		    TPM_NONCE_SIZE, ononce, 1, continueflag2, 0, 0);
+	if (memcmp(testhmac1, authdata1, TPM_HASH_SIZE) != 0)
+		return -1;
+	if (memcmp(testhmac2, authdata2, TPM_HASH_SIZE) != 0)
+		return -1;
+	return 0;
+}
+
+static int trusted_tpm_send(u32 chip_num, unsigned char *cmd, int buflen)
+{
+	int rc;
+
+	dump_tpm_buf(cmd);
+	rc = tpm_send(chip_num, cmd, buflen);
+	dump_tpm_buf(cmd);
+	if (rc > 0)
+		/* Can't return positive return codes values to keyctl */
+		rc = -EPERM;
+	return rc;
+}
+
+static int tpm_reset(struct tpm_buf *tb)
+{
+	INIT_BUF(tb);
+	store16(tb, TPM_TAG_RQU_COMMAND);
+	store32(tb, TPM_RESET_SIZE);
+	store32(tb, TPM_ORD_RESET);
+	return trusted_tpm_send(TPM_ANY_NUM, tb->data, TPM_MAX_BUF_SIZE);
+}
+
+/*
+ * use the TPM random number generator for all new keys and nonces
+ */
+static int tpm_get_random(struct tpm_buf *tb, unsigned char *buf, uint32_t len)
+{
+	int ret = 0;
+
+	INIT_BUF(tb);
+	store16(tb, TPM_TAG_RQU_COMMAND);
+	store32(tb, TPM_GETRANDOM_SIZE);
+	store32(tb, TPM_ORD_GETRANDOM);
+	store32(tb, len);
+	ret = trusted_tpm_send(TPM_ANY_NUM, tb->data, TPM_MAX_BUF_SIZE);
+	memcpy(buf, tb->data + TPM_GETRANDOM_RETURN, len);
+	return ret;
+}
+
+/*
+ * Create an object specific authorisation protocol (OSAP) session
+ */
+static int srkosap(struct tpm_buf *tb, struct osapsess *s)
+{
+	unsigned char enonce[TPM_NONCE_SIZE];
+	unsigned char ononce[TPM_NONCE_SIZE];
+	unsigned char key[TPM_HASH_SIZE];
+	int ret;
+
+	ret = tpm_get_random(tb, ononce, TPM_NONCE_SIZE);
+	if (ret < 0)
+		return ret;
+
+	INIT_BUF(tb);
+	store16(tb, TPM_TAG_RQU_COMMAND);
+	store32(tb, TPM_OSAP_SIZE);
+	store32(tb, TPM_ORD_OSAP);
+	store16(tb, SRKKEYTYPE);
+	store32(tb, SRKHANDLE);
+	storebytes(tb, ononce, TPM_NONCE_SIZE);
+
+	ret = trusted_tpm_send(TPM_ANY_NUM, tb->data, TPM_MAX_BUF_SIZE);
+	if (ret < 0)
+		return ret;
+
+	memset(key, 0, TPM_HASH_SIZE);
+	s->handle = LOAD32(tb->data, TPM_DATA_OFFSET);
+	memcpy(s->enonce, &(tb->data[TPM_DATA_OFFSET + TPM_U32_SIZE]),
+	       TPM_NONCE_SIZE);
+	memcpy(enonce, &(tb->data[TPM_DATA_OFFSET + TPM_U32_SIZE +
+				  TPM_NONCE_SIZE]), TPM_NONCE_SIZE);
+	ret = TSS_rawhmac(s->secret, key, TPM_HASH_SIZE, TPM_NONCE_SIZE,
+			  enonce, TPM_NONCE_SIZE, ononce, 0, 0);
+	return ret;
+}
+
+/*
+ * Create an object independent authorisation protocol (oiap) session
+ */
+static int oiap(struct tpm_buf *tb, uint32_t * handle, unsigned char *nonce)
+{
+	int ret;
+
+	INIT_BUF(tb);
+	store16(tb, TPM_TAG_RQU_COMMAND);
+	store32(tb, TPM_OIAP_SIZE);
+	store32(tb, TPM_ORD_OIAP);
+	ret = trusted_tpm_send(TPM_ANY_NUM, tb->data, TPM_MAX_BUF_SIZE);
+	if (ret < 0)
+		return ret;
+
+	*handle = LOAD32(tb->data, TPM_DATA_OFFSET);
+	memcpy(nonce, &tb->data[TPM_DATA_OFFSET + TPM_U32_SIZE],
+	       TPM_NONCE_SIZE);
+	return ret;
+}
+
+/*
+ * Have the TPM seal(encrypt) the trusted key, possibly based on
+ * Platform Configuration Registers (PCRs).
+ */
+static int srkseal(struct tpm_buf *tb,
+		   unsigned char *data, int datalen,
+		   unsigned char *blob, unsigned int *bloblen,
+		   unsigned char *pcrinfo, uint32_t pcrinfosize)
+{
+	struct osapsess sess;
+	unsigned char encauth[TPM_HASH_SIZE];
+	unsigned char pubauth[TPM_HASH_SIZE];
+	unsigned char xorwork[TPM_HASH_SIZE * 2];
+	unsigned char xorhash[TPM_HASH_SIZE];
+	unsigned char dummyauth[TPM_HASH_SIZE];
+	unsigned char nonceodd[TPM_NONCE_SIZE];
+	unsigned char cont;
+	uint32_t ordinal;
+	uint32_t pcrsize;
+	uint32_t datsize;
+	int sealinfosize;
+	int encdatasize;
+	int storedsize;
+	int ret;
+	int i;
+
+	memset(dummyauth, 0, sizeof dummyauth);
+
+	ret = srkosap(tb, &sess);
+	if (ret < 0)
+		return ret;
+	dump_sess(&sess);
+
+	/* calculate encrypted authorization value */
+	memcpy(xorwork, sess.secret, TPM_HASH_SIZE);
+	memcpy(xorwork + TPM_HASH_SIZE, sess.enonce, TPM_HASH_SIZE);
+	ret = TSS_sha1(xorwork, TPM_HASH_SIZE * 2, xorhash);
+	if (ret != 0)
+		return ret;
+
+	ret = tpm_get_random(tb, nonceodd, TPM_NONCE_SIZE);
+	if (ret < 0)
+		return ret;
+	ordinal = htonl(TPM_ORD_SEAL);
+	datsize = htonl(datalen);
+	pcrsize = htonl(pcrinfosize);
+	cont = 0;
+
+	/* encrypt data authorization key */
+	for (i = 0; i < TPM_HASH_SIZE; ++i)
+		encauth[i] = xorhash[i] ^ dummyauth[i];
+
+	/* calculate authorization HMAC value */
+	if (pcrinfosize == 0) {
+		/* no pcr info specified */
+		TSS_authhmac(pubauth, sess.secret, TPM_HASH_SIZE,
+			     sess.enonce, nonceodd, cont, TPM_U32_SIZE,
+			     &ordinal, TPM_HASH_SIZE, encauth,
+			     TPM_U32_SIZE, &pcrsize, TPM_U32_SIZE,
+			     &datsize, datalen, data, 0, 0);
+	} else {
+		/* pcr info specified */
+		TSS_authhmac(pubauth, sess.secret, TPM_HASH_SIZE,
+			     sess.enonce, nonceodd, cont, TPM_U32_SIZE,
+			     &ordinal, TPM_HASH_SIZE, encauth,
+			     TPM_U32_SIZE, &pcrsize, pcrinfosize,
+			     pcrinfo, TPM_U32_SIZE, &datsize, datalen,
+			     data, 0, 0);
+	}
+
+	INIT_BUF(tb);
+	store16(tb, TPM_TAG_RQU_AUTH1_COMMAND);
+	store32(tb, TPM_SEAL_SIZE + pcrinfosize + datalen);
+	store32(tb, TPM_ORD_SEAL);
+	store32(tb, SRKHANDLE);
+	storebytes(tb, encauth, TPM_HASH_SIZE);
+	store32(tb, pcrinfosize);
+	storebytes(tb, pcrinfo, pcrinfosize);
+	store32(tb, datalen);
+	storebytes(tb, data, datalen);
+	store32(tb, sess.handle);
+	storebytes(tb, nonceodd, TPM_NONCE_SIZE);
+	store8(tb, cont);
+	storebytes(tb, pubauth, TPM_HASH_SIZE);
+
+	ret = trusted_tpm_send(TPM_ANY_NUM, tb->data, TPM_MAX_BUF_SIZE);
+	if (ret < 0)
+		return ret;
+
+	/* calculate the size of the returned Blob */
+	sealinfosize = LOAD32(tb->data, TPM_DATA_OFFSET + TPM_U32_SIZE);
+	encdatasize = LOAD32(tb->data, TPM_DATA_OFFSET + TPM_U32_SIZE +
+			     TPM_U32_SIZE + sealinfosize);
+	storedsize = TPM_U32_SIZE + TPM_U32_SIZE + sealinfosize +
+	    TPM_U32_SIZE + encdatasize;
+
+	/* check the HMAC in the response */
+	ret = TSS_checkhmac1(tb->data, ordinal, nonceodd, sess.secret,
+			     TPM_HASH_SIZE, storedsize, TPM_DATA_OFFSET, 0, 0);
+
+	/* copy the returned blob to caller */
+	memcpy(blob, tb->data + TPM_DATA_OFFSET, storedsize);
+	*bloblen = storedsize;
+	return ret;
+}
+
+/*
+ * use the AUTH2_COMMAND form of unseal, to authorize both SRK and blob
+ */
+static int srkunseal(struct tpm_buf *tb,
+		     unsigned char *blob, int bloblen,
+		     unsigned char *data, unsigned int *datalen)
+{
+	unsigned char nonceodd[TPM_NONCE_SIZE];
+	unsigned char dummyauth[TPM_NONCE_SIZE];
+	unsigned char enonce1[TPM_NONCE_SIZE];
+	unsigned char enonce2[TPM_NONCE_SIZE];
+	unsigned char authdata1[TPM_HASH_SIZE];
+	unsigned char authdata2[TPM_HASH_SIZE];
+	uint32_t authhandle1 = 0;
+	uint32_t authhandle2 = 0;
+	unsigned char cont = 0;
+	uint32_t ordinal;
+	uint32_t keyhndl;
+	int ret;
+
+	memset(dummyauth, 0, sizeof dummyauth);
+
+	ret = oiap(tb, &authhandle1, enonce1);
+	if (ret < 0) {
+		pr_info("trusted_key: oiap failed (%d)\n", ret);
+		return ret;
+	}
+	ret = oiap(tb, &authhandle2, enonce2);
+	if (ret < 0) {
+		pr_info("trusted_key: oiap failed (%d)\n", ret);
+		return ret;
+	}
+
+	/* network order for HMAC */
+	ordinal = htonl(TPM_ORD_UNSEAL);
+	keyhndl = htonl(SRKHANDLE);
+	ret = tpm_get_random(tb, nonceodd, TPM_NONCE_SIZE);
+	if (ret < 0) {
+		pr_info("trusted_key: tpm_get_random failed (%d)\n", ret);
+		return ret;
+	}
+
+	TSS_authhmac(authdata1, dummyauth, TPM_NONCE_SIZE,
+		     enonce1, nonceodd, cont, TPM_U32_SIZE,
+		     &ordinal, bloblen, blob, 0, 0);
+	TSS_authhmac(authdata2, dummyauth, TPM_NONCE_SIZE,
+		     enonce2, nonceodd, cont, TPM_U32_SIZE,
+		     &ordinal, bloblen, blob, 0, 0);
+
+	INIT_BUF(tb);
+	store16(tb, TPM_TAG_RQU_AUTH2_COMMAND);
+	store32(tb, TPM_UNSEAL_SIZE + bloblen);
+	store32(tb, TPM_ORD_UNSEAL);
+	store32(tb, SRKHANDLE);
+	storebytes(tb, blob, bloblen);
+	store32(tb, authhandle1);
+	storebytes(tb, nonceodd, TPM_NONCE_SIZE);
+	store8(tb, cont);
+	storebytes(tb, authdata1, TPM_HASH_SIZE);
+	store32(tb, authhandle2);
+	storebytes(tb, nonceodd, TPM_NONCE_SIZE);
+	store8(tb, cont);
+	storebytes(tb, authdata2, TPM_HASH_SIZE);
+
+	ret = trusted_tpm_send(TPM_ANY_NUM, tb->data, TPM_MAX_BUF_SIZE);
+	if (ret < 0) {
+		pr_info("trusted_key: authhmac failed (%d)\n", ret);
+		return ret;
+	}
+
+	*datalen = LOAD32(tb->data, TPM_DATA_OFFSET);
+	ret = TSS_checkhmac2(tb->data, ordinal, nonceodd,
+			     dummyauth, TPM_HASH_SIZE,
+			     dummyauth, TPM_HASH_SIZE,
+			     TPM_U32_SIZE, TPM_DATA_OFFSET,
+			     *datalen, TPM_DATA_OFFSET + TPM_U32_SIZE, 0, 0);
+	if (ret < 0)
+		pr_info("trusted_key: TSS_checkhmac2 failed (%d)\n", ret);
+	memcpy(data, tb->data + TPM_DATA_OFFSET + TPM_U32_SIZE, *datalen);
+	return ret;
+}
+
+/*
+ * Create a new trusted key based on a TPM random number
+ */
+static int key_create(struct trusted_key_payload *p)
+{
+	struct tpm_buf *tb;
+	int ret;
+
+	tb = kzalloc(sizeof *tb, GFP_KERNEL);
+	if (!tb)
+		return -ENOMEM;
+
+	ret = tpm_get_random(tb, p->key, p->key_len);
+	kfree(tb);
+	return ret;
+}
+
+/*
+ * Have the TPM seal(encrypt) the symmetric key
+ */
+static int key_seal(struct trusted_key_payload *p)
+{
+	struct tpm_buf *tb;
+	int ret;
+
+	tb = kzalloc(sizeof *tb, GFP_KERNEL);
+	if (!tb)
+		return -ENOMEM;
+
+	ret = tpm_reset(tb);
+	if (ret < 0) {
+		pr_info("trusted_key: tpm_reset failed (%d)\n", ret);
+		goto out;
+	}
+	ret = srkseal(tb, p->key, p->key_len, p->blob,
+		      &p->blob_len, p->pcrinfo, p->pcrinfo_len);
+	if (ret < 0) {
+		pr_info("trusted_key: srkseal failed (%d)\n", ret);
+		goto out;
+	}
+
+out:
+	kfree(tb);
+	return ret;
+}
+
+/*
+ * Have the TPM unseal(decrypt) the symmetric key
+ */
+static int key_unseal(struct trusted_key_payload *p)
+{
+	struct tpm_buf *tb;
+	int ret;
+
+	tb = kzalloc(sizeof *tb, GFP_KERNEL);
+	if (!tb)
+		return -ENOMEM;
+
+	ret = tpm_reset(tb);
+	if (ret < 0) {
+		pr_info("trusted_key: tpm_reset failed (%d)\n", ret);
+		goto out;
+	}
+	ret = srkunseal(tb, p->blob, p->blob_len, p->key, &p->key_len);
+	if (ret < 0)
+		pr_info("trusted_key: srkunseal failed (%d)\n", ret);
+out:
+	kfree(tb);
+	return ret;
+}
+
+enum {
+	Opt_err = -1,
+	Opt_new = 1, Opt_load, Opt_update,
+	Opt_NEW, Opt_LOAD, Opt_UPDATE
+};
+
+static match_table_t key_tokens = {
+	{Opt_new, "new"},
+	{Opt_NEW, "NEW"},
+	{Opt_load, "load"},
+	{Opt_LOAD, "LOAD"},
+	{Opt_update, "update"},
+	{Opt_UPDATE, "UPDATE"},
+	{Opt_err, NULL}
+};
+
+/*
+ * datablob_parse - parse the keyctl data
+ *
+ * datablob format:
+ *       "NEW keylen [hex_pcrinfo]"
+ *       "LOAD hex_blob"
+ *       "UPDATE hex_pcrinfo"
+ *
+ * Tokenizes a copy of the keyctl data, returning a pointer to each token,
+ * which is null terminated.
+ *
+ * On success returns 0, otherwise -EINVAL.
+ */
+static int datablob_parse(char *datablob, char **keylen, char **pcrinfo,
+			  char **hex_encoded_data)
+{
+	substring_t args[MAX_OPT_ARGS];
+	int ret = -EINVAL;
+	int key_cmd;
+	char *p;
+
+	p = strsep(&datablob, " \t");
+	if (!p)
+		return ret;
+	key_cmd = match_token(p, key_tokens, args);
+
+	/* All key commands require at least one argument */
+	p = strsep(&datablob, " \t");
+	if (!p)
+		return ret;
+
+	switch (key_cmd) {
+	case Opt_new:
+	case Opt_NEW:
+		*keylen = p;
+		ret = 0;
+		p = strsep(&datablob, " \t");
+		if (p)
+			*pcrinfo = p;
+		break;
+	case Opt_load:
+	case Opt_LOAD:
+		*hex_encoded_data = p;
+		ret = 0;
+		break;
+	case Opt_update:
+	case Opt_UPDATE:
+		*pcrinfo = p;
+		ret = 0;
+		break;
+	case Opt_err:
+		break;
+	}
+	return ret;
+}
+
+/*
+ * Allocate payload.
+ */
+static struct trusted_key_payload *trusted_key_alloc(struct key *key)
+{
+	struct trusted_key_payload *p = NULL;
+	int ret;
+
+	ret = key_payload_reserve(key, sizeof *p);
+	if (ret < 0)
+		return p;
+	p = kzalloc(sizeof *p, GFP_KERNEL);
+	return p;
+}
+
+/*
+ * safety check user inputs and fill in payload
+ */
+static int trusted_key_fill(struct trusted_key_payload *p, char *asc_keylen,
+			    char *hex_pcrinfo, char *hex_blob)
+{
+	long key_len;
+	int ret;
+
+	if (hex_blob) {
+		p->blob_len = strlen(hex_blob) / 2;
+		if (p->blob_len > MAX_BLOB_SIZE)
+			return -EINVAL;
+		hex2bin(p->blob, hex_blob, p->blob_len);
+	}
+	if (asc_keylen) {
+		ret = strict_strtol(asc_keylen, 10, &key_len);
+		if ((ret < 0) || (key_len < MIN_KEY_SIZE) ||
+		    (key_len > MAX_KEY_SIZE))
+			return -EINVAL;
+		p->key_len = key_len;
+	}
+	if (hex_pcrinfo) {
+		p->pcrinfo_len = strlen(hex_pcrinfo) / 2;
+		if (p->pcrinfo_len > MAX_PCRINFO_SIZE)
+			return -EINVAL;
+		hex2bin(p->pcrinfo, hex_pcrinfo, p->pcrinfo_len);
+	}
+	return 0;
+}
+
+/*
+ * trusted_instantiate - create a new trusted key
+ *
+ * Unseal an existing trusted blob or, for a new key, get a
+ * random key, then seal and create an encryted key-type key,
+ * adding it to the specified keyring.
+ *
+ * On success, return 0. Otherwise return errno.
+ */
+static int trusted_instantiate(struct key *key, const void *data,
+			       size_t datalen)
+{
+	struct trusted_key_payload *p = NULL;
+	char *hex_blob = NULL;
+	char *asc_keylen = NULL;
+	char *datablob;
+	char *hex_pcrinfo = NULL;
+	int ret;
+
+	if (datalen <= 0 || datalen > 32767 || !data)
+		return -EINVAL;
+
+	datablob = kzalloc(datalen + 1, GFP_KERNEL);
+	if (!datablob)
+		return -ENOMEM;
+	memcpy(datablob, data, datalen);
+
+	ret = datablob_parse(datablob, &asc_keylen, &hex_pcrinfo, &hex_blob);
+	if (ret < 0)
+		goto out;
+	p = trusted_key_alloc(key);
+	if (!p) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	ret = trusted_key_fill(p, asc_keylen, hex_pcrinfo, hex_blob);
+	if (ret < 0)
+		goto out;
+
+	dump_payload(p);
+
+	if (hex_blob) {
+		ret = key_unseal(p);
+		if (ret < 0)
+			pr_info("trusted_key: key_unseal failed (%d)\n", ret);
+		goto out;
+	}
+
+	if (asc_keylen) {
+		ret = key_create(p);
+		if (ret < 0) {
+			pr_info("trusted_key: key_create failed (%d)\n", ret);
+			goto out;
+		}
+	}
+
+	ret = key_seal(p);
+	if (ret < 0)
+		pr_info("trusted_key: key_seal failed (%d)\n", ret);
+out:
+	if (!ret)
+		rcu_assign_pointer(key->payload.data, p);
+	else if (p)
+		kfree(p);
+	kfree(datablob);
+	return ret;
+}
+
+static void trusted_rcu_free(struct rcu_head *rcu)
+{
+	struct trusted_key_payload *p;
+
+	p = container_of(rcu, struct trusted_key_payload, rcu);
+	memset(p->key, 0, p->key_len);
+	kfree(p);
+}
+
+/*
+ * trusted_update - reseal an existing key with new PCR values
+ */
+static int trusted_update(struct key *key, const void *data, size_t datalen)
+{
+	struct trusted_key_payload *p = key->payload.data;
+	struct trusted_key_payload *new_p;
+	char *hex_blob = NULL;
+	char *asc_keylen = NULL;
+	char *datablob;
+	char *hex_pcrinfo = NULL;
+	int ret = 0;
+
+	if (datalen <= 0 || datalen > 32767 || !data)
+		return -EINVAL;
+
+	datablob = kzalloc(datalen + 1, GFP_KERNEL);
+	if (!datablob)
+		return -ENOMEM;
+	memcpy(datablob, data, datalen);
+	ret = datablob_parse(datablob, &asc_keylen, &hex_pcrinfo, &hex_blob);
+	if (ret < 0)
+		goto out;
+
+	new_p = trusted_key_alloc(key);
+	if (!new_p) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	ret = trusted_key_fill(new_p, asc_keylen, hex_pcrinfo, hex_blob);
+	if (ret < 0) {
+		pr_info("trusted_key: key_fill failed (%d)\n", ret);
+		kfree(new_p);
+		goto out;
+	}
+
+	/* copy old key values, and reseal with new pcrs */
+	new_p->key_len = p->key_len;
+	memcpy(new_p->key, p->key, p->key_len);
+	dump_payload(p);
+	dump_payload(new_p);
+
+	ret = key_seal(new_p);
+	if (ret < 0) {
+		pr_info("trusted_key: key_seal failed (%d)\n", ret);
+		kfree(new_p);
+		goto out;
+	}
+	rcu_assign_pointer(key->payload.data, new_p);
+	call_rcu(&p->rcu, trusted_rcu_free);
+out:
+	kfree(datablob);
+	return ret;
+}
+
+/*
+ * trusted_read - copy the sealed blob data to userspace in hex.
+ * On success, return to userspace the trusted key datablob size.
+ */
+static long trusted_read(const struct key *key, char __user * buffer,
+			 size_t buflen)
+{
+	struct trusted_key_payload *p;
+	char *ascii_buf;
+	char *bufp;
+	int i;
+
+	p = rcu_dereference_protected(key->payload.data,
+				      rwsem_is_locked(&((struct key *)key)->sem));
+	if (!p)
+		return -EINVAL;
+
+	if (!buffer || buflen <= 0)
+		return 2 * p->blob_len;
+
+	ascii_buf = kzalloc(2 * p->blob_len, GFP_KERNEL);
+	if (!ascii_buf)
+		return -ENOMEM;
+
+	bufp = ascii_buf;
+	for (i = 0; i < p->blob_len; i++)
+		bufp = pack_hex_byte(bufp, p->blob[i]);
+
+	if ((copy_to_user(buffer, ascii_buf, 2 * p->blob_len)) != 0) {
+		kfree(ascii_buf);
+		return -EFAULT;
+	}
+	kfree(ascii_buf);
+	return 2 * p->blob_len;
+}
+
+/*
+ * trusted_destroy - before freeing the key, clear the decrypted data
+ */
+static void trusted_destroy(struct key *key)
+{
+	struct trusted_key_payload *p = key->payload.data;
+
+	if (!p)
+		return;
+	memset(p->key, 0, p->key_len);
+	kfree(key->payload.data);
+}
+
+struct key_type key_type_trusted = {
+	.name = "trusted",
+	.instantiate = trusted_instantiate,
+	.update = trusted_update,
+	.match = user_match,
+	.destroy = trusted_destroy,
+	.describe = user_describe,
+	.read = trusted_read,
+};
+EXPORT_SYMBOL_GPL(key_type_trusted);
+
+static int __init init_trusted(void)
+{
+	int ret;
+
+	ret = register_key_type(&key_type_trusted);
+	if (ret < 0)
+		return ret;
+	return ret;
+}
+
+static void __exit cleanup_trusted(void)
+{
+	unregister_key_type(&key_type_trusted);
+}
+
+module_init(init_trusted);
+module_exit(cleanup_trusted);
+
+MODULE_LICENSE("GPL");
diff --git a/security/keys/trusted_defined.h b/security/keys/trusted_defined.h
new file mode 100644
index 0000000..e2d0c11
--- /dev/null
+++ b/security/keys/trusted_defined.h
@@ -0,0 +1,125 @@
+#ifndef __TRUSTED_KEY_H
+#define __TRUSTED_KEY_H
+
+#define TPM_MAX_BUF_SIZE		512
+#define TPM_TAG_RQU_COMMAND		193
+#define TPM_TAG_RQU_AUTH1_COMMAND	194
+#define TPM_TAG_RQU_AUTH2_COMMAND	195
+#define TPM_TAG_RSP_COMMAND		196
+#define TPM_TAG_RSP_AUTH1_COMMAND	197
+#define TPM_TAG_RSP_AUTH2_COMMAND	198
+#define TPM_NONCE_SIZE			20
+#define TPM_HASH_SIZE			20
+#define TPM_SIZE_OFFSET			2
+#define TPM_RETURN_OFFSET		6
+#define TPM_DATA_OFFSET			10
+#define TPM_U32_SIZE			4
+#define TPM_GETRANDOM_SIZE		14
+#define TPM_GETRANDOM_RETURN		14
+#define TPM_ORD_GETRANDOM		70
+#define TPM_RESET_SIZE			10
+#define TPM_ORD_RESET			90
+#define TPM_OSAP_SIZE			36
+#define TPM_ORD_OSAP			11
+#define TPM_OIAP_SIZE			10
+#define TPM_ORD_OIAP			10
+#define TPM_SEAL_SIZE			87
+#define TPM_ORD_SEAL			23
+#define TPM_ORD_UNSEAL			24
+#define TPM_UNSEAL_SIZE			104
+#define SRKKEYTYPE			4
+#define SRKHANDLE			0x40000000
+#define TPM_ANY_NUM			0xFFFF
+
+#define MIN_KEY_SIZE			32
+
+#define LOAD32(buffer, offset)	(ntohl(*(uint32_t *)&buffer[offset]))
+#define LOAD32N(buffer, offset)	(*(uint32_t *)&buffer[offset])
+#define LOAD16(buffer, offset)	(ntohs(*(uint16_t *)&buffer[offset]))
+
+struct tpm_buf {
+	int len;
+	unsigned char data[TPM_MAX_BUF_SIZE];
+};
+
+#define INIT_BUF(tb) (tb->len = 0)
+
+struct osapsess {
+	uint32_t handle;
+	unsigned char secret[TPM_HASH_SIZE];
+	unsigned char enonce[TPM_NONCE_SIZE];
+};
+
+#define TPM_DEBUG 0
+
+#if TPM_DEBUG
+static inline void dump_payload(struct trusted_key_payload *p)
+{
+	pr_info("trusted_key: key_len %d\n", p->key_len);
+	print_hex_dump(KERN_INFO, "key ", DUMP_PREFIX_NONE,
+		       16, 1, p->key, p->key_len, 0);
+	pr_info("trusted_key: pcrinfo %d\n", p->pcrinfo_len);
+	print_hex_dump(KERN_INFO, "pcrinfo ", DUMP_PREFIX_NONE,
+		       16, 1, p->pcrinfo, p->pcrinfo_len, 0);
+	pr_info("trusted_key: bloblen %d\n", p->blob_len);
+	print_hex_dump(KERN_INFO, "blob ", DUMP_PREFIX_NONE,
+		       16, 1, p->blob, p->blob_len, 0);
+}
+
+static inline void dump_sess(struct osapsess *s)
+{
+	print_hex_dump(KERN_INFO, "trusted-key: handle", DUMP_PREFIX_NONE,
+		       16, 1, &s->handle, 4, 0);
+	pr_info("trusted-key: secret:\n");
+	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE,
+		       16, 1, &s->secret, TPM_HASH_SIZE, 0);
+	pr_info("trusted-key: enonce:\n");
+	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE,
+		       16, 1, &s->enonce, TPM_HASH_SIZE, 0);
+}
+
+static inline void dump_tpm_buf(unsigned char *buf)
+{
+	int len;
+
+	pr_info("\ntrusted-key: tpm buffer\n");
+	len = LOAD32(buf, TPM_SIZE_OFFSET);
+	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE, 16, 1, buf, len, 0);
+}
+#else
+static inline void dump_payload(struct trusted_key_payload *p)
+{
+}
+
+static inline void dump_sess(struct osapsess *s)
+{
+}
+
+static inline void dump_tpm_buf(unsigned char *buf)
+{
+}
+#endif
+
+static inline void store8(struct tpm_buf *buf, unsigned char value)
+{
+	buf->data[buf->len++] = value;
+}
+
+static inline void store16(struct tpm_buf *buf, uint16_t value)
+{
+	*(uint16_t *) & buf->data[buf->len] = htons(value);
+	buf->len += sizeof(value);
+}
+
+static inline void store32(struct tpm_buf *buf, uint32_t value)
+{
+	*(uint32_t *) & buf->data[buf->len] = htonl(value);
+	buf->len += sizeof(value);
+}
+
+static inline void storebytes(struct tpm_buf *buf, unsigned char *in, int len)
+{
+	memcpy(buf->data + buf->len, in, len);
+	buf->len += len;
+}
+#endif
-- 
1.7.2.2

