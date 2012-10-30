Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488Ab2J3TVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:21:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244Ab2J3TVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:21:32 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 13/23] PKCS#7: Find the right key in the PKCS#7 key list and
 verify the signature
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, pjones@redhat.com, jwboyer@redhat.com, mjg@redhat.com,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        keescook@chromium.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 30 Oct 2012 19:21:23 +0000
Message-ID: <20121030192123.11000.64452.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
References: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Find the appropriate key in the PKCS#7 key list and verify the signature with
it.  There may be several keys in there forming a chain.  Any link in that
chain or the root of that chain may be in our keyrings.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/pkcs7_verify.c |   61 +++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)


diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index 7d7ac8a..614f2b6 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -114,6 +114,53 @@ error_no_desc:
 }
 
 /*
+ * Find the key (X.509 certificate) to use to verify a PKCS#7 message.  PKCS#7
+ * uses the issuer's name and the issuing certificate serial number for
+ * matching purposes.  These must match the certificate issuer's name (not
+ * subject's name) and the certificate serial number [RFC 2315 6.7].
+ */
+static int pkcs7_find_key(struct pkcs7_message *pkcs7)
+{
+	struct x509_certificate *x509;
+
+	kenter("%u,%u", pkcs7->raw_serial_size, pkcs7->raw_issuer_size);
+
+	for (x509 = pkcs7->certs; x509; x509 = x509->next) {
+		pr_devel("- x509 %u,%u\n",
+			 x509->raw_serial_size, x509->raw_issuer_size);
+
+		/* I'm _assuming_ that the generator of the PKCS#7 message will
+		 * encode the fields from the X.509 cert in the same way in the
+		 * PKCS#7 message - but I can't be 100% sure of that.  It's
+		 * possible this will need element-by-element comparison.
+		 */
+		if (x509->raw_serial_size != pkcs7->raw_serial_size ||
+		    memcmp(x509->raw_serial, pkcs7->raw_serial,
+			   pkcs7->raw_serial_size) != 0)
+			continue;
+		pr_devel("Found cert serial match\n");
+
+		if (x509->raw_issuer_size != pkcs7->raw_issuer_size ||
+		    memcmp(x509->raw_issuer, pkcs7->raw_issuer,
+			   pkcs7->raw_issuer_size) != 0) {
+			pr_warn("X.509 subject and PKCS#7 issuer don't match\n");
+			continue;
+		}
+
+		if (x509->pub->pkey_algo != pkcs7->sig.pkey_algo) {
+			pr_warn("X.509 algo and PKCS#7 sig algo don't match\n");
+			continue;
+		}
+
+		pkcs7->signer = x509;
+		return 0;
+	}
+	pr_warn("Issuing X.509 cert not found (#%*ph)\n",
+		pkcs7->raw_serial_size, pkcs7->raw_serial);
+	return -ENOKEY;
+}
+
+/*
  * Verify a PKCS#7 message
  */
 int pkcs7_verify(struct pkcs7_message *pkcs7)
@@ -125,6 +172,20 @@ int pkcs7_verify(struct pkcs7_message *pkcs7)
 	if (ret < 0)
 		return ret;
 
+	/* Find the key for the message signature */
+	ret = pkcs7_find_key(pkcs7);
+	if (ret < 0)
+		return ret;
+
+	pr_devel("Found X.509 cert\n");
+
+	/* Verify the PKCS#7 binary against the key */
+	ret = public_key_verify_signature(pkcs7->signer->pub, &pkcs7->sig);
+	if (ret < 0)
+		return ret;
+
+	pr_devel("Verified signature\n");
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(pkcs7_verify);

