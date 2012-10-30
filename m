Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934307Ab2J3TVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:21:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758415Ab2J3TU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:20:57 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 09/23] X.509: Handle certificates that lack an
 authorityKeyIdentifier field
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, pjones@redhat.com, jwboyer@redhat.com, mjg@redhat.com,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        keescook@chromium.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 30 Oct 2012 19:20:49 +0000
Message-ID: <20121030192049.11000.74865.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
References: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle certificates that lack an authorityKeyIdentifier field by assuming
they're self-signed and checking their signatures against themselves.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/x509_public_key.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)


diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index b7c81d8..3a87512 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -132,8 +132,8 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 		 pkey_algo_name[cert->sig.pkey_algo],
 		 pkey_hash_algo_name[cert->sig.pkey_hash_algo]);
 
-	if (!cert->fingerprint || !cert->authority) {
-		pr_warn("Cert for '%s' must have SubjKeyId and AuthKeyId extensions\n",
+	if (!cert->fingerprint) {
+		pr_warn("Cert for '%s' must have a SubjKeyId extension\n",
 			cert->subject);
 		ret = -EKEYREJECTED;
 		goto error_free_cert;
@@ -179,8 +179,9 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 	cert->pub->algo = pkey_algo[cert->pub->pkey_algo];
 	cert->pub->id_type = PKEY_ID_X509;
 
-	/* Check the signature on the key */
-	if (strcmp(cert->fingerprint, cert->authority) == 0) {
+	/* Check the signature on the key if it appears to be self-signed */
+	if (!cert->authority ||
+	    strcmp(cert->fingerprint, cert->authority) == 0) {
 		ret = x509_check_signature(cert->pub, cert);
 		if (ret < 0)
 			goto error_free_cert;

