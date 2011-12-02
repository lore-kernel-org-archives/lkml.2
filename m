Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402Ab1LBSq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 13:46:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932280Ab1LBSqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 13:46:24 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 18/21] KEYS: Provide a function to load keys from a PGP
 keyring blob [ver #3]
To: keyrings@linux-nfs.org
Cc: linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
        alan.cox@intel.com, David Howells <dhowells@redhat.com>
Date: Fri, 02 Dec 2011 18:46:15 +0000
Message-ID: <20111202184615.21874.7818.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111202184229.21874.25782.stgit@warthog.procyon.org.uk>
References: <20111202184229.21874.25782.stgit@warthog.procyon.org.uk>
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

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/security/keys-crypto.txt |   20 +++++++
 include/keys/crypto-type.h             |    3 +
 security/keys/Kconfig                  |    9 +++
 security/keys/Makefile                 |    1 
 security/keys/pgp_preload.c            |   90 ++++++++++++++++++++++++++++++++
 5 files changed, 123 insertions(+), 0 deletions(-)
 create mode 100644 security/keys/pgp_preload.c


diff --git a/Documentation/security/keys-crypto.txt b/Documentation/security/keys-crypto.txt
index a964717..ba2ab55 100644
--- a/Documentation/security/keys-crypto.txt
+++ b/Documentation/security/keys-crypto.txt
@@ -10,6 +10,7 @@ Contents:
     - Signature verification.
   - Implementing crypto parsers.
   - Implementing crypto subtypes.
+  - Initial PGP key preloading.
 
 
 ========
@@ -280,3 +281,22 @@ There are a number of operations defined by the subtype:
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
+			     struct key *keyring, const char *descprefix);
+
+This takes the blob of data defined by pgpdata and pgpdatalen, extracts keys
+from them and adds them to the specified keyring.  The keys are labelled with
+descprefix plus a simple uniquifier - it is not expected that the description
+will be used to identify the key.  The description is required to prevent all
+but the last key being discarded when the keys are linked into the keyring.
+
+This function is only available during initial kernel set up.
diff --git a/include/keys/crypto-type.h b/include/keys/crypto-type.h
index 6b93366..710e77f 100644
--- a/include/keys/crypto-type.h
+++ b/include/keys/crypto-type.h
@@ -31,4 +31,7 @@ extern void verify_sig_cancel(struct crypto_key_verify_context *ctx);
  * The payload is at the discretion of the subtype.
  */
 
+extern __init int preload_pgp_keys(const u8 *pgpdata, size_t pgpdatalen,
+				   struct key *keyring, const char *descprefix);
+
 #endif /* _KEYS_CRYPTO_TYPE_H */
diff --git a/security/keys/Kconfig b/security/keys/Kconfig
index 8ffe822..14f9683 100644
--- a/security/keys/Kconfig
+++ b/security/keys/Kconfig
@@ -117,3 +117,12 @@ config CRYPTO_KEY_PGP_PARSER
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
diff --git a/security/keys/Makefile b/security/keys/Makefile
index c7fa7ea..a25bf48 100644
--- a/security/keys/Makefile
+++ b/security/keys/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_CRYPTO_KEY_PUBLIC_KEY_SUBTYPE) += public_key.o
 obj-$(CONFIG_CRYPTO_KEY_PKEY_ALGO_DSA) += crypto_dsa.o
 obj-$(CONFIG_CRYPTO_KEY_PKEY_ALGO_RSA) += crypto_rsa.o
 obj-$(CONFIG_PGP_LIBRARY) += pgp_library.o
+obj-$(CONFIG_PGP_PRELOAD) += pgp_preload.o
 obj-$(CONFIG_CRYPTO_KEY_PGP_PARSER) += pgp_parser.o
 
 crypto_keys-y := crypto_type.o crypto_verify.o
diff --git a/security/keys/pgp_preload.c b/security/keys/pgp_preload.c
new file mode 100644
index 0000000..25154e3
--- /dev/null
+++ b/security/keys/pgp_preload.c
@@ -0,0 +1,90 @@
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
+#include <linux/pgp.h>
+#include "crypto_keys.h"
+
+struct preload_pgp_keys_context {
+	struct pgp_parse_context pgp;
+	key_ref_t keyring;
+	char descbuf[20];
+	u8 key_n;
+	u8 dsize;
+};
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
+	key_ref_t key;
+
+	sprintf(ctx->descbuf + ctx->dsize, "%d", ctx->key_n++);
+
+	key = key_create_or_update(ctx->keyring, "crypto", ctx->descbuf,
+				   data - headerlen, datalen + headerlen,
+				   KEY_POS_ALL | KEY_USR_VIEW,
+				   KEY_ALLOC_NOT_IN_QUOTA);
+
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
+/**
+ * preload_pgp_keys - Load keys from a PGP keyring blob
+ * @pgpdata: The PGP keyring blob containing the keys.
+ * @pgpdatalen: The size of the @pgpdata blob.
+ * @keyring: The keyring to add the new keys to.
+ * @descprefix: The key description prefix.
+ *
+ * Preload a pack of keys from a PGP keyring blob.
+ *
+ * The keys are given description of @descprefix + the number of the key in the
+ * list.  Since keys can be matched on their key IDs independently of the key
+ * description, the description is mostly irrelevant apart from the fact that
+ * keys of the same description displace one another from a keyring.
+ *
+ * The caller should override the current creds if they want the keys to be
+ * owned by someone other than the current process's owner.  Keys will not be
+ * accounted towards the owner's quota.
+ *
+ * This function may only be called whilst the kernel is booting.
+ */
+int __init preload_pgp_keys(const u8 *pgpdata, size_t pgpdatalen,
+			    struct key *keyring, const char *descprefix)
+{
+	struct preload_pgp_keys_context ctx;
+
+	ctx.pgp.types_of_interest =
+		(1 << PGP_PKT_PUBLIC_KEY) | (1 << PGP_PKT_PUBLIC_SUBKEY);
+	ctx.pgp.process_packet = found_pgp_key;
+	ctx.keyring = make_key_ref(keyring, 1);
+	ctx.key_n = 0;
+	ctx.dsize = strlen(descprefix);
+	strcpy(ctx.descbuf, descprefix);
+
+	return pgp_parse_packets(pgpdata, pgpdatalen, &ctx.pgp);
+}

