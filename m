Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab0DEUYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 16:24:45 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:36607 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab0DEUYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 16:24:32 -0400
From: Darren Hart <dvhltc@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@redhat.com>,
       Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH 1/6] futex: replace fshared and clockrt with combined flags
Date: Mon,  5 Apr 2010 13:23:54 -0700
Message-Id: <1270499039-23728-2-git-send-email-dvhltc@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com>
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the early days we passed the mmap sem around. That became the
"int fshared" with the fast gup improvements. Then we added
"int clockrt" in places. This patch unifies these options as "flags" and
cleans up various calls which had fshared in their signature but no
longer used it.

V4: Fix an operator precedence bug

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
---
 kernel/futex.c |  215 +++++++++++++++++++++++++++-----------------------------
 1 files changed, 104 insertions(+), 111 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index e7a35f1..ed08cfd 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -69,6 +69,14 @@ int __read_mostly futex_cmpxchg_enabled;
 #define FUTEX_HASHBITS (CONFIG_BASE_SMALL ? 4 : 8)
 
 /*
+ * Futex flags used to encode options to functions and preserve them across
+ * restarts.
+ */
+#define FLAGS_SHARED		0x01
+#define FLAGS_CLOCKRT		0x02
+#define FLAGS_HAS_TIMEOUT	0x04
+
+/*
  * Priority Inheritance state:
  */
 struct futex_pi_state {
@@ -283,7 +291,7 @@ again:
 }
 
 static inline
-void put_futex_key(int fshared, union futex_key *key)
+void put_futex_key(union futex_key *key)
 {
 	drop_futex_key_refs(key);
 }
@@ -878,7 +886,7 @@ double_unlock_hb(struct futex_hash_bucket *hb1, struct futex_hash_bucket *hb2)
 /*
  * Wake up waiters matching bitset queued on this futex (uaddr).
  */
-static int futex_wake(u32 __user *uaddr, int fshared, int nr_wake, u32 bitset)
+static int futex_wake(u32 __user *uaddr, int flags, int nr_wake, u32 bitset)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
@@ -889,7 +897,7 @@ static int futex_wake(u32 __user *uaddr, int fshared, int nr_wake, u32 bitset)
 	if (!bitset)
 		return -EINVAL;
 
-	ret = get_futex_key(uaddr, fshared, &key);
+	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -915,7 +923,7 @@ static int futex_wake(u32 __user *uaddr, int fshared, int nr_wake, u32 bitset)
 	}
 
 	spin_unlock(&hb->lock);
-	put_futex_key(fshared, &key);
+	put_futex_key(&key);
 out:
 	return ret;
 }
@@ -925,7 +933,7 @@ out:
  * to this virtual address:
  */
 static int
-futex_wake_op(u32 __user *uaddr1, int fshared, u32 __user *uaddr2,
+futex_wake_op(u32 __user *uaddr1, int flags, u32 __user *uaddr2,
 	      int nr_wake, int nr_wake2, int op)
 {
 	union futex_key key1 = FUTEX_KEY_INIT, key2 = FUTEX_KEY_INIT;
@@ -935,10 +943,10 @@ futex_wake_op(u32 __user *uaddr1, int fshared, u32 __user *uaddr2,
 	int ret, op_ret;
 
 retry:
-	ret = get_futex_key(uaddr1, fshared, &key1);
+	ret = get_futex_key(uaddr1, flags & FLAGS_SHARED, &key1);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, fshared, &key2);
+	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2);
 	if (unlikely(ret != 0))
 		goto out_put_key1;
 
@@ -970,11 +978,11 @@ retry_private:
 		if (ret)
 			goto out_put_keys;
 
-		if (!fshared)
+		if (!(flags & FLAGS_SHARED))
 			goto retry_private;
 
-		put_futex_key(fshared, &key2);
-		put_futex_key(fshared, &key1);
+		put_futex_key(&key2);
+		put_futex_key(&key1);
 		goto retry;
 	}
 
@@ -1004,9 +1012,9 @@ retry_private:
 
 	double_unlock_hb(hb1, hb2);
 out_put_keys:
-	put_futex_key(fshared, &key2);
+	put_futex_key(&key2);
 out_put_key1:
-	put_futex_key(fshared, &key1);
+	put_futex_key(&key1);
 out:
 	return ret;
 }
@@ -1140,11 +1148,13 @@ static int futex_proxy_trylock_atomic(u32 __user *pifutex,
 
 /**
  * futex_requeue() - Requeue waiters from uaddr1 to uaddr2
- * uaddr1:	source futex user address
- * uaddr2:	target futex user address
- * nr_wake:	number of waiters to wake (must be 1 for requeue_pi)
- * nr_requeue:	number of waiters to requeue (0-INT_MAX)
- * requeue_pi:	if we are attempting to requeue from a non-pi futex to a
+ * @uaddr1:	source futex user address
+ * @flags:	futex flags (FLAGS_SHARED, FLAGS_CLOCKRT, etc.), they must be
+ * 		the same type, no requeueing from private to shared, etc.
+ * @uaddr2:	target futex user address
+ * @nr_wake:	number of waiters to wake (must be 1 for requeue_pi)
+ * @nr_requeue:	number of waiters to requeue (0-INT_MAX)
+ * @requeue_pi:	if we are attempting to requeue from a non-pi futex to a
  * 		pi futex (pi to pi requeue is not supported)
  *
  * Requeue waiters on uaddr1 to uaddr2. In the requeue_pi case, try to acquire
@@ -1154,7 +1164,7 @@ static int futex_proxy_trylock_atomic(u32 __user *pifutex,
  * >=0 - on success, the number of tasks requeued or woken
  *  <0 - on error
  */
-static int futex_requeue(u32 __user *uaddr1, int fshared, u32 __user *uaddr2,
+static int futex_requeue(u32 __user *uaddr1, int flags, u32 __user *uaddr2,
 			 int nr_wake, int nr_requeue, u32 *cmpval,
 			 int requeue_pi)
 {
@@ -1197,10 +1207,10 @@ retry:
 		pi_state = NULL;
 	}
 
-	ret = get_futex_key(uaddr1, fshared, &key1);
+	ret = get_futex_key(uaddr1, flags & FLAGS_SHARED, &key1);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, fshared, &key2);
+	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2);
 	if (unlikely(ret != 0))
 		goto out_put_key1;
 
@@ -1222,11 +1232,11 @@ retry_private:
 			if (ret)
 				goto out_put_keys;
 
-			if (!fshared)
+			if (!(flags & FLAGS_SHARED))
 				goto retry_private;
 
-			put_futex_key(fshared, &key2);
-			put_futex_key(fshared, &key1);
+			put_futex_key(&key2);
+			put_futex_key(&key1);
 			goto retry;
 		}
 		if (curval != *cmpval) {
@@ -1266,8 +1276,8 @@ retry_private:
 			break;
 		case -EFAULT:
 			double_unlock_hb(hb1, hb2);
-			put_futex_key(fshared, &key2);
-			put_futex_key(fshared, &key1);
+			put_futex_key(&key2);
+			put_futex_key(&key1);
 			ret = fault_in_user_writeable(uaddr2);
 			if (!ret)
 				goto retry;
@@ -1275,8 +1285,8 @@ retry_private:
 		case -EAGAIN:
 			/* The owner was exiting, try again. */
 			double_unlock_hb(hb1, hb2);
-			put_futex_key(fshared, &key2);
-			put_futex_key(fshared, &key1);
+			put_futex_key(&key2);
+			put_futex_key(&key1);
 			cond_resched();
 			goto retry;
 		default:
@@ -1358,9 +1368,9 @@ out_unlock:
 		drop_futex_key_refs(&key1);
 
 out_put_keys:
-	put_futex_key(fshared, &key2);
+	put_futex_key(&key2);
 out_put_key1:
-	put_futex_key(fshared, &key1);
+	put_futex_key(&key1);
 out:
 	if (pi_state != NULL)
 		free_pi_state(pi_state);
@@ -1500,7 +1510,7 @@ static void unqueue_me_pi(struct futex_q *q)
  * private futexes.
  */
 static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
-				struct task_struct *newowner, int fshared)
+				struct task_struct *newowner)
 {
 	u32 newtid = task_pid_vnr(newowner) | FUTEX_WAITERS;
 	struct futex_pi_state *pi_state = q->pi_state;
@@ -1593,20 +1603,11 @@ handle_fault:
 	goto retry;
 }
 
-/*
- * In case we must use restart_block to restart a futex_wait,
- * we encode in the 'flags' shared capability
- */
-#define FLAGS_SHARED		0x01
-#define FLAGS_CLOCKRT		0x02
-#define FLAGS_HAS_TIMEOUT	0x04
-
 static long futex_wait_restart(struct restart_block *restart);
 
 /**
  * fixup_owner() - Post lock pi_state and corner case management
  * @uaddr:	user address of the futex
- * @fshared:	whether the futex is shared (1) or not (0)
  * @q:		futex_q (contains pi_state and access to the rt_mutex)
  * @locked:	if the attempt to take the rt_mutex succeeded (1) or not (0)
  *
@@ -1619,8 +1620,7 @@ static long futex_wait_restart(struct restart_block *restart);
  *  0 - success, lock not taken
  * <0 - on error (-EFAULT)
  */
-static int fixup_owner(u32 __user *uaddr, int fshared, struct futex_q *q,
-		       int locked)
+static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
 {
 	struct task_struct *owner;
 	int ret = 0;
@@ -1631,7 +1631,7 @@ static int fixup_owner(u32 __user *uaddr, int fshared, struct futex_q *q,
 		 * did a lock-steal - fix up the PI-state in that case:
 		 */
 		if (q->pi_state->owner != current)
-			ret = fixup_pi_state_owner(uaddr, q, current, fshared);
+			ret = fixup_pi_state_owner(uaddr, q, current);
 		goto out;
 	}
 
@@ -1658,7 +1658,7 @@ static int fixup_owner(u32 __user *uaddr, int fshared, struct futex_q *q,
 		 * lock. Fix the state up.
 		 */
 		owner = rt_mutex_owner(&q->pi_state->pi_mutex);
-		ret = fixup_pi_state_owner(uaddr, q, owner, fshared);
+		ret = fixup_pi_state_owner(uaddr, q, owner);
 		goto out;
 	}
 
@@ -1721,7 +1721,7 @@ static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
  * futex_wait_setup() - Prepare to wait on a futex
  * @uaddr:	the futex userspace address
  * @val:	the expected value
- * @fshared:	whether the futex is shared (1) or not (0)
+ * @flags:	futex flags (FLAGS_SHARED, etc.)
  * @q:		the associated futex_q
  * @hb:		storage for hash_bucket pointer to be returned to caller
  *
@@ -1734,7 +1734,7 @@ static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
  *  0 - uaddr contains val and hb has been locked
  * <1 - -EFAULT or -EWOULDBLOCK (uaddr does not contain val) and hb is unlcoked
  */
-static int futex_wait_setup(u32 __user *uaddr, u32 val, int fshared,
+static int futex_wait_setup(u32 __user *uaddr, u32 val, int flags,
 			   struct futex_q *q, struct futex_hash_bucket **hb)
 {
 	u32 uval;
@@ -1759,7 +1759,7 @@ static int futex_wait_setup(u32 __user *uaddr, u32 val, int fshared,
 	 */
 retry:
 	q->key = FUTEX_KEY_INIT;
-	ret = get_futex_key(uaddr, fshared, &q->key);
+	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q->key);
 	if (unlikely(ret != 0))
 		return ret;
 
@@ -1775,10 +1775,10 @@ retry_private:
 		if (ret)
 			goto out;
 
-		if (!fshared)
+		if (!(flags & FLAGS_SHARED))
 			goto retry_private;
 
-		put_futex_key(fshared, &q->key);
+		put_futex_key(&q->key);
 		goto retry;
 	}
 
@@ -1789,12 +1789,12 @@ retry_private:
 
 out:
 	if (ret)
-		put_futex_key(fshared, &q->key);
+		put_futex_key(&q->key);
 	return ret;
 }
 
-static int futex_wait(u32 __user *uaddr, int fshared,
-		      u32 val, ktime_t *abs_time, u32 bitset, int clockrt)
+static int futex_wait(u32 __user *uaddr, int flags, u32 val, ktime_t *abs_time,
+		      u32 bitset)
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct restart_block *restart;
@@ -1813,8 +1813,9 @@ static int futex_wait(u32 __user *uaddr, int fshared,
 	if (abs_time) {
 		to = &timeout;
 
-		hrtimer_init_on_stack(&to->timer, clockrt ? CLOCK_REALTIME :
-				      CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+		hrtimer_init_on_stack(&to->timer, (flags & FLAGS_CLOCKRT) ?
+				      CLOCK_REALTIME : CLOCK_MONOTONIC,
+				      HRTIMER_MODE_ABS);
 		hrtimer_init_sleeper(to, current);
 		hrtimer_set_expires_range_ns(&to->timer, *abs_time,
 					     current->timer_slack_ns);
@@ -1822,7 +1823,7 @@ static int futex_wait(u32 __user *uaddr, int fshared,
 
 retry:
 	/* Prepare to wait on uaddr. */
-	ret = futex_wait_setup(uaddr, val, fshared, &q, &hb);
+	ret = futex_wait_setup(uaddr, val, flags, &q, &hb);
 	if (ret)
 		goto out;
 
@@ -1842,7 +1843,7 @@ retry:
 	 * victim of a spurious wakeup as well.
 	 */
 	if (!signal_pending(current)) {
-		put_futex_key(fshared, &q.key);
+		put_futex_key(&q.key);
 		goto retry;
 	}
 
@@ -1856,17 +1857,12 @@ retry:
 	restart->futex.val = val;
 	restart->futex.time = abs_time->tv64;
 	restart->futex.bitset = bitset;
-	restart->futex.flags = FLAGS_HAS_TIMEOUT;
-
-	if (fshared)
-		restart->futex.flags |= FLAGS_SHARED;
-	if (clockrt)
-		restart->futex.flags |= FLAGS_CLOCKRT;
+	restart->futex.flags = flags;
 
 	ret = -ERESTART_RESTARTBLOCK;
 
 out_put_key:
-	put_futex_key(fshared, &q.key);
+	put_futex_key(&q.key);
 out:
 	if (to) {
 		hrtimer_cancel(&to->timer);
@@ -1879,7 +1875,6 @@ out:
 static long futex_wait_restart(struct restart_block *restart)
 {
 	u32 __user *uaddr = (u32 __user *)restart->futex.uaddr;
-	int fshared = 0;
 	ktime_t t, *tp = NULL;
 
 	if (restart->futex.flags & FLAGS_HAS_TIMEOUT) {
@@ -1887,11 +1882,9 @@ static long futex_wait_restart(struct restart_block *restart)
 		tp = &t;
 	}
 	restart->fn = do_no_restart_syscall;
-	if (restart->futex.flags & FLAGS_SHARED)
-		fshared = 1;
-	return (long)futex_wait(uaddr, fshared, restart->futex.val, tp,
-				restart->futex.bitset,
-				restart->futex.flags & FLAGS_CLOCKRT);
+
+	return (long)futex_wait(uaddr, restart->futex.flags,
+				restart->futex.val, tp, restart->futex.bitset);
 }
 
 
@@ -1901,8 +1894,8 @@ static long futex_wait_restart(struct restart_block *restart)
  * if there are waiters then it will block, it does PI, etc. (Due to
  * races the kernel might see a 0 value of the futex too.)
  */
-static int futex_lock_pi(u32 __user *uaddr, int fshared,
-			 int detect, ktime_t *time, int trylock)
+static int futex_lock_pi(u32 __user *uaddr, int flags, int detect,
+			 ktime_t *time, int trylock)
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct futex_hash_bucket *hb;
@@ -1925,7 +1918,7 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 	q.requeue_pi_key = NULL;
 retry:
 	q.key = FUTEX_KEY_INIT;
-	ret = get_futex_key(uaddr, fshared, &q.key);
+	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q.key);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -1947,7 +1940,7 @@ retry_private:
 			 * exit to complete.
 			 */
 			queue_unlock(&q, hb);
-			put_futex_key(fshared, &q.key);
+			put_futex_key(&q.key);
 			cond_resched();
 			goto retry;
 		default:
@@ -1977,7 +1970,7 @@ retry_private:
 	 * Fixup the pi_state owner and possibly acquire the lock if we
 	 * haven't already.
 	 */
-	res = fixup_owner(uaddr, fshared, &q, !ret);
+	res = fixup_owner(uaddr, &q, !ret);
 	/*
 	 * If fixup_owner() returned an error, proprogate that.  If it acquired
 	 * the lock, clear our -ETIMEDOUT or -EINTR.
@@ -2001,7 +1994,7 @@ out_unlock_put_key:
 	queue_unlock(&q, hb);
 
 out_put_key:
-	put_futex_key(fshared, &q.key);
+	put_futex_key(&q.key);
 out:
 	if (to)
 		destroy_hrtimer_on_stack(&to->timer);
@@ -2014,10 +2007,10 @@ uaddr_faulted:
 	if (ret)
 		goto out_put_key;
 
-	if (!fshared)
+	if (!(flags & FLAGS_SHARED))
 		goto retry_private;
 
-	put_futex_key(fshared, &q.key);
+	put_futex_key(&q.key);
 	goto retry;
 }
 
@@ -2026,7 +2019,7 @@ uaddr_faulted:
  * This is the in-kernel slowpath: we look up the PI state (if any),
  * and do the rt-mutex unlock.
  */
-static int futex_unlock_pi(u32 __user *uaddr, int fshared)
+static int futex_unlock_pi(u32 __user *uaddr, int flags)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
@@ -2044,7 +2037,7 @@ retry:
 	if ((uval & FUTEX_TID_MASK) != task_pid_vnr(current))
 		return -EPERM;
 
-	ret = get_futex_key(uaddr, fshared, &key);
+	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -2099,14 +2092,14 @@ retry:
 
 out_unlock:
 	spin_unlock(&hb->lock);
-	put_futex_key(fshared, &key);
+	put_futex_key(&key);
 
 out:
 	return ret;
 
 pi_faulted:
 	spin_unlock(&hb->lock);
-	put_futex_key(fshared, &key);
+	put_futex_key(&key);
 
 	ret = fault_in_user_writeable(uaddr);
 	if (!ret)
@@ -2166,7 +2159,7 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
 /**
  * futex_wait_requeue_pi() - Wait on uaddr and take uaddr2
  * @uaddr:	the futex we initially wait on (non-pi)
- * @fshared:	whether the futexes are shared (1) or not (0).  They must be
+ * @flags:	futex flags (FLAGS_SHARED, FLAGS_CLOCKRT, etc.), they must be
  * 		the same type, no requeueing from private to shared, etc.
  * @val:	the expected value of uaddr
  * @abs_time:	absolute timeout
@@ -2204,9 +2197,9 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
  *  0 - On success
  * <0 - On error
  */
-static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
+static int futex_wait_requeue_pi(u32 __user *uaddr, int flags,
 				 u32 val, ktime_t *abs_time, u32 bitset,
-				 int clockrt, u32 __user *uaddr2)
+				 u32 __user *uaddr2)
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct rt_mutex_waiter rt_waiter;
@@ -2221,8 +2214,9 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 
 	if (abs_time) {
 		to = &timeout;
-		hrtimer_init_on_stack(&to->timer, clockrt ? CLOCK_REALTIME :
-				      CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+		hrtimer_init_on_stack(&to->timer, (flags & FLAGS_CLOCKRT) ?
+				      CLOCK_REALTIME : CLOCK_MONOTONIC,
+				      HRTIMER_MODE_ABS);
 		hrtimer_init_sleeper(to, current);
 		hrtimer_set_expires_range_ns(&to->timer, *abs_time,
 					     current->timer_slack_ns);
@@ -2236,7 +2230,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 	rt_waiter.task = NULL;
 
 	key2 = FUTEX_KEY_INIT;
-	ret = get_futex_key(uaddr2, fshared, &key2);
+	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -2246,7 +2240,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 	q.requeue_pi_key = &key2;
 
 	/* Prepare to wait on uaddr. */
-	ret = futex_wait_setup(uaddr, val, fshared, &q, &hb);
+	ret = futex_wait_setup(uaddr, val, flags, &q, &hb);
 	if (ret)
 		goto out_key2;
 
@@ -2274,8 +2268,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 		 */
 		if (q.pi_state && (q.pi_state->owner != current)) {
 			spin_lock(q.lock_ptr);
-			ret = fixup_pi_state_owner(uaddr2, &q, current,
-						   fshared);
+			ret = fixup_pi_state_owner(uaddr2, &q, current);
 			spin_unlock(q.lock_ptr);
 		}
 	} else {
@@ -2294,7 +2287,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 		 * Fixup the pi_state owner and possibly acquire the lock if we
 		 * haven't already.
 		 */
-		res = fixup_owner(uaddr2, fshared, &q, !ret);
+		res = fixup_owner(uaddr2, &q, !ret);
 		/*
 		 * If fixup_owner() returned an error, proprogate that.  If it
 		 * acquired the lock, clear -ETIMEDOUT or -EINTR.
@@ -2325,9 +2318,9 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 	}
 
 out_put_keys:
-	put_futex_key(fshared, &q.key);
+	put_futex_key(&q.key);
 out_key2:
-	put_futex_key(fshared, &key2);
+	put_futex_key(&key2);
 
 out:
 	if (to) {
@@ -2551,58 +2544,58 @@ void exit_robust_list(struct task_struct *curr)
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		u32 __user *uaddr2, u32 val2, u32 val3)
 {
-	int clockrt, ret = -ENOSYS;
+	int ret = -ENOSYS;
 	int cmd = op & FUTEX_CMD_MASK;
-	int fshared = 0;
+	int flags = 0;
 
 	if (!(op & FUTEX_PRIVATE_FLAG))
-		fshared = 1;
+		flags |= FLAGS_SHARED;
 
-	clockrt = op & FUTEX_CLOCK_REALTIME;
-	if (clockrt && cmd != FUTEX_WAIT_BITSET && cmd != FUTEX_WAIT_REQUEUE_PI)
-		return -ENOSYS;
+	if (op & FUTEX_CLOCK_REALTIME) {
+		flags |= FLAGS_CLOCKRT;
+		if (cmd != FUTEX_WAIT_BITSET && cmd != FUTEX_WAIT_REQUEUE_PI)
+			return -ENOSYS;
+	}
 
 	switch (cmd) {
 	case FUTEX_WAIT:
 		val3 = FUTEX_BITSET_MATCH_ANY;
 	case FUTEX_WAIT_BITSET:
-		ret = futex_wait(uaddr, fshared, val, timeout, val3, clockrt);
+		ret = futex_wait(uaddr, flags, val, timeout, val3);
 		break;
 	case FUTEX_WAKE:
 		val3 = FUTEX_BITSET_MATCH_ANY;
 	case FUTEX_WAKE_BITSET:
-		ret = futex_wake(uaddr, fshared, val, val3);
+		ret = futex_wake(uaddr, flags, val, val3);
 		break;
 	case FUTEX_REQUEUE:
-		ret = futex_requeue(uaddr, fshared, uaddr2, val, val2, NULL, 0);
+		ret = futex_requeue(uaddr, flags, uaddr2, val, val2, NULL, 0);
 		break;
 	case FUTEX_CMP_REQUEUE:
-		ret = futex_requeue(uaddr, fshared, uaddr2, val, val2, &val3,
-				    0);
+		ret = futex_requeue(uaddr, flags, uaddr2, val, val2, &val3, 0);
 		break;
 	case FUTEX_WAKE_OP:
-		ret = futex_wake_op(uaddr, fshared, uaddr2, val, val2, val3);
+		ret = futex_wake_op(uaddr, flags, uaddr2, val, val2, val3);
 		break;
 	case FUTEX_LOCK_PI:
 		if (futex_cmpxchg_enabled)
-			ret = futex_lock_pi(uaddr, fshared, val, timeout, 0);
+			ret = futex_lock_pi(uaddr, flags, val, timeout, 0);
 		break;
 	case FUTEX_UNLOCK_PI:
 		if (futex_cmpxchg_enabled)
-			ret = futex_unlock_pi(uaddr, fshared);
+			ret = futex_unlock_pi(uaddr, flags);
 		break;
 	case FUTEX_TRYLOCK_PI:
 		if (futex_cmpxchg_enabled)
-			ret = futex_lock_pi(uaddr, fshared, 0, timeout, 1);
+			ret = futex_lock_pi(uaddr, flags, 0, timeout, 1);
 		break;
 	case FUTEX_WAIT_REQUEUE_PI:
 		val3 = FUTEX_BITSET_MATCH_ANY;
-		ret = futex_wait_requeue_pi(uaddr, fshared, val, timeout, val3,
-					    clockrt, uaddr2);
+		ret = futex_wait_requeue_pi(uaddr, flags, val, timeout, val3,
+					    uaddr2);
 		break;
 	case FUTEX_CMP_REQUEUE_PI:
-		ret = futex_requeue(uaddr, fshared, uaddr2, val, val2, &val3,
-				    1);
+		ret = futex_requeue(uaddr, flags, uaddr2, val, val2, &val3, 1);
 		break;
 	default:
 		ret = -ENOSYS;
-- 
1.6.3.3

