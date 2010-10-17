Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab0JQPfI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 11:35:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:55859 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757252Ab0JQPfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 11:35:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,342,1283756400"; 
   d="scan'208";a="564741421"
Message-ID: <4CBB17A8.70401@linux.intel.com>
Date: Sun, 17 Oct 2010 08:35:04 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100922 Thunderbird/3.1.4
MIME-Version: 1.0
To: "lkml" <linux-kernel@vger.kernel.org>
CC: =?ISO-8859-1?Q?Matthieu_Fertr=E9?= <matthieu.fertre@kerlabs.com>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] futex: fix errors in nested key ref-counting
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch should address the ref counting issue reported by
Mattieu and Louis as well as one with futex_wait_requeue_pi. I have only
been able to test on a single socket dual core i7 system, I'd like to
see some additional testing.

I have another pair of patches which push the ref-counting out of
unqueue_me() and futex_wait_setup(), but they're exhibiting some
unexpected behavior. I didn't want to hold up this fix on those
cleanups.



>From 7b0ff7743691c07ef9283d63388d9cfc0de736ef Mon Sep 17 00:00:00 2001
From: Darren Hart <dvhart@linux.intel.com>
Date: Fri, 15 Oct 2010 13:18:46 -0700
Subject: [PATCH] futex: fix errors in nested key ref-counting
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

futex_wait() was leaking key references due to futex_wait_setup() acquiring an
additional reference via the queue_lock() routine. The nested key ref-counting
has been masking bugs and complicating code analysis. queue_lock() is only
called with a previously ref-counted key, so remove the additional ref-counting
from the queue_(un)lock() functions.

futex_wait_requeue_pi() drops one key reference too many in unqueue_me_pi().
Remove the key reference handling from unqueue_me_pi(). This was paired with a
queue_lock() in futex_lock_pi(), so the count remains unchanged.

Document remaining nested key ref-counting sites.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Reported-by: Matthieu Fertré<matthieu.fertre@kerlabs.com>
Reported-by: Louis Rilling<louis.rilling@kerlabs.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: John Kacur <jkacur@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/futex.c |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 6a3a5fa..abaafd0 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1363,7 +1363,6 @@ static inline struct futex_hash_bucket *queue_lock(struct futex_q *q)
 {
 	struct futex_hash_bucket *hb;
 
-	get_futex_key_refs(&q->key);
 	hb = hash_futex(&q->key);
 	q->lock_ptr = &hb->lock;
 
@@ -1375,7 +1374,6 @@ static inline void
 queue_unlock(struct futex_q *q, struct futex_hash_bucket *hb)
 {
 	spin_unlock(&hb->lock);
-	drop_futex_key_refs(&q->key);
 }
 
 /**
@@ -1480,8 +1478,6 @@ static void unqueue_me_pi(struct futex_q *q)
 	q->pi_state = NULL;
 
 	spin_unlock(q->lock_ptr);
-
-	drop_futex_key_refs(&q->key);
 }
 
 /*
@@ -1812,7 +1808,10 @@ static int futex_wait(u32 __user *uaddr, int fshared,
 	}
 
 retry:
-	/* Prepare to wait on uaddr. */
+	/*
+	 * Prepare to wait on uaddr. On success, holds hb lock and increments
+	 * q.key refs.
+	 */
 	ret = futex_wait_setup(uaddr, val, fshared, &q, &hb);
 	if (ret)
 		goto out;
@@ -1822,24 +1821,23 @@ retry:
 
 	/* If we were woken (and unqueued), we succeeded, whatever. */
 	ret = 0;
+	/* unqueue_me() drops q.key ref */
 	if (!unqueue_me(&q))
-		goto out_put_key;
+		goto out;
 	ret = -ETIMEDOUT;
 	if (to && !to->task)
-		goto out_put_key;
+		goto out;
 
 	/*
 	 * We expect signal_pending(current), but we might be the
 	 * victim of a spurious wakeup as well.
 	 */
-	if (!signal_pending(current)) {
-		put_futex_key(fshared, &q.key);
+	if (!signal_pending(current))
 		goto retry;
-	}
 
 	ret = -ERESTARTSYS;
 	if (!abs_time)
-		goto out_put_key;
+		goto out;
 
 	restart = &current_thread_info()->restart_block;
 	restart->fn = futex_wait_restart;
@@ -1856,8 +1854,6 @@ retry:
 
 	ret = -ERESTART_RESTARTBLOCK;
 
-out_put_key:
-	put_futex_key(fshared, &q.key);
 out:
 	if (to) {
 		hrtimer_cancel(&to->timer);
@@ -2236,7 +2232,10 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 	q.rt_waiter = &rt_waiter;
 	q.requeue_pi_key = &key2;
 
-	/* Prepare to wait on uaddr. */
+	/* 
+	 * Prepare to wait on uaddr. On success, increments q.key (key1) ref
+	 * count.
+	 */
 	ret = futex_wait_setup(uaddr, val, fshared, &q, &hb);
 	if (ret)
 		goto out_key2;
@@ -2254,7 +2253,9 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 	 * In order for us to be here, we know our q.key == key2, and since
 	 * we took the hb->lock above, we also know that futex_requeue() has
 	 * completed and we no longer have to concern ourselves with a wakeup
-	 * race with the atomic proxy lock acquition by the requeue code.
+	 * race with the atomic proxy lock acquition by the requeue code. The
+	 * futex_requeue dropped our key1 reference and incremented our key2
+	 * reference count.
 	 */
 
 	/* Check if the requeue code acquired the second futex for us. */
-- 
1.7.1
-- 
Darren Hart
Embedded Linux Kernel
