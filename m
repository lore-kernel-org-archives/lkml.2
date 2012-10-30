Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965802Ab2J3TXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:23:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965682Ab2J3TWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:22:55 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 23/23] KEYS: Add a 'trusted' flag and a 'trusted only' flag
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, pjones@redhat.com, jwboyer@redhat.com, mjg@redhat.com,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        keescook@chromium.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 30 Oct 2012 19:22:48 +0000
Message-ID: <20121030192248.11000.91470.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
References: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add KEY_FLAG_TRUSTED to indicate that a key either comes from a trusted source
or had a cryptographic signature chain that led back to a trusted key the
kernel already possessed.

Add KEY_FLAGS_TRUSTED_ONLY to indicate that a keyring will only accept links to
keys marked with KEY_FLAGS_TRUSTED.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/pefile_parser.c |    2 +-
 crypto/asymmetric_keys/pkcs7_parser.h  |    3 ++-
 crypto/asymmetric_keys/pkcs7_trust.c   |    6 +++++-
 include/linux/key-type.h               |    1 +
 include/linux/key.h                    |    3 +++
 kernel/modsign_pubkey.c                |    6 ++++--
 security/keys/key.c                    |    8 ++++++++
 security/keys/keyring.c                |    4 ++++
 security/keys/proc.c                   |    3 ++-
 9 files changed, 30 insertions(+), 6 deletions(-)


diff --git a/crypto/asymmetric_keys/pefile_parser.c b/crypto/asymmetric_keys/pefile_parser.c
index 28be7d3..da2db58 100644
--- a/crypto/asymmetric_keys/pefile_parser.c
+++ b/crypto/asymmetric_keys/pefile_parser.c
@@ -432,7 +432,7 @@ static int pefile_key_preparse(struct key_preparsed_payload *prep)
 	if (ret < 0)
 		goto error;
 
-	ret = pkcs7_validate_trust(pkcs7, modsign_keyring);
+	ret = pkcs7_validate_trust(pkcs7, modsign_keyring, &prep->trusted);
 	if (ret < 0)
 		goto error;
 
diff --git a/crypto/asymmetric_keys/pkcs7_parser.h b/crypto/asymmetric_keys/pkcs7_parser.h
index f6df500..ffa72dc 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.h
+++ b/crypto/asymmetric_keys/pkcs7_parser.h
@@ -63,7 +63,8 @@ extern void pkcs7_free_message(struct pkcs7_message *pkcs7);
  * pkcs7_trust.c
  */
 extern int pkcs7_validate_trust(struct pkcs7_message *pkcs7,
-				struct key *trust_keyring);
+				struct key *trust_keyring,
+				bool *_trusted);
 
 /*
  * pkcs7_verify.c
diff --git a/crypto/asymmetric_keys/pkcs7_trust.c b/crypto/asymmetric_keys/pkcs7_trust.c
index 9abcb39..cc226f5 100644
--- a/crypto/asymmetric_keys/pkcs7_trust.c
+++ b/crypto/asymmetric_keys/pkcs7_trust.c
@@ -74,11 +74,13 @@ static struct key *pkcs7_request_asymmetric_key(
  * keys we already know and trust.
  */
 int pkcs7_validate_trust(struct pkcs7_message *pkcs7,
-			 struct key *trust_keyring)
+			 struct key *trust_keyring,
+			 bool *_trusted)
 {
 	struct public_key_signature *sig = &pkcs7->sig;
 	struct x509_certificate *x509, *last = NULL;
 	struct key *key;
+	bool trusted;
 	int ret;
 
 	kenter("");
@@ -131,6 +133,7 @@ int pkcs7_validate_trust(struct pkcs7_message *pkcs7,
 
 matched:
 	ret = verify_signature(key, sig);
+	trusted = test_bit(KEY_FLAG_TRUSTED, &key->flags);
 	key_put(key);
 	if (ret < 0) {
 		if (ret == -ENOMEM)
@@ -139,6 +142,7 @@ matched:
 		return -EKEYREJECTED;
 	}
 
+	*_trusted = trusted;
 	kleave(" = 0");
 	return 0;
 }
diff --git a/include/linux/key-type.h b/include/linux/key-type.h
index 518a53a..f942b2d 100644
--- a/include/linux/key-type.h
+++ b/include/linux/key-type.h
@@ -45,6 +45,7 @@ struct key_preparsed_payload {
 	const void	*data;		/* Raw data */
 	size_t		datalen;	/* Raw datalen */
 	size_t		quotalen;	/* Quota length for proposed payload */
+	bool		trusted;	/* True if key is trusted */
 };
 
 typedef int (*request_key_actor_t)(struct key_construction *key,
diff --git a/include/linux/key.h b/include/linux/key.h
index 2393b1c..cd0b9e9 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -162,6 +162,8 @@ struct key {
 #define KEY_FLAG_NEGATIVE	5	/* set if key is negative */
 #define KEY_FLAG_ROOT_CAN_CLEAR	6	/* set if key can be cleared by root without permission */
 #define KEY_FLAG_INVALIDATED	7	/* set if key has been invalidated */
+#define KEY_FLAG_TRUSTED	8	/* set if key is trusted */
+#define KEY_FLAG_TRUSTED_ONLY	9	/* set if keyring only accepts links to trusted keys */
 
 	/* the description string
 	 * - this is used to match a key against search criteria
@@ -203,6 +205,7 @@ extern struct key *key_alloc(struct key_type *type,
 #define KEY_ALLOC_IN_QUOTA	0x0000	/* add to quota, reject if would overrun */
 #define KEY_ALLOC_QUOTA_OVERRUN	0x0001	/* add to quota, permit even if overrun */
 #define KEY_ALLOC_NOT_IN_QUOTA	0x0002	/* not in quota */
+#define KEY_ALLOC_TRUSTED	0x0004	/* Key should be flagged as trusted */
 
 extern void key_revoke(struct key *key);
 extern void key_invalidate(struct key *key);
diff --git a/kernel/modsign_pubkey.c b/kernel/modsign_pubkey.c
index 602be22..57b0a77 100644
--- a/kernel/modsign_pubkey.c
+++ b/kernel/modsign_pubkey.c
@@ -45,7 +45,7 @@ static __init int module_verify_init(void)
 				    KUIDT_INIT(0), KGIDT_INIT(0),
 				    current_cred(),
 				    (KEY_POS_ALL & ~KEY_POS_SETATTR) |
-				    KEY_USR_VIEW | KEY_USR_READ,
+				    KEY_USR_VIEW | KEY_USR_READ | KEY_USR_WRITE,
 				    KEY_ALLOC_NOT_IN_QUOTA);
 	if (IS_ERR(modsign_keyring))
 		panic("Can't allocate module signing keyring\n");
@@ -53,6 +53,7 @@ static __init int module_verify_init(void)
 	if (key_instantiate_and_link(modsign_keyring, NULL, 0, NULL, NULL) < 0)
 		panic("Can't instantiate module signing keyring\n");
 
+	set_bit(KEY_FLAG_TRUSTED_ONLY, &modsign_keyring->flags);
 	return 0;
 }
 
@@ -95,7 +96,8 @@ static __init int load_module_signing_keys(void)
 					   plen,
 					   (KEY_POS_ALL & ~KEY_POS_SETATTR) |
 					   KEY_USR_VIEW,
-					   KEY_ALLOC_NOT_IN_QUOTA);
+					   KEY_ALLOC_NOT_IN_QUOTA |
+					   KEY_ALLOC_TRUSTED);
 		if (IS_ERR(key))
 			pr_err("MODSIGN: Problem loading in-kernel X.509 certificate (%ld)\n",
 			       PTR_ERR(key));
diff --git a/security/keys/key.c b/security/keys/key.c
index a15c9da..d0f35d1 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -299,6 +299,8 @@ struct key *key_alloc(struct key_type *type, const char *desc,
 
 	if (!(flags & KEY_ALLOC_NOT_IN_QUOTA))
 		key->flags |= 1 << KEY_FLAG_IN_QUOTA;
+	if (flags & KEY_ALLOC_TRUSTED)
+		key->flags |= 1 << KEY_FLAG_TRUSTED;
 
 	memset(&key->type_data, 0, sizeof(key->type_data));
 
@@ -813,6 +815,7 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 	prep.data = payload;
 	prep.datalen = plen;
 	prep.quotalen = ktype->def_datalen;
+	prep.trusted = flags & KEY_ALLOC_TRUSTED;
 	if (ktype->preparse) {
 		ret = ktype->preparse(&prep);
 		if (ret < 0) {
@@ -826,6 +829,11 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 			goto error_free_prep;
 	}
 
+	key_ref = ERR_PTR(-EPERM);
+	if (!prep.trusted && test_bit(KEY_FLAG_TRUSTED_ONLY, &keyring->flags))
+		goto error_free_prep;
+	flags |= prep.trusted ? KEY_ALLOC_TRUSTED : 0;
+
 	ret = __key_link_begin(keyring, ktype, description, &prealloc);
 	if (ret < 0) {
 		key_ref = ERR_PTR(ret);
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 6e42df1..af90786 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -1008,6 +1008,10 @@ int key_link(struct key *keyring, struct key *key)
 	key_check(keyring);
 	key_check(key);
 
+	if (test_bit(KEY_FLAG_TRUSTED_ONLY, &keyring->flags) &&
+	    !test_bit(KEY_FLAG_TRUSTED, &key->flags))
+		return -EPERM;
+
 	ret = __key_link_begin(keyring, key->type, key->description, &prealloc);
 	if (ret == 0) {
 		ret = __key_link_check_live_key(keyring, key);
diff --git a/security/keys/proc.c b/security/keys/proc.c
index 217b685..d0ca948 100644
--- a/security/keys/proc.c
+++ b/security/keys/proc.c
@@ -242,7 +242,7 @@ static int proc_keys_show(struct seq_file *m, void *v)
 #define showflag(KEY, LETTER, FLAG) \
 	(test_bit(FLAG,	&(KEY)->flags) ? LETTER : '-')
 
-	seq_printf(m, "%08x %c%c%c%c%c%c%c %5d %4s %08x %5d %5d %-9.9s ",
+	seq_printf(m, "%08x %c%c%c%c%c%c%c%c %5d %4s %08x %5d %5d %-9.9s ",
 		   key->serial,
 		   showflag(key, 'I', KEY_FLAG_INSTANTIATED),
 		   showflag(key, 'R', KEY_FLAG_REVOKED),
@@ -251,6 +251,7 @@ static int proc_keys_show(struct seq_file *m, void *v)
 		   showflag(key, 'U', KEY_FLAG_USER_CONSTRUCT),
 		   showflag(key, 'N', KEY_FLAG_NEGATIVE),
 		   showflag(key, 'i', KEY_FLAG_INVALIDATED),
+		   showflag(key, 'T', KEY_FLAG_TRUSTED),
 		   atomic_read(&key->usage),
 		   xbuf,
 		   key->perm,

