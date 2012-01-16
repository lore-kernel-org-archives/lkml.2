Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab2APQEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 11:04:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524Ab2APQD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 11:03:59 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] KEYS: Add missing smp_rmb() primitives to the keyring search
 code
To: jmorris@namei.org
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Mon, 16 Jan 2012 16:03:49 +0000
Message-ID: <20120116160349.10775.92195.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing smp_rmb() primitives to the keyring search code.

When keyring payloads are appended to without replacement (thus using up spare
slots in the key pointer array), an smp_wmb() is issued between the pointer
assignment and the increment of the key count (nkeys).

There should be corresponding read barriers between the read of nkeys and
dereferences of keys[n] when n is dependent on the value of nkeys.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 security/keys/gc.c      |    4 +++-
 security/keys/keyring.c |   22 +++++++++++++++-------
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/security/keys/gc.c b/security/keys/gc.c
index bf4d8da..a42b455 100644
--- a/security/keys/gc.c
+++ b/security/keys/gc.c
@@ -145,7 +145,9 @@ static void key_gc_keyring(struct key *keyring, time_t limit)
 	if (!klist)
 		goto unlock_dont_gc;
 
-	for (loop = klist->nkeys - 1; loop >= 0; loop--) {
+	loop = klist->nkeys;
+	smp_rmb();
+	for (loop--; loop >= 0; loop--) {
 		key = klist->keys[loop];
 		if (test_bit(KEY_FLAG_DEAD, &key->flags) ||
 		    (key->expiry > 0 && key->expiry <= limit))
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 37a7f3b..d605f75 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -319,7 +319,7 @@ key_ref_t keyring_search_aux(key_ref_t keyring_ref,
 	struct key *keyring, *key;
 	key_ref_t key_ref;
 	long err;
-	int sp, kix;
+	int sp, nkeys, kix;
 
 	keyring = key_ref_to_ptr(keyring_ref);
 	possessed = is_key_possessed(keyring_ref);
@@ -380,7 +380,9 @@ descend:
 		goto not_this_keyring;
 
 	/* iterate through the keys in this keyring first */
-	for (kix = 0; kix < keylist->nkeys; kix++) {
+	nkeys = keylist->nkeys;
+	smp_rmb();
+	for (kix = 0; kix < nkeys; kix++) {
 		key = keylist->keys[kix];
 		kflags = key->flags;
 
@@ -421,7 +423,9 @@ descend:
 	/* search through the keyrings nested in this one */
 	kix = 0;
 ascend:
-	for (; kix < keylist->nkeys; kix++) {
+	nkeys = keylist->nkeys;
+	smp_rmb();
+	for (; kix < nkeys; kix++) {
 		key = keylist->keys[kix];
 		if (key->type != &key_type_keyring)
 			continue;
@@ -515,7 +519,7 @@ key_ref_t __keyring_search_one(key_ref_t keyring_ref,
 	struct keyring_list *klist;
 	unsigned long possessed;
 	struct key *keyring, *key;
-	int loop;
+	int nkeys, loop;
 
 	keyring = key_ref_to_ptr(keyring_ref);
 	possessed = is_key_possessed(keyring_ref);
@@ -524,7 +528,9 @@ key_ref_t __keyring_search_one(key_ref_t keyring_ref,
 
 	klist = rcu_dereference(keyring->payload.subscriptions);
 	if (klist) {
-		for (loop = 0; loop < klist->nkeys; loop++) {
+		nkeys = klist->nkeys;
+		smp_rmb();
+		for (loop = 0; loop < nkeys ; loop++) {
 			key = klist->keys[loop];
 
 			if (key->type == ktype &&
@@ -622,7 +628,7 @@ static int keyring_detect_cycle(struct key *A, struct key *B)
 
 	struct keyring_list *keylist;
 	struct key *subtree, *key;
-	int sp, kix, ret;
+	int sp, nkeys, kix, ret;
 
 	rcu_read_lock();
 
@@ -645,7 +651,9 @@ descend:
 
 ascend:
 	/* iterate through the remaining keys in this keyring */
-	for (; kix < keylist->nkeys; kix++) {
+	nkeys = keylist->nkeys;
+	smp_rmb();
+	for (; kix < nkeys; kix++) {
 		key = keylist->keys[kix];
 
 		if (key == A)

