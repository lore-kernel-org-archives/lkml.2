Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab1KDJ2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 05:28:37 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40697 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab1KDJ2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 05:28:36 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: sergey.senozhatsky@gmail.com, bp@alien8.de,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [RFC PATCH 2/4] lockdep: Let register_lock_class() can be called with/without graph_lock
Date: Fri,  4 Nov 2011 17:26:28 +0800
Message-Id: <1320398790-21663-3-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
References: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will be used in later patch which fix some race condition in
lock_set_class().

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 4a16b0a..e7d38fa 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -711,9 +711,13 @@ look_up_lock_class(struct lockdep_map *lock, unsigned int subclass)
  * Register a lock's class in the hash-table, if the class is not present
  * yet. Otherwise we look it up. We cache the result in the lock object
  * itself, so actual lookup of the hash should be once per lock object.
+ *
+ * NOTE: register_lock_class() can be called with/without graph_lock hold
+ *	 depending on @locked. But it will release graph_lock before return.
  */
 static inline struct lock_class *
-register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
+register_lock_class(struct lockdep_map *lock, unsigned int subclass,
+		    int force, int locked)
 {
 	struct lockdep_subclass_key *key;
 	struct list_head *hash_head;
@@ -741,7 +745,7 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
 	hash_head = classhashentry(key);
 
 	raw_local_irq_save(flags);
-	if (!graph_lock()) {
+	if (!locked && !graph_lock()) {
 		raw_local_irq_restore(flags);
 		return NULL;
 	}
@@ -2986,7 +2990,7 @@ void lockdep_init_map(struct lockdep_map *lock, const char *name,
 		return;
 
 	if (subclass)
-		register_lock_class(lock, subclass, 1);
+		register_lock_class(lock, subclass, 1, 0);
 }
 EXPORT_SYMBOL_GPL(lockdep_init_map);
 
@@ -3032,7 +3036,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	 * Not cached?
 	 */
 	if (unlikely(!class)) {
-		class = register_lock_class(lock, subclass, 0);
+		class = register_lock_class(lock, subclass, 0, 0);
 		if (!class)
 			return 0;
 	}
@@ -3276,7 +3280,7 @@ found_it:
 	/* optimizing for lock_set_subclass() */
 	if (key) {
 		lockdep_init_map(lock, name, key, 0);
-		register_lock_class(lock, subclass, 0);
+		register_lock_class(lock, subclass, 0, 0);
 	}
 
 	curr->lockdep_depth = i;
-- 
1.7.5.4

