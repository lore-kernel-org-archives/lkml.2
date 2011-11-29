Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161Ab1K2XyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 18:54:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757056Ab1K2XxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 18:53:22 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 12/16] KEYS: Add a crypto key request function [ver #2]
To: keyrings@linux-nfs.org
Cc: linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
        alan.cox@intel.com, David Howells <dhowells@redhat.com>
Date: Tue, 29 Nov 2011 23:45:31 +0000
Message-ID: <20111129234531.13625.79857.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111129234258.13625.21153.stgit@warthog.procyon.org.uk>
References: <20111129234258.13625.21153.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function by which crypto keys can be requested.  A keyring is supplied
for the function to search (which can be, say, a system keyring containing keys
for kernel module signature checking).  The function also provides a point at
which hardware key caches, such as a TPM, can be consulted.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/security/keys-crypto.txt |   12 ++++
 include/keys/crypto-type.h             |    3 +
 security/keys/Makefile                 |    2 -
 security/keys/crypto_request.c         |   87 ++++++++++++++++++++++++++++++++
 4 files changed, 103 insertions(+), 1 deletions(-)
 create mode 100644 security/keys/crypto_request.c


diff --git a/Documentation/security/keys-crypto.txt b/Documentation/security/keys-crypto.txt
index 236d750..e1c19ea 100644
--- a/Documentation/security/keys-crypto.txt
+++ b/Documentation/security/keys-crypto.txt
@@ -158,6 +158,18 @@ using a key to provide the public key:
      not necessary if verify_sig_end() was called.
 
 
+To find a key to use for signature verification, the following function may be
+called:
+
+	struct key *request_crypto_key_for_PGP_sig(struct key *keyring,
+						  const u8 *sig, size_t siglen);
+
+This parses the specified signature blob to find the signing key identity and
+then searches the given keyring for a matching key.  It may also examine a
+hardware keystore (such as a TPM) for a usable signature matching service and
+generate a key to provide an access method to that service.
+
+
 ============================
 IMPLEMENTING CRYPTO SUBTYPES
 ============================
diff --git a/include/keys/crypto-type.h b/include/keys/crypto-type.h
index 6b93366..142611b 100644
--- a/include/keys/crypto-type.h
+++ b/include/keys/crypto-type.h
@@ -31,4 +31,7 @@ extern void verify_sig_cancel(struct crypto_key_verify_context *ctx);
  * The payload is at the discretion of the subtype.
  */
 
+extern struct key *request_crypto_key_for_PGP_sig(struct key *keyring,
+						  const u8 *sig, size_t siglen);
+
 #endif /* _KEYS_CRYPTO_TYPE_H */
diff --git a/security/keys/Makefile b/security/keys/Makefile
index 78a3aa6..722be34 100644
--- a/security/keys/Makefile
+++ b/security/keys/Makefile
@@ -22,6 +22,6 @@ obj-$(CONFIG_KEYS_COMPAT) += compat.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_SYSCTL) += sysctl.o
 
-crypto_keys-y	:= crypto_type.o pgp_parse.o crypto_verify.o
+crypto_keys-y	:= crypto_type.o pgp_parse.o crypto_verify.o crypto_request.o
 crypto_dsa-y	:= crypto_dsa_subtype.o crypto_dsa_verify.o
 crypto_rsa-y	:= crypto_rsa_subtype.o crypto_rsa_verify.o
diff --git a/security/keys/crypto_request.c b/security/keys/crypto_request.c
new file mode 100644
index 0000000..0a1819a3
--- /dev/null
+++ b/security/keys/crypto_request.c
@@ -0,0 +1,87 @@
+/* Cryptographic key request handling
+ *
+ * Copyright (C) 2011 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ *
+ * See Documentation/security/keys-crypto.txt
+ */
+
+#include <keys/crypto-subtype.h>
+#include <linux/seq_file.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/pgp.h>
+#include "crypto_keys.h"
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
+static int PGP_sig_parse_signature(struct pgp_parse_context *context,
+				   enum pgp_packet_tag type,
+				   u8 headerlen,
+				   const u8 *data,
+				   size_t datalen)
+{
+	struct PGP_sig_parse_context *ctx =
+		container_of(context, struct PGP_sig_parse_context, pgp);
+
+	ctx->found_sig = true;
+	return pgp_parse_sig_params(&data, &datalen, &ctx->params);
+}
+
+/**
+ * request_crypto_key_for_PGP_sig - Request a key matching a PGP signature
+ * @keyring: The keyring that might contain the key.
+ * @sig: The PGP signature blob.
+ * @siglen: The size of the PGP signature blob.
+ *
+ * Attempt to find a key to use for PGP signature verification, starting off by
+ * looking in the supplied keyring.  The function may also look for other key
+ * sources such as a TPM.  If an alternative key is found it will be added to
+ * the keyring for future reference.
+ */
+struct key *request_crypto_key_for_PGP_sig(struct key *keyring,
+					   const u8 *sig, size_t siglen)
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
+	p.pgp.process_packet = PGP_sig_parse_signature;
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
+	pr_debug("Look up: %s", criterion);
+
+	key = keyring_search(make_key_ref(keyring, 1),
+			     &key_type_crypto, criterion);
+	if (IS_ERR(key))
+		return ERR_CAST(key);
+	return key_ref_to_ptr(key);
+}

