Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965787Ab2J3TXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:23:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158Ab2J3TXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:23:19 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 19/23] pefile: Parse the "Microsoft individual code signing"
 data blob
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, pjones@redhat.com, jwboyer@redhat.com, mjg@redhat.com,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        keescook@chromium.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 30 Oct 2012 19:22:14 +0000
Message-ID: <20121030192214.11000.20716.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
References: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PKCS#7 certificate should contain a "Microsoft individual code signing"
data blob as its signed content.  This blob contains a digest of the signed
content of the PE binary and the OID of the digest algorithm used (typically
SHA256).

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/Makefile        |    9 ++-
 crypto/asymmetric_keys/mscode.asn1     |   28 ++++++++
 crypto/asymmetric_keys/mscode_parser.c |  110 ++++++++++++++++++++++++++++++++
 crypto/asymmetric_keys/pefile_parser.c |    6 ++
 crypto/asymmetric_keys/pefile_parser.h |    5 +
 include/linux/oid_registry.h           |    6 +-
 6 files changed, 162 insertions(+), 2 deletions(-)
 create mode 100644 crypto/asymmetric_keys/mscode.asn1
 create mode 100644 crypto/asymmetric_keys/mscode_parser.c


diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index 61905d3..566dd45 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -46,4 +46,11 @@ clean-files	+= pkcs7-asn1.c pkcs7-asn1.h
 obj-$(CONFIG_PE_FILE_PARSER) += pefile_key_parser.o
 
 pefile_key_parser-y := \
-	pefile_parser.o
+	pefile_parser.o \
+	mscode_parser.o \
+	mscode-asn1.o
+
+$(obj)/mscode_parser.o: $(obj)/mscode-asn1.h $(obj)/mscode-asn1.h
+$(obj)/mscode-asn1.o: $(obj)/mscode-asn1.c $(obj)/mscode-asn1.h
+
+clean-files	+= mscode-asn1.c mscode-asn1.h
diff --git a/crypto/asymmetric_keys/mscode.asn1 b/crypto/asymmetric_keys/mscode.asn1
new file mode 100644
index 0000000..6d09ba4
--- /dev/null
+++ b/crypto/asymmetric_keys/mscode.asn1
@@ -0,0 +1,28 @@
+--- Microsoft individual code signing data blob parser
+---
+--- Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
+--- Written by David Howells (dhowells@redhat.com)
+---
+--- This program is free software; you can redistribute it and/or
+--- modify it under the terms of the GNU General Public Licence
+--- as published by the Free Software Foundation; either version
+--- 2 of the Licence, or (at your option) any later version.
+---
+
+MSCode ::= SEQUENCE {
+	type			SEQUENCE {
+		contentType	ContentType,
+		parameters	ANY
+	},
+	content			SEQUENCE {
+		digestAlgorithm	DigestAlgorithmIdentifier,
+		digest		OCTET STRING ({ mscode_note_digest })
+	}
+}
+
+ContentType ::= OBJECT IDENTIFIER ({ mscode_note_content_type })
+
+DigestAlgorithmIdentifier ::= SEQUENCE {
+	algorithm   OBJECT IDENTIFIER ({ mscode_note_digest_algo }),
+	parameters  ANY OPTIONAL
+}
diff --git a/crypto/asymmetric_keys/mscode_parser.c b/crypto/asymmetric_keys/mscode_parser.c
new file mode 100644
index 0000000..0bd68e0
--- /dev/null
+++ b/crypto/asymmetric_keys/mscode_parser.c
@@ -0,0 +1,110 @@
+/* Parse a Microsoft Individual Code Signing blob
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
+#define pr_fmt(fmt) "MSCODE: "fmt
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/oid_registry.h>
+#include "pefile_parser.h"
+#include "mscode-asn1.h"
+
+/*
+ * Parse a Microsoft Individual Code Signing blob
+ */
+int mscode_parse(struct pefile_context *ctx)
+{
+	pr_devel("Data: %zu [%*ph]\n",
+		 ctx->pkcs7->data_len + ctx->pkcs7->data_hdrlen,
+		 (unsigned)(ctx->pkcs7->data_len + ctx->pkcs7->data_hdrlen),
+		 ctx->pkcs7->data - ctx->pkcs7->data_hdrlen);
+
+	return asn1_ber_decoder(&mscode_decoder, ctx,
+				ctx->pkcs7->data - ctx->pkcs7->data_hdrlen,
+				ctx->pkcs7->data_len + ctx->pkcs7->data_hdrlen);
+}
+
+/*
+ * Check the content type OID
+ */
+int mscode_note_content_type(void *context, size_t hdrlen,
+			     unsigned char tag,
+			     const void *value, size_t vlen)
+{
+	enum OID oid;
+
+	oid = look_up_OID(value, vlen);
+	if (oid == OID__NR) {
+		char buffer[50];
+		sprint_oid(value, vlen, buffer, sizeof(buffer));
+		printk("MSCODE: Unknown OID: %s\n", buffer);
+		return -EBADMSG;
+	}
+
+	if (oid != OID_msIndividualSPKeyPurpose) {
+		printk("MSCODE: Unexpected content type OID %u\n", oid);
+		return -EBADMSG;
+	}
+
+	return 0;
+}
+
+/*
+ * Note the digest algorithm OID
+ */
+int mscode_note_digest_algo(void *context, size_t hdrlen,
+			    unsigned char tag,
+			    const void *value, size_t vlen)
+{
+	struct pefile_context *ctx = context;
+	char buffer[50];
+	enum OID oid;
+
+	oid = look_up_OID(value, vlen);
+	switch (oid) {
+	case OID_md4:
+		ctx->digest_algo = PKEY_HASH_MD4;
+		break;
+	case OID_md5:
+		ctx->digest_algo = PKEY_HASH_MD5;
+		break;
+	case OID_sha1:
+		ctx->digest_algo = PKEY_HASH_SHA1;
+		break;
+	case OID_sha256:
+		ctx->digest_algo = PKEY_HASH_SHA256;
+		break;
+
+	case OID__NR:
+		sprint_oid(value, vlen, buffer, sizeof(buffer));
+		printk("MSCODE: Unknown OID: %s\n", buffer);
+		return -EBADMSG;
+
+	default:
+		printk("MSCODE: Unsupported content type: %u\n", oid);
+		return -ENOPKG;
+	}
+
+	return 0;
+}
+
+/*
+ * Note the digest we're guaranteeing with this certificate
+ */
+int mscode_note_digest(void *context, size_t hdrlen,
+		       unsigned char tag,
+		       const void *value, size_t vlen)
+{
+	struct pefile_context *ctx = context;
+	ctx->digest = value;
+	ctx->digest_len = vlen;
+	return 0;
+}
diff --git a/crypto/asymmetric_keys/pefile_parser.c b/crypto/asymmetric_keys/pefile_parser.c
index 68fc525..42b9696 100644
--- a/crypto/asymmetric_keys/pefile_parser.c
+++ b/crypto/asymmetric_keys/pefile_parser.c
@@ -224,6 +224,12 @@ static int pefile_key_preparse(struct key_preparsed_payload *prep)
 		goto error;
 	}
 
+	ret = mscode_parse(&ctx);
+	if (ret < 0)
+		goto error;
+
+	pr_devel("Digest: %u [%*ph]\n", ctx.digest_len, ctx.digest_len, ctx.digest);
+
 	ret = -ENOANO; // Not yet complete
 
 error:
diff --git a/crypto/asymmetric_keys/pefile_parser.h b/crypto/asymmetric_keys/pefile_parser.h
index 82bcaf6..c3462b7 100644
--- a/crypto/asymmetric_keys/pefile_parser.h
+++ b/crypto/asymmetric_keys/pefile_parser.h
@@ -29,3 +29,8 @@ struct pefile_context {
 	unsigned	digest_len;		/* Digest length */
 	enum pkey_hash_algo digest_algo;	/* Digest algorithm */
 };
+
+/*
+ * mscode_parser.c
+ */
+extern int mscode_parse(struct pefile_context *ctx);
diff --git a/include/linux/oid_registry.h b/include/linux/oid_registry.h
index edeff85..332dcf5 100644
--- a/include/linux/oid_registry.h
+++ b/include/linux/oid_registry.h
@@ -52,8 +52,12 @@ enum OID {
 	OID_md4,			/* 1.2.840.113549.2.4 */
 	OID_md5,			/* 1.2.840.113549.2.5 */
 
-	OID_certAuthInfoAccess,		/* 1.3.6.1.5.5.7.1.1 */
+	/* Microsoft Authenticode & Software Publishing */
+	OID_msIndirectData,		/* 1.3.6.1.4.1.311.2.1.4 */
+	OID_msIndividualSPKeyPurpose,	/* 1.3.6.1.4.1.311.2.1.21 */
 	OID_msOutlookExpress,		/* 1.3.6.1.4.1.311.16.4 */
+
+	OID_certAuthInfoAccess,		/* 1.3.6.1.5.5.7.1.1 */
 	OID_sha1,			/* 1.3.14.3.2.26 */
 	OID_sha256,			/* 2.16.840.1.101.3.4.2.1 */
 

