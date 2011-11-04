Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab1KDJ14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 05:27:56 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56756 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab1KDJ1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 05:27:55 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: sergey.senozhatsky@gmail.com, bp@alien8.de,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>, David Rientjes <rientjes@google.com>
Subject: [PATCH 1/4] lockdep: lock_set_subclass() fix
Date: Fri,  4 Nov 2011 17:26:27 +0800
Message-Id: <1320398790-21663-2-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
References: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit f59de89 [lockdep: Clear whole lockdep_map on initialization],
lockdep_init_map() will clear all the struct. But it will break
lock_set_class()/lock_set_subclass(). A typical race condition
is like below:

      CPU A                                   CPU B
lock_set_subclass(lockA);
  lock_set_class(lockA);
    lockdep_init_map(lockA);
      /* lockA->name is cleared */
      memset(lockA);
                                      __lock_acquire(lockA);
                                        /* lockA->class_cache[] is cleared */
                                        register_lock_class(lockA);
                                          look_up_lock_class(lockA);
                                            WARN_ON_ONCE(class->name !=
                                                      lock->name);

      lock->name = name;

Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
---
 include/linux/lockdep.h |    2 +-
 kernel/lockdep.c        |    9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index b6a56e3..182fb2d 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -330,7 +330,7 @@ extern void lock_set_class(struct lockdep_map *lock, const char *name,
 static inline void lock_set_subclass(struct lockdep_map *lock,
 		unsigned int subclass, unsigned long ip)
 {
-	lock_set_class(lock, lock->name, lock->key, subclass, ip);
+	lock_set_class(lock, NULL, NULL, subclass, ip);
 }
 
 extern void lockdep_set_current_reclaim_state(gfp_t gfp_mask);
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index e69434b..4a16b0a 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3247,7 +3247,6 @@ __lock_set_class(struct lockdep_map *lock, const char *name,
 {
 	struct task_struct *curr = current;
 	struct held_lock *hlock, *prev_hlock;
-	struct lock_class *class;
 	unsigned int depth;
 	int i;
 
@@ -3274,9 +3273,11 @@ __lock_set_class(struct lockdep_map *lock, const char *name,
 	return print_unlock_inbalance_bug(curr, lock, ip);
 
 found_it:
-	lockdep_init_map(lock, name, key, 0);
-	class = register_lock_class(lock, subclass, 0);
-	hlock->class_idx = class - lock_classes + 1;
+	/* optimizing for lock_set_subclass() */
+	if (key) {
+		lockdep_init_map(lock, name, key, 0);
+		register_lock_class(lock, subclass, 0);
+	}
 
 	curr->lockdep_depth = i;
 	curr->curr_chain_key = hlock->prev_chain_key;
-- 
1.7.5.4

