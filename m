Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095Ab2EJXmC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:42:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932829Ab2EJXl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:41:57 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 15/29] KEYS: PGP format signature parser [ver #4]
To: rusty@rustcorp.com.au
Cc: kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        David Howells <dhowells@redhat.com>
Date: Fri, 11 May 2012 00:41:47 +0100
Message-ID: <20120510234146.4137.76351.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
References: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
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
 security/keys/crypto/pgp_key_parser.c |    1 
 security/keys/crypto/pgp_parser.h     |    6 ++
 security/keys/crypto/pgp_sig_parser.c |  104 +++++++++++++++++++++++++++++++++
 4 files changed, 112 insertions(+), 0 deletions(-)
 create mode 100644 security/keys/crypto/pgp_sig_parser.c


diff --git a/security/keys/crypto/Makefile b/security/keys/crypto/Makefile
index d4ac8ac..fa7746d 100644
--- a/security/keys/crypto/Makefile
+++ b/security/keys/crypto/Makefile
@@ -12,4 +12,5 @@ obj-$(CONFIG_PGP_LIBRARY) += pgp_library.o
 obj-$(CONFIG_CRYPTO_KEY_PGP_PARSER) += pgp_parser.o
 pgp_parser-y := \
 	pgp_key_parser.o \
+	pgp_sig_parser.o \
 	pgp_pubkey_sig.o
diff --git a/security/keys/crypto/pgp_key_parser.c b/security/keys/crypto/pgp_key_parser.c
index 4efc4de..1407e2e 100644
--- a/security/keys/crypto/pgp_key_parser.c
+++ b/security/keys/crypto/pgp_key_parser.c
@@ -324,6 +324,7 @@ static struct crypto_key_parser pgp_key_parser = {
 	.owner		= THIS_MODULE,
 	.name		= "pgp",
 	.instantiate	= pgp_key_instantiate,
+	.verify_sig_begin = pgp_verify_sig_begin,
 };
 
 /*
diff --git a/security/keys/crypto/pgp_parser.h b/security/keys/crypto/pgp_parser.h
index a6192ce..73c900e 100644
--- a/security/keys/crypto/pgp_parser.h
+++ b/security/keys/crypto/pgp_parser.h
@@ -23,6 +23,12 @@ extern const
 struct public_key_algorithm *pgp_public_key_algorithms[PGP_PUBKEY__LAST];
 
 /*
+ * pgp_sig_parser.c
+ */
+extern struct crypto_key_verify_context *pgp_verify_sig_begin(
+	struct key *keyring, const u8 *sig, size_t siglen);
+
+/*
  * pgp_pubkey_sig.c
  */
 extern struct crypto_key_verify_context *pgp_pkey_verify_sig_begin(
diff --git a/security/keys/crypto/pgp_sig_parser.c b/security/keys/crypto/pgp_sig_parser.c
new file mode 100644
index 0000000..b72c505
--- /dev/null
+++ b/security/keys/crypto/pgp_sig_parser.c
@@ -0,0 +1,104 @@
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
+#include <linux/pgp.h>
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
+		return ERR_PTR(-EINVAL);
+
+	sprintf(criterion, "id:%08x%08x",
+		be32_to_cpu(p.params.issuer32[0]),
+		be32_to_cpu(p.params.issuer32[1]));
+
+	pr_debug("Look up: %s\n", criterion);
+
+	key = keyring_search(make_key_ref(keyring, 1),
+			     &key_type_crypto, criterion);
+	if (IS_ERR(key))
+		return ERR_CAST(key);
+
+	pr_debug("Found key %x\n", key_serial(key_ref_to_ptr(key)));
+	return key_ref_to_ptr(key);
+}
+
+/*
+ * Attempt to parse a signature as a PGP packet format blob and find a
+ * matching key.
+ */
+struct crypto_key_verify_context *pgp_verify_sig_begin(
+	struct key *keyring, const u8 *sig, size_t siglen)
+{
+	struct crypto_key_verify_context *ctx;
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

