Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab0GIW5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 18:57:20 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:59141 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab0GIW5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 18:57:17 -0400
Message-ID: <4C37A945.2000606@us.ibm.com>
Date: Fri, 09 Jul 2010 15:57:09 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Thunderbird/3.0.5
MIME-Version: 1.0
To: Darren Hart <dvhltc@us.ibm.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
       linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 4/4 V2] futex: convert hash_bucket locks to raw_spinlock_t
References: <1278714780-788-1-git-send-email-dvhltc@us.ibm.com> <1278714780-788-5-git-send-email-dvhltc@us.ibm.com>
In-Reply-To: <1278714780-788-5-git-send-email-dvhltc@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version pulls in the bits mistakenly left in 3/4.


>From 9f8b4faac79518f98131464c2d21a1c64fb841d2 Mon Sep 17 00:00:00 2001
From: Darren Hart <dvhltc@us.ibm.com>
Date: Fri, 9 Jul 2010 16:44:47 -0400
Subject: [PATCH 4/4 V2] futex: convert hash_bucket locks to raw_spinlock_t

The requeue_pi mechanism introduced proxy locking of the rtmutex.  This creates
a scenario where a task can wake-up, not knowing it has been enqueued on an
rtmutex. In order to detect this, the task would have to be able to take either
task->pi_blocked_on->lock->wait_lock and/or the hb->lock.  Unfortunately,
without already holding one of these, the pi_blocked_on variable can change
from NULL to valid or from valid to NULL. Therefor, the task cannot be allowed
to take a sleeping lock after wakeup or it could end up trying to block on two
locks, the second overwriting a valid pi_blocked_on value. This obviously
breaks the pi mechanism.

This patch increases latency, while running the ltp pthread_cond_many test
which Michal reported the bug with, I see double digit hrtimer latencies
(typically only on the first run after boo):

	kernel: hrtimer: interrupt took 75911 ns

This might be addressed by changing the various loops in the futex code to be
incremental, probably at an additional throughput hit. The private hash_bucket
lists discussed in the past could reduce hb->lock contention in some scenarios.
It should be noted that pthread_cond_many is a rather pathological case.

This also introduces problems for plists which want a spinlock_t rather
than a raw_spinlock_t. Any thoughts on how to address this?

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <efault@gmx.de>
---
 kernel/futex.c |   73 ++++++++++++++++++++++++++++++--------------------------
 1 files changed, 39 insertions(+), 34 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 2cd58a2..0ad5a85 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -114,7 +114,7 @@ struct futex_q {
 	struct plist_node list;
 
 	struct task_struct *task;
-	spinlock_t *lock_ptr;
+	raw_spinlock_t *lock_ptr;
 	union futex_key key;
 	struct futex_pi_state *pi_state;
 	struct rt_mutex_waiter *rt_waiter;
@@ -128,7 +128,7 @@ struct futex_q {
  * waiting on a futex.
  */
 struct futex_hash_bucket {
-	spinlock_t lock;
+	raw_spinlock_t lock;
 	struct plist_head chain;
 };
 
@@ -479,7 +479,7 @@ void exit_pi_state_list(struct task_struct *curr)
 		hb = hash_futex(&key);
 		raw_spin_unlock_irq(&curr->pi_lock);
 
-		spin_lock(&hb->lock);
+		raw_spin_lock(&hb->lock);
 
 		raw_spin_lock_irq(&curr->pi_lock);
 		/*
@@ -487,7 +487,7 @@ void exit_pi_state_list(struct task_struct *curr)
 		 * task still owns the PI-state:
 		 */
 		if (head->next != next) {
-			spin_unlock(&hb->lock);
+			raw_spin_unlock(&hb->lock);
 			continue;
 		}
 
@@ -499,7 +499,7 @@ void exit_pi_state_list(struct task_struct *curr)
 
 		rt_mutex_unlock(&pi_state->pi_mutex);
 
-		spin_unlock(&hb->lock);
+		raw_spin_unlock(&hb->lock);
 
 		raw_spin_lock_irq(&curr->pi_lock);
 	}
@@ -860,21 +860,21 @@ static inline void
 double_lock_hb(struct futex_hash_bucket *hb1, struct futex_hash_bucket *hb2)
 {
 	if (hb1 <= hb2) {
-		spin_lock(&hb1->lock);
+		raw_spin_lock(&hb1->lock);
 		if (hb1 < hb2)
-			spin_lock_nested(&hb2->lock, SINGLE_DEPTH_NESTING);
+			raw_spin_lock_nested(&hb2->lock, SINGLE_DEPTH_NESTING);
 	} else { /* hb1 > hb2 */
-		spin_lock(&hb2->lock);
-		spin_lock_nested(&hb1->lock, SINGLE_DEPTH_NESTING);
+		raw_spin_lock(&hb2->lock);
+		raw_spin_lock_nested(&hb1->lock, SINGLE_DEPTH_NESTING);
 	}
 }
 
 static inline void
 double_unlock_hb(struct futex_hash_bucket *hb1, struct futex_hash_bucket *hb2)
 {
-	spin_unlock(&hb1->lock);
+	raw_spin_unlock(&hb1->lock);
 	if (hb1 != hb2)
-		spin_unlock(&hb2->lock);
+		raw_spin_unlock(&hb2->lock);
 }
 
 /*
@@ -896,7 +896,7 @@ static int futex_wake(u32 __user *uaddr, int fshared, int nr_wake, u32 bitset)
 		goto out;
 
 	hb = hash_futex(&key);
-	spin_lock(&hb->lock);
+	raw_spin_lock(&hb->lock);
 	head = &hb->chain;
 
 	plist_for_each_entry_safe(this, next, head, list) {
@@ -916,7 +916,7 @@ static int futex_wake(u32 __user *uaddr, int fshared, int nr_wake, u32 bitset)
 		}
 	}
 
-	spin_unlock(&hb->lock);
+	raw_spin_unlock(&hb->lock);
 	put_futex_key(fshared, &key);
 out:
 	return ret;
@@ -1070,6 +1070,7 @@ void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
 
 	q->lock_ptr = &hb->lock;
 #ifdef CONFIG_DEBUG_PI_LIST
+	/* FIXME: we're converting this to a raw lock... */
 	q->list.plist.spinlock = &hb->lock;
 #endif
 
@@ -1377,14 +1378,14 @@ static inline struct futex_hash_bucket *queue_lock(struct futex_q *q)
 	hb = hash_futex(&q->key);
 	q->lock_ptr = &hb->lock;
 
-	spin_lock(&hb->lock);
+	raw_spin_lock(&hb->lock);
 	return hb;
 }
 
 static inline void
 queue_unlock(struct futex_q *q, struct futex_hash_bucket *hb)
 {
-	spin_unlock(&hb->lock);
+	raw_spin_unlock(&hb->lock);
 	drop_futex_key_refs(&q->key);
 }
 
@@ -1416,11 +1417,12 @@ static inline void queue_me(struct futex_q *q, struct futex_hash_bucket *hb)
 
 	plist_node_init(&q->list, prio);
 #ifdef CONFIG_DEBUG_PI_LIST
+	/* FIXME: we're converting this to a raw_spinlock */
 	q->list.plist.spinlock = &hb->lock;
 #endif
 	plist_add(&q->list, &hb->chain);
 	q->task = current;
-	spin_unlock(&hb->lock);
+	raw_spin_unlock(&hb->lock);
 }
 
 /**
@@ -1436,7 +1438,7 @@ static inline void queue_me(struct futex_q *q, struct futex_hash_bucket *hb)
  */
 static int unqueue_me(struct futex_q *q)
 {
-	spinlock_t *lock_ptr;
+	raw_spinlock_t *lock_ptr;
 	int ret = 0;
 
 	/* In the common case we don't take the spinlock, which is nice. */
@@ -1444,7 +1446,7 @@ retry:
 	lock_ptr = q->lock_ptr;
 	barrier();
 	if (lock_ptr != NULL) {
-		spin_lock(lock_ptr);
+		raw_spin_lock(lock_ptr);
 		/*
 		 * q->lock_ptr can change between reading it and
 		 * spin_lock(), causing us to take the wrong lock.  This
@@ -1459,7 +1461,7 @@ retry:
 		 * we can detect whether we acquired the correct lock.
 		 */
 		if (unlikely(lock_ptr != q->lock_ptr)) {
-			spin_unlock(lock_ptr);
+			raw_spin_unlock(lock_ptr);
 			goto retry;
 		}
 		WARN_ON(plist_node_empty(&q->list));
@@ -1467,7 +1469,7 @@ retry:
 
 		BUG_ON(q->pi_state);
 
-		spin_unlock(lock_ptr);
+		raw_spin_unlock(lock_ptr);
 		ret = 1;
 	}
 
@@ -1491,7 +1493,7 @@ static void unqueue_me_pi(struct futex_q *q)
 	pi_state = q->pi_state;
 	q->pi_state = NULL;
 
-	spin_unlock(q->lock_ptr);
+	raw_spin_unlock(q->lock_ptr);
 	drop_futex_key_refs(&q->key);
 
 	free_pi_state(pi_state);
@@ -1579,11 +1581,11 @@ retry:
 	 * simply return.
 	 */
 handle_fault:
-	spin_unlock(q->lock_ptr);
+	raw_spin_unlock(q->lock_ptr);
 
 	ret = fault_in_user_writeable(uaddr);
 
-	spin_lock(q->lock_ptr);
+	raw_spin_lock(q->lock_ptr);
 
 	/*
 	 * Check if someone else fixed it for us:
@@ -1976,7 +1978,7 @@ retry_private:
 		ret = ret ? 0 : -EWOULDBLOCK;
 	}
 
-	spin_lock(q.lock_ptr);
+	raw_spin_lock(q.lock_ptr);
 	/*
 	 * Fixup the pi_state owner and possibly acquire the lock if we
 	 * haven't already.
@@ -2053,7 +2055,7 @@ retry:
 		goto out;
 
 	hb = hash_futex(&key);
-	spin_lock(&hb->lock);
+	raw_spin_lock(&hb->lock);
 
 	/*
 	 * To avoid races, try to do the TID -> 0 atomic transition
@@ -2102,14 +2104,14 @@ retry:
 	}
 
 out_unlock:
-	spin_unlock(&hb->lock);
+	raw_spin_unlock(&hb->lock);
 	put_futex_key(fshared, &key);
 
 out:
 	return ret;
 
 pi_faulted:
-	spin_unlock(&hb->lock);
+	raw_spin_unlock(&hb->lock);
 	put_futex_key(fshared, &key);
 
 	ret = fault_in_user_writeable(uaddr);
@@ -2257,9 +2259,9 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 	/* Queue the futex_q, drop the hb lock, wait for wakeup. */
 	futex_wait_queue_me(hb, &q, to);
 
-	spin_lock(&hb->lock);
+	raw_spin_lock(&hb->lock);
 	ret = handle_early_requeue_pi_wakeup(hb, &q, &key2, to);
-	spin_unlock(&hb->lock);
+	raw_spin_unlock(&hb->lock);
 	if (ret)
 		goto out_put_keys;
 
@@ -2277,10 +2279,10 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 		 * did a lock-steal - fix up the PI-state in that case.
 		 */
 		if (q.pi_state && (q.pi_state->owner != current)) {
-			spin_lock(q.lock_ptr);
+			raw_spin_lock(q.lock_ptr);
 			ret = fixup_pi_state_owner(uaddr2, &q, current,
 						   fshared);
-			spin_unlock(q.lock_ptr);
+			raw_spin_unlock(q.lock_ptr);
 		}
 	} else {
 		/*
@@ -2293,7 +2295,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 		ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
 		debug_rt_mutex_free_waiter(&rt_waiter);
 
-		spin_lock(q.lock_ptr);
+		raw_spin_lock(q.lock_ptr);
 		/*
 		 * Fixup the pi_state owner and possibly acquire the lock if we
 		 * haven't already.
@@ -2668,8 +2670,11 @@ static int __init futex_init(void)
 		futex_cmpxchg_enabled = 1;
 
 	for (i = 0; i < ARRAY_SIZE(futex_queues); i++) {
-		plist_head_init(&futex_queues[i].chain, &futex_queues[i].lock);
-		spin_lock_init(&futex_queues[i].lock);
+		/* 
+		 * FIXME: plist wants a spinlock, but the hb->lock is a raw_spinlock_t
+		 */
+		plist_head_init(&futex_queues[i].chain, NULL /*&futex_queues[i].lock*/);
+		raw_spin_lock_init(&futex_queues[i].lock);
 	}
 
 	return 0;
-- 
1.7.0.4

