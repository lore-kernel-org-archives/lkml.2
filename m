Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab1K2XyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 18:54:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757055Ab1K2XxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 18:53:22 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 11/16] KEYS: RSA key signature verification [ver #2]
To: keyrings@linux-nfs.org
Cc: linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
        alan.cox@intel.com, David Howells <dhowells@redhat.com>
Date: Tue, 29 Nov 2011 23:45:18 +0000
Message-ID: <20111129234517.13625.6000.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111129234258.13625.21153.stgit@warthog.procyon.org.uk>
References: <20111129234258.13625.21153.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signature verification routines for RSA crypto key subtype.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/Makefile             |    2 
 security/keys/crypto_rsa.h         |   11 +
 security/keys/crypto_rsa_subtype.c |   15 +
 security/keys/crypto_rsa_verify.c  |  519 ++++++++++++++++++++++++++++++++++++
 4 files changed, 546 insertions(+), 1 deletions(-)
 create mode 100644 security/keys/crypto_rsa_verify.c


diff --git a/security/keys/Makefile b/security/keys/Makefile
index bde336e..78a3aa6 100644
--- a/security/keys/Makefile
+++ b/security/keys/Makefile
@@ -24,4 +24,4 @@ obj-$(CONFIG_SYSCTL) += sysctl.o
 
 crypto_keys-y	:= crypto_type.o pgp_parse.o crypto_verify.o
 crypto_dsa-y	:= crypto_dsa_subtype.o crypto_dsa_verify.o
-crypto_rsa-y	:= crypto_rsa_subtype.o
+crypto_rsa-y	:= crypto_rsa_subtype.o crypto_rsa_verify.o
diff --git a/security/keys/crypto_rsa.h b/security/keys/crypto_rsa.h
index 2ec8edc..6670458 100644
--- a/security/keys/crypto_rsa.h
+++ b/security/keys/crypto_rsa.h
@@ -34,3 +34,14 @@ struct RSA_payload {
 	u8		key_id_size;	/* Number of bytes in key_id */
 	struct RSA_public_key	*public_key;
 };
+
+/*
+ * crypto_rsa_verify.c
+ */
+extern struct crypto_key_verify_context *RSA_verify_sig_begin(
+	struct key *key, const u8 *sig, size_t siglen);
+extern int RSA_verify_sig_add_data(struct crypto_key_verify_context *ctx,
+				   const void *data, size_t datalen);
+extern int RSA_verify_sig_end(struct crypto_key_verify_context *ctx,
+			      const u8 *sig, size_t siglen);
+extern void RSA_verify_sig_cancel(struct crypto_key_verify_context *ctx);
diff --git a/security/keys/crypto_rsa_subtype.c b/security/keys/crypto_rsa_subtype.c
index da0d4cf..1eb5839 100644
--- a/security/keys/crypto_rsa_subtype.c
+++ b/security/keys/crypto_rsa_subtype.c
@@ -313,6 +313,11 @@ struct crypto_key_subtype RSA_crypto_key_subtype = {
 	.info		= CRYPTO_KEY_IS_PUBKEY_ALGO,
 	.instantiate	= RSA_instantiate,
 	.destroy	= RSA_destroy,
+
+	.verify_sig_begin	= RSA_verify_sig_begin,
+	.verify_sig_add_data	= RSA_verify_sig_add_data,
+	.verify_sig_end		= RSA_verify_sig_end,
+	.verify_sig_cancel	= RSA_verify_sig_cancel,
 };
 
 struct crypto_key_subtype RSA_crypto_key_subtype_2 = {
@@ -322,6 +327,11 @@ struct crypto_key_subtype RSA_crypto_key_subtype_2 = {
 	.info		= CRYPTO_KEY_IS_PUBKEY_ALGO,
 	.instantiate	= RSA_instantiate,
 	.destroy	= RSA_destroy,
+
+	.verify_sig_begin	= RSA_verify_sig_begin,
+	.verify_sig_add_data	= RSA_verify_sig_add_data,
+	.verify_sig_end		= RSA_verify_sig_end,
+	.verify_sig_cancel	= RSA_verify_sig_cancel,
 };
 
 struct crypto_key_subtype RSA_crypto_key_subtype_3 = {
@@ -331,6 +341,11 @@ struct crypto_key_subtype RSA_crypto_key_subtype_3 = {
 	.info		= CRYPTO_KEY_IS_PUBKEY_ALGO,
 	.instantiate	= RSA_instantiate,
 	.destroy	= RSA_destroy,
+
+	.verify_sig_begin	= RSA_verify_sig_begin,
+	.verify_sig_add_data	= RSA_verify_sig_add_data,
+	.verify_sig_end		= RSA_verify_sig_end,
+	.verify_sig_cancel	= RSA_verify_sig_cancel,
 };
 
 /*
diff --git a/security/keys/crypto_rsa_verify.c b/security/keys/crypto_rsa_verify.c
new file mode 100644
index 0000000..736e2f9
--- /dev/null
+++ b/security/keys/crypto_rsa_verify.c
@@ -0,0 +1,519 @@
+/* RSA signature verification algorithm [RFC3447]
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
+#include "internal.h"
+
+struct RSA_signature {
+	struct crypto_key_verify_context base;
+	enum pgp_hash_algo hash_algo : 8;
+	u8 signed_hash_msw[2];
+	union {
+		MPI mpi[1];
+		struct {
+			MPI s;			/* m^d mod n */
+		};
+	};
+	struct shash_desc hash;			/* This must go last! */
+};
+
+/*
+ * Hash algorithm OIDs plus ASN.1 DER wrappings [RFC4880 sec 5.2.2].
+ */
+static const u8 RSA_digest_info_MD5[] = {
+	0x30, 0x20, 0x30, 0x0C, 0x06, 0x08,
+	0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x02, 0x05, /* OID */
+	0x05, 0x00, 0x04, 0x10
+};
+
+static const u8 RSA_digest_info_SHA1[] = {
+	0x30, 0x21, 0x30, 0x09, 0x06, 0x05,
+	0x2b, 0x0E, 0x03, 0x02, 0x1A,
+	0x05, 0x00, 0x04, 0x14
+};
+
+static const u8 RSA_digest_info_RIPE_MD_160[] = {
+	0x30, 0x21, 0x30, 0x09, 0x06, 0x05,
+	0x2B, 0x24, 0x03, 0x02, 0x01,
+	0x05, 0x00, 0x04, 0x14
+};
+
+static const u8 RSA_digest_info_SHA224[] = {
+	0x30, 0x2d, 0x30, 0x0d, 0x06, 0x09,
+	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x04,
+	0x05, 0x00, 0x04, 0x1C
+};
+
+static const u8 RSA_digest_info_SHA256[] = {
+	0x30, 0x31, 0x30, 0x0d, 0x06, 0x09,
+	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x01,
+	0x05, 0x00, 0x04, 0x20
+};
+
+static const u8 RSA_digest_info_SHA384[] = {
+	0x30, 0x41, 0x30, 0x0d, 0x06, 0x09,
+	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x02,
+	0x05, 0x00, 0x04, 0x30
+};
+
+static const u8 RSA_digest_info_SHA512[] = {
+	0x30, 0x51, 0x30, 0x0d, 0x06, 0x09,
+	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x03,
+	0x05, 0x00, 0x04, 0x40
+};
+
+static const struct {
+	const u8 const *data;
+	size_t size;
+} RSA_ASN1_templates[PGP_HASH__LAST] = {
+#define _(X) { RSA_digest_info_##X, sizeof(RSA_digest_info_##X) }
+	[PGP_HASH_MD5]		= _(MD5),
+	[PGP_HASH_SHA1]		= _(SHA1),
+	[PGP_HASH_RIPE_MD_160]	= _(RIPE_MD_160),
+	[PGP_HASH_SHA256]	= _(SHA256),
+	[PGP_HASH_SHA384]	= _(SHA384),
+	[PGP_HASH_SHA512]	= _(SHA512),
+	[PGP_HASH_SHA224]	= _(SHA224),
+#undef _
+};
+
+struct RSA_sig_parse_context {
+	struct pgp_parse_context pgp;
+	struct pgp_sig_parameters params;
+};
+
+static int RSA_parse_signature(struct pgp_parse_context *context,
+			       enum pgp_packet_tag type,
+			       u8 headerlen,
+			       const u8 *data,
+			       size_t datalen)
+{
+	struct RSA_sig_parse_context *ctx =
+		container_of(context, struct RSA_sig_parse_context, pgp);
+
+	return pgp_parse_sig_params(&data, &datalen, &ctx->params);
+}
+
+/*
+ * Begin the process of verifying a RSA signature.
+ *
+ * This involves allocating the hash into which first the data and then the
+ * metadata will be put, and parsing the signature to check that it matches the
+ * key.
+ */
+struct crypto_key_verify_context *RSA_verify_sig_begin(
+	struct key *key, const u8 *sigdata, size_t siglen)
+{
+	struct RSA_sig_parse_context p;
+	struct RSA_signature *sig;
+	struct crypto_shash *tfm;
+	struct RSA_payload *rsa = key->payload.data;
+	int ret;
+
+	kenter("{%d},,%zu", key_serial(key), siglen);
+
+	if (!rsa->public_key) {
+		kleave(" = -ENOKEY [no public key]");
+		return ERR_PTR(-ENOKEY);
+	}
+
+	p.pgp.types_of_interest = (1 << PGP_PKT_SIGNATURE);
+	p.pgp.process_packet = RSA_parse_signature;
+	ret = pgp_parse_packets(sigdata, siglen, &p.pgp);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	if (p.params.pubkey_algo != PGP_PUBKEY_RSA_ENC_OR_SIG &&
+	    p.params.pubkey_algo != PGP_PUBKEY_RSA_SIG_ONLY) {
+		kleave(" = -ENOKEY [wrong pk algo]");
+		return ERR_PTR(-ENOKEY);
+	}
+
+	if (p.params.hash_algo >= PGP_HASH__LAST ||
+	    !pgp_hash_algorithms[p.params.hash_algo]) {
+		kleave(" = -ENOPKG [hash]");
+		return ERR_PTR(-ENOPKG);
+	}
+
+	pr_notice("Signature generated with %s hash\n",
+		  pgp_hash_algorithms[p.params.hash_algo]);
+
+	if (memcmp(&p.params.issuer, rsa->key_id, 8) != 0) {
+		kleave(" = -ENOKEY [wrong key ID]");
+		return ERR_PTR(-ENOKEY);
+	}
+
+	if (p.params.signature_type != PGP_SIG_BINARY_DOCUMENT_SIG &&
+	    p.params.signature_type != PGP_SIG_STANDALONE_SIG) {
+		/* We don't want to canonicalise */
+		kleave(" = -EOPNOTSUPP [canon]");
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+
+	/* Allocate the hashing algorithm we're going to need and find out how
+	 * big the hash operational data will be.
+	 */
+	tfm = crypto_alloc_shash(pgp_hash_algorithms[p.params.hash_algo], 0, 0);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm) == -ENOENT ?
+			ERR_PTR(-ENOPKG) : ERR_CAST(tfm);
+
+	/* We allocate the hash operational data storage on the end of our
+	 * context data.
+	 */
+	sig = kzalloc(sizeof(*sig) + crypto_shash_descsize(tfm), GFP_KERNEL);
+	if (!sig) {
+		crypto_free_shash(tfm);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	sig->base.key = key;
+	sig->hash_algo = p.params.hash_algo;
+	sig->hash.tfm = tfm;
+	sig->hash.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	ret = crypto_shash_init(&sig->hash);
+	if (ret < 0) {
+		crypto_free_shash(sig->hash.tfm);
+		kfree(sig);
+		return ERR_PTR(ret);
+	}
+
+	key_get(sig->base.key);
+	kleave(" = %p", sig);
+	return &sig->base;
+}
+
+/*
+ * Load data into the hash
+ */
+int RSA_verify_sig_add_data(struct crypto_key_verify_context *ctx,
+			    const void *data, size_t datalen)
+{
+	struct RSA_signature *sig =
+		container_of(ctx, struct RSA_signature, base);
+
+	return crypto_shash_update(&sig->hash, data, datalen);
+}
+
+/*
+ * Perform the RSA signature verification.
+ * @H: Value of hash of data and metadata
+ * @EM: The computed signature value
+ * @k: The size of EM (EM[0] is an invalid location but should hold 0x00)
+ * @hash_size: The size of H
+ * @asn1_template: The DigestInfo ASN.1 template
+ * @asn1_size: Size of asm1_template[]
+ */
+static int RSA_verify(const u8 *H, const u8 *EM, size_t k, size_t hash_size,
+		      const u8 *asn1_template, size_t asn1_size)
+{
+	unsigned PS_end, T_offset, i;
+
+	kenter(",,%zu,%zu,%zu", k, hash_size, asn1_size);
+
+	if (k < 2 + 1 + asn1_size + hash_size)
+		return -EBADMSG;
+
+	/* Decode the EMSA-PKCS1-v1_5 */
+	if (EM[1] != 0x01) {
+		kleave(" = -EBADMSG [EM[1] == %02u]", EM[1]);
+		return -EBADMSG;
+	}
+
+	T_offset = k - (asn1_size + hash_size);
+	PS_end = T_offset - 1;
+	if (EM[PS_end] != 0x00) {
+		kleave(" = -EBADMSG [EM[T-1] == %02u]", EM[PS_end]);
+		return -EBADMSG;
+	}
+
+	for (i = 2; i < PS_end; i++) {
+		if (EM[i] != 0xff) {
+			kleave(" = -EBADMSG [EM[PS%x] == %02u]", i - 2, EM[i]);
+			return -EBADMSG;
+		}
+	}
+
+	if (memcmp(asn1_template, EM + T_offset, asn1_size) != 0) {
+		kleave(" = -EBADMSG [EM[T] ASN.1 mismatch]");
+		return -EBADMSG;
+	}
+
+	if (memcmp(H, EM + T_offset + asn1_size, hash_size) != 0) {
+		kleave(" = -EKEYREJECTED [EM[T] hash mismatch]");
+		return -EKEYREJECTED;
+	}
+
+	kleave(" = 0");
+	return 0;
+}
+
+struct RSA_sig_digest_context {
+	struct pgp_parse_context pgp;
+	struct RSA_signature *sig;
+};
+
+/*
+ * Extract required metadata from the signature packet and add what we need to
+ * to the hash.
+ */
+static int RSA_digest_signature(struct pgp_parse_context *context,
+				enum pgp_packet_tag type,
+				u8 headerlen,
+				const u8 *data,
+				size_t datalen)
+{
+	enum pgp_signature_version version;
+	struct RSA_sig_digest_context *ctx =
+		container_of(context, struct RSA_sig_digest_context, pgp);
+	int i;
+
+	kenter("");
+
+	version = *data;
+	if (version == PGP_SIG_VERSION_3) {
+		/* We just include an excerpt of the metadata from a V3
+		 * signature.
+		 */
+		crypto_shash_update(&ctx->sig->hash, data + 1, 5);
+		data += sizeof(struct pgp_signature_v3_packet);
+		datalen -= sizeof(struct pgp_signature_v3_packet);
+	} else if (version == PGP_SIG_VERSION_4) {
+		/* We add the whole metadata header and some of the hashed data
+		 * for a V4 signature, plus a trailer.
+		 */
+		size_t hashedsz, unhashedsz;
+		u8 trailer[6];
+
+		hashedsz = 4 + 2 + (data[4] << 8) + data[5];
+		crypto_shash_update(&ctx->sig->hash, data, hashedsz);
+
+		trailer[0] = version;
+		trailer[1] = 0xffU;
+		trailer[2] = hashedsz >> 24;
+		trailer[3] = hashedsz >> 16;
+		trailer[4] = hashedsz >> 8;
+		trailer[5] = hashedsz;
+
+		crypto_shash_update(&ctx->sig->hash, trailer, 6);
+		data += hashedsz;
+		datalen -= hashedsz;
+
+		unhashedsz = 2 + (data[0] << 8) + data[1];
+		data += unhashedsz;
+		datalen -= unhashedsz;
+	}
+
+	if (datalen <= 2) {
+		kleave(" = -EBADMSG");
+		return -EBADMSG;
+	}
+
+	/* There's a quick check on the hash available. */
+	ctx->sig->signed_hash_msw[0] = *data++;
+	ctx->sig->signed_hash_msw[1] = *data++;
+	datalen -= 2;
+
+	/* And then the cryptographic data, which we'll need for the
+	 * algorithm.
+	 */
+	for (i = 0; i < ARRAY_SIZE(ctx->sig->mpi); i++) {
+		unsigned int remaining = datalen;
+		ctx->sig->mpi[i] = mpi_read_from_buffer(data, &remaining);
+		if (!ctx->sig->mpi[i])
+			return -ENOMEM;
+		data += remaining;
+		datalen -= remaining;
+	}
+
+	if (datalen != 0) {
+		kleave(" = -EBADMSG [trailer %zu]", datalen);
+		return -EBADMSG;
+	}
+
+	kleave(" = 0");
+	return 0;
+}
+
+/*
+ * RSAVP1() function [RFC3447 sec 5.2.2]
+ */
+static int RSAVP1(struct RSA_public_key *pub, MPI s, MPI *_m)
+{
+	MPI m;
+	int ret;
+
+	/* (1) Validate 0 <= s < n */
+	if (mpi_cmp_ui(s, 0) < 0) {
+		kleave(" = -EBADMSG [s < 0]");
+		return -EBADMSG;
+	}
+	if (mpi_cmp(s, pub->n) >= 0) {
+		kleave(" = -EBADMSG [s >= n]");
+		return -EBADMSG;
+	}
+
+	m = mpi_alloc(0);
+	if (!m)
+		return -ENOMEM;
+
+	/* (2) m = s^e mod n */
+	ret = mpi_powm(m, s, pub->e, pub->n);
+	if (ret < 0) {
+		mpi_free(m);
+		return ret;
+	}
+
+	*_m = m;
+	return 0;
+}
+
+/*
+ * Integer to Octet String conversion [RFC3447 sec 4.1]
+ */
+static int RSA_I2OSP(MPI x, size_t xLen, u8 **_X)
+{
+	unsigned X_size, x_size;
+	int X_sign;
+	u8 *X;
+
+	/* Make sure the string is the right length.  The number should begin
+	 * with { 0x00, 0x01, ... } so we have to account for 15 leading zero
+	 * bits not being reported by MPI.
+	 */
+	x_size = mpi_get_nbits(x);
+	kdebug("size(x)=%u xLen*8=%zu", x_size, xLen * 8);
+	if (x_size != xLen * 8 - 15)
+		return -ERANGE;
+
+	X = mpi_get_buffer(x, &X_size, &X_sign);
+	if (!X)
+		return -ENOMEM;
+	if (X_sign < 0) {
+		kfree(X);
+		return -EBADMSG;
+	}
+	if (X_size != xLen - 1) {
+		kfree(X);
+		return -EBADMSG;
+	}
+
+	*_X = X;
+	return 0;
+}
+
+/*
+ * The data is now all loaded into the hash; load the metadata, finalise the
+ * hash and perform the verification step [RFC3447 sec 8.2.2].
+ */
+int RSA_verify_sig_end(struct crypto_key_verify_context *ctx,
+		       const u8 *sigdata, size_t siglen)
+{
+	struct RSA_signature *sig =
+		container_of(ctx, struct RSA_signature, base);
+	struct RSA_payload *rsa = sig->base.key->payload.data;
+	struct RSA_sig_digest_context p;
+	size_t digest_size, tsize;
+	int ret;
+
+	/* Variables as per RFC3447 sec 8.2.2 */
+	void *H = NULL;
+	u8 *EM = NULL;
+	MPI m = NULL;
+	size_t k;
+
+	kenter("");
+
+	/* Firstly we add metadata, starting with some of the data from the
+	 * signature packet */
+	p.pgp.types_of_interest = (1 << PGP_PKT_SIGNATURE);
+	p.pgp.process_packet = RSA_digest_signature;
+	p.sig = sig;
+	ret = pgp_parse_packets(sigdata, siglen, &p.pgp);
+	if (ret < 0)
+		goto error_free_ctx;
+
+	ret = -ENOMEM;
+	digest_size = crypto_shash_digestsize(sig->hash.tfm);
+	H = kmalloc(digest_size, GFP_KERNEL);
+	if (!H)
+		goto error_free_ctx;
+
+	crypto_shash_final(&sig->hash, H);
+
+	/* (1) Check the signature size against the public key modulus size */
+	k = (mpi_get_nbits(rsa->public_key->n) + 7) / 8;
+
+	tsize = (mpi_get_nbits(sig->s) + 7) / 8;
+	kdebug("step 1: k=%zu size(S)=%zu", k, tsize);
+	if (tsize != k) {
+		ret = -EBADMSG;
+		goto error_free_digest;
+	}
+
+	/* (2b) Apply the RSAVP1 verification primitive to the public key */
+	ret = RSAVP1(rsa->public_key, sig->s, &m);
+	if (ret < 0)
+		goto error_free_mpi;
+
+	/* (2c) Convert the message representative (m) to an encoded message
+	 *      (EM) of length k octets.
+	 *
+	 *      NOTE!  The leading zero byte is suppressed by MPI, so we pass a
+	 *      pointer to the _preceding_ byte to RSA_verify()!
+	 */
+	ret = RSA_I2OSP(m, k, &EM);
+	if (ret < 0)
+		goto error_free_mpi;
+
+	ret = RSA_verify(H, EM - 1, k, digest_size,
+			 RSA_ASN1_templates[sig->hash_algo].data,
+			 RSA_ASN1_templates[sig->hash_algo].size);
+
+error_free_mpi:
+	kfree(EM);
+	mpi_free(m);
+error_free_digest:
+	kfree(H);
+error_free_ctx:
+	RSA_verify_sig_cancel(ctx);
+	kleave(" = %d", ret);
+	return ret;
+}
+
+/*
+ * Cancel an in-progress data loading
+ */
+void RSA_verify_sig_cancel(struct crypto_key_verify_context *_ctx)
+{
+	struct RSA_signature *sig =
+		container_of(_ctx, struct RSA_signature, base);
+
+	kenter("");
+
+	/* !!! Do we need to tell the crypto layer to cancel too? */
+	crypto_free_shash(sig->hash.tfm);
+	key_put(sig->base.key);
+	mpi_free(sig->s);
+	kfree(sig);
+
+	kleave("");
+}

