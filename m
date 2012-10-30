Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965790Ab2J3TWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:22:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965682Ab2J3TWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:22:48 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 22/23] PEFILE: Load the contained key if we consider the
 container to be validly signed
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, pjones@redhat.com, jwboyer@redhat.com, mjg@redhat.com,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        keescook@chromium.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 30 Oct 2012 19:22:39 +0000
Message-ID: <20121030192239.11000.98336.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
References: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Load the key contained in the PE binary if the signature on the container can
be verified by following the chain of X.509 certificates in the PKCS#7 message
to a key that we already trust.  Typically, the trusted key will be acquired
from a source outside of the kernel, such as the UEFI database.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/pefile_parser.c   |   11 ++++++++++-
 crypto/asymmetric_keys/x509_parser.h     |    3 +++
 crypto/asymmetric_keys/x509_public_key.c |    2 +-
 3 files changed, 14 insertions(+), 2 deletions(-)


diff --git a/crypto/asymmetric_keys/pefile_parser.c b/crypto/asymmetric_keys/pefile_parser.c
index 1ab1890..28be7d3 100644
--- a/crypto/asymmetric_keys/pefile_parser.c
+++ b/crypto/asymmetric_keys/pefile_parser.c
@@ -389,6 +389,8 @@ static int pefile_key_preparse(struct key_preparsed_payload *prep)
 {
 	struct pkcs7_message *pkcs7;
 	struct pefile_context ctx;
+	const void *saved_data;
+	size_t saved_datalen;
 	int ret;
 
 	kenter("");
@@ -434,7 +436,14 @@ static int pefile_key_preparse(struct key_preparsed_payload *prep)
 	if (ret < 0)
 		goto error;
 
-	ret = -ENOANO; // Not yet complete
+	/* We can now try to load the key */
+	saved_data = prep->data;
+	saved_datalen = prep->datalen;
+	prep->data += ctx.keylist_offset;
+	prep->datalen = ctx.keylist_len;
+	ret = x509_key_preparse(prep);
+	prep->data = saved_data;
+	prep->datalen = saved_datalen;
 
 error:
 	pkcs7_free_message(ctx.pkcs7);
diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index 5e35fba..65452c4 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -12,6 +12,8 @@
 #include <linux/time.h>
 #include <crypto/public_key.h>
 
+struct key_preparsed_payload;
+
 struct x509_certificate {
 	struct x509_certificate *next;
 	const struct x509_certificate *signer;	/* Certificate that signed this one */
@@ -47,3 +49,4 @@ extern struct x509_certificate *x509_cert_parse(const void *data, size_t datalen
 extern int x509_get_sig_params(struct x509_certificate *cert);
 extern int x509_check_signature(const struct public_key *pub,
 				struct x509_certificate *cert);
+extern int x509_key_preparse(struct key_preparsed_payload *prep);
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 3a87512..b37f2a6 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -105,7 +105,7 @@ EXPORT_SYMBOL_GPL(x509_check_signature);
 /*
  * Attempt to parse a data blob for a key as an X509 certificate.
  */
-static int x509_key_preparse(struct key_preparsed_payload *prep)
+int x509_key_preparse(struct key_preparsed_payload *prep)
 {
 	struct x509_certificate *cert;
 	struct tm now;

