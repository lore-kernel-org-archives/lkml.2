Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161Ab2IMXs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 19:48:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759127Ab2IMXss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 19:48:48 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 01/16] KEYS: Add payload preparsing opportunity prior to key
 instantiate or update
To: herbert@gondor.hengli.com.au, rusty@rustcorp.com.au
Cc: linux-crypto@vger.kernel.org, zohar@us.ibm.com, dmitry.kasatkin@intel.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 14 Sep 2012 00:48:12 +0100
Message-ID: <20120913234812.3575.8168.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120913234802.3575.77103.stgit@warthog.procyon.org.uk>
References: <20120913234802.3575.77103.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Give the key type the opportunity to preparse the payload prior to the
instantiation and update routines being called.  This is done with the
provision of two new key type operations:

	int (*preparse)(struct key_preparsed_payload *prep);
	void (*free_preparse)(struct key_preparsed_payload *prep);

If the first operation is present, then it is called before key creation (in
the add/update case) or before the key semaphore is taken (in the update and
instantiate cases).  The second operation is called to clean up if the first
was called.

preparse() is given the opportunity to fill in the following structure:

	struct key_preparsed_payload {
		char		*description;
		void		*type_data[2];
		void		*payload;
		const void	*data;
		size_t		datalen;
		size_t		quotalen;
	};

Before the preparser is called, the first three fields will have been cleared,
the payload pointer and size will be stored in data and datalen and the default
quota size from the key_type struct will be stored into quotalen.

The preparser may parse the payload in any way it likes and may store data in
the type_data[] and payload fields for use by the instantiate() and update()
ops.

The preparser may also propose a description for the key by attaching it as a
string to the description field.  This can be used by passing a NULL or ""
description to the add_key() system call or the key_create_or_update()
function.  This cannot work with request_key() as that required the description
to tell the upcall about the key to be created.

This, for example permits keys that store PGP public keys to generate their own
name from the user ID and public key fingerprint in the key.

The instantiate() and update() operations are then modified to look like this:

	int (*instantiate)(struct key *key, struct key_preparsed_payload *prep);
	int (*update)(struct key *key, struct key_preparsed_payload *prep);

and the new payload data is passed in *prep, whether or not it was preparsed.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/security/keys.txt          |   50 +++++++++++++
 fs/cifs/cifs_spnego.c                    |    6 +-
 fs/cifs/cifsacl.c                        |    8 +-
 include/keys/user-type.h                 |    6 +-
 include/linux/key-type.h                 |   35 +++++++++
 net/ceph/crypto.c                        |    9 +-
 net/dns_resolver/dns_key.c               |    6 +-
 net/rxrpc/ar-key.c                       |   40 +++++------
 security/keys/encrypted-keys/encrypted.c |   16 ++--
 security/keys/key.c                      |  114 ++++++++++++++++++++++--------
 security/keys/keyctl.c                   |   18 ++++-
 security/keys/keyring.c                  |    6 +-
 security/keys/request_key_auth.c         |    8 +-
 security/keys/trusted.c                  |   16 ++--
 security/keys/user_defined.c             |   14 ++--
 15 files changed, 250 insertions(+), 102 deletions(-)


diff --git a/Documentation/security/keys.txt b/Documentation/security/keys.txt
index aa0dbd7..7d9ca92 100644
--- a/Documentation/security/keys.txt
+++ b/Documentation/security/keys.txt
@@ -412,6 +412,10 @@ The main syscalls are:
      to the keyring. In this case, an error will be generated if the process
      does not have permission to write to the keyring.
 
+     If the key type supports it, if the description is NULL or an empty
+     string, the key type will try and generate a description from the content
+     of the payload.
+
      The payload is optional, and the pointer can be NULL if not required by
      the type. The payload is plen in size, and plen can be zero for an empty
      payload.
@@ -1114,12 +1118,53 @@ The structure has a number of fields, some of which are mandatory:
      it should return 0.
 
 
- (*) int (*instantiate)(struct key *key, const void *data, size_t datalen);
+ (*) int (*preparse)(struct key_preparsed_payload *prep);
+
+     This optional method permits the key type to attempt to parse payload
+     before a key is created (add key) or the key semaphore is taken (update or
+     instantiate key).  The structure pointed to by prep looks like:
+
+	struct key_preparsed_payload {
+		char		*description;
+		void		*type_data[2];
+		void		*payload;
+		const void	*data;
+		size_t		datalen;
+		size_t		quotalen;
+	};
+
+     Before calling the method, the caller will fill in data and datalen with
+     the payload blob parameters; quotalen will be filled in with the default
+     quota size from the key type and the rest will be cleared.
+
+     If a description can be proposed from the payload contents, that should be
+     attached as a string to the description field.  This will be used for the
+     key description if the caller of add_key() passes NULL or "".
+
+     The method can attach anything it likes to type_data[] and payload.  These
+     are merely passed along to the instantiate() or update() operations.
+
+     The method should return 0 if success ful or a negative error code
+     otherwise.
+
+     
+ (*) void (*free_preparse)(struct key_preparsed_payload *prep);
+
+     This method is only required if the preparse() method is provided,
+     otherwise it is unused.  It cleans up anything attached to the
+     description, type_data and payload fields of the key_preparsed_payload
+     struct as filled in by the preparse() method.
+
+
+ (*) int (*instantiate)(struct key *key, struct key_preparsed_payload *prep);
 
      This method is called to attach a payload to a key during construction.
      The payload attached need not bear any relation to the data passed to this
      function.
 
+     The prep->data and prep->datalen fields will define the original payload
+     blob.  If preparse() was supplied then other fields may be filled in also.
+
      If the amount of data attached to the key differs from the size in
      keytype->def_datalen, then key_payload_reserve() should be called.
 
@@ -1135,6 +1180,9 @@ The structure has a number of fields, some of which are mandatory:
      If this type of key can be updated, then this method should be provided.
      It is called to update a key's payload from the blob of data provided.
 
+     The prep->data and prep->datalen fields will define the original payload
+     blob.  If preparse() was supplied then other fields may be filled in also.
+
      key_payload_reserve() should be called if the data length might change
      before any changes are actually made. Note that if this succeeds, the type
      is committed to changing the key because it's already been altered, so all
diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
index e622863..086f381 100644
--- a/fs/cifs/cifs_spnego.c
+++ b/fs/cifs/cifs_spnego.c
@@ -31,18 +31,18 @@
 
 /* create a new cifs key */
 static int
-cifs_spnego_key_instantiate(struct key *key, const void *data, size_t datalen)
+cifs_spnego_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
 {
 	char *payload;
 	int ret;
 
 	ret = -ENOMEM;
-	payload = kmalloc(datalen, GFP_KERNEL);
+	payload = kmalloc(prep->datalen, GFP_KERNEL);
 	if (!payload)
 		goto error;
 
 	/* attach the data */
-	memcpy(payload, data, datalen);
+	memcpy(payload, prep->data, prep->datalen);
 	key->payload.data = payload;
 	ret = 0;
 
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 05f4dc2..f3c60e2 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -167,17 +167,17 @@ static struct shrinker cifs_shrinker = {
 };
 
 static int
-cifs_idmap_key_instantiate(struct key *key, const void *data, size_t datalen)
+cifs_idmap_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
 {
 	char *payload;
 
-	payload = kmalloc(datalen, GFP_KERNEL);
+	payload = kmalloc(prep->datalen, GFP_KERNEL);
 	if (!payload)
 		return -ENOMEM;
 
-	memcpy(payload, data, datalen);
+	memcpy(payload, prep->data, prep->datalen);
 	key->payload.data = payload;
-	key->datalen = datalen;
+	key->datalen = prep->datalen;
 	return 0;
 }
 
diff --git a/include/keys/user-type.h b/include/keys/user-type.h
index bc9ec1d..5e452c8 100644
--- a/include/keys/user-type.h
+++ b/include/keys/user-type.h
@@ -35,8 +35,10 @@ struct user_key_payload {
 extern struct key_type key_type_user;
 extern struct key_type key_type_logon;
 
-extern int user_instantiate(struct key *key, const void *data, size_t datalen);
-extern int user_update(struct key *key, const void *data, size_t datalen);
+struct key_preparsed_payload;
+
+extern int user_instantiate(struct key *key, struct key_preparsed_payload *prep);
+extern int user_update(struct key *key, struct key_preparsed_payload *prep);
 extern int user_match(const struct key *key, const void *criterion);
 extern void user_revoke(struct key *key);
 extern void user_destroy(struct key *key);
diff --git a/include/linux/key-type.h b/include/linux/key-type.h
index f0c651c..518a53a 100644
--- a/include/linux/key-type.h
+++ b/include/linux/key-type.h
@@ -26,6 +26,27 @@ struct key_construction {
 	struct key	*authkey;/* authorisation for key being constructed */
 };
 
+/*
+ * Pre-parsed payload, used by key add, update and instantiate.
+ *
+ * This struct will be cleared and data and datalen will be set with the data
+ * and length parameters from the caller and quotalen will be set from
+ * def_datalen from the key type.  Then if the preparse() op is provided by the
+ * key type, that will be called.  Then the struct will be passed to the
+ * instantiate() or the update() op.
+ *
+ * If the preparse() op is given, the free_preparse() op will be called to
+ * clear the contents.
+ */
+struct key_preparsed_payload {
+	char		*description;	/* Proposed key description (or NULL) */
+	void		*type_data[2];	/* Private key-type data */
+	void		*payload;	/* Proposed payload */
+	const void	*data;		/* Raw data */
+	size_t		datalen;	/* Raw datalen */
+	size_t		quotalen;	/* Quota length for proposed payload */
+};
+
 typedef int (*request_key_actor_t)(struct key_construction *key,
 				   const char *op, void *aux);
 
@@ -45,18 +66,28 @@ struct key_type {
 	/* vet a description */
 	int (*vet_description)(const char *description);
 
+	/* Preparse the data blob from userspace that is to be the payload,
+	 * generating a proposed description and payload that will be handed to
+	 * the instantiate() and update() ops.
+	 */
+	int (*preparse)(struct key_preparsed_payload *prep);
+
+	/* Free a preparse data structure.
+	 */
+	void (*free_preparse)(struct key_preparsed_payload *prep);
+
 	/* instantiate a key of this type
 	 * - this method should call key_payload_reserve() to determine if the
 	 *   user's quota will hold the payload
 	 */
-	int (*instantiate)(struct key *key, const void *data, size_t datalen);
+	int (*instantiate)(struct key *key, struct key_preparsed_payload *prep);
 
 	/* update a key of this type (optional)
 	 * - this method should call key_payload_reserve() to recalculate the
 	 *   quota consumption
 	 * - the key must be locked against read when modifying
 	 */
-	int (*update)(struct key *key, const void *data, size_t datalen);
+	int (*update)(struct key *key, struct key_preparsed_payload *prep);
 
 	/* match a key against a description */
 	int (*match)(const struct key *key, const void *desc);
diff --git a/net/ceph/crypto.c b/net/ceph/crypto.c
index 9da7fdd..af14cb4 100644
--- a/net/ceph/crypto.c
+++ b/net/ceph/crypto.c
@@ -423,14 +423,15 @@ int ceph_encrypt2(struct ceph_crypto_key *secret, void *dst, size_t *dst_len,
 	}
 }
 
-int ceph_key_instantiate(struct key *key, const void *data, size_t datalen)
+int ceph_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
 {
 	struct ceph_crypto_key *ckey;
+	size_t datalen = prep->datalen;
 	int ret;
 	void *p;
 
 	ret = -EINVAL;
-	if (datalen <= 0 || datalen > 32767 || !data)
+	if (datalen <= 0 || datalen > 32767 || !prep->data)
 		goto err;
 
 	ret = key_payload_reserve(key, datalen);
@@ -443,8 +444,8 @@ int ceph_key_instantiate(struct key *key, const void *data, size_t datalen)
 		goto err;
 
 	/* TODO ceph_crypto_key_decode should really take const input */
-	p = (void *)data;
-	ret = ceph_crypto_key_decode(ckey, &p, (char*)data+datalen);
+	p = (void *)prep->data;
+	ret = ceph_crypto_key_decode(ckey, &p, (char*)prep->data+datalen);
 	if (ret < 0)
 		goto err_ckey;
 
diff --git a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
index d9507dd..859ab8b 100644
--- a/net/dns_resolver/dns_key.c
+++ b/net/dns_resolver/dns_key.c
@@ -59,13 +59,13 @@ const struct cred *dns_resolver_cache;
  *        "ip1,ip2,...#foo=bar"
  */
 static int
-dns_resolver_instantiate(struct key *key, const void *_data, size_t datalen)
+dns_resolver_instantiate(struct key *key, struct key_preparsed_payload *prep)
 {
 	struct user_key_payload *upayload;
 	unsigned long derrno;
 	int ret;
-	size_t result_len = 0;
-	const char *data = _data, *end, *opt;
+	size_t datalen = prep->datalen, result_len = 0;
+	const char *data = prep->data, *end, *opt;
 
 	kenter("%%%d,%s,'%*.*s',%zu",
 	       key->serial, key->description,
diff --git a/net/rxrpc/ar-key.c b/net/rxrpc/ar-key.c
index 8b1f9f4..106c5a6 100644
--- a/net/rxrpc/ar-key.c
+++ b/net/rxrpc/ar-key.c
@@ -26,8 +26,8 @@
 #include "ar-internal.h"
 
 static int rxrpc_vet_description_s(const char *);
-static int rxrpc_instantiate(struct key *, const void *, size_t);
-static int rxrpc_instantiate_s(struct key *, const void *, size_t);
+static int rxrpc_instantiate(struct key *, struct key_preparsed_payload *);
+static int rxrpc_instantiate_s(struct key *, struct key_preparsed_payload *);
 static void rxrpc_destroy(struct key *);
 static void rxrpc_destroy_s(struct key *);
 static void rxrpc_describe(const struct key *, struct seq_file *);
@@ -678,7 +678,7 @@ error:
  *
  * if no data is provided, then a no-security key is made
  */
-static int rxrpc_instantiate(struct key *key, const void *data, size_t datalen)
+static int rxrpc_instantiate(struct key *key, struct key_preparsed_payload *prep)
 {
 	const struct rxrpc_key_data_v1 *v1;
 	struct rxrpc_key_token *token, **pp;
@@ -686,26 +686,26 @@ static int rxrpc_instantiate(struct key *key, const void *data, size_t datalen)
 	u32 kver;
 	int ret;
 
-	_enter("{%x},,%zu", key_serial(key), datalen);
+	_enter("{%x},,%zu", key_serial(key), prep->datalen);
 
 	/* handle a no-security key */
-	if (!data && datalen == 0)
+	if (!prep->data && prep->datalen == 0)
 		return 0;
 
 	/* determine if the XDR payload format is being used */
-	if (datalen > 7 * 4) {
-		ret = rxrpc_instantiate_xdr(key, data, datalen);
+	if (prep->datalen > 7 * 4) {
+		ret = rxrpc_instantiate_xdr(key, prep->data, prep->datalen);
 		if (ret != -EPROTO)
 			return ret;
 	}
 
 	/* get the key interface version number */
 	ret = -EINVAL;
-	if (datalen <= 4 || !data)
+	if (prep->datalen <= 4 || !prep->data)
 		goto error;
-	memcpy(&kver, data, sizeof(kver));
-	data += sizeof(kver);
-	datalen -= sizeof(kver);
+	memcpy(&kver, prep->data, sizeof(kver));
+	prep->data += sizeof(kver);
+	prep->datalen -= sizeof(kver);
 
 	_debug("KEY I/F VERSION: %u", kver);
 
@@ -715,11 +715,11 @@ static int rxrpc_instantiate(struct key *key, const void *data, size_t datalen)
 
 	/* deal with a version 1 key */
 	ret = -EINVAL;
-	if (datalen < sizeof(*v1))
+	if (prep->datalen < sizeof(*v1))
 		goto error;
 
-	v1 = data;
-	if (datalen != sizeof(*v1) + v1->ticket_length)
+	v1 = prep->data;
+	if (prep->datalen != sizeof(*v1) + v1->ticket_length)
 		goto error;
 
 	_debug("SCIX: %u", v1->security_index);
@@ -784,17 +784,17 @@ error:
  * instantiate a server secret key
  * data should be a pointer to the 8-byte secret key
  */
-static int rxrpc_instantiate_s(struct key *key, const void *data,
-			       size_t datalen)
+static int rxrpc_instantiate_s(struct key *key,
+			       struct key_preparsed_payload *prep)
 {
 	struct crypto_blkcipher *ci;
 
-	_enter("{%x},,%zu", key_serial(key), datalen);
+	_enter("{%x},,%zu", key_serial(key), prep->datalen);
 
-	if (datalen != 8)
+	if (prep->datalen != 8)
 		return -EINVAL;
 
-	memcpy(&key->type_data, data, 8);
+	memcpy(&key->type_data, prep->data, 8);
 
 	ci = crypto_alloc_blkcipher("pcbc(des)", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(ci)) {
@@ -802,7 +802,7 @@ static int rxrpc_instantiate_s(struct key *key, const void *data,
 		return PTR_ERR(ci);
 	}
 
-	if (crypto_blkcipher_setkey(ci, data, 8) < 0)
+	if (crypto_blkcipher_setkey(ci, prep->data, 8) < 0)
 		BUG();
 
 	key->payload.data = ci;
diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index 2d1bb8a..9e1e005 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -773,8 +773,8 @@ static int encrypted_init(struct encrypted_key_payload *epayload,
  *
  * On success, return 0. Otherwise return errno.
  */
-static int encrypted_instantiate(struct key *key, const void *data,
-				 size_t datalen)
+static int encrypted_instantiate(struct key *key,
+				 struct key_preparsed_payload *prep)
 {
 	struct encrypted_key_payload *epayload = NULL;
 	char *datablob = NULL;
@@ -782,16 +782,17 @@ static int encrypted_instantiate(struct key *key, const void *data,
 	char *master_desc = NULL;
 	char *decrypted_datalen = NULL;
 	char *hex_encoded_iv = NULL;
+	size_t datalen = prep->datalen;
 	int ret;
 
-	if (datalen <= 0 || datalen > 32767 || !data)
+	if (datalen <= 0 || datalen > 32767 || !prep->data)
 		return -EINVAL;
 
 	datablob = kmalloc(datalen + 1, GFP_KERNEL);
 	if (!datablob)
 		return -ENOMEM;
 	datablob[datalen] = 0;
-	memcpy(datablob, data, datalen);
+	memcpy(datablob, prep->data, datalen);
 	ret = datablob_parse(datablob, &format, &master_desc,
 			     &decrypted_datalen, &hex_encoded_iv);
 	if (ret < 0)
@@ -834,16 +835,17 @@ static void encrypted_rcu_free(struct rcu_head *rcu)
  *
  * On success, return 0. Otherwise return errno.
  */
-static int encrypted_update(struct key *key, const void *data, size_t datalen)
+static int encrypted_update(struct key *key, struct key_preparsed_payload *prep)
 {
 	struct encrypted_key_payload *epayload = key->payload.data;
 	struct encrypted_key_payload *new_epayload;
 	char *buf;
 	char *new_master_desc = NULL;
 	const char *format = NULL;
+	size_t datalen = prep->datalen;
 	int ret = 0;
 
-	if (datalen <= 0 || datalen > 32767 || !data)
+	if (datalen <= 0 || datalen > 32767 || !prep->data)
 		return -EINVAL;
 
 	buf = kmalloc(datalen + 1, GFP_KERNEL);
@@ -851,7 +853,7 @@ static int encrypted_update(struct key *key, const void *data, size_t datalen)
 		return -ENOMEM;
 
 	buf[datalen] = 0;
-	memcpy(buf, data, datalen);
+	memcpy(buf, prep->data, datalen);
 	ret = datablob_parse(buf, &format, &new_master_desc, NULL, NULL);
 	if (ret < 0)
 		goto out;
diff --git a/security/keys/key.c b/security/keys/key.c
index 50d96d4..1d039af 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -412,8 +412,7 @@ EXPORT_SYMBOL(key_payload_reserve);
  * key_construction_mutex.
  */
 static int __key_instantiate_and_link(struct key *key,
-				      const void *data,
-				      size_t datalen,
+				      struct key_preparsed_payload *prep,
 				      struct key *keyring,
 				      struct key *authkey,
 				      unsigned long *_prealloc)
@@ -431,7 +430,7 @@ static int __key_instantiate_and_link(struct key *key,
 	/* can't instantiate twice */
 	if (!test_bit(KEY_FLAG_INSTANTIATED, &key->flags)) {
 		/* instantiate the key */
-		ret = key->type->instantiate(key, data, datalen);
+		ret = key->type->instantiate(key, prep);
 
 		if (ret == 0) {
 			/* mark the key as being instantiated */
@@ -482,22 +481,37 @@ int key_instantiate_and_link(struct key *key,
 			     struct key *keyring,
 			     struct key *authkey)
 {
+	struct key_preparsed_payload prep;
 	unsigned long prealloc;
 	int ret;
 
+	memset(&prep, 0, sizeof(prep));
+	prep.data = data;
+	prep.datalen = datalen;
+	prep.quotalen = key->type->def_datalen;
+	if (key->type->preparse) {
+		ret = key->type->preparse(&prep);
+		if (ret < 0)
+			goto error;
+	}
+
 	if (keyring) {
 		ret = __key_link_begin(keyring, key->type, key->description,
 				       &prealloc);
 		if (ret < 0)
-			return ret;
+			goto error_free_preparse;
 	}
 
-	ret = __key_instantiate_and_link(key, data, datalen, keyring, authkey,
+	ret = __key_instantiate_and_link(key, &prep, keyring, authkey,
 					 &prealloc);
 
 	if (keyring)
 		__key_link_end(keyring, key->type, prealloc);
 
+error_free_preparse:
+	if (key->type->preparse)
+		key->type->free_preparse(&prep);
+error:
 	return ret;
 }
 
@@ -706,7 +720,7 @@ void key_type_put(struct key_type *ktype)
  * if we get an error.
  */
 static inline key_ref_t __key_update(key_ref_t key_ref,
-				     const void *payload, size_t plen)
+				     struct key_preparsed_payload *prep)
 {
 	struct key *key = key_ref_to_ptr(key_ref);
 	int ret;
@@ -722,7 +736,7 @@ static inline key_ref_t __key_update(key_ref_t key_ref,
 
 	down_write(&key->sem);
 
-	ret = key->type->update(key, payload, plen);
+	ret = key->type->update(key, prep);
 	if (ret == 0)
 		/* updating a negative key instantiates it */
 		clear_bit(KEY_FLAG_NEGATIVE, &key->flags);
@@ -774,6 +788,7 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 			       unsigned long flags)
 {
 	unsigned long prealloc;
+	struct key_preparsed_payload prep;
 	const struct cred *cred = current_cred();
 	struct key_type *ktype;
 	struct key *keyring, *key = NULL;
@@ -789,8 +804,9 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 	}
 
 	key_ref = ERR_PTR(-EINVAL);
-	if (!ktype->match || !ktype->instantiate)
-		goto error_2;
+	if (!ktype->match || !ktype->instantiate ||
+	    (!description && !ktype->preparse))
+		goto error_put_type;
 
 	keyring = key_ref_to_ptr(keyring_ref);
 
@@ -798,18 +814,37 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 
 	key_ref = ERR_PTR(-ENOTDIR);
 	if (keyring->type != &key_type_keyring)
-		goto error_2;
+		goto error_put_type;
+
+	memset(&prep, 0, sizeof(prep));
+	prep.data = payload;
+	prep.datalen = plen;
+	prep.quotalen = ktype->def_datalen;
+	if (ktype->preparse) {
+		ret = ktype->preparse(&prep);
+		if (ret < 0) {
+			key_ref = ERR_PTR(ret);
+			goto error_put_type;
+		}
+		if (!description)
+			description = prep.description;
+		key_ref = ERR_PTR(-EINVAL);
+		if (!description)
+			goto error_free_prep;
+	}
 
 	ret = __key_link_begin(keyring, ktype, description, &prealloc);
-	if (ret < 0)
-		goto error_2;
+	if (ret < 0) {
+		key_ref = ERR_PTR(ret);
+		goto error_free_prep;
+	}
 
 	/* if we're going to allocate a new key, we're going to have
 	 * to modify the keyring */
 	ret = key_permission(keyring_ref, KEY_WRITE);
 	if (ret < 0) {
 		key_ref = ERR_PTR(ret);
-		goto error_3;
+		goto error_link_end;
 	}
 
 	/* if it's possible to update this type of key, search for an existing
@@ -840,25 +875,27 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 			perm, flags);
 	if (IS_ERR(key)) {
 		key_ref = ERR_CAST(key);
-		goto error_3;
+		goto error_link_end;
 	}
 
 	/* instantiate it and link it into the target keyring */
-	ret = __key_instantiate_and_link(key, payload, plen, keyring, NULL,
-					 &prealloc);
+	ret = __key_instantiate_and_link(key, &prep, keyring, NULL, &prealloc);
 	if (ret < 0) {
 		key_put(key);
 		key_ref = ERR_PTR(ret);
-		goto error_3;
+		goto error_link_end;
 	}
 
 	key_ref = make_key_ref(key, is_key_possessed(keyring_ref));
 
- error_3:
+error_link_end:
 	__key_link_end(keyring, ktype, prealloc);
- error_2:
+error_free_prep:
+	if (ktype->preparse)
+		ktype->free_preparse(&prep);
+error_put_type:
 	key_type_put(ktype);
- error:
+error:
 	return key_ref;
 
  found_matching_key:
@@ -866,10 +903,9 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 	 * - we can drop the locks first as we have the key pinned
 	 */
 	__key_link_end(keyring, ktype, prealloc);
-	key_type_put(ktype);
 
-	key_ref = __key_update(key_ref, payload, plen);
-	goto error;
+	key_ref = __key_update(key_ref, &prep);
+	goto error_free_prep;
 }
 EXPORT_SYMBOL(key_create_or_update);
 
@@ -888,6 +924,7 @@ EXPORT_SYMBOL(key_create_or_update);
  */
 int key_update(key_ref_t key_ref, const void *payload, size_t plen)
 {
+	struct key_preparsed_payload prep;
 	struct key *key = key_ref_to_ptr(key_ref);
 	int ret;
 
@@ -900,18 +937,31 @@ int key_update(key_ref_t key_ref, const void *payload, size_t plen)
 
 	/* attempt to update it if supported */
 	ret = -EOPNOTSUPP;
-	if (key->type->update) {
-		down_write(&key->sem);
-
-		ret = key->type->update(key, payload, plen);
-		if (ret == 0)
-			/* updating a negative key instantiates it */
-			clear_bit(KEY_FLAG_NEGATIVE, &key->flags);
+	if (!key->type->update)
+		goto error;
 
-		up_write(&key->sem);
+	memset(&prep, 0, sizeof(prep));
+	prep.data = payload;
+	prep.datalen = plen;
+	prep.quotalen = key->type->def_datalen;
+	if (key->type->preparse) {
+		ret = key->type->preparse(&prep);
+		if (ret < 0)
+			goto error;
 	}
 
- error:
+	down_write(&key->sem);
+
+	ret = key->type->update(key, &prep);
+	if (ret == 0)
+		/* updating a negative key instantiates it */
+		clear_bit(KEY_FLAG_NEGATIVE, &key->flags);
+
+	up_write(&key->sem);
+
+	if (key->type->preparse)
+		key->type->free_preparse(&prep);
+error:
 	return ret;
 }
 EXPORT_SYMBOL(key_update);
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 3364fbf..505d40b 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -46,6 +46,9 @@ static int key_get_type_from_user(char *type,
  * Extract the description of a new key from userspace and either add it as a
  * new key to the specified keyring or update a matching key in that keyring.
  *
+ * If the description is NULL or an empty string, the key type is asked to
+ * generate one from the payload.
+ *
  * The keyring must be writable so that we can attach the key to it.
  *
  * If successful, the new key's serial number is returned, otherwise an error
@@ -72,10 +75,17 @@ SYSCALL_DEFINE5(add_key, const char __user *, _type,
 	if (ret < 0)
 		goto error;
 
-	description = strndup_user(_description, PAGE_SIZE);
-	if (IS_ERR(description)) {
-		ret = PTR_ERR(description);
-		goto error;
+	description = NULL;
+	if (_description) {
+		description = strndup_user(_description, PAGE_SIZE);
+		if (IS_ERR(description)) {
+			ret = PTR_ERR(description);
+			goto error;
+		}
+		if (!*description) {
+			kfree(description);
+			description = NULL;
+		}
 	}
 
 	/* pull the payload in if one was supplied */
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 81e7852..f04d8cf 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -66,7 +66,7 @@ static inline unsigned keyring_hash(const char *desc)
  * operations.
  */
 static int keyring_instantiate(struct key *keyring,
-			       const void *data, size_t datalen);
+			       struct key_preparsed_payload *prep);
 static int keyring_match(const struct key *keyring, const void *criterion);
 static void keyring_revoke(struct key *keyring);
 static void keyring_destroy(struct key *keyring);
@@ -121,12 +121,12 @@ static void keyring_publish_name(struct key *keyring)
  * Returns 0 on success, -EINVAL if given any data.
  */
 static int keyring_instantiate(struct key *keyring,
-			       const void *data, size_t datalen)
+			       struct key_preparsed_payload *prep)
 {
 	int ret;
 
 	ret = -EINVAL;
-	if (datalen == 0) {
+	if (prep->datalen == 0) {
 		/* make the keyring available by name if it has one */
 		keyring_publish_name(keyring);
 		ret = 0;
diff --git a/security/keys/request_key_auth.c b/security/keys/request_key_auth.c
index 60d4e3f..85730d5 100644
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -19,7 +19,8 @@
 #include <asm/uaccess.h>
 #include "internal.h"
 
-static int request_key_auth_instantiate(struct key *, const void *, size_t);
+static int request_key_auth_instantiate(struct key *,
+					struct key_preparsed_payload *);
 static void request_key_auth_describe(const struct key *, struct seq_file *);
 static void request_key_auth_revoke(struct key *);
 static void request_key_auth_destroy(struct key *);
@@ -42,10 +43,9 @@ struct key_type key_type_request_key_auth = {
  * Instantiate a request-key authorisation key.
  */
 static int request_key_auth_instantiate(struct key *key,
-					const void *data,
-					size_t datalen)
+					struct key_preparsed_payload *prep)
 {
-	key->payload.data = (struct request_key_auth *) data;
+	key->payload.data = (struct request_key_auth *)prep->data;
 	return 0;
 }
 
diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index 2d5d041..42036c7 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -927,22 +927,23 @@ static struct trusted_key_payload *trusted_payload_alloc(struct key *key)
  *
  * On success, return 0. Otherwise return errno.
  */
-static int trusted_instantiate(struct key *key, const void *data,
-			       size_t datalen)
+static int trusted_instantiate(struct key *key,
+			       struct key_preparsed_payload *prep)
 {
 	struct trusted_key_payload *payload = NULL;
 	struct trusted_key_options *options = NULL;
+	size_t datalen = prep->datalen;
 	char *datablob;
 	int ret = 0;
 	int key_cmd;
 
-	if (datalen <= 0 || datalen > 32767 || !data)
+	if (datalen <= 0 || datalen > 32767 || !prep->data)
 		return -EINVAL;
 
 	datablob = kmalloc(datalen + 1, GFP_KERNEL);
 	if (!datablob)
 		return -ENOMEM;
-	memcpy(datablob, data, datalen);
+	memcpy(datablob, prep->data, datalen);
 	datablob[datalen] = '\0';
 
 	options = trusted_options_alloc();
@@ -1011,17 +1012,18 @@ static void trusted_rcu_free(struct rcu_head *rcu)
 /*
  * trusted_update - reseal an existing key with new PCR values
  */
-static int trusted_update(struct key *key, const void *data, size_t datalen)
+static int trusted_update(struct key *key, struct key_preparsed_payload *prep)
 {
 	struct trusted_key_payload *p = key->payload.data;
 	struct trusted_key_payload *new_p;
 	struct trusted_key_options *new_o;
+	size_t datalen = prep->datalen;
 	char *datablob;
 	int ret = 0;
 
 	if (!p->migratable)
 		return -EPERM;
-	if (datalen <= 0 || datalen > 32767 || !data)
+	if (datalen <= 0 || datalen > 32767 || !prep->data)
 		return -EINVAL;
 
 	datablob = kmalloc(datalen + 1, GFP_KERNEL);
@@ -1038,7 +1040,7 @@ static int trusted_update(struct key *key, const void *data, size_t datalen)
 		goto out;
 	}
 
-	memcpy(datablob, data, datalen);
+	memcpy(datablob, prep->data, datalen);
 	datablob[datalen] = '\0';
 	ret = datablob_parse(datablob, new_p, new_o);
 	if (ret != Opt_update) {
diff --git a/security/keys/user_defined.c b/security/keys/user_defined.c
index c7660a2..55dc889 100644
--- a/security/keys/user_defined.c
+++ b/security/keys/user_defined.c
@@ -58,13 +58,14 @@ EXPORT_SYMBOL_GPL(key_type_logon);
 /*
  * instantiate a user defined key
  */
-int user_instantiate(struct key *key, const void *data, size_t datalen)
+int user_instantiate(struct key *key, struct key_preparsed_payload *prep)
 {
 	struct user_key_payload *upayload;
+	size_t datalen = prep->datalen;
 	int ret;
 
 	ret = -EINVAL;
-	if (datalen <= 0 || datalen > 32767 || !data)
+	if (datalen <= 0 || datalen > 32767 || !prep->data)
 		goto error;
 
 	ret = key_payload_reserve(key, datalen);
@@ -78,7 +79,7 @@ int user_instantiate(struct key *key, const void *data, size_t datalen)
 
 	/* attach the data */
 	upayload->datalen = datalen;
-	memcpy(upayload->data, data, datalen);
+	memcpy(upayload->data, prep->data, datalen);
 	rcu_assign_keypointer(key, upayload);
 	ret = 0;
 
@@ -92,13 +93,14 @@ EXPORT_SYMBOL_GPL(user_instantiate);
  * update a user defined key
  * - the key's semaphore is write-locked
  */
-int user_update(struct key *key, const void *data, size_t datalen)
+int user_update(struct key *key, struct key_preparsed_payload *prep)
 {
 	struct user_key_payload *upayload, *zap;
+	size_t datalen = prep->datalen;
 	int ret;
 
 	ret = -EINVAL;
-	if (datalen <= 0 || datalen > 32767 || !data)
+	if (datalen <= 0 || datalen > 32767 || !prep->data)
 		goto error;
 
 	/* construct a replacement payload */
@@ -108,7 +110,7 @@ int user_update(struct key *key, const void *data, size_t datalen)
 		goto error;
 
 	upayload->datalen = datalen;
-	memcpy(upayload->data, data, datalen);
+	memcpy(upayload->data, prep->data, datalen);
 
 	/* check the quota and attach the new data */
 	zap = upayload;

