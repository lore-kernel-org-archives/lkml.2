Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965706Ab2J3TVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:21:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965691Ab2J3TVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:21:10 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 08/23] X.509: Embed public_key_signature struct and create
 filler function
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, pjones@redhat.com, jwboyer@redhat.com, mjg@redhat.com,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        keescook@chromium.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 30 Oct 2012 19:20:40 +0000
Message-ID: <20121030192040.11000.56337.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
References: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Embed a public_key_signature struct in struct x509_certificate, eliminating
now unnecessary fields, and split x509_check_signature() to create a filler
function for it that attaches a digest of the signed data and an MPI that
represents the signature data.  x509_free_certificate() is then modified to
these.

Whilst we're at it, export both x509_check_signature() and the new
x509_get_sig_params().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/x509_cert_parser.c |   30 ++++++----
 crypto/asymmetric_keys/x509_parser.h      |   14 +++--
 crypto/asymmetric_keys/x509_public_key.c  |   83 ++++++++++++++++-------------
 3 files changed, 73 insertions(+), 54 deletions(-)


diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 08bebf1..931f069 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -47,6 +47,8 @@ void x509_free_certificate(struct x509_certificate *cert)
 		kfree(cert->subject);
 		kfree(cert->fingerprint);
 		kfree(cert->authority);
+		kfree(cert->sig.digest);
+		mpi_free(cert->sig.rsa.s);
 		kfree(cert);
 	}
 }
@@ -152,33 +154,33 @@ int x509_note_pkey_algo(void *context, size_t hdrlen,
 		return -ENOPKG; /* Unsupported combination */
 
 	case OID_md4WithRSAEncryption:
-		ctx->cert->sig_hash_algo = PKEY_HASH_MD5;
-		ctx->cert->sig_pkey_algo = PKEY_ALGO_RSA;
+		ctx->cert->sig.pkey_hash_algo = PKEY_HASH_MD5;
+		ctx->cert->sig.pkey_algo = PKEY_ALGO_RSA;
 		break;
 
 	case OID_sha1WithRSAEncryption:
-		ctx->cert->sig_hash_algo = PKEY_HASH_SHA1;
-		ctx->cert->sig_pkey_algo = PKEY_ALGO_RSA;
+		ctx->cert->sig.pkey_hash_algo = PKEY_HASH_SHA1;
+		ctx->cert->sig.pkey_algo = PKEY_ALGO_RSA;
 		break;
 
 	case OID_sha256WithRSAEncryption:
-		ctx->cert->sig_hash_algo = PKEY_HASH_SHA256;
-		ctx->cert->sig_pkey_algo = PKEY_ALGO_RSA;
+		ctx->cert->sig.pkey_hash_algo = PKEY_HASH_SHA256;
+		ctx->cert->sig.pkey_algo = PKEY_ALGO_RSA;
 		break;
 
 	case OID_sha384WithRSAEncryption:
-		ctx->cert->sig_hash_algo = PKEY_HASH_SHA384;
-		ctx->cert->sig_pkey_algo = PKEY_ALGO_RSA;
+		ctx->cert->sig.pkey_hash_algo = PKEY_HASH_SHA384;
+		ctx->cert->sig.pkey_algo = PKEY_ALGO_RSA;
 		break;
 
 	case OID_sha512WithRSAEncryption:
-		ctx->cert->sig_hash_algo = PKEY_HASH_SHA512;
-		ctx->cert->sig_pkey_algo = PKEY_ALGO_RSA;
+		ctx->cert->sig.pkey_hash_algo = PKEY_HASH_SHA512;
+		ctx->cert->sig.pkey_algo = PKEY_ALGO_RSA;
 		break;
 
 	case OID_sha224WithRSAEncryption:
-		ctx->cert->sig_hash_algo = PKEY_HASH_SHA224;
-		ctx->cert->sig_pkey_algo = PKEY_ALGO_RSA;
+		ctx->cert->sig.pkey_hash_algo = PKEY_HASH_SHA224;
+		ctx->cert->sig.pkey_algo = PKEY_ALGO_RSA;
 		break;
 	}
 
@@ -203,8 +205,8 @@ int x509_note_signature(void *context, size_t hdrlen,
 		return -EINVAL;
 	}
 
-	ctx->cert->sig = value;
-	ctx->cert->sig_size = vlen;
+	ctx->cert->raw_sig = value;
+	ctx->cert->raw_sig_size = vlen;
 	return 0;
 }
 
diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index a6ce46f..6b1d877 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -21,18 +21,17 @@ struct x509_certificate {
 	char		*authority;		/* Authority key fingerprint as hex */
 	struct tm	valid_from;
 	struct tm	valid_to;
-	enum pkey_algo	sig_pkey_algo : 8;	/* Signature public key algorithm */
-	enum pkey_hash_algo sig_hash_algo : 8;	/* Signature hash algorithm */
 	const void	*tbs;			/* Signed data */
 	unsigned	tbs_size;		/* Size of signed data */
-	unsigned	sig_size;		/* Size of sigature */
-	const void	*sig;			/* Signature data */
+	unsigned	raw_sig_size;		/* Size of sigature */
+	const void	*raw_sig;		/* Signature data */
 	const void	*raw_serial;		/* Raw serial number in ASN.1 */
 	unsigned	raw_serial_size;
 	unsigned	raw_issuer_size;
 	const void	*raw_issuer;		/* Raw issuer name in ASN.1 */
 	const void	*raw_subject;		/* Raw subject name in ASN.1 */
 	unsigned	raw_subject_size;
+	struct public_key_signature sig;	/* Signature parameters */
 };
 
 /*
@@ -40,3 +39,10 @@ struct x509_certificate {
  */
 extern void x509_free_certificate(struct x509_certificate *cert);
 extern struct x509_certificate *x509_cert_parse(const void *data, size_t datalen);
+
+/*
+ * x509_public_key.c
+ */
+extern int x509_get_sig_params(struct x509_certificate *cert);
+extern int x509_check_signature(const struct public_key *pub,
+				struct x509_certificate *cert);
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 8cb2f70..b7c81d8 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -24,72 +24,83 @@
 #include "x509_parser.h"
 
 /*
- * Check the signature on a certificate using the provided public key
+ * Set up the signature parameters in an X.509 certificate.  This involves
+ * digesting the signed data and extracting the signature.
  */
-static int x509_check_signature(const struct public_key *pub,
-				const struct x509_certificate *cert)
+int x509_get_sig_params(struct x509_certificate *cert)
 {
-	struct public_key_signature *sig;
 	struct crypto_shash *tfm;
 	struct shash_desc *desc;
 	size_t digest_size, desc_size;
+	void *digest;
 	int ret;
 
 	pr_devel("==>%s()\n", __func__);
-	
+
+	if (cert->sig.rsa.s)
+		return 0;
+
+	cert->sig.rsa.s = mpi_read_raw_data(cert->raw_sig, cert->raw_sig_size);
+	if (!cert->sig.rsa.s)
+		return -ENOMEM;
+	cert->sig.nr_mpi = 1;
+
 	/* Allocate the hashing algorithm we're going to need and find out how
 	 * big the hash operational data will be.
 	 */
-	tfm = crypto_alloc_shash(pkey_hash_algo_name[cert->sig_hash_algo], 0, 0);
+	tfm = crypto_alloc_shash(pkey_hash_algo_name[cert->sig.pkey_hash_algo], 0, 0);
 	if (IS_ERR(tfm))
 		return (PTR_ERR(tfm) == -ENOENT) ? -ENOPKG : PTR_ERR(tfm);
 
 	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
 	digest_size = crypto_shash_digestsize(tfm);
 
-	/* We allocate the hash operational data storage on the end of our
-	 * context data.
+	/* We allocate the hash operational data storage on the end of the
+	 * digest storage space.
 	 */
 	ret = -ENOMEM;
-	sig = kzalloc(sizeof(*sig) + desc_size + digest_size, GFP_KERNEL);
-	if (!sig)
-		goto error_no_sig;
+	digest = kzalloc(digest_size + desc_size, GFP_KERNEL);
+	if (!digest)
+		goto error;
 
-	sig->pkey_hash_algo	= cert->sig_hash_algo;
-	sig->digest		= (u8 *)sig + sizeof(*sig) + desc_size;
-	sig->digest_size	= digest_size;
+	cert->sig.digest = digest;
+	cert->sig.digest_size = digest_size;
 
-	desc = (void *)sig + sizeof(*sig);
-	desc->tfm	= tfm;
-	desc->flags	= CRYPTO_TFM_REQ_MAY_SLEEP;
+	desc = digest + digest_size;
+	desc->tfm = tfm;
+	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	ret = crypto_shash_init(desc);
 	if (ret < 0)
 		goto error;
+	might_sleep();
+	ret = crypto_shash_finup(desc, cert->tbs, cert->tbs_size, digest);
+error:
+	crypto_free_shash(tfm);
+	pr_devel("<==%s() = %d\n", __func__, ret);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(x509_get_sig_params);
 
-	ret = -ENOMEM;
-	sig->rsa.s = mpi_read_raw_data(cert->sig, cert->sig_size);
-	if (!sig->rsa.s)
-		goto error;
+/*
+ * Check the signature on a certificate using the provided public key
+ */
+int x509_check_signature(const struct public_key *pub,
+			 struct x509_certificate *cert)
+{
+	int ret;
 
-	ret = crypto_shash_finup(desc, cert->tbs, cert->tbs_size, sig->digest);
-	if (ret < 0)
-		goto error_mpi;
+	pr_devel("==>%s()\n", __func__);
 
-	ret = public_key_verify_signature(pub, sig);
+	ret = x509_get_sig_params(cert);
+	if (ret < 0)
+		return ret;
 
+	ret = public_key_verify_signature(pub, &cert->sig);
 	pr_debug("Cert Verification: %d\n", ret);
-
-error_mpi:
-	mpi_free(sig->rsa.s);
-error:
-	kfree(sig);
-error_no_sig:
-	crypto_free_shash(tfm);
-
-	pr_devel("<==%s() = %d\n", __func__, ret);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(x509_check_signature);
 
 /*
  * Attempt to parse a data blob for a key as an X509 certificate.
@@ -118,8 +129,8 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 		 cert->valid_to.tm_mday, cert->valid_to.tm_hour,
 		 cert->valid_to.tm_min,  cert->valid_to.tm_sec);
 	pr_devel("Cert Signature: %s + %s\n",
-		 pkey_algo_name[cert->sig_pkey_algo],
-		 pkey_hash_algo_name[cert->sig_hash_algo]);
+		 pkey_algo_name[cert->sig.pkey_algo],
+		 pkey_hash_algo_name[cert->sig.pkey_hash_algo]);
 
 	if (!cert->fingerprint || !cert->authority) {
 		pr_warn("Cert for '%s' must have SubjKeyId and AuthKeyId extensions\n",

