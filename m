Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987Ab2EJXk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:40:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891Ab2EJXkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:40:19 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/29] KEYS: Add signature verification facility [ver #4]
To: rusty@rustcorp.com.au
Cc: kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        David Howells <dhowells@redhat.com>
Date: Fri, 11 May 2012 00:40:07 +0100
Message-ID: <20120510234007.4137.76564.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
References: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a facility whereby a key subtype may be asked to verify a signature against
the data it is purported to have signed.

This adds four routines:

 (1) struct crypto_key_verify_context *
     verify_sig_begin(struct key *keyring, const void *sig, size_t siglen);

     This sets up a verification context for the given signature using
     information in that signature to select a key from the specified keyring
     and to request a hash algorithm from the crypto layer.

 (2) int verify_sig_add_data(struct crypto_key_verify_context *ctx,
			     const void *data, size_t datalen);

     Incrementally supply data to be signed.  May be called multiple times.

 (3) int verify_sig_end(struct crypto_key_verify_context *ctx,
			const void *sig, size_t siglen);

     Complete the verification process and return the result.  -EKEYREJECTED
     will indicate that the verification failed and 0 will indicate success.
     Other errors are also possible.

 (4) void verify_sig_cancel(struct crypto_key_verify_context *ctx);

     Cancel the verification process.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/security/keys-crypto.txt |  101 +++++++++++++++++++++++++++++
 include/keys/crypto-subtype.h          |   21 ++++++
 include/keys/crypto-type.h             |    9 +++
 security/keys/crypto/Makefile          |    2 -
 security/keys/crypto/crypto_verify.c   |  111 ++++++++++++++++++++++++++++++++
 5 files changed, 243 insertions(+), 1 deletions(-)
 create mode 100644 security/keys/crypto/crypto_verify.c


diff --git a/Documentation/security/keys-crypto.txt b/Documentation/security/keys-crypto.txt
index 97dee80..a964717 100644
--- a/Documentation/security/keys-crypto.txt
+++ b/Documentation/security/keys-crypto.txt
@@ -7,6 +7,7 @@ Contents:
   - Overview.
   - Key identification.
   - Accessing crypto keys.
+    - Signature verification.
   - Implementing crypto parsers.
   - Implementing crypto subtypes.
 
@@ -89,6 +90,65 @@ This gives access to the key type:
 	struct key_type key_type_crypto;
 
 
+SIGNATURE VERIFICATION
+----------------------
+
+The four operations that can perform cryptographic signature verification,
+using one of a set of keys to provide the public key:
+
+ (1) Begin verification procedure.
+
+	struct crypto_key_verify_context *
+	verify_sig_begin(struct key *keyring, const void *sig, size_t siglen);
+
+     This function sets up a verification context from the information in the
+     signature and looks for a suitable key in the keyring.  The signature blob
+     must be presented again at the end of the procedure.  The keys will be
+     checked against parameters in the signature, and if the matching one is
+     not found then -ENOKEY will be returned.
+
+     The hashing algorithm, if such a thing applies, will be determined from
+     information in the signature and the appropriate crypto module will be
+     used.  -ENOPKG will be returned if the hash algorithm is unavailable.
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
 ===========================
 IMPLEMENTING CRYPTO PARSERS
 ===========================
@@ -96,6 +156,7 @@ IMPLEMENTING CRYPTO PARSERS
 The crypto key type keeps a list of registered data parsers.  An example of
 such a parser is one that parses OpenPGP packet formatted data [RFC 4880].
 
+
 During key instantiation each parser in the list is tried until one doesn't
 return -EBADMSG.
 
@@ -107,6 +168,8 @@ The parser definition structure looks like the following:
 
 		int (*instantiate)(struct key *key,
 				   const void *data, size_t datalen);
+		struct crypto_key_verify_context *(*verify_sig_begin)(
+			struct key *keyring, const u8 *sig, size_t siglen);
 	};
 
 The owner and name fields should be set to the owning module and the name of
@@ -135,6 +198,44 @@ but it is expected that at least one will be defined.
      algorithm such as RSA and DSA this will likely be a printable hex version
      of the key's fingerprint.
 
+ (2) verify_sig_begin().
+
+     This is similar in concept to the instantiate() function, except that it
+     is given a signature blob to parse rather than a key data blob.
+
+     If the data format is not recognised, -EBADMSG should be returned.  If it
+     is recognised, but the signature verification process cannot for some
+     reason be set up, some other negative error code should be returned.
+     -ENOKEY should be used to indicate that no matching key is available and
+     -ENOPKG should be returned if the hash algorithm or the verification
+     algorithm are unavailable.
+
+     If successful, the parser should allocate a verification context and embed
+     the following struct in it:
+
+	struct crypto_key_verify_context {
+		struct key *key;
+		int (*add_data)(struct crypto_key_verify_context *ctx,
+				const void *data, size_t datalen);
+		int (*end)(struct crypto_key_verify_context *ctx,
+			   const u8 *sig, size_t siglen);
+		void (*cancel)(struct crypto_key_verify_context *ctx);
+	};
+
+     and return a pointer to this to the caller, who will then pass it to the
+     verification operation wrappers described in the "Signature Verification"
+     section.  The three operation pointers here correspond exactly to those
+     wrappers and are all mandatory.  container_of() should be used to retrieve
+     the actual context.
+
+     Note that the crypto key type retains a reference on the parser module for
+     the lifetime of this context, though the operation pointers need not point
+     into this module.
+
+     The parser should also record a pointer to the key selected and take a
+     reference on that key with key_get().
+
+
 Functions are provided to register and unregister parsers:
 
 	int register_crypto_key_parser(struct crypto_key_parser *parser);
diff --git a/include/keys/crypto-subtype.h b/include/keys/crypto-subtype.h
index fa87555..f2b927a 100644
--- a/include/keys/crypto-subtype.h
+++ b/include/keys/crypto-subtype.h
@@ -20,6 +20,20 @@
 extern struct key_type key_type_crypto;
 
 /*
+ * Context base for signature verification methods.  Allocated by the subtype
+ * and presumably embedded in something appropriate.
+ */
+struct crypto_key_verify_context {
+	struct key *key;
+	struct crypto_key_parser *parser;
+	int (*add_data)(struct crypto_key_verify_context *ctx,
+			const void *data, size_t datalen);
+	int (*end)(struct crypto_key_verify_context *ctx,
+		   const u8 *sig, size_t siglen);
+	void (*cancel)(struct crypto_key_verify_context *ctx);
+};
+
+/*
  * Keys of this type declare a subtype that indicates the handlers and
  * capabilities.
  */
@@ -48,6 +62,13 @@ struct crypto_key_parser {
 	 * Return EBADMSG if not recognised.
 	 */
 	int (*instantiate)(struct key *key, const void *data, size_t datalen);
+
+	/* Attempt to recognise a signature blob and find a matching key.
+	 *
+	 * Return EBADMSG if not recognised.
+	 */
+	struct crypto_key_verify_context *(*verify_sig_begin)(
+		struct key *keyring, const u8 *sig, size_t siglen);
 };
 
 extern int register_crypto_key_parser(struct crypto_key_parser *);
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
diff --git a/security/keys/crypto/Makefile b/security/keys/crypto/Makefile
index 36db1d5..67001bc 100644
--- a/security/keys/crypto/Makefile
+++ b/security/keys/crypto/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_CRYPTO_KEY_TYPE) += crypto_keys.o
 
-crypto_keys-y := crypto_type.o
+crypto_keys-y := crypto_type.o crypto_verify.o
diff --git a/security/keys/crypto/crypto_verify.c b/security/keys/crypto/crypto_verify.c
new file mode 100644
index 0000000..65f734c
--- /dev/null
+++ b/security/keys/crypto/crypto_verify.c
@@ -0,0 +1,111 @@
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
+#include <linux/module.h>
+#include "crypto_keys.h"
+
+/**
+ * verify_sig_begin - Initiate the use of a crypto key to verify a signature
+ * @keyring: The public keys to verify against
+ * @sig: The signature data
+ * @siglen: The signature length
+ *
+ * Returns a context or an error.
+ */
+struct crypto_key_verify_context *verify_sig_begin(
+	struct key *keyring, const void *sig, size_t siglen)
+{
+	struct crypto_key_verify_context *ret;
+	struct crypto_key_parser *parser;
+
+	pr_devel("==>%s()\n", __func__);
+
+	if (siglen == 0 || !sig)
+		return ERR_PTR(-EINVAL);
+
+	down_read(&crypto_key_parsers_sem);
+
+	ret = ERR_PTR(-EBADMSG);
+	list_for_each_entry(parser, &crypto_key_parsers, link) {
+		if (parser->verify_sig_begin) {
+			if (!try_module_get(parser->owner))
+				continue;
+
+			pr_debug("Trying parser '%s'\n", parser->name);
+
+			ret = parser->verify_sig_begin(keyring, sig, siglen);
+			if (IS_ERR(ret))
+				module_put(parser->owner);
+			else
+				ret->parser = parser;
+			if (ret != ERR_PTR(-EBADMSG)) {
+				pr_debug("Parser recognised the format"
+					 " (ret %ld)\n",
+					 PTR_ERR(ret));
+				break;
+			}
+		}
+	}
+
+	up_read(&crypto_key_parsers_sem);
+	pr_devel("<==%s() = %p\n", __func__, ret);
+	return ret;
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
+	return ctx->add_data(ctx, data, datalen);
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
+	struct crypto_key_parser *parser = ctx->parser;
+	int ret;
+
+	ret = ctx->end(ctx, sig, siglen);
+	module_put(parser->owner);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(verify_sig_end);
+
+/**
+ * verify_sig_end - Cancel signature verification
+ * @ctx: The context from verify_sig_begin()
+ */
+void verify_sig_cancel(struct crypto_key_verify_context *ctx)
+{
+	struct crypto_key_parser *parser = ctx->parser;
+
+	ctx->cancel(ctx);
+	module_put(parser->owner);
+}
+EXPORT_SYMBOL_GPL(verify_sig_cancel);

