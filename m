Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934287Ab2J3TWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:22:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933041Ab2J3TWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:22:00 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 14/23] PKCS#7: Verify internal certificate chain
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, pjones@redhat.com, jwboyer@redhat.com, mjg@redhat.com,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        keescook@chromium.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 30 Oct 2012 19:21:31 +0000
Message-ID: <20121030192131.11000.1482.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
References: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Verify certificate chain in the X.509 certificates contained within the PKCS#7
message as far as possible.  If any signature that we should be able to verify
fails, we reject the whole lot.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/pkcs7_verify.c |   67 +++++++++++++++++++++++++++++++++
 crypto/asymmetric_keys/x509_parser.h  |    1 
 2 files changed, 67 insertions(+), 1 deletion(-)


diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index 614f2b6..2d729a6 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -161,6 +161,70 @@ static int pkcs7_find_key(struct pkcs7_message *pkcs7)
 }
 
 /*
+ * Verify the internal certificate chain as best we can.
+ */
+static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7)
+{
+	struct x509_certificate *x509 = pkcs7->signer, *p;
+	int ret;
+
+	kenter("");
+
+	for (;;) {
+		pr_debug("verify %s: %s\n", x509->subject, x509->fingerprint);
+		ret = x509_get_sig_params(x509);
+		if (ret < 0)
+			return ret;
+
+		if (x509->issuer)
+			pr_debug("- issuer %s\n", x509->issuer);
+		if (x509->authority)
+			pr_debug("- authkeyid %s\n", x509->authority);
+
+		if (!x509->authority ||
+		    (x509->subject &&
+		     strcmp(x509->subject, x509->authority) == 0)) {
+			/* If there's no authority certificate specified, then
+			 * the certificate must be self-signed and is the root
+			 * of the chain.  Likewise if the cert is its own
+			 * authority.
+			 */
+			pr_debug("- no auth?\n");
+			if (x509->raw_subject_size != x509->raw_issuer_size ||
+			    memcmp(x509->raw_subject, x509->raw_issuer,
+				   x509->raw_issuer_size) != 0)
+				return 0;
+
+			ret = x509_check_signature(x509->pub, x509);
+			if (ret < 0)
+				return ret;
+			x509->signer = x509;
+			pr_debug("- self-signed\n");
+			return 0;
+		}
+
+		for (p = pkcs7->certs; p; p = p->next)
+			if (!p->signer &&
+			    p->raw_subject_size == x509->raw_issuer_size &&
+			    strcmp(p->fingerprint, x509->authority) == 0 &&
+			    memcmp(p->raw_subject, x509->raw_issuer,
+				   x509->raw_issuer_size) == 0)
+				goto found_issuer;
+		pr_debug("- top\n");
+		return 0;
+
+	found_issuer:
+		pr_debug("- issuer %s\n", p->subject);
+		ret = x509_check_signature(p->pub, x509);
+		if (ret < 0)
+			return ret;
+		x509->signer = p;
+		x509 = p;
+		might_sleep();
+	}
+}
+
+/*
  * Verify a PKCS#7 message
  */
 int pkcs7_verify(struct pkcs7_message *pkcs7)
@@ -186,6 +250,7 @@ int pkcs7_verify(struct pkcs7_message *pkcs7)
 
 	pr_devel("Verified signature\n");
 
-	return 0;
+	/* Verify the internal certificate chain */
+	return pkcs7_verify_sig_chain(pkcs7);
 }
 EXPORT_SYMBOL_GPL(pkcs7_verify);
diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index 6b1d877..5e35fba 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -14,6 +14,7 @@
 
 struct x509_certificate {
 	struct x509_certificate *next;
+	const struct x509_certificate *signer;	/* Certificate that signed this one */
 	struct public_key *pub;			/* Public key details */
 	char		*issuer;		/* Name of certificate issuer */
 	char		*subject;		/* Name of certificate subject */

