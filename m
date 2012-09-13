Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287Ab2IMXus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 19:50:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759236Ab2IMXul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 19:50:41 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 16/16] X.509: Add a crypto key parser for binary (DER) X.509
 certificates
To: herbert@gondor.hengli.com.au, rusty@rustcorp.com.au
Cc: linux-crypto@vger.kernel.org, zohar@us.ibm.com, dmitry.kasatkin@intel.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 14 Sep 2012 00:50:23 +0100
Message-ID: <20120913235023.3575.67327.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120913234802.3575.77103.stgit@warthog.procyon.org.uk>
References: <20120913234802.3575.77103.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a crypto key parser for binary (DER) encoded X.509 certificates.  The
certificate is parsed and, if possible, the signature is verified.

An X.509 key can be added like this:

	# keyctl padd crypto bar @s </tmp/x509.cert
	15768135

and displayed like this:

	# cat /proc/keys
	00f09a47 I--Q---     1 perm 39390000     0     0 asymmetri bar: X509.RSA e9fd6d08 []

Note that this only works with binary certificates.  PEM encoded certificates
are ignored by the parser.

Note also that the X.509 key ID is not congruent with the PGP key ID, but for
the moment, they will match.

If a NULL or "" name is given to add_key(), then the parser will generate a key
description from the CertificateSerialNumber and Name fields of the
TBSCertificate:

	00aefc4e I--Q---     1 perm 39390000     0     0 asymmetri bfbc0cd76d050ea4:/C=GB/L=Cambridge/O=Red Hat/CN=kernel key: X509.RSA 0c688c7b []

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/.gitignore         |    1 
 crypto/asymmetric_keys/Kconfig            |   10 +
 crypto/asymmetric_keys/Makefile           |   17 +
 crypto/asymmetric_keys/x509.asn1          |   60 +++
 crypto/asymmetric_keys/x509_cert_parser.c |  503 +++++++++++++++++++++++++++++
 crypto/asymmetric_keys/x509_parser.h      |   37 ++
 crypto/asymmetric_keys/x509_public_key.c  |  206 ++++++++++++
 crypto/asymmetric_keys/x509_rsakey.asn1   |    4 
 8 files changed, 838 insertions(+)
 create mode 100644 crypto/asymmetric_keys/.gitignore
 create mode 100644 crypto/asymmetric_keys/x509.asn1
 create mode 100644 crypto/asymmetric_keys/x509_cert_parser.c
 create mode 100644 crypto/asymmetric_keys/x509_parser.h
 create mode 100644 crypto/asymmetric_keys/x509_public_key.c
 create mode 100644 crypto/asymmetric_keys/x509_rsakey.asn1


diff --git a/crypto/asymmetric_keys/.gitignore b/crypto/asymmetric_keys/.gitignore
new file mode 100644
index 0000000..ee32837
--- /dev/null
+++ b/crypto/asymmetric_keys/.gitignore
@@ -0,0 +1 @@
+*-asn1.[ch]
diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 561759d..6d2c2ea 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -25,4 +25,14 @@ config PUBLIC_KEY_ALGO_RSA
 	help
 	  This option enables support for the RSA algorithm (PKCS#1, RFC3447).
 
+config X509_CERTIFICATE_PARSER
+	tristate "X.509 certificate parser"
+	depends on ASYMMETRIC_PUBLIC_KEY_SUBTYPE
+	select ASN1
+	select OID_REGISTRY
+	help
+	  This option procides support for parsing X.509 format blobs for key
+	  data and provides the ability to instantiate a crypto key from a
+	  public key packet found inside the certificate.
+
 endif # ASYMMETRIC_KEY_TYPE
diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index 7c92691..0727204 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -8,3 +8,20 @@ asymmetric_keys-y := asymmetric_type.o signature.o
 
 obj-$(CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE) += public_key.o
 obj-$(CONFIG_PUBLIC_KEY_ALGO_RSA) += rsa.o
+
+#
+# X.509 Certificate handling
+#
+obj-$(CONFIG_X509_CERTIFICATE_PARSER) += x509_key_parser.o
+x509_key_parser-y := \
+	x509-asn1.o \
+	x509_rsakey-asn1.o \
+	x509_cert_parser.o \
+	x509_public_key.o
+
+$(obj)/x509_cert_parser.o: $(obj)/x509-asn1.h $(obj)/x509_rsakey-asn1.h
+$(obj)/x509-asn1.o: $(obj)/x509-asn1.c $(obj)/x509-asn1.h
+$(obj)/x509_rsakey-asn1.o: $(obj)/x509_rsakey-asn1.c $(obj)/x509_rsakey-asn1.h
+
+clean-files	+= x509-asn1.c x509-asn1.h
+clean-files	+= x509_rsakey-asn1.c x509_rsakey-asn1.h
diff --git a/crypto/asymmetric_keys/x509.asn1 b/crypto/asymmetric_keys/x509.asn1
new file mode 100644
index 0000000..a7ad4fc
--- /dev/null
+++ b/crypto/asymmetric_keys/x509.asn1
@@ -0,0 +1,60 @@
+Certificate ::= SEQUENCE {
+	tbsCertificate		TBSCertificate ({ x509_note_tbs_certificate }),
+	signatureAlgorithm	AlgorithmIdentifier,
+	signature		BIT STRING ({ x509_note_signature })
+	} ({ x509_note_cert_start })
+
+TBSCertificate ::= SEQUENCE {
+	version           [ 0 ]	Version DEFAULT,
+	serialNumber		CertificateSerialNumber ({ x509_note_serial }),
+	signature		AlgorithmIdentifier ({ x509_note_pkey_algo }),
+	issuer			Name ({ x509_note_issuer }),
+	validity		Validity,
+	subject			Name ({ x509_note_subject }),
+	subjectPublicKeyInfo	SubjectPublicKeyInfo,
+	issuerUniqueID    [ 1 ]	IMPLICIT UniqueIdentifier OPTIONAL,
+	subjectUniqueID   [ 2 ]	IMPLICIT UniqueIdentifier OPTIONAL,
+	extensions        [ 3 ]	Extensions OPTIONAL
+	}
+
+Version ::= INTEGER
+CertificateSerialNumber ::= INTEGER
+
+AlgorithmIdentifier ::= SEQUENCE {
+	algorithm		OBJECT IDENTIFIER ({ x509_note_OID }),
+	parameters		ANY OPTIONAL
+}
+
+Name ::= SEQUENCE OF RelativeDistinguishedName
+
+RelativeDistinguishedName ::= SET OF AttributeValueAssertion
+
+AttributeValueAssertion ::= SEQUENCE {
+	attributeType		OBJECT IDENTIFIER ({ x509_note_OID }),
+	attributeValue		ANY ({ x509_extract_name_segment })
+	}
+
+Validity ::= SEQUENCE {
+	notBefore		Time ({ x509_note_not_before }),
+	notAfter		Time ({ x509_note_not_after })
+	}
+
+Time ::= CHOICE {
+	utcTime			UTCTime,
+	generalTime		GeneralizedTime
+	}
+
+SubjectPublicKeyInfo ::= SEQUENCE {
+	algorithm		AlgorithmIdentifier,
+	subjectPublicKey	BIT STRING ({ x509_extract_key_data })
+	}
+
+UniqueIdentifier ::= BIT STRING
+
+Extensions ::= SEQUENCE OF Extension
+
+Extension ::= SEQUENCE {
+	extnid			OBJECT IDENTIFIER ({ x509_note_OID }),
+	critical		BOOLEAN DEFAULT,
+	extnValue		OCTET STRING ({ x509_process_extension })
+	}
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
new file mode 100644
index 0000000..cdcfce8
--- /dev/null
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -0,0 +1,503 @@
+/* X.509 certificate parser
+ *
+ * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#undef DEBUG
+#define pr_fmt(fmt) "X.509: "fmt
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/oid_registry.h>
+#include "public_key.h"
+#include "x509_parser.h"
+#include "x509-asn1.h"
+#include "x509_rsakey-asn1.h"
+
+struct x509_parse_context {
+	struct x509_certificate	*cert;		/* Certificate being constructed */
+	unsigned long	data;			/* Start of data */
+	const void	*cert_start;		/* Start of cert content */
+	const void	*key;			/* Key data */
+	size_t		key_size;		/* Size of key data */
+	enum OID	last_oid;		/* Last OID encountered */
+	enum OID	algo_oid;		/* Algorithm OID */
+	unsigned char	nr_mpi;			/* Number of MPIs stored */
+	int		namesize;		/* Usage of namebuffer */
+	char		namebuffer[256];	/* Name building buffer */
+};
+
+/*
+ * Free an X.509 certificate
+ */
+void x509_free_certificate(struct x509_certificate *cert)
+{
+	if (cert) {
+		public_key_destroy(cert->pub);
+		kfree(cert->serial);
+		kfree(cert->issuer);
+		kfree(cert->subject);
+		kfree(cert->fingerprint);
+		kfree(cert->authority);
+		kfree(cert);
+	}
+}
+
+/*
+ * Parse an X.509 certificate
+ */
+struct x509_certificate *x509_cert_parse(const void *data, size_t datalen)
+{
+	struct x509_certificate *cert;
+	struct x509_parse_context *ctx;
+	long ret;
+
+	ret = -ENOMEM;
+	cert = kzalloc(sizeof(struct x509_certificate), GFP_KERNEL);
+	if (!cert)
+		goto error_no_cert;
+	cert->pub = kzalloc(sizeof(struct public_key), GFP_KERNEL);
+	if (!cert->pub)
+		goto error_no_ctx;
+	ctx = kzalloc(sizeof(struct x509_parse_context), GFP_KERNEL);
+	if (!ctx)
+		goto error_no_ctx;
+
+	ctx->cert = cert;
+	ctx->data = (unsigned long)data;
+
+	/* Attempt to decode the certificate */
+	ret = asn1_ber_decoder(&x509_decoder, ctx, data, datalen);
+	if (ret < 0)
+		goto error_decode;
+
+	/* Decode the public key */
+	ret = asn1_ber_decoder(&x509_rsakey_decoder, ctx,
+			       ctx->key, ctx->key_size);
+	if (ret < 0)
+		goto error_decode;
+
+	kfree(ctx);
+	return cert;
+
+error_decode:
+	kfree(ctx);
+error_no_ctx:
+	x509_free_certificate(cert);
+error_no_cert:
+	return ERR_PTR(ret);
+}
+
+/*
+ * Note an OID when we find one for later processing when we know how
+ * to interpret it.
+ */
+int x509_note_OID(void *context, size_t hdrlen,
+	     unsigned char tag,
+	     const void *value, size_t vlen)
+{
+	struct x509_parse_context *ctx = context;
+
+	ctx->last_oid = look_up_OID(value, vlen);
+	if (ctx->last_oid == OID__NR) {
+		char buffer[50];
+		sprint_oid(value, vlen, buffer, sizeof(buffer));
+		printk("X.509: Unknown OID: [%zu] %s: %d\n",
+		       (unsigned long)value - ctx->data, buffer, ctx->last_oid);
+	}
+	return 0;
+}
+
+/*
+ * Save the position of the TBS data so that we can check the signature over it
+ * later.
+ */
+int x509_note_tbs_certificate(void *context, size_t hdrlen,
+			      unsigned char tag,
+			      const void *value, size_t vlen)
+{
+	struct x509_parse_context *ctx = context;
+
+	pr_debug("x509_note_tbs_certificate(,%02x,%ld,%zu)!\n",
+		 tag, (unsigned long)value - ctx->data, vlen);
+
+	ctx->cert->tbs = value;
+	ctx->cert->tbs_size = vlen;
+	return 0;
+}
+
+/*
+ * Note the start position of the certificate content with respect to the TBS
+ * data and use this to compute the length of the TBS header which is needed
+ * for the signature check.
+ */
+int x509_note_cert_start(void *context, size_t hdrlen,
+			 unsigned char tag,
+			 const void *value, size_t vlen)
+{
+	struct x509_parse_context *ctx = context;
+	ptrdiff_t hdrsize;
+
+	pr_debug("x509_note_cert_start(,%02x,%ld,%zu)!\n",
+		 tag, (unsigned long)value - ctx->data, vlen);
+
+	hdrsize = ctx->cert->tbs - value;
+	ctx->cert->tbs = value;
+	ctx->cert->tbs_size += hdrsize;
+	return 0;
+}
+
+/*
+ * Record the public key algorithm
+ */
+int x509_note_pkey_algo(void *context, size_t hdrlen,
+			unsigned char tag,
+			const void *value, size_t vlen)
+{
+	struct x509_parse_context *ctx = context;
+
+	pr_debug("PubKey Algo: %u\n", ctx->last_oid);
+
+	switch (ctx->last_oid) {
+	case OID_md2WithRSAEncryption:
+	case OID_md3WithRSAEncryption:
+	default:
+		return -ENOPKG; /* Unsupported combination */
+
+	case OID_md4WithRSAEncryption:
+		ctx->cert->sig_hash_algo = PKEY_HASH_MD5;
+		ctx->cert->sig_pkey_algo = PKEY_ALGO_RSA;
+		break;
+
+	case OID_sha1WithRSAEncryption:
+		ctx->cert->sig_hash_algo = PKEY_HASH_SHA1;
+		ctx->cert->sig_pkey_algo = PKEY_ALGO_RSA;
+		break;
+
+	case OID_sha256WithRSAEncryption:
+		ctx->cert->sig_hash_algo = PKEY_HASH_SHA256;
+		ctx->cert->sig_pkey_algo = PKEY_ALGO_RSA;
+		break;
+
+	case OID_sha384WithRSAEncryption:
+		ctx->cert->sig_hash_algo = PKEY_HASH_SHA384;
+		ctx->cert->sig_pkey_algo = PKEY_ALGO_RSA;
+		break;
+
+	case OID_sha512WithRSAEncryption:
+		ctx->cert->sig_hash_algo = PKEY_HASH_SHA512;
+		ctx->cert->sig_pkey_algo = PKEY_ALGO_RSA;
+		break;
+
+	case OID_sha224WithRSAEncryption:
+		ctx->cert->sig_hash_algo = PKEY_HASH_SHA224;
+		ctx->cert->sig_pkey_algo = PKEY_ALGO_RSA;
+		break;
+	}
+
+	ctx->algo_oid = ctx->last_oid;
+	return 0;
+}
+
+/*
+ * Note the whereabouts and type of the signature.
+ */
+int x509_note_signature(void *context, size_t hdrlen,
+			unsigned char tag,
+			const void *value, size_t vlen)
+{
+	struct x509_parse_context *ctx = context;
+
+	pr_debug("Signature type: %u size %zu\n", ctx->last_oid, vlen);
+
+	if (ctx->last_oid != ctx->algo_oid) {
+		pr_warn("X.509: Got cert with pkey (%u) and sig (%u) algorithm OIDs\n",
+			ctx->algo_oid, ctx->last_oid);
+		return -EINVAL;
+	}
+
+	ctx->cert->sig = value;
+	ctx->cert->sig_size = vlen;
+	return 0;
+}
+
+/*
+ * Extract name segments into the assembly buffer and tag them with prefixes
+ * appropriate to the attribute OID.
+ */
+int x509_extract_name_segment(void *context, size_t hdrlen,
+			      unsigned char tag,
+			      const void *value, size_t vlen)
+{
+	struct x509_parse_context *ctx = context;
+	const char *prefix;
+	char pbuf[4];
+
+	switch (ctx->last_oid) {
+	case OID_commonName:		prefix = "CN";	break;
+	case OID_surname:		prefix = "S";	break;
+	case OID_countryName:		prefix = "C";	break;
+	case OID_locality:		prefix = "L";	break;
+	case OID_stateOrProvinceName:	prefix = "ST";	break;
+	case OID_organizationName:	prefix = "O";	break;
+	case OID_organizationUnitName:	prefix = "OU";	break;
+	case OID_title:			prefix = "T";	break;
+	case OID_name:			prefix = "N";	break;
+	case OID_givenName:		prefix = "G";	break;
+	case OID_initials:		prefix = "I";	break;
+	case OID_generationalQualifier:	prefix = "GQ";	break;
+	default:
+		sprintf(pbuf, "?%u", ctx->last_oid);
+		prefix = pbuf;
+		break;
+	}
+
+	ctx->namesize += snprintf(ctx->namebuffer + ctx->namesize,
+				  sizeof(ctx->namebuffer) - ctx->namesize,
+				  "/%s=%*.*s",
+				  prefix,
+				  (int)vlen, (int)vlen, (const char *)value);
+	if (ctx->namesize > sizeof(ctx->namebuffer) - 1)
+		ctx->namesize = sizeof(ctx->namebuffer) - 1;
+
+	return 0;
+}
+
+/*
+ * Take a copy of the issuer name.
+ */
+int x509_note_issuer(void *context, size_t hdrlen,
+		     unsigned char tag,
+		     const void *value, size_t vlen)
+{
+	struct x509_parse_context *ctx = context;
+
+	pr_debug("Issuer: %s\n", ctx->namebuffer);
+
+	ctx->cert->issuer = kmalloc(ctx->namesize + 1, GFP_KERNEL);
+	if (!ctx->cert->issuer)
+		return -ENOMEM;
+	memcpy(ctx->cert->issuer, ctx->namebuffer, ctx->namesize);
+	ctx->cert->issuer[ctx->namesize] = 0;
+	ctx->namesize = 0;
+	return 0;
+}
+
+/*
+ * Take a copy of the subject name.
+ */
+int x509_note_subject(void *context, size_t hdrlen,
+		      unsigned char tag,
+		      const void *value, size_t vlen)
+{
+	struct x509_parse_context *ctx = context;
+	pr_debug("Subject: %s\n", ctx->namebuffer);
+
+	ctx->cert->subject = kmalloc(ctx->namesize + 1, GFP_KERNEL);
+	if (!ctx->cert->subject)
+		return -ENOMEM;
+	memcpy(ctx->cert->subject, ctx->namebuffer, ctx->namesize);
+	ctx->cert->subject[ctx->namesize] = 0;
+	ctx->namesize = 0;
+	return 0;
+}
+
+/*
+ * Extract the data for the public key algorithm
+ */
+int x509_extract_key_data(void *context, size_t hdrlen,
+			  unsigned char tag,
+			  const void *value, size_t vlen)
+{
+	struct x509_parse_context *ctx = context;
+
+	if (ctx->last_oid != OID_rsaEncryption)
+		return -ENOPKG;
+
+	/* There seems to be an extraneous 0 byte on the front of the data */
+	ctx->cert->pkey_algo = PKEY_ALGO_RSA;
+	ctx->key = value + 1;
+	ctx->key_size = vlen - 1;
+	return 0;
+}
+
+/*
+ * Extract a RSA public key value
+ */
+int rsa_extract_mpi(void *context, size_t hdrlen,
+		    unsigned char tag,
+		    const void *value, size_t vlen)
+{
+	struct x509_parse_context *ctx = context;
+	MPI mpi;
+
+	if (ctx->nr_mpi >= ARRAY_SIZE(ctx->cert->pub->mpi)) {
+		pr_err("Too many public keys in certificate\n");
+		return -EBADMSG;
+	}
+
+	mpi = mpi_read_raw_data(value, vlen);
+	if (!mpi)
+		return -ENOMEM;
+
+	ctx->cert->pub->mpi[ctx->nr_mpi++] = mpi;
+	return 0;
+}
+
+/*
+ * Process certificate extensions that are used to qualify the certificate.
+ */
+int x509_process_extension(void *context, size_t hdrlen,
+			   unsigned char tag,
+			   const void *value, size_t vlen)
+{
+	struct x509_parse_context *ctx = context;
+	const unsigned char *v = value;
+	char *f;
+	int i;
+
+	pr_debug("Extension: %u\n", ctx->last_oid);
+
+	if (ctx->last_oid == OID_subjectKeyIdentifier) {
+		/* Get hold of the key fingerprint */
+		if (vlen < 3)
+			return -EBADMSG;
+		if (v[0] != ASN1_OTS || v[1] != vlen - 2)
+			return -EBADMSG;
+		v += 2;
+		vlen -= 2;
+
+		f = kmalloc(vlen * 2 + 1, GFP_KERNEL);
+		if (!f)
+			return -ENOMEM;
+		for (i = 0; i < vlen; i++)
+			sprintf(f + i * 2, "%02x", v[i]);
+		pr_debug("fingerprint %s\n", f);
+		ctx->cert->fingerprint = f;
+
+		ctx->cert->pub->key_id_size = i =
+			min(vlen, sizeof(ctx->cert->pub->key_id));
+		memcpy(ctx->cert->pub->key_id, v + vlen - i, i);
+		return 0;
+	}
+
+	if (ctx->last_oid == OID_authorityKeyIdentifier) {
+		/* Get hold of the CA key fingerprint */
+		if (vlen < 5)
+			return -EBADMSG;
+		if (v[0] != (ASN1_SEQ | (ASN1_CONS << 5)) ||
+		    v[1] != vlen - 2 ||
+		    v[2] != (ASN1_CONT << 6) ||
+		    v[3] != vlen - 4)
+			return -EBADMSG;
+		v += 4;
+		vlen -= 4;
+
+		f = kmalloc(vlen * 2 + 1, GFP_KERNEL);
+		if (!f)
+			return -ENOMEM;
+		for (i = 0; i < vlen; i++)
+			sprintf(f + i * 2, "%02x", v[i]);
+		pr_debug("authority   %s\n", f);
+		ctx->cert->authority = f;
+		return 0;
+	}
+
+	return 0;
+}
+
+/*
+ * Record the certificate serial number.
+ */
+int x509_note_serial(void *context, size_t hdrlen,
+		     unsigned char tag,
+		     const void *value, size_t vlen)
+{
+	struct x509_parse_context *ctx = context;
+	char *serial;
+
+	for (; vlen > 0; vlen--, value++)
+		if (*(const u8 *)value != 0)
+			break;
+
+	serial = kmalloc(vlen * 2 + 1, GFP_KERNEL);
+	if (!serial)
+		return -ENOMEM;
+	ctx->cert->serial = serial;
+
+	/* Note: this limits the field width to a maximum of 64 */
+	sprintf(serial, "%*phN", (int)vlen, value);
+
+	pr_devel("Serial: %s\n", serial);
+	return 0;
+}
+
+/*
+ * Record a certificate time.
+ */
+static int x509_note_time(time_t *_time,  size_t hdrlen,
+			  unsigned char tag,
+			  const unsigned char *value, size_t vlen)
+{
+	unsigned YY, MM, DD, hh, mm, ss;
+	const unsigned char *p = value;
+
+#define dec2bin(X) ((X) - '0')
+#define DD2bin(P) ({ unsigned x = dec2bin(P[0]) * 10 + dec2bin(P[1]); P += 2; x; })
+
+	if (tag == ASN1_UNITIM) {
+		/* UTCTime: YYMMDDHHMMSSZ */
+		if (vlen != 13)
+			goto unsupported_time;
+		YY = DD2bin(p);
+		if (YY > 50)
+			YY += 1900;
+		else
+			YY += 2000;
+	} else if (tag == ASN1_GENTIM) {
+		/* GenTime: YYYYMMDDHHMMSSZ */
+		if (vlen != 15)
+			goto unsupported_time;
+		YY = DD2bin(p) * 100 + DD2bin(p);
+	} else {
+		goto unsupported_time;
+	}
+
+	MM = DD2bin(p);
+	DD = DD2bin(p);
+	hh = DD2bin(p);
+	mm = DD2bin(p);
+	ss = DD2bin(p);
+
+	if (*p != 'Z')
+		goto unsupported_time;
+
+	*_time = mktime(YY, MM, DD, hh, mm, ss);
+	return 0;
+
+unsupported_time:
+	pr_warn("X.509: Got unsupported time [tag %02x]: '%*.*s'\n",
+		tag, (int)vlen, (int)vlen, value);
+	return -EBADMSG;
+}
+
+int x509_note_not_before(void *context, size_t hdrlen,
+			 unsigned char tag,
+			 const void *value, size_t vlen)
+{
+	struct x509_parse_context *ctx = context;
+	return x509_note_time(&ctx->cert->valid_from, hdrlen, tag, value, vlen);
+}
+
+int x509_note_not_after(void *context, size_t hdrlen,
+			unsigned char tag,
+			const void *value, size_t vlen)
+{
+	struct x509_parse_context *ctx = context;
+	return x509_note_time(&ctx->cert->valid_to, hdrlen, tag, value, vlen);
+}
diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
new file mode 100644
index 0000000..b38789a
--- /dev/null
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -0,0 +1,37 @@
+/* X.509 certificate parser internal definitions
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
+struct x509_certificate {
+	struct x509_certificate *next;
+	struct public_key *pub;			/* Public key details */
+	char		*serial;		/* Certificate serial number */
+	char		*issuer;		/* Name of certificate issuer */
+	char		*subject;		/* Name of certificate subject */
+	char		*fingerprint;		/* Key fingerprint as hex */
+	char		*authority;		/* Authority key fingerprint as hex */
+	time_t		valid_from;
+	time_t		valid_to;
+	enum pkey_algo	pkey_algo : 8;		/* Public key algorithm */
+	enum pkey_algo	sig_pkey_algo : 8;	/* Signature public key algorithm */
+	enum pkey_hash_algo sig_hash_algo : 8;	/* Signature hash algorithm */
+	const void	*tbs;			/* Signed data */
+	size_t		tbs_size;		/* Size of signed data */
+	const void	*sig;			/* Signature data */
+	size_t		sig_size;		/* Size of sigature */
+};
+
+/*
+ * x509_cert_parser.c
+ */
+extern void x509_free_certificate(struct x509_certificate *cert);
+extern struct x509_certificate *x509_cert_parse(const void *data, size_t datalen);
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
new file mode 100644
index 0000000..a44c22c
--- /dev/null
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -0,0 +1,206 @@
+/* Instantiate a public key crypto key from an X.509 Certificate
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
+#define pr_fmt(fmt) "X.509: "fmt
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/mpi.h>
+#include <linux/asn1_decoder.h>
+#include <keys/asymmetric-subtype.h>
+#include <keys/asymmetric-parser.h>
+#include <crypto/hash.h>
+#include "asymmetric_keys.h"
+#include "public_key.h"
+#include "x509_parser.h"
+
+static const
+struct public_key_algorithm *x509_public_key_algorithms[PKEY_ALGO__LAST] = {
+	[PKEY_ALGO_DSA]		= NULL,
+#if defined(CONFIG_PUBLIC_KEY_ALGO_RSA) || \
+	defined(CONFIG_PUBLIC_KEY_ALGO_RSA_MODULE)
+	[PKEY_ALGO_RSA]		= &RSA_public_key_algorithm,
+#endif
+};
+
+/*
+ * Check the signature on a certificate using the provided public key
+ */
+static int x509_check_signature(const struct public_key *pub,
+				const struct x509_certificate *cert)
+{
+	struct public_key_signature *sig;
+	struct crypto_shash *tfm;
+	struct shash_desc *desc;
+	size_t digest_size, desc_size;
+	int ret;
+
+	pr_devel("==>%s()\n", __func__);
+	
+	/* Allocate the hashing algorithm we're going to need and find out how
+	 * big the hash operational data will be.
+	 */
+	tfm = crypto_alloc_shash(pkey_hash_algo[cert->sig_hash_algo], 0, 0);
+	if (IS_ERR(tfm))
+		return (PTR_ERR(tfm) == -ENOENT) ? -ENOPKG : PTR_ERR(tfm);
+
+	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
+	digest_size = crypto_shash_digestsize(tfm);
+
+	/* We allocate the hash operational data storage on the end of our
+	 * context data.
+	 */
+	ret = -ENOMEM;
+	sig = kzalloc(sizeof(*sig) + desc_size + digest_size, GFP_KERNEL);
+	if (!sig)
+		goto error_no_sig;
+
+	sig->pkey_hash_algo	= cert->sig_hash_algo;
+	sig->digest		= (u8 *)sig + sizeof(*sig) + desc_size;
+	sig->digest_size	= digest_size;
+
+	desc = (void *)sig + sizeof(*sig);
+	desc->tfm	= tfm;
+	desc->flags	= CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	ret = crypto_shash_init(desc);
+	if (ret < 0)
+		goto error;
+
+	ret = -ENOMEM;
+	sig->rsa.s = mpi_read_raw_data(cert->sig, cert->sig_size);
+	if (!sig->rsa.s)
+		goto error;
+
+	ret = crypto_shash_update(desc, cert->tbs, cert->tbs_size);
+	if (ret < 0)
+		goto error_mpi;
+
+	sig->digest[0] = 0xa5;
+	sig->digest[1] = 0x5a;
+
+	ret = crypto_shash_final(desc, sig->digest);
+	if (ret < 0)
+		goto error_mpi;
+
+	ret = pub->algo->verify_signature(pub, sig);
+
+	pr_debug("Cert Verification: %d\n", ret);
+
+error_mpi:
+	mpi_free(sig->rsa.s);
+error:
+	kfree(sig);
+error_no_sig:
+	crypto_free_shash(tfm);
+
+	pr_devel("<==%s() = %d\n", __func__, ret);
+	return ret;
+}
+
+/*
+ * Attempt to parse a data blob for a key as an X509 certificate.
+ */
+static int x509_key_preparse(struct key_preparsed_payload *prep)
+{
+	struct x509_certificate *cert;
+	time_t now;
+	size_t srlen, sulen;
+	char *desc = NULL;
+	int ret;
+
+	cert = x509_cert_parse(prep->data, prep->datalen);
+	if (IS_ERR(cert))
+		return PTR_ERR(cert);
+
+	pr_devel("Cert Issuer: %s\n", cert->issuer);
+	pr_devel("Cert Subject: %s\n", cert->subject);
+	pr_devel("Cert Key Algo: %s\n", pkey_algo[cert->pkey_algo]);
+	pr_devel("Cert Valid: %lu - %lu\n", cert->valid_from, cert->valid_to);
+	pr_devel("Cert Signature: %s + %s\n",
+		 pkey_algo[cert->sig_pkey_algo],
+		 pkey_hash_algo[cert->sig_hash_algo]);
+
+	now = CURRENT_TIME.tv_sec;
+	if (now < cert->valid_from) {
+		pr_warn("Cert %s is not yet valid\n", cert->fingerprint);
+		ret = -EKEYREJECTED;
+		goto error_free_cert;
+	}
+	if (now >= cert->valid_to) {
+		pr_warn("Cert %s has expired\n", cert->fingerprint);
+		ret = -EKEYEXPIRED;
+		goto error_free_cert;
+	}
+
+	cert->pub->algo = x509_public_key_algorithms[cert->pkey_algo];
+	cert->pub->id_type = PKEY_ID_X509;
+
+	/* Check the signature on the key */
+	if (strcmp(cert->fingerprint, cert->authority) == 0) {
+		ret = x509_check_signature(cert->pub, cert);
+		if (ret < 0)
+			goto error_free_cert;
+	}
+
+	/* Propose a description */
+	srlen = strlen(cert->serial);
+	sulen = strlen(cert->subject);
+	ret = -ENOMEM;
+	desc = kmalloc(srlen + sulen + 2, GFP_KERNEL);
+	if (!desc)
+		goto error_free_cert;
+	memcpy(desc, cert->serial, srlen);
+	desc[srlen] = ':';
+	memcpy(desc + srlen + 1, cert->subject, sulen);
+	desc[srlen + sulen + 1] = 0;
+
+	/* We're pinning the module by being linked against it */
+	__module_get(public_key_subtype.owner);
+	prep->type_data[0] = &public_key_subtype;
+	prep->type_data[1] = cert->fingerprint;
+	prep->payload = cert->pub;
+	prep->description = desc;
+	prep->quotalen = 100;
+
+	/* We've finished with the certificate */
+	cert->pub = NULL;
+	cert->fingerprint = NULL;
+	desc = NULL;
+	ret = 0;
+
+error_free_cert:
+	x509_free_certificate(cert);
+	return ret;
+}
+
+static struct asymmetric_key_parser x509_key_parser = {
+	.owner	= THIS_MODULE,
+	.name	= "x509",
+	.parse	= x509_key_preparse,
+};
+
+/*
+ * Module stuff
+ */
+static int __init x509_key_init(void)
+{
+	return register_asymmetric_key_parser(&x509_key_parser);
+}
+
+static void __exit x509_key_exit(void)
+{
+	unregister_asymmetric_key_parser(&x509_key_parser);
+}
+
+module_init(x509_key_init);
+module_exit(x509_key_exit);
diff --git a/crypto/asymmetric_keys/x509_rsakey.asn1 b/crypto/asymmetric_keys/x509_rsakey.asn1
new file mode 100644
index 0000000..4ec7cc6
--- /dev/null
+++ b/crypto/asymmetric_keys/x509_rsakey.asn1
@@ -0,0 +1,4 @@
+RSAPublicKey ::= SEQUENCE {
+	modulus			INTEGER ({ rsa_extract_mpi }),	-- n
+	publicExponent		INTEGER ({ rsa_extract_mpi })	-- e
+	}

