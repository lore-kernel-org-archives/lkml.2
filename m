Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934332Ab2J3TWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:22:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758308Ab2J3TWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:22:15 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/23] KEYS: Store public key algo ID in public_key struct
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, pjones@redhat.com, jwboyer@redhat.com, mjg@redhat.com,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        keescook@chromium.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 30 Oct 2012 19:19:54 +0000
Message-ID: <20121030191954.11000.83264.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
References: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Store public key algo ID in public_key struct for reference purposes.  This
allows it to be removed from the x509_certificate struct and used to find a
default in public_key_verify_signature().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/x509_cert_parser.c |    5 +++--
 crypto/asymmetric_keys/x509_parser.h      |    1 -
 crypto/asymmetric_keys/x509_public_key.c  |    4 ++--
 include/crypto/public_key.h               |    1 +
 4 files changed, 6 insertions(+), 5 deletions(-)


diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 7fabc4c..a583930 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -343,8 +343,9 @@ int x509_extract_key_data(void *context, size_t hdrlen,
 	if (ctx->last_oid != OID_rsaEncryption)
 		return -ENOPKG;
 
-	/* There seems to be an extraneous 0 byte on the front of the data */
-	ctx->cert->pkey_algo = PKEY_ALGO_RSA;
+	ctx->cert->pub->pkey_algo = PKEY_ALGO_RSA;
+
+	/* Discard the BIT STRING metadata */
 	ctx->key = value + 1;
 	ctx->key_size = vlen - 1;
 	return 0;
diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index f86dc5f..e583ad0 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -20,7 +20,6 @@ struct x509_certificate {
 	char		*authority;		/* Authority key fingerprint as hex */
 	struct tm	valid_from;
 	struct tm	valid_to;
-	enum pkey_algo	pkey_algo : 8;		/* Public key algorithm */
 	enum pkey_algo	sig_pkey_algo : 8;	/* Signature public key algorithm */
 	enum pkey_hash_algo sig_hash_algo : 8;	/* Signature hash algorithm */
 	const void	*tbs;			/* Signed data */
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index fe38628..fac574c 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -108,7 +108,7 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 
 	pr_devel("Cert Issuer: %s\n", cert->issuer);
 	pr_devel("Cert Subject: %s\n", cert->subject);
-	pr_devel("Cert Key Algo: %s\n", pkey_algo_name[cert->pkey_algo]);
+	pr_devel("Cert Key Algo: %s\n", pkey_algo_name[cert->pub->pkey_algo]);
 	pr_devel("Cert Valid From: %04ld-%02d-%02d %02d:%02d:%02d\n",
 		 cert->valid_from.tm_year + 1900, cert->valid_from.tm_mon + 1,
 		 cert->valid_from.tm_mday, cert->valid_from.tm_hour,
@@ -165,7 +165,7 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 		goto error_free_cert;
 	}
 
-	cert->pub->algo = pkey_algo[cert->pkey_algo];
+	cert->pub->algo = pkey_algo[cert->pub->pkey_algo];
 	cert->pub->id_type = PKEY_ID_X509;
 
 	/* Check the signature on the key */
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index 46bde25..05778df 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -60,6 +60,7 @@ struct public_key {
 #define PKEY_CAN_DECRYPT	0x02
 #define PKEY_CAN_SIGN		0x04
 #define PKEY_CAN_VERIFY		0x08
+	enum pkey_algo pkey_algo : 8;
 	enum pkey_id_type id_type : 8;
 	union {
 		MPI	mpi[5];

