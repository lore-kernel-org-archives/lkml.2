Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab1K1Pp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 10:45:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244Ab1K1PpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:45:23 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 04/14] KEYS: Create a key type that can be used for general
 cryptographic operations
To: keyrings@linux-nfs.org
Cc: linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, mitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
        alan.cox@intel.com, David Howells <dhowells@redhat.com>
Date: Mon, 28 Nov 2011 15:45:13 +0000
Message-ID: <20111128154513.6009.9959.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111128154436.6009.77586.stgit@warthog.procyon.org.uk>
References: <20111128154436.6009.77586.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a key type that can be used for general cryptographic operations, such
as encryption, decryption, signature generation and signature verification.

The key type is "crypto" and can provide access to a variety of cryptographic
algorithms.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/security/keys-crypto.txt |  170 +++++++++++++++++
 include/keys/crypto-subtype.h          |   46 +++++
 include/keys/crypto-type.h             |   25 ++
 security/Kconfig                       |    8 +
 security/keys/Makefile                 |    3 
 security/keys/crypto_keys.h            |   21 ++
 security/keys/crypto_type.c            |  322 ++++++++++++++++++++++++++++++++
 7 files changed, 595 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/security/keys-crypto.txt
 create mode 100644 include/keys/crypto-subtype.h
 create mode 100644 include/keys/crypto-type.h
 create mode 100644 security/keys/crypto_keys.h
 create mode 100644 security/keys/crypto_type.c


diff --git a/Documentation/security/keys-crypto.txt b/Documentation/security/keys-crypto.txt
new file mode 100644
index 0000000..44c936a
--- /dev/null
+++ b/Documentation/security/keys-crypto.txt
@@ -0,0 +1,170 @@
+			    ======================
+			    CRYPTOGRAPHIC KEY TYPE
+			    ======================
+
+Contents:
+
+  - Overview.
+  - Key identification.
+  - Crypto subtypes.
+  - Accessing crypto keys.
+  - Implementing crypto subtypes.
+
+
+========
+OVERVIEW
+========
+
+The "crypto" key type is designed to be a container for cryptographic keys,
+without imposing any particular restrictions on the form of the cryptography or
+the key.
+
+The crypto key is given a subtype that defines what sort of data is associated
+with the key and what operations might be performed with it.  However, no
+requirement is made that the key data actually be loaded into the key or that
+the operations are done by the kernel.
+
+For instance, cryptographic hardware (such as a TPM) might be used to both
+retain the relevant key and provide operations using that key.  In such a case,
+the crypto key would then merely be an interface to the TPM driver.
+
+
+==================
+KEY IDENTIFICATION
+==================
+
+Because the identity of a key is not necessarily known or is not easily
+calculated when a crypto key is allocated, it may not be a simple matter to set
+a key description to something that's useful for determining whether this is
+the key you're looking for.  Furthermore, it may be necessary to perform a
+partial match upon the key identity.
+
+To help with this, when a key is loaded, the key subtype's instantiation
+routine calculates the key fingerprint and stores a copy in the key struct.
+
+The crypto key type's key matching function then performs more checks than just
+the straightforward comparison of the description with the criterion string:
+
+ (1) If the criterion string is of the form "id:<hexdigits>" then the match
+     function will examine a key's fingerprint to see if the hex digits given
+     after the "id:" match the tail.  For instance:
+
+	keyctl search @s crypto id:5acc2142
+
+     will match a key with fingerprint:
+
+	1A00 2040 7601 7889 DE11  882C 3823 04AD 5ACC 2142
+
+ (2) If the criterion string is of the form "<subtype>:<hexdigits>" then the
+     match will match the ID as in (1), but with the added restriction that
+     only keys of the specified subtype (e.g. dsa or rsa) will be matched.  For
+     instance:
+
+	keyctl search @s crypto dsa:5acc2142
+
+Looking in /proc/keys, the last 8 hex digits of the key fingerprint are
+displayed, along with the subtype:
+
+	1a39e171 I-----     1 perm 3f010000     0     0 crypto    modsign.0: dsa 5acc2142 []
+
+
+===============
+CRYPTO SUBTYPES
+===============
+
+The crypto key is just a simple container.  It contains no data of its own and
+does very little except provide a place to hang a function pointer table.  The
+key subtype does the actual work.
+
+When a crypto key is instantiated, it looks through its list of registered
+subtypes to try and find one that can handle the data blob it is given.  If the
+data blob begins with a byte with the top bit set, it is assumed to be a PGP
+packet format blob [RFC 4880] and is treated so.  The blob is parsed to find a
+PGP key, and then a subtype is looked for that says it can handle the
+appropriate algorithm type.
+
+
+=====================
+ACCESSING CRYPTO KEYS
+=====================
+
+To access crypto keys from within the kernel, the following inclusion is
+required:
+
+	#include <keys/crypto-type.h>
+
+This gives access to the key type:
+
+	struct key_type key_type_crypto;
+
+
+============================
+IMPLEMENTING CRYPTO SUBTYPES
+============================
+
+If a suitable subtype is found, then key->type_data.p[0] is set to point to the
+subtype definition and the module usage count is incremented.
+
+The subtype definition structure looks like the following:
+
+	struct crypto_key_subtype {
+		struct module		*owner;
+		const char		*name;
+		enum pgp_pubkey_algo	pubkey_algo : 8;
+		unsigned short		info;
+
+		int (*instantiate)(struct key *key,
+				   const void *data, size_t datalen);
+
+		void (*revoke)(struct key *key);
+		void (*destroy)(struct key *key);
+	};
+
+The owner and name fields should be set to the owning module and the name of
+the subtype.
+
+If the subtype represents a PGP public key algorithm the info field should have
+CRYPTO_KEY_IS_PUBKEY_ALGO OR'd into it and pubkey_algo should be set to the
+appropriate PGP_PUBKEY_ constant from the enumeration in <linux/pgp.h>.
+
+
+There are a number of operations defined by the subtype.  The first few are for
+management of the key itself:
+
+ (1) instantiate().
+
+     Mandatory.  When the subtype is selected, the instantiate() method will be
+     given the key being instantiated and the data blob.  If the first byte of
+     the data blob has bit 7 set, then it's a PGP packet blob and can be parsed
+     with the routines declared in <linux/pgp.h>.
+
+     If the key has a fingerprint or other auxiliary identifier, this should be
+     determined or calculated and a copy attached to key->type_data.p[1].
+
+     If successful, the subtype must set key->type_data.p[0] to point to its
+     definition.
+
+     The subtype may use key->payload in anyway it sees fit.
+
+ (2) revoke().
+
+     Optional.  Notification that the key has been revoked.  This provides the
+     subtype the opportunity to discard some memory, but care should be taken
+     as the key may be in use when this is called.
+
+ (3) destroy().
+
+     Mandatory.  key->type_data.p[0] is cleared by the caller and the module
+     usage will be decremented upon return.  The memory pointed to by
+     key->type_data.[1] will be freed after this method returns.  This method
+     must free whatever key->payload refers to.
+
+
+Functions are provided to register and unregister key subtypes:
+
+	int register_crypto_key_subtype(struct crypto_key_subtype *subtype);
+	void unregister_crypto_key_subtype(struct crypto_key_subtype *subtype);
+
+Key subtypes may have the same name, provided they differ in some other
+criterion, such as the public key algorithm ID.  This makes it possible to
+handle algorithms such as RSA that have multiple algorithm IDs.
diff --git a/include/keys/crypto-subtype.h b/include/keys/crypto-subtype.h
new file mode 100644
index 0000000..218cb2b
--- /dev/null
+++ b/include/keys/crypto-subtype.h
@@ -0,0 +1,46 @@
+/* Cryptographic key subtype
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
+#ifndef _KEYS_CRYPTO_SUBTYPE_H
+#define _KEYS_CRYPTO_SUBTYPE_H
+
+#include <keys/crypto-type.h>
+#include <linux/pgp.h>
+
+extern struct key_type key_type_crypto;
+
+/*
+ * Keys of this type declare a subtype that indicates the handlers and
+ * capabilities.
+ */
+struct crypto_key_subtype {
+	struct list_head	link;
+	struct module		*owner;
+	const char		*name;
+	enum pgp_pubkey_algo	pubkey_algo : 8;
+	unsigned short		info;
+#define CRYPTO_KEY_IS_PUBKEY_ALGO	0x1U
+	unsigned short		name_len;	/* length of name */
+
+	int (*instantiate)(struct key *key,
+			   const void *data, size_t datalen);
+
+	void (*revoke)(struct key *key);
+	void (*destroy)(struct key *key);
+
+};
+
+extern int register_crypto_key_subtype(struct crypto_key_subtype *);
+extern void unregister_crypto_key_subtype(struct crypto_key_subtype *);
+
+#endif /* _KEYS_CRYPTO_SUBTYPE_H */
diff --git a/include/keys/crypto-type.h b/include/keys/crypto-type.h
new file mode 100644
index 0000000..47c00c7
--- /dev/null
+++ b/include/keys/crypto-type.h
@@ -0,0 +1,25 @@
+/* Cryptographic key type interface
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
+#ifndef _KEYS_CRYPTO_TYPE_H
+#define _KEYS_CRYPTO_TYPE_H
+
+#include <linux/key-type.h>
+
+extern struct key_type key_type_crypto;
+
+/*
+ * The payload is at the discretion of the subtype.
+ */
+
+#endif /* _KEYS_CRYPTO_TYPE_H */
diff --git a/security/Kconfig b/security/Kconfig
index 51bd5a0..ef39878 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -54,6 +54,14 @@ config ENCRYPTED_KEYS
 
 	  If you are unsure as to whether this is required, answer N.
 
+config CRYPTO_KEY_TYPE
+	tristate "Cryptographic key type"
+	depends on KEYS
+	help
+	  This option provides support for a type of key that holds the keys
+	  required for cryptographic operations such as encryption, decryption,
+	  signature generation and signature verification.
+
 config KEYS_DEBUG_PROC_KEYS
 	bool "Enable the /proc/keys file by which keys may be viewed"
 	depends on KEYS
diff --git a/security/keys/Makefile b/security/keys/Makefile
index a56f1ff..ca85b01 100644
--- a/security/keys/Makefile
+++ b/security/keys/Makefile
@@ -15,6 +15,9 @@ obj-y := \
 
 obj-$(CONFIG_TRUSTED_KEYS) += trusted.o
 obj-$(CONFIG_ENCRYPTED_KEYS) += encrypted-keys/
+obj-$(CONFIG_CRYPTO_KEY_TYPE) += crypto_keys.o
 obj-$(CONFIG_KEYS_COMPAT) += compat.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_SYSCTL) += sysctl.o
+
+crypto_keys-y	:= crypto_type.o pgp_parse.o
diff --git a/security/keys/crypto_keys.h b/security/keys/crypto_keys.h
new file mode 100644
index 0000000..12db62a
--- /dev/null
+++ b/security/keys/crypto_keys.h
@@ -0,0 +1,21 @@
+/* Internal crypto type stuff
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
+static inline
+struct crypto_key_subtype *crypto_key_subtype(const struct key *key)
+{
+	return key->type_data.p[0];
+}
+
+static inline char *crypto_key_id(const struct key *key)
+{
+	return key->type_data.p[1];
+}
diff --git a/security/keys/crypto_type.c b/security/keys/crypto_type.c
new file mode 100644
index 0000000..3ab9e5e
--- /dev/null
+++ b/security/keys/crypto_type.c
@@ -0,0 +1,322 @@
+/* Cryptographic key type
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
+#define __KDEBUG
+#include <keys/crypto-subtype.h>
+#include <linux/seq_file.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/pgp.h>
+#include "crypto_keys.h"
+#include "internal.h"
+
+MODULE_LICENSE("GPL");
+
+static LIST_HEAD(crypto_key_subtypes);
+static DECLARE_RWSEM(crypto_key_subtypes_sem);
+
+/*
+ * Match crypto_keys on (part of) their name
+ * We have some shorthand methods for matching keys.  We allow:
+ *
+ *	"<desc>"	- request a key by description
+ *	"id:<id>"	- request a key matching the ID
+ *	"<subtype>:<id>" - request a key of a subtype
+ */
+static int crypto_key_match(const struct key *key, const void *description)
+{
+	const struct crypto_key_subtype *subtype = crypto_key_subtype(key);
+	const char *spec = description;
+	const char *id, *kid;
+	ptrdiff_t speclen;
+	size_t idlen, kidlen;
+
+	if (!subtype || !spec || !*spec)
+		return 0;
+
+	/* See if the full key description matches as is */
+	if (key->description && strcmp(key->description, description) == 0)
+		return 1;
+
+	/* All tests from here on break the criterion description into a
+	 * specifier, a colon and then an identifier.
+	 */
+	id = strchr(spec, ':');
+	if (!id)
+		return 0;
+
+	speclen = id - spec;
+	id++;
+
+	/* Anything after here requires a partial match on the ID string */
+	kid = crypto_key_id(key);
+	if (!kid)
+		return 0;
+
+	idlen = strlen(id);
+	kidlen = strlen(kid);
+	if (idlen > kidlen)
+		return 0;
+
+	kid += kidlen - idlen;
+	if (strcasecmp(id, kid) != 0)
+		return 0;
+
+	if (speclen == 2 &&
+	    memcmp(spec, "id", 2) == 0)
+		return 1;
+
+	if (speclen == subtype->name_len &&
+	    memcmp(spec, subtype->name, speclen) == 0)
+		return 1;
+
+	return 0;
+}
+
+/*
+ * Describe the crypto key
+ */
+static void crypto_key_describe(const struct key *key, struct seq_file *m)
+{
+	const struct crypto_key_subtype *subtype = crypto_key_subtype(key);
+	const char *kid = crypto_key_id(key);
+	size_t n;
+
+	seq_puts(m, key->description);
+
+	if (subtype) {
+		seq_puts(m, ": ");
+		seq_puts(m, subtype->name);
+
+		if (kid) {
+			seq_putc(m, ' ');
+			n = strlen(kid);
+			if (n <= 8)
+				seq_puts(m, kid);
+			else
+				seq_puts(m, kid + n - 8);
+		}
+
+		seq_puts(m, " [");
+		/* put something here to indicate the key's capabilities */
+		seq_putc(m, ']');
+	}
+}
+
+struct crypto_key_parse_context {
+	struct pgp_parse_context pgp;
+	enum pgp_pubkey_algo *pubkey_algo;
+};
+
+/*
+ * Extract a public key or subkey from the PGP stream.
+ */
+static int crypto_key_pgp_parse_public_key(struct pgp_parse_context *context,
+					   enum pgp_packet_tag type,
+					   u8 headerlen,
+					   const u8 *data,
+					   size_t datalen)
+{
+	struct crypto_key_parse_context *ctx =
+		container_of(context, struct crypto_key_parse_context, pgp);
+	struct pgp_parse_pubkey pgp;
+	int ret;
+
+	ret = pgp_parse_public_key(&data, &datalen, &pgp);
+	if (ret < 0)
+		return ret;
+	*ctx->pubkey_algo = pgp.pubkey_algo;
+	return -EEXIST; /* Signal we found what we were looking for */
+}
+
+/*
+ * Treat as a PGP blob
+ */
+static int crypto_key_is_pgp(const void *data, size_t datalen,
+			     enum pgp_pubkey_algo *algo)
+{
+	struct crypto_key_parse_context ctx;
+	int ret;
+
+	ctx.pgp.types_of_interest =
+		(1 << PGP_PKT_PUBLIC_KEY) | (1 << PGP_PKT_PUBLIC_SUBKEY);
+	ctx.pgp.process_packet = crypto_key_pgp_parse_public_key;
+	ctx.pubkey_algo = algo;
+
+	ret = pgp_parse_packets(data, datalen, &ctx.pgp);
+	if (ret == -EEXIST)
+		return 0;
+	return ret == 0 ? -EBADMSG : ret;
+}
+
+/*
+ * Instantiate a crypto_key defined key
+ */
+static int crypto_key_instantiate(struct key *key,
+				  const void *data, size_t datalen)
+{
+	struct crypto_key_subtype *subtype;
+	enum pgp_pubkey_algo pubkey_algo;
+	bool is_pgp;
+	int ret;
+
+	kenter("");
+
+	if (datalen == 0)
+		return -EINVAL;
+
+	if (((u8 *)data)[0] & 0x80) {
+		/* PGP tags have the top bit set */
+		ret = crypto_key_is_pgp(data, datalen, &pubkey_algo);
+		if (ret < 0)
+			return ret;
+		is_pgp = true;
+	} else {
+		/* We only support PGP blobs for now, but we could, for
+		 * instance, support a subtype that offloads checks to a
+		 * system's TPM. */
+		kleave(" = -EINVAL [not pgp]");
+		return -EINVAL;
+	}
+
+	down_read(&crypto_key_subtypes_sem);
+
+	list_for_each_entry(subtype, &crypto_key_subtypes, link) {
+		if (is_pgp &&
+		    subtype->info & CRYPTO_KEY_IS_PUBKEY_ALGO &&
+		    subtype->pubkey_algo == pubkey_algo)
+			goto found;
+	}
+
+	/* Not found; load module? */
+	ret = -ENOPKG;
+	goto error_up;
+
+found:
+	if (!try_module_get(subtype->owner)) {
+		ret = -ENOPKG;
+		goto error_up;
+	}
+
+	up_read(&crypto_key_subtypes_sem);
+
+	ret = subtype->instantiate(key, data, datalen);
+	if (ret != 0)
+		module_put(subtype->owner);
+	kleave(" = %d", ret);
+	return ret;
+
+error_up:
+	up_read(&crypto_key_subtypes_sem);
+	kleave(" = %d [nosub]", ret);
+	return ret;
+}
+
+/*
+ * dispose of the links from a revoked keyring
+ * - called with the key sem write-locked
+ */
+static void crypto_key_revoke(struct key *key)
+{
+	struct crypto_key_subtype *subtype = crypto_key_subtype(key);
+	if (subtype && subtype->revoke)
+		subtype->revoke(key);
+}
+
+/*
+ * dispose of the data dangling from the corpse of a crypto key
+ */
+static void crypto_key_destroy(struct key *key)
+{
+	struct crypto_key_subtype *subtype = crypto_key_subtype(key);
+	if (subtype) {
+		subtype->destroy(key);
+		module_put(subtype->owner);
+		key->type_data.p[0] = NULL;
+	}
+	kfree(key->type_data.p[1]);
+	key->type_data.p[1] = NULL;
+}
+
+struct key_type key_type_crypto = {
+	.name		= "crypto",
+	.instantiate	= crypto_key_instantiate,
+	.match		= crypto_key_match,
+	.revoke		= crypto_key_revoke,
+	.destroy	= crypto_key_destroy,
+	.describe	= crypto_key_describe,
+};
+EXPORT_SYMBOL_GPL(key_type_crypto);
+
+/**
+ * register_crypto_key_subtype - Register a crypto key subtype
+ * @subtype: The subtype to register
+ */
+int register_crypto_key_subtype(struct crypto_key_subtype *subtype)
+{
+	struct crypto_key_subtype *cursor;
+	int ret;
+
+	subtype->name_len = strlen(subtype->name);
+
+	down_write(&crypto_key_subtypes_sem);
+
+	list_for_each_entry(cursor, &crypto_key_subtypes, link) {
+		if (strcmp(cursor->name, subtype->name) == 0 &&
+		    cursor->pubkey_algo == subtype->pubkey_algo) {
+			pr_err("Crypto key subtype '%s'/%u already registered\n",
+			       subtype->name, subtype->pubkey_algo);
+			ret = -EEXIST;
+			goto out;
+		}
+	}
+
+	list_add_tail(&subtype->link, &crypto_key_subtypes);
+
+	pr_notice("Crypto key subtype '%s' registered\n", subtype->name);
+	ret = 0;
+
+out:
+	up_write(&crypto_key_subtypes_sem);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(register_crypto_key_subtype);
+
+/**
+ * unregister_crypto_key_subtype - Unregister a crypto key subtype
+ * @subtype: The subtype to unregister
+ */
+void unregister_crypto_key_subtype(struct crypto_key_subtype *subtype)
+{
+	down_write(&crypto_key_subtypes_sem);
+	list_del(&subtype->link);
+	up_write(&crypto_key_subtypes_sem);
+
+	pr_notice("Crypto key subtype '%s' unregistered\n", subtype->name);
+}
+EXPORT_SYMBOL_GPL(unregister_crypto_key_subtype);
+
+/*
+ * Module stuff
+ */
+static int __init crypto_key_init(void)
+{
+	return register_key_type(&key_type_crypto);
+}
+
+static void __exit crypto_key_cleanup(void)
+{
+	unregister_key_type(&key_type_crypto);
+}
+
+module_init(crypto_key_init);
+module_exit(crypto_key_cleanup);

