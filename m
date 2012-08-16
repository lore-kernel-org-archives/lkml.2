Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab2HPBg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 21:36:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757447Ab2HPBg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 21:36:56 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 14/25] KEYS: PGP format signature parser
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        jmorris@namei.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 16 Aug 2012 02:36:46 +0100
Message-ID: <20120816013646.872.87756.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120816013405.872.42381.stgit@warthog.procyon.org.uk>
References: <20120816013405.872.42381.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement a signature parser that will attempt to parse a signature blob as a
PGP packet format message.  If it can, it will find an appropriate crypto key
and set the public-key algorithm according to the data in the signature.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/crypto/Makefile         |    1 
 security/keys/crypto/pgp_sig_parser.c |  136 +++++++++++++++++++++++++++++++++
 2 files changed, 137 insertions(+)
 create mode 100644 security/keys/crypto/pgp_sig_parser.c


diff --git a/security/keys/crypto/Makefile b/security/keys/crypto/Makefile
index 0c8b8a1..a9a34c6 100644
--- a/security/keys/crypto/Makefile
+++ b/security/keys/crypto/Makefile
@@ -12,4 +12,5 @@ obj-$(CONFIG_PGP_LIBRARY) += pgp_library.o
 obj-$(CONFIG_CRYPTO_KEY_PGP_PARSER) += pgp_key_parser.o
 pgp_key_parser-y := \
 	pgp_public_key.o \
+	pgp_sig_parser.o \
 	pgp_sig_verify.o
diff --git a/security/keys/crypto/pgp_sig_parser.c b/security/keys/crypto/pgp_sig_parser.c
new file mode 100644
index 0000000..683eb53
--- /dev/null
+++ b/security/keys/crypto/pgp_sig_parser.c
@@ -0,0 +1,136 @@
+/* Handling for PGP public key signature data [RFC 4880]
+ *
+ * Copyright (C) 2011 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#define pr_fmt(fmt) "PGPSIG: "fmt
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/pgplib.h>
+#include <linux/err.h>
+#include "public_key.h"
+#include "pgp_parser.h"
+
+struct PGP_sig_parse_context {
+	struct pgp_parse_context pgp;
+	struct pgp_sig_parameters params;
+	bool found_sig;
+};
+
+/*
+ * Look inside signature sections for a key ID
+ */
+static int pgp_process_signature(struct pgp_parse_context *context,
+				 enum pgp_packet_tag type,
+				 u8 headerlen,
+				 const u8 *data,
+				 size_t datalen)
+{
+	struct PGP_sig_parse_context *ctx =
+		container_of(context, struct PGP_sig_parse_context, pgp);
+
+	ctx->found_sig = true;
+	return pgp_parse_sig_params(&data, &datalen, &ctx->params);
+}
+
+/*
+ * Attempt to find a key to use for PGP signature verification, starting off by
+ * looking in the supplied keyring.
+ *
+ * The function may also look for other key sources such as a TPM.  If an
+ * alternative key is found it can be added to the keyring for future
+ * reference.
+ */
+static struct key *find_key_for_pgp_sig(struct key *keyring,
+					const u8 *sig, size_t siglen)
+{
+	struct PGP_sig_parse_context p;
+	key_ref_t key;
+	char criterion[3 + 8 * 2 + 1];
+	int ret;
+
+	if (!keyring)
+		return ERR_PTR(-ENOKEY);
+
+	/* Need to find the key ID */
+	p.pgp.types_of_interest = (1 << PGP_PKT_SIGNATURE);
+	p.pgp.process_packet = pgp_process_signature;
+	p.found_sig = false;
+	ret = pgp_parse_packets(sig, siglen, &p.pgp);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	if (!p.found_sig)
+		return ERR_PTR(-ENOMSG);
+
+	sprintf(criterion, "id:%08x%08x",
+		be32_to_cpu(p.params.issuer32[0]),
+		be32_to_cpu(p.params.issuer32[1]));
+
+	pr_debug("Look up: %s\n", criterion);
+
+	key = keyring_search(make_key_ref(keyring, 1),
+			     &key_type_crypto, criterion);
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
+	pr_debug("Found key %x\n", key_serial(key_ref_to_ptr(key)));
+	return key_ref_to_ptr(key);
+}
+
+/*
+ * Attempt to parse a signature as a PGP packet format blob and find a
+ * matching key.
+ */
+static struct crypto_sig_verify_context *pgp_verify_sig_begin(
+	struct key *keyring, const u8 *sig, size_t siglen)
+{
+	struct crypto_sig_verify_context *ctx;
+	struct key *key;
+
+	key = find_key_for_pgp_sig(keyring, sig, siglen);
+	if (IS_ERR(key))
+		return ERR_CAST(key);
+
+	/* We only handle in-kernel public key signatures for the moment */
+	ctx = pgp_pkey_verify_sig_begin(key, sig, siglen);
+	key_put(key);
+	return ctx;
+}
+
+static struct crypto_sig_parser pgp_sig_parser = {
+	.owner		= THIS_MODULE,
+	.name		= "pgp",
+	.verify_sig_begin = pgp_verify_sig_begin,
+};
+
+/*
+ * Module stuff
+ */
+static int __init pgp_sig_init(void)
+{
+	return register_crypto_sig_parser(&pgp_sig_parser);
+}
+
+static void __exit pgp_sig_exit(void)
+{
+	unregister_crypto_sig_parser(&pgp_sig_parser);
+}
+
+module_init(pgp_sig_init);
+module_exit(pgp_sig_exit);

