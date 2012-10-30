Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965777Ab2J3TWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:22:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965762Ab2J3TWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:22:41 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 21/23] PKCS#7: Find intersection between PKCS#7 message and
 known, trusted keys
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, pjones@redhat.com, jwboyer@redhat.com, mjg@redhat.com,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        keescook@chromium.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 30 Oct 2012 19:22:31 +0000
Message-ID: <20121030192231.11000.99669.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
References: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Find the intersection between the X.509 certificate chain contained in a PKCS#7
message and a set of keys that we already know and trust.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/Makefile        |    1 
 crypto/asymmetric_keys/pefile_parser.c |    6 +
 crypto/asymmetric_keys/pkcs7_parser.h  |    6 +
 crypto/asymmetric_keys/pkcs7_trust.c   |  145 ++++++++++++++++++++++++++++++++
 kernel/modsign_pubkey.c                |    1 
 5 files changed, 159 insertions(+)
 create mode 100644 crypto/asymmetric_keys/pkcs7_trust.c


diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index 566dd45..ddc64bb 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_PKCS7_MESSAGE_PARSER) += pkcs7_message.o
 pkcs7_message-y := \
 	pkcs7-asn1.o \
 	pkcs7_parser.o \
+	pkcs7_trust.o \
 	pkcs7_verify.o
 
 $(obj)/pkcs7_parser.o: $(obj)/pkcs7-asn1.h
diff --git a/crypto/asymmetric_keys/pefile_parser.c b/crypto/asymmetric_keys/pefile_parser.c
index 9ede195..1ab1890 100644
--- a/crypto/asymmetric_keys/pefile_parser.c
+++ b/crypto/asymmetric_keys/pefile_parser.c
@@ -23,6 +23,8 @@
 #include "public_key.h"
 #include "pefile_parser.h"
 
+extern struct key *modsign_keyring;
+
 /*
  * Parse a PE binary.
  */
@@ -428,6 +430,10 @@ static int pefile_key_preparse(struct key_preparsed_payload *prep)
 	if (ret < 0)
 		goto error;
 
+	ret = pkcs7_validate_trust(pkcs7, modsign_keyring);
+	if (ret < 0)
+		goto error;
+
 	ret = -ENOANO; // Not yet complete
 
 error:
diff --git a/crypto/asymmetric_keys/pkcs7_parser.h b/crypto/asymmetric_keys/pkcs7_parser.h
index 5415857..f6df500 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.h
+++ b/crypto/asymmetric_keys/pkcs7_parser.h
@@ -60,6 +60,12 @@ extern struct pkcs7_message *pkcs7_parse_message(const void *data,
 extern void pkcs7_free_message(struct pkcs7_message *pkcs7);
 
 /*
+ * pkcs7_trust.c
+ */
+extern int pkcs7_validate_trust(struct pkcs7_message *pkcs7,
+				struct key *trust_keyring);
+
+/*
  * pkcs7_verify.c
  */
 extern int pkcs7_verify(struct pkcs7_message *pkcs7);
diff --git a/crypto/asymmetric_keys/pkcs7_trust.c b/crypto/asymmetric_keys/pkcs7_trust.c
new file mode 100644
index 0000000..9abcb39
--- /dev/null
+++ b/crypto/asymmetric_keys/pkcs7_trust.c
@@ -0,0 +1,145 @@
+/* Validate the trust chain of a PKCS#7 message.
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
+#define pr_fmt(fmt) "PKCS7: "fmt
+#include <linux/kernel.h>
+#include <linux/export.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/asn1.h>
+#include <linux/key.h>
+#include <keys/asymmetric-type.h>
+#include "public_key.h"
+#include "pkcs7_parser.h"
+
+/*
+ * Request an asymmetric key.
+ */
+static struct key *pkcs7_request_asymmetric_key(
+	struct key *keyring,
+	const char *signer, size_t signer_len,
+	const char *authority, size_t auth_len)
+{
+	key_ref_t key;
+	char *id;
+
+	kenter(",%zu,,%zu", signer_len, auth_len);
+
+	/* Construct an identifier. */
+	id = kmalloc(signer_len + 2 + auth_len + 1, GFP_KERNEL);
+	if (!id)
+		return ERR_PTR(-ENOMEM);
+
+	memcpy(id, signer, signer_len);
+	id[signer_len + 0] = ':';
+	id[signer_len + 1] = ' ';
+	memcpy(id + signer_len + 2, authority, auth_len);
+	id[signer_len + 2 + auth_len] = 0;
+
+	pr_debug("Look up: \"%s\"\n", id);
+
+	key = keyring_search(make_key_ref(keyring, 1),
+			     &key_type_asymmetric, id);
+	if (IS_ERR(key))
+		pr_debug("Request for module key '%s' err %ld\n",
+			 id, PTR_ERR(key));
+	kfree(id);
+
+	if (IS_ERR(key)) {
+		switch (PTR_ERR(key)) {
+			/* Hide some search errors */
+		case -EACCES:
+		case -ENOTDIR:
+		case -EAGAIN:
+			return ERR_PTR(-ENOKEY);
+		default:
+			return ERR_CAST(key);
+		}
+	}
+
+	pr_devel("<==%s() = 0 [%x]\n", __func__, key_serial(key_ref_to_ptr(key)));
+	return key_ref_to_ptr(key);
+}
+
+/*
+ * Validate that the certificate chain inside the PKCS#7 message intersects
+ * keys we already know and trust.
+ */
+int pkcs7_validate_trust(struct pkcs7_message *pkcs7,
+			 struct key *trust_keyring)
+{
+	struct public_key_signature *sig = &pkcs7->sig;
+	struct x509_certificate *x509, *last = NULL;
+	struct key *key;
+	int ret;
+
+	kenter("");
+
+	for (x509 = pkcs7->signer; x509; x509 = x509->next) {
+		/* Look to see if this certificate is present in the trusted
+		 * keys.
+		 */
+		key = pkcs7_request_asymmetric_key(
+			trust_keyring,
+			x509->subject, strlen(x509->subject),
+			x509->fingerprint, strlen(x509->fingerprint));
+		if (!IS_ERR(key))
+			/* One of the X.509 certificates in the PKCS#7 message
+			 * is apparently the same as one we already trust.
+			 * Verify that the trusted variant can also validate
+			 * the signature on the descendent.
+			 */
+			goto matched;
+		if (key == ERR_PTR(-ENOMEM))
+			return -ENOMEM;
+
+		 /* Self-signed certificates form roots of their own, and if we
+		  * don't know them, then we can't accept them.
+		  */
+		if (x509->next == x509) {
+			kleave(" = -EKEYREJECTED [unknown self-signed]");
+			return -EKEYREJECTED;
+		}
+
+		might_sleep();
+		last = x509;
+		sig = &last->sig;
+	}
+
+	/* No match - see if the root certificate has a signer amongst the
+	 * trusted keys.
+	 */
+	if (!last || !last->issuer || !last->authority) {
+		kleave(" = -EKEYREJECTED [no backref]");
+		return -EKEYREJECTED;
+	}
+
+	key = pkcs7_request_asymmetric_key(
+		trust_keyring,
+		last->issuer, strlen(last->issuer),
+		last->authority, strlen(last->authority));
+	if (IS_ERR(key))
+		return PTR_ERR(key) == -ENOMEM ? -ENOMEM : -EKEYREJECTED;
+
+matched:
+	ret = verify_signature(key, sig);
+	key_put(key);
+	if (ret < 0) {
+		if (ret == -ENOMEM)
+			return ret;
+		kleave(" = -EKEYREJECTED [verify %d]", ret);
+		return -EKEYREJECTED;
+	}
+
+	kleave(" = 0");
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pkcs7_validate_trust);
diff --git a/kernel/modsign_pubkey.c b/kernel/modsign_pubkey.c
index 4646eb2..602be22 100644
--- a/kernel/modsign_pubkey.c
+++ b/kernel/modsign_pubkey.c
@@ -17,6 +17,7 @@
 #include "module-internal.h"
 
 struct key *modsign_keyring;
+EXPORT_SYMBOL_GPL(modsign_keyring);
 
 extern __initdata const u8 modsign_certificate_list[];
 extern __initdata const u8 modsign_certificate_list_end[];

