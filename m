Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235Ab0D3Sik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:38:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933118Ab0D3RVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:21:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/7] KEYS: Use RCU dereference wrappers in keyring key type
	code
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Fri, 30 Apr 2010 14:32:18 +0100
Message-ID: <20100430133218.2126.28129.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100430133208.2126.56765.stgit@warthog.procyon.org.uk>
References: <20100430133208.2126.56765.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The keyring key type code should use RCU dereference wrappers, even when it
holds the keyring's key semaphore.

Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/keyring.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index d570824..63385af 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -20,6 +20,11 @@
 #include <linux/uaccess.h>
 #include "internal.h"
 
+#define rcu_dereference_locked_keyring(keyring)				\
+	(rcu_dereference_protected(					\
+		(keyring)->payload.subscriptions,			\
+		rwsem_is_locked((struct rw_semaphore *)&(keyring)->sem)))
+
 /*
  * when plumbing the depths of the key tree, this sets a hard limit set on how
  * deep we're willing to go
@@ -201,8 +206,7 @@ static long keyring_read(const struct key *keyring,
 	int loop, ret;
 
 	ret = 0;
-	klist = keyring->payload.subscriptions;
-
+	klist = rcu_dereference_locked_keyring(keyring);
 	if (klist) {
 		/* calculate how much data we could return */
 		qty = klist->nkeys * sizeof(key_serial_t);
@@ -720,8 +724,7 @@ int __key_link(struct key *keyring, struct key *key)
 	}
 
 	/* see if there's a matching key we can displace */
-	klist = keyring->payload.subscriptions;
-
+	klist = rcu_dereference_locked_keyring(keyring);
 	if (klist && klist->nkeys > 0) {
 		struct key_type *type = key->type;
 
@@ -765,8 +768,6 @@ int __key_link(struct key *keyring, struct key *key)
 	if (ret < 0)
 		goto error2;
 
-	klist = keyring->payload.subscriptions;
-
 	if (klist && klist->nkeys < klist->maxkeys) {
 		/* there's sufficient slack space to add directly */
 		atomic_inc(&key->usage);
@@ -867,7 +868,7 @@ int key_unlink(struct key *keyring, struct key *key)
 
 	down_write(&keyring->sem);
 
-	klist = keyring->payload.subscriptions;
+	klist = rcu_dereference_locked_keyring(keyring);
 	if (klist) {
 		/* search the keyring for the key */
 		for (loop = 0; loop < klist->nkeys; loop++)
@@ -958,7 +959,7 @@ int keyring_clear(struct key *keyring)
 		/* detach the pointer block with the locks held */
 		down_write(&keyring->sem);
 
-		klist = keyring->payload.subscriptions;
+		klist = rcu_dereference_locked_keyring(keyring);
 		if (klist) {
 			/* adjust the quota */
 			key_payload_reserve(keyring,
@@ -990,7 +991,9 @@ EXPORT_SYMBOL(keyring_clear);
  */
 static void keyring_revoke(struct key *keyring)
 {
-	struct keyring_list *klist = keyring->payload.subscriptions;
+	struct keyring_list *klist;
+
+	klist = rcu_dereference_locked_keyring(keyring);
 
 	/* adjust the quota */
 	key_payload_reserve(keyring, 0);
@@ -1024,7 +1027,7 @@ void keyring_gc(struct key *keyring, time_t limit)
 
 	down_write(&keyring->sem);
 
-	klist = keyring->payload.subscriptions;
+	klist = rcu_dereference_locked_keyring(keyring);
 	if (!klist)
 		goto no_klist;
 

