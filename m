Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965592Ab2J3TUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:20:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075Ab2J3TUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:20:19 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 04/23] KEYS: Split public_key_verify_signature() and make
 available
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, pjones@redhat.com, jwboyer@redhat.com, mjg@redhat.com,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        keescook@chromium.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 30 Oct 2012 19:20:02 +0000
Message-ID: <20121030192002.11000.7722.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
References: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify public_key_verify_signature() so that it now takes a public_key struct
rather than a key struct and supply a wrapper that takes a key struct.  The
wrapper is then used by the asymmetric key subtype and the modified function is
used by X.509 self-signature checking and can be used by PKCS#7 also.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/public_key.c      |   38 ++++++++++++++++++++++++------
 crypto/asymmetric_keys/public_key.h      |    6 +++++
 crypto/asymmetric_keys/x509_public_key.c |    2 +-
 3 files changed, 37 insertions(+), 9 deletions(-)


diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 796ce08..566cc50 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -86,21 +86,43 @@ EXPORT_SYMBOL_GPL(public_key_destroy);
 /*
  * Verify a signature using a public key.
  */
-static int public_key_verify_signature(const struct key *key,
-				       const struct public_key_signature *sig)
+int public_key_verify_signature(const struct public_key *pk,
+				const struct public_key_signature *sig)
 {
-	const struct public_key *pk = key->payload.data;
+	const struct public_key_algorithm *algo;
+
+	BUG_ON(!pk);
+	BUG_ON(!pk->mpi[0]);
+	BUG_ON(!pk->mpi[1]);
+	BUG_ON(!sig);
+	BUG_ON(!sig->digest);
+	BUG_ON(!sig->mpi[0]);
+
+	algo = pk->algo;
+	if (!algo) {
+		algo = pkey_algo[pk->pkey_algo];
+		if (!algo)
+			return -ENOPKG;
+	}
 
-	if (!pk->algo->verify_signature)
+	if (!algo->verify_signature)
 		return -ENOTSUPP;
 
-	if (sig->nr_mpi != pk->algo->n_sig_mpi) {
+	if (sig->nr_mpi != algo->n_sig_mpi) {
 		pr_debug("Signature has %u MPI not %u\n",
-			 sig->nr_mpi, pk->algo->n_sig_mpi);
+			 sig->nr_mpi, algo->n_sig_mpi);
 		return -EINVAL;
 	}
 
-	return pk->algo->verify_signature(pk, sig);
+	return algo->verify_signature(pk, sig);
+}
+EXPORT_SYMBOL_GPL(public_key_verify_signature);
+
+static int public_key_verify_signature_2(const struct key *key,
+					 const struct public_key_signature *sig)
+{
+	const struct public_key *pk = key->payload.data;
+	return public_key_verify_signature(pk, sig);
 }
 
 /*
@@ -111,6 +133,6 @@ struct asymmetric_key_subtype public_key_subtype = {
 	.name			= "public_key",
 	.describe		= public_key_describe,
 	.destroy		= public_key_destroy,
-	.verify_signature	= public_key_verify_signature,
+	.verify_signature	= public_key_verify_signature_2,
 };
 EXPORT_SYMBOL_GPL(public_key_subtype);
diff --git a/crypto/asymmetric_keys/public_key.h b/crypto/asymmetric_keys/public_key.h
index 5e5e356..5c37a22 100644
--- a/crypto/asymmetric_keys/public_key.h
+++ b/crypto/asymmetric_keys/public_key.h
@@ -28,3 +28,9 @@ struct public_key_algorithm {
 };
 
 extern const struct public_key_algorithm RSA_public_key_algorithm;
+
+/*
+ * public_key.c
+ */
+extern int public_key_verify_signature(const struct public_key *pk,
+				       const struct public_key_signature *sig);
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index fac574c..8cb2f70 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -76,7 +76,7 @@ static int x509_check_signature(const struct public_key *pub,
 	if (ret < 0)
 		goto error_mpi;
 
-	ret = pub->algo->verify_signature(pub, sig);
+	ret = public_key_verify_signature(pub, sig);
 
 	pr_debug("Cert Verification: %d\n", ret);
 

