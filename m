Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab2J3TT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:19:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754801Ab2J3TTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:19:54 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/23] KEYS: Move the algorithm pointer array from x509 to
 public_key.c
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, pjones@redhat.com, jwboyer@redhat.com, mjg@redhat.com,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        keescook@chromium.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 30 Oct 2012 19:19:45 +0000
Message-ID: <20121030191945.11000.42288.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
References: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the public-key algorithm pointer array from x509_public_key.c to
public_key.c as it isn't X.509 specific.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/public_key.c      |    8 ++++++++
 crypto/asymmetric_keys/x509_public_key.c |   11 +----------
 include/crypto/public_key.h              |    1 +
 3 files changed, 10 insertions(+), 10 deletions(-)


diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index b313df1..796ce08 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -28,6 +28,14 @@ const char *const pkey_algo_name[PKEY_ALGO__LAST] = {
 };
 EXPORT_SYMBOL_GPL(pkey_algo_name);
 
+const struct public_key_algorithm *pkey_algo[PKEY_ALGO__LAST] = {
+#if defined(CONFIG_PUBLIC_KEY_ALGO_RSA) || \
+	defined(CONFIG_PUBLIC_KEY_ALGO_RSA_MODULE)
+	[PKEY_ALGO_RSA]		= &RSA_public_key_algorithm,
+#endif
+};
+EXPORT_SYMBOL_GPL(pkey_algo);
+
 const char *const pkey_hash_algo_name[PKEY_HASH__LAST] = {
 	[PKEY_HASH_MD4]		= "md4",
 	[PKEY_HASH_MD5]		= "md5",
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index afbbc36..fe38628 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -23,15 +23,6 @@
 #include "public_key.h"
 #include "x509_parser.h"
 
-static const
-struct public_key_algorithm *x509_public_key_algorithms[PKEY_ALGO__LAST] = {
-	[PKEY_ALGO_DSA]		= NULL,
-#if defined(CONFIG_PUBLIC_KEY_ALGO_RSA) || \
-	defined(CONFIG_PUBLIC_KEY_ALGO_RSA_MODULE)
-	[PKEY_ALGO_RSA]		= &RSA_public_key_algorithm,
-#endif
-};
-
 /*
  * Check the signature on a certificate using the provided public key
  */
@@ -174,7 +165,7 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 		goto error_free_cert;
 	}
 
-	cert->pub->algo = x509_public_key_algorithms[cert->pkey_algo];
+	cert->pub->algo = pkey_algo[cert->pkey_algo];
 	cert->pub->id_type = PKEY_ID_X509;
 
 	/* Check the signature on the key */
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index 619d570..46bde25 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -23,6 +23,7 @@ enum pkey_algo {
 };
 
 extern const char *const pkey_algo_name[PKEY_ALGO__LAST];
+extern const struct public_key_algorithm *pkey_algo[PKEY_ALGO__LAST];
 
 enum pkey_hash_algo {
 	PKEY_HASH_MD4,

