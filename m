Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab2HPBhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 21:37:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757344Ab2HPBhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 21:37:17 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 16/25] KEYS: Provide a function to load keys from a PGP
 keyring blob
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        jmorris@namei.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 16 Aug 2012 02:37:08 +0100
Message-ID: <20120816013708.872.22387.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120816013405.872.42381.stgit@warthog.procyon.org.uk>
References: <20120816013405.872.42381.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a function to load keys from a PGP keyring blob for use in initialising
the module signing key keyring:

	int load_PGP_keys(const u8 *pgpdata, size_t pgpdatalen,
			  struct key *keyring, const char *descprefix);

The keys are labelled with descprefix plus a number to uniquify them.  The keys
will actually be identified by the ID calculated from the PGP data rather than
by the description, so this shouldn't be a problem.

The keys are attached to the keyring supplied.

Looking as root in /proc/keys after the module signing keyring has been loaded:

24460d1c I-----     1 perm 3f010000     0     0 crypto    modsign.0: dsa 5acc2142 []
3ca85723 I-----     1 perm 1f010000     0     0 keyring   .module_sign: 1/4

Thanks to Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> for some pointing
out some errors.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/security/keys-crypto.txt |   20 ++++++
 include/keys/crypto-type.h             |    3 +
 security/keys/crypto/Kconfig           |    9 +++
 security/keys/crypto/Makefile          |    1 
 security/keys/crypto/pgp_preload.c     |  115 ++++++++++++++++++++++++++++++++
 5 files changed, 148 insertions(+)
 create mode 100644 security/keys/crypto/pgp_preload.c


diff --git a/Documentation/security/keys-crypto.txt b/Documentation/security/keys-crypto.txt
index 0a886ec..be5067e 100644
--- a/Documentation/security/keys-crypto.txt
+++ b/Documentation/security/keys-crypto.txt
@@ -10,6 +10,7 @@ Contents:
     - Signature verification.
   - Implementing crypto parsers.
   - Implementing crypto subtypes.
+  - Initial PGP key preloading.
 
 
 ========
@@ -279,3 +280,22 @@ There are a number of operations defined by the subtype:
      Mandatory.  This should free the memory associated with the key.  The
      crypto key will look after freeing the fingerprint and releasing the
      reference on the subtype module.
+
+
+=======================
+INITIAL PGP KEY LOADING
+=======================
+
+A function is provided to perform an initial load of a set of public keys bound
+into a PGP packet format blob:
+
+	int preload_pgp_keys(const u8 *pgpdata, size_t pgpdatalen,
+			     struct key *keyring);
+
+This takes the blob of data defined by pgpdata and pgpdatalen, extracts keys
+from them and adds them to the specified keyring.  The keys are labelled with a
+description generated from the fingerprint and last user ID of each key.  The
+description is required to prevent all but the last key being discarded when
+the keys are linked into the keyring.
+
+This function is only available during initial kernel set up.
diff --git a/include/keys/crypto-type.h b/include/keys/crypto-type.h
index 0fb362a..ed9b203 100644
--- a/include/keys/crypto-type.h
+++ b/include/keys/crypto-type.h
@@ -31,4 +31,7 @@ extern void verify_sig_cancel(struct crypto_sig_verify_context *ctx);
  * The payload is at the discretion of the subtype.
  */
 
+extern __init int preload_pgp_keys(const u8 *pgpdata, size_t pgpdatalen,
+				   struct key *keyring);
+
 #endif /* _KEYS_CRYPTO_TYPE_H */
diff --git a/security/keys/crypto/Kconfig b/security/keys/crypto/Kconfig
index 1c2ae55..8af0155 100644
--- a/security/keys/crypto/Kconfig
+++ b/security/keys/crypto/Kconfig
@@ -40,3 +40,12 @@ config CRYPTO_KEY_PGP_PARSER
 	  This option provides support for parsing PGP (RFC 4880) format blobs
 	  for key data and provides the ability to instantiate a crypto key
 	  from a public key packet found inside the blob.
+
+config PGP_PRELOAD
+	bool "PGP public key preloading facility"
+	select PGP_LIBRARY
+	select CRYPTO_KEY_PGP_PARSER
+	help
+	  This option provides a facility for the kernel to preload PGP-wrapped
+	  bundles of keys during boot.  It is used by module signing to load
+	  the module signing keys for example.
diff --git a/security/keys/crypto/Makefile b/security/keys/crypto/Makefile
index a9a34c6..c873674 100644
--- a/security/keys/crypto/Makefile
+++ b/security/keys/crypto/Makefile
@@ -8,6 +8,7 @@ crypto_keys-y := crypto_type.o crypto_verify.o
 obj-$(CONFIG_CRYPTO_KEY_PUBLIC_KEY_SUBTYPE) += public_key.o
 obj-$(CONFIG_CRYPTO_KEY_PKEY_ALGO_RSA) += crypto_rsa.o
 obj-$(CONFIG_PGP_LIBRARY) += pgp_library.o
+obj-$(CONFIG_PGP_PRELOAD) += pgp_preload.o
 
 obj-$(CONFIG_CRYPTO_KEY_PGP_PARSER) += pgp_key_parser.o
 pgp_key_parser-y := \
diff --git a/security/keys/crypto/pgp_preload.c b/security/keys/crypto/pgp_preload.c
new file mode 100644
index 0000000..ca4cfe6
--- /dev/null
+++ b/security/keys/crypto/pgp_preload.c
@@ -0,0 +1,115 @@
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
+#include <linux/module.h>
+#include <linux/key.h>
+#include <linux/pgplib.h>
+#include <linux/err.h>
+#include <keys/crypto-type.h>
+#include "crypto_keys.h"
+
+struct preload_pgp_keys_context {
+	struct pgp_parse_context pgp;
+	key_ref_t keyring;
+	const u8 *key_start;
+	const u8 *key_end;
+	bool found_key;
+};
+
+/*
+ * Create a key.
+ */
+static int __init create_pgp_key(struct preload_pgp_keys_context *ctx)
+{
+	key_ref_t key;
+
+	key = key_create_or_update(ctx->keyring, "crypto", NULL,
+				   ctx->key_start,
+				   ctx->key_end - ctx->key_start,
+				   KEY_POS_ALL | KEY_USR_VIEW,
+				   KEY_ALLOC_NOT_IN_QUOTA);
+	if (IS_ERR(key))
+		return PTR_ERR(key);
+
+	pr_notice("Loaded %s key: %s\n",
+		  key_ref_to_ptr(key)->description,
+		  crypto_key_id(key_ref_to_ptr(key)));
+
+	key_ref_put(key);
+	return 0;
+}
+
+/*
+ * Extract a public key or subkey from the PGP stream.
+ */
+static int __init found_pgp_key(struct pgp_parse_context *context,
+				enum pgp_packet_tag type, u8 headerlen,
+				const u8 *data, size_t datalen)
+{
+	struct preload_pgp_keys_context *ctx =
+		container_of(context, struct preload_pgp_keys_context, pgp);
+	int ret;
+
+	if (ctx->found_key) {
+		ctx->key_end = data - headerlen;
+		ret = create_pgp_key(ctx);
+		if (ret < 0)
+			return ret;
+	}
+
+	ctx->key_start = data - headerlen;
+	ctx->found_key = true;
+	return 0;
+}
+
+/**
+ * preload_pgp_keys - Load keys from a PGP keyring blob
+ * @pgpdata: The PGP keyring blob containing the keys.
+ * @pgpdatalen: The size of the @pgpdata blob.
+ * @keyring: The keyring to add the new keys to.
+ *
+ * Preload a pack of keys from a PGP keyring blob.
+ *
+ * The keys have their descriptions generated from the user ID and fingerprint
+ * in the PGP stream.  Since keys can be matched on their key IDs independently
+ * of the key description, the description is mostly irrelevant apart from the
+ * fact that keys of the same description displace one another from a keyring.
+ *
+ * The caller should override the current creds if they want the keys to be
+ * owned by someone other than the current process's owner.  Keys will not be
+ * accounted towards the owner's quota.
+ *
+ * This function may only be called whilst the kernel is booting.
+ */
+int __init preload_pgp_keys(const u8 *pgpdata, size_t pgpdatalen,
+			    struct key *keyring)
+{
+	struct preload_pgp_keys_context ctx;
+	int ret;
+
+	ctx.pgp.types_of_interest =
+		(1 << PGP_PKT_PUBLIC_KEY) | (1 << PGP_PKT_PUBLIC_SUBKEY);
+	ctx.pgp.process_packet = found_pgp_key;
+	ctx.keyring = make_key_ref(keyring, 1);
+	ctx.found_key = false;
+
+	ret = pgp_parse_packets(pgpdata, pgpdatalen, &ctx.pgp);
+	if (ret < 0)
+		return ret;
+
+	if (ctx.found_key) {
+		ctx.key_end = pgpdata + pgpdatalen;
+		return create_pgp_key(&ctx);
+	}
+	return 0;
+}

