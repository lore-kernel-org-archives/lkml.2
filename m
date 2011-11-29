Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab1K3A2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 19:28:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757072Ab1K3A17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 19:27:59 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/16] KEYS: Add a DSA crypto key subtype [ver #2]
To: keyrings@linux-nfs.org
Cc: linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
        alan.cox@intel.com, David Howells <dhowells@redhat.com>
Date: Tue, 29 Nov 2011 23:44:13 +0000
Message-ID: <20111129234413.13625.56286.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111129234258.13625.21153.stgit@warthog.procyon.org.uk>
References: <20111129234258.13625.21153.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a key subtype for handling DSA crypto keys.  For the moment it only
provides a signature verification facility.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/Kconfig                   |   10 +
 security/keys/Makefile             |    2 
 security/keys/crypto_dsa.h         |   36 ++++
 security/keys/crypto_dsa_subtype.c |  338 ++++++++++++++++++++++++++++++++++++
 4 files changed, 386 insertions(+), 0 deletions(-)
 create mode 100644 security/keys/crypto_dsa.h
 create mode 100644 security/keys/crypto_dsa_subtype.c


diff --git a/security/Kconfig b/security/Kconfig
index ef39878..48926af 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -62,6 +62,16 @@ config CRYPTO_KEY_TYPE
 	  required for cryptographic operations such as encryption, decryption,
 	  signature generation and signature verification.
 
+config CRYPTO_KEY_DSA
+	tristate "DSA key type"
+	depends on CRYPTO_KEY_TYPE
+	select CRYPTO
+	select MPILIB
+	select MPILIB_EXTRA
+	help
+	  This option makes DSA cryptographic keys available.  They can be used
+	  for signature verification.
+
 config KEYS_DEBUG_PROC_KEYS
 	bool "Enable the /proc/keys file by which keys may be viewed"
 	depends on KEYS
diff --git a/security/keys/Makefile b/security/keys/Makefile
index ca85b01..8c499b1 100644
--- a/security/keys/Makefile
+++ b/security/keys/Makefile
@@ -16,8 +16,10 @@ obj-y := \
 obj-$(CONFIG_TRUSTED_KEYS) += trusted.o
 obj-$(CONFIG_ENCRYPTED_KEYS) += encrypted-keys/
 obj-$(CONFIG_CRYPTO_KEY_TYPE) += crypto_keys.o
+obj-$(CONFIG_CRYPTO_KEY_DSA) += crypto_dsa.o
 obj-$(CONFIG_KEYS_COMPAT) += compat.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_SYSCTL) += sysctl.o
 
 crypto_keys-y	:= crypto_type.o pgp_parse.o
+crypto_dsa-y	:= crypto_dsa_subtype.o
diff --git a/security/keys/crypto_dsa.h b/security/keys/crypto_dsa.h
new file mode 100644
index 0000000..0455634
--- /dev/null
+++ b/security/keys/crypto_dsa.h
@@ -0,0 +1,36 @@
+/* DSA internal definitions
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
+#define DSA_NPKEY	4	/* number of MPI's in DSA public key */
+
+extern struct crypto_key_subtype DSA_crypto_key_subtype;
+
+/*
+ * public key record
+ */
+struct DSA_public_key {
+	struct pgp_parse_pubkey pgp;
+	union {
+		MPI		pkey[DSA_NPKEY];
+		struct {
+			MPI	p;	/* DSA prime */
+			MPI	q;	/* DSA group order */
+			MPI	g;	/* DSA group generator */
+			MPI	y;	/* DSA public-key value = g^x mod p */
+		};
+	};
+};
+
+struct DSA_payload {
+	u8		key_id[8];	/* ID of this key pair */
+	u8		key_id_size;	/* Number of bytes in key_id */
+	struct DSA_public_key	*public_key;
+};
diff --git a/security/keys/crypto_dsa_subtype.c b/security/keys/crypto_dsa_subtype.c
new file mode 100644
index 0000000..ae6133b
--- /dev/null
+++ b/security/keys/crypto_dsa_subtype.c
@@ -0,0 +1,338 @@
+/* DSA crypto key subtype
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
+#define pr_fmt(fmt) "DSA: "fmt
+#include <keys/crypto-subtype.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/mpi.h>
+#include <linux/pgp.h>
+#include <crypto/hash.h>
+#define __KDEBUG
+#include "internal.h"
+#include "crypto_dsa.h"
+
+MODULE_LICENSE("GPL");
+
+static inline void digest_putc(struct shash_desc *digest, uint8_t ch)
+{
+	crypto_shash_update(digest, &ch, 1);
+}
+
+/*
+ * Destroy the contents of a DSA payload
+ */
+static void DSA_destroy_payload(struct DSA_payload *dsa)
+{
+	int i;
+
+	if (dsa->public_key) {
+		for (i = 0; i < DSA_NPKEY; i++)
+			mpi_free(dsa->public_key->pkey[i]);
+		kfree(dsa->public_key);
+	}
+	kfree(dsa);
+}
+
+/*
+ * Calculate the public key ID (RFC4880 12.2)
+ */
+static void DSA_calc_pk_keyid(struct shash_desc *digest,
+			      struct DSA_public_key *pk)
+{
+	unsigned n;
+	unsigned nb[DSA_NPKEY];
+	unsigned nn[DSA_NPKEY];
+	u8 *pp[DSA_NPKEY];
+	u32 a32;
+	int i;
+	int npkey = DSA_NPKEY;
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
+	digest_putc(digest, PGP_PUBKEY_DSA);
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
+static int DSA_get_fingerprint(struct DSA_payload *dsa,
+			       struct DSA_public_key *pk,
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
+	DSA_calc_pk_keyid(digest, pk);
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
+	memcpy(&dsa->key_id, raw_fingerprint + offset, 8);
+	dsa->key_id_size = 8;
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
+struct DSA_pk_parse_context {
+	struct pgp_parse_context pgp;
+	struct DSA_payload *dsa;
+	struct DSA_public_key *pk;
+	char *fingerprint;
+};
+
+/*
+ * Extract a public key or subkey from the PGP stream.
+ */
+static int DSA_parse_public_key(struct pgp_parse_context *context,
+				enum pgp_packet_tag type,
+				u8 headerlen,
+				const u8 *data,
+				size_t datalen)
+{
+	struct DSA_pk_parse_context *ctx =
+		container_of(context, struct DSA_pk_parse_context, pgp);
+	struct DSA_payload *dsa = ctx->dsa;
+	struct DSA_public_key *pk;
+	int i, ret;
+
+	kenter(",%u,%u,,%zu", type, headerlen, datalen);
+
+	if (dsa->public_key) {
+		kleave(" = -ENOKEY [already]");
+		return -ENOKEY;
+	}
+
+	pk = kzalloc(sizeof(struct DSA_public_key), GFP_KERNEL);
+	if (!pk)
+		return -ENOMEM;
+
+	ret = pgp_parse_public_key(&data, &datalen, &pk->pgp);
+	if (pk->pgp.pubkey_algo != PGP_PUBKEY_DSA) {
+		pr_debug("Ignoring non-DSA public key [%u]\n",
+			 pk->pgp.pubkey_algo);
+		ret = -ENOKEY;
+		goto cleanup;
+	}
+
+	ret = -ENOMEM;
+	for (i = 0; i < DSA_NPKEY; i++) {
+		unsigned int remaining = datalen;
+		pk->pkey[i] = mpi_read_from_buffer(data, &remaining);
+		if (!pk->pkey[i])
+			goto cleanup;
+		data += remaining;
+		datalen -= remaining;
+	}
+
+	ret = DSA_get_fingerprint(dsa, pk, &ctx->fingerprint);
+	if (ret < 0)
+		goto cleanup;
+
+	dsa->public_key = pk;
+	kleave(" = 0 [use]");
+	return 0;
+
+cleanup:
+	kdebug("cleanup");
+	if (pk) {
+		for (i = 0; i < DSA_NPKEY; i++)
+			mpi_free(pk->pkey[i]);
+		kfree(pk);
+	}
+	kleave(" = %d", ret);
+	return ret;
+}
+
+/*
+ * Instantiate a DSA key
+ */
+static int DSA_instantiate(struct key *key,
+			   const void *data, size_t datalen)
+{
+	struct DSA_pk_parse_context ctx;
+	struct DSA_payload *dsa;
+	int ret;
+
+	kenter("");
+
+	ret = key_payload_reserve(key, datalen);
+	if (ret < 0)
+		return ret;
+
+	dsa = kzalloc(sizeof(struct DSA_payload), GFP_KERNEL);
+	if (!dsa)
+		return -ENOMEM;
+
+	ctx.pgp.types_of_interest =
+		(1 << PGP_PKT_PUBLIC_KEY) | (1 << PGP_PKT_PUBLIC_SUBKEY);
+	ctx.pgp.process_packet = DSA_parse_public_key;
+	ctx.dsa = dsa;
+	ctx.pk = NULL;
+	ctx.fingerprint = NULL;
+
+	ret = pgp_parse_packets(data, datalen, &ctx.pgp);
+	if (ret < 0) {
+		DSA_destroy_payload(dsa);
+		kfree(ctx.fingerprint);
+		key_payload_reserve(key, 0);
+		return ret;
+	}
+
+	key->type_data.p[0] = &DSA_crypto_key_subtype;
+	key->type_data.p[1] = ctx.fingerprint;
+	key->payload.data = dsa;
+	return 0;
+}
+
+/*
+ * Destroy a DSA key
+ */
+static void DSA_destroy(struct key *key)
+{
+	if (key->payload.data)
+		DSA_destroy_payload(key->payload.data);
+}
+
+/*
+ * DSA crypto key subtype
+ */
+struct crypto_key_subtype DSA_crypto_key_subtype = {
+	.owner		= THIS_MODULE,
+	.name		= "dsa",
+	.pubkey_algo	= PGP_PUBKEY_DSA,
+	.info		= CRYPTO_KEY_IS_PUBKEY_ALGO,
+	.instantiate	= DSA_instantiate,
+	.destroy	= DSA_destroy,
+
+	.verify_sig_begin	= DSA_verify_sig_begin,
+	.verify_sig_add_data	= DSA_verify_sig_add_data,
+	.verify_sig_end		= DSA_verify_sig_end,
+	.verify_sig_cancel	= DSA_verify_sig_cancel,
+};
+
+/*
+ * Module stuff
+ */
+static int __init DSA_init(void)
+{
+	return register_crypto_key_subtype(&DSA_crypto_key_subtype);
+}
+
+static void __exit DSA_cleanup(void)
+{
+	unregister_crypto_key_subtype(&DSA_crypto_key_subtype);
+}
+
+module_init(DSA_init);
+module_exit(DSA_cleanup);

