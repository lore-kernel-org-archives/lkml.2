Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127Ab2IMXtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 19:49:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759054Ab2IMXtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 19:49:18 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/16] KEYS: Asymmetric public-key algorithm crypto key subtype
To: herbert@gondor.hengli.com.au, rusty@rustcorp.com.au
Cc: linux-crypto@vger.kernel.org, zohar@us.ibm.com, dmitry.kasatkin@intel.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 14 Sep 2012 00:48:57 +0100
Message-ID: <20120913234857.3575.38851.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120913234802.3575.77103.stgit@warthog.procyon.org.uk>
References: <20120913234802.3575.77103.stgit@warthog.procyon.org.uk>
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

 crypto/asymmetric_keys/Kconfig      |    8 +++
 crypto/asymmetric_keys/Makefile     |    2 +
 crypto/asymmetric_keys/public_key.c |  108 +++++++++++++++++++++++++++++++++++
 crypto/asymmetric_keys/public_key.h |   28 +++++++++
 include/crypto/public_key.h         |  109 +++++++++++++++++++++++++++++++++++
 5 files changed, 255 insertions(+)
 create mode 100644 crypto/asymmetric_keys/public_key.c
 create mode 100644 crypto/asymmetric_keys/public_key.h
 create mode 100644 include/crypto/public_key.h


diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index cad29b3..bbfccaa 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -9,5 +9,13 @@ menuconfig ASYMMETRIC_KEY_TYPE
 
 if ASYMMETRIC_KEY_TYPE
 
+config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
+	tristate "Asymmetric public-key crypto algorithm subtype"
+	select MPILIB
+	help
+	  This option provides support for asymmetric public key type handling.
+	  If signature generation and/or verification are to be used,
+	  appropriate hash algorithms (such as SHA-1) must be available.
+	  ENOPKG will be reported if the requisite algorithm is unavailable.
 
 endif # ASYMMETRIC_KEY_TYPE
diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index b725bcc..5ed46ee 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -5,3 +5,5 @@
 obj-$(CONFIG_ASYMMETRIC_KEY_TYPE) += asymmetric_keys.o
 
 asymmetric_keys-y := asymmetric_type.o
+
+obj-$(CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE) += public_key.o
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
new file mode 100644
index 0000000..cb2e291
--- /dev/null
+++ b/crypto/asymmetric_keys/public_key.c
@@ -0,0 +1,108 @@
+/* In-software asymmetric public-key crypto subtype
+ *
+ * See Documentation/crypto/asymmetric-keys.txt
+ *
+ * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
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
+#include <linux/export.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/seq_file.h>
+#include <keys/asymmetric-subtype.h>
+#include "public_key.h"
+
+MODULE_LICENSE("GPL");
+
+const char *const pkey_algo[PKEY_ALGO__LAST] = {
+	[PKEY_ALGO_DSA]		= "DSA",
+	[PKEY_ALGO_RSA]		= "RSA",
+};
+EXPORT_SYMBOL_GPL(pkey_algo);
+
+const char *const pkey_hash_algo[PKEY_HASH__LAST] = {
+	[PKEY_HASH_MD4]		= "md4",
+	[PKEY_HASH_MD5]		= "md5",
+	[PKEY_HASH_SHA1]	= "sha1",
+	[PKEY_HASH_RIPE_MD_160]	= "rmd160",
+	[PKEY_HASH_SHA256]	= "sha256",
+	[PKEY_HASH_SHA384]	= "sha384",
+	[PKEY_HASH_SHA512]	= "sha512",
+	[PKEY_HASH_SHA224]	= "sha224",
+};
+EXPORT_SYMBOL_GPL(pkey_hash_algo);
+
+const char *const pkey_id_type[PKEY_ID_TYPE__LAST] = {
+	[PKEY_ID_PGP]		= "PGP",
+	[PKEY_ID_X509]		= "X509",
+};
+EXPORT_SYMBOL_GPL(pkey_id_type);
+
+/*
+ * Provide a part of a description of the key for /proc/keys.
+ */
+static void public_key_describe(const struct key *asymmetric_key,
+				struct seq_file *m)
+{
+	struct public_key *key = asymmetric_key->payload.data;
+
+	if (key)
+		seq_printf(m, "%s.%s",
+			   pkey_id_type[key->id_type], key->algo->name);
+}
+
+/*
+ * Destroy a public key algorithm key.
+ */
+void public_key_destroy(void *payload)
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
+EXPORT_SYMBOL_GPL(public_key_destroy);
+
+/*
+ * Verify a signature using a public key.
+ */
+static int public_key_verify_signature(const struct key *key,
+				       const struct public_key_signature *sig)
+{
+	const struct public_key *pk = key->payload.data;
+
+	if (!pk->algo->verify_signature)
+		return -ENOTSUPP;
+
+	if (sig->nr_mpi != pk->algo->n_sig_mpi) {
+		pr_debug("Signature has %u MPI not %u\n",
+			 sig->nr_mpi, pk->algo->n_sig_mpi);
+		return -EINVAL;
+	}
+
+	return pk->algo->verify_signature(pk, sig);
+}
+
+/*
+ * Public key algorithm asymmetric key subtype
+ */
+struct asymmetric_key_subtype public_key_subtype = {
+	.owner			= THIS_MODULE,
+	.name			= "public_key",
+	.describe		= public_key_describe,
+	.destroy		= public_key_destroy,
+	.verify_signature	= public_key_verify_signature,
+};
+EXPORT_SYMBOL_GPL(public_key_subtype);
diff --git a/crypto/asymmetric_keys/public_key.h b/crypto/asymmetric_keys/public_key.h
new file mode 100644
index 0000000..1f86aad
--- /dev/null
+++ b/crypto/asymmetric_keys/public_key.h
@@ -0,0 +1,28 @@
+/* Public key algorithm internals
+ *
+ * See Documentation/crypto/asymmetric-keys.txt
+ *
+ * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <crypto/public_key.h>
+
+extern struct asymmetric_key_subtype public_key_subtype;
+
+/*
+ * Public key algorithm definition.
+ */
+struct public_key_algorithm {
+	const char	*name;
+	u8		n_pub_mpi;	/* Number of MPIs in public key */
+	u8		n_sec_mpi;	/* Number of MPIs in secret key */
+	u8		n_sig_mpi;	/* Number of MPIs in a signature */
+	int (*verify_signature)(const struct public_key *key,
+				const struct public_key_signature *sig);
+};
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
new file mode 100644
index 0000000..65d9879
--- /dev/null
+++ b/include/crypto/public_key.h
@@ -0,0 +1,109 @@
+/* Asymmetric public-key algorithm definitions
+ *
+ * See Documentation/crypto/asymmetric-keys.txt
+ *
+ * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
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
+
+enum pkey_algo {
+	PKEY_ALGO_DSA,
+	PKEY_ALGO_RSA,
+	PKEY_ALGO__LAST
+};
+
+extern const char *const pkey_algo[PKEY_ALGO__LAST];
+
+enum pkey_hash_algo {
+	PKEY_HASH_MD4,
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
+extern const char *const pkey_hash_algo[PKEY_HASH__LAST];
+
+enum pkey_id_type {
+	PKEY_ID_PGP,		/* OpenPGP generated key ID */
+	PKEY_ID_X509,		/* X.509 arbitrary subjectKeyIdentifier */
+	PKEY_ID_TYPE__LAST
+};
+
+extern const char *const pkey_id_type[PKEY_ID_TYPE__LAST];
+
+/*
+ * Cryptographic data for the public-key subtype of the asymmetric key type.
+ *
+ * Note that this may include private part of the key as well as the public
+ * part.
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
+	enum pkey_id_type id_type : 8;
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
+extern void public_key_destroy(void *payload);
+
+/*
+ * Public key cryptography signature data
+ */
+struct public_key_signature {
+	u8 *digest;
+	u8 digest_size;			/* Number of bytes in digest */
+	u8 nr_mpi;			/* Occupancy of mpi[] */
+	enum pkey_hash_algo pkey_hash_algo : 8;
+	union {
+		MPI mpi[2];
+		struct {
+			MPI s;		/* m^d mod n */
+		} rsa;
+		struct {
+			MPI r;
+			MPI s;
+		} dsa;
+	};
+};
+
+#endif /* _LINUX_PUBLIC_KEY_H */

