Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965689Ab2J3TVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:21:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934309Ab2J3TVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:21:01 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 07/23] X.509: Add bits needed for PKCS#7
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, pjones@redhat.com, jwboyer@redhat.com, mjg@redhat.com,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        keescook@chromium.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 30 Oct 2012 19:20:32 +0000
Message-ID: <20121030192032.11000.80704.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
References: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PKCS#7 validation requires access to the serial number and the raw names in an
X.509 certificate.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/x509.asn1          |    2 +-
 crypto/asymmetric_keys/x509_cert_parser.c |   17 +++++++++++++++++
 crypto/asymmetric_keys/x509_parser.h      |   10 ++++++++--
 3 files changed, 26 insertions(+), 3 deletions(-)


diff --git a/crypto/asymmetric_keys/x509.asn1 b/crypto/asymmetric_keys/x509.asn1
index bf32b3d..aae0cde 100644
--- a/crypto/asymmetric_keys/x509.asn1
+++ b/crypto/asymmetric_keys/x509.asn1
@@ -6,7 +6,7 @@ Certificate ::= SEQUENCE {
 
 TBSCertificate ::= SEQUENCE {
 	version           [ 0 ]	Version DEFAULT,
-	serialNumber		CertificateSerialNumber,
+	serialNumber		CertificateSerialNumber ({ x509_note_serial }),
 	signature		AlgorithmIdentifier ({ x509_note_pkey_algo }),
 	issuer			Name ({ x509_note_issuer }),
 	validity		Validity,
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index a583930..08bebf1 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -209,6 +209,19 @@ int x509_note_signature(void *context, size_t hdrlen,
 }
 
 /*
+ * Note the certificate serial number
+ */
+int x509_note_serial(void *context, size_t hdrlen,
+		     unsigned char tag,
+		     const void *value, size_t vlen)
+{
+	struct x509_parse_context *ctx = context;
+	ctx->cert->raw_serial = value;
+	ctx->cert->raw_serial_size = vlen;
+	return 0;
+}
+
+/*
  * Note some of the name segments from which we'll fabricate a name.
  */
 int x509_extract_name_segment(void *context, size_t hdrlen,
@@ -320,6 +333,8 @@ int x509_note_issuer(void *context, size_t hdrlen,
 		     const void *value, size_t vlen)
 {
 	struct x509_parse_context *ctx = context;
+	ctx->cert->raw_issuer = value;
+	ctx->cert->raw_issuer_size = vlen;
 	return x509_fabricate_name(ctx, hdrlen, tag, &ctx->cert->issuer, vlen);
 }
 
@@ -328,6 +343,8 @@ int x509_note_subject(void *context, size_t hdrlen,
 		      const void *value, size_t vlen)
 {
 	struct x509_parse_context *ctx = context;
+	ctx->cert->raw_subject = value;
+	ctx->cert->raw_subject_size = vlen;
 	return x509_fabricate_name(ctx, hdrlen, tag, &ctx->cert->subject, vlen);
 }
 
diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index 2d01182..a6ce46f 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -24,9 +24,15 @@ struct x509_certificate {
 	enum pkey_algo	sig_pkey_algo : 8;	/* Signature public key algorithm */
 	enum pkey_hash_algo sig_hash_algo : 8;	/* Signature hash algorithm */
 	const void	*tbs;			/* Signed data */
-	size_t		tbs_size;		/* Size of signed data */
+	unsigned	tbs_size;		/* Size of signed data */
+	unsigned	sig_size;		/* Size of sigature */
 	const void	*sig;			/* Signature data */
-	size_t		sig_size;		/* Size of sigature */
+	const void	*raw_serial;		/* Raw serial number in ASN.1 */
+	unsigned	raw_serial_size;
+	unsigned	raw_issuer_size;
+	const void	*raw_issuer;		/* Raw issuer name in ASN.1 */
+	const void	*raw_subject;		/* Raw subject name in ASN.1 */
+	unsigned	raw_subject_size;
 };
 
 /*

