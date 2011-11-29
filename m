Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab1K2Xx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 18:53:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756848Ab1K2XxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 18:53:20 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 13/16] KEYS: Provide a function to load keys from a PGP
 keyring blob [ver #2]
To: keyrings@linux-nfs.org
Cc: linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
        alan.cox@intel.com, David Howells <dhowells@redhat.com>
Date: Tue, 29 Nov 2011 23:45:44 +0000
Message-ID: <20111129234543.13625.10086.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111129234258.13625.21153.stgit@warthog.procyon.org.uk>
References: <20111129234258.13625.21153.stgit@warthog.procyon.org.uk>
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

 Documentation/security/keys-crypto.txt |   19 +++++++++
 include/keys/crypto-type.h             |    3 +
 security/keys/crypto_request.c         |   66 ++++++++++++++++++++++++++++++++
 3 files changed, 88 insertions(+), 0 deletions(-)


diff --git a/Documentation/security/keys-crypto.txt b/Documentation/security/keys-crypto.txt
index e1c19ea..35e61b1 100644
--- a/Documentation/security/keys-crypto.txt
+++ b/Documentation/security/keys-crypto.txt
@@ -9,6 +9,7 @@ Contents:
   - Crypto subtypes.
   - Accessing crypto keys.
     - Signature verification.
+    - Initial pgp key loading.
   - Implementing crypto subtypes.
     - Registration.
 
@@ -170,6 +171,24 @@ hardware keystore (such as a TPM) for a usable signature matching service and
 generate a key to provide an access method to that service.
 
 
+INITIAL PGP KEY LOADING
+-----------------------
+
+A function is provided to perform an initial load of a set of public keys bound
+into a PGP keyring blob:
+
+	int load_PGP_keys(const u8 *pgpdata, size_t pgpdatalen,
+			  struct key *keyring, const char *descprefix);
+
+This takes the blob of data defined by pgpdata and pgpdatalen, extracts keys
+from them and adds them to the specified keyring.  The keys are labelled with
+descprefix plus a simple uniquifier - it is not expected that the description
+will be used to identify the key.  The description is required to prevent all
+but the last key being discarded when the keys are linked into the keyring.
+
+This function is only available during initial kernel set up.
+
+
 ============================
 IMPLEMENTING CRYPTO SUBTYPES
 ============================
diff --git a/include/keys/crypto-type.h b/include/keys/crypto-type.h
index 142611b..ef961d9 100644
--- a/include/keys/crypto-type.h
+++ b/include/keys/crypto-type.h
@@ -34,4 +34,7 @@ extern void verify_sig_cancel(struct crypto_key_verify_context *ctx);
 extern struct key *request_crypto_key_for_PGP_sig(struct key *keyring,
 						  const u8 *sig, size_t siglen);
 
+extern __init int load_PGP_keys(const u8 *pgpdata, size_t pgpdatalen,
+				struct key *keyring, const char *descprefix);
+
 #endif /* _KEYS_CRYPTO_TYPE_H */
diff --git a/security/keys/crypto_request.c b/security/keys/crypto_request.c
index 0a1819a3..416c69f 100644
--- a/security/keys/crypto_request.c
+++ b/security/keys/crypto_request.c
@@ -85,3 +85,69 @@ struct key *request_crypto_key_for_PGP_sig(struct key *keyring,
 		return ERR_CAST(key);
 	return key_ref_to_ptr(key);
 }
+
+struct load_PGP_keys_context {
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
+static int found_PGP_key(struct pgp_parse_context *context,
+			 enum pgp_packet_tag type, u8 headerlen,
+			 const u8 *data, size_t datalen)
+{
+	struct load_PGP_keys_context *ctx =
+		container_of(context, struct load_PGP_keys_context, pgp);
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
+	key_ref_put(key);
+	return 0;
+}
+
+/**
+ * load_PGP_keys - Load keys from a PGP keyring blob
+ * @pgpdata: The PGP keyring blob containing the keys.
+ * @pgpdatalen: The size of the @pgpdata blob.
+ * @keyring: The keyring to add the new keys to.
+ * @descprefix: The key description prefix.
+ *
+ * Load a pack of keys from a PGP keyring blob.
+ *
+ * The keys are given description of @descprefix + the number of the key in the
+ * list.  Since keys can be matched on their key IDs independently of the key
+ * description, the description is mostly irrelevant apart from the fact that
+ * keys of the same description displace one another from a keyring.
+ *
+ * The caller should override the current creds if they want the keys to be
+ * owned by someone other than the current process's owner.  Keys will not be
+ * accounted towards the owner's quota.
+ */
+int __init load_PGP_keys(const u8 *pgpdata, size_t pgpdatalen,
+			 struct key *keyring, const char *descprefix)
+{
+	struct load_PGP_keys_context ctx;
+
+	ctx.pgp.types_of_interest =
+		(1 << PGP_PKT_PUBLIC_KEY) | (1 << PGP_PKT_PUBLIC_SUBKEY);
+	ctx.pgp.process_packet = found_PGP_key;
+	ctx.keyring = make_key_ref(keyring, 1);
+	ctx.key_n = 0;
+	ctx.dsize = strlen(descprefix);
+	strcpy(ctx.descbuf, descprefix);
+
+	return pgp_parse_packets(pgpdata, pgpdatalen, &ctx.pgp);
+}

