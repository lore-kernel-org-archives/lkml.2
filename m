Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934069Ab0D3Sex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:34:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933140Ab0D3RVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:21:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 7/7] KEYS: Do preallocation for __key_link()
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Fri, 30 Apr 2010 14:32:39 +0100
Message-ID: <20100430133239.2126.38583.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100430133208.2126.56765.stgit@warthog.procyon.org.uk>
References: <20100430133208.2126.56765.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do preallocation for __key_link() so that the various callers in request_key.c
can deal with any errors from this source before attempting to construct a key.
This allows them to assume that the actual linkage step is guaranteed to be
successful.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/internal.h    |   11 ++
 security/keys/key.c         |   45 +++++---
 security/keys/keyring.c     |  242 ++++++++++++++++++++++++++-----------------
 security/keys/request_key.c |   47 ++++++--
 4 files changed, 215 insertions(+), 130 deletions(-)

diff --git a/security/keys/internal.h b/security/keys/internal.h
index 24ba030..5d4402a 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -87,7 +87,16 @@ extern wait_queue_head_t request_key_conswq;
 extern struct key_type *key_type_lookup(const char *type);
 extern void key_type_put(struct key_type *ktype);
 
-extern int __key_link(struct key *keyring, struct key *key);
+extern int __key_link_begin(struct key *keyring,
+			    const struct key_type *type,
+			    const char *description,
+			    struct keyring_list **_prealloc);
+extern int __key_link_check_live_key(struct key *keyring, struct key *key);
+extern void __key_link(struct key *keyring, struct key *key,
+		       struct keyring_list **_prealloc);
+extern void __key_link_end(struct key *keyring,
+			   struct key_type *type,
+			   struct keyring_list *prealloc);
 
 extern key_ref_t __keyring_search_one(key_ref_t keyring_ref,
 				      const struct key_type *type,
diff --git a/security/keys/key.c b/security/keys/key.c
index e50d264..4a5984c 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -398,7 +398,8 @@ static int __key_instantiate_and_link(struct key *key,
 				      const void *data,
 				      size_t datalen,
 				      struct key *keyring,
-				      struct key *authkey)
+				      struct key *authkey,
+				      struct keyring_list **_prealloc)
 {
 	int ret, awaken;
 
@@ -425,7 +426,7 @@ static int __key_instantiate_and_link(struct key *key,
 
 			/* and link it into the destination keyring */
 			if (keyring)
-				ret = __key_link(keyring, key);
+				__key_link(keyring, key, _prealloc);
 
 			/* disable the authorisation key */
 			if (authkey)
@@ -453,15 +454,21 @@ int key_instantiate_and_link(struct key *key,
 			     struct key *keyring,
 			     struct key *authkey)
 {
+	struct keyring_list *prealloc;
 	int ret;
 
-	if (keyring)
-		down_write(&keyring->sem);
+	if (keyring) {
+		ret = __key_link_begin(keyring, key->type, key->description,
+				       &prealloc);
+		if (ret < 0)
+			return ret;
+	}
 
-	ret = __key_instantiate_and_link(key, data, datalen, keyring, authkey);
+	ret = __key_instantiate_and_link(key, data, datalen, keyring, authkey,
+					 &prealloc);
 
 	if (keyring)
-		up_write(&keyring->sem);
+		__key_link_end(keyring, key->type, prealloc);
 
 	return ret;
 
@@ -478,8 +485,9 @@ int key_negate_and_link(struct key *key,
 			struct key *keyring,
 			struct key *authkey)
 {
+	struct keyring_list *prealloc;
 	struct timespec now;
-	int ret, awaken;
+	int ret, awaken, link_ret = 0;
 
 	key_check(key);
 	key_check(keyring);
@@ -488,7 +496,8 @@ int key_negate_and_link(struct key *key,
 	ret = -EBUSY;
 
 	if (keyring)
-		down_write(&keyring->sem);
+		link_ret = __key_link_begin(keyring, key->type,
+					    key->description, &prealloc);
 
 	mutex_lock(&key_construction_mutex);
 
@@ -508,8 +517,8 @@ int key_negate_and_link(struct key *key,
 		ret = 0;
 
 		/* and link it into the destination keyring */
-		if (keyring)
-			ret = __key_link(keyring, key);
+		if (keyring && link_ret == 0)
+			__key_link(keyring, key, &prealloc);
 
 		/* disable the authorisation key */
 		if (authkey)
@@ -519,13 +528,13 @@ int key_negate_and_link(struct key *key,
 	mutex_unlock(&key_construction_mutex);
 
 	if (keyring)
-		up_write(&keyring->sem);
+		__key_link_end(keyring, key->type, prealloc);
 
 	/* wake up anyone waiting for a key to be constructed */
 	if (awaken)
 		wake_up_bit(&key->flags, KEY_FLAG_USER_CONSTRUCT);
 
-	return ret;
+	return ret == 0 ? link_ret : ret;
 
 } /* end key_negate_and_link() */
 
@@ -749,6 +758,7 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 			       key_perm_t perm,
 			       unsigned long flags)
 {
+	struct keyring_list *prealloc;
 	const struct cred *cred = current_cred();
 	struct key_type *ktype;
 	struct key *keyring, *key = NULL;
@@ -775,7 +785,9 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 	if (keyring->type != &key_type_keyring)
 		goto error_2;
 
-	down_write(&keyring->sem);
+	ret = __key_link_begin(keyring, ktype, description, &prealloc);
+	if (ret < 0)
+		goto error_2;
 
 	/* if we're going to allocate a new key, we're going to have
 	 * to modify the keyring */
@@ -817,7 +829,8 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 	}
 
 	/* instantiate it and link it into the target keyring */
-	ret = __key_instantiate_and_link(key, payload, plen, keyring, NULL);
+	ret = __key_instantiate_and_link(key, payload, plen, keyring, NULL,
+					 &prealloc);
 	if (ret < 0) {
 		key_put(key);
 		key_ref = ERR_PTR(ret);
@@ -827,7 +840,7 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 	key_ref = make_key_ref(key, is_key_possessed(keyring_ref));
 
  error_3:
-	up_write(&keyring->sem);
+	__key_link_end(keyring, ktype, prealloc);
  error_2:
 	key_type_put(ktype);
  error:
@@ -837,7 +850,7 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 	/* we found a matching key, so we're going to try to update it
 	 * - we can drop the locks first as we have the key pinned
 	 */
-	up_write(&keyring->sem);
+	__key_link_end(keyring, ktype, prealloc);
 	key_type_put(ktype);
 
 	key_ref = __key_update(key_ref, payload, plen);
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 4dc2284..b2ce9a8 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -662,20 +662,6 @@ static int keyring_detect_cycle(struct key *A, struct key *B)
 
 } /* end keyring_detect_cycle() */
 
-/*****************************************************************************/
-/*
- * dispose of a keyring list after the RCU grace period
- */
-static void keyring_link_rcu_disposal(struct rcu_head *rcu)
-{
-	struct keyring_list *klist =
-		container_of(rcu, struct keyring_list, rcu);
-
-	kfree(klist);
-
-} /* end keyring_link_rcu_disposal() */
-
-/*****************************************************************************/
 /*
  * dispose of a keyring list after the RCU grace period, freeing the unlinked
  * key
@@ -685,56 +671,51 @@ static void keyring_unlink_rcu_disposal(struct rcu_head *rcu)
 	struct keyring_list *klist =
 		container_of(rcu, struct keyring_list, rcu);
 
-	key_put(klist->keys[klist->delkey]);
+	if (klist->delkey != USHORT_MAX)
+		key_put(klist->keys[klist->delkey]);
 	kfree(klist);
+}
 
-} /* end keyring_unlink_rcu_disposal() */
-
-/*****************************************************************************/
 /*
- * link a key into to a keyring
- * - must be called with the keyring's semaphore write-locked
- * - discard already extant link to matching key if there is one
+ * preallocate memory so that a key can be linked into to a keyring
  */
-int __key_link(struct key *keyring, struct key *key)
+int __key_link_begin(struct key *keyring, const struct key_type *type,
+		     const char *description,
+		     struct keyring_list **_prealloc)
+	__acquires(&keyring->sem)
 {
 	struct keyring_list *klist, *nklist;
 	unsigned max;
 	size_t size;
 	int loop, ret;
 
-	ret = -EKEYREVOKED;
-	if (test_bit(KEY_FLAG_REVOKED, &keyring->flags))
-		goto error;
+	kenter("%d,%s,%s,", key_serial(keyring), type->name, description);
 
-	ret = -ENOTDIR;
 	if (keyring->type != &key_type_keyring)
-		goto error;
+		return -ENOTDIR;
+
+	down_write(&keyring->sem);
+
+	ret = -EKEYREVOKED;
+	if (test_bit(KEY_FLAG_REVOKED, &keyring->flags))
+		goto error_krsem;
 
-	/* do some special keyring->keyring link checks */
-	if (key->type == &key_type_keyring) {
-		/* serialise link/link calls to prevent parallel calls causing
-		 * a cycle when applied to two keyring in opposite orders */
+	/* serialise link/link calls to prevent parallel calls causing a cycle
+	 * when linking two keyring in opposite orders */
+	if (type == &key_type_keyring)
 		down_write(&keyring_serialise_link_sem);
 
-		/* check that we aren't going to create a cycle adding one
-		 * keyring to another */
-		ret = keyring_detect_cycle(keyring, key);
-		if (ret < 0)
-			goto error2;
-	}
+	klist = rcu_dereference_locked_keyring(keyring);
 
 	/* see if there's a matching key we can displace */
-	klist = rcu_dereference_locked_keyring(keyring);
 	if (klist && klist->nkeys > 0) {
-		struct key_type *type = key->type;
-
 		for (loop = klist->nkeys - 1; loop >= 0; loop--) {
 			if (klist->keys[loop]->type == type &&
 			    strcmp(klist->keys[loop]->description,
-				   key->description) == 0
+				   description) == 0
 			    ) {
-				/* found a match - replace with new key */
+				/* found a match - we'll replace this one with
+				 * the new key */
 				size = sizeof(struct key *) * klist->maxkeys;
 				size += sizeof(*klist);
 				BUG_ON(size > PAGE_SIZE);
@@ -742,22 +723,10 @@ int __key_link(struct key *keyring, struct key *key)
 				ret = -ENOMEM;
 				nklist = kmemdup(klist, size, GFP_KERNEL);
 				if (!nklist)
-					goto error2;
-
-				/* replace matched key */
-				atomic_inc(&key->usage);
-				nklist->keys[loop] = key;
-
-				rcu_assign_pointer(
-					keyring->payload.subscriptions,
-					nklist);
-
-				/* dispose of the old keyring list and the
-				 * displaced key */
-				klist->delkey = loop;
-				call_rcu(&klist->rcu,
-					 keyring_unlink_rcu_disposal);
+					goto error_sem;
 
+				/* note replacement slot */
+				klist->delkey = nklist->delkey = loop;
 				goto done;
 			}
 		}
@@ -767,16 +736,11 @@ int __key_link(struct key *keyring, struct key *key)
 	ret = key_payload_reserve(keyring,
 				  keyring->datalen + KEYQUOTA_LINK_BYTES);
 	if (ret < 0)
-		goto error2;
+		goto error_sem;
 
 	if (klist && klist->nkeys < klist->maxkeys) {
-		/* there's sufficient slack space to add directly */
-		atomic_inc(&key->usage);
-
-		klist->keys[klist->nkeys] = key;
-		smp_wmb();
-		klist->nkeys++;
-		smp_wmb();
+		/* there's sufficient slack space to append directly */
+		nklist = NULL;
 	} else {
 		/* grow the key list */
 		max = 4;
@@ -784,71 +748,155 @@ int __key_link(struct key *keyring, struct key *key)
 			max += klist->maxkeys;
 
 		ret = -ENFILE;
-		if (max > 65535)
-			goto error3;
+		if (max > USHORT_MAX - 1)
+			goto error_quota;
 		size = sizeof(*klist) + sizeof(struct key *) * max;
 		if (size > PAGE_SIZE)
-			goto error3;
+			goto error_quota;
 
 		ret = -ENOMEM;
 		nklist = kmalloc(size, GFP_KERNEL);
 		if (!nklist)
-			goto error3;
-		nklist->maxkeys = max;
-		nklist->nkeys = 0;
+			goto error_quota;
 
+		nklist->maxkeys = max;
 		if (klist) {
-			nklist->nkeys = klist->nkeys;
-			memcpy(nklist->keys,
-			       klist->keys,
+			memcpy(nklist->keys, klist->keys,
 			       sizeof(struct key *) * klist->nkeys);
+			nklist->delkey = klist->nkeys;
+			nklist->nkeys = klist->nkeys + 1;
+			klist->delkey = USHORT_MAX;
+		} else {
+			nklist->nkeys = 1;
+			nklist->delkey = 0;
 		}
 
 		/* add the key into the new space */
-		atomic_inc(&key->usage);
-		nklist->keys[nklist->nkeys++] = key;
-
-		rcu_assign_pointer(keyring->payload.subscriptions, nklist);
-
-		/* dispose of the old keyring list */
-		if (klist)
-			call_rcu(&klist->rcu, keyring_link_rcu_disposal);
+		nklist->keys[nklist->delkey] = NULL;
 	}
 
 done:
-	ret = 0;
-error2:
-	if (key->type == &key_type_keyring)
-		up_write(&keyring_serialise_link_sem);
-error:
-	return ret;
+	*_prealloc = nklist;
+	kleave(" = 0");
+	return 0;
 
-error3:
+error_quota:
 	/* undo the quota changes */
 	key_payload_reserve(keyring,
 			    keyring->datalen - KEYQUOTA_LINK_BYTES);
-	goto error2;
+error_sem:
+	if (type == &key_type_keyring)
+		up_write(&keyring_serialise_link_sem);
+error_krsem:
+	up_write(&keyring->sem);
+	kleave(" = %d", ret);
+	return ret;
+}
 
-} /* end __key_link() */
+/*
+ * check already instantiated keys aren't going to be a problem
+ * - the caller must have called __key_link_begin()
+ * - don't need to call this for keys that were created since __key_link_begin()
+ *   was called
+ */
+int __key_link_check_live_key(struct key *keyring, struct key *key)
+{
+	if (key->type == &key_type_keyring)
+		/* check that we aren't going to create a cycle by linking one
+		 * keyring to another */
+		return keyring_detect_cycle(keyring, key);
+	return 0;
+}
+
+/*
+ * link a key into to a keyring
+ * - must be called with __key_link_begin() having being called
+ * - discard already extant link to matching key if there is one
+ */
+void __key_link(struct key *keyring, struct key *key,
+		struct keyring_list **_prealloc)
+{
+	struct keyring_list *klist, *nklist;
+
+	nklist = *_prealloc;
+	*_prealloc = NULL;
+
+	kenter("%d,%d,%p", keyring->serial, key->serial, nklist);
+
+	klist = rcu_dereference_protected(keyring->payload.subscriptions,
+					  rwsem_is_locked(&keyring->sem));
+
+	atomic_inc(&key->usage);
+
+	/* there's a matching key we can displace or an empty slot in a newly
+	 * allocated list we can fill */
+	if (nklist) {
+		kdebug("replace %hu/%hu/%hu",
+		       nklist->delkey, nklist->nkeys, nklist->maxkeys);
+
+		nklist->keys[nklist->delkey] = key;
+
+		rcu_assign_pointer(keyring->payload.subscriptions, nklist);
+
+		/* dispose of the old keyring list and, if there was one, the
+		 * displaced key */
+		if (klist) {
+			kdebug("dispose %hu/%hu/%hu",
+			       klist->delkey, klist->nkeys, klist->maxkeys);
+			call_rcu(&klist->rcu, keyring_unlink_rcu_disposal);
+		}
+	} else {
+		/* there's sufficient slack space to append directly */
+		klist->keys[klist->nkeys] = key;
+		smp_wmb();
+		klist->nkeys++;
+	}
+}
+
+/*
+ * finish linking a key into to a keyring
+ * - must be called with __key_link_begin() having being called
+ */
+void __key_link_end(struct key *keyring, struct key_type *type,
+		    struct keyring_list *prealloc)
+	__releases(&keyring->sem)
+{
+	BUG_ON(type == NULL);
+	BUG_ON(type->name == NULL);
+	kenter("%d,%s,%p", keyring->serial, type->name, prealloc);
+
+	if (type == &key_type_keyring)
+		up_write(&keyring_serialise_link_sem);
+
+	if (prealloc) {
+		kfree(prealloc);
+		key_payload_reserve(keyring,
+				    keyring->datalen - KEYQUOTA_LINK_BYTES);
+	}
+	up_write(&keyring->sem);
+}
 
-/*****************************************************************************/
 /*
  * link a key to a keyring
  */
 int key_link(struct key *keyring, struct key *key)
 {
+	struct keyring_list *prealloc;
 	int ret;
 
 	key_check(keyring);
 	key_check(key);
 
-	down_write(&keyring->sem);
-	ret = __key_link(keyring, key);
-	up_write(&keyring->sem);
+	ret = __key_link_begin(keyring, key->type, key->description, &prealloc);
+	if (ret == 0) {
+		ret = __key_link_check_live_key(keyring, key);
+		if (ret == 0)
+			__key_link(keyring, key, &prealloc);
+		__key_link_end(keyring, key->type, prealloc);
+	}
 
 	return ret;
-
-} /* end key_link() */
+}
 
 EXPORT_SYMBOL(key_link);
 
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index ac49c8a..f656e9c 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -299,6 +299,7 @@ static int construct_alloc_key(struct key_type *type,
 			       struct key_user *user,
 			       struct key **_key)
 {
+	struct keyring_list *prealloc;
 	const struct cred *cred = current_cred();
 	struct key *key;
 	key_ref_t key_ref;
@@ -306,6 +307,7 @@ static int construct_alloc_key(struct key_type *type,
 
 	kenter("%s,%s,,,", type->name, description);
 
+	*_key = NULL;
 	mutex_lock(&user->cons_lock);
 
 	key = key_alloc(type, description, cred->fsuid, cred->fsgid, cred,
@@ -315,8 +317,12 @@ static int construct_alloc_key(struct key_type *type,
 
 	set_bit(KEY_FLAG_USER_CONSTRUCT, &key->flags);
 
-	if (dest_keyring)
-		down_write(&dest_keyring->sem);
+	if (dest_keyring) {
+		ret = __key_link_begin(dest_keyring, type, description,
+				       &prealloc);
+		if (ret < 0)
+			goto link_prealloc_failed;
+	}
 
 	/* attach the key to the destination keyring under lock, but we do need
 	 * to do another check just in case someone beat us to it whilst we
@@ -328,11 +334,11 @@ static int construct_alloc_key(struct key_type *type,
 		goto key_already_present;
 
 	if (dest_keyring)
-		__key_link(dest_keyring, key);
+		__key_link(dest_keyring, key, &prealloc);
 
 	mutex_unlock(&key_construction_mutex);
 	if (dest_keyring)
-		up_write(&dest_keyring->sem);
+		__key_link_end(dest_keyring, type, prealloc);
 	mutex_unlock(&user->cons_lock);
 	*_key = key;
 	kleave(" = 0 [%d]", key_serial(key));
@@ -341,27 +347,36 @@ static int construct_alloc_key(struct key_type *type,
 	/* the key is now present - we tell the caller that we found it by
 	 * returning -EINPROGRESS  */
 key_already_present:
+	key_put(key);
 	mutex_unlock(&key_construction_mutex);
-	ret = 0;
+	key = key_ref_to_ptr(key_ref);
 	if (dest_keyring) {
-		ret = __key_link(dest_keyring, key_ref_to_ptr(key_ref));
-		up_write(&dest_keyring->sem);
+		ret = __key_link_check_live_key(dest_keyring, key);
+		if (ret == 0)
+			__key_link(dest_keyring, key, &prealloc);
+		__key_link_end(dest_keyring, type, prealloc);
+		if (ret < 0)
+			goto link_check_failed;
 	}
 	mutex_unlock(&user->cons_lock);
-	key_put(key);
-	if (ret < 0) {
-		key_ref_put(key_ref);
-		*_key = NULL;
-		kleave(" = %d [link]", ret);
-		return ret;
-	}
-	*_key = key = key_ref_to_ptr(key_ref);
+	*_key = key;
 	kleave(" = -EINPROGRESS [%d]", key_serial(key));
 	return -EINPROGRESS;
 
+link_check_failed:
+	mutex_unlock(&user->cons_lock);
+	key_put(key);
+	kleave(" = %d [linkcheck]", ret);
+	return ret;
+
+link_prealloc_failed:
+	up_write(&dest_keyring->sem);
+	mutex_unlock(&user->cons_lock);
+	kleave(" = %d [prelink]", ret);
+	return ret;
+
 alloc_failed:
 	mutex_unlock(&user->cons_lock);
-	*_key = NULL;
 	kleave(" = %ld", PTR_ERR(key));
 	return PTR_ERR(key);
 }

