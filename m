Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961Ab0EDNRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 09:17:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759143Ab0EDNRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 09:17:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] KEYS: Fix RCU handling in key_gc_keyring()
To: torvalds@osdl.org, akpm@linux-foundation.org, serue@us.ibm.com,
       paulmck@linux.vnet.ibm.com
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 04 May 2010 14:16:10 +0100
Message-ID: <20100504131610.2015.50934.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

key_gc_keyring() needs to either hold the RCU read lock or hold the keyring
semaphore if it's going to scan the keyring's list.  Given that it only needs
to read the key list, and it's doing so under a spinlock, the RCU read lock is
the thing to use.

Furthermore, the RCU check added in e7b0a61b7929632d36cf052d9e2820ef0a9c1bfe is
incorrect as holding the spinlock on key_serial_lock is not grounds for
assuming a keyring's pointer list can be read safely.  Instead, a simple
rcu_dereference() inside of the previously mentioned RCU read lock is what we
want.

Reported-by: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/gc.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/security/keys/gc.c b/security/keys/gc.c
index 1990231..a46e825 100644
--- a/security/keys/gc.c
+++ b/security/keys/gc.c
@@ -77,10 +77,10 @@ static bool key_gc_keyring(struct key *keyring, time_t limit)
 		goto dont_gc;
 
 	/* scan the keyring looking for dead keys */
-	klist = rcu_dereference_check(keyring->payload.subscriptions,
-				      lockdep_is_held(&key_serial_lock));
+	rcu_read_lock();
+	klist = rcu_dereference(keyring->payload.subscriptions);
 	if (!klist)
-		goto dont_gc;
+		goto unlock_dont_gc;
 
 	for (loop = klist->nkeys - 1; loop >= 0; loop--) {
 		key = klist->keys[loop];
@@ -89,11 +89,14 @@ static bool key_gc_keyring(struct key *keyring, time_t limit)
 			goto do_gc;
 	}
 
+unlock_dont_gc:
+	rcu_read_unlock();
 dont_gc:
 	kleave(" = false");
 	return false;
 
 do_gc:
+	rcu_read_unlock();
 	key_gc_cursor = keyring->serial;
 	key_get(keyring);
 	spin_unlock(&key_serial_lock);

