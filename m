Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab0KHVKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 16:10:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:2629 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730Ab0KHVKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 16:10:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,170,1288594800"; 
   d="scan'208";a="624742631"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH V2] futex: replace fshared and clockrt with combined flags
Date: Mon,  8 Nov 2010 13:10:09 -0800
Message-Id: <1289250609-16304-1-git-send-email-dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <alpine.LFD.2.00.1011081745520.2900@localhost6.localdomain6>
References: <alpine.LFD.2.00.1011081745520.2900@localhost6.localdomain6>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the early days we passed the mmap sem around. That became the
"int fshared" with the fast gup improvements. Then we added
"int clockrt" in places. This patch unifies these options as "flags" and
cleans up various calls which had fshared in their signature but no
longer used it.

V2: use unsigned int for the flags.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: John Kacur <jkacur@redhat.com>
---
 kernel/futex.c |  204 +++++++++++++++++++++++++++-----------------------------
 1 files changed, 98 insertions(+), 106 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 40a8777..fd3fbe1 100644
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
@@ -284,7 +292,7 @@ again:
 }
 
 static inline
-void put_futex_key(int fshared, union futex_key *key)
+void put_futex_key(union futex_key *key)
 {
 	drop_futex_key_refs(key);
 }
@@ -870,7 +878,8 @@ double_unlock_hb(struct futex_hash_bucket *hb1, struct futex_hash_bucket *hb2)
 /*
  * Wake up waiters matching bitset queued on this futex (uaddr).
  */
-static int futex_wake(u32 __user *uaddr, int fshared, int nr_wake, u32 bitset)
+static int futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake,
+		      u32 bitset)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
@@ -881,7 +890,7 @@ static int futex_wake(u32 __user *uaddr, int fshared, int nr_wake, u32 bitset)
 	if (!bitset)
 		return -EINVAL;
 
-	ret = get_futex_key(uaddr, fshared, &key);
+	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -907,7 +916,7 @@ static int futex_wake(u32 __user *uaddr, int fshared, int nr_wake, u32 bitset)
 	}
 
 	spin_unlock(&hb->lock);
-	put_futex_key(fshared, &key);
+	put_futex_key(&key);
 out:
 	return ret;
 }
@@ -917,7 +926,7 @@ out:
  * to this virtual address:
  */
 static int
-futex_wake_op(u32 __user *uaddr1, int fshared, u32 __user *uaddr2,
+futex_wake_op(u32 __user *uaddr1, unsigned int flags, u32 __user *uaddr2,
 	      int nr_wake, int nr_wake2, int op)
 {
 	union futex_key key1 = FUTEX_KEY_INIT, key2 = FUTEX_KEY_INIT;
@@ -927,10 +936,10 @@ futex_wake_op(u32 __user *uaddr1, int fshared, u32 __user *uaddr2,
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
 
@@ -962,11 +971,11 @@ retry_private:
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
 
@@ -996,9 +1005,9 @@ retry_private:
 
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
@@ -1148,9 +1157,9 @@ static int futex_proxy_trylock_atomic(u32 __user *pifutex,
  * >=0 - on success, the number of tasks requeued or woken
  *  <0 - on error
  */
-static int futex_requeue(u32 __user *uaddr1, int fshared, u32 __user *uaddr2,
-			 int nr_wake, int nr_requeue, u32 *cmpval,
-			 int requeue_pi)
+static int futex_requeue(u32 __user *uaddr1, unsigned int flags,
+			 u32 __user *uaddr2, int nr_wake, int nr_requeue,
+			 u32 *cmpval, int requeue_pi)
 {
 	union futex_key key1 = FUTEX_KEY_INIT, key2 = FUTEX_KEY_INIT;
 	int drop_count = 0, task_count = 0, ret;
@@ -1191,10 +1200,10 @@ retry:
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
 
@@ -1216,11 +1225,11 @@ retry_private:
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
@@ -1260,8 +1269,8 @@ retry_private:
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
@@ -1269,8 +1278,8 @@ retry_private:
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
@@ -1352,9 +1361,9 @@ out_unlock:
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
@@ -1494,7 +1503,7 @@ static void unqueue_me_pi(struct futex_q *q)
  * private futexes.
  */
 static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
-				struct task_struct *newowner, int fshared)
+				struct task_struct *newowner)
 {
 	u32 newtid = task_pid_vnr(newowner) | FUTEX_WAITERS;
 	struct futex_pi_state *pi_state = q->pi_state;
@@ -1587,20 +1596,11 @@ handle_fault:
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
@@ -1613,8 +1613,7 @@ static long futex_wait_restart(struct restart_block *restart);
  *  0 - success, lock not taken
  * <0 - on error (-EFAULT)
  */
-static int fixup_owner(u32 __user *uaddr, int fshared, struct futex_q *q,
-		       int locked)
+static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
 {
 	struct task_struct *owner;
 	int ret = 0;
@@ -1625,7 +1624,7 @@ static int fixup_owner(u32 __user *uaddr, int fshared, struct futex_q *q,
 		 * did a lock-steal - fix up the PI-state in that case:
 		 */
 		if (q->pi_state->owner != current)
-			ret = fixup_pi_state_owner(uaddr, q, current, fshared);
+			ret = fixup_pi_state_owner(uaddr, q, current);
 		goto out;
 	}
 
@@ -1652,7 +1651,7 @@ static int fixup_owner(u32 __user *uaddr, int fshared, struct futex_q *q,
 		 * lock. Fix the state up.
 		 */
 		owner = rt_mutex_owner(&q->pi_state->pi_mutex);
-		ret = fixup_pi_state_owner(uaddr, q, owner, fshared);
+		ret = fixup_pi_state_owner(uaddr, q, owner);
 		goto out;
 	}
 
@@ -1715,7 +1714,7 @@ static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
  * futex_wait_setup() - Prepare to wait on a futex
  * @uaddr:	the futex userspace address
  * @val:	the expected value
- * @fshared:	whether the futex is shared (1) or not (0)
+ * @flags:	futex flags (FLAGS_SHARED, etc.)
  * @q:		the associated futex_q
  * @hb:		storage for hash_bucket pointer to be returned to caller
  *
@@ -1728,7 +1727,7 @@ static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
  *  0 - uaddr contains val and hb has been locked
  * <1 - -EFAULT or -EWOULDBLOCK (uaddr does not contain val) and hb is unlcoked
  */
-static int futex_wait_setup(u32 __user *uaddr, u32 val, int fshared,
+static int futex_wait_setup(u32 __user *uaddr, u32 val, unsigned int flags,
 			   struct futex_q *q, struct futex_hash_bucket **hb)
 {
 	u32 uval;
@@ -1753,7 +1752,7 @@ static int futex_wait_setup(u32 __user *uaddr, u32 val, int fshared,
 	 */
 retry:
 	q->key = FUTEX_KEY_INIT;
-	ret = get_futex_key(uaddr, fshared, &q->key);
+	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q->key);
 	if (unlikely(ret != 0))
 		return ret;
 
@@ -1769,10 +1768,10 @@ retry_private:
 		if (ret)
 			goto out;
 
-		if (!fshared)
+		if (!(flags & FLAGS_SHARED))
 			goto retry_private;
 
-		put_futex_key(fshared, &q->key);
+		put_futex_key(&q->key);
 		goto retry;
 	}
 
@@ -1783,12 +1782,12 @@ retry_private:
 
 out:
 	if (ret)
-		put_futex_key(fshared, &q->key);
+		put_futex_key(&q->key);
 	return ret;
 }
 
-static int futex_wait(u32 __user *uaddr, int fshared,
-		      u32 val, ktime_t *abs_time, u32 bitset, int clockrt)
+static int futex_wait(u32 __user *uaddr, unsigned int flags, u32 val,
+		      ktime_t *abs_time, u32 bitset)
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct restart_block *restart;
@@ -1807,8 +1806,9 @@ static int futex_wait(u32 __user *uaddr, int fshared,
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
@@ -1819,7 +1819,7 @@ retry:
 	 * Prepare to wait on uaddr. On success, holds hb lock and increments
 	 * q.key refs.
 	 */
-	ret = futex_wait_setup(uaddr, val, fshared, &q, &hb);
+	ret = futex_wait_setup(uaddr, val, flags, &q, &hb);
 	if (ret)
 		goto out;
 
@@ -1852,12 +1852,7 @@ retry:
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
 
@@ -1873,7 +1868,6 @@ out:
 static long futex_wait_restart(struct restart_block *restart)
 {
 	u32 __user *uaddr = restart->futex.uaddr;
-	int fshared = 0;
 	ktime_t t, *tp = NULL;
 
 	if (restart->futex.flags & FLAGS_HAS_TIMEOUT) {
@@ -1881,11 +1875,9 @@ static long futex_wait_restart(struct restart_block *restart)
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
 
 
@@ -1895,8 +1887,8 @@ static long futex_wait_restart(struct restart_block *restart)
  * if there are waiters then it will block, it does PI, etc. (Due to
  * races the kernel might see a 0 value of the futex too.)
  */
-static int futex_lock_pi(u32 __user *uaddr, int fshared,
-			 int detect, ktime_t *time, int trylock)
+static int futex_lock_pi(u32 __user *uaddr, unsigned int flags, int detect,
+			 ktime_t *time, int trylock)
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct futex_hash_bucket *hb;
@@ -1919,7 +1911,7 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 	q.requeue_pi_key = NULL;
 retry:
 	q.key = FUTEX_KEY_INIT;
-	ret = get_futex_key(uaddr, fshared, &q.key);
+	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q.key);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -1941,7 +1933,7 @@ retry_private:
 			 * exit to complete.
 			 */
 			queue_unlock(&q, hb);
-			put_futex_key(fshared, &q.key);
+			put_futex_key(&q.key);
 			cond_resched();
 			goto retry;
 		default:
@@ -1971,7 +1963,7 @@ retry_private:
 	 * Fixup the pi_state owner and possibly acquire the lock if we
 	 * haven't already.
 	 */
-	res = fixup_owner(uaddr, fshared, &q, !ret);
+	res = fixup_owner(uaddr, &q, !ret);
 	/*
 	 * If fixup_owner() returned an error, proprogate that.  If it acquired
 	 * the lock, clear our -ETIMEDOUT or -EINTR.
@@ -1995,7 +1987,7 @@ out_unlock_put_key:
 	queue_unlock(&q, hb);
 
 out_put_key:
-	put_futex_key(fshared, &q.key);
+	put_futex_key(&q.key);
 out:
 	if (to)
 		destroy_hrtimer_on_stack(&to->timer);
@@ -2008,10 +2000,10 @@ uaddr_faulted:
 	if (ret)
 		goto out_put_key;
 
-	if (!fshared)
+	if (!(flags & FLAGS_SHARED))
 		goto retry_private;
 
-	put_futex_key(fshared, &q.key);
+	put_futex_key(&q.key);
 	goto retry;
 }
 
@@ -2020,7 +2012,7 @@ uaddr_faulted:
  * This is the in-kernel slowpath: we look up the PI state (if any),
  * and do the rt-mutex unlock.
  */
-static int futex_unlock_pi(u32 __user *uaddr, int fshared)
+static int futex_unlock_pi(u32 __user *uaddr, unsigned int flags)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
@@ -2038,7 +2030,7 @@ retry:
 	if ((uval & FUTEX_TID_MASK) != task_pid_vnr(current))
 		return -EPERM;
 
-	ret = get_futex_key(uaddr, fshared, &key);
+	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -2093,14 +2085,14 @@ retry:
 
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
@@ -2160,7 +2152,7 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
 /**
  * futex_wait_requeue_pi() - Wait on uaddr and take uaddr2
  * @uaddr:	the futex we initially wait on (non-pi)
- * @fshared:	whether the futexes are shared (1) or not (0).  They must be
+ * @flags:	futex flags (FLAGS_SHARED, FLAGS_CLOCKRT, etc.), they must be
  * 		the same type, no requeueing from private to shared, etc.
  * @val:	the expected value of uaddr
  * @abs_time:	absolute timeout
@@ -2198,9 +2190,9 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
  *  0 - On success
  * <0 - On error
  */
-static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
+static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 				 u32 val, ktime_t *abs_time, u32 bitset,
-				 int clockrt, u32 __user *uaddr2)
+				 u32 __user *uaddr2)
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct rt_mutex_waiter rt_waiter;
@@ -2215,8 +2207,9 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 
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
@@ -2230,7 +2223,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 	rt_waiter.task = NULL;
 
 	key2 = FUTEX_KEY_INIT;
-	ret = get_futex_key(uaddr2, fshared, &key2);
+	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -2243,7 +2236,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 	 * Prepare to wait on uaddr. On success, increments q.key (key1) ref
 	 * count.
 	 */
-	ret = futex_wait_setup(uaddr, val, fshared, &q, &hb);
+	ret = futex_wait_setup(uaddr, val, flags, &q, &hb);
 	if (ret)
 		goto out_key2;
 
@@ -2273,8 +2266,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 		 */
 		if (q.pi_state && (q.pi_state->owner != current)) {
 			spin_lock(q.lock_ptr);
-			ret = fixup_pi_state_owner(uaddr2, &q, current,
-						   fshared);
+			ret = fixup_pi_state_owner(uaddr2, &q, current);
 			spin_unlock(q.lock_ptr);
 		}
 	} else {
@@ -2293,7 +2285,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 		 * Fixup the pi_state owner and possibly acquire the lock if we
 		 * haven't already.
 		 */
-		res = fixup_owner(uaddr2, fshared, &q, !ret);
+		res = fixup_owner(uaddr2, &q, !ret);
 		/*
 		 * If fixup_owner() returned an error, proprogate that.  If it
 		 * acquired the lock, clear -ETIMEDOUT or -EINTR.
@@ -2324,9 +2316,9 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 	}
 
 out_put_keys:
-	put_futex_key(fshared, &q.key);
+	put_futex_key(&q.key);
 out_key2:
-	put_futex_key(fshared, &key2);
+	put_futex_key(&key2);
 
 out:
 	if (to) {
@@ -2551,58 +2543,58 @@ void exit_robust_list(struct task_struct *curr)
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		u32 __user *uaddr2, u32 val2, u32 val3)
 {
-	int clockrt, ret = -ENOSYS;
+	int ret = -ENOSYS;
 	int cmd = op & FUTEX_CMD_MASK;
-	int fshared = 0;
+	unsigned int flags = 0;
 
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
1.7.1

