Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab1CXQUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 12:20:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:45191 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab1CXQUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 12:20:00 -0400
Date: Thu, 24 Mar 2011 16:18:57 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, peterz@infradead.org,
        chris.mason@oracle.com, tj@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        chris.mason@oracle.com, torvalds@linux-foundation.org,
        peterz@infradead.org, tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110323153727.GB12003@htj.dyndns.org>
References: <20110323153727.GB12003@htj.dyndns.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] mutex: Separate out mutex_spin()
Message-ID: <tip-d41228115b150ce0f813122a518d8349f68d3b85@git.kernel.org>
Git-Commit-ID: d41228115b150ce0f813122a518d8349f68d3b85
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 24 Mar 2011 16:18:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d41228115b150ce0f813122a518d8349f68d3b85
Gitweb:     http://git.kernel.org/tip/d41228115b150ce0f813122a518d8349f68d3b85
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Thu, 24 Mar 2011 10:41:19 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 24 Mar 2011 11:16:49 +0100

mutex: Separate out mutex_spin()

Separate out mutex_spin() out of __mutex_lock_common(). The fat
comment is converted to docbook function description.

While at it, drop the part of comment which explains that
adaptive spinning considers whether there are pending waiters,
which doesn't match the code.

This patch is to prepare for using adaptive spinning in
mutex_trylock() and doesn't cause any change in behavior.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Mason <chris.mason@oracle.com>
LKML-Reference: <20110323153727.GB12003@htj.dyndns.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/mutex.c |   86 ++++++++++++++++++++++++++++++++------------------------
 1 files changed, 49 insertions(+), 37 deletions(-)

diff --git a/kernel/mutex.c b/kernel/mutex.c
index a5889fb..03465e8 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -126,39 +126,32 @@ void __sched mutex_unlock(struct mutex *lock)
 
 EXPORT_SYMBOL(mutex_unlock);
 
-/*
- * Lock a mutex (possibly interruptible), slowpath:
+/**
+ * mutex_spin - optimistic spinning on mutex
+ * @lock: mutex to spin on
+ *
+ * This function implements optimistic spin for acquisition of @lock when
+ * the lock owner is currently running on a (different) CPU.
+ *
+ * The rationale is that if the lock owner is running, it is likely to
+ * release the lock soon.
+ *
+ * Since this needs the lock owner, and this mutex implementation doesn't
+ * track the owner atomically in the lock field, we need to track it
+ * non-atomically.
+ *
+ * We can't do this for DEBUG_MUTEXES because that relies on wait_lock to
+ * serialize everything.
+ *
+ * CONTEXT:
+ * Preemption disabled.
+ *
+ * RETURNS:
+ * %true if @lock is acquired, %false otherwise.
  */
-static inline int __sched
-__mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
-	       	unsigned long ip)
+static inline bool mutex_spin(struct mutex *lock)
 {
-	struct task_struct *task = current;
-	struct mutex_waiter waiter;
-	unsigned long flags;
-
-	preempt_disable();
-	mutex_acquire(&lock->dep_map, subclass, 0, ip);
-
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
-	/*
-	 * Optimistic spinning.
-	 *
-	 * We try to spin for acquisition when we find that there are no
-	 * pending waiters and the lock owner is currently running on a
-	 * (different) CPU.
-	 *
-	 * The rationale is that if the lock owner is running, it is likely to
-	 * release the lock soon.
-	 *
-	 * Since this needs the lock owner, and this mutex implementation
-	 * doesn't track the owner atomically in the lock field, we need to
-	 * track it non-atomically.
-	 *
-	 * We can't do this for DEBUG_MUTEXES because that relies on wait_lock
-	 * to serialize everything.
-	 */
-
 	for (;;) {
 		struct thread_info *owner;
 
@@ -177,12 +170,8 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		if (owner && !mutex_spin_on_owner(lock, owner))
 			break;
 
-		if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
-			lock_acquired(&lock->dep_map, ip);
-			mutex_set_owner(lock);
-			preempt_enable();
-			return 0;
-		}
+		if (atomic_cmpxchg(&lock->count, 1, 0) == 1)
+			return true;
 
 		/*
 		 * When there's no owner, we might have preempted between the
@@ -190,7 +179,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * we're an RT task that will live-lock because we won't let
 		 * the owner complete.
 		 */
-		if (!owner && (need_resched() || rt_task(task)))
+		if (!owner && (need_resched() || rt_task(current)))
 			break;
 
 		/*
@@ -202,6 +191,29 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		arch_mutex_cpu_relax();
 	}
 #endif
+	return false;
+}
+
+/*
+ * Lock a mutex (possibly interruptible), slowpath:
+ */
+static inline int __sched
+__mutex_lock_common(struct mutex *lock, long state, unsigned int subclass, unsigned long ip)
+{
+	struct task_struct *task = current;
+	struct mutex_waiter waiter;
+	unsigned long flags;
+
+	preempt_disable();
+	mutex_acquire(&lock->dep_map, subclass, 0, ip);
+
+	if (mutex_spin(lock)) {
+		lock_acquired(&lock->dep_map, ip);
+		mutex_set_owner(lock);
+		preempt_enable();
+		return 0;
+	}
+
 	spin_lock_mutex(&lock->wait_lock, flags);
 
 	debug_mutex_lock_common(lock, &waiter);
