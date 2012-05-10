Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab2EJXkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:40:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891Ab2EJXk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:40:28 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 07/29] KEYS: Asymmetric public-key algorithm crypto key
 subtype [ver #4]
To: rusty@rustcorp.com.au
Cc: kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        David Howells <dhowells@redhat.com>
Date: Fri, 11 May 2012 00:40:18 +0100
Message-ID: <20120510234018.4137.44760.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
References: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a subtype for supporting asymmetric public-key encryption algorithms such
as DSA (FIPS-186) and RSA (PKCS#1 / RFC1337).

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/crypto/Kconfig      |   10 +++
 security/keys/crypto/Makefile     |    3 +
 security/keys/crypto/public_key.c |   55 +++++++++++++++++++
 security/keys/crypto/public_key.h |  106 +++++++++++++++++++++++++++++++++++++
 4 files changed, 173 insertions(+), 1 deletions(-)
 create mode 100644 security/keys/crypto/public_key.c
 create mode 100644 security/keys/crypto/public_key.h


diff --git a/security/keys/crypto/Kconfig b/security/keys/crypto/Kconfig
index 3d15710..5f2b8ac 100644
--- a/security/keys/crypto/Kconfig
+++ b/security/keys/crypto/Kconfig
@@ -5,3 +5,13 @@ config CRYPTO_KEY_TYPE
 	  This option provides support for a type of key that holds the keys
 	  required for cryptographic operations such as encryption, decryption,
 	  signature generation and signature verification.
+
+config CRYPTO_KEY_PUBLIC_KEY_SUBTYPE
+	tristate "Asymmetric public-key crypto algorithm subtype"
+	depends on CRYPTO_KEY_TYPE
+	select MPILIB
+	help
+	  This option provides support for asymmetric public key type handling.
+	  If signature generation and/or verification are to be used,
+	  appropriate hash algorithms (such as SHA-1) must be available.
+	  ENOPKG will be reported if the requisite algorithm is unavailable.
diff --git a/security/keys/crypto/Makefile b/security/keys/crypto/Makefile
index 67001bc..6384306 100644
--- a/security/keys/crypto/Makefile
+++ b/security/keys/crypto/Makefile
@@ -3,5 +3,6 @@
 #
 
 obj-$(CONFIG_CRYPTO_KEY_TYPE) += crypto_keys.o
-
 crypto_keys-y := crypto_type.o crypto_verify.o
+
+obj-$(CONFIG_CRYPTO_KEY_PUBLIC_KEY_SUBTYPE) += public_key.o
diff --git a/security/keys/crypto/public_key.c b/security/keys/crypto/public_key.c
new file mode 100644
index 0000000..c00ddac
--- /dev/null
+++ b/security/keys/crypto/public_key.c
@@ -0,0 +1,55 @@
+/* Asymmetric public key crypto subtype
+ *
+ * Copyright (C) 2011 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#define pr_fmt(fmt) "PKEY: "fmt
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include "public_key.h"
+
+MODULE_LICENSE("GPL");
+
+/*
+ * Provide a part of a description of the key for /proc/keys.
+ */
+static void public_key_describe(const struct key *crypto_key,
+				struct seq_file *m)
+{
+	struct public_key *key = crypto_key->payload.data;
+
+	if (key)
+		seq_puts(m, key->algo->name);
+}
+
+/*
+ * Destroy a public key algorithm key
+ */
+static void public_key_destroy(void *payload)
+{
+	struct public_key *key = payload;
+	int i;
+
+	if (key) {
+		for (i = 0; i < ARRAY_SIZE(key->mpi); i++)
+			mpi_free(key->mpi[i]);
+		kfree(key);
+	}
+}
+
+/*
+ * Public key algorithm crypto key subtype
+ */
+struct crypto_key_subtype public_key_crypto_key_subtype = {
+	.owner		= THIS_MODULE,
+	.name		= "public_key",
+	.describe	= public_key_describe,
+	.destroy	= public_key_destroy,
+};
+EXPORT_SYMBOL_GPL(public_key_crypto_key_subtype);
diff --git a/security/keys/crypto/public_key.h b/security/keys/crypto/public_key.h
new file mode 100644
index 0000000..81ed603
--- /dev/null
+++ b/security/keys/crypto/public_key.h
@@ -0,0 +1,106 @@
+/* Asymmetric public-key algorithm definitions
+ *
+ * Copyright (C) 2011 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _LINUX_PUBLIC_KEY_H
+#define _LINUX_PUBLIC_KEY_H
+
+#include <linux/mpi.h>
+#include <crypto/hash.h>
+#include <keys/crypto-subtype.h>
+
+struct public_key;
+struct public_key_signature;
+
+enum pkey_hash_algo {
+	PKEY_HASH_MD5,
+	PKEY_HASH_SHA1,
+	PKEY_HASH_RIPE_MD_160,
+	PKEY_HASH_SHA256,
+	PKEY_HASH_SHA384,
+	PKEY_HASH_SHA512,
+	PKEY_HASH_SHA224,
+	PKEY_HASH__LAST
+};
+
+/*
+ * Public key type definition
+ */
+struct public_key_algorithm {
+	const char	*name;
+	u8		n_pub_mpi;	/* Number of MPIs in public key */
+	u8		n_sec_mpi;	/* Number of MPIs in secret key */
+	u8		n_sig_mpi;	/* Number of MPIs in a signature */
+	int (*verify)(const struct public_key *key,
+		      const struct public_key_signature *sig);
+};
+
+/*
+ * Asymmetric public key data
+ */
+struct public_key {
+	const struct public_key_algorithm *algo;
+	u8	capabilities;
+#define PKEY_CAN_ENCRYPT	0x01
+#define PKEY_CAN_DECRYPT	0x02
+#define PKEY_CAN_ENCDEC		(PKEY_CAN_ENCRYPT | PKEY_CAN_DECRYPT)
+#define PKEY_CAN_SIGN		0x04
+#define PKEY_CAN_VERIFY		0x08
+#define PKEY_CAN_SIGVER		(PKEY_CAN_SIGN | PKEY_CAN_VERIFY)
+	union {
+		MPI	mpi[5];
+		struct {
+			MPI	p;	/* DSA prime */
+			MPI	q;	/* DSA group order */
+			MPI	g;	/* DSA group generator */
+			MPI	y;	/* DSA public-key value = g^x mod p */
+			MPI	x;	/* DSA secret exponent (if present) */
+		} dsa;
+		struct {
+			MPI	n;	/* RSA public modulus */
+			MPI	e;	/* RSA public encryption exponent */
+			MPI	d;	/* RSA secret encryption exponent (if present) */
+			MPI	p;	/* RSA secret prime (if present) */
+			MPI	q;	/* RSA secret prime (if present) */
+		} rsa;
+	};
+
+	u8	key_id[8];	/* ID of this key pair */
+	u8	key_id_size;	/* Number of bytes in key_id */
+};
+
+/*
+ * Asymmetric public key algorithm signature data
+ */
+struct public_key_signature {
+	struct crypto_key_verify_context base;
+	u8 *digest;
+	enum pkey_hash_algo pkey_hash_algo : 8;
+	u8 signed_hash_msw[2];
+	u8 digest_size;	/* Number of bytes in digest */
+	union {
+		MPI mpi[2];
+		struct {
+			MPI s;			/* m^d mod n */
+		} rsa;
+		struct {
+			MPI r;
+			MPI s;
+		} dsa;
+	};
+	struct shash_desc hash;			/* This must go last! */
+};
+
+extern struct crypto_key_verify_context *pgp_pkey_verify_sig_begin(
+	struct key *crypto_key, const u8 *sigdata, size_t siglen);
+
+extern struct crypto_key_subtype public_key_crypto_key_subtype;
+
+#endif /* _LINUX_PUBLIC_KEY_H */

