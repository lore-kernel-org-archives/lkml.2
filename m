Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab1IFNKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 09:10:08 -0400
Received: from mga12.intel.com ([143.182.124.36]:50044 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753808Ab1IFNJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 09:09:50 -0400
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: linux-security-module@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.vnet.ibm.com
Subject: [RFC v2.0 2/3] crypto: ksign - digital signature verification support
Date: Tue,  6 Sep 2011 16:11:06 +0300
Message-Id: <247508afbc595e46d0756a07cbf4f879bf9aa48e.1315314576.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1315314576.git.dmitry.kasatkin@intel.com>
References: <cover.1315314576.git.dmitry.kasatkin@intel.com>
In-Reply-To: <cover.1315314576.git.dmitry.kasatkin@intel.com>
References: <cover.1315314576.git.dmitry.kasatkin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements RSA digital signature verification using GnuPG library.

Signature and public key have a special format and have special headers.
Signature header contains keyid, which is used to identify the key,
needed for signature verification.
Payload of the signature and the key are multi-precision integers.

Signing and key management utility "evmctl" is available on
http://meego.gitorious.org/meego-platform-security/evm-utils

Key is added to the kernel keyring with the name equal to a keyid.
evm-utils provide support to load PEM key into the keyring,
to convert PEM key to the kernel format and to load it into the keyring.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Acked-by: Mimi Zohar <zohar@us.ibm.com>
---
 crypto/Kconfig               |   13 ++
 crypto/Makefile              |    3 +
 crypto/ksign.c               |  269 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/crypto/ksign.h |   67 +++++++++++
 4 files changed, 352 insertions(+), 0 deletions(-)
 create mode 100644 crypto/ksign.c
 create mode 100644 include/linux/crypto/ksign.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 4b1b9a4..a604b23 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -863,6 +863,19 @@ config CRYPTO_MPILIB
 	help
 	  Multiprecision maths library from GnuPG
 
+config CRYPTO_KSIGN
+	bool "In-kernel signature checker (EXPERIMENTAL)"
+	depends on CRYPTO
+	help
+	  Signature checker (used for module sig checking).
+
+config CRYPTO_KSIGN_RSA
+	bool "Handle RSA signatures (EXPERIMENTAL)"
+	select CRYPTO_KSIGN
+	select CRYPTO_MPILIB
+	help
+	  RSA Signature checker.
+
 source "drivers/crypto/Kconfig"
 
 endif	# if CRYPTO
diff --git a/crypto/Makefile b/crypto/Makefile
index 604006d..4ef05e8 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -90,6 +90,9 @@ obj-$(CONFIG_CRYPTO_USER_API_HASH) += algif_hash.o
 obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
 obj-$(CONFIG_CRYPTO_MPILIB) += mpi/
 
+obj-$(CONFIG_CRYPTO_KSIGN) += ksignmod.o
+ksignmod-objs := ksign.o
+
 #
 # generic algorithms and the async_tx api
 #
diff --git a/crypto/ksign.c b/crypto/ksign.c
new file mode 100644
index 0000000..7b05911
--- /dev/null
+++ b/crypto/ksign.c
@@ -0,0 +1,269 @@
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
+ *	pkcs decoding is originated from LibTomCrypt code
+ */
+
+#include <linux/slab.h>
+#include <linux/key.h>
+#include <linux/crypto.h>
+#include <crypto/hash.h>
+#include <crypto/sha.h>
+#include <keys/user-type.h>
+#include <linux/crypto/mpi.h>
+#include <linux/crypto/ksign.h>
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
+static int ksign_verify_rsa(struct key *key,
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
+	if (!out1)
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
+/*
+ * Signature verification with public key
+ */
+int ksign_verify(struct key *keyring, const char *sig, int siglen,
+		       const char *digest, int digestlen)
+{
+	int err = -ENOMEM;
+	struct signature_hdr *sh = (struct signature_hdr *)sig;
+	struct shash_desc *desc = NULL;
+	unsigned char h[SHA1_DIGEST_SIZE];
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
+	crypto_shash_update(desc, digest, digestlen);
+	crypto_shash_update(desc, sig, sizeof(*sh));
+	crypto_shash_final(desc, h);
+
+	kfree(desc);
+
+	/* pass signature mpis address */
+	err = ksign_verify_rsa(key, sig + sizeof(*sh), siglen - sizeof(*sh),
+			     h, sizeof(h));
+
+err:
+	key_put(key);
+
+	return err ? -EINVAL : 0;
+}
+EXPORT_SYMBOL_GPL(ksign_verify);
+
+static int __init ksign_init(void)
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
+static void __exit ksign_cleanup(void)
+{
+	crypto_free_shash(shash);
+}
+
+module_init(ksign_init);
+module_exit(ksign_cleanup);
+
+MODULE_LICENSE("GPL");
diff --git a/include/linux/crypto/ksign.h b/include/linux/crypto/ksign.h
new file mode 100644
index 0000000..bdc302f
--- /dev/null
+++ b/include/linux/crypto/ksign.h
@@ -0,0 +1,67 @@
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
+ *	pkcs decoding is originated from LibTomCrypt code
+ */
+
+#ifndef CRYPTO_KSIGN_H
+#define CRYPTO_KSIGN_H
+
+#include <linux/key.h>
+
+enum pubkey_type {
+	PUBKEY_ALGO_RSA,
+	PUBKEY_ALGO_DSA,
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
+	uint8_t		version;
+	uint8_t		algo;
+	uint8_t		nmpi;
+	char		mpi[0];
+} __attribute__ ((packed));
+
+struct signature_hdr {
+	uint8_t		version;
+	time_t		timestamp;	/* signature made */
+	uint8_t		algo;
+	uint8_t		hash;
+	uint8_t		keyid[8];
+	uint8_t		nmpi;
+	char		mpi[0];
+} __attribute__ ((packed));
+
+#ifdef CONFIG_CRYPTO_KSIGN
+
+int ksign_verify(struct key *keyring, const char *sig, int siglen,
+		 const char *digest, int digestlen);
+
+#else
+
+static inline int ksign_verify(struct key *keyring, const char *sig, int siglen,
+		 const char *digest, int digestlen)
+{
+	return -EOPNOTSUPP;
+}
+
+#endif /* CONFIG_CRYPTO_KSIGN */
+
+#endif /* CRYPTO_KSIGN_H */
-- 
1.7.4.1

