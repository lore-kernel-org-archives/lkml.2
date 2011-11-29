Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108Ab1K2Xx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 18:53:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756855Ab1K2XxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 18:53:20 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 09/16] KEYS: Add signature verification facility [ver #2]
To: keyrings@linux-nfs.org
Cc: linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
        alan.cox@intel.com, David Howells <dhowells@redhat.com>
Date: Tue, 29 Nov 2011 23:44:52 +0000
Message-ID: <20111129234452.13625.40158.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111129234258.13625.21153.stgit@warthog.procyon.org.uk>
References: <20111129234258.13625.21153.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a facility whereby a key subtype may be asked to verify a signature against
the data it is purported to have signed.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/security/keys-crypto.txt |  106 +++++++++++++++++++++++++++++++-
 include/keys/crypto-subtype.h          |   15 +++++
 include/keys/crypto-type.h             |    9 +++
 security/keys/Makefile                 |    2 -
 security/keys/crypto_verify.c          |   87 ++++++++++++++++++++++++++
 5 files changed, 214 insertions(+), 5 deletions(-)
 create mode 100644 security/keys/crypto_verify.c


diff --git a/Documentation/security/keys-crypto.txt b/Documentation/security/keys-crypto.txt
index 44c936a..236d750 100644
--- a/Documentation/security/keys-crypto.txt
+++ b/Documentation/security/keys-crypto.txt
@@ -8,7 +8,9 @@ Contents:
   - Key identification.
   - Crypto subtypes.
   - Accessing crypto keys.
+    - Signature verification.
   - Implementing crypto subtypes.
+    - Registration.
 
 
 ========
@@ -98,14 +100,69 @@ This gives access to the key type:
 	struct key_type key_type_crypto;
 
 
+SIGNATURE VERIFICATION
+----------------------
+
+The four operations that can perform cryptographic signature verification,
+using a key to provide the public key:
+
+ (1) Begin verification procedure.
+
+	struct crypto_key_verify_context *
+	verify_sig_begin(struct key *key, const void *sig, size_t siglen);
+
+     This function sets up a verification context from the specified key and
+     the signature blob.  The signature blob must be presented again at the end
+     of the procedure.  The key is checked against parameters in the signature,
+     and if it's not the right key then an error will be given.
+
+     If such a thing applies, the hashing algorithm, will be extracted from the
+     signature and the appropriate crypto module will be used.  -ENOPKG will be
+     returned if the hash algorithm is unavailable.
+
+     The return value is an opaque pointer to be passed to the other functions,
+     or a negative error code.
+
+ (2) Indicate data to be verified.
+
+	int verify_sig_add_data(struct crypto_key_verify_context *ctx,
+				const void *data, size_t datalen);
+
+     This function is used to shovel data to the verification procedure so that
+     it can load it into the hash, pass it to hardware or whatever is
+     appropriate for the algorithm being employed.
+
+     The data is not canonicalised for the document type specified in the
+     signature.  The caller must do that.
+
+     It will return 0 if successful and a negative error code if not.
+
+ (3) Complete the verification process.
+
+	int verify_sig_end(struct crypto_key_verify_context *ctx,
+			   const void *sig, size_t siglen);
+
+     This function performs the actual signature verification step and cleans
+     up the resources allocated at the beginning.  The signature must be
+     presented again as some of the data therein may need to be added to the
+     internal hash.
+
+     It will return -EKEYREJECTED if the signature didn't match, 0 if
+     successful and may return other errors as appropriate.
+
+ (4) Cancel the verification process.
+
+	void verify_sig_cancel(struct crypto_key_verify_context *ctx);
+
+     This function cleans up the resources allocated at the beginning.  This is
+     not necessary if verify_sig_end() was called.
+
+
 ============================
 IMPLEMENTING CRYPTO SUBTYPES
 ============================
 
-If a suitable subtype is found, then key->type_data.p[0] is set to point to the
-subtype definition and the module usage count is incremented.
-
-The subtype definition structure looks like the following:
+Each subtype is specified through a definition structure:
 
 	struct crypto_key_subtype {
 		struct module		*owner;
@@ -118,6 +175,14 @@ The subtype definition structure looks like the following:
 
 		void (*revoke)(struct key *key);
 		void (*destroy)(struct key *key);
+
+		struct crypto_key_verify_context *(*verify_sig_begin)(
+			struct key *key, const u8 *sig, size_t siglen);
+		int (*verify_sig_add_data)(struct crypto_key_verify_context *ctx,
+					   const void *data, size_t datalen);
+		int (*verify_sig_end)(struct crypto_key_verify_context *ctx,
+				      const u8 *sig, size_t siglen);
+		void (*verify_sig_cancel)(struct crypto_key_verify_context *ctx);
 	};
 
 The owner and name fields should be set to the owning module and the name of
@@ -160,6 +225,39 @@ management of the key itself:
      must free whatever key->payload refers to.
 
 
+There are then sets of method pointers to actually use the key for things:
+
+ (*) Signature verification
+
+     Then there are functions to verify a signature using the public key stored in
+     this key:
+
+	(1) verify_sig_begin().
+	(2) verify_sig_add_data().
+	(3) verify_sig_end().
+	(4) verify_sig_cancel().
+
+     These correspond to the accessor functions mentioned in the previous
+     section.  The first function is optional - if it is not provided, then
+     verification is not a service available with this key.  The other three
+     are mandatory if the first is supplied and unnecessary otherwise.
+
+     The subtype should allocate a context in ->verify_sig_begin() and embed
+     the following struct in it:
+
+	struct crypto_key_verify_context {
+		struct key *key;
+	};
+
+     A pointer to this struct is then returned to the caller.  This is used by
+     the master routines to route the operations to the right place.  This is
+     passed to the _add_data, _end and _cancel routines - which should use
+     container_of() on it to get the full context.
+
+
+REGISTRATION
+------------
+
 Functions are provided to register and unregister key subtypes:
 
 	int register_crypto_key_subtype(struct crypto_key_subtype *subtype);
diff --git a/include/keys/crypto-subtype.h b/include/keys/crypto-subtype.h
index 218cb2b..76dbd50 100644
--- a/include/keys/crypto-subtype.h
+++ b/include/keys/crypto-subtype.h
@@ -20,6 +20,14 @@
 extern struct key_type key_type_crypto;
 
 /*
+ * Context base for signature verification methods.  Allocated by the subtype
+ * and presumably embedded in something appropriate.
+ */
+struct crypto_key_verify_context {
+	struct key *key;
+};
+
+/*
  * Keys of this type declare a subtype that indicates the handlers and
  * capabilities.
  */
@@ -38,6 +46,13 @@ struct crypto_key_subtype {
 	void (*revoke)(struct key *key);
 	void (*destroy)(struct key *key);
 
+	struct crypto_key_verify_context *(*verify_sig_begin)(
+		struct key *key, const u8 *sig, size_t siglen);
+	int (*verify_sig_add_data)(struct crypto_key_verify_context *ctx,
+				   const void *data, size_t datalen);
+	int (*verify_sig_end)(struct crypto_key_verify_context *ctx,
+			      const u8 *sig, size_t siglen);
+	void (*verify_sig_cancel)(struct crypto_key_verify_context *ctx);
 };
 
 extern int register_crypto_key_subtype(struct crypto_key_subtype *);
diff --git a/include/keys/crypto-type.h b/include/keys/crypto-type.h
index 47c00c7..6b93366 100644
--- a/include/keys/crypto-type.h
+++ b/include/keys/crypto-type.h
@@ -18,6 +18,15 @@
 
 extern struct key_type key_type_crypto;
 
+struct crypto_key_verify_context;
+extern struct crypto_key_verify_context *verify_sig_begin(
+	struct key *key, const void *sig, size_t siglen);
+extern int verify_sig_add_data(struct crypto_key_verify_context *ctx,
+			       const void *data, size_t datalen);
+extern int verify_sig_end(struct crypto_key_verify_context *ctx,
+			  const void *sig, size_t siglen);
+extern void verify_sig_cancel(struct crypto_key_verify_context *ctx);
+
 /*
  * The payload is at the discretion of the subtype.
  */
diff --git a/security/keys/Makefile b/security/keys/Makefile
index 0cb7d08..8f48527 100644
--- a/security/keys/Makefile
+++ b/security/keys/Makefile
@@ -22,6 +22,6 @@ obj-$(CONFIG_KEYS_COMPAT) += compat.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_SYSCTL) += sysctl.o
 
-crypto_keys-y	:= crypto_type.o pgp_parse.o
+crypto_keys-y	:= crypto_type.o pgp_parse.o crypto_verify.o
 crypto_dsa-y	:= crypto_dsa_subtype.o
 crypto_rsa-y	:= crypto_rsa_subtype.o
diff --git a/security/keys/crypto_verify.c b/security/keys/crypto_verify.c
new file mode 100644
index 0000000..ac97cc9
--- /dev/null
+++ b/security/keys/crypto_verify.c
@@ -0,0 +1,87 @@
+/* Signature verification with a crypto key
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
+#include "crypto_keys.h"
+
+/**
+ * verify_sig_begin - Initiate the use of a crypto key to verify a signature
+ * @key: The public key to verify against
+ * @sig: The signature data
+ * @siglen: The signature length
+ *
+ * Returns a context or an error.
+ */
+struct crypto_key_verify_context *verify_sig_begin(
+	struct key *key, const void *sig, size_t siglen)
+{
+	const struct crypto_key_subtype *subtype = crypto_key_subtype(key);
+
+	if (!subtype || !subtype->verify_sig_begin)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	return subtype->verify_sig_begin(key, sig, siglen);
+}
+EXPORT_SYMBOL_GPL(verify_sig_begin);
+
+/**
+ * verify_sig_add_data - Incrementally provide data to be verified
+ * @ctx: The context from verify_sig_begin()
+ * @data: Data
+ * @datalen: The amount of @data
+ *
+ * This may be called multiple times.
+ */
+int verify_sig_add_data(struct crypto_key_verify_context *ctx,
+			const void *data, size_t datalen)
+{
+	const struct crypto_key_subtype *subtype;
+
+	BUG_ON(!ctx);
+	subtype = crypto_key_subtype(ctx->key);
+	return subtype->verify_sig_add_data(ctx, data, datalen);
+}
+EXPORT_SYMBOL_GPL(verify_sig_add_data);
+
+/**
+ * verify_sig_end - Finalise signature verification and return result
+ * @ctx: The context from verify_sig_begin()
+ * @sig: The signature data
+ * @siglen: The signature length
+ */
+int verify_sig_end(struct crypto_key_verify_context *ctx,
+		   const void *sig, size_t siglen)
+{
+	const struct crypto_key_subtype *subtype;
+
+	BUG_ON(!ctx);
+	subtype = crypto_key_subtype(ctx->key);
+	return subtype->verify_sig_end(ctx, sig, siglen);
+}
+EXPORT_SYMBOL_GPL(verify_sig_end);
+
+/**
+ * verify_sig_end - Cancel signature verification
+ * @ctx: The context from verify_sig_begin()
+ */
+void verify_sig_cancel(struct crypto_key_verify_context *ctx)
+{
+	const struct crypto_key_subtype *subtype;
+
+	BUG_ON(!ctx);
+	subtype = crypto_key_subtype(ctx->key);
+	subtype->verify_sig_cancel(ctx);
+}
+EXPORT_SYMBOL_GPL(verify_sig_cancel);

