Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab1AYQgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 11:36:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab1AYQgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 11:36:16 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] KEYS: Fix __key_link_end() quota fixup on error
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dave@gnu.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Tue, 25 Jan 2011 16:34:28 +0000
Message-ID: <20110125163428.8139.59208.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix __key_link_end()'s attempt to fix up the quota if an error occurs.

There are two erroneous cases: Firstly, we always decrease the quota if the
preallocated replacement keyring needs cleaning up, irrespective of whether or
not we should (we may have replaced a pointer rather than adding another
pointer).

Secondly, we never clean up the quota if we added a pointer without the keyring
storage being extended (we allocate multiple pointers at a time, even if we're
not going to use them all immediately).

We handle this by setting the bottom bit of the preallocation pointer in
__key_link_begin() to indicate that the quota needs fixing up, which is then
passed to __key_link() (which clears the whole thing) and __key_link_end().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/internal.h    |    6 +++---
 security/keys/key.c         |    8 ++++----
 security/keys/keyring.c     |   31 +++++++++++++++++++------------
 security/keys/request_key.c |    2 +-
 4 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/security/keys/internal.h b/security/keys/internal.h
index edfa50d..a52aa7c 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -87,13 +87,13 @@ extern void key_type_put(struct key_type *ktype);
 extern int __key_link_begin(struct key *keyring,
 			    const struct key_type *type,
 			    const char *description,
-			    struct keyring_list **_prealloc);
+			    unsigned long *_prealloc);
 extern int __key_link_check_live_key(struct key *keyring, struct key *key);
 extern void __key_link(struct key *keyring, struct key *key,
-		       struct keyring_list **_prealloc);
+		       unsigned long *_prealloc);
 extern void __key_link_end(struct key *keyring,
 			   struct key_type *type,
-			   struct keyring_list *prealloc);
+			   unsigned long prealloc);
 
 extern key_ref_t __keyring_search_one(key_ref_t keyring_ref,
 				      const struct key_type *type,
diff --git a/security/keys/key.c b/security/keys/key.c
index 84d4eb5..1c2d43d 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -415,7 +415,7 @@ static int __key_instantiate_and_link(struct key *key,
 				      size_t datalen,
 				      struct key *keyring,
 				      struct key *authkey,
-				      struct keyring_list **_prealloc)
+				      unsigned long *_prealloc)
 {
 	int ret, awaken;
 
@@ -481,7 +481,7 @@ int key_instantiate_and_link(struct key *key,
 			     struct key *keyring,
 			     struct key *authkey)
 {
-	struct keyring_list *prealloc;
+	unsigned long prealloc;
 	int ret;
 
 	if (keyring) {
@@ -526,7 +526,7 @@ int key_negate_and_link(struct key *key,
 			struct key *keyring,
 			struct key *authkey)
 {
-	struct keyring_list *prealloc;
+	unsigned long prealloc;
 	struct timespec now;
 	int ret, awaken, link_ret = 0;
 
@@ -814,7 +814,7 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 			       key_perm_t perm,
 			       unsigned long flags)
 {
-	struct keyring_list *prealloc;
+	unsigned long prealloc;
 	const struct cred *cred = current_cred();
 	struct key_type *ktype;
 	struct key *keyring, *key = NULL;
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 92024ed..5620f08 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -25,6 +25,8 @@
 		(keyring)->payload.subscriptions,			\
 		rwsem_is_locked((struct rw_semaphore *)&(keyring)->sem)))
 
+#define KEY_LINK_FIXQUOTA 1UL
+
 /*
  * When plumbing the depths of the key tree, this sets a hard limit
  * set on how deep we're willing to go.
@@ -699,11 +701,11 @@ static void keyring_unlink_rcu_disposal(struct rcu_head *rcu)
  * Preallocate memory so that a key can be linked into to a keyring.
  */
 int __key_link_begin(struct key *keyring, const struct key_type *type,
-		     const char *description,
-		     struct keyring_list **_prealloc)
+		     const char *description, unsigned long *_prealloc)
 	__acquires(&keyring->sem)
 {
 	struct keyring_list *klist, *nklist;
+	unsigned long prealloc;
 	unsigned max;
 	size_t size;
 	int loop, ret;
@@ -746,6 +748,7 @@ int __key_link_begin(struct key *keyring, const struct key_type *type,
 
 				/* note replacement slot */
 				klist->delkey = nklist->delkey = loop;
+				prealloc = (unsigned long)nklist;
 				goto done;
 			}
 		}
@@ -760,6 +763,7 @@ int __key_link_begin(struct key *keyring, const struct key_type *type,
 	if (klist && klist->nkeys < klist->maxkeys) {
 		/* there's sufficient slack space to append directly */
 		nklist = NULL;
+		prealloc = KEY_LINK_FIXQUOTA;
 	} else {
 		/* grow the key list */
 		max = 4;
@@ -794,8 +798,9 @@ int __key_link_begin(struct key *keyring, const struct key_type *type,
 		nklist->keys[nklist->delkey] = NULL;
 	}
 
+	prealloc = (unsigned long)nklist | KEY_LINK_FIXQUOTA;
 done:
-	*_prealloc = nklist;
+	*_prealloc = prealloc;
 	kleave(" = 0");
 	return 0;
 
@@ -836,12 +841,12 @@ int __key_link_check_live_key(struct key *keyring, struct key *key)
  * combination.
  */
 void __key_link(struct key *keyring, struct key *key,
-		struct keyring_list **_prealloc)
+		unsigned long *_prealloc)
 {
 	struct keyring_list *klist, *nklist;
 
-	nklist = *_prealloc;
-	*_prealloc = NULL;
+	nklist = (struct keyring_list *)(*_prealloc & ~KEY_LINK_FIXQUOTA);
+	*_prealloc = 0;
 
 	kenter("%d,%d,%p", keyring->serial, key->serial, nklist);
 
@@ -881,20 +886,22 @@ void __key_link(struct key *keyring, struct key *key,
  * Must be called with __key_link_begin() having being called.
  */
 void __key_link_end(struct key *keyring, struct key_type *type,
-		    struct keyring_list *prealloc)
+		    unsigned long prealloc)
 	__releases(&keyring->sem)
 {
 	BUG_ON(type == NULL);
 	BUG_ON(type->name == NULL);
-	kenter("%d,%s,%p", keyring->serial, type->name, prealloc);
+	kenter("%d,%s,%lx", keyring->serial, type->name, prealloc);
 
 	if (type == &key_type_keyring)
 		up_write(&keyring_serialise_link_sem);
 
 	if (prealloc) {
-		kfree(prealloc);
-		key_payload_reserve(keyring,
-				    keyring->datalen - KEYQUOTA_LINK_BYTES);
+		if (prealloc & KEY_LINK_FIXQUOTA)
+			key_payload_reserve(keyring,
+					    keyring->datalen -
+					    KEYQUOTA_LINK_BYTES);
+		kfree((struct keyring_list *)(prealloc & ~KEY_LINK_FIXQUOTA));
 	}
 	up_write(&keyring->sem);
 }
@@ -921,7 +928,7 @@ void __key_link_end(struct key *keyring, struct key_type *type,
  */
 int key_link(struct key *keyring, struct key *key)
 {
-	struct keyring_list *prealloc;
+	unsigned long prealloc;
 	int ret;
 
 	key_check(keyring);
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 9a7fb39..a3dc0d4 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -352,8 +352,8 @@ static int construct_alloc_key(struct key_type *type,
 			       struct key_user *user,
 			       struct key **_key)
 {
-	struct keyring_list *prealloc;
 	const struct cred *cred = current_cred();
+	unsigned long prealloc;
 	struct key *key;
 	key_ref_t key_ref;
 	int ret;

