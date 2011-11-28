Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab1K1Pra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 10:47:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395Ab1K1PrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:47:25 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 09/14] KEYS: DSA key signature verification
To: keyrings@linux-nfs.org
Cc: linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, mitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
        alan.cox@intel.com, David Howells <dhowells@redhat.com>
Date: Mon, 28 Nov 2011 15:46:18 +0000
Message-ID: <20111128154617.6009.59579.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111128154436.6009.77586.stgit@warthog.procyon.org.uk>
References: <20111128154436.6009.77586.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signature verification routines for DSA crypto key subtype.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/Makefile            |    2 
 security/keys/crypto_dsa.h        |   11 +
 security/keys/crypto_dsa_verify.c |  375 +++++++++++++++++++++++++++++++++++++
 3 files changed, 387 insertions(+), 1 deletions(-)
 create mode 100644 security/keys/crypto_dsa_verify.c


diff --git a/security/keys/Makefile b/security/keys/Makefile
index f37c750..d6b691b 100644
--- a/security/keys/Makefile
+++ b/security/keys/Makefile
@@ -23,4 +23,4 @@ obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_SYSCTL) += sysctl.o
 
 crypto_keys-y	:= crypto_type.o pgp_parse.o crypto_verify.o
-crypto_dsa-y	:= crypto_dsa_subtype.o
+crypto_dsa-y	:= crypto_dsa_subtype.o crypto_dsa_verify.o
diff --git a/security/keys/crypto_dsa.h b/security/keys/crypto_dsa.h
index 0455634..8c7c6e9 100644
--- a/security/keys/crypto_dsa.h
+++ b/security/keys/crypto_dsa.h
@@ -34,3 +34,14 @@ struct DSA_payload {
 	u8		key_id_size;	/* Number of bytes in key_id */
 	struct DSA_public_key	*public_key;
 };
+
+/*
+ * crypto_dsa_verify.c
+ */
+extern struct crypto_key_verify_context *DSA_verify_sig_begin(
+	struct key *key, const u8 *sig, size_t siglen);
+extern int DSA_verify_sig_add_data(struct crypto_key_verify_context *ctx,
+				   const void *data, size_t datalen);
+extern int DSA_verify_sig_end(struct crypto_key_verify_context *ctx,
+			      const u8 *sig, size_t siglen);
+extern void DSA_verify_sig_cancel(struct crypto_key_verify_context *ctx);
diff --git a/security/keys/crypto_dsa_verify.c b/security/keys/crypto_dsa_verify.c
new file mode 100644
index 0000000..679c11e
--- /dev/null
+++ b/security/keys/crypto_dsa_verify.c
@@ -0,0 +1,375 @@
+/* DSA signature verification algorithm
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
+#define DSA_NSIG	2	/* number of MPI's in DSA signature */
+
+struct DSA_signature {
+	struct crypto_key_verify_context base;
+	enum pgp_hash_algo hash_algo : 8;
+	u8 signed_hash_msw[2];
+	union {
+		MPI mpi[2];
+		struct {
+			MPI r;
+			MPI s;
+		};
+	};
+	struct shash_desc hash;			/* This must go last! */
+};
+
+struct DSA_sig_parse_context {
+	struct pgp_parse_context pgp;
+	struct pgp_sig_parameters params;
+};
+
+static int DSA_parse_signature(struct pgp_parse_context *context,
+			       enum pgp_packet_tag type,
+			       u8 headerlen,
+			       const u8 *data,
+			       size_t datalen)
+{
+	struct DSA_sig_parse_context *ctx =
+		container_of(context, struct DSA_sig_parse_context, pgp);
+
+	return pgp_parse_sig_params(&data, &datalen, &ctx->params);
+}
+
+/*
+ * Begin the process of verifying a DSA signature.
+ *
+ * This involves allocating the hash into which first the data and then the
+ * metadata will be put, and parsing the signature to check that it matches the
+ * key.
+ */
+struct crypto_key_verify_context *DSA_verify_sig_begin(
+	struct key *key, const u8 *sigdata, size_t siglen)
+{
+	struct DSA_sig_parse_context p;
+	struct DSA_signature *sig;
+	struct crypto_shash *tfm;
+	struct DSA_payload *dsa = key->payload.data;
+	int ret;
+
+	kenter("{%d},,%zu", key_serial(key), siglen);
+
+	if (!dsa->public_key) {
+		kleave(" = -ENOKEY [no public key]");
+		return ERR_PTR(-ENOKEY);
+	}
+
+	p.pgp.types_of_interest = (1 << PGP_PKT_SIGNATURE);
+	p.pgp.process_packet = DSA_parse_signature;
+	ret = pgp_parse_packets(sigdata, siglen, &p.pgp);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	if (p.params.pubkey_algo != PGP_PUBKEY_DSA) {
+		kleave(" = -ENOKEY [wrong pk algo]");
+		return ERR_PTR(-ENOKEY);
+	}
+
+	if (p.params.hash_algo >= PGP_HASH__LAST) {
+		kleave(" = -ENOKEY [hash]");
+		return ERR_PTR(-ENOKEY);
+	}
+
+	if (memcmp(&p.params.issuer, dsa->key_id, 8) != 0) {
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
+	if (!tfm)
+		return ERR_PTR(-ENOMEM);
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
+int DSA_verify_sig_add_data(struct crypto_key_verify_context *ctx,
+			    const void *data, size_t datalen)
+{
+	struct DSA_signature *sig =
+		container_of(ctx, struct DSA_signature, base);
+
+	return crypto_shash_update(&sig->hash, data, datalen);
+}
+
+/*
+ * Perform the actual mathematical DSA signature verification.
+ */
+static int DSA_verify(const MPI datahash,
+		      const struct DSA_signature *sig,
+		      const struct DSA_public_key *pub)
+{
+	MPI w = NULL, u1 = NULL, u2 = NULL, v = NULL;
+	MPI base[3];
+	MPI exp[3];
+	int rc;
+
+	kenter("");
+
+	if (!(mpi_cmp_ui(sig->r, 0) > 0 && mpi_cmp(sig->r, pub->q) < 0)) {
+		pr_warning("Assertion failed [0 < r < q]\n");
+		return -EKEYREJECTED;
+	}
+
+	if (!(mpi_cmp_ui(sig->s, 0) > 0 && mpi_cmp(sig->s, pub->q) < 0)) {
+		pr_warning("Assertion failed [0 < s < q]\n");
+		return -EKEYREJECTED;
+	}
+
+	rc = -ENOMEM;
+	w  = mpi_alloc(mpi_get_nlimbs(pub->q)); if (!w ) goto cleanup;
+	u1 = mpi_alloc(mpi_get_nlimbs(pub->q)); if (!u1) goto cleanup;
+	u2 = mpi_alloc(mpi_get_nlimbs(pub->q)); if (!u2) goto cleanup;
+	v  = mpi_alloc(mpi_get_nlimbs(pub->p)); if (!v ) goto cleanup;
+
+	/* w = s^(-1) mod q */
+	if (mpi_invm(w, sig->s, pub->q) < 0)
+		goto cleanup;
+
+	/* u1 = (datahash * w) mod q */
+	if (mpi_mulm(u1, datahash, w, pub->q) < 0)
+		goto cleanup;
+
+	/* u2 = r * w mod q  */
+	if (mpi_mulm(u2, sig->r, w, pub->q) < 0)
+		goto cleanup;
+
+	/* v =  g^u1 * y^u2 mod p mod q */
+	base[0] = pub->g;	exp[0] = u1;
+	base[1] = pub->y;	exp[1] = u2;
+	base[2] = NULL;		exp[2] = NULL;
+
+	if (mpi_mulpowm(v, base, exp, pub->p) < 0)
+		goto cleanup;
+
+	if (mpi_fdiv_r(v, v, pub->q) < 0)
+		goto cleanup;
+
+	rc = (mpi_cmp(v, sig->r) == 0) ? 0 : -EKEYREJECTED;
+
+cleanup:
+	mpi_free(w);
+	mpi_free(u1);
+	mpi_free(u2);
+	mpi_free(v);
+	kleave(" = %d", rc);
+	return rc;
+}
+
+struct DSA_sig_digest_context {
+	struct pgp_parse_context pgp;
+	struct DSA_signature *sig;
+};
+
+/*
+ * Extract required metadata from the signature packet and add what we need to
+ * to the hash.
+ */
+static int DSA_digest_signature(struct pgp_parse_context *context,
+				enum pgp_packet_tag type,
+				u8 headerlen,
+				const u8 *data,
+				size_t datalen)
+{
+	enum pgp_signature_version version;
+	struct DSA_sig_digest_context *ctx =
+		container_of(context, struct DSA_sig_digest_context, pgp);
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
+	datalen--;
+
+	/* And then the cryptographic data, which we'll need for the
+	 * algorithm.
+	 */
+	for (i = 0; i < DSA_NSIG; i++) {
+		unsigned int remaining = datalen;
+		ctx->sig->mpi[i] = mpi_read_from_buffer(data, &remaining);
+		if (!ctx->sig->mpi[i])
+			return -ENOMEM;
+		data += remaining;
+		datalen -= remaining;
+	}
+
+	kleave(" = 0");
+	return 0;
+}
+
+/*
+ * The data is now all loaded into the hash; load the metadata, finalise the
+ * hash and perform the verification step.
+ */
+int DSA_verify_sig_end(struct crypto_key_verify_context *ctx,
+		       const u8 *sigdata, size_t siglen)
+{
+	struct DSA_signature *sig =
+		container_of(ctx, struct DSA_signature, base);
+	struct DSA_payload *dsa = sig->base.key->payload.data;
+	struct DSA_sig_digest_context p;
+	void *digest = NULL;
+	MPI datahash = NULL;
+	size_t digest_size;
+	int ret;
+
+	kenter("");
+
+	/* Firstly we add metadata, starting with some of the data from the
+	 * signature packet */
+	p.pgp.types_of_interest = (1 << PGP_PKT_SIGNATURE);
+	p.pgp.process_packet = DSA_digest_signature;
+	p.sig = sig;
+	ret = pgp_parse_packets(sigdata, siglen, &p.pgp);
+	if (ret < 0)
+		goto error_free_ctx;
+
+	ret = -ENOMEM;
+	digest_size = crypto_shash_digestsize(sig->hash.tfm);
+	digest = kmalloc(digest_size, GFP_KERNEL);
+	if (!digest)
+		goto error_free_ctx;
+
+	crypto_shash_final(&sig->hash, digest);
+
+	ret = -ENOMEM;
+	datahash = mpi_alloc((digest_size + BYTES_PER_MPI_LIMB - 1) /
+			     BYTES_PER_MPI_LIMB);
+	if (!datahash)
+		goto error_free_digest;
+
+	ret = mpi_set_buffer(datahash, digest, digest_size, 0);
+	if (ret < 0)
+		goto error_free_mpi;
+
+	ret = DSA_verify(datahash, sig, dsa->public_key);
+
+error_free_mpi:
+	mpi_free(datahash);
+error_free_digest:
+	kfree(digest);
+error_free_ctx:
+	DSA_verify_sig_cancel(ctx);
+	kleave(" = %d", ret);
+	return ret;
+}
+
+/*
+ * Cancel an in-progress data loading
+ */
+void DSA_verify_sig_cancel(struct crypto_key_verify_context *_ctx)
+{
+	struct DSA_signature *sig =
+		container_of(_ctx, struct DSA_signature, base);
+
+	kenter("");
+
+	/* !!! Do we need to tell the crypto layer to cancel too? */
+	crypto_free_shash(sig->hash.tfm);
+	key_put(sig->base.key);
+	mpi_free(sig->r);
+	mpi_free(sig->s);
+	kfree(sig);
+
+	kleave("");
+}

