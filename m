Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab1K3A2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 19:28:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756843Ab1K3A16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 19:27:58 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 07/16] KEYS: Add a RSA crypto key subtype [ver #2]
To: keyrings@linux-nfs.org
Cc: linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
        alan.cox@intel.com, David Howells <dhowells@redhat.com>
Date: Tue, 29 Nov 2011 23:44:26 +0000
Message-ID: <20111129234426.13625.10612.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111129234258.13625.21153.stgit@warthog.procyon.org.uk>
References: <20111129234258.13625.21153.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a key subtype for handling RSA crypto keys.  For the moment it only
provides a signature verification facility.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/Kconfig                   |    9 +
 security/keys/Makefile             |    2 
 security/keys/crypto_rsa.h         |   36 +++
 security/keys/crypto_rsa_subtype.c |  371 ++++++++++++++++++++++++++++++++++++
 4 files changed, 418 insertions(+), 0 deletions(-)
 create mode 100644 security/keys/crypto_rsa.h
 create mode 100644 security/keys/crypto_rsa_subtype.c


diff --git a/security/Kconfig b/security/Kconfig
index 48926af..4167b4f 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -72,6 +72,15 @@ config CRYPTO_KEY_DSA
 	  This option makes DSA cryptographic keys available.  They can be used
 	  for signature verification.
 
+config CRYPTO_KEY_RSA
+	tristate "RSA key type"
+	depends on CRYPTO_KEY_TYPE
+	select CRYPTO
+	select MPILIB
+	help
+	  This option makes RSA cryptographic keys available.  They can be used
+	  for signature verification.
+
 config KEYS_DEBUG_PROC_KEYS
 	bool "Enable the /proc/keys file by which keys may be viewed"
 	depends on KEYS
diff --git a/security/keys/Makefile b/security/keys/Makefile
index 8c499b1..0cb7d08 100644
--- a/security/keys/Makefile
+++ b/security/keys/Makefile
@@ -17,9 +17,11 @@ obj-$(CONFIG_TRUSTED_KEYS) += trusted.o
 obj-$(CONFIG_ENCRYPTED_KEYS) += encrypted-keys/
 obj-$(CONFIG_CRYPTO_KEY_TYPE) += crypto_keys.o
 obj-$(CONFIG_CRYPTO_KEY_DSA) += crypto_dsa.o
+obj-$(CONFIG_CRYPTO_KEY_RSA) += crypto_rsa.o
 obj-$(CONFIG_KEYS_COMPAT) += compat.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_SYSCTL) += sysctl.o
 
 crypto_keys-y	:= crypto_type.o pgp_parse.o
 crypto_dsa-y	:= crypto_dsa_subtype.o
+crypto_rsa-y	:= crypto_rsa_subtype.o
diff --git a/security/keys/crypto_rsa.h b/security/keys/crypto_rsa.h
new file mode 100644
index 0000000..2ec8edc
--- /dev/null
+++ b/security/keys/crypto_rsa.h
@@ -0,0 +1,36 @@
+/* RSA internal definitions
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
+#define RSA_NPKEY	2	/* number of MPI's in an RSA public key */
+
+extern struct crypto_key_subtype RSA_crypto_key_subtype;
+extern struct crypto_key_subtype RSA_crypto_key_subtype_2;
+extern struct crypto_key_subtype RSA_crypto_key_subtype_3;
+
+/*
+ * public key record
+ */
+struct RSA_public_key {
+	struct pgp_parse_pubkey pgp;
+	union {
+		MPI		pkey[RSA_NPKEY];
+		struct {
+			MPI	n;	/* RSA public modulus */
+			MPI	e;	/* RSA public encryption exponent */
+		};
+	};
+};
+
+struct RSA_payload {
+	u8		key_id[8];	/* ID of this key pair */
+	u8		key_id_size;	/* Number of bytes in key_id */
+	struct RSA_public_key	*public_key;
+};
diff --git a/security/keys/crypto_rsa_subtype.c b/security/keys/crypto_rsa_subtype.c
new file mode 100644
index 0000000..da0d4cf
--- /dev/null
+++ b/security/keys/crypto_rsa_subtype.c
@@ -0,0 +1,371 @@
+/* RSA crypto key subtype
+ *
+ * Copyright (C) 2011 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This file is derived from GnuPG.
+ *	Copyright (C) 1998, 1999, 2000 Free Software Foundation, Inc.
+ *
+ * GnuPG is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * GnuPG is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
+ */
+
+#define DEBUG
+#define pr_fmt(fmt) "RSA: "fmt
+#include <keys/crypto-subtype.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/mpi.h>
+#include <linux/pgp.h>
+#include <crypto/hash.h>
+#include "crypto_rsa.h"
+#define __KDEBUG
+#include "internal.h"
+
+MODULE_LICENSE("GPL");
+
+static inline void digest_putc(struct shash_desc *digest, uint8_t ch)
+{
+	crypto_shash_update(digest, &ch, 1);
+}
+
+/*
+ * Destroy the contents of a RSA payload
+ */
+static void RSA_destroy_payload(struct RSA_payload *rsa)
+{
+	int i;
+
+	if (rsa->public_key) {
+		for (i = 0; i < RSA_NPKEY; i++)
+			mpi_free(rsa->public_key->pkey[i]);
+		kfree(rsa->public_key);
+	}
+	kfree(rsa);
+}
+
+/*
+ * Calculate the public key ID (RFC4880 12.2)
+ */
+static void RSA_calc_pk_keyid(struct shash_desc *digest,
+			      struct RSA_public_key *pk)
+{
+	unsigned n;
+	unsigned nb[RSA_NPKEY];
+	unsigned nn[RSA_NPKEY];
+	u8 *pp[RSA_NPKEY];
+	u32 a32;
+	int i;
+	int npkey = RSA_NPKEY;
+
+	kenter("");
+
+	n = (pk->pgp.version < PGP_KEY_VERSION_4) ? 8 : 6;
+	for (i = 0; i < npkey; i++) {
+		nb[i] = mpi_get_nbits(pk->pkey[i]);
+		pp[i] = mpi_get_buffer(pk->pkey[i], nn + i, NULL);
+		n += 2 + nn[i];
+	}
+
+	digest_putc(digest, 0x99);     /* ctb */
+	digest_putc(digest, n >> 8);   /* 16-bit header length */
+	digest_putc(digest, n);
+	digest_putc(digest, pk->pgp.version);
+
+	a32 = pk->pgp.creation_time;
+	digest_putc(digest, a32 >> 24);
+	digest_putc(digest, a32 >> 16);
+	digest_putc(digest, a32 >>  8);
+	digest_putc(digest, a32 >>  0);
+
+	if (pk->pgp.version < PGP_KEY_VERSION_4) {
+		u16 a16;
+
+		if( pk->pgp.expires_at)
+			a16 = (pk->pgp.expires_at - pk->pgp.creation_time) / 86400UL;
+		else
+			a16 = 0;
+		digest_putc(digest, a16 >> 8);
+		digest_putc(digest, a16 >> 0);
+	}
+
+	digest_putc(digest, pk->pgp.pubkey_algo);
+
+	for (i = 0; i < npkey; i++) {
+		digest_putc(digest, nb[i] >> 8);
+		digest_putc(digest, nb[i]);
+		crypto_shash_update(digest, pp[i], nn[i]);
+		kfree(pp[i]);
+	}
+
+	kleave("");
+}
+
+/*
+ * Calculate and check the public key ID fingerprint against the key ID
+ */
+static int RSA_get_fingerprint(struct RSA_payload *rsa,
+			       struct RSA_public_key *pk,
+			       char **_fingerprint)
+{
+	struct crypto_shash *tfm;
+	struct shash_desc *digest;
+	int digest_size, offset;
+	char *fingerprint;
+	u8 *raw_fingerprint;
+	int ret, i;
+
+	ret = -ENOMEM;
+	tfm = crypto_alloc_shash(pk->pgp.version < PGP_KEY_VERSION_4 ?
+				 "md5" : "sha1", 0, 0);
+	if (!tfm)
+		goto cleanup;
+
+	digest = kmalloc(sizeof(*digest) + crypto_shash_descsize(tfm),
+			 GFP_KERNEL);
+	if (!digest)
+		goto cleanup_tfm;
+
+	digest->tfm = tfm;
+	digest->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	ret = crypto_shash_init(digest);
+	if (ret < 0)
+		goto cleanup_hash;
+
+	RSA_calc_pk_keyid(digest, pk);
+
+	digest_size = crypto_shash_digestsize(tfm);
+
+	raw_fingerprint = kmalloc(digest_size, GFP_KERNEL);
+	if (!raw_fingerprint)
+		goto cleanup_hash;
+
+	ret = crypto_shash_final(digest, raw_fingerprint);
+	if (ret < 0)
+		goto cleanup_raw_fingerprint;
+
+	fingerprint = kmalloc(digest_size * 2 + 1, GFP_KERNEL);
+	if (!fingerprint)
+		goto cleanup_raw_fingerprint;
+
+	offset = digest_size - 8;
+	kdebug("offset %u/%u", offset, digest_size);
+
+	for (i = 0; i < digest_size; i++)
+		sprintf(fingerprint + i * 2, "%02x", raw_fingerprint[i]);
+	kdebug("fingerprint %s", fingerprint);
+
+	memcpy(&rsa->key_id, raw_fingerprint + offset, 8);
+	rsa->key_id_size = 8;
+
+	*_fingerprint = fingerprint;
+	fingerprint = NULL;
+	ret = 0;
+cleanup_raw_fingerprint:
+	kfree(raw_fingerprint);
+cleanup_hash:
+	kfree(digest);
+cleanup_tfm:
+	crypto_free_shash(tfm);
+cleanup:
+	kleave(" = %d", ret);
+	return ret;
+}
+
+struct RSA_pk_parse_context {
+	struct pgp_parse_context pgp;
+	struct RSA_payload *rsa;
+	struct RSA_public_key *pk;
+	char *fingerprint;
+};
+
+/*
+ * Extract a public key or subkey from the PGP stream.
+ */
+static int RSA_parse_public_key(struct pgp_parse_context *context,
+				enum pgp_packet_tag type,
+				u8 headerlen,
+				const u8 *data,
+				size_t datalen)
+{
+	struct RSA_pk_parse_context *ctx =
+		container_of(context, struct RSA_pk_parse_context, pgp);
+	struct RSA_payload *rsa = ctx->rsa;
+	struct RSA_public_key *pk;
+	int i, ret;
+
+	kenter(",%u,%u,,%zu", type, headerlen, datalen);
+
+	if (rsa->public_key) {
+		kleave(" = -ENOKEY [already]");
+		return -ENOKEY;
+	}
+
+	pk = kzalloc(sizeof(struct RSA_public_key), GFP_KERNEL);
+	if (!pk)
+		return -ENOMEM;
+
+	ret = pgp_parse_public_key(&data, &datalen, &pk->pgp);
+	if (pk->pgp.pubkey_algo != PGP_PUBKEY_RSA_ENC_OR_SIG &&
+	    pk->pgp.pubkey_algo != PGP_PUBKEY_RSA_ENC_ONLY &&
+	    pk->pgp.pubkey_algo != PGP_PUBKEY_RSA_SIG_ONLY) {
+		pr_debug("Ignoring non-RSA public key [%u]\n",
+			 pk->pgp.pubkey_algo);
+		ret = -ENOKEY;
+		goto cleanup;
+	}
+
+	ret = -ENOMEM;
+	for (i = 0; i < RSA_NPKEY; i++) {
+		unsigned int remaining = datalen;
+		pk->pkey[i] = mpi_read_from_buffer(data, &remaining);
+		if (!pk->pkey[i])
+			goto cleanup;
+		data += remaining;
+		datalen -= remaining;
+	}
+
+	ret = RSA_get_fingerprint(rsa, pk, &ctx->fingerprint);
+	if (ret < 0)
+		goto cleanup;
+
+	rsa->public_key = pk;
+	kleave(" = 0 [use]");
+	return 0;
+
+cleanup:
+	kdebug("cleanup");
+	if (pk) {
+		for (i = 0; i < RSA_NPKEY; i++)
+			mpi_free(pk->pkey[i]);
+		kfree(pk);
+	}
+	kleave(" = %d", ret);
+	return ret;
+}
+
+/*
+ * Instantiate a RSA key
+ */
+static int RSA_instantiate(struct key *key,
+			   const void *data, size_t datalen)
+{
+	struct RSA_pk_parse_context ctx;
+	struct RSA_payload *rsa;
+	int ret;
+
+	ret = key_payload_reserve(key, datalen);
+	if (ret < 0)
+		return ret;
+
+	rsa = kzalloc(sizeof(struct RSA_payload), GFP_KERNEL);
+	if (!rsa)
+		return -ENOMEM;
+
+	ctx.pgp.types_of_interest = 1 << PGP_PKT_PUBLIC_KEY;
+	ctx.pgp.process_packet = RSA_parse_public_key;
+	ctx.rsa = rsa;
+	ctx.pk = NULL;
+	ctx.fingerprint = NULL;
+
+	ret = pgp_parse_packets(data, datalen, &ctx.pgp);
+	if (ret < 0) {
+		RSA_destroy_payload(rsa);
+		kfree(ctx.fingerprint);
+		key_payload_reserve(key, 0);
+		return ret;
+	}
+
+	key->type_data.p[0] = &RSA_crypto_key_subtype;
+	key->type_data.p[1] = ctx.fingerprint;
+	key->payload.data = rsa;
+	return 0;
+}
+
+/*
+ * Destroy a RSA key
+ */
+static void RSA_destroy(struct key *key)
+{
+	if (key->payload.data)
+		RSA_destroy_payload(key->payload.data);
+}
+
+/*
+ * RSA crypto key subtype
+ */
+struct crypto_key_subtype RSA_crypto_key_subtype = {
+	.owner		= THIS_MODULE,
+	.name		= "rsa",
+	.pubkey_algo	= PGP_PUBKEY_RSA_ENC_OR_SIG,
+	.info		= CRYPTO_KEY_IS_PUBKEY_ALGO,
+	.instantiate	= RSA_instantiate,
+	.destroy	= RSA_destroy,
+};
+
+struct crypto_key_subtype RSA_crypto_key_subtype_2 = {
+	.owner		= THIS_MODULE,
+	.name		= "rsa",
+	.pubkey_algo	= PGP_PUBKEY_RSA_ENC_ONLY,
+	.info		= CRYPTO_KEY_IS_PUBKEY_ALGO,
+	.instantiate	= RSA_instantiate,
+	.destroy	= RSA_destroy,
+};
+
+struct crypto_key_subtype RSA_crypto_key_subtype_3 = {
+	.owner		= THIS_MODULE,
+	.name		= "rsa",
+	.pubkey_algo	= PGP_PUBKEY_RSA_SIG_ONLY,
+	.info		= CRYPTO_KEY_IS_PUBKEY_ALGO,
+	.instantiate	= RSA_instantiate,
+	.destroy	= RSA_destroy,
+};
+
+/*
+ * Module stuff
+ */
+static int __init RSA_init(void)
+{
+	int ret;
+
+	ret = register_crypto_key_subtype(&RSA_crypto_key_subtype);
+	if (ret < 0)
+		return ret;
+
+	ret = register_crypto_key_subtype(&RSA_crypto_key_subtype_2);
+	if (ret < 0)
+		goto error_1;
+
+	ret = register_crypto_key_subtype(&RSA_crypto_key_subtype_3);
+	if (ret < 0)
+		goto error_2;
+	return 0;
+
+error_2:
+	unregister_crypto_key_subtype(&RSA_crypto_key_subtype_2);
+error_1:
+	unregister_crypto_key_subtype(&RSA_crypto_key_subtype);
+	return ret;
+}
+
+static void __exit RSA_cleanup(void)
+{
+	unregister_crypto_key_subtype(&RSA_crypto_key_subtype);
+	unregister_crypto_key_subtype(&RSA_crypto_key_subtype_2);
+	unregister_crypto_key_subtype(&RSA_crypto_key_subtype_3);
+}
+
+module_init(RSA_init);
+module_exit(RSA_cleanup);

