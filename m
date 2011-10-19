Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab1JSLuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 07:50:00 -0400
Received: from mga12.intel.com ([143.182.124.36]:30868 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755914Ab1JSLtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 07:49:22 -0400
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: linux-security-module@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.vnet.ibm.com, dhowells@redhat.com,
        herbert@gondor.hengli.com.au
Subject: [PATCH v2.2 5/7] crypto: digital signature verification support
Date: Wed, 19 Oct 2011 14:51:34 +0300
Message-Id: <a2d82de2f2e89a94ff00db5f2f362227a10cc6cc.1319025009.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1319025009.git.dmitry.kasatkin@intel.com>
References: <cover.1319025009.git.dmitry.kasatkin@intel.com>
In-Reply-To: <cover.1319025009.git.dmitry.kasatkin@intel.com>
References: <cover.1319025009.git.dmitry.kasatkin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements RSA digital signature verification using GnuPG library.

The format of the signature and the public key is defined by their respective
headers. The signature header contains version information, algorithm,
and keyid, which was used to generate the signature.
The key header contains version and algorythim type.
The payload of the signature and the key are multi-precision integers.

The signing and key management utilities evm-utils provide functionality
to generate signatures and load keys into the kernel keyring.
When the key is added to the kernel keyring, the keyid defines the name
of the key.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Acked-by: Mimi Zohar <zohar@us.ibm.com>
---
 Documentation/digsig.txt |   97 ++++++++++++++++
 include/linux/digsig.h   |   64 +++++++++++
 lib/Kconfig              |    8 ++
 lib/Makefile             |    1 +
 lib/digsig.c             |  283 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 453 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/digsig.txt
 create mode 100644 include/linux/digsig.h
 create mode 100644 lib/digsig.c

diff --git a/Documentation/digsig.txt b/Documentation/digsig.txt
new file mode 100644
index 0000000..17dd866
--- /dev/null
+++ b/Documentation/digsig.txt
@@ -0,0 +1,97 @@
+Digital Signature Verification API
+
+CONTENTS
+
+1. Introduction
+2. API
+3. User-space utilities
+
+
+1. Introduction
+
+Digital signature verification API provides a method to verify digital signature.
+Currently digital signatures are used by the IMA/EVM integrity protection subsystem.
+
+Digital signature verification is implemented using cut-down kernel port of
+GnuPG multi-precision integers (MPI) library. The kernel port provides
+memory allocation errors handling, has been refactored according to kernel
+coding style, and checkpatch.pl reported errors and warnings have been fixed.
+
+Public key and signature consist of header and MPIs.
+
+struct pubkey_hdr {
+	uint8_t		version;	/* key format version */
+	time_t		timestamp;	/* key made, always 0 for now */
+	uint8_t		algo;
+	uint8_t		nmpi;
+	char		mpi[0];
+} __packed;
+
+struct signature_hdr {
+	uint8_t		version;	/* signature format version */
+	time_t		timestamp;	/* signature made */
+	uint8_t		algo;
+	uint8_t		hash;
+	uint8_t		keyid[8];
+	uint8_t		nmpi;
+	char		mpi[0];
+} __packed;
+
+keyid equals to SHA1[12-19] over the total key content.
+Signature header is used as an input to generate a signature.
+Such approach insures that key or signature header could not be changed.
+It protects timestamp from been changed and can be used for rollback
+protection.
+
+2. API
+
+API currently includes only 1 function:
+
+	digsig_verify() - digital signature verification with public key
+	
+
+/**
+ * digsig_verify() - digital signature verification with public key
+ * @keyring:	keyring to search key in
+ * @sig:	digital signature
+ * @sigen:	length of the signature
+ * @data:	data
+ * @datalen:	length of the data
+ * @return:	0 on success, -EINVAL otherwise
+ *
+ * Verifies data integrity against digital signature.
+ * Currently only RSA is supported.
+ * Normally hash of the content is used as a data for this function.
+ *
+ */
+int digsig_verify(struct key *keyring, const char *sig, int siglen,
+						const char *data, int datalen);
+
+3. User-space utilities
+
+The signing and key management utilities evm-utils provide functionality
+to generate signatures, to load keys into the kernel keyring.
+Keys can be in PEM or converted to the kernel format.
+When the key is added to the kernel keyring, the keyid defines the name
+of the key: 5D2B05FC633EE3E8 in the example bellow.
+
+Here is example output of the keyctl utility.
+
+$ keyctl show
+Session Keyring
+       -3 --alswrv      0     0  keyring: _ses
+603976250 --alswrv      0    -1   \_ keyring: _uid.0
+817777377 --alswrv      0     0       \_ user: kmk
+891974900 --alswrv      0     0       \_ encrypted: evm-key
+170323636 --alswrv      0     0       \_ keyring: _module
+548221616 --alswrv      0     0       \_ keyring: _ima
+128198054 --alswrv      0     0       \_ keyring: _evm
+
+$ keyctl list 128198054
+1 key in keyring:
+620789745: --alswrv     0     0 user: 5D2B05FC633EE3E8
+
+
+Dmitry Kasatkin
+06.10.2011
+
diff --git a/include/linux/digsig.h b/include/linux/digsig.h
new file mode 100644
index 0000000..efae755
--- /dev/null
+++ b/include/linux/digsig.h
@@ -0,0 +1,64 @@
+/*
+ * Copyright (C) 2011 Nokia Corporation
+ * Copyright (C) 2011 Intel Corporation
+ *
+ * Author:
+ * Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
+ *                 <dmitry.kasatkin@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ *
+ */
+
+#ifndef _DIGSIG_H
+#define _DIGSIG_H
+
+#include <linux/key.h>
+
+enum pubkey_algo {
+	PUBKEY_ALGO_RSA,
+	PUBKEY_ALGO_MAX,
+};
+
+enum digest_algo {
+	DIGEST_ALGO_SHA1,
+	DIGEST_ALGO_SHA256,
+	DIGEST_ALGO_MAX
+};
+
+struct pubkey_hdr {
+	uint8_t		version;	/* key format version */
+	time_t		timestamp;	/* key made, always 0 for now */
+	uint8_t		algo;
+	uint8_t		nmpi;
+	char		mpi[0];
+} __packed;
+
+struct signature_hdr {
+	uint8_t		version;	/* signature format version */
+	time_t		timestamp;	/* signature made */
+	uint8_t		algo;
+	uint8_t		hash;
+	uint8_t		keyid[8];
+	uint8_t		nmpi;
+	char		mpi[0];
+} __packed;
+
+#if defined(CONFIG_DIGSIG) || defined(CONFIG_DIGSIG_MODULE)
+
+int digsig_verify(struct key *keyring, const char *sig, int siglen,
+					const char *digest, int digestlen);
+
+#else
+
+static inline int digsig_verify(struct key *keyring, const char *sig,
+				int siglen, const char *digest, int digestlen)
+{
+	return -EOPNOTSUPP;
+}
+
+#endif /* CONFIG_DIGSIG */
+
+#endif /* _DIGSIG_H */
diff --git a/lib/Kconfig b/lib/Kconfig
index b5dd7ef..3ff216c 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -296,4 +296,12 @@ config MPILIB_EXTRA
 	  This code in unnecessary for RSA digital signature verification,
 	  and can be compiled if needed.	  
 
+config DIGSIG
+	tristate "In-kernel signature checker"
+	depends on CRYPTO
+	select MPILIB
+	help
+	  Digital signature verification. Currently only RSA is supported.
+	  Implementation is done using GnuPG MPI library
+
 endmenu
diff --git a/lib/Makefile b/lib/Makefile
index 97705ae..52a6b28 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -118,6 +118,7 @@ obj-$(CONFIG_CORDIC) += cordic.o
 obj-$(CONFIG_LLIST) += llist.o
 
 obj-$(CONFIG_MPILIB) += mpi/
+obj-$(CONFIG_DIGSIG) += digsig.o
 
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
diff --git a/lib/digsig.c b/lib/digsig.c
new file mode 100644
index 0000000..dde7552
--- /dev/null
+++ b/lib/digsig.c
@@ -0,0 +1,283 @@
+/*
+ * Copyright (C) 2011 Nokia Corporation
+ * Copyright (C) 2011 Intel Corporation
+ *
+ * Author:
+ * Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
+ *                 <dmitry.kasatkin@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ *
+ * File: sign.c
+ *	implements signature (RSA) verification
+ *	pkcs decoding is based on LibTomCrypt code
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/key.h>
+#include <linux/crypto.h>
+#include <crypto/hash.h>
+#include <crypto/sha.h>
+#include <keys/user-type.h>
+#include <linux/mpi.h>
+#include <linux/digsig.h>
+
+static struct crypto_shash *shash;
+
+static int pkcs_1_v1_5_decode_emsa(const unsigned char *msg,
+			unsigned long  msglen,
+			unsigned long  modulus_bitlen,
+			unsigned char *out,
+			unsigned long *outlen,
+			int *is_valid)
+{
+	unsigned long modulus_len, ps_len, i;
+	int result;
+
+	/* default to invalid packet */
+	*is_valid = 0;
+
+	modulus_len = (modulus_bitlen >> 3) + (modulus_bitlen & 7 ? 1 : 0);
+
+	/* test message size */
+	if ((msglen > modulus_len) || (modulus_len < 11))
+		return -EINVAL;
+
+	/* separate encoded message */
+	if ((msg[0] != 0x00) || (msg[1] != (unsigned char)1)) {
+		result = -EINVAL;
+		goto bail;
+	}
+
+	for (i = 2; i < modulus_len - 1; i++)
+		if (msg[i] != 0xFF)
+			break;
+
+	/* separator check */
+	if (msg[i] != 0) {
+		/* There was no octet with hexadecimal value 0x00
+		to separate ps from m. */
+		result = -EINVAL;
+		goto bail;
+	}
+
+	ps_len = i - 2;
+
+	if (*outlen < (msglen - (2 + ps_len + 1))) {
+		*outlen = msglen - (2 + ps_len + 1);
+		result = -EOVERFLOW;
+		goto bail;
+	}
+
+	*outlen = (msglen - (2 + ps_len + 1));
+	memcpy(out, &msg[2 + ps_len + 1], *outlen);
+
+	/* valid packet */
+	*is_valid = 1;
+	result    = 0;
+bail:
+	return result;
+}
+
+/*
+ * RSA Signature verification with public key
+ */
+static int digsig_verify_rsa(struct key *key,
+		    const char *sig, int siglen,
+		       const char *h, int hlen)
+{
+	int err = -EINVAL;
+	unsigned long len;
+	unsigned long mlen, mblen;
+	unsigned nret, l;
+	int valid, head, i;
+	unsigned char *out1 = NULL, *out2 = NULL;
+	MPI in = NULL, res = NULL, pkey[2];
+	uint8_t *p, *datap, *endp;
+	struct user_key_payload *ukp;
+	struct pubkey_hdr *pkh;
+
+	down_read(&key->sem);
+	ukp = key->payload.data;
+	pkh = (struct pubkey_hdr *)ukp->data;
+
+	if (pkh->version != 1)
+		goto err1;
+
+	if (pkh->algo != PUBKEY_ALGO_RSA)
+		goto err1;
+
+	if (pkh->nmpi != 2)
+		goto err1;
+
+	datap = pkh->mpi;
+	endp = datap + ukp->datalen;
+
+	for (i = 0; i < pkh->nmpi; i++) {
+		unsigned int remaining = endp - datap;
+		pkey[i] = mpi_read_from_buffer(datap, &remaining);
+		datap += remaining;
+	}
+
+	mblen = mpi_get_nbits(pkey[0]);
+	mlen = (mblen + 7)/8;
+
+	err = -ENOMEM;
+
+	out1 = kzalloc(mlen, GFP_KERNEL);
+	if (!out1)
+		goto err;
+
+	out2 = kzalloc(mlen, GFP_KERNEL);
+	if (!out2)
+		goto err;
+
+	nret = siglen;
+	in = mpi_read_from_buffer(sig, &nret);
+	if (!in)
+		goto err;
+
+	res = mpi_alloc(mpi_get_nlimbs(in) * 2);
+	if (!res)
+		goto err;
+
+	err = mpi_powm(res, in, pkey[1], pkey[0]);
+	if (err)
+		goto err;
+
+	if (mpi_get_nlimbs(res) * BYTES_PER_MPI_LIMB > mlen) {
+		err = -EINVAL;
+		goto err;
+	}
+
+	p = mpi_get_buffer(res, &l, NULL);
+	if (!p) {
+		err = -EINVAL;
+		goto err;
+	}
+
+	len = mlen;
+	head = len - l;
+	memset(out1, 0, head);
+	memcpy(out1 + head, p, l);
+
+	err = -EINVAL;
+	pkcs_1_v1_5_decode_emsa(out1, len, mblen, out2, &len, &valid);
+
+	if (valid && len == hlen)
+		err = memcmp(out2, h, hlen);
+
+err:
+	mpi_free(in);
+	mpi_free(res);
+	kfree(out1);
+	kfree(out2);
+	mpi_free(pkey[0]);
+	mpi_free(pkey[1]);
+err1:
+	up_read(&key->sem);
+
+	return err;
+}
+
+/**
+ * digsig_verify() - digital signature verification with public key
+ * @keyring:	keyring to search key in
+ * @sig:	digital signature
+ * @sigen:	length of the signature
+ * @data:	data
+ * @datalen:	length of the data
+ * @return:	0 on success, -EINVAL otherwise
+ *
+ * Verifies data integrity against digital signature.
+ * Currently only RSA is supported.
+ * Normally hash of the content is used as a data for this function.
+ *
+ */
+int digsig_verify(struct key *keyring, const char *sig, int siglen,
+						const char *data, int datalen)
+{
+	int err = -ENOMEM;
+	struct signature_hdr *sh = (struct signature_hdr *)sig;
+	struct shash_desc *desc = NULL;
+	unsigned char hash[SHA1_DIGEST_SIZE];
+	struct key *key;
+	char name[20];
+
+	if (siglen < sizeof(*sh) + 2)
+		return -EINVAL;
+
+	if (sh->algo != PUBKEY_ALGO_RSA)
+		return -ENOTSUPP;
+
+	sprintf(name, "%llX", __be64_to_cpup((uint64_t *)sh->keyid));
+
+	if (keyring) {
+		/* search in specific keyring */
+		key_ref_t kref;
+		kref = keyring_search(make_key_ref(keyring, 1UL),
+						&key_type_user, name);
+		if (IS_ERR(kref))
+			key = ERR_PTR(PTR_ERR(kref));
+		else
+			key = key_ref_to_ptr(kref);
+	} else {
+		key = request_key(&key_type_user, name, NULL);
+	}
+	if (IS_ERR(key)) {
+		pr_err("key not found, id: %s\n", name);
+		return PTR_ERR(key);
+	}
+
+	desc = kzalloc(sizeof(*desc) + crypto_shash_descsize(shash),
+		       GFP_KERNEL);
+	if (!desc)
+		goto err;
+
+	desc->tfm = shash;
+	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	crypto_shash_init(desc);
+	crypto_shash_update(desc, data, datalen);
+	crypto_shash_update(desc, sig, sizeof(*sh));
+	crypto_shash_final(desc, hash);
+
+	kfree(desc);
+
+	/* pass signature mpis address */
+	err = digsig_verify_rsa(key, sig + sizeof(*sh), siglen - sizeof(*sh),
+			     hash, sizeof(hash));
+
+err:
+	key_put(key);
+
+	return err ? -EINVAL : 0;
+}
+EXPORT_SYMBOL_GPL(digsig_verify);
+
+static int __init digsig_init(void)
+{
+	shash = crypto_alloc_shash("sha1", 0, 0);
+	if (IS_ERR(shash)) {
+		pr_err("shash allocation failed\n");
+		return  PTR_ERR(shash);
+	}
+
+	return 0;
+
+}
+
+static void __exit digsig_cleanup(void)
+{
+	crypto_free_shash(shash);
+}
+
+module_init(digsig_init);
+module_exit(digsig_cleanup);
+
+MODULE_LICENSE("GPL");
-- 
1.7.4.1

