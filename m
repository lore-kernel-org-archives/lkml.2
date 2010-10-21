Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab0JUOUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:20:25 -0400
Received: from www.tglx.de ([62.245.132.106]:41789 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932286Ab0JUOUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:20:23 -0400
Date: Thu, 21 Oct 2010 16:19:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] futex updates for .6.37
Message-ID: <alpine.LFD.2.00.1010211618330.2418@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest futexes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git futexes-for-linus

Thanks,

	tglx

------------------>
Namhyung Kim (3):
      futex: Change 3rd arg of fetch_robust_entry() to unsigned int*
      futex: Mark restart_block.futex.uaddr[2] __user
      futex: Add lock context annotations

Randy Dunlap (1):
      futex: Fix kernel-doc notation & typos


 include/linux/thread_info.h |    4 ++--
 kernel/futex.c              |   35 +++++++++++++++++++++--------------
 kernel/futex_compat.c       |    2 +-
 3 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index a8cc4e1..c906965 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -23,12 +23,12 @@ struct restart_block {
 		};
 		/* For futex_wait and futex_wait_requeue_pi */
 		struct {
-			u32 *uaddr;
+			u32 __user *uaddr;
 			u32 val;
 			u32 flags;
 			u32 bitset;
 			u64 time;
-			u32 *uaddr2;
+			u32 __user *uaddr2;
 		} futex;
 		/* For nanosleep */
 		struct {
diff --git a/kernel/futex.c b/kernel/futex.c
index 6a3a5fa..9b9fda7 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -91,6 +91,7 @@ struct futex_pi_state {
 
 /**
  * struct futex_q - The hashed futex queue entry, one per waiting task
+ * @list:		priority-sorted list of tasks waiting on this futex
  * @task:		the task waiting on the futex
  * @lock_ptr:		the hash bucket lock
  * @key:		the key the futex is hashed on
@@ -104,7 +105,7 @@ struct futex_pi_state {
  *
  * A futex_q has a woken state, just like tasks have TASK_RUNNING.
  * It is considered woken when plist_node_empty(&q->list) || q->lock_ptr == 0.
- * The order of wakup is always to make the first condition true, then
+ * The order of wakeup is always to make the first condition true, then
  * the second.
  *
  * PI futexes are typically woken before they are removed from the hash list via
@@ -295,7 +296,7 @@ void put_futex_key(int fshared, union futex_key *key)
  * Slow path to fixup the fault we just took in the atomic write
  * access to @uaddr.
  *
- * We have no generic implementation of a non destructive write to the
+ * We have no generic implementation of a non-destructive write to the
  * user address. We know that we faulted in the atomic pagefault
  * disabled section so we can as well avoid the #PF overhead by
  * calling get_user_pages() right away.
@@ -515,7 +516,7 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
 			 */
 			pi_state = this->pi_state;
 			/*
-			 * Userspace might have messed up non PI and PI futexes
+			 * Userspace might have messed up non-PI and PI futexes
 			 */
 			if (unlikely(!pi_state))
 				return -EINVAL;
@@ -736,8 +737,8 @@ static void wake_futex(struct futex_q *q)
 
 	/*
 	 * We set q->lock_ptr = NULL _before_ we wake up the task. If
-	 * a non futex wake up happens on another CPU then the task
-	 * might exit and p would dereference a non existing task
+	 * a non-futex wake up happens on another CPU then the task
+	 * might exit and p would dereference a non-existing task
 	 * struct. Prevent this by holding a reference on p across the
 	 * wake up.
 	 */
@@ -1131,11 +1132,13 @@ static int futex_proxy_trylock_atomic(u32 __user *pifutex,
 
 /**
  * futex_requeue() - Requeue waiters from uaddr1 to uaddr2
- * uaddr1:	source futex user address
- * uaddr2:	target futex user address
- * nr_wake:	number of waiters to wake (must be 1 for requeue_pi)
- * nr_requeue:	number of waiters to requeue (0-INT_MAX)
- * requeue_pi:	if we are attempting to requeue from a non-pi futex to a
+ * @uaddr1:	source futex user address
+ * @fshared:	0 for a PROCESS_PRIVATE futex, 1 for PROCESS_SHARED
+ * @uaddr2:	target futex user address
+ * @nr_wake:	number of waiters to wake (must be 1 for requeue_pi)
+ * @nr_requeue:	number of waiters to requeue (0-INT_MAX)
+ * @cmpval:	@uaddr1 expected value (or %NULL)
+ * @requeue_pi:	if we are attempting to requeue from a non-pi futex to a
  * 		pi futex (pi to pi requeue is not supported)
  *
  * Requeue waiters on uaddr1 to uaddr2. In the requeue_pi case, try to acquire
@@ -1360,6 +1363,7 @@ out:
 
 /* The key must be already stored in q->key. */
 static inline struct futex_hash_bucket *queue_lock(struct futex_q *q)
+	__acquires(&hb->lock)
 {
 	struct futex_hash_bucket *hb;
 
@@ -1373,6 +1377,7 @@ static inline struct futex_hash_bucket *queue_lock(struct futex_q *q)
 
 static inline void
 queue_unlock(struct futex_q *q, struct futex_hash_bucket *hb)
+	__releases(&hb->lock)
 {
 	spin_unlock(&hb->lock);
 	drop_futex_key_refs(&q->key);
@@ -1391,6 +1396,7 @@ queue_unlock(struct futex_q *q, struct futex_hash_bucket *hb)
  * an example).
  */
 static inline void queue_me(struct futex_q *q, struct futex_hash_bucket *hb)
+	__releases(&hb->lock)
 {
 	int prio;
 
@@ -1471,6 +1477,7 @@ retry:
  * and dropped here.
  */
 static void unqueue_me_pi(struct futex_q *q)
+	__releases(q->lock_ptr)
 {
 	WARN_ON(plist_node_empty(&q->list));
 	plist_del(&q->list, &q->list.plist);
@@ -1843,7 +1850,7 @@ retry:
 
 	restart = &current_thread_info()->restart_block;
 	restart->fn = futex_wait_restart;
-	restart->futex.uaddr = (u32 *)uaddr;
+	restart->futex.uaddr = uaddr;
 	restart->futex.val = val;
 	restart->futex.time = abs_time->tv64;
 	restart->futex.bitset = bitset;
@@ -1869,7 +1876,7 @@ out:
 
 static long futex_wait_restart(struct restart_block *restart)
 {
-	u32 __user *uaddr = (u32 __user *)restart->futex.uaddr;
+	u32 __user *uaddr = restart->futex.uaddr;
 	int fshared = 0;
 	ktime_t t, *tp = NULL;
 
@@ -2458,7 +2465,7 @@ retry:
  */
 static inline int fetch_robust_entry(struct robust_list __user **entry,
 				     struct robust_list __user * __user *head,
-				     int *pi)
+				     unsigned int *pi)
 {
 	unsigned long uentry;
 
@@ -2647,7 +2654,7 @@ static int __init futex_init(void)
 	 * of the complex code paths. Also we want to prevent
 	 * registration of robust lists in that case. NULL is
 	 * guaranteed to fault and we get -EFAULT on functional
-	 * implementation, the non functional ones will return
+	 * implementation, the non-functional ones will return
 	 * -ENOSYS.
 	 */
 	curval = cmpxchg_futex_value_locked(NULL, 0, 0);
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index d49afb2..06da4df 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -19,7 +19,7 @@
  */
 static inline int
 fetch_robust_entry(compat_uptr_t *uentry, struct robust_list __user **entry,
-		   compat_uptr_t __user *head, int *pi)
+		   compat_uptr_t __user *head, unsigned int *pi)
 {
 	if (get_user(*uentry, head))
 		return -EFAULT;
