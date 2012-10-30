Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965731Ab2J3TVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:21:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244Ab2J3TVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:21:22 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 12/23] PKCS#7: Digest the data in a signed-data message
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, pjones@redhat.com, jwboyer@redhat.com, mjg@redhat.com,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        keescook@chromium.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 30 Oct 2012 19:21:14 +0000
Message-ID: <20121030192114.11000.1909.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
References: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Digest the data in a PKCS#7 signed-data message and attach to the
public_key_signature struct contained in the pkcs7_message struct.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/Makefile       |    3 +
 crypto/asymmetric_keys/pkcs7_verify.c |  130 +++++++++++++++++++++++++++++++++
 2 files changed, 132 insertions(+), 1 deletion(-)
 create mode 100644 crypto/asymmetric_keys/pkcs7_verify.c


diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index 59d8cad..b6b39e7 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -32,7 +32,8 @@ clean-files	+= x509_rsakey-asn1.c x509_rsakey-asn1.h
 obj-$(CONFIG_PKCS7_MESSAGE_PARSER) += pkcs7_message.o
 pkcs7_message-y := \
 	pkcs7-asn1.o \
-	pkcs7_parser.o
+	pkcs7_parser.o \
+	pkcs7_verify.o
 
 $(obj)/pkcs7_parser.o: $(obj)/pkcs7-asn1.h
 $(obj)/pkcs7-asn1.o: $(obj)/pkcs7-asn1.c $(obj)/pkcs7-asn1.h
diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
new file mode 100644
index 0000000..7d7ac8a
--- /dev/null
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -0,0 +1,130 @@
+/* Verify the signature on a PKCS#7 message.
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
+#include <crypto/hash.h>
+#include "public_key.h"
+#include "pkcs7_parser.h"
+
+/*
+ * Digest the relevant parts of the PKCS#7 data
+ */
+static int pkcs7_digest(struct pkcs7_message *pkcs7)
+{
+	struct crypto_shash *tfm;
+	struct shash_desc *desc;
+	size_t digest_size, desc_size;
+	void *digest;
+	int ret;
+
+	kenter(",%u", pkcs7->sig.pkey_hash_algo);
+
+	/* Allocate the hashing algorithm we're going to need and find out how
+	 * big the hash operational data will be.
+	 */
+	tfm = crypto_alloc_shash(pkey_hash_algo_name[pkcs7->sig.pkey_hash_algo],
+				 0, 0);
+	if (IS_ERR(tfm))
+		return (PTR_ERR(tfm) == -ENOENT) ? -ENOPKG : PTR_ERR(tfm);
+
+	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
+	pkcs7->sig.digest_size = digest_size = crypto_shash_digestsize(tfm);
+
+	ret = -ENOMEM;
+	digest = kzalloc(digest_size + desc_size, GFP_KERNEL);
+	if (!digest)
+		goto error_no_desc;
+
+	desc = digest + digest_size;
+	desc->tfm   = tfm;
+	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	/* Digest the message [RFC2315 9.3] */
+	ret = crypto_shash_init(desc);
+	if (ret < 0)
+		goto error;
+	ret = crypto_shash_finup(desc, pkcs7->data, pkcs7->data_len, digest);
+	if (ret < 0)
+		goto error;
+	pr_devel("MsgDigest = [%*ph]\n", 8, digest);
+
+	/* However, if there are authenticated attributes, there must be a
+	 * message digest attribute amongst them which corresponds to the
+	 * digest we just calculated.
+	 */
+	if (pkcs7->msgdigest) {
+		u8 tag;
+
+		if (pkcs7->msgdigest_len != pkcs7->sig.digest_size) {
+			pr_debug("Invalid digest size (%u)\n",
+				 pkcs7->msgdigest_len);
+			ret = -EBADMSG;
+			goto error;
+		}
+
+		if (memcmp(digest, pkcs7->msgdigest, pkcs7->msgdigest_len) != 0) {
+			pr_debug("Message digest doesn't match\n");
+			ret = -EKEYREJECTED;
+			goto error;
+		}
+
+		/* We then calculate anew, using the authenticated attributes
+		 * as the contents of the digest instead.  Note that we need to
+		 * convert the attributes from a CONT.0 into a SET before we
+		 * hash it.
+		 */
+		memset(digest, 0, pkcs7->sig.digest_size);
+
+		ret = crypto_shash_init(desc);
+		if (ret < 0)
+			goto error;
+		tag = ASN1_CONS_BIT | ASN1_SET;
+		ret = crypto_shash_update(desc, &tag, 1);
+		if (ret < 0)
+			goto error;
+		ret = crypto_shash_finup(desc, pkcs7->authattrs,
+					 pkcs7->authattrs_len, digest);
+		if (ret < 0)
+			goto error;
+		pr_devel("AADigest = [%*ph]\n", 8, digest);
+	}
+
+	pkcs7->sig.digest = digest;
+	digest = NULL;
+
+error:
+	kfree(digest);
+error_no_desc:
+	crypto_free_shash(tfm);
+	kleave(" = %d\n", ret);
+	return ret;
+}
+
+/*
+ * Verify a PKCS#7 message
+ */
+int pkcs7_verify(struct pkcs7_message *pkcs7)
+{
+	int ret;
+
+	/* First of all, digest the data in the PKCS#7 message */
+	ret = pkcs7_digest(pkcs7);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pkcs7_verify);

