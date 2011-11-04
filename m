Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab1KDJ2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 05:28:51 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50489 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab1KDJ2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 05:28:49 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: sergey.senozhatsky@gmail.com, bp@alien8.de,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [RFC PATCH 3/4] lockdep: split lockdep_init_map()
Date: Fri,  4 Nov 2011 17:26:29 +0800
Message-Id: <1320398790-21663-4-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
References: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new one __lockdep_init_map() is introduced which only initialize
the struct. It will be call in later patch in __lock_set_class()
to reduce recursive call to register_lock_class().

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |   25 ++++++++++++++++++-------
 1 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index e7d38fa..3af87ad 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2949,8 +2949,9 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
 /*
  * Initialize a lock instance's lock-class mapping info:
  */
-void lockdep_init_map(struct lockdep_map *lock, const char *name,
-		      struct lock_class_key *key, int subclass)
+static inline int
+__lockdep_init_map(struct lockdep_map *lock, const char *name,
+		 struct lock_class_key *key, int subclass)
 {
 	memset(lock, 0, sizeof(*lock));
 
@@ -2963,7 +2964,7 @@ void lockdep_init_map(struct lockdep_map *lock, const char *name,
 	 */
 	if (DEBUG_LOCKS_WARN_ON(!name)) {
 		lock->name = "NULL";
-		return;
+		return 0;
 	}
 
 	lock->name = name;
@@ -2972,7 +2973,7 @@ void lockdep_init_map(struct lockdep_map *lock, const char *name,
 	 * No key, no joy, we need to hash something.
 	 */
 	if (DEBUG_LOCKS_WARN_ON(!key))
-		return;
+		return 0;
 	/*
 	 * Sanity check, the lock-class key must be persistent:
 	 */
@@ -2982,15 +2983,25 @@ void lockdep_init_map(struct lockdep_map *lock, const char *name,
 		 * What it says above ^^^^^, I suggest you read it.
 		 */
 		DEBUG_LOCKS_WARN_ON(1);
-		return;
+		return 0;
 	}
 	lock->key = key;
 
 	if (unlikely(!debug_locks))
-		return;
+		return 0;
+
+	return 1;
+}
+
+void lockdep_init_map(struct lockdep_map *lock, const char *name,
+		      struct lock_class_key *key, int subclass)
+{
+	int ret;
 
-	if (subclass)
+	ret = __lockdep_init_map(lock, name, key, subclass);
+	if (ret && subclass)
 		register_lock_class(lock, subclass, 1, 0);
+
 }
 EXPORT_SYMBOL_GPL(lockdep_init_map);
 
-- 
1.7.5.4

